# L14 errata check. Read-only: reads the two decrypted images, the final4 / SUB masks and
# the owning docs; writes only into ida\out\errata-j\. No IDA, no device access.
import sys
from pathlib import Path as _Path
_REPO_S = _Path(__file__).resolve().parents[3].as_posix()
import hashlib, os, struct

ROOT = _REPO_S
OUT = os.path.join(ROOT, r'ida\out\errata-j')
DOCS = os.path.join(ROOT, r'docs\deep')
sys.exit("The firmware image is not in this repository.")
sys.exit("The firmware image is not in this repository.")
PROVEN = open(os.path.join(ROOT, r'ida\out\main-final4\final4_proven_mask.bin'), 'rb').read()
NAMED = open(os.path.join(ROOT, r'ida\out\main-final4\final4_named_mask.bin'), 'rb').read()
SUBHL = open(os.path.join(ROOT, r'ida\out\sub-final3\raw\mask_final3_after_headline_w2.bin'), 'rb').read()
SUBALL = open(os.path.join(ROOT, r'ida\out\sub-final3\raw\mask_final3_after_allwf.bin'), 'rb').read()
SUBWIN = 0xFFED0000
SUBBASE = 0xFFC00000

H = lambda b: ' '.join('%02x' % x for x in b)


def rd(img, addr, n):
    if img == 'M':
        return M[addr:addr + n]
    return S[addr - SUBBASE:addr - SUBBASE + n]


def fmt(img, a):
    return ('%06X' % a) if img == 'M' else ('%08X' % a)


