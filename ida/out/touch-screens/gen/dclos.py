import sys, re; sys.path.insert(0,'.')
from scrw import *
NOFOLLOW={0x3FFA0}  # softkey_clear: no screen change (checked separately)
def dclosure(roots, D=3):
    best={}; work=[(r,0) for r in roots]; seen=set(); unres=[]
    while work:
        a,d=work.pop()
        if not okcode(a) or (a in best and best[a]<=d): continue
        last_er6=None; last_er1=None
        while True:
            if a in best and best[a]<=d: break
            best[a]=d
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
                nd = d+1 if m=='jsr' else d
                if ma:
                    tg=int(ma.group(1),16)
                    if tg in HELP and isinstance(last_er6,int):
                        for i in range(HELP[tg]-1): 
                            if d+1<=D: work.append((be32(last_er6+4*i),d+1))
                    if tg not in NOFOLLOW and nd<=D: work.append((tg,nd))
                    if m=='jmp': break
                else:
                    if isinstance(last_er6,tuple):
                        T=last_er6[1]; i=0
                        while i<64 and okcode(be32(T+4*i)):
                            if nd<=D: work.append((be32(T+4*i),nd))
                            i+=1
                    else: unres.append(a)
                    if m=='jmp': break
                a+=n; continue
            mm=TGT.search(op)
            if m in ('bra','bra/s') and mm:
                tg=int(mm.group(1),16)
                if tg==0x28CBC and last_er1:
                    for o in (0,4,8,0xC,0x14,0x18,0x1C):
                        v=be32(last_er1+o)
                        if v and d+1<=D: work.append((v,d+1))
                work.append((tg,d)); break
            if m=='bsr' and mm:
                if d+1<=D: work.append((int(mm.group(1),16),d+1))
            elif m.startswith('b') and mm and m not in ('bld','bst','bset','bclr','btst','bnot','bist','bor','band','bxor','bild','bior','biand','bixor','brn'):
                work.append((int(mm.group(1),16),d))
            a+=n
    return best, unres
