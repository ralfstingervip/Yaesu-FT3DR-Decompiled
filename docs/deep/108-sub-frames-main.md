# 108 — MAIN-side handlers for the SUB→MAIN frame set (Lane L11)

> Lane L11, model `claude-opus-5-5`. Private DB `L11_SUBFRAMES_MAIN`
> (`--copy-from ida\db\jobs\K1_MAIN_FINAL4\K1_MAIN_FINAL4.i64`), iterated with
> `--reopen`. Jobs: `ida\jobs\l11_dump.py` (generic read-only dumper),
> `ida\jobs\l11_refscan.py` (operand scanner). Both read-only apart from IDA's own
> state; no image byte changed (sha256 MAIN `8e3ecd05…`, SUB `b93570b3…` as given).
> No shared DB opened, nothing connected to a radio, closed window
> `0x078106`–`0x07B753` not entered. Tables: `ida\out\sub-frames-main\`
> (`frame-types.tsv`, `dump1_handlers.txt`, `dump2_consumers.txt`, `refscan_cells.txt`).
> I own the MAIN side only; the SUB-side producers are L12's lane.

## Verdict

**The MAIN deframer accepts exactly ten SUB→MAIN frame types and no others:
`E0 E1 E2 E3 E4 E5 E6 EA FE FF`.** Each is a byte-at-a-time state machine that
validates a fixed 6-byte header (type, b1, 16-bit length, 16-bit header sum),
copies the payload to a dedicated RAM cell, and sets a per-type "arrived" flag.
Decoded end to end: **E0** = touch (already K2); **E1** = the GPS NMEA-sentence
relay from the SUB's GPS into MAIN's position store; **E3** = the link-ready
acknowledgement (echoes the `01 02 00` protocol constant); **E4** = a 29-byte
WIRES-X/node status record; **EA** = a WIRES-X data-transfer handshake byte;
**FE** = the large received-data block (C4FM picture / WIRES-X message, up to
1024 B) into the `0xFF5006` buffer; **FF** = bulk block read-back into
`sub_55DFC`. **The one frame that can change radio state is `E6`: its payload
bit 0 is injected as key `0x17`/`0x18` — the PTT key — so the SUB can command
PTT over the inter-processor link.** **E2** (word → `0xFFBC60`) and **E5**
(byte → `0xFFBB92`) are stored but have **no reader** anywhere in `0`–`0x80000`:
dead on the MAIN side. No frame handler writes EEPROM, reaches SCI-C (DSP), or
touches USB `0xFFEE00`.

## Method

- Seeded a private MAIN DB from `K1_MAIN_FINAL4` and dumped, with all chunks and
  xrefs, the deframer `sub_4753E`, the start-byte switch `sub_4761E`, the state
  table `off_475C8`, the SCI-D ISR `sub_44A70`, and all ten handlers
  (`dump1_handlers.txt`).
- Ran an operand scanner (`l11_refscan.py`) over every code head `0`–`0x80000`
  (H8S abs16 sign-extension masked to 24 bits, immediates matched on `op.value`)
  for every destination cell and arrival flag (`refscan_cells.txt`, 185 hits).
- Dumped the consumers that the scan pointed to: the E1 GPS chain
  (`sub_47BF6`/`sub_47CE0`), the E6 input poller `sub_FD22`, the EA FSM
  `sub_7055E`, the E4 reader `sub_730E8`, the FE reader `sub_6FE02`, and the
  link-init `sub_44700` (`dump2_consumers.txt`).
- **Not done:** I did not fully decode the FE picture/message parser in
  `0x6F000`–`0x70800` (only confirmed the `0xFF5006` buffer layout it reads), nor
  the `sub_55DFC` FF read-back target, nor the full E4 `0x730xx` state machine.
  SUB-side producers are out of my lane (L12).

## Findings

### 1. Transport: SCI-D ring, then a per-state dispatch

The SCI-D receive ISR **`sub_44A70`** (fixed vectors `0x380`/`0x388`) reads SSR
`0xFFFFF614` and RDR `0xFFFFF615`, and on a clean byte writes it through the
write pointer `0xFFFF8146` into a circular ring **`0xFF306A`–`0xFF3C6A`**
(3,073 B; wrap test `cmp.l #0xFF3C6B` at `0x044A92`). Framing/parity/overrun
(`SSR & 0x38`) are cleared and dropped. **SCI-D = the H8S SCI block at
`0xFFF610`** (Confirmed by the SSR/RDR offsets).

The deframer **`sub_4753E`** drains the ring via read pointer `0xFFFF8142`
(end `0xFFFF8148`) and dispatches on a state byte **`0xFFFF9D2D`**:
`0x047590 mov.l @(off_475C8:32,er3), er6 ; jmp @er6` (Confirmed). The state table
`off_475C8` (`0x0475C8`, 12 × BE32) is authoritative:

| state | handler | frame |
| --- | --- | --- |
| 0 | `nullsub_92` (`0x475F8`, rts) | idle/dummy |
| 1 | `sub_4761E` | **start-byte detect** |
| 2 | `sub_47792` | E0 |
| 3 | `sub_47B7C` | E1 |
| 4 | `sub_478AA` | E3 |
| 5 | `sub_47A7E` | FF |
| 6 | `sub_4799A` | E2 |
| 7 | `sub_47E2C` | FE |
| 8 | `sub_47F4E` | EA |
| 9 | `sub_4802E` | **E4** |
| 0xA | `sub_4811E` | **E6** |
| 0xB | `sub_481FE` | E5 |

> **Correction to doc 84 (K2).** K2's receive table swapped the E4/E6 handler
> addresses. The state table and the handlers' own `cmp.b` self-checks are
> decisive: **E4 (state 9) = `sub_4802E`** (resets length `0x29`, `cmp.b #0xE4`
> at `0x04803C`); **E6 (state 0xA) = `sub_4811E`** (resets length `0x0D`,
> `cmp.b #0xE6` at `0x04812C`). The states and lengths K2 gave are right.

### 2. The start-byte switch and the common frame format

`sub_4761E` (`0x047622`–`0x047656`) compares the first byte against the ten
constants and, for each, writes the byte to the frame buffer base **`0xFF9800`**
(`@(-0x6800:16,er1)`, `er1=0`), sets index `0xFFFF9D2A=1`, the remaining-byte
counter `0xFFFF9D2C`, and the next state `0xFFFF9D2D`. **Any other start byte
falls through to `rts` (`0x047658`) and is dropped — the census is closed at ten
types.**

