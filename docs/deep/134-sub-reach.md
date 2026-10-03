# SUB strict reach without the stale lane-4 xref roots (Lane N7)

Owner-side static analysis of `decrypted\FT3D_SUB_ver102_ALL.bin` (RX64M, little-endian, mapped at `0xFFC00000`,
file offset = address − `0xFFC00000`). Image bytes only: this lane opened **no** database. The scanner reads the 4 MB
image directly and reuses M15's relative-branch decoder (cross-checked against IDA with 0 mismatches, doc 127). M15's
`codeheads.tsv` is consulted only to decide whether a branch *source* is a real instruction head. No image or mask byte
was changed (sha256 MAIN `8e3ecd05409b2c31…`, SUB `b93570b3c2f69ccb…`, both re-hashed at the start and end of the run by
`n7_reach.py`), and nothing was written to a radio or any device. Model: claude-opus-5-5.

Tables are in `ida\out\sub-reach\`:

| File | Contents |
| --- | --- |
| `roots.tsv` | The two stale lane-4 `xref` roots `FFF2570F` / `FFF38800`, their parent dead functions, the only inbound edges that exist, and the count of inbound edges from outside each parent function (0 / 0) |
| `proposed-reach.tsv` | The three reach_w2 ranges (120 B), the per-range result of all five edge scans, and the proposal |
| `n7_reach.py` | The scanner (read-only; hash-checks both images) |
| `raw\reach_log.txt` | Full run log: every branch-byte hit with its disposition, the absolute/vector/switch/xref scans, and the verdict |

## Verdict

**Confirmed. The strict SUB reach figure is 457,342.** The 120 B that the published reach-only companion 457,462
contains above the strict figure have **no real inbound edge of any kind anywhere in the 4 MB image**. They are the
internal continuations of two Confirmed-dead functions, and they entered lane-4's reach closure only because lane 4
seeded their addresses `FFF2570F` and `FFF38800` directly as `xref` roots (`sub-window\functions.tsv`,
`sub-final2\ambiguous.tsv`). I searched every RX inbound-edge form that does not use such a root — `bsr`/`bra` direct
calls and PC-relative branches at every byte offset, absolute LE32 pointers / `MOV.L #imm32` / indirect-via-memory
targets, the 256 INTB and 32 EXTB relocatable vector slots, IDA's computed switch cases, and IDA xrefs — and found
**zero**. Both parent dead functions also have **zero** inbound edges from outside themselves, so there is no transitive
route either. **The 120 B are Not found for a live edge, scope: the whole 4 MB image, all of the edge forms listed
above.** This does not change the named headline: the 120 B remain inside `headline_w2` as credited-unreached code; only
the strict *reach* companion drops from 457,462 to 457,342 (= 457,462 − 120).

## Method

The 120 B are three half-open ranges inside two dead functions (bytes byte-checked against the image):

| Range | Address | File | Bytes | Parent dead function | First bytes |
| --- | --- | --- | --- | --- | --- |
| R1 | `FFF2570F`–`FFF25771` | `32570F` | 98 | `dead_FFF256BD` (`FFF256BD`–`FFF25771`, 180 B) | `fb e2 2c 5e 06 00 ec ee` |
| R2a | `FFF38800`–`FFF3880B` | `338800` | 11 | `dead_FFF387C9` (`FFF387C9`–`FFF3887C`, 179 B) | `fb e2 be 2c 01 00 f8 e5` |
| R2b | `FFF38871`–`FFF3887C` | `338871` | 11 | `dead_FFF387C9` | `3d 03 00 d5 00 03 05 b9` |

98 + 11 + 11 = **120**. Both parents are the whole dead functions `dead_FFF256BD` and `dead_FFF387C9`
(`sub-final3\dead.tsv`, each with `inbound_edges_now = 0`). The byte before each parent is a stop — `FFF256BB 67 05`
(`rtsd`) and `FFF387C7 67 01` (`rtsd`) — so neither is entered by fall-through. Within each parent, the reach_w2 bytes
are reached only by jumps whose source is *inside the same dead function* (`ambiguous.tsv`:
`jump FFF25700->FFF2570F`; `jumps FFF387F8->FFF38800`, `FFF387DB->FFF3880B`, `FFF387EB/FFF387FE->FFF38874`).

