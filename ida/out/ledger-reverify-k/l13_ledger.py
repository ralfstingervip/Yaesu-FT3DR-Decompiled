import sys
from pathlib import Path as _Path
_REPO = _Path(__file__).resolve().parents[3]
# L13 -- part 1: re-derive the K-wave + follow-up (docs 95-97) ledger from disk.
# Read-only on every input. Writes only ida\out\ledger-reverify-k\counts_ledger.tsv.
# Run: python "ida/out/ledger-reverify-k/l13_ledger.py"
import hashlib, os, re, struct, csv

ROOT = str(_REPO)
OUT = os.path.join(ROOT, r'ida\out\ledger-reverify-k')
P = lambda *a: os.path.join(ROOT, *a)
sys.exit('The firmware image is not in this repository.')
CONTENT = 505684
rows = []

def chk(group, item, got, exp, note=''):
    ok = (got == exp) if not callable(exp) else exp(got)
    rows.append((group, item, str(got), str(exp) if not callable(exp) else note, 'PASS' if ok else 'FAIL', note if not callable(exp) else ''))
    return ok

def rd(path):
    return open(P(path), 'rb').read()

def pc(b):
    return sum(1 for x in b if x)

def runs(b, val=1):
    out, i, n = [], 0, len(b)
    while i < n:
        if b[i]:
            j = i
            while j < n and b[j]:
                j += 1
            out.append((i, j))
            i = j
        else:
            i += 1
    return out

# ---- images
hm, hs = hashlib.sha256(M).hexdigest(), hashlib.sha256(S).hexdigest()
chk('image', 'MAIN sha256 prefix', hm[:16], '8e3ecd05409b2c31')
chk('image', 'SUB sha256 prefix', hs[:16], 'b93570b3c2f69ccb')
chk('image', 'MAIN size', len(M), 1048576)
chk('image', 'SUB size', len(S), 4194304)
chk('image', 'MAIN content end 0x7B754 (= 505,684); bytes above are all 0xFF or 0x00',
    all(x in (0, 0xFF) for x in M[CONTENT:]), True, 'content length used as denominator')

# ---- MAIN masks
f4p = rd(r'ida\out\main-final4\final4_proven_mask.bin')
f4n = rd(r'ida\out\main-final4\final4_named_mask.bin')
f3p = rd(r'ida\out\main-final3\final3_proven_mask.bin')
f3n = rd(r'ida\out\main-final3\final3_named_mask.bin')
for nm, b in (('final4_proven', f4p), ('final4_named', f4n), ('final3_proven', f3p), ('final3_named', f3n)):
    chk('mask', nm + ' length', len(b), 1048576 if nm.startswith('final4') else 505684,
        '' if nm.startswith('final4') else 'final3 masks are content-length (505,684 B); doc 83 Findings 4 says final4 uses "the same format as main-final3: 1,048,576 bytes" -- wording only')
    chk('mask', nm + ' values are 0/1 only', set(b) <= {0, 1}, True)
    chk('mask', nm + ' zero above 0x7B754', pc(b[CONTENT:]), 0)
