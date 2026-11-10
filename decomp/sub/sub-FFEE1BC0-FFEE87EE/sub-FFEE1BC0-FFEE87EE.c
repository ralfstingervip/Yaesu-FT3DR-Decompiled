/* sub-FFEE1BC0-FFEE87EE.c - FT3DR SUB (RX64M, CC-RX) hand reconstruction,
 * wave C lane sub-FFEE1BC0-FFEE87EE (228 functions, 0xFFEE1BC0..0xFFEE87EE).
 *
 * Contents: numeric/text helpers and the CC-RX simulator charput/charget
 * (part 1), then the SUB touch-LCD screen modules dispatched through
 * k_screen_tbl (FFED4050): screens 0x22..0x28 (APRS), 0x1C (character
 * picker), 0x04/0x05 (numeric entry), 0x03, 0x0D, 0x0B, 0x07/0x16
 * (keypad / PASSWORD), 0x00 (main display). Static analysis only.
 * Documentation C: it is not meant to compile as-is.
 */
#include <stdint.h>
#include <string.h>
typedef uint8_t u8;  typedef uint16_t u16; typedef uint32_t u32;
typedef int8_t  s8;  typedef int16_t  s16; typedef int32_t  s32;

typedef struct { u16 x, y, w, h; } rect16_t;        /* ROM rect tables, 8 B each   */
typedef struct { u8 op_hi, op_lo, slot, idx; } icon_query_t;   /* sub_FFEF2724 arg */
typedef struct { u16 base_code, rsvd; const u8 *map; } pick_group_t; /* FFED49E0, 45 x 8 B */
typedef struct gfx_surface gfx_surface_t;           /* 0x1D3B8 descriptor          */
typedef void (*fn_t)(void);

/* ---------------- RAM (SUB on-chip / external RAM) ---------------- */
extern u8  g_frame[];          /* 0x8C4D applied IPC frame shadow (doc 09/pc-04)    */
extern u8  g_frame_pend[];     /* 0x8E46 pending frame from MAIN                    */
extern u8  g_screen_phase;     /* 0x8C4C per-screen phase 0..3                      */
extern u8  g_screen_id;        /* 0x8A8C screen index into k_screen_tbl             */
extern u8  g_touch_key;        /* 0x8F73 last request/touch key from touch_key_poll */
extern u8  g_blink_armed;      /* 0x8F74 blink timer joined once (0x26, 0x07/0x16)  */
extern u8  g_lang;             /* 0x8F72 UI language, 0 = Japanese (RESUME-FULL)    */
extern u8  g_8D79;             /* 0x8D79 cleared by every redraw_all                */
extern u32 g_touch_req[2];     /* 0x1D3B0 64-bit request mask (keys 0..63)          */
extern gfx_surface_t g_surf;   /* 0x1D3B8 drawing surface descriptor                */
extern u8 *g_block3_dst;       /* 0x1D39C dst pointer for sub_FFEF42A7              */
extern u8  sim_io_buf;         /* 0x8C23 CC-RX lowlvl IO_BUF                        */
extern u32 sim_io_parm;        /* 0x1D264 CC-RX lowlvl PARM                         */
extern u8  g_pick_q[40];       /* 0x8C24 char-picker cell-repaint ring              */
extern u8  g_pick_rd;          /* 0x12282 ring read index                           */
extern u8  g_pick_wr;          /* 0x12283 ring write index                          */
extern u8  g_numentry_reset;   /* 0x12284 F104/F105 switch flag                     */
extern u8  g_ui_layer;         /* 0x12285 band/panel layer (ui_set_layer)           */
extern const u8 *g_icon_slot_rects[];  /* 0x68868 per-slot {x,y,w,h}[] base ptrs    */
extern const void *g_aprs_tabs_a[15];  /* 0x6875C header images, OP_LO 0            */
extern const void *g_aprs_tabs_b[15];  /* 0x68798 header images, OP_LO != 0         */
extern const void *g_aprs_sym_tbl[];   /* 0x68658 APRS symbol images                */
extern const void *g_aprs_ovl_tbl[];   /* 0x68584 APRS overlay images (53)          */
extern const void *g_compass_ctr[16];  /* 0x687D4 compass centre icons (0x24)       */
extern const void *g_gps_ctr_imgs[16]; /* 0x68814 compass centre icons (0x0D)       */
extern const void *g_level_imgs[];     /* 0x68514 level images, 14 per set          */

/* ---------------- ROM tables ---------------- */
extern const fn_t k_screen_tbl[];      /* FFED4050 screen handlers                  */
extern const fn_t k_aprs_list_phase[4], k_aprs_list_keys[];     /* FFED4300 / 4310 */
extern const fn_t k_aprs_detail_phase[4], k_aprs_detail_keys[]; /* FFED4378 / 4388 */
extern const fn_t k_aprs_text_phase[4], k_aprs_text_keys[];     /* FFED43F0 / 4400 */
extern const fn_t k_aprs_edit_phase[4], k_aprs_edit_keys[];     /* FFED4468 / 4478 */
extern const fn_t k_aprs_to_phase[4], k_aprs_to_keys[];         /* FFED44C0 / 44D0 */
extern const fn_t k_aprs_stn_phase[4], k_aprs_stn_keys[];       /* FFED452C / 453C */
extern const fn_t k_aprs_stxt_phase[4], k_aprs_stxt_keys[];     /* FFED45E8 / 45F8 */
extern const fn_t k_charpick_phase[4], k_charpick_keys[];       /* FFED4B48 / 4B58 */
extern const fn_t k_numentry_phase[4], k_numentry_keys[];       /* FFED4BB4 / 4BC4 */
extern const fn_t k_mainalt_phase[4], k_mainalt_keys[];         /* FFED4C78 / 4C88 */
extern const fn_t k_gpsinfo_phase[4], k_gpsinfo_keys[];         /* FFED4D78 / 4D88 */
extern const fn_t k_scope_phase[4], k_scope_keys[];             /* FFED4E70 / 4E80 */
extern const fn_t k_keypad_phase[4], k_keypad_keys[];           /* FFED4F10 / 4F20 */
extern const fn_t k_main_phase[4], k_main_keys[];               /* FFED4FF8 / 5008 */
extern const u16 k_bcd_w10[10], k_bcd_w100[10], k_bcd_w1000[10]; /* FFEB751A/752E/7542 */
extern const char k_hexdigits[16];     /* FFC0012D "0123456789ABCDEF"               */
extern const char k_aprs_type_labels[6][16]; /* "a5_0" table, first entry "5"       */
extern const u8  k_stamp_pos[5];       /* FFF48567 digit offsets in "[20yy/mm/dd hh:mm]" */
extern const char k_bracket_tmpl[5];   /* FFF48570 "[  ]"                           */
extern const char k_pw_title_ja[7];    /* FFF48580 kana "password"                  */
extern const char k_wide5_chars[11];   /* FFC362A1 "MWXYmwx*@\\"                    */
extern const u8  k_font_blocks[];      /* FFED4644 26 x 12 B font block descriptors */
extern const pick_group_t k_pick_groups[45]; /* FFED49E0 glyph_tbl8 (doc 79)        */
extern const u8  k_compass_pos[32];    /* FFC0013D 16 x,y byte pairs                */
extern const void *const k_compass_marks[17]; /* FFED45A4 bearing marker images     */
extern const u8  k_dial_pos[32];       /* FFC3D376 16 x,y label positions           */
extern const u16 k_marker_pos2[32], k_marker_pos4[32]; /* FFEC5972 / FFEC59B2       */
extern const u8  k_scope_bars[3];      /* FFC3D396 bars per span (19/39/79 Inferred) */
extern const rect16_t k_rects_60B8[], k_rects_6088[], k_rects_6058[], k_rects_6048[],
                      k_rects_5F28[], k_rects_6120[];
extern const rect16_t k_rect_5942, k_rect_595A, k_rect_5962;
/* k_img_FFExxxxx: RGB565/1-bpp image descriptors at the named ROM address. */

/* ---------------- callees outside this range ---------------- */
void frame_apply_opcode(void);          /* sub_FFEF4069 copy +0/+1, mark bit 0      */
void frame_apply_popup(void);           /* sub_FFEF40BA +0x13/+0x1A -> 0x8D7A       */
void frame_apply_header(void);          /* sub_FFEF4142 common header fields        */
u8   frame_sync_block(u8 *d, const u8 *s, u8 n, u32 mask_lo);   /* sub_FFEF208D     */
u8   frame_sync_block_hi(u8 *d, const u8 *s, u8 n, u32 mask_hi);/* sub_FFEF20DD     */
void frame_sync_block3(u8 *d, const u8 *s, u8 n);               /* sub_FFEF42A7     */
void ui_mark_dirty(u32 m);              /* sub_FFEEFEA4 g_touch_req[0] |= m         */
void ui_mark_dirty_hi(u32 m);           /* sub_FFEEFEEE g_touch_req[1] |= m         */
void ui_req_clear(u32 m);               /* sub_FFEEFF25                             */
void ui_req_clear_hi(u32 m);            /* sub_FFEEFF38                             */
u32  ui_req_get(void);                  /* sub_FFEEFF90                             */
void ui_flush_dirty(void);              /* sub_FFEF0294                             */
u8   touch_key_poll(void);              /* sub_FFEF003F lowest pending key or 0xFF  */
u8   touch_busy(void);                  /* sub_FFEEFB84 0x8F76 > 0                  */
void touch_key_ack(u8 k);               /* sub_FFEEFFEA clear request bit k         */
void touch_keys_clear(void);            /* sub_FFEF002C clear both request words    */
void ui_blink_subscribe(u32 hi, u32 lo);   /* sub_FFEF0163 (blink struct 0x68854)   */
void ui_blink_unsubscribe(u32 hi, u32 lo); /* sub_FFEF019E                          */
u8   ui_blink_phase(void);              /* sub_FFEF02F2                             */
void ui_icon_blink_update(u8 nv, u8 ov, u32 mask_hi); /* sub_FFEF3912 (Inferred)    */
u8   gfx_region_begin(gfx_surface_t *s, u16 x, u16 y, u16 w, u16 h); /* sub_FFEEF9BB */
void gfx_region_commit_next(void);      /* sub_FFEF036F flush + g_screen_phase++    */
void gfx_fb_init(void);                 /* sub_FFEF032D                             */
void gfx_copy_bg(u16 x, u16 y);         /* sub_FFEF0408                             */
void gfx_restore_bg(u16 x, u16 y, u16 w, u16 h);   /* sub_FFEF04F7                  */
void gfx_fill_rect(u16 x, u16 y, u16 w, u16 h, u16 rgb565); /* sub_FFEF1C48         */
void gfx_clear_screen(void);            /* sub_FFEFA747                             */
void gfx_draw_image(u16 x, u16 y, u8 mode, const void *img); /* sub_FFEF68D5        */
void gfx_blit(u16 x, u16 y, const void *img);       /* sub_FFEF0648                 */
void gfx_draw_text(u16 x, u16 y, u8 font, u8 attr, u8 n, const void *s, u8 col); /* sub_FFEF1B23 */
void gfx_draw_text_color(u16 x, u16 y, u8 m, const void *s, u16 n, u16 rgb);   /* sub_FFEFAB3E */
void gfx_draw_glyph(u16 x, u16 y, u8 font, u16 code, u8 mode);  /* sub_FFEF190D     */
void gfx_draw_number_str(u16 x, u16 y, u16 attr, const char *s);/* sub_FFEFA7E7     */
#define gfx_draw_number_attr gfx_draw_number_str
void ui_clear_with_titlebar(void);      /* sub_FFEFA75E                             */
void ui_clear_with_status(void);        /* sub_FFEFA588                             */
void ui_draw_status_strip(void);        /* sub_FFEF399F                             */
void ui_draw_widget(u16 id);            /* sub_FFEF9E8F 21-case widget painter      */
void ui_draw_icon(u8 i);                /* sub_FFEF2505                             */
void ui_icon_lookup(icon_query_t *q);   /* sub_FFEF2724                             */
void ui_draw_row_separator(u16 y, u8 m);/* sub_FFF0FF6E                             */
void ui_draw_scroll_track(u16 y0, u16 y1);          /* sub_FFEFA54F                 */
void ui_draw_scroll_thumb(u16 x, u16 y, u16 w, u16 h, u8 total, u8 vis, u8 pos); /* sub_FFEFAA2B */
void ui_set_layer(u8 v);                /* sub_FFEEC35B -> 0x12285                  */
const u8 *band_data(void);              /* sub_FFEEC3BD                             */
u8   band_mode(void);                   /* sub_FFEEC232                             */
void ui_draw_mode_badge(u16 x, u16 y);  /* sub_FFEF6A0D                             */
void ui_draw_value_label(u16 x, u16 y, u8 k);       /* sub_FFEF9A49                 */
void ui_draw_value_bar(u8 k, u16 x, u16 y, u8 v);   /* sub_FFEF9A8A                 */
void ui_draw_float(void);               /* sub_FFEF9B22                             */
void ui_get_float_pos(u16 *x, u16 *y);  /* sub_FFEEDF40                             */
void ui_render_text_req(u8 *req);       /* sub_FFEF6C42                             */
void ui_draw_text_panel(u16 x, u16 y, u8 m, const u8 *s);   /* sub_FFEF6764         */
void ui_draw_text_panel2(u16 x, u16 y, const u8 *s);        /* sub_FFEF682C         */
void aprs_draw_symbol(u16 x, u16 y, const void *img);       /* sub_FFEF0FCC         */
void mem_set(void *d, u8 v, u32 n);     /* sub_FFEFB29A                             */
void mem_copy(void *d, const void *s, u32 n);       /* sub_FFEFB268                 */
/* band_part_XXXX(): band-panel painters sub_FFEFXXXX (4CED returns a flag). */
/* ======================================================================
 * Part 1: numeric / text helpers  (FFEE1BC0 - FFEE2248)
 * ====================================================================== */

/* ----------------------------------------------------------------------
 * FFEE1BC0-FFEE1C1F (95 B)  bcd16_to_bin   [alias sub_FFEE1BC0]
 * Callers: sub_FFEE9DA5.
 * Converts a 4-digit packed-BCD word to binary using three ROM weight
 * tables of ten u16 each (k_bcd_w10 = 0,10,..,90; k_bcd_w100; k_bcd_w1000).
 * Confidence: Confirmed (table contents Inferred from the stride 0x14 and use).
 * -------------------------------------------------------------------- */
u16 bcd16_to_bin(u16 bcd)
{
    u16 v = bcd & 0x0F;
    bcd >>= 4;  v += k_bcd_w10  [bcd & 0x0F];   /* FFEB751A */
    bcd >>= 4;  v += k_bcd_w100 [bcd & 0x0F];   /* FFEB752E */
    bcd >>= 4;  v += k_bcd_w1000[bcd & 0x0F];   /* FFEB7542 */
    return v;
}

/* ----------------------------------------------------------------------
 * FFEE1C1F-FFEE1C4D (46 B)  bcd8_to_bin   [alias dead_FFEE1C1F]
 * No callers (dead). Byte variant of the above: reads the low byte of
 * k_bcd_w10[hi] (little-endian u16 table, so the low byte is the value).
 * Confidence: Confirmed.
 * -------------------------------------------------------------------- */
u8 bcd8_to_bin(u8 bcd)
{
    return (u8)((bcd & 0x0F) + ((const u8 *)k_bcd_w10)[(bcd >> 4) * 2]);
}

/* ----------------------------------------------------------------------
 * FFEE1C4D-FFEE1C6A (29 B)  nibble_to_hexchar   [alias sub_FFEE1C4D]
 * Callers: sub_FFEE9477.  k_hexdigits = "0123456789ABCDEF" (FFC0012D, doc 01).
 * Confidence: Confirmed.
 * -------------------------------------------------------------------- */
u8 nibble_to_hexchar(u8 v) { return k_hexdigits[v & 0x0F]; }

/* ----------------------------------------------------------------------
 * FFEE1C6A-FFEE1C9A (48 B)  put_hex2   [alias sub_FFEE1C6A]
 * Callers: sub_FFEE0FA3 (NMEA checksum, doc 14 "hex2"), sub_FFF0AB40.
 * Writes two upper-case hex digits of v to dst[0..1] (no terminator).
 * Confidence: Confirmed.
 * -------------------------------------------------------------------- */
void put_hex2(char *dst, u8 v)
{
    dst[0] = k_hexdigits[v >> 4];
    dst[1] = k_hexdigits[v & 0x0F];
}

/* ----------------------------------------------------------------------
 * FFEE1C9A-FFEE1CE5 (75 B)  put_dec2   [alias sub_FFEE1C9A]
 * Callers: sub_FFEE9282, sub_FFEE956A, sub_FFEE9A8E, sub_FFF37B5D.
 * Two decimal digits with leading zero; values > 99 write nothing.
 * Confidence: Confirmed.
 * -------------------------------------------------------------------- */
void put_dec2(char *dst, u8 v)
{
    if (v > 99) return;
    dst[0] = k_hexdigits[v / 10];
    dst[1] = k_hexdigits[v % 10];
}

/* ----------------------------------------------------------------------
 * FFEE1CE5-FFEE1D6D (136 B)  put_dec3_ltrim   [alias sub_FFEE1CE5]
 * Callers: sub_FFEDED8F (alignment UI), sub_FFF00684.
 * v %= 1000, then 1..3 digits left-aligned (no leading zeros, no padding,
 * no terminator).
 * Confidence: Confirmed.
 * -------------------------------------------------------------------- */
void put_dec3_ltrim(char *dst, u16 v)
{
    v %= 1000;
    if (v >= 100) *dst++ = k_hexdigits[v / 100];
    if (v >= 10)  *dst++ = k_hexdigits[(v % 100) / 10];
    *dst = k_hexdigits[v % 10];
}

/* ----------------------------------------------------------------------
 * FFEE1D6D-FFEE1DE8 (123 B)  put_dec3_zpad   [alias sub_FFEE1D6D]
 * Callers: sub_FFF00684, sub_FFF0104F, sub_FFF01F70, sub_FFF03652,
 *          sub_FFF0381A, sub_FFF03AD8, sub_FFF057FF.
 * Exactly three digits with leading zeros (v % 1000).
 * Confidence: Confirmed.
 * -------------------------------------------------------------------- */
void put_dec3_zpad(char *dst, u16 v)
{
    v %= 1000;
    dst[0] = k_hexdigits[v / 100];
    dst[1] = k_hexdigits[(v % 100) / 10];
    dst[2] = k_hexdigits[v % 10];
}

/* ----------------------------------------------------------------------
 * FFEE1DE8-FFEE1E8D (165 B)  put_dec3_spad   [alias sub_FFEE1DE8]
 * Callers (14): list renderers FFEE2B4C/FFEE2D81, menu walker sub_FFF0964A
 * ("itoa(buf, item+1)", docs 08/20), FFF0AB40, FFF41F8E, FFF43534, ...
 * Exactly three characters, right-aligned, leading zeros become spaces
 * (v % 1000). RESUME-FULL already calls it the general value->digit formatter.
 * Confidence: Confirmed.
 * -------------------------------------------------------------------- */
void put_dec3_spad(char *dst, u16 v)
{
    u8 d;
    v %= 1000;
    d = v / 100;
    dst[0] = d ? k_hexdigits[d] : ' ';
    d = (v % 100) / 10;
    dst[1] = (d == 0 && v / 100 == 0) ? ' ' : k_hexdigits[d];
    dst[2] = k_hexdigits[v % 10];
}

/* ----------------------------------------------------------------------
 * FFEE1E8D-FFEE1FCB (318 B)  put_dec5_spad   [alias sub_FFEE1E8D]
 * Callers: sub_FFF07E49 (MEMORY INFO), sub_FFF0AB40.
 * Exactly five characters, right-aligned, leading zeros -> spaces
 * (doc 50 section "frame packing" already states this).
 * Confidence: Confirmed.
 * -------------------------------------------------------------------- */
void put_dec5_spad(char *dst, u16 v)
{
    u8 started = 0, d;
    d = v / 10000;
    if (d == 0) *dst = ' '; else { started = 1; *dst = k_hexdigits[d]; }
    dst++;  v %= 10000;
    d = v / 1000;
    if (d == 0 && !started) *dst = ' '; else { started = 1; *dst = k_hexdigits[d]; }
    dst++;  v %= 1000;
    d = v / 100;
    if (d == 0 && !started) *dst = ' '; else { started = 1; *dst = k_hexdigits[d]; }
    dst++;  v %= 100;
    d = v / 10;
    *dst++ = (d == 0 && !started) ? ' ' : k_hexdigits[d];
    *dst = k_hexdigits[v % 10];
}

/* ----------------------------------------------------------------------
 * FFEE1FCB-FFEE206D (162 B)  put_dec3_ltrim_count   [alias sub_FFEE1FCB]
 * Callers: sub_FFEE518C (this range), sub_FFF057FF, sub_FFF0C1F0
 * (SmartBeaconing, doc 50).
 * As put_dec3_ltrim, but also adds the number of characters written to *len.
 * Confidence: Confirmed.
 * -------------------------------------------------------------------- */
void put_dec3_ltrim_count(char *dst, u8 *len, u16 v)
{
    v %= 1000;
    if (v >= 100) { *dst++ = k_hexdigits[v / 100];        (*len)++; }
    if (v >= 10)  { *dst++ = k_hexdigits[(v % 100) / 10]; (*len)++; }
    *dst = k_hexdigits[v % 10];
    (*len)++;
}

