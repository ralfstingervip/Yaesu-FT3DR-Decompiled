# AN1 TX protection sensor and the TX tone generators (MAIN)

> Lane M8. Private DBs `M8_TONES` (`--copy-from ida\db\jobs\L1_MAIN_FINAL5\L1_MAIN_FINAL5.i64`) and
> `M8_TONES_SUB` (`--copy-from ida\db\jobs\K7_SUB_FINAL3\K7_SUB_FINAL3.i64`, labels only). One
> read-only dump job `ida\jobs\m8_dump.py`, 12 MAIN and 3 SUB `--reopen` passes. No database
> edits. sha256 MAIN `8e3ecd05409b2c31…`, SUB `b93570b3c2f69ccb…`, unchanged. Nothing was
> connected to or written to a radio. Model: `claude-opus-5-5`.
>
> Tables in `ida\out\an1-tones\`:
> - `sensor.tsv` — every A/D channel MAIN converts, the AN1 path, AAD9, the popup result.
> - `tones.tsv` — every tone register, table and entry, with the frequency math (197 rows).
> - `m8_verify.py` — checks all 129 byte citations in this doc against both images, re-derives
>   the CTCSS, DTMF, DCS (Golay), sine, ramp and note-table facts, and regenerates both TSVs.
>   Last run: 129/129 pass.
> - `m8_scan.py` — raw byte-pattern scanner used for the censuses.
> - `disasm-dumps.txt` — every IDA request and its output.

## Verdict

**AN1.** The sensor on A/D channel AN1 can't be identified from this package. No string or unit
on either processor names it, so **PA temperature stays Inferred, not Confirmed**.

- AN1 is converted in exactly two places, the main TX dispatcher and its node-mode twin. Both
  run only during TX, every 70–80 ms.
- Only the main machine acts on the reading (`sub_35BAA`).
- The trip latch `AAD9` is cleared at the start of every TX request (`sub_34706`), so a cutoff
  ends only the current transmission.
- **Correction to doc 105:** the "popup `0x23`" is never shown. `sub_1BF40` drops any code
  ≥ `0x0C` before storing it. SUB's popup dispatcher also has no `0x23` entry.
- SUB does carry a `HEAT` message (popup id `0xA9`). No MAIN code was found that raises it.
- AN0 is the supply/battery voltage (Inferred strong). AN2–AN5 are per-band receiver
  quantities (roles Unknown).

**Tones.** All four TX tone engines are now decoded from register values.

| Engine | Hardware | Output | Rate / clock | Result |
| --- | --- | --- | --- | --- |
| **CTCSS** | TPU1 interrupt | D/A ch1 (`0xFFFF69`) | 6552.0 Hz sample rate | `f = AAB4 × 0.099976 Hz`; the table holds `f × 10`, so 67.0 → 66.98 Hz and 254.1 → 254.04 Hz |
| **DTMF** | Same TPU1 interrupt | D/A ch0 (`0xFFFF68`) | 6552.0 Hz | Two accumulators. The table decodes to the standard 4×4 grid. |
| **DCS** | TPU0 interrupt (handler `0x000706`) | D/A ch1 | 5374.5 Hz tick, 40 ticks per bit | 134.36 bps; 23-bit Golay words; ramped edges; ≈110 ms 134 Hz turn-off tail |
| **T-CALL** | 8-bit timer pair `0xFFFEC0`, φ/64, TCORA `0x47`, pin toggle, no interrupt | Timer pin | 250 kHz count | **1736.1 Hz** (designed as 1750 Hz) |

Notes on each engine:

- **CTCSS.** Sample rate is `16 MHz / (0x0989 + 1)`. The phase accumulator is 16 bits and drives
  a 256-entry sine table.
- **DCS.** The 104 code words at `0x000B8C` are exactly the standard DCS list, and every word
  passes the Golay(23,12) check.
- **T-CALL.** The 250 kHz count is cross-checked by the beep note table (C4–C7). The tone
  generator uses no interrupt.
- **Pager (class 7 = SQL TYPE `PAGER`).** The CTCSS engine alternates between the two pager
  tone indices `FF896A` and `FF896B`, 490–500 ms per tone. The analog answer-back sends five
  segments, about 2.5 s.

## Method

- **Dumper.** Wrote `m8_dump.py`, a copy of L8's dumper that works on either processor. Read
  every function and table cited here; requests and outputs are in `disasm-dumps.txt`.
- **Censuses.** Raw byte scans with `m8_scan.py` and inline Python over `0x000000`–`0x07B753`
  of MAIN:
  - `2r 92` (`mov.b @0x92:8`) at even offsets;
  - `3c a0` (ADCSR writes) and the value loaded before each one;
  - `aa de`, `81 1a`, `81 1e`, `8f 96`, `aa b4`/`aa ba`/`aa be`;
  - immediates passed to `sub_1BF40`, `sub_1BF38` and `sub_1BF78`, and immediate writers of
    `BBE1`;
  - every even-aligned `mov.b #0xA9`;
  - temperature, voltage and heat strings in both images.
