from pathlib import Path as _Path
_REPO = _Path(__file__).resolve().parents[4]
# Lane I14: merge the I-wave MAIN ledger deltas (I6, I8, I9) against H9 as BYTE SETS, then emit the seed inputs.
# Owner-side static analysis. Read-only on every input (image, H9 offline code + pickles, lane TSVs).
# Writes only ida\out\main-final2\*.tsv|txt and one pickle in the I14 scratchpad.
# Run:  python -B "ida/out/main-final2/offline/i14_merge.py"
import sys, os, pickle, collections, hashlib
sys.dont_write_bytecode = True
sys.path.insert(0, str(_REPO) + r"/ida/out/main-descent/offline")
import analyze as A9                       # H9 module: module-level code builds the masks, writes nothing unless __main__
import descent as D9                       # H9 descent, used unchanged
from common import IMG, IMGP, HI, CW, BU, bu, be32, flow

ROOT = str(_REPO) + "/"
OUT = ROOT + "ida/out/main-final2/"
SCR = r"local-temp/"
LOG = []
def say(*a):
    s = " ".join(str(x) for x in a); print(s); LOG.append(s)
INW = lambda x: CW[0] <= x < CW[1]
def be16(a): return int.from_bytes(IMG[a:a + 2], "big")

say("image sha256", hashlib.sha256(IMG).hexdigest()[:16], "len", len(IMG))

# ------------------------------------------------------------------ H9 masks (same construction as I9's i9_masks.py / I3)
PROV = bytearray(HI); NAMD = bytearray(HI); LEAVE = bytearray(HI)
for s, e, ad, c, h in A9.demoted:
    for x in range(s, e):
        if A9.NAMED[x] and (A9.B[x] if ad == "RC" else True):
            other = (A9.A[x] or A9.E[x] or A9.F[x] or A9.HH[x] or (ad == "D" and A9.B[x]))
            if A9.leaves(s, e, ad, c) and not other: LEAVE[x] = 1
for x in range(HI):
    if (A9.PU[x] and not A9.RCU(x) and not A9.DU(x)) or A9.NEWP(x): PROV[x] = 1
    if (A9.NAMED[x] and not LEAVE[x]) or (A9.RM[x] and not A9.NAMED[x]): NAMD[x] = 1
say("H9 proven", sum(PROV), "named", sum(NAMD))
assert sum(PROV) == 365570 and sum(NAMD) == 497139
I3M = open(ROOT + "ida/out/main-final/h9_proven_mask.bin", "rb").read()
assert len(I3M) >= HI
same = all((I3M[x] != 0) == bool(PROV[x]) for x in range(HI))
say("H9 proven mask == I3 h9_proven_mask.bin:", same, "(I3 file %d B, %d set)" % (len(I3M), sum(1 for b in I3M if b)))
assert same
RM = A9.RM

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

base = D9.run("full"); RB = bm(base["reached"])
assert bytes(RB) == bytes(RM), "H9 full descent does not reproduce RM"
say("H9 full descent reproduced: reached bytes", sum(RB), "insns", len(base["reached"]))

# ------------------------------------------------------------------ lane I6: exit-table instructions (published TSV)
I6 = {}
for ln in open(ROOT + "ida/out/orphan-screens/exit-table-new-insns.tsv", encoding="utf-8").read().splitlines()[1:]:
    c = ln.split("\t"); a = int(c[0], 16); n = int(c[1])
    assert bytes.fromhex(c[2]) == IMG[a:a + n], "I6 bytes mismatch %06X" % a
    assert bu(a)[0] == n, "I6 oracle length mismatch %06X" % a
    I6[a] = n
M6 = bytearray(HI)
for a, n in I6.items():
    for x in range(a, a + n): M6[x] = 1
