# 130 — The 425 B of M6 tables with no reader (Lane N3)

> Lane N3, model `claude-opus-5-5`. Owner-side, read-only static analysis of `decrypted\FT3D_MAIN_ver102_EXP.bin`
> (H8SX, big-endian, base 0, so file offset = address).
>
> - **Database.** One private database, `ida\db\jobs\N3_TABLES\N3_TABLES.i64`, made with `--copy-from ida\db\jobs\M1_MAIN_FINAL6\M1_MAIN_FINAL6.i64`. The job only read from it. No other database was opened, and `run_ida.py` was not run.
> - **Nothing written.** Nothing was connected to or written to a radio. `Firmware\` and `decrypted\*.bin` are unchanged. The sha256 values `8e3ecd05409b2c31…` (MAIN) and `b93570b3c2f69ccb…` (SUB) were checked at the start, by `n3_pieces.py` on every run, and at the end.
> - **Status.** No published mask or seed was edited. Everything below is a proposal.

## Verdict

None of the 425 B has a reader. I searched every byte offset of the 1 MB MAIN image for a BE32 or abs24 value that points into these bytes. The only hits that are real instruction operands are the eight known proven loads of `0x0361E2/EE/F2` and `0x036218`. Every other hit falls across an instruction boundary. The FINAL6 seed's operands and cross-references give the same answer. No stride-13 or stride-50 multiply leads to them either.

The bytes themselves, however, form clean tables. **410 B are proposed as Confirmed unread constants**, in 30 disjoint ranges:
- **378 B in the curve region:**
  - a `u8[35][13]` table at `0x036273`, stride 13;
  - a `u8[86][50]` table at `0x036692`, stride 50;
  - a `u8[86]` step array at `0x03776B`, stride 1.
- **32 B elsewhere:**
  - a `{u16 5; 3×5-B rows}` block at `0x005796`;
  - record [0] of a 32-B record array at `0x058FFE`;
  - a `u8[24]` map at `0x05B370`;
  - the head of an FF-terminated list at `0x04C3C7`.

**15 B stay Inferred.** These are pad bytes, a 13-B block with no stride, two 2-record fragments, and the 4 B after jump table `0x04B9EA`. For those 4 B, the slot reading is now excluded, because the table's index is proven to be at most `0x10`.

**Proposed deltas:** named **+410 B**; proven **0**. None of the 425 B is set in the FINAL7 named or proven mask today.

## Method

1. **Seed dump (IDA).** `ida\jobs\n3_dump.py` ran once on `N3_TABLES`. It has no patch or retype calls. It wrote:
   - `work\n3_heads.tsv`: 130 k heads, each with operand type, value and address.
   - `work\n3_xrefs.tsv`: every cross-reference into `0x035F00`–`0x0377C1`, and into each other piece ±0x40.
2. **Raw scans (offline, `n3_scan.py`).** These cover every byte offset of the 1 MB image, regardless of how IDA typed it.
   - BE32 values in `0x036119`–`0x0377C1`, at any alignment.
   - abs24 `jsr`/`jmp` operands (`5a`/`5e` + 24 bits) into the region.
   - Each hit was classified against the FINAL6 head that covers it, as either a whole operand or one split across instruction boundaries.
3. **Word-immediate scan (`n3_scan16.py`), over content `0x000000`–`0x07B753`.** Any `79 0r..79 6r` or `7a 8r..7a fr` followed by a 16-bit value in `0x6219`–`0x77C1`. This catches an address built from two halves.
4. **Operand census (`n3_ops.py`).** Every FINAL6 code-head operand outside the region, plus a list of every register base loaded from `0x02E000`–`0x036118`. That second list checks whether a base plus a `d:16` displacement or an index could reach the region.
5. **Stride search (`n3_stride.py`).** Every `mulxu` whose multiplier is loaded with 12, 13, 50, 86 or 98 in the four heads before it. There are 11 hits: 10 with stride 50, all into RAM `0xFF104C`, and 1 with stride 12 at `0x04FEAE`, which uses base `0x04F972`.
6. **Small pieces (`n3_small.py`).**
   - For each piece outside the curve region: BE32 values in [piece − 0x80, piece end) at any offset.
   - For `0x005796`, also abs16 operands, because addresses below `0x8000` are reachable as `@aa:16`.
   - A whole-image check of `0x04C3C0`–`0x04C3D1`, `0x05B370`–`0x05B387` and `0x062580`–`0x062599`.
7. **Bounds decoded by hand.** The index of jump table `0x04B9EA`, the row index of the APRS device rows at `0x04C32E`, and the curve readers `0x035344`, `0x0354E4` and `0x03559C`.
8. **Byte-check and tiling (`n3_pieces.py`).**
   - 72 citations, 0 failures.
   - 16 structural checks, 0 failures.
   - The 39 decisions tile M6's 35 Inferred pieces exactly, 425 B.
   - Output is `verify.txt`.

**Not covered.** A pointer built by arithmetic on unrelated constants, for example `0x30000 + 0x6273` from two separate immediates in different instructions, would not be seen. The same applies to a pointer passed in from SUB at run time. The word-immediate scan catches the common two-half forms only. A whole-ROM checksum loop would be a reader of every byte. None was found: no operand equals `0x80000`, `0x7FFFF`, `0x100000` or `0x7B754`.

## Findings

### 1. Who reads the curve region, and where they stop (Confirmed)

`sub_35248` turns the BCD frequency into a per-MHz column `er1`. For example, `0x03528C 7a 06 00 03 53 2a` loads the band floor `0x03532A 42 00 00 00`, and `0x035282 7a 24 47 00 00 00` / `0x03527C 7a 01 00 00 00 32` clamp UHF at column 0x32. A band dispatch at `0x035402` (`00 03 53 d0 ×2, 00 03 53 a2 ×2, 00 03 53 74, 00 03 53 44 ×2`) then selects one table:

| Base | Stride (row width) | Load | Ends |
| --- | --- | --- | --- |
| `0x03605A` | 5 | `0x0353EA 79 04 00 05`, `0x0353F4 78 60 6a 2e 00 03 60 5a` | `0x03606D` |
| `0x03606E` | 4 | `0x03538E 79 04 00 04`, `0x035398 78 60 6a 2e 00 03 60 6e` | `0x03607D` |
| `0x03607E` | 38 | `0x0353BC 79 04 00 26`, `0x0353C6 78 60 6a 2e 00 03 60 7e` | `0x036115` |
| `0x036116` | 51 | `0x03535E 79 04 00 33`, `0x035368 78 60 6a 2e 00 03 61 16` | `0x0361E1` |
| `0x0361E2/EE/F2`, `0x036218` | 1-D, `er1` | `0x03550A 78 10 6a 2e 00 03 61 f2`, `0x0354EA 78 10 6a 2e 00 03 62 18` | `0x03624A` |

The row widths the code actually uses are 4, 5, 38 and 51. The last byte any reader touches is `0x036218 + 0x32 = 0x03624A`. **Correction:** doc 118 and M6's `pieces.tsv` give this byte as `0x036249`. After it come 40 zero bytes, `0x03624B`–`0x036272` (`00 ×40`).

### 2. The unread curve tables are clean (Confirmed constants, no reader)

| Table | Bytes | Evidence that the stride is real |
| --- | --- | --- |
| `u8[35][13]`, `0x036273`–`0x036439` | row 0 `23 23 22 23 23 23 25 25 25 26 26 26 26`, row 2 `1e 1f 1f 1f 1f 1f 1f 21 21 21 21 22 22`, row 34 `15 15 15 16 …16` | 34 of 35 rows are non-decreasing (row 0 has one dip, `23 22`). The value falls at all 34 row boundaries. The table ends exactly where the 50-B grid starts: `0x036273 + 35·13 = 0x03643A`. |
| 50-B grid, `0x03643A`–`0x03775D` | `0x03643A 2b 2b 2b 2b 2d …`; rows 9–11 (`0x0365FC`–`0x036691`) are zero | — |
| `u8[86][50]`, `0x036692`–`0x03775D` | row 0 `21 21 21 21 24 24 24 24 24 2a 2a 2a…`, row 83 `11 11 11 11 11 11 12 12 13 13 13 13…`, end `19 19 19 19` | All 86 rows are non-decreasing, and the value falls at all 85 boundaries. 50 is the largest stride for which this holds. `0x03643A + 12·50 = 0x036692`. |
| 13-B block, `0x03775E`–`0x03776A` | `5b 5b 5b 5b 5b 00 2f 2f 2f 2f 00 00 00` | No stride. This block stays Inferred. |
| `u8[86]`, `0x03776B`–`0x0377C0` | `3e ×20, 3d ×15, 3b ×51` | Non-increasing. The count, 86, equals the row count of `0x036692` (the link is Inferred). It is followed by `00` and by proven code at `0x0377C2` (`6a 10 fb a5`). |

**What the tables are (Inferred).** None of these geometries (13 or 50 columns, 86 rows) matches a live reader (4, 5, 38 or 51 columns). The only stride-50 multiplies in the image are 10 sites such as `0x0608B0 79 04 00 32 52 41 7a 11 00 ff 10 4c`, and they all index RAM `0xFF104C`, the memory-channel records. The tables are most likely curves for a different band plan or model that this build carries but does not read. The same image also carries the unread `FT2D JPN` version record at `0x06C570`.

**Typing correction (proposal).** In the FINAL6 seed, `0x03605A`–`0x0377C1` is typed as **2,860 IDA code heads**, all mis-decoded data, with 0 of the bytes proven. Examples: `0x0376C6 sub.w #1,e2` and `0x03776C mov.b r6l,@0x3E:8`. The per-range breakdown is in `proposed-typing.tsv`. Retyping these as the `u8` arrays above changes no proven byte.

