from pathlib import Path as _Path
_REPO = _Path(__file__).resolve().parents[4]
# Lane I14: measure MAIN_FINAL2 (dumped by i14_apply_final2.py) against the merged proven mask. Read-only on inputs.
# Run:  python -B "ida/out/main-final2/offline/i14_post.py"
import sys, pickle, collections, hashlib
sys.dont_write_bytecode = True
sys.path.insert(0, str(_REPO) + r"/ida/out/main-descent/offline")
from common import IMG, HI, CW, runtype
OUT = str(_REPO) + r"/ida/out/main-final2/"
MF = str(_REPO) + r"/ida/out/main-final/"
SCR = r"local-temp/"
L = []
def say(*a):
    s = " ".join(str(x) for x in a); print(s); L.append(s)
d = pickle.load(open(SCR + "i14_merge.pkl", "rb"))
PROV, UNI = d["PROV"], d["UNI"]
P2 = bytearray(1 if (PROV[x] or UNI[x]) else 0 for x in range(HI))
say("merged proven mask bytes", sum(P2), "(H9", sum(PROV), "+ union", sum(UNI), ")")
open(OUT + "final2_proven_mask.bin", "wb").write(bytes(P2))
C2 = open(OUT + "MAIN_FINAL2_codemask.bin", "rb").read()
C1 = open(MF + "MAIN_FINAL_codemask.bin", "rb").read()
assert len(C2) == len(C1) == HI
w0, w1 = CW
say("window code mask identical to MAIN_FINAL:", C2[w0:w1] == C1[w0:w1], "window code bytes", sum(C2[w0:w1]))
say("image sha256 prefix", hashlib.sha256(IMG).hexdigest()[:16])
pc = sum(1 for x in range(HI) if P2[x] and C2[x]); pn = [x for x in range(HI) if P2[x] and not C2[x]]
say("merged proven bytes that are DB code: %d / %d (%.3f%%); not code: %d" % (pc, sum(P2), 100.0 * pc / sum(P2), len(pn)))
say("  of the union (+%d): DB code %d" % (sum(UNI), sum(1 for x in range(HI) if UNI[x] and C2[x])))
say("  MAIN_FINAL for comparison: H9 proven that is DB code %d / %d" % (sum(1 for x in range(HI) if PROV[x] and C1[x]), sum(PROV)))
def spans(f):
    out = []; x = 0
    while x < HI:
        if f(x):
            s = x
            while x < HI and f(x): x += 1
            out.append((s, x))
        else: x += 1
    return out
with open(OUT + "proven-not-dbcode.tsv", "w", encoding="utf-8", newline="\n") as h:
    h.write("start\tend_excl\tbytes\tin_window\tfirst_bytes\n")
    for s, e in spans(lambda x: P2[x] and not C2[x]):
        h.write("%06X\t%06X\t%d\t%d\t%s\n" % (s, e, e - s, int(w0 <= s < w1), IMG[s:e].hex()))
        say("  proven-not-code %06X-%06X %s" % (s, e, IMG[s:e].hex()))
dn = sum(1 for x in range(HI) if C2[x] and not P2[x]); dn1 = sum(1 for x in range(HI) if C1[x] and not PROV[x])
say("DB code bytes outside merged proven: %d (MAIN_FINAL vs H9: %d)" % (dn, dn1))
cls = collections.Counter()
for x in range(HI):
    if C2[x] and not P2[x] and not (w0 <= x < w1): cls[runtype(x)] += 1
say("  outside window by W2-8 runtype:", dict(cls))
say("DB code bytes total (0..HI): MAIN_FINAL %d, MAIN_FINAL2 %d" % (sum(C1), sum(C2)))
# functions
rows = [l.split("\t") for l in open(OUT + "MAIN_FINAL2_functions_raw.tsv", encoding="utf-8").read().splitlines()[1:]]
cnt = collections.Counter()
old = {l.split("\t")[0]: l.split("\t")[3] for l in open(MF + "functions.tsv", encoding="utf-8").read().splitlines()[1:]}
with open(OUT + "functions.tsv", "w", encoding="utf-8", newline="\n") as h:
    h.write("start\tend\tsize\treach_class\tin_MAIN_FINAL\n")
    for r in rows:
        s, e = int(r[0], 16), int(r[1], 16)
        if w0 <= s < w1: k = "closed-window"
        elif s < HI and P2[s]: k = "proven"
        elif any(P2[x] for x in range(s, min(e, HI))): k = "partly-proven"
        else: k = "typed-unreached"
        cnt[k] += 1
        h.write("%s\t%s\t%d\t%s\t%s\n" % (r[0], r[1], e - s, k, old.get(r[0], "new")))
say("functions", len(rows), dict(cnt))
oldset = set(old); newset = set(r[0] for r in rows)
say("functions new vs MAIN_FINAL: +%d -%d" % (len(newset - oldset), len(oldset - newset)), "removed:", sorted(oldset - newset))
open(OUT + "post_log.txt", "w", encoding="utf-8", newline="\n").write("\n".join(L) + "\n")
