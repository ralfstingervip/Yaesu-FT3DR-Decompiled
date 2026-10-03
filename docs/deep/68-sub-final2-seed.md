# SUB_FINAL2: lane-4 continuations merged, published data typed (Lane I17)

Owner-side static analysis of `decrypted\FT3D_SUB_ver102_ALL.bin` (RX64M, little-endian, mapped at `0xFFC00000`, file offset = address − `0xFFC00000`; sha256 `b93570b3…`, re-hashed by `i17_verify.py` and unchanged). The private DB is `ida\db\jobs\SUB_FINAL2\SUB_FINAL2.i64`, seeded with `--copy-from ida\db\jobs\SUB_FINAL\SUB_FINAL.i64`. SUB_FINAL was only copied: its sha256 is still `884f2474…`, the value I2 handed off. No other DB was opened, no image was modified, and nothing was written to a radio or any device. Model: claude-opus-5-5.

Tables are in `ida\out\sub-final2\` and listed under Files.

## Verdict

SUB_FINAL2 is SUB_FINAL with sound function bounds and no unexplored window bytes. It is a **fixed point**: pass 1 changed 2,998 items and removed 1,662 functions, and passes 2, 3 and 4 each changed **0 items and 0 functions**.

- **Merges.** Of I2's 1,666 reachable functions with no call, pointer or vector reference at their entry, **1,662 are proven continuations and were merged** into 511 owners.
  - Every merged start has an entry edge (fall-through from a non-stop instruction, a branch, or a switch case) from exactly one root.
  - None has a call xref, a data or pointer xref, a vector, an `o_imm` operand, or a 3-byte LE pointer pattern anywhere in the 4 MB image. The 10 data xrefs found all come from switch tables.
  - **4 stay functions** and are listed in `ambiguous.tsv`:
    - `FFF13F01` is a tail shared by two unreferenced roots.
    - `FFF46265`, `FFF47B5F` and `FFF47CF3` are tail-call targets. Each starts with a `pushm` prologue and is entered only by a `bra` from a thunk or wrapper.
  - Every old start has the repeatable comment `I17: was sub_XXXXXXXX (lane-4 start)`. `alias.tsv` maps all 1,666 old labels.
  - The function count falls from 4,088 to **2,426**. 2,417 functions are a single chunk, and no tail has more than one parent.
- **Data typing.** All **34,618 B** of never-explored published window data are now typed, as 154 classed sub-runs that tile the 138 runs exactly (`data-types.tsv`):
  - 16,230 B of RGB565 descriptor records
  - 10,788 B of low tables: icon records, 1-bpp font and glyph records, storage-driver tables, CC-RX runtime constants, and pointer and constant tables
  - 160 B of zero INTB slots
  - 7,440 B of string pool
- **Below the window.** The block `FFECE51C`–`FFED0000` is 64 B of zero pad plus descriptor records 0..425 and the first 4 B of record 426, at a **16-byte stride**. That agrees with docs 16 and 27 and corrects lane I10's "12-byte records".
- **Counts.** Recounted with I2's rules, every figure is unchanged:

  | Figure | Bytes |
  | --- | --- |
  | Headline | 464,263 |
  | Reach-only | 457,462 |
  | All-well-formed | 467,999 |
  | Code+typed | 520,552 |

  The byte-level ledger against I2's five final masks is **+0/−0** on every figure. The code heads equal I2's `target-heads.tsv` exactly.
- **Sanity.** 0 mid-instruction edges, 40/40 switch tables, and 0 violations of the RX encoding traps.

## Method

All IDA work ran through `run_job.py` on `SUB_FINAL2`. Every job wraps its body in try/except and writes the traceback to a file. Every job calls `auto_wait`, writes UTF-8, and ends with `qexit(0)`.

**Scripts.**

| Script | Kind | Role |
| --- | --- | --- |
| `ida\jobs\i17_query.py` | IDA, read-only | Dumps the evidence into `raw\query_seed\`: refs and drefs into the data ranges, and per function its chunks, entry xrefs by type and the head before the entry. |
| `ida\jobs\i17_plan.py` | IDA, read-only | Builds the frozen merge plan from the unmerged copy (`merge-plan.tsv`, `ambiguous.tsv`, `raw\ptr-scan.tsv`). |
| `ida\jobs\i17_dataplan.py` | Plain Python | Classifies the 138 runs from the image and writes `data-types.tsv`, `data-items.tsv` and `data-structs.tsv`. It asserts 555 byte facts (`raw\dataplan_checks.txt`: 0 FAIL). |
| **`ida\jobs\i17_apply_final2.py`** | IDA | The reusable, idempotent apply job: merges, struct types and data items, followed by `plan_range` and `auto_wait` over `FFECE4E4`–`FFF50A00`. It measures each pass. |
| `ida\jobs\i17_recount.py` | IDA, read-only | I2's `i2_recount.py` with the outputs redirected. It adds a byte ledger against I2's masks, a head check against `target-heads.tsv`, an unknown-byte count and a merged-starts column. |
| `ida\jobs\i17_dis.py` | IDA, read-only | Disassembly dumps for the citations (`raw\dis_final.txt`, `raw\dis_readers.txt`). |
| `ida\jobs\i17_verify.py` | Plain Python | Byte-verifies 61 cites plus the `cmp #1Ah` font-selector bound, 62 checks in all (`raw\verify.txt`: 0 FAIL). |

