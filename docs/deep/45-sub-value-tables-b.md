# 45 — SUB value-draw tables for menu groups 9, 10, 11 and the Japanese label path (lane H7)

Owner-side static analysis of the owner's FT3DR/FT3DE ver 1.02 images. The main subject is
`decrypted\FT3D_SUB_ver102_ALL.bin`: RX64M, little-endian, mapped at `0xFFC00000`, so a file
offset is the address minus `0xFFC00000`. MAIN (`decrypted\FT3D_MAIN_ver102_EXP.bin`, H8S/H8SX,
big-endian, base 0) was read only to tie each item to its sender and its settings byte. Nothing
was written to any device, and no image was modified. Model: **Opus 5.5 (`claude-opus-5-5`)**.

Tables are in `ida\out\value-tables\`. Lane H6 shares this directory, and every H7 file has a
`b-`, `jp-` or `h7_` prefix.

| File | What it holds |
| --- | --- |
| `b-items.tsv` | 41 rows, one per F3Ax/F3Bx/F3Cx/F3Dx code. Columns: group and row, English label, Japanese label, draw case, frame fields, decoded values, SUB store width, MAIN sender stub, MAIN RAM reads, settings-byte link. |
| `b-options.tsv` | 383 rows: every option string, numeric format and row label. Columns: English text and address, Japanese text and address, JIS mask, instruction site. |
| `jp-labels.tsv` | 117 rows: the complete Japanese setup-label set. Columns: group, row, handler, dispatch, draw calls, decoded text, JIS codes. |
| `h7_main_senders.tsv` | The MAIN `mov.w #F3xx` sites for these codes, each with its stub bytes, the RAM it reads and the settings join. |
| `h7_*.txt` | Raw IDA linear listings from this pass. |

