/* ============================================================================
 * Lane F4 — hand-reconstructed C for Routine B
 *
 *     sub_FFEF6C42   0xFFEF6C42 .. 0xFFEF9558   (10,518 bytes)
 *
 * The SINGLE LARGEST function in the SUB code window.  Prior status: only the
 * COARSE Lane-3 label "[med] wrapper/dispatch, calls 6" — never really purposed.
 * NEWLY RESOLVED here.
 *
 * WHAT IT IS (Confirmed mechanism; specific screen Inferred):
 *   An INCREMENTAL multi-slot screen renderer.  It redraws a set of up to ~10
 *   on-screen slots, but only the slots whose displayed value changed since the
 *   previous call, using per-slot "last value" caches so untouched slots are
 *   skipped.  It composites icons/bitmaps and glyph-metric text into the LCD
 *   framebuffer pointed to by *(0x1D3C8).
 *
 *   - arg (r1, saved @ sp+0x64): pointer to the slot/state record to render.
 *   - type = FFEEC232():  classifies the screen (1..4) from the MAIN->SUB frame
 *            opcode at *(0x8C4D) (seen values 0xF1/0xF7/0xF8/0xFD) and *(0x12285).
 *   - three 10-byte per-slot caches:  type{1,3}->0x8F83, type 2->0x8F8D,
 *                                     type 4->0x8F79.
 *   - sub-layout selector var_F (0..5): 6 distinct per-slot draw layouts.
 *
 * Draw primitives (Confirmed, see callees.txt):
 *   FFEF0AFE(x,y,desc)        bounds-checked bitmap compositor into *(0x1D3C8)
 *                             (clips to 0x140=320 x 0xF0=240).
 *   FFEF68D5(x,y,mode,desc)   icon/bitmap blit wrapper -> FFEF0648 / FFEF04F7.
 *   FFEF690B(x,y,mode,ptr)    text/number draw wrapper  -> FFEF0949 / FFEF0BD4.
 *   FFEF95BD(...)             sibling draw block (18 calls).
 * Flash data it reads:
 *   icon[]  @ FFED3A2C   16-byte bitmap descriptors {u16 w,u16 h,ptr,...}
 *                        (8x28,11x30,11x38,11x38,11x52 ... increasing bars)
 *   coord[] @ FFEC61A8   6-byte FIELD_COORD {u16 idx,u16 x,u16 y}
 *                        x = 0,44,88,144,188,232,275,296 ...  (column layout)
 *   glyph[] @ FFEC5A12   6-byte GLYPH_METRIC {u16,u16,u16}  (text metrics)
 * RAM it touches:
 *   slot record array @ 0x68F20 (10 x 0x28 bytes), menu state 0x8C4C/0x8C4D,
 *   0x8F77/0x8F78 (redraw triggers), caches 0x8F79/0x8F83/0x8F8D,
 *   last-drawn value cache 0x12286/0x12287 (keyed on arg[0x2F]).
 * Callers (4): FFEE68BA (wrapper that then memcpys, sub_FFEE6899),
 *   FFEF60E8 & FFEF613C (sub_FFEF6096), FFEF6314 — all screen-draw coordinators
 *   reached from the FFEEBAxx / FFEEF77E / FFF12272 menu sequencers.
 *
 * This file gives the control architecture faithfully.  The six per-layout
 * draw blocks (var_F = 0..5) are large and layout-specific; each is represented
 * by a documented stub naming its address range and the primitives it calls.
 * Full disassembly is in ida\out\sub-big2\ffef6c42.lst.
 * ==========================================================================*/

#include <stdint.h>

/* ---- types -------------------------------------------------------------- */
typedef struct { uint16_t w, h; const void *bmp; uint32_t pad; } IconDesc;  /* FFED3A2C */
typedef struct { uint16_t idx, x, y; }                          FieldCoord; /* FFEC61A8 */

/* ---- RAM ---------------------------------------------------------------- */
#define SCR_SUBSTATE  (*(volatile uint8_t  *)0x8C4Cu)   /* per-screen sub-state */
#define FRAME_OPCODE  (*(volatile uint8_t  *)0x8C4Du)   /* committed frame opcode */
#define REDRAW_A      (*(volatile uint8_t  *)0x8F77u)
#define REDRAW_B      (*(volatile uint8_t  *)0x8F78u)
#define CACHE79       ((volatile uint8_t   *)0x8F79u)   /* [10] per-slot cache, type 4 */
#define CACHE83       ((volatile uint8_t   *)0x8F83u)   /* [10] per-slot cache, type 1/3 */
#define CACHE8D       ((volatile uint8_t   *)0x8F8Du)   /* [10] per-slot cache, type 2 */
#define VALCACHE6     (*(volatile uint8_t  *)0x12286u)  /* last arg[0x2F], type 4 */
#define VALCACHE7     (*(volatile uint8_t  *)0x12287u)  /* last arg[0x2F], type 1/3 */
#define FB_PTR        (*(volatile void    **)0x1D3C8u)  /* LCD framebuffer base */

