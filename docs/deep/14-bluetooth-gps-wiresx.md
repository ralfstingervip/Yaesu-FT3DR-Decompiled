# Bluetooth, GPS, WIRES-X and the DATA-jack accessory

**Status: COMPLETE.** Bluetooth and GPS are confirmed drivers. WIRES-X is resolved:
the wire format, the command set, the two DATA-jack personalities (clone/PC vs
WIRES-X node/PDN, selected by the sign bit of `0xFFFF8DDE`), the connect-result state
machine, and the DTMF autodialer's separateness from WIRES-X node control are all
confirmed with disassembly. The camera image transport is the only item that remains
Inferred rather than Confirmed, and its two candidate MAIN ports were eliminated this
pass (MAIN-IO pinned `0xFFFF88` = DSP and `0xF610` = SUB link), leaving one hypothesis.

Scope covered: the two ver 1.02 radio images only. No host PE files, no hardware, no
device access. Databases `WL_SUB` (RX64M, seeded from `ida\db\radio\SUB.i64`, grown to
1516 functions) and `WL_MAIN` (H8S, seeded from `ida\db\radio\MAIN.i64`, grown to 3154
functions). The on-air C4FM/DV framing that WIRES-X user mode rides is PROTOCOLS'
scope and is not part of this deliverable. Cross-checked against MAIN-IO
(`05-main-io-interfaces.md`) for MAIN's four SCI channels.

> Workspace note for any resumer: the tree was moved into the repository root
> after the earlier pass, so every job script that hardcodes `ROOT = r"."`
> (including `run_job.py`, `wl_dump.py`, `wl_calls.py`) now points at a path that no
> longer exists. This pass ran through corrected-path copies of the launcher and dump
> script; fix `ROOT`/`OUT` before reusing the originals.

## Verdict

**Bluetooth carries audio only.** It is a self-contained module with its own firmware
sitting on SUB's SCI3 at 115200 bps 8N1, driven by a Yaesu-proprietary line-oriented
ASCII protocol (`TOKN=value\r\n`, fourteen four-letter tokens) implemented entirely in
`0xFFF395DF`–`0xFFF3B700`. It is **not** a host-resident HCI stack and it is **not** an
AT-command set: the tokens are Yaesu's own. The only link-type commands in the whole
image are `SCOL` and `SCOI` — SCO is Bluetooth's synchronous *voice* channel — plus
`TXAT`, `RXAT` and `ERAT`, which are audio level/error controls. There is no RFCOMM,
SPP, L2CAP, A2DP or OBEX token anywhere in either image, no byte-stream relay onto that
channel, and the channel's rings are 256 bytes in / 64 bytes out, which cannot be a data
pipe. Voice never crosses this UART at all, so Bluetooth audio never enters the radio's
digital data plane. **There is no wireless route into or out of this radio.**

**GPS is a MediaTek MT333x-class module** on SUB's SCI2 at 9600 bps 8N1, driven by a
correct NMEA sentence builder (`$PMTKnnn,args*CS\r\n`, checksum = XOR of everything after
the `$`) and an ACK-gated state machine that waits for `$PMTK001` before advancing. Twenty
distinct `$PMTK` commands ship. The output set is configured by `$PMTK314` to
RMC + VTG + GGA + GSA + GSV once per fix, GLL and everything else off, with the module
held in continuous (non-periodic) power mode.

**The most capable non-USB data route is the DATA-jack serial port on MAIN's SCI at
`0xFFFE90`.** It runs 4800/9600/19200/38400 bps 8N1 (user-selectable, and 38400 fixed in
its framed mode), it carries a real framed protocol — `0x01` | command letter |
4-ASCII-hex length | data | `0x04` | 2-ASCII-hex checksum — and, decisively, MAIN sets up
a **DMAC channel that streams a bulk buffer at `0xFEE000` straight into that SCI's
transmit register**. That is the only bulk data path out of this radio that does not
involve the Renesas boot ROM. Its ceiling is 38400 bps, about 3.8 kB/s.

**WIRES-X is split across both processors and uses no wireless UART of its own.** The
user interface — search, category, room/node lists, and the connect-result display —
is SUB code around `0xFFF0A2E8`–`0xFFF1236E`; the node/PDN operating side and the RF
are MAIN's. The *only* serial control path WIRES-X owns is the DATA-jack framed
protocol on MAIN's SCI at `0xFFFE90`, which is a **PC/host link**, not a radio-to-radio
one: the same `0x01`|cmd|len|data|`0x04`|cksum frame serves two mutually exclusive
personalities selected by the sign bit of `0xFFFF8DDE` — clone/programming (bit 7
clear, includes a software-reset command) and **WIRES-X portable-digital-node / PDN**
(bit 7 set, node UI active, reset path disabled). In normal (non-PDN) WIRES-X use the
node/room control and the connected-node identity ride the **C4FM DV DATA channel over
the air** — that framing is PROTOCOLS' scope and crosses no interface in this
assignment. The **DTMF** feature (`DTMF MODE` / `DTMF MEMORY`) is a separate manual
autodialer on MAIN, not a WIRES-X control path: it maps a keyed digit through the
16-symbol table `0123456789ABCD*#-` at MAIN `0xC8D4` and drives the FM TX audio.

## Method

What I ran, in order, all through `run_job.py`:

1. Raw string dump of both plaintext images with file offsets (scratch Python, no IDA).
2. `ida\jobs\wl_dump.py` — reads a control file of `START END LABEL` ranges, force-creates
   instructions and functions across each, then writes an annotated listing per range to
   `ida\out\wireless\lst\`, plus an xref report for a list of addresses. Passes:
   - `WL_SUB` pass 1: `ranges_sub1.txt` (SCI driver `FFEDB300`–`FFEDC400`, GPS
     `FFEE0A00`–`FFEE1400`).
   - `WL_SUB` pass 2: `ranges_sub2.txt` (`FFED9800`–`FFEDB300` channel layer,
     `FFEDFC00`–`FFEE0A00` NMEA parser, `FFEE1400`–`FFEE2200`).
   - `WL_SUB` pass 3: `ranges_sub3.txt` (`FFEDC400`–`FFEDE400`, `FFF3B300`–`FFF3B900`,
     `FFEDAE00`–`FFEDB300`).
   - `WL_SUB` pass 4: `ranges_sub4.txt` (`FFF39400`–`FFF3B800`, the Bluetooth driver).
   - `WL_SUB` pass 5: `ranges_sub5.txt` (`FFF08100`–`FFF08500` camera settings,
     `FFF0A600`–`FFF0A900`).
   - `WL_MAIN` passes: `ranges_main2.txt`, `ranges_main3.txt`, `ranges_main4.txt`.
3. `ida\jobs\wl_calls.py` — broad force-disassembly then a caller report that also prints
   the twelve instructions before each call site, so register arguments are visible.
   - `WL_SUB`: forced `FFED8B70`–`FFF40000`, 104330 new instructions, 455 → 1516 functions.
   - `WL_MAIN`: forced `0x400`–`0x7C000`, 126725 new instructions, 1447 → 3154 functions.
4. Raw byte scanners in the scratchpad: `refscan.py` (find every 32-bit word in an image
   equal to a given mapped address, unaligned, correct endianness per image) and
   `winrefs.py` (same for an address window). These found the pointer tables that no
   disassembly pass had reached.
5. **Resume pass.** `wl_dump.py` (corrected-path copy) over MAIN `0xC780`–`0xCB80`
   (DTMF autodialer → `WL_MAIN_DTMF.lst`) and SUB `0xFFF0A2C0`–`0xFFF0A480`,
   `0xFFF0B840`–`0xFFF0BE60`, `0xFFF12320`–`0xFFF12420` (WIRES-X room/node label,
   connect-result renderer, search-and-direct → `WL_SUB_WXROOMNODE/WXCONNECT/WXDIRECT.lst`).
   Plus raw scans: every `MOV.L #imm` load of the camera-settings base `0x8C4D` in SUB
   (2351 hits, `0xFFEDE400`–`0xFFF45481` — it is the master settings struct, not a
   camera-only object), and reference scans locating the SUB WIRES-X UI code from its
   strings. Cross-read MAIN-IO's `sci_channels.tsv` findings for MAIN's four SCIs.