chk('mask', 'final4_proven popcount', pc(f4p), 368624)
chk('mask', 'final4_named popcount', pc(f4n), 497451)
chk('mask', 'final3_proven popcount', pc(f3p), 368366)
chk('mask', 'final3_named popcount', pc(f3n), 497314)
chk('mask', 'final4_proven sha256 prefix', hashlib.sha256(f4p).hexdigest()[:16], '3a45f1f46b36a47f')
chk('mask', 'final4_named sha256 prefix', hashlib.sha256(f4n).hexdigest()[:16], '2b8255b683ca474a')
lostp = sum(1 for i in range(CONTENT) if f3p[i] and not f4p[i])
lostn = sum(1 for i in range(CONTENT) if f3n[i] and not f4n[i])
chk('mask', 'final3_proven \\ final4_proven (lost)', lostp, 0)
chk('mask', 'final3_named \\ final4_named (lost)', lostn, 0)
chk('mask', 'final4_proven \\ final4_named (proven not named)', sum(1 for i in range(CONTENT) if f4p[i] and not f4n[i]), 0)
newp = bytes(1 if (f4p[i] and not f3p[i]) else 0 for i in range(CONTENT))
newn = bytes(1 if (f4n[i] and not f3n[i]) else 0 for i in range(CONTENT))
chk('mask', 'final4_proven \\ final3_proven bytes', pc(newp), 258)
chk('mask', 'final4_named \\ final3_named bytes', pc(newn), 137)
RUN12 = [(0x04E2D6, 72), (0x065EFA, 16), (0x0179DA, 8), (0x029174, 6), (0x02B026, 10), (0x02B36A, 18), (0x02B3B2, 14),
         (0x02B64A, 64), (0x02B8BC, 10), (0x02C25E, 10), (0x064BE6, 16), (0x0696BC, 14)]
got = sorted((a, b - a) for a, b in runs(newp))
chk('mask', 'new proven = exactly the 12 listed runs (RESUME K ledger / doc 83 table)', got, sorted(RUN12))
chk('mask', 'sum of 12 listed runs', sum(n for a, n in RUN12), 258)
chk('mask', 'K1b runs (12 minus 0x04E2D6) sum', sum(n for a, n in RUN12 if a != 0x04E2D6), 186)
chk('mask', "J4's 0x065EFA/F00/F06 = 16 B", sum(newp[0x065EFA:0x065F0A]), 16)
# named delta decomposition: 95 proven-code + 2 label + 40 helper tails
nn_proven = sum(1 for i in range(CONTENT) if newn[i] and f4p[i])
chk('mask', 'named delta that is new proven code', nn_proven, 95)
chk('mask', 'named delta: Baro header 0x04E31E-0x04E31F', sum(newn[0x04E31E:0x04E320]), 2)
chk('mask', 'named delta remainder (helper-table tails)', pc(newn) - nn_proven - sum(newn[0x04E31E:0x04E320]), 40)
chk('mask', 'named delta runs not proven and not Baro (count of runs)', len([r for r in runs(bytes(newn[i] and not f4p[i] and not (0x04E31E <= i < 0x04E320) for i in range(CONTENT)))]), 15,
    )
