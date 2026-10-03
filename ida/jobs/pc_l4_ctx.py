r"""Lane-4: for each insn matching L4_RE print it plus next L4_N insns. L4_OUT suffix."""
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root
import os, re, traceback
import ida_auto, ida_funcs, idautils, idc, ida_bytes
OUT = str(_REPO / "ida/out/pc")
JOB=os.environ.get("YAESU_JOB","job"); SUF=os.environ.get("L4_OUT","ctx")
try:
    ida_auto.auto_wait(); rx=re.compile(os.environ["L4_RE"]); N=int(os.environ.get("L4_N","4")); L=[]
    for fs in idautils.Functions():
        fn=ida_funcs.get_func_name(fs)
        items=list(idautils.FuncItems(fs))
        for i,it in enumerate(items):
            s=idc.generate_disasm_line(it,0) or ""
            if rx.search(s):
                L.append("-- %s"%fn)
                for j in items[i:i+N+1]: L.append("%08X  %s"%(j,idc.generate_disasm_line(j,0)))
    open(os.path.join(OUT,"%s_%s.txt"%(JOB,SUF)),"w",encoding="utf-8").write("\n".join(L)+"\n"); idc.qexit(0)
except Exception:
    open(os.path.join(OUT,"%s_%s_TB.txt"%(JOB,SUF)),"w").write(traceback.format_exc()); idc.qexit(1)
