# J-wave ledger and citations, re-derived from disk (lane K12)

## Verdict

The J-wave ledger reproduces exactly from the bytes and masks on disk. Both image
sha256 values match (`8e3ecd05…` MAIN, `b93570b3…` SUB). MAIN_FINAL3 proven is
**368,366** and named is **497,314**. J2's +72 B at `0x04E2D6`–`0x04E31D` has 0/72
bytes in `final3_proven`, its `rts` is at `0x04E31C`, slot 68 of `0x04ABE4` points at
it, and `jsr @er6` is at `0x052232`. That gives totals **368,438 / 497,384**. SUB is
**464,263** and the headline is **93.37%** (93.3663%). All 190 ledger, count and
arithmetic checks pass.

Of 310 byte citations from docs 69–82 and the J section of `RESUME-FULL.md`:

- **292 pass.**
- **14 have the right bytes at the wrong address.** The bytes exist exactly, 2 or 4
  bytes away from the cited address.
- **3 fail as written.** One is a wrong byte transcription (doc 80, table `0xCE40`).
  The other two are loose prose descriptors.
- **1 cannot be checked.** It is opcode notation, not a byte run at an address.

No discrepancy touches the ledger, a mission answer, or any credited byte. The J8
timing (5.000 ms, 2.2 ms) and J12's 662/663 both re-derive from their own tables.
This lane makes no new reverse-engineering claim. Everything was read-only: no image
was modified, IDA was not used, and nothing was connected to a radio.

## Method

One Python script, `ida\out\ledger-reverify-j\k12_reverify.py`, reads the files on
disk and makes no IDA call. MAIN file offset = address. SUB file offset = address −
`0xFFC00000`.

1. **Image hashes.** sha256 and size of both `decrypted\*.bin`.
2. **Masks.** Counted set bytes in `main-final3\final3_proven_mask.bin`,
   `final3_named_mask.bin` and `main-final2\final2_proven_mask.bin`. Checked
   `final3 \ final2` (= I15's +54) and `final2 \ final3` (= exactly the two I12
   blocks, 42 + 78). Checked the J2 range against all three masks, J4's +16 B against
   `final3_proven`, and `final3_proven_runs.tsv` (928 runs, sum 368,366). Counted the
   SUB `mask_final2_headline_w2.bin` and `sub-final\raw\mask_final_headline_w2.bin`.
   Recomputed every percentage.
3. **Citations.** Every address+bytes, address+BE32/LE32, address+string, listing
   line, and "bytes within a routine" claim in docs 69–82 and `RESUME-FULL.md` lines
   10–227 is a row in `citations.tsv`, with doc, line, expected and actual bytes.
   - Where a doc names an instruction but gives no bytes, I checked the standard
     H8S/RX encoding. The `note` column says so.
   - When a run is not at the cited address, the script searches ±8 bytes. A hit there
     is graded **FAIL-OFFSET** (bytes correct, address wrong) instead of FAIL.
4. **Table-backed claims.** These were decoded from the image and graded as their own
   rows:
   - doc 71's nine touch-zone tables;
   - doc 79's icon, font, glyph and geometry record tables;
   - doc 80's 206-entry exit table at `0x19A9E`;
   - doc 76's `guard-sites.tsv`.
5. **Whole-image pattern counts.** I re-ran the count claims: `bb c2` 88 times;
   `6a 8c fe f0` once; `79 2X 89 80` nine times; zero hits for `5e/5a/00 03 c6 68`; and
   others listed in `counts.tsv`.
6. **Arithmetic and lane tables.** Every arithmetic identity in docs 69, 70, 72, 75, 76,
   78, 79 and 80 was recomputed. The lane tables they summarise were recounted:
   `sites.tsv`, `families.tsv`, `functions-disposition.tsv`, `dbcode-runs.tsv`,
   `disposition.tsv`, `settings-49.tsv`, and the F5/I6 settings tables.
