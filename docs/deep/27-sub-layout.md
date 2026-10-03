# SUB screen-layout tables and the font index

Lane 10. DB `SUB_LAYOUT`, seeded `--copy-from ida\db\jobs\SUB_UPPER\SUB_UPPER.i64`.
Closes the two data holes doc 16 left open (§5 "layout tables", Open #3 and #4).
Tables and disassembly under `ida/out/sub-layout/`; job
scripts `ida\jobs\full_l10_*.py`. Workspace root is physically
the repository root.

## Verdict

**Both holes are closed, and the "font index" turned out to be two separate
systems, not one.**

1. **The span `0xFFEB74D8`–`0xFFECE55C` is the text/character subsystem's data**, not
   generic screen layout. It holds six record kinds: a numeric place-value table, the
   per-font-block **code→glyph-ordinal translation arrays**, the user-selectable
   **character repertoire** (kanji / katakana / symbols / fullwidth / PUA), 6-byte
   glyph-metric and field-coordinate records, and a small callback/register-init
   table. Of 94,340 span bytes, **41,263 are content and all 41,263 are typed**; the
   other 53,077 are `0x00`/`0xFF` padding to a `0x200`-byte page grid.

2. **There are two fonts.** (a) A **1-bpp packed monochrome text font** driven by an
   8-entry master table at **`0xFFED4644`** (just past the RGB565 descriptor table).
   Each entry is `{u8 w, u8 h, u16 base_code, u32 ordinal_table_ptr, u32 pixel_base}`;
   its `ordinal_table_ptr` fields point **into this lane's span** — so the span's
   index arrays are literally the code→glyph translation for this font. The resolver
   is `sub_FFEF2184`; glyph pixel = `pixel_base + ordinal * height * ceil(w/8)`.
   (b) The **RGB565 sprite font** doc 16 described, reached as
   `descriptor_base + code*16` into the atlas descriptor table — I located 21 such
   base-load sites in 8 functions (9 distinct bases; primary `0xFFECFDCC`).

I rendered ASCII glyphs from the 1-bpp font end-to-end (`glyph_render.txt`): `A B C
W 0 1 2 3` all come out as recognizable letters/digits, proving code → ordinal →
bitmap.

## Method

what ran: five IDAPython jobs on `SUB_LAYOUT` (reopened) through the shared
launcher — `full_l10_layout.py` (segment + classify the span, immediate-load reader
scan over all 3806 functions, font `base+code*16` scan), `full_l10_disasm.py`,
`full_l10_font.py`, `full_l10_glyph.py`, `full_l10_blocks.py`, plus one linear-disasm
job — and plain-Python structural analysis / glyph rendering over
`decrypted\FT3D_SUB_ver102_ALL.bin` (coverage-independent). No radio, no device, no
image was written. `SUB_UPPER.i64` was only copied from.

scope: span classification and the byte-exact structural claims cover all 94,340
bytes of `0xFFEB74D8`–`0xFFECE55C`. The reader scan is every `o_imm` in all 3806
recovered functions / 153,500 instructions. The font-index scan is the same coverage.

what did not run: the DSP boot personality `26AA:0020` was not followed; no band /
MARS / expanded-RX search; settled negatives in RESUME-DEEP were not re-proved. The
1-bpp pixel store's exact extent in low flash is left as an inferred range (its base
pointers are confirmed; I did not walk every glyph).

## Findings

Little-endian; file offset = address − `0xFFC00000`.

### 1. Span map — `segments.tsv`

193 content segments totalling 41,263 bytes on a `0x200` page grid. By class:
`IDX_ASC` 14,562 B (88 segs), `CHARSET_CJK` 13,732 B (40), `CHARSET_PUA` 3,780 B
(10), `CHARSET_SYM` 272 B (5), `RECORDS` 8,917 B (50). These map onto the six record
kinds below (`records.tsv` has one row per kind, with bytes and reader functions).

### 2. The 1-bpp font master table — `0xFFED4644` (`font_blocks.txt`)

**Confirmed.** 8 records × 12 bytes. Shape
`{u8 width, u8 height, u16 base_code, u32 ordinal_table_ptr, u32 pixel_base}`:

| rec | @ | w | h | base_code | ordinal_tbl (+4) | pixel_base (+8) |
| --- | --- | --- | --- | --- | --- | --- |
| 0 | FFED4644 | 14 | 14 | 9321 | FFEB7556 | FFC0015D |
| 1 | FFED4650 | 14 | 14 | 5021 | FFEB7D6E | FFC02BCD |
| 2 | FFED465C | 14 | 14 | 2121 | FFEBC57A | FFC19E95 |
| 3 | FFED4668 | 7 | 14 | 0020 | FFEC21E0 | FFC31C31 |
| 4 | FFED4674 | 14 | 14 | 2D21 | FFEC2360 | FFC324D5 |
| 5 | FFED4680 | 14 | 14 | 2124 | FFEC2418 | FFC32DE9 |
| 6 | FFED468C | 14 | 14 | 7921 | FFEC3C70 | FFC333ED |
| 7 | FFED4698 | 14 | 14 | 2122 | FFEC432C | FFC35CD5 |

