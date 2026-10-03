# The third device: the DSP / vocoder, its bus, its protocol, and whether it can be reached

Agent DSP-AMBE. Machine-readable tables: `ida\out\dsp\protocol.tsv`,
`ida\out\dsp\commands.tsv`, `ida\out\dsp\bus.tsv`, `ida\out\dsp\routines.tsv`,
`ida\out\dsp\passthrough.tsv`, plus raw dumps under `ida\out\dsp\main\` and
`ida\out\dsp\sub\`. Private databases: `DSP_HUNT_MAIN`, `DSP_HUNT_SUB`.

## Verdict

The third programmable device is real, it belongs to **MAIN (the H8S)**, and the
firmware talks to it over **SCI channel A at `0xFFFF88`, configured in H8S
clocked-synchronous mode with the DSP supplying the clock** (`SMR = 0x80`,
`BRR = 0x00`, `SCR` `CKE1 = 1`), half-duplex, with both directions moved by the
on-chip DMAC. The wire format is **not** the DVSI AMBE-3000R framing: there is no
`0x61` start byte, no 16-bit length field and no TLV. It is a **fixed-length
frame — 32 bytes normally, 96 bytes for the bulk opcodes — with the opcode in
byte 0, fixed per-opcode payload fields, and an 8-bit additive checksum as the
last byte.** I recovered the complete opcode set in both directions (24 CPU→DSP
opcodes, 16 DSP→CPU opcodes), two complete canned packets sitting in ROM, the
reset/power-on sequence, the version query and the exact route by which its
answer reaches the "DSP Ver." line on the radio's version screen. No string in
either image names the part: `AMBE`, `DVSI`, `PRODID`, `VERSTRING`, `RATEP` and
`RATET` are **absent from both images** (full-image search). What the image does
name is the device's own role — `DSP POWER:ON & RESET!`, `CPU>DSP: STOP ENCODE`,
`CPU>DSP: RX ENABLE`, `DSP>CPU: TERM RX`, `DSP>CPU: DATA TEXT SET` — so the
device is the C4FM baseband-plus-vocoder engine, and the honest statement is
"a vocoder/baseband device on MAIN's synchronous SCI with this frame format",
not a part number.

On the owner's question: **yes, there is a firmware path that hands the DSP's bus
to a generic byte relay, and it is selected at power-on, not from a menu.** At
every reset MAIN polls an input port at `0xFFFF4C` up to 200 times; if
`(value & 0x7F) == 0x7D` it sets a bridge flag at `0xFF813A` to 1, and from then
on the SCI_A receive interrupt hands every byte to a generic queue-driven serial
engine instead of the DSP frame assembler, while the transmit side becomes a
plain polled `TDR` loop. In that mode MAIN also reconfigures SCI_A to
**asynchronous 8-N-2, `BRR = 0x0C`**. This is the data path of the radio's
**DSP WRITE MODE** — SUB carries the screen for it (`---DSP WRITE MODE----`,
`Push DISP Key!`, `Loading...`, `Complete`, `FIRM ERROR`), and MAIN drives an
eight-step state machine at `0xFFB0C4` that pulses a reset line and a boot-mode
line on port `0xFFFF52` before switching the port to async. So the DSP's firmware
**is** field-writable from MAIN even though the vendor package ships only Main
and Sub. What I could **not** determine from this image is which physical
connector feeds the other end of that relay: the engine's queues live at
`0xFF6288` and its other port is a peripheral block at `0xFFEE00`–`0xFFEE53`
that I did not identify. In normal operation there is **no** pass-through: every
instruction in the 512 KB of MAIN content that writes the DSP command buffer
lies inside the digital-voice module, and the DMA source register is only ever
loaded with one of four fixed buffers.

## Method

What I ran, in order.

1. Byte-level search of both plaintext images for vocoder vendor strings
   (`AMBE`, `DVSI`, `PRODID`, `VERSTRING`, `RATEP`, `RATET`, `VOCODER`, `CODEC`)
   — **not found, in either image, over the whole file**. Then a full ASCII
   string extraction of both images (MAIN 6,629 strings, SUB 15,150) into the
   scratchpad, and a search of those for `DSP`, version-screen text and
   firmware-load text. That is what turned up the MAIN debug-trace table and the
   SUB `---DSP WRITE MODE----` screen.
2. `ida\jobs\dsp_main_scan.py` on `DSP_HUNT_MAIN`, seeded `--copy-from
   ida\db\radio\MAIN.i64` (1,298 functions). Force-decoded `0x5A000`–`0x5B400`
   (1,885 new instructions, 48 new functions), dumped it annotated, resolved
   every xref to the 18 DSP trace strings, decoded all 256 big-endian vectors at
   `0`, and histogrammed on-chip register operands.
3. `ida\jobs\dsp_main_deep.py` on the same database. Force-decoded
   `0x44800`–`0x49200`, `0x54000`–`0x60000`, `0x6B800`–`0x6D400` and
   `0x78100`–`0x78500` (16,735 new instructions, 2,031 functions total), then a
   **linear sweep of `0x2000`–`0x80000`** for absolute operands in the on-chip
   register page, so the SCI census does not depend on function recovery.
4. `ida\jobs\dsp_sub_scan.py` on `DSP_HUNT_SUB`, seeded from
   `ida\db\radio\SUB.i64` (455 functions). Force-decoded the version-screen and
   DSP-write-mode windows, then a **linear sweep of the entire 4 MB image,
   2,077,781 decoded instructions**, for operands in the RX64M peripheral region.
5. `ida\jobs\dsp_dump.py`, a reusable range dumper driven by `DSP_RANGES` /
   `DSP_XREF` environment variables, run six times to iterate on the twenty-odd
   routines that carry the answer.
6. Raw byte-pattern scans in Python over the MAIN image for every H8S absolute
   addressing form (`@aa:8`, `@aa:16`, `@aa:32`, `mov.l #imm32`, bit operations)
   against each RAM address of interest, to get **complete** reader/writer sets
   rather than xref sets limited by function coverage. Also a complete
   `jsr/jmp @aa:24` edge list (9,052 sites) to find every entry point into the
   DSP driver and the serial engine from outside them.

