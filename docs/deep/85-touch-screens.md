# 85 — Touch zones → actions → named screens (MAIN, consumer side; lane K3)

> Lane K3, model `claude-opus-5-5`. Owner-side static analysis of
> `decrypted\FT3D_MAIN_ver102_EXP.bin` (H8SX, base 0, big-endian, file offset = address). Nothing was
> connected to a radio. No image byte changed (sha256 `8e3ecd05…` / `b93570b3…` re-checked after the
> work). The closed window `0x078106`–`0x07B753` was not entered; every walk below excludes it.
> Private DB `K3_TOUCHSCR` (`--copy-from ida\db\jobs\J1_MAIN_FINAL3\J1_MAIN_FINAL3.i64`), one run of
> `ida\jobs\k3_touch.py`, `idat_exit 0`. Tables: `ida\out\touch-screens\`. The touch producer
> (who fills `0xFFBBD1/D2/D4/C8`) is K2's; this lane starts at the consumer `0x0262E4`.

**Machine tables in `ida\out\touch-screens\`:**

| File | Content |
| --- | --- |
| `zones.tsv` | table, zone, rect, value, kind, event, pages and guard, screens for the page, action, J3 flag |
| `records.tsv` | record → entry handler → key table / dispatch → screen → editor name, buffer and width |
| `screen-opens-by-touch.tsv` | every screen-write site in the touch descent, with value or source, depth, in-69 flag and roots |
| `touch-pages.tsv` | page → ladder target → zone table and guard → MAIN screens → SUB screen |
| `work\` | IDA cross-check (`ida_disasm.txt`, `ida_xrefs.tsv`, `ida_check.tsv`, `ida_req.txt`) |
| `gen\` | the offline generators (plain read-only Python) |

## Verdict

**J3's "nine zone tables" are a sample. The touch consumer selects from 99 distinct zone tables
(511 zones), at 125 hit-test call sites, keyed on the page code the SUB is displaying.** IDA also
reports 125 xrefs to `sub_26F08`. Every touch becomes either:

- a **button event**: key code `0x0A` in `0xFFA9ED`, with the zone index in `0xFFBBC2`; or
- a **virtual key**: zone value `0xF0xx` or `0xFFxx`, which puts `xx` in `0xFFA9ED`. Digits `0`–`9`
  from the four keypad tables are turned into key `0x00` with the digit in `0xFFA9F0`.

The current screen's ordinary 17-slot key table then dispatches the event; **slot 10 is the touch
slot**. 78 of the 84 `0xFFBBC2` load sites are reached within two calls of a slot-10 handler. All 61
BE32 references from key-table space to the functions that contain those loads land on slot 10.
The other six load sites are:

- `0x021A2A`, called by the key resolver itself at `0x010F82`;
- `0x02865E`, the one unproven index helper (limit `0xB`), which has no caller;
- `0x02A0AE`, `0x02A0C6` and `0x02A0DE`, reached through table `0x02A1EC`;
- `0x02A600`, reached by `jsr` from `0x003190`.

Those last two paths were not followed.

**J3's eight records are on-screen-keyboard text editors.** Where they are drawn:

- Five use the SUB's shared keyboard screen `0x20`, through pages F514, F515 and F623. Pages
  F3B3/F3B8/F513 also open that screen.
- `0x028B6C` uses page F280, which is SUB screen `0x08`.
- The two records of screen `0x0A` use F401/F402, which are SUB screens `0x45`/`0x46`.

The eight records name these editors:

| Record | Editor | Status |
| --- | --- | --- |
| `0x028C8A` | BEACON STATUS TEXT (`0x9B`, 60 chars) | Confirmed |
| `0x028C2A` | APRS MSG TEXT (`0x94`) | Inferred |
| `0x028C62` | APRS MSG GROUP (`0xA2`) | Inferred |
| `0x028B6C` | WIRES-X EDIT CATEGORY TAG (`0xBE`, 16 chars) | Inferred |
| `0x028BF0` | 67-character home-mode text editor | Inferred as APRS message compose |
| `0x028BB4` | 80-character editor in the F6 family | Unknown label |
| `0x0296E8` / `0x029712` | 16-character and 4-character fields of screen `0x0A` | Field sizes Confirmed, labels Unknown |

The three Inferred labels use G3's row→label rule. Their neighbouring rows are Confirmed.

**No touch path opens any of the 69 unopened screen ids** (Not found). Scope:

- A depth-4 descent from 115 touch roots (83,361 instructions) reaches 115 screen-write sites. The
  roots are every slot-10 handler, the page-mapped virtual-key slots, and all record fields.
- The constant ids reached are `00 09 0A 0B 0D 26 2B 52 6C 72 7F 8C DC E8 E9 EA EB EC`. None is
  in the 69.
- Every computed id falls in H13's known sources: row tables, table `0x3BC6`, restores and clears,
  push and direct-entry bodies, and `[FFADA1]`.
- The touch-derived indices are bounded and cannot reach hidden ids. The group list allows groups
  1–12 only, so hidden group 13 is unreachable. Item rows are clamped by `sub_2C030` to each
  group's count. Group 13's item touch is a no-op (`0x029AE2`).

## Method

1. **Offline decode.** Instruction text comes from G1's per-address binutils H8SX oracle
   (`ida\out\h8s-decode\work\bu_all.tsv`). Byte reads come straight from the `.bin`. Reachability
   uses J1's `final3_proven_mask.bin` (one byte per address).
2. **Consumer walk.** I parsed the page ladder `0x02639C`–`0x02669C` (`cmp.w #Fxxx,r4 ; beq`). It
   has 94 page codes, counting F200–F22C as one range, and they lead to 75 distinct targets. From
   each target I enumerated paths, following local calls into `0x0262E4`–`0x027030`. Each
   path records the zone table loaded into `er5` before `jsr sub_26F08`, plus the guard: RAM tests,
   and HIT/MISS of a previous table. The hit-test sets Z on a miss (`0x026F3C`), so `bne` after the
   call means a hit.
