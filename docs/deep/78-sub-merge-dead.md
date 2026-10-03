# SUB: the 156 dead / unreached functions — merge, dead, or reached (Lane J10)

Owner-side static analysis of `decrypted\FT3D_SUB_ver102_ALL.bin` (RX64M, little-endian,
mapped at `0xFFC00000`; file offset = address − `0xFFC00000`; sha256 prefix `b93570b3…`,
4,194,304 B, unchanged). Private DB `J10_SUBMERGE`, seeded `--copy-from
ida\db\jobs\SUB_FINAL2\SUB_FINAL2.i64`. No shared DB was opened, no image byte was modified,
nothing was written to a radio or any device. Every script is read-only on the DB. Model:
claude-opus-4-8.

Tables in `ida\out\sub-merge\`:
- `disposition.tsv` — per-function verdict for all 156 (start, end, size, prior reach, disposition, root, root reach, edge kinds, fall-through flag, edges, calls, refusals).
- `chains.tsv` — the 156 grouped by resolved root (the merge groups).
- `dead-scan.tsv` — I10's whole-image reproduction per entry (LE prefix hits, pointer-like hits, vector membership).
- `peripheral.tsv` — every peripheral-range operand in all 156 function bodies (12 rows).
- `raw\dis.txt` — cited disassembly. `raw\status.txt` — run log.

## Verdict

The residue list is **156 functions, not ~155** (SUB_FINAL2 `functions.tsv`: 89
credited-unreached + 67 dead; the prose "155" dropped one). Applying I17's continuation-merge
rule to all 156 resolves every one with **zero ambiguity, zero refusals, and zero net change
to the 464,263 headline**:

- **(a) merge into an owner — 31 functions (2,279 B).** 30 are proven continuations entered by
  fall-through, branch, or both (`flow` 20, `flow+jump` 7, `jump` 3); 1 (`FFF2A70B`) is reached
  only by a `bsr` from a dead caller. Of the 31, **19 (824 B) merge into a credited-unreached
  owner and 12 (1,455 B) into a dead owner** — every owner stays in the reach class it already
  had, so no byte is promoted.
- **(b) genuinely dead — 125 functions (7,780 B).** Each is a chain head with **no** fall-through,
  branch, switch, call, data, pointer, immediate, or vector reference into its entry anywhere in
  the 4 MB image. Reproducing I10's method on all 156 entries: **0 LE32-pointer / 0 RX-imm24 /
  0 `o_imm` hits, and membership in 0 of the 288 INTB+EXTB vector slots — for every one of the
  156.** 66 of the 125 heads were already "dead"; **59 were "credited-unreached"** and are shown
  here to be dead.
- **(c) reachable by a missed root — 0 functions.** No dead or unreached function is entered by
  any live code. The prior passes missed nothing.

**Net change to the SUB window code count: +0 B. The headline stays 464,263.** 0 functions
became reachable, so nothing is added; merges and the cu→dead reclassification move function
ownership and labels, not bytes, and the headline is a fixed byte-mask (I17). **None of the 156
touches USB0, USBA, or the FCU/flash programming block** — restated with scope below. This
confirms and tightens I10 (its 52 dead-app orphans are all here and all still dead) and I17
(its 2 flagged-dead owners and the predecessors of its 4 ambiguous kept-cases are all here).

## Method

Universe U = SUB_FINAL2 `functions.tsv` rows with `reach ∈ {dead, credited-unreached}` = 156.
The merge rule is I17's `i17_plan.py`, re-run over U instead of over I2's 1,666 reachable
candidates (`ida\jobs\j10_merge.py`, read-only, `auto_wait`, `qexit(0)`, UTF-8, try/except →
`raw\status.txt`). For each C with chunk set K(C), every edge from outside K(C) into a head of
K(C) was collected from the DB:

- **flow** — the head before a chunk start is code outside K(C), not a `CF_STOP` (no
  rts/rtsd/bra/jmp), and ends exactly at the start.
- **jump** — a code xref `fl_JF`/`fl_JN` into a head of K(C).
- **switch** — an H8 switch edge (`sub-gap\raw\switch_edges.tsv`) or an IDA switch-table xref.
- **call** — `fl_CF`/`fl_CN`; recorded, and folded into root resolution so a function reached
  only from a dead caller collapses into that caller.
- **refuse** — a data xref, an INTB/EXTB vector slot equal to a head, an `o_imm` anywhere in the
  DB equal to the entry, or the entry's LE32/LE24 value stored at a non-code image offset.

Roots were resolved by least-fixpoint over U (I17's algorithm). A root is a function **not** in U
(⇒ the chain is live), a U-function with no external edge (⇒ a dead chain head), or a refused C.
Disposition: `reached-by` if the resolved root is a live (non-U) function; `merge-into` if it is a
dead/cu U chain head; `dead` if C has no external edge at all.

**I10 reproduction.** For every one of the 156 entries I scanned the whole 4,194,304-byte image
for its 3-byte LE prefix at every offset (covers both LE32 pointers and the RX sign-extended
`fb ?e` imm24), classified each hit (atlas-pixels / code-imm / inside-code-bytes / data), recorded
pointer-like hits, scanned every `o_imm` in the DB, and decoded all 256 INTB + 32 EXTB vectors for
membership. **Peripheral scan:** every `o_imm`/`o_displ`(op.value)/`o_mem`/`o_near` operand of
every instruction in every U function was tested against USB0 `0xA0000`–`0xA0400`, USBA
`0xD0000`–`0xD0200`, FCU/flash `0x7E0000`–`0x800000`, the SCI0 IPC RAM block `0x12D00`–`0x12E00`,
and the whole peripheral window `0x80000`–`0x100000`.

**Not done.** No DB edit, no instruction/function creation or deletion — this is a frozen plan,
like I17's `i17_plan.py` (the apply step, if ever wanted, is mechanical and byte-neutral). Function
purposes beyond the reach classification were not assigned.

## Findings

### 1. The 31 merges (Confirmed; `disposition.tsv`, `chains.tsv`, `raw\dis.txt`)

| Edge evidence at the continuation | Merges |
| --- | --- |
| flow (fall-through) only | 20 |
| flow + jump | 7 |
| jump only | 3 |
| call-only, from a dead caller | 1 |
| **total** | **31** |

Cited proofs (bytes in `raw\dis.txt`):

- **`FFF13DDA`→`FFF13DEF`→`FFF13EEA` (flow, root dead `FFF13DDA`).** `FFF13DDA` ends at
  `FFF13DEC 3e 01 00` mov.l #0,… — not a stop — into `FFF13DEF`. `FFF13DEF` ends at
  `FFF13EE8 2a 19` bgt.b `FFF13F01`, a conditional branch that falls through into `FFF13EEA`.
  `FFF13EEA` ends at `FFF13EFF 2e 17` bra.b `FFF13F16`. So the three are one dead routine, owner
  `FFF13DDA`. **This resolves I17 Open 1's example.** The fourth member of I17's chain,
  `FFF13F01`, is **not** in U — it is I17's reachable "ambiguous" kept-case, a shared tail entered
  by the `bgt` from `FFF13DEF`; it correctly stays its own function. No double-count.
- **`FFF12437` + 9 (flow, owner credited-unreached).** `FFF12437`,`…1244A`,`…1246C`,`…1248B`,
  `…124AB`,`…124CB`,`…124E9`,`…12508`,`…12528`,`…1254B` are a run of adjacent `sub #8,sp` /
  `mov.w` prologues that each fall through into the next — one function lane-4 split into ten.
