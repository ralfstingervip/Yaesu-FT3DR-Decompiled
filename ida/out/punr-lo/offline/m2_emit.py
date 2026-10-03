# M2: emit runs.tsv, proposed-demotions.tsv, proposed-rules.tsv. Read-only on inputs.
from pathlib import Path
REPO = Path(__file__).resolve().parents[4].as_posix()  # repository root
import sys, re, pickle, collections
sys.dont_write_bytecode = True
sys.path.insert(0, (REPO + "/ida/out/main-descent/offline"))
from common import IMG, bu, flow
from masks import A, RC, D, G1A
ROOT = (REPO + "/")
OUT = ROOT + "ida/out/punr-lo/"
H9 = "local-temp/"
RK = pickle.load(open(H9 + "descent.pkl", "rb"))["full"]["reached"]

RUNS = []
for ln in open(ROOT + "ida/out/l-wave-recon/proven-unreached-runs.tsv").read().splitlines():
    if ln.startswith("#") or ln.startswith("start"): continue
    c = ln.split("\t"); s = int(c[0], 16); e = int(c[1], 16)
    if s < 0x30000: RUNS.append((s, e))

def addend(s, e):
    t = []
    if sum(A[s:e]): t.append("A")
    if sum(RC[s:e]): t.append("RC")
    if sum(D[s:e]): t.append("D")
    if sum(G1A[s:e]): t.append("G1A")
    return "|".join(t)

def pred(s):
    for a in range(max(0, s - 10), s, 2):
        n, t = bu(a)
        if n and a + n == s: return a, t, (a in RK)
    return None

# verdicts (from m2_classify + m2_indirect: zero reached-head flow edge & zero pointer-to-start for all;
# 00932A has a reached-head indexed byte-load reader -> data).
DATA = {0x00932A}
# companions flagged by doc 99
COMP = {0x0076D8, 0x01C27E}

rows = []
for s, e in RUNS:
    p = pred(s)
    if s in DATA:
        v = "DATA-MISTYPED"; why = "reached 00929E 'mov.b @(0x932c:32,er4),r3l' reads run as byte table (er4 masked 0..0xFF @009298)"
    else:
        v = "DEAD"
        if p and p[1].split(" ", 1)[0] == "rts":
            why = "stub after reached rts @%06X; 0 inbound code edges whole-image" % p[0]
        elif p and p[1].startswith("bra"):
            why = "dead arm after reached %s; 0 inbound code edges whole-image" % p[1]
        else:
            why = "interior of a larger bra-skipped dead arm; 0 inbound code edges whole-image"
    rows.append((s, e, e - s, addend(s, e), v, ("companion(doc99)" if s in COMP else ""), why, IMG[s:min(e, s+16)].hex()))

with open(OUT + "runs.tsv", "w", encoding="utf-8", newline="\n") as f:
    f.write("# M2 lane: proven-unreached runs <0x030000 (29 runs, 368 B). Source list: ida/out/l-wave-recon/proven-unreached-runs.tsv.\n")
    f.write("# proving_rule: which analyze.py addend credits the run as proven (all = A: validated fnindex body INTERSECT items_before is_code, minus FNC).\n")
    f.write("# verdict: REACHED / DEAD / SPLIT-TAIL / DATA-MISTYPED / UNCERTAIN. Method: whole-image inbound scan (BE32/BE24/BE16 ptr-to-start,\n")
    f.write("# abs24 jsr/jmp, 8/16-bit rel branch+bsr, @(d,ERn), switch/jump tables, @@aa:8 vectors, RAM-cell addr-of, fall-through). All verified vs image.\n")
    f.write("start\tend_excl\tlen\tproving_rule\tverdict\ttag\twhy\tfirst_bytes\n")
    for s, e, n, ad, v, tag, why, fb in rows:
        f.write("%06X\t%06X\t%d\t%s\t%s\t%s\t%s\t%s\n" % (s, e, n, ad, v, tag, why, fb))

# proposed demotions: all 29 (DEAD -> demote from proven; DATA-MISTYPED -> demote + retype data)
dead = [(s, e, n) for s, e, n, ad, v, tag, why, fb in rows if v == "DEAD"]
data = [(s, e, n) for s, e, n, ad, v, tag, why, fb in rows if v == "DATA-MISTYPED"]
with open(OUT + "proposed-demotions.tsv", "w", encoding="utf-8", newline="\n") as f:
    f.write("# M2 proposed demotions from the MAIN proven mask (proposals only; no mask/seed rewritten).\n")
    f.write("# action: demote-proven = remove from proven (dead code, no inbound edge). retype-data = also retype as data (not code).\n")
    f.write("# DEAD runs: %d runs / %d B. DATA-MISTYPED: %d runs / %d B. Total %d runs / %d B.\n" %
            (len(dead), sum(x[2] for x in dead), len(data), sum(x[2] for x in data), len(rows), sum(x[2] for x in rows)))
    f.write("# Named/typed stays unchanged under the I12 convention (all 368 B are in final4/final6 named via the A addend).\n")
    f.write("start\tend_excl\tlen\taction\tverdict\n")
    for s, e, n, ad, v, tag, why, fb in rows:
        act = "demote-proven" if v == "DEAD" else "demote-proven+retype-data"
        f.write("%06X\t%06X\t%d\t%s\t%s\n" % (s, e, n, act, v))

with open(OUT + "proposed-rules.tsv", "w", encoding="utf-8", newline="\n") as f:
    f.write("# M2 proposed new descent rules to reach REACHED runs in this lane's scope.\n")
    f.write("# RESULT: none. Zero of the 29 runs is REACHED. Every run is a dead arm after an unconditional bra\n")
    f.write("# (or a stub after rts, or interior to such an arm), or a data table; none has any inbound code edge\n")
    f.write("# whole-image. The doc-99 er1-callback rule and the L4 abs24 rule do NOT reach any run here\n")
    f.write("# (no reached 'mov.l #T,er1; jsr @0x15206' nor reached abs24 jsr/jmp targets any run start <0x030000).\n")
    f.write("rule\tsites_added\tnote\n")
    f.write("(none)\t0\tno missing descent rule would reach any run in this scope\n")

print("DEAD %d/%dB  DATA %d/%dB  total %d/%dB" % (len(dead), sum(x[2] for x in dead), len(data), sum(x[2] for x in data), len(rows), sum(x[2] for x in rows)))
print("wrote runs.tsv, proposed-demotions.tsv, proposed-rules.tsv")