chk('mask', 'named 497,314 + 95 + 2 + 40', 497314 + 95 + 2 + 40, 497451)
# closed window
W0, W1 = 0x078106, 0x07B754
chk('mask', 'final4_proven set bytes inside window 0x078106-0x07B753', sum(f4p[W0:W1]), 220)
chk('mask', 'final3_proven set bytes inside window', sum(f3p[W0:W1]), 220)
chk('mask', 'final4_proven inside window all inside code 0x078106-0x078545', sum(f4p[0x078546:W1]), 0)
I12 = list(range(0x054D22, 0x054D4C)) + list(range(0x054F3A, 0x054F88))
chk('mask', 'I12 blocks 0x054D22-4B + 0x054F3A-87 (120 B) set in final4_proven', sum(f4p[i] for i in I12), 0, 'len %d' % len(I12))
chk('mask', 'new proven bytes inside I12 blocks', sum(newp[i] for i in I12), 0)
chk('mask', 'new proven bytes inside the window', sum(newp[W0:W1]), 0)
chk('ledger', 'J-wave 368,438 = 368,366 + 72', 368366 + 72, 368438)
chk('ledger', '368,624 - 368,438 = 186 (K1b)', 368624 - 368438, 186)
# -278 demotion
D0, D1 = 0x054AE2, 0x054BF8
chk('demotion', 'range length 0x054AE2-0x054BF7', D1 - D0, 278)
chk('demotion', 'range fully set in final4_proven', sum(f4p[D0:D1]), 278)
chk('demotion', 'range fully set in final4_named', sum(f4n[D0:D1]), 278)
chk('demotion', 'head 0x054AC0-0x054AE1 in final4_proven', sum(f4p[0x054AC0:D0]), 0)
chk('demotion', '0x054BF8-0x054C11 in final4_proven (stays)', sum(f4p[0x054BF8:0x054C12]), 26)
chk('demotion', '368,624 - 278', 368624 - 278, 368346)
chk('demotion', 'bytes 0x054ADE', M[0x054ADE:0x054AE2].hex(' '), '6a 0a a5 1a')
chk('demotion', 'bytes 0x054AE2', M[0x054AE2:0x054AE4].hex(' '), '4b 0c')
chk('demotion', 'bytes 0x054BF6 (rts)', M[0x054BF6:0x054BF8].hex(' '), '54 70')
chk('demotion', 'bytes 0x002214', M[0x002214:0x002218].hex(' '), '5e 05 4b f8')
chk('demotion', 'bytes 0x054AC0', M[0x054AC0:0x054AC4].hex(' '), '5e 05 45 68')
# whole-content scans (0..0x7B753)
be32 = [i for i in range(0, CONTENT - 3) if 0x054AC0 <= struct.unpack('>I', M[i:i + 4])[0] < D1]
chk('demotion', 'BE32 values in [0x054AC0,0x054BF8) at even offsets in content', len([i for i in be32 if i % 2 == 0]), 0)
chk('demotion', 'BE32 values in [0x054AC0,0x054BF8) at odd offsets (not pointers on H8SX)', ['%06X=%08X' % (i, struct.unpack('>I', M[i:i + 4])[0]) for i in be32 if i % 2],
    ['04E9FB=00054B00'], 'byte table 00 04 6a 00 00 05 4b 00 00 06 59 00; not one of doc 83 values 054AC0/054AE2/054AE4/054AF0')
chk('demotion', 'BE32 exactly 054AC0/054AE2/054AE4/054AF0 any alignment', len([i for i in be32 if struct.unpack('>I', M[i:i + 4])[0] in (0x054AC0, 0x054AE2, 0x054AE4, 0x054AF0)]), 0)
abs24 = [i for i in range(0, CONTENT - 3) if M[i] in (0x5A, 0x5E) and M[i + 1] == 0x05 and 0x054AC0 <= (0x050000 | M[i + 2] << 8 | M[i + 3]) < D1]
chk('demotion', 'jmp/jsr abs24 (5a/5e) into [0x054AC0,0x054BF8) anywhere in content', len(abs24), 0)
movl = [i for i in range(0, CONTENT - 5) if M[i] == 0x7A and (M[i + 1] & 0xF8) == 0 and 0x054AC0 <= struct.unpack('>I', M[i + 2:i + 6])[0] < D1]
chk('demotion', 'mov.l #imm (7a 0x) into range anywhere', len(movl), 0)
# relative branches from proven code (any proven offset, upper bound on heads) into range, origin outside range
br = []
rx = re.compile(r'\(0x([0-9a-f]+)\)')
for ln in open(P(r'ida\out\h8s-decode\work\bu_all.tsv'), encoding='utf-8', errors='replace'):
    p = ln.rstrip('\n').split('\t')
    if len(p) < 4 or not p[2].startswith('b'):
        continue
    a = int(p[0], 16)
    if not f4p[a] or D0 <= a < D1:
        continue
    m = rx.search(p[3])
    if m and D0 <= int(m.group(1), 16) < D1:
        br.append('%06X %s %s' % (a, p[2], p[3]))
