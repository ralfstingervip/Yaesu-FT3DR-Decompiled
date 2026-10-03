# 103 — Home key-table resolver `0x010900`–`0x011036` (MAIN, lane L6)

> Lane L6, model `claude-opus-5-5`. Owner-side static analysis of `decrypted\FT3D_MAIN_ver102_EXP.bin`
> (H8SX, base 0, big-endian, file offset = address) and, for labels only, `FT3D_SUB_ver102_ALL.bin`
> (RX, file offset = address − `0xFFC00000`). Nothing was connected to a radio. No image byte changed
> (sha256 `8e3ecd05…` / `b93570b3…` re-checked after the work). Private DBs `L6_HOME_KEYS`
> (`--copy-from K1_MAIN_FINAL4`) and `L6_HOME_KEYS_SUB` (`--copy-from K7_SUB_FINAL3`); no other DB was
> opened. No published mask or owning doc was edited.

**Tables in `ida\out\home-keytable\`:**

| File | Content |
| --- | --- |
| `keytable.tsv` | 60 home tables `0x01109C`–`0x01208B` + 7 other tables the resolver returns: selecting condition with branch addresses, every `mov.l #tbl,er5` site, all 17 slot handlers |
| `pages.tsv` | page → display state: `B3EA` state rows for the two state-machine render tables, then the home render dispatcher branch → pages; SUB screen, SUB handler, family, SUB strings |
| `zones-resolved.tsv` | all 511 K3 zones, one row each: K3 status, L6 status, key code, primary state, key table, slot handler, primary path and target, then every (page, state) join |
| `work\ida_check.tsv`, `ida_xrefs.tsv`, `ida_items.tsv` | IDA cross-check from `ida\jobs\l6_main_check.py` |
| `work\sub_strings.tsv` | SUB screen-handler string harvest from `ida\jobs\l6_sub_strings.py` |
| `work\open-check.tsv` | the hidden/service/USB re-check descent with parent chains |
| `gen\` | offline generators: `resolver.py` (Python model of the resolver), `walk.py` (state-aware path walker), `zones.py`, `pages.py`, `keytable.py`, `check_open.py`, `trace.py` |

## Verdict

`0x010900`–`0x011036` is the tail of the **main key dispatcher `sub_1079E`** (`0x01079E`–`0x0109B7`, called
from the main loop at `0x002C28`, `0x003816` and `0x00395A`) plus its four table selectors: `sub_10CC4` (home,
by `[8DDE]`/`[A9F9]`/rec+5), `sub_10EB8` (per-screen table), `sub_10EF0` (`[94C1]` key layer) and `sub_10FA8`
(`[94C0]` TX). Touch reaches it only as an ordinary key: the hit-test leaves `0x0A` (button, index in `BBC2`) or
the virtual code in `[FFA9ED]`, and `sub_1079E` dispatches `kt[A9ED]` through the selected table at
`0x01096A` (`6a 0c a9 ed 7a 64 00 00 00 ff 10 74 0a c5 01 00 69 56 7a 04 00 00 00 00 5d 60`). The selector is
decoded completely and modelled byte-for-byte in `gen\resolver.py`.

Of K3's **195 pending zones, 154 are now joined to one key table and one slot handler per display state**;
147 of them reach a concrete target in the primary state, 2 resolve to the no-op `sub_3FFA0`, 1 is a store
only, and 4 end in a flag toggle with no call. **The other 41 can never fire**: 38 sit on pages MAIN never
sends (F801 ×36, F3C3 ×2; the only `f8 01` / `f3 c3` immediates in the image are the ladder compares
`0x026634 79 24 f8 01` and `0x02653C 79 24 f3 c3`), and 3 are K3's unmatchable trailer records. Since the
consumer drops any touch whose page differs from `[FF3D74]` (doc 84), the 8 K3-joined F801 virtual keys are
unreachable too.

Families: **F8 = WIRES-X** (SUB labels "SEARCH & DIRECT", "LOCAL NEWS", "UPLOAD", "ADD TO CATEGORY" in the F8
screen handlers), shown when `[A9F9]==9`. **F6 = a message/news content browser** whose `B3EA` states
`0x13`–`0x3F` are shared by the `[A9F9]`=8/9/10 render tables (SUB "TO:", "NEW", "VOICE PLAY", ".wav").
**F5 = APRS** (`[A9F9]`=4/5). **F7** = the `[A9F9]`=8/10 group screens. **Record `0x028BB4` is the 80-character
text of the F621 "NEW" message**, edited on keyboard page F623 (label Inferred). **Screen `0x0A` is the F112 page**,
a 10-entry list that the image stores as name plus item rows; its label stays Unknown. Mode 10's label also stays
Unknown, and GM is only a candidate.

**Re-check of K2/K3's negative at this edge:** a depth-4 descent from all 237 handler roots joined to the 195
zones finds 0 window targets, 0 USB/SCI-C operands, 0 reset-entry jumps and 0 of the 69 unopened screen ids
(Confirmed scope below). Re-running K3's own descent over the K3-joined roots with one fix — `rts/l`/`rte/l`
terminate — shows the only window/USB contacts come from two **power-on special screens** that restart
MAIN (F00B market commit `jmp 0xDBD8`, F009 `jmp 0x2050`). After restart the window is still gated by the
reset strap. No zone or key opens a hidden or service screen.

## Method

1. **Offline decode** with G1's per-address H8SX oracle (`h8s-decode\work\bu_all.tsv`), bytes from the
   image, K1's `final4` masks. The resolver was hand-transcribed into `resolver.py`; each branch cites its
   address.
2. **IDA cross-check** (`l6_main_check.py`, DB `L6_HOME_KEYS`): 1,227 instructions in 16 ranges (resolver,
   selectors, render dispatchers, jump-table heads, key handlers); 1,221 size/kind match. The 6 mismatches are
   all unreached bytes IDA leaves `unk`: `0x0109B8`, `0x010A2C`, `0x010A2E`, `0x010CC2`, `0x061C54`, `0x0669DA`.
   Xrefs to `sub_1079E` are `0x002C28`/`0x003816`/`0x00395A`. Xrefs to each selector come only from `sub_1079E`,
   plus `0x010DDC` → `sub_10EB8`. The jump tables `0x02ADD0`, `0x02BA86` and `0x0669E0` are data (276 B each).
3. **State-aware walker** (`walk.py`): enumerates paths from a slot handler with the state partly known
   (`IDX`=zone value, `PAGE`, `[B3EA]`, `[A9F9]`, `[94C1]`, `[94C0]`, rec bytes). Known compares are decided
   and the rest fork. Jump tables with a known index are followed and unknown ones fork per entry. The eleven
   `BBC2` helpers resolve to `tbl[IDX−1]` when `1 ≤ IDX < limit`. Record dispatch `0x028CBC` is resolved with
   K3's field rule, and stores are recorded.
4. **Page → state** (`pages.py`): depth-3 call closure from each state handler of render tables `0x061C5A`
   (`[A9F9]`=9) and `0x0669E0` (`[A9F9]`=8/10), and from each branch of the home render dispatcher
   `0x0046B2`, to H5's emitter sites. A state that is also H5's reach-chain slot is marked `H5chain`; this is
   the primary state per page.
5. **SUB labels** (`l6_sub_strings.py`, DB `L6_HOME_KEYS_SUB`): from each screen handler in H5's opcode
   matrix, depth-3 direct calls plus phase pointer tables (`mov.l #tbl; mov.l [ri,rt]; jsr`), collecting
   immediates and data xrefs that land on ASCII.
