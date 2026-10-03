from __future__ import annotations
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root
import os, traceback
OUT=str(_REPO / "ida/out/jsr0")
def esc(t): return (t or "").replace("\t"," ").replace("\r"," ").replace("\n"," ")
def main():
    import ida_funcs, ida_bytes, idc, ida_xref, ida_auto
    ida_auto.auto_wait()
    def xto(ea):
        r=[]; xr=ida_xref.xrefblk_t(); ok=xr.first_to(ea,ida_xref.XREF_ALL)
        while ok: r.append((xr.frm,xr.iscode,xr.type)); ok=xr.next_to()
        return r
    def disf(h,ea):
        f=ida_funcs.get_func(ea)
        if not f: h.write("  NO FUNC @%08X\n"%ea); return None
        h.write(">> func %08X..%08X %s  (callers: %s)\n"%(f.start_ea,f.end_ea,
            idc.get_func_name(f.start_ea) or "",
            ", ".join("%08X"%c[0] for c in xto(f.start_ea))))
        a=f.start_ea
        while a<f.end_ea and a!=idc.BADADDR:
            raw=(ida_bytes.get_bytes(a,min(idc.get_item_size(a),12)) or b"").hex()
            h.write("   %08X %-24s %s\n"%(a,raw,esc(idc.generate_disasm_line(a,0))))
            nxt=idc.next_head(a,f.end_ea); a=nxt if nxt>a else a+1
        return f
    with open(os.path.join(OUT,"callers.txt"),"w",encoding="utf-8",newline="\n") as h:
        # level 1 callers
        for site,caller in ((0xFFEE2208,0xFFEE19C0),(0xFFEE2225,0xFFEE1A21)):
            h.write("\n===== caller of %08X =====\n"%site)
            f=disf(h,caller)
            # level 2: who calls the caller
            if f:
                h.write("  --- callers of %08X ---\n"%f.start_ea)
                for c in xto(f.start_ea):
                    cf=ida_funcs.get_func(c[0])
                    h.write("    from %08X in func %s\n"%(c[0], ("%08X"%cf.start_ea if cf else "none")))
    with open(os.path.join(OUT,"callers_status.txt"),"w") as h: h.write("ok\n")
if True:
    os.makedirs(OUT,exist_ok=True)
    try: main()
    except Exception:
        open(os.path.join(OUT,"callers_tb.txt"),"w").write(traceback.format_exc())
    import idc as _idc; _idc.qexit(0)
