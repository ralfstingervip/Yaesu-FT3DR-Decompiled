# Lane M6: decide every L5 Inferred table/record/label piece (+ the 43 B fragment), byte-check every citation,
# and emit pieces.tsv, proposed-typing.tsv, proposed-proven.tsv, verify.txt.  Offline, read-only on every input.
from pathlib import Path as _Path
_REPO_S = _Path(__file__).resolve().parents[3].as_posix()
import sys, hashlib
sys.path.insert(0, (_REPO_S + "/ida/out/inferred-tables"))
from m6_lib import *

CORE = open(O + r"\work\m6_core_mask.bin", "rb").read()      # K1 folded descent + L-wave edges + record 0x01686E fields
assert hashlib.sha256(img).hexdigest().startswith("8e3ecd05409b2c31")

# ---------------------------------------------------------------- citations
# (addr, hex, kind) kind: P = proven instruction in final6; C = instruction proven only after the core seeds; D = data bytes
FAILS = []
def cite(a, h, k="P"):
    b = bytes.fromhex(h.replace(" ", ""))
    ok = img[a:a + len(b)] == b
    if k == "P": ok = ok and all(PM[i] for i in range(a, a + len(b)))
    if k == "C": ok = ok and all(CORE[i] for i in range(a, a + len(b))) and not all(PM[i] for i in range(a, a + len(b)))
    if not ok: FAILS.append("%06X %s %s got %s" % (a, k, h, hx(a, len(b))))
    return "%06X `%s`" % (a, h)

DEC = []   # (lo, hi_excl, tier, typing, element, reader+bound, [cites], note)
def D(lo, hi, tier, typing, element, reader, cites, note=""):
    DEC.append((lo, hi, tier, typing, element, reader, cites, note))

# 1 sine/level table 0x000DEA (14 x u32), last cell
assert 0xDEA + 13 * 4 == 0xE1E
assert 0xDB2 + 14 * 4 == 0xDEA and 0xDEA + 14 * 4 == 0xE22
D(0x000E20, 0x000E22, "C-extent", "data u32 cell (low half), slot 13 (unread)", "u32 {u8 flag,u8 level,u16 mag}, stride 4, table 0x000DEA[14] (twin 0x000DB2[14] ends at 0x000DEA; code at 0x000E22)",
  "mov.l @(0xDEA:32,er6) with er6=AADC*4; traced AADC on this table = 1..12 (AACB 0xF..0x13 -> 1..5, 0x14 -> 6, then AADB=1 and AACB 1..7 -> 6..12); slot 13 is not read on any traced path",
  [cite(0x000938, "78 e0 6b 26 00 00 0d ea"), cite(0x000A04, "78 e0 6b 26 00 00 0d ea"), cite(0x00070C, "6a 0d aa dc"),
   cite(0x000710, "0c de"), cite(0x000712, "10 76"), cite(0x000926, "f4 01 6a 84 aa dc"), cite(0x000A12, "0a 0d 6a 8d aa dc"),
   cite(0x0009B4, "ac 07"), cite(0x0009BA, "ac 0e"), cite(0x0009C0, "ac 14"), cite(0x000E1E, "00 7f 31 9c", "D"), cite(0x000E22, "6e 0c 00 18")],
  "slot 13 = 00 7f 31 9c mirrors twin slot 13 at 0x000DE6 = 80 7f 31 9c (named); in-extent but unread")
# 2 no reader
D(0x005796, 0x0057A8, "Inferred", "data bytes (00 05 + 3 x a0 8x 8x e3 e8 + 00)", "unknown", "Not found (scope: every IDA code-head operand value, every BE32 cell, every 16-bit 0x5790-0x57A7 occurrence)",
  [cite(0x005794, "54 70"), cite(0x005796, "00 05 a0 81 87 e3 e8 a0 83 85 e3 e8 a0 87 81 e3 e8 00", "D"), cite(0x0057A8, "6a 10 89 be 77 10")])
# 3 jump table 0x00917E slots 3..7
D(0x00918A, 0x00919E, "C-read", "BE32 code pointers (dword+offset)", "jmp table 0x00917E[8], slots 3..7 -> 0xDB58 0xDB5E 0xDB88 0xD910 0xD9C8 (all proven)",
  "mov.l @(0x917E:32,er3),er6 ; jmp @er6 ; er3=B9E4*4; B9E4 stored 3,4,5,6,7 by proven code",
  [cite(0x009168, "6a 0b b9 e4"), cite(0x009172, "10 73"), cite(0x009174, "78 b0 6b 26 00 00 91 7e 59 60"),
   cite(0x029580, "fc 03 6a 8c b9 e4"), cite(0x029558, "fc 04 6a 8c b9 e4"), cite(0x0295FE, "fc 05 6a 8c b9 e4"),
   cite(0x0294EE, "fc 06 6a 8c b9 e4"), cite(0x029594, "fc 07 6a 8c b9 e4"), cite(0x00918A, "00 00 db 58 00 00 db 5e 00 00 db 88 00 00 d9 10 00 00 d9 c8", "D"),
   cite(0x00DB58, "5e 00 d6 42"), cite(0x00919E, "6e 0b 00 84")])
