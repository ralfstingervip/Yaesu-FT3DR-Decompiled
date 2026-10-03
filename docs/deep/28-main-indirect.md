# MAIN code reached only through indirect dispatch (Lane F1)

Owner-side static analysis of firmware already on disk. No device, no USB, no
serial; nothing was written to a radio and no image byte was modified. MAIN is
Hitachi/Renesas H8S advanced (`h8s300a`), big-endian, image base 0 so file
offset == mapped address; content region `0x000400`-`0x07B753`. Model:
`claude-opus-4-8`.

Machine table: `ida\out\main-indirect\proved.tsv` (444 rows). Residual table:
`ida\out\main-indirect\residual.tsv` (194 rows). Supporting evidence:
`verify.tsv` (per-function decode), `xref_live.tsv` (IDA's own xref db),
`dead_ctx.tsv` (fall-through context), `disrange.txt` (sample disassembly).

## Verdict

The full pass left **31,559 B of MAIN instruction bytes** (380,782 total minus
349,223 inside proven functions) as *kept-but-unproven* code — functions IDA
created but that the validation pass rejected because they carry **no direct
call/jump xref and often no classic prologue**. I confirmed the root cause: in
IDA's live database **all 638 of these rejected functions have exactly zero code
xrefs and zero data xrefs** (`xref_live.tsv`). They are unreferenced because IDA
never formalised the links from MAIN's indirect-dispatch tables to their targets.
Reading those tables out of the raw image is therefore the only way to prove the
code, which is exactly what this lane does.

Resolving MAIN's full dispatch backbone (**149 jump/switch tables, 6,406
entries**, all 32-bit big-endian, read from the image and cross-checked
byte-for-byte against `jumptables.tsv`) plus an exhaustive image-wide pointer
scan **proves 444 of the 638 functions (19,848 B) are reached and are
self-contained routines** (all 444 terminate in `rts`/`rte` or a tail branch).
That moves MAIN proven-code coverage from **91.7% → 96.9%** of the 380,782
instruction bytes (69.1% → 73.0% of the 505,684 B content region). A further
6,664 B (107 functions) is demonstrably *reachable* dispatch/flow code that IDA
over-split (not independent pointer targets, so not counted as proven). The true
unexplained residual is **3,148 B (87 functions): 1,842 B of self-contained
standalone routines with no pointer anywhere** (dead, or fixed-stride
`base+index` dispatch banks whose individual entries are computed at run time),
plus over-split tails, four closed-service-window stubs, and alignment stubs.

## Method

What I ran (every step is a file on disk):

