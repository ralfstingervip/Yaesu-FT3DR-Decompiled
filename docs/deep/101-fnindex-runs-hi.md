# 101 — fnindex-only runs at 0x050000 and above (Lane L4)

> Lane L4, model `claude-opus-5-5`. Owner-side, strictly read-only static analysis of
> `decrypted\FT3D_MAIN_ver102_EXP.bin` (MAIN, H8SX `h8sxa`, base 0, big-endian, so file offset = mapped address;
> sha256 prefix `8e3ecd05…`, re-checked unchanged; SUB `b93570b3…` untouched). No image byte, mask or seed was
> modified; nothing was connected to or written to any radio. Only my DB `L4_FNIDX_HI` was used (seed
> `ida\db\jobs\K1_MAIN_FINAL4\K1_MAIN_FINAL4.i64`, read-only `--copy-from`); in the end the whole-image evidence was
> decisive from the published masks + the binutils oracle, so no DB edit was needed. Tables: `ida\out\fnindex-hi\`.

## Verdict

Of the **27** fnindex-only runs with start ≥ `0x050000` (1,380 B, including the already-demoted `0x054AE2`), only **3
runs / 90 B are genuinely REACHED** by a real inbound edge the folded descent does not model (`0x05E8E0`, `0x066FB4`,
`0x067250` — all register/indirect call targets in live application code, none USB). **2 runs / 290 B are the USB
function-driver's transfer handlers** (`0x07778C`, `0x077CC2`), reachable only through the gated USB personality — keep,
do not demote, USB-relevant. **4 runs / 26 B are mis-typed data** (`0x05C600`, `0x065A88`, `0x073908`, `0x074310`).
**17 runs / 696 B are dead or split-tails with no live inbound edge** and are proposed for demotion (plus the data
runs, 722 B removable from the proven mask in all). The already-demoted `0x054AE2` (278 B) is listed, not re-proposed.
No new USB attack surface, no SDR path, no DSP path is created by any of these runs; the three REACHED runs are SCI-A
WIRES-X command handlers and a UI callback.

## Method

Whole-image evidence, offline, gated by the published masks. No descent re-run.

1. **Oracle + real heads.** The binutils per-byte decode `ida\out\h8s-decode\work\bu_all.tsv` (one row per offset) is a
   linear decode, so most of its "instructions" are mid-instruction garbage. I reconstructed the **114,980 real
   instruction heads** by walking the 923 proven runs of `final4_proven_mask.bin` with oracle lengths — all 923 tile
   exactly (0 mis-tiles), so a proven run's bytes decode uniquely and its start is a true head.
2. **Inbound-edge scan per run** (`scratchpad` scripts; results in `ida\out\fnindex-hi\`):
   - **Control flow** from real heads only: relative `b**`/`bsr` (parenthesised target) **and** absolute
     `jsr/jmp @0xADDR:8/16/24/32` (an early version missed the absolute form — the main call mechanism — and was fixed).
     Each edge into a run's start or interior is classed GEN (proven and not in any of the 94 fnindex-only runs),
     WIN (inside the service window `0x078106`–`0x07B753`), FN (inside another fnindex-only run), or UNPROV.
   - **BE32 pointers**: every 4-byte big-endian word anywhere in `0x0`–`0x7B753` equal to a run start/interior, tagged
     as a `mov.l #imm` code immediate (preceding `7A 0x` at a real head) or a data-table cell.
   - **`jmp/jsr @@aa:8` memory-indirect**: all 2,212 sites resolved against the pointer they read; none targets a run.
   - **Fall-through**: the real head whose `addr+len` equals the run start, and whether it is a flow-stop.
   - **Indirect `@er5`/`@er1`/`@er6` consumers** traced by reading the dispatcher bodies.
3. **Decode** of every cited site from the image bytes via the oracle flow-walk.

**Not done / scope.** I did not re-run H9's descent or recompute the fnindex set; I measured against K1's fixed-point
masks. For the two USB runs I did not fully trace the USB-ISR entry into their dispatch function (out of lane; flagged).
Runtime register values (e.g. that `@0xad9d` lets `0x15206` reach its `jsr @er1`) are the standard Inferred assumption.

## Findings

Full table: `ida\out\fnindex-hi\runs.tsv`. Demotion proposals: `ida\out\fnindex-hi\proposed-demotions.tsv`.

### REACHED — 3 runs, 90 B (descent missed an indirect/register edge)

