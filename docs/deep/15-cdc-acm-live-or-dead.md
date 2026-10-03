# The second MAIN USB stack (CDC-ACM `0x07B680`): live or dead

Agent USB-ADJUDICATE. Subject: `decrypted\FT3D_MAIN_ver102_EXP.bin` (1,048,576
bytes, base 0, big-endian). Private database `USB_ADJ`, seeded `--copy-from
ida\db\radio\MAIN.i64`. Machine-readable tables in `ida\out\usb-adj\`:
`evidence.tsv`, `relocation.tsv`, `usbadj_disasm.txt` (all cited disassembly,
reproducible with `ida\jobs\usbadj_probe.py --reopen`).

> Addressing note. The IDA h8s module renders register-page absolute operands as
> 32-bit sign-extended addresses, so the selector the two prior reports call
> `0xFF813A` appears in the disassembly as `0xFFFF813A`, the USB block `0xFFEE00`
> as `0xFFFFEE00`, port input `0xFFFF4C` as `0xFFFFFF4C`. Same physical registers;
> I keep the 24-bit `0xFF….` form in prose to match the brief and use IDA's
> `0xFFFF….` form only where I quote a disassembly line.

## Verdict

**The CDC-ACM stack is LIVE code, not dead linked-in library data. MAIN-IO is
right; DSP-AMBE's "dead" conclusion is wrong — but its underlying observation is
true and is the whole reason the mistake was made.** Every load-bearing claim
MAIN-IO made is confirmed at the byte and instruction level: the `.data`
initialiser at `0x002152` copies `0x4AE` bytes from `0x07B2A6` to `0xFF6034`
(confirmed by the `EEPMOV.W` and its three operand loads); the descriptor
pointer table at `0x07B5F0` holds `0xFF640E` and `0xFF649F`, which are *exactly*
where the device descriptor (`0x07B680`) and configuration descriptor
(`0x07B711`) land under that copy; the boot strap path calls `0x078106`, which
reads the USB interrupt-enable registers and enables the on-chip USB module
(`bset #2, @0xFFEE2D`); and the one physical USB interrupt handler `sub_54D50`
reads the selector `0xFF813A` and, when it is non-zero, hands the interrupt to
the stack-2 service routine at `0x07827C`, which drives the USB flag/trigger
registers directly. DSP-AMBE correctly found that *no instruction references the
flash addresses `0x07B680`/`0x07B711`* — I reproduce that negative over the whole
image — but that is because the descriptors are reached through their **RAM
images** after the copy, never through their flash addresses. The proof that
this is a scanning artefact and not death: **stack 1's own device descriptor at
`0x055818`, which is indisputably served in normal operation, also has zero IDA
xrefs**, because it too is reached by a 32-bit immediate load (`0x055136`). The
IEEE-1284 "ACME Manufacturing" string at `0x07B69C` genuinely is unreferenced
Renesas boilerplate, but it is a separate blob from the CDC descriptors, whose
VID/PID were deliberately set to Yaesu's `0x26AA:0x0020`.

**But the switch-position answer is the part that matters to the owner, and it is
a "no" for normal use.** The CDC personality is **not** the one that comes up in
centre-switch normal operation. The selector `0xFF813A` defaults to `0`
(`0x0021FA`), and only becomes `1` if a specific input line on port `0xFFFF4C` is
held at power-on (`(x & 0x7F) == 0x7D`, internal key code `0x11`). With the
selector at `0` — i.e. every ordinary power-on — boot calls `sub_54BF8` +
`sub_54C44` and the radio enumerates as the **vendor-specific bulk device
`0x26AA:0x0001`, class `FF/01/FF`** — not a serial port. The CDC-ACM virtual COM
port (`0x26AA:0x0020`, `bDeviceClass 0x02`) is a fully-built, reachable,
**held-key-gated service personality**, selected at reset before any UI exists.
So: the radio *can* present a USB serial port, but only when powered on with that
line held; it does **not** present one in default normal operation.

## Method

All disassembly is from database `USB_ADJ` (seeded from the shared
`ida\db\radio\MAIN.i64`, never opened in place). Script
`ida\jobs\usbadj_probe.py`: force-decodes the boot / stack-2 / USB-ISR windows,
dumps annotated disassembly, linear-decodes the two tight init bodies, and takes
an xref census. `auto_wait()` after analysis; `qexit(0)` at the end; body wrapped
in try/except to `ida\log`/`ida\out`. The launcher's `ROOT` is hardcoded to
the repository root (this tree is actually the repository root), so I passed
absolute `--script`/`--copy-from`; my private DB therefore lives at
`ida/db/jobs/USB_ADJ/` — isolated and mine, no shared DB touched.