1. **Loaded the proven set from disk** and computed the difference. Kept set =
   `main-full\functions.tsv` (3,899 funcs). Proven set = the validated fnindex
   (`main-low.tsv` 1,547 + `main-high-a.tsv` 899 + `main-high-b.tsv` 818 = 3,264,
   confirming the brief's "3,264 validated MAIN_FULL functions"). Difference =
   **638 rejected functions, 29,660 B of function extent** — the body of the
   ~31,559 B residual (the remaining ~1,899 B is the gap between is_code-byte
   counting and function-extent counting, plus head/tail accounting). Recovered
   functions (`main-raw\recovered-functions.tsv`) are a disjoint set already
   folded into the 100,125 B proven recovered-code figure, so they are not
   re-counted here.

2. **Resolved the dispatch backbone from the raw image.** For all 149 tables in
   `jumptables.tsv` I read every entry as a 32-bit big-endian dword at
   `base + 4*i`, kept entries pointing inside the content region, and dropped the
   shared sentinel `0x0003FFA0` (the do-nothing/default handler — bytes
   `fc006a8c...`, the H8S equivalent of a dummy vector). My raw read matches
   `jumptables.tsv` entry-for-entry (the TSV only stores the first 32 targets per
   row; I verified 100% agreement over the stored prefix for every table). I then
   mapped each live target to the function it starts or lands inside.

3. **IDA verification pass** (`ida\jobs\fin_main_ind.py`, DB `FIN_MAIN_IND`
   seeded from `MAIN_FULL`, launched only through `run_job.py`). For each of the
   638 it decoded the whole extent and recorded: is_code/is_func, clean decode,
   first four instructions (prologue evidence), presence of `rts`/`rte`, last
   instruction, embedded-data items, indirect `jsr`/`jmp @ERn` count, references
   into any resolved jump-table span, callees, and the distinct 0xFFxxxx
   I/O/RAM operands (masked to the 24-bit effective address — H8S `@aa:16`/`@aa:8`
   are sign-extended by IDA). A second pass (`fin_main_xref.py`) dumped IDA's
   authoritative cref/dref lists; a third (`fin_main_ctx.py`) dumped the
   preceding-instruction context for the no-reference remainder;
   `fin_main_disrange.py` dumped full disassembly for representative samples.
   All scripts call `ida_auto.auto_wait()`, wrap the body in try/except to a
   traceback file, and `idc.qexit(0)`; logs in `ida\log\jobs\FIN_MAIN_IND\`.

4. **Closed the reachability gap with two image-wide scans.** Because IDA holds
   no xref to any target, I scanned the entire content region for every rejected
   function's start address appearing as a 32-bit BE value at **any** offset
   (negligible false-positive rate), and as a 24-bit BE value (accepted only at
   ≥2 occurrences or inside a data region, to exclude coincidences). This catches
   function-pointer arrays the pass never formalised as jump tables.

5. **Classified and cross-validated.** A function is counted **proven** only if
   its address is a live entry in a resolved table *or* a validated pointer **and**
   it decodes cleanly **and** it is self-contained (ends in `rts`/`rte`/tail
   branch). I re-checked every table-reached row by reading the cited entry back
   from the image: **358/358 cited `table[index]` values equal the function start
   (or land inside its extent); zero mismatches.**

**H8S/2600 decode limitation (per lane F2), handled.** IDA's `h8s300a` module
cannot decode some H8S/2600-advanced instructions — notably the table-indexed
load `78 ?0 6B 2? dddddddd` = `MOV.W @(disp:32,ERn),Rm` (~280× across MAIN
content, 5× inside my 638 rejected extents), plus `01 7d`/`1f 10`/`17 6x` forms —
so they appear as gaps mid-function. My verify pass walks `next_head` over such
bytes and keeps decoding, so these gaps never fail a decode or truncate a
function: **0 of the 638 had a failed decode**, and self-containment (`rts`/`rte`/
tail) was still detected past every gap. 20 of the 638 carry such a gap
(`ndata>0`); **9 are in the proven set** (correctly proven — the gap is real code
inside the body, not a boundary) and 11 are in the residual for reachability
reasons, not because of the gap (8 of those 11 are self-contained with a clean
`rts`; 3 are genuine over-split tails that flow into adjacent code). **No reject
is an artefact of the decoder limitation.**

Scope I did **not** cross: the closed service window `0x078106`-`0x07B753`
(DSP loader / CDC-ACM download protocol) stays byte-class only — four rejected
stubs there are left in the residual untouched. I did not chase run-time-computed
`jmp @ERn` targets whose base is loaded and indexed at execution time; those are
not statically resolvable and are reported as such.

## Findings

### The five backbone tables (raw big-endian resolution)

| Table | entries | sentinel `0x3FFA0` | live targets | unique targets | role |
| --- | --- | --- | --- | --- | --- |
| `0x007814` | 245 | 0 | 245 | 180 | switch/control-transfer dispatcher |
| `0x01109C` | 1,020 | 617 | 403 | 173 | 32-bit jump table (sparse) |
| `0x012268` | 2,446 | 1,494 | 952 | 405 | master code-pointer / jump table |
| `0x02A1C8` | 198 | 19 | 179 | 31 | 32-bit jump table |
| `0x04AB70` | 389 | 0 | 389 | 95 | 32-bit jump table |

(The brief's `0x01109D`/`0x02008C` and `0x02A4DE` are off-by-one/typo versus
IDA's boundaries `0x01109C`..`0x01208C` and `0x02A1C8`..`0x02A4E0`; entries are a
clean multiple of 4 from the IDA bases.) The `0x012268` table is the backbone:
2,446 slots, of which 1,494 are the shared `0x3FFA0` sentinel and 952 are live
code pointers to 405 distinct routines — a classic compiler-emitted function
dispatch array.

Across **all 149 tables (6,406 entries)** the resolution is complete and
self-consistent with `jumptables.tsv`.

### What the backbone proves

Of the 638 rejected functions, **444 (19,848 B) are proven reached + self-
contained**, by mechanism:

| Mechanism | funcs | bytes |
| --- | --- | --- |
| the 5 backbone tables | 190 | 7,454 |
| 85 other resolved jump/switch tables | 168 | 8,084 |
| function-pointer arrays found by image-wide pointer scan | 86 | 4,310 |
| **total proven via indirect dispatch** | **444** | **19,848** |

90 distinct tables each proved at least one function. Prologue: only 5 of 444
carry a classic register-save/frame prologue — the rest are leaf routines or
interrupt-context handlers whose register save sits in a shared dispatcher entry
(they end `ldm.l @sp+,er4-er6 ; rte`, the save having happened upstream). This is
the expected shape of indirectly-dispatched H8S handlers and does **not** make
them tails: all 444 return (398 via `rts`/`rte`, 46 via a tail `jmp`/`bra`).

Representative proven routines (purpose is address-cited from body + callees;
full set in `proved.tsv`):

- `sub_1114` / `sub_12AC` / `sub_1A94` (376 B each) — reached by jump tables
  `0x001108` / `0x001A88`; interrupt-context (`rte`) bit-serial handlers working
  the `0xFF8F80`-block state RAM with long `bld/rotxl.b/mov.w @er5` shift loops.
- `sub_2A57C` — `0x012268` entry 0x…; writes dispatch state `0xFFBBC2` (the
  `sub_2853E`/`sub_28562` state variable from lane 1), calls `sub_5E4C0`.
- `sub_4BF46` — `0x04AB70`; state RAM `0xFFBBE9`/`0xFFA919`/`0xFFA4FC`, calls
  `sub_4BFF4`,`sub_52888`.
- `sub_62692` — function-pointer array at `0x061C86`; state RAM
  `0xFFB26A`/`0xFFBC2C`, calls `sub_5363A`,`sub_61D8C`.
- `sub_322C` — `0x012268` entry 2293 → `0x00322C` (byte-verified); calls
  `sub_320E`,`sub_5E0E8`, `rts`.

### Why the targets looked unreferenced

`xref_live.tsv` shows **0 cref and 0 dref for every one of the 638** in IDA's
database. The dispatch tables carry the addresses, but IDA stored the table
entries as raw dwords without emitting offset xrefs to the targets, so recursive
xref analysis never reached them and the validation pass (which keys on xrefs +
prologue) rejected them. The table entry is the proof the xref database is
missing — confirmed by reading it back from the image for all 358 table-reached
rows.

## Coverage impact

| Measure | before (full pass) | after Lane F1 |
| --- | --- | --- |
| MAIN proven instruction bytes | 349,223 | **369,071** |
| …as % of 380,782 instruction bytes | 91.7% | **96.9%** |
| …as % of 505,684 B content region | 69.1% | **73.0%** |
| kept-but-unproven residual (B) | 31,559 | **11,711** |

**Bytes moved kept-but-unproven → proven via indirect dispatch: +19,848 B
(444 functions).**

Residual after Lane F1 = 11,711 B. Broken down against the 638 rejected
functions (29,660 B extent):

- **Proven, Tier 1:** 444 funcs / 19,848 B (above).
- **Reachable but not an independent pointer target, Tier 2:** 107 funcs /
  6,664 B — kept out of the proven count to avoid inflation, but demonstrably
  executed:
  - 32 funcs / 2,174 B reached by a table at their exact start yet falling
    through into the next block (multi-block routine IDA over-split);
  - 21 funcs / 974 B switch/indexed-dispatch fragments that themselves read the
    resolved tables `word_782C`/`word_12268`/`word_14D9E` and do `jsr @ERn`
    (e.g. `0x00481E`, `0x006C70`, `0x015E32`, `0x014E7E`), reached by fall-through
    from the index computation;
  - 54 funcs / 3,516 B continuation blocks reached by fall-through from
    non-terminating preceding code.
- **True residual, 87 funcs / 3,148 B:**
  - 42 funcs / 1,842 B self-contained standalone routines after a hard stop,
    with the address absent from all 149 tables, the full-image BE32 scan, the
    validated BE24 scan, and IDA's xref db. The evidence points to
    **fixed-stride dispatch banks** reached by a computed `base + index*stride`
    call rather than dead code: the clearest case is the IPC command-sender bank
    at `0x00A6FE`,`0x00A73A`,`0x00A776`,`0x00A7B2`,`0x00A7EE` (stride `0x3C`),
    each writing the IPC mailbox `0xFF3D72`/`0xFF3D74`/`0xFF3D76` (opcodes
    `0xF501`/`0xF502`/`0xF503`…) and calling `sub_7C20` — **three of the five
    members (`A6FE`,`A776`,`A7EE`) were already validated in the full pass**, so
    the bank is demonstrably live and `0xA73A`/`0xA7B2` are reachable siblings,
    not dead; they carry no static pointer only because the dispatcher computes
    each entry from the base at run time. The remaining standalone routines in
    this bucket are the ones I cannot yet tie to a base, so they stay honestly
    labelled "dead-or-computed";
  - 22 funcs / 748 B continuation/data spans with no independent return;
  - 9 funcs / 430 B over-split tails that fall through from a *proven* function;
  - 10 funcs / 30 B 1-2 instruction alignment/`rts` stubs;
  - 4 funcs / 98 B inside the closed service window (byte-class only, untouched).

Counting Tier 2's reachable code as well, **375,735 B (98.7%)** of MAIN
instruction bytes is accounted for as reached code. The genuinely unexplained
remainder is **~3,148 B** of rejected-function extent (the dead/standalone,
over-split-tail, stub and closed-window rows above), plus ~1,899 B that is the
difference between is_code-byte counting (the brief's 31,559 B) and
function-extent counting (my 29,660 B) — a measurement basis, not additional
unproven routines.

## Open

Most valuable next steps, in order:

1. **Resolve the fixed-stride dispatch banks** (~1,842 B, Tier-1-true-residual).
   Find each bank's base reference and the `mov.l #base; add #k*stride; jsr @ERn`
   dispatcher; that converts the largest residual chunk (e.g. the `0x00A7xx` IPC
   command-sender bank) from "dead-or-computed" to proven, and enumerates the
   full MAIN→SUB command set by opcode. This is the single biggest unlock and is
   also directly useful to the IPC map in doc 25.
2. **Fold Tier 2 into the function model.** Merge the 32 over-split prefixes and
   54 fall-through continuations back into their parent routines so the function
   boundaries match the source; this is bookkeeping, not new reachability, but it
   cleans the 6,664 B now sitting between "proven" and "residual".
3. **Emit the missing table→target offset xrefs** into the shared MAIN database
   so future passes see these 444 functions as referenced and do not re-reject
   them. (Do this only in a private DB copy; never touch `ida\db\FT3D_MAIN.i64`.)
4. The two closed-window stubs stay closed per standing policy.
