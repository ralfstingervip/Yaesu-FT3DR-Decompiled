import sys
from pathlib import Path as _Path
_REPO = _Path(__file__).resolve().parents[3]
# N14 -- merge the strict (citations_strict.tsv) and loose (loose.tsv) citation passes into citations.tsv, applying a
# hand-reviewed verdict to every LOOSE-NEAR / UNPAIRED row. Every PASS-WITHIN verdict here names the address where the
# run was re-read and is byte-checked again by this script. Also runs the count claims (counts.tsv) and writes the
# per-doc summary (summary.tsv). Read-only on the images and docs.
import os, re, sys
from collections import Counter, defaultdict
sys.dont_write_bytecode = True
ROOT = str(_REPO)
OUT = os.environ.get('OUTDIR', os.path.dirname(os.path.abspath(__file__)))
sys.exit('The firmware image is not in this repository.')
SUBB = 0xFFC00000
def at(a, n): return (S[a - SUBB:a - SUBB + n] if a >= SUBB else M[a:a + n])
def hb(s): return bytes(int(x, 16) for x in s.replace('|', ' ').split())
def hits(p, buf=M, hi=0x7B754):
    p = hb(p) if isinstance(p, str) else p; o = []; i = buf.find(p)
    while 0 <= i < hi: o.append(i); i = buf.find(p, i + 1)
    return o
norm = lambda s: re.sub(r'\s+', ' ', s.replace('…', ' … ')).strip().lower()

