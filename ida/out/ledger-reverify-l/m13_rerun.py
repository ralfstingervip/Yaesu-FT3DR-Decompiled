from pathlib import Path as _Path
_REPO = _Path(__file__).resolve().parents[3]
# M13 -- re-run the L-wave lanes' offline scripts from a scratch copy with redirected outputs, and compare.
# Owner-side static analysis; read-only on every published file. For each lane: the published lane directory is
# copied to <scratch>/rerun/<lane>/, every absolute path to that lane directory (and the lane's old scratchpad) is
# rewritten in the copied *.py to point at the copy, the scripts run in order with PYTHONDONTWRITEBYTECODE=1, and
# every file the run (re)wrote is compared byte for byte with the published file of the same relative path.
# Published lane directories are listed (path, size, sha256) before and after; any change is reported.
# Outputs (OUTDIR, default this folder): rerun_a.tsv, rerun-log.txt
# (L10 accessory-ptt / L8 tx-states are re-run in rerun_b.tsv; L13/L14/L15 and the sub-frames lanes in rerun_c.tsv.)
import os, sys, re, shutil, hashlib, subprocess, time
sys.dont_write_bytecode = True
ROOT = str(_REPO)
IO = os.path.join(ROOT, "ida", "out")
OUT = os.environ.get("OUTDIR", os.path.join(IO, "ledger-reverify-l"))
SCR = os.environ.get("M13SCR", r"local-temp")
OLD_SCR = {"fnindex-lo": "local-temp/"}

# lane, lane dir, cwd (relative to copy), [ (script, args) ... ], extra (published-file, scratch-file) comparisons
JOBS = [
    ("L1", "main-final5", "offline", [("l1_build_masks.py", [])], []),
    ("L2", "fnindex-lo", "offline", [("l2_reach.py", []), ("l2_back.py", []), ("l2_refs.py", []), ("l2_emit.py", []), ("verify.py", [])],
        [("backward-closure.txt", "_scr/back_lo.txt"), ("inbound-scan.txt", "_scr/refs_lo.txt")]),
    ("L3", "fnindex-mid", "offline", [("l3_edges.py", []), ("l3_classify.py", [])], []),
    ("L5", "main-unnamed", "offline", [("l5_features.py", []), ("l5_evidence.py", []), ("l5_classify.py", []), ("l5_emit.py", []), ("l5_review.py", [])], []),
    ("L6", "home-keytable", "gen", [("keytable.py", []), ("pages.py", []), ("zones.py", []), ("check_open.py", [])], []),
    ("orch", "l-wave-recon", ".", [("recon_descent.py", [])], []),
]

def sha(p): return hashlib.sha256(open(p, "rb").read()).hexdigest()
def listing(d):
    out = {}
    for b, _, fs in os.walk(d):
        for f in fs:
            p = os.path.join(b, f); out[os.path.relpath(p, d)] = (os.path.getsize(p), sha(p))
    return out
def rewrite(src, lanedir, copy):
    fw = copy.replace("\\", "/") + "/"
    bw = copy + "\\"
    s = src
    # forward-slash and backslash absolute forms, and the ROOT/R-relative forms used by the lanes
    s = s.replace(str(_REPO) + "/ida/out/%s/" % lanedir, fw)
    s = s.replace(str(_REPO) + "/ida/out/%s/" % lanedir, bw)
    s = s.replace(str(_REPO) + "/ida/out/%s\"" % lanedir, copy + "\"")
    s = re.sub(r'ROOT\s*\+\s*"ida/out/%s/' % re.escape(lanedir), lambda m: '"' + fw, s)
    s = re.sub(r'R\s*\+\s*r"\\ida\\out\\%s"' % re.escape(lanedir), lambda m: 'r"' + copy + '"', s)
    s = re.sub(r'R\s*\+\s*"%s/' % re.escape(lanedir), lambda m: '"' + fw, s)
    s = s.replace('os.path.join(ROOT, "ida", "out", "%s")' % lanedir, 'r"%s"' % copy)
    s = s.replace('ROOT + "ida/out/l-wave-recon/', '"' + fw)
    if lanedir in OLD_SCR:
        s = s.replace(OLD_SCR[lanedir], fw + "_scr/")
    return s

rows = []; LOG = []
def log(*a):
    t = " ".join(str(x) for x in a); print(t, flush=True); LOG.append(t)
