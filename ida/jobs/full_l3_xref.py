r"""Lane 3: SUB functions reached by call/jump/vector, with start in the
code-bearing window 0xFFED0000-0xFFF50000.  Builds sub-xref.tsv (one row per
function in the window with reached-flag, xref detail, auto-derived purpose,
evidence), counts the totals the score needs, and dumps full disassembly for
the four extension-point clusters so C can be hand-written from them.

    python ida/run_job.py \
        --script ida\jobs\full_l3_xref.py --db FN_SUB_XREF \
        --copy-from ida\db\jobs\SUB_VEC\SUB_VEC.i64
    (then iterate with --reopen)
"""

from __future__ import annotations
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root

import os
import traceback

OUT = str(_REPO / "ida/out/fnindex")
DUMP = os.path.join(OUT, "extpoint_disasm.txt")
STATUS = os.path.join(OUT, "l3_status.txt")
COUNTS = os.path.join(OUT, "l3_counts.txt")
TSV = os.path.join(OUT, "sub-xref.tsv")

BASE = 0xFFC00000
INTB = 0xFFED8A70
EXTB = 0xFFFFFF80
WLO = 0xFFED0000
WHI = 0xFFF50000
PLO = 0x00080000
PHI = 0x00100000

# widest-first peripheral block table (from subvec_periph.py, trimmed to the
# live blocks plus the external-bus / LCD window).
BLOCKS = [
    (0x00080000, 0x00080400, "SYSTEM"),
    (0x00081000, 0x00082000, "BSC"),
    (0x00082000, 0x00082200, "DMAC"),
    (0x00082200, 0x00082400, "DMAC_common"),
    (0x00082400, 0x00082800, "DTC"),
    (0x00082800, 0x00082A00, "EXDMAC_ctl"),
    (0x00082A00, 0x00082B00, "EXDMAC"),
    (0x00083000, 0x00084000, "BSC_CS"),
    (0x00087000, 0x00087100, "ICU_IR"),
    (0x00087100, 0x00087200, "ICU_DTCER"),
    (0x00087200, 0x00087300, "ICU_IER"),
    (0x00087300, 0x00087400, "ICU_IPR"),
    (0x00087400, 0x00087800, "ICU_misc"),
    (0x00087800, 0x00088000, "ICU_other"),
    (0x00088000, 0x00088020, "CMT"),
    (0x00088040, 0x00088050, "R12DA"),
    (0x00088100, 0x00088170, "TPU"),
    (0x00088200, 0x00088280, "TMR"),
    (0x00089000, 0x00089200, "S12AD0"),
    (0x0008A000, 0x0008A020, "SCI0"),
    (0x0008A040, 0x0008A060, "SCI2"),
    (0x0008A060, 0x0008A080, "SCI3"),
    (0x0008AC00, 0x0008B000, "SDHI"),
    (0x0008B000, 0x0008B100, "CAC"),
    (0x0008C000, 0x0008C100, "PORT"),
    (0x0008C100, 0x0008C200, "MPC"),
    (0x0008C400, 0x0008C500, "RTC"),
    (0x000A0000, 0x000A0400, "USB0"),
    (0x000C1200, 0x000C2000, "MTU3"),
    (0x000D0100, 0x000D0180, "RSPI"),
]

# extension-point clusters to dump full disasm for.
WANT = [
    ("menu_walker", 0xFFF0964A),
    ("menu_settings_scr", 0xFFF08201),
    ("sci0_rxi0", 0xFFEDB7E7),
    ("sci0_txi0", 0xFFEDB857),
    ("grpbl0_disp", 0xFFEDBCDD),
    ("sci0_sub_8A5", 0xFFEDB8A5),
    ("sci0_sub_7B6", 0xFFEDB7B6),
    ("sdhi_bufacc", 0xFFF33AA7),
    ("sdhi_carddet", 0xFFF32A29),
    ("dmac3_end", 0xFFF32EA4),
    ("exdmac_isr", 0xFFEF1E28),
    ("exdmac_dda", 0xFFEF1DDA),
    ("exdmac_dar", 0xFFEF1F90),
]


