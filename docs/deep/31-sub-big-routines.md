# 31 — Two large un-decompiled SUB routines (Lane F4)

Owner-side static analysis of the FT3DR/FT3DE ver 1.02 **SUB** image
(`decrypted\FT3D_SUB_ver102_ALL.bin`, Renesas RX64M, little-endian, mapped
`0xFFC00000`). Read-only: no device, no writes to any image, no patch, no byte
string produced. Hand-disassembly of the two routines Lane F4 was assigned.

Evidence words: **Confirmed** (I read the bytes/instruction), **Inferred**
(confirmed evidence + a stated assumption), **Not found** (with scope),
**Unknown**. Every claim carries a mapped address and bytes/disassembly.

Database: private `FIN_SUB_BIG`, seeded `--copy-from ida\db\jobs\SUB_WINDOW\SUB_WINDOW.i64`
(never opened a shared DB). Jobs: `ida\jobs\fin_sub_big.py`, `fin_sub_ctx.py`,
`fin_sub_fix.py`. Listings and C: `ida\out\sub-big2\`
(`fff40c3e.lst`, `fff40c3e.c`, `ffef6c42.lst`, `ffef6c42.c`, plus
`callees.txt`, `ctx_a.txt`, `helpers_extra.txt`, `tables.txt`).

## Verdict

- **Routine A — assigned `sub_FFF40C3E`, really `sub_FFF40B7D`
  (`0xFFF40B7D–0xFFF410EB`, 1,390 B):** an **IPC-frame → shadow reconciler for
  the SUB edit/menu record**. It copies each changed field of the incoming
  MAIN→SUB frame at RAM `0x8E46` into the committed shadow at RAM `0x8C4D`, ORs a
  dirty/event bit into `*(uint32*)0x1D3B4` per change (helper `sub_FFEEFEEE`), and
  flushes with `sub_FFEF0294`. Which fields it reconciles is driven by
  `mode = frame[0x6C] & 3` (variable-length field at `+0x6E`, length from flash
  table `0xFFC3E94E = {19,39,79,107}`) and by `shadow[0x6C]∈{0,1,2}` (three fixed
  field groups at `+0x81/+0x85/+0x89…`, `+0x95…`, `+0xBD…`). Callees:
  `FFEEFEEE`, `FFEF0294`, `FFEF4142` (header-field reconciler), `FFEF42A7` (block
  copy). RAM: `0x8C4D`, `0x8E46`, `0x1D3B4`, `0x1D39C`. Sole caller `FFF40B69`
  (chain `sub_FFF40ADB`→`sub_FFF40B61`→this).

- **Routine B — `sub_FFEF6C42` (`0xFFEF6C42–0xFFEF9558`, 10,518 B):** the single
  largest SUB-window function; previously only **coarsely** labelled
  ("[med] wrapper/dispatch") — **newly resolved** as an **incremental multi-slot
  screen renderer**. It redraws up to ~10 on-screen slots, skipping unchanged
  ones via per-slot "last value" caches, compositing icons/bitmaps and
  glyph-metric text into the LCD framebuffer `*(0x1D3C8)`. A screen-type code
  `1..4` from `sub_FFEEC232` (keyed on the frame opcode at `*(0x8C4D)`) selects
  one of three caches (`0x8F79/0x8F83/0x8F8D`); a sub-layout code `0..5` selects
  one of six draw blocks. Callees: `FFEF690B`×52 (text/number draw), `FFEF0AFE`×40
  (clipped bitmap compositor), `FFEF95BD`×18, `FFEF68D5`×16 (icon blit),
  `FFEEC232`/`FFEEE512`/`FFEF02F2`×1. RAM: slot array `0x68F20[10]` (0x28 each),
  `0x8C4C/0x8C4D`, `0x8F77/0x8F78`, caches `0x8F79/0x8F83/0x8F8D`, `0x12286/7`,
  framebuffer ptr `0x1D3C8`. Callers (4): `FFEE68BA`, `FFEF60E8`, `FFEF613C`,
  `FFEF6314`.

Neither routine touches USB, flash-write, the DSP, or any new peripheral — both
are UI/IPC plumbing, consistent with the settled negatives.

## Method

- Seeded `FIN_SUB_BIG` from `SUB_WINDOW`, ran `fin_sub_big.py` (annotated listing
  + operand decode honoring the RX `o_displ`-in-`op.value` trap + code/data-ref
  census), then `fin_sub_ctx.py` (boundary/caller resolution) and
  `fin_sub_fix.py` (clean true-function listing + remaining helpers). All exited
  0, `ida_auto.auto_wait()` + `idc.qexit(0)`, UTF-8 output, try/except traceback.
- The data-ref census (`DataRefsFrom`) returned **0 RAM refs** for both routines:
  they reach RAM via `mov.l #imm,rN; mov.b [rN]`, exactly the BRIEF §4 case where
  IDA creates no xref. I recovered every RAM address by mining the
  `mov.l #imm,rN` immediates from the listing instead — reported below.
