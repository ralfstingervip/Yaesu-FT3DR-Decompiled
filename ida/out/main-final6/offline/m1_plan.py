# -*- coding: utf-8 -*-
r"""Lane M1 - plan the MAIN_FINAL6 DB edits from the FINAL5 seed dump (offline, read-only on every input).

Inputs : ida\out\main-final6\work\seed\{heads,funcs}.tsv (m1_dump.py on a fresh copy of L1_MAIN_FINAL5),
         ida\out\l-wave-recon\{drop_runs.tsv,final6_proven_mask.bin}, ida\out\main-final5\final5_named_mask.bin,
         ida\out\fnindex-lo|mid|hi\proposed-demotions.tsv (DATA-MISTYPED rows),
         ida\out\main-unnamed\proposed-typing.tsv (typing_conf == Confirmed), H9 descent.FNSEED, oracle bu_all.tsv.
Outputs: ida\out\main-final6\plan-delfunc.tsv, plan-typing.tsv, plan-log.txt
Every planned op is fully resolved here (exact range, exact instruction heads) so the IDA job only executes it.
"""
from pathlib import Path as _Path
_REPO = _Path(__file__).resolve().parents[4]
import sys, os, bisect, collections
sys.dont_write_bytecode = True
sys.path.insert(0, str(_REPO) + r"/ida/out/main-descent/offline")
import descent as D9
from common import IMG, BU, HI

ROOT = str(_REPO) + "/"
OUT = ROOT + "ida/out/main-final6/"
W = OUT + "work/seed/"
LOG = []
def say(*a):
    s = " ".join(str(x) for x in a); print(s); LOG.append(s)

H = {}
for l in open(W + "heads.tsv", encoding="utf-8").read().splitlines()[1:]:
    a, n, k = l.split("\t"); H[int(a, 16)] = (int(n), k)
HS = sorted(H)
F = {}
for l in open(W + "funcs.tsv", encoding="utf-8").read().splitlines()[1:]:
    a, e = l.split("\t"); F[int(a, 16)] = int(e, 16)
def item(x):
    i = bisect.bisect_right(HS, x) - 1
    if i >= 0 and HS[i] + H[HS[i]][0] > x: return HS[i], H[HS[i]][0], H[HS[i]][1]
    return None
def kind(x):
    it = item(x); return it[2] if it else "unk"
def overl(s, e):
    out = []; x = s
    while x < e:
        it = item(x)
        if it: out.append(it); x = it[0] + it[1]
        else: x += 1
    return out

P6 = open(ROOT + "ida/out/l-wave-recon/final6_proven_mask.bin", "rb").read()
N5 = open(ROOT + "ida/out/main-final5/final5_named_mask.bin", "rb").read()
DR = [tuple(int(x, 16) for x in l.split("\t")[:2]) for l in open(ROOT + "ida/out/l-wave-recon/drop_runs.tsv", encoding="utf-8").read().splitlines() if l.strip()]
inDR = lambda x: any(s <= x < e for s, e in DR)
ENTRY = [0x018250, 0x018ABE, 0x01A094, 0x05E8E0, 0x066FB4, 0x067250, 0x066FBE, 0x06726A]

# ------------------------------------------------------------ 1. functions to drop (H9 fnindex seeds inside drop runs)
seeds_in = sorted(a for a in D9.FNSEED if inDR(a))
say("H9 fnindex seeds inside drop_runs.tsv:", len(seeds_in))
DEL = []
for a in seeds_in:
    if a in ENTRY: say("  keep %06X (re-added entry point)" % a); continue
    if a not in F: say("  %06X not a function in the seed (head %s) - nothing to drop" % (a, H.get(a))); continue
    fe = F[a]
    left = [x for x in range(a, fe) if not inDR(x)]
    DEL.append((a, fe, left[0] if left else None, len(left), sum(P6[x] for x in left)))
say("functions to delete:", len(DEL))
for a in ENTRY:
    say("  entry %06X: seed head %s, function %s" % (a, H.get(a), a in F))