/* ----------------------------------------------------------------------
 * FFEE206D-FFEE20D3 (102 B)  hexchar_to_nibble   [alias sub_FFEE206D]
 * Callers: GPS/NMEA parser (FFEDFC5D, FFEE045D, FFEE0547, FFEE077C,
 * FFEE07D0, FFEE0853, FFEE0C85, FFEE0CF3) and the two helpers below.
 * '0'-'9' -> 0..9, 'A'-'F' / 'a'-'f' -> 10..15, anything else -> 0xFF.
 * Confidence: Confirmed.
 * -------------------------------------------------------------------- */
u8 hexchar_to_nibble(u8 c)
{
    u8 v = 0xFF;
    if (c >= '0') {
        if (c <= '9')                 v = c - '0';
        else if (c >= 'A' && c <= 'F') v = c - 'A' + 10;
        else if (c >= 'a' && c <= 'f') v = c - 'a' + 10;
    }
    return v;
}

/* ----------------------------------------------------------------------
 * FFEE20D3-FFEE20F8 (37 B)  hex2_to_byte   [alias dead_FFEE20D3]
 * No callers (dead; the xref from FFEE206D's caller list is this body).
 * Confidence: Confirmed.
 * -------------------------------------------------------------------- */
u8 hex2_to_byte(u8 hi, u8 lo)
{
    return (u8)((hexchar_to_nibble(hi) << 4) | hexchar_to_nibble(lo));
}

/* ----------------------------------------------------------------------
 * FFEE20F8-FFEE215D (101 B)  dec2_to_byte   [alias sub_FFEE20F8]
 * Callers: NMEA parser (FFEE0364, FFEE03FB, FFEE045D, FFEE0547) - used for
 * the 2-digit hh/mm/ss/dd/mm/yy fields.
 * Two ASCII decimal digits -> 0..99; a non-digit contributes 0.
 * Confidence: Confirmed.
 * -------------------------------------------------------------------- */
u8 dec2_to_byte(u8 tens, u8 ones)
{
    u8 v = 0;
    if (tens >= '0' && tens <= '9')
        v = ((const u8 *)k_bcd_w10)[hexchar_to_nibble(tens) * 2];
    if (ones >= '0' && ones <= '9')
        v += hexchar_to_nibble(ones);
    return v;
}

/* ----------------------------------------------------------------------
 * FFEE215D-FFEE21BD (96 B)  dec2_to_bcd   [alias dead_FFEE215D]
 * No callers (dead). Two ASCII decimal digits -> packed BCD byte.
 * Confidence: Confirmed.
 * -------------------------------------------------------------------- */
u8 dec2_to_bcd(u8 tens, u8 ones)
{
    u8 v = 0;
    if (tens >= '0' && tens <= '9') v = (u8)(hexchar_to_nibble(tens) << 4);
    if (ones >= '0' && ones <= '9') v |= hexchar_to_nibble(ones);
    return v;
}

/* ----------------------------------------------------------------------
 * FFEE21BD-FFEE2208 (75 B)  put_bcd2   [alias dead_FFEE21BD]
 * No callers (dead). Packed BCD byte -> two characters; a nibble > 9 prints ' '.
 * Confidence: Confirmed.
 * -------------------------------------------------------------------- */
void put_bcd2(char *dst, u8 bcd)
{
    u8 n = bcd >> 4;
    dst[0] = (n <= 9) ? k_hexdigits[n] : ' ';
    n = bcd & 0x0F;
    dst[1] = (n <= 9) ? k_hexdigits[n] : ' ';
}

/* ----------------------------------------------------------------------
 * FFEE2208-FFEE2225 (29 B)  charput   [alias sub_FFEE2208]
 * FFEE2225-FFEE2248 (35 B)  charget   [alias sub_FFEE2225]
 * Callers: charput <- sub_FFEE1958; charget <- dead_FFEE19E4.
 * These are byte-for-byte the CC-RX "lowlvl.src" simulator I/O stubs:
 *   SIM_IO = 0 (jsr to address 0 = debugger break-in), O_PUTC = 0x01220000,
 *   O_GETC = 0x01210000, IO_BUF = 0x8C23, PARM = 0x1D264.
 * This resolves doc 135's open question 2: they are the stock library
 * charput/charget, and the "jsr 0" is the simulated-I/O trap, unreachable
 * on target because all roots (FFEE1780/1868/19E4) are dead.
 * Confidence: Confirmed.
 * -------------------------------------------------------------------- */
void charput(u8 c)
{
    sim_io_buf = c;                 /* 0x8C23 */
    sim_io_parm = (u32)&sim_io_buf; /* 0x1D264 */
    ((void (*)(u32, void *))0)(0x01220000u /* O_PUTC */, &sim_io_parm);
}

u8 charget(void)
{
    sim_io_parm = (u32)&sim_io_buf;
    ((void (*)(u32, void *))0)(0x01210000u /* O_GETC */, &sim_io_parm);
    return sim_io_buf;
}

/* ======================================================================
 * Part 2: SUB touch-LCD screens, common shape
 * ======================================================================
 *
 * Everything from FFEE2248 to the end of this range is the SUB-side
 * renderer for screens selected by the IPC frame MAIN sends (screen id =
 * g_screen_id 0x8A8C, handler = k_screen_tbl[id] at FFED4050, called by
 * the dispatcher at FFEDF0DC/F141/F160). Each screen is a small module the
 * compiler laid out in the same order every time:
 *
 *   entry     (42 B)  if (g_screen_phase <= 3) phase_tbl[g_screen_phase]();
 *                     else g_screen_phase = 3;
 *   phase 0   (18 B)  <scr>_apply(1); g_screen_phase++;
 *   phase 1           full background: gfx_fb_init(), clear, title bar,
 *                     static decorations, ui_draw_widget(6 or 0x0E); phase++
 *   phase 2   (45 B)  if (gfx_region_begin(&g_surf, 0,0,320,240) == 1)
 *                     { <scr>_redraw_all(); gfx_region_commit_next(); }
 *   key N     (..)    partial redraws, each wrapped in a region_begin /
 *                     commit pair (commit also does g_screen_phase++)
 *   phase 3   (134 B) touch/dirty dispatcher:
 *                       g_touch_key = touch_key_poll();
 *                       if (g_touch_key == 0xFF) <scr>_apply(0);
 *                       if (g_touch_key != 0xFF && g_touch_key <= MAXKEY
 *                           && !touch_busy())
 *                         { touch_key_ack(g_touch_key); key_tbl[g_touch_key](); }
 *                       if (g_screen_phase >= 4) g_screen_phase = 3;
 *   apply     (28 B)  frame_apply_opcode(); <scr>_apply_fields();
 *                     frame_apply_popup(); if (first == 1) touch_keys_clear();
 *   apply_fields      compare-and-copy pending frame 0x8E46+k -> applied
 *                     shadow 0x8C4D+k; each change sets a dirty bit through
 *                     ui_mark_dirty(); ends with ui_flush_dirty().
 *
 * "Keys" are not only finger touches: touch_key_poll() (sub_FFEF003F)
 * returns the lowest pending bit of the 64-bit request mask g_touch_req
 * (0x1D3B0), which ui_mark_dirty() also sets. So key 15/16 are "redraw
 * header/body" requests and keys 0x11..0x19 are "redraw status icon
 * key-0x11" requests raised by the 0x20000<<i dirty bits below.
 * (Inferred from the identical mask layout; sub_FFEEFEA4 is outside range.)
 *
 * Immediates: IDA prints the RX "#UIMM:8" forms signed. 0xF0 (240, the LCD
 * height), 0xD6, 0xB4 ... appear in the listing as -10h, -2Ah, -4Ch.
 * The values below are the unsigned ones the code actually uses; they are
 * proven by the geometry (e.g. y 0x1A + h 0xD6 = 240, track 27+153 = 180).
 * ====================================================================== */

#define FRM(k)   (g_frame[(k)])          /* 0x8C4D + k, applied frame   */
#define PEND(k)  (g_frame_pend[(k)])     /* 0x8E46 + k, pending frame   */
#define OP_HI    FRM(0)
#define OP_LO    FRM(1)

/* compare/copy one byte, marking `mask` dirty on change */
#define SYNC_BYTE(k, mask) \
    do { if (FRM(k) != PEND(k)) { ui_mark_dirty(mask); FRM(k) = PEND(k); } } while (0)
/* n-byte compare/copy (sub_FFEF208D) */
#define SYNC_BLOCK(k, n, mask) frame_sync_block(&FRM(k), &PEND(k), (n), (mask))
/* nine per-icon byte pairs at k0+i and k1+i, dirty bit 0x20000<<i */
#define SYNC_ICONS(k0, k1) \
    do { u8 i_; for (i_ = 0; i_ < 9; i_++) { \
        SYNC_BYTE((k0) + i_, 0x20000u << i_); \
        SYNC_BYTE((k1) + i_, 0x20000u << i_); } } while (0)

/* phase-3 dispatcher shared shape */
#define TOUCH_DISPATCH(apply_fn, key_tbl, maxkey)                        \
    do {                                                                \
        g_touch_key = touch_key_poll();                                 \
        if (g_touch_key == 0xFF) apply_fn(0);                           \
        if (g_touch_key != 0xFF && g_touch_key <= (maxkey) && !touch_busy()) { \
            touch_key_ack(g_touch_key);                                 \
            (key_tbl)[g_touch_key]();                                   \
        }                                                               \
        if (g_screen_phase >= 4) g_screen_phase = 3;                    \
    } while (0)

/* entry shape */
#define SCREEN_ENTRY(phase_tbl)                                         \
    do { if (g_screen_phase <= 3) (phase_tbl)[g_screen_phase]();        \
         else g_screen_phase = 3; } while (0)

/* status-icon redraw for request key 0x11..0x19 (identical in every module) */
#define ICON_KEY_BODY()                                                 \
    do {                                                                \
        icon_query_t q; const u16 *r; u8 idx = g_touch_key - 0x11;      \
        q.op_hi = OP_HI; q.op_lo = OP_LO; q.idx = idx;                  \
        ui_icon_lookup(&q);                         /* sub_FFEF2724 */  \
        r = (const u16 *)(g_icon_slot_rects[q.slot] + idx * 8); /* 0x68868 */ \
        if (gfx_region_begin(&g_surf, r[0], r[1], r[2], r[3]) == 1) {   \
            ui_draw_icon(idx);                      /* sub_FFEF2505 */  \
            gfx_region_commit_next();               /* sub_FFEF036F */  \
        }                                                               \
    } while (0)

/* ======================================================================
 * Screen 0x22 - APRS list (MAIN pages F500/F502; F501/F503 are vestigial,
 * doc 43). Phase table off_FFED4300, key table off_FFED4310 (keys <= 0x19).
 * Two list layouts selected by OP_LO: 0 = station-style rows (type icon,
 * flag icon, 15-char text, 19-byte records), 2 = 19-char text rows
 * (20-byte records). Row numbers wrap at 60 and the scroll bar is sized
 * for 60 entries, matching a 60-entry APRS list (Inferred).
 * ====================================================================== */

/* FFEE2248-FFEE2272 (42 B) aprs_list_entry [sub_FFEE2248]  k_screen_tbl[0x22].
 * Doc 23 listed this as "not a function in the DB"; it is the standard entry.
 * Confidence: Confirmed. */
void aprs_list_entry(void) { SCREEN_ENTRY(k_aprs_list_phase); /* FFED4300 */ }

/* FFEE2272-FFEE2284 (18 B) aprs_list_phase0 [sub_FFEE2272]  phase_tbl[0].
 * Confidence: Confirmed. */
void aprs_list_phase0(void) { aprs_list_apply(1); g_screen_phase++; }

/* FFEE2284-FFEE23D6 (338 B) aprs_list_phase1_bg [sub_FFEE2284]
 * phase_tbl[1] and key_tbl[1]. Builds the static background: 15 tab/header
 * images from a RAM pointer table (0x6875C for OP_LO 0, else 0x68798),
 * spaced 13 px with an extra 13 px gap after items 3 and 10; four row
 * separators at y = 57 + 31*i; the scroll-bar track; then either widget 6
 * (no soft-key bar) or a black fill of the soft-key area plus widget 0x0E.
 * Confidence: Confirmed. */
void aprs_list_phase1_bg(void)
{
    u8  op = OP_LO, i, bar;
    u16 x = 0x2B, y = 5, gap = 1;

    gfx_fb_init();                       /* sub_FFEF032D */
    ui_clear_with_titlebar();            /* sub_FFEFA75E */
    for (i = 0; i < 15; i++) {
        const void *img = (op == 0) ? g_aprs_tabs_a[i] /* 0x6875C */
                                    : g_aprs_tabs_b[i] /* 0x68798 */;
        gfx_draw_image(x, y, 1, img);    /* sub_FFEF68D5 */
        x += gap + 12;
        if (i == 3 || i == 10) x += gap + 12;
    }
    for (i = 0, y = 0x39; i < 4; i++, y += 0x1F)
        ui_draw_row_separator(y, 1);     /* sub_FFF0FF6E */
    ui_draw_scroll_track(0x1B, 0xB4);    /* sub_FFEFA54F: x 311, y 27..180 */

    bar = (op == 0) ? FRM(0x82) : FRM(0x87);
    if (bar == 0) {
        ui_draw_widget(6);               /* sub_FFEF9E8F */
    } else {
        gfx_fill_rect(k_rects_60B8[0].x, k_rects_60B8[0].y,
                      320 - k_rects_60B8[0].x, 240 - k_rects_60B8[0].y, 0x0000);
        ui_draw_widget(0x0E);
    }
    g_screen_phase++;
}

/* FFEE23D6-FFEE2403 (45 B) aprs_list_phase2 [sub_FFEE23D6]  Confirmed. */
void aprs_list_phase2(void)
{
    if (gfx_region_begin(&g_surf, 0, 0, 320, 240) == 1) {
        aprs_list_redraw_all();
        gfx_region_commit_next();
    }
}

/* FFEE2403-FFEE2438 (53 B) aprs_list_key_title [sub_FFEE2403]  key_tbl[15].
 * Redraws the 22x20 edit-state badge at (298,4).  Confirmed. */
void aprs_list_key_title(void)
{
    if (gfx_region_begin(&g_surf, 0x12A, 4, 0x16, 0x14) == 1) {
        aprs_list_draw_badge(0x12A, 4);
        gfx_region_commit_next();
    }
}

/* FFEE2438-FFEE24B2 (122 B) aprs_list_key_body [sub_FFEE2438]  key_tbl[16].
 * Redraws the list body (y 26..), plus the soft-key icons when the bar is on.
 * Confirmed. */
void aprs_list_key_body(void)
{
    u8  bar = (OP_LO == 0) ? FRM(0x82) : FRM(0x87);
    u16 h   = (bar == 0) ? (u16)(k_rects_60B8[6].y - 0x1A) : 0xD6;
    if (gfx_region_begin(&g_surf, 0, 0x1A, 320, h) == 1) {
        aprs_list_draw_list(0, 0x1A);
        if (bar) aprs_list_draw_icons();
        gfx_region_commit_next();
    }
}

/* FFEE24B2-FFEE2524 (114 B) aprs_list_key_icon [sub_FFEE24B2]
 * key_tbl[0x11..0x19]: redraw status icon (key-0x11) inside its slot
 * rectangle. Identical copies: FFEE2FCB, FFEE35DB, FFEE3B2C, FFEE407F,
 * FFEE4568, FFEE4ED5(variant), FFEE5603, ... Confirmed. */
void aprs_list_key_icon(void) { ICON_KEY_BODY(); }

/* FFEE2524-FFEE25AA (134 B) aprs_list_phase3 [sub_FFEE2524]  Confirmed. */
void aprs_list_phase3(void) { TOUCH_DISPATCH(aprs_list_apply, k_aprs_list_keys /* FFED4310 */, 0x19); }

/* FFEE25AA-FFEE25C6 (28 B) aprs_list_apply [sub_FFEE25AA]  Confirmed. */
void aprs_list_apply(u8 first)
{
    frame_apply_opcode();          /* sub_FFEF4069 */
    aprs_list_apply_fields();
    frame_apply_popup();           /* sub_FFEF40BA */
    if (first == 1) touch_keys_clear();   /* sub_FFEF002C */
}

/* FFEE25C6-FFEE29B1 (1003 B) aprs_list_apply_fields [sub_FFEE25C6]
 * Field layout per OP_LO (all four share +0x20 = edit/badge state):
 *   0: +0x21..+0x81 list (cursor, top, 5 x 19 B rows), +0x82 bar flag,
 *      icons +0x83/+0x8C
 *   1: +0x21..+0x48, icons +0x49/+0x52            (F501, vestigial)
 *   2: +0x21..+0x86 list (5 x 20 B rows), +0x87 bar flag, icons +0x88/+0x91
 *   3: +0x21..+0x4A, icons +0x4B/+0x54            (F503, vestigial)
 * Confidence: Confirmed. */
void aprs_list_apply_fields(void)
{
    frame_apply_header();                         /* sub_FFEF4142 */
    switch (OP_LO) {
    case 0:
        SYNC_BYTE(0x20, 0x8000);
        SYNC_BLOCK(0x21, 0x82 - 0x21, 0x10000);
        SYNC_BLOCK(0x82, 1, 1);
        SYNC_ICONS(0x83, 0x8C);
        break;
    case 1:
        SYNC_BYTE(0x20, 0x8000);
        SYNC_BLOCK(0x21, 0x49 - 0x21, 0x10000);
        SYNC_ICONS(0x49, 0x52);
        break;
    case 2:
        SYNC_BYTE(0x20, 0x8000);
        SYNC_BLOCK(0x21, 0x87 - 0x21, 0x10000);
        SYNC_BLOCK(0x87, 1, 1);
        SYNC_ICONS(0x88, 0x91);
        break;
    case 3:
        SYNC_BYTE(0x20, 0x8000);
        SYNC_BLOCK(0x21, 0x4B - 0x21, 0x10000);
        SYNC_ICONS(0x4B, 0x54);
        break;
    }
    ui_flush_dirty();                              /* sub_FFEF0294 */
}

/* FFEE29B1-FFEE29D7 (38 B) aprs_list_redraw_all [sub_FFEE29B1]  Confirmed. */
void aprs_list_redraw_all(void)
{
    g_8D79 = 0;
    gfx_copy_bg(0, 0);                    /* sub_FFEF0408 */
    aprs_list_draw_badge(0x12A, 4);
    aprs_list_draw_list(0, 0x1A);
    aprs_list_draw_icons();
}

/* FFEE29D7-FFEE2A4A (115 B) aprs_list_draw_badge [sub_FFEE29D7]
 * Draws image FFED31CC at (x,y) mode 0, then overlays FFED31CC (state 1)
 * or FFED31DC (state 2) in mode 1; any other state redraws mode 0.
 * Both OP_LO branches read +0x20. Confirmed. */
void aprs_list_draw_badge(u16 x, u16 y)
{
    const void *img = &k_img_FFED31CC;
    u8 mode = 1, st = FRM(0x20);          /* identical for OP_LO 0 / !0 */
    gfx_draw_image(x, y, 0, img);
    switch (st & 3) {
    case 1:  img = &k_img_FFED31CC; break;
    case 2:  img = &k_img_FFED31DC; break;
    default: mode = 0; break;
    }
    gfx_draw_image(x, y, mode, img);
}

/* FFEE2A4A-FFEE2AC4 (122 B) aprs_list_draw_list [sub_FFEE2A4A]
 * Restores the body background, draws the rows for the current layout and
 * the scroll thumb (x 311, y 27, 6 x 153, 60 entries, 5 visible, pos +0x22).
 * Confirmed. */
void aprs_list_draw_list(u16 x, u16 y)
{
    u8 op = OP_LO;
    gfx_restore_bg(x, y, 320 - x, k_rects_60B8[6].y - y);   /* sub_FFEF04F7 */
    if (op == 0) aprs_list_draw_rows_a(x, y);
    else         aprs_list_draw_rows_b(x, y);
    ui_draw_scroll_thumb(0x137, 0x1B, 6, 0x99, 60, 5, FRM(0x22)); /* sub_FFEFAA2B */
}

/* FFEE2AC4-FFEE2B2C (104 B) aprs_list_draw_icons [sub_FFEE2AC4]
 * With the soft-key bar off only icons 6..8 are drawn; with it on the
 * soft-key area is restored and icons 0..8 are drawn. Same shape as
 * FFEE32EE, FFEE39CC, ... Confirmed. */
void aprs_list_draw_icons(void)
{
    u8 bar = (OP_LO == 0) ? FRM(0x82) : FRM(0x87), i;
    if (bar == 0) i = 6;
    else {
        i = 0;
        gfx_restore_bg(k_rects_60B8[0].x, k_rects_60B8[0].y,
                       320 - k_rects_60B8[0].x, 240 - k_rects_60B8[0].y);
    }
    for (; i < 9; i++) ui_draw_icon(i);
}

/* FFEE2B2C-FFEE2B4C (32 B) aprs_list_row_count [sub_FFEE2B2C]
 * 5 visible rows for OP_LO 0 and 2, 0 for the vestigial pages 1 and 3.
 * Confirmed. */
u8 aprs_list_row_count(void)
{
    u8 n = 0;
    if (OP_LO == 0 || OP_LO == 2) n = 5;
    return n;
}

/* FFEE2B4C-FFEE2D81 (565 B) aprs_list_draw_rows_a [sub_FFEE2B4C]
 * Layout A rows (19-byte records at +0x23): rec[0] = type (1..4 -> one of
 * four 14x28 RGB565 icons FFED217C/FFECF19C/FFED215C/FFED216C; 5..10 ->
 * a one-char label from a 6 x 16 B ROM table whose first entry is "5"),
 * rec[1] = flag (1 -> FFED219C, 2 -> FFED218C), rec[2..16] = 15 chars.
 * The selected row (+0x21, clamped to n-1) gets an orange (0xF980) bar.
 * Row number = top(+0x22)+row, wrapped above 60, printed as 2 digits.
 * Confidence: Confirmed (label table text not dumped). */
