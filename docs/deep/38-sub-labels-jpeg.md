# 38 — SUB labels for the F3xx/F4xx item codes, mode/step tables, JPEG container and RGB565 clamp (lane G3)

Owner-side static analysis of the owner's FT3DR/FT3DE ver 1.02 images. Primary subject
`decrypted\FT3D_SUB_ver102_ALL.bin` (RX64M, little-endian, mapped at `0xFFC00000`, file
offset = address − `0xFFC00000`). MAIN (`decrypted\FT3D_MAIN_ver102_EXP.bin`, H8S, base 0,
big-endian) is read only to tie each code to its sender. Nothing was written to any device,
and no image was modified. Model: **Opus 5.5 (`claude-opus-5-5`)**.

Machine tables (`ida\out\sub-labels\`):
- `f3xx-codes.tsv` — 113 F3xx/F4xx codes. Columns: code, target flag, SUB screen, MAIN row code
  and stub, MAIN menu row lists, SUB group and row, label address and text, SUB value-draw
  routine, settings byte, status and note. A cross-check line sits in the header.
- `mode-step.tsv` — RX MODE strings, the STEP string table, the MAIN numeric step table, the
  SQL TYPE tables and the TX POWER table, each with bytes.
- `jpeg-markers.tsv` — each marker, whether it is handled or rejected, the compare site and
  the bytes.
- Raw listings from this pass: `code2label.lst` (sub_FFF092FC, sub_FFF09396, sub_FFF004C2,
  walker), `valdraw.txt`, `valcases.txt`, `modestep.txt`, `grp-handlers.txt`, `ipc-store.lst`,
  `based8C4D.txt`, `jpeg-helpers.txt` (sub_FFF4C442 and helpers).

## Verdict

**Part A.** All six codes resolve through the SUB's own table-driven path. For the five F3
codes the path is: IPC → setup-item screen `0x1F` → `sub_FFF092FC` (code → menu group) and
`sub_FFF09396` (code → row) → `menu_table[group].labels + 20*row`. F400 is the exception: its
title is drawn directly as a string.

| Code | SUB label (English path) | Value the SUB draws | MAIN source byte |
| --- | --- | --- | --- |
| **F320** | `FFC3E781` **ANTENNA ATT** (TX/RX>MODE, row 0) | 0 → `OFF`, else `ON` + icon | record `+0x39` b5 |
| **F321** | `FFC3E795` **FM BANDWIDTH** (TX/RX>MODE, row 1) | 0 → `WIDE`, else `NARROW` | record `+0x12` b5 |
| **F340** | `FFC3E0B5` **BELL** (SIGNALING, row 0) | `SELECT: OFF/BELL` (+0x22), `RINGER: n times/CONTI` (+0x23) | record `+0x38`; `[0xFF8995]` |
| **F34A** | `FFC3E17D` **SQL TYPE** (SIGNALING, row 10) | 12-entry SQL TYPE string table | record `+0x16` (band-remapped) |
| **F395** | no own row. `sub_FFF09396` has no case for `0x95`, so it falls to row 0 and the screen shows `FFC3E2D1` **APO** | `MODE: OFF/BUSY/SIGNALING` + `SELECT: PATTERN1..3` | record `+0x36` b0-1; `[0xFF89C7]` |
| **F400** | no setup label. Title string `FFF4A509` **TX POWER** is drawn directly by `sub_FFF0878C` | `LOW1/LOW2/LOW3/HIGH` | record `+0x13` |

The model also labels the other 107 sender codes. For 99 of the 103 (group, row) positions
that MAIN's own menu row lists name, the model agrees exactly. It is an independent check
against doc 32's `0x1515C` table. The 4 disagreements are listed in the table header; all 4 are
codes that the IPC routes to special screens or shared stubs.

**Mode 2 and step 0x0C are refuted as literal names.**
- The SUB RX MODE value table is `0 = FM`, `1 = AM`, **`2 = AUTO`**.
- The 13-entry STEP table ends with **`0x0C = AUTO`**. Index 2 is `8.33 KHz` and index 10 is
  `9.0 KHz`.
- So the doc-35 `+0x39` b3/b4 gates force RX MODE and STEP to **AUTO**: the band plan picks
  them. They do not name AM or an air-band step.
- AM and 8.33 kHz on the air band are what AUTO resolves to there. That part is Inferred.

**Part B.**
- `sub_FFF4B084` together with its marker dispatcher `sub_FFF4C442` is a **strict baseline
  JFIF decoder**:
  - parsed: SOI, APPn and COM (skipped, offered to a callback), DQT (8-bit only), DHT, DRI,
    SOF0, SOS, RSTn (sequence checked), EOI and DNL;
  - rejected with the error code `(marker<<16)|0xFF00`: SOF1, **SOF2 progressive**, every other
    SOFn, JPG, DAC, DHP, EXP and JPGn.
- **The doc-30 "8-colour" saturation puzzle is a disassembler display artefact.** `75 5n ff` is
  RX `CMP #UIMM8`, an unsigned immediate, so the compare is with **255**, not −1. `75 4n ff` is
  `MOV.L #UIMM8`, which loads **255**. The 150 clamps are a normal `[0,255]` saturation. There
  is no clamp table.

## Method

- **IDA database.** Private DB `G3_SUB`, seeded `--copy-from ida\db\jobs\FIN_SUB_T2\FIN_SUB_T2.i64`
  (copy only). Iterated with `--reopen`. Every run exited 0 and no traceback file was written.
- **Generic dumper `ida\jobs\g3_dump.py`.** It takes request files with these commands:
  - `func` dumps a whole function, creating it if needed;
  - `lin` gives a linear decode;
  - `imm` does an operand-value scan;
  - `based` finds every `o_displ`/`o_phrase` access whose base register was loaded with
    `mov.l #base` within 4 heads. It reads the displacement from `op.value`, per the RX trap.

  The sweep `based 8E46` (the IPC pending frame) and `based 8C4D` found every reader of the
  frame's code byte (+1) and value bytes (+0x20..). That led to the label path.
- **Plain Python `ida\jobs\g3_gen_tables.py`** (read-only over the `.bin` files). It contains:
  - instruction-by-instruction Python models of `sub_FFF092FC` and `sub_FFF09396`;
  - decoding of the SUB menu table, the value-draw jump tables and the string tables;
  - the MAIN sender table `0x782C` and each stub's F-code;
  - the cross-check against doc 32's row lists.

  It writes `f3xx-codes.tsv` and `mode-step.tsv`. `jpeg-markers.tsv` was built from the
  `sub_FFF4C442` jump table and the byte-checked compare sites.
- **Scope covered:**
  - the full F3/F4 receive path: IPC → screen 0x1F → per-group store handlers → per-group
    value-draw dispatchers → label walker;
  - all 245 entries of the MAIN sender table;
  - the whole JPEG header path: `sub_FFF4B084` from start to SOS, and all of `sub_FFF4C442`;
  - the convert inner loop of `sub_FFF4C9D1`.
- **Not done:**
  - per-code value-draw tables for groups 1, 3, 5, 6, 7, 9, 10 and 11 (marked `-` in the TSV);
  - the entropy and IDCT internals beyond the marker compares;
  - the Japanese-language label path (`0x8F72 != 1`), which is a separate switch at
    `FFF096C0`.

## Findings

### A1. How an F3/F4 item frame reaches a label (Confirmed)

1. **IPC.** `sub_FFEDF3A7` maps an F3 sub-op to a screen. Everything except
   `0x00/0x01/0x66/0xB3/0xB8/0xD1` (and the excluded `0xD5/0xD6`) goes to screen **0x1F**
   (`FFEDF3FC` `3c 02 1f`). F4 sub-op 0 also goes to 0x1F (`FFEDF428` `3c 02 1f`).
2. **Latching.** Screen 0x1F's handler `FFEFE664` copies frame byte 0 to `0x8C4D`
   (`FFEFE682` `c0 fe` `mov.b [r15],[r14]`) and frame byte 1, the code, to **`0x8C4E`**
   (`FFEFE6A9` `c5 fe 01 01` `mov.b 1[r15],1[r14]`).
   - So the "settings shadow `0x8C4D`" of doc 34 is really a latched copy of the 300-byte
     frame. `0x8C6D` is the value at frame+0x20, and doc 34's `0x8CBA` is frame+0x6D.
3. **Store dispatch.** `FFEFE6AF` calls `sub_FFF092FC` and dispatches on the group:

   | Group | Store handler |
   | --- | --- |
   | 1 | `FFEFE727` |
   | 2, 0x15–0x17 | `FFEFEA4B` |
   | 3 | `FFEFECA4` |
   | 4 | `FFEFF034` (table `FFF48150`) |
   | 5 | `FFEFF4E5` |
   | 6 | `FFEFF68A` |
   | 7 | `FFEFF710` |
   | 8 | `FFEFF906` (table `FFF4816C`) |
   | 9 | `FFEFFEB8` |
   | 0xA | `FFF000AC` |
   | 0xB | `FFF00220` |
   | 0 | `FFF00462` |

   Each handler compares frame+0x20.. with the latched copy. If a byte changed, it sets redraw
   flag `0x8000` (`sub_FFEEFEA4`) and stores the byte (e.g. `FFEFEAA5` `c5 fe 20 20`).
4. **Draw.** `sub_FFF004C2` runs `grp = sub_FFF092FC()` (`FFF004C4` `05 38 8e 00`) and then
   `row = sub_FFF09396()` (`FFF004CA` `05 cc 8e 00`). It calls the per-group value drawer:
   - TX/RX: `sub_FFF0104F`, table `FFF481F0`, codes 0x20..0x2C;
   - SIGNALING: `sub_FFF01F70`, table `FFF4820A`, codes 0x40..0x4D;
   - CONFIG: `sub_FFF04090`, table `FFF48232`, codes 0x80..0x97;
   - group 0: `sub_FFF0878C`.

   Then it calls the walker `sub_FFF0964A(6, 0x1D, grp, row)` (`FFF00576` `05 d4 90 00`).
5. **Walker, English path.** It draws `*(u32*)(0xFFED74E8 + 8*grp + 4) + 20*row`:
   - `FFF09695` `fb e2 e8 74 ed ff` `mov.l #FFED74E8,r14`;
   - `FFF0969F` `75 13 14` `mul #14h,r3`;
   - `FFF096A2` `06 89 e3 01` `add 4[r14].l,r3`.

**Code → group, `sub_FFF092FC`.** The rule is `hi = code>>4`:

| `hi` | Group |
| --- | --- |
| 8, 9 | 8 |
| A, B | 9 |
| C | 0xA |
| D | 0xB |
| E | 0xC |
| 2 | split by thresholds: `≤0x22` → 0x15, `≤0x25` → 0x16, `≤0x28` → 0x17, `≤0x2A` → 0x16, else 0x17 |
| any other | `hi` |

**Code → row, `sub_FFF09396`.** It is a hand-coded case ladder, and **the default is 0**
(`FFF093B0` `3c 04 00`). Two examples:
- `hi=8`: `lo≤2` → `lo`; `lo≤6` → `lo+1`; else `lo`.
- `hi=9`: `lo≤4` → `lo+0x10`; `6` → `0x15`; `7` → `3`; **`5` has no case** (`FFF0952D` `61 41`,
  `FFF09539` `61 61`, `FFF09544` `61 71`).

The full model is in `g3_gen_tables.py`.

### A2. The six codes (Confirmed unless marked)

- **F320 → ANTENNA ATT.**
  - Group: `0x20 ≤ 0x22` → 0x15. Row: `lo=0` → 0. Label `FFC3E781`.
  - Store: `FFEFEA4B` path `FFEFEA7B` (one byte, +0x20).
  - Draw: jump table `FFF481F0[0]` → `FFF01087`. Value 0 draws `FFF486DD` "OFF"
    (`fb 22 dd 86 f4 ff`); otherwise `FFF48787` "ON" (`fb 22 87 87 f4 ff`) plus the bitmap
    `FFECEECC`.
  - MAIN: row code `0x13` → stub `0x4E70` `6e 0c 00 39 77 5c 79 0b f3 20`, i.e.
    `bld #5,@(0x39,er0)`, so the source is record `+0x39` b5. That matches doc 35's attenuator
    shadow bits.
- **F321 → FM BANDWIDTH.**
  - Row 1, label `FFC3E795`.
  - Draw `FFF010FF`: 0 → `FFF48828` "WIDE" (`fb 22 28 88 f4 ff`); else `FFF4882D` "NARROW".
  - MAIN stub `0x52E4` `6e 0c 00 12 77 5c 79 0b f3 21`: record `+0x12` b5. Doc 35's "halves the
    RF level" is the narrow-FM deviation.
- **F340 → BELL.**
  - Group 4, row 0, label `FFC3E0B5`.
  - Store `FFF48150[0]` → `FFEFF083` (bytes +0x20..+0x23).
  - Draw `FFF4820A[0]` → `FFF01FAB`:
    - "SELECT :" (`FFF489E7`), then +0x22: 1 → "BELL" (`FFF02007` `fb 12 f0 89 f4 ff`),
      0 → "OFF";
    - "RINGER :" (`FFF489F5`), then +0x23 (`FFF0204E` `59 ee 23`): "CONTI" (`FFF48A03`) or
      "n times" (`FFF48A09`).
  - MAIN stub `0x4EB4` `6e 03 00 38 … 6a 0c 89 95 … 79 0b f3 40 5e 00 97 92`:
    - high byte = record `+0x38` → frame+0x22;
    - low byte = `[0xFF8995]` → frame+0x23. That byte is R1 n=0x75, EEPROM `0x5F5`,
      BACKUP.dat `0x4B5`.
    - The word sender `sub_9792` puts the band flag at +0x20 and the word at +0x22/23.
- **F34A → SQL TYPE.**
  - Group 4, row 10, label `FFC3E17D`.
  - Store `FFF48150[10]` → `FFEFF053` (one byte).
  - Draw `FFF4820A[10]` → `FFF02D88`. It block-copies two 0xC0-byte string tables:
    - long names at `FFF48AF4`: OFF, TONE, TONE SQL, DCS, REV TONE, JR FREQ, PR FREQ, PAGER,
      (blank), D CD, TONE-DCS, D CD-TONE SQL;
    - short names at `FFF48BB4`: TN, TSQ, DCS, RTN, JR, PR, PAG, DC, T-D, D-T.

    It clamps the index to 0x0B (`FFF02DAA` `61 c1`) and indexes with `shll #4`.
  - MAIN stub `0x57F8` `5e 03 ef ee 0c cb … 79 0b f3 4a`: record `+0x16` after the band remap
    in `sub_3EFEE`.
  - This settles doc 35's "F34A tone/code group": it is the SQL TYPE index.
- **F395 → no dedicated label (fallback APO).**
  - Group 8 (`hi=9`). Row: no case for `lo=5` → default 0 → label `FFC3E2D1` "APO".
  - The code is not orphaned on the value side: store `FFF4816C[0x15]` → `FFEFF956`, and draw
    `FFF48232[0x15]` → `FFF051CA`:
    - "MODE  :" (`FFF49172`), then +0x22 = 0 "OFF", 1 "BUSY" (`FFF48E28`), 2 "SIGNALING"
      (`FFF4917A`);
    - "SELECT:" (`FFF49184`), then +0x23 = PATTERN1/2/3 (`FFF4918C/95/9E`).
  - MAIN stub `0x52CC` `6e 03 00 36 e3 03 6a 0b 89 c7 … 79 0b f3 95`:
    - record `+0x36` b0-1 → MODE;
    - `[0xFF89C7]` (R1 n=0xA7, EEPROM `0x627`, BACKUP.dat `0x4E7`) → SELECT.
  - Row code `0x80` is in **no** MAIN menu row list (doc 32), and the SUB has no row for it. It
    is a working but unlisted item: a busy/signalling indication mode with three patterns.
    **Inferred:** a vestigial or hidden setting. The on-screen title would be the APO fallback.
- **F400 → TX POWER.**
  - F4 frame, `0x8C4E = 0` → group 0 → `sub_FFF0878C`. It draws "TX POWER" (`FFF087A5`
    `fb 42 09 a5 f4 ff`, English when `0x8F72 == 1`) and the value from the 4×16 table at
    `FFF4A51F`: LOW1, LOW2, LOW3, HIGH. The index is clamped to 3 (`FFF087F0` `61 41`).
  - Store `FFF00462` (one byte, +0x20).
  - MAIN stub `0x597E` `6e 0b 00 13 … 79 0b f4 00`: record `+0x13`, a 2-bit field. That fits
    four power levels.

**Corrections to earlier docs (Confirmed by this table):**
- F391 = STEP, F38E = RPT SHIFT, F342 = DCS INVERSION, F346 = PR FREQUENCY, F348 = SQL S-METER
  and F322 = RX MODE (doc 23 §5) are now independently confirmed.
- Doc 35's "`sub_57BC` (`F347` TX power)" is wrong: **F347 is SQL LEVEL** (group 4, row 7,
  `FFC3E141`). TX power is F400.