- **Register identities.**
  - TPU channels are identified by which status flag their handler clears (doc 76 method).
  - The D/A and the 8-bit timer are identified by register geometry and access width against
    the H8S/H8SX family map: DACR written `0xDF`/`0x1F`, and 0x7F mid-scale on both data
    registers; TMR has TCR/TCSR/TCORA/TCNT/TCCR at +0/+2/+4/+8/+A.
  - The exact part is still unpinned (doc 04), so those two identities are **Inferred**. The
    bytes are Confirmed.
  - φ = 16 MHz comes from doc 76.
- **SUB.** Read the popup dispatcher `sub_FFF0B1DB` and the message switch `sub_FFF0B665`, and
  used the SQL TYPE and TX POWER name tables from doc 38.
- **Not covered:**
  - the RX tone decoders beyond identifying them;
  - the physical AN1 circuit;
  - the 14 `BBE1` writes whose value comes from a register;
  - SUB's own S12AD0 channels.

## Findings

### 1. MAIN's A/D: every channel and every reader (`sensor.tsv`)

**Converter usage (Confirmed).** All conversions are polled, single-channel, and software-started:

1. Write the channel to ADCSR (`0xFFFFA0`).
2. `bset #5` (ADST), then spin on `btst #5`.
3. `bclr #7` (ADF).
4. Read **one byte**, the upper 8 bits of channel *n*'s result register at `0xFFFF90 + 2n`.

ADCSR and ADCR are zeroed at init (`0x0021EE fc 00 3c a0 3c a1`). The vector-67 handler
`sub_24B6` zeroes them again (`0x00010C 00 00 24 b6`, `0x00258E fc 00 3c a0 3c a1`).

The census of byte writes to ADCSR found exactly ten (`3c a0`), with these channel values:

| Site | Value |
| --- | --- |
| `0x0021F0` | 0 |
| `0x002590` | 0 |
| `0x0032C2` | 2 |
| `0x0032DA` | 3 |
| `0x0032F8` | 4 |
| `0x003310` | 5 |
| `0x003336` | 0 |
| `0x003468` | 0 |
| `0x034546` | 1 |
| `0x035C22` | 1 |

**Channels and readers:**

| Ch | Read | Store | Readers | Role |
| --- | --- | --- | --- | --- |
| AN0 | `0x003346 2c 90` (every 60 ms, `9550 = 6`); `sub_3466` at boot | `A98C`; `A9BC`.w = BCD volts, `A9BE` = type, `A9BF` = bars | main loop, `sub_34AD2`, display | **Supply/battery voltage** (Inferred strong) |
| **AN1** | `0x034556 2c 92` and `0x035C32 2c 92`, TX only | `A996` | `sub_35BAA` only | **TX protection sensor**, identity Unknown |
| AN2 | `0x0032D2 2c 94` | `A992` | `sub_67DA`, `sub_23496`, `sub_306EA` | per-band level, band A (Unknown) |
| AN3 | `0x0032EA 2c 96` | `A993` | `sub_67DA`, `sub_23496`, `sub_3E060`, `sub_3E110` | per-band level, band A (Unknown) |
| AN4 | `0x003308 2c 98`, only if `8DDE == 0` (`0x0032F0 6a 0c 8d de 46 30`) | `A994` | `sub_67DA`, `sub_23496`, `sub_3210C` | band B counterpart of AN2 |
| AN5 | `0x003320 2c 9a`, same gate | `A995` | `sub_67DA`, `sub_23496`, `sub_3E26C`, `sub_3E31A` | band B counterpart of AN3 |

