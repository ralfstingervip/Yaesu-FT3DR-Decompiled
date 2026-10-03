# Lane I15 - consolidated, reproducible offline driver.
# Extends H9's strict proven descent with two missed edge classes and writes ida/out/descent-ext/*.tsv.
#   Rule A  helper / argument-passed stores of a code address into a RAM function-pointer cell
#   Rule B  record-field callbacks: a dispatcher that calls through @(d,ERn) with ERn an incoming
#           ROM-record pointer; the field at displacement d is the handler address.
# Read-only on every input. Imports H9's own descent.py / analyze.py unchanged (not run as __main__,
# so they write nothing). No image byte is modified; nothing is connected to a radio. The closed
# window 0x078106-0x07B753 is excluded from every byte count (edges into it stop at the edge).
# Model: claude-opus-5-5.
from pathlib import Path as _Path
_REPO_S = _Path(__file__).resolve().parents[4].as_posix()
import sys, os, re, pickle, collections
sys.dont_write_bytecode = True
H9 = (_REPO_S + "/ida/out/main-descent/offline")
sys.path.insert(0, H9)
import descent as D9
import analyze as A9                     # H9 module; module-level code rebuilds all masks, writes nothing on import
from common import IMG, HI, CW, be32, flow
OUT = (_REPO_S + "/ida/out/")
DEST = OUT + "descent-ext/"

# ---------------------------------------------------------------- H9 masks (reproduced exactly, as lane I9 did)
PROV = bytearray(HI); NAMD = bytearray(HI); LEAVE = bytearray(HI)
for s, e, ad, c, h in A9.demoted:
    for x in range(s, e):
        if A9.NAMED[x] and (A9.B[x] if ad == "RC" else True):
            other = (A9.A[x] or A9.E[x] or A9.F[x] or A9.HH[x] or (ad == "D" and A9.B[x]))
            if A9.leaves(s, e, ad, c) and not other: LEAVE[x] = 1
for x in range(HI):
    if (A9.PU[x] and not A9.RCU(x) and not A9.DU(x)) or A9.NEWP(x): PROV[x] = 1
    if (A9.NAMED[x] and not LEAVE[x]) or (A9.RM[x] and not A9.NAMED[x]): NAMD[x] = 1
NAMED = NAMD
assert sum(PROV) == 365570, sum(PROV)
assert sum(NAMED) == 497139, sum(NAMED)
PERSIST = open(OUT + "main-final/h9_proven_mask.bin", "rb").read()
assert bytes(PROV) == PERSIST, "PROV disagrees with I3 h9_proven_mask.bin"
print("H9 masks reproduced: proven %d  named %d  (== h9_proven_mask.bin)" % (sum(PROV), sum(NAMED)))

INW = lambda x: CW[0] <= x < CW[1]
def bm(r):
    m = bytearray(HI)
    for a, (n, t, k) in r.items():
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

# ---------------------------------------------------------------- baseline descent (H9, byte-equal)
base = D9.run("full");   RB = bm(base["reached"]); Rfull = base["reached"]
strict = D9.run("strict"); SB = bm(strict["reached"]); Rstrict = strict["reached"]
assert sum(RB) == 363758 and sum(SB) == 356820
print("baseline full reach %d  strict reach %d  (byte-equal to H9)" % (sum(RB), sum(SB)))

# function boundaries (I3 MAIN_FINAL)
import bisect
FUN = []
for ln in open(OUT + "main-final/MAIN_FINAL_functions.tsv", encoding="utf-8").read().splitlines()[1:]:
    c = ln.split("\t"); FUN.append((int(c[0], 16), int(c[1], 16)))
FUN.sort(); FST = [f[0] for f in FUN]
def func_of(a):
    i = bisect.bisect_right(FST, a) - 1
    if i >= 0 and FUN[i][0] <= a < FUN[i][1]: return FUN[i]
    return None

STABS = re.compile(r"^mov\.l er(\d),@(0x[0-9a-f]+):(16|32)$")
LDABS = re.compile(r"^mov\.l @(0x[0-9a-f]+):(16|32),er(\d)$")
MOVI  = re.compile(r"^mov\.l #(0x[0-9a-f]+),er(\d)$")
IJ    = re.compile(r"^(jmp|jsr) @er(\d)$")
FLD   = re.compile(r"^mov\.l @\((0x[0-9a-f]+):(16|32),er(\d)\),er(\d)$")
def absx(v, w): v = int(v, 16); return (v | 0xFF0000) if (w == "16" and v >= 0x8000) else v
def writes(t, r): return re.search(r",e?r%s[lh]?$" % r, t) is not None or re.search(r",er%s$" % r, t) is not None
def iscode(v): return 0x400 <= v < HI and v % 2 == 0
R = Rfull; AD = sorted(R)
def insns_in(f):
    s, e = f; i = bisect.bisect_left(AD, s); out = []
    while i < len(AD) and AD[i] < e: out.append(AD[i]); i += 1
    return out

