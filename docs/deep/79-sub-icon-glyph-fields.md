# SUB icon, glyph and storage record field meanings (Lane J11)

Owner-side static analysis of `decrypted\FT3D_SUB_ver102_ALL.bin` (RX64M, little-endian,
mapped `0xFFC00000`, file offset = address − `0xFFC00000`). Private DB `J11_SUBICON`,
seeded `--copy-from ida\db\jobs\SUB_FINAL2\SUB_FINAL2.i64`; no shared DB was opened, no
image was modified, nothing was written to any device. Model: claude-opus-4-8.

Decoded tables and struct layouts are in `ida\out\sub-icon-glyph\`; raw consumer
disassembly in `ida\out\sub-icon-glyph\raw\`.

## Verdict

All three record families typed by I17 are decoded from the code that consumes them, and
every field role is proven or cleanly inferred. **(1) Icon records** (254 × 28 B,
`FFED55E0`) are UI-widget descriptors: `{u32 id, u16 x_off, u16 y_off, u32 kind, [12 B
runtime/overlay], u32 bmp_desc}`. The sole accessor `sub_FFEF34B1` copies a record into a
caller buffer; the renderer `sub_FFEF2505` draws it — adding `x_off`/`y_off` to the
widget's on-screen base rectangle, and on `kind==2` passing `bmp_desc` (+0x18) to the
RGB565 blit `sub_FFEF68D5`, on `kind==1` drawing a glyph. All 223 populated records carry
`kind=2` and a `bmp_desc` that lands inside the RGB565 descriptor table. **(2) Font block
records** (26 × 12 B, `FFED4644`) are `{u8 w, u8 h, u16 base_code, u32 ord_tbl, u32
pix_base}`, consumed by the 1-bpp glyph resolver `sub_FFEF2184` and width helper
`sub_FFEE5269` — confirming doc 27 byte-for-byte and extending its 8 blocks to 26. The
adjacent `glyph1_desc` (51 × 12 B) and `glyph_tbl8` (45 × 8 B) tables are a static
pre-resolved glyph descriptor set and a mode-indexed glyph-code map, the latter consumed by
`sub_FFEE59A4`/`sub_FFEE5A73`. **(3) Storage-driver records**: `FFED7F18`–`FFED7F60` is a
status/capability **mask table** ANDed against a driver handle field (`sub_FFF34897`), and
`FFED7F60`–`FFED819C` is 13 × 44 B **capacity/geometry parameter records** selected by a
size threshold (`sub_FFF362EF`). **None of the 11 consumer functions references USB0, USBA,
the FCU, or any RX peripheral I/O address** — this is pure UI/imaging and filesystem layout.

## Method

Three IDAPython jobs through the shared `run_job.py` on `J11_SUBICON` (seeded from
SUB_FINAL2, then `--reopen`). Each wraps its body in try/except, calls `auto_wait`, writes
UTF-8, ends with `qexit(0)`.

| Script | Role |
| --- | --- |
| `ida\jobs\j11_dump.py` | Full disassembly of 7 consumers + hexdump of the 6 tables → `raw\dump.txt` |
| `ida\jobs\j11_dump2.py` | Disassembly of the icon renderer `sub_FFEF2505` and storage callers → `raw\dump2.txt` |
| `ida\jobs\j11_scan.py` | `o_imm` references into each table (all functions) + peripheral-immediate check inside every consumer → `raw\scan.txt` |

Plain-Python (coverage-independent, over the image) parsed the record tables into the TSVs
below. **Scope.** Consumer disassembly and the peripheral check cover the named functions
in full. The reference scan is every `o_imm` operand in all 2,426 DB functions. I did not
walk the SD/MMC driver's vtable methods (reached through function pointers at handle+0x48/
+0x4C), so the per-field SD-geometry semantics of family (3) are Inferred from the record
shape and the selection code, not from the register writes.

## Findings

Little-endian. Byte evidence is in `raw\dump.txt` / `raw\dump2.txt` unless noted.

### 1. Icon records — 254 × 28 B, `FFED55E0`–`FFED71A8` (`icon_records.tsv`)

**Struct (Confirmed):**

```c
struct sub_icon_rec_t {   // 28 bytes
    uint32_t id;          // +0x00  record's own index (0 for an unused slot)
    uint16_t x_off;       // +0x04  x offset, added to the widget slot's base x
    uint16_t y_off;       // +0x06  y offset, added to the widget slot's base y
    uint32_t kind;        // +0x08  draw kind: 2 = bitmap, 1 = glyph (runtime), 0 = unused
    uint32_t rt0c;        // +0x0C  runtime/overlay (0 in flash)
    uint32_t rt10;        // +0x10  runtime/overlay; byte +0x13 = font-block selector (glyph kind)
    uint32_t rt14;        // +0x14  runtime/overlay; byte +0x14 = char code (glyph kind)
    uint32_t bmp_desc;    // +0x18  pointer to an RGB565 i17_bmp_desc_t (bitmap kind)
};
```

**The accessor — `sub_FFEF34B1`** (only `o_imm` reader of `FFED55E0`; `scan.txt`). It takes
`r1` = input/state buffer, `r2` = output buffer; reads `byte[r1+4]` as the record index,
`mul #1Ch` (×28), base `#stru_FFED55E0`, `smovf #1Ch` copies the 28-byte record into the
output (`FFEF34BF`–`FFEF34CF`). It then patches the output per the display-state byte at
`[0x8C4D]`: e.g. `mov.w #…,4[r2]` (x_off), `mov.w #…,6[r2]` (y_off), `mov.l
#stru_FFED0C3C,18h[r2]` (bmp_desc, e.g. `FFEF3540`), and for glyph mode `mov.b #1,8[r2]`
(kind=1), `mov.b #12h,13h[r2]`, `mov.b #4,14h[r2]` (`FFEF36A2`–`FFEF36AC`).

