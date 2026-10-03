# 113 — The MAIN_FINAL6 seed (Lane M1)

> Lane M1, model `claude-opus-5-5`. Owner-side static analysis of `decrypted\FT3D_MAIN_ver102_EXP.bin` (MAIN, H8SX
> `h8sxa`, base 0, big-endian, file offset = mapped address). Image sha256 prefix `8e3ecd05409b2c31` and SUB
> `b93570b3c2f69ccb` were checked by the builder and are unchanged. No image byte was modified (no `patch_*`), and nothing
> was connected to, enumerated on or written to any radio or device. Only my DB `ida\db\jobs\M1_MAIN_FINAL6\M1_MAIN_FINAL6.i64`
> was opened. It was seeded `--copy-from ida\db\jobs\L1_MAIN_FINAL5\L1_MAIN_FINAL5.i64`, and the seed itself was read only.
> Tables are in `ida\out\main-final6\`. Jobs are `ida\jobs\m1_dump.py` and `ida\jobs\m1_apply_main_final6.py`.

## Verdict

**MAIN_FINAL6 is built, and one run reproduces both L-wave masks byte for byte.**

| mask | popcount | sha256 |
| --- | ---: | --- |
| `ida\out\main-final6\final6_proven_mask.bin` | **364,786** | `ecd7deaf54da6d21abeaf99597a6d18dca04f75874cf9f91cd910a7adc73d2c5` |
| `ida\out\main-final6\final6_named_mask.bin` | **501,656** | `fe8f60996e0a585216db5dec8ddbbcc7323c00fa816e2ed0ab34b0a89aa1165d` |

Both files are `cmp`-equal to `ida\out\l-wave-recon\final6_*_mask.bin`. There are 0 differing bytes, so there is no
difference list to give.

- **Seed:** `ida\db\jobs\M1_MAIN_FINAL6\M1_MAIN_FINAL6.i64`.
- **Fixed point:** a `--reopen` edits nothing and changes 0 functions, 0 heads, 0 code bytes and 0 xrefs. The layout
  hash is **`8ebdd76d4cf1cf86`** (L1-compatible: code heads plus functions). The typed hash, which also covers data
  heads, is `fa1c7b80848b9f8a`.
- **Odd code heads:** 0 over the whole content.
- **Proven bytes:** all 364,786 are DB code.

**The 4 B stale-head gap is fixed in the DB but not credited.** `0x006A0C` and `0x0077F8` are now 6-byte instructions,
and the old heads at `0x006A0E`/`0x006A10` and `0x0077FA`/`0x0077FC` are gone. Neither the FINAL6 descent nor the
fnindex-seeded descent reaches them. Their predecessors are FINAL4-proven blocks that no direct edge reaches (§4).

**Ledger**

- **Proven:** 369,214 → 364,786. That is −4,428 B in 86 runs and +0 for the gap.
- **Named:** 498,319 → 501,656. That is +3,337 B in 513 runs.
- **Headline:** 965,919 / 1,029,972 = **93.78 %**.

## Method

Every step below ran in this session. IDA was run only through `run_job.py`.

1. **Seed dump.** `m1_dump.py` ran on a fresh copy of L1_MAIN_FINAL5 and wrote every head and every function
   (`work\seed\`).
2. **Offline plan** (`offline\m1_plan.py`). Every DB edit was resolved to an exact range or an exact instruction here,
   and the planner asserts that no two edits overlap.

   **2a. Drop the fnindex seeds.** 108 H9 fnindex seeds (`descent.FNSEED`) lie inside `drop_runs.tsv`. The plan handles
   them as follows:
   - 105 functions are deleted.
   - `0x066FBE` and `0x06726A` are kept, because they are re-added entry points.
   - `0x048B84` has no function to delete.

   **2b. Retype the DATA-MISTYPED runs as data.** There are 23 runs:
   - L2: 80 B;
   - L3: 144 B;
   - L4: 26 B.

   None of them straddles an item.

   **2c. Apply L5's 522 Confirmed rows (3,337 B).** Each row was handled one of these ways:
   - 78 rows are `none` (the item already exists) and 71 are already data. Both are verified only.
   - 326 rows become byte arrays.
   - 10 rows become BE32 cells. A row that is the tail of a cell is widened to the whole cell, which ends at the row end.
     An offset is attached only when the target lies in a segment.
   - 2 rows are the stale-head fixes.
   - 2 rows are operand bytes of a single instruction: `0x016AD6` (`6e 0c 00 51`) and `0x050734` (`4b 08`).
   - 1 row is already covered by a DB code head.
   - 15 rows lie in the two IDA-undecoded named routines `0x06B4B0`–`0x06B555` and `0x06B670`–`0x06B699`. These were
     created as the full oracle linear chain: 54 and 16 instructions, each ending exactly at the routine end.
   - 17 rows are data rows whose IDA neighbour item crosses the row edge. They were widened over that neighbour. The plan
     asserts that 0 of the neighbour bytes are proven; 22 of them are named.
3. **Build.** `m1_apply_main_final6.py` ran with `--copy-from` on L1_MAIN_FINAL5 and tag `build`, then with `--reopen`
   and tag `verify`. The job:
   - turns auto-analysis off while it edits;
   - clears the `AU_CODE`, `AU_PROC` and `AU_USED` queues before turning it back on, so that no flow-on code or
     functions appear;
   - deletes the planned functions;
   - re-creates a function at the first leftover code head only when the DB holds a call xref into it, or an offset xref
     with no fall-through predecessor;
   - checks that all 8 entry points are functions.

   It verifies the following:
   - the image equals the DB bytes;
   - 600/600 plan rows are typed as planned;
   - the code heads equal the seed minus the edits plus the planned instructions, with 0 unexpected, 0 missing and
     0 resized;
   - every proven byte is DB code;
   - the stale-head fixes are in place.

   The job is idempotent: the `verify` pass skips all 450 edit rows.
4. **One-run mask builder** (`offline\m1_build_masks.py`, 7 s). It recomputes the whole chain and asserts every
   intermediate result against the file that was published for it:
   - H9's proven 365,570 and its base descent 363,758;
   - K1's folded descent (K1a + K1b, with fnindex seeds) → FINAL4 proven, which equals `final4_proven_mask.bin`;
   - minus `0x054AE2`–`0x054BF7`, plus doc 95's 13 window ranges → FINAL5, which equals both `final5_*` files.

   It then runs **one** folded descent **without fnindex seeds, plus the 8 entry points**. Every FINAL4-proven byte that
   only the fnindex-seeded descent reaches, and that this descent does not reach, is removed from FINAL5. Named is FINAL5
   plus L5's Confirmed rows. Finally the builder reads the DB's per-byte type mask (`MAIN_FINAL6_typemask.bin`) and
   asserts the DB invariants listed in §2.
5. **Citations.** `offline\m1_verify_bytes.py` checks 48 byte citations in this document, with 0 mismatches.
   `offline\m1_gap_edges.py` scans the whole image for edges into the two gap blocks.

**Not done.**
- I did not re-plan `0x400`–`0x078106`.
- I did not touch the three functions inside drop runs that are not fnindex seeds (`0x07778C`, `0x077CC2`, `0x077D16`,
  in L4's demoted USB-module bytes). The recipe drops fnindex seeds only.
- I did not apply any Inferred-tier typing.

## Findings

### 1. The two masks are reproduced, not copied (Confirmed, `build_log.txt`)

| step | proven | named | equals |
| --- | ---: | ---: | --- |
| H9 → FINAL4 (one K1 folded descent) | 368,624 | — | `final4_proven_mask.bin` |
| FINAL5 (−278 / +868) | 369,214 | 498,319 | both `final5_*` files |
| fnindex-only FINAL4-proven bytes | 4,850 | | (94 runs, docs 99–101) |
| re-reached by the 8 entry points | 144 | | `reached-by-entries.tsv` |
| dropped and still in FINAL5 | −4,428 | | 4,706 dropped − 278 already demoted |
| gap `0x006A0C`/`0x0077F8` | +0 | | not descent-reached |
| L5 Confirmed rows | | +3,337 | 522 rows, all residue, disjoint from FINAL5 named |
| **FINAL6** | **364,786** | **501,656** | **both `l-wave-recon\final6_*` files, byte-equal** |

**The README's "36 B restored by hand" now comes out of the descent.** I seeded it at `0x066FBE` and `0x06726A`, the two
re-added entries. They are called from FINAL4-proven code:
- `0x06AB36` and `0x06AE10` both hold `5e 06 6f be`;
- `0x06AB2A` and `0x06AE04` both hold `5e 06 72 6a`.

With those seeds, `reached-by-entries.tsv` contains:
- the 7 runs / 108 B of `rec_runs.tsv`;
- `0x066FBE`–`0x066FC7` (10 B);
- `0x06726A`–`0x067283` (26 B).

The other 6 seeds are byte-checked:
- `0x018276 7a 01 00 01 82 50` and `0x01827C 5e 01 52 06`;
- `sub_15206`'s `jsr @er1`, `0x015224 5d 10`;
- `0x05E862 7a 01 00 05 e8 e0 5e 01 52 06`.

Proven ⊆ named holds, and nothing is set above `0x07B754`.

### 2. DB invariants (Confirmed, `MAIN_FINAL6_log.txt`, builder asserts)

| check | result |
| --- | --- |
| FINAL6 proven bytes that are not DB code | **0** of 364,786 |
| DATA-MISTYPED bytes | 250/250 DB data; 0 proven; 250 still named (I12 convention) |
| L5 Confirmed bytes | 3,337/3,337 typed (167 code, 3,170 data) |
| plan rows | 600/600 verified |
| code heads vs plan | 0 unexpected, 0 missing, 0 resized |
| odd code heads | 0 |
| 8 entry points as functions | 8/8 (all were already functions in FINAL5) |
| fnindex functions still present in drop runs | 0 |

The build changed the following, and the reopen changed none of it:

| measure | seed → FINAL6 | change |
| --- | --- | ---: |
| functions | 5,463 → 5,340 | −153 / +30 |
| code heads | 124,367 → 123,697 | −670 |
| data heads | 6,549 → 6,861 | +312 |
| code bytes | 391,748 → 390,452 | −1,296 |
| data bytes | 34,236 → 37,169 | +2,933 |
| xrefs from code | 178,254 → 177,221 | |

`function-changes.tsv` gives the reason for every function change; 0 are unexplained.

- **105 deletions** are the fnindex seeds inside drop runs.
- **48 deletions** are functions whose start byte an L5 Confirmed row retypes as data, for example a function that began
  on label text. In 14 of these 48, no code is left.
- **30 functions are re-created** at the real first code head. Examples:
  - `0x0486D2`, from `0x009364 5e 04 86 d2`; its old start `0x0486C4` lies inside L5's value table `0x0486BD`–`0x0486D1`;
  - `0x035432`, from `0x03521A 5e 03 54 32`;
  - `0x065A8C`, from `0x065B1A 5e 06 5a 8c`;
  - `0x07390A`, from `0x07380C` and `0x074576` (`5e 07 39 0a`);
  - `0x056CCA`, from `0x056D1C 55 ac` (`bsr`);
  - `0x02D708`, through the BE32 cell `0x02CBAC 00 02 d7 08`;
  - `0x034012`, through the cell `0x033984 00 03 40 12`.

Leftover heads that have only a fall-through or jump predecessor stay code outside any function. Examples are
`0x01CCF2`, `0x064622`, and `0x045D88`, which has no xref at all.

### 3. The 22 rows L5 skipped, re-checked on FINAL5 (Confirmed)

None of the 22 rows lies in the opened window `0x078106`–`0x078545`. L5's four window-area rows (`0x078546`–`0x0785D7`,
128 B) lie past the opened span and do not straddle anything in FINAL5. They were applied as data.

Of the 22, 19 straddle in the static FINAL5 layout. The other three (`0x06B4DF`, `0x06B511`, `0x06B673`) straddled in
L5's run only because of instructions that L5's own earlier rows had created. All 22 are now typed:

| rows | how |
| --- | --- |
| `0x01E1C2` | already code: the DB head `0x01E1C0 78 b0 6b 26 00 01 e1 de` (8 B, `mov.l @(0x1e1de:32,er3),er6`) covers it |
| `0x06B4DF`, `0x06B511`, `0x06B531`, `0x06B673` | the oracle instruction chains of `0x06B4B0`/`0x06B670`. `0x06B531` is the second byte of `0x06B530 59 60` (`jmp @er6`), and the next instruction is `0x06B532 f2 00` |
| `0x03605A`, `0x0361E2`, `0x04C336`/`48`/`7E`/`91`/`A3`, `0x04E29B`, `0x04E2B9`, `0x04E527`, `0x06C59F`/`B1`/`B9`/`C1`/`C9`/`F9`, `0x06C601` (17) | byte arrays widened over the straddling mis-decoded neighbour, for example `0x04C336 ff 54`, `0x04E298 6e ff 00 0e`, `0x06C59E 30 04 01` and `0x03605A 07 07 07 07 07 39`. 22 neighbour bytes, all named, 0 proven |

### 4. The 4 B stale-head gap (Confirmed in the DB; not credited)

| gap | predecessor | instruction now in the DB | how the predecessor block is entered |
| --- | --- | --- | --- |
| `0x006A0C`–`0x006A0D` | `0x006A08 6e 5c 00 6d` | `0x006A0C 6a 10 8e a0 73 40`, `btst #4,@0x8EA0:16` (6 B) | it follows `0x006A06 40 12` (`bra 0x6A1A`). The block before it is entered by `0x0069EE 46 14` (`bne 0x6A04`) |
| `0x0077F8`–`0x0077F9` | `0x0077F6 67 04` | `0x0077F8 6a 10 81 7e 77 00`, `bld #0,@0x817E:16` (6 B) | it follows `0x0077CC 40 36` (`bra 0x7804`). The only calls, `0x00738E` and `0x007484` (`5e 00 77 cc`), land on that `bra`, which goes straight to `rts` |

