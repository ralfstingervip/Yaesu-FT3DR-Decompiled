# Lane L3: final classification + measured loss for the 31 fnindex-only runs in 0x030000-0x04FFFF.
# Read-only on every input (image, K1 masks, H9/K1 builders via exec of K1's pure prefix). Writes only
# ida\out\fnindex-mid\{runs.tsv, proposed-demotions.tsv, refs-detail.tsv, measure.txt}.
import sys
from pathlib import Path as _Path
_REPO_S = _Path(__file__).resolve().parents[4].as_posix()
import sys, os, hashlib, collections
sys.dont_write_bytecode = True
ROOT = (_REPO_S + "/")
OUT = ROOT + "ida/out/fnindex-mid/"
sys.path.insert(0, OUT + "offline")
sys.argv = [sys.argv[0]]
import l3_refs as R
IMG = R.IMG; HI = R.HI
sys.exit("The firmware image is not in this repository.")

# ---------------------------------------------------------------- classification (evidence lines are the doc's claims)
# (start, end_excl, class, routine/unit extent checked, evidence)
C = [
 (0x033790, 0x0337A4, "SPLIT-TAIL", [(0x033780, 0x0337A4)], "tail of routine 033780 (6e 0c 00 19 mov.b @(0x19,er0),r4l ... beq 0x337A2 at 03378E); run starts after the not-taken beq; head 033780-03378F (16 B, named, unproven) has 0 inbound refs whole-image; preceded by rts 03377E"),
 (0x0337AC, 0x0337C0, "SPLIT-TAIL", [(0x0337A4, 0x0337C0)], "tail of block 0337A4 (6a 0c bc 8d ac 3f 47 12) whose only inbound edge is 033786 beq .+28 inside the dead routine 033780; 0 other refs"),
 (0x0337C8, 0x0337DC, "SPLIT-TAIL", [(0x0337C0, 0x0337DC)], "tail of routine 0337C0 (6a 0c bc 8d ac 3c 47 12); head 0337C0-0337C7 has 0 inbound refs; preceded by rts 0337BE"),
 (0x033B70, 0x033B76, "DATA-MISTYPED", [(0x033B70, 0x033B76)], "FF-terminated byte list 03 06 0d 10 ff (+pad 00): 033B4A 7a 05 00 03 3b 70 mov.l #0x33B70,er5 -> jsr 0x3F768 which scans mov.b @er5+ until 0xFF (03F768 6c 5c ac ff)"),
 (0x03400E, 0x034012, "DATA-MISTYPED", [(0x03400E, 0x034012)], "4-B lookup table 27 29 2a 29: 034004 7a 05 00 03 40 0e mov.l #0x3400E,er5; bsr 0x34022 = and.l #0xff,er3; add.l er3,er5; mov.b @er5,r3l (034022 7a 63 00 00 00 ff 0a b5 68 5b)"),
 (0x03531E, 0x03532E, "DATA-MISTYPED", [(0x03531E, 0x03532E)], "4 packed-BCD band bases 05000000 13700000 22200000 42000000 (50/137/222/420 MHz, 10-Hz units): loaded as mov.l #0x3531E/22/26/2A,er6 at 0352EC/0352CE/0352B0/03528C, consumed by BCD subtract 0x3F94C (mov.w @(2,er6),r4; das)"),
 (0x035422, 0x035432, "DATA-MISTYPED", [(0x03541E, 0x035432)], "byte tables read by mov.b @(0x35422/26/2A/2E:32,er2),r5h at 0353D0/035374/0353A2/035344 (78 20 6a 25 00 03 54 2x)"),
 (0x03799E, 0x0379E8, "DATA-MISTYPED", [(0x037988, 0x037A14)], "inside range table 0x037988 {u16 stride 8, u16 count 0x11, 17 x (lo,hi) packed-BCD dwords 14050000..46260000}; 03793E 7a 06 00 03 79 88 mov.l #0x37988,er6 -> jsr 0x3F5B2 (6d 62 6d 63 01 00 69 64 = stride,count,lo); only inbound edge is 037A0C (itself table bytes)"),
 (0x037A02, 0x037A14, "DATA-MISTYPED", [(0x037988, 0x037A14)], "last records of table 0x037988 (45340000 45380000 45900000 46260000); BE32 hits 00037a0x elsewhere all straddle unrelated instructions; 0379EC bls is table bytes"),
 (0x03A9A2, 0x03A9F6, "DEAD", [(0x03A9A2, 0x03A9F6)], "self-contained routine (stm; EEPROM read jsr 0x3AB80; scan FFAA58 for 0xFFFFFFFF); preceded by rts 03A9A0; 0 inbound refs whole-image"),
 (0x03C668, 0x03C99C, "DEAD", [(0x03C668, 0x03C99C)], "J14 64-B I2C page writer: 01 00 6d f0 6a 0a 81 6e 79 06 00 40 5c 00 fd 00 ... rts 03C99A; only edge into it is its own bne 03C996 (58 60 fc ce); preceded by rts 03C666; 0 jsr/jmp/BE32/imm/bsr refs; live single-page sibling 03C99C stays"),
 (0x03CDBE, 0x03CDEA, "DEAD", [(0x03CDBE, 0x03CDEA)], "two EEPROM-record wrappers 03CDBE/03CDD8 (bsr 0x3CE42; jsr 0x3AB80); 0 inbound refs; preceded by rts 03CDBC"),
 (0x03CDFC, 0x03CE22, "DEAD", [(0x03CDFC, 0x03CE0A), (0x03CE0A, 0x03CE22)], "03CDFC (14 B) 0 refs; 03CE0A (24 B) called only by jsr @0x3CE0A at 022E06/022E0E inside fnindex-only run 022DF0, whose only caller 022DE6 sits in head 022DDE (0 refs) -> dead chain (cross-lane)"),
 (0x03D36E, 0x03D37E, "DEAD", [(0x03D36E, 0x03D37E)], "EEPROM-record wrapper (bsr 0x3D38E; jsr 0x3AB80); 0 inbound refs"),
 (0x03D3A6, 0x03D40E, "DEAD", [(0x03D3A6, 0x03D40E)], "three EEPROM-record wrappers 03D3A6/03D3E6/03D3FE (verify-and-rewrite FFAA10 vs FFAC9A); 0 inbound refs"),
 (0x03D436, 0x03D472, "DEAD", [(0x03D436, 0x03D472)], "EEPROM-record verify/rewrite wrapper (FFAA1A vs FFAC9A, 9 words); 0 inbound refs"),
 (0x03D61C, 0x03D64E, "DEAD", [(0x03D61C, 0x03D64E)], "read/write wrappers 03D61C/03D62C + param leaf 03D63C (EEPROM 0xFFFC -> FF8005, 1 B); leaf called only from inside the run; 0 inbound refs"),
 (0x03D68A, 0x03D6B0, "DEAD", [(0x03D68A, 0x03D6B0)], "EEPROM read 0x31 B from 0xD07E to FF8D9E; 0 inbound refs"),
 (0x03D70E, 0x03D74A, "DEAD", [(0x03D70E, 0x03D74A)], "EEPROM read/write 0x20 B at 0xD480 <-> FFB05A; 0 inbound refs"),
 (0x03DC48, 0x03DC7A, "DEAD", [(0x03DC48, 0x03DC7A)], "load + count of non-0xFF records at FF95FD (24 x 15 B); 0 inbound refs"),
 (0x03DDCA, 0x03DDFC, "DEAD", [(0x03DDCA, 0x03DDFC)], "read/write wrappers 03DDCA/03DDDA + param leaf 03DDEA (EEPROM 0x1FA80 <-> FFBADE, 16 B); 0 inbound refs"),
 (0x03FFCA, 0x03FFE0, "DEAD", [(0x03FFC2, 0x03FFF4)], "8-bit sum of 63 B at FF8EA0; only callers are bsr at 03FFC2 and 03FFE0, both in heads (store sum to BBB9 / compare and jsr 0x1BF40) that have 0 inbound refs"),
 (0x045D1E, 0x045D88, "SPLIT-TAIL", [(0x045D18, 0x045D96)], "tail of NMEA field parser 045D18 (68 1b ab 2c 47 6a = mov.b @er1,r3l; cmp.b #0x2C; beq 0x45D88); run starts right after the beq; head 045D18 has 0 inbound refs; preceded by rts 045D16"),
 (0x045D8E, 0x045D96, "SPLIT-TAIL", [(0x045D18, 0x045D96)], "exit block of the same routine (pop er6; mov.b #1,r4l; rts); reached only from inside 045D18-045D95"),
 (0x045F88, 0x045FBA, "DEAD", [(0x045F88, 0x045FBA)], "NMEA field parser; only caller jsr @0x45F88 at 04612A lies in 0460C2-04612F, a block of sub_45FBA skipped by the unconditional 0460C0 40 6e (bra 0x46130) and entered by no edge"),
 (0x046210, 0x0463E8, "DEAD", [(0x046210, 0x0463E8)], "three NMEA field parsers 046210/046290/04633C (+ internal 046216/04629C/046348); callers 0460C8/0460D6/046104 are all in the same skipped block of sub_45FBA; other hits: 0442E0 bhi (unproven bytes) and BE32 @01FBF3 (odd, unproven) - not code edges"),
 (0x046532, 0x04658E, "SPLIT-TAIL", [(0x046482, 0x046602)], "tail of multi-entry decimal-digit formatter 046482-046601 (entries 046482/04648A/0464F0/0464F8/046500/04658E/046596/04659E/0465A6 = bclr/bset #6,@0xAA33; bra); 0 inbound refs to 046482-046601 from outside (046474 blt is ASCII template bytes, BE32 @04F3C5/@04F459 straddle add.l #0x465)"),
 (0x0465AE, 0x046602, "SPLIT-TAIL", [(0x046482, 0x046602)], "same unreferenced formatter; reached only from 04658C/046594/04659C inside it"),
 (0x048B84, 0x048B86, "DEAD", [(0x048B84, 0x048B86)], "orphan rts 54 70 after the 'LON ' string 048B80; the string consumer copies exactly 4 B (048764 79 04 00 04; eepmov.w); 0 inbound refs"),
 (0x04A394, 0x04A3E2, "SPLIT-TAIL", [(0x04A390, 0x04A3E2)], "fall-through continuation of head 04A390 (6b 8c a5 58 mov.w e4,@0xA558) which follows rts 04A38E and has 0 inbound refs; 04A394 itself 0 refs"),
 (0x04C3C8, 0x04C3D2, "DATA-MISTYPED", [(0x04C3C6, 0x04C3D2)], "bytes 02 03 04 ff 05 06 07 08 09 ff, part of FF-separated byte list 04C3C7.. after the 17 x 9-B APRS device-name table 04C32C (reader 04C2A8); decodes as ccr ops (orc #0xff,ccr / xorc / ldc #8,ccr), no rts; only IDA 'edge' is 04C364 blt = ASCII 'Mc'; 0 refs"),
]
assert len(C) == 31
RUNS = {}
for ln in open(ROOT + "ida/out/main-final4/fnindex-only-runs.tsv", encoding="utf-8").read().splitlines()[2:]:
    c = ln.split("\t"); RUNS[int(c[0], 16)] = (int(c[1], 16), int(c[2]))
