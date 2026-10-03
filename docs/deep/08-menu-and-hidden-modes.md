# SUB setup menu, the walker, and the hidden modes

## Verdict

The setup-menu system in the RX64M SUB image is fully cracked. The 20-byte record
is not a record at all — it is a plain `char[20]`, and all the metadata lives in a
separate descriptor array whose real base is **`0xFFED74E8`, eight bytes below the
`0xFFED74F0` the previous pass searched for**, indexed **1-based**. That eight-byte
miss is the whole reason the earlier pass found no reader. The walker is
**`sub_FFF0964A` at `0xFFF0964A`** (`mul #14h` against the item index, `shll #3`
against the category, `add 4[r14].l` for the label pointer), driven by the page
renderer **`sub_FFF09171`** and the item-count function **`sub_FFF095E3`**. All of
this sits in `0xFFF00000`–`0xFFF10000`, a 64 KB window in which the inherited
455-function database contained **zero** functions.

On the three labels: **`COM PORT SETTING` is an ordinary documented APRS setting**
(APRS item 17 of 28) — nothing unexplained about it, it configures the DATA-jack
serial port. **`USB CAMERA` is real, reachable and unconditional**: it is item 1 of
4 in the `OPTION` category, it has a localised Japanese label (`USB ｶﾒﾗ`), and the
`OPTION` category screen `sub_FFF08201` draws its settings — `SIZE : 320*240 /
160*120`, `QUALITY:`, `SP SEL : CAMERA / INT SP`. It is a camera-accessory
*settings* screen inherited from the FT1D/FT2D lineage, and it is **not** evidence
of a USB host stack: the RX64M USB0 window `0x000A0000`–`0x000A03FF` is never
addressed anywhere in the 4 MB image, across all four RX immediate widths.
**`RAM DISPLAY` is a genuine hidden engineering screen**, and I found its gate:
**bit 7 of the settings byte at RAM `0x00008E4D`**. That bit both adds the extra
`OPTION` row (`sub_FFF095E3`) and unlocks a 4-page RAM-monitor screen
(`sub_FFF0A86D`). No instruction in the recovered code ever *sets* that bit — it is
only ever copied wholesale out of the stored settings struct — so the entry is a
settings-image bit, **not a key combination**. Settings themselves live in two
parallel ~256-byte SRAM structs (`0x00008E46` stored, `0x00008C4D` applied) and the
SUB image contains **no non-volatile store driver at all**: no flash FCU, no data
flash, no RSPI, no RIIC, no standby RAM. Persistence is not SUB's job.

## Method

Seeded a private database `MENU` from `ida\db\radio\SUB.i64` with `--copy-from`,
then five IDA jobs under `ida\jobs\`:

| Job | What it did |
| --- | --- |
| `menu_walk.py` | linear sweep of `0xFFEE0000`–`0xFFF50000`, 129,924 instructions created, 455 → 1463 functions; seeded the six constant sites; dumped the walker |
| `menu_dispatch.py` | swept `0xFFEC0000`–`0xFFEE0000` (47,585 more instructions, → 1539 functions); callers of the walker; peripheral operand census |
| `menu_module.py` | full disassembly slab of the menu module `0xFFF08000`–`0xFFF0B400` |
| `menu_gates.py` | resolved base+displacement operands from disassembly text (the IDA RX module does not expose the displacement in `op.addr`); gate reads/writes; string xrefs |
| `menu_final.py` | the decisive functions and their upward call chains |

Plus whole-image work in Python directly on `decrypted\FT3D_SUB_ver102_ALL.bin`
and `FT3D_MAIN_ver102_EXP.bin`, which needs no IDA and gives 100 % coverage:

- A raw LE-dword scan for every reference into the label and descriptor tables.
  This is what found `0xFFED74E8`.
- **An opcode-filtered immediate scan over all four RX immediate widths.** RX
  encodes `MOV.L #imm, Rd` as `FB (rd<<4)|(li<<2)|0b10`, where `li` = `00`→32-bit,
  `01`→8-bit, `10`→16-bit, `11`→24-bit. 14,968 sites in the image: 11,147 are
  32-bit, **2,545 are 24-bit**. Every peripheral address in this firmware is loaded
  with the *24-bit* form, because `0x0008xxxx` fits in 24 bits. A scan that looks
  only at 32-bit immediates sees zero peripherals. That is a coverage bug worth
  passing to the other agents.

