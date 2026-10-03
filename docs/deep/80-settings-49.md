# 80 — The last 49 unattributed settings bytes (lane J12)

Owner-side, static, read-only analysis of the owner's FT3DR/FT3DE ver 1.02 MAIN image
`decrypted\FT3D_MAIN_ver102_EXP.bin` (H8SX, big-endian, base 0, so file offset = address). No image was
modified, nothing was connected to or written to any device, and the closed window `0x078106`–`0x07B753`
was not analysed. Model: **Opus 4.8 (`claude-opus-4-8`)**.

Machine table: `ida\out\settings-49\settings-49.tsv` (per-byte: region, n, RAM addr, EEPROM, writer stub,
readers, writer-callers/feature code, live/dead, attributed feature, confidence). Raw evidence:
`ida\out\settings-49\dump.txt` (writer sites + full screen tables + every reference to the 49 RAM bytes),
`probe.txt` and `probe2.txt` (caller/reader disassembly + xref chains). Job scripts: `ida\jobs\j12_set49.py`,
`j12_probe.py`, `j12_probe2.py`. DB `J12_SET49`, seeded `--copy-from MAIN_FINAL2`, reopened twice; every run
`idat_exit 0`, no error file.

## Verdict

**48 of the 49 are attributed to a radio feature; 1 is dead.** I6 reached 614/663 settings-byte
attributions by walking the setup-screen exit handlers (`0x19A9E` table). The 49 that remained are exactly the
persisted bytes whose dedicated save stub is **not a `0x19A9E` exit-table target** — they are saved by
`jsr`-to-tail-stub calls made from **operational feature code** (the band/VFO state machine, the FUNC/soft-key
dispatch, scan/priority, APRS, power-on config, and a generic per-row bitmap editor), not from a menu item's
exit handler. That is precisely why a menu-screen walk could never see them. The one true dead byte is
**R1 `n=0xAA` / `FF89CA`**: its only reference image-wide is the factory-default store, it has no reader, and
its dedicated save stub at `0x1935E` is unreachable. One further byte, **R1 `n=0x17` / `FF8937`**, is read by a
display routine but has **no RAM writer and an unreachable save stub**, so its value is frozen at the default —
read-live but save-dead. The remaining 47 are live persisted state with confirmed readers and feature-code
writers. None of the 49 touches USB, SCI-C, the DSP or the closed window.

Final count across the F5/I6 663: **662 attributed, 1 dead (`FF89CA`)**. Of the 49: **47 live + feature-named,
1 read-live/save-dead (`FF8937`), 1 dead (`FF89CA`)**.

## Method

- **The 49 derived by set difference (Confirmed).** From F5's `settings-bytes.tsv`, the 663 "dedicated-writer,
  no-menu-item" bytes are the rows whose `writer` column names a `single sub_3CCxx@…` or a `…[blk …]` call in
  addition to the region bulk loop. Subtracting I6's 644-row `settings-bytes-ext.tsv` keys leaves exactly 49.
  The list and every writer call-site address are in `settings-49.tsv`.
- **Writer → function → caller (Confirmed).** `j12_set49.py` took each of the 18 distinct dedicated writer
  call-sites, found its containing function in the seed DB, and listed every `jsr`/`jmp` caller with context.
  It then dumped the full composite routines and, correcting an abs16 sign-extension bug (H8SX abs16 operands
  decode as `0xFFFF8xxx`, not `0xFF8xxx`), scanned all 124 k code heads for every reader/writer of each of the
  49 RAM addresses, plus a base-plus-displacement pass over the three region bases.
- **Screen tables decoded in full (Confirmed).** The job dumped `0x782C` (239 BE32 notifiers), `0x12268`
  (219 BE32 dials) and `0x19A9E` (206 BE16 exit offsets, handler = `0x148A0+val`). This proved that the stubs
  saving `n=0x16/0x17` (`0x192A0/0x192A8`) and `n=0xA9/0xAA` (`0x19352/0x1935A`) are **not** targets of any exit
  slot: the exit table jumps from id `0x2B`→`0x19290` straight to id `0x3E`→`0x192B0`, skipping them.
- **Feature naming (`probe.txt`, `probe2.txt`).** Each save-caller function and representative readers were
  disassembled, and `XrefsTo` was walked up to 3 levels to the feature root. The chains converge on
  `sub_2070` (band/VFO state machine), the `0x11xxx` FUNC/soft-key dispatch, `0x6Cxxx` (dial step/rate),
  `0x5Bxxx`/`0x5Cxxx` (scan + display-frame), `0x50EA8` (APRS TX), and `0x37FA6` (a 15-entry list editor).