Scripts are in `ida\jobs\`:
- `h7_dump.py` is the IDA dumper, a copy of `g3_dump.py`;
- `h7_jp_labels.py`, `h7_main_senders.py` and `h7_gen_tables.py` are plain read-only Python.

## Verdict

**Groups 9, 10 and 11 are decoded.**

| Group | Codes | Draw cases decoded | Menu rows decoded |
| --- | --- | --- | --- |
| 9 (APRS) | 31 (A0–BE) | 31 of 31 | 28 of 28 |
| 0xA (SD CARD) | 5 (C0–C4) | 5 of 5 | 3 of 4 |
| 0xB (OPTION) | 4 (D0, D2–D4) | 4 of 4 | 4 of 4 |

- The missing 0xA row is FORMAT. No item code maps to row 3, so its value page is not reached
  through this path.
- D1 is routed to a different screen.
- Every option string, unit and numeric format is decoded from the image bytes (`b-options.tsv`).
- 24 of the 41 codes resolve to a persisted MAIN settings byte (region, index, EEPROM address,
  BACKUP.dat offset). Two defaults check out:
  - TIME ZONE defaults to `0x2C`, which decodes to **UTC+09:00**.
  - BEACON INTERVAL defaults to 4, which decodes to **5 min**.

**The Japanese label path is decoded.**
- **Language flag.** It is the SUB byte **`[0x8F72]`**: **1 = English, 0 = Japanese**.
  - The SUB latches it from **MAIN frame+7 bit 0**.
  - MAIN fills that bit from **`0xFF89C2` bit 1**: region R1 index `0xA2`, EEPROM `0x622`,
    BACKUP.dat `0x4E2`.
  - The F315 LANGUAGE item sends the same bit.
- **Labels.** There is no alternate label table. The walker branches to **15 per-group handler
  functions** that draw string literals.
- **Encoding.** The text is **7-bit JIS X 0208 mixed with single-byte text**:
  - a 16-bit mask in `r3` marks which bytes start a 2-byte JIS code;
  - the single-byte font holds ASCII, JIS X 0201 half-width katakana, and a vendor block
    `0xE0`–`0xF9` of precomposed voiced katakana.
- **Coverage.** All 117 Japanese labels are decoded: the 116 English rows plus the hidden
  `RAM 表示` (RAM DISPLAY) row. The glyph mapping is proved by rendering the font bitmaps.

## Method

- **IDA database.** Private DB `H7_SUB`, seeded with
  `run_job.py --copy-from ida\db\jobs\G3_SUB\G3_SUB.i64` and then iterated with `--reopen`. Every
  run exited 0. No shared database was opened, and `run_ida.py` was not run.
- **Dumper.** `ida\jobs\h7_dump.py` provides the `lin`, `func`, `imm` and `xref` commands. IDA's
  function bounds over this region are broken: for example, `sub_FFF057FF` is cut off at its
  `bra.l`. So the dispatchers were dumped linearly:
  - `FFF05848`, 3,700 instructions, ending at `FFF07E44`;
  - `FFF07E49`, 1,400 instructions, covering groups 0xA, 0xB and 0;
  - the Japanese walker region `FFF096C0` and `FFF097AF`, 1,900 instructions, ending past
    `FFF0AC5A`;
  - the store handlers `FFEFFEB8`;
  - the renderers `FFEFA7E7`, `FFEF1B23`, `FFEF190D` and `FFEF2184`, plus `FFEE5269`;
  - the helpers `FFF05387`, `FFF0547A`, `FFF05622` and `FFF005A9`;
  - an operand scan for `8F72`.
- **Jump tables** were decoded from the bytes:
  - for group 9, `FFF48262`, 31 entries of s16, base = the `bra.l` at `FFF05846`;
  - for the group-9 store handler, `FFF4819C`, base `FFEFFED5`;
  - for the Japanese group handlers, `FFF482D0`, `FFF482E2`, `FFF482FE` and `FFF4832A`.
- **Read-only Python.** It models the renderer's mask loop (`h7_jp_labels.py`) and decodes every
  string table. It joins MAIN sender stubs to doc 32's `settings-bytes.tsv` by scanning stub bytes
  for H8S absolute-address forms (`h7_main_senders.py`). The JIS mapping was checked by rendering
  glyphs from font record 2 (`0xFFED4644`, doc 27). The single-byte `0xE0`–`0xF9` block was
  identified by rendering record 13.
- **Not done.**
  - The internals of the number formatter `sub_FFEE1FCB` / `sub_FFEE1E8D`.
  - The SD statistics routine `sub_FFF12B18`.
  - The Bluetooth help strings: they come from RAM pointer tables `0x69248` and `0x690F8`, filled
    at run time (Unknown).
  - BA (manual LAT/LON editor) and BB (MY SYMBOL) are described at field level, not every digit
    position.
  - The MAIN-side sender bodies `0x9C16`, `0x9C52`, `0x9A54` and `0x98CA` were not decoded, so the
    order of frame bytes is Inferred for the multi-byte items.

## Findings

### 1. Dispatch and store, groups 9, 0xA and 0xB (Confirmed)

**Draw dispatcher.** `sub_FFF004C2` calls these per-group drawers (G3 established this, and I
re-read it):

| Group | Call site | Drawer |
| --- | --- | --- |
| 9 | `FFF0053F` | `sub_FFF057FF` |
| 0xA | `FFF00544` | `sub_FFF07E49` |
| 0xB | `FFF00556` | `sub_FFF08201` |

After the 0xA and 0xB drawers it **suppresses the label** for code `0xC3` (`FFF0054F` `75 51 c3`)
and for code `0xD3` (`FFF00561` `75 51 d3`).

**Group 9 drawer.** It reserves a `0x9DC`-byte frame, copies frame+0x20, and sets x/y constants.
Then it dispatches on `code−0xA0` ≤ `0x1E`:

```text
FFF05831  72 11 60 ff   add #-0A0h,r1,r1
FFF05835  75 51 1e      cmp #1Eh,r1
FFF0583D  fb e2 62 82 f4 ff  mov.l #FFF48262,r14
FFF05843  fe 51 ee      mov.w [r1,r14],r14
FFF05846  7f 4e         bra.l r14
```

- A0 and A7 share one case.
- B3 and B8 go to `FFF07E44`: no draw, and the IPC sends them to screen 0x20.

**Group 0xA drawer** (`FFF07E63`):

| Code | Target |
| --- | --- |
| C4 | `FFF07EEE` |
| C3 | `FFF07EE9`, soft-key icons only, via `sub_FFF005A9` → `FFF0066B` |
| C0..C2 | `FFF07E79` |

**Group 0xB drawer** (`FFF08225`..`FFF0823A`):

| Code | Target |
| --- | --- |
| D4 | `FFF08749` |
| D2 | `FFF083D6` |
| D3 | `FFF0856F` |
| D0 | `FFF0823D` |
| anything else, including D1 | `rtsd` |

**Store, group 9.** The handler uses jump table `FFF4819C`. Most cases are a single-byte
compare-and-copy (`FFEFFF01` `c5 fe 20 20`). Multi-byte items call
`sub_FFEF208D(0x8C6D, 0x8E66, n, 0x8000)`, with `n` taken from the `add #k,r14` immediate:

| Code | Bytes | Code | Bytes | Code | Bytes |
| --- | --- | --- | --- | --- | --- |
| A2 | 11 | A9 | 21 | BA | 17 |
| A4, AC, AE, B4, B7 | 5 | AA | 10 | BB | 24 |
| A5 | 56 | B0 | 13 | BD | 12 |
| A6 | 98 | B2 | 53 | | |
| A8 | 19 | | | | |

**Store, groups 0xA and 0xB.**

| Code | Store |
| --- | --- |
| C0..C2 | 1 byte (`FFF000F0`) |
| C3 | +0x20 plus 4 records of 0x13 bytes (`FFF000F6`..`FFF0021C`) |
| C4 | none |
| D0, D2, D3 | multi-field stores (`FFF00242`, `FFF002EC`, `FFF003B0`) |
| D4 | 1 byte (`FFF0045A`) |

A recurring layout: `+0x20` is the focus or edit flag, `+0x21` is the top row or cursor, `+0x22`
is the cursor, and `+0x23+row` are per-row values. The list items wrap modulo the row count, for
example `FFF05914`.

### 2. Item values — group 9 (APRS) (Confirmed; strings in `b-options.tsv`)

| Code | Label | Values (frame byte → text) | MAIN source (settings byte) |
| --- | --- | --- | --- |
| A0 / A7 | AF DUAL / MUTE | +0x20: 0 OFF, else ON | `0xFF8AAB` b0 / b3 (R2 n=0xB, EEPROM `C00B`) |
| A1 | DESTINATION | fixed `MODEL CODE : APY03D` (`FFF4995F`); no value | frame only (`0xA252`) |
| A2 | FILTER | 8 rows (`FFF49973`): Mic-E, POSITION, WEATHER, OBJECT, ITEM, STATUS, OTHER, ALTNET; each OFF/ON (+0x23+row) | `0xFF8AAE` b0–6, `0xFF8AAF` b0 (R2 n=0xE/0xF) |
| A3 | MODEM | 0 OFF, 1 `1200bps`, else `9600bps` | `0xFF8AA0` (R2 n=0x0, default 0) |
| A4 | MSG FLASH | MSG (+0x22, ≤0x20), GRP (+0x23, ≤9) and BLN (+0x24, ≤9) all index one 33-entry table (`FFF493C0`): OFF, 2/4/6/8 sec … 60 sec, CONTINUOUS, EVERY 2 s … EVERY 10 m | `0xFF8BE2/3/4` (R2 n=0x142–0x144) |
| A5 | MSG GROUP | 6 user names of 9 chars at +0x22+9i, in list widget `sub_FFF03652` | frame (`0xA276`) |
| A6 | MSG TEXT | 5 user texts of 16 chars at +0x22+16i | frame (`0xA29A`) |
| A8 | POPUP | 16 rows (`FFF495D0`); each value (+0x23+row) indexes 19 entries (`FFF49826`): OFF, ALL 2/4/6/8/10/20/30/60 s, ALL CNT, BND 2 … 60 s, BND CNT | sender `0x63C4` → `sub_9C16` (body not decoded) |
| A9 | RINGER | 18 rows (`FFF49A15`): Mic-E … TX MSG; each OFF/ON | `sub_9C52` (body not decoded) |
| AA | UNIT | 7 rows (`FFF49B35`): POSITION `MM.MM'`/`MM'SS"`, DISTANCE km/mile, SPEED km/h/knot/mph, ALTITUDE m/ft, TEMP °C/°F, RAIN mm/inch, WIND m/s/mph | `0xFF8AAC` bits, `0xFF8AAD` (R2 n=0xC/0xD) |
| AB | TX DELAY | +0x20 ≤8 → 100/150/200/250/300/400/500/750/1000 ms (`FFF49BE0`) | `0xFF8ABD` (R2 n=0x1D, default 4 = 300 ms) |
| AC | BEACON INFO | AMBIGUITY OFF or `n digit` (n=1–4, `add #30h`); SPD/CSE OFF/ON; ALTITUDE OFF/ON | `0xFF8CF8`, `0xFF8CF9` b0/b1 (R2 n=0x258/0x259) |
| AD | BEACON INTERVAL | 20 entries (`FFF49DD9`): 30 sec, 1/2/3/5/10/15/20/30/60 min, 2/4/6/8/10/12/14/16/18/20 sec | `0xFF8ABC` (R2 n=0x1C, default 4 = 5 min) |
| AE | BEACON STATUS TEXT | S.TXT OFF/ON; TX RATE `1/1`..`1/8`; TEXT `Text 1`..`Text 5` | `0xFF8AB9/BA/BB` (R2 n=0x19–0x1B) |
| AF | BEACON TX | 0 MANUAL, 1 AUTO (icon `FFED31CC`), else SMART (`FFED31DC`) | `0xFFA90C` (work RAM, not in the persisted table) |
| B0 | COM PORT SETTING | 10 rows (`FFF49F45`): STATUS OFF/ON; SPEED 4800/9600/19200/38400; INPUT OFF/GPS; OUTPUT OFF/GPS/WAY.P/DSP H/DSP A/DSP D; WAYPOINT NMEA6–NMEA9 (`'6'+v`); Mic-E/POSITION/WEATHER/OBJECT/ITEM OFF/ON | `0xFF8C26`..`0xFF8C2A` (R2 n=0x186–0x18A) |
| B1 | DIGI PATH (select) | 2×4 grid P1..P8, selection +0x20 ≤7 | `0xFF8BE5` (R2 n=0x145, default 2) |
| B2 | DIGI PATH (edit) | 10-char title; up to 2 `AddressN` 9-char callsigns, or OFF; if +0x2A≠0, 8-slot editor `sub_FFF05622` | frame (`0xA2BE`) |
| B4 | GPS SETUP | DATUM 0 WGS-84 / 2 Tokyo (Mean) / **1 draws nothing** (`FFF06C4B`); PINNING OFF/ON; DGPS OFF/ON | `0xFF8BC8`, `0xFF8BCA` b0/b1 (R2 n=0x128/0x12A) |
| B5 | GPS POWER | GPS OFF / GPS ON | `0xFF8ABE` b6 (R2 n=0x1E) |
| B6 | GPS TIME SET | AUTO / MANUAL | `0xFF8AAB` b7 |
| B7 | GPS UNIT | POSITION `.MMM'`/`'SS"`; SPEED km/h/knot/mph; ALTITUDE m/ft | `0xFF8ABE` b0/b1, `0xFF8ABF` |
| B9 | MY POSITION (select) | 12 cells: GPS, Manual, P1..P9, P10 (+0x20 ≤0x0B) | `0xFF8AB8` (R2 n=0x18) |
| BA | MY POSITION (edit) | `LAT DD°MM.MM' N/S`, `LON DDD°MM.MM' E/W` (`4Eh/53h`, `45h/57h`), titled Manual / P10 / P n | frame (`0xA40E`) |
| BB | MY SYMBOL | 4 slots `1`..`4`, `(User)`, ICON row, symbol and overlay chars, sprites from RAM `0x68584`/`0x68658` | `0xFF8C1E` (R2 n=0x17E) |
| BC | POSITION COMMENT | 15 entries (`FFF4A1A6`): Off Duty, En Route, In Service, Returning, Committed, Special, Priority, Custom 0–6, EMERGENCY! | `0xFF8AA9` (R2 n=0x9) |
| BD | SmartBeaconing | rows STATUS / LOW SPD / HIGH SPD / SLOW RATE / FAST RATE / TURN ANGL / TURN SLOP / TURN TIME; STATUS OFF/TYPE1/TYPE2/TYPE3 (+0x23&3); speed unit km/h/knot/mph (+0x24 mod 3); units min/sec/°; STATUS=OFF hides rows 1–7 | `0xFF8BCC`, `0xFF8AAD`, `0xFFA90E..14` |
| BE | TIME ZONE | v=0..52: v≤25 → `UTC -hh` with hh = 13−(v+1)/2; v=26 → `UTC  00:00`; else `+`(v−26)/2. Minutes `:30` if v is odd (`FFF07E07 btst #0`). Range −13:00..+13:00 in 30-minute steps | `0xFF8BC9` (R2 n=0x129, default `0x2C` → +09:00) |

