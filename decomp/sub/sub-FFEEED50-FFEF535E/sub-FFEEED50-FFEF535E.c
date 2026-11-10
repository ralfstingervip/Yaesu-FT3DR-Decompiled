/* ============================================================================
 * sub-FFEEED50-FFEF535E.c  -  Wave C hand reconstruction, SUB core (RX64M).
 *
 * DOCUMENTATION ONLY.  Hand transcription of the IDA listing chunk
 * FFEEED50..FFEF535E of FT3D_SUB_ver102_ALL.bin (little-endian, mapped at
 * 0xFFC00000).  Nothing here was compiled or run.  145 functions, address order.
 *
 * Subsystems in this range (see NOTES.md):
 *   - SUB screen 0x2E (MAIN F701, the C4FM digital-group / GM station list):
 *     phase handlers, event handlers, 4-slot station rows        FFEEED50-FFEEF94F
 *   - LCD flush pipeline: off-screen surface, 1-deep flush queue,
 *     EXDMAC0 -> LCD (0x06000000), soft timers                     FFEEF94F-FFEEFDED
 *   - 64-bit UI redraw-event mask (0x1D3B0) and blink scheduler   FFEEFDED-FFEF0306
 *   - framebuffer primitives: erase/fill/blit/tint/rotate/glyph/string
 *                                                                  FFEF032D-FFEF2317
 *   - widget renderer (layout table, icon records)                FFEF23EE-FFEF3912
 *   - status bar (11 icons) and shadow/pending frame reconcilers  FFEF395E-FFEF535E
 *
 * RX notes used throughout (see NOTES.md for the evidence):
 *   - IDA's RX module prints every 8-bit immediate sign-extended.  A 3-byte
 *     "cmp #-0Fh" against a zero-extended byte is cmp #0xF1, "mov.w #-10h,8[r1]"
 *     (3D-form, uimm8) stores 0x00F0, "mov.l #-68h,r3" is 0x98.  The C below uses
 *     the unsigned values; 4-byte "mov.w #-1,[rN]" really is 0xFFFF.
 *   - Arguments r1..r4, then stack; return r1.  Frame idioms add/rtsd.
 *   - Screen: 320x240 RGB565, row stride 0x140 pixels.
 * ========================================================================== */

#include <stdint.h>
typedef uint8_t u8;  typedef uint16_t u16;  typedef uint32_t u32;
typedef int8_t  s8;  typedef int16_t  s16;  typedef int32_t  s32;

#define LCD_W 320u
#define LCD_H 240u
#define RGB565(r,g,b) (u16)(((r)<<11)|((g)<<5)|(b))
#define COL_WHITE 0xFFFFu
#define COL_GREY  0x7BEFu          /* 50% grey, the "inactive" text colour      */

/* ---- types ---------------------------------------------------------------- */
typedef struct { u16 x, y, w, h; } rect_t;           /* layout rectangle, 8 B    */

typedef struct {                  /* drawing surface / flush job, 16 bytes        */
    u8   state;                   /* +0  flush-job state (only 0x1D3A0 uses it)   */
    u8   slot;                    /* +1  off-screen slot index (0x8F75[])         */
    rect_t r;                     /* +2  x,y,w,h on screen                        */
    u16  pad;                     /* +A                                           */
    u16 *base;                    /* +C  320-stride RGB565 buffer                 */
} surface_t;

typedef struct {                  /* i17_bmp_desc_t (doc 16/68), 16 bytes          */
    u16  w, h;                    /* +0,+2                                        */
    const u16 *pix;               /* +4  RGB565 or intensity pixels               */
    u16  key;                     /* +8  transparent colour (and mode-1 "0%" col) */
    u16  tint;                    /* +A  mode-1 "100%" colour                     */
    u16  mode;                    /* +C  0 key-copy, 1 tint by intensity, 2 invert*/
} bmp_desc_t;

typedef struct { u8 w, h; u16 base_code; const u16 *ord_tbl; const u8 *pix; } font_blk_t; /* 12 B */
typedef struct { u16 w, h; const u8 *src; u8 flag; } glyph_t;  /* FFEF2184 output */

typedef struct {                  /* i17_icon_rec_t, 28 bytes (doc 79), FFED55E0[] */
    u8   id; u8 pad1[3];
    s16  x_off;                   /* +4                                           */
    s16  y_off;                   /* +6                                           */
    u8   kind;                    /* +8  1 = text, 2 = bitmap                     */
    char text[10];                /* +9  kind 1: up to 10 chars, drawn at 2x      */
    u8   font;                    /* +13                                          */
    u8   spacing;                 /* +14 extra pixels between characters          */
    u8   pad2[3];
    const bmp_desc_t *desc;       /* +18 kind 2: bitmap                           */
} icon_rec_t;

typedef struct {                  /* widget lookup context (FFEF2724), on stack   */
    u8 op;                        /* [0] = ui_shadow[0], screen opcode 0xF0..0xFD */
    u8 sub;                       /* [1] = ui_shadow[1], screen sub-code          */
    u8 layout;                    /* [2] OUT: index into layout_tbl[]             */
    u8 id;                        /* [3] IN : widget index on this screen         */
    u8 icon;                      /* [4] OUT: icon record index (FFED55E0[])      */
    u8 state;                     /* [5] OUT: 0 hidden,1 dim,2 normal,3 alt,4 blink*/
} widget_ctx_t;

typedef struct {                  /* 0x68854: blink scheduler                     */
    u32 timer;                    /* +0  soft-timer index (tick code uses 3)      */
    u32 phase;                    /* +4  toggles 0x10 / 0x11                      */
    u32 lo;                       /* +8  lo-word event bits to re-post each blink */
    u32 hi;                       /* +C  hi-word event bits to re-post            */
    u16 period;                   /* +10 reload used by blink_start*              */
} blink_t;

/* ---- RAM globals ---------------------------------------------------------- */
extern u8   screen_phase;         /* 0x00008C4C per-screen phase 0..3 (doc 31)    */
extern u8   ui_shadow[0x12C];     /* 0x00008C4D committed MAIN->SUB screen frame  */
extern u8   ui_pending[0x12C];    /* 0x00008E46 last received frame (FFEF0385)    */
extern u8   compose_flag_8D79;    /* 0x00008D79 cleared before a full compose     */
extern u8   ui_hold;              /* 0x00008D7A !=0 suspends event dispatch       */
extern u8   cur_event;            /* 0x00008F73 event being serviced              */
extern u8   surface_busy[1];      /* 0x00008F75 off-screen slot in use            */
extern u8   flush_count;          /* 0x00008F76 entries in flush_queue (max 1)    */
extern u8   lcd_display_on;       /* 0x00008A8A F000/F001 display flag (doc 43)   */
extern u8   screen_type_override; /* 0x00012285 forces sub_FFEEC232's result     */
extern u16  ui_timer_cnt[4];      /* 0x000124F6 soft-timer counters               */
extern u16  ui_timer_reload[4];   /* 0x000124FE soft-timer reloads (FFEC5A1C)     */
extern u16  slot_xy[4][2];        /* 0x00012570 GM row origins (.data image)      */
extern u8  *cur_band_rec;         /* 0x0001D39C = &ui_shadow[0x20]                */
extern surface_t flush_job;       /* 0x0001D3A0 job being DMA'd; .state = 0/1/2   */
extern u32  ui_event[2];          /* 0x0001D3B0 lo (events 0..31), hi (32..63)    */
extern surface_t main_surface;    /* 0x0001D3B8 the one drawing surface           */
extern surface_t *cur_surface;    /* 0x0001D3C8 target of all draw primitives     */
extern surface_t flush_queue[1];  /* 0x0001D3CC 1-deep flush queue                */
extern u32  ui_timer_group;       /* 0x0001D3E4 handle from sub_FFEE1229          */
extern blink_t blink;             /* 0x00068854                                   */
extern const rect_t *layout_tbl[];/* 0x00068868 per-layout widget rectangles      */

/* ---- external memory (CS6 SDRAM) and peripherals -------------------------- */
#define BASE_FRAME   ((u16 *)0x07000000)   /* background layer, 320x240          */
#define OFFSCREEN0   ((u16 *)0x0704B000)   /* composition buffer, slot 0         */
#define SLOT_STRIDE  0x25800u              /* 320*240*2                          */
#define GLYPH_SCRATCH ((u16 *)0x07070800)  /* expanded glyph                     */
#define PACK_BUF     ((u16 *)0x07096000)   /* sub-rect packed for DMA            */
#define LCD_PORT     ((volatile u8 *)0x06000000) /* CS5 LCD controller (doc 51)  */

#define ICU_IER0F    (*(volatile u8  *)0x0008720F)  /* bit6 = vector 126         */
#define ICU_IPR126   (*(volatile u8  *)0x0008737E)
#define EDMSAR       (*(volatile u32 *)0x00082800)  /* EXDMAC0 (RX64M offsets)   */
#define EDMDAR       (*(volatile u32 *)0x00082804)
#define EDMCRA       (*(volatile u32 *)0x00082808)
#define EDMCRB       (*(volatile u16 *)0x0008280C)
#define EDMTMD       (*(volatile u16 *)0x00082810)
#define EDMINT       (*(volatile u8  *)0x00082813)
#define EDMAMD       (*(volatile u32 *)0x00082814)
#define EDMCNT       (*(volatile u8  *)0x0008281C)
#define EDMREQ       (*(volatile u8  *)0x0008281D)
#define EDMSTS       (*(volatile u8  *)0x0008281E)
#define EDMAST       (*(volatile u8  *)0x00082A00)

/* ---- flash tables --------------------------------------------------------- */
extern void (*const screen2E_phase_tbl[4])(void);   /* FFED5518                  */
extern void (*const screen2E_event_tbl[42])(void);  /* FFED5528                  */
extern const bmp_desc_t *const gm_arrow_tbl[4];     /* FFED55D0 (4 descriptors)  */
extern const icon_rec_t icon_tbl[254];              /* FFED55E0 (doc 68/79)      */
extern const font_blk_t font_tbl[26];               /* FFED4644 (doc 27/68)      */
extern const rect_t screen2E_widget_rect[3];        /* FFEC6008                  */
extern const u16 ui_timer_reload_init[4];           /* FFEC5A1C                  */
extern const u8  event_base_tbl[];                  /* FFC3D8AC (fb e2 ac d8 c3 ff) */
typedef struct { u16 row, start, end; } span_t;     /* rounded-shape row spans   */
extern const span_t span_h34[], span_h26[], span_h1C[], span_h14[], span_h10[];
                                   /* FFEC5A24, FFEC5B5C, FFEC5C40, FFEC5CE8, FFEC5D60 */
extern const bmp_desc_t bmp_FFED205C, bmp_FFECF14C;  /* and the other stru_ names */

/* ---- callees outside this range ------------------------------------------- */
extern u8  *band_rec_current(void);           /* sub_FFEEC3BD: pointer to the current band record in ui_shadow (+0x20, +0x31, +0x6C, +0x7D ... chosen by op/sub) */
extern u8   screen_type(void);                /* sub_FFEEC232: 1..4, honours 0x12285 (doc 31) */
extern void screen_type_set(u8 t);            /* sub_FFEEC35B: 0x12285 = t        */
extern u8   screen_label_index(void);         /* sub_FFEEC1C9                      */
extern void band_anchor_tone(u16*,u16*,u16*); /* sub_FFEEC5AB (sibling of FFEEED50) */
extern void band_anchor_aux (u16*,u16*,u16*); /* sub_FFEEC7E1                      */
extern u8   glyph_width(u8 font, u16 code);   /* sub_FFEE5269 (doc 27)            */
extern u32  timer_group_register(u16 n, u16 *cnt, u16 *reload); /* sub_FFEE1229   */
extern void timer_group_start(u32 g, u16 idx);/* sub_FFEE12AC: cnt[idx]=reload[idx] */
extern void timer_group_stop (u32 g, u16 idx);/* sub_FFEE12E7: cnt[idx]=0         */
extern void lcd_cmd(u8 c);                    /* sub_FFEDE298 (doc 51)            */
extern void lcd_set_window(u16 x, u16 w1, u16 y, u16 h1); /* sub_FFEDE1F5: 0x2A/0x2B */
extern u8   lcd_display_flag(void);           /* sub_FFEDE267: returns 0x8A8A     */
extern void lcd_seq_set(u8 s);                /* sub_FFEDDEF1: 0x8A87 = s (s<=8)  */
extern void draw_bitmap_or_erase(u16 x, u16 y, u8 on, const bmp_desc_t *d); /* sub_FFEF68D5 */
extern void draw_text_colour(u16 x, u16 y, u8 mode, const char *s, u16 len, u16 col); /* sub_FFEFAB3E (len,col on stack) */
extern void statusbar_battery(u16 x, u16 y, u8 level); /* sub_FFEF693B          */
extern void gm_band_panel(void);              /* sub_FFEF6096                     */
extern void band_meter_draw(void);            /* sub_FFEF5E38 (draws at band_anchor_right; uses rec[0x3F]) */
extern void screen2E_bg_art(void);            /* sub_FFEFA588                     */
extern void screen2E_title(u16 x, u16 y);     /* sub_FFEFA54F                     */
extern void screen2E_label(u8 n);             /* sub_FFEF9E8F                     */
extern void *memcpy_b(void *d, const void *s, u32 n); /* sub_FFEFB268 (byte loop) */
extern void *memset_b(void *d, u8 v, u32 n);  /* sub_FFEFB29A                     */
extern u32  bit_u32(u8 n);                    /* sub_FFEFB2C2: n<=31 ? 1<<n : 0   */
extern u8   lowest_set_bit(u32 v);            /* sub_FFEFB369: 0xFF when v==0     */
extern void bcd_to_ascii(const u8 *bcd, u8 ndig, char *buf); /* sub_FFEFB4AA: packed BCD digits -> ASCII, passes - and space */

