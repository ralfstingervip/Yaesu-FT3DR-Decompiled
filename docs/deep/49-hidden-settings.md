# 49 — Hidden settings F316 / F31A and the MAIN screen model (lane H13)

Owner-side, static, read-only analysis of the owner's FT3DR/FT3DE ver 1.02 images. MAIN is
`decrypted\FT3D_MAIN_ver102_EXP.bin` (H8SX, big-endian, base 0, so file offset = address). SUB is
`decrypted\FT3D_SUB_ver102_ALL.bin` (RX64M, little-endian, at `0xFFC00000`). No image was modified,
nothing was written to or read from any device, and the closed MAIN window `0x078106`–`0x07B753`
was not analysed. Key codes, key sequences and the power-on key table are out of scope and are not
decoded here. Model: **Opus 5.5 (`claude-opus-5-5`)**.

Machine tables are in `ida\out\hidden-settings\`:

- `screens.tsv`: one row per MAIN screen id `0x00`–`0xEE` (239 rows). Columns: entry-notify stub,
  IPC opcode it sends, dial handler, exit/save handler, key table, menu-row membership, every writer
  found, F-code and SUB label.
- `readers.tsv`: every reader and writer of `0xFF89A9` and `0xFF89B6` on MAIN and SUB, with bytes.
- Generator: `ida\jobs\h13_gen_tables.py`. It is plain read-only Python. Before it writes anything,
  it re-reads **52 cited byte runs** from both `.bin` files and aborts on any mismatch. Last run:
  `checks ok: 52; screens 239; readers 14`.
- Raw IDA evidence:
  - `d1.txt`..`d10.txt` (MAIN) and `s1.txt`, `s2.txt` (SUB), from `ida\jobs\h13_dump.py`;
  - `screens_raw.txt` (every screen-byte store), from `ida\jobs\h13_screens.py`;
  - `sub_scan.txt`, from `ida\jobs\h13_sub.py`.

A note on numbering. The file `49-key-sequence-hidden.md` is the earlier lane H11 write-up, which was
interrupted before it finished. This document supersedes its F5 and F6 sections; the corrections are
listed under Findings §6.

## Verdict

**F316 ("LEVEL 1..15", `0xFF89A9`) is a dead setting in ver 1.02.**

It is fully plumbed on MAIN as setup screen **`0x41`**. Each piece is Confirmed:

| Piece | Where |
| --- | --- |
| Entry notifier | `0x782C` slot `0x41` → `sub_534C` sends `[FF89A9]−0x13` as F316 |
| Dial handler | `0x12268` slot → `0x166AA`: saturating step over `0x13..0x21` |
| Exit handler | `0x19A9E` slot → `0x192C4`: saves R1 `n=0x89` to EEPROM `0x609` |
| Key table | the generic item key table `0x12948` |

**Nothing ever makes `0x41` the current screen.** Row code `0x41` is absent from every menu row table,
and every writer of the screen byte was enumerated: 55 `er0` stores, 53 stores through other
registers, every push and direct-entry call, and the absolute aliases. A raw-byte scan cross-checks
the result. None of them produces `0x41`
(Not found; the scope is given under Method).

**The value controls nothing.**
- On MAIN its only reader is the sender itself. The dial handler's "apply" hook is
  `jsr nullsub_36` (`0x69A6` = `54 70`, rts).
- On SUB, F316 is only latched (`FFEFE73C`) and drawn as "LEVEL n" (`FFF00A8F`).

So it is **unreachable *and* inert**: dead, not merely hidden. The likely original purpose is an LCD
contrast-type DISPLAY item (Inferred, weak; §1.5).

**F31A (`0xFF89B6`) is the same pattern, one step weaker.** It is screen **`0x5C`**:
- notifier `sub_56E6`;
- dial handler `0x16B4E`, a *wrapping* 4-value `0..3` edit;
- exit handler `0x19312`, which saves R1 `n=0x96`.

No writer sets screen `0x5C`, the value has no MAIN consumer, and the SUB jump-table slot for code
`0x1A` is `rtsd`, so it is never even drawn. Dead (Confirmed within the same scope).

**Screen model (Confirmed).**
- Each band record holds a two-byte screen stack: `+1` = current screen id, `+0` = previous. The
  active record is `[FF812A]`; `FF90F0` is a third record used directly by about 30 sites.
- `sub_3FF10` pushes (`+0 ← +1`, `+1 ← r3l`). `sub_3FF3A` pops: for item screens
  `0x0E ≤ id < 0xDC` it first runs the per-screen exit/save handler, then sets `+1 ← +0`, `+0 ← 0`.
- Screen **`0x0C` is the setup-menu group list**: its notifier sends **F300**, and its key table's
  select slot enters a group. Screen `0x0D` is the sub-group list for group 2 (F301).
- When an item is opened, the 0-based **row code becomes the screen id** (`0x29A8C`
  `mov.b r3l,@(1,er0)`; `0x14B22`/`0x14B90`/`0x14C80` push).
- Four parallel tables are indexed by that id:

  | Table | Role |
  | --- | --- |
  | `0x782C` | entry notifier |
  | `0x12268` | dial |
  | `0x19A9E` | exit/save |
  | `0x1208C` → `0x125D4` | key table |

- `screens.tsv` resolves all 239 ids. **168 have at least one writer** (row-table membership, a
  constant, a direct-entry call or a screen table). **71 have table slots but no writer found.** Of
  these, 22 are empty slots (`rts` notifier, no dial, no save) and 32 carry a real EEPROM save
  handler, so they look like orphaned items from a shared code base. 6 of the 71 have a notifier that
  sends a frame to the SUB: `0x38`, `0x41`, `0x42`, `0x5C`, `0x80` and `0xEE`. `0x41` and `0x5C` are
  the two that are both fully plumbed and documented here.

## Method

**Databases.** All IDA work used `run_job.py` only:
- `H13_MAIN`: `--copy-from ida\db\jobs\MAIN_H8SX\MAIN_H8SX.i64` (`h8sxa`), then `--reopen` ×10;
- `H13_SUB`: `--copy-from ida\db\jobs\G3_SUB\G3_SUB.i64`, then `--reopen` ×2.

Every run exited `idat_exit 0` with no error file. No shared DB was opened and `run_ida.py` was not
run.

**Scripts.**
- `h13_dump.py` is a copy of `h12_dump.py` with the output path changed. Its commands are
  `func`/`range`/`imm`/`xref`/`ctx`/`displ`.
- `h13_screens.py` lists:
  - every code head in `0..0x078106` and `0x07B754..0x80000` whose disassembly stores to
    `@(1:16,ERn)`;
  - every word/long store to `@(0,ERn)`/`@ERn`;
  - every caller of `sub_3FF10`/`3FF3A`/`3FF2C`/`3FEFC`, each with 6 heads of context.
- `h13_sub.py` scans all 172,474 SUB code heads for compares against `0x16`/`0x1A` near the frame
  code byte, and for any operand equal to `0x8C6D`/`0x8E66`.

**`FF89A9` / `FF89B6` reader scope.**
- IDA `imm` scan of every code head (o_imm/o_mem).
- Raw byte scan of `89 a9` and `89 b6` over `0..0x80000`. The non-code hits were checked one by one:
  `6a 89 a9 xx` = `mov.b r1l,@FFA9xx`; `00 03 89 b6` = pointer `0x000389B6` in table `0x387FA`.
- Every `mov.l #0xFF89xx,ERn` base load (46 sites). Only the bulk/EEPROM writers load `FF8920`, and
  no base plus displacement reaches `0xA9`/`0xB6`.
