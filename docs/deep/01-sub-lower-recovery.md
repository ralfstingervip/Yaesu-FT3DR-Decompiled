# SUB lower region recovery — 0xFFC00000 to 0xFFE80000

Agent SUB-LOWER. Scope: the low 2.6 MB of the RX64M SUB image,
`decrypted\FT3D_SUB_ver102_ALL.bin` file offsets `0x000000`–`0x280000`, mapped
`0xFFC00000`–`0xFFE80000`. Private database `SUB_LOWER`. Tables in
`ida\out\sub-lower\`, job scripts `ida\jobs\sublower_*.py`.

## Verdict

**This region is not code. It is the display resource pack, and there is exactly
one function in it: the 60-byte reset stub at `0xFFC00000`.** Of 2,621,440 bytes,
60 are instructions (0.0023%), 2,618,308 are data identified by content, and
3,072 are unresolved. The breakdown is 2,286,592 bytes of 16-bit RGB565 display
bitmaps (87.2%), 243,712 bytes of 1-bit bitmap glyph font (9.3%), 74,752 bytes of
`0x00`/`0xFF` fill (2.9%), and about 11 KB of strings and small constant tables
that carry the setup-menu labels, the CTCSS and DCS code tables, the month names,
and the GPS command strings. The earlier pass recovered one function here and
that was the right answer; what it lacked was the evidence to say so. The blind
spot was real but it was a blind spot over data.

The region does not touch any peripheral. Nothing in it is a peripheral access,
no instruction anywhere in the 4 MB image addresses USB0 (`0x000A0000`–
`0x000A0400`), and no control transfer from anywhere lands in this region. I
found no USB engine, no descriptors, and no sample path here, and the reason is
structural rather than statistical: there is no code here to contain them.

Two things of real value came out of the region anyway. The **setup-menu record
table has a reader** — at `0xFFF095EB` and `0xFFF09695` — which the previous
session searched for and did not find because the table's base is `0xFFED74E8`,
eight bytes below the `0xFFED74F0` they looked for. And the code cluster that
appeared to reference this region turned out to be a **baseline JPEG decoder**,
which is very likely what `USB CAMERA` is for.

## Method

All IDA work through `ida\run_job.py` into the private database `SUB_LOWER`
(`ida\db\jobs\SUB_LOWER\`), plus a throwaway `SUB_LOWER_SEED` seeded with
`--copy-from ida\db\radio\SUB.i64` to read the earlier 455 functions. The shared
databases in `ida\db\` and `ida\db\radio\` were not opened or modified; their
timestamps are unchanged. Nothing was written to a radio.

Load: `--proc rx`, rebased to `0xFFC00000` with the `ida\survey.py` `_rebase`
pattern, then two segments — `LOWER` `0xFFC00000`–`0xFFE80000` and `UPPER`
`0xFFE80000`–`0x100000000`, both class `CODE`, both `ADDSEG_NOAA` so 4 MB of
resources would not be carpet-analysed. Code seeded only from the 32 fixed
vectors at `EXTB` `0xFFFFFF80`. That recovered **478 functions**, 23 more than the
earlier survey, all of them in `UPPER`, **none** in my region.

Passes run, in order:

| Job | What it did |
| --- | --- |
| `sublower_seed.py` | Harvested prologue and epilogue byte signatures from the 455 known functions |
| `sublower_load.py` | Load, rebase, segment, fixed vectors, baseline |
| `sublower_probe.py` | Reference scan, per-KB linear-sweep coherence, label xrefs, jump tables, candidate list |
| `sublower_force.py` | Positive control, tiered candidates, pointer-target classification, peripheral scan |
| `sublower_final.py` | Menu-table walker, peripheral register detail, forced `add_func` |
| `sublower_close.py` | Undid the force experiment, fixed the reset stub, MSTPCR/PRCR dump |
| `sublower_refs.py` | Corrected operand scan (see below) |
| `sublower_ctx.py` | Context for the apparent pixel-region references |
| `sublower_periph2.py` | Corrected peripheral scan (see below) |

Byte-level classification was done outside IDA in Python over the raw file:
Shannon entropy, zero and `0xFF` fill fractions, printable-ASCII density,
autocorrelation at strides 1–64, distinct aligned `u16` count, and pixel-run
fraction, per 1 KB block. Output `ida\out\sub-lower\region_map.tsv`.

### Two bugs of mine, both found and fixed

I report these because both produced a false negative that I published to my own
notes before catching it.

1. **Sign extension.** `sublower_probe.py` reported "0 operands resolving into
   LOWER" across 45,266 instructions. IDA stores a 32-bit immediate in a 64-bit
   `uval_t`, sign-extended, so `0xFFC00100` arrives as `0xFFFFFFFFFFC00100` and
   failed my range test. Masking to 32 bits gives the true figure, **89**.
   `sublower_refs.py` supersedes that scan.
2. **`o_displ` displacement.** `sublower_force.py` read `op.addr` for
   displacement operands. In IDA's RX module the displacement is in `op.value`;
   `op.addr` is zero. Verified at `0xFFEE1398`, `mov.w #0A502h, 3EEh[r14]`:
   `op1.value = 0x3EE`, `op1.addr = 0x0`. All 454 `base+dsp` effective addresses
   were therefore collapsing to `base+0`. `sublower_periph2.py` supersedes it;
   the corrected scan resolves 246 distinct peripheral addresses where the buggy
   one resolved 87. Credit to SUB-USB for flagging this.
