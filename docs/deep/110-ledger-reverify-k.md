# K-wave and follow-up ledger and citations, re-derived from disk (lane L13)

## Verdict

The K-wave ledger and the follow-up ledger (docs 95–97) reproduce exactly from the
masks and images on disk. Both image hashes match (`8e3ecd05…` MAIN, `b93570b3…` SUB,
re-checked at the end). `final4_proven_mask.bin` has **368,624** set bytes and
`final4_named_mask.bin` has **497,451**. `final3` ⊂ `final4` in both masks with 0 bytes
lost. The 258 new proven bytes are exactly the 12 listed runs. The −278 B range
`0x054AE2`–`0x054BF7` is fully set in final4 proven, which gives **368,346**. Doc 95's
868 B are 13 ranges that are clear in both final4 masks, and its 336 heads tile
`0x078106`–`0x078545` and match `bu_all.tsv`. K7's five SUB masks are byte-identical to
I17's. The headline is **962,582 / 1,029,972 = 93.46%**, MAIN named **498,319 / 505,684
= 98.54%**, proven **369,214**. All 152 ledger checks pass. K1's one-descent builder,
re-run from a scratch copy, rebuilds both final4 masks byte for byte.

Of **902 byte citations** from docs 83–97 and `RESUME-FULL.md` lines 1–320:

- **895 pass.** This includes 24 pass variants: 12 "next bytes" table cells, 9 quoted
  errata in doc 94, 2 jsr encodings and 1 run inside a routine.
- **5 have the right bytes at the wrong address.** Two of these name the store but cite
  the run from the immediate before it. Two name a load where the compare is 4 B later.
  One is a loose "following `00 06`".
- **2 fail as written.** Both are mnemonics in doc 90. The bytes are a `mov.b` then a
  `not.b`, and the effect the doc describes is the same.
- **0 cannot be checked.**

Of 130 pattern, table and arithmetic checks, 127 pass. The **3 failures are all
counts**: doc 93's "Twelve" FF956D writers (there are 11), doc 93's "8 references" to
B0CC (there are 9 byte-level), and doc 97's address-range wording for FF8010.

No discrepancy touches a credited byte, the ledger, or a mission answer. Every offline
test the lanes left was re-run, and each passes or reproduces its published output. The
two exceptions differ only because a newer mask now exists, and they are explained
below.

This lane makes no new reverse-engineering claim. It was read-only:
- IDA was not used.
- No image or lane output was modified.
- Nothing was connected to a radio.

## Method

