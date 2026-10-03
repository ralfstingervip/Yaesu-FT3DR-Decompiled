# 44 — SUB menu value-draw tables, groups 1, 3, 5, 6 and 7 (lane H6)

This is owner-side static analysis of the owner's FT3DR/FT3DE ver 1.02 images. The primary subject is `decrypted\FT3D_SUB_ver102_ALL.bin`: RX64M, little-endian, mapped at `0xFFC00000`, so file offset = address − `0xFFC00000`. MAIN (`decrypted\FT3D_MAIN_ver102_EXP.bin`: H8SX, base 0, big-endian) is read only to tie each SUB code to its sender and its settings byte. Nothing was written to any device, and no image was modified. Model: **Opus 5.5 (`claude-opus-5-5`)**.

Machine tables are in `ida\out\value-tables\`:

- `a-items.tsv` — one row per SUB code: group, row, label, F-code, MAIN row code, MAIN sender, SUB store handler, SUB draw entry, frame bytes, value format, settings RAM (with the doc-32 region/n/EEPROM/BACKUP/default), status and note. 32 rows: 28 menu rows, plus 4 codes that share a row.
- `a-options.tsv` — 124 rows. Each row is one raw value → displayed string or number, with the string address, the draw site and a reachability flag.
- Evidence listings:
  - `h6_draw-lin.txt`: linear decode of all five SUB draw regions.
  - `h6_stores.txt`: the dispatchers and store handlers.
  - `h6_sub2..4.txt`: the formatters and xrefs.
  - `h6_main-stubs.txt` and `h6_main2..4.txt`: the MAIN senders, frame builders and key-sequence machine.
- `ida\jobs\h6_gen_tables.py` writes both TSVs. Before writing, it **re-reads 155 cited byte runs** from the two `.bin` files and aborts on any mismatch. The last run passed: `checks ok: 155; items 32; options 124`.

## Verdict

All 28 menu rows of groups 1 (DISPLAY), 3 (MEMORY), 5 (SCAN), 6 (DP-ID) and 7 (WIRES-X) are accounted for:

- **26 rows have a value page, and it is fully decoded.** That covers every option string with its address, every numeric scale (units, step, clamp, padding) and the frame byte behind it.
- **2 rows have no value page at all** (Confirmed by the dispatchers):
  - **MEMORY NAME** (`0x32`): no SUB store case, no draw case, and no MAIN sender anywhere in the image.
  - **DP-ID LIST** (`0x64`): MAIN sends `[FF8DD7]`, but SUB neither latches nor draws it.

For 25 of the 26 rows, the value is tied to a MAIN sender and to a RAM byte or bit, or a MAIN data source.

Evidence-backed hidden or unreachable values:

1. **Code `0x16` (F316) is an unlisted 15-step "LEVEL 1..15" item.**
   - Its MAIN row code `0x41` is in no menu row list.
   - The SUB has no label for it; the title falls back to row 4, LANGUAGE.
   - Settings byte: `FF89A9` − `0x13`, default `0x19` → LEVEL 7.
   - Path Confirmed; "hidden" Inferred.
2. **The "(WIRES-X)" suffix on the DG-ID page is unreachable.** The only MAIN caller of builder `0xA07C` hard-codes the flag byte to 0 (`0x05E954` `f3 00`). Confirmed.
3. **SOFTWARE VERSION has a hidden extended mode.**
   - It shows two extra version digits (e.g. `1.0200` instead of `1.02`) only when `FFBC8A` bit 0 is set.
   - Only an 8-step key-sequence state machine at MAIN `0x01494C`–`0x014AA6` sets that bit (`0x014A62` `6a 18 bc 8a 70 00`).
   - Path Confirmed; the key sequence itself is Inferred.
4. **Two Japanese LAMP table slots are dead:** `FFF486E1` "OFF" and `FFF48709` "CON". Branches handle values 0 and 10 before the table is used. Confirmed.

## Method

- **Private databases**, both created via `run_job.py --copy-from` (copy only) and iterated with `--reopen`. Every run exited 0 and no `h6_dump_error.txt` was written.
  - `H6_SUB`, seeded from `ida\db\jobs\G3_SUB\G3_SUB.i64`.
  - `H6_MAIN`, seeded from `ida\db\jobs\G1_H8S\G1_H8S.i64` (`h8sxa`). It was used only to read the MAIN senders.
- **Dumper.** `ida\jobs\h6_dump.py` is G3's `g3_dump.py` with paths moved to `ida\out\value-tables\`, plus a `range` command (linear decode `a..b`). It provides `func`, `lin`, `range`, `imm` and `xref`.
- **SUB scope covered:**
  - the five group dispatchers named in G3: `FFF00684` (g1), `FFF01D02` (g3), `FFF0324E` (g5), `FFF0381A` (g6), `FFF03AD8` (g7), and their whole case bodies, linearly decoded `FFF006BD`–`FFF0104F`, `FFF01C0B`–`FFF01F70`, `FFF03281`–`FFF0381A`, `FFF0381A`–`FFF04090`;
  - the five store handlers `FFEFE727`, `FFEFECA4`, `FFEFF4E5`, `FFEFF68A`, `FFEFF710`;
  - the number formatters `sub_FFEE1CE5`/`1D6D`/`1DE8` and the scan-resume formatter `sub_FFF030D5`;
  - the two jump tables `FFF481DA` (g1, 11 × s16, relative to `bra.l` at `FFF006BB`) and `FFF48226` (g5, 6 × s16, relative to `FFF0327F`).
- **MAIN scope:**
  - every `79 0x F3 1x/3x/5x/6x/7x` immediate in the image (32 hits; `mscan` in the scratch run);
  - each sender stub and frame builder, and the byte and word senders `sub_976A`, `sub_9792`, `sub_98CA`, `sub_9922`;
  - the list-fill callers of the builders.
- **Settings bytes** are taken from `ida\out\settings\settings-bytes.tsv` (doc 32).
- **Not done:**
  - the Japanese label path and groups 9–11; these belong to sibling lane H7;
  - the MAIN writers of record `+0x50`/`+0x51` (SCAN WIDTH);
  - the key codes the `0x01494C` state machine expects;
  - the meaning of `F31A`'s byte `FF89B6`.

## Findings

### F1. Frame layout and senders (Confirmed)

**The frame.** MAIN builds the frame at `0xFF3D72`:
- `+0` is the length word;
- `0xFF3D74` holds `F3 cc`;
- `0xFF3D94` = frame `+0x20`.

The SUB latches the same frame at `0x8C4D` (doc 38 A1). So MAIN `0xFF3D94+k` ↔ SUB `0x8C6D+k`.

**The four generic senders:**

| Sender | Bytes sent |
| --- | --- |
| `sub_976A` (`0x976A`) | 1 byte: `r3l` → `+0x20` (`0x9784` `7a 06 00 ff 3d 94 68 eb`) |
| `sub_9792` | `+0x20` = `!(FFAD9D & 1)`, `+0x21` = `+0x20` − (`FFAD68`≠0), `+0x22/23` = word `[FFB05A]` (`0x97CC` `6b 04 b0 5a 6b a4 00 ff 3d 96`) |
| `sub_98CA` | the same two flag bytes, then 3 bytes from `FFB05A` |
| `sub_9922` | the same two flag bytes, then 4 bytes from `FFB05A` |

**What the SUB does with the flag bytes.** It uses `+0x20` and `+0x21` only to place the edit cursor: x = 6 or `0x6E`, y = `0x41`, `0x65` or `0x89`. Inferred: these are edit-mode and selected-line flags.

### F2. Group 1 — DISPLAY (dispatcher `FFF00684`, `add #-11h` / `61 a1` cmp #0Ah, table `FFF481DA`)

