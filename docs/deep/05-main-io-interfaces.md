# MAIN (H8S) external interfaces — serial channels, USB, program switch, flash

Agent MAIN-IO. Subject: `decrypted\FT3D_MAIN_ver102_EXP.bin` (1,048,576 bytes,
content to `0x7B751`, base 0, big-endian). Private database `MAIN_IO`, seeded
`--copy-from ida\db\radio\MAIN.i64`.

## Verdict

**The H8S MAIN processor has an on-chip USB device controller, and the ver 1.02
application firmware contains two complete USB device stacks.** This overturns
the project's working assumption. Registers `0xFFEE00`–`0xFFEE53` are a Renesas
USB Function Module (IFR0/1/2, IER0/1/2, EPDR0S/0O/0I/1/2/3, EPSZ0O/EPSZ1, FCLR,
TRG); three dedicated vector slots (234, 235, 238) carry its three interrupt
sources, which is only possible for an on-chip module. Stack 1 (default) presents
a **vendor-specific device, VID `0x26AA` PID `0x0001`**, class `FF/01/FF`, EP1 OUT
bulk 64 + EP3 IN interrupt 8, with four vendor control requests `0xD1`–`0xD4`.
Stack 2 (alternate) presents a **USB CDC-ACM virtual COM port, VID `0x26AA`
PID `0x0020`**, EP1 OUT bulk 64 + EP2 IN bulk 64 + EP3 IN interrupt 8; it is
selected at power-on when the port register `0xFFFF4C` masked with `0x7F` reads
`0x7D` — one input line held low, i.e. a key/jumper condition, not the program
switch. Separately, MAIN runs **four SCI channels**: an external user port at
selectable 4800/9600/19200/38400 baud that carries an ASCII/binary clone-style
framed protocol, an NMEA GPS-OUT stream and a DSP debug trace; a clocked-
synchronous DMA-fed link to the **DSP/vocoder**, proven by `CPU>DSP:` /
`DSP>CPU:` trace strings and a 15-entry opcode table; a 500 kbaud DMA link that
is almost certainly the inter-processor path to SUB; and a fixed-38400 link to an
unidentified on-board module which the external port can be bridged into.
**MAIN's application firmware contains no self-flash path**: no flash-control
register block, no `FKEY`/`FMATS` key writes, no erase/write sequence anywhere in
the 4,491 functions recovered. The program switch is not read by the application
at all — entering the update path is a hardware decision made at reset.

## Method

What I ran, in order, all through `ida\run_job.py --db MAIN_IO`:

| Script | What it did |
| --- | --- |
| `ida\jobs\mainio_scan.py` | seeded 1,377 function starts from a Python pre-scan of every `jsr @aa:24` (`5E 0x xx xx`) and `jmp @aa:24` target, then enumerated every instruction operand naming `0xFF0000`–`0xFFFFFF` |
| `ida\jobs\mainio_pass2.py` | seeded a further 1,540 starts from post-`RTS`/`RTE` boundaries and Renesas H8S prologues (`01 00 6D F6`, `6D F6 0F F6`, …); re-scanned operands; dumped the 12 distinct interrupt-vector handlers and the DSP region |
| `ida\jobs\mainio_pass3.py` | wide operand scan over `0xFFE000`–`0xFFFFFF` and `0xFF6000`–`0xFF6FFF`; xref reports; four rounds of targeted disassembly dumps (USB stack, four SCI drivers, DSP protocol, command interpreter, alternate USB stack) |

Coverage achieved: **4,491 functions** (from the inherited 1,298), 105,782 code
bytes of the 506,880 in `0x400`–`0x7C000` = **20.9 %**. That is low as a fraction
of the image because most of the image is data — the APRS symbol table
(`0x44000`+), font and kanji tables (`0x76000`–`0x7B4B2`), string tables — but it
covers the whole interrupt-driven periphery, which is what this assignment needs.
Operand coverage inside those functions is exhaustive: 17,594 references to
`0xFF0000`–`0xFFFFFF` at 2,530 distinct addresses.

What I could not do: identify the exact H8S part number. The register map I
recovered (RAM from `0xFEE000`, USB at `0xFFEE00`, an SCI at `0xFFF610`, port
DDRs at `0xFFFB80`, an SCI at `0xFFFE90`, ports at `0xFFFF40`/`0xFFFF50`, more
SCIs at `0xFFFF60`/`0xFFFF88`, TPU at `0xFFFFC0`–`0xFFFFFF`) does not match the
H8S/2370 group, and I did not try to pin the part from a datasheet. That is
MAIN-FULL's scope. Nothing below depends on the part number.

Machine-readable tables, all under `ida/out/main-io/`:

| File | Contents |
| --- | --- |
| `sci_channels.tsv` | the four SCI channels: registers, mode, BRR, baud, vectors, handlers, ring buffers, DMA channel, far end |
| `ioreg_wide.tsv`, `ioreg_wide_hist.tsv` | every operand naming `0xFFE000`–`0xFFFFFF` / `0xFF6000`–`0xFF6FFF`, with the disassembly line |
| `io_operands.tsv`, `io_hist.tsv` | the same for the whole `0xFF0000`–`0xFFFFFF` range (17,594 rows) |
| `port_usage.tsv` | per-register bit-level usage of the port input (`0xFFFF4x`), output (`0xFFFF5x`), DDR (`0xFFFB8x`) and pull-up/control (`0xFFFBAx`–`0xFFFBCx`) registers |
| `functions.tsv` | the 4,491 recovered functions |
| `disasm.txt`, `disasm3.txt` | annotated disassembly dumps. `disasm.txt` holds the 12 interrupt-vector handlers and the DSP region; `disasm3.txt` is overwritten each pass and holds only the last set (the serial command interpreter, the SCI-B parser and the alternate USB stack). Everything cited below is reproducible by putting the address range back into `dump_list3.txt` and re-running `mainio_pass3.py` with `--reopen` |
| `call_targets.txt`, `jmp_targets.txt`, `seed2.txt` | the seed lists, so the pass is reproducible |
| `xrefs_watch.tsv` | xrefs for the watched addresses |

## Hand-off to DSP-AMBE — read this first

**The DSP is owned by MAIN, not SUB, and it is on SCI channel C at `0xFFFF88` in
clocked-synchronous mode.** Evidence:

A trace-string block at file `0x05AE1C`–`0x05AF70` (confirmed, bytes read):

```
05AE1C  "CPU>DSP: "          05AE28  "DSP>CPU: "
05AE5A  "DSP POWER:ON & RESET! \r\n"
05AE72  "TIME OUT:3sec!\r\n"  05AE82  "DSP?\r\n"
05AE88  "DSP>CPU: ACK\r\n"    05AE96  "DSP>CPU: NAK\r\n"
05AEA4  "CPU>DSP: ACK\r\n"    05AEB2  "CPU>DSP: NAK\r\n"
05AEC0  "CPU>DSP: RX DISABLE\r\n"   05AED6  "CPU>DSP: RX ENABLE\r\n"
05AEEA  "CPU>DSP: MUTE ON\r\n"      05AEFC  "CPU>DSP: MUTE OFF\r\n"
05AF10  "CPU>DSP: STOP ENCODE\r\n"  05AF26  "CPU>DSP:VER?\r\n"
05AF34  "DSP>CPU: DATA TEXT SET\r\n"
05AF4C  "DSP>CPU: TERM TX\r\n"      05AF5E  "DSP>CPU: TERM RX\r\n"
```

