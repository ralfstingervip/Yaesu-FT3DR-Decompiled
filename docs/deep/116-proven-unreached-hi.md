# 116 — Proven-but-unreached runs at 0x058000 and above (lane M4)

> Lane M4, model `claude-opus-5-5`. Owner-side, strictly read-only static analysis of
> `decrypted\FT3D_MAIN_ver102_EXP.bin` (MAIN, H8SX `h8sxa`, base 0, big-endian, file offset = mapped
> address; sha256 `8e3ecd05…`, re-checked unchanged; SUB `b93570b3…` untouched). No image byte, mask or
> seed was modified; nothing was connected to or written to any radio. Only my private DB name `M4_PUNR_HI`
> is reserved; the whole-image evidence was decisive offline from the published masks, the binutils oracle,
> and H9's saved descent, so no IDA edit was needed. Tables and scripts: `ida\out\punr-hi\`
> (`runs.tsv`, `proposed-demotions.tsv`, `proposed-rules.tsv`, `analyze_m4.py`, `dump.py`, `gen_tables.py`,
> `citecheck.py`). All 20 doc citations byte-check against the image (`citecheck.py` → ALL OK).

## Verdict

The 29 runs split cleanly in two. **The 13 in-window runs (220 B, `0x078106`–`0x078514`) are WINDOW-ONLY
and stay proven**: they are the final4-proven subset of the 1088-byte gated USB CDC-ACM personality that
doc 95 decoded byte-for-byte; H9's `analyze.py` excludes the whole closed window from the descent by
construction (`INW` zeroing), so they can never show as "reached." **The 16 below-window runs (530 B) are
all DEAD** — compiler-emitted switch/case arms (and two alternate-length copy/dispatch variants) that sit
inside *otherwise-reached* functions but after an unconditional `bra` that skips them, with **no inbound
edge of any form anywhere in the image** (no BE32 pointer, no abs24 `jsr/jmp`, no raw-3-byte address, no
relative `b**`/`bsr`, and no indirect `jmp` in the containing function). They are proven only as
validated-fnindex (`A`) bytes and are proposed for demotion (proposal only; no mask edited). **No descent
rule can reach them, and none should be added.** The much-discussed "WIRES-X parser case bodies"
(`0x062808`, `0x06723A`, `0x06AB1C`–`0x06AB36`, `0x06ADF6`–`0x06AE10`) are in this dead set: they are
*not* dispatched by `off_74472` (which points only into `0x073Axx`–`0x07445A`) or by any other table.
None of this adds or removes USB, SDR or DSP surface.

## Method

Whole-image evidence, offline, gated by the published masks; no descent re-run.

1. **Real instruction heads.** Tiled `ida\out\l-wave-recon\final6_proven_mask.bin` with binutils-oracle
   lengths (`common.bu`): 113,638 heads, **0 mis-tiles** — every proven run decodes uniquely, so a proven
   run's start is a true head.
2. **Addend of each run.** Rebuilt H9's proven addends (`masks.py`: `A` validated-fnindex×is_code, `RC`
   recovered-code runs, `D` F1 proved-corrected rows, `G1A` binutils tier-A) and recorded which sets each
   run's bytes (`runs.tsv` col `addend`). All 16 below-window runs are `A`-only (fnindex); the window runs
   are `RC` or `A`.
3. **Inbound-edge scan, whole image `0`–`0x7B753`, every form** (`analyze_m4.py`, `gen_tables.py`):
   BE32 pointers at any offset, abs24 `5E`/`5A` `jsr/jmp`, raw 3-byte address occurrences, and
   `rel8`/`rel16`/`bsr16` relative branches decoded from **every** offset (not only proven heads). For the
   suspect functions I also scanned the whole function body for any indirect `jmp` (`jmp @erN`,
   `jmp @@aa:8`, `jmp @(d,erN)`, `bra rN.w`) and decoded the two local jump tables (`off_6acb6`,
   `off_5d028`) and the node-command table `off_74472`.
4. **Liveness.** Loaded H9's saved with-fnindex-seeds descent (`descent.pkl`, 113,731 reached insns) and,
   for each run, measured reached bytes in the enclosing maximal proven run and whether the run's own bytes
   are reached. Byte-checked every cited site with `citecheck.py`.

Not done: I did not re-run the descent or open an IDA database; I measured against K1's fixed-point
final6 masks and H9's saved descent. Runtime register values are the standard Inferred assumption.

