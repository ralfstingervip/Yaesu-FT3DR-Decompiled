import sys
from pathlib import Path as _Path
_REPO = _Path(__file__).resolve().parents[3]
# M13 group C: count / pattern / table / arithmetic claims of docs 109-112, re-derived from the images.
# Read-only. Plain Python, no IDA. MAIN offset = address; SUB file = address - 0xFFC00000 (RX little-endian).
# Writes counts_c.tsv to $OUTDIR (default: this directory).
import os, re, csv, struct, sys
sys.dont_write_bytecode = True
ROOT = str(_REPO)
HERE = os.path.join(ROOT, r'ida\out\ledger-reverify-l')
OUT = os.environ.get('OUTDIR', HERE)
P = lambda *a: os.path.join(ROOT, *a)
sys.exit('The firmware image is not in this repository.')
SB = 0xFFC00000
HI = 0x7B754
C = M[:HI]
F4P = open(P(r'ida\out\main-final4\final4_proven_mask.bin'), 'rb').read()
F4N = open(P(r'ida\out\main-final4\final4_named_mask.bin'), 'rb').read()
D109, D110, D111, D112 = '109-sub-frames-sub.md', '110-ledger-reverify-k.md', '111-errata-j.md', '112-c-reconstruction.md'
LINES = {d: open(P('docs', 'deep', d), encoding='utf-8').read().split('\n') for d in (D109, D110, D111, D112)}
rows = []


def line_of(doc, anchor):
    return next((i + 1 for i, L in enumerate(LINES[doc]) if anchor in L), 'ANCHOR?')


def chk(doc, anchor, claim, derived, expected, note='', info=False):
    v = 'INFO' if info else ('PASS' if derived == expected else 'FAIL')
    rows.append((doc, line_of(doc, anchor), claim, str(expected), str(derived), v, note))


def finds(buf, pat, lo=0, hi=None):
    hi = len(buf) if hi is None else hi
    out, j = [], buf.find(pat, lo, hi)
    while j >= 0:
        out.append(j)
        j = buf.find(pat, j + 1, hi)
    return out


def rfind(buf, rx):
    return [m.start() for m in re.finditer(rx, buf, re.S)]


def s(a, n):
    return S[a - SB:a - SB + n]


def le32(a):
    return struct.unpack('<I', s(a, 4))[0]


def h(x):
    return '%06X' % x

# ============================================================== doc 109 (L12, SUB)
BUILDERS = {0xFFEDD182: 'sub_FFEDD182', 0xFFEDD355: 'sub_FFEDD355', 0xFFEDD528: 'sub_FFEDD528', 0xFFEDD6FB: 'sub_FFEDD6FB', 0xFFEDD8DC: 'sub_FFEDD8DC'}


def rx_branch(off):
    """decode a BSR/BRA at SUB file offset off -> (kind, target) or None."""
    b = S[off]
    a = off + SB
    if b in (0x05, 0x04) and off + 4 <= len(S):
        d = int.from_bytes(S[off + 1:off + 4], 'little')
        d -= (1 << 24) if d & 0x800000 else 0
        return ('bsr.a' if b == 5 else 'bra.a', (a + d) & 0xFFFFFFFF)
    if b in (0x39, 0x38) and off + 3 <= len(S):
        d = int.from_bytes(S[off + 1:off + 3], 'little')
        d -= (1 << 16) if d & 0x8000 else 0
        return ('bsr.w' if b == 0x39 else 'bra.w', (a + d) & 0xFFFFFFFF)
    return None

calls = {t: [] for t in BUILDERS}
ptrs = {t: [] for t in BUILDERS}
for off in range(len(S) - 4):
    r = rx_branch(off)
    if r and r[1] in calls:
        calls[r[1]].append((off + SB, r[0]))
for t in BUILDERS:
    for j in finds(S, struct.pack('<I', t)):
        ptrs[t].append(j + SB)
raw_total = sum(len(v) for v in calls.values())
chk(D109, '81 builder call sites;', 'raw whole-image bsr/bra (05/04/39/38) + LE32 pointers into the 5 builders',
    raw_total + sum(len(v) for v in ptrs.values()), 81,
    'per builder calls %s; pointers %s' % ({BUILDERS[k]: len(v) for k, v in calls.items()}, {BUILDERS[k]: len(v) for k, v in ptrs.items()}))
exp_callers = {0xFFEDD182: 5, 0xFFEDD355: 1, 0xFFEDD528: 17, 0xFFEDD6FB: 28, 0xFFEDD8DC: 30}
chk(D109, '81 builder call sites;', 'per-builder raw call counts == builders.tsv callers column (5/1/17/28/30)',
    {BUILDERS[k]: len(v) for k, v in calls.items()}, {BUILDERS[k]: v for k, v in exp_callers.items()})