void aprs_list_draw_rows_a(u16 x, u16 y)
{
    char  labels[6][16];
    char  num[4];
    u16   col_no = 6, col_type = 0x22, col_flag = 0x3E, col_txt = 0x5A, ry;
    u8    n = aprs_list_row_count(), sel = FRM(0x21), top = FRM(0x22), row, v;
    const u8 *rec = &FRM(0x23);
    (void)x;

    if (sel > n - 1) sel = n - 1;
    for (row = 0; row < n; row++) {
        const u8 *r = rec + row * 19;
        ry = row * 31 + y + 1;
        if (sel == row) gfx_fill_rect(6, ry, 300, 30, 0xF980);
        v = top + row;
        if (v >= 61) v -= 60;
        put_dec3_spad(num, v);
        num[3] = 0;
        gfx_draw_text(col_no, ry + 2, 0x0D, 0, 2, &num[1], 1);  /* sub_FFEF1B23 */

        switch (r[0]) {
        case 0: break;
        case 1: gfx_draw_image(col_type, ry + 2, 1, &k_img_FFED217C); break;
        case 2: gfx_draw_image(col_type, ry + 2, 1, &k_img_FFECF19C); break;
        case 3: gfx_draw_image(col_type, ry + 2, 1, &k_img_FFED215C); break;
        case 4: gfx_draw_image(col_type, ry + 2, 1, &k_img_FFED216C); break;
        default:
            if (r[0] <= 10) {
                memcpy(labels, k_aprs_type_labels /* "5", ... */, sizeof labels);
                gfx_draw_text(col_type + 7, ry + 2, 0x0D, 0, 1, labels[r[0] - 5], 1);
            }
            break;
        }
        if (r[1] == 1)      gfx_draw_image(col_flag, ry + 2, 1, &k_img_FFED219C);
        else if (r[1] == 2) gfx_draw_image(col_flag, ry + 2, 1, &k_img_FFED218C);
        gfx_draw_text(col_txt, ry + 2, 0x0D, 0, 15, &r[2], 1);
    }
}

/* FFEE2D81-FFEE2E69 (232 B) aprs_list_draw_rows_b [sub_FFEE2D81]
 * Layout B rows: 20-byte records at +0x23, 19 chars drawn at x 34.
 * Confirmed. */
void aprs_list_draw_rows_b(u16 x, u16 y)
{
    char num[4];
    u16  col_no = 6, col_txt = 0x22, ry;
    u8   n = aprs_list_row_count(), sel = FRM(0x21), top = FRM(0x22), row, v;
    const u8 *rec = &FRM(0x23);
    (void)x;

    if (sel > n - 1) sel = n - 1;
    for (row = 0; row < n; row++) {
        ry = row * 31 + y + 1;
        if (sel == row) gfx_fill_rect(6, ry, 300, 30, 0xF980);
        v = top + row;
        if (v >= 61) v -= 60;
        put_dec3_spad(num, v);
        num[3] = 0;
        gfx_draw_text(col_no, ry + 2, 0x0D, 0, 2, &num[1], 1);
        gfx_draw_text(col_txt, ry + 2, 0x0D, 0, 0x13, rec + row * 20, 1);
    }
}

/* ======================================================================
 * Screen 0x23 - APRS message / beacon detail (MAIN page F510).
 * Phase table off_FFED4378, key table off_FFED4388 (keys <= 0x19).
 * Header: 16 chars at +0x20 whose first 56 px blink per +0x30 bits 0-1
 * (0 hidden, 1 shown, 2 blinking with the UI blink timer). Body: either a
 * 13-char line at +0x31 (mode +0x86 == 0) or a "[20yy/mm/dd hh:mm]" stamp
 * filled from BCD bytes +0x81..+0x85, then three 20-char lines at +0x3E
 * and a 7-char line at +0x7A. Bar flag +0x87, icons +0x88/+0x91.
 * ====================================================================== */

/* FFEE2E69-FFEE2E93 (42 B) aprs_detail_entry [sub_FFEE2E69]  k_screen_tbl[0x23]. Confirmed. */
void aprs_detail_entry(void) { SCREEN_ENTRY(k_aprs_detail_phase); /* FFED4378 */ }

/* FFEE2E93-FFEE2EA5 (18 B) aprs_detail_phase0 [sub_FFEE2E93]  Confirmed. */
void aprs_detail_phase0(void) { aprs_detail_apply(1); g_screen_phase++; }

/* FFEE2EA5-FFEE2F0E (105 B) aprs_detail_phase1_bg [sub_FFEE2EA5]
 * phase_tbl[1], key_tbl[1]. Cyan (0x03FF) 28-px title bar. Confirmed. */
void aprs_detail_phase1_bg(void)
{
    u8 bar = FRM(0x87);
    gfx_fb_init();
    gfx_clear_screen();                        /* sub_FFEFA747 */
    gfx_fill_rect(0, 0, 320, 0x1C, 0x03FF);
    if (bar == 0) ui_draw_widget(6);
    else {
        gfx_restore_bg(k_rects_60B8[0].x, k_rects_60B8[0].y,
                       320 - k_rects_60B8[0].x, 240 - k_rects_60B8[0].y);
        ui_draw_widget(0x0E);
    }
    g_screen_phase++;
}

/* FFEE2F0E-FFEE2F3B (45 B) aprs_detail_phase2 [sub_FFEE2F0E]  Confirmed. */
void aprs_detail_phase2(void)
{
    if (gfx_region_begin(&g_surf, 0, 0, 320, 240) == 1) {
        aprs_detail_redraw_all();
        gfx_region_commit_next();
    }
}

/* FFEE2F3B-FFEE2F6D (50 B) aprs_detail_key_header [sub_FFEE2F3B] key_tbl[15]. Confirmed. */
void aprs_detail_key_header(void)
{
    if (gfx_region_begin(&g_surf, 0, 0, 320, 0x1E) == 1) {
        aprs_detail_draw_header(0, 0);
        gfx_region_commit_next();
    }
}

/* FFEE2F6D-FFEE2FCB (94 B) aprs_detail_key_body [sub_FFEE2F6D] key_tbl[16]. Confirmed. */
void aprs_detail_key_body(void)
{
    u8  bar = FRM(0x87);
    u16 h = (bar == 0) ? (u16)(k_rects_60B8[6].y - 0x1C) : 0xD4;
    if (gfx_region_begin(&g_surf, 0, 0x1C, 320, h) == 1) {
        aprs_detail_draw_body_wrap(0, 0x1C);
        if (bar) aprs_detail_draw_icons();
        gfx_region_commit_next();
    }
}

/* FFEE2FCB-FFEE303D (114 B) aprs_detail_key_icon [sub_FFEE2FCB] key_tbl[0x11..0x19]. Confirmed. */
void aprs_detail_key_icon(void) { ICON_KEY_BODY(); }

/* FFEE303D-FFEE30C3 (134 B) aprs_detail_phase3 [sub_FFEE303D]  Confirmed. */
void aprs_detail_phase3(void) { TOUCH_DISPATCH(aprs_detail_apply, k_aprs_detail_keys /* FFED4388 */, 0x19); }

/* FFEE30C3-FFEE30DF (28 B) aprs_detail_apply [sub_FFEE30C3]  Confirmed. */
void aprs_detail_apply(u8 first)
{
    frame_apply_opcode(); aprs_detail_apply_fields(); frame_apply_popup();
    if (first == 1) touch_keys_clear();
}

/* FFEE30DF-FFEE3234 (341 B) aprs_detail_apply_fields [sub_FFEE30DF]
 * A change of +0x30 bit 1 (header blink) subscribes / unsubscribes dirty
 * bit 0x8000 to the blink timer (sub_FFEF0163 / sub_FFEF019E). Confirmed. */
void aprs_detail_apply_fields(void)
{
    frame_apply_header();
    SYNC_BLOCK(0x20, 0x10, 0x8000);
    if (PEND(0x30) != FRM(0x30)) {
        if (PEND(0x30) & 2)      ui_blink_subscribe(0, 0x8000);
        else if (FRM(0x30) & 2)  ui_blink_unsubscribe(0, 0x8000);
        ui_mark_dirty(0x8000);
        FRM(0x30) = PEND(0x30);
    }
    SYNC_BLOCK(0x31, 0x87 - 0x31, 0x10000);
    SYNC_BLOCK(0x87, 1, 1);
    SYNC_ICONS(0x88, 0x91);
    ui_flush_dirty();
}

/* FFEE3234-FFEE3258 (36 B) aprs_detail_redraw_all [sub_FFEE3234]  Confirmed. */
void aprs_detail_redraw_all(void)
{
    g_8D79 = 0;
    gfx_copy_bg(0, 0);
    aprs_detail_draw_header(0, 0);
    aprs_detail_draw_body_wrap(0, 0x1C);
    aprs_detail_draw_icons();
}

/* FFEE3258-FFEE32DF (135 B) aprs_detail_draw_header [sub_FFEE3258]
 * Draws 16 chars of +0x20 at x+6; when the blink state is "off" the first
 * 56 px (4 glyphs) are wiped again. Confirmed. */
void aprs_detail_draw_header(u16 x, u16 y)
{
    u8 on = 0;
    gfx_restore_bg(x, y, 320 - x, 0x1C);
    switch (FRM(0x30) & 3) {
    case 0:  on = 0; break;
    case 1:  on = 1; break;
    case 2:  on = ui_blink_phase(); break;     /* sub_FFEF02F2 */
    default: on = 0; break;
    }
    gfx_draw_text(x + 6, y, 0x0D, 0, 0x10, &FRM(0x20), 1);
    if (on == 0) gfx_restore_bg(x + 6, y, 0x38, 0x1C);
}

/* FFEE32DF-FFEE32EE (15 B) aprs_detail_draw_body_wrap [sub_FFEE32DF]  thunk. Confirmed. */
void aprs_detail_draw_body_wrap(u16 x, u16 y) { aprs_detail_draw_body(x, y); }

/* FFEE32EE-FFEE333B (77 B) aprs_detail_draw_icons [sub_FFEE32EE]  (bar = +0x87). Confirmed. */
void aprs_detail_draw_icons(void)
{
    u8 i;
    if (FRM(0x87) == 0) i = 6;
    else {
        i = 0;
        gfx_restore_bg(k_rects_60B8[0].x, k_rects_60B8[0].y,
                       320 - k_rects_60B8[0].x, 240 - k_rects_60B8[0].y);
    }
    for (; i < 9; i++) ui_draw_icon(i);
}

/* FFEE333B-FFEE3497 (348 B) aprs_detail_draw_body [sub_FFEE333B]
 * Doc 20 called this the "log timestamp formatter"; it is the body painter
 * of screen 0x23 and the template is filled from BCD frame bytes.
 * k_stamp_pos (FFF48567, 5 bytes) = offsets of yy/mm/dd/hh/mm in the
 * template. Confirmed (template offsets not dumped). */
void aprs_detail_draw_body(u16 x, u16 y)
{
    char stamp[19];
    u8   pos[5], mode, i;
    u16  tx = 0x14, ty;
    u16  h = k_rects_60B8[6].y - 0x1C;

    memcpy(stamp, "[20yy/mm/dd hh:mm]", 19);
    for (i = 0; i < 5; i++) pos[i] = k_stamp_pos[i];
    mode = FRM(0x86);
    gfx_restore_bg(x, y, 320 - x, h);

    if (mode == 0) {
        ty = 0x3E;
        gfx_draw_text(0x14, 0x20, 0x0D, 0, 0x0D, &FRM(0x31), 1);
    } else {
        ty = 0x20;
        for (i = 0; i < 5; i++) {
            u8 b = FRM(0x81 + i);
            stamp[pos[i]]     = (char)((b >> 4) | '0');
            stamp[pos[i] + 1] = (char)((b | '0') & 0x3F);
        }
        gfx_draw_text(0x14, 0x98, 0x0D, 0, 0x13, stamp, 1);
    }
    for (i = 0; i < 3; i++)
        gfx_draw_text(tx, ty + i * 30, 0x0D, 0, 0x14, &FRM(0x3E + i * 20), 1);
    gfx_draw_text(tx, ty + 3 * 30, 0x0D, 0, 7, &FRM(0x7A), 1);
}

/* ======================================================================
 * Screen 0x28 - APRS text page (MAIN page F518).
 * Phase table off_FFED43F0, key table off_FFED4400 (keys <= 0x19).
 * Header +0x20 (16 chars, first 4 blink per +0x32 bits 2-3), body: five
 * (bar off) or one (bar on) 22-char line(s) at +0x37 + 22*i. Bar flag
 * +0xD1, icons +0xD2/+0xDB.
 * ====================================================================== */

/* FFEE3497-FFEE34C1 (42 B) aprs_text_entry [sub_FFEE3497]  k_screen_tbl[0x28]. Confirmed. */
void aprs_text_entry(void) { SCREEN_ENTRY(k_aprs_text_phase); /* FFED43F0 */ }

/* FFEE34C1-FFEE34D3 (18 B) aprs_text_phase0 [sub_FFEE34C1]  Confirmed. */
void aprs_text_phase0(void) { aprs_text_apply(1); g_screen_phase++; }

/* FFEE34D3-FFEE351E (75 B) aprs_text_phase1_bg [sub_FFEE34D3]  Confirmed. */
void aprs_text_phase1_bg(void)
{
    u8 bar = FRM(0xD1);
    gfx_fb_init();
    gfx_clear_screen();
    gfx_fill_rect(0, 0, 320, 0x1E, 0x03FF);
    ui_draw_widget(bar == 0 ? 6 : 0x0E);
    g_screen_phase++;
}

/* FFEE351E-FFEE354B (45 B) aprs_text_phase2 [sub_FFEE351E]  Confirmed. */
void aprs_text_phase2(void)
{
    if (gfx_region_begin(&g_surf, 0, 0, 320, 240) == 1) {
        aprs_text_redraw_all();
        gfx_region_commit_next();
    }
}

/* FFEE354B-FFEE357D (50 B) aprs_text_key_header [sub_FFEE354B] key_tbl[15]. Confirmed. */
void aprs_text_key_header(void)
{
    if (gfx_region_begin(&g_surf, 0, 0, 320, 0x1E) == 1) {
        aprs_text_draw_header(0, 0);
        gfx_region_commit_next();
    }
}

/* FFEE357D-FFEE35DB (94 B) aprs_text_key_body [sub_FFEE357D] key_tbl[16]. Confirmed. */
void aprs_text_key_body(void)
{
    u8  bar = FRM(0xD1);
    u16 h = (bar == 0) ? (u16)(k_rects_60B8[6].y - 0x1E) : 0xD2;
    if (gfx_region_begin(&g_surf, 0, 0x1E, 320, h) == 1) {
        aprs_text_draw_body(0, 0x1E);
        if (bar) aprs_text_draw_icons();
        gfx_region_commit_next();
    }
}

/* FFEE35DB-FFEE364D (114 B) aprs_text_key_icon [sub_FFEE35DB]  Confirmed. */
void aprs_text_key_icon(void) { ICON_KEY_BODY(); }

/* FFEE364D-FFEE36D3 (134 B) aprs_text_phase3 [sub_FFEE364D]  Confirmed. */
void aprs_text_phase3(void) { TOUCH_DISPATCH(aprs_text_apply, k_aprs_text_keys /* FFED4400 */, 0x19); }

/* FFEE36D3-FFEE36EF (28 B) aprs_text_apply [sub_FFEE36D3]  Confirmed. */
void aprs_text_apply(u8 first)
{
    frame_apply_opcode(); aprs_text_apply_fields(); frame_apply_popup();
    if (first == 1) touch_keys_clear();
}

/* FFEE36EF-FFEE3870 (385 B) aprs_text_apply_fields [sub_FFEE36EF]  Confirmed. */
void aprs_text_apply_fields(void)
{
    frame_apply_header();
    SYNC_BLOCK(0xD1, 1, 1);
    SYNC_BLOCK(0x20, 0x31 - 0x20, 0x8000);
    if (((FRM(0x32) & 0x0C) >> 2) != ((PEND(0x32) & 0x0C) >> 2)) {
        if ((PEND(0x32) >> 2) & 2)      ui_blink_subscribe(0, 0x8000);
        else if ((FRM(0x32) >> 2) & 2)  ui_blink_unsubscribe(0, 0x8000);
        ui_mark_dirty(0x8000);
        FRM(0x32) = (FRM(0x32) & ~0x0C) | (PEND(0x32) & 0x0C);
    }
    SYNC_BLOCK(0x35, 0xD1 - 0x35, 0x10000);
    SYNC_ICONS(0xD2, 0xDB);
    ui_flush_dirty();
}

/* FFEE3870-FFEE3894 (36 B) aprs_text_redraw_all [sub_FFEE3870]  Confirmed. */
void aprs_text_redraw_all(void)
{
    g_8D79 = 0;
    gfx_copy_bg(0, 0);
    aprs_text_draw_header(0, 0);
    aprs_text_draw_body(0, 0x1E);
    aprs_text_draw_icons();
}

/* FFEE3894-FFEE3931 (157 B) aprs_text_draw_header [sub_FFEE3894]
 * Blink "on": 16 chars of +0x20 at x+34; "off": 12 chars of +0x24 at
 * x+90 (= the same text without its 4-glyph prefix). Confirmed. */
void aprs_text_draw_header(u16 x, u16 y)
{
    u8 on;
    gfx_restore_bg(x, y, 320 - x, 0x1E);
    switch ((FRM(0x32) & 0x0C) >> 2) {
    case 1:  on = 1; break;
    case 2:  on = ui_blink_phase(); break;
    default: on = 0; break;
    }
    if (on == 1) gfx_draw_text(x + 6 + 0x1C, y + 1, 0x0D, 0, 0x10, &FRM(0x20), 1);
    else         gfx_draw_text(x + 6 + 0x54, y + 1, 0x0D, 0, 0x0C, &FRM(0x24), 1);
}

/* FFEE3931-FFEE39CC (155 B) aprs_text_draw_body [sub_FFEE3931]  Confirmed. */
void aprs_text_draw_body(u16 x, u16 y)
{
    u8  bar = FRM(0xD1), n, i;
    u16 h = (bar == 0) ? (u16)(k_rects_60B8[6].y - 0x1E)
                       : (u16)(k_rects_60B8[0].y - 0x1E);
    gfx_restore_bg(x, y, 320 - x, h);
    n = (bar == 0) ? 5 : 1;
    for (i = 0; i < n; i++)
        gfx_draw_text(x + 6, i * 30 + y + 1, 0x0D, 0, 0x16, &FRM(0x37 + i * 22), 1);
}

/* FFEE39CC-FFEE3A1C (80 B) aprs_text_draw_icons [sub_FFEE39CC]  (bar = +0xD1). Confirmed. */
void aprs_text_draw_icons(void)
{
    u8 i;
    if (FRM(0xD1) == 0) i = 6;
    else {
        i = 0;
        gfx_restore_bg(k_rects_60B8[0].x, k_rects_60B8[0].y,
                       320 - k_rects_60B8[0].x, 240 - k_rects_60B8[0].y);
    }
    for (; i < 9; i++) ui_draw_icon(i);
}

/* ======================================================================
 * Screen 0x26 - APRS message text edit with 4-row pick list
 * (MAIN page F516, sent from MAIN screen 0x94; Inferred purpose).
 * Phase table off_FFED4468, key table off_FFED4478 (keys <= 0x11).
 * +0x20 cursor column, +0x21..+0x34 20-char edit line (0 / 0xFF shown
 * as '.'), +0x49 selected row, +0x4A top index, +0x4B.. 4 x 16-char rows.
 * The cursor cell blinks (blink timer subscribed once, flag 0x8F74).
 * ====================================================================== */

/* FFEE3A1C-FFEE3A46 (42 B) aprs_edit_entry [sub_FFEE3A1C]  k_screen_tbl[0x26]. Confirmed. */
void aprs_edit_entry(void) { SCREEN_ENTRY(k_aprs_edit_phase); /* FFED4468 */ }

/* FFEE3A46-FFEE3A58 (18 B) aprs_edit_phase0 [sub_FFEE3A46]  Confirmed. */
void aprs_edit_phase0(void) { aprs_edit_apply(1); g_screen_phase++; }

/* FFEE3A58-FFEE3A99 (65 B) aprs_edit_phase1_bg [sub_FFEE3A58]
 * Four row separators at y = 34 + 36*i, widget 6. Confirmed. */
void aprs_edit_phase1_bg(void)
{
    u16 y = 0x22; u8 i;
    gfx_fb_init();
    gfx_clear_screen();
    for (i = 0; i < 4; i++, y += 0x24) ui_draw_row_separator(y, 0);
    ui_draw_widget(6);
    g_screen_phase++;
}

/* FFEE3A99-FFEE3AC6 (45 B) aprs_edit_phase2 [sub_FFEE3A99]  Confirmed. */
void aprs_edit_phase2(void)
{
    if (gfx_region_begin(&g_surf, 0, 0, 320, 240) == 1) { aprs_edit_redraw_all(); gfx_region_commit_next(); }
}

/* FFEE3AC6-FFEE3AF8 (50 B) aprs_edit_key_line [sub_FFEE3AC6] key_tbl[15]. Confirmed. */
void aprs_edit_key_line(void)
{
    if (gfx_region_begin(&g_surf, 0, 0, 320, 0x22) == 1) { aprs_edit_draw_line(0, 0); gfx_region_commit_next(); }
}

/* FFEE3AF8-FFEE3B2C (52 B) aprs_edit_key_list [sub_FFEE3AF8] key_tbl[16]. Confirmed. */
void aprs_edit_key_list(void)
{
    if (gfx_region_begin(&g_surf, 0, 0x22, 320, 0x95) == 1) { aprs_edit_draw_list(0, 0x22); gfx_region_commit_next(); }
}