### 3. The non-curve pieces

| Piece | Bytes | Decision |
| --- | --- | --- |
| `0x005796`–`0x0057A6` (17) | `00 05 a0 81 87 e3 e8 a0 83 85 e3 e8 a0 87 81 e3 e8` | **C-unread.** `{u16 len = 5; 3 rows of 5}` with stride 5. Columns 0, 3 and 4 are constant (`a0`, `e3 e8`). This is the `{u16 len; rows}` shape that `sub_C66C` reads elsewhere. Bounded by `0x005794 54 70` (rts) and code `0x0057A8 6a 10 89 be`. No abs16 or abs32 reference. |
| `0x0057A7` (1) | `00` | Inferred: a pad before code. |
| `0x058FFE`–`0x058FFF` (2) | `1f 01` | **C-unread.** Header of record [0] in a stride-32 array. Record [0] is `1f 01 00… 20`, record [1] at `0x05901E` is `1f 02 … 21`, and record [2] at `0x05903E` is `18 00 … 18`. Records [1] and [2] are loaded (`0x058F86 7a 04 00 05 90 1e`, `0x058F94 7a 04 00 05 90 3e`); record [0] is not. It starts after `0x058FFC 54 70`. |
| `0x05B370`–`0x05B37B` (12) | `00 ×7 01 ×4 02` | **C-unread.** First half of a `u8[24]` map, `00 ×7 01 ×4 02 ×5 03 ×5 00 02 00`, that runs parallel to the 24-slot table `0x05B310`. The map's extent is exact: `0x05B310 + 96 = 0x05B370`, and `+24` reaches slot 0's target `0x05B388` (`00 05 b3 88`, code `6a 0b b0 bf`). No reference to `0x05B370`–`0x05B387`. FINAL6 types it as code (`nop`). |
| `0x04C3C7` (1) | `01` | **C-unread.** Head of the FF-terminated lists `01 02 03 04 ff \| 05 06 07 08 09 ff` (`0x04C3C7`–`0x04C3D1`), which end at code `0x04C3D2 6a 0b a5 1f`. Nothing references `0x04C3C0`–`0x04C3D1` (whole image). |
| `0x04BA2E`–`0x04BA31` (4) | `07 08 ff 00` | **Inferred.** It is **Confirmed not a jump-table slot.** The index of `0x04B8FE 78 b0 6b 26 00 04 b9 ea` is `r3l` from `sub_4C7E4`, masked by `0x04B8F6 7a 63 00 00 00 ff`. `sub_4C7E4` sets `r3l` only to constants 0–0x10:<br>• `0x04C7EA fb 00`, `0x04C7F4 f3 0a fb 01`, `0x04C7FC f3 03 fb 02`, `0x04C808 fb 07`<br>• `0x04C84E fb 10 40 02 0c 3b` (the `0c 3b` copies `r3h` = 0x0A or 3)<br>• `0x04C874 fb 04`, `0x04C8E0 0c eb` with `r6l` ∈ {5,6,8,9,0xB–0xF} (e.g. `0x04C8D2 fe 0f`)<br>The 17 slots are 0–16, so slot 17 is never read. The shape `07 08 ff` + `00` resembles the lists at `0x04C3C7`. |
| `0x062598` (2) | `77 20` | Inferred. Part of `00 05 77 13 00 12 77 20`: two `{u16, u16}` records, which is too few to fix a stride. No reader. |
| `0x067FAF`, `0x06C56F` (1 each) | `00` | Inferred pads. Odd-length objects elsewhere in the image are not padded, for example the `0x069A7F` stale copy, so padding cannot be assumed. |
| `0x06C596`–`0x06C597` (2) | `04 00` | Inferred. Terminator and pad of version record `0x06C570`. The record has no reader; its siblings `0x06C538` and `0x06C598` do. |

