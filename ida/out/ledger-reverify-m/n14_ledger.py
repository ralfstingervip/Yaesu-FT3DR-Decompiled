import sys
from pathlib import Path as _Path
_REPO = _Path(__file__).resolve().parents[3]
# N14 -- independent recount of the M-wave FINAL7 MAIN masks and their ledger terms. Read-only on every input.
# Writes counts_ledger.tsv in OUTDIR (default: this folder). No DB is opened; nothing is connected to a radio.
import os, sys, hashlib
sys.dont_write_bytecode = True
ROOT = str(_REPO)
IO = os.path.join(ROOT, "ida", "out")
OUT = os.environ.get("OUTDIR", os.path.dirname(os.path.abspath(__file__)))
rd = lambda *p: open(os.path.join(*p), "rb").read()
sha = lambda b: hashlib.sha256(bytes(b)).hexdigest()
sys.exit('The firmware image is not in this repository.')
rows = []
def chk(item, got, exp, note=""):
    ok = (got == exp) if exp is not None else None
    rows.append((item, str(got), str(exp) if exp is not None else "-", "PASS" if ok else ("INFO" if ok is None else "FAIL"), note))
chk("MAIN sha256", sha(M), "8e3ecd05409b2c314ebed77320ece5930bf31c8333cd84aeef4f6b0264c1bcce")
chk("SUB sha256", sha(S), "b93570b3c2f69ccb51c113c893b4bc4c414cf78ceddde478748404e0768c6230")
HI = 505684; CEIL = 0x07B754
P7 = rd(IO, "m-wave-recon", "final7_proven_mask.bin"); N7 = rd(IO, "m-wave-recon", "final7_named_mask.bin")
P6 = rd(IO, "l-wave-recon", "final6_proven_mask.bin"); N6 = rd(IO, "l-wave-recon", "final6_named_mask.bin")
P6b = rd(IO, "main-final6", "final6_proven_mask.bin"); N6b = rd(IO, "main-final6", "final6_named_mask.bin")
for nm, m, n, h in (("final7_proven", P7, 365358, "5585a9c6d810d96401a6dbd14eadabc575893e8c890dd39263e1df00040d58db"),
                    ("final7_named", N7, 505165, "0bcf995b1087e72397fc67e8f2e8487ddae0010ba312dfd58ae000f7fdf7fdd2"),
                    ("final6_proven", P6, 364786, "ecd7deaf54da6d21abeaf99597a6d18dca04f75874cf9f91cd910a7adc73d2c5"),
                    ("final6_named", N6, 501656, "fe8f60996e0a585216db5dec8ddbbcc7323c00fa816e2ed0ab34b0a89aa1165d")):
    chk(nm + " length", len(m), 1048576); chk(nm + " values", sorted(set(m)), [0, 1])
    chk(nm + " popcount", sum(m), n); chk(nm + " sha256", sha(m), h)
    chk(nm + " bytes at/above 0x07B754", sum(m[CEIL:]), 0)
chk("main-final6 masks == l-wave-recon final6 (M1 cmp-equal)", (P6b == P6, N6b == N6), (True, True))
chk("final7 proven subset of named", sum(1 for x in range(HI) if P7[x] and not N7[x]), 0)
chk("final6 named subset of final7 named", sum(1 for x in range(HI) if N6[x] and not N7[x]), 0)
chk("image tail 0x07B754.. all FF", set(M[CEIL:]) == {0xFF}, True)
def runs(f, lo=0, hi=HI):
    out = []; x = lo
    while x < hi:
        if f(x):
            s = x
            while x < hi and f(x): x += 1
            out.append((s, x))
        else: x += 1
    return out
rem = runs(lambda x: P6[x] and not P7[x]); add = runs(lambda x: P7[x] and not P6[x]); nadd = runs(lambda x: N7[x] and not N6[x])
nb = lambda rr: sum(e - s for s, e in rr)
chk("proven removed final6->final7", nb(rem), 1544, "1,472 + 72")
chk("proven added final6->final7", nb(add), 2116, "390 + 1,726")
chk("named added final6->final7", nb(nadd), 3509)
chk("ledger arithmetic proven", 364786 - 1472 - 72 + 390 + 1726, 365358)
chk("ledger arithmetic named", 501656 + 3509, 505165)
pub = [l.split("\t") for l in open(os.path.join(IO, "m-wave-recon", "final6-to-final7-diff.tsv"), encoding="utf-8").read().splitlines()[1:]]
mine = [("proven", "removed", s, e) for s, e in rem] + [("proven", "added", s, e) for s, e in add] + [("named", "added", s, e) for s, e in nadd]
chk("final6-to-final7-diff.tsv runs == my diff runs", sorted((r[0], r[1], int(r[2], 16), int(r[3], 16)) for r in pub) == sorted(mine), True, "%d rows" % len(pub))
def tsv(path, keep=lambda p: True):
    L = [l.split("\t") for l in open(os.path.join(IO, path), encoding="utf-8").read().splitlines() if l and not l.startswith("#")]
    hdr = L[0]; out = []
    for c in L[1:]:
        try: s, e = int(c[0], 16), int(c[1], 16)
        except ValueError: continue
        p = dict(zip(hdr, c))
        if keep(p): out.append((s, e, p))
    return out