- **`0x05E8E0`–`0x05E8F2` (18 B).** er1 function-pointer callback. `0x05E862 7a 01 00 05 e8 e0` (`mov.l #0x5E8E0,er1`)
  then `0x05E868 5e 01 52 06` (`jsr @0x15206`). `0x015206` preserves er1 and executes `0x015224 5d 10` (`jsr @er1`)
  when `@0xAD9D` ≠ 0; it has **13 genuine callers**. The descent does not follow `jsr @er1`, so it credited only the
  fnindex seed. Confirmed edge; live-path Inferred. Not USB (UI helper).
- **`0x066FB4`–`0x066FC8` (20 B)** and **`0x067250`–`0x067284` (52 B).** SCI-A **WIRES-X node-command** leaf handlers.
  `0x067250` is called by `0x067242 55 0c` (`bsr`) — the `'V'` case of the command parser at `0x0671xx`
  (`0x0671FE ac 56` = `cmp.b #0x56,r4l`, dispatch on `@0xB47B` and command letters `V/F/E/P/T`), and by abs24 `jsr`
  from `0x06280E`, `0x06AB24`, `0x06ADFE`. `0x066FB4` is called by abs24 `jsr` from `0x062808`, `0x06723A`,
  `0x06AB1C`, `0x06ADF6`. These callers are switch-case bodies of the node-command parser (the K9/doc-91 WIRES-X PC
  link), reached through an indexed node-command dispatch (`off_74472`) that the folded descent does not resolve;
  removing fnindex seeds breaks the chain at the dispatch, so the leaves appeared seed-only. Confirmed edges; dispatch
  liveness Inferred from the K9 identification. Both write the reply buffer `@0xB05A`/`@0xB050`. Not USB (SCI-A).

### WINDOW-ONLY / USB — 2 runs, 290 B (keep; do not demote)

- **`0x077CC2`–`0x077D90` (206 B)** and **`0x07778C`–`0x0777E0` (84 B).** USB function-driver transfer handlers inside
  the J4 "USB module, window-sourced" region (`0x076C0A`–`0x077FC7`). `0x077CC2` reads the window-copied USB descriptor
  RAM at `@0xFF600E`/`@0xFF600F` and calls `0x077FC6` and the sub-window routine `0x078086`. Their only in-scope
  callers are the three stubs `0x033790`/`0x0337AC`/`0x0337C8` (`jsr @0x77cc2`/`@0x7778c`/`@0x77d16`), which sit inside
  an **unproven** USB endpoint-dispatch function at `0x033780` (toggles `@0xBC8D` = `0x3D/0x3F/0x3C`, mirrors the proven
  sibling `0x033740` that calls `0x77cac`/`0x77cb8`). That cluster (`0x033680`–`0x0337DE`) has no direct callers — it is
  entered via the USB-ISR handler-table `jsr @er2` dispatch (doc 95, table at `FF6242`/`0x07B4B4`) on an er0 control
  block, which runs only under the gated USB personality (0x7D strap / `FF813A` / DSP-WRITE ≥ 5, doc 95). **Crediting:**
  these 290 B are live USB code only when the gate opens; the folded descent (which excludes the window and the er0
  dispatch) legitimately saw only the fnindex seed. Keep proven; **USB-relevant** (see below).

### DATA-MISTYPED — 4 runs, 26 B (retype; removes from proven)

- **`0x05C600` (2 B)** `ff ff` — a 0xFFFF constant/terminator loaded as a data pointer in er5
  (`0x05C57C`/`0x05C5F4 mov.l #0x5C600,er5`) and handed to iterators `0x5c9d6`/`0x5c780`.
- **`0x065A88` (4 B)** ASCII `"312\0"` (`33 31 32 00`), referenced by an indexed table-load near `0x065982`.
- **`0x073908` (2 B)** 2-byte datum in the `0x0739xx`–`0x074xxx` table cluster; loaded as an er1 pointer at `0x073ABA`
  alongside the **odd-address** sibling `0x73909` (`mov.l #0x73909,er1`), which cannot be a code entry → data.
- **`0x074310` (18 B)** a data block (`00 00 41 48 30 36 30 4D …`) copied by `eepmov.w` to RAM `@0xFF8956`
  (`0x0742F2 mov.l #0x74310,er5; 0x0742F8 mov.l #0xff8956,er6; 0x0742FE eepmov.w`).

### DEAD / SPLIT-TAIL — 17 runs, 696 B (propose demotion)

Same class as the already-demoted `0x054AE2`: proven only through an H9 fnindex function-start seed, with **no live
inbound edge** (0 proven abs24/relative CF, 0 BE32 table pointer, 0 `@@`, no fall-through from proven code).

- **Dead-caller clusters (bsr/jsr from UNPROVEN code only):** `0x050D5E` (32), `0x0526A2` (26), `0x0591F8` (60),
  `0x05E2E6` (32). `0x051108` (60) is called only by `0x054BBA` inside the **already-demoted** `0x054AE2` run.