- Scope covered: both functions fully disassembled; all direct callees dumped
  (`callees.txt`, `helpers_extra.txt`); flash tables `0xFFC3E94E`, `0xFFED3A2C`,
  `0xFFEC61A8` read (`tables.txt` + raw). **Not run:** no Hex-Rays (none exists
  for RX); the six per-layout draw blocks of Routine B are characterised at the
  block level, not transcribed pixel-op by pixel-op (full text in the `.lst`).

## sub_FFF40C3E  (true entry sub_FFF40B7D)

### The assigned boundary is wrong — Confirmed

`0xFFF40C3E` is **mid-instruction**. Bytes at `FFF40C3C`:

```
FFF40C3C  C5 FE 6E 6E   mov.b 6Eh[r15], 6Eh[r14]
```

The lane-4 body-validation sweep seeded a decode at `FFF40C3E` on the trailing
`6E 6E` and mis-read it as `pushm r6-r14`, registering a false function
`sub_FFF40C3E`. The real routine is **`sub_FFF40B7D`** (`sub #4,sp` prologue at
`FFF40B7D`, `rtsd #1` at `FFF410EB`). IDA over-split it into `sub_FFF40B7D`
(`FFF40B7D–FFF40C10`) + `sub_FFF40C3E` (`FFF40C3E–FFF410ED`); control flows
straight through (`FFF40C0E bra →FFF40C4C` forward, `FFF40C5B blt →FFF40C10`
back). This also explains "no direct xref": the false start has none; the true
start `FFF40B7D` is called once from `FFF40B69` (`bsr.w sub_FFF40B7D`).

### Structure — Confirmed

Locals on a 4-byte frame: `var_1`=mode, `var_2`=loop index, `var_3`=change
count, `var_4`=`frame[0x6D]` snapshot.

1. `FFF40B8B`–`B9E`: `mode = frame[0x6C] & 3`; `d = frame[0x6D]`.
2. `FFF40BA1`: `FFEF4142()` — reconciles the **common header** fields
   (`0x07` bit0, `0x0A`, `0x0B`, `0x0C`; dirty via `FFEEFEA4`). Confirmed in
   `helpers_extra.txt`.
3. `FFF40BA5`–`BCA`: publish `*(0x1D39C) = &shadow[0x20]`, then
   `FFEF42A7(&shadow[0x20], &frame[0x20], 3)` (block copy of the `0x20` triplet).
4. `FFF40BCE`–`C05`: reconcile `shadow[0x6C]`←mode and `shadow[0x6D]`←d, each
   firing `FFEEFEEE(1)` on change.
5. `FFF40C10`–`C5B` (outer loop): variable-length field at `+0x6E`, length
   `tbl_FFC3E94E[mode]`. Flash table `0xFFC3E94E`:
   ```
   FFC3E94E  13 27 4F 6B ...   -> {19, 39, 79, 107}
   ```
   Copies changed bytes, counts in `var_3`; `FFEEFEEE(1)` if any changed.
6. `FFF40C68`–`C7D`: 3-way switch on `shadow[0x6C]`:
   - **case 0** (`FFF40C80`): groups `0x81/0x85/0x89` (4 bytes each, one
     `FFEEFEEE(1)` if changed) then interleaved `0x8D/0x90` (3 each,
     `FFEEFEEE(2<<i)` per change).
   - **case 1** (`FFF40DED`): groups `0x95/0x99/0x9D`, then `0xA1/0xA4`.
   - **case 2** (`FFF40F5A`): groups `0xBD/0xC1/0xC5`, then `0xC9/0xCC`.
   - default: no group.
7. `FFF410C4`: reconcile the single byte `+0x09` (no dirty bit).
8. `FFF410E7`: `FFEF0294()` — the dirty-bit flush/dispatch. `rtsd #1`.

12 wave-2-reported loops + the `+0x6E` outer loop = **13 back-edges**
(`fff40c3e.lst`).

### Helpers — Confirmed

- `sub_FFEEFEEE` (`FFEEFEEE`–`FFEEFF00`, 18 B): `*(uint32*)0x1D3B4 |= arg`.
  A dirty/event-bit accumulator. (Sibling `FFEEFEA4` does the same for a word at
  `0x1D3B0`.)