- **`FFF3753A` + 8 (flow, owner credited-unreached).** Nine 7–11-byte register-poke stubs that
  fall through in sequence (see §4). One routine.
- **`FFEF0609`→`FFEF05DD` (jump, root dead).** `FFEF05DD` ends `FFEF05E9 2e 53` bra.b `FFEF063C`,
  which lands inside `FFEF0609`'s loop body; the two are one nested-loop function.
- **`FFF2A70B`→`FFF2A6D1` (call-only, root dead).** `FFF2A6D1` (a screen-handler-family orphan,
  one of I10's 52) calls `FFF2A70B` by `FFF2A6F7 39 14 00` bsr.w. `FFF2A70B` has that single call
  xref (its `call1` in `functions.tsv`) and no other reference; its only caller is dead, so it is
  dead. This is the single prev-dead function that is not its own head.

The merge owners by reach class: **19 merges (824 B) into credited-unreached owners**
(`FFF12437`, `FFF3753A`, `FFF1E789`, `FFF3887C`), **12 merges (1,455 B) into dead owners**. No
owner changes reach class, so the merges are byte-neutral on both the headline and the residue.

### 2. The 125 dead heads (Confirmed; `dead-scan.tsv`)

125 functions (7,780 B) are chain heads with no external entry edge of any kind. The whole-image
reproduction of I10's scan, run over all 156 entries, returns for **every** entry:

- **0** LE32-pointer hits and **0** RX-imm24 hits (pointer-like column = 0 for all 156),
- **0** `o_imm` operands anywhere in the DB equal to the entry,
- **0** of 288 INTB+EXTB vector slots equal to the entry.

So no code address for any of the 156 exists anywhere in the image — exactly I10's result for its
52 orphans, now extended to all 156. Of the 125 heads, 66 were already classed "dead" and **59
were classed "credited-unreached"** yet are dead chain-heads. They are dead application UI code the
CC-RX linker retained (Inferred — a general CC-RX property, as in I10/H10). **Not found** (scope:
every byte offset of all 4,194,304 bytes, every `o_imm` in the DB, all 288 vectors, the 643 switch
edges and all flow/branch predecessors). **Truly unknown: 0 B.**

### 3. Reconciliation — no double-count (Confirmed)

- **I10's 52 dead-app orphans** are all in U and all land as `dead`. I10's 2 recovered orphans
  (`FFF3627B`, `FFF40314`) are correctly **outside** U (now reachable functions), so they are not
  re-touched.
- **I17's 2 flagged-dead owners** `FFF256BD` and `FFF387C9` are in U as `dead` heads (their
  continuations `FFF2570F`/`FFF38800` were merged by I17 and are no longer functions, so they are
  absent — correct).