# ---------------------------------------------------------------- hand review of loose rows
# (doc prefix, line, cited bytes) -> (verdict, resolved address or None, note)
W = 'PASS-WITHIN'
REV = {
    ('114', 84, '5e 01 c4 d2'): (W, 0x01C28E, 'inside the cited range 0x01C27E-0x01C294 ("contains")'),
    ('115', 108, '40 0c'): (W, 0x03EF5E, 'the predecessor of arm 03EF60 ("following `40 0c`"); same at 03EF9E / 03EFDE'),
    ('115', 108, 'fc 03 40 04'): (W, 0x03EF64, '"the next arm in each"; same at 03EFA4 / 03EFE4'),
    ('115', 110, '5e 05 14 c6'): (W, 0x04B1DA, 'inside the cited run 04B1D0-04B1E5'),
    ('115', 110, '5e 05 16 fe'): (W, 0x04B1E0, 'inside the cited run 04B1D0-04B1E5'),
    ('116', 85, '40 16 5e 06 6f b4 40 10 5e 06 72 50'): ('WRONG-ADDR', 0x062806, 'run starts at 0x062806; 0x062808 is the `5e 06 6f b4` jsr inside it (-2, listing convention)'),
    ('117', 75, '7a 16 00 01 48 a0'): (W, 0x0191A2, 'second of the "+"-joined sequence after 0x01919A'),
    ('117', 75, '5d 60'): (W, 0x0191A8, 'third of the sequence'),
    ('117', 216, '7a 05 00 02 d7 04'): ('UNADDRESSED-PRESENT', 0x02D6FA, 'loader of table 0x02D704; the doc gives no site address'),
    ('117', 216, 'd7 fe'): ('DROPPED', None, 'immediate tail of the loader `7a 05 00 02 d7 fe` (at 0x02D7F4); not bytes at the table address'),
    ('117', 216, 'e2 d8'): ('DROPPED', None, 'immediate tail of `7a 05 00 02 e2 d8` (at 0x02E2CE)'),
    ('117', 216, 'e3 d2'): ('DROPPED', None, 'immediate tail of `7a 05 00 02 e3 d2` (at 0x02E3C8)'),
    ('118', 100, '40 44'): (W, 0x0168B2, 'last instruction of the cited range 0x01687E-0x0168B3 ("ending")'),
    ('118', 132, '01 00 6b 86 b2 88'): (W, 0x06991A, 'second of the "/"-joined pair after 0x069914'),
    ('118', 135, '47 02'): (W, 0x069988, 'byte 37 of live routine 0x069964 (the first point where the stale copy differs)'),
    ('118', 136, '47 0e'): (W, 0x069AA3, 'byte 37 of the stale copy 0x069A7F'),
    ('118', 146, '6a 8c b9 e4'): (W, 0x029582, '`fc 0N 6a 8c b9 e4`: fc 03..07 at 0x029580/029558/0295FE/0294EE/029594 in that order (each checked in counts.tsv)'),
    ('118', 147, '78 40 6a 2a 00 00 9b 15'): (W, 0x009B8A, '"then", 10 B after 0x009B80'),
    ('118', 148, '7a 05 00 00 b7 ee'): (W, 0x007E9A, 'second of the sequence after 0x007E96'),
    ('118', 149, '7a 05 00 00 f0 12'): (W, 0x00DE4A, 'second of the sequence after 0x00DE48'),
    ('118', 152, '10 33 0a b5 69 54'): (W, 0x01E180, '"0x01E17A … " (+6)'),
    ('118', 153, 'ee 0f fd 0a 50 d6 … ed 0f 08 de'): (W, 0x025AD4, 'index calc 22 B before the readers 0x025AEA / 0x025F0A (`78 60 6b 25 00 02 5b e2`); twin at 0x025EF4'),
    ('118', 156, '6d 36'): ('UNADDRESSED-PRESENT', 0x02F9F4, 'reader instruction, no address given; twin 0x03149C'),
    ('118', 156, '01 00 69 34'): ('UNADDRESSED-PRESENT', 0x02F9F8, 'reader instruction, no address given; twin 0x0314A0'),
    ('118', 175, '10 73 78 b0 6b 24 00 03 90 40'): (W, 0x038D3E, '"0x038D38 … " (+6)'),
    ('118', 175, 'ab 10 47 72'): (W, 0x038CF6, 'the separate 0x10 case before reader 0x038D38'),
    ('118', 177, 'ff 00'): (W, 0x04C3C5, 'row 16 is `2d x7 ff 00` at 0x04C3BE; 0x04C3C6 is its 00 pad byte'),
    ('118', 196, '78 e0 6b 26 00 00 0d'): ('PASS-PATTERN', 0x0007C6, '`78 e0 6b 26 00 00 0d xx`: 3 readers each of 0D32/0D72/0DB2/0DEA (counts.tsv)'),
    ('118', 199, 'ff 00'): (W, 0x04C3C5, 'as 118:177'),
    ('120', 126, '5e 03 fa 2c'): (W, 0x003354, '"0x003346 … " (+14)'),
    ('120', 149, '6a 8c 95 51'): (W, 0x034754, '"0x034750 … " (+4)'),
    ('120', 163, 'fc 01 6a 8c aa d7'): ('PASS-PATTERN', 0x034D2C, 'all five listed sites match (counts.tsv); a sixth identical store at 0x036016 in twin sub_3600E is not in the table (INFO)'),
    ('120', 174, 'fc 01 6a 8c aa d9'): (W, 0x035BD6, '"0x035BC6 … " (+16)'),
    ('120', 303, '6b 04 aa b2 0c 4d 6e 5d 36 56 3d 69 6b 05 aa b4 09 45 6b 85 aa b2'): (W, 0x002966, 'inside the TPU1 ISR 0x002950 the paragraph names'),
    ('120', 309, '79 04 09 89 6b 84 ff d8'): (W, 0x0351E2, '"0x0351D6 … " (+12)'),
    ('120', 333, 'ac 03 47 04'): (W, 0x034B72, '"0x034B6A … " (+8)'),
    ('120', 348, '6b 24 00 03 90 40 01 00 6b 84 aa be'): (W, 0x038D42, '"0x038D38 … " (+10)'),
    ('120', 357, '09 ed 09 65'): (W, 0x0029B6, 'inside the TPU1 ISR (0x00297C …)'),
    ('120', 417, 'cc 03 6a 8c fe c3'): (W, 0x03878A, '"0x03877A … " (+16)'),
    ('123', 90, 'fc 00'): (W, 0x03FB76, '"0x03FB70 … " (+6)'),
    ('123', 91, '79 2c 00 18 45 3c'): (W, 0x03FB78, 'next instruction of the same unpacker'),
    ('123', 149, '73 7b 46 68'): (W, 0x00FB52, '"0x00FB4A … " (+8)'),
    ('123', 150, '73 7b 46 4c'): (W, 0x00FB6E, '"0x00FB66 … " (+8)'),
    ('123', 150, '5e 00 fc 56'): (W, 0x00FB7E, '"0x00FB72 … " (+12)'),
    ('123', 183, 'fc ff 6a 8c aa e0 fc 0f 6a 8c aa d5'): (W, 0x0346E6, '"0x0346DE … " (+8)'),
    ('123', 207, '6a 18 89 20 71 70 5e 07 34 b0'): (W, 0x019D16, '"0x019D10 … " (+6)'),
    ('123', 234, '67 eb'): (W, 0x007E54, '"0x007E4E … " (+6)'),
    ('123', 235, '70 5b'): (W, 0x007E4C, 'the bset #5 the arrow points to, after the 0x007E32 run'),
    ('124', 314, 'bb 92'): (W, 0x0482CA, 'operand of the store `6a 8c bb 92` that starts at the cited 0x0482C8'),
    ('125', 147, '5e 01 52 06'): (W, 0x01827C, '"7a 01 00 <T> followed by 5e 01 52 06" at 0x018276 (+6)'),
    ('125', 234, '6d 62 6d 63 01 00 69 64'): ('PASS-ERRATUM-QUOTE', None, 'M13 quotes doc 100 as written; the image run M13 gives is graded in the strict pass'),
    ('125', 242, 'fb e2 44 2d 01 00'): ('UNADDRESSED-PRESENT', 0xFFEDD53E, 'M13 gives no address for the mov.l'),
    ('125', 246, 'f8 e4 03'): (W, 0xFFF392C9, '"… f8 e4 03" store at site FFF392C3 (+6)'),
    ('126', 16, 'f4 2a 68 e4 6e e4 00 01'): (W, 0x04B46A, 'the corrected address M14 gives on the next line'),
    ('126', 16, '68 e4'): (W, 0x04B46C, 'the first `*` store'),
    ('126', 104, '95 6d'): ('PASS-PATTERN', 0x02F624, '`6a 8X 95 6d`: all 11 listed sites match, each after `fc 02` (counts.tsv)'),
    ('126', 104, 'fc 02'): ('PASS-PATTERN', 0x02F620, 'as above'),
    ('126', 108, 'fb 09 … aa d3 ec 0f 46 0a'): (W, 0x011010, 'inside sub_10FA8: `fb 09` at 0x011010, `aa d3 ec 0f 46 0a` at 0x011014 (the n=9 select)'),
    ('126', 108, '6a 0c aa d4 ec 01 46 02 fb 01'): (W, 0x01101A, 'inside sub_10FA8 (the new n=9 path)'),
}
for k in [('120', 62, '3c a0'), ('120', 63, 'aa de'), ('120', 63, '81 1a'), ('120', 63, '81 1e'), ('120', 63, '8f 96'), ('120', 63, 'aa b4'),
          ('120', 63, 'aa ba'), ('120', 63, 'aa be'), ('120', 98, '3c a0'), ('120', 221, '6a 8c bb e1'), ('120', 401, 'aa de'),
          ('123', 65, '91 0a'), ('123', 65, '00 ff 91'), ('123', 65, 'aa d2'), ('123', 65, 'aa 30'), ('123', 65, '81 71'), ('123', 65, 'bb e3'),
          ('123', 66, '89 bb'), ('123', 66, '00 06 66 00'), ('123', 129, '91 0a'), ('123', 129, '91 0d'), ('123', 129, '00 ff 91 0a'),
          ('123', 168, '81 71'), ('123', 168, 'bb e3'), ('123', 272, 'aa d2'), ('124', 81, 'bb 92'), ('124', 81, 'ba 92'), ('124', 81, 'bb 70'),
          ('124', 81, '89 20'), ('125', 146, '5e 01 52 06'), ('127', 120, '60 40'), ('127', 360, '60 40')]:
    REV[k] = ('COUNT', None, 'search pattern of a count claim; graded in counts.tsv' if k[0] != '127' else 'size of I10 slivers (a table count, not an image location)')
