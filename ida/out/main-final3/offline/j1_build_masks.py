from pathlib import Path as _Path
_REPO = _Path(__file__).resolve().parents[4]
# Lane J1: build the MAIN_FINAL3 proven/named masks and verify 368,366 from ONE descent + the I12 demotion.
# Read-only on every input. Imports H9's descent.py / analyze.py unchanged (never as __main__).
# Writes only ida\out\main-final3\*.  No image byte is modified; nothing is connected to a radio.
import sys, os, collections, hashlib
sys.dont_write_bytecode = True
H9 = str(_REPO) + r"/ida/out/main-descent/offline"
sys.path.insert(0, H9)
import descent as D9
import analyze as A9
from common import IMG, HI, CW, be32, flow, bu, BU

ROOT = str(_REPO) + "/"
OUT = ROOT + "ida/out/main-final3/"
F2 = ROOT + "ida/out/main-final2/"
LOG = []
def say(*a):
    s = " ".join(str(x) for x in a); print(s); LOG.append(s)
INW = lambda x: CW[0] <= x < CW[1]
def be16(a): return int.from_bytes(IMG[a:a+2], "big")

say("image sha256", hashlib.sha256(IMG).hexdigest()[:16], "len", len(IMG))

# ---------------------------------------------------------------- H9 proven/named masks (same as I14/I15)
PROV = bytearray(HI); NAMD = bytearray(HI); LEAVE = bytearray(HI)
for s, e, ad, c, h in A9.demoted:
    for x in range(s, e):
        if A9.NAMED[x] and (A9.B[x] if ad == "RC" else True):
            other = (A9.A[x] or A9.E[x] or A9.F[x] or A9.HH[x] or (ad == "D" and A9.B[x]))
            if A9.leaves(s, e, ad, c) and not other: LEAVE[x] = 1
for x in range(HI):
    if (A9.PU[x] and not A9.RCU(x) and not A9.DU(x)) or A9.NEWP(x): PROV[x] = 1
    if (A9.NAMED[x] and not LEAVE[x]) or (A9.RM[x] and not A9.NAMED[x]): NAMD[x] = 1
assert sum(PROV) == 365570, sum(PROV)
assert sum(NAMD) == 497139, sum(NAMD)
assert bytes(PROV) == open(ROOT + "ida/out/main-final/h9_proven_mask.bin", "rb").read()[:HI]
say("H9 proven", sum(PROV), "named", sum(NAMD), "(== h9_proven_mask.bin)")

def bm(reached):
    m = bytearray(HI)
    for a, (n, t, k) in reached.items():
        for x in range(a, min(HI, a + n)):
            if not INW(x): m[x] = 1
    return m
def spans(f, lo=0, hi=HI):
    out = []; x = lo
    while x < hi:
        if f(x):
            s = x
            while x < hi and f(x): x += 1
            out.append((s, x))
        else: x += 1
    return out

# ---------------------------------------------------------------- baseline H9 descent (byte-equal)
base = D9.run("full"); RB = bm(base["reached"])
assert sum(RB) == 363758, sum(RB)
say("H9 full descent reproduced: reached bytes", sum(RB), "insns", len(base["reached"]))

# ---------------------------------------------------------------- lane seed edges (the folded rules)
# I6 exit-table 0x19A9E (206 BE16 rel to 0x148A0)
assert IMG[0x1919A:0x1919A+16].hex() == "78606b2600019a9e7a16000148a05d60"
EXIT_ENTS = sorted(set(0x148A0 + be16(0x19A9E + 2*i) for i in range(206)))
EX6 = [(a, "I6 exit-table 0x19A9E entry") for a in EXIT_ENTS]
# I8 helper-store / exit-table-slot (0x034CCE) + tier-X 0x003272 load-site rule + 3 immediates (0 B)
assert be32(0x03467C) == 0x034CCE
assert [be32(0x3272 + 4*i) for i in range(3)] == [0x327E, 0x328A, 0x329C]
I8X = [(0x034CCE, "I8 slot 0x03467C via jsr @er6 0x03464A"),
       (0x00327E, "I8 tier-X 0x003272 slot 0"), (0x00328A, "I8 tier-X slot 1"), (0x00329C, "I8 tier-X slot 2"),
       (0x077DB8, "I8 imm"), (0x077FC6, "I8 imm"), (0x078086, "I8 imm")]
