# 102 — MAIN unnamed residue: every byte outside the named mask (Lane L5)

> Lane L5, model `claude-opus-5-5`. Owner-side, read-only static analysis of `decrypted\FT3D_MAIN_ver102_EXP.bin`
> (H8SX, big-endian, base 0, so file offset = address). One private database, `ida\db\jobs\L5_MAIN_RESIDUE\L5_MAIN_RESIDUE.i64`,
> made with `--copy-from ida\db\jobs\K1_MAIN_FINAL4\K1_MAIN_FINAL4.i64`. No other database was opened, `run_ida.py` was not run,
> and nothing was connected to or written to a radio. `Firmware\` and `decrypted\*.bin` are unchanged (sha256 `8e3ecd05409b2c31…` /
> `b93570b3c2f69ccb…`, checked at the start and the end). Published masks and seeds were not edited.
> Tables: `ida\out\main-unnamed\`. Jobs: `ida\jobs\l5_dump.py`, `ida\jobs\l5_apply_typing.py`.

## Verdict

The MAIN residue is **exactly 7,365 B**: 505,684 content bytes (`0x000000`–`0x07B753`) minus 498,319 named bytes. The named
bytes are the 497,451 set bytes of `final4_named_mask.bin` plus doc 95's 868 B. That gives 730 raw runs, split here into 765
classified pieces. Every byte has a class, and the class totals add up to 7,365. **Only 43 B (0.0085 % of content) cannot be
named from this package.** They are one odd-aligned, code-shaped block at `0x069A7F`–`0x069AA9`. H8S/H8SX fetches instructions
only from even addresses, so this block cannot run where it sits. Nothing references it, and its bytes are not a table or text.

The rest can be named:

- **3,337 B have a Confirmed typing.** Each one either has a reference from proven code, is already an item in the database
  (the mask has a hole there), or has content that settles the type (text, BE32 cells pointing at code).
- **3,934 B have an Inferred typing.** 2,880 B of this is dead code: it decodes cleanly and has 0 inbound references from proven
  code or pointer cells anywhere in the image. Another 957 B are table interiors typed from their content only.
- **51 B are 0x00/0xFF fill.**

If the 3,337 Confirmed bytes are credited, MAIN named/typed goes from 498,319 to **501,656 / 505,684 = 99.20 %**. The headline
goes from 962,582 to **965,919 / 1,029,972 = 93.78 %**. Applying these typings to the private database lost no code bytes, and
all 368,624 proven bytes are still code.

Two findings are about the published masks, not the residue:

- **4 B are proven code that the proven mask missed.** They are `0x006A0C` and `0x0077F8`, both reached by fall-through
  (Confirmed).
- **At least 126 B of the proven mask are data.** The clearest case is a BCD frequency table at `0x03799E`–`0x0379E7` plus
  `0x037A02`–`0x037A13` (92 B), which proven code loads as data. The descent reached it only through fnindex seeds.

## Method

1. **Denominator.** The content is `0x000000`–`0x07B753`, which is 505,684 B. Docs 22, 33 and 36 and
   `ida\out\h8s-decode\coverage.txt` all fix this range and match the fnindex ranges 229,376 + 139,264 + 137,044 (doc 33).
   *Confirmed* that all 542,892 bytes from `0x07B754` to `0x0FFFFF` are `0xFF`, and that `final4_named_mask.bin` has 0 bits set
   past `0x07B753`.
2. **Residue.** The residue is the content minus (`final4_named_mask.bin` OR doc 95's 13 ranges).
   - The named mask popcount is 497,451.
   - All 868 doc-95 bytes were clear in both final4 masks before the union (asserted).
   - The union is 498,319, so the residue is 7,365 B in 730 runs.
   - The residue is saved as `residue_mask.bin`, 505,684 bytes with 1 = residue (sha256 prefix `0d453850c6a36595`).
3. **Database view** (`l5_dump.py`, read-only, on the K1 copy). For every run it records the IDA items that overlap it, every
   xref into it, and a list of all 130,679 heads over `0`..`0x7B753`, with their crefs and drefs.
4. **Whole-image reference scans** (offline, `offline\l5_evidence.py`, `l5_who.py`). For every residue address:
   - every BE32 occurrence at any of the 505,681 offsets, tagged by where it sits: an operand of a proven or named code head, a
     named table cell, residue, or a coincidental straddle;
   - every `jsr`/`jmp @aa:24` (`5E`/`5A 00 xx xx`);
   - every relative or absolute branch target of all IDA code heads, decoded with the binutils H8SX oracle
     (`h8s-decode\work\bu_all.tsv`).

   Indirect dispatch in proven code is `jmp`/`jsr @erN` loaded from BE32 tables, plus one `bra r0.w` at `0x076308`. The BE32 scan
   covers the first kind, and the second is handled in the window section.
5. **Classification** (`offline\l5_classify.py`). Rules run in a fixed order:
   - closed window;
   - proven fall-through;
   - a hole inside an IDA item whose other bytes are named;
   - the 2-byte tail of a named 6-B record or BE32 cell;
   - adjacent label text;
   - referenced data;
   - fill;
   - unreferenced text;
   - BE32 pointer cells;
   - low-diversity tables;
   - clean-decode dead code.

   Dead code must decode cleanly and end in `rts`/`rte`/`bra`/`jmp`, or follow a terminator and flow into code. It must have 0
   inbound edges from proven code or pointer cells. Edges from named but unproven code are listed in the evidence.

   After that, 224 pieces were adjudicated by hand in `offline\l5_overrides.py`, after reading the bytes, the decode and the
   reference scans. This covered split runs, records mistaken for code, label headers, and the `0x06B4B0` routine. The emitter
   (`offline\l5_emit.py`) asserts that the pieces tile the residue mask exactly.
6. **Proof on the private database** (`l5_apply_typing.py`). Every Confirmed typing was applied as follows:
   - BE32 cells became dword plus offset.
   - Labels and tables became byte arrays.
   - At `0x006A0C`/`0x0077F8` the stale 2-byte heads were deleted and the 6-byte instruction was created.
   - Code holes got `create_insn`.

   The job then compared a per-byte code/data/unknown snapshot taken before and after (`apply-typing-summary.txt`).

**Not done.**
- Inferred typings (dead code, content-only tables) were not applied.
- 22 Confirmed rows (64 B) were skipped because a named neighbour's IDA item crosses the row edge. Fixing them means retyping
  named bytes, which is outside the residue.
- No published mask or seed was changed.
- The fnindex-only proven runs are covered by docs 99–101. They were not re-audited here beyond the bytes next to the residue.

## Findings

### Class totals (`class-summary.tsv`; Confirmed/Inferred is the class label, T1–T4 is the typing tier)

| class | pieces | bytes | class Confirmed | T1 Confirmed typing | T2 Inferred typing | T3 fill | T4 un-nameable |
|---|---:|---:|---:|---:|---:|---:|---:|
| padding/fill | 10 | 51 | 51 | 0 | 0 | 51 | 0 |
| string/label | 128 | 1,073 | 1,062 | 1,062 | 11 | 0 | 0 |
| pointer table | 56 | 192 | 192 | 160 | 32 | 0 | 0 |
| value table | 215 | 1,860 | 905 | 903 | 957 | 0 | 0 |
| record struct | 143 | 917 | 917 | 917 | 0 | 0 | 0 |
| dead code | 135 | 2,880 | 2,878 | 0 | 2,880 | 0 | 0 |
| mid-instruction/garbage | 71 | 206 | 206 | 163 | 0 | 0 | 43 |
| closed-window interior | 4 | 128 | 128 | 128 | 0 | 0 | 0 |
| reached-code gap | 3 | 58 | 4 | 4 | 54 | 0 | 0 |
| Unknown | 0 | 0 | — | — | — | — | — |
| **total** | **765** | **7,365** | **6,343** | **3,337** | **3,934** | **51** | **43** |

### 1. Proven code missing from the proven mask: 4 B (Confirmed)

The proven instruction falls through into a 6-byte H8SX bit-op on `@aa:16`. IDA had left a stale 2-byte head 2 B into that
instruction. The descent counted only that head's bytes, so the first 2 B of the instruction are missing from the mask.

| run | predecessor (proven) | bytes / oracle |
|---|---|---|
| `0x006A0C` (2 B) | `0x006A08 6e 5c 00 6d` mov.b @(0x6d,er5),r4l | `6a 10 8e a0 73 40` btst #4,@0x8EA0:16 |
| `0x0077F8` (2 B) | `0x0077F6 67 04` bst #0,r4h | `6a 10 81 7e 77 00` bld #0,@0x817E:16 |

On the private database both now decode as 6-byte instructions, and the old heads at `0x006A0E`/`0x0077FA` are gone. Proven
code bytes were 368,624 before and 368,624 after, so the proven mask would grow by 4 B.

### 2. Record-field target `0x01687E` (54 B, Inferred)

Proven code at `0x016864` does `7a 05 00 01 68 6e 5a 01 52 60`, which is `mov.l #0x01686E,er5` then `jmp @0x015260`. Record
`0x01686E` is `00 01 a1 7c 00 00 00 00 00 01 68 7e 00 01 68 bc`, holding the four pointers {0x01A17C, NULL, 0x01687E, 0x0168BC}.