**Scope covered.** The code regions `0xFFEC0000`–`0xFFF50000` are now swept and
carry 1539 functions. Whole-image byte-level scans cover all 4,194,304 bytes.
**Not covered:** `0xFFC00000`–`0xFFEC0000` was not swept for code by me — SUB-LOWER
owns it, and their `region_map_summary.txt` classifies `0xFFC00000`–`0xFFE80000` as
87.2 % RGB565 bitmap, 9.3 % glyph, 0.4 % text and **0.04 % code**, which is
consistent: there is essentially no code down there and the menu walker was never
going to be found there.

**What I did not settle:** the entry condition for `DSP WRITE MODE`, and the
identity of the 13-byte table at `0xFFC3DF35`.

## Findings

### 1. The record layout — there is no record, only a string, plus a descriptor array

The 20-byte stride entry is a bare `char name[20]`, NUL-padded, no other fields.
Confirmed by reading the bytes: `0x3DF4D` = `54 41 52 47 45 54 20 4C 4F 43 41 54
49 4F 4E 00 00 00 00 00` = `"TARGET LOCATION"` + 5 NULs. All metadata is in a
second table:

```c
struct menu_cat {
    uint32       count;     /* number of visible items          */
    const char (*labels)[20];
};
struct menu_cat menu_table[24] @ 0xFFED74E8;   /* file 0x2D74E8 */
```

`menu_table[0]` is not a category: it is `{ 0, 0xFFC3DD55 }`, and `0xFFC3DD55` is
the **category-name array base minus one slot**, so the names are 1-based too.
Both arrays are indexed from 1. Confirmed end to end: `names[21]` =
`0xFFC3DD55 + 21*20` = `0xFFC3DEF9` = `"TX/RX>MODE"`, and `menu_table[21]` =
`{3, 0xFFC3E781}` = `ANTENNA ATT / FM BANDWIDTH / RX MODE`, which is exactly the
TX/RX > MODE submenu.

Full decode in **`ida\out\menu\menu_categories.tsv`** and
**`ida\out\menu\menu_records.tsv`**. Summary:

| idx | descriptor | count | labels | name |
| --- | --- | --- | --- | --- |
| 0 | `FFED74E8` | 0 | `FFC3DD55` | *(category-name array base, 1-based)* |
| 1 | `FFED74F0` | 9 | `FFC3DF4D` | DISPLAY |
| 2 | `FFED74F8` | 3 | `FFC3E001` | TX/RX |
| 3 | `FFED7500` | 6 | `FFC3E03D` | MEMORY |
| 4 | `FFED7508` | 14 | `FFC3E0B5` | SIGNALING |
| 5 | `FFED7510` | 6 | `FFC3E1CD` | SCAN |
| 6 | `FFED7518` | 2 | `FFC3E245` | GM |
| 7 | `FFED7520` | 5 | `FFC3E26D` | WIRES-X |
| 8 | `FFED7528` | 22 | `FFC3E2D1` | CONFIG |
| 9 | `FFED7530` | 28 | `FFC3E489` | APRS |
| 10 | `FFED7538` | 4 | `FFC3E6B9` | SD CARD |
| 11 | `FFED7540` | 4 | `FFC3E709` | **OPTION** |
| 12 | `FFED7548` | 1 | `FFC3E76D` | CALLSIGN |
| 13–20 | `FFED7550`–`FFED7588` | 0 | `00000000` | *(blank name slots, unused)* |
| 21 | `FFED7590` | 3 | `FFC3E781` | TX/RX>MODE |
| 22 | `FFED7598` | 4 | `FFC3E7BD` | TX/RX>DIGITAL |
| 23 | `FFED75A0` | 5 | `FFC3E80D` | TX/RX>AUDIO |

Those 12 live categories are exactly the 12 setup-menu categories of the shipped
radio. The label arrays are **contiguous and gapless** on the 20-byte lattice: each
category's `labels + count*20` lands on the next category's `labels`, with one
single exception, `OPTION` — see §4.

Counts sum to **116**. The lattice from `0xFFC3DF4D` to `0xFFC3E871` holds
`(0x3E871-0x3DF4D)/20` = **117** populated slots. The one uncounted slot is
`RAM DISPLAY`. (Correction to the earlier record: the "120 slots contain text"
figure included the packed strings from `0xFFC3E871` onward — `LOCAL NEWS`,
`UPLOAD`, `DOWNLOAD`, `SEARCH & DIRECT` — which are NUL-terminated WIRES-X strings
referenced individually, not 20-byte menu slots.)

There is **no direct cross-reference to `0xFFC3DF4D` or `0xFFC3DD55` anywhere in the
image** (`ida\out\menu\menu_xrefs.tsv`). A label can only be reached as
`menu_table[cat].labels[item]`. That is the architectural fact.

