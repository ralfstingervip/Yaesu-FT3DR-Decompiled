r"""SUB-UPPER pass 2 (reopen SUB_UPPER):
  (1) constant-propagation peripheral scan over all recovered functions, resolving
      #imm / [rN] / disp[rN] (RX disp is in op.value) — re-test USB0, USBA and the
      flash sequencer (FCU 0x007E0000-0x00800000, FWEPROR 0x0008C289, FENTRYR
      0x007FFFB2) on my own coverage;
  (2) bitmap-atlas accessor: find every function that loads a descriptor address
      (imm in [0xFFECE55C,0xFFED3F6C) on a 16-byte boundary), find their common
      callee(s) = the blit routine, and disassemble it + sample draw sites;
  (3) disassemble the EXDMAC external-bus display path.
"""
from __future__ import annotations
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root
import os, collections, traceback

OUT = str(_REPO / "ida/out/sub-upper")
BASE=0xFFC00000
TBL,TEND=0xFFECE55C,0xFFED3F6C
STATUS=os.path.join(OUT,"scan_status.txt")

def log(t):
    with open(STATUS,"a",encoding="utf-8",newline="\n") as h: h.write(t+"\n")
def esc(t): return (t or "").replace("\t"," ").replace("\r"," ").replace("\n"," ")

