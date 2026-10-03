# 128 — The MAIN_FINAL7 seed (Lane N1)

> Lane N1, model `claude-opus-5-5`. Owner-side, strictly read-only static analysis of
> `decrypted\FT3D_MAIN_ver102_EXP.bin` (MAIN, H8SX `h8sxa`, base 0, big-endian, file offset = mapped address).
> Image sha256 `8e3ecd05409b2c31…` and SUB `b93570b3c2f69ccb…` were checked at the start and again at the end of
> the lane, both unchanged. No image byte was modified (no `patch_*`), and nothing was connected to, enumerated on,
> written to or flashed to any radio or device. Only my DB `ida\db\jobs\N1_MAIN_FINAL7\N1_MAIN_FINAL7.i64` was
> opened; it was seeded `--copy-from ida\db\jobs\M1_MAIN_FINAL6\M1_MAIN_FINAL6.i64` (doc 113). The M-wave published
> masks were read only, never rewritten. Tables: `ida\out\main-final7\`. Jobs: `ida\jobs\n1_apply_main_final7.py`,
> `ida\out\main-final7\offline\n1_build_masks.py`, `ida\out\main-final7\offline\n1_verify_bytes.py`.

## Verdict

**MAIN_FINAL7 is built, and one run re-derives both published M-wave masks byte for byte.**

| mask | popcount | sha256 |
| --- | ---: | --- |
| `ida\out\main-final7\final7_proven_mask.bin` | **365,358** | `5585a9c6d810d96401a6dbd14eadabc575893e8c890dd39263e1df00040d58db` |
| `ida\out\main-final7\final7_named_mask.bin` | **505,165** | `0bcf995b1087e72397fc67e8f2e8487ddae0010ba312dfd58ae000f7fdf7fdd2` |

Both files are byte-equal to `ida\out\m-wave-recon\final7_{proven,named}_mask.bin` (0 differing bytes, so no
difference list). **The published FINAL7 recipe is correct; the named delta from this lane is 0.**

- **Seed:** `ida\db\jobs\N1_MAIN_FINAL7\N1_MAIN_FINAL7.i64`, sha256
  **`7b41e1f3664e8b660b9404142b594aae583825265bd47d7ea6f71842ef071f73`**.
- **Fixed point:** a `--reopen` recognises every planned run as already in its target state
  (`skip_code=145`, `skip_data=65`, `0` edits) and changes **0** functions, heads, code bytes, data bytes and
  xrefs. The layout hash is **`b65c70d2dbd39795`** (L1/M1-compatible: code heads plus functions); the typed hash,
  which also covers data heads, is `e0c9ed182d4a1e70`. Build-pass and reopen-pass hashes are identical.
- **Odd code heads:** 0 over the whole content.
- **Proven bytes:** all 365,358 are DB code (0 that are not).

**Ledger**

- **Proven:** 364,786 → 365,358. That is **−1,544** (1,472 B M2/M3/M4 dead runs + 72 B dropped leaves) **+2,116**
  (390 B M6 record fields + 1,726 B M7 CDC handlers).
- **Named:** 501,656 → 505,165, **+3,509** (union of M5 2,880, M6 635, M8 27; the 43 B stale copy `0x069A7F` is
  held out per the README).
- **Headline:** 505,165 + SUB window code 464,263 = 969,428 / 1,029,972 = **94.12 %**.

## Method

Every step ran in this session; IDA was run only through `run_job.py`.

1. **Mask re-derivation** (`offline\n1_build_masks.py`, ~8 s). It `exec`s the M-wave `_base.py` (reproduces FINAL4/5/6
   and asserts each against its published file), then runs **one** folded descent with the fnindex seeds cleared and
   the entry points re-validated to a fixpoint (65 entries, stable at iter 1): the four kept L2/L4 er1 callbacks
   (`0x018250`/`0x018ABE`/`0x01A094`/`0x05E8E0`, all four sources reached), the `sub_15260` record fields (17 of 17
   records have a reached loader), and the six CDC handler records at `0x07B4B4 + 10k + 6`. The four dead leaves
   (`0x066FB4`/`0x067250`/`0x066FBE`/`0x06726A`) are reached by nothing and drop out. FINAL7 proven = descent bytes +
   the whole service window `0x078106`–`0x078545`; FINAL7 named = FINAL6 named + proven + M5 Confirmed + the M6
   Confirmed tiers + M8. The result is asserted byte-equal to both published m-wave files.
2. **DB edit plan** (resolved directly from the published M-wave tables; `n1_apply_main_final7.py::build_plan`). The
   FINAL6 DB already holds the M7 CDC handler block (`0x0767BE`–`0x076ADE`, `0x076C0A`–`0x076FC8`, `0x07711E`–`0x0771E2`)
   as code and the M6 core run `0x01687E` as code, so the only edits needed are:
   - **CODE** (`del_items` + linear `create_insn`): the M6 proposed-proven runs
     (`ida\out\inferred-tables\proposed-proven.tsv`, core 148 B + companion 242 B = 390 B, 10 runs) and the M5
     dead-code rows (`ida\out\dead-code-tier\proposed-typing.tsv`, 135 `create_insn` rows, 2,878 B).
   - **DATA** (`del_items` + `create_byte` / `create_dword`+offset): the M6 Confirmed table rows
     (`ida\out\inferred-tables\proposed-typing.tsv`, C-read/C-extent, 63 rows, 575 B) and the two DATA-MISTYPED
     retypes `0x00932A`–`0x009332` (8 B byte table, doc 114 / M2) and `0x03D1C6`–`0x03D1CA` (4 B packed-BCD cell,
     doc 115 / M3).
   An offline simulation against the FINAL6 heads dump first confirmed 0 straddles of a proven item, 0 code/data
   overlap, and that the plan makes every FINAL7-proven byte code and every M5/M6 Confirmed byte typed.
3. **Build** (`n1_apply_main_final7.py`, `--copy-from` M1_MAIN_FINAL6, tag `build`, then `--reopen`, tag `verify`).
   Auto-analysis is turned off while editing; the `AU_CODE`/`AU_PROC`/`AU_USED` queues are cleared before it is
   turned back on, so no flow-on code or function appears. A data row whose edge a **non-proven** mis-decoded code
   item crosses deletes that neighbour with the row (it becomes unknown — the 16/18 neighbour bytes doc 118 §6
   predicts); a row whose edge a **proven** item would cross is refused (0 such rows occurred).
4. **Citations** (`offline\n1_verify_bytes.py`): 10/10 byte citations in this document match the image.

**Not done (by design).** I did not add the 519 unset named bytes (that is lane N2), did not credit the 43 B stale
copy `0x069A7F`, did not delete the four dead-leaf functions (they drop from the proven *mask* only and stay DB
code), and did not type the 76,898 named-but-unexplored DB bytes (pre-existing strings/closed-window residue,
doc 113 §5; unchanged in scope).

## Findings

### 1. The masks are re-derived, not copied (Confirmed, `build_log.txt`)

| step | proven | named | equals |
| --- | ---: | ---: | --- |
| FINAL6 (one base run) | 364,786 | 501,656 | both `l-wave-recon\final6_*` |
| FINAL7 proven = FINAL6 −1,544 +2,116 | 365,358 | | `m-wave-recon\final7_proven_mask.bin` |
| FINAL7 named = FINAL6 +3,509 | | 505,165 | `m-wave-recon\final7_named_mask.bin` |

Proven ⊆ named holds, nothing is set above `0x07B754`, and both masks are byte-equal to the published files
(`differing-runs=0`).

### 2. DB build and the fixed point (Confirmed, `MAIN_FINAL7_log.txt`)

| measure | FINAL6 seed → FINAL7 | change |
| --- | --- | ---: |
| functions | 5,340 → 5,331 | −9 |
| code heads | 123,697 → 123,765 | +68 |
| data heads | 6,861 → 6,923 | +62 |
| code bytes | 390,452 → 390,926 | +474 |
| data bytes | 37,169 → 37,722 | +553 |
| odd code heads | 0 → 0 | 0 |

The build applied 77 code runs (68 runs were already code and were skipped) and 62 data runs (`dword` for the BCD
cell). The 9 deleted functions are dead-code / table pieces whose start head an edit retyped. **The reopen pass is a
true no-op** — it recognises all 145 code runs and 65 data runs as already in state, makes 0 edits, and reproduces
the identical layout hash `b65c70d2dbd39795`.

| DB invariant | result |
| --- | --- |
| image bytes == DB bytes over `0`–`0x7B753` | True |
| FINAL7 proven bytes that are not DB code | **0** of 365,358 |
| M5 dead-code bytes that are DB code | 2,878 / 2,878 |
| M6 proposed-proven bytes that are DB code | 390 / 390 |
| M6 table bytes that are DB data | 575 / 575 |
| DATA-MISTYPED retypes that are DB data | `0x00932A` 8/8, `0x03D1C6` 4/4 |
| odd code heads (whole content) | 0 |

### 3. The DATA-MISTYPED retypes (Confirmed by bytes)

- `0x00932A`–`0x009332` = `05 04 02 03 04 04 04 00`: head of the byte lookup table the proven code at `0x00929E`
  reads indexed (doc 114 §3). Now DB data.
- `0x03D1C6`–`0x03D1CA` = `00 40 00 00`: low word of the packed-BCD constant the proven reader `0x03D1B4`
  (`mov.l #0x3D1C6,er6`) passes to the BCD routine `0x3F94C` (doc 115). Now a 4-B DB data cell. Neither range is in
  the FINAL7 proven mask, so retyping them to data removes no proven byte.

