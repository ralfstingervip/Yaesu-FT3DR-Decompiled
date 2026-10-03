# 87 — Menu names for the DSP config payloads (opcodes 0x11 / 0x12 / 0x32) and LOCATION SERVICE (lane K5)

Owner-side, static, read-only analysis of the owner's FT3DR/FT3DE ver 1.02 images. SUB is
`decrypted\FT3D_SUB_ver102_ALL.bin` (RX64M, little-endian, mapped at `0xFFC00000`, file offset = address −
`0xFFC00000`). MAIN is `decrypted\FT3D_MAIN_ver102_EXP.bin` (H8SX, big-endian, base 0, file offset =
address). No image was modified, nothing was connected to or written to any device, and the closed window
`0x078106`–`0x07B753` was not analysed. No market/destination/band-edge gate logic was decoded. Model:
**Opus 5.5 (`claude-opus-5-5`)**.

Machine tables, all in `ida\out\dsp-payload-labels\`:

| File | Contents |
| --- | --- |
| `f3-label-map.tsv` | 19 rows. F3A3, F3AB, F325, and the 16 hidden MAIN rows `0xC2`–`0xD1`. Each row: MAIN row id and menu position, notifier, dial and exit handlers, RAM byte, region/n, EEPROM address, default, SUB group/row, English and Japanese label (with raw JIS bytes), SUB value-draw case, value list, status and byte evidence. |
| `opcode-payload-names.tsv` | 27 rows. Opcode, frame byte, MAIN RAM source, packing, menu name or hidden row id, value meaning, status and evidence. Covers `0x32`, `0x11`, `0x12`, plus `0x1C [2]`. |
| `location-service.txt` | The LOCATION SERVICE answer, with every byte run and all 15 readers. |
| `k5_sub_dump.txt`, `k5_main_dump*.txt`, `k5_*sites.txt`, `k5_ff8d82_readers.txt` | Raw IDA listings and site→function lookups from this pass. |

Scripts: `ida\jobs\k5_dump.py` (copy of `h7_dump.py`; `lin`/`func`/`xref`/`imm`), `ida\jobs\k5_readers.py`
(site → containing function and callers) and `ida\jobs\k5_gen_tables.py`. The last one is plain read-only
Python: it re-reads **76 cited byte runs** from the two `.bin` files, asserts each one, and writes the two TSVs.
The last run printed `checks ok: 76 f3 rows: 19 op rows: 27`.

## Verdict

**F3A3 is APRS > APRS MODEM and F3AB is APRS > APRS TX DELAY.** So **DSP opcode `0x32` is the APRS
data-modem configuration frame**, not an "AMS / mode" frame:
- byte `[1]` carries the modem: OFF / 1200 bps / 9600 bps, encoded `0x00` / `0x85` / `0x8A`;
- byte `[2]` carries the TX delay: 100–1000 ms in nine steps, encoded as the high nibble (index + 3), `0x30`…`0xB0`.

Lanes G3 (doc 38) and H7 (doc 45) had already put both labels in their tables. Doc 77 (J9) missed them. This
pass re-verified both from the bytes on both processors and joined them to the opcode.

**The `FF8E20`–`FF8E36` block (opcode `0x11`) has no menu name anywhere in this build.** The same holds for
`FF8D85`–`FF8D87` (opcode `0x12` bytes `[1]`–`[3]`), `FF8E3D`–`FF8E3F` (opcode `0x11` bytes `[15]`–`[17]`) and
`FF8E2B`–`FF8E2D` (opcode `0x1C`). Their only user-interface trace is **16 vestigial MAIN setup rows, `0xC2`–`0xD1`**:
- they sit at indices 4–19 of the TX/RX > DIGITAL row list `0x1516A`, after the four visible rows;
- each row's exit handler saves exactly one of these DSP-config fields to EEPROM;
- every one has an `rts` entry notifier (no frame to the SUB, so the SUB has no label for it) and a
  consume-only dial handler (no edit);
- all are cut off by three separate guards: the cursor clamp `cmp.b #4` at `0x14F2E`, the touch list's
  row count of 4 at `0x29A4A`, and the reset at `0x150A6`.

