# 69 — The one-descent MAIN seed MAIN_FINAL3 (Lane J1)

> Lane J1, model `claude-opus-4-8`. Owner-side static analysis of `decrypted\FT3D_MAIN_ver102_EXP.bin`
> (MAIN, H8SX `h8sxa`, base 0, big-endian, so file offset = mapped address; sha256 prefix
> `8e3ecd05409b2c31`, unchanged). No image byte was modified (no `patch_*`), and nothing was connected
> to or written to any radio or device. Only my own DB `ida\db\jobs\J1_MAIN_FINAL3\J1_MAIN_FINAL3.i64`
> was opened; it was seeded with `--copy-from ida\db\jobs\MAIN_FINAL2\MAIN_FINAL2.i64`, which only reads
> that seed. The closed window `0x078106`–`0x07B753` was not analysed; its 99 code heads are snapshotted
> and restored, and no byte inside it is credited. Tables are in `ida\out\main-final3\`; the reusable job
> is `ida\jobs\j1_apply_main_final3.py`; the offline mask builder/verifier is
> `ida\out\main-final3\offline\j1_build_masks.py`.

## Verdict

**Yes — 368,366 B of proven MAIN code reproduce from one descent, and MAIN_FINAL3 is a true fixed point
with 0 odd heads.** Folding I15's record-field callback rule into H9's descent alongside the I6/I8/I9
rules that MAIN_FINAL2 already carries, a single `run("full", …)` descent reaches exactly the addend
union H9∪I6∪I8∪I9∪I15 — **0 bytes beyond the union and 0 union bytes unreached** — giving the one-descent
subtotal **365,570 + 1,544 + 116 + 66 + 1,136 + 54 = 368,486 B**. All ten pairwise addend intersections
are 0 B (reproducing `main-final2\overlaps.tsv` and extending it to I15), and I15 is disjoint from H9's
proven mask. Applying I12's −120 B demotion of the two unreachable USB-function-ISR blocks — re-confirmed
unreachable by a whole-image scan (0 BE32 pointers in, 0 jsr/jmp abs24 or bcc/bsr from outside either
block, and the single descent reaches 0 of their bytes) — gives **MAIN proven = 368,486 − 120 = 368,366 B**,
which matches the target to the byte. The resulting DB carries all 368,366 proven bytes as DB code
(0 proven bytes that are not code), has 0 odd code heads, and a `--reopen` pass changes **0 functions,
0 heads, 0 code bytes, 0 xrefs** (identical layout hash `94a9409905dcc048`). **Open sub-question: nothing
zeroes `0xFFA9E0`** — see Findings 5.

Figures: **MAIN proven 368,366** (72.845 % of 505,684 content B; 94.82 % of 388,490 decodable). **MAIN
named/typed 497,314** (= FINAL2 497,280 + I15 34; the 120 demoted bytes stay typed code, so named does not
fall).

## Method

Everything below was run this session; the two IDA passes went through `run_job.py` only.

### 1. Offline mask build + verification — `ida\out\main-final3\offline\j1_build_masks.py`

Plain Python, read-only on every input. It imports H9's `descent.py` and `analyze.py` unchanged (never as
`__main__`, so they write nothing), rebuilds H9's proven (365,570) and named (497,139) masks the way I9/I14/I15
did, and asserts the proven mask equals `ida\out\main-final\h9_proven_mask.bin` byte for byte. Then:

- **Per-lane addend masks** (bytes newly reached beyond H9's full reach of 363,758 B): I6 1,544, I8c 116,
  I8x 66, I9 1,136 — each re-derived through H9's unchanged descent from its edge seeds, and asserted equal
  to the published counts. I15's +54 is loaded from `descent-ext\new-bytes.tsv` (the four `beyond_all=1`
  runs) and byte-checked against the image.
- **Overlaps.** All ten pairwise intersections among {I6, I8c, I8x, I9, I15} = 0; each addend ∩ H9-proven =
  0; each addend ∩ closed-window = 0 (`overlaps.tsv`).
- **One descent.** `COMBINED = I6 exit entries + I8 (0x034CCE, tier-X 0x327E/0x328A/0x329C, 3 immediates) +
  I9 (records 0x0296E8/0x029712 fields, RAM-hook 0x000706, er1 cb 0x01A084) + I15 (all strict-gated Rule A/B
  edges from `descent-ext\new-edges.tsv`)`. A single `D9.run("full", extra_seeds=COMBINED)` is differenced
  against H9's baseline reach: newly-reached = 2,916 B, **beyond the addend union = 0, union not reached = 0**.
- **Proven mask.** `PROV3 = H9_proven ∪ (single-descent new bytes) \ I12_blocks`; `sum(PROV3)=368,366`,
  asserted equal to `final2_proven_mask.bin ∪ I15(54) \ I12(120)`.
- **I12 re-confirmation.** A whole-image scan: every BE32 word that lands inside either block, and every
  oracle `flow()` edge (jsr/jmp abs24, bcc/bsr 8/16) from outside the block that targets it. Result: 0 and 0
  for both blocks. The single descent reaches 0 bytes of either block (`i12-unreachable.tsv`).
- **0xFFA9E0 writers.** Every oracle instruction in the whole image (including the closed window) that names
  `0xFFA9E0`, plus a raw scan for the immediates `FFA9E0`/`00FFA9E0` (`ffa9e0-writers.tsv`).

### 2. Seed build — `ida\jobs\j1_apply_main_final3.py`

Idempotent, two rounds per pass, `--copy-from MAIN_FINAL2` then `--reopen`. It never runs a broad re-plan,
calls `auto_wait()` only after its own targeted edits, snapshots/restores the 99 closed-window heads, and
sweeps odd heads. It applies only I15's rule (the I6/I8/I9 edits are inherited intact from MAIN_FINAL2):

- **Type** record fields `0x028C3E`,`0x028C46` (record `0x028C2A` +0x14/+0x1C) and `0x028C9E`,`0x028CA6`
  (record `0x028C8A` +0x14/+0x1C) as dword offsets, with a user dref to each target.
- **Create code** tiling the two new handler stubs `0x028C4A` (16 B, 5 insns) and `0x028CAA` (18 B, 6 insns).
  The two 10-B handlers `0x02A924`/`0x02A9F4` are already correct code + functions in FINAL2; `make_run` is a
  no-op on an already-correct run, so their functions are preserved (net function delta 0).
- **Add crefs** from the dispatcher's two `jsr @er6` sites: `0x028D8C` (+0x14) → `0x02A924`,`0x02A9F4`;
  `0x028DA8` (+0x1C) → `0x028C4A`,`0x028CAA`.
- **I12 demotion is a proven-mask overlay, not a DB edit.** The 120 bytes stay disassembled DB code, exactly
  as FINAL2 keeps the proven mask a separate overlay from the DB code mask; the job asserts they remain code.

**Not done / scope.** I did not re-prove the fnindex A addend (it is carried, as in H9/I14); I credited
nothing beyond the five lane rules; I did not enter the closed window; I did not rename the new stubs or
force them into standalone functions (they fall inside the record-passer function `0x028B62`, which is
cosmetic and does not affect the mask or the fixed point).

## Findings

### 1. Rule-by-rule proven ledger (`ledger.tsv`)

| Term | Δ | Value |
| --- | ---: | ---: |
| MAIN proven code, H9 (== `h9_proven_mask.bin`) | | 365,570 |
| + I6 exit-table `0x019A9E` (exit-table rule) | +1,544 | |
| + I8 `0x034CCE` (helper-store / exit-slot rule) | +116 | |
| + I8 tier-X `0x003272` (tier-X load-site rule) | +66 | |
| + I9 three edges (records / vec-88 hook / er1 cb) | +1,136 | |
| + I15 record-field callback rule (`0x028C2A`/`0x028C8A` +0x14/+0x1C) | **+54** | |
| **one-descent union** | **+2,916** | **368,486** |
| − I12 demotion (unreachable ISR blocks `0x054D22`–`4B`, `0x054F3A`–`87`) | −120 | |
| **MAIN proven code, FINAL3** | | **368,366** |

All six addends are mutually disjoint and disjoint from H9's proven mask, so the union equals the sum; the
−120 demotion removes bytes that are in H9's proven mask (via the fnindex A addend) and in no addend, so the
subtraction removes exactly 120. Named/typed: 497,139 (H9) + 141 (I6/I8/I9, per I14) + 34 (I15
`0x028C4A`+`0x028CAA`) = **497,314**; the demoted bytes stay typed code.

### 2. I15's +54 B (Confirmed; `final3_proven_runs.tsv`, build log)

Dispatcher `0x028CBC` (`mov.w @0xBBC2:16,r4`, a key-indexed `cmp.w #k,r4; beq` ladder) calls each selected
field as `mov.l @(d:16,er1),er6; jsr @er6`, with the record passed in `er1`. Records `0x028C2A` and
`0x028C8A` carry two handler fields that nothing else reaches:

| Record | field | cell | target | len | decode (to rts) |
| --- | --- | --- | --- | ---: | --- |
| `0x028C2A` | +0x14 | `0x028C3E` | `0x02A924` | 10 | `bsr 0x2A92E; beq; jsr @0x29C56; rts` |
| `0x028C2A` | +0x1C | `0x028C46` | `0x028C4A` | 16 | `jsr @0x2A92E; beq; mov.b @0xBC82; jsr @0x1A58C; rts` |
| `0x028C8A` | +0x14 | `0x028C9E` | `0x02A9F4` | 10 | `bsr 0x2A9FE; beq; jsr @0x29C56; rts` |
| `0x028C8A` | +0x1C | `0x028CA6` | `0x028CAA` | 18 | `jsr @0x2A9FE; beq; mov.l er5,er1; mov.b @0xBC82; jsr @0x1A58C; rts` |

In FINAL2, `0x02A924`/`0x02A9F4` were already 10-B code functions (uncredited); `0x028C4A`/`0x028CAA` were
data. MAIN_FINAL3 now has all four as DB code with the dispatcher crefs and record-field drefs applied.

### 3. I12 −120 B demotion, re-confirmed unreachable (Confirmed; `i12-unreachable.tsv`)

| Block | len | BE32 ptr in | flow from outside | note |
| --- | ---: | ---: | ---: | --- |
| `0x054D22`–`0x054D4B` | 42 | 0 | 0 | vec-238 EE2F pulse, skipped by `40 2a` at `0x054D20` |
| `0x054F3A`–`0x054F87` | 78 | 0 | 0 | vec-235 EP3 report writer, sits after the `rte` at `0x054F38` |

