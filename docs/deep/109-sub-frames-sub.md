# 109 — SUB-side producers of SUB→MAIN frames: builders, transmit path and the full type census (Lane L12)

> Lane L12, model `claude-opus-5-5`. Private DB `L12_SUBFRAMES_SUB` (`--copy-from
> ida\db\jobs\K7_SUB_FINAL3\K7_SUB_FINAL3.i64`), iterated with `--reopen`. Jobs:
> `ida\jobs\l12_dump.py` (copy of `k2_dump.py` plus a call-context dump),
> `ida\jobs\l12_tree.py` (caller trees plus the strings each function references) and
> `ida\jobs\l12_refscan.py` (copy of `k2_refscan.py`). All three are read-only apart from IDA's
> own state. Each one writes a traceback file on exception and ends with `qexit(0)`. No shared
> DB was opened. `decrypted\*.bin` was read by Python only and not modified. Nothing was
> connected to a radio. Tables are in `ida\out\sub-frames-sub\`. SUB is RX64M little-endian,
> file offset = address − `0xFFC00000`. RX `75 4x`/`3C`–`3E` imm8 operands are read as
> unsigned (IDA prints `75 41 e0` as `#-20h` and `3d 10 90` as `#-70h`).

## Verdict

**Ten SUB→MAIN frame types exist, built by five builders.** The types are `E0`, `E1`, `E2`, `E3`,
`E4`, `E5`, `E6`, `EA`, `FE` and `FF`. Every frame goes out on **SCI0** (channel 0 of the generic
SCI driver) through one ring writer `sub_FFEDAF2D` and the TXI0 ISR (vector 59, `FFEDB857`).

**Census and coverage.**
- A raw scan of the whole image for `bsr`/`bra` (`05`/`04`/`39`/`38`) and 32-bit pointers into the
  builders and wrappers gives exactly the IDA cross-references:
  - 81 builder call sites;
  - 101 type-level build sites (`build-sites.tsv`).
- No other code touches SCI0's TDR. All 36 `0x08A000`/`0x08A002` immediates lie in the SCI0 driver
  `FFEDB3DC`–`FFEDB8E8`, and `0x08A003` never appears as an immediate.
- No type other than these ten is ever built. The MAIN start-byte switch (doc 84) accepts exactly
  these ten.

**Meaning of each type.**
- `E0`: touch. Already known from K2.
- `E1`: GPS NMEA relay, `$GPGGA`/`$GPRMC` only.
- `E2`: link and block-transfer error status.
- `E3`: acknowledgement.
- `E4`/`E5`/`E6`: Bluetooth-unit status.
- `EA`: voice play/record status, `.wav` on SD.
- `FE`: SD-card file-operation result or card event.
- `FF`: image-block read-back.

**Types whose content comes from an external interface:**
- `E1` carries GPS-module bytes verbatim. The GPS is on SCI2.
- `FE` carries up to 0x400 bytes of SD file-operation data (commands 0x0A–0x10), or 10 bytes of
  card information (command 0x6E).
- `E4` code 0x12 carries a device name and address reported by the Bluetooth module on SCI3.
- `E0` is ADC-derived.
- `FF` echoes image bytes that MAIN pushed.
- **No type carries anything from USB.** USB0 stays dark, and no builder input traces to it.

**Net proven/named byte delta: 0.** All 30,973 bytes of the 81 functions analysed are already
set in `mask_final2_headline_w2.bin`. One typed-data proposal follows: 260 bytes of Bluetooth
format strings.

## Method

1. **Builders and the transmit path.** I dumped the K2 transmitter `sub_FFEDD182` and its callee
   `sub_FFEDAF2D`, and listed every caller of both (`d1.txt`). The callers of `sub_FFEDAF2D` gave
   four more builders (`sub_FFEDD355`, `sub_FFEDD528`, `sub_FFEDD6FB` and `sub_FFEDD8DC`) and two
   non-MAIN senders:
   - `sub_FFEE0FA3`, channel 1;
   - `sub_FFF3B630`, channel 2.