7. **Lane outputs exist.** Checked every `ida\out\` file each J doc names (14 lanes)
   and the 16 named `ida\jobs\j*.py` scripts. All are present.
8. **Coverage.** `coverage.tsv` lists every line in scope that contains a hex byte run
   and records whether it is checked. Of 155 such lines, 120 carry a checked citation.
   The other 35 are:
   - encoding notation with no address (`78 b0 6b 26`, `5d d0`);
   - USB vendor request codes (`41 D1`/`41 D3`);
   - pattern-count lines, which are checked in `counts.tsv`;
   - continuation lines.

Scope limits:

- Byte re-reads inside the closed window were limited to the four BE32 pointers at
  `0x07B4C4`–`0x07B4EC` and the BE24 at `0x078570` that J4 cites. They were read, not
  decoded.
- I did not rebuild any mask from a fresh descent. As in J13, the named masks are
  confirmed by recount and arithmetic only.

## Findings

### 1. Ledger (`counts.tsv`) — all PASS

| item | re-derived | expected |
| --- | ---: | ---: |
| sha256 MAIN / SUB | `8e3ecd05…c1bcce` / `b93570b3…8c6230` | match `resume.md` |
| `final3_proven_mask` set bytes | 368,366 | 368,366 |
| `final3_named_mask` set bytes | 497,314 | 497,314 |
| `final2_proven` → `final3` | +54 (I15), −120 (exactly `0x054D22`–`4B` + `0x054F3A`–`87`) | 368,432 + 54 − 120 |
| J2 `0x04E2D6`–`0x04E31D` length / in `final3_proven` / in `final2_proven` | 72 / 0 / 0 | 72 / 0 |
| J2 bytes already named | 2, so **+70** | +70 |
| `rts` at `0x04E31C` | `54 70` | `54 70` |
| `0x04ABE4 + 68×4 = 0x04ACF4` BE32 | `0x0004E2D6` | `0x04E2D6` |
| `0x05222A` load base / `0x052232` | `…00 04 ab e4` / `5d 60` (`jsr @er6`) | — |
| J4 +16 B (`0x065EFA`/`F00`/`F06`) in `final3_proven` | 0 (not credited) | 0 |
| MAIN proven 368,366 + 72 | **368,438** | 368,438 |
| MAIN named 497,314 + 70 | **497,384** | 497,384 |
| SUB headline+w2 (both published masks) | **464,263** | 464,263 |
| 505,684 + 524,288 | 1,029,972 | 1,029,972 |
| (497,384 + 464,263) / 1,029,972 | 961,647 → **93.3663%** | 93.37% |
| 497,384 / 505,684 | 98.3587% | 98.36% |
| 368,438 / 505,684; / 388,490 | 72.8593%; 94.8385% | 72.86%; 94.84% |
| 464,263 / 524,288; 520,552 / 524,288 | 88.5511%; 99.2874% | 88.55%; 99.29% |
| I-wave 961,577 + 70 | 961,647 | 961,647 |

The intermediate arithmetic also checks: 365,570 + 1,544 + 116 + 66 + 1,136 + 54 =
368,486, and 368,486 − 120 = 368,366. On the named side, 497,139 + 141 + 34 = 497,314,
and so does 497,280 + 34. Doc 69's 72.845% and 94.82% are the same ratios taken on
368,366.

### 2. Citation discrepancies (`citations.tsv`; all other rows PASS)

**A. The address names the store, but the bytes listed start at the immediate load
before it (5 rows).** The bytes are correct and the instruction named is at the cited
address. The listing simply starts its byte column at the preceding `mov`.

| doc:line | cited | bytes actually start at |
| --- | --- | --- |
| 74:152 | `05549c fc 08 6a 8c 81 83` | `0x05549A` (store at `0x05549C`) |
| 74:158 | `038674 fc 00 6a 8c aa e8` | `0x038672` (store at `0x038674`) |
| 76:172 | `056776` `79 04 00 00 3c f0 6b 84 ff f6` | `0x056772` (`3c f0` at `0x056776`) |
| 76:172 | `056826` (same) | `0x056822` |
| 76:172 | `056950` (same) | `0x05694C` |

**B. The address is wrong (9 rows).** The bytes exist exactly at the corrected
address.

| doc:line | cited address and bytes | actual at the cited address | correct address |
| --- | --- | --- | --- |
| 70:107 | `04E31A 5e 05 27 80` (jsr @0x052780) | `27 80 54 70` | `0x04E318`. The 72-B extent and the `rts` at `0x04E31C` are unaffected. |
| 71:86 | `0x026F4A` `mov.w r3,@0xFFBBC2` (`6b 83 bb c2`) | `bb c2 6a 18` | `0x026F48`. `key-dispatch\writers-0xFFBBC2.tsv` has the same +2 error. |
| 72:63 | table entry `00 06 5F 00` at `0x02B3DC` | `5f 00 00 06` | `0x02B3DA` |
| 72:64 | table entry `00 06 5F 06` at `0x02B3E0` | `5f 06 7a 06` | `0x02B3DE`. The table runs from `0x02B3C2` (after `rts` at `0x02B3C0`), and `0x065EFA` is at `0x02B3D6`. |
| 72:129 | false-match `5A` at `0x074342` | `6b 84 96 f8` | `0x074340` (`5a 03 6b 84`, the immediate of `mov.w #0x5A03` at `0x07433E`) |
| 73:94 | writer `0x054F1E` `01 00 6b 84 81 84` | `6b 84 81 84 7a 04` | `0x054F1C`. `usb-status0\writers-readers.tsv` already has `054F1C`. |
| 73:95 | writer `0x05601E` (same form) | `6b 84 81 84 7a 04` | `0x05601C` (also correct in the lane TSV) |
| 76:126 | `002A5A 56 70` "rts" | `94 ba` | `0x002A5E`. Also, `56 70` is **rte**, which is correct for the vector-110 ISR; the listing labels it `rts`. |
| 80:24 | save stub for `n=0xAA` at `0x1935E` | `5a 03 cc bc` (its `jmp`) | `0x1935A`. Doc 80's own lines 45 and 145 already say `0x1935A`. |

