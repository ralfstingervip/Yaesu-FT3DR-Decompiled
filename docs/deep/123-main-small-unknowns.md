# 123 — MAIN small unknowns: the 666 kHz guard, key event 13, Bluetooth Save, VOX table, AAD2.b0, AA30.b4 (lane M11)

> Lane M11, model `claude-opus-5-5`. Owner-side static analysis of `decrypted\FT3D_MAIN_ver102_EXP.bin`
> (H8SX, big-endian, base 0, file offset = address). The SUB image (RX, file offset = address − `0xFFC00000`)
> was read only for byte checks of four citations. Nothing was connected to a radio. No image byte changed
> (sha256 `8e3ecd05409b2c31…` / `b93570b3c2f69ccb…`, re-hashed by `verify.py`). Private DB `M11_SMALL`
> (`--copy-from ida\db\jobs\L1_MAIN_FINAL5\L1_MAIN_FINAL5.i64`, then `--reopen` only). No other database
> was opened. No published mask, seed or owning doc was edited.

Tables in `ida\out\main-small\`:

| File | Content |
| --- | --- |
| `findings.tsv` | one row per finding, with status, address and bytes |
| `ff910a-writers.tsv` | every path that can write `FF910A`–`FF910D`, by kind, with the condition under which it hits the dword |
| `verify.py` / `verify.tsv` | re-reads all 141 cited byte runs and 24 raw-count claims from the images: **165/165 PASS** |
| `work\req*.txt`, `work\out*.txt` | the IDA requests and listings this doc quotes (job `ida\jobs\m11_dump.py`) |

## Verdict

All six items are resolved from the bytes. Four of them give a new meaning.

1. **`FF910A == 0x00066600` means "the broadcast record is tuned to 666.00 kHz".** `FF910A` is the
   packed-BCD frequency dword (10 Hz units) of the third operating record `FF90F0` (`+0x1A`, or working
   `FF9102 + 8`). That record holds the AM and FM broadcast segments. `0x00066600` is 0.66600 MHz. The
   two hidden toggles (group 9 → `FF89C4.b3`, group 11 → RAM DISPLAY `FF89C4.b4`) therefore arm only
   after the user has left the AM broadcast receiver on 666 kHz. Nothing writes the dword by absolute
   address. It is written by the record unpacker, the factory-default builder, the EEPROM `0x980`
   restore and ordinary tuning through the record pointer. No factory default equals 666 kHz.
2. **Key event 13 (raw `0x16`) is a DIAL-knob step.** It is built at one place, `0x00FBC6`, from a
   latch that one of two **quadrature-encoder ISRs** fills: IRQ7 → `FF8171` or IRQ10 → `FFBBE3`. The
   setup item **"DIAL KNOB CHANGE"** (`FF89B5`, F396) selects which encoder is the DIAL. The other encoder
   sets `AA38.b6` instead. `A9EE.b0` carries the direction. The only other source is **node command `'A'`
   with argument `0x16`**, a remote key injector. That corrects doc 104, which calls `'A'` a channel-index
   write. So in TX state `0x0E`, turning the DIAL cuts the pre-key tone short (doc 105).
3. **`FF8920.b7` is "Bluetooth Save"** (F3D4, group 11 item 3). **`BB8F.b7` is "Bluetooth power-save
   engaged".** It sets after about 10 s with no TX or activity, and only with Bluetooth ON, VOX value 0
   and Bluetooth Save ON. **`FF3D8C.b5`** (status-frame byte `+0x18`) is exactly "Bluetooth ON ∧ VOX
   value 0 ∧ Bluetooth Save ON". So the SUB `E6` gate `[1229D] == 0x20` (doc 107) is the Bluetooth Save
   mode.
4. **`0x007E2C` is a 5-entry VOX threshold table plus one pad byte.** The index is `FF89BB` (VOX 0..2,
   bounded by step record `0x019C82`), plus 2 with Bluetooth ON, and only when VOX ≠ 0. Reachable indices
   are {0,1,2,3,4}, and `0x007E31` is never read. The 6 B are **already named** in the L-wave mask (L5's
   Confirmed tier). Proven credit does not apply, because these bytes are data.
5. **`AAD2.b0` writers are complete.** It is set only at `0x00FD52` (headset press) and cleared only at
   `0x00FCC2`/`0x00FD06` (hardware PTT press). `0x03266E` masks with `0x9D` and keeps it. **Nothing
   clears it at TX end.** L10's narrow case stands.
6. **`AA30.b4` is the T-CALL burst request.** It has exactly one reader, `sub_3505C`, which runs only
   while keyed (`FF94C0 == 1`). That reader consumes the bit and starts the `AAD6` machine, which waits
   for `AAE1.b7` and then starts the 8-bit-timer tone (compare `0x47`). Node `'@'` with arg `0x11` is
   therefore a **remote T-CALL tone** while keyed, with the mic DAC muted. Arg `0x12` stops it.

**Byte credit: proven +0, named +0.** Every byte cited here is already named in
`ida\out\l-wave-recon\final6_named_mask.bin`. The cited bytes outside the proven mask are all data:
pointer slots, value tables and step records (25 runs, listed by the mask check in Method).

## Method

- **DB.** `M11_SMALL`, seeded from `L1_MAIN_FINAL5` via `run_job.py --copy-from` and then reopened 23
  times with `ida\jobs\m11_dump.py`. That script is a copy of L10's read-only dumper: `dis`, `func`,
  `xref`, `callers`, `refrange` (operand addr/value normalised to 24 bits over every code head in
  `0..0x80000`, skipping the closed window `0x078106`–`0x07B753`), `imm` and `grep`. It writes a
  traceback on exception and ends with `qexit(0)`. It makes no database edits.
- **Raw scans.** These ran on the plaintext over `0..0x80000`, closed window included, for the abs16/abs32
  encodings of every RAM address in question: `91 0a`, `00 ff 91 0x`, `aa d2`, `aa 30`, `81 71`, `bb e3`,
  `89 bb`, `00 06 66 00`. The counts are pinned in `verify.py`.
- **Tables reused, not re-derived:** H13 `ida\out\hidden-settings\screens.tsv` (screen → notifier,
  dial, exit handler, label); G3 `ida\out\sub-labels\f3xx-codes.tsv` (F-code → SUB label address); L6
  `ida\out\home-keytable\keytable.tsv` and `zones-resolved.tsv` (key tables, touch codes); doc 105's
  timer-tier table (`sub_3576`).
- **Mask check.** Every cited MAIN range was tested against `final6_proven_mask.bin` /
  `final6_named_mask.bin`. Every byte is named. The 25 runs not in the proven mask are all data.
- **Not done.** No SUB database was opened. SUB is cited only for three label strings and doc 107's
  `0xFFF3851D` compare, each byte-checked. The physical knob behind each IRQ pin (which encoder is
  wired to IRQ7 and which to IRQ10) is not in the image.

## Findings

### 1. `FF910A == 0x00066600` (key-machine cases 8 and 10)

**The field (Confirmed).** `sub_3FB0C` unpacks the 32-byte packed record at `FFAC76`. If packed
`+0x1F` b7 is set (`0x03FB0C 6e 5c 00 1f 73 7c 46 1e`), the destination is `er6 = FF9102`
(`0x03FB32 7a 06 00 ff 91 02`, with `bset 8EA6.b0`), which is `FF90F0 + 0x12`. Otherwise it is
`[FF812A] + 0x12`. The frequency goes to `@(8,er6)` at `0x03FBBA 01 00 6f e4 00 08`. With
`er6 = FF9102` that is `FF910A`, record `FF90F0 + 0x1A`. The repacker reads the same field as
`@(0x1A,er0)` (`0x03FE6E 01 00 6f 05 00 1a`).

**The encoding (Confirmed).** The dword is packed BCD in 10 Hz units:

- The unpacker loads `mov.l @(2,er5),er4` and zeroes the low byte (`0x03FB70 … fc 00`).
- Only when the top word is ≥ `0x0018` (≥ 1.8 MHz, `79 2c 00 18 45 3c`) does it put back `0x50`, `0x25`
  or `0x75`. Those are chosen by the 10/1 kHz byte: `12/37/62/87` → `50` (12.5 kHz grid), `06/31/56/81`
  → `25`, `18/43/68/93` → `75` (`0x03FB7E a4 12 47 2e a4 37 …`).
- The band tables use the same units. `0x022176 00 05 00 00 00 17 95 00` is 0.50000–1.79500 MHz.

So **`0x00066600` = 0.66600 MHz = 666.00 kHz**, inside the AM broadcast row. Below 1.8 MHz the low byte
is always `00`, so the compare matches exactly 666.00 kHz.

**Whose record (Confirmed bytes; label Inferred).** The repacker picks its source record from the band
table it finds the frequency in: table `0x022172`, or `0x0221C0` when `FF800F` is 2–4
(`0x03ECDE`).

| Rows (lo–hi, MHz) | Code | Table |
| --- | --- | --- |
| 0.5–1.795 | `C3` | both |
| 1.8–29.995 | `83` | both |
| 30–75.995 | `83` | `0x022172` |
| 30–87.995 | `83` | `0x0221C0` |
| 76–107.995 | `C3` | `0x022172` |
| 88–107.995 | `C3` | `0x0221C0` |
| 580–999.995 | `83` | both |

Code `C3` sends the repack to the `FF9102` record (`0x03FE94 ab 83 47 0c 7a 06 00 ff 91 02`). The
factory builder tags `FF90F0` records with `+0x1F = 0x98` (b7 set) and every other record with `0x18`
(`0x00EB60 fc 98 7a 20 00 ff 90 f0 47 02 fc 18`). The factory defaults for `FF90F0` (`sub_E99E`, called
with `er0 = FF90F0` at `0x00DFF8` and `0x00E030`) are:

- band 0 = `0x00054000`, 540.00 kHz (`0x00E9A0 7a 01 00 05 40 00`);
- band 4 = `F042[market]` = 95.75 MHz;
- band 3 = `F022[market]` = 76 or 88 MHz.

`FF90F0` is therefore the **AM/FM broadcast-receive record**. Doc 35 calls it "slot B (sub band)" and doc
49-hidden calls it "a third record". The table above is the stronger reading.

**Writers of `FF910A`–`FF910D`** (`ff910a-writers.tsv`):

| Kind | Site | When it hits `FF910A` | Status |
| --- | --- | --- | --- |
| abs16/abs32 | none (raw `91 0a` only at the two guard reads; `91 0d`, `00 ff 91 0a` 0 hits) | never | Not found, MAIN `0..0x80000` |
| unpack | `0x03FBBA` | packed `+0x1F` b7; 6 callers (`0x00EBB0`, `0x03A292`, `0x03A2B2`, `0x03A36E`, `0x03A5D2`, `0x03A614`) | Confirmed |
| factory default | `0x00EB04 01 00 6f 81 00 1a` | via `sub_E99E` with `er0 = FF90F0`; values 540 kHz / 95.75 / 76–88 MHz | Confirmed |
| EEPROM restore | `0x039888`, `0x0398D2` (`sub_3AB80`, EEPROM `0x980`, 0x80 B → `FF90F0`) | EEPROM `0x99A`–`0x99D` | Confirmed |
| record-relative | 30 stores to `@(0x1A..0x1D,er0)` in 17 tuning/entry routines (`sub_1DCA6` … `sub_753D4`) plus head `0x01E1D4` | when `er0 = FF90F0`, the active record while `8EA6.b0` is set (`0x03A622 6a 10 8e a6 73 00 47 06 7a 00 00 ff 90 f0`) | Inferred |

**When the guard is true.** The immediate `00 06 66 00` occurs only at `0x014986` and `0x0149A2`.
The guard holds when the broadcast record's saved frequency is 666.00 kHz. The record does not have to
be the active one: `FF90F0` is persistent (EEPROM `0x980`), and the arm reads it while the setup-menu
group list (screen `0x0C`) is open. Reaching 666 kHz needs a 9 kHz step from 540 (540 + 14 × 9) or
direct entry. The available AM step sizes were not checked (Open).

### 2. Key event 13

**Translator (Confirmed).** `0x00FBC8`: raw < `0x0A` → `A9F0 = raw`, event 0. Otherwise event = raw − 9
(`0x00FBD4 fb 09 18 bc`). Raw `0x16` is formed in one place:
`0x00FBBE 77 0b 6a 18 a9 ee 67 00 fc 16` (`A9EE.b0 = r3l.b0`; `raw = 0x16`). Two branches reach it:

| `FF89B5` | Latch giving event 13 (`0x16`) | Other latch → `sub_FC56` (`AA38.b6` + direction) |
| --- | --- | --- |
| 0 | `FF8171.b7` (`0x00FB4A … 73 7b 46 68`) | `FFBBE3.b7` (`0x00FB56`) |
| ≠ 0 (default 1, `0x00E634 fc 01 6a 8c 89 b5`) | `FFBBE3.b7` (`0x00FB66 … 73 7b 46 4c`) | `FF8171.b7` (`0x00FB72 … 5e 00 fc 56`) |

Both latches are read and cleared on the same pass. `FF89B5` is R1 `0x95` (EEPROM `0x615`). Screen
`0x66` sends it as **F396**, "DIAL KNOB CHANGE": `0x00A210 79 04 f3 96`, `0x00A228 6a 0b 89 b5`, exit
save `0x01932A 79 01 00 95 5a 03 cc bc`. The label string is at SUB `0xFFC3E475`.

**The latch writers are encoder ISRs (Confirmed code; "encoder" Inferred, strong).**

- **`FF8171` is written by `sub_29CA`, vector 71 = IRQ7** (`0x00011C 00 00 29 ca`; `IER = 0x0480`,
  pc-07).
  - It reads port `0xFFFF4E` b3 against the edge-state bit `8170.b0` and stores `0x80 | dir`
    (`0x0029E4`–`0x0029FE`).
  - It then **inverts both IRQ7 edge-select bits** (`0x002A08 6b 04 fd 6a 71 74 71 64 6b 84 fd 6a`) and
    `8170.b0`.
  - It runs only with `FF817F.b0` set and debounce `FF94B9 == 0`.
- **`FFBBE3` is written by `sub_2A60`, vector 74 = IRQ10**, with the same structure on port b1 and
  `8170.b1` (`0x002A6C`–`0x002A96`).
- The only other writers of these latches are the reset clear `0x002384` and the scan's own
  read-and-clear (raw: 6 `81 71`, 5 `bb e3`).
- An interrupt on every edge of one signal, with the edge sense flipped each time and a second line
  sampled to get the direction, is a quadrature decoder.

**What event 13 does (Inferred, strong).**

- Home tables #20–#27 slot 13 is the tuning dispatcher `0x01E8EA` (#20 at `0x011620 00 01 e8 ea`).
- On setting screens slot 13 is the value stepper. The VOX screen's table `0x01342C` slot 13 is
  `0x019C3A` → `sub_15260` → `0x019C50`/`0x019C76`.
- That stepper `loc_3F628` reads `A9EE.b0` as the direction (`0x03F62E 6a 10 a9 ee 73 00 46 20`: 0 = up
  with wrap at `hi`, 1 = down with wrap at `lo`).

So **event 13 is one detent of the DIAL knob**. The other encoder's `AA38.b6` is consumed in
`sub_1079E` (`0x0107B0`), presumably the second (VOL) control; that label is Unknown. In TX the event goes
to `sub_346DE` (slots `0x011994`, `0x011BB4`): in state `0x0E` it stops the tone (`AAE0 = 0xFF`) and moves
to `0x0F` (`0x0346DE … fc ff 6a 8c aa e0 fc 0f 6a 8c aa d5`). So turning the DIAL skips the pre-key tone.

**Remote source (Confirmed; corrects doc 104).** Node command `'A'` is table slot `0x11`
(`0x0744B6 00 07 3e b4`, `sub_73EB4`). It is a **key injector**, not a channel-index write:

- arg `r1h ≥ 0x17` → NAK;
- arg < `0x0A` → event 0 with digit `A9F0 = r1h`;
- otherwise event = `r1h − 9` (`0x073EB4 a1 17 44 24 … a1 0a 44 0c fc 00 6a 8c a9 ed 6a 81 a9 f0`,
  `0x073ECE fc 09 18 c1 6a 81 a9 ed`).

Arg `0x16` is event 13, with the direction left as the stale `A9EE.b0`. Arg `0x17` (event 14, the TX
request) is refused. So `'A'` cannot key TX; `'3'` remains the only PTT injector.

**Not found** (scope stated):

- raw `0x16` from the key matrix: `sub_100E4` emits only `0x0A`, `0x0C`–`0x0F`, `0x11`, `0x12`
  (`0x010108`);
- from touch: L6's 511 zones give `A9ED` ∈ {0, 1, 2, 4, 7, 9, `0x0A`};
- from any immediate store to `A9ED`: none stores `0x0D` or `0x16`.

### 3. `FF8920.b7`, `BB8F.b7`, and `FF3D8C` b5

**`FF8920.b7` = "Bluetooth Save" (Confirmed).** Screen `0x1F` has three handlers:

- dial slot `0x0122AC 00 01 9d 10` → `0x019D10 … 6a 18 89 20 71 70 5e 07 34 b0` (`bnot b7`, then
  `sub_734B0`);
- notifier slot `0x0078A8 00 00 d5 26` → `0x00D526 6a 10 89 20 77 70 79 0b f3 d4` (sends F3D4);
- F3D4 label "Bluetooth Save" at SUB `0xFFC3E745`, group 11 item 3.

Doc 58's label was right.

**`BB8F.b7` = Bluetooth power-save engaged (Confirmed code).** `sub_73412` (called from `0x073072`):

```c
if (!(FF8920 & 1) || FF89BB || !(FF8920 & 0x80)) { BB8F &= ~0x80; return; }     /* 0x073412, 0x0734A8 */
if (FF94C0 == 1 || activity(A9AC/A9AD != 0xFF per 8EA0, or BB8F.b6 && BC6F == 0)) {
    FF95A1 = 100;                                                                   /* 0x07348C */
    if (BB8F & 0x80) { FF817E |= 2; BB8F &= ~0x80; }                                /* wake      */
} else if (FF95A1 == 0 && !(BB8F & 0x80)) { FF817E |= 2; BB8F |= 0x80; }           /* 0x073470  */
/* sub_734B0 (BT Save toggle 0x019D1C, and 0x00EF88): FF95A1 = 200; BB8F &= ~0x80 */
```

`FF95A1` is in the 100 ms tier (`FF958E`–`FF95B1`, doc 105). Save engages after about 10 s idle, or
about 20 s after a toggle (Inferred from the tier).

**`FF3D8C` (frame byte `+0x18`, Confirmed bit map).** It is built by `sub_7C20` at
`0x007DC6`–`0x007DFE` and `sub_7E32`:

| Bit | Meaning |
| --- | --- |
| 7 | Bluetooth ON (`FF8920.b0`) |
| 6 | in Bluetooth Save mode: not in power-save (`!BB8F.b7`, `0x007E4E … 67 eb`); otherwise `BB70 == 0` (`0x007E40`) |
| **5** | **BT ON ∧ `FF89BB == 0` ∧ `FF8920.b7`** (`0x007E32 6a 0c 89 bb 46 08 6a 10 89 20 73 70 46 0c` → `70 5b`) |
| 4–2 | `FF89BC & 7` (VOX delay index) |
| 1–0 | VOX source: 1 = internal mic, 2 = with Bluetooth; 0 when VOX is 0 |

The SUB tests only `& 0x20` (`0xFFF3851D b6 11 75 21 20`). Doc 107's E6 gate `[1229D] == 0x20` is
therefore "Bluetooth Save mode active".

### 4. VOX table `0x007E2C`–`0x007E31`

```
007DDA  6a 0d 89 bb   r5l = FF89BB ; beq -> idx 0 (no VOX)
007DE0  f5 01 …       r5h = 1 ; if BT on: r5h = 2, r5l += 2       (8d 02 at 0x007DF0)
007E04  7a 65 00 00 00 ff 78 50 6a 2b 00 00 7e 2c 6a ab 00 ff 3d 8d   FF3D8D = tbl[r5l]
007E2C  00 28 14 2d 18 | 00                                         5 entries + pad
```

**Bound (Confirmed for UI values).** Only two code paths store to `FF89BB`, and both store 0
(`0x002ABA`, `0x0103CE`). The VOX screen edits it through step record
`0x019C82 00 02 00 ff 89 bb` (lo 0, hi 2) with the wrapping stepper `loc_3F628`. Up wraps to `lo` when
`cur ≥ hi`, and down wraps to `hi` when `cur ≤ lo` (`0x03F63E 69 64 1c bc 47 02 44 0a`,
`0x03F65E 69 64 1c 4b 47 02 44 0a`). So after any edit `FF89BB` ∈ {0,1,2}. The indices are:

- VOX 0 → 0 (`00`);
- VOX 1, 2 without Bluetooth → 1, 2 (`28`, `14`);
- VOX 1, 2 with Bluetooth → 3, 4 (`2D`, `18`).

`0x007E31` is never indexed. It is a pad byte, since the code at `0x007E32` must start on an even
address. **Inferred:** the EEPROM R1 restore (`FF89BB` = EEPROM `0x61B`) is not range-checked, so a
corrupt or foreign EEPROM value could index past the table. That is not reachable from the UI. The values
are per-level VOX thresholds sent to SUB in `FF3D8D`; the units are Unknown.

**Credit.** L5's Confirmed tier already names `007E2C`–`007E32` (`proposed-typing.tsv`), and it is set in
`final6_named_mask.bin`. Doc 107 compared against final4, which is why it saw the table unnamed.
**Named +0, proven +0**, since the proven mask is code and these are data.

### 5. `AAD2.b0`, the headset-ownership flag

Raw scan, MAIN `0..0x80000`: **32** `aa d2` operand sites. Bit 0 is touched only by:

| Site | Bytes | Role |
| --- | --- | --- |
| `0x00FD52` | `6a 18 aa d2 70 00` | set: headset press (`sub_FD22`) |
| `0x00FCC2` | `6a 18 aa d2 72 00 6a 18 aa d2 72 10 fc 17` | clear: PTT press, PTT DELAY 0 |
| `0x00FD06` | `6a 18 aa d2 72 00 fc 17` | clear: PTT press after PTT DELAY |
| `0x00FD42` | `6a 10 aa d2 73 00` | the only reader |
| `0x03266E` | `6a 0c aa d2 ec 9d 6a 8c aa d2` | whole-byte rewrite, keeps b0 (callers `0x02F5FA`, `0x0310E8`) |

All other sites test or change bits 1, 2, 3, 5, 6 or 7. The TX-end cleanup `sub_227BC` clears only b7
(`0x022830`). **No path clears b0 at TX end** (Confirmed). The power-on value is Unknown: the reset RAM
clear covers only `FEE000`–`FF72FF` (`0x002132`), and no other clear of `FFAAD2` was found. L10's narrow
case (a stale flag lets a later headset release end an APRS, WIRES-X `S` or remote `']'` TX) stands.

### 6. `AA30.b4` (node `'@'` arg `0x11`)

**Writers (Confirmed, raw).**

- `bset` at `0x034A52` (`aa 30 70 40`, 1 hit). It is reached from TX state 1 when `AAD1.b2` is set by
  T-CALL ev16 (`0x034A2E 6a 10 aa d1 73 20 46 16`, then `0x034A4C 6a 18 aa d1 72 20`). It is also reached
  directly by `'@'` 0x11 (`0x073E86 5e 03 4a 52`).
- `bclr` at `0x035064` (1 hit).
- No `btst`/`bnot`/`bld` of b4, and no whole-byte store to `AA30`. The four whole-byte reads test b1
  (`0x002D04`), b2 (`0x034EEE`), b3 (`0x03E682`) and b4 (`0x03505C`).

**Reader and effect (Confirmed).** `sub_3505C` is called only at `0x002CB4`, on the main-loop branch taken
when `FF94C0 == 1` (`0x002C48 6a 0c 94 c0 ac 01 47 58`). It latches `AA30` into `r2l`. If b4 is set, it
clears the bit and sets `AAD6 = 0`. It then dispatches table `0x035086` (3 states):

- **State 0** (`0x035092`, only on the latched b4): it sets `AAD1.b3`, sets `A9E3` b7 and b2, and calls
  `sub_38314`. If `AAE1.b7` is set it goes straight to the start, otherwise `AAD6 = 1`.
- **State 1** (`0x0350D0`): it waits for `AAE1.b7`.
- **Start** (`0x0350C0 79 04 00 47 5e 03 87 7a fc 02 6a 8c aa d6`): `sub_3877A` writes `FEC4 = 0x0047`
  and `FEC3 |= 3`, an 8-bit-timer compare-match toggle. Then `AAD6 = 2`.
- **State 2** (`0x0350DC 6a 0c aa d8 4b 00 54 70`): hold.
- **Stop** (`sub_350E4`): clears `AAD1.b3`, calls `sub_3830A`, sets `A9E3.b7`, clears `A9E3.b2`, sets
  `AAD6 = 0`. It is called from TX end `sub_34FF4` when `AAD1.b3` is set (`0x035042`), from T-CALL
  release `sub_22A88`/`sub_22A92`, and from `'@'` 0x12 (`0x073E8E`).

`'@'` 0x11 also zeroes the mic-gain DAC (`0x073E98 fc 00 6a 8c a9 9d`, then `sub_3490`). Arg `0x12`
calls `sub_34C58`, the band-dependent part of the mic-gain routine `sub_34C34` (restore, Inferred). So
**`'@'` 0x11 = remote T-CALL (tone burst, mic muted) while the radio is keyed; 0x12 ends it.** The ≈1750 Hz
reading of compare `0x47` is doc 105's and stays Inferred (clock select not read).

### Corrections to earlier docs (owning docs not edited)

- **Doc 104 (L7), §4 and `pdn-node-table` row `0x11`:** `'A'` is not "channel index `A9F0`". It is a
  remote key injector. Args `0x00`–`0x09` → digit event 0 (`A9F0 = arg`); `0x0A`–`0x16` → events 1–13;
  `≥ 0x17` NAK (`0x073EB4 a1 17 44 24`, `0x073ECE fc 09 18 c1 6a 81 a9 ed`). It cannot inject event 14
  (TX).
- **Doc 49 (H11) Open 4 / doc 112 Open 3:** `0x66600` is not a code address in this compare. It is the BCD
  frequency 666.00 kHz of record `FF90F0` (`0x014984 7a 24 00 06 66 00`; field proof `0x03FB32`,
  `0x03FBBA`). Doc 49's "nothing abs16-writes the dword" is correct. The writers are base+displacement
  and EEPROM block (§1).
- **Doc 35 (F8):** `FF90F0` is the broadcast-segment record (code `C3` rows `0x022176`/`0x022194`;
  defaults 540 kHz / 76–88 / 95.75 MHz at `0x00E99E`), not the B band. Doc 49-hidden's A = `FF8EE0`,
  B = `FF8FE8` (`0x00216A`, `0x00217E`) is right.
- **Doc 105 Open 4:** event 13 = DIAL step. Raw `0x16` comes from the encoder latches selected by
  `FF89B5`, or from node `'A'` 0x16. It is not a key-matrix key.
- **Doc 107 §6:** the `0x007E2C` candidate is already named in the L-wave named mask (L5 tier). The bound is
  {0..4} (§4). Open 3 is answered: `FF8920.b7` = Bluetooth Save, `BB8F.b7` = power-save engaged.

## USB relevance

None of the six items touches USB, the DSP bus or flash. They are UI and TX-control state on MAIN.

- **Q1 (USB):** unchanged. Node `'A'` and `'@'` ride the SCI node link (doc 104), not USB.
- **Q2 (SDR):** unchanged. The encoder ISRs and the status byte carry control bits only.
- **Q3 (DSP):** unchanged. `'@'` 0x11 drives a timer tone and the mic DAC, not a DSP opcode.
- **Owner-relevant.** A PC in node or remote mode can, in addition to `'3'` (PTT) and `'@'`, inject any
  non-TX key event with `'A'`, including DIAL steps and digits. It can also add a T-CALL tone burst while
  keyed. The two hidden menu toggles need the AM broadcast receiver left on 666 kHz.

## Open

1. **AM step sizes.** Is 666 kHz reachable by the DIAL on every market (9 kHz vs 10 kHz AM step), or
   only by direct entry? Read the `FF90F0` band-0 step table.
2. **Which physical knob is on IRQ7 and which on IRQ10**, and the label of the `AA38.b6` consumer
   (`sub_1079E` `0x0107B0` → `sub_11050`). This decides what "DIAL KNOB CHANGE = 1" (the default) maps
   to.
3. **`BB70`** (`FF3D8C.b6` outside Bluetooth Save mode): 9 abs16 writers, `0x02C10A` and eight at `0x0730B2`–`0x073326` in the Bluetooth
   cluster.
4. **The VOX threshold units** in `FF3D8D` (SUB consumer of status byte `+0x19`).
5. **Power-on value of `AAD2`/`FFAAxx`.** Find whether anything clears `FF8000`–`FFBFFF` beyond
   `FF72FF`.