Every `ordinal_table_ptr` lands inside this lane's span (`0xFFEB7556`–`0xFFEC432C`),
which is what makes the span the font's index. The `base_code` values are JIS-style
(`0x2121`, `0x5021`, `0x9321`, and `0x0020` for the ASCII/symbol block); the search
in `sub_FFEF2184` picks the highest block whose `base_code ≤ code`. Block 3 is the
7×14 ASCII/symbol font.

### 3. The glyph resolver — `sub_FFEF2184` (`glyph_lookup.txt`)

**Confirmed.** Input `r1`=block/size selector, `r2`=char code, `r3`=&out. Rejects
control codes (selector ≥ `0x1A`, code 0). Finds the block (loop at `FFEF21BA`,
`mul #0Ch` stride into `0xFFED4644`). Then:

```
FFEF2216  movu.w var_4,r1        ; code
FFEF2218  sub    2[r2].uw,r1     ; r1 = code - base_code
FFEF221C  mov.l  4[r2],r2        ; r2 = ordinal_table_ptr (into this span)
FFEF221E  mov.w  [r1,r2],r1      ; r1 = ordinal_table[code-base]  (glyph ordinal)
...
FFEF2231  movu.w 2[r1],r2        ; height
FFEF2233  mul    var_A,r2        ; height * ordinal
FFEF2237  movu.w [r1],r15 ; +7 ; div #8   ; ceil(width/8) = bytes/row  -> 1bpp
FFEF223F  mul    r15,r2
FFEF2241  add    8[r14].l,r2     ; += pixel_base
FFEF2245  mov.l  r2,4[r1]        ; out.src = pixel_base + ordinal*height*ceil(w/8)
```

`div #8` proves 1 bit per pixel. Width comes from `sub_FFEE5269` (returns block
`width`, with a special width-5 set `"MWXYmwx*@\\"`). Code `0xFF80` halves the width
(`shlr #1`, half-width variant).

### 4. The text engine above it

- `sub_FFEFA7E7` — **string renderer** (`renderers.txt`, loop `FFEFA82D`). Walks up to
  16 chars; a caller-supplied 16-bit mask marks which are double-byte; dispatches each
  to `sub_FFEF190D` (double-byte/kanji code, `bsr` at `FFEFA8A8`) or `sub_FFEF1B23`
  (single-byte/ASCII, `bsr` at `FFEFA8FD`). Advances x by 7/14 (ASCII) or 14/28
  (kanji). Callers pass ASCII literals: `#aManual "MANUAL"`, `#aOn "ON"`, `#a4800`.
- `sub_FFEF190D` — double-byte glyph blit → `sub_FFEF2184` then pixel copy to the
  320-stride (`0x140`) framebuffer at `[[0x1D3C8]+0xC]` (same surface as doc 16).
- `sub_FFEF1B23` — single-byte/ASCII glyph blit.

### 5. Glyph render proof — `glyph_render.txt`

ASCII block (rec 3: `base 0x20`, `w 7`, `h 14`, ordinal table `0xFFEC21E0`, pixel base
`0xFFC31C31`). `'A'`=0x41 → ordinal `0x21` → `0xFFC31DFF`:

```
...##..     ..####.  ('0', ordinal 0x10)
...##..     .#....#
..#..#.     .#....#
..#..#.     .#....#
..#..#.     .#....#
..#..#.     .#....#
.#....#     .#....#
.######     .#....#
.#....#     .#....#
.#....#     .#....#
.#....#     ..####.
```

`A B C W 0 1 2 3` all render correctly — the code→ordinal→bitmap chain is confirmed.

### 6. The RGB565 `base + code*16` font path — `font_index.txt`, `font_descriptors.txt`

**Confirmed.** 21 sites in 8 functions load a bitmap-descriptor-range immediate and
scale an index by 16 (`shll #4`) before `sub_FFEF0648`. 9 distinct bases; the primary
is **`0xFFECFDCC`** (descriptor rec 391, a run of 20×30 RGB565 glyphs, white/grey
mode pairs — the large frequency-display font), used by FFF02DE3, FFF03AD8, FFF067A9,
FFF07C24. Other bases head smaller runs: rec 963/964 (14×28, FFEE2CCE), rec 991–995
(22×22 icons, FFEE7300/FFF42EB5), rec 1009/1011 (11×5, FFF4288E). Example:

```
FFF0680F  shll  #4, r1            ; code*16
FFF06965  mov.l #unk_FFECFDCC, r3 ; base (rec 391)
FFF0696B  bsr.a sub_FFEF0648      ; RGB565 blit (doc 16)
```

### 7. Other span record kinds (`records.tsv`, `readers.tsv`, `reader_funcs.txt`)

- **NUM_SCALE** `0xFFEB74D8` (314 B): u16 place-value columns (digit×{1,10,100,1000},
  digit×{16,256}, 10..90, 100..900, 1000..9000) for decimal number drawing. Readers
  FFEDF777, FFEE1AA2, FFEE1B52, FFEE1BC0, FFEE1C1F, FFEE20F8.
