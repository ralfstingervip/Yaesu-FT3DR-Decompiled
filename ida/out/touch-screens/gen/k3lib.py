# Repository layout: this script lives under ida/out/; paths below are derived from its location.
from pathlib import Path as _Path
_REPO = _Path(__file__).resolve().parents[4]
def _no_image():
    import sys
    sys.exit("The firmware image is not in this repository.")
import sys, re
sys.dont_write_bytecode = True
R = (str(_REPO / "ida/out") + "/")
IMG = open(_no_image(),"rb").read()
BU = {}
for ln in open(R+"h8s-decode/work/bu_all.tsv",encoding="utf-8"):
    a,n,t = ln.rstrip("\n").split("\t",2); BU[int(a,16)] = (int(n), t.replace("\t"," ").strip())
PROVEN = open(R+"main-final3/final3_proven_mask.bin","rb").read()
def proven(a): return PROVEN[a] if a < len(PROVEN) else 0
def be32(a): return int.from_bytes(IMG[a:a+4],"big")
def be16(a): return int.from_bytes(IMG[a:a+2],"big")
def dis(a, e=None, n=None):
    out=[]; c=0
    while (e is None or a<e) and (n is None or c<n):
        l,t = BU.get(a,(2,".word"))
        if l==0: l=2
        out.append("%06X %-24s %s%s" % (a, IMG[a:a+l].hex(" "), t, "" ))
        a+=l; c+=1
    return out
def find(pat):
    b=bytes.fromhex(pat.replace(" ","")); r=[]; i=IMG.find(b)
    while i>=0: r.append(i); i=IMG.find(b,i+1)
    return r
import bisect
FUNCS=[]
for ln in open(R+"main-final3/MAIN_FINAL3_functions_raw.tsv").read().splitlines()[1:]:
    s,e,_=ln.split("\t"); FUNCS.append((int(s,16),int(e,16)))
FUNCS.sort(); FST=[f[0] for f in FUNCS]
def func_of(a):
    i=bisect.bisect_right(FST,a)-1
    if i>=0 and FUNCS[i][0]<=a<FUNCS[i][1]: return FUNCS[i][0]
    return None
def insns():
    for a,(n,t) in sorted(BU.items()): yield a,n,t