Scope I did **not** cover, and should be treated as not-searched rather than absent:
the camera image *transport* was not traced end to end (candidate MAIN port narrowed,
below); the WIRES-X **on-air** side (C4FM DV framing) is PROTOCOLS' and I did not touch
it; SUB's `FFF40000`–`FFFFFFFF` was not force-disassembled. MAIN's SCI at `0xFFFF88`
and the block at `0xF610`, listed as un-analysed in the interim, are now **resolved by
MAIN-IO**: `0xFFFF88` is the DSP (clocked-synchronous, external clock) and `0xF610` is
the 500 kbaud SUB link — neither is an accessory port.

## Findings

### 1. SUB's three serial channels, and what is on each

SUB has exactly three SCI channels and no RSPI or RIIC, so every SUB-side accessory is on
one of these. A three-entry channel abstraction sits above them.

`sub_FFEDAB4C` is the channel bring-up. It calls `sub_FFEDB300` (pin/MPC/ICU setup for all
three), then:

```
FFEDAB6B  mov.l   #unk_FFC3EB44, r1
FFEDAB71  bsr.a   sub_FFEDB4E8          ; SCI0  <- config at FFC3EB44 + 0
FFEDAB75  mov.l   #unk_FFC3EB44, r1
FFEDAB7B  add     #6, r1
FFEDAB7D  bsr.a   sub_FFEDB8F1          ; SCI2  <- config at FFC3EB44 + 6
FFEDAB81  add     #0Ch+var_A, sp, r1
FFEDAB84  bsr.a   sub_FFEDBD53          ; SCI3  <- config copied from FFF483C8
```

The config record is six bytes: `u16 rate_code; u8 data_bits; u8 stop_bits; u8 parity;
u8 flow`. `sub_FFEDB4E8` decodes `rate_code` as **bits per second divided by 100** and
looks up an (SMR, BRR) pair in a table at `0xFFC00100` (file `0x100`):

| rate code | ×100 | SMR | BRR | actual at PCLKB = 48 MHz |
| --- | --- | --- | --- | --- |
| `0x0030` | 4800 | `01` | `0x9B` | 4808 |
| anything else (default) | 9600 | `01` | `0x4D` | 9615 |
| `0x0090` | 14400 | `01` | `0x33` | 14423 |
| `0x00C0` | 19200 | `01` | `0x26` | 19231 |
| `0x0180` | 38400 | `01` | `0x12` | 39474 |
| `0x01E0` | 48000 | `01` | `0x0E` | 50000 |
| `0x0480` | 115200 | `00` | `0x19` | 115385 |
| `0x09C4` | 250000 | `01` | `0x02` | 249600 |
| `0x1388` | 500000 | `00` | `0x05` | 500000 |

SEMR is written `0x10` (ABCS = 1, eight clocks per bit) for all three channels at
`FFEDB3E1`/`FFEDB416`/`FFEDB44B`, which is what makes the arithmetic come out at
PCLKB ≈ 48 MHz. Confirmed. The chan-0 and chan-1 rate can also be set from an ASCII
string by `sub_FFEDAE05`, which parses `<rate/100>,<bits>,<stops>,<parity>,<flow>` with
`'7'` → 7 data bits, `'2'` → 2 stop bits, `'E'`/`'O'` → even/odd parity, `'X'`/`'H'` →
flow control. It refuses channel 2.

The actual configs, and the ring buffers from the parameter table at `0xFFECE4E8`
(three 12-byte rows: rx address, tx address, rx size, tx size):

| chan | SCI | regs | config bytes | rate | rx ring | tx ring | RXI/TXI vectors |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 0 | SCI0 | `0x0008A000` | `88 13 08 01 00 00` | **500000** 8N1 | `0x00000004`, 32768 B | `0x00008004`, 2048 B | 58 / 59 |
| 1 | SCI2 | `0x0008A040` | `60 00 08 01 00 00` | **9600** 8N1 | `0x00008804`, 256 B | `0x00008904`, 64 B | 62 / 63 |
| 2 | SCI3 | `0x0008A060` | `80 04 08 01 00 00` | **115200** 8N1 | `0x00008944`, 256 B | `0x00008A44`, 64 B | 80 / 81 |

`sub_FFEDAF2D(chan, buf, len)` is the shared transmit. Its six call sites divide the
channels cleanly:

- channel 0: `sub_FFEDD182`, `sub_FFEDD355`, `sub_FFEDD528`, `sub_FFEDD6FB`,
  `sub_FFEDD8DC`, all from a shared buffer at RAM `0x12D44 + 0x85F6/0x8DF6/0x95F6/
  0x9676/0x96F6`. That plus 500 kbps and a 32 KB receive ring identifies it as the
  MAIN↔SUB link. BOOT-IPC owns it; I did not go further.
- channel 1: `sub_FFEE0FA3` only — the GPS.
- channel 2: `sub_FFF3B630` only — Bluetooth.

The channel-enable `sub_FFEDAC17(chan, mask)` is called with chan 1 from `sub_FFEDC16C`
and `sub_FFEDF795`, and with chan 2 from `sub_FFF395DF` (the Bluetooth init). Confirmed.

### 2. Bluetooth

**It is a module, not a stack.** SUB never touches a Bluetooth baseband; it sends text
lines to something on SCI3 that answers in the same language, and that something does its
own discovery, pairing, bonded-device storage and SCO audio. So the module carries its own
firmware, which is not in this update package.

**Transmit path.** `sub_FFF3B630(fmt, ...)` is the only writer of channel 2:

```
FFF3B63F  mov.l   #1075Fh, r3          ; scratch buffer in RAM
FFF3B645  bsr.w   sub_FFF3B1F7         ; vsnprintf-style formatter
FFF3B648  mov.l   r1, 0Ch+var_C[sp]    ; formatted length
FFF3B64C  mov.l   #1075Fh, r2
FFF3B652  mov.l   #2, r1               ; channel 2
FFF3B654  bsr.a   sub_FFEDAF2D
```

All 28 of its call sites lie inside `FFF397C5`–`FFF3B0DB`, i.e. entirely within the
Bluetooth driver. There is no raw-byte relay onto channel 2 anywhere.

**Receive path.** Two token classifiers walk pointer arrays in RAM and compare the first
four bytes of an incoming line:

- `sub_FFF3A3A7` — array at RAM `0x69550`, indices 1..5, and it answers `ERROR\r\n` on no
  match. Dispatched by `sub_FFF3A204` to `sub_FFF3AD3E`, `sub_FFF3ADEC`, `sub_FFF3AE7C`,
  `sub_FFF3AE90`, `sub_FFF3AEF9`.
- `sub_FFF3A349` — array at RAM `0x69568`, indices 1..7. Dispatched by `sub_FFF3A259` to
  `sub_FFF3A414`, `sub_FFF3A639`, `sub_FFF3A493`, `sub_FFF3A833`, `sub_FFF3A95B`,
  `sub_FFF3A79B`, `sub_FFF3A8C9`.

The two RAM arrays are contiguous (`0x69550` + 6×4 = `0x69568`) and are the runtime copy
of a **fourteen-entry ROM pointer table at `0xFFEDA7A0`** (file `0x2DA7A0`), which lives
in the initialised-data section and therefore has no code reference — I found it with the
raw scanner, and confirmed no 32-bit word anywhere in the 4 MB image equals `0xFFEDA7A0`:

```
FFEDA7A0: FFF4AE70 FFF4AE75 FFF4AE7A FFF4AE7F   "    " SCAN LINK SCOL
FFEDA7B0: FFF4AE84 FFF4AE89 FFF4AE8E FFF4AE92   TXAT PINF "   " HELL
FFEDA7C0: FFF4AE97 FFF4AE9C FFF4AEA1 FFF4AEA6   PAIR FIND ERAT RXAT
FFEDA7D0: FFF4AEAB FFF4AEB0 00000000            SCOI ERRO  (terminator)
```

So the complete protocol vocabulary is: `SCAN`, `LINK`, `SCOL`, `TXAT`, `PINF` (group A,
command/echo) and `HELL`, `PAIR`, `FIND`, `ERAT`, `RXAT`, `SCOI`, `ERRO` (group B,
events). The format strings are at `0xFFF4AEB5`–`0xFFF4AFAF`. Full table with senders and
handlers: `ida\out\wireless\bt_commands.tsv`.

Worth calling out:

- `LINK=%c%c%c%c%c%c%c%c%c%c%c%c\r\n` (`0xFFF4AF5D`) and
  `PINF=0,%c%c%c%c%c%c%c%c%c%c%c%c\r\n` (`0xFFF4AF8F`) — twelve ASCII hex characters, i.e.
  a 48-bit Bluetooth device address. `LINK=1` / `LINK=0` connect and disconnect;
  `PINF=0` / `PINF=0,<addr>` is the paired-device record that feeds the `DEVICE LIST`
  menu item.
- `HELL%c\r\n` is the presence handshake. `sub_FFF3A414` accepts `'O'` (`cmp #4Fh` at
  `FFF3A41A`) or an ASCII digit (`cmp #30h`/`cmp #39h` at `FFF3A423`/`FFF3A42C`), so the
  module reports a one-character version or status. A radio with no module fitted simply
  never gets an answer.
- `FIND=%c%c%c%c` and `FIND=OVER` are discovery results and end-of-discovery; `SCAN=%d`
  starts it. These drive the `Searching` / `No Device` strings at `0xFFF4AB4A`.
- `PAIR=0` / `PAIR=%c%c%c%c` is pairing.
- `SCOL=1` / `SCOL=0` open and close the **SCO** link — Bluetooth's 64 kbit/s synchronous
  voice channel — and `SCOI=%c` is its indication. `TXAT=%d`, `RXAT=`, `ERAT=` are level
  and error controls.
- `Connected` / `Not Connected` / `Connecting` at `0xFFF4A4E8`/`0xFFF4A4F8`/`0xFFF4A508`,
  and a second `Connected` / `Not Connected` / `Busy Error` / `Offline Error` /
  `Not Accepted` / `No Matches` set at `0xFFF4AA84`. These are pairing/connection UI, not
  USB status. Confirming the coordinator's correction.
- `Bluetooth ` + katakana at `0xFFF4AA1E` and `0xFFF4AA31` are the two Bluetooth menu
  titles, referenced from `FFF0A7EF`, `FFF0A801`, `FFF0A829`.
- The OPTION menu group (category table row at `0xFFED7544`, count 4, first label
  `0xFFC3E709`) is exactly `USB CAMERA`, `Bluetooth`, `DEVICE LIST`, `Bluetooth Save`.
  `Bluetooth Save` is the module power-save setting, in the same family as the FTM-400's.

**Why this is audio only.** Three independent lines of evidence, all confirmed:

1. Vocabulary. Fourteen tokens, and the only transport-layer ones are SCO. Nothing named
   RFCOMM, SPP, serial port profile, L2CAP, A2DP or OBEX appears in either image (searched
   both 4 MB and 1 MB plaintexts for those literals and for `AT+`; not found).
2. Plumbing. Channel 2's transmit ring is 64 bytes and its receive ring is 256 bytes
   (`0xFFECE4E8` row 2). A data pipe cannot live in 64 bytes, and the only writer is a
   `printf`. There is no `bt_send_bytes`.
3. Audio never crosses the wire. 115200 bps cannot carry a voice channel alongside
   control text, and `TXAT`/`RXAT` are *level* commands, which only make sense if the
   module has its own analogue or PCM audio path to the radio's codec. MAIN-IO's pin-level
   view should be able to confirm that path; I did not.

So: no wireless data in, no wireless data out. Bluetooth is a hands-free headset link.

### 3. GPS

**Module family.** MediaTek. `$PMTK` is MediaTek's proprietary command prefix and the
specific set used — 313 (SBAS), 314 (NMEA output mask), 225 (periodic mode), 286 (AIC),
301 (DGPS source), 330 (datum), 386 (static navigation), 101/102/103 (hot/warm/cold start),
001 (ACK) — is the MT333x/MT3339 command set. Confirmed by the strings; the exact part
number is Unknown from this package.

**Link.** SUB channel 1 = SCI2 at `0x0008A040`, **9600 bps 8N1**, RXI vector 62, TXI 63.
Confirmed: config `0x0060` (= 9600/100) at `0xFFC3EB4A`, and `sub_FFEE0FA3` transmits on
channel 1.