# re-run I6's own gated descent (its algorithm, from i6_gen_tables.py) to confirm the published set
REACH = {}
for l in open(ROOT + "ida/out/main-descent/work/reached_insns.tsv", encoding="utf-8"):
    p = l.rstrip("\n").split("\t")
    try: REACH[int(p[0], 16)] = int(p[1])
    except ValueError: pass
assert all(x in REACH for x in (0x19158, 0x1919A, 0x191A2, 0x191A8))
assert IMG[0x1919A:0x1919A + 16].hex() == "78606b2600019a9e7a16000148a05d60"
EXIT_ENTS = sorted(set(0x148A0 + be16(0x19A9E + 2 * i) for i in range(206)))
NEW6 = {}; todo = list(EXIT_ENTS)
while todo:
    a = todo.pop()
    while True:
        if a in NEW6 or a in REACH: break
        n, t, k, tg = flow(a); assert n > 0
        NEW6[a] = n
        for x in tg:
            if x not in REACH and x not in NEW6: todo.append(x)
        if k in ("stop", "stops"): break
        a += n
say("I6: published insns", len(I6), "bytes", sum(M6), "| re-derived", len(NEW6), "insns", sum(NEW6.values()), "B; equal:", NEW6 == I6,
    "| exit entries", len(EXIT_ENTS))
assert NEW6 == I6

# ------------------------------------------------------------------ lane I8: indirect-callback edges (H9 descent + I8's 7 extra targets)
I8X_CONF = [(0x034CCE, "I8 slot 0x03467C of table 0x034674 via jsr @er6 0x03464A")]
I8X_TIERX = [(0x00327E, "I8 tier-X array 0x003272 slot 0"), (0x00328A, "I8 tier-X slot 1"), (0x00329C, "I8 tier-X slot 2")]
I8X_IMM = [(0x077DB8, "I8 imm"), (0x077FC6, "I8 imm"), (0x078086, "I8 imm")]
for v, _ in I8X_CONF + I8X_TIERX: assert v % 2 == 0
assert be32(0x03467C) == 0x034CCE
assert IMG[0x003262:0x003272].hex() == "7a630000 00ff 1073 01006f363272 5960".replace(" ", "")
assert [be32(0x3272 + 4 * i) for i in range(3)] == [0x327E, 0x328A, 0x329C]
def newly(extra):
    r = D9.run("full", extra_seeds=extra); m = bm(r["reached"])
    return r, bytearray(1 if (m[x] and not RB[x]) else 0 for x in range(HI))
r8, M8 = newly(I8X_CONF + I8X_TIERX + I8X_IMM)
_, M8c = newly(I8X_CONF)
_, M8x = newly(I8X_TIERX)
_, M8i = newly(I8X_IMM)
say("I8: all 7 extra targets ->", sum(M8), "B | 0x34CCE alone", sum(M8c), "| tier-X alone", sum(M8x), "| 3 immediates alone", sum(M8i))
assert sum(M8) == 182 and sum(M8c) == 116 and sum(M8x) == 66 and sum(M8i) == 0
# tier-X index cell 0xFFA9E0: every oracle instruction naming it (whole decodable image outside the window)
CELL = []
for a in sorted(BU):
    if INW(a) or a >= HI: continue
    n, t = bu(a)
    if n and ("0xa9e0" in t or "0xffa9e0" in t): CELL.append((a, t))
say("I8 tier-X index cell FFA9E0 oracle refs:", "; ".join("%06X %s" % c for c in CELL))

# ------------------------------------------------------------------ lane I9: three edges (published runs + re-derivation)
M9pub = bytearray(HI); I9runs = []
for ln in open(ROOT + "ida/out/suspect-tables/new-proven-bytes.tsv", encoding="utf-8").read().splitlines()[1:]:
    c = ln.split("\t"); s = int(c[0], 16); e = int(c[1], 16)
    assert e - s == int(c[2]) and IMG[s:s + 8].hex(" ").startswith(c[5][:23])
    I9runs.append((s, e, c[3]))
    for x in range(s, e): M9pub[x] = 1
