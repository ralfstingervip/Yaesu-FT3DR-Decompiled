# Convention D recomputed from files on disk (Lane N6)

Owner-side static arithmetic over published masks and the two decrypted images. No IDA, no database opened, no
mask or image written, nothing connected to or sent to any radio or device. Images re-hashed at start and finish:
MAIN `8e3ecd05409b2c31…`, SUB `b93570b3c2f69ccb…` (full digests in `ida\out\convention-d\n6_log.txt`).
Model: claude-opus-5-5.

Tables in `ida\out\convention-d\`:

| File | Contents |
| --- | --- |
| `n6_ledger.py` | The whole recount and the byte-checker (63 checks, 0 failed) |
| `ledger.tsv` | Conventions A–E on the FINAL7 MAIN masks, and every term with its source |
| `sub-residue-runs.tsv` | The 59 residue runs recomputed from the masks (start, end exclusive, file offset, bytes) |
| `main-unnamed-runs.tsv` | The 519 MAIN content bytes not in the FINAL7 named mask, as 46 runs |
| `bytecheck.tsv` | Image bytes at every address this doc cites |
| `n6_log.txt` | The run log, including the sha256 of each SUB mask read |

## Verdict

The M-wave table in RESUME-FULL reproduces exactly from the published masks. The SUB window is exactly partitioned:
code 464,263 + typed 56,289 + DEAD residue 3,736 = **524,288**. Each window byte falls in exactly one of the three
classes. The 3,736 B residue is the same 59 runs that doc 127 classed DEAD in `runs.tsv` and
`proposed-typing.tsv`. Under convention D the headline is **1,029,453 / 1,029,972 = 99.9496 %**, which rounds to the
published 99.95 %. All five conventions match the published totals and percentages. The recount agrees with
464,263 and 524,288, so no differing ranges exist. The denominator stays 1,029,972, and **the named delta from this
lane is 0**. **Confirmed.**

## Method

The method was one Python script, `n6_ledger.py`, with read-only inputs:

- **MAIN.** `ida\out\m-wave-recon\final7_named_mask.bin` and `final7_proven_mask.bin`, one byte per address over the
  1 MB image, values 0/1. Their sha256 equals `masks-sha256.txt` (`0bcf995b…`, `5585a9c6…`).
- **MAIN content.** `0x000000`–`0x07B754` = 505,684 B. This is `CONTENT` in `m_recon.py`. `0x07B754`–`0x100000` is
  all `FF` (Confirmed, 542,892 B). For example, `0x07B740 00 02 0a 00 00 00 07 05 01 02 40 00 00 07 05 82 02 40 00
  00 | ff ff ff ff`.
- **SUB.** The published K7 masks `ida\out\sub-final3\raw\mask_final3_after_{headline_w2, allwf, reach_w2,
  headline, reach}.bin`, one byte per window address, `FFED0000`–`FFF50000` (file `0x2D0000`–`0x350000`). Their
  sha256 values are recorded in `n6_log.txt`.
- **Doc 127 tables.** `ida\out\sub-residue-final\runs.tsv` and `proposed-typing.tsv`.

The derived terms are defined exactly as doc 127 and the M-wave table define them:
- typed = window − `allwf`
- residue = `allwf` − `headline_w2`
- strict reach = `reach_w2` − 120 B

The 120 B are the stale lane-4 root ranges `FFF2570F`–`FFF25771`, `FFF38800`–`FFF3880B` and `FFF38871`–`FFF3887C`
(end exclusive). All of them are set in `reach_w2`.

Scope covered: every byte of both MAIN masks, every byte of all five SUB window masks, and all 59 rows of each doc 127
table. Not done: no decode or classification of my own (I relied on doc 127 for DEAD), and no MAIN or SUB DB state.

## Findings

### 1. MAIN FINAL7 terms (Confirmed, from the masks)

| Term | Bytes | Check |
| --- | --- | --- |
| Named | 505,165 | Nothing named or proven at or above `0x07B754` |
| Proven | 365,358 | Proven ⊆ named |
| Unnamed content | 519 | 46 runs, in `main-unnamed-runs.tsv` |

The 43 B stale copy `0x069A7F`–`0x069AA9` is entirely unnamed. Its first 37 B equal `0x069964`'s. Both start
`6a 0c b3 f5 1c 9c 46 04`.

### 2. SUB window partition (Confirmed, from the masks)

| Class | Definition | Bytes |
| --- | --- | --- |
| Code | `headline_w2` | 464,263 |
| Typed | ¬`allwf` | 56,289 |
| DEAD residue | `allwf` ∧ ¬`headline_w2` | 3,736 |
| **Sum** | | **524,288** |

The mask relations and the other recounts:
- `headline_w2` ⊆ `allwf` and `reach_w2` ⊆ `headline_w2`.
- The per-byte class count is 1 at all 524,288 addresses, so the partition is exact with no overlap and no fourth
  class.
- `headline` = 464,165, `reach` = 454,692 and `reach_w2` = 457,462. These equal `sub-final3\counts.txt`.

### 3. The residue is doc 127's DEAD set (Confirmed)

- **Same runs.** The mask residue forms 59 runs. Their (start, end) list is identical, row for row, to
  `runs.tsv` and to the 59 data rows of `proposed-typing.tsv`.
- **Same class.** Every `runs.tsv` row has `klass` = DEAD, and every `proposed-typing.tsv` row has `class` = DEAD.
- **Same total.** The `proposed-typing.tsv` TOTAL row states 3,736.
- **Same subclasses.** dead-function 3,393, dead-function + split byte (`FFF2A6D1`) 300, and fragment 43. These
  sum to 3,736.
- **Bytes check.** In all 59 `runs.tsv` rows, `first_bytes` matches the SUB image at `file_off` = start −
  `0xFFC00000`. Examples:
  - first run `FFEDAE05` / file `0x2DAE05`: `71 00 ec a1 01 a0 8a a9`
  - fragment `FFF13DDA` / `0x313DDA`: `72 00 e0 fe f9 05 8e 00 f9 05 8d 00 3c 84 00 3e 02 00 3e 01 00`
  - split-byte site `FFF2A7F9` / `0x32A7F9`: `a0 09 2e 7e a9 8c 72 41 0c 10`

### 4. Conventions A–E on FINAL7 MAIN (Confirmed; `ledger.tsv`)

Denominator 505,684 + 524,288 = **1,029,972** (unchanged).

| Conv. | MAIN term | SUB term | Headline | % | Published |
| --- | --- | --- | --- | --- | --- |
| A | named 505,165 | code 464,263 | 969,428 | 94.1218 % | 969,428 = 94.12 % ✓ |
| B | named 505,165 | code + residue 467,999 | 973,164 | 94.4845 % | 973,164 = 94.48 % ✓ |
| C | named 505,165 | code + typed 520,552 | 1,025,717 | 99.5869 % | 1,025,717 = 99.59 % ✓ |
| **D** | named 505,165 | **code + typed + residue 524,288** | **1,029,453** | **99.9496 %** | 1,029,453 = 99.95 % ✓ |
| E | proven 365,358 | strict reach 457,342 | 822,700 | 79.8760 % | 822,700 = 79.88 % ✓ |

Under D, the only bytes of the denominator left out are MAIN's 519 unnamed bytes, 43 of them the held stale copy.

### 5. Proposed deltas

- **Named delta: 0.** No range is added, and the empty list sums to 0. The named headline stays **1,029,453** until
  the parent unions N2's Confirmed ranges.
- **Proven delta: 0.** No range is added, and the empty list sums to 0.

### 6. Labelling note on doc 127 (no byte changes)

- **The two "E" rows.** Doc 127 §4's row E uses SUB strict reach 457,342 (822,128 = 79.8204 %). Its own
  `counts.tsv` puts that figure in a row labelled `E2`. The row labelled `E` there uses `reach_w2` 457,462 (822,248
  = 79.8321 %). Both rows are arithmetically right on FINAL6 MAIN (proven 364,786). The M-wave table's E is the
  strict variant, and that is what is reproduced here.
- **FINAL6 vs FINAL7.** Doc 127's 99.61 % for D is on FINAL6 MAIN (named 501,656). On FINAL7 it is 99.95 %, which
  RESUME-FULL already records.

## USB relevance

None. This is a byte-count over published masks. No mission answer changes. The residue's USB status rests on doc 127
(no peripheral operand in any of the 59 runs), and this lane did not re-test it.

## Open

1. **Parent union.** Union N2's Confirmed ranges into the MAIN named mask. Recount D as 524,288 + new MAIN named over
   1,029,972, and keep a disjoint-range check against the 46 runs in `main-unnamed-runs.tsv`.
2. **Strict reach.** The strict SUB reach (457,342) removes stale roots only inside the 125 dead functions (doc 127
   Open 2). A closure without any stale lane-4 xref root could lower E further.
3. **The 43 B stale copy.** Counting `0x069A7F` as named is an owner decision. It would make D 1,029,496 = 99.9538 %
   (arithmetic only, not applied).
