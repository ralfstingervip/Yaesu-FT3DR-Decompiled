from pathlib import Path as _Path
_REPO_S = _Path(__file__).resolve().parents[4].as_posix()
from load import *
import bisect
RT=(_REPO_S + "/ida/out/wave2/main-raw-types.tsv")
runs=[]
for ln in open(RT,encoding="utf-8").read().splitlines()[1:]:
    c=ln.split("\t"); runs.append((int(c[0],16),int(c[1],16),c[3]))
runs.sort(); rst=[r[0] for r in runs]
def runtype(a):
    i=bisect.bisect_right(rst,a)-1
    if i>=0 and runs[i][0]<=a<runs[i][1]: return runs[i][2]
    return None
MF=(_REPO_S + "/ida/out/main-full/functions.tsv")
