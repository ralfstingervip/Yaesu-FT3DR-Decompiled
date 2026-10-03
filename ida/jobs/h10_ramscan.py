r"""Lane H10 -- who touches RAM 0x12D00-0x12DFF (IPC callback table at 0x12D20) and other
RAM ranges given in H10_R (hex lo-hi,...).  Read-only.

    python ida/run_job.py --script ida\jobs\h10_ramscan.py --db H10_SUB --reopen --env H10_R=12D00-12E00
Output: ida\out\sub-phase\raw\ramscan.txt
"""
from __future__ import annotations
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root
import os, traceback

RAW = str(_REPO / "ida/out/sub-phase/raw")
OUT = os.path.join(RAW, "ramscan.txt")


def main():
    import ida_auto, ida_bytes, ida_ua, ida_funcs, idautils, idc
    ida_auto.auto_wait()
    rr = []
    for it in os.environ.get("H10_R", "12D00-12E00").split(","):
        a, b = it.split("-"); rr.append((int(a, 16), int(b, 16)))
    h = open(OUT, "w", encoding="utf-8", newline="\n")
    ea = 0xFFC00000
    hits = 0
    while ea < 0xFFF50A00:
        fl = ida_bytes.get_flags(ea)
        if not ida_bytes.is_code(fl):
            ea = ida_bytes.next_head(ea, 0xFFF50A00)
            if ea == idc.BADADDR:
                break
            continue
        insn = ida_ua.insn_t(); ln = ida_ua.decode_insn(insn, ea)
        if ln > 0:
            for op in insn.ops:
                if op.type == 0:
                    break
                v = None
                if op.type == ida_ua.o_imm:
                    v = op.value & 0xFFFFFFFF
                elif op.type == ida_ua.o_mem:
                    v = op.addr
                if v is not None and any(lo <= v < hi for lo, hi in rr):
                    f = ida_funcs.get_func(ea)
                    h.write("== %08X f=%s  %s\n" % (ea, ("%08X" % f.start_ea) if f else "-", idc.GetDisasm(ea)))
                    c = ea
                    for _ in range(8):
                        c = idc.next_head(c, ea + 0x40)
                        if c == idc.BADADDR:
                            break
                        h.write("     %08X  %-14s %s\n" % (c, (ida_bytes.get_bytes(c, ida_bytes.get_item_size(c)) or b"").hex(), idc.GetDisasm(c)))
                    hits += 1
                    break
        ea += max(ln, 1)
    h.write("hits %d\n" % hits)
    h.close()


try:
    main()
except Exception:
    with open(OUT, "a", encoding="utf-8", newline="\n") as h:
        h.write(traceback.format_exc())
finally:
    import idc
    idc.qexit(0)
