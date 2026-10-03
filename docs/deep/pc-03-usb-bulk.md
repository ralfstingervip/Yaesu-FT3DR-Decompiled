# PC lane 3 - USB vendor-bulk personality (26AA:0001), the "snapshot camera" transport

Scope: owner-side static analysis of `decrypted\FT3D_MAIN_ver102_EXP.bin`
(H8S/2456 group, big-endian, load base 0) for a PC interoperability program.
Nothing is written to a radio. Addresses are file offsets = CPU addresses (base 0);
`0xFFxxxx` are on-chip RAM/SFR addresses (IDA also aliases them to `0xFFFFxxxx`).
Reproduce with `python ida\run_job.py --reopen --db PC_L3 --script ida\jobs\pc_l3_dump.py`.

## 1. Summary / verdict

The default MAIN USB personality (`0x26AA:0x0001`, selected when selector
`0xFF813A == 0`) is a **USB *device*** that a **USB host** (PC or the Yaesu snapshot
accessory) drives. It is the transport for the FT3DR **picture/"snapshot"** feature:
the host pushes a **JPEG image into the radio** over one bulk-OUT endpoint, framed and
controlled by vendor control requests on EP0; the radio hands the image to the SUB
processor for display/store. There is **no bulk-IN endpoint** - image data flows
host -> radio only. The prior lane-3 findings are confirmed; two are refined below.

- Confirmed: descriptor at `0x055818`; one interface FF/01/FF; EP1 bulk OUT 64B;
  EP3 interrupt IN 8B; poll-driven state machine (JSR at `0x002BE8` into `0x054FEC`,
  table at `0x055002`); JPEG/picture-header builders `sub_6F512`/`sub_6A700`/`sub_6A802`;
  SUB forward via `sub_B610`->`sub_B6B6`; SIZE/QUALITY in `0xFF89CE`/`0xFF89CD`.
- Refined 1: the 8-byte units the state machine at `0x055002` decodes are **literal
  USB SETUP packets** (the table at `0x0558FE` holds SETUP patterns, e.g.
  `80 06 00 01 ..` = GET_DESCRIPTOR). So `0x055002` **is** the EP0 request decoder,
  fed from a SETUP ring queued by the on-chip USB-module ISR `sub_54EC2` (`0x054EC2`).
- Refined 2 (doc-08 conflict): this personality **is** USB and is the "USB CAMERA"
  snapshot path. Doc-08's "USB CAMERA is not USB" does not hold for this image - the
  bulk/EP0 machinery here is real USB device firmware. Noted as a contradiction.
- Confirmed absent: no request reaches arbitrary memory R/W, flash write, clone data,
  or the DATA-jack CAT table. The entire accepted request set is
  GET_DESCRIPTOR + vendor `0xD1`-`0xD4` + chapter-9 enumeration; all effects are
  confined to camera/image buffers and the SUB link.

## 2. Descriptors (byte-confirmed, hex dump at `0x055818`)

Device descriptor `0x055818` (18 bytes):
`12 01 00 02 00 00 00 08  AA 26 01 00 00 00 00 00  00 01`
= bcdUSB 2.00, class/sub/proto 0 (per-interface), bMaxPacketSize0 **8**,
idVendor **0x26AA**, idProduct **0x0001**, 0 strings, 1 configuration.

Config descriptor `0x05582A` (wTotalLength 0x20 = 32):
- config: 1 interface, bmAttributes 0xC0 (self-powered), bMaxPower 0x32 (100 mA)
- interface `0x055833`: num 0, alt 0, 2 endpoints, class **0xFF** / sub **0x01** / proto **0xFF**
- endpoint `0x05583C`: `07 05 01 02 40 00 00` = **EP1 OUT, bulk, 64 bytes**
- endpoint `0x055843`: `07 05 83 03 08 00 64` = **EP3 IN, interrupt, 8 bytes, bInterval 0x64**

