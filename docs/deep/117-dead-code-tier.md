# 117 — L5's dead-code tier, re-proved (Lane M5)

> Lane M5, model `claude-opus-5-5`. Owner-side, read-only static analysis of `decrypted\FT3D_MAIN_ver102_EXP.bin`
> (H8SX, big-endian, base 0, so file offset = address). One private database, `ida\db\jobs\M5_DEADCODE\M5_DEADCODE.i64`,
> made with `--copy-from ida\db\jobs\L1_MAIN_FINAL5\L1_MAIN_FINAL5.i64`. No other database was opened, `run_ida.py` was not run,
> and nothing was connected to or written to a radio. `Firmware\` and `decrypted\*.bin` are unchanged (sha256 `8e3ecd05409b2c31…` /
> `b93570b3c2f69ccb…`, checked at the start and the end). No published mask, seed or other lane's file was edited.
> Tables: `ida\out\dead-code-tier\`. Jobs: `ida\jobs\m5_dump.py`, `ida\jobs\m5_apply.py`.

## Verdict

**134 of L5's 135 dead-code pieces (2,874 B) are now Confirmed dead.** Each one decodes cleanly as H8SX, and every instruction
boundary falls inside the piece. Each one ends in `rts`/`bra`, or exactly at the start of an existing real instruction. None
of them has an inbound edge from code that can run. One of the 134 is L5's `0x01E1C6`, which is now split: 22 B of dead code
plus the 2 B operand tail of the 8-byte instruction at `0x01E1C0`.

**The 135th piece, `0x018FAA` (6 B), is not dead.** Six `jsr @0x18faa` instructions call it. They sit in seven case handlers at
`0x01794E`–`0x017989`, and those handlers are fields 1–7 of record `0x01792E`. Proven code at `0x017924` passes that record to
the indexed record dispatcher `0x015260`, so the piece is reached under the `0x015260` rule (Inferred). Its typing as code is
Confirmed by the six direct calls.

Under the I12 convention (doc 69: code typed as code counts as named, reachable or not), all **2,880 B can be credited**:

- MAIN named goes from **501,656 to 504,536 / 505,684 = 99.77 %**.
- The headline goes from **965,919 to 968,799 / 1,029,972 = 94.06 %**.
- Proven is unchanged at **364,786**.

Applying the typing on the private database moved nothing outside the pieces. All 364,786 proven bytes are still code.

**Task 2:** all 22 of L5's proven-data candidates (126 B Confirmed + 120 B Inferred) are already outside the proposed final6
proven mask. Each is in `drop_runs.tsv`, and L2, L3 or L4 had classed each one DATA-MISTYPED. So the **proven delta is 0 B**.
For data typing:

- 21 ranges (236 B) have a proven reader that loads the address as data, so they are Confirmed data.
- `0x04C3C8` (10 B) has no direct reader and stays Inferred data.

## Method

All of this was run in this session. The scripts are in `ida\out\dead-code-tier\offline\`.

1. **Database view** (`m5_dump.py`, read-only, on the L1_MAIN_FINAL5 copy). It writes three files:
   - every head over `0`–`0x7B753` (124,367 code heads);
   - IDA's own forced-code decode of each piece, which serves as a second decoder;
   - every xref into a piece.
2. **Real heads.** There are 113,638 proven instruction heads. They come from tiling all 946 runs of
   `final6_proven_mask.bin` with the binutils oracle (`h8s-decode\work\bu_all.tsv`). All runs tiled exactly, with 0 mis-tiles.
   Real heads are those proven heads, the IDA code heads that are not in data, and the oracle heads of every piece.
3. **Data mask.** Bytes count as data if they are an IDA non-code item, or if L5 typed them as data, label, record or cell
   (520 L5 rows, 37,853 B in total).
4. **Forward closure from proven code** (`m5_scan.py`). Starting from the 113,638 proven heads, the closure follows these edges:
   - fall-through after non-terminators;
   - `bra/s` delay slots;
   - relative `b**`/`bsr`, including `bra/bc` and `bra/bs`;
   - absolute `jsr`/`jmp @aa:24`;
   - `jsr`/`jmp @@aa:8`/`@@vec`, resolved through the BE32 cell they read;
   - every `mov.l #imm` whose value is an instruction start. This covers er1/er5 callbacks and RAM-cell callbacks, which are
     registered by immediates.
   It is also seeded with every BE32 at an even offset outside real code whose value is a code head, a piece head or an
   undecoded code-shaped address (8,802 cells). That last case is deliberately over-inclusive: it covers record and jump
   tables that IDA never typed.
   The closure stops at the data mask. It reaches 117,262 instruction starts. **No proven code falls into the data mask.**
