# 66 — Extending H9's strict descent to the two missed edge classes (Lane I15)

> Lane I15, model `claude-opus-5-5`. All work is offline Python over H9's descent, run read-only.
> Scripts: `ida\out\descent-ext\offline\i15_descent_ext.py` (consolidated, reproducible from on-disk
> inputs). Tables: `ida\out\descent-ext\`. Image: `decrypted\FT3D_MAIN_ver102_EXP.bin` (MAIN, H8SX,
> base 0, big-endian, file offset = address). Private DB not needed — no IDA pass was required. No image
> byte was modified and nothing was connected to or written to a radio. The closed window
> `0x078106`–`0x07B753` was not analysed; edges into it stop at the edge. I imported H9's own `descent.py`
> and `analyze.py` unchanged (never as `__main__`, so they write nothing) and reproduced H9's proven
> (365,570) and named (497,139) masks and both reach masks (full 363,758 / strict 356,820) byte-for-byte
> before adding anything. I copied lane I9's scratch pickles into my own folder before reading them.

## Verdict

**H9's two rule gaps are real, and generalising them is almost entirely a re-derivation of what I9 already
found — with one genuine new increment of 54 proven bytes.** Rule A (code-pointer stores into a RAM
function-pointer cell that reach the cell through an argument register or a helper call, one or two levels
deep) finds exactly three installers — `0xFF811A`←`0x000706`, `0xFF811A`←`0x0004AA`, `0xFF811E`←`0x000E5E`
— all already credited or reached by I9; **Rule A adds 0 bytes beyond H9∪I6∪I8∪I9.** Rule B (records whose
fields are code pointers, dispatched through `mov.l @(d,er1),er6; jsr @er6`) finds the full family of
**eight** record callers of dispatcher `0x028CBC`, of which I9 credited two. The other six are reached, and
two of them (records `0x028C2A` and `0x028C8A`) carry handler pointers that nothing else reaches: fields
`+0x14` → `0x02A924`/`0x02A9F4` (the two I9 flagged as uncredited) **and** fields `+0x1C` →
`0x028C4A`/`0x028CAA` (not previously named). These four runs are Confirmed, clean (0 overlapping
instruction starts, 0 new bad decodes, all four decode to an `rts`), strict-reached at every gate, and
mutually disjoint from H9, I6, I8 and I9. **MAIN proven rises +54 B (34 of them also +named).** No new byte
touches USB `0xFFEE00`–`53`, SCI-C `0xFFFF88`, or the closed window.

Deltas:
- beyond **H9**: +1,182 B proven (1,128 coincide with I9's own additions; 0 with I6/I8; 54 are new).
- beyond **H9∪I6∪I8∪I9**: **+54 B proven, +34 B named/typed.**
- Union: proven 365,570 → **368,486**; named 497,139 → **497,312** (using I6 +10, I9 +129, I15 +34).

## Method

1. **Baseline, byte-equal to H9.** `i15_descent_ext.py` imports `descent.py`/`analyze.py`, rebuilds the
   proven/named masks exactly as I9 did (`assert sum==365570 / 497139`, and `PROV == ida\out\main-final\
   h9_proven_mask.bin`), and runs `run("full")`/`run("strict")` (`assert reach == 363758 / 356820`).
2. **Rule A, generalised.** Collect every RAM function-pointer cell X: a reached `mov.l @X,erN` followed
   within four instructions by `jmp/jsr @erN` (no intervening write). For every reached store `mov.l erN,@X`
   whose erN is **not** set by a local immediate (H9's own case), treat erN as live-in and walk the reached
   call graph back one or two levels; if a caller sets erN with `mov.l #imm,erN` before the call, credit
   `imm`. Four cells exist (`0xFF811A`,`0xFF811E`,`0xFFB288`,`0xFFB3C6`); three helper-installed edges result.
