# 49 — MAIN key-sequence state machine and hidden settings (lane H11)

Reconciled 2026-10-03 against `decrypted\FT3D_MAIN_ver102_EXP.bin`. The draft this
file started as was not reviewed when it landed. This pass is **Grok**. The draft
was written as Opus 5.5.

Checked against the image, and changed where the bytes disagreed:

- Screen id `0x0C` is the setup-menu group list (notifier `0x4E24` at slot `0x785C`
  calls `0x9562`, F300), not the home or operating screen. The compare at
  `0x01495C` is that id.
- `FF89B6` is the record `{lo 0, hi 3}` at `0x016B5A` (4 values `0..3`, wrapping
  step at `0x3F628`), not a 3-state value. The F316/F31A dial and exit handlers
  are in F5/F6.
- The `bset` for 0-based index 8 is `0x0149AE`, and for index 10 is `0x014992`.
  Index 0 does not test `FF910A`. The `==0x66600` test is only index 8
  (`0x01499A`) and index 10 (`0x01497E`).
- A wrong key at `0x014A96` clears `FFBC8A` bit 0 only. Bit 7 is not cleared.
- The buffer address typo `0xFF8AD8E` was `0xFFAD8E`.
- The step handlers are screen `0xC0`'s key table (`0x13F54`). The arm does not
  switch that table.

Owner-side, static, read-only analysis of the owner's FT3DR/FT3DE ver 1.02
**MAIN** image (`decrypted\FT3D_MAIN_ver102_EXP.bin`: Renesas H8SX, big-endian,
base 0, so file offset = mapped address). Register page is `0xFFFFxx` reached by
16-bit absolute addressing; I write addresses as the operand shows them
(`@0xFFFF89C1:16` = RAM byte `0xFF89C1`). SUB (`FFC00000`, RX64M) was not opened
in this pass; where F316/F31A rendering matters, doc 44 and H13 already cover it.
No image was modified and nothing was written to any device. This documents the
radio's own built-in behaviour; it describes no security bypass.

Machine tables: `ida\out\keyseq\states.tsv`, `ida\out\keyseq\readers.tsv`
(generator `ida\jobs\h11_gen_tables.py` re-reads **114** cited byte runs from the
`.bin` and aborts on any mismatch — last run `checks ok: 114`). Raw dumps still
on disk: `ida\out\keyseq\h11_d2.txt`..`h11_d12.txt` (job `ida\jobs\h11_dump.py`,
private DB `H11_MAIN` seeded `--copy-from H1_RECOUNT`, `h8sxa`). The `dump.txt`
the draft cited is not in that directory.

## Verdict

The 8-step machine at MAIN `0x01494C`–`0x014AA6` is armed by the KEY-LOCK handler
while the current screen id is `0x0C`. That id is the **setup-menu group list**
(notifier `0x4E24` sends F300), not the home or operating screen (those are
`0x00` and `0x03`–`0x07`; H13). It is **armed** by `sub_1494C` (called only from
the LOCK-key handler `sub_1CF0A`) and advanced by four per-key step handlers
(`0x0149D2`/`0x0149EA`/`0x014A02`/`0x014A1E`). Those handlers are slots in the
key table of screen `0xC0` (SOFTWARE VERSION), not of screen `0x0C`.

Numbering, once: `[0xFF8F2E]` is the **0-based** group index (`sub_298C8` stores
`[0xFFBBC2] − 1`). The **1-based** menu group is that index plus one, which is
H13's row-code map. `0x14D6A[index]` (index 1 is special-cased to the group-2
sub-lists) gives the row table. The four arms are the 0-based compares:

- `[FF8F2E] == 0` (1-based group 1, DISPLAY, table `0x1515C`) → sets `0xFFBC8A`
  bit 4, whose completion sets bit 0 = **two extra SOFTWARE-VERSION digits**
  (`1.0200`; doc 44 F7). No `FF910A` test. Confirmed.
- `[FF8F2E] == 8` (1-based group 9, APRS, table `0x151BE`) → `jsr sub_1645E` =
  `bnot #3,@0xFF89C4` = **toggles the group-13 enable** (doc 23/32), and only if
  `[FF910A] == 0x66600`. Confirmed.
