import sys, re; sys.path.insert(0,'.')
from k3lib import *
HELP={0x2853E:3,0x28562:4,0x28586:5,0x285AA:6,0x285CE:7,0x285F2:8,0x28616:9,0x2863A:0xA,0x2865E:0xB,0x28682:0x13,0x286A6:0x17}
CW=(0x078106,0x07B754)
KT=[(0x1109C+0x44*i) for i in range(60)]+[(0x125D4+0x44*i) for i in range(131)]
def ktab_slot(k): return [ (b, be32(b+4*k)) for b in KT ]
TGT=re.compile(r"\((0x[0-9a-f]+)\)\s*$")
def okcode(a): return 0x400<=a<0x80000 and not (CW[0]<=a<CW[1]) and BU.get(a,(0,''))[0]>0 and not BU[a][1].startswith('.word')
def closure(roots, stop=set()):
    seen=set(); work=list(roots); edges_unres=[]; tabs=[]
    while work:
        a=work.pop()
        if a in seen or not okcode(a) or a in stop: continue
        # linear walk
        last_er6=None; last_er1=None
        while True:
            if a in seen and a not in roots: break
            seen.add(a)
            n,t=BU.get(a,(0,''))
            if n==0 or t.startswith('.word') or CW[0]<=a<CW[1]: break
            p=t.split(' ',1); m=p[0]; op=p[1] if len(p)>1 else ''
            mo=re.match(r"#0x([0-9a-f]+),er6$",op)
            if m=='mov.l' and mo: last_er6=int(mo.group(1),16)
            mo1=re.match(r"#0x([0-9a-f]+),er1$",op)
            if m=='mov.l' and mo1: last_er1=int(mo1.group(1),16)
            mt=re.match(r"@\((0x[0-9a-f]+):32,er\d\),er6$",op)
            if m=='mov.l' and mt: last_er6=('jt',int(mt.group(1),16))
            if m in ('rts','rte'): break
            if m in ('jsr','jmp'):
                ma=re.match(r"@(0x[0-9a-f]+):24",op)
                if ma:
                    tg=int(ma.group(1),16)
                    if tg in HELP and isinstance(last_er6,int):
                        for i in range(HELP[tg]-1):
                            work.append(be32(last_er6+4*i))
                        tabs.append((a,last_er6,HELP[tg]-1))
                    if tg==0x28CBC and last_er1:
                        for o in (0,4,8,0xC,0x14,0x18,0x1C): work.append(be32(last_er1+o))
                    work.append(tg)
                    if m=='jmp': break
                else:
                    if isinstance(last_er6,tuple):
                        T=last_er6[1]; i=0
                        while i<64 and okcode(be32(T+4*i)): work.append(be32(T+4*i)); i+=1
                        tabs.append((a,T,i))
                    else: edges_unres.append(a)
                    if m=='jmp': break
                a+=n; continue
            mm=TGT.search(op)
            if m in ('bra','bra/s') and mm:
                tg=int(mm.group(1),16)
                if tg==0x28CBC and last_er1:
                    for o in (0,4,8,0xC,0x14,0x18,0x1C): work.append(be32(last_er1+o))
                work.append(tg); break
            if m in ('bsr',) and mm: work.append(int(mm.group(1),16))
            elif m.startswith('b') and mm and m not in ('bld','bst','bset','bclr','btst','bnot','bist','bor','band','bxor','bild','bior','biand','bixor','brn'):
                work.append(int(mm.group(1),16))
            a+=n
    return seen, edges_unres, tabs