chk('demotion', 'relative branches (bXX/bsr) decoded at any final4-proven offset outside range, targeting range', len(br), 0, '; '.join(br[:5]))
# fnindex-only runs
fr = [r for r in csv.reader(open(P(r'ida\out\main-final4\fnindex-only-runs.tsv'), encoding='utf-8'), delimiter='\t') if r and not r[0].startswith('#') and r[0] != 'start']
chk('fnindex', 'fnindex-only-runs.tsv runs', len(fr), 94)
chk('fnindex', 'fnindex-only-runs.tsv sum', sum(int(r[2]) for r in fr), 4850)
chk('fnindex', 'minus 0x054AE2 (93 runs / 4,572 B)', (len(fr) - 1, sum(int(r[2]) for r in fr if r[0] != '054AE2')), (93, 4572))
big = sorted(((int(r[2]), r[0]) for r in fr), reverse=True)[:5]
chk('fnindex', 'five largest', [(a, n) for n, a in big], [('03C668', 820), ('046210', 472), ('054AE2', 278), ('077CC2', 206), ('01C4D2', 194)])
chk('fnindex', 'every fnindex-only run fully final4-proven', all(sum(f4p[int(r[0], 16):int(r[1], 16)]) == int(r[2]) == int(r[1], 16) - int(r[0], 16) for r in fr), True)

# ---- doc 95: 868 B
R13 = [(0x07810C, 0x07815B, 80), (0x0781A4, 0x0781A9, 6), (0x0781C4, 0x078221, 94), (0x07823C, 0x07825F, 36),
       (0x078268, 0x078279, 18), (0x07827C, 0x078333, 184), (0x07833C, 0x07837B, 64), (0x078384, 0x0783D9, 86),
       (0x0783EE, 0x07842D, 64), (0x078440, 0x078441, 2), (0x078448, 0x078459, 18), (0x078462, 0x078507, 166),
       (0x078514, 0x078545, 50)]
for a, b, n in R13:
    chk('doc95', 'range %06X-%06X length' % (a, b), b - a + 1, n)
chk('doc95', '13 ranges sum', sum(n for a, b, n in R13), 868)
chk('doc95', '13 ranges: final4_proven set bytes', sum(sum(f4p[a:b + 1]) for a, b, n in R13), 0)
chk('doc95', '13 ranges: final4_named set bytes', sum(sum(f4n[a:b + 1]) for a, b, n in R13), 0)
clear = [i for i in range(0x078106, 0x078546) if not f4p[i]]
chk('doc95', 'unset proven bytes in 0x078106-0x078545', len(clear), 868)
chk('doc95', 'unset proven runs in code part == the 13 ranges', [(a, b - 1) for a, b in runs(bytes(0 if f4p[i] else 1 for i in range(0x078106, 0x078546)))],
    [(a - 0x078106, b - 0x078106) for a, b, n in R13])
chk('doc95', 'unset named bytes in 0x078106-0x078545', sum(1 for i in range(0x078106, 0x078546) if not f4n[i]), 868)
chk('doc95', 'span 0x078106-0x07B753 inclusive', 0x07B753 - 0x078106 + 1, 13902)
chk('doc95', 'data part 13902-1088', 13902 - 1088, 12814)
# 336 heads vs image and oracle
ch = list(csv.DictReader(open(P(r'ida\out\service-window\code-heads.tsv'), encoding='utf-8'), delimiter='\t'))
chk('doc95', 'code-heads.tsv rows', len(ch), 336)
cov, bad_img, gaps, pos = 0, [], 0, 0x078106
for r in ch:
    a, n = int(r['addr'], 16), int(r['len'])
    if a != pos:
        gaps += 1
    pos = a + n
    cov += n
    if M[a:a + n].hex(' ') != r['hex'].strip():
        bad_img.append(r['addr'])
chk('doc95', 'heads contiguous from 0x078106 (gaps)', gaps, 0)
chk('doc95', 'heads end at 0x078546', pos, 0x078546)
chk('doc95', 'heads byte total', cov, 1088)
chk('doc95', 'heads whose hex != image', len(bad_img), 0, ' '.join(bad_img[:5]))
bu = {}
for ln in open(P(r'ida\out\h8s-decode\work\bu_all.tsv'), encoding='utf-8', errors='replace'):
    p = ln.rstrip('\n').split('\t')
    a = int(p[0], 16)
    if 0x078106 <= a < 0x078546:
        bu[a] = (int(p[1]), p[2])
