# PC lane 4: what puts SUB `0x8C4E` at 8 (DSP WRITE MODE)

Lane 4 of 7 (residual #2 in RESUME-DEEP). Static analysis of the decrypted images only;
nothing was written to a radio. Chain table: `ida\out\pc\L4-dsp-write-chain.tsv` (23 steps,
each with address, value, evidence and confidence). Raw dumps: `ida\out\pc\PC_L4_MAIN_*.txt`,
`PC_L4_SUB_*.txt`. Private DBs: `ida\db\jobs\PC_L4_MAIN` (seeded from MAIN_FULL) and
`PC_L4_SUB` (seeded from SUB_UPPER). Scripts: `ida\jobs\pc_l4_dump.py`, `pc_l4_grep.py`,
`pc_l4_ctx.py`.

## Answer

**The only way in is a physical key held at cold power-on.** That is the key on bit 1 of
keypad column `0xFFFF4C` (port reads `0x7D`, internal key code `0x11`). No PC command, no
CAT/clone traffic, no USB request and no microSD file leads to this mode. A CAT soft reset
actively bypasses the check (see below).

`0x8C4E` is not a settings byte. It is the **low byte of the opcode of the last `0xF0xx`
status frame** that MAIN sent over the inter-processor link. SUB RAM `0x00008C4D`
(absolute RX RAM address, since the literal is `mov.l #8C4Dh`) holds a copy of that frame
starting at the opcode byte. DSP WRITE MODE is MAIN sending **opcode `0xF008`**, and MAIN
sends `0xF008` only while its UI mode is `0xEE`.

## The chain (MAIN → SUB)

1. **Strap.** `sub_20FA` at `0x21FA` clears `0xFF813A`, then polls `@0xFFFF4C & 0x7F == 0x7D`
   up to 200 times (`0x21FE`–`0x220A`). If the key is held it sets `0xFF813A = 1` (`0x2224`)
   and starts the CDC-ACM USB personality and the USB↔DSP queue (`jsr loc_78106`, `0x2234`).
   Nothing else writes `0xFF813A` (14 xrefs, 2 writes).
2. **Boot key-combo dispatcher `loc_10168`.** It is called once, from `reset_handler` at
   `0x2B52`. It has two gates:
   - `@0xFF816F != 0` skips everything (`0x10172`). This is a warm-start flag. The CAT/soft-reset
     entry `loc_2050` sets it to 1 (`0x2068`) and jumps to `loc_DC5A` without running
     `sub_20FA`. A cold boot clears it (`0x218C`).
   - `0xFF89C2` bit 0 set means only combos `0x0F`/`0x7E` are honoured (`0x1018E`).
   Past the gates, `sub_103C0` is reached in one of two ways:
   - **Route A:** `0xFF813A != 0` (`0x101B2`→`0x101B8`).
   - **Route B:** the raw port value matches entry 8 of the combo list at `0x10216`
     (`0x7D`), whose handler at `0x10242[8]` is `0x103C0`.
   Both routes need the same key.
3. **`sub_103C0`** clears loader state `0xFFB0C4` and pushes UI mode **`0xEE`** into the current
   UI context (`er0 = @0xFF812A`, byte +1) via `sub_3FF10`. This is the only immediate write
   of `#0xEE` anywhere in MAIN.
4. **Main loop** (`0x2C2C`–`0x2C44`): when the mode is `0xEE`, the loop only ticks the DSP loader
   `sub_5DCFE` (`0x2CE6`) plus housekeeping. The whole normal radio block `0x2C48`–`0x2CE2`
   is skipped.
5. **Status-frame builder by mode**: dispatch `0x6C62`–`0x6C78` reads table
   `0x782C + 4*mode`. The entry `0x782C + 4*0xEE = 0x7BE4` holds `0x0005E9E2`, which is the
   image's only reference to `sub_5E9E2`.
6. **`sub_5E9E2`** maps loader state to (phase, progress):
   - state below 5 → (0, 0)
   - states 5–6 → (1, 3), or (1, 6) when `0xFF813A` is set
   - state 7 or higher → (2, 10)

   It then calls **`sub_8532`**, which writes:
   - total length `0x2A` at `0xFF3D72`
   - **opcode `0xF008`** at `0xFF3D74`
   - length `0x20` at `0xFF3D76`
   - common payload `0xFF3D7A`–`0xFF3D93`, filled by `sub_7C20`
   - **phase at `0xFF3D94`** and **progress at `0xFF3D95`** (frame offsets +0x20/+0x21)
7. **Link**: MAIN SCI-D `0xFFF610` → SUB SCI0 (frame format per doc-09).
8. **SUB receive**: `sub_FFEDC1F6` dequeues a 300-byte slot. The slot starts at the opcode
   byte: slot[0..1] is mirrored to `0x84C8/0x84C9`, the same place the RX parser stores
   frame+5/+6 = opcode. It then `memcpy`s the slot to **`0x00008E46`** (`sub_FFEF0385`, sole
   caller). So `0x8E46 = 0xF0` and `0x8E47 = 0x08`.
9. **SUB dispatch**: `sub_FFEDF1D8` switches on `0x8E46`, and for `0xF0` `sub_FFEDF269` switches
   on `0x8E47`. The mapping is 8 → screen id 0x18, and 2/5/7/9/A/B → 0x12/0x13/0x17/0x19/0x1A/0x1B.
   Handler table `0xFFED4050` sends all of these to the boot-screen family `sub_FFF0CDFC`.
10. **Shadow copy** in `sub_FFEEB057` (`0xFFEEB09F`–`0xFFEEB0AB`) does `[0x8C4E] = [0x8E47]`.
    Dispatcher `sub_FFF0D6D9` then sees `cmp #8` → `sub_FFF0DE56` "---DSP WRITE MODE----".
    Its case set {2,5,7,8,9,A,B} is exactly the set of `0xF0xx` builders at `0x8060`–`0x862E`.

**Cross-check of the frame↔shadow alignment.** The DSP-write screen reads `0x8C4D+0x20`:

- 0 → "Push DISP Key!" highlighted
- 1 → "Loading..."
- 2 → "Complete"

It also reads `0x8C4D+0x21` as a 0–10 progress bar, which the screen clamps to at most 9
during phase 1 and forces to 10 at phase 2. These are exactly the phase and progress values
`sub_5E9E2` puts at MAIN frame +0x20/+0x21.

## What the radio does once in the mode

- SUB shows `---DSP WRITE MODE----` / `Push DISP Key!`.
- On MAIN, the UI-mode-`0xEE` key row has one live key and 16 no-ops. The address is
  `0x125D4 + word_1208C[0xEE-1] (0x21BC) + 3*4 = 0x1479C`, and slot 3 points to `0x5DCD8`,
  which starts the loader. Slot 3 is inferred to be **DISP** from the SUB prompt.
- The loader powers the DSP, pulses RESET, holds BOOT-MODE (`0xFFFF52` b3/b4), switches the DSP
  SCI to async, handshakes on `0xFFFF49.7`, then relays bytes between USB EPDR `0xFFEE2C`
  (CDC-ACM, PID `0x0020`) and the DSP's serial port. There is no DSP image in either firmware
  image, so the host has to supply it over USB.
- State 7 is terminal, and no transition out of mode `0xEE` was found. The exit is inferred
  to be a power cycle (medium confidence).
- Normal RX/TX, CAT servicing and the DSP trace do not run while in the mode:
  `0x2BE6`/`0x2C0A` skip `loc_54FEC`, `loc_6FD82`, `sub_545AC` … `sub_453A0` when `0xFF813A` is set.

## Implications for the PC program

- **It cannot enter the mode, even by accident.** None of these can reach it:
  - the DATA-jack CAT/clone stream
  - the CAT soft reset, which sets `0xFF816F = 1` and so suppresses the boot-combo check
  - SD files, since SUB's `0x8E46` is written only from the IPC queue and SUB sends nothing
    that sets MAIN's `0xFF813A` or mode `0xEE`
- **It must not talk to a radio that enumerates as USB `0x26AA:0x0020` (CDC-ACM).** That
  personality means the key was held at power-on. Bytes sent after DISP go straight into the
  DSP's boot loader. The program should refuse and tell the user to power-cycle normally.
- **A clone write that sets `0xFF89C2` bit 0 would disable the entry**, not enable it. The
  meaning of that bit is unknown, so a PC program should preserve it byte-for-byte.

## Still unknown

- The physical legend of key `0x11` (residual #1, a hardware question).
- Which key slot 3 is. DISP is inferred from the prompt and not mapped from the keypad matrix.
- The meaning of `0xFF89C2` bit 0.
- The exact MAIN call site that pushes the built F0 frame through `sub_B6B6`. It is implied by
  the dispatcher and the matching SUB-side values, but was not re-traced.
- The DSP boot-loader byte protocol (doc-09 open item 4).

## Corrections to earlier docs

- doc-09 and doc-12 call `0x8C4D`/`0x8E46` "the settings block". It is actually the
  last-received IPC frame: `0x8E46` is a raw 300-byte copy starting at the opcode, and
  `0x8C4D` is its field-by-field applied shadow.
- `0x8C4E` is the `0xF0xx` opcode low byte, i.e. the screen selector.
