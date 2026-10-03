# M14 errata check (K wave + follow-up docs 83-97, L-wave lane slips, L-wave correction index).
# Read-only: reads the two decrypted images, the published masks, the decoder table and the docs;
# writes only into ida\out\errata-k-l\. No IDA, no device access, nothing written to any radio.
import sys
from pathlib import Path as _Path
_REPO_S = _Path(__file__).resolve().parents[3].as_posix()
import hashlib, os, struct

ROOT = _REPO_S
OUT = os.path.join(ROOT, r'ida\out\errata-k-l')
DOCS = os.path.join(ROOT, r'docs\deep')
MP = os.path.join(ROOT, r'decrypted\FT3D_MAIN_ver102_EXP.bin')
SP = os.path.join(ROOT, r'decrypted\FT3D_SUB_ver102_ALL.bin')
sys.exit("The firmware image is not in this repository.")
sys.exit("The firmware image is not in this repository.")
rdm = lambda p: open(os.path.join(ROOT, p), 'rb').read()
P6 = rdm(r'ida\out\l-wave-recon\final6_proven_mask.bin')
N6 = rdm(r'ida\out\l-wave-recon\final6_named_mask.bin')
P4 = rdm(r'ida\out\main-final4\final4_proven_mask.bin')
SUBBASE = 0xFFC00000
C = M[:0x80000]

H = lambda b: ' '.join('%02x' % x for x in b)


def rd(img, a, n):
    return M[a:a + n] if img == 'M' else S[a - SUBBASE:a - SUBBASE + n]


def even_hits(pred, lo=0, hi=0x80000):
    return [i for i in range(lo, hi - 6, 2) if pred(i)]


