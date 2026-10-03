import sys
from pathlib import Path as _Path
_REPO_S = _Path(__file__).resolve().parents[4].as_posix()
import os,collections
W=(_REPO_S + "/ida/out/h8s-decode/work")
sys.exit("The firmware image is not in this repository.")
HI=0x7B754
def load(tag="before"):
    ids=open(os.path.join(W,"ida_decsize_%s.bin"%tag),"rb").read()
    items={}
    for ln in open(os.path.join(W,"items_%s.tsv"%tag),encoding="utf-8").read().splitlines()[1:]:
        ea,sz,k,st,fn,mn=ln.split("\t")
        items[int(ea,16)]=(int(sz),k,int(st),fn,mn)
    funcs=[]
    for ln in open(os.path.join(W,"funcs_%s.tsv"%tag),encoding="utf-8").read().splitlines()[1:]:
        s,e,n,c=ln.split("\t"); funcs.append((int(s,16),int(e,16),n,int(c)))
    return ids,items,funcs
BU={}
for ln in open(os.path.join(W,"bu_all.tsv"),encoding="utf-8"):
    a,n,t=ln.rstrip("\n").split("\t",2); a=int(a,16)
    BU[a]=(int(n),t.replace("\t"," "))
def bu(a): 
    n,t=BU[a]; return (0,t) if t.startswith(".word") or "Hmmm" in t or "Don't" in t else (n,t)