**Run sequence for the final DB.** All steps ran from a fresh `--copy-from`:

1. `i17_query`
2. `i17_plan`
3. `i17_dataplan`
4. `i17_apply_final2`, passes 1, 2 and 3
5. `i17_recount`
6. `i17_dis`
7. `i17_apply_final2` pass 4, which confirmed 0 changes after the read-only reopens

**Development runs.** I made two earlier apply builds on copies that were later discarded:

- The first build waited on cycles of continuations, which left 11 owner mismatches.
- The second build merged three tail-call targets.

I also ran a one-off probe of the struct API. The plan and data files were regenerated and checked against the earlier copies with `cmp`.

**Merge rule** (`i17_plan.py`). The universe is I2's `functions.tsv` rows with `reach == reachable` and `entry_refs` either empty or jump-only, which is 1,550 + 116 = 1,666 rows. For each candidate C with chunk set K(C), I collect every edge from outside K(C) into any head of K(C):

- **Flow.** The head before a chunk is code, is not a stop (CF_STOP: rts/rtsd/bra/jmp), and ends exactly at the chunk start.
- **Jump.** An fl_JF or fl_JN xref.
- **Switch.** One of H8's 643 switch edges, or an IDA xref from inside one of the 40 switch tables.
- **Refusal triggers.**
  - a call xref
  - any other data xref
  - an INTB or EXTB vector
  - I2's `ptr-root` flag
  - an `o_imm` operand equal to the entry, anywhere in the DB
  - the entry's 3-byte LE prefix at any byte offset of the image, unless that offset is inside a code head (not as an operand) or inside the atlas `FFC3EB80`–`FFEB74D8`

A root is a non-candidate function, a refused candidate, or a candidate with no external source. A **tail-call target** is also a root. That is a candidate whose entry edges are all unconditional branches and whose first instruction is `pushm` (`6E xx`).

Root sets are a least fixpoint over the candidate graph. A candidate reached from more than one root is a shared tail: it becomes a root and the fixpoint runs again. This handles cycles of continuations.

I read the task's "does not end in its own rts" as a condition on the predecessor. A fall-through edge counts only when the instruction before the continuation is not a stop. Otherwise the continuation must be branched into.

**Apply mechanics.** A continuation is merged once all its sources are already inside its root, so chains collapse into contiguous extensions. Cycles are then forced into the root, one at a time.

Each merge deletes the function. Each of its chunks then either extends the root's adjacent chunk (when the head before it is the root's chunk end) or is appended as a tail. A tail that still belongs to another parent is left with that parent. At the end, `get_func(old_start)` is checked against the plan's root for all 1,662 rows: **0 mismatches**.

**Scope.** The merges cover all functions in the DB. Data typing covers the 34,618 never-explored bytes of `FFED0000`–`FFF50000` and the block `FFECE51C`–`FFED0000`. In addition, two bogus items were retyped:

- a 6-B strlit at `FFED337C`, which is record 1250 of the descriptor table
- a 2-B strlit at `FFF4A120`, which is rect record 0

**Not done.**

- Function purposes were not assigned.
- The 155 unreferenced dead or credited-unreached functions were not merged, because they are outside the 1,666 (Open 1).
- The I2 typed items that already existed were left in place, except for the two retypes. Examples are dword pointer slots, and the `FFFFFFFF` at `FFED417C`, which I2 turned into an offset.
- Struct members carry no offset xrefs, so the `desc` and `src` fields inside struct records do not produce drefs.

## Findings

### 1. Merges (Confirmed; `merge-plan.tsv`, `alias.tsv`, `ambiguous.tsv`)

