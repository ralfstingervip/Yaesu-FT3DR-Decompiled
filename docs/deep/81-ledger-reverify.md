# I-wave ledger — independent re-derivation from disk (lane J13)

## Verdict

The full I-wave ledger reproduces from the bytes on disk. Every cited byte run,
every mask byte-count, every pairwise-intersection, and every arithmetic identity
in the I-wave block of `RESUME-FULL.md` re-derives exactly, with **no discrepancy**.
Both image sha256 match (`8e3ecd05…` MAIN, `b93570b3…` SUB). The MAIN proven
figure **368,366**, the SUB window figure **464,263**, and the **93.36%** headline
all confirm. This lane makes no new reverse-engineering claim; it only re-ran the
numbers against `decrypted\*.bin` and the published masks. Owner-side, read-only;
nothing was written to a radio and no image was modified.

## Method

Pure on-disk re-derivation in Python (`<scratchpad>\J13\reverify.py`), no IDA.
MAIN addresses are file offsets; SUB offsets = addr − 0xFFC00000.

1. Read all 50 "*verified*" byte strings in the I-wave lanes (I1,I2,I4,I6,I8,I9,
   I11,I12,I13,I14,I15 and the I1 doc-53 corrections) at their stated offsets and
   compared to disk → `ida\out\ledger-reverify\byte-runs.tsv`.
2. Re-checked the I15 record-field BE32 values (+0x14/+0x18/+0x1C of records
   0x028C2A / 0x028C8A).
3. Counted set bytes in `main-final\h9_proven_mask.bin` and
   `main-final2\final2_proven_mask.bin`; confirmed H9 ⊆ final2 and the difference.
4. Rebuilt the four per-lane byte sets (I6 / I8c / I8x / I9) from
   `main-final2\merged-new-bytes.tsv`, computed all six pairwise intersections,
   and confirmed their union equals `final2 \ H9` → `overlaps-reverify.tsv`,
   `mask-resum.tsv`.
