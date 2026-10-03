# L-wave ledger and citations, re-derived from disk (lane M13)

> Lane M13, model `claude-opus-5-5`. Owner-side static analysis only. Read-only on every input. No image byte
> was modified: sha256 `8e3ecd05409b2c31…` (MAIN) and `b93570b3c2f69ccb…` (SUB) were re-checked at the start and
> again at the end. Nothing was connected to or written to a radio or any device. One private DB,
> `ida\db\jobs\M13_REVERIFY_MAIN\M13_REVERIFY_MAIN.i64`, was copied from `L1_MAIN_FINAL5` and only read
> (`ida\jobs\m13_db_check.py`). Tables are in `ida\out\ledger-reverify-l\`.

## Verdict

**The L-wave ledger reproduces exactly from first principles.** I re-ran K1's folded descent with an
independent driver. It imports H9's `descent.py` unchanged and re-implements the K1a/K1b rules myself; it does not
use `recon_descent.py`. As a check on the driver, it rebuilds `final4_proven_mask.bin` byte for byte
(`h9_proven | descent − I12`). From that one descent I derived, without reading the orchestrator's outputs:

- the 94 fnindex-only runs (4,850 B), identical to `main-final4\fnindex-only-runs.tsv`;
- the 108 B recovered by the 6 new edges, identical to `rec_runs.tsv`;
- the 4,742 B / 89-run drop set, identical to `drop_runs.tsv`;
- **final6 proven = final5 − drop + the 36 hand-restored bytes = 364,786.**

The final6 proven mask is byte-identical to `final6_proven_mask.bin` (sha `ecd7deaf54da6d21`). A second derivation
reaches the same mask: final5 − (fnindex-only bytes not reached by a descent seeded with all **8** entry points).
That shows the 36 B restore is exactly what the 8-entry descent reaches.

**Named.** final5 named | L5's 522 Confirmed rows (3,337 B) = **501,656**, byte-identical to
`final6_named_mask.bin` (`fe8f60996e0a5852`).

**final5.** L1's masks equal final4 − `0x054AE2`–`0x054BF7` + the 868 window bytes, byte for byte. I derived
those 868 bytes independently as doc 95's 336 heads minus final4 proven: 13 ranges.

**Invariants.** Proven ⊆ named holds in final4, final5 and final6. No mask has a byte set at or above
`0x07B754`. The per-lane split is exactly **884 / 2,532 / 1,012**. The headline re-derives as
**965,919 / 1,029,972 = 93.78 %**.

**Checks.** 165 ledger checks pass, 0 fail. The seed DB's fingerprint matches L1's: layout hash
`42111f94aa98d911`, 5,463 functions, 124,367 heads, 336 window heads.

**Citations.** I graded **1,110 byte citations** from docs 98–112, `RESUME-FULL.md` lines 12–216 (the L wave)
and `l-wave-recon\README.md`:

| Result | Count |
| --- | ---: |
| Pass | **1,098** |
| Right bytes, wrong address | **10** |
| Fail as written | **2** |
| Cannot be checked | 0 |

The 1,098 passes include 10 deliberate erratum quotes in docs 110/111, 3 jsr encodings and 2 runs inside a
routine. Of the 10 wrong addresses, 5 are the L7/L9 slips the RESUME already lists; I confirm them.

Of 371 count and table checks from the lanes, 8 fail. One of those is substantive. **Doc 105:187: UHF sub-band
5 begins at 300.000 MHz, not 230** (`0x035144` = `30 00 00 00`). Nothing below 300 MHz in the UHF table maps to
index 5. A second is a real but local slip: doc 109's two SUB TX-buffer addresses are 0x8000 too high
(`0x1C33A` / `0x1C3BA`, not `0x2433A` / `0x243BA`).

No discrepancy touches a credited byte, the ledger or a mission answer.

**Re-runs.** Every offline checker the L lanes left was re-run from a scratch copy, 75 rows in all. Each run
reproduces its published output, apart from three explained differences:

- `recon_descent.py` writes the mask *before* the 36 B hand restore. Its output differs from the published mask
  in exactly those 36 bytes.
- L1's `ledger.tsv` was extended by hand after its script ran. The script prints `72.97%%`.
- L3's `runs.tsv` differs only in line endings (CRLF vs LF).

This lane credits **0 B** of proven and **0 B** of named. It proposes nothing new.

## Method

All scripts are in `ida\out\ledger-reverify-l\`. All are plain Python except one read-only IDA job.

1. **`m13_ledger.py` → `counts_ledger.tsv`, `ledger-log.txt`, `m13-descent-runs.tsv`,
   `m13-after-drop-edges.tsv`** (196 rows: 165 PASS, 31 INFO).
   - **Masks.** Hashes, lengths, value sets, popcounts and subset relations for all six masks.
   - **final5.** Rebuilt from final4 plus the window ranges, which are derived from
     `service-window\code-heads.tsv`.
   - **Descent.** Four folded descents: with fnindex seeds; without them; without them plus the 6 L2/L4 edges;
     without them plus all 8 entries.
   - **Per-lane split.** Split by address (L2 below `0x030000`, L3 below `0x050000`, L4 the rest) and reconciled
     against each lane's `runs.tsv` class totals.
   - **Byte evidence.** For each entry point, a whole-image scan of BE32, abs24, `mov.l #imm` and rel8/rel16
     edges into `0x033780` and its stubs, and the README's "check after the drop" as a byte-level edge scan from
     final6-proven bytes.
   - **Named and headline.** L5's residue and typing tiers, the SUB `headline_w2` mask, and every sum and
     percentage.
