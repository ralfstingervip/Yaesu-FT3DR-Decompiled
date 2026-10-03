# -*- coding: utf-8 -*-
r"""Lane H2 -- correct the text extents around the two ASCII-led F1 rows.
0x04DE26: word 0x000E, 0x04DE28 / 0x04DE36: 14 B labels "Height    -m \xff", "Height    -ft\xff",
0x04DE44: 20 x 4-char value fields (loaded 4 B at a time by 0x04DE0A mov.l @(0x4DE44:32,er3),er4).
0x04DF60: word 0x000E, 0x04DF62: 14 B label "A-Dir     -\x06 \xff",
0x04DF70: 10 x 4-char value fields (loaded by 0x04DF3A mov.l @(0x4DF70:32,er3),er4).
Appends to ida\out\h8sx-seed\changes.tsv (phase=text)."""
from __future__ import annotations
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root
import os, traceback
import ida_auto, ida_bytes, ida_funcs, ida_nalt, idc

ROOT = str(_REPO)
OUT = os.path.join(ROOT, "ida", "out", "h8sx-seed")
CH = []


def mk(ea, n, why):
    fl = ida_bytes.get_flags(ea)
    before = "code" if ida_bytes.is_code(fl) else ("data" if ida_bytes.is_data(fl) else "unk")
    ida_bytes.del_items(ea, ida_bytes.DELIT_SIMPLE, n)
    ok = ida_bytes.create_strlit(ea, n, ida_nalt.STRTYPE_C)
    if not ok:
        ok = ida_bytes.create_byte(ea, n)
    b = ida_bytes.get_bytes(ea, n)
    CH.append("text\tmake_string\t%06X\t%s\tstrlit %d B ok=%s\t%s; bytes %s" % (ea, before, n, ok, why, b.hex()))


def main():
    ida_auto.auto_wait()
    for f in (0x04DE6E, 0x04DF72):
        g = ida_funcs.get_func(f)
        if g:
            CH.append("text\terror\t%06X\tin func %X\t-\tunexpected" % (f, g.start_ea))
            return
    mk(0x04DE28, 14, "label 'Height    -m' + 20 ff")
    mk(0x04DE36, 14, "label 'Height    -ft' + ff")
    for i in range(20):
        mk(0x04DE44 + 4 * i, 4, "4-char value field %d of table 0x04DE44 (mov.l @(0x4DE44:32,er3) at 0x04DE0A)" % i)
    mk(0x04DF62, 14, "label 'A-Dir     -' 06 20 ff")
    for i in range(10):
        mk(0x04DF70 + 4 * i, 4, "4-char value field %d of table 0x04DF70 (mov.l @(0x4DF70:32,er3) at 0x04DF3A)" % i)
    ida_auto.auto_wait()


try:
    main()
except Exception:
    CH.append("text\terror\t0\t-\t-\t" + traceback.format_exc().replace("\n", " | "))
with open(os.path.join(OUT, "changes.tsv"), "a", encoding="utf-8", newline="\n") as h:
    for c in CH:
        h.write(c + "\n")
idc.qexit(0)
