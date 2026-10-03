# 24 — Host-surface extension map (Lane 7)

Static read of `decrypted\FT3D_MAIN_ver102_EXP.bin` (MAIN, H8SX/1668R group,
big-endian, load base 0; IDA `h8s300a`, valid). Private DB
`ida\db\jobs\EXT_HOST\EXT_HOST.i64`, seeded from `MAIN_FULL`. Script
`ida\jobs\full_l7_dump.py`; raw dumps `ida\out\extension\host-clone.txt`,
`host-clone2.txt`, `host-probe.txt`, `host-m.txt`; table `ida\out\extension\host.tsv`.
Nothing was written to a radio. Addresses are mapped CPU addresses = file offsets;
`0xFFxxxx` are on-chip RAM/SFR. Tags: **[B]** byte/instruction-confirmed, **[I]**
inferred, **[NF]** not found in stated scope.

This lane closes the holes doc 17 left in Surfaces B (clone), C (node link), and D
(USB), and maps the command surface a later owner feature would attach to. It is
protocol documentation only: no frame an owner could send is written here, and the
transmit `S` command, band coverage, the DSP `26AA:0020` loader, and any crafted
input stay out of scope by instruction.

## Verdict

All five doc-17 holes in scope are closed. The cable clone (Surface B) is a
one-shot streamed EEPROM image guarded by a **single 8-bit mod-256 checksum**, not
the 32-bit sum the card restore uses, with **no per-block ACK or per-block check**;
the only wire handshake is one `0x06` after the header. The five unknown node-link
`M` fields are decoded and the `M` path writes **only RAM**, never EEPROM directly.
USB vendor `D3` is a one-byte parameter-set request into a single RAM variable, and
`0xFF8184` is the USB state machine's working register, not a camera command set.
Command surfaces: node link = 9 inbound letters via `sub_6BAC8`; USB = 5 request
codes (GET_DESCRIPTOR + vendor D1–D4) via the classifier at `0x055590`. No surface
reaches arbitrary memory, flash, or the DSP loader.

## Method

- Ran `full_l7_dump.py` (spec-driven forced-code disasm / hex / xref / func-bounds,
  same engine as `pc_l1_dump.py`) over EXT_HOST in four passes: clone region
  `0x73540–0x73930` + helpers; clone ACK/timer/direction; node-link `M`
  parser/applier/validator + dispatcher; USB `D3`/state/`0xFF8184`.
- Did **not** run: any device I/O; the DSP `26AA:0020` loader (untouched); the host
  updater EXEs / DLLs (the MAIN image was sufficient — the dispatch tables are all in
  MAIN, so the `HOST_USB*` copy path was not needed); the transmit `S` internals.
- Settled negatives in `RESUME-DEEP.md` were not re-proved.

## Findings

### Surface B — cable clone `0x7358E–0x73920` (all six doc-17 items closed)

**Entry / port.** Power-on clone mode → `sub_73540` sets SCI_4 to **19200 8N1**,
polled (`BRR 0xFFFE91 = 0x19`, `SMR/SCR = 0`, `0xFF8004 = 1`) [B `0x73540`]. The
clone screen writes direction byte `0xFFBBC2`; `sub_2AD08` reads it: `== 1` →
`sub_7358E` (receive), else `sub_737FC` (send) [B `0x2AD0A–0x2AD18`].

**Frame shape.** 10-byte header = `"AH72M"` (5) + version byte (`= 2`) + region dword
(4) [B: builder `sub_7390A`; check `sub_737C8` vs template `0x738A2`]. Then the data:
**0x3FB blocks × 64 B** from EEPROM `0x140`, **0x3FC blocks × 64 B** from `0x10100`,
then **one trailer byte** [B `sub_7358E`/`sub_737FC`]. Those are exactly the
`BACKUP.dat` ranges — same bytes as the card image.

- **Per-block ACK — none.** The only wire handshake is a single `0x06` the receiver
  sends after the header+ID pass (`sub_7358E` → `sub_73AB4` at `0x735D0`, which
  transmits the byte at `0x73908` = `0x06`) [B]. The sender transmits its header once
  and then loops waiting for `0x06` before streaming (`sub_737A8` at `0x737A8`,
  `cmp #6` at `0x737C0`) [B]. `sub_73686`/`sub_736B6`, which doc 17 flagged as
  possible per-block ACKs, only write a 1–10 progress-segment value to display var
  `0xFFA9DD` and set event bit `0xFF817E.1` — they touch no SCI register [B].
