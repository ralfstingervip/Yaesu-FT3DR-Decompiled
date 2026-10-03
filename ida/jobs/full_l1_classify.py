r"""Lane 1: MAIN functions below 0x038000 -- recovery, validation, purpose.

Seeded --copy-from ida\db\jobs\MAIN_FULL\MAIN_FULL.i64 into DB FN_MAIN_LO.

Stage A  conservative recovery of missed code below the cut:
           * call/jump/vector targets < CUT that are not yet functions
           * undefined runs < CUT that decode cleanly with a real prologue+return
Stage B  classify every function with start < CUT:
           * validated test, per-function decode stats, registers, callees,
             settings-byte writers, string refs, dispatch idioms
           * a real purpose line, confidence marked when weak
Stage C  byte accounting below the cut; write main-low.tsv + counts log.

Outputs under ida\out\fnindex\ :
  main-low.tsv        start,end,validated,xref,purpose,evidence
  main-low-extra.tsv  callees / regs / strings detail per function
  l1_counts.txt       the integers the score needs
  l1_log.txt          run log / traceback
"""

from __future__ import annotations
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root

import collections
import os
import traceback

import ida_auto
import ida_bytes
import ida_funcs
import ida_ida
import ida_segment
import ida_ua
import ida_xref
import idautils
import idc

ROOT = str(_REPO)
OUT = os.path.join(ROOT, "ida", "out", "fnindex")
os.makedirs(OUT, exist_ok=True)
LOG_PATH = os.path.join(OUT, "l1_log.txt")
_LOG = []
CUT = 0x038000

RET = ("rts", "rte", "rtsl")
CALL = ("jsr", "bsr")
BRANCH = ("bra", "beq", "bne", "bcs", "bcc", "bhi", "bls", "bmi", "bpl", "bvs",
          "bvc", "bge", "blt", "bgt", "ble", "bt", "bf")
JMP = ("jmp",)
ODD = ("stc", "ldc", "eepmov", "trapa", "andc", "orc", "xorc", "tas", "mac",
       "clrmac", "ldmac", "stmac", "sleep")
PROLOGUE = ("push", "stm", "mov")  # mov only counts if dest is @-sp; checked below

# --- peripheral address map (true 24-bit effective addresses) --------------
def classify_reg(a):
    if 0xFFEE00 <= a <= 0xFFEE53:
        return "USB"
    if 0xFFF610 <= a <= 0xFFF617:
        return "SCI-D(500k/IPC)"
    if 0xFFFE90 <= a <= 0xFFFE97:
        return "SCI-A(DATA-jack)"
    if 0xFFFF60 <= a <= 0xFFFF67:
        return "SCI-B"
    if 0xFFFF88 <= a <= 0xFFFF8F:
        return "SCI-C(DSP)"
    if 0xFFFF90 <= a <= 0xFFFFA1:
        return "A/D"
    if 0xFFFC00 <= a <= 0xFFFC5F or 0xFFFD20 <= a <= 0xFFFD22:
        return "DMAC"
    if (0xFFFFC0 <= a <= 0xFFFFFF or 0xFFFEC0 <= a <= 0xFFFECB
            or 0xFFFEE0 <= a <= 0xFFFEE7 or 0xFFFEF0 <= a <= 0xFFFEF8
            or a in (0xFFFD68, 0xFFFD6A)):
        return "timer"
    if 0xFFFB80 <= a <= 0xFFFBCF:
        return "port-dir"
    if 0xFFFF00 <= a <= 0xFFFF5F:
        return "port-io"
    if 0xFFFDC2 <= a <= 0xFFFDCC:
        return "bus/clk-cfg"
    return None


def is_ram_config(a):
    # writable RAM used for settings / config vars
    return (0xFF8000 <= a <= 0xFFBFFF) or (0xFEE000 <= a <= 0xFF72FF)


def log(text):
    _LOG.append(text)
    with open(LOG_PATH, "w", encoding="utf-8", newline="\n") as h:
        h.write("\n".join(_LOG) + "\n")


def esc(t):
    return (t or "").replace("\t", " ").replace("\n", " ").replace("\r", " ")


WRITE_MNEMS = ("mov", "bset", "bclr", "bst", "bnot")