# 4 ramp 0x009B15
assert 0x9B15 + 0x24 == 0x9B39
D(0x009B34, 0x009B3A, "C-read", "data bytes", "u8 ramp table 0x009B15[0x25]",
  "mov.b @(0x9B15:32,er4),r2l with r4l < 0x25 (cmp.b #0x25 ; bcc skip)",
  [cite(0x009B80, "ac 25 44 0e"), cite(0x009B8A, "78 40 6a 2a 00 00 9b 15"), cite(0x009BC0, "ac 25 44 0e"), cite(0x009BCA, "78 40 6a 2a 00 00 9b 15")],
  "indices 0x1F..0x24")
# 5 eepmov block 0x00B7EE
assert 0xB7EE + 0x4C == 0xB83A
D(0x00B82C, 0x00B830, "C-read", "data bytes", "76-byte screen-template block 0x00B7EE..0x00B839",
  "eepmov.w r4=0x4C from er5=0xB7EE",
  [cite(0x007E96, "79 04 00 4c"), cite(0x007E9A, "7a 05 00 00 b7 ee"), cite(0x007EA6, "7b d4 59 8f"), cite(0x008C88, "7a 05 00 00 b8 3a")])
# 6 16-byte block 0x00F012
D(0x00F01E, 0x00F020, "C-read", "data bytes", "16-byte block 0x00F012..0x00F021 (after the 96 69 magic word 0x00F010)",
  "sub_3F36E (eepmov.w, r4h=0, r4l=count) with r4l=0x10, er5=0xF012",
  [cite(0x00DE48, "fc 10"), cite(0x00DE4A, "7a 05 00 00 f0 12"), cite(0x00DE56, "5e 03 f3 6e"), cite(0x03F36E, "f4 00 7b d4 59 8f 0d 44 46 f8 54 70")])
# 7 per-market band blocks 0x00F0A2 (8 x 0x24)
assert 0xF0A2 + 8 * 0x24 == 0xF1C2
D(0x00F188, 0x00F1A0, "C-extent", "BE32 BCD band edges", "per-market block 0x00F0A2 + 0x24*FF800F: {u16 stride, u16 count, 4 x {u32 lo, u32 hi}}; blocks 0..7",
  "add.l #0xF0A2 to er6 = FF800F*0x24, then sub_3F59C (stride forced 8, count 4) reads the whole block; piece = block 6 ranges + block 7 header",
  [cite(0x03F554, "6a 0c 80 0f"), cite(0x03F55C, "79 06 00 24 52 46"), cite(0x03F562, "7a 16 00 00 f0 a2"), cite(0x03F5A2, "79 02 00 08"),
   cite(0x03F5AC, "79 03 00 04"), cite(0x00F17A, "00 10 00 02 13 70 00 00 17 40 00 00 12 00 00 00 22 19 95 00", "D"), cite(0x00F1C2, "00 08 00 04", "D")],
  "index 6/7 = FF800F market value; doc 96 shows 1,2,3,4,5,7 cases")
# 8 per-market u32 0x00F6A2[8]
D(0x00F6A3, 0x00F6B8, "C-extent", "BE32 cells", "u32 per market, table 0x00F6A2[8] (next base 0x00F6C2)",
  "mov.l #0xF6A2,er5 ; sub_EAD2: er5 += FF800F*4 ; mov.l @er5,er4",
  [cite(0x01E548, "7a 05 00 00 f6 a2"), cite(0x00EA2C, "7a 05 00 00 f6 a2"), cite(0x00EAD2, "6a 0c 80 0f"), cite(0x00EADE, "10 74 0a c5 01 00 69 54"),
   cite(0x00E7F8, "6a 30 00 00 f6 c2")])
# 9 jump table 0x00FC0C slots 1..3
D(0x00FC10, 0x00FC1C, "C-read", "BE32 code pointers (dword+offset)", "jmp table 0x00FC0C[4], slots 1..3 -> sub_FC2E",
  "mov.l @(0xFC0C:32,er3),er6 ; jmp @er6 ; er3=A9F4*4; A9F4 = 1 at 0x00FC26, then inc while < 3",
  [cite(0x00FBF6, "6a 0b a9 f4"), cite(0x00FC02, "78 b0 6b 26 00 00 fc 0c 59 60"), cite(0x00FC26, "fc 01 6a 8c a9 f4"),
   cite(0x00FC44, "ac 03 44 06 0a 0c 6a 8c a9 f4"), cite(0x00FC2E, "6a 0c 95 40")])