- Doc 34's "settings shadow `0x8C4D`" is the latched IPC frame.

### A3. Mode and step tables (Confirmed; full rows in `mode-step.tsv`)

- **RX MODE** (code 0x22, draw `FFF011C5`):
  - The selector is a compare chain on +0x20 (`FFF011CB` `59 ee 20`, `FFF011CE` `61 2e`
    `cmp #2`).
  - The strings are contiguous at `FFF48834` `46 4d 00 41 4d 00 41 55 54 4f 00`:
    **0 = "FM"** (`FFF48834`), **1 = "AM"** (`FFF48837`), **2 = "AUTO"** (`FFF4883A`).
  - +0x21 picks a mode icon from `FFECE5EC`/`FFECE5FC`/`FFECE60C`.
- **STEP** (code 0x91, draw `FFF04CBA`):
  - `75 43 82` / `fb 22 8c 90 f4 ff` copy 0x82 bytes from `FFF4908C`, 13 entries × 10 bytes.
  - The index is clamped to 0x0C (`FFF04CCC` `61 d1`) and scaled with `mul #0Ah`
    (`FFF04CDF` `63 a3`).

  | Index | Value |
  | --- | --- |
  | 0 | 5.0 |
  | 1 | 6.25 |
  | 2 | **8.33** |
  | 3 | 10.0 |
  | 4 | 12.5 |
  | 5 | 15.0 |
  | 6 | 20.0 |
  | 7 | 25.0 |
  | 8 | 50.0 |
  | 9 | 100.0 |
  | 10 | **9.0** |
  | 11 | 200.0 KHz |
  | **0x0C** | **"AUTO"** (`FFF49104` `41 55 54 4f 00…`) |