- `[FF8F2E] == 10` (1-based group 11, OPTION, table `0x151DE`) → `jsr sub_16456`
  = `bnot #4,@0xFF89C4` = **toggles RAM DISPLAY enable** (doc 23/32), and only if
  `[FF910A] == 0x66600`. Confirmed.
- `[FF8F2E] == 5` (1-based group 6, table `0x151A0`) → sets `0xFFB0C8 = 1`, which
  the RADIO ID handlers `0x5E3BA`/`0x5E400`/`0x5E44E` test. No `FF910A` test.
  Confirmed.

A wrong key at any step clears **bit 0 only** and sets the counter to `0xFF`. It
does not clear the active flag (bit 7). The four step handlers are key-table
slots; the physical keypad labels for those slots are **Unknown** (the image does
not name them).

Separately, there is a **second, independent** hidden mechanism — a 4-entry
key-code buffer at `0xFFAD8E`..`0xFFAD91` compared against four
fixed 32-bit codes (`0x01020402`, `0x03090309`, `0x07070603`, `0x02060804`) — that
toggles the same `0xFF89C4` feature bits, plus a variant at `0x016528`/`0x01913E`
that sets `0xFFB0C8=1` / requests UI mode `0x16`. These reach the same hidden
features by a typed digit sequence rather than the LOCK-key machine.

F316 (screen `0x41`, "LEVEL 1..15", `0xFF89A9`) and F31A (screen `0x5C`,
`0xFF89B6`) each have a notifier, a dial handler and an exit handler. Neither row
code `0x41` nor `0x5C` appears in the group row-code tables `0x1515C`–`0x151EB`
(re-checked: 0 hits). H13's screen model is the one that enumerates writers of
the screen byte and finds none for these two ids; this note does not repeat that
scan. Where the two overlap, H13 supersedes.

## Method

- Located the machine and its callers by raw pointer scan of the plaintext
  (BE32 handler addresses and `5e xx xx xx` = `jsr …:24`), then disassembled each
  region in `H11_MAIN` with `h11_dump.py` (`range`/`func`/`lin`/`imm`/`xref`).
- Decoded the per-screen key-handler geometry: screen id → 2-byte offset word at
  `0x1208C + 2*(id−1)` → key-handler table at `0x125D4 + word`; 4-byte entries
  per key slot (`0x10EDA`, and the same pair at `0x29AAE`). Screen `0x0C` uses
  base `0x128C0` (word `0x02EC` at `0x120A2`). Screen `0xC0` uses base `0x13F54`
  (word `0x1980` at `0x1220A`).
- Traced the completions' consumers: `0xFFB0C8` readers, `sub_1645E`/`sub_16456`
  (both are single `bnot` on `0xFF89C4`, cross-checked against doc 32/23's
  `0xFF89C4` bit map), and the SOFTWARE-VERSION builder `sub_9CF4` reader of
  `0xFFBC8A` b0.
- F316/F31A: confirmed the sender stubs (`sub_534C`, `sub_56E6`) and their table
  slots (`0x7930`, `0x799C`), then scanned the 15 group row-code sub-tables
  (`0x1515C`–`0x151EB`) and the two ROM screen tables (`0x3BC6`, `0x23144`) for
  `0x41`/`0x5C`.
- **Not done / Unknown:** the physical keypad-label → slot map (the image does
  not name those slots). SUB rendering of RADIO ID / F316 / F31A is doc 44 and
  H13; this pass did not open a SUB database.

## Findings

### F1. The 8-step machine — control flow (Confirmed)

`sub_1494C` is the **arm**; it `rts` at `0x0149D0`. The bytes:

```
01494C 6a10 89c1 7330   btst #3,@0xFF89C1      ; KEY LOCK must be ON
014952 47 7c            beq  0x149D0           ;   else return
014954 6a10 bc8a 7370   btst #7,@0xFFBC8A      ; not already active
01495C 6e0c 0001 ac0c   mov.b @(1,er0),r4l;cmp #0x0C  ; screen id == 0x0C (group list)
014964 fc00 6a8c bc8a   FFBC8A = 0            ; clear state
01496A 6a0c 8f2e        mov.b @0xFF8F2E,r4l    ; sel = current menu group index
01496E ac05 … ac00 … ac08 … ac0a              ; sel in {5,0,8,10}?
0149BE 6a18 bc8a 7030   sel==5  -> bset #3 FFBC8A   (completion -> FFB0C8=1)
0149B6 6a18 bc8a 7040   sel==0  -> bset #4 FFBC8A   (completion -> ext version)
0149AE 6a18 bc8a 7050   sel==8  -> bset #5 FFBC8A   (completion -> sub_1645E)   [needs [FF910A]==0x66600]
014992 6a18 bc8a 7060   sel==10 -> bset #6 FFBC8A   (completion -> sub_16456)   [needs [FF910A]==0x66600]
0149C4 6a18 bc8a 7070   bset #7 FFBC8A  (ACTIVE)
0149CA fc08 6a8c bc8b   FFBC8B = 8      (step counter, counts DOWN)
0149D0 rts
```

So the **gating** is: (a) KEY LOCK on (`0xFF89C1` bit 3; default `0x11` so bit 3
is *not* default-set — it is toggled on by pressing the LOCK key, see F2);
(b) not already active (bit 7 set returns at `0x01495A`); (c) screen id `0x0C`,
the setup-menu group list, not the operating screen; and (d) `[0xFF8F2E]` is one
of `{0, 5, 8, 10}` (0-based; see the verdict for the 1-based names). Index 8 and
index 10 also require the dword at `[0xFF910A]` to equal `0x66600`
(`cmp.l` at `0x01499A` and `0x01497E`; `bne` back to the `rts` otherwise). Index
0 and index 5 do not read `FF910A`. That immediate occurs nowhere else in the
image, and there is no abs16 writer of `FF910A`. The address `0x66600` itself is
the byte `ac 3b` (`cmp.b #0x3B`) inside an existing compare chain, not a screen
object, so the draft's "right menu screen is open" reading is not supported.

The **step handlers** are four separate functions, each gated on `btst #7,FFBC8A`
(active) and a specific value of the counter `FFBC8B`, then they decrement it
(`0x014A8A`: `dec.b r4l; FFBC8B=r4l; jsr sub_3FFA0`). A wrong key →
`0x014A96 bclr #0,@FFBC8A` (`6a 18 bc 8a 72 00`), `FFBC8B=0xFF`, `jsr sub_14BBA`.
That clears bit 0 only. Bit 7 stays set. The only abs16 store of zero to
`FFBC8A` is the arm's `fc 00` at `0x014964` and the `mov.b r4l,@FFBC8A` at
`0x014966`. The branch at `0x01495A` skips that pair when bit 7 is already set.
No abs16 `bclr #7` of this byte exists.

| handler | key-table slot | expects FFBC8B | bytes |
| --- | --- | --- | --- |
| `0x014A02` | slot 8 | 8, 3, 2 | `6a10bc8a7370` then `ac08/ac03/ac02` |
| `0x014A1E` | slot 5 | 7, 4, 1 (1 = complete) | `6a10bc8a7370` then `ac07/ac04/ac01` |
| `0x0149D2` | slot 6 | 6 | `6a10bc8a7370` then `ac06` |
| `0x0149EA` | slot 1 | 5 | `6a10bc8a7370` then `ac05` |

Reading the counter 8→1, the **required key sequence** (by key-table slot) is:

```
counter: 8  7  6  5  4  3  2  1
slot:    8  5  6  1  5  8  8  5
```

These four slots are entries of screen **`0xC0`**'s key table (base `0x13F54`,
offset-table index `0xBF` because the word is indexed by `id−1`): slot1→`0x149EA`
at `0x13F58`, slot5→`0x14A1E` at `0x13F68`, slot6→`0x149D2` at `0x13F6C`,
slot8→`0x14A02` at `0x13F74` (also slot9→`0x15948`, slot `0x0D`→`0x15E1E`,
slot `0x10`→`0x148CA`). No other screen's key table points at the four step
handlers. Screen `0x0C` uses a different table (base `0x128C0`; slot 3 is
`sub_14AF4`, which enters the highlighted group). `sub_1494C` does not store a
new screen id and does not call `sub_3FF10`, so arming does not make the `0xC0`
table active. The selector at `0x10EDA` / `0x29AAE` follows the current screen
id and does not read `FFAAE0`. Screen `0xC0` is the SOFTWARE VERSION row (notifier
slot `0x7B2C` = `0x5E9C0`, F31B; row `0xC0` is index 8 of `0x1515C`). It becomes
current by that row, not by the arm.