3. **Immediate size.** My first raw pointer scan only matched the `imm:32` form
   of `MOV.L #imm, Rd` (`FB`, `(rd<<4)|0x02`). RX also encodes the same constant
   as sign-extended `imm:24` (`|0x0E`) and `imm:16` (`|0x0A`), and addresses from
   `0xFF800000` up fit in 24 bits, so the `imm:24` form is in scope. Redone over
   all three; that added 44 candidates.

The USB0 negative was re-tested after every one of those three corrections and
did not move.

### Machine-readable tables, `ida\out\sub-lower\`

| File | Contents |
| --- | --- |
| `region_map.tsv` | 2,560 rows, one per KB: entropy, fill fractions, ASCII density, autocorrelation at 28 and 2, distinct aligned `u16`, pixel-run fraction, final class |
| `region_map_summary.txt` | Byte totals per class and every contiguous run of 8 KB or more |
| `periph_refs.tsv` | Corrected peripheral references: instruction, function, form, effective address |
| `periph_lower_raw.tsv` | Raw peripheral-immediate byte patterns and aligned dwords inside the region |
| `real_refs_into_lower.tsv` | The 89 real operands that resolve into the region |
| `ptr_loads_verified.tsv` | 193 pointer-load byte patterns, each marked real instruction head or coincidence |
| `ptr_target_class.tsv` | 1,473 distinct pointer targets, classified |
| `ptr_into_lower.tsv`, `ptr_targets.txt` | The raw aligned-dword scan behind that classification |
| `lower_candidates.tsv`, `force_tier1.tsv` | Prologue candidates in the region and IDA's verdict on each |
| `control_candidates.tsv` | The positive control over known code, with `is_known_func` per row |
| `coherence.tsv`, `coherence_calibration.tsv` | Per-KB linear-sweep metrics, region and calibration |
| `prologues.tsv`, `epilogues.tsv`, `sig_summary.txt` | CC-RX entry and exit signatures harvested from the 455 known functions |
| `menu_walker.txt` | Setup-menu record table, its reader, all 23 groups expanded |
| `jump_tables.txt` | The two dispatch tables decoded, plus the tables they index |
| `mstp_prcr.txt` | Full disassembly of the three module-stop routines |
| `pixel_ref_context.txt` | Code around every apparent pixel-region reference — the JPEG evidence |
| `baseline_functions.tsv`, `baseline.txt` | Load-time state: 478 functions, all in `UPPER` |
| `reset_disasm.txt` | The reset stub and sample functions from the seed database |

