# Lane M3: shared loaders. Read-only on every input.
from pathlib import Path
REPO = Path(__file__).resolve().parents[4].as_posix()  # repository root
import sys, pickle, re
sys.dont_write_bytecode = True
sys.path.insert(0, (REPO + "/ida/out/main-descent/offline"))
from common import IMG, HI, flow, bu, be32
ROOT = (REPO + "/")
P6 = open(ROOT + "ida/out/l-wave-recon/final6_proven_mask.bin", "rb").read()
N6 = open(ROOT + "ida/out/l-wave-recon/final6_named_mask.bin", "rb").read()
P4 = open(ROOT + "ida/out/main-final4/final4_proven_mask.bin", "rb").read()
_D = pickle.load(open(ROOT + "ida/out/fnindex-mid/work/descents.pkl", "rb"))
MK = bytearray(HI)                 # K1 folded descent WITH fnindex seeds (L3 work pickle == L2 reach MK)
for a, (n, t, k) in _D["rK_reached"].items():
    for x in range(a, min(HI, a + n)): MK[x] = 1
RK = _D["rK_reached"]
def INW(a): return 0x078106 <= a < 0x07B754
RUNS = []
for ln in open(ROOT + "ida/out/l-wave-recon/proven-unreached-runs.tsv", encoding="utf-8").read().splitlines()[2:]:
    c = ln.split("\t"); RUNS.append((int(c[0], 16), int(c[1], 16), int(c[2])))
MINE = [r for r in RUNS if 0x30000 <= r[0] < 0x58000]
assert len(MINE) == 22 and sum(r[2] for r in MINE) == 574, (len(MINE), sum(r[2] for r in MINE))
PU = bytearray(HI)
for s, e, n in RUNS:
    for x in range(s, e): PU[x] = 1
def cls(a):
    if a >= HI: return "beyond"
    if INW(a): return "window"
    if MK[a] and P6[a]: return "reached"
    if MK[a]: return "reached-notP6"
    if PU[a]: return "punr"
    if P6[a]: return "P6-other"
    if N6[a]: return "named"
    return "unnamed"
def c1(a):
    return {"reached": "R", "reached-notP6": "r", "punr": "U", "P6-other": "p", "named": "n", "unnamed": ".", "window": "W", "beyond": "-"}[cls(a)]
def dis(a, e):
    out = []
    while a < e:
        n, t, k, tg = flow(a)
        if not n:
            out.append("  %06X %s %-12s .word" % (a, c1(a), IMG[a:a + 2].hex())); a += 2; continue
        out.append("  %06X %s %-14s %s" % (a, c1(a), IMG[a:a + n].hex(), t)); a += n
    return out
