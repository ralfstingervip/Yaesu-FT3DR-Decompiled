r"""Lane F3 -- disassemble the setup/caller sub_FFEDE804 and trace callers up.
    python "ida/run_job.py" --script ida\jobs\fin_sub_disp_caller.py --db FIN_SUB_DISP --reopen
"""
from __future__ import annotations
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root
import os, traceback
OUT = str(_REPO / "ida/out/sub-big")
STATUS = os.path.join(OUT, "caller_status.txt")
def log(t):
    with open(STATUS,"a",encoding="utf-8",newline="\n") as h: h.write(t+"\n")

def main():
    import ida_bytes, ida_funcs, ida_ua, ida_lines, idautils, idc, ida_auto
    ida_auto.auto_wait()
    def clean(s): return ida_lines.tag_remove(s)
    def hexb(ea,n):
        bs=ida_bytes.get_bytes(ea,n) or b""; return " ".join("%02x"%x for x in bs)

    def dump_fn(fp, start, label):
        f=ida_funcs.get_func(start)
        if not f:
            fp.write("; NO FUNC at %08X\n"%start); return None
        fp.write("; === %s  %08X-%08X (%d bytes)  name=%s ===\n"%(
            label,f.start_ea,f.end_ea,f.end_ea-f.start_ea,idc.get_func_name(start)))
        ea=f.start_ea
        while ea<f.end_ea:
            sz=ida_bytes.get_item_size(ea) or 1
            dis=clean(idc.generate_disasm_line(ea,0) or "")
            cmt=idc.get_cmt(ea,0) or ""
            fp.write("%08X  %-20s  %s%s\n"%(ea,hexb(ea,min(sz,12)),dis,("   ; "+cmt) if cmt else ""))
            ea+=sz
        fp.write("\n")
        return f

    CALLER=0xFFEDE804
    with open(os.path.join(OUT,"caller.lst"),"w",encoding="utf-8",newline="\n") as fp:
        f=dump_fn(fp, CALLER, "SETUP/CALLER sub_FFEDE804")
        # who calls sub_FFEDE804
        callers=set()
        for xr in idautils.XrefsTo(CALLER,0):
            callers.add(xr.frm)
            fp.write("; xrefTo %08X: from %08X type=%d iscode=%d func=%s\n"%(
                CALLER,xr.frm,xr.type,xr.iscode,idc.get_func_name(xr.frm)))
        fp.write("\n")
        # dump each distinct calling function (one level up)
        seen=set()
        for frm in sorted(callers):
            cf=ida_funcs.get_func(frm)
            if cf and cf.start_ea not in seen:
                seen.add(cf.start_ea)
                dump_fn(fp, cf.start_ea, "CALLER-OF-CALLER")
                for xr in idautils.XrefsTo(cf.start_ea,0):
                    fp.write("; (L2) xrefTo %08X from %08X func=%s\n"%(cf.start_ea,xr.frm,idc.get_func_name(xr.frm)))
                fp.write("\n")

    # Look for nearby string constants referenced by caller / caller-of-caller (subsystem hint)
    log("caller dumped; callers=%s"%(",".join("%08X"%c for c in sorted(callers)) if callers else "NONE"))

if True:
    os.makedirs(OUT,exist_ok=True)
    with open(STATUS,"w",encoding="utf-8",newline="\n") as _h: _h.write("start\n")
    try: main()
    except Exception:
        with open(os.path.join(OUT,"caller_tb.txt"),"w",encoding="utf-8",newline="\n") as _h:
            _h.write(traceback.format_exc())
        log("EXCEPTION")
    import idc as _idc; _idc.qexit(0)
