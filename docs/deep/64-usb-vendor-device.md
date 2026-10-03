# 64 — The vendor-class USB device `26AA:0001` ("USB CAMERA"): full protocol (lane I12)

Owner-side static analysis of the ver 1.02 images already on disk. Nothing was written to any radio or
device, nothing was enumerated, and no image byte was changed. MAIN is H8SX, big-endian, base 0, so the
file offset equals the mapped address for every MAIN cite below. Model: **claude-opus-5-5**.

Tables are in `ida\out\usb-vendor\`: `descriptors.tsv`, `requests.tsv`, `states.tsv`,
`usb-registers.tsv`, `ep-in-writers.tsv`, `push-dispatch.tsv`, `ram-cells.tsv`, `byte-verify.tsv`
(108 cited byte runs, all OK) and `ledger-delta.tsv` (proposed, not applied). Raw IDA dumps are in
`ida\out\usb-vendor\work\a` to `work\e`.

## Verdict

The vendor personality is a small, fixed-function device with exactly **four vendor requests plus
GET_DESCRIPTOR**, one **bulk OUT** endpoint for image data and one **interrupt IN** endpoint that
carries a **3-byte status report**. Nothing else is sent to the host.

- **Descriptors (Confirmed).** Device `26AA:0001`, USB 2.00, class 0, EP0 8 bytes, no strings.
  One configuration with one interface (class `FF/01/FF`). It has two endpoints: EP `0x01` bulk OUT 64 and
  **EP `0x83` interrupt IN, 8 bytes, bInterval `0x14` (20 ms)**. The 32 bytes actually served come
  from `0x05585E`. The config index read from `0xFF89CF` is overwritten with 0 at `0x055102` (`fd 00`).
  So the bInterval `0x64`/`0x96`/`0xC8`/`0xFA` variants are never served.
- **Requests (Confirmed).** The firmware accepts `C1 D4` (1-byte quality code) only in state 6. It
  accepts `41 D3` and `41 D1` in states 7/10, and `41 D2` in states 9/11. `80 06` is accepted only
  before configuration, for device and configuration descriptors. Everything else is dropped silently.
  The stack never writes a STALL. wLength is ignored everywhere.
  - The order is forced: enumerate → `D4` → (`D3` | `D1` → EP1 data → `D2`)*.
  - A `D4` is mandatory before any `D1`/`D3`, and it can be read only once per VBUS attach.
- **EP `0x83` (Confirmed).** It sends exactly three bytes: `[FF8184, FF89CE, code(FF89CD)]`.
  - `FF8184` is only ever 0 or 1. `FF89CE` is the USB CAMERA SIZE index. The code is
    `0x18`/`0x30`/`0x50` for QUALITY 0/1/≥2.
  - A report is sent when any of the three changes, and once after every `D2` (`FF8185 = 0xFF`).
  - **No error codes, no read-back data and no image data ever go to the host.**
  - EP0 IN carries only the fixed descriptor bytes and the 1-byte `D4` reply.
  - EP2 bulk IN is configured in the hardware endpoint table (`0x054C12`), but the vendor personality
    never declares or writes it.
- **The 17 "image-push sub-handlers" are 11 slots in three tables** (5 + 3 + 3). None of them touches a
  USB register.
  - The `0xFE00` read-back is an SCI-D request to SUB. It is issued at `0x055DEE`, not at
    `0x055FDE`.
  - It sits in a state machine whose start flag `0xFFBC51` has no non-zero writer anywhere in the
    image, and its 1 KB "flush" call is a bare `rts` (`0x06EE36`). The machine is dormant.
- **Selection (Confirmed).** The personality is a cold-boot latch (`0xFF813A`, writers `0x0021FA`/`0x002224`
  only). It is not a menu choice. The `USB CAMERA` menu only edits SIZE/QUALITY/SP SEL. The radio is
  always the USB **device**, to a camera accessory or a PC acting as host.
- **Q1/Q2.** The usable IN capacity is one 8-byte interrupt packet per 20 ms (400 B/s reserved). The
  firmware fills only 3 bytes and only on change. No IN endpoint of this personality can carry anything
  but that status or the fixed descriptor/quality bytes.

## Method

**IDA runs.** All IDA work was in the private DB `I12_MAIN`, through `run_job.py` only.

- The DB was seeded with `--copy-from ida\db\jobs\MAIN_FINAL\MAIN_FINAL.i64` (h8sxa). Four more passes
  used `--reopen`. All five passes exited 0 and no traceback was written.
- The one job script was `ida\jobs\i12_dump.py`. It is read-only: no edits and no auto-analysis.
- It produces disassembly with xrefs for given ranges, a function list, an xref census, and a text grep
  over every code head outside `0x078106`–`0x07B753`. It never decodes inside that window.

**Ranges dumped.**

- The whole vendor stack, `0x054B00`–`0x0560FF`.
- The D3 consumer `0x00FD40`–`0x00FE80`, the key scan `0x00FB60`, and the `FF8184` writers
  `0x039080`–`0x0394D0`.
- The EP3 caller `0x074AC0`, boot `0x002140`–`0x002330`, and the main loop `0x002B80`–`0x002C60`.
- The selector readers, the TX gate `0x022440`, the tone sequencer `0x038330`, `sub_B5CE`/`sub_B610`,
  the F3D0 sender `0x00594C`, the key `0x14` handler `0x06F4F0`, and the RAM DISPLAY sender `0x00A5F0`.

**Grep cells.** The grep covered `FF8180`–`FF8187`, `FF813A`, `FF8152`/`58`, `FF3D6x`, `FFB094`–`FFB09E`,
`FFBA38`–`FFBA74`, `FFBC4E`–`FFBC57`, `FF94C0`, `FF2EC9`, `FF89AB`, `FF89C1`, `FF89CD`–`CF`, `FFAAE0`,
`FFAAE8`, `FFA9E3`, `FF5006`, `FF9800`, and every `FFEExx` operand.

**Python byte scans (independent of IDA)** over `decrypted\FT3D_MAIN_ver102_EXP.bin`:

- Every `@aa:16` operand on `0xFFEE00`–`0xFFEE5F` outside the window (`usb-registers.tsv` counts),
  plus 32-bit immediates of `0x00FFEExx`.
- Every writer of `0xFFBC4C`–`0xFFBC57` in the `6A`/`6B` (`@aa:16`), `01 00 6B` (long) and H8SX
  `01 7x` immediate-to-memory forms.
- Branches into `0x054D22` and `0x054F3A`: bcc 8/16, bsr 8/16, jsr/jmp abs24, and BE32 pointers.
- Call sites of `0x055B58`, `0x06EE36`, `0x0557A2`, `0x00B5CE`, `0x054FEC` and `0x055B7A`.
- The consumers of the EP0-OUT buffer `0xFF3C6A`.

`ida\jobs\i12_gen_tables.py` re-reads all 108 cited byte runs from the two images (sha256 prefixes
`8e3ecd05…` / `b93570b3…`, unchanged) and writes `byte-verify.tsv`. Its exit code is non-zero on any
mismatch. Last run: `cites 108 mismatch 0`.

**Register names.** The function-module register names (IFR0/1/2, IER0/1/2, EPDR0i/0o/0s/1/2/3,
EPSZ0o/1, DASTS, FCLR, TRG, EPIR) and their bit meanings follow the Renesas H8S USB function module
layout. They are **Inferred** from how this code uses each bit. For example, IFR0 b3 triggers an 8-byte
read of `0xFFEE0E`, and IFR0 b6 triggers a counted read of `0xFFEE10`. The behaviour is Confirmed; the
names are not.

**Not done.**

- No analysis past the two window edges: `0x054EB0 jsr 0x07827C` in the ISR and `0x002234 jsr
  0x078106` at boot.
- The CDC helpers at `0x0767FA`–`0x077100` that touch IER/IFR/TRG were only listed, not analysed. They
  belong to the other personality (H4).
- No host-side code was written or run. The Windows DLLs were not opened.
- The exact semantics of byte 0 (`FF8184`) and of key `0x14` are Inferred from the surrounding state
  machines, which this lane did not fully decode (see Open).

## Findings

### 1. Descriptor set, byte by byte (Confirmed; full field table `descriptors.tsv`)

```
055810  08 01 00 02 00 00 00 08                         first-request stub (bLength patched to 8)
055818  12 01 00 02 00 00 00 08 aa 26 01 00 00 00 00 00 00 01      device
05582A  09 02 20 00 01 01 00 c0 32  09 04 00 00 02 ff 01 ff 00     config copy A
        07 05 01 02 40 00 00  07 05 83 03 08 00 64                 (only its first 9 bytes are ever sent)
