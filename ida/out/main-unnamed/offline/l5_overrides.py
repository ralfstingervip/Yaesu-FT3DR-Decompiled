from pathlib import Path as _Path
_REPO = _Path(__file__).resolve().parents[4]
# Lane L5: hand adjudications (after reading bytes, oracle decode and reference scans). Writes overrides.tsv.
# Each entry: run_start -> list of pieces (start, end_excl, class, sub, conf, evidence, typing, typing_conf).
# Pieces must tile the run exactly (checked by l5_classify.py).
import sys
sys.path.insert(0, str(_REPO) + r"/ida/out/main-unnamed/offline")
from l5_lib import *

VT, ST, PT, RS, DC, MI, FL, RG, UN = ("value table", "string/label", "pointer table", "record struct", "dead code",
                                      "mid-instruction/garbage", "padding/fill", "reached-code gap", "Unknown")
C, I = "Confirmed", "Inferred"
OV = {}


def hx(a, b, n=24): return img[a:min(b, a + n)].hex(" ")


def one(a, b, cls_, sub, conf, ev, typing="", tc=""):
    OV.setdefault(a, []).append((a, b, cls_, sub, conf, ev, typing, tc))


def piece(run, a, b, cls_, sub, conf, ev, typing="", tc=""):
    OV.setdefault(run, []).append((a, b, cls_, sub, conf, ev, typing, tc))


def whole(a, n, cls_, sub, conf, ev, typing="", tc=""):
    one(a, a + n, cls_, sub, conf, "bytes %s; %s" % (hx(a, a + n), ev), typing, tc)


# ---------- value tables ----------
whole(0x000E20, 2, VT, "last u16 (0x319C) of 4-B pair table 0x000E00", I, "table 0x000E00 = 0708 0012|0708 0024|0E10 0036|... second halves step 0x12; code resumes 0x000E22", "data", I)
whole(0x005796, 18, VT, "embedded byte table between rts 0x005794 and proven 0x0057A8", I, "oracle hits .word at 0x005796; 3 x 5-B groups a0 8x 8x e3 e8; 0 inbound refs", "data", I)
whole(0x0058AF, 15, VT, "continuation of BCD word table 0x00585A", C, "table 0x00585A loaded by proven mov.l #0x585A,er5 at 0x026058 (7a 05 00 00 58 5a); BCD words continue 2007..2541 without break", "data", C)
for a in (0x006529, 0x006565, 0x0065DD):
    whole(a, 3, PT, "low 3 B of a 00FFxxxx RAM-pointer cell", C, "table 0x0064F0.. of BE32 RAM addresses (00 ff ba a2, 00 ff 8d d5 ...); cell %06X = %s" % (a - 1, hx(a - 1, a + 3)), "BE32 cell", C)
whole(0x00B82C, 4, VT, "u16 pair inside zero-padded label/record block", I, "neighbours 0x00B800-0x00B83F are named label/record bytes", "data", I)
whole(0x00F01E, 2, VT, "interior of table 0x00F010 (starts 96 69 = market magic)", I, "0x00F010 referenced by proven code (run 0x00F010 evidence); 0x00F020.. continues the BE32 table", "data", I)
whole(0x00F188, 24, VT, "interior of BE32 BCD band-edge table 0x00F0A2..", I, "neighbours 00 00 17 40 / 00 00 12 00 ...; doc 97 reads windows from 0x00F0A2", "data", I)
whole(0x00F6A3, 21, VT, "interior of BE32 value table 0x00F660..", I, "cells 00 00 00 50 / 00 00 00 76 / 00 00 00 16 between named cells", "data", I)
whole(0x015192, 1, VT, "byte inside list 0x015164 (K5 DIGITAL row list)", I, "list 0x015164.. referenced by proven code (run 0x015164 evidence)", "data", I)
whole(0x01682E, 30, VT, "u16 left-justified bit-mask table {0x0000,0x8000..0xFFFE}", C, "base 0x01682C loaded by proven mov.w @(0x1682c:32,er?) at 0x016812 (bytes 6b 24 00 01 68 2c)", "data", C)
whole(0x01E226, 6, VT, "BCD frequency table interior (continues into fnindex-only proven 0x01E22C)", I, "84 60 90 10 96 10 between named BCD cells 84 90 89 40 96 60 ...", "data", I)
for a, n in ((0x025335, 2), (0x025341, 1)):
    whole(a, n, VT, "byte table 0x025334-0x025341 between rts 0x025332 and proven 0x025342", I, "06 06 06 06 05 06 05 05 05 04 06 05 05 05", "data", I)
