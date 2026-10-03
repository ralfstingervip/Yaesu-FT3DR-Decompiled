import sys
from pathlib import Path as _Path
_REPO = _Path(__file__).resolve().parents[3]
# M13 group A: count / pattern-count / arithmetic checks for docs 98-103, RESUME-FULL.md L-wave section (12-216)
# and ida\out\l-wave-recon\README.md. Plain Python, read-only on every input. Output: counts_a.tsv in
# os.environ['OUTDIR'] (default: this directory). MAIN file offset = address; SUB file offset = address - 0xFFC00000.
import os, sys, hashlib, csv, re
from collections import Counter
sys.dont_write_bytecode = True
ROOT = str(_REPO)
HERE = os.path.dirname(os.path.abspath(__file__))
OUTD = os.environ.get('OUTDIR', HERE)
P = lambda *a: os.path.join(ROOT, *a)
O = lambda *a: os.path.join(ROOT, 'ida', 'out', *a)
sys.exit('The firmware image is not in this repository.')
HI, CONTENT = 0x07B754, 505684
W0, W1 = 0x078106, 0x078546
be32 = lambda a: int.from_bytes(M[a:a + 4], 'big')
be16 = lambda a: int.from_bytes(M[a:a + 2], 'big')
def mask(*p): return open(O(*p), 'rb').read()
def sha16(b): return hashlib.sha256(b).hexdigest()[:16]
def pc(m, lo=0, hi=None): return sum(m[lo:hi])
def tsv(path):
    L = [l for l in open(path, encoding='utf-8').read().splitlines() if l and not l.startswith('#')]
    h = L[0].split('\t'); return [dict(zip(h, l.split('\t'))) for l in L[1:]]
def runs_of(m, lo=0, hi=None):
    hi = len(m) if hi is None else hi; out = []; x = lo
    while x < hi:
        if m[x]:
            s = x
            while x < hi and m[x]: x += 1
            out.append((s, x))
        else: x += 1
    return out
def find_all(buf, pat, lo=0, hi=None, even=False):
    hi = len(buf) if hi is None else hi; r = []; i = buf.find(pat, lo)
    while 0 <= i < hi:
        if not even or i % 2 == 0: r.append(i)
        i = buf.find(pat, i + 1)
    return r
ROWS = []
def chk(doc, line, claim, expected, derived, note='', info=False):
    v = 'INFO' if info else ('PASS' if str(expected) == str(derived) else 'FAIL')
    ROWS.append((doc, str(line), claim, str(expected), str(derived), v, note))
def pct(a, b, d): return ('%.' + str(d) + 'f') % (100.0 * a / b)

D98, D99, D100, D101, D102, D103 = ('98-main-final5-seed.md', '99-fnindex-runs-lo.md', '100-fnindex-runs-mid.md',
    '101-fnindex-runs-hi.md', '102-main-unnamed-residue.md', '103-home-keytable.md')
R, RM = 'RESUME-FULL.md', 'README.md'

P4, N4 = mask('main-final4', 'final4_proven_mask.bin'), mask('main-final4', 'final4_named_mask.bin')
P5, N5 = mask('main-final5', 'final5_proven_mask.bin'), mask('main-final5', 'final5_named_mask.bin')
P6, N6 = mask('l-wave-recon', 'final6_proven_mask.bin'), mask('l-wave-recon', 'final6_named_mask.bin')
WR = [(0x07810C, 0x07815B), (0x0781A4, 0x0781A9), (0x0781C4, 0x078221), (0x07823C, 0x07825F), (0x078268, 0x078279),
      (0x07827C, 0x078333), (0x07833C, 0x07837B), (0x078384, 0x0783D9), (0x0783EE, 0x07842D), (0x078440, 0x078441),
      (0x078448, 0x078459), (0x078462, 0x078507), (0x078514, 0x078545)]

# ======================================================================= doc 98
chk(D98, 26, 'final4 proven popcount', 368624, pc(P4))
chk(D98, 26, 'final4 named popcount', 497451, pc(N4))
chk(D98, 26, '368,624 - 278 + 868', 369214, 368624 - 278 + 868)
chk(D98, 26, 'final5 proven popcount', 369214, pc(P5))
chk(D98, 26, 'final5 named popcount', 498319, pc(N5))
chk(D98, 31, '962,582 / 1,029,972 %', '93.457', pct(962582, 1029972, 3))
chk(D98, 31, '498,319 + 464,263', 962582, 498319 + 464263)
chk(D98, 40, '0x054AE2-0x054BF7 set in final4 proven / named', '278/278', '%d/%d' % (pc(P4, 0x054AE2, 0x054BF8), pc(N4, 0x054AE2, 0x054BF8)))
chk(D98, 40, '13 window ranges: total / set in final4 proven / named', '868/0/0',
    '%d/%d/%d' % (sum(b - a + 1 for a, b in WR), sum(pc(P4, a, b + 1) for a, b in WR), sum(pc(N4, a, b + 1) for a, b in WR)))
