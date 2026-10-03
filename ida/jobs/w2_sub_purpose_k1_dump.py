r"""Wave-2 slice-1 manual-review helper: dump full disassembly for a curated set
of functions so vague/notable purposes can be verified by hand. Read-only.

    python ida\run_job.py --script ida\jobs\w2_sub_purpose_k1_dump.py --db W2_SUBP_1 --reopen
"""
from __future__ import annotations
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root
import os, traceback

OUT = str(_REPO / "ida/out/wave2")
DUMP = os.path.join(OUT, "review_dump.txt")

TARGETS = [
    0xFFEDB14B, 0xFFEDE387, 0xFFEE1868, 0xFFEE2248, 0xFFEE2E69, 0xFFEE3A1C,
    0xFFEE3EF7, 0xFFEE4421, 0xFFEE837F, 0xFFEEA1AE, 0xFFEEF315,
    0xFFEE47E7, 0xFFEE1780, 0xFFEE21BD, 0xFFEE81C6, 0xFFEF13F4,
    0xFFEE6AE4, 0xFFEF3715, 0xFFEE61B1, 0xFFEE4EDD, 0xFFEE3F5E,
    0xFFEDE5D0, 0xFFEEB728,
]


def main():
    import ida_funcs, idc, ida_ua, ida_bytes

    with open(DUMP, "w", encoding="utf-8", newline="\n") as h:
        for t in TARGETS:
            f = ida_funcs.get_func(t)
            s = t
            e = f.end_ea if f else (t + 0x60)
            # extend a little past end to see over-split continuation
            elim = e + 0x40
            h.write("\n===== %08X (func %08X..%08X) callers:" % (t, s, e))
            import idautils
            cs = [x.frm for x in idautils.XrefsTo(s, 0) if x.iscode]
            h.write(",".join("%08X" % c for c in cs[:6]) + " =====\n")
            ea = s
            while ea < elim:
                if ea == e:
                    h.write("      ---- func end ----\n")
                dis = idc.GetDisasm(ea) or "?"
                b = ida_bytes.get_bytes(ea, min(6, idc.get_item_size(ea))) or b""
                h.write("  %08X  %-16s  %s\n" % (ea, b.hex(), dis))
                nx = idc.next_head(ea, elim + 8)
                if nx <= ea:
                    break
                ea = nx
    print("wrote", DUMP)


if True:
    os.makedirs(OUT, exist_ok=True)
    try:
        main()
    except Exception:
        with open(os.path.join(OUT, "review_tb.txt"), "w", encoding="utf-8", newline="\n") as _h:
            _h.write(traceback.format_exc())
    import idc as _idc
    _idc.qexit(0)