# call graph over reached insns
callers = collections.defaultdict(set)
for a, (n, t, k) in R.items():
    _, _, kk, tg = flow(a)
    if kk == "call":
        for x in tg: callers[x].add(a)
    elif kk == "stop" and tg:
        for x in tg:
            if func_of(x) and func_of(x)[0] == x: callers[x].add(a)

# ---------------------------------------------------------------- RULE A
cells = collections.defaultdict(list)          # fn-ptr RAM cell X -> [loader site,...]
for a, (n, t, k) in R.items():
    m = LDABS.match(t)
    if not m: continue
    X = absx(m.group(1), m.group(2)); reg = m.group(3); x = a + n; c = 0
    while c < 4 and x in R:
        tt = R[x][1]; mj = IJ.match(tt)
        if mj and mj.group(2) == reg: cells[X].append(a); break
        if writes(tt, reg) or R[x][2] in ("stop", "stops"): break
        x += R[x][0]; c += 1
cells = dict(cells)

def set_by_imm_local(f, before, reg):
    for a in reversed([a for a in insns_in(f) if a < before]):
        t = R[a][1]; m = MOVI.match(t)
        if m and m.group(2) == reg: return int(m.group(1), 16), a
        if writes(t, reg): return None
    return None                                # reg live-in to f

def trace(fn, reg, depth, chain):
    res = []
    for c in callers.get(fn[0], ()):
        cf = func_of(c)
        if not cf: continue
        loc = set_by_imm_local(cf, c, reg)
        if loc: res.append((loc[0], loc[1], chain + ["%06X call ->%06X" % (c, fn[0])]))
        elif depth < 2: res += trace(cf, reg, depth + 1, chain + ["%06X ->%06X (reg passthru)" % (c, fn[0])])
    return res

ruleA = []; seenA = set()
for X, loaders in cells.items():
    for a, (n, t, k) in R.items():
        ms = STABS.match(t)
        if not (ms and absx(ms.group(2), ms.group(3)) == X): continue
        reg = ms.group(1); f = func_of(a)
        if not f: continue
        if set_by_imm_local(f, a, reg): continue           # H9's same-function immediate rule already covers this
        for imm, site, chain in trace(f, reg, 1, []):        # reg live-in: walk callers 1-2 levels for an immediate
            if iscode(imm) and (X, a, imm) not in seenA:
                seenA.add((X, a, imm))
                ruleA.append((X, a, imm, loaders[0], site, chain))

# ---------------------------------------------------------------- RULE B
fld_addr_reg = collections.defaultdict(set); fld_by_reg = collections.defaultdict(list)
for a, (n, t, k) in R.items():
    m = FLD.match(t)
    if not m: continue
    d = int(m.group(1), 16); basereg = m.group(3); dstreg = m.group(4); x = a + n; c = 0; ok = False
    while c < 3 and x in R:
        tt = R[x][1]; mj = IJ.match(tt)
        if mj and mj.group(2) == dstreg: ok = True; break
        if writes(tt, dstreg) or R[x][2] in ("stop", "stops"): break
        x += R[x][0]; c += 1
    if ok: fld_addr_reg[(a, basereg)].add(d); fld_by_reg[basereg].append(a)

def forward_fields(frm, reg):
    seen = set(); st = [frm]; found = set()
    while st:
        a = st.pop(); c = 0
        while a in R and a not in seen and c < 60:
            seen.add(a); t = R[a][1]
            if (a, reg) in fld_addr_reg:
                for d in fld_addr_reg[(a, reg)]: found.add((a, d))
            if writes(t, reg): break
            n, tx, kk, tg = flow(a)
            if kk == "call": break                           # a call may clobber the caller-saved pointer reg
            for x in tg:
                if x in R and x not in seen: st.append(x)
            if kk in ("stop", "stops"): break
            a = a + n; c += 1
    return found

SENT = 0x3FFA0
ruleB = []; recs = {}
for a, (n, t, k) in R.items():
    m = MOVI.match(t)
    if not m: continue
    reg = m.group(2); rec = int(m.group(1), 16)
    if not (0x400 <= rec < HI) or not fld_by_reg.get(reg): continue
    ff = forward_fields(a + n, reg)
    if not ff: continue
    recs[(rec, reg, a)] = sorted(set(d for _, d in ff))
    for fsite, d in sorted(ff):
        v = be32(rec + d) & 0xFFFFFF
        if iscode(v) and v != SENT:
            ruleB.append((fsite, reg, a, rec, d, v))