- **MAIN numeric step table** `0x1E07C`: 12 BE u16 values in 10 Hz units,
  `01f4 0271 09c4 03e8 04e2 05dc 07d0 09c4 1388 2710 0384 4e20`, which is
  5, 6.25, **25**, 10, 12.5, 15, 20, 25, 50, 100, 9, 200 kHz.
  - Index 2 holds 25.00 kHz where the SUB shows 8.33. 8.33 kHz cannot be written in 10 Hz
    units, so it must be synthesised elsewhere (Inferred).
  - There is no entry 0x0C. AUTO has no numeric step, which is consistent with the `+0x39` b4
    gate bypassing the table (doc 35).
- **Answer.** The doc-35 gates show **RX MODE = AUTO** and **STEP = AUTO** (Confirmed by the
  strings). "Mode 2 = AM" and "step 0x0C = air step" are **refuted** as table meanings. The
  air-band behaviour (AM, 8.33/25 kHz) is what AUTO resolves to on that segment. **Inferred**,
  from the 108 MHz band-plan evidence in doc 35.

### B1. JPEG container (Confirmed; per-marker rows in `jpeg-markers.tsv`)

**Marker dispatcher.** `sub_FFF4C442` reads a marker with `sub_FFF4C408`, which skips 0xFF
fill (`FFF4C40F` `75 51 ff`) and ORs in `0xFF00`. It then indexes the **63-entry s16 jump table
`FFF50960`** by `marker−0xFFC0` (`FFF4C45A` `add #-0FFC0h`, `FFF4C45F` `cmp #3Eh`, base
`bra.l` at `FFF4C470`):

