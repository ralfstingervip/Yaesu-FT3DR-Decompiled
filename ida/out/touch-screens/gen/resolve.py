import sys, re; sys.path.insert(0,'.')
from hwalk import *
from k3lib import *
PASSER={0x28B62:0x28B6C,0x28BAA:0x28BB4,0x28BE6:0x28BF0,0x28C20:0x28C2A,0x28C5A:0x28C62,0x28C82:0x28C8A,0x296DE:0x296E8,0x29708:0x29712}
RECF={1:None,2:None,3:0x0C,4:0x08,5:0x08,6:0x14,7:0x18}
def rec_action(rec,k):
    if k in (1,2): return "rec%05X: cursor-mode toggle (0xFFBC34), no field call"%rec
    if k in (3,4,5,6,7):
        o=RECF[k]; return "rec%05X+%02X -> %06X"%(rec,o,be32(rec+o))
    if 10<=k<=19 or (k>20 and k<0x8000): return "rec%05X+00 -> %06X (char idx %d -> A9F0)"%(rec,be32(rec),k-10)
    if k==20: return "rec%05X+04/+1C -> %06X/%06X (by 0xFFBC34)"%(rec,be32(rec+4),be32(rec+0x1C))
    return "rec%05X: softkey_clear (k=%d)"%(rec,k)
KT=[(0x1109C+0x44*i) for i in range(60)]+[(0x125D4+0x44*i) for i in range(131)]
SCRK={}
for s in range(1,0xEF):
    b=0x125D4+be16(0x1208C+2*(s-1)); SCRK.setdefault(b,[]).append(s)
def kt_name(b):
    if b>=0x125D4: return "kt%05X(scr %s)"%(b,",".join("%02X"%s for s in SCRK.get(b,[])) or "none")
    return "kt%05X(home/main #%d)"%(b,(b-0x1109C)//0x44)
ROOTS={}
for b in KT:
    ROOTS.setdefault(be32(b+40),[]).append(b)
WALK={r:hwalk(r) for r in ROOTS}
def atoms(conds):
    pe=None; pne=set(); ie=None; ine=set(); irng=[]; other=[]
    for c in conds:
        m=re.match(r"\[PAGE\](==|!=)0x([0-9a-f]+)$",c)
        if m:
            v=int(m.group(2),16)
            if m.group(1)=='==': pe=v
            else: pne.add(v)
            continue
        m=re.match(r"\[(?:IDX|FFBBC2)\](==|!=|<|>=|>|<=)0x([0-9a-f]+)$",c) or re.match(r"\[(?:IDX|FFBBC2)\](==|!=|<|>=|>|<=)(\d+)$",c)
        if m:
            v=int(m.group(2),16) if 'x' in c.split(m.group(1))[1] else int(m.group(2))
            if m.group(1)=='==': ie=v
            elif m.group(1)=='!=': ine.add(v)
            else: irng.append((m.group(1),v))
            continue
        other.append(c)
    return pe,pne,ie,ine,irng,other
def idx_ok(k,ie,ine,irng):
    if ie is not None and ie!=k: return False
    if k in ine: return False
    for op,v in irng:
        if op=='<' and not k<v: return False
        if op=='>=' and not k>=v: return False
        if op=='>' and not k>v: return False
        if op=='<=' and not k<=v: return False
    return True
def act_for(action,k):
    m=re.match(r"idxdisp\(limit=(\d+),table=0x([0-9a-f]+)\)",action)
    if m:
        L=int(m.group(1)); T=int(m.group(2),16)
        return ("tbl%05X[%d] -> %06X"%(T,k-1,be32(T+4*(k-1)))) if 1<=k<L else "softkey_clear (idx>=limit)"
    m=re.match(r"(jsr|jmp|bsr) ([0-9A-F]{6})$",action)
    if m and int(m.group(2),16) in PASSER: return rec_action(PASSER[int(m.group(2),16)],k)
    m=re.match(r"record\(0x([0-9a-f]+)\)",action)
    if m: return rec_action(int(m.group(1),16),k)
    return action
def resolve(page,k,screens_for_page):
    """return list of (root, kt list, guard, action)"""
    out=[]
    for r,paths in WALK.items():
        kts=ROOTS[r]
        explicit=any(atoms(c)[0]==page for c,a in paths)
        bysc=any(s in screens_for_page for b in kts for s in SCRK.get(b,[]))
        if not (explicit or bysc): continue
        for c,a in paths:
            if a in ('rts','steplimit'): continue
            pe,pne,ie,ine,irng,other=atoms(c)
            if pe is not None and pe!=page: continue
            if page in pne: continue
            if pe is None and not bysc: continue
            if not idx_ok(k,ie,ine,irng): continue
            out.append((r,kts," & ".join(other),act_for(a,k)))
    return out
