# 23 — Setup-menu structure and extension attachment points (lane 6)

Scope: static, read-only analysis of the owner's FT3DR ver 1.02 SUB (RX) and MAIN
(H8SX) images, done to map the setup menu so that a later session can add a small
owner feature such as a setup-menu row. Band coverage, TX keying and the DSP boot
loader were excluded and not approached. This pass produced no patch, no image and
no byte strings.

Evidence words: **Confirmed** (I read the bytes or instruction), **Inferred**
(confirmed evidence plus a stated assumption), **Not found** (with the scope
searched), **Unknown**. Citations are `file:line` under `ida\out\extension\`.

## Verdict

The setup menu is **driven by MAIN and drawn by SUB**. SUB holds a static 24-slot
group table at `0xFFED74E8`, indexed 1-based. It has 15 populated groups (1–12 and
21–23) holding 116 counted rows. There is one hidden row, `RAM DISPLAY` (OPTION),
behind `0x8E4D` bit 7. One row, `WX ALERT` (SIGNALING), is dropped when
`0x8C53==0`. **Slots 13–20 (`0xFFED7550`–`0xFFED7588`) are empty `{0,NULL}`**, and
their title-length bytes are zero too. On the MAIN side, the F301 list-frame jump
table at `0x9712` has 13 entries (groups 1–13). **Entry 12 (group 13) exists in
MAIN** and is gated by `0xFF89C4` bit 3, but SUB has no descriptor, labels or
localised draw case for it. This is the most concrete spare-slot attachment point.

The template for a **gated extra row** is the existing RAM DISPLAY mechanism:
- MAIN copies `0xFF89C4` bit 4 into frame+7 bit 7.
- SUB `sub_FFF095E3` adds 1 to the OPTION count when that bit is set.
- MAIN `sub_2992A` raises the OPTION cursor bound from 4 to 5.

**RAM DISPLAY answer:** it does **not** blit RAM to the LCD. Its hex-dump page
(`sub_FFF0AB40`) is text. It prints 64 bytes that MAIN places in the SUB frame
(`+0x23..+0x62`), under a 16-bit address MAIN sends in `+0x21/+0x22`, using the
string drawer `sub_FFEFA7E7`. No audited blit site points its source at RAM (see
Findings §7).

## Method

- **First lane-6 agent (jobs on disk, outputs read-only for this pass).**
  - `full_l6_sub1.py` and `full_l6_sub2.py` on the private SUB DB `EXT_MENU`
    produced `menus-sub1-funcs.txt`, `menus-sub1-slabs.txt`,
    `menus-sub2-funcs.txt`, `menus-blit-sites.tsv` and `menus-blit-direct.tsv`.
  - `full_l6_main1`–`5`, `7` and `8.py` on `EXT_MENU_MAIN` produced
    `menus-main1`–`8*`.
  - The `full_l6_sub2.py.log` shows one earlier run failing with a `SyntaxError`,
    then a clean re-run. The `.txt` outputs are from the clean run: the
    `direct blit hist {'flash_desc': 226, 'computed': 5}` line is present.
- **This respawn.** Three new read-only jobs, run one at a time with `--reopen`,
  each exiting 0:
  - `ida\jobs\full_l6r_grp.py` (EXT_MENU) → `menus-l6r-groups.tsv`: the raw 8-byte
    group entries 0–24 and 24 bytes at `0xFFC3DF35`.
  - `ida\jobs\full_l6r_sub.py` (EXT_MENU) → `menus-l6r-sub.tsv`: screen-handler
    table `0xFFED4050` entries 0x1C–0x22, the `_INITSCT` DTBL entry covering
    `0x69310`, and its ROM source dwords.
  - `ida\jobs\full_l6r_main.py` (EXT_MENU_MAIN) → `menus-l6r-main.tsv`: the
    `0x9712` jump table and 36 bytes at `0x9746`.
  - Logs are in `ida\log\jobs\EXT_MENU\full_l6r_*.log` and
    `ida\log\jobs\EXT_MENU_MAIN\full_l6r_main.log`. All are empty, meaning no
    traceback.
- I re-checked every finding the first agent reported against these dumps. I
  corrected two:
  - the title table is 24 entries, not 13;
  - the MAIN jt entry 12 shares its target with entry 11.
- **Not run this pass:**
  - **The settings-byte table was not built (lane stopped).** This was the full
    table of every MAIN settings byte mapped to its BACKUP.dat field. Only the
    address mapping rule is given (§6).
  - The three stack-built blit-wrapper descriptors were not audited (§7).
  - The SUB F3xx code → label mapping was taken from the first agent and not
    re-derived (§5).

## Findings

### 1. SUB group table `0xFFED74E8` — Confirmed

- **Entry layout.** 8-byte entries `{u8 count, 3 pad, u32 labels}`, read as
  `movu.b [r14, g*8]` at `FFF095EB`/`FFF095F1` (`menus-sub1-funcs.txt:7-8`).
- **Slots.** The raw entries are in `menus-l6r-groups.tsv:2-26`:
  - slot 0 is `00 00 00 00 55 DD C3 FF`, the name base;
  - slots 1–12 and 21–23 are populated;
  - slots 13–20 are all `00`;
  - slot 24 (`FFED75A8`, `94 89 F0 FF …`) is the next object, the list-screen
    function table, and not a group.
- **Group index limit.** Any group byte `>= 0x18` is clamped to 1 at
  `FFF0919B cmp #18h, r1` (`menus-sub1-funcs.txt:63`), so 23 is the highest usable
  group index.