# I9 three edges: record fields of 0x0296E8/0x029712 dispatched by 0x028CBC, RAM-hook helper 0x000706, er1 callback 0x01A084
I9X = []
for rec in (0x0296E8, 0x029712):
    for off in (0x00, 0x04, 0x08, 0x0C, 0x14, 0x18):
        v = be32(rec + off)
        if v and v < HI and v % 2 == 0: I9X.append((v, "I9 record %06X+%02X via 0x028CBC" % (rec, off)))
I9X.append((0x000706, "I9 ram-cell FF811A via helper 0x00042C"))
I9X.append((0x01A084, "I9 er1 callback via jsr @er1 0x015224"))
# I15 record-field callback rule: all strict-gated Rule A + Rule B edges from new-edges.tsv
I15X = []
for ln in open(ROOT + "ida/out/descent-ext/new-edges.tsv", encoding="utf-8").read().splitlines():
    if ln.startswith("#") or ln.startswith("rule"): continue
    c = ln.split("\t")
    if c[2] != "True": continue
    v = int(c[1], 16)
    if v and v < HI and v % 2 == 0: I15X.append((v, "I15 " + c[4]))

# ---------------------------------------------------------------- per-lane masks (beyond H9 reach), for overlap table
def newly(extra):
    r = D9.run("full", extra_seeds=extra); m = bm(r["reached"])
    return r, bytearray(1 if (m[x] and not RB[x]) else 0 for x in range(HI))
_, M6  = newly(EX6)
_, M8c = newly([I8X[0]])
_, M8x = newly(I8X[1:4])
_, M9  = newly(I9X)
# I15: the 4 record-field handler runs beyond H9UI6UI8UI9 (the +54). Build from new-bytes.tsv beyond_all rows.
M15 = bytearray(HI); I15RUNS = []
for ln in open(ROOT + "ida/out/descent-ext/new-bytes.tsv", encoding="utf-8").read().splitlines():
    if ln.startswith("#") or ln.startswith("addr"): continue
    c = ln.split("\t")
    if c[7] != "1": continue           # beyond_all
    s = int(c[0], 16); n = int(c[1]); I15RUNS.append((s, n, c[2]))
    assert IMG[s:s+n].hex().startswith(c[8][:2*n]) or c[8].startswith(IMG[s:s+min(n,7)].hex())
    for x in range(s, s + n): M15[x] = 1
say("per-lane beyond-H9-reach: I6 %d  I8c %d  I8x %d  I9 %d  I15 %d" % (sum(M6), sum(M8c), sum(M8x), sum(M9), sum(M15)))
assert sum(M6) == 1544 and sum(M8c) == 116 and sum(M8x) == 66 and sum(M9) == 1136 and sum(M15) == 54

# ---------------------------------------------------------------- I12 demotion mask (120 B)
M12 = bytearray(HI)
I12_BLOCKS = [(0x054D22, 0x054D4C), (0x054F3A, 0x054F88)]
for s, e in I12_BLOCKS:
    for x in range(s, e): M12[x] = 1
assert sum(M12) == 120
# every block byte is currently proven, and disjoint from every addend
assert all(PROV[x] for s, e in I12_BLOCKS for x in range(s, e)), "I12 block not all in H9 proven"
for nm, m in [("I6", M6), ("I8c", M8c), ("I8x", M8x), ("I9", M9), ("I15", M15)]:
    assert sum(1 for x in range(HI) if M12[x] and m[x]) == 0, "I12 overlaps " + nm

# ---------------------------------------------------------------- overlaps: all addend pairs = 0, I15 vs others = 0
SETS = collections.OrderedDict([("I6", M6), ("I8c", M8c), ("I8x", M8x), ("I9", M9), ("I15", M15)])
for k, m in SETS.items():
    ovp = sum(1 for x in range(HI) if m[x] and PROV[x])
    win = sum(1 for x in range(*CW) if m[x])
    say("%-4s bytes %5d  overlap H9-proven %d  in-window %d" % (k, sum(m), ovp, win))
    assert ovp == 0 and win == 0
