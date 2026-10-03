# Three suspect tables and the 0x01A080 → RAM 0xFF476E copy (Lane I9)

> Lane I9, model `claude-opus-5-5`. The private DB is `I9_MAIN`. It was seeded with `--copy-from ida\db\jobs\MAIN_H8SX\MAIN_H8SX.i64`
> (`h8sxa`, 5,022 functions) and used read-only through `ida\jobs\i9_probe.py`: one first run, then two `--reopen` runs.
> Offline scripts are in `ida\out\suspect-tables\offline\`. Tables are in `ida\out\suspect-tables\`.
> Image: `decrypted\FT3D_MAIN_ver102_EXP.bin`, base 0, so the file offset equals the address. All work was static. No image was
> modified, and nothing was connected to a radio. No other DB was opened. The closed window `0x078106`–`0x07B753` was not
> analysed; one copy source inside it is given as an edge address only.

## Verdict

**None of the three suspect tables is data. The H9 premise behind the "block copy" is wrong.**

**The three tables.** `0x02941C` (8 entries), `0x0357CC` (7) and `0x07308C` (4) are all pure code-pointer tables.

- Each is consumed by the standard H8SX dispatch `mov.b @cell,r3l; and.l #0xff,er3; shll.l #2,er3; mov.l @(T:32,er3),er6;
  jmp @er6`.
- Every index cell is written only with values inside the table's range.
- Every target is an even instruction head that both the binutils oracle and IDA `h8sxa` decode, with lengths that agree.
- H9's flag ("reaches non-IDA code exclusively") is an artefact of the older `H1_RECOUNT` database. In `MAIN_H8SX` all 19 targets
  are IDA code heads.
- The 149-table set needs no correction, and the byte effect of this part is **0**.

**The "block copy".** `0x03DE38` copies nothing from ROM.

- `0x01A080` is an **address in MAIN's serial EEPROM**, not a ROM address. The routine `sub_3BDAC` is the bit-banged I2C read for
  EEPROM bank 1 (device bytes `0xA2`/`0xA3`).
- The copy is a boot-time **load of a 1,100-entry u16 per-memory-channel table**, EEPROM `0x1A080`–`0x1A917`, into the RAM
  cache `0xFF476E`–`0xFF5005`. The table has a write-through accessor and a factory-reset save.
- It is data. Nothing executes, jumps into or hooks that RAM, so there is nothing to hand to I8.
- The ROM bytes at `0x01A080` are unrelated application code, a block of `mov.l #imm,er2; bra` landing pads.

**What the follow-up added.** Following the tables' targets and H9's demotions found **three Confirmed edges that H9's rules
missed**:

- two key-dispatch records passed to `0x028CBC`;
- the vector-88 RAM hook installed through a helper (`0x00042C`);
- one `er1` callback.

Together they newly prove **1,136 B**. **MAIN proven rises 365,570 → 366,706** (72.52 % of content, 94.39 % of 388,490
decodable). **Named/typed rises 497,139 → 497,268** (+129, 98.34 %). This also **reverses H9's demotion of F1 rows `0x000760` and
`0x000800`**, and of `0x01BF28`: all three are reached code.

## Method

1. **Byte reads in Python** from the image for every cited address. `offline\i9_tables.py` asserts 39 byte runs (`checks ok: 39`).
   Disassembly comes from G1's binutils H8SX oracle (`h8s-decode\work\bu_all.tsv`).
2. **H9 reproduced, not re-implemented.**
   - `offline\i9_masks.py` imports H9's own `analyze.py`/`masks.py` and rebuilds H9's final masks. It reproduces proven
     **365,570** and named **497,139** exactly.
   - `offline\i9_descent.py` imports H9's `descent.py` unchanged. Its baseline full descent equals H9's reached mask byte for
     byte (363,758 B).
   - **Per-table exclusion test.** Each table is removed and the descent rerun. This reproduces H9's numbers exactly: 236 / 42 /
     488 B reached only through each table, of which 56 / 20 / 36 B were "not IDA code" in `H1_RECOUNT`.
   - **New edges.** The new edges are added as gated seeds. Every gate instruction is checked as reached, in both the full and
     the strict descent. The extended descent has **0 overlapping instruction starts** and **0 new bad decodes**.