`n7_reach.py` scans the image for an inbound edge to (a) each of the 120 B, and (b) every byte of either whole parent
function (a live edge into the parent would reach the 120 B transitively through the internal jumps). Five independent
scans, none of which uses a lane-4 root:

- **A — PC-relative branches/calls at every byte offset.** `bra.s`/`beq.s`/`bne.s`, `bra.b`/`bcnd.b`,
  `bra.w`/`bsr.w`/`beq.w`/`bne.w`, `bra.a`/`bsr.a`, decoded with M15's validated decoder. A hit is classed INTERNAL if
  its source lies in the same dead function, EXTERNAL otherwise, and separately as a real DB instruction head or a byte
  coincidence.
- **B — absolute address references at every byte offset.** 4-byte LE value equal to any target address. This covers
  LE32 pointer tables at any alignment, `MOV.L #imm32` absolutes, the RX switch `bra.l`/`jsr Rn` absolute jump tables,
  and any `jsr`/`jmp Rn` whose register is loaded from a memory pointer (M15: 317 of 319 `jsr Rn` load from memory, 2
  load the constant 0). RX `imm24` sign-extends `0xFFxxxx`→`0xFFFFxxxx`, which can never equal `0xFFF2xxxx`/`0xFFF3xxxx`,
  so the 32-bit scan is the complete immediate/pointer test.
- **C — relocatable vectors.** All 256 INTB (`0xFFED8A70`) + 32 EXTB (`0xFFFFFF80`) slots. The two `mvtc` loads were
  re-confirmed at `FFC00017`/`FFC0000E`.
- **D — IDA computed switch cases** (M15 `switches.tsv all_targets`).
- **E — IDA xrefs** (M15 `xrefs.tsv`), corroboration.

Hashes were asserted at start and re-asserted at finish; both images unchanged.

**Not done / scope limits.** This lane tested the 120 B and their two parent functions only — the set M15 flagged. A
full re-run of the whole reach closure to find *any other* stale `xref` root outside the 125 dead functions is M15's
open item #2 and is beyond this lane (see Open). I did not run a fresh non-branch instruction decoder; the instruction
boundaries come from M15's K7 export, and scans B–E are boundary-independent.

## Findings

### 1. No live inbound edge to the 120 B (Confirmed; `proposed-reach.tsv`, `raw\reach_log.txt`)

| Scan | Scope | Edges into the 120 B from outside the parent function |
| --- | --- | --- |
| A relative branch (every offset) | 4,194,304 B | **0** real-instruction edges (24 + 4 + 7 = 35 hits, all INTERNAL same-function jumps; 8 EXTERNAL hits all byte coincidences, below) |
| B absolute LE32 / imm32 / pointer / indirect-via-memory | every offset, all 120 addrs + 2 roots + 4 entries + both whole parents | **0** |
| C INTB 256 + EXTB 32 vector slots | 288 slots | **0** |
| D IDA computed switch cases | all cases | **0** |
| E IDA xrefs | M15 export | **0** |

The internal jumps that *do* land in the 120 B are all real instructions inside the dead parent and confirm the
"continuation" structure, e.g. `FFF387F8 beq.s FFF38800` (into R2a), `FFF38809 bra.b FFF38871` and
`FFF387EB bra.w FFF38874` / `FFF387FE bra.b FFF38874` (into R2b). Each has a source inside `dead_FFF387C9`, which itself
has no way in.

**The 8 EXTERNAL branch-byte hits are all byte coincidences, not instructions** (verified against the DB item map):

| Source | Decodes as | Lands in | Disposition |
| --- | --- | --- | --- |
| `FFC23EF1` | `bra.a FFF25731` | R1 | byte `04` inside RGB565 bitmap data, file `023EF1`, far below the first code head `FFEDAB4C` — no code in `0xFFC00000`–`0xFFED0000` |
| `FFF256B6` | `bra.s FFF256BF` | `dead_FFF256BD` | interior (+1) of code head `FFF256B5` `mov.l r1,…[sp]` |
| `FFF256B8` | `bra.s FFF256C1` | `dead_FFF256BD` | interior (+1) of code head `FFF256B7` `mov.l …[sp],r1` |
| `FFF2B5DF` | `bsr.w FFF256DE` | `dead_FFF256BD` | interior (+2) of code head `FFF2B5DD` `bsr.a sub_FFF1EFAC` |
| `FFF387A9` | `bcnd.b FFF38805` | R2a | interior (+1) of code head `FFF387A8` `mov.l #sub_FFF3945C,r2` |
| `FFF387C6` | `bra.s FFF387CF` | `dead_FFF387C9` | interior (+1) of code head `FFF387C5` `movu.w …[sp],r1` |

