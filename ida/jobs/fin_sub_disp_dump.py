r"""Lane F3 -- hand-disassembly support for the big SUB dispatcher sub_FFF4C9D1.

Full exhaustive listing of the wrapper (FFF4C97E) + body (FFF4C9D1-FFF4F1B3),
plus switch/jump-table detection, computed-jump resolution, call-target set,
data refs, immediate harvest (24-bit aware), loop (back-branch) list, and full
listings of the callees.

    python "ida/run_job.py" --script ida\jobs\fin_sub_disp_dump.py --db FIN_SUB_DISP --copy-from ida\db\jobs\SUB_WINDOW\SUB_WINDOW.i64
    python "ida/run_job.py" --script ida\jobs\fin_sub_disp_dump.py --db FIN_SUB_DISP --reopen
"""
from __future__ import annotations
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root
import os, traceback

OUT = str(_REPO / "ida/out/sub-big")
STATUS = os.path.join(OUT, "dump_status.txt")

WRAP = 0xFFF4C97E
TARGET = 0xFFF4C9D1
TARGET_END = 0xFFF4F1B3
CALLEES = [0xFFF46457, 0xFFF455A0, 0xFFF46267, 0xFFF4557D, 0xFFF46D0A]

# RAM / periph / flash maps for annotating refs (from BRIEF + prior lanes)
PERIPH = {
    0x0008A000:"SCI0",0x0008A002:"SCI0.SCR",0x0008A004:"SCI0.SSR",0x0008A005:"SCI0.RDR",0x0008A003:"SCI0.TDR",
    0x0008A040:"SCI2",0x0008A042:"SCI2.SCR",0x0008A044:"SCI2.SSR",0x0008A045:"SCI2.RDR",
    0x0008A060:"SCI3",0x0008A062:"SCI3.SCR",0x0008A064:"SCI3.SSR",0x0008A065:"SCI3.RDR",
    0x00087000:"ICU.IR",0x00087200:"ICU.IER",0x00087300:"ICU.IPR",0x00087630:"ICU.GRPBL0",
    0x00080010:"MSTPCRA",0x00080014:"MSTPCRB",0x000803FE:"PRCR",0x0008C000:"PORT",
    0x00089000:"S12AD0.ADCSR",0x00088000:"CMT0",
}

def log(t):
    with open(STATUS,"a",encoding="utf-8",newline="\n") as h: h.write(t+"\n")

