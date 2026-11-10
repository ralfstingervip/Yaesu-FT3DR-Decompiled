# Lane main-038CB4-03F1C4: notes

The chunk holds 286 MAIN functions in 0x038CB4 to 0x03F1C4. Every function has a header and a C body in
`main-038CB4-03F1C4.c`. Most of the repeated EEPROM wrappers are written as one-liners. In the TSV the
counts are 277 Confirmed and 9 Inferred, with no Skeleton. The Inferred entries are the meaning of the
charge/standby loop, the RTC routines and the message compare. Their control flow was traced fully.

## Subsystems in the range

| Range | Subsystem |
| --- | --- |
| 038CB4-039030 | DTMF sender. A 20-slot ring at FFAC0E feeds TPU1 tone synthesis (doc 120 §6). In digital modes it also posts DSP mailbox FFB0C0. |
| 039120-0394B2 | Audio-route state machine handlers, states 0-8 (doc 73). `sub_391C0` computes USB EP3 byte 0 (FF8184). |
| 0394B4-03A120 | EEPROM block wrappers: marker, region, cal image, R1, plus the **mirrored VFO blocks** (see below). |
| 03A120-03AB80 | Memory store accessors: channel records, attribute bytes, name blocks, per-band VFO records, operating-record slots, band-plan lookup. |
| 03AB80-03CCBC | Bit-banged I2C drivers for EEPROM device A0 (0x00000-0x0FFFF) and A2 (0x10000-0x1FFFF). |
| 03CCBC-03DF86 | Settings R1/R2/R3 writers, DTMF memories (EEPROM 0xA80), **special memory areas** (`mem_rec_alt`), device-A2 stores (messages, groups, Bluetooth list, picture state) and the DG-ID word cache. |
| 03DF86-03E354 | S-meter quantiser and redraw (doc 137). |
| 03E354-03E728 | UI housekeeping timers, blinkers, lamp timer. |
| 03E728-03E9F8 | **3-wire RTC** driver (see below). |
| 03E9F8-03EC50 | Radio-off charge/standby loop and low-power module stop. |
| 03ECB8-03F1C4 | Market predicates (doc 59), calibration-byte pointers (doc 137), tone-class lookups (doc 120), memory-slot stepping and attribute checks. |

## Findings

1. **Mirrored VFO blocks with checksums.** Four RAM blocks are stored twice in EEPROM. Each copy ends in
   a byte-sum checksum: FF8EA0 at 0x700/0x740, FF8EE0 at 0x780/0x800, FF8FE8 at 0x880/0x900, and FF90F0 at
   0x980/0xA00.
   - On load, a good backup repairs a differing primary. FFBCAA flags a bad backup.
   - The shadows at FFBCB6.. hold the last saved image. The NMI handler calls `sub_39BA0`, which writes
     only the changed blocks to their backup copies. This is the power-fail save.
   - The NMI path also saves FF8002 to EEPROM 0xFFFE.
2. **Special memory areas (`sub_3CEFE`, table 0x3CF34).** When record byte +6 is non-zero, the memory
   area (+0x10/+0x11) chooses a synthesiser instead of the regular channel store at 0x2E80. It builds a
   full operating record from ROM tables (0x3FFF4, 0x4001C, 0x40362, 0x40480, 0x40B74, 0x415BA, 0x401BE,
   0x4020E), from EEPROM tone tables (0xBC00 and 0xBBC0) and from computed grids:
   - area 9 starts at 322.025 MHz in 25 kHz steps;
   - the dead case starts at 779.125, 797.125 or 806.125 MHz. Its step is 0x30D4 = 12500 units of 10 Hz,
     which is 125 kHz, not the 12.5 kHz that doc 115 gives (BCD scale checked via `sub_3F986`).
   - A market-dependent range table (0x221A8 or 0x221F6) decides whether the synthesised record goes to
     band A or band B.
   - Areas 0, 1 and 2 would return through a pushed er3 if they were ever dispatched. They are unreachable
     in practice (Inferred).
