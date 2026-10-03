r"""Measure the PRISTINE SUB_VEC seed with head/tail-correct instruction bytes,
to separate what was already disassembled from what lane-4 recovered.
Writes only to baseline_measure.txt (does not touch functions.tsv/coverage.txt).
"""
from __future__ import annotations
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root
import os, traceback
OUT=str(_REPO / "ida/out/sub-window")
WIN_LO=0xFFED0000; WIN_HI=0xFFF50000
def main():
    import ida_bytes, ida_funcs, idautils
    instr=data=undef=0; ea=WIN_LO
    while ea<WIN_HI:
        fl=ida_bytes.get_flags(ea)
        if ida_bytes.is_code(fl):
            sz=ida_bytes.get_item_size(ea); instr+=sz; ea+=sz if sz>0 else 1
        elif ida_bytes.is_data(fl):
            sz=ida_bytes.get_item_size(ea); data+=sz; ea+=sz if sz>0 else 1
        else:
            undef+=1; ea+=1
    heads=0; fbytes=0; nf=0
    for s in idautils.Functions(WIN_LO,WIN_HI):
        f=ida_funcs.get_func(s)
        if not f: continue
        nf+=1
        e=f.start_ea
        while e<f.end_ea:
            fl=ida_bytes.get_flags(e)
            if ida_bytes.is_code(fl):
                sz=ida_bytes.get_item_size(e); fbytes+=sz; heads+=1; e+=sz if sz>0 else 1
            else:
                e+=1
    with open(os.path.join(OUT,"baseline_measure.txt"),"w",encoding="utf-8",newline="\n") as h:
        h.write("PRISTINE SUB_VEC seed, window %08X-%08X\n"%(WIN_LO,WIN_HI))
        h.write("instruction bytes (heads+tails) %d (%.1f%%)\n"%(instr,100.0*instr/(WIN_HI-WIN_LO)))
        h.write("data-item bytes %d\n"%data)
        h.write("truly-undefined bytes %d\n"%undef)
        h.write("functions %d  instruction bytes inside functions %d  heads %d\n"%(nf,fbytes,heads))
if True:
    os.makedirs(OUT,exist_ok=True)
    try: main()
    except Exception:
        open(os.path.join(OUT,"baseline_tb.txt"),"w").write(traceback.format_exc())
    import idc as _idc; _idc.qexit(0)