bs = [r for r in csv.reader(open(P(r'ida\out\sub-frames-sub\build-sites.tsv'), encoding='utf-8'), delimiter='\t') if r and not r[0].startswith('#') and r[0] != 'type']
chk(D109, '101 type-level build sites', 'build-sites.tsv rows', len(bs), 101)
from collections import Counter
tc = Counter(r[0] for r in bs)
chk(D109, '101 type-level build sites', 'build-sites per type', dict(sorted(tc.items())),
    {'E0': 1, 'E1': 4, 'E2': 7, 'E3': 1, 'E4': 14, 'E5': 7, 'E6': 8, 'EA': 28, 'FE': 30, 'FF': 1})
bad = []
for r in bs:
    site = int(r[1], 16)
    first = r[3].split('->')[0].replace('sub_', '').replace('dead_', '')
    tgt = int(first, 16)
    d = rx_branch(site - SB)
    if not d or d[1] != tgt:
        bad.append('%s %s %s' % (r[0], r[1], d))
chk(D109, '101 type-level build sites', 'every build-site address decodes as bsr/bra to the first function of its via chain', bad, [])
chk(D109, '| `E5` | 7 |', 'E5 sites', tc['E5'], 7)
chk(D109, '| `E6` | 8 |', 'E6 sites', tc['E6'], 8)
chk(D109, '**Only two of the 30 sites carry data.**', 'FE sites', tc['FE'], 30)
chk(D109, 'There is also one direct `E4` with code 3', 'direct E4 at FFF38C9E is a bsr to sub_FFEDD528', rx_branch(0xFFF38C9E - SB), ('bsr.a', 0xFFEDD528))

# SCI0 24-bit immediates (MOV.L #imm24: fb (rd<<4)|0b1110 + 3 LE bytes)
def imm24(v):
    lo = v.to_bytes(3, 'little')
    return [j for j in range(len(S) - 5) if S[j] == 0xFB and (S[j + 1] & 0x0F) == 0x0E and S[j + 2:j + 5] == lo]
i0, i2, i3 = imm24(0x08A000), imm24(0x08A002), imm24(0x08A003)
inside = [j + SB for j in i0 + i2 if 0xFFEDB3DC <= j + SB <= 0xFFEDB8E8]
chk(D109, 'All 36 `0x08A000`/`0x08A002` immediates', 'MOV.L #imm24 0x08A000 + 0x08A002 (whole SUB image)', len(i0) + len(i2), 36, '0x08A000 x%d, 0x08A002 x%d' % (len(i0), len(i2)))
chk(D109, 'All 36 `0x08A000`/`0x08A002` immediates', '... of which inside FFEDB3DC-FFEDB8E8', len(inside), len(i0) + len(i2))
chk(D109, 'and `0x08A003` never appears as an immediate', 'MOV.L #imm24 0x08A003', len(i3), 0)
for a in (0x08A003,):
    other = [j for j in range(len(S) - 4) if S[j] == 0xFB and (S[j + 1] & 0x03) == 2 and S[j + 2:j + 5] == a.to_bytes(3, 'little')]
    chk(D109, 'and `0x08A003` never appears as an immediate', 'any fb-form with bytes 03 a0 08', len(other), 0, info=False)

# TX buffers
for b, disp, buf in (('sub_FFEDD182', 0x85F6, 0x1B33A), ('sub_FFEDD355', 0x8DF6, 0x1BB3A), ('sub_FFEDD528', 0x95F6, 0x2433A), ('sub_FFEDD6FB', 0x9676, 0x243BA)):
    chk(D109, '| `%s` | `0x%X` |' % (b, disp), '0x12D44 + disp (%s)' % b, '0x%X' % (0x12D44 + disp), '0x%X' % buf)
base_r14 = [s(a, 6).hex(' ') for a in (0xFFEDD18A, 0xFFEDD360, 0xFFEDD533, 0xFFEDD706, 0xFFEDD8F4)]
chk(D109, 'Each has its own TX', 'base register r14 = mov.l #12D44h in all five builders (fb e2 44 2d 01 00)', base_r14, ['fb e2 44 2d 01 00'] * 5,
    'MOV.B dsp16 is unscaled, so buffer = 0x12D44 + disp: FFEDD528 -> 0x1C33A, FFEDD6FB -> 0x1C3BA, FFEDD8DC (disp 0x96F6) -> 0x1C43A')
