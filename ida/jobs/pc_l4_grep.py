r"""Lane-4 grep over all function instructions. env L4_RE (python regex on disasm), L4_OUT."""
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root
import os, re, traceback
import ida_auto, ida_funcs, idautils, idc
OUT = str(_REPO / "ida/out/pc")
JOB=os.environ.get("YAESU_JOB","job"); SUF=os.environ.get("L4_OUT","grep")
try:
    ida_auto.auto_wait(); rx=re.compile(os.environ["L4_RE"]); L=[]
    for fs in idautils.Functions():
        fn=ida_funcs.get_func_name(fs)
        for it in idautils.FuncItems(fs):
            s=idc.generate_disasm_line(it,0) or ""
            if rx.search(s): L.append("%08X %-22s %s"%(it,fn,s))
    open(os.path.join(OUT,"%s_%s.txt"%(JOB,SUF)),"w",encoding="utf-8").write("\n".join(L)+"\n"); idc.qexit(0)
except Exception:
    open(os.path.join(OUT,"%s_%s_TB.txt"%(JOB,SUF)),"w").write(traceback.format_exc()); idc.qexit(1)
