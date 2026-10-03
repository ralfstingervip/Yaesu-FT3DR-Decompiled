# Recount after the G wave: F1 corrections, odd-aligned heads, junk functions (Lane H1)

> Lane H1. Private DB `H1_RECOUNT` (`ida\db\jobs\H1_RECOUNT\H1_RECOUNT.i64`), seeded with
> `--copy-from ida\db\jobs\G1_H8S\G1_H8S.i64` (processor `h8sxa`). No other database was opened, and
> `run_ida.py` was not run. Job script: `ida\jobs\h1_recount.py`. Offline scripts: `ida\out\recount\offline\`
> (`reach.py`, `why.py`, `odd.py`, `fnsanity.py`, `flagged.py`, `gen_apply.py`, `recount.py`, `open_measure.py`).
> Tables: `ida\out\recount\`. Image: `decrypted\FT3D_MAIN_ver102_EXP.bin`. Base is 0, so file offset = address.
> Static analysis only: no image was modified, and nothing was connected to or written to a radio.
> Model: claude-opus-5-5 (Claude Opus 5.5).

## Verdict

**Headline: 90.39 % (931,008 / 1,029,972).** It was 90.41 % (931,187), so the change is −179 B.
The headline barely moves because most corrected bytes change type and stay credited. The proven-code
companion drops by 821 B, and the decodable denominator drops by 2,968 B.

All six G1 F1 corrections are **Confirmed** from the image bytes, but they do not all do the same thing:

- **The four "+2" rows are bogus entry points over real, proven code.** Their 236 B stay proven code. Each
  one is reached by flow from a proven parent: `0x034538`, `sub_0380EA`, `sub_04F390`, and the case code of
  table `0x06AC3A`. Only the row's proof (a pointer to the +2 address) was wrong.
- **The two ASCII-led rows hold 76 B of text.** H1 found **three more F1 rows of the same kind**
  (`04E320`, `04E538`, `051694`; 38 B). That makes 114 B moved from proven code to typed string.

**`sub_C448` is junk (Confirmed)** and is removed. The same sweep found **29 more fnindex-"validated"
functions that are text or table bytes** (456 B more; 470 B in all with `sub_C448`), for example
`sub_6BE28` = `"USA JPN EXP "` and `sub_6AB5C` = `"NEW       "`.

The **1,501 odd-aligned code heads (3,102 B)** in MAIN_FULL are all bogus. **None is a real misaligned
instruction**, and the proven flow never targets an odd address except from inside the text function
`sub_6BE28`. Of the 3,102 B, 2,256 are ASCII, 581 sit across real even instructions, and the rest are
table, fill or untyped bytes. 1,466 of these heads (3,032 B) survive in `G1_H8S`.

**Corrected MAIN decodable denominator: 388,490** (was 391,458). The `H1_RECOUNT` database measures it
directly as 388,484 + 6.
**MAIN proven code: 375,469 / 388,490 = 96.65 % of decodable, 74.25 % of content.**
**MAIN named or typed: 492,708 / 505,684 = 97.43 %.**

## Method

1. **F1 rows.**
   - Read each row's bytes from the image.
   - Decoded them with the binutils H8SX oracle that G1 built (`h8s-decode\work\bu_all.tsv`).
     `h1_recount.py` also decoded them with IDA `h8sxa` (`work\h1_ida.txt`).
   - Searched the whole image for BE32 and BE24 occurrences of every original and corrected start
     (`offline\probe_rows.py`).
2. **Proven reach (`offline\reach.py`).** This is a recursive descent over the oracle. The seeds are:
   - the fnindex-validated starts (minus `sub_C448`);
   - the F1 starts with G1's six rows corrected;
   - the 27 distinct vector targets;
   - every entry of the 149 `jumptables.tsv`/`switch_tables.tsv` tables, read in full from the image as
     BE32 (sentinel `0x3FFA0` dropped);
   - every table loaded by a decoded `mov.l @(d:32,ERs)` (iterated);
   - the 45-case `bra r0.w` switch at `0x076308`.

   This covers 366,422 B. `offline\why.py` prints the shortest seed-to-address path.
3. **Odd heads (`offline\odd.py`).** Every odd code head in `items_before.tsv` (MAIN_FULL) was checked
   against:
   - the proven-reach mask;
   - an even-aligned structural decode, either flow from every even IDA head or a linear oracle decode
     from the run start to a terminator;
   - its byte content (ASCII, `0xFF`, binary);
   - its region (fnindex extent, F1 extent, other function, or W2-8 run type).

   The result is in `odd-heads.tsv`, one row per head.
4. **Credited-function sanity sweep (`offline\fnsanity.py`, `flagged.py`).** This ran over all 3,703 credited
   MAIN starts (3,263 fnindex + 440 F1 after correction). It flags any start whose own flow targets an odd
   address, hits an undecodable word, or opens with ≥4 printable bytes. It then measures how much of each
   flagged extent is reached by *other* proven seeds.

   - 83 starts were flagged and reviewed by hand.
   - 33 corrections were applied: 30 fnindex spans (`fnindex-corrections.tsv`) and 3 F1 rows.
   - 7 were left as Unknown (listed in that file).
   - The rest were real code (for example `rts` stubs `54 70`, which read as "Tp").
5. **Recount (`offline\recount.py`).** Every addend is rebuilt as a byte mask over `0x000000`–`0x07B753`.
   - The union of the masks is checked against the additive sum.
   - G1's +794 B is replicated from G1's own inputs (`items_before/after.tsv` and `absorb_plan.json`, with
     the rules in `cov.py`).
6. **IDA confirmation (`ida\jobs\h1_recount.py` on H1_RECOUNT).**
   - Phase 1 is read-only. It confirms the state matches G1: `h8sxa`, is_code 391,452 B, 1,466 odd heads
     (3,032 B), 4,019 functions.
   - Phase 2 edits this private DB only, with auto-analysis disabled:
     - all 1,466 odd heads undefined;
     - 220/223 true even instructions created (3 skipped: overlap or undecodable);
     - 35 junk/text spans (584 B) made data;
     - 24 junk functions deleted.
   - Phase 3 recounts: **388,484 B is_code, 0 odd heads**, 3,985 functions.

**Not done.**

- SUB was not re-examined. Its 438,300 B is carried unchanged; no G/H lane touched it.
- The closed window `0x078106`–`0x07B753` was not entered.
- The recovered-code runs were measured but **not** re-proved (see Open 1).
- `items_before.tsv` is G1's dump of MAIN_FULL (is_code 380,738). The published 380,782 differs from it
  by 44 B; G1 noted this and it is carried as is.

## Findings

### 1. The six G1 F1 rows (task 1): `proved-delta.tsv`, `proved-corrected.tsv`

| Row (orig) | Bytes at row start | True start | Bytes at true start (Confirmed) | What it is | Credited code bytes |
| --- | --- | --- | --- | --- | ---: |
| `034644`–`034674` | `6b 26 00 03 46 74` | `034642` | `78 b0 6b 26 00 03 46 74` = `mov.l @(0x34674:32,er3),er6`, then `5d 60` `jsr @er6` | Tail of the routine entered at `0x034538`. The call is `0x002CA8: 5e 03 45 38` = `jsr @0x34538:24`, reached from validated `sub_DC40`. F1's "pointer" BE32 `00034644` at `0x004AA6` lies inside the code table `46 43 00 02 46 54 00 03 46 44 47 00` ("FC",0,2,"FT",0,3,"FDG"), so it is a coincidence. | 48 → 48 (re-attributed) |
| `038104`–`038160` | `6b 26 00 03 81 8e` | `038102` | `78 b0 6b 26 00 03 81 8e` | Body of `sub_0380EA`: `0x030D90: 5e 03 80 ea` `jsr @0x380ea:24`, and `0x030D68` is an entry of table `0x030DA8`. F1's BE24 hit at `0x042F0E` is a coincidence. | 92 → 92 |
| `04F3A4`–`04F3DE` | `6b 26 00 04 f3 e4` | `04F3A2` | `78 b0 6b 26 00 04 f3 e4` | Body of `sub_04F390`: `0x04F340: 5e 04 f3 90` inside validated `sub_4F30A`. F1's "table `04F3E4`" is the table this very MOV.L loads (`00 04 f3 dc 00 04 f3 de …`). | 58 → 58 |
| `06AC14`–`06AC3A` | `6b 24 00 04 36 a6` | `06AC12` | `78 c0 6b 24 00 04 36 a6` | Case code of jump table `0x06AC3A`: entry `0x06ABF2` → `0x06AC0C` → `0x06AC12`, plus `bra .+118` at `0x06AB94`. F1's BE24 hit at `0x00091F` is odd-aligned, so it is a coincidence. | 38 → 38 |
| `04DE6E`–`04DEE2` | `31 30 20 20 32 30 20 20` "10  20" | `04DE94` | `7a 05 00 04 de e2` `mov.l #0x4DEE2,er5`; BE32 `0004DE94` at `0x04AD6C` (table `0x04AB70`, entry 127) | 38 B ASCII tail of the 80 B string at `0x04DE44` ("   3   6 … 1561", "  10  20 … 5120") | 116 → 78 |
| `04DF72`–`04E010` | `6e 69 20 20 34 35` "ni  45" | `04DF98` | `7a 05 00 04 e0 10`; BE32 at `0x04AD74` (entry 129) | 38 B ASCII "ni  45  90 … 360   -" | 158 → 120 |
| **H1** `04E320`–`04E392` | "Baro     -hPa" `ff` | `04E32E` | `7a 05 00 04 e3 92`; entry of tables `0x04AB70`/`0x04ABE4` | 14 B text | 114 → 100 |
| **H1** `04E538`–`04E584` | "Gust     -mph" `ff` | `04E546` | `fb 00 6a 10 8a ac …`; entry of tables `0x04AB70`/`0x04ABE4` | 14 B text | 76 → 62 |
| **H1** `051694`–`0516C6` | "---------" `ff` | `05169E` | `6a 0c bb e9 8c 02`; entry of table `0x051548` | 10 B text | 50 → 40 |

