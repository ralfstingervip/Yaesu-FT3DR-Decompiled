r"""Lane G1 -- last pipeline step on the PRIVATE G1_H8S database: undo IDA side
effects that the H8SX decode did not cause.

0x0458D8-0x0458F4 is ASCII text (W2-8 run type `string`). IDA re-creates a
function there from a data offset at 0x0455B8 whenever auto-analysis drains,
so it is removed after every other step.
"""
from __future__ import annotations
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root
import os, traceback
import ida_auto, ida_bytes, ida_funcs, idc

ROOT = str(_REPO)
LOG = os.path.join(ROOT, "ida", "out", "h8s-decode", "work", "g1_cleanup.log")
JUNK = ((0x0458D8, 0x0458F4),)


def main(log):
    ida_auto.auto_wait()
    for s, e in JUNK:
        f = ida_funcs.get_func(s)
        if f:
            ida_funcs.del_func(f.start_ea)
        ida_bytes.del_items(s, ida_bytes.DELIT_SIMPLE, e - s)
        log.write("cleared %06X-%06X\n" % (s, e))
    # do not let the queue run again before saving
    for nm in dir(ida_auto):
        if nm.startswith("AU_") and nm != "AU_NONE":
            ida_auto.auto_unmark(0, 0xFFFFFFFF, getattr(ida_auto, nm))


try:
    with open(LOG, "w", encoding="utf-8") as log:
        main(log)
except Exception:
    with open(LOG, "a", encoding="utf-8") as log:
        log.write(traceback.format_exc())
idc.qexit(0)