### 2. The walker — `sub_FFF0964A` at `0xFFF0964A`

```
FFF09691  B3 89              movu.b  14h+var_5[sp], r1     ; r1 = cat
FFF09693  6C 31              shll    #3, r1                ; cat * 8
FFF09695  FB E2 E8 74 ED FF  mov.l   #0FFED74E8h, r14      ; descriptor base
FFF0969B  4B 1E              add     r1, r14               ; &menu_table[cat]
FFF0969D  B3 83              movu.b  14h+var_6[sp], r3     ; r3 = item
FFF0969F  75 13 14           mul     #14h, r3              ; item * 20   <<< the stride
FFF096A2  06 89 E3 01        add     4[r14].l, r3          ; + menu_table[cat].labels
...       draw_string(x+0x2A, y, r3, maxlen=0x14)
```

Reconstructed:

```c
/* sub_FFF0964A */
void menu_draw_row(uint16 x, uint16 y, uint8 cat, uint8 item)
{
    char buf[16];
    itoa(buf, item + 1);                       /* sub_FFEE1DE8: 1-based row number */
    draw_string(x, y, buf, 2);                 /* sub_FFEF1B23, width 2           */
    if (*(uint8 *)0x8F72 == 1) {               /* language == English             */
        draw_string(x + 0x2A, y,
                    menu_table[cat].labels + item * 20, 0x14);
        return;
    }
    switch (cat) {                             /* localised draw, one fn per cat  */
      case 1:  return draw_display_row (x+0x2A, y, item);  /* sub_FFF097AF */
      case 2:  return draw_txrx_row    (x+0x2A, y, item);  /* sub_FFF098CC */
      ...
      case 11: return draw_option_row  (x+0x2A, y, item);  /* sub_FFF0A7B9 */
      case 12: return draw_callsign_row(x+0x2A, y, item);  /* sub_FFF0A84B */
      case 0x15: case 0x16: case 0x17: ...
      default: return;
    }
}
```

The dispatch tests `cat` against `1..0x0C`, `0x15`, `0x16`, `0x17` — precisely the
15 non-empty descriptor slots, and *not* 13–20. Independent confirmation of the
table's shape from the code side.

### 3. The page renderer and the count gate

```c
/* sub_FFF09171 — draw one page of the setup list */
void menu_draw_page(uint16 x, uint16 y)
{
    uint8 cat    = *(uint8 *)0x8C6D;          /* 0x8C4D + 0x20 */
    uint8 top    = *(uint8 *)0x8C6E - 1;      /* 0x8C4D + 0x21 */
    uint8 cursor = *(uint8 *)0x8C6F;          /* 0x8C4D + 0x22 */
    if (cat >= 0x18)  cat = 1;                /* valid categories are 1..0x17 */
    uint8 n = menu_item_count(cat);           /* sub_FFF095E3 */
    if (top >= n)  top = 0;
    if (cursor >= 6) cursor = 0;
    if (n <= 6)    top = 0;                   /* no scrolling when it fits */
    for (uint8 row = 0; row <= 5 && row < n; row++) {
        uint8 item = top + row;
        if (item >= n) item -= n;             /* wrap */
        if (row == cursor) draw_highlight_bar(...);
        menu_draw_row(x, y + row*0x24 + 2, cat, item);
    }
}
```

Six rows per page, `0x24` pixels apart. **`n` from `sub_FFF095E3` is the only gate
on which labels get drawn.**

```c
/* sub_FFF095E3 — the item count, with two gates */
uint8 menu_item_count(uint8 cat)
{
    uint8 n = *(uint8 *)(0xFFED74E8 + cat * 8);     /* low byte of .count */
    if (cat == 0x0B && (*(uint8 *)0x8E4D >> 7) == 1)
        return n + 1;                               /* OPTION gains one row    */
    if (cat == 0x04 && *(uint8 *)0x8C53 == 0)
        n = n - 1;                                  /* SIGNALING loses one row */
    return n;
}
```

The `SIGNALING` case removes item 14, `WX ALERT` at `0xFFC3E1B9` — the NOAA
weather-alert feature, which is US-market only. So `0x00008C53` is a
destination/market flag. The `OPTION` case is `RAM DISPLAY`.

### 4. The three labels, settled

#### `COM PORT SETTING` — `0xFFC3E5C9` — ordinary, documented, reachable

`0xFFC3E5C9` = `0xFFC3E489 + 16*20`, i.e. **APRS item 17 of 28**, comfortably
inside `menu_table[9].count = 28`. There is nothing unexplained about it: it
configures the serial port on the DATA jack, and the Japanese pool carries its
counterpart at `0xFFF4A977` (`"COM "` + katakana). Confirmed reachable.

