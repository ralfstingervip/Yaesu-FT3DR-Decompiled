r"""Lane J10 -- disassembly dump of the peripheral-touching dead/unreached functions and a
few merge-chain heads, for the write-up.  Read-only.

    python ida/run_job.py --script ida\jobs\j10_dis.py --db J10_SUBMERGE --reopen
"""
from __future__ import annotations
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root
import os, traceback

ROOT = str(_REPO)
OUT = os.path.join(ROOT, r"ida\out\sub-merge\raw")
DUMP = os.path.join(OUT, "dis.txt")

TARGETS = [0xFFEDC455, 0xFFF3753A, 0xFFF37542, 0xFFF3754A, 0xFFF37558,
           0xFFF13DDA, 0xFFF13DEF, 0xFFF13EEA, 0xFFF2A6D1, 0xFFF2A70B,
           0xFFEF05DD, 0xFFEF0609, 0xFFF12437]


def main():
    import ida_auto, ida_funcs, idautils, idc, ida_lines
    ida_auto.auto_wait()
    with open(DUMP, "w", encoding="utf-8", newline="\n") as h:
        for t in TARGETS:
            f = ida_funcs.get_func(t)
            if not f:
                h.write("=== %08X : no function\n\n" % t)
                continue
            h.write("=== %08X  func %08X-%08X  name=%s\n" % (t, f.start_ea, f.end_ea, idc.get_func_name(f.start_ea)))
            for a, b in sorted(tuple(c) for c in idautils.Chunks(f.start_ea)):
                ea = a
                while ea < b:
                    txt = idc.generate_disasm_line(ea, 0)
                    txt = ida_lines.tag_remove(txt) if txt else ""
                    sz = idc.get_item_size(ea)
                    bs = idc.get_bytes(ea, sz) or b""
                    h.write("  %08X %-18s %s\n" % (ea, bs.hex(), txt))
                    ea = idc.next_head(ea, b)
                    if ea == idc.BADADDR:
                        break
            h.write("\n")


try:
    main()
except Exception:
    with open(DUMP, "a", encoding="utf-8", newline="\n") as h:
        h.write(traceback.format_exc())
finally:
    import idc
    idc.qexit(0)
