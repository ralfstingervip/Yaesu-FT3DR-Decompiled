# 83 — The one-descent MAIN seed MAIN_FINAL4 (Lane K1)

> Lane K1, model `claude-opus-5-5`. Owner-side static analysis of `decrypted\FT3D_MAIN_ver102_EXP.bin` (MAIN, H8SX
> `h8sxa`, base 0, big-endian, so file offset = mapped address; sha256 prefix `8e3ecd05409b2c31`, re-checked, unchanged;
> SUB `b93570b3c2f69ccb`, unchanged). No image byte was modified (no `patch_*`), and nothing was connected to or written to
> any radio or device. Only my DB `ida\db\jobs\K1_MAIN_FINAL4\K1_MAIN_FINAL4.i64` was opened, seeded with
> `--copy-from ida\db\jobs\J1_MAIN_FINAL3\J1_MAIN_FINAL3.i64`, which only reads the seed. The closed window
> `0x078106`–`0x07B753` was not analysed: its 99 code heads are snapshotted and restored (identical to J1's
> `window_seed.tsv`), and no byte in it is credited. No market/destination/band-edge logic was decoded.
> Tables: `ida\out\main-final4\`. Job: `ida\jobs\k1_apply_main_final4.py`. Offline builder:
> `ida\out\main-final4\offline\k1_build_masks.py`.

## Verdict

**MAIN proven = 368,624 B and MAIN named/typed = 497,451 B, both from one folded descent with no hand patches.** The
MAIN_FINAL4 DB is a true fixed point (a `--reopen` pass changes 0 functions, 0 heads, 0 code bytes, 0 xrefs and 0 typed
items) with 0 odd heads, and all 368,624 proven bytes are DB code. Two rule changes, not patches, carry the gain over
FINAL3 (368,366):

- **K1a, +72 B: `0x04E2D6`.** The descent already walked table `0x04ABE4` to its full 256 entries. Slot 68 was missing
  because H2 had excluded it with the reason "target is mid_code in seed". That reason describes a stale seed-DB layout,
  not the table. H2 has exactly six exclusions of this kind. Withdrawing them re-admits table `0x04ABE4` slots
  68/134/154/245 and `0x04AB70` slots 97/163/183/274/358, all pointing to `0x04E2D6`, plus `0x034674[2]` → `0x034CCE`,
  which I8 had already seeded. This **corrects J2's cause**: the descent did not truncate the walk of `0x04ABE4`; the
  slot was excluded.
- **K1b, +186 B: J4's +16 B are now Confirmed, plus 170 B of the same kind.** The indexed-jmp reader for J4's three
  stubs is pinned. Proven `0x02B3A8 mov.l #0x2B3C2,er6; jmp @0x028616` enters a bounded touch-index helper:
  `mov.w @0xFFBBC2,r4; cmp.w #9; bcc; dec.w #1; bmi; …; add.l er4,er6; mov.l @er6,er6; jsr @er6` (`0x028630`). Slots
  5/6/7 of table `0x02B3C2` are `0x065EFA`/`0x065F00`/`0x065F06`, reached for touch index 6/7/8. This is one of eleven
  such helpers. Folding the helper family into the descent as a rule (68 `mov.l #T,er6` sites and 3 two-level sites, 79
  tables, 642 slots) reaches 12 runs. J4's 16 B are one of them; the other 170 B are eight more touch-key stubs that the
  descent had never reached.

The named figure adds +2 B for the `Baro/-hPa` label header and +40 B for helper slot-table tails that were not typed
before. **The touch-zone tables add 0 named bytes, because they were already typed.** There are **99** zone tables, not
J3's nine (5,296 B). All 5,296 B were already in the named mask through W2-8's typed runs, so typing them as
`touch_zone_t` struct arrays (done) moves no headline byte.

**Headline: MAIN named 497,451 + SUB 464,263 = 961,714 / 1,029,972 = 93.373 %** (was 93.37 % / 961,647; +67 B on the
J-wave figure).