Config-descriptor variant table at `0x05584A` points to 5 alternate config blocks
(`0x05585E`, `0x05587E`, `0x05589E`, `0x0558BE`, `0x0558DE`) that differ **only** in
the EP3 interrupt `bInterval` (0x14, 0x64, 0x96, 0xC8, ...). The variant returned by
GET_DESCRIPTOR(CONFIG) is chosen from camera setting `0xFF89CF` (read at `0x0550FE`).

## 3. Dispatch path (byte-confirmed)

Main loop -> `sub_2092`: at `0x002BE2` `mov.b @0xFF813A; bne skip; jsr 0x054FEC`
(`0x002BE8`). So the state machine runs only in the default personality
(`0xFF813A == 0`). `0x054FEC` reads state var `0xFF8183`, `shll.l #2` (x4), indexes
the 12-entry jump table at `0x055002`:

| state | handler | role |
|---|---|---|
| 0 | 0x055034 | dequeue an 8-byte SETUP from RX ring, classify (see 4) |
| 1,5 | 0x055042 | (re-entry into state-0 body) |
| 2 | 0x055196 | wait EP done flag (EE `0xFFEE`.. bit3), advance |
| 3 | 0x0551AA | wait EP done bit4, advance |
| 4 | 0x0551C2 | wait EP done bit3, advance |
| 6 | 0x0551DA | picture-size negotiate; handle GET 0xD4 (C1D4) |
| 7 | 0x055306 | handle 0x41D1 (start JPEG) / 0x41D3 (set param) |
| 8 | 0x055520 | receiving image payload |
| 9 | 0x055552 | end-of-buffer handling (`sub_55652`) |
| 10 | 0x055306 | (reuse) |
| 11 | 0x0556C8 | (final) |

SETUP packets are queued into a RX ring (`0xFF3CEA`..`0xFF3D6A`, read ptr `0xFF8152`,
write ptr `0xFF8158`) by the USB-module ISR `sub_54EC2` (`0x054EC2`, ends in RTE;
services on-chip USB registers `0xFFEE00`.. - EE01/EE02 flags, EE0C EP0 FIFO, EE18
EP data, EE2C trigger). Bus reset (EE01 bit0, `0x054EF0`) zeroes `0xFF8183` and resets
the ring - i.e. standard chapter-9 enumeration lives in the ISR, the vendor/descriptor
data stages in the poll loop via `sub_55144` (`0x055144`, copies N bytes to EP0 FIFO
`0xFFEE0C` and sets EE2C=1).

## 4. EP0 requests accepted (see `ida\out\pc\L3-usb-requests.tsv`)

First SETUP dword is at `0xFF3D6A`; `e2` (bytes 0-1) = bmRequestType:bRequest.
Recognized values (compared at `0x05507C`..`0x055098`): `0x8006`, `0xC1D4`,
`0x41D1`, `0x41D2`, `0x41D3`. The table at `0x0558FE` holds canonical 8-byte SETUP
templates matched against the received packet.

- **GET_DESCRIPTOR (0x8006)**, wValueH selects: 1=device -> 18 B @`0x055818`;
  2=config -> 32 B @`0x05582A` (variant by `0xFF89CF`); 3=string -> none. Byte-confirmed.
- **0xD4 IN** (bmRequestType 0xC1, wLength 1): returns 1 byte = size/quality code
  (`0x18`/`0x30`/`0x50` derived from `0xFF89CD`), handler `0x0552D8`. Read status.
- **0xD1 OUT** (0x41): **start JPEG receive**. 24-bit length in the SETUP wValue/wIndex
  (read at `0xFF3D6C`, `0x05543E`), divided by 64 -> packet count `0xFFFFB09C`; calls
  header builders `sub_6F512`/`sub_6A700`; state -> 8. Handler `0x055414`.
- **0xD2 OUT** (0x41): **end/commit frame** - bumps counter `0xFFFFBA73`, calls
  `sub_559F4`. Handler `0x0555F4`.
