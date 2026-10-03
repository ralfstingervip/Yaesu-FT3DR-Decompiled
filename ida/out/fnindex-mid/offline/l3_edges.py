# Lane L3: whole-image inbound-edge check for the fnindex-only runs 0x030000-0x04FFFF.
# Read-only on every input. Reuses K1's one-descent builder definitions (exec of its pure prefix, no writes)
# and H9's descent/oracle. Writes only ida\out\fnindex-mid\work\*.
from pathlib import Path as _Path
_REPO_S = _Path(__file__).resolve().parents[4].as_posix()
import sys, os, re, pickle, collections, hashlib, time
sys.dont_write_bytecode = True
ROOT = (_REPO_S + "/")
K1SRC = ROOT + "ida/out/main-final4/offline/k1_build_masks.py"
OUTD = ROOT + "ida/out/fnindex-mid/work/"
os.makedirs(OUTD, exist_ok=True)
src = open(K1SRC, encoding="utf-8").read()
cut = src.index("# attribution runs (each rule alone)")
G = {"__name__": "k1prefix", "__file__": K1SRC}
exec(compile(src[:cut], K1SRC, "exec"), G)
D9 = G["D9"]; IMG = G["IMG"]; HI = G["HI"]; be32 = G["be32"]; flow = G["flow"]; bu = G["bu"]
run_folded = G["run_folded"]; COMBINED = G["COMBINED"]; PROV = G["PROV"]; RB = G["RB"]
I12 = G["I12_BLOCKS"]; INW = G["INW"]
LOG = open(OUTD + "l3_edges_log.txt", "w", encoding="utf-8")
def say(*a):
    s = " ".join(str(x) for x in a); print(s); LOG.write(s + "\n"); LOG.flush()

P4 = open(ROOT + "ida/out/main-final4/final4_proven_mask.bin", "rb").read()[:HI]
assert sum(P4) == 368624
RUNS = []
for ln in open(ROOT + "ida/out/main-final4/fnindex-only-runs.tsv", encoding="utf-8").read().splitlines()[2:]:
    c = ln.split("\t"); RUNS.append((int(c[0], 16), int(c[1], 16), int(c[2])))
assert len(RUNS) == 94 and sum(r[2] for r in RUNS) == 4850
FO = bytearray(HI)
for s, e, n in RUNS:
    for x in range(s, e): FO[x] = 1
MINE = [r for r in RUNS if 0x30000 <= r[0] < 0x50000]
say("runs total", len(RUNS), sum(r[2] for r in RUNS), "| mine", len(MINE), sum(r[2] for r in MINE))
def runof(a):
    for s, e, n in RUNS:
        if s <= a < e: return s
    return None

FNSEED_ALL = dict(D9.FNSEED)
t0 = time.time()
rK, SK = run_folded(COMBINED)
def reachmask(r):
    m = bytearray(HI)
    for a, (n, t, k) in r["reached"].items():
        for x in range(a, min(HI, a + n)):
            if not INW(x): m[x] = 1
    return m
MK = reachmask(rK)
P4re = bytearray(1 if (PROV[x] or (MK[x] and not RB[x])) else 0 for x in range(HI))
for s, e in I12:
    for x in range(s, e): P4re[x] = 0
assert bytes(P4re) == bytes(P4), "folded descent does not reproduce final4_proven_mask.bin"
say("folded descent reproduces final4 proven (%d) in %.0fs" % (sum(P4re), time.time() - t0))

D9.FNSEED.clear()
r0, S0 = run_folded(COMBINED)
D9.FNSEED.update(FNSEED_ALL)
M0 = reachmask(r0)
fo = [x for x in range(HI) if P4[x] and not M0[x] and MK[x]]
say("no-fnindex reach: proven&~reach0&reachK =", len(fo), "B; matches tsv:", set(fo) == {x for x in range(HI) if FO[x]})
pickle.dump(dict(rK_reached=rK["reached"], rK_pred=rK["pred"], rK_seed=rK["seed"],
                 r0_reached=r0["reached"], r0_seed=r0["seed"]), open(OUTD + "descents.pkl", "wb"))