2. **`ida\jobs\m13_db_check.py` + `m13_dbcmp.py` → `db\fingerprint.txt`, `db\dbstate.bin`, `counts_db.tsv`.**
   - L1's fingerprint formula, recomputed on a copy of the seed.
   - A per-byte code/data/head/function dump compared with the masks.
3. **`m13_citations.py` + `m13_manual.py` (`m13_manual_a/b/c.py`) → `citations.tsv`, `coverage.tsv`.**
   - The grading engine is adapted from L13's `l13_citations.py`: exact match, then ±8 B, then a whole-image
     search.
   - **Automatic extraction:** 360 graded rows.
   - **Manual list: 784 entries**, which yield 760 graded rows; the rest are drop and regrade entries. They
     cover table cells, wrapped spans, BE32/LE32 claims, ASCII strings and SUB addresses. Docs 98–103 + RESUME
     + README: 316 entries (`m13_manual_a.py`). Docs 104–108: 308 (`_b`). Docs 109–112: 160 (`_c`).
   - **Dropped (10):** frame notation, RAM operands, and positional lists the extractor mis-paired. Every
     mis-paired pair was re-cited one by one.
   - **Coverage:** 446 in-scope lines carry a hex run. 372 are cited. Each of the other 74 is notation, a value
     list or a count line, and the count lines are checked in step 4.
4. **`m13_counts_a/b/c.py` → `counts_a/b/c.tsv`.** Whole-image pattern counts, table decodes and arithmetic
   behind docs 98–112 and the RESUME (345 rows).
5. **`m13_rerun.py` → `rerun_a.tsv`, `rerun-log.txt`** (L1, L2, L3, L5, L6, orchestrator).
   - Each published lane directory was copied to scratch. Every path to that directory, and to the lane's old
     scratchpad, was rewritten.
   - Scripts ran with `PYTHONDONTWRITEBYTECODE=1`. Every file a run rewrote was compared byte for byte.
   - Published directories were hashed before and after the runs: all unchanged.
   - `rerun_b.tsv` covers L8 and L10. `rerun_c.tsv` covers L13, L14 and L15.
6. **`m13_summary.py` → `counts.tsv`** (581 rows) **and `rerun.tsv`** (75 rows).

