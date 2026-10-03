# SUB (RX64M) upper region and the bitmap catalogue

Agent SUB-UPPER. Region above SUB-LOWER's boundary: mapped `0xFFE80000`–
`0x100000000` (file `0x280000`–`0x400000`), plus whole-image work where noted.
Private database `SUB_UPPER`, seeded `--copy-from ida\db\radio\SUB.i64`. Tables,
disassembly and renders under `ida/out/sub-upper/`; job scripts
`ida\jobs\subupper_probe.py`, `subupper_scan.py`, `subupper_blit.py`.

## Verdict

**The bitmap catalogue is fully recovered, and the open item's premise was wrong
in a useful way.** The 2.23 MB of RGB565 has no RAM-built index because it does
not need one: it is indexed by a **static descriptor table in flash at
`0xFFECE55C`–`0xFFED3F6C` (file `0x2CE55C`–`0x2D3F6C`), 1441 records of 16 bytes**,
each `{u16 width, u16 height, u32 src_ptr, u16 transparent_key, u16 tint_rgb565,
u16 mode}`. The 1255 distinct `src_ptr` values **tile the pixel blob
`0xFFC3EB80`–`0xFFEB74D8` (2,591,064 bytes) contiguously, with zero gaps and zero
overlaps** — a 100.0% partition, so this one table is the complete map of every
stored image. The earlier "no pointer, no index, no offset table" was correct
about 32-bit *pointer arrays*: SUB-LOWER's scan looked for stride-4 dword runs,
but the pointers sit at `+4` inside 16-byte records, i.e. a 16-byte pointer
stride, so a stride-4 test could not see them. The blob also runs 0x17490 bytes
past SUB-LOWER's `0xFFE80000` cutoff, so **~223 KB of my region
(`0xFFE80000`–`0xFFEB74D8`) is more atlas bitmaps, not code.**

I rendered the images (`catalogue_montage.png`, `catalogue_large_images.png`):
they are exactly a radio UI sprite atlas — the **"YAESU" boot splash** (252×26),
a full **font** in white/grey/red at several sizes, mode/status labels (**DN**,
**CLONE**, **NORMAL**, **REV**, **TX/RX** with antenna waves), **band-scope /
meter arc** animation frames (80×80), a rotary **knob**, GPS/compass arrows,
colored LED spheres and icons. The draw path is decoded end to end: a draw site
loads a descriptor address and calls `sub_FFEF68D5`→`sub_FFEF0648`, which
composites the RGB565 source into a **320-wide RAM framebuffer** (stride `0x140`,
base `[[0x0001D3C8]+0xC]`) with color-key transparency, tint and alpha, and
EXDMAC channel 0 (`sub_FFEF1F90`) flushes it to an **external LCD at
`0x06000000`** on chip-select CS1. That chain "yields every screen the radio can
draw."

**The USB and self-write verdicts do not move.** I reproduced the 3806-function
recovery independently and re-ran both tests on it. A whole-image scan of the RX
`MOV.L #imm` encodings (13,559 sites) finds **0** immediates in USB0
`0x000A0000`–`0x000A0400`, in the 8 KB either side, or in USBA `0x000D0000`+; a
constant-propagating scan over all 3806 functions / 153,500 instructions
(resolving `#imm`, `[rN]` and `disp[rN]`) finds **0** effective addresses in USB0,
USBA, the flash sequencer (FCU `0x007E0000`–`0x00800000`), `FWEPROR` `0x0008C289`
or `FENTRYR` `0x007FFFB2`. USB0 is dark and neither flash self-programs, now
confirmed on my own coverage as well as by the whole-image byte scan. Nothing in
the newly-mapped upper region is a peripheral, a USB path, or a flash-write path.

## Method

Workspace root is physically the repository root; paths below use the
project's `./...` convention. `run_job.py`'s `ROOT` constant still points at
the pre-move the repository root, so I ran every IDA job through a private, unmodified copy
of the launcher with `ROOT` corrected (scratchpad); the shared launcher and all
shared databases were left untouched. `ida\db\radio\SUB.i64` and
`ida\db\FT3D_*.i64` were only *copied from*, never opened. Nothing was written to
a radio.

