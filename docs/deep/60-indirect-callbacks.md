# 60 — Struct-member callbacks behind the 267 jmp/jsr @ERn sites (Lane I8)

Owner-side static analysis of firmware already on disk. No device, USB, serial or flash access;
nothing was written to or connected with a radio, and no image byte was modified. MAIN is H8SX
(IDA proc `h8sxa`), big-endian, base 0, so file offset = mapped address. Content ends below
`0x07B754`. The closed CDC/DSP-download window `0x078106`–`0x07B753` was not analysed; its one
indirect site is listed and not resolved (project boundary). Model: **claude-opus-5-5**.

Private DB `I8_MAIN` (`ida\db\jobs\I8_MAIN\I8_MAIN.i64`), seeded with
`--copy-from ida\db\jobs\MAIN_H8SX\MAIN_H8SX.i64`. No other DB was opened; `run_ida.py` was not run.
Job: `ida\jobs\i8_apply_cb_xrefs.py`. Offline classification/resolution scripts are in the lane
scratchpad (`i8_classify.py`, `i8_classify2.py`, `i8_resolve.py`, `i8_delta.py`, `i8_emit.py`); their
inputs are all project files (`ida\out\main-descent\work\reached_insns.tsv`, the image, the known
table lists). The whole chain was re-run from those inputs into a lane-private folder and reproduced
every number below byte-for-byte, so no shared-scratch overwrite affected the result.

Tables in `ida\out\indirect-cb\`:
- `sites.tsv` — all 267 sites: site, kind, reg, form, source, confidence, targets, evidence, mechanism.
- `targets.tsv` — 1,402 distinct byte-verified code targets, each with `in_H9_proven_descent` and sites.
- `usb-relevant.tsv` — 28 rows where a site or target touches the USB/image-push regions (task 5).
- `ledger-delta.tsv` — the +182 B proven delta with the no-double-count argument.
- `apply_log.txt` — the IDA job's applied-xref and reachability report.

## Verdict

The 267 `jmp/jsr @ERn` sites in MAIN reached code are **not** a reservoir of unreached handlers.
They are overwhelmingly (210 / 267) ordinary **computed jumps through ROM dispatch tables or RAM
callback cells that H9's descent already used as roots**: 166 `mov.l @(table:32,erIdx),erN` indexed
loads into the 149 F1/G2 tables, switch tables and H3's pointer arrays; 36 `mov.l @cell:16,erN`
loads from the four RAM callback cells (`0xFF811A`, `0xFF811E`, `0xFFB288`, `0xFFB3C6`); plus a
screen offset-table and a bytecode dispatcher. The remaining 57 are 24 direct function pointers
(`mov.l #imm`), 30 register-base table/record dispatches (`add.l idx,base; mov.l @base,erN`), 7
struct-member function pointers (`mov.l @(off,ptr),erN`), 1 callee-returned pointer, and the 1
closed-window site. **1,397 of the 1,402 distinct targets were already proven by H9.** Adding every
site→target edge to H9's own proven descent reaches **+182 B of code that was named but not proven,
0 of the 194 F1-residual functions, and leaves MAIN named/typed unchanged (both delta regions were
already typed "recovered code").** So **MAIN proven rises 365,570 → 365,752 (+182 B); named/typed
stays 497,139.** The single most useful by-product is a **correction to H2**: table slot `0x03467C`
(`= 0x34CCE`, entry 2 of jump table `0x034674`) was excluded as "mid_code", but it is the live target
of the `jsr @er6` at `0x03464A` and decodes as clean handler code (+116 B of the 182).

## Method

1. **Site list.** H9's `breakdown.txt` records "unresolved jmp/jsr @ERn sites in reached code 267".
   Grepping `ida\out\main-descent\work\reached_insns.tsv` (H9's IDA-decoded reached stream, 0 length
   mismatches) for `j(mp|sr) @er[0-7]` yields exactly 267 — the same set. 233 use `@er6`, 16 `@er4`,
   16 `@er5`, 1 each `@er1`/`@er2`; 147 `jmp`, 120 `jsr`. Confirmed.
2. **Classification.** For each site a backward def-use scan over the reached stream finds the nearest
   instruction writing the jump register, skipping control-flow and non-defining ops (`cmp`, `btst`,
   stores) and honouring caller-save: a value in `er0`–`er3` crossing a `jsr/bsr` is "clobbered"
   (callee-returned); `er4`–`er6` survive. Register copies and `add` base+index pairs are followed.
3. **Target resolution.** Table bases are matched against `main-full\jumptables.tsv`,
   `switch_tables.tsv` and `ptr-arrays\arrays.tsv`/`xrefs.tsv`; register-base tables are traced to
   their immediate/indexed base and read from the image; immediates and struct members are read
   directly. Every target is byte-verified from `decrypted\FT3D_MAIN_ver102_EXP.bin` in Python.
