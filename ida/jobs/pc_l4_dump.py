r"""Lane-4 dumper. env L4_FUNCS (comma hex), L4_XREFS (comma hex), L4_RANGES (lo-hi;..),
L4_OUT suffix. Writes ida\out\pc\<JOB>_<suffix>.txt. Read-only apart from create_insn."""
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root
import os, traceback
import ida_auto, ida_bytes, ida_funcs, ida_ua, ida_idaapi, idautils, idc
OUT = str(_REPO / "ida/out/pc")
JOB = os.environ.get("YAESU_JOB", "job"); SUF = os.environ.get("L4_OUT", "dump")
def dis(ea): return idc.generate_disasm_line(ea, 0) or ""
def eas(n):
    return [int(t,16) for t in os.environ.get(n,"").replace(" ","").split(",") if t]
def rngs(n):
    o=[]
    for p in os.environ.get(n,"").split(";"):
        if "-" in p:
            a,b=p.split("-",1); o.append((int(a,16),int(b,16)))
    return o
def fname(ea):
    f=ida_funcs.get_func(ea); return ida_funcs.get_func_name(f.start_ea) if f else "?"
def dump_func(ea,L):
    f=ida_funcs.get_func(ea)
    if f is None:
        L.append("; no func at %08X"%ea); return
    L.append("; ==== %s %08X-%08X ===="%(ida_funcs.get_func_name(f.start_ea),f.start_ea,f.end_ea))
    for it in idautils.FuncItems(f.start_ea):
        L.append("%08X  %s"%(it,dis(it)))
def dump_x(ea,L):
    L.append("; ==== xrefs TO %08X ===="%ea); n=0
    for x in idautils.XrefsTo(ea,0):
        L.append("  %08X %-22s %s"%(x.frm,fname(x.frm),dis(x.frm))); n+=1
    L.append("; (%d)"%n)
def dump_r(lo,hi,L):
    L.append("; ==== linear %08X-%08X ===="%(lo,hi)); c=lo
    while c<hi:
        L.append("%08X  %s"%(c,dis(c)))
        nh=ida_bytes.next_head(c,hi); c=nh if nh!=ida_idaapi.BADADDR and nh>c else c+1
def main():
    ida_auto.auto_wait(); L=["job %s %s"%(JOB,SUF)]
    for e in eas("L4_FUNCS"): dump_func(e,L); L.append("")
    for e in eas("L4_XREFS"): dump_x(e,L); L.append("")
    for a,b in rngs("L4_RANGES"): dump_r(a,b,L); L.append("")
    open(os.path.join(OUT,"%s_%s.txt"%(JOB,SUF)),"w",encoding="utf-8",newline="\n").write("\n".join(L)+"\n")
try:
    main(); idc.qexit(0)
except Exception:
    open(os.path.join(OUT,"%s_%s_TB.txt"%(JOB,SUF)),"w").write(traceback.format_exc()); idc.qexit(1)