| Row | Code / F | Value page (Confirmed) | MAIN source |
| --- | --- | --- | --- |
| 0 TARGET LOCATION | 0x11 / F311 | `+0x20`: 0 **COMPASS** `FFF486A4` / else **NUMERIC** `FFF486AC` | `FF89C5` b0 (`0x59F8` `6a 10 89 c5 77 00`) |
| 1 COMPASS | 0x12 / F312 | 0 **NORTH UP** `FFF486B4` / else **HEADING UP** `FFF486BD` | `FF8ABE` b7 (`0x5938`) |
| 2 BAND SCOPE | 0x13 / F313 | clamp ≥3→2 (`FFF00785` `61 31`); `FFF486C8` stride 5 (`63 53`): **19 CH / 39 CH / 79 CH** | `FF89B9`, default 1 = 39 CH |
| 3 LAMP | 0x14 / F314 | KEY = `+0x22` mod 11 (`FFF007E4` `fd 74 9e 0b`). EN table `FFF4870D` × 10 B: **OFF, 2, 3, 6, 10, 20, 30, 60, 120, 180 sec, CONTINUOUS**. SAVE `+0x23`: **OFF/ON** (`FFF00960` `59 ee 23`) | KEY: `FF89AA` sent as 10→0, n→n+1 (`0x532C` `ac 0a`, `0x5330` `0a 0c`), so raw 0..8 = 2..180 s, 9 = CONTINUOUS, 10 = OFF; default 5 = 30 s. SAVE: `FF89C5` b7 |
| 4 LANGUAGE | 0x15 / F315 | 0 **JAPANESE :** `FFF4878A` + JIS `46 7C 4B 5C 38 6C` (日本語) / else **ENGLISH  :** `FFF4879C` + `31 51 38 6C` (英語) | `FF89C2` b1 (`0x5310`) |
| (4) — | 0x16 / F316 | clamp ≥15→14 (`FFF00A8F` `61 f1`), +1 → **LEVEL 1..15** ("LEVEL" `FFF487B0`) | `FF89A9` − `0x13` (`0x534C` `6a 0b 89 a9 fc 13 18 cb`); default `0x19` → 7. **Unlisted (Inferred hidden)** |
| 5 LCD DIMMER | 0x17 / F317 | clamp ≥6→5 (`61 61`), +1 → **LEVEL 1..6** (`FFF487BC` template) | `FF89A4`, default 5 = LEVEL 6 |
| 6 OPENING MESSAGE | 0x18 / F318 | `+0x20`: 0 **OFF**; 1 **DC** : 10 chars @`+0x21`; 2 **MESSAGE** : 16 chars @`+0x33` (attr `+0x31`) + PUSH/DISP hints; 3 **CALLSIGN** : 10 @`+0x43` + 10 @`+0x4D`; ≥4 draws nothing | mode `FF8955` (`0x54C8`, default 1 = DC); message `FF8956` (`0x54F6`); callsign `FF8D26` (`0x550E`); builder `0x9C8E` |
| 7 SENSOR INFO | 0x19 / F319 | **VOLT** `FFF487E5` ":" + 10 chars @`+0x20` (JP: JIS `0x4545 0x3035` 電圧) | voltage text, builder `0x9CB2` (template ROM `0x89B0`, digits of `[FFA9C0]`) |
| (7) — | 0x1A / F31A | **not drawn**: jump-table slot → `FFF0104D` `67 43` (rtsd) | `FF89B6` (`0x56E6`); latched by `FFEFE727` |
| 8 SOFTWARE VERSION | 0x1B / F31B | 3 lines: `Main Ver.` `FFF487EC`, `Sub  Ver.` `FFF48800`, `DSP  Ver.` `FFF48814`, each `X.YY[ZZ]` | builder `0x9CF4`: see F7 |

