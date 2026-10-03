# L2: reproduce K1's folded descent with and without H9 fnindex seeds; read-only on every input.
from pathlib import Path as _Path
_REPO_S = _Path(__file__).resolve().parents[4].as_posix()
import sys, re, pickle
sys.dont_write_bytecode = True
H9 = (_REPO_S + "/ida/out/main-descent/offline")
sys.path.insert(0, H9)
import descent as D9
from common import IMG, HI, CW, be32, flow, bu
ROOT = (_REPO_S + "/")
SCR = r"local-temp"
INW = lambda x: CW[0] <= x < CW[1]
def be16(a): return int.from_bytes(IMG[a:a + 2], "big")

# J1 folded seeds verbatim from k1_build_masks.py
EX6 = [(a, "I6 exit-table 0x19A9E entry") for a in sorted(set(0x148A0 + be16(0x19A9E + 2 * i) for i in range(206)))]
I8X = [(0x034CCE, "I8"), (0x00327E, "I8"), (0x00328A, "I8"), (0x00329C, "I8"), (0x077DB8, "I8"), (0x077FC6, "I8"), (0x078086, "I8")]
I9X = []
for rec in (0x0296E8, 0x029712):
    for off in (0x00, 0x04, 0x08, 0x0C, 0x14, 0x18):
        v = be32(rec + off)
        if v and v < HI and v % 2 == 0: I9X.append((v, "I9 record %06X+%02X" % (rec, off)))
I9X += [(0x000706, "I9 ram-cell FF811A"), (0x01A084, "I9 er1 callback")]
I15X = []
for ln in open(ROOT + "ida/out/descent-ext/new-edges.tsv", encoding="utf-8").read().splitlines():
    if ln.startswith("#") or ln.startswith("rule"): continue
    c = ln.split("\t")
    if c[2] != "True": continue
    v = int(c[1], 16)
    if v and v < HI and v % 2 == 0: I15X.append((v, "I15 " + c[4]))
COMBINED = EX6 + I8X + I9X + I15X

EXCL2 = set()
for ln in open(ROOT + "ida/out/h8sx-seed/table-xrefs-excluded.tsv", encoding="utf-8").read().splitlines()[1:]:
    if ln.startswith("#") or not ln.strip(): continue
    c = ln.split("\t")
    if not c[5].startswith("target is mid_code in seed"): EXCL2.add(int(c[0], 16))
TAB_NEW = {}
for fn in ["jumptables.tsv", "switch_tables.tsv"]:
    for ln in open(ROOT + "ida/out/main-full/" + fn, encoding="utf-8").read().splitlines()[1:]:
        c = ln.split("\t"); b = int(c[0], 16); n = int(c[1])
        d = TAB_NEW.setdefault(b, {})
        for i in range(n):
            s = b + 4 * i; v = be32(s)
            if s in EXCL2: continue
            if v < HI and v % 2 == 0 and v != 0x3FFA0 and v != 0: d[s] = v
for _b in D9.H9_EXCL_TABLES: TAB_NEW[_b] = {}

HELPER_SIG_A = bytes.fromhex("6b04bbc27924"); HELPER_SIG_B = bytes.fromhex("44141b544b10790c000010740ac6010069665d604004")
HELPERS = {}
for a in range(0x400, HI, 2):
    if IMG[a:a + 6] == HELPER_SIG_A and IMG[a + 8:a + 30] == HELPER_SIG_B and IMG[a + 30:a + 36] == bytes.fromhex("5e03ffa05470"):
        HELPERS[a] = be16(a + 6)
JMPABS = re.compile(r"^(jmp|jsr) @(0x[0-9a-f]+):24$")
def k1b_edges(reached):
    new = {}
    for a, (n, t, k) in reached.items():
        m1 = D9.MOVI.match(t); m2 = D9.LD.match(t)
        if m1 and m1.group(2) == "6": form = "imm"; T = int(m1.group(1), 16)
        elif m2 and m2.group(4) == "6" and m2.group(3) == "4" and m2.group(2) == "32": form = "L1"; T = int(m2.group(1), 16)
        else: continue
        for x, tt in D9.window(reached, a, 4):
            mj = JMPABS.match(tt)
            if mj and int(mj.group(2), 16) in HELPERS:
                h = int(mj.group(2), 16); N = HELPERS[h]
                if h not in reached: break
                tabs = [T] if form == "imm" else []
                if form == "L1":
                    lo = 1 << 30; i = 0
                    while T + 4 * i < lo:
                        v = be32(T + 4 * i)
                        if not (0x400 <= v < HI and v % 2 == 0): break
                        tabs.append(v); lo = min(lo, v); i += 1
                    tabs = sorted(set(tabs))
                for tb in tabs:
                    for j in range(N - 1):
                        v = be32(tb + 4 * j)
                        if 0x400 <= v < HI and v % 2 == 0 and not INW(v):
                            new.setdefault(v, "K1b helper %06X table %06X slot %d via %06X" % (h, tb, j, a))
                break
            if D9.writes(tt, "6"): break
    return new
def run_folded(extra):
    D9.TAB.clear(); D9.TAB.update({b: dict(d) for b, d in TAB_NEW.items()})
    seeds = dict(extra)
    while True:
        r = D9.run("full", extra_seeds=sorted(seeds.items()))
        new = {a: l for a, l in k1b_edges(r["reached"]).items() if a not in seeds and a not in r["seed"]}
        if not new: return r
        seeds.update(new)
def bm(reached):
    m = bytearray(HI)
    for a, (n, t, k) in reached.items():
        for x in range(a, min(HI, a + n)):
            if not INW(x): m[x] = 1
    return m

FNSAVE = dict(D9.FNSEED)
rK = run_folded(COMBINED); MK = bm(rK["reached"])
D9.FNSEED.clear()
rN = run_folded(COMBINED); MN = bm(rN["reached"])
D9.FNSEED.update(FNSAVE)
P4 = open(ROOT + "ida/out/main-final4/final4_proven_mask.bin", "rb").read()[:HI]
FO = bytearray(1 if (P4[x] and MK[x] and not MN[x]) else 0 for x in range(HI))
runs = []; x = 0
while x < HI:
    if FO[x]:
        s = x
        while x < HI and FO[x]: x += 1
        runs.append((s, x))
    else: x += 1
print("reachedK bytes", sum(MK), "reachedN bytes", sum(MN), "fnonly runs", len(runs), "bytes", sum(FO))
ref = [l.split("\t") for l in open(ROOT + "ida/out/main-final4/fnindex-only-runs.tsv", encoding="utf-8").read().splitlines()[2:]]
ref = [(int(c[0], 16), int(c[1], 16)) for c in ref]
print("match published list:", ref == runs)
pickle.dump(dict(rK=rK, rN=rN, MK=bytes(MK), MN=bytes(MN), runs=runs, FNSEED=FNSAVE, FN=dict(D9.FN), HELPERS=HELPERS), open(SCR + "reach.pkl", "wb"))
