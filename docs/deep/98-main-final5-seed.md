# 98 — The MAIN_FINAL5 seed (Lane L1)

> Lane L1, model `claude-opus-5-5`. Owner-side static analysis of `decrypted\FT3D_MAIN_ver102_EXP.bin`
> (MAIN, H8SX `h8sxa`, base 0, big-endian, file offset = mapped address; sha256 prefix
> `8e3ecd05409b2c31`, re-checked, unchanged; SUB `b93570b3c2f69ccb`, unchanged). No image byte was
> modified (no `patch_*`), and nothing was connected to or written to any radio or device. Only my DB
> `ida\db\jobs\L1_MAIN_FINAL5\L1_MAIN_FINAL5.i64` was opened, seeded `--copy-from`
> `ida\db\jobs\K1_MAIN_FINAL4\K1_MAIN_FINAL4.i64` (read only). The low region `0x400`–`0x078106` was not
> re-planned. Tables: `ida\out\main-final5\`. Job: `ida\jobs\l1_apply_main_final5.py`. Offline mask
> builder: `ida\out\main-final5\offline\l1_build_masks.py`.

## Verdict

**MAIN_FINAL5 makes the DB and the published masks match the current headline: MAIN proven = 369,214 B,
MAIN named/typed = 498,319 B.** The seed carries FINAL4 plus exactly the two resolved deltas and no
others:

- **−278 B, demotion of `0x054AE2`–`0x054BF7`** (proven mask only). This is the I12 convention, confirmed
  from docs 64/69/83: the demotion is a proven-mask overlay, not a DB edit — the bytes stay disassembled
  DB code, so **named is unchanged**. The range is reached only as an H9 `fnindex` start seed and has **no
  inbound edge**, re-checked whole-image in the FINAL5 DB (below).
- **+868 B, the service window code `0x078106`–`0x078545`** (doc 95), folded into **both** masks. These are
  the thirteen ranges doc 95 found clear in both FINAL4 masks; FINAL5 opens the window in the DB to its full
  **336 code heads** so every proven window byte is DB code.

Popcounts verify exactly: proven `368,624 − 278 + 868 = 369,214`; named `497,451 + 868 = 498,319`. The DB is
a true fixed point (a `--reopen` changes 0 functions, 0 heads, 0 code bytes, 0 xrefs; layout hash
`42111f94aa98d911`; 0 odd heads outside the window), and all 369,214 proven bytes are DB code (0 proven
bytes not DB code).

**Headline: MAIN named 498,319 + SUB window code 464,263 = 962,582 / 1,029,972 = 93.457 %** (the follow-up's
93.46 %, now baked into the masks and the DB).

## Method

All passes were run this session; IDA ran only through `run_job.py`.

1. **Offline mask builder** (`offline\l1_build_masks.py`, plain Python, read-only on the FINAL4 masks).
   It asserts FINAL4 proven = 368,624 and named = 497,451; asserts the demoted range is fully set in both
   FINAL4 masks (278/278); asserts each of the thirteen window ranges is fully clear in both FINAL4 masks
   (868 total); then clears the 278 from proven only, sets the 868 in both, and asserts proven = 369,214,
   named = 498,319, proven ⊆ named, and nothing set above `0x07B754`. It writes `final5_proven_mask.bin`,
   `final5_named_mask.bin`, `ledger.tsv`, and `final4-to-final5-diff.tsv`.
2. **Seed build.** `run_job.py --script ida\jobs\l1_apply_main_final5.py --db L1_MAIN_FINAL5 --copy-from
   ida\db\jobs\K1_MAIN_FINAL4\K1_MAIN_FINAL4.i64` (tag `build`), then `--reopen` (tag `verify`). The job:
   - opens the window to its 336 code heads from `ida\out\service-window\code-heads.tsv` using doc 95's
     clean method (`enable_auto(False)`, delete window items, `create_insn` each head, `plan_range(W0,W1)`
     only, remove any un-wanted code head, re-enable auto). It cross-checks every head's bytes against the
     image (336/336, 0 diff) and checks the collar `0x078000`–`0x078106` / `0x078546`–`0x078900` is
     unchanged (drift 0);
   - adds the 18 window routine entry points as functions (16 new; two were already functions);
   - leaves the demoted range untouched (I12 convention — it stays DB code);
   - audits the demoted range for inbound edges whole-image;
   - is idempotent: on `--reopen` the window is already 336/336, so it edits nothing.
3. **Decodable-denominator check.** Read `ida\out\recount\recount.tsv` and `work\items_h1.tsv` (doc 39's
   H1_RECOUNT dump, the basis of the 388,490 figure) and counted its is_code coverage of the window
   directly.

**Not done.** I did not re-plan `0x400`–`0x078106` (would create false heads; out of scope). I did not touch
the SUB side. I did not decode anything new inside the window beyond doc 95's heads. The other 93
`fnindex`-only runs (`ida\out\main-final4\fnindex-only-runs.tsv`) are being edge-checked by lanes L2–L4 in
parallel and are **not** demoted here.

## Findings

### 1. The I12 convention (Confirmed from docs 64/69/83)

Doc 69 states it twice: "I12 demotion is a proven-mask overlay, not a DB edit. The 120 bytes stay
disassembled DB code" and "the demoted bytes stay typed code, so named does not [change]". Doc 64
(`usb-vendor`, the I12 source) proposed the −120 B as a proven-mask overlay. Doc 83's addendum applies the
same rule to `0x054AE2`–`0x054BF7`: "Under the I12 convention (demoted code stays typed), named is unchanged
at 497,451." So FINAL5 removes the 278 B from proven only; it does **not** edit the DB for the demotion, and
named is unchanged by it. Confirmed in the DB: after the demotion the range is still DB code (86 of 278 B
sit on code heads that the job counts; the rest are continuation bytes of those instructions — the point is
the range was not deleted).

### 2. The demoted range has no inbound edge (Confirmed, whole-image, FINAL5 DB)

Range `0x054AE2`–`0x054BF7` (278 B), checked four ways over the whole content `0x000000`–`0x07B753`:

- **DB cross-references.** `XrefsTo` on every byte of the range: **0** references from outside the enclosing
  routine `0x054AC0`–`0x054C11`. (98 internal edges — the routine's own fall-through and branches — remain.)
  IDA has resolved all code flow, data pointers and offset references in the DB, so 0 external xrefs is the
  decisive result.
- **Opcode-anchored abs24.** Whole-image scan for `jsr @aa:24` (`0x5E`) and `jmp @aa:24` (`0x5A`) whose
  24-bit target lands in the range: **0**.
- **BE32 / BE24 value scan.** The only byte-coincidences are not references: one BE32 value `0x00054B00` at
  file `0x04E9FB` and the same bytes as BE24 at `0x04E9FC` are one entry of a monotonic numeric table
  (`…00 03 ae 00 | 00 04 6a 00 | 00 05 4b 00 | 00 06 59 00 | 00 07 9d 00 | 00 09 22 00…`, i.e.
  `0x3AE00, 0x46A00, 0x54B00, 0x65900, 0x79D00, 0x92200`), a value sequence, not a pointer; and one BE24
  `0x054B04` at file `0x001A12` (`…05 e5 | 05 4b 04 | 60 04…`) that is not preceded by a `0x5E`/`0x5A` call
  or jump opcode. The DB assigns no offset xref from either site (consistent with the 0 external xrefs).
- **Physical entry.** The only way into `0x054AE2 4b 0c` (`bmi`) is fall-through from `0x054ADE
  6a 0a a5 1a` (`mov.b @0xFFFFA51A:16,r2l`, which sets N). A function cannot begin with a `bmi` on a
  predecessor's flags, so the H9 `fnindex` start is a mis-split of the routine `0x054AC0`…`rts 0x054BF6`;
  its head `0x054AC0`–`0x054AE1` was already unproven (H9 `demoted.tsv` l.793). The only external edge near
  the routine is `0x002214 5e 05 4b f8` → `sub_54BF8` (the separate 26-B routine `0x054BF8`–`0x054C11`,
  which stays proven). This reproduces doc 83's addendum.

### 3. Window opened to 336 heads, DB matches the proven mask (Confirmed)

FINAL4 held the window "closed" at 99 code heads; its proven mask credited 220 window bytes that fit inside
those 99 heads. FINAL5 credits the full 1,088 window code bytes (220 + 868), so the DB must contain them as
code. The job creates doc 95's 336 heads (byte-verified 336/336 against the image, collar drift 0), covering
`0x078106`–`0x078545` with no gap. After the build, **final5 proven mask = 369,214 set, proven bytes NOT DB
code = 0** — the subset invariant holds. The 18 window routine entries are functions (18/18). Outside the
window, code bytes are unchanged (`codebytes_scope` delta 0), so the window open touched nothing else.

### 4. DB is a fixed point (Confirmed, `MAIN_FINAL5_log.txt`)

| Pass | funcs | heads | codebytes (outside win) | win heads | odd | xrefs from code | layout hash | win hash |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | --- | --- |
| seed (K1_MAIN_FINAL4) | 5,451 | 124,130 | 390,660 | 99 | 0 | 177,965 | `fe4f9af1…` | `6ff215a0…` |
| `build` | 5,463 | 124,367 | 390,660 | 336 | 0 | 178,254 | `42111f94…` | `d722152f…` |
| `verify` (`--reopen`) | **5,463** | **124,367** | **390,660** | **336** | **0** | **178,254** | **`42111f94…`** | **`d722152f…`** |

The reopen delta is all zero (`hash_same=True`, `win_same=True`). Added over K1, all inside the window:
**+237 heads** (336 − 99), **+289 code xrefs**, and **+12 functions** net (the job deletes the window's old
functions, creates the 336 heads, then adds the 18 routine starts as functions — 16 by `add_func`, the other
two already present after the window plan — for a net +12 against K1's prior window function count).

### 5. Ledger (`ledger.tsv`, `final4-to-final5-diff.tsv`)

| Mask | FINAL4 | − demote | + window | FINAL5 |
| --- | ---: | ---: | ---: | ---: |
| proven | 368,624 | −278 | +868 | **369,214** |
| named | 497,451 | +0 | +868 | **498,319** |

Diff runs: proven loses one run (`0x054AE2`–`0x054BF8`, 278 B) and gains the 13 window runs (868 B); named
gains only the 13 window runs. Mask format unchanged from FINAL4: 1,048,576 bytes, one 0/1 byte per address,
zero above `0x07B754`. `final5_proven_mask.bin` sha256 prefix `0d5492ce5de1500b`; `final5_named_mask.bin`
`0bff9e2d27f9c121`.

### 6. Percent of content, and the decodable denominator (Confirmed definition; the 388,490 figure does NOT cleanly hold)

- MAIN proven **369,214 = 73.01 %** of 505,684 content. MAIN named **498,319 = 98.54 %** of content.
- The **388,490** denominator is defined in doc 39 (`recount.tsv`, row `DEC_corrected_final`): it is the
  corrected count of decodable (is_code) MAIN content bytes, reconciled to the IDA H1_RECOUNT dump
  (`items_h1.tsv`, is_code = 388,484) + 6. I confirmed `items_h1.tsv` sums to 388,484 is_code and that its
  **window coverage is exactly 99 heads / 318 bytes** — the window in its partial/closed state. So the
  388,490 denominator counted only 318 of the window's 1,088 decodable bytes.
- The FINAL5 numerator now credits all 1,088 window bytes (all decodable, 336/336 vs the oracle, doc 95).
  For the numerator and denominator to use the same decodable set, the denominator must add the 770 window
  bytes it omitted (1,088 − 318): **consistent denominator = 389,260**.
- Figures: against the published **388,490**, proven is **95.038 %** — but this is internally inconsistent
  (it credits window bytes the denominator excluded). Against the consistent **389,260**, proven is
  **94.850 %**. I recommend 94.85 %; a next pass that re-derives the decodable denominator over the
  now-fully-decoded window is the clean fix. Note the denominator figure is MAIN-only bookkeeping and has
  **no bearing on the headline**, which uses content (505,684) and total (1,029,972) denominators.

## USB relevance

The service window is the MAIN CDC-ACM / DSP-download personality (doc 95). Folding its 868 code bytes into
the proven/named masks is bookkeeping, not a new surface: the bytes were already read and named in doc 95,
and the window is gated (the `0x7D` strap, the USB ISR when `FF813A` ≠ 0, or DSP-WRITE state ≥ 5). No sample
or IQ path. The demoted range `0x054AE2`–`0x054BF7` is near the USB-function-ISR region but is a mis-split
UI/state routine with no inbound edge; its demotion removes nothing reachable. The answers on USB (Q1), SDR
(Q2) and DSP (Q3) are unchanged from the K wave.

## Open

1. **Re-derive the decodable denominator** over the now-fully-decoded window (389,260 is the consistent
   value I computed; a fresh H1-style recount would confirm it). Low priority; MAIN-only bookkeeping.
2. **The other 93 `fnindex`-only runs** (`ida\out\main-final4\fnindex-only-runs.tsv`, 4,572 B) — edge-check
   each before any demotion. `0x03C668` (820 B, J14's dead page writer) first. Lanes L2–L4 are on these in
   parallel; reconcile their proposals into a FINAL6 seed.
3. **Window routine naming.** The 18 window starts are default `sub_` names; name them from doc 95's roles
   (USB init, polled service, ISR demux, ring/endian helpers, SCI-C async init) for a readable seed.
4. `0x0781C6`, `0x0781DE`, `0x078256`, `0x07842E` decode and return but nothing points at them (doc 95); and
   `0x076ADE` / `0x076B20` have no absolute reference. These are inside the now-open window but unreferenced.

### Files (`ida\out\main-final5\`)

| File | Content |
| --- | --- |
| `final5_proven_mask.bin`, `final5_named_mask.bin` | the new masks (369,214 / 498,319 set) |
| `ledger.tsv` | rule-by-rule ledger with percentages |
| `final4-to-final5-diff.tsv` | contiguous diff runs: proven −1/+13, named +13 |
| `MAIN_FINAL5_codemask.bin` | DB code mask over `0x0`–`0x07B754` (superset of proven) |
| `MAIN_FINAL5_functions_raw.tsv`, `MAIN_FINAL5_log.txt` | function dump and the build/verify logs |
| `offline\l1_build_masks.py` | the offline mask builder and verifier |

DB: `ida\db\jobs\L1_MAIN_FINAL5\L1_MAIN_FINAL5.i64` (use as the next MAIN seed). Logs:
`ida\log\jobs\L1_MAIN_FINAL5\`.