# ------------------------------------------------------------------ byte checks
# (id, image, mapped address, expected bytes, meaning)
CHECKS = [
 # section 1 (K wave / follow-up, doc 110 non-pass rows)
 ('C01', 'M', 0x04B46A, 'f4 2a 68 e4 6e e4 00 01', "mov.b #0x2A,r4h (04B46A); mov.b r4h,@er6 (04B46C); mov.b r4h,@(1,er6) (04B46E)"),
 ('C02', 'M', 0x002098, '6a 18 aa 31 72 50 fc 00 6a 8c 80 04', 'bclr #5,@AA31 ; mov.b #0,r4l (00209E) ; mov.b r4l,@FF8004 (0020A0)'),
 ('C03', 'M', 0x0345AA, '6a 0c 8a a0 ac 01', 'mov.b @FF8AA0,r4l (0345AA) ; cmp.b #1,r4l (0345AE)'),
 ('C04', 'M', 0x034B58, '6a 0c 8a a0 ac 02', 'mov.b @FF8AA0,r4l (034B58) ; cmp.b #2,r4l (034B5C)'),
 ('C05', 'M', 0x00F672, '14 00 00 00 17 40 00 00 42 00 00 00 47 00 00 00 00 00 00 00 00 06',
  '16-B BCD pair, then 00 00 00 00 (0x00F682) and 00 06 (0x00F686)'),
 ('C06', 'M', 0x04954A, '0c 2b 17 0b', 'mov.b r2h,r3l (04954A) ; not.b r3l (04954C)'),
 ('C07', 'M', 0x049556, '0c ab 17 0b', 'mov.b r2l,r3l (049556) ; not.b r3l (049558)'),
 ('C08', 'M', 0x035F84, '40 30 6a 10 b0 cc 73 00', 'bra (035F84) ; btst #0,@B0CC (035F86, after the bra)'),
 ('C09', 'M', 0x03F38E, '6a 04 80 10', 'mov.b @FF8010,r4h'),
 ('C10', 'M', 0x011006, 'fb 04 6a 0c aa d1 ec 0c 46 14 fb 09 6a 0c aa d3 ec 0f 46 0a 6a 0c aa d4 ec 01 46 02 fb 01 7a 05 00 01 19 60 1a 0b 79 06 00 44',
  'sub_10FA8: n=4 if AAD1&0x0C; n=9 if AAD3&0x0F or AAD4&0x01; else n=1; er5 = 0x011960 + (n-1)*0x44'),
 # section 2 (L-wave lane slips)
 ('C11', 'M', 0x073E80, 'aa e1 67 00 40 22 5e 03 4a 52 fc 01 40 06 5e 03 50 e4 fc 00',
  "'@' handler: jsr @0x034A52 (073E86) ; mov.b #1,r4l (073E8A) ; bra ; jsr @0x0350E4 (073E8E) ; mov.b #0,r4l (073E92)"),
 ('C12', 'M', 0x073A28, '6a 0b 97 fc 7a 63 00 00 00 ff 10 73 78 b0 6b 26 00 07 44 72 5d 60',
  'mov.b @FF97FC,r3l (073A28) ; and.l #0xFF,er3 ; shll.l #2,er3 (073A32) ; mov.l @(0x074472,er3),er6 (073A34, 8 B) ; jsr @er6 (073A3C)'),
 ('C13', 'M', 0x0743BA, 'fc 01 6a 8c b0 cc', "remote ']' arg 1: mov.b #1,r4l (0743BA) ; mov.b r4l,@FFB0CC (0743BC)"),
 ('C14', 'M', 0x0743CA, 'fc 00 6a 8c b0 cc', "remote ']' arg 0: store at 0743CC (doc 106 l.131 cites the store; correct)"),
 ('C15', 'M', 0x03023A, '6a 18 aa d1 70 00 fc 05 6a 8c aa ce', 'bset #0,@AAD1 ; mov.b #5,r4l (030240) ; mov.b r4l,@FFAACE (030242)'),
 ('C16', 'M', 0x031CCC, '6a 18 aa d1 70 00 fc 05 6a 8c aa ce', 'band-B twin: mov.b #5,r4l (031CD2) ; store (031CD4)'),
 # section 3 anchors
 ('C17', 'M', 0x05AF34, '44 53 50 3e 43 50 55 3a 20 44 41 54 41 20 54 45 58 54 20 53 45 54', '"DSP>CPU: DATA TEXT SET" (DSP->CPU direction)'),
 ('C18', 'M', 0x05A07E, '6a 0b b0 b8 6b 83 b1 3e', 'builder sub_5A040: r3l = [B0B8] ; frame word 1C|B0B8 -> FFB13E'),
 ('C19', 'S', 0xFFF3AEB4, 'fb e2 78 05 01 00 f8 e4 01', 'SUB: TXAT=1 acknowledged (doc 107 l.151)'),
 ('C20', 'S', 0xFFF3A8B4, '66 51', 'SUB: ERAT callback code 5 (doc 107 l.207)'),
 ('C21', 'S', 0xFFF4AEDA, '54 58 41 54 3d 25 64 0d 0a 00', '"TXAT=%d\\r\\n"'),
 ('C22', 'S', 0xFFEDC8FE, 'b2 a9', 'SUB sub_FFEDC615 frame-checksum path (doc 109 l.210)'),
 ('C23', 'S', 0xFFEDC902, '55 21 0c', 'SUB: block number from frame +6..+7 (doc 109 l.210)'),
 ('C24', 'M', 0x05C440, 'fc 03 6a 8c b0 b8', 'only B0B8 store: mov.b #3,r4l ; mov.b r4l,@FFB0B8 (05C442)'),
 ('C25', 'M', 0x0359EA, '6a 0c 95 98 58 60 fe b2', 'state 0x14: test FF9598 ; bne back to dispatch 0x0358A4'),
 ('C26', 'M', 0x034A52, '6a 18 aa 30 70 40 40 20', 'bset #4,@AA30 ; bra 0x034A7A'),
 ('C27', 'M', 0x034A6A, '5e 03 58 72', 'jsr @0x035872 (skipped by the 0x034A52 entry)'),
 ('C28', 'M', 0x034A7A, '54 70', 'rts (bra target from 0x034A58)'),
 ('C29', 'M', 0x073E58, '6a 0c 94 c0 ac 01 46 4e', "'@' refuses unless FF94C0 == 1"),
 ('C30', 'M', 0x0744B2, '00 07 3e 58', 'table 0x074472 slot 0x10 -> sub_73E58'),
 ('C31', 'M', 0x073A6A, '0c ac fd 30 18 dc 6a 8c 97 fc', 'index = byte - 0x30 ; mov.b r4l,@FF97FC (073A70)'),
 ('C32', 'M', 0x0475EC, '00 04 80 2e 00 04 81 1e', 'SUB->MAIN state table 0x0475C8 slot 9 = 0x04802E, slot 0xA = 0x04811E'),
 ('C33', 'M', 0x04803C, 'aa e4', 'sub_4802E re-sync: cmp.b #0xE4,r2l'),
 ('C34', 'M', 0x04812C, 'aa e6', 'sub_4811E re-sync: cmp.b #0xE6,r2l'),
 ('C35', 'M', 0x026634, '79 24 f8 01', 'ladder compare cmp.w #0xF801,r4'),
 ('C36', 'M', 0x02653C, '79 24 f3 c3', 'ladder compare cmp.w #0xF3C3,r4'),
 ('C37', 'M', 0x0767BC, '54 13 01 20 6d f4', 'rts/l er2-er3 (0767BC, decoder) then stm.l er4-er6,@-sp (0767BE)'),
 ('C38', 'M', 0x034BDC, 'fc 32 6a 8c 95 79', 'FF9579 = 0x32 (500 ms per element)'),
 ('C39', 'M', 0x067FEE, 'fc 1e 6a 8c b0 b9', 'B0B9 = 0x1E'),
 ('C40', 'M', 0x0113E4, '00 06 64 c2', 'key-table slot -> sub_664C2'),
 ('C41', 'M', 0x010982, '5d 60', 'jsr @er6 in sub_1079E (key dispatcher)'),
 ('C42', 'M', 0x00FC66, '2a 4e ea 80', 'PTT: mov.b @0x4E:8,r2l ; and.b #0x80,r2l'),
 ('C43', 'M', 0x00FC90, 'aa 00 46 06', 'state 0 advances when r2l == 0'),
 ('C44', 'M', 0x00FC9C, 'aa 00 47 3a', 'state 1 emits the press only when r2l != 0'),
 ('C45', 'M', 0x035BBA, 'ac eb 45 54 ac ef 45 1c ac f4 45 20', 'AN1 thresholds 0xEB / 0xEF / 0xF4'),
 ('C46', 'M', 0x035BD2, '5e 03 4f 74 fc 01 6a 8c aa d9', 'jsr sub_34F74 (TX end) ; AAD9 = 1'),
]


# ------------------------------------------------------------------ computed checks
def x_ff956d():
    hits = even_hits(lambda i: C[i] == 0x6A and (C[i + 1] >> 4) == 8 and C[i + 2:i + 4] == b'\x95\x6d')
    w = even_hits(lambda i: C[i] == 0x6B and (C[i + 1] >> 4) in (8, 0xA) and C[i + 2:i + 4] == b'\x95\x6d')
    a32 = even_hits(lambda i: C[i] in (0x6A, 0x6B) and (C[i + 1] >> 4) == 0xA and C[i + 2:i + 6] == b'\x00\xff\x95\x6d')
    want = [0x02F622, 0x03111E, 0x0341E4, 0x03421A, 0x03429A, 0x0342BE, 0x0342D2, 0x034316, 0x03433A, 0x034860, 0x039436]
    pre = all(C[h - 2:h] == b'\xfc\x02' for h in hits)
    ok = hits == want and pre and not w and not a32
    return ok, 'abs16 mov.b stores to FF956D: %d (%s); each preceded by fc 02: %s; word/abs32 stores: %d/%d' % (
        len(hits), ' '.join('%06X' % h for h in hits), pre, len(w), len(a32))