**AN0 is the supply.** The evidence:

1. The raw byte is scaled `× 0x1AE6` and turned into BCD volts (`0x003346`…`5e 03 fa 2c`).
2. It is then classified:
   - `≥ 0x100` (10.0 V) → type 0, external DC (`0x003362 79 26 01 00`);
   - steps 7.6…5.0 V → type 1 (`0x003374 f3 01 fb 01 79 26 00 76`);
   - steps 3.9…3.3 V → type 2 (`0x0033C0 f3 02 fb 01 ae 39`).
3. These match the MAIN strings `" Volt Ext   . V  Volt  Lit  . V  Volt  Dry  . V"` at
   `0x0089E4`.
4. `sub_3466` tests ≥ 9.0 V at boot (`0x00348A 79 26 00 90`).
5. **New TX-power gate.** With type 2 (dry cells), `sub_34AD2` caps TX power at index 1, which
   is LOW2 (`0x034AD6 6a 0c a9 be ac 02 47 10`, `0x034AF4 aa 02 45 02 fa 01`). TX POWER indices
   0–3 are LOW1/LOW2/LOW3/HIGH (doc 38).

**AN1 census (Confirmed, whole image).**

- **`mov.b @0x92:8` reads.** Even-aligned `2r 92` outside the vector table occurs only at
  `0x034556` and `0x035C32`. The other three hits are operand bytes:
  - `0x011A6E`: BE32 pointer `0x00022A92`;
  - `0x061C88`: pointer `0x00062692`;
  - `0x070CC8`: operand of `mov.l #0x72892`.
- **Other read forms.** No abs16 or abs32 form of `FF92` exists.
- **Channel selects.** Channel 1 is selected only at `0x034544` and `0x035C20`.
- **No other AN1 reader exists outside TX.**
- Both samplers run every 70–80 ms. `FF9551` is a 10 ms-tier counter with reload 8, reset to 0
  per TX (`0x034750 … 6a 8c 95 51`).

### 2. What AN1 drives (Confirmed) and how the trip clears

The dispatcher clears `AAD7` on every pass (`0x03455C fc 00 6a 8c aa d7`). Only states that write
`AAD7 = 1` let the tail run `sub_35BAA`:

| State | Site |
| --- | --- |
| 2, analog hold | `0x034D2C` |
| 0x10, digital voice | `0x035A18`, `0x035A62` |
| 0x11, TXOFF wait | `0x035A9A` |
| 0x13, data | `0x035B52` |

Each site is `fc 01 6a 8c aa d7`. So protection is active in states 2, 0x10, 0x11 and 0x13, and
not during setup, grace or end. The tail itself is
`0x03465C 6a 0c aa d7 47 10 … 6a 0c aa d9 46 04 5e 03 5b aa`.

`sub_35BAA` thresholds (`0x035BBA ac eb 45 54 ac ef 45 1c ac f4 45 20`):

| `A996` | Fraction of 8-bit full scale | Action |
| --- | --- | --- |
| `< 0xEB` | below 92% | nothing |
| `0xEB`–`0xEE` | 92–93% | power index ≥ 2 → **1 (LOW2)** |
| `0xEF`–`0xF3` | 94–95% | power index ≠ 0 → **0 (LOW1)** |
| `≥ 0xF4` | 96% and up | tone `0x1D` (not in node mode), `sub_34F74` ends TX, `AAD9 = 1` (`0x035BC6`…`fc 01 6a 8c aa d9`) |

On a step, the routine does the following (`0x035BF2 fc 32 6a 8c aa e0 fc 23 5e 01 bf 40`,
`0x035BFE`):

1. Plays local tone `0x32`.
2. Calls `sub_1BF40(0x23)`, which displays nothing (§3).
3. Sets `AAD8 = level`.
4. Calls `sub_34B06`.

The twin samples AN1 but never calls `sub_35BAA` (`0x035CD0 6a 0c aa d9 46 00 54 70`).

**`AAD9` lifecycle (Confirmed, complete xref list).**

