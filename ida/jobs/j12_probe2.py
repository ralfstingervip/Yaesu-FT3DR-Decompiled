r"""Lane J12 - probe2: block editors FF8978 / FF8E40 and dead-candidate confirmation."""
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root
import os, traceback
BASE = str(_REPO / "ida/out/settings-49")
OUT = os.path.join(BASE, "probe2.txt")
ERR = os.path.join(BASE, "j12_probe2_error.txt")
LINS = [
    ("FF8978 16-byte editor @15E60", 0x15E60, 40),
    ("FF8E40 block reader fn 37EB6", 0x37EB6, 36),
    ("FF8E40 block writer fn 37FA6 up", 0x37F80, 28),
    ("FF8DE7 save caller 6CCF4 ctx", 0x6CCF4, 20),
    ("FF8DE2 save caller 5B772 ctx", 0x5B772, 30),
    ("FF8DE1 reader/other near 2648", 0x2650, 24),
]
# functions to get xrefs for
XF = [0x15E60, 0x37EB6, 0x37FA6]
# addresses to list all readers of FF8E40..FF8E4E individually with fn
def main():
    import ida_auto, ida_ua, ida_funcs, ida_bytes, idc, idautils
    ida_auto.auto_wait()
    out=[]; w=out.append
    def ops(insn):
        r=[]
        for i in range(8):
            op=insn.ops[i]
            if op.type==ida_ua.o_void: break
            if op.type==ida_ua.o_imm: r.append("#0x%X"%(op.value&0xFFFFFFFF))
            elif op.type==ida_ua.o_displ: r.append("d(R%d,+0x%X)"%(op.reg,op.value&0xFFFFFFFF))
            elif op.type in (ida_ua.o_mem,ida_ua.o_near,ida_ua.o_far): r.append("a=0x%X"%(op.addr&0xFFFFFFFF))
            elif op.type==ida_ua.o_reg: r.append("R%d"%op.reg)
            else: r.append("t%d"%op.type)
        return " ".join(r)
    def line(ea):
        insn=ida_ua.insn_t(); n=ida_ua.decode_insn(insn,ea)
        if n<=0: return None,1
        raw=ida_bytes.get_bytes(ea,n).hex(" "); dis=idc.generate_disasm_line(ea,0) or ""
        return "%08X  %-22s %-34s ; %s"%(ea,raw,dis.split(";")[0].strip(),ops(insn)),n
    def fname(ea):
        f=ida_funcs.get_func(ea); return ("%08X"%f.start_ea) if f else "-"
    for lbl,ea,cnt in LINS:
        w("###### %s @%08X"%(lbl,ea)); cur=ea
        for _ in range(cnt):
            if not ida_bytes.is_code(ida_bytes.get_flags(cur)):
                ida_bytes.del_items(cur,0,2); ida_ua.create_insn(cur)
            s,n=line(cur)
            if s is None: w("%08X ?? %02X"%(cur,ida_bytes.get_byte(cur))); cur+=1; continue
            w(s); cur+=n
        w("")
    w("================ XREFS ================")
    for f in XF:
        ff=ida_funcs.get_func(f)
        head=ff.start_ea if ff else f
        callers=sorted(set(x.frm for x in idautils.XrefsTo(head)))
        w("## fn %08X (head %08X) callers: %s"%(f, head, " ".join("%08X(%s)"%(c,fname(c)) for c in callers[:20]) or "(none)"))
    with open(OUT,"w",encoding="utf-8") as fh: fh.write("\n".join(out)+"\n")
    print("probe2 wrote %d lines"%len(out))
try: main()
except Exception:
    open(ERR,"w",encoding="utf-8").write(traceback.format_exc())
import idc; idc.qexit(0)
