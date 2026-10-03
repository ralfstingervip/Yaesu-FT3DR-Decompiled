from pathlib import Path as _Path
_REPO = _Path(__file__).resolve().parents[4]
# Lane M1: function-list diff FINAL5 seed -> FINAL6 seed, with the reason for every change. Read-only.
R = str(_REPO) + r"/ida/out/main-final6/"
def F(p): return {int(l.split("\t")[0], 16): int(l.split("\t")[1], 16) for l in open(p, encoding="utf-8").read().splitlines()[1:]}
a = F(R + "work/seed/funcs.tsv"); b = F(R + "MAIN_FINAL6_functions_raw.tsv")
drop = {int(l.split("\t")[0], 16) for l in open(R + "plan-delfunc.tsv", encoding="utf-8").read().splitlines()[1:]}
notes = {}
for l in open(R + "MAIN_FINAL6_log.txt", encoding="utf-8"):
    if "=== verify" in l: break
    if l.startswith("  leftover ") and "->" in l:
        t = l.split("->")[1].split(":")[0].strip(); notes[int(t, 16)] = l.strip()[9:]
rows = []
for x in sorted(set(a) - set(b)):
    rows.append(("deleted", x, a[x], "H9 fnindex seed inside drop_runs.tsv" if x in drop else "start byte retyped as data by an L5 Confirmed row"))
for x in sorted(set(b) - set(a)):
    rows.append(("added", x, b[x], notes.get(x, "?")))
with open(R + "function-changes.tsv", "w", encoding="utf-8", newline="\n") as f:
    f.write("change\tstart\tend\treason\n")
    for r in rows: f.write("%s\t%06X\t%06X\t%s\n" % r)
print(len(a), "->", len(b), "deleted", sum(r[0] == "deleted" for r in rows), "added", sum(r[0] == "added" for r in rows),
      "unexplained", sum(r[3] == "?" for r in rows))
