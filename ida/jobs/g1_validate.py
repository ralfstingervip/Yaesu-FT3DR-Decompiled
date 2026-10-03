r"""Lane G1 -- read-only validation dump of functions in G1_H8S.

Input  ida\out\h8s-decode\work\validate_in.txt  (one hex start per line)
Output ida\out\h8s-decode\work\validate_out.tsv
For each function: bounds, chunks, instruction count and bytes, the last
instruction of every chunk, code/data xrefs to the start, and every data
reference target its instructions make (for the RAM / I/O / ROM plausibility
check done offline).
"""
from __future__ import annotations
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root
import os, traceback
import ida_auto, ida_bytes, ida_funcs, ida_lines, ida_xref, idautils, idc

ROOT = str(_REPO)
WORK = os.path.join(ROOT, "ida", "out", "h8s-decode", "work")


def txt(ea):
    return ida_lines.tag_remove(ida_lines.generate_disasm_line(ea, 0) or "").replace("\t", " ")


def main(fh):
    ida_auto.auto_wait()
    starts = [int(x, 16) for x in open(os.path.join(WORK, "validate_in.txt"), encoding="utf-8").read().split()]
    fh.write("start\tend\tchunks\tninsn\tcode_bytes\tchunk_last\tcref_to\tcall_from\tjump_from\tdref_to\tdrefs\n")
    for s in starts:
        f = ida_funcs.get_func(s)
        if not f or f.start_ea != s:
            fh.write("%06X\t-\t0\t0\t0\tNOFUNC\t0\t\t\t0\t\n" % s)
            continue
        ninsn = 0
        cb = 0
        lasts = []
        drefs = set()
        for (cs, ce) in idautils.Chunks(s):
            last = None
            for h in idautils.Heads(cs, ce):
                if ida_bytes.is_code(ida_bytes.get_flags(h)):
                    ninsn += 1
                    cb += ida_bytes.get_item_size(h)
                    last = h
                    for d in idautils.DataRefsFrom(h):
                        drefs.add(d)
            lasts.append("%06X:%s" % (last, txt(last)) if last is not None else "none")
        calls, jumps, drefs_to = [], [], 0
        for x in idautils.XrefsTo(s, 0):
            if x.iscode:
                if x.type in (ida_xref.fl_CF, ida_xref.fl_CN):
                    calls.append("%06X" % x.frm)
                elif x.type in (ida_xref.fl_JF, ida_xref.fl_JN):
                    jumps.append("%06X" % x.frm)
            else:
                drefs_to += 1
        fh.write("%06X\t%06X\t%d\t%d\t%d\t%s\t%d\t%s\t%s\t%d\t%s\n" % (
            s, f.end_ea, len(lasts), ninsn, cb, " | ".join(lasts), len(calls) + len(jumps),
            ",".join(calls[:8]), ",".join(jumps[:8]), drefs_to, ",".join("%X" % d for d in sorted(drefs))))


try:
    with open(os.path.join(WORK, "validate_out.tsv"), "w", encoding="utf-8", newline="\n") as fh:
        main(fh)
except Exception:
    with open(os.path.join(WORK, "validate_err.txt"), "w", encoding="utf-8") as fh:
        fh.write(traceback.format_exc())
idc.qexit(0)