Scope I did **not** cover: MAIN's `0x76000`–`0x78600` serial-engine module is
only partly decoded and I did not identify the peripheral at
`0xFFEE00`–`0xFFEE53` or the producer side of the queues at `0xFF6288`. I did
not attempt a bit-exact H8S part identification (that is MAIN-FULL's
assignment). Nothing was written to a radio; no device was touched.

## Findings

### 1. The device exists and MAIN owns it — the trace table

MAIN carries a complete human-readable trace facility for the DSP link. File
offsets are also mapped addresses (MAIN base = 0).

| Offset | String |
| --- | --- |
| `0x0005AE1C` | `CPU>DSP: ` |
| `0x0005AE28` | `DSP>CPU: ` |
| `0x0005AE5A` | `DSP POWER:ON & RESET! \r\n` |
| `0x0005AE72` | `TIME OUT:3sec!\r\n` |
| `0x0005AE82` | `DSP?\r\n` |
| `0x0005AE88` / `0x0005AE96` | `DSP>CPU: ACK` / `DSP>CPU: NAK` |
| `0x0005AEA4` / `0x0005AEB2` | `CPU>DSP: ACK` / `CPU>DSP: NAK` |
| `0x0005AEC0` / `0x0005AED6` | `CPU>DSP: RX DISABLE` / `CPU>DSP: RX ENABLE` |
| `0x0005AEEA` / `0x0005AEFC` | `CPU>DSP: MUTE ON` / `CPU>DSP: MUTE OFF` |
| `0x0005AF10` | `CPU>DSP: STOP ENCODE` |
| `0x0005AF26` | `CPU>DSP:VER?` |
| `0x0005AF34` | `DSP>CPU: DATA TEXT SET` |
| `0x0005AF4C` / `0x0005AF5E` | `DSP>CPU: TERM TX` / `DSP>CPU: TERM RX` |

A string-pointer table at `0x0005AE32` indexes them; it is loaded at `0x00056420`
(`mov.l @(0x5AE32, er3), er6` / `jmp @er6`). Three formatters build ASCII into a
buffer at `0xFF2DC8`: `0x0005A482` for ACK/NAK, `0x0005A506` for CPU→DSP (the
command switch is at `0x0005A53E`) and `0x0005A7F2` for DSP→CPU (the response
switch is at `0x0005A82A`). A mode byte at `0xFF8C28` set to 3 or 5 makes the
trace fall back to a raw hex dump. Hex-digit table: `0x0000455C` =
`0123456789ABCDEF`; DTMF digit table `0x0000456C` = `0123456789ABCD*#-`.

SUB contains **none** of this. SUB's only DSP-related content is display text.

### 2. The bus

Confirmed from `sub_56520` (`0x00056520`), the DSP link's SCI initialisation:

```
0x5652C  mov.b #2,   @0xFFFF8A   ; SCR = 0x02  -> CKE1 = 1, external clock input
0x5653C  mov.b #0x80,@0xFFFF88   ; SMR = 0x80  -> C/A = 1, CLOCKED SYNCHRONOUS mode
0x56540  mov.b #0,   @0xFFFF89   ; BRR = 0x00  -> no internal baud generator
0x56544  mov.b r4l,  @0xFFFF8C   ; clear SSR flags
0x56548  mov.b #0x12,@0xFFFF8A   ; SCR = RE | CKE1     (receive)
0x56550  bset  #6,   @0xFFFF8A   ; SCR |= RIE
```

`SMR = 0x80` is clocked-synchronous mode and `CKE1 = 1` selects the external
serial clock on `SCK`. Together with `BRR = 0x00` this means **MAIN does not
generate the bit clock — the DSP does.** So there is no baud rate to quote for
normal operation: the rate is whatever the DSP drives. That also means the DSP is
the timing master of the voice link, which is what you would expect of a device
that has to run on a 20 ms C4FM frame grid.

Direction is switched per frame: `SCR = 0x22` (`TE | CKE1`) to transmit
(`sub_566E4` `0x00056706`, `sub_5678E` `0x000567B0`), `SCR = 0x12` to receive
(`sub_56732` `0x0005675A`, `sub_567DC` `0x0005680A`), with `SSR &= 0x87` between.

Register map and the DMAC channels (also in `ida\out\dsp\bus.tsv`):

| Address | Register | Use |
| --- | --- | --- |
| `0xFFFF88` | SCI_A SMR | `0x80` sync (DSP traffic), `0x08` async 8-N-2 (bridge mode) |
| `0xFFFF89` | SCI_A BRR | `0x00` sync, `0x0C` async |
| `0xFFFF8A` | SCI_A SCR | `0x02` / `0x12` / `0x52` / `0x22`; bit 7 (TIE) starts the DMA burst |
| `0xFFFF8B` | SCI_A TDR | DMA destination; also the polled write target at `0x00077022` |
| `0xFFFF8C` | SCI_A SSR | TDRE polled at `0x0004834E` |
| `0xFFFF8D` | SCI_A RDR | read by the ISR at `0x00056172` |
| `0xFFFC20` | DMAC ch1 source | the frame buffer passed in ER5 |
| `0xFFFC24` | DMAC ch1 destination | `0xFFFF8B` — this is the proof that ch1 feeds SCI_A |
| `0xFFFC2C` | DMAC ch1 count | `0x20` or `0x60` |
| `0xFFFC34` | DMAC ch1 control | `0x1A0`, then `0x800001A0` to enable |
| `0xFFFC14`/`0xFFFC18` | DMAC ch0 | the receive channel, `0x800001A0` / `0x200000` |
| `0xFFFD20`/`0xFFFD21` | DMAC request select | `0xE1` receive, `0x96` transmit |
| `0xFFFF52` | DSP control port | bit0 enable, bit1 direction, bit3 reset pulse, bit4 boot/mode |
| `0xFFFF49` bit 7 | DSP handshake input | polled in DSP-write states 4 and 5 |

Interrupt vectors, decoded from the 256-entry big-endian table at `0`
(`ida\out\dsp\main\vectors.tsv`; only 30 of 256 slots have a handler other than
the reset stub at `0x2092`):