/* ==========================================================================
 * FFEEED50-FFEEF0AA  size 858  band_anchor_right  (alias sub_FFEEED50)
 * Callers: sub_FFEEBD3E, sub_FFEF5E38.          Confidence: Confirmed (body)
 * Returns where (x,y) and in which colour the right-hand per-band indicator is
 * drawn on the current screen.  x is always 0x124 (292).  The y row depends on
 * the screen opcode/sub-code in ui_shadow[0..1], the screen type 1..4 from
 * sub_FFEEC232, the current band record's first byte and ui_shadow[9] bit 4.
 * White = active band, grey 0x7BEF = the other band.  When no case matches,
 * *x and *y stay 0xFFFF (callers test x>0x13F / y>=0xF0 and skip drawing);
 * *colour is then left untouched.  Which indicator sub_FFEF5E38 draws there is
 * not decided here (it uses rec[0x3F]; Inferred: a level/meter glyph).
 * ======================================================================== */
#define PUT(X,Y,C) do { *x = (X); *y = (Y); *colour = (C); return; } while (0)
void band_anchor_right(u16 *x, u16 *y, u16 *colour)
{
    u8 *rec = band_rec_current();
    u8 type = screen_type();
    u8 op = ui_shadow[0], sub = ui_shadow[1], r0 = rec[0];
    *x = 0xFFFF; *y = 0xFFFF;

    if (op == 0xF1) {
        if (sub == 0) {
            int a = (r0 == 0 || r0 == 2);
            int b = ((ui_shadow[9] & 0x10) >> 4) == 0;
            if (a) {
                if (b) { if (type == 1) PUT(0x124, 0x2D, COL_WHITE);
                         if (type == 2) PUT(0x124, 0x8D, COL_GREY); }
                else   { if (type == 1) PUT(0x124, 0x29, COL_GREY);
                         if (type == 2) PUT(0x124, 0x6C, COL_WHITE); }
            } else {
                if (b) { if (type == 1) PUT(0x124, 0x4D, COL_WHITE);
                         if (type == 2) PUT(0x124, 0x8D, COL_GREY); }
                else   { if (type == 1) PUT(0x124, 0x29, COL_GREY);
                         if (type == 2) PUT(0x124, 0x8D, COL_WHITE); }
            }
            return;
        }
        if (sub == 1)                    PUT(0x124, 0x2D, COL_WHITE);
        if (sub == 0x14 || sub == 0x15)  PUT(0x124, (r0 == 0 || r0 == 2) ? 0x2D : 0x4D, COL_WHITE);
        if (sub == 0x06)                 PUT(0x124, 0x16, COL_WHITE);
        if (sub == 0x0B)                 PUT(0x124, 0x29, COL_WHITE);
        if (sub == 0x12)                 PUT(0x124, 0x3E, COL_WHITE);
        if (sub == 0x13)                 PUT(0x124, 0x29, COL_WHITE);
        if (sub == 0x0F)                 PUT(0x124, 0x16, COL_WHITE);
        if (sub == 0x03) {
            int t4 = (type == 4);
            if (((ui_shadow[9] & 0x10) >> 4) == 0) {
                if (t4)        PUT(0x124, 0x16, COL_WHITE);
                if (type == 1) PUT(0x124, 0x4D, COL_WHITE);
                if (type == 2) PUT(0x124, 0x84, COL_GREY);
            } else {
                if (t4)        PUT(0x124, 0x16, COL_WHITE);
                if (type == 1) PUT(0x124, 0x4D, COL_GREY);
                if (type == 2) PUT(0x124, 0x84, COL_WHITE);
            }
        }
        return;
    }
    if (op == 0xF7) { if (sub == 1) PUT(0x124, 0x2C, COL_WHITE); return; }
    if (op == 0xF8) { if (sub == 0) PUT(0x124, 0x29, COL_WHITE); return; }
    if (op == 0xFD) { if (sub == 0) PUT(0x124, 0x29, COL_WHITE); return; }
}

/* ==========================================================================
 * FFEEF0AA-FFEEF315  size 619  band_anchor_left  (alias sub_FFEEF0AA)
 * Caller: sub_FFEF6096.                          Confidence: Confirmed (body)
 * Left-hand sibling of band_anchor_right: x = 0x19 (25), or 3 for F1/0F.
 * The F1 sub 0/1/0x14 and sub 3 cases only apply when rec[0] is 2 or 3.
 * ======================================================================== */
void band_anchor_left(u16 *x, u16 *y, u16 *colour)
{
    u8 *rec = band_rec_current();
    u8 type = screen_type();
    u8 op = ui_shadow[0], sub = ui_shadow[1];
    u8 h4 = (ui_shadow[9] & 0x10) >> 4;
    u8 r0 = rec[0];
    *x = 0xFFFF; *y = 0xFFFF;

    if (op == 0xF1) {
        if (sub == 0 || sub == 1 || sub == 0x14) {
            if (!(r0 == 2 || r0 == 3)) return;
            if (h4 == 0) {
                if (type == 1) PUT(0x19, 0x43, COL_WHITE);
                if (type == 3) PUT(0x19, 0x43, COL_WHITE);
                PUT(0x19, 0x83, COL_GREY);
            } else {
                if (type == 1) PUT(0x19, 0x1F, COL_GREY);
                if (type == 3) PUT(0x19, 0x43, COL_WHITE);
                PUT(0x19, 0x83, COL_WHITE);
            }
        }
        if (sub == 3) {
            if (!(r0 == 2 || r0 == 3)) return;
            if (h4 == 0) { if (type == 1) PUT(0x19, 0x4C, COL_WHITE);
                           if (type == 2) PUT(0x19, 0x83, COL_GREY); }
            else         { if (type == 1) PUT(0x19, 0x4C, COL_GREY);
                           if (type == 2) PUT(0x19, 0x83, COL_WHITE); }
            return;
        }
        if (sub == 0x06) PUT(0x19, 0x16, COL_WHITE);
        if (sub == 0x0F) PUT(0x03, 0x16, COL_WHITE);
        if (sub == 0x0B) PUT(0x19, 0x1F, COL_WHITE);
        if (sub == 0x12) PUT(0x19, 0x34, COL_WHITE);
        if (sub == 0x13) PUT(0x19, 0x1F, COL_WHITE);
        return;
    }
    if (op == 0xF7) { if (sub == 1) PUT(0x19, 0x2C, COL_WHITE); return; }
    if (op == 0xF8) { if (sub == 0) PUT(0x19, 0x1F, COL_WHITE); return; }
}
#undef PUT

/* ==========================================================================
 * Screen 0x2E (MAIN F701; doc 122: SUB screen 0x2E, handler 0xFFEEF315).
 * The station rows carry a 10-char name, a 4-way-rotated arrow bitmap and a
 * 7-char text with a decimal point - the shape of the C4FM GM (group monitor)
 * list (callsign / bearing / distance).  Inferred from layout only: no string
 * in this range names the screen.
 *
 * Phase table FFED5518 (indexed by screen_phase):
 *   0 screen2E_phase0_init  1 screen2E_draw_background
 *   2 screen2E_phase2_compose  3 screen2E_phase3_service
 * Event table FFED5528 (indexed by the event number from ui_event_next):
 *   0 screen2E_request_full    1 screen2E_draw_background  2 screen2E_clear
 *   4..14 statusbar_redraw_*  (4:@34 5:@4A 6:@68 7:@7D 8:@92 9:@A9 10:@DD
 *   11:battery@02 12:@21 13:@CC 14:@FC)   20 sub_FFEEBAAC   24,29 sub_FFEEC08D
 *   32..35,38 screen2E_redraw_rows   39..41 screen2E_redraw_widget
 *   other slots: null callbacks (sub_FFEF39F7 / sub_FFEF2032), per doc 46.
 * ======================================================================== */

/* FFEEF315-FFEEF33F  size 42  screen2E_dispatch (alias sub_FFEEF315)
 * Reached from the SUB screen table (doc 122).            Confidence: Confirmed */
void screen2E_dispatch(void)
{
    if (screen_phase <= 3) { screen2E_phase_tbl[screen_phase](); return; }
    screen_phase = 3;
}

/* FFEEF33F-FFEEF351  size 18  screen2E_phase0_init (alias sub_FFEEF33F)
 * Phase 0: take the pending frame in full, then go to phase 1.  Confirmed */
void screen2E_phase0_init(void)
{
    screen2E_sync(1);
    screen_phase++;
}

/* FFEEF351-FFEEF38C  size 59  screen2E_draw_background (alias sub_FFEEF351)
 * Phase 1 and event 1.  Re-targets drawing at the background layer
 * (0x07000000), draws the static artwork, then advances the phase.
 * Confidence: Confirmed (callee meanings Inferred) */
void screen2E_draw_background(void)
{
    surface_main_init();                                   /* cur = BASE_FRAME */
    screen2E_bg_art();                                     /* sub_FFEFA588     */
    draw_bitmap_or_erase(5, 0x19, 1, &bmp_FFED205C);
    screen2E_title(0x4E, screen2E_widget_rect[0].y);       /* sub_FFEFA54F     */
    screen2E_label(6);                                     /* sub_FFEF9E8F     */
    screen_phase++;
}

/* FFEEF38C-FFEEF3B9  size 45  screen2E_phase2_compose (alias sub_FFEEF38C)
 * Phase 2: full-screen compose into the off-screen buffer, then queue it
 * for the LCD (surface_main_commit also advances the phase to 3). Confirmed */
void screen2E_phase2_compose(void)
{
    if (surface_begin(&main_surface, 0, 0, LCD_W, LCD_H) == 1) {
        screen2E_compose_all();
        surface_main_commit();
    }
}

/* FFEEF3B9-FFEEF40A  size 81  screen2E_redraw_rows (alias sub_FFEEF3B9)
 * Events 32..35 and 38: redraw the four station rows (band y=0x4C, h=0x6F).
 * Confidence: Confirmed */
void screen2E_redraw_rows(void)
{
    if (surface_begin(&main_surface, 0, 0x4C, LCD_W, 0x6F) != 1) return;
    for (u8 i = 0; i < 4; i++)
        screen2E_draw_row(slot_xy[i][0], slot_xy[i][1], i);
    surface_main_commit();
}

/* FFEEF40A-FFEEF452  size 72  screen2E_redraw_widget (alias sub_FFEEF40A)
 * Events 0x27..0x29: redraw widget (cur_event-0x27) inside its rectangle
 * from FFEC6008.                                           Confidence: Confirmed */
void screen2E_redraw_widget(void)
{
    u8 k = cur_event - 0x27;
    const rect_t *r = &screen2E_widget_rect[k];
    if (surface_begin(&main_surface, r->x, r->y, r->w, r->h) == 1) {
        widget_draw(k);
        surface_main_commit();
    }
}

/* FFEEF452-FFEEF4D8  size 134  screen2E_phase3_service (alias sub_FFEEF452)
 * Phase 3, the steady state.  Picks the highest-priority pending redraw
 * event; with none pending, absorbs a newly received frame instead.  An
 * event is serviced only when the flush queue is empty (one frame in flight).
 * Confidence: Confirmed */
void screen2E_phase3_service(void)
{
    cur_event = ui_event_next();
    if (cur_event == 0xFF)
        screen2E_sync(0);
    if (cur_event != 0xFF && cur_event <= 0x29) {
        if (lcd_flush_queue_busy() == 0) {
            ui_event_ack(cur_event);
            screen2E_event_tbl[cur_event]();
        }
    }
    if (screen_phase >= 4) screen_phase = 3;   /* handlers that bump the phase */
}

/* FFEEF4D8-FFEEF4F4  size 28  screen2E_sync (alias sub_FFEEF4D8)
 * Pull ui_pending into ui_shadow, posting redraw events for what changed.
 * full=1 (phase 0) afterwards drops every event: the screen is redrawn whole.
 * Confidence: Confirmed */
void screen2E_sync(u8 full)
{
    ui_sync_screen_id();          /* FFEF4069 */
    screen2E_reconcile();         /* FFEEF4F4 */
    ui_sync_hold();               /* FFEF40BA */
    if (full == 1) ui_event_clear_all();
}

/* FFEEF4F4-FFEEF71E  size 554  screen2E_reconcile (alias sub_FFEEF4F4)
 * Caller: screen2E_sync.                                  Confidence: Confirmed
 * Field-by-field pending->shadow copy for screen 0x2E, mapping each change to
 * a redraw event.  Hi-word events: bit i (i<6) = station row i, 0x40 (event
 * 38) = all rows, 0x80<<i (events 39..41) = widget i.  A row whose state byte
 * becomes 2 starts blinking.  Layout: [0x6C..0x7B] screen header (any change
 * -> event 0, full redraw), [0x7C] selected row, [0x7D + 21*i] row i (6 rows),
 * [0xFB..0xFD], [0xFE..0x100] widget bytes. */
