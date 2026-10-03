from pathlib import Path as _Path
_REPO = _Path(__file__).resolve().parents[4]
# H9: breakdowns for the write-up (read-only). Writes work/breakdown.txt
import sys, pickle, collections
sys.dont_write_bytecode = True
sys.path.insert(0, str(_REPO) + r"/ida/out/main-descent/offline")
from analyze import *
res = pickle.load(open(SCR + "descent.pkl", "rb"))
IM = bytearray(HI)
for a, (n, t, k) in res["inferred"]["reached"].items():
    for x in range(a, min(HI, a + n)): IM[x] = 1
be = collections.defaultdict(list)
for o in range(0, HI - 3, 2): be[be32(o)].append(o)
O = []
def p(*a): O.append(" ".join(str(x) for x in a))
# 1 RC code-structural split
c = collections.Counter()
for s, e, ad, cl, h in demoted:
    if cl != "code-structural": continue
    k = "inferred-reached" if sum(IM[s:e]) * 2 >= e - s else ("be32-hit-even" if be.get(s) else "no-ref")
    c[(ad, k)] += e - s
p("code-structural split", dict(c))
# 2 D demotion by reason
WEAKS = {"000E20","006040","023602","02556E","029DF4","032D8E","032E8E","038104","0382BE","03FEDC","06AC14","001FE0","002020","005050","034644","046B84","04AAAA"}
H2T = {"000760","000800","001740"}; B24 = {"01BF28","06DBE0"}
moves = set()
for ln in open(R + "h8sx-seed/changes.tsv", encoding="utf-8").read().splitlines()[1:]:
    q = ln.split("\t")
    if q[0] == "entry" and q[1] in ("move_func_start", "generic_move_func_start"): moves.add(q[2])
for ln in open(R + "h8sx-seed/work/seedxref_slot_overlaps.tsv", encoding="utf-8").read().splitlines()[1:]:
    pass
dr = collections.Counter(); drows = collections.defaultdict(int)
for s, e, ad, cl, h in demoted:
    if ad != "D": continue
    row = DROW.get(s)
    k = "weak-714" if row in WEAKS else "H2-data-table" if row in H2T else "BE24-survivor" if row in B24 else "H2-entry-move" if row in moves else "other-row"
    dr[(k, cl)] += e - s; drows[(k, row)] += e - s
p("D demoted by reason/class", dict(dr))
p("D demoted rows", {"%s %s" % k: v for k, v in sorted(drows.items())})
# 3 weak rows
wk = [r for r in rows if r[0] in WEAKS | H2T | B24]
for o, s_, e_, n, rb, sb, org, note, act in wk: p("row", o, "%06X-%06X" % (s_, e_), n, "reached", rb, "strict", sb, org)
p("weak-714 total", sum(r[3] for r in wk if r[0] in WEAKS), "reached", sum(r[4] for r in wk if r[0] in WEAKS))
# 4 H3 PROVEN-PTR / REACHED-OVERSPLIT / H5
H3P = [(0x00919E,0x009246),(0x00DB58,0x00DB5E),(0x01026E,0x010276),(0x0174EA,0x01750A),(0x01EED0,0x01EEF6),(0x0237AA,0x023812),(0x034532,0x034534),(0x035092,0x0350C0),(0x053686,0x05369A),(0x05B3AE,0x05B3C8),(0x05C436,0x05C44C),(0x063F4A,0x063F84),(0x073172,0x0731C0)]
tot = sum(e - s for s, e in H3P); rch = sum(sum(RM[s:e]) for s, e in H3P)
inPU = sum(1 for s, e in H3P for x in range(s, e) if PU[x]); newb = sum(1 for s, e in H3P for x in range(s, e) if NEWP(x))
g1 = sum(1 for s, e in H3P for x in range(s, e) if F[x] or G1A[x] or E[x] or B[x])
p("H3 PROVEN-PTR ranges", tot, "reached", rch, "already in a proven addend", inPU, "in new-proven", newb, "credited in named (F/E/B)", g1)
for s, e in H3P: p("  H3", "%06X-%06X" % (s, e), e - s, "reached", sum(RM[s:e]), "new", sum(1 for x in range(s, e) if NEWP(x)))
for a in (0x010556, 0x033180, 0x033448, 0x04723C, 0x067370, 0x06B2C2, 0x06FDC2, 0x073C66):
    p("  H3 REACHED-OVERSPLIT start %06X reached=%d" % (a, RM[a]))
p("H5 F00A 0x85DA-0x8622 reached", sum(RM[0x85DA:0x8622]), "new", sum(1 for x in range(0x85DA, 0x8622) if NEWP(x)))
p("H5 F280 0x9534-0x9562 reached", sum(RM[0x9534:0x9562]))
p("NMI 0x267C reached", RM[0x267C], "0x7FF6 reached", RM[0x7FF6])
# 5 new-proven by where
resid = []
for ln in open(R + "main-indirect/residual.tsv", encoding="utf-8").read().splitlines()[1:]:
    q = ln.split("\t"); resid.append((int(q[0], 16), int(q[1], 16)))
RS = bytearray(HI)
for s, e in resid:
    for x in range(s, e): RS[x] = 1
FNall = bytearray(HI)
for f in ["main-low", "main-high-a", "main-high-b"]:
    L = open(R + "fnindex/%s.tsv" % f, encoding="utf-8").read().splitlines(); h = L[0].split("\t")
    for ln in L[1:]:
        q = dict(zip(h, ln.split("\t")))
        if q["validated"] != "yes":
            for x in range(int(q["start"], 16), int(q["end"], 16)): FNall[x] = 1
w = collections.Counter()
for x in range(HI):
    if NEWP(x):
        k = ("named" if NAMED[x] else "unnamed") + "/" + ("F1-residual" if RS[x] else "fnindex-unvalidated" if FNall[x] else (runtype(x) or "IDA-code-no-fn"))
        w[k] += 1
p("new-proven by location", dict(w))
# 6 A / G1A unreached (informative, not applied)
p("A bytes unreached", sum(1 for x in range(HI) if A[x] and not RM[x] and not INW(x)), "of", S(A))
p("G1A bytes unreached", sum(1 for x in range(HI) if G1A[x] and not RM[x] and not INW(x)), "of", S(G1A))
p("strict (roots only) reached", sum(1 for x in range(HI) if RM[x] and STRICT[x]), "of full", S(RM))
p("unresolved jmp/jsr @ERn sites in reached code", sum(1 for a, (n, t, k) in R_.items() if re.match(r"^(jmp|jsr) @er\d$", t)))
open(OUT + "work/breakdown.txt", "w", encoding="utf-8", newline="\n").write("\n".join(O) + "\n")
print("\n".join(O))
