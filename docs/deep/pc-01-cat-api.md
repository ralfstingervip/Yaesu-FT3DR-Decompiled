# PC-01 — DATA-jack framed command API (SCI-A `0xFFFE90`): implementer's card

Lane 1 of the PC-software pass. This is a static read of `decrypted\FT3D_MAIN_ver102_EXP.bin`
(MAIN, H8S, big-endian, base 0). The private IDA database `PC_L1` was copied from
`MAIN_FULL`; the dump script is `ida\jobs\pc_l1_dump.py`. Nothing was sent to a radio.
Machine-readable table: `ida\out\pc\L1-cat-commands.tsv`.

Tags: **[B `0xADDR`]** = byte-confirmed in the image at that address. **[I]** = inferred.

## 0. The headline, and corrections to doc 04 §10

1. **This is not a clone or programming protocol. It is the WIRES-X node-radio link.**
   The frame engine is armed only when the node-mode byte `0xFF8DDE` is non-zero
   [B `0x45186`: `bne` to `sub_6B700`, the only place that installs the frame handler].
   It never reads or writes memory images, the EEPROM, or flash. Its commands identify
   the radio, retune it (`M`), queue C4FM blocks and data messages for transmission
   (`E`, `F`), **key the transmitter** (`S`), and relay received on-air data and GPS
   text to the PC (`R`, `G`, `H`, `N`, `W`). Doc 14 already said this is the PDN/node
   link. Doc 04 called it "clone/CAT", and that label is wrong.
2. **`V` in the data phase restarts MAIN in both node modes.** At `0x6BB0C` the `bmi`
   skips only `jsr sub_2648`; `orc #0x80,ccr; jmp loc_2050` follows in both modes
   [B `0x6BB08`–`0x6BB14`]. Doc 04 said mode `0xFF` skips the restart. It does not.
3. **The restart at `0x6B7DC` is a link-loss timeout, not a command.** It fires when the
   frame-activity counter `0xFF959E` reaches 0 in mode `0x01` [B `0x6B7B8`–`0x6B7E2`].
4. **No NAK byte is ever sent.** A bad EOT or checksum only sets `0xFFB3D2.1`
   [B `0x6B8E6`]. In the session phase the frame is dropped. In the data phase the
   session falls back to the `V` gate [B `0x6BA46` → `0x6BAAE` `jsr sub_6B700`].
5. **There is a letter doc 04 missed:** outbound **`G`** (`0x47`) is built by `sub_6C05C`
   [B `0x6C096`]. `H` is built by `sub_6C19A`, not `sub_6C05C`.
6. **The length field is not bounds-checked. This is a RAM overrun** (§6, first item).

## 1. How the port gets into this mode

| Item | Value | Tag |
| --- | --- | --- |
| Port | SCI-A, SMR `0xFFFE90`, BRR `+1`, SCR `+2`, TDR `+3`, SSR `+4`, RDR `+5` | [B `0x45186`] |
| Mode byte | `0xFF8DDE`: `0x00` = plain COM port, `0x01` = node mode A, `0xFF` = node mode B | [B `0x10556`/`0x1054A`] |
| Mode entry | Held keypad codes at power-on (table `0x10216` → pointers `0x10242`, read by `sub_100E4`, skipped after a software restart because of `0xFF816F`). Code `0x37` toggles 0↔`0x01` (`sub_10556`). Code `0x67` toggles 0↔`0xFF` (`sub_1054A`). Which physical keys these are is not in the image. | [B table] / [I power-on] |
| Persistence | `0xFF8DDE` lies in the region that is cleared and then reloaded from settings at every boot (`sub_DD22` → `sub_DD5C`), so the mode survives a power cycle | [I] |
| Which mode is PDN | Doc 14 labels mode B (`0xFF`) as PDN. In mode A, `M` really retunes the radio and a link timeout restarts MAIN (behaviour that fits an HRI-200 node radio). | [I] |
| Baud / format | **38400 bps, 8N1**, fixed in node mode (BRR `0x0C` at φ = 16 MHz, SMR `0x00`) | [B `0x45206`] |
| Plain-mode baud | 4800/9600/19200/38400 from table `0x452C2`, indexed by `0xFF8C27` (COM PORT SPEED menu). Plain mode carries NMEA/waypoint text (doc 14), not this protocol. | [B `0x4519C`] |

Other power-on codes in the same table put SCI-A into a **transparent bridge to SCI-B**
(an on-board module) at 38400 (`0x5F` → `sub_10506` → `sub_734C2`) or 19200
(`0x77` → `sub_73540`) [B]. That is a different interface, and a PC tool must not drive it (§6).

