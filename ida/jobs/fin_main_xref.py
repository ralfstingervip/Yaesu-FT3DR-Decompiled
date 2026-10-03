# -*- coding: utf-8 -*-
r"""Lane F1 xref verification: for every reject, dump IDA's authoritative
cref/dref sources (all types) so 'unreferenced' claims are grounded in the
live database, not a possibly-incomplete TSV. Read-only. H8S, base 0."""
from __future__ import annotations
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root
import os, traceback
import ida_auto, ida_xref, idc

ROOT = str(_REPO)
IN_TSV = os.path.join(ROOT, "ida", "out", "main-indirect", "_rejects_in.tsv")
OUTD = os.path.join(ROOT, "ida", "out", "main-indirect")
OUT = os.path.join(OUTD, "xref_live.tsv")
TB = os.path.join(OUTD, "xref_live_tb.txt")


def main():
    ida_auto.auto_wait()
    rejects = []
    with open(IN_TSV, encoding="utf-8") as h:
        next(h)
        for line in h:
            p = line.rstrip("\n").split("\t")
            if len(p) >= 1 and p[0] and not p[0].startswith("#"):
                rejects.append(int(p[0], 16))

    with open(OUT, "w", encoding="utf-8", newline="\n") as out:
        out.write("start\tncref\tndref\tcref_srcs\tdref_srcs\tcref_types\n")
        for ea in rejects:
            crefs = []
            t = ida_xref.get_first_cref_to(ea)
            while t != idc.BADADDR:
                crefs.append(t)
                t = ida_xref.get_next_cref_to(ea, t)
            drefs = []
            d = ida_xref.get_first_dref_to(ea)
            while d != idc.BADADDR:
                drefs.append(d)
                d = ida_xref.get_next_dref_to(ea, d)
            # xref type for first few crefs
            types = []
            xr = ida_xref.xrefblk_t()
            ok = xr.first_to(ea, ida_xref.XREF_ALL)
            while ok:
                types.append("%d%s" % (xr.type, "c" if xr.iscode else "d"))
                ok = xr.next_to()
            out.write("%06X\t%d\t%d\t%s\t%s\t%s\n" % (
                ea, len(crefs), len(drefs),
                ",".join("%06X" % x for x in crefs[:6]),
                ",".join("%06X" % x for x in drefs[:6]),
                ",".join(types[:8])))


try:
    main()
except Exception:
    with open(TB, "w", encoding="utf-8", newline="\n") as h:
        h.write(traceback.format_exc())
finally:
    idc.qexit(0)
