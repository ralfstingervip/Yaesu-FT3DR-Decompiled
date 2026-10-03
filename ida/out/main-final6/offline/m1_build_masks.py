# -*- coding: utf-8 -*-
r"""Lane M1 - build the MAIN_FINAL6 proven/named masks in ONE run: offline descent + the FINAL6 DB typing.

Owner-side static analysis. Read-only on every input; writes only ida\out\main-final6\*.
No image byte is modified; nothing is connected to a radio.

Chain, all recomputed here (each step asserted against the file that was published for it):
  H9 proven (analyze rules)  --K1 folded descent (K1a+K1b, fnindex seeds)-->  FINAL4 proven   == final4_proven_mask.bin
  FINAL4 - 0x054AE2..0x054BF7 + doc-95 window ranges                     -->  FINAL5 proven   == final5_proven_mask.bin
  FINAL5 - (FINAL4-proven bytes reached by the fnindex-seeded descent but NOT by the descent run WITHOUT fnindex
           seeds plus the 8 L-wave entry points)                         -->  FINAL6 proven
  FINAL4 named + window ranges == final5_named_mask.bin;  FINAL5 named + L5 Confirmed rows  -->  FINAL6 named
DB side (ida\out\main-final6\MAIN_FINAL6_typemask.bin, written by ida\jobs\m1_apply_main_final6.py on the seed):
  every FINAL6 proven byte is DB code; every DATA-MISTYPED byte is DB data and unproven; every L5 Confirmed byte is
  typed (code or data) in the DB; the 0x006A0C/0x0077F8 heads are 6-byte instructions.
The 0x006A0C/0x0077F8 bytes are credited to proven only if the descent reaches them.
"""
import sys
from pathlib import Path as _Path
_REPO = _Path(__file__).resolve().parents[4]
import sys, os, re, hashlib, collections
sys.dont_write_bytecode = True
H9 = str(_REPO) + r"/ida/out/main-descent/offline"
sys.path.insert(0, H9)
import descent as D9
import analyze as A9
from common import IMG, HI, CW, be32, bu

ROOT = str(_REPO) + "/"
OUT = ROOT + "ida/out/main-final6/"
REC = ROOT + "ida/out/l-wave-recon/"
LOG = []
def say(*a):
    s = " ".join(str(x) for x in a); print(s); LOG.append(s)
INW = lambda x: CW[0] <= x < CW[1]
def be16(a): return int.from_bytes(IMG[a:a + 2], "big")
def sha(b): return hashlib.sha256(bytes(b)).hexdigest()
def rd(p): return open(p, "rb").read()
def runs(f, lo=0, hi=HI):
    out = []; x = lo
    while x < hi:
        if f(x):
            s = x
            while x < hi and f(x): x += 1
            out.append((s, x))
        else: x += 1
    return out
def bm(reached):
    m = bytearray(HI)
    for a, (n, t, k) in reached.items():
        for x in range(a, min(HI, a + n)):
            if not INW(x): m[x] = 1
    return m

FULL = 1048576
sys.exit('The firmware image is not in this repository.')
assert img_sha.startswith("8e3ecd05409b2c31"); say("MAIN image sha256", img_sha[:16])
sys.exit('The firmware image is not in this repository.')

# ------------------------------------------------------------------ H9 proven (as K1)
PROV = bytearray(HI)
for x in range(HI):
    if (A9.PU[x] and not A9.RCU(x) and not A9.DU(x)) or A9.NEWP(x): PROV[x] = 1
assert sum(PROV) == 365570
RB = bm(D9.run("full")["reached"]); assert sum(RB) == 363758
say("H9 proven", sum(PROV), "; H9 base descent", sum(RB))

# ------------------------------------------------------------------ K1 seeds and rules (verbatim from k1_build_masks.py)
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
I12_BLOCKS = [(0x054D22, 0x054D4C), (0x054F3A, 0x054F88)]
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

# ------------------------------------------------------------------ FINAL4 / FINAL5 reproduced
rK = run_folded(COMBINED); MK = bm(rK["reached"])
P4 = bytearray(PROV)
for x in range(HI):
    if MK[x] and not RB[x]: P4[x] = 1