| Targets | Action |
| --- | --- |
| `FFDB` → `FFF4C472` | DQT |
| `FFC4` → `FFF4C5CF` | DHT |
| `FFDD` → `FFF4C802` | DRI |
| `FFE0..FFEF`, `FFFE` → `FFF4C82B` | skip; when callback `[ctx]+0x38` is set, the payload is handed to it (`jsr r5` at `FFF4C8AC`) |
| `FFC0`, `FFC1`, `FFC2`, `FFDA` → `FFF4C960` | push the two marker bytes back (`sub_FFF4C391` ×2) and return 0 |
| everything else → `FFF4C916` | `shll #10h,r7; or #0FF00h` → error `(marker<<16)|0xFF00` |

**Core `sub_FFF4B084`.**
- **SOI** must come first (`FFF4B267` `77 01 d8 ff 00`).
- After the dispatcher, the frame marker **must equal SOF0** (`FFF4B2A6` `77 06 c0 ff 00`).
  SOF1 and **SOF2 (progressive)** reach `FFF4B5E8` and are rejected with
  `0xFFC1FF00`/`0xFFC2FF00`.
- **SOF0 checks:**
  - P = 8 (`FFF4B2DF` `61 81`);
  - X ≠ 0;
  - Y = 0 is allowed only when DNL is enabled (`[ctx]+0x40`; Y := 0xFFFF at `FFF4B313`);
  - Nf = 1..3 (`FFF4B394` `61 31`);
  - Lf = 8 + 3·Nf;
  - Hi, Vi ∈ {1, 2, 4} (`FFF4B4CE`/`FFF4B4D4`, `FFF4B4F3`/`FFF4B4FB`);
  - Tqi ≤ 3 (`FFF4B55B`).