**Sentence builder**, `sub_FFEE0FA3(const char *cmd)` at `0xFFEE0FA3`. Hand-reconstructed:

```c
void gps_send(const char *cmd)
{
    uint8_t  cs = 0;
    uint16_t i  = 0;
    char    *buf = (char *)0x8BB6;        /* TX staging buffer */

    while ((buf[i] = cmd[i]) != '\0') {
        if (i != 0) cs ^= (uint8_t)buf[i];   /* XOR everything after the '$' */
        i++;
    }
    buf[i++] = '*';
    hex2(buf + i, cs);                       /* sub_FFEE1C6A, two ASCII hex digits */
    i += 2;
    buf[i++] = '\r';
    buf[i++] = '\n';
    uart_send(1, buf, i);                    /* sub_FFEDAF2D, channel 1 */
}
```

That is a correct NMEA 0183 checksum. Confirmed instruction by instruction at
`FFEE0FAF`–`FFEE1039`.

**Command sequencing.** `sub_FFEE0D4D` is an ACK-gated state machine. It indexes four
pointer arrays by four state counters and sends one command per step:

| array | address | state var | contents |
| --- | --- | --- | --- |
| init | `0xFFED4288` | `0x1CC68` (0..3) | `$PMTK313,1`, `$PMTK314,0,1,1,1,1,1,0,…`, `$PMTK225,0`, `$PMTK286,1` |
| datum | `0xFFED4298` | `0x1CC6C` | `""`, `$PMTK330,0`, `,1`, `,2`, `,212`, `,213` |
| static nav | `0xFFED42B0` | `0x1CC78` | `""`, `$PMTK386,0.6`, `$PMTK386,1.0` |
| DGPS | `0xFFED42BC` | `0x1CC84` | `""`, `$PMTK301,0`, `,1`, `,2` |

Index 0 of each option array is the empty string, i.e. "send nothing", which is how an
unset menu option is handled. `sub_FFEE103B` is the ACK gate: it compares the first eight
received bytes against `"$PMTK001"` (`FFEE106A`, string at `0xFFC00112`) and only then
increments the next state counter and re-arms the timer via `sub_FFEE12E7`. Cold and warm
restarts use `$PMTK103` (`0xFFC00112`) and `$PMTK102` (`0xFFC0011B`) at `FFEE0E95` and
`FFEE0EE0`. Full decode: `ida\out\wireless\gps_commands.tsv`.

**What the configuration means for the location features.** `$PMTK314` has RMC, VTG, GGA,
GSA and GSV at rate 1 and everything else at 0, so the module emits those five sentences
once per fix; `$PMTK225,0` keeps it in continuous mode (no periodic standby), so the fix
rate is the module default of 1 Hz. That bounds the APRS beacon and SmartBeaconing inputs
to 1 Hz position, speed and course.

**Sentence parsing.** `sub_FFEE0000` is the sentence dispatcher; the received sentence sits
in RAM at `0x8B96`. Field extraction is by `sub_FFEDFE33` ("advance to the next
comma-separated field"), which has 30 call sites across `FFEE0191`–`FFEE0BBC`. Two numeric
converters: `sub_FFEE0CF3` parses a signed decimal field of up to 4 digits (`'-'` handling
at `FFEE0D13`), and `sub_FFEE0C85` parses hex with `'.'` handling. `sub_FFEE206D` is
ASCII→nibble.

`sub_FFEE0853` is the **GSV** parser: it writes 6-byte per-satellite records and
`sub_FFEE0BE2`/`0xFFEE0A16` then bubble-sorts up to 0x24 (36) satellites by SNR and copies
the top entries into a display table at RAM `0x1CC90` (stride 6; count at `+0x30`, PRN at
`+0x32`, elevation `+0x33`, azimuth `+0x34` as a word, SNR `+0x36`, in-use flag `+0x37`).
The working satellite table is at RAM `0x123E2`. That is what draws the `SENSOR INFO` /
satellite screen. `sub_FFEE0B54` decodes the GSA fix-type field (`'2'` → 1, `'3'` → 2,
else 0 — i.e. 2D / 3D / no fix). `sub_FFEE0B92` clears a 12-entry array to `-1` then fills
it from consecutive fields — the GSA satellite-in-solution list.

`sub_FFEE1105` starts **TPU0** (`0x00088100` TSTR bit 0, channel registers at
`0x00088110`, TGRA = `0xEA5F`, TIER = `0x41`) and enables its interrupt through
ICU IER `0x00087210` bit 7 (vector 135) with IPR `0x00087387` and SLIBXR `0x00087787` =
`0x0F`. `sub_FFEE11B8` is the handler: it clears TSR.TGFA at `0x00088115`, bumps a counter
at RAM `0x124D4`, and calls `sub_FFF36CAB`. This is the GPS timing/timeout tick.

`LOCATION SERVICE` (`0xFFC3E7D1`) is in the setup label table but is **not** in any menu
category group I decoded — the category table rows cover `0xFFC3E76D` (count 1) then jump
to `0xFFC3E781` (count 3). Its function is Unknown from this pass; MENU should settle
whether it is reachable.

The GPS log *file* on the microSD (`I:\FT3D\GPSLOG`, `0xFFF4AD6F`) is STORAGE's.

### 4. WIRES-X and the DATA-jack framed protocol

WIRES-X on this radio has three faces, and only the middle one crosses an interface in
my scope:

1. **User mode over the air.** You pick a node/room in SUB's WIRES-X UI and the radio
   links through a C4FM node on the DV **DATA** channel. The node/room ID, the
   connect/disconnect handshake and the connected-node identity all ride that on-air
   C4FM frame — **PROTOCOLS' scope**, no UART, no accessory. SUB draws the result (the
   connect-state renderer below); MAIN owns the RF.
2. **Portable-digital-node (PDN) mode.** The radio *is* the node: it talks to a PC
   running WIRES-X software over the **DATA-jack framed protocol** on MAIN's SCI at
   `0xFFFE90` (or, per MAIN-IO, potentially the USB CDC-ACM port). This is the only
   WIRES-X path that crosses a serial interface, and it shares its wire format with the
   clone/programming protocol.
3. **DTMF autodialer** (`DTMF MODE` / `DTMF MEMORY`) — a *separate* manual-DTMF feature,
   not WIRES-X node control. Covered at the end of this section.

**The frame format**, from `sub_6B77E` (MAIN, `0x0006B77E`) — the receive state machine —
and `sub_6CB40`/`sub_6CB5E`:

```
+------+---------+---------------+-----------------+------+-----------+
| 0x01 | cmd (1) | length (4 hex) | data (length B) | 0x04 | cksum (2) |
+------+---------+---------------+-----------------+------+-----------+
```

