# SUB (RX64M) interrupt vectors and ISRs

Agent SUB-VEC. Database `SUB_VEC`. Tables under `ida/out/sub-vec/`.

## Verdict

Both RX64M vector tables are decoded completely. The relocatable table at
`INTB` = `0xFFED8A70` (file `0x2D8A70`) holds 256 slots: **40 are zero, 199 hold
an empty 2-byte handler, and 17 hold a real handler**. The fixed table at
`EXTB` = `0xFFFFFF80` holds 32 slots: 31 point at empty stubs and slot 31 is the
reset vector `0xFFC00000`. The 17 live sources resolve to **thirteen
peripherals**, every one identified from the registers its handler and its setup
function actually touch: SCI0, SCI2 and SCI3 (async serial), the ICU group-BL0
aggregator, SDHI (SD card host), DMAC channel 3, EXDMAC channel 0, TPU channels
0/3/4, CMT3, S12AD0 (12-bit ADC) and MTU3a channel 6. Six of the seventeen use
RX64M *selectable* vectors whose meaning the firmware programs itself, and I
decoded all six source numbers. **No INTB slot resolves to a handler that
touches the USB0 window `0x000A0000`–`0x000A03FF`.** The four USB slots — 32,
33, 34, 35 — hold empty `rte` stubs; `ICU.IER[4]` at `0x00087204`, the byte
carrying the enable bits for vectors 32-39, is never loaded anywhere in the 4 MB
image; and `MSTPCRB` is written at exactly three instructions in the whole
image, each clearing exactly one bit (31, 29, 28 = SCI0, SCI2, SCI3), so
`MSTPB19` — USB0's module-stop bit — is never cleared and the peripheral stays
clock-gated off for the entire life of the firmware. That is a closed negative,
not a coverage-limited one. The most interesting positive finding is not USB at
all: vector 134 is an **ADC capture ISR that converts 12-bit samples to signed
16-bit PCM and fills two 98,304-byte ping-pong buffers in RAM at 16 kHz**, and
vector 210 is the matching playback ISR. A sample source and a buffered
transport into a task exist. Only the USB link is missing.

## Method

All work in private database `SUB_VEC`, seeded `--copy-from ida\db\radio\SUB.i64`
so it inherits the earlier 455 functions. Job scripts, all launched through
`run_job.py`:

| Script | What it did |
| --- | --- |
| `ida\jobs\subvec_tables.py` | Re-classed the RES/DENSE/PAD segments CODE, read both tables, created a function at all 223 distinct in-image targets, BFS'd the call graph out of them (15 rounds, 844 functions in the closure), dumped `intb.tsv`, `extb.tsv`, `intb_targets.tsv`, `isr_disasm.txt`, `operand_debug.txt`. |
| `ida\jobs\subvec_periph.py` | Walked every defined instruction with an intra-function constant propagation over `mov.l #imm, rN` / `add #imm, rN`, resolving bare immediates, `[rN]` and `disp[rN]` forms alike, to `periph_map.tsv` / `periph_addrs.tsv` / `periph_blocks.tsv`; decoded ICU `IR`/`IER`/`IPR`/`DTCER` accesses back to vector numbers in `icu_vectors.tsv`; wrote `modulestop.tsv` and `usb_window.txt`. Run twice, at 876 and at 3806 functions. |
| `ida\jobs\subvec_recover.py` | Dumped the vector-setup functions to `setup_disasm.txt`. Its first sweep attempt found nothing because the validator called `idc.print_insn_mnem` on bytes IDA had not made code; that returns `""`, so every candidate failed. Superseded by `subvec_sweep.py`. Reported as a failed pass. |
| `ida\jobs\subvec_sweep.py` | Code recovery above `0xFFE80000` from three seed sources (below), byte-level validator, xref closure, `periph_base_loads.tsv`, `coverage.txt`. |
| `ida\jobs\subvec_dump2.py` | `blocks_disasm.txt` for the functions that name the remaining unknown blocks, plus honest coverage measures. |

Whole-image immediate scan, in plain Python against
`decrypted\FT3D_SUB_ver102_ALL.bin`, independent of IDA: RX encodes
`MOV.L #imm, Rd` as `FB`, then `(rd<<4) | (li<<2) | 0b10`, with `li` = `00`
32-bit, `01` 8-bit, `10` 16-bit, `11` 24-bit. I scanned the **24-bit form
(`FB ?E`) and the 32-bit form (`FB ?2`)** across all 4,194,304 bytes; the 8- and
16-bit forms cannot reach `0x00080000` because they sign-extend into
`0xFFFF8000`–`0x00007FFF`. Result: 2545 `imm24` and 11,147 `imm32` sites, of
which **885 load an address in `0x00080000`–`0x000FFFFF`, covering 145 distinct
base addresses**. That is the scope for every "never anywhere in the image"
claim in this document, and it is the whole file, not the recovered subset.