### 4. Correction found on the way: APRS device row 16 is never selected (Confirmed)

`sub_4C284` copies a row of the 9-B device-name table `{u16 9}` at `0x04C32C`. The rows start at `0x04C32E`, and row *k* is at `0x04C32E + 9k`. The row index is `r3l − 1`:
- `0x04C29A ab 00 46 08` rejects `r3l = 0`.
- `0x04C2A6 1a 0b` decrements `r3l`.
- `0x04C2C0 6d 54 f3 00 52 43 0a b5` multiplies the index by 9 and adds it to the base.

`r3l` comes from the same `sub_4C7E4`, so its maximum is 0x10 and the row index runs 0–15. Row 15 is `0x04C3B5 54 48 2d 44 37 34 20 ff ff` ("TH-D74"). Row 16, `0x04C3BE 2d 2d 2d 2d 2d 2d 2d ff 00` ("-------"), is **never read**.

Doc 118 classed `0x04C3C6` as C-extent, as the pad of row 16. It should instead be an unread constant (row 16 of a clean stride-9 table). This does not change the named mask, because the byte is already named.

## USB relevance

- **Q1 (USB).** None of the 425 B is a USB descriptor, endpoint table or USB-register value. The nearest live code, `sub_35248` and `0x035344`–`0x03559C`, picks TX/RX curve bytes by band and MHz. It never touches `0xFFEE00`–`0xFFEE53`.
- **Q2 (SDR).** No sample path. These are calibration-style lookup curves.
- **Q3 (DSP).** Nothing new.

