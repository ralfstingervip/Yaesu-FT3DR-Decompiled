# Wave-2 lane W2-4 / SLICE 2 — SUB function purposes

Owner-side static analysis of the decrypted FT3DR/DE ver 1.02 SUB (RX64M) image
already on disk. Read-only; nothing was written to a radio, no image produced.
SUB is RX little-endian, base `0xFFC00000` (file offset = addr − `0xFFC00000`).

Machine-readable output: `ida\out\wave2\sub-purpose-2.tsv`
(columns `ea end size validated how purpose evidence`, one row per slice function).

## The shared list L and my slice

L is built identically across the five sibling lanes so the slices partition
cleanly: the rows of `ida\out\sub-window\functions.tsv` that are **validated**
(`body` or `xref`), whose start ea is **not** present in
`ida\out\fnindex\sub-xref.tsv` (lane-3's reached set), and whose **purpose is
empty**. Sorted by ea ascending. `slice_size = ceil(len(L)/5)`.

- **len(L) = 2189**
- slice_size = 438; slices: 438/438/438/438/437.
- **I own SLICE 2 = L[438:876]: 438 functions.**
- **first ea = `0xFFEF3960`, last ea = `0xFFF0370F`.**

L is the "dark" validated code: functions lane-4 proved are real bodies but that
lane-3's call/jump/vector reachability never landed on (reached only indirectly,
via register/table dispatch, or over-split by lane-4's recovery). My slice is a
contiguous run inside the LCD/UI/text-rendering band `0xFFEDB000`–`0xFFF48000`.

## Method

Batch IDAPython over a private DB `W2_SUBP_2` (seeded `--copy-from
ida\db\jobs\SUB_WINDOW\SUB_WINDOW.i64`, then `--reopen`), script
`ida\jobs\w2_sub_purpose_2.py` via `ida\run_job.py`. For each slice function:

- **Constant-prop peripheral/RAM/data scan** (the lane-3 `subvec_periph`
  technique): a light intra-function propagation of `mov.l #imm,rN` / `add #imm`
  resolves every operand — bare immediate, `[rN]`, and `disp[rN]` — to a named
  block. Classified against the peripheral map (`0x00080000`–`0x000FFFFF`), the
  flash data regions (font/charset span `0xFFEB74D8`–`0xFFED0000`, bitmap
  descriptor table, UI-layout tables, 1-bpp font master `0xFFED4644`, string pool
  `0xFFF48000`), named RAM anchors (framebuffer/active-surface ptr `0x1D3C8`,
  cam-cfg/settings struct `0x8C4D`, IPC pending buffer `0x8E46`, SCI0 callback
  table `0x12D20`), and the LCD CS1 window `0x06000000`.
- **Callees** (`bsr`/`jsr` to known function starts), each annotated with a
  purpose tag drawn from a KNOWN vocabulary (docs 20/21/25/27 named functions +
  drawing-pipeline helpers named by hand this lane, below) or from lane-3's
  `sub-xref.tsv` purpose fragment.
- **Callers**, **loop shape** (in-function backward branches), instruction bytes
  (Σ item size of code heads+tails), and terminator (canonical CF_STOP feature).
- A **role** is derived from the known-callee tags (text/graphics-draw,
  buffer-copy, IPC, menu/label, cfg-field), upgrading the generic call-graph
  label where the callee vocabulary supports it.
- **Manual review**: I disassembled the vague clusters (the "no-terminator"
  candidates and the highest-frequency un-named callees) and either reclassified
  them or hand-wrote a purpose. Six drawing-pipeline callees and three in-slice
  numeric/format utilities were named from their disassembly (see Findings).

**Validation rule.** A row is a genuine reject **only** if it holds no decodable
code (`icode == 0`, i.e. pure data / a mid-instruction split). Every function
that decodes to real RX instructions is purposed; where lane-4's boundary is
imperfect the row is purposed **and** flagged as an over-split fragment (a note
in the purpose and `clean=False` in evidence), because the code is real and its
purpose is derivable. There were **0** data rejects — expected, since lane-4 had
already discarded 413 non-function sweep candidates before validating these
bodies.

Not run / out of scope: no Hex-Rays (none exists for RX); no DSP-loader/CDC-ACM
protocol work; no band/MARS/expanded-RX search; settled negatives in RESUME-DEEP
untouched.

## Counts

| Quantity | Value |
| --- | --- |
| Functions in slice | 438 |
| **Purposed** | **438** (100%) |
| — clean standalone functions (own prologue + return) | 225 |
| — over-split fragments (purposed, boundary flagged) | 213 |
| **Rejected (not a function / data)** | **0** |
| Instruction bytes of purposed functions (Σ item size) | **18,932** |
| Instruction bytes of rejected functions | 0 |

Over-split fragment breakdown: 162 fall through with no own return, 15 have a
terminator but no own prologue (over-split head), 36 have neither
(prologue+return in an adjacent slice).

Purpose confidence / role distribution:

| Role | Rows |
| --- | --- |
| text/graphics-draw wrapper `[med]` | 324 |
| leaf/util `[low]` | 44 |
| generic wrapper/dispatch `[med]` | 12 |
| menu/label wrapper `[med]` | 7 |
| cfg-field apply/compare wrapper `[med]` | 1 |
| buffer-copy wrapper `[med]` | 1 |
| hand-verified numeric/format utilities (`how=manual`) | 3 |

Size buckets: <16 B 33, 16–47 B 313, 48–127 B 72, ≥128 B 20.

Evidence-class coverage (a row may hit several): reads string pool 126, uses
cam-cfg struct `0x8C4D` 57, reads font/charset coordinate data 22, uses IPC
pending buffer `0x8E46` 3, contains a loop 8. **Peripheral hardware blocks
touched: 0.**

## Findings

### This slice is pure UI / display code — no hardware surface

Not one of the 438 functions touches a peripheral register block (SCI, USB,
DMAC, EXDMAC, SDHI, S12AD, ICU, TPU, CMT, ports, RSPI, RTC …). The slice is the
radio's screen-drawing and value-formatting layer: it reads static text from the
string pool (`0xFFF48000`), coordinate/metric records from the font/charset span
(`0xFFECE55C`+), and the settings/state struct at RAM `0x8C4D`, and it renders
through the drawing pipeline below. This is consistent with the settled negatives
(no USB, no new peripheral surface anywhere in SUB) and adds no new attack or
data-input surface.

### The SUB drawing pipeline (helpers named this lane, from disasm)

These callees sit just below my slice and are called by hundreds of its rows;
naming them turned ~330 generic "wrapper/dispatch" purposes into precise
"text/graphics-draw wrapper" purposes. The pipeline uses a **320×240×16-bpp
off-screen VRAM** in the external-bus region and an **active-surface pointer at
RAM `0x1D3C8`**:

- `sub_FFEEF9BB` **surface-open** — finds a free slot in the surface table at
  RAM `0x8F75`, assigns it a VRAM buffer at `slot*0x25800 + 0x0704B000`
  (`0x25800` = 320·240·2), writes geometry (x/y/w/h) into the surface record,
  sets it active at `[0x1D3C8]`, returns 1 on success. (29 slice callers.)
- `sub_FFEF036F` **surface-commit** — commits the surface record at RAM
  `0x1D3B8` (via `sub_FFEEFA9E`) and bumps redraw counter `0x8C4C`. (30 callers.)
- `sub_FFEF1C48` **ui-elem-draw** — packs a 5-field draw descriptor
  (x,y,w,h,attr) and dispatches to the draw engine `sub_FFEF0581` through the
  active surface `[0x1D3C8]`. (89 callers — the dominant draw primitive here.)
- `sub_FFEF0408` **fill-rect/clear** — clears a 320-wide surface rectangle.
- `sub_FFEF002C` **draw-state-reset** — zeroes the state block at `0x1D3B0`.
- `sub_FFEF208D` **cfg-field update-if-changed** — byte-compares old vs new,
  copies and flags a redraw (`sub_FFEEFEA4` mark-dirty) only on change.

The begin/draw/end idiom recurs across the slice: `surface-open` → conditional
`ui-elem-draw`/glyph-blit → `surface-commit` (e.g. `sub_FFEF3960`,
`sub_FFEF3A11` and the whole `0xFFEF39xx`–`0xFFEF3Bxx` run).

### Notable in-slice groups (addresses)

- **Version-info screen builder — `sub_FFF00ED4`** (287 B, over-split
  head): copies the literals `"Main Ver.  :  .    "`, `"Sub  Ver.  :  .    "`,
  `"DSP  Ver.  :  .    "` from the string pool into a stack buffer, then reads
  the stored version bytes at `0x8C4D+0x21…0x29` and formats each with the
  byte→digit converters `sub_FFEE1DE8`/`sub_FFEE1D6D`. Directly answers "where is
  the DSP version shown": it is **displayed from a value already stored in RAM**
  (`0x8C4D+0x23` region), not read live from the DSP by this code.
- **Numeric/format utilities (hand-verified, `how=manual`):**
  - `sub_FFEFB2E2` (135 B) — bit-position / count-leading-zeros: index of the
    highest set bit of a u32, −1 if zero (successive halfword/byte/nibble/pair/bit
    test with shift-accumulate).
  - `sub_FFEFB645` (107 B) — u16 → packed BCD: `divu` by 1000/100/10, packing
    digit nibbles (`shll 0xC/8/4 | or`); the decimal-display formatter.
  - `sub_FFEFB430` (122 B) — byte → 2 ASCII digits at a dest pointer
    (`nibble|0x30`, `&0x3F` low nibble), with an `r3==1` blank-field mode that
    writes `'--'`/`'  '` for `'-'`/`' '`. Wrapped by `sub_FFEFB4AA`
    (caller `FFEF2044`).
- **Field-coordinate draw stanzas — `0xFFEF39F8`, `FFEF3A3E`, `FFEF3A84`,
  `FFEF3ACA`, … (25 B each):** each reads a 2-word `{x,y}`/metric record from the
  font/charset FIELD_COORD data (`unk_FFECE6EC`, `…71C`, `…73C`, stride ~0x20),
  loads draw args and falls through into the shared draw tail. 22 rows read this
  data region.
- **Settings/state (cam-cfg `0x8C4D`) screens — 57 rows.** The struct doc-20
  identified as the USB-CAMERA/settings config base; these rows render and apply
  its fields (e.g. `sub_FFF00420` cfg-field apply via mark-dirty; the field
  jump-table cases around `sub_FFEFFEB8`). Purely on-screen settings I/O.
- **IPC-pending-buffer readers — `sub_FFEF495B`, `sub_FFEFE223`, `sub_FFF00420`
  (RAM `0x8E46`):** UI code that reflects incoming IPC state into the display; it
  reads the pending buffer, it does not drive the SCI0 link.

### Over-split fragments

213 of the 438 rows are real code whose lane-4 boundary does not enclose a full
prologue-to-return function (they are jump-table landing pads, loop bodies, or
head/mid slices of a larger routine — e.g. the version builder `FFF00ED4`, the
record-copy loop `FFF02827` calling `memcpy sub_FFEFB268`, the status-string
writer `FFF031BE`). Each is purposed and its boundary status recorded in the
`evidence` column (`clean=False`) and in the purpose (`frag: …`). This is the
known lane-4 over-split artifact (doc 21 Open #3), not garbage: every one decodes
to clean RX and carries derivable meaning.

## USB relevance

None directly. This slice contains no USB, SCI, DMA, or any peripheral access —
it is the LCD/UI/number-formatting layer. Its one mission-adjacent contribution
is the **version-info screen** (`FFF00ED4`): the on-screen DSP version is a byte
stored in RAM (`0x8C4D+0x2x`), formatted and drawn here, confirming the version
display is passive and does not itself reach the DSP. The named drawing-pipeline
vocabulary (surface-open/commit, ui-elem-draw, fill-rect, `[0x1D3C8]` active
surface, `0x8F75` slot table, `0x0704B000` VRAM) is reusable by other lanes
mapping SUB's screen code.

## Open

1. The 12 generic `[med] wrapper/dispatch` and 44 `[low] leaf/util` rows are the
   call-graph floor for RX without a decompiler; their remaining un-named callees
   each appear only 3–4 times, so naming them individually is low-yield.
2. `sub_FFEE1DE8`'s dual use (doc-20 "fetch-label" vs. the byte→digit role it
   plays in the version screen) suggests it is a more general "format value into
   buffer" than doc-20's menu-context name; not re-adjudicated here (doc-20 is
   settled).
