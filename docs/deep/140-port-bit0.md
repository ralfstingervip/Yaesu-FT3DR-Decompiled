# 140 — Who reads and writes MAIN port `0xFFFF4E` bit 0

Lane N13. Owner-side static analysis of the ver 1.02 images on disk. Nothing was written to a radio, and no
image, mask or seed was modified. MAIN sha256 is `8e3ecd05…` and SUB sha256 is `b93570b3…`. Both were checked
at the start and at the end.

## Verdict

**Exactly two instructions in MAIN read `0xFFFF4E` bit 0, and nothing writes it (Confirmed).** Both are
`btst #0,@0x4E:8` (`7e 4e 73 00`), at `0x0106DC` and `0x010712`. They sit inside the VOX keyer `sub_105BE`,
which runs only when the VOX setting `FF89BB` is non-zero. Bit 0 feeds three RAM cells:
- the keyer state `FFBB93`;
- the raw key code `FFA9ED` (`0x17` / `0x18`, the same codes the PTT state machine posts);
- the hang count `FF95A3`.

No other MAIN code reads `0xFFFF4E` in a way that keeps bit 0. There is no interrupt on it and no pointer to
it. No frame carries `FFBB93`, `FF95A3` or the port bit, in either direction:
- `bb 93` occurs 9 times in `0`–`0x80000`, and each occurrence is one of the keyer's own operands.
- The SUB's VOX-level frame E5 lands in `FFBB92`, which is never read.

**On the SUB side (Confirmed):**
- MAIN's VOX setting reaches the SUB in every frame header: mode in `+0x18` b1–0, threshold in `+0x19`.
- For mode 1 (VOX on) or mode 2 (VOX on with Bluetooth), the SUB starts an audio-level detector. The detector
  drives **P24** (`P2.PODR` b4, set to output) high when the level is at or above the threshold.

**Whether P24 reaches MAIN `0xFFFF4E.b0` is Unknown.** No instruction in either image names that net, so it
has to be traced on the board.
- The two ends match in role and gating (Inferred).
- The P24 output is not Bluetooth-specific: VOX mode 1 starts the same detector.
- So "a Bluetooth VOX line" reaches this bit only if the board joins P24 to `0xFFFF4E.b0`, and only in VOX
  mode 2.

**Deltas.** Named delta is 0 and proven delta is 0. Every byte this lane cites is already named. The only
unproven bytes are the keyer's two data tables, 22 B: `0x0106C4`–`0x0106D3` and `0x01070C`–`0x010711`. Both are
already named data.

## Method

- **Hash check.** Both images were checked against the brief's sha256 at the start, and again before
  finishing (see the last section).
- **IDA.** Two private databases were used, each seeded once with `--copy-from` and then `--reopen`:
  - `N13_BIT` from `M1_MAIN_FINAL6`;
  - `N13_BIT_SUB` from `K7_SUB_FINAL3`.

  The jobs were `ida\jobs\n13_dump.py` (a read-only copy of `m12_dump.py`, with the window skip removed) and
  `ida\jobs\n13_cls.py` (classifies byte hits against IDA heads). Neither script edits the database.
  Requests and outputs are in `ida\out\port-bit0\work\` (`req*.txt`/`out*.txt` for MAIN, `sreq*`/`sout*` for SUB).
- **MAIN, IDA operand pass over every code head in `0`–`0x80000`, window included.** `grep @0x4E:8` and
  `grep FF4E` matched 19 heads:
  - 12 proven code heads (`sites.tsv` rows R01–R12);
  - 7 heads that are named data (rows D01–D04).
- **MAIN raw byte pass** (`ida\out\port-bit0\n13_rawscan.py`, scope `0`–`0x7FFFF`). It looked for every
  encoding that can address `0xFFFF4E`:
  - abs8 `2x 4E`, `3x 4E`, `7E 4E`, `7F 4E`;
  - abs16 `FF 4E`;
  - abs32 `00 FF FF 4E` and `FF FF FF 4E`.

  This gave 245 candidates. `n13_cls.py` classified them as 19 code heads, 14 inside other instructions,
  14 data and 198 undefined (81 of the undefined lie in the window range). The table is
  `work\raw_cls.tsv`.
  - Crossed with the FINAL7 proven mask, no candidate outside the 12 heads starts a proven instruction.
  - The 12 proven bytes among the others are operand bytes, for example `0x053EB2 cmp.w #0x4E20`.
- **Indirect forms (Not found, `0`–`0x7FFFF`):**
  - `mov.l #0x00FFFF4x / #0xFFFFFF4x, ERn` (`7a 0n …`): 0 hits;
  - `mov.w #0xFF4x`: 0 hits;
  - IDA `imm FFFF4E`: 0 hits;
  - `mov.w` or `mov.l` on `0xFFFF4C` / `0xFFFF4E`: 0 hits.