5. Counted the SUB headline masks in `sub-final2\raw\` and `sub-final\raw\`.
6. sha256 of both plaintext images.

Scope note: I independently re-masked the **proven** chain (H9 365,570 and the
+2,862 lane union). The MAIN **named/typed** base (497,139 → 497,314) and the SUB
464,166 pre-base were confirmed only by re-running the published masks/counts and
the arithmetic, not by rebuilding the named mask from a fresh descent — that base
is H9's and is outside the stated task scope.

## Findings

### (1) Byte runs — 50 / 50 PASS

All byte strings reproduce at the stated offsets. Representative confirmations:
0x055684 `6a 0c ee 10` (I1), 0x0554A4 `7a 04 00 ff 58 06` (I1), 0x054C1C
`24 28 80 00 02` (I12), 0x056B58 `6a 0b b1 02` (I4), 0x05F4B0 `7a 04 00 ff 50 06`
(I11), 0x028D0C `01 00 6f 16 00 00 5d 60` (I9), 0x00326A `01 00 6f 36 32 72 59 60`
and table 0x003272 `0000327e 0000328a 0000329c` (I14). SUB: 0xFFED7990
`5b f0 f0 ff`, 0xFFF0F05B `60 40 60 40 f8 05`, 0xFFEDFFFD `fb e2 d4 cd 01 00`,
0xFFF4A4E6 `43 6f 6e 6e 65 63 74 65 64 00` ("Connected\0") (I2).

**Notation clarification (not a discrepancy):** the resume shorthand for the I9
er1 edge, "`0x0178F0 → 0x015224` (*verified* `5d 10`)", binds `5d 10` (jsr @er1)
to **0x015224**; **0x0178F0** holds `7a 01 00 01 a0 84` (mov.l #0x1a084,er1). The
lane's own `suspect-tables\new-edges.tsv` states both, and both reproduce on disk.
I split them into two rows in `byte-runs.tsv`.

I15 record fields confirm byte-exact: record 0x028C2A +0x14=0x02A924,
+0x18=0x03FFA0 (sentinel), +0x1C=0x028C4A; record 0x028C8A +0x14=0x02A9F4,
+0x18=0x03FFA0, +0x1C=0x028CAA.

### (2) MAIN proven ledger — reproduces to the byte

| item | re-derived | expected | result |
| --- | --- | --- | --- |
| h9_proven_mask.bin set bytes | 365,570 | 365,570 | PASS |
| final2_proven_mask.bin set bytes | 368,432 | 368,432 | PASS |
| H9 ⊆ final2 | True | True | PASS |
| final2 \ H9 | 2,862 | 2,862 | PASS |
| lane I6 | 1,544 | 1,544 | PASS |
| lane I8c (0x034CCE) | 116 | 116 | PASS |
| lane I8x (tier-X 0x003272) | 66 | 66 | PASS |
| lane I9 (three edges) | 1,136 | 1,136 | PASS |
| lane sum | 2,862 | 2,862 | PASS |
| union disjoint (union == sum) | True | True | PASS |
| lane-union == final2 \ H9 | True | True | PASS |
| all 6 pairwise intersections | 0 | 0 | PASS |

`365,570 + 1,544 + 182 + 1,136 + 54 − 120 = 368,366` — **PASS**. The byte union
H9∪I6∪I8∪I9 = 368,432 independently confirmed by `len(final2_proven_mask)`. I8 =
116 + 66 = 182. The six pairwise lane intersections are all 0, reproducing
`main-final2\overlaps.tsv` (I6/I8c/I8x/I9), and the lane union is byte-identical to
`final2 \ H9`, which cross-validates the IDA-built mask against the merge table.
The I15 +54 and I12 −120 are arithmetic on top of the 368,432 union (the published
final2 mask predates both, per its seed note); the descent-ext ledger's
`beyond_all=1` rows (0x028C4A +16, 0x028CAA +18 = 34; 0x02A924 +10, 0x02A9F4 +10 =
20; total 54) match.

### (3) SUB window code — reproduces

| mask | re-derived | expected | result |
| --- | --- | --- | --- |
| sub-final2 headline | 464,165 | 464,165 | PASS |
| sub-final2 headline+w2 | 464,263 | 464,263 | PASS |
| sub-final headline | 464,165 | 464,165 | PASS |
| sub-final headline+w2 | 464,263 | 464,263 | PASS |

`464,166 − 1 + 98 = 464,263` — **PASS** (the DB recount alone gives 464,165 before
the +98; the headline base 464,166 = that 464,165 counted with the one byte the −1
later removes, per `sub-final\ledger-delta.tsv`). Residue `524,288 − 520,552 =
3,736` and `3,692 + 43 + 1 = 3,736` — both **PASS**.

### (4) Image sha256 — both MATCH

- MAIN `8e3ecd05409b2c314ebed77320ece5930bf31c8333cd84aeef4f6b0264c1bcce`
- SUB  `b93570b3c2f69ccb51c113c893b4bc4c414cf78ceddde478748404e0768c6230`

### Headline

`MAIN named/typed 497,314 + SUB window 464,263 = 961,577`;
`961,577 / 1,029,972 = 93.3595%` → **93.36%** — confirmed (matches RESUME-FULL
line 12). MAIN named 497,314 = 497,139 + I6 10 + I8 2 + I9 129 + I15 34 (arithmetic
checked; the 497,139 base is H9's named mask, not independently re-masked here).

## USB relevance

None changed by this audit — it is a verification lane, not a discovery lane. The
re-read incidentally re-confirms the USB-adjacent bytes other lanes cited: the
EP1 bulk-OUT image-push loop (0x055684 `6a 0c ee 10`, base 0x05567E
`7a 15 00 ff 58 06`, I1), vendor request plumbing (0x0554A4, 0x055520
`6a 0c aa e8 46 f8`, I12), the configured bulk-IN EP2 (0x054C1C `24 28 80 00 02`,
I12), and the C4FM picture staging store (0x05F4B0, I11). All reproduce exactly,
so the USB findings they support rest on correctly-read bytes. The mission answers
(USB surface on MAIN only; no SDR IQ path; DSP behind the closed window) are
unaffected and unchallenged by this lane.

## Open

1. Independently rebuild the MAIN **named/typed** mask (497,139 H9 base) from a
   fresh descent to close the one part of the ledger confirmed here only by
   arithmetic + published-mask recount rather than by re-masking.
2. The intermediate `main-final2\ledger-delta.tsv` line "headline (I2 SUB 464,263)
   961,543 / 93.3562%" predates I15's named +34; the adopted I-wave headline is
   961,577 / 93.36%. Harmless, but a future pass should regenerate that file so it
   carries 961,577 to avoid confusion.
3. Nothing else: the proven and SUB-window sums are fully reproduced.

### Tables (machine-readable)

- `ida\out\ledger-reverify\byte-runs.tsv` — 50-row pass/fail of every cited run.
- `ida\out\ledger-reverify\mask-resum.tsv` — mask counts, subset, union checks.
- `ida\out\ledger-reverify\overlaps-reverify.tsv` — six pairwise lane intersections.

Model: claude-opus-4-8.
