# N14 manual citation list for n14_citations.py: (doc, anchor text, address, kind, expected, note).
# kind: bytes | be32 | le32 | ascii | na | drop (an automatic row that is not this citation) | regrade (new verdict for an
# automatic non-PASS row after reading the line). Every entry was checked by hand against the line it anchors to.
D113, D114, D115, D116, D117, D118, D119, D120 = ('113-main-final6-seed.md', '114-proven-unreached-lo.md', '115-proven-unreached-mid.md',
    '116-proven-unreached-hi.md', '117-dead-code-tier.md', '118-inferred-tables.md', '119-cdc-personality.md', '120-an1-and-tones.md')
D121, D122, D123, D124, D125, D126, D127 = ('121-link-edge-cases.md', '122-touch-key-leftovers.md', '123-main-small-unknowns.md',
    '124-bluetooth-protocol.md', '125-ledger-reverify-l.md', '126-errata-k-l.md', '127-sub-residue-final.md')
RS, RD = 'RESUME-FULL.md', 'README.md'
Q = 'PASS-ERRATUM-QUOTE'
CITES = [
    # ---- extractor mis-pairings: the auto row paired a range end / span column with the bytes; re-cite at the run start
    (D114, '`0x00932A`–`0x009332` = `05 04 02 03', 0x9332, 'drop', '', 'range end paired with the bytes'),
    (D114, '`0x00932A`–`0x009332` = `05 04 02 03', 0x932A, 'bytes', '05 04 02 03 04 04 04 00', 'range start'),
    (D115, 'The 3-digit entry `04B812` (`f4 03`)', 0x4B812, 'regrade', 'PASS-WITHIN', '`f4 03` is the mov.b #3 at +6 inside the 8-B entry `7a 03 00 00 00 00 f4 03` that starts at 04B812'),
    (D115, '| `04F534`–`04F539` | 6 | span `04F4B0`', 0x4F4B0, 'drop', '', 'span column paired with the bytes of run 04F534'),
    (D115, '| `04F534`–`04F539` | 6 | span `04F4B0`', 0x4F534, 'bytes', 'fd 1e 40 02 fd 1d', 'run start'),
    (D115, '| `04F534`–`04F539` | 6 | span `04F4B0`', 0x4F532, 'bytes', '40 06', 'predecessor'),
    (D115, '| `050812`–`050825` | 20 | span `0507AC`', 0x507AC, 'drop', '', 'span column paired'),
    (D115, '| `050812`–`050825` | 20 | span `0507AC`', 0x50812, 'bytes', '5e 01 d0 fc fc 05 6a 8c a9 f9 … 5e 05 09 5a', 'run start'),
    (D115, '| `050812`–`050825` | 20 | span `0507AC`', 0x50810, 'bytes', '40 14', 'predecessor'),
    (D115, '| `050CD0`–`050CD3` | 4 | span `050C9C`', 0x50C9C, 'drop', '', 'span column paired'),
    (D115, '| `050CD0`–`050CD3` | 4 | span `050C9C`', 0x50CD0, 'bytes', '5e 03 ff a0', 'run start'),
    (D115, '| `050CD0`–`050CD3` | 4 | span `050C9C`', 0x50CCE, 'bytes', '40 04', 'predecessor'),
    (D115, '| `0532BA`–`0532CD` | 20 | span `05327C`', 0x5327C, 'drop', '', 'span column paired'),
    (D115, '| `0532BA`–`0532CD` | 20 | span `05327C`', 0x532BA, 'bytes', '7a 06 00 ff 3d ab fc 00 68 ec 7a 06 00 ff 3d ac fc 00 68 ec', 'run start'),
    (D115, '| `0532BA`–`0532CD` | 20 | span `05327C`', 0x532B8, 'bytes', '40 14', 'predecessor'),
    (RS, 'So `0x932A`–`0x932B` (`05 04`)', 0x932B, 'drop', '', 'range end paired'),
    (RS, 'So `0x932A`–`0x932B` (`05 04`)', 0x932A, 'bytes', '05 04', 'range start'),
    # ---- within-instruction / frame notation
    (D123, '- `bset` at `0x034A52` (`aa 30 70 40`, 1 hit)', 0x34A52, 'regrade', 'PASS-WITHIN', 'the bset at 034A52 is the 6-B `6a 18 aa 30 70 40`; the cited 4 B are its tail (the 1-hit search pattern)'),
    (D123, '- `bset` at `0x034A52` (`aa 30 70 40`, 1 hit)', 0x34A52, 'bytes', '6a 18 aa 30 70 40', 'full instruction'),
    (D124, '| 2 | `SCOI=0` (radio-closed)', 0xFFF3906F, 'drop', '', '`E6 00` is frame notation (type E6, arg 0); FFF3906F is the `05 b9 44 fa` bsr.a after `75 41 e6` at FFF3906C'),
    (D124, '| 2 | `SCOI=0` (radio-closed)', 0xFFF3906C, 'bytes', '75 41 e6 05 b9 44 fa', 'mov #0xE6,r1 then the bsr.a at FFF3906F'),
    # ---- doc 121:132 first address of the pair (auto graded only FFF39516)
    (D121, '`0xFFF394CF`/`0xFFF39516 75 41 e5`', 0xFFF394CF, 'bytes', '75 41 e5', 'first of the pair'),
    # ---- erratum quotes in 125 / 126 (the 'as cited' column), plus the corrected addresses those rows give
    (D125, '| 104:164 | `0x073E88` `5e 03 4a 52`', 0x73E88, 'regrade', Q, 'M13 quotes doc 104 as cited'),
    (D125, '| 104:164 | `0x073E88` `5e 03 4a 52`', 0x73E86, 'bytes', '5e 03 4a 52', 'true address given'),
    (D125, '| 104:164 | `0x073E90` `5e 03 50 e4`', 0x73E90, 'regrade', Q, 'M13 quotes doc 104 as cited'),
    (D125, '| 104:164 | `0x073E90` `5e 03 50 e4`', 0x73E8E, 'bytes', '5e 03 50 e4', 'true address given'),
    (D125, '| 106:130 | `0x0743BC` `fc 01 6a 8c b0 cc`', 0x743BC, 'regrade', Q, 'M13 quotes doc 106 as cited'),
    (D125, '| 106:130 | `0x0743BC` `fc 01 6a 8c b0 cc`', 0x743BA, 'bytes', 'fc 01 6a 8c b0 cc', 'true address given'),
    (D125, '| 106:153 | `0x030242` `fc 05 6a 8c aa ce`', 0x30242, 'regrade', Q, 'M13 quotes doc 106 as cited'),
    (D125, '| 106:153 | `0x030242` `fc 05 6a 8c aa ce`', 0x30240, 'bytes', 'fc 05 6a 8c aa ce', 'true address given'),
    (D125, '| 106:153 | `0x031CD4` same', 0x31CD2, 'bytes', 'fc 05 6a 8c aa ce', 'true address given'),
    (D125, '| 106:151 | store `0x031BEE` (FF9589)', 0x31BEE, 'bytes', 'fc c8 6a 8c 95 89', 'image at cited address, as M13 states'),
    (D125, '| 107:119 | `0x00FAFE` `6a 10 89 20 73 00 46 0c`', 0xFAFE, 'regrade', Q, 'M13 quotes doc 107 as cited'),
    (D125, '| 107:119 | `0x00FAFE` `6a 10 89 20 73 00 46 0c`', 0xFB04, 'bytes', '6a 10 89 20 73 00 46 0c', 'true address given'),
    (D125, '| 101:99 | `0x062962` er5 overwrite', 0x62972, 'bytes', '7a 05 00 ff b3 2e', 'true address of the er5 overwrite M13 gives'),
    (D125, '| 101:99 | `0x062962` er5 overwrite', 0x62962, 'bytes', '7a 05 00 06 21 78', 'image at the cited address, as M13 states'),
    (D125, '| 101:104 | interior BE32 `0x0006460E`', 0x1D340, 'be32', 0x0006460E, 'true address given'),
    (D125, '| 101:104 | interior BE32 `0x0006460E`', 0x53490, 'be32', 0x000645A8, 'second BE32 M13 adds'),
    (D125, '| 112:84 | `usb_isr_main` `0x054D50`', 0x54D50, 'regrade', Q, 'M13 quotes doc 112 as cited'),
    (D125, '| 112:84 | `usb_isr_main` `0x054D50`', 0x54D54, 'bytes', '6a 0c 81 3a 58 60 01 4c', 'true address given'),
    (D125, '| 112:84 | `usb_isr_main` `0x054D50`', 0x54D50, 'bytes', '01 10 6d f4 6a 0c 81 3a', 'image at the entry, as M13 states'),
    (D125, '"`6d 62 6d 63 01 00 69 64`" is not contiguous', 0x3F5B2, 'bytes', '01 00 6d f2 6d 62 79 0a 00 00 6d 63 01 00 69 64', 'the image run M13 gives (wrapped)'),
    (D126, '| A01 | 85:235 | `0x04B46E`', 0x4B46E, 'regrade', Q, 'M14 quotes doc 85 as written'),
    (D126, '| A02 | 96:113 | `0x0020A0`', 0x20A0, 'regrade', Q, 'M14 quotes doc 96 as written'),
    (D126, '| B01 | 104:164 | `0x073E88 5e 03 4a 52`', 0x73E88, 'regrade', Q, 'M14 quotes doc 104 as written'),
    (D126, '| B02 | 104:164 | `0x073E90 5e 03 50 e4`', 0x73E90, 'regrade', Q, 'M14 quotes doc 104 as written'),
    (D126, '| B06 | 106:130 | `0x0743BC fc 01 6a 8c b0 cc`', 0x743BC, 'regrade', Q, 'M14 quotes doc 106 as written'),
    (D126, '| B09 | `opcode-1c.tsv`:39 | `0743BC', 0x743BC, 'regrade', Q, 'M14 quotes the lane table as written'),
    # ---- wrapped spans and table rows in RESUME / README
    (RS, 'e.g. `0x06ADE4 0c cb 58 70 00', 0x6ADE4, 'bytes', '0c cb 58 70 00 28 eb 07 5e 06 ac d6 58 00 00 1e', 'wrapped onto the next line'),
    (RS, '(`0x015288 10 72 0a a5 01', 0x15288, 'bytes', '10 72 0a a5 01 00 69 56 47 08 5d 60', 'wrapped onto the next line'),
    (RS, 'word of BCD `00 40 00 00`', 0x3D1C6, 'bytes', '00 40 00 00', 'the BCD dword whose low word is 0x03D1C8'),
    (RS, 'Table `0x035140` = header `00 0a 00 02`, then', 0x35144, 'bytes', '30 00 00 00 41 99 95 00 00 05', 'row after the header'),
    (RS, 'a8 20`/`21`/`22`/`23` at `0x076EF8`+', 0x76F04, 'bytes', 'a8 20 58 70 00 74 a8 21 47 2a a8 22 47 12 a8 23', 'the four compares, first at 0x076F04'),
    (RS, '`00 06 66 00` occurs only at `0x014986` and `0x0149A2`', 0x14986, 'bytes', '00 06 66 00', ''),
    (RS, '`00 06 66 00` occurs only at `0x014986` and `0x0149A2`', 0x149A2, 'bytes', '00 06 66 00', ''),
    (RD, '`0x06ACD6` is an ordinary routine (`0f 95 7a 15', 0x6ACD6, 'bytes', '0f 95 7a 15', ''),
    # ---- runs the regexes miss (mixed byte/mnemonic span, wrapped span)
    (D114, '- `0x019EA0`–`0x019EAE` (14 B) `7A 01 00 FF AD 8A', 0x19EA0, 'bytes', '7a 01 00 ff ad 8a 7a 06 00 01 a1 bc 40 00', 'bytes part of a mixed span'),
    (D114, 'skipped by pred `0x019E9E 40 0E bra .+14`', 0x19E9E, 'bytes', '40 0e', ''),
    (D127, '**The single byte is `FFF2A7FC`**', 0xFFF2A7F9, 'bytes', 'a0 09 2e 7e a9 8c 72 41 0c 10', 'wrapped onto the next line'),
    # ---- listings without backticks
    (D118, 'proven 069964: 6a 0c b3 f5', 0x69964, 'bytes', '6a 0c b3 f5 1c 9c 46 04 6a 89 b3 f4 79 04 00 10 52 41 7a 11 00 ff 45 76 0f 95 7a 15 00 00 00 05 68 5c ac ff 47 02 40 06 7a 05 00 06 9a 4d', 'fenced listing'),
    (D118, 'stale  069A7F: 6a 0c b3 f5', 0x69A7F, 'bytes', '6a 0c b3 f5 1c 9c 46 04 6a 89 b3 f4 79 04 00 10 52 41 7a 11 00 ff 45 76 0f 95 7a 15 00 00 00 05 68 5c ac ff 47 0e 79 04 00 01 6b 84 b0 50 fb 0a 5e 05 e4 68 54 70', 'fenced listing'),
    (D123, '007DE0  f5 01 …', 0x7DE0, 'bytes', 'f5 01', 'listing'),
    (D123, '007DE0  f5 01 …', 0x7DF0, 'bytes', '8d 02', 'listing comment'),
    (D123, '007E2C  00 28 14 2d 18 | 00', 0x7E2C, 'bytes', '00 28 14 2d 18 00', 'listing'),
]