/* FFEE3B2C-FFEE3B9E (114 B) aprs_edit_key_icon [sub_FFEE3B2C] key_tbl[0x11]. Confirmed. */
void aprs_edit_key_icon(void) { ICON_KEY_BODY(); }

/* FFEE3B9E-FFEE3C24 (134 B) aprs_edit_phase3 [sub_FFEE3B9E]  Confirmed. */
void aprs_edit_phase3(void) { TOUCH_DISPATCH(aprs_edit_apply, k_aprs_edit_keys /* FFED4478 */, 0x11); }

/* FFEE3C24-FFEE3C40 (28 B) aprs_edit_apply [sub_FFEE3C24]  Confirmed. */
void aprs_edit_apply(u8 first)
{
    frame_apply_opcode(); aprs_edit_apply_fields(); frame_apply_popup();
    if (first == 1) touch_keys_clear();
}

/* FFEE3C40-FFEE3D42 (258 B) aprs_edit_apply_fields [sub_FFEE3C40]
 * Only one icon pair (+0x8B/+0x8C) is tracked: the loop bound is `> 0`.
 * Confirmed. */
void aprs_edit_apply_fields(void)
{
    u8 i;
    frame_apply_header();
    if (g_blink_armed == 0) {                 /* 0x8F74 */
        ui_blink_subscribe(0, 0x8000);
        g_blink_armed = 1;
    }
    SYNC_BLOCK(0x20, 0x49 - 0x20, 0x8000);
    SYNC_BLOCK(0x49, 0x8B - 0x49, 0x10000);
    for (i = 0; i < 1; i++) {
        SYNC_BYTE(0x8B + i, 0x20000u << i);
        SYNC_BYTE(0x8C + i, 0x20000u << i);
    }
    ui_flush_dirty();
}

/* FFEE3D42-FFEE3D69 (39 B) aprs_edit_redraw_all [sub_FFEE3D42]  Confirmed. */
void aprs_edit_redraw_all(void)
{
    g_8D79 = 0;
    gfx_copy_bg(0, 0);
    aprs_edit_draw_line(0, 0);
    aprs_edit_draw_list(0, 0x22);
    ui_draw_icon(0);
}

/* FFEE3D69-FFEE3E1D (180 B) aprs_edit_draw_line [sub_FFEE3D69]
 * 20 glyphs, 14 px pitch from x+20, through the double-byte glyph blitter
 * (sub_FFEF190D, font 0x0D). Cursor cell = orange 14x28 when blink phase 1.
 * Confirmed. */
void aprs_edit_draw_line(u16 x, u16 y)
{
    u8  blink = ui_blink_phase(), cur = FRM(0x20), i, c;
    u16 cx = 0x14, cy = 3;
    gfx_restore_bg(x, y, 320 - x, 0x22);
    for (i = 0; i < 0x14; i++, cx += 0x0E) {
        c = FRM(0x21 + i);
        if (c == 0 || c == 0xFF) c = '.';
        if (i == cur && blink == 1)
            gfx_fill_rect(x + cx, y + cy, 0x0E, 0x1C, 0xF980);
        gfx_draw_glyph(x + cx, y + cy, 0x0D, c, 1);      /* sub_FFEF190D */
    }
}

/* FFEE3E1D-FFEE3EF7 (218 B) aprs_edit_draw_list [sub_FFEE3E1D]
 * Four 36-px rows: one-digit index (top+row, only when <= 9) at x 34 and
 * 16 chars at x 62. Confirmed. */
void aprs_edit_draw_list(u16 x, u16 y)
{
    u8  sel = FRM(0x49), top = FRM(0x4A), n = 4, row;
    u16 cnum = 0x22, ctxt = 0x3E;
    char ch;
    gfx_restore_bg(x, y, 320 - x, 0xB7 - y);
    for (row = 0; row < n; row++, y += 0x24) {
        if (sel == row) gfx_fill_rect(6, y + 1, 0x134, 0x23, 0xF980);
        ch = (char)(top + row);
        if ((u8)ch <= 9) {
            ch += '0';
            gfx_draw_text(cnum, y + 5, 0x0D, 0, 1, &ch, 1);
        }
        gfx_draw_text(ctxt, y + 5, 0x0D, 0, 0x10, &FRM(0x4B + row * 16), 1);
    }
}

/* ======================================================================
 * Screen 0x25 - APRS message "To:" view (MAIN page F512; doc 103 links
 * "To:" FFF4856C to F512). Phase off_FFED44C0, keys off_FFED44D0 (<= 0x16).
 * +0x20 9-char addressee, +0x29.. 3 x 20-char lines, +0x65 7 chars,
 * +0x6C bar flag, icons +0x6D/+0x73 (6). Uses rect table FFEC6088.
 * ====================================================================== */

/* FFEE3EF7-FFEE3F21 (42 B) aprs_to_entry [sub_FFEE3EF7]  k_screen_tbl[0x25]. Confirmed. */
void aprs_to_entry(void) { SCREEN_ENTRY(k_aprs_to_phase); /* FFED44C0 */ }

/* FFEE3F21-FFEE3F33 (18 B) aprs_to_phase0 [sub_FFEE3F21]  Confirmed. */
void aprs_to_phase0(void) { aprs_to_apply(1); g_screen_phase++; }

/* FFEE3F33-FFEE3FC2 (143 B) aprs_to_phase1_bg [sub_FFEE3F33]  Confirmed. */
void aprs_to_phase1_bg(void)
{
    u8 bar = FRM(0x6C);
    gfx_fb_init();
    gfx_clear_screen();
    gfx_fill_rect(0, 0, 320, 0x1C, 0x03FF);
    gfx_draw_text(0x30, 0, 0x0D, 0, 3, "To:", 1);
    if (bar == 0) ui_draw_widget(6);
    else {
        gfx_fill_rect(k_rects_6088[0].x, k_rects_6088[0].y,
                      320 - k_rects_6088[0].x, 240 - k_rects_6088[0].y, 0x0000);
        ui_draw_widget(0x0D);
    }
    g_screen_phase++;
}

/* FFEE3FC2-FFEE3FEF (45 B) aprs_to_phase2 [sub_FFEE3FC2]  Confirmed. */
void aprs_to_phase2(void)
{
    if (gfx_region_begin(&g_surf, 0, 0, 320, 240) == 1) { aprs_to_redraw_all(); gfx_region_commit_next(); }
}

/* FFEE3FEF-FFEE4021 (50 B) aprs_to_key_header [sub_FFEE3FEF] key_tbl[15]. Confirmed. */
void aprs_to_key_header(void)
{
    if (gfx_region_begin(&g_surf, 0, 0, 320, 0x1E) == 1) { aprs_to_draw_header(0, 0); gfx_region_commit_next(); }
}

/* FFEE4021-FFEE407F (94 B) aprs_to_key_body [sub_FFEE4021] key_tbl[16]. Confirmed. */
void aprs_to_key_body(void)
{
    u8  bar = FRM(0x6C);
    u16 h = (bar == 0) ? (u16)(k_rects_6088[3].y - 0x1C) : 0xD4;
    if (gfx_region_begin(&g_surf, 0, 0x1C, 320, h) == 1) {
        aprs_to_draw_body_wrap(0, 0x1C);
        if (bar) aprs_to_draw_icons();
        gfx_region_commit_next();
    }
}

/* FFEE407F-FFEE40F7 (120 B) aprs_to_key_icon [sub_FFEE407F] key_tbl[0x11..0x16].
 * Same as ICON_KEY_BODY but icon 1 is never redrawn. Confirmed. */
void aprs_to_key_icon(void)
{
    if ((u8)(g_touch_key - 0x11) == 1) return;
    ICON_KEY_BODY();
}

/* FFEE40F7-FFEE417D (134 B) aprs_to_phase3 [sub_FFEE40F7]  Confirmed. */
void aprs_to_phase3(void) { TOUCH_DISPATCH(aprs_to_apply, k_aprs_to_keys /* FFED44D0 */, 0x16); }

/* FFEE417D-FFEE4199 (28 B) aprs_to_apply [sub_FFEE417D]  Confirmed. */
void aprs_to_apply(u8 first)
{
    frame_apply_opcode(); aprs_to_apply_fields(); frame_apply_popup();
    if (first == 1) touch_keys_clear();
}

/* FFEE4199-FFEE4294 (251 B) aprs_to_apply_fields [sub_FFEE4199]  Confirmed. */
void aprs_to_apply_fields(void)
{
    u8 i;
    frame_apply_header();
    SYNC_BLOCK(0x6C, 1, 1);
    SYNC_BLOCK(0x20, 0x29 - 0x20, 0x8000);
    SYNC_BLOCK(0x29, 0x6C - 0x29, 0x10000);
    for (i = 0; i < 6; i++) {
        SYNC_BYTE(0x6D + i, 0x20000u << i);
        SYNC_BYTE(0x73 + i, 0x20000u << i);
    }
    ui_flush_dirty();
}

/* FFEE4294-FFEE42B8 (36 B) aprs_to_redraw_all [sub_FFEE4294]  Confirmed. */
void aprs_to_redraw_all(void)
{
    g_8D79 = 0;
    gfx_copy_bg(0, 0);
    aprs_to_draw_header(0, 0);
    aprs_to_draw_body_wrap(0, 0x1C);
    aprs_to_draw_icons();
}

/* FFEE42B8-FFEE42F9 (65 B) aprs_to_draw_header [sub_FFEE42B8]
 * 9-char addressee after the static "To:" label. Confirmed. */
void aprs_to_draw_header(u16 x, u16 y)
{
    gfx_restore_bg(x, y, 320 - x, 0x1C);
    gfx_draw_text(0x68, y + 1, 0x0D, 0, 9, &FRM(0x20), 1);
}

/* FFEE42F9-FFEE4308 (15 B) aprs_to_draw_body_wrap [sub_FFEE42F9]  thunk. Confirmed. */
void aprs_to_draw_body_wrap(u16 x, u16 y) { aprs_to_draw_body(x, y); }

/* FFEE4308-FFEE435A (82 B) aprs_to_draw_icons [sub_FFEE4308]
 * Icons 3..5 (bar off) or 0..5 (bar on), always skipping icon 1. Confirmed. */
void aprs_to_draw_icons(void)
{
    u8 i = 0;
    if (FRM(0x6C) == 0) i = 3;
    else gfx_restore_bg(k_rects_6088[0].x, k_rects_6088[0].y,
                        320 - k_rects_6088[0].x, 240 - k_rects_6088[0].y);
    for (; i < 6; i++) if (i != 1) ui_draw_icon(i);
}

/* FFEE435A-FFEE4421 (199 B) aprs_to_draw_body [sub_FFEE435A]
 * Three 20-char lines at (20, 32+30i); the 7-char line +0x65 at y 122 is
 * suppressed when the bar flag == 1. Confirmed. */
void aprs_to_draw_body(u16 x, u16 y)
{
    u16 tx = 0x14, ty = 0x20, h;
    u8  bar = FRM(0x6C), i;
    h = (bar == 0) ? (u16)(k_rects_6088[3].y - 0x1C) : (u16)(k_rects_6088[0].y - 0x1C);
    gfx_restore_bg(x, y, 320 - x, h);
    for (i = 0; i < 3; i++)
        gfx_draw_text(tx, ty + i * 30, 0x0D, 0, 0x14, &FRM(0x29 + i * 20), 1);
    if (FRM(0x6C) != 1)
        gfx_draw_text(tx, ty + 3 * 30, 0x0D, 0, 7, &FRM(0x65), 1);
}

/* ======================================================================
 * Screen 0x24 - APRS station detail with symbol / compass
 * (MAIN page F511). Phase off_FFED452C, keys off_FFED453C (<= 0x19).
 * +0x20 16-char header (blink +0x32 b2-3), +0x30 == 1 adds badge FFED22AC,
 * +0x31 compass mode (0 off, 1/2 on, 3 ...), +0x32 b0-1 marker blink,
 * b4 header variant, b5 symbol(0)/compass(1), b6-7 centre-icon blink,
 * +0x33..+0x36 compass fields, +0x37/+0x38 APRS symbol table / code,
 * +0x39.. 6 x 22-char text lines, +0xD3 bar flag, icons +0xD4/+0xDA (6).
 * Request bits: 0x8000 header, 0x20000 body, 0x40000 marker, 0x80000
 * compass, 0x100000<<i icons (keys 20..25 -> icon key-0x14).
 * Key slots 16 and 19 are not resolved by the pointer index (see NOTES).
 * ====================================================================== */

/* FFEE4421-FFEE444B (42 B) aprs_stn_entry [sub_FFEE4421]  k_screen_tbl[0x24]. Confirmed. */
void aprs_stn_entry(void) { SCREEN_ENTRY(k_aprs_stn_phase); /* FFED452C */ }

/* FFEE444B-FFEE445D (18 B) aprs_stn_phase0 [sub_FFEE444B]  Confirmed. */
void aprs_stn_phase0(void) { aprs_stn_apply(1); g_screen_phase++; }

/* FFEE445D-FFEE44A9 (76 B) aprs_stn_phase1_bg [sub_FFEE445D]
 * Cyan header band at y 20..41 (below a 20-px status strip). Confirmed. */
void aprs_stn_phase1_bg(void)
{
    u8 bar = FRM(0xD3);
    gfx_fb_init();
    ui_clear_with_status();                       /* sub_FFEFA588 */
    gfx_fill_rect(0, 0x14, 320, 0x16, 0x03FF);
    ui_draw_widget(bar == 0 ? 6 : 0x0C);
    g_screen_phase++;
}

/* FFEE44A9-FFEE44D6 (45 B) aprs_stn_phase2 [sub_FFEE44A9]  Confirmed. */
void aprs_stn_phase2(void)
{
    if (gfx_region_begin(&g_surf, 0, 0, 320, 240) == 1) { aprs_stn_redraw_all(); gfx_region_commit_next(); }
}

/* FFEE44D6-FFEE450A (52 B) aprs_stn_key_header [sub_FFEE44D6] key_tbl[15]. Confirmed. */
void aprs_stn_key_header(void)
{
    if (gfx_region_begin(&g_surf, 0, 0x14, 320, 0x16) == 1) { aprs_stn_draw_header(0, 0x14); gfx_region_commit_next(); }
}

/* FFEE450A-FFEE4568 (94 B) aprs_stn_key_body [sub_FFEE450A] key_tbl[17], key_tbl[18]. Confirmed. */
void aprs_stn_key_body(void)
{
    u8 f = FRM(0x32);
    if (gfx_region_begin(&g_surf, 0, 0x2A, 320, 0xC6) == 1) {
        aprs_stn_draw_text(0, 0x2A);
        if ((f & 0x20) == 0) aprs_stn_draw_symbol(0, 0x2A);
        else                 aprs_stn_draw_compass(0, 0x2A);
        aprs_stn_draw_icons();
        gfx_region_commit_next();
    }
}

/* FFEE4568-FFEE45DA (114 B) aprs_stn_key_icon [sub_FFEE4568] key_tbl[20..25]
 * (icon = key - 0x14). Confirmed. */
void aprs_stn_key_icon(void)
{
    icon_query_t q; const u16 *r; u8 idx = g_touch_key - 0x14;
    q.op_hi = OP_HI; q.op_lo = OP_LO; q.idx = idx;
    ui_icon_lookup(&q);
    r = (const u16 *)(g_icon_slot_rects[q.slot] + idx * 8);
    if (gfx_region_begin(&g_surf, r[0], r[1], r[2], r[3]) == 1) { ui_draw_icon(idx); gfx_region_commit_next(); }
}

/* FFEE45DA-FFEE4660 (134 B) aprs_stn_phase3 [sub_FFEE45DA]  Confirmed. */
void aprs_stn_phase3(void) { TOUCH_DISPATCH(aprs_stn_apply, k_aprs_stn_keys /* FFED453C */, 0x19); }

/* FFEE4660-FFEE467C (28 B) aprs_stn_apply [sub_FFEE4660]  Confirmed. */
void aprs_stn_apply(u8 first)
{
    frame_apply_opcode(); aprs_stn_apply_fields(); frame_apply_popup();
    if (first == 1) touch_keys_clear();
}

/* FFEE467C-FFEE4A0D (913 B) aprs_stn_apply_fields [sub_FFEE467C]
 * The compass-mode transition table decides which areas to repaint.
 * Confirmed. */
void aprs_stn_apply_fields(void)
{
    u8 changed = 0, i, oldm, newm;
    frame_apply_header();
    SYNC_BLOCK(0xD3, 1, 1);
    SYNC_BLOCK(0x20, 0x31 - 0x20, 0x8000);

    if (((FRM(0x32) & 0x0C) >> 2) != ((PEND(0x32) & 0x0C) >> 2)) {
        if ((PEND(0x32) >> 2) & 2)     ui_blink_subscribe(0, 0x8000);
        else if ((FRM(0x32) >> 2) & 2) ui_blink_unsubscribe(0, 0x8000);
        ui_mark_dirty(0x8000);
        FRM(0x32) = (FRM(0x32) & ~0x0C) | (PEND(0x32) & 0x0C);
    }
    if (((FRM(0x32) & 0x10) >> 4) != ((PEND(0x32) & 0x10) >> 4)) {
        ui_mark_dirty(0x20000);
        FRM(0x32) = (FRM(0x32) & ~0x10) | (PEND(0x32) & 0x10);
    }
    if (FRM(0x31) != PEND(0x31)) {
        oldm = FRM(0x31); newm = PEND(0x31);
        if (oldm == 0 || oldm == 3) {
            if (newm == 1 || newm == 2) {
                ui_mark_dirty(0x80000); ui_mark_dirty(0x20000); ui_mark_dirty(0x40000);
            } else if (newm == 0) {
                ui_mark_dirty(0x20000);
            } else if (newm == 3) {
                ui_mark_dirty(0x20000); ui_mark_dirty(0x40000);
            }
        } else if (oldm == 1 || oldm == 2) {
            if (newm == 0) {
                ui_mark_dirty(0x10000); ui_mark_dirty(0x20000);
            } else if (newm == 3) {
                ui_mark_dirty(0x10000); ui_mark_dirty(0x20000); ui_mark_dirty(0x40000);
            } else {
                ui_mark_dirty(0x80000);
            }
        }
        FRM(0x31) = PEND(0x31);
    }
    if ((FRM(0x32) & 3) != (PEND(0x32) & 3)) {
        if (PEND(0x32) & 2)      ui_blink_subscribe(0, 0x40000);
        else if (FRM(0x32) & 2)  ui_blink_unsubscribe(0, 0x40000);
        ui_mark_dirty(0x40000);
    }
    SYNC_BLOCK(0x32, 0x37 - 0x32, 0x40000);
    changed = SYNC_BLOCK(0x37, 0xD3 - 0x37, 0x20000);
    if (changed == 1) {
        if (FRM(0x31) == 1 || FRM(0x31) == 2) ui_mark_dirty(0x80000);
        ui_mark_dirty(0x40000);
    }
    for (i = 0; i < 6; i++) {
        SYNC_BYTE(0xD4 + i, 0x100000u << i);
        SYNC_BYTE(0xDA + i, 0x100000u << i);
    }
    ui_flush_dirty();
}

/* FFEE4A0D-FFEE4A60 (83 B) aprs_stn_redraw_all [sub_FFEE4A0D]  Confirmed. */
void aprs_stn_redraw_all(void)
{
    u8 f = FRM(0x32);
    g_8D79 = 0;
    gfx_copy_bg(0, 0);
    ui_draw_status_strip();                       /* sub_FFEF399F */
    aprs_stn_draw_header(0, 0x14);
    aprs_stn_draw_text(0, 0x2A);
    if ((f & 0x20) == 0) aprs_stn_draw_symbol(0, 0x2A);
    else                 aprs_stn_draw_compass(0, 0x2A);
    aprs_stn_draw_icons();
}

/* FFEE4A60-FFEE4B04 (164 B) aprs_stn_draw_header [sub_FFEE4A60]
 * 16 chars at (4,22) through the coloured text routine sub_FFEFAB3E
 * (white); first 52 px wiped when the blink phase is off; badge FFED22AC
 * at (305,23) when +0x30 == 1. Confirmed. */
void aprs_stn_draw_header(u16 x, u16 y)
{
    u8 on, badge = FRM(0x30);
    gfx_restore_bg(x, y, 320 - x, 0x16);
    switch ((FRM(0x32) & 0x0C) >> 2) {
    case 1:  on = 1; break;
    case 2:  on = ui_blink_phase(); break;
    default: on = 0; break;
    }
    x = 4; y = 0x16;
    gfx_draw_text_color(x, y, 1, &FRM(0x20), 0x10, 0xFFFF);   /* sub_FFEFAB3E */
    if (on == 0) gfx_restore_bg(x, y, 0x34, 0x12);
    x = 0x131; y = 0x17;
    if (badge == 1) gfx_draw_image(x, y, 1, &k_img_FFED22AC);
}

/* FFEE4B04-FFEE4B67 (99 B) aprs_stn_draw_text [sub_FFEE4B04]
 * Six 22-char lines at x 46, 23-px pitch from y 46. Confirmed. */
void aprs_stn_draw_text(u16 x, u16 y)
{
    u16 tx = 0x2E, ty = 0x2E; u8 i;
    gfx_restore_bg(x, y, 320 - x, 240 - y);
    for (i = 0; i < 6; i++, ty += 0x17)
        gfx_draw_text_color(tx, ty, 1, &FRM(0x39 + i * 22), 0x16, 0xFFFF);
}

/* FFEE4B67-FFEE4BB7 (80 B) aprs_stn_draw_icons [sub_FFEE4B67]
 * Icons 3..5 (bar off) or 0..5 (bar on, rect table FFEC6058). Confirmed. */