**C. Fails as written (3 rows).**

| doc:line | claim | actual |
| --- | --- | --- |
| 80:66 | table `0xCE40` = `02 03 04 05 06 07 08 09 01 0F 00` | `02 03 04 05 06 07 08 09 **0a** 01 0f 00`. The doc drops the `0x0A` entry, so the table has 12 bytes, not 11. |
| 72:91 | `0x0376C8` "152 B monotonic" | Three concatenated ascending ramps (`11…1a`, `11…19`, `0f 0f 11…5b`). The cited `11 11 … 12 12` does pass. This is a descriptor only and does not affect the data/code disposition. |
| 79:129 | font blocks "0–7 kanji 14×14 … 9–25 base `0x0020`" | Block 3 is 7×14 with base `0x0020`, and blocks 11 and 18 have base `0x0023` and `0x002E`. Block 8 == block 2 (PASS). The lane's own `font_blocks.tsv` matches the image; only the prose is loose. |

**D. Not checkable (1 row).** 77:92 says "`0x15` (table `05C40A`, `1C 03`)". Address
`0x05C40A` holds BE32 step pointers (`0x05B4E4`, `0x05B522`, …). `1C 03` is
opcode/argument notation, not a byte run at that address.

The other 292 rows pass byte for byte. Representative rows:

- **J1:** the record cells `0x028C3E/46/9E/A6`; the stubs at `0x02A924` and `0x028C4A`;
  `fc 01/02/01` at `0x003282/94/B8`; `40 2a` at `0x054D20`; `rte` at `0x054F38`.
- **J2:** the `0x04E2D6` listing; slots 68 and 69; slots 97, 163 and 183 of `0x04AB70`;
  `0x054FF8`.
