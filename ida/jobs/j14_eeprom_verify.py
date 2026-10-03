r"""Lane J14 -- read-only IDA h8sxa verify pass on private DB J14_EEPROM
(seeded --copy-from ida\db\jobs\MAIN_FINAL2\MAIN_FINAL2.i64). Nothing in the DB
is changed. The closed window 0x078106-0x07B753 is never dumped.

Verifies I16 claims by byte/instruction:
  (1) sub_3BDAC I2C ports 0xFFFBA0/A4/A8
  (2) sub_33532 3-wire device, ports B/D; callers 0x77DB2, 0x77DF6
  (3) sub_5E96A DG-ID field pack
  (4) sub_3C668 caller scan (whole image)

Outputs (ida\out\eeprom-verify\):
  j14_xrefs.tsv        whole-image XrefsTo for 0x3BDAC,0x33532,0x3C668,0x5E96A,0x3C378
  j14_callsite.tsv     containing-func + reachability for 0x77DB2,0x77DF6, and each 3C668 xref
  j14_dis_*.txt        disasm of each range
  j14_meta.txt / j14_error.txt
"""
from __future__ import annotations
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root
import os, traceback
import ida_auto, ida_bytes, ida_funcs, ida_ida, idc, idautils, ida_lines, ida_xref

ROOT = str(_REPO)
W = os.path.join(ROOT, "ida", "out", "eeprom-verify")
WIN_LO, WIN_HI = 0x078106, 0x07B754
XT = {0: "Data_Unknown", 1: "dr_O", 2: "dr_W", 3: "dr_R", 4: "dr_T", 5: "dr_I",
      16: "fl_CF", 17: "fl_CN", 18: "fl_JF", 19: "fl_JN", 20: "fl_USER", 21: "fl_F"}

TARGETS = [0x3BDAC, 0x33532, 0x3C668, 0x5E96A, 0x3C378, 0x3BF4C]
RANGES = [(0x33532, 0x335F6), (0x5E95C, 0x5E9B0), (0x77D80, 0x77E40),
          (0x3C668, 0x3C99C)]


def fstart(ea):
    f = ida_funcs.get_func(ea)
    return "%06X" % f.start_ea if f else "-"


def fname(ea):
    f = ida_funcs.get_func(ea)
    return ida_funcs.get_func_name(f.start_ea) if f else "-"


def dis(ea):
    return ida_lines.tag_remove(idc.generate_disasm_line(ea, 0) or "")


def main():
    ida_auto.auto_wait()
    meta = ["procname\t%s" % ida_ida.inf_get_procname()]

    # whole-image xrefs to each target
    rows = ["target\tfrom\tfrom_func\ttype\tin_window\tfrom_insn"]
    for t in TARGETS:
        n = 0
        for x in idautils.XrefsTo(t, 0):
            n += 1
            inwin = 1 if WIN_LO <= x.frm < WIN_HI else 0
            insn = "-" if inwin else dis(x.frm)
            rows.append("%06X\t%06X\t%s\t%s\t%d\t%s" % (
                t, x.frm, "-" if inwin else fstart(x.frm), XT.get(x.type, str(x.type)), inwin, insn))
        meta.append("xrefs_to_%06X\t%d" % (t, n))
    with open(os.path.join(W, "j14_xrefs.tsv"), "w", encoding="utf-8", newline="\n") as fh:
        fh.write("\n".join(rows) + "\n")

    # reachability of specific callsites and of 3C668's containing func
    rows = ["site\tcontaining_func\tfunc_name\tfunc_code_xref_count\tinsn"]
    sites = [0x77DB2, 0x77DF6]
    for s in sites:
        f = ida_funcs.get_func(s)
        fe = f.start_ea if f else idc.BADADDR
        cx = 0
        if f:
            for x in idautils.XrefsTo(fe, 0):
                if x.type in (16, 17, 18, 19, 20, 21):
                    cx += 1
        rows.append("%06X\t%s\t%s\t%d\t%s" % (
            s, "%06X" % fe if f else "-", fname(s), cx, dis(s)))
    # 3C668 containing func + its callers
    f = ida_funcs.get_func(0x3C668)
    if f:
        cx = 0
        for x in idautils.XrefsTo(f.start_ea, 0):
            cx += 1
        rows.append("3C668func\t%06X\t%s\t%d\t%s" % (
            f.start_ea, ida_funcs.get_func_name(f.start_ea), cx, dis(f.start_ea)))
    with open(os.path.join(W, "j14_callsite.tsv"), "w", encoding="utf-8", newline="\n") as fh:
        fh.write("\n".join(rows) + "\n")

    # disasm ranges
    for lo, hi in RANGES:
        if lo < WIN_HI and hi > WIN_LO:
            meta.append("skipped_window_range\t%06X-%06X" % (lo, hi))
            continue
        out = []
        ea = lo
        while ea < hi and ea != idc.BADADDR:
            fl = ida_bytes.get_flags(ea)
            fn = ida_funcs.get_func(ea)
            if fn and fn.start_ea == ea:
                out.append("; ---- func %06X %s" % (ea, ida_funcs.get_func_name(ea)))
            sz = max(1, ida_bytes.get_item_size(ea))
            raw = " ".join("%02x" % b for b in ida_bytes.get_bytes(ea, min(sz, 8)) or b"")
            k = "C" if ida_bytes.is_code(fl) else ("D" if ida_bytes.is_data(fl) else "U")
            out.append("%06X %s [%s] %s" % (ea, k, raw, dis(ea)))
            nxt = ida_bytes.next_head(ea, hi)
            ea = nxt if nxt != ea else ea + 1
        with open(os.path.join(W, "j14_dis_%06X.txt" % lo), "w", encoding="utf-8", newline="\n") as fh:
            fh.write("\n".join(out) + "\n")

    with open(os.path.join(W, "j14_meta.txt"), "w", encoding="utf-8", newline="\n") as fh:
        fh.write("\n".join(meta) + "\n")


try:
    main()
except Exception:
    with open(os.path.join(W, "j14_error.txt"), "w", encoding="utf-8") as fh:
        fh.write(traceback.format_exc())
idc.qexit(0)
