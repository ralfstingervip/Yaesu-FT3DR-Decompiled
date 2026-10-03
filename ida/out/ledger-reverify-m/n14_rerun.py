from pathlib import Path as _Path
_REPO = _Path(__file__).resolve().parents[3]
# N14 -- re-run the M-wave lanes' published checkers from scratch copies with redirected outputs, and compare.
# Owner-side static analysis; read-only on every published file. Pattern adapted from M13's m13_rerun.py.
# For each lane: the published lane directory is copied to <SCR>/<lane>/, every path to that lane directory in the
# copied *.py is rewritten to the copy, scripts run with PYTHONDONTWRITEBYTECODE=1, and every file the run (re)wrote
# is compared byte for byte with the published file of the same relative path. Published lane directories are
# listed (size, sha256) before and after; any change is reported. Outputs: rerun.tsv, rerun-log.txt (OUTDIR).
import os, sys, re, shutil, hashlib, subprocess, time
sys.dont_write_bytecode = True
ROOT = str(_REPO)
IO = os.path.join(ROOT, "ida", "out")
OUT = os.environ.get("OUTDIR", os.path.dirname(os.path.abspath(__file__)))
SCR = os.environ.get("N14SCR", r"local-temp")

# lane, lane dir, cwd ("." = copy, "ROOT" = workspace root), [scripts], expected summary regex per script
JOBS = [
    ("M1", "main-final6", "offline", ["m1_build_masks.py", "m1_verify_bytes.py", "m1_plan.py", "m1_func_changes.py", "m1_gap_edges.py"]),
    ("M7", "cdc-personality", ".", ["verify.py"]),
    ("M8", "an1-tones", ".", ["m8_verify.py"]),
    ("M9", "link-edges", "ROOT", ["verify.py"]),
    ("M11", "main-small", ".", ["verify.py"]),
    ("M12", "bluetooth", ".", ["verify.py"]),
    ("M14", "errata-k-l", ".", ["m14_errata_check.py"]),
    ("M15", "sub-residue-final", ".", ["m15_verify.py", "m15_masks.py", "m15_analyze.py"]),
    ("orch", "m-wave-recon", ".", ["m_recon.py"]),
]

def sha(p): return hashlib.sha256(open(p, "rb").read()).hexdigest()
def listing(d):
    out = {}
    for b, _, fs in os.walk(d):
        for f in fs:
            p = os.path.join(b, f); out[os.path.relpath(p, d)] = (os.path.getsize(p), sha(p))
    return out
def rewrite(s, d, copy):
    fw = copy.replace("\\", "/")
    s = re.sub(r'ROOT\s*\+\s*"ida/out/%s/' % re.escape(d), lambda m: 'r"' + fw + '/', s)
    s = s.replace(str(_REPO) + "/ida/out/%s" % d, fw)
    s = s.replace(str(_REPO) + "/ida/out/%s" % d, copy)
    s = s.replace(str(_REPO) + "/ida/out/%s" % d, copy.replace("\\", "\\\\"))
    # os.path.join(ROOT, r"ida\out\<d>") -> os.path.join(ROOT, r"<abs copy>") (join discards ROOT for an absolute part)
    s = s.replace("r'ida\\out\\%s'" % d, "r'%s'" % copy).replace('r"ida\\out\\%s"' % d, 'r"%s"' % copy)
    # bluetooth: ROOT derived from the script location -> pin it to the workspace root
    s = s.replace("ROOT = os.path.dirname(os.path.dirname(os.path.dirname(HERE)))", "ROOT = r\"%s\"" % ROOT)
    return s

rows = []; LOG = []
def log(*a):
    t = " ".join(str(x) for x in a); print(t, flush=True); LOG.append(t)
