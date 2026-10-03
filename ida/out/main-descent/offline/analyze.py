from pathlib import Path as _Path
_REPO = _Path(__file__).resolve().parents[4]
# H9: re-measure recovered-code runs and F1 rows against the H9 descent; write reached/demoted/ledger-delta tables.
import sys, pickle, collections
sys.dont_write_bytecode = True
sys.path.insert(0, str(_REPO) + r"/ida/out/main-descent/offline")
from common import *
from masks import A, B, D, E, F, G1A, RC, RC0, HH, ODD_BIN, ODD_ASC, PRH1, F1ROWS, DROW, S
import classify
from classify import classify_span, lin

res = pickle.load(open(SCR + "descent.pkl", "rb"))
FULL = res["full"]; R_ = FULL["reached"]; SEED = FULL["seed"]; PRED = FULL["pred"]
classify.REACHED_INSN.update(R_)
INW = lambda x: CW[0] <= x < CW[1]
RM = bytearray(HI); OWN = {}
for a, (n, t, k) in R_.items():
    for x in range(a, min(HI, a + n)):
        if not INW(x): RM[x] = 1; OWN[x] = a
STRICT = bytearray(HI)
for a, (n, t, k) in res["strict"]["reached"].items():
    for x in range(a, min(HI, a + n)): STRICT[x] = 1
for x in range(*CW): STRICT[x] = 0
# H1 reach restricted to the same scope
for x in range(*CW): PRH1[x] = 0

def origin(a):
    """walk first-predecessor links back to a seed; return (seed, label, hops)"""
    seen = set(); h = 0
    while a not in SEED and a in PRED and a not in seen:
        seen.add(a); a = PRED[a]; h += 1
    if a in SEED: return a, SEED[a], h
    # fall-through predecessor: walk back over reached instructions
    return a, "?", h

def spans(pred_fn, lo=0, hi=HI):
    out = []; x = lo
    while x < hi:
        if pred_fn(x):
            s = x
            while x < hi and pred_fn(x): x += 1
            out.append((s, x))
        else: x += 1
    return out

# ------------------------------------------------------------------ proven sets
PU = bytearray(HI)          # H1 proven union (mask basis)
for x in range(HI):
    if A[x] or RC[x] or D[x] or G1A[x]: PU[x] = 1
NAMED = bytearray(HI)
for x in range(HI):
    if A[x] or B[x] or D[x] or E[x] or F[x] or HH[x]: NAMED[x] = 1

# ------------------------------------------------------------------ RC re-measure
for x in range(*CW): RC0[x] = 0   # closed window: not re-measured (bytes there keep their H1 status)
rc_tot = S(RC0)
rc_h1_un = sum(1 for x in range(HI) if RC0[x] and not PRH1[x])
rc_h9_un = sum(1 for x in range(HI) if RC0[x] and not RM[x])
rc_new = sum(1 for x in range(HI) if RC0[x] and RM[x] and not PRH1[x])
rc_lost = sum(1 for x in range(HI) if RC0[x] and PRH1[x] and not RM[x])

# classify every unreached RC byte that is still in the RC addend (i.e. not already removed by H1's odd-head pass)
RCU = lambda x: RC[x] and not RM[x] and not A[x] and not D[x] and not G1A[x] and not INW(x)
cls = {}
for s, e in spans(lambda x: RC0[x] and not RM[x]):
    cls.update(classify_span(s, e))
# IDA h8sxa (H9_DESCENT) data xrefs (dr_O=1, dr_W=2, dr_R=3) from reached instructions into probe spans:
# a code-structural run that reached code reads or takes the address of is data, not code.
DREF = set()
_rp = OUT + "work/ida_span_refs.tsv"
if os.path.exists(_rp):
    for ln in open(_rp, encoding="utf-8").read().splitlines()[1:]:
        c_ = ln.split("	")
        if c_[6] == "-": continue
        for r_ in c_[6].split(","):
            f_, t_ = r_.split(":")
            if int(t_) in (1, 2, 3) and int(f_, 16) in R_: DREF.add(int(c_[2], 16))
def dref_fix(cl):
    xs = sorted(x for x, c in cl.items() if c == "code-structural")
    i = 0
    while i < len(xs):
        j = i
        while j + 1 < len(xs) and xs[j + 1] == xs[j] + 1: j += 1
        if any(x in DREF for x in range(xs[i], xs[j] + 1)):
            for x in range(xs[i], xs[j] + 1): cl[x] = "data-referenced"
        i = j + 1
dref_fix(cls)
demoted = []      # (start, end, addend, class, h1_reached, note)
for s, e in spans(RCU):
    # split by class and by H1 reach
    x = s
    while x < e:
        c = cls.get(x, "junk"); h = PRH1[x]; y = x
        while y < e and cls.get(y, "junk") == c and PRH1[y] == h: y += 1
        demoted.append((x, y, "RC", c, h))
        x = y
