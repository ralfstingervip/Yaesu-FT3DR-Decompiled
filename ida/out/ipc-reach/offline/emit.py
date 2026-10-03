import sys
from pathlib import Path as _Path
_REPO = _Path(__file__).resolve().parents[4]
import pickle,collections,os
from bu import BU,IMG
from rchain import chain
OUT=str(_REPO) + r"/ida/out/ipc-reach"
S=pickle.load(open("mainset.pkl","rb"))
S=dict(S)
S.setdefault("F00F",[]).append(("raw ROM frame @0x802A (F0 0F 00 04 01 03 01 07) via polled SCI_6 TDR, NMI vector 7",0x800E,True))
sys.exit('The firmware image is not in this repository.')
SB=0xFFC00000
SCR=[int.from_bytes(SUBIMG[0xFFED4050-SB+4*i:0xFFED4050-SB+4*i+4],'little') for i in range(0x4B)]
def sub_decide(op):
    hi,lo=op>>8,op&0xFF
    fam={0xF0:"FFEDF269",0xF1:"FFEDF2E0",0xF2:"FFEDF36A",0xF3:"FFEDF3A7",0xF4:"FFEDF3A7",0xF5:"FFEDF447",0xF6:"FFEDF4B8",0xF7:"FFEDF53E",0xF8:"FFEDF56F",0xFD:"FFEDF61B",0xFE:"FFEDF645",0xFF:"FFEDF645"}.get(hi,"none(default slot)")
    sid=None; side=""
    if hi<0xF0 or 0xF9<=hi<=0xFC: sid=0x00; side="top-level default returns var=0 -> screen 0 (handler acts only on hi=F1)"
    elif hi==0xF0:
        if lo==0: side="classifier side effect: [8A8A]=0, LCD cmd 0x28 via FFEF2022->FFEDE298 (write 0x06000000)"
        elif lo==1: side="classifier side effect: [8A8A]=1, LCD cmd 0x29 via FFEF201A->FFEDE298"
        else: sid={2:0x12,3:0x15,4:0x15,5:0x13,6:0x16,7:0x17,8:0x18,9:0x19,0xA:0x1A,0xB:0x1B}.get(lo)
    elif hi==0xF1:
        t=[0,1,None,3,4,5,6,7,8,9,0xA,0xB,None,0xD,None,0xF,None,0x11,0x42,0x41,0x49,0x4A]
        sid=t[lo] if lo<len(t) else None
    elif hi==0xF2: sid=0x08 if lo==0x80 else (0x1C if lo<=0x2C else None)
    elif hi==0xF3:
        if lo in (0xD5,0xD6): sid=None
        else: sid={0:0x1D,1:0x1E,0x66:0x43,0xB3:0x20,0xB8:0x20,0xD1:0x21}.get(lo,0x1F)
    elif hi==0xF4: sid={0:0x1F,1:0x45,2:0x46,3:0x47,4:0x48}.get(lo)
    elif hi==0xF5: sid={0x18:0x28,0x10:0x23,0x11:0x24,0x12:0x25,0x13:0x20,0x14:0x20,0x15:0x20,0x16:0x26,0x17:0x27,0:0x22,1:0x22,2:0x22,3:0x22}.get(lo)
    elif hi==0xF6: sid={0x40:0x40,0x10:0x29,0:0x29,0x20:0x2A,0x21:0x2A,0x22:0x2B,0x23:0x20}.get(lo); 
    elif hi==0xF7: sid={3:0x44,1:0x2E}.get(lo)
    elif hi==0xF8: sid={0x24:0x3D,1:0x31,0x10:0x32,0x11:0x33,0x12:0x34,0x13:0x35,0x14:0x36,0x15:0x37,0x16:0x38,0x20:0x39,0x21:0x3A,0x22:0x3B,0x23:0x3C,0:0x30}.get(lo)
    elif hi==0xFD: sid=0x3F if lo==0 else None
    elif hi==0xFE: sid=None
    elif hi==0xFF: sid=0x3E if lo in (1,0xFE,0xFF) else None
    if hi==0xF6 and lo in (0x30,0x31,0x32):
        return fam,"0x2C or 0x3E","%08X/%08X"%(SCR[0x2C],SCR[0x3E]),"handled (id via sub_FFEDE929()==2)"
    if sid is None:
        if side: return fam,"0xFF(+side effect)","-","handled-in-classifier ("+side+")"
        return fam,"DROP","-","classifier returns 0xFF -> [8A8E]=0, screen unchanged, no handler call (FFEDF23D/FFEDF073)"
    return fam,"0x%02X"%sid,"%08X"%SCR[sid],"handled"+(" ("+side+")" if side else "")