- **Confirmed:** `proved.tsv` 19,848 B → `proved-corrected.tsv` **19,734 B** (444 rows).
- **The +2 rows correct the attribution and change no bytes.** The 2 prefix bytes of each MOV.L were already
  credited: 6 B by G1's +794 (W2-8 type `other`) and 2 B as a W2-8 "parameter table" (`0x038102`). So the row
  extents are kept as `[orig_start, end)` to avoid a double count, and `true_insn_or_entry` records the real
  start.
- In IDA `h8sxa` (`work\h1_ida.txt`), `0x038102` sits in function `0380EA-038160`, `0x04F3A2` in
  `04F390-04F3DE`, and `0x034642` in no function. `0x06AC12` sits inside IDA function `06AB5C-06AB68` (3 chunks),
  whose entry `0x06AB5C` is the text "NEW       " (Finding 3).

### 2. The 1,501 odd-aligned heads (task 2): `odd-heads.tsv`, `odd-heads-summary.txt`

| Class (MAIN_FULL) | Heads | Bytes | Where |
| --- | ---: | ---: | --- |
| Bogus across a **proven** even instruction | 223 | 452 | 222 in recovered-code runs, 1 in a pointer table |
| Bogus across a **structural** even decode (clean, not reached from a proven entry) | 58 | 118 | 52 in recovered-code runs (104 B), 6 in unvalidated MAIN_FULL functions (14 B) |
| Partly over proven code, rest data | 11 | 22 | recovered code 9, pointer table 2 |
| Data: ASCII | 1,088 | 2,256 | string runs 2,132 B, recovered-code runs 120 B, pointer table 4 B |
| Data: typed pointer table | 63 | 138 | pointer-table runs |
| Data: untyped binary | 54 | 108 | recovered-code runs (all 108 B) |
| Data: `0xFF` fill | 4 | 8 | fill runs |
| **Real misaligned instruction** | **0** | **0** | — |

