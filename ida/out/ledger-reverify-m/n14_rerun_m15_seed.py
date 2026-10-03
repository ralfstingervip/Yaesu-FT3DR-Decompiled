from pathlib import Path as _Path
_REPO = _Path(__file__).resolve().parents[3]
# N14 -- M15's raw\analyze_log.txt line 20 is a dict printed in hash-seed-dependent order. Re-run m15_analyze.py in the
# scratch copy made by n14_rerun.py under PYTHONHASHSEED 0..3 and record that only the order of line 20 changes.
# Run after n14_rerun.py. Appends rows to rerun.tsv (OUTDIR). Writes only inside the scratch copy.
import os, sys, ast, subprocess
sys.dont_write_bytecode = True
ROOT = str(_REPO)
OUT = os.environ.get("OUTDIR", os.path.dirname(os.path.abspath(__file__)))
SCR = os.environ.get("N14SCR", r"local-temp")
copy = os.path.join(SCR, "M15"); pub = os.path.join(ROOT, r"ida\out\sub-residue-final\raw\analyze_log.txt")
P = open(pub, encoding="utf-8").read().split("\n")
parse = lambda l: ast.literal_eval(l.split("subclass bytes ", 1)[1])
rows = []
for seed in range(4):
    subprocess.run([sys.executable, os.path.join(copy, "m15_analyze.py")], cwd=copy, capture_output=True,
                   env=dict(os.environ, PYTHONHASHSEED=str(seed), PYTHONDONTWRITEBYTECODE="1"))
    R = open(os.path.join(copy, "raw", "analyze_log.txt"), encoding="utf-8").read().split("\n")
    other = [i + 1 for i in range(max(len(P), len(R))) if i != 19 and (P[i] if i < len(P) else None) != (R[i] if i < len(R) else None)]
    same20 = parse(P[19]) == parse(R[19])
    rows.append(("M15", "sub-residue-final", "m15_analyze.py PYTHONHASHSEED=%d" % seed, "raw\\analyze_log.txt", "published",
                 "IDENTICAL-MOD-DICT-ORDER" if same20 and not other else "DIFFERS", "line 20 dict equal: %s; other lines differing: %s; run line 20: %s" % (same20, other, R[19])))
with open(os.path.join(OUT, "rerun.tsv"), "a", encoding="utf-8", newline="\n") as fh:
    for r in rows: fh.write("\t".join(r) + "\n"); print(r)