for s, e in I12_BLOCKS:
    for x in range(s, e): P4[x] = 0
F4P = rd(ROOT + "ida/out/main-final4/final4_proven_mask.bin"); F4N = rd(ROOT + "ida/out/main-final4/final4_named_mask.bin")
assert bytes(P4) == F4P[:HI] and sum(F4P[HI:]) == 0
say("FINAL4 proven reproduced:", sum(P4), "== final4_proven_mask.bin (sha %s)" % sha(F4P)[:16])
DEMOTE5 = (0x054AE2, 0x054BF8)
WIN = [(0x07810C, 0x07815B), (0x0781A4, 0x0781A9), (0x0781C4, 0x078221), (0x07823C, 0x07825F), (0x078268, 0x078279),
       (0x07827C, 0x078333), (0x07833C, 0x07837B), (0x078384, 0x0783D9), (0x0783EE, 0x07842D), (0x078440, 0x078441),
       (0x078448, 0x078459), (0x078462, 0x078507), (0x078514, 0x078545)]
P5 = bytearray(P4); N5 = bytearray(F4N[:HI])
for x in range(*DEMOTE5): P5[x] = 0
for lo, hi in WIN:
    for x in range(lo, hi + 1): P5[x] = 1; N5[x] = 1
F5P = rd(ROOT + "ida/out/main-final5/final5_proven_mask.bin"); F5N = rd(ROOT + "ida/out/main-final5/final5_named_mask.bin")
assert bytes(P5) == F5P[:HI] and bytes(N5) == F5N[:HI] and sum(F5P[HI:]) == 0 and sum(F5N[HI:]) == 0
say("FINAL5 reproduced: proven %d, named %d (== final5 files, sha %s / %s)" % (sum(P5), sum(N5), sha(F5P)[:16], sha(F5N)[:16]))

# ------------------------------------------------------------------ FINAL6 proven: ONE descent without fnindex seeds + 8 entries
NEW8 = [(0x018250, "L2 er1 cb 0x018276/0x01827C"), (0x018ABE, "L2 er1 cb 0x018AD2/0x018AD8"), (0x01A094, "L2 er1 cb 0x018BE8/0x018BEE"),
        (0x05E8E0, "L4 er1 cb 0x05E862/0x05E868"), (0x066FB4, "L4 jsr from node-cmd case bodies"), (0x067250, "L4 jsr/bsr from node-cmd case bodies"),
        (0x066FBE, "abs24 jsr 0x06AB36/0x06AE10 (5e 06 6f be) from FINAL4-proven code"), (0x06726A, "abs24 jsr 0x06AB2A/0x06AE04 (5e 06 72 6a) + bsr 0x067246")]
for a, l in NEW8:
    assert bu(a)[0] > 0, hex(a)
FNSAVE = dict(D9.FNSEED)
D9.FNSEED.clear()
r8 = run_folded(COMBINED + NEW8); M8 = bm(r8["reached"])
rN = run_folded(COMBINED); MN = bm(rN["reached"])            # attribution only: without the 8 entries
D9.FNSEED.update(FNSAVE)
assert all(M8[x] >= MN[x] for x in range(HI))
FO = [x for x in range(HI) if P4[x] and MK[x] and not MN[x]]     # fnindex-only FINAL4-proven bytes
REACH8 = [x for x in FO if M8[x]]
DROP = [x for x in FO if not M8[x]]
P6 = bytearray(P5)
for x in DROP: P6[x] = 0
say("fnindex-only FINAL4-proven bytes %d: re-reached by the 8 entries %d, dropped %d; dropped and still in FINAL5 %d" % (
    len(FO), len(REACH8), len(DROP), sum(P5[x] for x in DROP)))
say("FINAL6 proven", sum(P6), "(FINAL5 %d - %d)" % (sum(P5), sum(P5) - sum(P6)))