**Not found** (scope: the whole image `0`–`0x07B753`, every oracle-decoded branch, `bsr`, `jsr` and `jmp` target, every
abs24 `5E`/`5A` operand, and every BE32 value): any edge to `0x006A08` or `0x0077CE`. So `0x006A08` and `0x0077CE` are
FINAL4-proven only by H9's analyze rules, which include IDA-item-based H1 addends. They belong to the 1,692 B class of
FINAL4-proven bytes that the descent does not reach. The FINAL6 descent reaches neither gap byte, and the
fnindex-seeded descent does not either. I credited +0, as the task requires.

The current mask still contains `0x006A08`–`0x006A0B` and `0x006A0E`–`0x006A19` but not the 2 B between them, and the
same holds around `0x0077F8`. The audit of the 1,692 B class should settle each block as a whole: demote it, or keep it
and add its 2 B.

### 5. Named ≠ DB-typed (Confirmed, measurement only)

In the FINAL6 DB, 77,113 named bytes are unexplored. 12,588 of them sit in the closed window `0x078546`–`0x07B753`.
FINAL5 named, measured on the same DB, gives the same count, because all 3,337 bytes added here are typed. The named mask
is an offline ledger, not a DB census. This affects no figure above.

## Corrections to earlier docs (owning docs not edited)