**Independent re-verification (second session, no IDA).** Both tables were
re-decoded a second time directly from `FT3D_SUB_ver102_ALL.bin` in plain Python,
reading each slot's 4-byte little-endian target and then the two bytes *at* that
target, with no dependence on the IDA database. It reproduced the classification
exactly — 40 null, 1 `WAIT` (slot 0), 198 `RTE` stubs, 17 live handlers — the
same 17 live slot numbers, the same 40 zero slots, and byte-for-byte agreement
with `intb.tsv` on all 256 targets (0 mismatches) and with `extb.tsv` on all 32.
Slots 32–35 were reconfirmed as `7f95`=`RTE`. The whole-image RX immediate scan
was also re-run independently: **0** sites load the USB0 window
(`0x000A0000`–`0x000A0FFF`), the USBA window (`0x000D0000`–`0x000D00FF`), RSPI
(`0x000D0100`/`0x000D0140`) or RIIC (`0x00088300`); the only ICU `IER` bytes
loaded are `[5],[7],[10],[13],[15],[16],[17],[26]` (USB's `IER[4]` `0x00087204`
absent); `IR[32]`–`IR[35]` absent; and `MSTPCRB`/`C`/`D` are never loaded as an
immediate base (only `MSTPCRA`, 49 sites). Every headline claim below is thus
confirmed by two independent tool paths.

Scope I did **not** cover: register bases held in a static variable or arriving
from a pointer table are outside the constant-propagation reach. The
whole-image encoding scan closes most of that gap for base *loads*, but a base
computed at run time from a value read out of RAM would evade both. I found no
evidence of that pattern in the ISRs I read.

## Findings

### 1. The two tables

`ida\out\sub-vec\intb_vectors_full.tsv` is the **authoritative 256-row decode**:
one row per vector, with slot / vector number / slot address / slot file offset /
handler target / target file offset / target's first bytes / class
(`unused (null)` · `dummy (RTE stub)` · `trap (WAIT, BRK vector)` · `LIVE
handler`) / peripheral name. Supporting: `intb.tsv` (256 rows, IDA function
detail), `extb.tsv` (32 rows), `intb_targets.tsv` (217 rows, occupancy ranked).

INTB occupancy:

| Class | Slots | Detail |
| --- | --- | --- |
| Zero | 40 | 1-15, 17, 19, 20, 22, 24, 25, 28-31, 36, 37, 40, 41, 49, 56, 57, 91, 107-109, 118-120, 133 |
| Empty 2-byte handler | 199 | targets `0xFFF47E40`–`0xFFF47FCF` |
| Real handler | 17 | 44, 58, 59, 62, 63, 80, 81, 110, 111, 123, 126, 128, 129, 134, 135, 136, 210 |

**Two corrections to the "shared dummy handler" expectation.** First, the 199
filler slots do **not** share a handler. Each points at its **own** distinct
2-byte address, allocated on a 2-byte stride in ascending vector order, so INTB
has **216 distinct non-zero targets, not 18**. The bytes are a solid run of
`7F 95` = `RTE` from `0xFFF47E34` to `0xFFF47FCF` (file `0x347E34`–`0x347FCF`).
This is CC-RX compiling one separately-declared empty `#pragma interrupt` body
per source. The conclusion is the same — those sources are unserviced — but
"how many distinct targets" has a different answer than a shared-dummy layout
would give. Sharing does occur in the *fixed* table: `0xFFF47E3E` is one shared
stub used by 26 of the 32 EXTB slots.

Second, **slot 0's target is not an `rte`**. `0xFFF47E40` (file `0x347E40`) is
`7F 96` = **`WAIT`**, the only non-`RTE` byte pair in the run. Relocatable
vector 0 is the RX `BRK` instruction vector, so executing a `BRK` halts the CPU
and never returns — a deliberate trap-and-stop, not filler.

EXTB structure independently validates the RX fixed-vector layout from the image
alone: distinct stubs appear at exactly slots 20, 21, 23, 25 and 30, the shared
stub fills the reserved slots, and slot 31 is the reset vector. Those five
positions are precisely privileged-instruction, access, undefined-instruction,
floating-point and NMI in the RX fixed table. Nothing had to be assumed.

Cross-check with SUB-USB: their 17 handler addresses are byte-for-byte identical
to mine, as are the 40 zero slots and the 199-slot filler count. **No
disagreement on any slot.** The only differences are the two characterisations
above.

### 2. The seventeen live sources, and how each is identified

The slot index *is* the vector number by construction (`INTB + 4n` is vector
`n`), so every vector number below is confirmed. What needed identifying is
which hardware source each number carries. All rows are register evidence unless
marked.