3. **3-wire RTC, not a PLL.** `sub_3E864`/`sub_3E90A` clock a command byte 0x6n MSB-first, then data
   LSB-first. The pins are FFFF5A.b1 for clock, FFFF5D.b4 for data out, FFFF5D.b5 for chip enable and
   FFFF4D.b4 for data in.
   - The commands used are 0x60/0x61 (status 1), 0x62/0x63 (status 2), 0x64/0x65 (time) and 0x68 (INT1
     alarm). Status-1 bits 0xC0 trigger re-initialisation.
   - This fits a Seiko S-35190A-style RTC (Inferred).
   - It **contradicts doc 12**, which calls `sub_3E864` a 3-wire PLL programmer. It also contradicts doc 12
     citing 0x3E878/0x3E8B0/0x3E91E as readers of the blocked-band table: those addresses are nops and
     port moves.
   - FFFF45.b3 falling edges (INT1) drive a timer check in `sub_3E354`. If 89C1.b7 is set and the time
     equals FF898A, it disables interrupts and jumps to 0x25AC (Inferred: OFF timer). If 89C2.b6 is set
     and the minute is 0, it posts tone event 0x43.
4. **DG-ID words are per band.** `sub_3DEA8`/`sub_3DF2E` choose FF8ED6 or FF8ED8 by the A/B edit side
   (817E.b0). Doc 82 reads the pair as RX/TX selected by 8EA0.b6. Each word is more likely a two-byte pair
   per band (Inferred correction).
5. **Doc 73 Open #1 decoded.** The per-band RX predicate in `sub_391C0` is decoded in full in the C,
   including the dual-receive path (FF8EA6) and the node-mode path.
6. **Smaller points.**
   - `sub_3D6B0` saves 0x31 bytes, so R3 n = 0x7E..0xAE. Doc 32 says 0x7E..0xAF.
   - EEPROM 0x1C000 is read with two lengths into two RAM buffers: 0x110 bytes to FFB4A8 and 0x180 bytes to
     FF4576.
   - `sub_3EC50` writes MSTPCRA/B/C (FFFDC8/CA/CC) after it tears down USB.

## EEPROM map additions (device A0 unless noted)

| Address | Contents |
| --- | --- |
| 0x0180 / 0x0380 + 0x3A·k | band operating records, sides A and B |
| 0x0A80 + 16n | DTMF memories |
| 0x0F80 + 0x12n | area-3 names |
| 0x1034 + 0x12n | 18-byte records |
| 0x1200 + 0x20n | 0x1200 record set |
| 0x1380 / 0x1500 + 0x20b | per-band VFO records |
| 0xB800 + 8n | 8-byte records |
| 0xB8C0 + 0x12n | 18-byte records |
| 0xBBC0, 0xBC00 | area tone tables |
| 0xC280 / 0xC3A0 / 0xC4D0 / 0xD280 | records of 0x1C / 0x3C / 0x43 / 0x5D bytes |
| 0xE000 + 0x1En | typed 30-byte records |

Device A2:

| Address | Contents |
| --- | --- |
| 0x10010 | marker |
| 0x10100 + 0x20n, 0x10880 + 0xB0n | message store A |
| 0x131C0 + 0x20n, 0x13940 + 0x90n | message store B |
| 0x1A000 / 0x1A080 | DG-ID cache |
| 0x1B000 | group names |
| 0x1B0A0 | group items |
| 0x1B200, 0x1B300 | 0x90-byte blocks |
| 0x1C000 | see the double-length note above |
| 0x1C110 + 0x168n | 24×15-byte tables |
| 0x1D8F8 + 0x50n | 0x50-byte records |
| 0x1E000, 0x1E050 + 0x1E0n | blocks / records |
| 0x1EA00 | Bluetooth list |
| 0x1FA00 | picture state |

## Not done

- The meanings of the many record stores at 0xB800-0xE000 and in device A2 are not resolved, except
  where a doc names them. The C gives their addresses only.
- Which preset lists the special areas are (weather, marine and so on). The ROM tables were not dumped.
- The charge loop's A/D scale (`sub_3466`) and the exact meaning of FF9590.
- In `sub_3E354`, most of the timers and popup flags are given by address only.
- Gaps between functions are not in the chunk: the DTMF table and audio-SM prologue at 039040, the I2C
  retry stubs at 03B0E4 and 03C310, 03ECF4-03EDAA, and 03F04A.
