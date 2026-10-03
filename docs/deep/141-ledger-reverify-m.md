# M-wave ledger, checkers and citations, re-derived from disk (lane N14)

> Lane N14, model `claude-opus-5-5`. Owner-side static analysis of firmware files already on disk. Read-only on every
> input. No IDA was run and no database was opened, because none of the re-run checkers is an IDA script. Nothing was
> connected to or written to any radio or device. Image hashes were checked at the start and again at the end:
> MAIN `8e3ecd05409b2c31…`, SUB `b93570b3c2f69ccb…`. Tables are in `ida\out\ledger-reverify-m\`.

## Verdict

**The M-wave ledger reproduces exactly, and so does every published M-wave checker.**

**Masks.**
- `final7_proven_mask.bin` holds **365,358** set bytes (sha `5585a9c6d810d964`).
- `final7_named_mask.bin` holds **505,165** set bytes (sha `0bcf995b1087e723`).
- Both are 1,048,576 B of 0/1 values, with nothing set at or above `0x07B754`, and proven ⊆ named.
- I re-derived every ledger term from the lane tables, independently of `m_recon.py`: −1,472 (M2 368 + M3 574 +
  M4 530), −72 cascade, +390 (M6), +1,726 (M7), and named +3,509 (M5 ∪ M6 ∪ M8).
- Each term matches the FINAL6 → FINAL7 mask difference byte for byte: **74/74 PASS**.

**Re-runs.** M1, M7, M8, M9, M11, M12, M14, M15 and the orchestrator's `m_recon.py` were re-run from scratch copies:
- Every byte checker gives the published count: 48/48, 66/66, 129/129, 58/58, 165/165, 342/342, 59/59 and 97/97.
- Every output file is byte-identical, with two explained exceptions:
  - **M14.** Its text checks anchor into `RESUME-FULL.md` by fixed line number, and those lines moved by +239 when
    the M-wave section was inserted. With a frozen RESUME, all 4 outputs are byte-identical.
  - **M15.** One log line prints a dict in hash-seed order. The values are equal under 4 seeds.
- All 9 published lane directories hash identical before and after the runs.

**Citations.** I graded 670 byte citations from docs 113–127, the RESUME M-wave section and the m-wave-recon README:

| Result | Count |
| --- | ---: |
| Pass | **664** |
| Right bytes, wrong address | **6** |
| Fail | **0** |

The 6 wrong addresses are 4 distinct slips. Only one is new and outside a lane doc: the orchestrator's own
`0x06ADE4`, in both the README and the RESUME.

**Counts.** 39 of 42 count and table checks pass. 2 fail, for one claim: doc 120's "79 `6a 8c bb e1` stores" is 76
in the image. 1 is INFO: doc 120's `AAD7 = 1` site table leaves out a sixth store at `0x036016`.

No discrepancy touches a credited byte, the ledger or a mission answer.

**This lane credits 0 B. Proven delta 0, named delta 0.**

## Method

All scripts are in `ida\out\ledger-reverify-m\`. Every one is plain Python.

1. **`n14_ledger.py` → `counts_ledger.tsv`** (74 PASS, 1 INFO).
   - **Masks.** Hashes, lengths, value sets, popcounts, the `0x07B754` ceiling and the subset relations, for final6
     and final7. M1's `main-final6` masks are `cmp`-equal to `l-wave-recon`'s.
   - **Diff runs.** FINAL6 → FINAL7, compared run for run with `final6-to-final7-diff.tsv`.
   - **Proven terms.** The M2/M3/M4 demotion bytes come from each lane's `proposed-demotions.tsv`. The 72 B cascade
     is what is left outside them. M6 core + companion come from `proposed-proven.tsv`. The six CDC handler BE32s are
     read at `0x07B4B4 + 10k + 6`.
   - **Named terms.** M5, M6 and M8, with their overlaps and union. The stale copy is checked as held out.
   - **Percentages.** The headline, and the M15 conventions B–E.
   - **The 52 B `0x0771AE`–`0x0771E1`.** A whole-content scan for every abs24 jsr/jmp, even BE32 value, bsr8/16 and
     bcc8/16 into the range.
2. **`n14_rerun.py` → `rerun.tsv`, `rerun-log.txt`.** The harness pattern is M13's.
   - Each lane directory was copied to my scratchpad, and paths to it were rewritten in the copied `*.py`.
   - Scripts ran with `PYTHONDONTWRITEBYTECODE=1`. Every rewritten file was compared byte for byte with the
     published one.
   - Published directories were hashed before and after.
   - Remaining references to a published directory were read by hand. All are comments, except one read of
     M15's `runs.tsv`, whose content is identical.
3. **`n14_rerun_m14_frozen.py`.** M14 re-run against a scratch copy of `docs\deep` whose `RESUME-FULL.md` drops lines
   12–250, the M-wave section.
4. **`n14_rerun_m15_seed.py`.** M15's `m15_analyze.py` re-run under `PYTHONHASHSEED` 0–3.
5. **`n14_citations.py` + `n14_manual.py` → `citations_strict.tsv`, `coverage.tsv`.**
   - The engine is M13's, unchanged apart from scope: docs 113–127, `RESUME-FULL.md` lines 13–250, and the
     m-wave-recon README.
   - The manual list (64 entries) does three things. It drops 7 extractor mis-pairings and re-cites them at the run
     start. It regrades erratum quotes in 125/126 and two within-instruction cases. It adds wrapped spans and
     fenced listings.
6. **`n14_loose.py` → `loose.tsv`.** For each backticked byte run the strict pass did not grade, it tries every
   address on the same line and the previous line. 180 rows.
7. **`n14_review.py` → `citations.tsv`, `counts.tsv`, `summary.tsv`.**
   - Every LOOSE-NEAR and UNPAIRED row has a written verdict.
   - Each `PASS-WITHIN` names the address where the run was re-read, and the script byte-checks it again.
   - The same script runs the 42 count and table checks.
8. **`n14_selfcheck.py` → `selfcheck.tsv`.** Every byte citation in this doc: 45/45.

**Scope limits.**
- Only the checkers named in the assignment were re-run. Lane scripts outside them were not re-run: `punr-*`,
  `dead-code-tier`, `inferred-tables`, M10's `gen\`, M7's C files, and the IDA jobs.
- Inferred roles were not re-derived.
- Mnemonic-only claims with no bytes were not graded.
- Coverage: 497 in-scope lines carry a hex pair run. Every one has a graded row, except 10 that are notation or the
  continuation of a span graded on the line before.

## Findings

### 1. Ledger (`counts_ledger.tsv`)

| item | re-derived | published |
| --- | ---: | ---: |
| final7 proven / named | **365,358** / **505,165** | same |
| sha256 final7 P / N | `5585a9c6d810d964` / `0bcf995b1087e723` | `masks-sha256.txt` |
| final6 proven / named (both copies) | 364,786 / 501,656, `main-final6` == `l-wave-recon` | same |
| proven removed / added | 1,544 = 1,472 + 72 / 2,116 = 390 + 1,726 | same |
| M2 / M3 / M4 demotions | 368 / 574 / 530, all removed | same |
| cascade | `066FB4`–`066FC7` + `067250`–`067283` = 72 B. All four leaves are P7 = 0, N7 = 1 | README |
| M6 core + companion | 390, equal to the non-CDC additions | same |
| CDC handlers | BE32s `0784BE 0769AA 0768C8 0769AA 0767BE 0768A8` (`0x07B4BA 00 07 84 be` …); 1,778 new, 1,726 credited, `0771AE`–`0771E1` not | same |
| named +3,509 | M5 2,880 ∪ M6 635 ∪ M8 27. M5 ∩ M6 = `018FAA`–`018FAF`, and M8 ⊂ M6. The union equals the named difference exactly | same |
| stale copy | `069A7F`–`069AA9` (43 B), unnamed in final7. Its first 37 B equal `0x069964` (`6a 0c b3 f5 …`) | held |
| unnamed | 519 | same |
| percentages | 72.25% / 93.86% / 99.90% / headline 969,428 = 94.12%; incl. stale 505,208 = 99.91% | same |
| M15 conventions | B 94.48%, C 99.59%, D 99.95%, E 822,700 = 79.88%; SUB `headline_w2` = 464,263 | same |
| diff table | 279 rows, run for run equal to `final6-to-final7-diff.tsv` | same |

**The 52 B `0x0771AE`–`0x0771E1` (Not found at any instruction head; scope `0`–`0x07B754`).**
- A raw scan finds no abs24, BE32, bsr8 or bsr16 edge into the range.
- It does find two bcc8 byte patterns: `40 70` at `0x077142` and `40 60` at `0x077158`. Both are mid-instruction,
  inside the 6-byte heads `0x077140 01 5d 40 70 fd 62` and `0x077156 01 5d 40 60 fd 62` of the M1 seed
  (`MAIN_FINAL6_heads.tsv`).
- So the README's "no inbound edge" stands. The orchestrator's scan did not list bcc, and these two coincidences are
  now on record.

### 2. Re-runs (`rerun.tsv`, 81 rows)

| lane | script(s) | result |
| --- | --- | --- |
| M1 | `m1_build_masks`, `m1_verify_bytes`, `m1_plan`, `m1_func_changes`, `m1_gap_edges` | masks equal the published L-wave masks. 11 outputs IDENTICAL. Citations 48/48. 5,463 → 5,340 functions, 0 unexplained |
| M7 | `verify.py` | 66 cites, 0 mismatch |
| M8 | `m8_verify.py` | 129/129; `tones.tsv` and `sensor.tsv` IDENTICAL |
| M9 | `verify.py` (cwd = workspace root) | 58/58 |
| M11 | `verify.py` | 165/165; `verify.tsv` IDENTICAL |
| M12 | `verify.py` | 342/342; `verify.tsv` IDENTICAL |
| M14 | `m14_errata_check.py` | 59/59 byte+computed; `bytecheck.tsv` IDENTICAL. Live RESUME: source-line checks 12/20 and index 39/40, so `errata.tsv` / `index.tsv` / `run.txt` differ. **Frozen RESUME: 20/20, 40/40, all 4 outputs IDENTICAL** |
| M15 | `m15_verify`, `m15_masks`, `m15_analyze` | 97/97. 6 tables IDENTICAL. `raw\analyze_log.txt` line 20 differs only in dict order; equal under seeds 0–3 |
| orch | `m_recon.py` | both final7 masks, the diff table, the hashes and the log IDENTICAL |

Detail on the M14 drift:
- M14 anchors 9 quotes at RESUME lines 97, 117 and 265.
- The same quotes now sit at lines 336, 356 and 504: the 239 lines of the M-wave section moved them. No checked
  byte changed.
- The RESUME's "tables byte-identical" for M14 holds against the RESUME as it stood before the M-wave insertion.

### 3. Citations (`citations.tsv`, 670 graded + 60 not graded)

| doc | graded | pass | wrong address |
| --- | ---: | ---: | ---: |
| 113 | 34 | 34 | |
| 114 | 9 | 9 | |
| 115 | 82 | 82 | |
| 116 | 12 | 11 | 1 |
| 117 | 72 | 72 | |
| 118 | 74 | 74 | |
| 119 | 13 | 13 | |
| 120 | 60 | 60 | |
| 121 | 17 | 15 | 2 |
| 122 | 15 | 14 | 1 |
| 123 | 64 | 64 | |
| 124 | 50 | 50 | |
| 125 | 43 | 43 | |
| 126 | 72 | 72 | |
| 127 | 32 | 32 | |
| README | 2 | 1 | 1 |
| RESUME M-wave | 19 | 18 | 1 |
| **total** | **670** | **664** | **6** |

**What the passes include.**
- 598 exact matches.
- 49 within-routine runs. These are written "`addr … bytes`", as a sequence, or as "range contains", and each is
  re-read at a named address.
- 13 erratum quotes in 125/126: M13 and M14 quoting older slips as written.
- 4 pattern rows (e.g. `6a 8X 95 6d` at 11 sites).

**Not graded (60):** 32 search patterns of count claims (graded in `counts.tsv`), 13 notations (frame types, value
lists), 10 dropped mis-pairings, 4 runs with no address that are present in the image, and 1 duplicate.

**Right bytes, wrong address (6 rows, 4 slips):**

| where | as written | image at that address | the bytes are at |
| --- | --- | --- | --- |
| README:22 and RESUME:36 | `0x06ADE4 0c cb 58 70 00 28 eb 07 5e 06 ac d6 58 00 00 1e` | `00 2e 0c cb`: the tail of the 4-B `0x06ADE2 58 60 00 2e` (seed head, size 4) | **`0x06ADE6`** (**new**) |
| 121:132 (2 rows) | `0xFFF394CF`/`0xFFF39516 75 41 e5` | `05 59 40 fa` / `05 12 40 fa` (the bsr.a calls) | **`FFF394CC` / `FFF39513`** (−3). M9's own `verify.py` already uses these. **New** |
| 116:85 | `0x062808` (`40 16 5e 06 6f b4 40 10 5e 06 72 50 …`) | `5e 06 6f b4 …` (the jsr) | the run starts at **`0x062806`** (−2, listing convention). **New** |
| 122:117 | `0x063C04` (`fc 0a 6a 8c a9 f9`) | `fc 00 6a 8c b2 a3` | **`0x063C10`**. RESUME:186 already lists it; confirmed |

**Fails as written: none.**

### 4. Counts and tables (`counts.tsv`, 42 rows: 39 PASS, 2 FAIL, 1 INFO)

**FAIL, doc 120:221.** The doc says "Scope: 79 `6a 8c bb e1` stores".
- MAIN `0`–`0x07B754` holds **76** `6a 8c bb e1`, plus 1 `6a 8e bb e1` at `0x067748`, for **77** abs16 byte
  stores to BBE1. There is no abs32 form.
- Neither 76 nor 77 is 79, so the scope as stated is not reproducible.
- The conclusion is unaffected: none of the 76 is directly preceded by `fc a9` (`mov.b #0xA9,r4l`).