- **Per-block check — none.** No checksum is sent or verified per block [B].
- **Final byte / checksum.** A single running **8-bit mod-256 sum** is kept in
  `0xFF812E` over the 10-byte header **and every data byte** (accumulated on receive
  in `sub_7374A` when state `0xFF8131` ∈ {1,2} at `0x73776`; on send in `sub_738CC`
  when state == 3 at `0x738EC`). The trailer byte is that sum. Receive reads the
  trailer into `0xFF812F` (with state 0, so it is not summed) and compares
  `0xFF812E == 0xFF812F`; mismatch → error state 4 [B `0x7365E–0x73668`].
- **Whether receive checks the 32-bit sum — NO.** Receive verifies only the 8-bit
  sum above. This is weaker than, and different from, the 32-bit big-endian sum the
  `BACKUP.dat` card restore checks. An owner clone tool must compute the 8-bit sum for
  the cable path, not the 32-bit sum [B].
- **Timeouts.** Header receive waits **unbounded** for the sync byte `'A'` (0x41)
  (`sub_736E6` loops on the RX ring, servicing timers `sub_3576`/`sub_325A`, with no
  exit until `'A'` arrives) [B]. Each subsequent byte (blocks and the ACK) has a
  timeout of **0x4B0 (1200) counts** of timer flag `0xFF94B8` (also serviced by
  `sub_3576`/`sub_2A30`); expiry returns error 1 [B `0x7374A`]. Wall-clock per count
  is tied to the system tick and is not pinned here [I].
- On a good receive the radio commits to EEPROM (writers `sub_3B770`, `sub_3C99C`) and
  **reboots** (`orc #0x80,ccr; jmp 0x2050`) [B `0x7366A–0x73674`]; on send it restores
  the port via `sub_734C2` [B].
- A NAK byte `0x15` exists (`sub_73AB4` alt entry `0x73AC2`, byte at `0x73909`) but is
  used only by the extended clone-variant family (callers `0x73BD6…0x74466`), not by
  the full-image path in scope [B].

### Surface C — node-link `M` fields and EEPROM question

Payload byte `p` is at `0xFF1ACE + p`. Every field accepts `'F'` = no change. The
five fields doc 17 left unknown, now decoded in `sub_25EAE`:

| Locator | doc-17 name | Effect | Gate |
| --- | --- | --- | --- |
| `0xFF1AE5` | p23 | `'0'`/`'1'` → **VFO+0x12 bit 5** (1-bit mode flag) | mode A only [B `0x26010`] |
| `0xFF1AE6` | p24 | 0–3 → **VFO+0x16** (small enum; likely TX power) | mode A only [B `0x26040`] |
| `0xFF1AED` | "p33" | bit0 → **`0xFFB3D3`** (node-protocol var, not VFO) | always [B `0x260C2`] |
| `0xFF1AEE` | "p34–35" | 2 hex nibbles, value <0x80 → **`0xFFB3D4`** | always [B `0x260E0`] |
| `0xFF1AF0` | "p36" | 0–3 → **VFO+0x13** via table `0x2613A` (likely mode) | mode A only [B `0x2610E`] |

**Whether an `M` retune is stored to EEPROM — NO (in the M path).** The applier
`sub_25D72` writes only the in-RAM VFO struct (`er0`-relative offsets 0x12–0x1E) and
calls PLL/retune/display helpers (`sub_1BFEC`, `sub_1C0DC`, `sub_1C050`, `sub_3A29C`,
`sub_3A2D0`, `sub_3F3B4`); it contains **no call to the EEPROM writers**
(`sub_3B770`/`sub_3C99C`) [B `0x25D72–0x25EAC`]. Whether the radio's normal
power-off/menu settings-save later flushes that RAM image to EEPROM is a separate
mechanism, not invoked by `M` [I; not exercised]. Frequency/shift/offset/CTCSS/DCS are
staged into `0xFFB392`/`0xFFB396`/`0xFFB39B`/`0xFFB39C` and validated by `sub_3F522`
(a plausibility gate on `0xFF817E.0`) before apply [B].

### Surface D — USB vendor `D3` and `0xFF8184`

- **`D3` (`0x41D3`, host→device vendor OUT).** `sub_554E6` (`0x0554E6`) copies the
  SETUP `wValue` low byte (`0xFF3D6C`) into RAM variable **`0xFFB096`**, sets the USB
  state var, and ACKs the status stage [B]. `0xFFB096` has exactly one consumer
  (`0x00FDC8`, a byte read) [B]. So `D3` is a **one-byte parameter-set** request; its
  effect is confined to that variable. No memory, flash, clone, or node-link reach [B].
