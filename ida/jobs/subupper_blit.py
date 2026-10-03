r"""SUB-UPPER pass 3 (reopen): disassemble the blit chain and confirm the
descriptor+4 pixel pointer flows to the EXDMAC source (EDMSAR) and out to the
external LCD at 0x06000000. Dump sub_FFEF0648, sub_FFEF04F7, sub_FFEF1F90 and the
callers that set EDMSAR (sub_FFEF1F74 / sub_FFEF1F80)."""
from __future__ import annotations
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root
import os, traceback
OUT=str(_REPO / "ida/out/sub-upper")
STATUS=os.path.join(OUT,"blit_status.txt")
def log(t):
    with open(STATUS,"a",encoding="utf-8",newline="\n") as h: h.write(t+"\n")
def esc(t): return (t or "").replace("\t"," ").replace("\r"," ").replace("\n"," ")
def main():
    import ida_bytes, ida_funcs, idautils, idc, ida_auto
    ida_auto.auto_wait()
    def dump(h,ea):
        f=ida_funcs.get_func(ea)
        if f is None:
            h.write("; %08X no function\n"%ea); return
        h.write("\n=== %08X-%08X %s (size %d) ===\n"%(f.start_ea,f.end_ea,idc.get_func_name(f.start_ea) or "",f.end_ea-f.start_ea))
        e=f.start_ea
        while e<f.end_ea and e!=idc.BADADDR:
            raw=(ida_bytes.get_bytes(e,min(idc.get_item_size(e),10)) or b"").hex()
            h.write("%08X  %-22s %s\n"%(e,raw,esc(idc.generate_disasm_line(e,0))))
            e=idc.next_head(e,f.end_ea)
    targets=[0xFFEF0648,0xFFEF04F7,0xFFEF1F90,0xFFEF1F74,0xFFEF1F80,0xFFEF1FC2,0xFFEF1FDF,0xFFEF1FEB,0xFFEF1FD1]
    with open(os.path.join(OUT,"blit_chain.txt"),"w",encoding="utf-8",newline="\n") as h:
        for t in targets: dump(h,t)
        # who calls the EDMSAR setters, with a little context
        for setter in (0xFFEF1F74,0xFFEF1F80,0xFFEF1F90):
            h.write("\n--- callers of %08X ---\n"%setter)
            for xr in idautils.CodeRefsTo(setter,0):
                fn=ida_funcs.get_func(xr)
                h.write("  called from %08X (func %s)\n"%(xr, idc.get_func_name(fn.start_ea) if fn else "?"))
    log("blit chain dumped")
    # also: does sub_FFEF0648 reference a RAM framebuffer base? list its immediate loads
    with open(os.path.join(OUT,"blit_consts.txt"),"w",encoding="utf-8",newline="\n") as h:
        for t in (0xFFEF0648,0xFFEF04F7,0xFFEF68D5):
            f=ida_funcs.get_func(t)
            if not f: continue
            h.write("\n=== consts in %08X %s ===\n"%(t,idc.get_func_name(t) or ""))
            e=f.start_ea
            while e<f.end_ea and e!=idc.BADADDR:
                m=idc.print_insn_mnem(e).lower()
                if m in ("mov","movu") and "#" in (idc.print_operand(e,0) or ""):
                    v=idc.get_operand_value(e,0)
                    h.write("  %08X  %s   (#%08X)\n"%(e,esc(idc.generate_disasm_line(e,0)),v & 0xFFFFFFFF))
                e=idc.next_head(e,f.end_ea)
    log("consts dumped")
if True:
    os.makedirs(OUT,exist_ok=True)
    with open(STATUS,"w",encoding="utf-8",newline="\n") as _h: _h.write("start\n")
    try: main()
    except Exception:
        with open(os.path.join(OUT,"blit_traceback.txt"),"w",encoding="utf-8",newline="\n") as _h:
            _h.write(traceback.format_exc())
        log("EXC")
    import idc as _idc; _idc.qexit(0)
