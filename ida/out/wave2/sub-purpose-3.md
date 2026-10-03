# SUB purpose map — Wave-2 lane W2-5, SLICE 3

Owner-side static analysis of the decrypted FT3DR/DE ver 1.02 SUB image
(`decrypted\FT3D_SUB_ver102_ALL.bin`, RX64M, little-endian, base `0xFFC00000`,
file offset = addr − `0xFFC00000`). Read-only; nothing written to any radio, no
image produced. Machine-readable table: `ida\out\wave2\sub-purpose-3.tsv`
(columns `ea end size validated how purpose evidence`).

## Verdict

My slice is a contiguous block of the SUB **UI screen-rendering layer**
(`0xFFF03742`–`0xFFF0F030`). Every one of the 438 functions is real RX code and
was given an evidence-based one-line purpose; **none is data — 0 rejected.** The
region is built almost entirely out of one drawing framework: per-screen routines
that (a) render text labels/values through the font/blit chain, (b) draw
rectangles/regions on the current surface, (c) build "widgets" through a
begin/body/end triple, and (d) select which screen to draw through a state
dispatcher keyed on a UI-mode byte at RAM `0x8C4C`. No USB, flash-write, SDR/IQ,
or DSP-loader surface appears anywhere in the slice.

## Method

- Shared list **L** rebuilt identically to the sibling lanes inside IDA: rows of
  `ida\out\sub-window\functions.tsv` whose `validated` ∈ {xref, body}, whose start
  ea is **not** present in `ida\out\fnindex\sub-xref.tsv`, and whose purpose is
  empty; sorted by ea ascending. **len(L) = 2189.** slice_size = ceil(2189/5) =
  **438**. SLICE 3 = L[876:1314].
  **My slice: 438 functions, first ea `0xFFF03742`, last ea `0xFFF0F030`.**
  (L breakdown: 2054 body-validated + 135 xref-validated-but-absent-from-sub-xref.)
- Batch IDAPython over a private DB `W2_SUBP_3` seeded
  `--copy-from ida\db\jobs\SUB_WINDOW\SUB_WINDOW.i64` (script
  `ida\jobs\w2_sub_purpose_3_scan.py`, run through `ida\run_job.py`). For each
  function: constant-propagated peripheral/RAM/flash immediate scan, string reads,
  callee collection (named against docs 25/27/lane-10 plus helpers reversed here),
  caller census, loop shape (backward branches), switch detection, and a
  terminator test using IDA's `CF_STOP` instruction feature.
- Real-vs-data rule: a body is **rejected only if it is genuine non-code** (zero
  instructions or an undecodable/data byte on the linear path). A body that
  decodes cleanly but lacks its **own** terminator is kept as validated and tagged
  as an over-split fragment / tail-call / converging-tail, because lane-4
  over-split several large screen-draw routines at their internal
  `sub #imm,sp … add #imm,sp` frame boundaries — the pieces are real code with
  derivable purpose (they render specific strings and call specific blit helpers).
  Manual disasm confirmed: **no data lines (`dc.`/`.byte`/`align`/`unk`) occur in
  any candidate**; the "no own terminator" bodies end in `movu.w`/`add`/`sub`/tail
  `bsr`, i.e. real instructions.
- Manual review: 6 low-signal fragments were read in disasm and hand-purposed
  (`ida\log\jobs\W2_SUBP_3\vague_disasm.txt`); 12 recurring helper callees outside
  the slice were reversed to name the wrappers
  (`ida\log\jobs\W2_SUBP_3\helpers_disasm.txt`).
- Not run / out of scope: no Hex-Rays (none exists for RX); no entry into the
  DSP `26AA:0020` loader / CDC-ACM window (none is in this slice); no band /
  MARS / expanded-RX search; settled negatives in RESUME-DEEP left settled.

## Counts

- Functions in slice: **438**
- **Purposed (validated): 438**
- **Rejected (non-code/data): 0**
- Instruction bytes of purposed functions, counted by IDA item size:
  **18,642 bytes** (sum of the `size` column over validated rows; = the whole
  slice, since nothing was rejected).
- Of the 438, **180 are tagged as over-split fragments / tail-calls / converging
  tails** of larger screen-draw routines (real code, no own `rts`).

## Notable groups (with addresses)

Counts and item-size bytes by role (see `how`/`purpose` columns):

| Group | count | bytes |
| --- | ---: | ---: |
| glyph/blit/draw-framework wrapper (named callee) | 163 | 5,640 |
| label/value text draw (string refs) | 105 | 6,244 |
| rect/region draw wrapper (`FFEF1C48`) | 72 | 3,059 |
| draw-triple (begin_widget → body → end_widget) | 26 | 1,157 |
| screen-state dispatcher (`@0x8C4C`) | 15 | 1,300 |
| bar/scale/meter geometry caller (`FFEFAA2B`) | 6 | 194 |
| glyph-metric/field-coord record loader | 6/7 | ~393 |
| indicator/box draw wrapper (`FFF03652`) | 5 | 208 |
| prologue fragment (over-split head) | 25 | 105 |
| generic wrapper/dispatch + misc | ~11 | ~290 |

