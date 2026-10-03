# -*- coding: utf-8 -*-
r"""Lane N3 - read-only dump of heads + operands from a copy of the FINAL6 seed, and xrefs into the unread pieces.

Owner-side static analysis. No patch_* call, no retyping; nothing in the DB is changed.
Run:
  python ida\run_job.py --script ida\jobs\n3_dump.py --db N3_TABLES --copy-from ida\db\jobs\M1_MAIN_FINAL6\M1_MAIN_FINAL6.i64
Outputs (ida\out\unread-tables\work\):
  n3_heads.tsv   every head 0..0x7B754: ea, size, kind, func, disasm, op0..op2 (type:value:addr:reg:dtype)
  n3_xrefs.tsv   every xref into 0x035F00-0x0377C1 and into each non-curve Inferred piece +-0x40
"""
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root
import os, traceback
import ida_auto, ida_bytes, ida_funcs, ida_ua, idautils, idc, ida_lines

ROOT = str(_REPO)
W = os.path.join(ROOT, "ida", "out", "unread-tables", "work")
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
    with open(os.path.join(W, "n3_heads.tsv"), "w", encoding="utf-8", newline="\n") as o:
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
    pieces = [(0x035F00, 0x0377C2)]
    with open(os.path.join(ROOT, "ida", "out", "inferred-tables", "pieces.tsv"), encoding="utf-8") as h:
        for ln in list(h)[1:]:
            p = ln.rstrip("\n").split("\t")
            a = int(p[0], 16)
            if p[5] == "Inferred" and not (0x035F00 <= a < 0x0377C2):
                pieces.append((a - 0x40, int(p[1], 16) + 0x40))
    with open(os.path.join(W, "n3_xrefs.tsv"), "w", encoding="utf-8", newline="\n") as x:
        x.write("window\tto\tfrom\ttype\tfrom_kind\tfrom_disasm\n")
        for a, b in pieces:
            for t in range(max(0, a), b):
                for xr in idautils.XrefsTo(t, 0):
                    hd = ida_bytes.get_item_head(xr.frm)
                    x.write("%06X\t%06X\t%06X\t%d\t%s\t%s\n" % (a, t, xr.frm, xr.type, kind(hd), txt(hd)))
    with open(os.path.join(W, "n3_dump_ok.txt"), "w", encoding="utf-8") as h:
        h.write("ok\n")


try:
    main()
except Exception:
    with open(os.path.join(W, "n3_dump_traceback.txt"), "w", encoding="utf-8") as h:
        h.write(traceback.format_exc())
idc.qexit(0)