void aprs_stn_draw_icons(void)
{
    u8 i = 0;
    if (FRM(0xD3) == 0) i = 3;
    else gfx_restore_bg(k_rects_6058[0].x, k_rects_6058[0].y,
                        320 - k_rects_6058[0].x, 240 - k_rects_6058[0].y);
    for (; i < 6; i++) ui_draw_icon(i);
}

/* FFEE4BB7-FFEE4CBD (262 B) aprs_stn_draw_symbol [sub_FFEE4BB7]
 * +0x32 b4 == 0: draws the APRS symbol: code +0x38 (0x20..0x5A -> index
 * code-0x20, else 0) from the RAM pointer table 0x68658 at (25,65), then
 * an overlay from 0x68584[+0x37 % 53] at (23,62) when that index > 0.
 * b4 == 1: prints "[xy]" (template FFF48570 "[  ]") with x = +0x37,
 * y = +0x38 where non-zero, at (33,84), 4 chars, white.
 * Confidence: Confirmed (symbol semantics Inferred). */
void aprs_stn_draw_symbol(u16 x, u16 y)
{
    char txt[5];
    u8   code, ov;
    (void)x; (void)y;
    if (((FRM(0x32) & 0x10) >> 4) == 0) {
        code = FRM(0x38);
        ov   = FRM(0x37) % 0x35;
        code = (code >= 0x20 && code <= 0x5A) ? code - 0x20 : 0;
        aprs_draw_symbol(0x19, 0x41, g_aprs_sym_tbl[code]);     /* sub_FFEF0FCC, 0x68658 */
        if (ov > 0)
            aprs_draw_symbol(0x17, 0x3E, g_aprs_ovl_tbl[ov]);   /* 0x68584 */
    } else {
        memcpy(txt, k_bracket_tmpl /* "[  ]" */, 5);
        if (FRM(0x37)) txt[1] = FRM(0x37);
        if (FRM(0x38)) txt[2] = FRM(0x38);
        gfx_draw_text_color(0x21, 0x54, 1, txt, 4, 0xFFFF);
    }
}

/* FFEE4CBD-FFEE4D70 (179 B) aprs_stn_draw_compass [sub_FFEE4CBD]
 * When +0x31 != 0: four 60x60 quadrant images (FFED23CC/303C/305C/307C)
 * at (x+6..+66, y+11..+71) via sub_FFEF0648, the compass labels, then
 * (blink-gated by +0x32 b0-1) the bearing marker and the centre icon.
 * Note the base is truncated to bytes (x+6, y+11 stored with mov.b).
 * Confirmed. */
void aprs_stn_draw_compass(u16 x, u16 y)
{
    u8 on = 0, mode = FRM(0x31);
    u8 bx = (u8)(x + 6), by = (u8)(y + 0x0B);
    if (mode == 0) return;
    gfx_blit(bx + 0x3C, by,        &k_img_FFED23CC);
    gfx_blit(bx + 0x3C, by + 0x3C, &k_img_FFED303C);
    gfx_blit(bx,        by + 0x3C, &k_img_FFED305C);
    gfx_blit(bx,        by,        &k_img_FFED307C);
    aprs_stn_draw_compass_labels();
    switch (FRM(0x32) & 3) {
    case 1:  on = 1; break;
    case 2:  on = ui_blink_phase(); break;
    default: on = 0; break;
    }
    if (on == 1) {
        aprs_stn_draw_marker(bx, by);
        aprs_stn_draw_centre(FRM(0x36));
    }
}

/* FFEE4D70-FFEE4DDA (106 B) aprs_stn_draw_compass_labels [sub_FFEE4D70]
 * Four fixed images at (55,43), (114,102), (55,161), (0,102): the
 * N/E/S/W-style labels around the dial (Inferred). The masked +0x33 value
 * is computed but unused. Confirmed (label meaning Inferred). */
void aprs_stn_draw_compass_labels(void)
{
    u8 v = FRM(0x33);
    if (v > 0x0F) v &= 0x0F;          /* dead value */
    (void)v;
    gfx_blit(0x37, 0x2B, &k_img_FFED236C);
    gfx_blit(0x72, 0x66, &k_img_FFED234C);
    gfx_blit(0x37, 0xA1, &k_img_FFED237C);
    gfx_blit(0x00, 0x66, &k_img_FFED238C);
}

/* FFEE4DDA-FFEE4E37 (93 B) aprs_stn_draw_marker [sub_FFEE4DDA]
 * Position = byte pair k_compass_pos[+0x34 & 15] (FFC0013D, x then y);
 * image = k_compass_marks[+0x35 % 17] (FFED45A4, 17 RGB565 images
 * FFED308C..FFED3F5C). The x/y arguments are ignored. Confirmed. */
void aprs_stn_draw_marker(u16 x, u16 y)
{
    u8 pos = FRM(0x34) & 0x0F, dir = FRM(0x35) % 0x11;
    (void)x; (void)y;
    gfx_blit(k_compass_pos[pos * 2], k_compass_pos[pos * 2 + 1], k_compass_marks[dir]);
}

/* FFEE4E37-FFEE4E99 (98 B) aprs_stn_draw_centre [sub_FFEE4E37]
 * Image g_compass_ctr[v & 15] (RAM pointer table 0x687D4) at (46,93); the
 * draw mode follows +0x32 b6-7 (1 on, 2 blink, else 0). Confirmed. */
void aprs_stn_draw_centre(u8 v)
{
    const void *img; u8 m, mode = 0;
    v &= 0x0F;
    img = g_compass_ctr[v];
    m = (FRM(0x32) & 0xC0) >> 6;
    if (m == 2)      mode = ui_blink_phase();
    else if (m == 1) mode = 1;
    gfx_draw_image(0x2E, 0x5D, mode, img);
}

/* ======================================================================
 * Screen 0x27 - "TEXT" page (MAIN page F517, sent from MAIN screen 0x9B
 * = BEACON STATUS TEXT per touch-screens/records.tsv; Inferred).
 * Phase off_FFED45E8, keys off_FFED45F8 (<= 0x12). +0x20 slot number,
 * +0x21.. 3 x 20 chars, icons +0x5D/+0x5F (2), rects FFEC6048.
 * ====================================================================== */

/* FFEE4E99-FFEE4EC3 (42 B) aprs_stxt_entry [sub_FFEE4E99]  k_screen_tbl[0x27]. Confirmed. */
void aprs_stxt_entry(void) { SCREEN_ENTRY(k_aprs_stxt_phase); /* FFED45E8 */ }

/* FFEE4EC3-FFEE4ED5 (18 B) aprs_stxt_phase0 [sub_FFEE4EC3]  Confirmed. */
void aprs_stxt_phase0(void) { aprs_stxt_apply(1); g_screen_phase++; }

/* FFEE4ED5-FFEE4F0F (58 B) aprs_stxt_phase1_bg [sub_FFEE4ED5]
 * (FFF33C6C holds the value FFEE4F05, inside this body: a data word, not a
 * code pointer.) Confirmed. */
void aprs_stxt_phase1_bg(void)
{
    gfx_fb_init();
    gfx_clear_screen();
    gfx_draw_text(0x26, 1, 0x0D, 0, 4, "TEXT", 1);
    ui_draw_widget(0x0B);
    g_screen_phase++;
}

/* FFEE4F0F-FFEE4F3C (45 B) aprs_stxt_phase2 [sub_FFEE4F0F]  Confirmed. */
void aprs_stxt_phase2(void)
{
    if (gfx_region_begin(&g_surf, 0, 0, 320, 240) == 1) { aprs_stxt_redraw_all(); gfx_region_commit_next(); }
}

/* FFEE4F3C-FFEE4F6E (50 B) aprs_stxt_key_header [sub_FFEE4F3C] key_tbl[15]. Confirmed. */
void aprs_stxt_key_header(void)
{
    if (gfx_region_begin(&g_surf, 0, 0, 320, 0x1E) == 1) { aprs_stxt_draw_header(0, 0); gfx_region_commit_next(); }
}

/* FFEE4F6E-FFEE4FA2 (52 B) aprs_stxt_key_body [sub_FFEE4F6E] key_tbl[16]. Confirmed. */
void aprs_stxt_key_body(void)
{
    if (gfx_region_begin(&g_surf, 0, 0x1E, 320, 0x9B) == 1) { aprs_stxt_draw_body(0, 0x1E); gfx_region_commit_next(); }
}

/* FFEE4FA2-FFEE4FEA (72 B) aprs_stxt_key_icon [sub_FFEE4FA2] key_tbl[17..18]
 * Fixed rects k_rects_6048[idx] instead of the RAM slot table. Confirmed. */
void aprs_stxt_key_icon(void)
{
    u8 idx = g_touch_key - 0x11;
    const rect16_t *r = &k_rects_6048[idx];
    if (gfx_region_begin(&g_surf, r->x, r->y, r->w, r->h) == 1) { ui_draw_icon(idx); gfx_region_commit_next(); }
}

/* FFEE4FEA-FFEE5070 (134 B) aprs_stxt_phase3 [sub_FFEE4FEA]  Confirmed. */
void aprs_stxt_phase3(void) { TOUCH_DISPATCH(aprs_stxt_apply, k_aprs_stxt_keys /* FFED45F8 */, 0x12); }

/* FFEE5070-FFEE508C (28 B) aprs_stxt_apply [sub_FFEE5070]  Confirmed. */
void aprs_stxt_apply(u8 first)
{
    frame_apply_opcode(); aprs_stxt_apply_fields(); frame_apply_popup();
    if (first == 1) touch_keys_clear();
}

/* FFEE508C-FFEE5168 (220 B) aprs_stxt_apply_fields [sub_FFEE508C]  Confirmed. */
void aprs_stxt_apply_fields(void)
{
    u8 i;
    frame_apply_header();
    SYNC_BLOCK(0x20, 1, 0x8000);
    SYNC_BLOCK(0x21, 0x5D - 0x21, 0x10000);
    for (i = 0; i < 2; i++) {
        SYNC_BYTE(0x5D + i, 0x20000u << i);
        SYNC_BYTE(0x5F + i, 0x20000u << i);
    }
    ui_flush_dirty();
}

/* FFEE5168-FFEE518C (36 B) aprs_stxt_redraw_all [sub_FFEE5168]  Confirmed. */
void aprs_stxt_redraw_all(void)
{
    g_8D79 = 0;
    gfx_copy_bg(0, 0);
    aprs_stxt_draw_header(0, 0);
    aprs_stxt_draw_body(0, 0x1E);
    aprs_stxt_draw_icons();
}

/* FFEE518C-FFEE51DE (82 B) aprs_stxt_draw_header [sub_FFEE518C]
 * Slot number +0x20 as 1..3 digits at x 108 (sub_FFEFA7E7). Confirmed. */
void aprs_stxt_draw_header(u16 x, u16 y)
{
    char buf[4]; u8 len = 0, n = FRM(0x20);
    gfx_restore_bg(x, y, 320 - x, 0x1E);
    x = 0x6C;
    put_dec3_ltrim_count(buf, &len, n);
    buf[len] = 0;
    gfx_draw_number_str(x, y + 1, 0, buf);
}

/* FFEE51DE-FFEE524E (112 B) aprs_stxt_draw_body [sub_FFEE51DE]  Confirmed. */
void aprs_stxt_draw_body(u16 x, u16 y)
{
    u16 tx = x + 10, ty = y + 0x1E; u8 i;
    gfx_restore_bg(x, y, 320 - x, 0xB9 - y);
    for (i = 0; i < 3; i++)
        gfx_draw_text(tx, ty + i * 30 + 1, 0x0D, 0, 0x14, &FRM(0x21 + i * 20), 1);
}

/* FFEE524E-FFEE5269 (27 B) aprs_stxt_draw_icons [sub_FFEE524E]  Confirmed. */
void aprs_stxt_draw_icons(void) { u8 i; for (i = 0; i < 2; i++) ui_draw_icon(i); }

/* ----------------------------------------------------------------------
 * FFEE5269-FFEE52B3 (74 B) font_glyph_width   [alias sub_FFEE5269]
 * Callers: sub_FFEF1B23 (text), sub_FFEF1BB1, sub_FFEF2184 (glyph lookup).
 * Block 0x19 (variable-width ASCII) gives width 5 for the 11 bytes of
 * "MWXYmwx*@\" + NUL (the loop bound is 11, so code 0 also matches);
 * otherwise byte 0 of the 12-byte block descriptor k_font_blocks
 * (FFED4644). Same finding as docs 27/79. Confirmed.
 * -------------------------------------------------------------------- */
u8 font_glyph_width(u8 block, u16 code)
{
    u16 i;
    if (block == 0x19)
        for (i = 0; i < 11; i++)
            if (k_wide5_chars[i] == code) return 5;   /* FFC362A1 */
    return k_font_blocks[block * 12];
}

/* ======================================================================
 * Screen 0x1C - character picker grid (MAIN pages F200..F22C, low byte =
 * character group, 45 groups; doc 79 "glyph_tbl8").
 * Phase off_FFED4B48, keys off_FFED4B58 (<= 0x16).
 * +0x14/+0x15 current page (BE16), +0x16/+0x17 page count (BE16),
 * +0x20 page within group, +0x21 group sub-state, +0x22 cursor cell 0..39,
 * +0x23..+0x26 / +0x27..+0x2A soft-key icon pairs.
 * Grid: 8 columns x 5 rows of 32-px cells at x 46.., y 16..; cursor moves
 * are queued in a 40-entry ring g_pick_q (0x8C24) with read/write indices
 * 0x12282/0x12283 so each move repaints only the old and the new cell.
 * Request bits: 0x100000 key 20 whole grid, 0x200000 key 21 next queued
 * cell (plain), 0x400000 key 22 cursor cell (highlighted), 0x8000<<i
 * keys 15..18 icons 2..5.
 * ====================================================================== */

/* FFEE52B3-FFEE52DD (42 B) charpick_entry [sub_FFEE52B3]  k_screen_tbl[0x1C]. Confirmed. */
void charpick_entry(void) { SCREEN_ENTRY(k_charpick_phase); /* FFED4B48 */ }

/* FFEE52DD-FFEE52EF (18 B) charpick_phase0 [sub_FFEE52DD]  Confirmed. */
void charpick_phase0(void) { charpick_apply(1); g_screen_phase++; }

/* FFEE52EF-FFEE540D (286 B) charpick_phase1_bg [sub_FFEE52EF]
 * Seeds the cell queue with the cursor (clamped to 40, not 39 here),
 * paints the dark panels, grey frame lines and scroll track, widget 3.
 * Confirmed. */
void charpick_phase1_bg(void)
{
    u8 cur = FRM(0x22);
    if (cur >= 0x29) cur = 0x28;
    mem_set(g_pick_q, 0, 0x28);                   /* sub_FFEFB29A */
    g_pick_rd = 0;
    g_pick_wr = 0;
    g_pick_q[g_pick_rd] = cur;
    gfx_fb_init();
    gfx_fill_rect(0, 0, 320, 240, 0x0000);
    ui_draw_scroll_track(0x0F, 0xB6);
    gfx_fill_rect(0x09, 0x0F, 0x27, 0x26, 0x3186);
    gfx_fill_rect(0x2F, 0x0F, 0x104, 0xA8, 0x3186);
    gfx_fill_rect(0x09, 0x0F, 0x12A, 1, 0xAD95);
    gfx_fill_rect(0x09, 0x0F, 1, 0x26, 0xAD95);
    gfx_fill_rect(0x09, 0x34, 0x27, 1, 0xAD95);
    gfx_fill_rect(0x2F, 0x34, 1, 0x83, 0xAD95);
    gfx_fill_rect(0x132, 0x0F, 1, 0xA8, 0xAD95);
    ui_draw_widget(3);
    g_screen_phase++;
}

/* FFEE540D-FFEE543A (45 B) charpick_phase2 [sub_FFEE540D]  Confirmed. */
void charpick_phase2(void)
{
    if (gfx_region_begin(&g_surf, 0, 0, 320, 240) == 1) { charpick_redraw_all(); gfx_region_commit_next(); }
}

/* cell geometry shared by the two cell keys */
#define PICK_CELL_XY(cell, row, col, cx, cy) \
    do { row = (cell) >> 3; col = (cell) & 7; cx = col * 32 + 0x2E; cy = (row * 32) | 0x10; } while (0)

/* FFEE543A-FFEE54FF (197 B) charpick_key_cell_plain [sub_FFEE543A] key_tbl[21]
 * Repaints the oldest queued cell un-highlighted, pops it, then requests
 * key 22. Confirmed. */
void charpick_key_cell_plain(void)
{
    u8 row, col; u16 cx, cy;
    if (g_pick_rd != g_pick_wr) {
        PICK_CELL_XY(g_pick_q[g_pick_rd], row, col, cx, cy);
        if (gfx_region_begin(&g_surf, cx, cy, 0x32, 0x32) == 1) {
            charpick_draw_cell(cx, cy, row, col, 0);
            gfx_region_commit_next();
        }
        g_pick_q[g_pick_rd] = 0;
        g_pick_rd = (u8)((g_pick_rd + 1) % 0x28);
    }
    ui_mark_dirty(0x400000);
}

/* FFEE54FF-FFEE5591 (146 B) charpick_key_cell_cursor [sub_FFEE54FF] key_tbl[22]
 * Paints the cell at the queue head highlighted; if more moves are queued,
 * requests key 21 again. Confirmed. */
void charpick_key_cell_cursor(void)
{
    u8 row, col; u16 cx, cy;
    PICK_CELL_XY(g_pick_q[g_pick_rd], row, col, cx, cy);
    if (gfx_region_begin(&g_surf, cx, cy, 0x32, 0x32) == 1) {
        charpick_draw_cell(cx, cy, row, col, 1);
        gfx_region_commit_next();
    }
    if (g_pick_rd != g_pick_wr) ui_mark_dirty(0x200000);
}

/* FFEE5591-FFEE55C4 (51 B) charpick_key_grid [sub_FFEE5591] key_tbl[20]. Confirmed. */
void charpick_key_grid(void)
{
    if (gfx_region_begin(&g_surf, 0, 0x0F, 320, 0xA8) == 1) { charpick_draw_grid(0x0A, 0x10); gfx_region_commit_next(); }
}

/* FFEE55C4-FFEE5603 (63 B) charpick_key_softkeys [sub_FFEE55C4] key_tbl[19]. Confirmed. */
void charpick_key_softkeys(void)
{
    if (gfx_region_begin(&g_surf, 0, 0xBB, 320, 0x35) == 1) {
        gfx_restore_bg(0, 0xBB, 320, 0x35);
        charpick_draw_icons();
        gfx_region_commit_next();
    }
}

/* FFEE5603-FFEE564A (71 B) charpick_key_icon [sub_FFEE5603] key_tbl[15..18]
 * icon = key - 13 (2..5), rect k_rects_5F28[icon]. Confirmed. */
void charpick_key_icon(void)
{
    u8 idx = g_touch_key - 0x0D;
    const rect16_t *r = &k_rects_5F28[idx];
    if (gfx_region_begin(&g_surf, r->x, r->y, r->w, r->h) == 1) { ui_draw_icon(idx); gfx_region_commit_next(); }
}

/* FFEE564A-FFEE56D0 (134 B) charpick_phase3 [sub_FFEE564A]  Confirmed. */
void charpick_phase3(void) { TOUCH_DISPATCH(charpick_apply, k_charpick_keys /* FFED4B58 */, 0x16); }

/* FFEE56D0-FFEE56EC (28 B) charpick_apply [sub_FFEE56D0]  Confirmed. */
void charpick_apply(u8 first)
{
    frame_apply_opcode(); charpick_apply_fields(); frame_apply_popup();
    if (first == 1) touch_keys_clear();
}

/* reset the cell queue to a single entry (pattern repeated twice inline) */
static void charpick_q_reset(void)
{
    mem_set(g_pick_q, 0, 0x28);
    g_pick_rd = 0; g_pick_wr = 0;
    g_pick_q[g_pick_rd] = PEND(0x22);
    if (g_pick_q[g_pick_rd] >= 0x28) g_pick_q[g_pick_rd] = 0x27;
}

/* FFEE56EC-FFEE5987 (667 B) charpick_apply_fields [sub_FFEE56EC]
 * (charpick_q_reset is inlined twice in the binary.) Confirmed. */
void charpick_apply_fields(void)
{
    u32 req; u8 i;
    frame_apply_header();
    if (FRM(0x20) != PEND(0x20)) {                    /* page changed */
        ui_req_clear(0x400000); ui_req_clear(0x200000);   /* sub_FFEEFF25 */
        ui_mark_dirty(0x100000);
        FRM(0x20) = PEND(0x20);
        charpick_q_reset();
    }
    if (FRM(0x22) != PEND(0x22)) {                    /* cursor moved */
        FRM(0x22) = PEND(0x22);
        g_pick_wr = (u8)((g_pick_wr + 1) % 0x28);
        g_pick_q[g_pick_wr] = FRM(0x22);
        if (g_pick_q[g_pick_wr] >= 0x28) g_pick_q[g_pick_wr] = 0x27;
    }
    if (FRM(0x21) != PEND(0x21)) {
        ui_req_clear(0x400000); ui_req_clear(0x200000);
        ui_mark_dirty(0x100000);
        FRM(0x21) = PEND(0x21);
        charpick_q_reset();
    }
    if (g_pick_rd != g_pick_wr) {
        req = ui_req_get();                           /* sub_FFEEFF90 */
        if ((req & 0x600000) == 0) ui_mark_dirty(0x200000);
    }
    for (i = 0; i < 4; i++) {
        SYNC_BYTE(0x23 + i, 0x8000u << i);
        SYNC_BYTE(0x27 + i, 0x8000u << i);
    }
    ui_flush_dirty();
}

