# Errata for the K-wave and follow-up docs 83–97, the L-wave lane slips, and an index of L-wave corrections (lane M14)

## Verdict

All 12 non-pass items in doc 110 (L13) were re-read from the images, and every one is confirmed
on bytes:

- 5 address slips;
- 2 mnemonic slips;
- 3 wrong counts;
- the doc 83:200 wording item;
- the doc 93:99 scope note.

Two of these get a sharper correction here than doc 110 gave:

- **85:235.** The run `f4 2a 68 e4 6e e4 00 01` has two `'*'` stores, not one: `68 e4` at
  `0x04B46C` and `6e e4 00 01` at `0x04B46E`.
- **93:99.** `sub_10FA8` selects table n = 9 for `AAD3 & 0x0F`, and also for `AAD4 & 0x01`
  (`0x01101A 6a 0c aa d4 ec 01 46 02`).

The six L-wave lane slips that RESUME records (L7 ×3, L9 ×3) were re-read as well:

- L7's two `jsr` slips (`0x073E86`, `0x073E8E`) are confirmed.
- L9's three listing-convention slips (`0x0743BA`, `0x030240`, `0x031CD2`) are confirmed.
- L7's "table load at `0x073A34`" matches the image. Doc 104 never mis-cites it: its only cite
  is the correct range `0x073A28`–`0x073A3C` (l.99).

This lane adds four slips that no earlier lane recorded:

- 104:28 repeats `0x073E88`.
- 93:64 places "the command dispatcher" at `0x073A36`. That address is inside the 8-byte load
  `0x073A34 78 b0 6b 26 00 07 44 72`.
- `ida\out\dsp-1c03\opcode-1c.tsv` row 39 repeats `0743BC`.
- The `AAD4.b0` → n = 9 case above.

Section 3 indexes the 20 L-wave corrections to older docs: docs 06, 14, 51, 57, 77, 84, 85, 86,
93 and 104, plus the 388,490 denominator. For each row, both doc lines were text-checked and at
least one anchor byte run was re-read.

- No row changes a mask byte. Proven Δ = 0 and named Δ = 0 against the proposed MAIN_FINAL6
  masks (364,786 / 501,656).
- No row changes a mission answer.
- No existing doc was edited.

## Method

`ida\out\errata-k-l\m14_errata_check.py` is plain read-only Python. It makes no IDA call and
opens no device. It does the following:

1. Hashes both images. MAIN is `8e3ecd05409b2c31…c1bcce` and SUB is `b93570b3c2f69ccb…8c6230`,
   both unchanged.
2. Re-reads **46 byte runs** (C01–C46) and runs **13 computed checks** (X01–X13):
   `bytecheck.tsv`, 59/59 PASS. X13 re-scans this doc's own inline `0xADDR bytes` citations
   (60 found; the only 4 that differ from the image are the quoted as-written slips). MAIN file offset equals the address. SUB file offset is the
   address minus `0xFFC00000`.
3. Text-checks every errata row twice:
   - the quoted "as written" text on the cited line of the owning doc;
   - the L13 or RESUME line that recorded the item.

   Results: 21/21 and 20/20 PASS. B05 has no source line because it is new.
4. Text-checks both ends of each index row: 40/40 PASS.
5. Reads three mask bytes at every corrected address:
   - `l-wave-recon\final6_proven_mask.bin` (P6);
   - `final6_named_mask.bin` (N6);
   - `main-final4\final4_proven_mask.bin` (P4).

The computed checks are scoped as follows:

- X01, X02, X07 and X08 are whole-content scans (`0x000000`–`0x07FFFF`) at even offsets.
- X03 covers `0x034E42`–`0x03F4EA`.
- X06 is the `ac xx` ladder in `sub_5A506`.
- X09 is SUB `0xFFF3A9D3`–`0xFFF3AA5A`.
- X10 reads `ida\out\recount\work\items_h1.tsv`.

Scope limits:

- Doc 110's other 895 PASS citations were not re-run.
- Doc 110 also has two `DIFFERS-EXPLAINED` re-run rows in `counts.tsv`. They concern `l97_scan.py`
  and `l95_oracle.py` picking up the newer final5 mask. They are about script reproducibility, not
  doc errata, so they are not rows here.