`FFAAE0 = 0x16` is written by the index-8 and index-10 arms (`0x01498E`,
`0x0149AA`) and by the bit-3 and bit-4 completions (`0x014A78`, `0x014A6A`).
Three readers (`0x2D5BA`, `0x2E1AC`, `0x33F3E`) compare the byte with `0x16` and
`beq` to an `rts`, which skips the screen-restore that follows. That is not a
push of screen `0xC0`.

The keypad scanner `sub_100E4` (`0x100F8` reads the active-low column at `@0x4C`)
maps `0x7E→0x0E, 0x7D→0x11, 0x7B→0x0A, 0x77→0x0F, 0x6F→0x0D, 0x5F→0x0C,
0x3F→0x12` (Confirmed at `0x10108`–`0x1012E`). Which of those codes selects slots
1/5/6/8 was not re-derived here. The **physical labels for those slots are
Unknown**.

### F2. The LOCK-key entry and the "ticker" (Confirmed)

`sub_1494C` has exactly one caller: `sub_1CF0A` (`0x01CF3A jsr sub_1494C`).
`sub_1CF0A` is the **KEY-LOCK key handler**: `0x1CF0A bnot #3,@0xFF89C1` (toggle
LOCK), `jsr sub_193B2` (persist, `#0xA1`→`sub_3CCBC`), set a UI-mode request in
`0xFFAAE0` (`0x23`/`0x24` by LOCK state), `0xFF9548=0x64`, then `jsr sub_1494C`,
then `bset #1,@0xFF817E`. `sub_1CF0A`'s only caller is `sub_32AC` (`0x0032B4 jsr
sub_1CF0A`; one `jsr` in the image). `sub_32AC` runs when `[FF9536] < 0x46`
(`0x32B0 cmp.b #0x46` / `bcc` skips the call). It is the `[FFA9E0] == 2` slot of
the pointer table at `0x3272` (`0x327E`, `0x328A`, `0x329C`), not a 4-wide table
and not a compare against `0x4644`. The arm sees bit 3 after the `bnot`, so it
runs only on the press that turns LOCK on, and only if the screen id is still
`0x0C`.

`0xFF89C1` is initialised to `0x11` at `0x00E666` (`fc116a8c89c1`) — bit 3 clear
by default. Bit 3 is toggled only by `bnot` at `0x1CF0A` and `0x17778` (the
generic bit toggler reached from the config/entry-code path), and is read as the
gate at `0x1494C`, `0xFED0`, `0x10C40`, `0x22562`, `0x38442`, `0x55414` — i.e. the
same LOCK flag also conditions normal key handling elsewhere. (Bit 0, default
set, is MEMORY WRITE = NEXT, F335; bit 2 is MEMORY PROTECT, F333 — doc 44 F3.)

### F3. The four completions and their consumers (Confirmed)

At `0x014A36`, when the sequence completes (`0x014A32 cmp #1` on the step counter
reached in `0x014A1E`), the code tests `FFBC8A` bits 3/4/5/6 in order:

| armed bit | completion site | effect | consumer (reader) |
| --- | --- | --- | --- |
| b4 | `0x014A62` `bset #0,FFBC8A` | **extended SW-VER digits** | `sub_9CF4` SW-VER frame builder `0x9D18 bld #0,@0xFFBC8A` → `+0x20`; SUB draws `1.0200` (doc 44 F7) |
| b3 | `0x014A70` `FFB0C8 = 1` | **RADIO ID edit/save unlock** | `0x5E3BA`,`0x5E400`,`0x5E44E` (all `mov.b @0xFFB0C8; cmp #1`) |
| b5 | `0x014A5C` `jsr sub_1645E` | **toggle group-13 / spare menu** | `sub_1645E = bnot #3,@0xFF89C4`; read `0x14B08` (enable 1-based group 13, doc 23/32) |
| b6 | `0x014A56` `jsr sub_16456` | **toggle RAM DISPLAY enable** | `sub_16456 = bnot #4,@0xFF89C4`; read `0x2998C`/`0x14EF2`, carried to SUB by `sub_7C20` `bld #4` (doc 23/32) |

