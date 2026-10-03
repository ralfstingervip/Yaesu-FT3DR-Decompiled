# L2: whole-image inbound-reference scan for every fnindex-only run below 0x030000. Read-only.
from pathlib import Path as _Path
_REPO_S = _Path(__file__).resolve().parents[4].as_posix()
import sys, re, pickle, collections
sys.dont_write_bytecode = True
sys.path.insert(0, (_REPO_S + "/ida/out/main-descent/offline"))
import descent as D9
from common import IMG, HI, CW, be32, flow, bu
ROOT = (_REPO_S + "/")
SCR = r"local-temp"
P = pickle.load(open(SCR + "reach.pkl", "rb"))
rK, rN, runs = P["rK"], P["rN"], P["runs"]
RK, RN = rK["reached"], rN["reached"]
P4 = open(ROOT + "ida/out/main-final4/final4_proven_mask.bin", "rb").read()
N4 = open(ROOT + "ida/out/main-final4/final4_named_mask.bin", "rb").read()
INW = lambda x: CW[0] <= x < CW[1]
LIM = 0x30000
LO = [(s, e) for s, e in runs if s < LIM]
FNSEED = P["FNSEED"]; FN = P["FN"]

# owner head map for rK and rN
def ownmap(R):
    o = {}
    for a, (n, t, k) in R.items():
        for x in range(a, a + n): o[x] = a
    return o
OK, ON = ownmap(RK), ownmap(RN)
def site_class(a):
    if INW(a): return "window"
    if a in RN: return "reachedN-head"
    if a in ON: return "reachedN-mid"
    if a in RK: return "fnonly-head"
    if a in OK: return "fnonly-mid"
    if P4[a]: return "proven-unreached"
    if N4[a]: return "named-data/unproven"
    return "untyped"

HEX = re.compile(r"0x([0-9a-f]+)")
# decode-text index: value -> [(site, text)] for every even address (any operand constant)
DT = collections.defaultdict(list)
for a in range(0, HI, 2):
    n, t = bu(a)
    if not n: continue
    for m in HEX.finditer(t):
        v = int(m.group(1), 16)
        if v < LIM + 0x100: DT[v].append((a, t))
        elif v >= 0xFF8000 and ":16" in t: pass
# BE32 index over whole 1MB image (any byte offset)
B32 = collections.defaultdict(list)
for a in range(0, len(IMG) - 3):
    v = be32(a)
    if v < LIM + 0x100: B32[v].append(a)
    elif (v & 0xFFFFFF) < LIM + 0x100 and a < 0x400: B32[("m", v & 0xFFFFFF)].append(a)
B16 = collections.defaultdict(list)
for a in range(0, len(IMG) - 1):
    v = int.from_bytes(IMG[a:a + 2], "big")
    B16[v].append(a)

def predecessors(s):
    out = []
    for a in range(max(0, s - 10), s, 2):
        n, t = bu(a)
        if n and a + n == s: out.append((a, n, t, site_class(a)))
    return out

rows = []
with open(SCR + "refs_lo.txt", "w", encoding="utf-8") as f:
    for s, e in LO:
        heads = sorted(a for a in RK if s <= a < e)
        seeds_in = [a for a in heads if a in FNSEED]
        # origin chain
        a = s; seen = set()
        while a not in rK["seed"] and a in rK["pred"] and a not in seen:
            seen.add(a); a = rK["pred"][a]
        root = a; lab = rK["seed"].get(a, "?")
        f.write("=" * 100 + "\nRUN %06X-%06X len %d  root %06X <%s>  fnseeds-in-run %s\n" % (s, e, e - s, root, lab, " ".join("%06X(end %06X)" % (x, FN.get(x, 0)) for x in seeds_in)))
        f.write("bytes: %s\n" % IMG[s:e].hex())
        for p in predecessors(s):
            f.write("  pred %06X len %d '%s' [%s]\n" % p)
        f.write("  bytes before: %s\n" % IMG[max(0, s - 16):s].hex())
        for h in heads:
            n, t, k = RK[h]
            f.write("    %06X %-14s %s%s\n" % (h, IMG[h:h + n].hex(), t, "   <FNSEED>" if h in FNSEED else ""))
        # successor
        f.write("  after: %06X %s [%s]\n" % (e, IMG[e:e + 8].hex(), site_class(e)))
        # refs
        hs = set(heads)
        nref = 0
        for v in range(s, e):
            for site in B32.get(v, []):
                pre = IMG[site - 2:site].hex() if site >= 2 else ""
                f.write("  BE32 ->%06X%s at %06X pre=%s [%s]%s\n" % (v, "" if v in hs else " (non-head)", site, pre, site_class(site), " vec" if site < 0x400 else ""))
                nref += 1
            for site in B32.get(("m", v), []):
                f.write("  BE32m ->%06X at %06X raw %08X [%s]\n" % (v, site, be32(site), site_class(site))); nref += 1
            for site, t in DT.get(v, []):
                f.write("  DEC ->%06X%s at %06X '%s' [%s]\n" % (v, "" if v in hs else " (non-head)", site, t, site_class(site))); nref += 1
            if v < 0x8000 and v == s:
                for site in [z for z in B16.get(v, []) if z % 2 == 0]:
                    f.write("  BE16 ->%06X at %06X [%s]\n" % (v, site, site_class(site)))
        f.write("  total BE32/DEC refs into run: %d\n" % nref)
print("done", len(LO), sum(e - s for s, e in LO))
