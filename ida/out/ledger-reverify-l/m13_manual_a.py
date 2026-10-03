# M13 manual citation rows, group A: docs 98-103, RESUME-FULL.md lines 12-216 (L wave), l-wave-recon README.md.
# (doc file, anchor text on the line, address, kind, expected, note)
# kind: bytes ('??' wildcard, '…' gap) | be32 | le32 | ascii (bytes) | na (uncheckable) | drop | regrade
CITES = []
def c(doc, anchor, addr, kind, exp, note=''):
    CITES.append((doc, anchor, addr, kind, exp, note))

D98, D99, D100, D101, D102, D103 = ('98-main-final5-seed.md', '99-fnindex-runs-lo.md', '100-fnindex-runs-mid.md',
    '101-fnindex-runs-hi.md', '102-main-unnamed-residue.md', '103-home-keytable.md')
R, RM = 'RESUME-FULL.md', 'README.md'
SUBB = 0xFFC00000

# ---------------- doc 98 (L1)
c(D98, 'file `0x04E9FB` and the same bytes as BE24', 0x04E9FB, 'be32', 0x00054B00, 'BE32 coincidence in a value table')
c(D98, 'file `0x04E9FB` and the same bytes as BE24', 0x04E9FC, 'bytes', '05 4b 00', 'BE24 at 0x04E9FC')
c(D98, '(`…00 03 ae 00 | 00 04 6a 00 | 00 05 4b 00', 0x04E9F3, 'bytes', '00 03 ae 00 00 04 6a 00 00 05 4b 00 00 06 59 00 00 07 9d 00 00 09 22 00', 'table run starts 0x04E9F3 (address implied by the 0x04E9FB cell)')
c(D98, '`0x054B04` at file `0x001A12`', 0x001A10, 'bytes', '05 e5 05 4b 04 60 04', '"…05 e5 | 05 4b 04 | 60 04…": BE24 054B04 at 0x001A12')
c(D98, '- **Physical entry.** The only way into', 0x054ADE, 'bytes', '6a 0a a5 1a', 'wrapped span `0x054ADE 6a 0a a5 1a` (lines 93-94)')
c(D98, '- **Physical entry.** The only way into', 0x054AE2, 'bytes', '4b 0c', 'bmi')
c(D98, 'its head `0x054AC0`–`0x054AE1` was already unproven', 0x054BF6, 'bytes', '54 70', 'rts 0x054BF6 (line 95)')

# ---------------- doc 99 (L2)
c(D99, '| `0x018ABE` | 20 |', 0x018ABE, 'bytes', '6a 10 8c 26 73 70', 'FF8C26 b7 test at run start')
c(D99, '| `0x01A094` | 8 |', 0x01A094, 'bytes', '7a 02 00 01 a1 ec 40 4e', 'landing pad')
c(D99, '| `0x01A0A4` | 8 |', 0x01A0A4, 'bytes', '7a 02 00 01 a1 e0 40 3e', 'landing pad')
c(D99, '`0x05E862 7a 01 00 05 e8 e0` / `0x05E868`', 0x05E868, 'bytes', '5e 01 52 06', 'jsr @0x15206')
c(D99, '| `0x0192A0` | 8 |', 0x0192A0, 'bytes', '79 01 00 16 5a 03 cc bc', 'writer stub body')
c(D99, '| `0x0198C4` | 8 |', 0x0198C4, 'bytes', '79 01 01 8c 5a 03 cc ec', 'writer stub body')
c(D99, '| `0x0198C4` | 8 |', 0x05142C, 'bytes', '5e 01 98 c4', 'inbound jsr')
c(D99, '| `0x0198C4` | 8 |', 0x051472, 'bytes', '5e 01 98 c4', 'inbound jsr')
c(D99, '| `0x01C4D2` | 194 |', 0x01C28E, 'bytes', '5e 01 c4 d2', '`0x01C28E`, `0x01D93C` (`5e 01 c4 d2`)')
c(D99, '| `0x02370E` | 30 |', 0x01DB46, 'bytes', '5e 02 37 0e', 'inbound jsr')
c(D99, '| `0x02370E` | 30 |', 0x01E87C, 'bytes', '5e 02 37 0e', 'inbound jsr')
c(D99, '| `0x02370E` | 30 |', 0x01DB36, 'bytes', '00 03 ff a0', 'BE32 handler table ending `00 03 ff a0` right before 0x01DB3A')
c(D99, '| `0x015EB4` | 28 |', 0x015E80, 'bytes', '55 32', 'bsr 0x015EB4')
c(D99, '| `0x015EB4` | 28 |', 0x015E86, 'bytes', '55 2c', 'bsr 0x015EB4')
c(D99, '| `0x01F930` | 16 |', 0x01F926, 'bytes', '55 08', 'bsr 0x01F930')
c(D99, '| `0x01F930` | 16 |', 0x01F98C, 'bytes', '55 a2', 'bsr 0x01F930 (back)')
c(D99, '| `0x01F996` | 48 |', 0x01F976, 'bytes', '55 1e', 'bsr 0x01F996')
c(D99, '| `0x01F996` | 48 |', 0x01F94C, 'bytes', '55 66', 'bsr 0x01F996 (0x01F94E+0x66... => 0x01F9B4 interior)')
c(D99, '| `0x00245C` | 16 | `0x002416', 0x002412, 'bytes', 'fc 10', 'r4=0x10 (mov.b #0x10,r4l)')
c(D99, '| `0x00245C` | 16 | `0x002416', 0x002422, 'bytes', '7b d4 59 8f', 'eepmov.w')
c(D99, '| `0x00C63C` | 4 |', 0x00D4A2, 'bytes', '7a 05 00 00 c6 24', 'mov.l #0xC624,er5 (load of record list)')
c(D99, '| `0x0151E6` | 6 |', 0x014D9A, 'be32', 0x000151E6, 'pointer cell')
c(D99, '| `0x016642` | 6 |', 0x016642, 'bytes', '1e 32 46 64 96 00', 'values 30/50/70/100/150/0')
c(D99, '| `0x01E5EE` | 8 |', 0x01E5EE, 'bytes', '38 02 12 50 38 13 12 50', 'range pair {0x38021250, 0x38131250}')
for ld, tg, b in ((0x02D6FA, 0x02D71A, '7a 05 00 02 d7 04 55 18'), (0x02D7F4, 0x02D814, '7a 05 00 02 d7 fe 55 18'),
                  (0x02E2CE, 0x02E2EE, '7a 05 00 02 e2 d8 55 18'), (0x02E3C8, 0x02E3E8, '7a 05 00 02 e3 d2 55 18')):
    c(D99, '| `0x02D704`, `0x02D7FE`, `0x02E2D8`, `0x02E3D2` | 4 each |', ld, 'bytes', b, 'mov.l #T,er5 ; bsr +0x18')
    c(D99, '| `0x02D704`, `0x02D7FE`, `0x02E2D8`, `0x02E3D2` | 4 each |', tg, 'bytes', '7a 63 00 00 00 ff 0a b5 68 5b', 'bsr target')