**The drawing framework (helpers reversed here; outside the slice, named for
cross-lane reuse):**
- `sub_FFEEF9BB` **begin_widget** — allocate a draw slot in the active-flag table
  at RAM `0x8F75`, compute the layer pixel base (`slot*0x25800 + 0x704B000`),
  store {id,w,h,params} and publish the descriptor pointer to `[0x1D3C8]`; returns
  1 if allocated. (257 callers image-wide.)
- `sub_FFEF036F` **end_widget** — commit the descriptor via `sub_FFEEFA9E` (onto
  the 16-byte-stride layer table at `0x1D3CC`) and increment the UI-mode-step
  counter at `0x8C4C`. (253 callers.)
- `sub_FFEEFEA4` mark-region-dirty (OR into flag word `@0x1D3B0`, 265 callers);
  `sub_FFEF1C48` **draw rect/region on the current surface** (4 u16 coords + mode
  → `sub_FFEF0581`, 270 callers); `sub_FFEF2505` render one menu field-cell
  (8-byte record table `@0x68868`, 126 callers); `sub_FFEE1D6D`/`sub_FFEE1DE8`
  format a u16 as up-to-3 decimal digits via the digit-glyph table `@0xFFC0012D`
  (the second blanks leading zeros); `sub_FFEF153B` grid-cell→pixel coordinate
  mapper (screen stride `0x140` = 320); `sub_FFEF1DDA` EXDMAC display-blit
  kickoff (`0x82810`/`0x82A00`). Text chain (docs 27/lane-10): `sub_FFEFA7E7`
  string renderer, `sub_FFEF1B23` ASCII glyph blit, `sub_FFEF190D` kanji glyph
  blit.

**Screen-state dispatchers (15)** — each reads the mode byte at `0x8C4C`,
bounds-checks it, and `jsr`s through a per-screen handler pointer table in the
`0xFFED74E8` region, else clamps the state:
`FFF0896A FFF08AC9 FFF0A86D FFF0A9B9 FFF0AC89 FFF0AE50 FFF0C9FD FFF0CB2E
FFF0CDFC FFF0D05E FFF0E7E0 FFF0E9F5 FFF0EBB5 FFF0ECB4 FFF0EF47`.

**Draw-triples (26)** span `FFF089D5`…`FFF0F030`; each names its body function,
e.g. `FFF0A95A → body FFF0AB1A`, `FFF0AC62 → body FFEF2505` (menu-cell),
`FFF0F030 → body FFF0F4F3`.

**Identified screens/labels (evidence = embedded ASCII drawn through the text
chain):** `FFF0389B` "DG-ID RX :", `FFF046B5` "POWER ON :", `FFF04D03` "SIGNAL"
(S-meter), `FFF03E31` "(WIRES-X)", `FFF03E73` frequency-step selector
("0.05"/"0.1"/"0.2"), `FFF04CBD` "5.0 KHz", `FFF0512D` timer "min 0 sec",
`FFF05896` "MODEL CODE : APY03D", `FFF0A4FF`.. APRS screens ("APRS AF DUAL",
"APRS DESTINATION", "APRS MSG FLASH"), and the recurring "PUSH"/"DISP" soft-key
labels (`FFF03BD8`/`FFF03C0F`, repeated per screen).

**RAM/flash landmarks used across the slice:** `0x8C4C` UI-mode-step counter,
`0x8C4D` current screen/menu id, `0x8F73` field-state index, `0x8F75` widget-slot
flags, `0x1D3B0` dirty flags, `0x1D3C8` current-surface pointer, `0x1D3CC` layer
descriptor table, `0x68868` menu-cell record table, `0xFFEC5900`–`0xFFEC6400`
glyph-metric/field-coord records, `0xFFC0012D` digit-glyph table.

## USB / mission relevance

Nothing in this slice touches USB, the SUB USB0 block (`0x000A0000`, confirmed
dark elsewhere), flash write, an IQ/SDR sample path, or the DSP loader/CDC-ACM
service window. The slice is pure on-screen UI rendering (labels, meters, menus,
APRS/WIRES-X/DG-ID screens) driven by the internal LCD surface at `[0x1D3C8]` and
the EXDMAC blit. This reinforces, from fresh coverage, that the SUB image's
outward surfaces are display/UI, not a data-export path.

## Open

1. The screen-handler pointer tables the 15 dispatchers index (in the
   `0xFFED74E8` region, per-screen `off_FFED75xx`) were not fully enumerated;
   decoding them would name each screen's per-state handlers precisely.
2. The over-split draw routines could be re-joined into their parent functions
   (lane-4 boundary artifact) — cosmetic, does not change purposes.
3. `sub_FFEF153B`'s per-orientation coordinate cases (var_C 0..0xE) map to
   specific widget layouts; only the overall role was captured here.