**Scope limits.**
- IDA-only lane products were not re-run: L5's `apply_typing` and L6/L7/L9/L11/L12/L15 dumps.
- `l13_rerun.py` was not re-run, because it re-runs K1's builder, which step 1 already reproduces.
- Inferred roles were not re-derived.
- Mnemonic-only claims with no bytes were graded only where a manual row gives the encoding.

## Findings

### 1. Ledger (`counts_ledger.tsv`, 165/165 PASS)

| item | re-derived | expected |
| --- | ---: | ---: |
| final4 / final5 / final6 proven | 368,624 / 369,214 / **364,786** | same |
| final4 / final5 / final6 named | 497,451 / 498,319 / **501,656** | same |
| sha256 final5 P/N, final6 P/N | `0d5492ce5de1500b` / `0bff9e2d27f9c121`, `ecd7deaf54da6d21` / `fe8f60996e0a5852` | README |
| final4 → final5 | −278 at `0x054AE2`–`0x054BF7` only; +868 in 13 ranges `07810C`–`07815B` … `078514`–`078545`; masks byte-identical to my rebuild | doc 98 |
| doc 95 heads | 336, tile `0x078106`–`0x078546`, 1,088 B, hex = image; H1_RECOUNT window code 318 B → 770 omitted | 389,260 |
| K1 driver check | (h9_proven ∪ folded descent) − I12 == final4 proven | byte-identical |
| fnindex-only (P4 ∧ with-fn ∧ ¬without-fn) | 4,850 B, 94 runs, == `fnindex-only-runs.tsv` | 94 / 4,850 |
| recovered by 6 edges | 108 B (== `rec_runs.tsv`) | 108 |
| drop | 4,742 B / 89 runs (== `drop_runs.tsv`); 4,464 still in final5; contains the 36 restored | 4,742 |
| 8-entry descent | reaches exactly the 36 B beyond the 6-edge run; final5 − (FO ∧ ¬M8) == final6 | byte-identical |
| per lane | L2 884, L3 2,532, L4 1,012; = runs.tsv totals 938−54, 2,532, 1,380−90−278 | 884/2,532/1,012 |
| L4 1,012 | 358 DEAD + 338 SPLIT-TAIL (696) + 26 data + 290 WINDOW-ONLY (`0x077CC2` 206, `0x07778C` 84) | README |
| REACHED rows | L2 54 + L4 90 = 144 = 108 + 36 | 144 |
| proven but descent-unreached | 1,692 B, 80 runs, == `proven-unreached-runs.tsv`; largest `05C8DC` 218, `0460C2` 110, `03D0EE` 98 | README |
| callers `06AB1C 06AB2A 06AB36 06AE04 06AE10 062808 06723A` | all P4 = 1, descent = 0 | README |
| proven ⊆ named; bytes ≥ `0x07B754` | 0 violations; 0 bytes; image tail all `FF` | 0 |
| L5 residue | 7,365 B, disjoint from final5 named, union = 505,684 | same |
| Confirmed tier | 522 rows, 3,337 B, inside residue, no overlap; L6's 28 B inside it, clear in final5 | same |
| unnamed after final6 | 4,028 = 3,934 Inferred + 51 fill + 43 (`0x069A7F`–`0x069AA9`) | same |
| SUB window code | 464,263 (`mask_final3_after_headline_w2.bin`) | same |
| headline | 501,656 + 464,263 = 965,919 / 1,029,972 = 93.78 %; MAIN named 99.20 %; proven 72.14 % of content, 93.71 % of 389,260 | same |

**Byte evidence for the 8 entries (Confirmed).**

- **er1 callbacks.** There are 14 sites of `5e 01 52 06` in the image, and `0x015224` = `5d 10`. Each new er1
  callback is `7a 01 00 <T>` followed by `5e 01 52 06`, at final6-proven `0x018276`, `0x018AD2`, `0x018BE8` and
  `0x05E862`.