c(D99, '`0x01E22E` `mov.b r7h,@0x90:8`', 0x01E22E, 'bytes', '37 90', 'mov.b r7h,@0x90:8 misdecode inside table 0x01E22C')
c(D99, '- `0x01A0D4` has a BE32 at `0x01792E`', 0x01792E, 'be32', 0x0001A0D4)

# ---------------- doc 100 (L3)
c(D100, 'BCD subtract `0x3F94C` (`6f 64 00 02 … 1f 0b`)', 0x03F94C, 'regrade', 'PASS-WITHIN', 'parenthetical after routine 0x3F94C: `6f 64 00 02` at 0x03F954 (+8), `1f 0b` at 0x03F95A; entry is `fc 00 08 cc 6f 53 00 02`')
c(D100, 'It follows the `rts` at `0x03C666`', 0x03C666, 'bytes', '54 70', 'rts')
c(D100, '| `03C668`–`03C99B` | 820 |', 0x03C668, 'bytes', '01 00 6d f0 6a 0a 81 6e 79 06 00 40 5c 00 fd 00', 'page-writer head')
c(D100, '| `03D3A6`–`03D40D` | 104 |', 0x03D3A4, 'bytes', '54 70', 'rts 03D3A4')
c(D100, '| `03A9A2`–`03A9F5` | 84 |', 0x03A9A0, 'bytes', '54 70', 'rts 03A9A0')
for a in (0x03D436, 0x03D70E, 0x03D61C, 0x03DDCA, 0x03DC48, 0x03CDBE, 0x03D68A, 0x03D36E):
    c(D100, '| `03D436` 60, `03D70E` 60', a, 'bytes', '01 30 6d f0', 'wrapper prologue `01 30 6d f0 …`')
    c(D100, '| `03D436` 60, `03D70E` 60', a - 2, 'bytes', '54 70', '"each is preceded by an rts"')
c(D100, '| `03FFCA`–`03FFDF` | 22 |', 0x03FFC2, 'bytes', '55 06', 'bsr 0x03FFCA')
c(D100, '| `03FFCA`–`03FFDF` | 22 |', 0x03FFE0, 'bytes', '55 e8', 'bsr 0x03FFCA (back)')
c(D100, '| `048B84`–`048B85` | 2 |', 0x048B80, 'ascii', b'LON \x54\x70', '"LON " at 048B80 then orphan 54 70 at 048B84')
c(D100, '| `033790` | 20 |', 0x03377E, 'bytes', '54 70', 'rts 03377E')
c(D100, '| `033790` | 20 |', 0x03378E, 'bytes', '47 12', 'beq at 03378E (not-taken)')
c(D100, '| `0337AC` | 20 |', 0x033786, 'bytes', '47 1c', '`033786 beq .+28`')
c(D100, '| `0337C8` | 20 |', 0x0337BE, 'bytes', '54 70', 'rts 0337BE')
c(D100, '| `045D1E` 106 + `045D8E` 8 |', 0x045D16, 'bytes', '54 70', 'rts 045D16')
c(D100, '| `04A394` | 78 |', 0x04A38E, 'bytes', '54 70', 'rts 04A38E')
for a, v in ((0x046482, '72'), (0x04648A, '72'), (0x0464F0, '72'), (0x0464F8, '72'), (0x046500, '72'), (0x04658E, '72'),
             (0x046596, '70'), (0x04659E, '72'), (0x0465A6, '70')):
    c(D100, '| `046532` 92 + `0465AE` 84 |', a, 'bytes', '6a 18 aa 33 %s 60' % v, 'entry `6a 18 aa 33 72/70 60`')
