# SUB code window 0xFFED0000-0xFFF50000 — the "70.6% not yet instructions"

Lane 4. Database `SUB_WINDOW` (own copy of `ida\db\jobs\SUB_VEC\SUB_VEC.i64`).
Tables: `ida\out\sub-window\coverage.txt`, `functions.tsv`. Supporting:
`baseline_measure.txt`, `undefined_charac.txt`, `flags_dump.txt`, `blockmap.tsv`.

## Verdict

**The window was never 29.4% instructions. It was already ~80% instructions in the
seed database, and is 89.1% after this lane.** The stated baseline "154,162 /
524,288 = 29.4%" is a measurement artifact: `ida_bytes.is_code(flags)` is true only
for an instruction's **head** byte, and the SUB_VEC coverage script (and my own
pass 1-3) counted heads per byte. Multi-byte-instruction **tail** bytes carry class
`FF_TAIL`, so ~63% of every real instruction went uncounted. Measured correctly by
item size, the pristine SUB_VEC seed already held **417,303 instruction bytes
(79.6%)** in this window. Lane 4 recovered **+49,986 more instruction bytes**
(truly-undefined fell 103,789 → 52,553), reaching **467,289 instruction bytes
(89.1%)**; **438,300** of those sit inside a validated function. The code band
`0xFFEDB000`–`0xFFF48000` is contiguous RX code with essentially no embedded data
pools; the only real data in the window is the leading table block
`0xFFED0000`–`0xFFED8E70` and the `0xFFF48000` string pool. **Confirmed.**

## Method

