# L-wave reconciliation (orchestrator, 2026-10-03)

Owner-side static analysis only. Read-only on every input; nothing was written to a radio.
`decrypted\*.bin` unchanged (sha256 `8e3ecd05…` / `b93570b3…`).

These are **proposed MAIN_FINAL6 masks**. They are the ledger of record for the L wave, but no
seed database carries them yet (see "Next seed" below).

| File | What |
| --- | --- |
| `final6_proven_mask.bin` | 1,048,576 B, 0/1 per byte, popcount **364,786**, sha256 `ecd7deaf54da6d21…` |
| `final6_named_mask.bin` | 1,048,576 B, 0/1 per byte, popcount **501,656**, sha256 `fe8f60996e0a5852…`; proven ⊆ named; 0 bytes set above `0x07B754` |
| `recon_descent.py` | K1's folded descent (via L2's copy of its definitions) run three ways: with H9 fnindex seeds, without them, and without them plus the 6 new edges below |
| `drop_runs.tsv` | 89 runs / 4,742 B: final4-proven bytes reached only through fnindex seeds and **not** recovered by the new edges (includes the already-demoted `0x054AE2` 278 B and the 36 B restored by hand, see below) |
| `rec_runs.tsv` | 7 runs / 108 B recovered by the descent from the new edges |

## Proven: 369,214 → 364,786 (−4,428)

1. Start from L1's `ida\out\main-final5\final5_proven_mask.bin` (369,214).
2. New descent seeds (each Confirmed by bytes, re-read by the orchestrator):
   - L2: `0x018250` (`0x018276 7a 01 00 01 82 50`, `0x01827C 5e 01 52 06`), `0x018ABE`, `0x01A094` — er1 callbacks through
     `sub_15206` (`jsr @er1` at `0x015224 5d 10`; exactly 14 `5e 01 52 06` sites in the image).
   - L4: `0x05E8E0` (`0x05E862 7a 01 00 05 e8 e0 5e 01 52 06`), `0x066FB4`, `0x067250` (abs24 `jsr` from proven code).
3. Remove every byte in `drop_runs.tsv` that is still in final5 (4,464 B).
4. Restore `0x066FBE`–`0x066FC7` (10 B) and `0x06726A`–`0x067283` (26 B). Each L4 "REACHED" run is two tiny
   routines; the second ones are called by abs24 `jsr` from proven code (`0x06AB36`/`0x06AE10 5e 06 6f be`,
   `0x06AB2A`/`0x06AE04 5e 06 72 6a`, plus `bsr` at `0x067246`). Those callers are set in the final4 proven mask
   but are not reached by the full folded descent (checked against L2's saved descent result: `0x06AB1C`,
   `0x06AB2A`, `0x06AB36`, `0x06AE04`, `0x06AE10`, `0x062808`, `0x06723A` all P4=1, descent=0). The final4-proven
   bytes the full descent does not reach total 1,692 B in 80 runs (largest `0x05C8DC` 218 B, `0x0460C2` 110 B,
   `0x03D0EE` 98 B). Net −4,428.

Per lane: L2 884 + L3 2,532 + L4 1,012 = 4,428 (exact). L4's 1,012 = 696 dead/split-tail + 26 data + 290 USB-module
bytes `0x077CC2` (206) / `0x07778C` (84), demoted because their only callers are the stubs `0x033790`/`0x0337AC`/
`0x0337C8` in routine `0x033780`, which has **no** BE32 pointer, abs24 call or reachable relative branch anywhere in
the image (orchestrator scan; L3's verdict over L4's "window-only" reading — L4's own doc line 145 concedes it).

Check after the drop: the only remaining edges from proven code into dropped bytes are `mov.l #imm` loads of the
data-mistyped tables, the dead callers L2/L3 list as companions (`0x0076DA`, `0x01C28E`, `0x0460C8`/`D6`/`0x046104`/
`2A`), and L4's four vestigial er5 handlers (loaded, never called).

Not applied (left for a later pass): L2's 30 B and L3's 116 B companion bytes; L5's 4 B stale-head gap
(`0x006A0C`, `0x0077F8` — not reached by the descent either, so they need the DB fix first); L5's 120 B Inferred
proven-data candidates; L8's three 26 B fragments (already unproven).

## Named: 498,319 → 501,656 (+3,337)

L5's Confirmed typing tier (`ida\out\main-unnamed\proposed-typing.tsv`, rows with `typing_conf = Confirmed`,
522 rows). L6's +28 B (`0x010CC0`–`0x010CC3`, `0x011038`–`0x01104F`) are inside that set (+0 extra). Demotions do not
change named (I12 convention, confirmed by L1). L5's Inferred tier (3,934 B, 2,880 of it dead code) is not credited.

## Headline

    MAIN named 501,656 + SUB window code 464,263 = 965,919 / 1,029,972 = 93.78%   (was 93.46%)
    MAIN named/typed 501,656 / 505,684 = 99.20%;   MAIN proven 364,786 = 72.14% of content
    % of decodable: 364,786 / 389,260 = 93.71% (L1's corrected denominator; the published 388,490 counted only
    318 of the service window's 1,088 decodable bytes)

## Next seed (MAIN_FINAL6)

Copy `ida\db\jobs\L1_MAIN_FINAL5\L1_MAIN_FINAL5.i64`; drop the H9 fnindex seeds that fall inside `drop_runs.tsv`;
add the 8 entry points above (6 seeds + `0x066FBE`, `0x06726A`); retype the 250 B of data-mistyped runs (L2 80,
L3 144, L4 26) as data; apply L5's Confirmed typing (`ida\jobs\l5_apply_typing.py`, written for a FINAL4 copy —
re-check its 22 skipped rows against the opened window); re-derive both masks from one run and require equality
with the two files here.
