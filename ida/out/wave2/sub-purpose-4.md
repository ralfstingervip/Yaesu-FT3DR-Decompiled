# SUB purpose map — Wave-2 lane W2-6, SLICE 4

Owner-side static analysis of the decrypted FT3DR/DE ver 1.02 SUB image
(`decrypted\FT3D_SUB_ver102_ALL.bin`, RX64M, little-endian, base `0xFFC00000`,
file offset = addr − `0xFFC00000`). Nothing was written to a radio; no image was
produced. This lane only reads and describes code already on disk.

Model reported by this environment: **Opus 4.8** (`claude-opus-4-8`) — the Claude
Opus family the parent specified.

Machine-readable table: `ida\out\wave2\sub-purpose-4.tsv`
(columns `ea end size validated how purpose evidence`). Job scripts:
`ida\jobs\w2_sub_purpose_4.py` (batch) and `ida\jobs\w2_sub_purpose_4_dump.py`
(representative disassembly). Run logs (IDA stdout/stderr, status, counts, dump)
under `ida\log\jobs\W2_SUBP_4\`. Private DB `W2_SUBP_4`, seeded
`--copy-from ida\db\jobs\SUB_WINDOW\SUB_WINDOW.i64` (4,264 functions); no shared
DB opened for writing.

## Shared list L and this slice

L = rows of `ida\out\sub-window\functions.tsv` that are validated
(`validated ∈ {body,xref}`), whose start ea is **not** present in
`ida\out\fnindex\sub-xref.tsv` (lane 3's 1,689 reached functions), and whose
purpose is empty (excludes lane 4's 188 already-purposed). Sorted by ea,
`slice_size = ceil(len(L)/5)`, five slices; this lane owns **slice 4**.

- **len(L) = 2,189**, slice_size = 438.
- **Slice 4 = L[1314:1752], 438 functions, first ea `FFF0F05B`, last ea `FFF2F7B1`.**

These are functions with no incoming call/jump/vector xref — dark code reached
only indirectly (through fn-pointer tables) or that IDA over-split. All lie in the
upper application/UI band of the SUB image; **none touch a peripheral register**
(SCI/SDHI/DMAC/USB0/etc. all live below this band and are already in lane 3).

## Method

Batch IDAPython (`w2_sub_purpose_4.py`) recomputes L from the two TSVs, takes
slice 4, and for each function runs an intra-function pass:

- **Const-prop peripheral/RAM/flash resolution** over `mov.l #imm,rN` /
  `add #imm,rN`, handling bare immediates, `[rN]`, and `disp[rN]` (RX keeps the
  byte-scaled displacement in `op.value`, per brief correction 4). Peripheral
  region `0x00080000`–`0x000FFFFF` mapped to named blocks (same table as lane 3);
  RAM addresses `0x1000`–`0x7FFFF` recorded (landmarks from docs 25/20/27 named);
  flash immediates read as ≥4 printable ASCII → string refs.