5. **Inbound scan for each piece, whole image** (`m5_scan.py`). Every candidate edge was listed and its source classified:
   - BE32 values at any offset, including odd ones;
   - `5E`/`5A` + abs24 at any offset;
   - oracle branch decodes at every even offset;
   - operand immediates and addresses of real heads (`#imm`, `@aa:24/32`, `@(d:32,ERn)`, and 16-bit forms below `0x8000`);
   - fall-through candidates ending at the piece start.
   Extra scans (`m5_be24.py`) covered 3-byte BE values and u16 halves inside data items.
6. **Indirect dispatch census.** All 264 proven `jmp`/`jsr @ERn` sites were checked:
   - 162 load from `@(tbl:32,er3)`; 33 from RAM cells `@aa:16`; the rest from `@ERn`, record fields, `mov.l #imm`, or a
     register set earlier (the window register helpers and `0x015224 5d 10`).
   - All of these are BE32 or immediate forms, so the scans above cover them.
   - There are two u16 offset dispatches. The first is `bra r0.w` at `0x076308` (table `0x078546`, doc 95; its targets lie in
     the window).
   - The second is `0x01919A 78 60 6b 26 00 01 9a 9e` + `7a 16 00 01 48 a0` + `5d 60` (`jsr @er6` = `0x0148A0` + u16). All
     206 entries of table `0x019A9E` hit proven heads. The table ends where code begins, at `0x019C3A 7a 05`.
7. **Verdict rule** (`m5_classify.py`). A piece is **Confirmed dead** when all of the following hold:
   - (a) The oracle and IDA decodes agree, no instruction is undecodable, the decode ends exactly at the piece end, and branch
     targets land on boundaries.
   - (a) No real instruction straddles the piece start, and existing IDA heads inside the piece sit on boundaries.
   - (a) The piece ends in a terminator, or exactly at a real code head.
   - (b) The piece is outside the closure, and every code-shaped inbound comes from code outside the closure. Each such case was
     re-read by hand (Findings 2).
   - (b) Every other hit is not executable. Such a hit lies at an odd offset, mid-instruction, in data or text, or is a
     straddle, and no real edge ever enters it.
8. **Proof on the private database** (`m5_apply.py --reopen`). Every Confirmed row became `create_insn`, and per-byte state was
   snapshotted before and after. The lengths IDA created equal the oracle lengths in all 135 rows.
9. **Citations.** `m5_verify.py` byte-checks the 100 citations in this document against the image: **100/100 OK** (98 byte compares and 2 existence checks)
   (`verify.txt`).

**Not done.** The database is a copy of L1_MAIN_FINAL5, as assigned, and not M1's FINAL6 seed (doc 113), which already exists. M1's
L5 data rows were modelled offline through the data mask (step 3) and not applied in the database. Runtime values that the
`0x015260` dispatch depends on (`@0xAD68`, `@0xAD9D`) are the standard Inferred assumption.

## Findings

### 1. Result per piece (`pieces.tsv`, `summary.txt`)

| class | rows | bytes | typing |
|---|---:|---:|---|
| dead code, Confirmed | 134 | 2,872 | code, Confirmed |
| operand tail of named insn `0x01E1C0` | 1 | 2 | code, Confirmed |
| reached through `0x015260` dispatch (not dead), Inferred | 1 | 6 | code, Confirmed |
| **total** | **136** | **2,880** | **2,880 Confirmed** |

