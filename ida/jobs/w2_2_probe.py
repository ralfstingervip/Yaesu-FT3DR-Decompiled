from __future__ import annotations
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root
import os, traceback
import ida_auto, ida_bytes, ida_funcs, ida_ua, idautils, idc

OUT = str(_REPO / "ida/out/fnindex/w2_2_probe.txt")
lines = []

def dump(ea, n=12):
    lines.append("--- probe %06X ---" % ea)
    f = ida_funcs.get_func(ea)
    lines.append("in_func: %s  func_start=%s" % (
        (f is not None), ("%06X" % f.start_ea) if f else "None"))
    lines.append("flags code=%s unknown=%s" % (
        ida_bytes.is_code(ida_bytes.get_flags(ea)),
        ida_bytes.is_unknown(ida_bytes.get_flags(ea))))
    xr = list(idautils.XrefsTo(ea, 0))
    lines.append("xrefs_to: %d  %s" % (len(xr),
        ", ".join("%06X(%d)" % (x.frm, x.type) for x in xr[:8])))
    cur = ea
    for _ in range(n):
        lines.append("  %06X: %s" % (cur, idc.generate_disasm_line(cur, 0) or "?"))
        e = ida_bytes.get_item_end(cur)
        cur = e if e > cur else cur + 1

try:
    ida_auto.auto_wait()
    for a in (0x5E9E2, 0x7390A, 0x78106, 0x738AC, 0x738CC, 0x73AB4):
        dump(a)
    with open(OUT, "w", encoding="utf-8", newline="\n") as h:
        h.write("\n".join(lines) + "\n")
except Exception:
    with open(OUT, "w", encoding="utf-8", newline="\n") as h:
        h.write(traceback.format_exc())
idc.qexit(0)