3. **IDA cross-check** (`i9_probe.py` on `I9_MAIN`; outputs in `work\`).
   - It reports the item kind, function and xrefs for 109 probe addresses (`ida_probe.tsv`).
   - It decode-checks 1,104 oracle instructions over every span used here. There are **0 length mismatches**
     (`ida_len_check.tsv`, `ida_meta.txt`).
   - 149 of those instructions are not IDA code in the seed (`ida_not_code.tsv`). They are the newly reached spans, plus
     `0x073280`–`0x0732A4`.
4. **Index writers.** Every reached instruction addressing each index cell was listed, and every raw `6a xx` site in the image
   was scanned (`0xFFB9E4`, `0xFFAAD0`, `0xFFBB90`).
5. **EEPROM cache.** Every reached instruction with an immediate in `0xFF4700`–`0xFF5010` was found. The two bulk routines, the
   per-slot accessors and their callers were traced.
6. **ROM→RAM copies (task 3).**
   - Every reached `eepmov` was scanned, taking the source, destination and count from the preceding 12 instructions of the same
     block. This covers only `eepmov`. Hand-written `@ERn+` copy loops were not tabulated.
   - Count recovery is incomplete: 75 of 319 rows have a `?` length.

**Not done.** The 0x028CBC record family beyond my two records, and the `sub_15206` `er1`-callback family beyond `0x01A084`, were
surveyed but not credited (see Open). Both are I8's domain.

## Findings

### 1. The three suspect tables (`suspect-tables.tsv`, `table-entries.tsv`)

| Table | Extent | Dispatch (Confirmed bytes) | Index cell: values written | Verdict |
| --- | --- | --- | --- | --- |
| `0x02941C` | `0x02941C`–`0x02943B`, 8×BE32; the next byte `0x02943C` is target 0 | `0x029406` `6a 0b b9 e4 7a 63 00 00 00 ff 10 73 78 b0 6b 26 00 02 94 1c 59 60` | `0xFFB9E4`: only immediates 0–7, e.g. `0x01C610` 0, `0x02945E` 1, `0x0294E2` 2, `0x029582` 3, `0x02955A` 4, `0x029600` 5, `0x0294F0` 6, `0x029596` 7 | code pointers |
| `0x0357CC` | `0x0357CC`–`0x0357E7`, 7×BE32; the next code is `0x0357E8` | `0x035704` `6a 0b aa d0 … 78 b0 6b 26 00 03 57 cc 59 60` | `0xFFAAD0`: written only at `0x0347D8`/`0x035DE6` (`6a 8b aa d0`) from `sub_3F5B2`, a range lookup over band maps `0x03510A` (5 rows → 0–4) and `0x035140` (2 rows → 5–6) | code pointers |
| `0x07308C` | `0x07308C`–`0x07309B`, 4×BE32; the next byte `0x07309C` is target 0 | `0x073076` `6a 0b bb 90 … 78 b0 6b 26 00 07 30 8c 59 60` | `0xFFBB90`: immediates 1 (`0x0730B8`), 2 (`0x073106`, `0x073352`), 3 (`0x0730CA`, `0x0730E2`, `0x073124`); 0 is cleared RAM | code pointers |

**Bounds.** None of the three dispatchers checks its bound. The table size is enforced by the writers.

- **`0xFFAAD0`** is the indirect case.
  - The band maps are 10-byte records: BCD low, BCD high, u16 value.
    - `0x03510E` `04 00 00 00 07 59 95 00 00 00` = 40.0–75.995 MHz → 0. The other rows are 108–119.995 → 1, 120–173.995 → 2,
      174–221.995 → 3, 222–229.995 → 4, 300–419.995 → 5 (`0x035144`) and 420–579.995 → 6 (`0x03514E`).
  - If no row matched, `sub_3F5B2` would return the bytes past the last row: `0x99` for the VHF map, or `0x02`, the first CTCSS
    word at `0x035158`, for the UHF map.
  - Both writers sit behind `sub_3F5EE` range tests against RAM limits `0xFF92CE`/`0xFF92D6` (`0x034794`, `0x035DB4`). That
    makes the out-of-range case unreachable. Inferred: the RAM limits themselves were not traced.
- **What the case bodies do** (Confirmed bytes):
  - The 7 cases select a pair of band-specific calibration bytes: `0xFF8022`/`806A`, `0xFF8032`/`806D`, `0xFF8052`/`8073` and
    `0xFF8042`/`8070`.
  - Six sibling dispatchers index the same cell: tables `0x035580`, `0x0354C8`, `0x0355EC`, `0x035534`, `0x035680` and
    `0x035856`.

**Targets.**

- All 19 targets are even and are instruction heads in H9's descent.
- In `I9_MAIN` every target is an IDA code head with a `dr_O` xref from its slot, and every slot is a `.long` item.
- They are flat case labels (no prologue), which is the compiler's switch form. Examples:
  - `0x02943C` `7a 06 00 02 97 a0` (mov.l #0x297a0,er6);
  - `0x035732` `6a 0d 80 22`;
  - `0x07309C` `6a 10 89 20 73 00`.

**H9's flag explained.** Removing the tables loses exactly H9's 236 / 42 / 488 B. The bytes that were not IDA code in
`H1_RECOUNT` were:

- `0x028682`–`0x0286A6`, `0x02943C`–`0x029446` and `0x029708`–`0x029712` (56 B);
- `0x03571A`–`0x03572E` (20 B);
- `0x073280`–`0x0732A4` (36 B).

The first four ranges are IDA code in `MAIN_H8SX`. `0x073280` is the slot-2 target of the nested tier-A array `0x073162`, which
is reached from `0x07308C`'s case 3. It is unknown in IDA in both DBs, but the oracle and IDA decode lengths agree (Confirmed).

**Mixed records hang off `0x02941C`.**

- Targets 4 and 5 are `0x0296DE` `7a 01 00 02 96 e8 58 00 f5 d4` (mov.l #0x296e8,er1; bra 0x028CBC) and `0x029708` (#0x29712).
- `0x028CBC` is a key dispatcher on `0xFFBBC2`. It calls `@(0/4/8/0xC/0x14/0x18,er1)`, for example `0x028D0C`
  `01 00 6f 16 00 00 5d 60`.
- So the records `0x0296E8` and `0x029712` (32 B each) are data blocks whose fields are code pointers: `record-fields.tsv`.
- Targets 0–3 pass `er6` descriptors to `0x028682` (bound `cmp.w #0x13`, so 18 slots) and to `0x028562` (bound `cmp.w #4`, so 3
  slots).