**Plain-mode anomaly (unresolved).** The main loop calls `sub_6B74E` →
`jsr @0xFFB3C6` in every mode [B `0x2FEA`, `0x38A4`, …]. `0xFFB3C6` is zeroed at every
boot (`sub_DD22` clears `0xFF8188`–`0xFFBE75`) and is written only by `sub_6B700` and
`sub_6B73A`, which run only in node mode. A raw byte search finds no other writer. So in
plain mode the handler pointer should be 0. Either a writer is missing from this analysis,
or that call lands in the vector table. Either way, **treat the framed API as available
only in node mode.**

## 2. Frame format — byte-confirmed

```
[0]        0x01                 SOH  (any 0x01 byte restarts assembly)   [B 0x6B834]
[1]        letter               ASCII command                            [B 0x6BAD6]
[2..5]     4 ASCII hex          N = payload length, big-endian nibbles   [B sub_6CB5E]
[6..5+N]   payload              N bytes, printable ASCII by convention
[6+N]      0x04                 EOT; must sit at total-3                 [B 0x6B8A8]
[7+N,8+N]  2 ASCII hex          CC = (sum of bytes [0]..[6+N]) & 0xFF    [B 0x6B874/0x6B8B8/0x6B8CE]
total      N + 9 bytes
```

- Hex decode (`sub_6CB40`): a char `< 'A'` gives `c & 0x0F`, otherwise `(c + 0xC9) & 0x0F`.
  Upper and lower case both decode, and so does any other character, silently. The radio
  sends upper case (`sub_6CC04`).
- The radio's replies use the same format. The finalizer `0x6CC76` sums SOH..EOT, appends
  CC, and sends `framelen + 2` bytes by DMAC channel 2 from the fixed address `0xFEE000`
  [B `0x6B92E`–`0x6B97E`].
- **No echo.** The RX ISR `0x45462` only stores bytes into ring `0xFF27C8`–`0xFF29C7`
  (512 B). Bytes leave the radio only through the DMA reply path.
- RX errors (SSR `0x38`) are cleared and the byte is discarded [B `0x454C6`]. The RX ring
  wraps with **no overrun check** [B `0x45482`–`0x45498`].
- The assembler drains **at most 8 bytes per main-loop pass** [B `0x6B80A`]. The pass rate
  is unknown, so it is also unknown how much sustained 38400 input the 512-byte ring can
  absorb [I].
- Frame buffer: `0xFF1AC8`, which overlays the SCI-B RX ring `0xFF1AC8`–`0xFF23C7`
  (SCI-B wraps at `0xFF23C8` [B `0x4553C`]). Usable size 2304 B, so **N ≤ 2295 (`0x08F7`)** [I].

Example frames (checksums computed):

```
V  01 56 30 30 30 30 04 31 42          "\x01V0000\x04" "1B"
B  01 42 30 30 30 31 30 04 33 38       "\x01B0001" "0" "\x04" "38"
C  01 43 30 30 30 30 04 30 38          "\x01C0000\x04" "08"
N  01 4E 30 30 30 30 04 31 33          "\x01N0000\x04" "13"
```

## 3. Session state machine — byte-confirmed

The handler is a coroutine: `sub_6BA3A` pops its return address into `0xFFB3C6`, so each
main-loop pass resumes where the last one stopped.

1. **Gate** (`sub_6B9AC`, entered from `sub_6B700`). Frames other than `V` are ignored.
   On `V`, the radio replies with the 57-byte ident frame and waits for the DMA to finish.
2. After that, **`V` repeats the ident**. **`M` is processed and echoed.** When the echo
   has gone out, the radio sets `0xFFB3D7.0` (queue a `P`) and switches to the data phase
   (`sub_6B73A`, `0xFFB3E0 = 1`).
3. **Data phase** (`sub_6BA46`):
   - Each good frame is dispatched by `sub_6BAC8`. Unknown letters get no reply.
   - A bad frame drops the session back to step 1.
   - When nothing arrives, the radio sends frames on its own, in this priority order:
     `P` on a status change (`sub_6BB4C`), `R` (`0xFFB3D7.6`), `H` (bit 7), `G` (bit 2),
     then the mode-B position state machine (`0xFFB3E4`, jump table `0x6BD26`: `B` → state 1 …
     state 3 sends `W`, and the PC acks with `W` payload `'0'` → state 4).
   - The PC must be ready to receive these at any time.

