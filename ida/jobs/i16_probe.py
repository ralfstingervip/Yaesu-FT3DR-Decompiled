r"""Lane I16 -- read-only IDA h8sxa probe on private DB I16_MAIN (seeded --copy-from ida\db\jobs\MAIN_FINAL\MAIN_FINAL.i64).
Nothing in the DB is changed. The closed window 0x078106-0x07B753 is never dumped; edges into it are recorded as addresses only.

Outputs (ida\out\eeprom-map\work\):
  i16_funcs.tsv    every function in 0x000000-0x078106: start, end, size, name
  i16_callers.tsv  for every function starting in the EEPROM layer ranges: each code xref (from, from_func, type)
  i16_dis_<lo>.txt IDA disassembly of each requested range (env I16_DIS = "lo-hi,lo-hi")
  i16_meta.txt / i16_probe_error.txt
"""
from __future__ import annotations
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root
import os, traceback
import ida_auto, ida_bytes, ida_funcs, ida_ida, idc, idautils, ida_lines

ROOT = str(_REPO)
W = os.path.join(ROOT, "ida", "out", "eeprom-map", "work")
WIN_LO, WIN_HI = 0x078106, 0x07B754
XT = {0: "Data_Unknown", 1: "dr_O", 2: "dr_W", 3: "dr_R", 4: "dr_T", 5: "dr_I", 16: "fl_CF", 17: "fl_CN", 18: "fl_JF", 19: "fl_JN", 21: "fl_F"}
LAYER = [(0x039000, 0x03F000), (0x00D000, 0x00F200), (0x073400, 0x075800)]


def fstart(ea):
    f = ida_funcs.get_func(ea)
    return "%06X" % f.start_ea if f else "-"


def main():
    ida_auto.auto_wait()
    meta = ["procname\t%s" % ida_ida.inf_get_procname()]
    rows = ["start\tend\tsize\tname"]
    for s in idautils.Functions(0, WIN_LO):
        f = ida_funcs.get_func(s)
        rows.append("%06X\t%06X\t%d\t%s" % (s, f.end_ea, f.end_ea - s, ida_funcs.get_func_name(s)))
    meta.append("functions_below_window\t%d" % (len(rows) - 1))
    with open(os.path.join(W, "i16_funcs.tsv"), "w", encoding="utf-8", newline="\n") as fh:
        fh.write("\n".join(rows) + "\n")
    rows = ["callee\tfrom\tfrom_func\ttype\tin_window"]
    for lo, hi in LAYER:
        for s in idautils.Functions(lo, hi):
            for x in idautils.XrefsTo(s, 0):
                if x.type in (1, 2, 3, 4, 5, 0):
                    if not ida_bytes.is_code(ida_bytes.get_flags(x.frm)):
                        pass
                inwin = 1 if WIN_LO <= x.frm < WIN_HI else 0
                rows.append("%06X\t%06X\t%s\t%s\t%d" % (s, x.frm, "-" if inwin else fstart(x.frm), XT.get(x.type, str(x.type)), inwin))
    with open(os.path.join(W, "i16_callers.tsv"), "w", encoding="utf-8", newline="\n") as fh:
        fh.write("\n".join(rows) + "\n")
    spec = os.environ.get("I16_DIS", "")
    for part in [p for p in spec.split(",") if p]:
        lo, hi = [int(v, 16) for v in part.split("-")]
        if lo < WIN_HI and hi > WIN_LO:
            meta.append("skipped_window_range\t%s" % part)
            continue
        out = []
        ea = lo
        while ea < hi and ea != idc.BADADDR:
            fl = ida_bytes.get_flags(ea)
            if ida_funcs.get_func(ea) and ida_funcs.get_func(ea).start_ea == ea:
                out.append("; ---- func %06X" % ea)
            line = ida_lines.tag_remove(idc.generate_disasm_line(ea, 0) or "")
            sz = max(1, ida_bytes.get_item_size(ea))
            k = "C" if ida_bytes.is_code(fl) else ("D" if ida_bytes.is_data(fl) else "U")
            out.append("%06X %s %s" % (ea, k, line))
            ea = ida_bytes.next_head(ea, hi)
        with open(os.path.join(W, "i16_dis_%06X.txt" % lo), "w", encoding="utf-8", newline="\n") as fh:
            fh.write("\n".join(out) + "\n")
    with open(os.path.join(W, "i16_meta.txt"), "w", encoding="utf-8", newline="\n") as fh:
        fh.write("\n".join(meta) + "\n")


try:
    main()
except Exception:
    with open(os.path.join(W, "i16_probe_error.txt"), "w", encoding="utf-8") as fh:
        fh.write(traceback.format_exc())
idc.qexit(0)
