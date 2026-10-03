r"""Lane 10 pass 3 (reopen SUB_LAYOUT): disassemble the string/number renderers
sub_FFEFA7E7 and sub_FFEF190D (the per-character glyph indexers) and the FFF03AD8
tail, to locate the true base + code*16 font-index math and any ASCII offset."""
from __future__ import annotations
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root
import os, traceback
OUT = str(_REPO / "ida/out/sub-layout")
FUNCS = [0xFFEFA7E7, 0xFFEF190D, 0xFFEF1B23, 0xFFF03AD8]
def esc(t): return (t or "").replace("\t"," ").replace("\r"," ").replace("\n"," ")
def main():
    import ida_funcs, ida_bytes, idc, ida_auto
    ida_auto.auto_wait()
    with open(os.path.join(OUT, "renderers.txt"), "w", encoding="utf-8", newline="\n") as h:
        for ea in FUNCS:
            f = ida_funcs.get_func(ea)
            if not f:
                h.write("=== no function at %08X ===\n\n" % ea); continue
            h.write("=== %08X %s (%08X-%08X, %d bytes) ===\n" %
                    (f.start_ea, idc.get_func_name(f.start_ea) or "", f.start_ea, f.end_ea, f.end_ea-f.start_ea))
            a = f.start_ea
            while a < f.end_ea and a != idc.BADADDR:
                raw = (ida_bytes.get_bytes(a, min(idc.get_item_size(a), 8)) or b"").hex()
                h.write("  %08X  %-16s %s\n" % (a, raw, esc(idc.generate_disasm_line(a, 0))))
                a = idc.next_head(a, f.end_ea)
            h.write("\n")
if True:
    os.makedirs(OUT, exist_ok=True)
    try: main()
    except Exception:
        with open(os.path.join(OUT, "font_traceback.txt"), "w", encoding="utf-8", newline="\n") as _h:
            _h.write(traceback.format_exc())
    import idc as _idc; _idc.qexit(0)
