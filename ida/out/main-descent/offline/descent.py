from pathlib import Path as _Path
_REPO = _Path(__file__).resolve().parents[4]
# H9: proven descent over the binutils H8SX oracle with table, pointer-array, RAM-callback and @@vector edges.
# Read-only on every input. Writes pickles to the session scratchpad (h9/).
import sys, re, pickle, collections
sys.dont_write_bytecode = True
sys.path.insert(0, str(_REPO) + r"/ida/out/main-descent/offline")
from common import *

# ------------------------------------------------------------------ inputs
MF = R + "main-full/"
# vectors (reset + 30 handler slots; filler slots all = 0x2092)
VEC = {}
for ln in open(MF + "vectors.tsv", encoding="utf-8").read().splitlines()[1:]:
    c = ln.split("\t"); v = int(c[2], 16)
    if v < HI: VEC.setdefault(v, int(c[0]))
# H2 exclusions (slot addresses)
EXCL = set()
for ln in open(R + "h8sx-seed/table-xrefs-excluded.tsv", encoding="utf-8").read().splitlines()[1:]:
    if ln.startswith("#") or not ln.strip(): continue
    EXCL.add(int(ln.split("\t")[0], 16))
# 149 tables, full entry lists from the image (H1/F1 method), minus H2's excluded slots and the 0x3FFA0 sentinel
TAB = {}       # base -> {slot: target}
for fn in ["jumptables.tsv", "switch_tables.tsv"]:
    for ln in open(MF + fn, encoding="utf-8").read().splitlines()[1:]:
        c = ln.split("\t"); b = int(c[0], 16); n = int(c[1])
        d = TAB.setdefault(b, {})
        for i in range(n):
            s = b + 4 * i; v = be32(s)
            if s in EXCL: continue
            if v < HI and v % 2 == 0 and v != 0x3FFA0 and v != 0: d[s] = v
# H9 additions: 149-table entries that are data pointers, not code pointers (Confirmed by the load site or the target bytes)
H9_EXCL_TABLES = {
    0x014D6A: "load 0x014CD8 mov.l @(0x14d6a:32,er4),er5 -> add.l er3,er5 ; mov.b @er5,r3l (byte lookup); target 0x01515C = 8e 84 68 40 (IDA data)",
    0x014DAA: "load 0x014CEE mov.l @(0x14daa:32,er4),er5 -> add.l er3,er5 ; mov.b @er5,r3l (byte lookup); targets 0x015166/0x01516A/0x015180 = character maps",
    0x020D74: "no load site; entries 0001000a 00014382 00004394 then 45000001 ...; 0x01000A is mid-instruction (0x010008 mov.b r4l,@0xa9f1:16), 0x004394 = ff ff ff ff, 0x014382 inside table 0x012268",
    0x025496: "load 0x025464 mov.l @(0x25496:32,er1),er5 -> add.l er4,er5 ; mov.b @er5+,r3l (record pointer); targets 0x0254CE.. = 0000 0000 ff00 records",
    0x0254D0: "entries 0000ff00 x4 inside the record block that 0x025496 points into",
    0x05584A: "targets 0x05585E/7E/9E/BE/DE = 09 02 20 00 01 01 00 c0 32 09 04 ... (USB configuration/interface/endpoint descriptors); H3 rejected it as data",
}
for _b in H9_EXCL_TABLES:
    TAB[_b] = {}
# H3 arrays
ARR = {}       # base -> dict(tier, refs:set(addr), slots:{slot:target})
for ln in open(R + "ptr-arrays/arrays.tsv", encoding="utf-8").read().splitlines()[1:]:
    c = ln.split("\t")
    if c[4] not in ("A", "B", "C"): continue
    refs = set()
    if c[9] != "-":
        for r_ in c[9].split(","):
            refs.add(int(r_.split(":")[0], 16))
    ARR[int(c[0], 16)] = dict(tier=c[4], refs=refs, slots={})
for ln in open(R + "ptr-arrays/xrefs.tsv", encoding="utf-8").read().splitlines()[1:]:
    c = ln.split("\t"); ARR[int(c[2], 16)]["slots"][int(c[0], 16)] = int(c[1], 16)
# fnindex validated starts, minus H1's junk / leading-text spans
FN = {}
for f in ["main-low", "main-high-a", "main-high-b"]:
    L = open(R + "fnindex/%s.tsv" % f, encoding="utf-8").read().splitlines(); h = L[0].split("\t")
    for ln in L[1:]:
        c = dict(zip(h, ln.split("\t")))
        if c["validated"] == "yes": FN[int(c["start"], 16)] = int(c["end"], 16)
