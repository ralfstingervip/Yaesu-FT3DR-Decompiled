r"""Lane J11 -- read-only dump of icon/glyph/storage consumers + raw table bytes.
Output under ida\out\sub-icon-glyph\raw\.
"""
from __future__ import annotations
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root
import os, traceback

ROOT = str(_REPO)
OUTDIR = os.path.join(ROOT, r"ida\out\sub-icon-glyph\raw")
os.makedirs(OUTDIR, exist_ok=True)
OUT = os.path.join(OUTDIR, "dump.txt")

# consumer functions to disassemble in full
FUNCS = [
    0xFFEF34B1,  # icon record memcpy
    0xFFEE59A4,  # glyph_tbl8 consumer
    0xFFEF2184,  # 1bpp glyph resolver (font block table)
    0xFFEE5269,  # glyph width lookup
    0xFFF34897,  # storage driver table reader
    0xFFF362EF,  # storage mode record reader
    0xFFEF0648,  # RGB565 blit (reads bmp_desc fields)
]

# raw table ranges to hexdump
TABLES = [
    ("icon_rec", 0xFFED55E0, 0xFFED71A8),       # 254 x 28
    ("font1_blk", 0xFFED4644, 0xFFED477C),      # 26 x 12
    ("glyph1_desc", 0xFFED477C, 0xFFED49E0),    # 51 x 12
    ("glyph_tbl8", 0xFFED49E0, 0xFFED4B48),     # 45 x 8 (?)
    ("store_7f18", 0xFFED7F18, 0xFFED819C),     # storage driver tables
    ("descptr_55d4", 0xFFED55D4, 0xFFED55E0),   # 3 desc pointers
]


def dump_func(h, ida_funcs, ida_bytes, idc, ida_lines, ida_name, idautils, start):
    f = ida_funcs.get_func(start)
    if not f:
        h.write("!! no func at %08X\n" % start)
        return
    nm = ida_name.get_name(f.start_ea) or ""
    h.write("\n==== FUNC %08X %s  (end %08X)\n" % (f.start_ea, nm, f.end_ea))
    # callers
    h.write("-- callers:\n")
    for xr in idautils.XrefsTo(f.start_ea, 0):
        h.write("   from %08X (%s)\n" % (xr.frm, idc.get_func_name(xr.frm) or ""))
    h.write("-- body:\n")
    for ea in idautils.FuncItems(f.start_ea):
        sz = max(ida_bytes.get_item_size(ea), 1)
        dis = ida_lines.tag_remove(idc.generate_disasm_line(ea, 0) or "")
        bts = ida_bytes.get_bytes(ea, min(sz, 10)) or b""
        lab = ida_name.get_name(ea) or ""
        h.write("%08X  %-20s  %-22s %s\n" % (ea, bts.hex(), lab, dis))


def main():
    import ida_auto, ida_bytes, ida_funcs, idc, ida_lines, ida_name
    import idautils
    ida_auto.auto_wait()
    with open(OUT, "w", encoding="utf-8", newline="\n") as h:
        for fa in FUNCS:
            try:
                dump_func(h, ida_funcs, ida_bytes, idc, ida_lines, ida_name, idautils, fa)
            except Exception:
                h.write("ERR on %08X\n%s\n" % (fa, traceback.format_exc()))
        h.write("\n\n######## RAW TABLES ########\n")
        for name, a, b in TABLES:
            h.write("\n==== TABLE %s %08X-%08X (%d bytes)\n" % (name, a, b, b - a))
            data = ida_bytes.get_bytes(a, b - a) or b""
            # 16 bytes per line with address
            for off in range(0, len(data), 16):
                chunk = data[off:off + 16]
                h.write("%08X  %s\n" % (a + off, chunk.hex()))
    with open(OUT, "a", encoding="utf-8", newline="\n") as h:
        h.write("\ndone\n")


try:
    main()
except Exception:
    with open(OUT, "a", encoding="utf-8", newline="\n") as h:
        h.write(traceback.format_exc())
finally:
    import idc
    idc.qexit(0)