- An `o_displ` scan for displacements `0x89`/`0x96`. All 98 hits are `er0` band-record field
  `+0x89`, not the R1 region.

**Screen-writer scope.**
- The IDA scan above. It found 55 `@(1,er0)` stores, 53 on other registers (all classified), 25
  push callers and 35 pop references.
- A raw-byte scan over the same range, independent of IDA's code/data state:
  - every `6e [8-f]x 00 01` store with its loading `f? xx`;
  - every `jsr`/`jmp`/`bsr`/`bra` to `148A0`, `14C72`, `14AF4`, `14B76`, `3FF10`, `3FEFC`, `3FF1E`,
    `3FF02`, with the preceding `mov.b #xx,r3l`;
  - absolute writes to `FF8EE1`/`FF8FE9`/`FF90F1`.
- Both methods give the same value set.
- Indexed sources were read in full:
  - row tables `0x1515C`–`0x151EB` within the clamp records at `0x15102`;
  - table `0x3BC6`;
  - tables `0x23144`/`0x23156`.

**Not done.**
- The writer of `0xFFADA1`. It is read at `0x6FD1A` and copied into the screen byte, and is compared
  only against `0x85`/`0x88`/`0x89`. No abs16/abs32 writer exists, so it is written indirectly.
  Unknown.
