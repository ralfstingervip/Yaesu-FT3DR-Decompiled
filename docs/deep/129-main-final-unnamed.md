# 129 — The 519 MAIN bytes unset in `final7_named_mask.bin` (Lane N2)

> Lane N2, model `claude-opus-5-5`. Owner-side, read-only static analysis of
> `decrypted\FT3D_MAIN_ver102_EXP.bin` (H8SX, big-endian, base 0, so file offset = address).
>
> - **Database.** One private database, `ida\db\jobs\N2_UNNAMED\N2_UNNAMED.i64`, made with
>   `--copy-from ida\db\jobs\M1_MAIN_FINAL6\M1_MAIN_FINAL6.i64`. The job (`ida\jobs\n2_dump.py`) only reads.
>   No other database was opened, and `run_ida.py` was not run.
> - **Nothing written.** Nothing was connected to or written to a radio. `Firmware\` and `decrypted\*.bin` are
>   unchanged: sha256 `8e3ecd05409b2c31…` / `b93570b3c2f69ccb…`, checked at the start and again at the end by
>   `n2_verify.py`. No published mask or seed was edited.
> - **Outputs.** `ida\out\main-final-unnamed\` (tables, scripts, `verify.txt`).
> - **Status.** Every delta below is a proposal.

## Verdict

The `final7_named_mask.bin` diff against MAIN content `0x000000`–`0x07B753` gives **46 runs, 519 B**, as
expected. Every byte now has a decision, and 96 B of them are Confirmed.

| Class | Bytes | What it is |
| --- | ---: | --- |
| Typed data, C-read | 20 | A proven reader whose index is shown to reach the bytes. |
| Typed data, C-extent | 7 | Proven reader and stride; table extent fixed. |
| Fill | 26 | `00`/`FF` bytes that nothing reads and nothing enters. |
| Stale copy `0x069A7F` | 43 | M6's identification still holds: 37 B match `0x069964` byte for byte. |
| Typed data with no reader (Inferred) | 423 | 382 B of these are the byte-curve region `0x03624B`–`0x0377C1`. |

- **Named delta: +96 B.** 505,165 → **505,261 / 505,684 = 99.916 %**. That is 15 disjoint ranges.
  - If the owner keeps holding the stale copy out, the delta is +53 and the total 505,218 (99.908 %).
- **Proven delta: 0.** None of the 519 bytes is reached code. No relative branch, `jsr`/`jmp` abs24, vector or
  memory-indirect slot lands in any run (whole image).
- **Correction to L5/doc 102.** 27 of L5's 51 "padding/fill" bytes are not fill. They are slots of tables that
  proven code reads, with bounded indices that reach them.

The remaining 423 B cannot be named at the Confirmed level. No reader exists for them in this image under every
form searched.

## Method

1. **Seed dump.** I ran `ida\jobs\n2_dump.py` once on `N2_UNNAMED`.
   - It wrote `work\n2_heads.tsv`: 130,558 heads over `0`–`0x7B754`, each with operand type, value and address.
   - It also wrote `work\n2_xrefs.tsv` (every xref into each run ±0x80) and `work\n2_items.tsv`.
   - The database was not modified.
2. **Runs.** `n2_lib.runs()` recomputes the unset runs and asserts 46 runs / 519 B. The mask counts are asserted
   to be 505,165 named and 365,358 proven.
3. **Whole-image inbound scan.** This is `n2_verify.py` §4, per run, over the whole image `0`–`0x7B754`:
   - BE32 at **every** byte offset;
   - `5A`/`5E` abs24 `jmp`/`jsr` at every even offset;
   - rel8 `bcc`/`bra`/`bsr` (`4x dd`, `55 dd`) and rel16 (`58 x0 dddd`, `5C 00 dddd`) at every even offset;
   - the 256 vector slots, which also cover the `@@aa:8` memory-indirect table;
   - every IDA code-head operand value and address (types 2–6);
   - for the four runs below `0x8000`, abs16, `@(d:16,ERn)` and `mov.l #imm16` forms (`6A`/`6B`/`6E`/`6F`/`7A 08–0F`
     at even offsets). On this part, abs16 sign-extends, so ROM `0`–`0x7FFF` is reachable that way.

   Each hit is then classed:
   - `code-operand`: an IDA operand equal to the value;
   - `straddle`: inside a code head but not one of its operands;
   - `data-cell` / `unk-bytes`.

   All non-straddle hits are in `refs.tsv`.
