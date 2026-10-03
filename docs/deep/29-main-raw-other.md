# MAIN raw "other" residue — byte-exact resolution of the last 4,020 B

> Lane F2 of the deep pass. Private DB `FIN_MAIN_OTHER`
> (`ida\db\jobs\FIN_MAIN_OTHER\FIN_MAIN_OTHER.i64`, seeded `--copy-from
> ida\db\jobs\MAIN_RAW\MAIN_RAW.i64`; shared DBs untouched). Inputs:
> `ida\out\wave2\main-raw-types.tsv` (filter `type=="other"`),
> `ida\out\main-raw\runs.tsv`, `runs_diag.tsv`. Machine outputs:
> `ida\out\main-raw-other\split.tsv` (the complete partition),
> `fragments.tsv` (per-fragment decode), `decode.txt` / `decode2.txt` /
> `block4.txt` (authoritative H8S disassembly). Model: claude-opus-4-8
> (Claude Opus 4.8). Owner-side static analysis only; no image modified, nothing
> written to a radio.

## Verdict

**The 4,020 B / 524 runs that W2-8 left as MAIN raw "other" are fully accounted
for, and no new class of content exists in them.** The residue is not a hidden
table, loader, or peek/poke surface — it is the debris of a disassembler
limitation. The dominant cause is that **MAIN's core executes H8S instructions
that IDA's `h8s300a` module cannot decode**, above all the table-indexed load
`78 ?0 6B 2? dddddddd` (`MOV.W @(disp:32,ERn),Rm`), which occurs **280 times**
across the MAIN content region. Every such instruction becomes an undecodable
gap that fragments the surrounding recovered-code runs and, where a run boundary
lands on one, produces an "other" run whose code-probe decodes zero
instructions. The three ≥16 B blocks still in "other" split cleanly:
**block 1 = 91 B code + a 448 B 16-bit calibration table; block 3 = 287 B of
pure USB dispatcher code; block 4 = 157 B of pure USB-controller code.** The
fourth named block (0x003A84) was already retyped `parameter table` by W2-8; it
is confirmed here as five concatenated lookup tables with no code. The 505
sub-16 B fragments are, by decode and adjacency, 437 runs / 1,867 B of
code-region bytes (mid-instruction straddles + fragments of the 280 opaque
loads), 57 runs / 225 B of small inter-table data, and 11 runs / 47 B of padding
— all irreducible as runs only because the "outside `functions.tsv`" definition
cannot merge a 2–6 B orphan back into its parent instruction or table.

## Method

- **What ran.** Three IDAPython passes on a private copy of `MAIN_RAW`
  (`ida\jobs\fin_main_other.py`, `fin_main_other2.py`, `fin_main_other3.py`) plus
  a per-fragment pass (`fin_frag_decode.py`), all via `run_job.py --reopen`. Pure
  byte/structure analysis was done directly on
  `decrypted\FT3D_MAIN_ver102_EXP.bin` (base 0 ⇒ file offset == address).
- **Block disassembly.** For each block I linear-decoded from a clean
  instruction anchor (the end of the preceding `functions.tsv` function) through
  the block to the next function start. `decode_insn` (the lowest-level H8S
  decoder) established instruction boundaries; `create_insn` +
  `generate_disasm_line` produced the text. The opaque 8-byte
  `78 ?0 6B 2? dddddddd` form was handled explicitly (the module returns
  `size=0, itype=0` on it). A smart resync (skip 1–4 B, accept the skip that
  yields ≥3 consecutive clean instructions) and the set of intra-window branch
  targets pinned block 4's boundaries.
- **Data tables** were classified structurally (monotonic columns, fixed stride,
  16-bit-BE value distribution) on the raw bytes — the authoritative test for
  data, since H8S data decodes as plausible-looking garbage instructions.