with open(OUT + "plan-delfunc.tsv", "w", encoding="utf-8", newline="\n") as f:
    f.write("func_start\tfunc_end\tleftover_first\tleftover_bytes\tleftover_final6_proven\n")
    for a, fe, lf, nl, pv in DEL:
        f.write("%06X\t%06X\t%s\t%d\t%d\n" % (a, fe, "%06X" % lf if lf is not None else "-", nl, pv))

# ------------------------------------------------------------ 2. typing ops
OPS = []          # (op, start, end_excl, source, note)
# 2a. DATA-MISTYPED runs (L2/L3/L4) -> data
DM = []
for lane, nm in (("lo", "L2"), ("mid", "L3"), ("hi", "L4")):
    for l in open(ROOT + "ida/out/fnindex-%s/proposed-demotions.tsv" % lane, encoding="utf-8"):
        c = l.rstrip("\n").split("\t")
        if len(c) > 3 and c[3] == "DATA-MISTYPED": DM.append((nm, int(c[0], 16), int(c[1], 16)))
dm_by = collections.Counter();
for nm, s, e in DM: dm_by[nm] += e - s
say("DATA-MISTYPED:", dict(dm_by), "total", sum(dm_by.values()))
assert dict(dm_by) == {"L2": 80, "L3": 144, "L4": 26}
for nm, s, e in DM:
    ov = overl(s, e)
    assert all(it[0] >= s and it[0] + it[1] <= e for it in ov), ("DM straddle", hex(s))
    assert all(inDR(x) for x in range(s, e)) and not any(P6[x] for x in range(s, e))
    OPS.append(("data", s, e, nm + " DATA-MISTYPED", "items %s" % " ".join("%06X+%d%s" % (a, n, k[0]) for a, n, k in ov)))

# 2b. L5 Confirmed rows
rows = []
L = open(ROOT + "ida/out/main-unnamed/proposed-typing.tsv", encoding="utf-8").read().splitlines()
hdr = L[0].split("\t")
for l in L[1:]:
    p = dict(zip(hdr, l.split("\t")))
    if p["typing_conf"] == "Confirmed": rows.append(p)
say("L5 Confirmed rows:", len(rows), "bytes", sum(int(p["len"]) for p in rows))
assert len(rows) == 522 and sum(int(p["len"]) for p in rows) == 3337
DMSET = set(x for _, s, e in DM for x in range(s, e))
ROUTINES = [(0x06B4B0, 0x06B556), (0x06B670, 0x06B69A)]   # named, IDA-undecoded routines (L5 sec. 3)
def chain(s, e):
    a = s; out = []
    while a < e:
        n, t = BU[a]; assert n > 0 and not t.startswith(".word"), (hex(a), t); out.append((a, n, t)); a += n
    assert a == e, hex(a)
    return out
