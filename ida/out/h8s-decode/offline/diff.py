from pathlib import Path as _Path
_REPO_S = _Path(__file__).resolve().parents[4].as_posix()
import sys; sys.path.insert(0,".")
from ctx import *
import pickle,json
ids,ib,fb=load("before")
_,ia,fa=load("after")
plan=json.load(open((_REPO_S + "/ida/out/h8s-decode/work/absorb_plan.json"),encoding="utf-8"))
P={a:(n,t) for a,n,t,o in plan["insns"]}
def cmask(items):
    m=bytearray(HI)
    for ea,(sz,k,st,fn,mn) in items.items():
        if k=="code":
            for x in range(ea,min(HI,ea+sz)): m[x]=1
    return m
mb=cmask(ib); ma=cmask(ia)
print("is_code before",sum(mb),"after",sum(ma))
pm=bytearray(HI)
for a,(n,t) in P.items():
    for x in range(a,a+n): pm[x]=1
gain=[x for x in range(HI) if ma[x] and not mb[x]]
loss=[x for x in range(HI) if mb[x] and not ma[x]]
print("gained bytes",len(gain),"in plan",sum(1 for x in gain if pm[x]),"outside plan",sum(1 for x in gain if not pm[x]))
print("lost bytes",len(loss))
W0=0x078106
og=[x for x in gain if not pm[x]]
print(" outside-plan gain in window",sum(1 for x in og if x>=W0))
# group outside-plan gains into runs
runs=[]
for x in og:
    if runs and x==runs[-1][1]: runs[-1][1]=x+1
    else: runs.append([x,x+1])
print("outside-plan gain runs",len(runs))
c=collections.Counter(runtype(r[0]) for r in runs); print(c)
for r in runs[:30]: print("  %06X-%06X %d %s"%(r[0],r[1],r[1]-r[0],runtype(r[0])))
lr=[]
for x in loss:
    if lr and x==lr[-1][1]: lr[-1][1]=x+1
    else: lr.append([x,x+1])
print("loss runs",len(lr)); 
for r in lr[:20]: print("  L %06X-%06X %d"%(r[0],r[1],r[1]-r[0]), ib.get(r[0]))
