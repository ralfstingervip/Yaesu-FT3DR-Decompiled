# -*- coding: utf-8 -*-
r"""Lane H2 -- read-only: classify every table-xrefs.tsv row against the current DB.
slot state (code head / inside code / data / unk) and target state (code head, mid-insn, data, unk, odd).
Writes ida\out\h8sx-seed\work\<TAG>_tclass.tsv."""
from __future__ import annotations
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root
import os, traceback
import ida_auto, ida_bytes, ida_funcs, ida_ua, idc

ROOT = str(_REPO)
TSV = os.path.join(ROOT, "ida", "out", "main-banks", "table-xrefs.tsv")
OUT = os.path.join(ROOT, "ida", "out", "h8sx-seed", "work")
TAG = os.environ.get("H2_TAG", "seed")


def cls(ea):
    fl = ida_bytes.get_flags(ea)
    if ida_bytes.is_tail(fl):
        hd = ida_bytes.get_item_head(ea)
        hf = ida_bytes.get_flags(hd)
        if ida_bytes.is_code(hf):
            return "mid_code"
        return "mid_strlit" if ida_bytes.is_strlit(hf) else "mid_data"
    if ida_bytes.is_code(fl):
        return "code_head"
    if ida_bytes.is_data(fl):
        return "strlit" if ida_bytes.is_strlit(fl) else "data"
    return "unk"


def main():
    ida_auto.auto_wait()
    insn = ida_ua.insn_t()
    with open(TSV, encoding="utf-8") as h, open(os.path.join(OUT, "%s_tclass.tsv" % TAG), "w", encoding="utf-8", newline="\n") as o:
        next(h)
        o.write("slot\ttarget\ttable\tindex\tslot_cls\ttarget_cls\ttarget_func\ttarget_decodes\ttarget_bytes\n")
        for ln in h:
            p = ln.rstrip("\n").split("\t")
            s, t = int(p[0], 16), int(p[1], 16)
            f = ida_funcs.get_func(t)
            n = ida_ua.decode_insn(insn, t)
            o.write("%s\t%s\t%s\t%s\t%s\t%s\t%s\t%d\t%s\n" % (
                p[0], p[1], p[2], p[3], cls(s), ("odd_" if t & 1 else "") + cls(t),
                ("start" if f.start_ea == t else "inside") if f else "-", n if n > 0 else 0,
                (ida_bytes.get_bytes(t, 6) or b"").hex()))


try:
    main()
except Exception:
    with open(os.path.join(OUT, "%s_tclass_tb.txt" % TAG), "w", encoding="utf-8") as h:
        h.write(traceback.format_exc())
idc.qexit(0)