Field +8 points at `0x01687E`, which is 20 clean instructions (`6a 0a ad 9c 7a 62 …`, ending `bra 0x0168F8`). The record
(12 B residue) is Confirmed. That `0x015260` calls through +8 is Inferred, the same grade as doc 72's `0x02A924`.

### 3. Data typed from references (T1, 3,337 B)

- **Settings records: 143 pieces, 917 B.** These are the 6-byte `{u16 value; u32 ptr 00FFxxxx}` records, plus a few 8-byte
  `{u32; ptr}` variants. 109 pieces (821 B) are loaded by a `mov.l #rec,er6/er5` that is right next to them, almost always
  followed by `jsr @0x03F628` or `@0x03F62E`. Examples:
  - `0x0169DC 7a 06 00 01 69 ee 5e 03 f6 2e` loads record `0x0169EE 00 01 00 ff ad 9c`.
  - `0x0200F8 7a 06 00 02 01 04` loads `0x020104 03 84 03 e6 00 ff ac 34`.

  34 pieces (96 B) are the 2–4-byte tails or heads of records whose other bytes are named.
- **Screen records: 6 × 32 B** at `0x028B6C`, `0x028BB4`, `0x028BF0`, `0x028C2A`, `0x028C62` and `0x028C8A`. Each is loaded by
  proven `mov.l #rec,er1` before the common record dispatch `0x028CBC` (docs 72 and 85). They are eight BE32 handler or label
  fields, for example `0x028C2A 00 01 88 a8 … 00 02 a9 24 00 03 ff a0`.