Scope: every even address in `0x000000`–`0x078105` and `0x07B754`–`0x07B753` (i.e. all content outside the
closed window) decoded by the oracle, plus every BE32 word over the whole content. The only `flow()` edges
into block 2 originate *inside* block 2 (`0x054F66`→`0x054F74`, etc.) — internal branches of a
self-consistent but externally unreachable routine. No external branch, call, abs24 jump, or pointer reaches
either block, and the one-descent reaches 0 of their bytes. Both blocks were proven only through H9's
carried fnindex A addend; the demotion is correct. They remain disassembled in the DB (demotion is a
proven-mask overlay).

### 4. MAIN_FINAL3 DB state and fixed point (`MAIN_FINAL3_log.txt`)

| Pass | funcs | heads | code B (scope) | odd | xrefs from code | layout hash |
| --- | ---: | ---: | ---: | ---: | ---: | --- |
| seed (MAIN_FINAL2) | 5,442 | 124,076 | 390,474 | 0 | 177,856 | `867a8a0a…` |
| `build` (copy-from) | 5,442 | 124,087 | 390,508 | 0 | 177,877 | `94a94099…` |
| `verify` (`--reopen`) | **5,442** | **124,087** | **390,508** | **0** | **177,877** | **`94a94099…`** |

The reopen DELTA is `funcs=+0 heads=+0 codebytes_scope=+0 odd=+0 xrefs_from_code=+0 hash_same=True
win_same=True` — a true fixed point. Build added 11 heads (the two new stubs: 5 + 6 insns) and 34 code
bytes (16 + 18), 4 crefs and 2 drefs. The closed-window head hash `6ff215a0…` is unchanged. **All 368,366
proven bytes are DB code (0 not-code).**

### 5. Who zeroes `0xFFA9E0` (tier-X slot 0)? — nobody (Confirmed; `ffa9e0-writers.tsv`)

Across the **whole image, including the closed window**, exactly four instructions name `0xFFA9E0`:

| Addr | Access | Instruction |
| --- | --- | --- |
| `0x00325E` | read | `mov.b @0xa9e0:16,r3l` (the tier-X dispatch index load) |
| `0x003284` | write | `mov.b r4l,@0xa9e0:16` (r4l = 1, from `0x003282 fc 01`) |
| `0x003296` | write | `mov.b r4l,@0xa9e0:16` (r4l = 2, from `0x003294 fc 02`) |
| `0x0032BA` | write | `mov.b r4l,@0xa9e0:16` (r4l = 1, from `0x0032B8 fc 01`) |

The immediates `FFA9E0` and `00FFA9E0` appear **nowhere** in the content (raw scan, 0 occurrences), so no
pointer-indirect store (`mov.l #0xFFA9E0,erN; mov.b …,@erN`) can exist, and no block-clear covers it: the
boot RAM-clear loop (`0x002132`–`0x002150`) runs `mov.l #0xFEE000` … and clears only `0xFEE000`–`0xFF72FF`,
which ends well below `0xFFA9E0`. **Conclusion: `0xFFA9E0` has no zeroing writer anywhere; its only writers
store 1 or 2.** Tier-X slot 0 (value 0 → `0x00327E`) is therefore selected only from the power-on/indeterminate
state of this RAM byte before the first `1`/`2` store. This corroborates I14 Open 2: strictly, the +12 B of
slot 0 (`0x00327E`–`0x003289`) rest on an Inferred power-on value, not a Confirmed clear. The tier-X table
itself and slots 1/2 remain Confirmed (the FINAL2/I14 decision to credit tier-X stands); only slot 0's
initial-value assumption is Inferred. No correction to the credited 66 B is warranted — it is carried under
the one-descent union exactly as FINAL2 credited it.