4. **Readers below the run.** A table read as `@(base,ERn)` has its base below the run. For each run I listed
   every operand within 0x400 B below it (`work\scan.txt`, `n2_scan.py`). I then decoded each reader by hand,
   covering the base, scaling, index source, bound and copy length. The tool is `n2_dis.py`, which prints the
   dumped heads with P/N flags.
5. **Tiers.** I used M6's tiers (doc 118), with two additions:

   | Tier | Meaning |
   | --- | --- |
   | C-read | Proven reader; the index is shown to reach the bytes. |
   | C-extent | Proven reader and stride; extent fixed by code or an abutting table. |
   | F (fill) | Content is `00`/`FF`, with no reader and no entry, whole image. |
   | S | Stale copy by byte identity. |
   | no-reader | Inferred; kept out of the named delta. |

6. **Byte check.** `n2_verify.py` byte-checks 95 citations against the image. For each citation flagged "proven"
   it also checks that every byte is set in `final7_proven_mask.bin`. Result: **95 / 0 failures**.
   It also asserts that the 48 decision rows tile the 519 B exactly, and it writes the tables.

**Not done.**
- I did not prove which run-time values reach each index in the C-extent rows.
- Code that builds an address arithmetically from an unrelated base would not show up in the scan. For the
  curve region I checked the obvious forms by hand (see §3).

## Findings

### 1. Typed data with a proven reader: 27 B, Confirmed

