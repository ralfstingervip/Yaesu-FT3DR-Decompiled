import sys
from pathlib import Path as _Path
_REPO = _Path(__file__).resolve().parents[3]
# M13 -- independent re-derivation of the L-wave MAIN ledger (final5 and proposed final6 masks).
# Owner-side static analysis. Read-only on every input; plain Python, no IDA.
# Imports H9's descent.py / common.py unchanged (never as __main__). K1's folded-descent rules (K1a table
# rebuild, K1b touch-helper edges) are re-implemented here from k1_build_masks.py's stated rules, not
# imported from recon_descent.py, so the orchestrator's script is checked rather than reused.
# Outputs (to OUTDIR, default this folder): counts_ledger.tsv, m13-descent-runs.tsv, ledger-log.txt
# Run: python "ida/out/ledger-reverify-l/m13_ledger.py"
import sys, os, re, hashlib, time
sys.dont_write_bytecode = True
H9 = str(_REPO) + r"/ida/out/main-descent/offline"
sys.path.insert(0, H9)
import descent as D9
from common import IMG, HI, CW, be32, bu

ROOT = str(_REPO) + "/"
OUT = os.environ.get("OUTDIR", ROOT + "ida/out/ledger-reverify-l/")
sys.exit('The firmware image is not in this repository.')
LOG = []
ROWS = []
def say(*a):
    s = " ".join(str(x) for x in a); print(s, flush=True); LOG.append(s)
def chk(item, derived, expected, note=""):
    ok = (str(derived) == str(expected))
    ROWS.append((item, str(derived), str(expected), "PASS" if ok else "FAIL", note))
    say(("PASS " if ok else "FAIL ") + item, "| derived", derived, "| expected", expected, ("| " + note) if note else "")
    return ok
def info(item, derived, note=""):
    ROWS.append((item, str(derived), "-", "INFO", note)); say("INFO " + item, "|", derived, ("| " + note) if note else "")
def rd(p): return open(ROOT + p, "rb").read()
def sha16(b): return hashlib.sha256(bytes(b)).hexdigest()[:16]
def be16(a): return int.from_bytes(IMG[a:a + 2], "big")
INW = lambda x: CW[0] <= x < CW[1]
def runs(f, lo=0, hi=HI):
    out = []; x = lo
    while x < hi:
        if f(x):
            s = x
            while x < hi and f(x): x += 1
            out.append((s, x))
        else: x += 1
    return out
def tsv_runs(p):
    out = []
    for ln in open(ROOT + p, encoding="utf-8").read().splitlines():
        if not ln or ln.startswith("#") or ln.startswith("start"): continue
        c = ln.split("\t"); out.append((int(c[0], 16), int(c[1], 16), int(c[2])))
    return out
def bits(rs):
    m = bytearray(HI)
    for s, e, *_ in rs:
        for x in range(s, e): m[x] = 1
    return m
T0 = time.time()

# ------------------------------------------------------------------ 0. images and masks
chk("MAIN sha256 prefix", hashlib.sha256(IMG).hexdigest()[:16], "8e3ecd05409b2c31")
chk("SUB sha256 prefix", hashlib.sha256(SUBIMG).hexdigest()[:16], "b93570b3c2f69ccb")
chk("MAIN image tail 0x07B754.. all 0xFF", all(b == 0xFF for b in IMG[HI:]), True)
P4 = rd("ida/out/main-final4/final4_proven_mask.bin"); N4 = rd("ida/out/main-final4/final4_named_mask.bin")
P5 = rd("ida/out/main-final5/final5_proven_mask.bin"); N5 = rd("ida/out/main-final5/final5_named_mask.bin")
P6 = rd("ida/out/l-wave-recon/final6_proven_mask.bin"); N6 = rd("ida/out/l-wave-recon/final6_named_mask.bin")
for nm, m, exp in (("final4 proven", P4, 368624), ("final4 named", N4, 497451), ("final5 proven", P5, 369214),
                   ("final5 named", N5, 498319), ("final6 proven", P6, 364786), ("final6 named", N6, 501656)):
    chk(nm + " length", len(m), 1048576)
    chk(nm + " values in {0,1}", set(m) <= {0, 1}, True)
    chk(nm + " popcount", sum(m), exp)
    chk(nm + " bytes set at/above 0x07B754", sum(m[HI:]), 0)
    info(nm + " sha256", sha16(m))
chk("final6 proven sha256 prefix (README)", sha16(P6), "ecd7deaf54da6d21")
chk("final6 named sha256 prefix (README)", sha16(N6), "fe8f60996e0a5852")
for nm, p, n in (("final4", P4, N4), ("final5", P5, N5), ("final6", P6, N6)):
    chk(nm + " proven subset of named", sum(1 for x in range(HI) if p[x] and not n[x]), 0)
CONTENT = 505684
chk("content length 0x07B754", HI, CONTENT)