A pointer table at `0x05AE36` (`00 05 AE 5A | 00 05 AE 72 | 00 05 AE 82 |
00 FF 2D C8 | 00 05 AE 88 | 00 05 AE 96 | 00 FF 2D C8 | 00 05 AE A4 |
00 05 AE B2`) mixes flash strings with a RAM formatting buffer at `0xFF2DC8`.

**DSP opcode table**, decoded from `sub_5A506` at `0x05A506`–`0x05A5A5`
(confirmed — a linear `cmp.b`/`beq` chain on the first byte of the message
buffer, which is the message opcode):

| Opcode | Named in the trace as | Handler |
| --- | --- | --- |
| `0x06`, `0x07` | (shared formatter) | `0x05A8CE` |
| `0x08` | (shared formatter) | `0x05A948` |
| `0x09`, `0x0A` | payload-length-driven hex dump, length byte from `0xFFB122` | `0x05A5C4` |
| `0x0B` | | `0x05A762` |
| `0x11`, `0x31` | | `0x05A6C6` |
| `0x12`, `0x32` | | `0x05A6CC` |
| `0x15` | | `0x05ACDE` (96-byte frame) |
| `0x16` | | `0x05A9FC` (96-byte frame) |
| `0x18` | `CPU>DSP: STOP ENCODE` | `0x05AF10` |
| `0x19` | | `0x05AAD6` (96-byte frame) |
| `0x1A` | byte[1]==0 → `RX ENABLE`, else `RX DISABLE` | `0x05AED6` / `0x05AEC0` |
| `0x1D` | `MUTE ON` / `MUTE OFF` (from `0x05A74C`, strings at `0x05AEEA`/`0x05AEFC`) | `0x05A74C` |
| `0x1F` | `CPU>DSP:VER?` | `0x05AF26` |
| anything else | unknown → `0x05AD8C` | |

`0x1F` = "version query" is the route to the DSP version string shown on the
radio's version screen.

**Transmit path**, `sub_4834E` at `0x04834E` (confirmed):

```
04834E  mov.b  @0xFFFF8C:8, r4l      ; wait SSR.TDRE
048350  and.b  #0x80, r4l
048352  beq    sub_4834E
048354  mov.l  #0x1A0, er4
04835A  mov.l  er4, @0xFFFC34        ; DMA ch1 control
048360  mov.l  er5, @0xFFFC20        ; DMA ch1 source = message buffer
048366  mov.l  #0xFFFF8B, er4
04836C  mov.l  er4, @0xFFFC24        ; DMA ch1 dest = SCI-C TDR
048372  mov.b  @er5, r4l             ; opcode
048374  cmp.b  #0x19 / #0x16 / #0x15 -> 96-byte frame
048380  mov.b  @0xFF8DDE, r4h        ; if config flag set and 0x0C <= op < 0x0F -> 96
04838E  mov.l  #0x20, er4            ; else 32-byte frame
048394  mov.l  er4, @0xFFFC2C        ; DMA ch1 count
0483A8  mov.l  #0x200000, er4 -> @0xFFFC38
0483B4  mov.b  #0x96, r4l -> @0xFFFD22-1 (0xFFFD21, ch1 activation select)
0483BA  mov.l  #0x800001A0, er4 -> @0xFFFC34   ; DMA enable
0483C6  bclr   #1, @0xFFFF52:8       ; drop a port line (DSP strobe / CS)
0483CA  bset   #7, @0xFFFF8A:8       ; SCR.TIE -> start
```

So **CPU→DSP frames are fixed-length, 32 bytes normally and 96 bytes for opcodes
`0x15`, `0x16`, `0x19`**, pushed by DMA into the synchronous SCI. 96 bytes is the
voice-frame size; 32 bytes is the control/short frame.

**Receive path**: `sub_5615C` (vectors 148/149) reads `SSR 0xFFFF8C` and
`RDR 0xFFFF8D` into a ring at `0xFF23C8` (write pointer `0xFF815E`, read pointer
`0xFF815A`, drained by `sub_5683E`). Channel init `sub_56520` at `0x056520` sets
`SMR = 0x80` (clocked synchronous), `BRR = 0x00`, `SCR = 0x12` then `|0x40`
→ `0x52` = RIE | RE | CKE1, i.e. **external clock, MAIN is the slave**. So the
DSP supplies the bit clock; the rate is not set by MAIN and is bounded by
φ/4 = 4 Mbit/s.

**This is not AMBE-3000R framing.** No `0x61` start byte, no 16-bit big-endian
length, no `AMBE`/`DVSI`/`PRODID`/`VERSTRING`/`RATEP`/`RATET` strings anywhere in
the image (searched the full 1 MB). It is a proprietary fixed-length frame with a
1-byte opcode, on a synchronous serial bus, ACK/NAK-ed both ways.

## Findings

### 1. Serial channels

Four SCI blocks are configured. Full detail in
`ida\out\main-io\sci_channels.tsv`. Register identity is confirmed behaviourally
in every case (write-only SMR/BRR/TDR, bit-addressed SCR, read-modify-write SSR
with the `0x38` error mask ORER|FER|PER, read-only RDR).

| | SCI-A | SCI-B | SCI-C | SCI-D |
| --- | --- | --- | --- | --- |
| SMR/BRR/SCR/TDR/SSR/RDR | `FFFE90`–`FFFE95` | `FFFF60`–`FFFF65` | `FFFF88`–`FFFF8D` | `FFF610`–`FFF615` |
| Mode | async 8N1, CKS=0 | async 8N1, CKS=0 | **clocked synchronous**, slave (CKE1=1) | async 8N1, CKS=0 |
| BRR | table `0x0452C2` = `67 33 19 0C`; `0x0C` in alt mode | `0x0C` | `0x00` | `0x00` |
| Baud (φ=16 MHz) | **4800 / 9600 / 19200 / 38400**, index in `0xFF8C27` | **38400** | external clock, ≤ 4 Mbit/s | **500 000** |
| Vector group | 160–162 | 152–154 | 148–150 | 224–226 |
| ERI/RXI | `0x045462` | `0x045520` | `0x05615C` | `0x044A70` |
| TXI | `0x045406` | `0x0454E2` | `0x0483D0` | `0x048326` |
| Init | `0x045186` | `0x04556E`, `0x048BF2` | `0x056520` | `0x0446BE` |
| TX driver | `0x045312`, `0x0453A0` (interrupt) and `0x06B934` (DMA ch2) | `0x0454E2` (interrupt) | `0x04834E` (DMA ch1) | `0x0482D4` (DMA ch0) |
| TX buffer | `0xFF29C8`–`0xFF2DC7` (1 KB ring) | `0xFF95F8` + index `0xFFB0D4`, count `0xFFB0D2` | via DMA | via DMA |
| RX buffer | `0xFF27C8` (512 B) or `0xFF95F8` (256 B) | `0xFF1AC8`–`0xFF23C7` (2304 B) | `0xFF23C8` ring | `0xFF306A`–`0xFF3C6A` (3073 B) |
| Far end | **DATA jack / external PC** | on-board module, unidentified | **DSP / vocoder** | **SUB RX64M** (inferred) |

φ = 16 MHz is derived, not assumed: BRR values 103/51/25/12 in a 1:2:4:8 ladder
give `B = φ / (32·(N+1))`, and only φ ≈ 16 MHz maps them onto
4800/9600/19200/38400 (0.16 % error). BRR `0x00` on SCI-D then gives exactly
φ/32 = 500 000 baud.