/* FFEE5987-FFEE59A4 (29 B) charpick_redraw_all [sub_FFEE5987]  Confirmed. */
void charpick_redraw_all(void)
{
    g_8D79 = 0;
    gfx_copy_bg(0, 0);
    charpick_draw_grid(0x0A, 0x10);
    charpick_draw_icons();
}

/* glyph code of a grid cell: big-endian u16 in the group's code map */
#define PICK_CODE(grp, row, col) \
    ((u16)((k_pick_groups[(grp)].map[FRM(0x20) * 0x50 + (row) * 0x10 + (col) * 2] << 8) | \
            k_pick_groups[(grp)].map[FRM(0x20) * 0x50 + (row) * 0x10 + (col) * 2 + 1]))

/* FFEE59A4-FFEE5A73 (207 B) charpick_draw_cell [sub_FFEE59A4]
 * map + page*0x50 + row*0x10 + col*2 (doc 79 wrote the row/col names the
 * other way round; row = cell>>3, col = cell&7 per the callers).
 * Confirmed. */
void charpick_draw_cell(u16 x, u16 y, u8 row, u8 col, u8 hilite)
{
    u8 grp = OP_LO; u16 code;
    if (grp >= 0x2D) grp = 0x2C;
    code = PICK_CODE(grp, row, col);
    gfx_restore_bg(x, y, 0x22, 0x22);
    if (hilite == 1) gfx_fill_rect(x + 3, y + 3, 0x1E, 0x1E, 0xF980);
    gfx_draw_glyph(x + 4, y + 4, 2, code, 1);
}

/* FFEE5A73-FFEE5C27 (436 B) charpick_draw_grid [sub_FFEE5A73]
 * Answers doc 79 Open 3: the second glyph_tbl8 reader is this full-grid
 * painter. It draws the group's base_code glyph as the group label, a
 * white scroll thumb (page/pages over 167 px at x 311), then the 40 cells
 * with the cursor cell highlighted. Confirmed. */
void charpick_draw_grid(u16 x, u16 y)
{
    u8  grp = OP_LO, cur = FRM(0x22), row, col;
    u16 page, pages, seg, top, ry, cx, code;
    gfx_restore_bg(0, 0, 320, 0xB7);
    if (grp >= 0x2D) grp = 0x2C;
    if (cur >= 0x29) cur = 0x28;
    gfx_draw_glyph(x + 4, y + 4, 2, k_pick_groups[grp].base_code, 1);
    page  = (u16)((FRM(0x14) << 8) | FRM(0x15));
    pages = (u16)((FRM(0x16) << 8) | FRM(0x17));
    seg   = 0xA7 / pages;
    top   = (page - 1) * seg;
    gfx_fill_rect(0x137, top + 0x0F, 6, seg, 0xFFFF);
    for (row = 0; row < 5; row++) {
        ry = row << 5;
        for (col = 0; col < 8; col++) {
            cx = (col << 5) + 0x24;
            code = PICK_CODE(grp, row, col);
            if ((cur >> 3) == row && (cur & 7) == col)
                gfx_fill_rect(x + cx + 3, y + ry + 3, 0x1E, 0x1E, 0xF980);
            gfx_draw_glyph(x + cx + 4, y + ry + 4, 2, code, 1);
        }
    }
}

/* FFEE5C27-FFEE5C42 (27 B) charpick_draw_icons [sub_FFEE5C27]  icons 0..3. Confirmed. */
void charpick_draw_icons(void) { u8 i; for (i = 0; i < 4; i++) ui_draw_icon(i); }

/* ======================================================================
 * Screens 0x04 / 0x05 - direct numeric entry (MAIN pages F104 / F105).
 * Phase off_FFED4BB4, keys off_FFED4BC4 (<= 0x2C). +0x50.. packed BCD
 * digits (0xF = not yet typed -> blank). F105 shows 3 digits (memory
 * channel number, Inferred), F104 shows "ddd.ddd" (frequency, Inferred).
 * +0x20..+0x22 go through the 3-byte block applier sub_FFEF42A7 whose
 * pointer is kept in 0x1D39C; +0x6C/+0x78 are 12 icon pairs on the high
 * request word (keys 32..43 -> common handler FFEF23EE).
 * ====================================================================== */

/* FFEE5C42-FFEE5C6C (42 B) numentry_entry [sub_FFEE5C42]  k_screen_tbl[4], [5]. Confirmed. */
void numentry_entry(void) { SCREEN_ENTRY(k_numentry_phase); /* FFED4BB4 */ }

/* FFEE5C6C-FFEE5C7E (18 B) numentry_phase0 [sub_FFEE5C6C]  Confirmed. */
void numentry_phase0(void) { numentry_apply(1); g_screen_phase++; }

/* FFEE5C7E-FFEE5CAB (45 B) numentry_phase1_bg [sub_FFEE5C7E]  Confirmed. */
void numentry_phase1_bg(void)
{
    gfx_fb_init();
    gfx_fill_rect(0, 0, 320, 240, 0x0000);
    ui_draw_widget(1);
    g_screen_phase++;
}

/* FFEE5CAB-FFEE5CD8 (45 B) numentry_phase2 [sub_FFEE5CAB]  Confirmed. */
void numentry_phase2(void)
{
    if (gfx_region_begin(&g_surf, 0, 0, 320, 240) == 1) { numentry_redraw_all(); gfx_region_commit_next(); }
}

/* FFEE5CD8-FFEE5D05 (45 B) numentry_key_digits [sub_FFEE5CD8] key_tbl[20]. Confirmed. */
void numentry_key_digits(void)
{
    if (gfx_region_begin(&g_surf, 0, 0, 320, 0x20) == 1) { numentry_draw_digits(); gfx_region_commit_next(); }
}

/* FFEE5D05-FFEE5D44 (63 B) numentry_key_icons [sub_FFEE5D05] key_tbl[44]. Confirmed. */
void numentry_key_icons(void)
{
    if (gfx_region_begin(&g_surf, 0, 0x20, 320, 0xD0) == 1) {
        gfx_restore_bg(0, 0x20, 320, 0xD0);
        numentry_draw_icons();
        gfx_region_commit_next();
    }
}

/* FFEE5D44-FFEE5DCA (134 B) numentry_phase3 [sub_FFEE5D44]  Confirmed. */
void numentry_phase3(void) { TOUCH_DISPATCH(numentry_apply, k_numentry_keys /* FFED4BC4 */, 0x2C); }

/* FFEE5DCA-FFEE5E01 (55 B) numentry_apply [sub_FFEE5DCA]
 * An opcode change (F104 <-> F105) sets g_numentry_reset (0x12284) so the
 * next digit paint uses the F104 layout once. Confirmed. */
void numentry_apply(u8 first)
{
    if (FRM(1) != PEND(1)) g_numentry_reset = 1;
    frame_apply_opcode(); numentry_apply_fields(); frame_apply_popup();
    if (first == 1) touch_keys_clear();
}

/* FFEE5E01-FFEE5EE0 (223 B) numentry_apply_fields [sub_FFEE5E01]
 * +0x09 is copied silently (no request bit). Confirmed. */
void numentry_apply_fields(void)
{
    u8 i;
    frame_apply_header();
    g_block3_dst = &FRM(0x20);                        /* 0x1D39C */
    frame_sync_block3(&FRM(0x20), &PEND(0x20), 3);    /* sub_FFEF42A7 */
    for (i = 0; i < 12; i++) {
        if (FRM(0x6C + i) != PEND(0x6C + i)) { ui_mark_dirty_hi(1u << i); FRM(0x6C + i) = PEND(0x6C + i); }
        if (FRM(0x78 + i) != PEND(0x78 + i)) { ui_mark_dirty_hi(1u << i); FRM(0x78 + i) = PEND(0x78 + i); }
    }
    if (FRM(9) != PEND(9)) FRM(9) = PEND(9);
    ui_flush_dirty();
}

/* FFEE5EE0-FFEE5EF8 (24 B) numentry_redraw_all [sub_FFEE5EE0]  Confirmed. */
void numentry_redraw_all(void)
{
    g_8D79 = 0;
    gfx_copy_bg(0, 0);
    numentry_draw_digits_wrap();
    numentry_draw_icons();
}

/* FFEE5EF8-FFEE5EFC (4 B) numentry_draw_digits_wrap [sub_FFEE5EF8]  thunk. Confirmed. */
void numentry_draw_digits_wrap(void) { numentry_draw_digits(); }

/* FFEE5EFC-FFEE5F49 (77 B) numentry_draw_digits [sub_FFEE5EFC]  Confirmed. */
void numentry_draw_digits(void)
{
    u8 op = OP_LO;
    if (g_numentry_reset == 1) { op = 4; g_numentry_reset = 0; }
    gfx_restore_bg(0, 0, 320, 0x20);
    if (op == 5) numentry_draw_bcd3(0x8B, 2);
    else         numentry_draw_bcd6(0x6F, 3);
}

/* FFEE5F49-FFEE5FC6 (125 B) numentry_draw_bcd3 [sub_FFEE5F49]
 * Three BCD nibbles from +0x50 ("ddd", nibble > 9 -> ' '). Confirmed. */
void numentry_draw_bcd3(u16 x, u16 y)
{
    char out[3]; const u8 *bcd = &FRM(0x50); u8 i, n;
    for (i = 0; i < 3; i++) {
        n = (i & 1) ? (bcd[i >> 1] & 0x0F) : (bcd[i >> 1] >> 4);
        out[i] = (n <= 9) ? (char)('0' + n) : ' ';
    }
    gfx_draw_text(x, y, 0x0D, 0, 3, out, 1);
}

/* FFEE5FC6-FFEE6083 (189 B) numentry_draw_bcd6 [sub_FFEE5FC6]
 * Six BCD nibbles from +0x50 as "ddd.ddd"; the '.' becomes ' ' while the
 * third digit is still blank. Confirmed. */
void numentry_draw_bcd6(u16 x, u16 y)
{
    char out[7]; const u8 *bcd = &FRM(0x50); u8 i, j = 0, n;
    for (i = 0; i < 6; i++, j++) {
        n = (i & 1) ? (bcd[i >> 1] & 0x0F) : (bcd[i >> 1] >> 4);
        out[j] = (n <= 9) ? (char)('0' + n) : ' ';
        if (j == 2) { j++; out[j] = (out[j - 1] != ' ') ? '.' : ' '; }
    }
    gfx_draw_text(x, y, 0x0D, 0, 7, out, 1);
}

/* FFEE6083-FFEE609E (27 B) numentry_draw_icons [sub_FFEE6083]  icons 0..11. Confirmed. */
void numentry_draw_icons(void) { u8 i; for (i = 0; i < 12; i++) ui_draw_icon(i); }

/* ======================================================================
 * F1-family screens (main display group). These entries return at once
 * unless the pending frame's opcode high byte is 0xF1 (PEND(0) == 0xF1),
 * and they use the HIGH request word (keys 32..63, ui_mark_dirty_hi /
 * ui_req_clear_hi); keys 15..31 of their key tables point at shared F1
 * handlers outside this range (FFEEB8E4.., FFEEC08D ...).
 * ui_set_layer() (sub_FFEEC35B) stores a band/layer selector in 0x12285
 * (1 = band A, 2 = band B, 3/4 = other panels, 0xFF = none) that the
 * band painters read; band_data() (sub_FFEEC3BD) / band_mode()
 * (sub_FFEEC232) return the per-band record / dual-mono mode.
 * ====================================================================== */

/* ======================================================================
 * Screen 0x03 - main display variant (MAIN page F103; Inferred).
 * Phase off_FFED4C78, keys off_FFED4C88 (<= 0x3B).
 * High request bits: 0x400000 key 54 mode badge (+0x24 b2-3 blink,
 * +0x25..+0x27), 0x800000 key 55 name (+0x20..+0x23), 0x1000000 key 56
 * level (+0x2B), 0x2000000 key 57 item (+0x2C/+0x2F/+0x30), 0x4000000
 * key 58, 0x8000000 key 59 (+0x2D/+0x2E), 0x8000<<i keys 47..52 icons.
 * ====================================================================== */

/* FFEE609E-FFEE60D6 (56 B) mainalt_entry [sub_FFEE609E]  k_screen_tbl[3]. Confirmed. */
void mainalt_entry(void)
{
    if (PEND(0) != 0xF1) return;
    SCREEN_ENTRY(k_mainalt_phase);            /* FFED4C78 */
}

/* FFEE60D6-FFEE60E8 (18 B) mainalt_phase0 [sub_FFEE60D6]  Confirmed. */
void mainalt_phase0(void) { mainalt_apply(1); g_screen_phase++; }

/* FFEE60E8-FFEE613B (83 B) mainalt_phase1_bg [sub_FFEE60E8]  Confirmed. */
void mainalt_phase1_bg(void)
{
    gfx_fb_init();
    ui_clear_with_status();
    if (FRM(0xC9) != 0) {
        gfx_fill_rect(k_rects_6058[0].x, k_rects_6058[0].y,
                      320 - k_rects_6058[0].x, 240 - k_rects_6058[0].y, 0x0000);
        ui_draw_widget(0x0C);
    } else {
        ui_draw_widget(6);
    }
    g_screen_phase++;
}

/* FFEE613B-FFEE6168 (45 B) mainalt_phase2 [sub_FFEE613B]  Confirmed. */
void mainalt_phase2(void)
{
    if (gfx_region_begin(&g_surf, 0, 0, 320, 240) == 1) { mainalt_redraw_all(); gfx_region_commit_next(); }
}

/* FFEE6168-FFEE61B1 (73 B) mainalt_key_badge [sub_FFEE6168] key_tbl[54]
 * Rect k_rect_5942. Confirmed. */
void mainalt_key_badge(void)
{
    const rect16_t *r = &k_rect_5942;
    if (gfx_region_begin(&g_surf, r->x, r->y, r->w, r->h) == 1) {
        ui_set_layer(4);
        mainalt_draw_badge(k_rect_5942.x, k_rect_5942.y);
        ui_set_layer(0xFF);
        gfx_region_commit_next();
    }
}

/* FFEE61B1-FFEE61F4 (67 B) mainalt_key_name [sub_FFEE61B1] key_tbl[55]. Confirmed. */
void mainalt_key_name(void)
{
    if (gfx_region_begin(&g_surf, 0x30, 0x16, 0x110, 0x1F) == 1) {
        ui_set_layer(4);
        mainalt_draw_name(0x30, 0x16);
        ui_set_layer(0xFF);
        gfx_region_commit_next();
    }
}

/* FFEE61F4-FFEE6238 (68 B) mainalt_key_level [sub_FFEE61F4] key_tbl[56]. Confirmed. */
void mainalt_key_level(void)
{
    if (gfx_region_begin(&g_surf, 0x124, 0x16, 0x1C, 0x14) == 1) {
        ui_set_layer(4);
        mainalt_draw_level(0x124, 0x16);
        ui_set_layer(0xFF);
        gfx_region_commit_next();
    }
}

/* FFEE6238-FFEE6274 (60 B) mainalt_key_item [sub_FFEE6238] key_tbl[57]
 * Rect k_rect_595A; no layer switch. Confirmed. */
void mainalt_key_item(void)
{
    const rect16_t *r = &k_rect_595A;
    if (gfx_region_begin(&g_surf, r->x, r->y, r->w, r->h) == 1) {
        mainalt_draw_item(k_rect_595A.x, k_rect_595A.y);
        gfx_region_commit_next();
    }
}

/* FFEE6274-FFEE62C9 (85 B) mainalt_key_value [sub_FFEE6274] key_tbl[58]
 * Rect k_rect_5962; value +0x2C through sub_FFEF9A8A (kind 0). Confirmed. */
void mainalt_key_value(void)
{
    const rect16_t *r = &k_rect_5962;
    if (gfx_region_begin(&g_surf, r->x, r->y, r->w, r->h) == 1) {
        ui_set_layer(4);
        ui_draw_value_bar(0, k_rect_5962.x, k_rect_5962.y, FRM(0x2C));   /* sub_FFEF9A8A */
        ui_set_layer(0xFF);
        gfx_region_commit_next();
    }
}

/* FFEE62C9-FFEE633E (117 B) mainalt_key_float [sub_FFEE62C9] key_tbl[59]
 * Asks sub_FFEEDF40 for the on-screen position of a floating element;
 * if it is on screen, repaints a 164x13 box at (x-7, y-1) via
 * sub_FFEF9B22. Confirmed. */
void mainalt_key_float(void)
{
    u16 x, y;
    ui_set_layer(4);
    ui_get_float_pos(&x, &y);                      /* sub_FFEEDF40 */
    if (x > 0x13F || y >= 0xF0) { ui_set_layer(0xFF); return; }
    if (gfx_region_begin(&g_surf, x - 7, y - 1, 0xA4, 0x0D) == 1) {
        ui_draw_float(); /* sub_FFEF9B22 */
        gfx_region_commit_next();
    }
    ui_set_layer(0xFF);
}

/* FFEE633E-FFEE6395 (87 B) mainalt_key_softkeys [sub_FFEE633E] key_tbl[53]. Confirmed. */
void mainalt_key_softkeys(void)
{
    u8 idx = (FRM(0xC9) == 0) ? 3 : 0;
    const rect16_t *r = &k_rects_6058[idx];
    if (gfx_region_begin(&g_surf, r->x, r->y, 320 - r->x, 240 - r->y) == 1) {
        mainalt_draw_icons();
        gfx_region_commit_next();
    }
}

/* FFEE6395-FFEE641B (134 B) mainalt_phase3 [sub_FFEE6395]  Confirmed. */
void mainalt_phase3(void) { TOUCH_DISPATCH(mainalt_apply, k_mainalt_keys /* FFED4C88 */, 0x3B); }

/* FFEE641B-FFEE6437 (28 B) mainalt_apply [sub_FFEE641B]  Confirmed. */
void mainalt_apply(u8 first)
{
    frame_apply_opcode(); mainalt_apply_fields(); frame_apply_popup();
    if (first == 1) touch_keys_clear();
}

/* FFEE6437-FFEE67C7 (912 B) mainalt_apply_fields [sub_FFEE6437]
 * Level +0x2B values 14..20 blink (blink timer joined/left when crossing
 * 13/14). When the soft-key bar (+0xC9) is on, high requests 0..14 are
 * cancelled after the flush. Confirmed. */
void mainalt_apply_fields(void)
{
    u8 i;
    frame_apply_header();
    if (((FRM(0x24) & 0x0C) >> 2) != ((PEND(0x24) & 0x0C) >> 2)) {
        if ((PEND(0x24) >> 2) & 2)      ui_blink_subscribe(0x400000, 0);
        else if ((FRM(0x24) >> 2) & 2)  ui_blink_unsubscribe(0x400000, 0);
        ui_mark_dirty_hi(0x400000);
        FRM(0x24) = PEND(0x24);
    }
    frame_sync_block_hi(&FRM(0x25), &PEND(0x25), 3, 0x400000);   /* sub_FFEF20DD */
    frame_sync_block_hi(&FRM(0x20), &PEND(0x20), 4, 0x800000);
    if (FRM(0x2B) != PEND(0x2B)) {
        if (PEND(0x2B) >= 0x0E && FRM(0x2B) <= 0x0D)
            ui_blink_subscribe(0x1000000, 0);
        else if (PEND(0x2B) <= 0x0D && FRM(0x2B) >= 0x0E)
            ui_blink_unsubscribe(0x1000000, 0);
    }
    frame_sync_block_hi(&FRM(0x2B), &PEND(0x2B), 1, 0x1000000);
    frame_sync_block_hi(&FRM(0x2F), &PEND(0x2F), 1, 0x2000000);
    frame_sync_block_hi(&FRM(0x2C), &PEND(0x2C), 1, 0x2000000);
    frame_sync_block_hi(&FRM(0x30), &PEND(0x30), 1, 0x2000000);
    frame_sync_block_hi(&FRM(0x2D), &PEND(0x2D), 1, 0x8000000);
    if (FRM(0x2E) != PEND(0x2E)) {
        if (PEND(0x2E) == 0) ui_blink_unsubscribe(0x8000000, 0);
        else                 ui_blink_subscribe(0x8000000, 0);
        frame_sync_block_hi(&FRM(0x2E), &PEND(0x2E), 1, 0x8000000);
    }
    if (((FRM(9) & 0x10) >> 4) != ((PEND(9) & 0x10) >> 4)) ui_mark_dirty(1);
    g_block3_dst = &FRM(0x31);
    frame_sync_block3(&FRM(0x31), &PEND(0x31), 1);
    frame_sync_block3(&FRM(0x7D), &PEND(0x7D), 2);
    SYNC_BLOCK(0xC9, 1, 1);
    for (i = (PEND(0xC9) == 0) ? 3 : 0; i < 6; i++) {
        if (FRM(0xCA + i) != PEND(0xCA + i)) { ui_mark_dirty_hi(0x8000u << i); FRM(0xCA + i) = PEND(0xCA + i); }
        if (FRM(0xD0 + i) != PEND(0xD0 + i)) { ui_mark_dirty_hi(0x8000u << i); FRM(0xD0 + i) = PEND(0xD0 + i); }
    }
    if (FRM(9) != PEND(9)) FRM(9) = PEND(9);
    ui_flush_dirty();
    if (PEND(0xC9) != 0)
        for (i = 0; i < 15; i++) ui_req_clear_hi(1u << i);     /* sub_FFEEFF38 */
}

