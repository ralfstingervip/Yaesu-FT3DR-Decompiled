# -*- coding: utf-8 -*-
r"""Lane N1 - build the MAIN_FINAL7 proven/named masks in ONE run and prove the FINAL7 DB against them.

Owner-side static analysis. Read-only on every input; writes only ida\out\main-final7\*.
No image byte is modified; no published m-wave mask is overwritten; nothing is connected to a radio.

Step 0  exec ida\out\m-wave-recon\_base.py  -> reproduces FINAL4/5/6 (asserted == published files).
Step 1  one folded descent (fnindex seeds cleared, entries re-validated to a fixpoint): kept L2/L4 er1 callbacks,
        added sub_15260 record fields (M6) and the six CDC handler records (M7); the four dead leaves drop out.
Step 2  FINAL7 proven = descent bytes + the whole service window 0x078106-0x078545.
Step 3  FINAL7 named  = FINAL6 named + FINAL7 proven + M5 Confirmed + M6 Confirmed tiers + M8 (+27 inside M6).
Then: compare byte-for-byte with ida\out\m-wave-recon\final7_{proven,named}_mask.bin and read the FINAL7 DB
      typemask (ida\out\main-final7\MAIN_FINAL7_typemask.bin) to assert: every proven byte is DB code; the two
      DATA-MISTYPED retypes are DB data; every M5/M6 Confirmed byte is typed in the DB.
"""
from pathlib import Path as _Path
_REPO = _Path(__file__).resolve().parents[4]
import os, sys, hashlib
MW = str(_REPO) + r"/ida/out/m-wave-recon/"
exec(open(MW + "_base.py", encoding="utf-8").read())        # defines ROOT, REC, P6, N6, run_folded, COMBINED, bm, ...

OUT7 = ROOT + "ida/out/main-final7/"
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

# ---- Step 1: entries + fixpoint (verbatim rule set from m_recon.py) --------------------------------------
WIN7 = (0x078106, 0x078546)
def recfields(rec):
    out = []; lo = HI; i = 0
    while rec + 4 * i + 4 <= lo:
        v = be32(rec + 4 * i)
        if v == 0: i += 1; continue
        if not (0x400 <= v < HI and v % 2 == 0): break
        out.append(v); lo = min(lo, v) if v > rec else lo; i += 1
    return out
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
for t, srcs in FIXED: say("entry %06X source reached: %s" % (t, [s in r["reached"] for s in srcs]))
for a in DROP4: say("dropped entry %06X reached by the new descent? %s" % (a, a in r["reached"]))
say("sub_15260 records with a reached loader:", len([1 for rec, s in RECS.items() if any(x in r["reached"] for x in s)]), "of", len(RECS))

# ---- Step 2: FINAL7 proven ------------------------------------------------------------------------------
P7 = bytearray(M7)
for x in range(*WIN7): P7[x] = 1
rem = [x for x in range(HI) if P6[x] and not P7[x]]; add = [x for x in range(HI) if P7[x] and not P6[x]]
say("FINAL7 proven %d = FINAL6 %d - %d + %d" % (sum(P7), sum(P6), len(rem), len(add)))

# ---- Step 3: FINAL7 named -------------------------------------------------------------------------------
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
say("FINAL7 named %d = FINAL6 %d + %d (stale copy held out %d)" % (sum(N7), sum(N6), sum(N7) - sum(N6), len(STALE)))

# ---- compare with the published m-wave masks (byte-equality required) -----------------------------------
FULL = 1048576
outp = bytes(P7) + bytes(FULL - HI); outn = bytes(N7) + bytes(FULL - HI)
pubp = rd(MW + "final7_proven_mask.bin"); pubn = rd(MW + "final7_named_mask.bin")
for nm, mine, pub in (("proven", outp, pubp), ("named", outn, pubn)):
    d = runs(lambda x: mine[x] != pub[x], 0, FULL)
    say("%s: mine set=%d sha=%s | published set=%d sha=%s | EQUAL=%s | differing-runs=%d %s" % (
        nm, sum(mine), sha(mine)[:16], sum(pub), sha(pub)[:16], mine == pub, len(d),
        ["%06X-%06X mine=%d" % (s, e, mine[s]) for s, e in d[:20]]))
