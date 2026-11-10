# Lane sub-FFEE1BC0-FFEE87EE (SUB RX64M, 228 functions)

## What the range is
- `FFEE1BC0`-`FFEE2248`: small numeric/text helpers (BCD, hex, 2/3/5-digit
  formatters, hex/decimal parsers used by the NMEA parser) and the CC-RX
  `lowlvl.src` simulator stubs `charput`/`charget`.
- `FFEE2248`-`FFEE87EE`: SUB touch-LCD **screen modules** dispatched through
  `k_screen_tbl` (`FFED4050`, indexed by `0x8A8C`). Every module has the same
  compiler-generated shape (entry / phase0 / phase1 background / phase2 full
  redraw / key handlers / phase3 dispatcher / apply / apply_fields); the
  shape is documented once at the top of part 2 of the `.c`.

| Screen | MAIN page | Module | Name used |
|---|---|---|---|
| 0x22 | F500/F502 (F501/F503 vestigial) | FFEE2248 | aprs_list |
| 0x23 | F510 | FFEE2E69 | aprs_detail |
| 0x28 | F518 | FFEE3497 | aprs_text |
| 0x26 | F516 | FFEE3A1C | aprs_edit (Inferred) |
| 0x25 | F512 "To:" | FFEE3EF7 | aprs_to |
| 0x24 | F511 | FFEE4421 | aprs_stn (symbol / compass) |
| 0x27 | F517 "TEXT" | FFEE4E99 | aprs_stxt (Inferred) |
| 0x1C | F200..F22C | FFEE52B3 | charpick |
| 0x04/0x05 | F104/F105 | FFEE5C42 | numentry (Inferred) |
| 0x03 | F103 | FFEE609E | mainalt (Inferred) |
| 0x0D | F10D/F10F | FFEE6A51 | gpsinfo (Inferred) |
| 0x0B | F10B | FFEE7497 | scope (band scope, Inferred) |
| 0x07/0x16 | F107 / F006 | FFEE7C9F | keypad + PASSWORD |
| 0x00 | F100 | FFEE837F | main |

Confidence: every body was traced instruction by instruction; functions.tsv
marks a module `Inferred` where the *screen identity* is a guess from the
drawing (the control flow there is still fully traced).

## Notable findings
1. **Request-bit model.** "Keys" in the key tables are bits of a 64-bit mask
   at `0x1D3B0`. Touches and apply_fields dirty bits share it: key 0 =
   restart screen (`FFEF3991`), 1 = full background, 2 = blank, 15/16 =
   header/body, 17.. = icons; F1 screens use the high word (keys 32..63).
   This explains every key-table slot in `FFED4300`-`FFED5108`.
2. **charput/charget are stock CC-RX simulator I/O** (`O_PUTC 0x01220000`,
   `O_GETC 0x01210000`, `SIM_IO 0`). Answers doc 135 open question 2.
3. **0x8F72 is the language flag**: the password screen draws JIS X 0208
   kanji 0x467E 0x4E4F ("input") / 0x4550 0x4F3F ("registration") after a kana
   title when it is 0, English "PASSWORD INPUT/ENTRY" otherwise. Doc 12's
   "password state" and "0x4E4F = ON" readings are wrong (RESUME-FULL already
   had the language flag).
4. **Doc 79 open items closed**: `sub_FFEE5A73` is the char-picker full-grid
   painter (second glyph_tbl8 reader); `0x68868` slots hold `{x,y,w,h}`
   rects. Doc 79's row/col naming in the code-map index is swapped
   (row = cell>>3 -> x0x10, col = cell&7 -> x2).
5. Doc 20 called `sub_FFEE333B` a log timestamp formatter; it is the screen
   0x23 body painter filling "[20yy/mm/dd hh:mm]" from BCD frame bytes.
   Doc 23 said `FFEE2248` is "not a function": it is the screen-0x22 entry.
6. Compass pages (0x24 fixed north-up, 0x0D heading-up rotating in 16 steps)
   share the N/E/S/W label images `FFED236C/234C/237C/238C`.

## Encoding note
IDA's RX text prints 8-bit unsigned immediates signed (`#-10h` = 0xF0 = 240,
`#-2Ah` = 0xD6, `#-4Ch` = 0xB4). Geometry proves the unsigned values
(y + h = 240 everywhere); the `.c` uses them.

## Left undone
- Key slots 16 and 19 of screen 0x24 (`FFED457C`, `FFED4588`) are not in the
  pointer index; their handlers are unknown.
- Band painters `sub_FFEF4FCE`..`FFEF64D2`, the 11.8 KB text renderer
  `sub_FFEF6C42` and the shared F1 key handlers (`FFEEB8E4`..) are outside
  the range; named generically.
- Text of ROM labels (`a5_0` table, `FFF48580` kana) and table contents
  (`FFC3D396`, `FFEC59xx`) not dumped (no image in repo).
