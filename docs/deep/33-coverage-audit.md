# Coverage audit — does the 92.3% decompile headline stand? (Lane F6)

Independent re-derivation of `RESUME-FULL.md`'s headline
`Decompile 92.3% = 950,853 / 1,029,972` from the committed on-disk tables.
Owner-side static analysis only; no image modified, nothing written to a radio.
All figures below are re-derivable from named files; the machine table is
`ida/out/coverage-audit/recount.tsv`. Model: claude-opus-4-8.

Scope note: this audits only the **already-committed** state recorded in
`RESUME-FULL.md` and the existing tables. In-flight lanes (main-indirect,
main-raw-other, sub-big, sub-big2, settings) were not read and are not folded in.

## Verdict

**The 92.3% headline is arithmetically reproducible but not methodologically
sound as stated. The defensible figure is ~88.3%.**

Every addend reproduces from disk, and `950,853 / 1,029,972 = 92.32%` recomputes
exactly from the published per-lane figures. But one addend is counted against the
wrong denominator: the SUB side's **41,263 B of lane-10 layout/font data lies
entirely (193 of 193 segments) in `0xFFEB74D8`–`0xFFECE51C`, which is *below* the
`0xFFED0000`–`0xFFF50000` SUB window that the denominator (524,288 B) is defined
as.** Those bytes are real, correctly typed, and non-overlapping with anything
else — but adding them to the numerator while the denominator excludes their
address region inflates the headline. Removing the out-of-window bytes from the
numerator (keeping the published 1,029,972 denominator) gives
`909,590 / 1,029,972 = 88.3%`. Folding the layout region into the denominator
instead gives an even lower ~84.6%. Under no internally consistent accounting does
the 41,263 B support 92.3%.

Two smaller results, neither changing the verdict: (1) a genuine but negligible
**28 B double-count** on the MAIN side (three fnindex-recovered new functions sit
inside runs lane 5 typed as parameter tables); (2) the function byte addends are
**conservative** — the published is_code counts (249,098 MAIN, 438,300 SUB) are
*lower* than my end-start extent re-sums (249,840, 438,439), so they do not
inflate. The companions (MAIN instr 75.3%, SUB window 83.6%, SUB excl-data 93.0%)
all reproduce and are clean; the SUB **window** companion (83.6%) is the honest
SUB number, not the headline's 91.5%.

## Method

Worked from the committed TSV/txt tables with Python (`end-start` interval sums,
merge-and-sweep overlap detection) and awk. Addresses parsed as hex; MAIN base 0
so offset == address; SUB base `0xFFC00000`. Did **not** open any IDA DB: the
headline question is fully decidable from the tables, and the one figure that
would need IDA (the 380,782 is_code recount) is a companion, not a numerator
addend, and already matches the doc-04 baseline (380,620) within 162 B. Script:
`scratchpad/audit.py` (throwaway); results captured in `recount.tsv`.

Files read: `ida/out/fnindex/{main-low,main-high-a,main-high-b}.tsv` and their
`l1_counts/w2_1_counts/w2_2_counts.txt`; `ida/out/wave2/main-raw-types.tsv`;
`ida/out/sub-window/{functions.tsv,coverage.txt}`;
`ida/out/sub-layout/{segments.tsv,records.tsv,layout_status.txt}`;
`ida/out/main-raw/l5_counts.txt`.

## Re-derivation (claimed vs re-summed)

Denominator — **Confirmed.** MAIN content `505,684` (= `0x7B754`; reconciles the
three fnindex content ranges 229,376 + 139,264 + 137,044). SUB window `524,288`
(= `0xFFF50000 − 0xFFED0000`). Total `1,029,972`. All exact.

| Addend | Claimed | Re-summed | Match | Source / note |
|---|---|---|---|---|
| MAIN validated fn **count** | 3,264 | 3,264 | ✅ | 1547 + 899 + 818 validated=yes rows |
| MAIN fn bytes (is_code) | 249,098 | 249,098 | ✅ | l1(100766)+w2_1(80850)+w2_2(67482) |
| MAIN fn bytes (extent) | — | 249,840 | +742 | TSV `sum(end-start)`; is_code excludes 742 B embedded data |
| MAIN typed runs (type≠other) | 222,192 | **222,192** | ✅ exact | main-raw-types.tsv |
| MAIN runs "other" | 4,020 | 4,020 | ✅ | main-raw-types.tsv |
| MAIN runs total | 226,212 | 226,212 | ✅ | main-raw-types.tsv (= l5 raw_total) |
| **MAIN numerator** | 471,290 | 471,290 | ✅ | 249,098 + 222,192 |
| SUB validated fn **count** | 3,850 | 3,850 | ✅ | functions.tsv xref(1602)+body(2248) |
| SUB fn bytes (is_code item-size) | 438,300 | 438,300 | ✅ | coverage.txt (297,232 + 141,068) |
| SUB fn bytes (extent) | — | 438,439 | +139 | functions.tsv `sum(end-start)` |
| SUB layout/font (lane 10) | 41,263 | **41,263** | ✅ exact | segments.tsv `sum(len)`, 193 segs |
| **SUB numerator** | 479,563 | 479,563 | ✅ | 438,300 + 41,263 |
| **Grand numerator** | 950,853 | 950,853 | ✅ | → 950,853/1,029,972 = **92.32%** |

Companions — all **Confirmed**: MAIN instr `380,782/505,684 = 75.3%` (380,782
from `l5_counts.txt`); SUB window `438,300/524,288 = 83.6%`; SUB proved-data-
excluded `438,300/471,440 = 93.0%` (proved data `52,848` = 16236+6292+12912+1024+
16384; `471,440 = 524,288 − 52,848`). All-instruction `467,289/471,440 = 99.1%`.

