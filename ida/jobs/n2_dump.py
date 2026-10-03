# -*- coding: utf-8 -*-
r"""Lane N2 - read-only dump on private DB N2_UNNAMED (seed M1_MAIN_FINAL6).

Owner-side static analysis. No patch_* call, no DB edit.
Run:
  python ida\run_job.py --script ida\jobs\n2_dump.py --db N2_UNNAMED --copy-from ida\db\jobs\M1_MAIN_FINAL6\M1_MAIN_FINAL6.i64
Outputs (ida\out\main-final-unnamed\work\):
  n2_heads.tsv  every head 0..0x7B754: ea, size, kind, func, disasm, op0..op2 (type:value:addr:reg:dtype)
  n2_xrefs.tsv  every xref to any byte in each unnamed run +-0x80
  n2_items.tsv  items overlapping each run +-0x40
"""
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root
import os, traceback
import ida_auto, ida_bytes, ida_funcs, ida_ua, idautils, idc, ida_lines

ROOT = str(_REPO)
W = os.path.join(ROOT, "ida", "out", "main-final-unnamed", "work")
HI = 0x7B754


def kind(ea):
    f = ida_bytes.get_flags(ea)
    if ida_bytes.is_code(f): return "code"
    if ida_bytes.is_strlit(f): return "str"
    if ida_bytes.is_align(f): return "align"
    if ida_bytes.is_data(f):
        if ida_bytes.is_off0(f): return "off"
        if ida_bytes.is_byte(f): return "byte"
        if ida_bytes.is_word(f): return "word"
        if ida_bytes.is_dword(f): return "dword"
        return "data"
    if ida_bytes.is_tail(f): return "tail"
    return "unk"


def txt(ea):
    s = idc.generate_disasm_line(ea, 0) or ""
    return ida_lines.tag_remove(s).replace("\t", " ")[:100]


def main():
    ida_auto.auto_wait()
    with open(os.path.join(W, "n2_heads.tsv"), "w", encoding="utf-8", newline="\n") as o:
        o.write("ea\tsize\tkind\tfunc\tdisasm\top0\top1\top2\n")
        ea = 0
        insn = ida_ua.insn_t()
        while ea != idc.BADADDR and ea < HI:
            k = kind(ea)
            sz = ida_bytes.get_item_size(ea)
            ops = ["", "", ""]
            if k == "code" and ida_ua.decode_insn(insn, ea) > 0:
                for i in range(3):
                    op = insn.ops[i]
                    if op.type == 0: break
                    ops[i] = "%d:%X:%X:%d:%d" % (op.type, op.value & 0xFFFFFFFF, op.addr & 0xFFFFFFFF, op.reg, op.dtype)
            fn = ida_funcs.get_func(ea)
            o.write("%06X\t%d\t%s\t%s\t%s\t%s\t%s\t%s\n" % (ea, sz, k, "%06X" % fn.start_ea if fn else "", txt(ea), ops[0], ops[1], ops[2]))
            ea = ida_bytes.next_head(ea, HI)
    runs = []
    with open(os.path.join(W, "runs_in.tsv"), encoding="utf-8") as h:
        for ln in h:
            p = ln.rstrip("\n").split("\t"); runs.append((int(p[0], 16), int(p[1], 16)))
    with open(os.path.join(W, "n2_xrefs.tsv"), "w", encoding="utf-8", newline="\n") as x:
        x.write("run\tto\tfrom\ttype\tfrom_kind\tfrom_disasm\n")
        for a, b in runs:
            for t in range(max(0, a - 0x80), b + 0x80):
                for xr in idautils.XrefsTo(t, 0):
                    x.write("%06X\t%06X\t%06X\t%d\t%s\t%s\n" % (a, t, xr.frm, xr.type, kind(ida_bytes.get_item_head(xr.frm)), txt(ida_bytes.get_item_head(xr.frm))))
    with open(os.path.join(W, "n2_items.tsv"), "w", encoding="utf-8", newline="\n") as x:
        x.write("run\tea\tsize\tkind\tfunc\tdisasm\n")
        for a, b in runs:
            ea = ida_bytes.get_item_head(max(0, a - 0x40))
            while ea < b + 0x40 and ea != idc.BADADDR:
                fn = ida_funcs.get_func(ea)
                x.write("%06X\t%06X\t%d\t%s\t%s\t%s\n" % (a, ea, ida_bytes.get_item_size(ea), kind(ea), "%06X" % fn.start_ea if fn else "", txt(ea)))
                ea = ida_bytes.next_head(ea, HI)
    with open(os.path.join(W, "n2_dump_ok.txt"), "w", encoding="utf-8") as h:
        h.write("ok\n")


try:
    main()
except Exception:
    with open(os.path.join(W, "n2_dump_traceback.txt"), "w", encoding="utf-8") as h:
        h.write(traceback.format_exc())
idc.qexit(0)