| Slot | Vector address | Handler | Meaning |
| --- | --- | --- | --- |
| 128 | `0x000200` | `sub_48328` `0x00048328` | DMAC ch0 transfer end — clears receive-busy `0xFFBBE4` |
| 129 | `0x000204` | `sub_483D2` `0x000483D2` | DMAC ch1 transfer end — clears SCI_A TIE and transmit-busy `0xFFBC8C` |
| 148 | `0x000250` | `sub_5615C` `0x0005615C` | SCI_A ERI |
| 149 | `0x000254` | `sub_5615C` | SCI_A RXI |
| 150 | `0x000258` | `nullsub_15` `0x000483D0` | SCI_A TXI — a bare `rte`, because transmit is DMA driven |

Two other SCI blocks are in use in MAIN and are **not** the DSP: `0xFFFF60`
(vectors 152/153/154, handlers `sub_45520` / `sub_454E2`) and `0xFFFE90`
(vectors 160/161/162, handlers `sub_45462` / `sub_45406`). The `0xFFFE90` channel
is the MAIN↔SUB inter-processor link: its module (`0x73000`–`0x74900`) owns the
message buffer at `0xFF96F8`. A fourth block appears at `0xFFFF68` (used by
`nmi_handler` and the reset init).

### 3. The frame format — complete

Confirmed from three independent places: the DMA count selection in `sub_4834E`,
the checksum routine `sub_58FA2`, and two fully-formed canned packets in ROM.

```
  byte 0        opcode
  byte 1..N-2   payload, fixed fields per opcode
  byte N-1      checksum = (sum of bytes 0 .. N-2) mod 256

  N = 32 (0x20)  normally
  N = 96 (0x60)  for opcodes 0x15, 0x16, 0x19 always,
                 and for 0x0C..0x0E when MAIN RAM 0xFF8DDE != 0
```

There is no start delimiter, no length field, no TLV. `sub_58FA2`
(`0x00058FA2`) does it explicitly:

```
0x58FB0  mov.b @0xFFB13E, r4l      ; opcode
0x58FB4  cmp.b #0x19 ... #0x16 ... #0x15  -> loc_58FD2
0x58FC0  mov.b @0xFF8DDE, r6l ; beq ; cmp.b #0x0C ; bcs ; cmp.b #0x0F ; bcs -> loc_58FD2
0x58FCE  mov.b #0x0F, r4l          ; 15 words
0x58FD2  mov.b #0x2F, r4l          ; 47 words
0x58FD4  mov.l #0xFFB13E, er6
0x58FDA  mov.l er6, @0xFFB13A      ; publish the frame pointer
0x58FE0  mov.w @er6+, r5 ; add.b r5h,r3l ; add.b r5l,r3l ; dec.b r4l ; bne  ; (2*n bytes)
0x58FEA  mov.b @er6+, r5l ; add.b r5l,r3l                  ; one more byte
0x58FEE  mov.b r3l, @er6                                   ; store the checksum
```

15 words + 1 byte = 31 bytes summed, checksum at offset 31 → 32-byte frame.
47 words + 1 byte = 95 bytes summed, checksum at offset 95 → 96-byte frame. Both
match the DMA transfer counts `0x20` and `0x60` chosen by the identical opcode
test in `sub_4834E` at `0x00048374`–`0x000483A2`.

The two ROM packets settle it beyond doubt. MAIN file `0x0005901C`:

```
0005901c: 00 20 1F 02 00 00 00 00 ...                     <- packet starts at 0x5901E
0005903c: 00 21                                           <- byte 31 = 0x21
```

`0x5901E` = `1F 02 00×29 21`, and `0x1F + 0x02 = 0x21`. That is the **VER? query**.
`0x5903E` = `18 00×30 18`, checksum `0x18`. That is **STOP ENCODE**. They are sent
by `sub_58F86` and `sub_58F94`, which simply point `0xFFB13A` at ROM instead of at
the RAM buffer.

Buffers, all in MAIN RAM:

| Address | Role |
| --- | --- |
| `0xFFB13E`..`0xFFB19D` | command TX buffer; checksum lands at `0xFFB15D` (32) or `0xFFB19D` (96) |
| `0xFFB13A` | 32-bit pointer to the frame to send — `0xFFB13E`, or ROM `0x5901E` / `0x5903E` |
| `0xFFB1A0`..`0xFFB1BF` | ACK/NAK TX buffer, checksum at `0xFFB1BF` |
| `0xFFB0E0` | receive buffer; `0xFFB0DE` byte index, `0xFFB0DB` running checksum |
| `0xFFB0DC` | 2-byte value delivered by response `0x9F` — the DSP version |
| `0xFF23C8`..`0xFF27C7` | 1 KB byte ring between the ISR and the frame assembler; write ptr `0xFF815E`, read ptr `0xFF815A` |
| `0xFFB0A4` | link request/ack bit flags (bit 4 = NAK received, bit 5 = ACK received, bit 6 = request pending) |
| `0xFFB0A6` | link state index into the table at `0x0005645C` |
| `0xFFB0B6` | packet-builder request index into the table at `0x0005A3CE` |

ACK and NAK are themselves frames, built by `sub_58F2A` / `sub_58EE6`: zero 32
bytes at `0xFFB1A0`, write `0x20` (ACK) or `0x10` (NAK) at byte 0, the opcode
being answered at byte 1, and `opcode + 0x20` (or `+ 0x10`) as the checksum at
byte 31 (`0x00058F66`–`0x00058F72`).

### 4. The command set — every opcode

Recovered from the two trace switches, which by construction enumerate every
opcode the firmware handles, cross-checked against the actual builders. Full
table with per-opcode evidence in `ida\out\dsp\commands.tsv`.

**CPU→DSP** (switch at `0x0005A53E`):