05584A  00 05 58 5e  00 05 58 7e  00 05 58 9e  00 05 58 be  00 05 58 de     variant table
05585E  09 02 20 00 01 01 00 c0 32  09 04 00 00 02 ff 01 ff 00     variant 0 = the 32 bytes served
        07 05 01 02 40 00 00  07 05 83 03 08 00 14
```

**Device descriptor (`0x055818`).**

- bcdUSB 2.00; device class/subclass/protocol 0; bMaxPacketSize0 8; VID `0x26AA`, PID `0x0001`;
  bcdDevice 0.00.
- iManufacturer, iProduct and iSerialNumber are all 0; one configuration.

**Configuration (`0x05585E`).**

- wTotalLength 32; one interface; bConfigurationValue 1; no string; bmAttributes `0xC0`
  (self-powered, no remote wakeup); bMaxPower `0x32` (100 mA).
- **Interface 0, alternate setting 0:** 2 endpoints; class `0xFF`, subclass `0x01`, protocol `0xFF`;
  no string.
- **EP `0x01`:** bulk OUT, wMaxPacketSize 64.
- **EP `0x83`:** interrupt IN, wMaxPacketSize 8, bInterval `0x14`. At full speed that is 20 ms.

**Why only the 0x14 variant is served.**

- The code reads `0xFF89CF` at `0x0550FE` (`6a 0d 89 cf`) and then sets `fd 00` (`mov.b #0,r5l`). The
  index is therefore always 0, and `78 d0 6b 25 00 05 58 4a` at `0x05510C` loads `[0x05584A]` =
  `0x05585E`.
- The variants at `0x05587E`/`9E`/`BE`/`DE` differ only in bInterval (`0x64`, `0x96`, `0xC8`, `0xFA`) and
  are never served.
- The copy at `0x05582A` (bInterval `0x64`) is used only for the first 9-byte request.
- **Correction** to pc-03 §2 and pc-06 §1: they say the variant is "chosen from camera setting
  `0xFF89CF`" and give bInterval `0x64`.

**Strings.** There are none. `GET_DESCRIPTOR(STRING)` reaches `0x0550E8 aa 03 58 60 ff 44 58 00 ff 40`:
both branches go to the `rts` at `0x055032`. No string or LANGID descriptor exists in the image.

**pc-06 address error.** pc-06 puts the device descriptor at `0x055817`. That byte is the last byte of
the stub at `0x055810`; the descriptor starts at `0x055818`.

**Hardware endpoint table `0x054C12`.** `sub_54BF8` writes these 50 bytes to EPIR `0xFFEE32`
(`f4 32 7a 05 00 05 4c 12 6c 5c 6a 8c ee 32`). It is called only on the cold-boot path, `0x002214`,
when the entry flag `r1l == 0`. The flag is set by `0x0020F6 f9 01` / `0x0020FA f9 00`, and the reset
entry `0x002092` calls `0x0020FA`.

```
00 00 10 00 00   EP0  control, max 0x10>>1 = 8,  FIFO 0
14 20 80 00 01   EP1  cfg 1, bulk OUT,    max 64, FIFO 1
24 28 80 00 02   EP2  cfg 1, bulk IN,     max 64, FIFO 2
34 38 10 00 03   EP3  cfg 1, interrupt IN, max 8, FIFO 3
(6 x 5 zero bytes)
```

The field split is **Inferred**: byte0 = EP number / config / interface, byte1 = type in bits 5–4 and
IN in bit 3, byte2 = max packet << 1. The values agree with both descriptor sets. The hardware is
therefore configured once with a **64-byte bulk IN (EP2)** for both personalities. The vendor
descriptor does not declare it, and **no instruction outside the closed window references EPDR2
`0xFFEE14`**. The only 32-bit `0x00FFEE14` word in the image is at `0x07B5CE`, inside the window (the
CDC endpoint table). TRG is never written with `0x10` (EP2 packet enable) outside the window
(`usb-registers.tsv`).