Independently of IDA I read the raw plaintext bytes for every descriptor,
pointer table and copy operand, and hand-decoded the H8S boot sequence, so the
core chain does not depend on IDA's function recovery. Cross-checks run: a
whole-image byte scan for pointers to the flash descriptor addresses; a code-region
scan for 32-bit-immediate loads of the copied-RAM addresses; and the xref census
on the selector, the USB registers and both stacks' descriptors.

Scope not covered: I did not enumerate the payload semantics of the CDC data
path once enumerated (that is the external-protocol question), and I did not
identify the exact function of all 11 selector readers — I confirmed the two that
decide the personality (`0x054D54` USB ISR, `0x056160` DSP-SCI ISR) and left the
other nine characterised as mode gates. Neither affects the verdict.

## Findings

Adjudicating the specific contested points the assignment named.

### 1. The `.data` copy at `0x002152` — Confirmed, exactly as MAIN-IO stated

Hand-decoded and IDA-confirmed (`usbadj_disasm.txt`, boot section):

```
002152  79 04 04 AE        mov.w  #0x4AE, r4          ; length 1198
002156  7A 05 00 07 B2 A6  mov.l  #0x0007B2A6, er5    ; source
00215C  7A 06 00 FF 60 34  mov.l  #0x00FF6034, er6    ; destination
002162  7B D4 59 8F        eepmov.w                   ; block copy R4 bytes ER5->ER6
```

So `0x07B2A6`–`0x07B753` (`0x4AE` bytes) is copied to `0xFF6034`–`0xFF64E1` at
boot, before the strap test. This is the *only* copy into that RAM window and it
is unconditional. (The search for the length as a 32-bit constant fails because
it is a 16-bit `MOV.W #0x04AE`; that is why a naive constant hunt would miss it.)

### 2. The pointer table holds the descriptors' own RAM images — Confirmed

Raw bytes at file `0x07B5F0`:

```
07B5F0  00 FF 64 0E  00 43  00 FF 64 9F  04 00  00 07 B2 72 …
        \__ptr 0xFF640E__/         \__ptr 0xFF649F__/
```

Relocation arithmetic under the copy above (`RAM = 0xFF6034 + (flash − 0x07B2A6)`):

| structure | flash | RAM image | matches pointer? |
| --- | --- | --- | --- |
| device descriptor | `0x07B680` | `0xFF640E` | **yes** (`0x07B5F0`) |
| config descriptor | `0x07B711` | `0xFF649F` | **yes** (`0x07B5F6`) |
| endpoint I/O table | `0x07B580` | `0xFF630E` | — |
| this pointer table | `0x07B5F0` | `0xFF637E` | (self, relocated too) |

The pointer values are the post-copy RAM addresses to the byte. That can only be
a linker-computed relocation for a `.data` object that is meant to be used from
RAM. Full map in `relocation.tsv`.

### 3. The endpoint table wires the copied RAM straight to the USB engine — Confirmed

File `0x07B580`–`0x07B5BF` (lands at RAM `0xFF630E`) is an array whose entries
embed big-endian pointers to the USB Function Module's data/size registers,
interleaved with copied-RAM size variables:

```
… 00 FF EE 0E (EPDR0S) … 00 FF 64 20 (RAM size) 00 FF EE 0C (EPDR0I) …
  00 FF EE 24 (EPSZ0O) 00 FF EE 0D (EPDR0O) … 00 FF 64 20 00 FF EE 18 (EPDR3) …
```

i.e. a per-endpoint `(size-source, data-register)` table living in the copied
`.data`, pointing at the live registers at `0xFFEE0C/0D/0E/18/24`. This is the
structural link from the descriptor blob to the hardware.

### 4. Boot calls `0x078106`, and `0x078106` enables the USB module — Confirmed

Strap logic in `sub_20FA` (boot), IDA-confirmed:

```
0021FA  mov.b #0,   @0xFFFF813A     ; selector = 0 (default)
0021FE  mov.b #0xC8, r6l            ; 200 polls
002200  mov.b @0xFFFFFF4C, r4l      ; read the strap/key port
002202  and.b #0x7F, r4l
002204  cmp.b #0x7D, r4l            ; bit1 low, rest high?
002206  beq   loc_221E
…                                   ; NORMAL fall-through:
002214  jsr   sub_54BF8             ; stack-1 pipe-config load
002218  jsr   sub_54C44             ; stack-1 init (enables USB, see below)
…loc_221E (STRAP MET):
002224  mov.b #1,   @0xFFFF813A     ; selector = 1
002228  jsr   sub_55FFE
002234  jsr   loc_78106             ; stack-2 (CDC) init
```