- **abs24 jsr callers** (all final6-proven):
  - `0x066FB4`: from `062808`, `06723A`, `06AB1C`, `06ADF6`.
  - `0x067250`: from `06280E`, `06AB24`, `06ADFE`.
  - `0x066FBE`: from `06AB36`, `06AE10`.
  - `0x06726A`: from `06AB2A`, `06AE04`; `062814` is not proven.
  - Also `bsr` `55` at `0x067246` → `0x06726A`.
- **`0x033780`.** It and its stubs `033790` / `0337AC` / `0337C8` have **no** BE32, abs24, `mov.l #imm` or
  rel8/rel16 reference at any offset in `0`–`0x07B754`. Not found; scope: whole content, every offset.
- **Window handler records.** The records at `0x07B4B4` (stride 10) point to `0784BE`, `0769AA`, `0768C8`,
  `0769AA`, `0767BE` and `0768A8`. RESUME:46 names the first three; there are six records.
- **J14's page writer.** `0x03C996` = `58 60 fc ce` → `0x03C668`, its only edge.
- **Skipping branches.** `0x0460C0 40 6e` → `0x046130`, `0x01C27C 40 1a` → `0x01C298`, `0x01D932 40 12` →
  `0x01D946`.

**README "check after the drop", verified** (`m13-after-drop-edges.tsv`). Every decoded edge from final6-proven
bytes into a net-dropped byte falls into one of two groups:

- **35 `mov.l #imm` loads.** Each target is in a run classed DATA-MISTYPED, or is one of L4's four DEAD er5
  handlers `0620A6`, `062178`, `062722`, `067128` (all loaded into er5).
- **6 abs24 jsr.** They are exactly the README's dead companions `0076DA`, `01C28E`, `0460C8`, `0460D6`, `046104`
  and `04612A`. None is reached by the 8-entry descent. Their bytes are in H9's proven mask by its analyze rules,
  which is Open item 2.

**Seed DB (`counts_db.tsv`).**

- **Fingerprint.** Byte-identical to doc 98 / `MAIN_FINAL5_log.txt`: `funcs=5463 heads=124367
  codebytes_scope=390660 win_heads=336 odd=0 xrefs_from_code=178254 hash=42111f94aa98d911`.
- **Code mask.** The DB code mask equals `MAIN_FINAL5_codemask.bin`. Neither final5 nor final6 proven has any
  byte outside DB code.
- **Demoted range.** `0x054AE2`–`0x054BF7` is **278/278 B** DB code. L1's log line "86/278 bytes" counted heads
  (`is_code` on tail bytes is false), as doc 98:73 already explains.
- **The 8 entries** are code heads and function starts in the seed.
- **Named is a ledger overlay, not DB typing.** 77,228 final5-named bytes are neither code nor data in the
  seed. Of the 3,337 B final6 additions, 1,294 are code, 521 data and 1,522 unexplored. The MAIN_FINAL6 seed
  must apply L5's typing before it can require "named == DB-typed".

### 2. Citations (`citations.tsv`, 1,110 graded + 10 dropped)

| doc | rows | pass | other |
| --- | ---: | ---: | --- |
| 98 | 8 | 8 | |
| 99 | 88 | 88 | |
| 100 | 81 | 80 | 1 fail (1 within-routine pass) |
| 101 | 37 | 35 | 2 wrong address |
| 102 | 69 | 69 | |
| 103 | 107 | 107 | |
| 104 | 21 | 19 | 2 wrong address |
| 105 | 99 | 98 | 1 fail |
| 106 | 48 | 44 | 4 wrong address |
| 107 | 161 | 160 | 1 wrong address |
| 108 | 38 | 38 | |
| 109 | 51 | 51 | |
| 110 | 71 | 71 | incl. 2 erratum quotes, 2 encodings, 1 within |
| 111 | 79 | 79 | incl. 8 erratum quotes, 1 encoding |
| 112 | 71 | 70 | 1 wrong address |
| RESUME 12–216 | 64 | 64 | |
| README | 18 | 18 | |
| **total** | **1,110** | **1,098** | 10 wrong address, 2 fail |

