import sys
from pathlib import Path as _Path
_REPO = _Path(__file__).resolve().parents[3]
# M13 group B: whole-image count / pattern / table checks behind docs 104-108 (L7, L8, L9, L10, L11).
# Plain Python, read-only on both images. Writes counts_b.tsv to $OUTDIR (default: this directory).
# MAIN: file offset = address, big-endian H8SX (abs16 operands sign-extend to 0xFFxxxx).
# SUB: file offset = address - 0xFFC00000, RX little-endian.
import os, sys, hashlib
sys.dont_write_bytecode = True
ROOT = str(_REPO)
HERE = os.path.dirname(os.path.abspath(__file__))
OUT = os.environ.get('OUTDIR', HERE)
sys.exit('The firmware image is not in this repository.')
assert hashlib.sha256(M).hexdigest().startswith('8e3ecd05409b2c31')
assert hashlib.sha256(S).hexdigest().startswith('b93570b3c2f69ccb')
SB = 0xFFC00000
HI = 0x80000
D104, D105, D106, D107, D108 = ('104-pdn-node-table.md', '105-tx-states.md', '106-dsp-1c03-leftovers.md',
                                '107-accessory-ptt.md', '108-sub-frames-main.md')
be32 = lambda a: int.from_bytes(M[a:a + 4], 'big')
be16 = lambda a: int.from_bytes(M[a:a + 2], 'big')
rows = []


def row(doc, line, claim, expected, derived, ok, note=''):
    v = ok if isinstance(ok, str) else ('PASS' if ok else 'FAIL')
    rows.append((doc, str(line), claim, str(expected), str(derived), v, note))


def finds(buf, pat, lo=0, hi=None):
    hi = len(buf) if hi is None else hi
    out, j = [], buf.find(pat, lo)
    while 0 <= j < hi:
        out.append(j)
        j = buf.find(pat, j + 1)
    return out


def hx(xs, base=0):
    return ' '.join('%06X' % (x + base) for x in xs)


# ---------------------------------------------------------------- doc 104 (L7)
T = 0x074472
ptr = [be32(T + 4 * i) for i in range(48)]
row(D104, 16, 'off_74472 = 48 BE32 handler pointers 0x074472-0x074531, all code addresses',
    '48 even targets < 0x07B754', '%d even targets in range; next dword at 0x074532 = %08X' % (
        sum(1 for p in ptr if p % 2 == 0 and 0x400 <= p < 0x07B754), be32(0x074532)),
    all(p % 2 == 0 and 0x400 <= p < 0x07B754 for p in ptr), 'slot 1 = %06X (sub_2070)' % ptr[1])
row(D104, 25, "slot 0x10 ('@') = sub_73E58", '073E58', '%06X' % ptr[0x10], ptr[0x10] == 0x073E58)
row(D104, 73, 'slots 0x2D/0x2E', '074396 0743E0', '%06X %06X' % (ptr[0x2D], ptr[0x2E]), (ptr[0x2D], ptr[0x2E]) == (0x074396, 0x0743E0))
arg = M[0x074532:0x074532 + 48]
row(D104, 19, 'byte_74532: 48 arg-length bytes, 0xFF = variable', '48 B', 'len 48; 0xFF count %d; first 16 %s' % (arg.count(0xFF), arg[:16].hex(' ')),
    arg[:16].hex(' ') == '02 02 01 02 04 ff 04 ff 01 01 01 01 02 05 09 03')
# FF97FC references
hits = finds(M, b'\x97\xfc', 0, HI)
ops = [h for h in hits if M[h - 2] == 0x6A and M[h - 1] >> 4 in (0, 8)]
wr = [h - 2 for h in ops if M[h - 1] >> 4 == 8]
rd = [h - 2 for h in ops if M[h - 1] >> 4 == 0]
a32 = finds(M, b'\x00\xff\x97\xfc', 0, HI)
row(D104, 126, 'FF97FC: 3 abs16 references (read 0x073996, read 0x073A28, write 0x073A70), no abs32',
    'reads 073996 073A28; write 073A70; abs32 0', 'raw "97 fc" %d (%s); abs16 reads %s; writes %s; abs32 %d' % (len(hits), hx(hits), hx(rd), hx(wr), len(a32)),
    rd == [0x073996, 0x073A28] and wr == [0x073A70] and not a32)