- **No odd head lies inside a fnindex-validated or F1 extent** (Confirmed by region). The validated-function and
  F1 addends are therefore not inflated by odd heads. Recovered-code runs (part of proven code) are: 120 B of
  ASCII and 117 B of untyped data (108 untyped plus 9 non-code bytes of the partial heads).
- **Real misaligned = 0.**
  - **Confirmed:** across 115,090 instructions, the proven descent never decodes at an odd address. The only
    odd flow target it meets is `bsr .+83` → `0x06BE7D`, from `0x06BE28: 55 53`, which is the text
    `"USA JPN EXP "`.
  - **Inferred** from H8SX word-aligned fetch, with no odd entry from any table or vector in scope: none of
    the 1,501 heads can execute.
- G1 had already removed 35 of the heads (70 B, all in recovered-code runs). 1,466 heads (3,032 B) remain in
  `G1_H8S`.

**Corrected decodable denominator (current, post-G1 basis).**

| Term | Bytes | Source |
| --- | ---: | --- |
| Published | 391,458 | `h8s-decode\coverage.txt` (380,782 + 10,701 − 25) |
| − odd heads still in G1_H8S | −3,032 | `odd-heads.tsv` `still_in_G1_H8S=yes` |
| + true even instructions over those bytes | +527 | IDA H1_RECOUNT: `work\items_h1.tsv` × odd bytes (arithmetic 529) |
| + bytes of those instructions IDA had left undecoded | +115 | `items_h1.tsv` code minus `items_after.tsv` code |
| − H1 junk/text spans still is_code | −578 | 470 fnindex spans + 108 F1 text (G1 left all but 6 B of the F1 text as IDA code) |
| **Corrected** | **388,490** | = IDA-measured 388,484 + 6 (published 391,458 vs dump 391,452) |