- **Fragments.** Each of the 505 sub-16 B runs was (a) decode-tiled from its
  start (clean tile ⇒ code), (b) tested for all-padding (⇒ fill), (c) tested for
  a mid-instruction straddle, then (d) merged with neighbor type for the
  code-region vs data call. Result in `fragments.tsv` + `split.tsv`.
- **Boundaries honoured.** The CDC-ACM / USB↔DSP-download service window
  `0x078106`–`0x07B100` was **never disassembled or probed** — its 16 "other"
  runs are recorded as byte-class only. No band/MARS, self-write, or SDR question
  was reopened. No Hex-Rays (H8S).
- **What I could not do.** Give a complete H8S mnemonic for the
  module-unsupported instructions (the `78-b0` indexed load, and block 4's
  `01 7d` / `1f 10` / `17 6x` islands); I identify them as instructions by
  position (branch targets / in the executed stream) and by the 280-occurrence
  census, not by a full decode. Each sub-16 B fragment is characterized by shape,
  not reconstructed into its parent instruction.

## Findings

### The census that explains the residue: 280 undecodable indexed-loads

The idiom that drives MAIN's jump/pointer dispatch is:

```
mov.b  @0xFFFFB0xx:16, r3l      ; fetch a byte selector
and.l  #0xFF, er3               ; zero-extend
shll.l #2, er3                  ; selector * 4  (dword index)
78 b0 6b 26 00 05 64 70         ; MOV.W @(0x00056470,ER3),R6   <-- h8s300a: size=0
jsr    @er6                     ; call through the fetched pointer
```

`decode_insn` returns `size=0, itype=0` for every `78 ?0 6B 2?` form (verified at
0x0562B2, 0x0562C8, 0x0563A8, 0x0563DA, 0x05641C). A whole-image scan finds
**280** occurrences of `78 ?0 6B 2?` in `0x000000`–`0x07B753`. These are real,
executed instructions (each is sandwiched between `shll.l #2,erN` and
`jsr @erN`), so they are code — the module simply lacks the H8S/2600-advanced
`@(disp:32,ERn)` addressing form. This single gap is why so much MAIN code sits
outside functions as "recovered code" and why the four blocks and most sub-16 B
fragments were ever "other."

### Block 1 — 0x001825–0x001A40 (539 B): 91 B code + 448 B calibration table

- **Code 0x001825–0x001880 (91 B).** Tail of a recovered interrupt-style routine
  that begins at 0x00181A (`6A0C8F87  mov.b @0xFFFF8F87:16, r4l`) and ends
  `01106D75  ldm.l @sp+, er4-er5` (0x00187A) + `5670  rte` (0x00187E). The
  routine is a gate/counter updater over RAM 0xFFFF8F7C/8F7E/8F88/8F8A/8F8C/8F92.
  The run boundary 0x001825 is **mid-instruction** — inside
  `6B048F7E  mov.w @0xFFFF8F7E:16, r4` at 0x001824 — which is why the probe
  decoded only one bogus instruction.
- **Data 0x001880–0x001A40 (448 B).** A **28-entry calibration/interpolation
  table**, 16-byte stride. Each record is five 16-bit big-endian values + three
  zero words of padding. Column shapes (confirmed over all 28 rows):
  col0 descending 0x61A8→0x057B, col1 descending 0x22B8→0x04F5, col2 ascending
  step 0x28 (0x0078→0x04B0), col3 ascending step 0x2D (0x0087→0x0546), col4
  ascending step 0x64 (0x012C→0x0BB8). Two decay curves plus three linear ramps —
  an RF/level interpolation table. Record 0 = `61A8 22B8 0078 0087 012C 0000
  0000 0000`. The `rte` at 0x00187E is a clean code→data edge.

### Block 2 — 0x003A84–0x003B1D (153 B): all data, five lookup tables

Already retyped `parameter table` by W2-8 (so **not** part of the 4,020 B
"other"); confirmed here as 100% data and refined. It is the tail of a table
group that begins at 0x003A68:

| Range | B | Kind | Content |
| --- | ---: | --- | --- |
| 0x003A84–0x003A89 | 5 | byte curve tail | end of the gamma/expansion LUT begun 0x003A68 (0,1,2,…,255,255); bytes `84 A1 C8 FF FF` |
| 0x003A89–0x003AAB | 34 | byte index LUT | ÷2 staircase `00 00 00 01 01 … 0F 0F 10`, maps 0..33→0..16 |
| 0x003AAB–0x003ACE | 35 | byte index LUT | ÷3 staircase `00×4 01×3 … 0A×3`, maps 0..33→0..10, +1 align byte |
| 0x003ACE–0x003B18 | 74 | 16-bit value table | 37 BE entries, non-increasing decay 0x01DE→0x003C |
| 0x003B18–0x003B1D | 5 | byte ramp | 5 breakpoints `06 19 2D 4B 64` |

No instruction bytes; `84 a1 c8 ff ff` decodes as garbage ADD/OR only because H8S
data always does.

### Block 3 — 0x0562C8–0x0563E7 (287 B): 100% code, USB dispatcher

Linear decode over the enclosing routine [0x056298, 0x05641E) yields **108
instructions, 5 opaque indexed-loads, and 0 data bytes**. The block is a
stack-A USB jump-table dispatcher: a chain of `btst #n,@0xFFFFB0xx` /
`beq`/`bne` / `jsr sub_5Bxxx` tests selecting a handler. The three opaque loads
**inside** the block are:

- 0x0562C8 `78 b0 6b 26 00 05 64 70` → pointer table base **0x00056470**
- 0x0563A8 `78 b0 6b 26 00 05 EB D2` → pointer table base **0x0005EBD2**
- 0x0563DA `78 b0 6b 26 00 05 B3 10` → pointer table base **0x0005B310**

each followed by `5D60  jsr @er6`. (Two more of the same idiom bracket the block:
0x0562B2→0x0005645C just before, 0x05641C→0x0005AE32 just after.) There is **no
embedded data table inside the block** — the "embedded table" the classifier
guessed at is these opaque load instructions plus the external pointer tables
they index. The run is "other" only because its start 0x0562C8 *is* one of the
undecodable loads; its end 0x0563E7 is mid-instruction (`6A108C267370
btst #7,@0xFFFF8C26:16` at 0x0563E4).

### Block 4 — 0x076B50–0x076BED (157 B): 100% code, USB controller routine

Smart-resync decode over [0x076B4E, 0x076C04) yields **54 instructions + 9 short
islands the `h8s300a` module cannot decode, and 0 data tables.** It is a USB
device-controller service routine: it reads/writes the on-chip USB function
registers `@0xFFFFEE2C`, `@0xFFFFEE04`, `@0xFFFFEE05`, `@0xFFFFEE06` and
`@0xFEE000/0xFEE001`, calls `loc_783DA` / `sub_7823C` / `sub_7821E`, and returns
via `pop.w r2; rts`. The undecodable islands (`1f10`, `017d`, `016a`, `0f18`, and
the `17 6x 10 xx` bit-field forms) are **code, not data**: `01 7d` at 0x076BFA is
the target of `beq` from 0x076B5A, and the others sit between valid
USB-register accesses in the executed stream. Both run boundaries are
mid-instruction — start 0x076B50 inside `7A00 01000000 mov.l #0x01000000,er0`
(0x076B4E), end 0x076BED inside `5E07823C jsr sub_7823C` (0x076BEA). The routine
also calls into the closed service window (`jsr 0x0783DA`), but all of block 4
itself is outside that window.

### The 505 sub-16 B fragments (2,139 B), characterized

Per-fragment decode + neighbor context (`fragments.tsv`):