| Pass | Script | What it did |
| --- | --- | --- |
| 1 | `subupper_probe.py` | Seed from `SUB.i64`; reclass RES/DENSE/PAD CODE; vector-table closure (INTB 256 + EXTB 32) + BFS; sweep (peripheral base-load seeds, pointer-table seeds, prologue sweep, xref closure). 455→3806 functions. `functions.tsv`, `coverage.txt`. |
| 2 | `subupper_scan.py` | Constant-prop peripheral retest (USB0/USBA/FCU/FWEPROR/FENTRYR) over all 3806 functions; bitmap-accessor discovery (descriptor-immediate draw sites → common callee); EXDMAC display-path dump. `usb_flash_retest.txt`, `bitmap_accessor.txt`, `display_path.txt`. |
| 3 | `subupper_blit.py` | Full disassembly of the blit chain `sub_FFEF0648` / `sub_FFEF04F7` / `sub_FFEF68D5` and the EXDMAC setters; constant list per blit function. `blit_chain.txt`, `blit_consts.txt`. |

Plain-Python work over `decrypted\FT3D_SUB_ver102_ALL.bin` (coverage-independent,
all 4,194,304 bytes): the `MOV.L #imm,Rd` encoding scan (`FB`, byte2 low nibble
`0x02`=32-bit / `0x0E`=24-bit), the descriptor-table discovery and tiling proof,
and the RGB565 rendering (PIL). Scripts kept as `parse_catalogue.py` in the out
dir.

My recovery reproduced SUB-VEC's numbers exactly (455→876 via the vector closure,
then 3806; 155,086 code bytes in `0xFFED0000`–`0xFFFFFF80`), which is the expected
result of the same seeds on the same image and gives me an independent database to
test against rather than relying on theirs.

**Scope covered.** Whole-image immediate scan: all 4 MB, every byte offset.
Constant-prop peripheral/accessor scans: all 3806 recovered functions. Catalogue
tiling proof: byte-exact over the full table and the full pixel blob. **Scope not
covered.** A register base loaded from RAM or a pointer table at run time evades
both the immediate scan and the intra-function constant-prop, same caveat SUB-VEC
stated; I found no such pattern touching USB0 or the FCU. Instruction coverage of
the code window is ~30%, so claims about code *outside* recovered functions rest
on the byte-level encoding scan, which is not coverage-limited.

## Findings

### 1. Segment layout of the SUB image (from the shared DB)

`probe_status.txt`. `ROM 0xFFC00000-0xFFC40000`, `RES 0xFFC40000-0xFFEE0000`,
`DENSE 0xFFEE0000-0xFFF50000`, `PAD 0xFFF50000-0xFFFFFF80`, `VECT` to end. The
RES ("resource") segment therefore runs to `0xFFEE0000`, 0x60000 past SUB-LOWER's
`0xFFE80000` boundary — that tail is mine and is where the descriptor table and
the last atlas bitmaps live. Real code is `0xFFED0000`–`0xFFF50000`; INTB sits at
`0xFFED8A70`, inside RES.

### 2. The bitmap descriptor table — `bitmap_catalogue.tsv`

**Confirmed.** Table base `0xFFECE55C` (file `0x2CE55C`), 1441 records × 16 bytes,
end `0xFFED3F6C`. Record layout, verified against the blit's field reads (§4):

| Offset | Field | Notes |
| --- | --- | --- |
| `+0` u16 | width | 6…252 px |
| `+2` u16 | height | 11…98 px |
| `+4` u32 | `src_ptr` | absolute pointer into the RGB565 blob |
| `+8` u16 | `transparent_key` | RGB565 colour treated as transparent (usually `0x0000`) |
| `+0xA` u16 | `tint_rgb565` | draw colour: `0xFFFF` white (1253), `0x7BEF` grey (170), `0xF800` red (6), a few others |
| `+0xC` u16 | `mode` | `0` keyed copy (1249), `1` tint+alpha (188), `2` invert/highlight (4) |

First record (`0xFFECE55C`): `1C 00 14 00 80 EB C3 FF 00 00 FF FF 00 00 00 00`
= 28×20 at `src_ptr=0xFFC3EB80`, key 0, white, mode 0.

**Tiling proof (Confirmed, byte-exact).** The 1255 distinct `src_ptr` values, each
with span `[src_ptr, src_ptr + width*height*2)`, merge into **one** interval
`0xFFC3EB80`–`0xFFEB74D8` = 2,591,064 bytes, **no gaps, no overlaps**. 2 bytes per
pixel is not assumed: it is what makes the packing exact — 1206/1394 adjacent
records satisfy `src_ptr[i] + w*h*2 == src_ptr[i+1]` and the rest are the duplicate
`src_ptr` of colour/mode variants. This is the addressing mechanism SUB-LOWER
could not find; the pointers were invisible to a stride-4 dword scan because they
are 16 bytes apart. No other descriptor table of ≥6 records exists anywhere in the
image (whole-file scan).

### 3. What the images are — `catalogue_montage.png`, `catalogue_large_images.png`