On the pre-G1 basis the same arithmetic gives 380,782 − 2,521 − 470 − 114 = 377,677. That figure has no IDA
re-measure, so the +115-type term is not included.

### 3. `sub_C448` and 29 more junk "validated" functions (task 3): `fnindex-corrections.tsv`

**`sub_C448` (`0x00C448`–`0x00C456`) is junk (Confirmed).**

- Its bytes are `02 02 02 02 02 22 74 00 6c 69 5a 49 5c 62`. They fill the exact hole between lane-5 runs
  `0x00C06A`–`0x00C448` and `0x00C456`–`0x00C636`, both "byte table, alphabet {00,01,02}+{21..76}".
- Its "jmp" `5a 49 5c 62` targets `0x495C62`, outside the 16 MB space.
- Its only xref (`main-full\xrefs.tsv`) comes from `0x00C3F8`, inside the same table.
- The proven reach never touches it.
- **Action:** 14 B were removed from the validated-function addend and retyped as parameter table (credited).
- Note: in H1_RECOUNT, IDA `h8sxa` `decode_insn` at `0x00C44C` returns `stmac` (`02 22`). That differs from
  doc 36's remark that h8sxa rejects `stmac`.

**The sweep found 29 more of the same kind (Confirmed bytes, 456 B):**

- **Text after an `rts`:** `0x004C14` (20 spaces + `ff 00`), `0x04F96A`, `0x051054` ("    -1  -2 … -15"),
  `0x0510DA` (":ack:rej"), `0x0511D2` ("PPP\0PP0\0…000\0"), `0x0526FC`/`0x052704`, `0x059C14`, `0x05E08A`
  ("000102…26"), `0x06AB5C` ("NEW       " `ff 00`), `0x06BE28` ("USA JPN EXP ").
- **String openers:** `0x04CAB6`, `0x04D9D4`, `0x04F054` and `0x0516C6` are "[ " opening "[ STATUS TEXT ]",
  "[ COMMENT TEXT ]", "[ DATA TEXT ]" and "[   RAW DATA  ]". `0x04FDEE`, `…F4`, `…F8` and `0x04FE00` are pieces
  of "[1: [2: … [8: ".
- **A string continued:** `0x048B80` "LON " continues `.LAT ` at `0x048B7B`. The `54 70` at `0x048B84` is kept.
- **Leading text before a real entry:** `0x0261F0` (10 B), `0x066AF6` (16 B "-"), `0x06A976` (".jpg"),
  `0x06E05E` ("****"), `0x073B62` (10 spaces).
- **Table bytes:** `0x00C636` (4 B, between the same lane-5 byte-table runs as `sub_C448`); `0x011038` (24 B of
  byte pairs); `0x0232C6` (nine 4-byte records); `0x037A00` (`44 71` inside a BE float32 table: `43 89 00 00`,
  `43 95 00 00`, `44 58 00 00`, `44 71 00 00`, `45 34 00 00`). The last three were removed with **no** credit,
  because their type is not established: 62 B.

How they were validated:

- Every one of the 30 spans is is_code in MAIN_FULL and counted in the published 249,098.
- Whole-function cases have **zero** bytes reached by other proven seeds.
- Leading-text cases resume exactly where other proven flow begins.
- The fnindex validator accepted them on data references to strings: `sub_6BE28` is "called by sub_6BD6E",
  which actually loads the string pointer.

**Left as Unknown, not applied (7 spans, 62 B):**

- `0x022E3A` (40 B): clean code shape, no proven reach.
- Five 4-byte `27 29 2a 29` / `20 22 23 22` heads before table entries: `0x02D704`, `0x02D7FE`, `0x02E2D8`,
  `0x02E3D2`, `0x03400E`. They decode as `mov.b @aa:8` pairs and may be fall-through tails.
- F1 `0x034F22` (`4f 6e`, 2 B before table entry `0x034F24`).

### 4. Headline and companions (task 4): `recount.tsv`

**Double-count check (Confirmed).** All ten pairwise byte intersections of A, B, D, E and F are **0**. The union
is 492,887 = additive MAIN. The 28 B of doc 33 show up as A-mask = 249,070 = 249,098 − 28: in MAIN_FULL those
bytes are typed runs, not is_code. So the published −28 stays, and no other overlap exists.