| Nature | Runs | Bytes | What they are |
| --- | ---: | ---: | --- |
| code-region interstitial | 377 | 1,703 | code-adjacent, non-tiling: mid-instruction straddles, fragments of the 280 `78-b0` opaque loads (e.g. 0x00481C=`78 b0`), constant-pool tails |
| code, decode-proven | 60 | 164 | tile exactly as H8S insn(s), e.g. 0x0004AA `06 7F`=`andc #0x7F,ccr`, 0x001784 `6A0C8F87`=`mov.b @0xFFFF8F87,r4l` |
| small inter-table data | 57 | 225 | 24-bit pointer-entry tails (0x006529 `FF 81 80`→0xFF8180, 0x006565 `FF 9D 26`→0xFF9D26), 16-bit values/indices between tables |
| padding / fill tail | 11 | 47 | 00/FF/20-dominated alignment/erase tails |

So **437 runs / 1,867 B are code-region bytes** and only **68 runs / 272 B are
data or padding**. The size profile (233 runs of 2 B, 96 of 6 B, 54 of 10 B,
74 of 4 B, …) matches orphaned instruction operands, not a structured table.
These are irreducible **as runs**: a 2–6 B span outside `functions.tsv` cannot be
merged into the instruction or table it belongs to without redrawing the run
definition, and the `h8s300a` gap blocks extending the neighbouring code runs
over the opaque-load fragments. (Caveat: sub-16 B shape calls carry a few-percent
boundary error; e.g. a handful of code fragments at the edges of the big code
blocks look "data" to a neighbor test. The decode column in `fragments.tsv` is
the authoritative per-run signal.)

## Final residual

The 4,020 B / 524 runs of W2-8 "other" partition exactly three ways
(`split.tsv`, byte-sum verified == 4,020):

| Bucket | Runs | Bytes | Note |
| --- | ---: | ---: | --- |
| closed-window-left-closed | 16 | **898** | inside CDC-ACM/DSP-download window 0x078106–0x07B100; byte-class only by rule |
| newly-typed (byte-exact) | 3 | **983** | block 1 (91 B code + 448 B 16-bit calibration table), block 3 (287 B code), block 4 (157 B code) |
| irreducible interstitial fragments | 505 | **2,139** | 437 runs/1,867 B code-region, 57/225 B small data, 11/47 B fill — characterized, not mergeable as runs |
| **total** | **524** | **4,020** | |

Separately, block 2 (0x003A84, 153 B) was already `parameter table` before this
pass; it is confirmed all-data and refined into 5 sub-tables (rows appended to
`split.tsv`, `old_class = parameter table (w2-8)`).

Read honestly: only the **898 B** behind the deliberate service-window boundary
is genuinely unexamined. Of the remaining 3,122 B, **983 B** is now firm
code/table, and the **2,139 B** of fragments is known in nature (≈1,867 B is
code the disassembler can't own, ≈272 B is small data/padding) even though each
orphan stays an "other" run.

## Open

Most valuable first:

1. **Teach IDA the `78 ?0 6B 2?` indexed-load (and the `01 7d`/`1f 10`/`17 6x`
   forms).** A small processor-module extension or a scripted `create_insn`
   override for these 280+ sites would absorb the bulk of the 1,867 B
   code-region fragments into real code and raise MAIN's measured
   instruction-byte coverage. This is the single biggest remaining unlock for
   MAIN completeness, and it confirms MAIN is a fuller H8S/2600-advanced-class
   core, not a plain `h8s300a`.
2. **Follow the dispatch pointer tables** at 0x00056470, 0x0005EBD2, 0x0005B310,
   0x0005645C, 0x0005AE32 (block 3) — enumerate their entries to name the
   stack-A USB sub-handlers. (Pointer-table typing is lane 5's job; this only
   locates them.)
3. **Identify what block 1's 28-entry calibration table feeds** (which routine
   reads 0x001880 with the ×16 stride) — it is an RF/level interpolation store,
   a candidate for the calibration-feature attach point noted in doc 22.
4. The 898 B in the service window stay closed by project boundary; opening them
   is out of scope for this lane.