There are five plain-Python scripts in `ida\out\ledger-reverify-k\`, and none of them
calls IDA. MAIN file offset = address. SUB file offset = address − `0xFFC00000`. A
6-digit value of `0x100000` or more that a doc labels a SUB file offset is read as one.

1. **`l13_ledger.py` → `counts_ledger.tsv` (152 checks).**
   - **Masks and hashes.** Image sha256. Mask lengths, value sets and popcounts. Subset,
     loss and delta checks. The 12-run decomposition. The named +137 = 95 + 2 + 40 split.
   - **Window and I12.** Window and I12-block overlaps.
   - **The −278 range.** Bytes and mask state of the range. A whole-content scan for BE32
     values, abs24 `jsr`/`jmp`, `mov.l #imm`, and relative branches decoded at any
     final4-proven offset into the range.
   - **`fnindex-only-runs.tsv`.** 94 runs and 4,850 B.
   - **Doc 95.** The 13 ranges against both masks, then `code-heads.tsv` against the image
     and against `bu_all.tsv`: lengths, mnemonics and contiguity.
   - **K7 against I17.** K7's five `mask_final3_after_*` and `before_*` masks against I17's
     `mask_final2_*`, by byte comparison.
   - **Arithmetic.** Every percentage and sum in `RESUME-FULL.md` lines 1–320 and docs 83
     and 95.
   - **MAIN_FINAL5 (informational).** Five checks of `ida\out\main-final5\`, which a later
     lane wrote after the follow-up.
2. **`l13_citations.py` and `l13_manual.py` → `citations.tsv` and `coverage.tsv`.**
   - **Automatic extraction (447 rows).** The script reads:
     - in-span `ADDR bytes`;
     - `ADDR` followed by `is`, `=`, `:`, `(`, `|` or `begins` and then bytes;
     - `` `bytes` at `ADDR` ``;
     - `sub_X (bytes)`;
     - listing lines, including concatenated-hex and `; bytes` comment forms.
   - **Manual rows (455).** These cover wrapped spans, BE32 and LE32 table cells, INTB and
     vtable slots, ASCII strings, table values and "next bytes" columns. They also cover
     the K-wave "*verified*" runs in `RESUME-FULL.md` and a few named-instruction claims.
     Each row carries the anchor text and the resolved line.
   - **Grading.** A run not at its address is searched ±8 B, then across both images
     (runs of 4 B or more). Eight automatic extractions were not location claims and are
     kept in the file as `DROPPED`: a RAM operand followed by instruction bytes, a mask
     value, a range end, and a pair stated as "X and Y are `00 00`".
   - **`coverage.tsv`.** Lists all 444 in-scope lines that contain a hex byte run. 401
     carry a citation. Each of the other 43 has a reason: pattern count (checked in
     `counts_tables.tsv`), continuation line, or notation with no address (opcode lists
     such as `1C 03`, `75 41 xx`, register-encoding remarks, test outputs).
3. **`l13_counts.py` → `counts_tables.tsv` (130 checks).**
   - **Whole-image pattern counts** behind docs 84–89, 93, 94, 96, 97 and `RESUME`.
   - **Touch tables.** The 99 zone tables decoded from the image, and the 71/79/642 helper
     tables.
   - **K7 tables.** `dead.tsv`, `merges.tsv` and `usb-scan.tsv`, with their sums.
   - **Doc 95 arithmetic.** RAM-image address arithmetic, the descriptor and string bytes,
     and the 5,680-word table.
   - **Lane citation tables.** Every row of the three follow-up lanes' own `citations.tsv`
     (465, 94 and 92 rows), re-read from the images.
4. **`l13_rerun.py` → `rerun.tsv` and `rerun-log.txt` (75 rows).** Each lane script was
   copied to the session scratchpad and its output path rewritten to a scratch copy of
   the lane directory. Each script was run there, and every file it wrote was compared
   byte for byte with the published file.
   - `fcs_test.py` writes nothing and ran in place.
   - `fcs.c` was compiled with `gcc`.
   - The published lane directories were listed before and after the runs. Only the
     parent `ida\out` mtime changed, because of another lane.
5. **`l13_summary.py` → `counts.tsv`.** Combines all checks and the per-doc citation
   tallies.

**Scope limits.**
- Address-only statements with no bytes, and pure mnemonic claims, were mostly not
  graded. The exceptions are the named instructions whose encodings are listed in the
  manual file (`cmp.b`, `btst`, `jsr` and similar).
- Inferred roles were not re-derived.
- The closed window was read only as bytes.
- No mask was rebuilt by hand. K1's own builder was re-run instead, and it reproduces
  final3 internally before it writes final4.

## Findings

### 1. Ledger (`counts_ledger.tsv`, 152/152 PASS)

| item | re-derived | expected |
| --- | ---: | ---: |
| `final4_proven_mask.bin` / `final4_named_mask.bin` set | 368,624 / 497,451 | same |
| sha256 prefixes final4 proven / named | `3a45f1f46b36a47f` / `2b8255b683ca474a` | doc 83 |
| final3 \ final4 (proven, named) | 0, 0 | 0 |
| final4 \ final3 proven | 258 B = runs `0x04E2D6` 72, `0x065EFA` 16, `0x0179DA` 8, `0x029174` 6, `0x02B026` 10, `0x02B36A` 18, `0x02B3B2` 14, `0x02B64A` 64, `0x02B8BC` 10, `0x02C25E` 10, `0x064BE6` 16, `0x0696BC` 14 | the 12 listed runs |
| final4 \ final3 named | 137 = 95 proven-code + 2 (`0x04E31E`) + 40 tails in 15 runs | doc 83 |
| window `0x078106`–`0x07B753` in final4 proven | 220, all in `0x078106`–`0x078545` | 220 |
| I12 blocks in final4 proven; new bytes in I12 or window | 0; 0; 0 | 0 |
| `0x054AE2`–`0x054BF7` | 278 B, all set in final4 proven and named; head `0x054AC0`–`0x054AE1` 0 proven; `0x054BF8`–`0x054C11` 26 proven | doc 83 addendum |
| bytes `0x054ADE` / `0x054AE2` / `0x054BF6` / `0x002214` / `0x054AC0` | `6a 0a a5 1a` / `4b 0c` / `54 70` / `5e 05 4b f8` / `5e 05 45 68` | same |
| even-offset BE32 into `0x054AC0`–`0x054BF7`; abs24 `jsr`/`jmp`; `mov.l #imm`; relative branches from final4-proven offsets | 0; 0; 0; 0 | 0 |
| odd-offset BE32 in that range | one, `0x04E9FB` = `00054B00`, inside a byte table (`00 04 6a 00 00 05 4b 00 …`) | not a pointer (H8SX code is word-aligned) |
| `fnindex-only-runs.tsv` | 94 runs / 4,850 B; minus `0x054AE2` = 93 / 4,572; largest `0x03C668` 820, `0x046210` 472, `0x054AE2` 278, `0x077CC2` 206, `0x01C4D2` 194 | RESUME |
| doc 95 ranges | 13 ranges, 868 B, 0 set in either final4 mask; unset proven bytes in `0x078106`–`0x078545` are exactly those ranges | 868 |
| doc 95 heads | 336 rows, contiguous `0x078106`→`0x078546`, 1,088 B, 0 hex≠image, 0 length or mnemonic ≠ `bu_all.tsv`, 0 heads split by a range edge | 336/336 |
| K7 masks vs I17 | `headline`, `headline_w2`, `reach`, `reach_w2`, `allwf`: identical (after and before); 464,165 / 464,263 / 454,692 / 457,462 / 467,999 | same |
| `sub-final3\counts.txt` | typed 56,289; code+typed 520,552; 2,395 functions | same |
| 368,624 − 278; + 868 | 368,346; 369,214 | same |
| 497,451 + 868; + 464,263 | 498,319; 962,582 | same |
| 962,582 / 1,029,972; 961,714 / 1,029,972 | 93.457% → 93.46%; 93.373% | same |
| 498,319 / 505,684; 497,451 / 505,684 | 98.54%; 98.37% | same |
| 369,214 / 505,684; 368,346 / 505,684; 368,346 / 388,490 | 73.01%; 72.84%; 94.81% | same |
| doc 83: 72.896%, 94.886%, alt 72.841%, J4-only 368,454 → 368,176, 497,387 → 93.367%, named-removed 497,173 → 93.346% | all re-derive | same |
| strict companion 497,451 + 457,462; SUB 88.55%, 99.29% | 954,913 = 92.71% | same |
| MAIN_FINAL5 (informational) | proven 369,214 / named 498,319; final5 \ final4 = exactly the 868 window bytes; final4 \ final5 = exactly `0x054AE2`–`0x054BF7` | matches the follow-up |

One wording item. Doc 83:200 says the final4 masks use "the same format as main-final3:
1,048,576 bytes". The final4 masks are 1,048,576 B. The `main-final3\final3_*_mask.bin`
files are 505,684 B (content length). The values are 0/1 in both.

### 2. Citations (`citations.tsv`)

| doc | rows | pass | other |
| --- | ---: | ---: | --- |
| 83 | 34 | 34 | |
| 84 | 15 | 15 | |
| 85 | 16 | 15 | 1 store-address |
| 86 | 55 | 55 | |
| 87 | 100 | 98 | 2 wrong address (mnemonic) |
| 88 | 63 | 63 | |
| 89 | 14 | 14 | |
| 90 | 22 | 20 | 2 fail (mnemonic) |
| 91 | 4 | 4 | |
| 92 | 14 | 14 | |
| 93 | 55 | 55 | |
| 94 | 62 | 62 | 9 graded on doc 94's own correction |
| 95 | 111 | 111 | |
| 96 | 102 | 101 | 1 store-address (1 within-routine pass) |
| 97 | 180 | 179 | 1 wrong address |
| RESUME 1–320 | 55 | 55 | |
| **total** | **902** | **895** | 5 wrong address, 2 fail |

**Errata (owning docs not edited).**

*A. Right bytes, wrong address (5).*

| doc:line | as cited | image | true address |
| --- | --- | --- | --- |
| 85:235 | `0x04B46E` `f4 2a … 6e e4 00 01` | `0x04B46A` = `f4 2a 68 e4 6e e4 00 01` | run starts `0x04B46A`; the store `6e e4 00 01` is at `0x04B46E` |
| 96:113 | `0x0020A0` (`fc 00 6a 8c 80 04`) | `0x00209E` = `fc 00 6a 8c 80 04` | run starts `0x00209E`; store at `0x0020A0` |
| 87:132 | `0x345AA` `cmp.b #1` | `0x0345AA` = `6a 0c 8a a0` (load of FF8AA0) | `cmp.b #1` = `ac 01` at `0x0345AE` |
| 87:132 | `0x34B58` `cmp.b #2` | `0x034B58` = `6a 0c 8a a0` | `ac 02` at `0x034B5C` |
| 97:178 | "The following `00 06` bytes" after the `0x00F672` pair | `0x00F682` = `00 00 00 00 00 06` | `00 06` first at `0x00F686` |

*B. Fails as written (2), both mnemonic citations with no bytes in the doc.*

| doc:line | claim | image |
| --- | --- | --- |
| 90:103 | `not.b r2h` (`0x04954A`) | `0c 2b` `mov.b r2h,r3l`, then `17 0b` `not.b r3l` at `0x04954C`. The effect (~r2h) is as described. |
| 90:104 | `not.b r2l` (`0x049556`) | `0c ab` `mov.b r2l,r3l`, then `17 0b` at `0x049558`. Same effect. |

*C. Pass variants worth knowing (not errors).*
- **97:236–247.** The "Next bytes" column is the bytes after each 4-B `jsr`. Every site
  holds `5e 03 4d c2` (or `5e 03 4e 82`) followed by the cited bytes, so all 12 rows pass.
- **97:91–92.** `sub_3F94C` (`5e 03 f9 4c`) and `sub_3F924` (`5e 03 f9 24`) give the `jsr`
  encoding, not bytes at the routine. Both `jsr`s occur inside the `0x034DF2` and
  `0x034E06` arms.
- **96:51.** `sub_39544` (`55 0a 5e 03 ad 20`): those bytes are at `0x039548`, after the
  `01 30 6d f0` push at the entry. Doc 96's own `sub_39576` row shows the full form.
- **94:118–143.** Nine quoted J-doc citations. Doc 94's "actual" bytes and its corrected
  addresses all check:
  - `0x05549A`, `0x038672`;
  - `0x056772`, `0x056822`, `0x05694C`;
  - `0x04E318`, `0x026F48`;
  - `0x02B3DA`, `0x02B3DE`;
  - `0x054F1C`, `0x05601C`;
  - `0x002A5E`;
  - `0x00CE40` with `0a`;
  - the `0x0376C8` ramps (`11…1a`, `11…19`, `0f 0f 11…5b`).
- **97:149.** "immediates at `0x034791` and `0x035D9F`" are the low 24 bits (`ff 92 ce`).
  The imm32 `00 ff 92 ce` starts at `0x034790` / `0x035D9E`, inside `mov.l` at
  `0x03478E` / `0x035D9C`.

*D. Count claims that fail (`counts_tables.tsv`).*

| doc:line | claim | image |
| --- | --- | --- |
| 93:157 | FF956D writers: "Twelve sites" | **11** abs16 stores `6a 8X 95 6d`, each preceded by `fc 02`: `0x02F622 03111E 0341E4 03421A 03429A 0342BE 0342D2 034316 03433A 034860 039436`. The doc's own list and `tx-gate\ff956d.tsv` also have 11 (that TSV's reload row says "12"). There are 0 word or abs32 forms. |
| 93:193 | B0CC: "8 references in the whole image" | 9 byte-level references: `002E18 0358CA 035A22 035EDC 035F86 073B3A 0743BC 0743C2 0743CC`. The extra one, `0x035F86 6a 10 b0 cc 73 00`, follows a `bra` at `0x035F84` and is not final4-proven. Inside proven code the count is **8**, which matches. The "4 stores" claim passes. |
| 97:176 | "`FF8010` does not occur in `0x034E42–0x03F4EA`" | `0x03F38E 6a 04 80 10` (`mov.b @FF8010,r4h`) is inside that address range but outside both `sub_34E42` (`034E42`–`034E82`) and `sub_3F4A2` (`03F4A2`–`03F4EA`). The verdict's sentence "`FF8010` is not an operand of the check or the filler" holds. |