### 3. Item values — groups 0xA and 0xB (Confirmed)

| Code | Label | Values | MAIN |
| --- | --- | --- | --- |
| C0 / C1 | BACKUP / MEMORY CH | +0x20 cursor ≤2. List records of 0x12 bytes `{u16 mask BE, 16 chars}`: `Write to SD`/`Read from SD` (`FFF4A3F1`); in Japanese `SDに書き込み`/`SDから読み込み` (`FFF4A397`, masks `2AA0`/`2AA8`) | `0x6FCBA` (status bytes `0xFFB3F3..`) |
| C3 | (no label) | soft keys only; latches 4 file records | Not found (no `79 0x F3 C3` in MAIN `0..0x80000`) |
| C4 | MEMORY INFO | no frame values. `sub_FFF12B18` statistics feed a bar of used/total × 276.0 px (`FFF07F3D` `fmul #438A0000h`) and Used space / Free space / Capacity in MB with `,` grouping. Japanese labels 使用領域 / 空き容量 / 容量 | frame (`0xD28E`) |
| D0 | USB CAMERA | SIZE 320*240/160*120; QUALITY LOW/NORMAL/HIGH; SP SEL CAMERA/INT SP. Japanese labels `サイズ :` and `画質   :`; SP SEL stays English | `0xFF89CE`, `0xFF89CD`, `0xFF89C5` b1 (R1 n=0xAE/0xAD/0xA5); byte order Inferred |
| D2 | Bluetooth | OFF/ON. When ON: Connected / Not Connected / Connecting (Japanese 接続済み / 未接続 / 接続中), plus a 16-char device name; 6 help lines from RAM `0x69248` | `0xFF8920` b0 (R1 n=0x0) |
| D3 | DEVICE LIST | up to 5 paired names at +0x22+16i, 11 help lines from RAM `0x690F8`; label suppressed | frame (`0xD38C`) |
| D4 | Bluetooth Save | OFF/ON | `0xFF8920` b7 |

