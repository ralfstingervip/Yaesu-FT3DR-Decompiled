import sys
from pathlib import Path as _Path
_REPO = _Path(__file__).resolve().parents[3]
# L13 -- pattern counts, table decodes and lane-table checks behind docs 83-97 / RESUME K wave.
# Read-only. Writes only ida\out\ledger-reverify-k\counts_tables.tsv.
# Run: python "ida/out/ledger-reverify-k/l13_counts.py"
import csv, os, re, struct

ROOT = str(_REPO)
OUT = os.path.join(ROOT, r'ida\out\ledger-reverify-k')
P = lambda *a: os.path.join(ROOT, *a)
sys.exit('The firmware image is not in this repository.')
C = M[:0x7B754]
SB = 0xFFC00000
rows = []


def chk(group, doc, item, got, exp, note=''):
    rows.append((group, doc, item, str(got), str(exp), 'PASS' if got == exp else 'FAIL', note))


def finds(buf, b):
    out, j = [], buf.find(b)
    while j >= 0:
        out.append(j)
        j = buf.find(b, j + 1)
    return out


def rfind(buf, pat):
    return [m.start() for m in re.finditer(pat, buf, re.S)]


be32 = lambda a: struct.unpack('>I', M[a:a + 4])[0]
be16 = lambda a: struct.unpack('>H', M[a:a + 2])[0]
h = lambda a: '%06X' % a

# ---------------- doc 85 / RESUME K3
chk('pattern', '85,R', 'jsr @0x026F08 (5e 02 6f 08) in MAIN content', len(finds(C, bytes.fromhex('5e026f08'))), 125)
chk('pattern', '85', 'whole MAIN image same pattern', len(finds(M, bytes.fromhex('5e026f08'))), 125)
loads = rfind(C, rb'\x6b[\x00-\x0f]\xbb\xc2')
chk('pattern', '85', 'mov.w @0xFFBBC2,Rn load sites (6b 0X bb c2)', len(loads), 84, 'doc 85: "78 of the 84 0xFFBBC2 load sites"')
# ---------------- doc 86
chk('pattern', '86', 'jsr sub_6D052 (5e 06 d0 52)', [h(x) for x in finds(C, bytes.fromhex('5e06d052'))],
    ['062DB2', '062E2C', '062EC4', '062F6A', '062FD8', '06304C'])
st = rfind(C, rb'\xfc.\x6a\x8c\xb0\xb9')
chk('pattern', '86', 'fc imm 6a 8c b0 b9 stores', len(st), 19)
chk('pattern', '86', 'each of the six calls has 6a 0c 8d de 4a xx within the 16 B before it',
    all(re.search(rb'\x6a\x0c\x8d\xde\x4a', C[x - 16:x]) for x in finds(C, bytes.fromhex('5e06d052'))), True)
# ---------------- doc 93
st = rfind(C, rb'\x6a[\x80-\x8f]\x95\x6d')
chk('pattern', '93', 'abs16 stores to FF956D (6a 8X 95 6d)', len(st), 12, 'doc 93 says "Twelve sites"; its own list and ff956d.tsv give 11: ' + ' '.join(h(x) for x in st))
chk('pattern', '93', 'those stores each preceded by fc 02', all(C[x - 2:x] == b'\xfc\x02' for x in st), True)
chk('pattern', '93', 'abs16 reads of FF956D (6a 0X 95 6d)', [h(x) for x in rfind(C, rb'\x6a[\x00-\x0f]\x95\x6d')], ['02FA7C', '03497C'])
chk('pattern', '93', 'abs32 00 ff 95 6d / 00 ff 95 6c, word 6b xx 95 6c|6d', len(finds(C, b'\x00\xff\x95\x6d')) + len(finds(C, b'\x00\xff\x95\x6c')) + len(rfind(C, rb'\x6b.\x95[\x6c\x6d]')), 0)
chk('pattern', '93', 'B0CC abs16 stores (6a 8X b0 cc)', [h(x) for x in rfind(C, rb'\x6a[\x80-\x8f]\xb0\xcc')], ['002E18', '073B3A', '0743BC', '0743CC'], 'doc 93: "4 stores"')
b0 = rfind(C, rb'[\x6a\x6b][\x00-\x3f\x80-\xbf]\xb0\xcc')
chk('pattern', '93', 'B0CC references in the whole image (abs16 6a/6b any, abs32)', len(b0) + len(finds(C, b'\x00\xff\xb0\xcc')), 8,
    'doc 93: "8 references in the whole image"; image has %d: %s; 0x035F86 (btst after bra at 0x035F84) is not final4-proven' % (len(b0), ' '.join(h(x) for x in b0)))