**Confirmed by rendering** (RGB565 little-endian, row-major, width×height). 1255
distinct images, 163 distinct sizes. Size histogram (distinct images): 12×18 ×150
(the primary font), 16×24 ×73, 106×29 ×65 (labels/banners), 6×15 ×63, 12×30 ×62,
30×30 ×51, 43×39 ×49, 20×30 ×47, 40×40 ×33, 48×24 ×32, 80×19 ×28, 106×60 ×24,
80×80 ×16, up to 96×98 and 252×26. Identified content:

- `#381` **"YAESU"** 252×26 at `0xFFC749AC` — boot splash.
- `#595` rotary **knob** 96×98 at `0xFFCBF9EA`.
- `#988`–`#990`, `#1188`–`#1190` 80×80 — **band-scope / meter arc** frames (the
  arc sweeps between frames; an animation set).
- `#1408` **TX/RX** 106×60 with antenna waves.
- `#0` "DN" red, `#384` "CLONE", `#640` "REV", `#672` "NORMAL", `#928` "F/MW" —
  mode and status labels.
- Full alphanumeric **font**: white glyphs (`tint 0xFFFF`, mode 0), a greyed
  "disabled" set (`tint 0x7BEF`, mode 1 — e.g. the grey digits `#1312/#1344/#1376`),
  red digits (`tint 0xF800`). GPS/compass arrows (`#1152`, `#1216`), LED spheres
  (`#1248` green, `#1440` blue), play/refresh icons.

Screens are **composited from these sprites** — there is no single full-screen
image; the widest sprite (252 px) confirms a canvas wider than 160 (see §4). The
atlas is therefore the static inventory of every drawable UI element, and the
per-screen layout is decided by the drawing code, not stored as whole frames.

### 4. The draw path — `bitmap_accessor.txt`, `blit_chain.txt`, `display_path.txt`

**Confirmed.** Draw sites reference a specific image by loading its descriptor
address as an immediate and passing (x, y, mode, descriptor) to a common blit:

```
FFEE2C49  mov.l #unk_FFED217C, r4     ; descriptor for image rec 962
FFEE2C4F  mov.l #1, r3                ; mode
FFEE2C51  bsr.a sub_FFEF68D5          ; draw
```

442 such draw sites in the recovered code reference 199 distinct descriptors; the
whole-image immediate scan finds 632 loads of 297 distinct descriptor addresses,
all exactly on 16-byte record boundaries. The dominant callees are `sub_FFEF68D5`
(×176, a wrapper that reads `+0`/`+2` for w/h and dispatches) and `sub_FFEF0648`
(×168, the blit itself). Font glyphs and digit runs are the ~958 records without a
direct immediate — they are reached as `base + code*16` into contiguous same-size
runs, which is why only ~300 descriptors carry a direct pointer.

`sub_FFEF0648` (769 bytes) reads `w=[desc+0]`, `h=[desc+2]`, `key=[desc+8]`,
`tint=[desc+0xA]`, `mode=[desc+0xC]`, `src=[desc+4]`; fetches the framebuffer base
from the display context `[[0x0001D3C8]+0xC]`; and writes each pixel to
`fb + ((y+row)*0x140 + x+col)*2`. `0x140` = **320** is the framebuffer row stride
(repeated `mul #140h`), with a height clip at `0xF0` = **240**, i.e. a 320×240
canvas — consistent with the 252-px-wide splash. Three modes: mode 0 copies
non-key source pixels (color-key transparency); mode 1 decomposes tint into R/G/B
and alpha-blends per-pixel via a 0–100 `mul #64h / div #64h` percentage (the
grey/white glyph variants); mode 2 inverts (`not`) for highlight.

The framebuffer is pushed to the panel by EXDMAC channel 0 (base `0x00082800`):

```
FFEF1F90  mov.l #82800h, r14
FFEF1F95  mov.l #6000000h, 4[r14]     ; EDMDAR = 0x06000000  (external LCD, CS1)
FFEF1F9E  movu.w 6[r1], r2            ; width
FFEF1FA0  mul   8[r1].uw, r2          ; * height  -> transfer length
```

`sub_FFEF1F74`/`sub_FFEF1F80` set `EDMSAR` (`[0x00082800]`) — the source — from a
register, and `sub_FFEF1FEB` sets `EDMCRA` `[0x0008280C]` (count). So the pixel
address is computed, never an immediate, which is the other half of why SUB-LOWER
saw no pointer. `sub_FFEF04F7` is the sibling path writing base `0x07000000`
(a second external-bus surface). This matches SUB-VEC's external-bus map: the
display is a memory-mapped LCD on CS1/CS2, not an on-chip controller.

### 5. Adjacent tables in the RES tail