Linear decode of `0x078106` (`usbadj_disasm.txt`, "LINEAR" section):

```
078106  mov.l #0xFEE010, er0        ; init USB working RAM 0xFEE010..0xFEE20C
078114  cmp.l #0xFEE20C, er0
07811C  mov.b @0xFFFFEE04, r0l      ; read USB IER0
078132  mov.b @0xFFFFEE06, r1l      ; read USB IER2
078144  mov.l er0, @0xFF62F8        ; build state word in copied-RAM neighbourhood
078154  bset  #2, @0xFFFFEE2D       ; ENABLE the USB Function Module
07815A  rts
```

`0x054CA6` (inside `sub_54C44`) does the identical `bset #2, @0xFFEE2D` for
stack 1. Both stacks are real init paths; the selector picks which one runs.

### 5. What reads the selector, and what selects each personality — Confirmed

Census on `0xFF813A` (`0xFFFF813A`): **2 writers, 11 readers.**

* Writers: `0x0021FA` (=0) and `0x002224` (=1). Both in boot, nowhere else. It is
  a power-on latch, never rewritten at runtime — matching both prior reports.
* Decisive readers:
  * `0x054D54` — the USB interrupt handler `sub_54D50`:
    `mov.b @0xFFFF813A,r4l ; bne loc_54EA8`, and at `0x054EB0`
    `jsr @0x07827C`. Selector `0` → services stack 1 inline (reads IFR0 `0xFFEE00`,
    the 8-byte SETUP at `0xEE0E`, EP0 `0xEE0C`, arms `0xEE2C`). Selector `≠0` →
    hands the same interrupt to the stack-2 service routine.
  * `0x056160` — the DSP/SCI-C interrupt handler `sub_5615C`: selector `≠0` reroutes
    the byte stream to the serial engine (the DSP-write relay DSP-AMBE documented).
* Other readers: `0x002BE2`, `0x002C06`, `0x0037EA`, `0x00380C`, `0x00392C`,
  `0x003950`, `0x00DCC4`, `0x00EE82`, `0x0101B2` — scheduler/UI mode gates. Their
  existence confirms the selector is a genuine live global, not a vestige.

The stack-2 service loop `0x07815C` and ISR `0x07827C` drive the USB hardware
directly: `btst #4, @0xFFFFEE00` (IFR0) at `0x078192`/`0x0782B6`,
`mov.b …,@0xFFFFEE2C` (TRG) at `0x0781A0`/`0x078376`, reads of `IER0/IER2`
(`0x078284`/`0x07829C`), while pulling working pointers from the copied RAM
(`0xFF6288`, `0xFF6358`, `0xFF63F8`, `0xFF62D8`, and base `0xFF6240` at `0x07704C`).
So the CDC descriptor's RAM image **is** handed to the USB engine at `0xFFEE00`.

### 6. Why DSP-AMBE saw "dead", and why it isn't — Confirmed

DSP-AMBE scanned for references to `0x7B680`/`0x7B698`/`0x7B711` and found none.
Reproduced: a whole-image byte scan finds the flash descriptor addresses used as
pointers **nowhere**; the only pointers to that neighbourhood are inside the
copied `.data` tables themselves and resolve to the *RAM* images. The method that
would have caught it is the relocation, not an xref. The clincher is symmetry:

| descriptor | served in normal op? | XrefsTo | reached by |
| --- | --- | --- | --- |
| stack-1 device `0x055818` | **yes** | **0** | `MOV.L #0x055818` imm @ `0x055136` |
| stack-1 config `0x05582A` | yes | 0 | imm @ `0x055122` |
| stack-2 device `0x07B680` | (strap) | 0 | RAM image `0xFF640E` via ptr table |
| stack-2 config `0x07B711` | (strap) | 0 | RAM image `0xFF649F` via ptr table |

A zero xref count is produced equally by a live descriptor and a dead one on this
core, so it cannot distinguish them. The distinguishing evidence — the copy, the
relocated pointers, the init call, the ISR dispatch — all points to live.

### 7. The descriptors themselves — Confirmed valid, deliberately Yaesu-branded