- **Labels: 1,062 B Confirmed.**
  - Length headers `00 0e` of the APRS weather/status labels, loaded by proven `mov.l` (`0x04C4E2` … `0x04E584`).
  - The DSP debug strings' `0d 0a` endings (`0x05AE70` …).
  - The APRS device-ID table bytes at `0x04C336`–`0x04C3A3`, which IDA had typed as code (`TH-D7`, `TM-D700`, `VX-8G`,
    `FTM-400D`).
  - `"YAESU FT1D\r\n"` at `0x045306`.
  - The fullwidth JIS X 0208 letter table `0x01BE74` (`23 61`…`23 7a`, `23 41`…`23 5a`, 126 B), and the JIS label count headers
    at `0x01AD1C`…`0x01AFEE`, which the BE32 cell table `0x01AE1C` points at.
  - Channel-group labels `G5-1`…`G0-5` at `0x00FA30` (182 B).
  - The digit-pair table `"37"…"99"` plus hex digits at `0x0044DA` (164 B).
- **Value tables with a proven base load (870 B)** and **mask holes inside IDA word items (31 B).** Examples:
  - The BCD word table `0x00585A`, loaded by `mov.l #0x585A` at `0x026058`, and its continuation `0x0058AF`.
  - The bit-mask table `0x01682E`, base loaded by `mov.w @(0x1682c:32)` at `0x016812`.
  - `0x03F1C6`, base loaded by `mov.w @(0x3f1c4:32,er4)` at `0x03F196`.
  - The codec-size table `0x05BBD2 0c 00 0d 0e 2d 00 41 5a` (K10).
  - The 18 single bytes inside the IDA word switch table `0x019A9E`.
- **Pointer cells: 160 B Confirmed.** These are BE32 cells whose low half (or whole cell) is residue and whose value is an IDA
  code head. Examples: `0x01026A 00 01 05 4a`, `0x052A72 00 05 2a ce`, and the 6-cell table `0x0048C0` that points at the
  `{u16 3; 'VFO''VDR'}` label records.
- **Mid-instruction mask holes: 163 B.** These are bytes inside instructions whose other bytes are named.
  - 51 holes are in IDA items. Examples: `0x0152A3` inside `0x0152A2 6a 10 a9 ee 73 70`, and `0x076D5D` inside
    `6a 28 00 fe e0 03`.
  - 78 B are in the named but IDA-undecoded routines `0x06B4B0`–`0x06B555` and `0x06B670`–`0x06B699`. The first one dispatches
    through BE32 tables `0x06B556`, `0x06B582` and `0x06B5AA`, and nothing references either routine.
  - The rest are operand bytes of the named instructions at `0x016AD6`, `0x01E1BE`, `0x050734` and `0x076C00`.