- **SUB.** I ran `imm 8C022` / `imm 8C002`, then a raw scan of the whole 4 MB for `22 c0 08`, `02 c0 08`,
  `20 c0 08` and `00 c0 08`, then disassembled the detector, its start/stop routine, the pump and the header
  reader `sub_FFF3850B`.
- **Verification.** `ida\out\port-bit0\n13_verify.py` re-checks both hashes and every byte run cited here
  against the images. It also writes `sites.tsv` and `verify.tsv`. Result: **88/88 PASS**.
- **Not done:**
  - The SUB ADC channel behind `sub_FFF15811` / `sub_FFF158BC` was not traced.
  - The tick routine that counts `FF95A3` / `FF95A4` down was not located.
  - The pin and alternate-function identity of `0xFFFF4E.b0` was not established: "PF0" is Inferred from
    the register stride in pc-07.

## Findings

### 1. Every instruction that touches `0xFFFF4E` (Confirmed; `sites.tsv`)

| Row | Addr | Bytes | Bit kept | Consumer |
| --- | --- | --- | --- | --- |
| R01 | `0x002564` | `2a 4e ea 40` | b6 | `sub_24B6` re-init loop |
| R02 | `0x0029E4` | `2c 4e` (+ `0x0029EE 73 3c`) | b3 | IRQ7 handler → `FF8171` |
| R03 | `0x002A6C` | `2c 4e` (+ `0x002A76 73 1c`) | b1 | IRQ10 handler → `FFBBE3` |
| R04 | `0x00325A` | `2a 4e ea 40` | b6 | `sub_325A` |
| R05/R06 | `0x00DDE6` / `0x00DDEE` | `7e 4e 77 20` | b2 | market strap `FF8011` |
| R07 | `0x00FC66` | `2a 4e ea 80` | b7 | PTT state machine |
| R08 | `0x00FD5E` | `2a 4e ea 10` | b4 | side key |
| R09 | `0x01013C` | `7e 4e 73 50` | b5 | `FFBBF4` |
| **R10** | **`0x0106DC`** | **`7e 4e 73 00`** | **b0** | keyer state 1 |
| **R11** | **`0x010712`** | **`7e 4e 73 00`** | **b0** | keyer state 2 |
| R12 | `0x049468` | `2c 4e ec 80` | b7 | `sub_49468` |

- **Writers of `0xFFFF4E`: none** (Not found; scope is every IDA code head plus the raw `3x 4E` / `7F 4E` /
  abs16 / abs32 forms in `0`–`0x7FFFF`). This is expected for an input register.
- **Direction (Confirmed bytes, register name Inferred).** The DDR at the same stride, `0xFFFB8E`, is written
  only with 0:
  - `0x00229A fc 00 6a 8c fb 8e`;
  - `0x002548 fc 00 6a 8c fb 8e`;
  - `0x002740 6a 8a fb 8e`, with r2l = 0 from `0x00271A fa 00`;
  - `0x0027F0 6a 8a fb 8e`, with r2 = 0 from `0x0027C4 79 02 00 00`.

  The data register `0xFFFF5E` is written only as a whole byte 0 (`0x002290` / `0x00253E fc 00 3c 5e`). So
  bit 0 is an input throughout.
- **Bit sense.** At register level, **bit set = active**: `0x0106DC … 47 28` skips when the bit is clear.
  The electrical polarity of the pin is Unknown.

### 2. What bit 0 feeds (Confirmed code; labels as in doc 93)

- **Call path.** The keyer `sub_105BE` is called only from the key scan at `0x00FBB2 5e 01 05 be`.
  - The key scan calls it only after the PTT, side-key and other scanners have posted no event:
    `0x00FBAC 6a 0c a9 ed 4a 34`.
  - With `FF89BB == 0` the keyer disarms: `BB93 = 0` at `0x0105D2 6a 8c bb 93`.
- **Arming.** Once armed (state 1), it sets `0xFFFF50.b6` when Bluetooth is off (`0x01069E 7f 50 70 60`) and
  clears it when Bluetooth is on (`0x0106AA 7f 50 72 60`; test at `0x010690`).
