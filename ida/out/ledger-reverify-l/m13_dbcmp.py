import sys
from pathlib import Path as _Path
_REPO = _Path(__file__).resolve().parents[3]
# M13 -- compare the L1_MAIN_FINAL5 seed state (dumped by ida\jobs\m13_db_check.py from a private copy,
# M13_REVERIFY_MAIN) with the final5 masks and the proposed final6 masks. Plain Python, read-only.
# Output (OUTDIR, default this folder): counts_db.tsv
import os
ROOT = str(_REPO) + "/"
OUT = os.environ.get("OUTDIR", ROOT + "ida/out/ledger-reverify-l/")
HI = 0x7B754
ST = open(ROOT + "ida/out/ledger-reverify-l/db/dbstate.bin", "rb").read()
FP = open(ROOT + "ida/out/ledger-reverify-l/db/fingerprint.txt", encoding="utf-8").read().split("\n")[0]
CM5 = open(ROOT + "ida/out/main-final5/MAIN_FINAL5_codemask.bin", "rb").read()
P5 = open(ROOT + "ida/out/main-final5/final5_proven_mask.bin", "rb").read()[:HI]
N5 = open(ROOT + "ida/out/main-final5/final5_named_mask.bin", "rb").read()[:HI]
P6 = open(ROOT + "ida/out/l-wave-recon/final6_proven_mask.bin", "rb").read()[:HI]
N6 = open(ROOT + "ida/out/l-wave-recon/final6_named_mask.bin", "rb").read()[:HI]
sys.exit('The firmware image is not in this repository.')
code = lambda x: ST[x] & 1
data = lambda x: ST[x] & 2
head = lambda x: ST[x] & 4
func = lambda x: ST[x] & 8
rows = []
def chk(item, d, e, note=""):
    rows.append((item, str(d), str(e), "PASS" if str(d) == str(e) else "FAIL", note)); print(rows[-1])
def info(item, d, note=""):
    rows.append((item, str(d), "-", "INFO", note)); print(rows[-1])
def runs(f, lo=0, hi=HI):
    out = []; x = lo
    while x < hi:
        if f(x):
            s = x
            while x < hi and f(x): x += 1
            out.append((s, x))
        else: x += 1
    return out
chk("seed fingerprint (doc 98 / MAIN_FINAL5_log.txt)", FP, "funcs=5463 heads=124367 codebytes_scope=390660 win_heads=336 odd=0 xrefs_from_code=178254 hash=42111f94aa98d911 win_hash=d722152f5261cfc5")
chk("DB code mask == MAIN_FINAL5_codemask.bin", bytes(1 if code(x) else 0 for x in range(HI)) == CM5[:HI], True)
chk("final5 proven bytes not DB code", sum(1 for x in range(HI) if P5[x] and not code(x)), 0)
chk("final6 proven bytes not DB code", sum(1 for x in range(HI) if P6[x] and not code(x)), 0)
un5 = [x for x in range(HI) if N5[x] and not (code(x) or data(x))]
info("final5 named bytes that are neither code nor data in the seed", "%d B in %d runs" % (len(un5), len(runs(lambda x: N5[x] and not (code(x) or data(x))))))
dem = range(0x054AE2, 0x054BF8)
info("0x054AE2-0x054BF7 in seed: code / data / unexplored", "%d / %d / %d" % (sum(1 for x in dem if code(x)), sum(1 for x in dem if data(x) and not code(x)), sum(1 for x in dem if not (code(x) or data(x)))))
new6 = [x for x in range(HI) if N6[x] and not N5[x]]
info("final6 named additions (L5 Confirmed): seed code / data / unexplored", "%d / %d / %d of %d" % (sum(1 for x in new6 if code(x)), sum(1 for x in new6 if data(x) and not code(x)), sum(1 for x in new6 if not (code(x) or data(x))), len(new6)))
drop = [x for x in range(HI) if P5[x] and not P6[x]]
info("final6 proven demotions (4,428 B): seed code / data", "%d / %d" % (sum(1 for x in drop if code(x)), sum(1 for x in drop if data(x))))
for a in (0x018250, 0x018ABE, 0x01A094, 0x05E8E0, 0x066FB4, 0x067250, 0x066FBE, 0x06726A):
    info("entry %06X: code head / function start" % a, "%d / %d" % (1 if (code(a) and head(a)) else 0, 1 if func(a) else 0))
for a in (0x006A0A, 0x006A0C, 0x006A0E, 0x0077F6, 0x0077F8, 0x0077FA):
    info("stale-head area %06X: code/data/head, bytes" % a, "%d/%d/%d %s" % (1 if code(a) else 0, 1 if data(a) else 0, 1 if head(a) else 0, IMG[a:a + 2].hex()))
with open(OUT + "counts_db.tsv", "w", encoding="utf-8", newline="\n") as f:
    f.write("item\tderived\texpected\tverdict\tnote\n")
    for r in rows: f.write("\t".join(r) + "\n")