### 2. Interrupt service (Confirmed code; bit names Inferred)

At init, `sub_54C44` sets IER0 = `0x8D`, IER1 = `0x03` and IER2 = `0x18`, then sets `bset #2,@0xFFEE2D`
(`0x054C94`).

| Vector | Routine | Flag | Action |
| --- | --- | --- | --- |
| 234 | `0x054D50` | (selector) | `FF813A ≠ 0` → `0x054EB0 jsr 0x07827C` (**window edge**, CDC) |
| | | IFR0 b7 bus reset | FIFO clear `0xFFEE28 = 0x73`, SETUP ring reset, `FF8180.6`. **Does not reset state `FF8183`** (`0x054D64`–`0x054D96`) |
| | | IFR0 b3 SETUP | 8 bytes `0xFFEE0E` → ring `0xFF3CEA`–`0xFF3D69` (16 slots, no overflow check), TRG=`0x04` (`0x054DAC`) |
| | | IFR0 b2 EP0 OUT | EPSZ0o bytes `0xFFEE0D` → `0xFF3C6A` (nothing reads that buffer), TRG=`0x02`, `FF8180.4` |
| | | IFR0 b1 EP0 IN request | only in state 4: IER0=`0x8D`, count 0, TRG=`0x01` → zero-length status packet (`0x054E30`) |
| | | IFR0 b0 EP0 IN sent | next ≤8 bytes from `[FFB09E]` → `0xFFEE0C`, TRG=`0x01`; when done `FF8180.3` |
| 235 | `0x054EC2` | IFR1 b0 VBUS change | `FF8180.0` = IFR1 b3; **state `FF8183` = 0**; if VBUS gone, full soft reset incl. `FF8184` dword = `0x0100FFFF` (`0x054F12`) |
| | | IFR1 b1 EP3 sent | `FF8180.2` (no reader) |
| | | IFR2 b4 / b3 | `FF8180.5` = suspend state; `FF8180.7` = configuration done (no reader) |
| 238 | `0x054CFA` | IFR2 b4 | clears it, sets `FF8180.1` |

**Two unreachable blocks (Confirmed, whole-image byte scan for every branch, call, abs24 and BE32 form).**

- **`0x054F3A`–`0x054F87`** (78 B). This is an EP3 report writer inside vector 235. It sits after the
  `rte` at `0x054F38` (`6d 74 56 70 73 2c 47 4a`). The IFR1 b0 path always returns before it, and the
  b0-false branch at `0x054ECC` goes to `0x054F88`. IER1 = `0x03` also leaves the IFR1 b2 source
  disabled.
- **`0x054D22`–`0x054D4B`** (42 B). This is an `EE2F` pulse in vector 238, skipped by `40 2a` at
  `0x054D20`.
- Both blocks are in H9's proven mask through the function-index addend. See `ledger-delta.tsv`
  (proposed −120 B, not applied).

Standard chapter-9 requests other than GET_DESCRIPTOR (SET_ADDRESS, SET_CONFIGURATION, GET_STATUS,
features, interfaces) have **no firmware handler**. No compare for them exists in `0x054BF8`–`0x0557A0`.
**Inferred:** the module answers them itself and passes up only GET_DESCRIPTOR and vendor SETUPs.
Enumeration could not succeed otherwise.

### 3. Control-transfer state machine (Confirmed; `states.tsv`)

**The dispatcher.** The main loop calls `sub_54FEC` only when the selector is 0. The call sites are
`0x002BE2 6a 0c 81 3a 46 04 5e 05 4f ec`, `0x0037EA` and `0x00392C`. `sub_54FEC` dispatches on
`FF8183` through the 12-slot table `0x055002`.

**How each state handles SETUPs.** Each SETUP-consuming state dequeues one 8-byte packet into
`0xFF3D6A`.

- If the first word is not one of `8006`, `C1D4`, `41D3`, `41D1` or `41D2`, the packet is compared with
  **8 byte-rotations of `80 06 00 01 00 00 08 00`** at `0x0558FE`.
- A match is treated as GET_DESCRIPTOR(device). This is a resynchronisation aid for a misaligned ring.
- Seven further templates at `0x05593E` are never referenced (`80 06 …12`, `80 06 …02…09`,
  `80 06 …02…20`, `c1 d4 … 01 00`, and `41 d1`/`41 d2`/`41 d3 ff ff ff ff 00 00`). They document the
  intended wLength values: D1/D2/D3 = 0 and D4 = 1.
- The handler then checks only the word that state expects. **Anything else is silently discarded**:
  no STALL, and `FFEE2A` is written only at init.

```
        VBUS on (IFR1 b0, state:=0)
              |
   [0] wait FF8180.0 ──> [1] SETUP: 80 06 dev -> 8 B  (latch 5)
                             80 06 cfg -> 9 B  (latch 5, FF8181.0:=1)
                             else drop
   data stage: [2] wait EP0-IN done ──> [3] wait host status ZLP ──> latch
   [5] SETUP: 80 06 dev -> 18 B (latch 5) | cfg -> 32 B (latch 6)
   [6] EP3 report check; SETUP: C1 D4 -> 1 B (latch 7) | else drop
   [7]/[10] EP3 report check; SETUP:
        41 D3 -> FFB096:=wValueL; [4] ZLP; -> 7
        41 D1 accepted -> [8] (status stage held) ; refused -> [4] ZLP -> 11
        else drop
   [8] wait FFAAE8==0 -> [4] ZLP -> [9]
   [9] EP1 full -> copy packet;  SETUP 41 D2 -> finish; [4] ZLP -> 10 ; else drop
   [11] EP1 full -> discard;     SETUP 41 D2 -> [4] ZLP -> 10
   [4] = wait our ZLP sent (FF8180.3) -> latch (FF8182)
```

Consequences, all **Confirmed** from the code above:

1. **D4 is mandatory and one-shot.**
   - `C1 D4` is accepted only in state 6 (`0x0552D8 79 2a c1 d4 46 26 fb 07`), and the only way out of
     state 6 is through it.
   - State 6 is re-entered only through states 0→1→5, which needs a VBUS change. So a host can read
     the quality code **once per attach**, and must do so before any `D1`/`D3`.