The block's only RAM writers are the factory defaults (`0xE73C`–`0xE7A2`) and the EEPROM restore. In practice
these are factory DSP parameters that the user cannot change.

**LOCATION SERVICE is an ordinary, reachable setting.** It is TX/RX > DIGITAL, row 1:
- MAIN row id `0xB5` → IPC code F325 → SUB `menu_table` group `0x16`, row 1;
- settings byte `FF8D82` bit 0 (R3 `n=0x62`, EEPROM `0xD062`), default ON, values OFF/ON;
- Japanese label 位置情報ON/OFF.

It feeds no DSP config opcode. Its readers are in the TX-start path and the position-data builders.

## Method

- **Private DBs.**
  - `K5_SUB`: `run_job.py --copy-from ida\db\jobs\SUB_FINAL2\SUB_FINAL2.i64`, one run.
  - `K5_MAIN`: `--copy-from ida\db\jobs\J1_MAIN_FINAL3\J1_MAIN_FINAL3.i64`, then 8 `--reopen` runs.
  - Every run returned `idat_exit 0`, and no `k5_*_error.txt` was written. No shared DB was opened and
    `run_ida.py` was not run.
- **SUB, read in full:**
  - `sub_FFF092FC` (code → group) and `sub_FFF09396` (code → row);
  - the label walker `sub_FFF0964A`;
  - the draw dispatcher `sub_FFF004C2`, the TX/RX value drawer `sub_FFF0104F` (table `FFF481F0`) and the
    APRS drawer `sub_FFF057FF` (table `FFF48262`);
  - the store handlers `FFEFFEB8` (APRS, table `FFF4819C`) and `FFEFEA4B` (TX/RX);
  - the Japanese group handlers `FFF09A75` (group `0x16`) and `FFF0A4DE` (APRS, table `FFF4832A`);
  - `menu_table` `0xFFED74E8`, all 30 eight-byte slots decoded from the bytes.
- **MAIN, read in full:**
  - the three sender stubs, the three dial handlers and the step routine `0x3F62E`;
  - the row-code builder `sub_14EBE` / `sub_14C90`, and the touch path `0x29A20`–`0x29A8C`;
  - the opcode builders `0x5905E` (`0x11`), `0x59240` (`0x12`), `0x5A040` (`0x1C`) and `0x5EB4E` (`0x32`);
  - the factory-default block `0xE700`–`0xE7CC`.
- **Raw-byte scans of MAIN `0x000000`–`0x07FFFF`:**
  - abs16 (`6A/6B 0x/8x/1x/3x`) and abs32 (`00 FF hh ll`) forms of every payload RAM byte, `FF8AA0`,
    `FF8ABD` and `FF8D82`. A literal regex bug (`0x3F` = `?`) was caught, and the scan was redone with
    `bytes.find`;
  - every call form (`jsr`/`jmp` abs24, `bsr` d8/d16, BE32 pointer) into the `0x19926`–`0x199CC` save stubs;
  - the BE16 exit table `0x19A9E` (206 entries);
  - `mov.b #0xC2..0xD1,r3l` followed within 14 bytes by a screen push.
- **Screen tables.** For row ids `0xC2`–`0xD1` / `0x92` / `0x99` / `0xB5`, all four of H13's
  screen-indexed tables were read directly from the bytes (`0x782C`, `0x12268`, `0x19A9E`,
  `0x1208C`/`0x125D4`). They agree with `ida\out\hidden-settings\screens.tsv`.
- **Not done.**
  - What any config byte means *to the DSP*. That is Unknown: no DSP firmware is in the package.
  - The runtime-only bytes of opcode `0x12` (`[4]` and up).
  - The function of `sub_45238`, which forces `FF8AA0 = 0` at `0x4525C`.
  - The meaning of the `0x61`/`0x62` position markers.
  - The internals of the SD-card group, which `0xCx` codes would select on the SUB if they were ever sent.

