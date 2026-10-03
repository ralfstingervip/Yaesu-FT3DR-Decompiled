# 91 — DATA-jack CAT/clone command set on MAIN: opcode semantics (lane K9)

Owner-side static analysis of `decrypted\FT3D_MAIN_ver102_EXP.bin` (MAIN, H8SX,
big-endian, base 0). Private DB `K9_CAT` seeded from `J1_MAIN_FINAL3`. No device
was touched; nothing was written to a radio; `decrypted\*.bin` unchanged. The
CDC-ACM / DSP-download window `0x078106`–`0x07B753` was not entered. Machine
tables: `ida\out\cat-opcodes\cat-opcodes.tsv`, `dump-reset-paths.txt`,
`clone-format.txt`. Model running as: my environment reports **`claude-opus-5-5`** (named "Opus 5.5");
prior waves' lanes observed the exposed Opus as `claude-opus-4-8`, so treat the
exact build as that discrepancy notes.

## Verdict

The framed protocol on the DATA jack (MAIN SCI-A `0xFFFE90`) is a **WIRES-X
node / PDN and PC-link control protocol, not a memory clone or arbitrary CAT
peek/poke** — confirming PC-01 and correcting the "clone/CAT" label in docs 04,
11 and 14. Its full inbound opcode set is **V, M** (gate) and **B, C, E, F, S,
N, W, V** (data phase); the radio also emits **V, P, C, H, R, G, W**. Every
handler reads and writes only **fixed, compile-time addresses** (VFO struct via
`@0xFF812A`, state at `0xFFBxxx`, the C4FM TX ring at `0xFEE944`, the reply
staging buffer at `0xFEE000`); the host supplies values that land in fixed
destinations, **never an address**. **No DATA-jack opcode reads or writes a
host-chosen RAM or flash address** (Confirmed; full-parser scope stated below).
The `0x6B91A` path is the reply DMA transmitter — source fixed `#0xFEE000`,
length the radio's own reply length from `0xFFB3CC`, destination the SCI-A TDR —
so it cannot dump arbitrary memory. The `0x6B7DC` path is an **inactivity-timeout
software reset** in node mode A, not a command; the only command-triggered reset
is the data-phase `V`, which restarts MAIN and returns nothing. The separate,
**front-panel-only serial CLONE** streams two hardcoded EEPROM ranges
(`0x140`–`0x0FFFF` and `0x10100`–`0x1FFFF`) in 64-byte blocks with an 8-bit
additive checksum and an `AH72M`+version+region gate on receive — again no
host-chosen addressing.

## Method

- Force-coded and disassembled the whole framed engine and its builders:
  RX state machine `sub_6B700`–`0x6B9AC`, gate `sub_6B9AC`, data handler
  `sub_6BA46`, dispatcher `sub_6BAD6`, auto-senders `0x6BB4C`–`0x6BD26`, every
  per-opcode handler/builder `0x6BE34`–`0x6C539`, the template block `0x6C539`
  (dumped raw and decoded), hex codec/finalizer `0x6CB40`–`0x6CCB8`, the M
  parsers `sub_25EAE`/`sub_2611A`/`sub_25D72`, and the clone streamers
  `sub_737FC`/`sub_7358E`/`sub_737C8`/`sub_734C2`. Listings in
  `<scratchpad>\K9\*.lst`.
- Resolved reachability with IDA xrefs (DMA path, reset path, clone callers,
  `sub_2AD0A` back to the key-handler table `0x0146EC`).
- Cross-read PC-01 (framed API), PC-02 (BACKUP.dat/EEPROM), doc 14 §4–§5
  (personality split), doc 11 §B, doc 23. Where they disagree I cite the bytes.
- Not run: I did not re-derive the M field semantics byte-by-byte (PC-01 covers
  them; I confirmed only the mode-A/mode-B routing and that writes go to the
  fixed VFO struct). I did not enter the closed window.

## Findings

### 1. Frame engine and the two personalities

`sub_45186` installs the frame handler (via `sub_6B700`) only when the node-mode
byte `0xFF8DDE != 0`; at 0 the port is a plain COM port and the framed engine is
not armed. `sub_6B700` sets the gate handler pointer `0xFFB3C6 = sub_6B9AC`;
after `M` the handler switches to `sub_6BA46` (data phase, `0xFFB3E0=1`). The
sign bit of `0xFF8DDE` selects the personality everywhere: **bit7 clear
(positive, "mode A")** vs **bit7 set (negative, PDN/node B)**. Both are node/PC
link modes; neither is a memory-clone session.