**INFO, doc 120:155–163.** The `AAD7 = 1` site table lists `0x034D2C`, `0x035A18`, `0x035A62`, `0x035A9A` and
`0x035B52`, and all five are `fc 01 6a 8c aa d7`.
- A sixth identical store sits at **`0x036016`**, inside `sub_3600E`: `0x03600E 6a 10 b0 bb 73 70 46 08`, that is
  `btst #7,@B0BB ; bne`.
- `sub_3600E` is final7-proven, reached through the BE32 slot `0x035D24 00 03 60 0e`.
- Doc 120 names `sub_3600E` as a reader of AAD9 ("its twin") but leaves it out of the writer table. That is an
  omission; it does not change "no cooldown, no persistent lockout".

**PASS (selection).**
- **Doc 120.** Ten `3c a0`. Ten `aa de` with no abs16 writer. The dispatcher clear `0x03455C fc 00 6a 8c aa d7`.
- **Doc 123.**
  - `91 0a` / `91 0d` / `00 ff 91 0a` = 2 / 0 / 0.
  - Six `81 71`, five `bb e3`, 32 `aa d2`.
  - `00 06 66 00` only at `0x014986` / `0x0149A2`.
- **Doc 124.** `bb 92` once, with the store at `0x0482C8 6a 8c bb 92`.
- **Doc 125.** 14 sites of `5e 01 52 06`.
- **Doc 126.** 11 `6a 8X 95 6d` stores, each after `fc 02`.
- **Doc 118.** B9E4 stores of 3–7 at the five listed sites. 3 readers each of `0D32/0D72/0DB2/0DEA`.
- **Doc 115.** The three `03EFx0` arms.
- **RESUME.**
  - The four class-request compares from `0x076F04 a8 20`.
  - The M8 tone constants: `0x0351E2 79 04 09 89` → 6,552 Hz; `0x000476 79 04 0b a0` → 5,374.5 Hz / 40 =
    134.36 bps; `0x0350C0 79 04 00 47` → 1,736.1 Hz.
  - The lane table sizes:

    | lane | sizes |
    | --- | --- |
    | M2 | 29 runs / 368 B, 1 data |
    | M3 | 22 / 574, with 19 dead, 2 split tails and 1 data |
    | M4 | 16 / 530; 868 + 220 = 1,088 |
    | M5 | 136 / 2,880 |
    | M6 | 310 / 265 / 54 / 43; 425 Inferred, 382 of it in `0x03624B`–`0x0377C1` |
    | M10 | 511 zones |
    | M12 | 5 commands, 7 indications |
    | M15 | 59 runs / 3,736 B |