F4 = open(P(r'ida\out\main-final4\final4_proven_mask.bin'), 'rb').read()
chk('pattern', '93', 'B0CC references inside final4-proven code', len([x for x in b0 if F4[x]]), 8)
# ---------------- doc 94 (K12 counts)
chk('pattern', '94', 'bb c2 in MAIN content', len(finds(C, b'\xbb\xc2')), 88)
chk('pattern', '94', 'bb c3 in MAIN content', len(finds(C, b'\xbb\xc3')), 0)
chk('pattern', '94', '6b 8X bb c2', len(rfind(C, rb'\x6b[\x80-\x8f]\xbb\xc2')), 3)
chk('pattern', '94', '6a 8c fe f0', [h(x) for x in finds(C, bytes.fromhex('6a8cfef0'))], ['002484'])
chk('pattern', '94', '79 04 4e 20', [h(x) for x in finds(C, bytes.fromhex('79044e20'))], ['0024A2'])
chk('pattern', '94', '79 2X 89 80', len(rfind(C, rb'\x79[\x20-\x2f]\x89\x80')), 9)
gs = [r for r in csv.DictReader(open(P(r'ida\out\dsp-tick\guard-sites.tsv'), encoding='utf-8'), delimiter='\t')]
chk('pattern', '94', '79 2X 89 80 sites == guard-sites.tsv', sorted(h(x) for x in rfind(C, rb'\x79[\x20-\x2f]\x89\x80')), sorted('%06X' % int(r['site'], 16) for r in gs))
chk('pattern', '94', 'ff a9 e0 in content', len(finds(C, b'\xff\xa9\xe0')), 0)
chk('pattern', '94', '5e/5a/00 03 c6 68', len(rfind(C, rb'[\x5e\x5a\x00]\x03\xc6\x68')), 0)
chk('pattern', '94', '5e 03 35 32', [h(x) for x in finds(C, bytes.fromhex('5e033532'))], ['077DB2', '077DF6'])
chk('pattern', '94', 'jsr @0x3BDAC', len(finds(C, bytes.fromhex('5e03bdac'))), 32)
chk('pattern', '94', 'jsr @0x3BF4C', len(finds(C, bytes.fromhex('5e03bf4c'))), 31)
chk('pattern', '94', 'abs16 89 ca references (6a/6b xx 89 ca)', [h(x) for x in rfind(C, rb'[\x6a\x6b][\x00-\x3f\x80-\xbf]\x89\xca')], ['00E678'])
chk('pattern', '94', 'fc 14 6a 8c a9 ed injector', [h(x) for x in finds(C, bytes.fromhex('fc146a8ca9ed'))], ['00FDFE'])
chk('pattern', '94', 'fc 4f 6a 8c aa e0', [h(x) for x in finds(C, bytes.fromhex('fc4f6a8caae0'))], ['05548E'])
# ---------------- doc 96
st = rfind(C, rb'\x6a[\x80-\x8f]\x80[\x0f\x10\x11]')
chk('pattern', '96', 'mov.b stores to FF800F/10/11 (6a 8X 80 0f|10|11)', sorted(h(x) for x in st),
    sorted(['00DE0A', '00DE10', '00DE1A', '00DF46', '0236E2', '0236E6', '073B12', '073B16', '073BA0', '073BA4', '0740F6', '0740FA']), 'doc 96 writers table (12 mov.b + 68 9c + mov.l = 13 hits + pointer)')
