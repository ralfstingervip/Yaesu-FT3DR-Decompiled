# 35 — Channel-record field semantics and the 0xFF89C4 flag byte (lane F8)

Scope: static, read-only analysis of the owner's FT3DR ver 1.02 **MAIN** (H8S
advanced, `h8s300a`, base 0, big-endian) image. This lane closes doc 23 §5's
remaining Unknown channel-record fields and doc 23 Open #4/#6. No decompiler
exists for H8S; all evidence is raw bytes + disassembly. No image was modified;
nothing was written to a radio.

Evidence words: **Confirmed** (bytes/instruction read), **Inferred** (confirmed
evidence + a stated assumption), **Not found** (with the scope searched),
**Unknown**. Machine-readable table: `ida\out\chanrec\fields.tsv`. Raw dumps this
pass produced: `ida\out\chanrec\f8-senders.txt`, `f8-scan.txt`, `f8-ctx.txt`,
`f8-bits.txt`, `f8-misc.txt` (jobs `ida\jobs\f8_chanrec.py`, `f8_chanrec2.py`,
DB `ida\db\jobs\FIN_MAIN_REC`, copy-seeded from `MAIN_FULL`).

## Verdict

All six previously-Unknown channel-record fields are **resolved**. The record is
the **live per-band operating record** (not a bare memory-channel blob and not a
channel *number*): slot A at `[0xFF812A]+0x12`, slot B at `0xFF9102`
(`=0xFF90F0+0x12`), unpacked from the compact EEPROM/clone format at `0xFFAC76`
by `sub_3FB0C`. Confirmed: **packed +0x00 is a per-record flags byte** (its only
on-screen bit is bit 5 → `F321`); **packed +0x05** splits into a tone/code index
(`+0x16`→`F34A`), a mode sub-value (`+0x36` b4-5), and a 2-bit `+0x13`→`F400`
field; **packed +0x1E b4-5/b6-7** are the low and high halves of the per-band
**modulation-mode descriptor** at `+0x36` (b0-1→`F395`; b6-7 = mode group driving
the FM/AM/DN icon render); **packed +0x1F b7** selects which operating slot (A
main-band vs B sub-band) the record is written to; **packed +0x1F b0-2**→`+0x38`
(→`F340`); **packed +0x1F b3-7** is the `+0x39` **band-capability/gate byte**.
The `+0x39` gates are fixed-mode/fixed-step flags for special receive segments:
**bit 3 = force RX MODE = 2 (AM / air-band), bit 4 = force STEP = index 0x0C**;
bit 5 is an on-screen on/off (`F320`), bit 7 is the A/B-slot flag, **bit 6 is
unused**. For **0xFF89C4 bits 0, 5, 6, 7: Not found** — no individual reader or
toggler exists anywhere; they are touched only by whole-byte init (to the
constant 5) and the EEPROM block save/restore. Scope: every code head in
`0..0x80000` plus a whole-image raw byte scan.

## Method

- Seeded a private DB (`FIN_MAIN_REC`) from `MAIN_FULL.i64` via `run_job.py`
  (`--copy-from`), then `--reopen` for pass 2. Both scripts `auto_wait()`,
  wrap in try/except, write UTF-8, end `qexit(0)`.
- **Unpack / repack already on disk.** `sub_3FB0C` (unpack) and `sub_3FD48`
  (repack) are fully dumped in `ida\out\extension\menus-main5.txt` (from lane 6).
  Register roles, confirmed from the dump: `er5` = packed source (reloaded to
  `0xFFAC76` at `3FB3E`), `er6` = working dest = `[0xFF812A]+0x12`. Every reader
  uses `er0 = [0xFF812A]`, so **reader offset = unpack er6-offset + 0x12** — this
  is exactly why doc 23's "working +0x27 = working +0x39" holds (`0x27+0x12`).
- **Readers.** Pass 1 enumerated every caller of the three frame senders
  `sub_976A` (0x976A, byte), `sub_9792` (0x9792, word), `sub_98CA` (0x98CA) and
  `sub_9D82`/`sub_9CB2`, and scanned all code heads `0..0x80000` for
  `@(NN:16,er0)` reads/writes at the six target offsets (`0x12,0x13,0x16,0x36,
  0x38,0x39`). Pass 2 captured the bit selector (`bld/btst #n`) after each `0x12`
  and `0x39` read, dumped the `0x36` sender `sub_52CC`, the `0x16` remap family
  `sub_3EEEE..sub_3EFEE`, the STEP/MODE readers, and the band-plan builder
  `sub_E9CC/sub_EAD2`.
