# -*- coding: utf-8 -*-
r"""M-wave reconciliation (orchestrator): proposed FINAL7 MAIN masks from ONE folded descent.

Owner-side static analysis. Read-only on every input; writes only ida\out\m-wave-recon\*.
No image byte is modified, no database is opened, nothing is connected to a radio.

Step 0  exec _base.py (lane M1's m1_build_masks.py up to the FINAL6 named mask, DB checks and writes cut):
        reproduces FINAL4 / FINAL5 / FINAL6 and asserts each against its published file.
Step 1  one folded descent without fnindex seeds, entry points re-validated to a fixpoint:
          kept   L2 er1 callbacks 0x018250 / 0x018ABE / 0x01A094, L4 er1 callback 0x05E8E0 (source must be reached)
          added  sub_15260 record fields (M6 rule) for every record whose `mov.l #rec,er5` loader is reached
          added  CDC handler records 0x07B4B4 (M7; walked by window ISR 0x07827C, window credited since doc 95)
          dropped 0x066FB4 / 0x067250 / 0x066FBE / 0x06726A (M4: every caller is a dead arm)
Step 2  FINAL7 proven = descent bytes + whole service-window code 0x078106-0x078545 (1,088 B, docs 95/116).
Step 3  FINAL7 named  = FINAL6 named + FINAL7 proven + M5 typing + M6 Confirmed tiers + M8 (+27).
        M6's 43 B stale copy 0x069A7F is held out (owner decision) and reported separately.
"""
import os, sys, hashlib
HERE = os.path.dirname(os.path.abspath(__file__))
exec(open(os.path.join(HERE, "_base.py"), encoding="utf-8").read())

OUT7 = ROOT + "ida/out/m-wave-recon/"
PUB6P = rd(REC + "final6_proven_mask.bin"); PUB6N = rd(REC + "final6_named_mask.bin")
assert bytes(P6) == PUB6P[:HI] and bytes(N6) == PUB6N[:HI]
say("FINAL6 reproduced (== l-wave-recon masks):", sum(P6), sum(N6))

def tsv_ranges(path, keep=lambda p: True):
    L = [l.split("\t") for l in open(ROOT + path, encoding="utf-8").read().splitlines() if l and not l.startswith("#")]
    hdr = L[0]; out = []
    for c in L[1:]:
        p = dict(zip(hdr, c))
        try: s, e = int(c[0], 16), int(c[1], 16)
        except ValueError: continue
        if keep(p): out.append((s, e, p))
    return out
def bset(rs): return {x for s, e, _ in rs for x in range(s, e)}

# ------------------------------------------------------------------ Step 1: entries + fixpoint
WIN7 = (0x078106, 0x078546)
def loaders(rec):
    pat = bytes([0x7A, 0x05, (rec >> 24) & 0xFF, (rec >> 16) & 0xFF, (rec >> 8) & 0xFF, rec & 0xFF]); out = []; i = IMG.find(pat)
    while i != -1:
        tail = IMG[i + 6:i + 16]
        if bytes.fromhex("5a015260") in tail or bytes.fromhex("5e015260") in tail: out.append(i)
        i = IMG.find(pat, i + 1)
    return out
def recfields(rec):
    out = []; lo = HI; i = 0
    while rec + 4 * i + 4 <= lo:
        v = be32(rec + 4 * i)
        if v == 0: i += 1; continue
        if not (0x400 <= v < HI and v % 2 == 0): break
        out.append(v); lo = min(lo, v) if v > rec else lo; i += 1
    return out
# every record handed to sub_15260 by `mov.l #rec,er5` followed by jmp/jsr 0x015260
RECS = {}
for i in range(0, HI - 6, 2):
    if IMG[i] == 0x7A and IMG[i + 1] == 0x05 and IMG[i + 2] == 0:
        rec = int.from_bytes(IMG[i + 2:i + 6], "big")
        tail = IMG[i + 6:i + 16]
        if 0x400 <= rec < HI and (bytes.fromhex("5a015260") in tail or bytes.fromhex("5e015260") in tail):
            RECS.setdefault(rec, []).append(i)