3. **Tables.** Each table is read as `count` + `count × {Xmin,Ymin,Xmax,Ymax,val}` (BE16).
4. **Key tables.** The key tables were found from the dispatch at `0x029AA0`, which is
   `0x125D4 + BE16[0x1208C+2(id-1)]` plus `4·[A9ED]`. There are 131 tables at `0x0125D4`–`0x01489F`
   and 60 home/main tables at `0x01109C`–`0x01208B`. Both sets use a stride of `0x44` = 17 slots.
5. **Handler paths.** From each of the 73 distinct slot-10 handlers I enumerated paths. Variables are
   normalised: the page is `[FF3D74]` or `BBD1:BBD2`, and the index is `[FFBBC2]`. The resolver
   expands three things:
   - the eleven `0xFFBBC2` index-dispatch helpers `0x02853E`–`0x0286A6` (limit 3…0x17, `er6` = table);
   - the eight record passers;
   - jump tables reached through `mov.l @(T:32,ern),er6`.
6. **Zone joins.** A zone is joined to an action in two ways:
   - by an explicit page test in the handler path; or
   - by the page→screen map. That map combines the `0x782C` notifier chains in
     `ipc-reach\main-sites.tsv` with H13's `notify_opcodes`.

   Virtual keys resolve to `kt[slot = key]` of the mapped screens.
7. **Screen opens.** I ran a depth-bounded descent (D = 1…4) from the touch roots, then scanned it for
   screen-byte stores `@(1,ERn)` and for calls to `3FF10/3FF02/3FEFC/3FF1E/148A0/14C72/3FF3A/14AF4/14B7E/14C90`.
   Each store through a non-`er0` register was classified by its base load (`@0x812A`,
   `#FF8EE0/8FE8/90F0/9190/922C`, or `mov.l er0`). Values come from the preceding `mov.b #imm`, or
   were classified by hand (`screen-opens-by-touch.tsv` `value_src`).