# ------------------------------------------------------------------ 1. final5 = final4 - 278 + 868
DEM = (0x054AE2, 0x054BF8)
chk("0x054AE2-0x054BF7 length", DEM[1] - DEM[0], 278)
chk("0x054AE2-0x054BF7 fully proven in final4", sum(P4[DEM[0]:DEM[1]]), 278)
# window ranges derived independently: doc 95 code heads in 0x078106-0x078545 minus final4 proven
HEADS = []
for ln in open(ROOT + "ida/out/service-window/code-heads.tsv", encoding="utf-8").read().splitlines()[1:]:
    c = ln.split("\t"); a = int(c[0], 16); n = int(c[1]); HEADS.append((a, n, c[2]))
chk("doc 95 heads count", len(HEADS), 336)
chk("doc 95 heads tile 0x078106-0x078546", all(HEADS[i][0] + HEADS[i][1] == HEADS[i + 1][0] for i in range(len(HEADS) - 1)) and HEADS[0][0] == 0x078106 and HEADS[-1][0] + HEADS[-1][1] == 0x078546, True)
chk("doc 95 heads hex == image", sum(1 for a, n, h in HEADS if IMG[a:a + n].hex(" ") != h), 0)
WINCODE = bytearray(HI)
for a, n, h in HEADS:
    for x in range(a, a + n): WINCODE[x] = 1
WADD = [x for x in range(HI) if WINCODE[x] and not P4[x]]
WR = runs(lambda x: WINCODE[x] and not P4[x], 0x078106, 0x078546)
chk("window code bytes not in final4 proven", len(WADD), 868)
chk("window ranges (count)", len(WR), 13)
info("window ranges", " ".join("%06X-%06X" % (s, e - 1) for s, e in WR))
chk("window ranges clear in final4 named", sum(N4[x] for x in WADD), 0)
E5P = bytearray(P4[:HI])
for x in range(*DEM): E5P[x] = 0
for x in WADD: E5P[x] = 1
E5N = bytearray(N4[:HI])
for x in WADD: E5N[x] = 1
chk("final5 proven == final4 - 054AE2..054BF7 + window (byte-identical)", bytes(E5P) == P5[:HI], True)
chk("final5 named == final4 + window (byte-identical)", bytes(E5N) == N5[:HI], True)
chk("final4 \\ final5 proven", sum(1 for x in range(HI) if P4[x] and not P5[x]), 278)
chk("final5 \\ final4 proven", sum(1 for x in range(HI) if P5[x] and not P4[x]), 868)
chk("final5 \\ final4 named", sum(1 for x in range(HI) if N5[x] and not N4[x]), 868)
chk("final4 \\ final5 named", sum(1 for x in range(HI) if N4[x] and not N5[x]), 0)

# ------------------------------------------------------------------ 2. descent (K1 rules, independent driver)
EX6 = [(a, "I6 exit-table 0x19A9E") for a in sorted(set(0x148A0 + be16(0x19A9E + 2 * i) for i in range(206)))]
I8X = [(0x034CCE, "I8"), (0x00327E, "I8"), (0x00328A, "I8"), (0x00329C, "I8"), (0x077DB8, "I8"), (0x077FC6, "I8"), (0x078086, "I8")]
I9X = []
for rec in (0x0296E8, 0x029712):
    for off in (0x00, 0x04, 0x08, 0x0C, 0x14, 0x18):
        v = be32(rec + off)
        if v and v < HI and v % 2 == 0: I9X.append((v, "I9 rec"))
I9X += [(0x000706, "I9 ram-cell"), (0x01A084, "I9 er1 cb")]
I15X = []
for ln in open(ROOT + "ida/out/descent-ext/new-edges.tsv", encoding="utf-8").read().splitlines():
    if ln.startswith("#") or ln.startswith("rule"): continue
    c = ln.split("\t")
    if c[2] != "True": continue
    v = int(c[1], 16)
    if v and v < HI and v % 2 == 0: I15X.append((v, "I15"))
COMBINED = EX6 + I8X + I9X + I15X
# cross-check against K1's builder text: the seed families and the I8 list are stated there verbatim
K1SRC = open(ROOT + "ida/out/main-final4/offline/k1_build_masks.py", encoding="utf-8").read()
chk("K1 builder seeds I8 list (0x034CCE,0x00327E,0x00328A,0x00329C,0x077DB8,0x077FC6,0x078086) present", all(("0x%06X" % a) in K1SRC for a, _ in I8X), True)
chk("K1 builder COMBINED = EX6 + I8X + I9X + I15X", "COMBINED = EX6 + I8X + I9X + I15X" in K1SRC, True)
EXCL2 = set()
for ln in open(ROOT + "ida/out/h8sx-seed/table-xrefs-excluded.tsv", encoding="utf-8").read().splitlines()[1:]:
    if ln.startswith("#") or not ln.strip(): continue
    c = ln.split("\t")
    if not c[5].startswith("target is mid_code in seed"): EXCL2.add(int(c[0], 16))