Frame = `0x01 | letter | 4-ASCII-hex length | data | 0x04 | 2-ASCII-hex sum`
(PC-01 §2, re-confirmed: length decode `sub_6CB5E`, store `0xFFB3CA`; assembler
store at `0x6B844` has **no length bound** — the RAM-overrun PC-01 §6 flagged is
real and lives in the assembler, independent of any opcode). Assembly buffer
`0xFF1AC8`; RX ring `0xFF27C8`–`0xFF29C8`.

### 2. Opcode table (see `cat-opcodes.tsv` for the full machine table)

Dispatcher `sub_6BAD6` (`@0xFF1AC9` = frame[1]):
`B`→`0x6BE9C`, `C`→`0x6BEF6`, `F`→`sub_6C686`, `E`→`sub_6C850`, `S`→`sub_6C8E8`,
`N`→`0x6BFB4`, `W`→`0x6BD0A`, `V`→`0x6BB08`; any other letter → `mov #0; rts`
(ignored, no reply). Gate `sub_6B9AC` accepts only `V` (ident `sub_6BD3E`) and
`M` (`0x6B9FE`).

| Op | What it does | Writes | Reply |
| --- | --- | --- | --- |
| `V` gate | identity (`sub_6BD3E`): model `FT3D`, dest from `sub_734BE`, `20180418`, radio-ID `0xFF8060`, `0C01` | staging only | 55-B `V0030…` |
| `V` data | **software reset** `jsr sub_2648; orc#0x80; jmp 0x2050` (both modes) | — | none |
| `M` | set node params; **mode A only** writes current-band VFO fields (freq/shift/tone/DCS/step) via `sub_25EAE`→`sub_25D72` @`0xFF812A`; mode B (`sub_2611A`) changes no VFO | fixed VFO struct + `0xFFB3xx` | 74/76-B echo |
| `B` | ack; mode B starts position exchange (`loc_1CA72`, `0xFFB3E4=1`) | state only | 8-B `B00010` |
| `C` | status + radio-ID (`sub_6BB6E` status char, ID `0xFF8060`) | none | 18-B `C000B…` |
| `E` | queue 45/65/90-B C4FM block into ring `0xFEE944` slot `(0xFFB3E3 &3)` | bounded ring | 8-B `E00010/1` |
| `F` | callsign check (`0xFF0C33`), load 60-B hdr `0xFF0BFC` + body ≤`0x40C` `0xFF0C38` | bounded buffers | 8-B `F00010/1` |
| `S` | `p0&1`: **1 = KEY TX** (`sub_2244C`, `0xFF94C0=1`) + send; 0 = stop TX | radio TX state | 8-B `S00010/1` |
| `N` | return two CR-terminated GPS/NMEA strings ≤`0x60` from `0xFF9C64`/`0xFF9CC6` | none | var |
| `W` | ack radio's position report; advance mode-B state 3→4 | state only | none |
| out `P/H/R/G` | unsolicited status / node status / received C4FM block (`R`: 45/65/90) / received message | staging only | — |

`E`, `F`, `S` are the transmit-class opcodes (they load and key an on-air C4FM
payload). `R` relays a *received* C4FM DATA block to the PC (three fixed sizes
0x61/0x89/0xBB payload) — matching doc 14 open #2's prediction that the PDN link
carries the same DV DATA payload sizes as the air side.

### 3. The `0x6B91A` DMA transmitter — fixed source, radio-set length

Reached only from `0x6B7A0` (`btst #2,@0xFFB3D2; bne`), and `0xFFB3D2.2` is set
only by the reply finalizer `0x6CC76`. The DMA (bytes verified) loads
`MAR0A ← #0xFEE000` (immediate `7a 05 00 fe e0 00`), `IOAR0A ← #0xFFFE93`
(SCI-A TDR), `ETCR0A ← @0xFFB3CC` where `0xFFB3CC` is set by the finalizer to
`reply_len + 2` (`0x6CC78 inc #2`). **No path loads MAR0A or the count from a
host value.** It moves only the radio's freshly-built reply out of the fixed
staging buffer. This is doc 14's "bulk data-out path": it is bulk *out of a
canned reply*, radio→PC, fixed addressing. CONFIRMED. Detail in
`dump-reset-paths.txt`.

### 4. The `0x6B7DC` reset — inactivity timeout, not a command