Head-vs-item caveat (check #4) — **Confirmed internally consistent.**
`438,300 − 154,162 = 284,138`, exactly the measurement-correction figure
`RESUME-FULL.md` attributes to the SUB gain. coverage.txt states both the head-
only prior (154,162, 29.4%) and the item-size figure (438,300, 83.6%) explicitly.

## Double-count check

MAIN — **28 B overlap found** between validated-function ranges and typed runs
(should be disjoint; runs = bytes outside functions.tsv). All three sites are
fnindex-recovered **new** functions (not in the MAIN_FULL functions.tsv that the
runs were cut around), which lane 5 / W2-8 had classified as *parameter table*:

| Site | Bytes | Function (new) | Run type it overlaps |
|---|---|---|---|
| `0x1A25A`–`0x1A260` | 6 | sub_1A25A (lane 1 new) | parameter table (w2-8) |
| `0x1A432`–`0x1A436` | 4 | sub_1A432 (lane 1 new) | parameter table (lane5) |
| `0x63C04`–`0x63C16` | 18 | sub_63C04 (w2_2 new)  | parameter table (lane5) |

These 28 B are counted once in the function addend and again in the run addend —
a real double-count, but 0.006% of the MAIN numerator and 0.003% of the grand
numerator. It also flags a **type disagreement**: fnindex calls these bytes code;
lane 5 called them parameter tables. The other 6 new functions do not overlap
typed runs. (Correcting it drops the headline by <0.01 point.)

SUB — **0 B overlap** between validated functions and layout segments. They are
disjoint by location: functions live in `0xFFED0000`–`0xFFF50000`, layout lives in
`0xFFEB74D8`–`0xFFECE51C`. No double-count — but see Discrepancies: that very
disjointness is the problem, because the layout region is outside the denominator.

## Discrepancies

1. **SUB layout is outside the denominator window (material; this is the
   headline's defect).** `layout_status.txt` and `segments.tsv` agree the lane-10
   content is 41,263 B over 193 segments; I re-summed `sum(len) = 41,263` exactly.
   But every segment lies in `0xFFEB74D8`–`0xFFECE51C`: by my window test,
   **below-window 41,263 B, in-window 0 B, above-window 0 B.** records.tsv confirms
   the kinds live there too (NUM_SCALE `FFEB74D8`, GLYPH_ORDINAL_INDEX `FFEB7556`,
   CHARSET_REPERTOIRE `FFEC6D0E`, GLYPH_METRIC_6B `FFEC5A12`, FIELD_COORD
   `FFEC5940`, CALLBACK_REGINIT `FFECE4E4`); only FONTBLOCK_MASTER (`FFED4644`, 96 B)
   and part of FONT_RGB565_BASE (`FFECFDCC`–`FFED248C`) reach into the window, and
   those are *site* records, not counted in the 41,263 segment total. The SUB
   denominator is defined (coverage.txt, BRIEF) as the code window
   `0xFFED0000`–`0xFFF50000` = 524,288 B. Adding 41,263 B of numerator from a
   region the denominator excludes is a domain mismatch. Effect: SUB side reported
   as `479,563/524,288 = 91.5%` instead of the clean `438,300/524,288 = 83.6%`;
   headline reported as 92.3% instead of **88.3%**.
   - Fix A (keep published denominator, drop out-of-scope numerator):
     `(950,853 − 41,263)/1,029,972 = 909,590/1,029,972 = 88.3%`.
   - Fix B (count the layout, so widen the denominator by its ~94,340 B region):
     `950,853/(1,029,972 + 94,340) ≈ 84.6%`.
   Both are below 92.3%. Fix A is the minimal, most defensible correction.

2. **is_code vs extent spread (immaterial, and in the safe direction).** My TSV
   extent re-sums exceed the published is_code figures by +742 B (MAIN) and +139 B
   (SUB) — embedded non-code bytes inside function extents that is_code correctly
   excludes. The published addends are therefore *conservative*; they do not
   inflate the headline.

3. **MAIN 28 B double-count** (detailed above) — real, negligible.

4. **Per-type drift in main-raw-types vs l5_counts** (not an error): W2-8 re-typed
   lane 5's runs, so individual categories moved (e.g. parameter table 35,757→38,619,
   a new "code" bucket of 526 B appeared), but the **non-other total is exactly
   222,192** and other is exactly 4,020, matching the claim.

Net: the only correction that moves the headline is #1. Honest headline ≈ **88.3%**
(or state SUB as 83.6% window-coverage and report the 41,263 B of layout as
separate, out-of-window typed work).

## Open

1. **Decide the SUB layout accounting and restate the headline.** Either exclude
   the 41,263 B (→ 88.3%) or widen the SUB denominator to include the
   `0xFFEB74D8`–`0xFFECE51C` font/layout region (→ ~84.6%) and report that region's
   own coverage fraction. Do not leave numerator and denominator over different
   address domains.
2. **Reclassify the 3 double-count sites.** Resolve whether `sub_1A25A`,
   `sub_1A432`, `sub_63C04` are code (fnindex) or parameter tables (lane 5), remove
   the 28 B from one addend, and apply the same new-function/run reconciliation to
   the other 6 fnindex new functions to confirm none were missed.
3. **Optional IDA confirmation of the 380,782 MAIN is_code companion** in a private
   copied DB — not required for the headline, which this audit settled from tables.
4. When the in-flight lanes land, re-run `recount.tsv` so the folded deltas are
   checked against a consistent numerator/denominator domain from the start.