# 10 byte list 0x01518C[14]
D(0x015192, 0x015193, "C-read", "data byte", "u8 map 0x01518C[14] (next base 0x01519A)",
  "mov.b @(0x1518C:32,er3) with r3 from sub_3F62E on record 0x015120 {min 0, max 0x0D, ptr FFAD9B} (wraps 0..13)",
  [cite(0x014F7E, "7a 06 00 01 51 20"), cite(0x014F84, "5e 03 f6 2e"), cite(0x014F8E, "78 30 6a 2b 00 01 51 8c"),
   cite(0x015120, "00 0d 00 ff ad 9b", "D"), cite(0x03F63E, "69 64 1c bc 47 02 44 0a 0c 4b"), cite(0x014FB6, "78 30 6a 2b 00 01 51 9a")],
  "index 6")
# 11 record-field target -> proven code
D(0x01687E, 0x0168B4, "Proven-code", "code", "routine 0x01687E..0x0168B3 (20 insns, ends bra 0x0168F8)",
  "record 0x01686E field +8, called by sub_15260 when AD68=2 and AD9D=0 (jsr @er6 at 0x015292)",
  [cite(0x016864, "7a 05 00 01 68 6e 5a 01 52 60"), cite(0x01686E, "00 01 a1 7c 00 00 00 00 00 01 68 7e 00 01 68 bc", "D"),
   cite(0x01526A, "7a 02 00 00 00 00"), cite(0x015270, "6a 0a ad 68"), cite(0x015274, "46 06"), cite(0x01527C, "6a 0c ad 9d 47 06"),
   cite(0x015288, "10 72 0a a5 01 00 69 56 47 08 5d 60"), cite(0x015350, "fc 02 6a 8c ad 68"), cite(0x015924, "fc 00 6a 8c ad 9d"),
   cite(0x01687E, "6a 0a ad 9c 7a 62 00 00 00 ff aa 02 47 28", "C"), cite(0x0168B2, "40 44", "C")])
# 12 unread slot of word table 0x0168FE
D(0x016902, 0x016904, "C-extent", "data u16 (slot 2, unread)", "u16 table 0x0168FE[3] / u8 table 0x0168FA (index AD9C)",
  "mov.w @(0x168FE:32,er5) with er5=AD9C*2 at 0x016890/0x0168CE (proven after the core seeds); index 2 is diverted to 0x0168B4/0x0168F2 by cmp.b #2 ; beq",
  [cite(0x016888, "aa 02 47 28", "C"), cite(0x016890, "78 50 6b 25 00 01 68 fe", "C"), cite(0x016898, "78 20 6a 2a 00 01 68 fa", "C"),
   cite(0x0168FA, "00 01 00 00 00 23 00 59 00 00", "D"), cite(0x016904, "5e 01 51 ec", "D")],
  "the 2 B are table slot [2]; the only index that would read them is excluded")
# 13/14 JIS multi-tap records
D(0x01B629, 0x01B62E, "C-extent", "label record {u16 n; n x {u16 from,u16 to}}", "JIS X 0208 key-cycle record 0x01B628 {1; 2121->2121}",
  "cell [12] of 13-cell tables 0x01B4DA/0x01B62E/0x01B6AA/0x01B77A/0x01B88C (proven mov.l at 0x01A6EC..0x01A70C); sub_1A9C8 picks cell A9F0*4; loop mov.w @er5+ / mov.l @er5+",
  [cite(0x01A6EC, "7a 04 00 01 b4 da"), cite(0x01B50A, "00 01 b6 28", "D"), cite(0x01B65E, "00 01 b6 28", "D"), cite(0x01A9D6, "6a 0a a9 f0 10 4a"),
   cite(0x01A9E2, "0a c2 01 00 69 22"), cite(0x01A726, "6d 5c 01 00 6d 53 1d 4b"), cite(0x01B628, "00 01 21 21 21 21", "D"), cite(0x01B62E, "00 01 b6 62", "D")])
D(0x01B98D, 0x01B992, "C-extent", "label record {u16 n; n x {u16 from,u16 to}}", "JIS X 0208 key-cycle record 0x01B98C {1; 2121->2121}",
  "cells [10],[11] of 13-cell table 0x01B88C (proven mov.l 0x01A70C); same consumer",
  [cite(0x01A70C, "7a 04 00 01 b8 8c"), cite(0x01B8B4, "00 01 b9 8c 00 01 b9 8c", "D"), cite(0x01B98C, "00 01 21 21 21 21", "D"), cite(0x01B992, "5e 03 ff a0")])
# 15 BCD word table 0x01E220[6]
D(0x01E226, 0x01E22C, "C-read", "BCD u16 words", "u16 table 0x01E220[6] (twin 0x01E22C)",
  "er5=0x1E220 + 2*r3, r3 = word +8 of the matched 10-B record of range table 0x020C6A (values 0..5), mov.w @er5,r4",
  [cite(0x01E15A, "7a 06 00 02 0c 6a"), cite(0x01E160, "5e 03 f5 b2 46 3c"), cite(0x01E166, "7a 05 00 01 e2 20"),
   cite(0x01E17A, "7a 63 00 00 00 ff 10 33 0a b5 69 54"), cite(0x03F5E2, "6f 63 00 08"), cite(0x020C6A, "00 0a 00 06", "D"),
   cite(0x020CA0, "91 50 00 00 96 09 95 00 00 05", "D")], "word indices 3,4,5")