mine = sorted(s for s in RUNS if 0x30000 <= s < 0x50000)
assert [r[0] for r in C] == mine and all(RUNS[s][0] == e for s, e, *_ in C)

# ---------------------------------------------------------------- whole-image inbound scan of every unit and run
units = sorted({u for *_, us, _ in [(r[0], r[1], r[2], r[3], r[4]) for r in C] for u in us} | {(r[0], r[1]) for r in C})
S = R.scan(units)
def ext(u, rows):   # rows whose source lies outside the unit
    return [x for x in rows if not (u[0] <= x[1] < u[1])]
with open(OUT + "refs-detail.tsv", "w", encoding="utf-8") as h:
    h.write("# L3 whole-image inbound references, per run and per routine unit. Scope: oracle decode of every even address 0x000000-0x07B753 "
            "(closed window decoded only), branch/call/jump targets + every numeric operand; raw BE32 and 5A/5E+BE24 at every byte offset of the 1 MB image; "
            "mov.w #hi,eN/#lo,rN pairs; @@aa:8 slots. src_class: base = reached by K1's folded descent with all fnindex seeds removed.\n")
    h.write("unit_start\tunit_end_excl\tkind\tsrc\tsrc_text\ttarget\tsrc_class\n")
    for u in units:
        rows = ext(u, S[u])
        for p in R.preceding(u[0]): h.write("%06X\t%06X\tpreceding\t%06X\t%s %s\t-\t%s\n" % (u[0], u[1], p[0], p[1], p[2], p[4]))
        for k, a, t, v, c in rows: h.write("%06X\t%06X\t%s\t%06X\t%s\t%06X\t%s\n" % (u[0], u[1], k, a, t, v, c))
        if not rows: h.write("%06X\t%06X\tnone\t-\t-\t-\t-\n" % u)

