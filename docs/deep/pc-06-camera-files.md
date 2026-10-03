# pc-06: camera image transport and picture files on the microSD card

Lane 6 of the PC-software pass. This is static analysis of the images on disk
(`decrypted\`). Nothing was written to a radio. I used two private IDA
databases, `ida\db\jobs\PC_L6_MAIN` (copied from MAIN_FULL) and `PC_L6_SUB`
(copied from STOR_SUB). The scripts are `ida\jobs\pc_l6_dump.py` and
`pc_l6_grep.py`. The raw dumps are `ida\out\pc\L6_*.txt`, and the table is
`ida\out\pc\L6-camera-path.tsv`.

## Verdict

1. **Refuted: the camera does not use SCI-B `0xFFFF60`.** SCI-B is the
   **APRS/AX.25 packet-modem input**. Its parser `sub_48C44` is a software
   HDLC deframer, and it is byte-confirmed. The parser bit-reverses each
   ring byte (`0x48E88`), searches for flag `0x7E`, removes the stuffed 0
   that follows five 1s, and aborts on seven 1s. A frame must be `0x14`–`0x14D`
   bytes long and goes to `0xFFA1AE`. The FCS check at `sub_4986A` is the
   CRC-16 CCITT in reflected form: poly `0x8408`, held byte-swapped as
   `0x0884`, with the good residue `0xF0B8` (`cmp.w #0xB8F0`, `0x49904`).
   Byte `':'` is then tested as the APRS message type (`0x4994A`). The enable
   byte `0xFF8AA0` is the APRS modem setting: 0 = off, and 2 selects the
   alternate bit mode `0xFF9DDE`. The init values `SMR=0`, `BRR=0x0C`,
   `SCR=0x30` (38400 8N1) stand as found. The "SCI-A→SCI-B bridge" in
   doc 05 is therefore an external-port-to-packet-modem path, not a camera
   path.
2. **Confirmed: the camera is a USB host on MAIN's USB Function module, and
   the radio is the device.** The default USB personality from doc 15
   (vendor-specific, `VID 0x26AA PID 0x0001`) is the camera protocol. So
   `USB CAMERA` is a literal label.
3. The image travels camera → MAIN EP1 bulk OUT → MAIN 1 KB buffer →
   256-byte IPC blocks on SCI-D → SUB SDRAM `0x070E1000` → SUB JPEG preview →
   on user confirm, SUB writes **`I:\PHOTO\H<ID5>0<NNNNN>.jpg`**. The file
   is the **raw JPEG bytes as received** (no header or trailer). MAIN then
   appends a 128-byte index record and a 4-byte FAT entry in
   `I:\QSOLOG`, and updates the counters in `QSOMNG.dat`.

## 1. USB camera protocol (MAIN, H8S, big-endian)

### Descriptors (byte-confirmed in the image)

- Device, `0x055817`: `12 01 00 02 00 00 00 08 AA 26 01 00 00 00 00 00 00 01`.
  That is USB 2.0, EP0 max packet 8, VID `0x26AA`, PID `0x0001`, and one
  configuration.
- Configuration, `0x05582A`: `09 02 20 00 01 01 00 C0 32` (self-powered,
  100 mA).
  - Interface: `09 04 00 00 02 FF 01 FF 00` (vendor class `FF/01/FF`, two
    endpoints).
  - `07 05 01 02 40 00 00`: **EP 0x01 bulk OUT, 64 bytes** (image data).
  - `07 05 83 03 08 00 xx`: **EP 0x83 interrupt IN, 8 bytes**. There are
    five copies with bInterval `0x64`, `0x14`, `0x96`, `0xC8` and `0xFA`.

### Vendor requests (SETUP filter at `0x055074`)

Every handler copies the 8-byte SETUP packet from ring
`0xFF3CEA..0xFF3D69` to `0xFF3D6A` and compares its first word.

| SETUP (bmRequestType bRequest) | Handler | Effect |
| --- | --- | --- |
| `41 D1` (vendor, host→device, interface) | `0x05540C` | **Start of image.** Size = `wIndexL<<16 \| wValue` (bytes `0xFF3D6E/6D/6C`), stored in `0xFFB098`, `0xFFBA46` and `0xFFBA6E`. The 64-byte packet count goes to `0xFFB09C`. A new index record is started: template `0x6F534` via `sub_6F512`, filled by `sub_6A700`. Refused (`0xFFBA72=1`) while `0xFF94C0≠0` or `0xFF2EC9≠0` (busy). |
| `41 D2` | `0x0555F4` | **End of image.** `sub_559F4` sends the partial last block, then `0xFF2EC9=0`. |
| `41 D3` | `0x0554E6` | 1-byte status `wValueL` → `0xFFB096`, consumed by a table dispatch at `0x0FDC8`. *Meaning unknown.* |
| `C1 D4` (device→host) | `0x0552D8` | Returns 1 byte: `0x18`, `0x30` or `0x50` for `0xFF89CD` = 0, 1 or 2. *Inferred:* this is a JPEG-quality code (LOW/NORMAL/HIGH). |
| `80 06` | `0x0550D8` | Standard GET_DESCRIPTOR. |

**Bulk data** (`0x055652`): the handler reads `0xFFEE25` bytes from EPDR
`0xFFEE10` into `0xFF5806 + n`, then writes `0xFFEE2C = 0x20`. Each time a
256-byte boundary is crossed (`sub_55976`), `sub_B610` forwards that block to
SUB.

**Interrupt IN** (`0x054F4E`, `0x0551DA`, `0x0557A2`): 3 bytes
`[0xFF8184 cmd][0xFF89CE][quality code]` go to EPDR `0xFFEE18`, then
`TRG=0x40`. The message is sent whenever the command or the settings change.
`0xFF8184` is written by `0x39462` (=1) and `0x393DC`. *Inferred:* it is a
camera enable/mode command, gated by radio state.

`0xFF89CD/CE/CF` are loaded by the settings loader `sub_DEFA` (defaults
0/0/1, `0x0E63C`). *Inferred:* they are MAIN's copy of SUB's `QUALITY`,
`SIZE` and `SP SEL` fields (doc 14, `0x8C4D+0x22..0x24`).

## 2. MAIN → SUB block transfer (IPC, SCI-D `0xFFF610`)

`sub_B610` builds the block and `sub_B6B6` checksums it and sends it with
`sub_482D4`, the SCI-D DMA-0 transmit driver. All fields are big-endian. The
wire frame (0x116 bytes) is copied from `0xFF3D74`:

```
+0x00 u16 0xFFFF            command = image block
+0x02 u16 0x010C            sub-length = data length + 0x0C
+0x04 u16 hdrsum            byte sum of +0x00..+0x03
+0x06 u16 block#            1-based (0xFFBC40, pre-incremented)
+0x08 u16 total blocks      ceil(size/256) (0xFFBC42, loc_55B28)
+0x0A u32 running sum       sum of all image bytes sent so far (0xFFBC44)
+0x0E 256 bytes image data  (a short last block shrinks len/sub-length)
+0x10E u16 sum              byte sum of +0x00..+0x10D
+0x110 6 x 0x00
```

The SUB end stores block *n* at **`0x070E1000 + (n-1)*0x100`**
(`0xFFEDC515`, `0xFFEDCB27`), with payload length = sub-length − `0x0C`. SUB
then decodes the picture for preview with `sub_FFEDE804` → `sub_FFF4B084`
(baseline JPEG decoder). The decoder reads from the input window
`0x070E1000` (**`0x14000` = 81,920 bytes**) and writes RGB565 320×240 to
`0x070BB800` (`0x25800` bytes). The consumed JPEG length goes to `[0x1CC58]`
and the dimensions to `0x1230C` (compared with `0x140` = 320).

The reverse direction, SUB → MAIN, uses SCI-D frame type `0xFF` (length
`0x112`) into `0xFF9800`. It is validated at `sub_55DFC`: sub-length at +2
(minus `0x11`, at most 0x100), block number at +0x0B, total at +0x0D, a u32
sum at +0x0F checked on the last block, and data at +0x13. This streams a
stored picture back to MAIN. *Inferred:* it is used for C4FM picture
transmit and re-save.

## 3. The save: file request → microSD

When the user confirms in the picture dialog (key table `0x2AC96`, then
`0x2AC4C` → `sub_55A42` → `sub_710D2`), MAIN queues an SD request. The
request is the `0xFFBA30` state machine; `sub_71196` builds the IPC packet
from template `0x071326`.

Request header (0x90 bytes, then optional inline data):

| Offset | Field | Camera save |
| --- | --- | --- |
| +0x00 | total length u16 (0x90 + data) | 0x90 |
| +0x10 | op: 1 = `"w"` create, 2 = `"a"` append, 3 = `"r+"` update at offset (SUB `0xFFF3CA3B`); also 0x0B, 0x14, 0x50, 0x64 (not decoded) | 1 |
| +0x12 | param. 4 = data comes from SUB picture buffer `0x070E1000` (`sub_FFF3C911`) | 4 |
| +0x14 | dir index into SUB `0xFFED8318`: 0 FT3D, 1 FT3D\BACKUP, 2 FT3D\GPSLOG, 3 FT3D_MEMORY-CH, 4 QSOLOG, **5 PHOTO**, 6 VOICE | 5 |
| +0x56 | file name (length in `0xFFBAD4`) | 16 chars |
| +0x76 | u32 size / length | `0xFFBA46` |
| +0x7A | u32 file offset | — |

SUB parses the header in `sub_FFF3E4A7` into 0x24-byte slots at RAM
`0x683D0`. It builds `"I:\"` (`0xFFF4AFF3`) + `"PHOTO"` + `"\"`
(`0xFFF4B003`) + name, then calls `sub_FFF12C25` with mode 0 = `"w"`
(`0xFFF4ADAC`). The source is `0x070E1000` and the length is `[0x1CC58]`
(`sub_FFEDE93A`). **So the on-card `.jpg` is exactly the JPEG byte stream
from the camera, with no wrapper.** Its length is what the decoder consumed.
*Inferred:* that length runs through EOI.

### Filename (`sub_6EE38`, byte-confirmed)

```
'H' + 5 bytes @0xFF8060 + '0' + DDDDD + ".jpg"          (16 chars, e.g. "HE1abc000123.jpg")
DDDDD = decimal of u16 @0xFEEF12, printed then incremented and stored;
        if value >= 60001 the digits are "00000" (no increment)
```

*Inferred:* `0xFF8060` is the radio's own 5-character C4FM Radio ID. It is
also copied to record offset +0x19, and it is written from the DSP region
(`0x742A8`).

## 4. The index files in `I:\QSOLOG` (all big-endian)

After the save, `sub_6A802` → `sub_6F2AC` run this sequence:

1. **`QSOPCTDIR.dat`**: append (op 2, template `0x7218A`) the 128-byte record
   at `0xFF2F4A`. The record number is n = `u16 @0xFEEF10` + 1 (1 if the
   value is `0xFFFF`).
2. **`QSOPCTFAT.dat`**: append (op 2, template `0x722B6`) 4 bytes,
   `((n-1)*0x80) | 0x40000000`.
3. **`QSOMNG.dat`**: rewrite offset 0, length `0x20` (op 3, template
   `0x720F4`), from `0xFEEF00`. Here `+0x10` = picture count n and `+0x12` =
   next photo serial. *Inferred:* `+0x00` is the message count; it is used
   by the QSOMSG path.

### QSOPCTDIR record, 128 bytes

Built from default template `0x6F534`, then `sub_6A700` (camera) or
`sub_6A462`/`sub_6A4DE`/`sub_6A628` (received picture).

| Off | Len | Content | Source / default |
| --- | --- | --- | --- |
| 0x00 | 1 | flags. Camera = 0. Bit 4 comes from `0xFFB266` bit 7, bit 3 and bits 0-2 = type | 0 |
| 0x02 | 2 | received pictures only: `0xFFB422` | 0 |
| 0x04 | 21 | sender call/ID (0x0F or 0x15 bytes, depending on flags), received only | spaces |
| 0x19 | 5 | radio ID `0xFF8060` | spaces |
| 0x1E | 10 | own callsign `0xFFA8DA` | spaces |
| 0x28 | 6 | unused | spaces |
| 0x2E | 18 | 6 × (3-byte BCD date YYMMDD from `0xFFA9C4` / 3-byte BCD time HHMMSS from `0xFFA9C8`). Camera: all three pairs = now. Received: +0x3A = 6 bytes packed from 12 ASCII digits at `0xFFB20E` | 00 |
| 0x40 | 16 | ASCII `"20YY/MM/DD HH:MM"` (`sub_6A8AA`). Received: 16 bytes from `0xFFB23C` | spaces |
| 0x50 | 4 | u32 JPEG size (`0xFFBA46`; received: `0xFFB208`) | 0 |
| 0x54 | 16 | file name `H…….jpg` | spaces |
| 0x64 | 20 | position block. Camera: filled only if `sub_230CE` succeeds (*inferred:* GPS fix), else `0xFF`×20. Received: `0xFFB22A` unless it equals the "no position" pattern `0x5F88A` | FF |
| 0x78 | 8 | zero | 0 |

## 5. Received-over-air pictures (C4FM)

Received pictures use the same writer. `sub_55A70` → `sub_710C4` enters
`sub_710DE` with the size from `0xFFB208`, so the request is again op 1,
param 4, dir 5, and the name again comes from `sub_6EE38` (the own-ID `H…`
pattern). The index record is built by `sub_6A462`/`sub_6A4DE` and appended
through the same three-step sequence (`sub_6A5C8` → `loc_6A84C`). *Inferred:*
I did not trace the DSP-side source that fills the receive header
(`0xFFB20E`/`B22A`/`B23C`/`B208`).

## 6. What a PC program must do

**Reading the card.** `I:\PHOTO\*.jpg` are plain baseline JPEGs; open them
as they are. To get metadata, read `I:\QSOLOG\QSOPCTFAT.dat` as 4-byte BE
entries. Mask off `0x40000000` to get the byte offset into `QSOPCTDIR.dat`,
then parse the 128-byte records above. The count is `QSOMNG.dat` +0x10
(u16 BE).

**Writing a picture the radio will list** (for example, to send it from the
radio):

1. Encode a baseline (not progressive) JPEG, 320×240 or 160×120, no larger
   than **81,920 bytes** (the SUB decode window). *Inferred as a hard
   limit.*
2. Name it `H` + the radio's 5-character ID + `0` + a 5-digit serial +
   `.jpg`, and put it in `\PHOTO\`.
3. Append a 128-byte record to `\QSOLOG\QSOPCTDIR.dat`: flags 0, ID at
   +0x19, callsign at +0x1E, BCD date/time, the ASCII date at +0x40, the
   size at +0x50 (u32 BE), the file name at +0x54, and +0x64 = 20×`0xFF`.
   Append `((n-1)*0x80)|0x40000000` to `QSOPCTFAT.dat`.
4. Set `QSOMNG.dat` +0x10 = n, and set +0x12 above your serial so the radio
   does not reuse it.

Caveat: whether MAIN validates these `.dat` files when it reads them back
is residual #3, which is still open. Keep a copy of the card files before
editing.

**Alternative, live path.** A PC is also a USB host, so it can **stand in
for the camera**. Open `26AA:0001`, send vendor OUT `41 D1` with wValue =
size[15:0] and wIndex low byte = size[23:16]. Stream the JPEG on bulk
EP 0x01 in 64-byte packets, then send `41 D2`. The radio then shows the
normal snapshot preview and save/send dialog. `C1 D4` reads the quality
code, and EP 0x83 reports `[cmd, size, quality]`. The descriptors and
requests are byte-confirmed. That the radio accepts a non-camera host at
runtime is *inferred*: there is no host-identity check in the handlers I
read.

## Unknowns

- What the `41 D3` status values mean, and what the `0xFF8184` command
  values mean.
- The quality/size mapping of `0xFF89CD`/`0xFF89CE`. The code values
  `0x18`/`0x30`/`0x50` are confirmed; their mapping to the menu labels is
  inferred.
- File ops `0x0B`/`0x14`/`0x50`/`0x64` are not decoded (0x0B on PHOTO is
  probably delete or read).
- The meaning of bit 30 in the FAT entry and of the other flag bits.
- The DSP → MAIN source for received C4FM pictures.