**Correction to F1 table `0x0297A0`.** F1's single 27-entry table `0x0297A0` is really four arrays: `0x0297A0`[18], `0x0297E8`[3],
`0x0297F4`[3] and `0x029800`[3]. All 27 entries are code, so there are 0 B of change. H3's tier-C "array" `0x029726` is fields
+0x14..+0x1C of record `0x029712`.

### 2. The 0x01A080 → 0xFF476E "block copy" is an EEPROM cache (`eeprom-cache.tsv`)

**Copy site** `0x03DE20` (Confirmed):

```
03DE24  79 06 00 48 / 7a 00 00 01 a0 00 / 7a 01 00 ff 47 26 / 5e 03 bd ac   ; 0x48 B  EEPROM 0x1A000 -> RAM 0xFF4726
03DE38  79 06 08 98 / 7a 00 00 01 a0 80 / 7a 01 00 ff 47 6e / 5e 03 bd ac   ; 0x898 B EEPROM 0x1A080 -> RAM 0xFF476E
```

**`sub_3BDAC` is not a memory copy.**

- It bit-bangs port `0xFFFBA4`: bit 0 is data, bit 1 is clock, with `bld #0,@0xFFFBA0` for input at `0x03BE4E`.
- It sends a START, the device byte `0xA2` (`0x03C3AC` `fd a2`), the address bytes `r0h` and `r0l`, a repeated start with `0xA3`
  (`0x03BE1C` `fd a3`), and then reads `r6` bytes into `@er1+`.