pairs = []
for i, a in enumerate(SETS):
    for b in list(SETS)[i+1:]:
        n = sum(1 for x in range(HI) if SETS[a][x] and SETS[b][x]); pairs.append((a, b, n))
assert all(n == 0 for _, _, n in pairs), "nonzero pairwise intersection"
say("all %d pairwise addend intersections = 0" % len(pairs))

# ---------------------------------------------------------------- ONE descent run folding every rule
COMBINED = EX6 + I8X + I9X + I15X
rC = D9.run("full", extra_seeds=COMBINED); MCr = bm(rC["reached"])
MC = bytearray(1 if (MCr[x] and not RB[x]) else 0 for x in range(HI))   # bytes newly reached by the single descent
UNION_ADDEND = bytearray(1 if (M6[x] or M8c[x] or M8x[x] or M9[x] or M15[x]) else 0 for x in range(HI))
beyond = sum(1 for x in range(HI) if MC[x] and not UNION_ADDEND[x])
missing = sum(1 for x in range(HI) if UNION_ADDEND[x] and not MC[x])
say("ONE descent (folded rules): newly reached %d B | beyond addend-union %d | addend-union not reached %d" %
    (sum(MC), beyond, missing))
for s, e in spans(lambda x: MC[x] and not UNION_ADDEND[x]): say("   beyond %06X-%06X %d" % (s, e, e-s))
for s, e in spans(lambda x: UNION_ADDEND[x] and not MC[x]): say("   not-reached %06X-%06X %d" % (s, e, e-s))
assert beyond == 0 and missing == 0, "single descent != addend union"
# the single descent must NOT reach either I12 block
assert sum(1 for x in range(HI) if MCr[x] and M12[x]) == 0, "descent reaches an I12 block"
say("single descent reaches 0 bytes of either I12 block (unreachable confirmed by descent)")

# ---------------------------------------------------------------- the FINAL3 proven mask
PROV3 = bytearray(PROV)
for x in range(HI):
    if MC[x]: PROV3[x] = 1       # == adding the addend union (I6+I8+I9+I15)
for s, e in I12_BLOCKS:
    for x in range(s, e): PROV3[x] = 0
say("")
say("MAIN proven, FINAL3 =", sum(PROV3))
assert sum(PROV3) == 368366, sum(PROV3)
# cross-check against final2 mask arithmetic
F2M = open(F2 + "final2_proven_mask.bin", "rb").read()
assert sum(1 for b in F2M if b) == 368432
check = bytearray(F2M[:HI])
for x in range(HI):
    if M15[x]: check[x] = 1
for s, e in I12_BLOCKS:
    for x in range(s, e): check[x] = 0
assert bytes(check) == bytes(PROV3), "FINAL3 != final2 + I15 - I12"
say("cross-check: FINAL3 == final2_proven_mask + I15(54) - I12(120)  OK")

# ---------------------------------------------------------------- named mask: H9 named + joins-named(I6,I8,I9,I15); I12 stays typed
NAMD3 = bytearray(NAMD)
# I8's +2 (0x034CD5, 0x034D03) that H9 demoted as RC junk but are reached (per I14 correction)
for x in (0x034CD5, 0x034D03): NAMD3[x] = 1
for m in (M6, M8c, M8x, M9, M15):
    for x in range(HI):
        if m[x]: NAMD3[x] = 1
say("MAIN named/typed, FINAL3 =", sum(NAMD3))

# ---------------------------------------------------------------- whole-image unreachability scan for both I12 blocks
def scan_reach(lo, hi):
    hits = []
    # BE32 pointer anywhere (aligned to any even byte) that lands in [lo,hi)
    for a in range(0, HI - 3):
        v = be32(a)
        if lo <= v < hi: hits.append(("be32@%06X=%06X" % (a, v)))
    # jsr/jmp abs24 and bcc/bsr 8/16 that target [lo,hi): walk oracle decode of every even addr
    for a in range(0, HI, 2):
        if INW(a): continue
        n, t, k, tg = flow(a)
        if n == 0: continue
        for x in tg:
            if lo <= x < hi: hits.append("flow@%06X->%06X [%s]" % (a, x, t))
    return hits
