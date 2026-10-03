# Wave 2 - SUB code-window function purposes, slice 1

Owner-side static analysis of the decrypted FT3DR/DE ver 1.02 **SUB** image
(RX64M, little-endian, base 0xFFC00000; file offset = addr - 0xFFC00000).
Read-only: nothing here is written to any radio.

## Method

1. **List L.** Rows of `ida/out/sub-window/functions.tsv` (lane 4) that are
   validated (`validated` in {body, xref}, i.e. not `rejected`), whose start ea
   is **not** present in `ida/out/fnindex/sub-xref.tsv` (lane 3, the 1,689
   reached functions), and whose `purpose` is empty. Sorted by ea ascending.
   - **len(L) = 2189** (2054 body-validated + 135 xref-validated-but-not-in-lane-3).
   - Split into 5 contiguous slices, `ceil(2189/5) = 438` each (slice 5 = 437).
   - **This is slice 1: 438 functions, first ea `FFEDB0AA`, last ea `FFEF395E`.**

2. **Batch facts (IDAPython).** `ida/jobs/w2_sub_purpose_k1.py` on DB `W2_SUBP_1`
   (seeded from `SUB_WINDOW`) decodes each function and records: prologue shape
   (push/pushm/`sub #imm,sp` with SP=R0), return/tail terminator, instruction
   count and code bytes, direct callees (bsr/jsr o_near) resolved against lane-3
   purposes, **indirect** jsr/jmp, dispatch-table pointer immediates into the SUB
   rodata region 0xFFED0000-0xFFEDA000, peripheral register touches (imm/mem in
   0x00080000-0x000FFFFF, named via `ida/out/sub-vec/periph_addrs.tsv`), RAM refs
   (>= 0x400), string-pointer immediates, back-edges (loops), and code
   callers/data refs.
   - **Over-split handling.** Lane-4 boundaries frequently cut one routine into
     several "functions"; IDA holds each as its own entry (all 438 are IDA func
     entries). For a fall-through prologue whose real body continues past its
     row end, the scan is **extended** through to the terminating return so the
     row's calls/periph/strings/dispatch reflect the whole routine it heads.
     124 rows were enriched this way.

3. **Synthesize purposes** (`scratchpad/gen_purpose.py`, pure post-processing)
   with priority: peripheral access -> state/table dispatcher -> string/label ->
   tail thunk -> call-sequencer -> loop -> over-split entry sliver -> leaf. Each
   line cites its start address and the evidence used.

4. **Manual review.** `ida/jobs/w2_sub_purpose_k1_dump.py` dumped full
   disassembly for 23 representative/vague/notable functions
   (`ida/out/wave2/review_dump.txt`); the dispatcher pattern, the hex formatter,
   the stdio setup, the password-label routine, the 2D compute loop and the sole
   rejected block were all confirmed by hand and the templates tuned from them.

## Counts

- **Purposed: 437.  Rejected: 1.**
- Instruction (decoded) bytes of the 437 purposed functions: **23,895** (equal to
  total item size end-start, i.e. every item byte decodes as code; no data pads).

### Purposed instruction bytes by item size

| item size (bytes) | functions | instruction bytes |
|-------------------|-----------|-------------------|
| 1-8               | 69        | 178               |
| 9-32              | 91        | 1,781             |
| 33-64             | 189       | 8,588             |
| 65-128            | 41        | 3,337             |
| 129-256           | 35        | 5,413             |
| 257-512           | 12        | 4,598             |

The 33-64 B band dominates by count - it is mostly the fixed-size state-machine
dispatchers (0x2A B) and small call-sequencers.

### By classification (`how`)

| how            | count | instr bytes | meaning |
|----------------|-------|-------------|---------|
| calls          | 305   | 13,247      | mid-level sequencer/coordinator: calls lane-3 wrapper/leaf helpers |
| dispatch       | 45    | 4,422       | state/table dispatcher via indirect jsr through a pointer table |
| leaf           | 33    | 2,173       | small leaf helper / compute fragment, returns |
| periph         | 20    | 2,147       | direct peripheral register access |
| tail           | 17    | 812         | thunk / tail-branch to another sub |
| string         | 12    | 759         | references a string literal (UI label / libc) |
| entry-sliver   | 4     | 8           | over-split prologue-only fragment (SP setup), body continues |
| loop           | 1     | 327         | leaf loop/compute routine |
| interior-block | 1     | 59          | **rejected** (see below) |