## Findings

### A. The 13 in-window runs = WINDOW-ONLY (220 B, keep proven)

These are exactly the `final4`-proven bytes inside the 1088-byte USB personality code stream
`0x078106`–`0x078545`. They interleave perfectly with doc 95's **868** unset-code ranges: 220 (here) +
868 (doc 95, added by L1 in final5) = **1088** = the complete 18-routine stream doc 95 decoded with 0
mismatches. So the relationship to doc 95 is exact — my 220 B are the complement of its 868 B, and
together they are the whole gated personality. The runs stay proven; the window's own `RC`/`A` typing is
the proving rule.

They are unreached for one structural reason: `analyze.py` sets `RM[x]=0` for every `x` in the closed
window `CW` (`0x078106`–`0x07B754`), so the descent's "reached" set is *defined* to be empty there. A real
edge into the window does exist and is reached — boot `0x002234 5e 07 81 06` (`jsr @0x78106`) on the
strap-match path `0x002200 2c 4c ec 7f ac 7d 47 16` (`mov.b @0xFFFF4C; and #0x7F; cmp #0x7D; beq`) — and
the interior callers are the window's own gated handlers: `0x05DD12 5e 07 81 5c` (polled service, only
when `FFB0C4 ≥ 5`), `0x05DD9E 5e 07 82 22` (SCI reconfig), and `0x07845E`/`078150`/`078212`/`0768BC`/
`076F30`/the `jsr @er5` ring sites at `0x076844…`. Entry conditions are doc 95's exactly: strap
`(FFFF4C&0x7F)==0x7D` sets `FF813A=1`, the USB ISR calls `0x07827C` only when `FF813A≠0`, and the
DSP-WRITE state `FFB0C4 ≥ 5` gates `0x07815C`/`0x078222`. Per-run roles and callers are in `runs.tsv`.

### B. The 16 below-window runs = DEAD (530 B, propose demotion)

Every one sits in a function the descent **does** reach (e.g. `0x06AB1C`'s fn `0x06A97A`–`0x06AB5C`
450/482 B reached; `0x062808`'s fn `0x062730`–`0x062814` 216/228; `0x0605C6`'s fn 1120/1132;
`0x070DAA`'s fn 2528/2628). So these are not dead functions — they are dead *arms* inside live functions.
For each, the immediately preceding instruction is an unconditional `bra` to the function's common exit
that jumps **over** the run, and an exhaustive whole-image scan finds **no inbound edge of any kind** to
the run start, and the containing function contains **no indirect `jmp`** that could compute into them.
With no way to branch to them and no way even to *materialise* their address (no BE32/abs24/raw-3-byte
occurrence of the run address exists anywhere), they cannot be reached or stored as a callback. This is the
same category as doc 8/doc 105's unreachable TX states — valid code the final build never dispatches to.

- **WIRES-X reply-builder switch arms** — `0x062808` (`40 16 5e 06 6f b4 40 10 5e 06 72 50 …` = `bra exit;
  jsr @0x66FB4; bra; jsr @0x67250; …`), `0x0628FE` (`jsr @0x66FAA`), `0x06723A` (`jsr @0x66FB4`),
  `0x06AB1C` (six arms `jsr @0x66FB4/67250/6726A/66FAA/66FBE` after `0x06AB18 58 00 00 3e` `bra 0x6AB5A`),
  and its twin `0x06ADF6` (same arms after `0x06ADF2 58 00 00 1e`). The four functions holding these arms
  contain **no** indirect jmp; the arms have **no** inbound edge. **`off_74472` does not point to them** —
  its 48 BE32 slots (`0x074472 00 07 3a fe 00 00 20 70 00 07 3b 6c …`) target only `0x073Axx`–`0x07445A`.
  So L4/doc 101's "reached through the off_74472 node-command dispatch" is the wrong mechanism (see
  correction C). The arms are dead.
- **`0x05C8DC` (218 B, the largest run)** — a stack of WIRES-X reply-string builders (each writes `']'`
  `'a'` `'_'` `'0'` to `FF0206`/`FF0208`, calls a formatter, and `bra`s to the common exit `0x05C9B6`).
  The leading `0x05C8D8 58 00 00 da` (`bra .+218 → 0x05C9B6`) skips all of them; no inbound edge. Dead.