All work in private DB `SUB_WINDOW`, seeded `--copy-from ida\db\jobs\SUB_VEC\SUB_VEC.i64`.
Shared DBs only copied-from, never opened for writing. No device, no image output.
Scripts (prefix `full_l4_`, in `ida\jobs\`), each via `run_job.py`:

| Script | Ran |
| --- | --- |
| `full_l4_window.py` | first classification pass + B1/B2/B3 recovery (call/jump targets, pointer-table follows, RTE stub run) + head-count byte map. Exposed the extent-overcount and low apparent coverage. |
| `full_l4_measure.py` | CF_STOP-based terminator, per-2KB code-fraction map, undefined-run decode probe. Showed uniform ~30% head-code per block. |
| `full_l4_recover.py` | dark-code recovery: gap-filling **synced linear disassembly** seeded only at function boundaries (prologue, or a byte after a flow-stop instruction), each seed gated by `plausible_seed` (clean linear decode to a `CF_STOP` within 0x2000, zero invalid opcodes, ≥3 insns), iterated, then a guarded-aggressive round, then xref closure. |
| `full_l4_charac.py` | ran BEFORE the head/tail fix: undefined split into pointer-table / valid-decode / broken runs. Its 163,502 runs averaging 1.8 bytes were the clue. |
| `full_l4_flags.py` | per-byte class dump + undefined run-length histogram → proved the "undefined" bytes are instruction **tails** (run lengths 1/2/3/5 = tails of 2/3/4/6-byte RX insns). |
| `full_l4_final.py` | **authoritative** measurement: instruction bytes = Σ item size of code heads; head/tail-correct function classification and denominator. |
| `full_l4_baseline.py` | same correct count on a pristine SUB_VEC copy (`SUBW_BASE`) to separate seed content from lane-4 recovery. |

Classification rule per function whose start is in the window: **xref** if a
call/jump (`XrefsTo`, type ≠ fl_F) reaches its start; else **rejected** if the start
lies in a proved-data region; else **body** if the body decodes and a linear run
from the start reaches a flow-stop and the start is a recognized RX prologue;
else **rejected**. Numerator counts head+tail instruction bytes inside xref+body
functions.

**Scope covered.** Full 524,288-byte window byte-classified by item size. All 4,263
in-window functions adjudicated. Code band re-swept for dark functions to
convergence (a final aggressive round added only +117 bytes). **Not run.** No
Hex-Rays. No entry into the DSP `26AA:0020` loader. Band/MARS/expanded-RX left
closed. The `~7 KB` at `0xFFED8E70`–`0xFFEDAB4C` (between INTB end and the lowest
xref-reached function) is left inside the code-region denominator though it is
largely sparse data — this makes the reported coverage % conservative, not inflated.

## Findings

### 1. The is_code head/tail artifact (root cause of "29.4%")

`flags_dump.txt`. A per-byte class dump of `0xFFEE4000`, `0xFFEEE000`, `0xFFF08000`
shows the pattern `..C.C...C.C.C.C` — isolated head bytes with the tail bytes
reading as non-code. The undefined run-length histogram over the code band:
`<=1: 93,778 runs / 93,778 B`, `<=2: 36,032 / 72,064`, `<=3: 19,119 / 57,357`,
`<=5: 11,249 / 56,245`, and almost nothing longer. Those are exactly the tail-byte
counts of 2/3/4/6-byte RX instructions. `is_code()` counts heads, not bytes.

### 2. True byte composition of the window (`coverage.txt`, `full_l4_final.py`)

**Confirmed** (item-size measurement, head/tail correct):

| Class | Bytes | % of window |
| --- | --- | --- |
| instruction (heads+tails) | 467,289 | 89.1 |
| defined data items | 4,446 | 0.8 |
| truly-undefined `FF_UNK` | 52,553 | 10.0 |
| — of which 0xFF pad | 6,734 | |
| — of which 0x00 pad | 22,011 | |

467,289 + 4,446 + 52,553 = 524,288 ✔. The residual undefined after pad and the
descriptor table is only ~7.5 KB.

### 3. Proved data regions — the denominator (`coverage.txt`)

**Confirmed** (docs 16/02 + entropy block-map `blockmap.tsv`):

| Region | Bytes | Evidence |
| --- | --- | --- |
| `FFED0000`–`FFED3F6C` bitmap descriptor-table tail | 16,236 | doc 16, 16-byte records |
| `FFED3F6C`–`FFED5800` UI layout tables | 6,292 | ent≈5, printable index/coord runs (doc 16 §5) |
| `FFED5800`–`FFED8A70` zero-heavy tables | 12,912 | ent<2.1, 75% zero |
| `FFED8A70`–`FFED8E70` INTB vector table | 1,024 | doc 02, 256×4 |
| `FFF48000`–`FFF4C000` string pool | 16,384 | printable 49–76%; `FIRM ERROR` @`FFF4AB3F` |

Proved data = **52,848 B**. **Instruction-byte denominator = 524,288 − 52,848 =
471,440.** Numerator/denominator = 438,300 / 471,440 = **93.0%**. All-instruction /
denominator = 467,289 / 471,440 = 99.1% (the ~4.1 KB gap is FF/zero padding inside
the code region), confirming the code band is essentially fully instructions.

### 4. Dark-code recovery (`full_l4_recover.py`)

**Confirmed** (before/after, correct bytes; `baseline_measure.txt` vs `coverage.txt`):

| | pristine SUB_VEC | after Lane 4 | delta |
| --- | --- | --- | --- |
| instruction bytes (heads+tails) | 417,303 | 467,289 | +49,986 |
| truly-undefined bytes | 103,789 | 52,553 | −51,236 |
| in-function instruction bytes | 396,495 | 438,300 (validated) | +41,805 |
| instruction heads (old metric) | 154,162 | 171,535 | +17,373 |

The recovered functions are dark code reached only indirectly (register/table
dispatch) whose entries the SUB_VEC prologue sweep missed — chiefly functions whose
first instruction is `mov.l #imm,rN` (`FB ?2`/`FB ?E`), which SUB_VEC's seed3 gate
`b0 in (0x6E,0x7E,0x60,0x71)` excluded. Every recovered seed passed `plausible_seed`
(clean decode to a flow-stop, no invalid opcode), and the code band is hex-verified
RX instructions (`62 40`, `B0 89`, `61 11`, `FB 42`, `EF 61`, `38 31 …`).

### 5. Purposes cross-check (`functions.tsv`)

188 validated-by-body functions carry a peripheral/UI purpose derived from a
`mov.l #periph,rN` in the body, each citing its start address. These reproduce doc
02's ISR map from the opposite direction: `FFEDB7E7`→SCI0.SCR (RXI0), `FFEDBBD3`→
SCI2.SCR, `FFEDBCDD`→ICU.GRPBL0 — byte-for-byte the handlers doc 02 named. That
agreement is independent evidence the body-validated set is real code.

## Extension

A later owner feature added on the SUB side attaches to the same three live UARTs
and the external-bus/LCD path already mapped (docs 02/16), all of which are now
inside validated, disassembled functions in this window: the SCI0/2/3 RX/TX
handlers and their `0x00012D20` callback dispatch, and the blit/EXDMAC draw chain
`sub_FFEF0648`/`sub_FFEF68D5`/`sub_FFEF1F90`. No new peripheral, USB path, or
flash-write path appears anywhere in the recovered code — consistent with docs 02
and 16, whose settled negatives this lane does not disturb.

## Counts

- **Validated SUB functions in the window (total): 3,850.**
  - reached-by-xref: **1,602** (297,232 instruction bytes)
  - validated-by-body: **2,248** (141,068 instruction bytes)
- **Rejected sweep candidates: 413** (of 2,661 non-xref sweep candidates): 5 start
  inside a proved-data region, 408 lack a prologue or fail the decode-to-flow-stop
  test. 8,089 instruction bytes.
- **Instruction bytes inside validated functions (numerator): 438,300.**
- **Instruction-byte denominator: 471,440** (window 524,288 − 52,848 proved data);
  numerator/denominator = **93.0%**. Directly measured, the window is **467,289
  instruction bytes (89.1%)** vs 4,446 data-item + 52,553 undefined (28,745 of it
  FF/zero pad). Baseline correction: the "154,162 / 29.4%" figure was
  instruction-heads-only; pristine seed in true bytes = 417,303 (79.6%).
- **Purposes: 188** validated-by-body functions have a non-empty purpose citing the
  start address.

## Open

1. The ~7.5 KB genuinely-undefined remainder (window undefined 52,553 minus 28,745
   pad minus the 16,236 descriptor tail) is small alignment/table fragments at
   `0xFFED8E70`–`0xFFEDAB4C` and scattered inter-function padding; not individually
   catalogued.
2. `0xFFED8E70`–`0xFFEDAB4C` is left in the code-region denominator though largely
   data — tightening it would raise the reported coverage % by ~1.5 points.
3. The 408 no-prologue rejects decode cleanly and lie in the code band; most are
   almost certainly over-split tails of adjacent functions rather than noise, but
   under the stated rule (prologue + return) they are not counted as validated.
4. The shared SUB_VEC/subupper coverage scripts still report the heads-only metric;
   any future score comparing to "29.4%" must use the item-size count in §2.