**Do not cite these — superseded, kept only for traceability.**
`probe_notes.txt`, `force_notes.txt`, `label_operand_hits.tsv`,
`prologue_candidates.tsv` and `force_result.tsv` were produced by the two buggy
scans described above and their zero counts are artefacts. The corrected
equivalents are `refs_notes.txt` (operand scan), `periph2_notes.txt` and
`periph_refs.tsv` (peripheral scan), `lower_candidates.tsv` and `force_tier1.tsv`
(candidates and IDA's verdict). One result does survive the correction unchanged:
the corrected scan independently re-tested the setup-label range and also finds
**0** operands pointing directly inside `0xFFC3DF4D`–`0xFFC3E8D4`, because the
labels are reached through the record table's pointers plus an index, not by a
direct immediate.

### What I could not do

I did not analyse the upper region `0xFFE80000`+ as such (SUB-VEC), the INTB
vector table (SUB-VEC), the MAIN image, or any PE file. The corrected peripheral
scan covers only code inside the 479 recovered functions, which is 45,282
instructions and about 120 KB — thin against the ~1.5 MB upper region. Its
negative results are therefore scope-limited, and I say so at each one. The
whole-image raw byte scans (pointer loads, peripheral immediates, branch
displacements) are not scope-limited: they cover all 4,194,304 bytes at every
byte offset.

## Findings

### 1. Content map of the region

`ida\out\sub-lower\region_map.tsv` (2,560 rows, one per KB) and
`region_map_summary.txt`.

| Class | Bytes | Share | Evidence |
| --- | --- | --- | --- |
| `rgb565` display bitmaps | 2,286,592 | 87.2% | 13–40 distinct aligned `u16` per KB, pixel-run fraction 0.29–0.79, palette is RGB565 neutral greys and primaries |
| `glyph1` 1-bit glyph font | 243,712 | 9.3% | 139–403 distinct `u16` per KB, autocorrelation peak at stride 28 and 56, glyphs render |
| `fill` | 74,752 | 2.9% | >98% `0x00` or `0xFF` |
| `text` | 10,240 | 0.4% | >72% printable ASCII |
| `other` | 3,072 | 0.1% | unresolved |
| `const` | 2,048 | 0.1% | low entropy, short stride, not pixels or glyphs |
| `code` block | 1,024 | 0.04% | contains the 60-byte reset stub plus fill and const |

The distinct-`u16`-per-KB metric separates the two bitmap formats cleanly with no
overlap — pixel blocks top out at 40, glyph blocks start at 139 — so the boundary
is not a judgement call. Calibration rows are in the same file's columns.

Layout, from the run boundaries:

| Range | Content |
| --- | --- |
| `FFC00000`–`FFC0003C` | reset stub, 60 bytes, the only code |
| `FFC0003C`–`FFC00100` | `0xFF` pad |
| `FFC00100`–`FFC00160` | const table plus the GPS command strings |
| `FFC00400`–`FFC1A000` | 1-bit glyph font, 105,472 bytes |
| `FFC1A000`–`FFC1D800` | glyph font with two small const/pixel interruptions |
| `FFC1D800`–`FFC35C00` | 1-bit glyph font, 99,328 bytes |
| `FFC35C00`–`FFC3EC00` | mixed glyph, string and const block — setup labels live here |
| `FFC3EC00`–`FFE80000` | RGB565 display bitmaps, ~2.23 MB |

The glyph format is confirmed by rendering. Rows are 2 bytes, stored
big-endian-within-the-row and left-aligned, so the low bits of the second byte
are always clear. Around `0xFFC3A000` the data renders as readable Latin capitals
with 2-pixel strokes — `A`, `B`, `C`, `D` appear in ASCII order in the span
`0xFFC3A0FC`–`0xFFC3A150` — and the `#` and `*` glyphs render from `0xFFC3A01C`
and `0xFFC3A038`. I did not pin down the cell height for this font: the glyphs
split at neither 7 nor 14 rows cleanly and I am not going to assert a geometry I
could not verify. The much larger block from `0xFFC00400` has a measured
autocorrelation peak at stride 28 and 56, renders as 2-byte-wide rows in 28-byte
cells, and the glyphs show the left-radical / gap / right-radical structure of
kanji rather than Latin letters. 205 KB at 28 bytes per cell is about 7,500
glyphs, which is the size of a JIS kanji set.

The RGB565 claim rests on the palette. At `0xFFC40000` the aligned `u16` values
are `FFFF`, `0000`, `0821`, `18C3`, `0861`, `A534`, `5AEB`, `CE99`, `41E8` — every
non-black, non-white one has G ≈ 2R ≈ 2B, which in RGB565 is exactly the neutral
grey locus, and `F800` (pure red, dominant at `0xFFC3EC00`) and `D000` are the
saturated cases. 15 to 19 distinct colours per KB. That is a UI bitmap, not
arbitrary data.

### 2. No code: five independent tests

**(a) Control flow.** 479 functions, 45,282 decoded instruction heads, **0**
`o_near` operands landing in `0xFFC00000`–`0xFFE80000`. Not one call, branch or
jump from recovered code enters the region. A raw byte scan of all 4 MB for the
`bsr.a`/`bra.a` 24-bit displacement forms produced 5,859 apparent hits, but every
one whose source byte is a verified instruction head is excluded by the operand
scan, so all of them are mid-instruction coincidences.
`ida\out\sub-lower\real_refs_into_lower.tsv`, `branch_into_lower_raw.tsv`.

**(b) Prologue pattern, with a positive control.** I derived the real CC-RX entry
shapes from the 455 known functions rather than guessing
(`ida\out\sub-lower\sig_summary.txt`): `71 00 <neg>` = `add #-imm, r0` (217 of
455, 47.7%), `60 x0` = `sub #imm4, r0` (114, 25.1%), `7E A6` = `push.l r6` (45),
`FB E2`/`FB EE` = `mov.l #imm, r14` (39), `6E xy` = `pushm` (16). Exits: 397 of
455 end in `rtsd` (`67 xx` or `3F xx xx`), 55 in `rts` (`02`).

Scanning both regions for those patterns and filtering each hit by a 1 KB linear
sweep:

| | raw hits | no decode failure | reaches a return | branch targets align |
| --- | --- | --- | --- | --- |
| UPPER `FFEDA000`–`FFF50000` (483 KB, known code) | 9,654 | 9,581 (99.2%) | 9,186 (95.2%) | 1,786 |
| LOWER (2,560 KB, my region) | 739 | 33 (4.5%) | **0** | **0** |

Density is 20.0 hits per KB in real code against 0.29 in my region, 69× apart.
The control also tells me the honest limit of the method: as a function-boundary
detector the pattern is poor — 1,786 candidates for 478 real starts is 7.1%
precision at 26.4% recall — but as a code/data discriminator the "clean 1 KB
decode that reaches a return" test is decisive, 95.2% against 0%.

**(c) Forced function creation.** I took all 33 LOWER candidates that survived the
clean-decode filter and called `ida_funcs.add_func` on each. IDA **accepted 1 and
refused 32**. The one it accepted, `0xFFE73605`, is 23 bytes and sits in a 1 KB
block with 24 distinct `u16` values and a 0.56 pixel-run fraction — RGB565 image
data. All 33 candidates are in blocks classified as pixel data. I reject the one
acceptance as a false positive and undid it, so the region ends the pass with the
one real function it started with.
`ida\out\sub-lower\lower_candidates.tsv`, `force_tier1.tsv`,
`control_candidates.tsv`.

**(d) Pointer targets.** 1,922 aligned dwords anywhere in the image hold a value
inside the region, naming 1,473 distinct targets. Classified by content: 841
zero-headed, 585 other data, 47 strings, **0 code-like**
(`ida\out\sub-lower\ptr_target_class.tsv`). They are not an index table either:
across all 1,922 there are only three contiguous stride-4 runs of 4 or more
entries, 16 entries in total, and two of those runs are one value repeated. There
is no 32-bit resource pointer table. The 1,922 are overwhelmingly coincidences
inside pixel data.

**(e) Real pointer loads.** Scanning all 4 MB for `MOV.L #imm, Rd` in all three
immediate encodings gives 14,419 instructions; the encoding is validated by where
the immediates go — 78.4% into RX64M RAM and peripherals `0x00000000`–
`0x000FFFFF`, 18.1% into upper ROM `0xFFE80000`+, 2.1% elsewhere. **193** have an
immediate inside my region. Verified against real instruction heads
(`ida\out\sub-lower\ptr_loads_verified.tsv`): **77 are real instructions, 116 are
mid-instruction byte coincidences.** The 77 real ones reach only four addresses:
`0xFFC00100` (48 loads), `0xFFC3EB56` (10), `0xFFC3EB44` (2), `0xFFC3EB7E` (1),
plus 16 in the JPEG cluster discussed below. **No instruction anywhere in the
image loads a pointer to `0xFFC40000`–`0xFFE80000`** — the entire 2.23 MB pixel
region. 32 of the region's 40 64 KB pages are never named by any real operand.

That leaves an honest open question, stated as such: I did not find the mechanism
by which the 2.23 MB of bitmaps is addressed. It is not a 32-bit pointer, not a
32-bit index table, and not a monotonic file-offset table (I looked for those:
two runs of 8 and 9 entries in the whole image, neither in a plausible place).
The most likely explanation is a base held in RAM and initialised by code in the
~1.4 MB of the upper region that is still not recovered, but I have not
demonstrated it.

### 3. Peripheral references — `ida\out\sub-lower\periph_refs.tsv`

Register-tracked scan over all 479 recovered functions, covering `#imm`,
absolute, register-indirect `[Rn]` and `dsp:8`/`dsp:16` displacement forms, with
constant propagation through `mov.l #imm, Rn` and `add #imm, Rn`. **1,120 hits,
246 distinct peripheral addresses.** By form: 535 immediate, 454 base+displacement,
131 register-indirect.

| Block | Hits | Peripheral |
| --- | --- | --- |
| `00080000`–`000807FF` | 130 | SYSTEM — clocks, module stop, `PRCR` |
| `00082800`–`00082FFF` | 41 | DTC |
| `00083000`–`00083FFF` | 18 | unidentified |
| `00087000`–`00087FFF` | 194 | ICU interrupt controller |
| `00088000`–`000887FF` | 80 | CMT compare-match timers |
| `00089000`–`000897FF` | 61 | S12AD 12-bit ADC |
| `0008A000`–`0008A7FF` | 110 | SCI channels 0, 2, 3 |
| `0008C000`–`0008C7FF` | 434 | I/O ports |
| `000C1000`–`000C1FFF` | 48 | timer block |
| `000F4000`–`000F47FF` | 4 | unidentified |
| **`000A0000`–`000A0400`** | **0** | **USB0 — never addressed** |

The USB0 zero holds in a widened window too: `0x0009E000`–`0x000A2000`, USB0 plus
8 KB either side, has **0** hits. Inside my region there are 25 byte patterns that
look like `MOV.L #<peripheral address>, Rd` (all `imm:24`), **0** of them with an
immediate inside USB0 and **0** of them at a real instruction head — they are
coincidences inside bitmap data. 787 aligned dwords in my region fall in the
peripheral window (280 distinct values); **none** inside USB0.

SCI channel usage, `0x20` stride from `0x0008A000`: channel 0 (38 hits), channel 2
(36), channel 3 (36). Channels 1 and 4–7 are untouched by recovered code.

### 4. Module stop and register protect — `ida\out\sub-lower\mstp_prcr.txt`

Three functions touch `MSTPCRA`–`MSTPCRD`: `0xFFEE1393`, `0xFFF15055`,
`0xFFF36CCA`. They are the only ones in the whole image — no instruction anywhere
materialises `0x00080010`, `0x00080014`, `0x00080018`, `0x0008001C` or
`0x000803FE` other than in those three, and all three hold the base in a register
and reach the rest by displacement (`4[r1]` = `MSTPCRB`, `0Ch[r1]` = `MSTPCRD`,
`3EEh[r14]` = `PRCR`).

`0xFFF36CCA` is the main release sequence:

```
FFF36CCA  6040             sub     #4, sp
FFF36CCC  fbee100008       mov.l   #00080010, r14        ; MSTPCRA
FFF36CD1  fae9f7010ba5     mov.w   #0A50B, 3EEh[r14]     ; PRCR = A50B, unlock
FFF36CDC  ecef             mov.l   [r14], r15            ; read MSTPCRA
FFF36CDE  7adf             bclr    #13, r15              ; release
FFF36CE0  e3ef             mov.l   r15, [r14]
...
FFF36D1E  a81a             mov.l   4[r1], r2             ; MSTPCRB
FFF36D20  7bf2             bclr    #31, r2
FFF36D22  a01a             mov.l   r2, 4[r1]
```

Every module-stop bit the firmware ever clears:

| Register | Bits released |
| --- | --- |
| `MSTPCRA` | 9, 13, 14, 15, 16, 17, 19, 28 |
| `MSTPCRB` | **28, 29, 31 only** |
| `MSTPCRC` | none |
| `MSTPCRD` | 19 |

On RX64M the USB0 module-stop bit is `MSTPB19`. It is **never cleared**. Handed to
SUB-USB as their decisive test; the bit list is theirs to interpret, but on its
face USB0 is left in module stop, unclocked, for the life of the firmware.

### 5. The setup-menu record table has a reader

The previous session searched for code loading `0xFFED74F0` and found none. The
table's base is **`0xFFED74E8`**, one record lower, and exactly two instructions
load it: **`0xFFF095EB`** and **`0xFFF09695`**, both `mov.l #FFED74E8, r14`.
Full disassembly in `ida\out\sub-lower\menu_walker.txt`.

The table is an array of `{u32 count, u32 label_ptr}`, and the label pointers all
land in my region. Fully expanded, 23 groups, 116 labels:

| # | First label | n | Members |
| --- | --- | --- | --- |
| 1 | `FFC3DF4D` | 9 | TARGET LOCATION, COMPASS, BAND SCOPE, LAMP, LANGUAGE, LCD DIMMER, OPENING MESSAGE, SENSOR INFO, SOFTWARE VERSION |
| 2 | `FFC3E001` | 3 | MODE, DIGITAL, AUDIO |
| 3 | `FFC3E03D` | 6 | BANK LINK … MEMORY WRITE |
| 4 | `FFC3E0B5` | 14 | BELL, DCS CODE … WX ALERT |
| 5 | `FFC3E1CD` | 6 | DW TIME … PRIORITY REVERT |
| 6 | `FFC3E245` | 2 | DP-ID LIST, RADIO ID CHECK |
| 7 | `FFC3E26D` | 5 | RPT/WIRES FREQ … DG-ID |
| 8 | `FFC3E2D1` | 22 | APO … DIAL KNOB CHANGE |
| 9 | `FFC3E489` | 28 | APRS AF DUAL … TIME ZONE, **including COM PORT SETTING** |
| 10 | `FFC3E6B9` | 4 | BACKUP, MEMORY CH, MEMORY INFO, FORMAT |
| **11** | **`FFC3E709`** | **4** | **USB CAMERA, Bluetooth, DEVICE LIST, Bluetooth Save** |
| 12 | `FFC3E76D` | 1 | CALLSIGN |
| 21 | `FFC3E781` | 3 | ANTENNA ATT, FM BANDWIDTH, RX MODE |
| 22 | `FFC3E7BD` | 4 | DIGITAL POPUP, LOCATION SERVICE, STANDBY BEEP, DIGITAL VW |
| 23 | `FFC3E80D` | 5 | MIC GAIN, MUTE, RX AF DUAL, VOX, RECORDING |

Records 13–20 are zero. Two things matter here for the mission. `USB CAMERA` is a
**group header**, and its group is the Bluetooth group — `USB CAMERA`, `Bluetooth`,
`DEVICE LIST`, `Bluetooth Save`. And `COM PORT SETTING` sits inside the 28-item
APRS group, between `BEACON TX` and `DIGI PATH`, which places it as the APRS and
GPS data-port setting rather than anything to do with the USB connector. Menu
semantics are MENU's call; those are the addresses.

### 6. Both jump tables decoded — `ida\out\sub-lower\jump_tables.txt`

The previous session's two puzzles at `0xFFF0897E` and `0xFFF08B1F` are
function-pointer dispatch through a state byte in RAM. `0xFFF0897E`:

```
FFF0896A  mov.l   #00008C4C, r14      ; RAM state byte
FFF08970  movu.b  [r14], r14
FFF08972  cmp     #3, r14
FFF08974  bgt.b   FFF0898A            ; out of range -> clamp
FFF0897C  movu.b  [r14], r14          ; index 0..3
FFF0897E  mov.l   #FFED75A8, r15      ; table base
FFF08984  mov.l   [r14, r15], r14     ; scaled-index load, table[index]
FFF08987  jsr     r14
FFF08989  rts
FFF0898A  mov.b   #3, [r14]           ; clamp state to 3
```

Table `0xFFED75A8`, 4 entries: `FFF08994`, `FFF089A6`, and two more. `0xFFF08B1F`
is the same shape on state byte `0x00008F73`, bounds-checked with `cmp #10h` /
`bgtu`, through table `0xFFED75B8`, 17 entries — entries 0–14 all point at the
single handler `0xFFEF2032` and entries 15–19 are distinct (`FFF08A00`,
`FFF08A85`, `FFF0A8A6`, `FFF0A8B8`, `FFF0A958`). Both tables sit immediately above
the menu record table, which is why a scan for the record table walked into them.

### 7. Two hardware identifications from the region's strings

**GPS is a MediaTek part.** `0xFFC00112` holds `$PMTK103`, `0xFFC0011B`
`$PMTK102`, `0xFFC00124` `$PMTK001` — the MediaTek MT33xx proprietary NMEA
command set: cold start, hot/warm start, and the ACK sentence. They are loaded by
real instructions at `0xFFEE0E95`, `0xFFEE0EE0` and `0xFFEE106A` respectively, so
those three are the GPS command sender and ACK parser. The table immediately
before them at `0xFFC00100` is loaded 48 times from `0xFFEDB52A`–`0xFFEDBE47`.
Combined with SCI channels 0, 2 and 3 being the only serial channels touched, the
GPS link is one of them. Only three `PMTK` strings exist in the whole region, and
there are no `$GP`/`$GN`/`NMEA` sentence-name strings, so the receive path parses
sentences by field rather than by name.

**The hex-digit and formatting tables** are at `0xFFC0012D`
(`"0123456789ABCDEF"`, 25 loads from `0xFFEE1C55`–`0xFFEE21F6`) and `0xFFC3EB20`
(`"0123456789abcdef"` and the uppercase copy).

**CTCSS and DCS tables.** `0xFFC3D656` and `0xFFC3D8C2` hold 5-byte records
decoding as 67.0, 69.3, 71.9, 74.4, 77.0, 79.7, 82.5, 85.4 Hz — the standard
CTCSS tone list. `0xFFC3D750` and `0xFFC3D9BC` hold 3-byte records 023, 025, 026,
031, 032, 036, 043, 047, 051, 053, 054, 065, 071 — the standard DCS code list.
`0xFFC3D399` is the month-name table `Jan`…`Dec`.

### 8. The SUB image contains a baseline JPEG decoder

This is the one substantive correction to my own intermediate results, and it is
the most mission-relevant thing I found.

After fixing the sign-extension bug, 25 distinct addresses in my region appeared
to be referenced by real instructions, and about 28 of those references named
addresses inside the RGB565 pixel region — `FFD0FF00`, `FFD0FF01`, `FFDA0000`
through `FFDA0800`, `FFDAFE00`, `FFDB0300`, `FFDC0000`, `FFDC0100`, `FFDCFF00`,
`FFDCFF01`, `FFD8FF01`, `FFD9FF01`. Dumping the enclosing code
(`ida\out\sub-lower\pixel_ref_context.txt`) shows they are not addresses at all.
They are 16-bit constants sign-extended into 32-bit immediates by `stnz` and
`cmp`, and the 16-bit values are **JPEG markers**:

```
FFF4B267  7701d8ff00       cmp     #0FFD8h, r1          ; SOI
FFF4B26E  fd7cf601ffd8     stnz    #0FFD8FF01h, r6
...
FFF4B2A1  773600ff00       or      #0FF00h, r6          ; marker prefix
FFF4B2A6  7706c0ff00       cmp     #0FFC0h, r6          ; SOF0
```

In the cluster `0xFFF4B000`–`0xFFF4C600` the markers `FFD8` SOI, `FFD9` EOI,
`FFDA` SOS, `FFDC` DNL, `FFD0`/`FFD7` RST0/RST7, `FFC0` SOF0 and `FFE0` APP0 all
appear as compare or load constants. The confirming find is the canonical 64-byte
JPEG zig-zag natural-order table at **`0xFFF508F8`**, byte-for-byte.

There is no `JFIF`, `Exif`, `JPEG` or `YCbCr` string anywhere in the 4 MB image
and none of the Annex K default quantisation or Huffman tables are present, which
is what a **decoder** looks like — it reads the tables out of the stream. So the
radio can decode baseline JPEG, and `USB CAMERA` sits in the menu table. That is
the strongest functional hint in the region about what the `USB CAMERA` entry is
for. The decoder itself is in SUB-VEC's region; the addresses are above.

## USB relevance

**Question 1, everything USB.** My region contributes one string, `USB CAMERA` at
`0xFFC3E709`, which is a setup-menu group header whose members are Bluetooth
entries. The region contains no USB code, no descriptors, no endpoint tables and
no protocol bytes, and it contains no code at all beyond the 60-byte reset stub,
so that is a structural rather than a statistical negative. The corrected
peripheral scan over all recovered code finds **0** accesses to USB0
`0x000A0000`–`0x000A0400` in any addressing form, including base+displacement,
and **0** in the 8 KB either side. `MSTPCRB` has only bits 28, 29 and 31 cleared,
by the only three functions in the image that touch the module-stop registers;
bit 19 is never cleared. That bit 19 is USB0's stop bit is a datasheet fact about
the part, not something this image states, so the inference is: *if* the RX64M
mapping holds, USB0 is left in module stop for the life of the firmware. SUB-USB
owns that call. Zero of SUB-USB's 885 independently verified peripheral-access
sites fall in my region. Four independent lines agree.

**Question 2, USB SDR.** Nothing in my region bears on the sample source or the
transport, because there is no code here. What the region does establish is that
2.29 MB of the 4 MB image, 54.5% of the flash, is display bitmaps, so the notion
that spare firmware capacity is waiting to be repurposed should be judged against
a part whose flash is more than half full of pictures. The ADC block `S12AD` at
`0x00089000` is touched 61 times by recovered code; that is the RX64M's ~12-bit
1 Msps SAR converter and it is not an IF sampler. On link 3 of the chain, the USB
device controller, the module-stop evidence above says it is not merely unused.

**Question 3, the DSP and vocoder.** Not in my region. No `AMBE`, `DVSI`,
`PRODID`, `VERSTRING`, `RATEP` or `RATET` string occurs anywhere in
`0xFFC00000`–`0xFFE80000`, and no `0x61`-framed structure. The serial channels the
firmware does use are SCI 0, 2 and 3 at `0x0008A000`, `0x0008A040` and
`0x0008A060`; one of those carries the MediaTek GPS. Whoever owns the DSP question
should start from the other two.

## Hand-off

Addresses that belong to other agents, found while working mine.

**To SUB-USB.** The module-stop verdict material is in
`ida\out\sub-lower\mstp_prcr.txt`. Only three functions touch `MSTPCRA`–`MSTPCRD`
— `0xFFEE1393`, `0xFFF15055`, `0xFFF36CCA` — and no instruction anywhere
materialises those register addresses outside them. The complete set of bits ever
released is `MSTPCRA` {9, 13, 14, 15, 16, 17, 19, 28}, `MSTPCRB` {28, 29, 31},
`MSTPCRC` {}, `MSTPCRD` {19}. `PRCR` is written `0xA50B` to unlock at
`0xFFF36CD1` and `0xA500` to relock, and `0xFFF37424`–`0xFFF3743B` is a second
unlock/relock pair. On the unidentified blocks you asked about, I cannot name
them: my region has no code, so I have no image evidence for
`0x00083000`/`0x00083800`, `0x0008AC00`–`0x0008AC60`, `0x0008ADB0` or
`0x000C1A00`/`0x000C1A80`. My corrected scan sees 15 hits in
`0x00083000`–`0x000837FF`, 3 in `0x00083800`–`0x00083FFF`, 10 in
`0x000C1000`–`0x000C17FF` and 38 in `0x000C1800`–`0x000C1FFF`, which is all I can
add. Your `o_displ` tip was correct and cost me one pass too; my corrected scan
resolves 246 distinct peripheral addresses against 87 before.

**To SUB-VEC.** The baseline JPEG decoder is in your region: marker constants
throughout `0xFFF4B000`–`0xFFF4C600`, entry cluster around `0xFFF4B084`, helpers
at `0xFFF4C3A2` (byte fetch), `0xFFF4C408`, `0xFFF4C442`, `0xFFF4648C`, and the
canonical zig-zag table at `0xFFF508F8`. The two dispatch tables at `0xFFED75A8`
(4 entries, state byte `0x00008C4C`) and `0xFFED75B8` (17 entries, state byte
`0x00008F73`) are decoded in `ida\out\sub-lower\jump_tables.txt`. The reset stub
at `0xFFC00000` calls `0xFFF45DBC` for hardware init and `0xFFF36C53` as main,
sets `EXTB` `0xFFFFFF80` and `INTB` `0xFFED8A70`, `usp` `0x0006A8FC`, `isp`
`0x0006B8FC`, `fpsw` `0x100`, `psw` `0x10000`. Also: my segmentation recovered 478
functions from the fixed vectors alone against the earlier survey's 455, so the
earlier `_split_sub` segment layout was itself costing 23 functions.

**To MENU.** `ida\out\sub-lower\menu_walker.txt` has the complete table: base
`0xFFED74E8`, `{u32 count, u32 label_ptr}` records, reader at `0xFFF095EB` and
`0xFFF09695`, 23 groups, 116 labels, all expanded by name. `USB CAMERA`
(`0xFFC3E709`) is group 11's header and the group is `USB CAMERA`, `Bluetooth`,
`DEVICE LIST`, `Bluetooth Save`. `COM PORT SETTING` (`0xFFC3E5C9`) is inside
group 9, the 28-item APRS group. `RAM DISPLAY` (`0xFFC3E759`) is confirmed to sit
in the label array exactly one 20-byte record after group 11's fourth member
(`Bluetooth Save`, `0xFFC3E745`) and exactly one record before group 12's
`CALLSIGN` (`0xFFC3E76D`), so no group's count reaches it. It is in the array
without being reachable through this table — worth your attention. The label
array runs `0xFFC3DF4D`–`0xFFC3E8AD` at 20-byte stride, and more strings follow
it to about `0xFFC3EB90`.

## Open

Most valuable first.

1. **How the 2.23 MB of RGB565 bitmaps is addressed.** No instruction loads a
   pointer to `0xFFC40000`–`0xFFE80000`, there is no 32-bit index table and no
   file-offset table. The base almost certainly lives in RAM, set up by code in
   the ~1.4 MB of the upper region that is still unrecovered. Finding that
   initialiser would also give the bitmap catalogue, which is the map of every
   screen the radio can draw — including whatever `USB CAMERA` displays.
2. **`RAM DISPLAY` at `0xFFC3E759`.** It is in the label array but not inside any
   group's count. Either there is a second table, or it is dead. MENU's call, but
   it is the loose end most likely to be interesting.
3. **The unrecovered upper region.** 479 functions cover 120 KB of a ~1.5 MB
   region. Every scope-limited negative in this document — and in SUB-USB's work —
   would become much stronger with real coverage there. SUB-USB's approach is the
   right one to generalise: scan raw bytes for the `FB` immediate encoding and
   force-decode, because function recovery is not a prerequisite.
4. **The 3,072 unresolved bytes** in my region, the three `other`-class blocks.
   Small, and given the surroundings almost certainly a bitmap or glyph variant I
   did not fit, but they are the only part of the region I cannot name.
5. **SCI channels 0, 2 and 3.** One carries the MediaTek GPS. The other two are
   the best remaining candidates for the DSP or vocoder link, and the region's
   strings rule out a DVSI-style framing being present here.