### F3. Group 3 — MEMORY (dispatcher `FFF01D02`, compare chain `75 51 35/31/33/34/30`)

| Row | Code / F | Value page (Confirmed) | MAIN source |
| --- | --- | --- | --- |
| 0 BANK LINK | 0x30 / F330 | `sub_FFF01C0B` list (mode 1). Each row is `nn` (= `+0x20` + i, space-padded), the name (16 chars, attr word), and a link box when entry `+0x12` == 1 (`FFF01CCD` `b4 91`). Scrollbar: position `+0x21`−1, 5 visible, **total `0x18` = 24 banks** (`FFF01D66` `f8 04 18`) | list fill `0x4EE4` (`fc 13` → stride `0x13`, callback `0x4F38`) → builder `0x9DBC` |
| 1 BANK NAME | 0x31 / F331 | the same list without the link box (5 × `0x12` entries re-packed to stride `0x13`) | `0x4F96` (`fc 12`, callback `0x4FEA`) → `0x9DE0` |
| 2 MEMORY NAME | 0x32 | **no value page**: no case in `FFF01D02` or `FFEFECA4`, and MAIN has no `F332` sender (whole-image scan) | — |
| 3 MEMORY PROTECT | 0x33 / F333 | **OFF / ON** | `FF89C1` b2 (`0x53AE` `6a 10 89 c1 77 20`) |
| 4 MEMORY SKIP | 0x34 / F334 | clamp ≥3→2: **OFF / SKIP** `FFF489D0` + icon `FFECF18C` / **SELECT** `FFF489D5` + icon `FFECEE9C` | channel record `+0x07` & `0x0C`: 0→0, 4→1, 8 or C→2 (`0x575C`) |
| 5 MEMORY WRITE | 0x35 / F335 | **LOWER** `FFF489DC` / **NEXT** `FFF489E2` | `FF89C1` b0 (default `0x11` → NEXT) |