2. **Call sites and arguments.** For every call site I dumped the 14–18 instructions before the
   `bsr` to read the type, `b1`, the buffer and `n` (`d2.txt`).
3. **Callers and triggers.** Caller trees ran to depth 7 for all builders and wrappers (`t1.txt`,
   `t3.txt`). I dumped the producers:
   - GPS (`dA.txt`);
   - Bluetooth (`dB.txt`, `d3.txt`);
   - voice (`dC.txt`);
   - SD (`dD.txt`, `d5.txt`, `d6_fe.txt`);
   - the dispatcher tail `FFEDCE15`–`FFEDD0C7`;
   - the picture-step senders (`d8.txt`).
4. **Operand scans** over all code heads `FFC00000`–`FFFFFFFF` (`refs1/2/3.tsv`) for:
   - the payload and TX buffers;
   - the echo cells `0x84C8`/`0x84C9`;
   - the Bluetooth name/address buffers;
   - the GPS cells;
   - the SD queue `0x683D0`/`0x684F0`;
   - the header struct `0x12534`/`0x12546`/`0x12558`.
5. **Python scans of the image.** I ran a raw call/pointer scan over all 4 MB, and an SCI0 24-bit
   immediate scan. I also read the INTB slots 58/59/62/63/110 and checked the string pools at
   `FFF4AD00`–`FFF4B080` and `FFC3EB56`.

**Not done.**
- I did not decode the MAIN-side handlers; that is L11's lane.
- I did not decode the full Bluetooth wire protocol of SCI3. The `sub_FFF3A*` response parser was
  read only through its strings.
- I did not trace the SD driver below `sub_FFF12E8B`/`sub_FFF12F9B`/`sub_FFF12B18`.

## Findings

### 1. Frame format and the five builders (Confirmed; `builders.tsv`)

**Four of the five builders use the K2 format.** They are `sub_FFEDD182`, `sub_FFEDD355`,
`sub_FFEDD528` and `sub_FFEDD6FB`, all with arguments `(type, b1, [ptr,] n)`. Each has its own TX
buffer at `0x12D44+disp`:

| builder | disp | buffer |
| --- | --- | --- |
| `sub_FFEDD182` | `0x85F6` | `0x1B33A` |
| `sub_FFEDD355` | `0x8DF6` | `0x1BB3A` |
| `sub_FFEDD528` | `0x95F6` | `0x2433A` |
| `sub_FFEDD6FB` | `0x9676` | `0x243BA` |

```c
/* sub_FFEDD182 / FFEDD355 / FFEDD528 / FFEDD6FB — identical bodies, different buffers */
f[0]=type; f[1]=b1; f[2..3]=BE(n+9); f[4..5]=BE(f0+f1+f2+f3);
f[6]=0x01; f[7]=0x02; f[8]=0x00;            /* FFEDD206 fa e4 fc 85 01, …fd 85 02, …fe 85 00 */
f[9]=echo_hi[0x1B20C]; f[10]=echo_lo[0x1B20D];   /* FFEDD227 ca ee c8 84 ff 85 */
memcpy(&f[11], payload, n);                  /* FFEDD182: payload pre-staged at 0x1B20E (disp 0x84CA) */
f[11+n..12+n]=BE(sum f[0..10+n]);            /* 16-bit additive */
f[13+n..18+n]=0;                             /* six pad bytes, FFEDD2CC..FFEDD335 */
sci_tx(0 /*ch0*/, f, n+19);                  /* FFEDD34D 66 01; FFEDD34F 05 de db ff */
```

**Total length.** The frame length is `n+13`, which equals the length field plus 4. This is the same
rule as the MAIN→SUB deframer in doc 51.

**`FE` uses its own builder, `sub_FFEDD8DC`.** Its layout is different (§7):
- no `01 02 00` constants;
- the echo sits at `[6..7]`;
- the length field is `A.w0+6`.