## Findings

### 1. How an F3 code becomes a label on the SUB (Confirmed)

`sub_FFF092FC` maps the code byte at frame `+1` (`0x8C4E`) to a group:
- hi nibble 8 or 9 → group 8;
- hi nibble `A` or `B` → group 9 (`FFF09317` `71 1e f6 61 2e 23 60`);
- `C` → `0xA`, `D` → `0xB`, `E` → `0xC`;
- hi nibble 2 is split by range: ≤`0x22` → `0x15`, ≤`0x25` → `0x16` (`FFF09344` `75 51 25 2a 07 3c 02 16`),
  ≤`0x28` → `0x17`, ≤`0x2A` → `0x16`, else `0x17`.

`sub_FFF09396` gives the row:
- hi nibble `A`: row = low nibble (`FFF09551` `61 a1 18 c5 00 05 04`);
- hi nibble 2: low nibble 1 or 5 → row 1 (`FFF09417`).

The walker forms `*(u32*)(0xFFED74E8 + 8·group + 4) + 20·row` (`FFF09695` `fb e2 e8 74 ed ff` …
`FFF0969F` `75 13 14` … `FFF096A2` `06 89 e3 01`).

| `menu_table` slot | bytes | count | label base |
| --- | --- | --- | --- |
| group 9 `FFED7530` | `1c 00 00 00 89 e4 c3 ff` | 28 | `FFC3E489` (row 3 `FFC3E4C5` **APRS MODEM**, row 11 `FFC3E565` **APRS TX DELAY**) |
| group `0x16` `FFED7598` | `04 00 00 00 bd e7 c3 ff` | 4 | `FFC3E7BD` (row 1 `FFC3E7D1` **LOCATION SERVICE**) |

Groups 1–12 and `0x15`–`0x17` are populated, and groups 0 and 13–20 are empty. Their labels sum to 116; the
hidden RAM DISPLAY row makes 117. **No group can hold a label for the hidden `0xC2`–`0xD1` rows**: group
`0x16` has exactly 4 rows (Confirmed). **Not found:** no DSP-parameter label exists among the 120 label slots
of `0xFFC3DF4D`–`0xFFC3E8D4`.

### 2. F3A3 = APRS MODEM (Confirmed on both processors)

| Side | Evidence |
| --- | --- |
| MAIN row | APRS row list `0x151BE` = `90 9f 91 92 …`, so index 3 = `0x92` |
| MAIN notifier | `0x782C[0x92]` = `0x5AAE`: `79 0b f3 a3 6a 0b 8a a0 5e 00 97 6a 54 70` (send F3A3 with `[FF8AA0]`) |
| MAIN dial | `0x12268[0x92−0x0E]` = `0x17822`: if `FF8DDE≠0`, consume the key only (`6a 0c 8d de 47 06 5e 03 ff a0`). Otherwise `bset #3,@FFB0CE` (**re-send opcode `0x32`**), then the wrapping step `0x3F628` over record `0x1786A` = `00 02 00 ff 8a a0` (range 0..2) |
| MAIN exit | `0x1976C` `79 01 00 00 5a 03 cc ec` (save R2 `n=0`, EEPROM `0xC000`) |
| MAIN default | `0xE684` `6a ac 00 ff 8a a0` = 0 (OFF). Also forced to 0 at `0x4525C` in `sub_45238` (callers `0xED2E`, `0x451F0`; purpose Unknown) |
| SUB store | APRS jump table `FFF4819C` → `FFEFFED7`, 1-byte compare-and-copy `FFEFFF01` `c5 fe 20 20` |
| SUB draw | `FFF48262[3]` = `b7 01` → `FFF059FD`: 0 → `OFF` `FFF486DD`, 1 → `1200bps` `FFF499F3`, otherwise `9600bps` `FFF499FB` |
| SUB JP label | `FFF0A531` → `FFF4A8CA`, mask `0x0014`: `41 50 52 53 20 f4 2d da 2d c4 20 40 5f 44 6a` = `APRS ボーレート 設定` (APRS baud-rate setting). `F4` is the vendor precomposed ボ (doc 45); `405F 446A` = 設定 |