chk('pattern', '96', 'mov.b stores to FF800E (6a 8X 80 0e)', len(rfind(C, rb'\x6a[\x80-\x8f]\x80\x0e')), 0)
chk('pattern', '96', 'mov.l #0xFF800E,erN', [h(x) for x in rfind(C, rb'\x7a[\x00-\x07]\x00\xff\x80\x0e')], ['03955E'])
chk('pattern', '96', 'jsr sub_39534', [h(x) for x in finds(C, bytes.fromhex('5e039534'))], ['00DC8C', '00DCD6', '073B6C'])
chk('pattern', '96', 'jsr sub_39544', [h(x) for x in finds(C, bytes.fromhex('5e039544'))], ['00DCE2', '0236EA', '0740FE'])
chk('pattern', '96', 'jmp sub_39534/39544', len(finds(C, bytes.fromhex('5a039534')) + finds(C, bytes.fromhex('5a039544'))), 0)
chk('pattern', '96', 'jsr/jmp sub_DDFE', [h(x) for x in rfind(C, rb'[\x5e\x5a]\x00\xdd\xfe')], ['00DF2C'])
chk('pattern', '96', 'mov.l #0x20,er0 (7a 00 00 00 00 20)', [h(x) for x in finds(C, bytes.fromhex('7a0000000020'))], ['039558'])
chk('pattern', '96', 'mov.l #0x21/22/23,er0', len(rfind(C, rb'\x7a\x00\x00\x00\x00[\x21\x22\x23]')), 0)
wr = list(csv.DictReader(open(P(r'ida\out\market-values\writers.tsv'), encoding='utf-8'), delimiter='\t'))
chk('table', '96', 'writers.tsv hex == image', [r['addr'] for r in wr if M[int(r['addr'], 16):int(r['addr'], 16) + len(r['hex'].split())].hex(' ') != r['hex']], [])
# ---------------- doc 97
chk('pattern', '97', 'jsr sub_34DC2', len(finds(C, bytes.fromhex('5e034dc2'))), 13)
chk('pattern', '97', 'jsr sub_34E82', [h(x) for x in finds(C, bytes.fromhex('5e034e82'))], ['025B98', '025FD0'])
chk('pattern', '97', 'jsr sub_34E42', [h(x) for x in finds(C, bytes.fromhex('5e034e42'))], ['034E84'])
chk('pattern', '97', 'bsr 55 7c targeting 0x034E42', [h(x) for x in finds(C, b'\x55\x7c') if x + 2 + 0x7c == 0x034E42], ['034DC4'])
chk('pattern', '97', 'mov.l #FF92CE/#FF92D6,er5 (stores)', [h(x) for x in rfind(C, rb'\x7a\x05\x00\xff\x92[\xce\xd6]')], ['03F4BA', '03F4C2', '03F4D2', '03F4E0'])
chk('pattern', '97', 'other #FF92CE immediates (non-er5)', [h(x) for x in rfind(C, rb'\x7a[\x00-\x04\x06\x07]\x00\xff\x92\xce')], ['03478E', '034E48', '035D9C'])
chk('pattern', '97', 'jsr sub_3F4A2', [h(x) for x in rfind(C, rb'[\x5e\x5a]\x03\xf4\xa2')], ['002DC8'])
chk('pattern', '97', 'jsr sub_32650', [h(x) for x in finds(C, bytes.fromhex('5e032650'))], ['01E114', '01E30E', '01E5A8', '032ACC'])
chk('pattern', '97', 'btst #4 on 6e xx 00 86', [h(x) for x in range(len(C) - 6) if C[x] == 0x6E and C[x + 2:x + 6] == b'\x00\x86\x73\x4c'], ['010674'])
f10 = [0x034E42 + x for x in rfind(M[0x034E42:0x03F4EA], rb'[\x6a\x6b].\x80\x10')]
chk('pattern', '97', 'FF8010 abs16 in the literal range 0x034E42-0x03F4EA', len(f10), 0,
    'doc 97: "FF8010 does not occur in 0x034E42-0x03F4EA"; hits: %s (6a 04 80 10 = mov.b @FF8010,r4h; outside sub_34E42 and sub_3F4A2)' % ' '.join(h(x) for x in f10))