for a, n in ((0x02554B, 18), (0x02555F, 6)):
    whole(a, n, VT, "interior of 4-B record table 0x025522-0x02556D", I, "records 00 0x 0y 05 / ff 0x 0y 05; table cell 0x025546 pointed to by named dword 0x0254B6", "data", I)
for a, n in ((0x025C2A, 2), (0x025C5C, 2), (0x025C66, 4)):
    whole(a, n, VT, "BCD word table 0x025C00.. interior", I, "words 15 00 / 18 75 / 31 25 / 37 50 / 56 25 / 62 50 ... (BCD)", "data", I)
for a, n in ((0x02C7A2, 5), (0x02C8F3, 3)):
    whole(a, n, VT, "binary fields inside a label-record table", I, "between named space-padded labels", "data", I)
for a, n in ((0x02FA54, 4), (0x02FA7A, 2), (0x0314FC, 4), (0x031522, 2)):
    whole(a, n, VT, "interior of u16/u32 parameter table", I, "named cells 02 bc 00 03 34 50 01 f4 ... surround", "data", I)
whole(0x034530, 2, VT, "last u16 of 1-2-5 step table 0x03451E", C, "0005 000a 0014 0032 0064 00c8 01f4 03e8 07d0 (5..2000); next is rts 0x034532", "data", C)
for a, n in [(0x03619E, 60), (0x03628D, 7), (0x03629A, 4), (0x0362A8, 6), (0x0362BC, 2), (0x0362D8, 4), (0x0362F4, 2), (0x036338, 6),
             (0x036346, 6), (0x036354, 6), (0x036362, 6), (0x036372, 18), (0x03638C, 6), (0x0363AA, 2), (0x0367BE, 2), (0x0367F0, 7),
             (0x036980, 4), (0x0369E4, 6), (0x036A16, 2), (0x036A7A, 4), (0x036ADE, 6), (0x036B4A, 6)]:
    whole(a, n, VT, "byte curve table 0x036100-0x036B60 interior", I, "monotone byte runs (1e/1f, 1a/1b, 19/1b ...) between named table bytes; IDA crefs into it come from mis-decoded table bytes", "data", I)
whole(0x0379E8, 26, VT, "BCD frequency table 0x037988-0x037A13 (unproven part)", C, "base 0x037988 loaded by proven mov.l #0x37988,er6 at 0x03793E (7a 06 00 03 79 88) then jsr 0x03F5B2; cells 1740 0000 4314 0000 ...", "data", C)
whole(0x039067, 25, VT, "u16-pair table 0x039040.. interior", I, "24 c2 34 30 1b 3a 2f 3a ... between named cells", "data", I)
whole(0x03F1C6, 22, VT, "u16 table at 0x03F1C4", C, "base 0x03F1C4 loaded by proven mov.w @(0x3f1c4:32,er4),r4 at 0x03F196 and 0x03A8AE", "data", C)
for a in (0x040035, 0x04004B, 0x040061, 0x040077, 0x04008D, 0x0400A3, 0x0400B9, 0x040153, 0x040169, 0x04017F, 0x040195):
    whole(a, 3, VT, "22-B record table 0x03FFF4.. interior (04 aa aa field)", I, "stride 0x16 records ... 37 04 aa aa 4e 73 ...", "data", I)
for a in (0x0400CE, 0x0400E4, 0x0400FA, 0x040110, 0x040126, 0x04013C):
    whole(a, 4, VT, "22-B record table 0x03FFF4.. interior (xx 04 aa aa field)", I, "stride 0x16 records", "data", I)
whole(0x0401AA, 2, VT, "22-B record table interior", I, "00 04 field", "data", I)
for a in (0x040246, 0x040266):
    whole(a, 11, VT, "BCD frequency table 0x0401FE.. interior", I, "46 63 75 00 46 63 87 50 ... (BCD 466.375 ...)", "data", I)