The vector group at **156–159 is entirely the reset stub** — a fifth SCI channel
exists in the part and ver 1.02 does not use it (confirmed from `vectors.tsv`:
only 30 of the 256 vectors have a handler other than `0x2092`).

Three **DMAC** channels feed three of the SCIs. Register set confirmed from
operand use: MAR at `+0x00`, DAR at `+0x04`, count at `+0x0C`, control at `+0x14`
(`0x800001A0` = enable), `+0x18` = `0x200000`, per-channel activation-source byte
at `0xFFFD20`/`21`/`22`.

| Channel | Base | Destination | Activation | Used for | DMA-end vector (inferred) |
| --- | --- | --- | --- | --- | --- |
| 0 | `0xFFFC00` | `0xFFF613` (SCI-D TDR) | `0xFFFD20 = 0xE1` | MAIN→SUB block send | 128 → `0x048328` |
| 1 | `0xFFFC20` | `0xFFFF8B` (SCI-C TDR) | `0xFFFD21 = 0x96` | MAIN→DSP 32/96-byte frame | 129 → `0x0483D2` |
| 2 | `0xFFFC40` | `0xFFFE93` (SCI-A TDR) | `0xFFFD22 = 0xA2` | RAM block dump to the external port | 130 → `0x06B986` |

The vector-130 attribution is inferred, not confirmed: vectors 128/129/130 hold
handlers that each clear exactly one SCI's `SCR.TIE` — `0x048328` clears SCI-D's
(`0xFFF612`), `0x0483D2` clears SCI-C's (`0xFFFF8A`), `0x06B986` clears SCI-A's
(`0xFFFE92`) — which is the DMA-transfer-end housekeeping for the three channels
above, and it is the only reading that does not put two TXI handlers on one
channel. Confirming it needs the part's vector assignment, which MAIN-FULL owns.

#### What is on each end, and how I know

**SCI-A `0xFFFE90` = the DATA jack / external PC port.** Four independent
strands of evidence:

1. Its baud rate is the only one that is *user-selectable*, from a 4-entry table
   indexed by `0xFF8C27`, and `0xFF8C27` is written by the configuration loader
   `sub_DEFA` at `0x00E57A` — i.e. it is a setup-menu item. SUB's setup-label
   table contains `COM PORT SETTING`.
2. NMEA output templates sit in MAIN and are transmitted on this channel:
   `$GPWPL,0000.00,N,00000.00,E,` at `0x0458D8`,
   `$GPRMC,000000.000,V,0000.0000,N,00000.0000,E,0000.00,000.00,000000,,*` at
   `0x0463E8`, `$GPGGA,000000.000,0000.0000,N,00000.0000,E,0,00,00.0,00000.0,M,0000.0,M,000.0,0000*`
   at `0x04642E`. These are zero-filled *emission* templates — the GPS-OUT
   feature on the DATA jack.
3. The DSP debug trace is printed here: `sub_453A0`/`sub_45312` (which touch
   `0xFFFE94`) are called at `0x05643C` immediately after the trace formatters
   `sub_5A47E`/`sub_5A506`, gated on `0xFF8C26` bit 7 and `0xFF8C28` ∈ {3,4,5}.
4. The TXI handler terminates the message on byte `0x0A` (LF) and drops
   `0xFFB04E` bit 0 — a line-oriented text/ASCII protocol.

**SCI-C `0xFFFF88` = the DSP.** See the hand-off section above.

**SCI-D `0xFFF610` = the SUB RX64M (inferred, high confidence).** 500 kbaud
async, a 3,073-byte receive ring, DMA on transmit, and it is initialised twice:
once in the boot routine `sub_20FA` at `0x002348`, and again from `sub_3EC50`,
which is the same routine that rewrites the USB interrupt-enable registers
`0xFFEE04`/`05`/`06` and `0xFFEE2D` — i.e. a power-state transition that tears
down and rebuilds both the USB module and this link together. Nothing else in the
radio needs half a megabit. The RX ring's consumer is not in my 20.9 % coverage,
so I have not read the framing. **BOOT-IPC owns the pairing; this is the MAIN end
only.** My channel facts (registers, baud, ring, DMA) are confirmed; the "SUB"
attribution is inferred and should be cross-checked against the SUB image's own
SCI configuration.

**SCI-B `0xFFFF60` = unidentified on-board module.** Fixed 38400 8N1, a
2,304-byte receive ring at `0xFF1AC8`, a counted-length transmitter, parser at
`sub_48C44` (`0x048C44`), control at `sub_48B86`/`sub_48B9A`. The notable thing
is a **pass-through**: SCI-A's alternate receive buffer is `0xFF95F8`, which is
exactly SCI-B's transmit source buffer. Setting bit 7 of `0xFF817F` (done in
`sub_734F4` at `0x0734F4`; cleared in the normal SCI-A init at `0x0451B2` and
`0x04520C`) routes everything arriving from the external port straight into
SCI-B's transmit queue. That is a deliberate **PC → on-board-module transparent
bridge**, the shape you build to let a host configure or update a downstream
module. Candidates, none confirmed: the GPS receiver, the Bluetooth module, or a
second control MCU. I searched the full image and found **no** `$GP` *parser*,
no `$PMTK`, no `UBX` sync bytes, no `AT+`, no `RFCOMM`/`SPP` — so I cannot name
it from strings. Marked **unknown**.

### 2. Protocol reconstruction — the external-port command frame

`sub_6B77E` at `0x06B77E`–`0x06B990` is the command interpreter for SCI-A. It
drains up to 8 bytes per invocation from the SCI-A receive ring (`0xFF27C8`, read
pointer `0xFFB036`, fill count `0xFFB03C`) and assembles a frame at `0xFF1AC8`.
Reconstructed frame (confirmed from the instruction sequence):

```
offset  0 .. 8   9-byte header
        9 ..     payload, length computed at byte 9 by sub_6CB5E -> 0xFFB3CA
        n-3      0x04   (EOT; mismatch -> NAK)
        n-2      checksum byte (subtracted back out of the running sum)
        n-1      passed with n-2 to sub_6CB40, whose result is compared to the sum
```

* **Length**: the frame length is not a plain field — at exactly 9 accumulated
  bytes, `sub_6CB5E` (`0x06CB5E`) is called and its result is stored in
  `0xFFB3CA`; the interpreter then waits for `0xFFB3CA + 9` bytes total
  (`0x06B862`: `mov.w @0xFFB3CA, r4; add.w #9, r4; cmp.w r4, e4`). So the header
  encodes the payload length and `sub_6CB5E` decodes it.
* **Checksum**: an **8-bit additive sum** accumulated in `0xFFB3DC` over every
  received byte (`0x06B874`: `mov.b @0xFFB3DC, r4l; add.b r1l, r4l;
  mov.b r4l, @0xFFB3DC`), with the checksum byte itself subtracted back out
  before the compare, then finalised by `sub_6CB40`.
* **Terminator**: byte `n-3` must be `0x04` (ASCII EOT).
* **ACK/NAK**: on success `0xFFB3D5` bit 1 is cleared, `0xFF959E` is set to
  `0x64` (100), `0xFFB3D2` bit 1 is cleared; on failure `0xFFB3D2` bit 1 is set.
  `0xFFB3D2` bit 0 is set either way and the byte counter `0xFFB3C4` is reset.