### 4. Japanese label path

**4.1 The flag (Confirmed).** In walker `sub_FFF0964A`:

```text
FFF09685  fb e2 72 8f 00 00   mov.l #8F72h,r14
FFF0968B  58 ee               movu.b [r14],r14
FFF0968D  61 1e               cmp   #1,r14
FFF0968F  21 31               bne.b FFF096C0      ; not 1 -> Japanese handlers
```

- 1 selects the English table. G3 already documented that path (`FFF09695`).
- Every value drawer that localises tests `[0x8F72]==0` for Japanese. Examples: `FFF0636C`,
  `FFF07E84`, `FFF08250`, `FFF05397`, `FFF087A1`.
- `0x8F72` has 43 code references (operand scan).

**Who writes `0x8F72`.** Only one store was found, at `FFEDF088`:

```text
FFEDF088  fb 12 46 8e 00 00   mov.l #8E46h,r1
FFEDF08E  b1 99               movu.b 7[r1],r1
FFEDF090  64 11               and   #1,r1
FFEDF092  fb e2 72 8f 00 00   mov.l #8F72h,r14
FFEDF098  c3 e1               mov.b r1,[r14]
```

So the flag is byte 7, bit 0 of the received MAIN frame (`0x8E46`). Bit 7 of the same byte is the
RAM DISPLAY gate (docs 08 and 23).