#### `USB CAMERA` — `0xFFC3E709` — real, reachable, unconditional, and NOT a USB host feature

- It is `menu_table[11].labels[0]`, i.e. **OPTION item 1 of 4**. `count = 4`, so
  items 0–3 are drawn. It is therefore drawn on every FT3D, in every region, with
  no conditional anywhere. Confirmed.
- The whole `OPTION` category is `USB CAMERA`, `Bluetooth`, `DEVICE LIST`,
  `Bluetooth Save` — `0xFFC3E709`, `0xFFC3E71D`, `0xFFC3E731`, `0xFFC3E745`. The
  neighbours the assignment described (`FORMAT` before, `Bluetooth` after) are the
  last item of `SD CARD` and the second item of `OPTION`; the boundary between
  those two categories falls exactly there.
- **It is localised.** `sub_FFF0A7B9`, the Japanese `OPTION` row draw, has
  `case 0: draw(x, y, 0xFFF4AA16)` and `0xFFF4AA16` is `55 53 42 20 B6 D2 D7 00` =
  `"USB "` + JIS X 0201 half-width katakana `ｶ ﾒ ﾗ` = *kamera*, camera. A dead
  string left over from another product does not get a hand-written Japanese
  translation and its own switch case.
- **There is code behind it.** `sub_FFF004C2` is the setup-item screen dispatcher:
  `case 0x0B: bsr sub_FFF08201` at `FFF00556`. And `sub_FFF08201`
  (`0xFFF08201`–`0xFFF0878C`) is the screen that draws `SIZE   :` (`0xFFF4A48D`),
  `320*240` (`0xFFF4A496`), `160*120` (`0xFFF4A49E`), `QUALITY:` (`0xFFF4A4AF`),
  `SP SEL :` (`0xFFF4A4B8`), `CAMERA` (`0xFFF4A4C1`), `INT SP` (`0xFFF4A4C8`).
  Snapshot size, JPEG quality, and whether audio comes out of the camera
  accessory or the internal speaker.