void screen2E_reconcile(void)
{
    u8 changed = 0, i;

    ui_reconcile_header();                                       /* FFEF4142 */
    cur_band_rec = &ui_shadow[0x20];
    band_rec_reconcile(&ui_shadow[0x20], &ui_pending[0x20], 3);  /* FFEF42A7 */
    sync_bytes_post_lo(&ui_shadow[0x6C], &ui_pending[0x6C], 0x10, 1);

    if (ui_shadow[0x7C] != ui_pending[0x7C] && ui_pending[0x7C] <= 5) {
        ui_event_post_hi(1u << ui_shadow[0x7C]);    /* old selection row */
        ui_event_post_hi(0x40);
        ui_shadow[0x7C] = ui_pending[0x7C];
    }
    for (i = 0; i < 6; i++) {
        u8 *s = &ui_shadow[0x7D + i * 0x15], *p = &ui_pending[0x7D + i * 0x15];
        if (s[0] != p[0]) {
            if (p[0] == 2)      blink_start(1u << i, 0);
            else if (s[0] == 2) blink_stop (1u << i, 0);
            ui_event_post_hi(1u << i);
        }
        changed = sync_bytes_post_hi(s, p, 0x15, 1u << i);
        if (ui_shadow[0x7C] <= 5) {
            if (changed) ui_event_post_hi(0x40);
            if (s[0] == 2) ui_event_post_hi(0x40);
        }
    }
    for (i = 0; i < 3; i++) {
        if (ui_shadow[0xFB + i] != ui_pending[0xFB + i]) {
            ui_event_post_hi(0x80u << i);
            ui_shadow[0xFB + i] = ui_pending[0xFB + i];
        }
        if (ui_shadow[0xFE + i] != ui_pending[0xFE + i]) {
            ui_event_post_hi(0x80u << i);
            ui_shadow[0xFE + i] = ui_pending[0xFE + i];
        }
    }
    if (ui_shadow[9] != ui_pending[9]) ui_shadow[9] = ui_pending[9];
    blink_tick();                                                 /* FFEF0294 */
}

/* FFEEF71E-FFEEF77E  size 96  screen2E_compose_all (alias sub_FFEEF71E)
 * Caller: screen2E_phase2_compose.                        Confidence: Confirmed */
void screen2E_compose_all(void)
{
    compose_flag_8D79 = 0;
    surface_fill_from_base(0, 0);          /* background layer -> buffer */
    statusbar_draw_all();
    screen_type_set(3);
    screen2E_draw_band_parts();
    screen_type_set(0xFF);
    for (u8 i = 0; i < 4; i++)
        screen2E_draw_row(slot_xy[i][0], slot_xy[i][1], i);
    widget_draw(0);
    widget_draw(1);
    widget_draw(2);
}

/* FFEEF77E-FFEEF78B  size 13  screen2E_draw_band_parts (alias sub_FFEEF77E)
 * Callers: sub_FFEEC08D, screen2E_compose_all.            Confidence: Confirmed */
void screen2E_draw_band_parts(void)
{
    gm_band_panel();          /* sub_FFEF6096 (uses band_anchor_left)  */
    band_flag_current();      /* sub_FFEF4CED; result discarded        */
    band_meter_draw();        /* sub_FFEF5E38 (uses band_anchor_right) */
}

/* FFEEF78B-FFEEF833  size 168  screen2E_draw_row (alias sub_FFEEF78B)
 * Draw station row i at (x,y): erase 0x98x0x33, then if the row is in use
 * (state 1, or state 2 during the "on" half of the blink) paint the
 * 0x96x0x31 background - orange 0xF980 for the selected row, dark grey
 * 0x39E7 otherwise - and the row contents.               Confidence: Confirmed */
void screen2E_draw_row(u16 x, u16 y, u8 i)
{
    u8 sel = ui_shadow[0x7C];
    u8 *row = &ui_shadow[0x7D + i * 0x15];
    u8 show = 0;

    gfx_erase_rect(x, y, 0x98, 0x33);
    if (row[0] == 0) return;
    if (row[0] == 1) show = 1;
    else if (blink_get_phase() == 0x11) show = 1;
    if (show != 1) return;
    gfx_fill_rect(x, y, 0x96, 0x31, (sel == i) ? 0xF980 : 0x39E7);
    screen2E_draw_row_body(x, y, row);
}

/* FFEEF833-FFEEF94F  size 284  screen2E_draw_row_body (alias sub_FFEEF833)
 * Row record (21 bytes): [0] state, [1..10] name, [0x0C] arrow (bits 0-1
 * pick one of 4 bitmaps at FFED55D0, bits 2-3 rotation 0/90/180/270),
 * [0x0D..0x13] 7-char text whose [0x10] may be '.', [0x14] style (0/2 = light
 * grey text 0xBDF7, 1/3 = white text with arrow).          Confidence: Confirmed */
void screen2E_draw_row_body(u16 x, u16 y, u8 *row)
{
    u8 style = row[0x14], arrow = row[0x0C];
    u16 col = (style == 0 || style == 2) ? 0xBDF7 : COL_WHITE;
    u16 ax = x + 0x17, ay = y + 0x1C, tx;

    draw_text_colour(x + 10, y + 5, 1, (char *)&row[1], 10, col);
    if (style == 1 || style == 3) {
        const bmp_desc_t *d = gm_arrow_tbl[arrow & 3];
        switch (arrow >> 2) {
        case 0: gfx_draw_bitmap(ax, ay, d);      break;
        case 1: gfx_draw_bitmap_rot1(ax, ay, d); break;
        case 2: gfx_draw_bitmap_rot3(ax, ay, d); break;
        case 3: gfx_draw_bitmap_rot5(ax, ay, d); break;
        }
    }
    tx = (row[0x10] == '.') ? x + 0x37 : x + 0x31;
    draw_text_colour(tx, ay, 1, (char *)&row[0x0D], 7, col);
}

/* ==========================================================================
 * LCD flush pipeline.  Drawing goes into one off-screen 320x240 buffer
 * (0x0704B000); surface_begin claims it and records the dirty rectangle,
 * surface_main_commit queues it, lcd_flush_poll (main loop) DMAs the
 * rectangle to the LCD and frees the buffer when EXDMAC0 reports done.
 * ======================================================================== */

/* FFEEF94F-FFEEF9BB  size 108  lcd_flush_poll (alias sub_FFEEF94F)
 * Callers: sub_FFEDE897, sub_FFEDF016 (main loop).        Confidence: Confirmed
 * flush_job.state: 0 idle -> 1 job copied from queue -> 2 DMA running.  After a
 * frame completes with the display flag (0x8A8A) still 0 it steps the
 * display-on sequencer (0x8A87 = 2; Inferred: "first frame ready, enable"). */
void lcd_flush_poll(void)
{
    switch (flush_job.state) {
    case 0:
        if (lcd_flush_peek(&flush_job) != 1) return;
        flush_job.state = 1;
        /* fall through */
    case 1:
        lcd_flush_start(&flush_job);
        flush_job.state = 2;
        return;
    case 2:
        if (exdmac0_done() != 1) return;
        flush_job.state = 0;
        lcd_flush_retire_head();
        if (lcd_display_flag() == 0) lcd_seq_set(2);
        return;
    }
}

/* FFEEF9BB-FFEEFA62  size 167  surface_begin (alias sub_FFEEF9BB)
 * 256 callers (every screen's redraw).  Doc 12 read it as a "display-update
 * predicate"; it is the allocator: claim a free off-screen slot (only slot 0
 * exists: the loop runs i<=0), point desc at it, record the dirty rectangle
 * and make desc the current surface.  Returns 1 on success, 0 when w or h is
 * zero or the buffer is still waiting for its flush.        Confidence: Confirmed */
u8 surface_begin(surface_t *desc, u16 x, u16 y, u16 w, u16 h /* stack */)
{
    u8 ok = 0;
    if (w == 0 || h == 0) return 0;
    for (u8 i = 0; i <= 0; i++) {
        if (surface_busy[i] != 0) continue;
        surface_busy[i] = 1;
        desc->state = 0;
        desc->slot  = i;
        desc->base  = (u16 *)((u8 *)OFFSCREEN0 + i * SLOT_STRIDE);
        desc->r.x = x; desc->r.y = y; desc->r.w = w; desc->r.h = h;
        ok = 1;
        cur_surface = desc;
        break;
    }
    return ok;
}

/* FFEEFA62-FFEEFA75  size 19  surface_release (alias dead_FFEEFA62)
 * No caller (dead).  Frees desc's slot.                   Confidence: Confirmed */
void surface_release(surface_t *desc) { surface_busy[desc->slot] = 0; }

/* FFEEFA75-FFEEFA9E  size 41  lcd_flush_init (alias sub_FFEEFA75)
 * Callers: sub_FFEDEEFC, sub_FFEDF677.  Note the queue clear starts at
 * 0x1D3CD (entry byte 1), 16 bytes.                       Confidence: Confirmed */
void lcd_flush_init(void)
{
    memset_b(surface_busy, 0, 1);
    memset_b((u8 *)flush_queue + 1, 0, 0x10);
    flush_count = 0;
}

/* FFEEFA9E-FFEEFB66  size 200  lcd_flush_enqueue (alias sub_FFEEFA9E)
 * Callers: sub_FFEDE590, surface_main_commit, sub_FFF0B1DB, sub_FFF3CAD0.
 * Queue depth is 1: a second enqueue while one is pending is dropped.
 * Confidence: Confirmed */
void lcd_flush_enqueue(const surface_t *s)
{
    if (flush_count > 0) return;
    surface_t *q = &flush_queue[flush_count];
    q->state = 0;
    q->slot  = s->slot;
    q->r     = s->r;
    q->base  = s->base;
    flush_count++;
}

/* FFEEFB66-FFEEFB84  size 30  lcd_flush_queue_empty (alias sub_FFEEFB66)   Confirmed */
u8 lcd_flush_queue_empty(void) { return flush_count == 0 ? 1 : 0; }

/* FFEEFB84-FFEEFBA3  size 31  lcd_flush_queue_busy (alias sub_FFEEFB84)
 * 58 callers: every screen's phase-3 service tests it.     Confirmed */
u8 lcd_flush_queue_busy(void) { return (s8)flush_count > 0 ? 1 : 0; }

/* FFEEFBA3-FFEEFC15  size 114  lcd_flush_peek (alias sub_FFEEFBA3)
 * Copy the head entry to *out (all 16 bytes incl. state 0); 1 if one existed.
 * Confidence: Confirmed */
u8 lcd_flush_peek(surface_t *out)
{
    if (flush_count == 0) return 0;
    *out = flush_queue[0];
    return 1;
}

/* FFEEFC15-FFEEFC2C  size 23  lcd_flush_retire_head (alias sub_FFEEFC15)
 * Free the flushed slot and pop the queue.                Confidence: Confirmed */
void lcd_flush_retire_head(void)
{
    surface_busy[flush_queue[0].slot] = 0;
    lcd_flush_dequeue();
}

/* FFEEFC2C-FFEEFD64  size 312  lcd_flush_dequeue (alias sub_FFEEFC2C)
 * Generic shift-down pop (written for a deeper queue than the 1 used).
 * Confidence: Confirmed */
void lcd_flush_dequeue(void)
{
    u8 i;
    if (flush_count == 0) return;
    if (flush_count == 1) {
        flush_queue[0].slot = 0; flush_queue[0].r = (rect_t){0,0,0,0};
        flush_queue[0].base = 0; flush_count = 0;
        return;
    }
    for (i = 0; i < flush_count - 1; i++) {
        flush_queue[i].slot = flush_queue[i + 1].slot;
        flush_queue[i].r    = flush_queue[i + 1].r;
        flush_queue[i].base = flush_queue[i + 1].base;
    }
    flush_queue[i].slot = 0; flush_queue[i].r = (rect_t){0,0,0,0};
    flush_queue[i].base = 0;
    flush_count--;
}

/* ==========================================================================
 * UI soft timers: a 4-entry group registered with the generic timer service
 * at sub_FFEE1229 (4 groups of {n, counters, reloads} at 0x1CDE4).
 * ======================================================================== */

/* FFEEFD64-FFEEFD91  size 45  ui_timers_init (alias sub_FFEEFD64)
 * Caller: sub_FFEDEEF1.                                   Confidence: Confirmed */
void ui_timers_init(void)
{
    memcpy_b(ui_timer_reload, ui_timer_reload_init, 8);
    ui_timer_group = timer_group_register(4, ui_timer_cnt, ui_timer_reload);
}

/* FFEEFD91-FFEEFDA5  size 20  ui_timer_start (alias sub_FFEEFD91)   Confirmed */
void ui_timer_start(u32 idx) { timer_group_start(ui_timer_group, (u16)idx); }

/* FFEEFDA5-FFEEFDB9  size 20  ui_timer_stop (alias sub_FFEEFDA5)    Confirmed */
void ui_timer_stop(u32 idx)  { timer_group_stop(ui_timer_group, (u16)idx); }

/* FFEEFDB9-FFEEFDDA  size 33  ui_timer_expired (alias sub_FFEEFDB9)
 * 1 when counter idx has reached 0 (decremented elsewhere).  Confirmed */
u8 ui_timer_expired(u32 idx) { return ui_timer_cnt[idx] == 0 ? 1 : 0; }

/* FFEEFDDA-FFEEFDED  size 19  ui_timer_set_reload (alias sub_FFEEFDDA)  Confirmed */
void ui_timer_set_reload(u32 idx, u16 v) { ui_timer_reload[idx] = v; }