bad_or = [r['addr'] for r in ch if bu.get(int(r['addr'], 16), (None,))[0] != int(r['len'])]
chk('doc95', 'heads whose length != bu_all.tsv oracle length', len(bad_or), 0, ' '.join(bad_or[:5]))
bad_mn = [r['addr'] for r in ch if bu[int(r['addr'], 16)][1] != r['text'].split()[0]]
chk('doc95', 'heads whose mnemonic != bu_all.tsv mnemonic', len(bad_mn), 0, ' '.join(bad_mn[:5]))
# the 868 bytes are instruction bytes of those heads
hb = set()
for r in ch:
    hb.update(range(int(r['addr'], 16), int(r['addr'], 16) + int(r['len'])))
chk('doc95', '868 clear bytes all inside the 336 heads', all(i in hb for i in clear), True)
heads_clear = [r for r in ch if any(not f4p[i] for i in range(int(r['addr'], 16), int(r['addr'], 16) + int(r['len'])))]
heads_part = [r for r in heads_clear if not all(not f4p[i] for i in range(int(r['addr'], 16), int(r['addr'], 16) + int(r['len'])))]
chk('doc95', 'heads partly set/partly clear in proven (should be 0: ranges on head boundaries)', len(heads_part), 0, ' '.join(r['addr'] for r in heads_part[:5]))

# ---- follow-up ledger
chk('ledger', 'MAIN proven follow-up 368,346 + 868', 368346 + 868, 369214)
chk('ledger', 'MAIN named follow-up 497,451 + 868', 497451 + 868, 498319)
chk('ledger', 'K-wave headline 497,451 + 464,263', 497451 + 464263, 961714)
chk('ledger', 'follow-up headline 498,319 + 464,263', 498319 + 464263, 962582)
chk('ledger', 'denominator 505,684 + 524,288', 505684 + 524288, 1029972)
pct = lambda a, b, d=2: round(100.0 * a / b, d)
chk('ledger', 'headline % 962,582/1,029,972', pct(962582, 1029972), 93.46)
chk('ledger', 'K-wave headline % 961,714/1,029,972', pct(961714, 1029972), 93.37)
chk('ledger', 'doc 83 headline % (3 dp)', pct(961714, 1029972, 3), 93.373)
chk('ledger', 'MAIN named % 498,319/505,684', pct(498319, 505684), 98.54)
chk('ledger', 'MAIN named % 497,451/505,684', pct(497451, 505684), 98.37)
chk('ledger', 'proven % 369,214/505,684', pct(369214, 505684), 73.01)
chk('ledger', 'proven % 368,346/505,684', pct(368346, 505684), 72.84)
chk('ledger', 'proven % 368,346/388,490', pct(368346, 388490), 94.81)
chk('ledger', 'doc 83 proven % 368,624/505,684 (3 dp)', pct(368624, 505684, 3), 72.896)
chk('ledger', 'doc 83 proven % 368,624/388,490 (3 dp)', pct(368624, 388490, 3), 94.886)
chk('ledger', 'doc 83 alt proven % 368,346 (3 dp)', pct(368346, 505684, 3), 72.841)
chk('ledger', 'doc 83 K1b-J4-only: 368,366+72+16 / named 497,314+70+2+... ', 368366 + 72 + 16, 368454)
chk('ledger', 'K1b-J4-only after demotion', 368454 - 278, 368176)
chk('ledger', 'doc 83 J4-only headline 497,387 + 464,263', 497387 + 464263, 961650)
chk('ledger', 'doc 83 J4-only headline % (3 dp)', pct(961650, 1029972, 3), 93.367)
chk('ledger', 'doc 83 alt named-removed 497,451-278 / headline', (497451 - 278, 497173 + 464263, pct(961436, 1029972, 3)), (497173, 961436, 93.346))
chk('ledger', 'K wave +67 B on J (961,714-961,647)', 961714 - 961647, 67)
chk('ledger', 'follow-up +868 on K (962,582-961,714)', 962582 - 961714, 868)
chk('ledger', 'SUB window % 464,263/524,288', pct(464263, 524288), 88.55)
chk('ledger', 'SUB code+typed % 520,552/524,288', pct(520552, 524288), 99.29)
chk('ledger', 'strict companion 497,451 + 457,462', 497451 + 457462, 954913)
chk('ledger', 'strict companion %', pct(954913, 1029972), 92.71)