- **0xFF89C4.** Pass 1 listed every code reference (operand = `0xFFFF89C4`) with
  mnemonic + bit number. A raw-binary scan then ruled out the base+displacement
  form (`@(0xA4:16,erN)` with base `0xFF8920`): **0 sites**, and the block base
  `0xFF8920` is loaded at only 3 sites (`0x395C0`, `0x3CCC8`, `0x3CCD6` — the
  EEPROM block copy).
- **Not re-derived:** the SUB-side F3xx→label strings (the SUB dumps hold no
  direct F-code→string table; the six doc 23 §5 labels are reused as-is). The
  human mode/step *names* behind value 2 / index 0x0C live in the SUB label
  tables and are given here as Inferred from MAIN-side evidence.

## Channel-record field map

Conventions: `packed` = offset in `0xFFAC76`; `working` = `er0`-relative offset a
reader reads (`= unpack er6-offset + 0x12`). Full machine table in
`ida\out\chanrec\fields.tsv`.

### packed +0x00 → working +0x12 — per-record FLAGS byte (Confirmed)

Copied whole at unpack `3FB44 mov.b @(0,er5),r4l` / `3FB48 mov.b r4l,@(0,er6)`.
It is **not a channel number** — it is a bit-packed operating-flags byte with 61
code references. Bit map (all in `f8-bits.txt`):

| bit | meaning | evidence |
| --- | --- | --- |
| b0-1 | 2-bit sub-field, written by `sub_EC42` | `EC56` `and #0xFC`/`or`/store |
| b2-3 | 2-bit sub-field, written by `sub_EC20` | `EC34` `and #0xF3`/`or`/store |
| b4 | RF band/path flag → drives **output port 0xFF52 bit 5**, selects PLL tables `unk_30C3E`/`unk_30C86` | `0160E6 bld #4,r4l` then `bist #5,@0xFFFF52`; `sub_2F87C 02F880 btst #4` |
| **b5** | **on-screen on/off = `F321`**; also halves RF level (`shlr`) in the `sub_354E4` family (attenuator-like) | `sub_52E4`: `52E4 mov.b @(0x12,er0),r4l` / `52E8 bld #5` / `52EA mov.w #0xF321,e3`; `03552C btst #5` then `shlr.b r6l` |
| b6 | "custom STEP valid" gate (gates use of `+0x14`) | `sub_1DF7A 1DF7E btst #6` → read `+0x14`; `sub_1DCA6 01DCB6 bset #6` right after writing `+0x14` |
| b7 | flag (set in `sub_19xxx`, cleared `sub_3293A`) | `019526 bset #7`; `032960 bclr #7` |

On-screen reader: `sub_52E4` (bit 5 → `F321`). Remaining bits are internal
RF/tuning/scan state.

### packed +0x05 → three fields (Confirmed)

The 32-bit frequency read at `3FB70 mov.l @(2,er5),er4` deliberately zeroes its
low byte (`3FB76 mov.b #0,r4l`), so **packed +0x05 is a separate sub-byte**, split
three ways:

- **b0-3 → working +0x16** (`3FBC4 and #0xF`). Reader `sub_3EFEE` uses it as a
  4-bit index into per-band tables at `0x3C70/0x3C7C/0x3C88/0x3C94`
  (`3F000 mov.b @(0x16,er0),r4l` → `3F00A mov.b @(0x3C94,er4),r4l`), band-selected
  by `[0x817E].0`/`[0x8DD5]`/`[0x8AA0]`/`[0x8D20]`; result sent by `sub_57F8` as
  **`F34A`** (a tone/squelch-code group selector — Inferred).
- **b4-5 → working +0x36 bits 4-5** (`3FBDA and #0x30`). This is the per-band
  **mode sub-value**; live mirror `[0xFF8EB3]` (slot A) / `[0xFF8EC2]` (slot B),
  consumed by the display mode-render `sub_1CBE6` (`01CBF4 r5l=(0x36&0x30)>>4`)
  and rebuilt by repack helper `sub_1CC62`.
- **b6-7 → working +0x13** (`3FBCE and #0xC0; rotl #2`). Reader `sub_597E`
  (`597E mov.b @(0x13,er0),r3l` → `mov.w #0xF400,e3`) sends the 2-bit value as
  **`F400`**.

### packed +0x1E b4-5 and b6-7 → working +0x36 (Confirmed)

`+0x36` (`=er0+0x36 = er6+0x24`) is a **composite modulation-mode descriptor**
assembled from three sources (unpack `3FC9A`–`3FCB2`):

