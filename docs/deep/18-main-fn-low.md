# MAIN functions below 0x038000 — validation, purpose, recovery (Lane 1)

## Verdict

The 1,962 pre-existing MAIN functions with start `< 0x038000` were re-validated
and each given a real, evidence-based purpose line; 8 additional real functions
below the cut were recovered that the 3,899-function list missed. Of the
1,970 candidates below the cut, **1,547 are validated** (1,537 reached by a call,
jump, or vector; 10 accepted only on a byte-level prologue+return decode) and
**423 sweep-only candidates were rejected** (no xref and no clean prologue/return
signature — the residue of the earlier forced linear sweep). Every validated
function has a purpose line citing its start address, so `T_fn_low == D_fn_low`.
This region is **not** where the SCI/USB drivers live (those sit above the cut,
`0x44xxx`–`0x55xxx`): below `0x038000` is the reset/C-runtime, the timer and
I/O-port ISRs, and the bulk of the **foreground UI / screen-mode / menu state
machines and their settings writers**. The highest-value routines here are
jump-table command/menu dispatchers (`sub_1079E`, `sub_2853E`, `sub_28562`,
`sub_325A`) and the timer ISR that tail-dispatches an installed RAM handler
pointer (`sub_28F4`). Machine-readable table:
`ida\out\fnindex\main-low.tsv` (1,547 rows).

## Method

Private DB `FN_MAIN_LO`, seeded `--copy-from ida\db\jobs\MAIN_FULL\MAIN_FULL.i64`
(the 3,899-function state) and reopened. Two IDA jobs through `ida\run_job.py`:

- `ida\jobs\full_l1_classify.py` — Stage A conservative recovery below the cut
  (A1: call/jump/vector code-xref targets not yet functions; A2: undefined runs
  that decode cleanly from an H8S prologue to a return, ≥4 instructions, no bad
  decode). Stage B: classify every function `< 0x038000` — validated test,
  per-function decode stats, absolute-operand peripheral map, settings/RAM
  writers, callees, string refs, indirect-dispatch idiom, purpose synthesis.
  Stage C: byte accounting below the cut. Outputs `main-low.tsv`,
  `main-low-extra.tsv`, `new_functions.tsv`, `l1_counts.txt`, `l1_log.txt` under
  `ida\out\fnindex\`.
- `ida\jobs\full_l1_dump.py` — annotated disassembly of the eight highest-value
  routines (`hivalue_disasm.txt`) and an image-wide caller list for the EEPROM
  driver (`eeprom_callers.txt`).

**Validated** test: `nrefs > 0` and not a data signature, OR a byte-level decode
with a plausible H8S prologue (`push`/`stm`/`mov …,@-sp`/`sub …,sp`), at least
one return, ≥3 instructions, zero bad decodes, and at least one structural
instruction. Sweep-only candidates failing this were rejected and counted, not
listed. Addresses in this doc are true 24-bit effective addresses; IDA's
`h8s300a` module prints the 16-bit-absolute page as `0xFFFFxxxx`, e.g.
`@0xFFFFA9ED:16` is real address `0xFFA9ED`.

Did **not** run: no device access; nothing written to `decrypted\`,
`ida\db\radio\`, or the shared `.i64`s; no re-proving of settled RESUME-DEEP
answers; band/MARS/CAP and the `26AA:0020` DSP-boot loader left closed (none of
them live below this cut anyway — the CDC selector and USB stacks are above it).

## Findings

### Region character below `0x038000`

Peripheral touches among validated functions below the cut (from
`main-low-extra.tsv`): timer 19, port-io 69, port-dir 23, A/D 3, USB 1, SCI-D 1,
SCI-A/B/C 0, DMAC 0. The SCI and USB drivers, DMA setup, and the DATA-jack
command API all live **above** the cut; below it the peripheral surface is the
early timer/TMR ISRs (vectors 66–110, handlers `0x28D0`–`0x2A60`), the I/O-port
bit-bang, and the polled A/D (`sub_32C0`/`sub_3466`). 764 validated functions
write RAM config/settings bytes (`0xFF8000`–`0xFFBFFF` / `0xFEE000`–`0xFF72FF`);
138 contain an `eepmov` block copy; 22 use an indirect `jmp/jsr @reg` dispatch.
708 validated functions carry a `[weak]` purpose (small structural helpers with
no peripheral/string/settings signature) — marked so, not invented.

### Highest-value routines (hand-written C)

These qualify under the "settings byte / menu table / command dispatch" rule.

**`sub_1079E` @ `0x1079E`** — foreground screen/mode service pump. Bounds the
work on a busy flag `0xFFBBF5`, selects a per-mode handler table (`er5`) from
`0xFFBC4E` (`0→unk_11454`, `1→unk_11410`, `2→unk_11498`, plus special tables
`unk_12590/147D4/112BC` chosen by sub-mode flags), clears UI state
`0xFF9537..0xFF9539`, and finally dispatches by the screen-mode index
`0xFFA9ED` through that table:

```c
/* 0x10966: */ bset(0xFF817E, 1);
if (sub_109BA()) {
    uint32_t m = *(uint8_t*)0xFFA9ED;         /* mode index */
    void (*h)(void) = ((void(**)(void))er5)[m]; /* mov.l @(er5+m*4); jsr @er6 */
    h();                                        /* 0x10982 jsr @er6 */
}
*(uint8_t*)0xFFA9ED = 0xFF;                     /* 0x10994 mark serviced */
/* returns *(uint32_t*)0xFF812A */
```
It writes settings bytes `0xFF812A`, `0xFF8EA6`, `0xFF94C0/94C1`, `0xFFA9ED`,
`0xFFA9F9`, `0xFF9537..39`, `0xFFAA2E/2F`, `0xFFBBE1`, `0xFFBBDE`, `0xFFBC5E`,
`0xFF95E8`. Confidence: high (dispatch idiom and settings writes read directly).

**`sub_2853E` @ `0x2853E`** and **`sub_28562` @ `0x28562`** — bounded jump-table
command dispatchers on menu index `0xFFBBC2`; caller supplies the pointer table
base in `er6`:

```c
void sub_2853E(void (**table)(void) /*er6*/) {   /* sub_28562: limit 4 */
    uint16_t idx = *(uint16_t*)0xFFBBC2;
    if (idx >= 3 || (idx - 1) < 0) { sub_3FFA0(); return; } /* default */
    table[idx - 1]();                            /* shll.l #2; add er6; jsr @er6 */
}
```
Valid index selects `table[idx-1]`; out-of-range falls to the default handler
`sub_3FFA0`. Confidence: high.

**`sub_325A` @ `0x325A`** — state jump table (tail dispatch) with a ROM table at
`0x3272`:

```c
void sub_325A(void) {
    (void)(*(volatile uint8_t*)0xFFFF4E & 0x40); /* sample port bit 6 */
    uint32_t st = *(uint8_t*)0xFFA9E0;           /* state index */
    ((void(**)(void))0x3272)[st]();              /* mov.l @(0x3272,er3*4); jmp @er6 */
}
```
Confidence: high (table base is an in-ROM immediate below the cut).

**`sub_28F4` @ `0x28F4`** — TPU/TMR compare-match ISR that tail-jumps an
installed handler pointer held in RAM at `0xFF811A`:

```c
void sub_28F4(void) {                 /* stm.l er4-er5,@-sp */
    (void)*(uint16_t*)0xFFFFC6;       /* read counter */
    *(uint16_t*)0xFFFFC6 = 0;         /* reset counter */
    *(uint16_t*)0xFFFF36 &= ~0x10;    /* clear compare-match flag */
    uint8_t s = *(uint8_t*)0xFFFFC5;
    if (s & 0x10) *(uint8_t*)0xFFFFC5 = s & ~0x10;
    ((void(*)(void))*(void**)0xFF811A)(); /* jmp @er4: dispatch RAM handler ptr */
}
```
Siblings `sub_28D0/28E2/2922` (vectors 88/97/69) follow the same shape with RAM
handler pointers `0xFF811A`/`0xFF811E` — the firmware installs the active
timer-task handler by writing these RAM pointers. Confidence: high.

### Callback trampolines `sub_15206`/`sub_1522E`/`sub_15260`

A small cluster that dispatches through a callback selected by flag `0xFFAD68`
(0 → `loc_14E04`) and, when a second flag `0xFFAD9D` is set, either calls a
handler directly (`jsr @er1`) or indexes a caller-supplied table
(`(idx-1)*4 + er5`). These are the generic getter/setter/callback shims behind
the menu-item handlers. Confidence: medium (caller supplies the table/reg).

### Recovered functions (not in the 3,899 list)

8, all below the cut, all small in-gap helpers with clean prologue/return
(`ida\out\fnindex\new_functions.tsv`): `0x17C8`, `0x1F42`, `0x1F98`, `0x1A25A`,
`0x1A432`, `0x2224E`, `0x28698`, `0x325E6`. Low yield confirms the MAIN_FULL
pass already had near-complete coverage of this region.

### EEPROM persistence

The bit-banged EEPROM driver `sub_33532` (below the cut) has exactly one caller,
at `0x77DB2` (above the cut); `sub_334CA` has no direct caller in the image.
**Confirmed:** no validated function below `0x038000` calls the EEPROM driver —
consistent with doc-04's finding that settings writes below here land in RAM and
persistence is driven from the higher region.

## Extension

A later owner feature that adds or changes a menu screen would attach to the
`sub_1079E` per-mode handler tables (`unk_11410/11454/11498`, indexed by
`0xFFA9ED`) and to the bounded command tables consumed by `sub_2853E`/`sub_28562`
(indexed by `0xFFBBC2`, caller-supplied base). A periodic-task feature would
install a handler pointer at the RAM slots `0xFF811A`/`0xFF811E` dispatched by
the timer ISRs `sub_28F4`/`sub_28D0`/`sub_28E2`/`sub_2922`. All are RAM-state /
in-ROM-table driven; none writes flash or NV storage from this region. Recorded
as a single fact per the rules — no modification performed.

## Counts

- **T_fn_low** (validated, start `< 0x038000`): **1,547**
- **D_fn_low** (validated with a purpose citing the start address): **1,547**
- New functions recovered below the cut (not in the 3,899 list): **8**
- Rejected sweep-only candidates: **423**
- Instruction bytes inside validated functions below the cut: **100,766**
- Content bytes below the cut (`0x000000`–`0x038000`): **229,376**
  (of which non-`0xFF`: 222,528; the region is entirely inside the content area —
  fill does not begin until `0x07B754`)
- Derived MAIN instruction share below the cut:
  100,766 / 229,376 = **43.93%**
- Of the 1,547 validated: 1,537 reached by xref, 10 byte-validated only.

## Open

1. `sub_1079E`'s sub-mode selector tables (`unk_12590/147D4/112BC/11410/11454/
   11498`) are not yet enumerated entry-by-entry; a table walk would name every
   screen handler the pump can reach.
2. 708 `[weak]` helpers carry only a structural purpose; a caller-context pass
   (who calls them, with what) would upgrade many to concrete purposes.
3. The RAM handler-pointer installers for `0xFF811A`/`0xFF811E` were not traced
   to their write sites (likely above the cut — Lane 2).