for k in [('114', 100, '78 40 6a 2b'), ('124', 45, 'e6 01'), ('124', 238, 'e6 00'), ('124', 238, 'e5 00'), ('124', 304, 'e6 01'), ('124', 304, 'e6 00'),
          ('125', 314, 'f8 e4 03'), ('126', 143, '03 05 06 07 08 09 0a 18 1a 12 1d 0b 11 19 16 15 32 31 1f'), ('126', 178, '1c 03'),
          ('127', 90, 'fd 68'), ('127', 90, 'fd 73'), ('127', 90, '7f 0c'), ('127', 333, 'fb 16 e1')]:
    REV[k] = ('NOTATION', None, 'instruction form, frame type or value list; no image address')
REV[('RES', 90, 'a8 20')] = ('DUP', 0x076F04, 'graded in the strict pass (manual row at 0x076F04)')

rows = []
for l in open(os.path.join(OUT, 'citations_strict.tsv'), encoding='utf-8').read().splitlines()[1:]:
    c = l.split('\t'); rows.append(c[:9] + ['strict'])
unrev = []
for l in open(os.path.join(OUT, 'loose.tsv'), encoding='utf-8').read().splitlines()[1:]:
    doc, line, addr, run, v, img, note, text = l.split('\t')
    if v == 'LOOSE-PASS':
        n = len(hb(run.split('…')[0]))
        rows.append([doc, line, addr, run, at(int(addr, 16), n).hex(' '), 'PASS', img, 'loose', 'exact at an address on the line', 'loose']); continue
    key = (doc[:3], int(line), norm(run))
    if key not in REV: unrev.append(key); continue
    verdict, ra, why = REV[key]
    act = ''
    if ra is not None:
        seg = [s for s in run.split('…') if s.strip()]
        first = hb(seg[0]) if not run.strip().startswith('…') else None
        if first is not None and verdict in ('PASS-WITHIN', 'WRONG-ADDR', 'UNADDRESSED-PRESENT', 'PASS-PATTERN', 'DUP'):
            ok = at(ra, len(first)) == first
            act = at(ra, len(first)).hex(' ')
            if not ok: verdict, why = 'FAIL', why + ' | REVIEW MISMATCH at %X' % ra
    if verdict == 'WRONG-ADDR': act = at(int(addr, 16), len(hb(run.split('…')[0]))).hex(' '); why = 'run re-read at %X; ' % ra + why
    rows.append([doc, line, addr if (ra is None or verdict == 'WRONG-ADDR') else ('%X' % ra), run, act, verdict, img if img != '-' else ('SUB' if ra and ra >= SUBB else 'MAIN'), 'loose-reviewed', (note + '; ' if note else '') + why, 'loose'])
