r"""Lane W2-1: MAIN functions 0x038000 <= ea < 0x05A000 -- validate, purpose.

Seeded --copy-from ida\db\jobs\MAIN_FULL\MAIN_FULL.i64 into DB W2_MAIN_HI_A.

Adapted from ida\jobs\full_l1_classify.py (Lane 1, below 0x038000). Same column
layout and same validation/purpose heuristics; window shifted to the high-A
range. The DSP boot / CDC-ACM service loader window (0x078106-0x07B753) is
outside this range, but a defensive guard gives any function that lands inside
it only the one-line closed purpose.

Stage A  conservative recovery of missed code inside [LO,HI):
           * call/jump/vector code-xref targets in-range that are not funcs yet
           * undefined runs in-range that decode cleanly (prologue + return)
Stage B  classify every function with LO <= start < HI:
           * validated test, decode stats, registers, callees, settings writers,
             string refs, dispatch idioms, purpose line citing the start address
Stage C  byte accounting in-range; write main-high-a.tsv + counts log.

Outputs under ida\out\fnindex\ :
  main-high-a.tsv        start,end,validated,xref,purpose,evidence
  main-high-a-extra.tsv  regs / callees / ram_writes / strings per function
  w2_1_counts.txt        the integers the doc needs
  w2_1_new.tsv           validated functions in range not in functions.tsv
  w2_1_log.txt           run log / traceback
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
import ida_segment
import ida_ua
import idautils
import idc

ROOT = str(_REPO)
OUT = os.path.join(ROOT, "ida", "out", "fnindex")
os.makedirs(OUT, exist_ok=True)
LOG_PATH = os.path.join(OUT, "w2_1_log.txt")
_LOG = []

LO = 0x038000
HI = 0x05A000
CONTENT_END = 0x07B754          # fill (0xFF) begins here
LOADER_LO = 0x078106           # DSP boot / CDC-ACM loader window (closed)
LOADER_HI = 0x07B753

RET = ("rts", "rte", "rtsl")
CALL = ("jsr", "bsr")
BRANCH = ("bra", "beq", "bne", "bcs", "bcc", "bhi", "bls", "bmi", "bpl", "bvs",
          "bvc", "bge", "blt", "bgt", "ble", "bt", "bf")
JMP = ("jmp",)
ODD = ("stc", "ldc", "eepmov", "trapa", "andc", "orc", "xorc", "tas", "mac",
       "clrmac", "ldmac", "stmac", "sleep")
WRITE_MNEMS = ("mov", "bset", "bclr", "bst", "bnot")


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
    return (0xFF8000 <= a <= 0xFFBFFF) or (0xFEE000 <= a <= 0xFF72FF)


def log(text):
    _LOG.append(text)
    with open(LOG_PATH, "w", encoding="utf-8", newline="\n") as h:
        h.write("\n".join(_LOG) + "\n")


def esc(t):
    return (t or "").replace("\t", " ").replace("\n", " ").replace("\r", " ")


def scan(func):
    st = collections.Counter()
    regs = collections.Counter()
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
            for op in insn.ops:
                if op.type == 0:
                    break
                if base_m in ("jmp", "jsr") and op.type in (ida_ua.o_phrase, ida_ua.o_displ, ida_ua.o_reg):
                    has_indirect_jmp = True
            for idx, op in enumerate(insn.ops):
                if op.type == 0:
                    break
                if op.type == ida_ua.o_mem:
                    a24 = op.addr & 0xFFFFFF
                    rc = classify_reg(a24)
                    if rc:
                        regs[rc] += 1
                        reg_addrs.add(a24)
                    if a24 < CONTENT_END:
                        data_refs.add(a24)
                    if base_m in WRITE_MNEMS and idx == 0 and is_ram_config(a24):
                        ram_writes.add(a24)
                if base_m in CALL and op.type in (ida_ua.o_near, ida_ua.o_far, ida_ua.o_mem):
                    callees.add(op.addr & 0xFFFFFF)
        ea = max(ea + 1, ida_bytes.get_item_end(ea))
    return st, regs, reg_addrs, callees, ram_writes, data_refs, first_mnem, has_indirect_jmp


def plausible_prologue(func, first_mnem):
    if first_mnem is None:
        return False
    base_m = first_mnem.split(".")[0]
    if base_m in ("push", "stm"):
        return True
    insn = ida_ua.insn_t()
    if ida_ua.decode_insn(insn, func.start_ea) > 0:
        line = (idc.generate_disasm_line(func.start_ea, 0) or "").lower()
        if "@-sp" in line or "@-er7" in line:
            return True
    if base_m == "sub":
        line = (idc.generate_disasm_line(func.start_ea, 0) or "").lower()
        if "sp" in line or "er7" in line:
            return True
    return False


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


def load_tsv_starts():
    """Pre-existing functions.tsv starts, to flag NEW recoveries."""
    p = os.path.join(ROOT, "ida", "out", "main-full", "functions.tsv")
    starts = set()
    try:
        with open(p, "r", encoding="utf-8") as h:
            next(h, None)
            for line in h:
                cols = line.rstrip("\n").split("\t")
                if cols and cols[0]:
                    try:
                        starts.add(int(cols[0], 16))
                    except ValueError:
                        pass
    except OSError:
        pass
    return starts


def main():
    ida_auto.auto_wait()
    seg = ida_segment.get_first_seg()
    base = seg.start_ea
    tsv_starts = load_tsv_starts()
    log("functions.tsv starts loaded: %d" % len(tsv_starts))

    pre_starts = set(idautils.Functions())
    log("seeded functions total %d" % len(pre_starts))

    # ---- Stage A1: code-xref/vector targets in [LO,HI) not yet functions ----
    targets = set()
    insn = ida_ua.insn_t()
    for start in list(pre_starts):
        f = ida_funcs.get_func(start)
        if f is None:
            continue
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
                            if LO <= t < HI:
                                targets.add(t)
            ea = max(ea + 1, ida_bytes.get_item_end(ea))
    for i in range(256):
        v = ida_bytes.get_dword(base + i * 4)
        if LO <= v < HI:
            targets.add(v)
    added = 0
    for t in sorted(targets):
        if ida_funcs.get_func(t) is not None:
            continue
        fl = ida_bytes.get_flags(t)
        if ida_bytes.is_code(fl) or ida_bytes.is_unknown(fl):
            if ida_funcs.add_func(t):
                added += 1
    ida_auto.auto_wait()
    log("stage A1 added %d functions from code-xref/vector targets" % added)

    # ---- Stage A2: undefined runs in-range that decode cleanly -------------
    a2 = 0
    ea = LO
    while ea < HI:
        fl = ida_bytes.get_flags(ea)
        if ida_bytes.is_unknown(fl) and ida_funcs.get_func(ea) is None:
            b0 = ida_bytes.get_byte(ea)
            b1 = ida_bytes.get_byte(ea + 1)
            head_ok = (b0 == 0x6D and (b1 & 0xF0) == 0xF0) or (b0 == 0x01 and b1 == 0x00)
            if head_ok:
                cur = ea
                ok = True
                seen_ret = False
                n = 0
                while cur < HI and n < 400:
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
                        f2 = ida_funcs.get_func(ea)
                        if f2:
                            ea = f2.end_ea
                            continue
        ea += 2
    ida_auto.auto_wait()
    log("stage A2 added %d functions from clean undefined runs" % a2)
    new_starts = set(idautils.Functions()) - pre_starts
    log("recovered new functions total %d" % len(new_starts))

    # ---- Stage B: classify functions in [LO,HI) ---------------------------
    fname = {s: (idc.get_func_name(s) or "") for s in idautils.Functions()}

    rows = []
    extra = []
    new_rows = []
    T_fn = D_fn = 0
    rejected = 0
    insn_bytes_validated = 0
    subsystems = collections.Counter()

    for start in sorted(s for s in idautils.Functions() if LO <= s < HI):
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

        ib = 0
        ea = start
        while ea < end:
            fl = ida_bytes.get_flags(ea)
            step = max(1, ida_bytes.get_item_end(ea) - ea)
            if ida_bytes.is_code(fl):
                ib += step
            ea += step
        insn_bytes_validated += ib

        # closed guard (loader window is outside range but be safe)
        if LOADER_LO <= start <= LOADER_HI:
            purpose_full = "service-mode DSP loader / CDC-ACM stack (closed) [start %08X]" % start
            ev = "size=%d insn=%d nrefs=%d closed-window" % (size, st["insn"], nrefs)
            rows.append((start, end, "yes", nrefs, purpose_full, ev))
            extra.append((start, end, "", "", "", ""))
            D_fn += 1
            continue

        parts = []
        weak = False
        if regs:
            top = ", ".join("%s" % k for k, _ in regs.most_common(3))
            parts.append("touches %s (%s)" % (top,
                         "/".join("%06X" % a for a in sorted(reg_addrs)[:6])))
            for k, _ in regs.most_common(3):
                subsystems[k] += 1
        if ram_writes:
            parts.append("writes settings/RAM %s" %
                         "/".join("%06X" % a for a in sorted(ram_writes)[:6]))
        eeprom = {0x334CA, 0x33532} & callees
        if eeprom:
            parts.append("calls EEPROM driver (%s)" %
                         "/".join("sub_%X" % a for a in sorted(eeprom)))
        if indirect:
            parts.append("indirect dispatch (jmp/jsr @reg)")
        if st["eepmov"]:
            parts.append("block copy (eepmov)")
        srefs = []
        for a in sorted(data_refs):
            s = read_str(a)
            if s and any(ch.isalpha() for ch in s):
                srefs.append((a, s))
            if len(srefs) >= 3:
                break
        if srefs:
            parts.append("refs " + ", ".join('"%s"@%06X' % (esc(s), a) for a, s in srefs))
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

        ev = "size=%d insn=%d ret=%d call=%d br=%d nrefs=%d %s" % (
            size, st["insn"], st["ret"], st["call"], st["branch"], nrefs,
            "reachable" if nrefs else "byte-validated")
        D_fn += 1

        rows.append((start, end, "yes", nrefs, purpose_full, ev))
        extra.append((start, end,
                      ",".join("%06X" % a for a in sorted(reg_addrs)),
                      ",".join(sorted(set(fname.get(c, "sub_%X" % c) for c in callees))[:12]),
                      ",".join("%06X" % a for a in sorted(ram_writes)),
                      ";".join('%s@%06X' % (esc(s), a) for a, s in srefs)))
        if start not in tsv_starts:
            new_rows.append((start, end, purpose_full, "reachable" if nrefs else "byte-validated"))

    # ---- Stage C: byte accounting -----------------------------------------
    content_in_range = HI - LO
    blob = ida_bytes.get_bytes(LO, HI - LO) or b""
    nonff = sum(1 for b in blob if b != 0xFF)

    with open(os.path.join(OUT, "main-high-a.tsv"), "w", encoding="utf-8", newline="\n") as h:
        h.write("start\tend\tvalidated\txref\tpurpose\tevidence\n")
        for start, end, v, nrefs, purpose, ev in rows:
            h.write("%08X\t%08X\t%s\t%d\t%s\t%s\n" % (start, end, v, nrefs, esc(purpose), esc(ev)))

    with open(os.path.join(OUT, "main-high-a-extra.tsv"), "w", encoding="utf-8", newline="\n") as h:
        h.write("start\tend\tregs\tcallees\tram_writes\tstrings\n")
        for r in extra:
            h.write("%08X\t%08X\t%s\t%s\t%s\t%s\n" % r)

    with open(os.path.join(OUT, "w2_1_new.tsv"), "w", encoding="utf-8", newline="\n") as h:
        h.write("start\tend\tpurpose\thow\n")
        for start, end, purpose, how in new_rows:
            h.write("%08X\t%08X\t%s\t%s\n" % (start, end, esc(purpose), how))

    counts = [
        "range\t0x%06X..0x%06X" % (LO, HI),
        "T_fn (validated, LO<=start<HI)\t%d" % T_fn,
        "D_fn (with purpose citing start)\t%d" % D_fn,
        "new_functions_in_range (validated, not in functions.tsv)\t%d" % len(new_rows),
        "recovered_by_stageA_total\t%d" % len(new_starts),
        "rejected\t%d" % rejected,
        "instruction_bytes_in_validated_in_range\t%d" % insn_bytes_validated,
        "content_bytes_in_range\t%d" % content_in_range,
        "nonFF_bytes_in_range\t%d" % nonff,
        "MAIN_instr_pct_in_range\t%.2f" % (100.0 * insn_bytes_validated / content_in_range),
        "subsystems\t" + "; ".join("%s=%d" % (k, v) for k, v in subsystems.most_common()),
    ]
    with open(os.path.join(OUT, "w2_1_counts.txt"), "w", encoding="utf-8", newline="\n") as h:
        h.write("\n".join(counts) + "\n")
    log("COUNTS:\n" + "\n".join(counts))


try:
    main()
except Exception:
    _LOG.append("TRACEBACK\n" + traceback.format_exc())
    with open(LOG_PATH, "w", encoding="utf-8", newline="\n") as h:
        h.write("\n".join(_LOG) + "\n")
idc.qexit(0)