**MAIN side.** The shared frame header `sub_7C20` starts at `0x7C2E` with `fb 00` (`mov.b #0,r3l`)
and then:

```text
07C30  6a 10 89 c2 77 10   bld #1,@0xFF89C2
07C36  67 0b               bst #0,r3l          -> frame+7 bit 0
```

- The LANGUAGE item's sender stub `0x5310` sends the same bit as code **F315**:
  `6a 10 89 c2 77 10 67 0b … 79 0b f3 15 5e 00 97 6a`.
- **`0xFF89C2`** is R1 n=0xA2, EEPROM `0x622`, BACKUP.dat `0x4E2`.
- Default-init writes `0x20` there (`0E66A` `fc 20` / `0E66C` `6a 8c 89 c2`), which leaves bit 1
  clear, meaning Japanese.
- A conditional block then sets it: `0E832` `6a 18 89 c2 70 10` (`bset #1`), and `0E838` `72 50`
  (`bclr #5`). That block sits behind the `jsr sub_3ECB8` / `beq` at `0E80E`.
- **Inferred:** `sub_3ECB8` is the destination/market test that makes export units default to
  English.

**4.2 Structure (Confirmed).** There is no alternate table base. The Japanese branch
(`FFF096C0`..`FFF097AB`) is a compare chain on the group, and it calls one handler per group with
the row number:

| Group | Handler |
| --- | --- |
| 1 | `FFF097AF` |
| 2 | `FFF098CC` |
| 3 | `FFF09C73` |
| 4 | `FFF09E12` |
| 5 | `FFF0A108` |
| 6 | `FFF0A22A` |
| 7 | `FFF0A262` |
| 8 | `FFF0A309` |
| 9 | `FFF0A4DE` |
| 0xA | `FFF0A711` |
| 0xB | `FFF0A7B9` |
| 0xC | `FFF0A84B` |
| 0x15 | `FFF09944` |
| 0x16 | `FFF09A75` |
| 0x17 | `FFF09B88` |

- Groups 1, 4, 8 and 9 use s16 jump tables (`FFF482D0` ×9, `FFF482E2` ×14, `FFF482FE` ×22,
  `FFF4832A` ×28). The rest are compare chains.
- Each row draws literals, in one of three ways:
  - masked strings through `sub_FFEFA7E7`;
  - ASCII/kana strings through `sub_FFEF1B23`, which stops at NUL (`FFEF1B4F`);
  - single JIS glyphs through `sub_FFEF190D`. An example is MEMORY INFO: `メモリー` followed by
    glyphs `0x3E70` and `0x4A73`, which read 情報.

The strings live at `FFF4A512`..`FFF4AA4x`, right after the English value strings.

