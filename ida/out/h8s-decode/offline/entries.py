from pathlib import Path as _Path
_REPO_S = _Path(__file__).resolve().parents[4].as_posix()
import sys; sys.path.insert(0,".")
from rd import *
import json,pickle,re
ids,ib,fb=load("before"); _,ia,fa=load("after")
plan=json.load(open((_REPO_S + "/ida/out/h8s-decode/work/absorb_plan.json"),encoding="utf-8"))
P={a:(n,t) for a,n,t,o in plan["insns"]}
sites={a:t for a,n,t in plan["sites"]}
code={a:v for a,v in ia.items() if v[1]=="code" and a%2==0}
heads=sorted(code)
# targets from all code: calls & jumps
calls=set(); jumps=set()
for a in heads:
    n,t,k,tg=flow(a)
    for x in tg:
        (calls if k=="call" else jumps).add(x)
rA,seedA,ut=pickle.load(open("tierA.pkl","rb"))
MF=(_REPO_S + "/ida/out/main-full/")
TAB={}
for fn in ["jumptables.tsv","switch_tables.tsv"]:
    for ln in open(MF+fn,encoding="utf-8").read().splitlines()[1:]:
        c=ln.split("\t"); TAB.setdefault(int(c[0],16),set()).update(int(t,16) for t in c[3].split(",") if t)
tabt=set()
for b in ut: tabt|=TAB.get(b,set())
import bisect
def run_start(a):
    i=bisect.bisect_left(heads,a)
    while i>0:
        p=heads[i-1]
        if p+code[p][0]!=heads[i] or code[p][3]!="-": break
        if flow(p)[2] in("stop","stops"): break
        i-=1
    return heads[i]
PRO=re.compile(r"(stm\.l er\d-er\d,@-sp|mov\.l er\d,@-er7)")
out=collections.Counter(); ent={}
for s,t in sites.items():
    if ia[s][3]!="-": continue
    r=run_start(s)
    why=[]
    if r in calls: why.append("call")
    if r in tabt: why.append("table")
    if r in jumps: why.append("jump")
    if PRO.match(bu(r)[1]): why.append("prologue")
    p=heads[bisect.bisect_left(heads,r)-1]
    prevstop = flow(p)[2] in ("stop","stops") or p+code[p][0]!=r
    ent.setdefault(r,[]).append(s)
    out[(tuple(why),prevstop)]+=1
for k,v in out.most_common(): print(v,k)
print("distinct run starts",len(ent))
pickle.dump((ent,calls,jumps,tabt),open("entries.pkl","wb"))