### F4. Group 5 — SCAN (dispatcher `FFF0324E`, `add #-50h` / `61 51`, table `FFF48226`)

| Row | Code / F | Value page (Confirmed) | MAIN source |
| --- | --- | --- | --- |
| 0 DW TIME | 0x50 / F350 | **28-step scale**, v = min(v, 27) (`75 51 1c` → `1b`):<br>• v ≤ 8 → `0.`(v+1): 0.1–0.9 s;<br>• 9..26 → `(v−7)/2 . (0 or 5)`: 1.0–9.5 s in 0.5 s steps;<br>• 27 → `10`.<br>Suffix " sec" (EN, bytes `20 73 65 63`) or JIS `0x4943` 秒 (JP, `75 4f 49`/`43`) | `FF89AF`, default `0x11` → **5.0 s** |
| 1 SCAN LAMP | 0x51 / F351 | **OFF / ON** (shared drawer `FFF03408`) | `FF89BE` b5 (default ON) |
| 2 SCAN RE-START | 0x52 / F352 | the same 28-step scale as DW TIME (shared `FFF03281`) | `FF89B2`, default `0x0B` → **2.0 s** |
| 3 SCAN RESUME | 0x53 / F353 | "SCAN :" `FFF48E2D` (`+0x22`) and "DW   :" `FFF48E34` (`+0x23`), each formatted by `sub_FFF030D5` with v = min(v, 18):<br>• 0..15 → 2.0–9.5 s in 0.5 s steps (`68 11` shlr, `71 11 32` +'2');<br>• 16 → 10.0 s;<br>• 17 → **BUSY** `FFF48E28`;<br>• 18 → **HOLD** `FFF48975` | SCAN `FF8990` (default 6 → 5.0 s), DW `FF8991` (default `0x12` → HOLD), via `sub_9792` (`0x56C2`) |
| 4 SCAN WIDTH | 0x54 / F354 | VFO `+0x22`: 3 **BAND**, 4 **ALL**. MEMORY `+0x23`: 3 **BAND**, 4 **ALL CH**. BANK LINK `+0x24`: **OFF/ON**. Any other raw value draws a blank (`FFF03513` `61 3e`, `FFF03533` `61 4e`) | record `+0x50`/`+0x51`, plus `FF89C5` b6, via `sub_98CA` (`0x569E`) |
| 5 PRIORITY REVERT | 0x55 / F355 | **OFF / ON** | `FF89C3` b0 (default OFF) |