- **CHARSET_REPERTOIRE** `0xFFEC6D0E`–`0xFFECE082` (~17.8 KB): the user-selectable
  character set — CJK ideographs (`FFEC7AF0`…), fullwidth forms (`FFEC6D0E`: FF10 FF11
  = `０１`), box-drawing (`FFEC71AE`: 2500 2502 250C), circled numbers (`FFEC76F0`:
  2460…), math symbols (`FFEC6BE0`: 2208 220B), and PUA sequential maps (`FFECC86A`:
  E000 E001…). Readers FFF2DC2B, FFF2DDD4, FFF33499, FFF3850B.
- **GLYPH_METRIC_6B** `0xFFEC5A12` (2169 B): 6-byte `{u16,u16,u16}` metric records
  (`08 00 31 00 01 00` …). 153 loads across 50 functions read this region (headed by
  FFEE2438) — the widest reader set in the span.
- **FIELD_COORD** `0xFFEC5940` / `0xFFEC6220`: 6-byte `{index, x, y}` placement records
  (x ascending 0x30,0x46,0x5C,0x7D…). Readers FFEE6168, FFEE6176, FFEE6238, FFEE6246,
  FFEE6274, FFEE6282, FFEE73F3.
- **CALLBACK_REGINIT** `0xFFECE4E4`–`0xFFECE51C` (54 B): code pointers
  (`FFEFB267`, `FFEDE10F`, `FFEDE161`, `FFEDE1A2`) plus peripheral/register constants
  (`0x00088000/8804/8904/8944/8A44`, `0x00400001`). Readers FFEDAB4C, FFEDDF3A.

## Extension

what a later owner feature would attach to: the **character repertoire tables**
(`0xFFEC6D0E`–`0xFFECE082`) and the **1-bpp font-block master** (`0xFFED4644`) are the
attach points for any text/label change — adding a glyph means an ordinal-table entry
(this span) plus 1-bpp pixel data at the block's `pixel_base`; adding a selectable
character means an entry in the repertoire lists. The RGB565 `base+code*16` path
(`0xFFECFDCC`) is where large-display digits/labels attach. No band-coverage, TX, or
unlock surface touches this lane.

## Counts

- **T_run** = 7 record kinds identified in/for the span (6 inside the span + the
  `0xFFED4644` master just past it) **+ 21 RGB565 `base+code*16` font base-load sites**
  **+ 5 1-bpp font-block-table base-load sites** = **33**.
  (Span-only view: 6 record kinds + 21 font base sites = 27.)
- **D_run** = **33** — every kind and every base-load site is typed with shape + field
  meaning + evidence (`records.tsv`).
- **bytes of `0xFFEB74D8`–`0xFFECE55C` accounted for by typed records**: **41,263 of
  94,340** (100% of non-padding content; remaining 53,077 B are `0x00`/`0xFF` page
  padding).
- **font base-load sites**: RGB565 path 21 (funcs FFF02DE3, FFF03AD8, FFF067A9,
  FFF07C24, FFEE2CCE, FFEE7300, FFF4288E, FFF42EB5; 9 distinct bases, primary
  FFECFDCC); 1-bpp master path 5 (FFEF2184 ×4, FFEE5269 ×1, base FFED4644).

### Functions given a purpose (start addresses, for reconciliation with function lanes)

- `sub_FFEF2184` — 1-bpp glyph resolver: char code → {width,height,src ptr}
- `sub_FFEE5269` — glyph width lookup (per block; special width-5 set)
- `sub_FFEF190D` — double-byte/kanji glyph blit
- `sub_FFEF1B23` — single-byte/ASCII glyph blit
- `sub_FFEFA7E7` — string renderer (char walk + double-byte mask dispatch)
- `sub_FFEF1B23`/`sub_FFEF190D` call `sub_FFEF2184`; `sub_FFEF0648` = RGB565 blit (doc 16)
- RGB565 font widgets: `FFF02DE3 FFF03AD8 FFF067A9 FFF07C24 FFEE2CCE FFEE7300 FFF4288E FFF42EB5`
- Table readers: numeric `FFEDF777 FFEE1AA2`; metric `FFEE2438`(+49); coord `FFEE6168`(group);
  charset `FFF2DC2B FFF2DDD4 FFF33499 FFF3850B`; callback/reginit `FFEDAB4C FFEDDF3A`

## Open

1. The exact extent and per-block stride of the 1-bpp pixel store in low flash
   (`pixel_base` values `0xFFC0015D`–`0xFFC35CD5`, contiguous below the RGB565 atlas at
   `0xFFC3EB80`); the bases are confirmed, the full walk is not done.
2. The precise semantics of the two parallel identity `IDX_ASC` copies (e.g.
   `FFEB7556` vs `FFEB7F6E`) — one is block 0's ordinal table, the second copy's
   consumer is not pinned down.
3. `CALLBACK_REGINIT` at `0xFFECE4E4`: the code pointers look like a small callback
   vector and the `0x00088xxx` values like a peripheral init block, but the caller
   that walks it (beyond FFEDAB4C/FFEDDF3A immediate loads) is not traced.