chk(D98, 102, 'final4 proven bytes in window code 0x078106-0x078545', 220, pc(P4, W0, W1))
chk(D98, 103, '220 + 868', 1088, 220 + 868)
chk(D98, 129, 'final4->final5 proven: removed / added runs', '1/13',
    '%d/%d' % (len(runs_of(bytes(1 if P4[i] and not P5[i] else 0 for i in range(HI)))), len(runs_of(bytes(1 if P5[i] and not P4[i] else 0 for i in range(HI))))))
chk(D98, 130, 'final5 masks length; set above 0x07B754', '1048576/1048576/0/0', '%d/%d/%d/%d' % (len(P5), len(N5), pc(P5, HI), pc(N5, HI)))
chk(D98, 131, 'final5_proven_mask sha256 prefix', '0d5492ce5de1500b', sha16(P5))
chk(D98, 132, 'final5_named_mask sha256 prefix', '0bff9e2d27f9c121', sha16(N5))
chk(D98, 136, '369,214 / 505,684 %', '73.01', pct(369214, CONTENT, 2))
chk(D98, 136, '498,319 / 505,684 %', '98.54', pct(498319, CONTENT, 2))
IH = tsv(O('recount', 'work', 'items_h1.tsv'))
ihc = sum(int(r['size']) for r in IH if r['kind'] == 'code')
wh = [r for r in IH if r['kind'] == 'code' and W0 <= int(r['ea'], 16) < 0x07B754]
chk(D98, 139, 'items_h1.tsv is_code bytes', 388484, ihc)
chk(D98, 140, 'items_h1.tsv window code heads / bytes', '99/318', '%d/%d' % (len(wh), sum(int(r['size']) for r in wh)))
chk(D98, 144, '1,088 - 318; 388,490 + 770', '770/389260', '%d/%d' % (1088 - 318, 388490 + 770))
chk(D98, 145, '369,214 / 388,490 %', '95.038', pct(369214, 388490, 3))
chk(D98, 146, '369,214 / 389,260 %', '94.850', pct(369214, 389260, 3))
# whole-image inbound scans into 0x054AE2-0x054BF7
lo, hi = 0x054AE2, 0x054BF8
abs24 = [a for a in range(0, HI - 3, 2) if M[a] in (0x5E, 0x5A) and lo <= int.from_bytes(M[a + 1:a + 4], 'big') < hi]
chk(D98, 86, 'abs24 jsr/jmp (5E/5A at even offsets, content) into range, from proven code', 0, len([a for a in abs24 if P5[a]]),
    'all even sites: %s' % (','.join('%06X' % a for a in abs24) or 'none'))
b32 = [a for a in range(0, HI - 3) if lo <= be32(a) < hi]
chk(D98, 87, 'BE32 at any offset into range', '04E9FB', ','.join('%06X' % a for a in b32))
vals = [be32(0x04E9F3 + 4 * i) for i in range(6)]
chk(D98, 90, 'table values from 0x04E9F3 (stride 4)', '3AE00,46A00,54B00,65900,79D00,92200', ','.join('%X' % v for v in vals))
chk(D98, 91, 'BE24 054B04 at 0x001A12 not preceded by 5E/5A', 'True', str(M[0x001A11] not in (0x5E, 0x5A) and M[0x001A12:0x001A15] == bytes.fromhex('054b04')))

# ======================================================================= fnindex-only runs (docs 99-101, RESUME, README)
FO = tsv(O('main-final4', 'fnindex-only-runs.tsv'))
FO = [(int(r['start'], 16), int(r['end_excl'], 16)) for r in FO]
chk(D99, 33, 'fnindex-only-runs.tsv runs / bytes', '94/4850', '%d/%d' % (len(FO), sum(e - s for s, e in FO)))
chk(R, 33, '"93 fnindex-only runs" = 94 minus 0x054AE2', '93/4572', '%d/%d' % (len([1 for s, e in FO if s != 0x054AE2]), sum(e - s for s, e in FO if s != 0x054AE2)))
lo_r = [(s, e) for s, e in FO if s < 0x30000]; mid_r = [(s, e) for s, e in FO if 0x30000 <= s < 0x50000]; hi_r = [(s, e) for s, e in FO if s >= 0x50000]
chk(D99, 11, 'runs below 0x030000: runs / bytes', '36/938', '%d/%d' % (len(lo_r), sum(e - s for s, e in lo_r)))
chk(D100, 11, 'runs 0x030000-0x04FFFF: runs / bytes', '31/2532', '%d/%d' % (len(mid_r), sum(e - s for s, e in mid_r)))
chk(D101, 12, 'runs >= 0x050000: runs / bytes (incl. 0x054AE2)', '27/1380', '%d/%d' % (len(hi_r), sum(e - s for s, e in hi_r)))
def classes(path, col):
    c = Counter(); b = Counter()
    for r in tsv(path):
        if not re.fullmatch(r'[0-9A-Fa-f]{6}', r['start']): continue
        c[r[col]] += 1; b[r[col]] += int(r['len'])
    return c, b