- Bank 0 uses `0xA0`/`0xA1` (`0x03B180`, `0x03ABF0`), so `0x1A080` means EEPROM bank 1 (A16 = 1) at offset `0xA080`.
- The mirror routine `0x03DE52` writes the same two ranges back with `sub_3BF4C`.
- This matches doc pc-02 (`MEMORY.dat` `0xA280`: "one u16 per slot, EEPROM `0x1A080 + 2n`, `sub_3DF1C`"). **0x898 = 1,100 × 2**:
  one word per memory channel slot.

| Question | Answer (Confirmed unless marked) |
| --- | --- |
| Source / destination / length | EEPROM `0x1A080`–`0x1A917` → RAM `0xFF476E`–`0xFF5005`, `0x898` B. It is preceded by EEPROM `0x1A000`–`0x1A047` → `0xFF4726`–`0xFF476D` (`0x48` B, the header plus per-band arrays at `+0x18`/`+0x30`). `0xFF5006` is a separate object. |
| How often | **Boot only**, plus a reload. The single caller `0x00EF8C` `5e 03 de 20` is the last call of `sub_ED16`, the settings load, which is reached from the boot path `0x00DD06` and from `0x0452BC` (via `0x010594`). |
| Later writes to the RAM copy | Only `0x03DEFE` `69 94` (`mov.w r4,@er1`) in the write-through accessor `0x03DE96`. It sets `er1 = 0xFF476E + 2n` for a 16-bit slot `n`, and writes 2 B to EEPROM only when the value changed. The reset path `sub_DEFA` zeroes both blocks (`0x00E55A` `79 06 08 98 7a 05 00 ff 47 6e … 5e 03 de 52`) and saves them. |
| Readers | `0x03DF1C` copies slot `n` into the working word `0xFF8ED6`/`D7`, or into `0xFF8ED8`/`D9` when `0xFF817E` bit 0 is set. It is called beside the 32-byte channel-record read at `0x03A5C2`/`0x03A604`. The save path is `0x03A832` → `0x03DE96`. |
| Meaning | Inferred: two bytes per channel, each clamped to < 100 (`0x05E6CA` `6a 0c 8e d6 ac 64`; `0x05E6DA` likewise). It is consistent with per-channel DG-ID TX/RX. The working word is read by the DSP-side code at `0x056CA4`–`0x056CB8`. |
| Code? | **No.** Not found: no reached instruction in H9's full descent plus I9's additions (113,541+ instructions, closed window excluded) holds an immediate in `0xFF4726`–`0xFF5005` other than 14 sites: `0x00E54A`, `0x00E55E` and 12 in `0x03DE2E`–`0x03DF50` (the accessors in `eeprom-cache.tsv`). No hook cell receives such a value: all 42 reached stores to `0xFF811A`/`811E`/`B288`/`B3C6` were listed, and none is in range. No `jmp`/`jsr` targets the range. **Nothing for I8.** |
| ROM `0x01A080` crediting | `0x01A080` is mid-instruction. `0x01A07C` `7a 02 00 01 a1 fe` is a `mov.l #imm,er2; bra 0x01A0EA` landing pad, one of 14 at `0x01A07C`–`0x01A0E9`. In H9's masks `0x01A080`–`0x01A917` (2,200 B) has 1,524 B reached, 1,530 B proven and 2,166 B named. It is ordinary application code and was correctly treated as code. The only fix: the pad `0x01A084`–`0x01A08B` is reached (Section 3c). |