def log(t):
    with open(STATUS, "a", encoding="utf-8", newline="\n") as h:
        h.write(t + "\n")


def esc(t):
    return (t or "").replace("\t", " ").replace("\r", " ").replace("\n", " ")


def block_of(addr):
    for lo, hi, name in BLOCKS:
        if lo <= addr < hi:
            return name
    return None


def main():
    import ida_bytes
    import ida_funcs
    import ida_ua
    import ida_xref
    import idautils
    import idc

    o_reg, o_mem, o_phrase, o_displ, o_imm = 1, 2, 3, 4, 5
    o_near, o_far = 7, 6

    # -------- vector target set (INTB 256 + EXTB 32) --------
    vec_targets = set()
    for i in range(256):
        t = ida_bytes.get_dword(INTB + 4 * i)
        if t and t != 0xFFFFFFFF:
            vec_targets.add(t)
    for i in range(32):
        t = ida_bytes.get_dword(EXTB + 4 * i)
        if t and t != 0xFFFFFFFF:
            vec_targets.add(t)
    log("vector targets %d" % len(vec_targets))

    funcs = list(idautils.Functions())
    log("total functions %d" % len(funcs))
    fstart = set(funcs)

    def has_calljump(ea):
        """incoming call or jump xref (not ordinary flow). returns
        (callers, has_call, has_jump)."""
        callers = []
        has_call = False
        has_jump = False
        xr = ida_xref.xrefblk_t()
        ok = xr.first_to(ea, ida_xref.XREF_ALL)
        while ok:
            if xr.iscode and xr.type in (
                    ida_xref.fl_CF, ida_xref.fl_CN,
                    ida_xref.fl_JF, ida_xref.fl_JN):
                callers.append((xr.frm, xr.type))
                if xr.type in (ida_xref.fl_CF, ida_xref.fl_CN):
                    has_call = True
                else:
                    has_jump = True
            ok = xr.next_to()
        return callers, has_call, has_jump

    def scan_func(f):
        """constant-prop peripheral scan + string/callee collection."""
        regs = {}
        periph = {}       # block -> set(reg offsets/text)
        strings = []
        callees = set()
        ea = f.start_ea
        icode = 0
        ibytes = 0
        while ea != idc.BADADDR and ea < f.end_ea:
            fl = ida_bytes.get_flags(ea)
            if not ida_bytes.is_code(fl):
                ea = idc.next_head(ea, f.end_ea)
                regs = {}
                continue
            sz = idc.get_item_size(ea)
            icode += 1
            ibytes += sz
            insn = ida_ua.insn_t()
            if not ida_ua.decode_insn(insn, ea):
                ea = idc.next_head(ea, f.end_ea)
                continue
            mnem = idc.print_insn_mnem(ea) or ""
            for n in range(6):
                op = insn.ops[n]
                if op.type == 0:
                    break
                if op.type == o_imm:
                    v = op.value & 0xFFFFFFFF
                    if PLO <= v < PHI:
                        b = block_of(v)
                        if b:
                            periph.setdefault(b, set()).add(v)
                    elif (WLO <= v < 0x100000000) or (0xFFC00000 <= v < WLO):
                        s = read_str(v, ida_bytes)
                        if s:
                            strings.append(s)
                elif op.type in (o_mem, o_far, o_near):
                    v = op.addr & 0xFFFFFFFF
                    if PLO <= v < PHI:
                        b = block_of(v)
                        if b:
                            periph.setdefault(b, set()).add(v)
                elif op.type in (o_phrase, o_displ):
                    r = op.reg
                    disp = op.value & 0xFFFFFFFF
                    if r in regs:
                        v = (regs[r] + disp) & 0xFFFFFFFF
                        if PLO <= v < PHI:
                            b = block_of(v)
                            if b:
                                periph.setdefault(b, set()).add(v)
            # callee names
            if mnem in ("bsr", "jsr"):
                tgt = insn.ops[0].addr if insn.ops[0].type in (o_near, o_far) else None
                if tgt is None and insn.ops[0].type == o_mem:
                    tgt = insn.ops[0].addr
                if tgt and tgt in fstart:
                    callees.add(tgt)
            # register tracking
            if mnem.startswith("mov") and insn.ops[0].type == o_imm and insn.ops[1].type == o_reg and insn.ops[2].type == 0:
                regs[insn.ops[1].reg] = insn.ops[0].value & 0xFFFFFFFF
            elif mnem == "add" and insn.ops[0].type == o_imm and insn.ops[1].type == o_reg and insn.ops[2].type == 0:
                r = insn.ops[1].reg
                if r in regs:
                    regs[r] = (regs[r] + (insn.ops[0].value & 0xFFFFFFFF)) & 0xFFFFFFFF
            else:
                for n in range(6):
                    op = insn.ops[n]
                    if op.type == 0:
                        break
                    if op.type == o_reg and n == (1 if insn.ops[1].type != 0 else 0):
                        regs.pop(op.reg, None)
                if insn.ops[2].type == o_reg:
                    regs.pop(insn.ops[2].reg, None)
                if mnem in ("bsr", "jsr", "bra", "jmp") or mnem.startswith(("rts", "rte")):
                    regs = {}
            ea = idc.next_head(ea, f.end_ea)
        return periph, strings, callees, icode, ibytes

    def read_str(addr, ida_bytes):
        raw = ida_bytes.get_bytes(addr, 40)
        if not raw:
            return None
        s = bytearray()
        for c in raw:
            if c == 0:
                break
            if 0x20 <= c < 0x7F:
                s.append(c)
            else:
                return None
        if len(s) >= 4:
            return s.decode("ascii")
        return None

    # SCI/SDHI register naming for purposes
    def reg_name(b, v):
        if b == "SCI0":
            m = {0: "SMR", 1: "BRR", 2: "SCR", 3: "TDR", 4: "SSR", 5: "RDR"}
            return m.get(v - 0x0008A000, "+%x" % (v - 0x0008A000))
        return "%08X" % v

    def purpose_of(ea, periph, strings, callees):
        parts = ["@%08X" % ea]
        ev = []
        # peripherals
        if periph:
            names = sorted(periph, key=lambda k: -len(periph[k]))
            top = names[:4]
            desc = []
            for b in top:
                regs = sorted(periph[b])
                if b in ("SCI0",) and len(regs) <= 6:
                    desc.append("%s(%s)" % (b, "/".join(reg_name(b, r) for r in regs)))
                else:
                    desc.append("%s x%d" % (b, len(regs)))
            parts.append("touches " + ", ".join(desc))
            ev.append("periph:" + ",".join("%08X" % r for b in top for r in sorted(periph[b]))[:120])
        # strings
        us = []
        seen = set()
        for s in strings:
            if s not in seen:
                seen.add(s)
                us.append(s)
        if us:
            parts.append("refs " + "; ".join('"%s"' % s for s in us[:3]))
            ev.append("str:" + "|".join(us[:3])[:120])
        # callees
        if callees:
            cs = sorted(callees)
            parts.append("calls %d (%s%s)" % (
                len(cs), ",".join("%08X" % c for c in cs[:4]),
                ".." if len(cs) > 4 else ""))
        if not periph and not us:
            if callees:
                parts.append("[med] wrapper/dispatch")
            else:
                parts.append("[low] leaf/util")
        return " | ".join(parts), "; ".join(ev)

    # -------- main sweep over window functions --------
    rows = []
    win_funcs = [ea for ea in funcs if WLO <= ea < WHI]
    log("functions with start in window %d" % len(win_funcs))

    total_reached = 0
    reached_calljump = 0
    reached_vec_only = 0
    dpurpose = 0
    total_ibytes = 0
    calljump_all_window = 0
    call_only_reached = 0
    jump_reached = 0

    for ea in win_funcs:
        f = ida_funcs.get_func(ea)
        if f is None:
            continue
        callers, has_call, has_jump = has_calljump(ea)
        is_cj = len(callers) > 0
        if has_call:
            call_only_reached += 1
        if has_jump:
            jump_reached += 1
        is_vec = ea in vec_targets
        reached = is_cj or is_vec
        if is_cj:
            calljump_all_window += 1
        if not reached:
            continue
        periph, strings, callees, icode, ibytes = scan_func(f)
        total_reached += 1
        total_ibytes += ibytes
        if is_cj:
            reached_calljump += 1
        if is_vec and not is_cj:
            reached_vec_only += 1
        xref_kinds = []
        if is_vec:
            xref_kinds.append("vector")
        if is_cj:
            xref_kinds.append("call/jump(%d)" % len(callers))
        purpose, ev = purpose_of(ea, periph, strings, callees)
        if ("@%08X" % ea) in purpose:
            dpurpose += 1
        rows.append((ea, f.end_ea, "yes", ";".join(xref_kinds), purpose, ev))

    os.makedirs(OUT, exist_ok=True)
    with open(TSV, "w", encoding="utf-8", newline="\n") as h:
        h.write("start\tend\tvalidated\txref\tpurpose\tevidence\n")
        for ea, end, val, xref, purpose, ev in sorted(rows):
            h.write("%08X\t%08X\t%s\t%s\t%s\t%s\n" % (
                ea, end, val, esc(xref), esc(purpose), esc(ev)))
    log("wrote %s rows %d" % (TSV, len(rows)))

    with open(COUNTS, "w", encoding="utf-8", newline="\n") as h:
        h.write("window 0xFFED0000-0xFFF50000\n")
        h.write("total functions in DB: %d\n" % len(funcs))
        h.write("functions with start in window: %d\n" % len(win_funcs))
        h.write("T_fn_subxref (reached by call/jump/vector, in window): %d\n" % total_reached)
        h.write("  of which reached by call/jump: %d\n" % reached_calljump)
        h.write("  of which vector-only (no call/jump): %d\n" % reached_vec_only)
        h.write("call/jump-reached in window (compare to doc02 1396): %d\n" % calljump_all_window)
        h.write("  reached by CALL (fl_CN/CF): %d\n" % call_only_reached)
        h.write("  reached by JUMP (fl_JN/JF): %d\n" % jump_reached)
        h.write("D_fn_subxref (non-empty purpose citing start addr): %d\n" % dpurpose)
        h.write("instruction bytes inside reached window functions: %d\n" % total_ibytes)
        h.write("vector targets total (INTB+EXTB, in-image): %d\n" % len(vec_targets))
        vt_in_win = sum(1 for t in vec_targets if WLO <= t < WHI)
        h.write("vector targets with start in window: %d\n" % vt_in_win)
    log("wrote counts")

    # -------- dump extension-point clusters --------
    with open(DUMP, "w", encoding="utf-8", newline="\n") as h:
        for tag, ea in WANT:
            f = ida_funcs.get_func(ea)
            h.write("\n===== %s  %08X =====\n" % (tag, ea))
            if f is None:
                h.write("  (no function at this address; nearest: %08X)\n"
                        % (idc.get_func_attr(ea, idc.FUNCATTR_START)))
                continue
            h.write("  start %08X end %08X size %d file_off %06X\n" % (
                f.start_ea, f.end_ea, f.end_ea - f.start_ea, f.start_ea - BASE))
            cl, _hc, _hj = has_calljump(f.start_ea)
            h.write("  callers: %s\n" % ", ".join("%08X" % c for c, _ in cl[:12]))
            cur = f.start_ea
            while cur != idc.BADADDR and cur < f.end_ea:
                line = idc.generate_disasm_line(cur, 0) or ""
                h.write("  %08X  %s\n" % (cur, esc(line)))
                cur = idc.next_head(cur, f.end_ea)
    log("wrote extpoint_disasm.txt")
    log("done")


if True:
    os.makedirs(OUT, exist_ok=True)
    with open(STATUS, "w", encoding="utf-8", newline="\n") as _h:
        _h.write("start\n")
    try:
        main()
    except Exception:
        with open(os.path.join(OUT, "l3_traceback.txt"), "w", encoding="utf-8", newline="\n") as _h:
            _h.write(traceback.format_exc())
        log("EXCEPTION")
    import idc as _idc
    _idc.qexit(0)
