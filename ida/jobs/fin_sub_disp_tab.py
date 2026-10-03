r"""Lane F3 -- identify the pointer table that references sub_FFF4C9D1 and its callers.

    python "ida/run_job.py" --script ida\jobs\fin_sub_disp_tab.py --db FIN_SUB_DISP --reopen
"""
from __future__ import annotations
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root
import os, traceback
OUT = str(_REPO / "ida/out/sub-big")
STATUS = os.path.join(OUT, "tab_status.txt")
def log(t):
    with open(STATUS,"a",encoding="utf-8",newline="\n") as h: h.write(t+"\n")

def main():
    import ida_bytes, ida_funcs, idautils, idc, ida_auto, ida_name
    ida_auto.auto_wait()
    TARGET=0xFFF4C9D1
    PTR=0xFFEDE824

    def nm(a):
        n=idc.get_name(a) or ""
        f=ida_funcs.get_func(a)
        fn=idc.get_func_name(a) if f else ""
        return n or fn

    # 1) dump the dword table around FFEDE824 widely, resolve pointers
    log("== dword table around %08X ==" % PTR)
    lo=PTR-0x80; hi=PTR+0x80
    a=lo
    while a<hi:
        v=ida_bytes.get_dword(a)
        tgtf=ida_funcs.get_func(v)
        kind=""
        if tgtf is not None and 0xFFC00000<=v<=0xFFFFFFFF:
            kind="FUNC %s%s"%(idc.get_func_name(v), " <== TARGET" if v==TARGET else "")
        elif 0xFFC00000<=v<=0xFFFFFFFF:
            kind="codeptr? %s"%(nm(v))
        mark=" <<<<" if a==PTR else ""
        log("  %08X: %08X  %s%s"%(a,v,kind,mark))
        a+=4

    # 2) find the extent of the contiguous function-pointer table (scan out from PTR)
    def is_fptr(a):
        v=ida_bytes.get_dword(a)
        return ida_funcs.get_func(v) is not None and 0xFFD00000<=v<=0xFFFFFFFF
    s=PTR
    while s-4>=0xFFED0000 and is_fptr(s-4): s-=4
    e=PTR
    while e+4<0xFFF50000 and is_fptr(e+4): e+=4
    e+=4
    cnt=(e-s)//4
    log("contiguous fptr table: %08X..%08X  count=%d"%(s,e,cnt))
    tbl=[]
    for i in range(cnt):
        a=s+4*i; v=ida_bytes.get_dword(a)
        tbl.append((a,v,idc.get_func_name(v)))

    # 3) who references the table (any entry)?
    log("== xrefs to table entries ==")
    for a,v,fn in tbl:
        for xr in idautils.XrefsTo(a,0):
            log("  entry %08X (->%s) reffed by %08X type=%d iscode=%d func=%s"%(
                a,fn,xr.frm,xr.type,xr.iscode,idc.get_func_name(xr.frm)))

    # 4) xrefs to the table base + a scan for code that loads #base
    log("== xrefs to table base %08X =="%s)
    for xr in idautils.XrefsTo(s,0):
        log("  base reffed by %08X type=%d func=%s"%(xr.frm,xr.type,idc.get_func_name(xr.frm)))

    # 5) search whole window for immediate loads of the table base/PTR (mov.l #imm)
    log("== immediate loads of table base/PTR anywhere in window ==")
    import ida_ua
    ea=0xFFED0000
    targets={s:"tblbase",PTR:"PTR"}
    while ea<0xFFF50000:
        fl=ida_bytes.get_flags(ea); sz=ida_bytes.get_item_size(ea)
        if sz<=0: sz=1
        if ida_bytes.is_code(fl):
            insn=ida_ua.insn_t()
            if ida_ua.decode_insn(insn,ea)>0:
                for i in range(6):
                    op=insn.ops[i]
                    if op.type==0: break
                    if op.type==ida_ua.o_imm and op.value in targets:
                        log("  %08X loads %08X (%s) in %s"%(ea,op.value,targets[op.value],idc.get_func_name(ea)))
        ea+=sz

    # write table tsv
    with open(os.path.join(OUT,"handler_table.tsv"),"w",encoding="utf-8",newline="\n") as h:
        h.write("index\taddr\tptr\tfunc\n")
        for i,(a,v,fn) in enumerate(tbl):
            h.write("%d\t%08X\t%08X\t%s\n"%(i,a,v,fn))
    log("done cnt=%d"%cnt)

if True:
    os.makedirs(OUT,exist_ok=True)
    with open(STATUS,"w",encoding="utf-8",newline="\n") as _h: _h.write("start\n")
    try: main()
    except Exception:
        with open(os.path.join(OUT,"tab_tb.txt"),"w",encoding="utf-8",newline="\n") as _h:
            _h.write(traceback.format_exc())
        log("EXCEPTION")
    import idc as _idc; _idc.qexit(0)