- **`0xFF8184`.** Not a camera command set: it is the **USB state machine's working
  register** (a dword), written/read by the on-chip USB ISR `sub_54EC2`
  (`0x054F1C`/`0x054F4E`), the state handlers (`0x0551DA`, `0x055306`, `0x055336`,
  `0x055496`), the EP3 report builder `sub_557A2`, and `sub_55FFE` [B: 14 xrefs]. The
  "command values" doc 17 asked about are the transient SETUP/parameter dwords the
  machine parks there during a transfer, not a distinct request vocabulary [B].

## Extension

A later owner-side command would attach to one of two in-image dispatchers; both are
byte-confirmed and neither reaches memory/flash/DSP:

- **Node link:** `sub_6BAC8` at **`0x6BAC8`** — an inline `cmp.b` chain on the command
  letter at `0xFF1AC9`, **8 explicit entries** (`B C E F N S V W`) with the default at
  `0x6BB04` (unknown letters → ignored). The gate-phase letters `V`/`M` are handled
  before this (`M` parser `sub_25EAE`). This is a compare chain, not a jump table, so a
  new letter is a new `cmp/beq` pair; there is no spare table slot.
- **USB:** the SETUP classifier at **`0x055590`** (compares the `bmRequestType:bRequest`
  word against `0x8006,0xC1D4,0x41D1,0x41D2,0x41D3`), backed by the 12-entry poll-loop
  **state table `0x055002`** (dispatched from `0x054FEC`) and the SETUP-template table
  **`0x0558FE`**. A new vendor request is a new compare here plus a new state handler.

## Counts

- **Node-link command letters (inbound):** implemented **9** (`V M B C E F N S W`);
  stub **0**; absent = every other ASCII letter (no handler; default at `0x6BB04`).
  Radio-generated outbound letters (`P H R G`, plus echoes) are not inbound commands.
  Dispatcher `sub_6BAC8` @ `0x6BAC8`; entries 8 + default; gate `M` parser `sub_25EAE`.
- **USB request codes:** implemented **5** — `0x8006` GET_DESCRIPTOR + vendor
  `0x41D1`/`0x41D2`/`0x41D3`/`0xC1D4` (D1/D2/D3/D4); stub **0**; absent = every other
  vendor `bRequest` (D0, D5–DF, …) and non-enumeration standard requests beyond the
  ISR's chapter-9 set. Classifier `0x055590`; state table `0x055002` (12 entries);
  template table `0x0558FE`.
- **Doc-17 holes closed vs open:** Surface B — 6/6 closed (per-block ACK, per-block
  check, final byte, timeouts, 32-bit-sum question, + NAK note). Surface C — 5/5 `M`
  fields closed + EEPROM-persistence question answered for the `M` path. Surface D —
  `D3` and `0xFF8184` closed. Still open (below), none in this lane's scope.
- **Functions given a purpose (start addresses)** for the function lanes to reconcile:
  `sub_2AD08`, `sub_73540`, `sub_7351E`, `sub_7357A`, `sub_7358E`, `sub_734BE`,
  `sub_734C2`, `sub_734F4`, `sub_736E6`, `sub_73686`, `sub_736B6`, `sub_7374A`,
  `sub_737A8`, `sub_737C8`, `sub_737FC`, `sub_738AC`, `sub_738CC`, `sub_7390A`,
  `sub_73AB4`, `sub_73AEC`, `sub_73AFE`, `sub_25EAE`, `sub_25D72`, `sub_3F522`,
  `sub_6BAC8`, `sub_554E6` (`0x0554E6`).

## Open

1. Wall-clock value of the clone per-byte timeout (`0x4B0` counts of `0xFF94B8`);
   structurally closed, the tick period is not pinned [I].
2. The exact semantic labels of the `M`-driven VFO fields (VFO+0x12 bit5, VFO+0x13
   mode table `0x2613A`, VFO+0x16) — the bytes and destinations are confirmed; the
   menu labels are not in this package [Unknown].
3. Whether the normal settings-save persists an `M` retune to EEPROM (separate save
   path, not exercised here) [I].
4. The single consumer of the `D3` byte at `0x00FDC8` — confirmed to read `0xFFB096`;
   its downstream use in the camera/transfer path not traced further [I].
