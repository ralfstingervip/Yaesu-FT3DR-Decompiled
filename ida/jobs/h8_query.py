r"""Lane H8 -- dump decoded instructions (linear decode, not IDA items) at given addresses.

    python ida/run_job.py --script ida\jobs\h8_query.py --db H8_SUBGAP --reopen --env H8_Q=FFEDF024:4,FFEEC130:30
Output: ida\out\sub-gap\raw\query.txt (appended).
"""
from __future__ import annotations
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root
import os, traceback

RAW = str(_REPO / "ida/out/sub-gap/raw")
OUT = os.path.join(RAW, "query.txt")


def main():
    import ida_auto, ida_bytes, ida_ua, ida_funcs, idautils, idc
    ida_auto.auto_wait()
    q = os.environ.get("H8_Q", "")
    with open(OUT, "a", encoding="utf-8", newline="\n") as h:
        for item in q.split(","):
            if not item:
                continue
            a, n = item.split(":")
            ea = int(a, 16); n = int(n)
            h.write("== %08X x%d\n" % (ea, n))
            for _ in range(n):
                insn = ida_ua.insn_t(); ln = ida_ua.decode_insn(insn, ea)
                fl = ida_bytes.get_flags(ea)
                st = "C" if ida_bytes.is_code(fl) else ("D" if ida_bytes.is_data(fl) else ("t" if ida_bytes.is_tail(fl) else "u"))
                f = ida_funcs.get_func(ea)
                xr = ";".join("%08X:%d" % (x.frm, x.type) for x in idautils.XrefsTo(ea, 0))
                if ln <= 0:
                    h.write("%08X %s %02X  <invalid>\n" % (ea, st, ida_bytes.get_byte(ea)))
                    ea += 1
                    continue
                bb = (ida_bytes.get_bytes(ea, ln) or b"").hex()
                ops = []
                for op in insn.ops:
                    if op.type == 0:
                        break
                    ops.append("t%d a%X v%X" % (op.type, op.addr, op.value & 0xFFFFFFFF))
                h.write("%08X %s %-16s %-28s f=%s xr=%s [%s]\n" % (
                    ea, st, bb, idc.GetDisasm(ea) if st == "C" else insn.get_canon_mnem(),
                    ("%08X" % f.start_ea) if f else "-", xr, "|".join(ops)))
                ea += ln


try:
    main()
except Exception:
    with open(OUT, "a", encoding="utf-8", newline="\n") as h:
        h.write(traceback.format_exc())
finally:
    import idc
    idc.qexit(0)