6. **Open check** (`check_open.py`, `trace.py`): K3's `dclosure` edge rules at D=4, with `rts/l`, `rte/l` and
   `sleep` as terminators (K3 treated only `rts`/`rte` as ends; the image has 301 `rts/l` and 251 `rte/l`).
   Reset entries `0x2050`/`0x2092` are recorded, not followed. Run separately on set P (handlers joined to the
   195) and set J (K3-joined).

**Not covered:** the meaning of the band-record byte rec+5 (values 0–5) and of `[A9F9]`=1/3/8/10 beyond
the evidence below; K3-joined rows on pages L6 did not re-model (156, kept as K3 wrote them); the four
F200–F22C rows; 37 indirect `@erN` sites inside set P's descent.

## Findings

### 1. The resolver (Confirmed bytes; `keytable.tsv`)

`sub_1079E` order, after the `bsr sub_10748` prologue and `[BBF5]==0`, with key = `[A9ED]` ≥ 0:

| Step | Site | Selects |
| --- | --- | --- |
| key filter `sub_10C00` (lock/beep; `r2l=0xFF` discards) | `0x01080E` | – |
| `[BC4E]` = 1 / 2 / other | `0x01083E`–`0x01085C` | `0x011498` / `0x011410` / `0x011454` |
| `[BBF4].b7` | `0x01086E` | `sub_10A78` path |
| `[BBDE]≠0`, rec+1==0, key ∉ {0, 0x0A} | `0x010890` | `0x012590` (touch key 0x0A passes) |
| `[BBF4].b1` | `0x0108A8` | `0x0147D4` |
| `[A9FC]`/`[A9FE]`≠0, key≠0x0E | `0x0108C6` | `0x0112BC` |
| `[94C0]`≠0 → `sub_10FA8` (r3l=`[94C0]`) | `0x010918` | TX tables `0x011960+0x44·(r−1)`; r from table `0x011038` by screen, else 4/9/1 by `AAD1`/`AAD3`/`AAD4` |
| `[94C1]`≠0 → `sub_10EF0` (r3l=`[94C1]`) | `0x01091E` | layer tables (bases `0x011BC4`, `0x011D5C`, `0x011DE4`, `0x011EB0`, `0x011F7C`, `0x011FC0`, `0x012004`, `0x012048`) |
| rec+1==0, or `[A9F9]`==1 & rec+1<0xC → `sub_10CC4` | `0x010920`–`0x010936` | home tables |
| otherwise → `sub_10EB8` | `0x01094E` | `0x0125D4+BE16[0x1208C+2(id−1)]`, or `0x014818` when `[BBF1].b5` and key 0x0A |

