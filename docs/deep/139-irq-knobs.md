# 139 — Which control is on IRQ7 and IRQ10 (lane N12)

> Lane N12, model `claude-opus-5-5`. This is owner-side static analysis of `decrypted\FT3D_MAIN_ver102_EXP.bin`
> (H8SX, big-endian, base 0, file offset = address) and `decrypted\FT3D_SUB_ver102_ALL.bin` (RX, little-endian,
> file offset = address − `0xFFC00000`). Nothing was connected to a radio and no image was changed. Both images
> hash to sha256 `8e3ecd05…` / `b93570b3…`; `n12_verify.py` checks this at the start and at the end.
> The lane used its private DB `N12_IRQ`, opened with `--copy-from ida\db\jobs\M1_MAIN_FINAL6\M1_MAIN_FINAL6.i64`
> and then `--reopen` only. It opened no other database and edited no published mask, seed or owning doc.

Tables are in `ida\out\irq-knobs\`:

| File | Content |
| --- | --- |
| `findings.tsv` | 13 findings, each with its status, address and bytes |
| `n12_verify.py` / `verify.tsv` | Re-reads all 63 cited byte runs and both hashes, and re-derives the sprite geometry: **66/66 PASS** |
| `mask.tsv` | The cited MAIN ranges checked against the FINAL7 masks: 1,214 B, all named |
| `n12_render.py` / `sprite_FFED0A8C.png` | Renders the SUB sprite that the DIAL KNOB CHANGE screen draws, at 4× scale (magenta = transparent key) |
| `work\req*.txt`, `work\out*.txt` | The IDA requests and listings quoted here (job `ida\jobs\n12_dump.py`, a copy of M11's read-only dumper) |

## Verdict

**IRQ7 and IRQ10 are the two halves of the radio's dual concentric knob.**

Both handlers are quadrature decoders, and setup item **DIAL KNOB CHANGE** (`FF89B5`, F396) decides which
one acts as DIAL and which as VOL. The SUB screen for that item draws the knob and puts a label next to each
part.

**Function (Confirmed).** The firmware's own strings name what each IRQ does:

- At the factory default `FF89B5 = 1`, **IRQ10 is "DIAL"** (key event 13) and **IRQ7 is "VOL"**.
- At value 0 the two swap.

**Physical part (Inferred, strong).** The screen shows a small upper knob sitting on a wide lower ring:

- At value 1, the label "DIAL" is drawn level with the small upper knob and "VOL" level with the wide ring.
- At value 0 the labels are reversed, and the MAIN latch roles reverse with them.
- So **IRQ10 (pin P62) is the small upper/inner knob** and **IRQ7 (pin P17) is the wide lower/outer ring**,
  whichever setting is chosen.

**What each function drives.**

- The VOL function steps a per-band level, record `+0x6C`, through 0–31.
- That level goes through a 32-entry audio-taper table into channels 2 and 3 of an 8-channel serial DAC.
  `sub_3490` bit-bangs that DAC on `PBDR` (`FFFF5A`).
- That chain is Confirmed in code. The label "AF volume" is Inferred.

**Byte credit.** Named delta **0**, proven delta **0**. All 1,214 cited MAIN bytes are already named in
`final7_named_mask.bin`.

## Method

- **IDA.** Six passes of `ida\jobs\n12_dump.py` ran on `N12_IRQ`:
  - the first was `--copy-from` the MAIN seed;
  - every later pass used `--reopen`;
  - the script is read-only (`dis`, `func`, `xref`, `callers`, `refrange`) and ends with `qexit(0)`.
- **What the passes covered:**
  - the vector table `0x000`–`0x3FF`;
  - the IRQ3/7/10/11 and TGI5A handlers;
  - the init sequence `0x002370`–`0x002420` and the standby re-arm `sub_284E`;
  - the key scan `0x00FB00`–`0x00FC66`;
  - every abs16 xref to `FF8170`, `FF8171`, `FF817F`, `FF94B9`, `FFBBE3`, `FFAA38`, `FFA9EE`, `FF89B5`,
    `FFFD68`, `FFFD6A`, `FFFF34`;
  - the AA38.b6 consumer chain `sub_1079E` → `sub_10A30` → `sub_1E744` / `sub_1E840` / `sub_1E7C2` /
    `sub_1E80A`;
  - every operand reference in `FFA998`–`FFA99D`, and the DAC writer `sub_3490`.
- **SUB (no database opened; the lane has one DB, and it is MAIN):**
  - Plain-Python search of the whole 4 MB image for `DIAL`, `VOL`, `KNOB`, `ENCODER`, and for the LE32 addresses
    of the two option strings. `0xFFF491A7` was found at `FFF052F1` and `FFF05329`; `0xFFF491AB` at `FFF05303`
    and `FFF05317`.
  - The F396 value-draw case `FFF052D7`–`FFF0533E` was decoded by hand. G3's
    `ida\out\sub-labels\f3xx-codes.tsv` row F396 gives the entry `FFF052D7`.
  - Existing listings were reused for the draw primitives: `ida\out\sub-upper\blit_chain.txt` (blit `sub_FFEF0648`)
    and `ida\out\sub-layout\renderers.txt` (string renderer `sub_FFEFA7E7`, glyph blit `sub_FFEF190D`). The
    renderer's call into the glyph blit, `FFEFA894`–`FFEFA8AB`, was hand-decoded.
- **Sprite.** Descriptor `0xFFED0A8C` was decoded with doc 16's layout (`w, h, src, key, tint, mode`, RGB565 LE)
  and rendered by `n12_render.py`.
- **Not done:**
  - No datasheet pin table was available. "P17 = IRQ7" and "P62 = IRQ10" are Inferred: from the code, which
    samples exactly those bits to seed each IRQ's edge sense, and from pc-07's register map, which identifies the
    part.
  - The IRQ pin-select register (ITSR) was not searched.
  - The meaning of the IRQ7 gate `FF817F.b0` was not resolved.
  - The physical rotation sense (which way is "up") is hardware-only.

## Findings

### 1. Vectors and enable (Confirmed)

| Slot | Bytes | Handler | Source |
| --- | --- | --- | --- |
| 71 | `0x00011C 00 00 29 ca` | `sub_29CA` | IRQ7 |
| 74 | `0x000128 00 00 2a 60` | `sub_2A60` | IRQ10 |
| 75 | `0x00012C 00 00 2a 1e` | `sub_2A1E` | IRQ11. It clears the flag, masks interrupts and jumps to `0x2050`. This is the standby wake, not a knob. |

- **Normal enable:** `IER = 0x0480` (IRQ10 + IRQ7), written at `0x0023DA 79 04 04 80 6b 84 ff 34`.
- **Software standby** (`sub_284E`, `0x002874 79 04 08 08 6b 84 fb ce 79 04 08 08 6b 84 ff 34`): `SSIER` and `IER`
  are both set to `0x0808` (IRQ11 + IRQ3). Both knob IRQs are off, so **turning either knob cannot wake the
  radio**.

### 2. Pins and edge seeding (code Confirmed; pin names Inferred)

`sub_20FA` (the init routine) clears the latches, edge state, gate and debounce:
`0x002382 fc 00 6a 8c 81 71 6a 8c 81 70 6a 8c 81 7e 6a 8c 81 7f 6a 8c 94 b9`. It then seeds each IRQ to fire
on the next transition of its own pin:

| IRQ | Pin sampled | Code | Sense register | Input buffer | Pin (Inferred) |
| --- | --- | --- | --- | --- | --- |
| 7 | `PORT1 FFFF40` b7 | `0x002398 79 03 40 00 2c 40 ec 80 46 0a 79 03 80 00 6a 18 81 70 70 00 6b 83 fd 6a` | `ISCRL` b15:14. High: `01` (falling). Low: `10` (rising), and `8170.b0 = 1`. | `0x0023B0 fc 80 6a 8c fb 90` (`P1ICR = 0x80`) | **P17** |
| 10 | `PORT6 FFFF45` b2 | `0x0023B6 79 03 00 10 2c 45 ec 04 46 0a 79 03 00 20 6a 18 81 70 70 10 6b 83 fd 68` | `ISCRH` b5:4, with the same rule, using `8170.b1` | `0x0023CE fc 04 6a 8c fb 95` (`P6ICR = 0x04`) | **P62** |

### 3. The two ISRs are quadrature decoders (Confirmed)

**IRQ7, `sub_29CA`:**

1. Clears `ISR` b7 (`0x0029CA 6d f4 6b 04 ff 36 72 7c 6b 84 ff 36`).
2. Only if `FF817F.b0` is set and the debounce `FF94B9 == 0` (`0x0029D6 6a 10 81 7f 73 00 47 2a 6a 0c 94 b9 46 24`):
   - reads `PORTF FFFF4E` b3;
   - stores `0x81` in `FF8171` when b3 equals `8170.b0`, and `0x80` otherwise (`0x0029E4 2c 4e … fc 80 40 02 fc 81`);
   - re-arms the debounce at 4 (`0x0029FE 6a 8c 81 71 fc 04 6a 8c 94 b9`).
3. **Always** inverts both `ISCRL` IRQ7 bits and `8170.b0`
   (`0x002A08 6b 04 fd 6a 71 74 71 64 6b 84 fd 6a 6a 18 81 70 71 00 6d 74 56 70`).

**IRQ10, `sub_2A60`:**

1. Clears `ISR` b10 (`0x002A62 6b 04 ff 36 72 24`).
2. Has **no gate and no debounce**.
3. Compares `PORTF` b1 with `8170.b1` (`0x002A6C 2c 4e 6a 10 81 70 73 10 …`) and stores to `FFBBE3`
   (`0x002A86 6a 8c bb e3`).
4. Inverts `ISCRH` b5:4 and `8170.b1` (`0x002A8A 6b 04 fd 68 71 5c 71 4c 6b 84 fd 68 6a 18 81 70 71 10`).

**Why this is a quadrature decoder.** Each handler interrupts on every edge of one line (A), flips its edge
sense, and samples a second line (B, on `PORTF`) for direction. So: IRQ7 = A, `PF3` = B. IRQ10 = A, `PF1` = B.

**Supporting details:**

- **The debounce** `FF94B9` is decremented by the TGI5A ISR (`0x002A44 6a 0c 94 b9 47 06 1a 0c 6a 8c 94 b9`).
  After each latched IRQ7 step, further IRQ7 steps are dropped for 4 TPU5 ticks. The edge tracking itself never
  stops.
- **The IRQ7 gate** `FF817F.b0` has one setter, `0x004888 6a 18 81 7f 70 00 5e 01 07 60 54 70`. That is the tail of
  a dispatcher in `sub_45F6`. It is cleared only at init (`0x002390`). What it means is Unknown.

> Precision on doc 123:164. "It runs only with `FF817F.b0` set and debounce `FF94B9 == 0`" applies to the latch
> store only. The edge flip at `0x002A08` runs on every IRQ7 interrupt, because the gate branches to it
> (`0x0029DC 47 2a`).

### 4. DIAL KNOB CHANGE selects the roles (Confirmed)

The key scan reads `FF89B5` (`0x00FB40 6a 2c 00 ff 89 b5 46 1c`). Each pass reads and clears a latch:

| `FF89B5` | Latch → **event 13 (DIAL)** | Latch → `sub_FC56` (other knob) |
| --- | --- | --- |
| 0 | `FF8171` / **IRQ7** (`0x00FB48 fc 00 6a 0b 81 71 6a 8c 81 71 73 7b 46 68`) | `FFBBE3` / IRQ10 (`0x00FB56 6a 0b bb e3 6a 8c bb e3 73 7b 47 22 40 1a`) |
| ≠ 0 (**default 1**, `0x00E634 fc 01 6a 8c 89 b5`) | `FFBBE3` / **IRQ10** (`0x00FB64 fc 00 6a 0b bb e3 6a 8c bb e3 73 7b 46 4c`) | `FF8171` / IRQ7 (`0x00FB72 6a 0b 81 71 6a 8c 81 71 73 7b 47 06 5e 00 fc 56 54 70`) |

- **DIAL path:** sets `A9EE.b0 = dir` and raw key `0x16` (`0x00FBBE 77 0b 6a 18 a9 ee 67 00 fc 16`), then
  event = raw − 9 = 13 (`0x00FBD4 fb 09 18 bc 6a 8c a9 ed`).
- **Other path:** `sub_FC56` sets `AA38.b6` and `A9EE.b0 = dir`
  (`0x00FC56 6a 18 aa 38 70 60 77 0b 6a 18 a9 ee 67 00 54 70`).
- **Sending the setting to SUB:** `sub_A206` sends **F396** (`0x00A210 79 04 f3 96`) with the value byte
  `FF89B5 != 0 ? 1 : 0` (`0x00A228 6a 0b 89 b5 47 02 fb 01 7a 06 00 ff 3d 94 68 eb`).

### 5. The SUB screen names the functions and draws the knob (Confirmed bytes)

**Strings.**

- Label `0xFFC3E475` "DIAL KNOB CHANGE": `44 49 41 4c 20 4b 4e 4f 42 20 43 48 41 4e 47 45 00`.
- Options `0xFFF491A7` "VOL" and `0xFFF491AB` "DIAL": `56 4f 4c 00 44 49 41 4c 00`.
- Apart from these, the only `DIAL`/`VOL` strings in either image are the lock options "DIAL" / "KEY&DIAL" /
  "DIAL&PTT" (`0xFFF48FE2`–`0xFFF49006`) and "VOLT" (`0xFFF487E5`). There is no `KNOB` or `ENCODER` string beyond
  the label (Not found; whole-image search of both images).

**Value case `FFF052D7`.**

- First it blits sprite `0xFFED0A8C` at x = `0x41`, y = `0x4D`:
  `fb 32 8c 0a ed ff 75 42 4d 75 41 41 05 65 b3 fe` (`r3` = descriptor, `r2` = y, `r1` = x).
- It then tests the value byte (`FFF052E7 5a 01 bb 01 61 01 21 28`) and draws:

| Value | At x `0xBE`, y `0x64` | At x `0xBE`, y `0x85` | Bytes |
| --- | --- | --- | --- |
| 0 | "VOL" | "DIAL" | `FFF052EF fb 42 a7 91 f4 ff 66 03 75 42 64 75 41 be …`; `FFF05301 fb 42 ab 91 f4 ff 66 03 75 42 85 75 41 be …` |
| 1 | "DIAL" | "VOL" | `FFF05315 fb 42 ab 91 f4 ff 66 03 75 42 64 75 41 be …`; `FFF05327 fb 42 a7 91 f4 ff 66 03 75 42 85 75 41 be …` |

**Coordinate roles (Confirmed).**

- **Sprite blit:** it clips width against `0x140 − r1` (`FFEF0661 fb ea 40 01 06 c1 0e 1f`) and height against
  `0xF0 − r2` (`FFEF066F 75 4e f0 06 c1 0e 1e`). So `r1` = x and `r2` = y.
- **String renderer:** it saves `r1` → `[sp+0x1A]` and `r2` → `[sp+0x18]` (`FFEFA7EA 93 09 93 02`). It then calls
  the glyph blit with `r1 = [sp+0x1A] + advance` and `r2 = [sp+0x18]`
  (`FFEFA894 bb 09 06 c9 01 05 b1 0b b9 84 bb 02`, `bsr.a` at `FFEFA8A8 05 65 70 ff` → `FFEF190D`).
- **Glyph blit:** it addresses `(r2 + row)·0x140 + r1` (`FFEF19C5 be 01 06 c9 01 0a 76 11 40 01 06 c9 01 19`).
- So both label coordinates are the **top-left** corner. The labels sit at x = 190, right of the sprite (x 65–160),
  with their tops at y = 100 and y = 133.

**Sprite (Confirmed bytes; picture reading Inferred).**

- Descriptor `0xFFED0A8C 60 00 62 00 ea f9 cb ff 00 00 ff ff 00 00`: 96 × 98, pixels at `0xFFCBF9EA`,
  key 0, mode 0.
- The render (`sprite_FFED0A8C.png`) shows a **small fluted knob on top of a wide knurled ring**, which is a dual
  concentric control.
- The opaque width is at most 64 px in rows 0–55 and at least 68 px in rows 57–97 (`verify.tsv` GEO row).
- Drawn at y = 77, the small knob covers screen y 77–132 and the ring covers y 133–174.
- So the label at y = 100 sits beside the small knob, and the label at y = 133 starts on the ring's first row.

### 6. Putting it together

| Setting | Label beside small upper knob | Label beside wide ring | MAIN: DIAL latch | MAIN: other latch |
| --- | --- | --- | --- | --- |
| 0 | VOL | DIAL | IRQ7 | IRQ10 |
| 1 (default) | DIAL | VOL | IRQ10 | IRQ7 |

Both rows give the same answer: **IRQ10 ↔ small upper (inner) knob** and **IRQ7 ↔ wide lower (outer) ring**.

**Status:**

- The function names (DIAL / VOL per setting) are **Confirmed**: a string names each one, and the MAIN latch
  selection is read from the bytes.
- The physical assignment is **Inferred (strong)**. It rests on the labels being placed level with the sprite
  parts, and on two assumptions: that the sprite depicts the radio's own knob, and that the label placed beside a
  part names that part.

### 7. What "VOL" drives (Confirmed code; "AF volume" Inferred)

1. **Consume the flag.** `sub_1079E` consumes `AA38.b6` when no key event is pending
   (`0x0107B0 6a 10 aa 38 73 60 46 14`). It calls `sub_10A30` (`0x0107EE 5e 01 0a 30`), which calls `sub_1E744`
   and clears `AA38.b7/b6` (`0x010A40 5e 01 e7 44 6a 18 aa 38 72 70 6a 18 aa 38 72 60`).
2. **Step the level.** `sub_1E744` steps the active record's `+0x6C` byte through the step record
   `0x01E796 00 1f 00 ff aa 56` (range 0–31): `0x01E752 6e 0c 00 6c … 5e 01 e8 40 4b 2e 6e 8b 00 6c`.
   - The direction comes from `A9EE.b0` (`0x01E848 6a 10 a9 ee 73 00 46 0a`).
   - If `BBF4.b0` is set it calls `sub_16EE8` instead. That routine steps `8970`/`8971`; this mode was not labelled.
3. **Apply the taper.** `sub_1E7C2` / `sub_1E80A` map the level through the 32-entry curve
   `0x003A68 00 01 02 … 84 a1 c8 ff`, optionally pre-divided by tables `0x3A8A` / `0x3AAC`. They write `A99B` /
   `A99A` (`0x01E804 6a 8c a9 9b`, `0x01E836 6e 4c 3a 68 6a 8c a9 9a`).
4. **Send it out.** `sub_3490` (19 callers) sends each changed byte of `A998`–`A99F` as a 12-bit serial word:
   - a 4-bit address from `0x00356C 08 04 0c 02 0a 06 0e 01`, followed by the 8-bit value;
   - clock on `PBDR FFFF5A` b1, data on b0, load on b5
     (`0x003490 7a 01 00 00 00 00 6e 1a a9 98 6e 12 a9 a0 1c a2 47 38`, `0x0034AA 6e 12 35 6c 10 52 10 52 fe 0c`,
     `0x0034BC 10 12 7f 5a 67 00`, `0x0034D2 7f 5a 70 50`).
   - The DAC part number is Unknown.

A 0–31 level, an audio-taper curve and an analog DAC output agree with the "VOL" label. That makes `+0x6C` the
per-band AF volume (Inferred, strong).

## USB relevance

- **Q1 (USB):** none. Both knob IRQs are local GPIO decoders. Neither touches `FFEE00`, SCI or DMAC.
- **Q2 (SDR):** unchanged. The volume path is an 8-bit serial DAC written at most once per change. It carries no
  samples.
- **Q3 (DSP):** unchanged. Neither knob path reaches SCI-C.

## Open

1. **Rotation sense.** Which physical direction gives `dir = 0` (level up) is hardware-only. The direction rule is
   `dir = 1` when `PORTF` B-bit = `8170` edge state.
2. **IRQ7 gate `FF817F.b0`.** It has one setter, at the tail of the `sub_45F6` dispatcher (`0x004888`). Its readers
   `0x02D23C` / `0x02DE76` would say why only the ring has a gate and a debounce.
3. **`BBF4.b0` mode.** In this mode, VOL steps `8970`/`8971` through `sub_16EE8`. Label it.
4. **Datasheet pin check.** Confirm that P17 / P62 are the IRQ7-A / IRQ10-A functions on the identified part, and
   that ITSR is left at reset.

## Corrections to earlier docs (owning docs not edited)

| Doc:line | Old claim | New, with bytes |
| --- | --- | --- |
| 123:75 | "The physical knob behind each IRQ pin … is not in the image." | The image carries it. The F396 screen draws the dual knob (`0xFFED0A8C`) and labels its parts: `FFF052EF`/`FFF05301`/`FFF05315`/`FFF05327`. IRQ10 = small upper knob, IRQ7 = wide ring (Inferred, strong). §5–6 |
| 123:180, 123:350 (Open 2) | The `AA38.b6` consumer is "presumably the second (VOL) control; that label is Unknown." | It is "VOL" (`0xFFF491A7 56 4f 4c 00`), drawn for the non-DIAL latch. Code path: `+0x6C` 0–31 → `0x003A68` taper → `A99A`/`A99B` → serial DAC `sub_3490`. §7 |
| 123:164 | IRQ7 "runs only with `FF817F.b0` set and debounce `FF94B9 == 0`" | Only the latch store is gated. The edge flip at `0x002A08` runs on every IRQ7 interrupt (`0x0029DC 47 2a`). |
| RESUME-FULL Open 4 | "which knob is on IRQ7 / IRQ10" listed as hardware-only | Resolved from the image: functions Confirmed per setting, physical part Inferred (strong). |

## Byte ledger

- **Named delta: 0.** Ranges: none. Sum: 0 B.
- **Proven delta: 0.** Ranges: none. Sum: 0 B.
- **Check:** all 17 cited MAIN ranges (1,214 B) are already set in `final7_named_mask.bin` (`mask.tsv`, 0 unnamed).
  The cited data ranges (`0x00011C`, `0x000128`, `0x00356C`, `0x003A68`) are named but not proven, as data should
  be.
- No SUB term changes.
