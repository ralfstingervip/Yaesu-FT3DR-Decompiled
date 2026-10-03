from pathlib import Path as _Path
_REPO = _Path(__file__).resolve().parents[4]
# H9: compare H9 descents with H1's reach (scratchpad reach.pkl written by H1's reach.py). Read-only.
import sys, pickle, collections
sys.dont_write_bytecode = True
sys.path.insert(0, str(_REPO) + r"/ida/out/main-descent/offline")
from common import *
res = pickle.load(open(SCR + "descent.pkl", "rb"))
h1 = pickle.load(open(SCR + "../reach.pkl", "rb"))[2]
def mask(r):
    m = bytearray(HI)
    for a, v in r.items():
        for x in range(a, min(HI, a + v[0])): m[x] = 1
    return m
M = {k: mask(v["reached"]) for k, v in res.items()}
M["H1"] = mask(h1)
RC = bytearray(HI)
for s, e, t in RUNS:
    if t == "recovered code":
        for x in range(s, e): RC[x] = 1
print("RC bytes", sum(RC))
for k, m in M.items():
    print(k, "reached", sum(m), "RC reached", sum(1 for x in range(HI) if RC[x] and m[x]), "RC unreached", sum(1 for x in range(HI) if RC[x] and not m[x]))
for k in ("full", "h1like", "strict"):
    a = sum(1 for x in range(HI) if M[k][x] and not M["H1"][x]); b = sum(1 for x in range(HI) if M["H1"][x] and not M[k][x])
    print(k, "vs H1: +%d -%d" % (a, b), " RC: +%d -%d" % (sum(1 for x in range(HI) if RC[x] and M[k][x] and not M["H1"][x]), sum(1 for x in range(HI) if RC[x] and M["H1"][x] and not M[k][x])))