- **Row counts** (hex/decimal): 09/9, 03/3, 06/6, 0E/14, 06/6, 02/2, 05/5, 16/22,
  1C/28, 04/4, 04/4, 01/1, then 03/3, 04/4, 05/5. They sum to **116**, which
  agrees with doc 08 §2.
- **Row-count gates in `sub_FFF095E3`** (`menus-sub1-funcs.txt:1-47`):
  - `cmp #0Bh` at `FFF095F8`, then `mov.l #8E46h` / `movu.b 7[r1]` / `shlr #7` at
    `FFF095FC`–`FFF09604`: this adds 1 when `0x8E4D` bit 7 is set (RAM DISPLAY).
  - `cmp #4` at `FFF0961F`, then `movu.b 6[0x8C4D]` / `cmp #0` at
    `FFF09629`–`FFF0962B`: this subtracts 1 when `0x8C53==0` (WX ALERT, doc 08).
- **Localised row draw** `sub_FFF0964A`. Its switch has cases 1–12 and 0x15–0x17
  only (doc 08 §2). The English path draws `labels + item*20` for any group.

### 2. Category-title length table `0xFFC3DF35` — Confirmed (correction)

- The bytes are `05 07 05 06 09 05 02 07 06 04 07 06 08 00×8 0A 0D 0B`
  (`menus-l6r-groups.tsv:27`).
- The table is indexed **directly by the group byte, frame+0x20**, at
  `FFF08A08 mov.b 20h[r14]` and `FFF08A17 movu.b [r14, r1]`
  (`menus-sub2-funcs.txt:1484-1489`). The same load appears at `FFF08CA0`.
- It is therefore a 24-entry table, not 13.
  - Entries 21–23 (`0A 0D 0B`) equal the lengths of `TX/RX>MODE`,
    `TX/RX>DIGITAL` and `TX/RX>AUDIO`.
  - Entries 13–20 are `00`, which matches the empty slots.
  - Entries 1–12 match the category-name lengths except SCAN (5 vs 4), as doc 08
    open item 5 noted.
- **Use:** the value centres the title using a 13 px glyph pitch:
  - `FFF08A1E mul #0Dh`, then `mov.l #140h` / `sub` / `div #2`;
  - an odd length adds 13 first (`btst #0` at `FFF08A1A`, `add #0Dh` at `FFF08A30`).

This settles doc 08 open item 5 apart from the SCAN value.

### 3. SUB screen routing — Confirmed