c(D100, '| `046532` 92 + `0465AE` 84 |', 0x04F3C5, 'be32', 0x00046579, 'straddle of `add.l #0x465` (7a 13 00 00 04 65 at 0x04F3C2)')
c(D100, '| `046532` 92 + `0465AE` 84 |', 0x04F459, 'be32', 0x00046579, 'straddle of `add.l #0x465` (0x04F456)')
c(D100, '| `046210`–`0463E7` | 472 |', 0x0442E0, 'bytes', '58 20', '`0442E0 bhi` (16-bit Bcc form)')
c(D100, '| `046210`–`0463E7` | 472 |', 0x01FBF3, 'be32', 0x00046300, 'odd BE32 hit inside 046210-0463E7 (value not stated in doc; derived)')
c(D100, '| `033B70` | 6 |', 0x033B70, 'bytes', '03 06 0d 10 ff 00')
c(D100, '| `03400E` | 4 |', 0x03400E, 'bytes', '27 29 2a 29')
c(D100, '| `03400E` | 4 |', 0x034022, 'bytes', '7a 63 00 00 00 ff 0a b5 68 5b', 'bsr 0x34022 = and.l #0xff,er3; add.l er3,er5; mov.b @er5,r3l')
c(D100, '| `03531E` | 16 |', 0x03531E, 'bytes', '05 00 00 00 13 70 00 00 22 20 00 00 42 00 00 00')
for a, t in ((0x0352EC, '1e'), (0x0352CE, '22'), (0x0352B0, '26'), (0x03528C, '2a')):
    c(D100, '| `03531E` | 16 |', a, 'bytes', '7a 06 00 03 53 ' + t, 'mov.l #0x353%s,er6' % t.upper())
c(D100, '| `03799E` 74 + `037A02` 18 | 92 |', 0x037988, 'bytes', '00 08 00 11 14 05 00 00', 'stride 8, count 17, first lo 14050000')
c(D100, '| `03799E` 74 + `037A02` 18 | 92 |', 0x037A10, 'bytes', '46 26 00 00', 'last hi 46260000')
c(D100, '| `03799E` 74 + `037A02` 18 | 92 |', 0x037944, 'bytes', '5e 03 f5 b2', 'jsr 0x3F5B2')
c(D100, '| `03799E` 74 + `037A02` 18 | 92 |', 0x03F5B2, 'bytes', '6d 62 6d 63 01 00 69 64', 'as cited at the routine; image 01 00 6d f2 6d 62 79 0a 00 00 6d 63 01 00 69 64 (cited run is not contiguous)')
c(D100, '| `04C3C8` | 10 |', 0x04C3C8, 'bytes', '02 03 04 ff 05 06 07 08 09 ff')
c(D100, '| `04C3C8` | 10 |', 0x04C364, 'ascii', b'Mc', "IDA's 04C364 blt is ASCII 'Mc'")
c(D100, 'many BE32 `00037a0x` hits', 0x00EAEC, 'bytes', '00 03 7a 0?'.replace('0?', '02'), 'BE32 00037A02')
c(D100, 'many BE32 `00037a0x` hits', 0x009818, 'bytes', '00 03 7a 05', 'BE32 00037A05')
c(D100, '`045D88`–`045D8D` 6 B (`0b 01 fc 00 40 06`)', 0x045D88, 'bytes', '0b 01 fc 00 40 06')

# ---------------- doc 101 (L4)
for a in (0x06280E, 0x06AB24, 0x06ADFE):
    c(D101, 'from `0x06280E`, `0x06AB24`, `0x06ADFE`', a, 'bytes', '5e 06 72 50', 'abs24 jsr 0x067250')
for a in (0x062808, 0x06723A, 0x06AB1C, 0x06ADF6):
    c(D101, '`0x06AB1C`, `0x06ADF6`. These callers', a, 'bytes', '5e 06 6f b4', 'abs24 jsr 0x066FB4')
for a, t in ((0x03379A, '7c c2'), (0x0337B6, '77 8c'), (0x0337D2, '7d 16')):
    c(D101, 'callers are the three stubs `0x033790`/`0x0337AC`/`0x0337C8`', a, 'bytes', '5e 07 ' + t, 'jsr inside the stub (stub +0x0A)')