def scan(func):
    st = collections.Counter()
    regs = collections.Counter()          # reg-class -> hits
    reg_addrs = set()
    callees = set()
    ram_writes = set()
    data_refs = set()
    has_indirect_jmp = False
    insn = ida_ua.insn_t()
    first_mnem = None
    ea = func.start_ea
    while ea < func.end_ea:
        fl = ida_bytes.get_flags(ea)
        if ida_bytes.is_code(fl) and ida_ua.decode_insn(insn, ea) > 0:
            mnem = (ida_ua.print_insn_mnem(ea) or "").lower()
            base_m = mnem.split(".")[0]
            if first_mnem is None:
                first_mnem = mnem
            st["insn"] += 1
            if base_m in RET:
                st["ret"] += 1
            elif base_m in CALL:
                st["call"] += 1
            elif base_m in BRANCH:
                st["branch"] += 1
            elif base_m in JMP:
                st["branch"] += 1
            if base_m in ODD:
                st["odd"] += 1
            if base_m == "eepmov":
                st["eepmov"] += 1
            if not mnem:
                st["bad"] += 1
            # indirect jmp/jsr through register -> dispatch idiom
            for op in insn.ops:
                if op.type == 0:
                    break
                if base_m in ("jmp", "jsr") and op.type in (ida_ua.o_phrase, ida_ua.o_displ, ida_ua.o_reg):
                    has_indirect_jmp = True
            # operands
            for idx, op in enumerate(insn.ops):
                if op.type == 0:
                    break
                if op.type == ida_ua.o_mem:
                    a24 = op.addr & 0xFFFFFF
                    rc = classify_reg(a24)
                    if rc:
                        regs[rc] += 1
                        reg_addrs.add(a24)
                    # data ref (for strings) -- destination in low ROM
                    if a24 < CUT * 2:
                        data_refs.add(a24)
                    # settings writer: write mnem with mem dest operand 0
                    if base_m in WRITE_MNEMS and idx == 0 and is_ram_config(a24):
                        ram_writes.add(a24)
                if base_m in CALL and op.type in (ida_ua.o_near, ida_ua.o_far, ida_ua.o_mem):
                    callees.add(op.addr & 0xFFFFFF)
        ea = max(ea + 1, ida_bytes.get_item_end(ea))
    return st, regs, reg_addrs, callees, ram_writes, data_refs, first_mnem, has_indirect_jmp


def plausible_prologue(func, first_mnem):
    """H8S callee-saved prologue or a clean leaf entry."""
    if first_mnem is None:
        return False
    base_m = first_mnem.split(".")[0]
    if base_m in ("push", "stm"):
        return True
    # mov.l erN,@-sp  /  mov to @-er7
    insn = ida_ua.insn_t()
    if ida_ua.decode_insn(insn, func.start_ea) > 0:
        line = (idc.generate_disasm_line(func.start_ea, 0) or "").lower()
        if "@-sp" in line or "@-er7" in line:
            return True
    # sub.w/#imm,sp frame setup
    if base_m == "sub":
        line = (idc.generate_disasm_line(func.start_ea, 0) or "").lower()
        if "sp" in line or "er7" in line:
            return True
    return False