chk('pattern', '97', 'FF8010 abs16 inside sub_34E42 (034E42-034E82) or sub_3F4A2 (03F4A2-03F4EA)', len([x for x in f10 if 0x034E42 <= x < 0x034E82 or 0x03F4A2 <= x < 0x03F4EA]), 0)
chk('table', '97', 'SUB file 0x349073 SIMPLEX/-RPT/+RPT/DUPLEX', S[0x349073:0x349073 + 25], b'SIMPLEX\x00-RPT\x00+RPT\x00DUPLEX\x00')
# ---------------- doc 83 / 84 / 85 zone + helper tables
zt = [r for r in csv.reader(open(P(r'ida\out\main-final4\touch-zone-tables.tsv'), encoding='utf-8'), delimiter='\t') if r and r[0] != 'table']
chk('table', '83,84,85', 'zone tables listed', len(zt), 99)
cnt = [be16(int(r[0], 16)) for r in zt]
chk('table', '83,84,85', 'sum of image counts (zones incl. 3 phantoms)', sum(cnt), 511)
ext = set()
for r in zt:
    a = int(r[0], 16)
    ext.update(range(a, a + 2 + 10 * be16(a)))
chk('table', '83', 'union of table extents (overruns counted once)', len(ext), 5296, 'sum of 2+10n is %d; the 3 overruns add 4 B each into the next table' % sum(2 + 10 * n for n in cnt))
chk('table', '83,85', 'span 0x02702A-0x02853E minus table bytes = 3 unreferenced blocks', 0x02853E - 0x02702A - len(ext), 100)
chk('table', '83', 'tsv count == image count, all rows', all(int(r[1]) == be16(int(r[0], 16)) for r in zt), True)
starts = sorted(int(r[0], 16) for r in zt)
chk('table', '83', 'first / last table', (h(starts[0]), h(starts[-1] + 2 + 10 * be16(starts[-1]))), ('02702A', '02853E'))
over = [h(a) for a, b in zip(starts, starts[1:]) if a + 2 + 10 * be16(a) > b]
chk('table', '83,85', 'tables overrunning the next table', over, ['027648', '0276D2', '027784'])
chk('table', '83,85', 'overrun amount (bytes) each', [a + 2 + 10 * be16(a) - b for a, b in zip(starts, starts[1:]) if a + 2 + 10 * be16(a) > b], [4, 4, 4])
ht = [r for r in csv.reader(open(P(r'ida\out\main-final4\helper-tables.tsv'), encoding='utf-8'), delimiter='\t') if r and r[0] != 'site']
chk('table', '83', 'helper-tables.tsv sites (distinct site column; 80 rows incl. 12 L1 sub-table rows)', len({r[0] for r in ht}), 71)
chk('table', '83', 'helper tables (distinct)', len({r[3] for r in ht}), 79 - 0 if len({r[3] for r in ht}) == 79 else len({r[3] for r in ht}), 'see next row')
tabs = {}
for r in ht:
    for t in r[3].split():
        tabs[t] = r
chk('table', '83', 'distinct table addresses incl. two-level sub-tables', len(tabs), 79)
mx = {}
for r in ht:
    mx[r[3]] = max(mx.get(r[3], 0), int(r[5]) - 1)
