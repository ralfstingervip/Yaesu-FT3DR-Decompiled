from pathlib import Path as _Path
_REPO = _Path(__file__).resolve().parents[3]
# L2: reproduce K1's folded descent with and without H9 fnindex seeds; read-only on every input.
import sys, re, pickle
sys.dont_write_bytecode = True
H9 = str(_REPO) + r"/ida/out/main-descent/offline"
sys.path.insert(0, H9)
import descent as D9
from common import IMG, HI, CW, be32, flow, bu
ROOT = str(_REPO) + "/"
SCR = r"local-temp/"
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
import hashlib
P4 = open(ROOT + "ida/out/main-final4/final4_proven_mask.bin", "rb").read()[:HI]
P5 = open(ROOT + "ida/out/main-final5/final5_proven_mask.bin", "rb").read()[:HI]
FNSAVE = dict(D9.FNSEED)
rK = run_folded(COMBINED); MK = bm(rK["reached"])
D9.FNSEED.clear()
rN = run_folded(COMBINED); MN = bm(rN["reached"])
NEW = [(0x018250,"L2 er1 cb 0x018276/0x01827C"),(0x018ABE,"L2 er1 cb 0x018AD2/0x018AD8"),(0x01A094,"L2 er1 cb 0x018BE8/0x018BEE"),
       (0x05E8E0,"L4 er1 cb 0x05E862/0x05E868"),(0x066FB4,"L4 jsr from node-cmd case bodies"),(0x067250,"L4 jsr/bsr from node-cmd case bodies")]
r6 = run_folded(COMBINED + NEW); M6 = bm(r6["reached"])
D9.FNSEED.update(FNSAVE)
FO = [x for x in range(HI) if P4[x] and MK[x] and not MN[x]]
REC = [x for x in FO if M6[x]]
DROP = [x for x in FO if not M6[x]]
print("fnindex-only", len(FO), "recovered by new seeds", len(REC), "dropped", len(DROP))
print("P4 not in MK (proven but not reached by full descent):", sum(1 for x in range(HI) if P4[x] and not MK[x]))
print("M6 new beyond MN not in P4:", sum(1 for x in range(HI) if M6[x] and not MN[x] and not P4[x]))
print("gap bytes in MK?", [ (hex(a), MK[a], P4[a]) for a in (0x006A0C,0x006A0D,0x0077F8,0x0077F9)])
P6 = bytearray(P5)
for x in DROP: P6[x] = 0
print("P6 popcount", sum(P6), "removed from P5", sum(P5)-sum(P6))
def runs(xs):
    out=[];xs=sorted(xs)
    for x in xs:
        if out and out[-1][1]==x: out[-1][1]=x+1
        else: out.append([x,x+1])
    return out
open("drop_runs.tsv","w").write("".join("%06X\t%06X\t%d\n"%(s,e,e-s) for s,e in runs(DROP)))
open("rec_runs.tsv","w").write("".join("%06X\t%06X\t%d\n"%(s,e,e-s) for s,e in runs(REC)))
open("final6_proven_mask.bin","wb").write(bytes(P6)+open(ROOT + "ida/out/main-final5/final5_proven_mask.bin","rb").read()[HI:])
