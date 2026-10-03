# 122 — Touch / key-table leftovers: modes, rec+5, the 156 K3-joins, the 37 @erN sites, screen 0x0A (MAIN, lane M10)

> Lane M10, model `claude-opus-5-5`. Owner-side static analysis of `decrypted\FT3D_MAIN_ver102_EXP.bin`
> (H8SX, base 0, big-endian, file offset = address) and, for labels only, `FT3D_SUB_ver102_ALL.bin`
> (RX, little-endian, file offset = address − `0xFFC00000`). Nothing was connected to a radio. No image
> byte changed (sha256 MAIN `8e3ecd05409b2c31…`, SUB `b93570b3c2f69ccb…`, re-checked after the work).
> Private DBs `M10_KEYS_SUB` (`--copy-from K7_SUB_FINAL3`); MAIN work was done offline against G1's
> per-address H8SX oracle and K1's final4 masks (the same model L6 used). No shared DB was opened, no
> published mask or owning doc was edited. Builds on L6 (doc 103), K2 (84), K3 (85).

**Tables in `ida\out\touch-key-leftovers\`:**

| File | Content |
| --- | --- |
| `zones-final.tsv` | all 511 K3 zones = L6's `zones-resolved.tsv` + two columns `m10_status`, `m10_note`; the 156 K3-join-kept rows re-modelled, the 4 F200 rows resolved |
| `work\ern_resolved.tsv` | the 37 indirect `@erN` sites, each classified with target count, per-target window/USB-SCI-C scan |
| `work\sub_labels.tsv`, `sub_labels.rep` | deep (depth-6) SUB string harvest from the F701/F703 screen handlers |
| `gen\` | offline scripts: `d.py` (disassembler), `m10_ern.py` (@erN resolver + safety scan), copies of L6's `l6lib.py`/`sublib.py`/`walk.py`/`trace.py`/`resolver.py` reused read-only |

## Verdict

**rec+5 is the band's VFO/memory operating-mode index (0–5), decisively named by its own on-screen
3-char labels** at `0x0048D8`–`0x0048FF`, selected by table `0x0048C0[rec+5]`: **0 = `MR `, 1 = `VFO`,
2 = `MR ` (memory-tune variant), 3 = `TUN`, 4 = `PMS`, 5 = `HOM`**. It is the low nibble of packed record
byte `0xFFAC77`, unpacked to live record `+5` at `0x03FEEC`; it drives the home key table
(`0x0115EC + 0x44·rec+5`, resolver `0x010E92`) and the home render handler (table `0x07814[rec+5]`,
`0x006C32`). **Confirmed.**

**The home application mode `[A9F9]` only ever takes the values {0,1,4,5,6,8,9,10}** (24 writer sites,
all read; no path writes 3) — so **`[A9F9]=3` does not exist**, a correction to the task framing.
`[A9F9]=1` is the status / GPS-info display (F10D/F10F/F111; SUB "ALTI m", date strings; L6). `[A9F9]=8`
and `10` are the two **C4FM digital-group screens** (F701/F703), siblings of WIRES-X (`[A9F9]=9`): they
share the WIRES-X `[B3EA]` state machine and the `[B2A5]` digital-group flag (`=1` for mode 10, `=2` for
mode 9). Mode 8 is entered from the F-menu (idx `0x0B` → `0x01F5C8`) and is **gated on a DG-ID/preset
being set** (`[BA32]≠0` else popup `0xA7`); mode 10 by a key-1 short press (`0x063C04`). **GM (Group
Monitor) is the leading Inferred name for mode 10** and mode 8 is GM-family, but this rests on structure
and the DG-ID gate, not a label: **no `GM` / `GROUP MONITOR` text exists in either image** (Not found,
full ASCII scan of both), because the F701/F703 titles are drawn from the SUB label table by computed
index, not as direct strings.

**Screen 0x0A (page F112) is a per-band 16-entry group-name list editor.** Record `0x0296E8` edits a
**15-char name** (not 16; descriptor `0x05E376` = `00 0F 00 FF B9 ED`), record `0x029712` a **3-char item**
(not 4; descriptor `0x05E3B4` = `00 03 …`), both into buffer `0xFFBA02`. Default names `GROUP 01`…`GROUP 16`
/ `NEW GROUP` (`0x05DDFC`, 16-byte stride) are installed into `0xFFB9F2` by `0x00E0A2`. Corrects K3's
"16-char/4-char" field sizes.

**The re-model holds K3's negative at every new edge.** All 156 K3-join-kept rows resolve to the same key
table K3 used (`sel_screen(rec1)=scr_kt(screen)`, or `sel_home` for the A9F9=4/5 APRS pages) — **no
key-table correction**. The 37 `@erN` sites resolve to 234 concrete targets; a depth-1 scan and a depth-3
descent (17,057 instructions) from them find **0 window branches, 0 USB/SCI-C operands, 0 reset-entry
jumps, 0 of K3's 69 unopened screens**. No touch zone or key opens a hidden/service screen, the service
window, a USB register or SCI-C.

## Method

1. **Offline MAIN decode** with G1's per-address H8SX oracle (`h8s-decode\work\bu_all.tsv`), raw image
   bytes, and L6's `resolver.py`/`walk.py`/`trace.py` reused unchanged (read-only).
2. **rec+5**: scanned every writer/reader of band-record `+5` (abs `0x90F5` and `@(5,erN)`); the unpack at
   `0x03FEEC` and the label/handler tables `0x0048C0`/`0x07814`; read the label strings straight from the
   image.
3. **Modes**: enumerated all 24 `mov.b …,@0xA9F9` writer sites and their immediates; disassembled the
   mode-1/8/9/10 entry points and the shared render `0x066966`; traced `[B2A5]`, `[BA32]` and the popup
   dispatch `0x01BF78`.
4. **SUB labels** (`M10_KEYS_SUB`, job `ida\jobs\m10_sub_labels.py`): depth-6 call-closure (direct +
   pointer-table dispatch) from the F701 (`0xFFEEF315`) and F703 (`0xFFF420F6`) screen handlers; full
   ASCII scan of both images for GM/group/DG-ID terms.
5. **156 re-model**: reverse-mapped each screen id 1…131 to its key table and slot-10 handler, matched
   K3's cited handler per row, and checked the resolver's `select()` routes to the same table.
6. **37 @erN**: reproduced set-P's depth-4 descent to list the sites, resolved each er6 source, enumerated
   targets, and re-ran the window/USB/SCI-C/hidden-screen descent from all targets (`m10_ern.py`).

**Not covered / limits**: the exact FT3D feature behind screen 0x0A's group list (GM group vs. a preset
registry) stays Inferred; mode-8/10 names are Inferred (no confirming string); the SUB title glyphs drawn
by the label table were not decoded to text.

## Findings

### 1. rec+5 = band VFO/memory operating mode (Confirmed)

`sub_10748` sets `er0 = [0xFF812A]` = the live per-band operating record (band A `[0xFF8122]`, band B
`[0xFF8126]`/fixed `0xFF90F0`; `0x01076E`/`0x010782`/`0x010796`). The resolver reads `rec+5 = [er0+5]`.

- **Source**: `0x03FEE4 mov.b @0xac77:16,r3l ; 0x03FEE8 and.b #0xf,r3l ; 0x03FEEC 6e 8b 00 05` → `[er0+5] =
  [0xFFAC77] & 0x0F`. rec+5 is a 4-bit field of packed header byte `0xFFAC77`.
- **Mode label** (`0x00CA4C`): `er5 = rec+5·4`; `0x00CA58 mov.l @(0x48c0:16,er5),er5`. Table `0x0048C0`
  holds 6 length-prefixed ASCII labels:

| rec+5 | ptr | bytes | label |
| --- | --- | --- | --- |
| 0 | `0x0048E0` | `00 03 4D 52 20` | `MR ` (memory recall) |
| 1 | `0x0048D8` | `00 03 56 46 4F` | `VFO` |
| 2 | `0x0048E0` | — | `MR ` (memory-tune variant; special-cased) |
| 3 | `0x0048E8` | `00 03 54 55 4E` | `TUN` (tune) |
| 4 | `0x0048F0` | `00 03 50 4D 53` | `PMS` (programmable memory scan) |
| 5 | `0x0048F8` | `00 03 48 4F 4D` | `HOM` (home) |

- **Home key table**: `0x010E4E … 0x010E92 79 06 00 44` → `0x0115EC + 0x44·rec+5` (one 17-slot table per
  mode). rec+5==2 takes the `sub_3F1F2`/`sub_4906` exceptions (→ `0x011784`/`0x0117C8`/`0x01276C`): the
  memory-tune sub-state of MR.
- **Home render**: `0x006C32 mov.l @(0x7814:32,er3),er6` with `er3=rec+5·4`; table `0x07814` =
  `004938 004900 004938 004900 004AB0 004900` for rec+5 0…5.

### 2. `[A9F9]` application modes (Confirmed values; names Inferred)

All `mov.b …,@0xA9F9` writers take immediates **{0,1,4,5,6,8,9,0x0A}** (`0x01CF72`=1, `0x01D196`=4,
`0x01D18E`=5, `0x01F376`=6, `0x01CFC8`/`0x05FD0E`=9, `0x01F5DC`=8, `0x063C12`=0xA, `0x022D50`/…=0;
the `?` writers restore from saved `[0xFFA9FB]`). **No writer produces 3; `[A9F9]=3` does not exist**
(Confirmed, scope: all 24 writers).

| `[A9F9]` | Name | Entry | Evidence |
| --- | --- | --- | --- |
| 0/2/6/7 | home (VFO/MR/HOME/PMS/TUNE per rec+5) | — | §1 |
| 1 | **status / GPS-info display** (F10D/F10F/F111) | key 3 toggle `0x01CF72` | Inferred: SUB "ALTI m" `0x3485DD`, date `0x03D399` (L6) |
| 4 / 5 | **APRS** | F-menu `0x01D18C`/`0x01D194` | L6 (Confirmed) |
| 8 | **C4FM digital-group (GM-family)**, F701/F703 | F-menu idx `0x0B` → `0x01F5C8`, **`[BA32]≠0` else popup `0xA7`** (`0x01F5C8 6a 0c ba 32 … fc a7 … fc 08 6a 8c a9 f9`) | Inferred |
| 9 | **WIRES-X** | key 6 short → `0x05FD02` (`B2A5=2`) | L6 (Confirmed, SUB labels) |
| 10 | **GM (Group Monitor)** candidate, F701/F703 | key 1 short → `0x063C04` (`fc 0a 6a 8c a9 f9`; `B2A5=1`) | Inferred (leading) |

Modes 8/9/10 share the `[B3EA]` state machine and render `0x066966`; `[B2A5]` (1=mode10, 2=mode9) is the
digital-group discriminator read at `0x0086BE`. **F701 = SUB screen `0x2E` (handler `0xFFEEF315`), F703 =
SUB screen `0x44` (`0xFFF420F6`)**, states 7/8 of modes 8/10 and also WIRES-X states `0x35`/`0x36`. A
depth-6 closure of both handlers (178 / 161 functions) found no title string and does not reach the DG-ID
setup functions — the titles come from the SUB label table by index. **No `GM`/`GROUP MONITOR` string
exists in either image** (Not found; the only group/DG-ID text is `DG-ID`, `PRESET`, `DG-ID TX/RX`
`0xFFF48E93`+, `APRS MSG GROUP`, and MAIN `GROUP 01`…`16`/`NEW GROUP`).

### 3. Screen 0x0A (page F112) — 16-entry group-name list (Confirmed structure)

Reached when a band's current screen byte `rec+1 == 0x0A` (push helper `0x3FF10`, e.g. `0x014BD8 fb 0a`);
entry context `0x024540` selects band A `[0xFF8122]` vs band B `0xFF90F0` by `[0x8EA0].b6`. Handler
`0x029406` dispatches jump table `0x02941C[B9E4]`; `B9E4=4` → name record, `B9E4=5` → item record.

| Record | Field | Descriptor | Buffer | Commit |
| --- | --- | --- | --- | --- |
| `0x0296E8` | **15-char name** (K3 said 16) | `0x05E376` = `00 0F 00 FF B9 ED` (max 15, pad `0xFF`, count `0xFFB9ED`) | `0xFFBA02` | `0x05E33E` |
| `0x029712` | **3-char item** (K3 said 4) | `0x05E3B4` = `00 03 00 FF B9 ED` (max 3) | `0xFFBA02` | `0x05E37C` |

Default names `GROUP 01`…`GROUP 16` / `NEW GROUP` (`0x05DDFC`, 16-byte stride) are copied into `0xFFB9F2`
by `0x00E0A2` (`7a 02 00 05 dd fc … eepmov`), then `0xFFB9F2`→`0xFFBA02` for editing. The list entries are
a 6-byte-stride array at `0xFFBA12` indexed by `[0xFFB9EC]`, count `[0xFFB9EA]`. This is a per-band named
group/preset registry (exact FT3D feature Inferred; the `GROUP nn`/DG-ID context makes a GM/preset group
list the leading reading).

### 4. The 156 K3-join-kept rows re-modelled (`zones-final.tsv`; no correction)

The push helper sets `rec+1 = screen id`, so the resolver's `sel_screen(rec1)` reduces to
`scr_kt(screen)` — identical to K3's join. Verified per family:

- **Menu/setup screens** → `sel_screen→scr_kt(screen)`: F300(`0x0C`, slot10 `0x0298C8`✓), F006(`0x55`),
  F330/F331/F344/F3A5/F3A6(`0x1A`/`0x1B`), F341/F34B(`0x26`/`0x72`), F38A(`0x4F`), F392(`0x71`),
  F396(`0x66`), F3D2/F3D3(`0x1D`/`0x1E`), F401/F402(`0x0A`), F403(`0x09`), plus the keypad/char pages
  F003/F3B3/F3B8/F513/F515/F366/F371/F3BA/F3D1/F516 (virtual-key dispatch via the screen table).
- **APRS pages** (A9F9=4/5) → `sel_home` home tables #5/#6/#7, slot10 `0x02870A`/`0x02889A`/`0x0289BC`
  (`0x0111F0`/`0x011234`/`0x011278 + 0x28`) — exactly K3's cited handlers: F500/F501/F502/F503/F510/F511/
  F512/F518.
- **Power-on specials** F009/F00A/F00B — the restart/market screens L6 noted.

One state-dependency (not a correction): the low-id screens `0x09`/`0x0A` (F401/F402/F403) would be
diverted to the home key table if `[A9F9]==1` (resolver `0x010920`); those are band sub-screens shown only
under `[A9F9]∈{0,2,6,7}`, so the diversion is not reachable in their real display context.

The 4 formerly **not-modelled** F200–F22C rows (table `0x027DE2`) also resolve: F200 → MAIN screen `0x1B`
→ `scr_kt(0x1B) = 0x012A9C`, slot10 `0x029CFE` (a bounded item-list handler; no window/USB).

### 5. The 37 indirect `@erN` sites resolved (`work\ern_resolved.tsv`)

All 37 are table- or record-driven, not free indirect jumps:

- **18 indexed/const tables** (`mov.l @(tbl:32,erN),er6` / `#tbl`): the B3EA render & touch tables
  `0x02ADD0`/`0x02BA86`, the F-menu grid `0x02188C` (25 cells), the screen-0x0A table `0x02941C` (8), the
  mode-8 table `0x01F646`, WIRES-X handler tables `0x05A3CE`(44)/`0x05CE98`(33), etc. → 234 concrete
  targets.