/* ==========================================================================
 * UI redraw events: a 64-bit mask, ui_event[0] = events 0..31, ui_event[1] =
 * events 32..63.  Reconcilers post bits; the active screen's phase-3 handler
 * takes one at a time (ui_event_next), acks it and calls its table entry.
 * Doc 31/50 called FFEEFEA4/FFEEFEEE "dirty flags"; they are this mask.
 * "field/kind" form (FFEEFE0E): kind 0 -> lo |= field (raw mask);
 * kind 1 or 3 -> lo |= 0x8000<<field; kind 2 -> hi |= 1<<field.
 * ======================================================================== */

/* FFEEFDED-FFEEFE0E  size 33  ui_event_post2 (alias sub_FFEEFDED)
 * Caller: dead_FFEF212D only.                             Confirmed */
void ui_event_post2(u32 hi, u32 lo) { ui_event[0] |= lo; ui_event[1] |= hi; }

/* FFEEFE0E-FFEEFE52  size 68  ui_event_post_field (alias sub_FFEEFE0E)   Confirmed */
void ui_event_post_field(u32 field, u8 kind)
{
    switch (kind) {
    case 0:          ui_event_post_lo(field);              return;
    case 1: case 3:  ui_event_post_lo(0x8000u << field);   return;
    case 2:          ui_event_post_hi(1u << field);        return;
    }
}

/* FFEEFE52-FFEEFEA4  size 82  ui_event_post_shifted (alias dead_FFEEFE52)
 * Dead.  mask<<bit into the 64-bit set when bit<=0x3F and bit<=limit. Confirmed */
void ui_event_post_shifted(u32 mask, u8 bit, u8 limit)
{
    if (!(bit <= 0x3F && bit <= limit)) return;
    if (bit <= 0x1F) ui_event[0] |= mask << bit;
    else             ui_event[1] |= mask << (bit - 0x20);
}

/* FFEEFEA4-FFEEFEB5  size 17  ui_event_post_lo (alias sub_FFEEFEA4)
 * 63 callers.                                             Confidence: Confirmed */
void ui_event_post_lo(u32 mask) { ui_event[0] |= mask; }

/* FFEEFEB5-FFEEFEEE  size 57  ui_event_post_lo_shifted (alias dead_FFEEFEB5)  Confirmed */
void ui_event_post_lo_shifted(u32 mask, u8 bit, u8 limit)
{
    if (bit <= 0x1F && bit <= limit) ui_event[0] |= mask << bit;
}

/* FFEEFEEE-FFEEFF00  size 18  ui_event_post_hi (alias sub_FFEEFEEE)
 * 25 callers.  Doc 31: "*(u32*)0x1D3B4 |= arg" - same cell.   Confirmed */
void ui_event_post_hi(u32 mask) { ui_event[1] |= mask; }

/* FFEEFF00-FFEEFF25  size 37  ui_event_clear2 (alias dead_FFEEFF00)          Confirmed */
void ui_event_clear2(u32 hi, u32 lo) { ui_event[0] &= ~lo; ui_event[1] &= ~hi; }

/* FFEEFF25-FFEEFF38  size 19  ui_event_clear_lo (alias sub_FFEEFF25)         Confirmed */
void ui_event_clear_lo(u32 mask) { ui_event[0] &= ~mask; }

/* FFEEFF38-FFEEFF4C  size 20  ui_event_clear_hi (alias sub_FFEEFF38)         Confirmed */
void ui_event_clear_hi(u32 mask) { ui_event[1] &= ~mask; }

/* FFEEFF4C-FFEEFF90  size 68  ui_event_clear_field (alias sub_FFEEFF4C)
 * Inverse of ui_event_post_field.                         Confirmed */
void ui_event_clear_field(u32 field, u8 kind)
{
    switch (kind) {
    case 0:          ui_event_clear_lo(field);             return;
    case 1: case 3:  ui_event_clear_lo(0x8000u << field);  return;
    case 2:          ui_event_clear_hi(1u << field);       return;
    }
}

/* FFEEFF90-FFEEFF9E  size 14  ui_event_get_lo (alias sub_FFEEFF90)   Confirmed */
u32 ui_event_get_lo(void) { return ui_event[0]; }

/* FFEEFF9E-FFEEFFAC  size 14  ui_event_get_hi (alias sub_FFEEFF9E)   Confirmed */
u32 ui_event_get_hi(void) { return ui_event[1]; }

/* FFEEFFAC-FFEEFFEA  size 62  ui_event_set (alias dead_FFEEFFAC)     Confirmed */
void ui_event_set(u8 n)
{
    if (n <= 0x1F)      ui_event[0] |= bit_u32(n);
    else if (n <= 0x3F) ui_event[1] |= bit_u32(n - 0x20);
}

/* FFEEFFEA-FFEF002C  size 66  ui_event_ack (alias sub_FFEEFFEA)
 * 58 callers (every phase-3 service).                     Confirmed */
void ui_event_ack(u8 n)
{
    if (n <= 0x1F)      ui_event[0] &= ~bit_u32(n);
    else if (n <= 0x3F) ui_event[1] &= ~bit_u32(n - 0x20);
}

/* FFEF002C-FFEF003F  size 19  ui_event_clear_all (alias sub_FFEF002C)  Confirmed */
void ui_event_clear_all(void) { ui_event[0] = 0; ui_event[1] = 0; }

/* FFEF003F-FFEF0163  size 292  ui_event_next (alias sub_FFEF003F)
 * 59 callers.  Returns 0xFF while ui_hold is set or while a new screen
 * selector byte [0x13] is pending (the screen is about to change).  Fixed
 * priority list first, then any hi-word event (32+n), then any lo event.
 * Confidence: Confirmed */
u8 ui_event_next(void)
{
    u8 n;
    if (ui_hold != 0 || ui_shadow[0x13] != ui_pending[0x13]) return 0xFF;
    n = lowest_set_bit(ui_event[1]);           /* computed, overwritten below */
    if (ui_event[0] & (1u << 24)) return 0x18;
    if (ui_event[1] & (1u << 9))  return 0x29;
    if (ui_event[0] & (1u << 21)) return 0x15;
    if (ui_event[1] & (1u << 6))  return 0x26;
    if (ui_event[0] & (1u << 23)) return 0x17;
    if (ui_event[1] & (1u << 8))  return 0x28;
    if (ui_event[0] & (1u << 30)) return 0x1E;
    if (ui_event[0] & (1u << 31)) return 0x1F;
    n = lowest_set_bit(ui_event[1]);
    if (n == 0xFF) n = lowest_set_bit(ui_event[0]);
    else           n += 0x20;
    return n;
}

/* ==========================================================================
 * Blink scheduler (0x68854): every time soft timer 3 expires (reload 0x65
 * ticks) the phase flips 0x10<->0x11 and every registered event bit is
 * re-posted, so blinking elements redraw twice per period.
 * ======================================================================== */

/* FFEF0163-FFEF019E  size 59  blink_start (alias sub_FFEF0163)
 * 24 callers.                                             Confidence: Confirmed */
void blink_start(u32 hi, u32 lo)
{
    ui_timer_set_reload(blink.timer, blink.period);
    ui_timer_start(blink.timer);
    blink.lo |= lo;
    blink.hi |= hi;
}

/* FFEF019E-FFEF01D1  size 51  blink_stop (alias sub_FFEF019E)
 * Note it stops the shared timer even if other bits are still registered;
 * the next blink_start re-arms it.                         Confidence: Confirmed */
void blink_stop(u32 hi, u32 lo)
{
    ui_timer_stop(blink.timer);
    blink.lo &= ~lo;
    blink.hi &= ~hi;
}

/* FFEF01D1-FFEF0220  size 79  blink_start_field (alias sub_FFEF01D1)
 * Caller: band_rec_reconcile.  Field/kind mapping as ui_event_post_field
 * (kind 2 -> hi 1<<field, otherwise lo 0x8000<<field).    Confirmed */
void blink_start_field(u8 field, u8 kind)
{
    ui_timer_set_reload(blink.timer, blink.period);
    ui_timer_start(blink.timer);
    if (kind == 2) blink.hi |= 1u << field;
    else           blink.lo |= 0x8000u << field;
}

/* FFEF0220-FFEF0265  size 69  blink_stop_field (alias sub_FFEF0220)  Confirmed */
void blink_stop_field(u8 field, u8 kind)
{
    ui_timer_stop(blink.timer);
    if (kind == 2) blink.hi &= ~(1u << field);       /* bnot on -1 */
    else           blink.lo &= ~(0x8000u << field);
}

/* FFEF0265-FFEF0273  size 14  blink_get_phase (alias sub_FFEF0265)
 * Raw phase word, 0x10 or 0x11.                            Confirmed */
u32 blink_get_phase(void) { return blink.phase; }

/* FFEF0273-FFEF0294  size 33  blink_toggle (alias sub_FFEF0273)      Confirmed */
void blink_toggle(void) { blink.phase = (blink.phase == 0x10) ? 0x11 : 0x10; }

/* FFEF0294-FFEF02F2  size 94  blink_tick (alias sub_FFEF0294)
 * 57 callers (every reconciler ends with it).  Doc 31 calls it "the
 * dirty-bit flush"; it is the blink re-post.               Confirmed */
void blink_tick(void)
{
    if (ui_timer_expired(3) != 1) return;
    ui_timer_set_reload(3, 0x65);
    ui_timer_start(3);
    blink_toggle();
    for (u8 b = 0; b < 32; b++) {
        u32 m = 1u << b;
        if (blink.lo & m) ui_event_post_lo(m);
        if (blink.hi & m) ui_event_post_hi(m);
    }
}

/* FFEF02F2-FFEF0306  size 20  blink_on (alias sub_FFEF02F2)
 * 50 callers: "draw the blinking element in this half-period?"  Confirmed */
u8 blink_on(void) { return (u8)(blink.phase & 1); }

/* FFEF0306-FFEF032D  size 39  blink_reset (alias sub_FFEF0306)
 * Caller: sub_FFEDF677.                                    Confirmed */
void blink_reset(void)
{
    ui_timer_stop(blink.timer);
    blink.phase = 0; blink.lo = 0; blink.hi = 0;
}

/* ==========================================================================
 * Surfaces, frames and framebuffer primitives.  Every primitive addresses
 * cur_surface->base + ((y+row)*320 + x+col)*2, i.e. absolute screen
 * coordinates inside a full-screen buffer.  "Erase" means "copy back from
 * the background layer BASE_FRAME (0x07000000)".
 * ======================================================================== */

/* FFEF032D-FFEF036F  size 66  surface_main_init (alias sub_FFEF032D)
 * 59 callers (each screen's background phase).  Points the main surface at
 * the background layer itself, full screen, and makes it current.
 * Confidence: Confirmed (doc 51 agrees) */
void surface_main_init(void)
{
    main_surface.base = BASE_FRAME;
    main_surface.r.x = 0; main_surface.r.y = 0;
    main_surface.r.w = LCD_W; main_surface.r.h = LCD_H;
    cur_surface = &main_surface;
}

/* FFEF036F-FFEF0385  size 22  surface_main_commit (alias sub_FFEF036F)
 * 253 callers.  Queue the main surface for the LCD and advance the screen
 * phase (handlers in phase 3 rely on the phase>=4 clamp).    Confirmed */
void surface_main_commit(void)
{
    lcd_flush_enqueue(&main_surface);
    screen_phase++;
}

/* FFEF0385-FFEF039B  size 22  ui_pending_load (alias sub_FFEF0385)
 * Sole caller sub_FFEDC1F6 (IPC ring dequeue): copy one 300-byte frame
 * slot into ui_pending (doc 51/43: the only writer of 0x8E46).  Confirmed */
void ui_pending_load(const u8 *frame) { memcpy_b(ui_pending, frame, 0x12C); }

/* FFEF039B-FFEF03BC  size 33  ui_frames_clear (alias sub_FFEF039B)
 * Caller: sub_FFEDEF41.                                    Confirmed */
void ui_frames_clear(void)
{
    memset_b(ui_shadow, 0, 0x12C);
    memset_b(ui_pending, 0, 0x12C);
}

/* FFEF03BC-FFEF03DA  size 30  base_pixel_addr (alias dead_FFEF03BC)
 * Dead.  Returns 0x07000000 + y*320 + x - note: no *2, so a byte address
 * that is wrong for a 16-bit frame (the live twin below doubles it). Confirmed */
u32 base_pixel_addr(u16 x, u16 y) { return 0x07000000u + (u32)y * LCD_W + x; }

/* FFEF03DA-FFEF0408  size 46  base_pixel_read (alias dead_FFEF03DA)     Confirmed */
u16 base_pixel_read(u16 x, u16 y) { return BASE_FRAME[(u32)y * LCD_W + x]; }

/* FFEF0408-FFEF0453  size 75  surface_fill_from_base (alias sub_FFEF0408)
 * 60 callers; doc 06 "sub_FFEF0408(0,0) blanks the screen".  x and y are
 * stored but unused: the whole 320x240 background layer is copied into the
 * current surface (surface_xform_copy mode 0x0E = plain copy). Confirmed */
void surface_fill_from_base(u16 x, u16 y)
{
    surface_t src = { 0, 0, {0, 0, LCD_W, LCD_H}, 0, BASE_FRAME };
    surface_t dst = src;
    (void)x; (void)y;
    dst.base = cur_surface->base;
    surface_xform_copy(&src, &src.r, 0x0E, &dst, &dst.r);
}