**Errata (owning docs not edited).**

*A. Right bytes, wrong address (10).*

| doc:line | as cited | image at cited address | true address |
| --- | --- | --- | --- |
| 104:164 | `0x073E88` `5e 03 4a 52` | `4a 52 fc 01` | **`0x073E86`** (RESUME slip, confirmed) |
| 104:164 | `0x073E90` `5e 03 50 e4` | `50 e4 fc 00` | **`0x073E8E`** (RESUME slip, confirmed) |
| 106:130 | `0x0743BC` `fc 01 6a 8c b0 cc` | `6a 8c b0 cc 40 12` | **`0x0743BA`** (RESUME slip, confirmed) |
| 106:153 | `0x030242` `fc 05 6a 8c aa ce` | `6a 8c aa ce fc ff` | **`0x030240`** (RESUME slip, confirmed) |
| 106:153 | `0x031CD4` same | same | **`0x031CD2`** (RESUME slip, confirmed) |
| 106:151 | store `0x031BEE` (FF9589) | `fc c8 6a 8c 95 89` | the store `6a 8c 95 89` is at **`0x031BF0`** (`0x031BEE` is the immediate; `0x03013C` correctly names the FF9578 store) |
| 107:119 | `0x00FAFE` `6a 10 89 20 73 00 46 0c` | `6a 0c 89 bb 47 14` (VOX test) | **`0x00FB04`** |
| 101:99 | `0x062962` er5 overwrite `7a 05 00 ff b3 2e` | `7a 05 00 06 21 78` (load of handler `0x062178`) | **`0x062972`**; the conclusion holds |
| 101:104 | interior BE32 `0x0006460E` at `0x01D33E` | `6e 0c 00 06 46 0e` | the BE32 starts at **`0x01D340`**, inside that instruction. Not mentioned by the doc: `0x053490` = `000645A8`, inside dead run `0x05343C` |
| 112:84 | `usb_isr_main` `0x054D50` `6a 0c 81 3a 58 60 01 4c` | `01 10 6d f4 6a 0c 81 3a` | **`0x054D54`**, 4 B after the entry (`c-recon\citations.tsv` cites the full run from `0x054D50` correctly) |

L7's third RESUME slip, "the table load at `0x073A34`", is not an error in doc 104. `0x073A34` =
`78 b0 6b 26 00 07 44 72`, and doc 104 gives only the correct range `0x073A28`–`0x073A3C`.

*B. Fails as written (2).*

- **105:187 (substantive).** The doc says "UHF: 230–419.995 and 420–579.995 MHz → 5, 6". The table at
  `0x035140` is `00 0a 00 02 | 30 00 00 00 41 99 95 00 00 05 | 42 00 00 00 57 99 95 00 00 06`. **Index 5 is
  300.000–419.995 MHz.** 230–299.995 MHz has no UHF entry. The VHF table at `0x03510A` matches the doc exactly
  (40/108/120/174/222 MHz → 0–4).
- **100:126.** `0x3F5B2` "`6d 62 6d 63 01 00 69 64`" is not contiguous. The image is `01 00 6d f2 6d 62 79 0a 00 00
  6d 63 01 00 69 64`; the doc drops the push and `mov.w #0,e2`. The instructions it names are present.

### 3. Counts and tables (`counts_a/b/c.tsv`, 345 rows: 327 PASS, 8 FAIL, 10 INFO)