### 4. The four dead leaves drop from proven only (Confirmed)

`0x066FB4`, `0x067250`, `0x066FBE`, `0x06726A` are reached by the FINAL7 descent **by nothing** (every caller is a
dead WIRES-X case arm, doc 116 §B/§C). They leave the proven mask (part of the −72 B / 2 runs
`066FB4`–`066FC8`, `067250`–`067284`). In the DB they stay code and keep their functions — the drop is a mask
decision, not a typing one.

### 5. M7's CDC handlers were already code in the FINAL6 seed (Confirmed)

The 1,726 B of newly-proven CDC code (`0x0767BE`–`0x076ADE`, `0x076C0A`–`0x076FC8` and the reached part of
`0x07711E`–`0x0771E2`) is already DB code in M1_MAIN_FINAL6 (the L1 service-window open decoded it), so FINAL7
needs no CDC typing edit — only the mask credits it as proven, via the six handler-record `+6` pointer seeds
(e.g. `0x07B4BA 00 07 84 be`, `0x07B4E2 00 07 67 be`). The 52 B `0x0771AE`–`0x0771E2` remain named-not-proven,
unreached (README / doc 119). The only "make code" edits are the 390 B of M6 record fields (the companion fields
like `0x01794E`, `0x018FAA`, `0x05E812`, 232 B of which were untyped in FINAL6) plus M5's dead code.

