from __future__ import annotations
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root
import os, traceback
import ida_auto, ida_bytes, ida_lines, idautils, idc
ROOT = str(_REPO)
OUT = os.path.join(ROOT, "ida", "out", "sci-c-pump", "work", "prologue.txt")
def txt(ea):
    return ida_lines.tag_remove(ida_lines.generate_disasm_line(ea, 0) or "").replace("\t", " ")
def main(fh):
    ida_auto.auto_wait()
    for a, b in [(0x076FC8, 0x077018)]:
        fh.write("--- %06X..%06X ---\n" % (a, b))
        ea = a
        while ea < b:
            n = ida_bytes.get_item_size(ea)
            bs = " ".join("%02X" % ida_bytes.get_byte(ea + i) for i in range(min(n, 10)))
            fh.write("%06X  %-28s %s\n" % (ea, bs, txt(ea)))
            ea = ida_bytes.next_head(ea, idc.BADADDR)
try:
    with open(OUT, "w", encoding="utf-8", newline="\n") as fh:
        main(fh)
except Exception:
    with open(OUT, "a", encoding="utf-8") as fh:
        fh.write(traceback.format_exc())
idc.qexit(0)