8. **IDA cross-check** (`k3_touch.py`). IDA decodes all 24 checked instruction sites identically
   (`work\ida_check.tsv`). The xref counts match: `sub_26F08` 125, `sub_26F48` 3, `sub_26F9C` 1,
   `0x0262E4` 1 (from `0x00FBA8`). The record passers are reached from exactly the handlers below
   (`work\ida_xrefs.tsv`).

**Not done or not covered:**

- No descent or ledger run, so I make no proven-byte claim.
- The home key-table resolver `0x010900`–`0x011036` is only partly decoded. Its key table is chosen by
  `[94C0]`, `[94C1]`, `[A9F9]`, `[8DDE]`, `rec+5` and `[B3EA]`. As a result **195 of 511 zones are
  not joined to one handler**: pages F1xx, F6xx, F7xx, F8xx, F112, F301 and FD00. Their event
  (key code and index) is still decoded.
- 78 indirect `jsr/jmp @er6` sites in the descent were not resolved.
- Physical-key identities of the virtual codes are not decoded.
- The writer of `[FFADA1]` is still unknown (H13 Open 1).

## Findings

### 1. The consumer (`0x0262E4`, called only from the key poll at `0x00FBA8`)

The consumer runs after the physical-key scanners leave `A9ED` negative (`0x00FB8E`–`0x00FBA6`). It
proceeds as follows:

- `[FFBBC8]` is the new-touch flag. When it is set, the consumer clears it (`0x02633A`).
- It requires `[FFBBD3]` to be non-zero.
- It compares the SUB-reported page `BBD1:BBD2` with `[FF3D74]`, the last page MAIN sent
  (`0x026366`–`0x026388`). A mismatch drops the touch and sets `AAE0=0x1D`, `BBE5=1` and `817E.1`.
- It loads `er2 = [FFBBD4]` (`X<<16|Y`) and enters the ladder.
- With `[94C0]==1`, only F100/F101/F103/F107/FD00 pass (`sub_28FB8`).

**Hit-test `sub_26F08`** (bytes `6d 56 01 00 69 54 1d ca …`):

- First match wins, with inclusive bounds.
- `val ≥ 0`: `BBC2=val`, `A9ED=0x0A`, `A9EE.7=0`, `954B=0`, `BBC7=2` (`0x026F48`–`0x026F64`).
- `val < 0`: `BBC2=0`, `A9ED=BBC6=val&0xFF`. If bit 8 of `val` is set, `954B=0x32` and `BBC7=1`
  (`0x026F66`–`0x026F96`). That arms the hold path at `0x026322`, which later re-posts the code with
  `A9EE.7` (the long-press flag).
- `sub_26F9C` is used once, at `0x028F74` (page F100, `[94C1]==0`). It stores a held button index
  in `BBC4`, sets `A9EE.6` and arms the same timer. `0x02630A` then re-posts `BBC4` through
  `sub_26F48`. **This corrects J3**: `BBC4` is the pending hold/repeat button, not a "secondary
  coordinate".
- **Digit post-processing.** At four call sites (`0x026712`, `0x026794`, `0x026932`, `0x026E1E`),
  when `BBC2==0` and `A9ED<0x0A`, the code sets `A9F0=A9ED` and `A9ED=0`. The tables are `0x0270CA`,
  `0x027334`, `0x027648` and `0x0279EA`. At `0x02694C`, table `0x0279EA` also maps codes `≥0x0A` to
  `code−9`.

### 2. Zones (`zones.tsv`, `touch-pages.tsv`)

**Overall counts:**

- 99 tables / 511 zones, all inside `0x02702A`–`0x02853D` (5,296 B).
- That range also holds 100 B of three zone-shaped blocks with no reference (Not found by imm32,
  BE32 or `mov.l` scan): `0x028248`, `0x0282D6` and `0x028486`.
- Zone kinds: 462 button and 49 virtual-key.
- Virtual codes:
  - `F000`–`F009`: digits on 4 keypad tables;
  - `F010`: key `07` after the remap;
  - `F001`/`F004`/`F007`/`F009` used raw on `0x02843C`/`0x02782E`/`0x027886`: keys 1/4/7/9;
  - `FF02`: key `02` with hold, on F100/F10B/F112 tables.