**4.3 Encoding (Confirmed).** `sub_FFEFA7E7` loops byte index i = 0..15 (`FFEFA919` `cmp #0Fh`)
and stops at NUL:

```text
FFEFA839  66 fe 41 0e 09   r14 = 15 - i
FFEFA83E  ba 89 fd 60 e1   r1 = mask >> r14 ; and #1      -> bit (15-i)
FFEFA877  ...fe c2 13 6c 83 55 23 01   code = s[i]<<8 | s[i+1]  (0xFFFF -> 0x2121)
FFEFA8A8  05 65 70 ff      bsr sub_FFEF190D(x,y,2,code)   ; 28/14 px advance, i += 2
FFEFA8FD  05 26 72 ff      bsr sub_FFEF1B23(...)          ; single byte, 0xFF -> ' '
```

- **Double-byte codes.** The 2-byte codes are JIS X 0208 row/cell with no high bit.
  `sub_FFEF2184` picks the first font record in `0xFFED4644` whose `base_code ≤ code`. Record 1 is
  `0x5021`, the JIS level-2 kanji; record 2 is `0x2121`, which covers symbols, kana and level 1.
- **Glyph proof.** Rendered glyphs show サ `0x2535`, 秒 `0x4943`, 画 `0x3268` and 質 `0x3C41`, each
  14×14 1-bpp, exactly as JIS assigns them.
- **Single-byte text.** It uses record 13 (selector `0x0D`, 7×14, base `0x20`, ordinal table
  `FFEC558A`):
  - `0x20`–`0x7E` are ASCII;
  - `0xA1`–`0xDF` are JIS X 0201 half-width katakana. `0xDF` is also used as the degree sign, as in
    `\xdfC` and `\xdfF`;
  - **`0xE0`–`0xF9` are a vendor block of precomposed voiced katakana**: ヴ ガ ギ グ ゲ ゴ ザ ジ ズ
    ゼ ゾ ダ ヂ ヅ デ ド バ ビ ブ ベ ボ パ ピ プ ペ ポ. These were identified by rendering each
    glyph; for example `0xF0` has the ハ shape with a dakuten;
  - `0xFA`–`0xFF` are empty.

So the Japanese strings are Shift-JIS-free. They are JIS X 0208 code points plus JIS X 0201
katakana, with an explicit per-string mask. Examples:

| Address | Bytes | Mask | Text |
| --- | --- | --- | --- |
| `FFF4A484` | `25 35 25 24 25 3A 20 3A` | `A800` | サイズ : |
| `FFF4A397` | `53 44 24 4B 3D 71 24 2D 39 7E 24 5F` | `2AA0` | SDに書き込み |
| `FFF4A512` (TX POWER, drawn at `FFF087B9`) | `Aw?.=PNO@_Dj` | `AAA0` | 送信出力設定 |
| `FFF4A560` (group 1, row 0) | `0LCV>pJsI=<(` | `AAA0` | 位置情報表示 |

**4.4 Coverage (Confirmed).** 117 Japanese label rows:
- 116 of them match the 116 English rows group for group (counts at `0xFFED74E8`);
- the extra one is group 0xB row 4, `RAM 表示`, the hidden RAM DISPLAY item (doc 08). It is drawn
  with mask `0A00`.

| Kind | Rows |
| --- | --- |
| contain JIS X 0208 kana or kanji | 48 |
| half-width or voiced katakana only | 53 |
| left in English | 16 (APRS AF DUAL, BEEP, TOT, DG-ID, Bluetooth, …) |

Group 0 has its own Japanese title: 送信出力設定 for TX POWER (`FFF087B9`, mask `AAA0`).

Value strings are localised only in some places:

| Value strings | Where |
| --- | --- |
| A4 MSG FLASH, 33 entries | `FFF491B0`, mask ladder `FFF053B9`..`FFF05428` |
| A8 POPUP, 19 entries | `FFF496D0`, per-value mask table `FFF49800` |
| AD BEACON INTERVAL, 20 entries | `FFF49C99`, mask `2000` |
| C0/C1 lists | `FFF4A397` |
| C4 labels | `FFF4A44E` |
| D0 labels | `FFF4A484`, `FFF4A4A6` |
| D2 status | `FFF4A4CF`/`D8`/`DF` |