# ---------------------------------------------------------------- byte checks
# (id, image, mapped address, expected bytes, meaning)
CHECKS = [
 ('C01', 'M', 0x04E312, '7a 01 00 ff b0 67', 'mov.l #0xFFB067,er1'),
 ('C02', 'M', 0x04E318, '5e 05 27 80', 'jsr @0x052780'),
 ('C03', 'M', 0x04E31C, '54 70', 'rts (J2 extent end)'),
 ('C04', 'M', 0x026F42, '6f 53 00 08 4b 1e', 'mov.w @(8,er5),r3 ; bmi'),
 ('C05', 'M', 0x026F48, '6b 83 bb c2', 'mov.w r3,@0xFFBBC2'),
 ('C06', 'M', 0x026F3C, '6b 84 bb c2', 'mov.w r4,@0xFFBBC2 (no-zone, cited correctly)'),
 ('C07', 'M', 0x026F6A, '6b 84 bb c2', 'mov.w r4,@0xFFBBC2 (negative idx, cited correctly)'),
 ('C08', 'M', 0x02B3A8, '7a 06 00 02 b3 c2 5a 02 86 16', 'mov.l #0x02B3C2,er6 ; jmp @0x028616'),
 ('C09', 'M', 0x02B3C0, '54 70', 'rts ending the code before the table'),
 ('C10', 'M', 0x02B3C2, '00 02 b3 b2 00 02 b3 b2 00 02 b3 b2 00 02 b3 b2 00 02 b3 b2', 'table slots 0-4 = 0x02B3B2'),
 ('C11', 'M', 0x02B3D6, '00 06 5e fa', 'table slot 5 = 0x065EFA'),
 ('C12', 'M', 0x02B3DA, '00 06 5f 00', 'table slot 6 = 0x065F00'),
 ('C13', 'M', 0x02B3DE, '00 06 5f 06', 'table slot 7 = 0x065F06'),
 ('C14', 'M', 0x02B3E2, '7a 06 00 02 b4 1a', 'code after the table (mov.l #0x02B41A,er6)'),
 ('C15', 'M', 0x028616, '6b 04 bb c2 79 24 00 09', 'helper: mov.w @0xFFBBC2,r4 ; cmp.w #9,r4'),
 ('C16', 'M', 0x028630, '5d 60', 'helper: jsr @er6'),
 ('C17', 'M', 0x07433E, '79 04 5a 03 6b 84 96 f8', 'mov.w #0x5A03,r4 ; mov.w r4,@0xFF96F8'),
 ('C18', 'M', 0x074340, '5a 03 6b 84', 'false abs24 match = jmp @0x036B84 (5A = jmp)'),
 ('C19', 'M', 0x036B84, '1d 1d 1d 1d 1d 1d 1d 1d 1d 1d 1e 1e', 'false target is a byte ramp'),
 ('C20', 'M', 0x054F12, 'f4 01 fc 00 0d 4c 79 04 ff ff 01 00 6b 84 81 84',
  'mov.b #1,r4h; mov.b #0,r4l; mov.w r4,e4; mov.w #0xFFFF,r4; mov.l er4,@0xFF8184'),
 ('C21', 'M', 0x056012, 'f4 01 fc 00 0d 4c 79 04 ff ff 01 00 6b 84 81 84', 'same sequence, second writer'),
 ('C22', 'M', 0x05548E, 'fc 4f 6a 8c aa e0 fc 01 6a 8c 81 84 fc 08 6a 8c 81 83',
  'mov.b #0x4F; ->@FFAAE0 ; mov.b #1; ->@FF8184 ; mov.b #8,r4l (05549A); ->@FF8183 (05549C)'),
 ('C23', 'M', 0x038672, 'fc 00 6a 8c aa e8', 'mov.b #0,r4l (038672) ; mov.b r4l,@0xFFAAE8 (038674)'),
 ('C24', 'M', 0x0001B8, '00 00 2a 30', 'vector 110 -> 0x002A30'),
 ('C25', 'M', 0x002A30, '6d f4 6a 18 fe f5 72 00', 'push.w r4 ; bclr #0,@0xFFFEF5'),
 ('C26', 'M', 0x002A50, '6a 0c 94 ba 47 06 1a 0c 6a 8c 94 ba 6d 74 56 70',
  'FF94BA countdown ; pop.w r4 (002A5C) ; rte (002A5E)'),
 ('C27', 'M', 0x056772, '79 04 00 00 3c f0 6b 84 ff f6', 'restart 1: mov.w #0,r4 ; mov.b r4l,@0xF0:8 (056776) ; mov.w r4,@0xFFF6'),
 ('C28', 'M', 0x056822, '79 04 00 00 3c f0 6b 84 ff f6', 'restart 2 (3c f0 at 056826)'),
 ('C29', 'M', 0x05694C, '79 04 00 00 3c f0 6b 84 ff f6', 'restart 3 (3c f0 at 056950)'),
 ('C30', 'M', 0x05B8A8, '6b 0c ff f6 79 2c 89 80', 'mov.w @0xFFF6:16,e4 ; cmp.w #0x8980,e4'),
 ('C31', 'M', 0x0563CE, '6a 0b b0 be 7a 63 00 00 00 ff 10 73 78 b0 6b 26 00 05 b3 10 5d 60',
  'r3l = B0BE ; indexed load from 0x05B310 ; jsr @er6'),
 ('C32', 'M', 0x05B364, '00 05 c3 f4', '0x05B310 + 0x15*4 -> 0x05C3F4'),
 ('C33', 'M', 0x05C3F4, '6a 0b b0 bf 7a 63 00 00 00 ff 10 73 78 b0 6b 26 00 05 c4 0a 59 60',
  'r3l = B0BF (step) ; indexed load from 0x05C40A ; jmp @er6'),
 ('C34', 'M', 0x05C41A, '00 05 c4 36', 'step table slot 4 -> 0x05C436'),
 ('C35', 'M', 0x05C436, '6a 0c b0 a4 4a 2a 73 3c 46 26 fc 03 6a 8c b0 b8 5e 05 a0 40',
  'step 4: test B0A4 ; mov.b #3,r4l ; ->@FFB0B8 ; jsr @0x05A040'),
 ('C36', 'M', 0x05A040, '7a 04 00 00 00 00 7a 05 00 ff b1 3e' + ' 01 00 69 d4 0b 95' * 8 +
  ' f3 1c 6a 0b b0 b8 6b 83 b1 3e',
  'er4=0 ; er5=0xFFB13E ; 8x(mov.l er4,@er5; adds #4) = 32 B cleared ; r3h=0x1C ; r3l=[B0B8] ; mov.w r3,@0xFFB13E'),
 ('C37', 'M', 0x05A32E, 'fc 15 6a 8c b0 b7', 'sub_5A2F8: B0B7 = 0x15'),
 ('C38', 'M', 0x05A3A0, '6a 0c b0 b7 6a 8c b0 be', 'B0BE := B0B7'),
 ('C39', 'M', 0x019352, '79 01 00 a9 5a 03 cc bc 79 01 00 aa 5a 03 cc bc 79 01 00 ac',
  'stubs n=0xA9 (019352), n=0xAA (01935A: mov.w #0xAA,r1 ; jmp @0x03CCBC at 01935E), n=0xAC'),
 ('C40', 'M', 0x00CE1E, '6a 0b 89 cb 7a 63 00 00 00 ff 78 30 6a 2b 00 00 ce 40 01 00 6b 06 bc 2c 7a 16 00 00 00 3e 68 eb 54 70',
  'r3l=[FF89CB] ; r3l=[0xCE40+er3] ; er6=[FFBC2C]+0x3E ; mov.b r3l,@er6 ; rts'),
 ('C41', 'M', 0x00CE40, '02 03 04 05 06 07 08 09 0a 01 0f 00', 'dial table, 12 B'),
 ('C42', 'M', 0x00CE4C, '6a 0c 94 c1', 'code resumes after the table'),
 # K-wave index anchors
 ('K01', 'M', 0x04ACF4, '00 04 e2 d6', '0x04ABE4 slot 68 -> 0x04E2D6'),
 ('K02', 'M', 0x02639C, '01 00 6b 02 bb d4 79 24 f0 03', 'ladder: mov.l @0xFFBBD4:16,er2 (02639C) ; first compare cmp.w #0xF003,r4 (0263A2)'),
 ('K03', 'M', 0x00FC66, '2a 4e ea 80', 'PTT: mov.b @0x4E:8,r2l ; and.b #0x80,r2l'),
 ('K04', 'M', 0x03497C, '6a 0c 95 6d', 'mov.b @0xFF956D,r4l (settle, not TOT)'),
 ('K05', 'M', 0x034984, '7e 4d 73 30', 'btst #3,@0x4D:8 (interlock, not PTT)'),
 ('K06', 'M', 0x005AAE, '79 0b f3 a3 6a 0b 8a a0', 'F3A3 notifier sends [FF8AA0] (APRS MODEM)'),
 ('K07', 'M', 0x034A5A, '6a 18 a4 f0 70 60', 'bset #6,@0xFFA4F0 (APRS TX)'),
 ('K08', 'M', 0x034A62, '6a 18 a4 f0 70 70', 'bset #7,@0xFFA4F0 (APRS TX)'),
 ('K09', 'M', 0x0743BA, 'fc 01 6a 8c b0 cc', "remote ']' arg 1: B0CC = 1"),
 ('K10', 'M', 0x0743CA, 'fc 00 6a 8c b0 cc', "remote ']' arg 0: B0CC = 0"),
 ('K11', 'M', 0x0744B2, '00 07 3e 58', 'table 0x074472 slot 0x10 -> 0x073E58'),
 ('K12', 'M', 0x06D08A, 'fc 17 6a 8c b0 b7 6a 8c b0 be', 'sub_6D052: B0B7 = B0BE = 0x17'),
 ('K13', 'S', 0xFFF2A6F7, '39 14 00', 'bsr.w -> FFF2A70B (separate subroutine)'),
 ('K14', 'S', 0xFFED7F50, 'ff f0 ff 00 ff f1 ff 00 ff f2 ff 00 ff f3 ff 00', 'mask table entries 14-17 = CMD6 args 0x00FFF0FF..0x00FFF3FF'),
]