I9X = []
for rec in (0x0296E8, 0x029712):
    for off in (0x00, 0x04, 0x08, 0x0C, 0x14, 0x18):
        v = be32(rec + off)
        if v and v < HI and v % 2 == 0: I9X.append((v, "I9 record %06X+%02X via 0x028CBC" % (rec, off)))
I9X.append((0x000706, "I9 ram-cell FF811A via helper 0x00042C"))
I9X.append((0x01A084, "I9 er1 callback via jsr @er1 0x015224"))
r9, M9 = newly(I9X)
say("I9: published", sum(M9pub), "B | re-derived", sum(M9), "| equal:", M9 == M9pub)
assert M9 == M9pub and sum(M9) == 1136

# ------------------------------------------------------------------ zero overlap with H9 proven, named deltas
SETS = collections.OrderedDict([("I6", M6), ("I8c", M8c), ("I8x", M8x), ("I9", M9)])
for k, m in SETS.items():
    ovp = sum(1 for x in range(HI) if m[x] and PROV[x]); ovr = sum(1 for x in range(HI) if m[x] and RB[x])
    win = sum(1 for x in range(*CW) if m[x])
    say("%-3s bytes %5d  overlap H9-proven %d  overlap H9-reach %d  in-window %d  named-delta %d" %
        (k, sum(m), ovp, ovr, win, sum(1 for x in range(HI) if m[x] and not NAMD[x])))
    assert ovp == 0 and win == 0
pairs = []
for i, a in enumerate(SETS):
    for b in list(SETS)[i + 1:]:
        n = sum(1 for x in range(HI) if SETS[a][x] and SETS[b][x]); pairs.append((a, b, n))
        say("intersection %s & %s = %d B" % (a, b, n))
UNI = bytearray(1 if any(m[x] for m in SETS.values()) else 0 for x in range(HI))
UNIc = bytearray(1 if (M6[x] or M8c[x] or M9[x]) else 0 for x in range(HI))
say("union all four", sum(UNI), "| union without tier-X", sum(UNIc))

# ------------------------------------------------------------------ combined descent: all lanes' seeds together under H9's unchanged rules
EX6 = [(a, "I6 exit-table 0x19A9E entry") for a in EXIT_ENTS]
rC, MC = newly(EX6 + I8X_CONF + I8X_TIERX + I8X_IMM + I9X)
extra_c = sum(1 for x in range(HI) if MC[x] and not UNI[x]); miss_c = sum(1 for x in range(HI) if UNI[x] and not MC[x])
say("combined H9-rule descent with all lane seeds: newly reached", sum(MC), "| beyond union", extra_c, "| union bytes not reached", miss_c)
for s, e in spans(lambda x: MC[x] and not UNI[x]): say("   beyond-union %06X-%06X %d" % (s, e, e - s))
for s, e in spans(lambda x: UNI[x] and not MC[x]): say("   union-not-reached %06X-%06X %d" % (s, e, e - s))
# I6-only under H9's full rules
_, M6h = newly(EX6)
say("I6 seeds under H9's full rules alone:", sum(M6h), "B; == I6 set:", M6h == M6)

# ------------------------------------------------------------------ instruction list of the merged set (for the IDA job and length check)
INS = {}   # addr -> (len, text, lanes)
def lanes_of(x): return [k for k, m in SETS.items() if m[x]]
for a, (n, t, k) in rC["reached"].items():
    if INW(a): continue
    if any(UNI[x] for x in range(a, a + n)):
        assert all(UNI[x] for x in range(a, a + n)), "partial instruction %06X" % a
        INS[a] = (n, t)
covered = bytearray(HI)
for a, (n, t) in INS.items():
    for x in range(a, a + n): covered[x] = 1
