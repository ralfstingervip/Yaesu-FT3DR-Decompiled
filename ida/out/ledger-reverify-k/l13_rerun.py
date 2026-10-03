from pathlib import Path as _Path
_REPO = _Path(__file__).resolve().parents[3]
# L13 -- part 3: re-run the offline tests / generators the K-wave and follow-up lanes left behind.
# Each script is COPIED to a scratch directory with its output directory rewritten to a scratch copy
# of the lane's published directory, run there, and every file it writes is compared byte for byte
# with the published file. No published lane output is touched. fcs_test.py writes nothing and runs
# in place. Writes only ida\out\ledger-reverify-k\rerun.tsv and rerun-log.txt.
# Run: python "ida/out/ledger-reverify-k/l13_rerun.py" <scratch_dir>
import hashlib, os, shutil, subprocess, sys, time

ROOT = str(_REPO)
OUT = os.path.join(ROOT, r'ida\out\ledger-reverify-k')
SCR = sys.argv[1] if len(sys.argv) > 1 else os.path.join(os.environ.get('TEMP', '.'), 'l13_rerun')
os.makedirs(SCR, exist_ok=True)
ENV = dict(os.environ, PYTHONDONTWRITEBYTECODE='1', PYTHONIOENCODING='utf-8')
rows, log = [], []


def sha(p):
    return hashlib.sha256(open(p, 'rb').read()).hexdigest()


def snapshot(d):
    return {f: (os.path.getmtime(os.path.join(d, f)), sha(os.path.join(d, f))) for f in os.listdir(d) if os.path.isfile(os.path.join(d, f))}


def run(cmd, cwd):
    t = time.time()
    p = subprocess.run(cmd, cwd=cwd, env=ENV, capture_output=True, text=True, encoding='utf-8', errors='replace', timeout=3600)
    return p.returncode, p.stdout, p.stderr, time.time() - t


def rerun(tag, scripts, lane_dir, subs, extra_cwd=None):
    """scripts run in order; subs(work) -> list of (source text, replacement text) applied to every script."""
    pub = os.path.join(ROOT, lane_dir)
    base = os.path.join(SCR, tag)
    work = os.path.join(base, 'out')
    code = os.path.join(base, 'code')
    if os.path.exists(base):
        shutil.rmtree(base)
    shutil.copytree(pub, work, ignore=shutil.ignore_patterns('__pycache__'))
    os.makedirs(code, exist_ok=True)
    before = snapshot(work)
    time.sleep(1.1)
    for src in scripts:
        s = open(src, encoding='utf-8').read()
        n = 0
        for a, b in subs(work):
            n += s.count(a)
            s = s.replace(a, b)
        dst = os.path.join(code, os.path.basename(src))
        open(dst, 'w', encoding='utf-8').write(s)
        if n == 0:
            rows.append((tag, os.path.basename(src), 'redirect', '0 replacements', 'FAIL', 'output path not redirected; script NOT run'))
            continue
        rc, so, se, dt = run([sys.executable, dst], extra_cwd or code)
        log.append('=== %s %s rc=%d %.1fs replaced=%d\n%s\n%s' % (tag,os.path.basename(src), rc, dt, n, so[-6000:], se[-6000:]))
        rows.append((tag, os.path.basename(src), 'exit', str(rc), 'PASS' if rc == 0 else 'FAIL', 'path literals replaced: %d; %.1f s; last stdout: %s' % (n, dt, so.strip().splitlines()[-1][:160] if so.strip() else '')))
    after = snapshot(work)
    for f, (mt, h) in sorted(after.items()):
        if f not in before or before[f][0] != mt:
            pubf = os.path.join(pub, f)
            if not os.path.exists(pubf):
                rows.append((tag, f, 'written (no published file)', h[:16], 'INFO', ''))
            else:
                ph = sha(pubf)
                same = ph == h
                note = ''
                if not same:
                    a = open(pubf, 'rb').read().splitlines()
                    b = open(os.path.join(work, f), 'rb').read().splitlines()
                    diff = [i + 1 for i in range(max(len(a), len(b))) if (a[i] if i < len(a) else None) != (b[i] if i < len(b) else None)]
                    note = 'lines pub/new %d/%d, differing %d, first lines %s' % (len(a), len(b), len(diff), diff[:3])
                rows.append((tag, f, 'rewritten vs published', '%s / %s' % (h[:16], ph[:16]), 'IDENTICAL' if same else 'DIFFERS', note))


