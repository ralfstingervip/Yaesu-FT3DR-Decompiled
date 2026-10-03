# M4 lane: inbound-edge analysis of the 29 proven-but-unreached runs >= 0x058000.
# Owner-side, read-only, offline. No IDA, no device. Reuses H9's masks/common (read-only).
from pathlib import Path
REPO = Path(__file__).resolve().parents[3].as_posix()  # repository root
import sys, bisect
sys.dont_write_bytecode = True
sys.path.insert(0, (REPO + "/ida/out/main-descent/offline"))
from common import IMG, HI, CW, bu, flow, runtype, be32
from masks import A, RC, D, G1A, RC0

PROVEN = open((REPO + "/ida/out/l-wave-recon/final6_proven_mask.bin"), "rb").read()

# ---- my 29 runs (start>=0x058000) from proven-unreached-runs.tsv
RUNS = []
for ln in open((REPO + "/ida/out/l-wave-recon/proven-unreached-runs.tsv")).read().splitlines():
    if ln.startswith("#") or ln.startswith("start"): continue
    c = ln.split("\t"); s = int(c[0], 16)
    if s >= 0x058000:
        RUNS.append((s, int(c[1], 16), int(c[2]), int(c[3]), int(c[4]), c[5]))

# ---- reconstruct real instruction heads by tiling proven-mask runs with oracle lengths
heads = set(); mistile = []
x = 0
while x < HI:
    if PROVEN[x]:
        s = x
        while x < HI and PROVEN[x]: x += 1
        p = s
        while p < x:
            n, t = bu(p)
            if n == 0:
                mistile.append(p); break
            heads.add(p); p += n
        if p != x and n != 0:
            mistile.append(p)  # ran past run end
    else:
        x += 1
heads_sorted = sorted(heads)

# ---- build control-flow edges target->list(source) from every head (abs + relative via flow)
edge = {}
for h in heads_sorted:
    n, t, k, tgts = flow(h)
    for tg in tgts:
        edge.setdefault(tg, []).append((h, k, t))

# ---- BE32 pointer scan whole image 0..HI
def be32_sources(addr_set):
    hits = {}
    for off in range(0, HI - 3):
        w = (IMG[off] << 24) | (IMG[off+1] << 16) | (IMG[off+2] << 8) | IMG[off+3]
        if w in addr_set:
            hits.setdefault(w, []).append(off)
    return hits

# collect all interior addresses of all runs to test as pointer/edge targets
interior = {}
for s, e, ln, f6, inw, fb in RUNS:
    for a in range(s, e): interior[a] = s
be_hits = be32_sources(set(interior.keys()))

def addend_of(a):
    tags = []
    if A[a]: tags.append("A")
    if RC[a]: tags.append("RC")
    if RC0[a] and not RC[a]: tags.append("RC0only")
    if D[a]: tags.append("D")
    if G1A[a]: tags.append("G1A")
    return "+".join(tags) if tags else "NONE"

def head_at_or_before(a):
    i = bisect.bisect_right(heads_sorted, a) - 1
    return heads_sorted[i] if i >= 0 else None

print("heads:", len(heads_sorted), "mistiles:", len(mistile), mistile[:10])
print()
out = []
for s, e, ln, f6, inw, fb in RUNS:
    # addend over the run (first byte + whole-run summary)
    ad_start = addend_of(s)
    ad_all = set()
    for a in range(s, e): ad_all.add(addend_of(a))
    # inbound CF edges into [s,e)
    cf = []
    for a in range(s, e):
        for (src, k, t) in edge.get(a, []):
            cf.append((a, src, k, t.split("(")[0].strip()))
    # BE32 pointers into [s,e)
    be = []
    for a in range(s, e):
        for off in be_hits.get(a, []):
            # is the pointer itself at a code immediate (preceded by 7A 0x head) or data?
            be.append((a, off))
    # fall-through predecessor
    fh = head_at_or_before(s - 1)
    ft = None
    if fh is not None:
        n, t, k, tg = flow(fh)
        if fh + n == s:
            ft = (fh, k, t.split("(")[0].strip())
    rty = runtype(s)
    out.append(dict(s=s, e=e, ln=ln, inw=inw, fb=fb, ad_start=ad_start,
                    ad_all=",".join(sorted(ad_all)), cf=cf, be=be, ft=ft, rty=rty))

for r in out:
    print("== %06X-%06X len=%d inw=%d addend=%s all=[%s] runtype=%s" % (
        r["s"], r["e"], r["ln"], r["inw"], r["ad_start"], r["ad_all"], r["rty"]))
    print("   first:", r["fb"])
    if r["ft"]:
        print("   fallthrough-head %06X (%s) %s" % (r["ft"][0], r["ft"][1], r["ft"][2]))
    else:
        print("   fallthrough: none (prev head does not end at start, or is a flow-stop)")
    if r["cf"]:
        for (a, src, k, t) in r["cf"][:12]:
            print("   CF-> %06X from %06X [%s] %s" % (a, src, k, t))
    else:
        print("   CF: none (no abs/relative edge from any proven head)")
    if r["be"]:
        for (a, off) in r["be"][:12]:
            pre = IMG[off-2:off].hex() if off >= 2 else ""
            print("   BE32-> %06X at off %06X (pre=%s)" % (a, off, pre))
    else:
        print("   BE32: none")
    print()