**Re-entrancy guard.** `sub_FFEDD6FB` (`EA`) and `sub_FFEDD8DC` (`FE`) clear ICU IER10 bit 7
(`0x87210`) around the enqueue and set it again afterwards:
- clear: `FFEDD8B9 fb ee 10 72 08`, `FFEDD8BE f0 ef`;
- set: `FFEDD8D8 f0 e7`;
- same pair in `FFEDDEB2`…

IER10 bit 7 is vector 135, the TPU0 tick, so this masks the tick ISR. That ISR runs the other three
builders: touch, GPS and the link layer all hang off `sub_FFF36CAB`. Both rings share the
channel-0 descriptor (Inferred purpose: re-entrancy guard).

**Transmit path (Confirmed).**
- `sub_FFEDAF2D(ch, src, len)` writes into the ring of descriptor `0x12CD8+ch·0x18` (`FFEDAF44 75 11
  18`). On a full ring it calls the channel kick and retries, which is a busy-wait.
- The channel-0 kick `sub_FFEDB761` fetches one byte through the callback at `[0x12D20]`. It writes
  that byte to TDR `0x8A003` (`FFEDB7A0 c5 0e 03 01` on base `0x8A002`), then sets SCR.TIE and
  SCR.TEIE (`f0 e7`, `f0 e2`).
- TXI0 is INTB slot 59 (`FFED8B5C` = `57 b8 ed ff`) → `FFEDB857`. It refills TDR the same way and
  clears TIE when the ring is empty (`FFEDB89B f0 1f`). RXI0 is slot 58 → `FFEDB7E7`.

**Channels.**

| channel | SCI | base | role | evidence |
| --- | --- | --- | --- | --- |
| ch0 | SCI0 | `0x8A000` | MAIN link, to MAIN SCI-D (K2/doc 09) | — |
| ch1 | SCI2 | `0x8A040` | GPS receiver | `sub_FFEE0FA3` builds `$PMTK…*hh\r\n` with an XOR checksum; strings `$PMTK103`/`$PMTK102` at `FFC00112`/`FFC0011B`; RXI2/TXI2 slots 62/63 |
| ch2 | SCI3 | `0x8A060` | Bluetooth unit | `sub_FFF3B630` vsprintf-sends `SCAN=%d\r\n`, `SCOL=1\r\n`, `LINK=…`, `PAIR=…`, `FIND=…`, `PINF=…` from `FFF4AEB5`–`FFF4AFB8` |

**The echo (Confirmed by operand scan).** Bytes `[9..10]` hold the echo. It has exactly two writers:
- dequeue `FFEDC292`/`FFEDC2A6` (`mov.b 8016h[r1],84C8h[r14]`);
- the ack branch `FFEDCECD`/`FFEDCED8`.

Every frame therefore carries the opcode of the last MAIN frame dequeued or acknowledged.

### 2. `E0` — touch (Confirmed; unchanged from K2)

| field | value |
| --- | --- |
| site | one, `FFEE1779` → `sub_FFEDC3BD` |
| `b1` | pen |
| payload | `pen`, `X` (BE16), `Y` (BE16); `n=5`, total 18 bytes |
| X/Y source | S12AD1 ADC |

`FFEDC41F 66 53`, `FFEDC421 75 41 e0`. Called from the TPU0 tick.

### 3. `E1` — GPS NMEA relay (Confirmed; external content)

**Path.** Tick ISR → `sub_FFEDFA70` → `sub_FFEDFEB9`. When a complete sentence is buffered
(`[0x1CDD0]==3`), the classifier `sub_FFEE0191` matches buffer `0x8B96` bytes 3–5:

| class | sentence | evidence |
| --- | --- | --- |
| 1 | `RMC` | `FFEE0232 75 51 52`, `75 51 4d`, `75 51 43` |
| 2 | `GGA` | — |
| 3 | `GSA` | — |
| 4 | `VTG` | — |
| 5 | `GSV` (Inferred) | — |
| 6 | `$PMTK` reply | — |

