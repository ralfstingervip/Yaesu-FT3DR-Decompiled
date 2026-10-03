r"""Lane I17 -- read-only disassembly dump of address ranges for citations.
    python ida/run_job.py --script ida\jobs\i17_dis.py --db SUB_FINAL2 --reopen --env I17_DIS=FFEDF904-FFEDF942,... --env I17_TAG=x
Output: ida\out\sub-final2\raw\dis_<tag>.txt
"""
from __future__ import annotations
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root
import os, traceback

ROOT = str(_REPO)
TAG = os.environ.get("I17_TAG", "x")
OUT = os.path.join(ROOT, r"ida\out\sub-final2\raw", "dis_%s.txt" % TAG)


def main():
    import ida_auto, ida_bytes, ida_funcs, idc, ida_lines, ida_name
    ida_auto.auto_wait()
    with open(OUT, "w", encoding="utf-8", newline="\n") as h:
        for rg in os.environ.get("I17_DIS", "").split(","):
            if not rg:
                continue
            a, b = [int(x, 16) for x in rg.split("-")]
            h.write("==== %08X-%08X\n" % (a, b))
            ea = ida_bytes.get_item_head(a)
            while ea < b and ea != idc.BADADDR:
                sz = max(ida_bytes.get_item_size(ea), 1)
                f = ida_funcs.get_func(ea)
                nm = ida_name.get_name(ea)
                lab = (nm + ":") if nm and (not f or True) else ""
                dis = ida_lines.tag_remove(idc.generate_disasm_line(ea, 0) or "")
                h.write("%08X %-14s %-20s %s %s\n" % (ea, ("[%08X]" % f.start_ea) if f else "", ida_bytes.get_bytes(ea, min(sz, 8)).hex(), lab, dis))
                ea = ea + sz if ida_bytes.is_code(ida_bytes.get_flags(ea)) or ida_bytes.is_data(ida_bytes.get_flags(ea)) else ea + 1
    with open(OUT, "a", encoding="utf-8", newline="\n") as h:
        h.write("done\n")


try:
    main()
except Exception:
    with open(OUT, "a", encoding="utf-8", newline="\n") as h:
        h.write(traceback.format_exc())
finally:
    import idc
    idc.qexit(0)