extern const IconDesc   icon_FFED3A2C[];
extern const FieldCoord coord_FFEC61A8[];
extern const uint8_t    glyph_FFEC5A12[];

/* ---- helpers ------------------------------------------------------------ */
extern uint8_t FFEEC232(void);                              /* -> screen type 1..4 */
extern void    FFEF0AFE(uint16_t x, uint16_t y, const IconDesc *d);
extern void    FFEF68D5(uint16_t x, uint16_t y, uint8_t mode, const IconDesc *d);
extern void    FFEF690B(uint16_t x, uint16_t y, uint8_t mode, const void *p);
extern void    FFEF95BD(/* ... */);
extern void    FFEEE512(/* ... */);                        /* 1 call, misc init */
extern void    FFEF02F2(/* ... */);                        /* 1 call, leaf util */

/* The six layout blocks (addresses are the dispatch targets at FFEF738A). */
static void draw_layout0(const uint8_t *arg, uint8_t type);  /* FFEF73AB */
static void draw_layout1(const uint8_t *arg, uint8_t type);  /* FFEF8039 */
static void draw_layout2(const uint8_t *arg, uint8_t type);  /* FFEF8D23 */
static void draw_layout3(const uint8_t *arg, uint8_t type);  /* FFEF79F2 */
static void draw_layout4(const uint8_t *arg, uint8_t type);  /* FFEF86BE */
static void draw_layout5(const uint8_t *arg, uint8_t type);  /* FFEF93DC */
static void draw_default(const uint8_t *arg, uint8_t type);  /* FFEF9A47 (in sub_FFEF95BD) */

static volatile uint8_t *cache_for(uint8_t type)
{
    switch (type) { case 1: case 3: return CACHE83;
                    case 2:          return CACHE8D;
                    case 4:          return CACHE79;
                    default:         return CACHE79; }
}

void sub_FFEF6C42(const uint8_t *arg)
{
    uint8_t  type;              /* var_47 @sp+0x21 */
    uint8_t  layout;            /* var_F  @sp+0x59 */
    uint8_t  row;               /* var_10 @sp+0x58 */
    uint8_t  f35, f36, f37, f38;/* var_35..38: "value changed" flags */
    uint8_t  newv[10];          /* var_E  @sp+0x5A: per-slot freshly computed value */
    uint8_t  tmp[10];           /* var_52 @sp+0x16: per-slot index -> *6 into coord/glyph */
    uint8_t  chg[30];           /* var_2F @sp+0x39: change list, 3 bytes/entry {row,new,old} */
    uint8_t  nchg;              /* var_30 @sp+0x38: change count */
    volatile uint8_t *cache;

    f35 = f36 = f37 = f38 = 0;  /* FFEF6C49-6C88 zero the flag/scratch block */
    nchg = 0;

    /* ---- Stage 1: classify screen + "redraw if the keyed value changed" --- *
     * FFEF6C8B-6D0E.  arg[0x2F] is the screen's key value; cache it per type.  */
    type = FFEEC232();                                   /* FFEF6C8B */
    switch (type) {
    case 1: case 3:                                      /* FFEF6CC9 */
        if (VALCACHE7 != arg[0x2F]) { VALCACHE7 = arg[0x2F]; f35 = f36 = 1; }
        break;
    case 4:                                              /* FFEF6CA5 */
        if (VALCACHE6 != arg[0x2F]) { VALCACHE6 = arg[0x2F]; f35 = f36 = 1; }
        break;
    case 2:                                              /* FFEF6CED (parallel) */
        /* ... analogous compare/set ... */
        break;
    }

    /* ---- Stage 2: full-slot cache reset when a global redraw is requested -- *
     * FFEF6D0F-6DE1.  If sub-state==2, or 0x8F77==1, or 0x8F78==1, or f35,     *
     * invalidate all 10 cache slots (= 0xFF) for this screen type.            */
    cache = cache_for(type);
    if (SCR_SUBSTATE == 2 || REDRAW_A == 1 || REDRAW_B == 1 || f35 == 1)
        for (row = 0; row < 10; row++) cache[row] = 0xFF;

    /* ---- Stage 3: per-slot value compute + change collection -------------- *
     * FFEF6E85-6F3D (first pass) and FFEF7131-7387 (second pass).  For each    *
     * slot: compute its current value into newv[]/tmp[]; compare against       *
     * cache[slot]; if changed, append {row,newv,oldcache} to chg[] (nchg++),   *
     * update cache[slot], and mark adjacent cache cells dirty (-2).            *
     * (Bodies are mechanical index math over 0x68F20[10] and the stack arrays; *
     *  reproduced in ffef6c42.lst lines ~160-620.)                            */
    for (row = 0; row < 8; row++) {
        uint8_t v = newv[row];                    /* computed from 0x68F20[row], menu state */
        if (v != cache[row]) {
            chg[nchg * 3 + 0] = row;
            chg[nchg * 3 + 1] = v;
            chg[nchg * 3 + 2] = cache[row];
            cache[row] = v;
            nchg++;
        }
    }

    /* ---- Stage 4: draw dispatch on the sub-layout code -------------------- *
     * FFEF738A.  Each case is a large per-layout block that walks the changed  *
     * slots (chg[]) and the FIELD_COORD table, drawing icons via FFEF0AFE /    *
     * FFEF68D5 and text via FFEF690B into FB_PTR.                              */
    layout = /* var_F, set during stage 3 from arg + slot state */ 0;
    switch (layout) {
    case 0: draw_layout0(arg, type); break;   /* FFEF73AB */
    case 1: draw_layout1(arg, type); break;   /* FFEF8039 */
    case 2: draw_layout2(arg, type); break;   /* FFEF8D23 */
    case 3: draw_layout3(arg, type); break;   /* FFEF79F2 */
    case 4: draw_layout4(arg, type); break;   /* FFEF86BE */
    case 5: draw_layout5(arg, type); break;   /* FFEF93DC */
    default: draw_default(arg, type); break;  /* FFEF9A47 */
    }
}