# ------------------------------------------------------------------ D (F1 rows) re-measure
DU = lambda x: D[x] and not RM[x] and not A[x] and not RC[x] and not G1A[x] and not INW(x)
dcls = {}
for s, e in spans(lambda x: D[x] and not RM[x]):
    dcls.update(classify_span(s, e))
dref_fix(dcls)
for s, e in spans(DU):
    x = s
    while x < e:
        c = dcls.get(x, "junk"); h = PRH1[x]; row = DROW.get(x); y = x
        while y < e and dcls.get(y, "junk") == c and PRH1[y] == h and DROW.get(y) == row: y += 1
        demoted.append((x, y, "D", c, h))
        x = y

# ------------------------------------------------------------------ newly proven (reached, not in any proven addend)
NEWP = lambda x: RM[x] and not PU[x]
newp = spans(NEWP)

# ------------------------------------------------------------------ F1 rows, weak proofs and lane inputs
WEAK = {"000E20", "006040", "023602", "02556E", "029DF4", "032D8E", "032E8E", "038104", "0382BE", "03FEDC", "06AC14",
        "001FE0", "002020", "005050", "034644", "046B84", "04AAAA"}
EXTRA = {"01BF28": "BE24 odd (H3 survived)", "06DBE0": "BE24 odd (H3 survived)", "000760": "H2 data table 00F020",
         "000800": "H2 data table 01DE24", "001740": "H2 data table 00F068"}
rows = []
for c in F1ROWS:
    o = c["orig_start"]
    s = int(c["start"], 16); e = int(c["end"], 16)
    rb = sum(RM[s:e])
    first = next((x for x in range(s, e) if RM[x]), None)
    org = ""
    if first is not None:
        a0 = OWN[first]; sd, lab, h = origin(a0)
        org = "%06X <- %s (%d hops)" % (a0, lab, h)
    rows.append((o, s, e, e - s, rb, sum(1 for x in range(s, e) if STRICT[x]), org,
                 "weak-714" if o in WEAK else EXTRA.get(o, ""), c["h1_action"]))

# ------------------------------------------------------------------ ledger
H1_PROVEN = 375469
d_dc28 = -28
d_dc224 = -sum(1 for x in range(HI) if RC[x] and G1A[x])
d_rc = -sum(1 for x in range(HI) if RCU(x))
d_d = -sum(1 for x in range(HI) if DU(x))
d_new = sum(1 for x in range(HI) if NEWP(x))
NEW_PROVEN = H1_PROVEN + d_dc28 + d_dc224 + d_rc + d_d + d_new
chk = sum(1 for x in range(HI) if (PU[x] and not RCU(x) and not DU(x)) or NEWP(x))
assert chk == NEW_PROVEN, (chk, NEW_PROVEN)

# named/typed: RC unreached text/table/fill/wellformed stay typed; RC junk -> 'other' (leaves); D unreached:
# text/table/fill retyped (stay); D well-formed code and junk leave (unvalidated function bytes are not credited);
# reached bytes outside every named mask join.
def leaves(st, en, addend, c):
    if addend == "RC": return c == "junk"
    return c in ("junk", "code-structural")
n_leave = collections.Counter(); n_stay = collections.Counter()
for s, e, ad, c, h in demoted:
    for x in range(s, e):
        if NAMED[x] and (B[x] if ad == "RC" else True):
            other = (A[x] or E[x] or F[x] or HH[x] or (ad == "D" and B[x]))
            if leaves(s, e, ad, c) and not other: n_leave[(ad, c)] += 1
            else: n_stay[(ad, c)] += 1
n_join = sum(1 for x in range(HI) if RM[x] and not NAMED[x])
H1_NAMED = 492708
NEW_NAMED = H1_NAMED - sum(n_leave.values()) + n_join

