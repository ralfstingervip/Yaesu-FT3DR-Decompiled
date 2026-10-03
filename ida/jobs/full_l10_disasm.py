r"""Lane 10 pass 2 (reopen SUB_LAYOUT): disassemble the font-index functions and
the representative table-reader functions, so the index math (base + code*16) and
the record readers can be described with evidence."""
from __future__ import annotations
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root
import os, traceback
OUT = str(_REPO / "ida/out/sub-layout")

FONT_FUNCS = [0xFFF02DE3, 0xFFF03AD8, 0xFFF067A9, 0xFFF07C24,
              0xFFEE2CCE, 0xFFEE7300, 0xFFF4288E, 0xFFF42EB5]
READER_FUNCS = [0xFFEDF777, 0xFFEE1AA2,          # numeric-scale table readers
                0xFFEE2438, 0xFFEE6168,          # FFEC5A12 / FFEC5940 record readers
                0xFFEDAB4C, 0xFFEDDF3A,          # FFECE4E6 pointer/reginit readers
                0xFFF2DC2B, 0xFFF33499, 0xFFF3850B]

def esc(t): return (t or "").replace("\t"," ").replace("\r"," ").replace("\n"," ")

def dump(h, ea, ida_funcs, ida_bytes, idc, maxbytes=0x600):
    f = ida_funcs.get_func(ea)
    if not f:
        h.write("  (no function at %08X)\n" % ea); return
    h.write("=== %08X %s  (%08X-%08X)\n" % (f.start_ea, idc.get_func_name(f.start_ea) or "", f.start_ea, f.end_ea))
    a = f.start_ea
    while a < f.end_ea and a != idc.BADADDR:
        raw = (ida_bytes.get_bytes(a, min(idc.get_item_size(a), 8)) or b"").hex()
        h.write("  %08X  %-16s %s\n" % (a, raw, esc(idc.generate_disasm_line(a, 0))))
        a = idc.next_head(a, f.end_ea)
    h.write("\n")

def main():
    import ida_funcs, ida_bytes, idc, ida_auto
    ida_auto.auto_wait()
    with open(os.path.join(OUT, "font_funcs.txt"), "w", encoding="utf-8", newline="\n") as h:
        for ea in FONT_FUNCS: dump(h, ea, ida_funcs, ida_bytes, idc)
    with open(os.path.join(OUT, "reader_funcs.txt"), "w", encoding="utf-8", newline="\n") as h:
        for ea in READER_FUNCS: dump(h, ea, ida_funcs, ida_bytes, idc)

if True:
    os.makedirs(OUT, exist_ok=True)
    try: main()
    except Exception:
        with open(os.path.join(OUT, "disasm_traceback.txt"), "w", encoding="utf-8", newline="\n") as _h:
            _h.write(traceback.format_exc())
    import idc as _idc; _idc.qexit(0)