g3={}
for l in open(str(_REPO) + r"/ida/out/sub-labels/f3xx-codes.tsv",encoding="utf-8").read().splitlines():
    if l[:1]=="F":
        p=l.split("\t"); g3.setdefault(p[0],p[9].split(" (")[0] or "-")
g2={}
for ln in open(str(_REPO) + r"/ida/out/main-banks/ipc-opcodes.tsv",encoding="utf-8").read().splitlines()[1:]:
    p=ln.split("\t")
    if p[0]!="?": g2.setdefault(p[0],[]).append(p[1])
SUBONLY_G2=["F003","F00A","F109","F10A","F10D","F10F","F113","F115","F400","F401","F402","F404","F501","F503","F703","F801","FF01","FFFE"]
# SUB-recognised discrete set
subrec=set()
for hi in list(range(0xF0,0xF9))+[0xFD,0xFE,0xFF]:
    for lo in range(256):
        op=(hi<<8)|lo
        if hi==0xF3 and lo not in (0,1,0x66,0xB3,0xB8,0xD1): continue
        if hi==0xF2 and lo!=0x80 and lo>0x2C: continue
        fam,sid,h,st=sub_decide(op)
        if sid!="DROP": subrec.add("%04X"%op)
ops=sorted(set(S)|subrec)
def link(op):
    hi,lo=op>>8,op&0xFF
    G="generic: common header bytes +7..+9 applied (FFEDCEBC-FFEDD0C3), frame enqueued to 4-slot ring (bsr sub_FFEDD0D4 @FFEDCF2B)"
    if op==0xF00F: return "power-down: bclr 0x8C027.3/0x8C021.5/0x8C022.2/0x8C028.7 (FFEDC986-FFEDC9B9); then "+G, True
    if hi==0xFC: return ("sub_FFF3BC97(frame) @FFEDCDDB; NOT enqueued" if lo==0 else "discarded at FFEDCDD0; NOT enqueued"), False
    if hi==0xFE: return ("block request: word+0D/0E vs [0x1CC3C], sub_FFEDC4DD(word+0B/0C) @FFEDCDC0; NOT enqueued" if lo==0 else "discarded @FFEDCD8D; NOT enqueued"), False
    if hi==0xFF:
        if lo in (0xFE,0xFF): return "FF block protocol (FFEDCA70-FFEDCD2D): payload to 0x070E1000+(n-1)*0x100, checksum; MAIN frame NOT enqueued; SUB enqueues synthetic 2-byte FF FE / FF FF", False
        return "lo not FE/FF: counters reset (FFEDCD30); if mirror==FF SUB enqueues synthetic FF 01; MAIN frame NOT enqueued", False
    if op==0xF3D5: return "sub_FFF38338(frame) @FFEDCE43 then exit; NOT enqueued, no common-header pass", False
    if op==0xF3D6: return "common header applied; enqueue skipped (FFEDCEE0-FFEDCF1D); sub_FFF38107(frame) @FFEDD00D", False
    extra=""
    if op==0xF3D3: extra="; + sub_FFF38292(frame) @FFEDCFFF"
    if op==0xF3D2: extra="; + sub_FFF37D88(frame,1) @FFEDCFF1"
    if op==0xF640: extra="; + sub_FFF3E98C(frame) @FFEDD08D"
    if hi==0xF6 and (lo>>4)==3: extra="; if [0x12180]==1 sub_FFF36B1E @FFEDCE08"
    return G+extra, True
def purpose(op,sid):
    if op in g3 and g3[op] not in ("","-"): return g3[op]
    hi=op[:2]
    if op.startswith("F2") and op!="F280": return "F2 item index (0x1BD80 table idx) -> screen 0x1C"
    lab={"F0":"status/UI frame (F0 family)","F1":"main display/frequency screen family","F5":"F5 screen family","F6":"F6 screen family","F7":"F7 screen family","F8":"F8 screen family","FC":"bulk block (FC00)","FD":"FD screen","FE":"FE00 short frame","FF":"FF family (screen 0x3E)"}
    return lab.get(op[:2],"-")
