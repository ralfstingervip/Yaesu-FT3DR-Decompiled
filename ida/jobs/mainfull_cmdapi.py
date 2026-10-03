r"""MAIN-FULL: recover the DATA-jack external control command API.

Frame assembler sub_6B77E, session gate sub_6B9AC, data-phase pump sub_6BA46,
dispatcher sub_6BAC8 (switch on frame byte [1] = 0xFF1AC9), hex helpers
sub_6CB40/sub_6CB5E/sub_6CC04/sub_6CC4A.  This pass:
  1. fills the two known gaps (W handler 0x6BD0A, N handler 0x6BFB4) and any
     undefined runs in 0x6B700-0x6D120,
  2. parses the cmp.b/beq chains in the dispatcher and the two sub-dispatchers,
  3. dumps annotated disassembly of the whole interpreter,
  4. dumps the TX frame templates 0x6C536-0x6C612 as hex+ASCII,
  5. computes per-handler effect flags (DMA / EEPROM / staging RAM / reset),
so the opcode -> handler -> effect table can be written by hand from evidence.

Runs against the private MAIN_FULL database (H8S, base 0, big-endian).
"""

from __future__ import annotations
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root

import os
import traceback

import ida_auto
import ida_bytes
import ida_funcs
import ida_ua
import idautils
import idc

ROOT = str(_REPO)
OUT = os.path.join(ROOT, "ida", "out", "main-full")
os.makedirs(OUT, exist_ok=True)
LOG_PATH = os.path.join(OUT, "cmdapi_log.txt")
_LOG = []


def log(text):
    _LOG.append(str(text))
    with open(LOG_PATH, "w", encoding="utf-8", newline="\n") as h:
        h.write("\n".join(_LOG) + "\n")


def esc(text):
    return (text or "").replace("\t", " ").replace("\r", " ").replace("\n", " ")


# Known routine / handler starts (from MAIN-IO clone_commands.tsv + dispatcher).
FORCE_STARTS = [
    0x6B700, 0x6B73A, 0x6B74E, 0x6B77E, 0x6B986, 0x6B9AC, 0x6BA46, 0x6BAC8,
    0x6BB4C, 0x6BB6E, 0x6BCD6, 0x6BD0A, 0x6BD3E, 0x6BD6E, 0x6BDE8, 0x6BE28,
    0x6BE34, 0x6BE9C, 0x6BED8, 0x6BEF6, 0x6BF44, 0x6BF6C, 0x6BF8C, 0x6BFB4,
    0x6C048, 0x6C05C, 0x6C10A, 0x6C19A, 0x6C200, 0x6C22A, 0x6C344, 0x6C3DE,
    0x6C402, 0x6C652, 0x6C680, 0x6C686, 0x6C7D8, 0x6C850, 0x6C8E8, 0x6C9BA,
    0x6CB40, 0x6CB5E, 0x6CC04, 0x6CC22, 0x6CC4A,
]

DUMP_LO, DUMP_HI = 0x6B700, 0x6D120
TEMPL_LO, TEMPL_HI = 0x6C536, 0x6C612

RET = ("rts", "rte", "rtsl", "rtel")


def ensure_code(ea):
    """Make ea the head of an instruction if it is currently undefined bytes."""
    fl = ida_bytes.get_flags(ea)
    if ida_bytes.is_code(fl):
        return True
    if ida_bytes.is_unknown(fl) or ida_bytes.is_data(fl):
        ida_bytes.del_items(ea, ida_bytes.DELIT_SIMPLE, 1)
        if ida_ua.create_insn(ea) > 0:
            return True
    return ida_bytes.is_code(ida_bytes.get_flags(ea))


def force_function(ea):
    ensure_code(ea)
    f = ida_funcs.get_func(ea)
    if f is not None and f.start_ea == ea:
        return "exists"
    if ida_funcs.add_func(ea):
        return "added"
    return "failed"


def linear_fill(lo, hi):
    """Conservatively turn undefined runs into instructions across [lo,hi)."""
    made = 0
    ea = lo
    while ea < hi:
        fl = ida_bytes.get_flags(ea)
        if ida_bytes.is_unknown(fl):
            ida_bytes.del_items(ea, ida_bytes.DELIT_SIMPLE, 1)
            n = ida_ua.create_insn(ea)
            if n > 0:
                made += 1
                ea += n
                continue
        ea = max(ea + 1, ida_bytes.get_item_end(ea))
    return made