If the orchestrator credits only J4's three stubs from K1b and not the other 170 B: proven **368,454**, named
**497,387**, headline 961,650 = 93.367 %. The extra 170 B come from the same rule and meet the same evidence grade (see
Findings 2). I recommend crediting them.

## Method

All passes below were run this session. IDA ran only through `run_job.py`.

1. **Offline one-descent builder** (`offline\k1_build_masks.py`, plain Python, read-only on every input). It imports
   H9's `descent.py`/`analyze.py` unchanged and never runs them as `__main__`. It writes no `__pycache__`.
   - Asserts H9 proven = `h9_proven_mask.bin` (365,570) and H9's baseline descent = 363,758 B.
   - Rebuilds J1's folded seed set (I6 exit table, I8, I9, I15 strict edges) verbatim. It asserts that the single run
     with I12 −120 applied reproduces `final3_proven_mask.bin` **byte for byte** (368,366).
   - **K1a.** Rebuilds `descent.TAB` in memory from `main-full\{jumptables,switch_tables}.tsv`, applying every H2
     exclusion except the six `mid_code in seed` rows. It asserts that the remaining exclusions plus those six equal
     H2's set, that no existing slot changed, and that every re-admitted slot is one of the six (`k1a-slots.tsv`).
   - **K1b.** Finds the helper family by an exact byte signature: 11 helpers, `0x02853E`…`0x0286A6`, N = 3, 4, 5, 6, 7,
     8, 9, 10, 11, 19 and 23. Each helper must be reached. The rule fires at a reached site of either form below,
     provided no write to `er6` falls between the load and the jump, and then credits `T[0..N-2]`:
     - `mov.l #T,er6` followed within 4 reached instructions by `jmp/jsr @helper:24`.
     - The two-level form `mov.l @(L:32,er4),er6; jmp @helper`. Here the L1 entries stop structurally at the lowest
       sub-table address.

     A fixpoint wrapper around `descent.run` adds these edges until nothing new appears. This is one folded descent.
   - Attribution runs use each rule alone. The folded run then gives: newly reached beyond J1's union = **258 B** = K1a
     72 + K1b 186, K1a ∩ K1b = 0, J1 bytes lost = 0, both I12 blocks reached 0 B, and window bytes 0.
   - The builder writes the masks, the ledger and the IDA plan files.
2. **Seed build.** `run_job.py --script ida\jobs\k1_apply_main_final4.py --db K1_MAIN_FINAL4 --copy-from J1_MAIN_FINAL3`
   (tag `build`), then `--reopen` (tag `verify`). The job:
   - tiles the 79 new heads to the descent's lengths;
   - types the label as u16 + 13-char string + `0xFF`;
   - types the 99 zone tables as a `u16` count plus a `touch_zone_t[n]` struct array (`lo_x16_y16` dd, `hi_x16_y16` dd,
     `button_idx` dw; 10 B), with a byte tail where the declared count overruns;
   - types the 79 helper tables, 3 L1 tables and K1a cells as dword offsets (660 cells);
   - adds functions at the slot targets and 16 user crefs from each helper's `jsr @er6` and from `0x052232`/`0x04AB6C`;
   - sweeps odd heads and restores the window.

   It never runs a broad re-plan, and calls `auto_wait()` only after its own edits.

**Not done.** I did not prove at runtime that `0xFFBBC2` takes each value 1..N−1 on each screen (see Findings 2 for
the grade). I did not search for touch-zone tables passed by any mechanism other than `mov.l #T,er5` → `jsr/jmp`
`0x026F08`/`0x026F9C` within 8 instructions. I did not rename the K1b stubs beyond IDA's default `sub_` names, and I
did not enter the closed window.

## Findings

### 1. K1a: why `0x04E2D6` was missed, and the rule that recovers it (Confirmed)

The site is `0x052222 7a 63 00 00 00 ff` (`and.l #0xff,er3`), `10 73`, then `78 b0 6b 26 00 04 ab e4`
(`mov.l @(0x4ABE4:32,er3),er6`), then `0x052232 5d 60` (`jsr @er6`). The table cell is `0x04ACF4 = 00 04 e2 d6`.