| Vec | Handler | Peripheral | Confirming registers |
| --- | --- | --- | --- |
| 44 | `FFF32CA7`→`sub_FFF33AA7` | **SDHI** buffer access | reads `SDSTS2` `0x0008AC3C`, tests bits 8/9 (BWE/BRE), clears each by writing `~bit` |
| 58 | `FFEDB7E7` | **SCI0** RXI0 | `SCR0` `0x0008A002` bit 6, `SSR0` `0x0008A004` error clear (AND `0xC7`, OR `0xC0`), `RDR0` `0x0008A005` |
| 59 | `FFEDB857` | **SCI0** TXI0 | `TDR0` `0x0008A003`, `bclr #7, [0x0008A002]` (SCR0.TIE) |
| 62 | `FFEDBBD3` | **SCI2** RXI2 | `SCR2` `0x0008A042`, `SSR2` `0x0008A044`, `RDR2` `0x0008A045` |
| 63 | `FFEDBC43` | **SCI2** TXI2 | `TDR2` `0x0008A043`, `bclr #7, [0x0008A042]` |
| 80 | `FFEDC025` | **SCI3** RXI3 | `SCR3` `0x0008A062`, `SSR3` `0x0008A064`, `RDR3` `0x0008A065` |
| 81 | `FFEDC09B` | **SCI3** TXI3 | `TDR3` `0x0008A063`, `bclr #7, [0x0008A062]` |
| 110 | `FFEDBCDD` | **ICU group BL0** | reads `GRPBL0` `0x00087630`, dispatches bits 0,1,4,5,6,7 |
| 111 | `FFF32C99`→`sub_FFF32A29` | **SDHI** card detect | reads `SDSTS1` `0x0008AC38`, tests bit 4 (card in) and bit 3 (card out), clears each |
| 123 | `FFF32DFB`→`sub_FFF32EA4` | **DMAC channel 3** | `bclr #4, [0x000820DE]` = `DMSTS3`.DTIF; DMAC3 base `0x000820C0` |
| 126 | `FFEF1E28` | **EXDMAC channel 0** | dummy-reads `EDMSTS` `0x0008281E`; setup writes `EDMTMD` `0x00082810`, `EDMINT` `0x00082813`, `EDMCNT` `0x0008281C`, `EDMAST` `0x00082A00` |
| 128 | `FFF32C1E` | **TPU4** TGI4A | `bclr #0, [0x00088155]` = `TSR4`.TGFA; setup writes `TCR4`/`TMDR4`/`TIER4`/`TGRA4` at `0x00088150`+ and `TSTR` bit 4 |
| 129 | `FFF39E77` | **CMT3** CMI3 | setup writes `CMCR3` `0x00088018` = `0xFFC0` (CMIE set, CKS = PCLK/8) and `CMCOR3` `0x0008801C` = `0xEA5F`; handler touches no peripheral, which is correct for CMT — the flag self-clears |
| 134 | `FFF15A18` | **S12AD0** scan end | handler reads `ADDR0/1/2` `0x00089020`/`22`/`24` via `sub_FFF15967`; setup programs `ADCSR` `0x00089000`, `ADANSA0` `0x00089004` = 7, `ADADC`, `ADCER`, `ADSTRGR` `0x00089010` = `0x0600`, `ADSSTR` `0x00089060`/`73`/`74` |
| 135 | `FFEE11B8` | **TPU0** TGI0A | `bclr #0, [0x00088115]` = `TSR0`.TGFA; setup writes `TCR0` = 1, `TIER0` = `0x41`, `TGRA0` = `0xEA5F`, `TSTR` bit 0 |
| 136 | `FFF36C1C` | **TPU3** TGI3A | `bclr #0, [0x00088145]` = `TSR3`.TGFA, `mov.w #0, [0x00088146]` = `TCNT3`, `TSTR` bit 3; setup `TCR3` = 2, `TIER3` = `0x41`, `TGRA3` = `0x1D4B` |
| 210 | `FFF1527B` | **MTU3a channel 6** TGIA6 | setup `sub_FFF15168` unlocks `TRWERB` `0x000C1A84`, writes `TCR6` `0x000C1A00` = `0x20`, `TIER6` `0x000C1A08` = `0x81`, `TGRA6`/`TGRB6`/`TGRC6`/`TGRD6` = `0x0BB7`, `TSTRB` `0x000C1A80` |

Independent cross-check from the ICU itself. `ICU.IR[n]` is indexed *directly by
vector number* at `0x00087000 + n`, and the firmware touches exactly
`IR[58]`, `IR[59]`, `IR[62]`, `IR[63]`, `IR[80]`, `IR[81]`, `IR[110]`,
`IR[128]`, `IR[134]`, `IR[135]`, `IR[136]`. `IPR` adds `IPR[126]`, `IPR[129]`
and `IPR[210]`. `IER` bit operations give the enable set directly:
`IER[5]` bit 4 → 44, `IER[7]` bits 2/3/6/7 → 58/59/62/63, `IER[10]` bits 0/1 →
80/81, `IER[13]` bit 6 → 110, `IER[15]` bit 6 → 126, `IER[16]` bits 0/1/6/7 →
128/129/134/135, `IER[17]` bit 0 → 136, `IER[26]` bit 2 → 210. Rows in
`icu_vectors.tsv`. That set is identical to the 17 real-handler slots.

Third check, from `GRPBL0`: handler `FFEDBCDD` dispatches on bits 0, 1, 4, 5, 6,
7 and **skips bits 2 and 3**. The six sub-handlers it calls touch SCI0
(`sub_FFEDB8A5`, `sub_FFEDB7B6`), SCI2 (`sub_FFEDBC91`, `sub_FFEDBBA2`) and SCI3
(`sub_FFEDC0EF`, `sub_FFEDC13B`) — never SCI1. Bits 2/3 are SCI1's TEI/ERI.
Consistent with slots 60/61 being empty stubs and with `MSTPCRB` releasing only
SCI0, SCI2, SCI3.