# 4 B stale-head gap: credit only if the descent reaches it
GAP = [(0x006A0C, 0x006A0E, 0x006A08), (0x0077F8, 0x0077FA, 0x0077F6)]
gap_credit = 0
for s, e, pred in GAP:
    rch = [(x, M8[x], MK[x], P5[x]) for x in range(s, e)]
    say("gap %06X-%06X: descent-reached(final6 run) %s, (fnindex run) %s, FINAL5 proven %s; predecessor %06X in descent %d / %d, in FINAL4 proven %d" % (
        s, e, [M8[x] for x in range(s, e)], [MK[x] for x in range(s, e)], [P5[x] for x in range(s, e)], pred, M8[pred], MK[pred], P4[pred]))
    for x in range(s, e):
        if M8[x] and not P6[x]: P6[x] = 1; gap_credit += 1
say("gap bytes credited:", gap_credit)

# ------------------------------------------------------------------ FINAL6 named
rows = []
L = open(ROOT + "ida/out/main-unnamed/proposed-typing.tsv", encoding="utf-8").read().splitlines()
hdr = L[0].split("\t")
for l in L[1:]:
    p = dict(zip(hdr, l.split("\t")))
    if p["typing_conf"] == "Confirmed": rows.append((int(p["start"], 16), int(p["end_excl"], 16), p))
RES = rd(ROOT + "ida/out/main-unnamed/residue_mask.bin")
N6 = bytearray(N5); add = 0
for s, e, p in rows:
    for x in range(s, e):
        assert RES[x] and not N5[x]
        N6[x] = 1; add += 1
say("FINAL6 named", sum(N6), "(FINAL5 %d + %d L5 Confirmed, %d rows)" % (sum(N5), add, len(rows)))
assert all(N6[x] >= P6[x] for x in range(HI)), "proven must be a subset of named"

# ------------------------------------------------------------------ DB typing checks (FINAL6 seed)
TM = rd(OUT + "MAIN_FINAL6_typemask.bin"); assert len(TM) == HI
pnc = [x for x in range(HI) if P6[x] and TM[x] != 1]
say("DB: FINAL6 proven bytes not DB code:", len(pnc), ["%06X" % x for x in pnc[:10]])
DM = []
for lane in ("lo", "mid", "hi"):
    for l in open(ROOT + "ida/out/fnindex-%s/proposed-demotions.tsv" % lane, encoding="utf-8"):
        c = l.rstrip("\n").split("\t")
        if len(c) > 3 and c[3] == "DATA-MISTYPED": DM.append((int(c[0], 16), int(c[1], 16)))
dmb = [x for s, e in DM for x in range(s, e)]
say("DB: DATA-MISTYPED bytes %d: DB data %d, still proven %d, named %d" % (
    len(dmb), sum(1 for x in dmb if TM[x] == 2), sum(P6[x] for x in dmb), sum(N6[x] for x in dmb)))
l5b = [x for s, e, p in rows for x in range(s, e)]
say("DB: L5 Confirmed bytes %d: typed %d (code %d, data %d), untyped %d" % (
    len(l5b), sum(1 for x in l5b if TM[x]), sum(1 for x in l5b if TM[x] == 1), sum(1 for x in l5b if TM[x] == 2),
    sum(1 for x in l5b if not TM[x])))
say("DB: named bytes untyped in the DB (whole content): FINAL5 %d, FINAL6 %d" % (
    sum(1 for x in range(HI) if N5[x] and not TM[x]), sum(1 for x in range(HI) if N6[x] and not TM[x])))
HEADS = {}
for l in open(OUT + "MAIN_FINAL6_heads.tsv", encoding="utf-8").read().splitlines()[1:]:
    a, n, k = l.split("\t"); HEADS[int(a, 16)] = (int(n), k)
for s, e, pred in GAP:
    say("DB: %06X head %s; %06X head %s; %06X head %s" % (s, HEADS.get(s), s + 2, HEADS.get(s + 2), s + 4, HEADS.get(s + 4)))
assert not pnc and all(TM[x] == 2 for x in dmb) and all(TM[x] for x in l5b)

