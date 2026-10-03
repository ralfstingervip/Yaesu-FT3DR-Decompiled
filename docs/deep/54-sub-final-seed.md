# SUB final seed database: every H-wave repair applied, recounted (Lane I2)

This lane is owner-side static analysis of `decrypted\FT3D_SUB_ver102_ALL.bin` (RX64M, LE, mapped at `0xFFC00000`, file offset = address − `0xFFC00000`; sha256 `b93570b3…`, unchanged). The private DB is `SUB_FINAL`, built with `--copy-from ida\db\jobs\H10_SUB\H10_SUB.i64`. No other DB was opened, no image was modified, and nothing was written to a radio. Model: claude-opus-5-5.

Tables are in `ida\out\sub-final\`; the files are listed at the end of Method.

## Verdict

`ida\db\jobs\SUB_FINAL\SUB_FINAL.i64` carries every H8 and H10 repair and is a **fixed point**. Pass 1 changed 2,799 items and 754 functions. Passes 2 and 3 each changed **0 items and 0 functions** and performed 0 actions.

The DB now has:

- 172,723 instruction heads in `FFED0000`–`FFF50A00`
- **0 decoded edges into the middle of an instruction**
- 0 code heads outside a function
- all **40/40** relative switch tables, with IDA's case list equal to H8's edges
- 0 violations of the three RX encoding traps

Applying the repairs exposed three premises that were wrong:

1. **H10's −98 B is wrong.** The 49 wave-2 `60 40` "slivers" are entries of a pointer table. Each start appears as an aligned LE32 slot in `FFED7990`–`FFED7E8C`.
2. **H10 missed 30 more out-of-phase heads.** Its closure tests only where an edge *lands*, not how far the decoded instruction *extends*. One of the 30 is reached only from dead code.
3. **H10's list of 54 orphans includes a 7th function** whose true head lies inside a lane-4 body function. That function is `FFF2A6D1`, which runs on into `FFF2A7FC`.

Recounted under the existing rule, the figures are:

| Figure | Before | Now | Delta |
| --- | --- | --- | --- |
| **SUB window code** | 464,166 | **464,263 / 524,288 = 88.55 %** | **+97** (−1, +98) |
| Reachable-only companion | 454,630 | **457,462** | +2,832 |
| All-well-formed companion | 467,999 | 467,999 | 0 |
| Code+typed | 520,455 | **520,552 (99.29 %)** | +97 |

The overall decompile headline becomes 961,402 / 1,029,972 = **93.34 %**. Every change is reconciled to the byte below.

## Method

All IDA work ran through `run_job.py` against `SUB_FINAL`. Every script wraps its body in try/except, calls `auto_wait`, writes UTF-8 and ends with `qexit(0)`. The whole build was run three times from a fresh `--copy-from`, and the final run is the one reported.

| Script | Role |
| --- | --- |
| `ida\jobs\i2_state.py` | Read-only dump of segments, functions with chunks, window items, switch infos and code xrefs (`raw\state_<tag>\`). |
| `ida\jobs\i2_h10fix.py` | Verbatim port of `h10_phase.py` with its outputs redirected, plus an export of H10's FIX head set and byte masks. On the seed copy it reproduces H10 **byte-identically**: `closure_cmp.txt`, `repairs.tsv`, `fix_new.tsv`, `fix_lost.tsv`, `rej2.tsv`, `reach_only.txt`, `orphan_probe.tsv` and `indirect.tsv` all `cmp` equal. |
| `ida\jobs\i2_plan.py` | Builds the frozen plan from H8's and H10's TSVs on the unrepaired copy: `target-heads.tsv`, `func-plan.tsv`, `retype.tsv`, `overlap-fakes.tsv`, `w2-pointer-entries.tsv`. |
| `ida\jobs\i2_phasecheck.py` | Phase check of the plan before applying it, and of the DB afterwards: every decoded flow, branch and DB code xref must land on a head start. |
| **`ida\jobs\i2_apply_sub_final.py`** | The reusable, idempotent apply job (steps below). One run is one pass. It records each pass's item and function delta. |
| `ida\jobs\i2_recount.py` | Recount, mask reconciliation, sanity checks and the function index. Read-only. |
| `ida\jobs\i2_query.py` | Spot dumps used for the citations below. |

**Seed choice.**

- `H8_SUBGAP` and `H10_SUB` were both read-only lanes ("no instructions or functions were created in the DB").
- `H10_SUB` contains none of the repairs (`raw\state_seedH10\`):
  - the out-of-phase item `FFEEC134 a3 c5` sits inside `sub_FFEEC0D3`
  - `FFEDB081` is code but not a function
  - the sliver `sub_FFF0F05B` (`FFF0F05B`–`FFF0F05D`) is a function
  - only 8 switch infos are present
- Neither seed is a better base. I kept the default `H10_SUB`, because the H10 port reproduces exactly on it.

**Apply steps (`i2_apply_sub_final.py`).** Each step tests the DB first, so a second run changes nothing.

1. Move the RES/DENSE segment split from `FFEE0000` to `FFEDAB4C`, the first code byte after the `.data` images. Without this, IDA could not decode H8's hand-decoded `FFEDFFFD`.
2. Delete planned functions:
   - 68 whose start is not a true head
   - 18 wave-2 rejects with no call or pointer reference
   - the 105 "merge" bodies

   Each removed lane-4 start gets a comment `I2: lane-4 function start sub_X removed/merged…`.
3. Undefine every window code head that is not a target. That is 276 heads:
   - H10's 108
   - I2's 30
   - `FFEE0000`
   - 47 non-validated IDA items lying across H8's code-conflict and fragment bytes
   - 90 code items inside published data
4. Create every target head (540 created).
5. Type the data:
   - the three `.data` images as byte arrays `dinit_src_1217E`, `dinit_src_12570` and `dinit_src_68514`
   - the DTBL and BTBL as dwords `initsct_dtbl`/`initsct_btbl` (`FFED8A34`–`FFED8A70`)
   - the pads
   - `jpeg_dezigzag` u8[64], `idct_cos_q14` u32[7] and u8[12] at `FFF508F8`–`FFF50960`
   - 25 retype runs in published data
6. Set switch info for the 32 sites IDA lacked, and verify each with `calc_switch_cases` against H8's 643 edges.
7. Pointer xrefs: 2,146 aligned pointer slots in published tables and H8 tier-2 sites become dwords, and IDA turns them into offsets (drefs).
8. Functions:
   - create the H8 entries, the dead orphans and the residue stubs
   - merge entries that fall into a body nobody else references
   - attach each unowned head by flow, jump, call or pointer evidence
9. Run `plan_range` plus `auto_wait` over the window, then measure.

**Scope.** All of `FFED0000`–`FFF50A00` (window plus the past-window block). Functions are indexed for the whole DB.

**Not done.**

- No function purposes were assigned.
- Lane-4 split functions were not restructured (Open 1).
- The published data regions were typed only where IDA had decoded them as code, or where they hold pointer slots. 34,618 B of them stay unexplored; they are inside the typed mask.

**Files.**

| Path | Contents |
| --- | --- |
| `ida\out\sub-final\counts.txt` | The recounted figures. |
| `ledger-delta.tsv` | Byte-level ledger changes against H10. |
| `mask-diff.tsv` | Every byte run that differs between masks. |
| `functions.tsv` | The function index. |
| `switches.tsv` | The 40 switch tables. |
| `sanity.txt` | Results of the sanity checks. |
| `target-heads.tsv` | 172,723 heads with their class. |
| `func-plan.tsv` | The function plan. |
| `overlap-fakes.tsv` | The 30 extra out-of-phase heads. |
| `w2-pointer-entries.tsv` | The 49 wave-2 entries and their pointer slots. |
| `retype.tsv` | The published-data retype runs. |
| `dinit-code-pointers.tsv` | Header only (Finding 7). |
| `raw\apply_pass{1,2,3}{.txt,_changes.tsv,_delta.tsv}` | Per-pass logs, actions and deltas. |
| `raw\h10fix\` | H10 reproduction, plus `mask_fix.bin` and `mask_reach_only.bin`. |
| `raw\mask_final_*.bin` | The final byte masks. |
| `raw\ida-deleted-case-functions.txt` | The 192 functions IDA absorbed into switches. |
| `raw\state_seedH10\`, `raw\state_final\` | State dumps before and after. |

## Findings

All byte cites below were re-read from `decrypted\FT3D_SUB_ver102_ALL.bin` in Python.

### 1. Pass deltas and the fixed point (Confirmed)

| Pass | Items +/changed | Items − | Functions + | Functions − | Functions ~ | Actions |
| --- | --- | --- | --- | --- | --- | --- |
| 1 | 2,799 | 247 | 207 | 383 | 164 | 1 segment move, 276 undefines, 540 heads, 2,146 pointer dwords, 32 switch infos, … (`apply_pass1.txt`) |
| 2 | 0 | 0 | 0 | 0 | 0 | none |
| 3 | 0 | 0 | 0 | 0 | 0 | none |

The function count went from 4,264 in the seed to **4,088**:

- −68 starts that are not true heads
- −18 unreferenced wave-2 rejects
- −105 bodies merged into their real entry
- −192 functions that IDA itself absorbed into switch functions once the tables were correct
- +207 created

The 192 are 170 lane-4 "rejected" and 22 lane-4 "body" starts, all at H8 switch-case targets. None of them has a call xref or an aligned LE32 pointer. The code heads after every pass equal `target-heads.tsv` exactly: 0 extra, 0 missing.

### 2. 30 out-of-phase heads H10 did not see (Confirmed)

**27 extent overlaps.** H10's `push()` rejects an edge only if its *target* lands inside a validated byte. A reached head whose decoded length runs over a validated head start passes the test. 27 validated heads are like that (`overlap-fakes.tsv`). Every case is H10's pattern P: the operand byte `6e` was read as `pushm`, or a gap byte was skipped.

| True instruction (reached by flow) | Fake lane-4 heads it covers |
| --- | --- |
| `FFEDEC76 c5 fe 6e 6e` = `mov.b 6E[r15],6E[r14]`, after `FFEDEC74 4b 1f` | lane-4 function start `FFEDEC78 6e 6e` "pushm r6-r14" |
| `FFEF3613 3d 13 10` (mov.w #10h,6[r1]), then `67 03` rtsd, after `FFEF3611 a8 09` | the 1-byte heads `13`/`10`/`03` of `sub_FFEF34EF` |
| `FFF4C846 dd 6e 27`, target of `bpz.b` at `FFF4C83F 26 07` | `6e 27` |
| `FFF0C165 fb 22 6e ab f4 ff` | `6e ab` / `f4 ff` |
| `FFF23FAC 05 6e ad 00` bsr.a | `6e ad` / `00` |
| `FFF2CB41 05 6e 19 00` | `6e 19` / `00` |

**3 more from dead code.** Dead orphan `FFF2A6D1` ends `… FFF2A7F9 a0 09 | FFF2A7FB 2e 7e`. Its `beq.b` at `FFF2A7EE 20 0f` targets `FFF2A7FD`. The true decode is `2e 7e` bra.b, `a9 8c`, `72 41 0c 10`, resyncing at `FFF2A803`. This makes lane-4 body `FFF2A7FC 7e a9` (and the heads at `FFF2A7FE` and `FFF2A800`) out of phase: `FFF2A7FC` is a mid-instruction split of dead code.

**One more.** `FFEE0000 cd 01 00` (lane-4 "rejected" function) is the tail of `FFEDFFFD fb e2 d4 cd 01 00`.

Byte effect:

- The 27 overlaps move 0 B, because the union of bytes is unchanged.
- `FFF2A7FC` costs **−1 B**. That byte is now the second byte of an instruction that starts in dead code, outside any validated range.

### 3. The 49 wave-2 `60 40` entries are pointer-reached: H10's −98 B reversed (Confirmed)

All 49 starts (`w2-pointer-entries.tsv`) occur as aligned LE32 slots in the published layout tables `FFED7990`–`FFED7E8C`. For example, `FFED7990 = 5b f0 f0 ff` points at `FFF0F05B 60 40 | 60 40 f8 05 1f`, and `FFED7994 = 91 f0 f0 ff` points at `FFF0F091`.

- H8's tier-2 scan ignored them because they were validated heads at the time.
- H10 dropped the rejects from its roots, and its reach-only pointer roots required `v in valid_fix`, which excludes them. So nobody tested them.

Under H8's tier-2 rule (aligned data site, target outside data, decodes to a stop) they are credited code: **+98 B**. These are exactly the 98 bytes in H10's `fix_lost.tsv`, and none of them is in `mask_fix.bin`.

In the DB each one is now the function entry, with the former lane-4 body merged in. For example, `sub_FFF0F05B` covers `FFF0F05B`–`FFF0F091`, 54 B.

**Related.** Wave-2 reject `FFF0FEFA 71 00 f0` is called 7 times (e.g. `FFF0F16B 05 8f 0d 00` bsr.a → `FFF0FEFA`). It is now the entry of `sub_FFF0FEFA`, and lane-4 `sub_FFF0FEFF` is merged into it. Only the 18 wave-2 rejects with no call and no pointer (the argument-block splits) were deleted.

### 4. `FFEDFFFD` (Confirmed)

The segment boundary at `FFEE0000` cut `fb e2 d4 cd 01 00`. With the split at `FFEDAB4C`, IDA decodes `FFEDFFFD mov.l #1CDD4h,r14` and `FFEE0003 f8 e6 01 mov.l #1,[r14]`. H8's 9 hand-counted bytes are now ordinary DB heads (0 B change in the headline).