assert not unrev, unrev

# ---------------------------------------------------------------- counts and tables
C = []
def cnt(ref, claim, got, exp, note=''):
    C.append((ref, claim, str(got), str(exp), 'PASS' if got == exp else ('INFO' if exp is None else 'FAIL'), note))
cnt('120:98', '`3c a0` ADCSR byte writes, MAIN 0..0x07B753', len(hits('3c a0')), 10)
cnt('120:401', '`aa de` operand sites', len(hits('aa de')), 10)
cnt('120:401', 'abs16 byte stores to AADE (`6a 8X aa de`)', sum(len(hits(bytes([0x6a, k, 0xaa, 0xde]))) for k in range(0x80, 0x90)), 0)
cnt('120:221', '`6a 8c bb e1` stores ("79")', len(hits('6a 8c bb e1')), 79, 'image: 76 `6a 8c bb e1` + 1 `6a 8e bb e1` (0x%06X) = 77; no abs32 `6a a8 00 ff bb e1`' % hits('6a 8e bb e1')[0])
cnt('120:221', 'any abs16 byte store to BBE1 (`6a 8X bb e1`)', sum(len(hits(bytes([0x6a, k, 0xbb, 0xe1]))) for k in range(0x80, 0x90)), 79)
cnt('120:221', '`6a 8c bb e1` stores directly preceded by `fc a9` (mov.b #0xA9,r4l)', sum(1 for a in hits('6a 8c bb e1') if M[a - 2:a] == b'\xfc\xa9'), 0)
sites = [0x034D2C, 0x035A18, 0x035A62, 0x035A9A, 0x035B52]
cnt('120:155-163', 'listed AAD7=1 sites are `fc 01 6a 8c aa d7`', all(at(a, 6) == hb('fc 01 6a 8c aa d7') for a in sites), True)
cnt('120:155-163', 'all `fc 01 6a 8c aa d7` in MAIN', ['%06X' % a for a in hits('fc 01 6a 8c aa d7')], None,
    '0x036016 is in twin sub_3600E (proven; BE32 slot 0x035D24 = 0003600E) and is not in the table')