# ---------------------------------------------------------------- per-run descent attribution
def origin(r, a):
    seen = [];
    while a not in r["seed"] and a in r["pred"] and a not in seen:
        seen.append(a); a = r["pred"][a]
    return a, r["seed"].get(a, "?")
ATT = {}
for s, e, n in MINE:
    seeds_in = sorted(a for a in FNSEED_ALL if s <= a < e)
    root, lab = origin(rK, s)
    heads = sorted(a for a in rK["reached"] if s <= a < e)
    ATT[s] = dict(seeds_in=seeds_in, root=root, lab=lab, heads=heads)

# leave-out: remove only the fnindex seeds lying inside this run
LO = {}
for s, e, n in MINE:
    seeds_in = ATT[s]["seeds_in"]
    if not seeds_in: LO[s] = None; continue
    for a in seeds_in: D9.FNSEED.pop(a, None)
    rr, _ = run_folded(COMBINED)
    D9.FNSEED.clear(); D9.FNSEED.update(FNSEED_ALL)
    mm = reachmask(rr)
    kept = sum(mm[s:e]); lost_total = sum(1 for x in range(HI) if MK[x] and not mm[x])
    lost_runs = collections.Counter(runof(x) for x in range(HI) if MK[x] and not mm[x])
    still = None
    if kept:
        root2, lab2 = origin(rr, min(a for a in rr["reached"] if s <= a < e))
        still = (root2, lab2)
    LO[s] = dict(kept=kept, lost_total=lost_total, lost_runs=dict(lost_runs), still=still)
    say("leave-out %06X (%d seeds): run bytes kept %d/%d, total lost %d, lost by run %s%s" % (
        s, len(seeds_in), kept, n, lost_total, {("%06X" % k if k is not None else "none"): v for k, v in lost_runs.items()},
        "" if not still else " still-reached via %06X <- %s" % still))

# ---------------------------------------------------------------- static whole-image inbound scan
SCOPE = (0, HI)   # 0x000000-0x07B753 incl. closed window (decode only)
def cls(a):
    if INW(a): return "window"
    if FO[a]: return "fnonly:%06X" % runof(a)
    if M0[a]: return "base"
    if P4[a]: return "proven-unreached"
    return "unproven"
FLOWIN = collections.defaultdict(list)    # run -> [(src, text, kind, target, srcclass)]
IMMIN = collections.defaultdict(list)
mine_rng = [(s, e) for s, e, n in MINE]
def inmine(v):
    for s, e in mine_rng:
        if s <= v < e: return s
    return None
IMM = re.compile(r"#(0x[0-9a-f]+)")
for a in range(0, HI, 2):
    n, t, k, tg = flow(a)
    if not n: continue
    for v in tg:
        r_ = inmine(v)
        if r_ is not None and not (r_ <= a < [e for s, e in mine_rng if s == r_][0]):
            FLOWIN[r_].append((a, t, k, v, cls(a)))
    for m in IMM.finditer(t):
        v = int(m.group(1), 16)
        r_ = inmine(v)
        if r_ is not None: IMMIN[r_].append((a, t, v, cls(a)))
# BE32 / BE24 raw scans at every byte offset of the whole 1 MB image
BE32IN = collections.defaultdict(list); J24 = collections.defaultdict(list); W16 = collections.defaultdict(list)
for o in range(0, len(IMG) - 3):
    v = int.from_bytes(IMG[o:o + 4], "big")
    if v < 0x50000 and v >= 0x30000:
        r_ = inmine(v)
        if r_ is not None: BE32IN[r_].append((o, v, cls(o) if o < HI else "beyond-content"))
    if IMG[o] in (0x5A, 0x5E):
        v = int.from_bytes(IMG[o + 1:o + 4], "big"); r_ = inmine(v)
        if r_ is not None: J24[r_].append((o, IMG[o:o + 4].hex(), cls(o) if o < HI else "beyond-content"))