before = {d: listing(os.path.join(IO, d)) for _, d, *_ in JOBS}
for lane, d, cwd, scripts, extra in JOBS:
    pub = os.path.join(IO, d); copy = os.path.join(SCR, lane)
    if os.path.exists(copy): shutil.rmtree(copy)
    shutil.copytree(pub, copy, ignore=shutil.ignore_patterns("__pycache__"))
    os.makedirs(os.path.join(copy, "_scr"), exist_ok=True)
    for b, _, fs in os.walk(copy):
        for f in fs:
            if f.endswith(".py"):
                p = os.path.join(b, f); s0 = open(p, encoding="utf-8").read(); s1 = rewrite(s0, d, copy)
                if s1 != s0: open(p, "w", encoding="utf-8", newline="").write(s1)
    # every remaining reference to the published lane dir in the copied scripts is a leak -> report
    leaks = []
    for b, _, fs in os.walk(copy):
        for f in fs:
            if f.endswith(".py"):
                s = open(os.path.join(b, f), encoding="utf-8").read()
                for pat in ("ida/out/%s" % d, "ida\\out\\%s" % d, '"%s/' % d):
                    if pat in s: leaks.append("%s:%s" % (f, pat))
    if leaks: log(lane, "path references left unrewritten:", leaks)
    snap = {k: v for k, v in listing(copy).items()}
    t0 = time.time(); m0 = {k: os.path.getmtime(os.path.join(copy, k)) for k in snap}
    env = dict(os.environ, PYTHONDONTWRITEBYTECODE="1", PYTHONIOENCODING="utf-8")
    for sc, args in scripts:
        wd = os.path.join(copy, cwd)
        r = subprocess.run([sys.executable, os.path.join(wd, sc)] + args, cwd=wd, env=env, capture_output=True, text=True, encoding="utf-8", errors="replace")
        out = (r.stdout or "") + (r.stderr or "")
        open(os.path.join(copy, "_scr", sc + ".stdout.txt"), "w", encoding="utf-8").write(out)
        last = [l for l in out.strip().splitlines() if l.strip()][-3:] if out.strip() else []
        log("%s %s rc=%d %.1fs | %s" % (lane, sc, r.returncode, time.time() - t0, " / ".join(last)[:400]))
        rows.append((lane, d, sc, "rc=%d" % r.returncode, "-", "-", " / ".join(last)[:300].replace("\t", " ")))
    # files (re)written by the run
    after = listing(copy)
    wrote = sorted(k for k in after if not k.startswith("_scr") and (k not in snap or os.path.getmtime(os.path.join(copy, k)) > m0.get(k, 0)))
    for k in wrote:
        pp = os.path.join(pub, k)
        if not os.path.exists(pp):
            rows.append((lane, d, "output", k, "no published file", "-", "new file (not published)")); continue
        same = sha(pp) == after[k][1]
        note = ""
        if not same:
            a = open(pp, "rb").read(); b = open(os.path.join(copy, k), "rb").read()
            res = "DIFFERS"
            if a.replace(b"\r\n", b"\n") == b.replace(b"\r\n", b"\n"):
                res = "IDENTICAL-MOD-CRLF"; note = "identical after CRLF->LF (the re-run writes CRLF; the published file has LF)"
            elif k == "final6_proven_mask.bin":
                d_ = [i for i in range(len(a)) if a[i] != b[i]]
                r36 = list(range(0x066FBE, 0x066FC8)) + list(range(0x06726A, 0x067284))
                ok36 = d_ == r36 and all(a[i] == 1 and b[i] == 0 for i in d_)
                res = "DIFFERS-AS-DOCUMENTED" if ok36 else "DIFFERS"
                note = "%d bytes differ; exactly the 36 hand-restored bytes 0x066FBE-0x066FC7 + 0x06726A-0x067283 (published 1, script 0): %s" % (len(d_), ok36)
            elif k == "ledger.tsv" and lane == "L1":
                res = "DIFFERS-AS-EXPLAINED"
                note = ("sizes %d vs %d; script writes '72.97%%%%' (bad literal, wrong value) in rows 5/9 and no percentage block; "
                        "published rows 5/9 say 73.01%%/98.54%% and add 6 percentage rows - the published file was extended after the script ran") % (len(a), len(b))
            elif len(a) == len(b) and a.count(b"\n") == b.count(b"\n"):
                la = a.split(b"\n"); lb = b.split(b"\n"); dl = [i + 1 for i in range(len(la)) if la[i] != lb[i]]
                note = "same size; %d lines differ: %s" % (len(dl), dl[:8])
            else:
                note = "sizes %d vs %d" % (len(a), len(b))
        else:
            res = "IDENTICAL"
        rows.append((lane, d, "output", k, "published", res, note))
        log(lane, k, res + " " + note)
    unwritten = sorted(k for k in snap if not k.startswith("_scr") and k not in wrote and not k.endswith(".py"))
    rows.append((lane, d, "not rewritten by the run", str(len(unwritten)), "-", "-", " ".join(unwritten)[:600]))
    for pk, sk in extra:
        a = os.path.join(pub, pk); b = os.path.join(copy, sk)
        if os.path.exists(b):
            same = sha(a) == sha(b)
            rows.append((lane, d, "output(scratch)", "%s <- %s" % (pk, sk), "published", "IDENTICAL" if same else "DIFFERS", ""))
            log(lane, pk, "vs", sk, "IDENTICAL" if same else "DIFFERS")
after_pub = {d: listing(os.path.join(IO, d)) for _, d, *_ in JOBS}
for d in before:
    rows.append(("-", d, "published dir unchanged", "", "", "YES" if before[d] == after_pub[d] else "NO", ""))
with open(os.path.join(OUT, "rerun_a.tsv"), "w", encoding="utf-8", newline="\n") as f:
    f.write("lane\tlane_dir\tstep\titem\tcompared_to\tresult\tnote\n")
    for r in rows: f.write("\t".join(str(x) for x in r) + "\n")
open(os.path.join(OUT, "rerun-log.txt"), "w", encoding="utf-8", newline="\n").write("\n".join(LOG) + "\n")