row(D104, 126, 'wording: "3 references, all in 0x0739xx"', 'all three in 0x073900-0x0739FF',
    'only 0x073996 is; 0x073A28 and 0x073A70 are in 0x073Axx', 'FAIL',
    'wording slip; the three addresses the doc lists are right')
ph = [be32(0x073974 + 4 * i) for i in range(7)]
row(D104, 108, 'off_73974 = 7 x BE32 phase handlers', '073990 073992 0739DA 0739FA 073A54 073A86 073A98', hx(ph),
    ph == [0x073990, 0x073992, 0x0739DA, 0x0739FA, 0x073A54, 0x073A86, 0x073A98])
for slot, ch, pat, nm in ((0x1B, 'K', '5e073ac2', 'jsr loc_73AC2'), (0x21, 'Q', '5e073ac2', 'jsr loc_73AC2'),
                          (0x2C, '\\', '5e073ac2', 'jsr loc_73AC2'), (0x01, '1', '5a00dc5a', 'jmp loc_DC5A'),
                          (0x13, 'C', '5a00dbd8', 'jmp sub_DBD8'), (0x19, 'I', '5a0025ac', 'jmp loc_25AC')):
    p = ptr[slot]
    k = M.find(bytes.fromhex(pat), p, p + 64)
    row(D104, 136 if ch in '1CI' else 148, "command '%s' (slot 0x%02X) handler %06X contains %s" % (ch, slot, p, nm),
        pat, ('at %06X (+%d)' % (k, k - p)) if k >= 0 else 'not within 64 B', k >= 0)

# ---------------------------------------------------------------- doc 105 (L8)
raw = finds(M, b'\xaa\xd5', 0, HI)
row(D105, 87, 'raw scan 0x000000-0x080000 for "aa d5": 44 hits', 44, len(raw), len(raw) == 44)
row(D105, 89, '"00 ff aa d5": 0 hits', 0, len(finds(M, b'\x00\xff\xaa\xd5', 0, HI)), not finds(M, b'\x00\xff\xaa\xd5', 0, HI))
st = [h - 2 for h in raw if M[h - 2] == 0x6A and M[h - 1] >> 4 == 8]
vals = {}
for s_ in st:
    reg = M[s_ + 1] & 0x0F
    v = None
    for back in range(2, 24, 2):          # nearest preceding mov.b #imm,rX (fX imm) to the same register
        if M[s_ - back] == (0xF0 | reg):
            v = M[s_ - back + 1]
            break
    vals[s_] = v
vs = sorted(set(v for v in vals.values() if v is not None))
row(D105, 90, '32 AAD5 store sites (mov.b rX,@AAD5:16); values {0,1,2,3,5,0x0D-0x14}, never 4 or 6-0x0C', '32; {0,1,2,3,5,13..20}',
    '%d stores; values %s; unresolved %d' % (len(st), vs, sum(1 for v in vals.values() if v is None)),
    len(st) == 32 and set(vs) == {0, 1, 2, 3, 5} | set(range(0x0D, 0x15)), 'value = nearest preceding mov.b #imm to the stored register')
mt = [be32(0x034674 + 4 * i) for i in range(21)]
tw = [be32(0x035CD8 + 4 * i) for i in range(21)]
row(D105, 19, 'main table 0x034674: 21 dwords, all code', '21', hx(mt), all(0x034000 <= x < 0x036000 for x in mt), 'dword after: %08X' % be32(0x034674 + 84))
row(D105, 19, 'twin table 0x035CD8: 21 dwords, all code', '21', hx(tw), all(0x035000 <= x < 0x037000 and x % 2 == 0 for x in tw), 'dword after: %08X' % be32(0x035CD8 + 84))
row(D105, 216, 'main slots 6-0x0C -> 034DB6/B8/BA/BC/BE/B8/C0, each rts', '034DB6 034DB8 034DBA 034DBC 034DBE 034DB8 034DC0',
    hx(mt[6:13]), mt[6:13] == [0x034DB6, 0x034DB8, 0x034DBA, 0x034DBC, 0x034DBE, 0x034DB8, 0x034DC0] and all(M[x:x + 2] == b'\x54\x70' for x in mt[6:13]))
