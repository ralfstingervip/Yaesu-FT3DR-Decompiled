r"""Inspection helper for slice-2: dump disasm of sample reject + valid funcs."""
from __future__ import annotations
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root
import os, traceback

LOGDIR = str(_REPO / "ida/log/jobs/W2_SUBP_2")
OUTF = os.path.join(LOGDIR, "inspect.txt")

SAMPLES = [
    0xFFEFB2E2, 0xFFEFB645, 0xFFEFB430, 0xFFEF532E,
]


def main():
    import ida_funcs, ida_bytes, ida_ua, ida_idp
    import idc
    CF_STOP = getattr(ida_idp, "CF_STOP", 1)
    with open(OUTF, "w", encoding="utf-8", newline="\n") as h:
        for ea in SAMPLES:
            f = ida_funcs.get_func(ea)
            h.write("\n===== %08X =====\n" % ea)
            if f is None:
                h.write("  no func\n")
                continue
            h.write("  start %08X end %08X size %d\n" % (
                f.start_ea, f.end_ea, f.end_ea - f.start_ea))
            cur = f.start_ea
            while cur != idc.BADADDR and cur < f.end_ea:
                fl = ida_bytes.get_flags(cur)
                line = idc.generate_disasm_line(cur, 0) or ""
                iscode = ida_bytes.is_code(fl)
                stop = ""
                if iscode:
                    insn = ida_ua.insn_t()
                    if ida_ua.decode_insn(insn, cur):
                        if insn.get_canon_feature() & CF_STOP:
                            stop = "  <STOP>"
                raw = " ".join("%02X" % b for b in ida_bytes.get_bytes(cur, idc.get_item_size(cur)))
                h.write("  %08X %s %-40s [%s]%s\n" % (
                    cur, "C" if iscode else "d", line, raw, stop))
                cur = idc.next_head(cur, f.end_ea)


if True:
    try:
        main()
    except Exception:
        with open(OUTF, "a", encoding="utf-8", newline="\n") as h:
            h.write(traceback.format_exc())
    import idc as _idc
    _idc.qexit(0)