chk(D109, 'Each has its own TX', '(lane table) builders.tsv FE buffer 0x2443A vs 0x12D44 + 0x96F6', '0x%X' % (0x12D44 + 0x96F6), '0x2443A')
for a, hx in ((0xFFEDD190, 'c9 0e 0b f6 85'), (0xFFEDD366, 'c9 0e 0f f6 8d'), (0xFFEDD539, 'c9 0e 0f f6 95'), (0xFFEDD70C, 'c9 0e 0f 76 96')):
    chk(D109, 'Each has its own TX', 'disp operand in the builder at %X (builders.tsv)' % a, s(a, 5).hex(' '), hx)
pads = [a for a in range(0xFFEDD2CC, 0xFFEDD336) if s(a, 5) == bytes.fromhex('fae4f68500')]
chk(D109, 'six pad bytes, FFEDD2CC..FFEDD335', 'stores fa e4 f6 85 00 in FFEDD2CC..FFEDD335', len(pads), 6, ' '.join('%X' % a for a in pads))
# frame lengths n+13 (length field n+9 plus 4)
for t, n, L in (('E0', 5, 18), ('E2', 2, 15), ('E3', 3, 16), ('E4', 29, 42), ('E5/E6/EA', 1, 14), ('FF', 8 + 256, 277)):
    chk(D109, '**Matches.** The SUB length' if t not in ('E2', 'FF') else ('`E2` is 15 bytes' if t == 'E2' else '`FF` is 277 bytes'), '%s frame length n+13 (n=%d)' % (t, n), n + 13, L)
chk(D109, '`E1` (13+n) and `FE` (154+w18)', 'FE length: 152 header/payload bytes + 2 checksum', 152 + 2, 154)
ft = {r[0]: r for r in csv.reader(open(P(r'ida\out\sub-frames-sub\frame-types.tsv'), encoding='utf-8'), delimiter='\t') if r and not r[0].startswith('#')}
for t, cnt, tot in (('E2', 0x10, 17), ('FF', 0x110, 273), ('E1', 0x7F, 128), ('FE', 0xC7, 200)):
    chk(D109, '`E2` is 15 bytes' if t == 'E2' else ('`FF` is 277 bytes' if t == 'FF' else '`E1` (13+n) and `FE` (154+w18)'),
        'MAIN count %s: bytes-after-start 0x%X + start byte (frame-types.tsv MAIN_count column; source doc 84)' % (t, cnt), cnt + 1, tot,
        'frame-types.tsv: %s' % ft[t][2])
# INTB slots
for slot, nm in ((58, 'RXI0'), (59, 'TXI0'), (62, 'RXI2'), (63, 'TXI2'), (110, '110')):
    v = le32(0xFFED8A70 + 4 * slot)
    chk(D109, 'I also read the INTB slots', 'INTB slot %d (%s) = FFED8A70+%d*4' % (slot, nm, slot), '%08X' % v,
        {58: 'FFEDB7E7', 59: 'FFEDB857'}.get(slot, '%08X' % v), info=slot not in (58, 59))