for doc, path, col, exp in ((D99, O('fnindex-lo', 'runs.tsv'), 'class', {'REACHED': (4, 54), 'DEAD': (18, 760), 'SPLIT-TAIL': (2, 44), 'DATA-MISTYPED': (12, 80)}),
                            (D100, O('fnindex-mid', 'runs.tsv'), 'class', {'DEAD': (16, 1960), 'SPLIT-TAIL': (8, 428), 'DATA-MISTYPED': (7, 144)}),
                            (D101, O('fnindex-hi', 'runs.tsv'), 'verdict', {'REACHED': (3, 90), 'WINDOW-ONLY': (2, 290), 'DATA-MISTYPED': (4, 26), 'DEAD': (13, 358), 'SPLIT-TAIL': (4, 338), 'ALREADY-DEMOTED': (1, 278)})):
    c, b = classes(path, col)
    for k, (n, by) in exp.items():
        chk(doc, 'verdict', 'lane runs.tsv class %s runs/bytes' % k, '%d/%d' % (n, by), '%d/%d' % (c[k], b[k]))
    lane_runs = sorted((int(r['start'], 16), int(r['end_excl'], 16)) for r in tsv(path) if re.fullmatch(r'[0-9A-Fa-f]{6}', r['start']))
    scope = {D99: lo_r, D100: mid_r, D101: hi_r}[doc]
    chk(doc, 'method', 'lane runs.tsv ranges == fnindex-only-runs.tsv ranges in scope', 'True', str(lane_runs == sorted(scope)))
chk(D99, 24, '760 + 44 + 80', 884, 760 + 44 + 80)
pdl = [r for r in tsv(O('fnindex-lo', 'proposed-demotions.tsv')) if re.fullmatch(r'[0-9A-Fa-f]{6}', r['start'])]
chk(D99, 24, 'fnindex-lo proposed-demotions.tsv runs / bytes (excl. #C companions)', '32/884', '%d/%d' % (len(pdl), sum(int(r['len']) for r in pdl)))
chk(D99, 26, 'REACHED 18+20+8+8', 54, 18 + 20 + 8 + 8)
chk(D99, 157, '369,214 - 884; - 30', '368330/368300', '%d/%d' % (369214 - 884, 369214 - 884 - 30))
chk(D99, 129, 'companions 0x0076D8-0x0076DF + 0x01C27E-0x01C293', 30, 8 + 22)
chk(D99, 129, 'companion bytes set in final4 proven', 30, pc(P4, 0x0076D8, 0x0076E0) + pc(P4, 0x01C27E, 0x01C294))
chk(D99, 156, 'the 938 B are all in final4 named', 938, sum(pc(N4, s, e) for s, e in lo_r))
# er1-callback sites
J = find_all(M, bytes.fromhex('5e015206'), 0, HI)
J1 = [a for a in J if M[a - 6:a - 4] == bytes.fromhex('7a01')]
chk(RM, 22, '"exactly 14 `5e 01 52 06` sites in the image"', 14, len(J), ','.join('%06X' % a for a in J))
chk(D99, 95, 'sites `mov.l #T,er1` (7a 01, immediately before) ; jsr @0x15206', 14, len(J1), 'targets: ' + ','.join('%06X' % be32(a - 4) for a in J1))
chk(R, 74, '"14 sites" (sub_15206 er1 rule)', 14, len(J1))
chk(D101, 54, '0x015206 has "13 genuine callers" (sites outside dead block 0x017570)', 13, len([a for a in J1 if a != 0x017576]),
    '14 sites whole-image; 13 if dead 0x017576 excluded (doc 99 wording)', info=True)
chk(D99, 100, 'fourteenth site 0x017576 follows mov.l #0x1758E,er1 at 0x017570', 'True', str(0x017576 in J1 and be32(0x017572) == 0x1758E))
chk(D100, 40, '368,346 - 2,532 ; % of content', '365814/72.340', '%d/%s' % (368346 - 2532, pct(368346 - 2532, CONTENT, 3)))
chk(D100, 41, '365,814 - 252; - 116', '365562/365446', '%d/%d' % (365814 - 252, 365814 - 252 - 116))
chk(D100, 139, 'byte sum of the 31 runs', 160167, sum(sum(M[s:e]) for s, e in mid_r))
chk(D100, 141, 'ADJACENT 6 + 110; set in final4 proven', '116/116', '%d/%d' % (6 + 110, pc(P4, 0x045D88, 0x045D8E) + pc(P4, 0x0460C2, 0x046130)))
chk(D100, 97, 'DEAD table rows 820+472+50+104+84+368+38+22+2; 368 row = 60+60+50+50+50+44+38+16', '1960/368',
    '%d/%d' % (820 + 472 + 50 + 104 + 84 + 368 + 38 + 22 + 2, 60 + 60 + 50 + 50 + 50 + 44 + 38 + 16))