# ---------------------------------------------------------------- measured loss (exec of K1's pure prefix, as l3_edges.py)
K1SRC = ROOT + "ida/out/main-final4/offline/k1_build_masks.py"
src = open(K1SRC, encoding="utf-8").read(); cut = src.index("# attribution runs (each rule alone)")
G = {"__name__": "k1prefix", "__file__": K1SRC}
exec(compile(src[:cut], K1SRC, "exec"), G)
D9 = G["D9"]; run_folded = G["run_folded"]; COMBINED = G["COMBINED"]; INW = G["INW"]
FN0 = dict(D9.FNSEED)
def rmask(r):
    m = bytearray(HI)
    for a, (n, t, k) in r["reached"].items():
        for x in range(a, min(HI, a + n)):
            if not INW(x): m[x] = 1
    return m
rK, _ = run_folded(COMBINED); MK = rmask(rK)
def measure(drop):
    for a in drop: D9.FNSEED.pop(a, None)
    rr, _ = run_folded(COMBINED); D9.FNSEED.clear(); D9.FNSEED.update(FN0)
    m = rmask(rr)
    lost = [x for x in range(HI) if MK[x] and not m[x]]
    return lost
seedsA = sorted(a for a in FN0 if any(s <= a < e for s, e, *_ in C))
lostA = measure(seedsA)
seed022 = sorted(a for a in FN0 if 0x022DF0 <= a < 0x022E62)
lostB = measure(seedsA + seed022)
def byrun(lost):
    cnt = collections.Counter()
    for x in lost:
        k = [s for s in RUNS if s <= x < RUNS[s][0]]
        cnt["%06X" % k[0] if k else "other"] += 1
    return dict(sorted(cnt.items()))