The MAIN TX state machine branches on the same byte: `0x345AA` `cmp.b #1` and `0x34B58` `cmp.b #2` (in
`sub_34538` / `sub_34B44`). Those are the 1200 and 9600 paths. **Correction:** doc 77's "top-level
operating-mode selector" for `FF8AA0` is wrong. It is the APRS modem selector.

### 3. F3AB = APRS TX DELAY (Confirmed; one quirk Inferred)

| Side | Evidence |
| --- | --- |
| MAIN row | `0x151BE[11]` = `0x99` |
| MAIN notifier | `0x5D1A` `79 0b f3 ab 6a 0b 8a bd 5e 00 97 6a 54 70` |
| MAIN dial | `0x17990`: `bset #3,@FFB0CE` (**re-send `0x32`**), then `btst #1,@FF89C4`. When the bit is clear: record `0x179B6` = `00 08 00 ff 8a bd` (0..8). When it is set: `0x179BC` = `00 0a 00 ff 8a bd` (**0..10**) |
| MAIN exit / default | `0x19774` save R2 `n=0x1D` (EEPROM `0xC01D`); `0xE68A` `fc 04 6a 8c 8a bd` = 4 |
| SUB draw | `FFF48262[11]` = `11 09` → `FFF06157`: `smovf` copies 9 × 16 B from `FFF49BE0` = `100ms`, `150ms`, `200ms`, `250ms`, `300ms`, `400ms`, `500ms`, `750ms`, `1000ms`. A value ≥9 is drawn as 8 (`FFF0616A` `61 91 29 07 fa 04 db 09 08`) |
| SUB JP label | `FFF4A92F`: `41 50 52 53 20 54 58 20 ee a8 da b2` = `APRS TX ディレイ` (`EE` = vendor デ) |

**Quirk (Inferred).** `FF89C4` bit 1 is a hidden feature bit. Doc 49-key-sequence records it as toggled
only by the code-entry match `02060804` at `0x1643E`. With that bit set, TX DELAY can be stepped to 9 or 10.
Two things then disagree:
- the SUB clamps the display to `1000ms`;
- the opcode-`0x32` builder maps any value ≥9 to 0 (`0x5EBAC` `ac 09 45 02 fc 00`), so the DSP receives
  `0x30`, the 100 ms code.

Only the opcode builder reads `FF8ABD` (scan scope above), so the extended values reach nothing else.

### 4. Opcode payloads with names (Confirmed sources; `opcode-payload-names.tsv`)

The frame base is `FFB13E` = byte `[0]`.

**Opcode `0x32`** (builder `0x5EB4E`; `0x5EB8A` `f3 32 fb 00 6a 0c 8a a0 47 02 70 7b …`):

| Byte | Source | Packing | Menu name | Values on the wire |
| --- | --- | --- | --- | --- |
| [1] | `FF8AA0` | `(v≠0)<<7 \| v<<2 \| v` | APRS MODEM (F3A3) | OFF `0x00`, 1200 bps `0x85`, 9600 bps `0x8A` |
| [2] | `FF8ABD` | `((v<9?v:0)+3)<<4` | APRS TX DELAY (F3AB) | 100 ms `0x30`, 150 `0x40`, 200 `0x50`, 250 `0x60`, **300 `0x70`** (default), 400 `0x80`, 500 `0x90`, 750 `0xA0`, 1000 `0xB0` |
| [3] b0 | `FFAA35` b7 | bit | runtime, not a menu item | doc 77 |

The two dial handlers set `FFB0CE` b3 (`0x1782E`, `0x17990`), and that bit is what J9's `sub_5B2D8` tests to
re-send `0x32`. This confirms by code, not by name alone, that **changing APRS MODEM or APRS TX DELAY
re-sends opcode `0x32`**. Inferred: the APRS AFSK/9600 modem runs on the DSP. What the DSP does with these
codes is Unknown.