**Timeouts** [B for the logic, I for the time unit]. Every good frame reloads
`0xFF959E = 100` [B `0x6B8DA`]. This counter sits in the slow timer array
`0xFF958E`–`0xFF95B1`, which `sub_3576` decrements once every 10 base ticks. A base tick
is 2 × the vector-110 TPU interrupt (TCR `0x21` = φ/4, TGRA `0x4E20` → 5 ms), so about
**100 ms per count**:

| Condition (data phase) | Result | Site |
| --- | --- | --- |
| Transmitting (`0xFF94C0 == 1`) and counter < 59 (about 4.1 s with no good frame) | TX stopped (`sub_22718`), link-lost flag `0xFFB3D5.1` | `0x6B7C0` |
| Mode A, not transmitting, counter reaches 0 (about 10 s) | **MAIN restarts** (`jsr sub_2648; jmp 0x2050`) | `0x6B7B8`→`0x6B7DC` |
| Mode B, counter < 50 (about 5 s) | session reset to the gate (no restart) | `0x6B7E6`→`0x6B7EE` |

**So a PC program must send a valid frame at least every ~3 s once past `M`** (a `C` poll
is harmless), or it must deliberately let the session lapse.

## 4. Commands

Payload index `p` = frame index − 6. Full byte layouts are in the TSV. Summary:

| Letter | Phase | What it does | Reply | Writes RAM? |
| --- | --- | --- | --- | --- |
| `V` | gate | identify | 57 B: `"FT3D"`, destination `"EXP"`, version-like fields, `"20180418"`, 5-char radio ID from `0xFF8060`, `"0C01"`/`"0C03"` [B `0x6BD3E`] | staging only |
| `M` | gate | set node parameters, then the echo opens the data phase | 78 B echo | **yes, mode A only** (below) |
| `V` | data | **restart MAIN** | none | — |
| `C` | data | status + radio ID | 20 B `C000B` | no |
| `B` | data | ack; in mode B it starts the position exchange (`loc_1CA72`) | 10 B | state only |
| `N` | data | two CR-terminated strings (≤ 96 B each) from `0xFF9C64`/`0xFF9CC6` (GPS NMEA [I]); fallback `N0001 0` | variable | no |
| `E` | data | queue a 45/65/90-byte block (type `0`/`2`/`3`) into 4-slot ring `0xFEE944` | `E0001 0`, or deferred when the ring is full | bounded: slot `&3`, fixed length, end ≤ `0xFEEAAB` |
| `F` | data | load a 60-byte header + ≤ `0x40C`-byte hex body for transmission | `F0001 0`/`1` | bounded: `0xFF0BF4`–`0xFF1044` |
| `S` | data | `p0&1`: **1 = key TX and send the loaded data**, 0 = stop TX | `S0001 0`/`1` | radio state |
| `W` | data | ack of the radio's position report | none | state only |
| `P` `H` `R` `G` `W` | out | status / heard station / RX block / RX message / position | — | — |

**`M` payload** [B `sub_25EAE`]. Every field accepts `'F'` for "no change".

- **Frequency** `p3..p12`, written as `"0DDD.DDDxx"`: `p3` must be `'0'`, `p4–6` are MHz,
  `p7` is `'.'`, `p8` is the 100 kHz digit, and `p9–10` index the kHz/step tables
  `0x25BE2`/`0x25CAA`. `p11–12` are not read. The value is checked by `sub_3F522`.
- **Shift** `p13` = `'+'`/`'-'`, **offset** `p14–22` = `"DDD.DDDDD"`.
- `p23` = flag (VFO+0x12 bit 5); `p24` = `'1'`–`'3'` (VFO+0x16).
- **CTCSS** `p25–27` = integer Hz (`"088"` for 88.5).
- **DCS** `p28–30` = octal code (`"023"`).
- `p33` → `0xFFB3D3`; `p34–35` = hex < `0x80` → `0xFFB3D4` → `0xFFB131`/`0xFFB130`.
- `p36` = `'0'`–`'3'` → VFO+0x13.

The writes go to the current band's VFO struct (`@0xFF812A`) and are applied by
`sub_25D72`. They happen **only in mode A**: in mode B the parser is `sub_2611A`, which
changes no VFO settings (only `0xFFB12F`–`0xFFB131` are refreshed from the stale `0xFFB3D4`). If the check fails, `0xFFB3D5.2` is set and the echo is still sent.
Nothing in this path writes the EEPROM. Whether the new VFO values are later saved by the
radio's normal settings save is **unknown** [I: likely, because they live in the settings
RAM image].

## 5. Reads and writes, with their bounds

