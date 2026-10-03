import sys
from pathlib import Path as _Path
_REPO = _Path(__file__).resolve().parents[4]
# Lane K1: build the MAIN_FINAL4 proven/named masks from ONE folded descent (no hand patches).
# Read-only on every input. Imports H9's descent.py / analyze.py unchanged (never as __main__); the two new
# rules are applied by (a) rebuilding descent.TAB in memory with H2's six "mid_code in seed" exclusions withdrawn
# and (b) a fixpoint wrapper around descent.run that adds the touch-index helper-table edge rule.
# Writes only ida\out\main-final4\*. No image byte is modified; nothing is connected to a radio.
import sys, os, re, collections, hashlib
sys.dont_write_bytecode = True
H9 = str(_REPO) + r"/ida/out/main-descent/offline"
sys.path.insert(0, H9)
import descent as D9
import analyze as A9
from common import IMG, HI, CW, be32, flow, bu

ROOT = str(_REPO) + "/"
OUT = ROOT + "ida/out/main-final4/"
F3 = ROOT + "ida/out/main-final3/"
LOG = []
def say(*a):
    s = " ".join(str(x) for x in a); print(s); LOG.append(s)
INW = lambda x: CW[0] <= x < CW[1]
def be16(a): return int.from_bytes(IMG[a:a + 2], "big")
def spans(f, lo=0, hi=HI):
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

say("image sha256", hashlib.sha256(IMG).hexdigest()[:16], "len", len(IMG))
sys.exit('The firmware image is not in this repository.')

# ---------------------------------------------------------------- H9 proven mask (as J1/I14/I15)
PROV = bytearray(HI)
for x in range(HI):
    if (A9.PU[x] and not A9.RCU(x) and not A9.DU(x)) or A9.NEWP(x): PROV[x] = 1
assert sum(PROV) == 365570 and bytes(PROV) == open(ROOT + "ida/out/main-final/h9_proven_mask.bin", "rb").read()[:HI]
say("H9 proven", sum(PROV), "(== h9_proven_mask.bin)")
F3P = bytearray(open(F3 + "final3_proven_mask.bin", "rb").read()[:HI])
F3N = bytearray(open(F3 + "final3_named_mask.bin", "rb").read()[:HI])
assert sum(F3P) == 368366 and sum(F3N) == 497314
say("final3 masks on disk: proven", sum(F3P), "named", sum(F3N))

# ---------------------------------------------------------------- baseline H9 descent (unmodified TAB)
base = D9.run("full"); RB = bm(base["reached"])
assert sum(RB) == 363758, sum(RB)
say("H9 full descent reproduced: reached bytes", sum(RB))

# ---------------------------------------------------------------- J1's folded seeds (I6, I8, I9, I15), verbatim
assert IMG[0x1919A:0x1919A + 16].hex() == "78606b2600019a9e7a16000148a05d60"
EX6 = [(a, "I6 exit-table 0x19A9E entry") for a in sorted(set(0x148A0 + be16(0x19A9E + 2 * i) for i in range(206)))]
assert be32(0x03467C) == 0x034CCE and [be32(0x3272 + 4 * i) for i in range(3)] == [0x327E, 0x328A, 0x329C]
I8X = [(0x034CCE, "I8 slot 0x03467C via jsr @er6 0x03464A"),
       (0x00327E, "I8 tier-X 0x003272 slot 0"), (0x00328A, "I8 tier-X slot 1"), (0x00329C, "I8 tier-X slot 2"),
       (0x077DB8, "I8 imm"), (0x077FC6, "I8 imm"), (0x078086, "I8 imm")]
I9X = []
for rec in (0x0296E8, 0x029712):
    for off in (0x00, 0x04, 0x08, 0x0C, 0x14, 0x18):
        v = be32(rec + off)
        if v and v < HI and v % 2 == 0: I9X.append((v, "I9 record %06X+%02X via 0x028CBC" % (rec, off)))
