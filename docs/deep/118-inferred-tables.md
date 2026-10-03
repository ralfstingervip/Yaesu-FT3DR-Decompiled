# 118 — L5's Inferred table, record and label tier, plus the 43 B fragment (Lane M6)

> Lane M6, model `claude-opus-5-5`. This is owner-side, read-only static analysis of `decrypted\FT3D_MAIN_ver102_EXP.bin`
> (H8SX, big-endian, base 0, so file offset = address).
>
> - **Database.** One private database, `ida\db\jobs\M6_TABLES\M6_TABLES.i64`, made with `--copy-from ida\db\jobs\L1_MAIN_FINAL5\L1_MAIN_FINAL5.i64`. No other database was opened and `run_ida.py` was not run.
> - **Nothing written.** Nothing was connected to or written to a radio. `Firmware\` and `decrypted\*.bin` are unchanged: sha256 `8e3ecd05409b2c31…` / `b93570b3c2f69ccb…`, checked at the start and the end. Published masks and seeds were not edited.
> - **Outputs.** Tables are in `ida\out\inferred-tables\`. Jobs are `ida\jobs\m6_dump.py` and `ida\jobs\m6_apply.py`.
> - **Status.** Everything below is a proposal.

## Verdict

L5's Inferred typing tier has 97 pieces. Excluding dead code, they total **1,054 B**. With the 43 B fragment `0x069A7F` added, the total examined here is **1,097 B**. Every byte is now decided, and every cited instruction or data byte was checked against the image by a script (`m6_pieces.py`, 0 failures).

Typing results:

- **672 B are now Confirmed.**
  - **310 B (C-read).** A proven reader's bounded index is shown to reach the bytes.
  - **265 B (C-extent).** A proven reader with a known stride covers the table. The table's extent is fixed by the next proven base, by code, or by the index geometry. Which index values actually occur at run time is not shown for every slot. Two slots are shown to be skipped by their index logic: `0x000E20` and `0x016902`.
  - **54 B are proven code.**
  - **43 B are an identified stale copy.**
- **425 B stay Inferred.** No reader exists: there is no code operand, BE32 cell or abs24 call into them anywhere in the image. 382 B of this are the byte-curve region `0x03624B`–`0x0377C1`.

**Record-field target `0x01687E`.** `sub_15260` calls record field `+4·AD68` through `jsr @er6` at `0x015292`. Field `+8` (`0x01687E`) is called when `AD68 = 2` and `AD9D = 0`. The 54 B are therefore proven code. The same rule also reaches fields `+0` (`0x01A17C`) and `+C` (`0x0168BC`) of that record.

**The 43 B fragment `0x069A7F`.** It is a stale copy of `sub_69964`, the callback that `0x069914` registers at `FFB288`. Its first 37 B are byte-identical to proven `0x069964`–`0x069988`. After that it carries a different 6-byte tail.

Proposed ledger:

| | Before | After | Change |
| --- | ---: | ---: | --- |
| Named | 501,656 | **502,285** | +629 (C-read + C-extent + proven code) |
| Proven | 364,786 | **364,934** | +148 (core) |

A further 43 B (stale copy) and a 242 B / +6 named companion set are listed separately for the orchestrator to decide.

## Method

1. **Dump.** `m6_dump.py`, read-only on the L1 copy, wrote `work\m6_heads.tsv`. That file lists all 130 k heads with operand type, value and address. It also wrote xrefs around every piece. In the H8SX module, `@(d:32,ERn)` table bases are in `op.addr` (type 4) and `mov.l #imm` values are in `op.value` (type 5).
2. **Reference scan.** `m6_scan.py` covered every code-head operand within 0x400 B below each piece and every BE32 cell in the image. `m6_show.py refs` was used per table. Raw 16- and 32-bit operand values were searched where a table had no hit.
3. **Hand decode.** Each table's reader was decoded by hand: base, scaling, the source of the index register and its bound (`cmp`/`bcc`, a wrap record, store census via `m6_writers.py`), and the eepmov or `sub_3F36E` count. The helpers decoded on the way are listed below.

   | Helper | Behaviour |
   | --- | --- |
   | `sub_3F36E` | eepmov, `r4l` bytes |
   | `sub_3F5B2` / `sub_3F59C` | `{u16 stride, u16 count, records {u32 lo, u32 hi, …, u16 @+8}}` range search |
   | `sub_3F62E` | `{u8 min, u8 max, ptr}` wrap-increment |
   | `sub_C66C` | `{u16 len; rows}` copy of row `r3l` |
   | `sub_1A9C8` | cell `A9F0·4` of a cell table |