*E. Scope note, not graded as an error (93:99).* "Event 15 there is `0x022718` in all
four" checks for TX-time tables n = 1, 6, 7 and 8. However, `sub_10FA8` can also select
n = 4 (`AAD1 & 0x0C`) and n = 9 (`AAD3 & 0x0F`), and both of those hold `0x03FFA0`
(consume) at event 15.

All other count claims re-derive:
- **Hit-test calls.** 125 `5e 02 6f 08`.
- **Doc 86 stores.** Six `5e 06 d0 52`, each with `6a 0c 8d de 4a xx` within 16 B before
  it. Nineteen `fc imm 6a 8c b0 b9`, all at the immediate addresses in the table.
- **Doc 94's J counts** all pass: `bb c2` ×88, `6b 8X bb c2` ×3, `79 2X 89 80` ×9 (=
  `guard-sites.tsv`), `jsr @0x3BDAC` ×32, `jsr @0x3BF4C` ×31, and the others.
- **Doc 96 writers and calls.**
  - 12 `mov.b` writers.
  - One `mov.l #0xFF800E`.
  - Three `jsr sub_39534` and three `jsr sub_39544`.
  - `mov.l #0x20,er0` only at `0x039558`.
- **Doc 97 calls.**
  - 13 `jsr sub_34DC2`, 2 `jsr sub_34E82`, 1 `jsr sub_34E42`.
  - One `55 7c` into `0x034E42`.
  - The four er5 window stores in `sub_3F4A2`.
  - `jsr sub_32650` ×4.
  - The single `btst #4` on `+0x86`.
