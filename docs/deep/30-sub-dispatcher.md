# sub_FFF4C9D1 — SUB image decoder: YCbCr→RGB565 MCU output stage (Lane F3)

Target: `sub_FFF4C9D1`, `0xFFF4C9D1`–`0xFFF4F1B3` (10,210 bytes), the largest
body-validated function in the SUB code window. Owner-side static analysis only;
no device, no image modified, nothing written to a radio. Database `FIN_SUB_DISP`
(a private copy of `ida\db\jobs\SUB_WINDOW\SUB_WINDOW.i64`). Processor RX64M,
little-endian, mapped at `0xFFC00000`. No Hex-Rays for RX — C below is hand-written
from the disassembly.

Deliverable files:
- Full listing (wrapper + body): `ida\out\sub-big\fff4c9d1.lst` (4,337 lines)
- Resolved dispatch ladder: `ida\out\sub-big\fff4c9d1-table.tsv`
- Supporting: `fff4c9d1-analysis.txt`, `fff4c9d1-callees.lst`, `caller.lst`,
  `handler_table.tsv`, `blocks.txt` (same dir)

## Verdict

**`sub_FFF4C9D1` is the per-MCU color-conversion + chroma-upsampling + framebuffer
-write stage of the SUB's image-file decoder — the routine that turns decoded
YCbCr blocks into RGB565 pixels on the 320×240 LCD.** It is the output callback of
the on-radio **photo viewer** that displays image files from the microSD `I:\PHOTO`
folder. Confirmed by four independent lines of evidence:

1. The four multiply constants in the inner loop are the exact JFIF / ITU-R BT.601
   **YCbCr→RGB** coefficients (`mul #1670Ch`=1.410·Cr, `mul #1C5E7h`=1.773·Cb,
   `mul #0B6E3h`=0.714·Cr, `mul #5827h`=0.344·Cb), with the `add #-80h` (−128)
   chroma bias and `shar #10h` (>>16) fixed-point normalize.
2. Results are packed into **RGB565** (`and #0F800h` red, `and #7E0h` green,
   `shlr #3` blue) and stored 16-bit to a **windowed framebuffer** addressed as
   `base + (y−originY)·stride + (x−originX)` (`FFF4CACD`–`FFF4CAE6`).
3. The setup routine `sub_FFEDE804` wires a decoder context whose output buffer is
   `0x070BB800`, length `0x25800` = **153,600 = 320×240×2** (QVGA RGB565), and
   stores `&sub_FFF4C9D1` as a **callback function pointer** in that context.