bs = lambda rr: {x for s, e, *_ in rr for x in range(s, e)}
remS = {x for s, e in rem for x in range(s, e)}; addS = {x for s, e in add for x in range(s, e)}; naddS = {x for s, e in nadd for x in range(s, e)}
for lane, d, exp in (("M2", "punr-lo", 368), ("M3", "punr-mid", 574), ("M4", "punr-hi", 530)):
    b = bs(tsv(d + "/proposed-demotions.tsv"))
    chk("%s proposed demotions bytes" % lane, len(b), exp); chk("%s demotions all removed" % lane, b <= remS, True)
DEM = bs(tsv("punr-lo/proposed-demotions.tsv")) | bs(tsv("punr-mid/proposed-demotions.tsv")) | bs(tsv("punr-hi/proposed-demotions.tsv"))
chk("removed outside M2/M3/M4 (the 72 B cascade)", ["%06X-%06X" % (s, e) for s, e in runs(lambda x: x in remS - DEM)], ["066FB4-066FC8", "067250-067284"])
chk("cascade size", len(remS - DEM), 72)
for a in (0x066FB4, 0x067250, 0x066FBE, 0x06726A): chk("dropped leaf %06X final7 proven / named" % a, (P7[a], N7[a]), (0, 1))
core = set()
for l in open(os.path.join(IO, "inferred-tables", "proposed-proven.tsv"), encoding="utf-8").read().splitlines()[1:]:
    c = l.split("	")
    if len(c) > 2 and c[0] in ("core", "companion"): core.update(range(int(c[1], 16), int(c[2], 16)))
chk("M6 core+companion bytes", len(core), 390, "148 + 242")
chk("M6 core+companion = added outside CDC", core == addS - {x for x in addS if 0x0767BE <= x < 0x0771E2}, True)
cdc = [(0x07B4B4 + 10 * k, int.from_bytes(M[0x07B4B4 + 10 * k + 6:0x07B4B4 + 10 * k + 10], "big")) for k in range(6)]
chk("CDC handler records BE32 at 0x07B4B4+10k+6", ["%06X" % v for _, v in cdc], ["0784BE", "0769AA", "0768C8", "0769AA", "0767BE", "0768A8"])
CDC7 = {x for s, e in [(0x0767BE, 0x076ADE), (0x076C0A, 0x076FC8), (0x07711E, 0x0771E2)] for x in range(s, e)}
chk("M7 ranges new vs final6", len(CDC7 - {x for x in range(HI) if P6[x]}), 1778)
chk("M7 credited", len(addS & CDC7), 1726)
chk("M7 not credited", ["%06X-%06X" % r for r in runs(lambda x: x in CDC7 and not P7[x] and not P6[x])], ["0771AE-0771E2"])
lo, hi = 0x0771AE, 0x0771E2; hits = []
for i in range(HI - 4):
    if M[i] in (0x5A, 0x5E) and M[i + 1] == 0 and lo <= int.from_bytes(M[i + 1:i + 4], "big") < hi: hits.append("abs24 %06X" % i)
    v = int.from_bytes(M[i:i + 4], "big")
    if lo <= v < hi and v % 2 == 0: hits.append("BE32 %06X" % i)
    if i % 2 == 0 and not (lo <= i < hi):
        if M[i] == 0x55:
            t = i + 2 + (M[i + 1] - 256 if M[i + 1] > 127 else M[i + 1])
            if lo <= t < hi: hits.append("bsr8 %06X" % i)
        if M[i] == 0x5C and M[i + 1] == 0x00:
            t = i + 4 + int.from_bytes(M[i + 2:i + 4], "big", signed=True)
            if lo <= t < hi: hits.append("bsr16 %06X" % i)
        if 0x40 <= M[i] <= 0x4F:
            t = i + 2 + (M[i + 1] - 256 if M[i + 1] > 127 else M[i + 1])
            if lo <= t < hi: hits.append("bcc8 %06X" % i)
        if M[i] == 0x58 and (M[i + 1] & 0x0F) == 0:
            t = i + 4 + int.from_bytes(M[i + 2:i + 4], "big", signed=True)
            if lo <= t < hi: hits.append("bcc16 %06X" % i)
