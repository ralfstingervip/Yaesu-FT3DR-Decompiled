# -*- coding: utf-8 -*-
r"""Lane M6 - read-only dump of code heads + operands, and items/xrefs around the L5 Inferred pieces.

Owner-side static analysis. No patch_* call; nothing in the DB is changed.
Run:
  python ida\run_job.py --script ida\jobs\m6_dump.py --db M6_TABLES --copy-from ida\db\jobs\L1_MAIN_FINAL5\L1_MAIN_FINAL5.i64
Outputs (ida\out\inferred-tables\work\):
  m6_heads.tsv   every head 0..0x7B754: ea, size, kind, disasm, op0..op2 (type:value:addr:reg)
  m6_items.tsv   items overlapping each piece +-0x40
  m6_xrefs.tsv   xrefs into each piece +-0x40
"""
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root
import os, traceback
import ida_auto, ida_bytes, ida_funcs, ida_ua, idautils, idc, ida_lines

ROOT = str(_REPO)
W = os.path.join(ROOT, "ida", "out", "inferred-tables", "work")
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
    with open(os.path.join(W, "m6_heads.tsv"), "w", encoding="utf-8", newline="\n") as o:
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
    pieces = []
    with open(os.path.join(W, "pieces_in.tsv"), encoding="utf-8") as h:
        for ln in h:
            p = ln.rstrip("\n").split("\t"); pieces.append((int(p[0], 16), int(p[1], 16)))
    pieces.append((0x069A7F, 0x069AAA))
    with open(os.path.join(W, "m6_xrefs.tsv"), "w", encoding="utf-8", newline="\n") as x:
        x.write("piece\tto\tfrom\ttype\tfrom_kind\tfrom_disasm\n")
        for a, b in pieces:
            for t in range(max(0, a - 0x40), b + 0x40):
                for xr in idautils.XrefsTo(t, 0):
                    x.write("%06X\t%06X\t%06X\t%d\t%s\t%s\n" % (a, t, xr.frm, xr.type, kind(ida_bytes.get_item_head(xr.frm)), txt(ida_bytes.get_item_head(xr.frm))))
    with open(os.path.join(W, "m6_dump_ok.txt"), "w", encoding="utf-8") as h:
        h.write("ok\n")


try:
    main()
except Exception:
    with open(os.path.join(W, "m6_dump_traceback.txt"), "w", encoding="utf-8") as h:
        h.write(traceback.format_exc())
idc.qexit(0)