4. The entry `sub_FFF3CAD0` builds an `I:\PHOTO\…` path (string pool has
   `I:\PHOTO` @`FFF4AD9A`, `I:\` @`FFF4AFF3`, `\` @`FFF4B003`), opens the file,
   decodes it via the engine, reads the image width/height, scales/centres it and
   blits it to the screen.

It is **not** a jump-table dispatcher. `get_switch_info` returns nothing, there are
**zero register-indirect jumps**, and the 10,210-byte body is 4,286 instructions
with **0 data items** — no embedded table exists. "Dispatch" is a three-level
`cmp`/branch ladder selecting pixel geometry by component count and chroma sampling
factor. The routine touches **no peripheral, no USB, no DSP, no flash-write** — it
is pure image math over its argument structures and stack.

This also corrects the Wave-2 coarse label (`sub-purpose-5.tsv`): "wrapper/glue"
is wrong, and `ram:B6E3,F800,1670C,1C5E7` is a misread — those are **immediate
operands** (three YCbCr coefficients and the RGB565 red mask), not RAM addresses.
The function references no global RAM at all.

## Method

What I ran (all via `run_job.py`, private DB `FIN_SUB_DISP`, seeded `--copy-from`
`SUB_WINDOW.i64`; scripts in `ida\jobs\`):

| Script | Produced |
| --- | --- |
| `fin_sub_disp_dump.py` | full item-by-item listing of `FFF4C97E`–`FFF4F1B3`; switch-info probe; call/data-ref/immediate harvest (24-bit aware); back-branch (loop) list; callee listings. |
| `fin_sub_disp_tab.py` | resolved the `FFEDE824` xref (it is code, not a pointer table) and proved the `FFF4C9D1` address occurs once in the image. |
| `fin_sub_disp_caller.py` | disassembled the setup/caller `sub_FFEDE804` and its two callers `sub_FFEDE523`, `sub_FFF3CAD0`. |
| `parse_lst.py` (plain Python, scratch) | reconstructed basic blocks + branch graph; isolated the dispatch ladder and hub in-degrees. |

Scope covered: all 10,210 bytes decoded and classified (4,286 code heads, 0 data,
0 undefined — the body is pure code). All call targets, loops, discriminants and
the RGB565 math resolved. The caller chain was walked two levels up and the string
pool checked for the subsystem. **Not done:** I did not disassemble the decode
engine `sub_FFF4B06C` itself (marker/Huffman/IDCT parsing — out of target scope),
and I did not fully reconcile the per-channel saturation idiom (see Open).

Per the RX trap (BRIEF §4): every address/constant here uses the short immediate
forms; `o_displ` displacements were read from `op.value`. The four coefficients are
`mul #imm` immediates, which is why a RAM-address classifier mislabeled them.

## Structure (the dispatch resolved)

Entry `sub_FFF4C9D1` (`6e 6d` `pushm r6-r13`; `72 00 1c ff` `add #-0E4h,sp` → a
228-byte frame; total epilogue `rtsd #104h,r6-r13`). CC-RX ABI, four pointer args:

| Arg | Reg→save | Role (confirmed field uses) |
| --- | --- | --- |
| arg1 | R1→var_4 | decoder context. `[0x10]` int (abs'd, bound-checked); `[0x42]` byte = **sampling/upsample selector** (L1 key) |
| arg2 | R2→var_24 | frame/component descriptor. `[0x00]` u16 width; `[0x04]` u8 **component count** (L2 key: 1/2/3); `[0x08..]` h/v sampling-factor bytes |
| arg3 | R3→var_8 | output window/canvas. `[0x0C]` u16 originX; `[0x0E]` u16 originY; `[0x10]` stride |
| arg4 | R4→R6 | current MCU/tile. `[0x00]` u8 col; `[0x02]` u16 x; `[0x04]` u16 y; `[0x08]` u32 fb base; `[0x10..]` interleaved Y/Cb/Cr sample bytes |

Two exit hubs and the epilogue:
- `FFF4CC24` — **return 0** (success). 21 branches converge here.
- `FFF4C9EA` — **return −1** (reject/clip/error: `fb 16 ff` `mov #-1,r1`). 12 branches.
- `FFF4CC26` — epilogue `3f 6d 41` `rtsd #104h,r6-r13`. The true end of the body is
  `FFF4F1B0` `38 85 fd` `bra.w loc_FFF4EF35` (an outer row-loop back-edge); every
  return routes to the mid-body epilogue.

Three-level comparison ladder (full rung list in `fff4c9d1-table.tsv`):

```
L1  arg1->[0x42] == 1 ?            FFF4C9F8  cmp #1,r14 ; bne FFF4DEA7
      yes -> FIRST  HALF FFF4C9FD  (bound uses shll #2 = x4 horizontal)
      no  -> SECOND HALF FFF4DEA7  (bound uses shll #1 = x2 horizontal)
   (the two halves are line-for-line mirrors; only the H upsample factor differs)

L2  arg2->[0x04] (component count)   per half:
      == 3 -> YCbCr   path  (FFF4CA91 / FFF4DF3E)
      == 1 -> gray    path  (FFF4CC29 / FFF4E1C1)
      else -> 2-comp  path  (FFF4CD26 / FFF4E2BE)

L3  r14 (chroma sampling factor)     0 / 1 / 2  sub-cases; "not in {1,2}" -> return -1
      FFF4CAC6 (==0), FFF4CEA9/FFF4DB90 (==1/==2 guard), FFF4EEE3 (==2 guard) ...
```

30 instances each of the four YCbCr coefficients (90 `shar #10h` normalizes),
50 `and #0F800h` red + 50 `and #7E0h` green pack sites, 87 back-branches (loops):
the per-pixel / per-row loops the Wave-2 pass counted. The dominant geometry hub is
`FFF4CC24`, not a computed target.

Reached only as a callback: `&sub_FFF4C9D1` is stored once, at `FFEDE824`
`fb 12 d1 c9 f4 ff` `mov.l #FFF4C9D1h,r1` inside `sub_FFEDE804`, into the decoder
context (field `var_34`); the engine `sub_FFF4B06C` calls it indirectly — hence no
direct call xref.

## Hand C

```c
/* Reached only via the decoder context callback set by sub_FFEDE804.
 * Returns 0 on success, -1 on reject/clip/bad-sampling. */
int jpeg_mcu_to_rgb565(ctx_t *ctx, comp_t *frm, canvas_t *cv, mcu_t *mcu) /*R1,R2,R3,R4*/
{
    /* FFF4C9D1..C9E9 */
    if (frm->b04 != frm->b11)                 return -1;         /* edge/align guard */
    if (ctx->b42 == 1) {                                         /* L1: H-upsample x4 */
        if (abs(ctx->i10) < (frm->width << 2)) return -1;        /* output-fits check */
        ... first_half(arg2->ncomp) ...
    } else {                                                     /* L1: H-upsample x2 */
        if (abs(ctx->i10) < (frm->width << 1)) return -1;
        ... second_half(arg2->ncomp) ...   /* mirror of first_half, 2x geometry */
    }

    /* L2 dispatch inside each half (shown for the first half): */
    switch (frm->ncomp) {                       /* arg2->[0x04] */
      case 3: ... ycbcr_block(...);  break;     /* FFF4CA96 */
      case 1: ... gray_block(...);   break;     /* FFF4CC2E */
      default:/*2*/ ... two_comp(...); break;   /* FFF4CD26 */
    }
}

/* Windowed framebuffer address of this MCU (FFF4CACD..CAE6) */
uint8_t *dst = (uint8_t*)mcu->fb_base - cv->originX
             + (mcu->y - cv->originY) * cv->stride
             + mcu->x;

/* Missing-chroma padding: fill the MCU Cb/Cr planes with neutral 128 (FFF4CCE4) */
for (k = 0; k < rows; k++) {                    /* mov.b #-80h, n[Cb]; n[Cr] */
    for (n = 0; n < 8; n++) { cb_plane[n] = 0x80; cr_plane[n] = 0x80; }
}

/* YCbCr -> RGB565, per output pixel (FFF4CF8E..D00E). Coefficients are JFIF/BT.601. */
int Y  = *pY;                                   /* arg4 sample plane            */
int Cr = *pCr - 128, Cb = *pCb - 128;           /* add #-80h                     */
int R = Y + ((Cr * 0x1670C) >> 16);             /* 1.410 * Cr                    */
int B = Y + ((Cb * 0x1C5E7) >> 16);             /* 1.773 * Cb                    */
int G = Y - (((Cb*0x5827) + (Cr*0xB6E3)) >> 16);/* 0.344*Cb + 0.714*Cr          */
/* per-channel saturation as literally coded (cmp #-1 / cmp #0; see Open):       */
R = (R < 0) ? 0 : 0xFFFFFFFF;                    /* 150x identical idiom          */
G = (G < 0) ? 0 : 0xFFFFFFFF;
B = (B < 0) ? 0 : 0xFFFFFFFF;
*px16 = ((R << 8) & 0xF800) | ((G << 3) & 0x07E0) | ((B >> 3) & 0x1F);  /* RGB565 */

/* Row emit with vertical replication (FFF4DE61..DEA4): copy a converted row with
 * memcpy, advance src by 0x10 / dst by stride, double for 2:1 vertical. */
```

Callees (both are C-runtime primitives, full listings in `fff4c9d1-callees.lst`):
- `sub_FFF46457` = **`abs(int)`** — `7e 21` `abs r1`; `02` `rts`. Used on
  `ctx->i10` in the output-fits check (2 call sites: `FFF4C9FD`, `FFF4DEA7`).
- `sub_FFF455A0` = **`memcpy(dst,src,n)`** — `ef 1e`/`7f 8f` `smovf`/`ef e1`/`rts`
  (RX string-move; preserves R1). Used to emit converted pixel rows (4 call sites).

(The adjacent functions confirm a C-library cluster: `sub_FFF4557D` = `memcmp`,
`sub_FFF46267` = `strtol`-family with ctype table `FFC3EA20` and errno RAM
`0x68510`, helper `sub_FFF46D0A`. None are called by the target except abs/memcpy.)

## Findings

- **Identity (Confirmed).** YCbCr→RGB565 MCU output stage of the image decoder.
  Coefficients measured against the file: `0x1670C/65536 = 1.4104` (R←Cr, JFIF
  1.402, +0.6%), `0x1C5E7/65536 = 1.7731` (B←Cb, 1.772, +0.06%),
  `0xB6E3/65536 = 0.7144` (G←Cr, 0.714, +0.04%), `0x5827/65536 = 0.3443`
  (G←Cb, 0.344, +0.06%). Three of four match BT.601 to <0.1%; the set is
  dispositive for the JFIF YCbCr transform.
- **Caller/subsystem (Confirmed).** `sub_FFEDE804` (`FFEDE804`-`FFEDE897`) builds a
  decoder context on the stack: output `0x070BB800` len `0x25800` (320×240 RGB565),
  work buffers `0x070E1000` (len `0x14000`) and `0x070F5000` (len `0x69C`), two
  callbacks `&sub_FFF4C9D1` and `&sub_FFEDE897`, then calls engine `sub_FFF4B06C`
  (`r2 = #0x1230C`, the decode state block). Return 1 = decoded.
- **Entry points (Confirmed).** `sub_FFEDE523` decodes into a fixed buffer;
  `sub_FFF3CAD0` (834 B) is the **photo viewer**: builds an `I:\PHOTO\…` path,
  opens it, decodes, reads width/height from `0x1230C`, clamps to ≤320×≤~240,
  halves/doubles to fit, computes centring offsets `(320−w)/2`, `(−16−h)/2`, and
  blits via `sub_FFEDE8F8` after clearing with `sub_FFEF1C48`.
- **No external state (Confirmed).** 0 peripheral references, 0 `o_mem` operands,
  0 data xrefs. The function reads/writes only its four argument structures and its
  stack frame. The only RAM constant in the neighbourhood (`0x68510` = errno) is
  touched by the `strtol` neighbour, not by this routine.
- **Wave-2 corrections.** "wrapper/glue" → image color-convert output stage.
  `ram:B6E3/F800/1670C/1C5E7` → immediates (3 YCbCr coefficients + RGB565 red
  mask); the 4th coefficient `0x5827` was omitted by Wave-2. The 87 "loops" are
  genuine (per-row/per-pixel back-branches). The assignment's guess that the
  adjacent `sub_FFF4C97E` sets up the target is **wrong**: `sub_FFF4C97E` is an
  independent string/2-char search helper (reached by tail-jump from `FFF4B570`,
  returns via `rtsd`); the real setup is `sub_FFEDE804`.
- **Confirmed start/end.** Start `FFF4C9D1` (`pushm r6-r13` prologue). End
  `FFF4F1B3` (last insn `FFF4F1B0 bra.w FFF4EF35`). All returns via the mid-body
  epilogue `FFF4CC26 rtsd #104h,r6-r13`.
- **Boundary verified real (not an F4-style mid-instruction over-split).** A sibling
  lane found lane-4 body seeds can be bogus mid-instruction starts (e.g. a
  `C5 FE 6E 6E` tail misread as `6E6E pushm`, which fabricated `sub_FFF40C3E` inside
  `sub_FFF40B7D`). That does **not** apply here (`verify_status.txt`):
  (a) `FFF4C9D1` is `is_head=1, item_size=2, 6e 6d = pushm r6-r13`;
  (b) its `prev_head` `FFF4C9CE` is `rtsd #8,r6-r7` (a flow-stop) ending **exactly**
  at `FFF4C9D1`;
  (c) the bytes are `…3f 67 02 | 6e 6d b1 25` — the preceding byte is `02` (the rtsd
  tail), **not** a `C5`/`CF` mov.b that could absorb `6e 6d`;
  (d) forward linear decode from both xref-reached anchors (`FFF4C442`: 605 insns;
  `FFF4C97E`: 39 insns) reaches `FFF4C9D1` as a head with **0 straddling
  instructions, 0 bad decodes**. `sub_FFF4C97E` ends in `rtsd` and does not flow
  into the target — they are two separate functions. Extent `FFF4C9D1`–`FFF4F1B3`
  stands.

## USB relevance

Orthogonal / negative, and useful as an elimination. The single largest
un-decompiled SUB routine is an **image color-conversion/display** function with no
contact with USB, the DSP/vocoder, SDR sample paths, flash writes, or any
peripheral. It serves the LCD photo viewer (`I:\PHOTO`), consistent with the lane-10
RGB565 LCD findings and the `USB CAMERA`/`PICT` menu labels (BRIEF). This closes a
large block of SUB "unknown" code as imaging, not a hidden USB/SDR/DSP surface, and
reinforces the settled negative that SUB USB is dark.

## Open

1. **Saturation idiom.** Every per-channel clamp (150× `cmp #-1`, 154× `mov.l #-1`,
   zero compares against `0xFF`/`0x100`, only 2 unrelated `max`) is a **sign test**:
   `chan = (chan < 0) ? 0 : 0xFFFFFFFF` before the RGB565 field mask. As literally
   decoded this forces each channel to 0 or full-scale (an 8-colour result), not a
   continuous-tone [0,255] saturation. Whether this is a deliberate
   threshold/preview path, writes to a reduced-colour working buffer, or whether a
   dataflow subtlety I did not fully trace makes it continuous-tone, is unresolved.
   Highest-value next step.
2. **Decode engine `sub_FFF4B06C`.** Confirm the file format (JPEG markers/Huffman
   vs a Yaesu container) and how it drives the `var_34` callback per MCU — would
   nail the format and the exact meaning of arg2 sampling fields.
3. **Second callback `sub_FFEDE897`** and the role of work buffers `0x070E1000`
   (`0x14000`) and `0x070F5000` (`0x69C`) in the pipeline.