- **Set:** only at `0x035BD8`.
- **Cleared:**
  - `sub_34706`, the per-TX reset at state 0/0x0D (`0x034774 fc 00 6a 8c aa d9`, with
    `AAD8 = 0xFF` at `0x03476E`);
  - `sub_3266E` (`0x03269C`), called from `sub_2F5EE` and `sub_310E8`;
  - power-on init `sub_ED16` (`0x00EE0A`);
  - the twin reset `sub_35D4C` (`0x035D88`).
- **Read by:**
  - the tail gate;
  - state 0x13, which aborts the data transfer through `loc_5ECFE`
    (`0x035B5A 6a 0c aa d9 46 38`, `0x035B98 5e 05 ec fe`);
  - its twin `sub_3600E`;
  - `sub_616BA`, which plays result tone `0x59 + trip` after a GM/data session with
    `B3EA == 0x3C` (`0x0616C2 6a 10 aa d9 77 00 …`, `0x0616D8 8c 59 6a 8c aa e0`).

**There is no cooldown and no persistent lockout.** The next PTT press starts at full requested
power and is cut again only if AN1 is still ≥ `0xF4`.

**Sensor identity.**

- **Supports PA temperature (Inferred, low-moderate):**
  - the converter is read only while keyed;
  - the reading is high-is-bad near the top of scale;
  - the response steps power down before cutting off.
- **Against reflected power, PA current, or another stressor:** nothing rules these out.
- **No name or unit exists (Not found):**
  - MAIN strings with "Temp" occur only in APRS weather text (`0x04E586`);
  - SUB's `TEMP` at `0xFFF49B75` is in the APRS unit group (`DISTANCE`/`SPEED`/`ALTITUDE`/`TEMP`/
    `RAIN`/`WIND`);
  - `VOLT` at `0xFFF487E5` is the opening-message option.
  - No temperature value is displayed anywhere, and no menu shows AN1.
- **SUB's message popup `HEAT`:** id `0xA9`, case `0xFFF0B728 75 51 a9`, string `0xFFF4AB33`.
  This is the only heat-related text. No MAIN writer of popup channel `BBE1` loads `0xA9` by
  immediate. Scope: 79 `6a 8c bb e1` stores and the calls to `sub_1BF78`, which take `02`,
  `A4`, `A6`, `A7`, `AA`. 14 register-sourced stores are not traced. The link from AN1 to
  `HEAT` is therefore **Not found**.

### 3. Popup `0x23`: dropped on MAIN, absent on SUB (Confirmed)

**MAIN.** `sub_1BF40` is the routine that stores `FF94F5`. Its first instructions are
`0x01BF40 ac 02 45 32 ac 0c 44 2e`, i.e. `cmp #2; bcs ret; cmp #0xC; bcc ret`. Only codes 2–0x0B
reach the store `0x01BF48 6a 8c 94 f5`.

- `0x23` returns at once, so nothing is stored and the `0xA4`/`0x11`/`0x18` timer choices after
  the gate are dead.
- Every immediate caller passes a code that is dropped: `0x13`, `0x1E`, `0x23`, `0x2A`, `0x2B`,
  and `0x0F`/`0x17` via `sub_1BF38`.
- `FF94F5`'s other writers store only `0xFF`: `sub_71B0`, `sub_ED16` and `sub_3E354`.

**SUB.** The popup dispatcher `sub_FFF0B1DB` takes its id from `[0x8C4D + 0x13]`
(`0xFFF0B1E0 fb e2 4d 8c 00 00 c5 e0 13 05`). It handles these ranges:

- 1–9 and 0x0C–0x0E → message switch;
- 0x0A–0x0B;
- 0x10–0x17;
- 0x20–0x21 (`0xFFF0B26A 71 1e e0 61 2e`);
- 0x30/0x40/0x60/0x70/0x80 + 0..2;
- 0xA0–0xAF (`0xFFF0B2A6`);
- 0xB0/0xC0/0xD0/0xE0/0xF0 + 0..2.

`0x23` falls through to the exit. The message switch `sub_FFF0B665` has cases 1–0x0E and
0xA0–0xAE, and none for `0x23`.

The MAIN→SUB mapping of `8C60` was not traced, but `0x23` has no meaning on either side, so the
popup half of L8's claim is void.

### 4. Tone hardware map (Confirmed bytes; D/A and TMR identities Inferred)