HEADS = {}
for l in open(os.path.join(IO, "main-final6", "MAIN_FINAL6_heads.tsv"), encoding="utf-8").read().splitlines()[1:]:
    a, n, k = l.split("	"); HEADS[int(a, 16)] = (int(n), k)
def owner(x):
    for d in range(0, 11):
        h = HEADS.get(x - d)
        if h and h[0] > d: return "%06X+%d (%d B %s)" % (x - d, d, h[0], h[1])
    return "none"
chk("raw byte-pattern hits into 0x0771AE-0x0771E1 (abs24/BE32/bsr/bcc)", ["%s in %s" % (h, owner(int(h.split()[1], 16))) for h in hits], None, "INFO")
real = [h for h in hits if int(h.split()[1], 16) in HEADS]
chk("inbound edges into 0x0771AE-0x0771E1 at instruction heads (M1 seed heads)", real, [], "Not found expected; scope 0..0x07B754")
m5 = bs(tsv("dead-code-tier/proposed-typing.tsv", lambda p: p.get("typing_conf") == "Confirmed"))
m6 = bs(tsv("inferred-tables/proposed-typing.tsv", lambda p: p["m6_tier"] in ("C-read", "C-extent", "Proven-code", "companion-proven")))
st = bs(tsv("inferred-tables/proposed-typing.tsv", lambda p: p["m6_tier"] == "Stale-copy"))
m8 = set(range(0x039067, 0x039080)) | {0x000E20, 0x000E21}
chk("M5 named bytes", len(m5), 2880); chk("M6 named bytes (Confirmed tiers)", len(m6), 635); chk("M8 named bytes", len(m8), 27)
chk("M5 & M6 overlap", ["%06X-%06X" % r for r in runs(lambda x: x in m5 and x in m6)], ["018FAA-018FB0"])
chk("M8 inside M6", m8 <= m6, True)
chk("union M5|M6|M8", len(m5 | m6 | m8), 3509); chk("union == named added", (m5 | m6 | m8) == naddS, True)
chk("stale copy bytes held", ["%06X-%06X" % r for r in runs(lambda x: x in st)], ["069A7F-069AAA"]); chk("stale copy unnamed in final7", sum(N7[x] for x in st), 0)
chk("stale copy first 37 B == 0x069964", M[0x069A7F:0x069A7F + 37] == M[0x069964:0x069964 + 37], True)
chk("MAIN unnamed", HI - sum(N7[:HI]), 519)
pct = lambda a, b: "%.2f%%" % (100.0 * a / b)
chk("proven % of content", pct(365358, 505684), "72.25%"); chk("proven % of decodable", pct(365358, 389260), "93.86%")
chk("named %", pct(505165, 505684), "99.90%"); chk("headline", (505165 + 464263, "%.2f%%" % (100.0 * 969428 / 1029972)), (969428, "94.12%"))
chk("named incl. stale", (505165 + 43, pct(505208, 505684)), (505208, "99.91%"))
W = rd(IO, "sub-final3", "raw", "mask_final3_after_headline_w2.bin"); chk("SUB window code (headline_w2)", sum(W), 464263)
for nm, sb, exp in (("B", 467999, "94.48%"), ("C", 520552, "99.59%"), ("D", 524288, "99.95%")):
    chk("M15 convention %s headline" % nm, (505165 + sb, "%.2f%%" % (100.0 * (505165 + sb) / 1029972)), (505165 + sb, exp))
chk("M15 convention E", (365358 + 457342, "%.2f%%" % (100.0 * 822700 / 1029972)), (822700, "79.88%"))
chk("M15 gap 60,025 = 56,289 + 3,736", 56289 + 3736, 60025)
chk("old headline 965,919 + 3,509", 965919 + 3509, 969428)
with open(os.path.join(OUT, "counts_ledger.tsv"), "w", encoding="utf-8", newline="\n") as f:
    f.write("item\tgot\texpected\tresult\tnote\n")
    for r in rows: f.write("\t".join(x.replace("\t", " ") for x in r) + "\n")
from collections import Counter
print(Counter(r[3] for r in rows)); [print(r) for r in rows if r[3] != "PASS"]