- `0x01` resets the frame (`loc_6B884`: `buf[0] = 0x01`, count = 1, checksum seeded 0x01).
- `length` is four ASCII hex digits, decoded by `sub_6CB5E` once nine bytes are in and
  stored at `0xFFFFB3CA`. Total frame length is `length + 9` (`FFEDB862`… i.e.
  `0x0006B866  add.w #9, r4`), which is 6 bytes of header plus `length` bytes of data plus
  a 3-byte trailer.
- The trailer is `0x04` then two ASCII hex digits.
- The checksum is the 8-bit sum of every byte from the `0x01` through the `0x04`
  inclusive, emitted as two ASCII hex characters. Verified in the code: the running sum at
  `0xFFFFB3DC` accumulates every byte (`0x0006B874`), the checksum-high character is
  subtracted back out at `0x0006B8B4`, and `sub_6CB40` converts the ASCII hex pair before
  the compare at `0x0006B8CE`.
- The frame assembly buffer is RAM `0xFF1AC8`; the SCI receive ring is
  `0xFF27C8`–`0xFF29C8` (512 bytes), set up by `sub_45186`.

I verified the format against the ROM templates. `0x0006C570`:
`01 'V' "0020"` then `"FT2D    JPN     Ver0202 20180418"` (exactly 0x20 = 32 bytes) then
`0x04`. And `0x0006C538`: `01 'V' "0030"` then `"FT3D"` + 24 spaces + `"20180418"` + `"0"`
+ 7 spaces + `"0C01"` = exactly 0x30 = 48 bytes, then `0x04`. Both match.

**Command letters**, from the dispatcher at `0x0006BAD6`: `B`, `C`, `F`, `E`, `S`, `N`,
`W`, `V`, plus `M` handled separately at `0x0006B9FE`. Templates in ROM at
`0x0006C538`–`0x0006C650` also give `H`, `R` (three lengths: 0x61/0x89/0xBB = 97/137/187
data bytes) and `P`. `sub_6BB6E` builds the `H` status payload from ASCII characters
(`'0'`, `'9'`, `'D'`, `'2'`, `'1'`), so `H` is a periodic status frame — consistent with
the node-mode display strings (`LED : ON/OFF`, `MUTE : OFF/ALL/RX/TX`,
`Detect : Signal/DG-ID`, `TX ERROR`, `LEVEL`). `sub_6C686`, the `F` handler, compares a
5-byte identifier at frame+0x45 against RAM `0xFF0C33` and then copies 0x3C = 60 bytes
from frame+0x0E to `0xFF0BFC` — a callsign/radio-ID check followed by a 60-byte block,
which is the shape of a C4FM data payload. Full table:
`ida\out\wireless\wiresx.tsv`.

**The bulk transmit path**, `loc_6B91A`, is the most important thing in this section:

```
0006B92E  mov.l   #0xFEE000, er5          ; source buffer
0006B934  mov.b   @0xFFFFFE94:16, r4l     ; wait for SSR.TDRE
0006B93C  mov.l   #0x1A0, er4
0006B942  mov.l   er4, @0xFFFFFC54:16     ; DMABCR
0006B948  mov.l   er5, @0xFFFFFC40:16     ; MAR0A  = 0xFEE000
0006B94E  mov.l   #0xFFFE93, er4
0006B954  mov.l   er4, @0xFFFFFC44:16     ; IOAR0A = SCI TDR
0006B95A  mov.l   er3, @0xFFFFFC4C:16     ; ETCR0A = byte count
0006B960  mov.l   #0x200000, er4
0006B966  mov.l   er4, @0xFFFFFC58:16     ; DMACR
0006B96C  mov.b   #0xA2, r4l
0006B96E  mov.b   r4l, @0xFFFFFD22:16
0006B972  mov.l   #0x800001A0, er4
0006B978  mov.l   er4, @0xFFFFFC54:16     ; DMABCR, enable
0006B97E  bset    #7, @0xFFFFFE92:16      ; SCR.TIE
```

`sub_6B986` is the completion interrupt (clears SCR.TIE, `rte`). So MAIN can push an
arbitrary-length RAM buffer out of the DATA-jack serial port under DMA, with no per-byte
CPU cost. That is a genuine bulk data-out path.

**The port and its speed.** `sub_45186` configures the SCI at `0xFFFE90` in two modes:

- `[0xFFFF8DDE] == 0`: BRR comes from a 4-entry table at `0x000452C2` = `67 33 19 0C`
  indexed by `[0xFFFF8C27]`. With SMR = 0 (CKS = 00, so N = φ/(32·B) − 1) and φ = 16 MHz
  these are **4800 / 9600 / 19200 / 38400 bps** — exactly the four values in the
  `COM PORT SETTING` → `SPEED` option list (`0xFFF49FE3`, `0xFFF49FF3`, `0xFFF4A003`,
  `0xFFF4A013`). That cross-check is what pins this SCI to the DATA jack and pins
  φ = 16 MHz for MAIN.
- `[0xFFFF8DDE] != 0`: BRR fixed `0x0C` = **38400 bps**, and it calls `sub_6B700` to
  install the frame handler. So the framed protocol runs at 38400.

`sub_6B700` and `sub_6B73A` install one of two handler functions (`sub_6B9AC` /
`sub_6BA46`) through a pointer at `0xFFFFB3C6`, so there are two protocol personalities
on this port.

**The two personalities are the clone/PC link and the WIRES-X PDN link, selected by the
sign bit of `0xFFFF8DDE`.** Confirmed from the receive state machine (`WL_MAIN_WIRESFRAME.lst`):

```
0006B7B2  6a0c8dde   mov.b   @0xFFFF8DDE:16, r4l
0006B7B6  4b2e       bmi     loc_6B7E6          ; bit7 set  -> PDN branch
...
0006B7D6  6a0c8dde   mov.b   @0xFFFF8DDE:16, r4l
0006B7DA  4b12       bmi     loc_6B7EE          ; bit7 set  -> PDN branch
0006B7DC  5e002648   jsr     sub_2648           ; bit7 CLEAR -> clone branch:
0006B7E0  0480       orc     #0x80, ccr         ;   mask interrupts and
0006B7E2  5a002050   jmp     loc_2050           ;   SOFTWARE-RESET the radio
loc_6B7EE:
0006B7EE  5e06b700   jsr     sub_6B700          ; PDN: install frame handler
0006B7FA  6a18817e.. bset    #1, @0xFFFF817E    ;      set node-mode flags
0006B802  6a8cb3e5   mov.b   r4l, @0xFFFFB3E5   ;      (0xFFB3E5 = 1)
```

- `[0xFFFF8DDE]` bit 7 **clear** (a positive nonzero mode value): the **clone /
  programming** personality. Its `V` command reaches the `jsr sub_2648; orc #0x80,ccr;
  jmp 0x2050` software-reset (also at `0x06B7DC` and in the `V` handler `0x06BB08`),
  which is the memory-clone / ADMS session MAIN-IO decoded (`V M B C E F S N W`
  inbound, `V H R P …` outbound, `R` = block read).
