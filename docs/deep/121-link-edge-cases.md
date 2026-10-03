# 121 — SUB↔MAIN link edge cases: length mismatches, framing safety, and the SUB state gates (Lane M9)

> Lane M9, model `claude-opus-5-5` (model ID `claude-opus-5-5`). Private DBs
> `M9_LINK_MAIN` (MAIN, `--copy-from ida\db\jobs\L1_MAIN_FINAL5\L1_MAIN_FINAL5.i64`) and
> `M9_LINK_SUB` (SUB, `--copy-from ida\db\jobs\K7_SUB_FINAL3\K7_SUB_FINAL3.i64`), iterated with
> `--reopen`. Jobs: `ida\jobs\m9_dump.py` (copy of l12_dump), `ida\jobs\m9_refscan.py` (copy of
> l12_refscan). Read-only apart from IDA's own state; no image byte changed (sha256 MAIN
> `8e3ecd05…`, SUB `b93570b3…`, checked in `verify.py`). No shared DB opened, nothing connected to
> a radio, closed MAIN window `0x078106`–`0x07B753` not entered. Tables: `ida\out\link-edges\`
> (`frames-sim.tsv`, `sub-state.tsv`, `verify.py` 58/58 PASS, raw dumps in `work\`). MAIN is H8SX
> big-endian, base 0 (file offset = addr). SUB is RX little-endian at `0xFFC00000` (file offset =
> addr − `0xFFC00000`). Builds on L11 (doc 108), L12 (doc 109), L10 (doc 107).

## Verdict

**None of the SUB↔MAIN frame-length mismatches can drop, corrupt, or swallow a frame, and none
can cause or prevent a TX key/unkey.** The deframer is self-healing at every frame boundary, for
two confirmed reasons. First, **every SUB frame is followed by exactly six zero pad bytes** (the two
common-format builders `sub_FFEDD182` and `sub_FFEDD528` each write six `#0` bytes after the
checksum; `verify.py`), and MAIN's start-byte-detect state **skips every zero byte** before looking
for a start byte (`0x04761E 0c ac` / `0x047620 47 d8`, *verified*). Second, for the three
variable-length types (E1, FE, FF) MAIN **overrides its initial fixed byte-count with the frame's
own length field at index 3**, and **every type's checksum span is derived from the length field,
not from the read counter** — so validation always covers exactly the bytes SUB actually sent. The
one genuine over-read is **E2**: MAIN's hard-coded count is `0x10`=16 (expecting payload n=3) while
SUB sends E2 with n=2 (frame proper 15 bytes). MAIN therefore reads **2 bytes past** the E2 frame —
but those two bytes are SUB's transmitted pad zeros, the checksum (span = `byte3`+2 = 13 real bytes)
still validates the true 15-byte frame, and the remaining 4 pad zeros are skipped. An **E6 PTT frame
following an E2 is not swallowed**: MAIN resyncs on the 4 leftover pad zeros and reads E6's `0xE6`
start byte cleanly. The "FF 277 vs 273" is not a mismatch at all — 273 is the length field (n+9),
277 is the frame proper, and MAIN's length-driven count consumes exactly 277.

On the SUB state: **`0x12CB8`** is the SUB-side Bluetooth/SCO link-state gate (0 none / 1 SCO-up /
2 BT-active-link); as the second gate on the CKPD-button→E6 path it is *permissive* — when `==2` it
lets the headset button key TX even if MAIN's status byte `[0x1229D]` is not `0x20`. **E5
(tracking `0x12CBA`) has zero TX effect on MAIN** because its destination `0xFFBB92` and flag
`FFBA92.b4` are never read on the MAIN side (confirmed by refscan). **`0x8A86`** is a GPS
power-save mode flag (mirror of `0x12180`) that suppresses the E1 GPS relay and reprograms TPU3 to a
slow tick (`TGRA=0xB71A`); it *delays* but never blocks the SUB→MAIN tick that emits E6, and MAIN's
TOT remains the backstop, so it cannot cause a stuck TX.

## Method

- Seeded both private DBs and dumped the full MAIN deframer (`sub_4753E`, start-byte switch
  `sub_4761E`, state table `0x0475C8`, ISR `sub_44A70`, link-init `sub_44700`, and all ten handlers
  E0–FF) and the five SUB builders (`sub_FFEDD182`, `sub_FFEDD528`, `sub_FFEDD6FB`, `sub_FFEDD8DC`,
  transmit `sub_FFEDAF2D`) plus the `0x8A86` dispatcher and the TPU3 reprogram/restore pair.
- Operand-scanned MAIN `0`–`0x80000` for every deframer cell (`FF9D2A/2C/2D`, `FFBC4C`, `FFBA94`,
  `FFBC60`, `FFBB92`, …) and the SD-request fields `FFBA94`–`FFBAA3` to pin the counters and the
  length overrides (`work\om2_refs.tsv`, `om4_refs.tsv`).
