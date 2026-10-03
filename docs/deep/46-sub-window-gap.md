# SUB code-window gap 0xFFED0000–0xFFF50000 — what the "neither" bytes are (Lane H8)

Owner-side static analysis of `decrypted\FT3D_SUB_ver102_ALL.bin` (RX64M, LE, mapped
at `0xFFC00000`, file offset = address − `0xFFC00000`). Private DB `H8_SUBGAP`
(`--copy-from ida\db\jobs\FIN_SUB_T2\FIN_SUB_T2.i64`); no shared DB opened, no image
modified, nothing written to a radio. Model: claude-opus-5-5.

Tables: `ida\out\sub-gap\gap-runs.tsv` (861 classified segments of the 822 gap runs plus
the past-window region), `new-functions.tsv` (654 units, one purpose line each),
`typed-data.tsv` (50 typed data runs), `counts.txt`. Raw dumps and builders under
`ida\out\sub-gap\raw\`.

## Verdict

The published split has a hidden overlap. **3,994 B of validated code sit inside the
"string pool" proved-data region `0xFFF48000`–`0xFFF4C000`** (`sub_FFF4B059`,
`sub_FFF4B06C`, `sub_FFF4B084`; the strings end at `0xFFF4B059`). So 438,300 + 52,848
double-counts them, and the bytes that are neither code nor data come to **37,134 B in
822 runs**, not ~33,140. **Confirmed.**

Of those 37,134 B, **25,758 B are real code proven reachable** from already-validated
code, from interrupt vectors, or from pointers. **7,435 B are positively typed data.**
The other **3,941 B (0.75 % of the window)** stay unresolved: 3,829 B of well-formed
functions with no reference found, 72 B of fragments, and 40 B of decode conflicts.

Most of the new code (19,216 B) is chunks of already-validated functions that sit
outside the `functions.tsv` start–end range. They are reached by jumps, by
relative-switch cases (40 `bra.l` tables resolved, 32 of which IDA had missed), or by
falling through. The rest (6,542 B) is 356 new entries:

- 9 called routines, including a 1,714 B one at `0xFFEF42A7`
- 141 pointer-table callbacks: 57 screen-state hooks, 23 frame-alloc entry slivers, and
  5 bare-RTS null callbacks, one of which (`0xFFEF2032`) is the target of 719 table slots
- 206 vector RTE/WAIT stubs

The 7,388 B block at `0xFFED8E70`–`0xFFEDAB4C`, which earlier passes called "sparse
data", is exactly the three CC-RX **`.data` initialiser images** named by the
`_INITSCT` DTBL.

New honest SUB figures:

- **window code 464,058 / 524,288 = 88.5 %** (was 83.6 %)
- **code / non-data 464,058 / 467,999 = 99.2 %**
- **code + typed 99.25 %**

The past-window block `0xFFF50000`–`0xFFF509DE` (2,526 B) is the 2,293 B tail of
`sub_FFF4FABD` plus 233 B of JPEG/IDCT/switch data. It is reported here and kept out of
the denominator.

## Method

All IDA work is in `H8_SUBGAP`, run through `run_job.py`. The scripts are in
`ida\jobs\`, and each one ends with `qexit(0)` and writes UTF-8.

| Script | What it did |
| --- | --- |
| `h8_gap_dump.py` | Re-measured the numerator: the item size of every code head inside each `functions.tsv` xref/body range. It marked the 5 published data regions, emitted the gap runs, and dumped the composition, owning function, code/data xrefs and a linear-decode probe for each run (`raw\gap_raw.tsv`). It also dumped the past-window items. |
| `h8_switch.py` | Found every `7F 4x` (`bra.l Rx`) code head in `0xFFED0000`–`0xFFF509DE`. For each one it backtracked `mov.{b,w} [Ri,Rb],Rx` and `mov.l #tbl,Rb`, and bounded the table with the nearest `cmp #imm,Ri`. Each entry is a signed displacement from the `bra.l` (`raw\switches.tsv`, `switch_edges.tsv`). |
| `h8_closure.py` | Reachability closure. **Tier 1** starts from every validated instruction head (160,284 heads), plus the INTB 256 and EXTB 32 vector targets. Edges are decoded fall-through, `o_near` branch/call targets, IDA code xrefs and resolved switch edges. **Tier 2** scans LE32 values at every offset of the whole 4 MB image for targets in `0xFFED0000`–`0xFFF509DE` (6,496 sites). It keeps a site only if (a) it is a 4-aligned or table-adjacent data site, including the published data tables even where IDA had mis-decoded them, or (b) it is an immediate operand of validated or tier-1 code equal to the target. The target must lie outside the published data regions, the `.data` images and the switch tables, and must decode cleanly to a stop instruction (a bare `rts`/`rte` counts). Outputs: `raw\reach.tsv`, `ptr_sites.tsv`, `conflicts.tsv`, `t2_rejroots.tsv`. |
| `h8_units.py`, `raw\h8_units_prep.py`, `raw\h8_build.py` | Attribute each reached head to an owner. A head inherits its owner through jump, fall-through and switch edges. A call, a pointer or a vector starts a new unit. The scripts then add facts per unit (callees, RAM and peripheral immediates) and build the three tables. |
| `h8_query.py` | Spot disassembly used for the citations below. |

