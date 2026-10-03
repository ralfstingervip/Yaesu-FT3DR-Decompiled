# Lane M3: completeness checks. (1) inbound scan of EVERY even address in the 22 runs (not only linear-decode starts);
# (2) doc 60 indirect-cb targets inside the runs; (3) every reached register-relative branch (bra/bsr rN) and its +-32 KB reach;
# (4) every reached jmp/jsr @erN site count vs doc 60 sites.tsv. Writes ../work/m3_even.txt. Read-only.
from pathlib import Path
REPO = Path(__file__).resolve().parents[4].as_posix()  # repository root
import sys, re
sys.dont_write_bytecode = True
sys.path.insert(0, (REPO + "/ida/out/punr-mid/offline"))
from m3_common import MINE, RK, IMG, cls
import m3_refs
L = []
T = [a for s, e, n in MINE for a in range(s, e, 2)]
out = m3_refs.scan(T)
own = {a: s for s, e, n in MINE for a in range(s, e, 2)}
ext = 0
for a in T:
    for r in out[a]:
        k, src = r[0], r[1]
        internal = r[4] == "punr" and k == "flow"
        if internal: continue
        ext += 1
        L.append("even %06X (run %06X) %s" % (a, own[a], r))
L.append("even-address targets %d; non-internal rows %d" % (len(T), ext))
cb = [ln for ln in open((REPO + "/ida/out/indirect-cb/targets.tsv"), encoding="utf-8").read().splitlines()[1:]
      if int(ln.split("\t")[0], 16) in own or any(s <= int(ln.split("\t")[0], 16) < e for s, e, n in MINE)]
L.append("doc60 targets inside runs: %d %s" % (len(cb), cb))
RR = re.compile(r"^(bra|bsr) (r\d[lh]?\.[bw]|er\d)$")
rr = sorted(a for a, (n, t, k) in RK.items() if RR.match(t))
L.append("reached register-relative branches: %d %s" % (len(rr), ["%06X %s" % (a, RK[a][1]) for a in rr]))
for a in rr:
    hit = [s for s, e, n in MINE if a - 0x8000 <= s <= a + 0x8000]
    L.append("  %06X can reach runs %s" % (a, ["%06X" % h for h in hit]))
IJ = re.compile(r"^(jmp|jsr) @er\d$")
ij = sorted(a for a, (n, t, k) in RK.items() if IJ.match(t))
sites = {int(ln.split("\t")[0], 16) for ln in open((REPO + "/ida/out/indirect-cb/sites.tsv"), encoding="utf-8").read().splitlines()[1:]}
L.append("reached jmp/jsr @erN: %d; in doc60 sites.tsv: %d; not in sites: %s" % (len(ij), sum(1 for a in ij if a in sites), ["%06X" % a for a in ij if a not in sites]))
open((REPO + "/ida/out/punr-mid/work/m3_even.txt"), "w", encoding="utf-8").write("\n".join(L) + "\n")
print("\n".join(L))
