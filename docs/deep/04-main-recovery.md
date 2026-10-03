# MAIN (H8S) full recovery and register map

> **UPDATED — DATA-jack command API and part ID resumed.** The USB findings
> (§1–§9) are from the earlier pass and unchanged. This resume added, against the
> same `MAIN_FULL` database: **§10 the full DATA-jack external control command
> opcode→handler→effect table** (the radio's external control / clone / CAT API),
> and **§11 the H8S part identification**. Both are backed by the tables in
> `ida/out/main-full/` (`data_jack_commands.tsv`, `cmd_dispatch.tsv`,
> `cmd_effects.tsv`, `cmd_disasm.txt`, `cmd_templates.txt`). Still **not** done
> (MAIN's *USB-stack* internals, a separate subject from the DATA-jack serial
> API): hand-written C for the two USB stacks, the vendor control-request handlers
> `0x41D1`/`0x41D3` traced to their effects, and the destination of the USB
> bulk-OUT pages. 23.6% of the content region is still raw bytes; §7 says what is
> in it. Database: `MAIN_FULL`.

## Verdict

**The MAIN H8S processor has USB.** It carries an on-chip Hitachi/Renesas USB
Function Module at `0xFFEE00`, two complete USB device firmware stacks, four
sets of valid USB descriptors, and three live USB interrupt vectors (234, 235,
238). The USB module is initialised unconditionally from the reset path
(`reset_handler` → `sub_20FA` → `jsr sub_54BF8` at `0x2214` and
`jsr sub_54C44` at `0x2218`). One stack is a vendor-class device
(class `0xFF`, subclass `0x01`, bulk OUT endpoint 1 at 64 bytes + interrupt IN
endpoint 3 at 8 bytes) that answers `GET_DESCRIPTOR` plus four vendor control
requests `0x41D1`, `0x41D2`, `0x41D3`, `0xC1D4`; the other is a full **CDC-ACM
virtual COM port** (2 interfaces, bulk OUT EP1/64, bulk IN EP2/64, interrupt IN
EP3/8) whose descriptors sit in the C initialised-data image at file `0x7B680`
and `0x7B711`. The brief's expectation that "the H8S/237x family has no USB
module" is **refuted for this part**: whatever the exact H8S die is, it has a
USBF and this firmware drives it. This moves the answer to mission question 1
substantially: the radio's USB port is reachable by MAIN's application firmware,
not only by a Renesas boot ROM.

Separately: the `!sdr` fragment at file `0xC4B3` is **not a string and has
nothing to do with SDR** — it is six bytes inside a binary byte table, and the
group nine bytes earlier reads `!cdr` by the same accident.

Code recovery went from 1298 functions / 22.3% of the content region to **3899
functions / 55.3% of content bytes inside functions, 75.3% of content bytes
decoded as instructions**. Content ends at file `0x07B753`; `0x07B754`–`0x0FFFFF`
(542,892 bytes) is `0xFF` erase fill and holds nothing.

**The DATA-jack external control command API is fully recovered (§10).** It is a
Yaesu clone/CAT-style ASCII protocol on SCI-A: `SOH(0x01) | letter | NNNN(4 hex
= payload length) | payload | EOT(0x04) | CC(2 hex = 8-bit additive checksum)`,
total `N+9`. The command set is `V M B C E F S N W` inbound and `V H R P B C E
F S N W` outbound, dispatched on the frame's letter by `sub_6BAC8` after a
session gate (`sub_6B9AC`, first frame must be `V`). **`V` is a software-reset
command** (`jsr sub_2648; orc #0x80,ccr; jmp loc_2050` at `0x6BB08`, mirrored in
the frame assembler at `0x6B7DC`) taken when `0xFF8DDE` bit 7 is clear. **`R` is
a block-read** (up to 187-byte response) and the outbound path arms DMAC ch2 to
stream a frame out SCI-A. Critically, **every read and write in this API targets
a fixed RAM staging/record buffer — there is no arbitrary-address memory
read or write, and no command touches the EEPROM or flash.** The response DMA
source is a hardcoded immediate `#0xFEE000` and the length is the radio-computed
frame size (`0xFFB3CC`, set by the finalizer `loc_6CC76`), not a host value; `R`
reads a fixed 45/65/90 bytes from the fixed address `0xFEE944` (the APRS/beacon
record store) and the host's "record index" is only echoed into the reply
header. So this port is a structured clone/config/CAT interface, **not** a
memory peek/poke or a loader. Separately, **the MAIN part is an H8S/2456-group
MCU** (H8S/2600 core with the Renesas USB Function Module — §11).

## Method

Private database `MAIN_FULL` at `ida\db\jobs\MAIN_FULL\MAIN_FULL.i64`, seeded
with `--copy-from ida\db\radio\MAIN.i64` (the earlier 1298-function state) and
then reopened for each pass. `ida\db\radio\` was never written. Eight passes,
all under `ida\jobs\mainfull_*.py`, all launched through `ida\run_job.py`:

| Script | What it did |
| --- | --- |
| `mainfull_recover.py` | all 256 vector slots decoded; functions at every distinct target; big-endian pointer sweep; prologue sweep (`STM.L`/`PUSH.L`/`PUSH.W` forms derived from the 1298 known starts); gap linear sweep |
| `mainfull_recover2.py` | call-target following to a fixpoint; raw harvest of `JSR @aa:24` / `JMP @aa:24` absolute targets |
| `mainfull_map.py` | absolute-operand census, item-class run map, undefined-run inventory with decode probes, xrefs, strings |
| `mainfull_sweep.py` | forced linear sweep of code-like undefined runs; listing dumps |
| `mainfull_tables.py` | 4-aligned pointer/jump tables resolved; re-sweep; tables regenerated |
| `mainfull_switch.py` | switch tables at **any** alignment, found from the `78 n0 6B 2d <aa:32>` + `jmp @ERd` idiom (the control-transfer dispatcher's table at `0x55002` is 2-aligned and was missed by the aligned scan) |
| `mainfull_verify.py` | scored every function, dropped data mis-coded by the sweep, built `vector_map.tsv` |
| `mainfull_clean.py` | dropped tiny no-xref fragments and shredded runs left by the sweep, so the final coverage number means something |

Scope covered: the whole 1 MB image; every absolute-addressed operand at or
above `0x00FE0000` in every recovered function; all 256 vector slots; every
ASCII run of 4+ characters; the full descriptor-signature scan. Not covered:
`0xFF`-fill above `0x07B753` (nothing there), and roughly 119 KB of the content
region that is genuinely data (see the region map) — I did not hand-type C for
the whole USB stack, only the routines named below.

**Honesty on the sweep.** Passes 4–6 force-decode undefined runs, which recovers
real code but also turns some byte tables into instructions. `swept_runs.tsv`
lists every forced run. Pass 7 dropped 13 such functions and pass 8 dropped 248
tiny fragments plus 1230 shredded runs (2472 bytes). The residue is why I report
two figures: **3226 functions have at least one code cross-reference
(244,936 bytes)**, and **673 more (34,536 bytes) exist only because the linear
sweep decoded them**. Treat the second group as lower confidence. `functions.tsv`
carries a `confidence` column (`reachable` / `swept`) per function.

### Addressing mode — how IDA renders the register page

The reset code's second instruction is:

```
00002098  6a 18 aa 31 72 50        bclr    #5, @0xFFFFAA31:16
```

`6A 18 <aa:16>` is the memory-operand prefix for a bit operation; `72 50` is
`bclr #5`. The `:16` suffix means **16-bit absolute addressing**, so the 16-bit
field `0xAA31` is sign-extended. IDA's `h8s300a` module sign-extends to 32 bits
and prints `0xFFFFAA31`; on the H8S's 24-bit advanced-mode bus the real effective
address is **`0x00FFAA31`**. The reachable window is therefore
`0x00FF8000`–`0x00FFFFFF` (32 KB). Likewise `3C 5A` = `mov.b r4l, @0xFF:8` style
8-bit absolute (`@aa:8`) covers only `0x00FFFF00`–`0x00FFFFFF`, and IDA prints
`@0xFFFFFF5A:8` for real address `0x00FFFF5A`. `@aa:24` (`6A 2d`/`6A Ad`) and
`@aa:32` (`01 00 6B a1 …`) are also used, and are needed for anything below
`0x00FF8000` — e.g. `6A 20 00 FF 63 AC` = `mov.b @0xFF63AC:24, r0l`.

Every address in this document and in `ioregs.tsv` / `absrefs.tsv` is the **true
24-bit effective address** (column `ea24`); `ida_addr` keeps IDA's rendering so
the two can be matched up.

### Memory map derived from the image

`sub_20FA` is the C runtime start-up and it states the map outright:

```
00002132  mov.l  #0, er6
00002138  mov.l  #0xFF7300, er4
0000213E  mov.l  #0xFEE000, er5
00002144  sub.l  er5, er4          ; (0xFF7300-0xFEE000)/4 longs
00002148  mov.l  er6, @er5 ...     ; BSS clear
00002152  mov.w  #0x4AE, r4
00002156  mov.l  #unk_7B2A6, er5
0000215C  mov.l  #0xFF6034, er6
00002162  eepmov.w                 ; .data copy, 1198 bytes
```

- **RAM `0x00FEE000`–`0x00FF72FF`** — zero-filled at reset (37,632 bytes).
- **`.data` image: ROM `0x07B2A6`–`0x07B753` (1198 bytes) → RAM `0xFF6034`**.
  `0x07B2A6 + 1198 = 0x07B754`, i.e. exactly the end of content.
- RAM is also used densely from `0xFF8000` to `0xFFBCFF` (reachable by `@aa:16`)
  and sparsely from `0xFF0200` to `0xFF63FF` (needs `@aa:24`/`@aa:32`).
- Stack pointer initialised to `0xFF7F00` (`7A 07 00 FF 7F 00` at `0x2092`).
- Register page: `0xFFEE00`–`0xFFEE53`, `0xFFF610`–`0xFFF617`,
  `0xFFFB80`–`0xFFFBCF`, `0xFFFC00`–`0xFFFC5F`, `0xFFFD20`–`0xFFFDCF`,
  `0xFFFE90`–`0xFFFEFF`, `0xFFFF00`–`0xFFFFFF`. Nothing is addressed in
  `0xFFBD00`–`0xFFEDFF`, `0xFFEF00`–`0xFFF5FF` or `0xFFF700`–`0xFFFAFF`.

The register layout does **not** match the published H8S/2357 or H8S/2378 maps
in detail (the timer start register sits at `0xFFFFBC`, not `0xFFFFC0`, and
`0xFFFF60` is an SCI rather than a port data register), and the part has a USB
Function Module. The exact die is **Unknown** from this package; the block
identities below are derived from the image.

## Findings

### 1. Vector table — 256 slots, 30 occupied

`ida\out\main-full\vectors.tsv` (all 256 rows) and `vector_map.tsv` (per-slot
register set). 226 slots hold `0x00002092`, the reset entry, used as the shared
filler handler. 30 slots hold 27 distinct real handlers.

| Slot(s) | Handler | Peripheral — evidence |
| --- | --- | --- |
| 7 | `0x267C` | NMI. Reloads SP, then touches USB `IER0/1/2` (`0xFFEE04-06`), `0xFFEE2D`, `0xFFEE50`, SCI-D `SCR/SSR`, port block `0xFFFB80-8C`. Shutdown / fatal path. |
| 66 | `0x561C2` | timer channel at `0xFFFEE0` — clears `0xFFFEE5` (status), reads `0xFFFEE6` (counter), touches `0xFFFFBC` (start register) |
| 67 | `0x24B6` | software re-init entry — reloads SP `0xFF7F00` and repeats the reset register sequence |
| 68 | `0x28F4` | timer channel `0xFFFFC0` (`0xFFFFC5` status, `0xFFFFC6` counter) |
| 69 | `0x2922` | timer channel `0xFFFFE0` (`0xFFFFE5`, `0xFFFFE6`) |
| 71 | `0x29CA` | `0xFFFD6A` + port `0xFFFF4E` |
| 74 | `0x2A60` | `0xFFFD68` + port `0xFFFF4E` |
| 75 | `0x2A1E` | counter only (no register access) |
| 88 | `0x28D0` | timer channel `0xFFFFC0` (second source) + port `0xFFFF40` |
| 93 | `0x2950` | timer channel `0xFFFFD0` (`0xFFFFD5`) + ports `0xFFFF68/69` |
| 97 | `0x28E2` | timer channel `0xFFFFE0` (second source) + port `0xFFFF40` |
| 110 | `0x2A30` | timer channel `0xFFFEF0` (`0xFFFEF5`) |
| 128 | `0x48328` | DMA channel 0 end — clears `0xFFFC14` bit 0 and `0xFFF612` bit 7 (SCI-D TIE) |
| 129 | `0x483D2` | DMA channel 1 end — clears `0xFFFC34` bit 0 and `0xFFFF8A` bit 7 (SCI-C TIE) |
| 130 | `0x6B986` | DMA channel 2 end — clears `0xFFFC54` bit 0 and `0xFFFE92` bit 7 (SCI-A TIE) |
| 148, 149 | `0x5615C` | **SCI-C** error / receive (`SSR 0xFFFF8C`, `RDR 0xFFFF8D`) |
| 150 | `0x483D0` | `rte` stub — SCI-C transmit swallowed (its TX is DMA-driven) |
| 152, 153 | `0x45520` | **SCI-B** error / receive (`SSR 0xFFFF64`, `RDR 0xFFFF65`) → 2.25 KB ring `0xFF1AC8`–`0xFF23C7` |
| 154 | `0x454E2` | **SCI-B** transmit (`TDR 0xFFFF63`) |
| 160, 161 | `0x45462` | **SCI-A** error / receive (`SSR 0xFFFE94`, `RDR 0xFFFE95`) → rings `0xFF27C8`/`0xFF95F8` selected by `0xFF817F` bit 7 |
| 162 | `0x45406` | **SCI-A** transmit (`TDR 0xFFFE93`) |
| 224, 226 | `0x44A70` | **SCI-D** error / receive (`SSR 0xFFF614`, `RDR 0xFFF615`) → 3 KB ring `0xFF306A`–`0xFF3C69` |
| 225 | `0x48326` | `rte` stub |
| **234** | `0x54D50` | **USB interrupt 0** — reads `IFR0 0xFFEE00`; bus reset, EP0 SETUP, EP0 OUT, EP0 IN |
| **235** | `0x54EC2` | **USB interrupt 1** — reads `IFR1 0xFFEE01` then `IFR2 0xFFEE02`; EP3 interrupt-IN and SET_CONFIGURATION |
| **238** | `0x54CFA` | **USB interrupt 2** — reads `IFR2 0xFFEE02`, writes `0xFFEE2F` |

Peripherals the firmware services, from that list: **four SCI channels, one USB
function module, at least six 16-bit timer channels, a three-channel DMA
controller, and I/O ports**. The A/D converter is serviced but **polled, not
interrupt-driven** — `ADCSR 0xFFFFA0` is touched by `sub_20FA`, `sub_24B6`,
`sub_32C0` and `sub_3466` and by no vector handler at all.

### 2. On-chip register map

Full per-address table: `ida\out\main-full\ioregs.tsv` (16,893 access sites) and
`absrefs.tsv` (2,272 distinct addresses, rolled up with mnemonics and owning
functions).

| Range | Block | Confidence | Evidence |
| --- | --- | --- | --- |
| `0xFFEE00`–`0xFFEE4F` | **USB Function Module** | **Confirmed** | see §3 |
| `0xFFEE50`–`0xFFEE53` | module-stop / standby control | Inferred | `sub_20FA` writes `0x00` to `0xFFEE50` and `0xFFEE51` at `0x22B8`; `bset #1, @0xFFEE53` at `0x446C4` immediately precedes SCI-D configuration |
| `0xFFF610`–`0xFFF617` | **SCI-D**: SMR/BRR/SCR/TDR/SSR/RDR at +0..+5 | **Confirmed** | init `sub_446BE`; ISR `0x44A70` reads SSR, masks `0x38` errors, clears with `&0x87`, reads RDR; DMA ch0 destination = `0xFFF613` |
| `0xFFFB80`–`0xFFFBCF` | I/O port direction / output registers | Inferred | one constant each at init; `0xFFFBA4` carries 335 bit operations from 21 functions (`bclr` 139 / `bset` 120 / `bst` 72) |
| `0xFFFC00`, `0xFFFC20`, `0xFFFC40` (`0x20` stride) + `0xFFFD20`–`0xFFFD22` | **3-channel DMA controller** | **Confirmed by usage** | `+0x00` source, `+0x04` destination, `+0x0C` byte count, `+0x14` 32-bit mode with bit 31 = enable (`0x800001A0`), `+0x18` = `0x200000`; per-channel activation byte `0xFFFD20+ch` (`0xE1`, `0x96`); vectors 128/129/130. Destinations are the three SCI transmit data registers. |
| `0xFFFD68`, `0xFFFD6A` | 16-bit timer/compare registers | Unknown | word writes from ISRs at vectors 71 and 74 and from `sub_20FA` |
| `0xFFFDC2`–`0xFFFDCC` | bus / clock / refresh configuration | Inferred | `sub_20FA` writes `0x0111`, `0xD103`, `0x5CD4`, `0xE8FF`, `0xB700` once each, before any peripheral setup |
| `0xFFFE90`–`0xFFFE97` | **SCI-A** | **Confirmed** | init `sub_45186` (SCR=0, SMR=0, BRR=0/0x0C, SCR=0x30 then `bset #6`); ISRs `0x45462`/`0x45406`; DMA ch2 |
| `0xFFFEC0`–`0xFFFECB` | 16-bit timer channel | Inferred | 16-byte-stride block; byte writes at +0..+3, word accesses at `0xFFFEC4` and `0xFFFEC8` |
| `0xFFFEE0`–`0xFFFEE7` | 16-bit timer channel | **Confirmed by usage** | vector 66 clears `0xFFFEE5` and reads `0xFFFEE6` while touching `0xFFFFBC` |
| `0xFFFEF0`–`0xFFFEF8` | 16-bit timer channel | Inferred | `sub_2482` writes +0,+1,+2,+4 and words at +6,+8; vector 110 clears `0xFFFEF5` |
| `0xFFFF00`–`0xFFFF5F` | I/O ports (input and output data) | Inferred | read-and-compare and bit-test only; `0xFFFF4D` bit-tested by 9 functions; `0xFFFF5A` carries 74 bit operations from 13 functions |
| `0xFFFF60`–`0xFFFF67` | **SCI-B** | **Confirmed** | `sub_4556E`: `SCR=0` → `SMR=0` → `BRR=0x0C` → `SCR=0x30` → `bset #6, SCR` |
| `0xFFFF88`–`0xFFFF8F` | **SCI-C** | **Confirmed** | `sub_78222`/`sub_7823C`: `SCR=0` → `SMR=0x08` → `BRR=0x0C` → `SCR=0x70`; DMA ch1 destination = `TDR 0xFFFF8B` |
| `0xFFFF90`–`0xFFFF9F` | A/D data registers ADDRA..ADDRH | **Confirmed** | word reads from `sub_32C0` |
| `0xFFFFA0`, `0xFFFFA1` | A/D `ADCSR`, `ADCR` | **Confirmed** | `bset`/`btst`/`bclr` on `0xFFFFA0` (start and end-of-conversion bits) from `sub_32C0`/`sub_3466`; zeroed at init |
| `0xFFFFBC`, `0xFFFFBD` | timer start / sync registers | **Confirmed by usage** | 25 bit operations from 18 functions, one bit per timer channel, always paired with a channel block |
| `0xFFFFC0`, `0xFFFFD0`, `0xFFFFE0`, `0xFFFFF0` (`0x10` stride) | four 16-bit timer channels | **Confirmed by usage** | identical `+0`(control) `+1`(mode) `+2/+3`(I/O control) `+4`(interrupt enable) byte writes at init; `+5` status bit-cleared in the ISRs; `+6` counter and `+8` compare accessed as words |

All four SCI channels use the identical Hitachi SCI register geometry
(`SMR`, `BRR`, `SCR`, `TDR`, `SSR`, `RDR` at +0..+5) and the identical driver
idiom, so the identification is not a guess.

**Clock and baud rates — φ = 16 MHz, confirmed.** There is a four-entry BRR table
at file `0x0452C2`: `67 33 19 0C`, immediately followed by SCI-A configuration
code (`FC 00` / `6A 8C FE 92` = `mov.b #0, r4l; mov.b r4l, @0xFFFE92`). With
`CKS = 0` the SCI bit rate is φ/(32×(BRR+1)), so those four values are:

| BRR | rate at φ = 16 MHz | error |
| --- | --- | --- |
| `0x67` (103) | 4807.7 | +0.16% vs 4800 |
| `0x33` (51) | 9615.4 | +0.16% vs 9600 |
| `0x19` (25) | 19230.8 | +0.16% vs 19200 |
| `0x0C` (12) | 38461.5 | +0.16% vs 38400 |
| `0x00` (0) | **500000.0** | exact |

Four standard rates at the same 0.16% error pins **φ = 16 MHz**. Per channel:

- **SCI-A** `0xFFFE90` — the selectable-rate channel; the 4800/9600/19200/38400
  table at `0x0452C2` belongs to it, and `sub_45186` has two configuration paths
  (`BRR = 0x00` → 500 kbaud, and `BRR = 0x0C` → 38400).
- **SCI-B** `0xFFFF60` — `SMR = 0x00`, `BRR = 0x0C` → 38400, 8N1.
- **SCI-C** `0xFFFF88` — `SMR = 0x08`, `BRR = 0x0C` → 38400. See §10: I do **not**
  see this channel put into clocked-synchronous mode anywhere in my coverage.
- **SCI-D** `0xFFF610` — `SMR = 0x00`, `BRR = 0x00` → **500,000 baud**, 8N1
  (`sub_446BE` at `0x446CA`/`0x446D0`).

**No clocked-synchronous serial and no SPI/SSU block was found.** All four SCI
channels are configured with `SMR` bit 7 = 0, i.e. asynchronous. Scope: all four
SCI blocks, all writes to their `SMR` registers in the 3899 recovered functions.

### 3. USB Function Module at `0xFFEE00` — confirmed, live

Register identification, each line from the code:

| Address | Role | Evidence |
| --- | --- | --- |
| `0xFFEE00` | `IFR0` interrupt flags 0 | `sub_54D50` (vector 234) reads it and dispatches bits 7,3,2,1,0 with the read / `bclr` the serviced bit / `or.b` mask / write-back idiom |
| `0xFFEE01` | `IFR1` | `sub_54EC2` (vector 235), bits 0,2,1 |
| `0xFFEE02` | `IFR2` | `sub_54CFA` (vector 238) and `sub_54EC2`, bits 4,5,3 |
| `0xFFEE04/05/06` | `IER0/1/2` interrupt enable | `sub_54C44` writes `0x8D`, `0x03`, `0x18`; `sub_55620` later raises IER0 to `0x8F` |
| `0xFFEE08/09/0A` | `ISR0/1/2` interrupt select | `sub_54C44` writes `0x00`, `0x07`, `0x1F` |
| `0xFFEE0C` | `EPDR0i` — control IN FIFO | `sub_54D50` writes up to 8 bytes in a loop from `0xFFB09E`, count `0xFFB094` |
| `0xFFEE0D` | `EPDR0o` — control OUT FIFO | `sub_54D50` drains `@0xFFEE24` bytes into `0xFF3C6A` |
| `0xFFEE0E` | `EPDR0s` — **SETUP FIFO** | `sub_54D50` reads **exactly 8 bytes** into the ring `0xFF3CEA`–`0xFF3D69`. A USB SETUP packet is exactly 8 bytes. |
| `0xFFEE10` | `EPDR1` — bulk OUT FIFO, 64 B | `sub_55652` drains `@0xFFEE25` bytes into `0xFF5806+i` |
| `0xFFEE14` | `EPDR2` — bulk IN FIFO, 64 B | endpoint table row, `0x7B5D0`; not reached by absolute addressing (table-driven only) |
| `0xFFEE18` | `EPDR3` — interrupt IN FIFO, 8 B | `sub_54EC2` and `sub_557A2` push a 3-byte report |
| `0xFFEE24` | `EPSZ0o` — control OUT size | used as the loop count for `EPDR0o` |
| `0xFFEE25` | `EPSZ1` — bulk OUT size | used as the loop count for `EPDR1` |
| `0xFFEE27`, `0xFFEE28`, `0xFFEE2A`, `0xFFEE2E`, `0xFFEE44` | endpoint status / stall / address | `0x73` written to `0xFFEE28` on reset and at init |
| `0xFFEE2C` | `TRG` — packet trigger | written `0x01` after filling EP0i, `0x02` after draining EP0o, `0x04` after reading SETUP, `0x20` after EP1, `0x40` after EP3 |
| `0xFFEE2D` | module enable | `bset #2` at `0x54CA6`, `0x78154`, `0x78216` |
| `0xFFEE2F` | suspend/resume control | `sub_54CFA` writes `0x08` then `0x00` |
| `0xFFEE32` | configuration FIFO | `sub_54BF8` writes 50 bytes from `byte_54C12` to this single address in a loop |

Control-transfer handling, `sub_54FEC` onward — this is the decisive evidence:

```
00054FEC  mov.b  @0xFFFF8183:16, r3l      ; state
00054FF6  shll.l #2, er3
00054FF8  78 b0 6b 26 00 05 50 02         ; mov @(0x55002:32,er3), er6
00055000  59 60                           ; jmp @er6      -> 12-entry table
...
00055074  mov.l  @0xFF3D6A:32, er2        ; first 4 bytes of the SETUP packet
0005507C  cmp.w  #0x8006, e2              ; bmRequestType 0x80 | bRequest 0x06
00055080  beq    loc_550D8                ;   = GET_DESCRIPTOR
00055082  cmp.w  #0xC1D4, e2              ; vendor IN,  bRequest 0xD4
00055088  cmp.w  #0x41D3, e2              ; vendor OUT, bRequest 0xD3
0005508E  cmp.w  #0x41D1, e2              ; vendor OUT, bRequest 0xD1
00055094  cmp.w  #0x41D2, e2              ; vendor OUT, bRequest 0xD2
...
000550E0  cmp.b  #1, r2l                  ; descriptor type 1 = DEVICE
000550E4  cmp.b  #2, r2l                  ;                2 = CONFIGURATION
000550E8  cmp.b  #3, r2l                  ;                3 = STRING
```

The accepted-request table is at file `0x5593E`, seven 8-byte entries, byte-exact:

```
0005593E  80 06 00 01 00 00 12 00   GET_DESCRIPTOR(DEVICE),        wLength 18
00055946  80 06 00 02 00 00 09 00   GET_DESCRIPTOR(CONFIGURATION), wLength 9
0005594E  80 06 00 02 00 00 20 00   GET_DESCRIPTOR(CONFIGURATION), wLength 32
00055956  c1 d4 00 00 00 00 01 00   vendor IN  0xD4, wLength 1
0005595E  41 d1 ff ff ff ff 00 00   vendor OUT 0xD1, wValue/wIndex wildcard
00055966  41 d2 ff ff ff ff 00 00   vendor OUT 0xD2
0005596E  41 d3 ff ff ff ff 00 00   vendor OUT 0xD3
```

### 4. Complete descriptor inventory

Found by signature scan over the whole content region (`12 01` device,
`09 02` configuration, `xx 03` string with UTF-16LE ASCII body):

**Stack A (vendor class), device descriptor at file `0x055818`:**
```
12 01 00 02 00 00 00 08 aa 26 01 00 00 00 00 00 00 01
bcdUSB 0x0200  class 0x00  bMaxPacketSize0 8
idVendor 0x26AA  idProduct 0x0001  bcdDevice 0x0000  1 configuration
```
Six copies of its 32-byte configuration descriptor at `0x05582A`, `0x05585E`,
`0x05587E`, `0x05589E`, `0x0558BE`, `0x0558DE`, identical except the final
`bInterval` byte (`0x64`, `0x14`, `0x64`, `0x96`, `0xC8`, `0xFA`):
```
09 02 20 00 01 01 00 c0 32   CONFIGURATION wTotalLength 32, 1 interface, 100 mA
09 04 00 00 02 ff 01 ff 00   INTERFACE 0, 2 endpoints, class 0xFF/0x01/0xFF
07 05 01 02 40 00 00         ENDPOINT 0x01 OUT, bulk, 64 bytes
07 05 83 03 08 00 <interval> ENDPOINT 0x83 IN, interrupt, 8 bytes
```
The selector is deliberately pinned: `0x550FE` loads `@0xFFFF89CF` into `r5l`
and the very next instruction (`fd 00`) overwrites it with 0, so entry 0
(`bInterval 0x64`, 100 ms) is always used.

**Stack B (CDC-ACM), device descriptor at file `0x07B680`:**
```
12 01 10 01 02 00 00 08 aa 26 20 00 00 01 00 00 03 01
bcdUSB 0x0110  class 0x02 (CDC)  bMaxPacketSize0 8
idVendor 0x26AA  idProduct 0x0020  bcdDevice 0x0100  iSerialNumber 3
```
Configuration descriptor set at file `0x07B711`, `wTotalLength 0x43` = 67, and
9+9+5+4+5+5+7+9+7+7 = 67 checks out:
```
09 02 43 00 02 01 00 c0 10   CONFIGURATION, 2 interfaces, self-powered, 32 mA
09 04 00 00 01 02 02 01 00   INTERFACE 0, class 0x02/0x02/0x01 (CDC ACM, AT cmd)
05 24 00 10 01               CS_INTERFACE Header, bcdCDC 0x0110
04 24 02 06                  CS_INTERFACE ACM, bmCapabilities 0x06
05 24 06 00 01               CS_INTERFACE Union, master 0, slave 1
05 24 01 03 01               CS_INTERFACE Call Management, data interface 1
07 05 83 03 08 00 10         ENDPOINT 0x83 IN, interrupt, 8 bytes, 16 ms
09 04 01 00 02 0a 00 00 00   INTERFACE 1, class 0x0A (CDC Data), 2 endpoints
07 05 01 02 40 00 00         ENDPOINT 0x01 OUT, bulk, 64 bytes
07 05 82 02 40 00 00         ENDPOINT 0x82 IN,  bulk, 64 bytes
```

**String descriptors**, file `0x07B270`–`0x07B2A5`:
`04 03 09 04` (LANGID 0x0409), `0x07B276` `10 03` = `"Renesas"` UTF-16LE,
`0x07B286` `1A 03` = `"000000000000"` UTF-16LE. These are read straight out of
ROM: `0x77E3A` does `mov.l #unk_7B260, er1`.

**Endpoint configuration table**, 6 records of 20 bytes at file `0x07B57A`
(RAM `0xFF6308` after the `.data` copy), pairing a buffer address with a FIFO
register and a packet size — this is what ties the descriptors to the hardware:

| Buffer | FIFO register | size | endpoint |
| --- | --- | --- | --- |
| `0xFF6420` | `0xFFEE0E` | 8 | EP0 SETUP |
| `0xFF6420` | `0xFFEE0C` | 8 | EP0 IN |
| `0xFFEE24` | `0xFFEE0D` | 8 | EP0 OUT (size register `0xFFEE24`) |
| `0xFF6420` | `0xFFEE18` | 8 | EP3 interrupt IN |
| `0xFF6423` | `0xFFEE14` | **64** | EP2 bulk IN |
| `0xFFEE25` | `0xFFEE10` | **64** | EP1 bulk OUT (size register `0xFFEE25`) |

The descriptor-pointer table just below it, file `0x07B5F0`, holds
`00 FF 64 0E` and `00 FF 64 9F` — the **RAM addresses** the device descriptor
(`0x7B680` → `0xFF640E`) and the configuration descriptor (`0x7B711` →
`0xFF649F`) land at after the `.data` copy. The mapping is exact, which
independently confirms both the copy and the pointer table.

Provenance: the block at file `0x07B699`–`0x07B710` is
`MANUFACTURER:ACME Manufacturing;COMMAND SET:PCL,MPL;MODEL:LaserBeam ?;COMMENT:Anything you like;ACTIVE COMMAND SET:PCL;`
— the IEEE-1284 device-ID example from the USB printer-class specification, as
shipped in the Renesas USB Function Module sample code. Together with the
`"Renesas"` string descriptor this dates the stack as a Renesas USBF sample
adapted by Yaesu. The `idVendor 0x26AA` is not resolvable from this package
(**Unknown** whose it is).

### 5. Which stack runs, and why — the boot selector

```
000021F8  mov.b  #0, r4l
000021FA  mov.b  r4l, @0xFFFF813A:16        ; usb_mode = 0
000021FE  mov.b  #0xC8, r6l                 ; 200 attempts
00002200  mov.b  @0xFFFFFF4C:8, r4l         ; read port 0xFFFF4C
00002202  and.b  #0x7F, r4l
00002204  cmp.b  #0x7D, r4l
00002206  beq    loc_221E
00002208  dec.b  r6l
0000220A  bne    loc_2200
0000220C  mov.b  r4l, @0xFFFF813B:16
00002210  cmp.b  #0, r1l
00002212  bne    loc_2218
00002214  jsr    sub_54BF8:24               ; stack A: 50-byte block -> 0xFFEE32
00002218  jsr    sub_54C44:24               ; stack A: IER/ISR/EPDR/TRG init
0000221C  bra    loc_2240
0000221E  mov.b  r4l, @0xFFFF813B:16
00002222  mov.b  #1, r4l
00002224  mov.b  r4l, @0xFFFF813A:16        ; usb_mode = 1
00002228  jsr    sub_55FFE:24
00002234  jsr    loc_78106:24               ; stack B (CDC) init
```

`0xFFFF4C` is read 200 times at boot, masked with `0x7F` and compared to `0x7D`.
If it matches, `0xFF813A` is set to 1 and **stack B (CDC-ACM)** is brought up;
otherwise **stack A (vendor)** is. The same flag gates the ISR: `sub_54D50`
begins `mov.b @0xFFFF813A:16, r4l; bne loc_54EA8`, and `loc_54EA8` calls
`0x7827C` — stack B's interrupt service. So the two stacks share the one USB
module and the one interrupt vector set, arbitrated by `0xFF813A`.

What `0xFFFF4C == 0x7D` physically means is **Unknown** from this image. It is
read as an 8-bit absolute port byte and is never written, so it is an input.
`0xFFFF4D`, the neighbouring byte, is bit-tested by 9 functions (bits 2, 3, 4),
which is the signature of a switch/detect port. The program switch behind the
DATA jack is the obvious candidate but I have no evidence for it — **MAIN-IO
owns this; see the hand-off.**

### 6. Stack A's bulk data path

```
00055652  mov.b  @0xFFFFEE25:16, r4h        ; EPSZ1 = OUT packet size
00055678  mov.w  @0xFFFFBA6C:16, r5         ; write index
0005567E  add.l  #0xFF5806, er5
00055684  mov.b  @0xFFFFEE10:16, r4l        ; drain EPDR1
00055688  mov.b  r4l, @er5
0005568A  adds   #1, er5
0005568C  dec.b  r4h
0005568E  bne    loc_55684
0005569A  jsr    sub_55976:24               ; page complete?
0005569E  cmp.w  #0x400, r5                 ; 1024 bytes buffered
000556A4  jsr    sub_55A2C:24
000556C2  mov.b  r4l, @0xFFFFEE2C:16        ; TRG = 0x20, re-arm EP1
```

`sub_55976` treats the 1 KB region as four 256-byte pages at `0xFF5806`,
`0xFF5906`, `0xFF5A06`, `0xFF5B06`, and on each page boundary sets
`0xFFBC48` = page address, `0xFFBC3E` = `0x100`, and calls `sub_B610`, which
builds a command record at `0xFF3D72`–`0xFF3D81` and decrements a remaining-byte
counter at `0xFFB098`. So stack A is a **host→radio block transport**: 64-byte
bulk OUT packets accumulated into 256-byte pages, with an 8-byte status report
returned on the interrupt IN endpoint every 100 ms. Stack A has **no bulk IN
endpoint** — its descriptor set offers only EP1 OUT and EP3 interrupt IN.

### 7. Region and data map

`ida\out\main-full\region_map.tsv` (80 coarse rows plus named sub-regions) and
`items.tsv` (exact item-class runs). Content region `0x000000`–`0x07B753`:

| Class | Bytes | Share |
| --- | --- | --- |
| code-dominant | 401,408 | 79.4% |
| data | 35,668 | 7.1% |
| mixed code/data | 33,792 | 6.7% |
| pointer tables | 16,384 | 3.2% |
| text | 11,264 | 2.2% |
| mostly zero | 7,168 | 1.4% |

Named regions:

| Range (file offsets) | Content |
| --- | --- |
| `0x000000`–`0x0003FF` | exception vector table, 256 big-endian dwords |
| `0x000400`–`0x07B2A5` | code interleaved with constant pools, switch tables, pointer tables, 16-bit parameter tables |
| `0x003CC0`–`0x003EA0` | APRS type names, 8-byte stride: `Mic-E`, `FIXED`, `WEATHER`, `OBJECT`, `KILLOBJ`, `ITEM`, `KILLITM`, `STATUS`, `OTHER`, `MOVING`, in upper and lower case |
| `0x00C056`–`0x00C670` | byte table, see below (`!sdr`) |
| `0x0110 8A`–`0x01208C` | zero fill, 4098 bytes |
| `0x01226C`–`0x0148A0` | tables of 32-bit big-endian code pointers |
| `0x02702A`–`0x02853E` | 16-bit parameter/calibration table |
| `0x040482`–`0x0437BE` | broadcast-station name table, 20-byte stride (`VOA`, `BBC`, …) — the shortwave broadcast memory list |
| `0x046E10`–`0x047110` | rolling 0..15 index table |
| `0x04C52A` | `"(In Service) "` — APRS status text, as the earlier pass identified |
| `0x055818`–`0x0558FE` | **stack A USB descriptors** (1 device + 6 configuration) |
| `0x05593E`–`0x055976` | **stack A accepted-SETUP table**, 7 entries |
| `0x0717F5`–`0x073030` | zero fill, three blocks |
| `0x07B100`–`0x07B270` | JIS ku-ten index table |
| `0x07B270`–`0x07B2A5` | **USB string descriptors** |
| `0x07B2A6`–`0x07B753` | **C `.data` section image**, 1198 bytes → RAM `0xFF6034` |
| `0x07B4B0`–`0x07B680` | stack B descriptor-pointer and endpoint tables |
| `0x07B680`–`0x07B753` | **stack B device + CDC-ACM configuration descriptors** |
| `0x07B754`–`0x0FFFFF` | `0xFF` erase fill, 542,892 bytes, no content |

### 8. `!sdr` at `0xC4B3` resolved — coincidence, not SDR

The bytes are:

```
0000C4A2  02 02 02 02 02 02 21 63 64 72 5c 62 02 02 02 02   ......!cdr\b....
0000C4B0  02 02 21 73 64 72 5c 62 00 0c 01 01 01 01 01 01   ..!sdr\b........
0000C4BE  01 01 21 63 64 72 5c 62 01 01 01 01 01 01 21 73   ..!cdr\b......!s
0000C4CC  64 72 5c 62 02 00 02 02 02 02 6d 00 70 76 6e 62   dr\b......m.pvnb
```

This is a binary table whose whole alphabet is `{0x00, 0x01, 0x02}` for the
separator/flag bytes and `{0x21, 0x22, 0x31–0x35, 0x49–0x50, 0x5A–0x76}` for the
payload bytes. `21 73 64 72 5C 62` reads as `!sdr\b` and the group nine bytes
earlier, `21 63 64 72 5C 62`, reads as `!cdr\b` — they differ by exactly one
byte (`0x73` vs `0x63`). Nearby groups are `6C 69 63 72 5C 62` (`licr\b`),
`6C 69 73 72 5C 62` (`lisr\b`), `5A 49 4D 4E` (`ZIMN`), `5A 5D 5C` (`Z]\`),
`6D 00 70 76 6E 62` (`m.pvnb`). No natural-language reading survives, and
`0x63`/`0x73` are simply two neighbouring values in this table's payload
alphabet. The table has no ASCII string anywhere in it and is not referenced by
any string-handling code. **`!sdr` is a coincidence of the byte values; the table
is an indexed byte table (the payload alphabet is consistent with LCD icon or
glyph indices, but which is Unknown).** Note also that my forced linear sweep
mis-decoded this region as instructions; pass 8 removed 1230 such shredded runs,
and the region is correctly data.

### 9. Coverage, before and after

| Metric | Earlier pass | This pass |
| --- | --- | --- |
| Functions | 1298 | **3899** (3226 with ≥1 cross-reference, 673 sweep-only) |
| Bytes inside functions | 112,602 (22.3%) | **279,472 (55.3%)** |
| Content bytes decoded as instructions | not reported | **380,620 (75.3%)** |
| Explicit data items | — | 5,788 (1.1%) |
| Left as raw bytes | — | 119,276 (23.6%) |
| Content region | `0x000000`–`0x07B753`, 505,684 bytes | same, confirmed by byte scan |
| Fill above content | — | `0x07B754`–`0x0FFFFF`, 542,892 bytes of `0xFF` |
| Vector slots decoded | 256, 1 handler named | 256, **30 occupied slots attributed to peripherals** |
| Switch/jump tables resolved | 0 | 157 switch tables + 149 aligned pointer tables |

The remaining 23.6% is dominated by the data regions listed in §7 (station-name
text, zero fill, pointer tables, 16-bit parameter tables, the JIS index table),
which are correctly *not* code.

### 10. DATA-jack external control command API

This is the radio's external control interface on **SCI-A** (`0xFFFE90`, the
DATA-jack / external-PC port, 4800–38400 baud selectable). MAIN-IO reconstructed
the frame and a first dispatch table (`clone_commands.tsv`); this pass verified
all of it independently in `MAIN_FULL`, filled the two handler gaps MAIN-IO left
(`W` at `0x6BD0A`, `N` at `0x6BFB4`), and traced every handler's data source and
sink to answer the security question the leads raised. Machine-readable table:
`ida\out\main-full\data_jack_commands.tsv`; parsed dispatch chains in
`cmd_dispatch.tsv`; per-handler effect flags in `cmd_effects.tsv`; annotated
disassembly of `0x06B700`–`0x06D120` in `cmd_disasm.txt`; frame templates in
`cmd_templates.txt`.

**Frame** (confirmed, `sub_6B77E` at `0x06B77E`):

```
[0]           0x01                SOH
[1]           command letter      ASCII (dispatched by sub_6BAC8)
[2..5]        4 ASCII hex digits  N = payload length  (decoded by sub_6CB5E)
[6 .. 6+N-1]  payload             N bytes, ASCII
[6+N]         0x04                EOT   (mismatch -> NAK)
[7+N][8+N]    2 ASCII hex digits  8-bit additive-sum checksum, accum in 0xFFB3DC
total         N + 9
```

The assembler drains the SCI-A receive ring `0xFF27C8` into a frame buffer at
`0xFF1AC8`; at 9 accumulated bytes it calls `sub_6CB5E` (which runs the two-hex
decoder `sub_6CB40` over frame `[2][3]`/`[4][5]`) to get `N` into `0xFFB3CA`,
then waits for `N+9`. `sub_6CB40` is `'0'-'9' -> &0x0F`, `'A'-'F' -> +0xC9`,
`<<4`, `or`. Verified against a literal frame at `0x06C598` = `01 'B' 30 30 30 31
30 04` (`N`=1, total 10).

**Dispatcher** `sub_6BAC8` at `0x06BAC8` — a `cmp.b`/`beq` chain on the frame
letter read from `0xFF1AC9` (from `cmd_dispatch.tsv`):

| Letter | Byte | Dispatch target | Handler / effect |
| --- | --- | --- | --- |
| `V` | `0x56` | `0x6BB00`→`0x6BB08` | **SOFTWARE RESET** (below); or identify when `0xFF8DDE.7` set |
| `B` | `0x42` | `0x6BADC`→`0x6BE9C` | 1-byte status get/ack; optional `loc_1CA72` action |
| `C` | `0x43` | `0x6BAE2`→`0x6BEF6` | 11-byte record (shares `sub_6BED8`) |
| `F` | `0x46` | `0x6BAE8`→`0x6BB2E` | `sub_6C686` + reply `sub_6BF44` |
| `E` | `0x45` | `0x6BAEC`→`0x6BB22` | `sub_6C850` + reply `sub_6BF6C` |
| `S` | `0x53` | `0x6BAF0`→`0x6BB18` | `sub_6C8E8` + reply `sub_6BF8C` |
| `N` | `0x4E` | `0x6BAF4`→`0x6BFB4` | status/data read from fixed RAM fields |
| `W` | `0x57` | `0x6BAFA`→`0x6BD0A` | inbound state step; outbound = APRS position record |

`M` (`0x4D`) is handled one level up in the session gate `sub_6B9AC` (`0x6B9FE`),
which requires the first frame to be `V` and then accepts `V` or `M`. The
outbound-only builders `H`/`R`/`P` are driven by the data-phase pump `sub_6BA46`
and `sub_6BB4C` on bits of `0xFFB3D7`. Full per-command detail, with reply
templates at `0x06C536`–`0x06C60A`, is in `data_jack_commands.tsv`.

**The three security-relevant capabilities, verified:**

1. **Software reset — Confirmed.** Two sites, byte-identical:
   `0x06B7DC` (in the assembler) and `0x06BB08` (the `V` handler):
   ```
   0006BB08  mov.b  @0xFF8DDE:16, r4l
   0006BB0C  bmi    loc_6BB12          ; skip reset when 0xFF8DDE bit7 set
   0006BB0E  jsr    sub_2648:24
   0006BB12  orc    #0x80, ccr         ; mask interrupts
   0006BB14  jmp    loc_2050:24        ; re-enter startup
   ```
   So the `V` command **reboots MAIN** (when `0xFF8DDE` bit 7 is clear). It
   re-enters MAIN's own startup at `0x2050`, not a bootloader.

2. **RAM-out DMA — Confirmed, but bounded to the response frame.** The response
   path `0x06B91A` arms DMAC channel 2:
   ```
   0006B926  mov.w  @0xFFB3CC:16, r3       ; length (radio-computed, <=0xFFFF)
   0006B92E  mov.l  #0xFEE000, er5         ; SOURCE = hardcoded immediate
   0006B948  mov.l  er5, @0xFFFC40         ; DMA ch2 MAR = 0xFEE000
   0006B94E  mov.l  #0xFFFE93, er4
   0006B954  mov.l  er4, @0xFFFC44         ; DMA ch2 DAR = SCI-A TDR
   0006B95A  mov.l  er3, @0xFFFC4C         ; DMA ch2 count = 0xFFB3CC
   0006B96E  mov.b  #0xA2, @0xFFFD22       ; activation = SCI-A TXI
   0006B972  mov.l  #0x800001A0, @0xFFFC54 ; enable
   0006B97E  bset   #7, @0xFFFE92          ; SCI-A SCR.TIE -> start
   ```
   The source is a **hardcoded immediate** `#0xFEE000`; the length `0xFFB3CC` is
   written **only** by the finalizer `loc_6CC76` as `framelen+2` (verified: sole
   writer at `0x06CC7A`, sole reader at `0x06B926`). So this streams the assembled
   response frame (≤ ~194 bytes) out SCI-A — the outbound half of the clone
   protocol. **No command exposes an attacker-chosen source address or length; it
   is not an arbitrary RAM dump.**

3. **Settings write — RAM only, never NV.** `M` echoes 74/76 received bytes into
   the staging buffer `0xFEE000` and updates RAM config vars `0xFFB12F`–`0xFFB131`
   (via `sub_6C652`→`sub_25EAE` / `sub_6C680`→`sub_2611A`). `W`/`C`/`P` write
   fixed APRS/record buffers. **`cmd_effects.tsv` shows no handler calls the
   bit-banged EEPROM driver (`sub_334CA`/`sub_33532`) or any flash routine** — a
   grep of the whole `0x6B700`–`0x6D120` region for those callees is empty. So the
   API changes RAM-resident state only; persistence is a separate matter.

**Read commands are all bounded, fixed-source.** `R` (`sub_6C344`, the largest
read at 187 bytes) reads a **fixed 45/65/90 bytes from the fixed address
`0xFEE944`** (the APRS/beacon record store), hex-encodes them with `sub_6CC4A`,
and the block size is chosen by a RAM selector `0xFEEAAC` — the host's 4-hex
"record index" (`0xFFB3D0`) is only encoded into the reply header, never used as
an address offset. `N` reads fixed fields `0xFF9C64`/`0xFF9CC6`. `H` reads fixed
`0xFEEB14`. None performs host-controlled address arithmetic.

**Net:** the DATA-jack port is a Yaesu clone/CAT interface (`V0030FT3D…` is the
clone-file format tag, `0x06C536`). Its full external control power is: identify,
reboot the radio (`V`), read/write structured clone and APRS/GPS records in fixed
RAM buffers, and exchange model/destination. It is **not** a memory-peek/poke or
a firmware loader.

*Caveat on this pass:* the conservative `create_insn` fill turned the small
pointer table at `0x06BD26`–`0x06BD3D` (six big-endian pointers into the
`0x6BCD6` sub-state machine) into instructions in the listing; it is data, not
code, and does not affect any conclusion above.

### 11. H8S part identification

**Inferred (strong): the MAIN processor is an H8S/2456-group MCU** (H8S/2456 /
2456R / 2454), a 16-bit **H8S/2600-core** device carrying the Renesas **USB
Function Module**. The exact die and flash variant (e.g. the `R4F24568` flash
part) is **Unknown** from this package, but the family is well supported and the
previously-suspected H8S/237x and the sibling H8S/2472 group are **excluded**.

Evidence — the recovered register map (§2) is a narrow fingerprint:

- On-chip **USB Function Module** at `0xFFEE00` with the register nomenclature
  `IFR0/1/2`, `IER0/1/2`, `ISR0/1/2`, `EPDR0i/0o/0s`, `EPDR1/2/3`, `EPSZ0o`,
  `EPSZ1`, `TRG`, `FCLR` (§3). This is the Hitachi/Renesas *USB Function Module*
  block, and the leftover Renesas sample string at `0x07B699`
  (`…ACME Manufacturing;COMMAND SET:PCL,MPL;MODEL:LaserBeam…`) is that block's
  application-note boilerplate.
- Peripheral set: three-channel **DMAC** (`0xFFFC00`/`20`/`40`), a **TPU** 16-bit
  timer unit (`0xFFFFC0`–`0xFFFFFF`), multiple 8-bit **TMR** channels
  (`0xFFFEC0`/`E0`/`F0`), **four SCI** channels plus an unused fifth, on-chip
  **A/D** (`0xFFFF90`/`A0`) — and no Ethernet/E-DMAC and no 14-bit PWM.
- φ = 16 MHz (§2), RAM from `0xFEE000` (≥ ~48 KB used), ≥ 512 KB flash (content
  ends at `0x07B753` = 505,171 bytes, inside a 512 KB MAT).

The Renesas H8S/2456 group is documented as an H8S/2600-core MCU with exactly
this on-chip complement — "DMAC, DTC, TPU, 8-bit TMR, WDT, USB, two types of SCI,
A/D, D/A, I/O ports." The sibling **H8S/2472/2463/2462 group is excluded**: it
carries an **E-DMAC (Ethernet)**, only **two** SCI channels, and a 14-bit PWM —
none of which appear in MAIN. The **H8S/237x** group is excluded by the §2
register-map mismatch (timer-start register position, `0xFFFF60` being an SCI,
and the presence of the USB module). Fully confirming the member would need the
H8S/2456 hardware manual's register table checked against `absrefs.tsv`
address by address; that byte-level match was not performed, hence *Inferred*.

## USB relevance

**Question 1 — everything USB.** The centre of gravity moves to MAIN. The radio
firmware on the H8S side contains a complete USB device implementation:
a hardware USB function module at `0xFFEE00` released from module stop at boot,
three live interrupt vectors, EP0 control transfer handling with real
`GET_DESCRIPTOR` decoding, four vendor control requests, a 64-byte bulk OUT data
path with a 1 KB page assembler, an interrupt IN status channel, and a second
complete CDC-ACM personality with bulk IN as well as bulk OUT. All addresses are
in §3 and §4. The Windows-side `RComms.dll` / `RFP_USB_VB.dll` story (Renesas
boot device, `VID_045B&PID_0025`) is the *updater* path; it is not the only USB
in this system.

**Question 2 — USB SDR.** Judging the four links for MAIN specifically:

1. *Sample source* — **missing.** MAIN's only converter is the on-chip A/D at
   `0xFFFF90`–`0xFFFFA1`, and it is polled, not interrupt- or DMA-driven: no
   vector handler touches `ADCSR`, and no DMA channel's source or destination is
   an A/D register (the three channels move to SCI transmit registers
   `0xFFF613`, `0xFFFF8B`, `0xFFFE93`). Scope: all 16,893 absolute-operand sites
   in 3899 functions. This is a control-measurement A/D, not an IF sampler.
2. *Path into a processor* — partially present. Three DMA channels exist, all
   wired to SCI transmit.
3. *USB engine* — **present, and this is new.** A full-speed function module
   with a 64-byte **bulk IN** endpoint (EP2, `EPDR2` at `0xFFEE14`) declared in
   the CDC configuration descriptor at file `0x07B711`. Full-speed bulk is
   12 Mbit/s raw; a 64-byte-per-packet single-byte FIFO drained in software on an
   H8S will fall well short of that, and no DMA channel targets `0xFFEE14`, so
   the practical ceiling is **Unknown** but modest.
4. *Firmware* — the transport exists; the sample source does not.

So for MAIN the missing link is link 1 (and the DMA plumbing of link 2), not
link 3. That is a materially different answer from "no USB anywhere". A USB
bulk IN pipe that a host can open already exists in this firmware; what does not
exist is anything feeding it IQ.

**Question 3 — DSP / vocoder.** Nothing in MAIN matches the AMBE-3000R
hypothesis. **Not found**, scope stated: (a) no `AMBE`, `DVSI`, `PRODID`,
`VERSTRING`, `RATEP`, `RATET` string anywhere in the 1 MB image; (b) nine sites
load the immediate `0x61` into a byte register and **none** of them is within 96
bytes of a write to any of the four SCI transmit data registers; (c) the eleven
byte sequences matching `61 00 ll tt` are isolated in data with no surrounding
frame structure; (d) no clocked-synchronous serial or SPI/SSU register block
exists — all four SCI channels are configured asynchronous. If MAIN reaches a
vocoder it does so over one of the four async SCI channels with a proprietary
frame, or the vocoder hangs off SUB.

## Open

Most valuable first.

1. **What `0xFFFF4C == 0x7D` is.** This one byte decides whether the radio comes
   up as a vendor USB device or as a CDC virtual COM port. It is read-only, 200
   polls, at boot. Trace the port bit to a physical line (program switch, cable
   detect, SUB handshake). This is the single highest-value unknown in MAIN.
2. **The four vendor control requests.** `0x41D1`, `0x41D2`, `0x41D3` (host→
   device) and `0xC1D4` (device→host, 1 byte). Their handlers are reached through
   the 12-entry dispatcher table at `0x55002`; states 6–11 are at `0x551DA`,
   `0x55306`, `0x55520`, `0x55552`, `0x55306`, `0x556C8`. If one of them writes
   memory or flash, MAIN's USB is a debug/loader channel and mission question 1
   is answered far more strongly than the updater path alone suggests.
3. **Where the 256-byte bulk-OUT pages go.** `sub_B610` (`0xB610`, 166 bytes,
   4 callers) builds a record at `0xFF3D72` from `0xFFBC48`/`0xFFBC3E`. Find the
   consumer: clone-image write, flash programming, or a relay to SUB.
4. **Whether stack B (CDC) is reachable on production hardware**, and what it
   carries. It has bulk IN as well as bulk OUT and its own SCI configuration
   (`sub_78222` sets up SCI-C), which reads like a USB↔serial bridge — the exact
   shape a CAT-over-USB or a MAIN↔SUB pass-through would take.
5. **Close the last 23.6%.** The residue is mostly data, but the regions
   `0x040548`–`0x0436A6` and `0x078514`–`0x07B100` deserve a typed pass (the
   former is a 20-byte-stride record table, the latter is stack B's working
   data), and the 673 sweep-only functions should be confirmed or dropped.
6. **Pin the H8S part number — now narrowed to the H8S/2456 group (§11).**
   Family and core are settled (H8S/2600 core, Renesas USB Function Module;
   H8S/237x and H8S/2472 excluded). What remains is the exact member/flash
   variant: fetch the H8S/2456 hardware manual and check its register table
   against `absrefs.tsv` address by address (especially the `0xFFEE00` USB base
   and the `0xFFF610` SCI), which would turn a dozen "Inferred" rows in §2 into
   "Confirmed" and give exact bit names.

7. **DONE this resume — the DATA-jack command API (§10).** For a next pass, the
   only loose ends are the semantics of the `M`-commit callees `sub_25EAE` /
   `sub_2611A` (which RAM config bytes they finalise) and `loc_1CA72` (the `B`
   action), and whether any *other* subsystem later commits the RAM config the
   API writes into the serial EEPROM.

## Hand-offs

**To MAIN-IO** (external interfaces, DATA jack, program switch, clone/CAT, boot):

- Four SCI channels, all confirmed by the identical init idiom. Register bases,
  init routine, and ISRs:

  | Channel | Base | Init | RX ISR (vectors) | TX ISR | RX ring | DMA |
  | --- | --- | --- | --- | --- | --- | --- |
  | SCI-A | `0xFFFE90` | `sub_45186`, `sub_452C6`, `sub_734C2`, `sub_73540` | `0x45462` (160, 161) | `0x45406` (162) | `0xFF27C8`–`0xFF29C7` or `0xFF95F8`–`0xFF96F7`, chosen by `0xFF817F` bit 7 | ch2 `0xFFFC40`, vector 130 |
  | SCI-B | `0xFFFF60` | `sub_4556E`, `sub_48BF2` | `0x45520` (152, 153) | `0x454E2` (154) | `0xFF1AC8`–`0xFF23C7` (2.25 KB) | — |
  | SCI-C | `0xFFFF88` | `sub_78222`, `sub_7823C` | `0x5615C` (148, 149) → calls `0x7711E` | vector 150 is an `rte` stub; TX is DMA | — | ch1 `0xFFFC20`, `sub_4834E`, vector 129 |
  | SCI-D | `0xFFF610` | `sub_446BE` | `0x44A70` (224, 226) | — | `0xFF306A`–`0xFF3C69` (3 KB) | ch0 `0xFFFC00`, `sub_482D4`, vector 128 |

  Layout in all four: `SMR +0`, `BRR +1`, `SCR +2`, `TDR +3`, `SSR +4`,
  `RDR +5`. All configured asynchronous (`SMR` bit 7 = 0). `BRR = 0x0C`.
  Error mask in every RX ISR is `0x38`, cleared by `AND 0x87`.
- Boot selector: `0xFFFF4C` (8-bit absolute port read, masked `0x7F`, compared
  `0x7D`, 200 polls, at `0x2200`), result stored in `0xFF813B`, decision in
  `0xFF813A`. `0xFFFF4D` bits 2/3/4 are tested by `sub_2FA7A`, `sub_30590`,
  `sub_3080C`, `sub_31522`, `sub_31F9E`, `sub_32202`, `sub_34960`, `sub_3E864`
  and written by `sub_74310` — the likeliest switch/detect port.
- Boot path: reset `0x2092` → `sub_20FA` (`0x20FA`, the C runtime and full
  hardware init, 850 bytes) → `sub_20D8` self-test → `loc_27AE` main. `sub_24B6`
  (vector 67) is a software re-entry that repeats the same sequence.
- Port blocks to chase: `0xFFFF00`–`0xFFFF5F` (inputs and outputs, bit-banged)
  and `0xFFFB80`–`0xFFFBCF` (direction/output, one constant each at init).
  `0xFFFBA4` is the busiest register in the image: 335 bit operations from 21
  functions.
- Everything per-address is in `ida\out\main-full\ioregs.tsv` and `absrefs.tsv`;
  per-vector register sets in `vector_map.tsv`.

**To DSP-AMBE:**

- MAIN has **no SPI, no SSU, and no clocked-synchronous serial**. All four SCI
  channels are async. If MAIN talks to a vocoder it is over one of the four SCIs
  above, and the three with a large RX ring (SCI-B 2.25 KB, SCI-D 3 KB, SCI-A
  1 KB) are the candidates worth framing analysis.
- AMBE-3000R framing: **not found** in MAIN. Scope and negative evidence in the
  "Question 3" paragraph above. Nine `mov.b #0x61` sites exist and none is near
  an SCI `TDR` write.
- MAIN's A/D (`0xFFFF90`–`0xFFFFA1`) is polled from `sub_32C0` and `sub_3466`
  only — not an audio or IF path.

**To BOOT-IPC:**

- The three DMA channels all feed SCI transmit registers, so MAIN's high-volume
  outbound links are SCI-D (`0xFFF613`), SCI-C (`0xFFFF8B`) and SCI-A
  (`0xFFFE93`). Setup routines `sub_482D4`, `sub_4834E`, `sub_6B77E`; end
  interrupts at vectors 128, 129, 130. DMA register geometry is in §2.
- `sub_4834E` picks a DMA mode from the first byte of the outbound buffer
  (`0x19`, `0x16`, `0x15` → count `0x60`, else `0x20`) and from `0xFF8DDE` — a
  message-type dependent transfer, i.e. a framed protocol. Worth decoding.
- MAIN's USB stack B configures SCI-C at boot (`sub_78222` from `loc_78106`),
  which couples the USB personality to a serial channel — a plausible
  USB↔SUB or USB↔CAT bridge.

**Tables produced** (all under `ida/out/main-full/`):
DATA-jack command API (this resume): **`data_jack_commands.tsv`** (the
opcode→handler→effect table), `cmd_dispatch.tsv` (parsed dispatch chains),
`cmd_effects.tsv` (per-handler DMA/EEPROM/reset/staging flags),
`cmd_disasm.txt` (annotated `0x06B700`–`0x06D120`), `cmd_templates.txt`
(TX frame templates), `cmdapi_log.txt`. Earlier pass:
`vectors.tsv`, `vector_map.tsv`, `functions.tsv` (with a confidence column),
`ioregs.tsv`, `absrefs.tsv`, `xrefs.tsv`, `items.tsv`, `region_map.tsv`,
`switch_tables.tsv`, `jumptables.tsv`, `swept_runs.tsv`, `code_runs.tsv`,
`strings.tsv`, `descriptor_refs.tsv`, `data_refs.tsv`, `stage1..8_log.txt`, and
disassembly listings under `lst\` (`init`, `crt_hwinit`, `usb_core`, `usb_ctrl`,
`usb_task`, `usb_bulk`, `usb_setup_tbl`, `usb_b_init`, `usb_b_core`,
`usb_b_descr`, `usb_b_idx`, `usb_tail`, `blk_fffc00`, `blk_fffc40`,
`blk_fffe90`, `isr_44a70`, `isr_561c2`, `sci2_78222`, `descr`).