| Range | B | Tier | Table / element | Reader and bound |
| --- | ---: | --- | --- | --- |
| `0x004399` | 1 | C-read | slot `0x4D` of u8 table `0x00434C` | `0x05D406 6a 2c 00 fe f9 64 7a 64 00 00 00 ff 0c cb 6e 4c 43 4c` (and `0x05D8A0`, buffer `FF0C3A`). Index = received byte `and.l #0xFF`, taken after `']'` (`0x05D3FC ac 5d 47 06`). Slot `0x4D` (`'M'`) = `00`. |
| `0x006648`–`0x00664B` | 4 | C-read | BE32 slot 127 (`00 00 00 00`, NULL) of `0x00644C[128]` | `0x00A654 6a 0c 89 c6 ec 7f f4 00 10 54 7a 64 00 00 ff ff 78 c0 6b 25 00 00 64 4c`. The index is `FF89C6 & 0x7F`. Value `0x7F` is produced by `sub_3F62E`'s decrement wrap (`0x03F656 … 1c 4b 47 02 44 0a 0c cb`) with record `0x017734 00 7f 00 ff 89 c6` (`0x017714 6a 18 a9 ee 70 00`, `0x017722 7a 06 00 01 77 34 5e 03 f6 2e`). The caller `0x00643A` skips only `0x29`. |
| `0x023145`–`0x023148` | 4 | C-read | slots 1–4 of u8 `0x023144[0x12]` | `0x0230FC 6a 0c 97 f8 7a 64 00 00 00 ff 6a 10 8e a0 73 60 47 0e ac 10 47 0a 78 40 6a 2b 00 02 31 44`. `FF97F8` = 0 at `0x0102F8 fc 00 6a 8c 97 f8`, then wraps over `0..0x11` via record `0x0231EC 00 11 00 ff 97 f8` (`0x0231C2`). `sub_231C2` skips only 0 (conditional), `0x11`, 6 and 7 (`0x0231D4`). Bit `8EA0.6` is set by proven `0x0211C4 6a 18 8e a0 70 60`. |
| `0x034960`–`0x034964` | 5 | C-read | slots 2–6 of u8 `0x03495E[8]` | `0x034916 6a 0c aa d0 7a 64 00 00 00 ff …`, `0x034934 78 40 6a 2b 00 03 49 5e`. `AAD0` is the word +8 of the range-table row found by `sub_3F5B2` (`0x0347D4 5e 03 f5 b2 6a 8b aa d0`, `0x03F5E2 6f 63 00 08`). Rows give 0–4 (`0x03510A`) and 5–6 (`0x035140 … 00 05 … 00 06`). |
| `0x03CFE6`–`0x03CFE7` | 2 | C-read | low u16 of BCD u32 `0x03CFE4` = `00 46 00 00` | `0x03CFD0 7a 06 00 03 cf e4 5e 03 f9 4c`. `sub_3F94C` reads `@(2:16,er6)` and `@er6` (`0x03F94C fc 00 08 cc 6f 53 00 02 6f 64 00 02`). The call is taken when the channel entry's bit 0 is set (`0x03CFC0 73 0c 47 16`; entry 0 `0x040362 16 06 50 01`). This is the 4.6 MHz marine duplex offset (Inferred meaning). IDA's `nop` at `0x03CFE6` is a mis-decode. |
| `0x06F586`–`0x06F587` | 2 | C-read | bytes +0x52/+0x53 of the 128-B template `0x06F534` | `0x06F4C6 fc 80 f4 00 7a 05 00 06 f5 34 7a 06 00 ff 2e ca 7b d4 59 8f` copies 0x80 B, so it covers up to `0x06F5B3`; code starts at `0x06F5B4`. `sub_6F512` (`0x06F51A`) does the same. The caller `0x06541C 5e 06 f4 c6` is proven. |
| `0x073408`–`0x073409` | 2 | C-read | `u16 len` of record 4 of `{u16 len; u32 src; u32 dst}[5]` at `0x0733E0` | `0x073382 6a 0a ad 68 1a 0a f2 00 79 04 00 0a 52 42 78 20 6b 24 00 07 33 e0 47 18`: index = AD68 − 1, stride 10. AD68 = 5 is stored at proven `0x0184AC fc 05 6a 8c ad 68`. The record is `00 00 00 ff ab 5c 00 ff ab 5c`; len 0 means `beq`, no copy. |
| `0x0254CF`–`0x0254D0` | 2 | C-extent | bytes 1–2 of step record 0, sequence `0x0254CE` (10 × 4 B) | Reader `sub_25464`: `0x025464 78 90 6b 25 00 02 54 96 6a 0c ae 88 7a 64 00 00 00 ff 10 4c 0a c5 6c 5b 4b 04 0b 05`. Byte 1 is read only when byte 0 is negative; byte 2 at `0x02548C … 6c 5b 54 70`; byte 3 at `0x025428 68 5b`. `AE88` is one digit of the 8-digit buffer `FFAE80` packed by `sub_3FA8A` (`0x03FA8A 6d 56 10 46 10 46 14 e6`), so it is 0–9. Pointer cells 0/1/2/3/5/10 of `0x025496` select `0x0254CE`. |
| `0x0254E1`–`0x0254E4` | 4 | C-extent | byte 3 of record 4 and bytes 0–2 of record 5, same sequence | Same reader. The next sequence `0x0254F6` abuts, so there are 10 records. With r1 ∈ {0,3,5}, digit 5 is diverted at `0x025416 6a 0c ae 88 ac 05 47 1a` unless `sub_32798` returns Z, so record 5 stays C-extent. |
| `0x034965` | 1 | C-extent | slot 7 of `0x03495E[8]` | The twin `0x034956[8]` ends at `0x03495D` (`02 02 04 04 04 08 08 00`), and code starts at `0x034966`. |

Sum: C-read 20, C-extent 7.

### 2. Fill: 26 B, Confirmed

Each of these runs has zero non-straddle inbound hits in `refs.tsv`, and no reader base below it reaches it.