4. **Proven delta (task 4).** H9's own `offline\descent.py` was imported and run unchanged as the
   baseline (`run("full")`), then re-run with the resolved targets as `extra_seeds`. The delta is the
   set-difference of reached instructions; per-edge contributions were measured one edge at a time.
5. **Xref apply (task 3).** `i8_apply_cb_xrefs.py` adds a near call/jump cref from each site to each
   target in `I8_MAIN`, calls `auto_wait()`, and reports residual/head recovery. It modifies only the
   DB cross-reference graph; it patches no bytes. try/except → traceback file, ends `idc.qexit(0)`.

Not done / out of scope: the closed-window site `0x078308` (`jsr @er2`, `@(6,er6)`); the exact RAM-cell
writer set (already enumerated by H9 — 19 edges across the four cells); 23 register-base dispatches
whose table base is supplied by the caller or by a RAM state variable are labelled but their base is
not chased to source (their targets are already-proven handlers — see Findings 4).

## Findings

### 1. Form census of the 267 sites (`sites.tsv`)

| Form | n | Confidence | Resolved target set |
| --- | ---: | --- | --- |
| `rom_table_indexed` (incl. 1 screen offset-table) | 167 | Confirmed | the 149/switch/H3 table contents — H9 roots |
| `ram_cell` (`0xFF811A`×2, `0xFF811E`×2, `0xFFB288`×31, `0xFFB3C6`×1) | 36 | Confirmed (H9) | RAM callback cells; writers per H9 descent |
| `immediate` (`mov.l #imm; jsr/jmp @erN`) | 24 | Confirmed | `0x77FC6`, `0x78086`, `0x77DB8` (3 helpers) |
| `reg_table` (traced) + `reg_table_unresolved` | 7 + 23 | Confirmed / Inferred | register-base ROM tables |
| `struct_member` (`mov.l @(off,ptr),erN`) | 7 | Inferred | array `0x28C8A` members |
| `bytecode_dispatch` | 1 | Confirmed (data) | table `0x0387FA` → DATA (not code) |
| `call_return_value` | 1 | Inferred | `0x015224`, returns from `sub_14E04` |
| `closed_window` | 1 | — | `0x078308`, not resolved |

### 2. The only proven-code gain: H2's wrongly excluded slot `0x03467C` (+116 B, Confirmed)

Site `0x03464A` `jsr @er6`, fed by `0x034642: mov.l @(0x34674:32,er3),er6` with `er3 = index<<2`.
Table `0x034674` is a known 21-entry jump table (F1/G2). Its slot `0x03467C` holds `0x00034CCE`
(byte-verified: `be32(0x03467C) = 0x00034CCE`). H2 (`table-xrefs-excluded.tsv` row 288) excluded this
one slot with reason *"target is mid_code in seed (inside an existing item)"* — a DB item-boundary
artefact in the H8SX seed. The binutils H8SX oracle decodes `0x34CCE` as clean code:
`034CCE btst #0x3,@0x4d:8 ; 034CD2 bne ; 034CD4 mov.b @0xaad3:16,r4l ; … ; 034CF0 jsr @0x34c34 ;
034CF4 jsr @0x3ef6e`. H9 inherited the exclusion, so this handler (0x34CCE..0x34D40, 116 B) was reached
by nothing. With the site→target edge it is reached cleanly. **Correction: slot `0x03467C` = `0x34CCE`
is a genuine code pointer, not data.**

### 3. H3 tier-X array `0x003272` (+66 B, Inferred)