mineset = {x for s, e, *_ in C for x in range(s, e)}
with open(OUT + "measure.txt", "w", encoding="utf-8") as h:
    h.write("fnindex seeds inside the 31 runs: %d (%s)\n" % (len(seedsA), " ".join("%06X" % a for a in seedsA)))
    h.write("A: drop those seeds -> lost %d B; in my runs %d / %d; by run %s\n" % (len(lostA), len(mineset & set(lostA)), len(mineset), byrun(lostA)))
    h.write("B: also drop cross-lane seed(s) %s (run 022DF0) -> lost %d B; in my runs %d / %d; by run %s\n" % (
        " ".join("%06X" % a for a in seed022), len(lostB), len(mineset & set(lostB)), len(mineset), byrun(lostB)))
    h.write("my-run bytes still reached in A: %s\n" % sorted("%06X" % x for x in mineset - set(lostA))[:40])
print(open(OUT + "measure.txt", encoding="utf-8").read())

# ---------------------------------------------------------------- runs.tsv and proposed-demotions.tsv
P4 = open(ROOT + "ida/out/main-final4/final4_proven_mask.bin", "rb").read()
N4 = open(ROOT + "ida/out/main-final4/final4_named_mask.bin", "rb").read()
with open(OUT + "runs.tsv", "w", encoding="utf-8") as h:
    h.write("# L3: the 31 fnindex-only runs with 0x030000 <= start < 0x050000 (from ida\\out\\main-final4\\fnindex-only-runs.tsv). "
            "Classes: REACHED / SPLIT-TAIL / DEAD / DATA-MISTYPED / UNCERTAIN. Inbound evidence per unit in refs-detail.tsv.\n")
    h.write("start\tend_excl\tlen\tclass\tunits_checked\tbase_flow_edges_in\tfirst_bytes\tevidence\n")
    for s, e, cl, us, ev in C:
        ncode = sum(1 for u in us for x in ext(u, S[u]) if x[4] in ("base",) and x[0] in ("flow",))
        h.write("%06X\t%06X\t%d\t%s\t%s\t%d\t%s\t%s\n" % (s, e, e - s, cl, ",".join("%06X-%06X" % u for u in us), ncode, IMG[s:min(e, s + 8)].hex(), ev))