- Section 3 checks each correction's anchor bytes. It does not re-derive the superseding lanes'
  findings.
- Doc 103 counts "301 `rts/l` and 251 `rte/l`" for I13. That count was not reproduced. Its scope
  is not stated, and `bu_all.tsv` gives other totals over its other scopes. One `rts/l` was
  byte-checked instead: `0x0767BC 54 13`, which `bu_all.tsv` decodes as `rts/l er2-er3`.
- The mnemonics are hand-decoded H8SX, cross-checked against `bu_all.tsv` where cited.

## Findings

### 1. K wave and follow-up docs 83–97 (`errata.tsv` rows A01–A12)

The "Mask" column gives the state at the corrected address. P = proven and N = named, in proposed
final6. final4 is the same in every row.

| # | doc:line | as written | corrected (Confirmed bytes) | class | mask / credit |
| --- | --- | --- | --- | --- | --- |
| A01 | 85:235 | `0x04B46E` `f4 2a … 6e e4 00 01` | `0x04B46A f4 2a 68 e4 6e e4 00 01`: `mov.b #0x2A,r4h`, then **two** `'*'` stores, `mov.b r4h,@er6` at `0x04B46C` and `mov.b r4h,@(1,er6)` at `0x04B46E` | address −4 (run cited from the store) | P N, no change |
| A02 | 96:113 | `0x0020A0` (`fc 00 6a 8c 80 04`) | `0x00209E fc 00 6a 8c 80 04`. The store is at `0x0020A0`, so the address is right as a store address | listing convention, −2 | P N |
| A03 | 87:132 | `0x345AA` `cmp.b #1` | `0x0345AE ac 01`. `0x0345AA 6a 0c 8a a0` is the `FF8AA0` load | address +4 | P N |
| A04 | 87:132 | `0x34B58` `cmp.b #2` | `0x034B5C ac 02`. `0x034B58 6a 0c 8a a0` is the load | address +4 | P N |
| A05 | 97:178 | "The following `00 06` bytes are not copied." | The bytes after the 16-byte pair `0x00F672`–`0x00F681` are `0x00F682 00 00 00 00 00 06`. `00 06` is at `0x00F686`. "Not copied" stands | address/wording +4 | N only (data) |
| A06 | 90:103 | `not.b r2h` (`0x04954A`) | `0x04954A 0c 2b` (`mov.b r2h,r3l`), then `0x04954C 17 0b` (`not.b r3l`). The effect is the same | mnemonic | P N |
| A07 | 90:104 | `not.b r2l` (`0x049556`) | `0x049556 0c ab`, then `0x049558 17 0b`. The effect is the same | mnemonic | P N |
| A08 | 93:157 | "Twelve sites" | **11** `6a 8X 95 6d` stores at `02F622 03111E 0341E4 03421A 03429A 0342BE 0342D2 034316 03433A 034860 039436`. Each is preceded by `fc 02`. There are no word or abs32 stores (X01) | count | P N |
| A09 | 93:193 | "8 references in the whole image" | **9** byte-level references at `002E18 0358CA 035A22 035EDC 035F86 073B3A 0743BC 0743C2 0743CC`. 8 of them are in proven code. `0x035F86 6a 10 b0 cc 73 00` follows `bra` `0x035F84 40 30` and is P6 = 0. The "4 stores" count is right (X02) | count (scope) | `035F86` N only |
| A10 | 97:176 | "`FF8010` does not occur in `0x034E42–0x03F4EA`" | It occurs once: `0x03F38E 6a 04 80 10` (`mov.b @FF8010,r4h`). That is outside `sub_34E42` and `sub_3F4A2` (X03), so the claim should be scoped to those two functions | count / scope | P N |
| A11 | 83:200 | "same format as main-final3: 1,048,576 bytes" | `final3_*_mask.bin` are **505,684 B**. `final4_*_mask.bin` are 1,048,576 B. Both are 0/1 per byte (X04) | wording | — |
| A12 | 93:99 | "Event 15 there is `0x022718` in all four." | True for n = 1, 6, 7, 8. `sub_10FA8` also selects n = 4 (`0x011006 fb 04 6a 0c aa d1 ec 0c 46 14`) and n = 9 (`fb 09 … aa d3 ec 0f 46 0a` and, **new**, `6a 0c aa d4 ec 01 46 02 fb 01`). Both tables hold `0x03FFA0` at event 15 (`0x011A68`, `0x011BBC`; X05). n = 6/7/8 come from the 12-pair table `0x011038` | scope note | P N |

