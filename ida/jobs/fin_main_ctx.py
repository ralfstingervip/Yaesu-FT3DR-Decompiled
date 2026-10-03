# -*- coding: utf-8 -*-
r"""Lane F1 context dump for the self-contained-no-ref functions: show the
preceding instruction (fall-through vs hard-stop), the function's first 2 and
last instruction, and whether the preceding owner function ends in a return.
Helps decide dead vs IDA over-split vs computed-jump. Read-only, H8S base 0."""
from __future__ import annotations
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root
import os, traceback
import ida_auto, ida_bytes, ida_ua, ida_funcs, idc

ROOT = str(_REPO)
IN = os.path.join(ROOT, "ida", "out", "main-indirect", "_dead_in.tsv")
OUTD = os.path.join(ROOT, "ida", "out", "main-indirect")
OUT = os.path.join(OUTD, "dead_ctx.tsv")
TB = os.path.join(OUTD, "dead_ctx_tb.txt")

def dis(ea):
    return (idc.generate_disasm_line(ea, 0) or "").split(";")[0].strip()

def main():
    ida_auto.auto_wait()
    addrs = []
    with open(IN, encoding="utf-8") as h:
        next(h)
        for line in h:
            s = line.strip()
            if s and not s.startswith("#"):
                addrs.append(int(s, 16))
    with open(OUT, "w", encoding="utf-8", newline="\n") as out:
        out.write("start\tprev_ea\tprev_insn\tprev_is_stop\tfirst1\tfirst2\tlast_insn\tregion\n")
        for ea in addrs:
            prev = ida_bytes.prev_head(ea, max(0, ea - 32))
            pm = (idc.print_insn_mnem(prev) or "").lower()
            prev_stop = 1 if pm in ("rts", "rte", "bra", "jmp") else 0
            prev_insn = dis(prev)
            f1 = dis(ea)
            n2 = ida_bytes.next_head(ea, ea + 64)
            f2 = dis(n2) if n2 != idc.BADADDR else ""
            # last insn of this function
            f = ida_funcs.get_func(ea)
            last = ""
            if f:
                le = ida_bytes.prev_head(f.end_ea, ea)
                last = dis(le)
            # region note: what function owns prev
            pf = ida_funcs.get_func(prev)
            region = ("prev in %06X" % pf.start_ea) if pf else "prev no-func"
            out.write("%06X\t%06X\t%s\t%d\t%s\t%s\t%s\t%s\n" % (
                ea, prev, prev_insn.replace("\t", " "), prev_stop,
                f1.replace("\t", " "), f2.replace("\t", " "),
                last.replace("\t", " "), region))

try:
    main()
except Exception:
    with open(TB, "w", encoding="utf-8", newline="\n") as h:
        h.write(traceback.format_exc())
finally:
    idc.qexit(0)