TAB_NEW = {}
for fn in ("jumptables.tsv", "switch_tables.tsv"):
    for ln in open(ROOT + "ida/out/main-full/" + fn, encoding="utf-8").read().splitlines()[1:]:
        c = ln.split("\t"); b = int(c[0], 16); n = int(c[1]); d = TAB_NEW.setdefault(b, {})
        for i in range(n):
            s = b + 4 * i; v = be32(s)
            if s in EXCL2: continue
            if v < HI and v % 2 == 0 and v not in (0, 0x3FFA0): d[s] = v
for b in D9.H9_EXCL_TABLES: TAB_NEW[b] = {}
SIGA = bytes.fromhex("6b04bbc27924"); SIGB = bytes.fromhex("44141b544b10790c000010740ac6010069665d604004"); SIGC = bytes.fromhex("5e03ffa05470")
HELPERS = {a: be16(a + 6) for a in range(0x400, HI, 2) if IMG[a:a + 6] == SIGA and IMG[a + 8:a + 30] == SIGB and IMG[a + 30:a + 36] == SIGC}
info("K1b touch helpers", " ".join("%06X:N=%d" % kv for kv in sorted(HELPERS.items())))
JABS = re.compile(r"^(jmp|jsr) @(0x[0-9a-f]+):24$")
def helper_edges(reached):
    new = {}
    for a, (n, t, k) in reached.items():
        m1 = D9.MOVI.match(t); m2 = D9.LD.match(t)
        if m1 and m1.group(2) == "6": form, T = "imm", int(m1.group(1), 16)
        elif m2 and m2.group(4) == "6" and m2.group(3) == "4" and m2.group(2) == "32": form, T = "L1", int(m2.group(1), 16)
        else: continue
        for x, tt in D9.window(reached, a, 4):
            mj = JABS.match(tt)
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
                        if 0x400 <= v < HI and v % 2 == 0 and not INW(v): new.setdefault(v, "helper %06X" % h)
                break
            if D9.writes(tt, "6"): break
    return new
def folded(extra):
    D9.TAB.clear(); D9.TAB.update({b: dict(d) for b, d in TAB_NEW.items()})
    seeds = dict(extra)
    while True:
        r = D9.run("full", extra_seeds=sorted(seeds.items()))
        new = {a: l for a, l in helper_edges(r["reached"]).items() if a not in seeds and a not in r["seed"]}
        if not new: return r
        seeds.update(new)
def bm(r):
    m = bytearray(HI)
    for a, (n, t, k) in r["reached"].items():
        for x in range(a, min(HI, a + n)):
            if not INW(x): m[x] = 1
    return m
H9P = rd("ida/out/main-final/h9_proven_mask.bin")[:HI]
I12 = [(0x054D22, 0x054D4C), (0x054F3A, 0x054F88)]
say("descent: with fnindex seeds ...", round(time.time() - T0, 1)); rK = folded(COMBINED); MK = bm(rK)
R4 = bytearray(1 if (H9P[x] or MK[x]) else 0 for x in range(HI))
for s, e in I12:
    for x in range(s, e): R4[x] = 0