- **IPC F3/F4** `sub_FFEDF3A7` (`menus-sub2-funcs.txt:166-230`) handles frame byte 0
  `== 0xF3` (`FFEDF3B4 cmp #-0Dh`). It first excludes sub-ops 0xD5/0xD6
  (`FFEDF3C1 add #-0D5h`, `cmp #2`, `bltu`), then maps the sub-op to a screen code:

  | F3 sub-op | Screen code | Evidence |
  | --- | --- | --- |
  | 0x00 | 0x1D | `FFEDF3E5` |
  | 0x01 | 0x1E | `FFEDF3EA` |
  | 0x66 | 0x43 | `FFEDF3CD` / `FFEDF3F8` |
  | 0xB3, 0xB8 | 0x20 | `FFEDF3D2`, `FFEDF3D7` → `FFEDF3F4` |
  | 0xD1 | 0x21 | `FFEDF3DC` / `FFEDF3EF` |
  | other | 0x1F | `FFEDF3FC` |

  F4 sub-ops 0–4 map to 0x1F, 0x45, 0x46, 0x47 and 0x48.
- **Screen table `0xFFED4050`**, indexed by `0x8A8C` (`FFEDF0DC`,
  `menus-sub2-funcs.txt:20`). Entries from `menus-l6r-sub.tsv:3-8`:

  | Screen | Handler |
  | --- | --- |
  | 0x1D | `sub_FFF0AC89` |
  | 0x1E | `sub_FFF0896A` (list) |
  | 0x1F | `sub_FFEFE223` |
  | 0x20 | `sub_FFEFD6E9` |
  | 0x21 | **`sub_FFF0A86D`** (RAM DISPLAY) |
  | 0x22 | `FFEE2248`, not a function in the DB |

- **`sub_FFF0A86D`** re-checks `0x8E4D` bit 7 (`FFF0A873`) and then jumps through
  `off_FFED75FC` using page index `0x8C4C` 0..3 (`FFF0A88F`,
  `menus-sub1-funcs.txt:420-430`). The four page entries are `FFF0A8A6`,
  `FFF0A8B8`, `FFF0A958` and `FFF0A9B9` (`menus-sub1-slabs.txt:742-747`).
- **`sub_FFF092FC`** takes the item-code byte `0x8C4E` (frame+1), shifts it right
  by 4 (`FFF09306`) and maps the high nibble to a group:
  - 8/9 → 8;
  - 0xA/0xB → 9;
  - 0xC → 0xA;
  - 0xD → 0xB;
  - 0xE → 0xC;
  - 2 → 0x15/0x16/0x17, split by the full byte (`<=0x22`, `<=0x25`, `<=0x28`,
    `<=0x2A`);
  - every other nibble passes through unchanged.

  **High nibble 0xF has no case** and would yield group 15, an empty slot
  (`menus-sub2-funcs.txt:463-523`). `sub_FFF09396` decodes the low nibble into a
  row per group (`menus-sub2-funcs.txt:525+`).
- **Frame layout** — Confirmed. The SUB frame shadow is `0x8C4D`. Its fields
  +0x20, +0x21 and +0x22 are the group, the top row and the cursor, read at
  `FFF0917E`/`FFF09188`/`FFF09195` (`menus-sub1-funcs.txt:55-61`). This matches
  doc 08 (`0x8C6D`/`0x8C6E`/`0x8C6F`).

### 4. MAIN side — Confirmed unless marked

- **`sub_7C20`, the shared frame header** (`menus-main2-funcs.txt:84-106`):
  - `7C26 mov.b #2, r3l` goes to `0xFF3D7A` (frame+6).
  - `7C62 bld #4, @0xFF89C4` then `7C68 bst #7, r3l` go to `0xFF3D7B` (frame+7).
  - The frame base is `0xFF3D74`. SUB reads this bit as `0x8E46+7` bit 7.