assert outp == pubp and outn == pubn, "FINAL7 masks differ from the published m-wave files"

# ---- DB invariants on the FINAL7 seed -------------------------------------------------------------------
TM = rd(OUT7 + "MAIN_FINAL7_typemask.bin"); assert len(TM) == HI
pnc = [x for x in range(HI) if P7[x] and TM[x] != 1]
say("DB: FINAL7 proven bytes not DB code: %d %s" % (len(pnc), ["%06X" % x for x in pnc[:10]]))
for s, e in ((0x00932A, 0x009332), (0x03D1C6, 0x03D1CA)):
    say("DB: retype %06X-%06X all data: %s" % (s, e, all(TM[x] == 2 for x in range(s, e))))
M5code = bset(tsv_ranges("ida/out/dead-code-tier/proposed-typing.tsv",
                         lambda p: p.get("typing_conf") == "Confirmed" and p["db_action"].startswith("create_insn")))
M6data = bset([t for t in M6ALL if t[2]["m6_tier"] in ("C-read", "C-extent")])
M6code = {x for r in open(ROOT + "ida/out/inferred-tables/proposed-proven.tsv", encoding="utf-8").read().splitlines()[1:]
          for c in [r.split("\t")] if c[0] in ("core", "companion") for x in range(int(c[1], 16), int(c[2], 16))}
say("DB: M5 dead-code bytes that are DB code: %d/%d" % (sum(1 for x in M5code if TM[x] == 1), len(M5code)))
say("DB: M6 proven-run bytes that are DB code: %d/%d" % (sum(1 for x in M6code if TM[x] == 1), len(M6code)))
say("DB: M6 table bytes that are DB data: %d/%d" % (sum(1 for x in M6data if TM[x] == 2), len(M6data)))
assert not pnc and all(TM[x] == 2 for x in range(0x00932A, 0x009332)) and all(TM[x] == 2 for x in range(0x03D1C6, 0x03D1CA))
assert all(TM[x] == 1 for x in M5code) and all(TM[x] == 1 for x in M6code) and all(TM[x] == 2 for x in M6data)

# ---- outputs (this folder only) -------------------------------------------------------------------------
open(OUT7 + "final7_proven_mask.bin", "wb").write(outp)
open(OUT7 + "final7_named_mask.bin", "wb").write(outn)
with open(OUT7 + "final6-to-final7-diff.tsv", "w", encoding="utf-8", newline="\n") as f:
    f.write("mask\tdirection\tstart\tend_excl\tlen\n")
    for s, e in runs(lambda x: P6[x] and not P7[x]): f.write("proven\tremoved\t%06X\t%06X\t%d\n" % (s, e, e - s))
    for s, e in runs(lambda x: P7[x] and not P6[x]): f.write("proven\tadded\t%06X\t%06X\t%d\n" % (s, e, e - s))
    for s, e in runs(lambda x: N7[x] and not N6[x]): f.write("named\tadded\t%06X\t%06X\t%d\n" % (s, e, e - s))
with open(OUT7 + "ledger.tsv", "w", encoding="utf-8", newline="\n") as f:
    f.write("term\tvalue\tnote\n")
    for k, v, n in (("FINAL6 proven", sum(P6), "== l-wave-recon"), ("FINAL7 proven", sum(P7), "-1544 +2116"),
                    ("FINAL6 named", sum(N6), "== l-wave-recon"), ("FINAL7 named", sum(N7), "+3509"),
                    ("MAIN named %", "%.2f" % (100.0 * sum(N7) / 505684), "of 505,684 content"),
                    ("headline %", "%.4f" % (100.0 * (sum(N7) + 464263) / 1029972), "incl SUB window code 464,263")):
        f.write("%s\t%s\t%s\n" % (k, v, n))
with open(OUT7 + "masks-sha256.txt", "w", encoding="utf-8", newline="\n") as f:
    f.write("final7_proven_mask.bin\t%d\t%s\nfinal7_named_mask.bin\t%d\t%s\n" % (sum(outp), sha(outp), sum(outn), sha(outn)))
open(OUT7 + "build_log.txt", "w", encoding="utf-8", newline="\n").write("\n".join(LOG) + "\n")
say("WROTE main-final7 masks; byte-equal to published m-wave files")
print("\n".join(LOG[-14:]))
