# Wave-2 lane W2-7 — SUB purpose map, slice 5 of 5

Owner-side static analysis of the decrypted FT3DR/DE ver 1.02 SUB (RX64M) image on
disk. Nothing was written to any radio; no image was produced. SUB is little-endian,
base `0xFFC00000` (file offset = addr − `0xFFC00000`). Machine-readable table:
`ida\out\wave2\sub-purpose-5.tsv` (columns `ea end size validated how purpose
evidence`). Counts: `ida\out\wave2\w2_subp5_counts.txt`. Job script:
`ida\jobs\w2_sub_purpose_5.py` (seed DB `SUB_WINDOW` → private DB `W2_SUBP_5`).

Model reported by this environment: **Opus 4.8** (`claude-opus-4-8`) — the Claude
Opus family the parent specified, so this lane proceeded.

## The shared list L and my slice

Built identically to the sibling lanes, in-script from the two source tables:

- L = rows of `ida\out\sub-window\functions.tsv` whose `validated` is `xref` or
  `body` (i.e. not `rejected`), whose start ea is **not** present in
  `ida\out\fnindex\sub-xref.tsv`, and whose `purpose` column is empty.
- Sorted by ea ascending. **len(L) = 2189.** slice_size = ceil(2189/5) = **438**.
- **Slice 5** (the last, taking the remainder) = `L[4*438:]` = **437 functions**,
  **first ea `0xFFF2F7C5`, last ea `0xFFF4FABD`**.

These are exactly the functions lane 4 validated as real code (by prologue+return or
by call/jump xref) but which lane 3 never reached through a call/jump/vector xref and
so never assigned a semantic purpose — the indirectly-reached / table-dispatched tail
of the SUB code map, in the upper code band `0xFFF2Fxxx`–`0xFFF4Fxxx`.

## Method

One IDAPython pass in `W2_SUBP_5` (seeded `--copy-from
ida\db\jobs\SUB_WINDOW\SUB_WINDOW.i64`, reopened for iteration; shared DBs only
copied-from). For each slice function the script derives a one-line purpose from,
in priority order:

1. **Peripheral touches** — light intra-function constant propagation over
   `mov.l #imm,rN` / `add #imm,rN`, resolving every operand (bare immediate, `[rN]`,
   `disp[rN]`) that lands in `0x00080000`–`0x000FFFFF` to a named block, and to a
   named register for the confident blocks (DMAC channel+reg, SDHI, SYSTEM, ICU
   IER/IPR, SCI). Register maps from RX64M + lane 3's `subvec_periph`.
2. **Referenced strings** — flash immediates that read as ≥4 printable ASCII bytes.
3. **Callee purposes** — `bsr`/`jsr`/`jmp` targets that are known function starts,
   labelled from (a) a hardcoded doc map (memcpy, glyph/text/menu/IPC helpers from
   docs 20/25/27), (b) lane 4 `functions.tsv` peripheral purposes, (c) lane 3
   `sub-xref.tsv` purposes (shortened). Named (semantic) callees are cited; purely
   generic "wrapper/leaf" callees are collapsed to a helper count + addresses.
4. **RAM struct / flash-table data refs** (secondary evidence), with common bit-mask
   immediates filtered out and flash tables named by region (bitmap-descriptor table,
   font atlas, string pool, etc.).
5. **Loop shape** (count of in-function backward branches) and **callers**.