| Range | B | Bytes | Why |
| --- | ---: | --- | --- |
| `0x00244C`–`0x00245B` | 16 | `00`×8 `ff`×8 | Follows `rts` `0x00244A 54 70`. It is byte-identical to the block `0x00245C`, which is what is actually read: `0x002416` / `0x00242E 7a 05 00 00 24 5c` with an eepmov of `0x10`. |
| `0x00664C`–`0x006653` | 8 | `00`×8 | Beyond index bound `0x7F` of `0x00644C`; code `0x006654 55 10`. |
| `0x067FAF` | 1 | `00` | All five readers of `0x067FAA` copy exactly 5 B (`fc 05 f4 00 7a 05 00 06 7f aa` at `0x00DF62`, `0x00E4AA`, `0x06042E`, `0x06049C`, `0x063468`). `'DNEWS'` starts at `0x067FB0`. |
| `0x06C56F` | 1 | `00` | `0x06BD3E 79 04 00 37 7a 05 00 06 c5 38 …` copies 0x37 B, ending at `0x06C56E`. Structurally this is the record's last byte; the FT2D twin `0x06C570` also ends `04 00`. Nothing reads it. |

### 3. Stale copy `0x069A7F`–`0x069AA9`: 43 B, Confirmed by identity (M6's claim re-cited)

```text
proven 069964: 6a 0c b3 f5 1c 9c 46 04 6a 89 b3 f4 79 04 00 10 52 41 7a 11 00 ff 45 76 0f 95 7a 15 00 00 00 05 68 5c ac ff 47 | 02
stale  069A7F: 6a 0c b3 f5 1c 9c 46 04 6a 89 b3 f4 79 04 00 10 52 41 7a 11 00 ff 45 76 0f 95 7a 15 00 00 00 05 68 5c ac ff 47 | 0e 79 04 00 01 6b
```

- **Identity.** The first 37 bytes are identical, and byte 38 differs (*verified*).
- **Live routine.** `sub_69964` is registered by `0x069914 7a 06 00 06 99 64 01 00 6b 86 b2 88`.
- **Why the address is odd.** The copy starts at an odd address, right after the label buffer: `0x069A48` =
  `00 35`, and `0x0699A6 7a 05 00 06 9a 48` copies 0x35 B from `0x069A4A`, ending at `0x069A7E`.
- **No inbound edge.** The whole-image scan finds none.

**Classification:** stale copy, Confirmed.

### 4. No reader: 423 B, Inferred, kept out of the named delta

| Range | B | Content | Evidence |
| --- | ---: | --- | --- |
| 26 runs in `0x03628D`–`0x0377C1` | 382 | byte curves, rows of `0x33` | The only readers are the 51-entry tables at `0x0361E2`/`EE`/`F2`/`0x036218` and `0x036116[er2*0x33+er1]`. The bound er1 ≤ 0x32 comes from `0x03527C 7a 01 00 00 00 32`: each sub-band's MHz offset is computed as two BCD digits at `0x0352FC`–`0x035316`. er2 is an index into `0x03541E 03 02 01 00`, so ≤ 3. The highest byte reached is `0x03624A`. Nothing reads `0x03624B` (zeros up to `0x036272`) or the curves from `0x036273 23 23 22 23 …`. |
| `0x005796`–`0x0057A7` | 18 | `00 05 a0 81 87 e3 e8 a0 83 85 e3 e8 a0 87 81 e3 e8 00` | Sits between `rts` `0x005794` and proven `0x0057A8`, and is not a slot of callback table `0x0079BC`… Its 7 BE32 hits are `00 00 57 99` straddling BCD range rows, e.g. `0x030B70 00 30 55 00 00 00 57 99 95 00 00 48`. The pattern occurs nowhere else. |
| `0x04BA2E`–`0x04BA31` | 4 | `07 08 ff 00` | Follows the jump table `0x04B9EA` (dispatch `0x04B8FE 78 b0 6b 26 00 04 b9 ea 59 60`). The index from `sub_4C7E4` is at most `0x10` (`0x04C84E fb 10`), so slot 17 is never fetched. |
| `0x04C3C7` | 1 | `01` | Head of the list `01 02 03 04 ff 05 … 09 ff`. The device rows `0x04C32E` (stride 9) end with row 16 (`2d`×7 `ff 00`). |
| `0x058FFE`–`0x058FFF` | 2 | `1f 01` | Header of a 32-B frame whose checksum is `0x20` at `0x05901D`. The siblings `0x05901E`/`0x05903E` are loaded (`0x058F86 7a 04 00 05 90 1e`, `0x058F94 7a 04 00 05 90 3e`); this frame never is. |
| `0x05B370`–`0x05B37B` | 12 | `00`×7 `01`×4 `02` | First half of the 24-B class map that runs parallel to handler table `0x05B310[24]` (`0x0563DA 78 b0 6b 26 00 05 b3 10`). The map has no reader. |
| `0x062598`–`0x062599` | 2 | `77 20` | Tail of `00 05 77 13 00 12 77 20`; this pattern occurs once in the image. |
| `0x06C596`–`0x06C597` | 2 | `04 00` | Tail of the FT2D version record `0x06C570` (`01 'V0020FT2D' …`), which has no reader. |