Each EXTERNAL source is either inside the encoding of another, longer instruction or inside non-code bitmap data, so
none can be the start of an executed branch. This is the same false-positive class M15 reported ("21 patterns, 0 at an
instruction head"), here reproduced for these specific targets.

### 2. The two roots are stale (Confirmed; `roots.tsv`)

| Root | Parent (extent) | reach_w2 bytes | Lane-4 type | Inbound edges from outside the parent |
| --- | --- | --- | --- | --- |
| `FFF2570F` | `dead_FFF256BD` (`FFF256BD`–`FFF25771`) | 98 (`FFF2570F`–`FFF25771`) | `xref` | **0** |
| `FFF38800` | `dead_FFF387C9` (`FFF387C9`–`FFF3887C`) | 22 (`FFF38800`–`FFF3880B`, `FFF38871`–`FFF3887C`) | **0** |

`functions.tsv` records the parent chunks `FFF256BD`→`FFF2570F` and `FFF387C9`→`FFF38800` as `rejected`/`no` (dead), and
the continuations `FFF2570F`→`FFF25771` and `FFF38800`→`FFF3887C` as `xref`/`yes`. The `xref` validation is the only
reason they count as reached; `ambiguous.tsv` already labels both "the continuation was reachable only as a lane-4
'xref' root". My scans show the `xref` had no real referrer: nothing outside either dead function reaches the root
address or any byte of the parent.

### 3. The strict figure (Confirmed)

Published reach-only companion (M15, `reach_w2` mask) = **457,462**. Minus the 120 B with no live edge = **457,342**
(87.2311 % of the 524,288 B window). This equals M15's figure and the RESUME-FULL correction to docs 68/89. The named
headline is unaffected: the 120 B stay in `headline_w2` (464,263) as credited-unreached code; `allwf` (467,999) and the
code+typed named figures (520,552 / 524,288) are unchanged.

**Proposal (`proposed-reach.tsv`):** keep all 120 B as **credited-unreached, not proven-reached**. Drop them from the
strict reach companion. Zero bytes are proposed as newly reached (a valid zero delta). No mask or seed edit: the strict
companion is a counting convention over the existing `reach_w2` mask, and the headline/named masks do not move.

## USB relevance

None of the three mission answers changes. All 120 B are dead UI/screen-handler code in the window's upper band (the
`fb e2 2c 5e 06 00` / `fb e2 be 2c 01 00` `MOV.L #imm,r` + `bsr` clone family), with no peripheral immediate in
`0x80000`–`0x100000` (USB0/USBA/SYSTEM/MSTPCR) or the FCU/flash block, consistent with doc 127 §USB and K7's
`usb-scan.tsv`. SUB's USB surface stays dark; this lane only refines the SUB *reach* denominator by 120 B.

## Open

Most valuable first.

1. **Full reach re-closure over all `xref` roots (M15 open #2).** This lane proved the two roots inside the 125 dead
   functions are stale. Whether any *other* stale `xref` root — outside the dead-function set — inflates `reach_w2`
   remains untested. The clean test is a from-scratch reach closure seeded only by proven entry points (reset, the 288
   decoded vectors, and real direct/indirect/table edges), with `xref` roots excluded, then compare its byte count to
   457,342.
2. **Adopt the strict pair in the published ledger.** Pair MAIN proven with SUB strict reach 457,342 for the "proven"
   headline row; the MAIN side (364,786 final6 vs 365,358 final7) is the orchestrator's to pin. This lane changes only
   the SUB term and only in the reach row.
3. **The live `jsr` to address 0** (`FFEE2220` / `FFEE223B`, doc 127 open #3) is unrelated to these 120 B but is the
   remaining genuine reach question on SUB.