`sub_10CC4` with `[8DDE]==0` (normal user):

- rec+0x46.b0 → `0x01180C`.
- `[A9F9]`=1 → `0x01109C`/`0x0110E0`.
- `[A9F9]`=4 → `0x0111F0`.
- `[A9F9]`=5 → `0x011234`/`0x011278` (`[A9FA].b1`).
- `[A9F9]`=8/9/10 → `0x011344`/`0x011388`/`0x0113CC`.
- Otherwise → `0x0115EC + 0x44·rec+5` (`0x010E92 79 06 00 44 f3 00 52 63 0a b5`). rec+5==2 has the
  `sub_3F1F2`/`sub_4906` exceptions `0x011784`/`0x0117C8`/`0x01276C`.

`[8DDE]`>0 (node/PC link) selects `0x0114DC`/`0x011520`/`0x011564`, whose slot 10 is `0x3FFA0`: touch does
nothing in that mode. `[8DDE]`<0 selects `0x011168`/`0x0111AC`/`0x011388`/`0x0115A8`/`0x011850`.

Dispatch (`0x01095E`–`0x010982`): `bset 817E.1`; `sub_109BA` skips the call when `[AD69].b7` and the slot is
`0x3FFA0` (`0x0109DC 7a 26 00 03 ff a0`); then `jsr @er6` with `er4=0`. After the call: `sub_11050`,
`sub_10BC0`, `[A9ED]=0xFF`, and `jsr 0x16648` if `[94C1]`≠0.

**Table facts.**

- Table #9 `0x011300` (all 17 slots `0x3FFA0`) has no `mov.l` site and no base+index route. Not found over the
  whole image.
- TX tables #35/#37 (r=3/5) have no selector that produces their index (Inferred unreachable).
- `sub_109F0` (`0x0109F0`–`0x010A2B`) has 0 jsr/jmp abs24, 0 BE32 and 0 relative-branch references from proven
  code, and is a twin of `sub_109BA`. The same holds for `0x010B44`–`0x010B4D` and the stub `0x010A2C`.
  All are dead and stay unproven.

### 2. Families and states (`pages.tsv`)

**The `[A9F9]` home application mode.** The render dispatcher `0x0046B2`, for rec+1 < 0xC or 0xD8–0xE7, reads it
at `0x0046F8 6a 0c a9 f9 ac 0a 58 70 01 40 ac 09 58 70 01 40`.