def main():
    import ida_bytes, ida_funcs, ida_ua, idautils, idc, ida_auto
    ida_auto.auto_wait()
    O_IMM, O_MEM, O_DISPL, O_PHRASE, O_NEAR = ida_ua.o_imm, ida_ua.o_mem, ida_ua.o_displ, ida_ua.o_phrase, ida_ua.o_near
    M=0xFFFFFFFF

    # windows of interest
    def classify(a):
        if 0x000A0000<=a<0x000A1000: return "USB0"
        if 0x000D0000<=a<0x000D0200: return "USBA"
        if 0x007E0000<=a<0x00800000: return "FLASH_FCU"
        if a in (0x0008C288,0x0008C289): return "FWEPROR"
        if a in (0x007FFFB2,0x007FFFB3): return "FENTRYR"
        return None

    hits=[]
    nfunc=ninsn=0
    for start in idautils.Functions():
        nfunc+=1
        env={}   # reg -> const value
        for ea in idautils.FuncItems(start):
            insn=ida_ua.insn_t()
            if ida_ua.decode_insn(insn,ea)<=0:
                continue
            ninsn+=1
            mnem=insn.get_canon_mnem().lower()
            # resolve operands to effective addresses BEFORE updating env
            for i in range(6):
                op=insn.ops[i]
                if op.type==0: break
                ea_eff=None
                if op.type==O_MEM: ea_eff=op.addr & M
                elif op.type==O_IMM: ea_eff=op.value & M
                elif op.type==O_PHRASE:
                    if op.reg in env: ea_eff=env[op.reg] & M
                elif op.type==O_DISPL:
                    disp=op.value if op.value else op.addr
                    if op.reg in env: ea_eff=(env[op.reg]+disp) & M
                if ea_eff is not None:
                    c=classify(ea_eff)
                    if c: hits.append((c,ea,start,i,ea_eff,esc(idc.generate_disasm_line(ea,0))))
            # update env
            if mnem in ("mov","movu") and insn.ops[0].type==O_IMM:
                # mov #imm, rN  (dest is op1)
                dst=insn.ops[1]
                if dst.type in (1,) or dst.type==ida_ua.o_reg:
                    env[dst.reg]=insn.ops[0].value & M
            elif mnem=="add" and insn.ops[0].type==O_IMM and insn.ops[1].type==ida_ua.o_reg:
                if insn.ops[1].reg in env: env[insn.ops[1].reg]=(env[insn.ops[1].reg]+insn.ops[0].value)&M
                else: env.pop(insn.ops[1].reg,None)
            else:
                # invalidate any reg written (best-effort: clear dest regs)
                for i in range(6):
                    op=insn.ops[i]
                    if op.type==ida_ua.o_reg and i>0:
                        env.pop(op.reg,None)

    with open(os.path.join(OUT,"usb_flash_retest.txt"),"w",encoding="utf-8",newline="\n") as h:
        h.write("constant-prop peripheral retest over %d functions, %d instructions\n"%(nfunc,ninsn))
        cc=collections.Counter(x[0] for x in hits)
        h.write("hits by class: %s\n\n"%dict(cc))
        for c in ("USB0","USBA","FLASH_FCU","FWEPROR","FENTRYR"):
            rows=[x for x in hits if x[0]==c]
            h.write("=== %s : %d hits ===\n"%(c,len(rows)))
            for cl,ea,st,i,eff,dis in rows[:60]:
                h.write("  %08X (func %08X) op%d eff=%08X  %s\n"%(ea,st,i,eff,dis))
            h.write("\n")
    log("periph retest done: %s"%dict(collections.Counter(x[0] for x in hits)))

    # ---- (2) bitmap accessor ----
    draw_sites=[]   # (insn_ea, func_start, descriptor_ea)
    for start in idautils.Functions():
        for ea in idautils.FuncItems(start):
            insn=ida_ua.insn_t()
            if ida_ua.decode_insn(insn,ea)<=0: continue
            for i in range(6):
                op=insn.ops[i]
                if op.type==0: break
                if op.type==O_IMM:
                    v=op.value & M
                    if TBL<=v<TEND and (v-TBL)%16==0:
                        draw_sites.append((ea,start,v))
    # for each draw site, find the next call target within the function
    callee=collections.Counter()
    site_rows=[]
    for ea,st,desc in draw_sites:
        nx=ea; tgt=None
        for _ in range(12):
            nx=idc.next_head(nx, st+0x4000)
            if nx==idc.BADADDR: break
            m=idc.print_insn_mnem(nx).lower()
            if m in ("jsr","bsr"):
                for r in idautils.CodeRefsFrom(nx,0):
                    if r!=idc.next_head(nx,st+0x4000): tgt=r; break
                if tgt is None:
                    # operand target
                    tgt=idc.get_operand_value(nx,0)
                break
        if tgt: callee[tgt]+=1
        site_rows.append((ea,st,desc,tgt))
    with open(os.path.join(OUT,"bitmap_accessor.txt"),"w",encoding="utf-8",newline="\n") as h:
        h.write("descriptor-address immediate load sites: %d\n"%len(draw_sites))
        h.write("distinct descriptors referenced: %d\n"%len({d for _,_,d in draw_sites}))
        h.write("distinct functions containing a draw site: %d\n\n"%len({s for _,s,_ in draw_sites}))
        h.write("most common callee after a descriptor load (candidate blit routine):\n")
        for tgt,c in callee.most_common(15):
            nm=idc.get_func_name(tgt) or idc.get_name(tgt) or ""
            h.write("  %08X  x%-4d %s\n"%(tgt,c,nm))
        # disassemble the top blit candidate
        if callee:
            blit=callee.most_common(1)[0][0]
            f=ida_funcs.get_func(blit)
            h.write("\n=== top blit candidate %08X %s ===\n"%(blit, idc.get_func_name(blit) or ""))
            if f:
                ea=f.start_ea
                while ea<f.end_ea and ea!=idc.BADADDR:
                    raw=(ida_bytes.get_bytes(ea,min(idc.get_item_size(ea),10)) or b"").hex()
                    h.write("%08X  %-22s %s\n"%(ea,raw,esc(idc.generate_disasm_line(ea,0))))
                    ea=idc.next_head(ea,f.end_ea)
        # sample a few draw sites (disasm 8 insns around)
        h.write("\n=== sample draw sites ===\n")
        for ea,st,desc,tgt in site_rows[:8]:
            h.write("\n; site in func %08X draws descriptor %08X (rec %d) -> callee %s\n"%(st,desc,(desc-TBL)//16, ("%08X"%tgt) if tgt else "?"))
            e=ea
            for _ in range(8):
                h.write("  %08X  %s\n"%(e,esc(idc.generate_disasm_line(e,0))))
                e=idc.next_head(e, st+0x4000)
                if e==idc.BADADDR: break
    log("accessor done: %d sites, top callee %s"%(len(draw_sites), ("%08X"%callee.most_common(1)[0][0]) if callee else "none"))

    # ---- (3) EXDMAC display path ----
    want=[0xFFEF1DDA,0xFFEF1F74,0xFFEF1F80,0xFFEF1F90,0xFFEF1FC2,0xFFEF1FEB,0xFFEF1DDA]
    with open(os.path.join(OUT,"display_path.txt"),"w",encoding="utf-8",newline="\n") as h:
        done=set()
        for w in want:
            f=ida_funcs.get_func(w)
            s=f.start_ea if f else w
            if s in done: continue
            done.add(s)
            h.write("\n=== %08X %s ===\n"%(s, idc.get_func_name(s) or ""))
            if f:
                ea=f.start_ea
                while ea<f.end_ea and ea!=idc.BADADDR:
                    h.write("  %08X  %s\n"%(ea,esc(idc.generate_disasm_line(ea,0))))
                    ea=idc.next_head(ea,f.end_ea)
            else:
                h.write("  (no function)\n")
    log("display path done")

if True:
    os.makedirs(OUT,exist_ok=True)
    with open(STATUS,"w",encoding="utf-8",newline="\n") as _h: _h.write("start\n")
    try: main()
    except Exception:
        with open(os.path.join(OUT,"scan_traceback.txt"),"w",encoding="utf-8",newline="\n") as _h:
            _h.write(traceback.format_exc())
        log("EXCEPTION")
    import idc as _idc; _idc.qexit(0)
