# -*- coding: utf-8 -*-
r"""Lane M1 - read-only dump of a MAIN DB: every head over 0..0x7B754 (ea, size, kind) and every function.

Owner-side static analysis. No DB edit, no patch_*. Output dir: ida\out\main-final6\work\<M1_TAG>\
Run: python ida\run_job.py --script ida\jobs\m1_dump.py --db M1_MAIN_FINAL6 --reopen --env M1_TAG=after
"""
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root
import os, traceback
import ida_auto, ida_bytes, ida_funcs, idautils, idc

ROOT = str(_REPO)
TAG = os.environ.get("M1_TAG", "dump")
OUT = os.path.join(ROOT, "ida", "out", "main-final6", "work", TAG)
HI = 0x7B754


def main():
    ida_auto.auto_wait()
    os.makedirs(OUT, exist_ok=True)
    with open(os.path.join(OUT, "heads.tsv"), "w", encoding="utf-8", newline="\n") as h:
        h.write("ea\tsize\tkind\n")
        for ea in idautils.Heads(0, HI):
            f = ida_bytes.get_flags(ea)
            k = "code" if ida_bytes.is_code(f) else ("data" if ida_bytes.is_data(f) else "unk")
            h.write("%06X\t%d\t%s\n" % (ea, ida_bytes.get_item_size(ea), k))
    with open(os.path.join(OUT, "funcs.tsv"), "w", encoding="utf-8", newline="\n") as h:
        h.write("start\tend\n")
        for fa in idautils.Functions():
            fn = ida_funcs.get_func(fa)
            h.write("%06X\t%06X\n" % (fn.start_ea, fn.end_ea))
    with open(os.path.join(OUT, "done.txt"), "w", encoding="utf-8", newline="\n") as h:
        h.write("ok\n")


try:
    main()
except Exception:
    os.makedirs(OUT, exist_ok=True)
    with open(os.path.join(OUT, "m1_dump_tb.txt"), "w", encoding="utf-8", newline="\n") as h:
        h.write(traceback.format_exc())
finally:
    idc.qexit(0)