- **F301 list-frame builder** at `0x95B6` (`menus-main1-funcs.txt:215-300`):
  - `95CA mov.w #0xF301` goes to `FF3D74`, then `jsr sub_7C20`.
  - `95E2`–`95EE` store `0x8F2E+1` to `FF3D94` (frame+0x20). So **`0x8F2E` is the
    0-based group**.
  - `95BA cmp.b #1` sends TX/RX (0-based 1) down a separate path at `96C0`.
    Inferred: that path serves sub-groups 21–23.
  - Bytes `78 B0 6B 26 00 00 97 12` at `95FC` are
    `mov.l @(0x9712,er3), er6`, followed by `9604 jmp @er6`.
- **Jump table `0x9712`**, 13 entries (`menus-l6r-main.tsv:2-14`; entry 13 at
  `0x9746` is the byte table `01 01 01 …`):

  | Entry | Target | Cursor source |
  | --- | --- | --- |
  | 0 | `9642` | `8F4E`, via scroll table |
  | 1 | `9606` | `8F4F` |
  | 2 | `9610` | `8F53` |
  | 3 | `9648` | `8F54`, via scroll table |
  | 4 | `961A` | `8F55` |
  | 5 | `9622` | `8F56` |
  | 6 | `962A` | `8F57` |
  | 7 | `964E` | `8F58`, via scroll table |
  | 8 | `9654` | `8F59`, via scroll table |
  | 9 | `963A` | `8F5A` |
  | 10 | `9632` | `8F5B` (OPTION) |
  | 11 | `969C` | none: top=1, cursor=0 (CALLSIGN, 1 row) |
  | **12** | **`969C`** | **same target as entry 11** |

- **Scroll table `0x9746`** (`menus-l6r-main.tsv:16`, read at `9660`): the bytes
  are `01×6, 02, 03 … 1F`, so the top row is max(1, cursor−4). This is a six-row
  page. At least 36 entries were read, which covers APRS (28 rows). Only the groups
  with more than 6 rows use it: DISPLAY, SIGNALING, CONFIG and APRS.
- **`sub_14AF4`** (`menus-main2-funcs.txt:690-721`):
  - `14B04 cmp.b #0xC` and `14B08 btst #3, @0xFF89C4` send entry into 0-based
    group 12 to the reject path `sub_3FFA0` unless bit 3 is set.
  - 0-based group 1 goes to its own path (`14B00`).
- **`sub_2992A`** (`menus-main2-funcs.txt:762-793`): at `2998A` it loads 5 for
  `0xFF8F5B`, and `2998C btst #4, @0xFF89C4` / `29994 dec.b r3l` lowers it to 4
  when the bit is clear. This is the OPTION bound (entry 10 → `8F5B`).
- **`sub_14EE4`** (`menus-main2-funcs.txt:727-730`) reads the row code from
  `byte_1515C[er3]`. If the code is `0x69`, the row is skipped unless `0xFF89C4`
  bit 4 is set.
  - Inferred: `0x69` is MAIN's row code for RAM DISPLAY.
  - The first 64 bytes of `0x1515C` are dumped (`menus-main3.txt:335`). The claimed
    end `0x151EA` was not confirmed in the dumps.
- **`0xFF89C4` bit toggles** (`menus-main3.txt:118-124`): bits 1, 2, 4 and 3 are
  flipped by `bnot` at `16446`, `1644E`, `16456` and `1645E`. Each toggle comes
  from a comparison of a four-byte entry buffer at `0xFFAD8E` (`16420`–`16444`)
  and is then saved through `sub_193CA` (`193CA mov.w #0xA4, r1` then
  `jmp sub_3CCBC`, `menus-main4.txt:65`). The compared values are not reproduced
  here; they are not needed for menu structure.
- **`sub_976A`, the generic item-frame sender** (`menus-main8.txt:132-142`): it
  writes frame word `e3` (an `F3xx` code) to `FF3D74` and the value byte to
  `FF3D94` (+0x20), then calls `sub_7C20`. Its caller list (60+ sites) is the set of
  per-item senders.

### 5. Channel-record bits — Inferred

- **Assumption.** The handlers' `er0` is the working record whose `+0x12` region
  `sub_3FB0C` fills. `3FB14`–`3FB1C` set `er6 = [0xFF812A] + 0x12`
  (`menus-main5.txt:14-16`). The F3xx → label names come from the first agent's
  SUB decode and were not re-derived this pass.