# 16 byte table 0x025334[14]
for lo, hi in ((0x025335, 0x025337), (0x025341, 0x025342)):
    D(lo, hi, "C-extent", "data bytes", "u8 table 0x025334[14] (code at 0x025342)",
      "mov.b @(0x25334:32,er1),r4l, er1 = band/step index from sub_25342 (0x0D = not-found sentinel, skipped at 0x0252FA)",
      [cite(0x0252FA, "a9 0d 47 2a"), cite(0x0252FE, "78 10 6a 2c 00 02 53 34"), cite(0x0253D0, "78 10 6a 2c 00 02 53 34"), cite(0x025342, "6e 0a 00 04")],
      "index 1,2 / 13")
# 17 step-sequence records 0x025546 (cell 8 of 0x025496)
for lo, hi in ((0x02554B, 0x02555D), (0x02555F, 0x025565)):
    D(lo, hi, "C-extent", "4-B records {s8 flag,u8,u8,u8}", "sequence 0x025546 = 10 x 4 B (cell [8] of pointer table 0x025496), ends at code 0x02556E",
      "mov.l @(0x25496:32,er1),er5 ; er5 += AE88*4 ; mov.b @er5+",
      [cite(0x025464, "78 90 6b 25 00 02 54 96"), cite(0x025476, "10 4c 0a c5 6c 5b"), cite(0x0254B6, "00 02 55 46", "D"), cite(0x02556E, "6a 0d ae 84")])
# 18 5 x 0x28 sequence block 0x02569C
assert 0x2569C + 5 * 0x28 == 0x25764
D(0x025742, 0x025764, "C-extent", "4-B records {s8 flag,u8,u8,u8}", "5 x 10 x 4 B table 0x02569C (block 4), ends at code 0x025764",
  "sub_2556E/sub_255A2: er5 = er6 + 0x28*(AE84 mod 5) + 4*AE88 ; mov.b @er5+",
  [cite(0x025452, "7a 06 00 02 56 9c 5e 02 55 6e"), cite(0x02556E, "6a 0d ae 84 f5 00 ad 05 45 04 fc 05 18 cd"),
   cite(0x0255A2, "79 04 00 28 52 45 0a e5"), cite(0x0255B4, "10 4c 0a c5 6c 5b"), cite(0x025764, "7a 05 00 ff ae 8c")])
# 19 BCD step table 0x025BE2[100]
for lo, hi in ((0x025C2A, 0x025C2C), (0x025C5C, 0x025C5E), (0x025C66, 0x025C6A)):
    D(lo, hi, "C-read", "BCD u16 words", "u16 table 0x025BE2[100] (two-digit index)",
      "index = 10*(d1&0xF) + (d2&0xF) from two ASCII digits, shll.l er6, mov.w @(0x25BE2:32,er6),r5",
      [cite(0x025AD4, "ee 0f fd 0a 50 d6"), cite(0x025ADE, "ed 0f 08 de"), cite(0x025AE8, "10 36 78 60 6b 25 00 02 5b e2"),
       cite(0x025F0A, "78 60 6b 25 00 02 5b e2"), cite(0x025CA0, "95 00 95 00 95 00 95 00 95 00", "D")], "indices 36, 61, 66-67")
# 20/21 label blocks
D(0x02C7A2, 0x02C7A7, "C-read", "label bytes", "84-byte label block 0x02C792.. ({u16 0x54; text})",
  "mov.l #0x2C790,er5 ; mov.w @er5+,r4 (0x54) ; eepmov.w",
  [cite(0x00B0B2, "7a 05 00 02 c7 90 6d 54"), cite(0x00B0C0, "7b d4 59 8f"), cite(0x02C790, "00 54", "D")])
D(0x02C8F3, 0x02C8F6, "C-read", "label length low byte + row-0 bytes", "label rows 0x02C8F2 {u16 len 0x12; rows of 18 B}",
  "mov.l #0x2C8F2,er5 ; sub_C66C: mov.w @er5+,r4 ; er5 += len*r3l ; eepmov.w",
  [cite(0x00CBCE, "7a 05 00 02 c8 f2"), cite(0x00CBDA, "5e 00 c6 6c"), cite(0x00C676, "6d 54 52 43 0a b5 7b d4 59 8f"), cite(0x02C8F2, "00 12", "D")],
  "0x02C8F3 is read by mov.w; 0x02C8F4-5 are row 0")