- `sub_FFEF0294` (`FFEF0294`–`FFEF02F2`, 94 B): if `FFEEFDB9(3)==1`, send byte
  `0x65` via `FFEEFDDA(3,0x65)` and run `FFEEFD91(3)`/`FFEF0273()`; then for each
  bit 0..31 set in the flag words at `0x6885C`/`0x68860`, call `FFEEFEA4`/
  `FFEEFEEE` with that bit — i.e. propagate the accumulated dirty bits.

Hand C: `ida\out\sub-big2\fff40c3e.c`.

### Reading

`0x8C4D`/`0x8E46` are the SUB menu/frame-shadow region (doc 23 §3–4: `0x8E46`
= incoming MAIN→SUB frame, `0x8C4D` = committed shadow). `sub_FFF40ADB` (two
hops up) reads the menu cursor `0x8F73` and dispatches through table
`off_FFED83E8` (`FFF40B43 mov.l [r14,r15],r14; FFF40B46 jsr r14`), and clamps the
screen sub-state `0x8C4C` to `<4`. So Routine A is the **commit stage of a menu
edit**: when MAIN pushes an updated frame, SUB copies the changed fields into its
shadow and raises the matching dirty/event bits so the renderer and IPC reply
pick them up. The `+0x6E` lengths {19,39,79,107} indicate a variable-length
text/data field whose size depends on the record mode (Inferred: a text-entry or
multi-format record; exact field semantics Unknown from this routine alone).

## sub_FFEF6C42

### Prior status — Confirmed newly resolved

`functions.tsv`: `FFEF6C42 FFEF9558 xref yes` (no purpose). `sub-xref.tsv`:
`@FFEF6C42 | calls 6 (...) | [med] wrapper/dispatch` — coarse only. In the wave-2
purpose tables it appears **only as a callee** of `FFEE61B1/FFEE61B3`
(`sub-purpose-1.tsv`), never with its own purpose row. So it had **no real
purpose**; resolved here.

### Prologue & argument — Confirmed

```
FFEF6C42  710098        add #-68h, sp, sp        ; 0x68-byte frame
FFEF6C45  a609          mov.l r1, 68h+var_4[sp]  ; arg (r1) -> local @sp+0x64
```
Takes one pointer argument (the slot/state record). Zeroes a flag/scratch block
(`FFEF6C49`–`6C88`).

### External callees — Confirmed (filtered; the `.lst` "668" count includes
internal branch labels)

| callee | n | role |
| --- | --- | --- |
| `FFEF690B` | 52 | text/number draw wrapper → `FFEF0949`/`FFEF0BD4` |
| `FFEF0AFE` | 40 | **bounds-checked bitmap compositor** into `*(0x1D3C8)`, clips to `0x140×0xF0` (320×240) |
| `FFEF95BD` | 18 | sibling draw block |
| `FFEF68D5` | 16 | icon/bitmap blit wrapper → `FFEF0648`/`FFEF04F7` |
| `FFEEC232` | 1 | screen-type classifier (returns 1..4) |
| `FFEEE512` | 1 | misc |
| `FFEF02F2` | 1 | leaf util |

`FFEF68D5(x,y,mode,desc)` and `FFEF690B(x,y,mode,ptr)` are confirmed two-path
draw wrappers (`callees.txt`); `FFEF0AFE` reads width/height from the descriptor,
clips against 320×240, and writes into the framebuffer pointer at `*(0x1D3C8)`.

### RAM touched — recovered from `mov.l #imm` immediates (DataRefsFrom = 0)

- **Slot array `0x68F20`, stride `0x28`, 10 entries** (`0x68F20,0x68F48,…,0x69088`).
- Menu state `0x8C4C` (sub-state), `0x8C4D` (frame opcode), `0x8F77`/`0x8F78`
  (redraw triggers).
- **Three 10-byte per-slot caches** `0x8F79`, `0x8F83`, `0x8F8D`.
- `0x12285`/`0x12286`/`0x12287`/`0x12288` (screen-code + last-drawn-value caches).

### Flash tables read — Confirmed

- `icon_FFED3A2C` — 16-byte bitmap descriptors `{u16 w,u16 h,ptr,…}`:
  ```
  FFED3A2C 08 00 1C 00 A4 6B E5 FF   8x28  bmp=FFE56BA4
  FFED3A4C 0B 00 1E 00 24 6F E5 FF  11x30
  FFED3A7C 0B 00 34 00 40 78 E5 FF  11x52
  ```
  Increasing-height bar/indicator glyphs (Inferred: level/meter/bar set).