- The EEPROM restore of record `FF90F0` (`0x39882`, 0x80 bytes from EEPROM `0x980`) can only restore
  a previously saved screen byte. It is not a source of new ids (Inferred).
- No physical-key mapping was attempted (out of scope).

## Findings

### 1. F316 / `0xFF89A9` "LEVEL 1..15"

**1.1 Readers and writers on MAIN (Confirmed; `readers.tsv`).**

| Site | Bytes | What |
| --- | --- | --- |
| `0x0534C` | `6a 0b 89 a9 fc 13 18 cb 6d f3 79 0b f3 16 5e 00 97 6a 6d 73 54 70` | `sub_534C`: `r3l = [FF89A9] − 0x13`, then `sub_976A(0xF316)`. **The only reader.** |
| `0x0E58A` | `fc 19 6a 8c 89 a9` | factory default `0x19` (`sub_DEFA`), sent as 6 → "LEVEL 7" |
| `0x166AA` | `7a 06 00 01 66 ba 5e 03 f6 00 5e 00 69 a6 54 70` + record `13 21 00 ff 89 a9` | dial handler: `sub_3F600(&{lo 0x13, hi 0x21, &FF89A9})`, then `jsr nullsub_36` |
| `0x192C4` | `79 01 00 89 5a 03 cc bc` | exit handler: `sub_3CCBC(n=0x89)` → EEPROM `0x609` (BACKUP.dat `0x4C9`) |
| `0x395B8` | `79 06 01 80 7a 00 00 00 05 80 …` | R1 bulk save/restore (doc 32) |

**`sub_3F600` vs `loc_3F628` (Confirmed).** Both take `er6` → `{u8 lo, u8 hi, u32 ptr}`, and the
direction comes from `FFA9EE` bit 0.
- **`sub_3F600` saturates.** At `0x3F610`–`0x3F622`, a value already at `hi` (up) or `lo` (down)
  is left unchanged and the key is consumed. Otherwise it falls into `3F628`.
- **`loc_3F628` wraps.** At `0x3F636`–`0x3F674`, `v ≥ hi` goes to `lo` going up, and `v ≤ lo` goes to
  `hi` going down; otherwise it does `±1`.

So `FF89A9` ranges over `0x13..0x21`, 15 values, and the SUB's "clamp ≥15→14, +1" (doc 44) shows
exactly LEVEL 1..15.

**The "apply" hook is empty.** Compare a working sibling: LAMP's KEY-field edit `0x16684` is reached
through the pointer pair at `0x1667C`, uses record `00 0a 00 ff 89 aa`, and follows its step with
`bset #3,@FFAA30` (`0x1668E`). F316 instead calls `nullsub_36` (`0x069A6` =
`54 70`).

**1.2 No consumer (Not found, scope in Method).**
- No other abs16 or abs32 reference to `FF89A9` exists.
- No base-plus-displacement reference reaches it: the only `FF8920` base loads are `sub_395B8` and
  the `sub_3CCBC` family.