2. **No re-enumeration without a VBUS cycle.**
   - A bus reset does not touch `FF8183`, and GET_DESCRIPTOR is dropped in states 6–11.
   - **Inferred:** a host-side port reset, or a driver reload that re-reads descriptors, will time out
     until the cable is unplugged.
3. **wLength is ignored.**
   - Descriptor lengths are fixed: 8 then 18 for the device, 9 then 32 for the configuration.
   - The first configuration request after VBUS always gets 9 bytes, the next always 32
     (`FF8181.0`, `0x0550F2`/`0x055116`).
   - `D4` always returns 1 byte.
4. **One SETUP per poll pass.** The ring holds 16 SETUPs with no overflow check. States 2/3/4/8 do not
   dequeue.

### 4. Request table (Confirmed; full columns in `requests.tsv`)

| SETUP word | States | wValue | wIndex | wLength | Data | Handler | Effect |
| --- | --- | --- | --- | --- | --- | --- | --- |
| `80 06` type 1 | 1, 5 | `01xx` | – | ignored | IN 8 B (`0x055810`) first, then 18 B (`0x055818`) | `0x055128` | → state 5 |
| `80 06` type 2 | 1, 5 | `02xx` | – | ignored | IN 9 B (`0x05582A`) first, then 32 B (`0x05585E`) | `0x0550F2`/`0x055116` | 9 B → 5; 32 B → 6 |
| `80 06` other types, or any state ≥ 6 | – | – | – | – | none | – | dropped |
| `C1 D4` | 6 | ignored | ignored | ignored (1 B sent) | IN 1 B: `0x18`/`0x30`/`0x50` for `FF89CD` = 0/1/≥2 | `0x0552D8` | → 7 |
| `41 D3` | 7, 10 | low byte → `FFB096` | ignored | 0 | none | `0x0554E6` | key code `0x14` on a 0 → non-zero edge (§7); → 7 |
| `41 D1` | 7, 10 | size[15:0] | low byte = size[23:16] | 0 | none (image follows on EP1) | `0x05540C` | start image (§5); → 8 or (refused) 11 |
| `41 D2` | 9, 11 | ignored | ignored | 0 | none | `0x0555F4` / `0x055768` | end image; force EP3 report; → 10 |
| anything else | – | – | – | – | none | – | dropped, never stalled |

This confirms lane 7's count (doc 24) of 5 request codes. Doc 24's statement that "D3 is a one-byte
parameter-set request" is incomplete: the byte is a **button level** that becomes a key event (§7).

### 5. Image upload: `41 D1` → EP1 bulk OUT → `41 D2` (Confirmed)

**Gates at `0x055414`.** `D1` is refused when any of the following holds:

- `FF94C0 ≠ 0`. This is the transmit state: `sub_2244C`, the PTT-start handler, writes 1 or 2 at
  `0x022542`/`0x022550`.
- KEY LOCK is on (`FF89C1` b3) **and** `FF89AB` b0 = 0.
  - `FF89AB` is the LOCK type (F388, default 2). The SUB list at `0xFFF48FD9` gives 0 KEY, 1 DIAL,
    2 KEY&DIAL, 3 PTT, 4 KEY&PTT, 5 DIAL&PTT, 6 ALL (9-byte stride).
  - b0 = 0 is exactly the set of lock types that lock the keys. The TX inhibit `sub_22562` uses the
    same byte as `>= 3` (`6a 0c 89 ab ac 03`, the types that lock PTT). So the camera shutter is
    treated as a key press. The list mapping is Inferred; the bit tests are Confirmed.
- `FF2EC9 ≠ 0`, meaning a picture operation is already in progress.
- The size is 0 (`0x055460 47 50`).

**Accept.**

- **Size.** `size = wIndexL<<16 | wValue` (`0x05543E 7a 06 00 ff 3d 6c 6c 6c 6c 64 6c 6d`). It is stored
  in `FFB098` (bytes still to forward), `FFBA46` (record size) and `FFBA6E` (bytes still expected).
- **Bookkeeping.** `FFB09C = ceil(size/64)` is written at `0x05546E` and **read nowhere**. Write index
  `FFBA6C = 0`. `sub_6F512` sets `FF2EC9 = 1` and loads the 128-byte index-record template; `sub_6A700`
  fills it (pc-06).
- **Signals.** `FFA9E3` b4 is set (this kicks the audio/TX state machine `0x039080` into states 5–8).
  Event `0x4F` → `FFAAE0`. `FF8184 = 1`. State 8. Block count goes to `FFBC42`, and the forward pointer
  `FFBC48 = 0xFF5806` (`0x055488`–`0x0554AA`).
- **Status stage deferred.**
  - State 8 (`0x055520 6a 0c aa e8 46 f8`) returns the zero-length status packet only once `FFAAE8 == 0`.
  - `FFAAE8` is the state of the tone/event sequencer `sub_3835E` (jump table `0x038380`). That
    sequencer consumes `FFAAE0`; event `0x4F` is in its list at `0x03839C` (`4f 1e 35 5d ff`).
  - So the host's `D1` control transfer completes only after the radio has finished the sequencer
    activity that `D1` itself started. That activity is Inferred to be a confirmation tone.
  - Until then the status IN token is NAKed.

**Refuse.**

- `FFBA72 = 1` and next state 11, with the status ZLP sent at once.
- The host gets **no error indication**: no STALL, and `FF8184` is unchanged.
- The host may still stream the data. State 11 drains EP1 into nothing (`0x0556B8`) and accepts the
  closing `D2` (`0x055768`), which only forces an EP3 report.

**Data (state 9).**

- The poll checks IFR0 b6, reads EPSZ1 `0xFFEE25`, subtracts it from `FFBA6E`, and copies the packet
  byte by byte from EPDR1 `0xFFEE10` to `0xFF5806 + FFBA6C` (`0x055684 6a 0c ee 10 68 dc`). It then
  re-arms with TRG = `0x20` (`0x0556C0`).
- When the index equals exactly `0x100`/`0x200`/`0x300`/`0x400`, `sub_55976` forwards that 256-byte
  quarter to SUB as an `FFFF` block (`sub_B610`). At `≥0x400` the index wraps to 0 after a fixed
  `0x4E20`-iteration busy wait (`sub_55A2C`).