**Trailer zones.** Three tables have a count that runs one record past the data, into the
`81 0F 9E 29 00 09` trailer and the next table's header: `0x027648`, `0x0276D2` and `0x027784`.
The extra zone has `Xmin = 0x810F`, so it can never match (Confirmed).

**J3's nine tables, with pages and actions:**

| Table | Zones (x0,y0–x1,y1 → value) | Pages / guard | Action |
| --- | --- | --- | --- |
| `0x028452` | 5 full-width rows: Y `31–59`, `61–89`, `91–119`, `121–149`, `151–179` → 1–5 | F610 (`[B3EA]≠0x3D`), F810/F821/F824, F813, F820 (`[B3EA]≠0x19`), F823. Tried first | list-row buttons on F6/F8 pages. Handler not joined (home tables, by `[B3EA]`) |
| `0x02839A` | `1,185–104,238` → 6; `108,185–211,238` → 7 | F813 and F823, after a MISS on `0x028452` | bottom soft-keys. Not joined |
| `0x02843C` | `1,185–104,238` → `F004`; `215,185–318,238` → `F001` | FD00 | virtual keys 4 / 1 → slots 4 / 1 of the active key table |
| `0x02704C` | three buttons at Y `128–180` → 7, 8, 9 | F112, `[B9EA]==3`, after a MISS on `0x027CF0` (`sub_26FD8`) | not joined |
| `0x02706C` | four buttons at Y `128–180` → 10–13 | F112, `[B9EA]==4` | not joined |
| `0x027096` | five buttons at Y `128–180` → 14–18 | F112, `[B9EA]≥5`. Siblings `0x02702A` (1 zone) and `0x027036` (2 zones) for `[B9EA]`=1/2 | not joined |
| `0x0270CA` | 3×4 keypad: `F002`–`F009` → digits; `3` (top right), `2`, `4`, `5` | F003; F3B3/F3B8/F513 with `[BC35]≠2 & [BC34]==0`; F515 on screen `0xA2` with `[BC34]==0` | digits → slot 0 (e.g. scr `B3` → `0x05E0E8`, `A3` → `0x017E8A`, `9D` → `0x018808`). 3/4/5/2 → record fields `+0C`/`+08`/`+08`/cursor-mode, or `0x2A696`/`0x2A738`/`0x2A804` |
| `0x0271E6` | 14 keys: 11–19, 10 (character grid), 1, 3, 4, 5 | F3B3/F3B8/F513 with `[BC35]≠2 & [BC34]≠0`; F515 on `0xA2` with `[BC34]≠0` | character k → record `+00`, char index k−10 → `A9F0` (e.g. `rec28C62+00` → `0x018A5C`). 1 → cursor mode 0. 3/4/5 → `+0C`/`+08` |
| `0x027274` | 19 keys: 30–45, 3, 4, 5 | F3B3/F3B8/F513 with `[BC35]==2` | extended set: scr `A3` → `0x017D36`, scr `9D` → `0x0187DC`, F513 → `sub_28AD2` |

The full keyboards used by the records are `0x027334`, `0x0273F4`, `0x0274BE` and `0x02757E`
(19–20 keys). They are selected by `[FFBC34]` = 0 / 1 / ≠1 / 3 (`0x026744`–`0x0267AC`).

### 3. Records → editors (`records.tsv`)

Key table for screen id `id` = `0x125D4 + BE16[0x1208C+2(id−1)]`; slot 10 = `+0x28`.

