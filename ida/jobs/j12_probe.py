r"""Lane J12 - focused probe: decode exit-stub clusters and name caller/reader functions."""
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root
import os, traceback
BASE = str(_REPO / "ida/out/settings-49")
OUT = os.path.join(BASE, "probe.txt")
ERR = os.path.join(BASE, "j12_probe_error.txt")

# (label, ea, ninsns) linear decodes
LINS = [
    ("cluster 19288 (0x16/0x17 stubs; id2B=19290,id3E=192B0)", 0x19288, 28),
    ("cluster 19340 (0xA9/0xAA stubs; id?=19356/1935E)", 0x19340, 18),
    ("reader FF8937 fn 22E3A", 0x22E3A, 24),
    ("reader FF89C9 fn 7421E", 0x7421E, 30),
    ("writer FF89C9 fn 2DCE @2DE8", 0x2DCE, 36),
    ("reader FF89CB fn CE1E", 0x0CE1E, 14),
    ("save FF89CB caller fn 1D220", 0x1D220, 30),
    ("save FF89CB caller fn 1E892", 0x1E892, 28),
    ("save FF8A58 caller fn 1D2C0 (word)", 0x1D2C0, 24),
    ("save FF8AAA caller fn 50EA8", 0x50EA8, 40),
    ("reader FF8AAA fn 22CE0", 0x22CE0, 20),
    ("save FF8C2C caller fn 51408", 0x51408, 48),
    ("reader FF8C2C fn 17B5E", 0x17B5E, 24),
    ("save FF8DD0/D1 caller fn 5C602", 0x5C602, 16),
    ("reader FF8DD0 fn 5C602 near 5C746", 0x5C740, 12),
    ("save FF8DD5 caller fn 24C88", 0x24C88, 24),
    ("save FF8DD5/B6 caller fn 1C9C2", 0x1C9C2, 40),
    ("save FF8DD6 fn 24724", 0x24724, 30),
    ("save FF8DDE caller fn 1058A (power-on)", 0x10578, 24),
    ("save FF8DDF caller fn 6CCC2", 0x6CCC2, 24),
    ("save FF8DE0 caller fn 6CD66", 0x6CD66, 40),
    ("save FF8DE1 caller fn 2648", 0x2648, 28),
    ("save FF8DE2 caller fn 5B772", 0x5B772, 30),
    ("save FF8DE7 caller fn 6CCF4", 0x6CCF4, 20),
    ("save FF8E40-blk caller fn 37FA6 + reader 37EB6", 0x37EB6, 40),
]
# functions whose name/segment/ipc we want: print xrefs-to (callers up the chain)
XF = [0x22E3A, 0x7421E, 0x50EA8, 0x51408, 0x5C602, 0x24C88, 0x1C9C2, 0x6CCC2,
      0x6CD66, 0x2648, 0x5B772, 0x6CCF4, 0x37FA6, 0x1D220, 0x1E892, 0x1D2C0, 0x1058A]

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
        return "%08X  %-24s %-38s ; %s"%(ea,raw,dis.split(";")[0].strip(),ops(insn)),n
    def fname(ea):
        f=ida_funcs.get_func(ea); return ("%08X"%f.start_ea) if f else "-"
    for lbl,ea,cnt in LINS:
        w("###### %s @%08X"%(lbl,ea))
        cur=ea
        for _ in range(cnt):
            if not ida_bytes.is_code(ida_bytes.get_flags(cur)):
                ida_bytes.del_items(cur,0,2); ida_ua.create_insn(cur)
            s,n=line(cur)
            if s is None:
                w("%08X ?? %02X"%(cur,ida_bytes.get_byte(cur))); cur+=1; continue
            w(s); cur+=n
        w("")
    w("================ XREFS (callers) ================")
    def walk(ea,depth,seen):
        if depth>3 or ea in seen: return
        seen.add(ea)
        callers=sorted(set(x.frm for x in idautils.XrefsTo(ea)))
        w("  %sfn %08X callers: %s"%("  "*depth, ea, " ".join("%08X(%s)"%(c,fname(c)) for c in callers[:12]) or "(none)"))
        for c in callers[:6]:
            ff=ida_funcs.get_func(c)
            if ff and ff.start_ea!=ea:
                walk(ff.start_ea,depth+1,seen)
    for f in XF:
        w("## target %08X"%f)
        walk(f,0,set())
    with open(OUT,"w",encoding="utf-8") as fh: fh.write("\n".join(out)+"\n")
    print("probe wrote %d lines"%len(out))

try: main()
except Exception:
    open(ERR,"w",encoding="utf-8").write(traceback.format_exc())
import idc; idc.qexit(0)