`sub_FFEDFEB9` (called from `FFEDFA82`) now runs to `FFEE0006` and falls through into lane-4 body `sub_FFEE0006` (`fb e2 c4 24 01 00`).

### 5. Switch tables, and an IDA trap (Confirmed)

All 40 sites carry switch info, and `calc_switch_cases` equals H8's targets on 40/40 (`switches.tsv`).

**Trap: the jump-table element size lives in the flags.** (J32, JSIZE) = 00 means 2-byte and 01 means 1-byte. IDA's own 1-byte tables carry `0x802600` (VERSION, SIGNED, JSIZE, ELBASE). A first build that set JSIZE on 2-byte tables produced bogus case xrefs on 27 sites. For example, `FFEDC64B → FFEDC5EB` landed inside an instruction, and the phase check reported 108 mid-instruction edges. The job now verifies the cases before creating xrefs and deletes stale ones.

Example: `FFF23763 61 91` cmp #9 · `fb e2 8a 83 f4 ff` mov.l #FFF4838A · `fe 51 ee` · `FFF23773 7f 4e`. The table `FFF4838A` holds `84 01 5f 01 …`, so case 0 goes to `FFF23773 + 0x184 = FFF238F7`.

Cases that equal the next address (`site + 2`) get no jump xref in IDA. They are still in the switch info.