def func_body_addrs(start):
    """Direct callees (names+addr) and absolute mem addrs >=0xFE0000 touched by
    the function at `start` and one level of its callees."""
    def scan(fstart):
        f = ida_funcs.get_func(fstart)
        if f is None:
            return set(), set()
        callees = set()
        regs = set()
        insn = ida_ua.insn_t()
        ea = f.start_ea
        while ea < f.end_ea:
            if ida_bytes.is_code(ida_bytes.get_flags(ea)) and ida_ua.decode_insn(insn, ea) > 0:
                mnem = (ida_ua.print_insn_mnem(ea) or "").lower()
                for op in insn.ops:
                    if op.type == 0:
                        break
                    if op.type == ida_ua.o_mem:
                        a = op.addr & 0xFFFFFF
                        if a >= 0xFE0000:
                            regs.add(a)
                    if mnem.split(".")[0] in ("jsr", "bsr") and op.type in (
                            ida_ua.o_near, ida_ua.o_far, ida_ua.o_mem):
                        callees.add(op.addr)
                # capture jmp absolute (software reset jmp 0x2050)
                if mnem == "jmp":
                    for op in insn.ops:
                        if op.type in (ida_ua.o_near, ida_ua.o_far, ida_ua.o_mem):
                            callees.add(("jmp", op.addr))
            ea = max(ea + 1, ida_bytes.get_item_end(ea))
        return callees, regs

    callees, regs = scan(start)
    all_regs = set(regs)
    all_callees = set()
    for c in callees:
        if isinstance(c, tuple):
            all_callees.add(c)
            continue
        all_callees.add(c)
        subf = ida_funcs.get_func(c)
        if subf is not None and (subf.end_ea - subf.start_ea) < 2048:
            _, subregs = scan(c)
            all_regs |= subregs
    return all_callees, all_regs


def parse_cmp_beq(start, label):
    """Walk a function; pair every `cmp.b #imm` with the branch that follows it.
    Returns list of (cmp_ea, imm, ascii, branch_mnem, target)."""
    out = []
    f = ida_funcs.get_func(start)
    if f is None:
        log("parse_cmp_beq: no func at %08X (%s)" % (start, label))
        return out
    insn = ida_ua.insn_t()
    ea = f.start_ea
    pending = None  # (cmp_ea, imm)
    while ea < f.end_ea:
        if ida_bytes.is_code(ida_bytes.get_flags(ea)) and ida_ua.decode_insn(insn, ea) > 0:
            mnem = (ida_ua.print_insn_mnem(ea) or "").lower()
            if mnem.startswith("cmp"):
                imm = None
                for op in insn.ops:
                    if op.type == 0:
                        break
                    if op.type == ida_ua.o_imm:
                        imm = op.value & 0xFF
                if imm is not None:
                    pending = (ea, imm)
            elif mnem in ("beq", "bne", "beq.b", "bne.b", "beq.w", "bne.w"):
                tgt = None
                for op in insn.ops:
                    if op.type in (ida_ua.o_near, ida_ua.o_far):
                        tgt = op.addr
                if pending is not None and tgt is not None:
                    imm = pending[1]
                    ch = chr(imm) if 0x20 <= imm < 0x7F else "."
                    out.append((pending[0], imm, ch, mnem, tgt))
                pending = None
            ea = max(ea + ida_bytes.get_item_size(ea), ida_bytes.get_item_end(ea))
        else:
            ea = max(ea + 1, ida_bytes.get_item_end(ea))
    return out


def dump_range(path, lo, hi):
    with open(path, "w", encoding="utf-8", newline="\n") as h:
        ea = lo
        while ea < hi:
            size = max(1, ida_bytes.get_item_end(ea) - ea)
            raw = ida_bytes.get_bytes(ea, min(size, 12)) or b""
            f = ida_funcs.get_func(ea)
            mark = ""
            if f is not None and f.start_ea == ea:
                mark = "   ; ==== %s ====" % (idc.get_func_name(ea) or "")
            line = esc(idc.generate_disasm_line(ea, 0))
            h.write("%08X  %-24s  %s%s\n" % (ea, raw.hex(), line, mark))
            ea += size


def dump_templates(path, lo, hi):
    with open(path, "w", encoding="utf-8", newline="\n") as h:
        ea = lo
        while ea < hi:
            raw = ida_bytes.get_bytes(ea, 16) or b""
            ascii_str = "".join(chr(b) if 0x20 <= b < 0x7F else "." for b in raw)
            h.write("%08X  %-47s  %s\n" % (ea, raw.hex(" "), ascii_str))
            ea += 16