piece(0x04BA2C, 0x04BA2C, 0x04BA2E, PT, "low half of BE32 cell 0x04BA2A -> 0x04B908", C, "cell 00 04 b9 08", "BE32 cell", C)
piece(0x04BA2C, 0x04BA2E, 0x04BA32, VT, "small value record after pointer table 0x04BA0E", I, "07 08 ff 00", "data", I)
whole(0x04C3C6, 2, VT, "head of byte table 0x04C3C6 (00 01 02 03 04 ff 05 06 07 08 09 ff)", C, "the rest of this table, 0x04C3C8-0x04C3D1, is in final4_proven_mask (fnindex-only run 0x04C3C8) although it is data", "data", I)
for a, n in ((0x04E88A, 40), (0x04E8C0, 8), (0x04E8D5, 3), (0x04E932, 52), (0x04E97C, 6), (0x04E987, 7), (0x04E9E6, 16), (0x04EA18, 58), (0x04EAA8, 14)):
    whole(a, n, VT, "monotone u16/u32 curve tables 0x04E88A-0x04EAC0", I, "strictly increasing values; neighbouring bases 0x04E8D8 (proven mov.w at 0x04CD58) and 0x04E98E (proven mov.l at 0x04CE2E/0x04CE50) are referenced", "data", I)
for a, n in ((0x050120, 6), (0x050142, 4)):
    whole(a, n, VT, "identity byte ramp 0x050106 (00..3B) interior", C, "base 0x050106 loaded by proven add.l (run 0x050106 evidence); ramp continuous", "data", C)
whole(0x058FFE, 2, VT, "record header 1f 01 before zero-filled 32-B records 0x059000", I, "next records start 1f 02 at 0x05901E", "data", I)
whole(0x06B495, 2, VT, "byte table 0x06B494 (12 0e 34 30 1a 16 3c 38)", C, "base 0x06B494 loaded by proven code at 0x06B46C (be32 0x06B470)", "data", C)
whole(0x06B49B, 1, VT, "byte table 0x06B494 last byte", C, "base 0x06B494 loaded by proven code at 0x06B46C", "data", C)
for a in (0x06C56E, 0x06C596):
    whole(a, 2, VT, "binary field (04 00) inside version-string records 0x06C540..", I, "'0C01' 04 00 01 'V0020FT2D' ...", "data", I)
for a in (0x06CD1B,):
    whole(a, 2, RS, "interior of 6-B settings record 0x06CD1A {0003; 00FF8DE7}", C, "record 00 03 00 ff 8d e7; 0x06CD1A-1F", "struct", C)
whole(0x06CD1E, 2, RS, "tail of 6-B settings record 0x06CD1A", C, "record 00 03 00 ff 8d e7", "struct", C)
whole(0x06D017, 2, RS, "interior of 6-B settings record 0x06D016 {001F; 00FF8DE2}", C, "record 00 1f 00 ff 8d e2", "struct", C)
whole(0x06D01A, 2, RS, "tail of 6-B settings record 0x06D016", C, "record 00 1f 00 ff 8d e2", "struct", C)
whole(0x06F4B8, 2, VT, "u16 0x0001 inside 0xFF-filled block", I, "ff ff ff ff 00 01 ff ff", "data", I)
# ---------- records ----------
piece(0x0048C0, 0x0048C0, 0x0048D8, PT, "6 BE32 pointers to label records 0x0048D8-0x0048F8", C,
      "cells 00 00 48 e0 / 48 d8 / 48 e0 / 48 e8 / 48 f0 / 48 f8; each target is a {u16 3; 'VFO''VDR'} style record; 0 inbound refs to 0x0048C0", "BE32 offsets", C)
piece(0x0048C0, 0x0048D8, 0x0048DA, RS, "u16 count header (3) of label record 0x0048D8", C, "00 03 'VFO' 'VDR'", "struct", C)
for a in (0x0048E8, 0x0048F8):
    whole(a, 2, RS, "u16 count header (3) of label record", C, "record %s" % hx(a, a + 8), "struct", C)
whole(0x004C12, 2, ST, "u16 length header (0x15) of the 21-char label at 0x004C14", C, "00 15 then 20 spaces + ff", "string", C)
whole(0x005B2E, 4, ST, "last 4 chars of the 16-dash label 0x005B22", C, "2d x16 then code at 0x005B32", "string", C)
piece(0x016870, 0x016870, 0x016872, PT, "low half of BE32 cell 0x01686E -> 0x01A17C (field 0 of record 0x01686E)", C, "cell 00 01 a1 7c", "BE32 cell", C)
piece(0x016870, 0x016872, 0x01687E, RS, "pointer record 0x01686E {0x01A17C, NULL, 0x01687E, 0x0168BC}", C,
      "proven mov.l #0x1686E,er5 at 0x016864 then jmp @0x015260 (7a 05 00 01 68 6e 5a 01 52 60); cells 00 00 00 00 00 01 68 7e 00 01 68 bc", "struct", C)