FNSEED = dict(FN)
for ln in open(R + "recount/fnindex-corrections.tsv", encoding="utf-8").read().splitlines():
    if ln.startswith("#") or ln.startswith("span_start"): continue
    c = ln.split("\t"); ss, se, fs, fe = (int(x, 16) for x in c[:4])
    if ss == fs:
        FNSEED.pop(fs, None)
        if se < fe: FNSEED[se] = fe            # code resumes after the leading text
FNSEED.pop(0x006946, None)   # fnindex sub_6946 starts inside jsr @0x85da:24 at 0x006944 (5e 00 85 da); bytes reached from 0x006944 anyway
# F1 rows (H1-corrected). NOT used as seeds: they must be re-reached.
F1 = []
L = [l for l in open(R + "recount/proved-corrected.tsv", encoding="utf-8").read().splitlines() if not l.startswith("#")]
F1H = L[0].split("\t")
for ln in L[1:]:
    c = dict(zip(F1H, ln.split("\t"))); F1.append(c)
SWCASES = {0x07630A + int.from_bytes(IMG[0x078546 + 2 * i:0x078548 + 2 * i], "big") for i in range(45)}  # H1 edge (table bytes lie in the closed window; only the edge is noted)

LD = re.compile(r"^mov\.l @\((0x[0-9a-f]+):(16|32),er(\d)\),er(\d)$")
LDABS = re.compile(r"^mov\.l @(0x[0-9a-f]+):(16|32),er(\d)$")
STABS = re.compile(r"^mov\.l er(\d),@(0x[0-9a-f]+):(16|32)$")
STIMM = re.compile(r"^mov\.l #(0x[0-9a-f]+),@(0x[0-9a-f]+):(16|32)$")
MOVI = re.compile(r"^mov\.l #(0x[0-9a-f]+),er(\d)$")
IJ = re.compile(r"^(jmp|jsr) @er(\d)$")
MI = re.compile(r"^(jmp|jsr) @@\d+ \((0x[0-9a-f]+)\)$")
RR = re.compile(r"^(bra|bsr) (r\d[lh]?\.[bw]|er\d)$")
def absx(v, w): v = int(v, 16); return (v | 0xFF0000) if (w == "16" and v >= 0x8000) else v

def descend(seeds, limit=HI):
    reached = {}; work = list(seeds); bad = {}; pred = {}
    while work:
        a = work.pop()
        while 0 <= a < limit and a not in reached:
            if a & 1: bad[a] = "odd"; break
            n, t, k, tg = flow(a)
            if k == "bad": bad[a] = t; break
            reached[a] = (n, t, k)
            for x in tg:
                if 0 <= x < limit and x not in reached: work.append(x); pred.setdefault(x, a)
            if k == "stop": break
            if k == "stops":
                b = a + n
                if b not in reached:
                    n2, t2, k2, _ = flow(b)
                    if n2: reached[b] = (n2, t2, k2)
                break
            pred.setdefault(a + n, a); a += n
    return reached, bad, pred

def window(reached, a, k):
    """next k reached instructions in fall-through order after a"""
    out = []; x = a + reached[a][0]
    while len(out) < k and x in reached:
        out.append((x, reached[x][1]));
        if reached[x][2] in ("stop", "stops"): break
        x += reached[x][0]
    return out

def writes(t, r):
    return re.search(r",e?r%s[lh]?$" % r, t) is not None or re.search(r",er%s$" % r, t) is not None