- `[0xFFFF8DDE]` bit 7 **set** (a negative mode value): the **WIRES-X PDN / node**
  personality. It installs the frame handler via `sub_6B700`, sets the node-mode flags
  `0xFF817E` bit 1 and `0xFFB3E5 = 1`, and the reset path is not taken. The `H`
  periodic-status and `W` position frames belong here (node keep-alive / GPS).

The same flag gates the display: in `WL_MAIN_WIRESUI.lst`, `[0xFFFF8DDE] != 0`
(`0x0081B6`, `beq`) is what copies the `WIRES-X`/`WIRES-X NODE` strings at `0x8264`
into the display line buffer `0xFFB05A`. So `0xFFFF8DDE` is the master "WIRES-X node
mode" selector: `0` = normal user COM port, nonzero-positive = clone, negative = PDN.
(`sub_6B9AC` similarly branches on the sign bit to `sub_6C680`→`sub_2611A` vs
`sub_6C652`→`sub_25EAE`, the same two arms.) Confirmed.

**The WIRES-X connect-result renderer** lives in SUB at `sub_FFF0B84D`
(`WL_SUB_WXCONNECT.lst`). It is a switch on a connection-state code that centres and
draws one of six result strings through `sub_FFEF1B23`:

| state code | string | address |
| --- | --- | --- |
| `0x09` | `Connected` | `0xFFF4AA84` |
| `0x0D` | `Not Connected` | `0xFFF4AA8E` |
| `0x0A` | `Busy Error` | `0xFFF4AA9C` |
| — | `Offline Error` | `0xFFF4AAA7` (`0xFFF0B92C`) |
| — | `Not Accepted` | `0xFFF4AAB5` (`0xFFF0B96B`) |
| — | `No Matches` | `0xFFF4AAC2` (`0xFFF0B9F2`) |

The state code arrives from MAIN over the IPC link (SUB has no RF and no on-air frame
parser); SUB only renders it. This is the connected-node status surface the owner sees.

**The user-facing WIRES-X surface.** SUB menu category 7 (row at `0xFFED7524`: count 5,
first label `0xFFC3E26D`) is `RPT/WIRES FREQ`, `SEARCH SETUP`, `EDIT CATEGORY TAG`,
`REMOVE ROOM/NODE`, `DG-ID`. The operating strings are split across both images: MAIN has
the node-mode display (`WIRES-X`, `WIRES-X NODE`, `WIRES-X PDN`, `WIRES-X DIRECT`,
`WIRES-X DIRECT *`, `Detect : Signal`, `Detect : DG-ID`, `LED : ON/OFF`, `LEVEL`,
`MUTE : OFF/ALL/RX/TX`, `TX ERROR`, all in an 18-byte-stride table at `0x00008252`
referenced from `0x000081C2`, plus a second copy at `0x00008A70`); SUB has the search and
list UI (`(WIRES-X)` `0xFFF48860`, `RPT/WIRES ` `0xFFF4A77B`, `CATEGORY ` `0xFFF4A796`,
`ROOM/NODE :` `0xFFF4A7A7`, `SEARCH & DIRECT` `0xFFC3E88E`, `LOCAL NEWS` `0xFFC3E871`,
`UPLOAD  `/`DOWNLOAD` `0xFFC3E87C`, `ADD TO CATEGORY` `0xFFF4AD44`, `Searching`/
`No Device` `0xFFF4AB4A`, and the connect-result set `No Matches` / `Not Accepted` /
`Busy Error` / `Offline Error` at `0xFFF4AA9C`). `DG-ID TX  :` / `DG-ID RX  :` /
`DG-ID: ` are at `0xFFF48E93`.

`WiRES   ` (8 characters, `0x0005ECE6`) and `L-NODE` (`0x00066B2E`) are node/room name
fields in MAIN.

The on-air C4FM side of WIRES-X is PROTOCOLS' scope and I did not analyse it.

**DTMF is a separate feature, not a WIRES-X control path.** The assignment asks about a
"DTMF/command interface" for WIRES-X; the answer is that WIRES-X node/room selection uses
the search UI plus the on-air C4FM DATA channel (or the PDN framed link), **not** DTMF.
DTMF here is the classic manual-DTMF / autodial-memory feature, and it lives entirely on
MAIN. Evidence, confirmed:

- Menu labels `DTMF MODE` (`0xFFC3E0F1`) and `DTMF MEMORY` (`0xFFC3E105`) in SUB's
  setup-label table, adjacent to `BELL`, `DCS CODE`, `PAGER` — i.e. among the analog-FM
  signalling settings, not among the WIRES-X items (which are category 7, section above).
- The symbol table `0123456789ABCD*#-` (16 DTMF symbols) at MAIN `0x0000C8D4`.
- `sub_C814` (MAIN `0x0000C814`, `WL_MAIN_DTMF.lst`) is the DTMF display builder:

  ```
  0000C846  6a0dac07   mov.b   @0xFFFFAC07:16, r5l      ; DTMF digit position
  0000C854  6a0cac08   mov.b   @0xFFFFAC08:16, r4l      ; keyed DTMF digit code
  0000C858  7a64..00ff and.l   #0xFF, er4
  0000C85E  78406a2c0000c8d4  mov.b @(0xC8D4:32,er4), r4l  ; charset[code] -> ASCII
  0000C866  6e9c000a   mov.b   r4l, @(0xA:16,er1)       ; into the display line
  ```

  Templates `" : DTMF -"` (`0x0000C8BC`) and `"DTMF -"` (`0x0000C8CA`) render as
  `DTMF -<digit>` on screen while you key digits. The digit state is in MAIN RAM
  `0xFFFFAC07`/`AC08`/`AC09`.

So DTMF is a MAIN-side keypad→display→FM-TX-audio autodialer. It never touches the
WIRES-X frame code (`0x06Bxx`), the DATA-jack framed protocol, or SUB's node control.
`Not found` (searched MAIN `0x0000C780`–`0x0000CB80` and the WIRES frame region): no
cross-reference between the DTMF routines and the WIRES-X path.

### 5. The DATA-jack accessory and the camera

**Confirmed.** `sub_FFF08201` (SUB) is the `USB CAMERA` settings screen. It reads a
settings struct at RAM `0x8C4D`:

| field | offset | values | strings |
| --- | --- | --- | --- |
| cursor | `+0x21` | 0..2 | — |
| SIZE | `+0x22` | 0 = `320*240`, 1 = `160*120` | `0xFFF4A496`, `0xFFF4A49E` |
| QUALITY | `+0x23` | 0 = `LOW`, 1 = `NORMAL`, 2 = `HIGH` | `0xFFF48982`, `0xFFF48A4D`, `0xFFF48986` |
| SP SEL | `+0x24` | 0 = `CAMERA`, 1 = `INT SP` | `0xFFF4A4C1`, `0xFFF4A4C8` |

