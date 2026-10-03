r"""Lane 4 final measurement -- CORRECT instruction-byte accounting.

Prior passes (and SUB_VEC's coverage) counted ida_bytes.is_code() per byte, which
is true only for instruction HEAD bytes; multi-byte-instruction TAIL bytes are
FF_TAIL and were miscounted as 'undefined'. This pass measures true instruction
bytes = sum of item sizes of instruction heads, and re-classifies functions with
the same head/tail-correct accounting.

    python ida/run_job.py --script ida\jobs\full_l4_final.py --db SUB_WINDOW --reopen
"""
from __future__ import annotations
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root
import os, traceback

OUT = str(_REPO / "ida/out/sub-window")
BASE = 0xFFC00000
WIN_LO = 0xFFED0000
WIN_HI = 0xFFF50000
STATUS = os.path.join(OUT, "l4_final_status.txt")
CF_STOP = 0x00001
PERIPH = {
    0x0008A000:"SCI0",0x0008A002:"SCI0.SCR",0x0008A004:"SCI0.SSR",0x0008A005:"SCI0.RDR",
    0x0008A040:"SCI2",0x0008A042:"SCI2.SCR",0x0008A044:"SCI2.SSR",0x0008A045:"SCI2.RDR",
    0x0008A060:"SCI3",0x0008A062:"SCI3.SCR",0x0008A064:"SCI3.SSR",0x0008A065:"SCI3.RDR",
    0x0008AC38:"SDHI.SDSTS1",0x0008AC3C:"SDHI.SDSTS2",0x0008AC60:"SDHI.SDBUFR",
    0x000820DE:"DMAC3.DMSTS",0x00082800:"EXDMAC0",0x0008281E:"EXDMAC0.EDMSTS",
    0x00088155:"TPU4.TSR",0x00088115:"TPU0.TSR",0x00088145:"TPU3.TSR",
    0x00088018:"CMT3.CMCR",0x00089000:"S12AD0.ADCSR",0x00089004:"S12AD0.ADANSA",
    0x00089020:"S12AD0.ADDR0",0x00088040:"R12DA.DADR0",0x00088044:"R12DA.DACR",
    0x000C1A00:"MTU6",0x000C1A84:"MTU.TRWERB",0x00080010:"MSTPCRA",0x000803FE:"PRCR",
    0x00080020:"SCKCR",0x00080028:"PLLCR",0x00083010:"BSC.CS",0x0008C100:"MPC.PFCSE",
    0x00087000:"ICU.IR",0x00087200:"ICU.IER",0x00087630:"ICU.GRPBL0",
}
BLIT = {0xFFEF0648, 0xFFEF04F7, 0xFFEF68D5}
# hard-data regions (evidence: docs 16/02 + entropy). post-vector 0xFFED8E70-
# 0xFFEDB000 is NOT listed: it holds xref-reached code, so it stays in the code
# region. Non-xref sweep hits landing in these regions are rejected as noise.
DATA_REGIONS = [
    (0xFFED0000,0xFFED3F6C,"bitmap-descriptor-table-tail"),
    (0xFFED3F6C,0xFFED5800,"UI-layout-tables"),
    (0xFFED5800,0xFFED8A70,"zero-heavy-tables"),
    (0xFFED8A70,0xFFED8E70,"INTB-vector-table"),
    (0xFFF48000,0xFFF4C000,"string-pool"),
]


def log(t):
    with open(STATUS,"a",encoding="utf-8",newline="\n") as h: h.write(t+"\n")