def x_b0cc():
    a16 = even_hits(lambda i: C[i] in (0x6A, 0x6B) and (C[i + 1] >> 4) not in (0x2, 0xA) and C[i + 2:i + 4] == b'\xb0\xcc')
    a32 = even_hits(lambda i: C[i] in (0x6A, 0x6B) and (C[i + 1] >> 4) in (0x2, 0xA) and C[i + 2:i + 6] == b'\x00\xff\xb0\xcc')
    allh = sorted(a16 + a32)
    want = [0x002E18, 0x0358CA, 0x035A22, 0x035EDC, 0x035F86, 0x073B3A, 0x0743BC, 0x0743C2, 0x0743CC]
    pr6 = [h for h in allh if P6[h]]
    pr4 = [h for h in allh if P4[h]]
    stores = [h for h in allh if C[h] == 0x6A and (C[h + 1] >> 4) == 8]
    ok = allh == want and len(pr4) == 8 and len(pr6) == 8 and 0x035F86 not in pr6 and len(stores) == 4
    return ok, 'B0CC refs (abs16+abs32): %d (%s); in final4 proven %d, final6 proven %d; 0x035F86 proven6=%d; mov.b stores %d (%s)' % (
        len(allh), ' '.join('%06X' % h for h in allh), len(pr4), len(pr6), P6[0x035F86], len(stores), ' '.join('%06X' % h for h in stores))


def x_ff8010():
    hits = even_hits(lambda i: C[i] in (0x6A, 0x6B) and (C[i + 1] >> 4) not in (0x2, 0xA) and C[i + 2:i + 4] == b'\x80\x10',
                     0x034E42, 0x03F4EA + 6)
    in_fn = [h for h in hits if 0x034E42 <= h < 0x034E82 or 0x03F4A2 <= h < 0x03F4EA]
    return hits == [0x03F38E] and not in_fn, 'abs16 FF8010 refs in 0x034E42-0x03F4EA: %s; inside sub_34E42/sub_3F4A2: %d' % (
        ' '.join('%06X' % h for h in hits), len(in_fn))


def x_masksize():
    f3 = [os.path.getsize(os.path.join(ROOT, r'ida\out\main-final3', n)) for n in ('final3_proven_mask.bin', 'final3_named_mask.bin')]
    f4 = [os.path.getsize(os.path.join(ROOT, r'ida\out\main-final4', n)) for n in ('final4_proven_mask.bin', 'final4_named_mask.bin')]
    v3 = set(rdm(r'ida\out\main-final3\final3_proven_mask.bin')) | set(rdm(r'ida\out\main-final3\final3_named_mask.bin'))
    v4 = set(P4) | set(rdm(r'ida\out\main-final4\final4_named_mask.bin'))
    ok = f3 == [505684, 505684] and f4 == [1048576, 1048576] and v3 <= {0, 1} and v4 <= {0, 1}
    return ok, 'final3 proven/named sizes %s; final4 %s; values final3 %s final4 %s' % (f3, f4, sorted(v3), sorted(v4))


def x_tx_tables():
    ev = {}
    for n in (1, 4, 6, 7, 8, 9):
        t = 0x011960 + (n - 1) * 0x44
        ev[n] = struct.unpack('>I', M[t + 15 * 4:t + 16 * 4])[0]
    ok = all(ev[n] == 0x022718 for n in (1, 6, 7, 8)) and ev[4] == 0x03FFA0 and ev[9] == 0x03FFA0
    pairs = [(M[0x011038 + 2 * i], M[0x011039 + 2 * i]) for i in range(12)]
    return ok, 'event-15 slot (table+0x3C): ' + ', '.join('n=%d %06X' % (n, ev[n]) for n in sorted(ev)) + \
        '; pair table 0x011038 (code->n, 12 pairs read by the r5l=0x0C loop): ' + ' '.join('%02X>%d' % p for p in pairs)


def x_trace_ladder():
    lo, hi = 0x05A528, 0x05A5A0
    imms, i = [], lo
    while i < hi:
        if C[i] == 0xAC:
            imms.append(C[i + 1])
        i += 2
    want = [0x03, 0x05, 0x06, 0x07, 0x08, 0x09, 0x0A, 0x18, 0x1A, 0x12, 0x1D, 0x0B, 0x11, 0x19, 0x16, 0x15, 0x32, 0x31, 0x1F]
    return imms == want and 0x1C not in imms, 'sub_5A506 cmp.b #imm (ac xx) ladder 0x05A528-0x05A59F: ' + ' '.join('%02X' % v for v in imms) + '; 1C present: %s' % (0x1C in imms)


def x_b0b8():
    a16 = even_hits(lambda i: C[i] == 0x6A and (C[i + 1] >> 4) == 8 and C[i + 2:i + 4] == b'\xb0\xb8')
    a32 = even_hits(lambda i: C[i] == 0x6A and (C[i + 1] >> 4) == 0xA and C[i + 2:i + 6] == b'\x00\xff\xb0\xb8')
    return a16 == [0x05C442] and not a32, 'mov.b stores to FFB0B8: abs16 %s, abs32 %d' % (' '.join('%06X' % h for h in a16), len(a32))


def x_page_cmp():
    r = {}
    for pat in ('f801', 'f3c3'):
        r[pat] = even_hits(lambda i, p=bytes.fromhex(pat): C[i] == 0x79 and (C[i + 1] >> 4) == 2 and C[i + 2:i + 4] == p)
    ok = r['f801'] == [0x026634] and r['f3c3'] == [0x02653C]
    return ok, 'cmp.w #0xF801 sites %s; cmp.w #0xF3C3 sites %s' % (['%06X' % h for h in r['f801']], ['%06X' % h for h in r['f3c3']])


def x_ckpd():
    lo, hi = 0xFFF3A9D3 - SUBBASE, 0xFFF3AA5A - SUBBASE
    seg, v, i = S[lo:hi + 3], [], 0
    while i < len(seg) - 2:
        if seg[i] == 0x75 and seg[i + 1] == 0x51:
            v.append(seg[i + 2]); i += 3
        else:
            i += 1
    return bytes(v) == b'CKPD=200', 'SUB 75 51 imm8 (cmp #imm,r1) chain FFF3A9D3-FFF3AA5A = %r' % bytes(v)


