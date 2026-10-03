# 32 — MAIN settings-byte table (lane F5)

Static, read-only analysis of the owner's FT3DR/FT3DE ver 1.02 **MAIN** image
(`decrypted\FT3D_MAIN_ver102_EXP.bin`, H8S advanced `h8s300a`, big-endian, base 0,
so file offset = mapped address). This lane builds the per-byte table that doc 23
§6 established the *rule* for but was stopped before producing, and resolves doc 23
Open #3 (extent of the `0x1515C` row-code table and the `0x69` index). It also
documents the persisted flag byte `0xFF89C4`. No image was modified; nothing was
written to a radio; no patch or byte string was produced.

Evidence words: **Confirmed** (I read the bytes/instruction), **Inferred**
(confirmed evidence + a stated assumption), **Not found** (with scope), **Unknown**.

Machine tables (named below, full per-byte data lives there, not in this doc):
- `ida\out\settings\settings-bytes.tsv` — 1,408 rows: `region, n, ram_addr,
  eeprom_addr, backup_off, writer, reader, menu_item, evidence`.
- `ida\out\settings\1515c-rowcodes.tsv` — 145 rows: `table_base, index, row_code, note`.

## Verdict

**Confirmed.** The three persisted MAIN RAM settings regions and their EEPROM /
`BACKUP.dat` destinations are:

| Region | RAM | extent | EEPROM | BACKUP.dat | bulk save/restore |
| --- | --- | --- | --- | --- | --- |
| R1 | `0xFF8920`+n | **0x180 (384 B)** | `0x0580`+n | `0x0440`+n | `sub_395B8` |
| R2 | `0xFF8AA0`+n | **0x280 (640 B)** | `0xC000`+n | `0xBEC0`+n | `sub_3D492` |
| R3 | `0xFF8D20`+n | **0x180 (384 B)** | `0xD000`+n | `0xCEC0`+n | `sub_3D66C` |

The three regions tile RAM exactly (`0xFF8920` +0x180→ `0xFF8AA0` +0x280→
`0xFF8D20` +0x180→ `0xFF8EA0`) and each extent is confirmed by a dedicated bulk
save/restore loop whose byte count I read directly; the EEPROM ranges are bounded
by the next-used EEPROM addresses (`0x700`→RAM `0xFFBCB6`, `0xD480`→RAM `0xFFB05A`).
`BACKUP.dat offset = EEPROM − 0x140` (pc-02). The flag byte `0xFF89C4` is R1 n=0xA4
→ EEPROM `0x624` → `BACKUP.dat 0x4E4`, saved by `sub_193CA → sub_3CCBC(0xA4)` —
this reproduces doc 23 §6 exactly.

Of the 1,408 region bytes, **30 are attributed to a specific menu item** (an F3xx
item code read by a sender, or the named flag-bit gate): R1 = 18, R2 = 6, R3 = 6.
A further **663 bytes are confirmed individually-persisted settings** (they have a
dedicated single/multi-byte writer call) whose exact menu item I could not pin from
an F3xx sender, and the remaining **715 bytes are saved only by the region's bulk
loop** (no dedicated writer, no sender) — image bytes whose individual meaning is
Unknown from this package.