- One packet is handled per poll pass, and each forward blocks on SCI-D (`0x00B614`). The OUT rate is
  therefore bounded by the main loop and the SCI-D link, not by USB. This is Inferred; the loop period
  was not measured.

**Bounds (Confirmed arithmetic; consequence Inferred).** The copy loop has no limit other than the
packet length, and forwarding needs the index to land exactly on a multiple of `0x100`.

- If the host sends a packet shorter than 64 bytes before the last one, the index goes off alignment.
  Forwarding then stops matching, so the image is corrupted.
- A misaligned index can also reach `0x3FF` before a 64-byte packet arrives. The loop would then write
  up to `0xFF5806 + 0x43E` = `0xFF5C44`, which is **63 bytes past the 1 KB window**.
- Bytes beyond the declared size are not refused. `FFBA6E` simply wraps.
- No absolute reference to `0xFF5C06`–`0xFF5C44` exists, so what that RAM holds is Unknown. The scope
  was imm32 forms; base-plus-displacement use was not excluded.
- A host that sends full 64-byte packets and exactly `size` bytes never hits any of this.

**`D2` (state 9, `0x0555F4`).**

- If bytes are still owed, `FFBA73++`. That counter has **no reader**.
- `sub_559F4` sends the final partial block (length `FFB098`, from `FFBC48`), then posts SUB-side flags
  (`BBF1.4`, `sub_AF94`) and sets `FFBC4E = 2`.
- `FF2EC9 = 0` and `FF8185 = 0xFF`, which forces an EP3 report: an implicit "upload done" signal.
- Status ZLP, then state 10.

From there the picture appears on the SUB as a preview. Saving it is a separate user action
(`0x02AC64` → `sub_55A42`; pc-06 §3).

### 6. EP `0x83`: the 3-byte status report (Confirmed)

There are three live builders: state 6 (`0x055202`), states 7/10 (`0x05532E`) and `sub_557A2`. The last
has a single caller, `0x074B0C` in `sub_74B08`, a settings-refresh routine with four callers. All three
do the same thing, as at `0x0557D0`–`0x05580C`:

```
if (DASTS(0xFFEE27) & 0x20) return;                 /* previous report not yet taken */
if (FF8184 == FF8185 && FF8186 == (FF89CE<<8 | q)) return;   /* nothing changed */
EPDR3 = FF8184;  FF8185 = FF8184;
EPDR3 = FF89CE;                                      /* SIZE index 0 = 320*240, 1 = 160*120 */
EPDR3 = q = (FF89CD==0) ? 0x18 : (FF89CD==1) ? 0x30 : 0x50;   /* QUALITY code */
FF8186 = FF89CE<<8 | q;  TRG = 0x40;                 /* send a 3-byte packet */
```

**The packet is 3 bytes**, not 8 as pc-03 §6 says. The fourth EP3 writer is the unreachable block
`0x054F3A` (§2). See `ep-in-writers.tsv`.

**Byte 0 (`FF8184`).** It is only ever 0 or 1.

- Writers: the init dword `0x0100FFFF` at `0x054C64`/`0x054F1C`/`0x05601C`, `0x055496` (=1, D1),
  `0x0557A4` (=1), `0x039462` (=1), and `0x0393DC` (= `r3l`).
- In `sub_391C0`, `r3l` is assigned only `#0` or `#1`. It is 1 when SP SEL (`FF89C5` b1) is set, and 0
  when `FFA9E3 & 0x2C` is non-zero (TX-path bits).
- Otherwise it is 1, then cleared to 0 by the per-band receive-audio tests (`FFA9AD`/`FFA9AC`,
  `0x039366`–`0x0393DA`).
- The same routine drives output port `0xFFFF59` b2 from SP SEL and from VBUS (`FF8180.0`,
  `0x039168`/`0x0391B2`).
- **Inferred meaning:** "radio idle / audio routed to the camera accessory" = 1, versus "transmitting or
  receiving audio on the internal path" = 0. The camera end probably uses it to gate its shutter or
  speaker.
- pc-06's "camera command" and doc 24's "USB state machine's working register" are both superseded:
  `FF8184` is a byte-wide 0/1 flag. The neighbouring `FF8185`–`FF8187` are its shadow copies.

**Bytes 1–2.**

- These are the two USB CAMERA settings. The F3D0 settings sender `0x00594C` packs
  `[FF89CE, FF89CD, FF89C5.b1]` into the SUB frame, and doc 45 decodes the menu rows as SIZE,
  QUALITY, SP SEL in that order.
- So `FF89CE` = SIZE (two values) and `FF89CD` = QUALITY (three values, matching the three codes).
- **Inferred:** `0x18`/`0x30`/`0x50` are JPEG quality factors 24/48/80 for LOW/NORMAL/HIGH.

**No read-back or error code.** Nothing from the SUB read-back path (§8), no error code, and no image
byte is ever written to EPDR3 or EPDR0i.

- The only internal error code on this path is event `0x1D` → `FFAAE0` (`0x055F76`), which goes to the
  UI only.
- The "`0xFE00` read-back at `0x055FDE`" in I1's notes is a misattribution. `0x055FDE` is
  `5e 00 b6 10` (an `FFFF` block send in SM-C). The `FE00` request is `0x055DEE 5e 00 b5 ce` → `0x00B5DE
  79 04 fe 00`, which goes to SUB over SCI-D.

### 7. `41 D3`: a remote button, key code `0x14` (Confirmed path; action Inferred)

`D3` stores wValueL in `FFB096` (`0x0554E6`). The only reader is `sub_FDC8`. The key scanner calls it at
`0x00FB9E` only while no other key event is pending (`FFA9ED` negative). It is a 3-state edge detector
on `FFB097`, a copy of the debouncer `sub_FD5E` that serves port `0xFFFF4E` b4:

```
state 0: if (FFB096 == 0) state = 1;                     /* arm on release  */
state 1: if (FFB096 != 0) { FFA9ED = 0x14; state = 2; }  /* press -> key 0x14 */
state 2: if (FFB096 == 0) state = 1;
```

The `0x00FDFE fc 14 6a 8c a9 ed` line is the press branch.