- **10 BBC2 index-helper bodies** (`0x028558`…`0x0286C0`): `er6 = caller_table[IDX−1]` — per-call zone
  handler tables already in `zones-final.tsv`.
- **7 record-field dispatchers** (`0x028D12`…`0x028DA8`, dispatcher `0x028CBC`): `er6 = record[+00/04/08/
  0C/14/18/1C]` — per-record fields (K3 `records.tsv`).
- **2 key-table[key] / offset dispatchers**: `0x0191A8` (`er6 = 0x148A0 + BE16[0x19A9E+2·key]`), `0x029ADA`
  (`er6 = kt[A9ED]` of item-list table `0x014818`).

A depth-1 scan of the 234 targets and a depth-3 descent (17,057 instructions) from them: **0 window
branches, 0 USB/SCI-C operands, 0 reset-entry jumps, 44/43 screen-write sites with ids
{00 09 0A 0B 26 2B 52 6C 72 7F 8C} — none in K3's 69 unopened**.

### 6. Zone status after this lane (511 total, `zones-final.tsv`)

| m10_status | count | meaning |
| --- | --- | --- |
| resolved:state-dependent | 228 | L6 |
| m10-confirmed | 156 | re-modelled here, = K3's key table |
| resolved:single-handler | 74 | L6 |
| no-sender | 46 | pages MAIN never sends (F801/F3C3 class) — can never fire |
| m10-resolved | 4 | F200–F22C, resolved here |
| trailer-unmatchable | 3 | overrun records (`x0=0x810F`) |