CDC = [(0x07B4B4 + 10 * k, be32(0x07B4B4 + 10 * k + 6)) for k in range(6)]
FIXED = [(0x018250, [0x018276]), (0x018ABE, [0x018AD2]), (0x01A094, [0x018BE8]), (0x05E8E0, [0x05E862])]
DROP4 = [0x066FB4, 0x067250, 0x066FBE, 0x06726A]
def entries(reached):
    E = []
    for t, srcs in FIXED:
        if any(s in reached for s in srcs): E.append((t, "kept %06X" % t))
    for rec, srcs in sorted(RECS.items()):
        if any(s in reached for s in srcs):
            for v in recfields(rec): E.append((v, "sub_15260 record %06X" % rec))
    for r, v in CDC:
        if not INW(v): E.append((v, "CDC handler record %06X" % r))
    return E
D9.FNSEED.clear()
r = run_folded(COMBINED); prev = None
for it in range(10):
    E = entries(r["reached"]); key = tuple(sorted(set(a for a, _ in E)))
    say("fixpoint iter %d: %d entry points" % (it, len(key)))
    if key == prev: break
    prev = key; r = run_folded(COMBINED + E)
D9.FNSEED.update(FNSAVE)
M7 = bm(r["reached"])
for t, srcs in FIXED: say("entry %06X source %s reached: %s" % (t, srcs, [s in r["reached"] for s in srcs]))
for a in DROP4: say("dropped entry %06X: reached by the new descent? %s" % (a, a in r["reached"]))
say("sub_15260 records with a reached loader:", len([1 for rec, s in RECS.items() if any(x in r["reached"] for x in s)]), "of", len(RECS))

# ------------------------------------------------------------------ Step 2: FINAL7 proven
P7 = bytearray(M7)
for x in range(*WIN7): P7[x] = 1
rem = [x for x in range(HI) if P6[x] and not P7[x]]; add = [x for x in range(HI) if P7[x] and not P6[x]]
say("FINAL7 proven", sum(P7), "= FINAL6 %d - %d + %d" % (sum(P6), len(rem), len(add)))

DEM = bset(tsv_ranges("ida/out/punr-lo/proposed-demotions.tsv")) | bset(tsv_ranges("ida/out/punr-mid/proposed-demotions.tsv")) \
    | bset(tsv_ranges("ida/out/punr-hi/proposed-demotions.tsv"))
say("M2+M3+M4 proposed demotions %d B; all removed now: %s; removed outside them: %d" % (
    len(DEM), DEM <= set(rem), len(set(rem) - DEM)))
CORE6 = set()
for l in open(ROOT + "ida/out/inferred-tables/proposed-proven.tsv", encoding="utf-8").read().splitlines()[1:]:
    c = l.split("\t")
    if len(c) > 2 and c[0] in ("core", "companion"): CORE6.update(range(int(c[1], 16), int(c[2], 16)))
CDC7 = {x for s, e in [(0x0767BE, 0x076ADE), (0x076C0A, 0x076FC8), (0x07711E, 0x0771E2)] for x in range(s, e)}
addS = set(add)
P6S = set(x for x in range(HI) if P6[x])
say("added: in M6 proposed-proven %d / %d new; in M7 CDC ranges %d / %d new; other %d" % (
    len(addS & CORE6), len(CORE6 - P6S), len(addS & CDC7), len(CDC7 - P6S), len(addS - CORE6 - CDC7)))
miss7 = sorted(CDC7 - P6S - addS)
say("M7 bytes not reached by the descent: %d %s" % (len(miss7), ["%06X-%06X" % (s, e) for s, e in runs(lambda x: x in set(miss7))]))
say("removed outside M2/M3/M4: %s" % ["%06X-%06X" % (s, e) for s, e in runs(lambda x: x in (set(rem) - DEM))])

