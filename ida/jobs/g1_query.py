r"""Lane G1 -- read-only query of G1_H8S: for each address in G1_Q (comma-separated
hex), list the function, crefs/drefs to it, and a short disassembly window."""
from __future__ import annotations
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root
import os, traceback
import ida_auto, ida_bytes, ida_funcs, ida_lines, idautils, idc

ROOT = str(_REPO)
OUT = os.path.join(ROOT, "ida", "out", "h8s-decode", "work", "g1_query.txt")


def main(fh):
    ida_auto.auto_wait()
    for tok in os.environ.get("G1_Q", "").split(","):
        if not tok.strip():
            continue
        ea = int(tok, 16)
        f = ida_funcs.get_func(ea)
        fh.write("== %06X func=%s\n" % (ea, ("%06X-%06X" % (f.start_ea, f.end_ea)) if f else "-"))
        for x in idautils.XrefsTo(ea, 0):
            fh.write("   xref from %06X type=%d iscode=%d\n" % (x.frm, x.type, x.iscode))
        h = ida_bytes.get_item_head(ea)
        for _ in range(int(os.environ.get("G1_N", "6"))):
            fh.write("   %06X %s\n" % (h, ida_lines.tag_remove(ida_lines.generate_disasm_line(h, 0) or "")))
            h = ida_bytes.next_head(h, idc.BADADDR)


try:
    with open(OUT, "w", encoding="utf-8") as fh:
        main(fh)
except Exception:
    with open(OUT, "a", encoding="utf-8") as fh:
        fh.write(traceback.format_exc())
idc.qexit(0)