- `coord_FFEC61A8` — 6-byte FIELD_COORD `{u16 idx,u16 x,u16 y}`:
  `x = 0,44,88,144,188,232,275,296` — a horizontal column layout across a ~320px
  screen. (`doc 27`: FIELD_COORD family.)
- `glyph_FFEC5A12` — 6-byte GLYPH_METRIC records (`doc 27` names it
  `GLYPH_METRIC_6B`); read at `FFEC61A8`-relative offsets for text measurement.

### Control architecture — Confirmed

1. **Stage 1** (`FFEF6C8B`–`6D0E`): `type = FFEEC232()`; cache `arg[0x2F]` into
   `0x12286` (type 4) or `0x12287` (type 1/3); set redraw flags on change.
   `FFEEC232` itself (`helpers_extra`/raw) reads `*(0x12285)` and the frame
   opcode `*(0x8C4D)` (observed compares `#0xFD/#0xF7/#0xF8/#0xF1`) and returns
   a small screen-type code.
2. **Stage 2** (`FFEF6D0F`–`6DE1`): if `*(0x8C4C)==2 || *(0x8F77)==1 ||
   *(0x8F78)==1 || flag`, invalidate all 10 cache cells (`=0xFF`) of the
   type-selected cache.
3. **Stage 3** (`FFEF6E85`–`6F3D`, then `FFEF7131`–`7387`): per-slot
   (`var_10`, up to 10 / draw loop bounded at 8) compute the current value,
   compare with the cache, append changed slots as 3-byte `{row,new,old}` records
   to a stack change-list (`var_2F`, count `var_30`), and update the cache
   (dirty-marked `-2`/`-1`). This is the **incremental skip-unchanged** core.
4. **Stage 4** (`FFEF738A`): dispatch on sub-layout `var_F ∈ {0..5}` to six draw
   blocks, each walking the changed slots + FIELD_COORD table and emitting
   `FFEF0AFE`/`FFEF68D5` (icons) and `FFEF690B` (text) into the framebuffer:
   - `0`→`FFEF73AB`, `1`→`FFEF8039`, `2`→`FFEF8D23`, `3`→`FFEF79F2`,
     `4`→`FFEF86BE`, `5`→`FFEF93DC`, default→`FFEF9A47`.

44 back-edges total, spread across the six draw blocks (`ffef6c42.lst`).

### Callers / where the screen lives — Inferred

Callers: `FFEE6899` (wrapper that calls this then `memcpy FFEFB268`), `sub_FFEF6096`
(twice), `FFEF6314`. Those sit in the `FFEF60xx–FFEF63xx` screen-draw cluster,
reached from the menu **sequencer/coordinator** functions `FFEEBAAF`/`FFEEBAEC`/
`FFEEBE8E` (touch `0x8F77`, `0x1D3B8`), `FFEEF77E`, and `FFF12272`. So this is a
**top-level multi-slot operating/status screen**, not the plain setup-menu list
(which is `FFF08xxx/FFF09xxx`). The frame opcodes `0xF1/0xF7/0xF8/0xFD` that
`FFEEC232` keys on are the MAIN→SUB screen-command bytes. The **specific** screen
(candidates: a GM/Group-Monitor member grid, APRS station grid, or band/channel
status row — the bar-icon set and 6-column coordinate table fit a multi-station
or meter display) is **Inferred/Unknown**: no in-routine string anchors it.

Hand C: `ida\out\sub-big2\ffef6c42.c`.

## Open

1. **Name Routine B's screen.** Decode `sub_FFEEC232`'s full body (what maps
   frame opcode → type 1..4) and the six draw blocks' icon/coord selections; one
   block likely corresponds to a labelled screen in the `0xFFED4050` screen table
   or the `FFEEBAxx` sequencers. Highest value.
2. **Fix the function database.** `sub_FFF40C3E` is a false, mid-instruction
   start; merge it into `sub_FFF40B7D`. The 205-RTE-stub / over-split pattern
   (RESUME conflicts) suggests other lane-4 body-validated starts beginning with
   `mov.l #imm` / four-byte `C5 FE ..` tails may be similarly mis-seated.
3. **Routine A field semantics.** Resolve what the `+0x6E` variable field (modes
   with lengths 19/39/79/107) and the `0x81…/0x95…/0xBD…` groups hold — likely a
   per-record edit buffer; cross-check against the MAIN frame builder.
4. **`0x1D3B0/0x1D3B4/0x1D3C8/0x68F20` map.** These RAM anchors (dirty words,
   framebuffer ptr, slot array) recur across the UI; a short RAM-layout pass would
   let the whole `FFEExxxx` renderer/sequencer family be read at once.
