# Lane M3: inbound scan for every oracle instruction start inside each of the 22 runs (linear decode from run start)
# plus the run's enclosing fnindex span head. Writes ../refs-detail.tsv. Read-only on every input.
from pathlib import Path
REPO = Path(__file__).resolve().parents[4].as_posix()  # repository root
import sys
sys.dont_write_bytecode = True
sys.path.insert(0, (REPO + "/ida/out/punr-mid/offline"))
sys.path.insert(0, (REPO + "/ida/out/main-descent/offline"))
from m3_common import MINE, IMG, flow, cls
import m3_refs
import masks as M9
starts = {}
for s, e, n in MINE:
    a = s
    while a < e:
        starts[a] = s
        k = flow(a)[0]; a += k if k else 2
    for fs, fe in M9.FN.items():
        if fs <= s < fe: starts.setdefault(fs, s)
out = m3_refs.scan(sorted(starts))
rows = ["run\ttarget\ttarget_class\tkind\tsrc\tsrc_bytes\tsrc_text\tsrc_class"]
for t in sorted(starts):
    for p in m3_refs.preceding(t):
        rows.append("%06X\t%06X\t%s\tpre-%s\t%06X\t%s\t%s\t%s" % (starts[t], t, cls(t), p[3], p[0], p[1], p[2], p[4]))
    for k, a, b, tx, c in out[t]:
        rows.append("%06X\t%06X\t%s\t%s\t%06X\t%s\t%s\t%s" % (starts[t], t, cls(t), k, a, b, tx, c))
open((REPO + "/ida/out/punr-mid/refs-detail.tsv"), "w", encoding="utf-8", newline="\n").write("\n".join(rows) + "\n")
print(len(starts), "targets;", len(rows) - 1, "rows")
for r in rows[1:]:
    c = r.split("\t")
    if c[3].startswith("pre-normal") or c[3].startswith("pre-cond") or c[3].startswith("pre-call"):
        if c[7] == "punr": continue   # internal fall-through inside the run
    print(r)