### 5. Process notes

- `coverage.tsv`'s fourth column holds the reason, not the line text. The same layout is in M13's published file.
  `n14_review.py` reads the docs directly instead.
- M14's line anchors into RESUME, and M13's own RESUME anchors before it, break each time a wave section is
  inserted. Anchoring by section heading would make the re-runs stable.

## USB relevance

None of the three mission answers changes.
- **USB (Q1).** Every USB-bearing M-wave citation passes on bytes. These include the CDC record table
  `0x07B4B4`–`0x07B4F9`, M7's 66 cites, the four class-request compares at `0x076F04`, and the strap-key test
  `0x002200 2c 4c ec 7f ac 7d`.
- **Ledger.** The 52 B `0x0771AE`–`0x0771E1` stays unproven, with no edge at any instruction head.
- **SDR (Q2) and DSP (Q3).** The four slips and the doc 120 count concern a dead-arm example address, a Bluetooth
  link-state sender, a WIRES-X dead arm, a touch-mode store and a popup census. None of them touches SDR or the DSP.

## Open

1. **Corrections for the owning docs** (not edited here):
   - README:22 and RESUME:36 → `0x06ADE6`.
   - 121:132 → `FFF394CC` / `FFF39513`.
   - 116:85 → `0x062806`.
   - 120:221 → 76 `6a 8c bb e1` (+1 `6a 8e`), not 79.
   - 120:155–163 → add `0x036016` (`sub_3600E`).
   - 122:117 → `0x063C10` (already in RESUME:186).