def x_denominator():
    n = b = code = 0
    for line in open(os.path.join(ROOT, r'ida\out\recount\work\items_h1.tsv'), encoding='utf-8'):
        f = line.rstrip('\n').split('\t')
        if f[0] == 'ea':
            continue
        if f[2] == 'code':
            code += int(f[1])
            a = int(f[0], 16)
            if 0x078106 <= a <= 0x07B753:
                n += 1; b += int(f[1])
    win = 0x078546 - 0x078106
    ok = code == 388484 and (n, b) == (99, 318) and win == 1088 and 388490 + (win - b) == 389260
    return ok, 'items_h1 is_code %d (+6 = 388,490); window heads %d / %d B; window decodable %d; 388,490 + %d = %d' % (
        code, n, b, win, win - b, 388490 + win - b)


def x_doc95():
    t = open(os.path.join(DOCS, '95-service-window.md'), encoding='utf-8').read()
    hits = [k for k in ('388', 'denominator', '%') if k in t]
    return not hits, 'doc 95 text: occurrences of "388" / "denominator" / "%%": %s' % (hits or 'none')


def x_branches():
    d1 = M[0x034A59]
    t1 = 0x034A5A + (d1 - 256 if d1 > 127 else d1)
    d2 = struct.unpack('>h', M[0x0359F0:0x0359F2])[0]
    t2 = 0x0359F2 + d2
    return t1 == 0x034A7A and t2 == 0x0358A4, 'bra at 0x034A58 -> %06X; bne/16 at 0x0359EE -> %06X' % (t1, t2)



# as-written slips quoted in doc 126 itself (expected to differ from the image at the quoted address)
AS_WRITTEN = {('04B46E', 'f4 2a'), ('073E88', '5e 03 4a 52'), ('073E90', '5e 03 50 e4'), ('0743BC', 'fc 01 6a 8c b0 cc')}


def x_doc126():
    import re
    t = open(os.path.join(DOCS, '126-errata-k-l.md'), encoding='utf-8').read().split('\n')
    pat = re.compile(r'0x([0-9A-Fa-f]{6,8})`?\s+`?((?:[0-9a-f]{2} )*[0-9a-f]{2})(?![0-9a-fA-F])')
    n, bad, quoted = 0, [], 0
    for ln, line in enumerate(t, 1):
        for m in pat.finditer(line):
            a = int(m.group(1), 16)
            bs = bytes.fromhex(m.group(2).replace(' ', ''))
            img = 'S' if a >= SUBBASE else 'M'
            if img == 'M' and a >= 0x80000:
                continue
            n += 1
            if rd(img, a, len(bs)) == bs:
                continue
            if (m.group(1).upper()[-6:], m.group(2)) in AS_WRITTEN:
                quoted += 1
                continue
            bad.append('l.%d %s %s' % (ln, m.group(1), m.group(2)))
    return not bad, 'doc 126 inline ADDR+bytes citations: %d scanned, %d quoted as-written slips, mismatches: %s' % (n, quoted, bad or 'none')


COMPUTED = [('X01', x_ff956d, 'M whole content: FF956D writers'),
            ('X02', x_b0cc, 'M whole content: B0CC references'),
            ('X03', x_ff8010, 'M 0x034E42-0x03F4EA: FF8010 references'),
            ('X04', x_masksize, 'mask file sizes / values main-final3 vs main-final4'),
            ('X05', x_tx_tables, 'M TX-time tables 0x011960 event 15, n = 1,4,6,7,8,9'),
            ('X06', x_trace_ladder, 'M sub_5A506 trace-formatter opcode ladder'),
            ('X07', x_b0b8, 'M whole content: stores to FFB0B8'),
            ('X08', x_page_cmp, 'M whole content: page compares F801 / F3C3'),
            ('X09', x_ckpd, 'S Bluetooth line compare chain'),
            ('X10', x_denominator, 'decodable denominator re-derivation'),
            ('X11', x_doc95, 'doc 95 text search'),
            ('X12', x_branches, 'M branch targets 0x034A58 / 0x0359EE'),
            ('X13', x_doc126, 'doc 126 self-check of inline citations')]