- **Semantics.** A host must send `D3(1)` then `D3(0)` to produce one key event. Holding the value
  non-zero produces exactly one event.
- **Handler.** Key `0x14` is column 11 of the main key tables, handler `0x06F5D0` (pc-05 table).
- **When it acts.** The handler acts only when the operating band is in a digital mode (`FF8D20` or
  `FF8DD5` non-zero), `FFBA32 ≠ 0`, and `FF2EC9 == 0`. Otherwise it falls to the default `sub_3FFA0`.
- **What it does.** It copies the last picture's 12-byte name stem from `0xFF2F9E`, appends `".jpg"`
  (`0x06F640 7a 04 2e 6a 70 67`), starts an SD read with `sub_708B6`, and sets UI state `FFBAA3 = 0x25`.
- **Inferred:** "send the last snapshot" over C4FM. This is the camera accessory's second button.

### 8. The image sub-dispatch: 11 slots in three tables, none on USB (Confirmed; `push-dispatch.tsv`)

**The dispatcher.** `sub_55B7A` is called once per main-loop pass at `0x002C20`, inside the
`FF813A == 0` block (`0x002C06 … 46 1c`). It runs three independent machines in turn. For each, a
trigger byte resets the state to 0, then a table indexed by the state is called:

| Machine | Trigger | State | Table / site | Slots |
| --- | --- | --- | --- | --- |
| SM-A | `FFBC4F` | `FFBC50` 0–4 | `0x055BF2`, `jsr @er6` at `0x055BA0` | `0x055C1E`, `0x055C7E`, `0x055CEA`, `0x055D6C`, `0x055D8A` (rts) |
| SM-B | `FFBC51` | `FFBC54` 0–2 | `0x055C06`, `jsr @er6` at `0x055BC8` | `0x055D8C`, `0x055DE8`, `0x055DFA` (rts) |
| SM-C | `FFBC55` | `FFBC57` 0–2 | `0x055C12`, `jmp @er6` at `0x055BF0` | `0x055F84`, `0x055F96`, `0x055FF0` |

**Correction to I8 (doc 60).** I8 read `0x055BF2` as 11 handlers and `0x055C06` as 6, running each
table to the end of the block. The state cells take only the values written above (`FFBC50` ∈ {0..4},
`FFBC54` ∈ {0,1,2}, `FFBC57` ∈ {0,1,2}), so the tables hold 5, 3 and 3 entries. 11 distinct slots in all.

**SM-A, stored picture → SUB.** This machine is **dormant**.

- It reads up to 1 KB at a time from a picture file into `0xFF5006` (`sub_6EF20`), sums it, and sends
  it to SUB as `FFFF` blocks.
- Its trigger `FFBC4F` is set non-zero only at `0x055B6E`, inside the 34-byte fragment
  `0x055B58`–`0x055B79`. That fragment has **no caller**: no `jsr`/`jmp`/`bsr`, no imm32 and no BE32
  pointer to `0x055B58` in the image.
- The slots are still in H9's proven mask by table descent, which is correct under H9's rule.

**SM-B, SUB → MAIN read-back.** This machine is **dormant**.

- State 0 (`0x055D8C`) loads the size from `FFBA46` (camera) or `FFB208` (received picture) and points
  `FFBC48` at `0xFF5806` (`0x055DD4`).
- State 1 sends the `FE00` request (`0x055DEE`).
- The `0xFF` reply frames are checked by `0x055DFC`, called from the SCI-D receive path `0x047B66`.
  The checks are length ≤ `0x100`, block number, total and a running sum. The reply data is copied to
  `[FFBC48]` at `0x055EAE` (`68 ec`).
- Every 1 KB it calls `0x06EE36`, which is a bare `rts` (`54 70`).
- On success it calls the index-record writers (`sub_6A802` for the camera, `sub_6A5C8` for a received
  picture). On a mismatch it posts event `0x1D`.
- Its trigger `FFBC51` has **one writer, `0x055BAA`, which writes 0**. The scope was all `@aa:16`,
  long, imm32 and H8SX `01 7x` immediate-store forms over the whole image. So state 0 is never armed.
- Two corrections to I1 (doc 53) follow:
  - The `0xFF5806` window **does** have a second store, `0x055EAE`, writing through a pointer.
  - That store is in dormant code. I1's conclusion that USB EP1 is the only live source of the window
    still holds.

**SM-C, `0xFF5006` → SUB.** This machine is live but not USB.

- It is triggered at `0x05F4A6` in `sub_5F458`. It sends `FFBA74` bytes from `0xFF5006` as `FFFF`
  blocks and sets `FFBC56` when done.

**No slot touches USB.** None of the 11 slots, and none of `sub_B5CE`, `sub_B610` or `sub_B6B6`,
touches `0xFFEExx` (`usb-registers.tsv` lists every site). The only USB-adjacent code in this block is
the D1/D2 forwarding in §5.

### 9. How the personality is chosen, and who is host (Confirmed)

**The selector is a cold-boot latch.** `0xFF813A` has exactly two writers, both in `sub_20FA`:

```
0021F8  fc 00 6a 8c 81 3a        selector = 0
0021FE  fe c8                    200 polls
002200  2c 4c ec 7f ac 7d 47 16  (P[0xFFFF4C] & 0x7F) == 0x7D ?  -> 0x00221E
002210  a9 00 46 04 5e 05 4b f8 5e 05 4c 44     normal: EPIR load (cold entry only), vendor init
002222  fc 01 6a 8c 81 3a 5e 05 5f fe           strap: selector = 1, vendor RAM reset
002234  5e 07 81 06                               -> closed window (CDC init)  [edge only]
```

- The strap value `0x7D` is key code `0x11`, the A/B key per pc-05, held at power-on.
- There are 12 readers (`ram-cells.tsv`). This lane adds `0x05E9F2`, which was not in doc 15's list
  of 11.
- No runtime path writes the selector. The vendor stack runs only when it is 0: the ISR test at
  `0x054D54`, the three poll sites, and the image block at `0x002C06`.

**The `USB CAMERA` menu does not select anything USB-side.**

- The SUB label is at `0xFFC3E709` (setup group `D0`).
- Its value page edits SIZE (`320*240`/`160*120`, strings at `0xFFF4A496`), QUALITY (LOW/NORMAL/HIGH)
  and SP SEL (CAMERA/INT SP). MAIN sends these with code `F3D0` from `0x00594C`.
