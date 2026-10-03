# H1: backward path from a reached address to the proven seed that reaches it. Read-only.
from pathlib import Path
REPO = Path(__file__).resolve().parents[4].as_posix()  # repository root
import pickle,sys
sys.path.insert(0,(REPO + "/ida/out/h8s-decode/offline"))
from rd import flow
from reach import seeds_corrected,vec,TAB
S,seed,r,bad=pickle.load(open("local-temp","rb"))
pred={}
for a,(n,t,k) in r.items():
    _,_,_,tg=flow(a)
    succ=list(tg)
    if k not in("stop",): succ.append(a+n)
    for x in succ: pred.setdefault(x,[]).append(a)
tabsrc={}
for b,ts in TAB.items():
    for x in ts: tabsrc.setdefault(x,b)
def kind(a):
    if a in S: return S[a][1]+" start %06X"%a
    if a in vec: return "vector"
    if a in tabsrc: return "table %06X entry"%tabsrc[a]
    return "mov.l-table/switch case"
for tgt in map(lambda s:int(s,16),sys.argv[1:]):
    seen={tgt:None}; q=[tgt]; hit=None
    while q:
        a=q.pop(0)
        if a in seed: hit=a; break
        for p in pred.get(a,[]):
            if p not in seen: seen[p]=a; q.append(p)
    path=[]; a=hit
    while a is not None: path.append(a); a=seen[a]
    print("%06X <- seed %s ; path %s"%(tgt, kind(hit) if hit is not None else "NONE", " > ".join("%06X"%x for x in path)))