`main-full\switch_tables.tsv` already lists `0x04ABE4` at 256 entries, and `jumptables.tsv` lists `0x04AB70` at 389, so
the descent's walk covers slot 68. The slot was dropped by `h8sx-seed\table-xrefs-excluded.tsv`, which has six rows
with the reason `target is mid_code in seed (inside an existing item)`:

- `0x03467C` → `0x034CCE`
- `0x04ACF4`, `0x04ADFC`, `0x04AE4C`, `0x04AFB8`, `0x04B108` → `0x04E2D6`

The descent works on the binutils oracle, not on the seed DB layout, so this reason does not apply to it. Withdrawing
it re-admits 10 (table, slot) pairs (`k1a-slots.tsv`) and reaches exactly `0x04E2D6`–`0x04E31E`: 72 B, 23 instructions
ending in `rts` at `0x04E31C`. No other byte is reached; `0x034CCE` was already in J1 through I8's seed.

The handler loads `#0x4E31E` (its label), reads `0xFFBBE9`, copies the label into `0xFFB05A+idx` until `0xFF`, and
calls `0x052780`. The label is `0x04E31E 00 0e 42 61 72 6f 20 20 20 20 20 2d 68 50 61 ff`, a u16 header plus
"Baro     -hPa" plus `0xFF`. It is now typed; 2 B of it (the header) are newly named.

### 2. K1b: the touch-index helper tables, which pin J4's reader (`helper-tables.tsv`, `new-proven-runs.tsv`)

**J4's reader (Confirmed bytes and disassembly).**

- `0x02B3A8 7a 06 00 02 b3 c2` = `mov.l #0x2B3C2,er6`, then `5a 02 86 16` = `jmp @0x028616`. Both are proven.
- Helper `0x028616 6b 04 bb c2 | 79 24 00 09 | 44 14 | 1b 54 | 4b 10 | 79 0c 00 00 | 10 74 | 0a c6 | 01 00 69 66 | 5d 60`:
  `r4 = @0xFFBBC2`; skip if `r4 ≥ 9` or `r4 = 0`; then `er6 = @(T + 4·(r4−1))`; `jsr @er6` at `0x028630`.
- Table `0x02B3C2 = 0002B3B2 ×5, 00065EFA, 00065F00, 00065F06`. Exactly 8 = N−1 slots, and the next byte
  `0x02B3E2` is proven code (`7a 06 00 02 b4 1a`).

So `0x065EFA`/`0x065F00`/`0x065F06` are slots 5/6/7, which is touch-button index 6/7/8.

**Correction to doc 72 (J4).** The cells are at `0x02B3D6`/`0x02B3DA`/`0x02B3DE`, not `0x02B3DC`/`0x02B3E0`. The reader
is helper `0x028616`, not an indexed `jmp` inside `0x065Exx`.

**The family.** I8 listed nine of these helper `jsr @er6` sites as `reg_table_unresolved` (`indirect-cb\sites.tsv`:
`0x028558`, `0x02857C`, `0x0285C4`, `0x0285E8`, `0x02860C`, `0x028630`, `0x028654`, `0x02869C`, `0x0286C0`). All 11
helpers share the signature with `N = cmp.w #N`. They are reached from:

- 68 `mov.l #T,er6` sites;
- 3 two-level sites, for example `0x02C208 78 c0 6b 26 00 02 c2 ba 5a 02 85 86`, where L1 `0x02C2BA` =
  `0002C2CA 0002C2DA 0002C2EA 0002C2FA` ends exactly at its first sub-table, and the L1 index is byte `0xFFBC35`.

That gives 79 tables and 642 slots, all of them even content pointers. Every table ends exactly where proven code or
the next table begins (`after_table` column).

**New proven runs (all decode cleanly; each ends in `rts`, or branches or falls into already-proven code):**

