import sys
from pathlib import Path as _Path
_REPO = _Path(__file__).resolve().parents[3]
# N14 -- second, looser citation pass over the same scope as n14_citations.py (docs 113-127, RESUME-FULL.md lines
# 13-250, m-wave-recon README). For every backticked byte run (>= 2 hex bytes) on an in-scope line that the strict pass
# did not already grade, try every address token on the same line (and the previous line, for wrapped text):
#   LOOSE-PASS   the run matches exactly at one of those addresses
#   LOOSE-NEAR   the run matches within +-8 B of one of them (reviewed by hand in n14_manual.py)
#   UNPAIRED     no address on the line matches (notation, value lists, counts, or a wrapped span; reviewed by hand)
# Read-only. Writes loose.tsv (OUTDIR).
import os, re, sys
sys.dont_write_bytecode = True
ROOT = str(_REPO)
OUT = os.environ.get('OUTDIR', os.path.dirname(os.path.abspath(__file__)))
DOCS = os.path.join(ROOT, r'docs\deep')
sys.exit('The firmware image is not in this repository.')
SUBB = 0xFFC00000
LINES = {}
for f in os.listdir(DOCS):
    m = re.match(r'(\d{3})-.*\.md$', f)
    if m and 113 <= int(m.group(1)) <= 127: LINES[f] = open(os.path.join(DOCS, f), encoding='utf-8').read().split('\n')
R = open(os.path.join(DOCS, 'RESUME-FULL.md'), encoding='utf-8').read().split('\n')
LINES['RESUME-FULL.md'] = [L if 13 <= i <= 250 else '' for i, L in enumerate(R, 1)]
LINES['README.md'] = open(os.path.join(ROOT, r'ida\out\m-wave-recon\README.md'), encoding='utf-8').read().split('\n')
graded = set()
for l in open(os.path.join(OUT, 'citations_strict.tsv'), encoding='utf-8').read().splitlines()[1:]:
    c = l.split('\t')
    graded.add((c[0], c[1], re.sub(r'\s+', ' ', c[3].replace('…', ' ')).strip()))
RE_ADDR = re.compile(r'(?<![0-9A-Za-z_])(?:0x([0-9A-Fa-f]{4,8})|(FF[0-9A-F]{6})|([0-9A-F]{6}))(?![0-9A-Za-z])')
RE_RUN = re.compile(r'(?<![0-9A-Za-z])((?:[0-9a-fA-F]{2}|\?\?)(?:(?: |\s*…\s*| \| )(?:[0-9a-fA-F]{2}|\?\?))+)(?![0-9A-Za-z])')
def locate(a):
    if a >= SUBB: return 'SUB', S, a - SUBB
    if a < 0x80000: return 'MAIN', M, a
    return None, None, None
def segs(run):
    run = run.replace('|', ' ')
    return [[None if x == '??' else int(x, 16) for x in s.split()] for s in run.split('…') if s.split()]
def match_at(buf, off, sg, gapmax=96):
    def eq(o, s): return 0 <= o and o + len(s) <= len(buf) and all(x is None or buf[o + k] == x for k, x in enumerate(s))
    if not eq(off, sg[0]): return False
    pos = off + len(sg[0])
    for s in sg[1:]:
        j = next((j for j in range(pos, pos + gapmax + 1) if eq(j, s)), -1)
        if j < 0: return False
        pos = j + len(s)
    return True
rows = []
for doc, lines in LINES.items():
    for i, line in enumerate(lines, 1):
        if not line.strip(): continue
        spans = re.findall(r'`([^`]+)`', line)
        addrs = []
        for ctx in (lines[i - 2] if i > 1 else '', line):
            for m in RE_ADDR.finditer(ctx):
                t = m.group(1) or m.group(2) or m.group(3)
                if not re.search(r'[0-9]', t): continue
                a = int(t, 16)
                if locate(a)[0]: addrs.append(a)
        for sp in spans:
            for m in RE_RUN.finditer(sp):
                run = m.group(1); sg = segs(run)
                if sum(len(s) for s in sg) < 2 or not sg[0]: continue
                key = re.sub(r'\s+', ' ', run.replace('|', ' ').replace('…', ' ')).strip().lower()
                if (doc, str(i), key) in graded: continue
                # a run that is itself a hex address token (e.g. "00 06 66 00" is fine; skip pure 6-digit words) - runs need spaces
                v = None
                for a in dict.fromkeys(addrs):
                    img, buf, off = locate(a)
                    if match_at(buf, off, sg): v = ('LOOSE-PASS', img, a, 0); break
                if not v:
                    for a in dict.fromkeys(addrs):
                        img, buf, off = locate(a)
                        d = next((d for d in sorted(range(-8, 9), key=abs) if d and match_at(buf, off + d, sg)), None)
                        if d is not None: v = ('LOOSE-NEAR', img, a, d); break
                if not v:
                    flat = bytes(x for x in sg[0] if x is not None)
                    hm = M.count(flat) if len(flat) >= 2 else -1; hs = S.count(flat) if len(flat) >= 2 else -1
                    v = ('UNPAIRED', '-', None, 'first segment hits MAIN %d / SUB %d' % (hm, hs))
                rows.append((doc, i, '%X' % v[2] if v[2] is not None else '-', run, v[0], v[1], (('delta %+d' % v[3]) if isinstance(v[3], int) and v[3] else (v[3] if isinstance(v[3], str) else '')), line.strip()[:220]))
with open(os.path.join(OUT, 'loose.tsv'), 'w', encoding='utf-8', newline='\n') as f:
    f.write('doc\tline\taddress\tbytes_cited\tverdict\timage\tnote\ttext\n')
    for r in rows: f.write('\t'.join(str(x).replace('\t', ' ') for x in r) + '\n')
from collections import Counter
print(Counter(r[4] for r in rows))