row(D105, 219, 'twin slots 2-0x0C all -> nullsub_34 0x035E86 (rts)', '035E86 x11', hx(tw[2:13]), set(tw[2:13]) == {0x035E86} and M[0x035E86:0x035E88] == b'\x54\x70')
row(D105, 48, 'state 4 handler 0x034D5C (copy of state 5)', '034D5C', '%06X' % mt[4], mt[4] == 0x034D5C)
w = [be16(0x035158 + 2 * i) for i in range(50)]
row(D105, 290, 'word_35158: 50 CTCSS entries 670..2541 (x0.1 Hz)', '670..2541, increasing', '%d..%d, increasing=%s, next word %04X' % (w[0], w[-1], all(a < b for a, b in zip(w, w[1:])), be16(0x035158 + 100)),
    w[0] == 670 and w[-1] == 2541 and all(a < b for a, b in zip(w, w[1:])))
def bcd(b): return int(b.hex()) * 10 / 1e6
for base, line, exp in ((0x03510A, 186, [(40, 75.995, 0), (108, 119.995, 1), (120, 173.995, 2), (174, 221.995, 3), (222, 229.995, 4)]),
                        (0x035140, 187, [(230, 419.995, 5), (420, 579.995, 6)])):
    n = M[base + 3]
    got = [(bcd(M[base + 4 + 10 * i:base + 8 + 10 * i]), bcd(M[base + 8 + 10 * i:base + 12 + 10 * i]), be16(base + 12 + 10 * i)) for i in range(n)]
    ok = [(round(a, 3), round(b, 3), c) for a, b, c in got] == exp
    row(D105, line, 'sub-band table %06X {lo,hi,idx} packed BCD, 10 Hz units' % base, exp, [(round(a, 3), round(b, 3), c) for a, b, c in got], ok,
        '' if ok else 'image lo of idx 5 is BCD 30 00 00 00 = 300.000 MHz, not 230')
s3 = finds(M, bytes.fromhex('6a18aad47070'), 0, HI)
row(D105, 229, 'AAD4.b7 setters (bset #7,@AAD4): three, 0x0631CC 0x067C30 0x067EFE', '0631CC 067C30 067EFE', hx(s3), s3 == [0x0631CC, 0x067C30, 0x067EFE])
a996 = [h - 2 for h in finds(M, b'\xa9\x96', 0, HI) if M[h - 2] == 0x6A]
row(D105, 326, 'A996: 3 xrefs (two writers and sub_35BAA)', '2 writes + 1 read', '%s' % ', '.join('%06X %s' % (x, 'W' if M[x + 1] >> 4 == 8 else 'R') for x in a996),
    len(a996) == 3 and sum(1 for x in a996 if M[x + 1] >> 4 == 8) == 2)
for a in (0x02285A, 0x0228A2, 0x022912):
    row(D105, 246, 'FF94C0 = 0 store at %06X' % a, 'fc 00 6a 8c 94 c0', M[a - 2:a + 4].hex(' '), M[a - 2:a + 4] == bytes.fromhex('fc006a8c94c0'))
