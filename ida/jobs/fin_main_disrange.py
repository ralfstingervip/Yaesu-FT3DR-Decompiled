# -*- coding: utf-8 -*-
r"""Dump full disasm for a set of address ranges (debug). Read-only."""
from __future__ import annotations
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root
import os, traceback
import ida_auto, ida_bytes, idc

ROOT = str(_REPO)
OUT = os.path.join(ROOT, "ida", "out", "main-indirect", "disrange.txt")
TB = os.path.join(ROOT, "ida", "out", "main-indirect", "disrange_tb.txt")
RANGES = [(0x3510,0x3560),(0x4800,0x4860),(0x6C40,0x6CC0),(0xA730,0xA7E0),
          (0x15E10,0x15E90),(0xCD2E,0xCD80),(0x14E60,0x14F00)]

def main():
    ida_auto.auto_wait()
    with open(OUT,"w",encoding="utf-8",newline="\n") as o:
        for lo,hi in RANGES:
            o.write("==== %06X-%06X ====\n"%(lo,hi))
            ea=lo
            while ea<hi:
                flg=ida_bytes.get_flags(ea)
                kind="C" if ida_bytes.is_code(flg) else "D"
                line=(idc.generate_disasm_line(ea,0) or "")
                o.write("%06X %s %s\n"%(ea,kind,line))
                nxt=ida_bytes.next_head(ea,hi)
                ea=nxt if nxt>ea else ea+1
            o.write("\n")

try: main()
except Exception:
    open(TB,"w",encoding="utf-8").write(traceback.format_exc())
finally: idc.qexit(0)
