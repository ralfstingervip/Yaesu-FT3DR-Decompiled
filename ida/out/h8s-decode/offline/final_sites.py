import sys; sys.path.insert(0,".")
from clean import *
from forms import norm
import pickle
ids,items,funcs=load()
rA,seedA,ut=pickle.load(open("tierA.pkl","rb"))
rB,seedB=pickle.load(open("tierB2.pkl","rb"))
_,rF,rR,_=pickle.load(open("tiers.pkl","rb"))
W0,W1=0x078106,0x07B754
M0=0x075F36
def is78(a): return IMG[a]==0x78 and IMG[a+1]&0x8f==0x80 and IMG[a+2]==0x6b and IMG[a+3]&0xf0==0x20
code={ea for ea,v in items.items() if v[1]=="code"}
allr={}
for r in (rR,rB,rF): allr.update(r)
allr.update(rA)
cand=set(a for a in allr if ids[a]==0)
cand|=set(a for a in range(0,HI-8,2) if is78(a))
from gaps import gap_insns
GAPSET={a for a,n,s_ in gap_insns()}
cand|=set(a for a in GAPSET if ids[a]==0)
known=set(rA)
def pred_ok(a, depth=2):
    if depth==0: return True
    for k in (2,4,6,8,10):
        b=a-k
        if b<0: continue
        n,t=bu(b)
        if n==k and not t.startswith(("rts","rte","jmp","bra ")) and pred_ok(b,depth-1): return True
    return False
rows=[]
for a in sorted(cand):
    n,t=bu(a)
    if a in rA: tier="A"
    else:
        ok,why,nn,ns,an=local_clean(a,known)
        if a>=W0: tier="W?" if ok else "X"
        elif is78(a): tier="B" if ok and (pred_ok(a) or a in allr) else "X"
        elif M0<=a<W0: tier="B" if ok else "X"
        else: tier="X"
    if a>=W0 and tier!="X": tier="W"
    rows.append((a,n,t,tier))
pickle.dump(rows,open("sites.pkl","wb"))
c=collections.Counter((r[3]) for r in rows); print(c)
c=collections.Counter((r[3], "78MOVL" if is78(r[0]) else "other") for r in rows); print(sorted(c.items()))

C=collections.defaultdict(list)
for a,n,t,tier in rows:
    if tier in "ABW": C[(norm(t),IMG[a:a+1].hex())].append((a,tier,n))
for k,v in sorted(C.items(),key=lambda x:-len(x[1])):
    tc=collections.Counter(x[1] for x in v)
    print("%4d A=%-3d B=%-3d W=%-3d len=%s  %-38s %s"%(len(v),tc["A"],tc["B"],tc["W"],sorted(set(x[2] for x in v)),k[0]," ".join("%06X:%s"%(a,IMG[a:a+n].hex()) for a,_,n in v[:2])))
