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
