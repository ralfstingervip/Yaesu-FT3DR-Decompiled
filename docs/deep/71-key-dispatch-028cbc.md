# 71 — The 0x028CBC key-dispatch family: the touch-panel soft-key / on-screen-keyboard router (Lane J3)

> Lane J3, model `claude-opus-4-8`. Private DB `J3_KEYDISP`, seeded
> `--copy-from ida\db\jobs\MAIN_FINAL2\MAIN_FINAL2.i64`, driven read-only by
> `ida\jobs\j3_keydisp.py` (first pass) and `ida\jobs\j3_keydisp2.py` (one `--reopen`).
> The only DB mutations were local `create_insn` over the ranges this lane decodes; no image
> byte was modified, no other DB opened, nothing connected to a radio. Image
> `decrypted\FT3D_MAIN_ver102_EXP.bin` (MAIN, H8SX, base 0, big-endian, file offset = address).
> Tables: `ida\out\key-dispatch\`. The closed window `0x078106`–`0x07B753` was not entered.

## Verdict

**`0x028CBC` is the FT3D touch-panel soft-key dispatcher, and `0xFFBBC2` holds the on-screen
button index produced by a touch hit-test — not a physical keypad code.** The full chain is:
a touch event delivers a screen coordinate `(X,Y)`; a hit-test routine `sub_26F08` walks the
current screen's rectangle table and writes the matched button's index to the word at
`0xFFBBC2` (0 if no button was hit); later the current screen jumps into one of eight 32-byte
**button-action records** (loaded into `er1`, then `bra 0x028CBC`); `0x028CBC` reads
`0xFFBBC2` and routes the hit button to that record's handler for the pressed field. The
screens that own these records are **alphanumeric data-entry screens** (callsign / memory tag /
message / set-mode string editors): their handlers rotate characters through the lowercase
map at `0x01BE32` (`sub_1A58C`), set up an edit cursor (`0xFFBC7C` pointer / `0xFFBC82` column /
`0xFFBC83` width), scroll the on-screen keyboard, and commit the field (`sub_2A0F6`). The touch
zones span `X = 0..0x13F` (0..319) and `Y = 0x1F..0xEE` (31..238) — the radio's 320×240 panel,
which is the decisive proof. **Nothing in this family touches USB `0xFFEE00`–`0x53`, SCI-C
`0xFFFF88`, or any sample path.** All eight records and every reachable field handler are live
code; the dead parts are field `+0x10` (always 0, reserved) and the `+0x18 = 0x3FFA0` sentinel
("no-op / clear soft-key state"). This lane confirms and names the family; it adds **0 new
proven code bytes** beyond `MAIN_FINAL2` (the +226 of I9 and +54 of I15 for this family are
already in that seed) — the new yield is naming, the record/zone semantics, and identifying
the writer/hit-test functions and the touch-zone data tables.

## Method

1. **Byte scan (Python, offline).** Searched the whole MAIN image for `bb c2`: 88 hits, all
   abs16 references to `0xFFBBC2`. Classified every one by its opcode: 85 are loads
   (`6b 0X bb c2` into r3/r4) or data; exactly **3 are stores** (`6b 8X bb c2`). `bb c3` has 0
   hits, so `0xFFBBC2` is a 16-bit variable written only at those 3 sites.
2. **IDA pass 1** (`j3_keydisp.py`): force-decoded and dumped the dispatcher, the writer
   function, the record region, every field-handler target, and the screen table `0x012268`;
   emitted `anchors.tsv` (xrefs/func for every anchor) and `callers.tsv`. Outputs in
   `ida\out\key-dispatch\work\{disasm.txt,anchors.tsv,callers.tsv}`.
3. **IDA pass 2** (`j3_keydisp2.py`, `--reopen`): parsed the nine event→index lookup tables fed
   to `sub_26F08`, dumped the no-op handler `sub_3FFA0` and the raw-event dispatcher head, and
   pulled xrefs for the screen callers and shared helpers. Outputs
   `work\{disasm2.txt,luts.txt,context.tsv}`; cleaned copy `touch-zone-luts.txt`.
4. **Cross-checks.** Char map `0x01BE32` read directly (`00 61 62 … 7a` = `a`..`z`). Record
   fields and passer sites reconciled against I9 `record-fields.tsv` and I15 `rules-b-records.tsv`
   (agreement, no conflicts).
5. **Not done.** I did not run a descent / ledger diff, so I make no new proven-byte claim. The
   exact physical-key vs touch origin of each raw event code (`0xF3xx`–`0xFDxx`) was not fully
   traced; the hit-test coordinate source in `er2` is confirmed to be `(X,Y)` by the zone
   ranges but the producer that loads `er2` was not walked to the ADC/panel driver.

## Findings

### 1. The dispatcher `0x028CBC` (Confirmed, `work\disasm.txt`)

`0x028CBC 6b 04 bb c2` = `mov.w @0xFFBBC2:16, r4`, then a `cmp.w #k,r4; beq` ladder. The record
is supplied by the caller in `er1`. Mapping of button index `k` → action:

| `0xFFBBC2` (k) | site | action |
| --- | --- | --- |
| 1 | `0x28D72` | `bclr #3,@0xFFBBF1`; `0xFFBC34 := 0` — cursor-mode state, **no field call** |
| 2 | `0x28D54` | `bclr #3,@0xFFBBF1`; toggle `0xFFBC34` 1↔2 — **no field call** |
| 3 | `0x28D4A` | field **+0x0C** |
| 4 | `0x28D3A` | `0xFFA9ED := 4`; field **+0x08** |
| 5 | `0x28D32` | `0xFFA9ED := 6`; field **+0x08** |
| 6 | `0x28D80` | `bset #7,@0xFFAA30`; field **+0x14** |
| 7 | `0x28D90` | field **+0x18** (usually the `0x3FFA0` no-op sentinel) |
| 10..19 (and ≥20 fallthrough) | `0x28CFE`→`0x28D0C` | `r4-=10` → sub-index to `0xFFA9F0`; `0xFFA9ED:=0`; field **+0x00** |
| 0x14 (20), `0xFFBC34==3` | `0x28D18`→`0x28D24` | field **+0x04** |
| 0x14 (20), `0xFFBC34==0` | `0x28D18`→`0x28DA0` | field **+0x1C** |
| 0, 8, 9, other <0x0A | `0x28D9A` | `jsr sub_3FFA0` — no-op / clear |

Each field call is `mov.l @(d:16,er1),er6; jsr @er6; rts`. `sub_28AD2` is a second, smaller
dispatcher of the same shape (keys 6/1) for a sub-context.

### 2. The index source `0xFFBBC2` = touch hit-test (`writers-0xFFBBC2.tsv`, `touch-zone-luts.txt`)

**Writers — exactly three, all in one hit-test helper pair:**

| addr | insn | value | path |
| --- | --- | --- | --- |
| `0x026F3C` | `mov.w r4,@0xFFBBC2` | 0 | `sub_26F08` no-zone-matched |
| `0x026F4A` | `mov.w r3,@0xFFBBC2` | matched zone idx | `sub_26F48` point hit a zone |
| `0x026F6A` | `mov.w r4,@0xFFBBC2` | 0 | `sub_26F08` negative index |

`sub_26F08(er5 = zone table, er2 = X<<16 | Y)`: `r6 = @er5+` (zone count); each zone is 10
bytes `{lo32 = Xmin<<16|Ymin, hi32 = Xmax<<16|Ymax, val16 = button index}`; the first zone whose
rectangle contains `(X,Y)` wins and its `val16` is stored to `0xFFBBC2`. The sibling
`sub_26F9C` does the same into `0xFFBBC4` (a secondary coordinate/hit). The dword `00 FF BB C2`
at file `0x006618` is **data** — one entry in a RAM-variable pointer/save list — not a writer.

**Why it is a touch panel, not a keypad:** the nine parsed zone tables (`touch-zone-luts.txt`)
carry `X` up to `0x013F` (319) and `Y` up to `0xEE` (238) — the 320×240 display. Example
`LUT @0x028452`: five full-width rows (`X 0..319`) in `Y` bands `[31,59] [61,89] [91,119]
[121,149] [151,179]` → indices 1..5. `LUT @0x02706C`: a row of four buttons at
`Y [128,180]`, `X` in `[14,64] [94,144] [174,224] [254,304]` → indices 10..13. `LUT @0x027274`
(19 zones) lays out a full on-screen keyboard (indices 30..45 plus 3). **Value range of
`0xFFBBC2` is therefore 0..~45:** 0 = none; 1..7 control buttons; 10..19 and 30+ = character
grid (sub-index = idx−10 into `0xFFA9F0`); 20 = space/enter region.

### 3. The eight records and their screens (`record-layout.tsv`)