**Vectors.**

| Vector | Slot | Handler | Role |
| --- | --- | --- | --- |
| 88 | `0x160` | `0x0028D0` | TPU0 TGIA: clears `0xFFFFC5` b0, jumps through RAM pointer `FF811A` |
| 93 | `0x174` | `0x002950` | TPU1 TGIA: clears `0xFFFFD5` b0; the DDS |
| 97 | `0x184` | `0x0028E2` | TPU2 TGIA, through `FF811E` |
| 68, 69 | `0x110`, `0x114` | `0x0028F4`, `0x002922` | IRQ4/IRQ5: read and clear TPU0/TPU2 TCNT, then jump through the same pointers. These are RX tone/DCS period decoders. |
| 116–127 | all | `0x2092` | Every 8-bit-timer vector is the default, so the tone timer has no ISR |

**TPU init** (`0x0022C4`):

- TPU0 and TPU1: TCR `0x20` (φ/1, clear on TGRA), TMDR `0xC0`, TIOR `0`, TIER `0x40` (no
  interrupt until a tone starts).
- Starts are `@0xBC` b0 (TPU0) and b1 (TPU1); TIER b0 enables TGIA.

**D/A.**

- `0x002350 fc 03 3c 6b fc 7f 3c 69 fc 7f 3c 68`: both data registers at mid-scale `0x7F`.
- `0x002378 fc df 3c 6a`: DACR = `0xDF`, both outputs enabled.
- `0x03EC90 fc 1f 3c 6a`: outputs off before standby.
- `0xFFFF69` (DA1) carries CTCSS and DCS; `0xFFFF68` (DA0) carries DTMF.

**8-bit timer pair `0xFFFEC0`** (`0x002324`):

| Register | Value |
| --- | --- |
| `FEC0` | `0x0C`: clear on compare A, CKS=100, i.e. 16-bit cascade |
| `FEC1` | `0x02`: CKS=010 |
| `FECA`, `FECB` | `0` (ICKS=00) |
| `FEC2`, `FEC3` | `0` |

- **Clock.** φ/64 = 250 kHz.
- **Tones.** A tone is written as `TCORA` (word at `FEC4`) and `TCNT = 0`, with `FEC3 |= 3`
  (OS = toggle on compare A). `FEC3 &= 0xF0` stops it (`sub_3830A`).
- **Clock cross-check.** The beep sequencer's note table `0x003ACE` has 37 words, `0x1DE`…`0x3C`.
  Its successive ratios are 2^(1/12), and it fits C4 (261.6 Hz)…C7 under `f = 250 kHz / (2N)`
  within 0.55%. That supports φ/64 independently of the part map.

### 5. CTCSS and pager (Confirmed)

**Engine.** The TPU1 ISR (`0x002950`) does three things on each tick:

- It always clears TGFA.
- If `AAD2.b7` is set:
  - `AAB2 += AAB4`;
  - `DA1 = sine[AAB2 >> 8]`, through the table at `0x3656`;
  - bytes: `6b 04 aa b2 0c 4d 6e 5d 36 56 3d 69 6b 05 aa b4 09 45 6b 85 aa b2`.
- If `AAD2.b2` is set, it runs DTMF (§6).

**Sine table.** `0x3656` is 256 B, the values `0x00`–`0xFE` centred on `0x7F`. Its maximum
deviation from `127 + 127 sin(2πk/256)` is 0.5 LSB.

**Sample rate.** `sub_351D6` (`0x0351D6 … 79 04 09 89 6b 84 ff d8`) gives
`fs = 16e6 / 2442 = 6552.007 Hz`.

**Start.** `sub_34BCA` performs these steps:

1. Sets `AAB4 = word_35158[i]` (`0x034BFA`).
2. Sets `AAB2 = 0`.
3. Sets `AAD2.b7`.
4. Starts TPU1.

**Output frequency.** `f = AAB4 × fs / 65536 = AAB4 × 0.099976 Hz`.

- `word_35158` holds the 50 standard CTCSS tones × 10, from 670 to 2541. All 50 match the
  standard list.