**Scope covered:** all 524,288 window bytes, plus `0xFFF50000`–`0xFFF509DE`.

**Pointer scope:** LE32 at every byte offset of the whole image. The scripts also
brute-forced `bsr/bra .w/.a` relative sources over the window for the unreferenced
residue, and 24-bit `FB ?E` immediates for the same targets.

**Not done:**

- No new instructions or functions were created in the DB. Everything here is a measured
  classification.
- Indirect `jsr`/`jmp` through RAM-held pointers was not traced beyond the `.data`
  images, whose LE32 contents *are* inside the pointer scan.

## Findings

### 1. The split, reproduced from disk (Confirmed)

| Quantity | Bytes | Source |
| --- | --- | --- |
| Window `0xFFED0000`–`0xFFF50000` | 524,288 | |
| Validated instruction bytes (functions.tsv xref+body, item-size) | **438,300** | reproduced exactly in `H8_SUBGAP` (`raw\h8_gap_dump_status.txt`) |
| — of which in the 68 wave-2 rejects | 247 | same pass |
| Published proved data (5 regions) | 52,848 | doc 21 |
| — overlap with validated code | **3,994** | `sub_FFF4B059` (`7e a6 ef 16`…), `sub_FFF4B06C` (`60 40 f8 06`…), `sub_FFF4B084`–`FFF4C226`, all inside `FFF48000`–`FFF4C000` |
| Published data net of code | 48,854 | |
| **Gap (neither)** | **37,134 in 822 runs** | 524,288 − 438,300 − 48,854 |

The string pool really ends at `0xFFF4B059`. The last strings are
`…2e 00 66 61 6c 73 65 00 74 72 75 65 00` (`".", "false", "true"`), and the next byte
is `7e a6`, a push. The region `0xFFF4B059`–`0xFFF4C000` holds 4,007 B of code. Of
those, 3,994 B are validated, and 13 B at `0xFFF4B077` are an unreferenced twin wrapper
of `FFF4B06C`: `60 40 66 04 f8 06 01 39 06 00 62 40 02`, which pushes, sets
`[r0]=#1`, calls `bsr.w FFF4B084` and returns.

The first 0x3C8 B of the "string pool" are switch tables (finding 4). The
companion's 93.0 % = 438,300 / 471,440 therefore used a denominator that excluded
3,994 B of credited code. The same split made disjoint gives 438,300 / 475,434 = 92.2 %.

### 2. Classification of the 37,134 gap bytes (`counts.txt`)

