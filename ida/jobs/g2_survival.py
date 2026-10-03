# -*- coding: utf-8 -*-
r"""Lane G2 survival test. In a private DB (G2_BANKS):
  1. Read all 149 resolved dispatch tables from the raw image (BE32), emit
     table-xrefs.tsv (from_table_entry, target) for every live code target.
  2. Apply those xrefs via g2_apply_table_xrefs.apply_from_tsv.
  3. Re-analyse the MAIN content region.
  4. Count how many of the 444 proved functions still exist as functions AND
     carry an incoming xref. Write survival.txt.
H8S advanced, big-endian, base 0.
"""
from __future__ import annotations
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root
import os, sys, traceback
import ida_auto, ida_bytes, ida_funcs, ida_xref, idc, idautils

ROOT = str(_REPO)
JOBS = os.path.join(ROOT, "ida", "jobs")
OUTDIR = os.path.join(ROOT, "ida", "out", "main-banks")
os.makedirs(OUTDIR, exist_ok=True)
if JOBS not in sys.path:
    sys.path.insert(0, JOBS)
import g2_apply_table_xrefs as applier

JT = os.path.join(ROOT, "ida", "out", "main-full", "jumptables.tsv")
PROVED = os.path.join(ROOT, "ida", "out", "main-indirect", "proved.tsv")
XREF_TSV = os.path.join(OUTDIR, "table-xrefs.tsv")
SENT = 0x0003FFA0
LO, HI = 0x400, 0x7B754


def read_be32(ea):
    b = ida_bytes.get_bytes(ea, 4)
    if not b or len(b) != 4:
        return None
    return (b[0] << 24) | (b[1] << 16) | (b[2] << 8) | b[3]


def build_xref_tsv():
    n_rows = 0
    with open(JT, encoding="utf-8") as h, \
         open(XREF_TSV, "w", encoding="utf-8", newline="\n") as o:
        o.write("from_table_entry\ttarget\ttable\tindex\n")
        next(h)
        for line in h:
            p = line.rstrip("\n").split("\t")
            if len(p) < 2 or not p[0] or p[0].startswith("#"):
                continue
            base = int(p[0], 16)
            cnt = int(p[1])
            for i in range(cnt):
                ea = base + 4 * i
                d = read_be32(ea)
                if d is None or d == SENT:
                    continue
                if LO <= d < HI:
                    o.write("%06X\t%06X\t%06X\t%d\n" % (ea, d, base, i))
                    n_rows += 1
    return n_rows


def load_proved():
    starts = []
    with open(PROVED, encoding="utf-8") as h:
        next(h)
        for line in h:
            p = line.rstrip("\n").split("\t")
            if p and p[0] and not p[0].startswith("#"):
                try:
                    starts.append(int(p[0], 16))
                except ValueError:
                    pass
    return starts


def has_incoming_xref(ea):
    for _ in idautils.CodeRefsTo(ea, 0):
        return True
    for _ in idautils.DataRefsTo(ea):
        return True
    return False


def main():
    ida_auto.auto_wait()
    proved = load_proved()

    # baseline BEFORE applying xrefs
    before_func = sum(1 for s in proved if ida_funcs.get_func(s) and ida_funcs.get_func(s).start_ea == s)
    before_xref = sum(1 for s in proved if has_incoming_xref(s))

    n_rows = build_xref_tsv()
    rows, xrefs, funcs = applier.apply_from_tsv(XREF_TSV)

    # re-analyse the content region
    ida_auto.plan_and_wait(LO, HI)
    ida_auto.auto_wait()

    after_func = sum(1 for s in proved if ida_funcs.get_func(s) and ida_funcs.get_func(s).start_ea == s)
    after_xref = sum(1 for s in proved if has_incoming_xref(s))
    after_both = sum(1 for s in proved
                     if (ida_funcs.get_func(s) and ida_funcs.get_func(s).start_ea == s)
                     and has_incoming_xref(s))

    lost = [s for s in proved
            if not ((ida_funcs.get_func(s) and ida_funcs.get_func(s).start_ea == s) and has_incoming_xref(s))]

    with open(os.path.join(OUTDIR, "survival.txt"), "w", encoding="utf-8", newline="\n") as h:
        h.write("G2 table->target xref survival test\n")
        h.write("=" * 48 + "\n")
        h.write("table-xrefs.tsv rows (live targets): %d\n" % n_rows)
        h.write("xrefs applied: %d   funcs promoted: %d\n\n" % (xrefs, funcs))
        h.write("proved functions tracked: %d\n\n" % len(proved))
        h.write("BEFORE apply+reanalyse:\n")
        h.write("  still a function at start: %d / %d\n" % (before_func, len(proved)))
        h.write("  has incoming xref:         %d / %d\n\n" % (before_xref, len(proved)))
        h.write("AFTER apply+reanalyse:\n")
        h.write("  still a function at start: %d / %d\n" % (after_func, len(proved)))
        h.write("  has incoming xref:         %d / %d\n" % (after_xref, len(proved)))
        h.write("  function AND incoming xref: %d / %d\n\n" % (after_both, len(proved)))
        h.write("survivors (function + xref) = %d / %d = %.1f%%\n" % (
            after_both, len(proved), 100.0 * after_both / len(proved)))
        h.write("\nlost (%d): %s\n" % (len(lost), ",".join("%06X" % s for s in lost[:60])))


if __name__ == "__main__":
    try:
        main()
    except Exception:
        with open(os.path.join(OUTDIR, "survival_tb.txt"), "w", encoding="utf-8", newline="\n") as h:
            h.write(traceback.format_exc())
    finally:
        idc.qexit(0)