# ------------------------------------------------------------------ compare with the published L-wave masks
PUBP = rd(REC + "final6_proven_mask.bin"); PUBN = rd(REC + "final6_named_mask.bin")
out_p = bytes(P6) + bytes(FULL - HI); out_n = bytes(N6) + bytes(FULL - HI)
for nm, mine, pub in (("proven", out_p, PUBP), ("named", out_n, PUBN)):
    d = runs(lambda x: mine[x] != pub[x], 0, FULL)
    say("%s: mine %d sha %s | published %d sha %s | equal %s | differing runs %d %s" % (
        nm, sum(mine), sha(mine)[:16], sum(pub), sha(pub)[:16], mine == pub, len(d),
        ["%06X-%06X mine=%d" % (s, e, mine[s]) for s, e in d[:20]]))

# ------------------------------------------------------------------ outputs
open(OUT + "final6_proven_mask.bin", "wb").write(out_p)
open(OUT + "final6_named_mask.bin", "wb").write(out_n)
with open(OUT + "final5-to-final6-diff.tsv", "w", encoding="utf-8", newline="\n") as f:
    f.write("mask\tdirection\tstart\tend_excl\tlen\treason\n")
    for s, e in runs(lambda x: P5[x] and not P6[x]):
        f.write("proven\tremoved\t%06X\t%06X\t%d\tfnindex-only, not reached without fnindex seeds + 8 entries\n" % (s, e, e - s))
    for s, e in runs(lambda x: P6[x] and not P5[x]):
        f.write("proven\tadded\t%06X\t%06X\t%d\tdescent-reached\n" % (s, e, e - s))
    for s, e in runs(lambda x: N6[x] and not N5[x]):
        f.write("named\tadded\t%06X\t%06X\t%d\tL5 Confirmed typing\n" % (s, e, e - s))
with open(OUT + "reached-by-entries.tsv", "w", encoding="utf-8", newline="\n") as f:
    f.write("start\tend_excl\tlen\n")
    R8 = set(REACH8)
    for s, e in runs(lambda x: x in R8): f.write("%06X\t%06X\t%d\n" % (s, e, e - s))
with open(OUT + "ledger.tsv", "w", encoding="utf-8", newline="\n") as f:
    f.write("term\tdelta\tvalue\tnote\n")
    for r in (("MAIN proven FINAL4 (reproduced)", "", sum(P4), "== final4_proven_mask.bin"),
              ("MAIN proven FINAL5 (reproduced)", "", sum(P5), "== final5_proven_mask.bin"),
              ("fnindex-only FINAL4-proven bytes", "", len(FO), "reached with H9 fnindex seeds, not without"),
              ("  re-reached by the 8 entry points", "", len(REACH8), "reached-by-entries.tsv"),
              ("  dropped (still in FINAL5)", "-%d" % (sum(P5) - sum(P6) + gap_credit), "", "final5-to-final6-diff.tsv"),
              ("stale-head gap 0x006A0C/0x0077F8 credited", "+%d" % gap_credit, "", "only if descent-reached"),
              ("MAIN proven FINAL6", "", sum(P6), "%.2f%% of 505,684; %.2f%% of 389,260 decodable" % (100 * sum(P6) / 505684, 100 * sum(P6) / 389260)),
              ("MAIN named FINAL5 (reproduced)", "", sum(N5), "== final5_named_mask.bin"),
              ("L5 Confirmed typing", "+%d" % add, "", "522 rows"),
              ("MAIN named FINAL6", "", sum(N6), "%.2f%% of 505,684" % (100 * sum(N6) / 505684)),
              ("headline", "", sum(N6) + 464263, "%.4f%% of 1,029,972" % (100 * (sum(N6) + 464263) / 1029972))):
        f.write("\t".join(str(c) for c in r) + "\n")
with open(OUT + "masks-sha256.txt", "w", encoding="utf-8", newline="\n") as f:
    f.write("final6_proven_mask.bin\t%d\t%s\n" % (sum(out_p), sha(out_p)))
    f.write("final6_named_mask.bin\t%d\t%s\n" % (sum(out_n), sha(out_n)))
open(OUT + "build_log.txt", "w", encoding="utf-8", newline="\n").write("\n".join(LOG) + "\n")