**Correction (H9 Open 3, RESUME Open 5).** "Block copy ROM `0x01A080` → RAM `0xFF476E`" should read "EEPROM `0x1A080` → RAM
`0xFF476E`, I2C bank 1, per-channel u16 cache".

### 3. New Confirmed edges (`new-edges.tsv`, `new-proven-bytes.tsv`)

**a. Key records via `0x028CBC`: +226 B.**

- The gates `0x0296DE`/`0x029708` are reached in the strict descent.
- `er1` is not written between them and `0x028D0C`, `0x028D40` and `0x028D4A`.
- Newly reached:
  - `0x029732`–`0x029756` (36 B, ends `jsr @0x1bef2; rts`);
  - `0x029764`–`0x02976C` (8 B);
  - `0x05E33E`–`0x05E376` and `0x05E37C`–`0x05E3B4` (56 B each, `7a 01 00 ff ba 02 fa 00 0f 95 …`);
  - through them `0x01BEF2`–`0x01BF38` (70 B), which includes H9-demoted F1 row `0x01BF28` (`6a 18 aa 30 70 70`).

**b. Vector-88 RAM hook, second installer: +902 B.**

- `0x034C24` `5e 00 04 50` (jsr 0x450) → `0x000454` `7a 05 00 00 07 06` (mov.l #0x706,er5) → `0x00045A` bsr → `0x00042C`
  `01 00 6b 85 81 1a` (mov.l er5,@0xFF811A).
- The consumer is the vector-88 stub `0x0028D0` `01 20 6d f4 … 01 00 6b 06 81 1a 59 60`. IDA has slot `0x000160` → `0x0028D0`.
- The body `0x000706`–`0x000A8B` has no prologue. Every one of its nine exits is `01 20 6d 76 56 70` (ldm.l er4-er6; rte), which
  matches the stub's `stm.l er4-er6`.
- H9's rule missed it because the store is in a callee. The same helper also installs `0x0004AA` (from `0x000404`); `0x000E3A`
  installs `0x000E5E` into `0xFF811E`. Both were already reached.
- The body ends at the 256-byte popcount table `0x000A8C` (`00 01 01 02 01 02 02 03 …`). It writes byte register `0xFFFF69`
  (unidentified).

**c. `er1` callback: +8 B.** `0x0178F0` `7a 01 00 01 a0 84` (mov.l #0x1a084,er1) → `jsr 0x15206` → `0x015224` `5d 10` (jsr @er1).
`er1` is untouched on that path.

**Task 3 re-checks.**

- **`0x000760`.** H9 was right that table `0x00F020` is no proof. But the row is reached code inside the `0x000706` body. Its
  "start" `0x000760` is mid-instruction: `0x00075C` `01 00 6b 85 aa c2` is 6 B.
  - **Seed defect:** `MAIN_H8SX`/`I9_MAIN` has a bogus function at `0x000760` (`cmp.b #0xC2,r2l`). It should be undefined and
    `0x000706` created.
- **`0x000800`.** A true head (`fc 64`), now reached through the same body.
- **`0x001740`.** H9's re-proof holds. The hook value is `0x00171C` (`0x02FB4E` `7a 04 00 00 17 1c`). Flow reaches the head
  `0x001740` `46 3c` through `0x00173C` (4 B).

### 4. Ledger delta (`ledger-delta.tsv`)

| Term | Bytes |
| --- | ---: |
| MAIN proven, H9 (mask reproduced) | 365,570 |
| + key records via `0x028CBC` | +226 |
| + RAM hook `0xFF811A` ← `0x000706` | +902 |
| + `er1` callback `0x01A084` | +8 |
| **MAIN proven, I9** | **366,706** (72.52 % / 94.39 %) |
| MAIN named/typed, H9 (mask reproduced) | 497,139 |
| + newly reached bytes outside H9's named mask (`0x000706` body 63, `0x01BEF2` span 66) | +129 |
| **MAIN named/typed, I9** | **497,268** (98.34 %) |

**No double count against H9.**

- Every one of the 1,136 bytes is outside H9's reached mask (asserted). It is therefore outside H9's +8,057 new-proven term and
  outside the final proven mask (asserted: delta = |new \ PROV_H9|).
- 274 of the bytes were H9-demoted from RC or D. They re-enter, and `new-proven-bytes.tsv` labels each run.
- 862 bytes were never proven.
- Named: +129 = |new \ NAMED_H9|, asserted.

**Possible overlap with I8.** All three edges sit behind `jmp`/`jsr @ERn` (`0x028D12…`, `0x0028E0`, `0x015224`). If I8 credits any
of the same bytes, the orchestrator must union by byte mask, using the run list in `new-proven-bytes.tsv`.

### 5. Other ROM→RAM copies (`ram-copies.tsv`)

**No C-runtime section table exists.** The boot code (`0x0020FA`, and again at vector-67 entry `0x0024B6`) is hand-written:

- It zeroes RAM `0xFEE000`–`0xFF72FF` (`0x002132` `7a 06 00 00 00 00 7a 04 00 ff 73 00 7a 05 00 fe e0 00`; loop at `0x002148`).
- It then makes **one initialised-data copy**: `0x002152` `79 04 04 ae 7a 05 00 07 b2 a6 7a 06 00 ff 60 34 7b d4 59 8f`. That is
  0x4AE B from ROM `0x07B2A6`–`0x07B753` to RAM `0xFF6034`–`0xFF64E1`.
- **The source lies inside the closed window. Only the edge is given.**

Every other `eepmov` is a small template or default copy:

- 319 `eepmov` sites in all (2 of them the boot copy above); the next largest is `0x00D66E`, 0x81 B from `0x02C724` → `0xFF3D94`.
- None targets `0xFF4726`–`0xFF5005`.

## USB relevance

- **Everything USB.** No change. Nothing here touches the USB module at `0xFFEE00` or its descriptors. The EEPROM cache is
  channel data. The vector-88 hook body is a bit-timing routine on port `0xFFFF40` that writes `0xFFFF69`; it is not USB.
  Inferred, from the `2c 40` stub read.
- **SDR / DSP.** No change. The per-channel word reaches the DSP-side code only as a 0–99 pair, which is not a sample path.
- **Boot.** RAM `0xFF6034`–`0xFF64E1` is initialised at every boot from the tail of the closed window. Any lane that analyses
  `0xFF6034`-region variables should know that their initial values come from `0x07B2A6`+.

## Open

1. **I8 / orchestrator.**
   - `0x028CBC` has 8 record callers. Records `0x028C2A` (+0x14 → `0x02A924`) and `0x028C8A` (+0x14 → `0x02A9F4`) still point
     at unreached code. Confirmed fields, not credited here.
   - The `sub_15206` `er1`-callback family has 13 sites and 7 targets. All are reached except `0x01A084`, now credited.
   - H9's RAM-cell rule should follow stores made in a called helper (`0x00042C`, `0x000E3A`).
2. **Seed repair.** In `MAIN_H8SX`, undefine `sub_760`, create the code at `0x000706` (through `0x000A8B`), and type
   `0x000A8C` as a 256-byte table. Create code at `0x029732`, `0x029764`, `0x05E33E`, `0x05E37C` and `0x073280`. Type records
   `0x0296E8`/`0x029712` as 8-dword structs.
3. **Name the vector-88 source and register `0xFFFF69`.** Two bodies, `0x0004AA` and `0x000706`, are swapped in by `0x000400` and
   `0x000450` (called from `0x02F500`, `0x034C24`). The use of `0xFF8F9A` and the popcount table suggests a bit-serial decoder.
   Unverified.
4. **Confirm the DG-ID reading of EEPROM `0x1A080`** on the UI side: who edits `0xFF8ED6`/`D7`, and which screen shows them.