**What is forwarded.** Classes 1–4 call `sub_FFEDC2E1(0x8A93, [0x124C0])`.
- Classes 1 and 2 are also parsed into `0x1CD9C`/`0x1CDB8`.
- The wrapper sends `E1` with `b1=0` and the raw sentence bytes, `n≤0x12B` (`FFEDC2E9 76 01 2b 01`).
- It sends only when `[0x8A86]==0` and sentence byte 4 is `'G'` or `'M'` (`FFEDC32E 75 5e 47`,
  `FFEDC33D 75 5e 4d`). So only `$GPGGA` and `$GPRMC` reach MAIN. GSA and VTG are dropped.

**Content.** The bytes are verbatim GPS-module output from SCI2. That is an external interface.

**The `0x8A86` gate.**
- It is set to 1 only in the dispatcher, `FFEDCE8F`. The condition is opcode `F301` or
  `F3C0`/`F3C1` with frame byte `+0x13==3`.
- That same branch reprograms TPU3 through `sub_FFF36B9D`: TCR=6, TGRA=`0xB71A` (`FFF36BE2 f9 e9 04
  1a b7`).
- `sub_FFF36B1E` restores TCR=2, TGRA=`0x1D4B` and clears the gate (`FFEDCEB3`).
- Meaning of that mode: Unknown (Inferred: a low-rate/power-save state).

**GPS log, same wrapper.**
- When `[0x10C65]==1`, `GGA`…`VTG` sentences go to `sub_FFF14F8A`. This is Inferred to be the SD
  `FT3D\GPSLOG` writer.
- `0x10C65` is set by the SD task (`FFF3FCB9`).

### 4. `E2` — link and block-transfer status (Confirmed)

**Wrapper.** `sub_FFEDC493(status)` zeroes the block counters `0x1CC3C`/`0x1CC40`/`0x1CC44`. It then
sends `n=2` with the status word in big-endian order.

| site | function | status | condition |
| --- | --- | --- | --- |
| `FFEDC74F` | `sub_FFEDC615` | `FFF1` | length > 0x7FFF, opcode hi `FF` |
| `FFEDC835` | `sub_FFEDC615` | `FFF0` | header checksum mismatch, opcode hi `FF` |
| `FFEDC905` | `sub_FFEDC615` | **block number** (frame `+6..+7`) | frame checksum mismatch, opcode hi `FF` (`FFEDC8FE b2 a9`, `FFEDC902 55 21 0c`) |
| `FFEDCC2F` | `sub_FFEDC976` | `FFFE` | last `FFFF` block, 32-bit sum ≠ expected |
| `FFEDE4F1` | `sub_FFEDE480` (step table `FFED3F78`) | `FFFE` | picture step finds transfer state `[0x1CC4C]≤1` |
| `FFEDE578` | `sub_FFEDE523` (step `FFED3F7C`) | `FFFE` | JPEG decode `sub_FFEDE804`≠1 |
| `FFEDC48E` | `dead_FFEDC455` → `sub_FFEDD355` | word | dead (K7) |

**Correction to doc 51 (owning doc not edited).** On a frame-checksum error the payload is the
**block number**, not `0xFFFE`. `0xFFFE` is sent only for the 32-bit-sum and picture-step cases.

### 5. `E3` — acknowledgement (Confirmed)

**Wrapper.** `sub_FFEDC429` sends three zero bytes (`FFEDC44A 66 33`).

**Trigger.** `FFEDCEC2 f5 e6 0c`: any MAIN frame on the common-header path with bit 6 set in byte
`+7`. The echo is first set to that frame's opcode.

**Frames that never reach this test** (they return early):
- `FC00`, `FE00`, `FFxx`;
- `F3D5` (`FFEDCE47`).