### 6. Published-data cleanup (Confirmed)

The seed had 90 code items inside the published data regions, plus 4 functions there. Examples:

- `FFED54AC 6e 3c ef ff 28 3c ef ff e4 b8 ee ff`, a pointer table to `FFEF3C6E`, `FFEF3C28` and `FFEEB8E4`
- `FFF4A4E6 "Connected\0Not Connected\0Connecting\0"`

They are retyped as 28 dwords, 11 C strings and 13 bytes (`retype.tsv`). The 13 B twin `FFF4B077` stays code (dead) inside the pool; the ledger keeps it as typed data, as H8 and H10 did.

### 7. `.data` images (Confirmed / Not found)

DTBL and BTBL are typed, and the three images are typed as byte arrays:

```text
FFED8A34: 64 97 ed ff 4c ab ed ff 14 85 06 00 | fc 8f ed ff 62 97 ed ff 70 25 01 00 | 70 8e ed ff fb 8f ed ff 7e 21 01 00
```

Of the 349 LE32 values inside the images that fall in the window range, **none is 4-aligned at a code head**. Scope: the three images, aligned LE32. No code pointer from `.data` was found, so `dinit-code-pointers.tsv` is empty.

### 8. Recount and reconciliation (Confirmed, `counts.txt`, `mask-diff.tsv`, `ledger-delta.tsv`)