- **SOS** (`FFF4B63D` `77 01 da ff 00`) requires Ls > 2, Ns ≤ Nf and Ls = 2·Ns + 4.

**Table segments.**
- **DQT:** Pq must be 0 (`FFF4C4AF` `fd 78 c1 f0 00` `tst #0F0h`), so 16-bit tables are
  rejected with `0xFFDB0100`. Tq ≤ 3 (else `0xFFDB0200`). At most 3 tables (else
  `0xFFDB0400`). Each table is 65 bytes, stored through the de-zigzag table `FFF508F8`.
- **DHT:** Tc 0 or 1 (else `0xFFC40100`), Th ≤ 1 (else `0xFFC40200`), DC symbol count 1..12
  (`FFF4C662` `61 c7`), AC count ≤ 162 (`FFF4C764` `75 57 a2`). That allows exactly 2 DC and
  2 AC tables, the baseline limit.
- **DRI:** Lr must be 4 (`FFF4C807` `61 21` on len−2); Ri is stored at `[ctx+4]+0x12`.

**Scan-level markers.**
- **RST0..7:** the expected marker is initialised to `0xFFD0` (`FFF4BA78` `f9 79 20 d0 ff`)
  and checked and wrapped at `0xFFD7` (`FFF4BC75` `77 01 d7 ff 00`).
