r"""Lane F3 -- prove FFF4C9D1 is a real instruction boundary (not a mid-insn over-split).
    python "ida/run_job.py" --script ida\jobs\fin_sub_disp_verify.py --db FIN_SUB_DISP --reopen
"""
from __future__ import annotations
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root
import os, traceback
OUT = str(_REPO / "ida/out/sub-big")
STATUS = os.path.join(OUT, "verify_status.txt")
def log(t):
    with open(STATUS,"a",encoding="utf-8",newline="\n") as h: h.write(t+"\n")

def main():
    import ida_bytes, ida_ua, ida_funcs, idautils, idc, ida_auto, ida_lines
    ida_auto.auto_wait()
    CF_STOP=0x00001
    T=0xFFF4C9D1
    def clean(s): return ida_lines.tag_remove(s)
    def hb(ea,n):
        b=ida_bytes.get_bytes(ea,n) or b""; return " ".join("%02x"%x for x in b)

    # 1) IDA's own view of the boundary
    fl=ida_bytes.get_flags(T)
    log("FFF4C9D1 is_code=%d is_head=%d is_tail=%d item_size=%d  bytes=%s  dis=%s"%(
        ida_bytes.is_code(fl), ida_bytes.is_head(fl), ida_bytes.is_tail(fl),
        ida_bytes.get_item_size(T), hb(T,4), clean(idc.generate_disasm_line(T,0) or "")))
    ph=idc.prev_head(T, T-0x40)
    phsz=ida_bytes.get_item_size(ph)
    insn=ida_ua.insn_t(); ida_ua.decode_insn(insn,ph)
    stop=bool(insn.get_canon_feature()&CF_STOP)
    log("prev_head=%08X size=%d end=%08X stop=%d  dis=%s"%(ph,phsz,ph+phsz,stop,clean(idc.generate_disasm_line(ph,0) or "")))
    log("  -> prev_head ends exactly at T? %s"%(ph+phsz==T))

    # 2) raw bytes across the boundary
    log("raw FFF4C9C8..FFF4C9DB: %s"%hb(0xFFF4C9C8,0x14))

    # 3) forward linear decode from each trusted (xref-reached) anchor; does any
    #    instruction STRADDLE T, and is T hit as a head?
    for anchor in (0xFFF4C442, 0xFFF4C97E):
        ea=anchor; straddle=None; hit=False; bad=0; n=0
        while ea < T+2:
            ln=ida_ua.decode_insn(ida_ua.insn_t(), ea)
            if ln<=0: bad+=1; ea+=1; continue
            n+=1
            if ea==T: hit=True
            if ea<T<ea+ln: straddle=(ea,ln)
            if ea>T: break
            ea+=ln
        log("anchor %08X: insns=%d bad=%d  T_is_head=%s  straddling_insn=%s"%(
            anchor,n,bad,hit,("%08X len=%d"%straddle if straddle else "NONE")))

    # 4) F4-bug pattern check: is there a C5/CF/3C/.. mov.b whose body would absorb 6e 6d?
    #    look at the two bytes before T as a possible opcode start
    for off in (1,2,3,4):
        a=T-off
        ln=ida_ua.decode_insn(ida_ua.insn_t(),a)
        log("decode @T-%d (%08X bytes %s): len=%d dis=%s%s"%(
            off,a,hb(a,min(off+2,6)),ln, clean(idc.generate_disasm_line(a,0) or ""),
            "  [would straddle T]" if 0<ln and a<T<a+ln else ""))

    # 5) xref nature of each
    for s in (0xFFF4C97E,T):
        rs=["%08X(t%d,code%d)"%(x.frm,x.type,x.iscode) for x in idautils.XrefsTo(s,0)]
        f=ida_funcs.get_func(s)
        log("%08X func=%08X-%08X xrefs=%s"%(s, f.start_ea if f else 0, f.end_ea if f else 0, ";".join(rs) or "NONE"))
    log("done")

if True:
    os.makedirs(OUT,exist_ok=True)
    with open(STATUS,"w",encoding="utf-8",newline="\n") as _h: _h.write("start\n")
    try: main()
    except Exception:
        with open(os.path.join(OUT,"verify_tb.txt"),"w",encoding="utf-8",newline="\n") as _h:
            _h.write(traceback.format_exc())
        log("EXCEPTION")
    import idc as _idc; _idc.qexit(0)