| Run | B | Reached as | First bytes / role |
| --- | ---: | --- | --- |
| `0x0179DA`–`0x0179E2` | 8 | `0x0287E2[1]` via `0x02877E`, helper N=10 | `6a 10 a9 fa 73 00 47 1e`, btst `0xFFA9FA`, falls into proven `0x0179E2` |
| `0x029174`–`0x02917A` | 6 | `0x02917A[3]` via `0x02916A`, N=7 | `jsr @0x2010C; rts` |
| `0x02B026`–`0x02B030` | 10 | `0x02B032[0..4]` via `0x02B01C`, N=9 | `jsr @0x2B21C; bmi; jsr @0x608A6` |
| `0x02B36A`–`0x02B37C` | 18 | `0x02B37E[0..4]` via `0x02B360`, N=9 | `jsr @0x2B21C; …; mov.b r1l,@0xB3F1; jsr @0x65B04` |
| `0x02B3B2`–`0x02B3C0` | 14 | `0x02B3C2[0..4]` via `0x02B3A8`, N=9 | `jsr @0x2B21C; bmi; mov.b @0xB3EB,r1l; jsr @0x65ED4` |
| `0x02B64A`–`0x02B68A` | 64 | `0x02B68A[0..5,8]` via `0x02B5D2`, N=10 | two stubs (`0x02B64A`, `0x02B678`): `bset #5,@0xBBF2; … jsr @0x6517A; rts` |
| `0x02B8BC`–`0x02B8C6` | 10 | `0x02B8C6[3]` via `0x02B8B2`, N=6 | `jsr @0x2B92C; jsr @0x64BE6; rts` |
| `0x02C25E`–`0x02C268` | 10 | sub-tables of L1 `0x02C2BA`, slot 3, via `0x02C208`, N=5 | `bsr 0x2C268; mov.b #2,r4l; mov.b r4l,@0xBAD8; rts` |
| `0x064BE6`–`0x064BF6` | 16 | `jsr @0x64BE6` from new `0x02B8C0`, plus `0x02B8C6[4]` = `0x064BEE` | `mov.b #0xA/#0xB,r4l; mov.b r4l,@0xB3EB; bra 0x64C00` |
| **`0x065EFA`–`0x065F0A`** | **16** | `0x02B3C2[5,6,7]` via `0x02B3A8`, N=9 (**J4**) | `jsr @0x65B66/86/A6; bra 0x65F30` |
| `0x0696BC`–`0x0696CA` | 14 | `0x02A572[2]` via `0x02A542`, N=4 | `mov.b @0xB3F3,r4l; cmp.b #1; beq; bra` |

The run total is 186 B; adding `0x04E2D6` (K1a, 72 B) gives 258 B. All runs lie outside the window and the I12 blocks,
and none overlaps FINAL3 (`ledger-delta.tsv`).

**Grade.** Each run's evidence is Confirmed: the table bytes, the load of its base by proven code, the helper's index
bound, and the decode. One assumption remains, which is **Inferred**: that the touch hit-test can return each slot's
index on that screen. This is the same assumption every table rule in the ledger already rests on: H1's 149 tables are
credited ungated in `full` mode, and I15's record fields on the same `0xFFBBC2` selector were credited the same way.

The bound check makes slots 0..N−2 reachable exactly when `0xFFBBC2 ∈ 1..N−1`. The hit-test writes `0xFFBBC2` only
from zone `button_idx` values, and 1..8 occur widely; for example, zone table `0x0283B0` emits 6/7/8. The two-level
case at `0x02C25E` (10 B) also rests on a structural L1 bound, because the L1 index byte `0xFFBC35` is not range-checked.

I therefore credit K1b as the descent's rule. I have not hand-picked J4's 16 B.

### 3. Touch-zone tables: 99, not 9 (`touch-zone-tables.tsv`)

The format is confirmed from `sub_26F08` (`0x026F08 6d 56` = `mov.w @er5+,r6`, the count, then a 10-B stride with
`add.l #0xa,er5` at `0x026F28`) and is the same for its sibling `0x026F9C`. Scanning every oracle instruction for
`mov.l #T,er5` followed by `jsr/jmp @0x026F08` or `@0x026F9C` finds **99 tables**, `0x02702A`–`0x02853E`, all
referenced from proven sites `0x0266EE`–`0x026EF4` and `0x028F6E`. J3's nine are among them.