**Opcode `0x11`** (builder `0x5905E`). Bytes `[1]`–`[14]` match doc 77. Each one is now tied to its hidden
MAIN row:

| Bytes | RAM | Hidden row (exit save) |
| --- | --- | --- |
| [1] | `FF8E2A` | `0xC2` (`0x19926` n=`0x10A`) |
| [2] | `FF8E20`/`21` | `0xC3` (`0x1997E` block ×2) |
| [3] | `FF8E22`–`25` | `0xC4` (`0x1998C` ×4) |
| [4..7] | `FF8E26`–`29` | `0xC5` (`0x1999A` ×4) |
| [8] | `FF8E2E` | `0xC6` (`0x199A8` n=`0x10E`) |
| [9..11] | `FF8E2F`–`33` | `0xC7` (`0x199B0` ×5) |
| [12..13] | `FF8E34`/`35` | `0xC8` (`0x199BE` ×2) |
| [14] | `FF8E36` | `0xC9` (`0x199CC` n=`0x116`) |
| **[15..17]** | ROM `0xF9A8` **overlaid by `FF8E3D`–`3F` when `FF8E3C == 0x69`** | `0xCA`/`0xCB`/`0xCC` (n=`0x11D`/`0x11E`/`0x11F`) |
| [18..26] | ROM `0xF9AB`.. `00 28 04 30 60 3f 6f 19 19` | constant |
| **[27..30]** | `0xC0`; `0x17` if `FF8DDE≠0` else `0x27`; `0x10`; `0xF0` | constant / host-link flag |

Evidence for the new rows:
- **Overlay:** `0x59156` `6a 0c 8e 3c ac 69 46 18 fc 03 f4 00 7a 05 00 ff 8e 3d 7a 06 00 ff b1 4d 7b d4 59 8f`.
  The factory default writes `FF8E3C = 0x69` and copies ROM `39 2a 2a` into `FF8E3D`–`3F` (`0xE7A6`). So
  the overlay is a no-op until EEPROM differs.
- **Tail:** `0x59176` `f4 c0 6a 84 b1 59` … `cc 07 6a 8c b1 5a fc f0 6a 8c b1 5c`.

**Opcode `0x12`** (builder `0x59240`):
- `[1]` = `FF8D85 & 0xFC | DT`, row `0xCD`;
- `[2]` = `FF8D86` + request bits, row `0xCD`;
- **`[3]` = `FF8D87`, row `0xCE`.** This byte is new: `0x5930C` `6a 0b 8d 87 6b 83 b1 40`, default 4 at `0xE758`;
- bytes `[4]` and up are runtime state and are not mapped here.

**Opcode `0x1C` `[2]`** (`0x5A092`): `FF8E2B`/`2C` (rows `0xCF`/`0xD0`) or `FF8E2D` (row `0xD1`).

### 5. The 16 hidden DIGITAL rows `0xC2`–`0xD1` (Confirmed path, Not found label)

- **Row list.** `0x1516A` = `b8 b5 c1 b2 | c2 c3 c4 c5 c6 c7 c8 c9 ca cb cc cd ce cf d0 d1 | d6 d3`.
  - The first four are DIGITAL POPUP (`0xB8`), LOCATION SERVICE (`0xB5`), STANDBY BEEP (`0xC1`) and
    DIGITAL VW (`0xB2`).
  - The cursor record `0x1510E` = `00 14 00 ff ad 9b` would allow 0..20.
- **Three guards keep the cursor below 4. All three are Confirmed.**
  1. Keypad: `0x14F24` `7a 06 00 01 51 0e 5e 03 f6 2e ab 04 45 02 40 f0`. This means step the cursor with
     `sub_3F62E`, then `cmp.b #4; bcs ok; bra` back to step again. The wrapping step keeps its direction, so
     rows 4..20 are always stepped over.
  2. Touch: `0x29A4A` `fb 04 7a 01 00 ff 8f 51 5e 02 c0 30` (list hit-test with row count 4, saved cursor
     `FF8F51`).
  3. Reset: `0x150A6` `6a 0c 8f 51 ac 04 45 06 fc 00 6a 8c 8f 51` (saved cursor ≥4 → 0).