done_routine = set()
cnt = collections.Counter()
for p in rows:
    s, e = int(p["start"], 16), int(p["end_excl"], 16); act = p["db_action"]; src = "L5 " + p["class"]
    assert not any(x in DMSET for x in range(s, e))
    if act.startswith("none"):
        OPS.append(("check_typed", s, e, src, act)); cnt["none"] += 1; continue
    if act == "del_items + create_insn":
        n, t = BU[s]; assert n == 6, (hex(s), n, t)
        OPS.append(("insn", s, s + n, src + " stale-head fix", t)); cnt["stalefix"] += 1; continue
    if "create_insn" in act:
        rt = [r for r in ROUTINES if r[0] <= s < r[1]]
        if rt:
            if rt[0] not in done_routine:
                done_routine.add(rt[0])
                for a, n, t in chain(*rt[0]):
                    OPS.append(("insn", a, a + n, src + " routine %06X chain" % rt[0][0], t))
            cnt["routine-row"] += 1; continue
        # operand bytes of a single instruction: the even head at or below s whose oracle length covers [s,e)
        a = s & ~1
        while not (a in BU and BU[a][0] and a + BU[a][0] >= e): a -= 2
        assert s - a < 10
        it = item(a)
        if it and it[2] == "code" and it[0] <= a and it[0] + it[1] >= e:
            OPS.append(("check_code", s, e, src, "already covered by DB code head %06X+%d" % (it[0], it[1]))); cnt["code-covered"] += 1; continue
        OPS.append(("insn", a, a + BU[a][0], src + " operand bytes", BU[a][1])); cnt["operand-insn"] += 1; continue
    # data rows
    if all(kind(x) == "data" for x in range(s, e)):
        OPS.append(("check_data", s, e, src, "already data")); cnt["data-nochange"] += 1; continue
    s0 = s
    if act == "dword + offset":
        # rows are the residue part of BE32 cells that end at e (tails, low halves, whole runs of cells)
        s = e - 4 * ((e - s + 3) // 4)
        assert s % 2 == 0 and all((IMG[c] == 0 and int.from_bytes(IMG[c:c + 4], "big") < HI) or IMG[c:c + 2] == b"\x00\xff"
                                  for c in range(s, e, 4)), ("cell", hex(s0))
    ov = overl(s, e)
    lo = min([s] + [it[0] for it in ov]); hi = max([e] + [it[0] + it[1] for it in ov])
    if act == "dword + offset" and lo == s and hi == e:
        OPS.append(("dword", s, e, src, "cells %06X-%06X (row %06X-%06X; cell head bytes named %d, proven %d)" % (
            s, e, s0, e, sum(N5[x] for x in range(s, s0)), sum(P6[x] for x in range(s, s0)))))
        assert not any(P6[x] for x in range(s, e)); cnt["dword"] += 1; continue
    s = s0
    extra = [x for x in range(lo, hi) if not (s <= x < e)]
    if extra:
        assert not any(P6[x] for x in extra), ("would retype proven bytes", hex(s))
        note = "neighbour item(s) %s retyped with the row; extra bytes %s (named %d, proven 0)" % (
            " ".join("%06X+%d%s" % (a, n, k[0]) for a, n, k in ov if a < s or a + n > e),
            ",".join("%06X" % x for x in extra), sum(N5[x] for x in extra))
        cnt["data-expanded"] += 1
    else:
        note = ""; cnt["data"] += 1
    OPS.append(("data", lo, hi, src, note))
say("L5 row handling:", dict(cnt))

# merge overlapping/adjacent duplicate ops of the same kind produced by expansion (e.g. two rows sharing a neighbour)
OPS.sort(key=lambda o: (o[1], o[2]))
merged = []
for o in OPS:
    if merged and o[0] == "data" and merged[-1][0] == "data" and o[1] < merged[-1][2]:
        m = merged[-1]; merged[-1] = ("data", m[1], max(m[2], o[2]), m[3] + " + " + o[3], (m[4] + "; " + o[4]).strip("; "))
    elif merged and o[0] == "insn" and merged[-1][0] == "insn" and o[1] == merged[-1][1]:
        continue
    else:
        merged.append(o)
# no two editing ops may overlap
ed = [o for o in merged if o[0] in ("data", "dword", "insn")]
for a, b in zip(ed, ed[1:]):
    assert a[2] <= b[1], ("overlap", a, b)
with open(OUT + "plan-typing.tsv", "w", encoding="utf-8", newline="\n") as f:
    f.write("op\tstart\tend_excl\tlen\tsource\tnote\tbytes\n")
    for o in merged:
        f.write("%s\t%06X\t%06X\t%d\t%s\t%s\t%s\n" % (o[0], o[1], o[2], o[2] - o[1], o[3], o[4], IMG[o[1]:min(o[2], o[1] + 16)].hex()))
say("plan ops:", dict(collections.Counter(o[0] for o in merged)))
say("editing bytes: data %d, dword %d, insn %d" % tuple(sum(o[2] - o[1] for o in merged if o[0] == k) for k in ("data", "dword", "insn")))
open(OUT + "plan-log.txt", "w", encoding="utf-8", newline="\n").write("\n".join(LOG) + "\n")