piece(0x016870, 0x01687E, 0x0168B4, RG, "record-field target 0x01687E (call-through Inferred)", I,
      "pointer 0x01687E sits at +8 of record 0x01686E handed by proven code to 0x015260; body 6a 0a ad 9c 7a 62 ... bra 0x0168F8; clean decode 20 insns", "code", I)
piece(0x016902, 0x016902, 0x016904, VT, "last u16 (0000) of record 0x0168FA", I, "00 01 00 00 00 23 00 59 00 00", "data", I)
piece(0x016902, 0x016904, 0x01690A, DC, "unreferenced alternate entry falling into 0x01690A", C,
      "5e 01 51 ec 47 2a = jsr @0x151ec; beq; 0x01690A is a jsr target (proven 0x015C0A); 0 refs to 0x016904 (BE32, abs24, branch)", "code (unreferenced)", I)
piece(0x017530, 0x017530, 0x017536, RS, "6-B settings record {0004; 00FF89CF}", C, "00 04 00 ff 89 cf; referenced only by mov.l #0x17530 at 0x01751E inside dead run 0x017518", "struct", C)
piece(0x017530, 0x017536, 0x017538, DC, "orphan rts after record", I, "54 70; 0 refs", "code (unreferenced)", I)
whole(0x018655, 3, RS, "interior of 6-B settings record 0x018654 {0002; 00FF8ABF}", C, "record 00 02 00 ff 8a bf loaded by proven mov.l #0x18654 at 0x01863A", "struct", C)
whole(0x01AE1D, 3, PT, "low 3 B of BE32 cell 0x01AE1C -> 0x01AE44", C, "cell 00 01 ae 44; table continues 00 01 ae 52 ...", "BE32 cell", C)
whole(0x01B88D, 3, PT, "low 3 B of BE32 cell 0x01B88C -> 0x01B8C0", C, "cell 00 01 b8 c0; table continues 00 01 b8 ce ...", "BE32 cell", C)
for a in (0x01B629, 0x01B98D):
    whole(a, 5, ST, "JIS X 0208 2-byte label record {u16 n; codes 0x2121}", I, "00 01 21 21 21 21 (0x2121 = JIS ideographic space) among 0x21xx/0x23xx/0x24xx label records", "string", I)
whole(0x02010A, 2, RS, "tail of 8-B record 0x020104 {u16 0x0384; u16 0x03E6; ptr 00FFAC34}", C, "record 03 84 03 e6 00 ff ac 34 loaded by proven mov.l #0x20104,er6 at 0x0200F8", "struct", C)
whole(0x020104, 5, RS, "head of 8-B record 0x020104", C, "loaded by proven mov.l #0x20104,er6 at 0x0200F8 (7a 06 00 02 01 04)", "struct", C)
whole(0x020CCB, 23, PT, "BE32 pointer cells 0x020CCA.. (-> 0x020D50, 0x020D5E, 0x020D76, 0x020D84, 0x020D84, 0x020D9C)", C, "cells 00 02 0d 50 ...", "BE32 offsets", C)
whole(0x023690, 2, RS, "tail of 6-B settings record 0x02368C {0203; 00FFAD95}", C, "record loaded by proven mov.l #0x2368C at 0x02366E", "struct", C)
whole(0x052A72, 4, PT, "last BE32 cell of table 0x052A5E -> 0x052ACE", C, "00 05 2a ce; preceding cells 00 05 2a 76 / 82 / 8e / a6 / ba", "BE32 cell", C)
whole(0x053682, 4, PT, "last BE32 cell of table 0x05365E -> 0x0536D6", C, "00 05 36 d6; preceding cells 00 05 35 74 ... 36 c2", "BE32 cell", C)
for a, n in ((0x044C56, 8),):
    whole(a, n, ST, "u16 length (0x0E) + start of 14-char label", C, "00 0e 20 20 20 20 20 06 | 20 20 2e 20 20 20 27 ff", "string", C)