### F5. Group 6 — DP-ID (dispatcher `FFF0381A`: only `75 51 65` and `75 51 63`)

| Row | Code / F | Value page | MAIN source |
| --- | --- | --- | --- |
| 0 DP-ID LIST | 0x64 / F364 | **none**. Store `FFEFF68A` and draw `FFF0381A` handle only `0x63` and `0x65` (Confirmed) | `FF8DD7` (`0x5E95C`), default 1 — sent but never shown |
| (0) — | 0x65 / F365 | full-page view, label suppressed (`FFF0052E` `75 51 65` / `20 76` → skip walker):<br>• "DG-ID TX  :" `FFF48E93` + `+0x25`;<br>• "DG-ID RX  :" `FFF48E9F` + `+0x24`;<br>• 2-digit zero-padded, 00–99;<br>• cursor `+0x21` clamped to ≤2 | `0x5E96A` → `sub_9922`: `+0x24/+0x25` = `FF8ED8/9` if `FF8EA0` b6, else `FF8ED6/7`. `+0x22/+0x23` = `FF8DD8/9` are latched but not drawn |
| 1 RADIO ID CHECK | 0x63 / F363 | "RADIO ID : " `FFF48E87` + 5 chars @`+0x20` | `0x5990`: `sub_59CA` checks the 5 chars at `FF8060` against 0-9/A-Z/a-z; otherwise it sends ROM `"?????"` (`0x59C4` `3f 3f 3f 3f 3f`) |

### F6. Group 7 — WIRES-X (dispatcher `FFF03AD8`, chain `76/72/73..74/75/71`)

| Row | Code / F | Value page (Confirmed) | MAIN source |
| --- | --- | --- | --- |
| 0 RPT/WIRES FREQ | 0x71 / F371 | `+0x21`:<br>• 0 → **MANUAL** `FFF48A69`;<br>• 1 → **PRESET** `FFF48EAB` ": " + 9 BCD nibbles from `+0x22` (`sub_FFF03948`, `66 93`; leading zeros blanked, '.' after the 3rd digit) + **MHz** `FFF48EB2`;<br>• ≥2 → nothing | `0x69ADA` → `0x9F9C`: `+0x20` = `FFB380` b0, `+0x21` = `[FF8D90]`, `+0x22..25` = `FFB386..`, `+0x26..27` = ROM `0xC41C` (`00 00`) or `0xC41E` (`02 f0`) |
| 1 SEARCH SETUP | 0x72 / F372 | **HISTORY** `FFF48EB6` / **ACTIVITY** `FFF48EBE` | `FF8D8F` (`0x5E9C6`) |
| 2 EDIT CATEGORY TAG | 0x73 / F373 | 5 rows of 16 B at `+0x21`+16i, drawn by `sub_FFF03652` mode 2, base 1 (`66 23`): **C1..C5** + tag text (`'C'` = `f9 04 2b 43`) | list fill `0x6ED0C` (callback `0x69F4C`) → `0xA010` |
| 3 REMOVE ROOM/NODE | 0x74 / F374 | as 0x73 (C1..C5) | `0x6ED76` → `0xA034` |
| (3) — | 0x75 / F375 | `sub_FFF03652` mode 0, base 0: names without a prefix | `0x6EDB4` (callback `0x69F9E`) → `0xA058` |
| 4 DG-ID | 0x76 / F376 | "DG-ID: " `FFF48EC7`; `+0x20`: 0 → **AUTO** `FFF4883A`, else **nn** (01–99); `+0x21`≠0 → **"(WIRES-X)"** `FFF48860` | `0x5E944`: `+0x20` = `[FF8D24]` (default 0 = AUTO), `+0x21` = **0 always** |

`sub_FFF03652` modes 1, 3 and 5 (5 = the `G1..G5/B1..B3` table at `FFF48E6F`) are reached from group 9/10 callers (`FFF05C38`, `FFF05CD3`, `FFF07EAA`, `FFF07EC7`). They are lane H7's scope and are not dead.

### F7. SOFTWARE VERSION and the hidden extended-digit mode