chk("K1 rule rebuild: (h9_proven | folded descent) - I12 == final4 proven", bytes(R4) == P4[:HI], True, "my driver reproduces K1's mask")
FNSAVE = dict(D9.FNSEED); info("H9 fnindex seeds", len(FNSAVE))
D9.FNSEED.clear()
say("descent: without fnindex ...", round(time.time() - T0, 1)); rN = folded(COMBINED); MN = bm(rN)
NEW6 = [(0x018250, "L2"), (0x018ABE, "L2"), (0x01A094, "L2"), (0x05E8E0, "L4"), (0x066FB4, "L4"), (0x067250, "L4")]
NEW8 = NEW6 + [(0x066FBE, "hand"), (0x06726A, "hand")]
say("descent: without fnindex + 6 edges ...", round(time.time() - T0, 1)); r6 = folded(COMBINED + NEW6); M6 = bm(r6)
say("descent: without fnindex + 8 entries ...", round(time.time() - T0, 1)); r8 = folded(COMBINED + NEW8); M8 = bm(r8)
D9.FNSEED.update(FNSAVE)
FO = bytearray(1 if (P4[x] and MK[x] and not MN[x]) else 0 for x in range(HI))
FOT = bits(tsv_runs("ida/out/main-final4/fnindex-only-runs.tsv"))
chk("fnindex-only bytes (P4 & with-fn & ~without-fn)", sum(FO), 4850)
chk("fnindex-only runs", len(runs(lambda x: FO[x])), 94)
chk("fnindex-only == fnindex-only-runs.tsv (byte-identical)", bytes(FO) == bytes(FOT), True)
REC = [x for x in range(HI) if FO[x] and M6[x]]
DROP = [x for x in range(HI) if FO[x] and not M6[x]]
chk("recovered by 6 new edges (B)", len(REC), 108)
chk("rec_runs.tsv == recovered (byte-identical)", bytes(bits(tsv_runs("ida/out/l-wave-recon/rec_runs.tsv"))) == bytes(bits([(x, x + 1) for x in REC])), True)
chk("drop (fnindex-only, not recovered) bytes", len(DROP), 4742)
chk("drop runs", len(runs(lambda x: x in set(DROP))) if False else len(runs(lambda x, S=set(DROP): x in S)), 89)
chk("drop_runs.tsv == drop (byte-identical)", bytes(bits(tsv_runs("ida/out/l-wave-recon/drop_runs.tsv"))) == bytes(bits([(x, x + 1) for x in DROP])), True)
DS = set(DROP)
chk("drop includes 0x054AE2-0x054BF7 (already out of final5)", all(x in DS for x in range(*DEM)), True)
chk("drop bytes still in final5", sum(1 for x in DROP if P5[x]), 4464)
R36 = list(range(0x066FBE, 0x066FC8)) + list(range(0x06726A, 0x067284))
chk("hand restore length 0x066FBE-0x066FC7 + 0x06726A-0x067283", len(R36), 36)
chk("hand-restore bytes inside drop", sum(1 for x in R36 if x in DS), 36)
chk("8-entry descent reaches exactly the 36 restored bytes beyond the 6-edge run (within FO)", sorted(x for x in range(HI) if FO[x] and M8[x] and not M6[x]) == R36, True)
E6P = bytearray(P5[:HI])
for x in DROP: E6P[x] = 0
for x in R36: E6P[x] = 1
chk("final6 proven == final5 - drop + 36 (byte-identical, from my descent)", bytes(E6P) == P6[:HI], True)
E6P8 = bytearray(1 if (P5[x] and not (FO[x] and not M8[x])) else 0 for x in range(HI))
chk("final6 proven == final5 - (fnindex-only & ~8-entry descent)", bytes(E6P8) == P6[:HI], True)
chk("final5 - final6 proven", sum(P5[:HI]) - sum(P6[:HI]), 4428)
chk("final6 \\ final5 proven", sum(1 for x in range(HI) if P6[x] and not P5[x]), 0)
# per lane: L2 < 0x030000 <= L3 < 0x050000 <= L4
NETDROP = [x for x in range(HI) if P5[x] and not P6[x]]
lane = {"L2": sum(1 for x in NETDROP if x < 0x30000), "L3": sum(1 for x in NETDROP if 0x30000 <= x < 0x50000), "L4": sum(1 for x in NETDROP if x >= 0x50000)}
chk("per-lane L2 (<0x030000)", lane["L2"], 884); chk("per-lane L3 (0x030000-0x04FFFF)", lane["L3"], 2532); chk("per-lane L4 (>=0x050000)", lane["L4"], 1012)
# lane run tables cover the drops
LANE_T = {}; CLS = {}
for ln_, p in (("L2", "ida/out/fnindex-lo/runs.tsv"), ("L3", "ida/out/fnindex-mid/runs.tsv"), ("L4", "ida/out/fnindex-hi/runs.tsv")):
    rs = []
    for l in open(ROOT + p, encoding="utf-8").read().splitlines():
        if not l or l.startswith("#") or l.startswith("start"): continue
        c = l.split("\t"); rs.append((int(c[0], 16), int(c[1], 16), int(c[2]), c[3]))
    tot = sum(r[2] for r in rs); info(ln_ + " runs.tsv", "%d runs / %d B; classes %s" % (len(rs), tot, sorted(set(r[3] for r in rs))))
    rch = [r for r in rs if "REACH" in r[3].upper()]
    info(ln_ + " REACHED rows", " ".join("%06X+%d" % (r[0], r[2]) for r in rch) or "none")
    CLS[ln_] = {k_: sum(r[2] for r in rs if r[3] == k_) for k_ in set(r[3] for r in rs)}
    LANE_T[ln_] = (len(rs), tot, sum(r[2] for r in rch), sum(r[2] for r in rs if r[3] == "ALREADY-DEMOTED"))