* **Timeout / flow**: `0xFF959E` is a byte-budget counter compared against
  `0x3B` (59) and `0x32` (50) at `0x06B7C4` and `0x06B7EA`; exceeding it diverts
  to `sub_22718` or `sub_6B700`.
* **Response path**: `0x06B91A`–`0x06B984` sets up **DMA channel 2** with source
  `0xFEE000` — the base of RAM — a length from `0xFFB3CC`, destination
  `0xFFFE93` (SCI-A TDR), and starts it. So the protocol can **read a block of
  the radio's RAM out of the serial port**. That is the clone/read direction.
* **Reset command**: `0x06B7DC` does `jsr sub_2648; orc #0x80, ccr;
  jmp 0x2050` — mask interrupts and jump back into the startup path. A command
  on this port can restart MAIN.

#### The frame is ASCII, and here is the whole command set

`sub_6CB40` (`0x06CB40`) is a **two-ASCII-hex-digit → byte** converter
(`cmp.b #0x41` then `and.b #0x0F` for `'0'`–`'9'` or `add.b #0xC9` = −0x37 for
`'A'`–`'F'`, then `shll.b #2` twice = `<<4`, then `or`). `sub_6CB5E`
(`0x06CB5E`) applies it to frame bytes `[2][3]` and `[4][5]` and returns a 16-bit
value — **the length field is four ASCII hex digits, big-endian nibble order**.
So the frame is:

```
[0]           0x01                SOH
[1]           command letter      ASCII
[2..5]        4 ASCII hex digits  N = payload length
[6 .. 6+N-1]  payload             N bytes, ASCII
[6+N]         0x04                EOT
[7+N][8+N]    2 ASCII hex digits  additive-sum checksum
total         N + 9
```

That closes the arithmetic exactly: the receiver computes `N` at 9 accumulated
bytes and waits for `N + 9`, then requires byte `[total-3] == 0x04` and takes the
last two bytes as the checksum digits. Verified against a literal frame in the
image: `0x06C598` = `01 'B' '0' '0' '0' '1' '0' 04 …` — `N` = 1, total = 10 = 1+9.

**Dispatcher: `sub_6BAC8` at `0x06BAC8`**, switching on frame byte `[1]` read from
`0xFF1AC9` (confirmed, a linear `cmp.b`/`beq` chain):

| Letter | Byte | Handler | Notes |
| --- | --- | --- | --- |
| `V` | `0x56` | session identify; in the data phase, `0x06BB08` → `jsr sub_2648; orc #0x80, ccr; jmp 0x2050` | **the reset command**, taken when `0xFF8DDE` bit 7 is clear |
| `M` | `0x4D` | `sub_6C680` / `sub_6C652` then `sub_6BE34` | model / destination exchange; `sub_6BE34` is the routine holding the `USA JPN EXP` table at `0x06BE24` and the `eepmov` of 0x4C / 0x4A bytes from the frame buffer `0xFF1AC8` into `0xFEE000` |
| `B` | `0x42` | `0x06BE9C` | |
| `C` | `0x43` | `0x06BEF6` | |
| `E` | `0x45` | `sub_6C850`, reply `sub_6BF6C` | |
| `F` | `0x46` | `sub_6C686`, reply `sub_6BF44` | |
| `S` | `0x53` | `sub_6C8E8`, reply `sub_6BF8C` | |
| `N` | `0x4E` | `0x06BFB4` | |
| `W` | `0x57` | `0x06BD0A` | |
| anything else | | returns 0 → NAK | |

The session is gated: `sub_6B9AC` at `0x06B9AC` requires the **first** frame's
letter to be `V`, then calls `sub_6BD3E`, and only then accepts `V` again or `M`;
`sub_6BA46` at `0x06BA46` is the pump for the data phase, dispatching to
`sub_6C05C` / `sub_6C19A` / `sub_6C344` on `0xFFB3D7` bits 2/5/7 and transmitting
through `sub_6B73A`.

**Transmit-side frame templates**, literal in flash — these are the radio→PC
directions and the identity strings (confirmed bytes):

| Offset | Frame | Meaning |
| --- | --- | --- |
| `0x06C536` | `01 "V0030FT3D` … `201804180       0C01" 04` | identify, N = `0x0030` = 48. **`V0030FT3D` is the clone-file format tag**; `20180418` is the build date, `0C01` the version |
| `0x06C570` | `01 "V0020FT2D    JPN     Ver0202 20180418" 04` | the FT2D identify string, N = `0x0020` = 32 — MAIN carries both |
| `0x06C598` | `01 "B0001" "0" 04` | `B`, N = 1 |
| `0x06C5A0` | `01 "C000B" "00000000000" 04` | `C`, N = 11 |
| `0x06C5B2` | `01 "E0001" "0" 04` | `E`, N = 1 |
| `0x06C5BA` | `01 "F0001" "0" 04` | `F`, N = 1 |
| `0x06C5C2` | `01 "S0001" "0" 04` | `S`, N = 1 |
| `0x06C5CA` | `01 "H001E"` | `H`, N = `0x1E` = 30 — header template, payload filled at run time |
| `0x06C5D0` / `0x06C5D8` / `0x06C5E0` | `01 "R0061" "0"` / `01 "R0089" "2"` / `01 "R00BB" "3"` | **`R` = block read/response, three block sizes 97 / 137 / 187 bytes**, with the byte after the length acting as a block selector `0`/`2`/`3` |
| `0x06C5E8` | `01 "P000B" "00000000000" 04` | `P`, N = 11 |
| `0x06C5FA` | `01 "N0001" "0" 04` | `N`, N = 1 |
| `0x06C602` | `01 "W0048" "2000000.00000+000.000000106702300030000.00000+000.00000010670230003500…"` | **`W`, N = `0x48` = 72 — position/waypoint write**: latitude `000.00000`, longitude `+000.00000`, then date/time; this is the APRS/GPS record |

So the command letters are `V M B C E F S N W` inbound and
`V H R P B C E F S N W` outbound. `R` with its three block sizes is the read
primitive a cloning tool would use; `V` is the handshake and the format tag.

Related identity data, all in MAIN (confirmed): a model-name table at
`0x04C388` (`FT1D`, `FTM-400D`, `FT2D`, `FTM-100D`, `FT3D`, `TH-D74`, `H-D72`,
`-------`) with a parallel index table `00 01 02 03 04 FF 05 06 07 08 09 FF` at
`0x04C3C6`; the destination table `USA JPN EXP ` at `0x06BE24` (4-byte stride);
and the model code `APY03D` at `0x04B182` and `0x04B18A`.

`0xFEE000` is the **clone staging buffer**, not a settings image as such: it is
both the `eepmov` destination at `0x06BE30`/`0x06BE50` (76 and 74 bytes from the
frame buffer `0xFF1AC8`) and the DMA channel 2 source for the outbound dump at
`0x06B948`.

The other protocol worth naming: the USB vendor requests. The control-transfer
matcher (`0x05507C`, `0x05527C`, `0x055598`, `0x0553A8` — the same 5-way compare
repeated in four state-machine arms) recognises exactly five 16-bit
`bmRequestType<<8 | bRequest` values:

| Value | Meaning | Handling |
| --- | --- | --- |
| `0x8006` | standard GET_DESCRIPTOR | device → `0x055818` (18 B) or `0x055810` (8 B); config → `0x05582A` (9 B) or one of six 32-byte blocks via the pointer table at `0x05584A`, selected by `0xFF89CF`; string → not served |
| `0x41D1` | vendor OUT, interface, bRequest `0xD1` | matched, arm not in my dumps |
| `0x41D2` | vendor OUT, interface, bRequest `0xD2` | `0x0555F4`: calls `sub_559F4`, clears `0xFF2EC9`, arms EP1 bulk reception into the buffer at `0xFFBA6E` with count `0xFFBA6C` and packet counter `0xFFBA73` |
| `0x41D3` | vendor OUT, interface, bRequest `0xD3` | matched, arm not in my dumps |
| `0xC1D4` | vendor IN, interface, bRequest `0xD4` | `0x0552D8`: returns **1 byte**, `0x18`/`0x30`/`0x50` selected by `0xFF89CD` (0/1/other) |

There is also an 8-entry × 8-byte table of literal SETUP packets at `0x0558FE`,
compared two longwords at a time (`0x0550B2`); the first entry is
`80 06 00 01 00 00 08 00` = GET_DESCRIPTOR(DEVICE, 8 bytes).

### 2b. MAIN's non-volatile store — a bit-banged 3-wire serial EEPROM

MAIN does hold a serial EEPROM, and it is **not** on any SCI channel — it is
bit-banged on port pins. Confirmed from the two halves of the driver:

| Signal | Pin | Direction |
| --- | --- | --- |
| `/CS` | `0xFFFF5C` bit 7 | output, driven low for the transaction (`bclr` at entry, `bset` at exit) |
| `SCLK` | `0xFFFF5A` bit 1 | output |
| `DI` (to EEPROM) | `0xFFFF5A` bit 0 | output, written with `BST #0` from the C flag |
| `DO` (from EEPROM) | `0xFFFF4A` bit 0 | input, read with `BLD #0` into the C flag |
| direction switch | DDR `0xFFFB8A` via the RAM shadow `0xFF816D` bit 0 | cleared to read, set to write |

* **`sub_33532` (`0x033532`) = READ.** `/CS` low, clock low, 9 command bits
  shifted MSB-first out of `ER5` (loaded from `0xFFBC66`, pre-shifted left 8),
  each bit `BST #0, @0xFFFF5A` followed by clock high/low; then the data pin is
  turned around (`bclr #0, @0xFF816D`; `mov.b @0xFF816D, r4l;
  mov.b r4l, @0xFFFB8A`); then **16 clocks** with `BLD #0, @0xFFFF4A` +
  `ROTXL.W R3` shifting the bits in; result stored to `0xFFBC68`; `/CS` released.
* **`sub_334CA` (`0x0334CA`) = WRITE.** Same start, then **`0x19` = 25 clocks**
  shifting `ER5` = `{E5 = 0xFFBC66 command, R5 = 0xFFBC68 data}` = 9 command bits
  + 16 data bits; then `/CS` high, `DI` low, one extra clock pulse (the
  ready/latch cycle), clock left high.
* **Command word format**, built by `sub_77D6A` (`0x077D6A`):
  `cmd9 = ((a & 0xE0) << 1) | (op ? 0x20 : 0) | (a & 0x1F)` — i.e. bits [8:6] are
  a 3-bit opcode taken from the caller's byte `a[7:5]`, bit 5 is address bit 5
  supplied separately, bits [4:0] are `a[4:0]`. **9-bit command + 16-bit word is
  the 93C46-class Microwire organisation (64 × 16).**
* **Block-read API** at `sub_77D90` (`0x077D90`) and `0x077DB8`: builds the
  command word, calls `sub_334CA`/`sub_33532`, and the second one loops storing
  the returned 16-bit words high-byte-then-low-byte into a caller buffer — a
  contiguous multi-word read. Note this lives in the **same code region as the
  alternate CDC-ACM USB stack** (`0x076000`–`0x0783xx`), which is suggestive: a
  USB virtual COM port and an EEPROM block-read API side by side is the shape of
  a factory/service interface.

A second 3-wire device shares the same port: `0xFFFF5A` bits 4, 5 and 6 are
bit-banged by `sub_3490`, `sub_34E0`, `sub_37A56`, `sub_3827E` with `0xFFFBA5`
bit 4 gating (`sub_3347E` at `0x03347E`). That is a separate clock/data pair —
most plausibly the PLL synthesiser, unverified.

**What I could not confirm, and the honest scope:** I did not locate the routine
that ships a ~254-byte settings block to SUB. SCI-D's transmit is DMA from a
caller-supplied source register (`sub_482D4` takes the address in `ER5` and the
count in `ER3`), so the source is not a constant I can enumerate, and SCI-D's
receive-ring consumer (read pointer `0xFF8142`) is outside my 20.9 % coverage.
The 93C46-class part found here is only 128 bytes at 64 × 16, which is too small
for a 254-byte settings image on its own — so either there is a second, larger
store I have not found (a wider EEPROM on the bits-4/5 pair, or an on-chip data
area), or the settings live in MAIN's battery-backed RAM and the EEPROM holds
only calibration. Marked **unknown**; see Open item 1.

### 3. The program switch

**The MAIN application firmware never reads a three-position switch, and there is
no update-mode branch in it.** Scope of that negative: I enumerated every operand
of every instruction in all 4,491 recovered functions that names any address in
`0xFF0000`–`0xFFFFFF` (17,594 references, `io_operands.tsv`), then examined every
access to the port *input* registers `0xFFFF40`–`0xFFFF4F` individually — there
are only 26 of them, all listed in `port_usage.tsv`. None decodes three states,
and none leads to a flash operation.

What the boot path *does* read is a single input line, and it selects a USB
personality, not an update mode. `sub_20FA` at `0x0021F8`–`0x002238` (confirmed):

```
0021F8  mov.b  #0, r4l
0021FA  mov.b  r4l, @0xFF813A       ; USB stack selector = 0
0021FE  mov.b  #0xC8, r6l           ; 200 polls
002200  mov.b  @0xFFFF4C:8, r4l     ; read port input register
002202  and.b  #0x7F, r4l           ; mask bit 7 away
002204  cmp.b  #0x7D, r4l           ; bit 1 low, all others high?
002206  beq    loc_221E
002208  dec.b  r6l
00220A  bne    loc_2200
00220C  mov.b  r4l, @0xFF813B
002210  cmp.b  #0, r1l
002214  jsr    sub_54BF8            ; normal USB stack init A
002218  jsr    sub_54C44            ; normal USB stack init B
00221C  bra    loc_2240
loc_221E:
00221E  mov.b  r4l, @0xFF813B
002222  mov.b  #1, r4l
002224  mov.b  r4l, @0xFF813A       ; USB stack selector = 1
002228  jsr    sub_55FFE
002234  jsr    0x078106             ; ALTERNATE (CDC) USB stack init
```

`0xFFFF4C` is decoded elsewhere, in `sub_100E4` at `0x0100E4`, as a **one-hot
active-low 7-line input**:

| `PORT & 0x7F` | Bit low | Code assigned |
| --- | --- | --- |
| `0x7F` | none | idle / nothing pressed |
| `0x7E` | 0 | `0x0E` |
| `0x7D` | 1 | `0x11` |
| `0x7B` | 2 | `0x0A` |
| `0x77` | 3 | `0x0F` |
| `0x6F` | 4 | `0x0D` |
| `0x5F` | 5 | `0x0C` |
| `0x3F` | 6 | `0x12` |
| anything else | multiple | `0x09` |