# computed checks
def chk_ramps():
    a, n = 0x0376C8, 152
    b = M[a:a + n]
    runs, start = [], 0
    for i in range(1, n + 1):
        if i == n or b[i] < b[i - 1]:
            runs.append((a + start, a + i - 1, i - start, b[start], b[i - 1]))
            start = i
    want = [(0x0376C8, 0x0376F9, 50, 0x11, 0x1A), (0x0376FA, 0x03772B, 50, 0x11, 0x19),
            (0x03772C, 0x03775F, 52, 0x0F, 0x5B)]
    det = '; '.join('%06X-%06X %dB %02x..%02x' % r for r in runs)
    return runs == want, det


FONT_WANT = {  # idx: (w, h, base) for the blocks the prose gets wrong or right
    0: (14, 14, 0x9321), 1: (14, 14, 0x5021), 2: (14, 14, 0x2121), 3: (7, 14, 0x0020),
    4: (14, 14, 0x2D21), 5: (14, 14, 0x2124), 6: (14, 14, 0x7921), 7: (14, 14, 0x2122),
    8: (14, 14, 0x2121), 9: (14, 27, 0x0020), 11: (10, 9, 0x0023), 18: (5, 14, 0x002E), 25: (4, 7, 0x0020)}


def chk_font():
    base = 0xFFED4644
    recs = [rd('S', base + 12 * i, 12) for i in range(26)]
    ok = True
    dec = []
    for i, r in enumerate(recs):
        w, h, bc, ordt, pix = struct.unpack('<BBHII', r)
        dec.append((w, h, bc))
        if i in FONT_WANT and FONT_WANT[i] != (w, h, bc):
            ok = False
    others = [i for i in range(9, 26) if dec[i][2] != 0x20]
    ok = ok and others == [11, 18] and recs[8] == recs[2]
    det = 'blk3=%dx%d base %04X; blocks 9-25 with base!=0x0020: %s; blk8==blk2 (12 B): %s; blk9 %dx%d, blk25 %dx%d' % (
        dec[3][0], dec[3][1], dec[3][2], others, recs[8] == recs[2], dec[9][0], dec[9][1], dec[25][0], dec[25][1])
    return ok, det


def chk_step_table():
    t = [struct.unpack('>I', M[0x05C40A + 4 * i:0x05C40E + 4 * i])[0] for i in range(12)]
    ok = all(0x05B000 <= v < 0x05C500 for v in t[:11]) and not (0x05B000 <= t[11] < 0x05C500)
    return ok, '11 step pointers 0x05C40A-0x05C435: ' + ','.join('%06X' % v for v in t[:11]) + '; 0x05C436 = %08X (code)' % t[11]


def chk_bbc2_stores():
    hits = [i for i in range(0x80000 - 4) if M[i] == 0x6B and (M[i + 1] & 0xF8) == 0x80 and M[i + 2:i + 4] == b'\xbb\xc2']
    return hits == [0x026F3C, 0x026F48, 0x026F6A], 'mov.w Rn,@0xFFBBC2 stores in 0x000000-0x07FFFF: ' + ','.join('%06X' % h for h in hits)


def chk_hittest():
    c = M[:0x80000].count(bytes.fromhex('5e026f08'))
    return c == 125, 'jsr @0x026F08 (5e 02 6f 08) count = %d' % c


COMPUTED = [('X01', chk_ramps, 'M 0x0376C8+152: non-decreasing runs'),
            ('X02', chk_font, 'S 0xFFED4644 26x12 font blocks {u8 w,u8 h,u16 base,u32 ord,u32 pix} LE'),
            ('X03', chk_step_table, 'M 0x05C40A step table extent'),
            ('X04', chk_bbc2_stores, 'M whole content: stores to 0xFFBBC2'),
            ('X05', chk_hittest, 'M whole content: hit-test call sites')]