chk("lane runs.tsv total runs / bytes (L2+L3+L4)", (sum(v[0] for v in LANE_T.values()), sum(v[1] for v in LANE_T.values())), (94, 4850))
chk("REACHED bytes L2 + L4 (RESUME: 144 B)", (LANE_T["L2"][2], LANE_T["L4"][2], LANE_T["L2"][2] + LANE_T["L4"][2]), (54, 90, 144))
chk("data-mistyped bytes per lane L2/L3/L4 (README 80/144/26)", (CLS["L2"].get("DATA-MISTYPED"), CLS["L3"].get("DATA-MISTYPED"), CLS["L4"].get("DATA-MISTYPED")), (80, 144, 26))
chk("L4 DEAD + SPLIT-TAIL (README 696)", CLS["L4"]["DEAD"] + CLS["L4"]["SPLIT-TAIL"], 696)
chk("L4 WINDOW-ONLY rows (README 290 USB-module bytes)", CLS["L4"]["WINDOW-ONLY"], 290)
chk("REACHED 144 = recovered by 6 edges 108 + hand 36", 108 + 36, LANE_T["L2"][2] + LANE_T["L4"][2])
chk("L2 runs bytes - REACHED == L2 net drop", LANE_T["L2"][1] - LANE_T["L2"][2], lane["L2"])
chk("L3 runs bytes - REACHED == L3 net drop", LANE_T["L3"][1] - LANE_T["L3"][2], lane["L3"])
chk("L4 runs bytes - REACHED - ALREADY-DEMOTED == L4 net drop", LANE_T["L4"][1] - LANE_T["L4"][2] - LANE_T["L4"][3], lane["L4"])
L4D = [x for x in NETDROP if x >= 0x50000]
usb = sum(1 for x in L4D if 0x077CC2 <= x < 0x077CC2 + 206) + sum(1 for x in L4D if 0x07778C <= x < 0x07778C + 84)
chk("L4 USB-module demotions 0x077CC2(206)+0x07778C(84)", usb, 290)
for a, n in ((0x03C668, 820), (0x046210, 472), (0x045F88, 50), (0x01C4D2, 194), (0x077CC2, 206), (0x07778C, 84)):
    chk("dropped run %06X len" % a, next((e - s for s, e in runs(lambda x: P5[x] and not P6[x]) if s == a), None), n)
# proven but never reached by the full descent
PU = runs(lambda x: P4[x] and not MK[x])
chk("final4-proven bytes not reached by full descent (B)", sum(e - s for s, e in PU), 1692)
chk("... runs", len(PU), 80)
big = sorted(PU, key=lambda r: -(r[1] - r[0]))[:3]
chk("largest three", " ".join("%06X:%d" % (s, e - s) for s, e in big), "05C8DC:218 0460C2:110 03D0EE:98")
for a in (0x06AB1C, 0x06AB2A, 0x06AB36, 0x06AE04, 0x06AE10, 0x062808, 0x06723A):
    chk("caller %06X P4=1, full descent=0" % a, (P4[a], MK[a]), (1, 0))
PUT = bits(tsv_runs_ := [(int(l.split("\t")[0], 16), int(l.split("\t")[1], 16), 0) for l in open(ROOT + "ida/out/l-wave-recon/proven-unreached-runs.tsv", encoding="utf-8").read().splitlines() if l and not l.startswith(("#", "start"))])
chk("proven-unreached-runs.tsv == P4 & ~descent (byte-identical)", bytes(PUT) == bytes(bits(PU)), True)
for x in (0x006A0C, 0x006A0D, 0x0077F8, 0x0077F9):
    info("stale-head byte %06X: P4/MK/P6/N6" % x, (P4[x], MK[x], P6[x], N6[x]))
open(OUT + "m13-descent-runs.tsv", "w", encoding="utf-8", newline="\n").write(
    "# M13 descent re-run: net final5->final6 proven removals (P5 & ~P6) as runs, lane, first bytes\nstart\tend_excl\tlen\tlane\tfirst_bytes\n" +
    "".join("%06X\t%06X\t%d\t%s\t%s\n" % (s, e, e - s, "L2" if s < 0x30000 else ("L3" if s < 0x50000 else "L4"), IMG[s:min(e, s + 8)].hex()) for s, e in runs(lambda x: P5[x] and not P6[x])))

# ------------------------------------------------------------------ 3. byte evidence for the 8 entries and the drops
ER1 = bytes.fromhex("5e015206")
sites = []; j = IMG.find(ER1)
while j >= 0:
    if j < HI: sites.append(j)
    j = IMG.find(ER1, j + 1)
chk("jsr @0x015206 sites (5e 01 52 06)", len(sites), 14)
chk("0x015224 = jsr @er1 (5d 10)", IMG[0x015224:0x015226].hex(), "5d10")
for tgt, ld in ((0x018250, 0x018276), (0x018ABE, 0x018AD2), (0x01A094, 0x018BE8), (0x05E8E0, 0x05E862)):
    chk("er1 load %06X = mov.l #%06X,er1 and jsr @0x15206 at +6" % (ld, tgt), (IMG[ld:ld + 6].hex(), IMG[ld + 6:ld + 10].hex(), P6[ld], P6[ld + 6]),
        ("7a0100%06x" % tgt, "5e015206", 1, 1))
for tgt in (0x066FB4, 0x067250, 0x066FBE, 0x06726A):
    pat = bytes([0x5E]) + tgt.to_bytes(3, "big"); hits = []; j = IMG.find(pat)
    while j >= 0:
        if j < HI and j % 2 == 0: hits.append(j)
        j = IMG.find(pat, j + 1)
    info("abs24 jsr @%06X sites (P6 proven)" % tgt, " ".join("%06X(%d)" % (h, P6[h]) for h in hits))
    chk("abs24 jsr @%06X has a site in final6-proven code" % tgt, any(P6[h] for h in hits), True)