| Evidence at the continuation | Merged |
| --- | --- |
| flow only | 1,239 |
| flow + jump | 261 |
| flow + jump + switch | 2 |
| jump only | 154 |
| jump + switch | 6 |
| **total** | **1,662** (1,502 entered by fall-through, 160 only by branch) |

**Apply pass 1.**

- 1,662 `del_func` calls
- 1,724 chunk extensions
- 186 appended tails
- 117 forced merges inside continuation cycles
- 17 tails left with a co-parent, which later merged into the same root

**Pointer test.** The 3-byte scan of the 4 MB image found 60 hits for the 1,666 entries. 43 lie inside code bytes but not as an operand, and 17 have a 4th byte other than `FF`. There were **0 `o_imm` hits** and **0 LE32 data hits** (`raw\ptr-scan.tsv`).

**Switch cases.** The first plan refused 10 candidates whose only data xrefs come from IDA's switch tables. Those are case edges, so they now count as switch edges:

| Candidates | Switch table |
| --- | --- |
| `FFEEC0D3` | `FFF48076` |
| `FFEF9EF4`, `FFEF9F68`, `FFEF9FDC`, `FFEFA330`, `FFEFA409`, `FFEFA495`, `FFEFA4C0` | `FFF48126` |
| `FFF06A19` | `FFF48262` |
| `FFF40980` | tables `FFF48027`–`FFF48059` |

**Examples.** Bytes are verified (`raw\verify.txt`); the disassembly is in `raw\dis_final.txt`.

- **Fall-through.** In `sub_FFEDFEB9` the code runs `FFEDFFFD fb e2 d4 cd 01 00` mov.l #1CDD4h,r14, then `FFEE0003 f8 e6 01` mov.l #1,[r14], which is not a stop, into `FFEE0006 fb e2 c4 24 01 00`. That address was lane-4 `sub_FFEE0006` and is now `loc_FFEE0006` in `sub_FFEDFEB9` (`FFEDFEB9`–`FFEE0191`). The same function also absorbs `FFEE003B`, the jump target from `FFEDFF87`. Both cases were I2's Open 1 examples.
- **Self-tail loop.** In `sub_FFEDB081`, `FFEDB0A9 2e 7e` bra.b FFEDB127 is followed by the loop head `FFEDB0AB a8 89`, which `FFEDB125 29 86` blt.b reaches. That loop head falls into `FFEDB0B0 fb e2 d8 2c 01 00`. I2 had attached `FFEDB0AB` as a tail of `sub_FFEDB0B0` itself, so the predecessor of `sub_FFEDB0B0` was its own chunk. The edge set over K(C) resolves this to `sub_FFEDB081`, which now covers `FFEDB081`–`FFEDB131` as one chunk.
- **EXDMAC block (doc 16).**
  - `FFEF1F74`/`FFEF1F80`/`FFEF1F88`/`FFEF1F90` each start with `fb ee 00 28 08` mov.l #82800h,r14.
  - `FFEF1F7B 2e 15` bra.b and `FFEF1F87 09` bra.s go to `FFEF1F90`.
  - `FFEF1F8D e1 1e 03` falls through.

  Nothing calls any of the four. With `FFEF1FC2`, `FFEF1FD1`, `FFEF1FDF`, `FFEF1FEB` and `FFEF1FF2`, they are one routine, `sub_FFEF1EFA` (`FFEF1EFA`–`FFEF201A`). Doc 16 calls them `sub_FFEF1F74`/`sub_FFEF1F80`; they are labels of `sub_FFEF1EFA`.
- **Large owners.** `sub_FFEF9E8F` absorbs the switch-case blocks of the `FFF48126` dispatcher. `sub_FFEE2B4C` absorbs `FFEE2BC0`, `FFEE2C03`, `FFEE2CCE` and `FFEE2D52`. Doc 27 lists `FFEE2CCE` as an RGB565 font-widget function; it is a block inside `sub_FFEE2B4C`.

**Kept (`ambiguous.tsv`).**