So the boot check is "**is the line that maps to key code `0x11` held down at
power-on?**" — a held-key condition, not a slide switch. Holding it selects the
CDC-ACM personality. `0xFF813A` is written only at those two sites in `sub_20FA`
and read at `0x00EE82` (`sub_ED16`), `0x0101B2` (`sub_1019E`), `0x054D54`
(the USB ISR) and `0x056160` (the SCI-C ISR) — so it is a boot-time latch, never
changed afterwards.

**Answer to the assignment's critical question:** the application does not read
the program switch and cannot enter the update path. Renesas boot mode on both
the H8S and the RX64M is entered by the state of the mode pins at the rising edge
of reset, sampled by hardware before the first instruction executes; no firmware
is running to observe it. The three-position switch behind the DATA jack must be
wired to those mode/boot pins (and to whichever of the two chips it selects).
**Entering the update path is therefore a hardware decision, not a firmware
decision** — which also means no firmware bug or command can put the radio into
the programming mode, and no software mistake can take it out of normal
operation. Confidence: the firmware half is **confirmed** (searched scope stated
above); the "switch is on the mode pins" half is **inferred** from that absence
plus how Renesas boot mode works, and is not visible in this package.

### 4. Boot and update entry, and flash self-write

**Not found: any self-programming path in MAIN's application firmware.** Scope
and the specific tests:

* No flash-control register block. The candidate H8S F-ZTAT addresses
  `0xFFFFC8`–`0xFFFFCF` show only a single access in the whole recovered corpus
  (`0xFFFFC8`, once, in `sub_2F55A`), and the `0xFFFFC0`/`D0`/`E0`/`F0` blocks
  are unmistakably **TPU timer channels** — the `+0,+1,+2,+4,+5,+6,+8` access
  footprint of TCR/TMDR/TIOR/TIER/TSR/TCNT/TGRA on a 16-byte stride, with
  `0xFFFFC0`/`C1` as TSTR/TSYR.
* No `FKEY`/`FMATS` key writes. I scanned the raw image for every
  `mov.b #0x5A/#0xA5/#0xAA, Rd` followed within 8 bytes by an absolute store into
  the top page. Two candidates surfaced and both are false positives, verified
  against the disassembly: `0x00268A` is the byte pair inside
  `mov.b @0xFFFBA5:16, r4l` (a port pull-up register), and `0x00A282` is inside
  `mov.w #0xF3A5, r4`.
* No erase-block table, no RAM-resident-code copy-and-call pattern other than the
  ordinary `.data` initialiser at `0x002152`, no `FLASH`/`ERASE`/`BOOT`/`WRITE`
  strings (searched the full 1 MB).
* The only thing resembling a loader entry is the software-reset in the command
  interpreter (`0x06B7DC`: `jsr sub_2648; orc #0x80, ccr; jmp 0x2050`), which
  re-enters MAIN's own startup — it does not jump to a bootloader.

Conclusion: **MAIN's application cannot write its own flash.** The only write
path is the Renesas boot ROM, which is not present in this image (the image
begins at address 0 with the vector table and the boot ROM lives in a separate,
mask-ROM MAT that is mapped in only in boot mode). Confidence: **not found**
across the stated scope, which I regard as decisive for this question because a
self-programming routine has a large, distinctive register footprint and the
operand enumeration was exhaustive inside the recovered functions.

Boot structure for the record: reset vector `0x2092` (`mov.l #0xFF7F00, sp`),
226 of the 256 vectors point at `0x2092` as the unused-source stub, NMI at
index 7 → `0x267C`. `.bss` clear covers `0xFEE000`–`0xFF72FF` (`0x002132`);
`.data` is copied from `0x07B2A6` for `0x4AE` bytes to `0xFF6034` (`0x002152`) —
which is how the alternate USB stack's descriptor tables reach RAM (see below).

### 5. USB on MAIN — the headline

MAIN has a USB device controller and uses it. Evidence, strongest first:

1. **Three dedicated interrupt vectors.** Vector 234 → `0x054D50`, 235 →
   `0x054EC2`, 238 → `0x054CFA`. Each handler services a different interrupt
   flag register: `0xFFEE00`, `0xFFEE01`, `0xFFEE02`. An externally bus-attached
   USB chip would share one IRQ vector; three distinct vector slots means three
   on-chip interrupt sources.
2. **A Renesas USB Function Module register map**, derived behaviourally:

| Address | Role | Evidence |
| --- | --- | --- |
| `0xFFEE00` | IFR0 | `sub_54D50` tests bits 7,3,2,1,0 and write-1-clears each |
| `0xFFEE01` | IFR1 | `sub_54EC2` tests bits 0,2,1 |
| `0xFFEE02` | IFR2 | `sub_54CFA`, `0x054FA6` test bits 4,3 |
| `0xFFEE04/05/06` | IER0/1/2 | `sub_54C44` writes `0x8D`, `0x03`, `0x18` |
| `0xFFEE08/09/0A` | ISR0/1/2 (clear) | `sub_54C44` writes `0x00`, `0x07`, `0x1F` |
| `0xFFEE0C` | EPDR0I (EP0 IN data) | `0x054E86`, `0x055180` write control-in bytes |
| `0xFFEE0D` | EPDR0O (EP0 OUT data) | `0x054DFE` reads `EPSZ0O` bytes |
| `0xFFEE0E` | EPDR0S (SETUP data) | `0x054DB4` reads **exactly 8 bytes** in a loop |
| `0xFFEE10` | EPDR1 (EP1 OUT bulk) | `sub_55520` reads `EPSZ1` bytes |
| `0xFFEE18` | EPDR3 (EP3 IN interrupt) | `0x054F52`–`0x054F76` writes 3 bytes then TRG `0x40` |
| `0xFFEE24` | EPSZ0O | `0x054DF2` |
| `0xFFEE25` | EPSZ1 | `0x055652` |
| `0xFFEE27` | EP3 status | `0x055202` tests bit 5 before refilling EP3 |
| `0xFFEE28` | FCLR | `0x054D88` writes `0x73` on bus reset |
| `0xFFEE2C` | TRG | `1` = EP0i PKTE, `2` = EP0o RDFN, `4` = EP0s RDFN, `0x40` = EP3 PKTE |
| `0xFFEE2D` | module enable | `bset #2` in both stacks' init |
| `0xFFEE2F` | reset/pull-up pulse | `0x054D22`: write `8`, 15 NOPs, write `0` |
| `0xFFEE53` | pin function / DDR | `bset #1` in the SCI-D init `sub_446BE` |

