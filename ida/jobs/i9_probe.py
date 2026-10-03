r"""Lane I9 -- read-only IDA h8sxa probe on private DB I9_MAIN (seeded --copy-from ida\db\jobs\MAIN_H8SX\MAIN_H8SX.i64).
Nothing in the DB is changed.

Inputs  (ida\out\suspect-tables\work\): probe_addrs.tsv (addr, label), check_insns.tsv (addr, oracle_len, oracle_text)
Outputs (same dir): ida_meta.txt, ida_probe.tsv, ida_len_check.tsv, i9_probe_error.txt on failure
"""
from __future__ import annotations
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root
import os, traceback
import ida_auto, ida_bytes, ida_ua, ida_funcs, ida_ida, idc, idautils, ida_lines

ROOT = str(_REPO)
W = os.path.join(ROOT, "ida", "out", "suspect-tables", "work")
XT = {0: "Data_Unknown", 1: "dr_O", 2: "dr_W", 3: "dr_R", 4: "dr_T", 5: "dr_I", 16: "fl_CF", 17: "fl_CN", 18: "fl_JF", 19: "fl_JN", 21: "fl_F"}


def kind(ea):
    fl = ida_bytes.get_flags(ea)
    if ida_bytes.is_code(fl):
        return "code"
    if ida_bytes.is_data(fl):
        return "data"
    if ida_bytes.is_tail(fl):
        return "tail"
    return "unk"


def main():
    ida_auto.auto_wait()
    meta = ["procname\t%s" % ida_ida.inf_get_procname(),
            "functions\t%d" % sum(1 for _ in idautils.Functions(0, 0x80000))]
    insn = ida_ua.insn_t()
    rows = ["addr\tlabel\tida_kind\thead\titem_start\titem_size\tdecode_len\tdisasm\tfunc_start\txrefs_to"]
    for ln in open(os.path.join(W, "probe_addrs.tsv"), encoding="utf-8").read().splitlines()[1:]:
        a, lab = ln.split("\t")[:2]
        a = int(a, 16)
        fl = ida_bytes.get_flags(a)
        hs = ida_bytes.get_item_head(a)
        sz = ida_bytes.get_item_size(hs)
        dl = ida_ua.decode_insn(insn, a)
        dis = ida_lines.tag_remove(idc.generate_disasm_line(a, 0) or "") if ida_bytes.is_head(fl) else "-"
        fn = ida_funcs.get_func(a)
        xr = ",".join("%06X:%s" % (x.frm, XT.get(x.type, str(x.type))) for x in idautils.XrefsTo(a, 0))
        rows.append("%06X\t%s\t%s\t%d\t%06X\t%d\t%d\t%s\t%s\t%s" % (a, lab, kind(a), 1 if ida_bytes.is_head(fl) else 0, hs, sz, dl,
                                                                    dis.replace("\t", " "), "%06X" % fn.start_ea if fn else "-", xr or "-"))
    with open(os.path.join(W, "ida_probe.tsv"), "w", encoding="utf-8", newline="\n") as f:
        f.write("\n".join(rows) + "\n")
    n = 0
    mism = ["addr\toracle_len\tida_len\tida_kind\toracle_text\tida_disasm"]
    notcode = 0
    nclist = ["addr\toracle_len\tida_kind\toracle_text"]
    for ln in open(os.path.join(W, "check_insns.tsv"), encoding="utf-8").read().splitlines()[1:]:
        a, l, t = ln.split("\t")[:3]
        a = int(a, 16); l = int(l)
        n += 1
        dl = ida_ua.decode_insn(insn, a)
        k = kind(a)
        if k != "code":
            notcode += 1
            nclist.append("%06X\t%d\t%s\t%s" % (a, l, k, t))
        if dl != l:
            mism.append("%06X\t%d\t%d\t%s\t%s\t%s" % (a, l, dl, k, t, idc.print_insn_mnem(a) or "-"))
    meta += ["checked_insns\t%d" % n, "len_mismatch\t%d" % (len(mism) - 1), "checked_not_ida_code\t%d" % notcode]
    with open(os.path.join(W, "ida_len_check.tsv"), "w", encoding="utf-8", newline="\n") as f:
        f.write("\n".join(mism) + "\n")
    with open(os.path.join(W, "ida_not_code.tsv"), "w", encoding="utf-8", newline="\n") as f:
        f.write("\n".join(nclist) + "\n")
    with open(os.path.join(W, "ida_meta.txt"), "w", encoding="utf-8", newline="\n") as f:
        f.write("\n".join(meta) + "\n")


try:
    main()
except Exception:
    with open(os.path.join(W, "i9_probe_error.txt"), "w", encoding="utf-8") as f:
        f.write(traceback.format_exc())
idc.qexit(0)
