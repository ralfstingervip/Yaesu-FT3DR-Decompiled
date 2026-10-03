import sys
from pathlib import Path as _Path
_REPO = _Path(__file__).resolve().parents[4]
import sys
W=str(_REPO) + r"/ida/out/h8s-decode/work/bu_all.tsv"
sys.exit('The firmware image is not in this repository.')
BU={}
for ln in open(W,encoding="utf-8"):
    a,n,t=ln.rstrip("\n").split("\t",2); BU[int(a,16)]=(int(n),t.replace("\t"," "))
def lin(a,end):
    out=[]
    while a<end:
        n,t=BU.get(a,(2,"?"))
        out.append("%06X  %-20s %s"%(a,IMG[a:a+n].hex(" "),t)); a+=n
    return out
if __name__=="__main__":
    a=int(sys.argv[1],16); e=int(sys.argv[2],16)
    print("\n".join(lin(a,e)))