c(D101, 'sibling `0x033740` that calls `0x77cac`/`0x77cb8`', 0x033758, 'bytes', '5e 07 7c ac', 'jsr 0x77CAC')
c(D101, 'sibling `0x033740` that calls `0x77cac`/`0x77cb8`', 0x033774, 'bytes', '5e 07 7c b8', 'jsr 0x77CB8')
c(D101, '`0x077CC2` reads the window-copied USB descriptor', 0x077CC2, 'bytes', '7a 00 00 3d 40 00 5e 07 7f c6 79 00 40 01 5e 07 80 86 6a 20 00 ff 60 0e', 'calls 0x077FC6, 0x078086; reads @0xFF600E')
c(D101, '`0x077CC2` reads the window-copied USB descriptor', 0x077CDC, 'bytes', '6a 29 00 ff 60 0f', 'reads @0xFF600F')
c(D101, '- **`0x05C600` (2 B)** `ff ff`', 0x05C600, 'bytes', 'ff ff')
c(D101, '(`0x05C57C`/`0x05C5F4 mov.l #0x5C600,er5`)', 0x05C57C, 'bytes', '7a 05 00 05 c6 00')
c(D101, '(`0x05C57C`/`0x05C5F4 mov.l #0x5C600,er5`)', 0x05C5F4, 'bytes', '7a 05 00 05 c6 00')
c(D101, '- **`0x065A88` (4 B)** ASCII', 0x065A88, 'bytes', '33 31 32 00')
c(D101, 'loaded as an er1 pointer at `0x073ABA`', 0x073ABA, 'bytes', '7a 01 00 07 39 08', 'mov.l #0x73908,er1')
c(D101, 'sibling `0x73909` (`mov.l #0x73909,er1`)', 0x073AC8, 'bytes', '7a 01 00 07 39 09', 'odd sibling load (address derived)')
c(D101, '- **`0x074310` (18 B)** a data block', 0x074310, 'bytes', '00 00 41 48 30 36 30 4d')
c(D101, '(`0x0742F2 mov.l #0x74310,er5; 0x0742F8 mov.l #0xff8956,er6; 0x0742FE eepmov.w`)', 0x0742F2, 'bytes', '7a 05 00 07 43 10')
c(D101, '(`0x0742F2 mov.l #0x74310,er5; 0x0742F8 mov.l #0xff8956,er6; 0x0742FE eepmov.w`)', 0x0742F8, 'bytes', '7a 06 00 ff 89 56')
c(D101, '(`0x0742F2 mov.l #0x74310,er5; 0x0742F8 mov.l #0xff8956,er6; 0x0742FE eepmov.w`)', 0x0742FE, 'bytes', '7b d4 59 8f')
c(D101, '`0x051108` (60) is called only by `0x054BBA`', 0x054BBA, 'bytes', '5e 05 11 08', 'jsr 0x051108')
c(D101, 'and at `0x062962` er5 is overwritten', 0x062962, 'bytes', '7a 05 00 ff b3 2e', 'as cited: the overwrite mov.l #0xffb32e,er5')
c(D101, 'and at `0x062962` er5 is overwritten', 0x062962, 'bytes', '7a 05 00 06 21 78 5e 06 1d 8c', 'what 0x062962 holds: the 0x062178 er5 load + jsr @0x61D8C')
c(D101, 'function `0x052A00`), `0x05343C` (90)', 0x052A14, 'bytes', '01 00 6d 25 … 5d 50', 'mov.l @er2+,er5 … jsr @er5 in the tail')
c(D101, '`0x0645A4` (126, pred `0x0645A0 mov.b @0xb26f`', 0x0645A0, 'bytes', '6a 8c b2 6f', 'mov.b r4l,@0xB26F:16 (a store; doc writes mov.b @0xb26f)')
c(D101, '`0x01D360` are mid-instruction false positives)', 0x01D33E, 'be32', 0x0006460E, 'as cited (BE32 into 0645A4 run); the cell is at 0x01D340 inside `6e 0c 00 06 46 0e` at 0x01D33E')
c(D101, '`0x01D360` are mid-instruction false positives)', 0x01D360, 'be32', 0x00064610)
c(D101, 'the only nearby call `0x002214 jsr @0x54BF8`', 0x002214, 'bytes', '5e 05 4b f8')