- The error is −0.024% on every tone: 67.0 → 66.98 Hz and 254.1 → 254.04 Hz.
- The tone index is record `+0x17`.
- **Stop:** `sub_351BC` stops TPU1 only when neither CTCSS (`b7`) nor DTMF (`b2`) is active.

**Class map** (`sub_3EF6E`: `class = byte[0x3C88 + record+0x16]`; SQL TYPE names from doc 38):

| SQL TYPE | OFF | TONE | TONE SQL | DCS | REV TONE | JR FREQ | PR FREQ | PAGER | — | D CD | TONE-DCS | D CD-TONE SQL |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| TX class | 0 | 1 | 2 | 3 | 0 | 0 | 0 | **7** | 0 | 3 | 2 | 3 |

Class 0 sends no tone, classes 1, 2 and 7 use CTCSS, and class 3 uses DCS (`0x034B6A … ac 03 47 04`).

**Pager (class 7).** The two tone indices are `FF896A` and `FF896B`, chosen by `AAD1.b7`
(`0x034BD8`). Each one loads `FF9579 = 0x32`, a 10 ms-tier counter, so it plays for 490–500 ms.

State 2 handles the alternation (`0x034CF4`, `0x034D22 6a 18 aa d1 71 70 5e 03 4b ca`):

- When `FF9579` expires, it toggles `AAD1.b7` and reloads.
- For the answer-back (`AAD1.b0`), `AACE` counts 5 expiries and then ends TX.

That gives tone A–B–A–B–A, about 2.5 s, which agrees with L8.

### 6. DTMF (Confirmed)

**Start.** `sub_38CCA` takes digits from the 20-slot queue `AC0E[AC0B]`. Code `0x10` is handled
separately. For each digit it does the following (`0x038D38 … 6b 24 00 03 90 40 01 00 6b 84 aa be`,
`0x038D5A`):

1. Loads `AABE`.l from `dword_39040[d]`.
2. Clears the phases `AABA`.l.
3. Sets `AAD2.b2`.
4. Starts TPU1.

**ISR.** The same TPU1 ISR (`0x00297C`…) steps two 16-bit phases with the two halves of `AABE`
(`09 ed 09 65`). It then writes `(sine[p1] >> 1) + (sine[p2] >> 1)` to **DA0** (`0x0029A8 3e 68`).

**Table.** The increments are `f × 10`, the same scale as CTCSS. Index 0–15 maps to the keys
`0 1 2 3 4 5 6 7 8 9 A B C D * #`, and every pair falls exactly on the standard grid:

- rows 697, 770, 852 and 941 Hz;
- columns 1209, 1336, 1477 and 1633 Hz.

### 7. DCS (Confirmed; was "Inferred, moderate" in doc 105)

**Start.** `sub_34C1A` calls `sub_450` (`0x000450 6e 0c 00 18 7a 05 00 00 07 06 55 d0`), then
`sub_2F55A`. `sub_450` sets up the transmission:

| Setting | Value | Bytes |
| --- | --- | --- |
| TPU0 handler pointer `FF811A` | `0x000706` | — |
| Codeword | `AAC2` = `AAC6` = `dword[0x000B8C + 4 × record+0x18]` | `0x00042C` |
| TPU0 period | TGRA0 (`FF8F96`) = `0x0BA0` | `0x000476 79 04 0b a0` |
| Word length | `AACA = 0x17`, 23 bits | `0x000490` |

The `0x7440` that `sub_42C` also writes is the RX-decode period, 537.6 Hz, 4 × 134.4.

- **Tick rate.** `16e6 / 2977 = 5374.54 Hz`.
- **Bit timing.** The ISR counts `AACB` 1…`0x28`, i.e. **40 ticks per bit**
  (`0x00073E ac 21 45 46 47 06 ac 28 45 68`). That is **134.363 bps** against a nominal 134.4
  (−0.03%).
- **Word repeat.** The next bit is taken MSB-first from `AAC2` with `shal.l`. After 23 bits the
  word reloads from `AAC6` (`0x000762 f4 17 6a 84 aa ca`).

**Codeword table.** `0x000B8C` holds 104 BE32 entries with the low 9 bits zero.

- Each entry's first 12 transmitted bits are the code, LSB-first, followed by `0 0 1`. The
  following 11 bits are parity.