4. **Descent.** `m6_descent.py` reuses the setup of `l-wave-recon\recon_descent.py` (K1 folded descent, fnindex seeds cleared, the 6 L-wave edges). It writes only into this folder. It was run three ways: base, base + record `0x01686E` fields (core), and core + the other `sub_15260` records the descent misses (companion). The deltas are measured against `final6_proven_mask.bin`.
5. **Tables.** `m6_pieces.py` holds one decision per piece with citations. It byte-checks each citation, and for `P` citations it also checks that every instruction byte is proven in final6. It asserts that the decisions tile the 97 pieces plus the fragment exactly, then emits the tables.
6. **Database proof.** `m6_apply.py` ran on a fresh L1 copy.
   - **Rows.** 66 rows applied and 0 skipped. `0x01687E` and `0x018FAA` both `create_insn` cleanly to their ends.
   - **Proven code.** Final6-proven bytes that are code: 364,786 before and 364,786 after. No proven byte was lost.
   - **Image.** The database bytes equal the image.
   - **Neighbours.** 18 named neighbour bytes changed outside the rows. They are tails of IDA mis-decoded 2-byte "code" items inside the same tables, for example `0x040034` and `0x04E8CE`, and they went from code to unknown.
   - **Layout hash after:** `e682c3878903f688`.

**Not done.**
- The run-time reachability of each individual index value in C-extent tables was not proven. Examples: market value 6, DTMF code 15, and key `A9F0` = 10/12.
- The 382 B curve region was searched only for direct operands and pointer cells. Code that builds those addresses arithmetically from an unrelated base would not have been seen.

## Findings

### 1. `sub_15260` calls field +8, so `0x01687E` is proven code (Confirmed)

`sub_15260` (proven):

```text
015260  01 00 6d f5            push.l er5 ; ... pop.l er5
01526A  7a 02 00 00 00 00      mov.l  #0,er2
015270  6a 0a ad 68            mov.b  @AD68,r2l
015274  46 06                  bne    +6            ; AD68==0 -> jsr sub_14E04
01527C  6a 0c ad 9d 47 06      mov.b @AD9D,r4l ; beq 0x015288
015282  01 00 69 56            mov.l @er5,er6        ; AD9D!=0 -> field +0
015288  10 72 0a a5            shll.l #2,er2 ; add.l er2,er5
01528C  01 00 69 56 47 08      mov.l @er5,er6 ; beq (NULL -> return)
015292  5d 60                  jsr   @er6
```

- **The call site.** `0x016864` is `7a 05 00 01 68 6e 5a 01 52 60`. It is proven and is reached as key-table entry `0x012FDC`.
- **The record.** It passes `0x01686E` = `00 01 a1 7c | 00 00 00 00 | 00 01 68 7e | 00 01 68 bc`.
- **Which field runs:**

  | Condition | Field | Target |
  | --- | --- | --- |
  | `AD68 = 1` | +4 | NULL, skipped |
  | `AD68 = 2` | +8 | `0x01687E` |
  | `AD68 = 3` | +C | `0x0168BC` |
  | `AD9D ≠ 0` | +0 | `0x01A17C` |

- **Both conditions occur in proven code.** `AD68 = 2` is stored by proven code (`0x015350 fc 02 6a 8c ad 68`, and nine other `fc 02` stores). `AD9D = 0` is stored at `0x015924 fc 00 6a 8c ad 9d`.
- **The rule is already part of the descent.** The descent accepts this rule for 10 other `sub_15260` records, for example `0x015FC8`, `0x016678` and `0x0177B8` in `main-full\jumptables.tsv`, and `0x0174DA` (H3 Tier B). Record `0x01686E` was missed only because slot 1 is NULL.

**Core delta (proven, `proposed-proven.tsv`): +148 B.**

| Range | Bytes | Note |
| --- | ---: | --- |
| `0x01687E`–`0x0168B3` | 54 | newly named too: 20 insns, `6a 0a ad 9c 7a 62 …`, ending `40 44` bra `0x0168F8` |
| `0x0168BC`–`0x0168F1` | 54 | already named |
| `0x01A17C`–`0x01A1A3` | 40 | already named |