- **Not done.** Human menu labels. These bytes are not menu items, so they have no setup-label row; several
  are operational state with no on-screen label at all. Feature *names* below are Inferred from the handler's
  RAM footprint; the reader/writer *addresses and mechanism* are Confirmed.

## Findings

Full per-byte data is in `settings-49.tsv`. The 49 fall into 15 groups.

### Live, feature-attributed (47 bytes)

- **R1 `0x58`–`0x67` → `FF8978` (16 bytes): per-row toggle BITMAP.** Edited by the generic bit editor at
  `0x15E64` (reached from the dial dispatch `sub_15E42` and the exit path `0x19158`). It resolves a row code
  via `sub_14C90` (`cmp #0x32`), derives a byte+bit index from `FF8F4E/FF8F4C` (`divxu #8`), toggles that bit
  in `@(FF8978,er3)` (`0x15E8E`) and block-saves 16 bytes (`0x15E9C`). Read back at `0x15ECA`. A 128-bit
  per-item on/off map (Inferred: setup-menu item visibility / enable list). Live.
- **R1 `0xAB` → `FF89CB`: band/VFO dial index.** Readers `0xCE1E` (indexes table `0xCE40` = `02 03 04 05 06 07
  08 09 01 0F 00`, result → record `+0x3E`), `0x1D304`, `0x1EEBA`, `0x1F0B4`. Saved by `sub_1938A` from fn
  `0x1D220` (gated on band-record `+0x11 == 6`) and fn `0x1E892`. Live.
- **R1 `0x138`/`0x139` → `FF8A58` (word): band/VFO working word.** fn `0x1D2C0` computes it via `sub_1D300`
  (which reads `FF89CB`) and writes it to band-record `+0xE`, to `FF90FE` and to `FF8A58`, then saves via
  `sub_193F8`; fn `0x1D2EE` reloads/edits it. Same band-dial mechanism as `FF89CB`. Live.
- **R1 `0xA9` → `FF89C9`: runtime 2-state flag.** Toggled 0↔1 by fn `0x7421E` (the `0x74xxx` clone/monitor
  region, keyed on `r1h`), cleared by the VFO-reset routine fn `0x2DCE` (`0x2DE8`), read at `0x229EA`,
  `0x74226`, `0x74236`. Persisted via the R1 bulk loop; its dedicated stub `0x19352` is unreachable but
  irrelevant. Live.
- **R2 `0x0A` → `FF8AAA`: APRS/beacon parameter.** Sits next to the F3BC-attributed byte (R2 `0x09`). Read into
  the beacon/message buffer field `FF9E01` by fn `0x50EA8` (APRS TX setup), and at `0x22D2E`. Default 1. Live.
- **R2 `0x18C` → `FF8C2C`: FUNC/soft-key display toggle (2 bits).** Bits 0/1 toggled by fn `0x51408` (reached
  from the FUNC dispatch `0x111F0`, on soft-key code `A9F0 == 5`) and mirrored to `FF8EAB`/`FF8EAC`; tested at
  `0x17BE6`, `0x17F4E`, `0x18DD4`, `0x50AA2`; cleared in the VFO reset `0x2DCE`. Live.
- **R3 `0xB0`/`0xB1` → `FF8DD0` (word): `0x5Cxxx` display/scope-frame parameter.** Default word at `0x0E398`;
  read at `0x5C746` inside fn `0x5C602`, which builds a serial frame to `FF0206/FF0208`; saved via `sub_19A30`
  from the same function. Live.
- **R3 `0xB5`/`0xB6` → `FF8DD5`/`FF8DD6`: core band/VFO current-state.** `FF8DD5` is read **127×** across the
  image; saved by fn `0x24C88` (band commit — `eepmov` of 5 bytes `FFAC77→FF8EC2`) and fn `0x1C9C2` (the
  band/VFO switch, which also drives `FF8D20`, `FF8EB5/B6/B7`, `B11E/B11F`). `FF8DD6` is handled by fn
  `0x24724` (copies `FF96F9→FF8EB3`, writes `FF8ED6/D7`). Live, high-value.
- **R3 `0xBE` → `FF8DDE`: core operating-mode/state byte — the most-read of the 49 (216 readers).** Forced to
  0 and saved in the power-on path fn `0x1058A`, re-saved at `0x105B6`. Live, high-value.
- **R3 `0xBF`/`0xC0`/`0xC7` → `FF8DDF`/`FF8DE0`/`FF8DE7`: per-function dial step/rate cluster (`0x6Cxxx`).**
  Each follows the same shape: read the persisted byte, add an offset, write it to `FFB3DF`, set `FFB3D5` bit 6,
  and load the repeat/accel countdown `FF959F = 0x14`. `FF8DE0` is read 72×. Reached from the soft-key dispatch
  `0x11xxx` and band machine `0x2070`. Live.