# ---------------- doc 102 (L5)
c(D102, 'Proven code at `0x016864` does', 0x016864, 'bytes', '7a 05 00 01 68 6e 5a 01 52 60', 'wrapped span (lines 126)')
c(D102, 'Field +8 points at `0x01687E`', 0x01687E, 'bytes', '6a 0a ad 9c 7a 62')
c(D102, '`G5-1`…`G0-5` at `0x00FA30` (182 B)', 0x00FA30, 'ascii', b'-5\xff\xffG5-1', 'piece starts with the "-5" tail of G4-5; G5-1 at 0x00FA34')
c(D102, '`G5-1`…`G0-5` at `0x00FA30` (182 B)', 0x00FAE2, 'ascii', b'G0-5', 'last label ends 0x00FAE5 (piece 0x00FA30-0x00FAE5 = 182 B)')
c(D102, 'The digit-pair table `"37"…"99"` plus hex digits', 0x0044DA, 'ascii', b'3738394041', '"37"…')
c(D102, 'The digit-pair table `"37"…"99"` plus hex digits', 0x004556, 'ascii', b'99', '…"99" (0x0044DA + 62*2)')
c(D102, 'The fullwidth JIS X 0208 letter table `0x01BE74`', 0x01BEA6, 'bytes', '23 7a', '`23 7a` last lower-case')
c(D102, 'The fullwidth JIS X 0208 letter table `0x01BE74`', 0x01BEB4, 'bytes', '23 41', '`23 41` first upper-case (after 12 B of zeros)')
c(D102, 'The fullwidth JIS X 0208 letter table `0x01BE74`', 0x01BEE6, 'bytes', '23 5a', '`23 5a`')
c(D102, '`"YAESU FT1D\\r\\n"` at `0x045306`', 0x045306, 'ascii', b'YAESU FT1D\r\n')
c(D102, 'The BCD word table `0x00585A`, loaded by', 0x026058, 'bytes', '7a 05 00 00 58 5a', 'mov.l #0x585A at 0x026058')
c(D102, 'The bit-mask table `0x01682E`, base loaded by', 0x016812, 'bytes', '78 40 6b 24 00 01 68 2c', 'mov.w @(0x1682C:32,...)')
c(D102, '`0x03F1C6`, base loaded by', 0x03F196, 'bytes', '78 40 6b 24 00 03 f1 c4', 'mov.w @(0x3F1C4:32,...)')
c(D102, 'and the 6-cell table `0x0048C0`', 0x0048C0, 'bytes', '00 00 48 e0 00 00 48 d8 00 00 48 e0 00 00 48 e8 00 00 48 f0 00 00 48 f8', '6 BE32 cells')
c(D102, '`0x076D5D` inside', 0x076D5A, 'bytes', '6a 28 00 fe e0 03', 'instruction containing 0x076D5D')
c(D102, '`0x00835E`–`0x00840B`, 174 B, ending `rts`', 0x00840A, 'bytes', '54 70', 'rts 0x00840A')
c(D102, '`0x00835E`–`0x00840B`, 174 B, ending `rts`', 0x00834E, 'ascii', b'MUTE : TX', 'label in front of 0x00835E')
c(D102, '`0x06259A`, called by `jsr @0x625d0` at `0x062624`', 0x062624, 'bytes', '5e 06 25 d0')
c(D102, '`0x01758E`, registered by `mov.l #0x1758E` at `0x017570`', 0x017570, 'bytes', '7a 01 00 01 75 8e', 'mov.l #0x1758E,er1')
c(D102, '`0x076C06`, the USB-module tail that `0x076BE8` branches to', 0x076BE8, 'bytes', '47 1c', 'beq 0x076C06')
c(D102, '`0x069A7F`–`0x069AA9` is `6a 0c b3 f5', 0x069A7F, 'bytes', '6a 0c b3 f5 1c 9c 46 04 6a 89 b3 f4')
c(D102, '| `0x01E22C` (12 B) | data |', 0x01E174, 'bytes', '7a 05 00 01 e2 2c')
c(D102, '| `0x01E22C` (12 B) | data |', 0x01E360, 'bytes', '7a 05 00 01 e2 2c')
c(D102, '| `0x01E22C` (12 B) | data |', 0x032630, 'bytes', '7a 05 00 01 e2 2c')
c(D102, "| `0x074310` (18 B) | `00 00 'AH060M'` + FF |", 0x074310, 'bytes', "00 00 41 48 30 36 30 4d ff ff", "00 00 'AH060M' + FF")
c(D102, "| `0x065A88` (4 B) | `'312'` + 00 |", 0x065A88, 'bytes', '33 31 32 00')
c(D102, 'cells such as `14 48 40 00` and `00 00 45 34`', 0x0379B0, 'bytes', '14 48 40 00', 'cell inside table 0x037988 (address derived)')
c(D102, 'cells such as `14 48 40 00` and `00 00 45 34`', 0x037A02, 'bytes', '00 00 45 34', 'cell (address derived)')
c(D102, 'the byte tables `0x04C3C8` (`02 03 04 ff 05 …`)', 0x04C3C8, 'bytes', '02 03 04 ff 05')
c(D102, 'The residue holds the DSP debug-console strings', 0x05AE28, 'ascii', b'DSP>CPU:')
c(D102, 'The residue holds the DSP debug-console strings', 0x05AE1E, 'ascii', b'CPU>DSP:')
c(D102, 'The residue holds the DSP debug-console strings', 0x05AE70, 'bytes', '0d 0a', 'CRLF bytes (`0x05AE70` …)')
for a, t in ((0x0761B8, 'a0'), (0x0761AE, 'b0'), (0x0761A4, 'c0'), (0x07619A, 'd0')):
    c(D102, 'indexed by `0x0761B8`/`AE`/`A4`/`9A`', a, 'bytes', '78 01 6a 29 00 07 85 ' + t, 'nibble map 0x0785%s' % t.upper())

# ---------------- doc 103 (L6)
for a in (0x002C28, 0x003816, 0x00395A):
    c(D103, 'from the main loop at `0x002C28`, `0x003816` and `0x00395A`', a, 'bytes', '5e 01 07 9e', 'jsr sub_1079E')
c(D103, 'It is dispatched by render table `0x061C5A` at `0x061C30`', 0x061C30, 'bytes', '78 b0 6b 26 00 06 1c 5a', 'wrapped span (line 145-146)')
c(D103, 'Modes 8/10 use render `0x0669E0` (`0x0669CA`)', 0x0669CA, 'bytes', '78 b0 6b 26 00 06 69 e0', 'render table load')
c(D103, 'Modes 8/10 use render `0x0669E0` (`0x0669CA`)', 0x02BA74, 'bytes', '78 b0 6b 26 00 02 ba 86', 'touch table load')
SUBLAB = [('| F800 | `0x03E88E`', 0x3E88E, b'SEARCH & DIRECT'), ('| F810 | `0x03E871`', 0x3E871, b'LOCAL NEWS'),
          ('| F815 / F816 | `0x03E87C`', 0x3E87C, b'UPLOAD  '), ('| F822 | `0x34AD44`', 0x34AD44, b'ADD TO CATEGORY'),
          ('| F620 / F621 | `0x348614`', 0x348614, b'TO:\x00'), ('| F620 / F621 | `0x348614`', 0x348618, b'NEW\x00'),
          ('| F640 | `0x34AE5C`', 0x34AE5C, b'VOICE PLAY'), ('| F640 | `0x34AE5C`', 0x34AE67, b'.wav'),
          ('| F630–F632, FD00 |', 0x3483D8, b'Adj\x00Data\x00Mode'), ('| F630–F632, FD00 |', 0x3483D0, b'Waiting\x00'),
          ('"ALTI m" `0x3485DD`', 0x3485DD, b'ALTI'), ('"ALTI m" `0x3485DD`', 0x3D399, b'Jan'),
          ('F512 handler "To:" `0x34856C`', 0x34856C, b'To:'), ('F512 handler "To:" `0x34856C`', 0x348578, b'TEXT'),
          ('"---CALLSIGN  INPUT---"', 0x34ABE0, b'---CALLSIGN  INPUT---'), ('"---DSP WRITE MODE----" `0x34ACF8`', 0x34ACF8, b'---DSP WRITE MODE----')]