before = {d: listing(os.path.join(IO, d)) for _, d, *_ in JOBS}
for lane, d, cwd, scripts in JOBS:
    pub = os.path.join(IO, d); copy = os.path.join(SCR, lane)
    if os.path.exists(copy): shutil.rmtree(copy)
    shutil.copytree(pub, copy, ignore=shutil.ignore_patterns("__pycache__"))
    os.makedirs(os.path.join(copy, "_n14"), exist_ok=True)
    for b, _, fs in os.walk(copy):
        for f in fs:
            if f.endswith(".py"):
                p = os.path.join(b, f); s0 = open(p, encoding="utf-8").read(); s1 = rewrite(s0, d, copy)
                if s1 != s0: open(p, "w", encoding="utf-8", newline="").write(s1)
    leaks = []
    for b, _, fs in os.walk(copy):
        for f in fs:
            if f.endswith(".py"):
                s = open(os.path.join(b, f), encoding="utf-8").read()
                for pat in ("ida/out/%s" % d, "ida\\out\\%s" % d, "ida\\\\out\\\\%s" % d):
                    for m in re.finditer(re.escape(pat), s):
                        ln = s[:m.start()].count("\n") + 1; line = s.splitlines()[ln - 1].strip()
                        leaks.append("%s:%d:%s" % (f, ln, line[:120]))
    if leaks: log(lane, "remaining references to the published dir (checked by hand):", leaks)
    rows.append((lane, d, "path refs left", str(len(leaks)), "-", "-", " | ".join(leaks)[:600]))
    snap = listing(copy); m0 = {k: os.path.getmtime(os.path.join(copy, k)) for k in snap}
    env = dict(os.environ, PYTHONDONTWRITEBYTECODE="1", PYTHONIOENCODING="utf-8")
    for sc in scripts:
        wd = ROOT if cwd == "ROOT" else os.path.join(copy, cwd)
        sp = os.path.join(copy, "offline" if cwd == "offline" else "", sc) if cwd != "ROOT" else os.path.join(copy, sc)
        t0 = time.time()
        r = subprocess.run([sys.executable, sp], cwd=wd, env=env, capture_output=True, text=True, encoding="utf-8", errors="replace")
        out = (r.stdout or "") + (r.stderr or "")
        open(os.path.join(copy, "_n14", sc + ".stdout.txt"), "w", encoding="utf-8", newline="\n").write(out)
        last = [l for l in out.strip().splitlines() if l.strip()][-3:] if out.strip() else []
        log("%s %s rc=%d %.1fs | %s" % (lane, sc, r.returncode, time.time() - t0, " / ".join(last)[:400]))
        rows.append((lane, d, sc, "rc=%d" % r.returncode, "-", "-", " / ".join(last)[:400].replace("\t", " ")))
    after = listing(copy)
    wrote = sorted(k for k in after if not k.startswith("_n14") and (k not in snap or os.path.getmtime(os.path.join(copy, k)) > m0.get(k, 0)))
    for k in wrote:
        pp = os.path.join(pub, k)
        if not os.path.exists(pp):
            rows.append((lane, d, "output", k, "no published file", "-", "new file")); log(lane, k, "new file"); continue
        if sha(pp) == after[k][1]:
            res, note = "IDENTICAL", ""
        else:
            a = open(pp, "rb").read(); b = open(os.path.join(copy, k), "rb").read()
            if a.replace(b"\r\n", b"\n") == b.replace(b"\r\n", b"\n"):
                res, note = "IDENTICAL-MOD-CRLF", ""
            else:
                la = a.split(b"\n"); lb = b.split(b"\n")
                dl = [i + 1 for i in range(max(len(la), len(lb))) if (la[i] if i < len(la) else None) != (lb[i] if i < len(lb) else None)]
                res = "DIFFERS"; note = "sizes %d vs %d; %d lines differ: %s" % (len(a), len(b), len(dl), dl[:10])
                if len(dl) <= 6:
                    note += " | " + " || ".join("L%d pub=%r run=%r" % (i, (la[i - 1] if i <= len(la) else b"")[:160], (lb[i - 1] if i <= len(lb) else b"")[:160]) for i in dl)
        rows.append((lane, d, "output", k, "published", res, note)); log(lane, k, res, note[:300])
    unwritten = sorted(k for k in snap if not k.startswith("_n14") and k not in wrote and not k.endswith(".py"))
    rows.append((lane, d, "not rewritten by the run", str(len(unwritten)), "-", "-", " ".join(unwritten)[:600]))
after_pub = {d: listing(os.path.join(IO, d)) for _, d, *_ in JOBS}
for d in before:
    same = before[d] == after_pub[d]
    rows.append(("-", d, "published dir unchanged", "", "", "YES" if same else "NO", ""))
    if not same: log("PUBLISHED DIR CHANGED:", d, set(before[d].items()) ^ set(after_pub[d].items()))
with open(os.path.join(OUT, "rerun.tsv"), "w", encoding="utf-8", newline="\n") as f:
    f.write("lane\tlane_dir\tstep\titem\tcompared_to\tresult\tnote\n")
    for r in rows: f.write("\t".join(str(x).replace("\t", " ").replace("\n", " ") for x in r) + "\n")
open(os.path.join(OUT, "rerun-log.txt"), "w", encoding="utf-8", newline="\n").write("\n".join(LOG) + "\n")