| Record | Entered from | Reached by (Confirmed bytes) | Screen | Editor | Buffer / width |
| --- | --- | --- | --- | --- | --- |
| `0x028B6C` | `sub_29C38` (`5e 02 8b 62`) | `0x013EF4` = `00029c38`, slot 10 of kt `0x013ECC` | `0xBE` | **EDIT CATEGORY TAG** (WIRES-X), Inferred | `0xFFAE22+16·[B3F4]`, 16 |
| `0x028BB4` | `sub_2B502` (`0x02B516`, `[PAGE]==F623`) | `[B3EA]`-indexed `0x02AE50`/`0x02AE9C` (via `sub_2AD6A`) and `0x02BB52` (via `sub_2BA60`). Those are slot 10 of home kt `0x011344`/`0x011388`/`0x0113CC` | home/main | 80-char F6-family text editor; label Unknown (WIRES-X Inferred, weak) | `0xFF061A`, 80 |
| `0x028BF0` | `sub_289BC` (`0x0289F8`, F514) | `0x0112A0` = `000289bc`, home kt `0x011278`; selected at `0x010E00` (`7a 05 00 01 12 78`) when `[A9F9]==5 & [A9FA].b1` | home/main | 67-char compose, **APRS message** (Inferred: 67 = APRS text maximum) | `0xFFA574`, 67 |
| `0x028C2A` | `sub_2A8C6` (`0x02A90E`, F515 & `[BBEE]==2`) | `0x01391C`, kt `0x0138F4` | `0x94` | **APRS MSG TEXT**, Inferred | `sub_18894()`, 16 |
| `0x028C62` | `sub_2A95A` (`0x02A992`, F515 & `[AD68]≥2`) | `0x013784`, kt `0x01375C` | `0xA2` | **APRS MSG GROUP**, Inferred | – |
| `0x028C8A` | `sub_2A99E` (`0x02A9DE`, F514 & `[BBEE]==2`) | `0x0139A4`, kt `0x01397C` | `0x9B` | **BEACON STATUS TEXT**, Confirmed (F3AE) | `0xFFADA2`, 60 |
| `0x0296E8` | `sub_29406` (`[B9E4]`=4) | `0x012860` = `00029406`, kt `0x012838` | `0x0A` | 16-char name, copied `0xFFB9F2`→`0xFFBA02` at `0x02954A`; label Unknown | `0xFFBA02`, 16 |
| `0x029712` | `sub_29406` (`[B9E4]`=5) | same | `0x0A` | 4-char item of the list `0xFFBA12+6·[B9EC]` (`0x0295E6`); label Unknown | `0xFFBA02`, 4 |

**Label evidence.** All three labels come from row tables and SUB label bytes.

- **`0xBE` / EDIT CATEGORY TAG.** Group-7 row table `0x0151A2` is `bc bd be bf b4`. G3's rule
  (label = group base + 20·row, which agreed on 99 pairs) gives SUB `0x3E295` = `45 44 49 54 20 43
  41 54 45 47 4f 52 59 20 54 41 47` "EDIT CATEGORY TAG". Rows 0, 1 and 4 (`0xBC` F371, `0xBD` F372,
  `0xB4` F376) are Confirmed by their F-codes.
- **`0xA2` / APRS MSG GROUP and `0x94` / APRS MSG TEXT.** These are rows 5 and 6 of `0x0151BE`. They
  map to `0x3E4ED` "APRS MSG GROUP" and `0x3E501` "APRS MSG TEXT". Rows 4 (`0x93` F3A4) and 7
  (`0x95` F3A7) are Confirmed.
- **Screen `0x0A`.** It is pushed at `0x014BDA` (`FF8EA9.7`) and at `0x024554`. Its pages are
  F401/F402, which are SUB screens `0x45`/`0x46`. Its purpose is Unknown.

### 4. Touch-specific screen changes (`screen-opens-by-touch.tsv`)