# IER10 bit 7 == vector 135
chk(D109, 'IER10 bit 7 is vector 135', 'ICU IER address/bit for vector 135', '0x%X b%d' % (0x87200 + 135 // 8, 135 % 8), '0x87210 b7')
# strings pool and tens table
pool = s(0xFFF4AEB5, 260)
chk(D109, 'Type the 260 bytes at `FFF4AEB5`', 'FFF4AEB5..FFF4AFB8 length / starts SCAN= / ends %d,FT3D,NUL', (0xFFF4AFB8 - 0xFFF4AEB5 + 1, pool[:5], pool[-8:]), (260, b'SCAN=', b'%d\x00FT3D\x00'))
allwf = open(P(r'ida\out\sub-final2\raw\mask_final2_allwf.bin'), 'rb').read() if os.path.exists(P(r'ida\out\sub-final2\raw\mask_final2_allwf.bin')) else None
if allwf is not None:
    # masks are window-relative (0xFFED0000-0xFFF50000) when 524,288 B long
    base = 0xFFED0000 if len(allwf) == 524288 else SB
    chk(D109, '0 of the 260 are set', 'bytes of FFF4AEB5..FFF4AFB8 set in mask_final2_allwf.bin (len %d)' % len(allwf), sum(1 for a in range(0xFFF4AEB5, 0xFFF4AFB9) if allwf[a - base]), 0)
else:
    chk(D109, '0 of the 260 are set', 'mask_final2_allwf.bin', 'not found', 0, 'uncheckable here', info=True)
tens = s(0xFFC3EB56, 40)
chk(D109, '`FFC3EB56`–`FFC3EB7D` (40 bytes)', 'tens table = 10 LE u16 pairs (i, 10*i)', [struct.unpack('<HH', tens[4 * i:4 * i + 4]) for i in range(10)], [(i, 10 * i) for i in range(10)])
chk(D109, '`FFC3EB56`–`FFC3EB7D` (40 bytes)', 'range length', 0xFFC3EB7D - 0xFFC3EB56 + 1, 40)
chk(D109, '1. **Builders and the transmit path.**', '(info) bsr at FFEDD34F targets sub_FFEDAF2D', rx_branch(0xFFEDD34F - SB), ('bsr.a', 0xFFEDAF2D))
bts = [r for r in csv.reader(open(P(r'ida\out\sub-frames-sub\builders.tsv'), encoding='utf-8'), delimiter='\t') if r and not r[0].startswith('#') and r[0] != 'builder']
ev_bad, ev_n = [], 0
for r in bts:
    for m in re.finditer(r'(FF[0-9A-F]{6}) ((?:[0-9a-f]{2} )*[0-9a-f]{2})(?![0-9a-f])', r[8]):
        ev_n += 1
        a = int(m.group(1), 16); want = m.group(2)
        if s(a, len(want.split())).hex(' ') != want:
            ev_bad.append('%X %s != %s' % (a, want, s(a, len(want.split())).hex(' ')))
chk(D109, 'Tables: `ida\\out\\sub-frames-sub\\frame-types.tsv`', 'builders.tsv evidence byte runs re-read (%d runs)' % ev_n, ev_bad, [])
ftb, ft_n = [], 0
for r in ft.values():
    for m in re.finditer(r'(FF[0-9A-F]{6}) ((?:[0-9a-f]{2} )*[0-9a-f]{2})(?![0-9a-f])', '\t'.join(r)):
        ft_n += 1
        a = int(m.group(1), 16); want = m.group(2)
        if s(a, len(want.split())).hex(' ') != want:
            ftb.append('%X %s != %s' % (a, want, s(a, len(want.split())).hex(' ')))
chk(D109, 'Tables: `ida\\out\\sub-frames-sub\\frame-types.tsv`', 'frame-types.tsv evidence byte runs re-read (%d runs)' % ft_n, ftb, [])

# ============================================================== doc 110 (L13): count claims
st = rfind(C, rb'\x6a[\x80-\x8f]\x95\x6d')
chk(D110, '| 93:157 | FF956D writers', 'abs16 byte stores 6a 8X 95 6d (MAIN content)', [h(x) for x in st],
    ['02F622', '03111E', '0341E4', '03421A', '03429A', '0342BE', '0342D2', '034316', '03433A', '034860', '039436'])
chk(D110, '| 93:157 | FF956D writers', 'each preceded by fc 02', all(C[x - 2:x] == b'\xfc\x02' for x in st), True)
chk(D110, '| 93:157 | FF956D writers', 'word (6b 8X 95 6c/6d) or abs32 (6a aX 00 ff 95 6d / 6b aX ...) store forms', len(rfind(C, rb'\x6b[\x80-\x8f]\x95[\x6c\x6d]')) + len(rfind(C, rb'[\x6a\x6b][\xa0-\xaf]\x00\xff\x95\x6d')), 0)
b0 = rfind(C, rb'[\x6a\x6b][\x00-\x0f\x10-\x1f\x80-\x8f]\xb0\xcc') + finds(C, b'\x00\xff\xb0\xcc')
chk(D110, '| 93:193 | B0CC:', 'byte-level references to FFB0CC (abs16 6a/6b + abs32)', [h(x) for x in sorted(b0)],
    ['002E18', '0358CA', '035A22', '035EDC', '035F86', '073B3A', '0743BC', '0743C2', '0743CC'])
chk(D110, '| 93:193 | B0CC:', 'of those in final4-proven code', len([x for x in b0 if F4P[x]]), 8, 'not proven: %s' % [h(x) for x in b0 if not F4P[x]])
chk(D110, '| 93:193 | B0CC:', 'stores 6a 8X b0 cc', [h(x) for x in rfind(C, rb'\x6a[\x80-\x8f]\xb0\xcc')], ['002E18', '073B3A', '0743BC', '0743CC'])
chk(D110, '| 93:193 | B0CC:', '0x035F84 is a bra and 0x035F86 follows it', (M[0x035F84] in (0x40, 0x58) or M[0x035F84:0x035F86] == b'\x40\x00', M[0x035F86:0x035F8C].hex(' ')), (True, '6a 10 b0 cc 73 00'), 'byte at 035F84 = %s' % M[0x035F84:0x035F86].hex(' '))
chk(D110, '- **Hit-test calls.** 125', 'jsr @0x026F08 (5e 02 6f 08)', len(finds(C, bytes.fromhex('5e026f08'))), 125)
d052 = finds(C, bytes.fromhex('5e06d052'))
chk(D110, '- **Doc 86 stores.** Six', 'jsr @0x06D052', len(d052), 6)
chk(D110, '- **Doc 86 stores.** Six', 'each with 6a 0c 8d de 4a within 16 B before', all(C.find(b'\x6a\x0c\x8d\xde\x4a', x - 16, x) >= 0 for x in d052), True)
chk(D110, 'Nineteen `fc imm 6a 8c b0 b9`', 'fc imm 6a 8c b0 b9', len(rfind(C, rb'\xfc.\x6a\x8c\xb0\xb9')), 19)
chk(D110, "- **Doc 94's J counts**", 'bb c2 in MAIN content', len(finds(C, b'\xbb\xc2')), 88)
chk(D110, "- **Doc 94's J counts**", '6b 8X bb c2', [h(x) for x in rfind(C, rb'\x6b[\x80-\x8f]\xbb\xc2')], ['026F3C', '026F48', '026F6A'])
chk(D110, "- **Doc 94's J counts**", '79 2X 89 80', len(rfind(C, rb'\x79[\x20-\x2f]\x89\x80')), 9)
chk(D110, '`jsr @0x3BDAC` ×32', 'jsr @0x3BDAC', len(finds(C, bytes.fromhex('5e03bdac'))), 32)
chk(D110, '`jsr @0x3BDAC` ×32', 'jsr @0x3BF4C', len(finds(C, bytes.fromhex('5e03bf4c'))), 31)
chk(D110, '  - 12 `mov.b` writers.', 'mov.b stores 6a 8X 80 0f/10/11', len(rfind(C, rb'\x6a[\x80-\x8f]\x80[\x0f\x10\x11]')), 12)
chk(D110, '  - One `mov.l #0xFF800E`.', 'mov.l #0xFF800E,erN', [h(x) for x in rfind(C, rb'\x7a[\x00-\x07]\x00\xff\x80\x0e')], ['03955E'])
chk(D110, '  - Three `jsr sub_39534`', 'jsr sub_39534 / sub_39544', (len(finds(C, bytes.fromhex('5e039534'))), len(finds(C, bytes.fromhex('5e039544')))), (3, 3))
chk(D110, '  - `mov.l #0x20,er0` only at', 'mov.l #0x20,er0', [h(x) for x in finds(C, bytes.fromhex('7a0000000020'))], ['039558'])
chk(D110, '  - 13 `jsr sub_34DC2`', 'jsr sub_34DC2 / 34E82 / 34E42', (len(finds(C, bytes.fromhex('5e034dc2'))), len(finds(C, bytes.fromhex('5e034e82'))), len(finds(C, bytes.fromhex('5e034e42')))), (13, 2, 1))
chk(D110, '  - One `55 7c` into', 'bsr 55 7c landing on 0x034E42', [h(x) for x in finds(C, b'\x55\x7c') if x + 2 + 0x7c == 0x034E42], ['034DC4'])
chk(D110, '  - The four er5 window stores', 'mov.l #0xFF92CE/D6,er5 in sub_3F4A2', len([x for x in rfind(C, rb'\x7a\x05\x00\xff\x92[\xce\xd6]') if 0x03F4A2 <= x < 0x03F4EA]), 4)
chk(D110, '  - `jsr sub_32650` ×4.', 'jsr sub_32650', len(finds(C, bytes.fromhex('5e032650'))), 4)
chk(D110, '  - The single `btst #4` on `+0x86`.', 'btst #4 on @(0x86,erN) (6e x 00 86 73 4c)', len([x for x in range(len(C) - 6) if C[x] == 0x6E and C[x + 2:x + 6] == b'\x00\x86\x73\x4c']), 1)
mfirst = (M[0x027648:0x02764C], M[0x0276D2:0x0276D6], M[0x027784:0x027788])
chk(D110, '- **Zone tables.** 99 tables', '(info) bytes at the three phantom-record overrun addresses', ' / '.join(x.hex(' ') for x in mfirst), '', info=True)
zt = [r for r in csv.reader(open(P(r'ida\out\main-final4\touch-zone-tables.tsv'), encoding='utf-8'), delimiter='\t') if r and r[0] != 'table' and not r[0].startswith('#')]
cnt = [int.from_bytes(M[int(r[0], 16):int(r[0], 16) + 2], 'big') for r in zt]
cov = set()
for r in zt:
    t = int(r[0], 16); cov.update(range(t, t + 2 + 10 * int.from_bytes(M[t:t + 2], 'big')))
chk(D110, '- **Zone tables.** 99 tables', 'zone tables / records (image counts) / 2+10n sum / union bytes', (len(zt), sum(cnt), sum(2 + 10 * c for c in cnt), len(cov)), (99, 511, 5308, 5296))
ht = [r for r in csv.reader(open(P(r'ida\out\main-final4\helper-tables.tsv'), encoding='utf-8'), delimiter='\t') if r and r[0] != 'site' and not r[0].startswith('#')]
chk(D110, '- **Helper tables.** 71 sites', 'helper-tables.tsv: rows / distinct sites / distinct tables / slots sum', (len(ht), len({r[0] for r in ht}), len({r[3] for r in ht}), sum(int(r[5]) - 1 for r in ht)), (80, 71, 79, 649))
dead = list(csv.DictReader(open(P(r'ida\out\sub-final3\dead.tsv'), encoding='utf-8'), delimiter='\t'))
mg = list(csv.DictReader(open(P(r'ida\out\sub-final3\merges.tsv'), encoding='utf-8'), delimiter='\t'))
chk(D110, '- **K7.** `dead.tsv` has 125', 'dead.tsv rows / bytes', (len(dead), sum(int(r['bytes_total']) for r in dead)), (125, 10670))
chk(D110, '- **K7.** `dead.tsv` has 125', 'merges.tsv rows / j10 / all-chunk bytes / owners', (len(mg), sum(int(r['bytes_j10']) for r in mg), sum(int(r['bytes_all_chunks']) for r in mg), len({r['owner_now'] for r in mg})), (31, 2279, 2890, 15))
us = list(csv.DictReader(open(P(r'ida\out\sub-final3\usb-scan.tsv'), encoding='utf-8'), delimiter='\t'))
chk(D110, '- **K7.** `dead.tsv` has 125', 'usb-scan.tsv rows', len(us), 184, 'detail prefixes: %s' % dict(Counter(r['detail'].split('(')[0].split(' ')[0] for r in us)))

# ============================================================== doc 111 (L14)
chk(D111, 'Counting these with K12', '18 + 3 + 3 errata rows', 18 + 3 + 3, 24)
er = list(csv.DictReader(open(P(r'ida\out\errata-j\errata.tsv'), encoding='utf-8'), delimiter='\t'))
chk(D111, 'Counting these with K12', 'errata.tsv rows', len(er), 24)
bc = list(csv.DictReader(open(P(r'ida\out\errata-j\bytecheck.tsv'), encoding='utf-8'), delimiter='\t'))
chk(D111, '2. Re-reads **61 byte runs', 'bytecheck.tsv rows / PASS', (len(bc), sum(r['result'] == 'PASS' for r in bc)), (61, 61))
chk(D111, '2. Re-reads **61 byte runs', 'bytecheck split C/K/X ids', dict(Counter(r['id'][0] for r in bc)), {'C': 42, 'K': 14, 'X': 5})
bcb = []
for r in bc:
    if r['image'] in ('M', 'S') and re.fullmatch(r'(?:[0-9a-f]{2} )*[0-9a-f]{2}', r['expected'] or ''):
        off = int(r['file_off'], 16)
        buf = M if r['image'] == 'M' else S
        if buf[off:off + len(r['expected'].split())].hex(' ') != r['expected']:
            bcb.append(r['id'])
chk(D111, '2. Re-reads **61 byte runs', 'bytecheck.tsv byte rows re-read independently (mismatches)', bcb, [])
kw = list(csv.DictReader(open(P(r'ida\out\errata-j\kwave-index.tsv'), encoding='utf-8'), delimiter='\t'))
chk(D111, '4. Checks both ends of each K-wave index row', 'kwave-index.tsv rows (x2 text checks)', (len(kw), 2 * len(kw)), (23, 46))
chk(D111, 'The whole content holds exactly 3 stores', 'word stores to FFBBC2 (6b 8X bb c2)', [h(x) for x in rfind(C, rb'\x6b[\x80-\x8f]\xbb\xc2')], ['026F3C', '026F48', '026F6A'])
chk(D111, '| K-02 | 71:43', 'jsr @0x026F08 sites', len(finds(C, bytes.fromhex('5e026f08'))), 125)
# 16 rows with the corrected address in proven code
corr = {'E01': 0x04E318, 'E02': 0x026F48, 'E03': 0x026F48, 'E08': 0x074342, 'E09': 0x054F1C, 'E10': 0x05601C, 'E11': 0x05549A, 'E12': 0x038672,
        'E13': 0x002A5E, 'E14': 0x056772, 'E15': 0x056822, 'E16': 0x05694C, 'E17': 0x056776, 'E18': 0x05B8A8, 'E19': 0x05B8AC, 'E20': 0x05C436}
chk(D111, 'In 16 of the rows the corrected', 'corrected addresses of E01-E03, E08-E20 set in final4 proven', sum(F4P[a] for a in corr.values()), 16, 'not proven: %s' % [k for k, a in corr.items() if not F4P[a]])
nonly = {'E04': 0x02B3DA, 'E05': 0x02B3DE, 'E06': 0x02B3C2, 'E22': 0x01935A, 'E23': 0x01935A, 'E24': 0x00CE40}
chk(D111, '| E04 | 72:63 |', 'N-only rows: named=1 proven=0 (E04-E06, E22-E24)', {k: (F4N[a], F4P[a]) for k, a in nonly.items()}, {k: (1, 0) for k in nonly})
chk(D111, '| E07 | 72:91 |', 'E07 152 B 0x0376C8-0x03775F in neither final4 mask', sum(F4P[0x0376C8:0x037760]) + sum(F4N[0x0376C8:0x037760]), 0,
    'continuation 0x037760-0x037762: proven %d, named %d (outside the 152 B the row is about)' % (sum(F4P[0x037760:0x037763]), sum(F4N[0x037760:0x037763])))
# ramps
def nondec(lo, hi):
    b = M[lo:hi + 1]
    return all(b[i] <= b[i + 1] for i in range(len(b) - 1)), b[0], b[-1], len(b)
chk(D111, '| E07 | 72:91 |', 'ramps 0376C8-0376F9 / 0376FA-03772B / 03772C-03775F: (nondecreasing, first, last, len)',
    [nondec(0x0376C8, 0x0376F9), nondec(0x0376FA, 0x03772B), nondec(0x03772C, 0x03775F)],
    [(True, 0x11, 0x1a, 50), (True, 0x11, 0x19, 50), (True, 0x0f, 0x5b, 52)])
chk(D111, '| E07 | 72:91 |', 'ramp breaks (drops) only at 0376FA and 03772C; 5b run ends 0x037762', ([h(0x0376C8 + i + 1) for i in range(0x037762 - 0x0376C8) if M[0x0376C8 + i + 1] < M[0x0376C8 + i]], M[0x03775F:0x037763].hex(' ')), (['0376FA', '03772C'], '5b 5b 5b 5b'), 'byte after the run at 0x037763 = %02x' % M[0x037763])
chk(D111, '| E08 | 72:129 |', 'false abs24 target', '0x%06X' % int.from_bytes(M[0x074341:0x074344], 'big'), '0x036B84')
chk(D111, '| E13 | 76:126 |', 'vector 110 slot address', '0x%X' % (110 * 4), '0x1B8')
tab = [int.from_bytes(M[0x05C40A + 4 * i:0x05C40E + 4 * i], 'big') for i in range(12)]
chk(D111, '   - The table has 11 pointers', '0x05C40A: 11 code pointers then non-pointer at 0x05C436', (sum(1 for v in tab[:11] if 0x05B000 <= v < 0x05D000), '%08X' % tab[11]), (11, '%08X' % tab[11]), 'slot 11 bytes = %s (code)' % M[0x05C436:0x05C43A].hex(' '))
chk(D111, '`0x05B364` (= `0x05B310 + 0x15×4`)', '0x05B310 + 0x15*4', '0x%X' % (0x05B310 + 0x15 * 4), '0x5B364')
chk(D111, '   - It clears 32 B at `FFB13E`', 'count of 01 00 69 d4 0b 95 at 0x05A04C..', sum(1 for i in range(8) if M[0x05A04C + 6 * i:0x05A052 + 6 * i] == bytes.fromhex('010069d40b95')), 8)
# E21 SUB font blocks
FT = 0xFFED4644
blk = [struct.unpack('<BBHII', s(FT + 12 * i, 12)) for i in range(26)]
want_14 = {0: 0x9321, 1: 0x5021, 2: 0x2121, 4: 0x2D21, 5: 0x2124, 6: 0x7921, 7: 0x2122, 8: 0x2121}
got_14 = {i: blk[i][2] for i in want_14 if blk[i][:2] == (14, 14)}
chk(D111, '| E21 | 79:128', 'blocks 0-2,4-8 are 14x14 with the listed bases', got_14, want_14)
chk(D111, '| E21 | 79:128', 'block 3 = (w,h,base)', blk[3][:3], (7, 14, 0x20))
chk(D111, '| E21 | 79:128', 'block 8 == block 2 (12 B)', s(FT + 96, 12) == s(FT + 24, 12), True)
chk(D111, '| E21 | 79:128', 'blocks 9-25 bases (except 11, 18) all 0x0020; block 11 / 18', ({i: blk[i][2] for i in range(9, 26) if i not in (11, 18) and blk[i][2] != 0x20}, blk[11][:3], blk[18][:3]), ({}, (10, 9, 0x23), (5, 14, 0x2E)))
chk(D111, '| E21 | 79:128', 'blocks 9-25 size range (first, last)', (blk[9][:2], blk[25][:2]), ((14, 27), (4, 7)), 'w x h of blocks 9 and 25')
chk(D111, '| K-20 | 79:27', 'SUB FFED7F50 4 LE32', ['%08X' % le32(0xFFED7F50 + 4 * i) for i in range(4)], ['00FFF0FF', '00FFF1FF', '00FFF2FF', '00FFF3FF'])

# ============================================================== doc 112 (L15)
cr = [r for r in csv.reader(open(P(r'ida\out\c-recon\citations.tsv'), encoding='utf-8'), delimiter='\t') if r and r[0] != 'addr']
crb = [r[0] for r in cr if M[int(r[0], 16):int(r[0], 16) + len(r[1].split())].hex(' ') != r[1]]
chk(D112, '`ida\\out\\c-recon\\citations.tsv` (re-read from the image', 'c-recon/citations.tsv rows / mismatches on re-read', (len(cr), crb), (65, []))
fsm = [int.from_bytes(M[0x055002 + 4 * i:0x055006 + 4 * i], 'big') for i in range(12)]
chk(D112, 'So state 5 shares the handler of state 1', 'FSM: state5==state1==0x055042, state10==state7==0x055306', (fsm[5] == fsm[1] == 0x055042, fsm[10] == fsm[7] == 0x055306), (True, True))
chk(D112, 'So state 5 shares the handler of state 1', 'FSM: 10 distinct handlers among 12 slots', len(set(fsm)), 10)
chk(D112, 'indexed `jmp`). Re-read from the image', 'dispatcher 0x054FF8 indexes 0x055002', M[0x054FF8:0x055000].hex(' '), '78 b0 6b 26 00 05 50 02')
chk(D112, 'writes up to `0xFF5806 + 0x43E = 0xFF5C44`', 'overrun arithmetic: 0xFF5806+0x3FF+0x40-1, minus window end 0xFF5C05', ('0x%X' % (0xFF5806 + 0x3FF + 0x40 - 1), 0xFF5806 + 0x43E - (0xFF5806 + 0x3FF)), ('0xFF5C44', 63))
rep = finds(M, bytes.fromhex('6a0c81846a8cee18'))
chk(D112, '**The 3-byte EP `0x83` report** appears verbatim', 'report byte0 copy (6a 0c 81 84 6a 8c ee 18) sites', [h(x) for x in rep], ['054F4E', '05520A', '055336', '0557D8'], '0x055202/0x05532E are the DASTS gates before 05520A/055336; 0557D8 lies in sub_557A2')
vec = [int.from_bytes(M[4 * v:4 * v + 4], 'big') for v in (234, 235, 238)]
chk(D112, '(vectors 234/235/238', 'vectors 234/235/238', ['%06X' % v for v in vec], ['054D50', '054EC2', '054CFA'])
req = {k: len([x for x in finds(M, bytes.fromhex('792a' + k)) if 0x054B00 <= x < 0x056100]) for k in ('8006', 'c1d4', '41d1', '41d2', '41d3')}
chk(D112, 'all five accepted requests', '(info) cmp.w #req,r2 sites per request in 0x054B00-0x056100', req, '', info=True)
cl = {f: sum(1 for _ in open(P(r'ida\out\c-recon', f), encoding='utf-8')) for f in ('l15_usb_vendor.c', 'l15_tx_gate.c', 'l15_keyseq.c')}
chk(D112, '**~370 lines of C over ~30 routines**', '(info) line counts of the three C files (RESUME: 809)', (cl, sum(cl.values())), '', info=True)
chk(D112, 'Output in `l15_dump.txt` (3,207 lines)', 'l15_dump.txt lines', sum(1 for _ in open(P(r'ida\out\c-recon\l15_dump.txt'), encoding='utf-8', errors='replace')), 3207)
chk(D112, '(`00 02 05 0a 14` = OFF/20/50/100/200 ms)', 'delay table x10 ms', [b * 10 for b in M[0x00FCDC:0x00FCE1]], [0, 20, 50, 100, 200])
chk(D112, '**PTT debounce** `sub_FC66`', 'off_FC80 4 BE32', ['%06X' % int.from_bytes(M[0xFC80 + 4 * i:0xFC84 + 4 * i], 'big') for i in range(4)], ['00FC90', '00FC9C', '00FCE2', '00FCF4'])
chk(D112, '(`0x054EA8` → `jsr 0x07827C`)', 'jsr @0x07827C sites', [h(x) for x in finds(M, bytes.fromhex('5e07827c'))], ['054EB0'], info=False)

with open(os.path.join(OUT, 'counts_c.tsv'), 'w', encoding='utf-8', newline='') as f:
    f.write('doc\tline\tclaim\texpected\tderived\tverdict\tnote\n')
    for r in rows:
        f.write('\t'.join(str(x).replace('\t', ' ').replace('\n', ' ') for x in r) + '\n')
print('checks', len(rows), dict(Counter(r[5] for r in rows)))
for r in rows:
    if r[5] == 'FAIL':
        print('FAIL', r)
