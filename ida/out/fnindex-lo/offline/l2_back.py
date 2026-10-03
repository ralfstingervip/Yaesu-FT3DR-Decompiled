# L2: backward closure from each fnindex-only run (<0x30000) over flow edges from IDA-code / proven sites,
# collecting every non-flow reference (immediate / BE32 / table) and every flow edge from reachedN code.
from pathlib import Path as _Path
_REPO_S = _Path(__file__).resolve().parents[4].as_posix()
import sys, re, pickle, collections
sys.dont_write_bytecode = True
sys.path.insert(0, (_REPO_S + "/ida/out/main-descent/offline"))
from common import IMG, HI, CW, be32, flow, bu
ROOT = (_REPO_S + "/")
SCR = r"local-temp"
P = pickle.load(open(SCR + "reach.pkl", "rb"))
RK, RN, runs = P["rK"]["reached"], P["rN"]["reached"], P["runs"]
P4 = open(ROOT + "ida/out/main-final4/final4_proven_mask.bin", "rb").read()
CM = open(ROOT + "ida/out/main-final4/MAIN_FINAL4_codemask.bin", "rb").read()
INW = lambda x: CW[0] <= x < CW[1]
ON = {}
for a, (n, t, k) in RN.items():
    for x in range(a, a + n): ON[x] = a
HEX = re.compile(r"0x([0-9a-f]+)")
FLOWREF = collections.defaultdict(list)    # target -> [(site, kind)] direct flow from decodes
IMMREF = collections.defaultdict(list)     # value -> [(site, text)] non-flow constants
for a in range(0, HI, 2):
    n, t, k, tg = flow(a)
    if not n: continue
    for x in tg: FLOWREF[x].append((a, k))
    if k in ("normal", "call", "cond", "stop", "stops") and not tg:
        for m in HEX.finditer(t):
            v = int(m.group(1), 16)
            if 0x400 <= v < HI: IMMREF[v].append((a, t))
    elif k == "normal":
        pass
    if k == "normal":
        for m in HEX.finditer(t):
            v = int(m.group(1), 16)
            if 0x400 <= v < HI and (a, t) not in IMMREF[v]: IMMREF[v].append((a, t))
B32 = collections.defaultdict(list)
for a in range(0, len(IMG) - 3):
    v = be32(a)
    if 0x400 <= v < HI: B32[v].append(a)

def isreal(a):   # site counts as code for the closure
    return CM[a] or P4[a] or a in RK
def cls(a):
    if INW(a): return "window"
    if a in RN: return "RN"
    if a in ON: return "RN-mid"
    if a in RK: return "fnonly"
    if P4[a]: return "proven-unreached"
    if CM[a]: return "idacode-unproven"
    return "data/untyped"

out = open(SCR + "back_lo.txt", "w", encoding="utf-8")
SUMMARY = {}
for s, e in runs:
    if s >= 0x30000: continue
    nodes = set(a for a in RK if s <= a < e)
    work = list(nodes); seen = set(work); flow_in = []; nonflow = []; frontier_dead = []
    steps = 0
    while work and steps < 4000:
        steps += 1
        x = work.pop()
        # non-flow references to x
        for site, t in IMMREF.get(x, []):
            nonflow.append((x, site, t, cls(site)))
        for site in B32.get(x, []):
            nonflow.append((x, site, "BE32 pre=%s" % IMG[site - 2:site].hex(), cls(site)))
        preds = list(FLOWREF.get(x, []))
        for a in range(max(0, x - 10), x, 2):
            n, t, k, tg = flow(a)
            if n and a + n == x and k not in ("stop", "stops", "bad"): preds.append((a, "fall"))
        for site, k in preds:
            c = cls(site)
            if c in ("RN", "RN-mid"):
                flow_in.append((x, site, k, c)); continue
            if not isreal(site):
                continue
            if site in nodes or site in seen: continue
            seen.add(site); work.append(site)
    # summarize closure as runs of addresses
    cl = sorted(seen)
    out.write("=" * 90 + "\nRUN %06X-%06X len %d: closure %d insns, steps %d\n" % (s, e, e - s, len(cl), steps))
    # compress closure
    segs = []
    for a in cl:
        if segs and a - segs[-1][1] <= 6: segs[-1][1] = a
        else: segs.append([a, a])
    out.write("  closure segs: %s\n" % " ".join("%06X-%06X(%s)" % (a, b, cls(a)) for a, b in segs))
    for r in flow_in: out.write("  FLOW-FROM-RN into %06X from %06X %s [%s]\n" % r)
    for r in nonflow: out.write("  NONFLOW to %06X at %06X '%s' [%s]\n" % r)
    SUMMARY[(s, e)] = dict(closure=cl, flow_in=flow_in, nonflow=nonflow)
pickle.dump(SUMMARY, open(SCR + "back_lo.pkl", "wb"))
print("ok")