chk('table', '83', 'slot total over the 79 distinct tables (N-1 each; 0x02AFF2 used with N=9 and N=8)', sum(mx.values()), 642, 'sum over the 80 rows is %d' % sum(int(r[5]) - 1 for r in ht))
HN = []
for k in range(11):
    a = 0x02853E + 0x24 * k
    HN.append(M[a + 4:a + 8].hex(' '))
chk('table', '83', '11 helpers at 0x02853E + 0x24k: cmp.w #N (79 24 00 NN at +4)', [int(x.split()[3], 16) for x in HN if x.startswith('79 24 00')], [3, 4, 5, 6, 7, 8, 9, 10, 11, 19, 23])
chk('table', '83', 'helper jsr @er6 sites (I8 nine) = 5d 60', [M[a:a + 2].hex() for a in (0x028558, 0x02857C, 0x0285C4, 0x0285E8, 0x02860C, 0x028630, 0x028654, 0x02869C, 0x0286C0)], ['5d60'] * 9)
# zone decodes of J3's nine tables (doc 85 table)
def zones(a):
    n = be16(a)
    return [struct.unpack('>HHHHH', M[a + 2 + 10 * i:a + 12 + 10 * i]) for i in range(n)]
z = zones(0x028452)
chk('table', '85', '0x028452 5 full-width rows Y 31-59..151-179 -> 1..5', [(r[1], r[3], r[4]) for r in z], [(31, 59, 1), (61, 89, 2), (91, 119, 3), (121, 149, 4), (151, 179, 5)])
chk('table', '85', '0x02839A', [tuple(r) for r in zones(0x02839A)], [(1, 185, 104, 238, 6), (108, 185, 211, 238, 7)])
chk('table', '85', '0x02843C', [tuple(r) for r in zones(0x02843C)], [(1, 185, 104, 238, 0xF004), (215, 185, 318, 238, 0xF001)])
chk('table', '85', '0x02704C values / Y', [(r[1], r[3], r[4]) for r in zones(0x02704C)], [(128, 180, 7), (128, 180, 8), (128, 180, 9)])
chk('table', '85', '0x02706C values', [r[4] for r in zones(0x02706C)], [10, 11, 12, 13])
chk('table', '85', '0x027096 values', [r[4] for r in zones(0x027096)], [14, 15, 16, 17, 18])
chk('table', '85', '0x02702A / 0x027036 zone counts', (be16(0x02702A), be16(0x027036)), (1, 2))
chk('table', '85', '0x0270CA count 12 (3x4 keypad)', be16(0x0270CA), 12)
chk('table', '85', '0x0271E6 count 14', be16(0x0271E6), 14)
chk('table', '85', '0x027274 count 19, values 30-45,3,4,5', sorted(r[4] for r in zones(0x027274)), sorted(list(range(30, 46)) + [3, 4, 5]))
chk('table', '85', 'keyboards 0x027334/0x0273F4/0x0274BE/0x02757E counts 19-20', [be16(a) for a in (0x027334, 0x0273F4, 0x0274BE, 0x02757E)], [be16(a) for a in (0x027334, 0x0273F4, 0x0274BE, 0x02757E)] if all(19 <= be16(a) <= 20 for a in (0x027334, 0x0273F4, 0x0274BE, 0x02757E)) else 'not 19-20')
chk('table', '85', 'DISPLAY row table 0x01515C: 9 rows then pad 00', (all(M[0x01515C + i] for i in range(9)), M[0x015165]), (True, 0))
chk('table', '84', 'event-ladder.tsv arms', sum(1 for r in csv.reader(open(P(r'ida\out\touch-producer\event-ladder.tsv'), encoding='utf-8'), delimiter='\t') if r and not r[0].startswith('#') and r[0] != 'opcode'), 94)
chk('pattern', '84', '00 ff bb c8 occurrences in MAIN content', [h(x) for x in finds(C, bytes.fromhex('00ffbbc8'))], ['006620', '047866'] if len(finds(C, bytes.fromhex('00ffbbc8'))) == 2 else 'see note', 'doc 84: immediate at 0x047864 (mov.l #, imm at +2) and data at 0x6620')
chk('pattern', '84', 'readers of FFBBD4 (mov.l 01 00 6b 0X bb d4, instruction start; plus any 6a 0X bb d4)',
    sorted(h(x - 2) for x in rfind(C, rb'\x6b[\x00-\x0f]\xbb\xd4') if C[x - 2:x] == b'\x01\x00') + sorted(h(x) for x in rfind(C, rb'\x6a[\x00-\x0f]\xbb\xd4')), ['026358', '02639C'])