- **No other entry was found.** There is no `mov.b #0xC2..0xD1,r3l` followed by a push or direct entry
  (`0x3FF10` / `0x148A0` / `0x14C72`) anywhere in `0..0x80000` (Not found, that scope). H13's census also
  lists only the row-code paths.
- **The screens are stubs.**
  - The notifier for all 16 is `0x782C[id]` = `0x5EA38` = `54 70` (`rts`), so no frame goes to the SUB.
  - The dial handler `0x12268[id−0x0E]` = `0x3FFA0` only consumes the key.
  - The key tables hold only shared navigation slots. Rows `0xC2`–`0xC5`, `0xC7`–`0xC9` and `0xCD` use
    private tables (`0x13F98`…) whose only non-trivial slots are `0x158DE`, `0x159E6` (runs the exit
    handler `sub_19158`) and `0x14BBC` (pops via `sub_3FF3A`). Row `0xC8`'s table `0x140EC` has
    `0x152D4`/`0x15948` instead, the same slots as the generic table. The others use the generic table `0x12948`,
    whose dial slot `0x15E1E` reaches the consume-only `0x3FFA0`.
  - Only the exit handler does real work, and it saves the field. The notifier, dial and exit slots of all
    16 rows were verified in `k5_gen_tables.py`.
- **No writer can change the values.**
  - No abs16 or abs32 store to `FF8E20`–`FF8E36`, `FF8E3D`–`3F`, `FF8D85`–`87` or `FF8E2B`–`2D` exists in
    MAIN `0..0x80000`, other than the factory-default block `0xE73C`–`0xE7A2` and the eepmov at `0xE7BC`.
  - The R3 restore at `0x3D652`–`0x3D662` (`79 06 01 80`, `7a 00 00 00 d0 00`, `7a 01 00 ff 8d 20`,
    `5e 03 ab 80` = read 0x180 bytes from EEPROM `0xD000` into `FF8D20`) reloads them.
  - `FF8D86`, `FF8E24`, `FF8E25`, `FF8E2B`, `FF8E2C` and `FF8E34`–`36` have no default store at all, so their
    values come only from EEPROM.
  - Doc 32 also maps these bytes to `BACKUP.dat` offsets `0xCFC0`–`0xCFDF`. Whether the SD restore path
    writes them back was not traced here.
  - Inferred: these are factory-set DSP parameters, and the vestigial rows were probably a service or
    engineering page that this build compiles out.

### 6. LOCATION SERVICE (Confirmed; role Inferred)

The full record is in `location-service.txt`. In short:

| Item | Value |
| --- | --- |
| SUB | group `0x16` row 1 (`FFF09344`, `FFF09417`); store `FFEFEA4B` (codes `0x24`..`0x2A`, 1 byte); draw `FFF481F0[5]` → `FFF01162`, OFF `FFF486DD` / ON `FFF48787` (shared with STANDBY BEEP and DIGITAL VW) |
| SUB JP | `FFF09AE6` → `FFF4A5F7`, mask `0xAA00`, JIS `304C 4356 3E70 4A73` = 位置情報, plus `ON/OFF` |
| MAIN | row `0x1516A[1]` = `0xB5`; notifier `0x5E9B2` `79 0b f3 25 6a 0b 8d 82 5e 00 97 6a 54 70`; dial `0x5E526` with record `00 01 00 ff 8d 82`; exit `0x19976` save R3 `n=0x62`; default `0xE728` `fc 01 6a 8c 8d 82` (ON) |
| Readers | 15 sites, all `btst #0,@FF8D82`. `0x35A46` in `sub_35A04` (TX/PTT state machine): if ON, `AC0A == 0` and DT is V/D-1 or V/D-2, it calls `sub_5CA34`. `0x35F9A` (main-loop twin). `0x5C622`: OFF writes marker `61 5F 30`, ON with `sub_23038` true writes `62 5F 30` at `FF0208`. `0x6A294`: ON with position copies 20 B `FF9D90` → `FF2F2E`. Plus 11 sites in `0x5C888`–`0x5CFB2` |

