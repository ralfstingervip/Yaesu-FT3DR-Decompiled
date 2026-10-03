r"""Lane N8: what RAM address 0 holds for the live jsr 0.
Two sites FFEE2220 and FFEE223B (bytes 66 03 7f 13 = mov.l #0,r3 ; jsr r3).
Find the enclosing functions, their callers (live path?), and every writer of
RAM address 0. Reach check via xrefs. Reopen/seed from K7_SUB_FINAL3."""
from __future__ import annotations
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root
import os, traceback

OUT = str(_REPO / "ida/out/jsr0")

def esc(t):
    return (t or "").replace("\t"," ").replace("\r"," ").replace("\n"," ")

def main():
    import ida_funcs, ida_bytes, idc, ida_xref, ida_ua, idautils, ida_auto, ida_segment
    ida_auto.auto_wait()
    SITES = (0xFFEE2220, 0xFFEE223B)

    def dump_xrefs(h, ea, label):
        refs=[]
        xr=ida_xref.xrefblk_t()
        ok=xr.first_to(ea, ida_xref.XREF_ALL)
        while ok:
            refs.append((xr.frm, xr.iscode, xr.type)); ok=xr.next_to()
        h.write("  xrefs TO %s %08X (%d): %s\n" % (label, ea, len(refs),
            ", ".join("%08X(c%d,t%d)"%(f,c,t) for f,c,t in refs)))
        return refs

    def func_of(ea):
        f=ida_funcs.get_func(ea)
        return f

    with open(os.path.join(OUT,"ctx.txt"),"w",encoding="utf-8",newline="\n") as h:
        for site in SITES:
            h.write("\n########## SITE %08X ##########\n"%site)
            f=func_of(site)
            if f:
                h.write("enclosing func %08X..%08X name=%s\n"%(f.start_ea,f.end_ea,idc.get_func_name(f.start_ea) or ""))
            else:
                h.write("NO FUNC at %08X\n"%site)
            # bytes at site
            h.write("bytes@site: %s\n"%(ida_bytes.get_bytes(site,8) or b"").hex())
            dump_xrefs(h, site, "site")
            if f:
                dump_xrefs(h, f.start_ea, "funcstart")
                # linear disasm of enclosing func (+ a little before)
                a=f.start_ea; end=f.end_ea
                h.write("-- linear %08X..%08X --\n"%(a,end))
                while a < end and a!=idc.BADADDR:
                    fl=ida_bytes.get_flags(a); size=idc.get_item_size(a)
                    raw=(ida_bytes.get_bytes(a,min(size,12)) or b"").hex()
                    line=esc(idc.generate_disasm_line(a,0))
                    tag="C" if ida_bytes.is_code(fl) else ("D" if ida_bytes.is_data(fl) else "U")
                    mark=" <<< JSR0" if a==site else ""
                    h.write("  %08X [%s] %-24s %s%s\n"%(a,tag,raw,line,mark))
                    nxt=idc.next_head(a,end)
                    a=nxt if nxt>a else a+1

        # writers of RAM address 0: xrefs to 0,1,2,3
        h.write("\n########## XREFS TO RAM 0..3 ##########\n")
        for ea in (0,1,2,3):
            refs=[]
            xr=ida_xref.xrefblk_t()
            ok=xr.first_to(ea, ida_xref.XREF_ALL)
            while ok:
                refs.append((xr.frm,xr.iscode,xr.type)); ok=xr.next_to()
            h.write("  addr %08X: %d refs: %s\n"%(ea,len(refs),
                ", ".join("%08X(c%d,t%d)"%(f,c,t) for f,c,t in refs)))

        # fixed vector table EXTB 0xFFFFFF80 (32 entries) + reset
        h.write("\n########## FIXED VECTORS EXTB FFFFFF80..FFFFFFFF ##########\n")
        for i in range(32):
            va=0xFFFFFF80 + i*4
            val=ida_bytes.get_dword(va)
            flag=" <== ZERO" if val==0 else ""
            h.write("  [%2d] %08X -> %08X%s\n"%(i,va,val,flag))

        # relocatable vector table INTB FFED8A70 (256 entries)
        h.write("\n########## INTB VECTORS FFED8A70 (256) zero entries only ##########\n")
        zc=0
        for i in range(256):
            va=0xFFED8A70 + i*4
            val=ida_bytes.get_dword(va)
            if val==0:
                zc+=1; h.write("  [%3d] %08X -> 00000000\n"%(i,va))
        h.write("  total zero INTB entries: %d\n"%zc)

    with open(os.path.join(OUT,"ctx_status.txt"),"w",encoding="utf-8",newline="\n") as h:
        h.write("ok\n")

if True:
    os.makedirs(OUT, exist_ok=True)
    try:
        main()
    except Exception:
        with open(os.path.join(OUT,"ctx_tb.txt"),"w",encoding="utf-8",newline="\n") as _h:
            _h.write(traceback.format_exc())
    import idc as _idc
    _idc.qexit(0)