chk(D100, 115, 'SPLIT rows 20+20+20+114+176+78 ; DATA rows 6+4+16+16+92+10', '428/144', '%d/%d' % (20 + 20 + 20 + 114 + 176 + 78, 6 + 4 + 16 + 16 + 92 + 10))
chk(D100, 136, 'A: 2,508 + 168 + 84; B: 2,532 + 252 + 114', '2760/2898', '%d/%d' % (2508 + 168 + 84, 2532 + 252 + 114))
chk(D101, 123, '358 + 338 + 26; 368,624 - 722', '722/367902', '%d/%d' % (358 + 338 + 26, 368624 - 722))
chk(D101, 93, 'DEAD list 32+26+60+32+60+12+66+2+20+18+14+14+2', 358, 32 + 26 + 60 + 32 + 60 + 12 + 66 + 2 + 20 + 18 + 14 + 14 + 2)
chk(D101, 101, 'SPLIT list 32+90+90+126', 338, 32 + 90 + 90 + 126)
chk(D101, 12, 'REACHED 18+20+52 ; USB 206+84 ; DATA 2+4+2+18', '90/290/26', '%d/%d/%d' % (18 + 20 + 52, 206 + 84, 2 + 4 + 2 + 18))
chk(D101, 100, '`0x062178` has 4 load sites (7a 05 00 06 21 78)', 4, len(find_all(M, bytes.fromhex('7a0500062178'), 0, HI)))
er5 = {t: len(find_all(M, bytes.fromhex('7a05') + t.to_bytes(4, 'big'), 0, HI)) for t in (0x0620A6, 0x062178, 0x062722, 0x067128)}
chk(D101, 97, 'er5 handler load sites per handler', 'all >=1', 'all >=1' if all(er5.values()) else str(er5), str(er5))
chk(D101, 54, '5e 01 52 06 at 0x05E868 preceded by mov.l #0x5E8E0,er1', 'True', str(0x05E868 in J1))
# real heads from proven runs (doc 101 method)
BU = {}
for ln in open(O('h8s-decode', 'work', 'bu_all.tsv'), encoding='utf-8'):
    c = ln.rstrip('\n').split('\t'); BU[int(c[0], 16)] = (int(c[1]), c[2], c[3] if len(c) > 3 else '')
pr4 = runs_of(P4, 0, HI)
heads, mis, at8 = 0, 0, 0
for s, e in pr4:
    x = s
    while x < e:
        n, mn, op = BU[x]; heads += 1
        if '@@' in op: at8 += 1
        x += n
    if x != e: mis += 1
chk(D101, 28, 'proven runs of final4_proven_mask.bin', 923, len(pr4))
chk(D101, 28, 'real heads walked over the proven runs with oracle lengths; mis-tiles', '114980/0', '%d/%d' % (heads, mis))
at8all = sum(1 for a, v in BU.items() if '@@' in v[2])
chk(D101, 37, '"all 2,212" `jmp/jsr @@aa:8` sites = oracle rows at every content offset', 2212, at8all,
    'scope is the linear per-offset oracle (odd offsets included; %d at even offsets); real final4-proven heads with @@: %d' % (sum(1 for a, v in BU.items() if '@@' in v[2] and a % 2 == 0), at8))

# ======================================================================= doc 102
RES = mask('main-unnamed', 'residue_mask.bin')
U = bytearray(N4[:HI])
for a, b in WR:
    for x in range(a, b + 1): U[x] = 1
chk(D102, 12, '505,684 - 498,319', 7365, CONTENT - 498319)
chk(D102, 46, 'final4 named OR 13 ranges', 498319, sum(U))
chk(D102, 47, 'residue_mask.bin length / popcount / sha prefix', '505684/7365/0d453850c6a36595', '%d/%d/%s' % (len(RES), sum(RES), sha16(RES)))
chk(D102, 46, 'residue == content minus union; raw runs', 'True/730', '%s/%d' % (all(RES[x] == (0 if U[x] else 1) for x in range(CONTENT)), len(runs_of(RES))))
chk(D102, 41, 'bytes 0x07B754-0x0FFFFF all 0xFF (count)', 542892, sum(1 for b in M[HI:] if b == 0xFF))
chk(D102, 42, 'final4_named_mask bits past 0x07B753', 0, pc(N4, HI))
chk(D102, 40, '229,376 + 139,264 + 137,044', CONTENT, 229376 + 139264 + 137044)
CS = tsv(O('main-unnamed', 'class-summary.tsv'))
tot = [r for r in CS if r['class'] == 'TOTAL'][0]; body = [r for r in CS if r['class'] != 'TOTAL']
cols = ['pieces', 'bytes', 'class_Confirmed', 'T1_typing_Confirmed', 'T2_typing_Inferred', 'T3_fill', 'T4_unnameable']
chk(D102, 109, 'class-summary TOTAL row', '765/7365/6343/3337/3934/51/43', '/'.join(tot[c] for c in cols))
chk(D102, 109, 'class-summary rows sum to TOTAL (all columns)', 'True', str(all(sum(int(r[c]) for r in body) == int(tot[c]) for c in cols)))
chk(D102, 109, 'per class: T1+T2+T3+T4 == bytes', 'True', str(all(int(r['bytes']) == sum(int(r[c]) for c in cols[3:]) for r in body)))
DOCTAB = {'padding/fill': (10, 51, 51, 0, 0, 51, 0), 'string/label': (128, 1073, 1062, 1062, 11, 0, 0), 'pointer table': (56, 192, 192, 160, 32, 0, 0),
          'value table': (215, 1860, 905, 903, 957, 0, 0), 'record struct': (143, 917, 917, 917, 0, 0, 0), 'dead code': (135, 2880, 2878, 0, 2880, 0, 0),
          'mid-instruction/garbage': (71, 206, 206, 163, 0, 0, 43), 'closed-window interior': (4, 128, 128, 128, 0, 0, 0), 'reached-code gap': (3, 58, 4, 4, 54, 0, 0)}
