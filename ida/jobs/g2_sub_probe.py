# -*- coding: utf-8 -*-
from __future__ import annotations
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root
import os, traceback
import ida_auto, ida_bytes, ida_funcs, idc

ROOT = str(_REPO)
OUT = os.path.join(ROOT, "ida", "out", "main-banks", "sub_probe.txt")
HANDLERS = [0xFFEDF36A, 0xFFEDF3A7, 0xFFEDF447, 0xFFEDF4B8, 0xFFEDF53E,
            0xFFEDF56F, 0xFFEDF61B, 0xFFEDF645]


def main():
    ida_auto.auto_wait()
    with open(OUT, "w", encoding="utf-8", newline="\n") as h:
        for ea in HANDLERS:
            f = ida_funcs.get_func(ea)
            end = f.end_ea if f else ea + 0xC0
            h.write("\n==== %08X-%08X ====\n" % (ea, end))
            a = ea
            while a < end:
                h.write("  %08X  %s\n" % (a, idc.generate_disasm_line(a, 0) or "?"))
                nxt = idc.next_head(a)
                a = nxt if nxt > a else a + 2


try:
    main()
except Exception:
    with open(os.path.join(ROOT, "ida", "out", "main-banks", "sub_probe_tb.txt"), "w", encoding="utf-8") as h:
        h.write(traceback.format_exc())
finally:
    idc.qexit(0)