- **Unreferenced functions (pred = `rts`, 0 inbound):** `0x056CBE` (12), `0x066924` (66), `0x067522` (2, lone `rts`
  after a time-format routine), `0x068CB2` (20).
- **Vestigial er5-handlers (4 runs, 48 B):** `0x0620A6` (18), `0x062178` (14), `0x062722` (14), `0x067128` (2). Each is
  loaded into er5 right before `jsr @0x61d8c` (or `@0x61e4a`), but **both dispatchers ignore er5** (read `@0x9599`,
  return a flag, `rts` — no er5 read/store/call), and at `0x062962` er5 is overwritten (`mov.l #0xffb32e,er5`) before any
  use. `0x062178` has 4 such load sites. No table pointer, no abs24 `jsr`, no fall-through → never executed.
- **Split-tails (head unproven/unreferenced):** `0x052A14` (32, tail of the handler-loop `mov.l @er2+,er5; jsr @er5 ×3`
  function `0x052A00`), `0x05343C` (90) and `0x0534C0` (90, near-identical menu/`eepmov`+`jsr @er5` tails),
  `0x0645A4` (126, pred `0x0645A0 mov.b @0xb26f` is unproven fall-in; its two interior "BE32 pointers" at `0x01D33E`/
  `0x01D360` are mid-instruction false positives). Each head is unproven with 0 callers; H9's fnindex split credited
  only the tail.

### Already demoted — `0x054AE2`–`0x054BF8` (278 B)

Listed per the brief; not re-proposed. K-wave (K8 found, K1 follow-up resolved): split tail of routine `0x054AC0`, whose
head `0x054AC0`–`0x054AE1` is unproven and unreferenced; the only nearby call `0x002214 jsr @0x54BF8` targets the
separate 26-B routine that stays proven.

### Ledger impact (proposals only — masks/seeds NOT edited)

| Class | runs | bytes |
| --- | ---: | ---: |
| REACHED (keep) | 3 | 90 |
| WINDOW-ONLY / USB (keep) | 2 | 290 |
| DATA-MISTYPED (retype → data) | 4 | 26 |
| DEAD (demote) | 13 | 358 |
| SPLIT-TAIL (demote) | 4 | 338 |
| already-demoted `0x054AE2` | 1 | 278 |
| **proven removable this lane (demote+retype, excl. 054AE2)** | **21** | **722** |

If all 722 B are removed from `final4_proven_mask.bin` (368,624), MAIN proven becomes **367,902** before applying the
separate `0x054AE2` −278 that the next seed must also apply.

## USB relevance

- **No new USB surface.** The two USB runs (`0x07778C`, `0x077CC2`, 290 B) are **existing** USB function-driver code,
  not a new engine or endpoint. They confirm and extend doc 64/J4: the USB module region `0x076C0A`–`0x077FC7` contains
  transfer handlers reached through the USB-ISR `jsr @er2` dispatch on an er0 control block, entered only under the
  gated personality (doc 95). `0x077CC2` consuming the window-copied descriptor RAM at `@0xFF600E` ties this code to the
  CDC-ACM descriptor set in the service window. A dedicated USB-window pass should trace `0x033680`–`0x0337DE` and
  `0x0768A8`/`0x0768C8`/`0x0769AA` into these handlers.
- **No SDR, no DSP path.** None of the 27 runs touches a sample/IQ buffer, a wide DMA path, or SCI-C `0xFFFF88`. The
  REACHED runs are SCI-A WIRES-X command handlers and a UI callback. The DSP and SDR answers are unchanged.

## Open (most valuable first)

1. **Next MAIN seed (MAIN_FINAL5).** Apply `0x054AE2` −278 and demote the 17 DEAD/split-tail runs (696 B) + retype the
   4 data runs (26 B) listed in `proposed-demotions.tsv`; re-run the fixed-point builder. Before demoting, re-confirm the
   split-tail heads (`0x052A00`, `~0x053420`, `0x0645A0`) stay unproven and un-called.
2. **USB-window pass** should decide `0x07778C`/`0x077CC2` definitively by tracing the USB-ISR handler-table into
   `0x033680`–`0x0337DE`; if the window never reaches `0x033780`, they are dead-in-scope rather than gated-live.
3. **Confirm the er5-handler mechanism is truly vestigial** across *all* callers of `0x61d8c`/`0x61e4a` (none should
   consume er5); that would upgrade the four er5-handler demotions from Confirmed-edge to Confirmed-dead.
4. The remaining 67 fnindex-only runs with start < `0x050000` (3,470 B; `0x03C668` 820 B first) need the same edge check.