**Classification (three-way).** Because these are lane-4-validated bodies, the reject
clause caught only true non-code. A function is `yes` (clean) if it contains a return
(`rts`/`rtsd`/`rte`) or ends in a tail branch; `frag` if it decodes as code
(≥50% code bytes) but has no return of its own — an IDA over-split continuation of a
larger routine (lane 4 Open #3 predicted these "over-split tails"); `no` (rejected)
only if the body is not code. Fragments still receive a best-effort purpose and, where
available, a `cont-of:<addr>` pointer to the fall-through predecessor so the parent
routine can be reconstructed.

**Not run / out of scope.** No Hex-Rays (none exists for RX). No entry into the DSP
`26AA:0020` loader / CDC-ACM window (it is MAIN's, not SUB's; no SUB slice address is
in it). No band/MARS/expanded-RX search. Settled negatives in RESUME-DEEP were not
disturbed. Purpose depth is capped by the RX-no-decompiler ceiling: where a function
only calls other un-named helpers, the honest result is a typed wrapper, not an
invented semantic name.

## Counts

- **len(L) = 2189**; slice 5 = **437** functions, `0xFFF2F7C5`..`0xFFF4FABD`.
- **Purposed = 437** (100%): **246 clean functions** + **191 code fragments**.
- **Rejected (data/degenerate) = 0** — every slice member decodes as RX code,
  confirming lane 4's validation for this slice.
- **Instruction bytes of purposed functions (Σ item size) = 39,399**
  (30,961 in clean functions, 8,438 in fragments). This is the `size` column summed.
- Semantic evidence: **121** functions cite a peripheral register, **2** cite an own
  string, **25** cite a named (doc-labelled) callee; the remaining ~289 are typed
  from the call graph / RAM-flash refs (typed wrappers, glue, and leaf utilities).
- Loop shape: 406 straight-line, 31 contain loops (largest `loops(87)` at
  `0xFFF4C9D1`, a ~10 KB table-driven dispatcher).

## Notable groups (with addresses)

- **microSD block-I/O + interrupt setup (SDHI / DMAC3 / ICU) — 86 functions from
  `0xFFF32A16`.** The dominant cluster of the slice. Register-level purposes name
  `DMAC3.DMSAR/DMDAR/DMCRA/DMCRB/DMTMD/DMCNT` (the SD block-transfer DMA channel 3,
  matching lane 3's "DMAC3 moves the block"), `DMAC.DMAST` (channel-start),
  `SDHI.SDIMSK1/SDIMSK2/SDSTS1/SDSTS2/SDCMD/SDARG/SDCLKCR/SDSIZE`, and
  `IER[05]/IER[0D]/IER[0F]` + `IPR[2C]/IPR[6F]/IPR[7B]` (enabling/prioritising the
  SDHI, DMAC and EXDMAC interrupt sources). This is the low-level storage machinery
  under docs 13/20's FAT layer — consistent with "microSD is data storage only".
- **Voice recorder / WAV (SD-backed).** `0xFFF376F0` refs `"VOICE PLAY"`;
  `0xFFF3772C` calls a `".wav"`-handling routine (`sub_FFF379BC`); a small
  surrounding group at `0xFFF376xx`–`0xFFF377xx` reads RAM state near `0x008C4C`.
- **Recording backup path.** `0xFFF3F8A5` refs `"local tree, not in this repo"` (backup directory on
  the SD volume, drive `I:`) and toggles ICU IER bits — the record-backup feature.
- **UI text / menu rendering — `0xFFF42000`–`0xFFF44xxx`.** Functions here call the
  documented draw primitives `ascii glyph-blit (sub_FFEF1B23)` (8 sites),
  `string-render (sub_FFEFA7E7)`, `dbcs/kanji glyph-blit`, and
  `menu-label-fetch(1-based) (sub_FFEE1DE8)` — per-row screen/label drawing for menus
  and status widgets.
- **External-bus / LCD chip-select (BSC).** `0xFFF3753A`, `0xFFF37542`, `0xFFF40309`
  touch `BSC_CS` registers (external memory config; CS1 = LCD, per docs 16/20).
- **Clock / module-stop control (SYSTEM).** 7 functions touch
  `SYS.MSTPCRA..D / SCKCR / PRCR` — peripheral clock gating and register-protect.
- **Flash-table readers.** A run of leaf functions indexes the
  **bitmap-descriptor table** (`0xFFED36xx` and neighbours), the **text/font-index
  span** (`0xFFEC6058`), and the **font/bitmap pixel store** — icon/glyph lookup
  helpers feeding the render path above.
- **USB: absent.** No function in the slice references `0x000A0000`–`0x000A03FF`
  (USB0). The settled negative "SUB USB0 is dark" holds across all 437 slice
  functions.

## Open

1. The 191 fragments are real code with no own return — IDA over-splits of larger
   routines. `cont-of:<addr>` in the evidence column points to the fall-through
   parent for 136 of them; merging them in-DB would collapse them into their parent
   functions and raise the semantic yield (a few chunk-ownership cases produce a
   circular `cont-of`, an artifact, not a real cycle).
2. The ~289 call-graph-typed wrappers/leaves are limited by their callees being
   un-named lower helpers (the F1xxxx accessor region); naming those callees (a
   lower-slice / lane-3 follow-up) would lift these to semantic purposes.
3. `0xFFF4C9D1` (~10 KB, `loops(87)`) and `0xFFF40C3E` (~1.2 KB, `loops(12)`) are the
   largest routines and warrant hand-disassembly if their subsystem matters.