3. **Two complete, internally consistent descriptor sets.**

   *Stack 1, default (`0xFF813A == 0`), descriptors at `0x055810`–`0x0558FD`:*

   ```
   055818  12 01 00 02 00 00 00 08 AA 26 01 00 00 00 00 00 00 01
           device: bcdUSB 0x0200, class 0, bMaxPacketSize0 8,
           idVendor 0x26AA, idProduct 0x0001, 1 configuration
   05582A  09 02 20 00 01 01 00 C0 32
           config: wTotalLength 32, 1 interface, self-powered, 100 mA
   055833  09 04 00 00 02 FF 01 FF 00
           interface 0: class 0xFF, subclass 0x01, protocol 0xFF, 2 endpoints
   05583C  07 05 01 02 40 00 00      EP1 OUT, bulk, 64
   055843  07 05 83 03 08 00 64      EP3 IN, interrupt, 8, bInterval 100 ms
   ```
   An 8-byte short device-descriptor reply sits at `0x055810`
   (`08 01 00 02 00 00 00 08`), served when `0xFF8183 == 1`. Five alternate
   copies of the configuration block follow at `0x05585E`, `0x05587E`,
   `0x05589E`, `0x0558BE`, `0x0558DE`, identical except `bInterval` = 20, 100,
   150, 200, 250 ms, reached through the pointer table at `0x05584A` (confirmed:
   `0x05510E` does `mov.w @word_5584A:32, r5` with a length of `0x20`) and
   indexed by `0xFF89CF`.

   *Stack 2, alternate (`0xFF813A == 1`), descriptors at `0x07B680`–`0x07B753`:*

   ```
   07B680  12 01 10 01 02 00 00 08 AA 26 20 00 00 01 00 00 03 01
           device: bcdUSB 0x0110, class 0x02 (CDC), bMaxPacketSize0 8,
           idVendor 0x26AA, idProduct 0x0020, iSerialNumber 3
   07B711  09 02 43 00 02 01 00 C0 10     config, wTotalLength 67, 2 ifaces, 32 mA
   07B71A  09 04 00 00 01 02 02 01 00     iface 0: CDC comm / ACM / AT-command
   07B723  05 24 00 10 01                 CDC header, bcdCDC 0x0110
   07B728  04 24 02 06                    ACM, bmCapabilities 0x06
   07B72C  05 24 06 00 01                 Union: master 0, slave 1
   07B731  05 24 01 03 01                 Call management, data interface 1
   07B736  07 05 83 03 08 00 10           EP3 IN, interrupt, 8, 16 ms
   07B73D  09 04 01 00 02 0A 00 00 00     iface 1: CDC data, 2 endpoints
   07B746  07 05 01 02 40 00 00           EP1 OUT, bulk, 64
   07B74D  07 05 82 02 40 00 00           EP2 IN, bulk, 64
   ```
   9+9+5+4+5+5+7+9+7+7 = 67 = `0x43`, so `wTotalLength` checks out exactly. This
   is a **valid USB CDC-ACM virtual COM port**. String descriptors at
   `0x07B272` (`04 03 09 04`, LANGID 0x0409), `0x07B276` (`10 03` "Renesas"),
   `0x07B286` (`1A 03` "000000000000"), reached by the pointer table at
   `0x07B5FC`. An IEEE-1284 printer-class device-ID string
   (`MANUFACTURER:ACME Manufacturing;COMMAND SET:PCL,MPL;MODEL:LaserBeam ?;…`) at
   `0x07B69C` is unmodified Renesas sample-code boilerplate left in the image.

4. **Stack 2 is live, not dead data.** The `.data` initialiser at `0x002152`
   copies `0x4AE` bytes from `0x07B2A6` to `0xFF6034`, i.e. `0x07B2A6`–`0x07B753`
   → `0xFF6034`–`0xFF64E1`. The tables at `0x07B4B2`–`0x07B753` therefore land in
   RAM, and they contain pointers to their own RAM images: `0x07B5F0` holds
   `00 FF 64 0E` and `00 FF 64 9F`, which are exactly where `0x07B680` (device
   descriptor) and `0x07B711` (configuration descriptor) end up. `0x07B580`
   onward is a per-endpoint table pairing a size variable with a data register:
   `(0xFF6420, 0xFFEE0E, 8)`, `(0xFF6420, 0xFFEE0C, 8)`, `(0xFFEE24, 0xFFEE0D, 8)`,
   `(0xFF6420, 0xFFEE18, 0x40)`, `(0xFF6423, 0xFFEE14, 0x40)`,
   `(0xFFEE25, 0xFFEE10, 0x40)`. Stack-2 code is at `0x076700`–`0x0783xx`: init
   `0x078106` (reads IER0/1/2, builds a word at `0xFF62F8`, initialises
   `0xFEE010`–`0xFEE20C`, `bset #2, @0xFFEE2D`), service loop `0x07815C`,
   ISR trampoline `0x07827C` entered from `sub_54D50` at `0x054EB0` when
   `0xFF813A != 0`, endpoint helper `sub_768A8`, and SCI-C helpers
   `sub_78222`/`sub_7823C`/`sub_78256`.

5. **Answer to the adjacent question I own.** The micro-USB jack is not merely
   sensed by a GPIO — it is wired to a real on-chip USB device controller, D+/D−
   and all. Cable presence is detected *inside* the module: `sub_54CFA` and
   `0x054FA6` test IFR2 bits 4 and 5 and latch the result into `0xFF8180` bits 5
   and 7, which is the VBUS-monitor path of a Renesas USB Function Module. The
   `0xFFEE2F` write-8-delay-write-0 at `0x054D22` is the D+ pull-up / UDC reset
   pulse. Additionally the NMI handler (`0x00267C`) touches `0xFFEE04`/`05`/`06`
   and `0xFFEE2D` — so the power-fail/undervoltage NMI shuts the USB module down,
   which is consistent with a bus-powered or charge-aware design. I found **no
   separate GPIO cable-insert line** for USB in `port_usage.tsv`.

### 6. Keypad, display, audio and the rest

Full bit-level table in `ida\out\main-io\port_usage.tsv`. Summary of the port
plane: inputs are read at `0xFFFF40`–`0xFFFF4F` (26 distinct accesses), outputs
driven at `0xFFFF50`–`0xFFFF5F`, directions set at `0xFFFB80`–`0xFFFB95`, and
pull-up MOS / open-drain control at `0xFFFBA0`–`0xFFFBCF`. `sub_20FA` and
`nmi_handler` between them write the entire DDR set — the NMI handler re-drives
the pin directions, which is how a power-fail handler parks the hardware.

| Function | Pins / registers | Evidence |
| --- | --- | --- |
| Key / accessory matrix | input `0xFFFF4C` (7 lines, one-hot active low), decoded in `sub_100E4`; additional key inputs `0xFFFF4D` bits 2/3/4, `0xFFFF4E` bits 2/5, `0xFFFF41` bit 3, `0xFFFF42` bit 6, `0xFFFF45` bit 3, `0xFFFF49` bit 7, `0xFFFF4A` bit 0 | `port_usage.tsv`; `sub_100E4`, `sub_30590`, `sub_307E0`, `sub_31F9E`, `sub_32202`, `sub_3E864` |
| Display / LCD control | output `0xFFFF5A` bits 0,1,4,5,6 (`bset`/`bclr` in `sub_3490`, `sub_34E0`, `sub_334CA`, `sub_33532`, `sub_37A56`, `sub_3827E`), `0xFFFF5C` bit 7, `0xFFFF5B` bits 2,3, `0xFFFF5D` bits 0–5 | the largest cluster of bit-banged outputs in the image, driven from a family of routines around `0x033000`–`0x038000` |
| DSP strobe / chip select | output `0xFFFF52` bit 1 | dropped in `sub_4834E` immediately before the DSP DMA starts |
| Audio mute / path control | output `0xFFFF52` bits 0,2,3,4,5,7 and `0xFFFF59` bits 2,3,4,5 | `sub_56056`, `sub_565EE`, `sub_5683E`, `sub_5DCFE`, `sub_2F400`, `sub_30F00`, `sub_3486C`, `sub_35E3C`, `sub_3EA28` — the `0x5D000`/`0x5E000` audio region and the `0x56000` DSP region share them |
| PTT / TX enable, squelch | input `0xFFFF49` bit 7 (`sub_2FC6E`, `sub_2FCC8`, `sub_5DCFE`), input `0xFFFF41` bit 3 (`sub_317DC`, `sub_31836`), input `0xFFFF42` bit 6 (`sub_3EA28`) | tested in the TX/RX state machines |
| Backlight / LED | output `0xFFFF50` bit 6 (`bclr` in `sub_105C4`, `sub_10600`; `btst` in `sub_FAF6`), whole-byte writes to `0xFFFF51`, `0xFFFF55`, `0xFFFF5E` | `port_usage.tsv` |
| Timers | TPU channels on a 16-byte stride: TSTR/TSYR `0xFFFFC0`/`C1`, channels at `0xFFFFD0`, `0xFFFFE0`, `0xFFFFF0` (TCR/TMDR/TIOR/TIER/TSR/TCNT/TGRA at `+0,+1,+2,+4,+5,+6,+8`); 8-bit timers at `0xFFFEC0`–`0xFFFECB`, `0xFFFEE0`–`0xFFFEE6`, `0xFFFEF0`–`0xFFFEF8` | `ioreg_wide_hist.tsv`; `0xFFFFF5`/`F6` carry the DSP 3-second timeout (`TIME OUT:3sec!`) |
| A/D, misc | `0xFFFF20` (73 accesses, 12 functions), `0xFFFF2D`/`2E`/`30`–`0x39`, `0xFFFF88`-adjacent `0xFFFFA0`/`A1`, `0xFFFFBC` | not chased; in MAIN-FULL's scope |