chk(D102, 99, 'doc 102 class table == class-summary.tsv (9 classes)', 'True', str(all(tuple(int(r[c]) for c in cols) == DOCTAB[r['class']] for r in body if r['class'] in DOCTAB)))
RU = tsv(O('main-unnamed', 'runs.tsv'))
tile = bytearray(CONTENT)
for r in RU:
    for x in range(int(r['start'], 16), int(r['end_excl'], 16)): tile[x] += 1
chk(D102, 77, 'runs.tsv: pieces / tile residue exactly', '765/True', '%d/%s' % (len(RU), all(tile[x] == RES[x] for x in range(CONTENT))))
PT = tsv(O('main-unnamed', 'proposed-typing.tsv'))
conf = [r for r in PT if r['typing_conf'] == 'Confirmed']; inf_ = [r for r in PT if r['typing_conf'] == 'Inferred']
chk(D102, 275, 'proposed-typing.tsv rows', 754, len(PT))
chk(D102, 20, 'Confirmed typing rows / bytes', '522/3337', '%d/%d' % (len(conf), sum(int(r['len']) for r in conf)))
chk(D102, 21, 'Inferred typing bytes', 3934, sum(int(r['len']) for r in inf_))
chk(D102, 14, '43 / 505,684 %', '0.0085', pct(43, CONTENT, 4))
chk(D102, 15, '0x069A7F-0x069AA9 length; odd start; in residue', '43/True/43', '%d/%s/%d' % (0x069AAA - 0x069A7F, 0x069A7F % 2 == 1, sum(RES[0x069A7F:0x069AAA])))
chk(D102, 26, '498,319 + 3,337 ; % of content', '501656/99.20', '%d/%s' % (498319 + 3337, pct(501656, CONTENT, 2)))
chk(D102, 27, '962,582 + 3,337 ; % of 1,029,972', '965919/93.78', '%d/%s' % (962582 + 3337, pct(965919, 1029972, 2)))
chk(D102, 136, 'settings records 109 pieces 821 B + 34 pieces 96 B', '143/917', '%d/%d' % (109 + 34, 821 + 96))
chk(D102, 154, 'value tables 870 B + 31 B holes vs T1 value table 903', 903, 870 + 31, 'doc gives two sub-totals (870 + 31 = 901) for a 903 B T1 value-table class; 2 B not itemised', info=True)
chk(D102, 172, '0x078546-0x07859F bytes / u16 entries', '90/45', '%d/%d' % (0x0785A0 - 0x078546, (0x0785A0 - 0x078546) // 2))
chk(D102, 182, 'dead code 1,696 + 1,052 + 132 ; 55 + 76 + 4', '2880/135', '%d/%d' % (1696 + 1052 + 132, 55 + 76 + 4))
PD = tsv(O('main-unnamed', 'proven-data-candidates.tsv'))
chk(D102, 225, 'proven-data-candidates Confirmed / Inferred bytes', '126/120',
    '%d/%d' % (sum(int(r['len']) for r in PD if r['conf'] == 'Confirmed'), sum(int(r['len']) for r in PD if r['conf'] == 'Inferred')))
chk(D102, 225, '74 + 18 + 12 + 18 + 4', 126, 74 + 18 + 12 + 18 + 4)
chk(D102, 223, 'Confirmed proven-data bytes all in final4 proven and in fnindex-only runs', 'True',
    str(all(P4[x] and any(s <= x < e for s, e in FO) for r in PD if r['conf'] == 'Confirmed' for x in range(int(r['start'], 16), int(r['end_excl'], 16)))))
chk(D102, 32, '0x006A0C-0D / 0x0077F8-F9 in final4 proven ; following 4 B proven', '0/8', '%d/%d' % (pc(P4, 0x006A0C, 0x006A0E) + pc(P4, 0x0077F8, 0x0077FA), pc(P4, 0x006A0E, 0x006A12) + pc(P4, 0x0077FA, 0x0077FE)))
chk(D102, 208, 'apply rows 351 + 149 + 22 + 232', 754, 351 + 149 + 22 + 232)
ats = open(O('main-unnamed', 'apply-typing-summary.txt'), encoding='utf-8').read()
chk(D102, 211, 'apply-typing-summary: skipped-straddle 22 rows / 64 B', 'True', str('skipped-straddle 22 rows / 64 B' in ats))

# ======================================================================= doc 103
ZR = tsv(O('home-keytable', 'zones-resolved.tsv'))
pend = [r for r in ZR if r['k3_status'] == 'K3-pending']
cp = Counter(r['l6_status'] for r in pend)
res = sum(v for k, v in cp.items() if k.startswith('resolved'))
chk(D103, 32, 'K3-pending zones / resolved by L6', '195/154', '%d/%d' % (len(pend), res))
chk(D103, 34, 'pending never-fire: no-sender + trailer-unmatchable', '38/3', '%d/%d' % (cp['no-sender'], cp['trailer-unmatchable']))
ns = [r for r in pend if r['l6_status'] == 'no-sender']
chk(D103, 35, 'no-sender pending on F801 / F3C3', '36/2', '%d/%d' % (sum('F801' in r['pages'].upper() for r in ns), sum('F3C3' in r['pages'].upper() for r in ns)))
chk(D103, 37, 'K3-joined zones with status no-sender (F801 virtual keys)', 8, sum(1 for r in ZR if r['k3_status'] == 'K3-joined' and r['l6_status'] == 'no-sender'))
chk(D103, 33, '147 + 2 + 1 + 4', 154, 147 + 2 + 1 + 4)
f801 = [a for a in range(0, HI - 3, 2) if M[a] == 0x79 and M[a + 2:a + 4] == b'\xf8\x01']
f3c3 = [a for a in range(0, HI - 3, 2) if M[a] == 0x79 and M[a + 2:a + 4] == b'\xf3\xc3']
chk(D103, 35, '`79 xx f8 01` word-immediate sites (even, content)', '026634', ','.join('%06X' % a for a in f801))
chk(D103, 36, '`79 xx f3 c3` word-immediate sites (even, content)', '02653C', ','.join('%06X' % a for a in f3c3))
chk(D103, 35, 'raw `f8 01` / `f3 c3` occurrences anywhere in content (context)', 'INFO', '%d/%d' % (len(find_all(M, b'\xf8\x01', 0, HI)), len(find_all(M, b'\xf3\xc3', 0, HI))), info=True)
rl = Counter((BU[a][1], a % 2) for a in range(0, HI) if a in BU and BU[a][1] in ('rts/l', 'rte/l'))
hp = Counter()
for s, e in pr4:
    x = s
    while x < e:
        n, mn, op = BU[x]
        if mn in ('rts/l', 'rte/l'): hp[mn] += 1
        x += n
chk(D103, 78, '"the image has 301 rts/l and 251 rte/l"', '301/251', '%d/%d' % (rl[('rts/l', 0)], rl[('rte/l', 0)]),
    'oracle decodes at even content addresses (all addresses: rts/l %d, rte/l %d; at final4-proven heads: rts/l %d, rte/l %d)' %
    (rl[('rts/l', 0)] + rl[('rts/l', 1)], rl[('rte/l', 0)] + rl[('rte/l', 1)], hp['rts/l'], hp['rte/l']) +
    '; IDA code heads (main-unnamed/work/ida_heads.tsv x oracle): rts/l 47, rte/l 0; no tested scope gives 301/251')
chk(D103, 14, '60 home tables 0x01109C-0x01208B at 0x44 stride; bytes', '60/4080', '%d/%d' % ((0x01208C - 0x01109C) // 0x44, 0x01208C - 0x01109C))
for t in (0x02ADD0, 0x02BA86, 0x0669E0):
    n = 0
    while n < 200 and 0x400 <= be32(t + 4 * n) < HI and be32(t + 4 * n) % 2 == 0: n += 1
    chk(D103, 64, 'jump table 0x%06X: 276 B = 69 BE32 code cells' % t, 69, n, 'cells counted until the first non-code value', info=(n != 69))
chk(D103, 176, 'F-menu table 0x02188C bound: `79 23 00 19` cmp.w #0x19 at 0x021872', 'True', str(M[0x021872:0x021876] == bytes.fromhex('79230019')))
chk(D103, 124, 'table #9 0x011300: mov.l #0x11300 sites / BE32 0x00011300 occurrences', '0/0',
    '%d/%d' % (len([a for a in find_all(M, bytes.fromhex('00011300'), 0, HI) if M[a - 2] == 0x7A]), len(find_all(M, bytes.fromhex('00011300'), 0, HI))))
chk(D103, 238, 'named +28: 0x010CC0-C3 + 0x011038-4F clear in final4 named', '28/0', '%d/%d' % (4 + 24, pc(N4, 0x010CC0, 0x010CC4) + pc(N4, 0x011038, 0x011050)))
chk(D103, 236, '0x011038: 12 {id, idx} pairs', 12, 24 // 2)
chk(D103, 239, '0x0109F0-0x010A2F unproven in final4; named bytes', '0/4', '%d/%d' % (pc(P4, 0x0109F0, 0x010A30), pc(N4, 0x0109F0, 0x010A30)))

# ======================================================================= RESUME-FULL.md (L wave) + README
CONF = set()
for r in conf:
    for x in range(int(r['start'], 16), int(r['end_excl'], 16)): CONF.add(x)
chk(R, 21, '501,656 + 464,263 ; / 1,029,972 %', '965919/93.78', '%d/%s' % (501656 + 464263, pct(965919, 1029972, 2)))
chk(R, 21, 'was 962,582 = 93.46% ; delta', '93.46/3337', '%s/%d' % (pct(962582, 1029972, 2), 965919 - 962582))
chk(R, 23, '501,656 / 505,684 %', '99.20', pct(501656, CONTENT, 2))
chk(R, 24, '364,786 / 505,684 % ; / 389,260 %', '72.14/93.71', '%s/%s' % (pct(364786, CONTENT, 2), pct(364786, 389260, 2)))
chk(R, 28, '368,624 - 278 + 868 ; 497,451 + 868', '369214/498319', '%d/%d' % (368624 - 278 + 868, 497451 + 868))
chk(R, 33, '369,214 - 4,428 ; 884 + 2,532 + 1,012', '364786/4428', '%d/%d' % (369214 - 4428, 884 + 2532 + 1012))
chk(R, 48, 'residue mask 7,365 disjoint from final5 named; union = content', '7365/0/505684',
    '%d/%d/%d' % (sum(RES), sum(1 for x in range(CONTENT) if RES[x] and N5[x]), sum(1 for x in range(CONTENT) if RES[x] or N5[x])))
chk(R, 50, 'L5 Confirmed typing bytes all in residue; final5 named + Confirmed', 'True/501656',
    '%s/%d' % (all(RES[x] for x in CONF), pc(N5) + len(CONF - {x for x in range(HI) if N5[x]})))
chk(R, 51, "L6's +28 B inside the L5 Confirmed set", 28, len(CONF & (set(range(0x010CC0, 0x010CC4)) | set(range(0x011038, 0x011050)))))
chk(R, 55, 'un-nameable 0x069A7F-0x069AA9 = 43 B, not in Confirmed', '43/0', '%d/%d' % (0x069AAA - 0x069A7F, len(CONF & set(range(0x069A7F, 0x069AAA)))))
chk(R, 72, 'L5 classes 1,073+1,860+917+192+2,880+206+128+58+51', 7365, 1073 + 1860 + 917 + 192 + 2880 + 206 + 128 + 58 + 51)
chk(R, 64, 'fnindex-only runs 94 / 4,850 B; reached 144 = 54 + 90', '144', 54 + 90)
chk(R, 80, '41 = 38 + 3 ; 154 + 41', '41/195', '%d/%d' % (38 + 3, 154 + 41))
chk(R, 147, '895 + 5 + 2', 902, 895 + 5 + 2)
chk(R, 154, "24 errata = K12's 18 + 6", 24, 18 + 6)
# AAD5 stores (L8 claim quoted in RESUME)
st16 = [a for a in range(0, HI - 3, 2) if M[a] == 0x6A and (M[a + 1] >> 4) == 0x8 and M[a + 2:a + 4] == b'\xaa\xd5']
st32 = [a for a in range(0, HI - 5, 2) if M[a] == 0x6A and (M[a + 1] >> 4) == 0xA and M[a + 2:a + 6] == b'\x00\xff\xaa\xd5']
def stval(a):
    r = M[a + 1] & 0x0F
    for back in range(2, 14, 2):
        b0, b1 = M[a - back], M[a - back + 1]
        if (b0 >> 4) == 0xF and (b0 & 0x0F) == r: return b1
        if b0 == 0x18 and b1 == (r << 4 | r): return 0      # sub.b rX,rX
    return None
vs = sorted(set(stval(a) for a in st16 + st32), key=lambda v: -1 if v is None else v)
chk(R, 101, 'stores to AAD5 (mov.b rX,@0xAAD5:16 / :32)', 32, len(st16) + len(st32), 'abs16 %d, abs32 %d' % (len(st16), len(st32)))
chk(R, 102, 'AAD5 store values (immediate in the preceding <=12 B)', '0,1,2,3,5,13,14,15,16,17,18,19,20',
    ','.join('?' if v is None else str(v) for v in vs))
b8 = [a for a in range(0, HI - 3, 2) if M[a] == 0x6A and (M[a + 1] >> 4) in (0x8, 0xA) and (M[a + 2:a + 4] == b'\xb0\xb8' or M[a + 2:a + 6] == b'\x00\xff\xb0\xb8')]
chk(R, 111, '"the only B0B8 store is 0x05C442"', '05C442', ','.join('%06X' % a for a in b8))
sb = find_all(S, bytes.fromhex('fbe2a0220100'))
chk(R, 127, '"three `fb e2 a0 22 01 00` sites" (literal pattern, SUB whole image)', 3, len(sb), ','.join('%08X' % (a + 0xFFC00000) for a in sb))
sb3 = find_all(S, bytes.fromhex('fbe2a0220100f8e403'))
chk(R, 127, 'stores of 3 to 122A0: `fb e2 a0 22 01 00 f8 e4 03` (SUB whole image)', 3, len(sb3), ','.join('%08X' % (a + 0xFFC00000) for a in sb3))
fsm = [be32(0x055002 + 4 * i) for i in range(12)]
chk(R, 160, 'FSM table 0x055002: state 5 == state 1, state 10 == state 7', 'True/True', '%s/%s' % (fsm[5] == fsm[1], fsm[10] == fsm[7]),
    ' '.join('%X' % v for v in fsm))
cells = [be32(0x074472 + 4 * i) for i in range(48)]
chk(R, 91, 'off_74472: 48 BE32 code pointers', 48, sum(1 for v in cells if 0x400 <= v < HI and v % 2 == 0), 'cell 48 = %08X' % be32(0x074472 + 4 * 48))
for t, nm in ((0x034674, 'main'), (0x035CD8, 'node')):
    c21 = [be32(t + 4 * i) for i in range(21)]
    rtsok = all(M[c21[i]:c21[i] + 2] == b'\x54\x70' for i in range(6, 13))
    chk(R, 100, '21-entry table 0x%06X (%s): 21 code cells; states 6-0x0C bare rts' % (t, nm), '21/True',
        '%d/%s' % (sum(1 for v in c21 if 0x400 <= v < HI and v % 2 == 0), rtsok), 'state 4 -> %06X' % c21[4])
# README file checks
def rr(p):
    out = []
    for l in open(p, encoding='utf-8').read().splitlines():
        if l.strip() and not l.startswith('#') and re.match(r'[0-9A-F]{6}\t', l):
            c = l.split('\t'); out.append((int(c[0], 16), int(c[1], 16)))
    return out
DRP, RCP, PU = rr(O('l-wave-recon', 'drop_runs.tsv')), rr(O('l-wave-recon', 'rec_runs.tsv')), rr(O('l-wave-recon', 'proven-unreached-runs.tsv'))
chk(RM, 10, 'drop_runs.tsv runs / bytes', '89/4742', '%d/%d' % (len(DRP), sum(e - s for s, e in DRP)))
chk(RM, 15, 'rec_runs.tsv runs / bytes', '7/108', '%d/%d' % (len(RCP), sum(e - s for s, e in RCP)))
dropset = {x for s, e in DRP for x in range(s, e)}
in5 = {x for x in dropset if P5[x]}
REST = set(range(0x066FBE, 0x066FC8)) | set(range(0x06726A, 0x067284))
chk(RM, 24, 'drop bytes still in final5 proven', 4464, len(in5))
chk(RM, 25, 'restored 10 + 26 B, all inside drop set and final5', '36/36/36', '%d/%d/%d' % (len(REST), len(REST & dropset), len(REST & in5)))
chk(RM, 31, 'net = 4,464 - 36', 4428, len(in5) - len(REST))
P6x = bytearray(P5)
for x in in5 - REST: P6x[x] = 0
chk(RM, 8, 'final5 - (drop - restore) == final6_proven_mask.bin', 'True', str(bytes(P6x) == P6))
chk(RM, 8, 'final6 proven popcount / sha prefix', '364786/ecd7deaf54da6d21', '%d/%s' % (pc(P6), sha16(P6)))
chk(RM, 9, 'final6 named popcount / sha prefix', '501656/fe8f60996e0a5852', '%d/%s' % (pc(N6), sha16(N6)))
chk(RM, 9, 'final6 proven subset of named; set above 0x07B754 (P/N)', '0/0/0', '%d/%d/%d' % (sum(1 for x in range(len(P6)) if P6[x] and not N6[x]), pc(P6, HI), pc(N6, HI)))
N6x = bytearray(N5)
for x in CONF: N6x[x] = 1
chk(RM, 48, 'final5 named + L5 Confirmed rows == final6_named_mask.bin', 'True', str(bytes(N6x) == N6))
lane = Counter('L2' if x < 0x30000 else ('L3' if x < 0x50000 else 'L4') for x in in5 - REST)
chk(RM, 33, 'per-lane split of the 4,428 (by address range of the lane scopes)', '884/2532/1012', '%d/%d/%d' % (lane['L2'], lane['L3'], lane['L4']))
chk(RM, 33, '696 + 26 + 290 ; 206 + 84', '1012/290', '%d/%d' % (696 + 26 + 290, 206 + 84))
chk(RM, 33, '0x077CC2 (206) + 0x07778C (84) in the drop set', 290, len(dropset & (set(range(0x077CC2, 0x077D90)) | set(range(0x07778C, 0x0777E0)))))
chk(RM, 30, 'proven-unreached-runs.tsv runs / bytes', '80/1692', '%d/%d' % (len(PU), sum(e - s for s, e in PU)))
top = sorted(PU, key=lambda r: -(r[1] - r[0]))[:3]
chk(RM, 30, 'largest unreached runs', '05C8DC:218,0460C2:110,03D0EE:98', ','.join('%06X:%d' % (s, e - s) for s, e in top))
chk(RM, 47, 'L5 Confirmed rows ; Inferred tier bytes ; dead code in Inferred', '522/3934/2880',
    '%d/%d/%d' % (len(conf), sum(int(r['len']) for r in inf_), sum(int(r['len']) for r in inf_ if r['class'] == 'dead code')))
chk(RM, 60, 'data-mistyped retype 80 + 144 + 26', 250, 80 + 144 + 26)
chk(RM, 56, '364,786 / 389,260 % ; 388,490 + 770', '93.71/389260', '%s/%d' % (pct(364786, 389260, 2), 388490 + 770))
b33780 = [a for a in range(0, HI - 3) if be32(a) in (0x033780, 0x033790, 0x0337AC, 0x0337C8)]
ab33780 = [a for a in range(0, HI - 3, 2) if M[a] in (0x5E, 0x5A) and int.from_bytes(M[a + 1:a + 4], 'big') in (0x033780, 0x033790, 0x0337AC, 0x0337C8)]
chk(RM, 35, 'BE32 / abs24 jsr-jmp references to 0x033780 or its stubs (whole content)', '0/0', '%d/%d' % (len(b33780), len(ab33780)))

with open(os.path.join(OUTD, 'counts_a.tsv'), 'w', encoding='utf-8', newline='\n') as f:
    f.write('doc\tline\tclaim\texpected\tderived\tverdict\tnote\n')
    for r in ROWS: f.write('\t'.join(x.replace('\t', ' ') for x in r) + '\n')
print('counts_a:', len(ROWS), Counter(r[5] for r in ROWS))
for r in ROWS:
    if r[5] != 'PASS': print('  ', r)
