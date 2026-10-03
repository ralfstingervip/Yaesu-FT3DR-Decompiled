# Lane M3: re-run K1's folded descent (pure prefix of k1_build_masks.py, exec'd as L3 did; no writes) with the L-wave's
# 6 new edges, with and without H9 fnindex seeds, and measure reach over the 22 runs. Writes ../work/m3_descent.txt only.
from pathlib import Path
REPO = Path(__file__).resolve().parents[4].as_posix()  # repository root
import sys, time
sys.dont_write_bytecode = True
ROOT = (REPO + "/")
K1SRC = ROOT + "ida/out/main-final4/offline/k1_build_masks.py"
src = open(K1SRC, encoding="utf-8").read()
cut = src.index("# attribution runs (each rule alone)")
G = {"__name__": "k1prefix", "__file__": K1SRC}
exec(compile(src[:cut], K1SRC, "exec"), G)
D9 = G["D9"]; run_folded = G["run_folded"]; COMBINED = G["COMBINED"]; HI = G["HI"]; INW = G["INW"]
sys.path.insert(0, ROOT + "ida/out/punr-mid/offline")
from m3_common import MINE, MK, P6
NEW = [(0x018250, "L2"), (0x018ABE, "L2"), (0x01A094, "L2"), (0x05E8E0, "L4"), (0x066FB4, "L4"), (0x067250, "L4"),
       (0x066FBE, "L-recon hand"), (0x06726A, "L-recon hand")]
def bm(r):
    m = bytearray(HI)
    for a, (n, t, k) in r["reached"].items():
        for x in range(a, min(HI, a + n)):
            if not INW(x): m[x] = 1
    return m
L = []; t0 = time.time()
rA, _ = run_folded(COMBINED + NEW); MA = bm(rA)
FN = dict(D9.FNSEED); D9.FNSEED.clear()
rB, _ = run_folded(COMBINED + NEW); MB = bm(rB)
D9.FNSEED.update(FN)
L.append("check: MK reach over runs = %d (expect 0)" % sum(MK[x] for s, e, n in MINE for x in range(s, e)))
for s, e, n in MINE:
    L.append("%06X-%06X %3d  reach(fnindex+8 new)=%d  reach(no fnindex+8 new)=%d  P6=%d" % (s, e, n, sum(MA[s:e]), sum(MB[s:e]), sum(P6[s:e])))
L.append("total over 574 B: with-fnindex %d, without %d; %.0fs" % (sum(MA[x] for s, e, n in MINE for x in range(s, e)),
         sum(MB[x] for s, e, n in MINE for x in range(s, e)), time.time() - t0))
open(ROOT + "ida/out/punr-mid/work/m3_descent.txt", "w", encoding="utf-8").write("\n".join(L) + "\n")
print("\n".join(L))