/* FFEE67C7-FFEE683A (115 B) mainalt_redraw_all [sub_FFEE67C7]  Confirmed. */
void mainalt_redraw_all(void)
{
    g_8D79 = 0;
    gfx_copy_bg(0, 0);
    ui_draw_status_strip();
    ui_set_layer(4);
    ui_draw_mode_badge(0, 0x16);                   /* sub_FFEF6A0D */
    mainalt_draw_name(0x30, 0x16);
    mainalt_draw_level(0x124, 0x16);
    mainalt_draw_item(0xBD, 0x38);
    gfx_draw_image(0x1C, 0x36, 1, &k_img_FFECF17C);
    ui_draw_float();
    ui_set_layer(1); mainalt_draw_band();
    ui_set_layer(2); mainalt_draw_band();
    ui_set_layer(0xFF);
    mainalt_draw_icons();
}

/* FFEE683A-FFEE6889 (79 B) mainalt_draw_band [sub_FFEE683A]
 * Paints the band panel selected by the current layer through the shared
 * band painters (all outside this range). Confirmed. */
void mainalt_draw_band(void)
{
    const u8 *b = band_data();                      /* sub_FFEEC3BD */
    if (b[0] == 2) {
        band_part_6096(); band_part_5E38();
    } else {
        band_part_4FCE(); band_part_5202(); band_part_6096(); band_part_5E38();
        if (band_part_4CED() == 1) { band_part_643C(); band_part_64D2(); }
        else                       { band_part_5518(); band_part_59E4(); }
    }
    band_part_6023(); band_part_637D();
}

/* FFEE6889-FFEE6899 (16 B) mainalt_draw_badge [sub_FFEE6889]  thunk -> sub_FFEF6A0D. Confirmed. */
void mainalt_draw_badge(u16 x, u16 y) { ui_draw_mode_badge(x, y); }

/* FFEE6899-FFEE68C0 (39 B) mainalt_draw_name [sub_FFEE6899]
 * Builds an 80-byte request on the stack with +0x2F = 0 and +0x30..+0x33
 * = frame +0x20..+0x23, then hands it to the large text renderer
 * sub_FFEF6C42 (11.8 KB). x/y are not passed on; the rest of the request
 * is uninitialised stack. Confirmed. */
void mainalt_draw_name(u16 x, u16 y)
{
    u8 req[0x50];
    (void)x; (void)y;
    req[0x2F] = 0;
    mem_copy(&req[0x30], &FRM(0x20), 4);           /* sub_FFEFB268 */
    ui_render_text_req(req);                        /* sub_FFEF6C42 */
}

/* FFEE68C0-FFEE69A4 (228 B) mainalt_draw_level [sub_FFEE68C0]
 * +0x2B: 0..13 steady; 14..20 blinking as v-7; 21..27 blinking as v-14
 * with the main image steady; > 27 draws nothing. Extra overlay FFED39DC
 * for v 7..10 and FFECEFDC for v 11..13; main image from RAM table
 * 0x68514[v] (set index fixed at 0, stride 0x38). Confirmed. */
void mainalt_draw_level(u16 x, u16 y)
{
    u8 on = 0, v = FRM(0x2B), set = 0, grp = 0;
    if (v > 0x1B) return;
    if (v <= 0x0D)      { on = 1; set = 0; }
    else if (v <= 0x14) { on = ui_blink_phase(); v -= 7;  set = 1; }
    else                { on = ui_blink_phase(); v -= 14; set = 2; }
    gfx_restore_bg(x, y, 320 - x, 0x14);
    if (v >= 7 && v <= 10)       gfx_draw_image(x, y, on, &k_img_FFED39DC);
    else if (v >= 11 && v <= 13) gfx_draw_image(x, y, on, &k_img_FFECEFDC);
    if (set == 2) on = 1;
    gfx_draw_image(x, y, on, g_level_imgs[grp * 14 + v]);    /* 0x68514 */
}

/* FFEE69A4-FFEE6A04 (96 B) mainalt_draw_item [sub_FFEE69A4]  Confirmed. */
void mainalt_draw_item(u16 x, u16 y)
{
    u8 sel = FRM(0x2F), k, v;
    gfx_restore_bg(x, y, 320 - x, 0x14);
    if (sel == 0) { k = 0; v = FRM(0x2C); }
    else          { k = 1; v = FRM(0x30); }
    ui_draw_value_label(x, y, k);                   /* sub_FFEF9A49 */
    ui_draw_value_bar(k, 0xE1, 0x41, v);
}

/* FFEE6A04-FFEE6A51 (77 B) mainalt_draw_icons [sub_FFEE6A04]  (bar +0xC9). Confirmed. */
void mainalt_draw_icons(void)
{
    u8 i = 0;
    if (FRM(0xC9) == 0) i = 3;
    else gfx_restore_bg(k_rects_6058[0].x, k_rects_6058[0].y,
                        320 - k_rects_6058[0].x, 240 - k_rects_6058[0].y);
    for (; i < 6; i++) ui_draw_icon(i);
}

/* ======================================================================
 * Screen 0x0D - GPS information page with compass (MAIN pages F10D/F10F,
 * F111 toggles with it - doc 103; Inferred "info display").
 * Phase off_FFED4D78, keys off_FFED4D88 (<= 0x39).
 * +0x6C page mode (2..4 show the compass), +0x70.. 22 bytes and +0x86..
 * 7 bytes of text panels, +0x8D heading icon, +0x8E b0-1 marker blink,
 * b2-3 second blink, +0x8F dial style + heading (labels rotate in 16
 * steps), +0x90 marker position, +0x91 centre icon, icon pairs
 * +0x92/+0x98 (6). High bits: 0x10000 body (key 48), 0x80000 blink
 * (key 51), 0x100000<<i even icons (keys 52/54/56), 0x200000 odd icons
 * (key 53).
 * ====================================================================== */

/* FFEE6A51-FFEE6A89 (56 B) gpsinfo_entry [sub_FFEE6A51]  k_screen_tbl[0x0D]. Confirmed. */
void gpsinfo_entry(void)
{
    if (PEND(0) != 0xF1) return;
    SCREEN_ENTRY(k_gpsinfo_phase);            /* FFED4D78 */
}

/* FFEE6A89-FFEE6A9B (18 B) gpsinfo_phase0 [sub_FFEE6A89]  Confirmed. */
void gpsinfo_phase0(void) { gpsinfo_apply(1); g_screen_phase++; }

/* FFEE6A9B-FFEE6AB7 (28 B) gpsinfo_phase1_bg [sub_FFEE6A9B]  Confirmed. */
void gpsinfo_phase1_bg(void)
{
    gfx_fb_init();
    ui_clear_with_status();
    ui_draw_widget(0x10);
    g_screen_phase++;
}

/* FFEE6AB7-FFEE6AE4 (45 B) gpsinfo_phase2 [sub_FFEE6AB7]  Confirmed. */
void gpsinfo_phase2(void)
{
    if (gfx_region_begin(&g_surf, 0, 0, 320, 240) == 1) { gpsinfo_redraw_all(); gfx_region_commit_next(); }
}

/* FFEE6AE4-FFEE6B74 (144 B) gpsinfo_key_body [sub_FFEE6AE4]
 * key_tbl[48..52], [54], [56]. Unlike redraw_all it does not test the
 * page mode before painting the compass. Confirmed. */
void gpsinfo_key_body(void)
{
    u8 i;
    if (gfx_region_begin(&g_surf, 0, 0x17, 320, 0xD9) == 1) {
        gfx_restore_bg(0, 0x17, 320, 0xD9);
        ui_draw_text_panel(0, 0x17, 1, &FRM(0x70));      /* sub_FFEF6764 */
        ui_draw_text_panel2(0xA7, 0x24, &FRM(0x86));     /* sub_FFEF682C */
        gpsinfo_draw_heading_icon(0xBE, 0x3D, FRM(0x8D));
        gpsinfo_draw_compass();
        for (i = 0; i < 6; i++) ui_draw_icon(i);
        gfx_region_commit_next();
    }
}

/* FFEE6B74-FFEE6BBE (74 B) gpsinfo_key_odd_icons [sub_FFEE6B74]
 * key_tbl[53], [55], [57]: repaints icons 1, 3, 5 inside the band
 * between k_rects_6120[1] and k_rects_6120[4].y. Confirmed. */
void gpsinfo_key_odd_icons(void)
{
    u16 x = k_rects_6120[1].x, y = k_rects_6120[1].y;
    if (gfx_region_begin(&g_surf, x, y, 320 - x, k_rects_6120[4].y - y) == 1) {
        ui_draw_icon(1); ui_draw_icon(3); ui_draw_icon(5);
        gfx_region_commit_next();
    }
}

/* FFEE6BBE-FFEE6C44 (134 B) gpsinfo_phase3 [sub_FFEE6BBE]  Confirmed. */
void gpsinfo_phase3(void) { TOUCH_DISPATCH(gpsinfo_apply, k_gpsinfo_keys /* FFED4D88 */, 0x39); }

/* FFEE6C44-FFEE6C60 (28 B) gpsinfo_apply [sub_FFEE6C44]  Confirmed. */
void gpsinfo_apply(u8 first)
{
    frame_apply_opcode(); gpsinfo_apply_fields(); frame_apply_popup();
    if (first == 1) touch_keys_clear();
}

/* FFEE6C60-FFEE7047 (999 B) gpsinfo_apply_fields [sub_FFEE6C60]
 * Note: when an odd icon changes (skip_flush = 1) the routine returns
 * without ui_flush_dirty(). Confirmed. */
void gpsinfo_apply_fields(void)
{
    u8 i, skip_flush = 0, even, diff;
    frame_apply_header();
    g_block3_dst = &FRM(0x20);
    frame_sync_block3(&FRM(0x20), &PEND(0x20), 3);
    if (FRM(0x6C) != PEND(0x6C)) { ui_mark_dirty_hi(0x10000); FRM(0x6C) = PEND(0x6C); }
    for (i = 0; i < 0x16; i++)
        if (FRM(0x70 + i) != PEND(0x70 + i)) { ui_mark_dirty_hi(0x10000); FRM(0x70 + i) = PEND(0x70 + i); }
    if (FRM(0x8D) != PEND(0x8D)) { ui_mark_dirty_hi(0x10000); FRM(0x8D) = PEND(0x8D); }
    for (i = 0; i < 7; i++)
        if (FRM(0x86 + i) != PEND(0x86 + i)) { ui_mark_dirty_hi(0x10000); FRM(0x86 + i) = PEND(0x86 + i); }
    if (FRM(0x8E) != PEND(0x8E) || FRM(0x8F) != PEND(0x8F) ||
        FRM(0x90) != PEND(0x90) || FRM(0x91) != PEND(0x91)) {
        if (PEND(0x8E) & 2)             ui_blink_subscribe(0x80000, 0);
        else if (FRM(0x8E) & 2)         ui_blink_unsubscribe(0x80000, 0);
        if ((PEND(0x8E) >> 2) & 2)      ui_blink_subscribe(0x80000, 0);
        else if ((FRM(0x8E) >> 2) & 2)  ui_blink_unsubscribe(0x80000, 0);
        ui_mark_dirty_hi(0x10000);
        FRM(0x8E) = PEND(0x8E); FRM(0x8F) = PEND(0x8F);
        FRM(0x90) = PEND(0x90); FRM(0x91) = PEND(0x91);
    }
    for (i = 0; i < 6; i++) {
        even = (i == 0 || i == 2 || i == 4);
        diff = (FRM(0x92 + i) != PEND(0x92 + i));
        if (even) {
            if (diff) {
                ui_icon_blink_update(PEND(0x92 + i), FRM(0x92 + i), 0x100000u << i);  /* sub_FFEF3912 */
                ui_mark_dirty_hi(0x100000u << i);
                FRM(0x92 + i) = PEND(0x92 + i);
            }
            if (FRM(0x98 + i) != PEND(0x98 + i)) {
                ui_mark_dirty_hi(0x100000u << i);
                FRM(0x98 + i) = PEND(0x98 + i);
            }
        } else {
            if (diff) {
                ui_icon_blink_update(PEND(0x92 + i), FRM(0x92 + i), 0x200000);
                ui_mark_dirty_hi(0x200000);
                FRM(0x92 + i) = PEND(0x92 + i);
                skip_flush = 1;
            }
            if (FRM(0x98 + i) != PEND(0x98 + i)) {
                ui_mark_dirty_hi(0x200000);
                FRM(0x98 + i) = PEND(0x98 + i);
                skip_flush = 1;
            }
        }
    }
    if (FRM(9) != PEND(9)) FRM(9) = PEND(9);
    if (skip_flush == 0) ui_flush_dirty();
}

/* FFEE7047-FFEE70D7 (144 B) gpsinfo_redraw_all [sub_FFEE7047]  Confirmed. */
void gpsinfo_redraw_all(void)
{
    u8 mode = FRM(0x6C), i;
    g_8D79 = 0;
    gfx_copy_bg(0, 0);
    ui_draw_status_strip();
    if (mode >= 2 && mode <= 4) {
        ui_draw_text_panel(0, 0x17, 1, &FRM(0x70));
        ui_draw_text_panel2(0xA7, 0x24, &FRM(0x86));
        gpsinfo_draw_heading_icon(0xBE, 0x3D, FRM(0x8D));
        gpsinfo_draw_compass();
    }
    for (i = 0; i < 6; i++) ui_draw_icon(i);
}

/* FFEE70D7-FFEE7125 (78 B) gpsinfo_draw_heading_icon [sub_FFEE70D7]
 * Only for v 1 / 2: FFED23FC (1) or FFED23DC (2), then FFED240C at x+12.
 * Confirmed. */
void gpsinfo_draw_heading_icon(u16 x, u16 y, u8 v)
{
    if ((u8)(v - 1) > 1) return;
    gfx_blit(x, y, (v == 1) ? &k_img_FFED23FC : &k_img_FFED23DC);
    gfx_blit(x + 0x0C, y, &k_img_FFED240C);
}

/* FFEE7125-FFEE719D (120 B) gpsinfo_draw_compass [sub_FFEE7125]  Confirmed. */
void gpsinfo_draw_compass(void)
{
    u8 on = 0, m8E = FRM(0x8E), d8F = FRM(0x8F), mode = FRM(0x6C);
    u8 pos = FRM(0x90), ctr = FRM(0x91);
    gpsinfo_draw_dial(0x26, 0x44, d8F);
    gpsinfo_draw_labels(d8F);
    switch (m8E & 3) {
    case 1:  on = 1; break;
    case 2:  on = ui_blink_phase(); break;
    default: on = 0; break;
    }
    if (on == 1) gpsinfo_draw_marker(mode, pos);
    gpsinfo_draw_centre(ctr);
}

/* FFEE719D-FFEE7300 (355 B) gpsinfo_draw_dial [sub_FFEE719D]
 * Four 80x80 quadrants at (x+80,y) (x+80,y+80) (x,y+80) (x,y); style
 * (v & 3) picks one of four image sets. Confirmed. */
void gpsinfo_draw_dial(u16 x, u16 y, u8 v)
{
    static const void *const set[4][4] = {
        { &k_img_FFED231C, &k_img_FFED2F9C, &k_img_FFED2FAC, &k_img_FFED2FBC },
        { &k_img_FFED318C, &k_img_FFED319C, &k_img_FFED31AC, &k_img_FFED31BC },
        { &k_img_FFED233C, &k_img_FFED2FFC, &k_img_FFED300C, &k_img_FFED301C },
        { &k_img_FFED232C, &k_img_FFED2FCC, &k_img_FFED2FDC, &k_img_FFED2FEC },
    };  /* the binary has four inline copies, not a table */
    v = (v & 0x0F) & 3;
    gfx_blit(x + 0x50, y,        set[v][0]);
    gfx_blit(x + 0x50, y + 0x50, set[v][1]);
    gfx_blit(x,        y + 0x50, set[v][2]);
    gfx_blit(x,        y,        set[v][3]);
}

/* FFEE7300-FFEE73F3 (243 B) gpsinfo_draw_labels [sub_FFEE7300]
 * The four cardinal labels (same images as screen 0x24, which proves the
 * N/E/S/W reading: there they sit at top/right/bottom/left) are placed at
 * k_dial_pos[(d + 4k) & 15] (FFC3D376, 16 x/y byte pairs), i.e. the dial
 * rotates in 22.5-degree steps (heading-up compass). Confirmed. */
void gpsinfo_draw_labels(u8 d)
{
    u8 k;
    if (d > 0x0F) d = 0x0F;
    k = d;                       gfx_blit(k_dial_pos[k * 2], k_dial_pos[k * 2 + 1], &k_img_FFED236C);
    k = (u8)((d + 4)  % 16);     gfx_blit(k_dial_pos[k * 2], k_dial_pos[k * 2 + 1], &k_img_FFED234C);
    k = (u8)((d + 8)  % 16);     gfx_blit(k_dial_pos[k * 2], k_dial_pos[k * 2 + 1], &k_img_FFED237C);
    k = (u8)((d + 12) % 16);     gfx_blit(k_dial_pos[k * 2], k_dial_pos[k * 2 + 1], &k_img_FFED238C);
}

/* FFEE73F3-FFEE7469 (118 B) gpsinfo_draw_marker [sub_FFEE73F3]
 * Mode 2: image FFED2D7C at k_marker_pos2[v&15] (FFEC5972, u16 x,y);
 * mode 4: image FFED335C at k_marker_pos4[v&15] (FFEC59B2). Confirmed. */
void gpsinfo_draw_marker(u8 mode, u8 v)
{
    u8 i = v & 0x0F;
    if (mode == 2)      gfx_blit(k_marker_pos2[i * 2], k_marker_pos2[i * 2 + 1], &k_img_FFED2D7C);
    else if (mode == 4) gfx_blit(k_marker_pos4[i * 2], k_marker_pos4[i * 2 + 1], &k_img_FFED335C);
}

/* FFEE7469-FFEE7497 (46 B) gpsinfo_draw_centre [sub_FFEE7469]
 * Image g_gps_ctr_imgs[v & 15] (RAM pointer table 0x68814) at (98,128). Confirmed. */
void gpsinfo_draw_centre(u8 v)
{
    gfx_draw_image(0x62, 0x80, 1, g_gps_ctr_imgs[v & 0x0F]);
}

/* ======================================================================
 * Screen 0x0B - band scope (MAIN page F10B; Inferred from the drawing:
 * 19/39/79 vertical level bars of width 16/8/4 px, level 0..10, plus span
 * labels). Phase off_FFED4E70, keys off_FFED4E80 (<= 0x23).
 * +0x6C header variant, +0x6D span 0..2 (taken mod 3), +0x6E.. bar
 * levels (count k_scope_bars[span], FFC3D396), then 3 icon pairs at an
 * offset that follows the bar count (0x81/0x95/0xBD). High bit 1 = scope
 * (key 32), 2<<i = icons (keys 33..35, shared handler).
 * ====================================================================== */

/* FFEE7497-FFEE74CF (56 B) scope_entry [sub_FFEE7497]  k_screen_tbl[0x0B]. Confirmed. */
void scope_entry(void)
{
    if (PEND(0) != 0xF1) return;
    SCREEN_ENTRY(k_scope_phase);              /* FFED4E70 */
}

/* FFEE74CF-FFEE74E1 (18 B) scope_phase0 [sub_FFEE74CF]  Confirmed. */
void scope_phase0(void) { scope_apply(1); g_screen_phase++; }

/* FFEE74E1-FFEE75A5 (196 B) scope_phase1_bg [sub_FFEE74E1]
 * Header band (y 84..105, colour 0x2A69), five horizontal grid lines
 * (y 106 + 19i) and five vertical ones (x 51 + 54i, y 106..182), centre
 * marker image FFED249C at (154,99), widget 6. Confirmed. */
void scope_phase1_bg(void)
{
    u16 x = 0, y = 0x54; u8 i;
    gfx_fb_init();
    ui_clear_with_status();
    gfx_fill_rect(x, y, 320 - x, 0x16, 0x2A69);
    for (i = 0, x = 0, y = 0x6A; i < 5; i++, y += 0x13) gfx_fill_rect(x, y, 320 - x, 1, 0x7BEF);
    for (i = 0, x = 0x33, y = 0x6A; i < 5; i++, x += 0x36) gfx_fill_rect(x, y, 1, 0xB7 - y, 0x7BEF);
    gfx_draw_image(0x9A, 0x63, 1, &k_img_FFED249C);
    ui_draw_widget(6);
    g_screen_phase++;
}

/* FFEE75A5-FFEE75D2 (45 B) scope_phase2 [sub_FFEE75A5]  Confirmed. */
void scope_phase2(void)
{
    if (gfx_region_begin(&g_surf, 0, 0, 320, 240) == 1) { scope_redraw_all(); gfx_region_commit_next(); }
}

/* FFEE75D2-FFEE7606 (52 B) scope_key_scope [sub_FFEE75D2] key_tbl[32]. Confirmed. */
void scope_key_scope(void)
{
    if (gfx_region_begin(&g_surf, 0, 0x54, 320, 0x65) == 1) { scope_draw(0, 0x54); gfx_region_commit_next(); }
}

/* FFEE7606-FFEE768C (134 B) scope_phase3 [sub_FFEE7606]  Confirmed. */
void scope_phase3(void) { TOUCH_DISPATCH(scope_apply, k_scope_keys /* FFED4E80 */, 0x23); }

/* FFEE768C-FFEE76A8 (28 B) scope_apply [sub_FFEE768C]  Confirmed. */
void scope_apply(u8 first)
{
    frame_apply_opcode(); scope_apply_fields(); frame_apply_popup();
    if (first == 1) touch_keys_clear();
}