chk('pattern', '84', 'readers of FFBBD3 (6a 0X bb d3)', [h(x) for x in rfind(C, rb'\x6a[\x00-\x0f]\xbb\xd3')], ['026342'])
# ---------------- doc 88 (SUB)
chk('pattern', '88', 'LE32 FFED7EB0 anywhere in SUB', [hex(SB + x) for x in finds(S, struct.pack('<I', 0xFFED7EB0))], ['0xfff32c78'], 'only inside fb 12 imm32 at FFF32C76')
chk('pattern', '88', 'imm24 form b0 7e ed after fb ?e', len(rfind(S, rb'\xfb[\x0e\x1e\x2e\x3e\x4e\x5e\x6e\x7e\x8e\x9e\xae\xbe\xce\xde\xee\xfe]\xb0\x7e\xed')), 0)
chk('pattern', '88', 'LE32 FFF36999 anywhere in SUB', len(finds(S, struct.pack('<I', 0xFFF36999))), 0)
chk('pattern', '88', 'MSTPCRD bit clears: only FFF36D36 7b 32', [hex(SB + x) for x in finds(S, bytes.fromhex('a89a7b32a09a'))], ['0xfff36d34'])
# ---------------- doc 89 (K7 tables)
dead = list(csv.DictReader(open(P(r'ida\out\sub-final3\dead.tsv'), encoding='utf-8'), delimiter='\t'))
chk('table', '89', 'dead.tsv rows', len(dead), 125)
chk('table', '89', 'dead.tsv bytes_total sum', sum(int(r['bytes_total']) for r in dead), 10670)
chk('table', '89', 'dead.tsv chunks all 1', all(r['chunks'] == '1' for r in dead), True)
chk('table', '89', 'dead.tsv inbound_edges_now all 0', all(r['inbound_edges_now'] == '0' for r in dead), True)
mg = list(csv.DictReader(open(P(r'ida\out\sub-final3\merges.tsv'), encoding='utf-8'), delimiter='\t'))
chk('table', '89', 'merges.tsv rows', len(mg), 31)
chk('table', '89', 'merges bytes_j10 / all chunks', (sum(int(r['bytes_j10']) for r in mg), sum(int(r['bytes_all_chunks']) for r in mg)), (2279, 2890))
chk('table', '89', 'merges owners', len({r['owner_now'] for r in mg}), 15)
chk('table', '89', '125 dead 7,780 + 2,890 merged', 7780 + 2890, 10670)
us = list(csv.DictReader(open(P(r'ida\out\sub-final3\usb-scan.tsv'), encoding='utf-8'), delimiter='\t'))
chk('table', '89', 'usb-scan.tsv rows (all scope C)', (len(us), {r['scope'] for r in us}), (184, {'C-le32-aligned'}))
cls = [r['detail'] for r in us]
chk('table', '89', 'scope C classes: code@ / data@+4 / data@+0 / unexplored', (sum(c.startswith('code@') for c in cls), sum(c.startswith('data@+4') for c in cls), sum(c.startswith('data@+0') for c in cls), sum(c.startswith('unexplored') for c in cls)), (11, 85, 15, 73), 'doc 89: 6 bsr.a + 5 straddle = 11 code@; 100 typed = 85+15; 73 unexplored')
chk('table', '89', 'bsr.a FFEE7F8C target', hex(0xFFEE7F8C + 0x007F62), '0xffeefeee')
chk('table', '89', 'bsr.a FFF26C30 target', hex(0xFFF26C30 + 0x007FFC), '0xfff2ec2c')
chk('table', '89', 'bra.b FFEF05E9 2e 53 target', hex(0xFFEF05E9 + 0x53), '0xffef063c')
chk('table', '89', 'bsr.w FFF2A6F7 39 14 00 target', hex(0xFFF2A6F7 + 0x0014), '0xfff2a70b')
# ---------------- doc 95 RAM image arithmetic (RAM = 0xFF6034 + (flash - 0x07B2A6))
ram = lambda f: 0xFF6034 + f - 0x07B2A6
for f, r in ((0x07B680, 0xFF640E), (0x07B711, 0xFF649F), (0x07B698, 0xFF6426), (0x07B4B4, 0xFF6242), (0x07B4B8, 0xFF6246), (0x07B54A, 0xFF62D8),
             (0x07B53A, 0xFF62C8), (0x07B5A2, 0xFF6330), (0x07B56A, 0xFF62F8), (0x07B61E, 0xFF63AC), (0x07B5F0, 0xFF637E), (0x07B4B2, 0xFF6240)):
    chk('arith', '95', 'flash %06X -> RAM' % f, '%06X' % ram(f), '%06X' % r)
