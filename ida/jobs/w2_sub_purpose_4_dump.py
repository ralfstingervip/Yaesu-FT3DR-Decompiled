r"""Dump disassembly for representative slice-4 functions to characterize the
recurring groups (42-byte leaves, hot-accessor callers, wrappers) and verify the
callee labels. Reopen-only.

    python ida\run_job.py --script ida\jobs\w2_sub_purpose_4_dump.py --db W2_SUBP_4 --reopen
"""
from __future__ import annotations
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root
import os
import traceback

OUT = str(_REPO / "ida/out/wave2")
DUMP = os.path.join(OUT, "w2_subp4_dump.txt")

WANT = [
    0xFFF15D0C,  # 9-byte leaf
    0xFFF15DCF,  # 11-byte leaf
    0xFFF12437,  # 19-byte leaf
    0xFFF1E789,  # 61-byte leaf
    0xFFF28113,  # 47-byte leaf
    0xFFF286F9,  # 112-byte leaf
    0xFFF0F802,  # state dispatcher (fn-ptr table)
]


def main():
    import ida_funcs
    import idc
    import ida_xref
    with open(DUMP, "w", encoding="utf-8", newline="\n") as h:
        for ea in WANT:
            f = ida_funcs.get_func(ea)
            h.write("\n===== %08X =====\n" % ea)
            if f is None:
                h.write("  (no function)\n")
                continue
            h.write("  start %08X end %08X size %d\n" % (
                f.start_ea, f.end_ea, f.end_ea - f.start_ea))
            # callers
            cs = []
            xr = ida_xref.xrefblk_t()
            ok = xr.first_to(f.start_ea, ida_xref.XREF_ALL)
            while ok:
                if xr.iscode and xr.type in (ida_xref.fl_CF, ida_xref.fl_CN,
                                             ida_xref.fl_JF, ida_xref.fl_JN):
                    cs.append(xr.frm)
                ok = xr.next_to()
            h.write("  callers(%d): %s\n" % (len(cs), ", ".join("%08X" % c for c in cs[:10])))
            cur = f.start_ea
            while cur != idc.BADADDR and cur < f.end_ea:
                line = idc.generate_disasm_line(cur, 0) or ""
                line = line.replace("\t", " ")
                h.write("  %08X  %s\n" % (cur, line))
                cur = idc.next_head(cur, f.end_ea)


if True:
    os.makedirs(OUT, exist_ok=True)
    try:
        main()
    except Exception:
        with open(os.path.join(OUT, "w2_subp4_dump_tb.txt"), "w", encoding="utf-8") as _h:
            _h.write(traceback.format_exc())
    import idc as _idc
    _idc.qexit(0)