# ---- informational: a later lane's MAIN_FINAL5 masks (written after the follow-up; not part of the K ledger)
f5p_path = P(r'ida\out\main-final5/final5_proven_mask.bin')
if os.path.exists(f5p_path):
    f5p, f5n = rd(r'ida\out\main-final5/final5_proven_mask.bin'), rd(r'ida\out\main-final5/final5_named_mask.bin')
    addp = [i for i in range(CONTENT) if f5p[i] and not f4p[i]]
    remp = [i for i in range(CONTENT) if f4p[i] and not f5p[i]]
    chk('final5-info', 'final5_proven popcount = follow-up proven', pc(f5p), 369214)
    chk('final5-info', 'final5_named popcount = follow-up named', pc(f5n), 498319)
    chk('final5-info', 'final5 minus final4 proven = exactly the 868 window bytes', sorted(addp) == sorted(clear), True)
    chk('final5-info', 'final4 minus final5 proven = exactly 0x054AE2-0x054BF7', remp == list(range(D0, D1)), True)
    chk('final5-info', 'final5 named = final4 named + the 868 window bytes', [i for i in range(CONTENT) if f5n[i] != f4n[i]] == sorted(clear), True)

# ---- SUB: K7 masks vs I17
for k, exp in (('headline', 464165), ('headline_w2', 464263), ('reach', 454692), ('reach_w2', 457462), ('allwf', 467999)):
    a = rd(r'ida\out\sub-final3\raw\mask_final3_after_%s.bin' % k)
    b = rd(r'ida\out\sub-final2\raw\mask_final2_%s.bin' % k)
    chk('sub', 'K7 mask_final3_after_%s == I17 mask_final2_%s (byte-identical)' % (k, k), a == b, True, 'len %d/%d' % (len(a), len(b)))
    chk('sub', 'popcount mask_final3_after_%s' % k, pc(a), exp)
    chk('sub', 'popcount mask_final2_%s' % k, pc(b), exp)
    bb = os.path.join(P(r'ida\out\sub-final3\raw'), 'mask_final3_before_%s.bin' % k)
    if os.path.exists(bb):
        chk('sub', 'K7 mask_final3_before_%s == after' % k, rd(r'ida\out\sub-final3\raw\mask_final3_before_%s.bin' % k) == a, True)
# counts.txt figures
ct = open(P(r'ida\out\sub-final3\counts.txt'), encoding='utf-8').read()
for lab, v in (('typed data mask', 56289), ('code+typed (headline+w2)', 520552), ('functions in DB', 2395)):
    m = re.search(re.escape(lab) + r'\s+(\d+)', ct)
    chk('sub', 'sub-final3/counts.txt ' + lab, int(m.group(1)) if m else None, v)

with open(os.path.join(OUT, 'counts_ledger.tsv'), 'w', encoding='utf-8', newline='') as f:
    f.write('group\titem\tgot\texpected\tverdict\tnote\n')
    for r in rows:
        f.write('\t'.join(r) + '\n')
print('ledger checks: %d, PASS %d, FAIL %d' % (len(rows), sum(r[4] == 'PASS' for r in rows), sum(r[4] == 'FAIL' for r in rows)))
for r in rows:
    if r[4] != 'PASS':
        print(r)