- The nearest `mov.l #0xFF89xx` loads (`0x1948A` `FF8999`, `0x194AE` `FF89A1`, `0x194BC` `FF89A2`)
  are single-byte EEPROM writes with `r6 = 1` (`79 06 00 01`), so they do not cover `0xA9`.

**1.3 SUB side (Confirmed).**
- **Store.** `FFEFE727` reads code `[8C4E]`. `FFEFE73C` `71 1e eb` / `61 3e` routes codes
  `0x15..0x17` to the generic one-byte compare-and-copy `8E66 → 8C6D` (`FFEFE75E`–`FFEFE78C`).
- **Draw.** The group-1 drawer clamps and prints "LEVEL n" (`FFF00A8F` `61 f1`).
- **No other use.** The whole-image compare scan found three `cmp #16h` sites near frame bytes:
  - two are loop bounds of frame-copy loops (`FFEE6D05`, `FFEEABDC`);
  - one is the **F8xx** "Upload" path (`FFF0C2CE` `75 5e f8` tests opcode high byte `0xF8`, so it is
    F816, not F316).

  Nothing on the SUB turns code `0x16` into a hardware action.

**1.4 Reachability: table slot `0x7930` belongs to the screen-entry table `0x782C` (Confirmed).**
- **The table and its index.** `0x782C` is a 239-entry BE32 table, `0x782C`–`0x7BE7`. The next bytes
  at `0x7BE8` are code (`6b 24 00 ff 3d 74`). It is indexed by the **current screen id**: the four
  call sites `0x0481C`, `0x04DE4`, `0x06C6E` and `0x06E92` all do
  `mov.b @(1,er0),r3l ; and.l #0xFF ; shll.l #2 ; mov.l @(0x782C,er3),er6 ; jsr @er6`
  (`78 b0 6b 26 00 00 78 2c`).
- **The slot.** Slot `0x41` = `0x7930` = `0000534c`.
- **Where screen ids come from.** Item screen ids are menu row codes. Every path that turns a row
  into a screen reads the 15 row tables at `0x1515C`–`0x151EB`, through:
  - `sub_14C90` (`0x14CD8` `78 c0 6b 25 00 01 4d 6a`, `0x14CEE` …`4d aa`);
  - `sub_14EBE` (`0x14EE4`);
  - the per-group switch `0x2992A`–`0x29A72`, which feeds `0x29A8C`.
- **0x41 is not in them.** The tables' 144 bytes contain no `0x41` and no `0x5C`.
- **No other path produces it.** The remaining sources are:
  - constants 0, 1, 2, 9, `0x0A`–`0x0D`, `0x1D`, `0x1E`, `0x6B`, `0xB3`, `0xDB`, `0xDC`,
    `0xE8`–`0xEC`;
  - direct-entry ids 0x26, 0x28, 0x2B, 0x39, 0x40, 0x52, 0x6C, 0x72, 0x7F, 0x8C and 0xB1 (§3.4);
  - table `0x3BC6` (3..7);
  - table `0x23156` (`0xDD`..`0xE7`);
  - `[FFADA1]`;
  - restores of `+0`.

  None of them yields `0x41`.

**Verdict for row code `0x41`: dead.** It has a full screen implementation and no entry.

**1.5 What it was meant to be (Inferred, weak).** Three facts point to a removed **LCD-contrast-type**
DISPLAY item:
- the SUB code `0x16` sits between LANGUAGE (`0x15`) and LCD DIMMER (`0x17`) in an otherwise
  alphabetical DISPLAY list (`BAND SCOPE, LAMP, LANGUAGE, LCD DIMMER, OPENING MESSAGE, SENSOR INFO,
  SOFTWARE VERSION`, doc 44 F2);
- it uses a "LEVEL n" scale like LCD DIMMER;
- its R1 byte `n=0x89` lies next to LAMP `n=0x8A` and near LCD DIMMER `n=0x84`.

The label itself is not in the package (Unknown). Whatever it was, ver 1.02 drives no peripheral from
it.

### 2. F31A / `0xFF89B6`

