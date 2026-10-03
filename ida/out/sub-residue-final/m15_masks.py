"""M15: residue from the published K7_SUB_FINAL3 masks (read-only)."""
# Repository layout: this script lives under ida/out/; paths below are derived from its location.
from pathlib import Path as _Path
_REPO = _Path(__file__).resolve().parents[3]
def _no_image():
    import sys
    sys.exit("The firmware image is not in this repository.")
import hashlib, os
R = str(_REPO)
SUB = os.path.join(R, _no_image())
MAIN = os.path.join(R, _no_image())
for p in (MAIN, SUB):
    print(os.path.basename(p), hashlib.sha256(open(p, "rb").read()).hexdigest())
RAW = os.path.join(R, "ida/out/sub-final3/raw")
WLO = 0xFFED0000
def m(n): return open(os.path.join(RAW, "mask_final3_after_%s.bin" % n), "rb").read()
H, HW, A, RE, RW = m("headline"), m("headline_w2"), m("allwf"), m("reach"), m("reach_w2")
for n, x in (("headline", H), ("headline_w2", HW), ("allwf", A), ("reach", RE), ("reach_w2", RW)):
    print(n, sum(x), len(x))
print("hw subset allwf", all(a or not h for h, a in zip(HW, A)))
res = [i for i in range(len(A)) if A[i] and not HW[i]]
print("residue", len(res))
runs = []
for i in res:
    if runs and runs[-1][1] == i: runs[-1][1] = i + 1
    else: runs.append([i, i + 1])
print("runs", len(runs))
for s, e in runs: print("%08X %08X %d" % (WLO + s, WLO + e, e - s))