# 22/23 6-B records {u16 mul; u32 off} x 12
for base, lo, hi, site, cmps in ((0x02FA34, 0x02FA54, 0x02FA58, 0x02F9EA, (0x02F98C, 0x02F992, 0x02F998, 0x02F9B8, 0x02F9BC)),
                                 (0x02FA34, 0x02FA7A, 0x02FA7C, 0x02F9EA, (0x02F98C, 0x02F992, 0x02F998, 0x02F9B8, 0x02F9BC)),
                                 (0x0314DC, 0x0314FC, 0x031500, 0x031492, (0x031434, 0x03143A, 0x031440, 0x031460, 0x031464)),
                                 (0x0314DC, 0x031522, 0x031524, 0x031492, (0x031434, 0x03143A, 0x031440, 0x031460, 0x031464))):
    cs = [cite(site, "7a 13 00 0%x %02x %02x" % (base >> 16, (base >> 8) & 255, base & 255)), cite(site + 0xA, "6d 36"), cite(site + 0xE, "01 00 69 34")]
    for c, v in zip(cmps, (0x00, 0x48, 0x12, 0x24, 0x36)): cs.append(cite(c, "ab %02x" % v))
    for rt, ld in (((0x030B00, 0x02F968), (0x030BA4, 0x02F97A)) if base == 0x02FA34 else ((0x032442, 0x031410), (0x0324E6, 0x031422))):
        cs.append(cite(ld, "7a 06 00 0%x %02x %02x" % (rt >> 16, (rt >> 8) & 255, rt & 255)))
        st, n = be16(rt), be16(rt + 2); ws = [be16(rt + 4 + st * i + 8) for i in range(n)]
        assert 0x1E in ws and 0x42 in ws
        cs.append(cite(rt, "%04x %04x" % (st, n), "D"))
        i = ws.index(0x42 if hi - lo == 2 else 0x1E); cs.append(cite(rt + 4 + st * i + 8, "%04x" % ws[i], "D"))
    D(lo, hi, "C-read", "6-B records {u16 mul; u32 offset}", "12 x 6 B table 0x%06X (r3 = byte offset 6..0x42)" % base,
      "add.l #base,er3 ; mov.w @er3+,r6 ; mov.l @er3,er4 ; r3 = word +8 of the matched record of range tables 0x030B00/0x030BA4 (0x032442/0x0324E6), which hold 0x1E and 0x42", cs,
      "record 5 offset field / record 11 offset low word")
# 24 4 x 0x33 table 0x036116
assert 0x36116 + 4 * 0x33 == 0x361E2
D(0x03619E, 0x0361DA, "C-extent", "data bytes", "u8 table 0x036116[4][0x33] (next proven base 0x0361E2)",
  "er6 = er2*0x33 + er1 ; mov.b @(0x36116:32,er6) ; er1 <= 0x32 (clamp value at 0x03527C), er2 indexes 4-byte row tables 0x03541E/0x03542E",
  [cite(0x03534C, "78 20 6a 2c 00 03 54 1e"), cite(0x03535E, "79 04 00 33 0f a6 52 46 0a 96"), cite(0x035368, "78 60 6a 2e 00 03 61 16"),
   cite(0x03527C, "7a 01 00 00 00 32"), cite(0x03551A, "78 10 6a 2e 00 03 61 e2")], "rows 2-3")
# 25/26 no reader over 0x03624B..0x0377C1
D(0x03624B, 0x0377C2, "Inferred", "data bytes (byte curve tables)", "unknown 2-D byte tables",
  "Not found: no operand of any IDA code head, BE32 cell or abs24 call lands in 0x036219-0x0377C1; the only readers in the area are bases 0x03605A/6E/7E, 0x036116, 0x0361E2/EE/F2, 0x036218 with indices that stop at 0x036249",
  [cite(0x0354EA, "78 10 6a 2e 00 03 62 18"), cite(0x03527C, "7a 01 00 00 00 32")], "probably tables for a band plan this build does not use (Inferred)")
# 27 DTMF pair table 0x039040[16]
assert 0x39040 + 16 * 4 == 0x39080
D(0x039067, 0x039080, "C-extent", "u16 pairs (u32 cells)", "u32 table 0x039040[16] (two u16 tone words), ends at code 0x039080",
  "and.l #0xFF,er3 ; shll.l #2,er3 ; mov.l @(0x39040:32,er3),er4 ; r3l = 0x10 handled separately",
  [cite(0x038CF6, "ab 10 47 72"), cite(0x038D38, "7a 63 00 00 00 ff 10 73 78 b0 6b 24 00 03 90 40"), cite(0x039080, "6a 0a a9 e3")])
# 28 22-B channel records 0x04001C[19]
assert 0x4001C + 19 * 0x16 == 0x401BE
D(0x040035, 0x0401AC, "C-extent", "22-B records {u32 BCD freq; 18 B fields+JIS label}", "19 x 22 B table 0x04001C (next proven base 0x0401BE)",
  "mov.l #0x4001C,er2 ; er2 += 0x16*er3 ; mov.l @er2,er5 ; eepmov.w 0x12 bytes from er2+4",
  [cite(0x03CFFA, "7a 02 00 04 00 1c"), cite(0x03D0AA, "79 04 00 16 52 43 0a b2 01 00 69 25"), cite(0x03D0C4, "fc 12 0f a5 0b 95"),
   cite(0x03D0D2, "7b d4 59 8f"), cite(0x03D19A, "78 b0 6b 25 00 04 01 be")], "every record byte is read by one of the two loads")