for anc, off, s in SUBLAB:
    c(D103, anc, SUBB + off, 'ascii', s, 'SUB file 0x%X' % off)
c(D103, '| F822 | `0x34AD44`', 0xFFF103EC, 'bytes', 'fb 32 44 ad f4 ff', 'insn FFF103EC: mov.l #0xFFF4AD44,r3')
c(D103, 'F621 is SUB screen 0x2A', 0xFFEFC52B, 'bytes', 'fb 42 14 86 f4 ff', 'mov.l #0xFFF48614,r4 ("TO:")')
c(D103, 'F621 is SUB screen 0x2A', 0xFFEFC5FF, 'bytes', 'fb 42 18 86 f4 ff', 'mov.l #0xFFF48618,r4 ("NEW")')
c(D103, 'Its cells', 0x02AE50, 'be32', 0x0002B502, 'touch-table cell -> 0x02B502')
c(D103, 'Its cells', 0x02BB52, 'be32', 0x0002B502, 'cell in the 8/10 table')
KT = [('| F106, 24', 0x011BC4, 0x02186E), ('| F107, 16', 0x011960, 0x0291D4), ('| F112, 17', 0x012838, 0x029406),
      ('| F10D/F10F/F111, 14', 0x01109C, 0x0286CA), ('| F10D/F10F/F111, 14', 0x0110E0, 0x0286CA),
      ('| F10B, 5', 0x01287C, 0x029306), ('| F301, 6', 0x014818, 0x0298D8), ('| F8xx, 33', 0x011388, 0x02AD6A),
      ('| F701/F703, 13', 0x0113CC, 0x02BA60), ('| F004 / F517 / F104–5', 0x013D34, 0x02A696),
      ('| F004 / F517 / F104–5', 0x01397C, 0x02A99E),
      ('| 4 / 5 | `0x04AAE8`', 0x0111F0, 0x02870A), ('| 4 / 5 | `0x04AAE8`', 0x011234, 0x02889A),
      ('| 4 / 5 | `0x04AAE8`', 0x011278, 0x0289BC), ('| 8 | `0x066966`', 0x011344, 0x02AD6A),
      ('| 0/2/6/7 | F1 display', 0x0115EC, 0x028E84), ('| 0/2/6/7 | F1 display', 0x0115EC + 0x44, 0x028DAC)]
for anc, kt, h in KT:
    c(D103, anc, kt + 40, 'be32', h, 'key table 0x%06X slot 10' % kt)
for kt in (0x0114DC, 0x011520, 0x011564):
    c(D103, '`[8DDE]`>0 (node/PC link) selects', kt + 40, 'be32', 0x0003FFA0, 'key table 0x%06X slot 10 = no-op' % kt)
for i in range(17):
    c(D103, '- Table #9 `0x011300` (all 17 slots `0x3FFA0`)', 0x011300 + 4 * i, 'be32', 0x0003FFA0, 'slot %d' % i)
for idx, stub, tgt in ((0x0B, 0x01F31C, '5e 01 f5 c8'), (0x0F, 0x0219AA, '6a 0c a9 f9 ac 05 47 0c 6a 8c a9 fb 5e 01 d1 8c'),
                       (0x10, 0x0219CA, '6a 0c a9 f9 ac 04 47 0c 6a 8c a9 fb 5e 01 d1 94'),
                       (0x12, 0x0219EA, 'fc 01 6a 8c 8e a1'), (0x18, 0x0219F2, 'fc 00 6a 8c 8e a1')):
    c(D103, '| F106, 24', 0x02188C + 4 * idx, 'be32', stub, 'jump table 0x02188C[0x%X]' % idx)
    c(D103, '| F106, 24', stub, 'bytes', tgt, 'cell 0x%X stub -> doc target' % idx)
c(D103, '| F106, 24', 0x02188C + 4 * 0x0D, 'be32', 0x0001FAC6, 'jump table [0x0D]; "pop 0x03FF3A" not byte-checked')
c(D103, '- **F00B** zone → `0x02A68A[2]` = `0x0236B8`', 0x02A68A + 8, 'be32', 0x000236B8, 'BE32 table index 2')
c(D103, 'The 2 in-69 hits (`0x04B46E`, `0x04B6B6`, value 0x2A)', 0x04B46A, 'bytes', 'f4 2a 68 e4 6e e4 00 01', 'mov.b #0x2A,r4h; stores; 0x04B46E = `6e e4 00 01`')
c(D103, 'The 2 in-69 hits (`0x04B46E`, `0x04B6B6`, value 0x2A)', 0x04B6B2, 'bytes', 'f4 2a 68 e4 6e e4 00 01', '0x04B6B6 = `6e e4 00 01`')
c(D103, '| `0x010CC0`–`0x010CC3` | 4 B |', 0x010CC0, 'bytes', '00 03 04 ff')
c(D103, '| `0x010CC0`–`0x010CC3` | 4 B |', 0x03F768, 'bytes', '6c 5c ac ff 47 06 1c bc 47 04 40 f4', 'scanner')
c(D103, '| `0x011038`–`0x01104F` | 24 B |', 0x011038, 'bytes', '72 06 26 07 25 07 42 07 45 07 70 07 dd 08 e1 08 e2 08 e3 08 e4 08 e7 08')
c(D103, 'through into the next function (e.g. `0x0767BC rts/l`', 0x0767BC, 'bytes', '54 13', 'rts/l encoding (H8SX 54 1x); "reads 0xFFEE04" at 0x0767BE not byte-checked')