- Byte-checked all 58 cited runs straight from the two images with `ida\out\link-edges\verify.py`:
  **58/58 PASS**, images unchanged.
- **Not done:** I did not re-decode the full E1 NMEA collector arithmetic to a per-byte total (I
  state only that MAIN tracks the length field, which is what Task 1 asks); the Bluetooth module
  wire protocol below SCI3 is out of scope; the headset-SCO-drop-while-keyed hardware case
  (doc 107 Open #1) remains a hardware question.

## Findings

### 1. The read counter is per-type and fixed in the start-byte switch (Confirmed)

`sub_4761E` matches the start byte against the ten constants and, for each, writes the remaining
byte count to `FF9D2C` and the next state to `FF9D2D`. The counts (all *verified*, `verify.py`):

| type | state | `FF9D2C` (bytes after byte0) | total read | set at |
| --- | --- | --- | --- | --- |
| E0 | 2 | `0x11`=17 | 18 | `0x4766A`/`0x476E4` |
| E1 | 3 | `0x7F`=127 (init) | **recomputed** | `0x476C6` |
| E2 | 6 | `0x10`=16 | **17** | `0x47688` |
| E3 | 4 | `0x0F`=15 | 16 | `0x4766A` |
| E4 | 9 | `0x29`=41 | 42 | `0x4777A` |
| E5 | 0xB | `0x0D`=13 | 14 | `0x47702` |
| E6 | 0xA | `0x0D`=13 | 14 | `0x4775C` |
| EA | 8 | `0x0D`=13 | 14 | `0x4773E` |
| FE | 7 | `0xC7`=199 (init) | **recomputed** | `0x47720` |
| FF | 5 | `FFBC4C`=`0x110` (init) | **recomputed** | `0x476A6` |

### 2. E1, FE, FF override the fixed count from the frame's length field (Confirmed)

At index 3 (the length-low byte) each variable handler recomputes:
- **E1** `sub_47B7C`: `0x047BC4 aa 85` (reject `byte3 ≥ 0x85`), `0x047BCC` `FF9D2C = byte3−1`,
  `0x047BD6` `FFBBE6 = byte3−9` (payload size).
- **FE** `sub_47E2C`: `0x047E7C` `FFBA94 = (byte2:byte3)−1`, `0x047E80 79 24 04 01` reject `> 0x400`.
- **FF** `sub_47A7E`: `0x047AD2 79 24 01 12` reject `≥ 0x112`, `0x047AD8` `sub.w #2`, `0x047ADC`
  `FFBC4C = len−2`.

So the fixed inits (`0x7F`, `0xC7`, `0x110`) are never the operative count; these three track SUB's
variable length exactly. **The "FF 277 vs 273" is length-field (n+9 = 273) vs frame-proper (277);
MAIN consumes 277.** Likewise E1 (13+n) and FE (154+data) track the field, not MAIN's old fixed
128/200.

### 3. The checksum span comes from the length field, not the read counter (Confirmed)

Every handler validates the frame checksum over `byte3 + 2` (or `byte2:byte3 + …` for the 16-bit
types) bytes, reading the expected sum from the two bytes immediately after. E2 example
(`sub_4799A`): `0x047A42 6e 5a 00 03` (r2l = `byte3`), `0x047A48 8e 02` (`+2`). For E2, `byte3` =
`n+9` = 11 = `0x0B`, so the span is 13 bytes (indices 0–12) and the sum sits at indices 13–14 — i.e.
exactly SUB's real 15-byte frame. **So even when the read counter over-shoots (E2), the checksum
still validates only the true frame.**

### 4. The pad + zero-skip safety net (Confirmed) — resolves every mismatch

Both common-format builders append **six** `#0` pad bytes after the checksum (`verify.py` counts 6
in `sub_FFEDD182` and 6 in `sub_FFEDD528`; wire length = header 11 + n + checksum 2 + pad 6 =
**n+19**). The start-byte-detect state skips zeros (`0x04761E 0c ac`; `0x047620 47 d8 beq
loc_475FA`, which fetches the next ring byte and loops). Consequences:

- **E2 (15 vs 17).** MAIN reads 17 = 15 real + 2 pad. Checksum validates the 15. Of the 6 pad, 2
  are consumed and **4 remain**; the deframer resyncs to state 1 and skips them.
- **E6 PTT following an E2 — not swallowed.** After E2, 4 pad zeros remain before E6. State 1 skips
  them and lands on E6's `0xE6`. E6 keys/unkeys normally. The same holds for any frame after any
  other: a frame's start byte (`0xE0`–`0xFF`) is always preceded only by pad zeros, so resync is
  exact. **No short/long frame can corrupt or swallow its successor.**
- **No under-read anywhere.** Every type except E2 consumes exactly its frame-proper length (fixed
  types) or the length-field count (E1/FE/FF); E2 alone over-reads, by 2, into pad. MAIN never
  leaves a real (non-pad) byte in the ring, so nothing bleeds into the next frame.
- **Error path is also self-healing.** On a header-sum or frame-sum mismatch the handler jumps to
  `loc_475A4`: `0x0475A8` `FFBAA8 = index`, `0x0475AE` `FF9D2D = 1` (resync), and if `FF89C4.4` is
  set, `0x0475C0` raises tone `FFAAE0 = 0x1B`. State 1 then skips zeros and resyncs at the next
  non-zero start byte.

### 5. SUB state: `0x12CB8`, E5/`0x12CBA`, and the `0x8A86` GPS mode (Confirmed bytes)

- **`0x12CB8` — Bluetooth/SCO link-state, 2nd gate on the CKPD→E6 PTT path.** Values: 0 (none),
  1 (SCO just up, `0xFFF38F7B f8 e5 01`), 2 (BT active, `0xFFF3862D`/`0xFFF38660 f8 e5 02`, set
  right after the BT on/off helpers `sub_FFF158F0`/`sub_FFF15845`). In the CKPD toggle
  `sub_FFF39216` (doc 107), an E6 is emitted only when `[0x1229D]==0x20` **or** `[0x12CB8]==2`. So
  `0x12CB8==2` is *permissive*: it lets the headset button key TX even when MAIN's status byte
  `[0x1229D]` (= MAIN `FF3D8C`, which encodes BT-on ∧ VOX-off) is not `0x20`. It is a gate on
  whether the button *produces* an E6, not a TX bit itself.
- **E5 / `0x12CBA` — inert on MAIN.** E5 (7 send sites, doc 109; builder `sub_FFEDD528`, e.g.
  `0xFFF394CF`/`0xFFF39516 75 41 e5`) tracks a second Bluetooth link-state word `0x12CBA` (1/2,
  `0xFFF394A9`/`0xFFF394F0`). **MAIN stores E5's payload to `0xFFBB92` and sets `FFBA92.b4`, but no
  MAIN code reads either** (refscan `work\om2_refs.tsv` finds the single writer `0x0482C8` and no
  reader; confirms doc 108). **E5 has no TX effect whatsoever.**
- **`0x8A86` — GPS power-save mode (mirror of `0x12180`).** Set to 1 at `0xFFEDCE95 f8 e4 01` and
  cleared at `0xFFEDCEB9 f8 e4 00`, in the MAIN-frame dispatcher, when the opcode hi byte is `0xF3`
  (`0xFFEDCE5E 75 51 f3`), the opcode lo is 1 (F301) or `0xC0`/`0xC1` (F3C0/F3C1), and frame
  byte `[0x18] == 3` (`0xFFEDCE7E 61 31`). That same branch calls `sub_FFF36B9D` to reprogram TPU3
  (`0xFFF36BE2 f9 e9 04 1a b7` → `TGRA = 0xB71A`, a slow tick); the clear branch calls
  `sub_FFF36B1E` to restore it. When `0x8A86 == 1`, the E1 GPS relay is suppressed (doc 109 §3).
  **TX impact: none that can stick.** The TPU3 tick fans out the SUB→MAIN builders (touch, GPS,
  link); slowing it *delays* an E6 PTT (key or unkey) frame but never blocks it, and MAIN's TOT
  (`FF95EA`, 180 s default) remains the unconditional unkey backstop.

## USB relevance

- **Q1 (USB):** none. The SUB↔MAIN link is SCI only; no deframer cell, builder, or state gate
  touches USB `0xFFEE00` (MAIN) or USB0 (SUB, dark). No new surface.
- **Q2 (SDR):** none. The densest frame is still FE (≤0x400 B of SD data); the link is a UART.
- **Q3 (DSP):** none. No frame or state gate reaches SCI-C (the DSP bus).
- **Owner-relevant TX findings (all static):** (a) the E2/FF/E1/FE length "mismatches" are benign —
  no frame can corrupt or swallow an E6 PTT frame, so headset/remote PTT over the link is robust;
  (b) `0x12CB8==2` broadens when a Bluetooth-headset button can key TX (even without MAIN's VOX-off
  status byte); (c) the `0x8A86` GPS power-save mode only *delays* E6, never stalls a key/unkey.

## Open (most valuable first)

1. **E1 NMEA collector exact byte total.** I confirmed MAIN recomputes from `byte3`; a per-byte
   trace of `sub_47BF6` would close the last count to the byte (low value; E1 is pad-protected
   regardless).
2. **What MAIN state sends F301/F3C0/F3C1 with `[+0x13]==3`** (the `0x8A86` trigger) — the MAIN
   sender side; would name the GPS power-save menu item.
3. **FE date-byte decode on MAIN** (`(tens<<4)|(v&0xF)`, doc 109 §7) — how MAIN recovers the tm
   fields; not TX-relevant.
4. **`0x1229D`/`FF3D8C` bit semantics** (the first E6 gate) — settle the VOX/BT-save labels
   (doc 107 Open #3).