| Class | Bytes | Evidence standard |
| --- | --- | --- |
| code reached by flow, jump or switch from validated code | **22,569** | Confirmed: decoded edge from a validated head (`reach.tsv` src/kind) |
| code reached from a pointer (tier 2) | **2,777** | Confirmed pointer bytes; target decodes to a stop |
| code reached from a vector (INTB/EXTB) | **412** | Confirmed: 206 two-byte stubs `7f 95` RTE / `7f 96` WAIT at `FFF47E34`–`FFF47FCF` |
| typed data: `.data` initialiser images + 3 B pad | **7,388** | Confirmed: DTBL (finding 3) |
| typed data: byte switch tables | **47** | Confirmed: finding 4 |
| well-formed functions, no reference found | 3,829 | Not found (scope above): 54 runs |
| fragments (pre-function `02` bytes, `f8 04` holes, head slivers) | 72 | Unknown |
| decode conflicts (my linear decode is misaligned with IDA's items) | 40 | excluded |
| **Total** | **37,134** | |

### 3. The 7,388 B block is the CC-RX `.data` ROM image (Confirmed)

`_INITSCT`'s DTBL is at `FFED8A34`–`FFED8A58`. Its entries are triples of
{src, end, dst}:

- `64 97 ed ff 4c ab ed ff 14 85 06 00`
- `fc 8f ed ff 62 97 ed ff 70 25 01 00`
- `70 8e ed ff fb 8f ed ff 7e 21 01 00`

That gives three sections:

- `FFED8E70`–`FFED8FFB` → RAM `0x1217E` (395 B). It starts `00 00 00 01 "PLL REF"…`:
  20-byte adjustment-name records, the `PLL REF` label of doc 12.
- `FFED8FFC`–`FFED9762` → `0x12570` (1,894 B)
- `FFED9764`–`FFEDAB4C` → `0x68514` (5,096 B). It contains descriptor pointers
  `5c e5 ec ff`…, the days-per-month table `1f 1c 1f 1e…`, and IEEE double constants
  `…f0 7f`.

1 B (`ff`) and 2 B (`ff ff`) of alignment pad sit between the ranges.

The loop bounds are loaded at `FFF45DE0` `fb 42 34 8a ed ff` (`mov.l #FFED8A34,r4`) and
`FFF45DE6` `fb 52 58 8a ed ff`. The BTBL that follows (`FFED8A58`–`FFED8A70`) is loaded
at `FFF45DC0`/`FFF45DC6`. Together they cover the 7,388 B to the byte:
395 + 1 + 1,894 + 2 + 5,096.

### 4. Relative switch tables, a dispatch form IDA mostly missed (Confirmed)

The idiom is `cmp #N,Ri` … `mov.l #tbl,Rb` / `mov.{b,w} [Ri,Rb],Rx` / `bra.l Rx`, with
the target equal to the `bra.l` address plus the signed entry. For example, at
`FFF097B9`:

```text
61 81 25 05 38 0d 01   cmp #8, r1 ; bgtu ; bra.w
fb e2 d0 82 f4 ff      mov.l #FFF482D0, r14
fe 51 ee               mov.w [r1, r14], r14
7f 4e                  bra.l r14
```

The table `FFF482D0` is `02 00 17 00 2c 00 4c 00 …`, which gives targets `FFF097CB`,
`FFF097E0`, `FFF097F5`, `FFF09815`, and so on. These are exactly the 4-byte
`b8 82 b8 89` case heads that lane 4 had rejected as over-split slivers.

The scan found **40 sites and resolved all 40 (643 edges)**. IDA had resolved only 8,
and its entry counts match these on all 8 (16/12/22/10/10/10/10/10). The tables are:

- 3 byte tables in the gap at `FFF47FD1`/`FFF47FE1`/`FFF47FED`. These are the
  "post-RTE-stub" bytes `02 09 10 17…`, which tier 2 had mistaken for code
  (`t2_rejroots.tsv`).
- 36 tables inside the published string-pool region `FFF48000`–`FFF483C8`. They are
  already counted as data there and are sub-typed only.
- 1 table past the window: `FFF50960`, 63 × 2 B, from `FFF4C470`. Its bound comes from
  `FFF4C45F` `75 5e 3e` (cmp #62) and the base from `fb 12 60 09 f5 ff`.

Adding these edges lifted tier-1 code by 2,052 B of switch-reached chunks.

**Side effect (Open):** 63 tier-1 edges land in the middle of a validated instruction
(`raw\conflicts.tsv`). All are switch or jump targets, for example the cases of
`FFEEC131` landing at `FFEEC14A`, `FFEEC16E` and `FFEEC174`. Some validated bodies
(`sub_FFEEC0D3`) are therefore decoded out of phase in IDA, and their bytes sit in the
438,300 as misaligned instructions.

### 5. New code, by owner (`new-functions.tsv`, 654 units, each with a purpose)

| Unit kind | Units | Window bytes | Notes |
| --- | --- | --- | --- |
| Chunk of a validated function, reached by an IDA jump xref | 254 | 16,912 | purpose = "continuation of sub_X (entered by … from …): <existing purpose>". All 254 owners already carry a purpose. |
| Chunk reached by a switch case | 15 | 2,052 | e.g. `FFF04252`…`FFF05385` from `bra.l FFF040C7` |
| Chunk reached by fall-through from a validated head | 29 | 252 | e.g. a validated function ends at `FFF2F226` after `71 00 f0` (a frame alloc) and runs on |
| New routine reached by `bsr` from validated code | 9 | 3,344 + 9 | `FFEF42A7` (680 insns, from `FFF4525C` `05 4b f0 fa`); `FFF36469` (605 B, from `FFF3691C`); `FFEDFEB9` (334 B, from `FFEDFA82`); `FFEF5202`; `FFF23ED6`; `FFF3365E`; `FFEE97B0`; `FFF454C5`; plus a bare RTS at `FFEEA6B7` |
| New entry reached from a pointer | 141 | 2,777 | 132 from tables inside the published data regions, 7 from `mov.l #imm` in validated code (e.g. `FFEDAC8E` `fb 22 81 b0 ed ff` → `FFEDB081`), 2 from below-window tables (`FFECE514`, `FFECE50C`) |
| Interrupt stub | 206 | 412 | INTB/EXTB targets in `FFF47E34`–`FFF47FCF` (lane 3's 205 RTE stubs plus the slot-0 WAIT) |

The 9 B at `FFEDFFFD` are hand-decoded:

```text
fb e2 d4 cd 01 00   mov.l #0x1CDD4, r14
f8 e6 01            mov.l #1, [r14]
```

IDA cannot decode this pair because the first instruction crosses the segment boundary
at `0xFFEE0000`. It is reached by fall-through from `FFEDFFF9` `c5 fe 1a 16`.

**Pointer-reached patterns (Confirmed bytes):**

- **57 screen-state hooks.** For example, `FFEDE3E2` is
  `66 11 39 92 03 fb e2 4c 8c 00 00 … 02`: `mov #1,r1`, `bsr.w` handler,
  `mov.l #0x8C4C,r14` (per-screen sub-state, doc RESUME-FULL), …, `rts`. These are reached
  from the layout tables `FFED3F6C`–`FFED8A70`, for example `FFED3F6C`.
- **23 frame-alloc entry slivers.** `71 00 f0` (`add #-16,sp`) is followed directly by
  the validated body. Examples are the table at `FFED8910`
  (`e4 b8 ee ff 41 b9 ee ff 9e b9 ee ff f8 b9 ee ff` →
  `FFEEB8E4`/`FFEEB941`/`FFEEB99E`/`FFEEB9F8`) and `FFEE2284`.
- **5 bare-RTS null callbacks.** `FFEF2032` (`02`) is the target of **719 table slots**,
  starting `FFED3FF4` `32 20 ef ff 32 20 ef ff…`. The others are `FFEDF1AA`,
  `FFEF39F7` (14 slots), `FFEFB267` and `FFF332BE`.
- **Screen-family routines.** 13 units of 22–28 instructions at
  `FFEEB8E4`–`FFEEC030` each call one `sub_FFEEC5AB`/`C7E1`/`CAE0`/… draw wrapper.

**Rejected tier-2 roots (6, `t2_rejroots.tsv`):**

- `FFF508F8` and `FFF50954`–`FFF5095D` are data (finding 6).
- `FFEF9EBE` is pointed at only from 5 unaligned sites inside bitmap data at
  `FFE2xxxx`. These are coincidental byte matches, so it is not credited.

**Peripheral or USB access in the new code: none.** The only 0x0008xxxx-range
immediate is `FFEE8F85` `fb 1e 00 00 08` (`mov.l #0x80000,r1`). It is passed as an
argument to `bsr.a sub_FFEEFEEE` (`05 64 6f 00`) between reads of the RAM settings
`0x8C4D+0x6E` and `0x8E46+0x6E`, so it is a bit-mask value, not a SYSTEM register access.
**Inferred.**

### 6. Past-window block `0xFFF50000`–`0xFFF509DE` (2,526 B; kept out of the denominator)

- **Code, 2,293 B (Confirmed).** `FFF50000`–`FFF508F5` is the tail of validated
  `sub_FFF4FABD`. The function's window range ends at the window edge. Fall-through
  from `FFF4FFFE` `ef fd` continues as `ed 0f 20 af…`, and IDA's own function extends
  here (`raw\past_items.tsv`).
- **Data, 233 B (Confirmed):**
  - `FFF508F5` `ff ff ff`: 3 B pad
  - `FFF508F8`–`FFF50938`: a 64 B permutation of 0..63 that starts
    `00 01 08 10 09 02 03 0a 11 18`, i.e. the **JPEG de-zigzag** order. It is referenced
    by immediates at `FFF4B967`, `FFF4C533` and `FFF4F500`.
  - `FFF50938`–`FFF50954`: 7 × u32 `0x2D41 0x2C63 0x29CF 0x25A1 0x1924 0x1151 0x08D4`.
    These equal round(2¹⁴·cos(π/4)·cos(kπ/16)) for k = 0,1,2,3,5,6,7, i.e. **IDCT
    cosines**.
  - `FFF50954`–`FFF50960`: 12 × `01`, referenced by immediates at `FFF4FAD1`, `…DA`,
    `…E3` and `…FD`.
  - `FFF50960`–`FFF509DE`: the 63-entry switch table.

  This is the photo-viewer JPEG decoder's data, consistent with docs 30 and 38.
- **True SUB content top stays `FFF509DD`.** The next bytes are `ff`, then 0xFF erase to
  `FFFFFF7F`.

### 7. What remains unresolved (3,941 B)

- **54 function-shaped runs (3,829 B).** Most are IDA-decoded lane-4 rejects that start
  with a frame prologue `71 00 xx`. Examples: `FFF2A6D1` (299 B:
  `add #-18h,sp` … `bsr.a FFF15E96` … `rtsd #6`, then an internal `bsr.w` to
  `FFF2A70B`), `FFEDAE05` (296 B, not created in IDA), and `FFF1EB84` (284 B). A family
  of 54-byte clones (`FFF2C17D`, `FFF2C72B`, `FFF2CC9F`, `FFF2D157`, …) shares the body
  `7100eca101 05 xxxx fe a009a809 6101 210f 6602 fb16e1 05…`. No reference to any of
  them was found by:
  - an LE32 scan of the whole image at every offset
  - a 24-bit LE immediate search
  - a brute-force `04`/`05`/`38`/`39` relative-branch scan over the window
  - the resolved switch tables

  They are therefore either dead code kept by the linker, or reached by a computed
  address this pass cannot see. **Not found (scope stated).** They are not credited.
- **Fragments (72 B):**
  - 13 two-byte `f8 04` holes inside validated `FFF2xxxx`/`FFF3xxxx` bodies (decode phase
    disagreement)
  - lone `02` bytes before functions (`FFEE177F`, `FFF3758F`, `FFF375A4`)
  - head slivers (`FFF13DDA` 21 B, `FFF3B8CB` 9 B)
  - `FFEF202A` `75 41 28 05 6b c2 fe 02`, a complete 3-instruction stub with no reference
- **Conflicts (40 B):** finding 4 side effect.

### 8. Byte deltas and new companion figures

**Numerator delta: SUB window code +25,758 B** (Confirmed reachability). This is
instruction bytes in the newly reached and purposed units. Each byte lies outside the
438,300 validated set and outside every published data region, so nothing is counted
twice. It splits into:

- 19,216 B extending existing functions
- 6,542 B in new functions (9 called, 141 pointer, 206 vector)

**Typed-data delta: +7,435 B.** This is 7,388 B of `.data` images plus pad, and 47 B of
switch tables. It is disjoint from the code and from the published regions.

| Figure | Before | After |
| --- | --- | --- |
| SUB window code | 438,300 / 524,288 = 83.6 % | **464,058 / 524,288 = 88.5 %** |
| SUB typed data (disjoint from code) | 52,848 published (48,854 net of the 3,994 overlap) | **56,289 (10.7 %)** |
| SUB code / non-data | 93.0 % (overlapping denominator 471,440); 92.2 % disjoint | **464,058 / 467,999 = 99.2 %** |
| SUB code + typed | — | **520,347 / 524,288 = 99.25 %**; 3,941 B unresolved |
| Past-window (not in denominator) | — | +2,293 B code, +233 B data; window+tail code would be 466,351 / 526,814 = 88.5 % |

**Headline (definition unchanged, not applied here).** The SUB addend of the Fix-A
headline is code only. Adding +25,758 gives 931,187 + 25,758 = 956,945 / 1,029,972 =
**92.9 %**.

The +7,435 B of typed data would count only if the headline starts crediting SUB typed
data. In that case the existing 48,854 B would have to be credited too, and the
string-pool bound should first be corrected to `FFF4B059`. That moves 13 B of code
(`FFF4B077`) from data into the unresolved residue. This is the orchestrator's choice.

Two caveats, neither applied:

1. The 438,300 still includes 247 B in the 68 wave-2 rejects.
2. The finding-4 conflicts mean a few validated bodies are out of phase.

## USB relevance

None of the 25,758 B of newly proven code touches a peripheral register. The single
peripheral-range immediate is a bit-mask argument (finding 5). There are no USB0
(`0x000A0000`), ICU-USB, flash-write or DSP references either. The new code is:

- UI screen hooks and callbacks
- continuation chunks of menu, draw and IPC routines
- one large called routine at `FFEF42A7` (RAM `0x8E46`, UI state)
- interrupt RTE stubs

The data is `.data` initialisers and JPEG tables. This closes the "uncovered SUB code"
caveat for this window: the settled negatives (USB0 dark, no SUB-side SDR or DSP path)
now rest on 99.25 % of the window being code or typed data, not 91 %. **Confirmed**
within the window; nothing here reopens any of the three mission answers.

## Open

1. Apply the 25,758 B in a DB: create the 9 called routines and the 141 pointer entries,
   and attach the 298 chunks to their owners using `units.tsv`. Then emit the 643 switch
   edges as xrefs (reuse `switch_edges.tsv`) so that future re-analysis keeps them.
2. Re-seat the phase-conflicted validated bodies, starting with `sub_FFEEC0D3`'s case
   block `FFEEC133`–`FFEEC184` (63 edges in `raw\conflicts.tsv`), and recount the
   numerator.
3. Look for the callers of the 54 unreferenced `71 00`-prologue functions (3,829 B). The
   54-byte clone family suggests a table indexed through a RAM copy, so check pointer
   values that `_INITSCT` copies to RAM and then modifies, and `jsr` sites with a
   register loaded from the `.data` region at `0x68514`+.
4. Correct the published string-pool region to `FFF48000`–`FFF4B059`, and sub-type its
   first 0x3C8 B as 36 switch tables (`typed-data.tsv` rows marked `published-data`).
5. Decide whether SUB typed data enters the headline numerator. If it does, credit the
   48,854 B net and the +7,435 B together, never the overlapping 52,848.