for a, n in ((0x04B495, 3), (0x04B4A3, 3)):
    whole(a, n, ST, "terminator / u16 count of label list ('-.-km' 'mi')", C, "00 08 ' -.-km' ff ' -.-mi' ff 00 05 ... 00 03 'km' ff 'mi' ff", "string", C)
for a, n in ((0x04C74D, 3), (0x04FDAE, 2), (0x062240, 2), (0x06732E, 2), (0x0677E6, 4), (0x04E59F, 3)):
    whole(a, n, ST, "length header / tail of adjacent label", C, "context %r | %r" % (img[a - 8:a].decode("latin1"), img[a + n:a + n + 8].decode("latin1")), "string", C)
# ---------- K3 touch / screen records ----------
for a in (0x028B6C, 0x028BB4, 0x028BF0, 0x028C2A, 0x028C62, 0x028C8A):
    whole(a, 32, RS, "32-B screen record (8 BE32 fields: handlers / labels)", C,
          "loaded by proven mov.l #0x%06X,er1 just before (doc 72/85 record dispatch 0x028CBC); fields are BE32 code/label pointers" % a, "struct", C)
# ---------- split runs ----------
piece(0x008352, 0x008352, 0x00835E, ST, "tail of label 'MUTE : TX       '", C, "20 3a 20 54 58 20 20 20 20 20 20 20 after named 'MUTE : RX' / 'MUTE : ALL' labels", "string", C)
piece(0x008352, 0x00835E, 0x00840C, DC, "unreferenced routine 0x00835E (rts 0x00840A)", C, "fd 00 6a 10 8d e0 ...; clean decode 56 insns; 0 refs to 0x00835E (BE32, abs24, branch from any IDA code head)", "code (unreferenced)", I)
piece(0x009B34, 0x009B34, 0x009B3A, VT, "tail of byte ramp table (..1a 1b | 1c 1d 1e 1f 20 00)", I, "continues named ramp 0x16 0x17 ... 0x1b", "data", I)
piece(0x009B34, 0x009B3A, 0x009B5A, DC, "unreferenced routine 0x009B3A (rts 0x009B58)", C, "fa 19 6a 0c b3 eb ...; 0 refs to 0x009B3A", "code (unreferenced)", I)
piece(0x0174BE, 0x0174BE, 0x0174C4, RS, "6-B settings record {0001; 00FF89CC}", C, "loaded by mov.l #0x174BE at 0x0174AC (named, unproven code)", "struct", C)
piece(0x0174BE, 0x0174C4, 0x0174D0, DC, "unreferenced fragment jsr/beq/jsr 0x3FFA0/rts", C, "5e 01 51 ec 47 04 5e 03 ff a0 54 70; 0 refs to 0x0174C4", "code (unreferenced)", I)
piece(0x017588, 0x017588, 0x01758E, RS, "6-B settings record {0002; 00FFBA33}", C, "loaded by mov.l #0x17588 at 0x01757C (named, unproven code)", "struct", C)
piece(0x017588, 0x01758E, 0x01759A, DC, "callback 0x01758E registered only by unproven code", C, "fc 00 6a 8c ba 33 5e 01 a0 a4 54 70; only ref: mov.l #0x1758E,er1 at 0x017570 (named, unproven)", "code (unreferenced from proven)", I)
piece(0x0235FC, 0x0235FC, 0x023604, RS, "8-B record {ffc0; 0040; ptr 00FFAA56}", C, "loaded by proven mov.l #0x235FC,er6 at 0x0235DE (7a 06 00 02 35 fc)", "struct", C)
piece(0x0235FC, 0x023604, 0x02361E, DC, "unreferenced routine 0x023604 (rts 0x02361C)", C, "5e 03 ed aa 0f c2 68 2b ...; 0 refs to 0x023604", "code (unreferenced)", I)
piece(0x0235FC, 0x02361E, 0x023624, RS, "6-B settings record {013F; 00FFAA56}", C, "loaded only by mov.l #0x2361E inside dead routine 0x023604", "struct", C)
piece(0x050B34, 0x050B34, 0x050B3A, RS, "6-B settings record {0004; 00FFA507}", C, "loaded by proven mov.l #0x50B34,er6 at 0x050B1C", "struct", C)
piece(0x050B34, 0x050B3A, 0x050B54, DC, "unreferenced routine 0x050B3A (rts 0x050B52)", C, "6a 0c ad 68 ac 02 45 0c ...; 0 refs to 0x050B3A", "code (unreferenced)", I)
piece(0x04FB40, 0x04FB40, 0x04FB44, ST, "length-prefixed label {u16 2; 'TX'}", C, "00 02 54 58 loaded by proven mov.l #0x4FB40,er5 at 0x04FB24", "string", C)
piece(0x04FB40, 0x04FB44, 0x04FB4A, DC, "unreferenced fragment jsr @0x619C; rts", C, "5e 00 61 9c 54 70; 0 refs to 0x04FB44", "code (unreferenced)", I)
piece(0x04BE9D, 0x04BE9D, 0x04BEBC, ST, "label list tail (ff 00 0e '  ---.--.--' ...)", C, "0x04BE9E loaded by proven mov.l at 0x048AE2/0x04BF7E/0x04C076/0x04D68E/0x04D6F0", "string", C)
piece(0x04BE9D, 0x04BEBC, 0x04BEDC, DC, "unreferenced routine 0x04BEBC (rts 0x04BEDA)", C, "ab 30 45 18 ab 3a 45 10 ...; 0 refs to 0x04BEBC", "code (unreferenced)", I)
piece(0x076C04, 0x076C04, 0x076C06, MI, "mask hole: last 2 B of IDA insn 0x076C00 (6 B mov.w #0,@0xff6314:32)", C, "item 6b f0 00 ff 63 14; 0x076C00-03 named", "already typed in DB (mask correction)", C)
piece(0x076C04, 0x076C06, 0x076C0A, DC, "USB-module routine tail pop/rts, reached only from unproven 0x076BE8", C, "6d 72 54 70; branch 0x076BE8 beq -> 0x076C06 (named, unproven USB module; doc 72: module reached only via closed-window table)", "code", I)
piece(0x01E1C2, 0x01E1C2, 0x01E1C6, MI, "operand tail of named insn 0x01E1BE (mov.w @(0x1e1de:32,er3),r6)", C, "78 b0 6b 26 | 00 01 e1 de", "code (extend insn)", C)
piece(0x01E1C2, 0x01E1C6, 0x01E1DE, DC, "tail of unproven routine 0x01E1A4 (rts 0x01E1DC)", C, "01 10 6d 75 40 06 7a 06 96 51 00 00 ...; 0 refs into 0x01E1A4-0x01E1DD", "code (unreferenced)", I)
piece(0x062598, 0x062598, 0x06259A, VT, "last u16 of record 0x062592 (00 05 77 13 00 12 77 20)", I, "77 20", "data", I)
piece(0x062598, 0x06259A, 0x0625F6, DC, "routine 0x06259A (rts 0x0625F4), reached only from unproven jsr @0x625D0 at 0x062624", C, "f2 10 fa 00 7a 01 ...; 0 refs to 0x06259A; jsr @0x625d0 from 0x062624 (named, unproven)", "code (unreferenced from proven)", I)
whole(0x046482, 176, DC, "unreferenced case-stub routine 0x046482, falls into fnindex-only proven 0x046532", C, "6a 18 aa 33 72 60 40 08 ...; clean decode 57 insns; 0 refs to 0x046482", "code (unreferenced)", I)
whole(0x004894, 16, DC, "unreferenced fragment after rts 0x004892, flows into proven 0x0048A4", C, "fc 00 6a 8c aa 3c 6a 10 b0 56 73 00 46 08 40 06; only IDA branch into it comes from table bytes 0x0048C6 decoded as bvc", "code (unreferenced)", I)
# ---------- 0x06B4B0 / 0x06B670 named-but-undecoded routines (mask shredded) ----------
for a, n in [(0x06B4B0, 1), (0x06B4CD, 4), (0x06B4D7, 2), (0x06B4DB, 2), (0x06B4DF, 4), (0x06B4E5, 18), (0x06B4FD, 4), (0x06B50D, 2),
             (0x06B511, 4), (0x06B531, 6), (0x06B53D, 4)]:
    whole(a, n, MI, "byte hole in named routine 0x06B4B0-0x06B555 (IDA undecoded; 0 inbound refs)", C,
          "oracle decodes 0x06B4B0.. cleanly to jmp @er6 via tables 0x06B556/0x06B582/0x06B5AA; neighbouring bytes of the same insns are named", "code (mask correction)", C)