def main():
    ida_auto.auto_wait()
    seg = ida_segment.get_first_seg()
    base = seg.start_ea

    # ----- snapshot pre-existing function starts (the 3899 list is on disk;
    #       but the seeded DB already carries them, so remember starts now) --
    pre_starts = set(idautils.Functions())
    log("seeded functions total %d" % len(pre_starts))

    # ================= Stage A: conservative recovery < CUT ================
    added = 0
    # A1: call / jump / vector code-xref targets that are not functions yet
    targets = set()
    for start in list(pre_starts):
        f = ida_funcs.get_func(start)
        if f is None:
            continue
        insn = ida_ua.insn_t()
        ea = f.start_ea
        while ea < f.end_ea:
            if ida_bytes.is_code(ida_bytes.get_flags(ea)) and ida_ua.decode_insn(insn, ea) > 0:
                m = (ida_ua.print_insn_mnem(ea) or "").lower().split(".")[0]
                if m in ("jsr", "bsr", "jmp"):
                    for op in insn.ops:
                        if op.type == 0:
                            break
                        if op.type in (ida_ua.o_near, ida_ua.o_far, ida_ua.o_mem):
                            t = op.addr
                            if base <= t < CUT:
                                targets.add(t)
            ea = max(ea + 1, ida_bytes.get_item_end(ea))
    # vector table slots < CUT
    for i in range(256):
        v = ida_bytes.get_dword(base + i * 4)
        if base <= v < CUT:
            targets.add(v)
    for t in sorted(targets):
        if ida_funcs.get_func(t) is not None:
            continue
        fl = ida_bytes.get_flags(t)
        if ida_bytes.is_code(fl) or ida_bytes.is_unknown(fl):
            if ida_funcs.add_func(t):
                added += 1
    ida_auto.auto_wait()
    log("stage A1 added %d functions from code-xref/vector targets" % added)

    # A2: undefined runs < CUT that decode cleanly with prologue + return
    a2 = 0
    ea = base
    insn = ida_ua.insn_t()
    while ea < CUT:
        fl = ida_bytes.get_flags(ea)
        if ida_bytes.is_unknown(fl) and ida_funcs.get_func(ea) is None:
            # probe: is this a plausible function head?
            b0 = ida_bytes.get_byte(ea)
            b1 = ida_bytes.get_byte(ea + 1)
            head_ok = (b0 == 0x6D and (b1 & 0xF0) == 0xF0) or \
                      (b0 == 0x01 and b1 == 0x00) or \
                      (b0 == 0x6D and (b1 & 0xF0) == 0xF0)
            if head_ok:
                # decode forward up to a return without a bad insn
                cur = ea
                ok = True
                seen_ret = False
                n = 0
                while cur < CUT and n < 400:
                    sz = ida_ua.decode_insn(insn, cur)
                    if sz <= 0 or insn.itype == 0:
                        ok = False
                        break
                    m = (ida_ua.print_insn_mnem(cur) or "").lower().split(".")[0]
                    n += 1
                    if m in RET:
                        seen_ret = True
                        break
                    cur += sz
                if ok and seen_ret and n >= 4:
                    if ida_funcs.add_func(ea):
                        a2 += 1
                        ea = ida_funcs.get_func(ea).end_ea
                        continue
        ea += 2
    ida_auto.auto_wait()
    log("stage A2 added %d functions from clean undefined runs" % a2)
    added_total = added + a2
    new_starts = set(idautils.Functions()) - pre_starts
    log("recovered new functions total %d" % len(new_starts))

    # ================= Stage B: classify functions < CUT ===================
    fname = {s: (idc.get_func_name(s) or "") for s in idautils.Functions()}

    def read_str(a, maxlen=40):
        raw = ida_bytes.get_bytes(a, maxlen) or b""
        out = []
        for c in raw:
            if 32 <= c < 127:
                out.append(chr(c))
            else:
                break
        s = "".join(out)
        return s if len(s) >= 3 else ""

    rows = []
    extra = []
    T_fn = D_fn = 0
    rejected = 0
    insn_bytes_validated = 0

    for start in sorted(s for s in idautils.Functions() if s < CUT):
        func = ida_funcs.get_func(start)
        if func is None:
            continue
        end = func.end_ea
        size = end - start
        st, regs, reg_addrs, callees, ram_writes, data_refs, first_mnem, indirect = scan(func)
        nrefs = len(list(idautils.XrefsTo(start, 0)))
        insn_n = st["insn"] or 1
        structural = st["ret"] + st["call"] + st["branch"]
        odd_ratio = st["odd"] / float(insn_n)
        looks_data = (nrefs == 0 and size >= 24 and
                      (structural == 0 or (odd_ratio > 0.30 and st["call"] == 0)))
        byte_ok = (st["ret"] >= 1 and st["insn"] >= 3 and st["bad"] == 0
                   and plausible_prologue(func, first_mnem) and structural > 0)
        validated = (nrefs > 0 and not looks_data) or byte_ok
        if not validated:
            rejected += 1
            continue
        T_fn += 1

        # instruction bytes inside this validated function
        ib = 0
        ea = start
        while ea < end:
            fl = ida_bytes.get_flags(ea)
            step = max(1, ida_bytes.get_item_end(ea) - ea)
            if ida_bytes.is_code(fl):
                ib += step
            ea += step
        insn_bytes_validated += ib

        # ---- purpose synthesis ----
        parts = []
        weak = False
        # peripherals
        if regs:
            top = ", ".join("%s" % k for k, _ in regs.most_common(3))
            parts.append("touches %s (%s)" % (top,
                         "/".join("%06X" % a for a in sorted(reg_addrs)[:6])))
        # settings writer
        if ram_writes:
            parts.append("writes settings/RAM %s" %
                         "/".join("%06X" % a for a in sorted(ram_writes)[:6]))
        # EEPROM persistence callee
        eeprom = {0x334CA, 0x33532} & callees
        if eeprom:
            parts.append("calls EEPROM driver (%s)" %
                         "/".join("sub_%X" % a for a in sorted(eeprom)))
        # dispatch idiom
        if indirect:
            parts.append("indirect dispatch (jmp/jsr @reg)")
        # eepmov copy
        if st["eepmov"]:
            parts.append("block copy (eepmov)")
        # string refs
        srefs = []
        for a in sorted(data_refs):
            s = read_str(a)
            if s and any(ch.isalpha() for ch in s):
                srefs.append((a, s))
            if len(srefs) >= 3:
                break
        if srefs:
            parts.append("refs " + ", ".join('"%s"@%06X' % (esc(s), a) for a, s in srefs))
        # callees summary
        named_callees = [fname.get(c, "") for c in callees if fname.get(c)]
        # fallback structural purpose
        if not parts:
            weak = True
            if st["call"] == 0 and structural <= st["ret"] and insn_n <= 8:
                parts.append("small leaf helper (%d insn)" % insn_n)
            elif st["branch"] >= 2 and st["call"] == 0:
                parts.append("branch-heavy compute/decode helper (%d insn)" % insn_n)
            elif st["call"] >= 1:
                parts.append("caller/orchestration helper -> %d callee(s)" % len(callees))
            else:
                parts.append("helper routine (%d insn, %d ret)" % (insn_n, st["ret"]))
        purpose = "; ".join(parts)
        if weak:
            purpose = "[weak] " + purpose
        purpose_full = purpose + " [start %08X]" % start

        # evidence
        ev = "size=%d insn=%d ret=%d call=%d br=%d nrefs=%d %s" % (
            size, st["insn"], st["ret"], st["call"], st["branch"], nrefs,
            "reachable" if nrefs else "byte-validated")
        if purpose_full and start:
            D_fn += 1

        rows.append((start, end, "yes", nrefs, purpose_full, ev))
        extra.append((start, end,
                      ",".join("%06X" % a for a in sorted(reg_addrs)),
                      ",".join(sorted(set(fname.get(c, "sub_%X" % c) for c in callees))[:12]),
                      ",".join("%06X" % a for a in sorted(ram_writes)),
                      ";".join('%s@%06X' % (esc(s), a) for a, s in srefs)))

    # ================= Stage C: byte accounting < CUT ======================
    content_below = CUT - base  # region below cut is all content (fill starts >0x7B754)
    # count non-0xFF bytes just to be exact
    blob = ida_bytes.get_bytes(base, CUT - base) or b""
    nonff = sum(1 for b in blob if b != 0xFF)

    with open(os.path.join(OUT, "main-low.tsv"), "w", encoding="utf-8", newline="\n") as h:
        h.write("start\tend\tvalidated\txref\tpurpose\tevidence\n")
        for start, end, v, nrefs, purpose, ev in rows:
            h.write("%08X\t%08X\t%s\t%d\t%s\t%s\n" % (start, end, v, nrefs, esc(purpose), esc(ev)))

    with open(os.path.join(OUT, "main-low-extra.tsv"), "w", encoding="utf-8", newline="\n") as h:
        h.write("start\tend\tregs\tcallees\tram_writes\tstrings\n")
        for r in extra:
            h.write("%08X\t%08X\t%s\t%s\t%s\t%s\n" % r)

    with open(os.path.join(OUT, "new_functions.tsv"), "w", encoding="utf-8", newline="\n") as h:
        h.write("start\tend\tname\n")
        for s in sorted(x for x in new_starts if x < CUT):
            f = ida_funcs.get_func(s)
            h.write("%08X\t%08X\t%s\n" % (s, f.end_ea if f else s, idc.get_func_name(s) or ""))

    counts = [
        "T_fn_low (validated, start<0x038000)\t%d" % T_fn,
        "D_fn_low (with purpose citing start)\t%d" % D_fn,
        "new_functions_below_cut\t%d" % len([x for x in new_starts if x < CUT]),
        "new_functions_total_recovered\t%d" % len(new_starts),
        "rejected_sweep_only\t%d" % rejected,
        "instruction_bytes_in_validated_below_cut\t%d" % insn_bytes_validated,
        "content_bytes_below_cut (0..0x038000)\t%d" % content_below,
        "nonFF_bytes_below_cut\t%d" % nonff,
        "MAIN_instr_pct_below_cut\t%.2f" % (100.0 * insn_bytes_validated / content_below),
    ]
    with open(os.path.join(OUT, "l1_counts.txt"), "w", encoding="utf-8", newline="\n") as h:
        h.write("\n".join(counts) + "\n")
    log("COUNTS:\n" + "\n".join(counts))


try:
    main()
except Exception:
    _LOG.append("TRACEBACK\n" + traceback.format_exc())
    with open(LOG_PATH, "w", encoding="utf-8", newline="\n") as h:
        h.write("\n".join(_LOG) + "\n")
idc.qexit(0)
