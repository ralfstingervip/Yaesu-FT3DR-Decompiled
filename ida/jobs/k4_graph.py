# -*- coding: utf-8 -*-
r"""Lane K4. Read-only. Whole-image (MAIN 0..0x80000, closed window 0x078106-0x07B753 skipped)
call/jump edge list and RAM data-ref list, for offline reachability of the auto-TX senders.
Writes to env K4_OUTDIR: edges.tsv (src_ea, src_func, dst, kind, disasm), drefs.tsv (ea, func, addr, mnem, disasm)."""
from __future__ import annotations
import os, traceback
import ida_auto, idc, ida_funcs, idautils, ida_xref, ida_ua

OUTD = os.environ.get("K4_OUTDIR", "")
LO, HI = 0x0, 0x80000
CW_LO, CW_HI = 0x078106, 0x07B754


def main():
    ida_auto.auto_wait()
    e = open(os.path.join(OUTD, "edges.tsv"), "w", encoding="utf-8", newline="\n")
    d = open(os.path.join(OUTD, "drefs.tsv"), "w", encoding="utf-8", newline="\n")
    e.write("src_ea\tsrc_func\tdst\tkind\tdisasm\n")
    d.write("ea\tfunc\taddr\tmnem\tdisasm\n")
    import ida_bytes
    heads = []
    ea = LO
    while ea < HI and ea != idc.BADADDR:
        if idc.is_code(idc.get_full_flags(ea)):
            heads.append(ea)
        ea = idc.next_head(ea, HI)
    for fs in [0]:
        for ea in heads:
            f = ida_funcs.get_func(ea)
            fs = f.start_ea if f else 0xFFFFFF
            if CW_LO <= ea < CW_HI:
                continue
            if not idc.is_code(idc.get_full_flags(ea)):
                continue
            dis = idc.generate_disasm_line(ea, 0) or ""
            mn = idc.print_insn_mnem(ea)
            nxt = ea + idc.get_item_size(ea)
            for x in idautils.XrefsFrom(ea, 0):
                if x.iscode:
                    if x.type == ida_xref.fl_F or x.to == nxt:
                        continue
                    kind = {ida_xref.fl_CN: "call", ida_xref.fl_CF: "callfar", ida_xref.fl_JN: "jump", ida_xref.fl_JF: "jumpfar"}.get(x.type, "c%d" % x.type)
                    e.write("%06X\t%06X\t%06X\t%s\t%s\n" % (ea, fs, x.to, kind, dis))
                else:
                    to = x.to
                    if to >= 0xFF000000:
                        to &= 0xFFFFFF
                    if to >= 0xFE0000 or to < 0x80000:
                        d.write("%06X\t%06X\t%06X\t%s\t%s\n" % (ea, fs, to, mn, dis))
    e.close(); d.close()
    with open(os.path.join(OUTD, "funcs.tsv"), "w", encoding="utf-8", newline="\n") as h:
        for fs in idautils.Functions(LO, HI):
            f = ida_funcs.get_func(fs)
            h.write("%06X\t%06X\t%s\n" % (f.start_ea, f.end_ea, ida_funcs.get_func_name(fs)))


try:
    main()
except Exception:
    with open(os.path.join(OUTD or ".", "k4_graph_tb.txt"), "w", encoding="utf-8") as h:
        h.write(traceback.format_exc())
finally:
    idc.qexit(0)