3. **Rule B, generalised.** Find every field-load site `mov.l @(d:16,erN),erM` followed within three
   instructions by `jmp/jsr @erM`. For every reached `mov.l #rec,erN` (rec in ROM), walk forward over
   reached flow (branch targets + fall-through, stopping on a write to erN or on a call) and collect the
   field-load displacements reached with erN intact; decode `be32(rec+d)` and credit it when it is an even,
   in-range, valid instruction head (the sentinel `0x3FFA0` is dropped, as in H9).
4. **Strict gate + fixed point.** Each edge is added as a descent seed only when its referencing sites
   (store/loader/immediate for A; record-passer + field-load for B) are reached in H9's **strict** descent.
   `run("full"/"strict", extra_seeds=…)` iterates to a fixed point. The extended full descent has **0
   overlapping instruction starts and 0 new bad decodes** vs H9.
5. **Overlap.** I9's new bytes come from `new-proven-bytes.tsv`; I6's from `exit-table-new-insns.tsv`
   (addr,len); I8's are reconstructed by seeding its two edge regions (`0x34CCE`, `0x327E/328A/329C`) and
   differencing against H9 (reproduces I8's +182). The four lane masks are pairwise disjoint and disjoint
   from H9's proven mask (verified).
6. **Byte-verify.** Every cite below was read from the image in Python (`checks ok`).

**Not done / limits.** Only the 1–2-level argument/helper dataflow of Rule A was followed; deeper
register-passing chains were not. Rule B covers the `@(d,er1)` dispatcher family reachable from a
`mov.l #rec,erN`; the `jsr @erN` single-pointer form (I9's `0x01A084` via `0x015206`) is a different rule
and is left to I9. The closed window was not entered.

## Findings

### 1. Dispatcher `0x028CBC` (Confirmed)

`0x028CBC` `6b 04 bb c2` = `mov.w @0xBBC2:16,r4`, then a `cmp.w #key,r4; beq` ladder selecting a field
handler. Each handler is `mov.l @(d:16,er1),er6; jsr @er6; bra 0x028D9E (rts)`. Seven displacements are
code-pointer fields — `+0x00` (`0x028D0C`), `+0x04` (`0x028D24` `01 00 6f 16 00 04`), `+0x08` (`0x028D40`),
`+0x0C` (`0x028D4A`), `+0x14` (`0x028D86` `01 00 6f 16 00 14`), `+0x18` (`0x028D90`), `+0x1C` (`0x028DA0`
`01 00 6f 16 00 1c`) — with `+0x18` defaulting to `jsr @0x3FFA0` (the "none" sentinel). The caller passes
the record in `er1` via `mov.l #rec,er1` then `bra 0x028CBC`. Eight such records exist
(`rules-b-records.tsv`), all strict-reached; records `0x028C20`/`0x028C82` are reached through screen table
`0x012268` (origin walk, 8 hops). This is a key-indexed handler table (key register `0xFFBBC2`), not a
USB/DSP path.

### 2. The four new handler targets (Confirmed; `ida\out\descent-ext\new-bytes.tsv` rows `beyond_all=1`)

| Record | field | target | bytes (head) | decode | prior status |
| --- | --- | --- | --- | --- | --- |
| `0x028C2A` | `+0x14` | `0x02A924` (10 B) | `55 08 47 04 5e 02 9c 56 54 70` | `bsr 0x2A92E; beq; jsr @0x29C56; rts` | I9-named, **uncredited** |
| `0x028C2A` | `+0x1C` | `0x028C4A` (16 B) | `5e 02 a9 2e 47 08 …` | `jsr @0x2A92E; …; jsr @0x1A58C; rts` | **not named** |
| `0x028C8A` | `+0x14` | `0x02A9F4` (10 B) | `55 08 47 04 5e 02 9c 56 54 70` | `bsr 0x2A9FE; beq; jsr @0x29C56; rts` | I9-named, **uncredited** |
| `0x028C8A` | `+0x1C` | `0x028CAA` (18 B) | `5e 02 a9 fe 47 0a …` | `jsr @0x2A9FE; …; jsr @0x1A58C; rts` | **not named** |

Record layout (byte-verified): each is a 32-byte / 8-dword struct; `rec+0x14 = target`, `rec+0x1C = target`
(`0x028C2A`: `+14=0002A924 +1C=00028C4A`; `0x028C8A`: `+14=0002A9F4 +1C=00028CAA`). `02A924` and `02A9F4`
are pre-existing unproven IDA functions (10 B each) in MAIN_FINAL; `028C4A`/`028CAA` are flat stubs, not
function starts. None is in `main-indirect\residual.tsv`, so **no F1-residual function becomes reached.**

### 3. Rule A — three helper installers, 0 new bytes (`rules-a-cells.tsv`)

- `0xFF811A` ← `0x000706`: `0x034C24 jsr @0x450` → `0x000454 mov.l #0x706,er5` → `0x00045A bsr 0x42C` →
  `0x00042C 01 00 6b 85 81 1a` (`mov.l er5,@0xFF811A:16`); consumer `0x0028DA mov.l @0xFF811A,er6;
  0x0028E0 jmp @er6` (vector-88 stub). This is I9's +902.
- `0xFF811A` ← `0x0004AA` (installer `0x000404`) and `0xFF811E` ← `0x000E5E` (installer `0x000E26`→`0x000E3A`):
  both helper bodies were already reached. Rule A credits 0 bytes beyond H9∪I9. It confirms H9's note that
  its RAM-cell rule "missed stores made in a called helper", and shows the miss was bounded — only this one
  installer family uses the helper form, and I9 already caught its one unreached body.

### 4. Ledger (`ledger-delta.tsv`)

| Term | Δ | Value |
| --- | ---: | ---: |
| MAIN proven, H9 | | 365,570 |
| H9 + I6 (+1,544) + I8 (+182) + I9 (+1,136), disjoint | | 368,432 |
| I15 Rule A | +0 | |
| I15 Rule B (records `0x028C2A`,`0x028C8A`, fields +14/+1C) | **+54** | |
| **MAIN proven, H9+I6+I8+I9+I15** | | **368,486** |
| MAIN named, H9 (+I6 +10, +I9 +129) | | 497,278 |
| I15 named (`0x028C4A` 16 + `0x028CAA` 18) | **+34** | **497,312** |

## USB relevance

None. The new dispatcher `0x028CBC` is keyed on `0xFFBBC2` and its handlers (`0x02A924`/`0x02A9F4` →
`jsr @0x29C56`; `0x028C4A`/`0x028CAA` → `jsr @0x2A92E/@0x2A9FE` and `jsr @0x1A58C`) are ordinary
application/menu code. Explicit flag check: none of `0x02A924`, `0x02A9F4`, `0x028C4A`, `0x028CAA` falls in
USB `0xFFEE00`–`0xFFEE53`, SCI-C `0xFFFF88`, or the closed window `0x078106`–`0x07B753`. The USB, SDR and
DSP answers are unchanged; this lane only hardens the MAIN proven/named figures.

## Open

Most valuable first:
1. **Name the key-dispatch family.** Dispatcher `0x028CBC` on `0xFFBBC2` has eight 32-byte records
   (`rules-b-records.tsv`); identify the key source `0xFFBBC2` and what the handlers at `0x29C56`/`0x2A92E`/
   `0x1A58C` do (likely a sub-menu or band/mode selector). This would let the 32 unopened save-handler
   screens (H13) be attributed.
2. **Other `@(d,ERn)` dispatchers.** 174 field-load+indirect-jump sites exist across four base registers
   (er1/er3/er4/er6); only the er1/`0x028CBC` family had record-address callers that added bytes. A pass
   that feeds the er3/er4/er6 dispatchers from their table/array pointer roots (I8's domain) may reach more.
3. **Deeper Rule A chains.** Only 1–2 register-passing levels were followed. No third-level installer was
   found in scope, but the search was bounded; a full backward-slice would close it.