if __name__ == "__main__":
    os.makedirs(OUT, exist_ok=True)
    cnt = collections.Counter(); cnt_h1 = collections.Counter()
    for s, e, ad, c, h in demoted: cnt[(ad, c)] += e - s; cnt_h1[(ad, c, h)] += e - s
    # reached.tsv
    with open(OUT + "reached.tsv", "w", encoding="utf-8", newline="\n") as f:
        f.write("# H9 full descent. kind: rc-new = recovered-code bytes reached by H9 and not by H1; new-proven = reached bytes in no proven addend\n")
        f.write("# (A fnindex, RC recovered code, D F1, G1 tier A); f1-row = per-row reach of every proved-corrected row. origin = first reached insn <- seed/edge label.\n")
        f.write("kind\tstart\tend\tbytes\treached_bytes\tstrict_bytes\tin_named\tw2_8_type\torigin\tnote\tfirst_bytes\n")
        for s, e in spans(lambda x: RC0[x] and RM[x] and not PRH1[x]):
            sd, lab, h = origin(OWN[s])
            f.write("rc-new\t%06X\t%06X\t%d\t%d\t%d\t%d\t%s\t%06X <- %s\t\t%s\n" % (s, e, e - s, e - s, sum(STRICT[s:e]), sum(NAMED[s:e]), runtype(s), OWN[s], lab, IMG[s:min(e, s + 12)].hex()))
        for s, e in newp:
            sd, lab, h = origin(OWN[s])
            f.write("new-proven\t%06X\t%06X\t%d\t%d\t%d\t%d\t%s\t%06X <- %s\t\t%s\n" % (s, e, e - s, e - s, sum(STRICT[s:e]), sum(NAMED[s:e]), runtype(s) or "-", OWN[s], lab, IMG[s:min(e, s + 12)].hex()))
        for o, s, e, n, rb, sb, org, note, act in rows:
            f.write("f1-row\t%06X\t%06X\t%d\t%d\t%d\t%d\t-\t%s\t%s\t%s\n" % (s, e, n, rb, sb, sum(NAMED[s:e]), org or "UNREACHED", ("orig " + o + " " + note + " " + act).strip(), IMG[s:min(e, s + 12)].hex()))
    with open(OUT + "demoted.tsv", "w", encoding="utf-8", newline="\n") as f:
        f.write("# H9: bytes credited as proven code by H1 (RC = recovered-code runs, D = F1 proved-corrected rows) that the H9 descent does not reach.\n")
        f.write("# class from bytes: text (printable run >=4 + terminator), fill (FF FF), table (>=half pointer-like BE32), code-wellformed (oracle linear decode clean to a stop), junk.\n")
        f.write("# h1_reached=1: H1's descent reached these bytes, but only through a table row H2 excluded as data.\n")
        f.write("start\tend\tbytes\taddend\tclass\th1_reached\tf1_row\tnamed_after\tfirst_bytes\n")
        for s, e, ad, c, h in demoted:
            f.write("%06X\t%06X\t%d\t%s\t%s\t%d\t%s\t%s\t%s\n" % (s, e, e - s, ad, c, h, DROW.get(s, "-") if ad == "D" else "-",
                    "leaves" if leaves(s, e, ad, c) else "stays (retyped/typed)", IMG[s:min(e, s + 16)].hex()))
    L = []
    def row(k, v, src, note=""): L.append("%s\t%s\t%s\t%s" % (k, v, src, note))
    row("RC_bytes_w2_8", rc_tot, "wave2/main-raw-types.tsv type=recovered code")
    row("RC_unreached_H1", rc_h1_un, "H1 reach.pkl (recount/offline/reach.py)", "H1 open-measure 16,784")
    row("RC_unreached_H9", rc_h9_un, "H9 full descent")
    row("RC_newly_reached_H9", rc_new, "H9 not H1", "array/RAM-cell edges")
    row("RC_lost_vs_H1", rc_lost, "H1 not H9", "H1 reached these only via table rows now excluded as data (H2 306 rows + H9 6 tables)")
    for k, v in sorted(cnt.items()): row("demoted_%s_%s" % k, v, "demoted.tsv")
    for k, v in sorted(cnt_h1.items()): row("demoted_%s_%s_h1reached%d" % k, v, "demoted.tsv")
    row("proven_H1", H1_PROVEN, "recount/recount.tsv MAIN_proven_H1")
    row("delta_doc33_28B_in_A", d_dc28, "A published basis vs mask", "A mask already excludes the 28 B (typed runs, not is_code)")
    row("delta_RC_x_G1A_overlap", d_dc224, "RC mask & G1 tier-A mask", "0x02F2E0-0x02F35E, 0x030E00-0x030E62 counted twice")
    row("delta_RC_unreached", d_rc, "demoted.tsv addend=RC")
    row("delta_D_unreached", d_d, "demoted.tsv addend=D")
    row("delta_new_proven", d_new, "reached.tsv kind=new-proven")
    row("proven_H9", NEW_PROVEN, "sum; checked against byte union", "%.2f%% of 505,684 content" % (100 * NEW_PROVEN / 505684))
    row("named_H1", H1_NAMED, "recount/recount.tsv MAIN_named_or_typed_H1")
    for k, v in sorted(n_leave.items()): row("named_leave_%s_%s" % k, -v, "demoted.tsv named_after=leaves")
    row("named_join_reached_uncredited", n_join, "reached, outside every named mask")
    row("named_H9", NEW_NAMED, "", "%.2f%% of 505,684" % (100 * NEW_NAMED / 505684))
    open(OUT + "work/ledger_raw.tsv", "w", encoding="utf-8", newline="\n").write("metric\tvalue\tsource\tnote\n" + "\n".join(L) + "\n")
    print("\n".join(L))
    pickle.dump(dict(cls=cls, dcls=dcls, demoted=demoted, newp=newp, rows=rows), open(SCR + "analyze.pkl", "wb"))