- **Field map.** Unpack is in `sub_3FB0C` (`menus-main5.txt`); the reader is in
  `menus-main8.txt`.

  | Packed | Unpack (main5) | Working | Reader (main8) | Code / label |
  | --- | --- | --- | --- | --- |
  | +0x01 b0–3 | `3FB50 and #0xF` → er6+2 (:27) | +0x14 | `5816`/`581C` (:87-89) | F391 STEP |
  | +0x01 b4–5 | `3FB5A and #0x30` → er6+3 (:30) | +0x15 | `5702`/`5708` (:35-37) | F38E RPT SHIFT |
  | +0x01 b6–7 | `3FB68 and #0xC0`, `rotl` → er6+7 (:35) | +0x19 | `571E`, `sub_9D82` `9D8E mov.w #0xF322` (:45, :149) | F322 RX MODE |
  | +0x1D b0–4 | `3FC7C and #0x1F` → er6+0x22 (:133) | +0x34 | `5A10`/`5A0C` (:127-128) | F346 PR FREQUENCY |
  | +0x1D b5–7 | `3FC86 and #0xE0` → er6+0x23 (:136) | +0x35 | `5142`/`5148` (:11-13) | F342 DCS INVERSION |
  | +0x1E b0–3 | `3FC94 and #0xF` → er6+0x25 (:141) | +0x37 | `56F8`/`56F4` (:31-32) | F348 SQL S-METER |

- **Still Unknown:**
  - +0x00: copied whole to er6+0 (`3FB48`).
  - +0x05: b0–3 → er6+4, b6–7 → er6+1, b4–5 → er6+0x24 (`3FBC4`/`3FBCE`/`3FBDA`).
  - +0x1E b4–5 and b6–7: merged into er6+0x24 (`3FCA0`, `3FCAE`).
  - +0x1F:
    - b7 selects the destination buffer `0xFF9102` and sets `0x8EA6` bit 0
      (`3FB10`);
    - b0–2 → er6+0x26 (`3FCBA`);
    - b3–7 → er6+0x27, which is working +0x39 (`3FCC4`).
    - Working +0x39 bit 3 forces RX MODE to show 2 (`571A`), and bit 4 forces
      STEP to 0x0C (`5812`). What these gate bits mean is Unknown.

### 6. EEPROM / BACKUP.dat address mapping rule — Confirmed

- **Writers** (`menus-main6.txt:29-58`):
  - `3CCC8 add.l #0xFF8920` and `3CCDC add.l #0x580`: `0xFF8920+n` → EEPROM
    `0x580+n`.
  - `3CD0C add.l #0xC000`: `0xFF8AA0+n` → `0xC000+n`.
  - `3CD3C add.l #0xD000`: `0xFF8D20+n` → `0xD000+n`.
- **BACKUP.dat offset** = EEPROM − `0x140` (pc-02, `eep = off + 0x140`).
- **`0xFF89C4`:**
  - n = 0xA4, which is the argument at `193CA`;
  - EEPROM `0x624`, BACKUP.dat `0x4E4`;
  - the default is 5 (`E67C mov.b #5` → `89C4`, `menus-main3.txt:42-43`);
  - it is forced to 5 after a restore whose checksum matches
    (`74AB0 cmp.l er4, er6` / `74AB4 mov.b #5`, `menus-main2-funcs.txt:1907-1910`;
    pc-02 names `0x74AA8` as the checksum compare).
- **The settings-byte table was not built this pass (lane stopped).**

### 7. RAM DISPLAY vs the blit path — Confirmed / Not found

