# SUB (RX64M) USB hardware — definitive verdict

## Verdict

**USB0 is dark in the SUB application firmware, and the case is now closed in
both directions.** The RX64M silicon block exists at `0x000A0000` and the
firmware even programs a valid 48 MHz USB clock, but the module is never
released from module stop: `MSTPCRB` (`0x00080014`) is touched at exactly three
read-modify-write `bclr` pairs in the entire 4 MB image — bits 31, 29 and 28,
which are SCI0, SCI2 and SCI3 — and there is no whole-word store to it anywhere,
so its final value is `0x4FFFFFFF` and every other bit, including USB0, keeps its
reset value of 1 = stopped. `MSTPCRC` (`0x00080018`) is never read or written at
all. Independently: not one of the 21 210 resolved peripheral effective
addresses lands in `0x000A0000`–`0x000A03FF`, or anywhere in
`0x00090000`–`0x000BFFFF`; every MPC pin-function register for the pins RX64M
multiplexes onto USB0 (`P14PFS`, `P16PFS`, `P22PFS`, `P24PFS`, `P26PFS`) is
never written and those pins are explicitly driven as ordinary GPIO; the image
contains no USB descriptor of any kind, no VID, no PID, no `bcdUSB`, no string
descriptor; and the ICU is configured so that the 17 enabled interrupt vectors
match the 17 vectors with unique handlers exactly, with `IER04` — the byte that
covers vectors 32–39, where RX64M places `D0FIFO0`/`D1FIFO0` — never touched. Six
independent tests agree. The one test that does **not** corroborate is the clock
tree, and that matters: `SCKCR2` is written `0x0031`, whose `UCK` field selects
PLL÷4 = 48 MHz, so the part is clocked for USB even though the controller is
switched off. So the honest statement is the one the owner needs: *the RX64M in
this radio contains a full-speed USB controller that is clocked but never
enabled by this firmware* — not *the hardware cannot do USB*. Whether USB0's
dedicated `DP`/`DM` pins are wired to the micro-USB jack cannot be answered from
firmware; the pin evidence says the multiplexed USB0 helper pins certainly are
not used as USB, and two of them are driven as outputs for something else.

## Method

Everything below was run against `decrypted\FT3D_SUB_ver102_ALL.bin`
(4 194 304 bytes, mapped `0xFFC00000`–`0xFFFFFFFF`) in the private database
`SUB_USB`, seeded with `--copy-from ida\db\radio\SUB.i64` (the earlier
455-function state). No shared database was opened. Job scripts:
`ida\jobs\subusb_open.py`, `subusb_regmap.py`, `subusb_probe_ops.py`,
`subusb_regmap2.py`, `subusb_dump.py`, `subusb_widen.py`.