`0x6B7DC jsr sub_2648; orc #0x80; jmp 0x2050` fires only when: data phase active
(`0xFFB3E0≠0`), not transmitting (`0xFF94C0≠1`), mode byte `0xFF8DDE` bit7 clear
(mode A), and link counter `0xFF959E == 0`. `0xFF959E` reloads to 100 on every
good frame and counts down ~100 ms/tick (~10 s), so this restarts MAIN when the
mode-A PC link goes quiet. It is not selected by any opcode. The only
command-triggered reset is data-phase `V` (`0x6BB08`); the `bmi` at `0x6BB0C`
only skips the `sub_2648` quiesce pre-step, the reset runs in both modes —
**correcting doc 14's claim that mode `0xFF` skips the restart.** Neither reset
exposes memory. CONFIRMED.

### 5. Does any opcode read arbitrary RAM/flash? — No (full-parser scope)

Scope covered: the complete framed engine `0x6B700`–`0x6C7D8`, its builders
`0x6BE34`–`0x6C539`, the hex codec/finalizer `0x6CB40`–`0x6CCB8`, both M parsers,
and all reply/auto senders. Every load/store operand is a fixed immediate
address or a counter-indexed fixed ring; the length field bounds only the
assembler, and every bounded write (`E` slot, `F` body ≤`0x40C`) targets a fixed
region. The reply DMA sources fixed `0xFEE000`. There is **no read-memory and no
write-memory opcode, and no host-supplied address operand anywhere.** The `R`
"query" returns canned status/RX-block fields, matching doc 11 B3.
**Confirmed / Not found (arbitrary host-addressed read or write), scope = the
entire DATA-jack parser named above.**

### 6. Clone mode (front-panel only) — see `clone-format.txt`

Dispatched by `sub_2AD0A` (`@0xFFBBC2`: 1=receive/write, else=send/read),
referenced only from the key-handler pointer table `0x0146EC` → front-panel
soft-key; disabled while node mode is active. Port SCI-A 38400 8N1 (`sub_734C2`,
BRR `0x0C`). **Block = 0x40 (64) B.** Address space = EEPROM device A
`0x140`–`0x0FFFF` (`0x3FB`×`0x40`) + device B `0x10100`–`0x1FFFF` (`0x3FC`×`0x40`),
the same ranges as `BACKUP.dat`; all starts/counts are compile-time immediates.
**Checksum = one trailing 8-bit additive byte** (accumulator `0xFF812E` vs
received `0xFF812F`), which **differs from `BACKUP.dat`'s 32-bit sum** (pc-02) —
noted as a new detail. Receive validates `AH72M` + version(2) + region
(`sub_737C8`, same gate as BACKUP.dat) before any EEPROM write, then resets to
apply. No host-chosen addressing.

## USB relevance

- **Q1 (everything USB):** adds no USB surface. This control API is on the SCI-A
  DATA jack, independent of MAIN's two `26AA` USB personalities and of the boot
  updater. It confirms the DATA jack's most capable mode is a 38.4 kbit/s framed
  node/PC link whose only bulk-out is a canned reply via DMA from a fixed buffer.
- **Q2 (USB SDR): no.** No opcode exposes a sample stream or an arbitrary memory
  read; `R`/`G` carry only decoded C4FM DATA blocks and GPS text, and the DMA
  moves ≤64 KB-class reply buffers at 38.4 kbit/s. Nothing here is a sample path.
- **Q3 (DSP):** the framed `E`/`F`/`S` load and key on-air C4FM payloads (DSP
  TX), and `R` relays received DSP-decoded DATA blocks, but the DSP download path
  stays behind the closed window and no opcode reaches it directly.

## Open

Most valuable first.
1. Decode the mode-B position state machine (`0x6BD26` jump table, `loc_261FA`,
   `loc_1CA72`) and the `P`/`H`/`G` payload byte meanings — the only
   under-specified parts of the node protocol (doc 14 open #2).
2. Confirm the `R` 45/65/90-B block sizes against the on-air C4FM DATA frame
   sizes (PROTOCOLS / doc 06) to prove the PDN link relays the same payloads.
3. Decode the M frequency index tables `0x25BE2`/`0x25CAA` and whether mode-A
   `M` retunes are later persisted by the normal settings save (PC-01 open #6).
4. Byte-verify the clone send checksum writeback in `sub_738CC`'s tail (beyond
   `0x738FE`) to state the 8-bit sum fully (receive side already proves it).