### 4. Closed window (128 B, Confirmed)

- `0x078546`–`0x07859F` (90 B) is the 45-entry u16 offset table for the `bra r0.w` switch at `0x076308`. It is read by
  `0x0762FE 78 01 6b 20 00 07 85 46` (mov.w @(0x78546:32,r0l.b),r0) and matches doc 95's `switch-078546.tsv`.
- `0x0785A7`, `0x0785CA` and `0x0785D4` (38 B) are inside the 16-byte nibble-to-code maps at `0x0785A0`/`B0`/`C0`/`D0`. They are
  indexed by `0x0761B8`/`AE`/`A4`/`9A` `78 01 6a 29 00 07 85 x0` (doc 95, line 213).

### 5. Dead code (2,880 B in 135 pieces; class Confirmed, typing Inferred)

All 135 pieces decode cleanly with the oracle. None has an inbound BE32 operand or cell, abs24 `jsr`/`jmp`, or branch from any
proven code head.

- **55 unreferenced routines or stubs (1,696 B).** Examples:
  - `0x00835E`–`0x00840B`, 174 B, ending `rts` at `0x00840A`; the label `"MUTE : TX"` sits in front of it.
  - `0x024CCA`, 120 B.
  - `0x00CD3E`, 94 B.
  - `0x04FE8E`, 86 B.
  - `0x046482`, 176 B of case stubs that fall into fnindex-only `0x046532`.
  - The `fd 0x 6a 8d b0 8d 7a 03 …` case-stub families at `0x0528DA`–`0x053372`, `0x0529AC` and `0x0533F6`, which flow into
    fnindex-only `0x052A14`/`0x05343C`.
- **76 fragments after a terminator inside proven routines (1,052 B).** These include 18 `jsr @0x03FFA0`/`@0x03FF9C`, each
  sitting between a `bra .+4` and the routine's `rts` and skipped by that `bra`. Example:
  `0x0169E6 40 04 | 5e 03 ff a0 | 54 70`.
- **4 pieces (132 B) reached only from named, unproven code.**
  - `0x06259A`, called by `jsr @0x625d0` at `0x062624`.
  - `0x01758E`, registered by `mov.l #0x1758E` at `0x017570`.
  - `0x076C06`, the USB-module tail that `0x076BE8` branches to; doc 72 says that module is reached only through the window.
  - `0x01E1C6`.

### 6. Un-nameable: 43 B

`0x069A7F`–`0x069AA9` is `6a 0c b3 f5 1c 9c 46 04 6a 89 b3 f4 …`. It is code-shaped but starts at an odd address, straight
after the 0x20-filled buffer of label record `0x069A48 00 35`. The named bytes after it (`0x069AAA`–`0x069AB4`) are also odd
relative to their instructions. There are 0 references. The block looks like a stale, byte-shifted copy of code. The CPU cannot
execute it in place, and its bytes are neither text nor a table.

### 7. The typings do not move any code (`apply-typing-summary.txt`; private database only)

- **Rows.** Of 754 typing rows:
  - 351 rows (2,865 B) were applied;
  - 149 rows (408 B) needed no change, because they were already typed;
  - 22 rows (64 B) were skipped because they cross a named item;
  - 232 Inferred rows (3,934 B) were deliberately not applied.
- **Image.** The database bytes match the image over all 505,684 B.
- **Code outside the residue.** No code byte was lost. 91 B gained an IDA code item: these are named bytes of the IDA-undecoded
  routines `0x06B4B0`/`0x06B670`, and of the instructions at `0x016AD6`, `0x050734`, `0x006A0C` and `0x0077F8`.
- **Proven bytes.** Proven bytes that are code: 368,624 before, 368,624 after.
- **Residue.** Residue bytes typed in the database went from 4,893 to 6,400 (code 4,339 → 3,230, data 3,170). Mis-decoded
  "code" over tables and labels became data.
- **Layout hash after:** `c1fc19e13e0e12e3`.

### 8. Side finding: data inside the proven mask (`proven-data-candidates.tsv`)

All of these are inside `final4_proven_mask.bin` and on K1's list of fnindex-only runs.

**Confirmed data, 126 B.** Proven code loads each base as data:

| range | what it is | proven load |
|---|---|---|
| `0x03799E`–`0x0379E7` (74 B) and `0x037A02`–`0x037A13` (18 B) | BCD frequency table `0x037988`; cells such as `14 48 40 00` and `00 00 45 34` | `0x03793E 7a 06 00 03 79 88` |
| `0x01E22C` (12 B) | data | `mov.l #0x1e22c` at `0x01E174`, `0x01E360`, `0x032630` |
| `0x074310` (18 B) | `00 00 'AH060M'` + FF | `0x0742F2 7a 05 00 07 43 10` |
| `0x065A88` (4 B) | `'312'` + 00 | `0x06597E 78 40 6a 2b 00 06 5a 88` |

For the BCD table, IDA decodes the `14 xx`/`00 00` cells as `or.b`/`nop`. The `bcs` it sees at `0x037A0C` (`45 90`) is what pulls
`0x03799E` into the descent.

**Inferred data candidates, 120 B.** These have only content-level evidence:
- the byte tables `0x04C3C8` (`02 03 04 ff 05 …`), `0x02D704`/`0x02E2D8`/`0x03400E` (`27 29 2a 29`) and
  `0x02D7FE`/`0x02E3D2` (`20 22 23 22`);
- the fill at `0x00245C`;
- and others.

These bytes stay named; only the proven figure would fall. Docs 99–101 own the fnindex audit.

## USB relevance

- **Q1, USB.** None of the 7,365 B is a USB descriptor, endpoint table or USB register access. The only residue next to USB code
  is the 2-byte operand tail of `0x076C00 6b f0 00 ff 63 14` and its `pop`/`rts` at `0x076C06`, inside the USB module that doc 72
  says is reached only through the closed window. The window residue is the doc-95 switch table and nibble maps (128 B). The
  USB answer from docs 64, 73–75 and 95 stands.
- **Q2, SDR.** No sample buffer, DMA descriptor or IQ path is in the residue. Nothing new.
- **Q3, DSP.** The residue holds the DSP debug-console strings' CRLF bytes (`0x05AE70` …, `"DSP>CPU:"`/`"CPU>DSP:"`) and the
  codec-size table `0x05BBD2` (K10). No new DSP opcode or path was found.

## Open (most valuable first)

1. **Make the proven mask agree with the bytes.**
   - Add `0x006A0C`/`0x0077F8` (+4 B; re-create the two 6-byte instructions).
   - Demote the 126 B of Confirmed data in `proven-data-candidates.tsv`, starting with the `0x03799E`/`0x037A02` BCD table, which
     the `0x037A00`/`0x037A02` fnindex seeds pulled in.
   - Cross-check against docs 99–101 before any further demotion.
2. **Credit the T1 typings in the next named mask** (+3,337 B, giving 501,656 named). Retype the 22 skipped edge rows (64 B)
   together with their named neighbours.
3. **Settle `0x015260`'s call-through of record field +8** to promote `0x01687E` (54 B). Settle the 4 dead pieces that only
   unproven code reaches (`0x06259A`, `0x01758E`, `0x01E1C6`, `0x076C06`).
4. **Find the bases of the content-only tables** (957 B T2) so they can move to Confirmed. These are the curve tables at
   `0x04E88A`–`0x04EAC0` and `0x036100`–`0x036B60`, and the 22-B record table at `0x03FFF4`.

## Files

| file | content |
|---|---|
| `ida\out\main-unnamed\runs.tsv` | 765 pieces tiling the 7,365 B: start, end, raw run, class, subclass, class confidence, typing, typing confidence, tier, first 32 bytes, evidence |
| `ida\out\main-unnamed\class-summary.tsv` | per-class pieces and bytes, class confidence, T1–T4 tiers (totals 7,365) |
| `ida\out\main-unnamed\proposed-typing.tsv` | 754 typable pieces with database action and confidence |
| `ida\out\main-unnamed\apply-typing.tsv`, `apply-typing-summary.txt` | per-row result and neutrality counts on `L5_MAIN_RESIDUE` |
| `ida\out\main-unnamed\proven-data-candidates.tsv` | proven-mask bytes that are data (126 B Confirmed, 120 B Inferred) |
| `ida\out\main-unnamed\residue_mask.bin` | 505,684-byte mask, 1 = residue (7,365 set) |
| `ida\out\main-unnamed\offline\` | `l5_lib.py`, `l5_evidence.py`, `l5_classify.py`, `l5_overrides.py` (+ `overrides.tsv`), `l5_emit.py`, `l5_who.py`, `l5_show.py`, `l5_detail.py`, `l5_review.py`, `l5_features.py` |
| `ida\out\main-unnamed\work\` | IDA dump (`ida_items.tsv`, `ida_xrefs.tsv`, `ida_heads.tsv`), `evidence.json`, review listings |