# ---------------------------------------------------------------- errata
# doc, lines, quote (must occur in those lines), as_written, corrected, class,
# credited, mission, k12, checks, corrected MAIN addresses for the mask column
ERRATA = [
 ('E01', '70-dERn-dispatchers.md', '107', '04E31A 5e 05 27 80',
  '04E31A 5e 05 27 80 jsr @0x052780',
  '0x04E318 5e 05 27 80 jsr @0x052780 (after 0x04E312 7a 01 00 ff b0 67 mov.l #0xFFB067,er1; before 0x04E31C 54 70 rts)',
  'address slip (-2)',
  'no: inside the credited J2 run 0x04E2D6-0x04E31D; the extent is set by the rts at 0x04E31C, which the doc cites correctly',
  'no', 'agree', ['C01', 'C02', 'C03'], [0x04E318]),
 ('E02', '71-key-dispatch-028cbc.md', '86', '`0x026F4A` | `mov.w r3,@0xFFBBC2`',
  '0x026F4A mov.w r3,@0xFFBBC2',
  '0x026F48 6b 83 bb c2 mov.w r3,@0xFFBBC2 (after 0x026F42 6f 53 00 08 mov.w @(8,er5),r3 and 0x026F46 4b 1e bmi). The same row\'s path column already says sub_26F48.',
  'address slip (+2)', 'no: touch-index store; not a ledger byte', 'no (touch layer; no USB/DSP)', 'agree',
  ['C04', 'C05', 'C06', 'C07', 'X04'], [0x026F48]),
 ('E03', r'ida\out\key-dispatch\writers-0xFFBBC2.tsv', '6', '026F4A\t6b 83 bb c2',
  '026F4A 6b 83 bb c2 mov.w r3,@0xFFBBC2',
  '026F48 6b 83 bb c2 (lane table, same slip as E02)',
  'address slip (+2), lane table', 'no', 'no', 'agree (K12 noted it in prose, not as a row)', ['C05', 'X04'], [0x026F48]),
 ('E04', '72-main-unreached-functions.md', '63', '`00 06 5F 00` at `0x02B3DC`',
  'Table entry 00 06 5F 00 at 0x02B3DC',
  '0x02B3DA 00 06 5f 00 = slot 6 of table 0x02B3C2',
  'address slip (+2)',
  'no: the cell is data; the 16 B it points at (J4 stubs) are credited under K1b from the correct cells 0x02B3D6/DA/DE (doc 83 l.120)',
  'no', 'agree', ['C08', 'C09', 'C10', 'C11', 'C12', 'C13', 'C14'], [0x02B3DA]),
 ('E05', '72-main-unreached-functions.md', '64', '`00 06 5F 06` at `0x02B3E0`',
  'Table entry 00 06 5F 06 at 0x02B3E0',
  '0x02B3DE 00 06 5f 06 = slot 7 (last) of table 0x02B3C2; 0x02B3E2 is code (7a 06 00 02 b4 1a)',
  'address slip (+2)', 'no (as E04)', 'no', 'agree', ['C13', 'C14'], [0x02B3DE]),
 ('E06', '72-main-unreached-functions.md', '62;71;152;154', '0x02B3C0',
  '"~0x02B3C0" table (l.62, 71, 152); "the 0x02B3C0 base held in a register" (l.154)',
  'table base 0x02B3C2 (0x02B3C0 is 54 70 rts). Base loaded by 0x02B3A8 7a 06 00 02 b3 c2 then jmp @0x028616; reader is helper 0x028616 (6b 04 bb c2 79 24 00 09 ... 0x028630 5d 60 jsr @er6), not an indexed jmp inside 0x065EC2-0x065F3A',
  'address slip (approximate base; l.154 also names the wrong reader site)',
  'no: K1 credits the 16 B from this base (doc 83 l.110-120)', 'no', 'new (K12 graded the "~" form PASS; doc 83 l.230 gives the base)',
  ['C08', 'C09', 'C15', 'C16'], [0x02B3C2]),
 ('E07', '72-main-unreached-functions.md', '91', '152 B monotonic',
  '0x0376C8 (11 11 ... 12 12, 152 B monotonic)',
  '0x0376C8 152 B = three non-decreasing ramps: 0x0376C8-0x0376F9 (50 B, 11..1a), 0x0376FA-0x03772B (50 B, 11..19), 0x03772C-0x03775F (52 B, 0f..5b); the 5b run continues past the 152 B to 0x037762',
  'wording', 'no: data either way; disposition unchanged', 'no', 'agree', ['X01'], [0x0376C8]),
 ('E08', '72-main-unreached-functions.md', '129', '`jsr` operand `5A` at `0x074342`',
  '`jsr` operand `5A` at `0x074342`',
  'false abs24 match 5a 03 6b 84 at 0x074340 = "jmp @0x036B84" (5A is jmp @aa:24; jsr is 5E). Real code: 0x07433E 79 04 5a 03 mov.w #0x5A03,r4; 0x074342 6b 84 96 f8 mov.w r4,@0xFF96F8. Target 0x036B84 = 1d x10, 1e 1e (ramp).',
  'address slip (-2) + mnemonic slip (jsr->jmp)',
  'no: the conclusion (false positive) stands', 'no', 'agree on address; adds jmp/jsr', ['C17', 'C18', 'C19'], [0x074340]),
 ('E09', '73-usb-status-byte0.md', '94', '`0x054F1E`',
  '0x054F1E | 0x0100FFFF long | VBUS-gone soft reset',
  '0x054F1C 01 00 6b 84 81 84 mov.l er4,@0xFF8184, er4 = 0x0100FFFF built at 0x054F12 f4 01 / fc 00 / 0d 4c / 79 04 ff ff. Lane TSV usb-status0\\writers-readers.tsv already has 054F1C.',
  'address slip (+2)', 'no', 'no: USB status byte 0 writer exists, same instruction (Q1 unchanged)', 'agree', ['C20'], [0x054F1C]),
 ('E10', '73-usb-status-byte0.md', '95', '`0x05601E`',
  '0x05601E | 0x0100FFFF long | selector=1 / soft reset',
  '0x05601C 01 00 6b 84 81 84 (same sequence from 0x056012)',
  'address slip (+2)', 'no', 'no (Q1 unchanged)', 'agree', ['C21'], [0x05601C]),
 ('E11', '74-usb-key14-tone4f.md', '152', '05549c  fc 08 6a 8c 81 83',
  '05549c  fc 08 6a 8c 81 83',
  '05549a fc 08 6a 8c 81 83 (mov.b #8,r4l at 0x05549A; store mov.b r4l,@0xFF8183 at 0x05549C). Line 148 uses the load address, so l.152 is inconsistent with it.',
  'address slip (listing convention: store address with load bytes)', 'no', 'no (Q1 unchanged)', 'agree', ['C22'], [0x05549A]),
 ('E12', '74-usb-key14-tone4f.md', '158', '038674  fc 00 6a 8c aa e8',
  '038674  fc 00 6a 8c aa e8',
  '038672 fc 00 6a 8c aa e8 (store at 0x038674; l.40 "0x038674" as a store address is correct)',
  'address slip (listing convention)', 'no', 'no (Q1 unchanged)', 'agree', ['C23'], [0x038672]),
 ('E13', '76-dsp-tpu-tick.md', '126', '002A5A  56 70',
  '002A5A  56 70  rts',
  '002A5C 6d 74 pop.w r4 ; 002A5E 56 70 rte (vector 110 = 00 00 2a 30; handler opens with 6d f4 push.w r4 at 0x002A30)',
  'address slip (+4) + mnemonic slip (rts->rte)', 'no', 'no (tick timing unchanged; Q3)', 'agree', ['C24', 'C25', 'C26'], [0x002A5E]),
 ('E14', '76-dsp-tpu-tick.md', '172', '056776',
  '056776  79 04 00 00 3c f0 6b 84 ff f6',
  '056772 79 04 00 00 3c f0 6b 84 ff f6 (TCR store 3c f0 at 0x056776)',
  'address slip (listing convention, -4)', 'no', 'no (2.2 ms guard unchanged)', 'agree', ['C27'], [0x056772]),
 ('E15', '76-dsp-tpu-tick.md', '172', '056826',
  '056826  (same bytes)', '056822 (3c f0 at 0x056826)',
  'address slip (listing convention, -4)', 'no', 'no', 'agree', ['C28'], [0x056822]),
 ('E16', '76-dsp-tpu-tick.md', '172', '056950',
  '056950  (same bytes)', '05694C (3c f0 at 0x056950)',
  'address slip (listing convention, -4)', 'no', 'no', 'agree', ['C29'], [0x05694C]),
 ('E17', '76-dsp-tpu-tick.md', '173', '@0xFFFF0 (TCR',
  'mov.b r4l,@0xFFFF0 (TCR=0x00)',
  'mov.b r4l,@0xF0:8 = @0xFFFFF0 (TCR3); 3c f0 is the 8-bit absolute form',
  'address typo (dropped digit)', 'no', 'no', 'new (not in K12)', ['C27', 'C28', 'C29'], [0x056776, 0x056826, 0x056950]),
 ('E18', '76-dsp-tpu-tick.md', '155', 'mov.w @0xFFFFF6:16,r4',
  '05B8A8  6b 0c ff f6  mov.w @0xFFFFF6:16,r4',
  '05B8A8 6b 0c ff f6 mov.w @0xFFF6:16,e4 (register nibble c = e4)',
  'mnemonic slip (register name)', 'no', 'no (compare value 0x8980 and 2.2 ms unchanged)', 'agree (K12 Open 3)', ['C30'], [0x05B8A8]),
 ('E19', '76-dsp-tpu-tick.md', '156', 'cmp.w #0x8980,r4',
  '05B8AC  79 2c 89 80  cmp.w #0x8980,r4',
  '05B8AC 79 2c 89 80 cmp.w #0x8980,e4',
  'mnemonic slip (register name)', 'no', 'no', 'agree (K12 Open 3)', ['C30'], [0x05B8AC]),
 ('E20', '77-dsp-tx-sources.md', '92', '`0x15` (table `05C40A`, `1C 03`)',
  '0x15 (table 05C40A, 1C 03)',
  'now checkable, PASS: B0BE=0x15 selects 0x05B310[0x15] @0x05B364 = 00 05 c3 f4; 0x05C3F4 indexes the 11-slot step table 0x05C40A-0x05C435 by FFB0BF; slot 4 @0x05C41A = 00 05 c4 36; step 0x05C436 sets B0B8=3 (fc 03 6a 8c b0 b8) and calls 0x05A040, which clears the 32-B frame at FFB13E and stores word 1C|[B0B8] there (f3 1c 6a 0b b0 b8 6b 83 b1 3e). sub_5A2F8 posts 0x15 via B0B7 (0x05A32E fc 15 6a 8c b0 b7), copied to B0BE at 0x05A3A0.',
  'notation (resolved; correct as written)', 'no', 'no (Q3: opcode 1C meaning still Unknown, doc 93 l.73)',
  'resolves K12 N/A', ['C31', 'C32', 'C33', 'C34', 'C35', 'C36', 'C37', 'C38', 'X03'], [0x05C436, 0x05A07C]),
 ('E21', '79-sub-icon-glyph-fields.md', '128-130', 'blocks 9–25 are the ASCII/symbol',
  'Blocks 0-7 kanji/katakana/symbol (14x14, base 0x2121/0x5021/0x9321...), block 8 duplicates block 2, blocks 9-25 ASCII/symbol (base_code 0x0020)',
  'blocks 0-2 and 4-8 are 14x14 (base 9321, 5021, 2121, 2D21, 2124, 7921, 2122, 2121); block 3 is 7x14 base 0x0020 (half-width ASCII); block 8 == block 2 (all 12 B); blocks 9-25 base 0x0020 except block 11 (10x9, 0x0023) and block 18 (5x14, 0x002E); range 14x27 (blk 9) to 4x7 (blk 25) is correct',
  'wording', 'no: SUB data table, not window code', 'no', 'agree', ['X02'], []),
 ('E22', '80-settings-49.md', '24', 'save stub at `0x1935E`',
  'its dedicated save stub at 0x1935E is unreachable',
  '0x01935A 79 01 00 aa mov.w #0xAA,r1 ; 0x01935E 5a 03 cc bc jmp @0x03CCBC (0x1935E is the stub\'s jmp, not its start); doc 80 l.45 and l.145 already say 0x1935A',
  'address slip (+4)', 'no: dead stub, named (typed) but not proven', 'no', 'agree', ['C39'], [0x01935A]),
 ('E23', '80-settings-49.md', '115', 'save stub `0x1935E`',
  'its dedicated save stub 0x1935E is unreachable',
  '0x01935A (same as E22)', 'address slip (+4)', 'no', 'no', 'new (K12 checked l.24 only)', ['C39'], [0x01935A]),
 ('E24', '80-settings-49.md', '66-67', '08 09 01 0F 00',
  'table 0xCE40 = 02 03 04 05 06 07 08 09 01 0F 00',
  '0x00CE40 02 03 04 05 06 07 08 09 0a 01 0f 00 (12 B, 0x00CE40-0x00CE4B; code resumes 0x00CE4C 6a 0c 94 c1). Reader 0x00CE1E indexes it by [FF89CB]; index 8 -> 0x0A, 9 -> 0x01, 10 -> 0x0F, 11 -> 0x00',
  'byte slip (dropped 0a)', 'no', 'no', 'agree', ['C40', 'C41', 'C42'], [0x00CE40]),
]