How the 135 pieces end:

| ends at | pieces | bytes |
|---|---:|---:|
| `rts` | 47 | 1,484 |
| `bra` | 27 | 312 |
| exactly at a proven instruction | 52 | 598 |
| exactly at a named, unproven instruction | 9 | 486 |

What comes before them:

| predecessor | pieces |
|---|---:|
| a terminator (68 `bra`, 43 `rts`, 2 `rts/l`) | 113 |
| a data item or label | 17 |
| no item | 3 |
| a non-terminator inside dead code (`0x076C00`, `0x01E1C0`) | 2 |

**134 of the 135 pieces are outside the closure.** `0x018FAA` is the only one inside it, and it gets there only through the
record-cell seed in step 4, which leads into Finding 4. All 18 single-`jsr @0x3FFA0`/`@0x3FF9C` stubs are confirmed. Each sits
between a proven `bra .+4` and its `rts`. 16 have no inbound branch at all. The other two (`0x0169E8`, `0x05DCF8`) are branched to
only from dead prefixes (Finding 2).

### 2. Pieces whose only code-shaped inbound comes from dead named code (Confirmed)

Each source below was re-checked whole-image with `m5_who.py`, covering BE32 at every offset, `5E`/`5A` abs24, and relative
branches from every even offset.

| piece | inbound | why the source is dead |
|---|---|---|
| `0x01758E` (12 B) `fc 00 6a 8c ba 33 5e 01 a0 a4 54 70` | `0x017570 7a 01 00 01 75 8e 5e 01 52 06` registers it as an er1 callback for `0x015206` | Routines `0x017538`–`0x017587` follow `rts` `0x01756E 54 70`. They have 0 BE32, abs24 or relative refs. |
| `0x053496` (42 B) | `jsr @0x534a8` at `0x053532` and `0x05353E` (`5e 05 34 a8`) | Routine `0x05351A`–`0x053543` follows `rts` `0x053518`. It has 0 refs, and so does `0x0534C0`–`0x053519`. |
| `0x06259A` (92 B) | `0x062624 5e 06 25 d0`. The four relative "sources" `0x06257A`… are the ASCII labels `"DIRECT ENTRY"`/`"SEARCH"` (`0x062576 44 49 52 45 43 54 …`). | Routine `0x0625F6`–`0x062629` follows `rts` `0x0625F4`. It has 0 refs. |
| `0x076C06` (4 B) `6d 72 54 70` | Fall-through from `0x076C00 6b f0 00 ff 63 14`, plus `beq` at `0x076BE8 47 1c` | USB-module routine `0x076B20`–`0x076C09`, after `rts/l` `0x076B1E 54 02`. It has 0 refs. The 11 BE32 hits (for example `0x06256C 00 07 6b 84`) are straddles of a `#7` immediate into the next `6b` instruction. |
| `0x0169E8` (4 B) `5e 03 ff a0` | `beq` at `0x0169DA 47 0c` | It sits in the 10-B prefix `0x0169D2 5e 01 51 ec 47 14 aa 01 47 0c`, which has 0 refs. The routine is entered at `0x0169DC` (abs24 `jsr` from P `0x015C90`/`0x015CAC`). `0x0169CC 00 31 00 ff aa 56` is a record loaded by P `0x0169B2`. |
| `0x05DCF8` (4 B) | `bne` at `0x05DCDE 46 18` | `0x05DCDA`–`0x05DCDF` follows P `bra` `0x05DCD8 40 06`. It has 0 refs. |
| `0x018766` (48 B) | `beq` at `0x01872A`/`0x01872E` | Both lie in dead piece `0x018728`, which follows P `bra` `0x018726 40 6e`. |
| `0x06DBE0` (2 B) `54 70` | `jsr` at `0x061C54`/`0x0669DA` (`5e 06 db e0`) | Both are dead pieces, each after a `bra .+4`. |

### 3. `0x01E1C6` — L5's split point was mid-instruction (correction to doc 102)