| +0x36 bits | source | meaning | reader |
| --- | --- | --- | --- |
| b0-1 | packed +0x1E b4-5 (`3FCA0 and #0x30; >>2`) | 2-bit field → **`F395`** (paired with `[0xFF89C7]`) | `sub_52CC 52CC and #3` → `F395` |
| b4-5 | packed +0x05 b4-5 | mode sub-value (A `[0x8EB3]`/B `[0x8EC2]`) | `sub_1CBE6 01CBF4` |
| b6-7 | packed +0x1E b6-7 (`3FCAA and #0xC0`) | **mode group** (value+2 ∈ {2..5}; A `[0x8EB6]`/B `[0x8EC5]`) — selects the FM/AM/DN icon group | `sub_1CBE6 01CBE6` `r5h=((0x36&0xC0)>>6)+2` |

So `packed +0x1E b4-5` and `b6-7` are the low 2 bits and high 2 bits of the
per-band modulation-mode descriptor; the display switch at `1CC18`/`1CC36` uses
`(r5h,r5l)` to pick the mode rendering (`sub_1CB20/44/68/8C/B0`). The precise
human mode names (FM/AM/DN/…) are on the SUB side (Inferred).

### packed +0x1F — slot select, +0x38, and the gate byte (Confirmed)

`sub_3FB0C` reads `3FB0C mov.b @(0x1F,er5),r4l` / `3FB10 btst #7,r4l`:

- **b7 (destination-slot select).** Set → `3FB32 mov.l #0xFF9102,er6` and
  `bset #0,@0xFFFF8EA6`; clear → working = `[0xFF812A]+0x12` (and conditionally
  `bclr #0,@0xFFFF8EA6`). This chooses the **operating record slot**: slot B
  (`0xFF90F0`, working `0xFF9102`) with `0x8EA6.0` as the "slot-B active" flag,
  vs slot A (`[0xFF812A]`). Slot A = **main/A band**, slot B = **sub/B band** —
  confirmed by: `sub_EAD2 EB60` sets packed `+0x1F = 0x98` when `er0==0xFF90F0`
  else `0x18` (bit 7 = "belongs to B"); `sub_3A5F8/sub_3A5B6` redirect `er0` to
  `0xFF90F0` when `8EA6.0` is set after unpack; and `sub_57BC` (`F347` TX power)
  reads a *different* power variable for `er0==0xFF90F0` (`57BC cmp.l #0xFF90F0`).
- **b0-2 → working +0x38** (`3FCBA and #7`). Sent as the high byte of **`F340`**
  (`04EB4 mov.b @(0x38,er0),r3h` … `04EC8 mov.w #0xF340,e3`, paired with
  `[0xFF8995]`); also consumed by PLL/mode code (`sub_2E610`, `sub_31A20`, …).
- **b3-7 → working +0x39** (`3FCC4 and #0xF8`) — the gate byte, next section.

## +0x39 gate bits

`+0x39` (= packed +0x1F b3-7, low 3 bits forced 0) is a **band-capability byte**,
read in 50 places (`f8-scan.txt`). It is not a UI value as a whole; individual
bits gate behaviour:

| bit | role | evidence |
| --- | --- | --- |
| **b3** | **FIXED-RX-MODE flag** → forces RX MODE display to **2** | `sub_5714`: `5714 mov.b #2,r3l` / `5716 mov.b @(0x39,er0),r4l` / `571A btst #3` / `571C bne` (skip load of `+0x19`) → `F322` carries 2. Also gates the frequency at `+0x1A` (`sub_1E63E 1E642 btst #3`), and is set/cleared by `sub_16BC0` (`16BE8 bset #3`). |
| **b4** | **FIXED-STEP flag** → forces STEP display to **0x0C** | `sub_580C`: `580C mov.b #0xC,r3l` / `580E mov.b @(0x39,er0),r4l` / `5812 btst #4` / `5814 bne` (skip load of `+0x14`) → `F391` carries 0x0C. Selects tuning tables `unk_170F8/170FE` (`sub_1700A`), `unk_1E07C` (`sub_1DF7A`), `[0xAE8C]` (`sub_2511E`); `sub_1700A 17084 bset #4`. |
| b5 | on-screen on/off = **`F320`**; propagates to RF/DSP shadow bits `0x8173.4` and `0x8176.1` | `04E70 bld #5` → `F320`; `sub_2F8E6 2F8F2 bld #5` then `bst #4,@0xFFFF8173`; `sub_3138E 3139A bld #5` then `bst #1,@0xFFFF8176`; toggled `015F56 bnot #5` |
| b6 | **unused / reserved** | **Not found**: no `btst/bld/bset/bclr/bnot/bst` on `@(0x39,er0)` bit 6 across all 50 refs |
| b7 | **A/B record-slot flag** (same bit as the b7 slot-select above) | `sub_1F1C8 1F1D2 btst #7`; cleared on commit `sub_3D022 3D352 bclr #7` and on clone-load `sub_75114 75118 bclr #7` |