- **0xD3 OUT** (0x41): set a transfer parameter from the SETUP (`0xFF3D6C`->`0xFFB096`).
  Handler `0x0554E6`.

## 5. Bulk-OUT framing (as visible)

After 0xD1, the host streams the JPEG as raw bytes in 64-byte EP1-OUT packets
(count = ceil(len/64)). No length/CRC wrapper is added by the host beyond the JPEG
itself; the firmware tracks remaining packets in `0xFFFFB09C` and reassembles into the
image buffer, then forwards to SUB as MAIN->SUB link frames via `sub_B610`->`sub_B6B6`.
Header/JPEG-structure synthesis is `sub_6F512`/`sub_6A700`/`sub_6A802`. (Reassembly and
SUB forward are inferred from call sites `0x05547A`, `0x0559DA`, `0x055A06`, `0x055D32`;
the 64-byte packetization and packet count are byte-confirmed.)

## 6. Interrupt-IN (EP3) 8-byte report

Builder `sub_557A2` (`0x0557A2`, single caller `0x074B0C`): writes the current camera
**SIZE** code (`0xFF89CE`, at `0x0557B4`/`0x0557E4`) and a picture-dimension/**QUALITY**
code (`0x18`/`0x30`/`0x50` from `0xFF89CD`) into the endpoint data register and triggers
send (EE2C=0x40). Byte0=size, byte1=quality are byte-confirmed; the full 8-byte layout
is not fully enumerated in this routine (remaining bytes inferred as reserved/status).

Camera settings: `0xFF89CD` (quality/size index 0/1/2), `0xFF89CE` (size code),
`0xFF89CF` (config-variant / poll-rate). All three are set by the menu routine
`sub_DEFA` (`0x0E63C`/`0x0E642`/`0x0E648`) and read by display `sub_594C`.

## 7. What a PC program can do, and driver approach

The PC is the **USB host**. Over `0x26AA:0x0001` a PC program can:
1. Enumerate and read the standard descriptors.
2. Query current picture SIZE/QUALITY with vendor IN request `0xD4` (1 byte), and read
   the 8-byte interrupt-IN status on EP3.
3. **Push a JPEG into the radio**: vendor OUT `0xD1` with the 24-bit length in
   wValue/wIndex, then stream the JPEG in 64-byte EP1-OUT packets, then vendor OUT
   `0xD2` to commit. `0xD3` sets an auxiliary parameter first if needed.

There is no path to read the radio's memory, flash, or clone/CAT data through this
interface - it only ingests a picture. It cannot pull images out (no bulk IN).

Driver approach: the interface is vendor-specific (class 0xFF), so **WinUSB** (a custom
INF binding `WinUSB.sys` to `USB\VID_26AA&PID_0001`) or **libusb / libusbK** is the
right choice - `libusb_control_transfer` for EP0 (GET_DESCRIPTOR + vendor D1-D4) and
`libusb_bulk_transfer` to EP1 OUT for the JPEG, `libusb_interrupt_transfer` on EP3 IN
for status. No Yaesu kernel driver is required for the raw transfers.

> **Orchestrator correction (2026-09-27):** an earlier draft said `HMSEUSBDRIVER.exe` /
> `RFP_USB_VB.dll` drive this personality. They do not: per doc 10 they are Renesas's
> boot-mode stack (`HmseUsb.sys`, `VID_045B&PID_0025` only), and nothing in the update
> package references VID `0x26AA`. No PC-side driver for `26AA:0001` ships in this tree.

## 8. Confidence notes

Byte-confirmed (address cited above): descriptors, VID/PID, endpoint set, dispatch
gate, state table, all recognized SETUP opcodes and their handler addresses, the 64-byte
packetization and packet-count math, and the two interrupt-report fields. Inferred:
image-buffer reassembly internals and the SUB-forward semantics (from call sites, not
traced end to end), the un-enumerated bytes of the 8-byte interrupt report, and the
exact meaning of the size/quality code values (0x18/0x30/0x50).