# ------------------------------------------------------------------ errata (sections 1 and 2)
# id, section, doc, lines, quote, as_written, corrected, class, credited note, mission,
# source doc, source lines, source quote, checks, corrected MAIN addresses
ERRATA = [
 ('A01', 1, '85-touch-screens.md', '235', '`0x04B46E` `f4 2a … 6e e4 00 01`',
  '`0x04B46E` `f4 2a … 6e e4 00 01` writes `\'*\'`',
  '0x04B46A f4 2a 68 e4 6e e4 00 01: mov.b #0x2A,r4h (04B46A); mov.b r4h,@er6 (04B46C); mov.b r4h,@(1,er6) (04B46E). Two "*" stores, at 04B46C and 04B46E; the cited run starts at the immediate 04B46A',
  'address slip (-4, run cited from the store)', 'no', 'no',
  '110-ledger-reverify-k.md', '175', '| 85:235 |', ['C01'], [0x04B46A, 0x04B46C, 0x04B46E]),
 ('A02', 1, '96-market-values.md', '113', 'at `0x0020A0` (`fc 00 6a 8c 80 04`)',
  'Cold reset stores 0 to FF8004 at 0x0020A0 (fc 00 6a 8c 80 04)',
  '0x00209E fc 00 6a 8c 80 04 (mov.b #0,r4l at 00209E; mov.b r4l,@FF8004 at 0020A0). 0x0020A0 is right as a store address',
  'address slip (listing convention, -2)', 'no', 'no',
  '110-ledger-reverify-k.md', '176', '| 96:113 |', ['C02'], [0x00209E, 0x0020A0]),
 ('A03', 1, '87-dsp-payload-labels.md', '132', '`0x345AA` `cmp.b #1`',
  '0x345AA cmp.b #1',
  '0x0345AE ac 01 cmp.b #1,r4l; 0x0345AA is 6a 0c 8a a0 mov.b @FF8AA0,r4l (the load)',
  'address slip (+4, mnemonic cited at the load)', 'no', 'no',
  '110-ledger-reverify-k.md', '177', '| 87:132 | `0x345AA`', ['C03'], [0x0345AE]),
 ('A04', 1, '87-dsp-payload-labels.md', '132', '`0x34B58` `cmp.b #2`',
  '0x34B58 cmp.b #2',
  '0x034B5C ac 02 cmp.b #2,r4l; 0x034B58 is 6a 0c 8a a0 (the load)',
  'address slip (+4, mnemonic cited at the load)', 'no', 'no',
  '110-ledger-reverify-k.md', '178', '| 87:132 | `0x34B58`', ['C04'], [0x034B5C]),
 ('A05', 1, '97-tx-freq-range.md', '178', 'The following `00 06` bytes are not copied.',
  'The following 00 06 bytes are not copied.',
  'The bytes after the 16-B pair (0x00F672-0x00F681) are 0x00F682 00 00 00 00 00 06; 00 06 first at 0x00F686. "Not copied" stands (sub_3F48E copies 8 B per window)',
  'address/wording slip (+4: four 00 bytes skipped)', 'no (data table: named, not proven)', 'no (TX range unchanged)',
  '110-ledger-reverify-k.md', '179', '| 97:178 |', ['C05'], [0x00F686]),
 ('A06', 1, '90-aprs-ax25.md', '103', '`not.b r2h` (`0x04954A`)',
  'not.b r2h (0x04954A)',
  '0x04954A 0c 2b mov.b r2h,r3l ; 0x04954C 17 0b not.b r3l. Effect (~r2h sent) unchanged',
  'mnemonic slip (two instructions summarised as one)', 'no', 'no',
  '110-ledger-reverify-k.md', '185', '| 90:103 |', ['C06'], [0x04954A, 0x04954C]),
 ('A07', 1, '90-aprs-ax25.md', '104', '`not.b r2l` (`0x049556`)',
  'not.b r2l (0x049556)',
  '0x049556 0c ab mov.b r2l,r3l ; 0x049558 17 0b not.b r3l. Effect unchanged',
  'mnemonic slip (two instructions summarised as one)', 'no', 'no',
  '110-ledger-reverify-k.md', '186', '| 90:104 |', ['C07'], [0x049556, 0x049558]),
 ('A08', 1, '93-tx-gate.md', '157', 'Twelve sites',
  'Writers. Twelve sites, all storing fc 02',
  'Eleven: abs16 6a 8X 95 6d at 02F622 03111E 0341E4 03421A 03429A 0342BE 0342D2 034316 03433A 034860 039436, each preceded by fc 02; no word or abs32 store',
  'wrong count (12 -> 11)', 'no', 'no',
  '110-ledger-reverify-k.md', '214', '| 93:157 |', ['X01'], [0x02F622]),
 ('A09', 1, '93-tx-gate.md', '193', 'There are 8 references in the whole image',
  'There are 8 references in the whole image, with 4 stores',
  '9 byte-level references (002E18 0358CA 035A22 035EDC 035F86 073B3A 0743BC 0743C2 0743CC); 8 in proven code (final4 and proposed final6). 0x035F86 6a 10 b0 cc 73 00 follows bra 0x035F84 40 30 and is not proven. "4 stores" is right',
  'wrong count (scope: 8 proven / 9 byte-level)', 'no', 'no',
  '110-ledger-reverify-k.md', '215', '| 93:193 |', ['X02', 'C08'], [0x035F86]),
 ('A10', 1, '97-tx-freq-range.md', '176', '`FF8010` does not occur in `0x034E42–0x03F4EA`',
  'FF8010 does not occur in 0x034E42-0x03F4EA',
  'FF8010 occurs once in that address range: 0x03F38E 6a 04 80 10 mov.b @FF8010,r4h, outside sub_34E42 (034E42-034E81) and sub_3F4A2 (03F4A2-03F4E9). Scope the sentence to the two functions',
  'wrong count (0 -> 1; scope wording)', 'no', 'no',
  '110-ledger-reverify-k.md', '216', '| 97:176 |', ['X03', 'C09'], [0x03F38E]),
 ('A11', 1, '83-main-final4-seed.md', '200', 'same format as main-final3: 1,048,576 bytes',
  'The masks use the same format as main-final3: 1,048,576 bytes',
  'final4_*_mask.bin are 1,048,576 B; main-final3\\final3_*_mask.bin are 505,684 B (content length). Both are 0/1 per byte',
  'wording (file length)', 'no', 'no',
  '110-ledger-reverify-k.md', '143', 'One wording item. Doc 83:200', ['X04'], []),
 ('A12', 1, '93-tx-gate.md', '99', 'Event 15 there is `0x022718` in all four.',
  'Event 15 there is 0x022718 in all four.',
  'True for n = 1, 6, 7, 8. sub_10FA8 also selects n = 4 (AAD1 & 0x0C) and n = 9 (AAD3 & 0x0F, or AAD4 & 0x01 - new here), and both tables hold 0x03FFA0 (the default slot value) at event 15',
  'scope note (incomplete case list)', 'no', 'no (PTT release under modes 4/9 is Open)',
  '110-ledger-reverify-k.md', '218', 'Scope note, not graded as an error (93:99)', ['X05', 'C10'], [0x011006]),
 ('B01', 2, '104-pdn-node-table.md', '164', '`0x073E88 5e 03 4a 52`',
  '0x073E88 5e 03 4a 52 (jsr sub_34A52)',
  '0x073E86 5e 03 4a 52 jsr @0x034A52; 0x073E88 is the operand half (4a 52), and 0x073E8A is fc 01',
  'address slip (+2)', 'no', 'no',
  'RESUME-FULL.md', '97', '`5e 03 4a 52` is at `0x073E86`', ['C11'], [0x073E86]),
 ('B02', 2, '104-pdn-node-table.md', '164', '`0x073E90 5e 03 50 e4`',
  '0x073E90 5e 03 50 e4 (jsr sub_350E4)',
  '0x073E8E 5e 03 50 e4 jsr @0x0350E4; 0x073E90 is the operand half (50 e4)',
  'address slip (+2)', 'no', 'no',
  'RESUME-FULL.md', '97', '`5e 03 50 e4` at `0x073E8E`', ['C11'], [0x073E8E]),
 ('B03', 2, '104-pdn-node-table.md', '28', '`0x073E88 jsr sub_34A52 → sub_35872`',
  '0x073E88 jsr sub_34A52 -> sub_35872',
  '0x073E86 jsr @0x034A52 (same slip as B01, not in RESUME); the "-> sub_35872" part is superseded by doc 105 (index I08)',
  'address slip (+2) - new', 'no', 'no',
  'RESUME-FULL.md', '97', '`5e 03 4a 52` is at `0x073E86`', ['C11', 'C26', 'C27'], [0x073E86]),
 ('B04', 2, '104-pdn-node-table.md', '99', '(`0x073A28`–`0x073A3C`)',
  'mov.b @FF97FC, r3l ; shll.l #2 ; mov.l @(off_74472, er3), er6 ; jsr @er6 (0x073A28-0x073A3C)',
  'Correct as written: the range spans 073A28 (load index) to 073A3C (jsr @er6), and the table load is 0x073A34 78 b0 6b 26 00 07 44 72 (8 B). No standalone mis-cited load address exists in doc 104 or in ida\\out\\pdn-node-table (writers.tsv row 6 gives 073A34). The only mis-cite of this instruction in docs\\deep is doc 93:64 (B05)',
  'no slip in the owning doc (RESUME note matches the image)', 'no', 'no',
  'RESUME-FULL.md', '97', 'the table load at `0x073A34`', ['C12'], [0x073A34]),
 ('B05', 2, '93-tx-gate.md', '64', 'The command dispatcher `0x073A36`',
  'The command dispatcher 0x073A36',
  '0x073A34 78 b0 6b 26 00 07 44 72 mov.l @(0x074472,er3),er6 (the indexed load), then 0x073A3C 5d 60 jsr @er6; 0x073A36 is inside the 8-byte load (decodes as a bogus mov.w @0x74472:32,r6). Dispatcher routine is sub_739FA (0x0739FA)',
  'address slip (+2, mid-instruction) - new (K-wave doc, not graded by L13)', 'no', 'no',
  'n/a (new in this lane)', '', '', ['C12'], [0x073A34]),
 ('B06', 2, '106-dsp-1c03-leftovers.md', '130', '`0x0743BC fc 01 6a 8c b0 cc`',
  '(0x0743BC fc 01 6a 8c b0 cc)',
  '0x0743BA fc 01 6a 8c b0 cc (store at 0x0743BC). l.131 "0x0743CC" (arg 0) is a store address with no bytes and is right (0x0743CA fc 00 / 0x0743CC 6a 8c b0 cc)',
  'address slip (listing convention, +2)', 'no', 'no',
  'RESUME-FULL.md', '117', '`fc 01` at `0x0743BA`', ['C13', 'C14'], [0x0743BA, 0x0743BC]),
 ('B07', 2, '106-dsp-1c03-leftovers.md', '153', '`0x030242`',
  '(0x030242/0x031CD4 fc 05 6a 8c aa ce) - band A',
  '0x030240 fc 05 6a 8c aa ce (store at 0x030242)',
  'address slip (listing convention, +2)', 'no', 'no',
  'RESUME-FULL.md', '117', '`fc 05 6a 8c aa ce` at `0x030240`', ['C15'], [0x030240]),
 ('B08', 2, '106-dsp-1c03-leftovers.md', '153', '`0x031CD4`',
  '(0x030242/0x031CD4 fc 05 6a 8c aa ce) - band B',
  '0x031CD2 fc 05 6a 8c aa ce (store at 0x031CD4)',
  'address slip (listing convention, +2)', 'no', 'no',
  'RESUME-FULL.md', '117', 'and `0x031CD2`', ['C16'], [0x031CD2]),
 ('B09', 2, r'ida\out\dsp-1c03\opcode-1c.tsv', '39', '0743BC\tfc 01 6a 8c b0 cc',
  '0743BC fc 01 6a 8c b0 cc (lane table)',
  '0743BA fc 01 6a 8c b0 cc (same as B06)',
  'address slip (+2), lane table - new', 'no', 'no',
  'RESUME-FULL.md', '117', '`fc 01` at `0x0743BA`', ['C13'], [0x0743BA]),
]