# 29 BCD table 0x04020E
for lo, hi in ((0x040246, 0x040251), (0x040266, 0x040271)):
    D(lo, hi, "C-read", "BCD u32 cells", "u32 BCD table 0x04020E (indices 0x0B..0x1B = 466.35..466.55 MHz)",
      "mov.l @(0x4020E:32,er5),er5 with er5=r3*4; r3l tested in [0x0B,0x1C)",
      [cite(0x03D1CA, "0f b5 10 75 78 d0 6b 25 00 04 02 0e"), cite(0x03D1E2, "ab 0b 45 08 ab 1c 44 04"), cite(0x04023A, "46 63 50 00", "D")],
      "indices 14-16 / 22-24")
# 30 no reader
D(0x04BA2E, 0x04BA32, "Inferred", "data bytes 07 08 ff 00", "unknown", "Not found; follows the 17-slot jump table 0x04B9EA (0x04B8FE)",
  [cite(0x04B8FE, "78 b0 6b 26 00 04 b9 ea"), cite(0x04BA32, "7a 05 00 04 be 62")])
# 31 APRS device row 16 pad + unreferenced byte
assert 0x4C32E + 16 * 9 == 0x4C3BE
D(0x04C3C6, 0x04C3C7, "C-extent", "label pad byte", "row 16 ('-------' ff 00) of the 9-B APRS device-name rows 0x04C32C",
  "mov.w @er5+ (stride 9) ; er5 += 9*r3 ; copy until 0xFF -> the pad byte after the FF is never copied",
  [cite(0x04C2A8, "7a 05 00 04 c3 2c"), cite(0x04C2C0, "6d 54 f3 00 52 43 0a b5 6c 54 a4 ff 47 08"), cite(0x04C32C, "00 09", "D"),
   cite(0x04C3BE, "2d 2d 2d 2d 2d 2d 2d ff 00", "D")])
D(0x04C3C7, 0x04C3C8, "Inferred", "data byte", "head of 01 02 03 04 ff 05..09 ff byte list", "Not found", [cite(0x04C3C7, "01 02 03 04 ff 05 06 07 08 09 ff", "D")])
# 32 base-91 tables
for t, n in ((0x04E76C, 91), (0x04E822, 91), (0x04E8D8, 91)): pass
assert 0x4E822 + 182 == 0x4E8D8 and 0x4E8D8 + 182 == 0x4E98E and 0x4E98E + 91 * 4 == 0x4EAFA
for lo, hi in ((0x04E88A, 0x04E8B2), (0x04E8C0, 0x04E8C8), (0x04E8CF, 0x04E8D0), (0x04E8D5, 0x04E8D8)):
    D(lo, hi, "C-read", "u16 words", "u16 table 0x04E822[91] (index = char-0x21; purpose Inferred: APRS base-91 decode)",
      "r3l = char-0x21, bounded 0..0x5A (cmp.b #0x5B ; bcs), shll.b r3l, mov.w @(0x4E822:32,er3)",
      [cite(0x04CD30, "fc 21 18 cb 4b 04 ab 5b 45 04"), cite(0x04CD40, "10 0b"), cite(0x04CD4E, "78 30 6b 23 00 04 e8 22")])
for lo, hi in ((0x04E932, 0x04E966), (0x04E971, 0x04E972), (0x04E97C, 0x04E982), (0x04E987, 0x04E98E)):
    D(lo, hi, "C-read", "u16 words", "u16 table 0x04E8D8[91]",
      "same bounded index, mov.w @(0x4E8D8:32,er3)",
      [cite(0x04CD36, "ab 5b 45 04"), cite(0x04CD58, "78 30 6b 23 00 04 e8 d8")])
for lo, hi in ((0x04E9E6, 0x04E9F6), (0x04EA18, 0x04EA52), (0x04EAA8, 0x04EAB6)):
    D(lo, hi, "C-read", "u32 cells", "u32 table 0x04E98E[91] (next base 0x04EAFA)",
      "r1l = char-0x21 bounded 0..0x5A, shll.l #2,er1, mov.l @(0x4E98E:32,er1)",
      [cite(0x04CDE0, "fc 21 18 cb 4b 04 ab 5b 45 06"), cite(0x04CDF2, "0c b9"), cite(0x04CE2C, "10 71 78 90 6b 23 00 04 e9 8e"),
       cite(0x04CE4C, "78 90 6b 23 00 04 e9 8e"), cite(0x04CE12, "78 30 6b 24 00 04 ea fa")])
# 33-36 no reader
D(0x058FFE, 0x059000, "Inferred", "record header 1f 01", "first of the 32-B records 0x058FFE/0x05901E/0x05903E",
  "Not found for 0x058FFE; siblings 0x05901E/0x05903E are loaded at 0x058F86/0x058F94", [cite(0x058F86, "7a 04 00 05 90 1e"), cite(0x05901E, "1f 02", "D")])