rows=[]
siterows=[]
for op in ops:
    sites=S.get(op,[])
    live=[x for x in sites if x[2]]
    fam,sid,h,st=sub_decide(int(op,16))
    lk,enq=link(int(op,16))
    if not enq: fam,sid,h,st=fam,"n/a (not enqueued)","-","classifier never sees MAIN frame"
    if op in ("FF01","FFFE"): lk="SUB-internal synthetic 2-byte frame enqueued by link layer (FFEDCD61-FFEDCD7D FF01; FFEDC917-FFEDC94A / FFEDCCFF-FFEDCD1B FF FE)"; fam,sid,h,st=sub_decide(int(op,16))
    if op.startswith("F2") and op not in ("F200","F280") and op in S: msites="F200 builder 0x9430 lo-byte rewrite @0x945C (r3l=@0xFFBC76, set at 0x2A16A)"
    else: msites="; ".join("%s@%06X%s"%(m,a,"" if l else "(DEAD)") for m,a,l in sites) or "-"
    mlive="yes" if live else ("dead-only" if sites else "no sender")
    if op in ("FF01","FFFE"): cls="SUB-internal (synthesised by SUB link layer)"
    elif op=="F22C": cls="range edge only (F2 classifier accepts lo<=0x2C; MAIN index max 0x2B)"
    elif not sites and sid!="DROP": cls="SUB-only, no MAIN emitter (vestigial)"
    elif sites and not live: cls="SUB-recognised, MAIN builder dead"
    elif live and sid=="DROP": cls="MAIN-sent; link-layer generic only; screen classifier drops (no handler)"
    elif live and not enq: cls="MAIN-sent; consumed at SUB link layer sub_FFEDC976"
    elif live: cls="matched"
    else: cls="-"
    g2s="G2:"+",".join(g2[op]) if op in g2 else ("G2-missed" if sites else "")
    if op in SUBONLY_G2: g2s+=" | G2 listed SUB-only"
    rows.append((op,msites,mlive,lk,fam,sid,h,cls,purpose(op,sid),st,g2s))
    for m,a,l in sites:
        siterows.append((op,"%06X"%a,m,"live" if l else "DEAD",chain(a)[:400]))
os.makedirs(OUT,exist_ok=True)
with open(os.path.join(OUT,"opcode-matrix.tsv"),"w",encoding="utf-8",newline="\n") as f:
    f.write(r"# Lane H5 reconciled MAIN->SUB IPC opcode matrix. MAIN emission census = every store to mailbox opcode word 0xFF3D74 (139 sites) + 91 generic-sender call sites (e3) + F101->F102 rewriter + F2 low-byte rewrite + raw NMI frame. live = emitting instruction reached by recursive descent from the vector table (tables dispatched; slot-value feasibility Inferred). SUB decision = top-level classifier sub_FFEDF1D8 + family classifiers, bytes in ida\out\ipc-reach\sub_probe.txt. F3 low bytes other than 00/01/66/B3/B8/D1/D5/D6 all map to 0x1F; F2 low 00..2C map to 0x1C; only opcodes with a MAIN sender or a discrete SUB case are listed."+"\n")
    f.write("opcode\tmain_senders\tmain_live\tsub_link_layer(sub_FFEDC976)\tsub_family_classifier\tsub_screen_id\tsub_screen_handler(FFED4050[id])\tclass\tpurpose_label\tsub_decision_detail\tprior_lane_status\n")
    for r in rows: f.write("\t".join(r)+"\n")
with open(os.path.join(OUT,"main-sites.tsv"),"w",encoding="utf-8",newline="\n") as f:
    f.write("opcode\temit_site\tmechanism\tstatus\treach_chain(site<-...<-vector)\n")
    for r in siterows: f.write("\t".join(r)+"\n")
import collections
c=collections.Counter(r[7] for r in rows)
print(len(rows),c)
for r in rows:
    if r[7]!="matched": print(r[0],r[2],r[5],r[7],r[1][:60])