# ---------------------------------------------------------------- gate (strict) + extended descent
edges = []                                 # (target, rule, label, gate_ok, note)
for X, store, imm, ld, site, chain in ruleA:
    gs = store in Rstrict and ld in Rstrict and site in Rstrict
    edges.append((imm, "A", "cell %06X store %06X loader %06X imm@%06X [%s]" % (X, store, ld, site, " / ".join(chain)), gs))
for fsite, reg, ca, rec, off, v in ruleB:
    gs = ca in Rstrict and fsite in Rstrict
    edges.append((v, "B", "rec %06X+%02X er%s passer %06X fldsite %06X" % (rec, off, reg, ca, fsite), gs))
extra = []; seen = set()
for v, rule, lab, gs in edges:
    if gs and v not in seen: seen.add(v); extra.append((v, "%s %s" % (rule, lab)))

fx = D9.run("full", extra_seeds=extra);   RX = bm(fx["reached"])
sx = D9.run("strict", extra_seeds=extra); SX = bm(sx["reached"])
ov = sum(1 for a, (n, t, k) in fx["reached"].items() for x in range(a + 1, a + n) if x in fx["reached"])
badnew = sorted(set(fx["bad"]) - set(base["bad"]))
newfull = [x for x in range(HI) if RX[x] and not RB[x]]
print("extra strict-gated seeds %d | extended full %d (+%d) | overlaps %d | new bad %d" %
      (len(extra), sum(RX), sum(RX) - sum(RB), ov, len(badnew)))

# ---------------------------------------------------------------- lane masks + residual
def mask_runs(path, sc, ec=None, lenc=None):
    m = bytearray(HI)
    for ln in open(path, encoding="utf-8").read().splitlines():
        if ln.startswith("#") or ln.split("\t")[0].lower() in ("start", "addr", "term", "target"): continue
        c = ln.split("\t")
        try: s = int(c[sc], 16)
        except ValueError: continue
        e = s + int(c[lenc]) if lenc is not None else int(c[ec], 16)
        for x in range(s, min(e, HI)): m[x] = 1
    return m
I9m = mask_runs(OUT + "suspect-tables/new-proven-bytes.tsv", 0, ec=1)
I6m = mask_runs(OUT + "orphan-screens/exit-table-new-insns.tsv", 0, lenc=1)
i8 = D9.run("full", extra_seeds=[(0x34CCE, "I8"), (0x327E, "I8"), (0x328A, "I8"), (0x329C, "I8")])
I8r = bm(i8["reached"]); I8m = bytearray(HI)
for x in range(HI):
    if I8r[x] and not RB[x]: I8m[x] = 1
known = bytearray(HI)
for x in range(HI):
    if PROV[x] or I6m[x] or I8m[x] or I9m[x]: known[x] = 1
beyond_h9  = [x for x in newfull if not PROV[x]]
beyond_all = [x for x in newfull if not known[x]]
new_named  = [x for x in beyond_all if not NAMED[x]]
print("beyond H9 proven: +%d | beyond H9UI6UI8UI9: +%d proven, +%d named" % (len(beyond_h9), len(beyond_all), len(new_named)))

# ---------------------------------------------------------------- write tables
os.makedirs(DEST, exist_ok=True)
def W(name): return open(DEST + name, "w", encoding="utf-8", newline="\n")
with W("rules-a-cells.tsv") as f:
    f.write("# Rule A: code address stored into a RAM function-pointer cell through an argument register / helper call (1-2 levels).\n")
    f.write("cell\tstore_site\ttarget\tloader_site\timm_set_site\tstore_strict\tbeyond_H9proven\tchain\n")
    for X, store, imm, ld, site, chain in ruleA:
        f.write("%06X\t%06X\t%06X\t%06X\t%06X\t%s\t%s\t%s\n" % (X, store, imm, ld, site,
                store in Rstrict, not PROV[imm], " / ".join(chain)))
with W("rules-b-records.tsv") as f:
    f.write("# Rule B: ROM records whose fields are code pointers, consumed by dispatcher 0x028CBC via mov.l @(d,er1),er6; jsr @er6.\n")
    f.write("# record stride is non-uniform; each record is a 32-byte (8-dword) struct; fields +0/+8/+C/+14/+1C are handler pointers, +18=0x3FFA0 sentinel(none), +4/+10 zero.\n")
    f.write("record\tpasser_site\tbasereg\tpasser_strict\tfields(off=target)\n")
    for (rec, reg, ca), ds in sorted(recs.items()):
        fl = " ".join("+%02X=%06X" % (o, be32(rec + o) & 0xFFFFFF) for o in (0, 4, 8, 0xC, 0x10, 0x14, 0x18, 0x1C))
        f.write("%06X\t%06X\ter%s\t%s\t%s\n" % (rec, ca, reg, ca in Rstrict, fl))
