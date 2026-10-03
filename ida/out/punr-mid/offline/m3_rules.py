# Lane M3: which H9 analyze.py rule keeps each byte of the 22 proven-unreached runs (0x030000-0x057FFF) in the proven mask.
# H9 proven = (PU & ~RCU & ~DU) | NEWP, PU = A | RC | D | G1A (analyze.py lines "proven sets"/"ledger"). Read-only.
from pathlib import Path
REPO = Path(__file__).resolve().parents[4].as_posix()  # repository root
import sys, collections
sys.dont_write_bytecode = True
sys.path.insert(0, (REPO + "/ida/out/main-descent/offline"))
sys.path.insert(0, (REPO + "/ida/out/punr-mid/offline"))
import analyze as A9
import masks as M9
import descent as D9
from m3_common import MINE, P4, P6, MK, IMG
H9P = open((REPO + "/ida/out/main-final/h9_proven_mask.bin"), "rb").read()
FNSPAN = {}
for s, e in M9.FN.items(): FNSPAN[s] = e
def fn_cover(x):
    return sorted("%06X-%06X" % (s, e) for s, e in M9.FN.items() if s <= x < e)
def rule(x):
    r = []
    if A9.A[x]: r.append("A")
    if A9.RC[x]: r.append("RC")
    if A9.D[x]: r.append("D")
    if A9.G1A[x]: r.append("G1A")
    if A9.RM[x]: r.append("RM")
    if A9.NEWP(x): r.append("NEWP")
    if A9.RCU(x): r.append("RCU!")
    if A9.DU(x): r.append("DU!")
    return "+".join(r) or "none"
out = []
for s, e, n in MINE:
    segs = []; x = s
    while x < e:
        k = rule(x); y = x
        while y < e and rule(y) == k: y += 1
        segs.append((x, y, k)); x = y
    fc = set()
    for x in range(s, e): fc.update(fn_cover(x))
    drow = sorted(set(M9.DROW.get(x, "") for x in range(s, e)) - {""})
    h9 = sum(H9P[s:e]); p4 = sum(P4[s:e]); p6 = sum(P6[s:e]); mk = sum(MK[s:e])
    seeds = sorted("%06X" % a for a in D9.FNSEED if s <= a < e)
    out.append("%06X\t%06X\t%d\th9=%d p4=%d p6=%d mk=%d\t%s\tfnindex=%s\tfnseeds_in=%s\tF1=%s" % (
        s, e, n, h9, p4, p6, mk, " ".join("%06X-%06X:%s" % g for g in segs), ",".join(fc) or "-", ",".join(seeds) or "-", ",".join(drow) or "-"))
open((REPO + "/ida/out/punr-mid/work/m3_rules.txt"), "w", encoding="utf-8").write("\n".join(out) + "\n")
print("\n".join(out))
