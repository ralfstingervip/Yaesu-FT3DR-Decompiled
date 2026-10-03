# M13 -- combine all checks into counts.tsv and all re-runs into rerun.tsv. Plain Python, read-only on inputs.
# counts.tsv = counts_ledger.tsv + counts_db.tsv + counts_a/b/c.tsv + per-doc citation tallies from citations.tsv
# rerun.tsv  = rerun_a.tsv (M13: L1 L2 L3 L5 L6 orchestrator) + rerun_b.tsv (L8 L10) + rerun_c.tsv (L13 L14 L15 L11 L12)
import os, csv, collections
D = os.path.dirname(os.path.abspath(__file__))
OUT = os.environ.get("OUTDIR", D)
def tsv(name):
    p = os.path.join(D, name)
    if not os.path.exists(p): return None, []
    rows = [r for r in csv.reader(open(p, encoding="utf-8"), delimiter="\t", quoting=csv.QUOTE_NONE)]
    rows = [r for r in rows if r and not r[0].startswith("#")]
    return rows[0], rows[1:]
out = []
h, rows = tsv("counts_ledger.tsv")
for r in rows: out.append(("ledger", "-", "-", r[0], r[2], r[1], r[3], r[4] if len(r) > 4 else ""))
h, rows = tsv("counts_db.tsv")
for r in rows: out.append(("seed-db", "-", "-", r[0], r[2], r[1], r[3], r[4] if len(r) > 4 else ""))
for g in "abc":
    h, rows = tsv("counts_%s.tsv" % g)
    if h is None: continue
    ix = {k: i for i, k in enumerate(h)}
    for r in rows:
        get = lambda k: r[ix[k]] if k in ix and ix[k] < len(r) else ""
        out.append(("counts_" + g, get("doc"), get("line"), get("claim"), get("expected"), get("derived"), get("verdict"), get("note")))
h, rows = tsv("citations.tsv")
tally = collections.defaultdict(collections.Counter)
for r in rows: tally[r[0]][r[5]] += 1
for doc in sorted(tally, key=lambda d: (not d[0].isdigit(), int(d.split("-")[0]) if d[0].isdigit() else 0, d)):
    c = tally[doc]
    out.append(("citations", doc, "-", "verdict tally", "-", " ".join("%s=%d" % kv for kv in sorted(c.items())), "INFO", "total %d" % sum(v for k, v in c.items() if k != "DROPPED")))
allc = collections.Counter()
for c in tally.values(): allc.update(c)
out.append(("citations", "ALL", "-", "verdict tally", "-", " ".join("%s=%d" % kv for kv in sorted(allc.items())), "INFO", "total %d" % sum(v for k, v in allc.items() if k != "DROPPED")))
with open(os.path.join(OUT, "counts.tsv"), "w", encoding="utf-8", newline="\n") as f:
    f.write("source\tdoc\tline\tcheck\texpected\tderived\tverdict\tnote\n")
    for r in out: f.write("\t".join(str(x).replace("\t", " ").replace("\n", " ") for x in r) + "\n")
vt = collections.Counter(r[6] for r in out)
print("counts.tsv rows", len(out), dict(vt))
print("citations", dict(allc))
rr = []
for g in "abc":
    h, rows = tsv("rerun_%s.tsv" % g)
    if h is None: continue
    for r in rows: rr.append(["rerun_" + g] + r)
with open(os.path.join(OUT, "rerun.tsv"), "w", encoding="utf-8", newline="\n") as f:
    f.write("source\tcolumns as in the source file (rerun_a: lane, lane_dir, step, item, compared_to, result, note; rerun_b/c: lane, script, command, result, outputs_compared, identical, note)\n")
    for r in rr: f.write("\t".join(x.replace("\t", " ") for x in r) + "\n")
print("rerun.tsv rows", len(rr))