for a, n in [(0x06B670, 1), (0x06B673, 4), (0x06B679, 4), (0x06B67F, 18)]:
    whole(a, n, MI, "byte hole in named routine 0x06B670-0x06B699 (IDA undecoded; 0 inbound refs)", C,
          "oracle: mov.w #0,r4; mov.w r4,@b050; ... rts 0x06B698; neighbouring bytes of the same insns are named", "code (mask correction)", C)
whole(0x016AD7, 3, MI, "operand bytes of named insn 0x016AD6 (6e 0c 00 51 mov.b @(0x51,er0),r4l)", C, "0x016AD6 named, 0x016AD7-9 residue", "code (extend insn)", C)
whole(0x050735, 1, MI, "operand byte of named insn 0x050734 (4b 08 bmi)", C, "named IDA-undecoded code 0x05071C..", "code (extend insn)", C)
whole(0x069A7F, 43, MI, "odd-aligned instruction-like bytes after a 0x20-filled label buffer", C,
      "starts at odd address 0x069A7F; H8S/H8SX instructions are word-aligned, so these bytes cannot execute in place; 0 refs", "", "")


def write():
    with open(O + r"\offline\overrides.tsv", "w", encoding="utf-8", newline="\n") as f:
        f.write("# start\tend_excl\tclass\tsub\tconf\tevidence\ttyping\ttyping_conf  (written by l5_overrides.py)\n")
        for k in sorted(OV):
            for (a, b, c, sub, conf, e, t, tc) in OV[k]:
                f.write("%06X\t%06X\t%s\t%s\t%s\t%s\t%s\t%s\n" % (a, b, c, sub, conf, e.replace("\t", " "), t, tc))
    print("overrides", sum(len(v) for v in OV.values()), "pieces for", len(OV), "runs")