- MAIN uses them only as EP3 report bytes 1–2, the `D4` reply, and the byte-0/port-`0x59` logic
  (§6). Nothing in the menu path writes `FF813A`, IER, or the module enable.

**The radio is always the device.**

- `0xFFEE00`–`0xFFEE53` is a *function* controller. The code reads SETUP packets, answers
  GET_DESCRIPTOR, and fills IN FIFOs. Every access to `0xFFEE00`–`0xFFEE5F` outside the window
  (`usb-registers.tsv`) is a function-side operation of this kind. None is a host-side operation: no SOF
  generation, no port reset, no token issue.
- Both descriptor sets are device descriptors.
- The camera accessory must therefore be the USB host, as must a PC standing in for it. This agrees
  with pc-06 §6 and doc 53.
- The VBUS sense bit (IFR1 b3 → `FF8180.0`) also feeds the audio routing on port `0xFFFF59` b2
  (`0x039168`). **Inferred:** the accessory powers the bus, consistent with bmAttributes `0xC0`
  (self-powered device).

**A diagnostic view exists.** The RAM DISPLAY engineering screen (sender `0x00A654`, frame `F3D1`)
indexes the base-address table `0x00644C` by `FF89C6 & 0x7F`. Slots 55–58 are `0xFF8180`, `0xFFB094`,
`0xFF3C6A` and `0xFFEE00` (`0x006528`). These are the USB event flags, the EP0-IN count, the EP0-OUT
buffer and IFR0. The vendor stack's state can therefore be viewed on the radio's own screen.
**Inferred:** this is a factory debugging aid. It is read-only and only sends data to the SUB display.

### 10. The protocol as a host sees it (documentation only; no host code was written)

**Host-visible state diagram.** The device-side state numbers are in brackets.

```
 attach (VBUS) ─► ENUMERATING [1/5]
     GET_DESCRIPTOR(DEVICE)  -> 8 B (first time), 18 B (after)
     GET_DESCRIPTOR(CONFIG)  -> 9 B (first time), 32 B (after)  ── 32 B read ─► CONFIGURED-WAIT-D4 [6]
     (SET_ADDRESS / SET_CONFIGURATION: answered by the module itself, Inferred)
     (STRING / QUALIFIER / anything else: no answer, host times out)
 CONFIGURED-WAIT-D4 [6]
     C1 D4 (IN, 1 B) -> quality code ─────────────────────────────────► IDLE [7]
     EP 0x83 may already report [b0,size,q]
 IDLE [7] / [10]
     41 D3 wValue=1 then 41 D3 wValue=0  -> one key-0x14 event          (stays IDLE)
     41 D1 wValue=size[15:0] wIndex=size[23:16]
         accepted -> status stage completes only after the radio's event sequencer is idle ─► UPLOAD [9]
         refused  -> status stage completes at once ────────────────────────────────────► SINK [11]
 UPLOAD [9]   bulk OUT EP 0x01, 64-byte packets, exactly `size` bytes; then 41 D2 ─► IDLE [10]
 SINK [11]    bulk OUT accepted and discarded;                         then 41 D2 ─► IDLE [10]
 after each D2: one EP 0x83 report is sent ([b0,size,q], b0 normally 1 after an accepted D1)
 detach (VBUS off) -> everything resets; a bus reset alone does NOT (no re-enumeration)
```

**Request / response table.**

| Host sends | Radio returns | Notes |
| --- | --- | --- |
| `80 06 00 01 00 00 xx xx` | 8 B (`08 01 00 02 00 00 00 08`), later 18 B | wLength ignored |
| `80 06 00 02 00 00 xx xx` | 9 B, later 32 B (`descriptors.tsv`) | wLength ignored; EP `0x83` bInterval 20 ms |
| `C1 D4 00 00 00 00 01 00` | 1 B: `0x18` / `0x30` / `0x50` | only in [6]; once per attach |
| `41 D3 vv 00 00 00 00 00` | ZLP | press on the 0 → non-zero edge; release to re-arm |
| `41 D1 lo hi ss 00 00 00` | ZLP, possibly delayed | size = `ss<<16 \| hi<<8 \| lo`; ≤ 0xFFFFFF. The SUB JPEG window is 81,920 B (pc-06), so larger images will not decode (Inferred) |
| bulk OUT EP `0x01` | ACK per packet (module) | send full 64-byte packets; a short packet is the last packet only |
| `41 D2 00 00 00 00 00 00` | ZLP; then an EP `0x83` report | final partial block is forwarded to SUB here |
| interrupt IN EP `0x83` | `[b0, SIZE, Qcode]` (3 B) when something changes | b0 ∈ {0,1}; SIZE ∈ {0,1}; Qcode ∈ {0x18,0x30,0x50} |
| anything else | nothing (NAK until timeout; never STALL) | Inferred host-side effect |

**No authentication or identity check.** No handler compares a host identity, serial number or
challenge (scope: every vendor handler in `0x05540C`–`0x0557A0`). This is Confirmed. That a PC is
therefore accepted in place of the camera is Inferred, as pc-06 said.

### 11. Q1/Q2: IN bandwidth and what IN can carry (Confirmed)

**Declared IN capacity.**

- EP `0x83` is interrupt, 8 B per bInterval of 20 ms: **400 B/s reserved**.
- The firmware writes **3 B per report** and only on change. The report fires after `D2`, on a
  SIZE/QUALITY change, or on a byte-0 flip, so it is typically a handful of packets per session.
  Effective payload is ≤ 150 B/s even if byte 0 toggled every interval.
- EP0 IN carries the fixed descriptor bytes (67 B per enumeration) and the 1-byte `D4` reply once per
  attach.
- There is **no bulk IN** in this personality.

**What IN can carry.** Exactly the EP0-IN and EP3 sources in `ep-in-writers.tsv`.

- EP0-IN is fed from `[FFB09E]`, which is set only by `sub_55144`. Its five callers pass only
  `0x055810`, `0x055818`, `0x05582A`, `0x05585E` and `0xFFB095`.