### 3. The six selectable vectors — decoded

RX64M vectors 128-255 carry **no fixed peripheral meaning**: the firmware routes
a source into them by writing a source number to `SLIBXRn` (vectors 128-143, at
`0x00087780 + (n-128)`) or `SLIARn` (vectors 208-255, at
`0x000879D0 + (n-208)`). This is why a remembered numbering table cannot name
them, and it is the one place in the table where the brief's instruction to
derive identity from registers is not merely good practice but the only method
that works.

| Register | Address | Value | Written by | Resolves to |
| --- | --- | --- | --- | --- |
| `SLIBXR128` | `0x00087780` | `0x21` (33) | `FFF32BCC` in `sub_FFF32BB7` | TPU4 TGI4A |
| `SLIBXR129` | `0x00087781` | `0x02` (2) | `FFF39E55` in `sub_FFF39E37` | CMT3 CMI3 |
| `SLIBXR134` | `0x00087786` | `0x40` (64) | `FFF156F3` in `sub_FFF15648` | S12AD0 scan end |
| `SLIBXR135` | `0x00087787` | `0x0F` (15) | `FFEE1164` in `sub_FFEE1105` | TPU0 TGI0A |
| `SLIBXR136` | `0x00087788` | `0x1C` (28) | `FFF36B6D` in `sub_FFF36B1E` | TPU3 TGI3A |
| `SLIAR210` | `0x000879D2` | `0x1E` (30) | `FFF15198` in `sub_FFF15168` | MTU3a ch.6 TGIA6 |

Each identification stands on the register block the writing function programs in
the same breath, plus what the handler clears — it does not depend on any source
list. But the three TPU values also fall out of one arithmetic progression, which
is a strong independent corroboration: if the selectable-B list enumerates
TPU0…TPU5 with 5, 4, 4, 5, 4, 4 sources each (matching the hardware — channels 0
and 3 have four TGRs and an overflow, channels 1/2/4/5 have two TGRs plus
overflow and underflow) starting at 15, then TGI0A = 15, TGI1A = 20, TGI2A = 24,
**TGI3A = 28** and **TGI4A = 33**. Observed: 15, 28, 33. Three hits, no misses.
And CMI2 = 1, **CMI3 = 2** puts the two CMT unit-1 sources at the head of the
list, followed by TMR0-3's twelve sources (3-14), which lands TPU0 exactly at 15.
The whole low end of the selectable-B source list is therefore reconstructed from
four data points in the firmware.

### 4. The audio chain — the highest-value ISR content

`vec_intb_134` at `FFF15A18` (file `0x315A18`, 525 bytes), reading from the
control block at RAM `0x00020278`:

```
sub_FFF15967(ch, &s)            ; s = S12AD0 ADDRn   (0x00089020/22/24)
s = (s - 0x0800) << 4           ; FFF15A32 add #-800h ; FFF15A3A shll #4
if (cb->state != 3) return      ; FFF15A46 cmp #3
buf = cb->sel == 1 ? A : B      ; FFF15A54 / FFF15B32   double buffer
if (cb->idx > 0x17FFE) return
buf[cb->idx++] = s & 0xFF       ; FFF15A93
buf[cb->idx++] = s >> 8         ; FFF15AB0
if (cb->idx == 0x18000) {       ; FFF15ACC
    msg = { 1, cb+6, cb->idx, buf }        ; 20 bytes
    sub_FFF14079(&msg)          ; FFF15B0E  queue send
    cb->sel = other; cb->idx = 0
}
```

`(sample - 0x800) << 4` is a 12-bit unsigned ADC reading turned into
**left-justified signed 16-bit PCM**. Buffer A base `0x00020278 + 0x122` =
`0x0002039A`, buffer B base `0x00020278 + 0x1812E` = `0x000383A6`, each
`0x18000` = 98,304 bytes = 49,152 samples. `vec_intb_210` at `FFF1527B`
(973 bytes) is the mirror image: it reads bytes back out of the same buffers,
advances a play cursor at `cb+0x10C` against a length at `cb+0x108`, and feeds
`sub_FFF375D0`. `sub_FFF15087` and `sub_FFF150D2` are the start/stop pair and
they enable the two vectors **mutually exclusively** — `IER[26]` bit 2 (210) on
with `IER[16]` bit 6 (134) off is playback, the reverse is record.

Sample rate, derived from the clock registers in `sub_FFF36CCA` /
`sub_FFF37443`: `PLLCR` `0x00080028` = `0x1F00` → PLIDIV = ÷1, STC = 31 → ×16;
`SCKCR` `0x00080020` = `0x42C22222` → FCK ÷16, ICK ÷4, BCK ÷4, PCKA/B/C/D ÷4;
`SCKCR2` `0x00080024` = `0x0031` → UCK ÷4. With a 12 MHz crystal that is
PLL 192 MHz, **ICLK and PCLK 48 MHz**, FCLK 12 MHz, UCLK 48 MHz. Every timer
period then comes out round, which is what makes the 12 MHz figure safe:
MTU6 TGRA6 = 2999, ÷1 → **16.000 kHz**; CMT3 `CMCOR3` = 59,999 at PCLK/8 →
**100 Hz**; TPU0 TGRA0 = 59,999 at PCLK/4 → **200 Hz**; TPU3 TGRA3 = 7499 at
PCLK/16 → **400 Hz**; TPU4 TGRA4 = 3000 at PCLK/16 → **1 kHz**. So the ADC
capture runs at 16 kHz mono, 16-bit — 256 kbit/s — and each buffer holds 3.072
seconds.