What this lane adds to doc 110:

- **A01.** Doc 110 named one store. There are two.
- **A12.** Doc 110 listed `AAD3 & 0x0F` as the only n = 9 condition. `AAD4.b0` set (with
  `AAD1 & 0x0C` and `AAD3 & 0x0F` clear) also gives n = 9: `0x011020 46 02` skips
  `mov.b #1,r3l`, so r3l stays 9.

All the other rows agree with doc 110 on bytes.

### 2. L-wave lane citation slips (`errata.tsv` rows B01–B09)

| # | doc:line | as written | image (Confirmed) | verdict |
| --- | --- | --- | --- | --- |
| B01 | 104:164 | `0x073E88 5e 03 4a 52` | `0x073E86 5e 03 4a 52` (`jsr @0x034A52`). `0x073E88` is the operand `4a 52` | RESUME confirmed (+2) |
| B02 | 104:164 | `0x073E90 5e 03 50 e4` | `0x073E8E 5e 03 50 e4` (`jsr @0x0350E4`) | RESUME confirmed (+2) |
| B03 | 104:28 | `0x073E88 jsr sub_34A52 → sub_35872` | The address should be `0x073E86`. The "→ `sub_35872`" part is superseded by doc 105 (I08) | **new**, same slip as B01 |
| B04 | 104:99 | (`0x073A28`–`0x073A3C`) | `0x073A28 6a 0b 97 fc` … `0x073A34 78 b0 6b 26 00 07 44 72` (indexed load) … `0x073A3C 5d 60` | **correct as written**. RESUME's "table load at `0x073A34`" matches. No mis-cite of it was found in doc 104 or in `ida\out\pdn-node-table\` (Not found; scope: doc 104 full text, plus its lane TSVs/TXT grepped for `073A3x`) |
| B05 | 93:64 | "The command dispatcher `0x073A36`" | `0x073A36` is inside the 8-byte load at `0x073A34`. Read from there, `bu_all.tsv` gives a bogus `mov.w @0x74472:32,r6`. The routine is `sub_739FA` | **new** (K-wave doc; L13 did not grade address-only cites) |
| B06 | 106:130 | `0x0743BC fc 01 6a 8c b0 cc` | `0x0743BA fc 01 6a 8c b0 cc`. The store is at `0x0743BC`. l.131's `0x0743CC` (arg 0) is a store address with no bytes, and it is right | RESUME confirmed (listing, +2) |
| B07 | 106:153 | `0x030242` … `fc 05 6a 8c aa ce` | `0x030240 fc 05 6a 8c aa ce`, after `0x03023A 6a 18 aa d1 70 00` | RESUME confirmed (+2) |
| B08 | 106:153 | `0x031CD4` | `0x031CD2 fc 05 6a 8c aa ce` (band-B twin) | RESUME confirmed (+2) |
| B09 | `opcode-1c.tsv`:39 | `0743BC	fc 01 6a 8c b0 cc` | `0743BA` | **new** (lane table, same as B06) |

A regex sweep of docs 104 and 106 for `ADDR bytes` pairs found only B01, B02, B06 and B08. B07
sits behind a `/` separator. All the other inline runs in those two docs match the image.

### 3. Index of L-wave corrections to older docs (`index.tsv`)

A reader of the old docs should treat these statements as superseded. Both line pointers in every
row are text-checked. The anchor IDs refer to `bytecheck.tsv`, and every anchor passes.