D(0x05B370, 0x05B37C, "Inferred", "data bytes", "first half of a 24-B class map parallel to the 24-slot table 0x05B310",
  "Not found", [cite(0x0563DA, "78 b0 6b 26 00 05 b3 10"), cite(0x05B370, "00 00 00 00 00 00 00 01 01 01 01 02 02 02 02 02 03 03 03 03 03 00 02 00", "D")])
D(0x062598, 0x06259A, "Inferred", "data u16", "tail of 00 05 77 13 00 12 77 20", "Not found", [cite(0x062592, "00 05 77 13 00 12 77 20", "D")])
D(0x067FAF, 0x067FB0, "Inferred", "pad byte", "between the 5-byte FF block 0x067FAA (eepmov r4=5 at 0x00DF66) and 'DNEWS' 0x067FB0",
  "Not found (both neighbours have exact-length readers that stop short of it)",
  [cite(0x00DF62, "fc 05 f4 00 7a 05 00 06 7f aa"), cite(0x060412, "7a 06 00 06 7f b0 79 0c 00 05")])
# 37 version records
D(0x06C56E, 0x06C56F, "C-read", "record terminator 0x04", "55-byte version record 0x06C538 (01 'V0030FT3D'... '0C01' 04)",
  "eepmov.w r4=0x37 from er5=0x6C538 (0x06C538..0x06C56E)",
  [cite(0x06BD3E, "79 04 00 37 7a 05 00 06 c5 38"), cite(0x06BD4E, "7b d4 59 8f")])
D(0x06C56F, 0x06C570, "Inferred", "pad byte", "after record 0x06C538", "Not found", [cite(0x06C56E, "04 00 01 56", "D")])
D(0x06C596, 0x06C598, "Inferred", "record terminator 04 + pad", "end of record 0x06C570 ('V0020FT2D JPN Ver0202 20180418')",
  "Not found (record 0x06C570 has no reader; next record 0x06C598 is eepmov'd at 0x06BEBC)", [cite(0x06BEB8, "79 04 00 08 7a 05 00 06 c5 98")])
# 38 FF block
D(0x06F4B8, 0x06F4BA, "C-read", "data bytes", "16-byte block 0x06F4B6..0x06F4C5", "eepmov.w r4=0x10 from er5=0x6F4B6",
  [cite(0x06F472, "fc 10 f4 00 7a 05 00 06 f4 b6"), cite(0x06F482, "7b d4 59 8f")])
# 39 stale copy
D(0x069A7F, 0x069AAA, "Stale-copy", "stale code bytes (odd-aligned, not executable)",
  "37 B identical to proven sub_69964 head 0x069964-0x069988; 6 B variant tail; decodes at odd alignment through 0x069AB4",
  "Not executable (odd); eepmov source 0x069A4A (count 0x35 at 0x069A48) ends exactly at 0x069A7E",
  [cite(0x069964, "6a 0c b3 f5 1c 9c 46 04 6a 89 b3 f4 79 04 00 10 52 41 7a 11 00 ff 45 76 0f 95 7a 15 00 00 00 05 68 5c ac ff 47"),
   cite(0x069A7F, "6a 0c b3 f5 1c 9c 46 04 6a 89 b3 f4 79 04 00 10 52 41 7a 11 00 ff 45 76 0f 95 7a 15 00 00 00 05 68 5c ac ff 47", "D"),
   cite(0x069AA4, "0e 79 04 00 01 6b 84 b0 50 fb 0a 5e 05 e4 68 54 70", "D"), cite(0x069989, "02 40 06 7a 05 00 06 9a 4d"),
   cite(0x0699A6, "7a 05 00 06 9a 48"), cite(0x069A48, "00 35", "D"), cite(0x069914, "7a 06 00 06 99 64")])
assert img[0x069964:0x069964 + 37] == img[0x069A7F:0x069A7F + 37] and img[0x069964 + 37] != img[0x069A7F + 37]
assert 0x069A4A + 0x35 == 0x069A7F

# ---------------------------------------------------------------- tile L5 pieces
L5 = {}
for l in list(open(R + r"\ida\out\main-unnamed\runs.tsv", encoding="utf-8"))[1:]:
    p = l.rstrip("\n").split("\t"); L5[int(p[0], 16)] = (int(p[1], 16), p[4], p[9], p[8])
pieces = [(a, b, c) for a, b, n, c in pieces] + [(0x069A7F, 0x069AAA, "mid-instruction/garbage")]
rows = []
for a, b, c in pieces:
    assert a in L5 and L5[a][0] == b
    covered = 0
    for lo, hi, tier, typ, el, rd, cs, note in DEC:
        s, e = max(a, lo), min(b, hi)
        if s < e:
            rows.append((s, e, c, a, tier, typ, el, rd, "; ".join(cs), note)); covered += e - s
    assert covered == b - a, ("uncovered", hex(a))
rows.sort()
for s, e, *_ in rows: assert not any(NM[i] for i in range(s, e)), hex(s)
total = sum(e - s for s, e, *_ in rows)

