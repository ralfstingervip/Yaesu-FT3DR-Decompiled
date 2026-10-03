# -*- coding: utf-8 -*-
r"""Lane L2 - IDA cross-check of the fnindex-only runs below 0x030000 (read-only query).

Owner-side static analysis. Opens a private copy of K1_MAIN_FINAL4 (db L2_FNIDX_LO). Makes no DB edit and
patches no byte: it only reads items, functions and cross-references and writes
ida\out\fnindex-lo\ida-xrefs.tsv and ida-items.tsv.

  python ida\run_job.py --script ida\jobs\l2_xrefs.py --db L2_FNIDX_LO --copy-from ida\db\jobs\K1_MAIN_FINAL4\K1_MAIN_FINAL4.i64
  python ida\run_job.py --script ida\jobs\l2_xrefs.py --db L2_FNIDX_LO --reopen
"""
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root
import os, traceback
import ida_auto, ida_bytes, ida_funcs, idautils, idc, ida_xref

ROOT = str(_REPO)
OUT = os.path.join(ROOT, "ida", "out", "fnindex-lo")
RUNS_TSV = os.path.join(ROOT, "ida", "out", "main-final4", "fnindex-only-runs.tsv")
LIM = 0x030000
# heads of the unproven caller regions examined offline (dead arms / unreferenced routines)
HEADS = [0x01DB3A, 0x01E870, 0x017570, 0x01758E, 0x0188D0, 0x018A94, 0x01844E, 0x018420, 0x015E64, 0x015EA8,
         0x01F4DA, 0x01F508, 0x01F916, 0x01F940, 0x01F96E, 0x022DDE, 0x01CCB0, 0x01CCFA, 0x04FB44, 0x0076D8,
         0x01C27E, 0x01D934, 0x051422, 0x051468, 0x010B44, 0x02AB92, 0x01522E]
XT = {ida_xref.fl_CF: "call_far", ida_xref.fl_CN: "call", ida_xref.fl_JF: "jmp_far", ida_xref.fl_JN: "jmp",
      ida_xref.fl_F: "flow", ida_xref.dr_O: "offset", ida_xref.dr_W: "write", ida_xref.dr_R: "read",
      ida_xref.dr_T: "text", ida_xref.dr_I: "info"}


def kind(ea):
    f = ida_bytes.get_flags(ea)
    if ida_bytes.is_code(f): return "code"
    if ida_bytes.is_data(f): return "data"
    if ida_bytes.is_tail(f): return "tail"
    return "unk"


def fn(ea):
    f = ida_funcs.get_func(ea)
    return "%06X-%06X" % (f.start_ea, f.end_ea) if f else "-"


def main():
    os.makedirs(OUT, exist_ok=True)
    ida_auto.auto_wait()
    runs = []
    for ln in open(RUNS_TSV, encoding="utf-8").read().splitlines():
        if ln.startswith("#") or ln.startswith("start"): continue
        c = ln.split("\t"); s, e = int(c[0], 16), int(c[1], 16)
        if s < LIM: runs.append((s, e))
    with open(os.path.join(OUT, "ida-xrefs.tsv"), "w", encoding="utf-8", newline="\n") as h:
        h.write("group\tto\tfrom\txtype\tfrom_kind\tfrom_head\tfrom_func\tfrom_disasm\n")
        groups = [("run %06X-%06X" % (s, e), range(s, e)) for s, e in runs] + [("head %06X" % a, [a]) for a in HEADS]
        for g, rng in groups:
            n = 0
            for ea in rng:
                for x in idautils.XrefsTo(ea, 0):
                    fh = idc.get_item_head(x.frm)
                    h.write("%s\t%06X\t%06X\t%s\t%s\t%06X\t%s\t%s\n" % (g, ea, x.frm, XT.get(x.type, str(x.type)), kind(x.frm), fh,
                                                                       fn(x.frm), idc.generate_disasm_line(fh, 0)))
                    n += 1
            h.write("%s\t-\t-\ttotal=%d\t-\t-\t-\t-\n" % (g, n))
    with open(os.path.join(OUT, "ida-items.tsv"), "w", encoding="utf-8", newline="\n") as h:
        h.write("group\tea\tkind\titem_size\tfunc\tdisasm\n")
        for s, e in runs:
            ea = s
            while ea < e:
                sz = max(1, ida_bytes.get_item_size(ea)) if ida_bytes.is_head(ida_bytes.get_flags(ea)) else 1
                h.write("run %06X\t%06X\t%s\t%d\t%s\t%s\n" % (s, ea, kind(ea), sz, fn(ea), idc.generate_disasm_line(ea, 0)))
                ea += sz
        for a in HEADS:
            h.write("head\t%06X\t%s\t%d\t%s\t%s\n" % (a, kind(a), ida_bytes.get_item_size(a), fn(a), idc.generate_disasm_line(a, 0)))


try:
    main()
except Exception:
    os.makedirs(OUT, exist_ok=True)
    with open(os.path.join(OUT, "l2_xrefs_traceback.txt"), "w", encoding="utf-8") as h:
        h.write(traceback.format_exc())
idc.qexit(0)