write()
whole(0x016AF6, 10, RS, "two 6-B settings records {0304; 00FFAA56} (second one's tail named)", C, "03 04 00 ff aa 56 | 03 04 00 ff", "struct", C)
whole(0x01798A, 4, RS, "head of 6-B settings record {0002; 00FF8AAD}", C, "00 02 00 ff | 8a ad", "struct", C)
for a in (0x04FDF2, 0x04FDF6):
    whole(a, 2, ST, "piece of label list '[1: [2: ... [8: '", C, "5b 33 3a 20 5b 34 3a 20", "string", C)
write()

# ---------- second adjudication pass (records / labels mis-typed as plain value tables) ----------
whole(0x01770C, 8, RS, "8-B record {u16 0; u16 0x0400; ptr 00FFBA76}", C, "loaded by proven mov.l #0x1770C,er6 at 0x017700", "struct", C)
whole(0x01818A, 4, RS, "tail of record 0x018186 {2F5C; 00FFAA56} + head of record 0x01818C {217E; 00FF8AC1}", C, "0x01818C loaded by proven mov.l at 0x0180EC", "struct", C)
whole(0x01BA30, 7, RS, "tail of record 0x01BA2C {20F9; 00FFAA56} + record 0x01BA32 {207E; 00FFAA56} head", C, "0x01BA32 loaded by mov.l at 0x01B9E4 (named, unproven)", "struct", C)
for a, n in ((0x01FBEA, 4), (0x01FBF0, 6), (0x01FBF8, 18)):
    whole(a, n, RS, "8-B records {u32 value; ptr 00FFAC34} at 0x01FBEA..0x01FC09", C, "records 00 00 04 4b 00 ff ac 34 / 00 00 04 63 00 ff ac 34 / 00 00 00 55 00 ff ac 34 / 00 00 00 17 00 ff ac 34, loaded by proven mov.l at 0x01FB86/0x01FB90/0x01FB9E/0x01FBAC/0x01FBB6", "struct", C)
whole(0x022120, 8, RS, "8-B record {u32 0x44A; ptr 00FFAD64}", C, "loaded by proven mov.l #0x22120 at 0x022114", "struct", C)
whole(0x025040, 5, RS, "head of 6-B settings record {0002; 00FF89xx}", C, "loaded by proven mov.l #0x25040 at 0x025028", "struct", C)
whole(0x046B5A, 10, RS, "tail of record 0x046B56 {0204; 00FF9D42} + 8-B record 0x046B5C {u32 0x10; ptr 00FF9D38}", C, "0x046B5C loaded by mov.l at 0x046B3E (named, unproven)", "struct", C)
whole(0x06CCEE, 5, RS, "head of 6-B settings record {0001; 00FF8Dxx}", C, "loaded by proven mov.l #0x6CCEE at 0x06CCC2", "struct", C)
whole(0x00DB40, 24, ST, "dash / blank label fields ('----', '----------------')", C, "loaded by proven mov.l #0xDB40 at 0x00DA8E", "string", C)
whole(0x04BE62, 8, ST, "u16 length (0x0E) + start of 14-char label", C, "loaded by proven mov.l at 0x04BA32 and ~47 other sites", "string", C)
for a, n in ((0x04C693, 3), (0x04C73D, 5), (0x04E527, 3)):
    whole(a, n, ST, "label terminator ff + u16 length (0x0E) of next label", C, "next label text follows; length word read by proven code (IDA drefs from 0x04CC84/0x04CC08/0x04E47A)", "string", C)
