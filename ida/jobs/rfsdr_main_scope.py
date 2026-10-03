"""RF-SDR pass 4 on MAIN: find the sweep.

Builds the call graph, then reports every function that reaches both the RSSI
reader (sub_32C0 / sub_3466) and the synthesiser-tune path, and dumps the ones
that also contain a backward branch (a loop).  That is the band-scope sweep, if
one exists in MAIN.
"""

from __future__ import annotations
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root

import collections
import sys

sys.path.insert(0, str(_REPO / "ida/jobs"))

import ida_auto
import ida_bytes
import ida_funcs
import ida_ua
import ida_xref
import idautils
import idc

import rfsdr_lib as L

RSSI = {0x32C0, 0x3466}
TUNE = {0x37BA0, 0x37BA4, 0x378A2, 0x37AEA, 0x37B66, 0x37C30, 0x37C62,
        0x37A30, 0x37A3A, 0x37A4C, 0x37A56}

WINDOWS = [
    ("periodic", 0x2900, 0x3300),
    ("tune_entry", 0x37600, 0x37A10),
    ("scan_a", 0x30E0, 0x30F0),
]


@L.guard
def main() -> None:
    ida_auto.auto_wait()
    for _n, lo, hi in WINDOWS:
        L.force_code(lo, hi)
    ida_auto.auto_wait()
    for name, lo, hi in WINDOWS:
        with L.open_asm("main3_%s.asm" % name) as h:
            L.dump_range(h, lo, hi, name)

    callees = collections.defaultdict(set)
    callers = collections.defaultdict(set)
    loops = set()
    funcs = list(idautils.Functions())
    for start in funcs:
        fn = ida_funcs.get_func(start)
        if fn is None:
            continue
        ea = fn.start_ea
        while ea < fn.end_ea:
            size = ida_bytes.get_item_size(ea)
            if size <= 0:
                break
            for xr in idautils.XrefsFrom(ea, 0):
                if xr.type in (ida_xref.fl_CF, ida_xref.fl_CN):
                    callees[start].add(xr.to)
                    callers[xr.to].add(start)
                elif xr.type in (ida_xref.fl_JF, ida_xref.fl_JN):
                    if fn.start_ea <= xr.to < ea:
                        loops.add(start)
            ea += size

    def reaches(start, targets, depth=3):
        seen = {start}
        frontier = {start}
        for _ in range(depth):
            nxt = set()
            for f in frontier:
                for c in callees.get(f, ()):
                    if c in targets:
                        return True
                    cf = ida_funcs.get_func(c)
                    key = cf.start_ea if cf else c
                    if key in targets:
                        return True
                    if key not in seen:
                        seen.add(key)
                        nxt.add(key)
            frontier = nxt
        return False

    with L.open_out("main_sweep_candidates.tsv") as h:
        h.write("func\tsize\thas_loop\treaches_rssi\treaches_tune\tdirect_calls\n")
        for start in funcs:
            fn = ida_funcs.get_func(start)
            if fn is None:
                continue
            r = reaches(start, RSSI)
            t = reaches(start, TUNE)
            if r and t:
                h.write("%06X\t%d\t%s\t%s\t%s\t%s\n"
                        % (start, fn.end_ea - start,
                           "yes" if start in loops else "no", r, t,
                           ",".join("%06X" % c for c in sorted(callees.get(start, ()))[:16])))

    with L.open_out("main_callgraph.tsv") as h:
        h.write("func\tname\tsize\tloop\tcallees\n")
        for start in funcs:
            fn = ida_funcs.get_func(start)
            if fn is None:
                continue
            h.write("%06X\t%s\t%d\t%s\t%s\n"
                    % (start, idc.get_func_name(start) or "",
                       fn.end_ea - start, "yes" if start in loops else "no",
                       ",".join("%06X" % c for c in sorted(callees.get(start, ())))))

    with L.open_out("main_rssi_tune_callers.txt") as h:
        for t in sorted(RSSI | TUNE):
            h.write("=== target %06X\n" % t)
            for c in sorted(callers.get(t, ())):
                fn = ida_funcs.get_func(c)
                h.write("    caller %06X size %d loop=%s\n"
                        % (c, (fn.end_ea - fn.start_ea) if fn else 0,
                           "yes" if c in loops else "no"))


main()