- **Size.** The 99 tables total **5,296 B**, with 0 proven bytes and 0 DB code bytes after typing.
- **Overruns.** Three tables declare one record too many: `0x027648` (14), `0x0276D2` (18) and `0x027784` (15) each
  overrun the next table by 4 B. The phantom last record begins with the bytes `81 0f 9e 29` at `0x0276CC`, so
  `Xmin = 0x810F`, and the matcher's `cmp.w e4,e2; bcs` means no on-panel X ≤ 319 can ever hit it. It is harmless
  (Confirmed bytes and code; the intent is Unknown). These are typed as `count-1` struct records plus a 6-B byte tail.
- **Off-panel zone.** `0x027CB0` record 4 reaches Y = `0x13D`, below the 240-line panel. It is still matchable within
  the panel.
- **Named effect: +0.** All 5,296 B were already named. They are W2-8 typed runs (`masks.B`), so typing them as
  `touch_zone_t[n]` (99/99 struct arrays in the DB) improves structure but not the ledger.

### 4. Ledger (`ledger.tsv`, `ledger-delta.tsv`)

| Mask | final3 | final4 | Δ | final3 ∖ final4 | Δ in window | Δ in I12 |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| proven | 368,366 | **368,624** | +258 | 0 | 0 | 0 |
| named | 497,314 | **497,451** | +137 | 0 | 0 | 0 |

**Proven +258** = K1a `0x04E2D6` 72 + K1b 186 (12 runs above).

**Named +137** breaks down as:
- 95 newly named proven code: `0x04E2D8`–`0x04E31E` 70, `0x02B026` 10, `0x02B3B2` 14, `0x065F01` 1;
- 2 for the `Baro` header `0x04E31E`;
- 40 for helper slot-table tails that W2-8 had left untyped (15 runs of 2–4 B, for example `0x02881A`–`0x02881E` and
  `0x02C306`–`0x02C30A`);
- 0 for the zone tables.

The proven mask is a subset of the named mask (0 proven bytes unnamed). Overlaps are all 0: K1a ∩ K1b, Δ ∩ final3,
Δ ∩ window, Δ ∩ I12, zone ∩ proven, helper tables ∩ proven, and zone ∩ helper tables.

**Mask format and hashes.** The masks use the same format as main-final3: 1,048,576 bytes, one byte per address (0/1),
zero above `0x7B754`.
- `final4_proven_mask.bin`: sha256 prefix `3a45f1f46b36a47f`
- `final4_named_mask.bin`: sha256 prefix `2b8255b683ca474a`

**Percentages.** Proven is 72.896 % of 505,684 content and 94.886 % of 388,490 decodable. Named is 98.372 %.

### 5. MAIN_FINAL4 DB state (`MAIN_FINAL4_log.txt`)

| Pass | funcs | heads | code B (scope) | odd | xrefs from code | layout hash | typed hash |
| --- | ---: | ---: | ---: | ---: | ---: | --- | --- |
| seed (J1_MAIN_FINAL3) | 5,442 | 124,087 | 390,508 | 0 | 177,877 | `94a94099…` | `1ed37183…` |
| `build` | 5,451 | 124,130 | 390,660 | 0 | 177,965 | `fe4f9af1…` | `1e8ddcd1…` |
| `verify` (`--reopen`) | **5,451** | **124,130** | **390,660** | **0** | **177,965** | **`fe4f9af1…`** | **`1e8ddcd1…`** |

The reopen delta is all zero. Window head hash `6ff215a0…` is unchanged. All 79 new heads are correct, and 0 proven
bytes are not DB code.

Functions: +11 roots (`0x0179DA`, `0x029174`, `0x02B36A`, `0x02B64A`, `0x02B678`, `0x02B8BC`, `0x02C25E`, `0x04E2D6`,
`0x064BE6`, `0x064BEE`, `0x0696BC`), with two J1 junk starts removed:
- `0x04E2DA`, a mis-start inside the new handler;
- `0x02C308`, a 2-B "function" on the low half of the pointer cell `0x02C306 = 0002C25E`, now typed as an offset.