- EP3 is fed only from `FF8184`, `FF89CE` and the constant quality code.
- No path exists from the image buffer, the SUB read-back, the DSP, the receiver or any RAM chosen by
  the host to an IN FIFO. **No IN endpoint can carry anything other than this status/descriptor data.**

**Hardware headroom.** The module is configured with a 64-byte bulk IN (EP2, `0x054C12`). That EP2 is
used only by the CDC personality, and only behind the closed window.

- At full speed a bulk IN pipe can in principle move up to 19 × 64 B per 1 ms frame, about
  1.2 MB/s.
- This firmware drives EP data by byte-wise programmed I/O, with no DMA on any USB register.
- So the answer is "**the part has a bulk IN pipe; this firmware's vendor personality does not use it,
  and nothing in it produces sample data**". It is not "the hardware cannot".

### 12. Corrections to earlier docs (Confirmed unless noted)

| Doc | Earlier claim | Correction | Evidence |
| --- | --- | --- | --- |
| pc-03 §2, pc-06 §1 | config variant chosen from `0xFF89CF`; EP3 bInterval `0x64` | index forced to 0; served bInterval is `0x14` (20 ms) | `0x0550FE 6a 0d 89 cf fd 00`; `0x05587D = 14` |
| pc-03 §6 | 8-byte interrupt report, byte0 = size, byte1 = quality | 3-byte report: `[FF8184 0/1, SIZE, quality code]` | `0x0557D0`–`0x05580C` |
| pc-06 §1 | device descriptor at `0x055817`; EP3 writer `0x054F4E` | descriptor at `0x055818`; `0x054F4E` is in an unreachable block | `0x054F36 6d 74 56 70` |
| pc-03 §3 | state roles (6 "size negotiate", 7 "D1/D3", 9 "end-of-buffer"…) | see `states.tsv` (6 = D4 only, 9 = EP1 data + D2, 11 = discard sink) | `0x055002` handlers |
| pc-03 §4 | "`FFB09C` tracks remaining packets" | written, never read | byte scan: 1 writer `0x05546E`, 0 readers |
| doc 24 | `FF8184` is the USB state machine's dword working register; D3 effect confined to one variable | `FF8184` is a byte 0/1 status flag; state is `FF8183`. D3 drives key code `0x14` | §6, §7 |
| doc 53 (I1) | the only store into `0xFF5806`–`0xFF5B06` is `0x055688`; `FE00` read-back at `0x055FDE` | a second store `0x055EAE` exists, in dormant SM-B; `FE00` is issued at `0x055DEE` | §8 |
| doc 60 (I8) | `0x055BF2` = 11 handlers, `0x055C06` = 6 | 5 + 3 slots, plus a third table `0x055C12` (3) at site `0x055BF0` | state value sets, §8 |
| doc 15 | 11 readers of `FF813A` | 12 (`0x05E9F2` added) | grep `a\grep.txt` |
| H9 proven mask | `0x054D22`–`0x054D4B`, `0x054F3A`–`0x054F87` proven | unreachable (120 B); proposed demotion, not applied | `ledger-delta.tsv` |

## USB relevance

**Q1, everything USB.**

- The vendor personality is now specified end to end:
  - descriptors byte by byte, with no strings
  - the hardware endpoint configuration
  - every interrupt source and every register access
  - the 12-state control machine
  - all accepted requests, with exact field use
  - the EP3 report format
  - D3's role as a remote button
  - the D1 gates (TX, key lock, busy)
  - the deferred D1 status stage
  - the absence of STALL, of wLength handling, and of re-enumeration after a bus reset
- It is chosen only by the cold-boot strap. It is not a menu choice.
- The image sub-dispatch (11 slots) has no USB contact, and two of its three machines are dormant in
  ver 1.02.

**Q2, USB SDR.** Still **no** for this personality, and now proven at the IN-endpoint level:

- IN capacity is one 8-byte interrupt packet per 20 ms.
- Its only contents are three status bytes or fixed descriptor bytes.
- The only bulk pipe is OUT.
- The module does have a configured 64-byte bulk IN (EP2), but only the CDC personality behind the
  closed window references it.

**Q3, DSP.** Unaffected. Nothing in the vendor stack touches SCI-C or the DSP driver. Its only
side-effects are the SUB link (SCI-D), the UI/tone sequencer, the key queue (key `0x14`) and the
picture index records.

## Open (most valuable first)

1. **Pin byte 0 of the EP3 report.** Decode the audio/TX state machine `0x039080` (`FFA9E5` states 0–8,
   `FFA9E3` bit roles, `FFA9AD`/`FFA9AC`) and output port `0xFFFF59` b2. That turns "0/1 flag" into a
   named camera-side signal.
2. **Key `0x14` handler `0x06F5D0` → `sub_708B6`.** Confirm that it starts a C4FM picture transmit of
   the last snapshot, and what `FFBA32` is.
3. **Tone/event sequencer `sub_3835E`.** Identify event `0x4F` and bound the delay it adds to the `D1`
   status stage, which a host must tolerate.
4. **RAM past `0xFF5C05`.** Find what owns `0xFF5C06`–`0xFF5C44` by base-plus-displacement users, to
   judge the consequence of a misaligned upload (§5 Bounds).
5. **`0xFFEE08`/`09`/`0A`/`2E`/`44`/`50`/`51`/`53`.** Their functions are Unknown. A part datasheet for
   the exact H8SX variant would settle the register names this doc marks Inferred.
6. **Orchestrator decision.** Apply or reject the −120 B proven-mask demotion in `ledger-delta.tsv`.
   It is disjoint from the three pending I-wave deltas.

## Files

- `docs\deep\64-usb-vendor-device.md` (this doc)
- `ida\jobs\i12_dump.py` (IDA job, read-only) and `ida\jobs\i12_gen_tables.py` (plain Python byte
  verifier and table writer)
- `ida\out\usb-vendor\`:
  - `descriptors.tsv`, `requests.tsv`, `states.tsv`, `usb-registers.tsv`
  - `ep-in-writers.tsv`, `push-dispatch.tsv`, `ram-cells.tsv`
  - `byte-verify.tsv`, `ledger-delta.tsv`
  - `work\a`–`work\e` (raw dumps and greps)
- DB `ida\db\jobs\I12_MAIN\I12_MAIN.i64`; logs in `ida\log\jobs\I12_MAIN\`
