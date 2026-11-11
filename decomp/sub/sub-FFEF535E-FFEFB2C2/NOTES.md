# Lane sub-FFEF535E-FFEFB2C2: SUB LCD widget layer

54 functions, 0xFFEF535E–0xFFEFB2C2 (≈ 24 KB, 11.7 KB of it in `sub_FFEF6C42`).
Coverage: 54 of 54 have a header and a C body. 47 are Confirmed and 7 Inferred (the body is traced fully, but the
meaning of the name is a reading). None is a Skeleton.

## What the range is

- **Band-row status items on the operating screen** (`bandrow_*`). Each one asks a position helper in
  0xFFEECxxx–0xFFEEFxxx for (x, y[, dim]). It returns if the item is off-screen, restores the background under
  its cell, and draws from the **band display record** that `band_rec_ptr()` (sub_FFEEC3BD) returns. That
  pointer is into the MAIN status-frame shadow at 0x8C4D: +0x20 for the upper row and +0x6C for the lower row.
  The record's field map is in `globals.tsv` (`rec+NN` rows).
- **The frequency readout**, `freq_draw_digits` (sub_FFEF6C42).
- **Primitives**:
  - `icon_draw_or_erase`, with 330 callers.
  - `shape_draw_or_erase`.
  - The string renderers: `text_draw_mixed` (441 callers, 1-bpp font) and three RGB565 font renderers.
  - `screen_grid_draw`, with 66 callers. It draws bevelled cell grids and tile screens.
  - Title bar, scroll bars, rounded panel, screen clears, `memcpy_bytes` and `memset_bytes`.

## Notable findings

1. **sub_FFEF6C42 is the main frequency display. This contradicts doc 31 §sub_FFEF6C42**, which called it a
   "multi-slot screen (GM grid / APRS / band row)". The evidence:
   - rec[0x30..0x33] are unpacked as 8 packed-BCD digits, and a nibble ≥10 is read as 0.
   - Leading zeros are blanked.
   - Digits 6 and 7 use a smaller glyph set and are hidden when both are 0.
   - The 8x28 … 11x52 bitmaps are **decimal points**. They are drawn at x=131/140/114, between digit columns
     x=88 and x=144, and only while the MHz digits are non-zero.
   - The "slot array 0x68F20, stride 0x28" is ten 10-pointer **digit-glyph tables**.
   - The "three 10-byte caches" 0x8F79/83/8D are per-row **digit caches**: 8 digits, plus [8] "trailing 00
     hidden" and [9] "point shown".
   - `FFEF690B` draws digit bitmaps through span masks. It is not "text/number draw".
   - doc 31's "FFEF95BD sibling draw block ×18" does not exist. FFEF95BD falls inside `cmp #6,r14`
     (`61 6E` at FFEF95BC), which is the misread that doc 48 lists. Nothing branches there.
   - The six layout blocks are the same code with different constants (checked by a normalised diff), so the
     C is driven by a table.
2. **Tone/DCS readout is proven by its tables.** rec[0x45] is the tone mode. rec[0x46] indexes a 50-entry
   5-glyph table at FFC3D8C2. rec[0x47] indexes a 104-entry 3-glyph table at FFC3D9BC. Those are the standard
   CTCSS and DCS set sizes. Indices ≤ 11 use 4 glyphs, which fits the 12 tones below 100 Hz.
3. **Record fields named here for the first time:**
   - rec[0x3F] is the communication mode, 0..0x1B. Codes 0x0E..0x1B are blink variants of 7..13. The
     "digital" class is m<4 or 7..10, and it switches the slot between DG-ID and tone.
   - rec[0x49] and rec[0x4A] are TX and RX DG-ID, 0..99.
   - rec[0x43] and rec[0x44] are meter level and peak.
   - rec[0x48] bit4 selects the "A96"/"A12" APRS baud tag.
   - frame[0x12] is the battery level.
   - frame[0x14..0x17] are the list index and count used by the scroll thumb.
4. **Doc 23's open item: the "stack-built wrapper descriptors" at FFEFAC8B, FFEFADCF and FFEFAEF3.** These are
   the three RGB565 font renderers. Each copies w/h/pix/key from the flash glyph descriptor, reached through a
   RAM pointer table (0x688BC, 0x68A34, 0x68BAC). Only the tint and tint-enable words come from the caller, so
   the copy has no RAM pixel source.
5. **`band_row_type()` (sub_FFEEC232) can be forced.** When 0x12285 != 0xFF it returns that value, so callers
   choose which row (1 upper, 2 lower, 3 single) the same item code draws. Every per-band item depends on this.

## Corrections / doc deltas

- doc 20 gives `sub_FFEFA7E7(x, y, str, color)`. The arguments are actually (x, y, dbcs_mask, str): the third
  is the 16-bit double-byte mask and the fourth is the string. Doc 45 §4.3 already reads it this way. There is
  no colour argument. The coloured variant is `sub_FFEFA924`, and as compiled it draws single-byte characters
  in fixed grey 0x7BEF.
- **Immediate signedness.** IDA prints RX `#UIMM8` operands as negative. So the clip test is y ≥ 240 (not
  "< -16"), and coordinates such as -7Dh = 131 and -49h = 183 are unsigned. Frame opcodes 0xF1/F3/F6/F7/F8/FD
  confirm this.
- **`sub_FFEF04F7`, `FFEF0AFE` and `FFEF0BD4` restore pixels from a background surface at 0x07000000.** In
  effect, every "erase" in the UI copies the wallpaper back. Doc 31 calls `FFEF0AFE` a "compositor"; in fact it
  erases a glyph's opaque pixels.

- **Compiled quirks kept as is:** `battery_draw` places its segments at an absolute x (27-3n) and ignores the x
  argument. `dead_draw_label_composite` starts its running x at 0. In `bandrow_draw_main` kind 1, row type 3,
  screens other than F1/12 and F1/14 reach the draw with coordinates that were never set.

## Left undone (TODO waveC)

- `freq_draw_digits`: the decimal-point y exceptions per layout are listed in a comment and not coded into
  `FREQ_LAYOUT`. The x of the FIELD_COORD entries (flash FFEC61A8/61E4/6220/625C) is not reproduced.
- The icon meanings are not named. These are rec[0x34] icons 1-3, rec[0x3D] icons, rec[0x3E] 1..10+suffix,
  rec[0x48] bits 0-1, and the status-bar icon sets of `statusbar_icon_sel8/sel4`. Naming them needs the
  bitmaps rendered from the firmware, which is not in the repo.
- The tone-mode values 0..11 and the 14 communication modes need display names. That needs the icon pixels or
  the MAIN-side encoder.
- The position helpers (FFEECAE0 … FFEEF0AA) and `band_row_type` live in other lanes. They are named here
  only as callees.
