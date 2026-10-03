# MAIN raw remainder — classification of every byte outside functions

> Lane 5 of the ten-lane MAIN/SUB decompile. Database `MAIN_RAW`
> (`ida\db\jobs\MAIN_RAW\MAIN_RAW.i64`, seeded `--copy-from
> ida\db\jobs\MAIN_FULL\MAIN_FULL.i64`). Machine tables:
> `ida\out\main-raw\runs.tsv` (one row per run), `recovered-functions.tsv`
> (function starts inside recovered-code runs), `runs_diag.tsv` (shape stats for
> the residual `other`). Classifier: `ida\jobs\full_l5_classify.py`.
> Model: claude-opus-5-5 (Opus 5.5).

## Verdict

**Every raw byte in the MAIN content region `0x000000`–`0x07B753` is now
classified.** "Raw" is defined as the assignment requires: any byte **not inside
a function listed in `ida\out\main-full\functions.tsv`**. That is **226,212
bytes** (44.7% of the 505,684-byte content region) — a superset of doc 04's
119,276 "undefined" bytes, because it also includes the 101,148 bytes of code
that the sweep decoded as instructions but never attached to a function head, and
the 5,788 bytes of explicit data items.

The 226,212 raw bytes split into **3,854 runs**. **96.5% of the raw bytes
(218,368 B) carry a positive type**; the residual **7,844 B (3.5%) is `other`**,
and of that only 6,946 B sits outside the closed loader window — almost all of it
(315 runs < 4 B, 667 runs 4–15 B) is sub-16-byte interstitial padding / constant
-pool tails / isolated bytes between functions, plus four ≥16-byte mixed
code/data blocks by the USB stacks. **No new class of content was found.** In
particular there is **no font/bitmap glyph data in the MAIN image** (font bytes =
0); the display glyph/bitmap atlas lives in SUB flash (doc 16), not here.

The raw remainder is exactly what doc 04 predicted: recovered code (unowned
instructions), pointer/jump/switch dispatch tables, 16-bit parameter/calibration
tables and byte index tables, ASCII name/label string tables, and erase/zero/
space padding. Nothing in it is a memory-peek/poke surface, a loader, or a
band/MARS unlock — those questions are settled elsewhere and were not reopened.

## Method