## The one rejection

- **`FFEF3715`** (59 B, 22 insns): no prologue, no callers, no data ref, no
  return of its own; it reads sub-index RAM 0x8C4D and range-checks key codes
  ('0'-'3', 0x10/0x20, 'I','Z', 'M'-'N') then writes fields into a struct, and
  falls through - control first reaches an `rtsd` +10 B later. It is an interior
  case block of an over-split key-code handler, not a standalone function.

## Notable groups

- **UI / menu state machine (45 dispatchers).** The single most important
  finding of this slice. A recurring 0x2A-byte template reads the master state
  byte **RAM 0x8C4C** (referenced 238x firmware-wide; 65x within this slice),
  bounds-clamps it, indexes a per-screen handler pointer table in the rodata
  region (`off_FFED3F6C`, `off_FFED3F8C`, ... `off_FFED4Fxx`; 55 distinct table
  pointers span 0xFFED0BBC-0xFFED8974) and `jsr`s the selected handler. Larger
  0x86-byte variants also seed a sub-handler and bump the state. Sub-index
  **RAM 0x8C4D** (64x) selects a second dimension; **0x8E46** (19x) and
  **0x8F73** (32x) are mode/flag guards. These are the SUB's screen/mode
  step functions; the tables at 0xFFED3F00+ are the screen dispatch tables.

- **Shared data structures.** RAM **0x1D3B8** is touched by 93 functions - a
  display/render context block (neighbours 0x1D3B0, 0x1D3C8 pointer, 0x1D264,
  0x1CE14 object tables). RAM **0x12CD8** is a 24-byte-element table
  (bounds-checked, fields at +0x0C/+0x14/+0x16; e.g. FFEDB14B iterates and
  populates it) - a channel/entry list; 0x12D44 is a sibling table.

- **Peripheral drivers (20 direct + more via helpers).** PORT/pin I/O
  (0x8C027/0x8C028), TPU timers (0x88135 TPU2.TSR, TPU_TSTR), and clock /
  module-stop / reset control (SYSTEM base 0x80000, via helper sub_FFEEFEA4 with
  module masks 0x80000/0x20000/0x40000). DMAC region 0x8281C also appears.

- **C runtime / formatting (libc region).** FFEE1780 initialises stdio
  (references "local tree, not in this repo", "local tree, not in this repo", "local tree, not in this repo"); FFEE21BD is a
  byte->hex-ASCII formatter using the "0123456789ABCDEF" table at 0xFFC0012D.
  memcpy = `sub_FFEFB268` is called by a handful of routines (per lane 25 ABI).

- **UI text labels (string bucket).** "PASSWORD INPUT"/"PASSWORD ENTRY"
  (FFEE81C6/E6, drawn via label helper sub_FFEF1B23), "Waiting", "Adj"/"Data"/
  "Mode", "To:", "TEXT", "A12" - operator-facing screen strings.

- **Over-split artefacts.** 4 pure entry slivers (a lone `sub #imm,sp`
  prologue whose body is the next contiguous "function") plus the many enriched
  fall-through rows are consequences of lane-4 recovery splitting single routines
  at internal labels; they are described as the routine they head, not rejected,
  because a genuine stack-frame prologue is present.

## Files

- `ida/out/wave2/sub-purpose-1.tsv` - 438 rows: `ea end size validated how purpose evidence`
- `ida/out/wave2/sub-purpose-1.md` - this file
- `ida/jobs/w2_sub_purpose_k1.py` - IDAPython facts extractor (emits the per-function
  facts consumed by the purpose synthesiser)
- `ida/jobs/w2_sub_purpose_k1_dump.py` - IDAPython manual-review disassembly dumper
- DB: `ida/db/jobs/W2_SUBP_1/` (seeded from SUB_WINDOW); logs: `ida/log/jobs/W2_SUBP_1/`

The per-function facts table and the manual-review disassembly dump were produced
as intermediates during synthesis; the evidence they yielded is folded into the
`evidence` column of the TSV and the groups above. Both jobs regenerate them on
demand from DB `W2_SUBP_1`.
