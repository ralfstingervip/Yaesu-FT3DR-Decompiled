# M2: classify each proven-unreached run <0x030000. Read-only.
# For each run: predecessor (insn ending at run start), reached-HEAD flow edges into the run,
# reached-HEAD data-loads referencing the run, and whether the byte after the run is reached code.
from pathlib import Path
REPO = Path(__file__).resolve().parents[4].as_posix()  # repository root
import sys, re, pickle, collections
sys.dont_write_bytecode = True
sys.path.insert(0, (REPO + "/ida/out/main-descent/offline"))
from common import IMG, HI, CW, be32, bu, flow
ROOT = (REPO + "/")
H9 = "local-temp/"
DESC = pickle.load(open(H9 + "descent.pkl", "rb"))
FULL = DESC["full"]; RK = FULL["reached"]            # reached instruction HEADS -> (n,text,kind)
OWN = {}
for a, (n, t, k) in RK.items():
    for x in range(a, a + n): OWN[x] = a
P4 = open(ROOT + "ida/out/main-final4/final4_proven_mask.bin", "rb").read()
N4 = open(ROOT + "ida/out/main-final4/final4_named_mask.bin", "rb").read()
INW = lambda x: CW[0] <= x < CW[1]

RUNS = []
for ln in open(ROOT + "ida/out/l-wave-recon/proven-unreached-runs.tsv").read().splitlines():
    if ln.startswith("#") or ln.startswith("start"): continue
    c = ln.split("\t"); s = int(c[0], 16); e = int(c[1], 16)
    if s < 0x30000: RUNS.append((s, e))
RUNSET = {}
for s, e in RUNS:
    for x in range(s, e): RUNSET[x] = (s, e)

# Build all reached-HEAD flow edges across the whole image from the binutils oracle.
# A reached head is a genuine instruction; compute its direct flow targets (branch/jsr/jmp/bsr/fall).
flow_into = collections.defaultdict(list)   # run_start -> [(src, kind, tgt, text)]
data_into = collections.defaultdict(list)   # run_start -> [(src, text, tgt)]
HEXP = re.compile(r"0x([0-9a-f]+)")
MEMLOAD = re.compile(r"\b(mov|movfpe|movtpe|add|sub|cmp|or|and|xor|bset|bclr|btst|ldc|stc|mulxu|divxu)\b")
for a in RK:
    n, t, k = RK[a]
    # direct branch/call targets from the oracle flow()
    fn, ft, fk, tgts = flow(a)
    for tg in tgts:
        if tg in RUNSET:
            flow_into[RUNSET[tg][0]].append((a, fk, tg, ft))
    # fall-through: if this insn is 'normal'/'cond'/'call'/'stops' it also falls to a+n
    if fk in ("normal", "cond", "call", "stops") and (a + n) in RUNSET:
        flow_into[RUNSET[a + n][0]].append((a, "fall", a + n, t))
    # data references: any operand constant (not a branch target) that lands in a run
    m0 = t.split(" ", 1)[0]
    is_branch = m0 in ("bra", "bra/s", "brn", "jmp", "jsr", "bsr") or (m0.startswith("b") and "." in t)
    for mm in HEXP.finditer(t):
        v = int(mm.group(1), 16)
        if v in RUNSET and not (is_branch):
            data_into[RUNSET[v][0]].append((a, t, v))

def pred_of(s):
    for a in range(max(0, s - 10), s, 2):
        n, t = bu(a)
        if n and a + n == s:
            fn, ft, fk, tg = flow(a)
            reached = a in RK
            return (a, ft, fk, reached)
    return None

def site(a):
    if INW(a): return "window"
    if a in RK: return "reached-head"
    if a in OWN: return "reached-mid"
    if P4[a]: return "proven-unreached"
    if N4[a]: return "named"
    return "untyped"

print("run       len pred                               after        flowIN(reached-head)            dataIN(reached-head)")
for s, e in RUNS:
    p = pred_of(s)
    ps = "none"
    if p:
        ps = "%06X %-22s r=%d" % (p[0], p[1][:22], p[3])
    aft = "%06X[%s]" % (e, site(e))
    fin = flow_into.get(s, [])
    din = data_into.get(s, [])
    fins = ";".join("%06X %s->%06X(%s)" % (x[0], x[1], x[2], x[3].split(' ',1)[0]) for x in fin) or "-"
    dins = ";".join("%06X %s" % (x[0], x[1].split(' ',1)[0]) for x in din) or "-"
    print("%06X-%06X %3d %-34s %-12s %-30s %s" % (s, e, e - s, ps, aft, fins, dins))