| # | old doc:lines | superseded | now | superseding doc:lines (lane) | anchor (Confirmed) |
| --- | --- | --- | --- | --- | --- |
| I01 | 06:278 | CPU→DSP `0x1C` = "DATA TEXT SET" | That name belongs to DSP→MAIN event `0x9C` (06:291 itself). The CPU→DSP trace ladder has no `0x1C` case | 106:137–141 (L9) | `0x05AF34` "DSP>CPU: DATA TEXT SET"; ladder `ac` values `03 05 06 07 08 09 0A 18 1A 12 1D 0B 11 19 16 15 32 31 1F`, no `1C` (X06) |
| I02 | 93:205–206 | `1C` trace label "DATA TEXT SET" | as I01 | 106:137–141 (L9) | as I01 |
| I03 | 14:32, 239–240, 260 | `TXAT`/`RXAT`/`ERAT` are level/error controls | `RXAT=` carries a headset AT command, and `TXAT=1` enables that pass-through (Inferred in doc 107) | 107:204–207 (L10) | SUB `0xFFF3AEB4 fb e2 78 05 01 00 f8 e4 01`; `0xFFF4AEDA` "TXAT=%d\r\n"; `cmp` chain `CKPD=200` (X09) |
| I04 | 51:24, 95 | the frame-checksum error replies `0xFFFE` | The payload is the block number. `0xFFFE` is sent only for the 32-bit-sum and picture-step cases | 109:216–217 (L12) | SUB `0xFFEDC8FE b2 a9`, `0xFFEDC902 55 21 0c` |
| I05 | 57:343 | `1C` `[2]` packed for `B0B8` 9/`0x0D` (implied live) | Sub-ops 9 and `0x0D` are dead. The only `B0B8` store is the constant 3 | 106:101–102 (L9) | `0x05C440 fc 03 6a 8c b0 b8`, the sole store (X07) |
| I06 | 57:682 | "a press while busy is refused, not queued" | State `0x14` retries for 3.0–3.1 s, then refuses | 105:378–380 (L8) | `0x0359EA 6a 0c 95 98 58 60 fe b2` → `0x0358A4` (X12) |
| I07 | 77:27–28 | host `0x11` → `sub_34A52 → sub_35872` keys the radio | `0x034A52` = `bset AA30.b4 ; bra rts`. The `jsr sub_35872` at `0x034A6A` is skipped. `'@'` needs `FF94C0 == 1` | 105:381–385 (L8) | `0x034A52 6a 18 aa 30 70 40 40 20`; `0x034A6A 5e 03 58 72`; `0x034A7A 54 70`; `0x073E58 6a 0c 94 c0 ac 01 46 4e` |
| I08 | 104:28, 160 | L7's `'@'` arg `0x11` → `sub_35872` | as I07. L8 corrects L7 within the same wave | 105:63–64 (L8) | as I07 |
| I09 | 77:27 | `sub_73E58` = "host command `0x11`" | slot `0x10` (`'@'`) | 104:25–29 (L7) | `0x0744B2 00 07 3e 58`; `0x073A6A 0c ac fd 30 18 dc 6a 8c 97 fc` |
| I10 | 93:230–232 | slot `0x10` vs `0x11` not settled | settled: `0x10` | 104:25–29 (L7) | as I09 |
| I11 | 84:189, 191 | E4 → `sub_4811E`, E6 → `sub_4802E` | swapped: E4 = `sub_4802E`, E6 = `sub_4811E` | 108:81–85 (L11; also 107:107–109, L10) | `0x0475EC 00 04 80 2e 00 04 81 1e`; `0x04803C aa e4`; `0x04812C aa e6` |
| I12 | 85:118–119 | 195 of 511 zones pending | 154 are joined; 41 can never fire | 103:32–36 (L6) | `0x026634 79 24 f8 01`, `0x02653C 79 24 f3 c3`, the only such compares (X08) |
| I13 | 85:104 | K3's descent (ends only at `rts`/`rte`) | `rts/l`, `rte/l` and `sleep` also end a function | 103:77–78 (L6) | `0x0767BC 54 13` (`rts/l`), then `0x0767BE` `stm.l` prologue |
| I14 | 86:243 | T4 carrier length open | AACE 5 × 500 ms ≈ 2.5 s | 106:167 (L9; 105:391) | `0x034BDC fc 32 6a 8c 95 79`; `0x030240`/`0x031CD2 fc 05 6a 8c aa ce` |
| I15 | 86:212, 244 | caller of `B0B9=0x1E` not traced | a key on a WIRES-X screen | 106:190–191 (L9) | `0x067FEE fc 1e 6a 8c b0 b9`; `0x0113E4 00 06 64 c2`; `0x010982 5d 60` |
| I16 | 93:15 | PTT `0xFFFF4E` b7 "active low" | At register level, bit set = pressed. The pin sense is Unknown | 112:131–137 (L15) | `0x00FC66 2a 4e ea 80`; `0x00FC90 aa 00 46 06`; `0x00FC9C aa 00 47 3a` |
| I17 | 93:74, 115 | serial-frame PTT: link Unknown | SUB→MAIN frame E6 (SCI_6), sent for a Bluetooth headset button | 107:5–12 (L10) | `0x04812C aa e6`; table slot `0x0475F0`; SUB `CKPD=200` (X09) |
| I18 | 93:221 | battery/temperature/ADC "Not found" | an AN1 foldback and cutoff exists (in `sub_35BAA`, outside K11's scope) | 105:388–390 (L8) | `0x035BBA ac eb 45 54 ac ef 45 1c ac f4 45 20`; `0x035BD2 5e 03 4f 74 fc 01 6a 8c aa d9` |
| I19 | 93:157 | Twelve `FF956D` writers | 11 (A08) | 110:214 (L13) | X01 |
| I20 | RESUME-FULL:265 (doc 95: none) | 388,490 decodable denominator | 318 of the window's 1,088 B were counted; the consistent figure is 389,260 | 98:140–144 (L1) | `items_h1.tsv` is_code 388,484 (+6); window 99 heads / 318 B; 1,088 − 318 = 770 (X10). Doc 95 contains no "388", "denominator" or "%" (X11) |

RESUME also lists "docs 85/87/90/96/97 citations: seven slips and three counts (L13)". Those are
Section 1. This index adds no entry for docs 87, 90, 96 or 97 beyond Section 1. For doc 95, the
only L-wave correction concerns the RESUME ledger line. Doc 95 itself states no denominator.

## USB relevance

None of the three mission answers changes.

- **Q1 (USB).** No row touches a USB register or the USB module. B04/B05 and I07–I10 concern the
  SCI-A node-command dispatcher, which touches no USB register (doc 104).
- **Q2 (SDR).** No row touches a sample path.
- **Q3 (DSP).** Several rows touch DSP reach:
  - I01/I02 confirm by byte scan that the vendor trace has no name for `1C`. Its meaning stays
    Unknown.
  - I05 confirms the single `B0B8` store, so `1C` stays a fixed `1C 03`.
  - I07/I08 confirm that `'@'` arg `0x11` sets `AA30.b4` and returns, without reaching
    `sub_35872`.

  The owner-relevant keying list in RESUME is unchanged.

## Open

1. **A docs-only pass** can apply Sections 1–2 to docs 83–106 if the owner wants that. The rows in
   `errata.tsv` can be pasted as they stand. I19/A08 and A09 together fix doc 93 §4–§5.
2. **Doc 93 §1, n = 4 and n = 9.** Name what PTT release does under TX-time tables n = 4 and
   n = 9. Event 15 = `0x03FFA0` in both. n = 9 is now known to cover `AAD4.b0` as well (A12).
3. **Doc 103's 301 `rts/l` / 251 `rte/l` counts** need a stated scope before they are reused.
4. **Pinning `l97_scan.py` / `l95_oracle.py`** to a named mask (doc 110 Open 3) is still open.

## Files (`ida\out\errata-k-l\`)

| file | content |
| --- | --- |
| `m14_errata_check.py` | the read-only checker; reruns in seconds |
| `errata.tsv` | 21 rows: A01–A12 (Section 1), B01–B09 (Section 2). Columns: `id`, `section`, `doc`, `line`, `as_written`, `corrected`, `class`, `credited_byte_affected`, `mission_answer_affected`, `evidence`, mask at corrected (P6/N6/P4), `source` (doc 110 or RESUME line), and two text checks |
| `bytecheck.tsv` | 46 byte runs plus 13 computed checks, 59/59 PASS |
| `index.tsv` | 20 rows, 40/40 text checks |
| `run.txt` | hashes and summary |

Model: claude-opus-5-5.