cnt('120:153', 'dispatcher clear `0x03455C fc 00 6a 8c aa d7`', at(0x03455C, 6) == hb('fc 00 6a 8c aa d7'), True)
cnt('123:129', '`91 0a` / `91 0d` / `00 ff 91 0a` in MAIN 0..0x80000', (len(hits('91 0a', hi=0x80000)), len(hits('91 0d', hi=0x80000)), len(hits('00 ff 91 0a', hi=0x80000))), (2, 0, 0))
cnt('123:168', '`81 71` / `bb e3` raw', (len(hits('81 71')), len(hits('bb e3'))), (6, 5))
cnt('123:272', '`aa d2` operand sites', len(hits('aa d2')), 32)
cnt('123:135, RESUME:130', '`00 06 66 00` sites', ['%06X' % a for a in hits('00 06 66 00')], ['014986', '0149A2'])
cnt('124:314', '`bb 92` in 0..0x80000', len(hits('bb 92', hi=0x80000)), 1)
cnt('124:314', 'store at 0x0482C8 / BA92.b4 set at 0x0482BE', (at(0x0482C8, 4).hex(' '), at(0x0482BE, 6).hex(' ')), ('6a 8c bb 92', '6a 18 ba 92 70 40'))
cnt('125:146', '`5e 01 52 06` sites', len(hits('5e 01 52 06')), 14)
st = sorted(set(a for k in range(0x80, 0x90) for a in hits(bytes([0x6a, k, 0x95, 0x6d]))))
cnt('126:104', '`6a 8X 95 6d` stores and their sites', ['%06X' % a for a in st], ['02F622', '03111E', '0341E4', '03421A', '03429A', '0342BE', '0342D2', '034316', '03433A', '034860', '039436'])
cnt('126:104', 'each preceded by `fc 02`', all(M[a - 2:a] == b'\xfc\x02' for a in st), True)
cnt('118:146', 'B9E4 stores of 3..7 at 029580/029558/0295FE/0294EE/029594', [at(a, 6).hex(' ') for a in (0x029580, 0x029558, 0x0295FE, 0x0294EE, 0x029594)],
    ['fc 0%d 6a 8c b9 e4' % n for n in range(3, 8)])