def main():
    import ida_bytes, ida_funcs, ida_ua, idautils, idc

    def gb(ea):
        b=ida_bytes.get_byte(ea); return b if b is not None else 0xFF
    def in_data_region(ea):
        for lo,hi,l in DATA_REGIONS:
            if lo<=ea<hi: return l
        return None
    def is_prologue(ea):
        b0,b1=gb(ea),gb(ea+1)
        if b0==0x6E: return 1<=(b1>>4)<(b1&0xF)<=15
        if b0==0x7E and 0xA0<=b1<=0xAF: return True
        if b0==0x60 and (b1&0x0F)==0 and (b1>>4): return True
        if b0==0x71 and b1==0x04: return True
        if b0==0xFB and (b1&0x0F) in (0x02,0x0E): return True
        return False
    def plausible2(ea,bound=0x3000):
        cur=ea;n=0
        while cur<ea+bound and cur<WIN_HI:
            insn=ida_ua.insn_t();ln=ida_ua.decode_insn(insn,cur)
            if ln<=0 or ln>8: return False
            n+=1
            if insn.get_canon_feature()&CF_STOP: return n>=2
            cur+=ln
        return False
    def has_ref(ea):
        for xr in idautils.XrefsTo(ea,0):
            if xr.iscode and xr.type!=21: return True
        return False

    # ---- true byte classification of the whole window (head/tail-correct) ----
    instr_bytes=data_bytes=undef_bytes=0
    ea=WIN_LO
    while ea<WIN_HI:
        fl=ida_bytes.get_flags(ea)
        if ida_bytes.is_code(fl):        # head of an instruction
            sz=ida_bytes.get_item_size(ea)
            instr_bytes+=sz; ea+=sz if sz>0 else 1
        elif ida_bytes.is_data(fl):
            sz=ida_bytes.get_item_size(ea)
            data_bytes+=sz; ea+=sz if sz>0 else 1
        elif ida_bytes.is_tail(fl):
            # tail of a code or data item; attribute to its head's class
            hd=ida_bytes.prev_head(ea+1,WIN_LO)
            # fallback: count as instr if previous defined item is code
            undef_bytes+=0
            # tails are already included via head item_size above, so skip
            ea+=1
        else:                            # FF_UNK truly undefined
            undef_bytes+=1; ea+=1
    log("window head/tail-correct: instr_bytes(incl tails) %d data %d truly-undef %d" % (
        instr_bytes, data_bytes, undef_bytes))

    # ---- function classification with correct instruction-byte count ----
    def instr_bytes_in(f):
        c=0; ea=f.start_ea
        while ea<f.end_ea:
            fl=ida_bytes.get_flags(ea)
            if ida_bytes.is_code(fl):
                sz=ida_bytes.get_item_size(ea); c+=sz; ea+=sz if sz>0 else 1
            else:
                ea+=1
        return c
    def peripheral_purpose(f):
        hits=[]; e=f.start_ea; cnt=0
        while e<f.end_ea and e!=idc.BADADDR and cnt<400:
            cnt+=1
            if gb(e)==0xFB:
                lo=gb(e+1)&0x0F
                if lo==0x0E: v=int.from_bytes(ida_bytes.get_bytes(e+2,3) or b"\0","little")
                elif lo==0x02: v=int.from_bytes(ida_bytes.get_bytes(e+2,4) or b"\0","little")
                else: v=-1
                if v in PERIPH: hits.append(PERIPH[v])
                elif v in BLIT: hits.append("UI-draw")
            for ref in idautils.CodeRefsFrom(e,0):
                if ref in BLIT: hits.append("UI-draw")
            nx=idc.next_head(e,f.end_ea)
            if nx==idc.BADADDR or nx<=e: break
            e=nx
        seen=[]
        for h in hits:
            if h not in seen: seen.append(h)
        return seen

    n_x=n_b=n_r=0; ib_x=ib_b=ib_r=0; body_prol=0; purposed=0
    rows=[]
    for s in idautils.Functions(WIN_LO,WIN_HI):
        f=ida_funcs.get_func(s)
        if not f: continue
        ib=instr_bytes_in(f)
        xref=has_ref(s); dr=in_data_region(s); prol=is_prologue(s); pl=plausible2(s)
        fb=(ida_bytes.get_bytes(s,min(8,f.end_ea-s)) or b"").hex()
        pur=peripheral_purpose(f); purpose=",".join(pur)
        if xref:
            cls="xref"; n_x+=1; ib_x+=ib; ev="start %08X %s"%(s,fb)
        elif dr is not None:
            cls="rejected"; n_r+=1; ib_r+=ib; ev="in-data-region:%s"%dr
        elif pl and prol:
            cls="body"; n_b+=1; ib_b+=ib; body_prol+=1
            ev="start %08X %s prologue+return"%(s,fb)
            if purpose: purposed+=1
        else:
            cls="rejected"; n_r+=1; ib_r+=ib
            ev="start %08X %s prol=%d plausible=%d"%(s,fb,int(prol),int(pl))
        rows.append((s,f.end_ea,cls,"yes" if xref else "no",purpose if cls=="body" else "",ev,ib))

    numerator=ib_x+ib_b
    log("FINAL(correct) xref %d(%d) body %d(%d) reject %d(%d) numerator %d purposed %d"%(
        n_x,ib_x,n_b,ib_b,n_r,ib_r,numerator,purposed))

    # ---- denominator (correct) ----
    total=WIN_HI-WIN_LO
    proved_data=sum(hi-lo for lo,hi,_ in DATA_REGIONS)
    # truly-undefined 0xFF / 0x00 padding across whole window
    ff=z=0; ea=WIN_LO
    while ea<WIN_HI:
        fl=ida_bytes.get_flags(ea)
        if not ida_bytes.is_code(fl) and not ida_bytes.is_data(fl) and not ida_bytes.is_tail(fl):
            b=gb(ea)
            if b==0xFF: ff+=1
            elif b==0x00: z+=1
        ea+=1
    denom=total-proved_data
    with open(os.path.join(OUT,"functions.tsv"),"w",encoding="utf-8",newline="\n") as h:
        h.write("start\tend\tvalidated\txref\tpurpose\tevidence\n")
        for s,e,c,x,p,ev,ib in sorted(rows):
            h.write("%08X\t%08X\t%s\t%s\t%s\t%s\n"%(s,e,c,x,p,ev))
    with open(os.path.join(OUT,"coverage.txt"),"w",encoding="utf-8",newline="\n") as h:
        h.write("Lane 4 SUB code window -- FINAL coverage (head/tail-correct byte count)\n")
        h.write("database SUB_WINDOW; window %08X-%08X = %d bytes\n\n"%(WIN_LO,WIN_HI,total))
        h.write("KEY CORRECTION: is_code() flags only instruction HEADs. Prior 29.4%%/154162\n")
        h.write("figure (SUB_VEC and my pass1-3) counted heads only. Below uses item sizes.\n\n")
        h.write("== whole-window true byte classification ==\n")
        h.write("instruction bytes (heads+tails)  %d (%.1f%%)\n"%(instr_bytes,100.0*instr_bytes/total))
        h.write("data-item bytes                  %d (%.1f%%)\n"%(data_bytes,100.0*data_bytes/total))
        h.write("truly-undefined (FF_UNK)         %d (%.1f%%)\n"%(undef_bytes,100.0*undef_bytes/total))
        h.write("  of which 0xFF pad %d, 0x00 pad %d\n\n"%(ff,z))
        h.write("== function classification (instruction BYTES, tails included) ==\n")
        h.write("reached-by-xref     %d funcs   %d instr bytes\n"%(n_x,ib_x))
        h.write("validated-by-body   %d funcs   %d instr bytes  (%d w/ prologue, %d with purpose)\n"%(
            n_b,ib_b,body_prol,purposed))
        h.write("rejected            %d funcs   %d instr bytes\n"%(n_r,ib_r))
        h.write("VALIDATED TOTAL     %d funcs   %d instr bytes  <-- numerator\n\n"%(n_x+n_b,numerator))
        h.write("== instruction-byte denominator ==\n")
        h.write("window total                    %d\n"%total)
        for lo,hi,l in DATA_REGIONS:
            h.write("  -proved data %08X-%08X %7d  %s\n"%(lo,hi,hi-lo,l))
        h.write("proved data total               %d\n"%proved_data)
        h.write("instruction-byte denominator    %d  (window - proved data)\n"%denom)
        h.write("  numerator/denominator = %d/%d = %.1f%%\n"%(numerator,denom,100.0*numerator/denom))
        h.write("  all-instr-bytes/denom = %d/%d = %.1f%%\n"%(instr_bytes,denom,100.0*instr_bytes/denom))
        h.write("  numerator/full-window = %d/%d = %.1f%%\n"%(numerator,total,100.0*numerator/total))
    log("done")


if True:
    os.makedirs(OUT,exist_ok=True)
    with open(STATUS,"w",encoding="utf-8",newline="\n") as _h: _h.write("start\n")
    try: main()
    except Exception:
        with open(os.path.join(OUT,"l4_final_tb.txt"),"w",encoding="utf-8",newline="\n") as _h:
            _h.write(traceback.format_exc())
        log("EXCEPTION")
    import idc as _idc; _idc.qexit(0)