After any completion, `0xFFAAE0 = 0x16` (UI mode = menu/settings) and
`0x014A7C bset #1,@0xFF817E`.

**`0xFFB0C8` meaning (service / RADIO ID page).** It is set only at `0x014A72`,
`0x016538`, `0x01654E`, all `=1`. Its readers are the RADIO ID CHECK page handlers
on the dedicated screen (key table at `0x13690`, which is the F363 "RADIO ID
CHECK" page): key 4 → `0x5E3BA`, key 5 → `0x5E44E`, key 6 → `0x5E3BA`, key D →
`0x5E3FA`. When `FFB0C8==1`:
- `0x5E418` allows **editing** the 5 ASCII characters of the radio ID at
  `0xFF8060` (validated 0-9/A-Z/a-z at `0x5E432`–`0x5E448`);
- `0x5E45C jsr sub_39576` **commits** the block: `sub_39586` sets `er0=0x40`
  (64 bytes), `er1=0xFF8016` source, then `sub_3AD20` `bset #0,@0xFFFFFBA4` — an
  EEPROM/clone write trigger (persists the identity block).

When `FFB0C8==0` these handlers fall through to `sub_3FFA0`/`sub_14BBA` (no edit,
no save). So completion b3 **unlocks writing the radio-ID / identity block** — a
service/engineering function. (Inferred that this is the "RADIO ID"/MY CALL
service page; the SUB-side title render is SUB scope.)

### F4. Second, independent hidden mechanism — the 4-code buffer (Confirmed)

A 4-byte key buffer at `0xFFAD8E`..`0xFFAD91` (addr `0xFFAD8E`) is filled on
certain screens (the fill/compare loops at `0x016400`, `0x016500`, `0x019110`
walk 4 entries). At `0x016420` it is read as a 32-bit word and compared:

```
016420 01006b04 ad8e            mov.l @0xFFAD8E,er4
016426 7a24 01020402  == -> sub_1645E   (bnot #3 FF89C4 = group 13)
01642E 7a24 03090309  == -> sub_16456   (bnot #4 FF89C4 = RAM DISPLAY)
016436 7a24 07070603  == -> 0x1644E bnot #2 FF89C4  (b2: default-set, no reader — doc 32)
01643E 7a24 02060804  == -> 0x16446 bnot #1 FF89C4  (b1: feature flag — doc 32)
```

A separate screen variant (gated by a long chain of fixed menu-field values at
`0x01647A`+) matches buffer `0x04030708` at `0x016528` and sets `FFB0C8 = 1`
(`0x016536`); another (`0x019100`, when UI word `[0xFF8F2C]==0x10`) matches
`0x08030706` at `0x01913E` and requests UI mode `0x16`. These are typed-digit
back doors to the **same** hidden features as the LOCK-key machine. (The entry-code
toggles `0xFF89C4` persist via `sub_193CA` = `sub_3CCBC(#0xA4)`, doc 32.)

### F5. F316 / screen `0x41` "LEVEL 1..15" — handlers (Confirmed)

`sub_534C` (`0x0534C`) is the F316 sender: `mov.b @0xFF89A9,r3l; #0x13 sub;
mov.w #0xF316; jsr sub_976A` — it sends `[0xFF89A9] − 0x13`. `0xFF89A9` default
is `0x19` (init `0x00E58C fc196a8c89a9`), so default value sent = 6 → SUB draws
"LEVEL 7" (doc 44). Notifier slot `0x782C + 4·0x41 = 0x7930` = `0x0000534C`.
Callers index that table by `@(1,er0)` (`0x0481C`, `0x04DE4`, `0x06C6E`, `0x06E92`).

The dial and exit the draft did not name are the screen-`0x41` slots (id − `0x0E`
= `0x33`):

- Dial `0x12268 + 4·0x33 = 0x12334` = `0x166AA`: `mov.l #0x166BA,er6; jsr sub_3F600;
  jsr 0x69A6; rts`. `0x69A6` is `54 70` (rts). The record at `0x166BA` is
  `13 21 00 ff 89 a9`, i.e. `{lo 0x13, hi 0x21, ptr 0x00FF89A9}`. `sub_3F600`
  saturates: already at `hi` going up, or at `lo` going down, consumes the key
  and returns the byte unchanged (`0x3F610`–`0x3F626`). Otherwise it falls into
  `0x3F628`. Fifteen values, `0x13`..`0x21`.
- Exit `0x19A9E + 2·0x33 = 0x19B04` holds `4A 24`; `sub_19158` adds `0x148A0`,
  which is `0x192C4`: `mov.w #0x89,r1; jmp sub_3CCBC` (R1 n=`0x89`, the EEPROM
  save doc 32 already records).

Row code `0x41` is absent from `0x1515C`–`0x151EB` (re-checked, 0 hits). The
abs16 sites of `FF89A9` are the sender read at `0x534C` and the init store at
`0xE58C`; the dial reads the byte through the record pointer, not as abs16.
H13 is the writer enumeration for the screen id. This was a complete item
(notifier, dial, exit) whose row is not in the menu tables.

### F6. F31A / `0xFF89B6` — four values, not three (Confirmed)

`sub_56E6` (`0x56EA mov.b @0xFF89B6,r3l`) is the F31A sender
(`mov.w #0xF31A; jsr sub_976A`). Notifier slot `0x782C + 4·0x5C = 0x799C` =
`0x000056E6`. Row code `0x5C` is absent from `0x1515C`–`0x151EB` (same scan).
Doc 44 / H13: the SUB slot for code `0x1A` is `rtsd`, so it is not drawn. This
pass did not open SUB.

The dial and exit:

- Dial `0x12268 + 4·0x4E = 0x123A0` = `0x16B4E`: `mov.l #0x16B5A,er6; jsr 0x3F628;
  rts`. The record at `0x16B5A` is `00 03 00 ff 89 b6` = `{lo 0, hi 3, ptr
  0x00FF89B6}`. `loc_3F628` **wraps**. Direction is `FFA9EE` bit 0. Going up
  (`0x3F636`–`0x3F654`), `v >= hi` stores `lo` (`mov.b r4h,r3l` at `0x3F646`,
  after `cmp.b r3l,r4l`); otherwise it increments. Going down (`0x3F656`–`0x3F674`),
  `v <= lo` stores `hi` (`mov.b r4l,r3l` at `0x3F666`); otherwise it decrements.
  The legal values are `0, 1, 2, 3`. Not a 3-state value. What those four values
  mean is **Unknown** (no other MAIN consumer than the sender and this editor;
  SUB does not draw the frame).
- Exit `0x19A9E + 2·0x4E = 0x19B3A` holds `4A 72` → `0x148A0 + 0x4A72 = 0x19312`:
  `mov.w #0x96,r1; jmp sub_3CCBC`.

Same shape as F316: a complete screen whose row is missing. H13 supersedes the
screen model.

### F7. Hand-written C — the machine (Confirmed from the bytes)

```c
/* keyslot = index in screen 0xC0's key table (base 0x13F54; offset index 0xBF).
   The scanner codes in sub_100E4 are not re-mapped to those slots here.
   State bytes: FFBC8A (flags), FFBC8B (step counter).
   FF8F2E is the 0-based group index; 1-based group = FF8F2E + 1. */

/* Called from the LOCK-key handler sub_1CF0A, which first toggles FF89C1 bit 3. */
void keyseq_arm(screen_t *scr)                      /* sub_1494C */
{
    if (!(FF89C1 & 0x08)) return;                   /* KEY LOCK must be ON      */
    if (FFBC8A & 0x80)    return;                   /* not already active       */
    if (scr->id != 0x0C)  return;                   /* setup-menu group list    */

    FFBC8A = 0;
    switch (FF8F2E) {                               /* 0-based group index      */
    case 0:  FFBC8A |= 0x10; break;                 /* 1-based group 1, ver digits */
    case 5:  FFBC8A |= 0x08; break;                 /* 1-based group 6, FFB0C8  */
    case 8:  if (FF910A != 0x66600) return;         /* 1-based group 9 (APRS)   */
             FFAAE0 = 0x16; FFBC8A |= 0x20; break;  /* -> sub_1645E (group 13)  */
    case 10: if (FF910A != 0x66600) return;         /* 1-based group 11 (OPTION)*/
             FFAAE0 = 0x16; FFBC8A |= 0x40; break;  /* -> sub_16456 (RAM DISPLAY)*/
    default: return;
    }
    FFBC8A |= 0x80;                                 /* ACTIVE */
    FFBC8B  = 8;                                    /* step counter, counts down */
}

/* One of four per-key handlers. They run only while screen 0xC0 is current.
   Each checks the active flag and that the counter is where that key is due. */
void keyseq_step(int keyslot)                       /* 0x149D2/EA, 0x14A02/1E */
{
    if (!(FFBC8A & 0x80)) { keyseq_reset(); return; }
    switch (keyslot) {
    case 8: if (FFBC8B==8||FFBC8B==3||FFBC8B==2) break; else {keyseq_reset();return;}
    case 1: if (FFBC8B==5) break;                   else {keyseq_reset();return;}
    case 6: if (FFBC8B==6) break;                   else {keyseq_reset();return;}
    case 5: if (FFBC8B==7||FFBC8B==4) break;
            if (FFBC8B==1) { keyseq_complete(); return; }
            else {keyseq_reset();return;}
    }
    FFBC8B--;                                       /* 0x14A8A */
    consume_key();                                  /* sub_3FFA0 */
}
/* Required order (counter 8..1): slots 8,5,6,1,5,8,8,5 */

void keyseq_complete(void)                          /* 0x14A36 */
{
    if      (FFBC8A & 0x08) { FFB0C8 = 1;  FFAAE0 = 0x16; }      /* RADIO ID unlock */
    else if (FFBC8A & 0x10) { FFBC8A |= 1; FFAAE0 = 0x16; }      /* ext SW-VER digit */
    else if (FFBC8A & 0x20) { sub_1645E(); }                    /* bnot FF89C4 b3   */
    else if (FFBC8A & 0x40) { sub_16456(); }                    /* bnot FF89C4 b4   */
    FF817E |= 0x02;  FFBC8B = 0;                     /* 0x14A7C/0x14A84 */
}

void keyseq_reset(void)                             /* 0x14A96 */
{
    FFBC8A &= ~1;  FFBC8B = 0xFF;  redraw();         /* bit 7 is NOT cleared */
}
```

## USB relevance

None of this touches USB, the DSP bus, flash self-programming, or any peripheral
register. The four completions flip RAM feature flags that the normal menu
(`0xFF89C4`) and the SOFTWARE-VERSION / RADIO-ID display pages read. The one
completion that persists anything is the RADIO ID unlock (`0xFFB0C8=1`), which
only lets the user edit and save the 5-character identity block to the existing
EEPROM/clone store via `sub_39576` — no new data path. For mission questions 1–3
the answer is unchanged: this is UI/service state on MAIN, not a transport.

## Open (most valuable first)

1. **Physical keypad labels for slots 1/5/6/8.** Unknown. The image does not name
   those slots, and this pass did not take labels from a photo or a schematic
   that is not in the tree.
2. **How screen `0xC0`'s key table becomes current.** Confirmed as far as the
   bytes above: the arm does not select it, and `FFAAE0 == 0x16` does not push
   it. The row `0xC0` sits in the 1-based group-1 table. Anything past that
   ordinary row open was not followed. Not a new coverage lane.
3. **SUB rendering of RADIO ID / F316 / F31A.** Not re-opened. Doc 44 and H13
   already cover it (F316 drawn as LEVEL; F31A's SUB slot is `rtsd`). No SUB
   database was opened.
4. **`[FF910A] == 0x66600`.** Narrowed, not identified. Both compares are real
   and are the only uses of that immediate and of abs16 `FF910A`. The constant
   is a code address (`ac 3b` at `0x66600`), and nothing abs16-writes the dword.
   It is not shown to be the APRS or OPTION settings page.
5. **`0xFF89C4` bits 0/2/5–7.** Not re-scanned. Doc 32 still lists those bits as
   no reader found. The 4-code buffer's `bnot` of bit 1 (`0x16446`) and bit 2
   (`0x1644E`) are unchanged; bit 2's readers stay Unknown.