cnt('118:196', 'readers `78 e0 6b 26 00 00 0d xx` per base 0D32/0D72/0DB2/0DEA', [len(hits('78 e0 6b 26 00 00 %s' % b)) for b in ('0d 32', '0d 72', '0d b2', '0d ea')], [3, 3, 3, 3])
cnt('115:108', 'arms 03EF60/03EFA0/03EFE0: `40 0c | fc 07 40 08 | fc 03 40 04`', [at(a - 2, 10).hex(' ') for a in (0x03EF60, 0x03EFA0, 0x03EFE0)], ['40 0c fc 07 40 08 fc 03 40 04'] * 3)
cnt('117:216', 'loaders `7a 05 00 02 <tbl>` for 02D704/02D7FE/02E2D8/02E3D2', [len(hits('7a 05 00 02 ' + t)) for t in ('d7 04', 'd7 fe', 'e2 d8', 'e3 d2')], [1, 1, 1, 1])
cnt('RESUME:90', 'class-request compares `a8 20/21/22/23` from 0x076F04', [at(a, 2).hex(' ') for a in (0x076F04, 0x076F0A, 0x076F0E, 0x076F12)], ['a8 20', 'a8 21', 'a8 22', 'a8 23'])
cnt('RESUME:69', 'BCD dword 0x03D1C6 / low word 0x03D1C8', (at(0x03D1C6, 4).hex(' '), at(0x03D1C8, 2).hex(' ')), ('00 40 00 00', '00 00'))
cnt('RESUME:36, README:22', 'run `0c cb 58 70 00 28 …` start; seed head at 0x06ADE2 is 4 B', ['%06X' % a for a in hits('0c cb 58 70 00 28 eb 07 5e 06 ac d6 58 00 00 1e')], ['06ADE6'])
cnt('118:118-120', 'stale copy 0x069A7F first 37 B == 0x069964', M[0x069A7F:0x069A7F + 37] == M[0x069964:0x069964 + 37], True)
cnt('121:132', '`75 41 e5` sites near the cited pair', ['%08X' % (a + SUBB) for a in hits('75 41 e5', S, len(S)) if 0x339480 <= a <= 0x339520], ['FFF394CC', 'FFF39513'])
cnt('122:117, RESUME:186', 'mode-10 store `fc 0a 6a 8c a9 f9`', ['%06X' % a for a in hits('fc 0a 6a 8c a9 f9')], ['01D09E', '063C10'])
IO = os.path.join(ROOT, 'ida', 'out')
def tsvrows(p):
    L = [l.split('\t') for l in open(os.path.join(IO, p), encoding='utf-8').read().splitlines() if l and not l.startswith('#')]
    return L[0], L[1:]
tg1 = int.from_bytes(at(0x0351E4, 2), 'big'); tg0 = int.from_bytes(at(0x000478, 2), 'big'); tc = at(0x0350C3, 1)[0]
cnt('RESUME:102 M8', 'TPU1 TGRA1 (0x0351E2 `79 04 09 89`) -> 16e6/(N+1)', (at(0x0351E2, 4).hex(' '), round(16e6 / (tg1 + 1))), ('79 04 09 89', 6552))
cnt('RESUME:103 M8', 'TPU0 TGRA0 (0x000476 `79 04 0b a0`) -> 16e6/(N+1), /40', (at(0x000476, 4).hex(' '), round(16e6 / (tg0 + 1), 1), round(16e6 / (tg0 + 1) / 40, 2)), ('79 04 0b a0', 5374.5, 134.36))
cnt('RESUME:104 M8', 'T-CALL TCORA (0x0350C0 `79 04 00 47`) -> 250e3/(2(N+1))', (at(0x0350C0, 4).hex(' '), round(250e3 / (2 * (tc + 1)), 1)), ('79 04 00 47', 1736.1))
h, r = tsvrows(r'punr-lo\proposed-demotions.tsv'); cnt('RESUME M2', 'runs / bytes / data runs', (len(r), sum(int(x[2]) for x in r), sum(1 for x in r if 'retype' in x[3])), (29, 368, 1))
h, r = tsvrows(r'punr-mid\proposed-demotions.tsv'); r = [x for x in r if x[3] != 'ALL']
cnt('RESUME M3', 'runs / bytes / DEAD / SPLIT-TAIL / DATA', (len(r), sum(int(x[2]) for x in r), sum(1 for x in r if x[3] == 'DEAD'), sum(1 for x in r if x[3] == 'SPLIT-TAIL'), sum(1 for x in r if x[3] == 'DATA-MISTYPED')), (22, 574, 19, 2, 1))
h, r = tsvrows(r'punr-hi\proposed-demotions.tsv'); cnt('RESUME M4', 'dead arms below the window: runs / bytes', (len(r), sum(int(x[2]) for x in r)), (16, 530))
cnt('RESUME M4', 'window = doc 95 868 + M4 220', 868 + 220, 0x078546 - 0x078106)
h, r = tsvrows(r'dead-code-tier\proposed-typing.tsv'); cnt('RESUME M5', 'rows / bytes', (len(r), sum(int(x[2]) for x in r)), (136, 2880))
h, r = tsvrows(r'inferred-tables\proposed-typing.tsv')
tier = Counter(); [tier.update({x[5]: int(x[2])}) for x in r]
cnt('RESUME M6', 'C-read / C-extent / code / stale', (tier['C-read'], tier['C-extent'], tier['Proven-code'], tier['Stale-copy']), (310, 265, 54, 43))
h, r = tsvrows(r'inferred-tables\pieces.tsv')
inf = [x for x in r if x[5] == 'Inferred']
cnt('RESUME M6', 'Inferred bytes / in 0x03624B-0x0377C1', (sum(int(x[2]) for x in inf), sum(int(x[2]) for x in inf if 0x03624B <= int(x[0], 16) < 0x0377C2)), (425, 382))
h, r = tsvrows(r'sub-residue-final\runs.tsv'); cnt('RESUME M15', 'residue runs / bytes', (len(r), sum(int(x[2]) for x in r)), (59, 3736))
h, r = tsvrows(r'bluetooth\commands.tsv'); cmds = sorted(set(x[0][:4] for x in r if x[1] == 'command'))
cnt('RESUME M12', 'M12 commands (distinct names, kind=command)', len(cmds), 5, ' '.join(cmds))
h, r = tsvrows(r'bluetooth\indications.tsv'); ind = sorted(set(x[0][:4] for x in r if re.match(r'[A-Z]{4}', x[0])) - set(cmds))
cnt('RESUME M12', 'M12 indications (distinct names, less echoes of own commands)', ind, sorted(['HELL', 'PAIR', 'FIND', 'ERAT', 'RXAT', 'SCOI', 'ERRO']), ' '.join(ind))
L = [l for l in open(os.path.join(IO, r'touch-key-leftovers\zones-final.tsv'), encoding='utf-8').read().splitlines() if l and not l.startswith('#')]
cnt('RESUME M10', 'zones in zones-final.tsv', len(L) - 1, 511)
with open(os.path.join(OUT, 'counts.tsv'), 'w', encoding='utf-8', newline='\n') as f:
    f.write('ref\tclaim\tgot\texpected\tresult\tnote\n')
    for c in C: f.write('\t'.join(x.replace('\t', ' ') for x in c) + '\n')