/* FFEF0453-FFEF04F7  size 164  base_put_bitmap (alias sub_FFEF0453)
 * Caller: sub_FFEDE8F8.  Opaque copy of a bitmap into the BACKGROUND layer
 * (not the current surface); clipped by size only.          Confirmed */
void base_put_bitmap(u16 x, u16 y, const bmp_desc_t *b)
{
    u16 w = b->w, h = b->h;
    if (w > LCD_W - x || h > LCD_H - y) return;
    for (u16 r = 0; r < h; r++)
        for (u16 c = 0; c < w; c++)
            BASE_FRAME[(u32)(y + r) * LCD_W + x + c] = b->pix[(u32)w * r + c];
}

/* FFEF04F7-FFEF0553  size 92  gfx_erase_rect (alias sub_FFEF04F7)
 * 132 callers ("clears a 320-pixel region", docs 12/13).  Restores the
 * rectangle from the background layer into the current surface. Confirmed */
void gfx_erase_rect(u16 x, u16 y, u16 w, u16 h)
{
    surface_t src = { 0, 0, {0, 0, LCD_W, LCD_H}, 0, BASE_FRAME };
    surface_t dst = src;
    rect_t r = { x, y, w, h };
    dst.base = cur_surface->base;
    surface_xform_copy(&src, &r, 0x0E, &dst, &r);
}

/* FFEF0553-FFEF0581  size 46  gfx_fill_rect_white (alias sub_FFEF0553)
 * Caller: sub_FFEFA78C.                                     Confirmed */
void gfx_fill_rect_white(u16 x, u16 y, u16 w, u16 h)
{
    rect_t r = { x, y, w, h };
    surface_fill_rect(cur_surface, &r, 0xFFFF);
}

/* FFEF0581-FFEF05DD  size 92  surface_fill_rect (alias sub_FFEF0581)  Confirmed */
void surface_fill_rect(surface_t *s, const rect_t *r, u16 colour)
{
    for (u16 row = 0; row < r->h; row++)
        for (u16 col = 0; col < r->w; col++)
            s->base[(u32)(r->y + row) * LCD_W + r->x + col] = colour;
}

/* FFEF05DD-FFEF0648  size 107  surface_recolour (alias dead_FFEF05DD)
 * Dead (doc 78/89: FFEF05DD+FFEF0609 are one nested-loop function).
 * Replace colour `from` by `to` inside rectangle r of the current surface.
 * Confidence: Confirmed */
void surface_recolour(const rect_t *r, u16 from, u16 to)
{
    for (u16 row = 0; row < r->h; row++)
        for (u16 col = 0; col < r->w; col++) {
            u16 *p = &cur_surface->base[(u32)(r->y + row) * LCD_W + r->x + col];
            if (*p == from) *p = to;
        }
}

/* Shared helpers for the blitters below (not functions in the image). */
#define CLIPPED(x,y,w,h) ((w) > LCD_W - (x) || (h) > LCD_H - (y))
#define FB(x,y)          (cur_surface->base[(u32)(y) * LCD_W + (x)])
static inline u16 blend565(u16 c0, u16 c100, u8 pct)
{   /* channel-wise c0 + (c100-c0)*pct/100, as FFEF0730..FFEF077D */
    s32 r0 = c0 >> 11, g0 = (c0 & 0x7E0) >> 5, b0 = c0 & 0x1F;
    s32 r1 = c100 >> 11, g1 = (c100 & 0x7E0) >> 5, b1 = c100 & 0x1F;
    return RGB565((u8)(r0 + (r1 - r0) * pct / 100), (u8)(g0 + (g1 - g0) * pct / 100),
                  (u8)(b0 + (b1 - b0) * pct / 100));
}
static inline u8 half_toward(u8 c, u8 t)   /* FFEF12EE..: t +/- |c-t|*50/100 */
{ return (c > t) ? (u8)(t + (c - t) * 50 / 100) : (u8)(t - (t - c) * 50 / 100); }

/* FFEF0648-FFEF0949  size 769  gfx_draw_bitmap (alias sub_FFEF0648)
 * 30 direct callers + sub_FFEF68D5 (x176): the RGB565 sprite blit (doc 16).
 * Clips by size; mode 1: source pixel = intensity, output = blend from key
 * (0%) to tint (100%); mode 2: bitwise-inverted source; otherwise key-colour
 * transparency with a 2-pixel (32-bit) fast path.            Confirmed */
void gfx_draw_bitmap(u16 x, u16 y, const bmp_desc_t *d)
{
    u16 w, h, key, row, col;
    if (d == 0) return;
    w = d->w; h = d->h;
    if (CLIPPED(x, y, w, h)) return;
    key = d->key;
    if (d->mode == 1) {
        for (row = 0; row < h; row++)
            for (col = 0; col < w; col++) {
                u16 p = d->pix[(u32)w * row + col];
                if (p == key) continue;
                FB(x + col, y + row) = blend565(key, d->tint, (u8)(p * 100u / 0xFFFFu));
            }
    } else if (d->mode == 2) {
        for (row = 0; row < h; row++)
            for (col = 0; col < w; col++) {
                u16 p = d->pix[(u32)w * row + col];
                if (p != key) FB(x + col, y + row) = (u16)~p;
            }
    } else {
        for (row = 0; row < h; row++)
            for (col = 0; col < w; col++) {
                const u16 *s = &d->pix[(u32)w * row + col];
                u16 *o = &FB(x + col, y + row);
                if (col + 1 < w) {
                    if (s[0] != key && s[1] != key) *(u32 *)o = *(const u32 *)s;
                    else if (!(s[0] == key && s[1] == key)) {
                        if (s[0] == key) o[1] = s[1]; else o[0] = s[0];
                    }
                    col++;                         /* two pixels per step */
                } else if (s[0] != key) {
                    o[0] = s[0];
                }
            }
    }
}

/* Row-span lookup shared by the two "rounded" routines (FFEF09AE, FFEF0C3A). */
static inline void rounded_span(u16 w, u16 h, u16 row, u16 *start, u16 *end)
{
    const span_t *t = 0;
    switch (h) {
    case 0x34: t = span_h34; break;   case 0x26: t = span_h26; break;
    case 0x1C: t = span_h1C; break;   case 0x14: t = span_h14; break;
    case 0x10: t = span_h10; break;
    }
    if (t) { *start = t[row].start; *end = t[row].end; }
    else   { *start = 0; *end = w - 1; }
}

/* FFEF0949-FFEF0AFE  size 437  gfx_blit_rounded (alias sub_FFEF0949)
 * Caller: sub_FFEF690B (text/number box, doc 31).  Opaque copy of the
 * bitmap but only between per-row start/end columns taken from 6-byte
 * span tables for the five box heights 0x10/0x14/0x1C/0x26/0x34 (rounded
 * ends); other heights copy whole rows.  Copies in 32-bit pairs, so a span
 * always moves at least one pair.                            Confirmed */
void gfx_blit_rounded(u16 x, u16 y, const bmp_desc_t *d)
{
    u16 s, e, n, row, k;
    if (d == 0) return;
    if (CLIPPED(x, y, d->w, d->h)) return;
    for (row = 0; row < d->h; row++) {
        rounded_span(d->w, d->h, row, &s, &e);
        const u32 *src = (const u32 *)&d->pix[(u32)d->w * row + s];
        u32 *dst = (u32 *)&FB(x + s, y + row);
        n = (u16)((e - s + 1) / 2);
        *dst = *src;
        for (k = 1; k < n; k++) *++dst = *++src;
    }
}

/* FFEF0AFE-FFEF0BD4  size 214  gfx_erase_shape (alias sub_FFEF0AFE)
 * Caller: sub_FFEF6C42 (x40, doc 31 "bitmap compositor").  For every
 * non-key pixel of the bitmap, restore the background-layer pixel at that
 * screen position: erases exactly the shape a previous blit drew. Confirmed */
void gfx_erase_shape(u16 x, u16 y, const bmp_desc_t *d)
{
    if (d == 0 || CLIPPED(x, y, d->w, d->h)) return;
    for (u16 row = 0; row < d->h; row++)
        for (u16 col = 0; col < d->w; col++) {
            u32 off = (u32)(y + row) * LCD_W + x + col;
            if (d->pix[(u32)d->w * row + col] != d->key)
                cur_surface->base[off] = BASE_FRAME[off];
        }
}

/* FFEF0BD4-FFEF0D92  size 446  gfx_erase_rounded (alias sub_FFEF0BD4)
 * Caller: sub_FFEF690B.  Same spans as gfx_blit_rounded but the source is
 * the background layer at the same screen offset (descriptor supplies only
 * w and h).                                                   Confirmed */
void gfx_erase_rounded(u16 x, u16 y, const bmp_desc_t *d)
{
    u16 s, e, n, row, k;
    if (d == 0 || CLIPPED(x, y, d->w, d->h)) return;
    for (row = 0; row < d->h; row++) {
        rounded_span(d->w, d->h, row, &s, &e);
        u32 off = (u32)(y + row) * LCD_W + x + s;
        const u32 *src = (const u32 *)&BASE_FRAME[off];
        u32 *dst = (u32 *)&cur_surface->base[off];
        n = (u16)((e - s + 1) / 2);
        *dst = *src;
        for (k = 1; k < n; k++) *++dst = *++src;
    }
}

/* FFEF0D92-FFEF0FCC  size 570  gfx_draw_bitmap_whites (alias sub_FFEF0D92)
 * Caller: sub_FFEFAB3E (coloured text).  Modes 1 and 2 as gfx_draw_bitmap;
 * the default mode copies only source pixels equal to 0xFFFF (no key
 * test) - used for white-on-transparent glyph art.          Confirmed */
void gfx_draw_bitmap_whites(u16 x, u16 y, const bmp_desc_t *d)
{
    if (d == 0 || CLIPPED(x, y, d->w, d->h)) return;
    for (u16 row = 0; row < d->h; row++)
        for (u16 col = 0; col < d->w; col++) {
            u16 p = d->pix[(u32)d->w * row + col];
            if (d->mode == 1) { if (p != d->key) FB(x + col, y + row) = blend565(d->key, d->tint, (u8)(p * 100u / 0xFFFFu)); }
            else if (d->mode == 2) { if (p != d->key) FB(x + col, y + row) = (u16)~p; }
            else if (p == 0xFFFF) FB(x + col, y + row) = p;
        }
}

/* FFEF0FCC-FFEF121F  size 595  gfx_draw_bitmap_2x (alias sub_FFEF0FCC)
 * Caller: sub_FFEE4BB7.  Pixel-doubled gfx_draw_bitmap (no 32-bit fast
 * path).  Quirk: the clip test uses 4*w and 4*h (the doubled size doubled
 * again), so it rejects sprites that would still fit.         Confirmed */
void gfx_draw_bitmap_2x(u16 x, u16 y, const bmp_desc_t *d)
{
    u16 W, H;
    if (d == 0) return;
    W = (u16)(d->w << 1); H = (u16)(d->h << 1);
    if ((u32)W * 2 > LCD_W - x || (u32)H * 2 > LCD_H - y) return;
    for (u16 row = 0; row < H; row++)
        for (u16 col = 0; col < W; col++) {
            u16 p = d->pix[(u32)(W >> 1) * (row >> 1) + (col >> 1)];
            if (p == d->key) continue;
            if (d->mode == 1)      FB(x + col, y + row) = blend565(d->key, d->tint, (u8)(p * 100u / 0xFFFFu));
            else if (d->mode == 2) FB(x + col, y + row) = (u16)~p;
            else                   FB(x + col, y + row) = p;
        }
}

/* FFEF121F-FFEF13A1  size 386  gfx_draw_bitmap_dim (alias sub_FFEF121F)
 * Callers: widget_draw, sub_FFF0C46F.  Key-transparent blit with every
 * channel pulled half-way toward grey (13,27,13) = 0x6B6D: the "disabled /
 * inactive" look of widget icons.                             Confirmed */
void gfx_draw_bitmap_dim(u16 x, u16 y, const bmp_desc_t *d)
{
    if (d == 0 || CLIPPED(x, y, d->w, d->h)) return;
    for (u16 row = 0; row < d->h; row++)
        for (u16 col = 0; col < d->w; col++) {
            u16 p = d->pix[(u32)d->w * row + col];
            if (p == d->key) continue;
            FB(x + col, y + row) = RGB565(half_toward(p >> 11, 0x0D),
                                          half_toward((p & 0x7E0) >> 5, 0x1B),
                                          half_toward(p & 0x1F, 0x0D));
        }
}

/* FFEF13A1-FFEF153B  size 410  gfx_draw_bitmap_dark (alias dead_FFEF13A1)
 * Dead (doc 127).  As above but toward black, and a pure-white source pixel
 * is first rewritten IN THE SOURCE to red 0xF800 (a write to the bitmap,
 * harmless only because flash ignores it) and treated as (31,0,0). Confirmed */
void gfx_draw_bitmap_dark(u16 x, u16 y, const bmp_desc_t *d)
{
    if (d == 0 || CLIPPED(x, y, d->w, d->h)) return;
    for (u16 row = 0; row < d->h; row++)
        for (u16 col = 0; col < d->w; col++) {
            u16 *s = (u16 *)&d->pix[(u32)d->w * row + col];
            u8 r, g, b;
            if (*s == d->key) continue;
            if (*s == 0xFFFF) { *s = 0xF800; r = 0x1F; g = 0; b = 0; }
            else { r = *s >> 11; g = (*s & 0x7E0) >> 5; b = *s & 0x1F; }
            FB(x + col, y + row) = RGB565(half_toward(r, 0), half_toward(g, 0), half_toward(b, 0));
        }
}