| Opcode | Meaning | Builder |
| --- | --- | --- |
| `0x06` | frame type, answered by `0xA6` | — |
| `0x07` | frame type, answered by `0xA7` | — |
| `0x08` | frame type, answered by `0xA8` | — |
| `0x09`, `0x0A` | frame types with a byte from `0xFFB122` | — |
| `0x0B` | **DTMF**, subtype `0x00`/`0x01`, digit in a low nibble | `0x00059F94`, `0x0005A034` |
| `0x0C`–`0x0E` | 96-byte frames when `0xFF8DDE != 0` | — |
| `0x10` | **NAK** (checksum failure), byte 1 = rejected opcode | `sub_58EE6` |
| `0x11` | control, 7-word payload | `0x000590AA` (`sub_5905E`) |
| `0x12` | control, byte 1 carries bit fields from `0xFFB11E` / `0xFFB0AA` | `0x000592A4` (`sub_59240`) |
| `0x15` | **96-byte table upload**, subtype `0x01` = 18 × 5-byte records from `0xFF4576`, subtype `0x11` = 6 × 5 from `0xFF4696`, blank-record default ROM `0x00004C14` | `0x0005A17E` |
| `0x16` | 96-byte frame | `sub_594FA` `0x000594FA` |
| `0x18` | **STOP ENCODE** | canned ROM `0x0005903E` |
| `0x19` | 96-byte frame | — |
| `0x1A` | **RX ENABLE** (byte 1 = 0) / **RX DISABLE** (byte 1 ≠ 0) | `0x00059DD8`, `0x00059E56` |
| `0x1C` | **DATA TEXT SET**, byte 1 from `0xFFB0B8` | `0x0005A082` |
| `0x1D` | **MUTE OFF** (byte 1 = 0) / **MUTE ON** (byte 1 ≠ 0) | `0x00059EF6`, `0x00059EA6` |
| `0x1F` | **VER?**, byte 1 = `0x00` or `0x02` | canned ROM `0x0005901E` (`1F 02`), `0x00059BBA` (`1F 00`) |
| `0x20` | **ACK**, byte 1 = acknowledged opcode | `sub_58F2A` |
| `0x31` | variant of `0x11` | `0x0005EB2E` |
| `0x32` | variant of `0x12` | `0x0005EBA4` |

**DSP→CPU** (switch at `0x0005A82A`, dispatched at `0x000569A6`):

| Opcode | Meaning | Effect in MAIN |
| --- | --- | --- |
| `0x90` | **NAK**, byte 1 = rejected opcode | clear `0xFFB0A4` bit 6, set bit 4 (retransmit) |
| `0x9A` | special, only when `0xFF8DDE != 0` | set `0xFFB3D5` bit 0 |
| `0x9C` | **DATA TEXT SET** | set `0xFFB12D` bit 0 |
| `0x9E` | **TERM TX** | set `0xFFB12D` bit 7 |
| `0x9F` | **VER response**, payload bytes 1–2 | stored as a word at `0xFFB0DC` |
| `0xA0` | **ACK**, byte 1 = acknowledged opcode | clear bit 6, set bit 5 of `0xFFB0A4` |
| `0xA6`, `0xA7`, `0xA8`, `0xA9`, `0xAA` | data / voice frames | `sub_56A94`, **no ACK returned** |
| `0xAB` | **TERM RX** | `sub_56A94`, no ACK |
| `0xB6`, `0xB7`, `0xB8`, `0xB9`, `0xBA` | data / voice frames | `sub_56A94`, no ACK |
| `0xBB` | **TERM RX** | `sub_56A94`, no ACK |

**Referenced versus merely present.** MENU is right that this driver is probably
shared across the FT1D/FT2D/FT3D line (model table at MAIN `0x0004C388`,
destination table `USA JPN EXP` at `0x0006BE26`, model code `APY03D` at
`0x0004B182`), so some trace entries may cover commands this radio never sends. I
kept the two classes separate in `commands.tsv`. Opcodes with a **located builder
in this image** — i.e. definitely emitted by this firmware — are `0x0B`, `0x10`,
`0x11`, `0x12`, `0x15`, `0x16`, `0x18`, `0x1A`, `0x1C`, `0x1D`, `0x1F`, `0x20`,
`0x31`, `0x32`. Opcodes that appear **only in the trace switch**, with no builder
I could locate, are `0x06`, `0x07`, `0x08`, `0x09`, `0x0A` and `0x19` (and the
`0x0C`–`0x0E` length rule). Those six are either emitted through the runtime
opcode path in `sub_594FA` (which writes `r1l` to `0xFFB13E` at `0x000595F2` and
`0x00059778`, so its opcode is a parameter and cannot be read off statically) or
they belong to a sibling model. Treat them as "the DSP understands them" rather
than "this radio sends them".

The no-ACK rule is explicit at `0x000569BE`–`0x000569D2`: opcodes in `0xA6`–`0xAB`
and `0xB6`–`0xBB` jump straight to `sub_56A94`; every other opcode goes through
`loc_56A4A`, which sends ACK `0x20` first. That is the shape of a streaming voice
link — the frames that carry voice are not acknowledged, only the control
messages are.

Receive-side error handling, `sub_5683E` at `0x00056976`:

```
0x56976  mov.b @0xFFB0DB, r4l ; add.b r5l, r4l ; mov.b r4l, @0xFFB0DB   ; running sum
0x56980  cmp.b r5h, r5l ; bne loc_56A52                                  ; sum vs trailing byte
0x56A52  jsr sub_58EE6                                                   ; -> NAK 0x10
```

### 5. Initialisation, reset, and the version query

Power-on sequence, in call order:

1. `sub_56492` `0x00056492` — enter: state `0xFFB0A6 = 1`, timer `0xFF9552 = 0x0A`,
   `bset #0, @0xFFFF52`.
2. `sub_564B2` `0x000564B2` — the `DSP POWER:ON & RESET!` step: `0xFFB0A2 = 0x80`,
   `(0xFFFD6A & 0xFFC0) | 0x10`, set bit 2 of `0xFFFB90` and of `0xFFFF34`, clear
   bit 2 of `0xFFFF36`, with `nop` padding between each.
3. `sub_564FA` `0x000564FA` — after the delay: `bset` bits 1, 2 and 3 of
   `0xFFFF52`, restart the timer, state = 2.
4. `sub_56520` `0x00056520` — the SCI initialisation quoted above; state = 4.
5. The link then runs as a state machine through the 13-entry table at
   `0x0005645C` indexed by `0xFFB0A6` (`0x56490`, `sub_564FA`, `sub_56520`, …,
   `sub_566E4`, `sub_56732`, `sub_5678E`, `sub_567DC`).
6. Shutdown is `sub_56056` `0x00056056`: clear every `0xFFFF52` bit, clear bit 4 of
   `0xFFFF59`, reset all link state. Reached from `0x0000EDA0`, `0x0003EA2C` and
   `0x000743D0`.

`TIME OUT:3sec!` belongs to the idle/timeout states around `0x000565C0`, which
use a 16-bit counter compared against `0x8980` (`0x000565FA`).

**The version query and where its answer goes.** There is no rate table in the
sense a DVSI part would have; the identifying configuration artifact here is the
version handshake plus the opcode-`0x15` table upload.