| Site | Bytes | What | Status |
| --- | --- | --- | --- |
| `0x056E6` | `79 0b f3 1a 6a 0b 89 b6 5e 00 97 6a 54 70` | `sub_56E6`: send `[FF89B6]` as F31A. Only reader. Slot `0x782C+4·0x5C = 0x799C` | C |
| `0x16B4E` | `7a 06 00 01 6b 5a 5e 03 f6 28 54 70` + record `00 03 00 ff 89 b6` | dial handler for screen `0x5C` (`0x12268` slot `0x123A0`): wrapping step `0..3` (4 values) | C |
| `0x19312` | `79 01 00 96 5a 03 cc bc` | exit handler: save R1 `n=0x96` (EEPROM `0x616`, BACKUP.dat `0x4D6`) | C |
| SUB `FFEFE74F` | `75 51 1a 20 0c` | code `0x1A` → generic 1-byte latch | C |
| SUB `FFF0104D` | `67 43` | draw jump-table slot = `rtsd`: **never drawn** (doc 44) | C |
| — | — | any other MAIN/SUB reader | NF (same scope as §1.2; `00 03 89 b6` at `0x3882C` is pointer `0x000389B6`) |
| — | — | an explicit factory-default store | NF (abs scan of `sub_DEFA` and image-wide) |

Screen `0x5C` is absent from the row tables and from every other writer. **Dead.** What its four
values meant is Unknown.

The alphabetical slot rule from §1.5 would place its label between SENSOR INFO and SOFTWARE VERSION
(Inferred).

### 3. The MAIN screen model

**3.1 Storage (Confirmed).**
- **Records.** Records sit at `FF8EE0` (A), `FF8FE8` (B) and `FF90F0`, each `0x108` long. Alternates
  `FF9190`/`FF922C` are installed at `0x2CF54`/`0x2DE12`.
- **Pointers.** `[FF8122]` and `[FF8126]` are the A and B pointers. `[FF812A]` is the active one,
  chosen by `FF817E` bit 0 (e.g. `0x02B78` `6a 18 81 7e 72 00 01 00 6b 00 81 22 01 00 6b 80 81 2a`).
- **`FF90F0`.** 30 sites load `er0` directly with `FF90F0` (`7a 00 00 ff 90 f0`, e.g. `0x02B9E`,
  `0x0DFF8`).
- **The screen pair.** Each record holds **`+1` = current screen** and **`+0` = previous screen**.
  The absolute aliases `FF8EE0`/`E1`, `FF8FE8`/`E9` and `FF90F0`/`F1` are written together at
  `0x10346`–`0x1035A` and `0x24AFE`/`0x24D04`.

**3.2 Push and pop (Confirmed; hand C from the bytes).**

```c
typedef struct { uint8_t prev, cur; /* ... 0x108 bytes ... */ } rec_t;   /* er0 = [FF812A] */

void scr_push(rec_t *r, uint8_t id)          /* sub_3FF10: 6e0c0001 6e8c0000 6e8b0001 5470 */
{ r->prev = r->cur; r->cur = id; }
void scr_push90F0(uint8_t id)                /* sub_3FF02: same on FF90F0 */
{ R90F0.prev = R90F0.cur; R90F0.cur = id; }
void scr_pop(rec_t *r)                       /* sub_3FF3A */
{
    if (r->cur >= 0x0E && r->cur < 0xDC) {   /* setup item screen */
        exit_handler[r->cur - 0x0E]();       /* sub_19158: jsr 0x148A0 + BE16[0x19A9E + 2*(id-0x0E)] */
        FFAA31 &= ~4; sub_697EC();
        if (r->prev == 0x0C || r->prev == 0x0D) goto out;   /* back to the menu list */
    }
    FFAA31 &= ~4; sub_1F9EA();
out:
    r->cur = r->prev; r->prev = 0;
}
uint8_t item_index(rec_t *r) { return r->cur - 0x0E; }   /* sub_15E42 (fc 0e 18 cb) */
```

**3.3 Per-screen tables (Confirmed).**