- **EOI** at `FFF4BB55` `77 0e d9 ff 00`.
- **DNL** at `FFF4BB5D` `77 0e dc ff 00`. The header-time `0xFFDCFF00` is caught at `FFF4B668`.

**Profile.**
- Supported: baseline sequential Huffman, 8-bit, 1–3 components, sampling factors 1/2/4,
  restart intervals, DNL, and APP/COM skip with a hook.
- Not supported: progressive, extended-12-bit, lossless, hierarchical or arithmetic coding,
  and 16-bit quantisation tables.
- **No maximum-dimension compare exists in the header path.** X and Y are only tested ≠ 0. Size
  is enforced by the caller: the photo viewer `sub_FFF3CAD0` scales and clips to 320×240
  (doc 30).
- Which subsampling modes the output stage accepts (factor 0/1/2, i.e. 4:4:4, 4:2:2, 4:2:0)
  comes from doc 30's ladder. **Inferred.**

**Correction to doc 34.** The "ROM tables / sentinels" `0xFFDA0000/0100`, `0xFFDB0300`,
`0xFFDC0000/0100`, `0xFFFF0100` and so on are **return codes** of the form
`(marker<<16)|reason`. They are loaded into `r7`/`r1` just before error exits, for example
`FFF4B65D` `mov.l #FFDA0000,r1` → `FFF4B9E2`, or `FFF4C922..C951`. They are not tables.