- **J5:** all 7 `FF8184` writers and 9 readers, by operand.
- **J6:** all listed `event-4f` and `fc 14` bytes.
- **J7:** the full `054c7c`–`054d4b` listing and the EP1 loop.
- **J8:** TPU5 init, vector 110 = `00 00 2a 30`, slot 66 = `00 05 61 c2`, and the guard
  handler.
- **J9:** the `0x00F9A8` 12-byte ROM tail.
- **J10:** the SUB branch bytes, with each branch target recomputed.
- **J11:** geometry field 0, the `0x7DFFFF` and `#FFED7F60` immediates, the icon kinds
  (223 / 30 / 1), glyph_tbl8 (`0x2422`…, +2 always 0), and geometry field 7 = 1.
- **J13:** its own runs.
- **J14:** the I2C/3-wire bytes and the `05E96A` listing.
- **RESUME:** the J-section bytes.

### 3. Pattern counts and lane tables (`counts.tsv`) — all PASS

- **Whole-image counts.** All match the docs:
  - `bb c2` ×88, `bb c3` ×0, `6b 8X bb c2` ×3 (J3);
  - one `fc 14` injector at `0x00FDFE` and one `fc 4f…aa e0` at `0x05548E` (J6);
  - `6a 8c fe f0` only at `0x002484`, `79 04 4e 20` only at `0x0024A2`, and
    `79 2X 89 80` ×9, identical to `guard-sites.tsv` (J8);
  - 0 of `ff a9 e0` in content (J1);
  - 0 BE32 in `0xFF5C06`–`0xFF5C44`, and one store each to EE08/09/0A (J7);
  - 7 store forms to `FF8184` (J5);
  - 0 hits for `5e/5a/00 03 c6 68`, `5e 03 35 32` only at `0x077DB2`/`0x077DF6`,
    `jsr @0x3BDAC` ×32 and `jsr @0x3BF4C` ×31 (J14);
  - the abs16 reference to `89 ca` only at `0x00E678` (J12).
- **J2 `sites.tsv`.** 188 sites: 174 reached, 14 unreached; 178 d32 and 10 d16; 173
  roots. `families.tsv` sums to `n_new` = 1.
- **J4 `functions-disposition.tsv`.** 83 functions = 5 + 3 + 15 + 60, with
  36 / 958 / 604 / 2,286 B. `dbcode-runs.tsv` has 598 runs totalling 22,262 B. Every
  sum in doc 72 checks.
- **J10 `disposition.tsv`.** 156 functions = 31 merges (2,279 B) + 125 dead (7,780 B).
  The prior reach classes are 89 cu (5,321 B) and 67 dead (4,738 B). The 125 dead
  heads split 59 from cu (3,414 B) and 66 from dead. Merges go 19 into cu owners
  (824 B) and 12 into dead owners (1,455 B). `FFF2A70B` is 372 B.
- **J12 662/663 is consistent with its tables.**
  - F5 `settings-bytes.tsv` has exactly **663** rows with a dedicated writer and no
    menu item.
  - Of these, 614 are in I6's 644-row `settings-bytes-ext.tsv` (class
    `dedicated-unattributed`). The remaining **49** are exactly the 49 keys of
    `settings-49.tsv`.
  - That table has 47 `live*` rows, 1 `read-live/save-dead` (`FF8937`) and 1 `DEAD`
    (`FF89CA`).
  - So 614 + 48 = **662 attributed**, and 662 + 1 = 663.
  - The 15 group sizes sum to 47 live.
  - On the exit table at `0x19A9E` (206 BE16, handler = `0x148A0` + val): no slot
    targets `0x192A0`/`0x192A8`/`0x19352`/`0x1935A`. Slot `0x1D` gives `0x19290` and
    slot `0x30` gives `0x192B0`, with nothing in between. Doc 80 calls these ids
    `0x2B`/`0x3E`, which is index + `0x0E`; I did not verify that bias independently.