- **Doc 101 (L4), `0x067522`:** the row reads "lone rts … 0 inbound". In fact two abs24 calls to it exist,
  `0x06B4F6 5e 06 75 22` and `0x06B536 5e 06 75 22`. Both sit inside `0x06B4B0`, a routine with no inbound reference
  (doc 102 §3; Inferred from L5's scan). The DEAD verdict stands, because the bytes are reached only from dead code, but
  "0 inbound" is wrong.
- **Doc 102 (L5), row `0x01E1C2`:** the row calls the containing instruction "named insn 0x01E1BE
  (mov.w @(0x1e1de:32,er3),r6)". `0x01E1BE` is `10 73` (`shll.l #2,er3`). The instruction that covers the row is
  `0x01E1C0 78 b0 6b 26 00 01 e1 de`, `mov.l @(0x1e1de:32,er3),er6` (8 B), which is already a DB code head.
- **Doc 102 (L5) §1:** "the proven mask would grow by 4 B". This does not hold under the descent standard used since
  K1. The fall-through comes from blocks that are not descent-reached (§4 above), so the bytes are fixed in the DB and
  not credited.
- **L-wave README:** "Restore … 36 B by hand" is now derived. Seeding the descent with the entries `0x066FBE` and
  `0x06726A` gives the same 36 B, so the published proven mask is a pure descent result.

## USB relevance

This is bookkeeping, and the mission answers do not change.

- **Q1, USB:** the only USB-adjacent change is that the dead USB-module bytes `0x07778C` and `0x077CC2` drop out of
  proven. They stay as DB code and functions, because they are not fnindex seeds. No USB register access, descriptor or
  endpoint moved.
- **Q2, SDR:** no sample path appears.
- **Q3, DSP:** no DSP path appears.

## Open

1. **Audit the 1,692 B (80 runs) of FINAL4-proven bytes that the descent does not reach**, including the `0x006A08` and
   `0x0077CE` blocks. When a block is kept, add its 2 B gap byte pair. When a block is demoted, the gap stays out.
2. **Decide the three non-fnindex functions in drop runs** (`0x07778C`, `0x077CC2`, `0x077D16`). The DB keeps them as
   functions while proven drops them.
3. **The 77,113 named-but-unexplored DB bytes.** Type the ones whose named class is settled (strings, tables), so that
   the DB and the named ledger converge.
4. **Name the 30 re-created functions and the orphaned code heads** listed in `function-changes.tsv` and in the log.

## Files (`ida\out\main-final6\`)

| file | content |
| --- | --- |
| `final6_proven_mask.bin`, `final6_named_mask.bin`, `masks-sha256.txt` | the masks (364,786 / 501,656 set), byte-equal to the L-wave files |
| `ledger.tsv`, `final5-to-final6-diff.tsv`, `reached-by-entries.tsv`, `build_log.txt` | ledger, 86 proven-removed and 513 named-added runs, the 144 B the entries reach, builder log |
| `plan-typing.tsv`, `plan-delfunc.tsv`, `plan-log.txt` | the resolved DB edit plan (600 rows, 105 function drops) |
| `MAIN_FINAL6_log.txt` | build and verify logs (fingerprints, leftover-function decisions) |
| `MAIN_FINAL6_typemask.bin`, `MAIN_FINAL6_codemask.bin`, `MAIN_FINAL6_heads.tsv`, `MAIN_FINAL6_functions_raw.tsv` | DB per-byte type (0 unexplored, 1 code, 2 data), code mask, heads, functions |
| `function-changes.tsv` | 153 deleted and 30 added functions, with reasons |
| `offline\m1_plan.py`, `m1_build_masks.py`, `m1_gap_edges.py`, `m1_func_changes.py`, `m1_verify_bytes.py` | planner, one-run builder, gap edge scan, function diff, citation checker |
| `work\seed\`, `work\build\` | seed dump and build-pass snapshot (identical to the verify pass) |