- **Zone tables.** 99 tables and 511 records. Their union is 5,296 B: the 2+10n sum is
  5,308, and the three phantom records each overrun the next table by 4 B (`0x027648`,
  `0x0276D2`, `0x027784`). The span holds 100 unreferenced bytes.
- **Helper tables.** 71 sites, 79 tables and 642 slots. Table `0x02AFF2` is used with
  N = 9 and with N = 8, so the 80 site rows sum to 649.
- **Helpers' N.** The helpers' `cmp.w #N` values are 3–11, 19 and 23.
- **K7.** `dead.tsv` has 125 rows / 10,670 B. `merges.tsv` has 31 rows / 2,279 /
  2,890 B and 15 owners. `usb-scan.tsv` has 184 rows = 11 code, 85 + 15 typed and 73
  unexplored.
- **Doc 95.** All twelve flash→RAM mappings re-derive. The descriptors and strings
  re-derive. 5,680 words, min `0x2121`, max `0xFFFF`, 3,201 distinct.
- **Lane citation tables.** Every row of service-window (465), market-values (94) and
  tx-freq-range (92, including the SUB row at file `0x349073`) matches the images.

### 3. Offline re-runs (`rerun.tsv`, 75 rows)

| lane | script | result |
| --- | --- | --- |
| K8 | `fcs_test.py` | ALL PASS; stdout identical to the Python half of `fcs_test_result.txt` |
| K8 | `fcs.c` (`gcc -O2`) | ALL PASS; stdout identical to the C half |
| K5 | `k5_gen_tables.py` | `checks ok: 76 f3 rows: 19 op rows: 27`; both TSVs identical |
| L96 | `l96_bytes.py`, `l96_cite.py` | 4 outputs identical |
| L97 | `l97_scan.py`, `l97_tables.py`, `l97_cite.py` | `citations.tsv` and `tables.txt` identical. `scan.txt` differs only in its mask list. |
| L95 | `l95_oracle.py` → `l95_heads.py` → `l95_facts.py` → `l95_data.py` → `l95_cite.py` | 19 outputs identical, `rows 465`. `oracle-summary.txt` differs only in its mask lines. |
| K1 | `k1_build_masks.py` | final3 reproduced internally. `final4_proven_mask.bin`, `final4_named_mask.bin`, `ledger*.tsv`, `helper-tables.tsv`, `touch-zone-tables.tsv` and 7 other files are byte-identical. |