def main():
    ida_auto.auto_wait()

    # ---- 1. fill gaps -----------------------------------------------------
    results = []
    for ea in FORCE_STARTS:
        results.append((ea, force_function(ea)))
    ida_auto.auto_wait()
    made = linear_fill(DUMP_LO, DUMP_HI)
    ida_auto.auto_wait()
    # second pass: functions may now be creatable at post-RET boundaries
    for ea in FORCE_STARTS:
        force_function(ea)
    ida_auto.auto_wait()
    log("force_function results:")
    for ea, r in results:
        log("  %08X %s" % (ea, r))
    log("linear_fill made %d insns in %06X-%06X" % (made, DUMP_LO, DUMP_HI))

    # ---- 2. parse dispatchers --------------------------------------------
    with open(os.path.join(OUT, "cmd_dispatch.tsv"), "w", encoding="utf-8", newline="\n") as h:
        h.write("dispatcher\tcmp_ea\timm\tascii\tbranch\ttarget\ttarget_name\n")
        for start, label in ((0x6BAC8, "main_dispatch"),
                             (0x6BA46, "dataphase_pump"),
                             (0x6B9AC, "session_gate"),
                             (0x6B77E, "frame_assembler")):
            for cmp_ea, imm, ch, br, tgt in parse_cmp_beq(start, label):
                h.write("%s\t%08X\t%02X\t%s\t%s\t%08X\t%s\n"
                        % (label, cmp_ea, imm, ch, br, tgt, idc.get_func_name(tgt) or ""))
    log("cmd_dispatch.tsv written")

    # ---- 3. annotated disasm ---------------------------------------------
    dump_range(os.path.join(OUT, "cmd_disasm.txt"), DUMP_LO, DUMP_HI)
    log("cmd_disasm.txt written %06X-%06X" % (DUMP_LO, DUMP_HI))

    # ---- 4. TX templates --------------------------------------------------
    dump_templates(os.path.join(OUT, "cmd_templates.txt"), TEMPL_LO, TEMPL_HI)
    log("cmd_templates.txt written %06X-%06X" % (TEMPL_LO, TEMPL_HI))

    # ---- 5. per-handler effect flags -------------------------------------
    # addresses of interest for effect classification
    DMA2 = {0xFFFC40, 0xFFFC44, 0xFFFC48, 0xFFFC4C, 0xFFFC54, 0xFFFD22}
    EEPROM = {0x334CA, 0x33532, 0x77D6A, 0x77D90, 0x77DB8}  # bit-banged EEPROM API
    RESET_CALLS = {0x2648, ("jmp", 0x2050), 0x2050}
    handlers = [
        ("frame_asm", 0x6B77E), ("dma_resp@6B91A", 0x6B77E),
        ("session_gate", 0x6B9AC), ("dataphase_pump", 0x6BA46),
        ("dispatch", 0x6BAC8),
        ("V_reset?", 0x6BB4C), ("BB6E", 0x6BB6E),
        ("W_6BD0A", 0x6BD0A), ("BD3E", 0x6BD3E), ("BD6E", 0x6BD6E),
        ("M_BE34", 0x6BE34), ("B_BE9C", 0x6BE9C), ("P_BED8", 0x6BED8),
        ("C_BEF6", 0x6BEF6), ("F_reply_BF44", 0x6BF44), ("E_reply_BF6C", 0x6BF6C),
        ("S_reply_BF8C", 0x6BF8C), ("N_BFB4", 0x6BFB4),
        ("pump_C05C", 0x6C05C), ("H_idx_C10A", 0x6C10A), ("H_C19A", 0x6C19A),
        ("R_C344", 0x6C344), ("W_reply_C3DE", 0x6C3DE), ("aprs_store_C402", 0x6C402),
        ("M_C652", 0x6C652), ("M_C680", 0x6C680), ("F_C686", 0x6C686),
        ("E_C850", 0x6C850), ("S_C8E8", 0x6C8E8),
        ("hex2_CB40", 0x6CB40), ("len_CB5E", 0x6CB5E),
        ("CC04", 0x6CC04), ("CC4A", 0x6CC4A),
    ]
    with open(os.path.join(OUT, "cmd_effects.tsv"), "w", encoding="utf-8", newline="\n") as h:
        h.write("label\tstart\tname\tsize\tdma2\teeprom\treset\tstaging_FEExxx\t"
                "usb_FFEExx\tsci_a_tdr\tcallees\tregs\n")
        for label, start in handlers:
            f = ida_funcs.get_func(start)
            if f is None:
                h.write("%s\t%08X\t(none)\t0\t\t\t\t\t\t\t\t\n" % (label, start))
                continue
            callees, regs = func_body_addrs(start)
            plain_callees = {c for c in callees if not isinstance(c, tuple)}
            jmps = {c for c in callees if isinstance(c, tuple)}
            f_dma = bool(regs & DMA2)
            f_ee = bool(plain_callees & EEPROM)
            f_reset = bool((plain_callees | jmps) & RESET_CALLS)
            f_stage = any(0xFEE000 <= r <= 0xFEEFFF for r in regs)
            f_usb = any(0xFFEE00 <= r <= 0xFFEE53 for r in regs)
            f_scia = 0xFFFE93 in regs
            cnames = ",".join(sorted(
                (idc.get_func_name(c) or ("%08X" % c)) if not isinstance(c, tuple)
                else ("jmp_%08X" % c[1]) for c in callees))
            rnames = ",".join("%06X" % r for r in sorted(regs))
            h.write("%s\t%08X\t%s\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%s\t%s\n"
                    % (label, start, idc.get_func_name(start) or "", f.end_ea - f.start_ea,
                       f_dma, f_ee, f_reset, f_stage, f_usb, f_scia, cnames, rnames))
    log("cmd_effects.tsv written")

    log("DONE")


try:
    main()
except Exception:
    _LOG.append("TRACEBACK\n" + traceback.format_exc())
    with open(LOG_PATH, "w", encoding="utf-8", newline="\n") as h:
        h.write("\n".join(_LOG) + "\n")
idc.qexit(0)