Frame layout (Confirmed from the MAIN validators; matches K2's SUB builder):
byte0 = type, byte1 = b1, byte2:3 = BE length (= payload_n + 9), byte4:5 = BE
header sum of bytes 0..3, byte6..8 = constant `01 02 00`, byte9:10 = echoed
MAIN→SUB opcode, byte11.. = payload, then a BE frame sum, then pad. Every
handler re-validates each header byte against its known-constant value and both
the header sum (index 5) and the whole-frame sum before acting; a mismatch
resyncs to state 1 and (if `0xFF89C4` bit 4 is set) raises an error tone
`0xFFAAE0=0x1B` and stores the error index to `0xFFBAA8`.

### 3. Per-type decode (payload cell, action, consumer)

Full table in `frame-types.tsv`. Highlights with evidence:

- **E0 touch** (`sub_47792`): 18-B `eepmov` to `0xFFBBC8` (`0x04786C`); one-shot
  `01 02 00`→`0xFF813F`, `FF813E=1`. Consumer = touch poller `sub_262E4` (K2).

- **E1 = GPS NMEA relay** (`sub_47B7C` → payload collector `sub_47BF6` →
  parser dispatch `sub_47CE0`). Variable length (byte3 ≥ `0x85`), payload size
  cached at `0xFFBBE6` = byte3−9. After the frame sum, the payload is shifted
  down to `0xFF9800` (`eepmov` `0x047C82`), a `0x0A` is appended, and bytes
  [2..5] are matched against **`"PGGA"` `0x50474741`, `"PRMC"` `0x50524D43`,
  `"PGSA"` `0x50475341`, `"PVTG"` `0x50565447`** (`0x047CA0`/`CAA`/`CB4`/`CBC`) —
  i.e. `$GPGGA/$GPRMC/$GPGSA/$GPVTG`. Parsers `sub_4477E`, `sub_44F4E`,
  `sub_458F4`, `sub_45FBA`, `sub_45312` fill the position store at `0xFF9C00`
  (`0xFF9CC4/C6`, `0xFF9C62/64`) and arm a GPS-valid timer `0xFF9594=0x64`.
  **Confirmed: E1 is how the SUB's GPS reaches MAIN**, which is the position
  source for the APRS beacon / GPS display paths. (Indirect TX relevance: APRS
  auto-beaconing, doc 90, consumes this when APRS MODEM is on.)

- **E3 = link-ready ack** (`sub_478AA`): copies byte6..8 (`01 02 00`) to
  `0xFF813F` and sets `0xFF813E=1` (`eepmov` `0x04797A`). `FF813E`/`FF813F` are a
  SUB-link-established gate read by `sub_7C20`, `sub_9CF4`, `sub_4F700` (GPS),
  `sub_730E8` (E4), `sub_74364`. E0 writes the same triple as a one-shot.

- **E4 = 29-B WIRES-X/node status record** (`sub_4802E`): header sum hi = 1
  (`cmp.b #1` at `0x048072`, since `0xE4+0x26=0x010A`); 29-B `eepmov`
  `0xFF980B`→**`0xFFBB71`** (`0x0480FE`), flag `BA92` bit 2. Read by the
  `0x730xx` block (`sub_730E8` tests byte0==1 → `0xFFBB90=2`; `sub_731C0` reads
  the record tail at `0xFFBB72`). Inferred: WIRES-X connection/GM status.

- **EA = WIRES-X transfer handshake** (`sub_47F4E`): 1 payload byte →
  **`0xFFBAD7`** (`0x048018`), flag `BA92` bit 1. Driven by FSM `sub_7055E`
  (state `0xFFBAD6`, values `0x80/0x90/0xA0/0x10`); raises alert tone
  `0xFFAAE0=0x1D` and `0xFF95A5` on some transitions. Inferred: the control
  channel of the picture/message transfer.

- **FE = large received-data block** (`sub_47E2C`): 16-bit length in byte2:byte3
  (≤ `0x400`, stored/counted at `0xFFBA94`); the whole frame (count+4 B) is
  `eepmov`'d to **`0xFF5006`** (`0x047F22`/`0x047F34`), flag `BA92` bit 0.
  Consumed by `sub_6FE02` et al. in `0x6F000`–`0x70800` (reads block header at
  `0xFF501E`==`0xC8`/`0xC9`, length at `0xFF5012`) and by `sub_55C7E`/`sub_5F458`
  /`sub_6F586`. This is the C4FM picture (JPEG) / WIRES-X message block path
  (docs 51/63). RX data only.

- **FF = bulk block read-back** (`sub_47A7E`): b1==`0xFF`, 16-bit count in
  byte2:byte3 (< `0x112`); after the frame sum, `jsr sub_55DFC` (`0x047B66`).

- **E6 = SUB-commanded PTT** (`sub_4811E`): 1 payload byte → **`0xFFBB91`**
  (`0x0481E8`), flag `BA92` bit 3. Consumer is the **input poller `sub_FD22`**
  (called from the key-scan loop `sub_FA30`): it reads `0xFFBB91`, and
  `and #1 ; bnot #0 ; add #0x17` yields **`0x17` (press) / `0x18` (release)**,
  stored to the key cell **`0xFFA9ED`** (`0x00FD30`–`0x00FD58`), with `0xFFAAD2`
  bit 0 as the debounce latch. Keys `0x17`/`0x18` are the PTT key codes (K11,
  doc 93). **Confirmed: a valid E6 frame keys/unkeys the transmitter.**

- **E2** (`sub_4799A`): 2 payload bytes → word `0xFFBC60` (`0x047A66`).
  **E5** (`sub_481FE`): 1 payload byte → `0xFFBB92` (`0x0482C8`), flag `BA92`
  bit 4. **Neither destination, nor E5's flag bit 4, is read by any abs16
  access in `0`–`0x80000`** (`refscan_cells.txt`): both are **dead on MAIN**
  (Not found; scope = whole MAIN code segment, indexed/pointer reads not
  excluded).

### 4. Arrival-flag byte `0xFFBA92`

Bits set by the handlers, cleared by the consumers: bit0=FE, bit1=EA, bit2=E4,
bit3=E6, bit4=E5. (bit4 is never tested — see E5 above.) `0xFFBA93` is a sibling
link-busy/retry byte (bit 6 gates `0xFF9567`) used across the WIRES-X functions
but is not itself a frame destination.

## USB relevance

- **Q1 (USB):** none. Every handler and every consumer I traced writes RAM
  (`0xFF98xx`, `0xFFBBxx`, `0xFFBAxx`, `0xFF5006`, `0xFF9Cxx`) or calls parser
  code; not one touches USB `0xFFEE00`–`0x53` or SCI-C `0xFFFF88` (DSP). The
  SUB→MAIN link is SCI-D only. No new USB surface.
- **Q2 (SDR):** the densest SUB→MAIN frame is FE at ≤1024 B of already-formed
  picture/message data, and E1 is ASCII NMEA — neither is an IQ/sample path.
- **Q3 (DSP):** no frame handler reaches the DSP bus.
- **Owner-relevant TX finding:** add **E6 (SUB→MAIN SCI-D frame) → PTT key
  `0x17`/`0x18`** to the list of things that can key the radio without a
  front-panel keypress. On the MAIN side this is unconditional once a
  well-formed E6 arrives; *what makes the SUB emit E6* is L12's question. E1 also
  feeds the APRS auto-TX paths indirectly (position source).

## Open (most valuable first)

1. **What makes the SUB send E6** (the PTT frame) and **E4** (status) — L12's
   SUB-side lane; pair with this doc to close the PTT-over-link path.
2. **Confirm E2/E5 are truly unused** with an indexed/pointer-access scan of the
   `0xFFBB00`/`0xFFBC00` RAM page (my scan covered abs16 + immediates only).
3. **FE picture/message parser** `0x6F000`–`0x70800` and the `0xFF5006` block
   format (header at `+0x18`, length at `+0x0C`) — ties FE to doc 63 pictures.
4. **FF read-back target `sub_55DFC`** — what bulk data MAIN returns and to whom.
5. **E4 `0x730xx` state machine** — the full WIRES-X/node status record meaning.
