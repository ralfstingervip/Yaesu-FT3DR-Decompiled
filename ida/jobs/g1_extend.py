r"""Lane G1 -- extend IDA functions over the absorbed H8SX code (PRIVATE G1_H8S).

For every planned instruction still outside a function, take the maximal run of
consecutive code heads outside any function that starts there. If the code head
immediately before the run belongs to a function chunk that ends exactly at the
run start, and that head does not stop flow, grow that chunk over the run.
Repeat until nothing changes. Runs with no such predecessor are left as code
outside functions and listed.
Output ida\out\h8s-decode\work\extend.tsv
"""
from __future__ import annotations
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root
import os, json, traceback
import ida_auto, ida_bytes, ida_funcs, ida_ua, ida_idp, idc

ROOT = str(_REPO)
WORK = os.path.join(ROOT, "ida", "out", "h8s-decode", "work")
W0 = 0x078106


def is_code_head(ea):
    fl = ida_bytes.get_flags(ea)
    return ida_bytes.is_code(fl) and ida_bytes.is_head(fl)


def stops(ea):
    insn = ida_ua.insn_t()
    if ida_ua.decode_insn(insn, ea) <= 0:
        return True
    return bool(insn.get_canon_feature() & ida_idp.CF_STOP)


def run_from(a):
    e = a
    while e < W0 and is_code_head(e) and not ida_funcs.get_func(e):
        e += ida_bytes.get_item_size(e)
    return e


def main(fh):
    ida_auto.auto_wait()
    plan = json.load(open(os.path.join(WORK, "absorb_plan.json"), encoding="utf-8"))
    todo = sorted(a for a, n, t, o in plan["insns"])
    fh.write("kind\trun_start\trun_end\tfunc\tchunk_start\told_chunk_end\n")
    changed = True
    rounds = 0
    while changed and rounds < 20:
        changed = False
        rounds += 1
        for a in todo:
            if ida_funcs.get_func(a) or not is_code_head(a):
                continue
            # step back to the first head of this outside-function run
            s = a
            while True:
                p = ida_bytes.prev_head(s, 0)
                if p == idc.BADADDR or not is_code_head(p) or ida_funcs.get_func(p) or p + ida_bytes.get_item_size(p) != s:
                    break
                s = p
            p = ida_bytes.prev_head(s, 0)
            if p == idc.BADADDR or not is_code_head(p) or p + ida_bytes.get_item_size(p) != s or stops(p):
                continue
            ch = ida_funcs.get_fchunk(p)
            f = ida_funcs.get_func(p)
            if ch is None or f is None or ch.end_ea != s:
                continue
            e = run_from(s)
            old = ch.end_ea
            if ida_funcs.set_func_end(p, e):
                fh.write("extend\t%06X\t%06X\t%06X\t%06X\t%06X\n" % (s, e, f.start_ea, ch.start_ea, old))
                changed = True
    ida_auto.auto_wait()
    left = []
    for a in todo:
        if not ida_funcs.get_func(a):
            left.append(a)
    for a in left:
        fh.write("outside\t%06X\t-\t-\t-\t-\n" % a)


try:
    with open(os.path.join(WORK, "extend.tsv"), "w", encoding="utf-8", newline="\n") as fh:
        main(fh)
except Exception:
    with open(os.path.join(WORK, "extend_err.txt"), "w", encoding="utf-8") as fh:
        fh.write(traceback.format_exc())
idc.qexit(0)
