# Lane L6. Parent-tracking variant of K3's dclosure (same edge rules) to explain open-check hits. Read-only.
from pathlib import Path as _Path
_REPO_S = _Path(__file__).resolve().parents[4].as_posix()
import sys, re, os
K3GEN = (_REPO_S + "/ida/out/touch-screens/gen")
sys.path.insert(0, K3GEN); cwd=os.getcwd(); os.chdir(K3GEN)
from dclos import BU, CW, HELP, TGT, okcode, be32
os.chdir(cwd)
RESTART={0x2050,0x2092}
RESTART_HITS=[]
def trace(roots, D=4):
    best={}; par={}; work=[(r,0,None) for r in roots]
    while work:
        a,d,pa=work.pop(0)
        if not okcode(a) or (a in best and best[a]<=d): continue
        if a not in par: par[a]=pa
        last_er6=None; last_er1=None; blk=a
        while True:
            if a in best and best[a]<=d: break
            best[a]=d; par.setdefault(a,('flow',blk))
            n,t=BU.get(a,(0,''))
            if n==0 or t.startswith('.word') or CW[0]<=a<CW[1]: break
            p=t.split(' ',1); m=p[0]; op=p[1] if len(p)>1 else ''
            mo=re.match(r"#0x([0-9a-f]+),er6$",op)
            if m=='mov.l' and mo: last_er6=int(mo.group(1),16)
            mo1=re.match(r"#0x([0-9a-f]+),er1$",op)
            if m=='mov.l' and mo1: last_er1=int(mo1.group(1),16)
            mt=re.match(r"@\((0x[0-9a-f]+):32,er\d\),er6$",op)
            if m=='mov.l' and mt: last_er6=('jt',int(mt.group(1),16))
            if m in ('rts','rts/l','rte','rte/l','sleep'): break
            if m in ('jsr','jmp'):
                ma=re.match(r"@(0x[0-9a-f]+):24",op); nd = d+1 if m=='jsr' else d
                if ma:
                    tg=int(ma.group(1),16)
                    if tg in HELP and isinstance(last_er6,int):
                        for i in range(HELP[tg]-1):
                            if d+1<=D: work.append((be32(last_er6+4*i),d+1,a))
                    if tg in RESTART: RESTART_HITS.append((a,tg))
                    elif tg!=0x3FFA0 and nd<=D: work.append((tg,nd,a))
                    if m=='jmp': break
                else:
                    if isinstance(last_er6,tuple):
                        T=last_er6[1]; i=0
                        while i<64 and okcode(be32(T+4*i)):
                            if nd<=D: work.append((be32(T+4*i),nd,a))
                            i+=1
                    if m=='jmp': break
                a+=n; continue
            mm=TGT.search(op)
            if m in ('bra','bra/s') and mm:
                tg=int(mm.group(1),16)
                if tg==0x28CBC and last_er1:
                    for o in (0,4,8,0xC,0x14,0x18,0x1C):
                        v=be32(last_er1+o)
                        if v and d+1<=D: work.append((v,d+1,a))
                work.append((tg,d,a)); break
            if m=='bsr' and mm:
                if d+1<=D: work.append((int(mm.group(1),16),d+1,a))
            elif m.startswith('b') and mm and m not in ('bld','bst','bset','bclr','btst','bnot','bist','bor','band','bxor','bild','bior','biand','bixor','brn'):
                work.append((int(mm.group(1),16),d,a))
            a+=n
    return best, par
def chain(par, a, lim=40):
    out=[]; cur=a
    for _ in range(lim):
        p=par.get(cur)
        if p is None: out.append('ROOT %06X'%cur); break
        if isinstance(p,tuple): cur=p[1]; continue   # within block -> block start
        out.append('%06X<-%06X'%(cur,p)); cur=p
    return out
