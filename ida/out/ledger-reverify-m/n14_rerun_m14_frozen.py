from pathlib import Path as _Path
_REPO = _Path(__file__).resolve().parents[3]
# N14 -- re-run M14's m14_errata_check.py against a frozen RESUME-FULL.md (the 239 lines 12-250 of the M-wave section
# removed, so the L-wave text sits at the line numbers M14 anchored), with every other doc copied unchanged.
# Read-only on published files; everything is written under the scratch copy. Appends rows to rerun.tsv (OUTDIR).
import os, sys, shutil, hashlib, subprocess
sys.dont_write_bytecode = True
ROOT = str(_REPO)
OUT = os.environ.get("OUTDIR", os.path.dirname(os.path.abspath(__file__)))
SCR = os.environ.get("N14SCR", r"local-temp")
pub = os.path.join(ROOT, r"ida\out\errata-k-l"); copy = os.path.join(SCR, "M14-frozen"); docs = os.path.join(copy, "_docs")
if os.path.exists(copy): shutil.rmtree(copy)
shutil.copytree(pub, copy)
shutil.copytree(os.path.join(ROOT, r"docs\deep"), docs)
L = open(os.path.join(docs, "RESUME-FULL.md"), encoding="utf-8").read().split("\n")
assert L[12].startswith("## M wave") and L[250].startswith("## L wave"), (L[12][:30], L[250][:30])
open(os.path.join(docs, "RESUME-FULL.md"), "w", encoding="utf-8", newline="").write("\n".join(L[:11] + L[250:]))
p = os.path.join(copy, "m14_errata_check.py"); s = open(p, encoding="utf-8").read()
s = s.replace(r"OUT = os.path.join(ROOT, r'ida\out\errata-k-l')", "OUT = r'%s'" % copy).replace(r"DOCS = os.path.join(ROOT, r'docs\deep')", "DOCS = r'%s'" % docs)
assert "r'%s'" % copy in s and "r'%s'" % docs in s
open(p, "w", encoding="utf-8", newline="").write(s)
r = subprocess.run([sys.executable, p], cwd=copy, env=dict(os.environ, PYTHONDONTWRITEBYTECODE="1"), capture_output=True, text=True)
sha = lambda f: hashlib.sha256(open(f, "rb").read()).hexdigest()
rows = [("M14", "errata-k-l", "m14_errata_check.py (RESUME frozen: lines 12-250 removed)", "rc=%d" % r.returncode, "-", "-", " / ".join(r.stdout.strip().splitlines()[-3:]))]
for f in ("bytecheck.tsv", "errata.tsv", "index.tsv", "run.txt"):
    rows.append(("M14", "errata-k-l", "output (frozen RESUME)", f, "published", "IDENTICAL" if sha(os.path.join(pub, f)) == sha(os.path.join(copy, f)) else "DIFFERS", ""))
print(r.stdout[-600:], r.stderr[-600:])
with open(os.path.join(OUT, "rerun.tsv"), "a", encoding="utf-8", newline="\n") as fh:
    for x in rows: fh.write("\t".join(str(c).replace("\t", " ") for c in x) + "\n"); print(x)
