from pathlib import Path as _Path
_REPO_S = _Path(__file__).resolve().parents[4].as_posix()
from rd import *
import bisect,pickle
ids,items,funcs=load()
MF=(_REPO_S + "/ida/out/main-full/")
code={ea:v for ea,v in items.items() if v[1]=="code"}
S=seeds_proven()
iv=sorted((s,e) for s,(e,_) in S.items()); st=[s for s,e in iv]
def inproven(a):
    i=bisect.bisect_right(st,a)-1
    return i>=0 and iv[i][0]<=a<iv[i][1]
tab=set()
for fn in ["jumptables.tsv","switch_tables.tsv"]:
    for ln in open(MF+fn,encoding="utf-8").read().splitlines()[1:]:
        c=ln.split("\t")
        for t in c[3].split(","):
            if t: tab.add(int(t,16))
vec=set()
for ln in open(MF+"vectors.tsv",encoding="utf-8").read().splitlines()[1:]:
    c=ln.split("\t"); vec.add(int(c[2],16))
seedA=set(S)|{a for a in code if inproven(a) and a%2==0}|{t for t in tab if t<HI and t%2==0}|{v for v in vec if v<HI}
rA,badA,_=descend(list(seedA))
fs=sorted((s,e) for s,e,n,c in funcs); fst=[s for s,e in fs]
def infunc(a):
    i=bisect.bisect_right(fst,a)-1
    return i>=0 and fs[i][0]<=a<fs[i][1]
seedF=seedA|{a for a in code if a%2==0 and infunc(a)}|set(fst)
rF,badF,_=descend(list(seedF))
seedR=seedF|{a for a in code if a%2==0}
rR,badR,_=descend(list(seedR))
print("tableseeds",len(tab),"vec",len(vec))
for nm,r in (("A",rA),("F",rF),("R",rR)):
    s=[a for a in r if ids[a]==0]
    print(nm,"reached",len(r),"h8s-undecodable sites",len(s))
pickle.dump((rA,rF,rR,seedA),open("tiers.pkl","wb"))