| Table | Index | Used by | Meaning |
| --- | --- | --- | --- |
| `0x782C` BE32 ×239 | id | `0x0481C`, `0x04DE4`, `0x06C6E`, `0x06E92` | entry/refresh notifier → MAIN→SUB frame (F3xx and others). `0x04892` = `rts` |
| `0x1208C` BE16 ×238 → `0x125D4`+off | id−1 | `0x29AA0` (any id), `sub_10EB8` (id < `0x0C`) | key table, 17 × BE32 per screen. Offset `0x374` = shared item table `0x12948` |
| `0x12268` BE32 ×219 | id−`0x0E` | `sub_15E1E` (`0x15E30`) | dial / value-change handler. `0x3FFA0` = consume key only |
| `0x19A9E` BE16 ×206, rel. `0x148A0` | id−`0x0E` | `sub_19158` from pop (`0x3FF46`) | exit handler. Usually `mov.w #n,r1 ; jmp sub_3CCBC/3CCEC/3CD1C` = save R1/R2/R3 byte n |

**3.4 How a screen becomes current (Confirmed).**

**Screen `0x0C`, the setup-menu group list.** It is pushed at `0x1492A`, `0x14946` and `0x14BAC`
(`fb 0c 5e 03 ff 10`).
- Its notifier `0x4E24` (`… 5e 00 95 62`) calls the **F300** builder `0x9562`. G3 found that F300
  routes the SUB to its group-list screen `0x1D`.
- Its key table is `0x128C0`:
  - slot 3 (`0x128CC`) = `sub_14AF4`, which enters the group indexed by `[FF8F2E]`;
  - slot 9 (`0x128E4`) = `0x14BB2`, which pops.
- `sub_14AF4` behaves as follows:
  - group index 1 → push `0x0D`, the sub-group list (F301 builder `0x95C0`);
  - group index 12 (1-based group 13) is refused unless `FF89C4` bit 3 is set (`0x14B04`
    `ac 0c 46 08 6a 10 89 c4 73 30 47 3e`);
  - otherwise the item's row code is pushed (`0x14B22`).

**Row code → screen.** Four paths, all reading the row tables:
- `sub_14C90` → push at `0x14B22`, `0x14B90`, `0x14C80` and `0x1845C`;
- `sub_14EBE` → store at `0x14E50`;
- the group switch → `0x29A8C` `6e 8b 00 01`.

The row tables are `0x1515C` (g1), `0x15166`/`0x1516A`/`0x15180` (g2 a/b/c), and `0x15186` …
`0x151E6` (g3..g13). They sit behind the pointer tables `0x14D6A`/`0x14DAA` and the cursor clamp
records `0x15102` (`{u16 max, u32 0xFFAD9B}` ×15).

**Direct entry `sub_148A0` (`r3l` = id, `r3h` = return tag).**
- It sets `FFAD6A=2` and `FFAD6B=r3h`, then pushes via `sub_14C72`. The pop at `0x148E6`/`0x14908`
  returns there.
- Its 13 call sites carry ids 0x26, 0x28 (×2), 0x2B, 0x39, 0x40, 0x52, 0x6C, 0x72, 0x7F, 0x8C (×2)
  and 0xB1. For example, `0x1F2C0` `fb 8c f3 01 5e 01 48 a0` opens TX POWER `0x8C`. These are the
  shortcut paths into single items.

**Other sources.**
- Constants: 1, 2, 9, `0x0A`, `0x0B`, `0x1D`, `0x1E`, `0x6B`, `0xB3`, `0xDB`, `0xDC`, `0xE9`.
- `0xE8`, `0xEA`, `0xEB` and `0xEC` come only from power-on handler routines (`0x1029A`, `0x1053E`,
  `0x1051C`, `0x103DE`; doc 50 covers `0xE8`).
- Table `0x3BC6` gives the operating-mode screens 3..7. Its index is record `+0x8A`, e.g. `0x2CA90`
  `6e 2b 3b c6`.