The I12 blocks remain DB code, 42/78 B by codemask. The job's "19/42, 28/78" line counts heads, as J1's did.

### 6. Corrections to earlier docs (owning docs not edited)

- **Doc 70 (J2) / RESUME J-wave.** `0x04E2D6` was missed because H2 excluded slot `0x04ACF4` (and four sibling cells)
  as "mid_code in seed". The walk of `0x04ABE4` was not truncated. The handler is also slot 134/154/245 of `0x04ABE4`
  and slot 274/358 of `0x04AB70`, besides the slots J2 listed.
- **Doc 72 (J4).** The table cells are `0x02B3D6`/`0x02B3DA`/`0x02B3DE` (table `0x02B3C2`, slots 5–7, touch index
  6–8). The reader is helper `0x028616`, reached by `jmp` from proven `0x02B3A8`. The +16 B is now Confirmed under rule
  K1b. J4's "no code root beyond the 5" was scoped to unproven DB-code runs; K1b finds 170 B more, most of which were
  data or unknown in FINAL3's DB.
- **Doc 71 (J3).** There are 99 touch-zone tables (5,296 B), not nine, and all were already named. Three carry a count
  that is one too large (a phantom, unmatchable record).
- **Doc 60 (I8).** Nine `reg_table_unresolved` `jsr @er6` sites (`0x028558`…`0x0286C0`) are resolved. They are the
  touch-index helper family, with 79 tables and 642 slots.

## USB relevance

None. Every new byte is touch-UI or sensor-display code:
- the K1a handler reads `0xFFBBE9` and prints a label;
- the K1b stubs set `0xFFB3EB`/`0xFFB3F1`/`0xFFBC04`/`0xFFBAD8` and call UI helpers (`0x2B21C`, `0x6517A`, `0x65Bxx`).

None of the new code touches USB `0xFFEE00`–`0xFFEE53`, SCI-C `0xFFFF88` or the closed window. The touch hit-test
family is the shared GUI input layer, and no zone table or helper table holds a hidden or service screen entry that
reaches USB. Scope for that statement: the 642 helper slots and 233 distinct targets, all of which are proven
application code. The answers on USB, SDR and DSP are unchanged.

## Open

1. **Selector-domain proof for K1b.** Tie each helper site to the zone table active on its screen, to show that
   `0xFFBBC2` can produce every credited index. This would upgrade the shared table-rule assumption to Confirmed for
   these 186 B, and the same method would apply to I15's record fields.
2. **Other register-table forms.** I8's remaining `reg_table`/`reg_table_unresolved` sites outside the helper family,
   and the `0xFFBC35` L1 index, are the next proven-code ceiling on MAIN. Bound each with its range check before
   crediting.
3. **Touch-zone producers.** Trace the `er2 = X<<16|Y` event source (J-wave Open 2) now that all 99 tables and their
   99 call sites are typed. The off-panel and phantom records found here are the only anomalies.
4. **Cosmetic.** Name the 11 new roots and the 11 helpers (`touch_dispatch_N`).

### Files (`ida\out\main-final4\`)

| File | Content |
| --- | --- |
| `final4_proven_mask.bin`, `final4_named_mask.bin` | the new masks (368,624 / 497,451 set) |
| `ledger.tsv` | rule-by-rule ledger |
| `ledger-delta.tsv` | popcounts against final3, per-run proven and named deltas, overlaps |
| `new-proven-runs.tsv`, `new-heads.tsv` | the 12 new runs and 79 instruction heads, with rule and origin |
| `k1a-slots.tsv` | the 10 re-admitted (table, slot) pairs |
| `helper-tables.tsv` | 71 sites / 79 tables / 642 slots of the touch-index helper family |
| `touch-zone-tables.tsv` | 99 zone tables (count, extent, overrun, sites, named/proven) |
| `typing-plan.tsv`, `crefs-plan.tsv` | job inputs |
| `final4_proven_runs.tsv` | contiguous runs of the proven mask |
| `MAIN_FINAL4_codemask.bin`, `MAIN_FINAL4_functions_raw.tsv`, `MAIN_FINAL4_log.txt`, `build_log.txt`, `window_seed.tsv` | DB dumps and pass logs |
| `offline\k1_build_masks.py` | the one-descent builder and verifier |