with W("new-edges.tsv") as f:
    f.write("# Every Rule A / Rule B edge; gate_strict = referencing site(s) reached in H9's strict descent; added as a descent seed only when true.\n")
    f.write("rule\ttarget\tgate_strict\tnewly_proven_beyond_H9\tlabel\n")
    for v, rule, lab, gs in edges:
        f.write("%s\t%06X\t%s\t%s\t%s\n" % (rule, v, gs, (gs and not PROV[v] and any(RX[x] and not RB[x] for x in range(v, min(HI, v + 2)))), lab))
# per-rule attribution: descend with only-A and only-B strict-gated seeds
extraA = [(v, lab) for (v, lab) in extra if lab.startswith("A ")]
extraB = [(v, lab) for (v, lab) in extra if lab.startswith("B ")]
RXA = bm(D9.run("full", extra_seeds=extraA)["reached"])
RXB = bm(D9.run("full", extra_seeds=extraB)["reached"])
def rule_of(s):
    a = RXA[s] and not RB[s]; b = RXB[s] and not RB[s]
    return "A" if (a and not b) else "B" if (b and not a) else "A+B" if (a and b) else "?"
with W("new-bytes.tsv") as f:
    f.write("# Bytes newly reached by the extended (A+B) descent and not in H9's proven mask. overlap flags: in_I6/in_I8/in_I9; beyond_all=1 means beyond H9UI6UI8UI9.\n")
    f.write("addr\tlen\trule\tin_H9named\tin_I6\tin_I8\tin_I9\tbeyond_all\tfirst_bytes\n")
    bmask = bytearray(HI)
    for x in beyond_h9: bmask[x] = 1
    for s, e in spans(lambda x: bmask[x]):
        f.write("%06X\t%d\t%s\t%d\t%d\t%d\t%d\t%d\t%s\n" % (s, e - s, rule_of(s), 1 if NAMED[s] else 0,
                1 if I6m[s] else 0, 1 if I8m[s] else 0, 1 if I9m[s] else 0,
                1 if not known[s] else 0, IMG[s:min(e, s + 14)].hex()))
with W("ledger-delta.tsv") as f:
    f.write("term\tdelta_bytes\tvalue\tnote\n")
    f.write("MAIN proven code, H9\t\t365570\tbaseline (reproduced; == h9_proven_mask.bin)\n")
    f.write("H9 + I6(+1544) + I8(+182) + I9(+1136)\t\t368432\tmutually disjoint, additive\n")
    f.write("I15 Rule A\t+0\t\treproduces I9 helper installers 0x000706/0x0004AA/0x000E5E; 0 bytes beyond H9UI6UI8UI9\n")
    f.write("I15 Rule B (records 0x028C2A,0x028C8A fields +14/+1C)\t+%d\t\t4 runs: 02A924,02A9F4 (named already) + 028C4A,028CAA (new named)\n" % len(beyond_all))
    f.write("MAIN proven code, H9+I6+I8+I9+I15\t\t%d\tbyte union\n" % (368432 + len(beyond_all)))
    f.write("MAIN named/typed, H9\t\t497139\tbaseline\n")
    f.write("H9 + I6(+10) + I9(+129) named\t\t497278\t\n")
    f.write("I15 named delta\t+%d\t%d\t028C4A(16)+028CAA(18); 02A924/02A9F4 already named\n" % (len(new_named), 497278 + len(new_named)))
    f.write("beyond H9 only (incl. I9 re-derivation)\t+%d\t\t1128 of these coincide with I9; 54 are beyond all\n" % len(beyond_h9))

pickle.dump(dict(ruleA=ruleA, ruleB=ruleB, recs=recs, extra=extra, beyond_h9=beyond_h9,
                 beyond_all=beyond_all, new_named=new_named), open(DEST + "offline/i15_result.pkl", "wb"))
print("\nresidual runs beyond H9UI6UI8UI9:")
rmask = bytearray(HI)
for x in beyond_all: rmask[x] = 1
for s, e in spans(lambda x: rmask[x]):
    print("  %06X-%06X %3dB  named_already=%d  %s" % (s, e, e - s, 1 if NAMED[s] else 0, IMG[s:min(e, s + 12)].hex()))
print("done.")
