# M2: whole-image inbound-reference scan for the 29 proven-unreached runs below 0x030000. Read-only.
# Reuses L2's l2_refs index machinery (BE32 / decode-text / BE16 whole-image indexes) but drives it off
# the proven-unreached run list and H9's full folded descent (descent.pkl full/reached) as the reached set.
from pathlib import Path
REPO = Path(__file__).resolve().parents[4].as_posix()  # repository root
import sys, re, pickle, collections
sys.dont_write_bytecode = True
sys.path.insert(0, (REPO + "/ida/out/main-descent/offline"))
from common import IMG, HI, CW, be32, bu
ROOT = (REPO + "/")
H9 = "local-temp/"
OUT = ROOT + "ida/out/punr-lo/"
DESC = pickle.load(open(H9 + "descent.pkl", "rb"))
FULL = DESC["full"]; RK = FULL["reached"]; SEED = FULL["seed"]; PRED = FULL["pred"]
P4 = open(ROOT + "ida/out/main-final4/final4_proven_mask.bin", "rb").read()
N4 = open(ROOT + "ida/out/main-final4/final4_named_mask.bin", "rb").read()
INW = lambda x: CW[0] <= x < CW[1]
LIM = 0x30000

# run list: proven-unreached runs with start < 0x030000
RUNS = []
for ln in open(ROOT + "ida/out/l-wave-recon/proven-unreached-runs.tsv").read().splitlines():
    if ln.startswith("#") or ln.startswith("start"): continue
    c = ln.split("\t"); s = int(c[0], 16); e = int(c[1], 16)
    if s < LIM: RUNS.append((s, e))

# reached owner-map
OWN = {}
for a, (n, t, k) in RK.items():
    for x in range(a, a + n): OWN[x] = a
# verify unreached
bad = [(s, e) for s, e in RUNS if any(x in RK or x in OWN for x in range(s, e))]
print("runs", len(RUNS), "bytes", sum(e - s for s, e in RUNS), "any-reached:", len(bad))
for s, e in bad: print("  REACHED-in-full!", "%06X-%06X" % (s, e))

def site_class(a):
    if INW(a): return "window"
    if a in RK: return "reached-head"
    if a in OWN: return "reached-mid"
    if P4[a]: return "proven-unreached"
    if N4[a]: return "named-data/unproven"
    return "untyped"

HEX = re.compile(r"0x([0-9a-f]+)")
DT = collections.defaultdict(list)       # value -> [(site, text)] from any operand constant, even addrs
for a in range(0, HI, 2):
    n, t = bu(a)
    if not n: continue
    for m in HEX.finditer(t):
        v = int(m.group(1), 16)
        if v < LIM + 0x100: DT[v].append((a, t))
B32 = collections.defaultdict(list)      # BE32 at every byte offset of the whole image
for a in range(0, len(IMG) - 3):
    v = be32(a)
    if v < LIM + 0x100: B32[v].append(a)
    elif (v & 0xFFFFFF) < LIM + 0x100 and a < 0x400: B32[("m", v & 0xFFFFFF)].append(a)
B16 = collections.defaultdict(list)
for a in range(0, len(IMG) - 1):
    v = int.from_bytes(IMG[a:a + 2], "big"); B16[v].append(a)

def predecessors(s):
    out = []
    for a in range(max(0, s - 10), s, 2):
        n, t = bu(a)
        if n and a + n == s: out.append((a, n, t, site_class(a)))
    # also odd-aligned fall-through (H8SX insns can be odd-length so predecessor may be odd? no, insns are even)
    return out

with open(OUT + "inbound-scan.txt", "w", encoding="utf-8", newline="\n") as f:
    for s, e in RUNS:
        f.write("=" * 100 + "\nRUN %06X-%06X len %d\n" % (s, e, e - s))
        f.write("bytes: %s\n" % IMG[s:e].hex())
        f.write("bytes before: %s\n" % IMG[max(0, s - 16):s].hex())
        for p in predecessors(s):
            f.write("  pred %06X len %d '%s' [%s]\n" % p)
        f.write("  after: %06X %s [%s]\n" % (e, IMG[e:e + 8].hex(), site_class(e)))
        nref = 0
        for v in range(s, e):
            for site in B32.get(v, []):
                pre = IMG[site - 2:site].hex() if site >= 2 else ""
                f.write("  BE32 ->%06X%s at %06X pre=%s [%s]%s\n" % (v, "" if v == s else " (mid)", site, pre, site_class(site), " vec" if site < 0x400 else "")); nref += 1
            for site in B32.get(("m", v), []):
                f.write("  BE32m ->%06X at %06X raw %08X [%s] vec\n" % (v, site, be32(site), site_class(site))); nref += 1
            for site, t in DT.get(v, []):
                f.write("  DEC ->%06X%s at %06X '%s' [%s]\n" % (v, "" if v == s else " (mid)", site, t, site_class(site))); nref += 1
            if v < 0x8000 and v == s:
                for site in [z for z in B16.get(v, []) if z % 2 == 0]:
                    f.write("  BE16 ->%06X at %06X [%s]\n" % (v, site, site_class(site)))
        f.write("  total BE32/DEC refs into run: %d\n" % nref)
print("wrote", OUT + "inbound-scan.txt")
