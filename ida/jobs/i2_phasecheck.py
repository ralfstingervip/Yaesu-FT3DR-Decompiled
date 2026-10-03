r"""Lane I2 -- phase check of a head list (read-only).  For every head in
ida\out\sub-final\target-heads.tsv (or the DB's own heads when I2_SRC=db), decode it and test
every decoded successor (fall-through unless CF_STOP, o_near branch/call targets) and every DB
code xref: a successor inside FFED0000..FFF50A00 must start a head, never land inside one.
Output ida\out\sub-final\raw\phase_<I2_TAG>.tsv

    python ida/run_job.py --script ida\jobs\i2_phasecheck.py --db SUB_FINAL --reopen --env I2_TAG=plan --env I2_SRC=plan
"""
from __future__ import annotations
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root
import os, traceback, bisect

ROOT = str(_REPO)
OUT = os.path.join(ROOT, r"ida\out\sub-final")
TAG = os.environ.get("I2_TAG", "plan")
SRC = os.environ.get("I2_SRC", "plan")
LO, HI = 0xFFED0000, 0xFFF50A00
CF_STOP = 0x1
PATH = os.path.join(OUT, "raw", "phase_%s.tsv" % TAG)


def main():
    import ida_auto, ida_bytes, ida_ua, idautils
    ida_auto.auto_wait()
    heads = {}
    if SRC == "plan":
        with open(os.path.join(OUT, "target-heads.tsv"), encoding="utf-8") as h:
            next(h)
            for ln in h:
                p = ln.split("\t")
                heads[int(p[0], 16)] = (int(p[1]), p[2])
    else:
        ea = LO
        while ea < HI:
            fl = ida_bytes.get_flags(ea)
            if ida_bytes.is_code(fl):
                sz = max(ida_bytes.get_item_size(ea), 1); heads[ea] = (sz, "db"); ea += sz
            elif ida_bytes.is_data(fl):
                ea += max(ida_bytes.get_item_size(ea), 1)
            else:
                ea += 1
    ks = sorted(heads)

    def cover(t):
        i = bisect.bisect_right(ks, t) - 1
        if i >= 0 and ks[i] < t < ks[i] + heads[ks[i]][0]:
            return ks[i]
        return None
    n = 0
    with open(PATH, "w", encoding="utf-8", newline="\n") as h:
        h.write("src\tsrc_class\tkind\ttarget\tcover_head\tcover_class\tcover_size\n")
        for ea in ks:
            insn = ida_ua.insn_t(); ln = ida_ua.decode_insn(insn, ea)
            if ln <= 0:
                h.write("%08X\t%s\tINVALID\t\t\t\t\n" % (ea, heads[ea][1])); n += 1; continue
            succ = []
            if not (insn.get_canon_feature() & CF_STOP):
                succ.append((ea + ln, "flow"))
            for op in insn.ops:
                if op.type == 0:
                    break
                if op.type in (ida_ua.o_near, ida_ua.o_far):
                    succ.append((op.addr, "branch"))
            if SRC != "plan":
                for t in idautils.CodeRefsFrom(ea, 0):
                    succ.append((t, "xref"))
            for t, k in succ:
                if LO <= t < HI:
                    c = cover(t)
                    if c is not None:
                        h.write("%08X\t%s\t%s\t%08X\t%08X\t%s\t%d\n" % (ea, heads[ea][1], k, t, c, heads[c][1], heads[c][0])); n += 1
    with open(PATH, "a", encoding="utf-8", newline="\n") as h:
        h.write("# heads %d conflicts %d\n" % (len(ks), n))


try:
    main()
except Exception:
    with open(PATH, "a", encoding="utf-8", newline="\n") as h:
        h.write(traceback.format_exc())
finally:
    import idc
    idc.qexit(0)