/* FFEF153B-FFEF17DB  size 672  surface_xform_copy (alias sub_FFEF153B)
 * Callers: surface_fill_from_base, gfx_erase_rect, gfx_draw_bitmap_rot1/3/5,
 * sub_FFF0C9A5.  Copy rectangle sr of surface src (row stride taken from
 * src->r.w, origin src->r.x/y) to rectangle dr of dst (stride 320) with one
 * of 11 orientation modes.  Modes 0,1,4,5 swap the loop bounds (90-degree
 * turns); 2,3 are 180 degrees; 6..9 are mirrors; 0x0E is a plain copy.
 * Even modes 0/2/4/6/8 assume a source stride padded to a multiple of 6,
 * modes 7/9 to a multiple of 2 (Inferred: decoder output formats); modes
 * 1,3,5 treat source pixel 0 as transparent.                 Confirmed */
void surface_xform_copy(const surface_t *src, const rect_t *sr, u32 mode,
                        surface_t *dst, const rect_t *dr /* stack */)
{
    u16 nc = 0, nr = 0, row, col;        /* var_1A = columns, var_1C = rows */
    u32 si = 0;
    const rect_t *g = &src->r;           /* x=+2, y=+4, w=+6 of the surface */
    if (mode == 0x0E || (mode >= 2 && mode <= 3) || (mode >= 6 && mode <= 9)) { nc = sr->w; nr = sr->h; }
    else if (mode <= 1 || (mode >= 4 && mode <= 5))                          { nc = sr->h; nr = sr->w; }

    for (row = 0; row < nr; row++)
        for (col = 0; col < nc; col++) {
            switch (mode) {
            case 0:  si = ((g->w + 5) / 6) * (g->y + nc - col - 1) * 6 + g->x + row;          break;
            case 1:  si = (u32)(g->y + nc - col - 1) * g->w + g->x + row;                     break;
            case 2:  si = ((nc + 5) / 6) * (g->y + nr - row - 1) * 6 + g->x + nc - col - 1;   break;
            case 3:  si = (u32)(g->y + nr - row - 1) * nc + g->x + nc - col - 1;              break;
            case 4:  si = ((g->w + 5) / 6) * (g->y + col) * 6 + g->x + nr - row - 1;          break;
            case 5:  si = (u32)(g->y + col) * g->w + g->x + nr - row - 1;                     break;
            case 6:  si = ((nc + 5) / 6) * (g->y + nr - row - 1) * 6 + g->x + col;            break;
            case 7:  si = ((nc + 1) / 2) * (g->y + nr - row - 1) * 2 + g->x + col;            break;
            case 8:  si = ((nc + 5) / 6) * (g->y + row) * 6 + g->x + nc - col - 1;            break;
            case 9:  si = ((nc + 1) / 2) * (g->y + row) * 2 + g->x + nc - col - 1;            break;
            case 0x0E: si = (u32)(sr->y + row) * LCD_W + sr->x + col;                         break;
            default: break;                    /* si keeps its previous value */
            }
            u16 *s = &src->base[si];
            u16 *o = &dst->base[(u32)(dr->y + row) * LCD_W + dr->x + col];
            if (mode == 1 || mode == 3 || mode == 5) { if (*s != 0) *o = *s; }
            else *o = *s;
        }
}

/* FFEF17DB-FFEF1841  size 102  gfx_draw_bitmap_rot1 (alias sub_FFEF17DB)
 * FFEF1841-FFEF18A7  size 102  gfx_draw_bitmap_rot3 (alias sub_FFEF1841)
 * FFEF18A7-FFEF190D  size 102  gfx_draw_bitmap_rot5 (alias sub_FFEF18A7)
 * Caller of all three: screen2E_draw_row_body (the GM bearing arrow).
 * Wrap a bitmap descriptor as a source surface {0,0,w,h,pix} and copy it
 * to (x,y) of the current surface with surface_xform_copy mode 1, 3 or 5
 * (90 / 180 / 270 degrees, 0 = transparent).               Confirmed */
static void gfx_draw_bitmap_xform(u16 x, u16 y, const bmp_desc_t *d, u32 mode)
{
    surface_t src = { 0, 0, {0, 0, d->w, d->h}, 0, (u16 *)d->pix };
    surface_t dst = { 0, 0, {0, 0, LCD_W, LCD_H}, 0, cur_surface->base };
    rect_t dr = { x, y, d->w, d->h };
    surface_xform_copy(&src, &src.r, mode, &dst, &dr);
}
void gfx_draw_bitmap_rot1(u16 x, u16 y, const bmp_desc_t *d) { gfx_draw_bitmap_xform(x, y, d, 1); }
void gfx_draw_bitmap_rot3(u16 x, u16 y, const bmp_desc_t *d) { gfx_draw_bitmap_xform(x, y, d, 3); }
void gfx_draw_bitmap_rot5(u16 x, u16 y, const bmp_desc_t *d) { gfx_draw_bitmap_xform(x, y, d, 5); }

/* FFEF190D-FFEF1A16  size 265  gfx_draw_glyph (alias sub_FFEF190D)
 * 24 callers (docs 27/45/139: "double-byte glyph blit").  Codes 0..0x1F are
 * skipped except 6, which is drawn as code 0xDF.  The 1-bpp glyph is expanded
 * into the scratch buffer 0x07070800 (2x when scale==1), then every non-zero
 * pixel is copied (white) to the current surface.  If the lookup fails the
 * expansion is skipped but the copy still runs on the stale w/h (latent bug,
 * not triggered by valid fonts).                              Confirmed */
void gfx_draw_glyph(u16 x, u16 y, u8 font, u16 code, u8 scale /* stack */)
{
    glyph_t g; u16 w, h;
    u16 *buf = GLYPH_SCRATCH;
    if (code != 6 && code <= 0x1F) return;
    if (code == 6) code = 0xDF;
    font_glyph_lookup(font, code, &g);
    if (scale == 1) { glyph_expand_2x(&g, buf); w = g.w << 1; h = g.h << 1; }
    else            { glyph_expand_1x(&g, buf); w = g.w;      h = g.h; }
    if (CLIPPED(x, y, w, h)) return;
    for (u16 r = 0; r < h; r++)
        for (u16 c = 0; c < w; c++) {
            u16 p = buf[(u32)w * r + c];
            if (p != 0) FB(x + c, y + r) = p;
        }
}

/* FFEF1A16-FFEF1B23  size 269  gfx_draw_glyph_colour (alias sub_FFEF1A16)
 * Callers: gfx_draw_string_colour, sub_FFEFA924.  As gfx_draw_glyph but set
 * pixels are painted `colour`.                                Confirmed */
void gfx_draw_glyph_colour(u16 x, u16 y, u8 font, u16 code, u8 scale, u16 colour)
{
    glyph_t g; u16 w, h;
    u16 *buf = GLYPH_SCRATCH;
    if (code != 6 && code <= 0x1F) return;
    if (code == 6) code = 0xDF;
    font_glyph_lookup(font, code, &g);
    if (scale == 1) { glyph_expand_2x(&g, buf); w = g.w << 1; h = g.h << 1; }
    else            { glyph_expand_1x(&g, buf); w = g.w;      h = g.h; }
    if (CLIPPED(x, y, w, h)) return;
    for (u16 r = 0; r < h; r++)
        for (u16 c = 0; c < w; c++)
            if (buf[(u32)w * r + c] != 0) FB(x + c, y + r) = colour;
}

/* FFEF1B23-FFEF1BB1  size 142  gfx_draw_string (alias sub_FFEF1B23)
 * 95 callers (doc 08 "draw_string", doc 45: stops at NUL).  Draws up to
 * maxlen single-byte codes; 0xFF prints as space; stops at NUL or when the
 * next glyph would pass x=320.  Advance = glyph width (x2 at scale 1) +
 * spacing.                                                     Confirmed */
void gfx_draw_string(u16 x, u16 y, u8 font, u8 spacing, u8 maxlen /* stack */,
                     const u8 *s, u8 scale)
{
    u16 off = 0;
    for (u8 i = 0; i < maxlen; i++) {
        u8 ch = s[i], w;
        if (ch == 0) return;
        if (ch == 0xFF) ch = ' ';
        w = glyph_width(font, ch);
        if (scale == 1) w <<= 1;
        if (x + off + w > LCD_W) return;
        gfx_draw_glyph(x + off, y, font, ch, scale);
        off += w + spacing;
    }
}

/* FFEF1BB1-FFEF1C48  size 151  gfx_draw_string_colour (alias sub_FFEF1BB1)
 * Callers: sub_FFEFA924, sub_FFF08201, sub_FFF0DE56, sub_FFF448F5.  Confirmed */
void gfx_draw_string_colour(u16 x, u16 y, u8 font, u8 spacing, u8 maxlen,
                            const u8 *s, u8 scale, u16 colour)
{
    u16 off = 0;
    for (u8 i = 0; i < maxlen; i++) {
        u8 ch = s[i], w;
        if (ch == 0) return;
        if (ch == 0xFF) ch = ' ';
        w = glyph_width(font, ch);
        if (scale == 1) w <<= 1;
        if (x + off + w > LCD_W) return;
        gfx_draw_glyph_colour(x + off, y, font, ch, scale, colour);
        off += w + spacing;
    }
}

/* FFEF1C48-FFEF1C79  size 49  gfx_fill_rect (alias sub_FFEF1C48)
 * 95 callers.                                                 Confirmed */
void gfx_fill_rect(u16 x, u16 y, u16 w, u16 h, u16 colour /* stack */)
{
    rect_t r = { x, y, w, h };
    surface_fill_rect(cur_surface, &r, colour);
}

/* FFEF1C79-FFEF1DDA  size 353  gfx_fill_gradient (alias sub_FFEF1C79)
 * Caller: sub_FFEE9A8E.  Vertical gradient: row 0 = c_top, last row =
 * c_bottom, linear in between (pct = 100 - (1000000/(h-1))*row/10000).
 * Confirmed */
void gfx_fill_gradient(u16 x, u16 y, u16 w, u16 h, u16 c_bottom, u16 c_top)
{
    for (u16 row = 0; row < h; row++) {
        u8 pct;
        if (row == 0) pct = 100;
        else if (row == h - 1) pct = 0;
        else pct = (u8)(100 - (u8)((1000000u / (h - 1)) * row / 10000u));
        u16 c = blend565(c_bottom, c_top, pct);
        for (u16 col = 0; col < w; col++) FB(x + col, y + row) = c;
    }
}

/* ==========================================================================
 * EXDMAC channel 0 -> LCD.  Register names follow the RX64M manual
 * (EDMCRA at +0x08 = 32-bit reload|count, EDMCRB at +0x0C = 16-bit block
 * count); doc 02 has these two swapped, see NOTES.md.
 * ======================================================================== */

/* FFEF1DDA-FFEF1E28  size 78  exdmac0_init (alias sub_FFEF1DDA)
 * Caller: sub_FFEDEEFC (boot).                                Confirmed */
void exdmac0_init(void)
{
    ICU_IER0F &= ~0x40;                 /* mask vector 126                     */
    EDMCNT &= ~0x01;                    /* DTE = 0                             */
    EDMAMD = 0x8000;
    EDMTMD = 0x8100;                    /* block transfer, 16-bit units        */
    EDMINT |= 0x10;                     /* DTIE                                */
    EDMAST |= 0x01;                     /* EXDMAC module start                 */
    EDMCNT |= 0x01;                     /* DTE = 1                             */
    ICU_IPR126 = (u8)((ICU_IPR126 | 5) & 0xF5);   /* priority 5           */
}

/* FFEF1E28-FFEF1E35  size 13  exdmac0_isr (alias vec_intb_126)
 * INTB vector 126 (docs 02/20): dummy-read EDMSTS, rte.         Confirmed */
void exdmac0_isr(void) { (void)EDMSTS; }

/* FFEF1E35-FFEF1E4C  size 23  exdmac0_kick (alias sub_FFEF1E35)  Confirmed */
void exdmac0_kick(void)
{
    ICU_IER0F |= 0x40;
    EDMCNT |= 0x01;
    EDMREQ = 0x11;                      /* SWREQ | CLRS: software start        */
}

/* FFEF1E4C-FFEF1E63  size 23  exdmac0_stop (alias sub_FFEF1E4C)
 * Callers: sub_FFEDEEFC, lcd_flush_start.                     Confirmed */
void exdmac0_stop(void)
{
    ICU_IER0F &= ~0x40;
    EDMCNT &= ~0x01;
    EDMREQ = 0;
}

/* FFEF1E63-FFEF1E84  size 33  exdmac0_done (alias sub_FFEF1E63)
 * Callers: sub_FFEDDF3A, lcd_flush_poll.  EDMSTS bit 4 (DTIF). Confirmed */
u8 exdmac0_done(void) { return ((EDMSTS >> 4) & 1) == 1 ? 1 : 0; }

/* FFEF1E84-FFEF1EFA  size 118  surface_pack_rect (alias sub_FFEF1E84)
 * Copy a non-full-width dirty rectangle into the contiguous buffer
 * 0x07096000 so one linear DMA can send it; returns that address. Confirmed */