# ---------------------------------------------------------------- K-wave index
# owning doc, lines, quote in owning doc, superseded statement, replacement, superseding doc, sup lines, quote in superseding doc, lane, anchors
KIDX = [
 ('K-01', '70-dERn-dispatchers.md', '38-39;98', 'truncated before slot 68',
  'I8\'s walk of 0x04ABE4 truncated before slot 68', 'a stale mid_code exclusion of slot 0x04ACF4 hid 0x04E2D6; the walk was not truncated; the handler is also slots 134/154/245 of 0x04ABE4 and 274/358 of 0x04AB70',
  '83-main-final4-seed.md', '227-229', 'was not truncated', 'K1', ['K01']),
 ('K-02', '71-key-dispatch-028cbc.md', '43;95;141;165', 'nine',
  'nine touch-zone tables', '99 zone tables / 511 zones / 5,296 B, 125 hit-test call sites',
  '85-touch-screens.md', '241-242', '**99** (125 call sites)', 'K1/K2/K3', ['X05']),
 ('K-03', '71-key-dispatch-028cbc.md', '51;158-159', 'raw events (the ladder at `0x026500`/`0x026580`)',
  '0xF3xx-0xFDxx are raw touch events; ladder at 0x026500/0x026580', 'they are the MAIN->SUB screen opcode echoed by SUB; ladder of 94 arms starts 0x02639C (er2 load) / 0x0263A2 (first compare)',
  '84-touch-producer.md', '24-26', 'starts at `0x0263A2`, not', 'K2/K3', ['K02']),
 ('K-04', '71-key-dispatch-028cbc.md', '92', 'a secondary coordinate/hit',
  'sub_26F9C / 0xFFBBC4 = secondary coordinate/hit', 'BBC4 is the pending hold/repeat button',
  '85-touch-screens.md', '245', 'hold/repeat button', 'K3', []),
 ('K-05', '71-key-dispatch-028cbc.md', '142-143', '0x02843C',
  'tables 0x02843C/0x0270CA hold button indices', '0xF00x / 61441 / 61444 values are virtual-key codes (BBC2 stays 0)',
  '85-touch-screens.md', '243-244', 'virtual-key', 'K3', []),
 ('K-06', '72-main-unreached-functions.md', '63-64', '0x02B3DC',
  'table cells 0x02B3DC/0x02B3E0', '0x02B3D6/0x02B3DA/0x02B3DE, table 0x02B3C2 (E04-E06 here)',
  '83-main-final4-seed.md', '120;230-231', '0x02B3D6', 'K1/K12', ['C11', 'C12', 'C13']),
 ('K-07', '72-main-unreached-functions.md', '69-72', '+16 B Inferred',
  'J4 +16 B Inferred, reader not pinned', 'Confirmed: 0x02B3A8 loads 0x02B3C2 and jumps to helper 0x028616 (jsr @er6 at 0x028630); credited under rule K1b',
  '83-main-final4-seed.md', '230-232', 'now Confirmed under rule', 'K1', ['C08', 'C15', 'C16']),
 ('K-08', '72-main-unreached-functions.md', '131', 'beyond the 5 functions',
  'nothing beyond the 5 functions is reachable code the descent missed', 'scoped to unproven DB-code runs; K1b finds 170 B more of touch-key stubs',
  '83-main-final4-seed.md', '231-233', 'K1b finds 170 B more', 'K1', []),
 ('K-09', '77-dsp-tx-sources.md', '20-21;77-80;197;232', '0xFFFF4D` bit 3',
  'PTT = 0xFFFF4D b3 (active low)', 'PTT = 0xFFFF4E b7 (0x00FC66 debounce); 0xFFFF4D b3 is a band-A RF-status interlock',
  '93-tx-gate.md', '15;225-227', '`0xFFFF4E` b7', 'K11', ['K03', 'K05']),
 ('K-10', '77-dsp-tx-sources.md', '69;233-234', 'TX-inhibit timer (TOT)',
  'FF956D = TX-inhibit timer (TOT)', 'FF956D is a 10-20 ms post-retune settle; the TOT is FF95EA',
  '93-tx-gate.md', '228', 'The TOT is `FF95EA`', 'K11', ['K04']),
 ('K-11', '77-dsp-tx-sources.md', '20;27-28;216-218', 'Two things key the radio up, and only two',
  'only PTT and the SCI-A node link key the radio', 'also four APRS automatic paths (beacon, SmartBeaconing, retry, auto-ack), PDN S frame, remote "]" (session 0x15), GM beacon, addressed delivery ACK',
  '90-aprs-ax25.md', '254-257', 'key-up list is incomplete', 'K8 (+K4 doc 86 l.228-231, K10 doc 92, K11 doc 93)', ['K07', 'K08']),
 ('K-12', '77-dsp-tx-sources.md', '30-31;219', 'automatic** data-reply session `0x17`',
  'session 0x17 is an automatic reply started by decoded over-air messages', 'session 0x17 is the PDN form of a WIRES-X request; sub_62DA4... are request builders',
  '86-dsp-autoreply.md', '218-226', 'Correction to doc 77', 'K4', ['K12']),
 ('K-13', '77-dsp-tx-sources.md', '93;106', 'a data/message/APRS packet is queued',
  'AAD4.b0 = data/message/APRS packet queued', 'AAD4.b0 setters are the C4FM GM engines; APRS uses AAD3 b0/b2 -> A4F0 b6/b7',
  '90-aprs-ax25.md', '258-259', '`AAD4.b0`/session `0x0A`', 'K8', ['K07', 'K08']),
 ('K-14', '77-dsp-tx-sources.md', '39;181-190', '**AMS / mode** frame',
  '0x32 = AMS/mode frame; F3A3/F3AB labels unresolved', 'F3A3 = APRS MODEM (FF8AA0), F3AB = APRS TX DELAY; opcode 0x32 = APRS modem config',
  '87-dsp-payload-labels.md', '287-290', '**APRS modem config**', 'K5/K8', ['K06']),
 ('K-15', '77-dsp-tx-sources.md', '144-155', '[15..26]',
  'opcode 0x11 layout; opcode 0x12 layout', '0x11 bytes [15..17] overlaid from FF8E3D-3F when FF8E3C==0x69, bytes [27..30] omitted; 0x12 byte [3] = FF8D87 omitted',
  '87-dsp-payload-labels.md', '291-294', 'opcode `0x11` bytes `[15..17]`', 'K5', []),
 ('K-16', '77-dsp-tx-sources.md', '111-113;235', '`B0CC` is written as a whole byte',
  'B0CC written by sub_2DCE/sub_73AFE/sub_74396; open item 4', 'B0CC is a 1-bit flag set/cleared by remote command "]" (0x0743BC / 0x0743CC); it selects session 0x15',
  '93-tx-gate.md', '229', '`B0CC` is a 1-bit remote-commanded flag', 'K11', ['K09', 'K10']),
 ('K-17', '77-dsp-tx-sources.md', '27', 'host command byte `0x11`',
  'sub_73E58 = host command 0x11', 'table 0x074472 slot 0x10 holds 0x073E58 (frame byte 0x40); numbering basis not settled',
  '93-tx-gate.md', '230-232', 'slot `0x10`', 'K11', ['K11']),
 ('K-18', '78-sub-merge-dead.md', '24;144', '2,279 B',
  'residue 10,059 B; merges 2,279 B', 'residue 10,670 B (three tail chunks, 611 B, missed); merges 2,890 B',
  '89-sub-final3-seed.md', '44', '10,670 B', 'K7', []),
 ('K-19', '78-sub-merge-dead.md', '24-25;108-109', '`FFF2A70B`',
  'FFF2A70B is a continuation of FFF2A6D1', 'FFF2A70B is a separate subroutine (called by bsr.w at FFF2A6F7), merged only as instructed',
  '89-sub-final3-seed.md', '45', 'is a separate subroutine', 'K7', ['K13']),
 ('K-20', '79-sub-icon-glyph-fields.md', '27;153-155;190', 'mask table',
  '18-entry status/capability mask table; idx = u16[handle+0x2C6]', '7 {SD,MMC} R1 error-mask pairs + 4 CMD6 args (FFED7F50-5C = 0x00FFF0FF..0x00FFF3FF); +0x2C6 = card family',
  '88-sub-sdmmc-driver.md', '333-335', 'R1 error-mask pairs', 'K6', ['K14']),
 ('K-21', '79-sub-icon-glyph-fields.md', '163-168', 'SDSC/SDHC-class split',
  '0x7DFFFF = SDSC/SDHC split; field 0/field 7 meaning', 'split is within SDHC; field 0 = {u16 spt,u16 heads}; field 7 = RSC; records are SD Association format parameters',
  '88-sub-sdmmc-driver.md', '337-339', '**within SDHC**', 'K6', []),
 ('K-22', '79-sub-icon-glyph-fields.md', '190', 'one live',
  'geometry records are the one live lead', 'reached only from dead sub_FFF36999 (formatter unreachable in v1.02)',
  '88-sub-sdmmc-driver.md', '340', 'dead `sub_FFF36999`', 'K6', []),
 ('K-23', '70-dERn-dispatchers.md', '107', '04E31A',
  'K12 citation errata in docs 70-80', 'see section 1 of this doc (E01-E24) and doc 94 section 2',
  '94-ledger-reverify-j.md', '110-148', 'Citation discrepancies', 'K12/L14', []),
]