assert covered == UNI, "merged instruction list does not tile the union"
# overlapping starts?
ovs = [a for a in INS for x in range(a + 1, a + INS[a][0]) if x in INS]
say("merged instructions", len(INS), "overlapping starts", len(ovs), "odd starts", sum(1 for a in INS if a & 1))
assert not ovs

# ------------------------------------------------------------------ figures
P_H9, N_H9 = 365570, 497139
dP_all = sum(UNI); dP_c = sum(UNIc)
dN_all = sum(1 for x in range(HI) if UNI[x] and not NAMD[x]); dN_c = sum(1 for x in range(HI) if UNIc[x] and not NAMD[x])
say("MERGED proven (incl tier-X)", P_H9 + dP_all, "+%d" % dP_all, "| excl tier-X", P_H9 + dP_c, "+%d" % dP_c)
say("MERGED named (incl tier-X)", N_H9 + dN_all, "+%d" % dN_all, "| excl tier-X", N_H9 + dN_c, "+%d" % dN_c)
DEN = 1029972
for sub in (464166, 464263):
    say("headline SUB %d: named %d -> %d / %d = %.4f%%" % (sub, N_H9 + dN_all, N_H9 + dN_all + sub, DEN, 100.0 * (N_H9 + dN_all + sub) / DEN))

# ------------------------------------------------------------------ tables
def w(name, hdr, rows):
    with open(OUT + name, "w", encoding="utf-8", newline="\n") as f:
        f.write(hdr + "\n")
        for r in rows: f.write("\t".join(str(c) for c in r) + "\n")
rows = []
x = 0
while x < HI:
    if UNI[x]:
        s = x; L = lanes_of(x)
        while x < HI and UNI[x] and lanes_of(x) == L: x += 1
        rows.append(("%06X" % s, "%06X" % x, x - s, "+".join(L), "yes" if all(NAMD[y] for y in range(s, x)) else
                     ("no" if not any(NAMD[y] for y in range(s, x)) else "partial:%d" % sum(1 for y in range(s, x) if not NAMD[y])),
                     IMG[s:min(x, s + 8)].hex(" ")))
    else: x += 1
w("merged-new-bytes.tsv", "start\tend_excl\tlen\tlanes\tin_H9_named\tfirst_bytes   # lanes: I6 exit table, I8c 0x34CCE (Confirmed), I8x tier-X 0x003272, I9 three edges", rows)
orow = []
for a, b, n in pairs:
    for s, e in spans(lambda x: SETS[a][x] and SETS[b][x]): orow.append((a, b, "%06X" % s, "%06X" % e, e - s))
    orow.append((a, b, "total", "", n))
w("overlaps.tsv", "lane_a\tlane_b\tstart\tend_excl\tbytes", orow)
w("merged-insns.tsv", "addr\tlen\tbytes\tlanes\ttext", [("%06X" % a, n, IMG[a:a + n].hex(" "), "+".join(lanes_of(a)), t) for a, (n, t) in sorted(INS.items())])
# edges for the seed job: (site, target, kind, lane)
EDG = []
for i in range(206):
    v = 0x148A0 + be16(0x19A9E + 2 * i); EDG.append(("%06X" % (0x19A9E + 2 * i), "%06X" % v, "slot16rel", "I6"))
for v in EXIT_ENTS: EDG.append(("0191A8", "%06X" % v, "call", "I6"))
for rec in (0x0296E8, 0x029712):
    for off in range(0, 0x20, 4):
        v = be32(rec + off)
        if v and v < HI and v % 2 == 0: EDG.append(("%06X" % (rec + off), "%06X" % v, "slot32", "I9"))
for site, off in ((0x028D12, 0x00), (0x028D46, 0x08), (0x028D50, 0x0C)):
    for rec in (0x0296E8, 0x029712):
        v = be32(rec + off)
        if v and v < HI: EDG.append(("%06X" % site, "%06X" % v, "call", "I9"))
