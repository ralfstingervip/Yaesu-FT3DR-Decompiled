# -*- coding: utf-8 -*-
r"""Lane M5 - read-only dump of the MAIN database state for the dead-code tier audit.

Owner-side static analysis. No patch_* call, no item created or deleted by this job.
Input : ida\out\dead-code-tier\work\pieces_in.tsv (start, end_excl, len, subclass) - L5's 135 dead-code pieces
Output: ida\out\dead-code-tier\work\m5_heads.tsv   every head 0..0x7B753 (ea, size, kind, func, crefs/drefs from)
        ida\out\dead-code-tier\work\m5_idadec.tsv  IDA's own forced-code linear decode of each piece (2nd decoder)
        ida\out\dead-code-tier\work\m5_xrefs.tsv   every IDA xref whose target lies in a piece
Run   : python ida\run_job.py --script ida\jobs\m5_dump.py --db M5_DEADCODE --copy-from ida\db\jobs\L1_MAIN_FINAL5\L1_MAIN_FINAL5.i64
"""
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root
import os, traceback
import ida_auto, ida_bytes, ida_funcs, ida_ua, ida_lines, idautils, idc

ROOT = str(_REPO)
W = os.path.join(ROOT, "ida", "out", "dead-code-tier", "work")
HI = 0x7B754


def kind(ea):
    f = ida_bytes.get_flags(ea)
    if ida_bytes.is_code(f): return "code"
    if ida_bytes.is_strlit(f): return "str"
    if ida_bytes.is_align(f): return "align"
    if ida_bytes.is_data(f):
        if ida_bytes.is_off0(f): return "off"
        if ida_bytes.is_struct(f): return "struct"
        if ida_bytes.is_byte(f): return "byte"
        if ida_bytes.is_word(f): return "word"
        if ida_bytes.is_dword(f): return "dword"
        return "data"
    return "unk"


def main():
    ida_auto.auto_wait()
    pieces = []
    with open(os.path.join(W, "pieces_in.tsv"), encoding="utf-8") as h:
        for ln in h:
            p = ln.rstrip("\n").split("\t")
            pieces.append((int(p[0], 16), int(p[1], 16)))
    with open(os.path.join(W, "m5_heads.tsv"), "w", encoding="utf-8", newline="\n") as o:
        o.write("ea\tsize\tkind\tfunc\ttargets\n")
        ea = 0
        while ea != idc.BADADDR and ea < HI:
            k = kind(ea)
            tg = []
            if k == "code":
                tg = ["%X" % t for t in idautils.CodeRefsFrom(ea, 0)]
            tg += ["d%X" % t for t in idautils.DataRefsFrom(ea)]
            fn = ida_funcs.get_func(ea)
            o.write("%06X\t%d\t%s\t%s\t%s\n" % (ea, ida_bytes.get_item_size(ea), k,
                    "%06X" % fn.start_ea if fn else "", ",".join(tg)))
            ea = ida_bytes.next_head(ea, HI)
    with open(os.path.join(W, "m5_idadec.tsv"), "w", encoding="utf-8", newline="\n") as o, \
         open(os.path.join(W, "m5_xrefs.tsv"), "w", encoding="utf-8", newline="\n") as x:
        o.write("piece\tea\tsize\tdisasm\n")
        x.write("piece\tto\tfrom\ttype\tfrom_kind\n")
        for a, b in pieces:
            ea = a
            while ea < b:
                insn = ida_ua.insn_t()
                n = ida_ua.decode_insn(insn, ea)
                s = ida_lines.tag_remove(ida_lines.generate_disasm_line(ea, ida_lines.GENDSM_FORCE_CODE) or "")
                o.write("%06X\t%06X\t%d\t%s\n" % (a, ea, n, s.replace("\t", " ")[:100]))
                if n <= 0: break
                ea += n
            for t in range(a, b):
                for xr in idautils.XrefsTo(t, 0):
                    x.write("%06X\t%06X\t%06X\t%d\t%s\n" % (a, t, xr.frm, xr.type, kind(ida_bytes.get_item_head(xr.frm))))


try:
    main()
    open(os.path.join(W, "m5_dump_ok.txt"), "w").write("ok\n")
except Exception:
    with open(os.path.join(W, "m5_dump_tb.txt"), "w", encoding="utf-8", newline="\n") as h:
        h.write(traceback.format_exc())
finally:
    idc.qexit(0)