Device `0x07B680`: `12 01 10 01 02 00 00 08 AA 26 20 00 00 01 00 00 03 01` —
bcdUSB 1.10, **bDeviceClass 0x02 (CDC)**, EP0 8, **VID 0x26AA / PID 0x0020**,
iSerialNumber 3. Config `0x07B711`: `09 02 43 00 02 01 00 C0 10` + CDC
header/ACM/union/call-mgmt functional descriptors + EP `0x83` int / EP `0x01`
bulk-OUT 64 / EP `0x82` bulk-IN 64; `9+9+5+4+5+5+7+9+7+7 = 0x43` matches
`wTotalLength`. This is a hand-valid CDC-ACM set carrying **Yaesu's** VID and a
clean product ID — not a vendor sample's identity. The ACME/LaserBeam IEEE-1284
string (`0x07B698`: `00 79` length prefix + text) is unreferenced sample residue
that happens to sit in the same copied region; it does not touch the CDC path.

## USB relevance

**Question 1 (everything USB).** The MAIN USB device controller has two real,
switchable personalities, both fully wired to the on-chip module at `0xFFEE00`:

* **Normal centre-switch power-on → `0x26AA:0x0001`, vendor-specific bulk**
  (class `FF/01/FF`, EP1 OUT bulk 64 + EP3 IN int 8; no bulk IN). This is what a
  PC sees from a radio turned on the ordinary way.
* **Held-key power-on (`0xFFFF4C` line for key code `0x11`) → `0x26AA:0x0020`,
  CDC-ACM virtual COM port** (EP1 OUT bulk 64, EP2 IN bulk 64, EP3 IN int 8).
  Fully implemented and reachable; it is the data path DSP-AMBE identified as the
  DSP-write relay (in that mode the DSP's SCI is switched to async and CDC bytes
  are relayed to it). This resolves the HOST-USB open question in favour of "MAIN
  has its own USB stacks", distinct from the `045B:0025` boot-ROM identity.

The owner-facing bottom line: **the radio does not present a USB serial port when
switched on normally**; it presents one only when powered on with the specific
key/line held. That is a deliberate service/factory mode, not a bug and not a
normal-use feature. Which physical button is key code `0x11` (`0xFFFF4C` bit 1)
is the one thing still worth pinning (MAIN-IO Open item 3).

**Question 2 (USB SDR).** Unchanged by this adjudication and if anything narrowed:
even the CDC personality's IN direction is a single 64-byte full-speed bulk
endpoint (~1 MB/s ceiling), and neither personality has an IQ/sample source
behind it — the widest input to MAIN is the DSP's vocoder-rate synchronous SCI.
No SDR path is created by the CDC stack being live.

**Question 3 (the DSP).** Consistent with DSP-AMBE: the held-key/CDC mode is the
firmware's own route for streaming bytes to the DSP for a firmware write. The
"unidentified peripheral at `0xFFEE00`–`0xFFEE53`" in DSP-AMBE's report is the USB
Function Module; the "generic serial engine" it starts via `jsr 0x078106` is the
CDC stack. That closes DSP-AMBE's biggest open item on the MAIN side.

## Open

Most valuable first.

1. **Name the strap line.** `0xFFFF4C` bit 1 = internal key code `0x11`
   (`sub_100E4`). Cross-referencing the keypad map (MAIN-IO Open 3) would turn
   "hold this line low at power-on" into "hold *this button*", which is the single
   fact that makes the CDC serial port usable to the owner. Cheap.
2. **CDC data-plane semantics.** With the port up, what does it speak? EP1/EP2
   bulk feed the copied-RAM queues at `0xFF6288`/`0xFF62D8`; trace their producers
   and consumers to see whether it is a transparent DSP-write relay only, or also
   a general console. Handlers in `0x076000`–`0x0783xx`.
3. **The nine mode-gate readers of `0xFF813A`** (`0x002Bxx`, `0x0037xx`,
   `0x0039xx`, `0x00DCC4`, `0x00EE82`, `0x0101B2`) — quick disassembly would show
   exactly what else changes behaviour between the vendor and CDC modes (e.g.
   whether the DATA-jack command interpreter is suppressed in CDC mode).
4. **Stack-1 (`0x26AA:0x0001`) purpose.** It is the *normal-mode* USB identity and
   is barely characterised; its four vendor requests `0xD1`–`0xD4` (MAIN-IO
   section 2) are the actual USB API a PC gets from a normally-powered radio.