- Named `0x01E1C0 78 b0 6b 26 00 01 e1 de` is one 8-byte `mov.l @(0x1e1de:32,er3),er6`, and the IDA item is 8 B.
- L5's residue piece starts at `0x01E1C6`, so its first 2 B (`e1 de`) are the tail of that instruction. The oracle happened to
  decode `e1 de` as `and.b`. L5's own row `0x01E1C2`–`0x01E1C5` already calls the bytes before them an operand tail.
- **Correct split:**
  - `0x01E1C6`–`0x01E1C7` = operand tail (typing code, Confirmed; no database change needed);
  - `0x01E1C8`–`0x01E1DD` = dead code (`01 10 6d 75` `ldm.l` … `rts` `0x01E1DC`).
- The whole routine `0x01E1A4`–`0x01E1DD` follows P `rts` `0x01E1A2`. The only refs into `0x01E1A0`–`0x01E1C5` are relative
  branches to that `rts`. The routine's internal `beq` `0x01E1A8 47 24` and `bne` `0x01E1AE 46 2c` are what L5 counted as
  "unproven inbound".

### 4. `0x018FAA` is reached through the `0x015260` record dispatch (correction to doc 102)

- **The call.** `0x017924 7a 05 00 01 79 2e 5a 01 52 60` is proven. It loads `er5 = 0x01792E` and jumps to `0x015260`.
- **The record.** `0x01792E` is `00 01 a0 d4 | 00 01 79 4e | 00 01 79 56 | 00 01 79 5e | 00 01 79 6a | 00 01 79 72 | 00 01 79 7a | 00 01 79 82`.
- **The helper** (P):
  1. It sets `er2 = @0xAD68` (`0x01526A 7a 02 00 00 00 00 6a 0a ad 68`).
  2. If `@0xAD9D` is non-zero, it takes field 0 (`0x01527C 6a 0c ad 9d 47 06 01 00 69 56`).
  3. Otherwise it takes field `[AD68]` (`0x015288 10 72 0a a5 01 00 69 56 47 08 5d 60`, `jsr @er6`).
- **The handlers.** Fields 1–7 are seven handlers, `mov.b #n,r4l; jsr @0x18faa; bra rts`. The first is `0x01794E fc 00 5e 01 8f aa 40 32`.
  The others call from `0x017958`/`6C`/`74`/`7C`/`84`, each `5e 01 8f aa`.
- **The target.** `0x018FAA 6a 18 8a ac 61 c0` (`bnot r4l,@0x8aac:16`) is the twin entry of P `0x018FA2 6a 18 8a ab 61 c0 40 06`.
  Both reach `0x018FB0 6a 18 aa 30 70 60 54 70`.
- **Not reached by the descent.** The K1/L-wave descent does not take fields 1..n of `0x015260` records, so `0x01794E`–`0x017989`
  (60 B, named, not proven) and `0x018FAA` (6 B) are reachable but unproven. This is a **proven-candidate proposal of 66 B
  under an Inferred rule**. It is not credited here.

### 5. Coincidental hits (recorded per piece in `pieces.tsv`)

All of the following were shown never to be entered by a real edge, and none is in the closure:

- straddles across two proven instructions, for example `0x05E350 00 01 0a 04` into `0x0109F0`'s interior;
- BCD cells, for example `0x037E9C 00 00 84 09` → `0x008409` (odd);
- odd-offset BE32;
- label text, for example `"MUTE : OFF"` at `0x008318`, whose bytes decode to branches into `0x00835E`;
- the 58 three-byte and 18 u16 matches (`work\be24.txt`). All of these are operand bytes of proven instructions, glyph data, or
  low halves of BE32 pointers whose high half differs.

### 6. Applying the typing is byte-neutral (`apply-typing-summary.txt`)

- **Rows.** 135 rows (2,878 B) were applied. The 1 operand-tail row needed no change, because the DB item is already 8 B. No row
  was skipped or partial.
