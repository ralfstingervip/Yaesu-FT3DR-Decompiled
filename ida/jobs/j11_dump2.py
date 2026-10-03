r"""Lane J11 -- pass 2: trace icon caller + find all readers of icon record offsets."""
from __future__ import annotations
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root
import os, traceback

ROOT = str(_REPO)
OUTDIR = os.path.join(ROOT, r"ida\out\sub-icon-glyph\raw")
os.makedirs(OUTDIR, exist_ok=True)
OUT = os.path.join(OUTDIR, "dump2.txt")

FUNCS = [0xFFEF2505, 0xFFF3466C, 0xFFF35347, 0xFFEF68D5]


def dump_func(h, m, start):
    ida_funcs, ida_bytes, idc, ida_lines, ida_name, idautils = m
    f = ida_funcs.get_func(start)
    if not f:
        h.write("!! no func at %08X\n" % start); return
    nm = ida_name.get_name(f.start_ea) or ""
    h.write("\n==== FUNC %08X %s (end %08X)\n-- callers:\n" % (f.start_ea, nm, f.end_ea))
    for xr in idautils.XrefsTo(f.start_ea, 0):
        h.write("   from %08X (%s)\n" % (xr.frm, idc.get_func_name(xr.frm) or ""))
    h.write("-- body:\n")
    for ea in idautils.FuncItems(f.start_ea):
        sz = max(ida_bytes.get_item_size(ea), 1)
        dis = ida_lines.tag_remove(idc.generate_disasm_line(ea, 0) or "")
        bts = (ida_bytes.get_bytes(ea, min(sz, 10)) or b"").hex()
        lab = ida_name.get_name(ea) or ""
        h.write("%08X  %-20s  %-20s %s\n" % (ea, bts, lab, dis))


def main():
    import ida_auto, ida_bytes, ida_funcs, idc, ida_lines, ida_name
    import idautils
    ida_auto.auto_wait()
    m = (ida_funcs, ida_bytes, idc, ida_lines, ida_name, idautils)
    with open(OUT, "w", encoding="utf-8", newline="\n") as h:
        for fa in FUNCS:
            try:
                dump_func(h, m, fa)
            except Exception:
                h.write("ERR %08X\n%s\n" % (fa, traceback.format_exc()))
        h.write("\ndone\n")


try:
    main()
except Exception:
    with open(OUT, "a", encoding="utf-8", newline="\n") as h:
        h.write(traceback.format_exc())
finally:
    import idc
    idc.qexit(0)
