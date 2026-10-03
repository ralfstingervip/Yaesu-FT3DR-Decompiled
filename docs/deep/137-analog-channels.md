# 137 — MAIN analog channels AN1–AN5: readers, A/D setup and the labels that name them (lane N10)

> Lane N10. Private DBs `N10_AN` (`--copy-from ida\db\jobs\M1_MAIN_FINAL6\M1_MAIN_FINAL6.i64`) and
> `N10_AN_SUB` (`--copy-from ida\db\jobs\K7_SUB_FINAL3\K7_SUB_FINAL3.i64`, labels only). One read-only
> dump job `ida\jobs\n10_dump.py` (M8's dumper plus `census` and `xrange`): 11 MAIN passes and 3 SUB
> passes, no database edits. sha256 MAIN `8e3ecd05409b2c31…`, SUB `b93570b3c2f69ccb…`, checked at
> start and at finish, unchanged. Nothing was connected to or written to a radio. Model: `claude-opus-5-5`.
>
> Tables in `ida\out\analog-channels\`:
> - `channels.tsv` — one row per channel AN0–AN5: result register, conversion site, store, readers,
>   role, the string or unit that names it, identity grade.
> - `readers.tsv` — every instruction that writes or reads the five result bytes `FFA992`–`FFA996`
>   (23 sites), with function and role.
> - `align-items.tsv` — the 18 alignment items: SUB label, row code, row stub, which channel the stub
>   shows live, band-B permission, calibration byte, ROM default.
> - `n10_verify.py` — checks both hashes, asserts 112 listed byte citations and every
>   `0xADDR bytes` span in this doc (59), re-runs the raw census and regenerates the three TSVs.
>   Last run: 112/112 and 59/59 pass.
> - `work\` — request files and raw IDA output (`out1`–`out11.txt`, `sout1`–`sout3.txt`).

## Verdict

AN2–AN5 are now named by strings in this package. AN1 is still not.

- **AN3 (band A) and AN5 (band B) are the S-meter.** Confirmed: the reading is quantised into
  levels 0–10 between two calibration bytes that the SUB's alignment labels call **`S1 LEVEL`** and
  **`S9 LEVEL`**. The level is then compared with the setting labelled **`SQL S-METER`**.
- **AN2 (band A) and AN4 (band B) are the squelch-detector input.** Confirmed: the reading is compared
  with calibration bytes labelled **`HIS SQL`**, **`THLD SQL`** and **`TIGH SQL`**. The threshold is
  interpolated by the setting labelled **`SQL LEVEL`**.
  - A reading above the threshold mutes, so high means no signal. That fits a noise detector, but the
    detector type is Inferred, since no string names it.
- **The labels come from an on-radio alignment screen that earlier docs missed.** MAIN item rows
  `0xDC`–`0xE7` send a label index and a value to the SUB. The SUB draws the name from 16 `.data`
  records: `PLL REF`, `HIS SQL`, `THLD SQL`, `TIGH SQL`, `S1 LEVEL`, `S9 LEVEL`, `HI/L3/L2/L1 POWER`,
  `MAX/TONE/DCS/TUNE/DIG DEV`, `LCD CONTRAST`.
  - The SQL rows show **live AN2/AN4**, and the S-level rows show **live AN3/AN5**.
  - A key handler on those rows copies the live reading into the calibration byte. The runtime code
    then reads that byte back against the same channel.
  - That closed loop ties each label to its pin by bytes, not by guess.
- **AN1 stays Unknown.**
  - Its only reader is still `sub_35BAA`.
  - None of the 16 alignment labels uses it.
  - A whole-image vocabulary scan (TEMP, HEAT, SWR, REFL, CURR, THERM, PROTECT, FINAL, APC, °C and
    others) found no name for it.
  - PA temperature stays **Inferred, not Confirmed**, exactly as doc 120 left it.

## Method

- **Seed and dumper.** `n10_dump.py` is `m8_dump.py` with two read-only additions:
  - `census` lists every code head whose operand address or value equals a target. On MAIN it also
    matches `@aa:8` operands as `0xFFFF00|aa`.
  - `xrange` lists every xref into a range.
- **MAIN census.** Over all code heads in `0x000000`–`0x07FFFF`, with the closed window
  `0x078106`–`0x07B753` skipped, the census covered three groups (`work\out1.txt`, `out2.txt`):
  - the A/D registers `FFFF90`–`FFFFA1`;
  - the result bytes `FFA992`–`FFA996`;
  - `FF8970`, `FF8162`/`FF8166`, `FF97F8`–`FF97FF`, `FF3DE0`–`FF3DE2` and `FFAA33`.
- **Raw cross-check.** `n10_verify.py` byte-scans the whole image for `6a ?? a9 92..96` at even
  offsets and for any `ff a9 9x` abs24/abs32 form.
  - Result: 23 sites, the same as IDA's. No abs24/abs32 form exists.
- **Label chain.** Each link was read as bytes:
  1. alignment item;
  2. row code (`0x023156`);
  3. row stub (`0x782C` table);
  4. label index (`0x00D104`);
  5. MAIN frame byte `FF3DE0` = frame offset `0x6C`. Doc 124 established that SUB offset k = MAIN
     `FF3D74` + k;
  6. SUB renderer `sub_FFEDED8F`;
  7. RAM label `0x12182 + 16·i`, copied by `_INITSCT` from ROM `FFED8E74 + 16·i`.

  The calibration-byte mapping (`sub_3EDB2`) was then matched to the runtime readers' offsets.
- **SUB.**
  - Read the renderer and the SQL LEVEL / SQL S-METER value-draw arms of `sub_FFF01F70`, cases 7 and 8.
  - SUB names come from the K7 seed. `alias-final3.tsv` and `alias.tsv` map the continuation labels
    of `sub_FFEDED8F` (`FFEDEDDA`, `FFEDEE66`, `FFEDEEA0`, `FFEDEECE`) to it.
- **Not covered.**
  - The physical pins.
  - Which screen selects the key-handler rows that hold `sub_23496` / `sub_234AA`: the
    `0x014340`–`0x0146F7` rows are 17 × 4 B, but the index base was not found.
  - The display path of the S-level byte `+0x81` beyond the redraw flag.
  - The band-scope consumer of `FFAEC5[]`.
- **Deliberately omitted.** The alignment screen's entry condition is not reproduced here. That is
  scope: no recipe.

## Findings

### 1. A/D setup (Confirmed; unchanged from doc 120, re-read)

Conversion is polled and single-channel, with one sequence per sample:

1. channel → ADCSR `0xFFFFA0`;
2. `bset #5` (start);
3. spin on `btst #5`;
4. `bclr #7`;
5. read **one byte**, the upper 8 bits, from `0xFFFF90 + 2n`.

ADCSR and ADCR are zeroed at init (`0x0021EE fc 00 3c a0 3c a1`). The vector-67 handler zeroes them
again (`0x00010C 00 00 24 b6`, `0x00258E fc 00 3c a0 3c a1`).

**ADC register census over code heads (`work\out2.txt`).** All channel-select writes and result reads
are in `sub_20FA`, `sub_24B6`, `sub_32C0`, `sub_3466`, `sub_34538` and `sub_35C14`. Three hits are
data that IDA left as code heads:

| Site | Bytes | Actual content |
| --- | --- | --- |
| `0x000E20` | `31 9c` | DCS ramp entry (doc 120) |
| `0x04E96A` | `22 a0` | the base-91 `u16` table `0x04E8D8` (doc 118) |
| `0x04E970` | `2b 9e` | the base-91 `u16` table `0x04E8D8` (doc 118) |

No code reads `ADDRG`/`ADDRH` (`0xFFFF9C`/`0xFFFF9E`). Channels 6 and 7 are never selected.

| Ch | Conversion (bytes) | Store | Cadence |
| --- | --- | --- | --- |
| AN2 | `0x0032C0 fc 02 3c a0 7f a0 70 50 7e a0 73 50 46 fa 7f a0 72 70 2c 94 6a 8c a9 92` | `FFA992` | every `sub_32C0` call |
| AN3 | `0x0032D8 fc 03 3c a0 … 2c 96 6a 8c a9 93` | `FFA993` | same |
| AN4 | `0x0032F6 fc 04 3c a0 … 2c 98 6a 8c a9 94` | `FFA994` | only when `FF8DDE == 0` (`0x0032F0 6a 0c 8d de 46 30`) |
| AN5 | `0x00330E fc 05 3c a0 … 2c 9a 6a 8c a9 95` | `FFA995` | same gate |
| AN1 | `0x034544 fc 01 3c a0 … 2c 92 6a 8c a9 96`; twin `0x035C20` (same 24 B) | `FFA996` | TX only (doc 120) |

`sub_32C0` is called from the main loop `sub_2070` (`0x002BD4`, `0x0037E6`, `0x003928`, each
`5e 00 32 c0`) and from `sub_30E0` (`0x003130`).

### 2. Every reader of `FFA992`–`FFA996` (Confirmed, whole image; `readers.tsv`)

There are 23 sites: 4 AN2–5 writes, 2 AN1 writes and 17 reads. No base-register or abs24/abs32 form
exists.

| Channel | Readers (site, bytes) | What the reader does |
| --- | --- | --- |
| AN2 `FFA992` | `sub_306EA` `0x03079A 6a 0d a9 92 1c db 44 3a` | band-A squelch decision (§3) |
| | stub `0x0067DA` (`0x0067E8 6a 0d a9 92`) | alignment rows THLD/TIGH SQL: shows the live value (§5) |
| | `sub_23496` `0x0234A4 6a 0a a9 92` | alignment key: copies the live value into the calibration byte |
| AN3 `FFA993` | `sub_3E060` `0x03E08A`, `0x03E0D0` (`6a 0d a9 93`) | band-A S-level 0–10 → record `+0x80`/`+0x81` (§4) |
| | `sub_3E110` `0x03E11E` | same quantiser, result in `r2l`, used by `sub_2D708`/`sub_2D71A`/`sub_2D802`/`sub_2D814` |
| | stub `0x0067EE` (`0x0067FC 6a 0d a9 93`) | alignment rows S1/S9 LEVEL: live value |
| | `sub_234AA` `0x0234B8 6a 0a a9 93` | alignment key: copy into the calibration byte |
| AN4 `FFA994` | `sub_3210C` `0x0321BC 6a 0d a9 94 1c db 44 3a` | band-B squelch decision |
| | stub `0x0067DA` (`0x0067E2`) | live value, band-B side (`8EA0.b6`) |
| | `sub_23496` `0x02349E` | copy, band-B side |
| AN5 `FFA995` | `sub_3E26C` `0x03E296`, `0x03E2DA` | band-B S-level |
| | `sub_3E31A` `0x03E328` | band-B quantiser, used by `sub_2E2DC`/`sub_2E2EE`/`sub_2E3D6`/`sub_2E3E8` |
| | stub `0x0067EE` (`0x0067F6`) | live value, band-B side |
| | `sub_234AA` `0x0234B2` | copy, band-B side |
| AN1 `FFA996` | `sub_35BAA` `0x035BB6 6a 0c a9 96 ac eb 45 54 ac ef 45 1c ac f4 45 20` | the only reader: foldback at `0xEB`/`0xEF`, cutoff at `0xF4` (doc 120) |

### 3. AN2/AN4 are the squelch input (Confirmed by label; detector type Inferred)

`sub_306EA` (band A, sole caller `sub_30654` at `0x0306B2 55 36 ab 02 47 24`) reads its calibration
block through `FF8162`:

`0x030756 01 00 6b 03 81 62 6e 35 00 01 6e 3d 00 02 6e 36 00 00 0c 6e 11 0e 18 ed 18 e5 6a 0a 89 70`

1. **Hysteresis.** `h = cal[0] >> 1`.
2. **End points.** `t1 = cal[1] − h` and `t15 = cal[2] − h`.
3. **Level.** `L` is `FF8970`.
4. **Threshold.**
   - L = 1 gives `t1`, and L = 15 gives `t15`.
   - Levels 2–14 interpolate: `t1 − ((t1 − t15)/14)·(L − 1)` (`0x030786 fc 0e 51 c3 1a 0a 50 a3`).
   - L = 0 takes the tone-class path through `sub_3EF2E`.
5. **Compare.** `0x03079A 6a 0d a9 92 1c db 44 3a`: if AN2 ≤ threshold, return 0. Otherwise, unless
   state `+0x90` is already 2, add `cal[0]` of hysteresis and compare again; above it, return **2**
   (`0x0307A2 6e 0c 00 90 ac 02 47 06 08 6b 1c db 44 2c fb 02`).
6. **Mute.** State 2 is mute (doc 93).

`sub_3210C` is the byte-for-byte band-B twin. It uses `FF8166` (`0x032178 01 00 6b 03 81 66`),
`FF8971` (`0x032192 6a 0a 89 71`) and AN4. Its caller is `sub_320B6` (`0x0320B6 55 54 ab 02 47 42`).

**What names it.**

- `FF8970`/`FF8971` are the **`SQL LEVEL`** setting. The F347 sender stub `sub_57BC` sends `FF8970`
  for band A and `FF8971` for band B (`0x0057C4 6a 10 8e a0 73 60 46 06 6a 0d 89 70 40 16 6a 0d 89 71`,
  `0x0057EC 79 0b f3 47`). F347 is labelled `SQL LEVEL` at SUB `0xFFC3E141` (doc 38, re-read).
- `cal[0]`, `cal[1]` and `cal[2]` are the alignment bytes labelled **`HIS SQL`**, **`THLD SQL`** and
  **`TIGH SQL`** (§5, `align-items.tsv`).
- The ROM defaults for block 0 make sense under those names: THLD `0x89` > TIGH `0x4E`
  (`0x00EF92 00 89 4e …`). A tighter squelch level lowers the noise threshold.

### 4. AN3/AN5 are the S-meter (Confirmed by label)

`sub_3E060` (band A) runs as follows:

1. **Gate.** It stores level 0 when `+0x90 == 2`, or when `+0x8F.b1` is clear and the setting at
   record `+0x37` is 0 (`0x03E074 6e 0c 00 37 58 70 00 84`). Otherwise it quantises.
2. **Quantise** (`0x03E07C 01 00 6b 03 81 62 6e 3a 00 03 6e 32 00 04 6a 0d a9 93 1c 2d 44 20`).
   It reads `cal[3]` and `cal[4]`:
   - AN3 ≥ `cal[4]` gives level **10** (`0x03E0B2 fa 0a`);
   - otherwise the step is `(cal[4] − cal[3])/8` (`0x03E098 fb 08 51 b4`), and the level counts how
     many of the 9 thresholds `cal[3] + k·step`, k = 0…8, AN3 reaches (`0x03E09E fe 09`).
3. **Store.** The level goes to `+0x80`/`+0x81` (`0x03E0B4 fc 00 6e 8c 00 80 6e 8a 00 81`).

**What names it.**

- `cal[3]` and `cal[4]` are the alignment bytes labelled **`S1 LEVEL`** and **`S9 LEVEL`**, so the
  levels are S0 (below S1), S1–S9, and 10 at or above the S9 byte.
- Record `+0x37` is the **`SQL S-METER`** setting: F348 sender `0x0056F4 79 0b f3 48 6e 0b 00 37`,
  label SUB `0xFFC3E155`.
  - `sub_2FC6E` compares the level with it through the identity table `0x003B6E 00 01 … 0a` and
    closes the band (`+0x90 = 1`) when the level is below the setting
    (`0x02FCA6 6e 04 00 81 6e 0d 00 37 7a 65 00 00 00 ff 6e 5c 3b 6e 1c c4 44 08 fc 01 6e 8c 00 90`).
  - Band B: `sub_317DC`, the same bytes at `0x031814`.
- The SUB draws that setting as `OFF` for 0 (`0xFFF02C09 5a 01 f7 03 61 01 21 27`, string
  `0xFFF486DD`), else `LEVEL  n` (`0xFFF02C9F fb e2 ec 8a f4 ff`, `0xFFF48AEC`).
  - So the unit shown is the generic `LEVEL`. The S-unit meaning comes from the two calibration
    labels, not from the value text.

**Other consumers.**

- `sub_3DF86`/`sub_3E192` compare `+0x80` with its previous value `+0x84` and set the redraw flag
  `817E.b1`. This is the meter display (Inferred).
- `sub_3E110` and `sub_3E31A` feed `sub_2D73C`/`sub_2E310`, which stores the level into `FFAEC5[AE9D]`
  and steps the index up or down (`0x02D73C fc 27 6e 8c 00 8a 6a 0b ae 9d 7a 63 00 00 00 ff 6e bd ae c5`).
  A per-step level array fits the band scope (Inferred).

### 5. The alignment screen that carries the labels (Confirmed; `align-items.tsv`)

**SUB side.**

- `_INITSCT` DTBL entry `0xFFED8A4C 70 8e ed ff fb 8f ed ff 7e 21 01 00` copies `FFED8E70`–`FFED8FFB`
  to RAM `0x1217E`.
- The records are `{4 B, name}` on a **16-byte** stride from `FFED8E70`. Names start at `FFED8E74`:
  `PLL REF`, `HIS SQL` (`FFED8E84`), `THLD SQL` (`FFED8E94`), `TIGH SQL` (`FFED8EA4`), `S1 LEVEL`
  (`FFED8EB4`), `S9 LEVEL` (`FFED8EC4`), `HI POWER`, `L3 POWER`, `L2 POWER`, `L1 POWER`, `MAX DEV`,
  `TONE DEV`, `DCS DEV`, `TUNE DEV`, `DIG DEV`, `LCD CONTRAST` (`FFED8F64`).
- Renderer `sub_FFEDED8F`:
  - label index = frame `[0x8C4D + 0x6C]`, clamped to 0 above 15
    (`0xFFEDEDB9 fb e2 4d 8c 00 00 c5 e0 6c 0f b3 89 61 f1 2b 05 3c 0f 00`);
  - name = `0x12182 + 16·index` (`0xFFEDEDDC 6c 42 fb 42 82 21 01 00 4b 24`);
  - value = `[0x8C4D + 0x6D]`, drawn as a number (`0xFFEDEE14 … c5 e0 6d 0a`).

**MAIN side.**

- Item index `FF97F8` runs 0…0x11. The stepper `sub_231C2` uses the range word `0x0231EC 00 11 00 ff 97 f8`
  with helper `sub_3F636`.
- The row stubs, via the row table `0x023156 dd de df df e0 e0 e0 e0 e1 …` and the dispatch at
  `0x004810 … 78 b0 6b 26 00 00 78 2c … 5d 60`, do the following:
  - write the label index `D104[item]` to `FF3DE0` (`0x00D0F0 78 50 6a 2b 00 00 d1 04 7a 06 00 ff 3d e0 68 eb`);
  - write the value to `FF3DE1` (`0x00D11A`).
- `FF3DE0`/`FF3DE1` are frame offsets `0x6C`/`0x6D`.

**Rows that show live A/D, and why it ties the labels.**

- Row `0xDF` (items 2 and 3, THLD/TIGH SQL) uses stub `0x0067DA`. Row `0xE0` (items 4–7, S1/S9 LEVEL)
  uses stub `0x0067EE` (`0x007BA8 00 00 67 da 00 00 67 ee`).
- Each stub loads AN2/AN4 or AN3/AN5 by side (`8EA0.b6`). It sends that live byte when `AA33.b1` is
  set; otherwise it sends the stored calibration byte (`0x006816 … 6a 10 aa 33 73 10 46 06 5e 03 ed aa 68 4d 5e 00 d1 16`).
- Row `0xDE` (HIS SQL) uses the generic stub `0x00676C` (`0x007BA4 00 00 67 6c`) and shows only the
  stored byte. That fits a hysteresis, which is a difference, not a level.
- `sub_23496` and `sub_234AA` load the same pairs. With `AA33.b1` set, they store the live byte into
  the calibration byte `sub_3EDAA()` points at, then toggle `AA33.b1`
  (`0x0234BC 6a 10 aa 33 73 10 47 06 5e 03 ed aa 68 ca 6a 18 aa 33 71 10`). They are reached only
  through key-handler pointers `0x014468`/`0x014478` and `0x0144AC`/`0x0144BC`.
- The calibration byte for items 1–7 and 0xF is `FF8016` (side A) or `FF8096` (side B), plus a band
  offset 0/0x10/0x30/0x20 from record `+4`, plus **item − 1**
  (`0x03EE20 1a 0b 0a b4 6a 10 8e a0 73 60 47 08 7a 14 00 ff 80 96 40 06 7a 14 00 ff 80 16`,
  `0x03EDCC`).
  - So THLD SQL is offset 1, TIGH SQL 2, S1 LEVEL 3 and S9 LEVEL 4.
  - `HIS SQL` is offset 0.
  - At run time `FF8162`/`FF8166` point at the same blocks, chosen by record `+0x8E`
    (`0x03EE9A`, `0x03EEC4`; written at `0x02F6C8`, `0x0311B6`).
  - The readers in §3–4 use exactly offsets 0–2 with AN2/AN4 and 3–4 with AN3/AN5.
- **Defaults.** ROM `0x00EF92` is copied to both `FF8016` and `FF8096`; `0x00F012` goes to `FF80C6`
  (`0x00DE26`, `0x00DE38`, `0x00DE4A`). Block 0 reads
  `00 89 4e 20 49 3b 59 91 5f 37 08 …`: the HI/L3/L2/L1 POWER defaults `91 5f 37 08` decrease, which
  is consistent with the item mapping.

**Band-B items and the second S-meter pair.**

- Band-B side is allowed only for items 1–5, 0xF and 0x10. Permit table
  `0x023144 ff 00 00 00 00 00 ff ff …`, read at `0x023112`.
- Items 6 and 7 are a second S1/S9 pair at offsets 5 and 6. They force record `+0x19` to 2
  (`0x0232EA`, `0x023302 ac 02 47 06 fc 02 6e 8c 00 19`), and the forward stepper skips them
  (`0x0231E0 ab 06 47 de ab 07 47 da`).
- No runtime reader of offsets 5 or 6 goes through `FF8162`/`FF8166`. Not found, scope: all eight
  pointer loads `0x030756`, `0x03E07C`, `0x03E0C2`, `0x03E110` and `0x032178`, `0x03E288`, `0x03E2CC`,
  `0x03E31A` use offsets 0–4.

### 6. AN1 (Unknown — Not found)

- **Readers.** Still only `sub_35BAA`.
- **Alignment.** No alignment item shows or stores `FFA996`: the census has no `a9 96` outside
  `sub_34538`, `sub_35BAA` and `sub_35C14`. No label among the 16 is a temperature or protection item.
- **Vocabulary scan, both whole images.** The only hits are unrelated:
  - `W PROTECT` at `0xFFF4AAD9` is SD write-protect;
  - `TEMP` and `Temp` are APRS weather units (doc 120);
  - `HEAT` is the unused popup (doc 120).
- **Grade.** PA temperature stays Inferred, low to moderate. Identity is Unknown.

## USB relevance

- **Q1, USB.** None of these routines touches `0xFFEE00`–`0xFFEE53`. The alignment screen's values
  travel only on the MAIN→SUB frame (`FF3DE0`/`FF3DE1`), not on USB.
- **Q2, SDR: unchanged, no.**
  - AN2–AN5 are 8-bit, polled once per `sub_32C0` call.
  - AN3/AN5 are the detected signal strength and AN2/AN4 the squelch detector. Both are DC levels
    after detection, not IF or IQ.
  - The fastest consumer turns AN3 into an 11-step level.
- **Q3, DSP.** Unaffected. Nothing here uses SCI-C.

## Corrections to earlier docs (owning docs not edited)

| Doc | Earlier claim | New reading | Bytes |
| --- | --- | --- | --- |
| 93 §2 | "the RSSI squelch `sub_306EA` (`A992` against setting `FF8970`)" | `A992` (AN2) is the squelch-detector input, calibrated by HIS/THLD/TIGH SQL, and high mutes. `FF8970` is SQL LEVEL (F347). The RSSI/S-meter is AN3 (`A993`). | `0x030756 … 6a 0a 89 70`, `0x03079A 6a 0d a9 92 1c db 44 3a`, `0x0057C4 … 6a 0d 89 70` |
| 120 Verdict, `sensor.tsv` | AN2–AN5 "per-band receiver quantities (roles Unknown)"; Open 5 | AN2/AN4 = squelch input, AN3/AN5 = S-meter, Confirmed by labels. `0x007BA8` is the row-stub table entry for row DF; `0x014468`/`0x014478` are key-handler pointers. | §2–§5 |
| 12 §5.4, 08 (line 384) | No alignment or calibration UI; "if per-unit alignment exists it is not labelled" | 16 labelled alignment items exist (SUB `.data` `FFED8E74`), drawn by `sub_FFEDED8F` from MAIN rows `0xDC`–`0xE7`. The calibration block is `FF8016`/`FF8096` (EEPROM image, doc 96). | `0xFFED8E70 00 00 00 01 50 4c 4c 20 52 45 46`, `0xFFEDEDDC 6c 42 fb 42 82 21 01 00` |
| 12 Open 5 | `PLL REF` "access = indexed_possible … resolve its indexed access" | Index = frame `[8C4D+0x6C]`; MAIN item 0 → calibration byte `FF8056`. | `0xFFEDEDB9`, `0x03EDB2 7a 04 00 ff 80 56` |
| 46 §3 | "20-byte adjustment-name records" | 16-byte records: `{4 B, 12-char name}`, names at `FFED8E74 + 16·i` | `0xFFEDEDDC 6c 42` (`shll #4`) |
| 07 §MAIN A/D | "quantizes to S-meter bars" in `sub_32C0` | Already corrected by doc 120. The S-meter quantiser is `sub_3E060`/`sub_3E26C` on AN3/AN5. | `0x03E07C` |

## Proven / named bytes (proposals only)

Measured against `ida\out\m-wave-recon\final7_*_mask.bin`. Every routine cited is already proven. All
tables cited are named, except one run:

| Range | Bytes | Proposal | Basis |
| --- | --- | --- | --- |
| `0x023145`–`0x023148` | 4 (`00 00 00 00`) | **named +4** (data, `u8 byte_23144[18]`, entries 1–4) | Read at `0x023112 78 40 6a 2b 00 02 31 44 4b 22`, indexed by `FF97F8` ∈ 0…0x11 (range word `0x0231EC 00 11 00 ff 97 f8`, helper `0x03F636`). Entries 1–4 are the band-B permit flags for items 1–4 (HIS/THLD/TIGH SQL, S1 LEVEL). The neighbours `0x023144` and `0x023149`–`0x023155` are already named. |

- **Named delta:** +4, one range, `0x023145`–`0x023148`.
- **Proven delta:** 0.
- **SUB:** 0.

## Open

1. **Physical pins.** Confirm AN1–AN5 against a board or service manual. The AN1 identity can only
   come from there.
2. **Key-row base for `0x014340`–`0x0146F7`.** The rows are 17 × 4 B. Finding the index base would
   prove which screen reaches `sub_23496`/`sub_234AA`. The labels do not depend on it, because the
   runtime offsets close the loop.
3. **The second S1/S9 pair (items 6/7, offsets 5/6, record `+0x19 = 2`).** Look for a reader outside
   the `FF8162`/`FF8166` path, for example AM mode.
4. **The `+0x81` S-level path to the SUB display and band scope** (`FFAEC5[]`), and item 0x12
   (`FF97FF` set), whose label code `D104[0x12]` reads past the 18-byte table.