2. **Reproducibility.**
   - `m14_errata_check.py` should anchor RESUME by section text.
   - `m15_analyze.py` should print `sorted(...)` dicts.
   - The citation engine's `coverage.tsv` should write the line text.
3. **Not re-run here:** the `punr-*`, `dead-code-tier`, `inferred-tables` and M10 generators. A later
   re-verification could add them, along with the MAIN_FINAL7 seed check when that seed exists.

### Files (`ida\out\ledger-reverify-m\`)

| file | content |
| --- | --- |
| `n14_ledger.py` → `counts_ledger.tsv` | 75 ledger rows (74 PASS, 1 INFO) |
| `n14_rerun.py` → `rerun.tsv`, `rerun-log.txt` | lane re-runs; `n14_rerun_m14_frozen.py` and `n14_rerun_m15_seed.py` append to `rerun.tsv` |
| `n14_citations.py`, `n14_manual.py` → `citations_strict.tsv`, `coverage.tsv` | strict pass (543 graded + 7 dropped) |
| `n14_loose.py` → `loose.tsv` | loose pass (180 rows) |
| `n14_review.py` → `citations.tsv`, `counts.tsv`, `summary.tsv` | merged grading (670 graded, 60 not graded), 42 count checks, per-doc totals |
| `n14_selfcheck.py` → `selfcheck.tsv` | the 45 byte citations in this doc: 45/45 |

Run order: `n14_ledger`, `n14_rerun`, `n14_rerun_m14_frozen`, `n14_rerun_m15_seed`, `n14_citations`, `n14_loose`,
`n14_review`, `n14_selfcheck`.

Model: claude-opus-5-5.