All other group-9/A/B values are English in both modes.

### 5. Corrections to earlier docs

- **Doc 12 §(`FFEE80D9`) calls `0x8F72` "the password-feature state variable". That is wrong.**
  `0x8F72` is the language flag (§4.1). `sub_FFEE80A9` simply draws its Japanese variant when the
  flag is 0.
- **Doc 23 §5 says the other bits of frame+7 come from `0x8BCA`/`0x813E`.** The full map at
  `07C2E`..`07C6A` is:

  | frame+7 bit | Source |
  | --- | --- |
  | b0 | `0xFF89C2` b1 (language) |
  | b1 | `0xFF8ABE` b6 (GPS POWER) |
  | b2 | inverted `0xFFBBE0` b7 |
  | b3 | `0xFF8BCA` b0 |
  | b4 | `0xFF8BCA` b1 |
  | b6 | `0xFF813E == 0` |
  | b7 | `0xFF89C4` b4 (RAM DISPLAY) |

  All bytes are Confirmed. Which bit lands where on the SUB is Confirmed only for b0 (`FFEDF090`)
  and for b7 (doc 08).
- **G3 `f3xx-codes.tsv`** has no MAIN stub for F3A2, A5, A6, B0, B2, BA, BB and C1, because they
  are not in table `0x782C`. They do have senders: `05A42`, `0A276`, `0A29A`, `0634C`, `0A2BE`,
  `0A40E`, `0A54A` and `6FCEE` (`h7_main_senders.tsv`).

## USB relevance

- **No change to the three mission answers.** Everything here is SUB display and localisation for
  MAIN-originated settings frames.
- **COM PORT SETTING (B0)** is the only USB- or serial-adjacent item. It exposes STATUS,
  SPEED 4800–38400, INPUT OFF/GPS, OUTPUT OFF/GPS/WAY.P/DSP H/DSP A/DSP D and WAYPOINT NMEA6–9.
  These are MAIN settings (`0xFF8C26..2A`, EEPROM `C186..C18A`) for MAIN's serial/CDC path.
  - The SUB only draws them.
  - **Inferred:** they configure the MAIN CDC-ACM virtual COM port / DATA-jack output that BRIEF
    correction 1 describes. Nothing on the SUB side adds a USB endpoint or a sample path.
- **USB CAMERA (D0)** settings are SIZE, QUALITY and SP SEL (`0xFF89CD/CE`, `0xFF89C5` b1). That
  confirms it is the SUB JPEG/camera feature, with no streaming path.

## Open

1. **MAIN multi-byte senders.** Decode `sub_98CA`, `sub_9C16`, `sub_9C52`, `sub_9A54` and
   `sub_9BDA` to confirm which frame byte each RAM byte lands in (A8, A9, AC, AE, B0, B4, B7, BD,
   D0). The values are decoded; the byte order is Inferred.
2. **`sub_3ECB8`.** Confirm it is the market/destination test that sets English (`0E832`).
3. **FORMAT row (0xA row 3) and code C3.** Find which screen draws the SD FORMAT confirmation.
   C3's 4-record store suggests a file list.
4. **Number formatters.** `sub_FFEE1FCB` (BD parameter values) and `sub_FFEE1E8D` (MB with commas):
   pin down scaling, ranges and decimals.
5. **B4 DATUM value 1.** It draws nothing. Check whether MAIN can ever send 1, a removed
   "Tokyo (Japan)" option.
6. **Lane H6.** It can reuse `h7_jp_labels.py` and the `sb()`/`txt()` decoder in
   `h7_gen_tables.py` for any Japanese value strings in groups 1, 3, 5, 6 and 7.
