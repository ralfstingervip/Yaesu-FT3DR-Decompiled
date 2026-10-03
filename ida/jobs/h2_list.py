# -*- coding: utf-8 -*-
r"""Lane H2 -- read-only listing of address ranges. Env H2_RANGES = "lo-hi,lo-hi" (hex),
H2_TAG = output prefix. Writes ida\out\h8sx-seed\work\<TAG>_list.txt."""
from __future__ import annotations
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root
import os, traceback
import ida_auto, ida_bytes, ida_funcs, ida_lines, idautils, idc

ROOT = str(_REPO)
OUT = os.path.join(ROOT, "ida", "out", "h8sx-seed", "work")
TAG = os.environ.get("H2_TAG", "list")


def main(h):
    ida_auto.auto_wait()
    for r in os.environ.get("H2_RANGES", "").split(","):
        if not r:
            continue
        lo, hi = [int(x, 16) for x in r.split("-")]
        h.write("=== %06X-%06X\n" % (lo, hi))
        ea = lo if ida_bytes.is_head(ida_bytes.get_flags(lo)) else ida_bytes.next_head(lo, hi)
        while ea != idc.BADADDR and ea < hi:
            sz = ida_bytes.get_item_size(ea)
            fl = ida_bytes.get_flags(ea)
            k = "C" if ida_bytes.is_code(fl) else ("D" if ida_bytes.is_data(fl) else "U")
            b = (ida_bytes.get_bytes(ea, min(sz, 10)) or b"").hex(" ")
            fn = ida_funcs.get_func(ea)
            xr = ",".join("%X" % x for x in list(idautils.CodeRefsTo(ea, 0))[:5] + list(idautils.DataRefsTo(ea))[:5])
            t = ida_lines.tag_remove(ida_lines.generate_disasm_line(ea, 0) or "")
            h.write("%06X %s %-30s %-48s fn=%s in=%s\n" % (ea, k, b, t[:48], "%X" % fn.start_ea if fn else "-", xr))
            ea = ida_bytes.next_head(ea, hi)


try:
    with open(os.path.join(OUT, "%s_list.txt" % TAG), "w", encoding="utf-8", newline="\n") as h:
        main(h)
except Exception:
    with open(os.path.join(OUT, "%s_list_tb.txt" % TAG), "w", encoding="utf-8") as h:
        h.write(traceback.format_exc())
idc.qexit(0)
