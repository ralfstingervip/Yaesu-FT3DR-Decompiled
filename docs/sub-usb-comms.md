# FT3DR ver 1.02 SUB USB communication map

Scope: the USB *communication* implementation in the ver 1.02 SUB image
`decrypted/FT3D_SUB_ver102_ALL.bin` (4,194,304 bytes, little-endian, base `0xFFC00000`,
Renesas RX64M). This is the register/init/pipe/descriptor question. The setup-menu
count/pointer record table and the `FFED75A8`/`FFF08980` menu-walker chain are covered
in `docs/sub-usb.md` (another agent) and are not repeated here.

Nothing here was written to a radio. `Firmware/` and `decrypted/` were not modified.
No IDA database was opened for this pass; the findings come from a direct decode of the
plaintext image (scripts in a local-temp directory, not in this repo).

## Result (headline)

The SUB RX64M application image does **not** contain a USB communication stack.
No instruction anywhere in the 4,194,304-byte image addresses the RX64M USB0 register
window `0x000A0000`–`0x000A03FF`, no base pointer to that window exists (as an
instruction immediate or inside any pointer table), there are no USB descriptor tables,
and there are no USB class strings. The SUB path is therefore neither a USB device
(peripheral) nor a USB host at the application level.

The only USB in the FT3DR update system is the Renesas boot-ROM programming device
(`VID_045B&PID_0025`, per the update manual). That boot loader lives in the RX64M boot
ROM, not in this application image, and is out of scope. The `USB` text that appears in
this image is user-interface text, not a USB stack (see below).

## 1. USB0 register-window accesses — none

The RX64M USB0 (USBb, full-speed peripheral) register block is `0x000A0000`–`0x000A03FF`
(SYSCFG `+0x00`, SYSSTS0 `+0x04`, DVSTCTR0 `+0x08`, CFIFO `+0x14`, INTENB0 `+0x30`,
INTSTS0 `+0x40`, PIPExCTR, etc.).

On RX / CC-RX, a peripheral register is reached by loading its base address into a
register with the `MOV.L #imm32, Rd` instruction (opcode `FB`, second byte
`[rd:4][li:2][10]`, immediate little-endian; `li` 0/1/2/3 = 4/1/2/3 immediate bytes),
then a `MOV.B/.W/.L dsp[Rd]` access. The reset handler itself shows the form, e.g. at
file `0x17`: `FB E2 70 8A ED FF` = `MOV.L #0FFED8A70h, R14`.

Scanning the entire image for that immediate form:

- **`FB`-form `MOV.L #imm` with the immediate inside `0x000A0000`–`0x000A03FF`: 0 sites.**
- **`FB`-form `MOV.L #imm` anywhere in `0x00090000`–`0x000BFFFF` (the whole USB0/parent
  region): 0 sites.** There is a hard gap: the peripheral bases the firmware loads stop
  at `0x0008FD75` and resume at `0x000C0821`. Nothing is loaded in between, which is
  exactly where USB0 (`0x000A0000`) sits.

For comparison, the same scan finds **885** `FB` immediate loads in the RX peripheral I/O
region `0x00080000`–`0x000FFFFF`, so the firmware does actively drive on-chip peripherals
through the standard CC-RX immediate-base pattern — it simply never targets USB0. Bases
that are loaded and identifiable include:

| Base immediate | Count | RX64M peripheral |
| --- | --- | --- |
| `0x00080000` | 13 | SYSTEM (MDMONR/SYSCR area) |
| `0x00080010` | 49 | SYSTEM MSTPCRA / module-stop block (`+0x04`=MSTPCRB, `+0x08`=MSTPCRC) |
| `0x0008C000` | 12 | PORT (PDR group) |
| `0x0008C11F` | 28 | MPC.PWPR (pin-function write-protect) |
| `0x0008C1xx` | many | MPC PmnPFS pin-function-select registers |

(Example load sites: `0x00084208` base at `FFD60434`; `0x0008630C` base at `FFE6AAB0`;
`0x0008733A` base at `FFEDB300`.) The point is only that the scanner detects real
peripheral-base loads; USB0 is absent from the results.

### The apparent "USB0 dword" data is not operands

A raw byte scan of the whole image finds 87 little-endian and 108 big-endian dwords whose
value falls in `0x000A0000`–`0x000A03FF`. Every one is data, not an instruction operand,
and each is the "run of 16-bit values" pattern the survey rules exclude. Two
representative shapes, dumped as aligned dwords:

```text
FFEB7568: 00060005 00080007 000A0009 000C000B 000E000D   ; monotonic u16 table 5,6,7,8,9,10,11,12,13,14
FFED1F4C: FFFF0000 00000000 000A0001 FFD827D4 FFFF0000   ; {u16,u16,code-ptr} record; 0x000A is a count/id, next dword is a real code pointer
```

In the first, `000A0009` is simply the u16 pair `9,10`. In the second, `000A0001` is the
u16 pair `1,10` inside a dispatch record whose following dword (`FFD827D4`, etc.) is a
valid `0xFFC00000`-region code pointer. None of the aligned occurrences form a
peripheral-base pointer table (no array of `0x000Axxxx` I/O bases anywhere). So there is
no indirect route to USB0 either.

## 2. USB init / interrupt / pipe / FIFO / endpoint routines — none

Because no code addresses `0x000A0000`–`0x000A03FF`, there is no USB controller init, no
USB interrupt service routine, no pipe or FIFO (CFIFO/D0FIFO/D1FIFO) handler, and no
endpoint transfer routine to enumerate. The IDA survey reached the same result from the
other direction: recursive descent from reset, the fixed vectors, and their call graph
recovered 455 functions (`ida/out/survey/SUB/functions.tsv`) and
`ida/out/survey/SUB/usb_operands.tsv` has zero USB0 operands
(`usb_coverage.txt`: `functions_visited=455 ... equal=yes`). This pass extends that check
to the *uncovered* code (the other ~97% of the image) via the whole-image `FB`-immediate
decode above, and still finds nothing.

Interrupt vectoring context (for completeness): reset at `0xFFC00000` sets `EXTB` to the
fixed vector table at `0xFFFFFF80` and `INTB` to the relocatable vector table at
`0xFFED8A70` (file `0x2D8A70`). RX64M routes USB0 through relocatable vectors
(USBI0/USBR0 and the D0FIFO0/D1FIFO0 group). Since no routine in the image touches USB0
registers, whatever occupies those INTB slots is not a functioning USB ISR.

## 3. USB descriptor tables — none

Signature scans of the whole image:

- Device descriptor (`0x12 0x01` + a valid bcdUSB of `0x0100/0x0110/0x0200/0x0201/0x0210`):
  **0 matches.**
- Configuration descriptor (`0x09 0x02` + plausible wTotalLength and bNumInterfaces):
  **0 matches.**

There is no device/config/interface/endpoint/string descriptor set, and therefore no
VID/PID, bcdUSB, or class/subclass fields to decode in this image.

## 4. Device vs host, and class — neither

With no USB0 register access, no descriptors, and no class code, the SUB image implements
**neither a USB device (peripheral) nor a USB host**, and **no USB class** (not CDC, HID,
MSC, audio, or vendor). Evidence for the negative:

- USB0 window never addressed (section 1).
- No descriptors (section 3).
- No USB class strings. The only `USB` substrings in the image are UI text:
  - `FFC3E709` "USB CAMERA" — a setup-menu label (the 20-byte setup-label table).
  - `FFF4AA12` "USB " — a display/status message string.
  The apparent `CDC` at `FFC3BEB2` is inside a token run `...CDCECFCGCHCICJCKCL...` (coded
  labels), and the two `HID` hits (`FFC162B2`, `FFC17D26`) sit inside binary display/font
  data. None are USB class identifiers.

## 5. Extent decoded / scanned

- Whole-image `FB`-form `MOV.L #imm` decode across all 4,194,304 bytes: 0 immediates in
  `0x000A0000`–`0x000A03FF`; 0 in `0x00090000`–`0x000BFFFF`; 885 in the wider peripheral
  region `0x00080000`–`0x000FFFFF` (all non-USB, tabulated above).
- Whole-image little-endian and big-endian dword window scan (`0x000A0000`–`0x000A03FF`):
  87 LE / 108 BE, all data (16-bit value runs / `{u16,u16,ptr}` records), 0 operands.
- Aligned-dword pointer-table check on every window value: no peripheral-base pointer
  array.
- Descriptor signature scan (device `0x12 0x01`, config `0x09 0x02`): 0.
- USB / class string scan: only the two UI strings above.
- Cross-check against the prior IDA survey of the 455 recovered functions: consistent
  (zero USB0 operands there too).

Summary line: the entire 4,194,304-byte SUB image was decoded for RX `FB` immediate
operands and scanned for USB0-window dwords, descriptors, and USB strings; the USB0
register window `0x000A0000`–`0x000A03FF` is never addressed by any instruction and no
USB stack, descriptor, or class is present — the scan stopped at full image coverage with
a clean negative result.