**What the b3/b4 gates represent.** They are per-segment flags that *lock* the
mode and tuning step for receive-only band segments. The band-plan builder
`sub_E9CC`/`sub_EAD2` constructs such segment records with `+0x1F = 0x18` (bits 3
and 4 both set) — and `sub_E9CC` lays out the band table with a bound at
`0x10800000` = **108.00000 MHz**, the start of the VHF **air band**. Forced mode
value **2** with a mandatory step is exactly the air-band (AM-only) case; broadcast
and other RX-only segments reuse the same mechanism. So: **b3 = "mode is fixed
(AM / air-type), ignore the stored RX-mode field and show 2"**, **b4 = "step is
fixed, ignore the stored step field and show index 0x0C"**. The literal names
behind mode 2 and step index 0x0C (AM, and the air-band kHz step) are held in the
SUB label tables — Inferred here, strongly, from the 108 MHz band-plan evidence.

## 0xFF89C4 bits 0, 5-7

doc 23 Open #4 asked for any reader/toggler of bits 0 and 5-7 (bits 1-4 known).
**Complete enumeration of every access to `0xFF89C4`** (`f8-scan.txt`, operand =
`0xFFFF89C4`), plus a whole-image raw scan:

| bit | individual access? | sites |
| --- | --- | --- |
| b0 | **none** | — |
| b1 | yes | toggle `bnot #1 @16446`; read `btst #1 @17996,1655E,3E792,48D08,48D5C,49C30` |
| b2 | toggle only | `bnot #2 @1644E` (no `btst/bld` reader found) |
| b3 | yes | toggle `bnot #3 @1645E`; read `btst #3 @14AB8,14AD0,14B08,174A4,1F360` |
| b4 | yes | toggle `bnot #4 @16456`; read `bld/btst #4 @7C62,14EF2,2998C,1505A` + ~20 more |
| b5 | **none** | — |
| b6 | **none** | — |
| b7 | **none** | — |

**bits 0, 5, 6, 7: Not found.** No instruction anywhere tests or toggles them
individually. The *only* code that touches them is:
- whole-byte initialisation to the constant **5** (`E67C mov.b #5` → `0E67E mov.b
  r4l,@0xFFFF89C4`; restore-forces-5 `74AB4`/`074AB6`), and
- the EEPROM block save/restore of the `0xFF8920+n` region (block base loaded only
  at `0x3CCC8`/`0x3CCD6`/`0x395C0`).

Scope searched: all code heads `0x0..0x80000` (IDA, operand-resolved) **and** a
whole-image raw byte scan that also excluded the base+displacement form
(`@(0xA4:16,erN)`: **0 sites**). Consequence of default = 5 (`0b0000_0101`):
bit 0 is *persistently 1* but never consumed; bits 5/6/7 are persistently 0 and
never consumed. They are reserved/unused in ver 1.02 — **do not assume they are
free to repurpose without the EEPROM-map lane (F5) confirming the byte's
save/restore footprint**, but no firmware logic reads them.

## Open

1. **Human labels for `F320/F321/F340/F34A/F395/F400`.** The MAIN side gives the
   F-code and bit width; the on-screen strings require the SUB F3xx→row→label
   decode (lane 6 territory). Best MAIN-side inferences: `F321` = ATT-like level
   flag; `F320` = an RF/DSP modulation option; `F34A` = tone/code group.
2. **`+0x36` mode enumeration.** Confirm the `(b6-7+2, b4-5)` → modulation mapping
   (FM/AM/DN/…) against the SUB mode-icon strings and `[0x8EB3/0x8EB6]`.
3. **`+0x16` remap tables `0x3C70..0x3C94`.** Dump and type the four 16-entry
   tables to name the `F34A` value space.
4. **Confirm mode-2 = AM and step-index-0x0C = the air-band step** from the SUB
   step/mode label tables (this pass inferred it from the 108 MHz band plan).
5. **`+0x1F b6`**: reserved here; re-test if a later firmware revision is examined.