### 6. `E4`/`E5`/`E6` — Bluetooth unit (Confirmed bytes; meanings Inferred)

**Builder.** All three use `sub_FFEDD528`.
- Payload buffer: `0x10369`.
- Callers: the MAIN `F3D2`/`F3D6` handlers `sub_FFF37D88`/`sub_FFF38107` (doc 43's table), and
  Bluetooth response callbacks registered with the SCI3 command senders (`dr_O` refs such as
  `FFF37E3A mov.l #sub_FFF38EFB`).
- Those callbacks run from the BT pump `sub_FFF3B69B`, which is in the tick fan-out (K2). That
  places them in tick context (Inferred).

**`E4`, 29 bytes, built by `sub_FFF389E7(code, name, addr)`:**

| bytes | content |
| --- | --- |
| `[0]` | `code` |
| `[1..16]` | name, `strlen`-limited, padded `0xFF` |
| `[17..28]` | 12-character address, padded `0xFF` |

Evidence: `FFF38A45 fb f6 ff`, `FFF38AE7 75 41 e4`.

**Where the code is stored.**
- codes 0–5 → `0x122A7`;
- `0x10`/`0x13` → `0x122A9`;
- 9 → `0x122AA` (`FFF38AAD`…`FFF38ADA`).

There is also one direct `E4` with code 3 at `FFF38C9E`.

**Name/address sources (operand scan, `refs1.tsv`).**
- `0x10358`/`0x1034B` are written only from MAIN `F3D2`/`F3D6` frame offsets `+0x22`/`+0x32`.
- `0x1033A`/`0x1032D` come from `F3D5` (doc 51).
- Code `0x12` (`FFF38B2F 75 41 12`) instead copies a 0x1C-byte entry of a `FIND` result list handed
  in by the BT parser. **That is external content from the Bluetooth module.**

**`E5`/`E6`.** Each is a 1-byte flag, 0 or 1.

| type | sites | tracks (mostly) |
| --- | --- | --- |
| `E5` | 7 | `0x12CBA` |
| `E6` | 8 | `0x12CBC` |

`E6`=1 is sent when the `SCOL=1\r\n` command (`sub_FFF39ABC`, callback `sub_FFF38EFB`) completes in
state 3 (`FFF38FB1`…`FFF38FD2`). On that basis `E6` is Inferred to be the SCO audio-link state.
`E5`'s exact link is Unknown.

**Closing open states.** Before re-linking, `F3D2` sub-op 2 (frame `+0x21==2`) and `F3D6` send `E6(0)` if `[0x12CBC]==2` and `E5(0)` if `[0x12CBA]==1` (`FFF37FAD`/`FFF37FE9`).

### 7. `FE` — SD file-operation results (Confirmed layout; command names Inferred; external content)

**Arguments.** `sub_FFEDD8DC(0xFE, 0, A, B)` takes two by-value structs:
- `A`: 18 bytes, a copy of `0x12558`;
- `B`: a 36-byte SD command record from queue `0x683D0` (stride 0x24) or batch list `0x684F0`.

**Frame layout.** Offsets come from `3D 04 xx` immediates read unsigned.

| bytes | content |
| --- | --- |
| `[2..3]` | `A.w0+6` |
| `[6..7]` | echo |
| `[8..15]` | `A.w0..w6` |
| `[16..18]`, `[20..21]` | `A.w8..w10` |
| `[24..29]` | `B.w0/w2/w4` |
| `[30..93]` | 64-byte path `*B.p8` |
| `[94..125]` | 32-byte name `*B.pC` |
| `[126..133]` | `B.l10`, `B.l14` |
| `[134..135]` | `B.w18` |
| `[136..137]` | `B.l1C` low 16 bits |
| `[138..151]` | zero |
| `[152..]` | `B.w18` bytes from `*B.p20` |
| after data | checksum, then 6 pad bytes |

**Header fields.**
- `A.w0` is the payload length: `0x90` (`3d 10 90`), or `0x90+w18` (`FFF3CF79 72 11 90 00`).
- `A.w8..w10` are year/month/day/hour/minute. They are copied from the `FC00` header `0x12534` via
  `0x12546`; `sub_FFF3BC97` loads them into a tm struct at `*0x65C14` (`+0x14` = `w8+100`).
- **Packing quirk (Confirmed code).** Each byte is `(tens<<4)|(v & 0x0F)` (`FFEDD9E7 64 f3`, then
  the tens table `FFC3EB56` = `{0,0},{1,10},…{9,90}`). True BCD results only for v<10. MAIN can
  still recover v because the tens digit is known. How MAIN decodes it is for L11.

**Triggers: the SD task `sub_FFF3FC53`, called from the main loop `sub_FFF36C9C`.**
- **Card inserted.** `sub_FFF3B8DE` creates `FT3D`, `FT3D\BACKUP`, `FT3D\GPSLOG`,
  `FT3D_MEMORY-CH`, `QSOLOG`, `PHOTO` and `VOICE`, then sends `B.w0=0xC8`, or `0xC9` if a mkdir
  failed.
- **Card removed.** `sub_FFF3BA5A` sends `0xCD`.
- **Every SD command record that MAIN queues in an `FC00` frame.** The path is `sub_FFF3BC97` →
  `sub_FFF3E4A7` → `0x683D0`. The executor is `sub_FFF3C4BC`, which dispatches on command codes
  0x0A–0x10, 0x12 (image file → `0x070E1000`), 0x14, 0x1E, 0x28, 0x32, 0x3C, 0x46, 0x50, 0x64,
  0x6E and 0x78, plus the state-1/4/5/6 continuations.

**Only two of the 30 sites carry data.** All others store `w18=0`.
- `FFF3CFBE` (commands 0x0A–0x10) copies `B.l10` bytes (buffer 0x400) of the file-operation buffer.
  On reads these are SD file bytes.
- `FFF3E386` (command 0x6E) sends 10 bytes of card/volume data from `sub_FFF12B18`.

### 8. `EA` — voice play/record status (Confirmed values; trigger names Inferred)

**Builder and payload.** `sub_FFEDD6FB`, buffer `0x11F66`, `n=1`. The status byte is one of
`0x00`, `0x01`, `0x02`, `0x10`, `0x11` or `0xA0` (error). Evidence:
- `FFF3E9DE fb f6 a0`;
- `FFF3F801 75 4f 10`;
- `FFF3F82C 75 4f 11`;
- `FFF3F90E 66 1f`;
- `FFF3F95B 66 2f`.

**Producers.**
- **MAIN `F640`** (`sub_FFF3E98C`): frame `+0x20` → play command `0x122B7`, and `+0x21..` → a
  filename of up to 15 characters, giving `I:\FT3D\VOICE\<name>.wav` (Inferred folder). It sends
  `A0` if the player is busy.
- **Common-header byte `+9` bits 3:2** (dispatcher `FFEDD02F`…`FFEDD0C3`):
  - 2 → `sub_FFF3F037`;
  - 1 → `sub_FFF3F0BA`;
  - 0 → `sub_FFF3EF94`.
- **The main-loop player `sub_FFF3EAE2`** (states 0–4 and 0x10), including a seek whose position
  comes from the **SUB-local touch seek bar** `sub_FFF375FB` (`FFF3EB60`). This is a SUB-only UI
  event that produces a SUB→MAIN frame.
- **SD-queue states 5/6** (`I:\RECBACKUP`).
- **Engine completion callbacks:**
  - `sub_FFF3F7CB` maps engine codes 1/5/2/−1 to `10`/`11`/`00`/`A0`;
  - `sub_FFF3F8A5` maps 2/3/4/−1 to `00`/`01`/`02`/`A0`, then deletes `RECBACKUP`.

No file bytes travel in `EA`.

### 9. `FF` — image block read-back (Confirmed; doc 51 §2)

**Trigger.** MAIN `FE00` with block `n` in the range `1..[0x1CC3C]`, handled by `sub_FFEDC4DD`.

| field | value |
| --- | --- |
| `b1` | `0xFF` (`FFEDC5E2 75 41 ff`, `ef 12`) |
| payload `[0..1]` | `n` |
| payload `[2..3]` | total |
| payload `[4..7]` | `[0x1CC48]` |
| payload `[8..]` | 256 bytes, or `[0x1CC40]` on the last block, from `0x070E1000+(n−1)·256` |

### 10. Wire lengths against the MAIN deframer counts (for L11)

**Matches.** The SUB length matches MAIN's doc-84 count for:
- `E0` (18);
- `E3` (16);
- `E4` (42);
- `E5`/`E6`/`EA` (14).

**Differences:**
- `E2` is 15 bytes, but MAIN counts 17. MAIN would read two of the zero pad bytes.
- `FF` is 277 bytes for a full block, but MAIN counts 273.
- `E1` (13+n) and `FE` (154+w18) are variable, but MAIN's counts are fixed (128 and 200).

Whether MAIN uses the header length instead is for L11.

## USB relevance

**Q1.** No SUB→MAIN frame is fed from USB.
- The external sources that reach MAIN through these frames are:
  - the GPS module (SCI2, `E1`);
  - the Bluetooth module (SCI3, `E4` code 0x12, and indirectly `E5`/`E6`);
  - the SD card (SDHI, `FE`);
  - the touch ADC (`E0`).
- The operand and call scans of the builders and every wrapper show no USB0 register and no
  USB-derived buffer. This is consistent with K7's whole-image 0.

**Q2: no SDR path.**
- The largest payload is an SD file chunk of 0x400 bytes or less in `FE`.
- The SUB→MAIN link is the same SCI0 UART.

**Q3.** None of these frames touches the DSP bus. Bluetooth audio (SCO) is handled by the external
module. SUB sees only its AT-style control strings.

## Open

1. **L11.** Use `frame-types.tsv` and `build-sites.tsv` to reconcile:
   - the `E2` (15 vs 17) and `FF` (277 vs 273) length differences;
   - `E1` and `FE` against MAIN's fixed counts;
   - how MAIN decodes the `FE` date bytes `(tens<<4)|(v&0xF)`.
2. **Bluetooth protocol.** Decode the response parser `sub_FFF3A833`/`sub_FFF3A8C9`/`sub_FFF3A95B`
   and pump `sub_FFF3B69B`. That would name the `E4` codes 0–5 and 0x10–0x13 and settle what `E5`
   versus `E6` track.
3. **SD command codes.** Name 0x0A–0x78 from `sub_FFF12E8B`/`sub_FFF12F9B` and the folder table
   `off_FFED8318`. Confirm which commands read file data into `FE` (backup restore, memory-channel
   import, QSO log).
4. **The `0x8A86` mode.** Find what MAIN state sends `F301`/`F3C0`/`F3C1` with `+0x13==3`; it
   suppresses `E1` and slows TPU3.
5. **Typed-data proposal.** Type the 260 bytes at `FFF4AEB5`–`FFF4AFB8` as strings in the next SUB
   seed. These are the Bluetooth format strings `SCAN=%d\r\n` … `PINF=0,%c…\r\n`, `%d` and `FT3D`.
   They are absent from `sub-final2\data-items.tsv` and `data-structs.tsv`, and 0 of the 260 are set
   in `mask_final2_allwf.bin`. Optionally also name the tens table `FFC3EB56`–`FFC3EB7D` (40 bytes).
   It lies outside the window, so it has no ledger effect.

Tables: `ida\out\sub-frames-sub\frame-types.tsv`, `build-sites.tsv` and `builders.tsv`.
Raw dumps, requests and scans are in `ida\out\sub-frames-sub\req\`.