| `[A9F9]` | Render | Key table (slot 10) | Pages | Entered by | Name |
| --- | --- | --- | --- | --- | --- |
| 0/2/6/7 | F1 display | `0x0115EC+0x44·rec+5` (`0x028E84`/`0x028DAC`/`0x028FE0`…) | F100/F101/F103/F114/F115 | – | home |
| 1 | `0x009246` | #0/#1 `0x0286CA` | F10D/F10F, F111 if `[BBE0].b2` | key 3 (`0x01CF80`) toggles app ↔ 1 | Inferred info display (SUB F111 handler refs "ALTI m" `0x3485DD`, "Jan" `0x03D399`) |
| 4 / 5 | `0x04AAE8` / `0x04B192` | #5 `0x02870A` / #6–#7 `0x02889A`/`0x0289BC` | F502 / F500, F510, F512–F514 | F-menu idx 0x10/0x0F (`0x01D194`/`0x01D18C`) | **APRS** (Inferred: F512 handler "To:" `0x34856C`, F517 "TEXT" `0x348578`, K3/K5 records) |
| 8 | `0x066966` | #10 `0x02AD6A` | F701/F703 + shared F6 | F-menu idx 0x0B → `0x01F5C8` (needs `[BA32]`≠0, else popup 0xA7) | Unknown |
| 9 | `0x061BE2` | #11 `0x02AD6A` | F8, F6, some F1 | key 6 short press → `0x01CA80 5e 05 fc 0e` (`0x05FD02`: B3EA=1, B2A5=2, A9F9=9) | **WIRES-X** (Confirmed SUB labels, below) |
| 10 | `0x066966` | #12 `0x02BA60` | F701/F703 + shared F6 | key 1 short press → `0x01CE9A 5e 06 3c 04` (`0x063C04`: B2A5=1, A9F9=10) | Unknown (GM candidate, unproven) |

**WIRES-X state machine.** `[B3EA]` is its state. It is dispatched by render table `0x061C5A` at `0x061C30`
(`78 b0 6b 26 00 06 1c 5a`) and by touch table `0x02ADD0` at `0x02AD8E` (`78 b0 6b 26 00 02 ad d0`).
Modes 8/10 use render `0x0669E0` (`0x0669CA`) and touch `0x02BA86` (`0x02BA74`). Those two share every state
`0x13`–`0x3F` handler with mode 9, and add state 7 → F701 and state 8 → F703.

Primary (H5-chain) states:

- **F8 (WIRES-X):** F810=0x0B, F811=0x12, F812=0x13, F813=0x06, F814=0x2B, F815=0x14, F816=0x1B, F820=0x16,
  F821/F822=0x11, F823=0x10, F824=0x07. F800 is closure-only, at 0x02–0x05 and 0x08.
- **F6:** F600=0x32, F610=0x37, F620=0x38, F621/F623=0x20, F622=0x24, F640=0x3F. F630–F632 are closure-only,
  at 0x35/0x36/0x3C/0x3D.

SUB labels, each Confirmed as bytes and as an immediate in the page's SUB screen-handler closure
(`work\sub_strings.tsv`):

| Page | SUB file offset | Label |
| --- | --- | --- |
| F800 | `0x03E88E` | "SEARCH & DIRECT" (`53 45 41 52 43 48 20 26 20 44 49 52 45 43 54`) |
| F810 | `0x03E871` | "LOCAL NEWS" |
| F815 / F816 | `0x03E87C` | "UPLOAD  " |
| F822 | `0x34AD44` | "ADD TO CATEGORY" (insn `FFF103EC`) |
| F620 / F621 | `0x348614` / `0x348618` | "TO:" / "NEW" |
| F640 | `0x34AE5C` / `0x34AE67` | "VOICE PLAY" / ".wav" |
| F630–F632, FD00 | `0x3483D8`–`0x3483E1`, `0x3483D0` | "Adj", "Data", "Mode"; "Waiting" |

The first three are rows of the SUB setup-label table (`0x3DF4D`–`0x3E8D4`).

### 3. Joins for the 195 (`zones-resolved.tsv`; examples, all Confirmed table cells)