**462 of 511 zones now join to a key table and handler; the remaining 49 can never fire** (46 never-sent
pages + 3 trailer records).

## USB relevance

None new, and the mission answers are unchanged. The key resolver, every re-modelled handler, all 234
`@erN` targets and the screen-0x0A editor touch neither the USB module `0xFFEE00`–`0x53` nor SCI-C
`0xFFFF88`, and none enters the closed window `0x078106`–`0x07B753` (Not found; scopes above). The GM/
WIRES-X group modes are UI applications over the existing C4FM path; they expose no new hardware surface.
Q1 (USB is MAIN's `0xFFEE00`), Q2 (no SDR) and Q3 (DSP on SCI-C) stand.

## Open

1. Decode the SUB label-table index that draws the F701/F703 titles, to confirm GM vs. another name for
   modes 8/10 from the glyph the firmware actually shows (the only route left — no ASCII title exists).
2. Name screen-0x0A's exact feature: trace who sets `rec+1=0x0A`/`[0x8EA9].b7` from a concrete menu item
   and whether the `0xFFBA12` list is the GM group registry or a preset table.
3. Decode the mode-1 F10D↔F111 toggle content (altimeter / clock / GPS) fully, and name `[A9F9]`=6.
4. Fold the field-size corrections (0x0296E8 = 15 ch, 0x029712 = 3 ch) and the rec+5 label table into the
   next MAIN seed's typing; type the F200 list table `0x027DE2` and screen-0x0A tables.