# ---------------------------------------------------------------- outputs
with open(os.path.join(OUT, 'citations.tsv'), 'w', encoding='utf-8', newline='\n') as f:
    f.write('doc\tline\taddress\tbytes_cited\tbytes_actual\tverdict\timage\tsource\tnote\tpass\n')
    for r in rows: f.write('\t'.join(str(x).replace('\t', ' ') for x in r) + '\n')
GRADED_PASS = {'PASS', 'PASS-WITHIN', 'PASS-ERRATUM-QUOTE', 'PASS-PATTERN', 'PASS-SUBFILE', 'PASS-ENCODING'}
NOT_GRADED = {'DROPPED', 'COUNT', 'NOTATION', 'DUP', 'UNADDRESSED-PRESENT'}
per = defaultdict(Counter)
for r in rows: per[r[0]][r[5]] += 1
with open(os.path.join(OUT, 'summary.tsv'), 'w', encoding='utf-8', newline='\n') as f:
    f.write('doc\tgraded\tpass\twrong_addr\tfail\tnot_graded\tdetail\n')
    tot = Counter()
    for d in sorted(per, key=lambda d: (not d[0].isdigit(), d)):
        c = per[d]; g = sum(v for k, v in c.items() if k not in NOT_GRADED)
        p = sum(v for k, v in c.items() if k in GRADED_PASS); w = c['WRONG-ADDR']; fl = c['FAIL']; ng = sum(v for k, v in c.items() if k in NOT_GRADED)
        tot.update(dict(g=g, p=p, w=w, f=fl, n=ng)); f.write('%s\t%d\t%d\t%d\t%d\t%d\t%s\n' % (d, g, p, w, fl, ng, dict(c)))
    f.write('TOTAL\t%d\t%d\t%d\t%d\t%d\t\n' % (tot['g'], tot['p'], tot['w'], tot['f'], tot['n']))
print('citations', Counter(r[5] for r in rows))
print('graded %d pass %d wrong %d fail %d not graded %d' % (tot['g'], tot['p'], tot['w'], tot['f'], tot['n']))
print('counts', Counter(c[4] for c in C)); [print(c) for c in C if c[4] != 'PASS']