**Row-code correction (doc 23 Open #3):** the `0x1515C` table is **0x90 (144) bytes**,
`0x1515C`–`0x151EB` (code resumes at `0x151EC`); doc 23's guessed end `0x151EA` is
the last row-code byte, followed by one `0x00` pad at `0x151EB`. **Row code `0x69`
does not appear anywhere in the table.** The `cmp.b #0x69` in `sub_14EE4`
(`0x14EEC`) gates group 1 and is **inert** in this EXP build — no entry equals 0x69.
The functioning RAM DISPLAY gate is in the OPTION case (`0x1505A`, `btst #4,
@0xFF89C4`): RAM DISPLAY is **row code `0xD6`**, at **index 4** of the OPTION
sub-table `loc_151DE` (`0x151DE` = `87 1E 1D 1F D6 00`).

## Method

- IDA job `ida\jobs\settings_map.py`, run through the launcher, DB `FIN_SETTINGS`
  seeded `--copy-from ida\db\jobs\EXT_MENU_MAIN\EXT_MENU_MAIN.i64` (exit 0, log
  clean). It dumped, with real disassembly: the writer family `sub_3CCBC`..`sub_3CD4B`;
  every caller of each of the 6 writer entry points with 14 instructions of context;
  every caller of the F3xx senders `sub_976A`/`sub_9D82`; the default-init window
  around `sub_DEFA`/`0xE600`; the row-code dispatch `0x14EBE`..`0x150B4` with its
  jump table `0x150B6`, param records `0x15102` and all row-code sub-tables; and
  every abs16 access to `0xFF89C4`. Outputs: `ida\out\settings\{writers-family,
  writers-callsites,senders-callsites,default-init,rowcodes,flag-89C4-sites}.txt`.
- Raw-image cross-check in Python on the decrypted `.bin` (read-only): enumerated
  every `jsr`/`jmp` to each writer entry and each sender, and recovered each site's
  `n` (from `mov.w #n,r1`), multi-byte `base`+`count` (`mov.l #ram,er1` /
  `mov.w #cnt,r6`), and each sender's F3xx code + RAM source. The raw scan is a
  superset of IDA's xrefs — it also catches the dense `mov.w #n,r1; jmp` tail-call
  dispatcher in `sub_19xxx` (e.g. `sub_3CD1C`: 11 xrefs vs 28 real call sites).
  Spot-checked against the IDA disassembly (e.g. site `0x19244` → `mov.w #0x54,r1`
  → n=0x54). The two TSVs are generated from this pass.
- **Covered:** all 6 writer entries, all `sub_976A`/`sub_9D82` sites, the full
  row-code block, the flag byte, and default-init stores in `0xDC00`–`0xEC00`.
  **Not fully covered:** human-readable labels for the F3xx codes (the SUB-side
  F3xx→label decode was not re-derived — see Open); readers that reach a region
  byte via base-register displacement rather than abs16.

## Region extents

Each extent is the byte count of the region's own bulk save/restore, read from the
setup helper (Confirmed):

- **R1** `sub_395B8` (`0x395B8`): `79 06 01 80` `mov.w #0x180,r6` · `7A 00 00 00 05 80`
  `mov.l #0x580,er0` · `7A 01 00 FF 89 20` `mov.l #0xFF8920,er1`. Restore (read)
  `sub_3AB80` at `0x3959E`; save (write) `sub_3AD20` at `0x395AE`. Upper bound
  confirmed: EEPROM `0x700` is the next object (`0x395F0` `mov.l #0x700,er0` →
  RAM `0xFFBCB6`), so R1 = `0x580`–`0x700` = **0x180**.
- **R2** `sub_3D492` (`0x3D492`): `79 06 02 80` `mov.w #0x280,r6` · `mov.l #0xC000,er0`
  (`0x3D496`) · `mov.l #0xFF8AA0,er1` (`0x3D49C`). Restore at `0x3D478`, save at
  `0x3D488`. R2 = `0xC000`–`0xC280` = **0x280**. Largest individual write ends at
  n=0x265 (< 0x280), consistent.
- **R3** `sub_3D66C` (`0x3D66C`): `79 06 01 80` `mov.w #0x180,r6` · `mov.l #0xD000,er0`
  (`0x3D674`) · `mov.l #0xFF8D20,er1` (`0x3D67A`). Restore at `0x3D662`, save at
  `0x3D680`. Upper bound: EEPROM `0xD480` is the next object (`0x3D734` → RAM
  `0xFFB05A`), so R3 = `0xD000`–`0xD180` = **0x180**. (A partial re-save of R3 at
  `0x3D6B0` covers n=0x7E..0xAF — EEPROM `0xD07E`, RAM `0xFF8D9E` — a sub-block,
  consistent with the same region.)

## Settings-byte map (summary — full per-byte table in `settings-bytes.tsv`)

### Writer family `sub_3CCBC` (Confirmed, `writers-family.txt`)

Each region has a 1-byte entry (arg `n` in `r1`) and a block entry (`er1` = RAM
address, `r6` = count). The mapping is literally `EEPROM = RAM − RAM_base + EEP_base`:

| Region | 1-byte entry | block entry | key instructions |
| --- | --- | --- | --- |
| R1 | `sub_3CCBC` | `sub_3CCD0` | `3CCC8 add.l #0xFF8920,er1` · `3CCDC add.l #0x580,er0` |
| R2 | `sub_3CCEC` | `sub_3CD00` | `3CCF8 add.l #0xFF8AA0,er1` · `3CD0C add.l #0xC000,er0` |
| R3 | `sub_3CD1C` | `sub_3CD30` | `3CD28 add.l #0xFF8D20,er1` · `3CD3C add.l #0xD000,er0` |

Both forms end at `jsr sub_3AD20` (the byte-serial EEPROM write; `sub_3AB80` is the
read). Distinct persisted bytes per region (single-byte callers + block coverage):
**R1 144/384, R2 450/640, R3 99/384** (the large R2 count reflects big block
saves — APRS/WiresX text and tables, see below). Call-site evidence with context is
in `writers-callsites.txt`; the per-byte writer column of `settings-bytes.tsv`
names the exact site(s) for every persisted n.

### Bytes attributed to a menu item (Confirmed — F3xx sender reads the RAM byte)

The F3xx item senders `sub_976A` (`0x976A`) and `sub_9D82` (`0x9D82`) write an
`F3xx` item code to frame `+0x00` (`0xFF3D74`) and the value byte to frame `+0x20`
(`0xFF3D94`). Where a sender's value byte is read from a region RAM address, that
byte is attributed to that menu item (default value from `sub_DEFA`/`0xE600` where
found). The F3xx code *is* the menu-item identifier; human labels require the SUB
decode (Open #1).

| Region | n | RAM | EEPROM | BACKUP | F3xx | default | sender |
| --- | --- | --- | --- | --- | --- | --- | --- |
| R1 | 0x54 | FF8974 | 0x5D4 | 0x494 | F347 | — | 0x57F0 |
| R1 | 0x72 | FF8992 | 0x5F2 | 0x4B2 | F328 | 0x01 | 0x5832 |
| R1 | 0x73 | FF8993 | 0x5F3 | 0x4B3 | F380 | — | 0x4E52 |
| R1 | 0x76 | FF8996 | 0x5F6 | 0x4B6 | F397 | 0x01 | 0x4EDC |
| R1 | 0x84 | FF89A4 | 0x604 | 0x4C4 | F317 | 0x05 | 0x515C |
| R1 | 0x89 | FF89A9 | 0x609 | 0x4C9 | F316 | 0x19 | 0x535A |
| R1 | 0x8B | FF89AB | 0x60B | 0x4CB | F388 | 0x02 | 0x5370 |
| R1 | 0x8D | FF89AD | 0x60D | 0x4CD | F326 | 0x06 | 0x5392 |
| R1 | 0x8F | FF89AF | 0x60F | 0x4CF | F350 | 0x11 | 0x5698 |
| R1 | 0x90 | FF89B0 | 0x610 | 0x4D0 | F38C | — | 0x5676 |
| R1 | 0x91 | FF89B1 | 0x611 | 0x4D1 | F390 | 0x01 | 0x5734 |
| R1 | 0x92 | FF89B2 | 0x612 | 0x4D2 | F352 | 0x0B | 0x56E0 |
| R1 | 0x93 | FF89B3 | 0x613 | 0x4D3 | F327 | — | 0x5440 |
| R1 | 0x96 | FF89B6 | 0x616 | 0x4D6 | F31A | — | 0x56EE |
| R1 | 0x99 | FF89B9 | 0x619 | 0x4D9 | F313 | 0x01 | 0x5790 |
| R1 | 0x9A | FF89BA | 0x61A | 0x4DA | F393 | 0x06 | 0x58C6 |
| R1 | **0xA4** | **FF89C4** | **0x624** | **0x4E4** | **FLAGS** (see below) | 0x05 | — |
| R1 | 0xB0 | FF89D0 | 0x630 | 0x4F0 | F385 | — | 0x5978 |
| R2 | 0x00 | FF8AA0 | 0xC000 | 0xBEC0 | F3A3 | 0x00 | 0x5AB6 |
| R2 | 0x09 | FF8AA9 | 0xC009 | 0xBEC9 | F3BC | 0x00 | 0x62D8/0x62E6 |
| R2 | 0x1C | FF8ABC | 0xC01C | 0xBEDC | F3AD | 0x04 | 0x5D30 |
| R2 | 0x1D | FF8ABD | 0xC01D | 0xBEDD | F3AB | 0x04 | 0x5D22 |
| R2 | 0x129 | FF8BC9 | 0xC129 | 0xBFE9 | F3BE | 0x2C | 0x62F4 |
| R2 | 0x145 | FF8BE5 | 0xC145 | 0xC005 | F3B1 | 0x02 | 0x5E62 |
| R3 | 0x62 | FF8D82 | 0xD062 | 0xCF22 | F325 | 0x01 | 0x5E9BA |
| R3 | 0x6D | FF8D8D | 0xD06D | 0xCF2D | F324 | 0x0E | 0x6400 |
| R3 | 0x6F | FF8D8F | 0xD06F | 0xCF2F | F372 | — | 0x5E9CE |
| R3 | 0xB4 | FF8DD4 | 0xD0B4 | 0xCF74 | F329 | 0x01 | 0x5E9DC |
| R3 | 0xB7 | FF8DD7 | 0xD0B7 | 0xCF77 | F364 | 0x01 | 0x5E964 |
| R3 | 0xBC | FF8DDC | 0xD0BC | 0xCF7C | F32A | 0x01 | 0xD288 |

Observation (Inferred): the F3xx codes cluster by region — R1 carries `F31x`–`F39x`
(general DISPLAY/SIGNALING/CONFIG-style items), R2 carries `F3A3`–`F3BE` (the APRS /
GPS / beacon family, matching R2's large text/table blocks), R3 carries a mix of
`F32x`–`F37x`. Senders that read a *channel/VFO working-record* field instead of a
region byte (`sub_9D82` F322 RX MODE from `+0x19`; F391 STEP `+0x14`; F38E RPT SHIFT
`+0x15`; F346 PR FREQ `+0x34`; F342 DCS INV `+0x35`; F348 SQL S-METER `+0x37`) back
the 32-byte channel record (pc-02 §3.1 / doc 23 §5), not these three regions.

### Multi-byte block saves (Confirmed — these persist variable-length settings)

Large block writers reveal structured settings stored as units (full list in the
`writer` column of the TSV):

- **R2** (APRS/GPS/WiresX, the big one): n=0x22 ×58 (`0xFF8AC2`), n=0x5C ×130
  (`0xFF8AFC`), n=0xDE ×74 (`0xFF8B7E`), n=0x12C ×22 (`0xFF8BCC`), n=0x145 ×57
  (`0xFF8BE5`), n=0x18E ×20, n=0x1A2 ×20, n=0x25A ×12 — character/table settings.
- **R1**: n=0x06 ×16 (`0xFF8926`), n=0x36 ×18 (`0xFF8956`), n=0x58 ×16 (`0xFF8978`).
- **R3**: n=0x06 ×10 (`0xFF8D26`), n=0x70 ×14 (`0xFF8D90`), n=0x120 ×15 (`0xFF8E40`).

### Flag byte `0xFF89C4` (R1 n=0xA4, EEPROM `0x624`, BACKUP `0x4E4`) — Confirmed

A bit-packed flags byte, default **5** (`0b0000_0101`, `sub_DEFA` `0xE67E`; forced
to 5 on a `BACKUP.dat` restore whose checksum matched, `sub_7481A` `0x74AB6`). Saved
individually by `sub_193CA` (`mov.w #0xA4,r1` → `sub_3CCBC`). Bit roles (toggle =
`bnot`, read = `btst`/`bld`; sites in `flag-89C4-sites.txt`):

| Bit | Toggle | Readers / role |
| --- | --- | --- |
| 0 | — | default set; no reader found (Unknown) |
| 1 | `0x16446` | `0x1655E`,`0x17996`,`0x3E792`,`0x48D08`,`0x49C30` (feature flag) |
| 2 | `0x1644E` | default set; no abs16 reader found (Unknown) |
| 3 | `0x1645E` | `0x14B08` = **enable 1-based group 13** (the spare MAIN menu slot, doc 23) |
| 4 | `0x16456` | **RAM DISPLAY enable** — read widely (`0x1505A`,`0x14EF2`,`0x2998C`,`0x7D3A`…); carried to SUB by `sub_7C20` `bld #4` (`0x7C62`) into frame+7 bit 7 |
| 5–7 | — | no toggler/reader found (Unknown) |

The four toggles are driven by an entry-code buffer at `0xFFAD8E` (`sub` around
`0x16420`) and then saved via `sub_193CA` (doc 23 §4).

## Row-code table `0x1515C` (resolves doc 23 Open #3) — Confirmed

`sub_14EBE` reads the 0-based group (`0xFF8F2E`), ×4, and jumps through the 13-entry
dispatch table at **`0x150B6`** (`78 B0 6B 26 00 01 50 B6` `mov.l @(0x150B6,er3),er6`
· `0x14ED2 jmp @er6`). Each of the 13 group cases loads a param record from `0x15102`
(`{u16 clamp, u32 cursor=0xFFAD9B}`), calls the clamp `sub_3F62E`, then indexes its
own row-code sub-table and returns `table[index]` as the row code. The 15 sub-tables
(group 1/DISPLAY splits into 3 by `0xFF8F4F`) run **`0x1515C`–`0x151EB` = 0x90 (144)
bytes**; code resumes at `0x151EC`. Full dump in `1515c-rowcodes.tsv`; raw block:

```
8e8468403f285170c000 13355f00 b8b5c1b2c2c3c4c5c6c7c8c9cacbcccdcecfd0d1d6d3
454e6f7c7d00 1a1b4d4b644a 16262.. 5862.. bb8d bcbdbebfb400 0f14..66 (28, APRS)
8889 8285 871e1d1fd600 b300 b7d2d3d7d600
```

| Table | group (1-based) | rows | note |
| --- | --- | --- | --- |
| `0x1515C` | 1 | 10 | holds the **inert** `cmp #0x69` gate (`0x14EE4`) — no entry is 0x69 |
| `0x15166`/`0x1516A`/`0x15180` | 2 (DISPLAY, 3 sub-cases) | 4/22/6 | selected by `0xFF8F4F` |
| `0x15186` | 3 | 6 | |
| `0x1518C` | 4 | 14 | `0x8F` check at `0x14F96` |
| `0x1519A`,`0x151A0`,`0x151A2`,`0x151A8` | 5–8 | 6/2/6/22 | |
| `0x151BE` | 9 = **APRS** | 28 | |
| `0x151DA` | 10 | 4 | |
| **`0x151DE`** | **11 = OPTION** | 6 | **idx 4 = `0xD6` = RAM DISPLAY**, gated `btst #4,@0xFF89C4` at `0x1505A` |
| `0x151E4` | 12 | 2 | |
| `0x151E6` | 13 | 6 | last table; ends `…D6 00` at `0x151EA`/`0x151EB` |

**`0x69` index:** none. `0x69` is **absent** from `0x1515C`–`0x151EB` (Confirmed by
full byte scan). doc 23's inference "0x69 is MAIN's row code for RAM DISPLAY" is
corrected: RAM DISPLAY is row code **`0xD6`** at **index 4** of the OPTION table
`loc_151DE` (`0x151DE`). The `cmp.b #0x69` at `0x14EEC` governs **group 1** and
never matches in this EXP 1.02 build — it is a latent skip-hidden-row gate (same
shape as the OPTION one) with no 0x69 entry populated here.

## Open

1. **F3xx → human label.** The 30 attributed bytes carry their F3xx item code but
   not a text name; map each F3xx to its SUB-side setup label (the SUB receives the
   frame and routes by `(group,item)`), to upgrade `menu_item` from code to name.
2. **663 confirmed-setting bytes with item Unknown.** These have a dedicated writer
   (so they are real settings) but no F3xx sender was found; trace each save
   function's menu caller, or read them via a known-good `BACKUP.dat` diff, to name
   them.
3. **715 bulk-only bytes.** Saved only by the region bulk loop; many are interior
   bytes of the R2 text/table blocks or reserved padding. Decompose the big R2
   blocks (n=0x22/0x5C/0xDE/0x145 …) into their APRS/WiresX sub-fields.
4. **Flag byte `0xFF89C4` bits 0, 2, 5–7.** Bits 0 and 2 default-set with no reader
   found in the abs16 scan; 5–7 unseen. Do not assume free.
5. **Non-abs16 readers.** Readers that reach a region byte through a base register +
   displacement were not enumerated; a displacement-aware scan would add attributions.