chk("0x067246 bsr", IMG[0x067246:0x067248].hex()[:2], "55")
chk("0x067246 bsr target", "%06X" % (0x067248 + (IMG[0x067247] - 256 if IMG[0x067247] > 127 else IMG[0x067247])), "06726A")
# 0x033780 inbound scan
TG = {0x033780, 0x033790, 0x0337AC, 0x0337C8}
hits = []
for x in range(0, HI - 3):
    v = be32(x)
    if (v & 0xFFFFFF) in TG and (v >> 24) in (0x00, 0x5E, 0x5A): hits.append(("be32/abs24 %06X %s" % (x, IMG[x:x + 4].hex()), x))
for x in range(0, HI - 4, 2):
    b0, b1 = IMG[x], IMG[x + 1]
    t = None
    if (b0 >> 4) == 4 or b0 == 0x55:
        t = x + 2 + (b1 - 256 if b1 > 127 else b1)
    elif (b0 == 0x58 and (b1 & 0x0F) == 0) or (b0 == 0x5C and b1 == 0):
        d = int.from_bytes(IMG[x + 2:x + 4], "big"); t = x + 4 + (d - 65536 if d > 32767 else d)
    if t in TG: hits.append(("rel %06X %s -> %06X" % (x, IMG[x:x + 4].hex(), t), x))
    if IMG[x] == 0x7A and (IMG[x + 1] >> 4) == 0 and int.from_bytes(IMG[x + 2:x + 6], "big") in TG: hits.append(("mov.l #imm %06X" % x, x))
info("refs to 0x033780/90/AC/C8 (any offset, any form)", "; ".join("%s P5=%d P6=%d" % (h, P5[x], P6[x]) for h, x in hits) or "none")
chk("refs to 0x033780 stubs whose source byte is final5-proven", sum(1 for h, x in hits if P5[x]), 0)
chk("refs to 0x033780 stubs at even offsets (any mask)", sum(1 for h, x in hits if x % 2 == 0), 0)
RECS = [(0x07B4B4 + 10 * i, be32(0x07B4B4 + 10 * i), be32(0x07B4B4 + 10 * i + 6)) for i in range(6)]
info("service-window handler records 0x07B4B4 (stride 10: BE32 key, u16, BE32 handler)", " ".join("%06X:%08X->%06X" % r for r in RECS))
chk("first three handler targets (RESUME:46 names these)", " ".join("%06X" % r[2] for r in RECS[:3]), "0784BE 0769AA 0768C8")
chk("no handler record points at 0x033780 or its stubs", sum(1 for r in RECS if r[2] in TG), 0)
chk("0x03C996 bytes (bra to 0x03C668)", (IMG[0x03C996:0x03C99A].hex(), "%06X" % (0x03C99A + int.from_bytes(IMG[0x03C998:0x03C99A], "big", signed=True))), ("5860fcce", "03C668"))
for a, hx, tg in ((0x0460C0, "406e", 0x046130), (0x01C27C, "401a", 0x01C298), (0x01D932, "4012", 0x01D946)):
    chk("%06X bra" % a, (IMG[a:a + 2].hex(), "%06X" % (a + 2 + IMG[a + 1] if IMG[a + 1] < 128 else a + 2 + IMG[a + 1] - 256)), (hx, "%06X" % tg))
# no BE32 or abs24 call/jump into the J14 page writer / NMEA parsers / 0x01C4D2
for t in (0x03C668, 0x046210, 0x045F88, 0x01C4D2):
    h = []
    for x in range(0, HI - 3):
        v = be32(x)
        if (v & 0xFFFFFF) == t and (v >> 24) in (0, 0x5E, 0x5A): h.append("%06X:%s(P6=%d)" % (x, IMG[x:x + 4].hex(), P6[x]))
    info("BE32/abs24 refs to %06X" % t, " ".join(h) or "none")
    srcs = [int(s_.split(":")[0], 16) for s_ in h if "P6=1" in s_]
    # README: the remaining proven callers are the not-yet-applied dead companions, set by H9's analyze rules, unreached by the descent
    chk("final6-proven abs24 callers of %06X are README companions and descent-unreached" % t,
        all(x in (0x0076DA, 0x01C28E, 0x0460C8, 0x0460D6, 0x046104, 0x04612A) and not MK[x] for x in srcs), True, " ".join("%06X" % x for x in srcs) or "none")