### 4. J8 timing — internally consistent

- **TCR `0x21`.** CCLR = 001 and TPSC = 001 (Pφ/4). TIER `0x41` sets TGIEA. TSTR
  `0x20` is bit 5, so channel 5.
- **Tick period.** TGRA `0x4E20` = 20,000.
  - Counting 20,000 periods at 4 MHz gives **5.000 ms**.
  - Doc 76's TGRA+1 count gives 20,001 / 4 MHz = **5.00025 ms**.
  - RESUME writes "20001/4 MHz = 5.000 ms", which is the same value rounded to 3
    decimals. Not a conflict.
- **Script guard.** `0x8980` = 35,200. At φ/1 = 16 MHz, 35,200 × 62.5 ns =
  **2.2000 ms** exactly. Overflow is 65,536 / 16 MHz = 4.096 ms.
- **Tiers.** 5 × 2 = 10, × 10 = 100, × 10 = 1000 ms.
- **Vector offsets.** 110 × 4 = `0x1B8`; 66 × 4 = `0x108`.
- **TCR restart writes.** All four TCR3 writes are `0x00` (`0x0022F6` plus the three
  restart writes).

### 5. Lane outputs

All 14 J lanes' `ida\out\` directories and every table their docs name are present.
That includes J6's `work\p1`/`p2`, J7's `ram-ff5c06.tsv` and J14's `j14_dis_*.txt`.
All 16 named job scripts are present in `ida\jobs\`.

## USB relevance

None of the three mission answers changes; this is a verification lane. Every
USB-bearing citation passes on bytes. That covers:

- J5's `FF8184` writers and readers (two writer addresses need the −2 fix above);
- J6's `41 D1` beep (`0x05548E`) and the `0x055520` status-stage gate;
- J7's ISR0/1/2 writes, the dead EE2F pulse block, the EP1 copy loop and the
  `0xFF5C44` overrun arithmetic;
- J4's in-window USB-module pointers `0x07B4C4`–`0x07B4EC`.

The USB, SDR and DSP findings therefore rest on correctly read bytes.

## Open

1. **Errata for the owning docs** (this lane does not edit them). They are trivial,
   but they make the cites reproducible:
   - 70:107 → `04E318`;
   - 71:86 and `writers-0xFFBBC2.tsv` → `0x026F48`;
   - 72:63/64 → `0x02B3DA`/`0x02B3DE`, table base `0x02B3C2`;
   - 72:129 → `0x074340`;
   - 73:94/95 → `0x054F1C`/`0x05601C`;
   - 76:126 → `002A5E 56 70 rte`;
   - 80:24 → `0x1935A`;
   - 80:66 → add `0a`.
2. **Optional listing convention.** In 74:152/158 and 76:172, either cite the start of
   the immediate load or list only the store bytes.
3. **Mnemonic notation in doc 76 (not a byte error).**
   - `6b 0c ff f6` and `79 2c 89 80` are written as `r4`. In the H8S register field,
     `c` selects `e4`, which is how doc 82's own `0d 4c` (`mov.w r4,e4`) reads.
   - The compare value and the 2.2 ms result do not depend on this.
   - A next pass could normalise the mnemonic to `e4`.
4. **Named-mask independence.** As in J13, the named masks (497,314) were confirmed
   by recount, not by a fresh rebuild. The open item from doc 81 still stands.

### Files (`ida\out\ledger-reverify-j\`)

- `k12_reverify.py`: the script, read-only, reruns in under a minute.
- `citations.tsv`: 310 rows with source doc, line, address, expected, actual,
  pass/fail, kind and note.
- `counts.tsv`: 190 PASS checks covering sha256, masks, ledger, percentages, pattern
  counts, lane tables, arithmetic and file existence, plus per-doc citation tallies.
- `coverage.tsv`: every line in scope with a hex byte run, with whether it is cited
  and, if not, why.

Model: claude-opus-5-5.