## USB relevance

**Question 1, everything USB.** MAIN is where USB lives in this radio, and the
earlier "no USB anywhere" reading was an artefact of looking only at SUB. Two
descriptor sets, two stacks, a full on-chip device controller, VBUS detection,
D+ pull-up control, and a boot-time selector between a vendor-specific bulk
device (`26AA:0001`) and a **CDC-ACM virtual COM port** (`26AA:0020`). The Renesas
`045B:0025` "Generic Boot USB Direct" device in the update manual is a *third*,
separate identity presented by the boot ROM with the program switch thrown; it
has nothing to do with either application stack. The micro-USB jack is therefore
reachable in normal operation, without the program switch, and in at least one
mode it is a plain serial port.

**Question 2, USB SDR.** My part of the chain, judged separately:

* *Transport and engine*: **present but slow.** The controller is full-speed
  (bcdUSB `0x0110`/`0x0200`, 64-byte bulk endpoints) and, crucially, the
  device-to-host direction is thin. Stack 1 has **no bulk IN endpoint at all** —
  only EP1 OUT bulk (host→radio) and an 8-byte interrupt IN; no instruction
  anywhere in the recovered corpus names `0xFFEE14` (EPDR2, the bulk IN data
  register), which appears only as a data word inside stack 2's endpoint table at
  `0x07B5D0`, so stack 2 drives EP2 through that table indirection and stack 1
  does not drive it at all. Stack 2 does declare EP2 IN bulk 64, so a CDC-ACM byte stream out of
  the radio is architecturally possible, but at full speed with a single 64-byte
  bulk IN the ceiling is roughly 1 MB/s theoretical and far less in practice —
  enough for 8-bit mono at 48 kHz, not enough for 16-bit IQ at any useful rate.
* *Path into the processor*: **present.** Three DMA channels exist and are wired
  to SCIs; retargeting one at a USB endpoint FIFO is a firmware change, not a
  hardware one.
* *Sample source*: **absent on this side.** MAIN has no IQ input. The only
  wideband digital input it has is SCI-C at up to 4 Mbit/s from the DSP, in
  32- and 96-byte frames, which is vocoder-rate, not sample-rate.
* *Firmware*: **absent**, and — decisively — **there is no route to install
  firmware that would do it, via USB or otherwise.** MAIN cannot write its own
  flash (section 4). The only write path is the boot ROM behind the program
  switch, which is a hardware gate.

So the link that fails is the sample source, and the link that makes it
unfixable-in-software is the absence of any self-programming path.

**Question 3, reaching the DSP.** This is the strongest positive result. The DSP
is on MAIN's SCI-C, MAIN owns the protocol, the opcode table is in this document,
`0x1F` is the version query that produces the DSP version on the radio's version
screen, and the whole conversation is *already* mirrored as human-readable text
out of the DATA-jack serial port when the trace flags `0xFF8C26` bit 7 and
`0xFF8C28` are set. Two concrete routes for the owner: enable the trace and watch
`CPU>DSP:`/`DSP>CPU:` traffic on the DATA jack at the menu-selected baud rate, or
drive the external command interpreter (`sub_6B77E`, frame in section 2) to reach
MAIN and have MAIN relay. There is no path that reaches the DSP bus directly —
it is a synchronous slave port with MAIN as the only other node.

## Open

Most valuable first.

1. **The external command protocol's opcode space.** I reconstructed the frame
   but not the dispatch. `sub_6CB5E` (`0x06CB5E`, the length decoder) and
   `sub_6CB40` (`0x06CB40`, the checksum finaliser) and their callers in
   `0x06C000`–`0x06D000` will contain the command table. That is the realistic
   route to talking to this radio and it is one focused pass away.
2. **The two unexamined USB vendor requests, `0x41D1` and `0x41D3`.** The
   matcher arms for them are in the parts of `0x055306`–`0x0555B6` and
   `0x0556C8`–`0x055810` I did not dump. Together with `0x41D2` (bulk OUT arm)
   and `0xC1D4` (returns `0x18`/`0x30`/`0x50`) they are the complete USB API of
   stack 1, and knowing what `0x26AA:0001` is *for* would settle whether USB is
   useful in normal operation.
3. **Which key is `0xFFFF4C` bit 1.** It maps to internal key code `0x11` in
   `sub_100E4`. Cross-referencing that code against the key-handling tables would
   tell the owner exactly which button to hold at power-on to get a USB serial
   port. High practical value, probably cheap.
4. **Identify SCI-B's far end** (`0xFFFF60`, 38400). Read `sub_48C44`
   (`0x048C44`–`0x048E90`) and `sub_48B86`/`sub_48B9A`. If it is the GPS module,
   the PC pass-through at `0xFF817F` bit 7 is a documented-in-firmware route into
   it.
5. **SCI-D's receive framing** (`0xFFF610`, 500 kbaud, ring `0xFF306A`). The
   consumer of read pointer `0xFF8142` is outside my coverage. Coordinate with
   BOOT-IPC: I have the MAIN end's registers, baud, DMA and ring; they should
   have SUB's matching channel.
6. **Raise coverage past 20.9 %.** My seeding is reproducible from
   `call_targets.txt` + `seed2.txt`; the next lever is resolving the compiler's
   switch jump tables (the `78 B0 / 6B 26 <table>:32 / 59 60` idiom, e.g. at
   `0x054FF6`, `0x0563A8`, `0x05641C`), each of which hides a fan-out of handlers.
7. **Confirm the H8S part number** from the recovered register map. MAIN-FULL's
   job, but note for them that the map is *not* H8S/2370: RAM starts at
   `0xFEE000`, there is an on-chip USB Function Module at `0xFFEE00`, a fifth
   unused SCI, three DMAC channels at `0xFFFC00`/`20`/`40`, and port DDRs at
   `0xFFFB80`.