- **Reads** come only from fixed addresses: the template `0x6C538`, `0xFF8060` (5 B),
  `0xFFB05B` (6 B), `0xFF9C64`/`0xFF9CC6` (≤ 96 B each), `0xFEEB14` (20 B), `0xFEE944`
  (45/65/90 B), `0xFEFD72`… The host never supplies an address. The `R` sequence number
  `0xFFB3D0` is radio-side and is only echoed. DMA always starts at `0xFEE000`.
- **Writes** are bounded and fixed:
  - `M`: VFO fields and the `0xFFB3xx` vars.
  - `E`: `0xFEE944`–`0xFEEAAB` and `0xFEEAAC`–`0xFEEAB7`.
  - `F`: `0xFF0BF4`–`0xFF1044`.
  - Protocol state bytes `0xFFB3C4`–`0xFFB3EA`.
  - Staging buffer `0xFEE000`–`~0xFEE0C4`.
- **The one unbounded write** is the frame assembler itself (§6, first item).
- As doc 04 established: no arbitrary R/W, no EEPROM or flash write, no loader.

## 6. What a PC program must NOT send

1. **A length field over `0x08F7`, or any length you do not then deliver exactly.**
   `0x6B844` stores byte *n* at `0xFF1AC8 + n` with a 16-bit *n* and **no limit**. A header
   such as `01 x FFFF` followed by data would overwrite the SCI-B ring, then `0xFF23C8`+,
   and eventually all RAM up to the I/O page. **This is active in every mode**, because the
   assembler runs even when no handler is installed. Always compute N from the actual
   payload. Never put `0x01` inside a frame.
2. **`S` with payload `'1'`**, unless you intend to transmit on air under your licence with
   the antenna and frequency checked. It keys the TX (`sub_2244C` sets `0xFF94C0 = 1`).
   `E` and `F` load data that `S`/the node logic will transmit. Treat all three as TX commands.
3. **`V` after the session is open.** It restarts MAIN without warning or reply.
4. **`M` with fields you have not validated.** In mode A it retunes the live radio (including
   repeater shift and tone). Send `'F'` for every field you do not mean to change. The echo
   status (`0xFFB3D5.2` is not visible on the wire) is not a reliable success flag.
   Read back with `C` or on the radio's display.
5. **Idling longer than ~10 s in mode A after `M`**, unless a restart is acceptable.
6. **Anything while the radio is in a SCI-A↔SCI-B bridge mode** (power-on codes `0x5F`/`0x77`).
   The bytes go raw to an unidentified on-board module.
7. **Framed traffic in plain COM mode.** Behaviour there is unverified (§1 anomaly).
8. **Unknown letters.** They are ignored today, but they tie up the 8-bytes-per-pass assembler.

## 7. Minimal safe PC-program recipe (receive-only / identify)

1. The user enables node mode on the radio (power-on key hold; the manual's "PDN" procedure [I]).
2. Open the port at **38400 8N1**, no flow control. Use Yaesu's DATA-jack PC cable (e.g. SCU-39) [I].
3. Send `V` (`\x01V0000\x041B`). Parse the 57-byte ident: model, destination, radio ID.
4. To go further without retuning, send `M` with 69 payload bytes, all `'F'` except
   `p0–2 = "200"` [I]. That opens the data phase. In mode B, `M` changes no VFO settings anyway.
5. Poll with `C` every 1–2 s. Consume the unsolicited `P`/`H`/`R`/`G`/`W` frames.
   Answer a radio `W` with `W0001 0`. Use `N` for GPS text.
6. To close, stop polling. Mode B returns to the gate after about 5 s. **Mode A restarts
   after about 10 s.**

## 8. Unknowns, most valuable first

1. The plain-mode `jsr @0xFFB3C6` with a zero pointer (§1). Either there is a missing
   writer, or the plain-mode behaviour is odd.
2. The physical keys behind codes `0x37`/`0x67` (and `0x5F`/`0x77`). This needs hardware
   or the manual.
3. Semantics of `M` fields `p23`/`p24`/`p33`/`p34–35`/`p36` and of the frequency index
   tables `0x25BE2`/`0x25CAA`. The next step is to decode `sub_25D72` and `sub_3F522`.
4. The `C`/`P` status characters (`sub_6BB6E`), the `H` header bits (`sub_6C10A`), and the
   mode-B position state machine (`0x6BD26`, `loc_261FA`, `loc_1CA72`).
5. Main-loop pass rate, and therefore how much sustained 38400 input the 512-byte ring and
   the 8-byte-per-pass drain can absorb.
6. Whether mode-A `M` changes are later saved to the EEPROM by the normal settings save.