# split 16-bit construction: mov.w #hi,eN ... mov.w #lo,rN (or reverse) within 4 insns
MW = re.compile(r"^mov\.w #(0x[0-9a-f]+),([er])(\d)$")
for a in range(0, HI, 2):
    n, t = bu(a)
    m = MW.match(t) if n else None
    if not m: continue
    x = a + n
    for _ in range(4):
        n2, t2 = bu(x)
        if not n2: break
        m2 = MW.match(t2)
        if m2 and m2.group(3) == m.group(3) and m2.group(2) != m.group(2):
            hi_, lo_ = (m, m2) if m.group(2) == "e" else (m2, m)
            v = (int(hi_.group(1), 16) << 16) | int(lo_.group(1), 16)
            r_ = inmine(v)
            if r_ is not None: W16[r_].append((a, t + " ; " + t2, v, cls(a)))
            break
        x += n2
# fall-through predecessor and preceding instruction
def preceding(s):
    out = []
    for a in range(max(0, s - 10), s, 2):
        n, t, k, tg = flow(a)
        if n and a + n == s: out.append((a, t, k, cls(a)))
    return out
# @@aa:8 memory-indirect sites
MI = re.compile(r"^(jmp|jsr) @@(\d+) \((0x[0-9a-f]+)\)$")
MIIN = collections.defaultdict(list)
for a in range(0, HI, 2):
    n, t = bu(a)
    m = MI.match(t) if n else None
    if m:
        v = be32(int(m.group(3), 16)) & 0xFFFFFF; r_ = inmine(v)
        if r_ is not None: MIIN[r_].append((a, t, v, cls(a)))
# vector table 0x0-0x3FF entries
VECIN = collections.defaultdict(list)
for i in range(256):
    v = be32(4 * i) & 0xFFFFFF; r_ = inmine(v)
    if r_ is not None: VECIN[r_].append((i, v))
# indirect-site census (doc 60) targets
CBIN = collections.defaultdict(list)
for ln in open(ROOT + "ida/out/indirect-cb/targets.tsv", encoding="utf-8").read().splitlines()[1:]:
    c = ln.split("\t"); v = int(c[0], 16); r_ = inmine(v)
    if r_ is not None: CBIN[r_].append(ln)

res = dict(MINE=MINE, ATT=ATT, LO=LO, FLOWIN=dict(FLOWIN), IMMIN=dict(IMMIN), BE32IN=dict(BE32IN), J24=dict(J24),
           W16=dict(W16), MIIN=dict(MIIN), VECIN=dict(VECIN), CBIN=dict(CBIN),
           PRE={s: preceding(s) for s, e, n in MINE})
pickle.dump(res, open(OUTD + "edges.pkl", "wb"))
for s, e, n in MINE:
    say("== %06X-%06X %d  seeds_in=%s root=%06X <- %s" % (s, e, n, ",".join("%06X" % a for a in ATT[s]["seeds_in"]), ATT[s]["root"], ATT[s]["lab"]))
    for p in res["PRE"][s]: say("   pre  %06X %-40s %s %s" % p)
    for x in FLOWIN.get(s, []): say("   flow %06X %-40s %s ->%06X %s" % x)
    for x in IMMIN.get(s, []): say("   imm  %06X %-40s ->%06X %s" % x)
    for x in BE32IN.get(s, []): say("   be32 @%06X =%06X %s" % x)
    for x in J24.get(s, []): say("   j24  @%06X %s %s" % x)
    for x in W16.get(s, []): say("   w16  %06X %s ->%06X %s" % x)
    for x in MIIN.get(s, []): say("   @@   %06X %s ->%06X %s" % x)
    for x in VECIN.get(s, []): say("   vec  %d ->%06X" % x)
    for x in CBIN.get(s, []): say("   cb   %s" % x)
say("done %.0fs" % (time.time() - t0))