# ---------------- RESUME-FULL.md L-wave section
c(R, "callbacks `0x018250`, `0x018ABE`, `0x01A094` via `sub_15206`'s", 0x015224, 'bytes', '5d 10', 'jsr @er1 (line 34-35)')
for a, b in ((0x06AB2A, '5e 06 72 6a'), (0x06AB36, '5e 06 6f be'), (0x06AE04, '5e 06 72 6a'), (0x06AE10, '5e 06 6f be')):
    c(R, 'abs24 `jsr` from proven `0x06AB2A`/`36`, `0x06AE04`/`10`', a, 'bytes', b)
for a, v in ((0x07B4BA, 0x000784BE), (0x07B4C4, 0x000769AA), (0x07B4CE, 0x000768C8)):
    c(R, 'handler records at `0x07B4B4` point to', a, 'be32', v, 'pointer field of a 10-B record from 0x07B4B4')
c(R, 'and `0x01C4D2` (194 B), whose callers are skipped by', 0x01C28E, 'bytes', '5e 01 c4 d2', 'caller')
c(R, 'and `0x01C4D2` (194 B), whose callers are skipped by', 0x01D93C, 'bytes', '5e 01 c4 d2', 'caller')
c(R, 'flag the same data in the proven mask (BCD table `0x037988`', 0x037988, 'bytes', '00 08 00 11 14 05 00 00', 'BCD range table head')
c(R, '`0x01E22C`, "AH060M" `0x074310`, "312" `0x065A88`)', 0x074312, 'ascii', b'AH060M')
c(R, '`0x01E22C`, "AH060M" `0x074310`, "312" `0x065A88`)', 0x065A88, 'ascii', b'312\x00')
c(R, 'reached-code gap, 51 fill. Finds `"YAESU FT1D\\r\\n"` at `0x045306`', 0x045306, 'ascii', b'YAESU FT1D\r\n')
c(R, 'code missing from the proven mask at `0x006A0C` / `0x0077F8`', 0x006A0C, 'bytes', '6a 10 8e a0 73 40', '6-B btst whose first 2 B were missing')
c(R, 'code missing from the proven mask at `0x006A0C` / `0x0077F8`', 0x0077F8, 'bytes', '6a 10 81 7e 77 00', '6-B bld')
c(R, '(dispatch `0x01096A`', 0x01096A, 'bytes', '6a 0c a9 ed', 'dispatch on [A9ED]')
c(R, 'F3C3 that MAIN never sends — the only `79 2x f8 01` / `f3 c3` compares are `0x026634` /', 0x026634, 'bytes', '79 2? f8 01'.replace('?', '4'), 'cmp.w #0xF801')
c(R, 'F3C3 that MAIN never sends — the only `79 2x f8 01` / `f3 c3` compares are `0x026634` /', 0x02653C, 'bytes', '79 24 f3 c3', 'cmp.w #0xF3C3 (address on next line)')
c(R, '**F8 = WIRES-X** (SUB "SEARCH & DIRECT" `0x03E88E`', SUBB + 0x3E88E, 'ascii', b'SEARCH & DIRECT', 'SUB file 0x3E88E')
c(R, '"LOCAL NEWS" `0x03E871`, "ADD TO CATEGORY" `0x34AD44`', SUBB + 0x3E871, 'ascii', b'LOCAL NEWS', 'SUB file')
c(R, '"LOCAL NEWS" `0x03E871`, "ADD TO CATEGORY" `0x34AD44`', SUBB + 0x34AD44, 'ascii', b'ADD TO CATEGORY', 'SUB file')
c(R, '**L7 — WIRES-X node-command table.**', 0x074472 + 0x40, 'be32', 0x00073E58, 'off_74472 slot 0x10 = sub_73E58')
c(R, '`5e 03 4a 52` is at `0x073E86`, `5e 03 50 e4` at `0x073E8E`', 0x073E86, 'bytes', '5e 03 4a 52')
c(R, '`5e 03 4a 52` is at `0x073E86`, `5e 03 50 e4` at `0x073E8E`', 0x073A34, 'bytes', '78 b0 6b 26 00 07 44 72', 'table load of off_74472')
c(R, '`0x074532`). **`sub_73E58` is slot', 0x074532, 'bytes', '02 02 01 02', 'arg-length table head (no bytes cited; head shown)')
c(R, '40 20`** (set `AA30` b4, `bra` to `rts` `0x034A7A`)', 0x034A52, 'bytes', '6a 18 aa 30 70 40 40 20', 'wrapped span (lines 106-107)')
c(R, '40 20`** (set `AA30` b4, `bra` to `rts` `0x034A7A`)', 0x034A7A, 'bytes', '54 70', 'rts')
c(R, '40 20`** (set `AA30` b4, `bra` to `rts` `0x034A7A`)', 0x034A6A, 'bytes', '5e 03 58 72', 'the only jsr sub_35872')
c(R, '(orchestrator): `fc 01` at `0x0743BA`, `fc 05 6a 8c aa ce` at `0x030240` and `0x031CD2`', 0x031CD2, 'bytes', 'fc 05 6a 8c aa ce')
c(R, 'receive buffer for the SUB→MAIN link (SCI at `0xFFF610`, ISR `0x044A70` from vectors 224/226', 224 * 4, 'be32', 0x00044A70, 'vector 224')
c(R, 'receive buffer for the SUB→MAIN link (SCI at `0xFFF610`, ISR `0x044A70` from vectors 224/226', 226 * 4, 'be32', 0x00044A70, 'vector 226')
c(R, '`RXAT=CKPD=200` — a Bluetooth headset', 0xFFF3A9D3, 'bytes', '75 51 43 … 75 51 4b … 75 51 50 … 75 51 44 … 75 51 3d … 75 51 32 … 75 51 30',
  'compares `43 4b 50 44 3d 32 30 30` are the imm8 of a cmp #imm,r1 chain from 0xFFF3A9D3 (line 123-124)')
