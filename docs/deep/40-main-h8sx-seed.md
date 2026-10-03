# MAIN H8SX seed database (MAIN_H8SX)

> Lane H2. Private DB `MAIN_H8SX` (`ida\db\jobs\MAIN_H8SX\MAIN_H8SX.i64`), seeded with
> `--copy-from ida\db\jobs\G1_H8S\G1_H8S.i64`. Reference copy `H2_REF` (seeded from `MAIN_FULL`) was used
> only for read-only measurement. `H2_TEST` is a throwaway copy of the seed used for trial and stability
> runs. No other database was opened. Image: `decrypted\FT3D_MAIN_ver102_EXP.bin` (base 0, so file
> offset = address). No image was modified. Nothing was connected to or written to a radio.
> Model: claude-opus-5-5 (Claude Opus 5.5).
> Tables: `ida\out\h8sx-seed\` (`changes.tsv`, `stats.tsv`, `f1_true_starts.tsv`,
> `table-xrefs-h8sx.tsv`, `table-xrefs-excluded.tsv`; intermediates in `work\`, filter in `offline\`).

## Verdict

**Use `ida\db\jobs\MAIN_H8SX\MAIN_H8SX.i64` as the MAIN seed.** Copy it with
`--copy-from ida\db\jobs\MAIN_H8SX\MAIN_H8SX.i64`. It is processor `h8sxa`, with one segment
`ROM 0x000000-0x100000`. The reset vector is `0x2092`, the same layout as MAIN_FULL (Confirmed).

- **H8SX decode (Confirmed):** all 663 G1 tier-A/B sites are code at their planned length, including all
  246 `MOV.L @(d:32,ERs),ERd`. The H8SX module `0x075F36`–`0x078105` is 8,656/8,656 B code. All 164 G1
  functions are present, and none of the 44 removed ones has come back.
- **Odd-aligned code is gone:** 0 odd code heads, against 1,466 in G1_H8S and 1,501 in MAIN_FULL.
- **F1 corrections applied:** all six F1 corrections are in the DB. The pass also moved 87 more function
  starts that lay inside data to their table-proven entry.
- **Table cross-references:** 3,888 of G2's 4,194 table→target xrefs are applied. The other 306 come from
  data tables that were mistaken for jump tables.
- **Survival:** 368 of the 444 F1 indirect functions keep a function start plus an incoming xref. G2 got
  261 under h8s300a. A second apply plus re-analysis is a fixed point: 0 code bytes and 0 functions
  change outside the closed window.
- **Closed window `0x078106`–`0x07B753`:** its item list is byte-identical to G1_H8S, with 152 heads and
  318 B of code. Auto analysis would change 57 heads there, so this lane reverted those changes.
- **Names and comments:** all 14 user names and 49 comments carried over.

## Method

The steps below were run in this order. Every IDA step went through `python ida\run_job.py --script
ida\jobs\<job> --db MAIN_H8SX --reopen`; only the first step was a `--copy-from`.

1. **`h2_dump.py`, seeding the DB.** Seeded `MAIN_H8SX` from G1_H8S with `H2_TAG=g1`, and `H2_REF` from
   MAIN_FULL with `H2_TAG=full`. The dump is read-only. It writes processor, segments, entries, code and
   data bytes, odd heads, functions, names, comments, the window item list with its SHA-1, and
   proved-row status to `work\<tag>_*`.
2. **`h2_fix.py`.**
   - Re-checks `h8sxa`.
   - Verifies G1's absorption against `h8s-decode\sites.tsv` and `absorbed.tsv`.
   - Applies the F1 corrections.
   - Deletes every odd-aligned code head outside the window, and any function that starts on an odd
     address.
3. **`h2_tclass.py` and `offline\build_xref_filter.py`.** Classify each G2 table row against the DB:
   slot state, and whether the target is a code head, inside an instruction, data, ASCII, or does not
   decode. Bad rows and data tables are dropped (Finding 4).
4. **`h2_xref.py`.**
   - Snapshots the window.
   - Applies `table-xrefs-h8sx.tsv` with `g2_apply_table_xrefs.apply_from_tsv`, unchanged. It runs twice:
     the second pass picks up targets that were orphaned when a slot overwrote a function starting
     inside it.
   - Runs `plan_range(0x400, 0x078106)` and `auto_wait`.
   - Restores the window to its snapshot.
   - Measures survival at each stage.
5. **`h2_text.py`.** Corrects the text extents around the two ASCII-led rows.
6. **`h2_entry.py`.**
   - Moves F1 rows whose start has no reference to the table target that F1 itself recorded
     (`inside->X`). This applies when `X - row <= 8`, or when the bytes in between were read and are data.
   - Then a generic pass does the same for any function that starts in the low half of a pointer-like
     BE32 constant.
7. **Checks.**
   - `h2_fix.py` again, as a re-verification.
   - `h2_dump.py` with `H2_TAG=seed_final`.
   - `h2_xref.py` on a fresh `H2_TEST` copy of the final seed, as a stability check.

Scope and limits:

- Re-analysis covered `0x000400`–`0x078105`.
- The window was never analysed. Any change auto analysis made there was reverted.
- No new names were created. No window protocol was read.
- `inf start_ea` is unset (`BADADDR`), as it was in MAIN_FULL. The reset entry is the `reset_handler`
  entry point.

## Findings

### 1. Layout matches MAIN_FULL (Confirmed, `work\full_meta.txt` vs `work\seed_final_meta.txt`)

| Item | MAIN_FULL | G1_H8S | MAIN_H8SX |
| --- | --- | --- | --- |
| processor | `h8s300a` | `h8sxa` | `h8sxa` |
| segments | `ROM 0x0-0x100000`, CODE, 32-bit | same | same |
| BE32 @ 0 | `00002092` | same | same |
| entries | `reset_handler 0x2092`, `nmi_handler 0x267C` | same | same |

### 2. G1's H8SX absorption is intact (Confirmed by `h2_fix.py` verify, `work\verify3_log.txt`)

- 663 of 663 A/B sites are code heads of the planned length; 246 of 246 are MOV.L @(d:32).
- The module has 0 non-code bytes of 8,656.
- 164 of 164 new functions are present, and 44 of 44 removed functions are absent.
- These held before and after every step.

### 3. F1 corrections (`f1_true_starts.tsv`, `changes.tsv` phase `fix`/`text`)

| F1 row | True entry | Evidence (bytes from the image) | Action |
| --- | --- | --- | --- |
| `034644` | `0x034538` | `0x002CA8` and `0x0038BA` = `5e 03 45 38` (jsr). `0x034642` = `78 b0 6b 26 00 03 46 74` (MOV.L, call table `0x034674`). Body ends `rts` at `0x034672`. | `add_func` → `0x034538`–`0x034674`. It was code with no function in G1. |
| `038104` | `0x0380EA` | `0x030D90` = `5e 03 80 ea`; contains `0x038102` = `78 b0 6b 26 00 03 81 8e` | already fixed by G1; verified |
| `04F3A4` | `0x04F390` | `0x04F340` = `5e 04 f3 90`; contains `0x04F3A2` = `78 b0 6b 26 00 04 f3 e4` | already fixed by G1; verified |
| `06AC14` | `0x06AB68` | `0x06AB04` = `5e 06 ab 68`. 8-way `jmp @er6` table `0x06AC3A`; every case joins `0x06AC0C`; `rts` at `0x06AC38`. `0x06AC12` = `78 c0 6b 24 00 04 36 a6`. | Deleted bogus `sub_6AB5C` (3 chunks), which started on the text `"NEW       "` (`4e 45 57 20…`, `ff 00`). That text is the source of `eepmov.w` with `r4 = 10` at `0x06AB46`–`0x06AB52`. Made a 10 B string and the word `0xFF00`. Redefined `sub_6AB68` as `0x06AB68`–`0x06AC3A`. |
| `04DE6E` | `0x04DE94` | `0x04DE26` = word `000E`; `0x04DE28` = `"Height    -m "+FF`; `0x04DE36` = `"Height    -ft"+FF`; `0x04DE44`–`0x04DE93` = 20 four-char fields (`"   3"`…`"1561"`, `"  10"`…`"5120"`), read by `0x04DE0A mov.l @(0x4DE44:32,er3),er4`. Entry `7a 05 00 04 de e2`. | 33 text items (14+14 B labels plus 4 B fields) |
| `04DF72` | `0x04DF98` | `0x04DF60` = `000E`; `0x04DF62` = `"A-Dir     -" 06 20 FF`; `0x04DF70`–`0x04DF97` = 10 fields `"omni"`, `"  45"`…`" 360"`, `"   -"`, read by `0x04DF3A mov.l @(0x4DF70:32,er3),er4`. Entry `7a 05 00 04 e0 10`. | (as above) |

**Correction to G1/F1 (Confirmed):** the ASCII runs are not 38 B starting at the F1 row. The rows start
in the middle of a 4-char field.

- The value tables are `0x04DE44`–`0x04DE93` (80 B) and `0x04DF70`–`0x04DF97` (40 B).
- Each table is preceded by its 14 B labels.
- The step-2 38 B strings were superseded by the step-5 field items (`changes.tsv` rows `fix make_string`
  at `04DE6E`/`04DF72`).

These look like the APRS/WX "Height" and antenna-direction value lists. That is Inferred from the text.

### 4. Table→target xrefs: 306 of G2's 4,194 rows are not code pointers (`table-xrefs-excluded.tsv`)

When G2's TSV is applied as-is, the `del_items` on each slot destroys real code in two places, and it
creates functions on ASCII. Excluded:

| Table(s) | Rows | Evidence | Status |
| --- | ---: | --- | --- |
| `0x00F020`–`0x00F674` (19 tables) | 268 | One block of 32-bit records: `0x00F040` = `0000 0957 5000 0957 5000 …`, `0x00F0A0` = `…0002 1440 0000 1460 … 0000 4300 0000 4400`. Targets include `0x4400`/`0x4200` = `20 20 20 20…` (ASCII) and `0x2220`/`0x1080`, which fall mid-instruction. | data (Inferred for the block; ASCII and mid-instruction targets Confirmed) |
| `0x01DE24` | 10 | `00000500 00000625 00000800 00001000 00001250 00001500 00002000 00002500 00005000 00010000 00000900 00020000` at `0x01DE1C`. This is the 5 / 6.25 / 8.33 / 10 / 12.5 / 15 / 20 / 25 / 50 / 100 / 9 / 200 kHz step list (cf. doc 38's 13-entry SUB step table). | data (Confirmed bytes; meaning Inferred) |
| `0x035320` | 3 | `00001370 00002220 00004200`; `0x4200` is ASCII spaces | data (Confirmed) |
| `0x037D8C` | 3 | `0001010A 00012B4A 00072000` then `210c 2211 234b` | data (Confirmed) |
| `0x04B470`, `0x04B6B8` | 8 | The slots are code: `6e e4 00 01 6e e4 00 02 …` = `mov.b r4h,@(n:16,er6)` inside `sub_4B378`/`sub_4B5B6`. Targets `0x016EE4`/`0x026EE4`/`0x036EE4` are bytes, not pointers. | data misread from code (Confirmed) |
| row-level | 14 | 5 rows of `0x04AB70` → `0x04E2D6` (mid-instruction in the DB), 1 of `0x034674` → `0x034CCE` (mid-instruction), 8 rows of `0x02C110`/`0x02C1CC` whose targets are nested pointer data (`0003ffa0`) | not applied (Confirmed state) |

Consequence for F1 (Inferred): F1 proved three functions only through these data tables. They are
`0x000760` (via `0x00F020`), `0x001740` (via `0x00F068`) and `0x000800` (via `0x01DE24`). Their "reach"
evidence is a numeric coincidence. They stay as functions in the seed, but with no table xref.

### 5. Function-start corrections beyond F1's six (`changes.tsv` phases `xref`/`entry`)

The same fault recurs. An IDA/F1 function starts 2–8 bytes before its real entry, on data. When the slot
is made a dword, or when the start is moved, the table-proven entry becomes the function.

- **28 F1 rows fixed when slots were applied.** 26 started inside the last slot of a table; for example,
  F1 `016596` sits on `0x016594` = `0001 65c0`, and the true entry is `0x016598`. The other two are
  `002D2C`, which is the table at `0x002D2C` itself, and `03CFE6`, a `00 00` pad before `0x03CFE8`. The
  table targets were promoted by the second apply pass.
- **64 F1 rows moved by `h2_entry.py`.** For 58 of them `X − row ≤ 8`; e.g. `015F02` sits in
  `00ff 8993`, a RAM pointer at `0x015F00`, and the entry is `0x015F04`. The other 6 were allowed after
  their bytes were read as data:
  - `005798`: 5-byte records `a0 81 87 e3 e8…`;
  - `00589A`: a numeric table;
  - `01682E`: `8000 c000 e000 …` masks;
  - `04E320`: `"Baro     -hPa"+FF`;
  - `04E538`: `"Gust     -mph"+FF`;
  - `051694`: `"---------"+FF`.
- **6 by the generic pass**: `018CB8`, `018E6C`, `024154`, `02ACA8`, `034960` (6 B of `00 00` pad) and
  `06D01A`. Each moved to a table-slot target; for example, `06D01A` sat in `00ff 8de2`, and the entry is
  `0x06D01C`, referenced from `0x0111A0`/`0x0115E0`/`0x011888`.
- **Not applied, listed:** `050A3C` (+16; the gap bytes look like code). Also `05BBD8`, `05FFB4` and
  `06F586`, where an item between the start and the target is itself referenced.

### 6. Odd-aligned heads (`changes.tsv` phase `fix`, 49 runs)

- 1,466 heads (3,032 B) were deleted, and one odd-start function, `0x06B681`.
- The deleted heads are concentrated in `0x06Dxxx` (1,028), `0x06B4xx`–`0x06C6xx` (254), `0x025xxx`
  (164), `0x020xxx` (14) and `0x023xxx` (6).
- None had an incoming cref from an even address.
- They overlay data, such as the byte table at `0x06D1E6` referenced from `0x05C7FC`, or real even code.
  H8 instruction fetch is word-aligned, so every odd head is impossible (Confirmed by ISA). Re-analysis
  re-created none of them.

### 7. Stage measurements and survival (`work\seedxref_log.txt`, `work\stab_log.txt`)

| Stage | Code bytes | Functions | Proved rows: start+xref / entry-aware |
| --- | ---: | ---: | --- |
| G1_H8S copy | 391,452 | 4,019 | 27 / – |
| after `h2_fix` (odd −3,032 B, text −82 B) | 388,338 | 4,018 | 31 / 31 |
| xrefs applied (2 passes; +975 / +12 functions) | 388,944 | 5,003 | 273 / 301 |
| auto analysis `0x400`–`0x078105` (+18 functions, 0 removed; window reverted) | 390,528 | 5,021 | 275 / 303 |
| `h2_text` (−80 B of junk code over the labels) | 390,448 | 5,021 | 275 / 303 |
| `h2_entry`: 64 + 6 moves (−248 −16 B gap bytes undefined) | **390,184** | **5,022** | 275 / **368** |
| stability: re-apply + re-analysis on a copy | 390,184 | 5,022 | 275 / 368 (no change) |

Notes on the survival figures:

- "Entry-aware" counts a row when its start, or the table-proven entry inside it, is a function start
  with an incoming reference.
- The 76 rows that do not survive are all still functions with no incoming xref:
  - 69 are reached in F1 only through pointer data outside the 149 tables (`be32-data` 59, `be32` 4,
    `be24*` 6);
  - 3 are the data-table rows from Finding 4;
  - 4 are the listed `entry` cases.
- `stats.tsv` has the full three-way comparison.
- Against G1_H8S, the seed has 1,107 new function starts and 104 fewer old ones (`work\g1_funcs.tsv` vs
  `work\seed_final_funcs.tsv`). 1,073 of the new starts are table targets, created by G2's job logic,
  which promotes every target that lacks a function. Many of them are `jmp @ERn` switch-case blocks, not called routines.

## USB relevance

1. **Everything USB.** This is a tooling result, not new USB content. It matters for USB work in three
   ways:
   - Every future MAIN lane now decodes the H8SX USB-service module `0x075F36`–`0x078105` and the 246
     stack-A/B dispatch loads natively.
   - The stack-A dispatcher table `0x05645C` carries table xrefs, with all 13 rows applied.
   - The closed CDC-ACM/DSP-download window `0x078106`–`0x07B753` is exactly as G1 left it, and was not
     analysed.
2. **USB SDR.** No change.
3. **DSP.** No change. The SCI_1 byte pump at `0x077018` is code in the seed, but it has no caller
   outside the window (G1 Open 3 stands).

## Open

1. **Pointer-array xrefs.** 69 of the 76 remaining unreferenced F1 functions need F1's `be32-data`/`be24`
   pointer evidence emitted as xrefs (G2 Open 2). Do this on a copy of this seed.
2. **Revisit F1's `0x000760`/`0x000800`/`0x001740` proofs.** Their tables are data (Finding 4).
   `0x000760`/`0x000880` are real `rte` handlers, so their true reach is probably a vector or a RAM hook.
3. **Settle the 5 listed or skipped entries:** `050A3C`, `05BBD8`, `05FFB4`, `06F586`, plus
   `04AB70[97,163,183,274,358]` → `0x04E2D6`. Decide whether IDA's item over `0x04E2D4` is wrong.
4. **Even code under the deleted odd heads.** For example, `0x06D000`–`0x06D016` is real even code
   (`6a8c a99b`, `5e03 ffa0`, `5470`). Other freed runs (`0x06B495`–`0x06B69B`, `0x06C603`–`0x06C651`)
   are now unknown. A recursive pass from referenced even addresses may recover more.
5. **When opening the window, start from this seed.** Do not run `plan_range` over `0x078106`–`0x07B753`
   unless the lane owns the window: auto analysis changes 57 heads and adds one function there.
6. **Optional seed polish.**
   - Set `inf start_ea` to `0x2092`.
   - Consider demoting table-target "functions" that are pure switch cases into their parent function
     with `append_func_tail`, so that the function count reflects called routines.