- **But it is not a USB host feature.** Whole-image, all four immediate widths:
  **zero** loads of any address in `0x000A0000`–`0x000A03FF`. Only three strings in
  the entire 4 MB image contain "USB": this menu label, `USB ` at `0xFFF4AA16`
  (the same label's Japanese form), and `uSb` at `0xFFF46677` which is
  mid-instruction bytes, not a string. No descriptors, no VID/PID, no endpoint
  tables. The accessory is a camera-equipped speaker-microphone on the radio's
  accessory jack; "USB" is Yaesu's name for that connector on this product family,
  not the RX64M USB peripheral.
- **Lineage.** The MAIN image carries a three-slot model table `FT1D` / `FT2D` /
  `FT3D` at `0x04C388` / `0x04C39A` / `0x04C3AC`, the string `YAESU FT1D` at
  `0x045304`, and two clone-file headers: `V0030FT3D ... 20180418` at `0x06C539`
  and `V0020FT2D    JPN     Ver0202 20180418` at `0x06C571`. The camera-microphone
  accessory is an FT1D/FT2D-generation feature, and this firmware is a direct
  descendant that still carries all three model identities. That explains the
  label's history — but unlike `RAM DISPLAY`, it is **not** unreachable: the count
  includes it and the screen exists.

#### `RAM DISPLAY` — `0xFFC3E759` — genuine hidden engineering screen, gate found

This is the interesting one, and it is hidden by exactly the mechanism the
assignment hypothesised.

- It occupies the **one slot in the entire 20-byte table that no count covers**.
  `menu_table[11].labels = 0xFFC3E709`, `count = 4`, so the covered slots end at
  `0xFFC3E745`. `RAM DISPLAY` is at `0xFFC3E759` = slot index 4.
  `menu_table[12].labels = 0xFFC3E76D` = `0xFFC3E759 + 20`. The array is otherwise
  gapless, so the hole is deliberate: **the item was hidden by leaving the label in
  place and not counting it.**
- The gate is **bit 7 of the settings byte at RAM `0x00008E4D`**, read at
  `FFF09602` (`mov.l #8E46h, r1` / `movu.b 7[r1], r1` / `shlr #7, r1` /
  `cmp #1, r1`). When set, `menu_item_count(11)` returns 5 and item index 4 is
  drawn.
- It is localised too: `sub_FFF0A7B9` `case 4: draw(x, y, 0xFFF4AA3F, attr=0x0A00)`
  and `0xFFF4AA3F` is `52 41 4D 20 49 3D 3C 28 00` = `"RAM "` plus two 2-byte
  JIS X 0208 codes, `0x493D` (ku-ten 41-29) and `0x3C28` (ku-ten 28-8), which are
  the kanji 表 and 示 — *hyouji*, "display". Note that every other item in that
  function is drawn with attribute `0`; `RAM DISPLAY` alone is drawn with `0x0A00`.
- **The screen behind it exists and is gated by the same bit.** `sub_FFF0A86D`:

  ```c
  void ram_display_screen(void)
  {
      if ((*(uint8 *)0x8E4D >> 7) != 1) return;         /* same gate */
      uint8 page = *(uint8 *)0x8C4C;
      if (page > 3) { *(uint8 *)0x8C4C = 3; return; }
      ((void (**)(void))0xFFED75FC)[page]();
  }
  ```

  The four pages at `0xFFED75FC` are `FFF0A8A6`, `FFF0A8B8`, `FFF0A958`,
  `FFF0A9B9`. Page 1, `sub_FFF0A8B8`, loads a 3-entry pointer table at RAM
  `0x00069310`, dereferences each, and prints 5-digit decimal values in a loop —
  a RAM monitor. This is an engineering screen, not a user feature.

  (Note: `0xFFED75FC` is one of the "jump tables" the earlier pass dismissed. It
  was right that they are jump tables of code pointers — they sit past the end of
  the menu descriptor array at index 24 and above — but `0xFFED75FC` is not
  compiler switch-table noise, it is the RAM DISPLAY page table. `0xFFED75B8` is a
  17-slot table in which 15 slots hold the same address `0xFFEF2032` — a single
  byte `02`, i.e. a bare RX `rts`, the shared do-nothing stub — which is the
  signature of a mostly-unimplemented dispatch.)

- **How the bit gets set: not by a key combination.** Only four instructions in the
  whole recovered code touch `0x00008E4D` (`ida\out\menu\gate_writes.txt`):
  `FFEF4154` and `FFEF416E` in `sub_FFEF4142`, `FFF09602` (the count gate), and
  `FFF0A873` (the screen gate). Three are reads. The fourth, `FFEF416E`, is
  `mov.b 7[r15], 7[r14]` with `r15 = 0x8E46` and `r14 = 0x8C4D` — a whole-byte
  copy from the stored struct into the applied shadow. **Nothing sets bit 7.** The
  bit can therefore only arrive from outside, in a restored settings image. I did
  not find, and do not claim, any key sequence.

### 5. Where the settings live

Two parallel structs in RX64M on-chip SRAM, sized from the maximum displacement
observed against each base (`ida\out\menu\settings_fields2.tsv`):

| base | extent | refs | role |
| --- | --- | --- | --- |
| `0x00008E46` | `0x00008E46`–`0x00008F44` (~254 B) | 2093 | **stored settings** — the source of truth |
| `0x00008C4D` | `0x00008C4D`–`0x00008D4D` (~256 B) | 4306 | **applied shadow** — last value pushed to hardware |
| `0x00008C4C` | 1 byte | 403 | RAM DISPLAY page index |
| `0x00008F72` | `0x00008F72`–`0x00008F80` | 79 | language flag and neighbours |

`sub_FFEF4142` is the settings applier, called from 38 sites. For each field it
compares the stored value against the shadow, and on a difference calls a
per-field apply handler then copies the new value into the shadow — e.g. field +7
bit 0 differs → `sub_FFEEFEA4(1)` → `mov.b 7[r15], 7[r14]`. Byte `0x8E4D` is a
bitfield: bit 0 is a normal user setting with an apply handler, **bit 7 is the
RAM DISPLAY enable, and the copy takes the whole byte, so the hidden bit rides
along.** UI navigation state lives at the top of the shadow struct:
`0x8C6D` current category, `0x8C6E` scroll top, `0x8C6F` cursor row.

**The SUB image contains no non-volatile store driver.** Confirmed over the whole
4 MB with the corrected all-widths immediate scan and over all 1539 recovered
functions (`ida\out\menu\periph_census.tsv`, 970 peripheral operand sites):

| Store | Verdict |
| --- | --- |
| RX64M Flash FCU / FACI (`0x007E0000`–`0x007FFFFF`) | **Not found.** No register access. The SUB never programs its own flash. |
| E2 DataFlash (`0x00100000`–`0x0010FFFF`) | **Not found.** The 48 hits on `#100000h` are the arithmetic constant 1,048,576, used with `cmp` and `or`, not addresses. |
| RSPI (`0x000D0100`) | **Not found.** No SPI EEPROM or serial flash from SUB. |
| RIIC I²C (`0x00088300`) | **Not found.** |
| Standby RAM (`0x000A4000`–`0x000A5FFF`) | **Not found.** The structs are in ordinary SRAM. |
| SDHI (`0x0008AC00`) | **Present and fully driven** — `SDCMD +0x00`, `SDARG +0x08`, `SDSTOP +0x10`, `SDSECCNT +0x14`, `SDRSP10 +0x18`, `SDSTS1 +0x38`, `SDSTS2 +0x3C`, `SDIMSK1 +0x40`, `SDIMSK2 +0x44`, `SDCLKCR +0x48`, `SDSIZE +0x4C`, `SDOPT +0x50`, `SDBUFR +0x60`. The register offsets match the RX64M SDHI layout exactly. |
| SCI (`0x0008A000`, `0x0008A040`, `0x0008A060`) | **Three channels: SCI0, SCI2, SCI3.** SCI1 and SCI4–7 never touched. |

So the SD card is the *export* target, not the store: `I:\FT3D\BACKUP` and
`\Backup.bin` at `0xFFF4AD60` / `0xFFF4ADC1`, referenced from `FFF14178`, which is
the `SD CARD > BACKUP` menu path.

**Inferred** (stated as inference, for MAIN-IO to confirm): the non-volatile
configuration is owned by the **MAIN H8S**, and SUB receives its ~254-byte block
over one of SCI0/2/3. Supporting evidence, all from the MAIN image: the clone-file
headers `V0030FT3D` (`0x06C539`) and `V0020FT2D    JPN     Ver0202 20180418`
(`0x06C571`), the model table `FT1D`/`FT2D`/`FT3D` (`0x04C388`+), the destination
code table `USA JPN EXP` (`0x06BE26`), and the model code `APY03D` twice at
`0x04B182`/`0x04B18A`. A cloning or programming tool would target MAIN's store,
not SUB's SRAM — but it would set SUB's behaviour, including `0x8E4D` bit 7.

### 6. Hidden, service, test and factory modes

Written to **`ida\out\menu\hidden_modes.tsv`**. Confirmed items:

| Item | Status | Gate / entry |
| --- | --- | --- |
| `RAM DISPLAY` menu row | **confirmed present, confirmed gated** | bit 7 of `0x00008E4D`; read at `FFF09602` |
| `RAM DISPLAY` 4-page RAM monitor | **confirmed present, confirmed gated** | same bit, read at `FFF0A873`; dispatcher `sub_FFF0A86D`, pages at `0xFFED75FC` |
| `WX ALERT` row removal | **confirmed gated** | `*(uint8*)0x8C53 == 0`; read at `FFF09623` — a destination/market flag |
| `---DSP WRITE MODE----` | **confirmed present**, entry **not determined** | `sub_FFF0DE56` at `0xFFF0DE56`, strings `0xFFF4ACF8` `---DSP WRITE MODE----`, `0xFFF4AD0E` `Push DISP Key!`, `0xFFF4AD1D` `Loading...`, `0xFFF4AD28` `Complete`; sole caller `sub_FFF0D6D9` at `FFF0D709` |
| `PASSWORD INPUT` / `PASSWORD ENTRY` | confirmed, **documented feature** | `CONFIG` item 12, label `0xFFC3E3AD`; screen `sub_FFEE80A9`, strings `0xFFF48588` / `0xFFF48597` |
| Language gate | confirmed | `*(uint8*)0x8F72 == 1` → generic English table |

**I did not find any key-combination check that enters a service or alignment
mode, and I am not going to guess one.** There is no `ADJUST`, `ALIGN`, `CALIB`,
`SERVICE MODE`, `TEST MODE`, `FACTORY` or `DIAGNOSTIC` string anywhere in either
image (the only `SERVICE` hits are `LOCATION SERVICE`, a WIRES-X setting, and
`In Service`, an APRS status icon). If an alignment mode exists on this radio it is
either in MAIN, or reached through the same settings-bit mechanism as
`RAM DISPLAY`. The `DSP WRITE MODE` screen is the strongest service-mode artifact
in the SUB image and its entry path is the highest-value thing still open.

### 7. The string pools

Catalogued in **`ida\out\menu\string_pools.tsv`**. The two that matter:

- **`0xFFC3DD55` / `0xFFC3DF4D`** — the 20-byte English menu tables, described
  above. Only reachable through the descriptor array.
- **`0xFFF4A380`–`0xFFF4AA55`** — the **Japanese localised setup pool**, which the
  earlier pass saw as "display messages around file `0x34A800`". It is not a
  message pool; it is the per-category mirror of the English 20-byte table,
  consumed one string at a time by the 15 localised draw functions. Encoding:
  **JIS X 0201 half-width katakana** in `0xA1`–`0xDF`, Yaesu-extended pre-composed
  voiced forms in `0xE0`–`0xFF` (`0xEE` = ﾃﾞ, `0xF0` = ﾊﾞ, `0xF2` = ﾌﾞ, `0xE7` = ｼﾞ),
  and 2-byte JIS X 0208 kanji. Verified: `0xFFF4AA29` = `EE F0 B2 BD D8 BD C4` =
  ﾃﾞﾊﾞｲｽﾘｽﾄ = "DEVICE LIST"; `0xFFF4AA31` = `Bluetooth ` + `BE 2D F2` = ｾ-ﾌﾞ =
  "Save"; `0xFFF4A9CA` = `BA 2D D9 BB B2 DD` = ｺ-ﾙｻｲﾝ = "CALLSIGN".

Every `USB`-containing string in the image, resolved:

| Address | Bytes | What it is | Drawn from |
| --- | --- | --- | --- |
| `0xFFC3E709` | `"USB CAMERA"` | English label, OPTION item 1 of 4 | `sub_FFF0964A` generic path, `menu_table[11].labels[0]` |
| `0xFFF4AA16` | `"USB "` + `B6 D2 D7` | the same label in Japanese, `USB ｶﾒﾗ` | `sub_FFF0A7B9` `case 0`, loaded at `FFF0A7DB` |
| `0xFFF46677` | `75 53 62` | **not a string** — these are instruction bytes, RX `cmp #62h, r3`, inside recovered code | n/a |

The `USB` at `0xFFF4AA16` that the earlier pass flagged as a "delimited `USB`" is
simply the Japanese menu label. There is no USB status message, no USB connection
state, no USB error. `Connected` / `Not Connected` / `Connecting`
(`0xFFF4A4E6`/`F0`/`FE`) and `Searching` / `No Device` (`0xFFF4AB4A`/`54`) belong to
the **Bluetooth** pairing UI, whose module protocol is a plain ASCII AT-style
command set over a UART at `0xFFF4AE75`–`0xFFF4AF8F` (`SCAN=%d`, `LINK=%c`×12,
`PAIR=%c%c%c%c`, `PINF=0,%c`×12, `HELL%c`, `FIND=OVER`, `ERAT=`, `RXAT=`,
`ACK ERROR`). `FIRM ERROR` (`0xFFF4AB3F`, drawn from `FFF0BD49`) is an SD-card
firmware-file error, not a USB one. `EMERGENCY !!` / `EMERGENCY!` are APRS.

Also worth recording: the GPS is a **MediaTek MT333x-class module on a UART** —
`$PMTK313,1`, `$PMTK314,...`, `$PMTK225,0`, `$PMTK286,1`, `$PMTK330`, `$PMTK386`,
`$PMTK301` at `0xFFF483E8`–`0xFFF484A4`. And `MODEL CODE : APY03D` at `0xFFF4995F`,
drawn from `FFF05898`.

## USB relevance

1. **Everything USB.** `USB CAMERA` is a real, reachable, unconditional menu item
   with a working settings screen — but it has **nothing to do with the RX64M USB
   peripheral**. My independent scan, corrected to cover all four RX immediate
   widths over the whole 4 MB image, finds **zero** loads of any address in
   `0x000A0000`–`0x000A03FF`, while the same scan finds 885 peripheral sites
   elsewhere (SYSTEM, MSTPCR, ICU, DMAC, CMT, TPU, S12AD, three SCI channels,
   SDHI, I/O ports). That is a strong negative from real coverage rather than from
   11 % of the image. Only three "USB" byte sequences exist in the image and two of
   them are the same menu label in two languages. **For SUB-USB: `USB CAMERA` is
   a label-and-settings-screen only; there is no USB host stack behind it, and the
   camera accessory is on the radio's accessory jack, not the USB peripheral.**
2. **Is USB SDR possible?** Nothing here supports it. The SUB is the UI and
   storage processor: SDHI for the SD card, three UARTs (MAIN link, MediaTek GPS,
   Bluetooth module), S12AD, and a large graphics data region. No sample path, no
   USB engine in use.
3. **Can the DSP be reached?** Two concrete leads, both new. The SUB image contains
   a **`---DSP WRITE MODE----`** screen at `sub_FFF0DE56` (`0xFFF0DE56`) with
   `Push DISP Key!` / `Loading...` / `Complete`, reached from `sub_FFF0D6D9` — so a
   DSP firmware-write path exists in the shipped firmware, presumably loading from
   SD. The SUB also draws the DSP version (`DSP  Ver.  :  .    ` at `0xFFF48814`,
   from `FFF00EF0`) and has `DSP H` / `DSP A` / `DSP D` value strings at
   `0xFFF4A059`/`069`/`079`. The **MAIN** image carries the actual DSP protocol
   trace strings — `CPU>DSP: `, `DSP>CPU: `, `DSP POWER:ON & RESET!`,
   `CPU>DSP: RX ENABLE`, `CPU>DSP: MUTE ON`, `CPU>DSP: STOP ENCODE`,
   `CPU>DSP:VER?`, `DSP>CPU: ACK` / `NAK`, `DSP>CPU: TERM TX` / `TERM RX` at
   `0x05AE1C`–`0x05AF5E`. **MAIN owns the DSP link; SUB only displays its version
   and hosts the write-mode screen.** That is the single most valuable pointer I
   can hand to whoever is chasing mission question 3.

## Open

Most valuable first.

1. **The `DSP WRITE MODE` entry path.** Trace `sub_FFF0D6D9` (`0xFFF0D6D9`) and
   `sub_FFF0D6C4` upward from `FFF0CF42` / `FFF0CF6F`, and find what file it loads
   and over which link it pushes the image. This is the live end of mission
   question 3 and it is one job away.
2. **The MAIN side of the DSP link.** `0x05AE1C`–`0x05AF5E` in
   `FT3D_MAIN_ver102_EXP.bin` is a complete set of protocol trace strings. Find
   their references and the framing falls out. Hand to whoever owns MAIN.
3. **Confirm who persists the settings.** MAIN-IO should look for a serial EEPROM
   or FRAM driver on the H8S side and for the ~254-byte block that matches
   `0x00008E46`. If it is an external device, that is the cloning-tool target, and
   it is also how one would set `0x8E4D` bit 7 and unlock `RAM DISPLAY`.
4. **Re-run every earlier immediate scan with all four RX immediate widths.** The
   24-bit form (`FB xE`) carries every peripheral address in this firmware and a
   32-bit-only scan sees none of them. 2,545 sites were invisible to the earlier
   method. Any "not found" derived from a 32-bit-only immediate scan should be
   re-tested — mine included, in reverse: the USB0 negative now holds across all
   four widths.
5. **The 13-byte table at `0xFFC3DF35`.** Three loads (`FFEFE38A`, `FFF08A11`,
   `FFF08CA0`), values `05 07 05 06 09 05 02 07 06 04 07 06 08`. Read 1-based it
   tracks the category name lengths except for `SCAN` (5 vs 4). Decoding the three
   users would settle it; low value but it is the last unexplained object in the
   menu data.
6. **Sweep `0xFFC40000`–`0xFFEC0000` for the residual 0.04 % of code** that
   SUB-LOWER's region map reports. Almost certainly graphics helpers, but it is the
   last unswept code in the image.

### Tables

All under `ida/out/menu/`:

| File | Contents |
| --- | --- |
| `menu_records.tsv` | every menu slot: category, name, count, label pointer, item number, slot address, label, whether it is inside the count, raw 20 bytes |
| `menu_categories.tsv` | the 24 descriptor entries with their name, count, label array, localised draw function and item screen function |
| `hidden_modes.tsv` | the hidden, gated and service items with their gate addresses and evidence |
| `string_pools.tsv` | the 15 significant string pools with extent, encoding and purpose |
| `menu_xrefs.tsv` | cross-references to the tables, including the confirmed absence of any direct reference to `0xFFC3DF4D` |
| `periph_census.tsv` | 970 peripheral operand sites over the recovered code |
| `walker_funcs.txt`, `walker_callers.txt`, `walker_caller_funcs.txt` | the walker, the count function and the page renderer |
| `menu_module_disasm.txt` | full disassembly of `0xFFF08000`–`0xFFF0B400` |
| `category_handlers.txt` | the 15 localised per-category draw functions |
| `ramdisplay_funcs.txt` | the RAM DISPLAY dispatcher and its four pages |
| `gate_writes.txt` | every reference to the gate bytes, resolved through base+displacement |
| `settings_fields2.tsv` | 6908 resolved settings-struct field accesses |
| `decisive_funcs.txt`, `call_chains.txt` | the camera screen, DSP write mode, password screen, settings applier, and their call chains |
| `functions_menu.tsv` | 1539 functions after the sweep, up from the inherited 455 |

Job scripts: `ida\jobs\menu_walk.py`, `menu_dispatch.py`, `menu_module.py`,
`menu_gates.py`, `menu_final.py`. Database: `ida\db\jobs\MENU\MENU.i64`.