- **`FFF13F01`** is entered by `FFF13EE8 2a 19` bgt.b from `sub_FFF13DEF`, and by `FFF13EFF 2e 17` bra.b FFF13F16 from `sub_FFF13EEA`. Both sources are lane-4 "body" starts with no reference; I2 classes them credited-unreached. By flow, `FFF13DDA`→`FFF13DEF`→`FFF13EEA`→`FFF13F01` is one unreferenced routine (Inferred), but its other parts are outside the 1,666.
- **`FFF46265`** (`6e 6d` pushm r6-r13) is reached only by `FFF45579 04 ec 0c 00` bra.a. That instruction is in `sub_FFF45575` (`66 a3` mov.l #0Ah,r3 / `66 02` mov.l #0,r2), an `atoi`-style wrapper. `FFF46265` is the `strtol`-family body of doc 30. The doc-30 label `sub_FFF46267` (`60 c0`) is now `loc_FFF46267` inside `sub_FFF46265`.
- **`FFF47B5F`** (`6e 69`) and **`FFF47CF3`** (`6e 67`) are the targets of one-instruction thunks: `FFF4791C 04 43 02 00` bra.a, and `FFF47920`.

**Flagged merges.**

- `FFF2570F` (`FFF25700 20 0f` beq.b)
- `FFF38800` (`FFF387F8 10` beq.s)

Both are entered only from functions that I2 classes as **dead** (`sub_FFF256BD`, `sub_FFF387C9`). They were "reachable" only because lane 4 validated them as "xref" starts on these jumps. They are merged, and their owners stay dead.

**Labels that docs cite.** 31 merged starts are cited somewhere in `docs\`, either bare or as `sub_`. The owners follow:

- **docs 54, 46, 48 (I2/H-wave seeds):**
  - `FFEE0006` and `FFEE003B` →`FFEDFEB9`
  - `FFEEC0D3`→`FFEEC08D`
  - `FFEEA555`→`FFEEA379`
  - `FFF38800`→`FFF387C9`
- **docs 02, 16, 20, 21 and RESUME-FULL (EXDMAC):** `FFEF1F74`, `FFEF1F80`, `FFEF1F90`, `FFEF1FC2`, `FFEF1FD1`, `FFEF1FDF`, `FFEF1FEB` and `FFEF1FF2` →`FFEF1EFA`
- **doc 27 (font and layout readers):**
  - `FFEE2CCE`→`FFEE2B4C`
  - `FFEE6176`→`FFEE6168`
  - `FFEE6246`→`FFEE6238`
  - `FFEE6282`→`FFEE6274`
  - `FFF02DE3`→`FFF01F70`
  - `FFF067A9` and `FFF07C24` →`FFF057FF`
  - `FFF33499`→`FFF33421`
- **doc 31:**
  - `FFEE61B3`→`FFEE61B1`
  - `FFEEBAEC`→`FFEEBAAC`
  - `FFEEBE8E`→`FFEEBE51`
- **doc 23:**
  - `FFEFAC8B`→`FFEFAB3E`
  - `FFEFADCF`→`FFEFAD3F`
  - `FFEFAEF3`→`FFEFADF3`
- **doc 45:** `FFF05397`→`FFF05387`
- **doc 50:** `FFF07F37`→`FFF07E49`
- **doc 30:** `FFF00ED4`→`FFF00684`, and `FFF46267`→`FFF46265`

Search the DB for the repeatable comment, or look the label up in `alias.tsv`.

### 2. The 34,618 B (Confirmed unless marked; `data-types.tsv`, 154 window rows)

| Group | Bytes | Rows | Content |
| --- | --- | --- | --- |
| RGB565 descriptor records `FFED0000`–`FFED3F6C` | 16,230 | 3 | `i17_bmp_desc_t {u16 w,u16 h,u32 src,u16 key,u16 tint,u16 mode,u16 pad}`, stride 16. Tail of record 426, then records 427..1440 (1,014 records). |
| Low tables `FFED3F6C`–`FFED8A70` | 10,788 | 31 | See the table below. |
| INTB slots | 160 | 14 | 40 vectors with value 0, typed as u32. I2 had typed only the nonzero slots. |
| String pool `FFF48000`–`FFF4B059` | 7,440 | 106 | C strings, fixed-width slots, local-array images and pads (below). |

**Low tables.**

| Range | Bytes | Class and layout | Reader (bytes in `raw\verify.txt`, disassembly in `raw\dis_readers.txt`) |
| --- | --- | --- | --- |
| `FFED4180`–`FFED4288` | 264 | RAM-default image: bytes 4..267 of a 268-B const struct, copied to RAM `1CC90`. | `sub_FFEDFBE2`: `FFEDFBED fb 3a 0c 01` mov.l #10Ch,r3 / `fb 22 7c 41 ed ff` #FFED417C / `fb 12 90 cc 01 00` #1CC90h / `7f 8f` smovf. The field readers are `sub_FFEDF904`..`sub_FFEDFA32`. |
| `FFED428C`..`FFED42CC` (4 runs) | 40 | `char*` slots 1..16 of the 17-entry GPS `$PMTK` command table (`FFED4288`). | `sub_FFEE0D4D`: `FFEE0D7B fb f2 88 42 ed ff` / `fe 6e f1` mov.l [r14,r15],r1. |
| `FFED42CC`–`FFED4300` | 52 | Linker section-address list (Inferred to be CC-RX `__sectop`/`__secend` constants): `FFC00100 FFC3EB44 FFECE4E8 FFF47FD1 FFF48064 FFF483C8 FFF483C8 000698FC FFED8A34 FFED8A58 FFED8A70 ×3`. | No reference: the 3-byte scan of the whole image finds 0 hits. `FFF47FD1`, `FFF48064` and `FFF483C8` are the first 1-byte switch table, the first 2-byte table and the end of the tables (H8 `typed-data.tsv`). `FFED8A34`, `FFED8A58` and `FFED8A70` are DTBL, BTBL and INTB. |
| `FFED45A8`–`FFED45E8` | 64 | 16 descriptor pointers, slots 1..16 of 17. | `sub_FFEE4DDA`: `FFEE4E22 fb e2 a4 45 ed ff`, with index = byte mod 0x11, then `sub_FFEF0648`. |
| `FFED4644`–`FFED477C` | 312 | **26** `i17_font1_blk_t {u8 w,u8 h,u16 base_code,u32 ord_tbl,u32 pix_base}` records. | Records 0..7 match doc 27's table byte for byte. Record 8 repeats record 2. Records 9..25 are smaller fonts with base `0x20`, sizes 14×27 down to 4×7. The bound is `cmp #1Ah` (`75 51 1a`) at `FFEF2184+0x12`, which allows **26** entries; doc 27 listed only 8. |
| `FFED477C`–`FFED49E0` | 612 | 51 `i17_glyph1_desc_t {u16 w,u16 h,u32 pix,u32 flag}` records. `pix` points into the 1-bpp store `FFC362AC`.. (for example, `FFED477C 05 00 07 00 ac 62 c3 ff 00 00 00 00`). | No direct immediate (scan: 0 hits). Contiguous after the font blocks (Inferred: same base, index ≥ 26). |
| `FFED49E0`–`FFED4B48` | 360 | 45 `i17_glyph_tbl8_t {u16,u16,u32 tbl}` records. | `sub_FFEE59A4`: `FFEE59C8 6c 31` shll #3 / `fb e2 e0 49 ed ff`, index clamped to 0x2C. |
| `FFED55D4`–`FFED55E0` | 12 | 3 descriptor pointers. | `sub_FFEEF86F`: `FFEEF8C9 fb e2 d0 55 ed ff`, index & 3. |
| `FFED55E0`–`FFED71A8` | 7,112 | **254** `i17_icon_rec_t` records, 28 B each: `id` (= index, or 0 when unused), f04/f06, f08 (= 2), three zero words, and `desc` at +0x18, which is a descriptor pointer. | `sub_FFEF34B1`: `FFEF34BF 75 11 1c` mul #1Ch / `fb 22 e0 55 ed ff` / smovf 0x1C. |
| `FFED71A8`–`FFED7228` | 128 | u32[32] holding 1<<i. | `sub_FFEFB2C2`: `75 51 1f` cmp #1Fh / `fb e2 a8 71 ed ff`. |
| `FFED74E8`–`FFED75A8` | 192 | 24 `i17_menu_cat_t {u32 count,u32 labels}` records. Records 13..21 are empty. | `sub_FFF095E3`: `6c 31` / `fb e2 e8 74 ed ff`. This is BRIEF correction 5's 1-based menu table. |
| `FFED7A68`–`FFED7AE4` | 124 | WIRES-X news tables. The first is `{u32 desc, char[12]}` (EMERGENCY / NEWS STATION / LOCAL NEWS / INT NEWS). The second is `i17_news_b_t {u32 desc,char[8],u32}` ('       ' / VOICE / MESSAGE / PICT). | `sub_FFF0F6A7` (`#FFED7A64`); `sub_FFF0F546` (`6c 41` / `fb 22 a4 7a ed ff`). |
| `FFED7E94`, `FFED831C` | 56 | NULL-terminated `char*` lists of `I:\FT3D\…` and `FT3D\…` paths. | `sub_FFF12A8F`; `sub_FFF3B8DE` and others. |
| `FFED7F18`–`FFED819C` | 644 | Storage-driver tables (Inferred SD/MMC host): 7 mask pairs (u32[14]), u32[4], and 13 `u32[11]` mode records of 44 B. | `sub_FFF34897`: `5e ef 63 01` movu.w 2C6h[r14] / `fb 52 18 7f ed ff`, which feeds `tst 2B0h[r14].l` and error −17h. `sub_FFF362EF`: `77 01 ff ff 7d` cmp #7DFFFFh / `75 43 2c` / `fb e2 60 7f ed ff`. |
| `FFED81F8`–`FFED8318` | 288 | 2 × 4 `i17_ramptr9_t` (u32[9] RAM addresses `0x10C66..`). | `sub_FFF3B7B5`: `75 13 24` mul #24h / `fb 22 f8 81 ed ff`, copied to RAM `683D0` and `68460`. |
| `FFED84D8`–`FFED8628` | 336 | `{idx,u32}` ×10 (200 … 1,000,000), then `{idx,f32}` ×16 holding sin(k·22.5°), then ×16 holding cos(k·22.5°). | `sub_FFF42981`: `fd c3 1e` / `fb f2 d8 84 ed ff`. All 32 floats were checked against math.sin/cos within 1e-6. |
| `FFED8974`–`FFED8A34` | 192 | CC-RX runtime constants: stream count 20 (`14 00 00 00`), a 72-B stream template, printf flag bits 1,2,4,8,16,0, mode bits 0,1,2,4, double[9] 1e1,1e2,1e4 … 1e256, and 0x400. | `sub_FFEE1868` / `sub_FFF45E0D`; `sub_FFF45E90` (`75 43 48` / `fb 22 78 89 ed ff`); `sub_FFF45FF6` (`" +-#0,;:_"` / `fb d2 c0 89 ed ff`); `sub_FFF469D7`; `sub_FFF46D28`. |

**String pool, 7,440 B.**

| Class | Bytes |
| --- | --- |
| Fixed-width string slots (dominant stride 8–16 with NUL fill, for example `FFF495E0` "POSITION\0" in `char[16]` slots) | 5,364 |
| C strings: ASCII, half-width kana and JIS rows | 1,666 |
| C strings with NUL padding | 243 |
| Two local-array images of 5 `i17_rect16_t {x,y,w,h}` records each (below) | 78 |
| NUL padding | 52 |
| u8 index arrays (`03 06 09 0c`) | 28 |
| 6-B const record (below) | 8 |
| Pad between W_1 and W_2 (`FFF48063 ff`) | 1 |

- The rect-record images are copied by `FFF07125 75 43 28` / `fb 22 48 a1 f4 ff` smovf.
- The const record `FFF483C8 80 04 08 01 00 00` + 2 pad is read by `sub_FFEDAB4C` (`FFEDAB4E fb e2 c8 83 f4 ff` / `d4 e0 01` mov.w [r14]).
- `FFF49800` is a u8[38] local-array image (`FFF054C9 75 43 26` / `fb 22 00 98 f4 ff`).
- Every referenced byte is an item head, because pieces are split at every operand or xref target. A referenced NUL is an empty string, for example `FFF48438` from the PMTK table.

**CC-RX `.data` images.** Not found within the 34,618 B. The three images (`FFED8E70`–`FFEDAB4C`) were typed by I2. The DTBL has 3 entries, and the section list above adds none.

### 3. Below-window block `FFECE51C`–`FFED0000` (Confirmed)

| Range | Bytes | Content |
| --- | --- | --- |
| `FFECE51C`–`FFECE55C` | 64 | All `00`. It follows doc 27's CALLBACK_REGINIT, whose last slot is `FFECE518 a2 e1 ed ff`. |
| `FFECE55C`–`FFECFFFC` | 6,816 | Descriptor records 0..425, typed `i17_bmp_desc_t`. |
| `FFECFFFC`–`FFED0000` | 4 | w and h of record 426 (`14 00 1e 00 34 61 c8 ff …`). The record crosses the window edge. |

**Format and count checked against docs 16 and 27.**

- Record 0 is `FFECE55C 1c 00 14 00 80 eb c3 ff 00 00 ff ff 00 00 00 00` and record 1 starts at `FFECE56C 1c 00 14 00`. **The stride is 16**, so I10's 12-byte reading is wrong.
- `FFECE55C` + 1441×16 = `FFED3F6C` (doc 16). Record 391 is `FFECFDCC`, doc 27's primary font base.
- The 1,441 `src` spans tile `FFC3EB80`–`FFEB74D8` with 0 gaps, and there are 1,255 distinct `src` values.
- Modes are {0: 1249, 1: 188, 2: 4}, and the top tints are `FFFF`×1253, `7BEF`×170 and `F800`×6. All of these equal doc 16.
- **Correction to doc 16's ranges.** Width is 1..318 and height is 1..98, not "6…252 / 11…98". Rules and bars exist: record 1119 at `FFED2B4C` is 318×1, and record 188 at `FFECF11C` is 1×53.

### 4. Fixed point and sanity (Confirmed; `raw\apply_pass{1..4}.txt`, `sanity.txt`)

| Pass | Items +/changed | Items − | Functions + | Functions − | Functions ~ | Functions after |
| --- | --- | --- | --- | --- | --- | --- |
| 1 | 2,998 | 0 | 0 | 1,662 | 511 | 2,426 |
| 2 | 0 | 0 | 0 | 0 | 0 | 2,426 |
| 3 | 0 | 0 | 0 | 0 | 0 | 2,426 |
| 4 (after the dis reopens) | 0 | 0 | 0 | 0 | 0 | 2,426 |

Code bytes in `FFECE4E4`–`FFF50A00` were 470,305 before and after.

`sanity.txt` reports:

- 0 edges from the 172,723 heads into mid-instruction bytes, and 0 onto non-code bytes
- 40/40 switch tables whose IDA cases equal H8's edges
- RX traps:
  - 1,373 `FB` imm24 forms: 0 mismatches
  - 10,981 imm32 forms: 0 mismatches
  - 4,448 `75 4x`/`75 5x` uimm8 forms: 0 mismatches
  - 14,645 `A8`–`AF` `o_displ` `op.value` operands: 0 mismatches
- 0 code heads outside a function
- code heads equal to I2's `target-heads.tsv` (0 extra, 0 missing)
- 0 unknown bytes in the window
- 0 tails with more than one parent

### 5. Recount (Confirmed; `counts.txt`, `ledger-delta.tsv`)

| Figure | SUB_FINAL (I2) | SUB_FINAL2 | Delta |
| --- | --- | --- | --- |
| Headline + w2 | 464,263 | 464,263 | 0 |
| Headline as literally rerun | 464,165 | 464,165 | 0 |
| Reach-only + w2 | 457,462 | 457,462 | 0 |
| All-well-formed | 467,999 | 467,999 | 0 |
| Code+typed | 520,552 | 520,552 | 0 |
| Window bytes never explored | 34,618 | **0** | −34,618 |

`ledger-delta.tsv` is the byte-for-byte comparison of the five final masks with I2's `raw\mask_final_*.bin`: **+0/−0** on each. The expected delta was 0 and the observed delta is 0. Merges move ownership, not bytes. Typing touches only bytes that were not code.

The typed mask in I2's rules is a fixed region set, so typing does not change code+typed. DB data bytes in the window are 56,276, which is 56,289 minus the 13-B code twin `FFF4B077`.

**Functions.** `functions.tsv` adds a `merged_old_starts` column. The classes are:

| Class | Functions |
| --- | --- |
| reachable | 2,269 |
| credited-unreached | 89 |
| dead | 67 |
| outside-window | 1 |

Only 4 reachable functions still lack a call, pointer or vector reference at their entry. They are the 4 kept cases.

## USB relevance

None of the three mission answers changes. The merges move ownership of code that was already credited, and the typed data is UI, font, menu, storage, runtime and string data.

In the 34,618 B and the below-window block, 130 four-byte windows fall in USB0 `0xA0000`–`0xA0400`, USBA `0xD0000`–`0xD0200` or FCU `0x7E0000`–`0x800000`. Every one is a pair of u16 fields. The field offsets are:

| Record type | Offsets of the hits |
| --- | --- |
| Descriptor | +0 (w, h) and +14 (pad, next w) |
| Icon | +2, +4 (f04, f06) and +26 |
| Glyph | +10 |

There are 2 unaligned straddles, `FFED860E` and `FFF49811`. **None is a pointer field.** No table here is read by a USB, flash or SCI0 routine.

The settled SUB negatives (USB0 dark, no SUB-side SDR or DSP path) now rest on a DB in which every window byte is code or typed data. Every reached function starts at a real entry, except for 4 listed cases. **Confirmed** within `FFECE51C`–`FFF50000`.

## Open

1. **Unreferenced routines outside the 1,666.** 155 dead or credited-unreached functions have no reference at their entry, and several are fall-through continuations of one another. One example is `FFF13DDA`→`FFF13DEF`→`FFF13EEA`→`FFF13F01`. Running the same plan rule over them would give clean bounds for the dead code. It would also resolve `FFF13F01`.
2. **Doc updates for the orchestrator.**
   - Doc 16: the w/h ranges.
   - Doc 27: 26 font blocks, not 8. `FFEE2CCE`, `FFF02DE3`, `FFF067A9`, `FFF07C24` and `FFF33499` are labels inside larger functions.
   - Doc 62: the record stride is 16, not 12.
   - Doc 30: the strtol body starts at `FFF46265`.
3. **Field semantics.** Not yet given:
   - `i17_icon_rec_t` f04/f06/f08
   - the storage-driver mode records (probably capacity-class parameters, Inferred)
   - the 1-bpp glyph descriptors, which have no direct reader
   - the 268-B default image at `FFED417C`

   This needs a pass over the readers named above.
4. **Retype or annotate I2's bogus items.** The `off_FFED417C` offset to `FFFFFFFF` is one case. A sweep of I2's 2,847 data items for strlits that sit inside record tables would find the rest. Only `FFED337C` and `FFF4A120` were found, because only those intersected the 34,618 B.

## How to seed from SUB_FINAL2

```text
python "ida/run_job.py" --script ida\jobs\<lane>_x.py --db <YOURDB> --copy-from ida\db\jobs\SUB_FINAL2\SUB_FINAL2.i64
```

- **Layout.**
  - Segments are as in SUB_FINAL: `RES FFC40000–FFEDAB4C`, then `DENSE FFEDAB4C–FFF50000`.
  - The DB has 2,426 functions.
  - Code heads are identical to `ida\out\sub-final\target-heads.tsv`.
  - Credited code is `ida\out\sub-final2\raw\mask_final2_headline_w2.bin`, which is identical to I2's mask.
- **Old labels.** A doc citation `sub_X` of a merged start shows up in the DB as `loc_X`, with the repeatable comment `I17: was sub_X (lane-4 start)`. `alias.tsv` gives its owner.
- **Local types.** There are 12 types named `i17_*` (`data-structs.tsv`). Descriptor records are struct items, so a draw site's `#unk_FFEDxxxx` now shows as `stru_FFEDxxxx`.
- **Rebuild from scratch.** Run these in order; each takes seconds:
  1. `i17_query.py --copy-from ida\db\jobs\SUB_FINAL\SUB_FINAL.i64`
  2. `i17_plan.py --reopen`
  3. `python ida\jobs\i17_dataplan.py`
  4. `i17_apply_final2.py --reopen --env I17_PASS=1`, then again with `I17_PASS=2` to confirm 0 changes
  5. `i17_recount.py --reopen`
- **File hashes.** IDA rewrites the `.i64` on every reopen. At hand-off its sha256 was `933f1ded…`. Use content checks, not file hashes, as the reference.

## Files (`ida\out\sub-final2\`)

| Path | Contents |
| --- | --- |
| `merge-plan.tsv` | All 1,666 candidates: decision, root, direct owners, chunks, entry edges and reason. |
| `alias.tsv` | Old name, old start, new owner, owner name, decision and reason for all 1,666 rows. |
| `ambiguous.tsv` | The 4 kept candidates and the 2 flagged merges. |
| `data-types.tsv` | Scope (window / below-window / retype), range, bytes, class, layout, count and evidence. The window rows sum to 34,618. |
| `data-items.tsv`, `data-structs.tsv` | The IDA item plan (2,998 items) and the struct declarations. |
| `functions.tsv` | The SUB_FINAL2 function index, with `merged_old_starts`. |
| `counts.txt`, `ledger-delta.tsv` | The recount and the byte ledger against I2's masks. |
| `sanity.txt`, `switches.tsv` | Sanity checks and the 40 switch tables. |
| `raw\apply_pass{1..4}{.txt,_changes.tsv,_delta.tsv}` | Per-pass logs, actions and item and function deltas. |
| `raw\plan_status.txt`, `raw\ptr-scan.tsv`, `raw\query_seed\` | Plan log, the pointer scan, and the query dumps. |
| `raw\dataplan_checks.txt`, `raw\verify.txt` | Byte assertions (0 FAIL). |
| `raw\dis_final.txt`, `raw\dis_readers.txt` | Disassembly for the citations. |
| `raw\mask_final2_*.bin`, `raw\mask-diff-h10.tsv`, `raw\recount_status.txt` | Masks, the H10 comparison and the recount log. |