```
CPU -> DSP    1F 02 00...00 21              (canned ROM packet 0x0005901E)
DSP -> CPU    9F <hi> <lo> ...              (payload stored as a word at 0xFFB0DC)
```

`sub_5683E` at `0x00056A04`:

```
0x56A04  mov.b @0xFFB0E1, r4h
0x56A08  mov.b @0xFFB0E2, r4l
0x56A0C  mov.w r4,  @0xFFB0DC       ; the DSP firmware version
0x56A28  bset  #1,  @0xFFB0A4       ; "version known"
```

MAIN then forwards it to SUB as an inter-processor message, `sub_74310`
`0x00074310`:

```
0x74336  btst  #1, @0xFFB0A4        ; version known?
0x7433E  mov.w #0x5A03, r4
0x74342  mov.w r4, @0xFF96F8        ; message id 0x5A, length 3
0x74346  mov.w @0xFFB0DC, r4
0x7434A  mov.b r4h, @0xFF96FA       ; payload[0]
0x7434E  mov.b r4l, @0xFF96FB       ; payload[1]
0x74358  jsr   loc_73AD0            ; transmit over the SCI_C inter-processor link
```

MAIN's own version goes out the same way as message `0x5B` length 4, three bytes
from `0xFF813F` (`sub_74364` `0x00074364`).

On the SUB side the version screen is `sub_FFF00ED1` at `0xFFF00ED1`. It copies
three 20-byte templates and patches digits into them:

| SUB address | Template |
| --- | --- |
| `0xFFF487EC` | `Main Ver.  :  .    ` |
| `0xFFF48800` | `Sub  Ver.  :  .    ` |
| `0xFFF48814` | `DSP  Ver.  :  .    ` |

The digits come from a shared status block at **SUB RAM `0x00008C4D`**: bytes
`+0x21`/`+0x22`/`+0x23` become the Main version, `+0x24`/`+0x25`/`+0x26` the Sub
version, and **`+0x27`/`+0x28`/`+0x29` the DSP version** (`0xFFF00F9A`,
`0xFFF00FB3`, `0xFFF00FCC`). Byte `+0x20` is a flag: when zero, the drawn string
is two characters shorter (`0xFFF00FE5`–`0xFFF00FEF`), i.e. the last field is
suppressed.

So the full chain for the number on the version screen is:

```
DSP --(0x9F response, sync SCI_A, DMA)--> MAIN 0xFFB0DC
    --(inter-processor message 0x5A, async SCI_C 0xFFFE90)--> SUB 0x00008C4D+0x27
    --> "DSP  Ver.  :"
```

**The version gates real behaviour.** MAIN compares the received version against
a constant in four places, e.g. `0x0005B0CC`:

```
0x5B0CC  mov.w @0xFFB0DC, r4
0x5B0D0  cmp.w #0x041E, r4
0x5B0D4  bcc   loc_5B0E2          ; version >= 0x041E -> send the 0x15 table uploads
0x5B0D6  ...   0xFFB0A9 += 4      ; older DSP firmware -> skip them
```

Also at `0x0005B1A1`, `0x0005B4E4` and `0x0005B52A`. On the newer-firmware branch
MAIN calls `sub_5A0B4` (opcode `0x15`, subtype `0x01`, 18 five-byte records from
`0xFF4576`) and `sub_5A0C0` (subtype `0x11`, 6 records from `0xFF4696`); the
blank-record default in ROM at `0x00004C14` is twenty spaces, so these records are
**callsign / ID text**. That is significant on its own: the DSP, not MAIN, is
doing the C4FM callsign and ID matching, which places it as a baseband engine and
not merely a speech codec.

### 6. Can it be reached directly?

**(a) Is there a pass-through?** Yes, and it is the most important finding in this
document. MAIN's SCI_A interrupt handler is a two-way switch on a flag at
`0xFF813A` (`sub_5615C`, `0x0005615C`):

```
0x56160  mov.b @0xFF813A, r4l
0x56164  bne   loc_561A8                ; bridge mode
         ; ---- normal DSP mode ----
0x56166  mov.b @0xFFFF8C, r5l           ; SSR
0x5616A  and.b #0x20, r5l ; bne         ; framing/overrun error path
0x5616E  and.b #0x87, r5h ; mov.b r5h, @0xFFFF8C
0x56172  mov.b @0xFFFF8D, r5l           ; RDR
0x56174  mov.l @0xFF815E, er4 ; mov.b r5l, @er4 ; adds #1, er4
0x5617E  cmp.w #0x27C8, r4 ; bcs ; mov.l #0xFF23C8, er4   ; 1 KB ring wrap
0x5618A  mov.l er4, @0xFF815E
0x56194  rte
loc_561A8:
0x561B0  jsr   loc_7711E                ; hand the byte to the generic serial engine
0x561C0  rte
```

The transmit side has the matching split: normal traffic goes out by DMA
(`sub_4834E`), bridge traffic goes out through a plain polled loop at
`0x0007701E`:

```
0x7701E  mov.b @0xFFFF8C, r1l ; bpl 0x7701E     ; wait for TDRE
0x77022  mov.b r0h, @0xFFFF8B                   ; write TDR
0x77024  bclr  #7, @0xFFFF8C                    ; clear TDRE
```

up to `0x40` bytes per call, from a queue whose control block is at `0xFF6288`.

`0xFF813A` is written in exactly **two** places in the whole image, both in the
reset initialisation `sub_20FA`:

```
0x21F8  mov.b #0, r4l
0x21FA  mov.b r4l, @0xFF813A            ; default: normal DSP mode
0x21FE  mov.b #0xC8, r6l                ; 200 attempts
loc_2200:
0x2200  mov.b @0xFFFF4C, r4l            ; read an input port
0x2202  and.b #0x7F, r4l
0x2204  cmp.b #0x7D, r4l
0x2206  beq   loc_221E
0x2208  dec.b r6l ; bne loc_2200
0x220C  mov.b r4l, @0xFF813B            ; normal boot
0x2218  jsr   sub_54C44
0x221C  bra   loc_2240
loc_221E:
0x221E  mov.b r4l, @0xFF813B
0x2222  mov.b #1, r4l
0x2224  mov.b r4l, @0xFF813A            ; BRIDGE MODE
0x2228  jsr   sub_55FFE                 ; set up ring pointers 0xFF8152/0xFF8156 = 0xFF3CEA
0x2234  jsr   loc_78106                 ; start the generic serial engine
```