- **What ran.** `full_l5_classify.py` against `MAIN_RAW` (fresh copy of
  `MAIN_FULL` each run; `ida\db\radio\` and the shared `.i64`s untouched). It
  loads `functions.tsv` from disk as the authoritative raw boundary (so the
  denominator matches the parent lanes exactly), computes the complement inside
  `[0x000000, 0x07B754)`, and walks it.
- **Run definition.** A *run* is a maximal contiguous span of raw bytes, **split
  wherever the type changes**; adjacent same-type runs are merged into one. Within
  a raw span the classifier applies, in priority order: (1) region_map named
  sub-regions + doc-04 §7 vetted tables + every `jumptables.tsv`/`switch_tables.tsv`
  entry (verified 4-byte big-endian dword pointer arrays), painted small-region-
  wins-over-large so nested tables resolve; (2) `is_code` → **recovered code**;
  (3) padding/erase runs (0xFF ≥4, 0x00/0x20 ≥8) → **fill**; (4) ASCII ≥6 →
  **string**; (5) ≥4 aligned BE dwords all in ROM `[0x400,0x07B754)` or on-chip
  RAM `[0xFE0000,0x1000000)` → **pointer table**; (6) everything else is consumed
  as a greedy `other` span and then reclassified by byte shape (constant block,
  monotonic curve/lookup, high-entropy map, 16-bit BE value table, small-alphabet
  byte/index table, or a read-only code probe).
- **Recovered code.** For every recovered-code run outside the closed loader
  window the script calls `add_func` at each instruction head and validates it
  (reachable-by-xref with structure, or byte-validated prologue+return); results
  in `recovered-functions.tsv` with a per-function validated flag and xref count.
- **What did NOT run — closed boundaries honoured.**
  - The **CDC-ACM / USB↔DSP-download loader personality (`26AA:0020`)** occupies
    `0x078106`–`0x07B100`. Inside that window the classifier records **byte class
    only**: no code probe, no `add_func`, no function enumeration, no tracing of
    the download byte path. 898 B there remain `other` by that rule.
  - Band coverage / MARS-CAP / expanded-RX were not searched for; the 16-bit
    calibration table (§Findings) is reported as a byte range only.
  - Settled negatives in `RESUME-DEEP.md` (no self-write, SUB USB0 dark, no SDR
    IQ source, part = H8S/2456-group) were not re-proved.
- **No Hex-Rays** (H8S). Big-endian, base 0, `h8s300a`, per lane rules.

## Findings

### Byte accounting (content `0x000000`–`0x07B753`, 505,684 B)

Inside functions.tsv: 279,472 B. Raw (this lane): 226,212 B — **run byte-sum
verified == 226,212** (`runs.tsv`). Independent instruction recount over the whole
content region: **380,782 B are `is_code`** (doc 04 reported 380,620; +162 B from
the code-probe reclaiming a few small unowned runs — i.e. essentially confirms
doc 04's denominator, no material increase).

| Type | Bytes | Runs | Share of raw |
| --- | ---: | ---: | ---: |
| recovered code | 100,125 | 1,298 | 44.3% |
| string | 36,015 | 430 | 15.9% |
| parameter table | 35,757 | 410 | 15.8% |
| pointer table | 35,232 | 284 | 15.6% |
| fill | 11,239 | 435 | 5.0% |
| **other** | **7,844** | **997** | **3.5%** |
| font | 0 | 0 | 0% |
| **typed total** | **218,368** | **2,857** | **96.5%** |

### Recovered code (100,125 B, 1,298 runs)

These are instructions the earlier sweep decoded but left unowned (doc 04's
"101,148 code bytes outside functions"). Split for reconciliation with the two
MAIN function lanes that divide at `0x038000`:

- below `0x038000`: 50,577 code B; **904 functions recovered (419 validated)**
- at/above `0x038000`: 49,548 code B; **692 functions recovered (326 validated)**
- **total 1,596 functions, 745 validated** (`recovered-functions.tsv`).

The 851 unvalidated entries are sweep/byte fragments and small `bra` thunks —
low confidence, exactly the residue doc 04 flagged ("673 sweep-only functions").
Largest recovered-code runs are USB-stack support code: `0x056EE2`–`0x057A88`
(2,982 B), `0x058678`–`0x058DD0` (1,880 B), `0x0475FA`–`0x047BF6` (1,532 B),
`0x026956`–`0x026F02` (1,452 B).

### Pointer / jump / switch tables (35,232 B, 284 runs)

The indirect-dispatch backbone of MAIN. Highest-value:

| Range | Bytes | What (evidence) |
| --- | ---: | --- |
| `0x012268`–`0x0148A0` | 9,784 | 32-bit BE code-pointer / jump table, 2,446 entries (doc 04 §7 code-pointer region) |
| `0x01109D`–`0x01208C` | 4,079 | jump table, 1,020 entries |
| `0x04AB70`–`0x04B184` | 1,556 | jump table, 389 entries |
| `0x000000`–`0x000400` | 1,024 | exception vector table, 256 BE dwords (30 occupied, 226 → filler `0x2092`) |
| `0x007814`–`0x007BE8` | 980 | switch table, 245 entries (control-transfer dispatcher) |
| `0x02A1C8`–`0x02A4DE` | 790 | jump table, 198 entries |
| `0x07B4B0`–`0x07B680` | 464 | USB stack-B descriptor-pointer + 6×20-B endpoint table (in the `.data` image) |

### Parameter / calibration / index tables (35,757 B, 410 runs)

| Range | Bytes | What |
| --- | ---: | --- |
| `0x02702A`–`0x02853E` | 5,396 | 16-bit BE parameter/calibration table (doc 04 §7) — reported as a byte range only |
| `0x0762FE`–`0x0767B6` | 1,208 | 16-bit BE value table, 604 entries |
| `0x046E10`–`0x047210` | 1,024 | rolling 0..15 index table (doc 04 §7) |
| `0x0009D8`–`0x000E20` | 1,096 | 16-bit BE value table, 548 entries |
| `0x00C06A`–`0x00C448` | 990 | byte/icon-index table, alphabet {00,01,02}+{21..76} (the `!cdr`/`!sdr` block — coincidence, doc 04 §8) |
| `0x07B120`–`0x07B4B0` | 912 | JIS ku-ten index table |
| `0x044FB4`–`0x04505C` | 168 | monotonic curve/lookup table (S-curve/gamma-style) |

### String tables (36,015 B, 430 runs)

Dominated by the shortwave broadcast-station name table `0x040482`–`0x044597`
(16,661 B, 20-B stride, VOA/BBC/…); APRS type names `0x003CC0`–`0x003EA0`; a hex/
alphanumeric charset table `0x06D1E6`–`0x06DBE0` (2,554 B); and several 2-byte-
stride ASCII character/label tables in `0x078B50`–`0x07A592` (kanji/label maps,
data — not the loader logic).

### Fill (11,239 B, 435 runs)

0xFF erase gaps, 0x00 zero/BSS-image padding, and 0x20 blank padding inside string
regions. Largest: `0x02C3CF` (154 B 0x20), `0x07132A` (146 B 0x00). Note the big
0xFF erase field is `0x07B754`–`0x0FFFFF` (542,892 B) which is **above** content
and out of this lane's scope.

### Other (7,844 B, 997 runs) — the honest residue

- **898 B** in the closed loader window `0x078106`–`0x07B100` (byte-class only by
  boundary rule; 16 runs).
- **~1,136 B** in four ≥16-B mixed code/data blocks adjacent to the USB stacks /
  dispatch region: `0x001825` (539 B, MOV-stub-like), `0x0562C8` (287 B, stack-A
  code with an embedded table), `0x076B50` (157 B), `0x003A84` (153 B header+level
  table). Code-probe rejected them (coverage < 65%) — genuinely interleaved.
- **~5,810 B** across 982 sub-16-byte interstitial fragments (padding tails,
  isolated 2–3 byte data/code fragments between functions). Irreducible under the
  "outside functions.tsv" run definition; not a classifiable table/string/code.

## Extension

Where a later owner-side MAIN feature would attach (attach points only — no
unlock, no loadable image, per session scope):

- **Indirect-dispatch tables** `0x012268` (2,446-entry) and `0x01109D`
  (1,020-entry), and the control-transfer switch table `0x007814` — any new
  command/menu handler on MAIN is reached through one of these pointer arrays.
- **Free interrupt capacity**: 226 of 256 vector slots point at the filler
  handler `0x2092` (doc 04 §1); unused slots are available ISR hooks.
- **The DATA-jack command API** (doc 04 §10) is code (in functions); its reply-
  template and record tables are among the parameter/string runs here — the data
  side a new external-control command would extend.
- **16-bit calibration table `0x02702A`** is the RF/tuning parameter store a
  calibration feature would read; **band coverage stays closed** and is only a
  stored destination index (`0xFF9E1F`), not in this table.
- The **CDC-ACM / USB↔DSP-download region `0x078106`–** is the service-mode
  transport; **left closed** — noted as an attach point, not analysed.

## Counts

- **T_run** = 3,854
- **D_run** (typed, not `other`) = 2,857
- raw total = 226,212 B; content = 505,684 B; run byte-sum verified = 226,212 B
- bytes per type: recovered code 100,125 · string 36,015 · parameter table 35,757
  · pointer table 35,232 · fill 11,239 · other 7,844 · font 0
- recovered-code bytes = **100,125** in 1,298 runs
- recovered functions = **1,596** total, **745 validated** (904/419 below
  `0x038000`; 692/326 at/above)
- MAIN content instruction bytes (independent recount) = **380,782** (doc 04:
  380,620; +162, confirms the denominator — no material increase)

## Open

- Four ≥16-B `other` blocks (`0x001825`, `0x0562C8`, `0x076B50`, `0x003A84`,
  ~1,136 B) are mixed code+data by the USB stacks; a byte-exact hand split into
  code vs embedded table was not done (low value, near-loader).
- 982 sub-16-B `other` fragments (~5,810 B) are interstitial padding/fragments;
  not individually characterised.
- The 898 B inside the CDC-ACM/DSP-download loader window are byte-class-only by
  boundary rule — **deliberately not** resolved.
- 851 recovered functions are unvalidated sweep/byte fragments (incl. `bra`
  thunks); confidence is low and matches doc 04's sweep caveat.
