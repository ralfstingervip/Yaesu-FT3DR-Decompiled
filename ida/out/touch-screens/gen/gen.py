# Repository layout: this script lives under ida/out/; paths below are derived from its location.
from pathlib import Path as _Path
_REPO = _Path(__file__).resolve().parents[4]
import sys, re, os; sys.path.insert(0,'.')
from resolve import *
from tables import parse
OUT=(str(_REPO / "ida/out/touch-screens") + "/")
J3NINE={0x028452,0x02839A,0x02843C,0x02706C,0x02704C,0x027096,0x0271E6,0x027274,0x0270CA}
DIGIT_PP={0x270CA:'digit',0x27334:'digit',0x27648:'digit',0x279EA:'digit+remap'}
# page map
PM=[l.rstrip('\n').split('\t') for l in open('pagemap.txt')]
TABPAGES={}
for pages,tg,tab,guard in PM:
    TABPAGES.setdefault(int(tab,16),[]).append((pages,guard))
# page -> screens (ipc-reach chains via 0x782C + H13 notify_opcodes)
PS={}
for ln in open(str(_REPO / "ida/out/ipc-reach/main-sites.tsv"),encoding='utf-8').read().splitlines()[1:]:
    c=ln.split('\t')
    if len(c)<5: continue
    for m in re.finditer(r"tab00782C@[0-9A-F]+@([0-9A-F]+)",c[4]):
        PS.setdefault(c[0],set()).add((int(m.group(1),16)-0x782C)//4)
rows=[l.rstrip('\n').split('\t') for l in open(str(_REPO / "ida/out/hidden-settings/screens.tsv"),encoding='utf-8') if not l.startswith('#')]
H=rows[0]
for r in rows[1:]:
    d=dict(zip(H,r))
    for op in d['notify_opcodes'].split(','):
        if op.startswith('F'): PS.setdefault(op,set()).add(int(d['screen_id'],16))
def pscreens(pagekey):
    s=set()
    if pagekey=='F200-F22C':
        for k,v in PS.items():
            if k.startswith('F2') and k!='F280': s|=v
        return s
    return PS.get(pagekey,set())
def ev(v,pp):
    if v<0x8000:
        return ("button","A9ED=0x0A (touch key) ; BBC2=%d"%v)
    code=v&0xFF; hold=(v>>8)&1
    s="vkey A9ED=0x%02X%s ; BBC2=0"%(code," +hold(954B=0x32,BBC7=1 -> long-press A9EE.7)" if hold else "")
    if pp and code<0x0A: s+=" ; post: digit %d -> A9F0, A9ED=0x00"%code
    elif pp=='digit+remap' and code>=0x0A: s+=" ; post: A9ED=0x%02X (code-9)"%(code-9)
    return ("vkey",s)
def eff_key(v,pp):
    if v<0x8000: return 0x0A
    code=v&0xFF
    if pp and code<0x0A: return 0x00
    if pp=='digit+remap' and code>=0x0A: return code-9
    return code
out=["table\tzone\tx0\ty0\tx1\ty1\tvalue\tkind\tevent\tpages\tpage_guard\tscreens_for_page\taction\tj3_nine\tnote"]
nres=0; nz=0; nunres=0
for T in sorted(TABPAGES):
    c,recs=parse(T); pp=DIGIT_PP.get(T)
    for i,(x0,y0,x1,y1,v) in enumerate(recs):
        nz+=1
        note=""
        if x0>0x13F:
            note="trailer: Xmin=0x%04X>319, unmatchable (count overruns into next table header)"%x0
        elif y1>0xEF: note="Ymax=%d beyond panel (239); harmless over-tall zone"%y1
        kind,evs=ev(v,pp)
        acts=[]; scr_all=set()
        for pages,guard in TABPAGES[T]:
            for pg in pages.split(','):
                sc=pscreens(pg); scr_all|=sc
                if note.startswith('trailer'): continue
                if kind=='button':
                    pval=0xF200 if pg=='F200-F22C' else int(pg,16)
                    for r,kts,g,a in resolve(pval,v,sc):
                        acts.append("%s:%06X%s=>%s"%(pg,r,("["+g+"]") if g else "",a))
                else:
                    k=eff_key(v,pp)
                    for s in sorted(sc):
                        b=0x125D4+be16(0x1208C+2*(s-1)); h=be32(b+4*k)
                        acts.append("%s:scr%02X kt%05X slot%d=>%06X%s"%(pg,s,b,k,h," (softkey_clear)" if h==0x3FFA0 else ""))
                    if not sc: acts.append("%s:slot%d of current key table (screen not mapped)"%(pg,k))
        if acts: nres+=1
        else: nunres+=1
        out.append("\t".join(["%06X"%T,str(i),str(x0),str(y0),str(x1),str(y1),"0x%04X"%v,kind,evs,
            ";".join(sorted(set(p for p,g in TABPAGES[T]))), " | ".join(sorted(set("%s:%s"%(p,g) for p,g in TABPAGES[T])))[:400],
            ",".join("%02X"%s for s in sorted(scr_all)) or "-", " ; ".join(dict.fromkeys(acts)) or "unresolved", "J3" if T in J3NINE else "", note]))
open(OUT+"zones.tsv","w",encoding="utf-8",newline="\n").write("# Lane K3. Every touch zone table selected by the consumer at 0x0262E4 (page ladder 0x02639C-0x02669C on the SUB-reported page = [FF3D74]).\n# zone = 10 B {Xmin,Ymin,Xmax,Ymax,val} BE16; hit-test sub_26F08 (first match, inclusive bounds). val>=0: button -> BBC2=val, A9ED=0x0A. val<0: virtual key -> A9ED=val&0xFF (bit8 of val = hold/long-press arm).\n# action: <page>:<slot-10 handler root>[guard]=>effect (button) or <page>:scrNN ktXXXXX slotK=>handler (virtual key). Resolution: handler paths with explicit page test, or key table of a screen that sends the page (ipc-reach 0x782C chains + H13 notify_opcodes).\n"+"\n".join(out)+"\n")
print("tables",len(TABPAGES),"zones",nz,"resolved",nres,"unresolved",nunres)