The two mask-list differences come from the scripts picking "the newest
`*proven_mask.bin` under `ida\out`". A later lane has since written
`ida\out\main-final5\final5_proven_mask.bin`. With that directory excluded, both outputs
are byte-identical to the published files (`L97-frozen`, `L95-frozen`).

`l96_cite.py` derives `ROOT` from its own path, so the scratch copy had `ROOT` pinned.
No published lane file changed: the published directories were listed before and after
the runs, and the listings differ only in the parent directory's mtime.

## USB relevance

None of the three mission answers changes. This is a verification lane. Every
USB-bearing citation passes on bytes:
- doc 95's gates `0x0021FA`–`0x002234` and `0x054D54`–`0x054EC0`;
- doc 95's DSP-WRITE gate `0x05DCFE`–`0x05DD9E`;
- the `eepmov` copy sites;
- the CDC-ACM device and configuration descriptors at `0x07B680` and `0x07B711`;
- the string descriptors and pointer records;
- the ISR handler records `0x07B4B4`–`0x07B4F0`;
- K7's USB0/USBA/FCU regression table;
- K6's MSTPCRD release `FFF36D34 a8 9a 7b 32 a0 9a`.

The SDR "no" (Q2) and the DSP reach (Q3) rest on bytes that were read correctly. This
lane adds one cross-check: the new MAIN_FINAL5 masks differ from final4 by exactly the
−278 demotion and the +868 window bytes. Whoever owns them should still confirm this on
their side.

