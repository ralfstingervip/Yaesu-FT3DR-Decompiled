r"""Dump disasm for the recurring helper callees and a few representative
full caller functions, so the wrapper/dispatch idioms in slice 3 can be named.
Read-only. Run with --reopen against W2_SUBP_3."""
from __future__ import annotations
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root
import os
import traceback

LOGDIR = str(_REPO / "ida/log/jobs/W2_SUBP_3")
OUT = os.path.join(LOGDIR, "helpers_disasm.txt")

TARGETS = [
    0xFFEEF9BB, 0xFFEF036F, 0xFFEFAA2B, 0xFFEF1BB1, 0xFFF03652,
    0xFFEF2505, 0xFFEE1DE8, 0xFFEE1D6D, 0xFFEF153B, 0xFFEEFA9E,
    0xFFEEFEA4, 0xFFEE1E4C, 0xFFEF1DE8,
    # representative full callers inside the slice using the triple / idioms
    0xFFEF1C48, 0xFFF1EE20, 0xFFEF2724,
    0xFFF0A95A, 0xFFF0AB1A, 0xFFF03742, 0xFFF0376D, 0xFFF03D24,
    0xFFF086A6, 0xFFF089D5, 0xFFF0DF2B, 0xFFF0B307,
]


def esc(t):
    return (t or "").replace("\t", " ").replace("\r", " ").replace("\n", " ")


def main():
    import ida_funcs
    import ida_xref
    import idc

    def callers_of(ea):
        out = []
        xr = ida_xref.xrefblk_t()
        ok = xr.first_to(ea, ida_xref.XREF_ALL)
        while ok:
            if xr.iscode and xr.type in (ida_xref.fl_CF, ida_xref.fl_CN,
                                         ida_xref.fl_JF, ida_xref.fl_JN):
                out.append(xr.frm)
            ok = xr.next_to()
        return out

    with open(OUT, "w", encoding="utf-8", newline="\n") as h:
        for ea in TARGETS:
            f = ida_funcs.get_func(ea)
            h.write("\n===== %08X =====\n" % ea)
            if f is None:
                h.write("  (no function)\n")
                continue
            cl = callers_of(f.start_ea)
            h.write("  start %08X end %08X size %d  ncallers=%d\n" % (
                f.start_ea, f.end_ea, f.end_ea - f.start_ea, len(cl)))
            cur = f.start_ea
            while cur != idc.BADADDR and cur < f.end_ea:
                line = idc.generate_disasm_line(cur, 0) or ""
                h.write("  %08X  %s\n" % (cur, esc(line)))
                cur = idc.next_head(cur, f.end_ea)


if True:
    os.makedirs(LOGDIR, exist_ok=True)
    try:
        main()
    except Exception:
        with open(os.path.join(LOGDIR, "helpers_tb.txt"), "w",
                  encoding="utf-8", newline="\n") as _h:
            _h.write(traceback.format_exc())
    import idc as _idc
    _idc.qexit(0)