EDG += [("0028E0", "000706", "jump", "I9"), ("000454", "000706", "imm", "I9"), ("015224", "01A084", "call", "I9"), ("0178F0", "01A084", "imm", "I9"),
        ("03464A", "034CCE", "call", "I8"), ("03467C", "034CCE", "slot32", "I8"),
        ("003270", "00327E", "jump", "I8x"), ("003270", "00328A", "jump", "I8x"), ("003270", "00329C", "jump", "I8x"),
        ("003272", "00327E", "slot32", "I8x"), ("003276", "00328A", "slot32", "I8x"), ("00327A", "00329C", "slot32", "I8x")]
w("seed-edges.tsv", "site\ttarget\tkind\tlane", EDG)
LED = [
    ("MAIN proven code, H9 (mask rebuilt from H9 offline code; == I3 h9_proven_mask.bin)", "", P_H9, "main-descent/ledger-delta.tsv", ""),
    ("I6 exit table 0x19A9E", "+%d" % sum(M6), "", "orphan-screens/exit-table-new-insns.tsv", "re-derived; 0 overlap H9 proven"),
    ("I8 0x034CCE via jsr @er6 0x03464A (Confirmed)", "+%d" % sum(M8c), "", "indirect-cb/ledger-delta.tsv", "re-derived with H9 descent"),
    ("I8 tier-X 0x003272 via jmp @er6 0x003270", "+%d" % sum(M8x), "", "indirect-cb/ledger-delta.tsv", "I14: Confirmed (see doc 65 Findings 2)"),
    ("I9 three edges", "+%d" % sum(M9), "", "suspect-tables/new-proven-bytes.tsv", "re-derived with H9 descent"),
    ("pairwise intersections (sum)", "-%d" % sum(n for _, _, n in pairs), "", "overlaps.tsv", "union, not sum"),
    ("MAIN proven code, merged (byte union)", "+%d" % dP_all, P_H9 + dP_all, "merged-new-bytes.tsv", "%.2f%% of 505,684; %.2f%% of 388,490" % (100.0 * (P_H9 + dP_all) / 505684, 100.0 * (P_H9 + dP_all) / 388490)),
    ("  companion: merged without tier-X", "+%d" % dP_c, P_H9 + dP_c, "", ""),
    ("MAIN named/typed, H9", "", N_H9, "main-descent/ledger-delta.tsv", ""),
    ("joins named: union bytes outside H9 named mask", "+%d" % dN_all, N_H9 + dN_all, "merged-new-bytes.tsv",
     "I6 +%d, I8 +%d (lane said 0: 0x034CD5/0x034D03 are H9 RC 'junk -> leaves' bytes, now reached), I9 +%d" % (
         sum(1 for x in range(HI) if M6[x] and not NAMD[x]), sum(1 for x in range(HI) if (M8c[x] or M8x[x]) and not NAMD[x]),
         sum(1 for x in range(HI) if M9[x] and not NAMD[x]))),
    ("headline (H-wave SUB 464,166)", "", N_H9 + dN_all + 464166, "", "%.4f%% of 1,029,972" % (100.0 * (N_H9 + dN_all + 464166) / DEN)),
    ("headline (I2 SUB 464,263)", "", N_H9 + dN_all + 464263, "sub-final/ledger-delta.tsv", "%.4f%% of 1,029,972" % (100.0 * (N_H9 + dN_all + 464263) / DEN)),
]
w("ledger-delta.tsv", "term\tdelta_bytes\tvalue\tsource\tnote", LED)
pickle.dump(dict(UNI=bytes(UNI), UNIc=bytes(UNIc), PROV=bytes(PROV), NAMD=bytes(NAMD), INS=INS, SETS={k: bytes(v) for k, v in SETS.items()}),
            open(SCR + "i14_merge.pkl", "wb"))
open(OUT + "merge_log.txt", "w", encoding="utf-8", newline="\n").write("\n".join(LOG) + "\n")