```c
/* sub_FFF4C442: process table/misc segments until a frame or scan header. */
int jpeg_tables(ctx_t *c)
{
    for (;;) {
        int m = next_marker(c);                    /* sub_FFF4C408: skip 0xFF fill, |0xFF00 */
        if (m == -1) return 0xFFFF0100;            /* FFF4C974: input exhausted          */
        switch (m) {                               /* jump table FFF50960[m-0xFFC0]      */
        case 0xFFDB: if ((e = parse_dqt(c))) return e; break;   /* Pq==0, Tq<=3, <=3 tables */
        case 0xFFC4: if ((e = parse_dht(c))) return e; break;   /* Tc<=1, Th<=1, DC<=12, AC<=162 */
        case 0xFFDD: if ((e = parse_dri(c))) return e; break;   /* Lr==4 */
        case 0xFFE0 ... 0xFFEF: case 0xFFFE:
                     skip_segment(c, c->app_cb);   /* optional callback [ctx]+0x38 */
                     break;
        case 0xFFC0: case 0xFFC1: case 0xFFC2: case 0xFFDA:
                     unget(c, m & 0xFF); unget(c, 0xFF); return 0;
        default:     return (m << 16) | 0xFF00;    /* FFF4C916 */
        }
    }
}
/* caller (sub_FFF4B084): after jpeg_tables(), next_marker() must be 0xFFC0 (SOF0),
   otherwise return (m<<16)|0xFF00; i.e. SOF1/SOF2 are rejected here. */
```

### B2. Saturation idiom in `sub_FFF4C9D1` (Confirmed)

**Instruction sequence.** Each clamp is 17 bytes, for example at `FFF4CFA8`:

```text
75 59 ff   cmp   #255, r9        ; CMP #UIMM8, Rs  (75 5s uimm8, zero-extended)
2b 06      ble.b +6              ; signed r9 <= 255 -> keep checking low side
75 49 ff   mov.l #255, r9        ; MOV.L #UIMM8, Rd (75 4d uimm8, zero-extended)
0f         bra.s +7
61 09      cmp   #0, r9
26 04      bpz.b +4
66 09      mov.l #0, r9
```

IDA renders the unsigned immediate as `#-1`. The operand value it stores is `0xFF`, as the
dump column `#0xFF` shows. Three facts in the same image confirm the unsigned reading:
- the IPC switch `FFEDF3B4` `75 5e f3` compares a `movu.b`-loaded byte with **0xF3**. A signed
  −13 could never match it, and the F3 handler would be dead.
- `FFF4C967` `75 42 ff` pushes back the literal `0xFF` marker byte.
- The 4 genuine `mov.l #-1` returns in the function use the different signed form `fb x6 ff`.