| Page / zones | State → key table → slot 10 | Resolution (`IDX`=zone value) |
| --- | --- | --- |
| F106, 24 (`0x027A64`/`0x027ADE`; page chosen by `[8EA1]`) | `[94C1]`=1 → `sub_10EF0` → #42 `0x011BC4` (rec+5≠0; rec+5==0 gives #47, slot 10 = no-op) → `0x02186E` | **F-menu grid**: jump table `0x02188C[IDX]` (25 cells). E.g. 0x0B → `0x01F5C8` (mode 8), 0x0F → `0x01D18C` (APRS 5), 0x10 → `0x01D194` (APRS 4), 0x12/0x18 → `[8EA1]`=1/0 page flip, 0x0D → pop `0x03FF3A` |
| F107, 16 (`0x027B58`, 4×4) | `[94C0]`=1 & `[BBE0].b1` → `sub_10FA8` → #33 `0x011960` → `0x0291D4` | **TX DTMF keypad**: IDX<0xB → `[A9F0]`=IDX−1, `jsr 0x022F06`; IDX≥0xB → `jsr 0x022EF4`(IDX−1) (`0x0291F8`–`0x02920E`); `[89BB]`≠0 → no-op |
| F112, 17 (`0x02702A`…`0x027096`, `0x027CF0`) | screen 0x0A (rec+1=0x0A) → kt `0x012838` → `0x029406` | jump table `0x02941C[B9E4]`. B9E4=0: helper limit 0x13 → `0x0297A0[IDX−1]`; 4/5: records `0x0296E8`/`0x029712` |
| F10D/F10F/F111, 14 | `[A9F9]`=1 → #0/#1 → `0x0286CA` | IDX<6 → `jsr 0x046B64`(IDX−1), 6 → `0x046B90`, 7 → `bnot [BBE0].b2` (F10D↔F111 toggle) |
| F10B, 5 (`0x027CB0`, `0x027CE4`) | screen 0x0B (`[8EBD].b7`) → kt `0x01287C` → `0x029306` | 2/3 → `0x024E7E`+`0x07075A`, 4 → `0x025010`, 5 → no-op |
| F301, 6 (`0x0284AC`) | screen 0x0D, `[BBF1].b5` → kt `0x014818` → `0x0298D8` | the menu item list K3 described (`0x029AEA[[8F2E]]`) |
| F8xx, 33 | `[A9F9]`=9 → #11 `0x011388` → `0x02AD6A` → `0x02ADD0[B3EA]` | state handler, then helper. E.g. F800 (`0x02AEE4`, `0x02AEFA[IDX−1]` → `0x06067C`/`0x06038C`/`0x060354`); F813 IDX 6/7 → `0x0606C0`/`0x02AFDE`; F812 → `0x02B30E[IDX−1]`; F816 → `[B3EB]`=IDX−1, `jsr 0x065D66` |
| F6xx, 28 | same table, states `0x20`–`0x3F` | F621 IDX 3 → `0x02B92C`+`0x06517A`; 4 → open editor (`[AD99]`=0, `[BC34]`=0/3 by `[89C2].b1`, `[BBED]`=2); 5 → `0x065374`. F640 → `0x02C1FC`, helper table `0x02C2BA[BC35]` (e.g. `0x02C2FA`: `0x02C214`/`0x02C224`/`0x02C22E`/`0x02C25E`) |
| F701/F703, 13 | `[A9F9]`=10 → #12 → `0x02BA60` → `0x02BA86[B3EA]` (7 → `0x02BB9A`, 8 → `0x02BC00`) | F701 → `0x02BBDC[IDX−1]`, F703 → `0x02BC3C[IDX−1]` (`0x02BC14`/`0x02BC22`/`0x02BC1A`). Under `[A9F9]`=8 the same zones go through `0x02ADD0`: state 7 → `0x02B012`, state 8 → no-op |
| F004 / F517 / F104–5 | screen 0xB3 kt `0x013D34` / screen 0x9B kt `0x01397C` / home | `0x02A696` stores `[BC34]`=0 / `0x02A99E` stores `[AD68]`/`[BBEE]` / no-op |

**Record `0x028BB4` (label Inferred).** `0x02B502` is the touch handler of `B3EA` states 0x20 and 0x33. Its cells
are `0x02AE50` and `0x02AE9C` = `00 02 b5 02`, plus `0x02BB52` in the 8/10 table.

- On `[FF3D74]`==F623 (`0x02B50E 79 24 f6 23`) it calls passer `0x028BAA` → record `0x028BB4`
  (`0x02B516 5e 02 8b aa`).
- The buffer is `0xFF061A+[AD99]`, width `0x50` = 80 (`0x02B550 7a 05 00 ff 06 1a`, `0x02B55C fc 50`).
- On F621 the same handler opens the editor (IDX 4).
- F621 is SUB screen 0x2A, whose handler closure references "TO:"/"NEW" (`FFEFC52B`/`FFEFC5FF`).

So it is the 80-character text of a new message, in the WIRES-X content states.

**Screen 0x0A (label Unknown).**

- It is pushed when `[8EA9].b7` is set (`0x014BD0`, `0x014BD8 fb 0a`, `0x014BDA 5e 03 ff 10`).
- The render path at rec+1=0x0A emits **F112** (`0x004792` → `0x0090B4`; SUB screen 0x42). K3's F401/F402 attribution was not re-checked.
- `[8EA9]` low bits hold a 1–10 index: `0x024510 ac 0b` clamps it, and `[B9EB]`=index−1.
- The page shows `[B9EA]` item buttons (1–5+). `0x0296E8` edits a 16-character name, `0x029712` a 4-character
  item.
