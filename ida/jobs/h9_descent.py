r"""Lane H9 -- read-only IDA h8sxa cross-check of the H9 offline descent, on private DB H9_DESCENT
(seeded --copy-from ida\db\jobs\H1_RECOUNT\H1_RECOUNT.i64). Nothing in the DB is changed.

Inputs (written by ida\out\main-descent\offline\*.py):
  work\reached_insns.tsv   addr, oracle_len   (every instruction the H9 full descent reached, closed window excluded)
  work\probe_spans.tsv     start, end, label  (unreached recovered-code spans, weak F1 rows, entry probes)
Outputs (ida\out\main-descent\work\):
  ida_meta.txt             processor, is_code total, function count
  ida_len_check.tsv        every reached address whose IDA h8sxa decode length differs from the oracle
  ida_span_refs.tsv        for every byte-address in each probe span: IDA is_code, function, and every incoming xref
"""
from __future__ import annotations
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root
import os, traceback
import ida_auto, ida_bytes, ida_ua, ida_funcs, ida_ida, idc, idautils, ida_xref

ROOT = str(_REPO)
W = os.path.join(ROOT, "ida", "out", "main-descent", "work")
LO, HI = 0x000000, 0x07B754
CW0, CW1 = 0x078106, 0x07B754


def main():
    ida_auto.auto_wait()
    meta = []
    meta.append("procname\t%s" % ida_ida.inf_get_procname())
    tot = 0; odd = 0
    ea = LO
    if not ida_bytes.is_head(ida_bytes.get_flags(ea)):
        ea = ida_bytes.next_head(ea, HI)
    while ea != idc.BADADDR and ea < HI:
        fl = ida_bytes.get_flags(ea)
        if ida_bytes.is_code(fl):
            tot += ida_bytes.get_item_size(ea)
            if ea & 1:
                odd += 1
        ea = ida_bytes.next_head(ea, HI)
    meta.append("is_code_bytes_0_7B754\t%d" % tot)
    meta.append("odd_code_heads\t%d" % odd)
    meta.append("functions\t%d" % sum(1 for _ in idautils.Functions(LO, HI)))

    n = 0; mism = []
    insn = ida_ua.insn_t()
    for ln in open(os.path.join(W, "reached_insns.tsv"), encoding="utf-8").read().splitlines()[1:]:
        a, l = ln.split("\t")[:2]; a = int(a, 16); l = int(l)
        if CW0 <= a < CW1:
            continue
        n += 1
        sz = ida_ua.decode_insn(insn, a)
        if sz != l:
            mism.append("%06X\t%d\t%d\t%s\t%s" % (a, l, sz, idc.print_insn_mnem(a) or "-",
                                                  "code" if ida_bytes.is_code(ida_bytes.get_flags(a)) else "notcode"))
    meta.append("reached_insns_checked\t%d" % n)
    meta.append("len_mismatch\t%d" % len(mism))
    with open(os.path.join(W, "ida_len_check.tsv"), "w", encoding="utf-8", newline="\n") as f:
        f.write("addr\toracle_len\tida_len\tida_mnem\tida_item\n")
        f.write("\n".join(mism) + ("\n" if mism else ""))

    out = ["label\tspan\taddr\tis_code\thead\tfunc\txrefs_to"]
    for ln in open(os.path.join(W, "probe_spans.tsv"), encoding="utf-8").read().splitlines()[1:]:
        s, e, lab = ln.split("\t")[:3]; s = int(s, 16); e = int(e, 16)
        for a in range(s, e):
            if CW0 <= a < CW1:
                continue
            fl = ida_bytes.get_flags(a)
            refs = []
            for x in idautils.XrefsTo(a, 0):
                refs.append("%06X:%d" % (x.frm, x.type))
            head = ida_bytes.is_head(fl)
            if not refs and a != s and not head:
                continue
            fn = ida_funcs.get_func(a)
            out.append("%s\t%06X-%06X\t%06X\t%d\t%d\t%s\t%s" % (lab, s, e, a, int(ida_bytes.is_code(fl)), int(head),
                                                            ("%06X" % fn.start_ea) if fn else "-", ",".join(refs) or "-"))
    with open(os.path.join(W, "ida_span_refs.tsv"), "w", encoding="utf-8", newline="\n") as f:
        f.write("\n".join(out) + "\n")
    with open(os.path.join(W, "ida_meta.txt"), "w", encoding="utf-8", newline="\n") as f:
        f.write("\n".join(meta) + "\n")


try:
    main()
except Exception:
    os.makedirs(W, exist_ok=True)
    with open(os.path.join(W, "h9_descent.err"), "w", encoding="utf-8") as f:
        f.write(traceback.format_exc())
idc.qexit(0)