# ---------------------------------------------------------------- descent deltas
dd = [l.rstrip("\n").split("\t") for l in list(open(O + r"\work\descent_delta.tsv", encoding="utf-8"))[1:]]
core = [(int(r[1], 16), int(r[2], 16)) for r in dd if r[0] == "core"]
comp = [(int(r[1], 16), int(r[2], 16)) for r in dd if r[0] == "companion"]
assert sum(e - s for s, e in core) == 148 and sum(e - s for s, e in comp) == 242

# ---------------------------------------------------------------- write
H = "start\tend_excl\tlen\tL5_class\tL5_piece\tm6_tier\ttyping\telement\treader_and_bound\tevidence\tnote\n"
with open(O + r"\pieces.tsv", "w", encoding="utf-8", newline="\n") as f:
    f.write(H)
    for s, e, c, a, tier, typ, el, rd, ev, note in rows:
        f.write("%06X\t%06X\t%d\t%s\t%06X\t%s\t%s\t%s\t%s\t%s\t%s\n" % (s, e, e - s, c, a, tier, typ, el, rd, ev, note))
by = {}
for s, e, c, a, tier, *_ in rows: by[tier] = by.get(tier, 0) + e - s
with open(O + r"\proposed-typing.tsv", "w", encoding="utf-8", newline="\n") as f:
    f.write("start\tend_excl\tlen\ttyping\ttyping_conf\tm6_tier\tnamed_delta\tdb_action\n")
    for s, e, c, a, tier, typ, el, rd, ev, note in rows:
        if tier == "Inferred": continue
        conf = {"C-read": "Confirmed", "C-extent": "Confirmed", "Proven-code": "Confirmed", "Stale-copy": "Confirmed (identity)"}[tier]
        act = {"C-read": "make data (%s)" % typ, "C-extent": "make data (%s)" % typ, "Proven-code": "create_insn from 0x%06X" % s,
               "Stale-copy": "make byte array, comment 'stale copy of sub_69964'"}[tier]
        f.write("%06X\t%06X\t%d\t%s\t%s\t%s\t+%d\t%s\n" % (s, e, e - s, typ, conf, tier, e - s, act))
    f.write("018FAA\t018FB0\t6\tcode\tConfirmed (companion)\tcompanion-proven\t+6\tcreate_insn (entry called by jsr @0x18faa from 0x017950..0x017984, reached only via companion record 0x01792E fields +4..+1C)\n")
with open(O + r"\proposed-proven.tsv", "w", encoding="utf-8", newline="\n") as f:
    f.write("set\tstart\tend_excl\tlen\tnamed_in_final6\tseed\n")
    for r in dd:
        s = int(r[1], 16)
        seed = {0x01687E: "record 0x01686E+8 (jmp sub_15260 at 0x01686A)", 0x0168BC: "record 0x01686E+C", 0x01A17C: "record 0x01686E+0 (AD9D!=0 path)",
                0x016ABE: "record 0x016AAE+4/+8/+C (jmp sub_15260 at 0x016AAA)", 0x01794E: "record 0x01792E+4..+1C (jmp sub_15260 at 0x01792A)",
                0x017AB6: "record 0x017AA6+4/+8/+C (jmp at 0x017AA2)", 0x018632: "record 0x018622+4/+8/+C (jmp at 0x01861E)",
                0x018FAA: "jsr @0x18faa at 0x017950/58/6C/74/7C/84 inside the 0x01794E run", 0x01A0D4: "record 0x01792E+0",
                0x05E812: "record 0x05E806+4/+8 (jmp at 0x05E802)"}[s]
        f.write("%s\t%s\t%s\t%s\t%s\t%s\n" % (r[0], r[1], r[2], r[3], r[4], seed))
with open(O + r"\verify.txt", "w", encoding="utf-8", newline="\n") as f:
    f.write("citations failed: %d\n" % len(FAILS) + "".join("  " + x + "\n" for x in FAILS))
    f.write("pieces in: %d (+ fragment), rows out: %d, bytes: %d\n" % (len(pieces) - 1, len(rows), total))
    for k in sorted(by): f.write("  %-12s %5d B\n" % (k, by[k]))
    f.write("named delta, Confirmed typing (C-read + C-extent + Proven-code): %d\n" % (by.get("C-read", 0) + by.get("C-extent", 0) + by.get("Proven-code", 0)))
    f.write("named delta, stale copy (separate decision): %d\n" % by.get("Stale-copy", 0))
    f.write("proven delta core: %d (%s)\n" % (sum(e - s for s, e in core), ", ".join("%06X-%06X" % (s, e - 1) for s, e in core)))
    f.write("proven delta companion: %d (%s)\n" % (sum(e - s for s, e in comp), ", ".join("%06X-%06X" % (s, e - 1) for s, e in comp)))
    f.write("named delta companion (0x018FAA dead-code piece): 6\n")
print(open(O + r"\verify.txt", encoding="utf-8").read())