**Counts in the routine.** The function contains 150 `75 5x ff` compares, 150 `75 4x ff` loads
and 152 `bpz`. There are only 2 unrelated `min`/`max`, and 0 data references, so **there is no
clamp table**. Doc 30's Open #1 closes: the output is continuous-tone, not 8-colour.

**Hand C**, for the YCbCr ×2-horizontal path `FFF4CF8E..FFF4D14E`. Coefficients and masks are
as read. One Cr/Cb pair feeds two luma samples, and every output pixel is written twice
(`mov.w r6,[r3]` / `mov.w r6,2[r3]`):

```c
static inline int sat8(int v) { return v > 255 ? 255 : (v < 0 ? 0 : v); }  /* 75 5n ff ... */

for (j = 0; j < pairs; j++) {
    int cr = c[2*j]     - 128;                     /* movu.b [r5];   add #-80h  */
    int cb = c[2*j + 1] - 128;                     /* movu.b 1[r5];  add #-80h  */
    int dR = (cr * 0x1670C) >> 16;                 /* 1.402 Cr  (mul; shar #10h) */
    int dB = (cb * 0x1C5E7) >> 16;                 /* 1.772 Cb                    */
    int dG = (cr * 0xB6E3 + cb * 0x5827) >> 16;    /* 0.714 Cr + 0.344 Cb         */
    for (k = 0; k < 2; k++) {
        int Y = y[2*j + k];                        /* [r1], then [var_38 + (r15|1)] */
        uint16_t px = (uint16_t)(((sat8(Y + dR) << 8) & 0xF800)    /* shll #8; and #0F800h */
                               | ((sat8(Y - dG) << 3) & 0x07E0)    /* shll #3; and #7E0h   */
                               |  (sat8(Y + dB) >> 3));            /* shlr #3              */
        out[4*j + 2*k]     = px;                   /* x2 horizontal replicate */
        out[4*j + 2*k + 1] = px;
    }
}
```

## USB relevance

- **No change to the three mission answers.**
- The F3/F4 frames are MAIN→SUB display notifications carried on the inter-processor SCI. The
  SUB only latches and draws them; it sends no USB, touches no peripheral and writes no flash.
- The JPEG stack is the SD-card photo viewer. Every input comes through the FatFs byte reader
  (`sub_FFF4C226` / `sub_FFF4C3A2`), and the only external hook is the APPn callback.
- Nothing here exposes a sample path, the DSP or a USB endpoint. This closes RESUME-FULL
  "next unlocks" items 4 and 5 as **imaging and UI only**.
- **One RX trap for the brief.** `75 4x`/`75 5x` carry an **unsigned** 8-bit immediate that
  IDA shows as negative. Any analysis that read `cmp #-N` or `mov.l #-1` from IDA text, rather
  than from `op.value`, should be re-checked. This trap produced doc 30's 8-colour reading.

## Open

1. **Groups 1, 3, 5, 6, 7, 9–11 value-draw tables.** Decode them the same way (dispatchers
   `FFF00684`, `FFF01D02`, `FFF0324E`, `FFF0381A`, `FFF03AD8`, `FFF057FF`, `FFF07E49`,
   `FFF08201`) to fill the `sub_value_draw` column for every code.
2. **F395's purpose.** Find who calls MAIN row `0x80` (it is in no menu list) to decide whether
   BUSY/SIGNALING + PATTERN is a hidden setting or dead code. Find also whether any SUB path
   other than `sub_FFF09396` gives it a title.
3. **8.33 kHz synthesis on MAIN.** Check `0x1E07C[2] = 2500` in context (`sub_1DF7A`,
   `sub_1700A`) to confirm how the 8.33 kHz step is produced when STEP index 2 is selected.
4. **Japanese label path** (`FFF096C0` switch on group) for completeness.
5. **The four cross-check disagreements** (F301, F3C0 row 0x89, F3D1 → screen 0x21): document
   the special screens 0x1D, 0x1E, 0x20, 0x21 and 0x43 they use.