- **State dispatch.** The keyer dispatches on `FFBB93` through `0x0106C4` =
  `00 01 05 d6 | 00 01 06 d4 | 00 01 07 12 | 00 01 07 38`.
  - **State 1** (`sub_106D4`). If `FF94C0 == 0`, **bit 0 is set**, and the warm-up count `FF95A4` is 0:
    - `A9ED = 0x17` (`0x0106E8 fc 17 6a 8c a9 ed`);
    - `BB93 = 2` (`0x0106EE`);
    - `FF95A3 = byte[0x01070C + FF89BC]` (`0x010706`; table `06 0b 10 15 1a 1f`).
  - **State 2** (`sub_10712`).
    - While **bit 0 is set**, `FF95A3` is reloaded (`0x010716 46 dc`).
    - When bit 0 is clear and `FF95A3 == 0`: `A9ED = 0x18` (`0x01071E fc 18 6a 8c a9 ed`), then `BB93 = 3`
      if `FF94C0 == 1`, else 0 (`0x010732`).
  - **State 3** (`sub_10738`) returns to 0 when `FF94C0 == 0` (`0x010738 … fc 00 6a 8c bb 93`).
- **What the codes become.** `0x17` / `0x18` are the same raw codes the PTT state machine posts
  (`0x00FCCE fc 17 6a 8c a9 ed`, `0x00FCE6 fc 18 6a 8c a9 ed`). The key scan maps them to events 14 / 15
  (`0x00FBD4 fb 09 18 bc 6a 8c a9 ed`). From there the path is the TX gate already documented in docs 93 and
  105; nothing new.
- **Other readers of `FFBB93`.** The only reader outside the keyer is the key-scan gate
  `0x00FB0C 7e 50 73 60 46 14 6a 0c bb 93 46 0e`. With VOX on and Bluetooth off, an armed keyer bypasses the
  PTT scanner and zeroes `A9EA` (`0x00FB26`). Doc 93 already notes this.
- **RAM flags fed by bit 0:** `FFBB93` (state), `FFA9ED` (raw code, then event), `FF95A3` (hang count).
  - `FF95A3` has exactly two code references, `0x010706` (write) and `0x010718` (read).
  - Raw `95 a3` occurs only at those operands (`0x010708`, `0x01071A`).
  - So its countdown runs through a base register or a block routine, which was not traced.

### 3. Frames (Confirmed)

- **MAIN → SUB.** No frame builder reads `FFBB93`, `FF95A3`, `FF95A4` or `0xFFFF4E`.
  - Raw `bb 93`, `95 a3` and `95 a4` occur only as the keyer's own operands (9, 2 and 3 hits).
  - What every frame header does carry is the VOX *setting*, built in `sub_7C20`:
    - `+0x18` b1–0 = 1 when `FF89BB ≠ 0` (`0x007DDA 6a 0d 89 bb 47 14 f5 01`), or 2 with Bluetooth on
      (`0x007DEE f5 02 8d 02`);
    - `+0x18` b4–2 = `FF89BC & 7` (`0x007DF4 … ec 07 10 4c … 6a ab 00 ff 3d 8c`);
    - `+0x19` = `byte[0x007E2C + FF89BB(+2)]` (`0x007E0A … 6a ab 00 ff 3d 8d`; table `00 28 14 2d 18 00`).
- **SUB → MAIN.** The SUB's level result travels as E5. MAIN stores it once, `0x0482C4 6a 0c 98 0b 6a 8c bb 92`,
  and `bb 92` occurs nowhere else in `0`–`0x80000` (doc 124). No SUB frame mentions `FFBB93` or the port bit.

### 4. SUB P24: the only candidate source (Confirmed code; net Unknown)

- **Header to detector.** `sub_FFF3850B` reads header `+0x18 & 3` into `12521` (`FFF3853B b6 11 64 31 …
  80 29`) and `+0x19` into `12524` (`FFF38582 b6 19 … 90 a1`).
  - Mode 1 and mode 2 both set `1251E = 6` (`FFF385C5` / `FFF385D0 … f8 e5 06`); mode 0 sets 0 (`FFF385BA`).
  - Then it starts the detector, `bsr sub_FFF38705` (`FFF38673 39 92 00`): op 1 at `FFF38739 66 11 05 30 16 00`,
    and `12CB8 = 1` at `FFF3875F`.
  - Or it stops it, `bsr sub_FFF3876D` (`FFF385EE 39 7f 01`): op 2 at `FFF387AE 66 21 05 bb 15 00`, and
    `12CB8 = 2` at `FFF387BC`.
- **`sub_FFF39D6B` op 1.** Copies the config to `1252C` and sets `122B0 = 6` (`FFF39DB1 … f8 e4 06`). It picks
  `sub_FFF15811` for mode 1 and `sub_FFF158BC` for modes 2–3 (`FFF39DC3 … b0 19 71 1e fe 61 2e 23 10`).