# README "Check after the drop": every edge from final6-proven bytes into net-dropped bytes (byte-level scan at even offsets)
ND = bytearray(HI)
for x in NETDROP: ND[x] = 1
EDG = []
for x in range(0x400, HI - 6, 2):
    if not P6[x]: continue
    b0, b1 = IMG[x], IMG[x + 1]; t = None; kind = None
    if b0 in (0x5E, 0x5A): t = int.from_bytes(IMG[x + 1:x + 4], "big"); kind = "abs24 " + ("jsr" if b0 == 0x5E else "jmp")
    elif b0 == 0x7A and (b1 >> 4) == 0 and IMG[x + 2] == 0: t = int.from_bytes(IMG[x + 2:x + 6], "big"); kind = "mov.l #imm,er%d" % (b1 & 7)
    elif (b0 >> 4) == 4 or b0 == 0x55: t = x + 2 + (b1 - 256 if b1 > 127 else b1); kind = "rel8 " + IMG[x:x + 2].hex()
    elif (b0 == 0x58 and (b1 & 0x0F) == 0) or (b0 == 0x5C and b1 == 0):
        d = int.from_bytes(IMG[x + 2:x + 4], "big"); t = x + 4 + (d - 65536 if d > 32767 else d); kind = "rel16 " + IMG[x:x + 2].hex()
    if t is not None and t < HI and ND[t] and (t == 0 or not ND[t - 1] or kind.startswith(("abs24", "mov.l"))):
        EDG.append((x, kind, t, bu(x)[1] if bu(x)[0] else "(no decode at x)", P6[x], MK[x], M8[x]))
open(OUT + "m13-after-drop-edges.tsv", "w", encoding="utf-8", newline="\n").write(
    "# byte-level scan: even offsets x with final6 proven = 1 whose abs24 / mov.l #imm / relative target lies in a net-dropped byte\n"
    "# (relative/branch targets kept only at the first byte of a dropped run). bu_text = binutils oracle decode at x\n"
    "src\tkind\ttarget\tbu_text\tP6\tdescent_with_fn\tdescent_8entry\n" +
    "".join("%06X\t%s\t%06X\t%s\t%d\t%d\t%d\n" % e for e in EDG))
real = [e for e in EDG if e[3].split(" ")[0] in ("jsr", "jmp", "bsr", "mov.l") or e[3].split(" ")[0].startswith("b")]
info("after-drop edges (decoded instruction at x)", "; ".join("%06X %s -> %06X [%s] desc8=%d" % (e[0], e[1], e[2], e[3], e[6]) for e in real))
chk("after-drop decoded call/branch edges reached by the 8-entry descent", sum(1 for e in real if e[6] and e[3].split(" ")[0] in ("jsr", "jmp", "bsr", "bra") ), 0)

LANECLS = []
for p_ in ("ida/out/fnindex-lo/runs.tsv", "ida/out/fnindex-mid/runs.tsv", "ida/out/fnindex-hi/runs.tsv"):
    for l in open(ROOT + p_, encoding="utf-8").read().splitlines():
        if not l or l.startswith(("#", "start")): continue
        c = l.split("	"); LANECLS.append((int(c[0], 16), int(c[1], 16), c[3]))
def lanecls(t): return next((c for s_, e_, c in LANECLS if s_ <= t < e_), "?")
movs = [e for e in real if e[3].startswith("mov.l")]
calls = [e for e in real if not e[3].startswith("mov.l")]
er5dead = sorted(set(e[2] for e in movs if lanecls(e[2]) == "DEAD"))
chk("after-drop mov.l #imm targets: lane class DATA-MISTYPED or DEAD", all(lanecls(e[2]) in ("DATA-MISTYPED", "DEAD") for e in movs), True, "%d loads" % len(movs))
chk("after-drop mov.l #imm into DEAD runs = L4's four vestigial er5 handlers", (" ".join("%06X" % t for t in er5dead), all(e[1].endswith("er5") for e in movs if e[2] in er5dead)), ("0620A6 062178 062722 067128", True))
chk("after-drop call edges = README dead companions", " ".join("%06X" % e[0] for e in calls), "0076DA 01C28E 0460C8 0460D6 046104 04612A")
chk("after-drop call sources unreached by the 8-entry descent", sum(e[6] for e in calls), 0)

# ------------------------------------------------------------------ 4. named
RES = rd("ida/out/main-unnamed/residue_mask.bin")
chk("L5 residue mask length", len(RES), CONTENT)
chk("L5 residue popcount", sum(RES), 7365)
chk("residue & final5 named", sum(1 for x in range(HI) if RES[x] and N5[x]), 0)
chk("residue | final5 named == all content", all(RES[x] or N5[x] for x in range(HI)), True)
rows = [l.split("\t") for l in open(ROOT + "ida/out/main-unnamed/proposed-typing.tsv", encoding="utf-8").read().splitlines()[1:] if l]
conf = [r for r in rows if r[5] == "Confirmed"]
chk("proposed-typing Confirmed rows", len(conf), 522)
CM = bytearray(HI)
for r in conf:
    for x in range(int(r[0], 16), int(r[1], 16)): CM[x] = 1