- **I17's 4 ambiguous kept-cases** `FFF13F01`, `FFF46265`, `FFF47B5F`, `FFF47CF3` are reachable and
  **not** in U. Their U-side predecessors `FFF13EEA` and `FFF47B43` are handled here without
  touching the kept-cases.
- **Correction to the count:** the residue is **156 functions (10,059 B: 89 cu = 5,321 B +
  67 dead = 4,738 B)**, not 155. `FFF2A70B` (372 B), which I17 classed dead with a `call1`, is
  shown here to be dead specifically because its only caller `FFF2A6D1` is dead — a concrete
  instance of I17's flagged-dead principle that I10 did not enumerate (it is not a bare `71 00`
  orphan).

### 4. Peripheral operands in the 156 (Confirmed; `peripheral.tsv`)

12 peripheral-range immediates appear across all 156 function bodies. **0 are in USB0
(`0xA0000`–`0xA0400`), 0 in USBA (`0xD0000`–`0xD0200`), 0 in the FCU/flash block
(`0x7E0000`–`0x800000`).** The 12 are:

- **`FFEDC455` (credited-unreached) → `0x12D44` ×3.** It clears three longwords at the **SCI0 IPC
  RAM control block** sibling (`0x12D44`, the block H10 identified; e.g. `FFEDC459 fb e2 44 2d 01 00`
  mov.l #12D44h,r14 then `fa e5 7c 4f 00` mov.w #0,9EF8h[r14]) and tail-calls `sub_FFEDD355` with
  id `#-1Eh`. This is an **IPC-RAM** reference, not a touch of the SCI hardware registers, and the
  function is dead — it never executes.
- **`FFF3753A`-family (credited-unreached, the 9-stub routine of §1) → SYSTEM/DMAC/PORT.**
  `#0x83812` (mov.w #0 — a DMAC/system-area register), `#0x8C100` (`f0 e1` bset #1,[r14].b — an I/O
  PORT register), and `#0x80004` with `mov.w #0xA503,3FAh[r14]` = a write of key `0xA503` to
  **`0x803FE` PRCR**, the register-protect unlock. This is a dead low-level clock/port/DMAC
  init stub. None of its targets is USB, flash, or SCI.

So the only peripheral-adjacent references in the entire 156 are one dead function's writes to the
SCI0 **IPC RAM block** and one dead init stub's writes to **SYSTEM (PRCR)/DMAC/PORT** registers.
Neither reaches USB0, USBA, or the FCU/flash controller.

## USB relevance

None of the three mission answers changes.

- **USB.** **Not found** (scope: every `o_imm`/`o_displ`/`o_mem`/`o_near` operand of every
  instruction in all 156 dead/unreached SUB functions, plus the whole-image code-address scan):
  no reference to USB0 `0xA0000`–`0xA0400` or USBA `0xD0000`–`0xD0200`. The SUB-USB-dark result is
  unaffected — the residue carries no hidden USB surface.
- **Flash.** **Not found** (same scope): no reference to the FCU/flash programming block
  `0x7E0000`–`0x800000`. No self-flash path hides in the dead code.
- **IPC.** The MAIN↔SUB SCI0 path is touched only in RAM, by one dead function (`FFEDC455`),
  which clears the IPC state block and never runs. The live IPC handlers are unchanged.
- **SDR / DSP.** The 156 are dead UI/screen handlers, `atoi`/`strtol`-family helpers, nested-loop
  table walkers, and a dead register-init stub. No sample source, transport, USB engine, or DSP
  framing. The SUB side still contributes nothing to USB SDR or direct DSP access.

The settled SUB negatives now rest on a DB in which the residue is not merely "unexplored" but
classified function-by-function: every one of the 156 is either a byte-neutral continuation of a
known routine or a confirmed-dead head with zero inbound references anywhere in 4 MB.

## Open

1. **Reachability-standard bracket (informational, not a headline change).** This pass proves that
   all 89 "credited-unreached" functions are unreachable: 59 are dead heads (3,414 B) and 30 are
   continuations of dead/cu routines (824 B into cu owners, the rest into dead owners). Under a
   strict reachability standard the headline would drop by their bytes; under the carried-forward
   H8/H10 standard it stays **464,263**. This is a cleaner, function-level version of H10's 9,527 B
   honesty bracket — do not mix the two standards.
2. **Optional apply.** A byte-neutral apply job (merge the 31 continuations into their owners, add
   the repeatable comment `J10: was sub_X`, leave the 125 dead heads as functions) would give the
   seed clean bounds for the dead code, exactly as I17 did for the 1,662. It changes 0 bytes.
3. **Function purposes.** The 24-member screen-handler clone family and the `FFF12437`/`FFF3753A`
   split routines could be named, but they are dead; low priority.

## Files (`ida\out\sub-merge\`)

| Path | Contents |
| --- | --- |
| `disposition.tsv` | All 156: start, end, size, prior reach, disposition (reached-by/merge-into/dead), root, root reach, edge kinds, entry fall-through, edges, calls, refusals. |
| `chains.tsv` | The 156 grouped by resolved root — the merge groups. |
| `dead-scan.tsv` | Per-entry I10 reproduction: LE-prefix hits, pointer-like hits, vector membership. All 156 are 0/0/none. |
| `peripheral.tsv` | The 12 peripheral-range operands across all 156 bodies, with region. |
| `raw\dis.txt` | Cited disassembly (the merge proofs and the two peripheral functions). |
| `raw\status.txt` | Run log with the byte ledger. |