### 6. Correction to prior docs

- **doc 64 (I12) Open 6 / `usb-vendor\ledger-delta.tsv`.** The proposed −120 B demotion is now **applied** in
  MAIN_FINAL3's proven mask (it was "proposed, not applied"). Re-confirmed unreachable here by an independent
  whole-image scan.
- **doc 65 (I14) Open 1.** Satisfied: I15's rules are folded into one descent so 368,432 (and now 368,366)
  reproduces from a single `run("full", …)`, not from hand-applied patches.
- No factual claim in docs 64/65/66 is contradicted; this lane only applies two pending deltas and answers
  the `0xFFA9E0` sub-question.

## USB relevance

No mission answer changes. The ±bytes are UI/application code, not USB transport:

- **I15 +54 B** is the key-dispatch family on `0xFFBBC2` (handlers `0x02A924`/`0x02A9F4` → `jsr @0x29C56`;
  `0x028C4A`/`0x028CAA` → `jsr @0x2A92E`/`@0x2A9FE` and `@0x1A58C`). None falls in USB `0xFFEE00`–`0xFFEE53`,
  SCI-C `0xFFFF88`, or the closed window (I15 §2, re-confirmed by the overlap/window asserts here).
- **I12 −120 B** is genuinely dead USB-function-ISR code: block 1 an `EE2F` pulse in vector 238 that is
  branch-skipped, block 2 an EP3 interrupt-report writer in vector 235 that sits past an `rte`. Removing them
  from the proven count makes the USB stack's *reachable* surface slightly smaller and sharper; it removes no
  live USB behaviour (both were already Confirmed unreachable in doc 64 §2). The live vendor/CDC USB paths are
  untouched.
- The `0xFFA9E0` finding is a 3-state key-hold machine (`0x00327E`–`0x0032BF` on `0xFFA9E0`/`0xFF9536`), not a
  USB path.

MAIN_FINAL3 is the recommended seed for the next MAIN lane: it carries every I-wave proven delta
(`--copy-from ida\db\jobs\J1_MAIN_FINAL3\J1_MAIN_FINAL3.i64`).

## Open

Most valuable first:

1. **Name the `0x028CBC` key-dispatch family and its key source `0xFFBBC2`** (I15/I14 Open). Identifying
   what `0x29C56`/`0x2A92E`/`0x1A58C` do would attribute the eight 32-byte records and let the save-handler
   screens be named. This is the largest remaining *named* (not proven) gain on MAIN.
2. **Settle tier-X slot 0's initial value.** If a future pass shows `0xFFA9E0` is read before any `1`/`2`
   store on a path that depends on its being 0, slot 0 (`0x00327E`–`0x003289`, 12 B) stays credited; if not,
   demote those 12 B to Inferred. Requires tracing the callers of the dispatch at `0x00325E`.
3. **Resolve the remaining `jmp/jsr @ERn` sites** H9 left (its Open 1) and the er3/er4/er6 `@(d,ERn)`
   dispatchers (I15 Open 2); these are the ceiling for further proven gains on MAIN.
4. **Attach the new stubs** `0x028C4A`/`0x028CAA` as standalone functions rather than tails of `0x028B62`,
   and classify the DB code outside the proven mask (I14 Open 3). Cosmetic; moves no headline.

### Files (`ida\out\main-final3\`)

| File | Content |
| --- | --- |
| `final3_proven_mask.bin` | per-byte proven mask over `0..0x7B754` (505,684 B; 368,366 set) |
| `final3_named_mask.bin` | per-byte named/typed mask (497,314 set) |
| `ledger.tsv` | the rule-by-rule byte ledger (Findings 1) |
| `overlaps.tsv` | all addend pairwise intersections (all 0), I15∩H9, I12∩{H9,addends} |
| `final3_proven_runs.tsv` | the 928 contiguous runs of the proven mask |
| `i12-unreachable.tsv` | the whole-image unreachability scan for both I12 blocks |
| `ffa9e0-writers.tsv` | every instruction naming `0xFFA9E0` (whole image) |
| `MAIN_FINAL3_codemask.bin`, `MAIN_FINAL3_functions_raw.tsv`, `MAIN_FINAL3_log.txt`, `build_log.txt` | DB dumps and pass logs |
| `offline\j1_build_masks.py` | the offline mask builder/verifier |

Job: `ida\jobs\j1_apply_main_final3.py`. DB: `ida\db\jobs\J1_MAIN_FINAL3\J1_MAIN_FINAL3.i64`; logs in
`ida\log\jobs\J1_MAIN_FINAL3\`.