- **Pieces.** Piece bytes that are DB code went from 2,230 to 2,880.
- **Bytes outside the pieces.** **0** state changes, **0** code bytes lost and **0** heads added or removed.
- **Proven bytes.** Proven-mask bytes that are DB code: **364,786 before, 364,786 after**.
- **Image.** The database bytes match the image file.
- **Layout hash:** `436a56f8c7d502c7` before, `69b5c8feba5cfb1e` after.

### 7. Task 2 — L5's proven-data candidates (`proposed-demotions.tsv`)

All 22 ranges, 246 B in total, have **0 bytes in `final6_proven_mask.bin`**. Every range lies inside `drop_runs.tsv`, and L2, L3
or L4 had classed each one DATA-MISTYPED. **Proven delta: 0 B** (already applied by the L-wave reconciliation). Named is
unchanged, but each should be retyped as data in the next seed (M1's recipe).

**L5's 126 B Confirmed.** Each still has a proven data load:

| range | proven reader |
|---|---|
| `0x03799E`/`0x037A02` | `0x03793E 7a 06 00 03 79 88`. The table header at `0x037988` is `00 08 00 11`, meaning 17 × 8 B, ending at `0x037A13`. |
| `0x01E22C` | `0x01E174 7a 05 00 01 e2 2c`, used indexed |
| `0x074310` | `0x0742F2 7a 05 00 07 43 10`, then `eepmov.w` |
| `0x065A88` | `0x06597E 78 40 6a 2b 00 06 5a 88` |

**L5's 120 B Inferred → 110 B Confirmed data, 10 B still Inferred.** Each reader below is proven and dereferences the address
as data:

| range | proven reader | how the data is used |
|---|---|---|
| `0x00245C` (16) | `0x002416 7a 05 00 00 24 5c` | `eepmov.w` block copy (6 sites) |
| `0x024000` (6) | `0x023F9E 78 40 6a 2b 00 02 40 00` | direct byte read |
| `0x02D704`, `0x02D7FE`, `0x02E2D8`, `0x02E3D2` (4 each) | `7a 05 00 02 d7 04` / `… d7 fe` / `… e2 d8` / `… e3 d2` | `bsr` to `add.l er3,er5; mov.b @er5,r3l` (`0x02D71A 7a 63 00 00 00 ff 0a b5 68 5b`) |
| `0x03400E` (4) | `0x034004 7a 05 00 03 40 0e` | same pattern |
| `0x02E640`, `0x033B70` (6 each) | `0x02E61A 7a 05 00 02 e6 40`, `0x033B4A 7a 05 00 03 3b 70` | `jsr 0x3F768` (`6c 5c ac ff`, FF-terminated scan) |
| `0x03531E` (16) | `0x0352EC 7a 06 00 03 53 1e` and 3 siblings | `jsr 0x3F94C`, BCD |
| `0x035422` (16) | `0x0353D0 78 20 6a 25 00 03 54 22` and 3 siblings | direct reads |
| `0x05C600` (2) | `0x05C57C 7a 05 00 05 c6 00` | `jsr 0x5C9D6` (`6c 5c ac ff`) |
| `0x073908` (2) | `0x073ABA 7a 01 00 07 39 08`, plus a direct `0x074444 6a 2b 00 07 39 09` (an odd address, so it cannot be code) | direct read |
| `0x01E5EE` (8) | `0x01E5BE 7a 06 00 01 e5 ee` | `jsr 0x3F5EE` (`01 00 69 64` `mov.l @er6`) |
| `0x016642` (6) | `0x016634 78 40 6a 2c 00 01 66 42` | direct read |
| `0x0151E6` (6) | `0x01509A 78 30 6a 2b 00 01 51 e6` | direct read |

**Still Inferred:** `0x04C3C8` (10 B) `02 03 04 ff 05 06 07 08 09 ff`.

- Nothing reads it directly.
- It follows the APRS device-name table `0x04C32C`, which is `00 09` + 17 × 9-B FF-padded names and is read at P
  `0x04C2A8 7a 05 00 04 c3 2c`.
- As code it would be `stc`/`orc #0xff,ccr`/`xorc`/`ldc #8,ccr`.
- It is data by content only.

### Ledger (proposals only; masks and seeds not edited)

    MAIN proven  364,786   (+0; Task 2 delta 0, already out of final6)
    MAIN named   501,656 + 2,880 = 504,536 / 505,684 = 99.77 %
    Headline     504,536 + 464,263 = 968,799 / 1,029,972 = 94.06 %   (was 93.78 %)
    MAIN still unnamed: 1,148 B = 1,054 B L5 T2 tables/labels (lane M6) + 51 B fill + 43 B un-nameable (0x069A7F)

The named +2,880 B covers 136 ranges, each listed in `proposed-typing.tsv`. All of them are disjoint from the final6 named and
proven masks (asserted). They are: 2,872 B dead code, the 2-B operand tail at `0x01E1C6`, and the 6-B reached entry at `0x018FAA`.
If `0x018FAA` is held back, because it is not dead, the delta is +2,874.

## USB relevance

- **Q1, USB.** Only one piece touches the USB module: `0x076C06` (`pop r2; rts`), the tail of routine `0x076B20`–`0x076C09`.
  That routine writes `0xFFEE00` (`0x076BC2 01 7d 40 fd ee 00`), `0xFFEE2C` (`0x076B88 6a 89 ee 2c`) and `0xFF62F8`
  (`0x076BBA 01 00 6b a1 00 ff 62 f8`), and it has **0 inbound refs whole-image**. It is
  dead vendor-stack code, and that does not change the USB surface in docs 64, 73–75, 95 or 112.
- **Q2, SDR, and Q3, DSP.** No piece reaches a sample path or the DSP link. Nothing new.

## Open (most valuable first)

1. **Add a descent rule for the `0x015260` indexed record dispatch.** Its fields 1..n are called as `field[@0xAD68]`. It would
   prove `0x01794E`–`0x017989` and `0x018FAA` (66 B, Inferred). Other records passed to `0x015260`, `0x01522E` and `0x015206`
   may hide more handlers that are named but unproven.
2. **Re-apply this typing on M1's FINAL6 seed** (doc 113) and re-derive the named mask. Expected: +2,880 with no proven change.
3. **Retype Task 2's 246 B as data in the next seed** (L2/L3/L4 already list them). `0x04C3C8` needs a reader to become Confirmed.
4. **Prune the dead named code found next to the pieces.** It stays named (I12) and was never proven:
   - `0x0169D2` (10 B);
   - `0x017538`–`0x017587`;
   - `0x05351A`–`0x053543` and `0x0534C0`–`0x053519`;
   - `0x0625F6`–`0x062629`;
   - `0x076B20`–`0x076C05`;
   - `0x01E1A4`–`0x01E1C7`;
   - `0x05DCDA`–`0x05DCDF`.

## Files

| file | content |
|---|---|
| `ida\out\dead-code-tier\pieces.tsv` | 136 rows tiling L5's 135 pieces: class, confidence, typing, first bytes, evidence |
| `ida\out\dead-code-tier\proposed-typing.tsv` | 136 typing rows (2,880 B, all Confirmed) with DB action |
| `ida\out\dead-code-tier\proposed-demotions.tsv` | Task 2: 22 ranges, proven-mask status, reader, use, data confidence |
| `ida\out\dead-code-tier\apply-typing.tsv`, `apply-typing-summary.txt` | per-row DB result and neutrality counts on `M5_DEADCODE` |
| `ida\out\dead-code-tier\summary.txt`, `verify.txt` | totals; 100/100 citation byte-check and mask facts |
| `ida\out\dead-code-tier\offline\` | `m5_lib.py`, `m5_scan.py`, `m5_flags.py`, `m5_show.py`, `m5_review.py`, `m5_ctx.py`, `m5_who.py`, `m5_be24.py`, `m5_readers.py`, `m5_classify.py`, `m5_verify.py` |
| `ida\out\dead-code-tier\work\` | DB dump (`m5_heads.tsv`, `m5_idadec.tsv`, `m5_xrefs.tsv`), `scan.json`, `review.txt`, `readers.json`, `be24.txt` |
