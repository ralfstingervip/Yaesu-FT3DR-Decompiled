# sub-FFEFB2C2-FFF030D5: SUB UI screens 0x1F, 0x20, 0x29 to 0x2C and SET-MODE item pages

This file covers 123 functions: 122 Confirmed and 1 pseudo-function (`FFF01EFB`, see below). There are no Skeletons. The RX64M disassembly was decompiled by hand. The code is unoptimised CC-RX output (every local is spilled to the stack), so the bodies were traced in full.

## What the range is
1. **`FFEFB2C2`–`FFEFB7F8`: bit, BCD and byte-order helpers.**
   - Live: `bit_mask`, `lsb_index` (the UI uses it to pick the next event) and the BCD-to-ASCII pair `FFEFB430`/`FFEFB4AA`.
   - The other 14 are dead.
2. **`FFEFB7F8`–`FFEFE223`: five touch screens, all on one framework.**
   - The phase machine is `ui_phase` (`0x8C4C`): 0 init/latch, 1 static frame, 2 full-screen layer, 3 event loop.
   - Each screen has a phase table and an event table at `0xFFED7228`…`0xFFED74E4`.
   - Events are bit numbers in the 64-bit word `0x1D3B0`. Frame latchers post bit 15 when the value changes, and bits 16 and up for rows or soft keys. Touch zones post the same numbers.
   - A blink timer at `0x68854` re-posts registered events to make cursors blink.
   - The screens:
     - **0x29 (F600/F610):** digital message/picture folder. The category menu is "VOICE / MESSAGE / PICT". The list has 5 rows of 0x18-byte entries.
     - **0x2A (F620/F621):** message header and body: TO, FROM, SENT/RCVD date, D/L date, "NEW". The body scrolls over 3 pages.
     - **0x2B (F622):** a 20-character edit line plus a 4-row pick list.
     - **0x2C (F630–F632):** picture/message detail viewer with an info overlay. Dates are 5 BCD bytes printed as "20yy/mm/dd hh:mm".
     - **0x20 (F3B3/F3B8/F513–F515/F623):** the shared keyboard (doc 23). `scr20_kbd_type` maps the page to a field rectangle.
3. **`FFEFE223`–`FFF004C2`: screen 0x1F, the SET-MODE item page.**
   - Covers the phase machine, title centring, frame latching, and the 12 per-group store handlers named in doc 38.
4. **`FFF004C2`–`FFF030D5`: value drawers.**
   - Groups 1 (DISPLAY), 2 (TX/RX), 3 (MEMORY) and 4 (SIGNALING).
   - Also the shared bank/name list renderer `draw_bank_list`.

## Notable findings
- **Item 0x23 has its own value page.** It has no row of its own: `sub_FFF09396` maps it to row 0, so the title reads "DIGITAL POPUP". The page it draws is a digital squelch page: "SQL TYPE: OFF/CODE/BREAK", "SQL CODE: nn" and "(WIRES-X)" when `+0x24 == 1`. This is the other user of "(WIRES-X)" that doc 44 mentions (`FFF013F5`).
- **Item 0x4D (WX ALERT) and frame header byte 6.**
  - The 0x4D store case is the only one that latches frame header byte 6.
  - `scr1F_item_handler` suspends screen 0x1F entirely when a pending frame for item 0x4D in group 4 has byte 6 == 0.
- **IDA function bounds are wrong around `FFF01D02`.**
  - `sub_FFF01EFB` (17 B) is not a function. It is the shared cursor-and-divider tail of `draw_value_memory`'s MEMORY SKIP case.
  - `FFF01F0C`–`FFF01F6F` (the MEMORY WRITE "LOWER/NEXT" case) is ownerless code that belongs to `FFF01D02`. It is missing from the chunk listing and was recovered from `ida/out/sub-residue-final/raw/codeheads.tsv`.
- **Latent bugs in the firmware.**
  - DTMF MODE (0x43): the cursor y is uninitialised when the row is above 2.
  - VOX DELAY (0x2B): the table index is not clamped.
  - Dead helpers: `u8_to_dec_buggy` emits v%div, and the BCD inc/dec helpers add or subtract 6, not 7.
- **Event delivery waits on the LCD queue.** Events are taken only while no layer transfer is queued (`0x8F76`). Screen 0x1F also re-latches on every pass and clears all events when a handler drops the phase back below 3.
- **Other value-page details found here:**
  - RX AF DUAL: TRX 1–10 s, HOLD, TX 1–10 s. JP labels 送受信/送信/固定.
  - BELL ringer: "1time" vs "n times" (singular is drawn by length).
  - PR FREQUENCY: 300 + 100·v Hz.
  - TONE SQL FREQ and DCS CODE blink while bit 7 is set (edit mode).
  - DCS INVERSION: a 6-way Rx/Tx NORMAL/INVERT/BOTH map.

## Consistency with docs
- Store handlers, value strings and tables agree with docs 38, 44 and 45.
- Doc 08 open item 5 (`0xFFC3DF35`) is the group-title length used to centre the title. Doc 23 already settles it, and this use confirms it.
- No contradictions found.
- `0x8F72` reads 0 = Japanese here. That matches doc 38's "`!= 1` is Japanese" for the values seen.

## Conventions and caveats
- IDA prints #UIMM8 immediates as negative numbers. They were read as unsigned bytes where they are coordinates, heights or byte compares (-10h = 240, and so on). Header comment in the .c.
- ROM strings are named by their IDA symbols (`aOff_5`, `a670`, …). Addresses are given only where a doc proves them. Data tables are not in the listings, so the contents of the per-screen phase/event tables come from data xrefs (`ida/out/sub-final2/raw/query_seed/funcs.tsv`), not from table bytes.
- Callee names outside the range (`layer_begin`, `draw_text`, `post_event_lo` …) were given by this lane from short reads of those functions. They are Inferred names.

## Left undone
- The JP-branch JIS strings of DCS INVERSION and TONE SEARCH are summarised, not transcribed glyph by glyph.
- The contents of the string tables (MUTE 4×9, DIGITAL POPUP 10×7/10×13) were not read; the listings do not include data.
- Meaning of `0x8D79`.
- Identity of the 3-glyph title word in screen 0x29.