Labels `SIZE   :` `0xFFF4A48D`, `QUALITY:` `0xFFF4A4AF`, `SP SEL :` `0xFFF4A4B8`, with
Japanese alternates selected by `[0x8F72]`. Display calls are `sub_FFEFA7E7`.
`Connected` / `Not Connected` / `Connecting` sit immediately after these strings at
`0xFFF4A4E8`.

`SP SEL : CAMERA / INT SP` is decisive on one point: the accessory has a **speaker**, so
it is a speaker-microphone, not a bare camera. Two QVGA-class resolutions, a quality
setting and a speaker selector is the Yaesu camera speaker-microphone (MH-85A11U class)
feature set.

The camera settings are **not a standalone object**: the base `0x8C4D` is loaded 2351
times across all of SUB's code (`0xFFEDE400`–`0xFFF45481`), so `0x8C4D` is the master
settings/context struct and `SIZE`/`QUALITY`/`SP SEL` at `+0x22..+0x24` are three fields
of it. That matters because MAIN owns persistence and ships a ~254-byte settings block to
SUB over the IPC link (RESUME-DEEP), so these camera settings are part of the normal
config sync, not a camera-only channel.

**Inferred, not yet confirmed — the image transport.** SUB has no USB host stack and
never addresses the RX64M PDC unit, so the JPEG cannot arrive on SUB directly. MAIN holds
the image-side code — `Send pictures` (`0x00043636`), `.jpg` (`0x0006A974`, `0x0006F642`),
and the SD path prefixes `_VOICE` / `_MESSAGE` / `_PICT` at `0x00067330`. The interim
hypothesis that the camera speaker-mic might sit on MAIN's `0xFFFF88` or `0xF610` is now
**eliminated**: MAIN-IO pinned `0xFFFF88` as the DSP (clocked-synchronous slave) and
`0xF610` as the 500 kbaud SUB link. That leaves exactly one candidate accessory serial
port on MAIN — **SCI-B at `0xFFFF60`, fixed 38400 8N1**, which MAIN-IO could not name
("unidentified on-board module") and which carries a deliberate **external-port
pass-through bridge** (set `0xFF817F` bit 7 → the DATA-jack RX is routed straight into
SCI-B's TX queue). A camera speaker-microphone that a PC can also address through the
radio fits that bridge exactly. The likely full path, still to be confirmed: camera →
MAIN SCI-B `0xFFFF60` → MAIN buffers the JPEG in external RAM around `0xFEE000` → MAIN
ships it to SUB over the 500 kbaud channel-0 link (32 KB rx ring, sized for it) → SUB
writes it to microSD. No JPEG SOI marker, `JFIF` or `Exif` literal exists in either
image, consistent with the radio moving an opaque blob rather than parsing it. Marked
**Inferred**; the un-run confirmation is reading MAIN's SCI-B parser `sub_48C44`.

The `COM PORT SETTING` option pool in SUB (16-byte stride, `0xFFF49F53` onward) is worth
recording because it tells you what the DATA-jack port can do without any framed
protocol at all:

- sub-items: `SPEED` `0xFFF49F53`, `INPUT` `0xFFF49F63`, `OUTPUT` `0xFFF49F73`,
  `WAYPOINT` `0xFFF49F83`
- `SPEED` values: `4800`, `9600`, `19200`, `38400` (`0xFFF49FE3` .. `0xFFF4A013`)
- the 16-byte-stride value list at `0xFFF4A029`: `OFF`, `GPS`, `WAY.P`, `DSP H`, `DSP A`,
  `DSP D`, `NMEA `

`DSP H`, `DSP A` and `DSP D` as selectable COM-port output modes are a firmware-supported
**debug data output on the DATA jack**, and MAIN-IO's watch list already names
`dsp_trace_fmt` at `0x0005A47E` and `dsp_cmd_name` at `0x0005A506` in MAIN. That is a
hand-off to DSP-AMBE and it is a second, simpler data-out route.

MAIN also emits NMEA itself: fixed templates `$GPWPL,0000.00,N,00000.00,E,`
(`0x000458D8`), `$GPRMC,000000.000,V,0000.0000,N,00000.0000,E,0000.00,000.00,000000,,*`
(`0x000463E6`) and `$GPGGA,000000.000,0000.0000,N,00000.0000,E,0,00,00.0,00000.0,M,0000.0,M,000.0,0000*`
(`0x0004642E`), copied into a work buffer at `0xFF9C20` by an `eepmov.w` at `0x000455C4`.
These serve both the APRS raw-NMEA position formats and the `OUTPUT: NMEA` / `WAY.P`
COM-port modes.

### 6. Inventory of every non-USB external interface

Machine-readable version: `ida\out\wireless\interfaces.tsv`.

| # | Interface | CPU / channel | Bus and rate | Protocol | Direction | Data or audio/control | Status |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 1 | MAIN↔SUB inter-processor link | SUB chan 0 / SCI0 `0x8A000`; MAIN side not identified | UART 500 000 bps 8N1, 32 KB rx ring | binary, five senders at `FFEDD182`+ | bidirectional | **data**, bulk | confirmed |
| 2 | GPS module | SUB chan 1 / SCI2 `0x8A040` | UART 9600 bps 8N1 | NMEA 0183 + `$PMTK` | bidirectional | **data** (position/time) | confirmed |
| 3 | Bluetooth module | SUB chan 2 / SCI3 `0x8A060` | UART 115 200 bps 8N1, 256/64 B rings | Yaesu ASCII `TOKN=value\r\n`, 14 tokens | bidirectional | **control only** | confirmed |
| 3a | Bluetooth air link | — | Bluetooth SCO | — | bidirectional | **audio only** | inferred |
| 4 | DATA jack, plain COM mode | MAIN SCI `0xFFFE90` | UART 4800/9600/19200/38400 bps 8N1 | line text: NMEA in, NMEA/`$GPWPL`/`DSP H/A/D` out | bidirectional | **data** (text) | confirmed |
| 5 | DATA jack, framed mode | MAIN SCI `0xFFFE90` | UART 38 400 bps 8N1, DMAC bulk TX | `0x01`\|cmd\|len4\|data\|`0x04`\|cs2 | bidirectional | **data**, bulk | confirmed |
| 6 | microSD card | SUB SDHI `0x0008AC38` | SD | FAT12/16/32/exFAT | bidirectional | **data** | confirmed (STORAGE owns it) |
| 7 | MAIN SCI-B `0xFFFF60` = on-board accessory | MAIN | UART 38 400 bps 8N1, 2304 B rx ring | unknown; external-port pass-through via `0xFF817F` bit 7 | bidirectional | unknown; leading camera candidate | port confirmed (MAIN-IO), far end unknown |
| 8 | DSP / vocoder | MAIN SCI-C `0xFFFF88` | clocked-synchronous, MAIN = clock slave, ≤ 4 Mbit/s, DMA ch1 | 1-byte opcode, 32/96-byte frames | bidirectional | **data** (vocoder frames) | confirmed (DSP-AMBE / MAIN-IO own it) |
| 9 | Camera speaker-microphone | MAIN, most likely SCI-B `0xFFFF60` (interface 7) | unknown | unknown | in (image), out (control) | **data** (JPEG-class image) | settings confirmed; transport **inferred** |

**Which is the most capable route in and out?** Interface 5 — the DATA-jack serial port
in its framed mode, 38 400 bps 8N1, with a DMAC channel feeding the transmit register from
a RAM buffer at `0xFEE000`. It is the only non-USB interface that combines an external
connector, a framed bidirectional protocol with a length field and a checksum, and a
zero-CPU bulk transfer engine. Its ceiling is 38 400 bps ≈ 3.8 kB/s net. Interface 4 (the
same port in plain mode, including `DSP H/A/D`) is the same wire with no framing and is
the easier one to exercise. The microSD card moves far more data but is not a live link.
Interface 1 is faster (500 kbps) but internal. Bluetooth is not a data route at all.

## USB relevance

1. **Everything USB.** Nothing here is USB. The `USB CAMERA` label is a misnomer: the
   settings it exposes (two QVGA resolutions, a quality setting, and a *speaker* selector)
   describe a speaker-microphone accessory, and neither image contains a USB host stack,
   a USB descriptor, or an access to the RX64M USB0 or PDC blocks. Read alongside the
   earlier negative results, `USB CAMERA` is a product-naming artefact, not evidence of a
   USB port.
2. **Is USB SDR possible?** Nothing in my scope supplies a sample source. The GPS UART at
   9600 bps and the Bluetooth UART at 115 200 bps are control links. The only bulk engine
   I found is MAIN's DMAC feeding an SCI at 38 400 bps, which is three orders of magnitude
   short of even 48 kHz 16-bit IQ (1.5 Mbit/s). If a stream ever leaves this radio without
   new hardware, it leaves at 38 400 bps through the DATA jack, not as IQ.
3. **Can the DSP be reached directly?** A real lead, and it belongs to DSP-AMBE:
   `COM PORT SETTING` → `OUTPUT` offers `DSP H`, `DSP A` and `DSP D`
   (`0xFFF4A059`/`0xFFF4A069`/`0xFFF4A079`), i.e. three firmware-supported DSP trace
   modes on the DATA-jack serial port, and MAIN-IO already located `dsp_trace_fmt`
   (`0x0005A47E`) and `dsp_cmd_name` (`0x0005A506`) in MAIN. That is a shipped, menu-
   selectable path that emits DSP information out of a physical connector, and it is the
   cheapest way to observe the vocoder without touching hardware.

## Open

Most valuable first. (The two biggest interim items — the WIRES-X-vs-clone personality
split, and MAIN's `0xFFFF88`/`0xF610` far ends — are resolved above and no longer here.)

1. **Confirm the camera image transport by reading MAIN's SCI-B parser `sub_48C44`**
   (`0x048C44`–`0x048E90`, the far end of `0xFFFF60`, 38400). This is the last candidate
   accessory port after `0xFFFF88`/`0xF610` were eliminated. If it frames image data,
   follow it to the DMA buffer near `0xFEE000` and then into the channel-0 IPC packet that
   reaches SUB and the microSD. The `.jpg` sinks at `0x0006A808` / `0x0006F512` are the
   MAIN-side anchors.
2. **Decode the `H`, `R` and `W` payload layouts** of the framed protocol in its PDN
   personality. `sub_6BB6E` builds the 30-byte `H` status; `R` has three fixed sizes
   (97/137/187) that look like C4FM data blocks; `W` is 72 bytes of position/route.
   Cross-check the `R` sizes against PROTOCOLS' on-air frame sizes — if they match, the
   PDN link carries the same DV DATA payloads the air side does.
3. **Confirm the Bluetooth audio path electrically.** The "audio only" verdict rests on
   the protocol vocabulary (SCO-only) plus the 64/256-byte ring sizes. MAIN-IO or SUB-VEC
   should be able to show the module's PCM/analogue connection to the codec, closing it.
4. **Settle `LOCATION SERVICE` (`0xFFC3E7D1`).** It is in the setup label table but not in
   any category group I decoded. MENU owns reachability; if it is live, find its handler.
5. **Confirm whether a Bluetooth module is actually fitted to an FT3DR.** The driver ships
   and the menu group is populated, but presence is detected at runtime by the `HELL`
   handshake, so the image cannot tell you. Unknown from this package.

## Artifacts and cross-agent notes

**Databases** (mine, do not let another agent open them; all paths are now under the
moved root the repository root):
`ida\db\jobs\WL_SUB\WL_SUB.i64` — RX, 1516 functions, forced over `FFED8B70`–`FFF40000`.
`ida\db\jobs\WL_MAIN\WL_MAIN.i64` — H8S, 3154 functions, forced over `0x400`–`0x7C000`.

**Tables written**, under `ida\out\wireless\`: `bt_commands.tsv`, `gps_commands.tsv`,
`wiresx.tsv` (updated this pass with the personality selector, connect-result states and
DTMF), `interfaces.tsv` (rows 7–9 updated), plus `WL_SUB_functions.tsv`,
`WL_MAIN_functions.tsv`, `WL_SUB_xrefs.tsv`. Listings this pass:
`lst\WL_MAIN_DTMF.lst`, `lst\WL_SUB_WXCONNECT.lst`, `lst\WL_SUB_WXROOMNODE.lst`,
`lst\WL_SUB_WXDIRECT.lst`; earlier listings `WL_MAIN_WIRESFRAME.lst`, `WL_MAIN_WIRESUI.lst`,
`WL_SUB_BT.lst`, `WL_SUB_GPS*.lst` remain the primary evidence for sections 1–3.

**Hand-offs to other agents:**
- PROTOCOLS: the WIRES-X on-air C4FM DV DATA framing, and the meaning of the framed
  protocol's `H`/`R`/`W` payloads (the `R` block sizes 97/137/187 should match on-air
  frame sizes if PDN relays the same DV DATA payloads).
- MAIN-IO / SUB-VEC: the Bluetooth module's electrical PCM/analogue path to the codec
  (to close the "audio only" verdict), and MAIN's SCI-B (`0xFFFF60`) far end / the camera
  transport confirmation via `sub_48C44`.
- MENU: reachability of `LOCATION SERVICE` (`0xFFC3E7D1`).

**Tooling caveat for any resumer:** the workspace was moved into
the repository root after the earlier pass, so `run_job.py`, `wl_dump.py` and
`wl_calls.py` still hardcode the dead `ROOT = r"."` / `OUT = r"ida/..."`.
This pass ran corrected-path copies. Fix those two constants before reusing the originals,
and keep using **forward slashes** in `--env` values (backslashes are eaten before IDA
sees them).
