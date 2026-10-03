from __future__ import annotations
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root
import os, traceback
OUT=str(_REPO / "ida/out/jsr0")
def esc(t): return (t or "").replace("\t"," ").replace("\r"," ").replace("\n"," ")
def main():
    import ida_funcs, idc, ida_xref, ida_auto, ida_bytes
    ida_auto.auto_wait()
    def xto(ea):
        r=[]; xr=ida_xref.xrefblk_t(); ok=xr.first_to(ea,ida_xref.XREF_ALL)
        while ok: r.append(xr.frm); ok=xr.next_to()
        return r
    # walk up the call graph from a set of starts, BFS, report func names/deadness
    def name(ea):
        f=ida_funcs.get_func(ea)
        if not f: return ("no-func",None)
        return (idc.get_func_name(f.start_ea) or "", f.start_ea)
    with open(os.path.join(OUT,"up.txt"),"w",encoding="utf-8",newline="\n") as h:
        for root in (0xFFEE2208,0xFFEE2225,0xFFEE1958,0xFFEE19E4,0xFFF45E0D):
            seen=set(); frontier=[root]; depth=0
            h.write("\n===== call-graph ABOVE %08X =====\n"%root)
            cur={root}
            while cur and depth<8:
                nxt=set()
                for ea in sorted(cur):
                    nm,fs=name(ea)
                    callers=[]
                    if fs is not None:
                        for c in xto(fs):
                            cf=ida_funcs.get_func(c)
                            callers.append(cf.start_ea if cf else c)
                    h.write("  d%d %08X %-20s callers=%s\n"%(depth,ea,nm,
                        ",".join("%08X"%c for c in sorted(set(callers)))))
                    for c in set(callers):
                        if c not in seen: nxt.add(c)
                seen|=cur; cur=nxt; depth+=1
    open(os.path.join(OUT,"up_status.txt"),"w").write("ok\n")
if True:
    os.makedirs(OUT,exist_ok=True)
    try: main()
    except Exception: open(os.path.join(OUT,"up_tb.txt"),"w").write(traceback.format_exc())
    import idc as _idc; _idc.qexit(0)