## USB relevance

This is bookkeeping; the three mission answers are unchanged.

- **Q1 (USB):** the only USB-adjacent movement is that the CDC-ACM request parser and live handlers become **proven**
  (they were already named code). No USB register, descriptor or endpoint moved; the surface is still exactly the
  two personalities (vendor `26AA:0001`, CDC `26AA:0020`) of docs 95/119. The four dead leaves that leave proven are
  SCI-A WIRES-X reply-builder arms, not USB.
- **Q2 (SDR):** no sample/IQ path appears. The M6 tables credited here are band edges, tone pairs and labels.
- **Q3 (DSP):** no DSP bus exposure is added. The CDC path's far end remains the DSP command/download link over
  SCI-C, reachable only in the strap/DSP-WRITE service mode.

## Open (most valuable first)

1. **Lane N2:** add the 519 unset named bytes (the remaining C-read/C-extent-but-untyped tables and the proposed
   proven-code already counted in named) and decide the 43 B stale copy `0x069A7F`; re-derive named.
2. **Name the 9 deleted functions and any orphaned heads** the retypes left, and re-type the 16 neighbour bytes
   (`0x040034`… / `0x04E8CE`… / `0x06C56E`) that went code→unknown with their tables (doc 118 open 2).
3. **The 76,898 named-but-unexplored DB bytes** (strings, closed window) — type the settled classes so the DB and the
   named ledger converge (same open item as doc 113 §5).

## Files (`ida\out\main-final7\`)

| file | content |
| --- | --- |
| `final7_proven_mask.bin`, `final7_named_mask.bin`, `masks-sha256.txt` | the masks (365,358 / 505,165 set), byte-equal to the m-wave files |
| `ledger.tsv`, `final6-to-final7-diff.tsv`, `build_log.txt` | ledger, the proven-removed/added and named-added runs, mask-builder log |
| `MAIN_FINAL7_log.txt` | build and reopen logs (fingerprints, deltas, invariants) |
| `MAIN_FINAL7_typemask.bin`, `MAIN_FINAL7_codemask.bin`, `MAIN_FINAL7_heads.tsv`, `MAIN_FINAL7_functions_raw.tsv` | DB per-byte type (0 unk, 1 code, 2 data), code mask, heads, functions |
| `offline\n1_build_masks.py`, `n1_verify_bytes.py` | one-run mask builder + DB invariant check; citation checker |
| `ida\jobs\n1_apply_main_final7.py` | the idempotent build/verify job (private DB only) |