- **Page 1 `sub_FFF0A8B8`** blits three entries of the `.data` pointer table
  `0x69310` through `sub_FFEF68D5` (`FFF0A8CA`–`FFF0A8FC`,
  `menus-sub1-funcs.txt:449-470`).
  - `_INITSCT`'s DTBL entry `FFED8A34`
    `{src FFED9764, end FFEDAB4C, dst 00068514}` covers `0x69310`, so its ROM source
    is `0xFFEDA560` (`menus-l6r-sub.tsv:10-11`).
  - The first three dwords are `FFECF65C`, `FFECF43C` and `FFECF5BC`
    (`menus-l6r-sub.tsv:12-14`). All three are inside the flash descriptor range
    `FFECE55C`–`FFED3F6C`, at 16-byte records 272, 238 and 262.
  - Not found: an immediate write to `0x69310`. Scope is the first agent's
    immediate scan; this pass did not repeat it.
- **Monitor page `sub_FFF0AB40`** (`menus-sub1-funcs.txt:627-724`):
  - It prints the group number (`+0x20`) and the 16-bit value
    `(+0x21<<8)|+0x22` (`FFF0AB84`–`FFF0AB89`).
  - It then walks 8 rows × 8 columns of `movu.b 23h[0x8C4D + row*8 + col]`
    (`FFF0ABC6`), converts each byte with `sub_FFEE1C6A`, and draws text with
    `sub_FFEFA7E7`.
  - Inferred: the 16-bit value is a MAIN-side address, because MAIN fills the 64
    bytes.
- **Blit census** (`menus-blit-direct.tsv`, log hist):
  - 231 direct `sub_FFEF0648` calls: 226 immediate flash descriptors and 5
    computed (`FFEE4E31`, `FFEEF8D6`, `FFEF68F3`, `FFF0783A`, `FFF07851`).
  - The wrapper's 3 "RAM_IMM" sites are stack-built descriptors, not RAM source
    pointers: `FFEFAC8B`, `FFEFADCF` and `FFEFAEF3`, each `add #…, sp, r4`
    (`menus-blit-sites.tsv:151-154`). They were not audited.

## Extension

These are the attachment points a later owner feature (a setup-menu row) would
touch. Nothing here was modified.

1. **Gated extra row in an existing group.** This is the RAM DISPLAY pattern and
   needs changes on both sides:
   - SUB count function `sub_FFF095E3` (the gate compare at `FFF095F8`/`FFF09602`);
   - SUB label lattice `0xFFC3DF4D`…, 20-byte stride, gapless apart from OPTION
     (doc 08 §2);
   - MAIN per-group cursor bound in `sub_2992A` (OPTION at `2998A`);
   - MAIN row-code table `0x1515C` and its gate `sub_14EE4`;
   - MAIN item sender `sub_976A` (F3xx code into frame +0x20);
   - the SUB item decoder `sub_FFF092FC`/`sub_FFF09396`.
2. **New group.**
   - SUB empty descriptor slots `0xFFED7550`–`0xFFED7588` (groups 13–20);
   - title-length bytes `0xFFC3DF42`–`0xFFC3DF49`;
   - group limit 23, clamped at `FFF0919B`;
   - the localised draw switch in `sub_FFF0964A`, which has no case 13–20;
   - on MAIN: jump-table entry 12 at `0x9742` (→ `969C`), gated by `sub_14AF4` on
     `0xFF89C4` bit 3. Only group 13 has a MAIN entry.
3. **Screen routing.** F3 sub-op switch `FFEDF3B4`–`FFEDF3FC` and screen table
   `0xFFED4050` (entries 0x1D–0x21 known; 0x22 → `FFEE2248` is unidentified).
   The item-code high nibble 0xF is undecoded in `sub_FFF092FC`.
4. **Persisted flag byte.** `0xFF89C4`, EEPROM `0x624`, BACKUP.dat `0x4E4`,
   default 5, saved by `sub_193CA` → `sub_3CCBC(0xA4)`. Bits 1–4 have known
   readers or togglers (bit 1 at `17996`, bit 3 at `14B08`, bit 4 at
   `7C62`/`2998C`/`14EF2`). Bits 0 and 5–7 were not traced this pass; do not
   assume they are free.
