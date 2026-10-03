# 114 — proven-but-unreached runs below 0x030000 (Lane M2)

> Lane M2, model `claude-opus-5-5`. Owner-side, read-only static analysis of
> `decrypted\FT3D_MAIN_ver102_EXP.bin` (H8SX, big-endian, base 0, file offset = address). No image byte was
> modified, no mask or seed was edited, nothing was connected to or written to a radio. Image sha256
> `8e3ecd05409b2c31…` (checked in `offline\m2_verify.py`). Tables: `ida\out\punr-lo\`. Reached set is H9's full
> folded descent (`descent.pkl` `full/reached`, the exact descent the input list is measured against).

## Verdict

The 29 proven-but-unreached runs below `0x030000` (368 B) carry **no live code and no USB/SCI/DMAC surface**.
All 29 are proven only by the **A addend** of `analyze.py` — they lie inside a `validated = yes` fnindex function body
that is `is_code` in `items_before` (masks.py lines 27–32) — and none is credited by RC, D or G1A. The full folded
descent does not reach them because, inside those otherwise-reached functions, each run is an **unreachable fragment**:
- **28 runs (360 B) are DEAD.** 26 are dead arms placed immediately after an unconditional `bra` that jumps over
  them; 1 (`0x0076D8`) is a stub after an `rts`; 2 (`0x006A0E`, `0x0077FA`) are interior pieces of a larger
  bra-skipped arm. Every one has **zero inbound code edges whole-image** — no reached-head branch/call/jmp,
  no fall-through, no switch/jump-table target, no BE32/BE24/BE16/@@aa:8 pointer to its start, and no address-of
  immediate in reached code.
- **1 run (8 B) is DATA-MISTYPED** (`0x00932A`): reached code at `0x00929E` reads it as an indexed byte table.

**Zero runs are REACHED, SPLIT-TAIL, or UNCERTAIN**, so **no new descent rule is proposed** — nothing in this scope
would be reached by adding one (doc 99's er1-callback rule and L4's abs24 rule reach none of these). Proposed
demotion: all **29 runs / 368 B** from the MAIN proven mask (`proposed-demotions.tsv`); the one DATA-MISTYPED run
should additionally be retyped as data. Proposals only; no mask or seed was rewritten.

## Method

1. **Proving rule per run.** `offline\m2_emit.py` imports H9's `masks.py` and tests each run against the A/RC/D/G1A
   addend masks. All 29 are A-only (fnindex body ∩ `items_before` is_code, minus FNC corrections). Confirmed.
2. **Confirm unreached.** `offline\m2_refs.py` loads `descent.pkl` `full/reached` and asserts no byte of any run is
   a reached instruction head or owned by one (`any-reached: 0` for all 29). This reproduces the input list's
   "not reached by K1's full folded descent".
3. **Whole-image inbound scan** (`offline\m2_refs.py` → `inbound-scan.txt`), reusing L2's index machinery
   (`ida\out\fnindex-lo\offline\l2_refs.py`): BE32 at every byte offset of the 1 MB image (plus a 24-bit-masked
   variant in the `0x0`–`0x3FF` vector page), every operand constant in the binutils H8SX oracle decode at every
   even address `0`–`0x7B754` (abs24 `jsr`/`jmp`, 8/16-bit `bra`/`bsr`/`Bcc`, `mov.l #imm`, `@(d,ERn)`), BE16 for
   run starts `< 0x8000`, and the decode that ends exactly at the run start (fall-through). Every hit is tagged
   reached-head / reached-mid / proven-unreached / named / untyped / window.
4. **Flow vs data edges** (`offline\m2_classify.py`). From every reached instruction *head* (`full/reached`) I
   computed its direct flow targets (`common.flow`) and its fall-through, and separately its non-branch operand
   constants, and recorded any that land in a run. Only reached-**head** sources count; "reached-mid" hits are
   spurious decodes starting inside a reached instruction and are discarded.