chk("Confirmed typing bytes", sum(CM), 3337)
chk("Confirmed typing lengths sum == bytes (no overlap)", sum(int(r[2]) for r in conf), 3337)
chk("Confirmed typing inside residue", sum(1 for x in range(HI) if CM[x] and not RES[x]), 0)
E6N = bytearray(1 if (N5[x] or CM[x]) else 0 for x in range(HI))
chk("final6 named == final5 named | Confirmed typing (byte-identical)", bytes(E6N) == N6[:HI], True)
chk("final6 named - final5 named", sum(N6) - sum(N5), 3337)
chk("L6 +28 B (0x010CC0-0x010CC3, 0x011038-0x01104F) inside Confirmed tier", sum(CM[x] for x in list(range(0x010CC0, 0x010CC4)) + list(range(0x011038, 0x011050))), 28)
chk("L6 +28 B clear in final5 named", sum(N5[x] for x in list(range(0x010CC0, 0x010CC4)) + list(range(0x011038, 0x011050))), 0)
inf = [r for r in rows if r[5] == "Inferred"]
chk("Inferred typing bytes (not credited)", sum(int(r[2]) for r in inf), 3934)
chk("Inferred dead-code bytes", sum(int(r[2]) for r in inf if r[3] == "dead code"), 2880)
U = [x for x in range(HI) if not N6[x]]
chk("unnamed after final6", len(U), CONTENT - 501656)
UNN = range(0x069A7F, 0x069AAA)
chk("0x069A7F-0x069AA9 length", len(UNN), 43)
chk("0x069A7F-0x069AA9 unnamed in final6", sum(1 for x in UNN if not N6[x]), 43)
info("unnamed after final6 = Inferred + fill + 43?", "%d = %d + 51 + 43 -> %s" % (len(U), 3934, len(U) == 3934 + 51 + 43))
chk("final6 named & ~proven stale-head 4 B (0x006A0C/0x0077F8) named", (N6[0x006A0C], N6[0x006A0D], N6[0x0077F8], N6[0x0077F9]), (1, 1, 1, 1))

# ------------------------------------------------------------------ 5. SUB and headline
SUBH = rd("ida/out/sub-final3/raw/mask_final3_after_headline_w2.bin")
chk("SUB window code (K7 headline_w2 mask)", sum(SUBH), 464263)
TOT = 505684 + 524288
chk("headline denominator", TOT, 1029972)
chk("headline numerator", sum(N6[:HI]) + sum(SUBH), 965919)
chk("headline %", "%.2f" % (100.0 * 965919 / 1029972), "93.78")
chk("previous headline 962,582 %", "%.2f" % (100.0 * (498319 + 464263) / 1029972), "93.46")
chk("headline delta", 965919 - 962582, 3337)
chk("MAIN named %", "%.2f" % (100.0 * 501656 / 505684), "99.20")
chk("MAIN proven % of content", "%.2f" % (100.0 * 364786 / 505684), "72.14")
chk("decodable 388,490 + 770", 388490 + 770, 389260)
chk("window decodable 1,088 - 318", 1088 - 318, 770)
h1w = 0
for ln in open(ROOT + "ida/out/recount/work/items_h1.tsv", encoding="utf-8").read().splitlines()[1:]:
    c = ln.split("\t"); ea = int(c[0], 16); n = int(c[1])
    if c[2] == "code": h1w += max(0, min(ea + n, 0x078546) - max(ea, 0x078106))
chk("H1_RECOUNT items_h1 code bytes in 0x078106-0x078545 (L1: 318)", h1w, 318)
chk("doc 95 window code heads bytes", sum(n for a, n, h in HEADS), 1088)
chk("MAIN proven % of decodable", "%.2f" % (100.0 * 364786 / 389260), "93.71")
chk("369,214 - 4,428", 369214 - 4428, 364786)
chk("498,319 + 3,337", 498319 + 3337, 501656)
chk("368,624 - 278 + 868", 368624 - 278 + 868, 369214)
chk("497,451 + 868", 497451 + 868, 498319)
chk("884 + 2,532 + 1,012", 884 + 2532 + 1012, 4428)
chk("4,742 - 278 - 36", 4742 - 278 - 36, 4428)
chk("L4 1,012 = 696 + 26 + 290", 696 + 26 + 290, 1012)
chk("data-mistyped 80 + 144 + 26", 80 + 144 + 26, 250)

with open(OUT + "counts_ledger.tsv", "w", encoding="utf-8", newline="\n") as f:
    f.write("item\tderived\texpected\tverdict\tnote\n")
    for r in ROWS: f.write("\t".join(x.replace("\t", " ") for x in r) + "\n")
open(OUT + "ledger-log.txt", "w", encoding="utf-8", newline="\n").write("\n".join(LOG) + "\n")
print("ledger checks:", len(ROWS), "PASS", sum(1 for r in ROWS if r[3] == "PASS"), "FAIL", sum(1 for r in ROWS if r[3] == "FAIL"), "INFO", sum(1 for r in ROWS if r[3] == "INFO"), "time", round(time.time() - T0, 1))