- **`0x05CF34` (8 B) = SPLIT-TAIL.** The proven-mask boundary falls mid-instruction inside a dead
  `B0B9`-indexed dispatcher at `0x05CF22` (`01 00 6d f6 6a 0b b0 b9 … 78 b0 6b 26 00 05 d0 28 59 60` =
  `mov @B0B9; and; shll.l #2; mov.l @(0x5D028,er3),er6; jmp @er6`). `0x05CF20 bra` skips `0x05CF22`, which
  has no inbound edge; the jump-table *targets* are reached via the live copy of this dispatcher elsewhere,
  so only this dead duplicate's head bytes remain. Dead/split.
- **Others** — `0x0605C6`, `0x064EDE` (lone `bra.w` arm), `0x064EFE` (`jsr @0x64BD0`), `0x06691E`
  (`jsr @0x1FA22;rts`), `0x06BC56` (54 B reply-digit builder), `0x06BE52` (28 B alternate-length copy
  `0x4A` from `FEE000`→`FF1AC8`), `0x06CCE8` (reached only from the unreached `0x06CCC0 46 26` `bne`),
  `0x070DAA` (dead 4-way selector after `0x070DA8 40 10` `bra`) and `0x070DD6` (its three arms, pointers
  `0x72DD8`/`0x72E6E`/`0x72F04`, reached only from that dead selector). All: no inbound edge. Dead.

Full per-run detail, addend, reached-byte count and inbound-edge list are in `ida\out\punr-hi\runs.tsv`;
the 530 B demotion list is `proposed-demotions.tsv`.

### C. Correction to doc 101 (L4) and the l-wave-recon ledger — mechanism, not byte count

The leaf subs `0x066FB4`, `0x066FBE`, `0x067250`, `0x06726A` (and `0x066FAA`) are reached in the
with-seeds descent **only as fnindex function-start seeds** — each is preceded by `rts` (no fall-through)
and its *only* real callers are the section-B dead arms. doc 101 called `0x066FB4`/`0x067250` "REACHED …
through an indexed node-command dispatch (`off_74472`)"; that mechanism is wrong — `off_74472` points
nowhere near them and their caller stubs are unreachable. The l-wave-recon README restored
`0x066FBE` (10 B) + `0x06726A` (26 B) citing "proven callers `0x06AB2A/36`, `0x06AE04/10`," which this lane
shows are dead. I do **not** demote the leaves here (they are separately typed and this lane's scope is the
callers), but I flag that their liveness rests on fnindex seeding plus dead callers; a USB/WIRES-X follow-up
should decide whether the whole `0x066FAA`–`0x067283` reply-leaf cluster is live at all. Byte count of the
published masks is unchanged by this correction; see `proposed-rules.tsv` rule R3.

## USB relevance

- **Q1 (USB surface): no change.** The 13 window runs are the *existing* CDC-ACM virtual-COM personality
  (VID `0x26AA` PID `0x0020`, doc 95 / BRIEF correction 1), confirmed real code reached only behind the
  strap + `FF813A` + `FFB0C4 ≥ 5` gates. No new engine, endpoint or register. The 16 dead runs touch no
  USB register (`0xFFEE00`–`0xFFEE53`); they are SCI-A WIRES-X/PDN reply-builder arms and are dead.
- **Q2 (USB SDR): unchanged no.** No run reads a sample/IQ buffer, a wide DMA path, or SCI-C `0xFFFF88`.
- **Q3 (DSP): unchanged.** The only DSP-adjacent item is the dead duplicate `B0B9` dispatcher at
  `0x05CF22`; the live `B0B9` state machine (doc 106/L9) is unaffected.

## Open (most valuable first)

1. **Apply the 530 B demotion (R2)** in the next MAIN seed and re-derive the proven mask; these are
   fnindex-only dead arms that both the descent (unreached) and the recon drop-analysis (not seed-reached)
   missed. Before demoting, a seed owner should re-confirm each run still has 0 inbound edges on the opened
   DB.
2. **Decide the `0x066FAA`–`0x067283` leaf cluster (R3).** If its only live entry is fnindex seeding, the
   recon's +36 B (`0x066FBE`/`0x06726A`) and L4's two REACHED seeds should be reconsidered; this needs a
   trace of every caller of those leaves, not just the dead arms.
3. **Window personality:** doc 95's open items stand (what drives `FFFF4C` to `0x7D`; the `0x076ADE`/
   `0x076B20` prologues with no absolute reference). The 220 B here add nothing new to those.
