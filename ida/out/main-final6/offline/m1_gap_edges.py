from pathlib import Path as _Path
_REPO = _Path(__file__).resolve().parents[4]
# Lane M1: who reaches the two stale-head gaps? Whole-image scan (0..0x7B754) for every edge into the enclosing blocks.
# Read-only. Oracle = binutils H8SX decode per address (h8s-decode/work/bu_all.tsv).
import sys, re
sys.dont_write_bytecode = True
sys.path.insert(0, str(_REPO) + r"/ida/out/main-descent/offline")
from common import IMG, BU, HI, be32, flow
P6 = open(str(_REPO) + r"/ida/out/l-wave-recon/final6_proven_mask.bin", "rb").read()
TM = open(str(_REPO) + r"/ida/out/main-final6/MAIN_FINAL6_typemask.bin", "rb").read()
H = {}
for l in open(str(_REPO) + r"/ida/out/main-final6/MAIN_FINAL6_heads.tsv").read().splitlines()[1:]:
    a, n, k = l.split("\t"); H[int(a, 16)] = (int(n), k)
for lo, hi in ((0x0069F0, 0x006A1C), (0x0077B0, 0x007806)):
    print("== block %06X-%06X" % (lo, hi))
    # back to the block entry: walk back over DB code heads while they flow
    tg = {}
    for a in sorted(BU):
        if a & 1 or a >= HI: continue
        n, t, k, ts = flow(a)
        for x in ts:
            if lo <= x < hi: tg.setdefault(x, []).append((a, t, P6[a], H.get(a, (0, "-"))[1]))
    for x in sorted(tg):
        print("  target %06X <- %s" % (x, "; ".join("%06X '%s' P6=%d db=%s" % r for r in tg[x][:6])))
    for i in range(HI - 3):
        v = be32(i)
        if lo <= v < hi: print("  BE32 %08X at %06X (bytes %s) P6=%d" % (v, i, IMG[i:i + 4].hex(), P6[i]))
        if IMG[i] in (0x5E, 0x5A) and lo <= int.from_bytes(IMG[i + 1:i + 4], "big") < hi:
            print("  abs24 %02X %06X at %06X" % (IMG[i], int.from_bytes(IMG[i + 1:i + 4], "big"), i))
    print("  DB heads:", " ".join("%06X+%d%s/P%d" % (a, H[a][0], H[a][1], P6[a]) for a in sorted(H) if lo <= a < hi))