c(R, '(after L12): audio coming up alone never keys', 0xFFF38FD2, 'drop', '', 'FFF38FD2 is the bsr.a call site (`05 56 45 fa`) of the E6 build, not bytes `e6 01`; E6 loaded at FFF38FCF (`75 41 e6`) -- doc 107:190/305')
c(R, '(after L12): audio coming up alone never keys', 0xFFF38FCF, 'bytes', '75 41 e6 05 56 45 fa', 'mov #0xE6,r1 then bsr.a at FFF38FD2 (context for the dropped row)')
c(R, 'Exactly ten types accepted: E0 E1 E2 E3 E4 E5 E6 EA FE FF (switch `0x04761E`', 0x0475C8 + 4, 'be32', 0x0004761E, 'state table 0x0475C8 cell 1 = switch 0x04761E (address of cell derived)')
c(R, '`0x047658`; state table `0x0475C8`', 0x047658, 'bytes', '54 70', 'rts')
c(R, 'address, 2 mnemonic slips (all *verified* by the orchestrator', 0x04B46A, 'bytes', 'f4 2a 68 e4 6e e4 00 01')
c(R, 'address, 2 mnemonic slips (all *verified* by the orchestrator', 0x00209E, 'bytes', 'fc 00 6a 8c 80 04')
c(R, '`0x0345AE`, `0x034B5C`, `0x04954A`/`0x049556` are `mov` + `not.b r3l`', 0x0345AE, 'bytes', 'ac 01', 'cmp.b #1')
c(R, '`0x0345AE`, `0x034B5C`, `0x04954A`/`0x049556` are `mov` + `not.b r3l`', 0x034B5C, 'bytes', 'ac 02', 'cmp.b #2')
c(R, '`0x0345AE`, `0x034B5C`, `0x04954A`/`0x049556` are `mov` + `not.b r3l`', 0x04954A, 'bytes', '0c 2b 17 0b', 'mov.b r2h,r3l; not.b r3l')
c(R, '`0x0345AE`, `0x034B5C`, `0x04954A`/`0x049556` are `mov` + `not.b r3l`', 0x049556, 'bytes', '0c ab 17 0b', 'mov.b r2l,r3l; not.b r3l')
c(R, 'writers not twelve (*verified*), `B0CC` 9 refs at byte level', 0x03F38E, 'bytes', '6a 04 80 10', 'FF8010 at 0x03F38E (next line)')
c(R, '`cmp.w #0x400` after the packet at `0x05569E`', 0x05569E, 'bytes', '79 25 04 00', 'cmp.w #0x400,r5')
c(R, '`0x055002` *verified*: states 5 and 10 share', 0x055002, 'bytes', '00 05 50 34 00 05 50 42', 'FSM table head (sharing checked in counts_a.tsv)')

# ---------------- l-wave-recon README.md
c(RM, '`0x06AB2A`/`0x06AE04 5e 06 72 6a`, plus `bsr` at `0x067246`', 0x06AB2A, 'bytes', '5e 06 72 6a')
c(RM, '`0x06AB2A`/`0x06AE04 5e 06 72 6a`, plus `bsr` at `0x067246`', 0x067246, 'bytes', '55 22', 'bsr 0x06726A')
c(RM, 'routines; the second ones are called by abs24 `jsr` from proven code (`0x06AB36`', 0x06AB36, 'bytes', '5e 06 6f be')
for a, b in ((0x0076DA, '5e 00 cf c2'), (0x01C28E, '5e 01 c4 d2'), (0x0460C8, '5e 04 62 10'), (0x0460D6, '5e 04 62 90'),
             (0x046104, '5e 04 63 3c'), (0x04612A, '5e 04 5f 88')):
    c(RM, 'data-mistyped tables, the dead callers L2/L3 list as companions', a, 'bytes', b, 'companion dead caller')
for a, b in ((0x033790, '01 30 6d f0 fc 3d 6a 8c bc 8d 5e 07 7c c2'), (0x0337AC, '01 30 6d f0 fc 3f 6a 8c bc 8d 5e 07 77 8c'),
             (0x0337C8, '01 30 6d f0 fc 3c 6a 8c bc 8d 5e 07 7d 16')):
    c(RM, 'bytes `0x077CC2` (206) / `0x07778C` (84), demoted because their only callers are the stubs', a, 'bytes', b, 'stub (jsr into the USB module)')
# coverage additions (doc 102 lines 145/146/188)
c(D102, '- Length headers `00 0e` of the APRS weather/status labels', 0x04C4E2, 'bytes', '00 0e', 'first header')
c(D102, '- Length headers `00 0e` of the APRS weather/status labels', 0x04E584, 'bytes', '00 0e', 'last header')
c(D102, "- The DSP debug strings' `0d 0a` endings", 0x05AE70, 'bytes', '0d 0a')
for a in (0x0528DA, 0x053372, 0x0529AC, 0x0533F6):
    c(D102, '- The `fd 0x 6a 8d b0 8d 7a 03 …` case-stub families', a, 'bytes', 'fd ?? 6a 8d b0 8d 7a 03', 'case stub family member')
