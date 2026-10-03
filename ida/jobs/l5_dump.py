# -*- coding: utf-8 -*-
r"""Lane L5 - read-only dump of the MAIN unnamed residue as the K1_MAIN_FINAL4 seed sees it.

Owner-side static analysis. No patch_* call; no DB item is changed by this job.
Input : ida\out\main-unnamed\work\runs_raw.tsv  (start, end_excl, len)
Output: ida\out\main-unnamed\work\ida_items.tsv   items overlapping each run (+1 neighbour each side)
        ida\out\main-unnamed\work\ida_xrefs.tsv   every xref whose target lies inside a run
        ida\out\main-unnamed\work\ida_heads.tsv   all code heads image-wide (ea,size,mnem,crefs-from targets)
Run:
  python ida\run_job.py --script ida\jobs\l5_dump.py --db L5_MAIN_RESIDUE --copy-from ida\db\jobs\K1_MAIN_FINAL4\K1_MAIN_FINAL4.i64
"""
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root
import os, traceback
import ida_auto, ida_bytes, ida_funcs, ida_name, idautils, idc, ida_xref, ida_nalt, ida_lines, ida_ida

ROOT = str(_REPO)
W = os.path.join(ROOT, "ida", "out", "main-unnamed", "work")
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
    if ida_bytes.is_tail(f): return "tail"
    return "unk"


def txt(ea):
    s = idc.generate_disasm_line(ea, 0) or ""
    return ida_lines.tag_remove(s).replace("\t", " ")[:90]


def main():
    ida_auto.auto_wait()
    runs = []
    with open(os.path.join(W, "runs_raw.tsv"), encoding="utf-8") as h:
        for ln in h:
            a, b, n = ln.split("\t"); runs.append((int(a, 16), int(b, 16)))
    with open(os.path.join(W, "ida_items.tsv"), "w", encoding="utf-8", newline="\n") as o, \
         open(os.path.join(W, "ida_xrefs.tsv"), "w", encoding="utf-8", newline="\n") as x:
        o.write("run\tea\tsize\tkind\tname\tfunc\tdisasm\n")
        x.write("run\tto\tfrom\ttype\tfrom_kind\tfrom_func\tfrom_disasm\n")
        for a, b in runs:
            ea = ida_bytes.get_item_head(a)
            p = ida_bytes.prev_head(ea, 0)
            seq = []
            if p != idc.BADADDR: seq.append(p)
            while ea < b and ea != idc.BADADDR:
                seq.append(ea)
                ea = ida_bytes.next_head(ea, HI + 0x100)
            if ea != idc.BADADDR: seq.append(ea)
            # include unknown bytes that are not heads: walk byte by byte through run for non-head unk
            seen = set(seq)
            for e in range(a, b):
                f = ida_bytes.get_flags(e)
                if not ida_bytes.is_head(f) and not ida_bytes.is_tail(f) and e not in seen:
                    seq.append(e); seen.add(e)
            for e in sorted(set(seq)):
                fn = ida_funcs.get_func(e)
                o.write("%06X\t%06X\t%d\t%s\t%s\t%s\t%s\n" % (a, e, ida_bytes.get_item_size(e), kind(e),
                        ida_name.get_name(e) or "", "%06X" % fn.start_ea if fn else "", txt(e)))
            for t in range(a, b):
                for xr in idautils.XrefsTo(t, 0):
                    fn = ida_funcs.get_func(xr.frm)
                    x.write("%06X\t%06X\t%06X\t%d\t%s\t%s\t%s\n" % (a, t, xr.frm, xr.type, kind(ida_bytes.get_item_head(xr.frm)),
                            "%06X" % fn.start_ea if fn else "", txt(ida_bytes.get_item_head(xr.frm))))
    with open(os.path.join(W, "ida_heads.tsv"), "w", encoding="utf-8", newline="\n") as o:
        o.write("ea\tsize\tkind\ttargets\n")
        ea = 0
        while ea != idc.BADADDR and ea < HI:
            f = ida_bytes.get_flags(ea)
            k = kind(ea)
            tg = []
            if k == "code":
                tg = ["%X" % t for t in idautils.CodeRefsFrom(ea, 0)]
            tg += ["d%X" % t for t in idautils.DataRefsFrom(ea)]
            o.write("%06X\t%d\t%s\t%s\n" % (ea, ida_bytes.get_item_size(ea), k, ",".join(tg)))
            ea = ida_bytes.next_head(ea, HI)


try:
    main()
    open(os.path.join(W, "l5_dump_ok.txt"), "w").write("ok\n")
except Exception:
    with open(os.path.join(W, "l5_dump_tb.txt"), "w", encoding="utf-8", newline="\n") as h:
        h.write(traceback.format_exc())
finally:
    idc.qexit(0)