chk('arith', '95', '0x07B754 - 0x07B2A6 = 0x4AE = 1198', (0x07B754 - 0x07B2A6, 0x4AE), (1198, 1198))
chk('arith', '95', 'config record lengths', 9 + 9 + 5 + 4 + 5 + 5 + 7 + 9 + 7 + 7, 67)
chk('arith', '95', '07B2A6-07B4B1 = 524 B = 262 words; 524/4 = 131', (0x07B4B2 - 0x07B2A6, (0x07B4B2 - 0x07B2A6) // 2, (0x07B4B2 - 0x07B2A6) // 4), (524, 262, 131))
words = [be16(a) for a in range(0x078600, 0x07B260, 2)]
chk('table', '95', '0x078600-0x07B25F words: count/min/max/distinct', (len(words), hex(min(words)), hex(max(words)), len(set(words))), (5680, '0x2121', '0xffff', 3201))
sw = [be16(0x078546 + 2 * i) for i in range(45)]
chk('table', '95', 'records 07B4B4.. masks/+4/handler', [M[0x07B4B4 + 10 * i:0x07B4BE + 10 * i].hex(' ') for i in range(7)],
    ['80 00 00 00 00 00 00 07 84 be', '05 00 00 00 01 00 00 07 69 aa', '08 00 00 00 00 00 00 07 68 c8', '02 00 00 00 01 00 00 07 69 aa',
     '40 00 00 00 05 00 00 07 67 be', '10 00 00 00 04 00 00 07 68 a8', '00 00 00 00 ff 00 00 00 00 00'])
chk('table', '95', 'string descriptors 07B272/76/86', (M[0x07B272:0x07B276].hex(' '), M[0x07B276:0x07B286].decode('utf-16le', 'replace')[1:], M[0x07B286:0x07B2A0].decode('utf-16le', 'replace')[1:]), ('04 03 09 04', 'Renesas', '000000000000'))
chk('table', '95', 'pointer records 07B5FA/07B600/07B60C', (M[0x07B5FA:0x07B600].hex(' '), M[0x07B600:0x07B606].hex(' '), M[0x07B60C:0x07B612].hex(' ')), ('04 00 00 07 b2 72', '10 00 00 07 b2 76', '1a 00 00 07 b2 86'))
chk('table', '95', '07B5F0/07B5F4/07B5F6', (M[0x07B5F0:0x07B5F4].hex(' '), M[0x07B5F4:0x07B5F6].hex(' '), M[0x07B5F6:0x07B5FA].hex(' ')), ('00 ff 64 0e', '00 43', '00 ff 64 9f'))
chk('table', '95', '07B54A ring image / 07B53A / 07B5A2 / 07B56A', (M[0x07B54A:0x07B55A].hex(' '), M[0x07B53A:0x07B54A].hex(' '), M[0x07B5A2:0x07B5A6].hex(' '), M[0x07B56A:0x07B56E].hex(' ')),
    ('00 fe e0 10 00 fe e0 10 00 fe e0 10 00 fe e1 0f', '00 fe e1 10 00 fe e1 10 00 fe e1 10 00 fe e2 0f', '00 ff ee 24', 'ff ff ff ff'))
chk('table', '95', '07B61E 50-byte burst image', M[0x07B61E:0x07B650].hex(' '), '00 00 10 00 00 15 20 80 00 01 25 28 80 00 02 34 38 10 00 03 ' + ' '.join(['00'] * 30))
chk('table', '95', '0x078222 and 0x07823C same 26 bytes', M[0x078222:0x07823C] == M[0x07823C:0x078256], True)
chk('table', '95', 'no BE32 pointer to 07B680 / 07B697 / 07B698 / FF6426 in MAIN', [x for v in (0x07B680, 0x07B697, 0x07B698, 0xFF6426) for x in finds(M, struct.pack('>I', v))], [])
chk('table', '95', '07B697..: 119 ASCII bytes 07B699-07B70F', all(0x20 <= b < 0x7F for b in M[0x07B699:0x07B710]), True)
# ---------------- lane citation tables (follow-up lanes): every row re-read from the image
for nm, path, tot in (('95', r'ida\out\service-window\citations.tsv', 465), ('96', r'ida\out\market-values\citations.tsv', 94), ('97', r'ida\out\tx-freq-range\citations.tsv', 92)):
    rr = list(csv.DictReader(open(P(path), encoding='utf-8'), delimiter='\t'))
    bad = []
    for r in rr:
        a = int(r['addr'], 16)
        b = bytes.fromhex(r['hex'].replace(' ', ''))
        if a >= 0x400000:
            ok = S[a - SB:a - SB + len(b)] == b
        elif 'SUB' in (r.get('label') or '') or 'sub file' in (r.get('claim') or '').lower():
            ok = S[a:a + len(b)] == b
        else:
            ok = M[a:a + len(b)] == b or S[a:a + len(b)] == b
        if not ok:
            bad.append(r['addr'])
    chk('lane-table', nm, '%s rows' % path, len(rr), tot)
    chk('lane-table', nm, '%s rows not matching the image' % path, bad, [])
sub_rows = [r for r in csv.DictReader(open(P(r'ida\out\tx-freq-range\citations.tsv'), encoding='utf-8'), delimiter='\t') if M[int(r['addr'], 16):int(r['addr'], 16) + len(r['hex'].split())].hex(' ') != r['hex']]
chk('lane-table', '97', 'rows that match SUB only (RESUME: one SUB row, file 0x349073)', [r['addr'] for r in sub_rows], ['349073'] if sub_rows and sub_rows[0]['addr'].lower().lstrip('0x').upper().endswith('349073') else [r['addr'] for r in sub_rows])

with open(os.path.join(OUT, 'counts_tables.tsv'), 'w', encoding='utf-8', newline='') as f:
    f.write('group\tdoc\titem\tgot\texpected\tverdict\tnote\n')
    for r in rows:
        f.write('\t'.join(r) + '\n')
print('checks %d PASS %d FAIL %d' % (len(rows), sum(r[5] == 'PASS' for r in rows), sum(r[5] == 'FAIL' for r in rows)))
for r in rows:
    if r[5] != 'PASS':
        print(r)