/* FFEE76A8-FFEE7945 (669 B) scope_apply_fields [sub_FFEE76A8]  Confirmed. */
void scope_apply_fields(void)
{
    u8 span = PEND(0x6D) % 3, i, k0, k1;
    frame_apply_header();
    g_block3_dst = &FRM(0x20);
    frame_sync_block3(&FRM(0x20), &PEND(0x20), 3);
    if (FRM(0x6C) != PEND(0x6C)) { ui_mark_dirty_hi(1); FRM(0x6C) = PEND(0x6C); }
    if (FRM(0x6D) != span)       { ui_mark_dirty_hi(1); FRM(0x6D) = span; }
    for (i = 0; i < k_scope_bars[span]; i++)
        if (FRM(0x6E + i) != PEND(0x6E + i)) { ui_mark_dirty_hi(1); FRM(0x6E + i) = PEND(0x6E + i); }
    for (i = 0; i < 3; i++) {
        switch (FRM(0x6D)) {
        case 0:  k0 = 0x81; k1 = 0x84; break;
        case 1:  k0 = 0x95; k1 = 0x98; break;
        case 2:  k0 = 0xBD; k1 = 0xC0; break;
        default: continue;
        }
        if (FRM(k0 + i) != PEND(k0 + i)) { ui_mark_dirty_hi(2u << i); FRM(k0 + i) = PEND(k0 + i); }
        if (FRM(k1 + i) != PEND(k1 + i)) { ui_mark_dirty_hi(2u << i); FRM(k1 + i) = PEND(k1 + i); }
    }
    if (FRM(9) != PEND(9)) FRM(9) = PEND(9);
    ui_flush_dirty();
}

/* FFEE7945-FFEE7985 (64 B) scope_redraw_all [sub_FFEE7945]  Confirmed. */
void scope_redraw_all(void)
{
    g_8D79 = 0;
    gfx_copy_bg(0, 0);
    ui_draw_status_strip();
    ui_set_layer(3);
    scope_draw_band();
    ui_set_layer(0xFF);
    scope_draw(0, 0x54);
    ui_draw_icon(0); ui_draw_icon(1); ui_draw_icon(2);
}

/* FFEE7985-FFEE79CB (70 B) scope_draw_band [sub_FFEE7985]
 * Same painter chain as mainalt_draw_band but the "type 2" order is
 * 5E38 then 6096 and the 643C/64D2 branch is absent. Confirmed. */
void scope_draw_band(void)
{
    const u8 *b = band_data();
    if (b[0] == 2) {
        band_part_5E38(); band_part_6096();
    } else {
        band_part_4FCE(); band_part_5202(); band_part_6096(); band_part_5E38();
        if (band_part_4CED() != 1) { band_part_5518(); band_part_59E4(); }
    }
    band_part_6023(); band_part_637D();
}

/* FFEE79CB-FFEE7C9F (724 B) scope_draw [sub_FFEE79CB]
 * Header glyph row at (185,86) 13 px apart (4 images for variant 0, 5
 * otherwise), span label at (267,86), then the bars. Level 1..10 maps to
 * a top y (175,167,160,152,145,138,130,123,115,108) and bar image
 * FFED31EC + 0x10*(level-1); each bar is drawn as `width` 1-px columns.
 * The jump table is jpt_FFEE7BD4 (10 byte offsets). Confirmed. */
void scope_draw(u16 x, u16 y)
{
    static const u16 lvl_y[10] = { 0xAF, 0xA7, 0xA0, 0x98, 0x91, 0x8A, 0x82, 0x7B, 0x73, 0x6C };
    u8  hdr = FRM(0x6C), span = FRM(0x6D), i, j, v, on;
    u16 hx = 0xB9, hy = 0x56, n, w, bx, by = 0;
    const u8 *lv;
    const void *img = 0;

    gfx_restore_bg(x, y, 320 - x, 0xB7 - y);
    if (hdr == 0) {
        gfx_blit(hx, hy, &k_img_FFECF4DC); hx += 13;
        gfx_blit(hx, hy, &k_img_FFECF6BC); hx += 13;
        gfx_blit(hx, hy, &k_img_FFECF59C); hx += 13;
        gfx_blit(hx, hy, &k_img_FFECF59C);
    } else {
        gfx_blit(hx, hy, &k_img_FFECE81C); hx += 13;
        gfx_blit(hx, hy, &k_img_FFECF69C); hx += 13;
        gfx_blit(hx, hy, &k_img_FFECF93C); hx += 13;
        gfx_blit(hx, hy, &k_img_FFECF9BC); hx += 13;
        gfx_blit(hx, hy, &k_img_FFECF8BC);
    }
    hx = 0x10B; hy = 0x56;
    if (span >= 3) span = 2;
    lv = &FRM(0x6E);
    if (span == 0) {
        n = 19; w = 16; bx = 8;
        gfx_blit(hx, hy, &k_img_FFECE81C); hx += 13; gfx_blit(hx, hy, &k_img_FFECEB1C);
    } else if (span == 1) {
        n = 39; w = 8; bx = 4;
        gfx_blit(hx, hy, &k_img_FFECE8DC); hx += 13; gfx_blit(hx, hy, &k_img_FFECEB1C);
    } else {
        n = 79; w = 4; bx = 2;
        gfx_blit(hx, hy, &k_img_FFECEA5C); hx += 13; gfx_blit(hx, hy, &k_img_FFECEB1C);
    }
    hx += 13; gfx_blit(hx, hy, &k_img_FFECF47C);
    hx += 13; gfx_blit(hx, hy, &k_img_FFECF51C);

    for (i = 0; i < n; i++) {
        v = lv[i];
        if (v >= 11) v = 10;
        on = 1;
        if (v >= 1 && v <= 10) {
            by  = lvl_y[v - 1];
            img = (const u8 *)&k_img_FFED31EC + (v - 1) * 0x10;   /* FFED31EC..FFED327C */
        } else {
            on = 0;
        }
        if (on == 1)
            for (j = 0; j < w; j++) gfx_draw_image(bx + j, by, on, img);
        bx += w;
    }
}

/* ======================================================================
 * Screens 0x07 / 0x16 - TX DTMF keypad header (MAIN F107) and the
 * PASSWORD screen (MAIN F006 -> 0x16, OP_HI == 0xF0; doc 12 section on
 * the CONFIG lock). Phase off_FFED4F10, keys off_FFED4F20 (<= 0x35).
 * F0 layout: +0x20 mode (0 input, else entry), +0x21 cursor,
 * +0x22..+0x25 digits (0 ends, 0xFF shown '-'), icons +0x26/+0x3A (20).
 * F1 layout: +0x24.. 25 bytes, icons +0x6C/+0x80 (20).
 * High bits: 0x100000 icons (key 52), 0x200000 header (key 53).
 * ====================================================================== */

/* FFEE7C9F-FFEE7CC9 (42 B) keypad_entry [sub_FFEE7C9F]  k_screen_tbl[7], [0x16]. Confirmed. */
void keypad_entry(void) { SCREEN_ENTRY(k_keypad_phase); /* FFED4F10 */ }

/* FFEE7CC9-FFEE7CDB (18 B) keypad_phase0 [sub_FFEE7CC9]  Confirmed. */
void keypad_phase0(void) { keypad_apply(1); g_screen_phase++; }

/* FFEE7CDB-FFEE7D15 (58 B) keypad_phase1_bg [sub_FFEE7CDB]
 * Both the F1 and the F0 branch draw widget 2. Confirmed. */
void keypad_phase1_bg(void)
{
    u8 op = OP_HI;
    gfx_fb_init();
    gfx_clear_screen();
    if (op == 0xF1)      ui_draw_widget(2);
    else if (op == 0xF0) ui_draw_widget(2);
    g_screen_phase++;
}

/* FFEE7D15-FFEE7D42 (45 B) keypad_phase2 [sub_FFEE7D15]  Confirmed. */
void keypad_phase2(void)
{
    if (gfx_region_begin(&g_surf, 0, 0, 320, 240) == 1) { keypad_redraw_all(); gfx_region_commit_next(); }
}

/* FFEE7D42-FFEE7D87 (69 B) keypad_key_header [sub_FFEE7D42] key_tbl[53]. Confirmed. */
void keypad_key_header(void)
{
    if (gfx_region_begin(&g_surf, 0, 0, 320, 0x20) == 1) {
        if (OP_HI == 0xF0) password_draw(0, 0);
        else               keypad_draw_freq();
        gfx_region_commit_next();
    }
}

/* FFEE7D87-FFEE7DB5 (46 B) keypad_key_icons [sub_FFEE7D87] key_tbl[52]. Confirmed. */
void keypad_key_icons(void)
{
    if (gfx_region_begin(&g_surf, 0, 0x20, 320, 0xD0) == 1) { keypad_draw_icons(); gfx_region_commit_next(); }
}

/* FFEE7DB5-FFEE7E3B (134 B) keypad_phase3 [sub_FFEE7DB5]  Confirmed. */
void keypad_phase3(void) { TOUCH_DISPATCH(keypad_apply, k_keypad_keys /* FFED4F20 */, 0x35); }

/* FFEE7E3B-FFEE7E57 (28 B) keypad_apply [sub_FFEE7E3B]  Confirmed. */
void keypad_apply(u8 first)
{
    frame_apply_opcode(); keypad_apply_fields(); frame_apply_popup();
    if (first == 1) touch_keys_clear();
}

/* FFEE7E57-FFEE803D (486 B) keypad_apply_fields [sub_FFEE7E57]
 * In the F1 branch the 3-byte block pointer is set but sub_FFEF42A7 is
 * not called. Confirmed. */
void keypad_apply_fields(void)
{
    u8 i;
    frame_apply_header();
    if (OP_HI == 0xF0) {
        if (g_blink_armed == 0) { ui_blink_subscribe(0x200000, 0); g_blink_armed = 1; }
        frame_sync_block_hi(&FRM(0x20), &PEND(0x20), 6, 0x200000);
        for (i = 0; i < 0x14; i++) {
            if (FRM(0x26 + i) != PEND(0x26 + i)) { ui_mark_dirty_hi(0x100000); FRM(0x26 + i) = PEND(0x26 + i); }
            if (FRM(0x3A + i) != PEND(0x3A + i)) { ui_mark_dirty_hi(0x100000); FRM(0x3A + i) = PEND(0x3A + i); }
        }
    } else {
        g_block3_dst = &FRM(0x20);
        if (FRM(9) != PEND(9)) FRM(9) = PEND(9);
        for (i = 0; i < 0x14; i++) {
            if (FRM(0x6C + i) != PEND(0x6C + i)) { ui_mark_dirty_hi(0x100000); FRM(0x6C + i) = PEND(0x6C + i); }
            if (FRM(0x80 + i) != PEND(0x80 + i)) { ui_mark_dirty_hi(0x100000); FRM(0x80 + i) = PEND(0x80 + i); }
        }
        for (i = 0; i < 0x19; i++)
            if (FRM(0x24 + i) != PEND(0x24 + i)) { ui_mark_dirty_hi(0x200000); FRM(0x24 + i) = PEND(0x24 + i); }
    }
    ui_flush_dirty();
}

/* FFEE803D-FFEE806F (50 B) keypad_redraw_all [sub_FFEE803D]
 * Doc 12 named this the password dispatcher (F0 -> password_draw). Confirmed. */
void keypad_redraw_all(void)
{
    u8 op = OP_HI;
    g_8D79 = 0;
    gfx_copy_bg(0, 0);
    if (op == 0xF0) password_draw(0, 0);
    else            keypad_draw_freq();
    keypad_draw_icons();
}

/* FFEE806F-FFEE80A9 (58 B) keypad_draw_freq [sub_FFEE806F]
 * Header line from the current band record: attribute word b[2..3] (BE)
 * and string b+4, drawn at (20,3) by sub_FFEFA7E7. Confirmed. */
void keypad_draw_freq(void)
{
    const u8 *b = band_data();
    u16 x = 6, y = 1;
    gfx_restore_bg(0, 0, 320, 0x20);
    gfx_draw_number_attr(x + 0x0E, y + 2, (u16)((b[2] << 8) | b[3]), b + 4);   /* sub_FFEFA7E7 */
}

/* FFEE80A9-FFEE8363 (698 B) password_draw [sub_FFEE80A9]
 * g_lang (0x8F72, language flag per RESUME-FULL) == 0 -> Japanese title:
 * 7-byte kana string FFF48580 then two JIS X 0208 kanji through the
 * glyph blitter: 0x467E 0x4E4F = "nyuuryoku" (input) when +0x20 == 0,
 * 0x4550 0x4F3F = "touroku" (registration/entry) otherwise. Non-zero ->
 * "PASSWORD INPUT" / "PASSWORD ENTRY". Doc 12 read 0x4E4F as "ON" and the
 * flag as password state; both readings are superseded.
 * Then four digit cells 14 px apart. Input mode: the cursor cell gets an
 * orange box and the glyph while the blink phase is on, and only a '-'
 * placeholder while off; other cells: 'Z' erases, anything else draws.
 * Entry mode: cursor box when blink on, glyph always.
 * Confidence: Confirmed. */
void password_draw(u16 x, u16 y)
{
    u8  blink, mode = FRM(0x20), cur = FRM(0x21), i, c, is_cur;
    u16 dx, dy = 3;
    gfx_restore_bg(0, 0, 320, 0x20);
    if (g_lang == 0) {
        dx = 0x30;
        gfx_draw_text(x + dx, y + dy, 0x0D, 0, 7, k_pw_title_ja /* FFF48580 */, 1);
        dx += 0x62;
        if (mode == 0) {
            gfx_draw_glyph(x + dx, y + dy, 2, 0x467E, 1); dx += 0x1C;
            gfx_draw_glyph(x + dx, y + dy, 2, 0x4E4F, 1);
        } else {
            gfx_draw_glyph(x + dx, y + dy, 2, 0x4550, 1); dx += 0x1C;
            gfx_draw_glyph(x + dx, y + dy, 2, 0x4F3F, 1);
        }
        dx += 0x1C;
    } else {
        dx = 0x1B;
        gfx_draw_text(x + dx, y + dy, 0x0D, 0, 0x0E,
                      mode == 0 ? "PASSWORD INPUT" : "PASSWORD ENTRY", 1);
        dx += 0xC4;
    }
    dx += 0x0E;
    blink = ui_blink_phase();
    for (i = 0; i < 4; i++, dx += 0x0E) {
        c = FRM(0x22 + i);
        if (c == 0) return;
        if (c == 0xFF) c = '-';
        is_cur = (i == cur);
        if (mode == 0) {
            if (is_cur) {
                if (blink == 1) {
                    gfx_fill_rect(x + dx, y + dy, 0x0E, 0x1C, 0xF980);
                    gfx_draw_glyph(x + dx, y + dy, 0x0D, c, 1);
                } else if (c == '-') {
                    gfx_draw_glyph(x + dx, y + dy, 0x0D, c, 1);
                }
            } else if (c == 'Z') {
                gfx_restore_bg(x + dx, y + dy, 0x0E, 0x1C);
            } else {
                gfx_draw_glyph(x + dx, y + dy, 0x0D, c, 1);
            }
        } else {
            if (is_cur && blink == 1) gfx_fill_rect(x + dx, y + dy, 0x0E, 0x1C, 0xF980);
            gfx_draw_glyph(x + dx, y + dy, 0x0D, c, 1);
        }
    }
}

/* FFEE8363-FFEE837F (28 B) keypad_draw_icons [sub_FFEE8363]  icons 0..19. Confirmed. */
void keypad_draw_icons(void) { u8 i; for (i = 0; i < 0x14; i++) ui_draw_icon(i); }

/* ======================================================================
 * Screen 0x00 - main display, dual band (MAIN page F100; doc 43: acts
 * only on F1 frames). Phase off_FFED4FF8, keys off_FFED5008 (<= 0x35);
 * keys 15..31 and 54.. are the shared F1 handlers just after this range.
 * +0x20 (1 B) and +0x6C (2 B) through the block applier, +0xB8 bar flag,
 * icon pairs +0xB9/+0xBF (high bit 0x200000 = key 53), +0x09 bit 4
 * (band layout) change restarts the screen.
 * ====================================================================== */

/* FFEE837F-FFEE83B7 (56 B) main_entry [sub_FFEE837F]  k_screen_tbl[0]. Confirmed. */
void main_entry(void)
{
    if (PEND(0) != 0xF1) return;
    SCREEN_ENTRY(k_main_phase);               /* FFED4FF8 */
}

/* FFEE83B7-FFEE83C9 (18 B) main_phase0 [sub_FFEE83B7]  Confirmed. */
void main_phase0(void) { main_apply(1); g_screen_phase++; }

/* FFEE83C9-FFEE841C (83 B) main_phase1_bg [sub_FFEE83C9]  Confirmed. */
void main_phase1_bg(void)
{
    gfx_fb_init();
    ui_clear_with_status();
    if (FRM(0xB8) != 0) {
        gfx_fill_rect(k_rects_6058[0].x, k_rects_6058[0].y,
                      320 - k_rects_6058[0].x, 240 - k_rects_6058[0].y, 0x0000);
        ui_draw_widget(0x0C);
    } else {
        ui_draw_widget(6);
    }
    g_screen_phase++;
}

/* FFEE841C-FFEE8449 (45 B) main_phase2 [sub_FFEE841C]  Confirmed. */
void main_phase2(void)
{
    if (gfx_region_begin(&g_surf, 0, 0, 320, 240) == 1) { main_redraw_all(); gfx_region_commit_next(); }
}

/* FFEE8449-FFEE84A0 (87 B) main_key_softkeys [sub_FFEE8449] key_tbl[53]. Confirmed. */
void main_key_softkeys(void)
{
    u8 idx = (FRM(0xB8) == 0) ? 3 : 0;
    const rect16_t *r = &k_rects_6058[idx];
    if (gfx_region_begin(&g_surf, r->x, r->y, 320 - r->x, 240 - r->y) == 1) {
        main_draw_icons();
        gfx_region_commit_next();
    }
}

/* FFEE84A0-FFEE8526 (134 B) main_phase3 [sub_FFEE84A0]  Confirmed. */
void main_phase3(void) { TOUCH_DISPATCH(main_apply, k_main_keys /* FFED5008 */, 0x35); }

/* FFEE8526-FFEE8542 (28 B) main_apply [sub_FFEE8526]  Confirmed. */
void main_apply(u8 first)
{
    frame_apply_opcode(); main_apply_fields(); frame_apply_popup();
    if (first == 1) touch_keys_clear();
}

/* FFEE8542-FFEE86A4 (354 B) main_apply_fields [sub_FFEE8542]
 * Icon changes all raise the same high bit 0x200000 (not shifted per
 * icon). With the bar on, high requests 10..13 (0x3C00) are cancelled.
 * Confirmed. */
void main_apply_fields(void)
{
    u8 i;
    frame_apply_header();
    g_block3_dst = &FRM(0x20);
    frame_sync_block3(&FRM(0x20), &PEND(0x20), 1);
    frame_sync_block3(&FRM(0x6C), &PEND(0x6C), 2);
    SYNC_BLOCK(0xB8, 1, 1);
    for (i = (PEND(0xB8) == 0) ? 3 : 0; i < 6; i++) {
        if (FRM(0xB9 + i) != PEND(0xB9 + i)) { ui_mark_dirty_hi(0x200000); FRM(0xB9 + i) = PEND(0xB9 + i); }
        if (FRM(0xBF + i) != PEND(0xBF + i)) { ui_mark_dirty_hi(0x200000); FRM(0xBF + i) = PEND(0xBF + i); }
    }
    if (((FRM(9) & 0x10) >> 4) != ((PEND(9) & 0x10) >> 4)) {
        touch_keys_clear();
        ui_mark_dirty(1);
    }
    if (FRM(9) != PEND(9)) FRM(9) = PEND(9);
    ui_flush_dirty();
    if (PEND(0xB8) != 0) ui_req_clear_hi(0x3C00);
}

/* FFEE86A4-FFEE86D6 (50 B) main_redraw_all [sub_FFEE86A4]  Confirmed. */
void main_redraw_all(void)
{
    g_8D79 = 0;
    gfx_copy_bg(0, 0);
    ui_draw_status_strip();
    ui_set_layer(1); main_draw_band();
    ui_set_layer(2); main_draw_band();
    ui_set_layer(0xFF);
    main_draw_icons();
}

/* FFEE86D6-FFEE87A1 (203 B) main_draw_band [sub_FFEE86D6]
 * "Compact" painting (only 6096/5E38) for a type-2 band record when the
 * +0x09 b4 layout and band_mode() agree (b4 0 & mode 2, or b4 1 & mode 1);
 * otherwise the full chain. In band_mode 2 with the bar on the icons are
 * repainted instead of the 6023/637D tail. Confirmed. */
void main_draw_band(void)
{
    const u8 *b = band_data();
    u8 kind = b[0], mode = band_mode(), compact = 0;
    if (kind == 2) {
        if (((FRM(9) & 0x10) >> 4) == 0) { if (mode == 2) compact = 1; }
        else if (((FRM(9) & 0x10) >> 4) == 1 && mode == 1) compact = 1;
    }
    if (compact == 1) {
        band_part_6096(); band_part_5E38();
    } else {
        band_part_4FCE(); band_part_5202(); band_part_535E(); band_part_5421();
        band_part_5494(); band_part_6096(); band_part_5E38();
        if (band_part_4CED() == 1) { band_part_643C(); band_part_64D2(); }
        else                       { band_part_5518(); band_part_59E4(); }
        band_part_55FB(); band_part_541D();
    }
    if (band_mode() == 2 && FRM(0xB8) != 0) main_draw_icons();
    else { band_part_6023(); band_part_637D(); }
}

/* FFEE87A1-FFEE87EE (77 B) main_draw_icons [sub_FFEE87A1]  (bar +0xB8). Confirmed. */
void main_draw_icons(void)
{
    u8 i = 0;
    if (FRM(0xB8) == 0) i = 3;
    else gfx_restore_bg(k_rects_6058[0].x, k_rects_6058[0].y,
                        320 - k_rects_6058[0].x, 240 - k_rects_6058[0].y);
    for (; i < 6; i++) ui_draw_icon(i);
}