whole(0x04FBAE, 2, ST, "u16 length header of label '*  0/51/52/...'", C, "loaded by proven mov.l #0x4FBAE at 0x04FB5C", "string", C)
whole(0x04FBC6, 6, ST, "length-prefixed label {u16 4; 'MSG '}", C, "loaded by proven mov.l #0x4FBC6 at 0x04FB7E", "string", C)
whole(0x05DDEC, 3, ST, "label 'ALL' (FF-padded)", C, "loaded by proven mov.l #0x5DDEC at 0x063B78/0x063C98/0x063CF4", "string", C)
for a in (0x01AE52, 0x01AE68, 0x01AE7E, 0x01AED6, 0x01AF46, 0x01AF5C, 0x01AF72, 0x01AFCA):
    assert img[a] == 0 and 0x21 <= img[a + 2] <= 0x25, hex(a)
    whole(a, 2, ST, "u16 count header of JIS X 0208 2-byte label record", C, "pointed to by the BE32 cell table 0x01AE1C../0x01AF10..; codes 0x24xx/0x25xx follow", "string", C)
write()
# ---------- closed window 0x078106-0x07B753 (doc 95) ----------
whole(0x078546, 90, "closed-window interior", "switch offset table: 45 x u16 for 'bra r0.w' at 0x076308", C,
      "loaded by proven mov.w @(0x78546:32,..) at 0x0762FE (be32 0x076302); offsets 0000 001c 0036 ... 0496 (doc 95 switch-078546.tsv)", "u16 offset table", C)
for a, n in ((0x0785A7, 30), (0x0785CA, 5), (0x0785D4, 3)):
    whole(a, n, "closed-window interior", "16-B nibble->code maps 0x0785A0/B0/C0/D0", C,
          "indexed by proven mov.b @(0x7859x:32,r0l.b),r1l at 0x0761B8/0x0761AE/0x0761A4/0x07619A (doc 95 l.213)", "byte table", C)
write()
# ---------- IDA 'code' items that sit in label / table data ----------
for a in (0x04C336, 0x04C348, 0x04C37E, 0x04C391, 0x04C3A3):
    whole(a, 1, ST, "byte of APRS device-ID label table (TH-D7 / TM-D700 / VX-8G / FTM-400D ...); IDA mis-typed it as code", C,
          "context %r | %r" % (img[a - 8:a].decode("latin1"), img[a + 1:a + 9].decode("latin1")), "string", C)
for a in (0x04E29B, 0x04E2B9):
    whole(a, 1, ST, "low byte of u16 length 0x000E of label (ff 00 0e 'RainD'/'RainN')", C,
          "context %r | %r" % (img[a - 8:a].decode("latin1"), img[a + 1:a + 9].decode("latin1")), "string", C)
whole(0x067FAF, 1, ST, "byte before label 'DNEWS' in a 0xFF/0x00-padded label block", I, "context ff ff ff ff ff | 00 | 'DNEWS'", "string", I)
whole(0x004399, 1, FL, "0x00 inside an 0xFF fill block (IDA item ff 00 at 0x004398)", C, "context ff x8 | 00 | ff x8", "", "")
for a in (0x04E8CF, 0x04E971):
    whole(a, 1, VT, "byte of monotone u16 curve table (IDA mis-typed as code)", I, "context %s" % img[a - 6:a + 6].hex(" "), "data", I)
whole(0x04E992, 2, VT, "high half of u32 entry 0x04E992 (0x0000000C) of table 0x04E98E", C, "table base 0x04E98E loaded by proven mov.l at 0x04CE2E/0x04CE50; cells 00 00 00 0a | 00 00 00 0c ...", "data", C)
write()