The output side is the on-chip DAC, not PWM: `sub_FFF15155` is
`r1 &= 0x0FFF; mov.w r1, [0x00088040]` = **R12DA `DADR0`**, and `sub_FFF15087`
sets `DACR` `0x00088044` bit 6 (`DAOE0`). `ADSTRGR` = `0x0600` → `TRSA` = 6, so
the ADC is **hardware-triggered by a timer**, not by software, and the only
16 kHz timer running is MTU6 — the same unit that raises vector 210.

### 5. Blocks that had no name before

`ida\out\sub-vec\periph_map.tsv` (1787 access rows),
`periph_addrs.tsv` (309 distinct registers), `periph_blocks.tsv` (32 blocks),
`periph_base_loads.tsv` (all 885 whole-image base loads).

- **`0x00083000` and `0x00083800` are the BSC external chip-select registers.**
  `sub_FFF37443` writes, from base `0x00083010`: `CS1MOD` `0x00083012` = `0x0301`,
  `CS2MOD` `0x00083022` = `0x0001`, `CS1WCR1` `0x00083014` = `0x02020202`,
  `CS2WCR1` `0x00083024` = `0x05050505`, `CS1WCR2` `0x00083018` = `0x01110110`,
  `CS2WCR2` `0x00083028` = `0x12320133`, then `CS0CR` `0x00083802` = 0,
  `CS1CR` `0x00083812` = 1, `CS2CR` `0x00083822` = 1. The 0x10 stride between
  the CS1 and CS2 groups and the `0x83802`/`0x83812`/`0x83822` triple are the
  RX64M BSC layout exactly. The same function sets `SYSCR0` `0x00080006` =
  `0x5A03` (**EXBE = 1, external bus enabled**) and polls it, and programs MPC
  `PFCSE` `0x0008C100` = 6 (CS1 and CS2 pin output), `PFCSS` `0x0008C102` =
  `0x28`, `PFAOE0` `0x0008C104` = `0xFF` and `PFAOE1` `0x0008C105` = `0x0F`
  (**address lines A0-A19**), `PFBCR0` `0x0008C106` = `0x53`.
- **EXDMAC channel 0's destination is hard-coded to the CS1 area.**
  `sub_FFEF1F90` is `mov.l #6000000h, 4[0x00082800]` — `EDMDAR` = `0x06000000`.
  `sub_FFEF1F74`/`sub_FFEF1F80` set `EDMSAR` from a register,
  `sub_FFEF1FC2`/`FFEF1FD1`/`FFEF1FDF` set `EDMCRA` `0x0008280C`, and
  `sub_FFEF1FEB`/`FFEF1FF2` set `EDMCRB` `0x00082808`. So the firmware
  block-DMAs from internal RAM to a **memory-mapped device on external chip
  select CS1**, with transfer-end on vector 126. Two different devices are
  implied by the wait-state settings: CS1 is fast (2 cycles), CS2 slow
  (5 cycles).
- **`0x0008ADB0` and `0x0008ADC0` are the upper half of the SDHI block**
  (`SDDMAEN` and `SDRST` by position). They are touched by the same functions
  that touch `SDBUFR` `0x0008AC60`, immediately after it — enabling DMA for a
  buffer transfer. Inferred from position and co-location, not from a register
  name in the image.
- **`0x000C1280` is MTU3a unit-0 common, `0x000C1A80` unit-1 common,
  `0x000C1A00` the MTU6/MTU7 channel block.** Structurally confirmed:
  `sub_FFF15168` opens with `bset #0` on **both** `0x000C1284` and `0x000C1A84`
  and closes with `bclr #0` on both — the canonical MTU3 `TRWERA`/`TRWERB`
  register-write-enable unlock/lock pair, and the two addresses are exactly
  `0x800` apart, which is the unit-0 to unit-1 offset. `0x000C1CB4` is in the
  same unit and stays unidentified.
- **The SD subsystem is one connected path.** `DMRSR3` `0x0008740C` = `0x2C`
  binds DMAC channel 3's activation source to **vector 44**, which is the SDHI
  buffer-access interrupt. So SDHI signals buffer-ready (vector 44) → DMAC3
  moves the block → DMAC3 transfer-end raises vector 123. Card insert/remove is
  vector 111. Three of the seventeen live vectors are the microSD path.