I ran the H8/H10 rule on this DB's own items and xrefs. Roots are the code heads in lane-4 xref/body ranges (wave-2 rejects excluded), clipped to their ranges, plus 256 INTB + 32 EXTB vectors and H8's 141 tier-2 roots. Edges are decoded flow, branch targets, DB code xrefs and H8's switch edges.

| Figure | This DB | Against H10's masks |
| --- | --- | --- |
| Headline as literally rerun | 464,165 | `mask_fix` + H8 9 B: **+0 / −1** (`FFF2A7FC`) |
| + the 49 pointer entries | **464,263** | +98, exactly the 49 two-byte entries |
| Reach-only (H10 §5 rule) | 454,692 | +62 = `FFEDFFFD`–`FFEE003B` (the 9 B pair plus lane-4 body `FFEE0006`–`FFEE003B`, 53 B, now reached by fall-through) |
| Reach-only + 49 entries as roots | **457,462** | +2,770 in 14 runs, each starting at an entry: 98 B of entries + 2,672 B of lane-4 bodies they fall into |
| All-well-formed = DB code outside the typed mask | **467,999** | 0. DB code in the window is 468,012, of which 13 B (`FFF4B077`) lie in the typed pool. |
| Typed mask | 56,289 | = 48,854 published net + 7,435 H8 |
| Code+typed | **520,552** | +97 |

There is no double count. The +98 bytes are 0 in `mask_fix.bin` and are the same bytes H10 subtracted. The +62 and +2,770 are 0 in `mask_reach_only.bin` and lie inside the headline mask. Every window byte is code or typed, so "non-typed non-code" is 0. Headline bytes that are not DB code: 0.