/* ---------------------------------------------------------------------------
 * Representative layout block (var_F == 0), FFEF73AB-FFEF7498.  Shows the
 * pattern all six blocks share: pick an icon descriptor, compute (x,y) from a
 * literal or a FIELD_COORD lookup, then blit by draw-type.
 * ------------------------------------------------------------------------- */
static void draw_layout0(const uint8_t *arg, uint8_t type)
{
    const IconDesc *d = &icon_FFED3A2C[5];      /* FFEF73AB: #FFED3A7C (last, 11x52) */
    uint16_t x, y;

    if (type == 1 || type == 2 || type == 3) {  /* FFEF73B3 */
        x = 0xFF83;  y = (type == 2) ? 0x6C : 0x2D;         /* var_44 / var_46 */
        if (/* var_37 or var_38 set */ 1)
            FFEF0AFE(x, y, d);                  /* FFEF73D4 / FFEF73ED */
    }
    /* var_48 selects the blit flavour for the main glyph/icon: */
    for (uint8_t row = 0; /* row < nchg */ row < 8; row++) {   /* FFEF741A.. */
        const FieldCoord *c = &coord_FFEC61A8[/* tmp[row] */ row];  /* *6 lookup */
        uint16_t fx = c->x;                      /* FFEF742D: 2[rec] */
        /* draw-type var_48: 1 -> FFEF68D5 (icon), 2 -> FFEF0AFE (bitmap) */
        /* FFEF73F1-7413:
         *   case 2: FFEF0AFE(x, y, d);
         *   case 1: FFEF68D5(x, y, /mode/1, d);
         */
        (void)fx;
    }
    /* ... glyph/number fields drawn via FFEF690B at coord_FFEC61A8[] positions,
     *     reading glyph_FFEC5A12[] metrics ... (FFEF7498-FFEF8038) */
}

/* The remaining five blocks are structurally the same renderer specialised for
 * a different slot layout; see ffef6c42.lst for the full disassembly.  Only the
 * dispatch ENTRY points are asserted (FFEF738A switch on var_F); the blocks are
 * interleaved in address space (target order 3,1,4,2,5 is not ascending), so no
 * contiguous end-range is claimed here.  Confirmed entries:
 *   var_F==1 -> FFEF8039    var_F==2 -> FFEF8D23    var_F==3 -> FFEF79F2
 *   var_F==4 -> FFEF86BE    var_F==5 -> FFEF93DC    default  -> FFEF9A47
 * The 44 back-edges (ffef6c42.lst) are distributed across these blocks.
 */
static void draw_layout1(const uint8_t *arg, uint8_t type){ (void)arg;(void)type; /* FFEF8039 */ }
static void draw_layout2(const uint8_t *arg, uint8_t type){ (void)arg;(void)type; /* FFEF8D23 */ }
static void draw_layout3(const uint8_t *arg, uint8_t type){ (void)arg;(void)type; /* FFEF79F2 */ }
static void draw_layout4(const uint8_t *arg, uint8_t type){ (void)arg;(void)type; /* FFEF86BE */ }
static void draw_layout5(const uint8_t *arg, uint8_t type){ (void)arg;(void)type; /* FFEF93DC */ }
static void draw_default(const uint8_t *arg, uint8_t type){ (void)arg;(void)type; /* FFEF9A47 */ }