The answers in docs 95, 96 and 97 stand.

## Open

1. **Typing pass on a FINAL7 seed.** Retype `0x03605A`–`0x0377C1` (2,860 code heads), `0x05B370`–`0x05B387` and `0x06C570`–`0x06C597` as data, following `proposed-typing.tsv`. Then require proven-mask neutrality, as `m6_apply.py` did.
2. **Decide the tier name.** "Confirmed unread constants" (C-unread) is new. The orchestrator should decide whether it counts toward the named mask. If it does, the delta is +410 (`proposed-named.tsv`). If it does not, the delta is 0.
3. **Doc 118's other C-extent rows.** Some may be unread too, now that the `sub_4C7E4` bound is known. Re-check them the way §4 did. Candidates: the `0x04B9EA` slots for values `sub_4C7E4` never returns, and APRS row 16.
4. **The `FT2D JPN` record at `0x06C570` and the unread curve geometries** together suggest shared source with another model. A side-by-side with an FT2D image, if the owner has one, would name the tables.

## Files

| File | Content |
| --- | --- |
| `ida\out\unread-tables\pieces.tsv` | 39 rows tiling the 425 B: tier, typing, element and stride, reader scope, byte-checked citations |
| `ida\out\unread-tables\proposed-named.tsv` | 30 disjoint ranges, sum 410 B (named delta); proven delta 0 |
| `ida\out\unread-tables\proposed-typing.tsv` | Retype proposal with FINAL6 code-head counts per range |
| `ida\out\unread-tables\verify.txt` | Hashes, 72 citations (0 failures), 16 structure checks (0 failures), tiling, totals |
| `ida\out\unread-tables\n3_pieces.py` | Decisions and citations; this is the byte-check script |
| `ida\out\unread-tables\n3_lib.py`, `n3_scan.py`, `n3_scan16.py`, `n3_ops.py`, `n3_small.py`, `n3_stride.py`, `n3_typing.py` | Loader, scans, census and typing counts |
| `ida\out\unread-tables\work\` | `n3_heads.tsv` and `n3_xrefs.tsv` (IDA dump of `N3_TABLES`), plus `scan_*.txt` |
| `ida\jobs\n3_dump.py` | The read-only IDA job |