**Companion (same rule, other records the descent misses): +242 B proven, +6 B named.**

| Record (jmp site) | Fields reached |
| --- | --- |
| `0x016AAE` (`0x016AAA`) | `0x016ABE`, `0x016AD6`, `0x016AEE` |
| `0x01792E` (`0x01792A`) | 8 fields: `0x01A0D4`, then `0x01794E` … `0x017982` |
| `0x017AA6` (`0x017AA2`) | `0x017AB6`, `0x017AC6`, `0x017ACE` |
| `0x018622` (`0x01861E`) | `0x018632`, `0x01863A`, `0x018646` |
| `0x05E806` (`0x05E802`) | `0x05E812`, `0x05E826` |

The new proven runs are `0x016ABE`(56), `0x01794E`(60), `0x017AB6`(38), `0x018632`(34), `0x018FAA`(6), `0x01A0D4`(8) and `0x05E812`(40). `0x018FAA` is entered by `jsr @0x18faa` six times inside the `0x01794E` run. Its bytes are `6a 18 8a ac 61 c0`, a `bnot` sibling of `0x018FA2`.

### 2. `0x069A7F`–`0x069AA9`: a stale copy of `sub_69964` (Confirmed by identity)

```text
proven 069964: 6a 0c b3 f5 1c 9c 46 04 6a 89 b3 f4 79 04 00 10 52 41 7a 11 00 ff 45 76 0f 95 7a 15 00 00 00 05 68 5c ac ff 47 | 02 40 06 7a 05 00 06 9a 4d ...
stale  069A7F: 6a 0c b3 f5 1c 9c 46 04 6a 89 b3 f4 79 04 00 10 52 41 7a 11 00 ff 45 76 0f 95 7a 15 00 00 00 05 68 5c ac ff 47 | 0e 79 04 00 01 6b 84 b0 50 fb 0a 5e 05 e4 68 54 70
```

**The shared head.** The first 37 bytes are identical. They decode as:

```text
mov.b @B3F5,r4l ; cmp.b r1l,r4l ; bne ; mov.b r1l,@B3F4
er1 = r1*0x10 + 0xFF4576
r4l = @(er1+5)
cmp.b #0xFF ; beq
```

`sub_69964` is the callback registered by `0x069914 7a 06 00 06 99 64` / `01 00 6b 86 b2 88`.

**The two tails.**
- In the live routine, `47 02` branches to an eepmov of the 10-byte default `0x069A4D` into `FFB05A`.
- The stale copy's `47 0e` branches to `rts` at `0x069AB3`. Its fall-through is `mov.w #1,r4 ; mov.w r4,@B050 ; mov.b #0x0A,r3l ; jsr sub_5E468 ; rts`. These end at `0x069AB4` and continue into the named bytes `0x069AAA`–`0x069AB4`.