- **`sub_FFF39D6B` op 2.** Sets `122B0 = 0` (`FFF39DEA`) and **clears P24** (`FFF39E11 fb ee 22 c0 08 f0 ec`).
- **Detector.** The pump runs it every second pass while `122B0 == 6` (`FFF3B71F fb e2 b0 22 01 00 58 ee 61 6e
  21 26`; call `FFF3B74C 39 c9 f9`). `sub_FFF3B115` compares the level against `[1252C+4] << 4`
  (`FFF3B11A … b8 91 6c 41 b8 0a 47 12 29 0a`):
  - at or above → **`bset #4`** (`FFF3B12E fb ee 22 c0 08`, `FFF3B133 f0 e4`);
  - below → **`bclr #4`** (`FFF3B136 fb ee 22 c0 08`, `FFF3B13B f0 ec`).
- **Pin setup.** P24 is an output: `P2.PDR` b4 set at `FFF36F9F fb ee 02 c0 08 f0 e4`. `P2.PODR` is zeroed at
  `FFF36F7B … f8 e4 00`.
  - The other `P2.PODR` writers touch b2 only: `FFF396B9 … f0 e2`, `FFF396F8 … f0 ea`, `FFEDC9AD … f0 ea`.
  - No base-plus-displacement form reaches `8C022`. The `8C000` base sites use displacements `0x20` and
    `0x60` (raw scan, whole SUB image).
- **The net (Unknown).** Neither image names a connection from P24 to MAIN `0xFFFF4E.b0`.
- **Circumstantial match (Inferred).**
  - P24 is a level output that is active while the audio is loud enough.
  - `0xFFFF4E.b0` is a level input that is active-set and polled only by the VOX keyer.
  - Both ends are gated by the same setting, `FF89BB`.
  - The MAIN keyer still samples bit 0 with Bluetooth on, while it releases `0xFFFF50.b6`.
  - P24 has no other consumer in the SUB.

### Corrections to earlier docs (owning docs not edited)

| Doc | Old claim | New bytes |
| --- | --- | --- |
| 124:315, `bluetooth\cites.tsv` row `FFF3B136` | P24 "clear at `FFF3B136`" | `FFF3B136 fb ee 22 c0 08` is the base load; the `bclr #4` is `FFF3B13B f0 ec`. A third writer, `FFF39E11 … f0 ec` (detector stop), and the init `FFF36F7B … f8 e4 00` are missing. |
| 124 path 12 ("headset audio") | P24 is the BT-VOX detector output | The detector is also started for VOX mode 1 without Bluetooth (`FFF385C5 … f8 e5 06`). P24 is a VOX-level output, not Bluetooth-only. |
| 05:673, `main-io\port_usage.tsv` row `FFFF4E` | Bits touched `2(bld),5(btst)`; funcs include `sub_458D8` | Bit 0 is read at `0x0106DC` / `0x010712 7e 4e 73 00`. b1, b3, b4, b6 and b7 are read by `mov.b`+mask (rows R02–R04, R07, R08, R12). `0x0458E6 2c 4e` is ASCII `",N"` in `$GPWPL`, not a reader. |

## USB relevance

None. No register on either path is a USB register:
- MAIN keyer `0x0105BE`–`0x010747`, key scan `0x00FAF6`–`0x00FBE6`, header `0x007DC0`–`0x007E56`;
- SUB `sub_FFF3850B`, `sub_FFF39D6B`, `sub_FFF3B115`, P2 `8C002` / `8C022`.

Q1 (USB surface), Q2 (no USB SDR) and Q3 (DSP on SCI-C) are unchanged. Docs 95, 96 and 97 stand.

## Open

1. **Board trace of MAIN `0xFFFF4E.b0` (PF0, Inferred).** Is it SUB P24, an on-board VOX comparator, or a
   wired-OR? Only hardware can settle this.
2. **The SUB level source.** Which ADC channel `sub_FFF15811` (mode 1) and `sub_FFF158BC` (modes 2–3) sample,
   and what `sub_FFF159DF`'s gate `1250A[2]` / `[4]` selects.
3. **The countdown site for `FF95A3` / `FF95A4`** (no direct reference), and the identity of output
   `0xFFFF50.b6`.

Files:
- `ida\out\port-bit0\sites.tsv` (43 rows);
- `verify.tsv` (88/88);
- `n13_verify.py`;
- `n13_rawscan.py`;
- `work\` (requests, outputs, `raw_cls.tsv`, `raw_cands_full.txt`).

Jobs: `ida\jobs\n13_dump.py`, `ida\jobs\n13_cls.py`. DBs: `N13_BIT`, `N13_BIT_SUB`.