Each record is a 32-byte / 8-dword struct; live fields are `+00/+04/+08/+0C/+14/+18/+1C`,
`+0x10` is always 0. Six records (`0x028B6C, 0x028BB4, 0x028BF0, 0x028C2A, 0x028C62,
0x028C8A`) live inside the shared entry function `sub_28B62`: each is reached by a distinct
`mov.l #rec,er1; bra 0x028CBC` entry label, jumped to from a different screen handler
(`sub_29C38, sub_2B502, sub_289BC, sub_2A8C6, sub_2A95A, sub_2A99E`) whose only references are
`dr_O` pointers from the GUI screen-handler tables in `0x011xxx`–`0x013xxx` (e.g. `0x013EF4,
0x0112A0, 0x01391C, 0x013784, 0x0139A4`). The other two records (`0x0296E8, 0x029712`) are
reached from screen table `0x012860 → 0x02941C` slots 4 and 5, indexed by the screen/mode byte
`0xFFB9E4` (set to 7 at `0x0296D8`), through `sub_29406`.

The handlers are ordinary edit code (`handler-map.tsv`): `sub_1A58C` rotates the character at
the cursor using the `a`..`z` map at `0x01BE32`; `sub_29C70/28A10/2A92E/2A9FE/2B548` set the
edit cursor (`0xFFBC7C` target pointer, `0xFFBC82` column from `0xFFAD68/0xFFAD99/0xFFB3F4`,
`0xFFBC83` field width); `sub_29C40/29C5C` scroll via `sub_75F36/76080`; `sub_2A0F6` commits;
`sub_29732 → loc_1BEF2` enters a chosen character into one of three edit buffers selected by
`0xFFBC34` (`0x1B1D0 / 0x1BCFE / 0x1B352`).

### 4. Live vs dead

- **Live:** all 8 records; all field handlers listed in `handler-map.tsv`; the hit-test pair
  `sub_26F08/26F9C`; the dispatcher and `sub_28AD2`.
- **Inert fields:** `+0x10` (reserved, always 0); `+0x04` is null in 6 of 8 records (live only
  for `0x028B6C` and `0x028BB4`); `+0x18` is the `0x3FFA0` no-op sentinel in 6 of 8 records —
  the button exists on screen but clears state rather than acting.
- `sub_3FFA0` is the universal "clear current soft-key state" helper (≈400 callers across the
  GUI), confirming this is the shared UI input layer, not a special path.

### Corrections / confirmations to I9 and I15

- I15's "key register `0xFFBBC2`, likely a sub-menu or band/mode selector" is **refined**: it is
  a **touch-panel button index from a coordinate hit-test**, value range 0..~45, writers at
  `0x026F3C/4A/6A` inside `sub_26F08/26F48`.
- I9/I15 handler stubs `0x02A924, 0x02A9F4, 0x028C4A, 0x028CAA` are named here as record-local
  field `+0x14`/`+0x1C` thunks for records `0x028C2A`/`0x028C8A` (see `handler-map.tsv`).
- Net new **proven code** beyond `MAIN_FINAL2`: **0** (this lane confirms and names; it did not
  run a descent). Candidates a future typing pass should credit as **data**: the nine touch-zone
  tables (`0x028452, 0x02839A, 0x02843C, 0x02704C, 0x02706C, 0x027096, 0x0271E6, 0x027274,
  0x0270CA`, 10-byte-stride records) and the pointer in the RAM-save list at `0x006618`.

## USB relevance

**None, and it closes a loose end.** The dispatcher keyed on `0xFFBBC2` and every reachable
handler are the touch-UI data-entry layer. Explicit check: none of the writers, the dispatcher,
the eight records, or any field handler falls in USB `0xFFEE00`–`0xFFEE53`, SCI-C `0xFFFF88`, or
the closed window `0x078106`–`0x07B753`. The three mission answers (USB lives on MAIN's
`0xFFEE00` module; no USB-SDR sample path; DSP on SCI-C) are unchanged. This family is the
on-screen keyboard — exactly the kind of input surface that could *drive* a hidden USB/service
menu, but here it only edits display strings and set-mode fields.

## Open

Most valuable first:
1. **Trace the touch-event producer** that loads `er2 = X<<16|Y` and dispatches `0xF3xx`–`0xFDxx`
   raw events (the ladder at `0x026500`/`0x026580`). That reaches the touch-panel/ADC driver and
   would confirm whether any raw event code maps to a hidden/service screen — the one place this
   UI layer could expose something beyond normal operation.
2. **Attribute the eight screens by name** via the GUI screen-handler tables in
   `0x011xxx`–`0x013xxx` and the set-mode label table, so each record is tied to its on-radio
   editor (callsign / memory tag / message / etc.).
3. **Type the nine touch-zone tables and `sub_26F08/26F9C` as a struct family** in a final seed,
   and credit the zone tables as data (byte count to be measured by a descent/typing pass).