def doc_lines(path):
    p = path if os.path.isabs(path) else (os.path.join(ROOT, path) if path.startswith('ida') else os.path.join(DOCS, path))
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
    L = doc_lines(path)
    txt = '\n'.join(L[i - 1] for i in expand(spec))
    return quote in txt


def main():
    res = {}
    rows = ['id\timage\taddr\tfile_off\texpected\tactual\tresult\tmeaning']
    for cid, img, a, exp, what in CHECKS:
        e = bytes.fromhex(exp.replace(' ', ''))
        act = rd(img, a, len(e))
        ok = act == e
        res[cid] = ok
        off = a if img == 'M' else a - SUBBASE
        rows.append('\t'.join([cid, img, fmt(img, a), '0x%06X' % off, H(e), H(act), 'PASS' if ok else 'FAIL', what]))
    for cid, fn, what in COMPUTED:
        ok, det = fn()
        res[cid] = ok
        rows.append('\t'.join([cid, '', '', '', what, det, 'PASS' if ok else 'FAIL', 'computed']))
    open(os.path.join(OUT, 'bytecheck.tsv'), 'w', encoding='utf-8', newline='\n').write('\n'.join(rows) + '\n')

    er = ['doc\tline\tas_written\tcorrected\tclass\tcredited_byte_affected\tevidence\tid\tmission_answer_affected\tk12\tmask_final4_at_corrected\tdoc_text_check']
    for (eid, doc, line, quote, asw, cor, cls, cred, miss, k12, cks, addrs) in ERRATA:
        tq = 'PASS' if quote_ok(doc, line, quote) else 'FAIL'
        ev = ' '.join('%s:%s' % (c, 'PASS' if res[c] else 'FAIL') for c in cks)
        mk = ','.join('%06X proven=%d named=%d' % (a, PROVEN[a], NAMED[a]) for a in addrs)
        if eid == 'E21':
            o = 0xFFED4644 - SUBWIN
            mk = 'SUB FFED4644 headline_w2=%d allwf=%d' % (SUBHL[o], SUBALL[o])
        if addrs:
            loc = 'proven code' if any(PROVEN[a] for a in addrs) else ('named only' if any(NAMED[a] for a in addrs) else 'outside masks')
        else:
            loc = 'SUB data, outside SUB code masks' if eid == 'E21' else 'n/a (prose or notation)'
        cred2 = 'NO mask change. Location: %s. %s' % (loc, cred)
        er.append('\t'.join([doc, line, asw, cor, cls, cred2, ev, eid, miss, k12, mk, tq]))
    open(os.path.join(OUT, 'errata.tsv'), 'w', encoding='utf-8', newline='\n').write('\n'.join(er) + '\n')

    kx = ['id\towning_doc\towning_lines\tsuperseded\treplacement\tsuperseding_doc\tsuperseding_lines\tlane\tanchors\towning_text_check\tsuperseding_text_check']
    for (kid, od, ol, oq, sup, rep, sd, sl, sq, lane, anc) in KIDX:
        a = 'PASS' if quote_ok(od, ol, oq) else 'FAIL'
        b = 'PASS' if quote_ok(sd, sl, sq) else 'FAIL'
        ev = ' '.join('%s:%s' % (c, 'PASS' if res[c] else 'FAIL') for c in anc)
        kx.append('\t'.join([kid, od, ol, sup, rep, sd, sl, lane, ev, a, b]))
    open(os.path.join(OUT, 'kwave-index.tsv'), 'w', encoding='utf-8', newline='\n').write('\n'.join(kx) + '\n')

    h = lambda p: hashlib.sha256(open(os.path.join(ROOT, p), 'rb').read()).hexdigest()
    sys.exit("The firmware image is not in this repository.")
    for r in rows[1:]:
        if '\tFAIL\t' in r:
            summ.append('FAILED CHECK: ' + r)
    for r in er[1:] + kx[1:]:
        if r.endswith('FAIL') or '\tFAIL' in r or ':FAIL' in r:
            summ.append('ROW ISSUE: ' + r[:160])
    open(os.path.join(OUT, 'run.txt'), 'w', encoding='utf-8', newline='\n').write('\n'.join(summ) + '\n')
    print('\n'.join(summ))


if __name__ == '__main__':
    main()