DB: `ida\db\jobs\K1_MAIN_FINAL4\K1_MAIN_FINAL4.i64` (use as the next MAIN seed). Logs: `ida\log\jobs\K1_MAIN_FINAL4\`.

## Addendum — K8 candidate over-credit `0x054AE2`–`0x054BF7` (orchestrator follow-up)

**Verdict: the entry is invalid.** The folded one-descent reaches `0x054AE2` only as the seed `fnindex 054AE2`. That is
one of H9's `full`-mode fnindex start seeds (`FNSEED`, validated span `0x054AE2`–`0x054BF8`), and it has **no
predecessor edge** (`pred` empty). It is a seed, not a code edge. Measured, Confirmed:

- **Whole-image scope.** Scanned `0x000000`–`0x07B753`, decode only, including the closed window. There are:
  - 0 BE32 pointers to `0x054AC0`/`0x054AE2`/`0x054AE4`/`0x054AF0`;
  - 0 `jmp/jsr` abs24 into the range;
  - 0 `mov.l #imm` pointing into it;
  - 0 TAB, H3-array, vector, I6–I15, K1a or K1b slot targets inside it.

  The only oracle flow edge from outside `0x054AC0`–`0x054C11` is `0x002214 5e 05 4b f8` (`jsr @0x54BF8`), which
  targets only the separate 26-B routine `0x054BF8`–`0x054C11`. That routine is valid and stays.
- **Physical entry.** The only way into `0x054AE2` is fall-through from `0x054ADE 6a 0a a5 1a`
  (`mov.b @0xA51A,r2l`, which sets N) into `0x054AE2 4b 0c` (`bmi`). A function cannot begin with a `bmi` on flags
  set by its predecessor, so the fnindex start is a mis-split of one routine. That routine is `0x054AC0`
  (`5e 05 45 68`, `jsr @0x54568`) … `rts` at `0x054BF6`. Its head `0x054AC0`–`0x054AE1` is already unproven (H9
  `demoted.tsv` line 793) and has 0 inbound references.
- **Measured loss.** Re-running the builder with only that seed removed (scratch copy; the published masks are
  untouched) reaches 26 of the 304 B in `0x054AE2`–`0x054C11`, i.e. only `0x054BF8`. It loses exactly **278 B** of the
  proven mask and nothing else: unreached proven bytes go from 1,692 to 1,970.

This is the same class as I12's −120 B, which was also proven only through H9's carried fnindex addend. The bytes
were in final3 too.

**Alternative numbers** (`ida\out\main-final4\candidate-054AE2.tsv`; published masks not rewritten):

| | Published | Alternative |
| --- | ---: | ---: |
| MAIN proven, final4 | 368,624 | **368,346** (72.841 %) |
| MAIN proven, final3 | 368,366 | 368,088 |
| MAIN proven, K1b J4-only variant | 368,454 | 368,176 |

Named depends on the convention:
- Under the I12 convention (demoted code stays typed), named is unchanged at **497,451** and the headline stays
  **93.373 %**.
- If the range is also removed from named, named is 497,173 and the headline is 961,436 = 93.346 %.

**Open, same class.** The proven bytes that the folded descent reaches *only* through fnindex seeds total **4,850 B in
94 runs** (`ida\out\main-final4\fnindex-only-runs.tsv`). This is the reach with all fnindex seeds removed, minus the
bytes that are proven but reached by nothing at all. The largest runs are `0x03C668` 820 B, `0x046210` 472,
`0x054AE2` 278, `0x077CC2` 206 and `0x01C4D2` 194. `0x03C668` is the EEPROM page-writer that J14 found to have 0
references. Each run needs the same edge check before any demotion. I have not demoted them.