- Table `0x23156` gives `0xDD`..`0xE7` (`0x2311C`).
- `[FFADA1]` → `0x85`/`0x88`/`0x89` (`0x6FD1A`).
- Restores of `+0`: `0x1F930`, `0x2D5D0`, `0x2E1C2`, `0x33F54`.

**3.5 Screen-id table (`screens.tsv`; 239 rows).** A selection:

| id | Notifier / opcode | Dial | Exit | Purpose (source) |
| --- | --- | --- | --- | --- |
| `0x00` | `rts` | – | – | no screen / home (cleared by pop, `0x3FF90`) |
| `0x03`–`0x07` | `0x4C76`.. | – | – | operating-mode screens from table `0x3BC6` |
| `0x09` | `0xD642` F403 | – | – | pushed at `0x21A1A`; F403 routes SUB to screen `0x47` (G3) |
| `0x0A` / `0x0B` | `0x4D84` / `0x4D40` | – | – | pushed when `FF8EA9.7` / `FF8EBD.7` is set (`0x14BD0`–`0x14BEA`) |
| `0x0C` | `0x4E24` → F300 | – | – | **setup-menu group list** |
| `0x0D` | `0x4E36` → F301 | – | – | group-2 sub-group list |
| `0x0F`…`0xD7` | F3xx stubs | `0x12268` | `0x19A9E` | **setup items**; row code = id; labels from G3 (e.g. `0x3F` LANGUAGE, `0x40` LAMP, `0x28` LCD DIMMER, `0x8C` TX POWER, `0xC0` SOFTWARE VERSION) |
| **`0x41`** | `0x534C` F316 | `0x166AA` | `0x192C4` save n=0x89 | **dead hidden item (§1)** |
| **`0x5C`** | `0x56E6` F31A | `0x16B4E` | `0x19312` save n=0x96 | **dead hidden item (§2)** |
| `0xB7`, `0xD2`, `0xD3`, `0xD6`, `0xD7` | `rts` / `0x5EA38` / `0x643A` | – | – | rows of group 13 (`0x151E6`), shown only when `FF89C4` bit 3 is set. `0xD6` = RAM DISPLAY (doc 32) |
| `0xDB` | `0x66A4` | – | – | pushed at `0x1F7B4` / `sub_3FEFC` (FF90F0 layer) |
| `0xDC`–`0xE7` | `0x676C`.. | – | – | from `0x102F4`/`0x233B0` and table `0x23156` |
| `0xE8`–`0xEC` | `0x682C` F00B, `0x48B2` F002, `0x6914` F000/F001, `0x692C` F009, `0x693A` | – | – | power-on-only screens (`0xE8` = destination editor, doc 50) |

**Ids with table slots but no writer found: 71.** Of these:
- 22 are empty slots: an `rts` notifier, no dial handler and no save;
- 32 have a real save handler, e.g. `0x0E` save R1 `0xA3`, `0x10` save R1 `0x74`, `0x97` save R2
  `0x0B`, `0xB9` save R3 `0x6E`;
- 17 are other partial slots.

Six of the 71 have a notifier that reaches the SUB: `0x38` F364, `0x41` F316, `0x42` F387, `0x5C`
F31A, `0x80` F395 and `0xEE` F008. These are the strongest "orphaned item" candidates.

`screens.tsv` lists them with `status = C(table slot) / NF(writer)`.

### 4. Hand C — the dead F316 item as it would run (Confirmed bytes, nothing invented)

```c
/* screen 0x41: entry */                       /* 0x782C[0x41] = sub_534C */
void f316_notify(void) { sub_976A(0xF316, FF89A9 - 0x13); }
/* screen 0x41: dial */                        /* 0x12268[0x33] = 0x166AA */
static const struct { uint8_t lo, hi; uint8_t *p; } R41 = { 0x13, 0x21, &FF89A9 };  /* 0x166BA */
void f316_dial(void) { step_saturating(&R41); nullsub_36(); }  /* 3F600, 69A6 = rts */
/* screen 0x41: exit (from pop) */             /* 0x19A9E[0x33] -> 0x192C4 */
void f316_exit(void) { eeprom_save_R1(0x89); } /* sub_3CCBC: EEPROM 0x580+0x89 = 0x609 */
```