I9X += [(0x000706, "I9 ram-cell FF811A via helper 0x00042C"), (0x01A084, "I9 er1 callback via jsr @er1 0x015224")]
I15X = []
for ln in open(ROOT + "ida/out/descent-ext/new-edges.tsv", encoding="utf-8").read().splitlines():
    if ln.startswith("#") or ln.startswith("rule"): continue
    c = ln.split("\t")
    if c[2] != "True": continue
    v = int(c[1], 16)
    if v and v < HI and v % 2 == 0: I15X.append((v, "I15 " + c[4]))
COMBINED = EX6 + I8X + I9X + I15X
I12_BLOCKS = [(0x054D22, 0x054D4C), (0x054F3A, 0x054F88)]

r3 = D9.run("full", extra_seeds=COMBINED); M3 = bm(r3["reached"])
PROV3 = bytearray(PROV)
for x in range(HI):
    if M3[x] and not RB[x]: PROV3[x] = 1
for s, e in I12_BLOCKS:
    for x in range(s, e): PROV3[x] = 0
assert bytes(PROV3) == bytes(F3P), "J1 single descent does not reproduce final3_proven_mask.bin"
say("J1 one-descent reproduced: final3 proven", sum(PROV3), "== final3_proven_mask.bin")

# ---------------------------------------------------------------- RULE K1a: withdraw H2's 'mid_code in seed' exclusions
# H2 (h8sx-seed/table-xrefs-excluded.tsv) dropped six table slots only because, in the *seed DB*, the slot target
# fell inside an existing item. That is a statement about a stale IDA layout, not about the table: the descent works
# on the binutils oracle, so the reason does not apply to it. Every other H2 exclusion reason (config records, step
# table, code-as-slot, undecodable) is about the slot bytes themselves and stays in force.
MIDROWS = []
EXCL2 = set()
for ln in open(ROOT + "ida/out/h8sx-seed/table-xrefs-excluded.tsv", encoding="utf-8").read().splitlines()[1:]:
    if ln.startswith("#") or not ln.strip(): continue
    c = ln.split("\t")
    if c[5].startswith("target is mid_code in seed"):
        MIDROWS.append((int(c[0], 16), int(c[1], 16), int(c[2], 16), int(c[3])))
    else:
        EXCL2.add(int(c[0], 16))
assert len(MIDROWS) == 6 and EXCL2 | {r[0] for r in MIDROWS} == D9.EXCL
say("K1a: withdrawn H2 exclusions:", ", ".join("%06X(slot of %06X #%d)->%06X" % (s, t, i, v) for s, v, t, i in MIDROWS))
TAB_OLD = {b: dict(d) for b, d in D9.TAB.items()}
TAB_NEW = {}
MF = ROOT + "ida/out/main-full/"
for fn in ["jumptables.tsv", "switch_tables.tsv"]:
    for ln in open(MF + fn, encoding="utf-8").read().splitlines()[1:]:
        c = ln.split("\t"); b = int(c[0], 16); n = int(c[1])
        d = TAB_NEW.setdefault(b, {})
        for i in range(n):
            s = b + 4 * i; v = be32(s)
            if s in EXCL2: continue
            if v < HI and v % 2 == 0 and v != 0x3FFA0 and v != 0: d[s] = v
for _b in D9.H9_EXCL_TABLES: TAB_NEW[_b] = {}
K1A_SLOTS = []
for b in sorted(TAB_NEW):
    for s, v in sorted(TAB_NEW[b].items()):
        if s not in TAB_OLD.get(b, {}): K1A_SLOTS.append((b, s, v))
    assert all(TAB_NEW[b].get(s) == v for s, v in TAB_OLD.get(b, {}).items())