tot = collections.Counter(); totb = collections.Counter()
with open(OUT + "proposed-demotions.tsv", "w", encoding="utf-8") as h:
    h.write("# L3 proposals only - no mask, seed or DB was edited. Each range is final4-proven (%s) and named; demotion = clear from proven mask "
            "(I12 convention: named unchanged; DATA-MISTYPED ranges should be retyped as data). byte_sum = sum of the image bytes in the range.\n" % "final4_proven_mask.bin")
    h.write("start\tend_excl\tlen\tclass\tproven_bytes\tnamed_bytes\tbyte_sum\tsha256_16\tnote\n")
    for s, e, cl, us, ev in C:
        b = IMG[s:e]
        h.write("%06X\t%06X\t%d\t%s\t%d\t%d\t%d\t%s\t%s\n" % (s, e, e - s, cl, sum(P4[s:e]), sum(N4[s:e]), sum(b), hashlib.sha256(b).hexdigest()[:16],
                ev.split(";")[0][:120]))
        tot[cl] += e - s; totb[cl] += sum(b)
    h.write("total\t-\t%d\tALL\t-\t-\t%d\t-\t%s\n" % (sum(tot.values()), sum(totb.values()), " ".join("%s=%d" % kv for kv in sorted(tot.items()))))
    # adjacent bytes of the same dead routines that are proven but reached by nothing (not fnindex-only; listed for the next seed)
    for s, e, note in [(0x045D88, 0x045D8E, "ADJACENT proven-unreached: 0b 01 fc 00 40 06 inside dead routine 045D18-045D95 (target of 045D1C beq only)"),
                       (0x0460C2, 0x046130, "ADJACENT proven-unreached: block of sub_45FBA skipped by 0460C0 bra 0x46130; holds the only calls to 045F88/046210/046290/04633C")]:
        b = IMG[s:e]
        h.write("%06X\t%06X\t%d\tADJACENT\t%d\t%d\t%d\t%s\t%s\n" % (s, e, e - s, sum(P4[s:e]), sum(N4[s:e]), sum(b), hashlib.sha256(b).hexdigest()[:16], note))
print("class totals", dict(tot), "all", sum(tot.values()))
