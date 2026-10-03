# H1: size the next correction (not applied): even-aligned IDA code over typed data, and recovered-code bytes no proven flow reaches.
from pathlib import Path
REPO = Path(__file__).resolve().parents[4].as_posix()  # repository root
import sys,pickle,collections
sys.path.insert(0,(REPO + "/ida/out/h8s-decode/offline"))
from ctx import runs
from rd import HI,IMG
_,_,r,_=pickle.load(open("local-temp","rb"))
PR=bytearray(HI)
for a,(n,t,k) in r.items():
    for x in range(a,a+n): PR[x]=1
mh=bytearray(HI)
for ln in open((REPO + "/ida/out/recount/work/items_h1.tsv"),encoding="utf-8").read().splitlines()[1:]:
    ea,sz,k=ln.split("\t")
    if k=="code":
        for x in range(int(ea,16),int(ea,16)+int(sz)): mh[x]=1
c=collections.Counter(); rc_un=0; rc_un_ascii=0
for s,e,t in runs:
    for x in range(s,e):
        if mh[x] and not PR[x]: c[t]+=1
    if t=="recovered code":
        # printable runs >= 6 not reached
        i=s
        while i<e:
            j=i
            while j<e and (32<=IMG[j]<127) and not PR[j]: j+=1
            if j-i>=6: rc_un_ascii+=j-i
            i=max(j,i+1)
        rc_un+=sum(1 for x in range(s,e) if not PR[x])
print("IDA is_code bytes (H1_RECOUNT) inside W2-8 runs, not reached by proven flow, by run type:",dict(c))
print("recovered-code run bytes not reached by proven flow:",rc_un,"of which printable runs >=6:",rc_un_ascii)