row(D105, 47, 'states 6-0x0C bare rts 0x034DB6-0x034DC1 (54 70 x6)', '54 70 x6', M[0x034DB6:0x034DC2].hex(' '), M[0x034DB6:0x034DC2] == b'\x54\x70' * 6)
f9598 = [h - 2 for h in finds(M, b'\x95\x98', 0, HI) if M[h - 2] == 0x6A and M[h - 1] >> 4 == 8]
row(D105, 257, 'FF9598 = 0x1F loaded in sub_35872 (0x035872 fc 1f 6a 8c 95 98); stores of FF9598', 'store at 035874', hx(f9598), 0x035874 in f9598, 'INFO list of all abs16 stores')
for b in (0x011960, 0x011AB4, 0x011AF8, 0x011B3C):
    row(D107, 333, 'TX-time table %06X (n=%d): event 14 / 15' % (b, (b - 0x011960) // 0x44 + 1),
        '229D2|3FFA0 / 22718', '%05X / %05X' % (be32(b + 56), be32(b + 60)), be32(b + 60) == 0x022718 and be32(b + 56) in (0x0229D2, 0x03FFA0))

# ---------------------------------------------------------------- doc 106 (L9)
b8 = finds(M, b'\xb0\xb8', 0, HI)
b8w = [h - 2 for h in b8 if M[h - 2] == 0x6A and M[h - 1] >> 4 == 8]
b8r = [h - 2 for h in b8 if M[h - 2] == 0x6A and M[h - 1] >> 4 == 0]
row(D106, 19, 'B0B8: one store (0x05C442, value 3); no abs32 form; read only at 0x05A07E/0x05A086',
    'W 05C442; R 05A07E 05A086; abs32 0', 'W %s (imm %s); R %s; abs32 %d; raw "b0 b8" %d' % (hx(b8w), M[0x05C440:0x05C442].hex(' '), hx(b8r), len(finds(M, b'\x00\xff\xb0\xb8', 0, HI)), len(b8)),
    b8w == [0x05C442] and b8r == [0x05A07E, 0x05A086] and not finds(M, b'\x00\xff\xb0\xb8', 0, HI) and M[0x05C440:0x05C442] == b'\xfc\x03')
b9 = finds(M, bytes.fromhex('6a8cb0b9'), 0, HI)
b9v = {x: (M[x - 1] if M[x - 2] == 0xFC else None) for x in b9}
census = {}
for ln in open(os.path.join(ROOT, r'ida\out\dsp-autoreply\b0b9-census.tsv'), encoding='utf-8').read().splitlines()[1:]:
    c = ln.split('\t')
    for s_ in c[1].split(','):
        census[int(s_, 16)] = int(c[0], 16)
img_imm = {x - 2: v for x, v in b9v.items()}
mism = sorted(set(census.items()) ^ set(img_imm.items()))
row(D106, 60, 'B0B9: 19 immediate stores (fc XX 6a 8c b0 b9) matching dsp-autoreply\\b0b9-census.tsv', 19,
    '%d stores; census rows %d; differences %s' % (len(b9), len(census), ['%06X=%02X' % m for m in mism] or 'none'),
    'PASS' if len(b9) == 19 and not mism else ('INFO' if len(b9) == 19 and len(census) == 19 and set(census.values()) == set(img_imm.values()) else 'FAIL'),
    'count and values match; K4 census row 0x20 cites 0x06CAFA (the store) where its header promises the fc-imm address 0x06CAF8')
l9 = {}
for ln in open(os.path.join(ROOT, r'ida\out\dsp-1c03\b0b9-writers.tsv'), encoding='utf-8').read().splitlines():
    if ln.startswith('#') or not ln.strip():
        continue
    c = ln.split('\t')
    for s_ in c[1].split(','):
        l9[int(s_, 16)] = int(c[0], 16)
mism9 = sorted(set(l9.items()) ^ set(img_imm.items()))
row(D106, 178, 'b0b9-writers.tsv (L9) sites = immediate addresses of the 19 stores', 'identical to image',
    'differences %s' % (['%06X=%02X' % m for m in mism9] or 'none'), not mism9,
    'L9 table cites 0x20 at 06CAF8; the immediate fc 20 is at %s' % hx([x for x, v in img_imm.items() if v == 0x20]))
c5a = finds(M, bytes.fromhex('5e05a040'), 0, HI)
row(D106, 107, 'callers of sub_5A040: 0x05A38C and 0x05C446', '05A38C 05C446', hx(c5a), c5a == [0x05A38C, 0x05C446])
sl = finds(M, bytes.fromhex('000664c2'), 0, HI)
js = finds(M, bytes.fromhex('5e0664c2'), 0, HI) + finds(M, bytes.fromhex('5a0664c2'), 0, HI)
row(D106, 39, "sub_664C2's only caller is the key table: BE32 slot 0x0113E4, no abs24 jsr/jmp", 'slot 0113E4; jsr 0', 'BE32 %s; jsr/jmp %d' % (hx(sl), len(js)), sl == [0x0113E4] and not js)
st78 = [('%06X' % (x - 2), M[x - 4:x - 2].hex(' ')) for x in finds(M, b'\x95\x78', 0, HI) if M[x - 2] == 0x6A and M[x - 1] >> 4 == 8]
st89 = [('%06X' % (x - 2), M[x - 4:x - 2].hex(' ')) for x in finds(M, b'\x95\x89', 0, HI) if M[x - 2] == 0x6A and M[x - 1] >> 4 == 8]
row(D106, 148, 'FF9578 / FF9589 = 0xC8 stores (0x03013C, 0x031BEE)', 'C8 stores', 'FF9578 %s; FF9589 %s' % (st78, st89),
    any(a == '03013C' and p == 'fc c8' for a, p in st78) and any(a == '031BF0' and p == 'fc c8' for a, p in st89),
    'FF9589 store is at 0x031BF0 (doc cites 0x031BEE, the imm)')
row(D106, 64, 'FF9579 and FF9578 inside the 10 ms tier FF9536-FF958D', 'inside', 'FF9578 %s, FF9579 %s, FF9589 %s' % tuple(0xFF9536 <= x <= 0xFF958D for x in (0xFF9578, 0xFF9579, 0xFF9589)), True)
row(D106, 167, 'carrier = AACE 5 x FF9579 0x32 x 10 ms', '2.5 s', '%.1f s' % (5 * 0x32 * 0.01), 5 * 0x32 * 0.01 == 2.5)
row(D106, 116, 'session 0x15 table 0x05C40A: 11 steps, step 4 = sub_5C436', '11 code pointers', hx([be32(0x05C40A + 4 * i) for i in range(11)]),
    all(0x05B000 <= be32(0x05C40A + 4 * i) < 0x05D000 for i in range(11)) and be32(0x05C40A + 16) == 0x05C436 and not (0x05B000 <= be32(0x05C40A + 44) < 0x05D000),
    'dword after: %08X' % be32(0x05C40A + 44))

# ---------------------------------------------------------------- doc 107 (L10)
sb = finds(M, bytes.fromhex('7a01000000006e9a9800'), 0, HI)
row(D107, 70, '10 start-byte stores in sub_4761E: 7a 01 00 00 00 00 ; 6e 9a 98 00', '10 in 04761E-047791', '%d: %s' % (len(sb), hx(sb)), len(sb) == 10 and all(0x04761E <= x < 0x047792 for x in sb))
body = [x for x in finds(M, bytes.fromhex('6e9a9800'), 0, HI) if x - 6 not in sb]
row(D107, 72, '13 indexed body stores 6e 9a 98 00 (besides the 10 start stores)', 13, '%d: %s' % (len(body), hx(body)), len(body) == 13)
bb91 = [h - 2 for h in finds(M, b'\xbb\x91', 0, HI) if M[h - 2] == 0x6A]
row(D107, 114, 'FFBB91: exactly one writer and one reader', '1 W + 1 R', ', '.join('%06X %s' % (x, 'W' if M[x + 1] >> 4 == 8 else 'R') for x in bb91),
    len(bb91) == 2 and sorted(M[x + 1] >> 4 for x in bb91) == [0, 8])
e6 = [x + SB for x in finds(S, bytes.fromhex('7541e6'))]
def bsra(a):
    o = a - SB
    if S[o] != 0x05:
        return None
    d = int.from_bytes(S[o + 1:o + 4], 'little')
    d = d - (1 << 24) if d & 0x800000 else d
    return a + d
tg = [bsra(a + 3) for a in e6]
row(D107, 200, 'SUB: 8 E6 sites (mov #0xE6,r1), all in 0xFFF37D88-0xFFF393F4, each followed by bsr.a', '8',
    '%d: %s; bsr.a targets %s' % (len(e6), ' '.join('%08X' % x for x in e6), sorted(set('%08X' % t if t else '-' for t in tg))),
    len(e6) == 8 and all(0xFFF37D88 <= x <= 0xFFF393F4 for x in e6) and all(tg))
row(D107, 299, "L12's bsr.a addresses = E6 site + 3", 'FFF37FB0 FFF38215 FFF38FD2 FFF3906F FFF39284 FFF39312 FFF393B6 FFF393F4',
    ' '.join('%08X' % (x + 3) for x in e6), [x + 3 for x in e6] == [0xFFF37FB0, 0xFFF38215, 0xFFF38FD2, 0xFFF3906F, 0xFFF39284, 0xFFF39312, 0xFFF393B6, 0xFFF393F4])
# bsr.a / bsr.w callers of the two SUB->MAIN builders
def callers(t):
    out = []
    for o in range(0, len(S) - 4):
        b = S[o]
        if b == 0x05:
            d = int.from_bytes(S[o + 1:o + 4], 'little'); d = d - (1 << 24) if d & 0x800000 else d
            if o + SB + d == t: out.append(o + SB)
        elif b == 0x39:
            d = int.from_bytes(S[o + 1:o + 3], 'little'); d = d - (1 << 16) if d & 0x8000 else d
            if o + SB + d == t: out.append(o + SB)
    return out
for t, n in ((0xFFEDD528, 17), (0xFFEDD182, 5)):
    cs = callers(t)
    row(D107, 44, 'callers of sub_%08X: %d sites' % (t, n), n, '%d (bsr.a/bsr.w byte scan, not decode-checked)' % len(cs), len(cs) == n,
        'raw relative-call scan over the whole SUB image; may include data false positives')
v122 = {}
for o in finds(S, bytes.fromhex('fbe2a0220100f8e4')):
    v122.setdefault(S[o + 8], []).append(o + SB)
other122 = [o + SB for o in finds(S, bytes.fromhex('a0220100')) if not (S[o - 2] == 0xFB and S[o - 1] == 0xE2 and S[o + 4:o + 6] == b'\xf8\xe4')]
exp122 = {3: [0xFFF392C3, 0xFFF3935D, 0xFFF3943C],
          2: [0xFFF37E53, 0xFFF384C0, 0xFFF386EF, 0xFFF38997, 0xFFF39101, 0xFFF3915B, 0xFFF391A4, 0xFFF39367, 0xFFF39446, 0xFFF39547],
          0: [0xFFF37D58, 0xFFF37EB9, 0xFFF39099, 0xFFF390A9, 0xFFF39173], 4: [0xFFF39486], 1: [0xFFF3885F]}
row(D107, 310, '[122A0] writer census (mov.l #0x122A0,r14 ; mov.b #v,[r14]): 3 x3, 2 x10, 0 x5, 4 x1, 1 x1', exp122 and 'doc table',
    '; '.join('%d: %s' % (k, ' '.join('%08X' % x for x in v)) for k, v in sorted(v122.items())), v122 == exp122,
    'other 0x122A0 immediates not followed by mov.b #imm,[r14]: %s' % (' '.join('%08X' % x for x in other122) or 'none'))
w12cbc = {}
for o in finds(S, bytes.fromhex('fbe2bc2c0100f8e5')):
    w12cbc.setdefault(S[o + 8], []).append(o + SB)
row(D107, 328, '12CBC = 2 written only at FFF38FBC FFF3926E FFF392FC', 'FFF38FBC FFF3926E FFF392FC', ' '.join('%08X' % x for x in w12cbc.get(2, [])),
    w12cbc.get(2) == [0xFFF38FBC, 0xFFF3926E, 0xFFF392FC], 'all mov.w #v,[r14] after mov.l #0x12CBC: %s' % '; '.join('%d: %s' % (k, ' '.join('%08X' % x for x in v)) for k, v in sorted(w12cbc.items())))
row(D107, 388, '12CBC = 3 without E6 at FFF37EF0, FFF38CDB, FFF38EB6 (plus FFF39059 in the code-3 path)', 'subset of 12CBC=3 stores',
    ' '.join('%08X' % x for x in w12cbc.get(3, [])), {0xFFF37EF0, 0xFFF38CDB, 0xFFF38EB6, 0xFFF39059} <= set(w12cbc.get(3, [])))
w12cc2 = [o + SB for o in finds(S, bytes.fromhex('fbe2c22c0100f8e501'))]
row(D107, 353, '[12CC2] = 1 set solely at FFF39B62 / FFF39B95', 'FFF39B62 FFF39B95', ' '.join('%08X' % x for x in w12cc2), w12cc2 == [0xFFF39B62, 0xFFF39B95])
w12cb8 = {}
for o in finds(S, bytes.fromhex('fbe2b82c0100f8e5')):
    w12cb8.setdefault(S[o + 8], []).append(o + SB)
row(D107, 280, '12CB8 = 2 at FFF38627/FFF3865A; = 1 at FFF38F7B', '2: FFF38627 FFF3865A; 1: FFF38F7B',
    '; '.join('%d: %s' % (k, ' '.join('%08X' % x for x in v)) for k, v in sorted(w12cb8.items())),
    w12cb8.get(2) == [0xFFF38627, 0xFFF3865A] and S[0xFFF38F7B - SB:0xFFF38F7B - SB + 3] == b'\xf8\xe5\x01',
    'doc list incomplete: the image also stores 12CB8 = 2 at FFF387B6 and = 1 at FFF38759 / FFF388EB; FFF38F7B is the mov.w #1,[r14] of the FFF38F75 site')
ck = ''.join(chr(S[a - SB + 2]) for a in (0xFFF3A9D3, 0xFFF3A9DC, 0xFFF3A9F1, 0xFFF3AA06, 0xFFF3AA1B, 0xFFF3AA30, 0xFFF3AA45, 0xFFF3AA5A))
row(D107, 11, 'compares 0xFFF3A9D3-0xFFF3AA5A spell CKPD=200 (75 51 xx)', 'CKPD=200', ck, ck == 'CKPD=200')
row(D107, 104, 'E6 header sum: E6+0A = F0 (high byte 00); E4: E4+26 = 0x10A (high byte 01)', 'F0, 10A', '%X, %X' % (0xE6 + 0x0A, 0xE4 + 0x26), (0xE6 + 0x0A, 0xE4 + 0x26) == (0xF0, 0x10A))

# ---------------------------------------------------------------- doc 108 (L11)
cmp_ = [M[a + 1] for a in range(0x047622, 0x047658) if M[a] == 0xAA and (a - 0x047622) % 2 == 0 and M[a + 1] >= 0xE0]
row(D108, 15, 'start-byte switch 0x047622-0x047656: exactly ten cmp.b #type; then rts 0x047658', 'E0 E1 E2 E3 E4 E5 E6 EA FE FF',
    ' '.join('%02X' % x for x in sorted(cmp_)) + '; 047658 = ' + M[0x047658:0x04765A].hex(' '),
    sorted(cmp_) == [0xE0, 0xE1, 0xE2, 0xE3, 0xE4, 0xE5, 0xE6, 0xEA, 0xFE, 0xFF] and M[0x047658:0x04765A] == b'\x54\x70')
row(D108, 56, 'ring 0xFF306A-0xFF3C6A = 3,073 B', 3073, 0xFF3C6A - 0xFF306A + 1, 0xFF3C6A - 0xFF306A + 1 == 3073)
for cell, nm in ((b'\xbc\x60', 'FFBC60 (E2)'), (b'\xbb\x92', 'FFBB92 (E5)')):
    refs = [h - 2 for h in finds(M, cell, 0, HI) if M[h - 2] in (0x6A, 0x6B)]
    rds = [x for x in refs if (M[x + 1] >> 4) in (0, 1, 3)]
    row(D108, 163, '%s: no abs16 reader in 0-0x80000' % nm, '0 readers', ', '.join('%06X %s' % (x, M[x:x + 2].hex(' ')) for x in refs),
        not rds, 'abs16 forms 6a/6b with op nibble 0 (load), 1/3 (bit test) counted as readers')
ba92 = [h - 2 for h in finds(M, b'\xba\x92', 0, HI) if M[h - 2] == 0x6A and M[h - 1] in (0x10, 0x18)]
bits = {}
for x in ba92:
    op = M[x + 4]; bit = (M[x + 5] >> 4) & 7
    kind = {0x73: 'btst', 0x70: 'bset', 0x72: 'bclr', 0x71: 'bnot', 0x77: 'bld'}.get(op, '%02x' % op)
    bits.setdefault(bit, []).append('%06X %s' % (x, kind))
row(D108, 163, "FFBA92 bit 4 (E5 arrival flag) is never tested", 'bit 4: bset only',
    '; '.join('b%d: %s' % (k, ', '.join(v)) for k, v in sorted(bits.items())),
    all('btst' not in s_ and 'bld' not in s_ for s_ in bits.get(4, [])))

with open(os.path.join(OUT, 'counts_b.tsv'), 'w', encoding='utf-8', newline='') as f:
    f.write('doc\tline\tclaim\texpected\tderived\tverdict\tnote\n')
    for r in rows:
        f.write('\t'.join(x.replace('\t', ' ').replace('\n', ' ') for x in r) + '\n')
from collections import Counter
print('counts_b rows', len(rows), Counter(r[5] for r in rows))
for r in rows:
    if r[5] != 'PASS':
        print(r[5], r[0], r[1], r[2], '|', r[4][:200])