for s, e in I12_BLOCKS:
    h = scan_reach(s, e)
    say("I12 block %06X-%06X: inbound refs found = %d %s" % (s, e, len(h), h[:12]))

# ---------------------------------------------------------------- 0xFFA9E0 writer search (tier-X slot 0)
say("")
say("=== writers of 0xFFA9E0 (tier-X slot 0) ===")
cellhits = []
for a in sorted(BU):
    if a >= HI or INW(a): continue
    n, t = bu(a)
    if n and ("0xa9e0" in t or "0xffa9e0" in t):
        # classify read vs write
        kind = "write" if (",@0xa9e0" in t.replace("0xffa9e0","0xa9e0") or t.strip().endswith("@0xa9e0:16") and t.split()[0].startswith("mov") and ",@" in t) else "?"
        cellhits.append((a, t))
for a, t in cellhits: say("  %06X  %s" % (a, t))
# boot clear loop coverage
say("boot clear 0x002132-0x002150 region bytes: %s" % IMG[0x002132:0x002152].hex(" "))

# ---------------------------------------------------------------- write outputs
os.makedirs(OUT + "offline", exist_ok=True)
open(OUT + "final3_proven_mask.bin", "wb").write(bytes(PROV3) + bytes(len(IMG) - HI))
open(OUT + "final3_named_mask.bin", "wb").write(bytes(NAMD3) + bytes(len(IMG) - HI))
# proven mask runs for inspection
def w(name, hdr, rows):
    with open(OUT + name, "w", encoding="utf-8", newline="\n") as f:
        f.write(hdr + "\n")
        for r in rows: f.write("\t".join(str(c) for c in r) + "\n")
# overlaps table (all pairs + I15 vs H9/I12)
orow = []
for a, b, n in pairs: orow.append((a, b, n))
orow.append(("I15", "H9proven", sum(1 for x in range(HI) if M15[x] and PROV[x])))
orow.append(("I12", "H9proven", sum(1 for x in range(HI) if M12[x] and PROV[x])))
for nm, m in SETS.items(): orow.append(("I12", nm, sum(1 for x in range(HI) if M12[x] and m[x])))
w("overlaps.tsv", "set_a\tset_b\tbytes", orow)
# rule-by-rule ledger
LED = [
    ("MAIN proven code, H9 (== h9_proven_mask.bin)", "", 365570, "one-descent baseline"),
    ("I6 exit-table 0x019A9E (exit-table rule)", "+1544", "", "0 overlap"),
    ("I8 0x034CCE (helper-store/exit-slot rule)", "+116", "", "0 overlap"),
    ("I8 tier-X 0x003272 (tier-X load-site rule)", "+66", "", "0 overlap"),
    ("I9 three edges (records/vec-88 hook/er1 cb)", "+1136", "", "0 overlap"),
    ("I15 record-field callback rule (028C2A/028C8A +14/+1C)", "+54", "", "0 overlap"),
    ("subtotal: one-descent union", "+2916", 368486, "365570+1544+116+66+1136+54"),
    ("I12 demotion: unreachable USB-ISR blocks 054D22-4B, 054F3A-87", "-120", "", "re-confirmed unreachable"),
    ("MAIN proven code, FINAL3", "", sum(PROV3), "368486-120"),
    ("MAIN named/typed, H9", "", 497139, ""),
    ("joins named: I6+I8+I9 (I14 +141) + I15 (+34)", "+175", "", ""),
    ("MAIN named/typed, FINAL3", "", sum(NAMD3), "I12 bytes remain typed code"),
]
w("ledger.tsv", "term\tdelta\tvalue\tnote", LED)
# proven mask run list
w("final3_proven_runs.tsv", "start\tend_excl\tlen",
  [("%06X" % s, "%06X" % e, e - s) for s, e in spans(lambda x: PROV3[x])])
open(OUT + "build_log.txt", "w", encoding="utf-8", newline="\n").write("\n".join(LOG) + "\n")
say("")
say("wrote final3_proven_mask.bin (%d set), final3_named_mask.bin (%d set), overlaps.tsv, ledger.tsv, final3_proven_runs.tsv" %
    (sum(PROV3), sum(NAMD3)))