| doc:line | claim | image |
| --- | --- | --- |
| 105:187 | UHF sub-band 5 from 230 MHz | 300 MHz (above) |
| 109:100–101 | TX buffers `0x2433A` / `0x243BA` | `mov.l #12D44h,r14` (`fb e2 44 2d 01 00`) + disp `95F6` / `9676` (`FFEDD539 c9 0e 0f f6 95`, `FFEDD70C c9 0e 0f 76 96`) = **`0x1C33A` / `0x1C3BA`**. Lane table `sub-frames-sub\builders.tsv` FE row: `0x2443A` → **`0x1C43A`** |
| 107:280 | 12CB8 = 2 at `FFF38627`/`FFF3865A`; = 1 at `FFF38F7B` | incomplete: = 2 also at `FFF387B6`; = 1 at `FFF38759`, `FFF388EB`, `FFF38F75` (`FFF38F7B` is the `mov.w` inside the `FFF38F75` site) |
| 104:126 | "3 references, all in 0x0739xx" | `073996` (0x0739xx), `073A28`, `073A70` (0x073Axx). The three sites are right |
| 103:78 and RESUME:179 | "the image has 301 `rts/l` and 251 `rte/l`" | not reproducible in any scope: oracle even addresses 181/73, all addresses 654/530, final4-proven heads 23/0, IDA code heads 47/0. Unknown which scope was meant |
| RESUME:127 | "three `fb e2 a0 22 01 00` sites" | that literal pattern occurs **22** times in SUB; the stores of 3 (`… f8 e4 03`) are exactly 3: `FFF392C3`, `FFF3935D`, `FFF3943C` (doc 107's claim passes) |

**Notes (INFO, not errors).**
- 101:54 "13 genuine callers" leaves out the dead `0x017576`; there are 14 er1 sites.
- 102:154: 870 + 31 = 901 B against a 903 B class; 2 B are not itemised.
- 109:150: one mnemonic stands for two writers. `FFEDC2A6` is `ca 1e 17 80 c9 84` (`8017h` → `84C9h`).
- Doc 112's "~370 lines" against 809 in the three C files.
- The 0x20 row of K4's `dsp-autoreply\b0b9-census.tsv` gives the store (`0x06CAFA`) where its header promises
  the immediate (`0x06CAF8`).

**Everything else re-derives.** Examples:
- 32 AAD5 stores with values {0,1,2,3,5,`0x0D`–`0x14`}.
- Both 21-entry tables, with states 6–`0x0C` = `rts`.
- 48 `off_74472` handlers.
- One B0B8 store, `0x05C442`.
- 10 SUB→MAIN start-byte compares ending at `rts` `0x047658`.
- 101 build sites, and 36 SCI0 `#imm24` loads.
- FSM `0x055002`: 5 = 1 and 10 = 7.
- All 65 `c-recon\citations.tsv` rows.
- L14's 61/24/46 tables.
- 195 pending zones = 154 + 38 + 3.

### 4. Re-runs (`rerun.tsv`, 75 rows)

| lane | script(s) | result |
| --- | --- | --- |
| L1 | `l1_build_masks.py` | both masks and `final4-to-final5-diff.tsv` identical. `ledger.tsv` differs as explained: the script writes the literal `72.97%%` (a wrong value: 369,214/505,684 = 73.01 %) and no percentage block. The published file has 73.01 % / 98.54 % and 6 extra rows, added after the script ran |
| L2 | `l2_reach` → `l2_back` → `l2_refs` → `l2_emit` → `verify` | `runs.tsv`, `proposed-demotions.tsv` and `proposed-seeds.tsv` identical; `backward-closure.txt` and `inbound-scan.txt` = scratch `back_lo.txt` / `refs_lo.txt` |
| L3 | `l3_edges` → `l3_classify` | 6 outputs identical (including both pickles); `runs.tsv` identical after CRLF → LF |
| L5 | `l5_features` → `evidence` → `classify` → `emit` → `review` | 9 outputs identical; residue sha `0d453850c6a36595` |
| L6 | `keytable`, `pages`, `zones`, `check_open` | 4 outputs identical |
| orch | `recon_descent.py` | `drop_runs.tsv` and `rec_runs.tsv` identical. `final6_proven_mask.bin` differs in exactly the 36 bytes `0x066FBE`–`0x066FC7` + `0x06726A`–`0x067283` (script 0, published 1): the script stops before README step 4 |
| L8 | `tx-states\build_tables.py` | "32 55"; `states.tsv` and `transitions.tsv` identical |
| L10 | `accessory-ptt\verify.py` | 185/185; `verify.tsv` identical |
| L14 | `l14_errata_check.py` | 61/61, 24/24, 46/46; 4 outputs identical |
| L13 | `l13_ledger`, `l13_counts`, `l13_citations` + `l13_summary` | ledger 152/152 and counts identical. Citations differ only in RESUME rows: the L-wave section was inserted above the K-wave text, so 28 anchors in "lines 1–320" moved. With those rows frozen, the outputs are byte-identical |

All published lane directories hashed identical before and after the runs.

## USB relevance

None of the three mission answers changes. Every USB-bearing citation in the L wave passes on bytes:
- L15's ISR, FSM and EP1 copy-loop runs, apart from the 4 B entry slip at 112:84;
- doc 108's ten start-byte compares and the absence of any USB path in the SUB→MAIN frames;
- doc 109's SCI0 sites;
- the USB-module demotion of `0x077CC2` / `0x07778C`, whose only callers sit in `0x033780`, which is referenced
  nowhere in the image.

The 105:187 band-table correction concerns TX sub-band bookkeeping, not USB. It does not change the SDR "no"
(Q2) or the DSP reach (Q3).

## Open

1. **MAIN_FINAL6 seed.** Build it as the README recipe says.
   - The masks are now independently confirmed.
   - Make the 36 B restore part of the script: seed the 8 entries in `recon_descent.py`, so its output equals
     the published mask without a hand step.
   - Apply L5's typing before claiming named == DB-typed. 1,522 of the 3,337 new named bytes are unexplored in
     the seed today.
2. **Errata for the owning docs** (not edited here):
   - 105:187 → UHF index 5 = 300–419.995 MHz.
   - 109:100–101 → `0x1C33A` / `0x1C3BA`, and `builders.tsv` FE → `0x1C43A`.
   - 107:280 → the full 12CB8 writer list.
   - 101:99 → `0x062972`; 101:104 → `0x01D340`; 112:84 → `0x054D54`; 107:119 → `0x00FB04`; 106:151 → store
     `0x031BF0`.
   - 100:126 → the full byte run.
   - 104:126 → "0x0739xx / 0x073Axx".
   - 103:78 and RESUME:179 → state the scope of 301/251 or drop the figures.
   - RESUME:127 → "three `… f8 e4 03` stores".
   - RESUME:46 → six handler records, not three.
3. **The 1,692 B / 80 runs of proven-but-unreached bytes** (README Open 2), now including the six dead
   companions confirmed above.
4. **Reproducibility.**
   - `l1_build_masks.py` should write the ledger that was published.
   - L3 should write with `newline="\n"`.
   - `l13_citations.py` should anchor RESUME by section, not by line range.

### Files (`ida\out\ledger-reverify-l\`)

| file | content |
| --- | --- |
| `m13_ledger.py` → `counts_ledger.tsv`, `ledger-log.txt`, `m13-descent-runs.tsv`, `m13-after-drop-edges.tsv` | 196 ledger rows (165 PASS / 31 INFO) |
| `..\..\jobs\m13_db_check.py`, `m13_dbcmp.py` → `db\`, `counts_db.tsv` | seed fingerprint and DB-state comparison |
| `m13_citations.py`, `m13_manual.py`, `m13_manual_a/b/c.py` → `citations.tsv`, `coverage.tsv` | 1,110 graded citations (+10 dropped), 446 coverage lines |
| `m13_counts_a/b/c.py` → `counts_a/b/c.tsv` | 345 count, table and arithmetic checks |
| `m13_rerun.py` → `rerun_a.tsv`, `rerun-log.txt`; `rerun_b.tsv`, `rerun_c.tsv` | re-runs |
| `m13_summary.py` → `counts.tsv` (581 rows), `rerun.tsv` (75 rows) | combined tables |
| `m13_selfcheck.py` → `selfcheck.tsv` | the 52 byte citations written in this doc, re-read from the images: 52/52 pass |

Model: claude-opus-5-5.