# ------------------------------------------------------------------ index of L-wave corrections (section 3)
# id, old doc, old lines, old quote, superseded statement, now, sup doc, sup lines, sup quote, lane, anchors
INDEX = [
 ('I01', '06-dsp-vocoder.md', '278', '| `0x1C` | **DATA TEXT SET**, byte 1 from `0xFFB0B8`',
  'CPU->DSP opcode 0x1C = DATA TEXT SET', '"DATA TEXT SET" is DSP->MAIN event 0x9C (doc 06 l.291 itself); the CPU->DSP trace formatter sub_5A506 has no 0x1C case',
  '106-dsp-1c03-leftovers.md', '137-141', 'is the name of the DSP→MAIN **event `0x9C`**', 'L9', ['C17', 'C18', 'X06']),
 ('I02', '93-tx-gate.md', '205-206', 'trace label "DATA TEXT SET", doc 06',
  'opcode 1C trace label "DATA TEXT SET"', 'as I01',
  '106-dsp-1c03-leftovers.md', '137-141', 'doc 06 / K11 attached to opcode `1C`', 'L9', ['C17', 'X06']),
 ('I03', '14-bluetooth-gps-wiresx.md', '32;239-240;260', 'which are audio level/error controls',
  'TXAT/RXAT/ERAT are audio level/error controls', 'RXAT= carries an AT command from the headset (e.g. RXAT=CKPD=200); TXAT=1 enables that pass-through (Inferred in doc 107)',
  '107-accessory-ptt.md', '204-207', '`TXAT`/`RXAT` are not attenuation levels.', 'L10', ['C19', 'C20', 'C21', 'X09']),
 ('I04', '51-sub-link-layer.md', '24;95', '`0xFFFE` frame/block checksum',
  'a frame-checksum error replies status 0xFFFE', 'the reply payload on a frame-checksum error is the block number (frame +6..+7); 0xFFFE only for the 32-bit-sum and picture-step cases',
  '109-sub-frames-sub.md', '216-217', '**block number**, not `0xFFFE`', 'L12', ['C22', 'C23']),
 ('I05', '57-dsp-session-scripts.md', '343', '`[2]` from `FF8E2B`–`FF8E2D` only for `B0B8` 9/`0x0D`',
  '1C sub-ops 9/0x0D carry [2] from FF8E2B-2D (implied live)', 'one B0B8 store in the image (0x05C442, constant 3): sub-ops 9 and 0x0D are dead',
  '106-dsp-1c03-leftovers.md', '101-102', 'only live value; `9` and `0x0D` are decode-only paths with no writer', 'L9', ['C24', 'X07']),
 ('I06', '57-dsp-session-scripts.md', '682', 'so a press while busy is refused, not queued',
  'AAD5 = 0x14: a press while busy is refused', 'state 0x14 retries the dispatch for FF9598 = 0x1F (3.0-3.1 s) and refuses only on expiry',
  '105-tx-states.md', '378-380', '(3.0–3.1 s), and refuses only on expiry', 'L8', ['C25', 'X12']),
 ('I07', '77-dsp-tx-sources.md', '27-28', 'calls the same',
  "host command 0x11 calls sub_34A52 -> sub_35872, so the PC can key the radio", "'@' arg 0x11 enters 0x034A52 = bset AA30.b4 ; bra rts; the jsr sub_35872 at 0x034A6A is skipped; '@' refuses unless FF94C0 == 1 (already keyed)",
  '105-tx-states.md', '381-385', '`6a 18 aa 30 70 40 40 20` (`bset AA30.b4 ; bra rts`)', 'L8', ['C26', 'C27', 'C28', 'C29', 'X12']),
 ('I08', '104-pdn-node-table.md', '28;160', 'sub_34A52 → sub_35872',
  "L7: '@' arg 0x11 -> jsr sub_34A52 -> sub_35872 (DSP TX-start)", 'as I07 (L8 corrects L7 in the same wave)',
  '105-tx-states.md', '63-64', "**Node command `'@'` arg `0x11` does not key the radio**", 'L8', ['C11', 'C26', 'C27', 'C28']),
 ('I09', '77-dsp-tx-sources.md', '27', 'host command byte `0x11`',
  'sub_73E58 = host command 0x11', "sub_73E58 = slot 0x10 ('@', 0x40 - 0x30); 0x11 is '@''s argument byte",
  '104-pdn-node-table.md', '25-29', 'is table slot 0x10', 'L7', ['C30', 'C31']),
 ('I10', '93-tx-gate.md', '230-232', 'This may only be a numbering-basis',
  'slot 0x10 vs 0x11 basis not settled', 'settled: slot 0x10; index = byte - 0x30 (single writer 0x073A70)',
  '104-pdn-node-table.md', '25-29', 'The slot 0x10 vs 0x11 question is settled', 'L7', ['C30', 'C31']),
 ('I11', '84-touch-producer.md', '189;191', '| `E4` | 9 | `sub_4811E` | 0x29 |',
  'E4 handler sub_4811E, E6 handler sub_4802E', 'swapped: E4 (state 9) = sub_4802E, E6 (state 0xA) = sub_4811E; states and lengths were right',
  '108-sub-frames-main.md', '81-85', '**E4 (state 9) = `sub_4802E`**', 'L10/L11', ['C32', 'C33', 'C34']),
 ('I12', '85-touch-screens.md', '118-119', '**195 of 511 zones are',
  '195 of 511 zones pending (not joined)', '154 joined; 41 can never fire (38 on pages F801/F3C3 that MAIN never sends, 3 trailer records)',
  '103-home-keytable.md', '32-36', '**The other 41 can never fire**', 'L6', ['C35', 'C36', 'X08']),
 ('I13', '85-touch-screens.md', '104', 'I ran a depth-bounded descent (D = 1…4)',
  'K3 descent (terminators only rts/rte)', 'rts/l, rte/l and sleep also end a function; without them the descent falls into the next function',
  '103-home-keytable.md', '77-78', 'K3 treated only `rts`/`rte` as ends', 'L6', ['C37']),
 ('I14', '86-dsp-autoreply.md', '243', '- Length of the T4 carrier.',
  'T4 carrier length open', 'AACE (5) x FF9579 (0x32 x 10 ms) = about 2.5 s',
  '106-dsp-1c03-leftovers.md', '167', '≈ 2.5 s', 'L9 (L8 doc 105 l.391 concurs)', ['C38', 'C15', 'C16']),
 ('I15', '86-dsp-autoreply.md', '212;244', 'caller not traced',
  'B0B9 = 0x1E caller not traced', 'keypress: sub_664C2 <- key-table slot 0x0113E4 <- jsr @er6 0x010982 in key dispatcher sub_1079E',
  '106-dsp-1c03-leftovers.md', '190-191', 'a keypress action on a WIRES-X screen', 'L9', ['C39', 'C40', 'C41']),
 ('I16', '93-tx-gate.md', '15', '(active low)',
  'PTT 0xFFFF4E b7 active low', 'at register level bit 7 set = pressed; "active low" can only describe the pin (Unknown)',
  '112-c-reconstruction.md', '131-137', '**bit7 = 1 as pressed**', 'L15', ['C42', 'C43', 'C44']),
 ('I17', '93-tx-gate.md', '74;115', 'which link is Unknown',
  'serial-frame PTT at FF9800: accessory and link Unknown', 'FF9800 is the SUB->MAIN SCI_6 frame buffer; the PTT is frame E6, sent by SUB for a Bluetooth headset button (RXAT=CKPD=200)',
  '107-accessory-ptt.md', '5-12', 'frame type `0xE6`', 'L10', ['C34', 'C32', 'X09']),
 ('I18', '93-tx-gate.md', '221', '**Battery, temperature, ADC:** **Not found**',
  'no battery/temperature/ADC gate in the routines read', 'AN1 power foldback and cutoff in sub_35BAA (outside K11 scope)',
  '105-tx-states.md', '388-390', 'samples AN1 and folds back or cuts TX', 'L8', ['C45', 'C46']),
 ('I19', '93-tx-gate.md', '157', 'Twelve sites',
  'Twelve FF956D writers', 'Eleven (section 1 row A08)',
  '110-ledger-reverify-k.md', '214', '**11** abs16 stores', 'L13', ['X01']),
 ('I20', 'RESUME-FULL.md', '265', '94.81% of 388,490 decodable',
  'decodable denominator 388,490 (doc 95 has no such statement: X11)', '388,490 counted 318 of the window\'s 1,088 decodable bytes; consistent denominator 389,260',
  '98-main-final5-seed.md', '140-144', '**consistent denominator = 389,260**', 'L1', ['X10', 'X11']),
]