**Builder `0x9CF4` fills the frame** (Confirmed):
- `+0x20` = `FFBC8A` b0 (`0x9D18`);
- `+0x21..+0x23` = immediates **1, 2, 0** (`0x9D2E` `fc 01`, `0x9D38` `fc 02`, `0x9D42` `fc 00`);
- `+0x24..+0x26` = `FF813F..41` (3 B, the SUB version);
- `+0x27..+0x28` = `FFB0DC..DD` (`0x9D62`). That is the DSP version word that MAIN stores at `0x056A0C` `6b 84 b0 dc` (doc 06).

**SUB `FFF00ED1` renders each line as follows:**
- `X` = 2-char space-padded decimal (`sub_FFEE1DE8`);
- `YY` and `ZZ` = 2-digit zero-padded (`sub_FFEE1D6D`);
- the length is `0x13` (`FFF00EFB` `3c 01 13`), minus 2 when `+0x20` == 0 (`FFF00FED` `60 21`).

So the normal display is `Main Ver. : 1.02`. With the flag set it is `1.0200`, and the DSP line becomes `hi.lo00`.

**How the flag gets set.** `FFBC8A` b0 is set only at `0x014A62`, inside an 8-step key-sequence machine:
- **Entry `0x01494C`.** The machine starts only when all of these hold: `btst #3,@FF89C1` (default `0x11` sets that bit), `btst #7,@FFBC8A` (that bit is clear) and screen byte `@(1,er0)` == `0x0C`.
- **Which sequence is armed.** The value of `[FF8F2E]` ∈ {0, 5, 8, 10} sets bit 4, 3, 5 or 6 of `FFBC8A`, and the counter `FFBC8B` starts at 8.
- **Key checks.** `0x149D2`..`0x14A34` compare the expected key codes per step. A wrong key clears b0 (`0x014A96` `6a 18 bc 8a 72 00`).
- **Completions.** The bit-4 sequence sets b0, i.e. the extended version digits. The other three do something else: bit 3 → `FFB0C8`=1, bit 5 → `sub_1645E`, bit 6 → `sub_16456`.

Status: Confirmed for the bytes, Inferred for "key sequence". The key codes and the meaning of the other three completions are Unknown here.

### F8. Hidden, dead or unreachable values (evidence only)

| What | Evidence | Status |
| --- | --- | --- |
| F316 / code 0x16 "LEVEL 1..15" | MAIN row code `0x41` (sender `0x534C`) is in no menu row list (doc 32/38). Its only reference is the row-code table slot `0x7930` = `0x782C` + 4·`0x41` (BE32 `0000534c` occurs once). SUB row mapping gives it the LANGUAGE title. A full value scale is drawn | path C, hidden I |
| "(WIRES-X)" on DG-ID | Builder `0xA07C` has a single xref, `0x5E956`. A whole-MAIN raw scan agrees: `5e 00 a0 7c` occurs once, and BE32 `0000a07c` occurs 0 times. The caller loads `f3 00` (r3h = 0) and `0xA0AA` `0c 3b` stores r3h → `+0x21` | C (unreachable on this page; the string is still used at `FFF013F5`) |
| Extended version digits | `FFBC8A` b0 is only set at `0x014A62` (key-sequence completion) | C/I |
| JP LAMP table slots `FFF486E1` "OFF" and `FFF48709` "CON" | Values 0 and 10 branch away at `FFF00826`/`FFF00851` before the table index | C (dead slots) |
| DP-ID LIST value `FF8DD7` | sent by `0x5E95C` but not latched or drawn by screen `0x1F` | C |
| F31A value `FF89B6` | latched, but the jump-table slot is `rtsd` | C |
| SCAN WIDTH VFO/MEMORY raw 0–2, ≥5; OPENING MESSAGE ≥4; RPT/WIRES mode ≥2 | draw a blank or nothing | U (MAIN writers not traced; no evidence that these values occur) |

### F9. Hand C for the two numeric time scales (Confirmed from `FFF03281` and `FFF030D5`)