So the bridge is a **boot-time strap or held-key condition** on port `0xFFFF4C`,
tested before any UI exists, with the required pattern `(x & 0x7F) == 0x7D` — all
of bits 0, 2, 3, 4, 5, 6 high and bit 1 low. Which physical pins those are is
**unknown** from the image; there is no schematic in this package.

In bridge mode MAIN also reconfigures SCI_A away from synchronous operation
(`sub_78222` / `sub_7823C`, `0x00078222`):

```
SCR = 0x00 ; SMR = 0x08 ; BRR = 0x0C ; delay 255 ; SCR = 0x70
```

`SMR = 0x08` is asynchronous, 8 data bits, no parity, **2 stop bits**;
`BRR = 0x0C` with `CKS = 0` gives φ/416 (38400 at φ = 16 MHz, 57600 at
φ = 24 MHz — the exact rate depends on MAIN's φ, which I did not pin down);
`SCR = 0x70` is `RIE | TE | RE`. This is what a bootloader link looks like, and it
is a completely different electrical arrangement from the voice link.

**In normal operation there is no pass-through, and that is a positive result,
not a coverage gap.** I scanned the entire MAIN image for every H8S absolute
addressing form that could write `0xFFB13E`..`0xFFB17F`: 40 sites, all inside
`0x00058FD4`–`0x0005EB54`, i.e. inside the digital-voice module. Nothing in the
CAT/serial modules, the SD/file modules, the inter-processor module or the
display modules touches the command buffer. The DMA source register `0xFFFC20` is
written from exactly one instruction (`0x00048360`), and the pointer it reads is
only ever `0xFFB13E`, `0xFFB1A0`, ROM `0x5901E` or ROM `0x5903E`. The
packet-builder request index `0xFFB0B6` has **no** absolute-addressing writer
anywhere in the image; it is only read, at `0x0005A3AC`. A complete
`jsr/jmp @aa:24` edge list (9,052 sites) shows only three external entry points
into the DSP driver window `0x56000`–`0x56C00`: `sub_56046` (shutdown) from
`0xEDA0`/`0x3EA2C`/`0x743D0`, and the task ticks `0x56236`/`0x56272` from the
scheduler at `0x2Cxx`–`0x39xx`.

**(b) Is the bus physically exposed?** Not determinable from the firmware, and the
firmware evidence points the other way. The link is clocked-synchronous with the
DSP driving `SCK`, moved by DMA, with a dedicated control port at `0xFFFF52` and a
handshake input at `0xFFFF49` bit 7. That is a chip-to-chip arrangement. No
connector, jack or accessory string in either image is associated with the
`0xFFFF88` block. **Unknown** without a board teardown.

**(c) Is the DSP firmware field-updatable?** **Yes.** SUB carries the complete
screen for it at `sub_FFF0DE56` (`0xFFF0DE56`):

| SUB address | String |
| --- | --- |
| `0xFFF4ACF8` | `---DSP WRITE MODE----` |
| `0xFFF4AD0E` | `Push DISP Key!` |
| `0xFFF4AD1D` | `Loading...` |
| `0xFFF4AD28` | `Complete` |
| `0xFFF4AB44` | `FIRM ERROR` |

The screen reads bytes `+0x20` and `+0x21` of the shared status block at SUB RAM
`0x00008C4D` as `(phase, progress)` (`0xFFF0DE96`–`0xFFF0DEA6`). MAIN generates
exactly that pair, `sub_5E9E2` `0x0005E9E2`:

```
0x5E9E6  mov.b @0xFFB0C4, r4l          ; the DSP-write state, 0..7
0x5E9EA  cmp.b #5, r4l ; bcs -> (0,0)
0x5E9EE  -> (1,3)
0x5E9F2  mov.b @0xFF813A, r4h ; bne -> (1,6)   ; bridge mode selects a different progress
0x5E9FC  cmp.b #7, r4l ; bcs ; -> (2,0x0A)
0x5EA04  jsr sub_8532                  ; push to the display
```

And MAIN drives the write sequence itself, `sub_5DD00` `0x0005DD00`, state
`0xFFB0C4` = 0..7:

| State | Action |
| --- | --- |
| 0 | `bset #0, @0xFFFF52` via `sub_5DCDA` `0x0005DCDA`; state = 1 |
| 1 | `bset #3, @0xFFFF52` (assert reset), timer `0xFF9552 = 3`; state = 2 |
| 2 | timer expires → `bclr #3, @0xFFFF52` (release reset), timer `0xFF9554 = 0x0A`; state = 3 |
| 3 | timer expires → `bset #5, @0xFFFBA5`, `bset #5, @0xFFFB91`, **`jsr sub_78222`** (SCI_A → async 8-N-2); state = 4 |
| 4 | wait `@0xFFFF49` bit 7 clear → `bset #3, @0xFFFBA4`; state = 5 |
| 5 | wait `@0xFFFF49` bit 7 set → timer `0xFF9554 = 0x0B`; state = 6 |
| 6 | timer expires → `bclr #4, @0xFFFF52`, `@0xFFAAE0 = 0x16`; state = 7 |
| 7 | done |

From state 5 onward each tick calls `sub_7815C` (`0x0005DD12`), which pumps the
byte queues at `0xFF6288` — one of which drains to the DSP's `TDR` through the
polled loop at `0x0007701E`. The mode is entered from `sub_103C0` `0x000103C0`,
which clears `0xFFB0C4` and dispatches mode code `0xEE` through `sub_3FF10`.

**The SUB-side gate, traced.** MENU flagged that `sub_FFF0DE56`'s sole caller is
`sub_FFF0D6D9` at `0xFFF0D709` with the entry condition unknown. It is now traced.
`sub_FFF0D6D9` (`0xFFF0D6D9`) is a **screen dispatcher on byte `+0x01` of SUB's
global state struct at `0x00008C4D`, i.e. the byte at `0x00008C4E`**:

```
0xFFF0D6D9  mov.l   #0x8C4D, r1
0xFFF0D6DF  movu.b  1[r1], r1
0xFFF0D6E1  cmp #0x0B -> sub_FFF0E617      0xFFF0D6E5  cmp #5 -> sub_FFF0DA4B
0xFFF0D6E9  cmp #7    -> sub_FFF0DB03      0xFFF0D6ED  cmp #8 -> sub_FFF0DE56  <-- DSP WRITE MODE
0xFFF0D6F1  cmp #9    -> sub_FFF0E118      0xFFF0D6F5  cmp #0x0A -> sub_FFF0E392
0xFFF0D6F9  cmp #2    -> sub_FFF0D73E      else rts
```

Its own caller `sub_FFF0D6C4` (`0xFFF0D6C4`) clears `[0x00008D79]`, calls
`sub_FFEF0408(0, 0)` to blank the screen, then dispatches. So **SUB shows the DSP
write screen when `[0x00008C4E] == 8`, and nothing more** — it is a passive
display selector, not a gate on the operation. That matches everything on the
MAIN side: `0x00008C4D` is the same struct into which MAIN's inter-processor
messages deposit the version digits (`+0x21`..`+0x29`) and the write progress
(`+0x20`, `+0x21`), and MAIN has its own independent entry (`sub_103C0`
`0x000103C0`, mode code `0xEE`) and its own state machine (`0xFFB0C4`,
`sub_5DD00`). **The decision to enter DSP WRITE MODE is MAIN's; SUB only draws
it.** I did not name the single instruction that writes `0x00008C4E` — that
struct base is loaded at **2,351** sites across the SUB image
(`mov.l #0x00008C4D, Rd` pattern count), so isolating one field's writer needs a
proper RX data-flow pass rather than a pattern scan.

There is **no DSP firmware image and no DSP firmware filename in either
plaintext image** (full-image string search; MAIN's only data filenames are
`QSOMSG.dat`, `BACKUP.dat`, `MEMORY.dat` and friends, SUB's are `I:\FT3D…` and
`\Backup.bin`). So the DSP image is not carried in this package and is not read
from a named file — it arrives over the wire while the radio is in DSP WRITE
MODE. That is consistent with the vendor shipping only Main and Sub updaters and
with the radio nonetheless displaying a third version number that moves
independently.

**(d) What would actually have to happen to send your own frames to it?** Two
distinct routes, and they need different things.

*Route 1 — the bridge (bytes only, no framing help).* Boot MAIN with the strap
condition at `0xFFFF4C` satisfied, so `0xFF813A` becomes 1. Then the DSP's serial
port is in async 8-N-2 at φ/416 and every byte MAIN receives on that port is
pushed into the queue engine, and bytes in the outbound queue are written to the
DSP's `TDR`. The obstacles, in order: you do not know which pins `0xFFFF4C`
reads, so you cannot reproduce the strap without a board probe; you do not know
which physical connector feeds the queue engine's other side, because the
peripheral block at `0xFFEE00`–`0xFFEE53` is unidentified in this pass; and in
that mode the DSP is held in its own boot/loader state by the reset and boot
lines on `0xFFFF52`, so what it accepts is a loader protocol, not the 32/96-byte
voice framing.

*Route 2 — the normal frame driver (full framing, but no external input).* This
is the path that speaks the protocol documented above, and it is closed from
outside. The command buffer is only written by the digital-voice module, the
request index `0xFFB0B6` has no absolute writer, and the DMA source is one of
four fixed buffers. To inject a frame you would have to change MAIN's firmware —
which the vendor update path can do, since the MAIN updater writes the whole H8S
image over the Renesas boot-ROM USB device. That is a firmware modification, not
a message you can send to a running radio.

Neither route is something you can do over the USB cable to a stock radio.
Nothing here required or involved writing to a device.

### 7. Which side owns voice

```
                      RF / IF
                         |
                   [ receive chain ]            <- RF-SDR's area
                         |
                   demodulated C4FM baseband
                         |
   +---------------------v-----------------------+
   |            DSP / vocoder device             |   its own firmware, own version
   |  - C4FM demod/remod, AMBE+2 speech codec    |   drives SCK: it is the clock master
   |  - callsign / ID matching (opcode 0x15 list)|
   |  - DTMF (opcode 0x0B)                       |
   +--------------^-----------------+------------+
                  |                 |
        SCI_A 0xFFFF88, clocked synchronous, external clock,
        32/96-byte checksummed frames, DMAC ch0 in / ch1 out
                  |                 |
   +--------------+-----------------v------------+
   |                 MAIN  (H8S)                 |
   |  sub_5683E frame assembler / dispatcher     |
   |  sub_58FA2 frame builder + checksum          |
   |  sub_4834E DMA transmit engine               |
   |  RX ENABLE/DISABLE, MUTE ON/OFF, STOP ENCODE |
   |  owns the radio hardware and the DSP reset   |
   +----------------------+-----------------------+
                          |
     SCI_C 0xFFFE90, async, inter-processor messages
     (0x32, 0x38, 0x3A, 0x3B, 0x42, 0x58, 0x5A, 0x5B, 0x5E)
     0x5A = DSP version, 0x5B = MAIN version
                          |
   +----------------------v-----------------------+
   |                 SUB  (RX64M)                 |
   |  UI, menus, version screen, DSP WRITE MODE   |
   |  screen; 3 async SCIs only (one is the GPS); |
   |  no SPI, no SSI, no synchronous serial;      |
   |  12-bit DAC R12DA 0x00088040 + 2 ADCs        |
   |  -> touches analog audio, never voice frames |
   +-----------------------------------------------+
```

The owner should approach **MAIN**. SUB never sees a voice frame: it has exactly
three asynchronous SCI channels (`0x0008A000`, `0x0008A040`, `0x0008A060`) and no
SPI or synchronous-serial peripheral anywhere in its 4 MB image — a negative
established over a full linear sweep of 2,077,781 decoded instructions, not a
partial scan. SUB's only involvement with the DSP is displaying its version
number and its write-mode progress, both delivered by MAIN over the
inter-processor link. SUB's DAC and ADCs (independently confirmed by SUB-VEC)
place it on the analog side of the audio path, not the digital voice path.

## USB relevance

**Question 1 (everything USB).** Two things the USB agents need.

First, an unreferenced but complete **USB CDC-ACM descriptor set sits in MAIN's
ROM**, which nobody has reported:

| MAIN offset | Content |
| --- | --- |
| `0x0007B680` | device descriptor `12 01 10 01 02 00 00 08 AA 26 20 00 00 01 00 00 03 01`, i.e. bcdUSB 1.10, class `0x02` (CDC), EP0 8 bytes, **idVendor `0x26AA`, idProduct `0x0020`**, bcdDevice `0x0100`, iSerialNumber 3, 1 configuration |
| `0x0007B698` | IEEE-1284 printer device ID string `MANUFACTURER:ACME Manufacturing;COMMAND SET:PCL,MPL;MODEL:LaserBeam ?;COMMENT:Anything you like;ACTIVE COMMAND SET:PCL;` |
| `0x0007B711` | configuration descriptor set: `09 02 43 00 02 01 00 C0 10` (2 interfaces, self-powered, 32 mA), CDC header/ACM/union/call-management functional descriptors, `07 05 83 03 08 00 10` (EP `0x83` interrupt IN), `09 04 01 00 02 0A 00 00 00`, `07 05 01 02 40 00 00` (EP `0x01` bulk OUT 64), `07 05 82 02 40 00 00` (EP `0x82` bulk IN 64) |

**None of these blobs is referenced by any instruction in the image** — I scanned
for `mov.l #imm32` and for raw 32-bit pointers to `0x7B680`, `0x7B698`, `0x7B710`
and `0x7B711` and found nothing. They are almost certainly dead data from a
linked-in vendor USB library, along with the ACME/LaserBeam placeholder that
ships in sample code. The right reading is "MAIN's build pulled in a USB
device-stack library whose descriptors were never wired up", and it needs
checking against whether the H8S part MAIN actually is has a USB module at all.
The VID/PID pair `0x26AA:0x0020` is worth recording either way.

Second, the module at MAIN `0x76000`–`0x78600` is a **generic multi-port,
queue-driven byte relay** (control block `0xFF6288`, second block `0xFF62D8`,
register-looking accesses at `0xFF62F8`, and a peripheral block at
`0xFFEE00`–`0xFFEE53` plus external addresses `0xFEE000`–`0xFEE20C` and
`0x00082000`). It is called from clusters at `0x29xxx` and `0x33xxx` as well as
from the DSP bridge. If anyone is hunting MAIN's external comms, that module is
where it lives, and identifying the `0xFFEE00` block is the unlock.

**Question 2 (USB SDR).** The DSP link is the only high-rate synchronous data
path in MAIN, and it is 32/96-byte packets of already-vocoded speech and control
fields on a bus clocked by the DSP. It is not IQ, not raw receiver samples, and
its DMA channels terminate at `0xFFFF8B`/`0xFFFF8D` — a byte-wide SCI data
register, not a wide converter port. It removes nothing from the SDR question but
it also offers nothing: there is no sample source behind it, only a codec.

**Question 3 (the DSP).** Answered above. The short version for the orchestrator:
the device is on MAIN's SCI at `0xFFFF88` in clocked-synchronous mode; the framing
is proprietary (fixed 32/96 bytes, opcode first, additive checksum last) and
**not** AMBE-3000R; the full command set is in `ida\out\dsp\commands.tsv`; a
boot-strap-selected pass-through at `0xFF813A` does exist and is the DSP-write
data path; and no route from a stock radio's USB port reaches it.

## Open

Most valuable first.

1. **Identify the peripheral block at MAIN `0xFFEE00`–`0xFFEE53`** and the queue
   producers for the control block at `0xFF6288`. That single answer tells the
   owner which physical connector the DSP bridge is wired to, which is the whole
   remaining gap in the "can it be reached" answer. `0x76000`–`0x78600` needs a
   proper decode pass; my force-decode of `0x76A00`–`0x76C90` came out
   misaligned in places and I worked from raw bytes there.
2. **Identify the pins behind `0xFFFF4C` and `0xFFFF52`.** `0xFFFF4C` is the
   boot-strap that selects bridge mode; `0xFFFF52` carries the DSP's enable,
   reset and boot-mode lines. Pairing these with the port data-direction
   registers, and with whatever MAIN-FULL settles about the exact H8S part, would
   turn "a strap condition" into a named pin. Note that MAIN is **not** a plain
   H8S/2378: it has SCI blocks at `0xFFFF60`, `0xFFFF68`, `0xFFFF88` and
   `0xFFFE90`, a DMAC at `0xFFFC00` on a `0x20` stride with source/destination/
   count/control at `+0x00`/`+0x04`/`+0x0C`/`+0x14`, and live vectors as high as
   slot 238 — the H8S/237x vector map stops well short of that.
3. **Decode the async loader protocol.** With the bridge identified, dump the
   bytes the queue engine sends during states 5–7 of `sub_5DD00` and work out the
   loader handshake. The handshake input is `0xFFFF49` bit 7 and the sequence
   ends by writing `0x16` to `0xFFAAE0`.
4. **Pin MAIN's φ** so the async rate (φ/416 with `BRR = 0x0C`) becomes a real
   number, and confirm that the synchronous link really has no MAIN-side rate
   control (I am confident: `BRR = 0x00` and `CKE1 = 1`).
5. **Resolve the payload layout of opcodes `0x06`–`0x0A`, `0x16` and `0x19`.**
   These are the voice/data frames. `sub_594FA` (`0x000594FA`) and the `0xA6`/`0xB6`
   handler `sub_56A94` (`0x00056A94`) are where the field structure is; `sub_56A94`
   already shows it masking the top two bits of payload byte 1 and the bottom two
   bits of byte 3. Getting these fields out would let the owner interpret a
   captured voice frame, which is the last piece of a full protocol description.
6. **Find the single writer of SUB `0x00008C4E`.** Setting it to 8 is what puts
   the `---DSP WRITE MODE----` screen up. The dispatcher is traced (above) but the
   producer is buried in a struct with 2,351 access sites. An RX data-flow pass
   over SUB's inter-processor message handler would find it, and would also
   confirm that message `0x5A` is what lands the DSP version at `+0x27`.
7. **Decide what `0xFF8DDE` is.** It has ~250 readers and only 3 writers
   (`0x0000E516`, `0x00010580`, `0x000105B6`), and it switches opcodes `0x0C`–`0x0E`
   to 96-byte frames and enables response `0x9A`. It is a top-level mode global —
   probably the digital/analog or wide/narrow mode — and naming it would clarify
   several branches in the DSP driver.