def doc_lines(path):
    if os.path.isabs(path):
        p = path
    elif path.startswith('ida'):
        p = os.path.join(ROOT, path)
    else:
        p = os.path.join(DOCS, path)
    return open(p, encoding='utf-8').read().split('\n')


def expand(spec):
    out = []
    for part in spec.split(';'):
        if '-' in part:
            a, b = part.split('-')
            out += list(range(int(a), int(b) + 1))
        else:
            out.append(int(part))
    return out


def quote_ok(path, spec, quote):
    if not spec:
        return 'n/a'
    L = doc_lines(path)
    lines = expand(spec)
    joined = '\n'.join(L[i - 1] for i in lines)
    flat = ' '.join(L[i - 1].strip() for i in lines)
    return 'PASS' if (quote in joined or quote in flat) else 'FAIL'


def mask_at(addrs):
    return ','.join('%06X P6=%d N6=%d P4=%d' % (a, P6[a], N6[a], P4[a]) for a in addrs) or 'n/a'


def main():
    res = {}
    rows = ['id\timage\taddr\tfile_off\texpected\tactual\tresult\tmeaning']
    for cid, img, a, exp, what in CHECKS:
        e = bytes.fromhex(exp.replace(' ', ''))
        act = rd(img, a, len(e))
        ok = act == e
        res[cid] = ok
        off = a if img == 'M' else a - SUBBASE
        rows.append('\t'.join([cid, img, ('%06X' % a) if img == 'M' else ('%08X' % a), '0x%06X' % off,
                               H(e), H(act), 'PASS' if ok else 'FAIL', what]))
    for cid, fn, what in COMPUTED:
        ok, det = fn()
        res[cid] = ok
        rows.append('\t'.join([cid, '', '', '', what, det, 'PASS' if ok else 'FAIL', 'computed']))
    open(os.path.join(OUT, 'bytecheck.tsv'), 'w', encoding='utf-8', newline='\n').write('\n'.join(rows) + '\n')

    er = ['id\tsection\tdoc\tline\tas_written\tcorrected\tclass\tcredited_byte_affected\tmission_answer_affected\t'
          'evidence\tmask_at_corrected (P6/N6 = proposed final6, P4 = final4)\tsource\tsource_text_check\tdoc_text_check']
    for (eid, sec, doc, line, quote, asw, cor, cls, cred, miss, sdoc, sline, squote, cks, addrs) in ERRATA:
        tq = quote_ok(doc, line, quote)
        sq = quote_ok(sdoc, sline, squote) if sline else 'n/a'
        ev = ' '.join('%s:%s' % (c, 'PASS' if res[c] else 'FAIL') for c in cks)
        loc = ('proven code' if any(P6[a] for a in addrs) else ('named only' if any(N6[a] for a in addrs) else 'outside masks')) if addrs else 'n/a'
        cred2 = 'NO mask change (location: %s). %s' % (loc, cred)
        src = '%s:%s' % (sdoc, sline) if sline else sdoc
        er.append('\t'.join([eid, str(sec), doc, line, asw, cor, cls, cred2, miss, ev, mask_at(addrs), src, sq, tq]))
    open(os.path.join(OUT, 'errata.tsv'), 'w', encoding='utf-8', newline='\n').write('\n'.join(er) + '\n')

    ix = ['id\told_doc\told_lines\tsuperseded\tnow\tsuperseding_doc\tsuperseding_lines\tlane\tanchors\told_text_check\tsuperseding_text_check']
    for (iid, od, ol, oq, sup, now, sd, sl, sq, lane, anc) in INDEX:
        a = quote_ok(od, ol, oq)
        b = quote_ok(sd, sl, sq)
        ev = ' '.join('%s:%s' % (c, 'PASS' if res[c] else 'FAIL') for c in anc)
        ix.append('\t'.join([iid, od, ol, sup, now, sd, sl, lane, ev, a, b]))
    open(os.path.join(OUT, 'index.tsv'), 'w', encoding='utf-8', newline='\n').write('\n'.join(ix) + '\n')

    h = lambda p: hashlib.sha256(open(p, 'rb').read()).hexdigest()
    nt = sum(1 for r in er[1:] if r.endswith('\tPASS'))
    ns = sum(1 for r in er[1:] if r.split('\t')[-2] == 'PASS')
    ns_n = sum(1 for r in er[1:] if r.split('\t')[-2] != 'n/a')
    ni = sum(r.split('\t')[-2:].count('PASS') for r in ix[1:])
    sys.exit("The firmware image is not in this repository.")
    for r in rows[1:]:
        if '\tFAIL\t' in r:
            summ.append('FAILED CHECK: ' + r[:200])
    for r in er[1:] + ix[1:]:
        if '\tFAIL' in r or ':FAIL' in r:
            summ.append('ROW ISSUE: ' + r[:200])
    open(os.path.join(OUT, 'run.txt'), 'w', encoding='utf-8', newline='\n').write('\n'.join(summ) + '\n')
    print('\n'.join(summ))


if __name__ == '__main__':
    main()