- **`0x0008630C`** (5 base loads, `FFE6AAB0`, `FFE7D4A2`, `FFE961FA`,
  `FFE9C55A`, `FFEAEFE0`) and **`0x00084208`** (7 base loads, all in
  `0xFFD6xxxx`, so SUB-LOWER's region) remain unidentified. **`0x00083940`**
  (one load at `FFF40309`) likewise.
- Absent from the whole image, by the 885-site scan: **no RSPI**
  (`0x000D0100`/`0x000D0140`), **no RIIC** (`0x00088300`-`0x000883C0`), no
  ETHERC, no CAN, no SCI1 and no SCI4-SCI12. Independently agrees with MENU.

### 6. Module stop — hand-off, with the boundary closed

`ida\out\sub-vec\modulestop.tsv`. SUB-USB owns this; here are the addresses and
the one thing that constrains my USB answer.

`sub_FFF36CCA` (file `0x336CCA`) is the release sequence, bracketed by
`PRCR` `0x000803FE` = `0xA50B` at `FFF36CD1` and `= 0xA503` at `FFF36D8C`. Every
write is a read-modify-write of one bit:

| Register | Bits cleared (in order) | Instruction addresses |
| --- | --- | --- |
| `MSTPCRA` `0x00080010` | 13, 13, 13, 19, 17, 16, 28, 9, 13, 15, 15, 14 | `FFF36CDE`, `FFF36CE9`, `FFF36CF4`, `FFF36CFF`, `FFF36D0A`, `FFF36D15`, `FFF36D41`, `FFF36D4C`, `FFF36D57`, `FFF36D62`, `FFF36D6D`, `FFF36D83` |
| `MSTPCRB` `0x00080014` | **31, 29, 28 — and nothing else** | `FFF36D20`, `FFF36D2B`, `FFF36D78` |
| `MSTPCRC` `0x00080018` | none | — |
| `MSTPCRD` `0x0008001C` | 19 | `FFF36D36` |

Two other functions touch `MSTPCRA`: `sub_FFEE1393` (`FFEE13A3`/`A7`, with its
own `PRCR` `0xA502`/`0xA500` bracket) and `sub_FFF15055` (`FFF1505A`/`5E`).

The reason this is a closed boundary and not a sample: the whole-image encoding
scan shows `0x00080010` is loaded as a base at **exactly 49 sites, all inside
those three functions**, and `0x00080014`, `0x00080018` and `0x0008001C` are
**never loaded as a base anywhere in the 4 MB image**. `MSTPCRB` is therefore
only ever reachable as `4[base]` from `0x00080010`, inside code I have fully
disassembled. Three writes, three bits, 31/29/28.

Those three bits are SCI0, SCI2 and SCI3 — which is exactly the live SCI set the
vector table, the `IER` bits and the `GRPBL0` dispatch all independently name.
`MSTPB19`, USB0's bit, is never cleared.

`MSTPCRD` bit 19 is the one unaccounted bit. By elimination it is a strong
candidate for SDHI, since SDHI is heavily driven (18 registers, 169 accesses) and
every other cleared bit has a plausible timer/ADC/DAC/DMA owner — but `MSTPCRA`
has one spare bit too, so elimination is not airtight. SUB-USB should settle it
against the manual; the bit and its instruction address are above.

### 7. Coverage

`ida\out\sub-vec\coverage.txt`, `functions_after.tsv` (3806 rows).

| Stage | Functions | Bytes in functions |
| --- | --- | --- |
| Baseline, inherited from `ida\db\radio\SUB.i64` | 455 | 106,944 |
| After the vector closure (pass A) | 876 | 147,376 |
| After the sweep (pass D) | 3806 | 409,004 (union, no double counting) |

Instruction bytes in the code-bearing window `0xFFED0000`–`0xFFF50000`
(524,288 bytes): **154,162 = 29.4%**. Above `0xFFF50000` the flash is erased —
`0xFFF50000`–`0xFFFFFF80` is 96-100% `0xFF` per 64 KB block — so the owned
region's real code extent is that 512 KB window, not the nominal 1.5 MB. Below
`0xFFED0000` the region is low-entropy data (2.6-2.8 bits/byte, 56-60% zero in
`0xFFE80000`–`0xFFEB0000`).

Honest quality split. The **+421 functions from the vector closure are all
verified** — each is a vector target or is reached by a call from one. Of the
2930 added by the sweep, **1396 of the 3806 total are reached by a call or jump
xref**; the remaining 2410 should be treated as candidates, because 2364 of the
2612 seeds came from the prologue-pattern sweep, which is heuristic. The
solidly-verified part of the sweep is the 184 seeds recovered by walking back
from a peripheral base-load site: **192 instructions in the owned region that
provably access a peripheral register were outside any function before this
pass**, and the byte encoding proves they are instructions.

The recovery paid off in peripheral coverage, which is the check that matters:
SDHI went from 2 registers / 14 accesses to **18 / 169**, DMAC from 1 / 2 to
**10 / 60**, the EXDMAC block from 6 / 20 to **10 / 43**, and `DMRSR3` and
`DMAST` appeared for the first time. The new code is real driver code, not
sweep noise.

## USB relevance

**Question 1, everything USB.** Negative, and now closed rather than
coverage-limited.

- INTB slots **32, 33, 34, 35** — USB0 `D0FIFO0`, USB0 `D1FIFO0` and the USBA
  `D0FIFO`/`D1FIFO` pair — hold targets `0xFFF47E50`, `0xFFF47E52`,
  `0xFFF47E54`, `0xFFF47E56`. Table bytes at `0xFFED8AF0`, `0xFFED8AF4`,
  `0xFFED8AF8`, `0xFFED8AFC` (file `0x2D8AF0`+) are `507ef4ff`, `527ef4ff`,
  `547ef4ff`, `567ef4ff`. Each target is `7F 95` = `RTE`, two bytes, no body.
- `ICU.IER[4]` at `0x00087204`, the enable byte for vectors 32-39, **is never
  loaded as a base anywhere in the 4,194,304-byte image**. Nor is `IR[32]`
  `0x00087020` or `IR[33]` `0x00087021`. The `IER` bytes that *are* used are
  `IER[5]`, `[7]`, `[10]`, `[13]`, `[15]`, `[16]`, `[17]`, `[26]`.
- `MSTPCRB` is written at three instructions in the whole image, clearing bits
  31, 29, 28 only. **USB0 is never released from module stop**, so its registers
  are not even accessible.
- Zero instructions in 3806 functions access `0x000A0000`–`0x000A03FF`, and zero
  `MOV.L #imm, Rd` sites anywhere in the image load an address in
  `0x000A0000`–`0x000A0FFF` (USB0 and PDC) or `0x000D0000`–`0x000D00FF` (USBA),
  across both the 24-bit and 32-bit immediate widths. `ida\out\sub-vec\usb_window.txt`.
- One nuance that cuts the other way and should not be buried: `SCKCR2`
  `0x00080024` = `0x0031` sets `UCK` = ÷4, which from the 192 MHz PLL is exactly
  the **48 MHz USB clock**. The Renesas BSP writes `SCKCR2` unconditionally, so
  this is provisioning, not use — but it does mean the clock tree is already
  correct for USB. The gate is `MSTPCRB` bit 19 and the absent code, not the
  clock.

**Question 2, USB SDR.** My half of the chain is the surprise. Links 1 and 2
**exist**: there is a sample source (S12AD0, 12-bit, three channels enabled,
hardware-triggered), a conversion to signed 16-bit PCM in the ISR, 16 kHz
sampling, two 98 KB RAM buffers, a message hand-off to another task, and — for
bulk movement — a DMAC and an EXDMAC that already block-transfer to an external
bus device. Link 3 does not exist: the USB controller is clock-gated off and has
no code. So for this processor the answer is firmly "the silicon could, this
firmware does not" — and the missing piece is narrow: a USB stack plus one bit
in `MSTPCRB`. The rate ceiling is the real limit for SDR: `S12AD0` at 16 kHz
into a 98 KB buffer is a voice recorder, roughly 1 Msps and 12 bits at best, not
IF sampling. Whether there is a *wideband* sample source at all is RF-SDR's
call; SUB does not have one on-chip.

**Question 3, the DSP.** Narrowing, from the peripheral census. The SUB
processor has **no RSPI and no RIIC anywhere in the image**, so if a vocoder is
reached from SUB it is over one of the three live UARTs (SCI0 `0x0008A000`,
SCI2 `0x0008A040`, SCI3 `0x0008A060`) or over the **external bus** — and there
*is* an external bus, with two chip selects at different speeds, 20 address
lines, and an EXDMAC channel whose destination is hard-wired to `0x06000000` on
CS1. All three SCI channels dispatch received bytes through a callback table at
RAM `0x00012D20` (entries at +0, +4, +8, +0xC, +0x10, +0x14, +0x18, +0x1C with
16-bit sizes at +8..+0x22), so whoever owns a channel registers a handler there.
That table is the place to look for AMBE framing.

## Open

Most valuable first.

1. **Who sits on `0x06000000` (CS1) and on CS2?** The firmware enables the
   external bus, configures two chip selects with different wait states, and
   DMAs blocks to CS1. Find the accesses to those windows (my scan found only
   three loads of `0x06000000` and none in the CS2 window as immediates, so the
   addresses are computed — chase them through the EXDMAC callers at
   `FFEF1F74`-`FFEF1FF9` and `sub_FFEF1DDA`). An external memory-mapped device
   is the best remaining candidate for both the DSP link and the "RAM DISPLAY"
   label. Hands off to DSP-AMBE and SUB-LOWER.
2. **Resolve the callback table at RAM `0x00012D20`.** All three live SCI
   channels dispatch through it. Whoever registers each slot names what is on
   SCI0, SCI2 and SCI3 — MAIN, GPS, Bluetooth or the vocoder. `sub_FFEDB300`
   (the SCI/ICU init) and `sub_FFEDB4E8`/`FFEDB8F1`/`FFEDBD53` (the per-channel
   open functions, which write `BRR` and so fix the baud rates) are the entry
   points. Deriving the three baud rates from `BRR` plus PCLK 48 MHz would be
   quick and highly diagnostic.
3. **Follow the ADC capture buffers.** `sub_FFF14079` receives the 20-byte
   message when a 98 KB buffer fills. Where the PCM goes — microSD via SDHI, or
   back out the DAC — decides whether the radio already has a
   sample-to-storage pipeline that a USB endpoint could tap. The SD path is
   fully instrumented (vectors 44, 111, 123, `DMRSR3` = 44) so this is tractable.
4. **Name `MSTPCRD` bit 19, `0x0008630C`, `0x00084208`, `0x00083940` and
   `0x000C1CB4`.** Five loose ends; the module-stop bit is SUB-USB's, the two
   `0xFFD6xxxx`/`0xFFE6xxxx` blocks are SUB-LOWER's.
5. **Raise the code fraction above 29.4%.** The prologue sweep is
   low-precision — 2410 of 3806 functions have no incoming call. A better pass
   would seed only from verified instruction encodings (the 885 base-load sites
   generalise to any opcode with a fixed immediate position) and from the
   compiler's switch tables, then let flow analysis do the rest, rather than
   pattern-matching prologues.
6. **Confirm the crystal.** Everything downstream of the 12 MHz assumption —
   16 kHz audio, 100 Hz tick, 48 MHz ICLK — is consistent and round, but a
   direct confirmation (a `BRR` value against a known baud rate, or a CAC
   configuration) would make it stated fact rather than a well-supported
   inference.

## Verification record and handover

**Status: complete.** Both vector tables are fully decoded, all 17 live sources
are identified from register evidence, all six selectable-vector source numbers
are decoded, and the USB verdict is closed. A second session then re-decoded both
tables and re-ran the whole-image USB immediate scan directly from the binary
with no IDA dependence (see Method, "Independent re-verification"); it reproduced
every count, every live slot number, and every USB negative exactly, and agreed
byte-for-byte with `intb.tsv`/`extb.tsv`. The authoritative 256-row table with
per-slot peripheral names is `ida\out\sub-vec\intb_vectors_full.tsv`. This
section records the tooling state for any follow-on pass; the sections above are
final.

**Database.** `SUB_VEC`, at `ida/db/jobs/SUB_VEC/SUB_VEC.i64`, 3806
functions. Reopen with:

```text
python "ida/run_job.py" --script ida\jobs\<script>.py --db SUB_VEC --reopen
```

**Job scripts, in the order they were run.** All five are on disk and re-runnable.

| Script | Re-run when |
| --- | --- |
| `ida\jobs\subvec_tables.py` | Rebuilding the vector closure from scratch. Needs `--copy-from ida\db\radio\SUB.i64`, not `--reopen`. |
| `ida\jobs\subvec_periph.py` | After any pass that adds functions — it regenerates `periph_map.tsv`, `periph_addrs.tsv`, `periph_blocks.tsv`, `icu_vectors.tsv`, `modulestop.tsv`, `usb_window.txt` over whatever is in the database. Cheap, idempotent, `--reopen`. |
| `ida\jobs\subvec_recover.py` | **Its sweep is broken** (validator calls `idc.print_insn_mnem` on non-code, gets `""`, rejects everything). Only its `setup_disasm.txt` dump is useful. Superseded by `subvec_sweep.py`. |
| `ida\jobs\subvec_sweep.py` | Extending code recovery. Edit the seed list; the byte-level validator is correct. |
| `ida\jobs\subvec_dump2.py` | Dumping named functions — edit the `WANT` list — plus the honest coverage measures. |

**Scope covered:** the relocatable and fixed vector tables in full; every
distinct handler target created as a function and disassembled with its call
closure; a constant-propagating peripheral scan over every defined instruction at
both 876 and 3806 functions; and a whole-image (4,194,304-byte) scan of the RX
`MOV.L #imm, Rd` 24-bit and 32-bit encodings, which is what makes the
"never anywhere in the image" claims closed rather than coverage-limited.

**Scope not covered:** register bases held in a static variable or fetched from a
pointer table are outside the constant-propagation reach — the whole-image
encoding scan closes that for base *loads*, but a base computed at run time from
RAM would evade both, and I found no such pattern in the ISRs but did not prove
its absence. Instruction coverage of the owned region's real code window
`0xFFED0000`-`0xFFF50000` is 29.4%, so any claim about code *outside* recovered
functions rests on the encoding scan, not on disassembly. The five blocks listed
in Findings §5 as unidentified stayed unidentified. `MSTPCRD` bit 19 is named
only by elimination.

**Single most valuable next step:** find who lives at `0x06000000` on external
chip select CS1. The firmware enables the external bus (`SYSCR0` = `0x5A03`),
configures CS1 and CS2 with different wait states, drives 20 address lines, and
hard-codes EXDMAC channel 0's destination to `0x06000000` at `FFEF1F95`. That is
the only peripheral path off this processor that is both wide and unexplained,
and it is the strongest remaining candidate for the DSP/vocoder link and for the
`RAM DISPLAY` setup label. The addresses are computed rather than immediate, so
the route in is the EXDMAC callers at `FFEF1F74`-`FFEF1FF9` and `sub_FFEF1DDA` —
work out what fills `EDMSAR` and `EDMCRA` and the device declares itself. Second
most valuable, and quick: derive the three SCI baud rates from the `BRR` writes
in `sub_FFEDB4E8` / `sub_FFEDB8F1` / `sub_FFEDBD53` against PCLK 48 MHz, then
resolve the shared callback table at RAM `0x00012D20` to name what is on SCI0,
SCI2 and SCI3.
