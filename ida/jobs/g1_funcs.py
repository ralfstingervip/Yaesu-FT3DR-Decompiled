r"""Lane G1 -- create functions at entries proven by a call or a verified dispatch
table, over absorbed H8SX code that is still outside any function (PRIVATE G1_H8S).

Input  ida\out\h8s-decode\work\entries.json  (run starts that are jsr/bsr
       targets of existing code or entries of a dispatch table whose load is a
       decoded MOV.L @(d:32,ERs),ERd followed by jmp/jsr @ERd)
Output ida\out\h8s-decode\work\funcs_created.tsv
Every add_func result is logged; nothing is deleted.
"""
from __future__ import annotations
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root
import os, json, traceback
import ida_auto, ida_funcs, idc

ROOT = str(_REPO)
WORK = os.path.join(ROOT, "ida", "out", "h8s-decode", "work")


def main(fh):
    ida_auto.auto_wait()
    d = json.load(open(os.path.join(WORK, "entries.json"), encoding="utf-8"))
    fh.write("entry\twhy\tok\tstart\tend\n")
    for e in d["entries"]:
        if ida_funcs.get_func(e):
            f = ida_funcs.get_func(e)
            fh.write("%06X\t%s\tinside\t%06X\t%06X\n" % (e, d["why"]["%06X" % e], f.start_ea, f.end_ea))
            continue
        ok = ida_funcs.add_func(e)
        ida_auto.auto_wait()
        f = ida_funcs.get_func(e)
        fh.write("%06X\t%s\t%r\t%s\t%s\n" % (e, d["why"]["%06X" % e], ok,
                                            ("%06X" % f.start_ea) if f else "-", ("%06X" % f.end_ea) if f else "-"))
    ida_auto.auto_wait()


try:
    with open(os.path.join(WORK, "funcs_created.tsv"), "w", encoding="utf-8", newline="\n") as fh:
        main(fh)
except Exception:
    with open(os.path.join(WORK, "funcs_err.txt"), "w", encoding="utf-8") as fh:
        fh.write(traceback.format_exc())
idc.qexit(0)