```c
/* DW TIME (0x50) and SCAN RE-START (0x52): FFF03281 */
static void fmt_dw(char *s, unsigned v) {
    if (v >= 28) v = 27;                                    /* 75 51 1c; mov.b #1Bh */
    if (v <= 8)        sprintf(s, "0.%c", '1' + v);         /* 0.1 .. 0.9            */
    else if (v == 27)  strcpy(s, " 10");
    else               sprintf(s, "%c.%c", '0' + (v - 7) / 2, (v - 7) % 2 ? '5' : '0');
    strcat(s, jp ? "\x49\x43" /* JIS 0x4943 '秒', attr 0x1000 */ : " sec");
}
/* SCAN RESUME (0x53), SCAN and DW fields: sub_FFF030D5 */
static void fmt_resume(char *s, unsigned v) {
    if (v >= 19) v = 18;
    if (v == 17) { strcpy(s, "BUSY"); return; }             /* FFF48E28 */
    if (v == 18) { strcpy(s, "HOLD"); return; }             /* FFF48975 */
    if (v == 16) strcpy(s, "10.0");
    else         sprintf(s, " %c.%c", '2' + v / 2, (v & 1) ? '5' : '0');   /* 2.0 .. 9.5 */
    strcat(s, jp ? "\x49\x43" /* attr 0x800 */ : " sec");
}
```

### F10. Item counts

| Group | Menu rows | Value page decoded | No value page (Confirmed) | Extra codes (no own row) |
| --- | --- | --- | --- | --- |
| 1 DISPLAY | 9 | **9** | 0 | 0x16 (decoded, hidden), 0x1A (not drawn) |
| 3 MEMORY | 6 | **5** | 1 (MEMORY NAME) | — |
| 5 SCAN | 6 | **6** | 0 | — |
| 6 DP-ID | 2 | **1** | 1 (DP-ID LIST) | 0x65 DG-ID TX/RX page (decoded) |
| 7 WIRES-X | 5 | **5** | 0 | 0x75 (decoded) |
| **Total** | **28** | **26** | **2** | 4 extra codes |

## USB relevance

**No change to the three mission answers.** These pages are MAIN→SUB display notifications on the inter-processor SCI. The SUB latches the frame at `0x8C4D` and draws it. It touches no peripheral, no USB block and no flash.

The single item that bears on mission question 3 (the DSP) is the SOFTWARE VERSION page:
- The displayed DSP version is the word at MAIN `FFB0DC`, copied into frame `+0x27/+0x28`.
- It is shown as `hi.lo`, i.e. two decimal bytes, with an optional `00` extension.
- This confirms doc 06's `0x9F` VER-response path end to end, as far as the screen. It does not expose the DSP itself.

## Open

1. **Decode the key sequence of the state machine at MAIN `0x01494C`–`0x014AA6`.**
   - Work out the expected key code per step, and where the screen byte `@(1,er0)` = `0x0C` and `[FF8F2E]` come from.
   - Name the other three completions: `FFB0C8`=1, `sub_1645E`, `sub_16456`. This is the most promising hidden-mode lead in this lane.
2. **Find MAIN writers of channel record `+0x50`/`+0x51`** (SCAN WIDTH), to settle whether raw values 0–2 ever occur. Do the same for OPENING MESSAGE mode ≥4 and RPT/WIRES mode ≥2.
3. **F316 / row code `0x41`:** find any path that dispatches row code `0x41` (a service menu?) to decide whether "LEVEL 1..15" is reachable. Identify what `FF89A9` controls.
4. **F31A `FF89B6`** (latched, not drawn), and whether DP-ID LIST `FF8DD7` is shown on a screen other than `0x1F`.
5. **Decode the JIS X 0201 + vendor glyph strings** `FFF486D7` (`b7 2d` = ｷｰ) and `FFF487AC` (`da f3 d9`, presumably ﾚﾍﾞﾙ with vendor glyph `0xF3`). Lane H7 owns the JP path.