**The coverage problem, and how it was solved.** The earlier "no USB" result
came from 455 recovered functions and a literal-immediate scan, which is 11 % of
the image. Rather than try to disassemble 4 MB (that is SUB-LOWER's job), I made
the peripheral scan independent of function recovery. The RX has **no absolute
addressing mode**: to touch an I/O register the code *must* materialise the
address in a register, and the only encoding that does so is
`MOV.L #imm, Rd` = `FB (rd<<4)|0x02` + imm32, `|0x0E` + imm24, `|0x0A` + imm16.
That encoding was confirmed against the reset handler:

```
FFC0000E  FB E2 80 FF FF FF   mov.l #0FFFFFF80h, r14   ; -> EXTB
FFC00017  FB E2 70 8A ED FF   mov.l #0FFED8A70h, r14   ; -> INTB
```

So I raw-scanned **all 4 194 304 bytes at every byte offset** for that opcode
pattern with an immediate in the RX64M I/O region `0x00080000`–`0x000FFFFF`,
found 885 sites, forced an instruction at each, verified IDA decoded the same
immediate and length (885/885, 0 failures), then walked forward from each site
with constant propagation over `[Rn]`, `dsp:8[Rn]`, `dsp:16[Rn]`, register
copies and `add #imm`, invalidating a register whenever an instruction's
`CF_CHGn` says it changed and on every call. That resolved **21 210 effective
addresses over 352 distinct peripheral registers** — the whole peripheral map of
the firmware, from a scan whose scope is the entire image.

One correctness note, because it invalidated my first pass: for the IDA RX
module an `o_displ` operand carries the byte-scaled displacement in
**`op.value`**, not `op.addr`. Verified at `FFEE1398`,
`mov.w #0A502h, 3EEh[r14]` → `op1.type=4 op1.reg=14 op1.value=0x3EE`, and
`0x00080010 + 0x3EE = 0x000803FE` = `PRCR`. `ida\out\sub-usb\reg_access.tsv`
from the first pass was deleted; `reg_access2.tsv` is the corrected one.

**Holes explicitly closed.** RX `dsp:16` is unsigned and scaled by operand size,
so with `.L` the reach from a base is `0xFFFF × 4 = 0x3FFFC`; a base as low as
`0x00060004` could still land in the USB window. The walk was therefore re-run
with the base filter widened to `0x00040000`–`0x00100000` (1 808 sites) — zero
effective addresses in `0x00090000`–`0x000BFFFF`. A base could also be loaded
from a flash literal: 24 four-byte-aligned words in the image hold a value in
`0x000A0000`–`0x000A03FF` and **none has a cross-reference**; all are
`0x000A0001`/`0x000A0009`/`0x000A000A`, i.e. adjacent 16-bit entries of index
tables such as `… 09 00 0A 00 0B 00 0C 00 …`.

**Not covered.** I did not attempt a full disassembly of the ~2.8 MB lower
region (SUB-LOWER owns it) and I did not identify every peripheral block —
`0x00083000`, `0x00083800`, `0x0008AC00`, `0x0008ADB0`, `0x000C1A00` and the
`MSTPCRD` bit-19 peripheral are named as unidentified below rather than guessed.
None of them is the USB0 or USBA block. I did not touch the MAIN image, the PE
files, or any device.

## Findings

### Test 1 — module stop. Decisive, negative.

The whole module-stop configuration lives in one CC-RX generated routine at
`0xFFF36CCA`, reached from the reset handler through
`FFC00036 bsr.a FFF36C53` → `FFF36C59 bsr.a FFF36CC0` → `bsr.w FFF36CCA`. It
opens and closes with the register-protect key:

```
FFF36CCC  FB EE 10 00 08        mov.l #80010h, r14          ; MSTPCRA
FFF36CD1  FA E9 F7 01 0B A5     mov.w #0A50Bh, 3EEh[r14]    ; PRCR <- A50B (unlock)
...
FFF36D8C  FA E9 F7 01 03 A5     mov.w #0A503h, 3EEh[r14]    ; PRCR <- A503
FFF36EFB  FA E9 F7 01 00 A5     mov.w #0A500h, 3EEh[r14]    ; PRCR <- A500 (relock)
```

Every module-stop write in the image is a read-`bclr`-write against the live
register — never a mask-and-store against a shadow, and never a whole-word
store. That is what makes the result airtight: a bit that is not `bclr`-ed
anywhere keeps its reset value of 1.

**`MSTPCRB` `0x00080014` — the decisive register. Three bclr pairs, in the whole
image:**

```
FFF36D19  FB 1E 10 00 08        mov.l #80010h, r1
FFF36D1E  A8 1A                 mov.l 4[r1], r2      ; read MSTPCRB
FFF36D20  7B F2                 bclr  #1Fh, r2       ; bit 31
FFF36D22  A0 1A                 mov.l r2, 4[r1]
FFF36D29/2B/2D                  bclr  #1Dh           ; bit 29
FFF36D76/78/7A                  bclr  #1Ch           ; bit 28
```

Final `MSTPCRB` = `0xFFFFFFFF & ~0xB0000000` = **`0x4FFFFFFF`**.

**How I established the bit positions, rather than trusting a remembered
number.** `MSTPCRB`'s high byte is the SCI block: bits 31…24 are SCI0…SCI7
descending. Four independent witnesses in this image pin that down and account
for all three cleared bits, leaving none spare:

| witness | SCI0 | SCI2 | SCI3 | SCI1 |
| --- | --- | --- | --- | --- |
| `MSTPCRB` bit cleared | 31 | 29 | 28 | — (bit 30 stays set) |
| SCI register base used (`0x0008A000 + 0x20n`) | `0x0008A000` | `0x0008A040` | `0x0008A060` | none |
| INTB slot with a unique handler (RXI/TXI) | 58 / 59 | 62 / 63 | 80 / 81 | none (60/61 are stubs) |
| MPC pin assignment, `PSEL = 0x0A` | P20/P21 | P12/P13 | P23/P25 | none |
| ICU `IER` bit set | `IER07` b3,b2 | `IER07` b7,b6 | `IER0A` b1,b0 | none |
| `GENBL0` bits (TEI/ERI) | 0, 1 | 4, 5 | 6, 7 | 2, 3 not set |

Three cleared bits, three fully corroborated peripherals. **Therefore, whichever
bit of `MSTPCRB` is USB0 — Renesas documents it as `MSTPB19` — that bit is 1 and
USB0 is held in module stop.** On RX64M a module in module stop has no clock
supply and its registers are inaccessible; it cannot be used, and it cannot
raise an interrupt.

`MSTPCRC` `0x00080018` is **never read and never written anywhere in the
4 MB image** — zero accesses out of 21 210. Every peripheral that register gates
stays stopped.

`MSTPCRD` `0x0008001C`: one `bclr` pair, bit 19, at `FFF36D34`/`FFF36D38`. The
peripheral is not identified from this package. It is not USB0 (documented in
`MSTPCRB`), and in any case no USB0 register is ever accessed, so a released
controller that is never programmed has `SYSCFG.USBE = 0` and does nothing.

`MSTPCRA` `0x00080010`: fourteen `bclr` operations, bits 9, 13 (×4), 14, 15 (×2),
16 (×2), 17, 19 (×2), 28. Two of those bit identities are *proved* inside this
image rather than assumed, because the release sits immediately before the
peripheral's own configuration:

```
FFEE1393  mov.l #80010h, r14 / mov.w #0A502h, 3EEh[r14]   ; PRCR unlock
FFEE13A5  bclr #10h, r15                                  ; MSTPCRA bit 16
FFEE13B4..FFEE13EC  PORT0.PMR b0,b1 = 0; PWPR unlock; P00PFS.ASEL=1; P01PFS.ASEL=1
FFEE13EE  mov.l #89100h, r14 ...                          ; S12AD1  => bit 16 = S12AD1

FFF1505C  bclr #13h, r15                                  ; MSTPCRA bit 19
FFF15060..FFF15084  0x00088045, 0x00088046 = 0; P03 -> ASEL=1  ; R12DA => bit 19 = D/A
```

Full decode: `ida\out\sub-usb\mstp_decode.tsv`.

The consistency check that matters: **every peripheral block whose registers the
firmware actually accesses has its module-stop bit cleared, and no accessed
block lacks one.** The converse is not exactly true — `MSTPCRA` bit 15 (CMT unit
0) is cleared twice yet no `CMT0`/`CMT1` register is ever accessed, which is
normal for generated `hwsetup` code. Nothing is released that could be USB.

`PRCR` `0x000803FE` is written at 11 instructions with the values `0xA502`,
`0xA50B`, `0xA503` and `0xA500`, each unlock bracketed by a relock.

### Test 2 — clock supply. Does *not* corroborate; the clock is there.

The clock tree is configured in the same routine, all through the
`0x00080010` base:

| insn | register | value | meaning |
| --- | --- | --- | --- |
| `FFF36E18` | `MOSCWTCR` `0x000800A2` | `0x53` | main oscillator wait |
| `FFF36E21` | `MOSCCR` `0x00080032` | `0x00` | main clock oscillator **started**, then polled `OSCOVFSR.MOOVF` at `0x0008003C` |
| `FFF36DEF` | `SOSCCR` `0x00080033` | `0x01` | sub-clock oscillator stopped |
| `FFF36E44` | `PLLCR` `0x00080028` | `0x1F00` | `PLIDIV`=÷1, `PLLSRSEL`=main, `STC`=0x1F ⇒ **×16** |
| `FFF36E4E` | `PLLCR2` `0x0008002A` | `0x00` | PLL released, then polled `OSCOVFSR.PLOVF` |
| `FFF36E66` | `OPCCR` `0x000800A0` | `0x00` | high-speed operating mode |
| `FFF36E79` | `SCKCR` `0x00080020` | `0x42C22222` | `FCK`÷16, `ICK`÷4, `PSTOP0=PSTOP1=1`, `BCK`÷4, `PCKA..PCKD`÷4 |
| `FFF36E94` | `BCKCR` `0x00080030` | `0x00` | `BCLKDIV`=0 |
| **`FFF36EA9`** | **`SCKCR2` `0x00080024`** | **`0x0031`** | **`UCK` (bits 7:4) = 3 ⇒ PLL ÷ 4** |
| `FFF36EBD` | `SCKCR3` `0x00080026` | `0x0400` | `CKSEL` = 4 ⇒ **PLL selected** as the system clock |
| `FFF36ED4` | `LOCOCR` `0x00080034` | `0x01` | LOCO stopped |

With a 12 MHz main crystal that is PLL = 192 MHz, ICK = PCLKB = 48 MHz, and
`SCKCR2.UCK` = ÷4 gives a **48 MHz USB clock**. So this test is the one that
points the other way, and I am reporting it as such rather than forcing it into
the verdict: the firmware *does* produce the clock a full-speed USB controller
needs. It is also exactly what CC-RX's generated clock initialisation writes
whether or not USB is used, and with `MSTPB19` set the clock never reaches the
module. The value of the finding is that it removes "the clock tree cannot
support USB" from the list of obstacles.

### Test 3 — pin function. Negative, and it says what the pins do instead.

Ports 0–3 are initialised at `0xFFF36F03` (reached from `FFF36CC3`). Every port
gets `PODR = 0`, an explicit per-bit `PDR` direction, and **`PMR = 0`** — all
pins in general-I/O mode, no peripheral function:

```
FFF36F3F  mov.l #8C001h, r14        ; PORT1
FFF36F4D..FFF36F70  PDR: bclr#2 bset#3 bclr#4 bset#5 bclr#6 bset#7
FFF36F77  mov.b #0, 60h[r14]        ; PORT1.PMR = 0
FFF36FC0  mov.b #0, [r14]           ; PORT2.PMR = 0   (r14 = 8C062h)
FFF36F88..FFF36FB9  PORT2.PDR: bset#0 bclr#1 bclr#2 bset#3 bset#4 bclr#5 bset#6 bclr#7
```

`PWPR` `0x0008C11F` is unlocked only four times in the whole image — `FFEE13C7`,
`FFF1570C`, `FFF32D1F`, `FFF37333` — always as `bclr #7` (`B0WI=0`) then
`bset #6` (`PFSWE=1`), and relocked immediately after. The complete set of MPC
`PFS` registers ever written, at `0x0008C140 + 8·port + pin`:

| PFS | pin | value written | function |
| --- | --- | --- | --- |
| `0x0008C140` | P00 | `bset #7` | `ASEL` = analog input |
| `0x0008C141` | P01 | `bset #7` | `ASEL` = analog input |
| `0x0008C143` | P03 | `bset #7` | `ASEL` = D/A output |
| `0x0008C14A` | **P12** | `PSEL = 0x0A` | SCI2 `RXD2` |
| `0x0008C14B` | **P13** | `PSEL = 0x0A` | SCI2 `TXD2` |
| `0x0008C150` | **P20** | `PSEL = 0x0A` | SCI0 `TXD0` |
| `0x0008C151` | **P21** | `PSEL = 0x0A` | SCI0 `RXD0` |
| `0x0008C153` | **P23** | `PSEL = 0x0A` | SCI3 `TXD3` |
| `0x0008C155` | **P25** | `PSEL = 0x0A` | SCI3 `RXD3` |
| `0x0008C160`/`61`/`62` | P40/P41/P42 | `bset #7` | `ASEL` = analog inputs |
| `0x0008C17D`..`0x0008C181` | P75..P81 | read-modify-write | external bus / parallel device |
| `0x0008C1A2`..`0x0008C1A4` | PC2..PC4 | read-modify-write | external bus / parallel device |

The `PSEL = 0x0A` writes use the CC-RX idiom `or #0Ah` then `and #0CAh`, which
sets `PSEL[4:0] = 0b01010` while preserving `ISEL` and `ASEL`
(`FFF37341`–`FFF3737D`).

**The pins RX64M multiplexes onto USB0 — P14 (`USB0_OVRCURA`/`USB0_ID`), P16
(`USB0_VBUS`/`USB0_VBUSEN`/`USB0_OVRCURB`), P22 (`USB0_ID`/`USB0_OVRCURB`), P24
(`USB0_VBUSEN`), P26 (`USB0_DPUPE`) — have their `PFS` registers `0x0008C14C`,
`0x0008C14E`, `0x0008C152`, `0x0008C154`, `0x0008C156` never written anywhere in
the image**, so `PSEL` stays 0, and their `PMR` bits are never set. After
startup only `PMR1` bits 2, 3 and `PMR2` bits 0, 1, 3, 5 are ever set — the six
SCI pins and nothing else. P14 and P16 are left as GPIO **inputs**; P24 and P26
are GPIO **outputs**; and P22 is re-directed to an output at `FFF373DF`
(`mov.l #8C002h, r14; bset #2, [r14]`). The board is using those pins for
something that is not USB.

One caveat stated honestly: on RX64M `USB0_DP` and `USB0_DM` are **dedicated**
pins, not multiplexed through MPC, so the absence of MPC configuration does not
by itself prove the data lines are unavailable. It does prove the firmware never
configures any USB0 signal, and it proves the helper pins are committed
elsewhere.

### Test 4 — the register window, every addressing form. Negative, full scope.

| pass | scope | result |
| --- | --- | --- |
| Opcode-aware `FB`-form scan, base in `0x00080000`–`0x000FFFFF` | 4 194 304 bytes, every byte offset | 885 sites, 885 verified, **no site loads an address in `0x000A0000`–`0x000A03FF`**; the distinct-base list jumps from `0x0008FD75` straight to `0x000C0821` |
| Forward constant propagation from those sites | 21 210 effective addresses, 352 distinct registers | **0** in `0x000A0000`–`0x000A03FF`; **0** in `0x00090000`–`0x000BFFFF` |
| Widened base range `0x00040000`–`0x00100000` to cover `dsp:16`·4 reach | 1 808 sites | **0** in `0x00090000`–`0x000BFFFF` |
| Raw dword scan, every byte offset | 4 194 304 bytes | 87 values in the window, all glyph-bitmap or 16-bit index-table data |
| Aligned flash literals with a window value, plus their xrefs | 4 194 304 bytes | 24 literals, **all with zero cross-references** |

The two methods reconcile exactly: the raw byte hits exist, none of them is an
instruction immediate and none is a referenced pointer, and no computed address
reaches the window. The same passes also cover `PDC` at `0x000A0500` — the
RX64M's own parallel camera-capture unit — and `CAN0` at `0x00090200`: both
untouched. Tables: `usb_window_access.tsv` (empty), `gap_access.tsv` (empty),
`usb_window_bytescan.txt`, `job5_widen.txt`.

### Test 5 — descriptors. Negative, whole image.

| descriptor | raw byte-pair hits | passing field validation |
| --- | --- | --- |
| device `0x12 0x01` + valid `bcdUSB` | — | **0** |
| configuration `0x09 0x02` | 71 | **0** |
| interface `0x09 0x04` | 43 | **0** |
| endpoint `0x07 0x05` | 26 | **0** |
| HID `0x09 0x21` | 45 | **0** |
| string (`bLength`, `0x03`, UTF-16LE) | — | **0** |

Validation required plausible `wTotalLength`/`bNumInterfaces`/`bmAttributes` for
configuration, a known class code for interface, a legal endpoint address and
transfer type for endpoint. No `bcdUSB` value appears in a descriptor position.
`0x045B` (Renesas) occurs twice, at `0x2B9410` and `0x2BEFB0`, both inside
sequential 16-bit codepoint tables (`… 59 04 5A 04 5B 04 5C 04 …`) — not a VID.
`0x0025` occurs 119 times as an ordinary small constant. Full output:
`descriptor_scan.txt`.

### Test 6 — host versus device. No host stack, and an interrupt map that agrees.

No host-side signature exists: **0** `GET_DESCRIPTOR` setup templates
(`80 06 00 01`, `00 02`, `00 03`), **0** mass-storage `CBW`/`CSW` signatures
(`USBC`/`USBS`), **0** UVC GUIDs or `MJPG`, **0** CDC functional descriptors,
**0** HID report descriptors, **0** hub descriptors, and none of
`usb_`, `USB_`, `R_USB`, `pipe`, `hub` as identifier text. The string `USB`
occurs exactly **twice** in 4 MB: at file `0x0003E709` (`USB CAMERA`, the setup
label already known) and at file `0x0034AA16`, a UI string `USB` + katakana
sitting next to `Bluetooth ` in the display string pool. `CAMERA` also appears at
`0x0034A4C1` among ordinary menu strings (`SP SEL :`, `INT SP`). So `USB CAMERA`
is a *label*, with no code and no hardware path behind it — reinforced by the
fact that the RX64M's own camera interface `PDC` at `0x000A0500` is never
touched either.

The interrupt evidence is the strongest corroboration in this document, because
it closes in both directions. All 256 `INTB` slots at `0xFFED8A70` (file
`0x2D8A70`) were decoded: 40 are zero, 199 point into a table of 2-byte stubs at
`0xFFF47E40`–`0xFFF47FCF` (consecutive slots → consecutive 2-byte entries), and
**17 have a unique handler**:

```
 44 -> FFF32CA7    58 -> FFEDB7E7    59 -> FFEDB857    62 -> FFEDBBD3
 63 -> FFEDBC43    80 -> FFEDC025    81 -> FFEDC09B   110 -> FFEDBCDD
111 -> FFF32C99   123 -> FFF32DFB   126 -> FFEF1E28   128 -> FFF32C1E
129 -> FFF39E77   134 -> FFF15A18   135 -> FFEE11B8   136 -> FFF36C1C
210 -> FFF1527B
```

Every `IER` bit set anywhere in the image (`IER` = `0x00087200 + n`, bit *b* →
vector 8*n*+*b*) yields **exactly that same set of 17 vectors**, with no extras
on either side. Confirmed by the `IR` registers the firmware clears, at
`0x00087000 + vector`: `0x8703A`, `0x8703B`, `0x8703E`, `0x8703F`, `0x87050`,
`0x87051`, `0x8706E`, `0x87080`, `0x87086`, `0x87087`, `0x87088` = vectors 58,
59, 62, 63, 80, 81, 110, 128, 134, 135, 136.

**`IER04` at `0x00087204`, the byte that covers vectors 32–39 where RX64M places
`D0FIFO0` and `D1FIFO0`, is never accessed anywhere in the image**, and vectors
32–35 point at the shared stub.

The group interrupt is fully accounted for too. `GROUPBL0` is vector 110, handler
`0xFFEDBCDD`; `GENBL0` `0x00087670` receives exactly six `bset` operations at
`FFEDB374`–`FFEDB3DA` — bits 1, 0, 5, 4, 6, 7 — interleaved with the SCI0/SCI2
and SCI3 `IER` enables, i.e. `TEI`/`ERI` for the three live channels, final value
**`0x000000F3`**. The handler tests exactly those six bits of `GRPBL0`
(`shll #1Fh/#1Eh/#1Bh/#1Ah/#19h/#18h` then `shlr #1Fh`). Six sources enabled, six
sources dispatched, nothing spare.

One nuance worth recording for SUB-VEC: six of the live vectors are RX64M
*selectable* slots, and the firmware routes sources into them —
`SLIBXR128 0x00087780 ← 0x21`, `SLIBXR129 0x00087781 ← 0x02`,
`SLIBXR134 0x00087786 ← 0x40`, `SLIBXR135 0x00087787 ← 0x0F`,
`SLIBXR136 0x00087788 ← 0x1C`, `SLIBR210 0x000879D2 ← 0x1E`; and
`DMRSR3 0x0008740C ← 0x2C` makes DMAC channel 3 fire off vector 44. I cannot
decode those six source numbers without the Renesas source-number table, so I
will not claim they are not USB. It does not matter: a source in module stop has
no clock and cannot assert, and none of those six handlers touches a USB0
register — no handler does, because no instruction in the image does.

### Test 7 — is USB0 bonded out?

What the firmware evidence supports:

- **Confirmed** — the RX64M's USB0 controller exists in the silicon at
  `0x000A0000` (it is an RX64M; the register window is part of the part).
- **Confirmed** — the firmware produces a 48 MHz USB clock (`SCKCR2 ← 0x0031`,
  `UCK` = PLL÷4, PLL = ×16 of the main clock).
- **Confirmed** — the controller is never released from module stop and no
  register in its window is ever addressed.
- **Confirmed** — every USB0 auxiliary pin RX64M offers through MPC is left with
  `PSEL = 0`, `PMR = 0`, and P22/P24/P26 are actively driven as GPIO outputs.
  That is inconsistent with a board design that intends USB0 device operation
  from the application firmware, and it is also affirmative evidence that those
  package pins carry other signals on this board.
- **Unknown** — whether `USB0_DP`/`USB0_DM` (dedicated pins, outside MPC) are
  routed to the micro-USB jack. Firmware cannot answer this. The one thing the
  package *does* tell us is that the official updater reaches the radio over
  USB through the **Renesas boot-mode ROM** (`VID_045B&PID_0025`, the device
  `Generic Boot USB Direct`, entered with the program switch behind the DATA
  jack) — and that boot ROM is the *same* USB0 peripheral. So on the SUB side
  the data lines almost certainly *are* wired, because the boot ROM enumerates
  over them. The boot ROM is not in this image; it lives in the RX64M's
  factory ROM.

## USB relevance

**Question 1, everything USB.** On the SUB processor the USB-touching byte count
is zero. There is no USB code, no USB register access, no descriptor, no
endpoint, no interrupt, no pin. The only USB-shaped things in the 4 MB image are
two pieces of display text (`USB CAMERA`, `USB` + katakana). The USB engine that
the updater talks to is the RX64M's boot-mode ROM, which is not in this package
and is reachable only by holding the program switch behind the DATA jack at
power-on.

**Question 2, is USB SDR possible?** From my half of the chain the answer is a
clean no with a precisely located break, and it is worth spelling out which link
fails because the failure is *firmware*, not silicon:

| link | status on SUB |
| --- | --- |
| 1. sample source | not mine — but note the on-chip converters in use are `S12AD` `0x00089000` and `S12AD1` `0x00089100`, 12-bit SAR class, plus a `R12DA` D/A at `0x00088040`, all released and configured. Handing this to RF-SDR. |
| 2. transport to a mover | **exists.** `DMAC` is released (`MSTPCRA` bit 28) and channel 3 is wired to interrupt 44 via `DMRSR3`; `EXDMAC0` registers `0x00082800`–`0x0008281E` are also in use. |
| 3. USB device controller with a bulk/iso IN endpoint | **missing in firmware, present in silicon.** The controller is in module stop and never addressed. Full speed would be 12 Mbit/s raw, so 16-bit IQ at 48 kHz fits and 192 kHz is marginal — but none of that is reachable today. |
| 4. firmware implementing it | **absent**, and there is no partial stack to extend: not one line of USB code exists to build on. |

So the honest framing for the owner: **this is not "the hardware cannot do it".
It is "the chip can, the clock is already right, and the firmware does not."**
The distance between those two is a complete USB device stack plus a pin/board
question. The practical obstacle is that installing such firmware means writing
the SUB flash, and the only documented write path is the same boot-mode ROM — so
any USB-SDR experiment would begin by replacing the SUB application image
wholesale, and would still depend on `USB0_DP`/`USB0_DM` actually reaching the
jack, which this package cannot confirm.

**Question 3, the DSP/vocoder.** Not my assignment, but my scan produces the
bus inventory that bears on it, and one hard data point. SUB runs exactly three
SCI channels — SCI0 (P20/P21), SCI2 (P12/P13), SCI3 (P23/P25) — plus an
external parallel bus (`PFCSE 0x0008C100 ← 6`, `PFCSS0 ← 0x28`,
`PFAOE0 ← 0xFF`, `PFAOE1 ← 0x0F`, `PFBCR0 ← 0x53`, and `SYSCR0 0x00080006 ←
0x5A03` then `0x5A01`, toggling `EXBE`) on ports 7, 8 and C with DMAC3. **No
`RSPI` is used** — `0x000D0100` never appears as a base — so on the SUB side
there is no SPI path to a vocoder. One SCI is a MediaTek GPS receiver: the
strings `$PMTK103`, `$PMTK102`, `$PMTK001` sit at file `0x00010E` (`0xFFC0010E`).
That leaves two SCI channels for the MAIN link and the external COM port
(`COM PORT SETTING`), which suggests the DSP hangs off MAIN, not SUB.

## Open

Most valuable first.

1. **Compare the peripheral map with SUB-VEC.** My INTB decode, `IER` set and
   `IR` set agree with each other perfectly, and my table is
   `ida\out\sub-usb\vectors_live.tsv`. Any disagreement with SUB-VEC's
   independent decode is important. The specific item I could not finish is the
   six selectable-interrupt source numbers (`0x21`, `0x02`, `0x40`, `0x0F`,
   `0x1C`, `0x1E`) — decoding those names six more peripherals.
2. **Name the unidentified blocks**: `0x00083000`/`0x00083800` (paired
   `0x10`-stride register groups), `0x0008AC00`–`0x0008AC60`, `0x0008ADB0`,
   `0x000C1A00`/`0x000C1A80`, and the `MSTPCRD` bit-19 peripheral. All are
   accessed heavily and none is USB, so none changes this verdict, but they are
   the remaining holes in the SUB hardware picture. Start from
   `ida\out\sub-usb\reg_access2.tsv`.
3. **The external parallel bus on ports 7/8/C with DMAC3.** `DSCR` drive-strength
   bits are set for PC2–PC4, five `PFS` registers are read-modify-written, and a
   DMA channel is bound to it. That is the highest-bandwidth path in the SUB
   image and RF-SDR should know what is on the other end of it.
4. **The MAIN (H8S) side of the USB question.** The H8S/237x family is not
   believed to have a USB module, but this document does not test that; the
   equivalent exhaustive pass on `FT3D_MAIN_ver102_EXP.bin` is not done.
5. **Package/pinout of the actual RX64M part.** Only a photograph of the board or
   the part marking settles whether `USB0_DP`/`USB0_DM` reach the jack. Nothing
   in these files can.

### Files

| file | contents |
| --- | --- |
| `ida\out\sub-usb\usb_evidence.tsv` | one row per test: scope, result, direction, addresses |
| `ida\out\sub-usb\mstp_decode.tsv` | every module-stop bit operation with its peripheral and the evidence for it |
| `ida\out\sub-usb\vectors_live.tsv` | all 256 INTB slots, classified, with `IER`/`IR` cross-check |
| `ida\out\sub-usb\reg_access2.tsv` | 21 210 resolved peripheral accesses, 352 registers, whole image |
| `ida\out\sub-usb\fb_sites.tsv` | 885 verified `MOV.L #imm, Rd` peripheral base loads |
| `ida\out\sub-usb\sys_access.tsv` | SYSTEM block: module stop, clock, `PRCR` |
| `ida\out\sub-usb\mpc_access.tsv` | every MPC `PFS`/`PWPR` access |
| `ida\out\sub-usb\port_access.tsv` | every PORT `PDR`/`PODR`/`PIDR`/`PMR`/`ODR`/`PCR`/`DSCR` access |
| `ida\out\sub-usb\icu_access.tsv` | every ICU access incl. `IER`, `IPR`, `GENBL0/1`, `SLIBXR`, `DMRSR` |
| `ida\out\sub-usb\usb_window_access.tsv` | USB0 window — header only, zero rows |
| `ida\out\sub-usb\gap_access.tsv` | `0x00090000`–`0x000BFFFF` — header only, zero rows |
| `ida\out\sub-usb\usb_window_bytescan.txt` | all 87 raw byte matches in the USB window, with context |
| `ida\out\sub-usb\descriptor_scan.txt` | descriptor, host-signature and string scans |
| `ida\out\sub-usb\job2_probe.txt` | operand-encoding probe + full startup disassembly |
| `ida\out\sub-usb\job4_dump.txt` | ICU group setup, `GROUPBL0`/`BL1` handlers, MPC setup, runtime module-stop helpers |
| `ida\out\sub-usb\job5_widen.txt` | widened base scan and flash-literal xref check |