def run(mode="full", use_arrays=True, use_ram=True, use_mi=True, extra_seeds=()):
    """mode full: roots + 149 tables (ungated, H1 convention) + fnindex seeds. mode strict: roots only; 149 tables gated too."""
    seed = {}                                   # addr -> origin label
    for v, i in VEC.items(): seed.setdefault(v, "vector %d" % i)
    seed.setdefault(0x2092, "reset")
    if mode == "full":
        for b, d in TAB.items():
            for s, v in d.items(): seed.setdefault(v, "table %06X slot %06X" % (b, s))
        for a in FNSEED: seed.setdefault(a, "fnindex %06X" % a)
    for a, lab in extra_seeds: seed.setdefault(a, lab)
    edge_log = []
    cells_log = {}
    while True:
        r, bad, pred = descend(list(seed))
        new = {}
        # table / array loads and gated array refs
        ldsites = collections.defaultdict(set)
        for a, (n, t, k) in r.items():
            m = LD.match(t)
            if m: ldsites[int(m.group(1), 16)].add(a)
            m = MOVI.match(t)
            if m: ldsites[int(m.group(1), 16)].add(a)
        if mode == "strict":
            for b, d in TAB.items():
                hit = [s for x in range(b - 16, b + 4 * max(1, len(d)) + 4, 2) for s in ldsites.get(x, ())]
                if hit:
                    for s, v in d.items(): new.setdefault(v, "table %06X slot %06X via ref %06X" % (b, s, hit[0]))
        if use_arrays:
            for b, A in ARR.items():
                hit = [x for x in A["refs"] if x in r] + sorted(ldsites.get(b, ()))
                if hit:
                    for s, v in A["slots"].items(): new.setdefault(v, "array %s %06X slot %06X via ref %06X" % (A["tier"], b, s, hit[0]))
        if use_ram:
            # call cells: mov.l @X,erN ; ... ; jmp/jsr @erN (no intervening write to erN)
            cells = {}
            for a, (n, t, k) in r.items():
                m = LDABS.match(t)
                if not m: continue
                X = absx(m.group(1), m.group(2)); reg = m.group(3)
                for x, tt in window(r, a, 4):
                    mj = IJ.match(tt)
                    if mj and mj.group(2) == reg: cells.setdefault(X, x); break
                    if writes(tt, reg): break
            cells_log = cells
            for a, (n, t, k) in r.items():
                m = MOVI.match(t)
                if m:
                    imm = int(m.group(1), 16); reg = m.group(2)
                    if not (0x400 <= imm < HI and imm % 2 == 0): continue
                    for x, tt in window(r, a, 6):
                        ms = STABS.match(tt)
                        if ms and ms.group(1) == reg:
                            X = absx(ms.group(2), ms.group(3))
                            if X in cells: new.setdefault(imm, "ram-cell %06X store %06X call %06X" % (X, x, cells[X]))
                        if writes(tt, reg): break
                m = STIMM.match(t)
                if m:
                    imm = int(m.group(1), 16); X = absx(m.group(2), m.group(3))
                    if 0x400 <= imm < HI and imm % 2 == 0 and X in cells:
                        new.setdefault(imm, "ram-cell %06X store %06X call %06X" % (X, a, cells[X]))
        if use_mi:
            for a, (n, t, k) in r.items():
                m = MI.match(t)
                if m:
                    v = be32(int(m.group(2), 16)) & 0xFFFFFF
                    if v < HI and v % 2 == 0: new.setdefault(v, "@@slot %s at %06X" % (m.group(2), a))
        if 0x076308 in r:
            for v in SWCASES: new.setdefault(v, "bra r0.w switch 076308 (H1)")
        new = {a: l for a, l in new.items() if a not in seed}
        if not new: break
        for a, l in new.items(): seed[a] = l; edge_log.append((a, l))
    return dict(seed=seed, reached=r, bad=bad, pred=pred, edges=edge_log, cells=cells_log)

if __name__ == "__main__":
    res = {}
    res["full"] = run("full")
    res["h1like"] = run("full", use_arrays=False, use_ram=False, use_mi=False)
    res["strict"] = run("strict")
    for k, v in res.items():
        r = v["reached"]
        print(k, "seeds", len(v["seed"]), "insns", len(r), "bytes", sum(x[0] for x in r.values()), "new edges", len(v["edges"]), "cells", len(v["cells"]))
    pickle.dump(res, open(SCR + "descent.pkl", "wb"))

_IDAH = None
def ida_heads():
    global _IDAH
    if _IDAH is None:
        _IDAH = set()
        for ln in open(R + "recount/work/items_h1.tsv", encoding="utf-8").read().splitlines()[1:]:
            ea, sz, k = ln.split("	")[:3]
            if k == "code": _IDAH.add(int(ea, 16))
    return _IDAH

def run_inferred(base):
    """Inferred tier on top of a full run: every mov.l #imm (imm even, in content, outside the closed window, decodable)
    in reached code, plus every H3 tier-C array, is taken as a code edge; iterate to a fixpoint. NOT credited as proven."""
    extra = {}
    for b, A_ in ARR.items():
        if A_["tier"] == "C":
            for s, v in A_["slots"].items(): extra.setdefault(v, "array C %06X slot %06X (unreferenced)" % (b, s))
    while True:
        r = run("full", extra_seeds=sorted(extra.items()))
        new = {}
        for a, (n, t, k) in r["reached"].items():
            m = MOVI.match(t) or STIMM.match(t)
            if m:
                v = int(m.group(1), 16)
                if 0x400 <= v < CW[0] and v % 2 == 0 and v in ida_heads() and not all(printable(b) for b in IMG[v:v + 4]) and v not in r["seed"] and v not in extra:
                    new[v] = "imm %06X (mov.l #imm, Inferred callback)" % a
        if not new: return r, extra
        extra.update(new)
