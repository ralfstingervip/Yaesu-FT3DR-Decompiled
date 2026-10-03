# M2: check indirect inbound edges into each run START: switch/jump tables, BE32/BE24/BE16 pointers,
# @@aa:8 memory-indirect vectors, RAM-cell callbacks (doc 60). Read-only.
from pathlib import Path
REPO = Path(__file__).resolve().parents[4].as_posix()  # repository root
import sys, pickle, collections
sys.dont_write_bytecode = True
sys.path.insert(0, (REPO + "/ida/out/main-descent/offline"))
from common import IMG, HI, be32
ROOT = (REPO + "/")
H9 = "local-temp/"
RK = pickle.load(open(H9 + "descent.pkl", "rb"))["full"]["reached"]

RUNS = []
for ln in open(ROOT + "ida/out/l-wave-recon/proven-unreached-runs.tsv").read().splitlines():
    if ln.startswith("#") or ln.startswith("start"): continue
    c = ln.split("\t"); s = int(c[0], 16); e = int(c[1], 16)
    if s < 0x30000: RUNS.append((s, e))
STARTS = {s for s, e in RUNS}
ALLBYTES = {}
for s, e in RUNS:
    for x in range(s, e): ALLBYTES[x] = s

# 1. switch/jump tables -> any target inside a run?
hits = collections.defaultdict(list)
for fn in ("main-full/jumptables.tsv", "main-full/switch_tables.tsv"):
    for ln in open(ROOT + "ida/out/" + fn).read().splitlines()[1:]:
        c = ln.split("\t")
        tea = c[0]; targets = c[-1].split(",")
        for t in targets:
            t = t.strip()
            if not t: continue
            tv = int(t, 16)
            if tv in ALLBYTES: hits[ALLBYTES[tv]].append(("%s tbl %s -> %06X" % (fn.split('/')[1], tea, tv)))
print("=== switch/jumptable targets into runs ===")
for s in sorted(hits): print("  %06X:" % s, hits[s][:6])
if not hits: print("  none")

# 2. BE32 / BE24(packed in vec area) / BE16 pointers to a run START (code-entry candidates)
print("=== pointers to run START (whole image) ===")
# index of pointer sources
for s, e in RUNS:
    srcs = []
    for a in range(0, len(IMG) - 3):
        if be32(a) == s: srcs.append(("BE32", a))
    # BE24 three-byte packed (0x00 + addr) and @@aa:8 vectors live in low mem 0..0xFF
    for a in range(0, len(IMG) - 1):
        if int.from_bytes(IMG[a:a+2], "big") == s and s < 0x10000: srcs.append(("BE16", a))
    # @@aa:8: jmp @@aa reads a BE24/BE32 vector from address aa (0..0xFF). Does any run start appear as a
    # 4-byte vector in page 0 (0..0x400 already covered by BE32). Report page-0 BE32 hits distinctly.
    if srcs:
        # classify each source by whether it sits in reached code or is an isolated pointer-looking cell
        shown = []
        for kind, a in srcs[:40]:
            inrun = a in ALLBYTES
            pre = IMG[max(0,a-2):a].hex()
            shown.append("%s@%06X(pre=%s%s)" % (kind, a, pre, ",vec" if a < 0x400 else (",inrun" if inrun else "")))
        print("  %06X <- %d src: %s" % (s, len(srcs), " ".join(shown)))
print("(no line for a run = zero BE32/BE16 pointer to its start anywhere in the image)")