# 1. K8 fcs_test.py (writes nothing) + fcs.c
rc, so, se, dt = run([sys.executable, os.path.join(ROOT, r'ida\out\aprs-ax25\fcs_test.py')], SCR)
log.append('=== fcs_test.py rc=%d\n%s\n%s' % (rc, so, se))
rows.append(('K8', 'fcs_test.py', 'exit / result', '%d / %s' % (rc, 'ALL PASS' if 'PYTHON RESULT: ALL PASS' in so else 'not all pass'), 'PASS' if rc == 0 and 'PYTHON RESULT: ALL PASS' in so else 'FAIL', ''))
pub = open(os.path.join(ROOT, r'ida\out\aprs-ax25\fcs_test_result.txt'), encoding='utf-8').read()
py_pub = pub[pub.find('image @'):].strip() if 'image @' in pub else ''
rows.append(('K8', 'fcs_test.py', 'stdout vs fcs_test_result.txt python part', '', 'IDENTICAL' if so.strip() == py_pub else 'DIFFERS', ''))
gcc = shutil.which('gcc')
if gcc:
    exe = os.path.join(SCR, 'fcs_l13.exe')
    rc1, so1, se1, _ = run([gcc, '-O2', '-o', exe, os.path.join(ROOT, r'ida\out\aprs-ax25\fcs.c')], SCR)
    rc2, so2, se2, _ = run([exe], SCR) if rc1 == 0 else (-1, '', '', 0)
    log.append('=== fcs.c gcc rc=%d run rc=%d\n%s\n%s%s' % (rc1, rc2, so2, se1, se2))
    c_pub = pub[:pub.find('image @')].strip() if 'image @' in pub else pub.strip()
    rows.append(('K8', 'fcs.c (gcc)', 'exit / result', '%d / %s' % (rc2, 'ALL PASS' if 'ALL PASS' in so2 else 'not all pass'), 'PASS' if rc2 == 0 and 'ALL PASS' in so2 else 'FAIL', ''))
    rows.append(('K8', 'fcs.c (gcc)', 'stdout vs fcs_test_result.txt C part', '', 'IDENTICAL' if so2.strip() == c_pub else 'DIFFERS', ''))
else:
    rows.append(('K8', 'fcs.c', 'gcc', 'not found', 'SKIPPED', ''))

J = os.path.join(ROOT, 'ida', 'jobs')
q = lambda w: repr(w)
# 2. K5 table generator (re-asserts 76 cited byte runs)
rerun('K5', [os.path.join(J, 'k5_gen_tables.py')], r'ida\out\dsp-payload-labels',
      lambda w: [(r'os.path.join(ROOT, r"ida\out\dsp-payload-labels")', q(w))])
# 3. L96 / L97 byte scripts
rerun('L96', [os.path.join(J, 'l96_bytes.py'), os.path.join(J, 'l96_cite.py')], r'ida\out\market-values',
      lambda w: [('ROOT = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))', 'ROOT = ' + q(ROOT)),
                 ('os.path.join(ROOT, "ida", "out", "market-values", "scan-raw.txt")', q(os.path.join(w, 'scan-raw.txt'))),
                 ('os.path.join(ROOT, "ida", "out", "market-values")', q(w))])
rerun('L97', [os.path.join(J, 'l97_scan.py'), os.path.join(J, 'l97_tables.py'), os.path.join(J, 'l97_cite.py')], r'ida\out\tx-freq-range',
      lambda w: [('os.path.join(ROOT, "ida", "out", "tx-freq-range", "%s")' % f, q(os.path.join(w, f))) for f in ('citations.tsv', 'scan.txt', 'tables.txt')])
# 4. L95 oracle chain
rerun('L95', [os.path.join(J, n) for n in ('l95_oracle.py', 'l95_heads.py', 'l95_facts.py', 'l95_data.py', 'l95_cite.py')], r'ida\out\service-window',
      lambda w: [(str(_REPO) + r'/ida/out/service-window', w), ('os.path.join(ROOT, "ida", "out", "service-window")', q(w))])
# 4b. L97 / L95 again with the mask walk frozen at follow-up time: a later lane's ida\out\main-final5 mask
#     (not part of this re-verification) is newer than final4 and changes only the mask lines of two reports.
FROZEN = ('if fn.endswith("proven_mask.bin"):', 'if fn.endswith("proven_mask.bin") and "main-final5" not in dirpath:')
rerun('L97-frozen', [os.path.join(J, 'l97_scan.py')], os.path.join('ida', 'out', 'tx-freq-range'),
      lambda w: [('os.path.join(ROOT, "ida", "out", "tx-freq-range", "scan.txt")', q(os.path.join(w, 'scan.txt'))), FROZEN])
rerun('L95-frozen', [os.path.join(J, 'l95_oracle.py')], r'ida\out\service-window',
      lambda w: [('os.path.join(ROOT, "ida", "out", "service-window")', q(w)), FROZEN])
# 5. K1 one-descent builder (asserts final3 reproduction, writes masks + ledger)
rerun('K1', [os.path.join(ROOT, r'ida\out\main-final4\offline\k1_build_masks.py')], r'ida\out\main-final4',
      lambda w: [('ROOT + "ida/out/main-final4/"', q(w.replace(os.sep, '/') + '/'))])

with open(os.path.join(OUT, 'rerun.tsv'), 'w', encoding='utf-8', newline='\n') as f:
    f.write('lane\tfile\tcheck\tvalue\tverdict\tnote\n')
    for r in rows:
        f.write('\t'.join(r) + '\n')
open(os.path.join(OUT, 'rerun-log.txt'), 'w', encoding='utf-8', newline='\n').write('\n'.join(log) + '\n')
for r in rows:
    print('\t'.join(r))