- **Callee vocabulary**: direct `bsr`/`jsr` targets that are known function starts
  are mapped to a short tag from a known-name map (docs 25/20/27/16, plus this
  lane's disasm review) or from lane 3's `sub-xref.tsv` purpose text.
- **Indirect dispatch**: a register-target `jsr`/`jmp` is flagged; a flash
  immediate whose dereferenced dword is itself a code address in the window is
  recorded as a **function-pointer table** — this recovers the state-dispatcher
  group that has no direct xref and no direct callee.
- **Loop shape**: a backward branch inside the function → "loop".
- **Reject** if the body is not a real function: no instructions, or fewer than 3
  instructions with no return terminator, no callee, no loop, no indirect call
  (over-split tails / data).

After the batch, representative members of every non-obvious group were
disassembled to confirm the label rather than guess:
the 9–11 B stubs, the 42/134 B state dispatchers, the "hot accessor" callees, and
the largest leaves. Two doc-derived labels were corrected as a result (below).

**Not run / out of scope:** no Hex-Rays (none exists for RX). No entry into the
DSP/CDC-ACM service window (it is MAIN-side; nothing in this SUB slice falls in
it). No band/MARS/expanded-RX search. Settled negatives in RESUME-DEEP untouched.
Functions whose base register arrives from a caller argument or a RAM pointer are
outside const-prop reach — the same ceiling lanes 2/3 record — and are labeled
honestly as reg-relative/arg-only accessors, not padded.

## Counts

- Functions in slice: **438**.
- **Purposed: 371** (each with a one-line purpose citing its start address).
- **Rejected: 67** (not real functions — see below).
- validated breakdown of the 438: 318 `body`, 53 `xref` (lane-4 tag), 67 rejected.
- **Instruction bytes of purposed functions (Σ item size): 32,515.**
  (Rejected fragments total 188 bytes.)
- Evidence classes among purposed (`how` column): 174 call-graph-only,
  114 RAM+call-graph, 50 leaf (arg-only/reg-relative), 23 indirect dispatch,
  10 string-bearing (+ combinations).

## Corrections to prior labels (from this slice's disassembly)

1. **RAM `0x00008C4D` is a per-item UI/config struct array (stride `0x14`), not
   specifically "cam cfg".** Doc 20 named it `cam_cfg` from the camera screen, but
   in this slice the same base is indexed `0x8C4D + item*0x14 + field` by APRS /
   messaging / list screens (strings "LOCAL NEWS", "ADD TO CATEGORY", "UPLOAD",
   "SEARCH & DIRECT"). Relabeled neutrally. The adjacent byte **`0x00008C4C` is the
   per-screen sub-state selector** (clamped to ≤3 by the dispatchers), and
   **`0x00008F73` is the menu-item/cursor index** (range-checked ≤`0x10`).
2. **`sub_FFEF1C48` is a framebuffer draw helper** (spills 5 args, loads the
   framebuffer pointer at `[0x1D3C8]`, tail-calls the blit primitive
   `sub_FFEF0581`) — not the generic "hot accessor" its high caller count
   suggested. **`sub_FFF1EE20` is an object/list accessor** that stores the current
   object pointer at global `0x65E30` and returns a validity flag (569 callers).

## Notable groups (with addresses)

- **Per-screen state/event dispatchers — 23 functions** (e.g. `FFF0F170`,
  `FFF0F66B`, `FFF0F802`, `FFF0F961`, `FFF0FA85`, `FFF0FF98`, `FFF1016A`,
  `FFF1039A` …). Shape: read the sub-state byte at RAM `0x8C4C` (or item index
  `0x8F73`), range-check it, then `mov.l [rIdx, #off_FFED79xx], r14; jsr r14` —
  **indirect dispatch through a 4-entry function-pointer table in the data region
  `0xFFED7948`–`0xFFED7Bxx`**, then clamp the state to 3. These have zero direct
  xrefs (their addresses live only in those tables), which is exactly why they
  fell out of lane 3's reached set. The fn-ptr tables at `0xFFED79xx` are the
  attach point for a new screen sub-state.
- **Setup/list-row label drawers — ~95 functions** tagged `UI draw/screen`
  (e.g. `FFF0F612`, `FFF0F641`, `FFF0FE0E`, `FFF10025`, `FFF122FE` …). Compute a
  cell position from `0x8C4D + item*0x14`, set color/attr, and call the ASCII
  glyph blit `sub_FFEF1B23` (28 callers here); string-bearing members draw fixed
  labels ("LOCAL NEWS" `FFF0F9DA`, "ADD TO CATEGORY" `FFF103EA`, "UPLOAD"
  `FFF11530`/`FFF12697`, "SEARCH & DIRECT" `FFF1236A`). This is the same
  render-a-row idiom doc 20 documented for the camera screen, replicated across
  the APRS/messaging screens.
- **Object/list-management cluster `FFF1B000`–`FFF2D000` — 25 functions** call the
  object accessor `sub_FFF1EE20`(@`0x65E30`) and touch list-state RAM
  (`0x65E2C`, `0x65E24`, `0x100C`, `0x1212`, `0x12512`); **31 functions reference
  the padded label constant `"        CEN"` at `0xFFF4ADF8`** (a right-justified
  field default in the string pool). This is the GM/APRS/memory-list handling
  band.
- **SD-card record codecs — `FFF28000`+.** `FFF286F9` (112 B) unpacks a
  **FAT/DOS packed date-time**: from a 16-bit field at struct `+0x234` it emits
  sec×2 (`&0x1F<<1`), min (`>>5 &0x3F`), hour (`>>0xB`); from `+0x236` day
  (`&0x1F`), month (`(>>5 &0xF)−1`), year (`>>9 +0x50` → 1980-based) into an output
  struct — the SD file-timestamp decoder above the block layer of doc 13.
  `FFF28113` (47 B) is a bit-flag get/set on a struct field at `+0x443` with a
  `0x18`-mask validity check.
- **`.wav` filename builder `FFF13F01`** (voice-record path): concatenates a base
  name with the `".wav"` extension (`aWav_0`) via the CC-RX string ops
  (`smovu`/`suntil`) and `sub_FFF45524`/`sub_FFF15F48`, checks a `','` delimiter,
  and stores results to globals at `0x20278`+`0x108`/`0x10C`/`0x30134`.
- **Trivial/stub leaves — 50 functions**, mostly 9–11 B (e.g. `FFF15D0C`,
  `FFF15DCF` return 0; `FFF12437` is an argument-shuffle thunk). The larger leaves
  (`FFF1E789` 61 B context initializer, `FFF28113`, `FFF286F9`) are real
  reg-relative struct accessors/codecs whose base pointer arrives in an argument —
  the const-prop blind spot, labeled `leaf/util (arg-only/reg-relative)` rather
  than left blank.

## Rejected (67, 188 bytes total)

All are over-split fragments, not standalone functions: **49 two-byte `60 40`
fragments** and **18 five-byte `71 04`/`71 00` fragments**, each a single
non-terminating instruction with no return, no callee and no branch. They cluster
at a regular `0x36`-byte stride inside a repeated near-identical stub block around
`0xFFF0F000`–`0xFFF10500` (index byte stepping `0x1E`), i.e. IDA created function
heads mid-structure. This matches lane 4's note that its ~408 no-prologue rejects
"are almost certainly over-split tails of adjacent functions." Each is recorded as
one fact in the TSV (address, "1–2 insn, no return/callee") with no recipe.

## USB / mission relevance

Nothing in slice 4 bears on the three mission questions. The slice is entirely
upper-band application/UI code (screen dispatchers, list/label drawing, GM/APRS
list management, SD record codecs, a voice-file namer). **No peripheral register
is touched by any of the 438 functions** — no USB0, no SCI, no SDHI register
access appears here; those drivers are lower and already mapped by lanes 2/3.
This is consistent with, and does not disturb, the settled negatives
(SUB USB0 dark; no SDR IQ source; no self-flash-write).

## Open

1. The `0xFFED7948`–`0xFFED7Bxx` fn-pointer tables that feed the 23 state
   dispatchers were not fully walked — enumerating each table's 4 targets would
   name the concrete per-screen handlers and pin which screen each dispatcher
   drives.
2. The reg-relative accessors (the 50 leaves and the 69 single-callee "wrapper"
   rows) need caller-side base-register resolution to lift from structural to
   semantic — the same call-graph ceiling lane 3 records; a data-flow pass across
   callers (out of this lane's per-function scope) would resolve many.
3. The `"        CEN"` field label's exact screen (GM member slot vs. APRS) is not
   pinned; naming the struct at `0x65E30`/`0x65E2C` would settle it.