**The renderer — `sub_FFEF2505`** (~90 callers; it is the central "draw widget N" entry).
After calling `sub_FFEF34B1` at `FFEF25D2` it dispatches on `kind` (`byte rec+8`, read at
`FFEF25D5`):

- **kind==2 (bitmap):** `FFEF267A`–`FFEF2690`:
  `r2 = layout.y + rec+6` (`add var_22`), `r1 = layout.x + rec+4` (`add var_24`),
  `r4 = rec+0x18` (`mov.l var_10,r4`), `r3 = 1`, `bsr sub_FFEF68D5`.
  This **proves `+4 = x offset`, `+6 = y offset`, `+0x18 = bitmap descriptor pointer`**
  (`sub_FFEF68D5` → `sub_FFEF0648` is doc 16's RGB565 blit).
- **kind==1 (glyph):** `FFEF25E0`–`FFEF2603`: same x/y add, then
  `r3 = rec+0x13` (font selector), `r4 = rec+0x14` (char code), `bsr sub_FFEF1B23`
  (doc 27's single-byte glyph blit). So for the glyph variant the three "zero words"
  (+0xC/+0x10/+0x14) carry `{font_selector@+0x13, char_code@+0x14}`.

`layout.x`/`layout.y` come from a RAM per-slot rectangle at `[0x68868 + slot*4] + id*8`
(`FFEF2544`–`FFEF2558`); i.e. the record's `x_off`/`y_off` are **relative** to a slot
rectangle, not absolute. In flash all 223 populated records are `kind=2` with a `bmp_desc`
inside `FFECE55C`–`FFED3F6C` (verified over all 254). 30 slots are unused (`kind=0`);
one slot at the `FFED57B8` zero-gap reads as a stray value (non-record padding).

**Correction to I17 / doc 16.** I17's `i17_icon_rec_t` named `f04/f06/f08` and "three zero
words". The roles are now: `f04=x_off`, `f06=y_off`, `f08=kind` (not "=2" by definition —
it is a selector, 2 in flash), and the three words are runtime/overlay fields whose glyph
sub-use is `+0x13` (font selector) and `+0x14` (char code).

### 2. Font block + glyph records (`font_blocks.tsv`, `glyph1_desc.tsv`, `glyph_tbl8.tsv`)

**Font block table — 26 × 12 B, `FFED4644`–`FFED477C` (Confirmed):**

```c
struct font_block_t {    // 12 bytes
    uint8_t  w;          // +0x00  glyph cell width  (px)
    uint8_t  h;          // +0x01  glyph cell height (px)
    uint16_t base_code;  // +0x02  JIS code of the block's first glyph
    uint32_t ord_tbl;    // +0x04  code->ordinal table: u16[code - base_code]
    uint32_t pix_base;   // +0x08  1-bpp pixel base
};
```

Resolver **`sub_FFEF2184`** (`FFEF21BA`–`FFEF2245`): block stride `mul #0Ch`, base
`#stru_FFED4644`; blocks 0–7 auto-selected by code range (`cmp 2[r14].uw` on `base_code`),
blocks 8–25 selected directly by the `selector` arg. For the chosen block:
`out.w = sub_FFEE5269(block,code)`; `out.h = byte[block+1]`; `ordinal =
u16[ord_tbl + (code − base_code)]`; `out.src = pix_base + ordinal·h·ceil(w/8)` — `div #8`
proves 1 bpp. Width helper **`sub_FFEE5269`**: block 25 (`0x19`) is the variable-width ASCII
font — glyphs in the set `"MWXYmwx*@\"` get width 5, else `byte[block+0]`.

**Correction to doc 27:** the table has **26 blocks, not 8** (bound is `cmp #1Ah` in
`sub_FFEF2184`). Blocks 0–7 are the kanji/katakana/symbol set (14×14, `base_code`
`0x2121`/`0x5021`/`0x9321`…), block 8 duplicates block 2, blocks 9–25 are the ASCII/symbol
fonts (`base_code 0x0020`) from 14×27 down to 4×7. Full list in `font_blocks.tsv`.

**glyph1_desc — 51 × 12 B, `FFED477C`–`FFED49E0`:** `{u16 w, u16 h, u32 src, u32 flag}`.
This is **exactly the output layout `sub_FFEF2184` emits** (`mov.w r1,[r6]` w; `2[r2]` h;
`4[r1]` src; `8[r1]=0`). `src` points into the low 1-bpp store (`FFC362AC`…), `flag` is 0
except a couple of entries (=1). **Reader: Not found** by `o_imm` over all functions (scope:
all 2,426 DB functions) — matching I17. Inferred: a static set of **pre-resolved small
symbol/tiny-font glyph descriptors** consumed by the glyph pixel-copy stage via a computed
base, not a bare immediate.

**glyph_tbl8 — 45 × 8 B, `FFED49E0`–`FFED4B48`:** `{u16 base_code, u16 rsvd(=0), u32 map}`.
Consumer **`sub_FFEE59A4`** (and `sub_FFEE5A73`): record index = display-state byte
`[0x8C4E]` clamped to ≤ `0x2C` (44 → 45 records); reads **`+4 = map`** only, then indexes
`map + state2·0x50 + col·0x10 + row·2` and reads a **u16 glyph code** (`FFEE59CA`–
`FFEE5A24`) which it passes to `sub_FFEF190D` (kanji blit) and `sub_FFEF04F7` (RGB565
blit) — this is the large multi-cell character display. `base_code` (+0, ascending JIS
codes `0x2422`…) identifies the block (Inferred; not read by `sub_FFEE59A4`); `+2` is always
0. Note: `map` points above `FFC362AC` into a region doc 27 loosely called the "1-bpp pixel
store"; here it is read as a **code map** (u16 codes), so that region holds both glyph
pixels and these mode→code tables.

### 3. Storage-driver records — `FFED7F18`–`FFED819C` (`storage_mode_records.tsv`)

**Mask table — `FFED7F18`–`FFED7F60` (72 B, u32[18]):** status/capability bit masks.
Consumer **`sub_FFF34897`** (`FFF34923`–`FFF34938`): `idx = u16[handle+0x2C6]`;
`mask = *(u32*)(FFED7F18 + idx)`; `if (handle[0x2B0] & mask) return −0x17` (busy/EACCES).
Before that it calls two driver vtable methods — `(*(handle->drv+0x48))(7,0,0)` and
`(*(handle->drv+0x4C))(1)` — and returns `−9` on failure, retried 3×. Classic SD/MMC
command/status path. 20 `o_imm` reads of this region across `sub_FFF336xx`, `sub_FFF345F3`,
`sub_FFF34897`, `sub_FFF34C83` (`scan.txt`).

**Capacity/geometry records — `FFED7F60`–`FFED819C`, 13 × 44 B (u32[11]):** selected by a
size threshold. Consumer **`sub_FFF362EF`** (`FFF362F7`–`FFF3631D`):
`if (value <= 0x7DFFFF) rec = FFED7F60; else rec = FFED7F60 + 0x2C;`
`memcpy(out, rec, 0x2C)` (`sub_FFF2E478`, size `#2Ch`). The `#2Ch` proves the **44-byte
stride**; `0x7DFFFF` (8,257,535) is a capacity tier boundary (SDSC/SDHC-class split,
Inferred). Records 2–12 are read field-by-field by `sub_FFF36327` (11 reads of record 2 at
`FFED7FB8`). Field 0 scales with the tier (`0x0080003F`, `0x00FF003F`, then `0x0002xxxx`…
`0x0080xxxx`), field 7 = 1 for records 2–12; these are device geometry/format parameters.
Exact SD semantics per field are Inferred (the vtable methods were not walked).

## USB relevance

**Confirmed none.** The peripheral-immediate check (`scan.txt`) over all 11 consumer
functions (`sub_FFEF34B1`, `sub_FFEF2505`, `sub_FFEE59A4`, `sub_FFEF2184`, `sub_FFEE5269`,
`sub_FFF34897`, `sub_FFF362EF`, `sub_FFF3466C`, `sub_FFF35347`, `sub_FFF35683`,
`sub_FFF369F2`) finds **zero** immediates in USB0 (`0xA0000`–`0xA0400`), USBA
(`0xD0000`–`0xD0200`), the FCU (`0x7E0000`–`0x800000`), or RX peripheral I/O
(`0x80000`–`0xFFFFF`). Families (1) and (2) are UI/imaging layout drawn to the external LCD
(doc 16's blit chain); family (3) is a filesystem/SD driver that reaches its hardware
through a vtable of function pointers, not from these tables. Nothing here is a USB, DSP,
or flash-write path. Mission answers 1/2/3 are unchanged; this closes I17 Open 3 (icon
`f04/f06/f08`, storage mode records, 1-bpp glyph descriptors).

## Open

Most valuable first.

1. **SD/MMC driver vtable** (`handle->drv+0x48/+0x4C`, errors −9/−0x17). Resolving the
   function pointers would name the storage peripheral (SDHI vs RSPI/SPI) and give exact
   semantics to the 13 geometry records and the 18-entry mask table. This is the one live
   thread for "what bus the filesystem uses".
2. **`glyph1_desc` consumer.** No bare immediate reads `FFED477C`; the computed base that
   walks these 51 pre-resolved descriptors is not pinned (likely inside the glyph
   pixel-copy stage `sub_FFEF190D`/`sub_FFEF1B23`).
3. **`glyph_tbl8` secondary reader `sub_FFEE5A73`** and the exact `[0x8C4E]`→record mapping
   (what display the 45-entry mode map drives — clock/callsign/large readout).
4. **Icon RAM slot table** at `0x68868` (per-slot base rectangles, `[base]+id*8`): confirm
   the `{x,y,w,h}` rectangle layout and who populates it.
