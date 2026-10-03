# 65 — Merging the I-wave MAIN ledger deltas, and the MAIN_FINAL2 seed (Lane I14)

> Lane I14, model `claude-opus-5-5`. Owner-side static analysis of `decrypted\FT3D_MAIN_ver102_EXP.bin` (H8SX, base 0,
> big-endian, so file offset = address; sha256 prefix `8e3ecd05409b2c31`, unchanged). No image byte was modified, and
> nothing was connected to or written to any radio or device. Only my own DB `ida\db\jobs\MAIN_FINAL2\MAIN_FINAL2.i64` was
> opened. It was seeded with `--copy-from ida\db\jobs\MAIN_FINAL\MAIN_FINAL.i64`, and `--copy-from` only reads that seed.
> The closed window `0x078106`–`0x07B753` was not analysed, and no byte inside it is credited. Its 99 code heads (318 B) are
> byte-identical to the seed. Tables are in `ida\out\main-final2\`.

## Verdict

**The three lanes' claims do not overlap.** I6, I8 and I9 each claim bytes against H9. All six pairwise intersections
are **0 B**, so the byte union equals the sum: **+2,862 B**.

**Merged figures:**
- **MAIN proven: 365,570 → 368,432.** That is 72.86 % of 505,684 content bytes and 94.84 % of the 388,490 decodable bytes.
- **MAIN named/typed: 497,139 → 497,280 (+141, 98.34 %).**

**Decompile headline:**
- With the H-wave SUB rule (464,166): **961,446 / 1,029,972 = 93.35 %**.
- With lane I2's SUB proposal (464,263): **961,543 / 1,029,972 = 93.36 %**.

**Two corrections to the lanes:**
- **I8's tier-X +66 B is kept as Confirmed.** The dispatch reads exactly that table base. Its index cell is written only
  with values inside the 3-slot range.
- **I8's named delta is +2, not 0.** I8 counted a span as named because the W2-8 run type says "recovered code". But H9
  had demoted 2 bytes of that span as junk (`0x034CD5`, `0x034D03`), and they are now reached.

**All three lanes reproduce exactly.** I re-ran each lane's edges through H9's unchanged descent, and each set came back
byte for byte. Running all three lanes' seeds together reaches exactly the union: nothing more and nothing less.

**The MAIN_FINAL2 seed:**
- **It is a true fixed point.** A `--reopen` pass changes 0 functions, 0 heads, 0 code bytes and 0 xrefs. A rebuild
  from a fresh MAIN_FINAL copy reproduces the same layout hash.
- **It has 0 odd heads.**
- **Every merged proven byte is DB code: 368,432 / 368,432.** That includes the 34 lead-in bytes I3 left as non-code.
- **The closed window is unchanged.** It has the same 99 heads and 318 code bytes, and its code mask is identical to
  MAIN_FINAL's.

## Method

All of the following was run in this session.

### 1. Offline merge: `ida\out\main-final2\offline\i14_merge.py`

This is plain Python and read-only. It imports H9's `analyze.py` and `descent.py` unchanged. Its log is in
`merge_log.txt`.

**H9 masks rebuilt.** I rebuilt H9's proven and named masks the way I9 and I3 did:
- proven = 365,570, named = 497,139;
- the proven mask equals I3's `main-final\h9_proven_mask.bin` byte for byte;
- the H9 full descent reproduces H9's reach mask (363,758 B, 113,731 instructions).

**Each lane's set was loaded and re-derived:**
- **I6.** I loaded `exit-table-new-insns.tsv` (383 instructions). Every row's bytes match the image, and every row's
  oracle length matches. I then re-ran I6's gated exit-table descent (127 entries) and got the identical set, 1,544 B.
  Running H9's full rules from the same 127 roots gives the same 1,544 B.
- **I8.** I ran H9's `run("full")` with I8's 7 extra targets. That gives 182 B: 116 B from `0x034CCE` alone, 66 B from
  the three tier-X targets alone, and 0 B from the three immediates `0x077DB8`/`0x077FC6`/`0x078086`.
- **I9.** I loaded `new-proven-bytes.tsv` and re-derived it from I9's edge list: the record fields of
  `0x0296E8`/`0x029712`, `0x000706` and `0x01A084`. The result is identical: 1,136 B.

**Checks on every set:**
- overlap with H9 proven = 0;
- overlap with H9 reach = 0;
- bytes in the window = 0;
- pairwise intersections computed;
- the union was cross-checked by a single combined descent seeded with all lanes' roots.

**Instruction list.** The union is tiled by **820 oracle instructions**, with 0 overlapping starts and 0 odd starts
(`merged-insns.tsv`).

**Decode lengths, before and after.** IDA `h8sxa` decodes all 820 at the oracle's length:
- in the unmodified seed, using the read-only probe `ida\jobs\i14_probe.py`;
- again in the final DB (`MAIN_FINAL2_insncheck.tsv`, 0 mismatches).

### 2. Seed build: `ida\jobs\i14_apply_final2.py`

The job is idempotent, two rounds per pass. It was run through `run_job.py` only:
1. a probe `--copy-from`;
2. dev passes `pass1`–`pass3` (`--reopen`; log `MAIN_FINAL2_devlog.txt`);
3. a clean rebuild `build` (`--copy-from` again, so the DB was recreated from MAIN_FINAL);
4. `verify` (`--reopen`).

Each pass is logged in `MAIN_FINAL2_log.txt`. The job never runs a broad re-plan. It calls `auto_wait()` only after its
own edits, never calls `patch_*`, snapshots and restores the window's code heads, and sweeps odd heads.

### 3. Measurement: `ida\out\main-final2\offline\i14_post.py`

This measures the DB code-mask dump against the merged proven mask (`final2_proven_mask.bin`, 368,432 B). It writes
`functions.tsv`, using I3's reach-class rule, which I reproduced exactly on MAIN_FINAL (5,212 / 30 / 89 / 6, 0
mismatches). Its log is in `post_log.txt`.

### 4. Cite check: `ida\out\main-final2\offline\i14_cites.py`

This re-reads 48 cited byte runs from the image and checks the oracle text for each: `checks ok: 48 / 48`.

**Not done (scope):**
- I did not extend H9's descent rules; that is lane I15.
- I credited nothing beyond the three lanes' edges.
- I did not search for writers of the tier-X index cell inside the closed window.

## Findings

### 1. Per-lane re-verification and overlaps (`merged-new-bytes.tsv`, `overlaps.tsv`)

| Lane set | Bytes | ∩ H9 proven | ∩ H9 reach | in window | not in H9 named | Re-derived |
| --- | ---: | ---: | ---: | ---: | ---: | --- |
| I6 exit table `0x019A9E` | 1,544 | 0 | 0 | 0 | 10 | identical (I6 algorithm and H9 rules) |
| I8c `0x034CCE` | 116 | 0 | 0 | 0 | **2** | identical |
| I8x tier-X `0x003272` | 66 | 0 | 0 | 0 | 0 | identical |
| I9 three edges | 1,136 | 0 | 0 | 0 | 129 | identical |
| **Union** | **2,862** | 0 | 0 | 0 | **141** | combined descent = union exactly |

**Overlaps.** All six pairwise intersections are 0 B, so there is nothing to subtract. I9 had flagged a possible overlap
with I8, because all three of its edges sit behind `jmp/jsr @ERn`. There is none, for these reasons:
- I8's `sites.tsv` gives the RAM-cell sites (`0x0028E0`) no target.
- I8 never resolved the `er1` callback at `0x015224` to `0x01A084`.
- I8 never resolved the record fields of `0x028CBC`'s dispatch.

**Sample re-decodes** (all Confirmed; part of the 48 checks):
- **I6.** The dispatch at `0x01919A` is `78 60 6b 26 00 01 9a 9e` (mov.w @(0x19a9e:32,er6),r6), then `0x0191A2`
  `7a 16 00 01 48 a0` (add.l #0x148a0,er6), then `0x0191A8` `5d 60` (jsr @er6). A typical new stub is `0x019250`
  `79 01 00 73 5a 03 cc bc` (mov.w #0x73,r1; jmp @0x3ccbc).
- **I8.** `0x034642` `78 b0 6b 26 00 03 46 74` is mov.l @(0x34674:32,er3),er6, and `0x03464A` `5d 60` is jsr @er6.
  Slot `0x03467C` = `00 03 4c ce`. The target `0x034CCE` decodes as `7e 4d 73 30` (btst #3,@0x4d:8) and runs to
  `0x034D40` `54 70` (rts).
- **I9.** The installer chain is `0x034C24` `5e 00 04 50` → `0x000454` `7a 05 00 00 07 06` → `0x00042C`
  `01 00 6b 85 81 1a` (mov.l er5,@0xFF811A). The vector-88 stub `0x0028DA` `01 00 6b 06 81 1a 59 60` jumps through that
  cell. The callback load is `0x0178F0` `7a 01 00 01 a0 84`, and the jsr @er1 is `0x015224` `5d 10`.

**All 820 instructions decode at the same length** in the oracle, in each lane's TSV, and in IDA `h8sxa` (Confirmed).

### 2. Decision on I8's tier-X +66 B: Confirmed, credited

**The dispatch** (Confirmed, reached in H9's full descent): `0x00325E` `6a 0b a9 e0` (mov.b @0xa9e0:16,r3l), then
`0x003262` `7a 63 00 00 00 ff` (and.l #0xff,er3), then `0x003268` `10 73` (shll.l #2,er3). Next comes `0x00326A`
`01 00 6f 36 32 72`, which is mov.l @(0x3272:16,er3),er6; the displacement is the table base exactly. The jump is
`0x003270` `59 60` (jmp @er6).

**The table** sits immediately after the `jmp`: `0x003272` = `0000327e 0000328a 0000329c`. Its first target, `0x00327E`,
immediately follows the table. This is the compiler's switch layout.

**Index range.** Within the oracle decode of `0x000000`–`0x078105`, the only instructions that name the cell `0xFFA9E0`
are:
- the load at `0x00325E`;
- three stores of constants 1, 2 and 1: `0x003282` `fc 01 6a 8c a9 e0`, `0x003294` `fc 02 6a 8c a9 e0`, and `0x0032B8`
  `fc 01 6a 8c a9 e0`.

So the index takes only 0, 1 or 2, which are exactly the 3 slots.

**Why H9 missed it.** H3 put the array in tier X ("2/3 targets weak") because it found no referencing instruction (H3's
`ref_insns` = 0). H9 credits arrays only in tiers A, B and C. Had H3 tiered the array, H9's own load-site rule (its `LD`
regex accepts the `:16` form) would have credited it.

**What remains Inferred.** Slot 0 depends on the cell starting at 0. No clear of `0xFFA9E0` was found among the reached
pointer immediates. The boot clear covers `0xFEE000`–`0xFF72FF` only: `0x002132`–`0x002150`, `7a 04 00 ff 73 00` … `7a 05 00
fe e0 00`.

**Companion figure without tier-X:** proven 368,366, which is 72.85 % of content and 94.82 % of decodable.

### 3. Correction to I8's named delta (+2, not 0)

H9 demoted `0x034CD5` (`0c`, the second byte of `0x034CD4` `6a 0c aa d3`) and `0x034D03` (`10`, inside `0x034D02`
`6a 10 aa d1 73 00`). Its `demoted.tsv` lists both as `RC junk → leaves`, so H9's named mask excludes them.

Both bytes are now reached code. Under H9's rule "reached and not named → joins named", they return. I8 judged its
spans by the W2-8 run type alone ("recovered code") and missed this.

### 4. Merged ledger (`ledger-delta.tsv`)

| Term | Δ | Value |
| --- | ---: | ---: |
| MAIN proven code, H9 | | 365,570 |
| + I6 exit table `0x19A9E` | +1,544 | |
| + I8 `0x034CCE` (Confirmed) | +116 | |
| + I8 tier-X `0x003272` (Confirmed, §2) | +66 | |
| + I9 three edges | +1,136 | |
| − pairwise intersections | 0 | |
| **MAIN proven code, merged (byte union)** | **+2,862** | **368,432** (72.86 % / 94.84 %) |
| MAIN named/typed, H9 | | 497,139 |
| + union bytes outside H9's named mask (I6 10, I8 2, I9 129) | +141 | **497,280** (98.34 %) |
| **Headline, SUB 464,166 (H-wave rule)** | | **961,446 / 1,029,972 = 93.35 %** |
| **Headline, SUB 464,263 (I2 proposal)** | | **961,543 / 1,029,972 = 93.36 %** |

**No double count.** The four sets are disjoint from H9's proven mask, from H9's reach mask and from each other, so
their union equals their sum.

**I9's re-proven bytes.** I9 re-proves 274 B that H9 had demoted, including F1 rows `0x000760` and `0x000800`. Those
bytes are outside H9's final proven mask, so adding them back does not count them twice. (Confirmed: the asserts in
`i14_merge.py`.)

### 5. MAIN_FINAL2 (`MAIN_FINAL2_log.txt`)

| Pass | funcs | heads | code B scope + window | odd | xrefs from code | layout hash |
| --- | ---: | ---: | ---: | ---: | ---: | --- |
| seed (MAIN_FINAL) | 5,337 | 124,081 | 390,122 + 318 | 0 | 175,443 | `b6ab2a22…` |
| `build` (copy-from) after | 5,442 | 124,076 | 390,474 + 318 | 0 | 177,856 | `867a8a0a…` |
| `verify` (reopen): both rounds change 0 | **5,442** | **124,076** | **390,474 + 318** | **0** | **177,856** | **`867a8a0a…`** |

The window head hash `6ff215a0…` is unchanged across all passes, and the window code mask equals MAIN_FINAL's
(`post_log.txt`).

**What the job applies (round 1 of `build`):**

**Data typing.** Each extent below holds 0 code heads afterwards:

| Extent | Size | Typed as | What was there before | Evidence |
| --- | --- | --- | --- | --- |
| exit table `0x019A9E` | 206 BE16 words, 412 B | words, with a user dref from each slot to its `0x148A0`-relative target (206 drefs) | 410 B of bogus code, none H9-proven | — |
| I8 slot `0x03467C` | 1 dword | offset → `0x034CCE` | H2-excluded slot | I8's correction |
| tier-X table `0x003272` | 3 dwords | offsets | — | §2 |
| I9 records `0x0296E8`, `0x029712` | 8 dwords each | offsets on the 6 non-null fields | — | `00 02 97 32 00 00 00 00 00 05 e3 3e …` |
| byte tables `0x034CBA` and `0x034CC4` | 10 B each | bytes | — | read by `0x034C9A` `6a 2b 00 03 4c ba` and `0x034CAC` `78 30 6a 2b 00 03 4c c4` |
| I9's popcount table `0x000A8C` | 256 B | bytes | — | `00 01 01 02 01 02 02 03 …` |

The two byte tables are why IDA had mis-decoded across `0x034CCC`.

**Instructions.**
- Created 215 merged instructions that were not code heads: 75 for I6, 139 for I9, and `0x034CCE` for I8.
- Fixed all 16 of I3's lead-in rows, which are 15 instructions; `0x04CAD2` lies inside `0x04CACE`.

**Functions deleted (10).** Bogus `sub_760` (I9), plus the 9 functions that started 2 bytes inside a lead-in
instruction: `001FE0`, `002020`, `006946`, `01000A`, `016A18`, `025250`, `046B84`, `04AAAA` and `070B0A`.

The xrefs into those +2 heads do not come from real code, so no real xref breaks:
- `0x006946`'s jump-xref comes from ASCII decoded as code: `0x006904` `48 41`, "HA".
- `0x04CAD0`'s comes from `0x04CA62` `41 6c`, "Al", read as `brn`.
- `0x010000`'s data refs are numeric constants, for example `0x061F16` `7a 04 00 01 00 00` (mov.l #0x10000,er4).

**Functions added (115):**
- 108 I6 exit entries. The other 19 of the 127 already lie inside functions.
- 5 for I9: `0x000706`, `0x029732`, `0x029764`, `0x05E33E` and `0x05E37C`.
- `0x034CCE` (I8).
- `0x016A16`, a lead-in site that is a `bsr` target (`0x0169FE` `55 16`).

**Edges.**
- 137 user crefs: 127 from `0x0191A8`, I9's record/RAM-hook/`er1` edges, `0x03464A`→`0x034CCE`, and 3 tier-X jumps.
- 219 user drefs.
- 2,374 of I8's 2,378 site→target crefs. The other 4 were already present. Closed-window sites and targets are skipped,
  the same logic as `i8_apply_cb_xrefs.py`.

**State after the build.**
- All 820 merged instructions are code heads of the oracle length.
- All 820 are inside a function.
- The 127 exit entries carry a cref from `0x0191A8`.

**Coverage of the DB (`post_log.txt`).**
- **All merged proven bytes are code:** 368,432 / 368,432 (100 %). MAIN_FINAL had 365,536 / 365,570 against H9.
- **DB code outside the merged proven mask: 22,360 B,** down from 24,904. By W2-8 run type:

  | Run type | Bytes |
  | --- | ---: |
  | recovered code | 13,283 |
  | untyped | 3,680 |
  | parameter table | 3,326 |
  | string | 1,532 |
  | other | 266 |
  | fill | 149 |
  | pointer table | 26 |

  This is the typed-but-unproven surplus that the named/typed figure already credits.

**`functions.tsv`.** 5,442 functions:

| Class | Count | MAIN_FINAL |
| --- | ---: | ---: |
| proven | 5,322 | 5,212 |
| partly-proven | 31 | 30 |
| typed-unreached | 83 | 89 |
| closed-window | 6 | 6 |

Five old functions changed class, four of them to proven.

### 6. Lead-in heads (`proven-not-dbcode.tsv`)

**I3's 34 bytes are now code.** Each site now carries H9's oracle instruction. Examples:
- `0x006944` `5e 00 85 da` (jsr @0x85da), not the bogus `0x006946` head;
- `0x00FFFE` `6a 0c a9 f1`, which follows `0x00FFF8` `6a 18 a9 ee 70 70` by flow;
- `0x04CACE` `7a 01 00 00 00 14` (mov.l #0x14,er1);
- `0x044F3E` `54 70` (rts, after `0x044F3A` `46 02` bne .+2).

`proven-not-dbcode.tsv` in `main-final2` is therefore empty (header only).

**Eight lead-in instructions have no function.** They sit in code that no function covers in MAIN_FINAL either:
`001FDE`, `00201E`, `006944`, `02524E`, `044F3E`, `046B82`, `04AAA8` and `070B08`.

## USB relevance

No mission answer changes.

**The merged code.** None of the +2,862 B addresses the USB function module `0xFFEE00`–`0xFFEE53`, SCI-C `0xFFFF88` or
the closed window (Confirmed by each lane, and by the window and in-window asserts here). Its content:
- **I6:** EEPROM save stubs.
- **I8:** the slot-2 handler of jump table `0x034674` (`0x034CCE`) and a 3-state key-hold machine (`0x00327E`–`0x0032BF`, on `0xFFA9E0` and
  `0xFF9536`).
- **I9:** key-record handlers and the vector-88 bit-timing body `0x000706`–`0x000A8B`. That body writes the unidentified
  byte register `0xFFFF69`; I9 read it as not USB (Inferred).

**For later USB lanes.** MAIN_FINAL2 now carries I8's explicit crefs for the image-push sub-dispatch and the
control-transfer state machine:
- `0x055BA0` → the 11 handlers of table `0x055BF2`;
- `0x055BC8` → the 6 handlers of table `0x055C06`;
- `0x055000` → the 10 states of table `0x055002`.

All of I8's edges are present, since the `verify` pass added 0. A lane tracing the image-push feeder (RESUME Open 1)
should seed from MAIN_FINAL2, not MAIN_FINAL.

**SDR and DSP.** Unchanged.

## Open

1. **Fold in lane I15's extended descent rules.** Union I15's new bytes with `final2_proven_mask.bin`; do not add them.
   Re-run the merge's no-overlap asserts. If the rules are adopted, `0x19A9E`, the tier-X load-site rule and RAM-cell
   stores through a helper should become H9 roots, so that 368,432 is reproducible from one descent.
2. **Tier-X slot 0 initial value.** Find who zeroes `0xFFA9E0`; RAM above `0xFF7300` is not cleared by the boot loop. If
   nothing does, slot 0 is reached only from the power-on RAM state, and the +12 B of slot 0 (`0x00327E`–`0x003289`)
   would become Inferred.
3. **Attach the 8 function-less lead-in instructions and the remaining typed-unreached functions** (83) to their callers.
   Classify the 22,360 B of DB code outside the proven mask. Retyping the 1,532 B of strings would tidy the DB without
   moving any headline.
4. **I9's leftover record fields.** `0x028C2A`+0x14 → `0x02A924` and `0x028C8A`+0x14 → `0x02A9F4` are Confirmed fields
   that nothing credits yet. Also the remaining `sub_15206` `er1` callbacks.
5. **Seed for the next MAIN lane:**
   `python ida\run_job.py --script ida\jobs\<your>.py --db <YOURDB> --copy-from ida\db\jobs\MAIN_FINAL2\MAIN_FINAL2.i64`.
   `i14_apply_final2.py` rebuilds it from MAIN_FINAL to the same layout hash `867a8a0a68ef6a23`.

### Files (`ida\out\main-final2\`)

| File | Content |
| --- | --- |
| `merged-new-bytes.tsv` | runs of the 2,862-byte union: start, end, length, lanes, whether H9 named them, first bytes |
| `overlaps.tsv` | pairwise lane intersections (all 0) |
| `ledger-delta.tsv` | the table in §4 |
| `merged-insns.tsv` | the 820 instructions |
| `seed-edges.tsv` | the edges the job applies |
| `final2_proven_mask.bin` | per-byte mask over `0..0x7B754` |
| `functions.tsv` | 5,442 functions with reach class and MAIN_FINAL class |
| `MAIN_FINAL2_functions_raw.tsv`, `MAIN_FINAL2_codemask.bin`, `MAIN_FINAL2_insncheck.tsv` | DB dumps |
| `window_seed.tsv` | the seed's 99 window code heads |
| `proven-not-dbcode.tsv` | empty, header only |
| `MAIN_FINAL2_log.txt` (`build`, `verify`), `MAIN_FINAL2_devlog.txt` (probe-era `pass1`–`pass3`), `merge_log.txt`, `post_log.txt` | pass logs |
| `offline\i14_merge.py`, `offline\i14_post.py`, `offline\i14_cites.py` | the offline scripts |

Jobs: `ida\jobs\i14_apply_final2.py`, `ida\jobs\i14_probe.py`.
