# TX state machine `FFAAD5`: every state, including 6–0x14 (MAIN)

> Lane L8. Private DB `L8_TX_STATES` (`--copy-from ida\db\jobs\K1_MAIN_FINAL4\K1_MAIN_FINAL4.i64`),
> generic read-only dump job `ida\jobs\l8_dump.py` (a copy of K11's dumper plus a `dw` command), with
> 8 `--reopen` passes. Image `decrypted\FT3D_MAIN_ver102_EXP.bin`, base 0, file offset = mapped address,
> big-endian. sha256 `8e3ecd05…` was unchanged before and after; SUB `b93570b3…` was not opened.
> No image was modified. Nothing was connected to or written to a radio. The CDC-ACM/DSP-download
> window `0x078106`–`0x07B753` was not entered. Model: `claude-opus-5-5`.
>
> Tables in `ida\out\tx-states\`:
> - `states.tsv`: 32 rows, one per state per machine.
> - `transitions.tsv`: 55 edges.
> - `disasm-dumps.txt`: every IDA dump this lane used.
> - `build_tables.py`: regenerates both TSVs. It reads every cited byte from the image, so every
>   `0xADDR:bytes` cell is image bytes by construction.

## Verdict

**The TX state variable is `FFAAD5`.** It is a byte index into one of two 21-entry dword jump
tables:

| Machine | Dispatcher | Table | Runs from |
| --- | --- | --- | --- |
| Main | `sub_34538` | `0x034674` | Normal and PDN main loops (`0x002CA8`, `0x0038BA`) |
| Twin | `sub_35C14` | `0x035CD8` | Node main loop (`0x003A12`), when `FF8DDE > 0` and `FF8DE0.b7` |

A dispatcher runs only while `FF94C0 == 1`. Before indexing, it consumes the one-shot event byte
`FFAACF`:

| `AACF` | Meaning | Effect |
| --- | --- | --- |
| 1 | TX request | Restart at state 0 or 0x0D |
| 4 | Encoder re-arm | `sub_34B44` |
| 7 | Analog release | State 5 |
| 8 | Digital release | State 0x11 |

**The states group into five bands.**

| States | Role |
| --- | --- |
| 0, 1 | Setup and key-up |
| 2, 3, 5 | Analog hold, RF-status grace, release tail |
| 0x0D, 0x0E, 0x0F | Pre-key tone wait |
| 0x10–0x14 | C4FM digital: voice/0x15 hold, TXOFF wait, end, data, DSP-busy retry |
| 4, 6–0x0C | Unreachable: no instruction in the image stores these values |

States 6–0x0C are bare `rts` handlers (`0x034DB6`–`0x034DC1`, `54 70` ×6), and slot 0x0B reuses 7.
State 4 has a real handler (`0x034D5C`, a copy of state 5), but no instruction stores 4.

**The machine has no explicit "back to idle" store.** The end routines clear `FF94C0`, which stops
the dispatcher, and `AAD5` keeps its last value until the next request rewrites it.

**Three things here are new:**

- **An ADC-driven TX power foldback and cutoff** in the dispatcher tail (`sub_35BAA`). A/D channel AN1
  is sampled every 80 ms during TX.
  - `≥ 0xEB` → power ≤ 1.
  - `≥ 0xEF` → power 0.
  - `≥ 0xF4` → TX is forced off and the trip latches (`AAD9`).

  It is not applied in the node-mode twin. Doc 93 found no such gate in its scope.
- **State 0x14 is a 3.0–3.1 s retry window**, not an immediate refusal (corrects doc 57).
- **Node command `'@'` arg `0x11` does not key the radio** (corrects doc 77). `0x034A52` is
  `bset #4,@AA30` (the T-CALL burst) and runs only while `FF94C0 == 1`.

## Method

- **Seed and job.** Seeded `L8_TX_STATES` from `K1_MAIN_FINAL4` and copied K11's read-only dumper
  as `l8_dump.py`, adding `dw`, a dword table dump. Ran 8 `--reopen` passes. Every request and its
  output is in `disasm-dumps.txt`.
- **Read in full:**
  - both dispatchers and both tables;
  - every handler of both machines;
  - `sub_34706`/`sub_34782`/`sub_34838`/`sub_3486C` (setup);
  - `sub_35872`/`sub_35EC0` (digital dispatch);
  - `sub_34A7C`/`sub_34AD2`/`sub_34B06` (power level);
  - `sub_34B44`/`sub_34BCA`/`sub_34C1A`/`sub_351D6` (tone encoders);
  - `sub_35BAA` (AN1 protection);
  - `sub_34FF4`, `sub_227BC`, `sub_22718` and `sub_35E88` (ends);
  - `sub_3576` (timer tiers);
  - the three main-loop variants in `sub_2070`;
  - every `AACF` writer;
  - the request routines `sub_2244C`, `sub_22676`, `sub_22A28`, `sub_22FEE`, `sub_22CA0`,
    `sub_3019E` and `sub_73E58`;
  - `sub_3EF6E` (tone class) and `sub_3490` (serial DAC).
- **`AAD5` census.**
  - Raw scan of `0x000000`–`0x080000` for `aa d5`: 44 hits, all abs16 operands and all equal to
    IDA's xrefs.
  - Scan for `00 ff aa d5` (abs32 or immediate forms): 0 hits.
  - The value stored at each of the 32 store sites was read. None stores 4 or 6–0x0C.
  - Not covered: a register-indirect store through a computed `0xFFAAxx` pointer. None was seen in
    any routine read here.
- **Operand xrefs taken for:** `AACF`, `AAD1`–`AAD4`, `AAD7`–`AAD9`, `AAE0`, `AAE1`, `AAE8`, `A996`,
  `AC0A`, `B0BB`, `BB95`, `AA30`, `AA36`, `9553`, `9597`, `9598`, `FF94C0` and `@0xBC:8`.
- **Labels.** Session numbers and TXON/TXOFF come from doc 57. APRS and ringer labels come from
  doc 90, GM sources from doc 86, and PTT/TOT/interlock roles from doc 93. Those were not re-derived.
- **Not covered:**
  - the TPU0/TPU1 interrupt service routines, so the tone classes are labelled by mechanism;
  - the 8-bit-timer clock select behind the T-CALL tone;
  - the SUB popup text for code `0x23`;
  - the physical AN1 source.

**Timer tiers** (`sub_3576`, `0x003576`–`0x003654`):

| Tier | Counters | Driven by |
| --- | --- | --- |
| 10 ms | Bytes `FF9536`–`FF958D`; words `FF95B2`–`FF95CD` | 5 ms ISR counter `FF94B8`, reload 2 |
| 100 ms | Bytes `FF958E`–`FF95B1`; words `FF95CE`–`FF95E9` | `FF9534`, reload 10 |
| 1 s | Words `FF95EA`–`FF95F7` | `FF9535`, reload 10 |

A byte loaded with *n* expires after (*n*−1)…*n* ticks.

## Findings

### 1. Dispatch (Confirmed)

```
sub_2070 main loop
  FF8DDE == 0           -> FF94C0==1 ? sub_34538 (0x002CA8)
  FF8DDE <  0 (PDN) or
  FF8DDE >  0 & !8DE0.b7 -> FF94C0==1 ? sub_34538 (0x0038BA)
  FF8DDE >  0 &  8DE0.b7 -> FF94C0==1 ? sub_35C14 (0x003A12)   [0x0037CC 4b 0a, 0x0037D4 58 60 01 42]

sub_34538: every 80 ms (FF9551=8) sample A/D AN1 -> A996       [0x034544 fc 01 3c a0 ; 0x034556 2c 92]
           AAD7=0 ; r2l = AACF ; event pre-step (§2)
           jsr @off_34674[AAD5]                                   [0x034636 6a 0b aa d5 … 78 b0 6b 26 00 03 46 74 5d 60]
           AACF=0 ; band.0x94 ? sub_378A2 (synth/PLL write)        [0x034652 6e 0a 00 94 47 04 5e 03 78 a2]
           AAD7 && !AAD9 ? sub_35BAA (AN1 protection)              [0x03465C … 0x03466E 5e 03 5b aa]
```

The `0xFFFFA0`/`0xFFFF92` reads are ADCSR and ADDRB under the H8S/H8SX A/D map. The register
identities are Inferred; the bytes are Confirmed.

### 2. Event pre-step (Confirmed; `transitions.tsv` rows 1–13)

**Main machine.**

| `AACF` | Condition | Result |
| --- | --- | --- |
| 1 (any other non-zero value except 4/7/8) | APRS beacon `AAD3.b0` and ringer `FF8C52 ≠ 0` | `AAE0 = 'M'` (0x4D), then state 0x0D (`0x0345B8`) |
| | APRS message `AAD3.b2` and ringer `FF8C53 ≠ 0` | `AAE0 = 'N'` (0x4E), then state 0x0D (`0x0345CA`) |
| | `AAD4.b7` set | Clear it, state 0x0D (`0x034596`) |
| | Otherwise | State 0 (`0x0345A0`) |
| 4 | State ≥ 2 | Re-run `sub_34B44` (`0x0345E0`). Posted by `sub_17210` (`0x01725E`) during TX. |
| 7 | State < 2 | Abort, `sub_34FF4` |
| | State ≥ 2 | State 5 (`0x0345F4 fc 05`) |
| 8 | State < 2 | Abort |
| | State 0x13, or `AAD4.b0` set | Ignored. Data TX finishes on its own. |
| | State 0x14 | Abort |
| | Otherwise | `B0BB.b0 = 0`, `B0BB.b1 = 1` (TXOFF request), state 0x11, `FF9553 = 0x64` (1.0 s) (`0x03462A`) |

The `8AA0 == 1` test before the ringer read is dead: it is `bne +0` at `0x0345B0 46 00`.

**Twin machine.** Only `AACF` 8 and "other" are handled. There is no APRS ringer and no 4/7
handling.

### 3. States (`states.tsv`)

| State | Handler | Role | Leaves to |
| --- | --- | --- | --- |
| 0 | `0x0346FA` | Reset `sub_34706`, setup `sub_34782` | 1 (in window), 3 (outside both windows) |
| 1 | `0x034966` | Settle `FF956D` (10–20 ms) → `0xFFFF4D.b3` interlock → key-up | 2 analog / APRS; `sub_35872` digital; END on interlock |
| 2 | `0x034CCE` | Analog hold; class-7 two-tone timer; `AAD7 = 1` | 3, 5, END |
| 3 | `0x034D42` | RF-status grace, 30–40 ms (`FF9568 = 4`) | 2 or END |
| 4 | `0x034D5C` | **Never stored.** Same body as state 5. | – |
| 5 | `0x034D66` | Wait `TSTR.b0` clear, then resume if PTT held again, else END | 2, END |
| 6–0x0C | `0x034DB6`…`0x034DC0` | **`rts`, never stored** | – |
| 0x0D | `0x0346C8` | Reset `sub_34706` | 0x0E |
| 0x0E | `0x0346D2` | Wait for tone sequencer `FFAAE8 == 0`, then setup | 1/3; 0x0F on key event 13 |
| 0x0F | `0x0346D8` | Setup (tone skipped) | 1/3 |
| 0x10 | `0x035A04` | Digital voice or session-0x15 hold; LOCATION blocks | 0x11 |
| 0x11 | `0x035A8C` | Wait `B0BB.b7` (TXOFF done) or 1.0 s; `B11F++`; 30 ms | 0x12 |
| 0x12 | `0x035ABE` | `sub_227BC` end and cleanup | terminal |
| 0x13 | `0x035B4A` | Data session; loop while `B0BA` blocks remain | 0x13, 0x12 |
| 0x14 | `0x0359EA` | DSP link busy: retry dispatch until `FF9598` (3.0–3.1 s) | 0x10/0x13/0x14, END |

**States 0 and 1 in detail (Confirmed bytes; hardware roles Inferred).**

Setup (`sub_34782`):

- **TX window.** It tests `FFAAAA` against `FF92CE` (VHF) and `FF92D6` (UHF) with `sub_3F5EE`.
  This is the same window pair doc 97 decodes.
- **Band and sub-band.** It sets latch bit `8176.b0` (VHF) or clears it (UHF), and shifts it out
  with `sub_37A3A`. `AAD0` is the sub-band index from the tables at `0x03510A`/`0x035140`
  (`{lo, hi, idx}` in packed BCD, 10 Hz units):
  - VHF: 40–75.995, 108–119.995, 120–173.995, 174–221.995 and 222–229.995 MHz → 0–4;
  - UHF: 230–419.995 and 420–579.995 MHz → 5, 6.
- **Offset class and retune.** `sub_34838` sets the offset class `band.0x8D`, `FF956D = 2`, and
  `band.0x94 = 2`. The last one makes the dispatcher tail call the synthesizer writer `sub_378A2`.
- **Port bits.** `sub_3486C` sets `0xFFFF52` b5/b7 and `0xFFFF5B` b2, clears `0xFFFF5D` b0, and
  handles `0xFFFF5B` b3 → `0xFFFF5D` b1. It sets `0xFFFF59` b4 with `B0AC = 3` for analog voice,
  and clears them for digital or APRS. It then writes filter latch `8172` from
  `byte_34956[AAD0]` = `02 02 04 04 04 08 08`.
- **Roles.** The individual bit roles (T/R switch, PA, filter) are Unknown. Doc 05 calls `0x52` and
  `0x59` "audio / path control".

Key-up (state 1, analog):

1. `sub_34A7C` sets the power level: `band.0x84 = byte_34B28[level]` = `04 06 08 0A`, plus the
   per-band DAC trims in `sub_351F4`.
2. `sub_34B30` sets the band audio path.
3. `AA30.b2` arms the TOT (doc 93 §4).
4. `sub_34B44` arms the tone encoder (§5).
5. One of the following:
   - `A4F0.b6`/`b7` → APRS sender (doc 90);
   - T-CALL burst (§5);
   - tone `0x1F` (`AA36.b3`, set by the key handler `sub_22676` at table `0x0146B8`; label
     Unknown);
   - `sub_34C34`: mic-gain DAC `A99D = byte_34CBA[FF89AD]` (9 levels; `FF89AD` is F326), then
     flush the 8-channel serial DAC `sub_3490` (`0xFFFF5A` b0/b1/b5, channel nibbles from
     `0x00356C`).

**States 6–0x14 in detail.**

- **6–0x0C: unreachable (Confirmed).**
  - Table slots `0x03468C`–`0x0346A7` point at `0x034DB6`/`B8`/`BA`/`BC`/`BE`/`B8`/`C0`, each
    `54 70`.
  - None of the 32 `AAD5` store sites writes 6–0x0C (§Method).
  - The twin's slots 2–0x0C all point at `nullsub_34` `0x035E86` (`54 70`).
  - These look like reserved, compiled-out states.
- **0x0D / 0x0E / 0x0F: the pre-key tone wait.**
  - 0x0D resets.
  - 0x0E holds until the tone sequencer reports idle (`0x0346D2 6a 0c aa e8 46 04`), then runs
    setup. The ringer or GM tone therefore finishes before RF comes up.
  - Key event 13 in the TX-time key tables (`sub_346DE`, slots `0x011994`/`0x011BB4`) cuts the
    wait short: `AAE0 = 0xFF` stops the tone and 0x0F runs setup on the next pass.
  - In any other state the same key only plays `AAE0 = 0` (`sub_3FFA0` = `fc 00 6a 8c aa e0` at
    `0x03FFA0`).
  - Entry is from APRS with a ringer flag, or from `AAD4.b7`. Three GM/data senders set `AAD4.b7`,
    and only when `FF8997 ≠ 0`: `0x0631CC`, `0x067C30`, `0x067EFE` (`6a 18 aa d4 70 70`). Each
    reloads the pending tone from `B312`, which `sub_22FEE` saved before requesting.
- **0x10: digital voice / session 0x15 hold.** Entered from `sub_35872`.
  - `B0CC.b0` → `sub_5A2F8` (session 0x15).
  - Otherwise voice → `sub_5A1BE` (session 0x02/0x0B/0x10 by `B0C7`). That routine also increments
    `B11F` (`0x05A1FA`).
  - The DSP script does TXON (doc 57: `0xFFFF52.b2 = 0`).
  - While holding, after `FF9597` (`0x23` = 3.5 s) and with LOCATION SERVICE `FF8D82.b0` set,
    `sub_5CA34` queues a position block each time the session step `B0BF == 0x10`. It then reloads
    `FF9597 = 0x19`, so a block goes out every 2.5 s.
  - Excluded: `B0CC`, `AAD4` b2/b3, `AC0A ≠ 0`, and DT type `B11E == 3`.
- **0x11: TXOFF wait.** The dispatcher has already cleared `B0BB.b0` and set `B0BB.b1`.
  - The DSP session engine runs TXOFF, which sets `B0BB.b7` (doc 57 `0x05BC7C`).
  - The state leaves on `B0BB.b7` or on the 1.0 s `FF9553` timeout.
  - On leaving: `B11F = (B11F + 1) & 0x7F` via `sub_3F636` with descriptor
    `0x05C876 = 00 7f 00 ff b1 1f`, then `FF9553 = 3`, then 0x12.
- **0x12: end.** After 30 ms, `sub_227BC` runs (`FF94C0 = 0` at `0x02285A`/`0x0228A2`/`0x022912`).
  - Data TX: `817E.b1`.
  - Node: optional end tone `']'` (`FF8DD4`, F329), and node flags cleared.
  - `sub_6163E` clears `AAD4` and arms `FF9599 = 0x78` (12 s).
  - `8EA0.b3` → `sub_21266` returns to the original band.
- **0x13: data TX** (session 0x0A via `sub_5A28A`, `AAD4.b0`).
  - Release is ignored.
  - Each time `B0BB.b7` shows a finished burst: if blocks remain (`B0BA` 1..0x7F) it stays in
    0x13; otherwise it goes to 0x12.
  - An AN1 trip (`AAD9`) aborts the transfer through `loc_5ECFE` (`B0BA`/`B258`/`B25F`/`B263 = 0`).
- **0x14: DSP busy.**
  - `sub_35872` loads `FF9598 = 0x1F` (`0x035872 fc 1f 6a 8c 95 98`).
  - A busy `dsp_request` stores 0x14.
  - 0x14 re-enters the dispatch at `0x0358A4` on every pass (`0x0359EE 58 60 fe b2`), so a busy link
    is **retried for 3.0–3.1 s**.
  - On expiry: tone `0x1D` (local only) and `sub_34FF4`.

### 4. Twin machine (node mode) differences (Confirmed)

- **Setup** `sub_35D96`:
  - has no settle (`FF956D`) and no `band.0x94`, so there is no `sub_378A2` retune from this
    machine;
  - does not run `sub_3486C`, so only `0xFFFF52` b5/b7 and `FBA5.b6` are set;
  - stores `FF9568 = 0x19`, which no twin state reads.
- **State 1** never samples `0xFFFF4D` and always runs the digital dispatch `sub_35EC0`.
- **State 0x10** is `0x035F84 40 30`, a `bra` to `rts`.
  - The skipped 8 bytes `0x035F86 6a 10 b0 cc 73 00 46 28` are unproven dead code.
  - The LOCATION body `sub_35F8E` is instead called from the main loop (`0x0039F4 5e 03 5f 8e`).
- **End** `sub_35E88` writes `FF94C0 = 0` itself and does not call `sub_227BC`, so none of
  `sub_227BC`'s PA/DAC teardown runs.
- **The AN1 protection is disabled.** `0x035CD0 6a 0c aa d9 46 00`: `bne +0`, and no `jsr`.

### 5. Tone encoders and the T-CALL burst (bytes Confirmed, labels Inferred)

`sub_3EF6E` returns a class `byte[0x3C88 + band.0x16]`, or 0 in digital or APRS mode. `sub_34B44`
uses it:

- **Class 0:** nothing.
- **Class 3:** `sub_34C1A` → `sub_2F55A`: TPU0 TCR = `0x20`, TGRA0 = `FF8F96`, start
  (`@0xBC:8` b0), interrupt enable (`@0xC4:8` b0).
  - On analog release with class 3, `sub_22718` posts `AACF = 7` and mutes the mic (`A99D = 0`).
  - State 5 then waits for TPU0 to stop.
  - This fits a DCS turn-off code (Inferred, moderate).
- **Other classes:** `sub_34BCA`.
  - `AAB4 = word_35158[tone]`, a 50-entry table from **67.0 to 254.1 Hz × 10** (`02 9e` = 670 …
    2541, Confirmed). This is the standard CTCSS list.
  - `sub_351D6` starts TPU1 at TCR `0x20`, TGRA1 = `0x0989`. That gives 16 MHz / 2442 ≈ 6.55 kHz,
    which looks like a sine-synthesis sample clock (Inferred).
  - **Class 7** alternates `FF896A`/`FF896B` every 500 ms (`FF9579 = 0x32`, `bnot #7,@AAD1`). This
    is a two-tone pager pattern (Inferred).
- **T-CALL.**
  - `sub_22A28` (event 16, analog only) sets `AAD1.b2`.
  - State 1 turns it into `AA30.b4`, which drives the small machine `AAD6` (`sub_3505C`).
  - That machine waits for the sequencer (`AAE1.b7`), then `sub_3877A(0x47)`: `FEC4 = 0x0047`,
    `FEC3 |= 3`, an 8-bit timer compare match A with output toggle.
  - At φ/64 this would be 250 kHz / (2 × 72) = 1736 Hz, close to 1750 Hz. The clock select was not
    read (Inferred).
  - The burst is stopped by `sub_350E4` from `sub_34FF4`, or by node command `'@'` arg `0x12`.

### 6. AN1 power foldback and cutoff (Confirmed bytes; sensor identity Unknown)

`sub_35BAA` (`0x035BAA`) runs in the main tail when `AAD7` is set and the trip latch `AAD9` is
clear.

1. Base power level `r2l` comes from `sub_34AD2`, or from the forced level `AAD8` if that is
   positive.
2. AN1 (`A996`) thresholds:

   | AN1 | Action |
   | --- | --- |
   | `< 0xEB` | Nothing |
   | `0xEB`–`0xEE` | Level ≥ 2 → 1 |
   | `0xEF`–`0xF3` | Level ≠ 0 → 0 |
   | `≥ 0xF4` | Tone `0x1D`, `sub_34F74` (the TOT expiry body, which ends TX), `AAD9 = 1` |

3. On a level change it plays tone `0x32` (local only), shows popup code `0x23` via `sub_1BF40`,
   sets `AAD8 = level`, and applies it with `sub_34B06`.

Bytes: `0x035BBA ac eb 45 54 ac ef 45 1c ac f4 45 20`, `0x035BD2 5e 03 4f 74 fc 01 6a 8c aa d9`.

`AAD8`/`AAD9` are reset per TX by `sub_34706` (`0x034770`/`0x034776`). Only TX code reads `A996`:
3 xrefs, two writers and `sub_35BAA`. The sensor is Unknown. PA temperature is the best fit
(Inferred, low-moderate): the code acts only during TX, steps power down before cutting, and
refuses with the error tone.

### 7. Where each TX source enters (Confirmed unless marked)

| Source | Entry | Path through `AAD5` |
| --- | --- | --- |
| PTT `0xFFFF4E.b7` → ev14; VOX-type keyer `0x4E.b0`; command `'3'` | `sub_2244C` (`AACF = 1`, `FF94C0 = 1` at `0x02253C`/`0x022542`) | 0 (or 0x0D) → 1 → 2 / 0x10 / 0x13 / 0x14; release AACF 7→5 or 8→0x11→0x12 |
| T-CALL `0x4E.b4` → ev16 `sub_22A28` | `sub_2244C`, then `AAD1.b2` | 0 → 1 (burst via `AAD6`) → 2; release `sub_22AA4` |
| APRS beacon / SmartBeaconing / message / ack (doc 90) | `sub_22ACC`, `sub_22CF4`, `sub_22D76`, `sub_22DB8` → `sub_2244C` with `AAD3` b0/b2 | ringer ? 0x0D→0x0E→1 : 0 → 1 → forced analog key-up, `A4F0` b6/b7 → 2 |
| WIRES-X `S` frame (doc 92) | node handler `sub_6C8E8` (`0x06C942`/`0x06C970` `jsr sub_2244C`; data arm sets `AAD4.b0`) | PDN: main machine with host-keyed bypasses; node: twin 0 → 1 → 0x10/0x13 |
| Remote `']'` (`B0CC.b0`, doc 93) | does not key by itself | selects session 0x15 at `sub_35872` → 0x10 |
| GM beacon `sub_67AB0`, GM ACK `sub_67F18` (doc 86) | `sub_22FEE` → `sub_2244C`, `AAD4.b0` | (`FF8997 ≠ 0`: 0x0D → 0x0E →) 0 → 1 → 0x13 → 0x12 |
| Analog answer-back `sub_3019E`/`sub_31C52` (doc 86 T4) | writes `AACF = 1`, `FF94C0 = 1` directly (`0x030260`/`0x030266`) and **bypasses `sub_2244C`'s gates** except the range check `sub_34DC2` | 0 → 1 → 2, with `AAD1.b0` and `AACE = 5` |
| Node `'@'` (`sub_73E58`) | only when `FF94C0 == 1` | no state change; arg `0x11` starts the T-CALL burst, `0x12` stops it, `< 0x10` → `AC06 = 0x50 + n` |
| TOT `FF95EA` | `sub_34F74` | analog → END; digital → `sub_22718` → `AACF = 8` → 0x11 |

**Answer-back carrier length** (doc 86 T4 open):

- `AACE = 5` is counted down only in state 2's class-7 branch, once per 500 ms toggle.
- With pager-class tone, the carrier is therefore about 5 × 0.5 s = **2.5 s**, alternating
  `FF896A`/`FF896B`, plus the 10–20 ms settle. The bytes are Confirmed: `0x03023A`/`0x030240`, and
  `0x034D0A`–`0x034D1C`.
- The class at the time of an answer-back is Inferred to be 7. If it is not 7, nothing counts
  `AACE` down and TX lasts until the TOT.

### 8. Diagram (main machine; twin differences in §4)

```
 request AACF=1 ──┬─ AAD4.b7 / APRS+ringer ─► [0D reset] ─► [0E wait tone AAE8==0] ─┐
 (sub_2244C,      │                                   key ev13 ─► [0F] ─────────────┤
  3019E, 31C52)   └──────────────────────────► [00 reset+setup] ◄───────────────────┘
                                                 │ in window          │ out of window
                                                 ▼                    ▼
                                [01 settle 10-20 ms; 4D.b3 low?] ─► [03 grace 30-40 ms]
                                   │analog/APRS        │digital            ▲  │ 4D high → END
                                   ▼                   ▼                   │  │ 4D low
                         ┌──► [02 analog hold] ─4D high┘        sub_35872 dispatch
                         │      │ AACF=7 (class 3)              │B0CC/voice   │AAD4.b0    │busy
                         │      ▼                               ▼             ▼           ▼
                         └── [05 wait TSTR.b0=0; PTT again]   [10 voice/0x15] [13 data] [14 retry ≤3.1 s]
                               │ else END                       │AACF=8        │B0BA==0     │ok→10/13
                                                                ▼              ▼            │timeout→END
                                                     [11 TXOFF wait ≤1 s] ─► [12 end 30 ms] ─► FF94C0=0
 END = sub_34FF4 / sub_227BC (FF94C0=0; dispatcher stops; AAD5 keeps its value)
 4, 06–0C: never stored (rts handlers)
```

### 9. Corrections to earlier docs (owning docs not edited)

- **Doc 57 §8.** "UI callers turn that into `AAD5 = 0x14`, so a press while busy is refused, not
  queued." In fact state 0x14 retries the session request on every pass for `FF9598 = 0x1F`
  (3.0–3.1 s), and refuses only on expiry (`0x0359EA 6a 0c 95 98 58 60 fe b2`).
- **Doc 77 §Verdict/§1.**
  - "Host command `0x11` … calls the same `sub_34A52 → sub_35872`": `0x034A52` is
    `6a 18 aa 30 70 40 40 20` (`bset AA30.b4 ; bra rts`). IDA's `sub_34A52` is a mis-split tail of
    `sub_34966`.
  - `sub_73E58` refuses unless `FF94C0 == 1` (`0x073E58 6a 0c 94 c0 ac 01 46 4e`).
  - The node path that keys is `sub_6C8E8` → `sub_2244C`.
  - Doc 77's "TX-inhibit timer (TOT) `FF956D`" was already corrected by doc 93.
- **Doc 93 §6.** "Battery, temperature, ADC: Not found in the routines read." The TX dispatcher
  samples AN1 and folds back or cuts TX (§6). `sub_35BAA` was outside K11's routine list, so the
  statement was correct for K11's scope.
- **Doc 86 T4.** Carrier length is now bounded (§7). Inferred: 2.5 s under the pager class.

### 10. Proven / named bytes (proposals only)

**+0 B proposed.** Every handler and helper cited here is already in `final4_proven_mask.bin` and
`final4_named_mask.bin`. Three small unproven runs are code-like but unreachable, and should stay
unproven:

| Range | Bytes | Why unreachable (Confirmed) |
| --- | --- | --- |
| `0x035F86`–`0x035F8D` (8 B) | `6a 10 b0 cc 73 00 46 28` | Skipped by the unconditional `bra` at `0x035F84`. No BE32 pointer, `jsr`, or `jmp` targets it (whole-image scan). |
| `0x034AC4`–`0x034ACD` (10 B) | `6a 18 aa d2 72 60 fa 01 54 70` | Follows `rts` at `0x034AC2`. No branch was seen to it. |
| `0x034AFC`–`0x034B03` (8 B) | `6a 18 aa d2 72 60 fa 01` | Skipped by `bra` at `0x034AFA`. No branch was seen to it. |

The jump tables `0x034674` (84 B) and `0x035CD8` (84 B) are named and correctly not proven, since
they are data.

## USB relevance

- **Q1 (USB): none.** No routine here touches `0xFFEE00`–`0xFFEE53` or the closed window.
  - The only external keyers into this machine are GPIO (PTT, side keys), SCI-B APRS timing,
    SCI-A/PDN node frames, and the `0x30` command protocol.
  - The machine itself never reads a host byte.
- **Q2 (SDR): unchanged no.**
  - The only A/D use here is a single 8-bit AN1 sample every 80 ms for protection.
  - The tone engines (TPU0, TPU1, 8-bit timer) generate audio; they do not move samples.
- **Q3 (DSP).** The DSP is driven from states 0x10, 0x11 and 0x13 only:
  - state 0x10/0x13 entry, through the `dsp_request` entries `0x05A1BE`/`0x05A28A`/`0x05A2F8`
    (sessions 0x02/0x0B/0x10, 0x0A, 0x15);
  - state 0x11, through the `B0BB` b0/b1/b7 handshake (TXOFF).

  No state sends a free-form opcode.

## Open

1. **Name the AN1 sensor and popup `0x23`.** Read the SUB popup table, or the RX-side use of
   A/D channels, to settle temperature against SWR or current.
2. **Decode the TPU0/TPU1 and 8-bit-timer ISRs** to confirm the class 3 = DCS, other = CTCSS,
   class 7 = pager, and 1750 Hz labels, and the class map at `0x003C88`.
3. **Map `0xFFFF52` b5/b7, `0xFFFF5B` b2/b3, `0xFFFF5D` b0/b1, `0xFFFF59` b4 and latch `8172`/`8176`**
   to T/R switch, PA enable and filter bank. `sub_227BC`/`sub_22948` should hold the reverse writes.
4. **Identify key event 13** (raw `0x16`), the key that skips the pre-key tone, and the
   `sub_22676`/tone-`0x1F` key at table `0x0146B8`.
5. **Settle `FF89BB`.** Doc 77 reads it as short-TX and doc 93 as the VOX enable. State 1 arms the
   DSP short-TX `BB94` with it (`0x0349D4`–`0x0349FC`).