u16 *surface_pack_rect(const surface_t *s)
{
    u16 h = s->r.h, w = s->r.w;
    for (u16 r = 0; r < h; r++)
        for (u16 c = 0; c < w; c++)
            PACK_BUF[(u32)r * w + c] = s->base[(u32)(s->r.y + r) * LCD_W + s->r.x + c];
    return PACK_BUF;
}

/* FFEF1EFA-FFEF201A  size 288  lcd_flush_start (alias sub_FFEF1EFA)
 * Caller: lcd_flush_poll.  Doc 16/20's FFEF1F74/1F80/1F90/1FC2/1FD1/1FDF/
 * 1FEB/1FF2 are interior labels of this one routine (doc 68).  Chooses the
 * DMA source (whole buffer / full-width band in place / packed copy), sets
 * destination 0x06000000, sizes the transfer as blocks of max(w,h) pixels
 * (or one block of w*h when < 0x400), opens the LCD window and starts.
 * Confirmed */
void lcd_flush_start(const surface_t *s)
{
    u32 n; u16 w, h;
    exdmac0_stop();
    int full = (s->r.x == 0 && s->r.y == 0 && s->r.w == LCD_W && s->r.h == LCD_H);
    if (!full) {
        if (s->r.x == 0 && s->r.w == LCD_W)
            EDMSAR = (u32)s->base + (u32)s->r.y * LCD_W * 2;
        else
            EDMSAR = (u32)surface_pack_rect(s);
    } else {
        EDMSAR = (u32)s->base;
    }
    EDMDAR = 0x06000000;
    n = (u32)s->r.w * s->r.h;
    if (n >= 0x400) {
        w = s->r.w; h = s->r.h;
        if (w > h) { EDMCRB = h; n = w; }
        else       { EDMCRB = w; n = h; }
    } else {
        EDMCRB = 1;
    }
    EDMCRA = n << 16;
    EDMCRA |= n;
    lcd_set_window(s->r.x, s->r.w - 1, s->r.y, s->r.h - 1);
    exdmac0_kick();
}

/* FFEF201A-FFEF2022  size 8  lcd_display_on (alias sub_FFEF201A)
 * MAIN command F001 (doc 51): LCD controller command 0x29.      Confirmed */
void lcd_display_on(void)  { lcd_cmd(0x29); }

/* FFEF2022-FFEF202A  size 8  lcd_display_off (alias sub_FFEF2022)
 * MAIN command F000: command 0x28.                               Confirmed */
void lcd_display_off(void) { lcd_cmd(0x28); }

/* FFEF202A-FFEF2032  size 8  lcd_display_off_unused (alias dead_FFEF202A)
 * Byte-identical unreferenced copy of the above (docs 62/127).    Confirmed */
void lcd_display_off_unused(void) { lcd_cmd(0x28); }

/* FFEF2032-FFEF2033  size 1  nop_callback (alias sub_FFEF2032)
 * Bare rts; the default slot of many handler tables (doc 46: 719 slots). */
void nop_callback(void) { }

/* FFEF2033-FFEF208D  size 90  bcd_to_text_blank (alias dead_FFEF2033)
 * Dead.  BCD -> ASCII of `ndig` digits, then leading '0's become spaces
 * while at least `keep` digits remain.                         Confirmed */
void bcd_to_text_blank(const u8 *bcd, u8 ndig, u8 keep, char *buf)
{
    bcd_to_ascii(bcd, ndig, buf);
    for (u8 i = 0; i < ndig - 1; i++) {
        if (buf[i] == '0' && i < ndig - keep) buf[i] = ' ';
        else return;
    }
}

/* FFEF208D-FFEF20DD  size 80  sync_bytes_post_lo (alias sub_FFEF208D)
 * 39 callers; doc 50's per-field store helper.  Copies n bytes src->dst and
 * posts lo-word event `mask` for every byte that differed; returns 1 if any
 * did.                                                         Confirmed */
u8 sync_bytes_post_lo(u8 *dst, const u8 *src, u8 n, u32 mask)
{
    u8 changed = 0;
    for (; (s8)n > 0; n--, dst++, src++) {
        if (*dst != *src) { ui_event_post_lo(mask); changed = 1; }
        *dst = *src;
    }
    return changed;
}

/* FFEF20DD-FFEF212D  size 80  sync_bytes_post_hi (alias sub_FFEF20DD)
 * 9 callers.  Same, hi-word events.                            Confirmed */
u8 sync_bytes_post_hi(u8 *dst, const u8 *src, u8 n, u32 mask)
{
    u8 changed = 0;
    for (; (s8)n > 0; n--, dst++, src++) {
        if (*dst != *src) { ui_event_post_hi(mask); changed = 1; }
        *dst = *src;
    }
    return changed;
}

/* FFEF212D-FFEF2184  size 87  sync_bytes_post2 (alias dead_FFEF212D)
 * Dead.  Same, posting both words via ui_event_post2.          Confirmed */
u8 sync_bytes_post2(u8 *dst, const u8 *src, u8 n, u32 hi, u32 lo /* stack */)
{
    u8 changed = 0;
    for (; (s8)n > 0; n--, dst++, src++) {
        if (*dst != *src) { ui_event_post2(hi, lo); changed = 1; }
        *dst = *src;
    }
    return changed;
}

/* FFEF2184-FFEF2261  size 221  font_glyph_lookup (alias sub_FFEF2184)
 * Callers: gfx_draw_glyph(_colour).  Doc 27 sec.3 / doc 79 (resolver).
 * Fonts 0..7 share the 8 JIS blocks of FFED4644 (first block whose
 * base_code <= code); fonts 8..0x19 index their own block.  Code 0x80 is
 * returned at half width.                                      Confirmed */
void font_glyph_lookup(u8 font, u16 code, glyph_t *out)
{
    u8 b;
    if (code == 0 || font >= 0x1A) { out->src = 0; return; }
    if (font <= 7) {
        for (b = 0; b < 8; b++)
            if (code >= font_tbl[b].base_code) break;
        if (b == 8) { out->src = 0; return; }
    } else {
        b = font;
    }
    out->w = glyph_width(b, code);
    out->h = font_tbl[b].h;
    u16 ord = font_tbl[b].ord_tbl[code - font_tbl[b].base_code];
    out->src = font_tbl[b].pix + (u32)out->h * ord * ((out->w + 7) / 8);
    out->flag = 0;
    if (code == 0x80) out->w >>= 1;
}

/* FFEF2261-FFEF2317  size 182  glyph_expand_1x (alias sub_FFEF2261)
 * 1-bpp MSB-first rows -> 0xFFFF/0x0000 pixels, w (low byte) x h. Confirmed */
void glyph_expand_1x(const glyph_t *g, u16 *dst)
{
    if (g->src == 0 || g->w >= LCD_W || g->h >= LCD_H) return;
    u8 bpr = (u8)((g->w + 7) / 8), w = (u8)g->w;
    for (u16 r = 0; r < g->h; r++)
        for (u16 c = 0; c < w; c++) {
            u8 byte = g->src[r * bpr + (c >> 3)];
            dst[(u16)(w * r + c)] = (byte >> (7 - (c & 7))) & 1 ? 0xFFFF : 0;
        }
}

/* FFEF2317-FFEF23EE  size 215  glyph_expand_2x (alias sub_FFEF2317)
 * Same, each source pixel becomes a 2x2 block.                   Confirmed */
void glyph_expand_2x(const glyph_t *g, u16 *dst)
{
    if (g->src == 0 || g->w >= LCD_W || g->h >= LCD_H) return;
    u8 bpr = (u8)((g->w + 7) / 8), w2 = (u8)(g->w * 2), h2 = (u8)(g->h * 2);
    for (u16 r = 0; r < h2; r++) {
        u16 sc = 0;
        for (u16 c = 0; c < w2; c += 2, sc++) {
            u8 byte = g->src[(r >> 1) * bpr + (sc >> 3)];
            u16 p = (byte >> (7 - (sc & 7))) & 1 ? 0xFFFF : 0;
            dst[(u16)(w2 * r + c)] = p;
            dst[(u16)(w2 * r + c) + 1] = p;
        }
    }
}

/* ==========================================================================
 * Widgets.  A screen is a list of widgets.  MAIN's frame carries, per widget,
 * an icon index and a draw state in two parallel byte arrays inside ui_shadow;
 * widget_lookup knows, for each (op, sub) screen, where those arrays live and
 * which rectangle table (layout_tbl[layout]) positions them.
 * ======================================================================== */

/* FFEF23EE-FFEF246D  size 127  screen_redraw_widget_by_event (alias sub_FFEF23EE)
 * No direct caller (reached through a screen event table).  Widget index =
 * cur_event - event_base_tbl[screen_label_index()] (byte table at FFC3D8AC,
 * just after the "TN TSQ DCS..." squelch-type strings that IDA named it by);
 * redraws that widget in its own rectangle.                    Confirmed */
void screen_redraw_widget_by_event(void)
{
    u8 k = cur_event - event_base_tbl[screen_label_index()];
    widget_ctx_t c = { ui_shadow[0], ui_shadow[1], 0, k, 0, 0 };
    widget_lookup(&c);
    const rect_t *r = &layout_tbl[c.layout][k];
    if (surface_begin(&main_surface, r->x, r->y, r->w, r->h) == 1) {
        widget_draw(k);
        surface_main_commit();
    }
}

/* FFEF246D-FFEF2505  size 152  widget_icon_override (alias sub_FFEF246D)
 * Caller: widget_draw (screen F1/0D and F1/0F, state 3).  Icons 0x2B..0x2D are
 * drawn here directly (bitmap FFED244C on sub 0x0D, FFED39AC otherwise);
 * icons 0x28/0x29/0x2A get a substitute bitmap in rec->desc.  Confirmed */
void widget_icon_override(const widget_ctx_t *c, icon_rec_t *rec)
{
    u8 icon = c->icon, sub = c->sub;
    const rect_t *r = &layout_tbl[c->layout][c->id];
    if (icon >= 0x2B && icon <= 0x2D) {
        extern const bmp_desc_t bmp_FFED244C, bmp_FFED39AC;
        draw_bitmap_or_erase(r->x, r->y, 1, sub == 0x0D ? &bmp_FFED244C : &bmp_FFED39AC);
        return;
    }
    extern const bmp_desc_t bmp_FFED1E6C, bmp_FFED1E8C, bmp_FFED0B7C;
    if (icon == 0x29) rec->desc = &bmp_FFED1E8C;
    else if (icon == 0x2A) rec->desc = &bmp_FFED0B7C;
    else if (icon == 0x28) rec->desc = &bmp_FFED1E6C;
}

/* FFEF2505-FFEF2724  size 543  widget_draw (alias sub_FFEF2505)
 * ~83 callers; doc 79's "draw widget N" renderer.             Confirmed
 * state: 0 hidden (area erased only), 1 dimmed, 2 normal, 3 alternate (dimmed,
 * or the F1/0D,0F override), 4 blinking (3/2 by blink phase).  Icons 2..5 get a
 * backing frame (bitmap FFECF14C) 14 px below the widget origin first.
 * Correction to doc 79: icon_rec +9..+0x12 is the text (10 chars) and +0x14 the
 * character spacing; the routine draws text records at 2x (scale arg 1). */
void widget_draw(u8 id)
{
    widget_ctx_t c = { ui_shadow[0], ui_shadow[1], 0, id, 0, 0 };
    icon_rec_t rec;
    const rect_t *r;
    u8 st;

    widget_lookup(&c);
    if (c.state == 4) c.state = (blink_on() == 1) ? 3 : 2;
    r = &layout_tbl[c.layout][id];
    if (r->w == 0) return;
    if (!(c.op == 0xF1 && c.sub == 0x0D && c.state == 3))
        gfx_erase_rect(r->x, r->y, r->w, r->h);
    if (c.state == 0) return;
    /* FFEF25A3..25C9 computes (op==0xF5&&sub==0x11)||sub==0x18 and never uses it */
    widget_icon_fetch(&c, &rec);
    if (rec.kind == 1) {
        gfx_draw_string(r->x + rec.x_off, r->y + rec.y_off, rec.font, rec.spacing,
                        10, (const u8 *)rec.text, 1);
        return;
    }
    if (rec.kind != 2) return;
    st = c.state;
    if (c.icon >= 2 && c.icon <= 5) {
        if (st == 2) draw_bitmap_or_erase(r->x, r->y + 0x0E, 1, &bmp_FFECF14C);
        else         gfx_draw_bitmap_dim(r->x, r->y + 0x0E, &bmp_FFECF14C);
    }
    if (st == 2) { draw_bitmap_or_erase(r->x + rec.x_off, r->y + rec.y_off, 1, rec.desc); return; }
    if (st == 1) { gfx_draw_bitmap_dim(r->x + rec.x_off, r->y + rec.y_off, rec.desc);     return; }
    if (c.op == 0xF1 && (c.sub == 0x0D || c.sub == 0x0F)) {
        widget_icon_override(&c, &rec);
        draw_bitmap_or_erase(r->x + rec.x_off, r->y + rec.y_off, 1, rec.desc);
        return;
    }
    gfx_draw_bitmap_dim(r->x + rec.x_off, r->y + rec.y_off, rec.desc);
}