5. **Indirect edges to run starts** (`offline\m2_indirect.py`): the full switch/jump-table target lists
   (`ida\out\main-full\jumptables.tsv`, `switch_tables.tsv`), BE32/BE16 pointers to each run start, the
   `0x0`–`0x3FF` `@@aa:8` vector page (covered by the BE32 scan), and RAM-cell callbacks (an address-of immediate
   in reached code, covered by step 4's data-edge scan).
6. **USB relevance.** A linear decode of every run was scanned for operands in `0xFFEE00`–`0xFFEE53` (USB),
   `0xFFF610`, `0xFFFF60`–`0xFFFF9F` (SCI incl. DSP SCI-C `0xFFFF88`) and the DMAC blocks: **0 hits**.
7. **Citations.** `offline\m2_verify.py` byte-checks all 13 addresses cited below against the image (13/13 OK).

Not done: runs ≥ `0x030000` (other M-lane scope) and the closed window `0x078106`–`0x07B753` (no run below
`0x030000` lies in it). Arbitrary 16-bit offset tables with unknown bases were not searched (same scope limit as
doc 99 §Open-5); the known bases were covered by the whole-image operand scan.

## Findings

### 1. All 29 are A-addend-only (the proving rule)

Every run byte is set in A = `(validated fnindex function body) ∩ (items_before is_code)` minus FNC corrections.
None is in RC (recovered-code runs), D (F1 proved-corrected rows) or G1A (tier-A absorb). So the descent's failure
to reach them is the *only* thing separating "proven" from "reached" here: the function enclosing each run is real
and mostly reached, but the run itself is an unreachable fragment of that function's extent. This is why they sit in
the proven mask yet never appear in the descent — they are not a separate class from doc 99's fnindex runs so much
as the same compiler artefact one step further out (not reached even with the fnindex seeds in).

### 2. DEAD — 28 runs, 360 B (Confirmed: 0 inbound code edges whole-image)

The overwhelming pattern (26 of 28) is a **dead arm after an unconditional `bra`**: the reached instruction ending
at the run start is a `bra` whose target is at or past the run end, so control skips the run; nothing branches into
it. Representative, byte-checked:

- `0x0049D4`–`0x0049F0` (28 B): pred `0x0049D2 40 62 bra .+98 (0x4A36)`; after `0x0049F0` is a reached head.
- `0x0167EA`–`0x0167EE` (4 B) `5E 03 FF A0 = jsr @0x03FFA0`: pred `0x0167E8 40 04 bra .+4 (0x167EE)` skips the
  `jsr`. Seven runs are this exact "else → `jsr 0x3FFA0`" menu-callback landing arm bypassed by a `bra`
  (`0x0167EA`, `0x0180B2`, `0x0188F0`, `0x01895C`, `0x01A044`, `0x01CF46`, `0x02A730`) — doc 99 §1's pattern, here
  on the skipped side.
- `0x019EA0`–`0x019EAE` (14 B) `7A 01 00 FF AD 8A 7A 06 00 01 A1 BC 40 00 = mov.l #0xFFAD8A,er1 ; mov.l
  #0x1A1BC,er6 ; bra` — a second er1-callback *registration* arm skipped by pred `0x019E9E 40 0E bra .+14`. Even
  with doc 99's er1-helper rule this never executes: the `bra` before it removes it.
- `0x0076D8`–`0x0076E0` (8 B) `8B 0B 5E 00 CF C2 54 70 = …; jsr @0x00CFC2 ; rts`: a stub after reached
  `rts 0x0076D6`. **doc-99 companion**; it is the only inbound to doc-99's DEAD run `0x00CFC2`, and is itself
  dead. Confirmed.
- `0x01C27E`–`0x01C294` (22 B) contains `5E 01 C4 D2 = jsr @0x01C4D2`: dead arm after pred `0x01C27C 40 1A
  bra .+26`. **doc-99 companion**; the only inbound to doc-99's DEAD run `0x01C4D2`. Confirmed.
- `0x006A0E`/`0x0077FA`: no instruction decodes cleanly to the run start; each sits inside a larger span skipped by
  a reached `bra` (`0x006A06 bra→0x6A1A` covers `0x006A08`–`0x006A1A`; `0x0077CC bra→0x7804` covers
  `0x0077CE`–`0x7804`). DEAD.

For every DEAD run the switch/jump-table lists produce **no** target, and there is **no** BE32/BE24/BE16/`@@aa:8`
pointer to the run start anywhere in the 1 MB image. The only pointer-shaped hits are BE16 *values* equal to
`0x6A08`/`0x6A0E` for the two sub-`0x10000` runs — all in data regions (`0x076xxx` service-window tables, `0x001xxx`,
`0x035xxx`), none behind a `jmp`/`jsr` opcode, i.e. data collisions, not code entries.

### 3. DATA-MISTYPED — 1 run, 8 B (Confirmed by the reader)

`0x00932A`–`0x009332` = `05 04 02 03 04 04 04 00`, the head of a byte lookup table. Reached code:
`0x009298 7A 64 00 00 00 FF and.l #0xFF,er4` then `0x00929E 78 40 6A 2B 00 00 93 2C
mov.b @(0x932C:32,er4),r3l` — an index (0..0xFF) into the table at `0x932C`. The fnindex put a function start on the
table (two bytes ahead of the base the code uses). Same `78 40 6A 2B …` indexed-byte-load form as doc 99 §4's
`0x016642`/`0x024000`. It should be retyped as data; it is not code.

### 4. Ledger effect if applied (Inferred arithmetic; masks not rewritten)

MAIN proven would fall by **368 B** (360 DEAD + 8 DATA-MISTYPED), from the L-wave recon's `364,786` to **`364,418`**
for this scope. These 368 B are a subset of the recon's retained 1,692 B of proven-unreached runs
(`ida\out\l-wave-recon\proven-unreached-runs.tsv`); the recon did not demote them, and this lane proposes doing so.
Two of the 29 (`0x0076D8` 8 B, `0x01C27E` 22 B) are the same addresses doc 99 already lists as optional `#C`
companions in `ida\out\fnindex-lo\proposed-demotions.tsv`, so a merge must not double-count them (30 B overlap).
Named/typed is unchanged (I12 convention: all 368 B are in `final4`/`final6` named via the A addend).

## USB relevance

None. No run reads or writes `0xFFEE00`–`0xFFEE53` (USB), `0xFFF610`, `0xFFFF60`–`0xFFFF9F` (SCI, incl. the DSP
SCI-C at `0xFFFF88`) or the DMAC blocks (`offline` scan, 0 hits over every decoded operand). The DSP/SCI-adjacent
and USB-adjacent concerns doc 99 raised live in its own runs, not here. This lane changes none of the three mission
answers: no new USB surface, no sample path, no DSP bus exposure. It only tightens the proven-code ledger by
removing dead and data bytes.

## Open (most valuable first)

1. **Merge the 368 B demotion** into MAIN_FINAL6's proven mask, de-duplicating the 30 B companion overlap with
   doc 99, and retype `0x00932A`–`0x009332` as a byte table. Re-derive the proven mask and confirm −368 (−338 net of
   the overlap) and +0 elsewhere.
2. **Size the "dead arm after `bra`" class image-wide.** This lane and doc 99 both find the compiler emitted
   complete arms (often the "else → `jsr 0x3FFA0`" menu landing, or an er1-callback registration) that a later
   unconditional `bra` skips. A whole-image pass for 0-reference blocks immediately after an unconditional `bra`
   would quantify how much of the remaining 1,324 B of proven-unreached runs ≥ `0x030000` is the same artefact.
3. The seven `jsr @0x03FFA0` dead arms and the two er1-registration arms (`0x019EA0`, and `0x01A0E4` →
   record `0x1A1DA`) confirm `0x03FFA0` and the `0x1A1xx` record block as the menu-callback default/landing set
   (doc 99 §1); a map of which callbacks are live vs skipped would close the menu-dispatch picture, but it is not
   on any USB/SDR/DSP path.