- The 104 codes are exactly the standard DCS list in order, D023…D754.
- All 104 codewords are divisible by the Golay generator. `m8_verify.py` asserts this.
- **TX inversion.** `8F85.b2` XORs the word with `0xFFFFFF00` (`0x00045C`). That bit comes
  from `record+0x35` (F342 DCS INVERSION) via the map `0x003B68 00 01 02 04 05 06`.

**Waveform.** Output is DA1, centred on `0x7F` (`0x000808 3c 69`).

- Each level change is drawn as a 16-step ramp from tables `0x000D32` (rising) and `0x000D72`
  (falling), each 16 × 4 B.
- An entry is `[sign 00/80][amp][word = 100 × amp]`, and the sample is
  `0x7F ∓ (word − amp × AADE) / 100`. All 60 ramp entries satisfy `word = 100 × amp`.
- `AADE` acts as an attenuation percentage. It has no abs16 writer in the image: its 10 `aa de`
  hits are all reads in this ISR.

**Turn-off code.** On analog release with class 3, `sub_22718` sets `AACD.b0` (`0x022794`).

1. The ISR switches to a square-ish 134 Hz tone: 20 ticks per half-cycle, ramps from `0x000DB2`
   and `0x000DEA` (14 × 4 B each).
2. It runs `AACC = 0x1E` half-cycles, about 110 ms (`0x0008F0`).
3. It then stops TPU0 (`sub_2F550`) and parks DA1 at `0x7F` (`0x000A7E 5e 02 f5 50 fc 7f 3c 69`).
4. State 5's wait on `TSTR.b0` (`0x034D66`) is the wait for this tail to finish.

### 8. T-CALL (bytes Confirmed; frequency Inferred through the TMR clock)

1. The `AAD6` machine waits for the beep sequencer to go idle (`AAE1.b7`).
2. It loads `r4 = 0x0047` and calls `sub_3877A` (`0x0350C0 79 04 00 47 5e 03 87 7a`).
3. `sub_3877A` writes TCORA = `0x0047` and TCNT = `0`, and sets toggle on compare A
   (`0x03877A … cc 03 6a 8c fe c3`).

The tone runs until `sub_350E4` turns the output off (`sub_3830A`). That happens at TX end
(`sub_34FF4`) or on node `'@'` `0x12` (L8).

**Frequency.** The counter period is 72 counts at 250 kHz, and there is one toggle per period:

`250000 / (2 × 72)` = **1736.1 Hz**

The design value is clearly 1750 Hz: `N = 250000 / (2 × 1750) = 71.4 → 71 = 0x47`. The note
table uses the same `clk / (2N)` rule. The real tone is −0.8% low because the compare-clear
period is N+1.

## USB relevance

- **Q1 USB: none.** No routine here touches `0xFFEE00`–`0xFFEE53`. The tone engines, A/D and
  popup paths read no host byte.
- **Q2 SDR: unchanged, no.**
  - MAIN's A/D is polled one channel at a time and only the top 8 bits are kept.
  - AN1 is sampled every 70–80 ms, AN0 every 60 ms, and AN2–AN5 once per main-loop pass.
  - The only sample streams in MAIN go *out* of the CPU: the 6.55 kHz and 5.37 kHz tone
    synthesis to the on-chip D/A. They are generated, not captured.
- **Q3 DSP: none.** The analog tone engines are independent of the SCI-C DSP link. Digital
  modes return class 0 from `sub_3EF6E`.

## Corrections to earlier docs (owning docs not edited)