### 5. Corrections to earlier docs (byte-checked)

- **Doc 102 / L5 (`main-unnamed\runs.tsv`, class "padding/fill", 10 rows, 51 B).**
  - **27 B are read data.** Ranges: `0x004399` (slot of `0x00434C`), `0x006648`–`0x00664B`, `0x023145`–`0x023148`,
    `0x0254CF`–`0x0254D0`, `0x0254E1`–`0x0254E4`, `0x034960`–`0x034965`, `0x03CFE6`–`0x03CFE7`,
    `0x06F586`–`0x06F587`, `0x073408`–`0x073409`. Readers and bytes are in §1.
  - **24 B are fill:** `0x00244C` (16) and `0x00664C` (8).
- **Doc 118 (M6), `0x067FAF` and `0x06C56F`.** M6 left them "Inferred, no reader". The bytes and readers it
  cites are correct. I class them as **fill, Confirmed**: each is a `00` byte that nothing reads or enters.
- **Doc 118, `0x04BA2E`.** It said "Lies after the 17-slot jump table". The stronger statement holds: the
  dispatcher's index tops out at `0x10` (`0x04C84E fb 10`), so the bytes are never fetched as a slot.
- **README of `m-wave-recon` and the RESUME ledger line "519 B unnamed, 43 of them the stale copy".** Of the 519 B,
  96 can be named (Confirmed). 423 B remain un-nameable at the Confirmed level. The "0 un-nameable bytes" in
  doc 118 counts only L5's T4 tier, not everything outside the named mask.

### 6. Consistency note (no proposal)

The FINAL7 named mask already counts **5,209 B** whose evidence is the same as the 423 B above: no reader and
no entry. The scope was Not found over the whole image, by BE32, abs24, rel and IDA operands; the only BE32
hits are straddles such as `0x02853C 00 03 6b 04 bb c2` and `0x04B49C … 00 03 6b 6d …`, or odd offsets.

| Range | Named B | Proven B | How it is named |
| --- | ---: | ---: | --- |
| `0x03624B`–`0x0377C1` (curve region) | 5,113 | 0 | IDA code items, which are mis-decodes such as `mov.b r3l,@0x3B:8` |
| `0x04C3C8`–`0x04C3D1` | 10 | 0 | |
| `0x059000`–`0x05901D` | 30 | 0 | |
| `0x05B37C`–`0x05B387` | 12 | 0 | |
| `0x062592`–`0x062597` | 6 | 0 | |
| `0x06C570`–`0x06C595` | 38 | 0 | |

Either those 5,209 B and the 423 B should share a tier, or the convention should say that IDA-typed bytes
count as named whatever the reader evidence. **This is the orchestrator's call.** No change is proposed here.

### 7. One unchecked index (fact only)

At `0x073382`, `AD68 − 1` indexes the 5-record table `0x0733E0` with no compare against 5. Proven code also
stores AD68 = 0, 6, 7, 8, 9, `0x74` and `0xFF`. Whether any of those values coincides with the `BB71 == 9` gate
at `0x073368` is **Unknown**. Not exercised.

### Proposed deltas

**Named (Confirmed, disjoint, 15 ranges):**

