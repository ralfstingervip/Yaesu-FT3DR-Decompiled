r"""Lane I2 -- dump the SUB DB state (read-only): segments, functions+chunks, window items,
switch infos, code xrefs out of window heads.  Tag from env I2_TAG (default 'seed').

    python ida/run_job.py --script ida\jobs\i2_state.py --db SUB_FINAL --reopen --env I2_TAG=pass1
Output: ida\out\sub-final\raw\state_<tag>\{segs.txt,funcs.tsv,items.tsv,switch.tsv,cxref.tsv,dxref.tsv,status.txt}
"""
from __future__ import annotations
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root
import os, traceback

ROOT = str(_REPO)
TAG = os.environ.get("I2_TAG", "seed")
OUT = os.path.join(ROOT, r"ida\out\sub-final\raw", "state_" + TAG)
LO, HI = 0xFFED0000, 0xFFF50A00


def log(t):
    with open(os.path.join(OUT, "status.txt"), "a", encoding="utf-8", newline="\n") as h:
        h.write(t + "\n")


def main():
    import ida_auto, ida_bytes, ida_funcs, ida_segment, ida_nalt, ida_xref, idautils, idc, ida_name
    os.makedirs(OUT, exist_ok=True)
    ida_auto.auto_wait()
    with open(os.path.join(OUT, "segs.txt"), "w", encoding="utf-8", newline="\n") as h:
        for s in idautils.Segments():
            sg = ida_segment.getseg(s)
            h.write("%08X\t%08X\t%s\t%s\tbitness=%d\n" % (sg.start_ea, sg.end_ea, ida_segment.get_segm_name(sg),
                                                       ida_segment.get_segm_class(sg), sg.bitness))
    nf = 0
    with open(os.path.join(OUT, "funcs.tsv"), "w", encoding="utf-8", newline="\n") as h:
        h.write("start\tend\tflags\tname\tchunks\n")
        for s in idautils.Functions():
            f = ida_funcs.get_func(s)
            ch = ";".join("%08X-%08X" % (a, b) for a, b in idautils.Chunks(s))
            h.write("%08X\t%08X\t%X\t%s\t%s\n" % (s, f.end_ea, f.flags, ida_name.get_name(s), ch))
            nf += 1
    nc = nd = nu = 0; cb = db = 0
    with open(os.path.join(OUT, "items.tsv"), "w", encoding="utf-8", newline="\n") as h, \
         open(os.path.join(OUT, "cxref.tsv"), "w", encoding="utf-8", newline="\n") as hx, \
         open(os.path.join(OUT, "switch.tsv"), "w", encoding="utf-8", newline="\n") as hs:
        h.write("ea\tsize\tkind\tfunc\tdtype\n")
        hx.write("from\tto\ttype\n")
        hs.write("ea\tjumps\tncases\telbase\tflags\n")
        ea = LO
        while ea < HI:
            fl = ida_bytes.get_flags(ea)
            if ida_bytes.is_code(fl) or ida_bytes.is_data(fl):
                sz = max(ida_bytes.get_item_size(ea), 1)
                f = ida_funcs.get_func(ea)
                if ida_bytes.is_code(fl):
                    k = "c"; nc += 1; cb += sz
                    for xr in idautils.XrefsFrom(ea, 0):
                        if xr.iscode and xr.type != 21:
                            hx.write("%08X\t%08X\t%d\n" % (ea, xr.to, xr.type))
                    si = ida_nalt.get_switch_info(ea)
                    if si:
                        hs.write("%08X\t%08X\t%d\t%08X\t%X\n" % (ea, si.jumps, si.get_jtable_size(), si.elbase, si.flags))
                    dt = ""
                else:
                    k = "d"; nd += 1; db += sz
                    dt = "%X" % (fl & 0xF0000000)
                h.write("%08X\t%d\t%s\t%s\t%s\n" % (ea, sz, k, ("%08X" % f.start_ea) if f else "", dt))
                ea += sz
            else:
                nu += 1
                ea += 1
    log("funcs %d ; window+past code heads %d (%d B) data items %d (%d B) unk bytes %d" % (nf, nc, cb, nd, db, nu))
    log("done")


try:
    main()
except Exception:
    os.makedirs(OUT, exist_ok=True)
    log(traceback.format_exc())
finally:
    import idc
    idc.qexit(0)