5. **Frame bit carrier.** `sub_7C20` frame+7 (`0xFF3D7B`). Bit 7 carries the RAM
   DISPLAY gate to SUB `0x8E4D`. The other bits of that byte are set from
   `0x8BCA` and `0x813E` (`7C50`–`7C60`).

## Counts

| Item | Value |
| --- | --- |
| Menu group slots | 24 (0–23). Slot 0 is the header; the highest usable group is 23 |
| Groups populated | 15 (1–12, 21–23) |
| Groups empty | 8 (13–20) |
| Rows counted in the table | 116 |
| Rows shown | 116 by default. 115 when `0x8C53==0` (WX ALERT removed). 117 with RAM DISPLAY enabled |
| Rows hidden | 1 (RAM DISPLAY, OPTION row 5). There is also 1 conditional row (WX ALERT) |
| Spare slots | 8 SUB descriptors `FFED7550`, `FFED7558`, `FFED7560`, `FFED7568`, `FFED7570`, `FFED7578`, `FFED7580`, `FFED7588`; 8 title bytes `FFC3DF42`–`FFC3DF49`; 1 MAIN jump-table entry at `0x9742` (group 13) |
| MAIN F301 jump-table entries | 13; scroll-table bytes read: 36 |
| RAM DISPLAY pages | 4 (`off_FFED75FC`); the hex dump is 64 bytes (8×8) |
| Channel-record fields resolved | 6, across 3 bytes (+0x01 ×3, +0x1D ×2, +0x1E low nibble) |
| Channel-record bytes with unknown fields | 4 (+0x00, +0x05, +0x1E b4–7, +0x1F) |
| Blit sites | 231 direct (226 flash, 5 computed); 3 wrapper sites with stack descriptors, not audited |
| Functions given a purpose | 26 (listed below) |

**SUB functions (14):**

| Function | Purpose |
| --- | --- |
| `FFF095E3` | item count |
| `FFF09171` | draw page |
| `FFF0964A` | draw row |
| `FFF0A86D` | RAM DISPLAY dispatcher |
| `FFF0A8A6`, `FFF0A8B8`, `FFF0A958`, `FFF0A9B9` | RAM DISPLAY pages 0–3 |
| `FFF0AB40` | hex dump |
| `FFEDF3A7` | IPC F3/F4 → screen code |
| `FFF092FC` | group decode |
| `FFF09396` | row decode |
| `FFF08A00`, `FFF08C8F` | title centring / list draw |

**MAIN functions (12):**

| Function | Purpose |
| --- | --- |
| `7C20` | frame header |
| `95B6` | F301 list frame |
| `976A` | F3xx item sender |
| `9D82` | F322 sender |
| `14AF4` | group-enter gate |
| `14EE4` | row-code 0x69 gate |
| `2992A` | cursor bounds |
| `16456`, `1645E` | `89C4` bit toggles |
| `193CA` | save `89C4` |
| `3CCBC` | EEPROM writer, `0xFF8920` region |
| `3FB0C` | channel-record unpack |

## Open

1. **Settings-byte table.** The full map of every MAIN settings byte to its
   BACKUP.dat field was not built (lane stopped). Only the mapping rule in §6
   exists.
2. **The three stack-built wrapper descriptors** (`FFEFAC8B`, `FFEFADCF`,
   `FFEFAEF3`) and the 5 computed direct blits have not been audited for a RAM
   source.
3. **The full extent of `0x1515C`.** Where does it end (is `0x151EA` correct), and
   which index holds `0x69`?
4. **Remaining `0xFF89C4` bits.** Bit 0 and bits 5–7 have no readers identified.
5. **Remaining screen handlers.** Screen 0x22 handler `FFEE2248` (no function), and
   the purpose of F3 sub-ops 0xD5/0xD6, which are excluded before the switch.
6. **Remaining channel-record fields.** +0x00, +0x05, +0x1E b4–7 and +0x1F, plus
   what the +0x39 b3/b4 gates mean.
7. **Label re-derivation.** Re-derive the F3xx → label names on the SUB side to
   upgrade §5 from Inferred.
8. **SCAN title length.** The SCAN value is 5 against a 4-character name.