**Why it sits at an odd address.** It starts exactly where the label buffer ends. Label record `0x069A48` is `00 35`, and `0x0699A6`–`0x0699B4` copies 0x35 bytes from `0x069A4A`, so the copy ends at `0x069A7E`. The fragment therefore sits on an odd address, so the CPU cannot run it. Nothing references it (L5's scan; this lane found no aligned reference either). It is an older or alternate build of the `sub_69964` callback, left in the image after the label buffer. **Proposed:** name the 43 B as "byte array, stale copy of `sub_69964`". That would leave MAIN with 0 un-nameable bytes. The orchestrator should decide whether identity naming counts toward the named mask.

### 3. Tables upgraded to Confirmed (`pieces.tsv`, one row per piece with reader, bound and bytes)

**C-read: the bounded index is shown to cover the piece (310 B).**

| Piece(s) | Table / element | Reader and bound |
| --- | --- | --- |
| `0x00918A` (20) | jmp table `0x00917E[8]`, slots 3–7 → proven `0xDB58 0xDB5E 0xDB88 0xD910 0xD9C8` | `0x009174 78 b0 6b 26 00 00 91 7e 59 60`; index `B9E4`, stores of 3–7 at `0x029580/58/0x0295FE/0x0294EE/0x029594` (`fc 0N 6a 8c b9 e4`) |
| `0x009B34` (6) | u8 ramp `0x009B15[0x25]` | `0x009B80 ac 25 44 0e` then `78 40 6a 2a 00 00 9b 15` |
| `0x00B82C` (4) | 76-B template `0x00B7EE` | `0x007E96 79 04 00 4c`, `7a 05 00 00 b7 ee`, eepmov |
| `0x00F01E` (2) | 16-B block `0x00F012` | `0x00DE48 fc 10`, `7a 05 00 00 f0 12`, `jsr sub_3F36E` |
| `0x00FC10` (12) | jmp table `0x00FC0C[4]` slots 1–3 | `0x00FC02 78 b0 6b 26 00 00 fc 0c`; `A9F4` = 1 (`0x00FC26`), inc while < 3 (`0x00FC44 ac 03 44 06`) |
| `0x015192` (1) | u8 map `0x01518C[14]` | `0x014F8E 78 30 6a 2b 00 01 51 8c`; index from record `0x015120 00 0d 00 ff ad 9b` via `sub_3F62E` (0..13) |
| `0x01E226` (6) | BCD u16 `0x01E220[6]` | `0x01E17A … 10 33 0a b5 69 54`; index = word +8 of range table `0x020C6A` (values 0–5) |
| `0x025C2A/5C/66` (8) | BCD u16 `0x025BE2[100]` | index = 10·d1 + d2 (`ee 0f fd 0a 50 d6 … ed 0f 08 de`), `0x025AEA`/`0x025F0A` |
| `0x02C7A2` (5) | label block `0x02C790 {00 54; 84 B}` | `0x00B0B2 7a 05 00 02 c7 90 6d 54` + eepmov |
| `0x02C8F3` (3) | rows `0x02C8F2 {00 12; 18-B rows}` | `0x00CBCE` + `sub_C66C` (`6d 54 52 43 0a b5`) |
| `0x02FA54`, `0x02FA7A`, `0x0314FC`, `0x031522` (12) | 12 × `{u16 mul; u32 off}` at `0x02FA34` / `0x0314DC` | `add.l #base,er3`, `6d 36`, `01 00 69 34`; r3 = word +8 of range tables `0x030B00/0x030BA4/0x032442/0x0324E6`, which hold 0x1E and 0x42 |
| `0x040246`, `0x040266` (22) | BCD u32 `0x04020E` (466.35–466.55 MHz cells) | `0x03D1CA 0f b5 10 75 78 d0 6b 25 00 04 02 0e`; `0x03D1E2 ab 0b 45 08 ab 1c 44 04` |
| `0x04E88A`…`0x04EAB6` (206 in 11 pieces) | `u16 0x04E822[91]`, `u16 0x04E8D8[91]`, `u32 0x04E98E[91]` (abutting; next base `0x04EAFA`) | index = char − 0x21 with `ab 5b 45 04` (`0x04CD36`, `0x04CDE6`, …). Purpose Inferred: APRS base-91 decode |
| `0x06C56E` (1) | terminator `04` of 55-B version record `0x06C538` | `0x06BD3E 79 04 00 37 7a 05 00 06 c5 38` + eepmov |
| `0x06F4B8` (2) | 16-B block `0x06F4B6` | `0x06F472 fc 10 f4 00 7a 05 00 06 f4 b6` + eepmov |

**C-extent: the reader and stride are proven and the extent is fixed (265 B).**

| Piece(s) | Table / element | Why the extent is fixed |
| --- | --- | --- |
| `0x000E20` (2) | slot 13 of u32 `0x000DEA[14]` | Twin `0x000DB2[14]` ends at `0x000DEA`, and code starts at `0x000E22`. **The traced index range is 1–12**, so slot 13 `00 7f 31 9c` is never read. |
| `0x00F188` (24) | per-market band blocks `0x00F0A2 + 0x24·FF800F` (8 blocks); block 6 ranges + block 7 header | `0x03F55C 79 06 00 24 52 46`, `0x03F562 7a 16 00 00 f0 a2`, `sub_3F59C`; next table `0x00F1C2 00 08 00 04` |
| `0x00F6A3` (21) | u32 per market `0x00F6A2[8]` | `sub_EAD2` (`6a 0c 80 0f … 10 74 0a c5 01 00 69 54`); next base `0x00F6C2` (`0x00E7F8`) |
| `0x016902` (2) | slot [2] of u16 `0x0168FE` | Reader `0x016890` is proven once the core seeds are in. Index 2 is diverted by `0x016888 aa 02 47 28`, so the slot is never read. |
| `0x01B629`, `0x01B98D` (10) | JIS key-cycle records `{u16 n; n·{from,to}}` = `{1; 2121→2121}` | Cell [12] of 13-cell tables `0x01B4DA`/`0x01B62E`/… and cells [10–11] of `0x01B88C`; consumer `0x01A9D6 6a 0a a9 f0 10 4a`, `0x01A726 6d 5c 01 00 6d 53` |
| `0x025335`, `0x025341` (3) | u8 `0x025334[14]` | `0x0252FE 78 10 6a 2c 00 02 53 34`; code at `0x025342` |
| `0x02554B`, `0x02555F` (24) | 10 × 4-B step sequence `0x025546` = cell [8] of `0x025496` | `0x025464`; ends at code `0x02556E` |
| `0x025742` (34) | 5 × 10 × 4 B `0x02569C`, block 4 | `0x0255A2 79 04 00 28 52 45 0a e5`; 0x2569C + 5·0x28 = code `0x025764` |
| `0x03619E` (60) | u8 `0x036116[4][0x33]` | `0x03535E 79 04 00 33 0f a6 52 46 0a 96`; er1 ≤ 0x32; next base `0x0361E2` |
| `0x039067` (25) | u32 tone-pair `0x039040[16]` | `0x038D38 … 10 73 78 b0 6b 24 00 03 90 40`; 0x10 is handled separately (`ab 10 47 72`); code at `0x039080` |
| `0x040035`…`0x0401AB` (59 in 18 pieces) | 19 × 22-B channel records `0x04001C` (u32 BCD freq + 18 B incl. JIS label) | `0x03D0AA 79 04 00 16 52 43 0a b2 01 00 69 25`, eepmov `0x12` from +4; next base `0x0401BE` |
| `0x04C3C6` (1) | pad byte of row 16 (`-------` `ff 00`) of 9-B APRS device rows `0x04C32C` | The copy stops at FF (`0x04C2CA a4 ff 47 08`) |

### 4. Still Inferred: no reader (425 B)

| Piece(s) | Bytes | Why it stays Inferred |
| --- | ---: | --- |
| `0x03628D`…`0x036B4F` (22 pieces) and `0x0376C8`, `0x03776A` | 382 | The byte-curve region `0x03624B`–`0x0377C1`. The only readers near it are bases `0x03605A/6E/7E`, `0x036116`, `0x0361E2/EE/F2` and `0x036218`. Their indices end at `0x036249` (er1 ≤ 0x32, clamp `0x03527C 7a 01 00 00 00 32`). **Not found** (scope: every IDA code-head operand value, every BE32 cell, abs24 calls): no operand or cell lands in `0x036219`–`0x0377C1`. Most of the region is already named. It probably holds tables for a band plan this build does not use (Inferred). |
| `0x005796` | 18 | `00 05 a0 81 87 e3 e8 …`. No operand, cell or 16-bit occurrence. |
| `0x04BA2E` | 4 | `07 08 ff 00`. Lies after the 17-slot jump table `0x04B9EA`. |
| `0x04C3C7` | 1 | Head of the list `01 02 03 04 ff 05 … 09 ff`. |
| `0x058FFE` | 2 | `1f 01`. Siblings `0x05901E`/`0x05903E` are loaded; this one is not. |
| `0x05B370` | 12 | First half of a 24-B class map parallel to handler table `0x05B310`. |
| `0x062598` | 2 | No reader. |
| `0x067FAF` | 1 | Sits between the exact-length eepmov `0x00DF62` (5 B from `0x067FAA`) and the `DNEWS` compare (5 B). Both readers stop short of it. |
| `0x06C56F` | 1 | Pad after record `0x06C538`. |
| `0x06C596` | 2 | `04 00`, the end of record `0x06C570`, which has no reader. |

### 5. Corrections to earlier docs (all byte-checked)

- **Doc 102 / L5, `0x000E20`.** The table is not "4-B pair table `0x000E00`". The bases are `0x000D32`/`0x000D72`/`0x000DB2`/`0x000DEA`, read as `78 e0 6b 26 00 00 0d xx` with entries `{u8 flag, u8 level, u16 mag}`. `0x000E00` is mid-entry, and the piece is slot 13 of `0x000DEA` (`0x000E1E 00 7f 31 9c`), which is never read.
- **Doc 102, `0x015192`.** It is not in list `0x015164`. It is index 6 of u8 map `0x01518C[14]` (`0x014F8E 78 30 6a 2b 00 01 51 8c`).
- **Doc 102, `0x016902`.** It is not the "last u16 of record `0x0168FA`". It is slot [2] of u16 table `0x0168FE`, and that index is diverted.
- **Doc 102, `0x04C3C6`.** It is not the "head of byte table `0x04C3C6`". It is the pad byte of APRS device row 16 at `0x04C3BE` (`2d×7 ff 00`). The byte list starts at `0x04C3C7`.
- **Doc 102 §2.** The `0x015260` call-through is Confirmed, not Inferred. The descent misses 6 `sub_15260` records, so neither the H3 scan (`ptr-arrays\arrays.tsv`) nor `main-full\jumptables.tsv` covers them.
- **Doc 102 §6.** "Un-nameable" becomes "stale copy of `sub_69964`" (37 B identity).
- **Doc 102 §5.** `0x018FAA` is not "unreachable after `bra`". It is a real entry, called by `5e 01 8f aa` six times at `0x017950`–`0x017984`.

## USB relevance

- **Q1 (USB).** None of the 1,097 B is a USB descriptor, endpoint table or USB-register access. The proven and companion code (`0x01687E`, `0x0168BC`, `0x01A17C`, the `0x016AAE`… record fields) is key and menu handler code around `AD68`/`AD9C`/`AA30`. It does not touch `0xFFEE00`–`0xFFEE53`. The USB answer of docs 64, 73–75 and 95 stands.
- **Q2 (SDR).** There is no sample path in these bytes. The tables are band edges, steps, tone pairs, char-decode weights and labels.
- **Q3 (DSP).** Nothing new. The stale `sub_69964` tail calls `sub_5E468` with `r3l = 0x0A`. `sub_5E468` was not examined here, and the stale copy cannot execute anyway.

## Open (most valuable first)

1. **MAIN_FINAL6 seed.**
   - Add the three record-`0x01686E` field entries and re-derive. Expect +148 proven and +54 named.
   - Decide on the 242 B companion (five records, same rule).
   - Consider making the descent treat every `mov.l #rec,er5 ; jmp sub_15260` site as a record, with fields read up to the lowest target or a non-pointer cell. That is what `m6_descent.py recfields()` does.
2. **Apply the Confirmed typing.** Use `m6_apply.py` (proven-neutral on L1 copy). The 18 named neighbour bytes it turns from code to unknown are IDA mis-decodes inside the same tables, and should be retyped with them.
3. **The 382 B curve region `0x03624B`–`0x0377C1`.** Look for an arithmetic base, for example `add.l` of a band offset to `0x036218`, in code that is not yet disassembled. Otherwise accept it as an unused band-plan table.
4. **Tighten C-extent to C-read** by proving the index values: market 6/7 for `0x00F188`/`0x00F6A3`, key `A9F0` for the JIS records, `AE84`/`AE88` for `0x025742`, and the channel index for `0x04001C`.

## Files

| File | Content |
| --- | --- |
| `ida\out\inferred-tables\pieces.tsv` | 100 rows tiling the 97 L5 pieces + `0x069A7F`: tier, typing, element, reader and bound, byte-checked citations |
| `ida\out\inferred-tables\proposed-typing.tsv` | 66 rows with named delta: C-read 310, C-extent 265, proven code 54, stale copy 43, companion 6 |
| `ida\out\inferred-tables\proposed-proven.tsv` | Core 148 B (3 runs) and companion 242 B (7 runs), with seeds |
| `ida\out\inferred-tables\verify.txt` | Citation check (0 failures), tier totals, deltas |
| `ida\out\inferred-tables\apply-typing.tsv`, `apply-typing-summary.txt` | Database neutrality on `M6_TABLES` |
| `ida\out\inferred-tables\m6_pieces.py` | Decisions and citations; the byte-check script |
| `ida\out\inferred-tables\m6_descent.py` | Descent with record seeds (writes only here) |
| `ida\out\inferred-tables\m6_lib.py`, `m6_scan.py`, `m6_show.py`, `m6_writers.py` | Loaders and reference tools |
| `ida\out\inferred-tables\work\` | `m6_heads.tsv` (IDA dump), `scan.txt`, `descent_delta.tsv`, `m6_core_mask.bin` |
| `ida\jobs\m6_dump.py`, `ida\jobs\m6_apply.py` | IDA jobs (private database only) |