| Ranges | Bytes |
| --- | ---: |
| `0x00244C`–`0x00245B` | 16 |
| `0x004399` | 1 |
| `0x006648`–`0x006653` | 12 |
| `0x023145`–`0x023148` | 4 |
| `0x0254CF`–`0x0254D0` | 2 |
| `0x0254E1`–`0x0254E4` | 4 |
| `0x034960`–`0x034965` | 6 |
| `0x03CFE6`–`0x03CFE7` | 2 |
| `0x067FAF` | 1 |
| `0x069A7F`–`0x069AA9` | 43 |
| `0x06C56F` | 1 |
| `0x06F586`–`0x06F587` | 2 |
| `0x073408`–`0x073409` | 2 |
| **Total** | **96** |

Adjacent rows are merged here; `proposed-typing.tsv` keeps them split by tier. The tiers break down as C-read
20, C-extent 7, fill 26 and stale copy 43.

- **MAIN named:** 505,165 + 96 = **505,261 / 505,684 = 99.916 %**. Without the stale copy: 505,218 (99.908 %).
- **Headline**, under convention A with SUB window code 464,263: 969,524 / 1,029,972 = **94.131 %**.

**Proven:** +0, so it stays at 365,358.

## USB relevance

- **Q1 (USB).** None of the 519 B is a USB descriptor, an endpoint record, or an access to `0xFFEE00`–`0xFFEE53`.
  - The readers touched here are: APRS Mic-E type parsing (`0x00434C`, `0x04B9EA`, `0x04C32C`); the
    frequency-step digit tables (`0x0254CE`); sub-band tables (`0x03495E`, curves); the marine duplex offset
    (`0x03CFE4`); a 10-B memmove record table (`0x0733E0`); and a 128-B RAM template (`0x06F534`).
  - The USB answers of docs 64, 73–75, 95 and 119 stand.
- **Q2 (SDR).** There is no sample path in these bytes. The curve region is unread, per-MHz byte tables.
- **Q3 (DSP).** Nothing new. The stale copy cannot execute.

## Open (most valuable first)

1. **Orchestrator.** Decide the convention for the 5,209 named-but-unread bytes in §6 against the 423 B here.
   Separately, decide whether the stale copy counts (+43).
2. **Tighten the C-extent rows to C-read.** For `0x0254E2`–`0x0254E4`, prove that `sub_32798` returns Z with
   r2l ≠ 0 for r1 ∈ {0,3,5} while digit 5 is set. For `0x0254CF`, no tightening is possible: byte 1 of a record
   whose flag is `00` is never read.
3. **The curve region `0x03624B`–`0x0377C1` (5,495 B).**
   - It has rows of 51 B, one per MHz, like the live 420–470 MHz tables.
   - A search across the other FT-series images would show whether it is another model's band plan.
   - This image has no reader.

## Files

| File | Content |
| --- | --- |
| `ida\out\main-final-unnamed\runs.tsv` | The 46 runs with their decision rows, classes, non-straddle inbound hits and straddle count. |
| `ida\out\main-final-unnamed\proposed-typing.tsv` | 48 disjoint rows tiling the 519 B: class, confidence, tier, typing, evidence, and whether the row is in the named delta. |
| `ida\out\main-final-unnamed\refs.tsv` | Every non-straddle inbound hit (8, all BCD/straddle explained in §4). |
| `ida\out\main-final-unnamed\verify.txt` | Hashes, tiling assert, 95/0 citation check, tier sums, delta. |
| `ida\out\main-final-unnamed\n2_verify.py` | Decisions, byte-checked citations, whole-image inbound scan, table writer. |
| `ida\out\main-final-unnamed\n2_lib.py`, `n2_dis.py`, `n2_scan.py`, `n2_abs16.py` | Loader, head printer, exploratory scans (`work\scan.txt`, `work\abs16.txt`). |
| `ida\out\main-final-unnamed\work\` | `n2_heads.tsv`, `n2_xrefs.tsv`, `n2_items.tsv` (IDA dump), `runs_in.tsv`. |
| `ida\jobs\n2_dump.py` | IDA job (read-only, private DB `N2_UNNAMED`). |