| Site | What touch does | Bound |
| --- | --- | --- |
| `0x0298C8` | Screen `0x0C` (F300, table `0x027E0C`, 12 zones, values 1–12): `[FF8F2E]=idx−1`, then `jsr sub_14AF4` | Values 0–11 only. The group-13 gate at `0x014B04` (`FF8F2E==0x0C`) is never reached by touch |
| `0x029900`–`0x029A8C` | Item list (kt `0x014818`, used when `BBF1.b5` and key `0x0A`, `sub_10EB8`): idx 5–10 → `sub_2C030(count, cursor)` → row table → `mov.b r3l,@(1,er0)` | `0x02C074` `cmp.b r4l,r3l ; bcc fail` keeps cursor < count. The touch counts match the row tables: MEMORY 6, SIGNALING 14, SCAN 6, GM 2, WIRES-X 5, CONFIG 22, APRS 28, SD CARD 4, OPTION 5 (4 unless `FF89C4.b4`), and the TX/RX sub-lists 3/4/5. Sub-list 2b is limited to its first 4 of 21 rows. DISPLAY is the exception (below). Group 12 → `0x029ADE` and group 13 → `0x029AE2` are no-ops (`jsr 3FFA0`). |
| `0x029A74` | Sub-group list (screen `0x0D`): `[FF8F4F]=idx−5` for idx 5–7, then `sub_14B7E` | 0–2 |
| `0x06FD66` | screen := `[FFADA1]` | This handler fills all 17 slots of screen `0x86`'s key table `0x01353C`. `0x86` is itself one of the 69, so this path is not reachable |

**One off-by-one (Confirmed bytes, harmless).** DISPLAY's touch count is `fb 0a` (`0x0299C4`) = 10,
but its row table `0x01515C` has 9 rows plus a pad `00`. A cursor of 9 would read `0x00` (home),
which is not one of the 69. The scroll window tops out at item 8, so that cursor is not expected to
be reachable (Inferred).

`0x014EEC` tests for row code `0x69`, which is one of the 69, but `0x01515C` does not contain it,
so the test is dead.

The 31 stores through `er1`/`er2`/`er6` and some through `er5` are string or struct writes, not
screen writes. For example, `0x04B46E` `f4 2a … 6e e4 00 01` writes `'*'` into a text buffer. This
classification is a heuristic based on the base load. H13's whole-image writer census covers these
stores independently.

### 5. Corrections to J3 (doc 71)

- "Nine zone tables" → **99** (125 call sites). J3 did not list 90 of them, including the four full
  keyboards `0x027334`/`0x0273F4`/`0x0274BE`/`0x02757E` that the records actually use.
- The values `61441`/`61444` in `0x02843C` and the `0xF00x` values in `0x0270CA` are **virtual-key
  codes**, not button indices. They leave `BBC2=0` and post key `xx` (or a digit).
- `sub_26F9C`/`BBC4` is the hold/repeat button, not a "secondary coordinate".
- The record screens are now named (§3). `0x028BB4` is reached through `[B3EA]` dispatch tables in
  the home key tables, not through a GUI table in `0x011xxx`–`0x013xxx`.

## USB relevance

None. Scope: the consumer, the hit-test, the 99 tables, the 73 slot-10 handlers and the eight
records' fields.

- They touch neither the USB module `0xFFEE00`–`0x53` nor SCI-C `0xFFFF88`, and none enters the
  closed window. The depth-4 descent excluded the window by construction.
- The touch layer only edits text and settings fields and navigates the menu tree.
- It cannot select hidden group 13, and no touch path reaches any of the 69 unopened screens.
- No touch zone was found that opens a service, USB or DSP screen. The three mission answers are
  unchanged.

## Open

1. **Decode the home key-table resolver `0x010900`–`0x011036`.** It maps `[94C0]`, `[94C1]`,
   `[A9F9]`, `[8DDE]`, `rec+5` and `[B3EA]` to the 60 tables at `0x01109C`. That would join the
   remaining 195 zones (F1xx, F6xx, F7xx, F8xx, F112, F301, FD00) to single handlers. It would also
   name the F5, F6 and F8 page families, including record `0x028BB4` and screen `0x0A`.
2. **Find the writer of `[FFADA1]`** (H13 Open 1). It is the only screen-id source still Unknown. The
   one touch path that uses it sits on unopened screen `0x86`.
3. **Resolve the 78 indirect `@er6` sites** in the descent, to turn the screen-open answer from a
   bounded walk into a complete one.
4. **Type the 99 tables (5,296 B) as zone structs** in a final seed. They are already inside the
   named mask, so there is no ledger change. Also mark the three unreferenced blocks
   `0x028248`/`0x0282D6`/`0x028486` (100 B) and the three trailer overruns.