### 5. Group 13 and the other bytes in the same `FF89C4` family

These are not part of the assignment, but they share the screen model. The hidden **group 13** row
table `0x151E6` holds `b7 d2 d3 d7 d6`. Entry into it is gated at `0x14B04` by `FF89C4` bit 3.

That bit is toggled only by `sub_1645E` (doc 32). The callers of `sub_1645E` are the code-entry
routines that doc 32 and the H11 doc list. This lane does not decode them. A sequence-gated routine
that sets `0xFFBC8A` bit 0 is also one of those callers.

Of the five group-13 rows:
- `0xB7` has an `rts` notifier;
- `0xD2` and `0xD3` share notifier `0x5EA38`, as do the 16 group-2b rows `0xC2`–`0xD1`;
- `0xD6` is RAM DISPLAY;
- `0xD7` has dial `0x190E6`.

They are reachable when the bit is set (Confirmed path). Their labels are outside this lane.

### 6. Corrections to earlier docs

- **H11 `49-key-sequence-hidden.md` F6**, "`FF89B6` 3-state". The record is `{lo 0, hi 3}` with the
  wrapping step, so it holds **4 values `0..3`**.
- **H11 F5/F6** found the sender-table slots but not the dial or exit handlers. This lane adds
  `0x166AA`/`0x192C4` and `0x16B4E`/`0x19312`. These show both items were complete screens that lost
  their menu rows, not stray senders.
- **H11 states "screen `0x0C` = home screen".** That is not supported. `0x0C` is the **setup-menu
  group list**: its notifier sends F300 (the SUB group-list screen `0x1D`), its key table's select
  slot enters a group, and pop treats a previous screen of `0x0C`/`0x0D` as "back to menu".
- **Doc 32 row-code table.** The group labels in `1515c-rowcodes.tsv` are shifted by one. The tables
  map as follows:

  | Table | Contents |
  | --- | --- |
  | `0x1515C` | DISPLAY: `8E 84 68 40 3F 28 51 70 C0` = TARGET LOCATION … SOFTWARE VERSION |
  | `0x15166`/`0x1516A`/`0x15180` | the three group-2 sub-lists |
  | `0x151DA` | SD CARD |
  | `0x151DE` | OPTION |
  | `0x151E4` | group 12 |
  | `0x151E6` | hidden group 13 |

  The `0x1515C` table's trailing `00` is a pad: the clamp at `0x15102` is `00 08` → 9 rows.

## USB relevance

No change to the three mission answers.
- F316 and F31A are dead UI settings that touch no peripheral on either processor.
- The screen model is pure UI dispatch: entry notifier, dial, exit-save and key tables.
- None of the 239 screen ids leads to a USB, sample-streaming or DSP-access path in this analysis.
- The screens that reach the DATA-jack/USB configuration are ordinary menu items, already decoded by
  docs 44/45 (COM PORT SETTING F3B0, USB CAMERA F3D0 = screen `0x87`).

## Open

1. **Writer of `0xFFADA1`**, which feeds the screen byte at `0x6FD1E` with values compared against
   `0x85`/`0x88`/`0x89`. Trace the indirect stores, e.g. base `FFAD8A` + `0x17`. That would close the
   last unresolved screen source; it cannot produce `0x41`/`0x5C` unless it copies a row code.
2. **The 32 orphaned screens with save handlers.** Attribute each one to its R1/R2/R3 byte via doc 32
   and decide whether any byte has a live consumer. A live consumer would make it a hidden-but-active
   setting rather than a dead one.
3. **Purposes of screens `0x01`, `0x02`, `0x09`–`0x0B`, `0xB3`, `0xDB`–`0xE7` and `0xE9`.** Decode
   their notifier opcodes on the SUB (`F0xx`/`F1xx` families) to name them.
4. **The 168 reachable screens' key tables.** Decode them only as handler addresses; the key
   identities stay out of scope.