def main():
    import ida_bytes, ida_funcs, ida_ua, ida_nalt, idautils, idc, ida_auto, ida_lines
    ida_auto.auto_wait()

    def ida_lines_clean(s):
        return ida_lines.tag_remove(s)
    def gb(ea):
        b=ida_bytes.get_byte(ea); return b if b is not None else 0xFF
    def hexbytes(ea,n):
        bs=ida_bytes.get_bytes(ea,n) or b""
        return " ".join("%02x"%x for x in bs)

    def classify_addr(a):
        if a is None: return ""
        if a in PERIPH: return "PERIPH:"+PERIPH[a]
        if 0x00080000<=a<0x00100000: return "PERIPH?"
        if 0x00000000<=a<0x00080000: return "RAM"
        if 0xFFC00000<=a<0xFFD00000: return "FLASH.rodata"
        if 0xFFED0000<=a<0xFFF50000: return "CODEWIN"
        if 0xFFD00000<=a<0xFFFFFFFF: return "FLASH.code"
        return ""

    # ---------- function boundary confirmation ----------
    for s in (WRAP, TARGET):
        f=ida_funcs.get_func(s)
        if f:
            log("func %08X-%08X (size %d) name=%s" % (s,f.end_ea,f.end_ea-s,idc.get_func_name(s)))
        else:
            log("NO FUNC at %08X" % s)

    # ---------- xrefs TO the wrapper and target (who reaches them) ----------
    for s in (WRAP, TARGET):
        refs=[]
        for xr in idautils.XrefsTo(s,0):
            refs.append("%08X(type=%d iscode=%d)"%(xr.frm,xr.type,xr.iscode))
        log("xrefsTo %08X: %s" % (s, "; ".join(refs) if refs else "NONE"))

    # ---------- main listing walker ----------
    def dump_range(fp, lo, hi, title):
        fp.write("; ==================================================================\n")
        fp.write("; %s   %08X .. %08X  (%d bytes)\n" % (title, lo, hi, hi-lo))
        fp.write("; ==================================================================\n")
        ea=lo
        n_code=n_data=n_undef=0
        while ea<hi:
            fl=ida_bytes.get_flags(ea)
            sz=ida_bytes.get_item_size(ea)
            if sz<=0: sz=1
            # don't overrun
            if ea+sz>hi: sz=hi-ea
            bts=hexbytes(ea,min(sz,16))
            if ida_bytes.is_code(fl):
                n_code+=1
                dis=idc.generate_disasm_line(ea,0) or ""
                # strip IDA color codes
                dis=ida_lines_clean(dis)
                cmt=idc.get_cmt(ea,0) or ""
                fp.write("%08X  %-24s  %s%s\n" % (ea, bts, dis, ("   ; "+cmt) if cmt else ""))
            elif ida_bytes.is_data(fl):
                n_data+=1
                dis=idc.generate_disasm_line(ea,0) or ""
                dis=ida_lines_clean(dis)
                fp.write("%08X  %-24s  %s   ; DATA\n" % (ea, bts, dis))
            else:
                n_undef+=1
                # try to show what it would decode as
                insn=ida_ua.insn_t()
                ln=ida_ua.decode_insn(insn,ea)
                guess=""
                if ln>0:
                    guess=ida_lines_clean(idc.generate_disasm_line(ea,0) or "")
                fp.write("%08X  %-24s  UNDEF %s\n" % (ea, bts, guess))
            ea+=sz
        fp.write("; ---- range stats: code heads %d, data items %d, undef items %d ----\n\n"%(n_code,n_data,n_undef))

    # ---------- analysis collectors over [TARGET, TARGET_END) ----------
    switches=[]      # (jump_ea, info dict)
    indirect_jumps=[]
    calls={}         # target -> count
    datarefs={}      # addr -> (first_ea, type)
    imms_mem={}      # o_mem addr -> count
    imms_val={}      # immediate value -> count (only "interesting" large ones)
    displs={}        # (regname, value) -> count   -- base+disp forms
    backbranches=[]  # (ea, target)  loops
    all_targets=[]   # computed-jump landing targets

    def op_regname(insn,opn):
        try: return "R%d"%insn.ops[opn].reg
        except Exception: return "?"

    ea=TARGET
    while ea<TARGET_END:
        fl=ida_bytes.get_flags(ea)
        sz=ida_bytes.get_item_size(ea)
        if sz<=0: sz=1
        if not ida_bytes.is_code(fl):
            ea+=sz; continue
        mnem=idc.print_insn_mnem(ea)
        insn=ida_ua.insn_t()
        ln=ida_ua.decode_insn(insn,ea)

        # switch info
        si=ida_nalt.get_switch_info(ea)
        if si is not None:
            d={"jump_ea":ea}
            for a in ("ncases","jumps","lowcase","defjump","startea","elbase","flags"):
                try: d[a]=getattr(si,a)
                except Exception: d[a]=None
            try: d["elsize"]=si.get_jtable_element_size()
            except Exception: d["elsize"]=None
            try: d["ncases2"]=si.get_jtable_size()
            except Exception: d["ncases2"]=None
            switches.append(d)

        # branches / calls
        if mnem in ("jmp","bra"):
            op0=idc.print_operand(ea,0)
            # register-indirect?
            if insn.ops[0].type==ida_ua.o_reg:
                indirect_jumps.append((ea,op0,"reg"))
            elif insn.ops[0].type in (ida_ua.o_phrase,ida_ua.o_displ,ida_ua.o_mem):
                indirect_jumps.append((ea,op0,"mem"))
            else:
                tgt=insn.ops[0].addr
                if tgt and tgt<ea: backbranches.append((ea,tgt))
        if mnem in ("bsr","jsr"):
            tgt=insn.ops[0].addr
            if insn.ops[0].type==ida_ua.o_reg:
                indirect_jumps.append((ea,idc.print_operand(ea,0),"call-reg"))
            elif tgt:
                calls[tgt]=calls.get(tgt,0)+1
        if mnem in ("beq","bne","bc","bnc","bgtu","bleu","bpz","bn","bge","blt","bgt","ble","bo","bno","bra.b","bra.w"):
            tgt=insn.ops[0].addr
            if tgt and tgt<ea: backbranches.append((ea,tgt))

        # code refs from (catch call/jump targets IDA already resolved)
        for ref in idautils.CodeRefsFrom(ea,0):
            if ref<TARGET or ref>=TARGET_END:
                if mnem in ("bsr","jsr"):
                    calls[ref]=calls.get(ref,0)+1

        # data refs
        for dr in idautils.DataRefsFrom(ea):
            if dr not in datarefs:
                datarefs[dr]=(ea,classify_addr(dr))

        # operand harvest
        for i in range(8):
            op=insn.ops[i]
            if op.type==ida_ua.o_void: break
            if op.type==ida_ua.o_mem:
                a=op.addr; imms_mem[a]=imms_mem.get(a,0)+1
            elif op.type==ida_ua.o_imm:
                v=op.value
                if v>=0x1000: imms_val[v]=imms_val.get(v,0)+1
            elif op.type==ida_ua.o_displ:
                # RX: displacement in op.value (byte-scaled)
                key=(op.reg, op.value)
                displs[key]=displs.get(key,0)+1
        ea+=sz

    # ---------- write main listing ----------
    with open(os.path.join(OUT,"fff4c9d1.lst"),"w",encoding="utf-8",newline="\n") as fp:
        fp.write("; Full listing -- SUB dispatcher sub_FFF4C9D1 (+ wrapper sub_FFF4C97E)\n")
        fp.write("; database FIN_SUB_DISP (copy of SUB_WINDOW); RX64M, base 0xFFC00000, LE\n\n")
        dump_range(fp, WRAP, TARGET, "WRAPPER sub_FFF4C97E")
        dump_range(fp, TARGET, TARGET_END, "BODY sub_FFF4C9D1 (dispatcher)")

    # ---------- callees listing ----------
    with open(os.path.join(OUT,"fff4c9d1-callees.lst"),"w",encoding="utf-8",newline="\n") as fp:
        for c in CALLEES:
            f=ida_funcs.get_func(c)
            lo=c; hi=f.end_ea if f else c+64
            dump_range(fp, lo, hi, "CALLEE %08X"%c)
            # who else calls it
            refs=["%08X"%xr.frm for xr in idautils.XrefsTo(c,0)]
            fp.write("; xrefsTo %08X: %s\n\n"%(c,", ".join(refs) if refs else "NONE"))

    # ---------- analysis file ----------
    with open(os.path.join(OUT,"fff4c9d1-analysis.txt"),"w",encoding="utf-8",newline="\n") as fp:
        fp.write("ANALYSIS of sub_FFF4C9D1  %08X-%08X (%d bytes)\n\n"%(TARGET,TARGET_END,TARGET_END-TARGET))

        fp.write("== SWITCH INFO (ida_nalt.get_switch_info) ==\n")
        if not switches: fp.write("  none auto-detected\n")
        for d in switches:
            fp.write("  jump@%08X ncases=%s/%s jumps=%08X elbase=%08X elsize=%s startea=%08X defjump=%08X lowcase=%s flags=0x%X\n"%(
                d["jump_ea"], d.get("ncases"), d.get("ncases2"),
                (d.get("jumps") or 0), (d.get("elbase") or 0), d.get("elsize"),
                (d.get("startea") or 0), (d.get("defjump") or 0), d.get("lowcase"), (d.get("flags") or 0)))
        fp.write("\n")

        fp.write("== INDIRECT / REGISTER JUMPS & CALLS ==\n")
        for ea,op,kind in indirect_jumps:
            fp.write("  %08X  %-6s  %s\n"%(ea,kind,op))
        fp.write("\n")

        fp.write("== CALL TARGETS (bsr/jsr) ==\n")
        for t in sorted(calls):
            nm=idc.get_func_name(t) or ""
            fp.write("  %08X  x%-3d  %s  %s\n"%(t,calls[t],nm,classify_addr(t)))
        fp.write("\n")

        fp.write("== DATA REFS (DataRefsFrom) ==\n")
        for a in sorted(datarefs):
            frm,cls=datarefs[a]
            fp.write("  %08X  %-14s  first@%08X\n"%(a,cls,frm))
        fp.write("\n")

        fp.write("== o_mem operand addresses (absolute mem refs) ==\n")
        for a in sorted(imms_mem):
            fp.write("  %08X  x%-3d  %s\n"%(a,imms_mem[a],classify_addr(a)))
        fp.write("\n")

        fp.write("== immediate values >=0x1000 (candidate addresses/constants) ==\n")
        for v in sorted(imms_val):
            fp.write("  0x%08X  x%-3d  %s\n"%(v,imms_val[v],classify_addr(v)))
        fp.write("\n")

        fp.write("== base+displacement operands (reg, disp) top 60 by count ==\n")
        for (reg,val),c in sorted(displs.items(), key=lambda kv:-kv[1])[:60]:
            fp.write("  R%-2d + 0x%-6X  x%d\n"%(reg,val,c))
        fp.write("\n")

        fp.write("== BACK-BRANCHES (loops) count=%d ==\n"%len(backbranches))
        for ea,t in backbranches:
            fp.write("  %08X -> %08X\n"%(ea,t))
        fp.write("\n")

    log("dump done: switches=%d indirect=%d calls=%d datarefs=%d backbranches=%d"%(
        len(switches),len(indirect_jumps),len(calls),len(datarefs),len(backbranches)))

if True:
    os.makedirs(OUT,exist_ok=True)
    with open(STATUS,"w",encoding="utf-8",newline="\n") as _h: _h.write("start\n")
    try:
        main()
    except Exception:
        with open(os.path.join(OUT,"dump_tb.txt"),"w",encoding="utf-8",newline="\n") as _h:
            _h.write(traceback.format_exc())
        log("EXCEPTION")
    import idc as _idc; _idc.qexit(0)