Site `0x003270` `jmp @er6`, fed by `mov.l @(0x3272:32,erX),er6`. Array `0x003272` is H3 tier X ("2/3
targets weak", `arrays.tsv`), so H9 (which credits only tiers A/B/C) left its three slots unreached.
Targets `0x327E` (+12 B), `0x328A` (+18 B), `0x329C` (+36 B) decode and flow cleanly as three small
consecutive handlers. Credited Inferred because the array itself is weak.

### 4. Everything else was already proven; the edges only make the call graph explicit

1,397 of 1,402 targets are in H9's proven descent. The IDA job shows **29 of the 194 F1-residual
functions now carry an explicit incoming callback xref** (`apply_log.txt`) — but each was already
*reached* by H9 through the table root; the residual label is an F1 start/over-split artefact, not
unreached code. So the explicit edges improve the DB call graph (and name 482 table-handler entry
points that were not function heads) without adding proven bytes. The 3 `immediate` helpers
`0x77FC6/0x78086/0x77DB8` (H8SX-module region just below the closed window) are already reached by
flow (+0 B each). The register-base dispatches (e.g. `0x0191A8` → screen offset-table `0x19A9E` +
base `0x148A0`; `0x029ADA` → table `0x125D4` → `{0x252CE, sentinel 0x3FFA0}`; the `0x02855x` chain
indexed by RAM `0xBBC2`; the `0x0529xx`–`0x0534EA` family) all land on already-proven handlers.

### 5. The struct at `0x28C8A` and the bytecode dispatcher

Sites `0x028D12`–`0x028DA8` read function pointers from `@(0x0..0x1C, er1)` with `er1 = #0x28C8A`:
an 8-entry pointer array at `0x28C8A` = `{+00 0x18040, +04 0, +08 0x17EFE, +0C 0x2A9EA, +10 0,
+14 0x2A9F4, +18 0x3FFA0 (frame-builder sentinel), +1C 0x28CAA→inline jsr}`. All non-null targets
already proven. Site `0x0384B4` (`jmp @er5`) belongs to a **bytecode interpreter**: table `0x0387FA`
holds pointers into a command-script DATA region at `0x3891A`+ (`ff 01 0c 0b 25 06 …`), parsed by
`mov.b @er5+`; `0x3891A` is data, not a code target, and the `jmp @er5` code path has no in-range code
entry. Recorded as data so it is not miscounted as a handler.

### 6. Ledger delta (`ledger-delta.tsv`)

| Term | Δ bytes | Value |
| --- | ---: | ---: |
| MAIN proven code, H9 | | 365,570 |
| `0x34CCE` handler via `jsr @er6` at `0x03464A` (Confirmed) | +116 | |
| `0x003272` tier-X targets `0x327E/0x328A/0x329C` via `jmp @er6` at `0x003270` (Inferred) | +66 | |
| **MAIN proven code, I8** | **+182** | **365,752** |
| MAIN named/typed, H9 | | 497,139 |
| **MAIN named/typed, I8** | **0** | **497,139** |

**No double count.** The 182 B are *newly reached* instructions relative to H9's full descent, whose
reached set ⊇ its proven set, so they are disjoint from H9's proven mask by construction. They are
also disjoint from H3's credited A/B/C arrays (`0x003272` is tier X, excluded) and from G2's credited
slots (`0x03467C` was in H2's exclusion set, so never in a credited table slot). Both regions are
already typed "recovered code" in the W2-8 map (`common.runtype`), so they add **no** new named bytes —
the named mask is unchanged and nothing is counted twice.

## USB relevance

Three sites touch the mission regions (`usb-relevant.tsv`), and all three are already-proven table
dispatchers — no new USB-reachable code, but the edges are now explicit for Lane I1:

- **Image-push driver (`0x0559xx`–`0x055Fxx`), Open #1 / Lane I1.** Site `0x055BA0` `jsr @er6` → table
  **`0x055BF2`**, 11 handlers (`0x055C1E, 055C7E, 055CEA, 055D6C, 055D8A, 055D8C, 055DE8, 055DFA,
  055F84, 055F96, 055FF0`). Site `0x055BC8` `jsr @er6` → table **`0x055C06`**, 6 handlers
  (`0x055D8C, 055DE8, 055DFA, 055F84, 055F96, 055FF0`). These are the image-push feeder's internal
  sub-dispatch; I1 tracing the feeder should start from tables `0x055BF2`/`0x055C06`.
- **USB control-transfer state machine.** Site `0x055000` `jmp @er6` → table **`0x055002`**, 10
  states (`0x055034, 055042, 055196, 0551AA, 0551C2, 0551DA, 055306, 055520, 055552, 0556C8`), the
  vector-235 control-transfer handler H9 cited as fully reached. Now edge-linked.
- No site or target lands in the USB register window `0xFFEE00`–`0xFFEE53` or SCI-C `0xFFFF88`
  (those are MMIO, not code). The three `immediate` helpers sit in the H8SX USB-module code region
  (`0x77DB8/0x77FC6/0x78086`, just below the closed window) but were already reached.

## Open

1. **Lane I1:** image-push sub-dispatch tables `0x055BF2` (11 handlers) and `0x055C06` (6 handlers),
   site `0x055BA0`/`0x055BC8`. Decode each handler to find which consume the `0xFF5806`–`0xFF5B06`
   buffers vs. the USB-CDC endpoint.
2. Chase the 23 register-base dispatch bases to their source (RAM state vars `0xBBC2`, `0xB08D`, …)
   to name the state machines; targets are already proven so this is naming, not coverage.
3. The orchestrator may fold the +182 B into the MAIN proven headline (365,752) and record the H2
   slot-`0x03467C` correction; keep the +66 B as Inferred until the H3 tier-X array is re-weighed.
4. Closed-window site `0x078308` and the DSP/CDC window remain CLOSED by project boundary.
