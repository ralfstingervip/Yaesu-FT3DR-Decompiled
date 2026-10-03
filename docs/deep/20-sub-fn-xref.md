# 20 — SUB (RX64M) functions reached by call/jump/vector

Lane 3. Database `FN_SUB_XREF` (seeded `--copy-from ida\db\jobs\SUB_VEC\SUB_VEC.i64`,
3,806 functions, doc 02's closure). Machine-readable table:
`ida\out\fnindex\sub-xref.tsv` (`start, end, validated, xref, purpose, evidence`).
Counts file `ida\out\fnindex\l3_counts.txt`; extension-point disassembly
`ida\out\fnindex\extpoint_disasm.txt`. Job script `ida\jobs\full_l3_xref.py`.

Model as reported by this environment: **Opus 5.5** (`claude-opus-5-5`), the Opus
family the parent specified.

## Verdict

Every SUB function whose start lies in the code-bearing window
`0xFFED0000`–`0xFFF50000` and that is reached by a call, jump, or interrupt
vector is enumerated with a one-line purpose citing its start address. The
recomputed reached count is **1,689** (1,467 by call or jump, of which 1,396 by
call and 76 by jump; plus 222 reached only through the vector table — 17 live ISR
entries and 205 empty CC-RX interrupt stubs). Doc 02's "1,396" is reproduced
exactly as the **call-reached** subset; the difference is fully accounted for
(jump targets + vector-only stubs), not a coverage change. 157 of the 1,689 carry
hard semantic evidence (a peripheral register or a referenced string); the
remaining 1,532 are typed from the call graph (named callees/callers), which is
the ceiling for an RX image with no Hex-Rays decompiler. Hand-written C is given
for the four extension clusters the assignment names: the menu row/label path
(`sub_FFF0964A` and the working settings screen `sub_FFF08201`), the LCD blit
(EXDMAC → CS1 `0x06000000`), the SD-card block I/O primitives, and the SUB SCI0
IPC receive path. USB0 stays closed (no function in the set touches
`0x000A0000`–`0x000A03FF`). No band/TX/DSP-loader material was produced.

## Method

- Private DB `FN_SUB_XREF`, copied from `SUB_VEC.i64`; no shared DB opened for
  writing. All work through `ida\run_job.py` (`--copy-from`, then `--reopen`).
- **Reached** decided per function by incoming cross-reference type: call =
  `fl_CN`/`fl_CF`, jump = `fl_JN`/`fl_JF` (ordinary fall-through flow excluded),
  and by membership in the vector-target set. That set was rebuilt in-DB by
  reading the 256 `INTB` dwords at `0xFFED8A70` and the 32 `EXTB` dwords at
  `0xFFFFFF80` (223 distinct in-image targets; 222 in-window). This matches doc
  02's independently-derived table.
- **Purpose** derived from code only, per function: a light intra-function
  constant propagation over `mov.l #imm,rN` / `add #imm,rN` resolves every
  peripheral access (bare immediate, `[rN]`, and `disp[rN]`) in
  `0x00080000`–`0x000FFFFF` to a named block/register (SCI/SDHI/TPU/ICU/… map
  reused from `subvec_periph.py`); immediates pointing into the flash that read
  as ≥4 printable ASCII bytes are captured as string references; direct `bsr`/`jsr`
  targets that are known function starts are captured as callees. Confidence is
  marked `[med]` (call-graph only) or `[low]` (leaf, no callee) when no
  peripheral/string evidence exists. Every purpose is prefixed with `@<start>` so
  it cites the function it describes.
- **Instruction bytes** summed per reached function over `is_code` items in
  `[start,end)`.
- Extension-point clusters dumped in full to `extpoint_disasm.txt` and
  transliterated to C by hand (below).
- **Did not run / out of scope, deliberately:** USB0 was not probed beyond
  confirming absence from the reached set; band-coverage, TX-keying and the DSP
  `26AA:0020` loader were not approached; the sweep-only (unreached) candidates
  are another lane's — this lane lists only reached functions. Purposes for the
  1,532 call-graph-typed functions are structural, not semantic; a function whose
  base register arrives from RAM or a pointer table is outside constant-prop reach
  (same limit doc 02 records).

## Findings

### Counts and the reconciliation with doc 02

| Quantity | Value |
| --- | --- |
| Functions in DB | 3,806 |
| Functions with start in `0xFFED0000`–`0xFFF50000` | 3,805 (all but `reset_handler` at `FFC00000`) |
| **Reached by call/jump/vector (T_fn_subxref)** | **1,689** |
| — reached by call (`fl_CN`/`fl_CF`) | 1,396 |
| — reached by jump (`fl_JN`/`fl_JF`) | 76 |
| — reached by call OR jump | 1,467 |
| — reached only via vector (no call/jump) | 222 (= 17 live ISR + 205 RTE stubs) |
| **Purpose citing start address (D_fn_subxref)** | **1,689** (100%) |
| — of which carry peripheral/string evidence | 157 |
| Instruction bytes inside reached window functions | **271,819** |

Doc 02 reported "1,396 of the 3,806 … reached by a call or jump xref." That
figure is reproduced here **exactly as the call-reached count**. The honest delta:
doc 02's phrase counted call references only; adding the 71 functions reached by a
jump but never a call gives 1,467, and adding the 222 vector-only functions (which
have no call/jump xref at all, so doc 02's phrasing excluded them) gives 1,689.
The 205 RTE stubs are the empty `#pragma interrupt` bodies at
`0xFFF47E34`–`0xFFF47FCF` (doc 02 §1); they are functions the vector table reaches
and are therefore in scope, but carry no purpose beyond "unserviced interrupt
stub." Nothing in the closure changed; the number differs only by definition.

### Highest-value semantic hits (samples from the 157)

- GPS on an SCI channel: `sub_FFEE0D4D` refs `"$PMTK103"`/`"$PMTK102"`,
  `sub_FFEE103B` refs `"$PMTK001"` (MediaTek GPS command set) — confirms doc 02's
  SCI GPS channel at the code level.
- CC-RX runtime: `sub_FFEE18A6` refs `"<drive C>\stdin"`/`"<drive C>\stdout"`/`"<drive C>\stderr"`;
  `sub_FFEE333B` refs `"[20yy/mm/dd hh:mm]"` (log timestamp formatter).
- The three live SCI ISR pairs (SCI0 58/59, SCI2 62/63, SCI3 80/81) all resolve
  to their `SCR/SSR/RDR`/`TDR` registers in the table, matching doc 02 exactly.

### Extension cluster 1 — menu row / label path

`sub_FFF0964A` (36 B, `@30964A`, callers `FFF00576`, `FFF0928D`) is a row helper
that fetches a menu label by a **1-based** index and lays out its cell:

```c
/* @FFF0964A : emit one menu row. r1=col/x word, r2=row word, r3=b, r4=item */
void menu_row(u16 x, u16 row, u8 attr, u8 item) {
    char label[N];
    fetch_label(&label, item + 1);       /* bsr sub_FFEE1DE8, index is 1-based */
    u16 cx = x + 0x2A;                    /* column advance = 42 px */
    /* ... continues past dump tail: places label at (cx,row) ... */
}
```

The `item + 1` confirms brief correction 5 (label table is 1-based). The concrete
model an owner setup-menu row attaches to is the **working USB CAMERA settings
screen** `sub_FFF08201` (749 B, `@308201`, caller `FFF00556`). It reads a config
struct based at RAM `0x00008C4D` and renders one row per field via the text-draw
primitive `sub_FFEFA7E7(x, y, str, color)`:

```c
struct cam_cfg { u8 f20; u8 size_ix; u8 size; u8 quality; u8 sp_sel; } *c = (void*)0x8C4D;
/* sub_FFF08201, one visible pattern repeated per row: */
draw_text(x, y, c->size    ? "160*120" : "320*240", ...);   /* SIZE   : */
draw_text(x, y, (char*[]){"LOW","NORMAL","HIGH"}[c->quality], ...); /* QUALITY: */
draw_text(x, y, c->sp_sel  ? "INT SP"  : "CAMERA", ...);     /* SP SEL : */
/* selection highlight via sub_FFEF0648(x,y,tbl); commit rows 2..4 via sub_FFF08826 */
```

To add a setup row: extend the config struct, add a `cmp c->field / draw_text`
block here, and register the label in the 1-based table `sub_FFF0964A` reads.
`sub_FFEFA7E7` (label+value, x/y/str/color) and `sub_FFEF0648` (highlighted row)
are the two draw entry points. This is the cleanest owner extension point in the
lane.

### Extension cluster 2 — LCD blit (EXDMAC → CS1 `0x06000000`)

The LCD framebuffer is a memory-mapped device on external chip-select CS1
(`0x06000000`, doc 16/RESUME). EXDMAC channel 0 block-copies a RAM bitmap to it.

```c
/* configure, @FFEF1F90 (callers FFEF1F7B/FFEF1F87). arg = bitmap descriptor. */
void lcd_blit_config(struct bmp *b) {   /* b->w @+6, b->h @+8 */
    EXDMAC0.EDMDAR = 0x06000000;        /* 0x00082804 : dest = LCD on CS1 */
    u32 count = b->w * b->h;
    if (count >= 0x400) { /* set full-frame transfer dims from b->w,b->h */ }
    else               { /* small-region path */ }
}
/* kick, @FFEF1DDA (caller FFEDEF25). */
void lcd_blit_start(void) {
    ICU.IER[0x0F] &= ~0x40;             /* 0x0008720F : mask EXDMAC0 int */
    EXDMAC0.EDMCNT_bit0 = 0;            /* 0x0008281C : disable */
    /* 0x00082814 = 0x8000; EDMTMD 0x00082810 = 0x8100; EDMINT 0x00082813 |= 0x10 */
    EXDMAC0.EDMAST |= 1;               /* 0x00082A00 : start channel */
    EXDMAC0.EDMCNT_bit0 = 1;            /* 0x0008281C : enable */
    ICU.IER[0x0F] ...                  /* re-enable, transfer-end raises vector 126 */
}
```

Transfer-end is INTB vector 126 (`sub_FFEF1E28`, which only dummy-reads `EDMSTS`
`0x0008281E`). Register naming follows doc 02's EXDMAC map. An owner overlay that
draws to the LCD would build a bitmap descriptor and call `lcd_blit_config` →
`lcd_blit_start`.

### Extension cluster 3 — SD-card block I/O primitives

These are the low-level SDHI block-transfer primitives (the FAT/file layer sits
above them, doc 13):

```c
/* buffer-access ISR body, @FFF33AA7 (tail of vector 44). */
void sdhi_bufacc(void) {
    sub_FFF32CB5();                    /* service the pending buffer op */
    u32 s = SDHI.SDSTS2;               /* 0x0008AC3C */
    if (s & 0x100) { SDHI.SDSTS2 = ~0x100; return; }   /* BWE: buffer write */
    if (s & 0x200) { SDHI.SDSTS2 = ~0x200; return; }   /* BRE: buffer read  */
}
/* card insert/remove, @FFF32A29 (tail of vector 111). */
void sdhi_carddet(void) {
    for (int i = 0; i <= 0; i++) {     /* single slot */
        u32 s = SDHI.SDSTS1;           /* 0x0008AC38 */
        if (s & 0x10) {                /* card inserted */
            if (card_present != 1) { card_present = 1;     /* 0x00065E38 */
                obj_table[i]->flags |= 0x40; }             /* 0x00065E34[i]+0x58 */
            SDHI.SDSTS1 &= ~0x10;
        } else if (s & 0x08) {         /* card removed */
            if (card_present == 1) { card_present = 0;
                obj_table[i]->flags &= ~0x40; }
            SDHI.SDSTS1 &= ~0x08;
        }
    }
}
/* DMAC3 transfer-end, @FFF32EA4 (vector 123 path). */
void dmac3_end(void) { DMAC3.DMSTS &= ~0x10; }   /* 0x000820DE bit4 = DTIF */
```

The full SD path (doc 02 §5): SDHI buffer-ready (vector 44) → DMAC3 moves the
block (`DMRSR3 = 0x2C` binds it) → DMAC3 end (vector 123); insert/remove is
vector 111. A card→radio data feature (e.g. reading a settings file) attaches
above these, at the FAT layer.

### Extension cluster 4 — SUB SCI0 IPC receive path (`0x0008A000`)

SCI0 is the MAIN↔SUB IPC link (to MAIN SCI_6, doc 09). A callback pair is
registered at RAM `0x00012D20`:

```c
struct sci0_cb {          /* @ 0x00012D20 */
    tx_fn tx_provider;    /* +0x00 : supplies next TX byte, returns nonzero if one */
    rx_fn rx_handler;     /* +0x04 : consumes one received byte */
    u16   tx_ctx;         /* +0x08 : passed as arg1 to tx_provider */
    u16   rx_ctx;         /* +0x0A : passed as arg1 to rx_handler  */
};

/* RXI0, vector 58, @FFEDB7E7 — the IPC receive entry. */
void sci0_rxi0_isr(void) {
    if (!(SCI0.SCR & 0x40)) return;              /* 0x0008A002 RIE off */
    u8 ssr = SCI0.SSR;                           /* 0x0008A004 */
    if (ssr & 0x38) SCI0.SSR = (ssr & ~0x38)|0xC0;  /* clear ORER|FER|PER */
    u8 b = SCI0.RDR;                             /* 0x0008A005 */
    struct sci0_cb *cb = (void*)0x00012D20;
    if (cb->rx_handler) cb->rx_handler(cb->rx_ctx, &b, 1);  /* r1,r2,r3 */
}
/* TXI0, vector 59, @FFEDB857. */
void sci0_txi0_isr(void) {
    u8 out; struct sci0_cb *cb = (void*)0x00012D20;
    u16 have = cb->tx_provider ? cb->tx_provider(cb->tx_ctx, &out, 1) : 0;
    if (have) SCI0.TDR = out;              /* 0x0008A003 */
    else      SCI0.SCR &= ~0x80;           /* clear TIE, stop TX */
}
```

`sub_FFEDB7B6` / `sub_FFEDB8A5` are the polled (non-interrupt) twins of the same
receive/transmit bodies, invoked by the ICU group-BL0 dispatcher `sub_FFEDBCDD`
(vector 110) on `GRPBL0` `0x00087630` bits — the TEI/ERI aggregation path for
SCI0/2/3. An owner feature that speaks to MAIN over IPC registers a
`rx_handler`/`tx_provider` pair in the `0x00012D20` table; it does not touch the
ISR.

## Extension

Ranked for a later owner feature (e.g. a setup-menu row):

1. **`sub_FFF08201` + `sub_FFF0964A`** (settings-screen render + 1-based label
   fetch) with draw primitives `sub_FFEFA7E7` (label/value) and `sub_FFEF0648`
   (highlight). Adding a row = one config byte + one `cmp/draw_text` block + one
   label-table entry. Cleanest attach point.
2. **IPC callback table at RAM `0x00012D20`** to exchange data with MAIN over
   SCI0 without modifying the ISR.
3. **SD FAT layer above `sub_FFF33AA7`/`sub_FFF32A29`** for a card-file input.
4. **`lcd_blit_config`/`lcd_blit_start`** (EXDMAC→CS1) to draw an overlay.

## Counts

- **T_fn_subxref** (reached by call/jump/vector, start in `0xFFED0000`–`0xFFF50000`):
  **1,689**.
- **D_fn_subxref** (of those, non-empty purpose citing start address): **1,689**
  (157 with peripheral/string evidence; 1,327 call-graph-typed; 205 RTE stubs).
- **Instruction bytes inside those functions:** **271,819**.
- **Recomputed reached vs doc 02's 1,396:** call-reached = 1,396 (identical);
  call-or-jump = 1,467 (+71 jump-only); +222 vector-only = 1,689. Difference is a
  definitional widening (jumps + vector-only stubs), not a coverage change.

## Open

Most valuable first.

1. Lift the 1,327 call-graph-typed functions toward semantic purposes by
   resolving base registers arriving from RAM/pointer tables (the constant-prop
   blind spot; would name much of the SCI callback and menu-dispatch machinery).
2. Resolve the `0x00012D20` callback slots to who registers each — names what
   SCI0 actually carries end-to-end (already flagged by doc 02).
3. Map the FAT/file layer above the SD primitives (doc 13 has the storage
   verdict; the function-level file-op entries are not yet all named).
4. Name the menu label indices `sub_FFF0964A` fetches against the label table so
   a new row's index is known exactly.