/* FFEF2724-FFEF34B1  size 3469  widget_lookup (alias sub_FFEF2724)
 * 20 callers.  Doc 34 / ida/out/sub-tier2/ffef2724.c named it a "settings
 * field fetch" with d[3] a base adjust and d[2] a value-type tag; the callers
 * (widget_draw, screen_redraw_widget_by_event) show d[3] is the widget index,
 * d[2] the layout-table index, d[4] the icon index and d[5] the draw state:
 *     c->icon  = ui_shadow[ICON  + c->id];
 *     c->state = ui_shadow[STATE + c->id];
 *     c->layout = LAYOUT;
 * Primary jump table FFF480CE on op-0xF0 (14 entries), F1 secondary table
 * FFF480EA on sub (22 entries), other ops use cmp chains.  Every (op,sub)
 * mapping below was read off the listing.                    Confirmed */
#define W(ICON, STATE, LAYOUT) do { c->icon = ui_shadow[(ICON) + c->id]; \
        c->state = ui_shadow[(STATE) + c->id]; c->layout = (LAYOUT); return; } while (0)
void widget_lookup(widget_ctx_t *c)
{
    u8 op = c->op, sub = c->sub;
    if ((u8)(op - 0xF0) > 0x0D) return;
    switch (op) {
    case 0xF0:
        switch (sub) {
        case 3: case 4: W(0x3F, 0x2B, 0x02);
        case 6:         W(0x3A, 0x26, 0x02);
        case 9:         W(0x24, 0x22, 0x13);
        case 0x0A:      W(0x23, 0x21, 0x13);
        case 0x0B:      W(0x24, 0x22, 0x0A);
        }
        return;
    case 0xF1:
        switch (sub) {
        case 0x00:           W(0xBF, 0xB9, 0x0C);
        case 0x01: case 0x15:W(0x83, 0x7D, 0x0C);
        case 0x03:           W(0xD0, 0xCA, 0x0C);
        case 0x04: case 0x05:W(0x78, 0x6C, 0x01);
        case 0x06:           W(0x7C, 0x6C, 0x00);
        case 0x07:           W(0x80, 0x6C, 0x02);
        case 0x08: case 0x09: case 0x0A: W(0x93, 0x7F, 0x02);
        case 0x0B:                               /* by ui_shadow[0x6D]      */
            switch (ui_shadow[0x6D]) {
            case 0: c->icon = ui_shadow[0x84 + c->id]; c->state = ui_shadow[0x81 + c->id]; break;
            case 1: c->icon = ui_shadow[0x98 + c->id]; c->state = ui_shadow[0x95 + c->id]; break;
            case 2: c->icon = ui_shadow[0xC0 + c->id]; c->state = ui_shadow[0xBD + c->id]; break;
            }
            c->layout = 0x06; return;
        case 0x0C:           W(0xE3, 0xDD, 0x10);
        case 0x0D:           W(0x98, 0x92, 0x10);
        case 0x0E:           W(0x100, 0xFB, 0x11);
        case 0x0F:           W(0xB4, 0xAF, 0x11);
        case 0x12:           W(0x9F, 0x9C, 0x06);
        case 0x13:                               /* by ui_shadow[0x6C] (doc 34 said 0x6D) */
            switch (ui_shadow[0x6C]) {
            case 0: c->icon = ui_shadow[0x90 + c->id]; c->state = ui_shadow[0x8D + c->id]; break;
            case 1: c->icon = ui_shadow[0xA4 + c->id]; c->state = ui_shadow[0xA1 + c->id]; break;
            case 2: c->icon = ui_shadow[0xCC + c->id]; c->state = ui_shadow[0xC9 + c->id]; break;
            }
            c->layout = 0x06; return;
        case 0x14:           W(0x96, 0x90, 0x0C);
        default:             return;              /* 2, 0x10, 0x11, >0x15 */
        }
    case 0xF2:
        if (sub == 0x80) W(0x45, 0x31, 0x02);
        W(0x27, 0x23, 0x03);
    case 0xF3:
        switch (sub) {
        case 0x00:           W(0x2E, 0x22, 0x04);
        case 0x41: case 0x4B:W(0x23, 0x21, 0x0A);
        case 0x71:           W(0x27, 0x26, 0x08);
        case 0x8A:           W(0x29, 0x28, 0x08);
        case 0x92:           W(0x2A, 0x27, 0x06);
        case 0x96:           W(0x22, 0x21, 0x08);
        case 0xB3:           W(0x3F, 0x2B, 0x02);
        case 0xB8:           W(0x3E, 0x2A, 0x02);
        case 0xBA:           W(0x30, 0x2F, 0x12);
        case 0xC3:           W(0x6F, 0x6D, 0x0B);
        case 0xD1:           W(0x65, 0x63, 0x0A);
        case 0x66:           W(0x58, 0x55, 0x06);
        case 0xD2:           W(0x41, 0x3E, 0x06);
        case 0xD3:           W(0x75, 0x72, 0x06);
        }
        return;
    case 0xF4:
        switch (sub) {
        case 1: W(0x65, 0x62, 0x06);
        case 2: W(0x91, 0x8E, 0x06);
        case 3: W(0x80, 0x7D, 0x06);
        case 4: W(0x78, 0x75, 0x06);
        }
        return;
    case 0xF5:
        switch (sub) {
        case 0x00: W(0x8C, 0x83, 0x0E);
        case 0x01: W(0x52, 0x49, 0x0E);
        case 0x02: W(0x91, 0x88, 0x0E);
        case 0x03: W(0x54, 0x4B, 0x0E);
        case 0x10: W(0x91, 0x88, 0x0E);
        case 0x11: W(0xDA, 0xD4, 0x0C);
        case 0x12: W(0x73, 0x6D, 0x0D);
        case 0x13: W(0x3E, 0x2A, 0x02);
        case 0x14: W(0x5D, 0x49, 0x02);
        case 0x15: W(0x48, 0x34, 0x02);
        case 0x16: W(0x8C, 0x8B, 0x07);
        case 0x17: W(0x5F, 0x5D, 0x0B);
        case 0x18: W(0xDB, 0xD2, 0x0E);
        }
        return;
    case 0xF6:
        switch (sub) {
        case 0x10: W(0xA2, 0x9E, 0x0F);
        case 0x20: W(0x9C, 0x99, 0x06);
        case 0x21: W(0x87, 0x84, 0x06);
        case 0x22: W(0x9B, 0x9A, 0x07);
        case 0x23: W(0x49, 0x35, 0x02);
        case 0x30: W(0x5C, 0x58, 0x0F);
        case 0x31: W(0x58, 0x54, 0x0F);
        case 0x32: W(0x38, 0x34, 0x0F);
        case 0x40: W(0x33, 0x30, 0x06);
        }
        return;
    case 0xF7:
        switch (sub) {
        case 0: W(0x8F, 0x8D, 0x0B);
        case 1: W(0xFE, 0xFB, 0x06);
        case 2: W(0xFD, 0xFB, 0x0B);
        case 3: W(0x77, 0x74, 0x14);
        }
        c->icon = 0; c->state = 0; c->layout = 0x06; return;
    case 0xF8:
        switch (sub) {
        case 0x01: W(0x93, 0x7F, 0x02);
        case 0x10: W(0x9C, 0x99, 0x06);
        case 0x11: W(0x3B, 0x3A, 0x09);
        case 0x12: W(0x3B, 0x39, 0x0B);
        case 0x13: W(0x74, 0x71, 0x06);
        case 0x20: W(0xA1, 0x9E, 0x06);
        case 0x23: W(0xAE, 0xAC, 0x06);
        case 0x24: W(0xB3, 0xB0, 0x06);
        }
        c->icon = 0; c->state = 0; c->layout = 0x06; return;
    case 0xFD:
        if (sub == 0) W(0x81, 0x7E, 0x06);
        return;
    default:                                    /* 0xF9..0xFC */
        return;
    }
}
#undef W

/* FFEF34B1-FFEF3912  size 1121  widget_icon_fetch (alias sub_FFEF34B1)
 * Caller: widget_draw.  Copies icon_tbl[c->icon] (28 bytes, doc 79) and then
 * applies per-screen corrections: offsets {x_off,y_off} and/or a substitute
 * bitmap, keyed on op (jump table on op-0xF1, 8 entries), sub and icon.
 * Case F6 (FFEF3715) is the arm IDA had split off as a function start (doc 54/I2).
 * Confidence: Confirmed (offsets), descriptor names are raw addresses */
#define OFS(X,Y)     do { out->x_off = (X); out->y_off = (Y); } while (0)
#define SUBST(X,Y,D) do { extern const bmp_desc_t D; OFS(X,Y); out->desc = &D; } while (0)
void widget_icon_fetch(const widget_ctx_t *c, icon_rec_t *out)
{
    u8 icon = c->icon, sub = ui_shadow[1];
    *out = icon_tbl[icon];
    switch (ui_shadow[0]) {
    case 0xF1:
        if (sub == 4 || sub == 5) {
            if (icon == 0x78) OFS(0x0D, 0x0C);
            else if (icon == 0x7A) OFS(0x20, 0x0C);
            else if (icon >= 0x96 && icon <= 0x9F) OFS(0x2D, 0x0E);
        } else if (sub == 0x0E || sub == 0x0F) {
            switch (icon) {                      /* byte jump table FFEF35F2 */
            case 0x28: OFS(0x10, 0x09); break;   case 0x29: OFS(0x10, 0x0B); break;
            case 0x2A: OFS(0x06, 0x10); break;   case 0x2B: OFS(0x13, 0x0E); break;
            case 0x2C: OFS(0x11, 0x10); break;   case 0x2D: OFS(0x10, 0x10); break;
            }
        } else if (sub == 8) {
            if (icon == 0xC9)      SUBST(0x0F, 0x0D, bmp_FFED3B7C);
            else if (icon == 0x78) SUBST(0x06, 0x0D, bmp_FFED3B8C);
        } else if (sub == 0x0D) {
            /* nothing */
        } else if (sub == 6) {
            switch (icon) {
            case 0x01: SUBST(0, 0x0E, bmp_FFED1F5C); break;
            case 0xD4: SUBST(0, 0x11, bmp_FFED0CEC); break;
            case 0x21: SUBST(0, 0x11, bmp_FFED0CFC); break;
            case 0x22: SUBST(0, 0x11, bmp_FFED0D9C); break;
            case 0x07: SUBST(0, 0x11, bmp_FFED0C3C); break;
            }
        } else {
            if (icon == 0xE1) {                  /* becomes a text record   */
                OFS(0x0D, 0x07); out->kind = 1; out->font = 0x12; out->spacing = 4;
            } else if (icon == 0x01 && c->state == 3) {
                extern const bmp_desc_t bmp_FFECE78C; out->desc = &bmp_FFECE78C;
            }
        }
        return;
    case 0xF2:
        if (sub == 0x80) return;
        if (icon == 0x79) SUBST(0, 0x0D, bmp_FFED0BBC);
        else if (icon == 0x4D || icon == 0x4E) OFS(0, 0x0D);
        return;
    case 0xF3:
        return;
    case 0xF4:
        if (sub == 3 && icon == 0x78) OFS(0x0D, 0x0E);
        return;
    case 0xF5:
        return;
    case 0xF6:                                   /* FFEF3715 */
        if (sub >= 0x30 && sub <= 0x32) {
            switch (icon) {
            case 0xFC: SUBST(0, 0x0C, bmp_FFED39BC); break;
            case 0x5C: SUBST(0, 0x0C, bmp_FFED0D4C); break;
            case 0x5D: SUBST(0, 0x0C, bmp_FFED0C7C); break;
            case 0x5E: SUBST(0, 0x0C, bmp_FFED1F6C); break;
            case 0x60: SUBST(0, 0x0C, bmp_FFED0D6C); break;
            case 0x6A: SUBST(0, 0x0C, bmp_FFED1F7C); break;
            case 0x5A: SUBST(0, 0x0C, bmp_FFED0C1C); break;
            }
        } else if (sub == 0x20) {
            if (icon == 0x5D) OFS(0x0D, 0x0E);
        } else if (sub == 0x10) {
            if (icon == 0x49 || icon == 0x4D || icon == 0x4E) OFS(0, 0x0C);
            else if (icon == 0x5A) SUBST(0, 0x0C, bmp_FFED0C1C);
        }
        return;
    case 0xF7:
        if (sub == 0) { if (icon == 0x78) OFS(0x0D, 0x0E); }
        else if (sub == 3) {
            if (icon == 0x56)      SUBST(0, 0, bmp_FFED2AFC);
            else if (icon == 0x55) SUBST(0, 0, bmp_FFED2B0C);
            else if (icon == 0x36) SUBST(0, 0, bmp_FFED205C);
        } else if (sub == 1) { if (icon == 0x1F) SUBST(0, 0x0C, bmp_FFED0F0C); }
        return;
    case 0xF8:
        if (icon == 0x78) OFS(0x0D, 0x0E);
        else if (icon == 0x1F) SUBST(0, 0x0E, bmp_FFED0F0C);
        return;
    }
}
#undef OFS
#undef SUBST

/* FFEF3912-FFEF395E  size 76  blink_by_state (alias sub_FFEF3912)
 * Caller: sub_FFEE6C60.  If the new state `a` is 4 (blink) register `m` for
 * blinking, else if the old state `b` was 4 unregister it.  The low byte of m
 * picks the word: non-zero -> lo-word bits, zero -> hi-word bits (Inferred:
 * callers pass small lo masks or hi masks >= 0x100).          Confirmed */
void blink_by_state(u8 a, u8 b, u32 m)
{
    if (a == 4) { if ((u8)m != 0) blink_start(0, m); else blink_start(m, 0); return; }
    if (b == 4) { if ((u8)m != 0) blink_stop (0, m); else blink_stop (m, 0); }
}