- No SUB label was found.

### 4. Hidden / service / USB re-check (`work\open-check.tsv`)

Set P covers the 237 handler roots of the 195, descended 20,493 instructions. It finds:

- 0 branch targets in `0x078106`–`0x07B753`;
- 0 operands on `0xFFEE00`–`0xFFEE53` or `0xFFFF88`–`0xFFFF8F`;
- 0 jumps to `0x2050`/`0x2092`;
- 44 screen-write sites whose constant ids are `00 09 0A 0B 26 2B 52 6C 72 7F 8C`. None of them is in the 69.

Set J (K3-joined, 224 roots) reaches the window at `0x002234`/`0x05DD12`/`0x05DD9E` and 64 USB operands, but only
through two roots on the power-on special screens. Their SUB closure contains "---CALLSIGN  INPUT---"
`0x34ABE0` and "---DSP WRITE MODE----" `0x34ACF8`.

- **F00B** zone → `0x02A68A[2]` = `0x0236B8`. It stores the market bytes `FF800F`/`FF8010` (doc 96), then
  `jmp 0xDBD8` (`0x0236EE 5a 00 db d8`) re-initialises MAIN.
- **F009** → `0x07358E` → `0x073674 5a 00 20 50` (`jmp` reset entry).

After either restart the window is entered only through the reset strap test `0x002200 2c 4c ec 7f ac 7d 47 16`
(`[FFFF4C]&0x7F==0x7D` → `0x002234 5e 07 81 06`) or the DSP-WRITE/`FF813A` paths of doc 95.

The 2 in-69 hits (`0x04B46E`, `0x04B6B6`, value 0x2A) are K3's `'*'` text-buffer writes, not screen writes.
K3's negative therefore stands, refined: no touch zone opens a hidden or service screen. Two zones on the
held-key/power-on screens restart MAIN, which re-runs the normal strap-gated boot.

### 5. Proven / named byte proposals (do not edit published masks)

| Range | Size | Content | Evidence |
| --- | --- | --- | --- |
| `0x010CC0`–`0x010CC3` | 4 B | byte list `00 03 04` + `ff` terminator, scanned for `[89AB]` | `0x010C76 6a 0b 89 ab`, `0x010C7A 7a 05 00 01 0c c0` → `jsr 0x03F768` (scanner `6c 5c ac ff 47 06 1c bc 47 04 40 f4`) |
| `0x011038`–`0x01104F` | 24 B | 12 × {screen id, TX table index} `72 06 26 07 25 07 42 07 45 07 70 07 dd 08 e1 08 e2 08 e3 08 e4 08 e7 08` | `0x010FF6 7a 06 00 01 10 38`, loop `0x010FFC 6d 63 1c 35 47 22 1a 0d 46 f6` |

- **Named +28 B**: both ranges are 0 in `final4_named_mask.bin` today. They are data, so proven is +0.
- **No demotion**: `0x0109F0`–`0x010A2F` (64 B, 4 named), `0x010B44`–`0x010B4D` and `0x0109B8` are already
  unproven. Their no-reference status is Confirmed over abs24 jsr/jmp, BE32, and relative branches from proven
  code.

## USB relevance

None new:

- The key resolver and every handler it now gives the 195 zones touch neither the USB module nor SCI-C, and
  never enter the closed window (Not found, set P scope above).
- The only touch-adjacent contact with USB/window code is a restart from the held-key market editor (F00B) or
  the callsign/DSP-write power-on screen (F009). That restart re-runs the strap-gated boot of doc 95; it is not
  a new USB surface.
- The three mission answers are unchanged.

## Open

1. Name `[A9F9]`=8 and 10 (and 1/3), and the band-record byte rec+5. One route is the SUB screens 0x2E/0x44
   (F701/F703) glyph tables; another is the owner's manual key legends for key codes 1, 3 and 6.
2. Re-model the 156 K3-joined rows on F0/F2/F3/F5 pages through `resolver.py`. Today they carry K3's
   union-of-handlers join.
3. Apply the `rts/l`/`rte/l` terminator fix to K3's `dclosure` before reusing it. Without it the descent falls
   through into the next function (e.g. `0x0767BC rts/l` → `0x0767BE`, which reads `0xFFEE04`).
4. Fold the +28 B named proposal into the next MAIN seed, and type the 60 home tables in IDA. 2,468 of their
   4,080 B are still `unk` in `K1_MAIN_FINAL4` (`work\ida_items.tsv`), although the named mask already counts
   them.