- **R3 `0xC1` → `FF8DE1`: config-tracked mirror of `FF8F4C`.** Maintained by fn `0x2648` in the power-on/config
  path, which compares `[FF8006]` (region/version config) against ROM `[0xDD0E]` and, when `FF8F4C` differs,
  copies it into `FF8DE1` and saves via `sub_19A64`. Default 0xA; 5 readers. Live.
- **R3 `0xC2` → `FF8DE2`: scan/priority parameter (`0x5Bxxx`).** Saved by fn `0x5B772` (which drives
  `FFB0BE/B0BF`, `FFB3D8`). Default 0xA; 4 readers. Live.
- **R3 `0x120`–`0x12E` → `FF8E40` (15 bytes): structured preset/value list.** Default-seeded by `sub_DEFA` at
  `0x37EB6` (`eepmov` of 14 bytes from table `0x38066`), edited by the multi-field editor fn `0x37FA6`/`0x37EB6`
  (reached from `0x145C4`), with per-field value range `0x16..0xED` and a selector in `FF94FD`; `FF8E4E` is the
  selected element (7 readers). Live.

### Read-live but save-dead (1 byte)

- **R1 `0x17` → `FF8937`.** Read once, at `0x22E54` inside display fn `0x22E3A` (gated on `FF89BE` bit 0 =
  SQL EXPANSION; the byte is offset by `+0x50` and written to the display register `FFAC06`). But it has **no
  RAM writer anywhere**, and its dedicated save stub `0x192A8` (`mov.w #0x17,r1; jmp sub_3CCBC`) is **not a
  `0x19A9E` exit target and has no `jsr`** — unreachable. So the value is permanently its default and the save
  is dead code. Attributed to the `0x22E3A` display path, but flagged save-dead.

### Dead (1 byte)

- **R1 `0xAA` → `FF89CA`.** Its only image-wide reference is the factory-default store at `0x0E678`
  (`sub_DEFA`). No reader, no runtime writer, and its dedicated save stub `0x1935E` is unreachable (not a
  `0x19A9E` target, no `jsr`). Dead in ver 1.02 — a leftover 1-byte setting with a complete-but-unused save
  stub, persisted only incidentally by the R1 bulk loop.

### Why I6 missed these (Confirmed)

The `0x19290…0x192BF` and `0x19342…0x19390` clusters are runs of 8-byte `mov.w #n,r1 ; jmp sub_3CCxx`
exit-stubs. The `0x19A9E` table maps each live screen to one of them; the four skipped stubs (`n=0x16, 0x17,
0xA9, 0xAA`) have no screen pointing at them. The other 45 bytes are saved by block/single stubs invoked by a
plain `jsr` from feature code far outside the `0x148A0…0x19Bxx` handler region — the band machine, the FUNC
dispatch, scan, APRS and power-on paths. A setup-screen exit walk, by construction, reaches none of these.

## USB relevance

None. All 49 are UI/operational-state bytes in RAM regions R1/R2/R3 with EEPROM/BACKUP.dat backing. No reader or
writer among them, or in any of the newly-traced feature functions, addresses the USB module (`0xFFEE00`),
SCI-C (`0xFFFF88`), the DSP driver or the closed window `0x078106`–`0x07B753`. The three mission answers are
unchanged. The only mildly notable item is `FF8DD0`/`FF8DD1` feeding a serial frame to `FF0206/08`, but that is
an internal LCD/display frame, not USB.

## Open

1. **Name the two core state bytes on the radio UI.** `FF8DDE` (216 readers) and `FF8DD5` (127 readers) are the
   fundamental band/VFO/mode state. Deciding which is "VFO vs MR vs HOME", which is "A/B band", needs the
   operating-mode decode that other lanes hold, cross-referenced with `FF8D20` and the band record `FF8EE0`.
2. **The 15-byte `FF8E40` list.** Decode table `0x38066` and the `0x37FCE` dispatch to name the preset list
   (likely a band-edge / scan-edge or PMG preset set).
3. **The `0x6Cxxx` dial step/rate cluster** (`FF8DDF/E0/E7`). Confirm whether `FF959F = 0x14` is the
   dial-acceleration window and map each byte to its function (VFO dial, memory dial, etc.).
4. **Corrections for the next MAIN seed.** The save stubs at `0x192A0` (`n=0x16`), `0x192A8` (`n=0x17`),
   `0x19352` (`n=0xA9`) and `0x1935A` (`n=0xAA`) are unreachable dead code — do not credit them to any screen.