# ------------------------------------------------------------------ Step 3: FINAL7 named
M5T = bset(tsv_ranges("ida/out/dead-code-tier/proposed-typing.tsv", lambda p: p.get("typing_conf") == "Confirmed"))
M6ALL = tsv_ranges("ida/out/inferred-tables/proposed-typing.tsv")
M6T = bset([t for t in M6ALL if t[2]["m6_tier"] in ("C-read", "C-extent", "Proven-code", "companion-proven")])
STALE = bset([t for t in M6ALL if t[2]["m6_tier"] == "Stale-copy"])
M8T = set(range(0x039067, 0x039080)) | {0x000E20, 0x000E21}
N7 = bytearray(N6)
for x in M5T | M6T | M8T: N7[x] = 1
for x in range(HI):
    if P7[x]: N7[x] = 1
assert all(N7[x] >= P7[x] for x in range(HI))
say("FINAL7 named %d = FINAL6 %d + %d (M5 %d, M6 %d, M8 %d, union; proven-only %d); stale copy held out %d" % (
    sum(N7), sum(N6), sum(N7) - sum(N6), len(M5T), len(M6T), len(M8T),
    sum(1 for x in range(HI) if P7[x] and not N6[x] and x not in (M5T | M6T | M8T)), len(STALE)))
CONTENT = 505684
say("MAIN named %.2f%%; unnamed %d (stale copy %d)" % (100.0 * sum(N7) / CONTENT, CONTENT - sum(N7), len(STALE)))
say("headline (SUB window code 464,263): %d / 1,029,972 = %.4f%%" % (sum(N7) + 464263, 100.0 * (sum(N7) + 464263) / 1029972))
say("proven: %.2f%% of content, %.2f%% of 389,260 decodable" % (100.0 * sum(P7) / CONTENT, 100.0 * sum(P7) / 389260))

# ------------------------------------------------------------------ outputs (this folder only)
outp = bytes(P7) + bytes(FULL - HI); outn = bytes(N7) + bytes(FULL - HI)
open(OUT7 + "final7_proven_mask.bin", "wb").write(outp)
open(OUT7 + "final7_named_mask.bin", "wb").write(outn)
with open(OUT7 + "final6-to-final7-diff.tsv", "w", encoding="utf-8", newline="\n") as f:
    f.write("mask\tdirection\tstart\tend_excl\tlen\treason\n")
    for s, e in runs(lambda x: P6[x] and not P7[x]):
        why = "M2/M3/M4 dead" if all(y in DEM for y in range(s, e)) else "cascade: not reached by the FINAL7 descent"
        f.write("proven\tremoved\t%06X\t%06X\t%d\t%s\n" % (s, e, e - s, why))
    for s, e in runs(lambda x: P7[x] and not P6[x]):
        why = "M7 CDC handler records" if all(y in CDC7 for y in range(s, e)) else ("M6 sub_15260 record rule" if all(y in CORE6 for y in range(s, e)) else "FINAL7 descent")
        f.write("proven\tadded\t%06X\t%06X\t%d\t%s\n" % (s, e, e - s, why))
    for s, e in runs(lambda x: N7[x] and not N6[x]):
        f.write("named\tadded\t%06X\t%06X\t%d\tM5/M6/M8 typing or FINAL7 proven\n" % (s, e, e - s))
with open(OUT7 + "masks-sha256.txt", "w", encoding="utf-8", newline="\n") as f:
    f.write("final7_proven_mask.bin\t%d\t%s\nfinal7_named_mask.bin\t%d\t%s\n" % (sum(outp), sha(outp), sum(outn), sha(outn)))
open(OUT7 + "recon_log.txt", "w", encoding="utf-8", newline="\n").write("\n".join(LOG) + "\n")