| Doc | Earlier claim | Correction | Evidence |
| --- | --- | --- | --- |
| **105** (L8) §6 and Verdict | Each AN1 step "shows popup code `0x23` via `sub_1BF40`" | `sub_1BF40` drops codes ≥ `0x0C`, so nothing is shown; SUB has no `0x23` popup either | `0x01BF40 ac 02 45 32 ac 0c 44 2e`; §3 |
| **105** §5 | Class 3 "fits a DCS turn-off code (Inferred, moderate)"; TPU1 "looks like a sine-synthesis sample clock (Inferred)"; T-CALL clock select "not read" | DCS Confirmed (Golay table, 134.36 bps, turn-off tail); TPU1 DDS Confirmed; TMR clock read as `FEC1 = 0x02`, `FECB = 0` (φ/64), giving 1736.1 Hz from a 1750 Hz design | §5, §7, §8; `0x002336 fc 02 6a 8c fe c1` |
| **105** §6 | `AAD8`/`AAD9` reset per TX by `sub_34706` | Correct, but incomplete: `sub_3266E` and `sub_ED16` also clear them; `sub_616BA` reads `AAD9` for a result tone; protection runs only in states 2/0x10/0x11/0x13 | §2 |
| **07** §MAIN A/D | `sub_32C0` "reads 10-bit results from `@0xFFFF90/95/96/99` … quantizes to S-meter bars (thresholds `0x73`–`0x76`)" | Byte reads of the upper 8 bits from `0x90`/`0x94`/`0x96`/`0x98`/`0x9A`. The `0x76`…`0x33` thresholds are **BCD battery volts** applied to AN0 only; AN2–AN5 are stored raw | `0x0032D2 2c 94`, `0x003346`–`0x0033C4` |
| **04** §1 | ADCSR touched only by `sub_20FA`, `sub_24B6`, `sub_32C0`, `sub_3466` "and by no vector handler at all" | Also `sub_34538`/`sub_35C14` (AN1). `sub_24B6` *is* the vector-67 handler; it zeroes ADCSR and takes no sample | `0x00010C 00 00 24 b6`; `0x034546`, `0x035C22` |
| **04** §2 table | `0xFFFF90`–`9F` "word reads"; `0xFFFEC0`–`CB` "16-bit timer channel"; no D/A row | Byte reads; `0xFFFEC0`–`CB` is an 8-bit timer pair in 16-bit cascade (beeper and T-CALL); `0xFFFF68`–`6A` is the D/A (DA0, DA1, DACR) (identities Inferred) | §4 |
| **102** (L5) `runs.tsv` | `0x000E20` "last u16 (`0x319C`) of 4-B pair table `0x000E00`" | The table is `0x000DEA`, 14 × 4 B, the DCS turn-off ramp | §7 |
| **102** (L5) `runs.tsv` | `0x039067` typing Inferred | Typing Confirmed: DTMF table | §7 |

## Proven / named bytes (proposals only)

Measured against the final6 masks:

- every routine cited here is already proven and named;
- every table is named except the two runs below;
- `0x035086`–`0x035091` (the `AAD6` jump table) is correctly unproven.

| Range | Bytes | Proposal | Basis |
| --- | --- | --- | --- |
| `0x039067`–`0x03907F` | 25 | **named +25** (data, DTMF table tail) | All 16 entries of `dword_39040` are read via `0x038D40 78 b0 6b 24 00 03 90 40`, indexed by digit 0–15; all 16 decode to the DTMF grid. Code resumes at `0x039080` (proven). |
| `0x000E20`–`0x000E21` | 2 | **named +2** (data) | Low word of element 13 of the 14-element ramp `0x000DEA`; `0x319C = 100 × 0x7F`, the format of all 60 ramp entries. Typing is Confirmed by format. The ISR's index reaches only 12, so the element itself is never read. Code resumes at `0x000E22`. |

**Totals:**

- proven **+0** (364,786);
- named **+27** (501,656 → 501,683);
- headline would be 965,946 / 1,029,972 = 93.78%;
- SUB unchanged.

## Open

1. **AN1 hardware identity.** Settle it from the board (thermistor near the PA vs. a detector
   output) or from a service manual. Firmware alone gives no unit.
2. **Trace the 14 register-sourced `BBE1` writers and the MAIN record behind SUB `8C60`.** This
   would settle whether `HEAT` (`0xA9`) is raised anywhere.
3. **Decode the RX side of the same engines.** That covers the IRQ4/IRQ5 + TPU0/TPU2 period
   decoders, handlers `0x00171C`, `0x001784` and `0x00181A`, the `0x0010C0` config records at
   `0x00158C`, and the `0x3C70`/`0x3C7C` RX class maps.
4. **Find any writer of `AADE`** (DCS amplitude). None uses abs16; check pointer and block-copy
   paths.
5. **Label AN2–AN5.** Check the `sub_23496`/`sub_67DA` table owners `0x014468`/`0x014478` and
   `0x007BA8` to name them, e.g. S-meter vs. squelch noise per band.