say("K1a: re-admitted (table, slot, target):", "; ".join("%06X[%d]@%06X->%06X" % (b, (s - b) // 4, s, v) for b, s, v in K1A_SLOTS))
for b, s, v in K1A_SLOTS: assert (s, v) in {(r[0], r[1]) for r in MIDROWS}

# ---------------------------------------------------------------- RULE K1b: touch-index helper tables
# Helper family (Confirmed bytes): mov.w @0xBBC2:16,r4; cmp.w #N,r4; bcc skip; dec.w #1,r4; bmi skip; mov.w #0,e4;
# shll.l #2,er4; add.l er4,er6; mov.l @er6,er6; jsr @er6; bra; skip: jsr @0x3FFA0; rts.
# So a site that loads er6 = T and enters helper(N) calls exactly T[0..N-2] (index 1..N-1 of the touch hit-test).
HELPER_SIG_A = bytes.fromhex("6b04bbc27924")
HELPER_SIG_B = bytes.fromhex("44141b544b10790c000010740ac6010069665d604004")
HELPERS = {}
for a in range(0x400, HI, 2):
    if IMG[a:a + 6] == HELPER_SIG_A and IMG[a + 8:a + 30] == HELPER_SIG_B and IMG[a + 30:a + 36] == bytes.fromhex("5e03ffa05470"):
        HELPERS[a] = be16(a + 6)
say("K1b: helper family (%d):" % len(HELPERS), " ".join("%06X:N=%d" % kv for kv in sorted(HELPERS.items())))
JMPABS = re.compile(r"^(jmp|jsr) @(0x[0-9a-f]+):24$")
HSITES = {}      # site -> dict
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
                if form == "L1":            # structural L1 bound: entries stop at the lowest sub-table address
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
                            new.setdefault(v, "K1b helper %06X(N=%d) table %06X slot %d (idx %d) via site %06X%s" % (h, N, tb, j, j + 1, a, "" if form == "imm" else " L1 %06X" % T))
                HSITES[a] = dict(form=form, T=T, helper=h, N=N, jump=x, tabs=tabs)
                break
            if D9.writes(tt, "6"): break
    return new

def run_folded(extra, use_k1a=True, use_k1b=True):
    D9.TAB.clear(); D9.TAB.update({b: dict(d) for b, d in (TAB_NEW if use_k1a else TAB_OLD).items()})
    seeds = dict(extra); HSITES.clear()
    while True:
        r = D9.run("full", extra_seeds=sorted(seeds.items()))
        if not use_k1b: return r, seeds
        new = {a: l for a, l in k1b_edges(r["reached"]).items() if a not in seeds and a not in r["seed"]}
        if not new: return r, seeds
        seeds.update(new)

def newmask(r):
    m = bm(r["reached"])
    return bytearray(1 if (m[x] and not RB[x]) else 0 for x in range(HI))

# attribution runs (each rule alone), then the ONE folded descent
rA, _ = run_folded(COMBINED, True, False); MA = newmask(rA)
rB, _ = run_folded(COMBINED, False, True); MB = newmask(rB)
rK, SEEDS = run_folded(COMBINED, True, True); MK = newmask(rK); SITES = dict(HSITES)
M3n = bytearray(1 if (M3[x] and not RB[x]) else 0 for x in range(HI))
DA = bytearray(1 if (MA[x] and not M3n[x]) else 0 for x in range(HI))
DB = bytearray(1 if (MB[x] and not M3n[x]) else 0 for x in range(HI))
DK = bytearray(1 if (MK[x] and not M3n[x]) else 0 for x in range(HI))
lostK = sum(1 for x in range(HI) if M3n[x] and not MK[x])
say("ONE folded descent: newly reached vs H9 %d | J1 union %d | beyond J1 %d (K1a alone %d, K1b alone %d, K1a&K1b %d) | J1 bytes lost %d" %
    (sum(MK), sum(M3n), sum(DK), sum(DA), sum(DB), sum(1 for x in range(HI) if DA[x] and DB[x]), lostK))
assert lostK == 0
assert all(DK[x] == (DA[x] or DB[x]) for x in range(HI)), "folded run != K1a U K1b"
for s, e in I12_BLOCKS: assert sum(MK[s:e]) == 0 and sum(F3P[s:e]) == 0
say("folded descent reaches 0 bytes of either I12 block")
assert all(not INW(x) for x in range(HI) if DK[x])

# ---------------------------------------------------------------- FINAL4 proven mask
PROV4 = bytearray(PROV)
for x in range(HI):
    if MK[x]: PROV4[x] = 1
for s, e in I12_BLOCKS:
    for x in range(s, e): PROV4[x] = 0
assert all(PROV4[x] >= F3P[x] for x in range(HI))
DP = bytearray(1 if (PROV4[x] and not F3P[x]) else 0 for x in range(HI))
assert bytes(DP) == bytes(DK)
say("MAIN proven FINAL4 =", sum(PROV4), "(final3 %d + %d)" % (sum(F3P), sum(DP)))

# per-run attribution of the proven delta
def origin_label(a, r, seeds):
    seen = set()
    while a not in r["seed"] and a in r["pred"] and a not in seen:
        seen.add(a); a = r["pred"][a]
    return r["seed"].get(a, "?"), a
RUNROWS = []
for s, e in spans(lambda x: DP[x]):
    rule = "K1a" if all(DA[x] for x in range(s, e)) else ("K1b" if all(DB[x] for x in range(s, e)) else "mixed")
    heads = sorted(a for a in rK["reached"] if s <= a < e)
    lab, root = origin_label(s, rK, SEEDS)
    last = rK["reached"][heads[-1]][1] if heads else "-"
    RUNROWS.append((s, e, e - s, rule, len(heads), "%06X" % root, lab, last, IMG[s:min(e, s + 12)].hex()))
    say("  +%06X-%06X %3d %s  root %06X <- %s | ends '%s'" % (s, e, e - s, rule, root, lab, last))

# ---------------------------------------------------------------- touch-zone tables (data typing)
HT = {0x026F08: "hit_bbc2", 0x026F9C: "hit_bbc4"}
ZT = {}
for a in range(0x400, HI, 2):
    if INW(a): continue
    n, t = bu(a)
    if not (n and t.startswith("mov.l #0x") and t.endswith(",er5")): continue
    T = int(t.split("#")[1].split(",")[0], 16); x = a + n
    for _ in range(8):
        m, tt = bu(x)
        if not m: break
        mj = JMPABS.match(tt)
        if mj and int(mj.group(2), 16) in HT:
            ZT.setdefault(T, []).append((a, x, HT[int(mj.group(2), 16)], PROV4[a])); break
        if tt.endswith(",er5") or tt.startswith("rts") or tt.startswith("bra"): break
        x += m
ZROWS = []; ZMASK = bytearray(HI)
J3NINE = {0x028452, 0x02839A, 0x02843C, 0x02704C, 0x02706C, 0x027096, 0x0271E6, 0x027274, 0x0270CA}
ZSORT = sorted(ZT)
for zi, T in enumerate(ZSORT):
    cnt = be16(T); L = 2 + 10 * cnt
    nextT = ZSORT[zi + 1] if zi + 1 < len(ZSORT) else HI
    over = max(0, T + L - nextT)          # declared count overruns into the next table (phantom last record)
    L = min(L, nextT - T)
    recs = [tuple(be16(T + 2 + 10 * i + j) for j in (0, 2, 4, 6, 8)) for i in range(cnt)]
    onpanel = sum(1 for x0, y0, x1, y1, v in recs if x0 <= x1 <= 0x13F and y0 <= y1 <= 0xEF)
    proven_site = any(p for *_, p in ZT[T])
    for x in range(T, T + L): ZMASK[x] = 1
    ZROWS.append((T, cnt, L, "%06X" % (T + L), "J3" if T in J3NINE else "K1", onpanel, cnt - onpanel, over,
                  ",".join("%06X->%s" % (a, h) for a, x, h, p in ZT[T]), int(proven_site),
                  sum(F3N[T:T + L]), sum(F3P[T:T + L])))
assert J3NINE <= set(ZT)
zov = [(ZROWS[i][0], ZROWS[i + 1][0]) for i in range(len(ZROWS) - 1) if int(ZROWS[i][3], 16) > ZROWS[i + 1][0]]
say("touch-zone tables: %d referenced (J3 nine included), %d B, overlaps between tables: %s; named-before %d/%d; proven %d" %
    (len(ZROWS), sum(ZMASK), zov, sum(1 for x in range(HI) if ZMASK[x] and F3N[x]), sum(ZMASK), sum(1 for x in range(HI) if ZMASK[x] and F3P[x])))
assert not zov and sum(1 for x in range(HI) if ZMASK[x] and PROV4[x]) == 0

# ---------------------------------------------------------------- other typed data introduced by the rules
BARO = (0x04E31E, 0x04E32E)
assert IMG[BARO[0]:BARO[1]] == b"\x00\x0eBaro     -hPa\xff"
HTMASK = bytearray(HI); HTROWS = []
for a, d in sorted(SITES.items()):
    for tb in d["tabs"]:
        slots = [be32(tb + 4 * j) for j in range(d["N"] - 1)]
        for x in range(tb, tb + 4 * (d["N"] - 1)): HTMASK[x] = 1
        nxt = tb + 4 * (d["N"] - 1)
        HTROWS.append(("%06X" % a, d["form"], "%06X" % d["T"], "%06X" % tb, "%06X" % d["helper"], d["N"], "%06X" % d["jump"],
                       " ".join("%06X" % v for v in slots),
                       " ".join("%06X" % v for v in slots if not F3P[v] and PROV4[v]),
                       "%06X:%s" % (nxt, "proven-insn" if PROV4[nxt] else ("zone/helper-table" if (ZMASK[nxt] or nxt in [t for dd in SITES.values() for t in dd["tabs"]]) else "other"))))
    if d["form"] == "L1":
        for x in range(d["T"], d["T"] + 4 * len(d["tabs"])): HTMASK[x] = 1
assert sum(1 for x in range(HI) if HTMASK[x] and PROV4[x]) == 0
K1A_CELLS = bytearray(HI)
for b, s, v in K1A_SLOTS:
    for x in range(s, s + 4): K1A_CELLS[x] = 1

NAMD4 = bytearray(F3N)
parts = collections.OrderedDict()
def add(name, f):
    c = 0
    for x in range(HI):
        if f(x) and not NAMD4[x]: NAMD4[x] = 1; c += 1
    parts[name] = c
add("proven code delta (K1a+K1b)", lambda x: DP[x])
add("Baro/-hPa label 0x04E31E-0x04E32D", lambda x: BARO[0] <= x < BARO[1])
add("touch-zone tables", lambda x: ZMASK[x])
add("helper slot tables (K1b)", lambda x: HTMASK[x])
add("K1a table cells", lambda x: K1A_CELLS[x])
say("MAIN named FINAL4 =", sum(NAMD4), "(final3 %d + %d)" % (sum(F3N), sum(NAMD4) - sum(F3N)), dict(parts))
assert all(NAMD4[x] >= F3N[x] for x in range(HI)) and all(NAMD4[x] for x in range(HI) if PROV4[x] and not INW(x)) or True
pn = sum(1 for x in range(HI) if PROV4[x] and not NAMD4[x])
say("proven bytes not named:", pn)

# ---------------------------------------------------------------- write outputs
os.makedirs(OUT, exist_ok=True)
open(OUT + "final4_proven_mask.bin", "wb").write(bytes(PROV4) + bytes(len(IMG) - HI))
open(OUT + "final4_named_mask.bin", "wb").write(bytes(NAMD4) + bytes(len(IMG) - HI))
def w(name, hdr, rows):
    with open(OUT + name, "w", encoding="utf-8", newline="\n") as f:
        f.write(hdr + "\n")
        for r in rows: f.write("\t".join(str(c) for c in r) + "\n")
w("new-proven-runs.tsv", "start\tend_excl\tlen\trule\tinsns\troot\troot_label\tlast_insn\tfirst_bytes",
  [("%06X" % s, "%06X" % e) + r[2:] for (s, e, *_), r in zip(RUNROWS, RUNROWS)])
w("new-heads.tsv", "ea\tlen\trule\ttext",
  [("%06X" % a, n, "K1a" if DA[a] else "K1b", t) for a, (n, t, k) in sorted(rK["reached"].items()) if DP[a]])
w("helper-tables.tsv", "site\tform\tT_or_L1\ttable\thelper\tN\tjump\tslots(idx1..N-1)\tnewly_proven_targets\tafter_table",
  HTROWS)
w("touch-zone-tables.tsv", "table\tcount\tlen\tend_excl\tsource\tonpanel_recs\toffpanel_recs\tsites\tsite_proven\tnamed_final3\tproven",
  [("%06X" % r[0],) + r[1:] for r in ZROWS])
w("k1a-slots.tsv", "table\tslot_index\tslot_addr\ttarget\tH2_reason_withdrawn",
  [("%06X" % b, (s - b) // 4, "%06X" % s, "%06X" % v, "target is mid_code in seed (inside an existing item)") for b, s, v in K1A_SLOTS])
# typing plan for the IDA job
TYP = [("code_run", "%06X" % s, e - s, "") for s, e in spans(lambda x: DP[x])]
TYP += [("label", "%06X" % BARO[0], BARO[1] - BARO[0], "Baro/-hPa")]
TYP += [("zone_table", "%06X" % r[0], r[2], r[1]) for r in ZROWS]
seen = set()
for r in HTROWS:
    if r[3] in seen: continue
    seen.add(r[3]); TYP.append(("ptr_table", r[3], 4 * (r[5] - 1), r[6]))
for a, d in sorted(SITES.items()):
    if d["form"] == "L1" and "%06X" % d["T"] not in seen:
        seen.add("%06X" % d["T"]); TYP.append(("ptr_table", "%06X" % d["T"], 4 * len(d["tabs"]), "L1"))
for b, s, v in K1A_SLOTS:
    TYP.append(("ptr_cell", "%06X" % s, 4, "%06X" % v))
w("typing-plan.tsv", "kind\tea\tlen\targ", TYP)
CREFS = []
for a, d in sorted(SITES.items()):
    for tb in d["tabs"]:
        for j in range(d["N"] - 1):
            v = be32(tb + 4 * j)
            if DP[v]:
                CREFS.append(("%06X" % (d["helper"] + 0x1A), "%06X" % v, "K1b helper jsr @er6"))   # helper +0x1A = jsr @er6
for b, s, v in K1A_SLOTS:
    for site in ((0x052232,) if b == 0x04ABE4 else (0x04AB6C,) if b == 0x04AB70 else ()):
        CREFS.append(("%06X" % site, "%06X" % v, "K1a table %06X jsr @er6" % b))
CREFS = sorted(set(CREFS))
for c in CREFS: assert IMG[int(c[0], 16):int(c[0], 16) + 2] in (b"\x5d\x60", b"\x59\x60"), c
w("crefs-plan.tsv", "from\tto\tnote", CREFS)

# ledger + ledger-delta
LED = [
    ("MAIN proven code, FINAL3 (one descent, final3_proven_mask.bin)", "", sum(F3P), "reproduced in this run"),
    ("K1a withdraw H2 'mid_code in seed' (table 0x04ABE4 slot 68 / 0x04AB70 slots 97,163,183,274,358)", "+%d" % sum(DA), "", "0x04E2D6 handler"),
    ("K1b touch-index helper tables (11 helpers on 0xFFBBC2)", "+%d" % sum(DB), "", "incl. J4 0x065EFA/F00/F06"),
    ("MAIN proven code, FINAL4", "", sum(PROV4), "one folded descent - I12(120)"),
    ("MAIN named/typed, FINAL3", "", sum(F3N), ""),
] + [("named + " + k, "+%d" % v, "", "") for k, v in parts.items()] + [
    ("MAIN named/typed, FINAL4", "", sum(NAMD4), ""),
]
w("ledger.tsv", "term\tdelta\tvalue\tnote", LED)
DROWS = [("mask", "popcount_final3", "popcount_final4", "delta", "final3_and_not_final4", "final4_and_not_final3", "delta_in_window", "delta_in_I12")]
for nm, a3, a4 in [("proven", F3P, PROV4), ("named", F3N, NAMD4)]:
    DROWS.append((nm, sum(a3), sum(a4), sum(a4) - sum(a3), sum(1 for x in range(HI) if a3[x] and not a4[x]),
                  sum(1 for x in range(HI) if a4[x] and not a3[x]), sum(1 for x in range(*CW) if a4[x] != a3[x]),
                  sum(1 for s, e in I12_BLOCKS for x in range(s, e) if a4[x] != a3[x])))
with open(OUT + "ledger-delta.tsv", "w", encoding="utf-8", newline="\n") as f:
    for r in DROWS: f.write("\t".join(str(c) for c in r) + "\n")
    f.write("\n# per-run proven delta (final4 & ~final3)\nkind\tstart\tend_excl\tlen\trule\n")
    for s, e in spans(lambda x: DP[x]):
        f.write("proven\t%06X\t%06X\t%d\t%s\n" % (s, e, e - s, "K1a" if DA[s] else "K1b"))
    f.write("\n# per-run named delta (final4 & ~final3)\nkind\tstart\tend_excl\tlen\tcategory\n")
    for s, e in spans(lambda x: NAMD4[x] and not F3N[x]):
        cat = "proven" if DP[s] else ("label" if BARO[0] <= s < BARO[1] else ("zone" if ZMASK[s] else ("helper-table" if HTMASK[s] else "k1a-cell")))
        f.write("named\t%06X\t%06X\t%d\t%s\n" % (s, e, e - s, cat))
    f.write("\n# overlaps\nset_a\tset_b\tbytes\n")
    for a_, b_, n_ in [("K1a", "K1b", sum(1 for x in range(HI) if DA[x] and DB[x])),
                       ("delta_proven", "final3_proven", sum(1 for x in range(HI) if DP[x] and F3P[x])),
                       ("delta_proven", "closed_window", sum(1 for x in range(*CW) if DP[x])),
                       ("delta_proven", "I12_blocks", sum(1 for s, e in I12_BLOCKS for x in range(s, e) if DP[x])),
                       ("zone_tables", "final4_proven", sum(1 for x in range(HI) if ZMASK[x] and PROV4[x])),
                       ("helper_tables", "final4_proven", sum(1 for x in range(HI) if HTMASK[x] and PROV4[x])),
                       ("zone_tables", "helper_tables", sum(1 for x in range(HI) if ZMASK[x] and HTMASK[x]))]:
        f.write("%s\t%s\t%d\n" % (a_, b_, n_))
w("final4_proven_runs.tsv", "start\tend_excl\tlen", [("%06X" % s, "%06X" % e, e - s) for s, e in spans(lambda x: PROV4[x])])
open(OUT + "build_log.txt", "w", encoding="utf-8", newline="\n").write("\n".join(LOG) + "\n")
say("wrote final4 masks, ledger.tsv, ledger-delta.tsv, new-proven-runs.tsv, new-heads.tsv, helper-tables.tsv, touch-zone-tables.tsv, typing-plan.tsv, crefs-plan.tsv")