### 9. Sanity checks (Confirmed, `sanity.txt`)

- **Phase.** Of the edges from 172,723 heads (decoded flow, branch targets and DB code xrefs), **0** land mid-instruction and 0 land on non-code bytes. The DB-mode `i2_phasecheck.py` also reports 0.
- **Switches.** 40/40 present and matching.
- **RX traps:**
  - 1,373 `FB` 24-bit `mov.l` immediates: IDA's value equals the sign-extended bytes on all of them (0 mismatches).
  - 10,981 32-bit immediates: 0 mismatches.
  - 4,448 `75 4x`/`75 5x` uimm8 forms: all zero-extended (0 mismatches).
  - 14,645 `mov.l dsp5[Rs],Rd` (`A8`–`AF`): `o_displ` `op.value` equals the byte-decoded displacement × 4 (0 mismatches).
- **Functions.** 4,087 functions start in window+past, all on code heads. 0 code heads lie outside a function.

### 10. Function index (`functions.tsv`: start, end, size, chunks, name, reach, entry_refs, lane4_class)

| Reach class | Functions | Bytes |
| --- | --- | --- |
| reachable (reach-only + 49 roots) | 3,931 | 459,908 |
| credited-unreached (lane-4 body rule only) | 89 | 5,932 |
| dead (residue: 52 H10 orphans, stubs, `FFF2A6D1` callee, twin) | 67 | 4,516 |
| outside-window (`reset_handler` `FFC00000`) | 1 | 60 |

Of the reachable functions, 1,550 have no call, pointer or vector reference at their entry, and 116 more are reached only by jumps. These are lane-4 split points (Open 1).

## How to seed from SUB_FINAL

```text
python "ida/run_job.py" --script ida\jobs\<lane>_x.py --db <YOURDB> --copy-from ida\db\jobs\SUB_FINAL\SUB_FINAL.i64
```

- Segments: `RES FFC40000–FFEDAB4C`, `DENSE FFEDAB4C–FFF50000`. The DENSE start moved from `FFEE0000`.
- Removed or merged lane-4 starts carry a comment `I2: lane-4 function start sub_X …`. Doc citations of an old `sub_X` can be found by searching for it.
- Credited code is `raw\mask_final_headline_w2.bin`, one byte per window address (1 = credited). Residue heads are the `res-*` rows of `target-heads.tsv`.
- To rebuild the DB from scratch, run these steps in order:
  1. `i2_h10fix.py` with `--copy-from ida\db\jobs\H10_SUB\H10_SUB.i64`
  2. `i2_plan.py --reopen`
  3. `i2_apply_sub_final.py --reopen --env I2_PASS=1`, then again with `I2_PASS=2` to confirm 0
  4. `i2_recount.py --reopen`

  Each run takes seconds.
- IDA rewrites the `.i64` on every reopen. At hand-off its sha256 was `884f2474…`, but content checks, not file hashes, are the reference.

## USB relevance

None changes. Every repair concerns UI, screen and dispatch code or data typing:

- argument blocks
- `6e` operand phase slips
- pointer-table entries in the layout tables
- switch cases
- the `.data` images and JPEG tables

No new code was created outside H8's and H10's reached and residue sets: the DB's code heads equal `target-heads.tsv`. The settled SUB negatives (USB0 dark, no SUB-side SDR or DSP path) now rest on a DB where 464,263 B are credited and 0 edges are out of phase. **Confirmed** within the window.

## Open

1. **Lane-4 split functions.** 1,666 reachable functions have no call, pointer or vector reference at their entry. They are fall-through or jump continuations, for example `sub_FFEE0006` after `sub_FFEDFEB9`, and `FFEE003B`, which is a jump target from `FFEDFF87`. Merging them would fix function bounds, but it renames `sub_` labels that other docs cite, so it needs an orchestrator decision. The data needed is in `functions.tsv` (`entry_refs`).
2. **Adopt the corrected figures:** headline 464,263 (+97) and reach-only 457,462. The literal rerun without the w2 correction is 464,165.
3. Type the remaining 34,618 B of published data (layout tables `FFED3F6C`–`FFED8A70`, string pool) into records. Counts are unaffected.
4. `FFF2A6D1` plus `FFF2A7FC`–`FFF2A87F` is one dead routine. The 89 credited-unreached functions (5,932 B) are the residue of the mixed standard. A strict headline would use 457,462.