Inferred role: the setting gates whether the radio's own position data goes into a C4FM digital (V/D)
transmission, and the position-dependent display. **This corrects doc 14**, which said "not in any menu
category group". The label belongs to `menu_table` group 22 (1-based), the 4-row TX/RX > DIGITAL group, and
it is reachable with no condition.

## USB relevance

- **Q1 (USB): none.** No function in this pass touches `0xFFEE00`–`0xFFEE53` or enters the closed window.
  The F3xx path is the MAIN↔SUB SCI link, not USB.
- **Q2 (SDR): unchanged no.** Opcode `0x32` carries 3 configuration bytes (modem select, TX delay, a flag
  bit) and opcode `0x11` carries a fixed parameter block. Neither carries samples.
- **Q3 (DSP reachability): narrower.**
  - The user can reach exactly two DSP config fields from the menus: APRS MODEM and APRS TX DELAY, both in
    opcode `0x32`.
  - Every byte of opcodes `0x11`, `0x12 [1..3]` and `0x1C [2]` is factory/EEPROM-only. The hidden rows that
    would save them can neither be entered nor edit a value.
  - There is still no path from any UI to an arbitrary DSP opcode or arbitrary payload.
  - The firmware's UI gives no way to change the DSP parameter block; only EEPROM contents (and possibly a
    `BACKUP.dat` restore, not traced) set it. That was not examined further.

## Open

1. **`sub_45238`** (`0x4525C` forces APRS MODEM OFF, together with `FF89AB=2` and `FF89D0=0`). Name the event:
   it is called from the default block (`0xED2E`) and from `0x451F0`.
2. **The DSP-side meaning of `0x32 [1]`/`[2]`** (`0x85`/`0x8A`, nibble 3..11), and of the `0x11` block.
   Unknown without DSP firmware. A `BACKUP.dat` diff of R3 `0xD100`–`0xD11F` across radios would show whether
   the factory values vary per unit (calibration) or are fixed.
3. **The `0x61`/`0x62` position markers** written at `FF0208` by `sub_5C602`, and `sub_5CA34`, to pin what
   LOCATION SERVICE puts on the air.
4. **The two trailing row codes `0xD6`/`0xD3`** in `0x1516A` (indices 20/21; H13 places them in group 13).
   They are outside the cursor's reach here.

### Corrections to earlier docs (owning docs not edited)

- **Doc 77 (J9) §Verdict/§6:**
  - F3A3/F3AB were already decoded (doc 38 `f3xx-codes.tsv`, doc 45 §2). They are **APRS MODEM** and
    **APRS TX DELAY**.
  - Opcode `0x32` is the **APRS modem config** frame, and `FF8AA0` is not an operating-mode selector.
- **Doc 77 §4:** opcode `0x11` bytes `[15..17]` are overlaid from `FF8E3D`–`3F` when `FF8E3C==0x69`.
  Bytes `[27..30]` (`C0`, `17`/`27`, `10`, `F0`) were omitted. The `FF8E20`–`36` block's menu rows exist but
  are hidden and inert (§5); doc 77 had their names as "Unknown".
- **Doc 77 §5:** opcode `0x12` byte `[3]` = `FF8D87` was omitted.
- **Doc 14 §3:** LOCATION SERVICE is in group 22 (TX/RX > DIGITAL, row 1) and is reachable.
- **Doc 32 row-code table:** `0x1516A`'s "22 rows" are 4 visible + 16 hidden DSP-config rows + `D6`/`D3`.
- **Doc 49-hidden-settings §5** noted that rows `0xC2`–`0xD1` share notifier `0x5EA38`. This pass adds what
  they save and the three guards that hide them.

Byte-count delta: **+0 B** to the decompile ledger. This pass named and verified existing code; it found no
new code.