## Open

1. **Errata for the owning docs** (not edited here). Doc 93: "Twelve" → 11, and "8
   references in the whole image" → "8 in proven code (9 byte-level)". Doc 97:176 →
   scope the FF8010 statement to the two functions. Docs 85:235 and 96:113: cite from
   the immediate, or give the store address only. Doc 87:132 → `0x0345AE` / `0x034B5C`.
   Doc 90:103–104 → `mov.b r2h/r2l,r3l; not.b r3l` (`0x04954A`/`0x04954C`,
   `0x049556`/`0x049558`). Doc 97:178 → "the bytes after it are `00 00 00 00 00 06`".
   Doc 83:200 → final3 masks are 505,684 B.
2. **Doc 93 §1.** Name what TX-time tables n = 4 and n = 9 do with PTT release (event 15
   = `0x03FFA0`), since `sub_10FA8` selects them for `AAD1 & 0x0C` / `AAD3 & 0x0F`.
3. **Reproducibility.** `l97_scan.py` and `l95_oracle.py` report "the newest mask". Pin
   them to a named mask, so that later lanes do not change their output.
4. **Named-mask independence.** As noted in docs 81 and 94, `final4_named_mask.bin` is
   confirmed by K1's builder and by recount, not by an independent rebuild.

### Files (`ida\out\ledger-reverify-k\`)

| file | content |
| --- | --- |
| `l13_ledger.py` → `counts_ledger.tsv` | 152 ledger checks |
| `l13_citations.py` + `l13_manual.py` → `citations.tsv`, `coverage.tsv` | 902 graded citations (+8 dropped), 444 coverage lines |
| `l13_counts.py` → `counts_tables.tsv` | 130 pattern, table, arithmetic and lane-table checks |
| `l13_rerun.py` → `rerun.tsv`, `rerun-log.txt` | 75 re-run rows |
| `l13_summary.py` → `counts.tsv` | all checks plus per-doc citation tallies (374 rows) |

Model: claude-opus-5-5.