**Confirmed** (byte inspection). Between the bitmap blob end (`0xFFEB74D8`) and the
descriptor table (`0xFFECE55C`) are small UI layout tables: sequential u16 index
runs (`0xFFEB8000`: `A7 00 A8 00 … BB 00 FF FF`, an `0xFFFF`-terminated list) and
6-/8-byte coordinate records (`0xFFEC6220`: `{u16 index, u16 x, u16 flag}` with x
ascending 0x30,0x46,0x5C,… — character or field positions). These are the
placement data the drawing code uses to lay sprites onto the 320×240 canvas. Not
exhaustively catalogued; they are layout, not new peripherals.

### 6. USB0 and self-write, re-tested on my coverage — `usb_flash_retest.txt`

**Confirmed / Not found (scope: all 4 MB for the byte scan; all 3806 functions for
the constant-prop).**

- Whole-image `MOV.L #imm` scan, 13,559 sites: **0** into USB0 `0x000A0000`–
  `0x000A0400`, **0** into the widened `0x0009E000`–`0x000A2000`, **0** into USBA
  `0x000D0000`–`0x000D0200`.
- Constant-prop over 3806 functions / 153,500 instructions, resolving `#imm`,
  `[rN]` and `disp[rN]` (RX displacement read from `op.value`): **0** effective
  addresses in USB0, USBA, FCU `0x007E0000`–`0x00800000`, `FWEPROR` `0x0008C289`
  or `FENTRYR` `0x007FFFB2`.
- The only two `MOV.L #imm` hits in the whole flash-control window are coincidences
  — `0x007EFFED` decoded inside the INTB table data at `0xFFED8A50`, and
  `0x007EFB21` inside JPEG constant code at `0xFFF4C806`; neither is at a real
  instruction that addresses the FCU.

This independently reproduces SUB-USB's and SUB-VEC's closed negatives. The newly
mapped upper region adds no USB byte and no flash-write byte.

## USB relevance

**Question 1 (everything USB).** Nothing. The upper region I recovered is display
resources (2.59 MB atlas + its descriptor and layout tables) and the draw/blit/DMA
code that renders them to an external LCD; none of it touches USB0, USBA or any
serial-to-host path. USB0 dark is re-confirmed two independent ways on my own
database.

**Question 2 (USB SDR).** No new sample source or transport. The one architectural
note worth recording is that the display already drives **EXDMAC channel 0** as a
high-rate block-mover from memory to an external-bus device at `0x06000000` — the
DMA engine and an external memory-mapped sink exist and are in constant use, so if
a USB device controller were ever provisioned, a DMA fabric to feed it is present.
That does not change the verdict: link 3 (a USB device engine) is still absent and
clock-gated, per the module-stop evidence others closed. The 2.59 MB of pictures
also reframes "spare capacity": ~62% of the 4 MB SUB flash is the image atlas.

**Question 3 (DSP/vocoder).** Not here. The external-bus surfaces at `0x06000000`
and `0x07000000` that SUB-VEC flagged as the DSP/`RAM DISPLAY` candidate are, on
this evidence, the **LCD panel** (the blit writes pixel data there, sized w×h from
image descriptors). That likely resolves SUB-VEC's open item #1 in favour of
"CS1 is the display", and makes the remaining DSP candidates the two non-GPS SCI
channels, as SUB-LOWER concluded.

## Open

Most valuable first.

1. **`RAM DISPLAY` (`0xFFC3E759`) vs the LCD path.** SUB-VEC guessed CS1 might be
   `RAM DISPLAY`; I show CS1 is the framebuffer sink. The `RAM DISPLAY` menu
   feature (MENU's loose end) is most likely a debug mode that renders raw RAM to
   this same LCD — worth checking whether a draw site points the blit `src` at a
   RAM address instead of a flash descriptor.
2. **Confirm the panel controller part.** The canvas is 320×240, output over an
   8/16-bit external bus at `0x06000000` (CS1, 2-wait) and `0x07000000`. Reading
   the init writes to those windows (the command/data split) would name the LCD
   controller and confirm bus width.
3. **The layout tables in `0xFFEB74D8`–`0xFFECE55C`.** I identified their shapes
   (index lists, coordinate records) but did not fully catalogue them; they encode
   the per-screen sprite placement and would let a future pass reconstruct exact
   screen compositions rather than just the sprite inventory.
4. **Font indexing.** The ~958 descriptors without a direct immediate are indexed
   `base + code*16`; finding the few base loads would map character code → glyph
   and confirm the character set.
5. **`0x07000000` second surface.** `sub_FFEF04F7` writes it; determine whether it
   is a second panel, an overlay plane, or the same panel's data port.