| Addend | Published | H1 | Source file (re-sum from disk) |
| --- | ---: | ---: | --- |
| A fnindex-validated is_code | 249,098 | **248,628** | `fnindex\l1_counts.txt` 100,766 + `w2_1_counts.txt` 80,850 + `w2_2_counts.txt` 67,482; minus `recount\fnindex-corrections.tsv` col `is_code_in_A` (470) |
| B typed runs (type ≠ other) | 222,192 | **222,075** | `wave2\main-raw-types.tsv`; minus 117 B untyped odd-head data in recovered-code runs (`recount\odd-heads.tsv`) |
| C doc-33 double count | −28 | −28 | `33-coverage-audit.md` |
| D F1 proved extents | 19,848 | **19,734** | `recount\proved-corrected.tsv` sum(`bytes`) |
| E F2 newly typed | 983 | 983 | `main-raw-other\split.tsv` (old `other` → code / parameter table) |
| F G1 new, uncredited | 794 | 794 | `h8s-decode\coverage.txt` §4, replicated in `recount.py` |
| H H1 retyped and credited | — | **522** | string 504 (390 `fnindex-corrections.tsv` + 114 F1 text in `proved-delta.tsv`), parameter table 18 (`sub_C448` 14 + `0x00C636` 4) |
| **MAIN numerator** | 492,887 | **492,708** | |
| G SUB window validated is_code | 438,300 | 438,300 | `sub-window\coverage.txt` (297,232 + 141,068) |
| **Headline numerator** | 931,187 | **931,008** | |
| Denominator | 1,029,972 | 1,029,972 | 505,684 MAIN content + 524,288 SUB window |
| **Headline** | 90.41 % | **90.39 %** | |

The 120 B of ASCII odd heads in recovered-code runs stay inside B (retyped string, still credited).

**MAIN companions.**

| Metric | Published (G wave) | H1 |
| --- | --- | --- |
| Named or typed | 492,887 / 505,684 = 97.47 % | **492,708 / 505,684 = 97.43 %** |
| Proven code | 376,290 = A 249,098 + recovered-code runs 100,125 + D 19,848 + G1 tier A 7,219 | **375,469** = 248,628 + 99,888 + 19,734 + 7,219 |
| Decodable denominator | 391,458 | **388,490** |
| Proven % of decodable | 96.13 % | **96.65 %** |
| Proven % of content | 74.41 % | **74.25 %** |

The recovered-code term is 100,125 − 120 ASCII − 117 data = 99,888. The proven-code share of decodable *rises*
because the denominator loses 2,968 B and the numerator only 821 B.

## USB relevance

- **No mission answer changes.** Every byte moved by this lane is text, a table, or the attribution of
  already-proven code inside UI/menu/IPC routines.
- The three re-attributed parents (`0x034538`, `sub_0380EA`, `sub_04F390`) and the `0x06AC3A` switch were not
  examined for purpose beyond reachability.
- None of the moved bytes lies in the H8SX USB/SCI module `0x075F36`–`0x078105` or in the closed window
  `0x078106`–`0x07B753`: the highest corrected address is `0x073B62` (Confirmed by address). The USB stack-A
  dispatcher `0x056272`–`0x05645C` is also untouched.

## Open

1. **Re-prove the "recovered code" runs (largest remaining inflation).** They are 100,125 B, counted whole as
   proven code. Under the corrected proven descent, **16,784 B of them are not reached**, and 2,943 B of those
   are printable runs of ≥6 bytes (`open-measure.txt`). This is an upper bound: the descent has no
   RAM-pointer call edges. Their is_code bytes are also in the decodable denominator. Other unreached is_code
   bytes sit in typed data runs: string 949 B, fill 68 B, pointer table 60 B, "other" 224 B, and parameter
   table 2,939 B (the last partly real code per G1). A lane should seed reach with every proven entry plus
   resolved pointer arrays (G2 Open #2), then demote the unreached text and tables.
2. **Settle the 7 Unknown spans** (62 B) in `fnindex-corrections.tsv`, especially the five
   `27 29 2a 29` / `20 22 23 22` heads that sit 4 B before table entries.
3. **Rebuild a MAIN seed DB as `h8sxa` with H1's edits.** `H1_RECOUNT` already has 0 odd heads, 220 true
   instructions and the 24 junk functions deleted, and can serve as that seed. It still carries G1's tier-B
   code outside functions.
4. **Fold the four re-attributed F1 rows into their parents in the function model.** `0x034538` has no IDA
   function in G1_H8S, and `0x06AC12` is still chunked under the text-entry function `06AB5C`.
