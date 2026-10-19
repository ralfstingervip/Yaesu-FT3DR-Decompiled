/* ============================================================================
 * sub-FFEF535E-FFEFB2C2.c  -  wave-C hand reconstruction, SUB core (RX64M, CC-RX)
 *
 * DOCUMENTATION ONLY.  Hand transcription of the IDA listing chunk
 * sub-FFEF535E-FFEFB2C2.lst (54 functions, 0xFFEF535E..0xFFEFB2C2).  Nothing
 * here was compiled or run.  Little-endian, args r1..r4 (+stack), return r1.
 *
 * WHAT THIS RANGE IS
 *   The SUB-side LCD "widget" layer for the 320x240 RGB565 framebuffer:
 *     - per-band status-row items of the operating screen (mode icon, tone /
 *       DCS readout, DG-ID, APRS baud tag, S-meter, VOL/SQL bar, band name),
 *     - the large frequency readout (sub_FFEF6C42, 11.7 KB),
 *     - generic primitives: icon draw/erase, shaped draw/erase, string
 *       renderers (1-bpp font and RGB565 fonts), bevel/grid frames, scroll
 *       bars, rounded panels, screen clears, memcpy / memset.
 *   Every per-band item reads the *band display record* that MAIN sends in the
 *   status frame (shadow at 0x8C4D, see below) and is placed by a per-item
 *   position helper in 0xFFEECxxx..0xFFEEFxxx (outside this lane).
 *
 * CONVENTIONS / ENCODING NOTES
 *   - IDA prints 8-bit unsigned immediates as negative ("cmp #-10h", "mov.w
 *     #-7Dh").  RX CMP/MOV #UIMM8 zero-extend, so -10h is 0xF0 (240), -11h is
 *     0xEF, -7Dh is 0x83 (131), -74h is 0x8C, -20h is 0xE0, -3Ch is 0xC4,
 *     -0Fh is 0xF1, -9 is 0xF7, -8 is 0xF8, -3 is 0xFD.  The firmware's own
 *     comparisons (frame opcodes 0xF1/0xF7/0xF8/0xFD, clip height 240) confirm
 *     this reading.  Constants below are written unsigned.
 *   - "Off-screen" guard used by every item:   x > 319 || y >= 240  -> skip.
 *   - Many items take a third position output "dim": 0xFFFF = normal colours,
 *     anything else = the dimmed (inactive band) variant.  RAM icon-pointer
 *     tables are laid out [style][index] with style 0 = normal, 1 = dim.
 *   - "show" tri-state fields (2-bit): 0 = hidden, 1 = shown, 2 = blinking
 *     (visible when blink_phase()==1).
 * ========================================================================== */

#include <stdint.h>
typedef uint8_t u8;  typedef uint16_t u16;  typedef uint32_t u32;
typedef int8_t  s8;  typedef int16_t  s16;  typedef int32_t  s32;

/* ---- RGB565 bitmap descriptor (16 bytes; doc 16 / bitmap_catalogue.tsv) --- */
typedef struct {
    u16 w, h;            /* +0, +2 */
    const u16 *pix;      /* +4  RGB565 source                              */
    u16 key;             /* +8  transparent colour key                     */
    u16 tint;            /* +A  tint colour                                */
    u16 tint_on;         /* +C  1 = apply tint                             */
    u16 pad;
} BmpDesc;

typedef struct { u16 idx, x, y; } FieldCoord;   /* 6-byte FIELD_COORD (doc 27) */

/* ---- RAM globals (address, meaning) -------------------------------------- */
extern volatile u8  g_ui_substate;          /* 0x00008C4C  per-screen sub-state (doc 23/31)        */
extern volatile u8  g_frame[];              /* 0x00008C4D  MAIN->SUB status-frame shadow:
                                               [0]=opcode hi (0xF1 main screen, 0xF3, 0xF6, 0xF7,
                                               0xF8, 0xFD), [1]=opcode lo / screen id (doc pc-04),
                                               [9] bit4 = dual-band/alt layout flag (Inferred),
                                               +0x20 band-A display record, +0x6C band-B record,
                                               +0x31 / +0x7D alternates (see band_rec_ptr)       */
extern volatile u8  g_redraw_freq_a;        /* 0x00008F77  force full frequency redraw (doc 31)     */
extern volatile u8  g_redraw_freq_b;        /* 0x00008F78  "    , also set after name draws       */
extern volatile u8  g_freq_cache_t4[10];    /* 0x00008F79  digit cache, row-type 4                   */
extern volatile u8  g_freq_cache_t13[10];   /* 0x00008F83  digit cache, row-type 1/3                 */
extern volatile u8  g_freq_cache_t2[10];    /* 0x00008F8D  digit cache, row-type 2                   */
extern volatile u8  g_band_row_override;    /* 0x00012285  !=0xFF forces band_row_type() result      */
extern volatile u8  g_freq_blinkmode_t4;    /* 0x00012286  last rec[0x2F] drawn, type 4              */
extern volatile u8  g_freq_blinkmode_t13;   /* 0x00012287  last rec[0x2F] drawn, type 1/3            */
extern volatile u8  g_freq_blinkmode_t2;    /* 0x00012288  last rec[0x2F] drawn, type 2              */
extern void * volatile g_lcd_ctx;           /* 0x0001D3C8  display context; +0xC = framebuffer       */
extern volatile u32 g_blink_tick;           /* 0x00068858  (=0x68854+4) bit0 = blink phase          */
extern const BmpDesc *g_mode_icons[2][14];  /* 0x00068514  communication-mode icons [dim][mode]      */
extern const BmpDesc *g_font12[94];         /* 0x000688BC  RGB565 font, chars 0x21..0x7E, 12-px pitch*/
extern const BmpDesc *g_font20[94];         /* 0x00068A34  RGB565 font, chars 0x21..0x7E, 20-px pitch*/
extern const BmpDesc *g_font8num[94];       /* 0x00068BAC  small font, only 0-9 : i k m . - used     */
extern const BmpDesc *g_dgid_digits[5][11]; /* 0x00068D24  DG-ID digit glyphs [style][digit]        */
extern const BmpDesc *g_rec3e_icons[2][11]; /* 0x00068E2C  rec[0x3E] value glyphs [dim][v-1]        */
extern const BmpDesc *g_tone_glyphs[11];    /* 0x00068E84  tone/DCS readout glyphs (digit, '.')     */
extern const BmpDesc *g_tonemode_icons[2][12]; /* 0x00068EB0  tone-mode icons [dim][mode]           */
extern const BmpDesc *g_rec48_icons[2][2];  /* 0x00068F10  rec[0x48] bits0-1 icons [dim][0/1]      */
extern const BmpDesc *g_freq_digits[10][10];/* 0x00068F20  ten frequency digit sets, 0x28 apart:
                                               68F20 68F48 68F70 68F98 68FC0 68FE8 69010 69038 69060 69088 */
#define BG_SURFACE  ((const u16 *)0x07000000u)  /* background image used for erase (CS area) */

/* ---- flash data -------------------------------------------------------- */
extern const BmpDesc icon_FFECE72C, icon_FFECE7BC, icon_FFECE81C, icon_FFECEE4C,
    icon_FFECEE6C, icon_FFECEE7C, icon_FFECEE8C, icon_FFECEE9C, icon_FFECEECC,
    icon_FFECEF3C, icon_FFECEF4C, icon_FFECEF7C, icon_FFECEFDC, icon_FFECF13C,
    icon_FFECF17C, icon_FFECF18C, icon_FFECF43C, icon_FFECF44C, icon_FFECF59C,
    icon_FFECF5AC, icon_FFED1F2C, icon_FFED214C, icon_FFED220C, icon_FFED221C,
    icon_FFED241C, icon_FFED242C, icon_FFED2B5C, icon_FFED2DCC, icon_FFED2DDC,
    icon_FFED2DEC, icon_FFED2DFC, icon_FFED2E0C, icon_FFED2E1C, icon_FFED2E2C,
    icon_FFED2E3C, icon_FFED2E4C, icon_FFED2E5C, icon_FFED2F7C, icon_FFED2F8C,
    icon_FFED33FC, icon_FFED340C, icon_FFED341C, icon_FFED342C, icon_FFED39CC,
    icon_FFED39DC, icon_FFED39EC, icon_FFED3A2C, icon_FFED3A3C, icon_FFED3A4C,
    icon_FFED3A5C, icon_FFED3A6C, icon_FFED3A7C, icon_FFED3B9C, icon_FFED3BAC,
    icon_FFED3C1C, icon_FFED3C3C, icon_FFED3C5C, icon_FFED3C7C, icon_FFED3C9C,
    icon_FFED3CBC, icon_FFED3CDC, icon_FFED3CFC, icon_FFED3D1C, icon_FFED3D3C,
    icon_FFED3D5C, icon_FFED3D7C, icon_FFED3D9C, icon_FFED3E7C, icon_FFED3E9C,
    icon_FFED3EAC;
extern const char  ctcss_text_FFC3D8C2[50][5];   /* 50 CTCSS tones, 5 glyph indices each */
extern const char  dcs_text_FFC3D9BC[104][3];    /* 104 DCS codes, 3 glyph indices each  */
extern const FieldCoord freq_coord_FFEC61A8[10], freq_coord_FFEC61E4[10],
                        freq_coord_FFEC6220[10], freq_coord_FFEC625C[10];
extern const char aA12_0[], aA96_0[];            /* "A12" / "A96" (APRS 1200/9600)     */

/* ---- callees outside this lane (names given here; addresses authoritative) */
extern u8  *band_rec_ptr(void);                 /* sub_FFEEC3BD: &g_frame[0x20|0x31|0x6C|0x7D] for the
                                                   band row being drawn (by opcode + band_row_type) */
extern u8   band_row_type(void);                /* sub_FFEEC232: 1 upper row, 2 lower row, 3 single /
                                                   other screens, 4 only via g_band_row_override    */
extern u8   blink_phase(void);                  /* sub_FFEF02F2: g_blink_tick & 1                    */
extern void lcd_restore_bg(u16 x, u16 y, u16 w, u16 h);   /* sub_FFEF04F7: copy rect from BG_SURFACE */
extern void lcd_fill_white(u16 x, u16 y, u16 w, u16 h);   /* sub_FFEF0553                           */
extern void lcd_blit(u16 x, u16 y, const BmpDesc *d);     /* sub_FFEF0648: RGB565 key/tint blit     */
extern void lcd_blit_shaped(u16 x, u16 y, const BmpDesc *d);  /* sub_FFEF0949: per-row span mask
                                                   (GLYPH_METRIC spans by height 16/20/28/38/52)    */
extern void lcd_erase_glyph(u16 x, u16 y, const BmpDesc *d);  /* sub_FFEF0AFE: restore BG under the
                                                   non-key pixels of d                               */
extern void lcd_erase_shaped(u16 x, u16 y, const BmpDesc *d); /* sub_FFEF0BD4: same spans, from BG  */
extern void lcd_blit_alt(u16 x, u16 y, const BmpDesc *d);     /* sub_FFEF0D92 (used on F7 screens)   */
extern void glyph_draw_dbcs(u16 x, u16 y, u8 blk, u16 code, u8 big);          /* sub_FFEF190D */
extern void glyph_draw_dbcs_col(u16 x, u16 y, u8 blk, u16 code, u8 big, u16 col); /* sub_FFEF1A16 */
extern void glyph_draw_sbcs(u16 x, u16 y, u8 blk, u8 a4, u8 n, const u8 *ch, u8 big);   /* sub_FFEF1B23 */
extern void glyph_draw_sbcs_col(u16 x, u16 y, u8 blk, u8 a4, u8 n, u16 col, const u8 *ch, u8 big); /* sub_FFEF1BB1 */
extern void lcd_fill_rect(u16 x, u16 y, u16 w, u16 h, u16 rgb565);  /* sub_FFEF1C48 */
/* per-item position helpers: write x,y (0xFFFF = not shown) [+ dim] for the current row */
extern void pos_icon34(u16 *x, u16 *y);                       /* sub_FFEECAE0 */
extern void pos_icon3d_b23(u16 *x, u16 *y);                   /* sub_FFEECC17 */
extern void pos_icon3d_b01(u16 *x, u16 *y);                   /* sub_FFEECD4E */
extern void pos_icon3d_b45(u16 *x, u16 *y, u16 *dim);         /* sub_FFEECE85 */
extern void pos_icon3d_b67(u16 *x, u16 *y);                   /* sub_FFEED16E */
extern u8   pos_tone(u16 *x, u16 *y, u16 *dim);               /* sub_FFEED293 (returns wide flag) */
extern void pos_icon48(u16 *x, u16 *y, u16 *dim);             /* sub_FFEED5A7 */
extern void pos_aprs(u16 *x, u16 *y, u16 *tint);              /* sub_FFEED748 */
extern void pos_volsql(u16 *x, u16 *y);                       /* sub_FFEED8E9 */
extern void pos_levelbar(u16 *x, u16 *y);                     /* sub_FFEEDB0C */
extern void pos_smeter_frame(u16 *x, u16 *y);                 /* sub_FFEEDD2E */
extern void pos_smeter(u16 *x, u16 *y);                       /* sub_FFEEDF40 */
extern void pos_freq(u16 *x, u16 *y, u8 *layout);             /* sub_FFEEE512 (layout 0..5) */
extern void pos_rec3e(u16 *x, u16 *y, u16 *dim);              /* sub_FFEEE7AB */
extern void pos_dgid(u16 *tx_x, u16 *tx_y, u16 *rx_x, u16 *rx_y, u16 *dim); /* sub_FFEEE970 */
extern void pos_mode(u16 *x, u16 *y, u16 *dim);               /* sub_FFEEED50 */
extern void pos_bigname(u16 *x, u16 *y, u16 *tint);           /* sub_FFEEF0AA */

#define OFFSCREEN(x, y)   ((x) > 319 || (y) >= 240)
#define FRAME_OP          (g_frame[0])
#define FRAME_SUB         (g_frame[1])
#define DUAL_FLAG         ((g_frame[9] & 0x10) >> 4)

static u8 tri_state(u8 v)            /* the recurring 2-bit show/blink decode */
{
    if (v == 1) return 1;
    if (v == 2) return blink_phase();
    return 0;
}

/* forward declarations of functions in this file */
void icon_draw_or_erase(u16 x, u16 y, u8 visible, const BmpDesc *d);
void shape_draw_or_erase(u16 x, u16 y, u8 visible, const BmpDesc *d);
void bandrow_draw_dgid(void);
void bandrow_draw_rec3e(void);
void bandrow_draw_level_bar(void);
void freq_draw_digits(u8 *rec);
void level_bar_draw(u8 kind, u16 x, u16 y, u8 value);
void smeter_draw_segments(void);
void text_draw_mixed(u16 x, u16 y, u16 dbcs_mask, const u8 *s);
void rgbtext_draw_12(u16 x, u16 y, u16 spacing, const u8 *s, u16 len, u16 tint);
void rgbtext_draw_20(u16 x, u16 y, u16 spacing, const u8 *s, u16 len, u16 tint);
void rgbtext_draw_num8(u16 x, u16 y, u16 spacing, const u8 *s, u16 len, u16 tint);
void bevel_box_row_draw(u16 x, u16 y, u16 w, u16 h, u16 gap, u8 first, u8 end);

/* ==========================================================================
 * FFEF535E-FFEF53FE (160)  bandrow_draw_icon34   [IDA sub_FFEF535E]
 * Callers: FFEE86D6, FFEEB2A1, FFEEB99E, FFF4026F, FFF44EE1, FFF453BB.
 * Draws the 16x16 icon selected by band-record byte 0x34: (v & 0x7F) 1/2/3
 * selects icon FFECEE8C / FFECEE7C / FFECEE6C; bit7 set = blink.  Meaning of
 * the field not proven (a 3-valued per-band attribute).            Confirmed
 * ========================================================================== */
void bandrow_draw_icon34(void)
{
    const BmpDesc *icon = &icon_FFECEE6C;
    u8 *rec = band_rec_ptr();
    u16 x, y;
    u8 vis;

    pos_icon34(&x, &y);
    if (OFFSCREEN(x, y)) return;
    lcd_restore_bg(x, y, 16, 16);

    vis = 1;
    switch (rec[0x34] & 0x7F) {
    case 3: icon = &icon_FFECEE6C; break;
    case 2: icon = &icon_FFECEE7C; break;
    case 1: icon = &icon_FFECEE8C; break;
    default: vis = 0; break;
    }
    if (vis != 1) return;
    if ((rec[0x34] >> 7) == 1) vis = blink_phase();
    icon_draw_or_erase(x, y, vis, icon);
}

/* FFEF53FE-FFEF541D (31)  dead_draw_icon_ee9c  [IDA dead_FFEF53FE]  no xrefs.
 * Draws the 12x16 icon FFECEE9C at the fixed point (100,20).      Confirmed */
void dead_draw_icon_ee9c(void) { icon_draw_or_erase(100, 20, 1, &icon_FFECEE9C); }

/* FFEF541D-FFEF5421 (4)  bandrow_draw_rec3e_thunk  [IDA sub_FFEF541D]
 * Tail-thunk to bandrow_draw_rec3e.  Callers: FFEE86D6, FFEEB2A1, FFEEC08D,
 * bandrow_draw_main (x3).                                          Confirmed */
void bandrow_draw_rec3e_thunk(void) { bandrow_draw_rec3e(); }

/* ==========================================================================
 * FFEF5421-FFEF5494 (115)  bandrow_draw_icon3d_b23   [IDA sub_FFEF5421]
 * Callers: FFEE86D6, FFEEB2A1, FFEEB9F8, FFF4026F, FFF44EE1, FFF453BB.
 * Band-record 0x3D bits 2-3 (tri-state) show / blink the 12x16 icon
 * FFECF13C in a 12x16 cell.                                         Confirmed
 * ========================================================================== */
void bandrow_draw_icon3d_b23(void)
{
    u8 *rec = band_rec_ptr();
    u16 x, y;
    u8 vis;

    pos_icon3d_b23(&x, &y);
    if (OFFSCREEN(x, y)) return;
    lcd_restore_bg(x, y, 12, 16);
    vis = tri_state((rec[0x3D] & 0x0C) >> 2);
    if (vis == 1) icon_draw_or_erase(x, y, vis, &icon_FFECF13C);
}

/* ==========================================================================
 * FFEF5494-FFEF5518 (132)  bandrow_draw_icon3d_b01   [IDA sub_FFEF5494]
 * Callers: FFEE86D6, FFEEB2A1, FFEEBA52, FFF4026F, FFF44EE1, FFF453BB.
 * Band-record 0x3D bits 0-1: 1 -> icon FFECF18C, 2 -> icon FFECEE9C (both
 * 12x16), else nothing (cell is cleared).  No blink here.            Confirmed
 * ========================================================================== */
void bandrow_draw_icon3d_b01(void)
{
    const BmpDesc *icon = &icon_FFECF18C;
    u8 *rec = band_rec_ptr();
    u16 x, y;
    u8 vis;

    pos_icon3d_b01(&x, &y);
    if (OFFSCREEN(x, y)) return;
    lcd_restore_bg(x, y, 12, 16);
    switch (rec[0x3D] & 3) {
    case 1:  vis = 1; icon = &icon_FFECF18C; break;
    case 2:  vis = 1; icon = &icon_FFECEE9C; break;
    default: vis = 0; break;
    }
    if (vis == 1) icon_draw_or_erase(x, y, vis, icon);
}

/* Communication-mode byte rec[0x3F] (0..0x1B).  0x0E..0x14 and 0x15..0x1B are
 * the same 7 modes in two blink/AMS variants; folded back to 7..13.  The
 * "digital" class used to choose DG-ID vs tone display is m<4 || 7<=m<=10.
 * (Mode names Inferred; the folding and class test are Confirmed.)            */
static u8 mode_fold(u8 m)
{
    if (m <= 0x1B && m >= 0x0E) m = (m <= 0x14) ? (u8)(m - 7) : (u8)(m - 14);
    return m;
}
static int mode_is_digital(u8 m) { return m < 4 || (m >= 7 && m <= 10); }

/* ==========================================================================
 * FFEF5518-FFEF55FB (227)  bandrow_draw_icon3d_b45_or_dgid   [IDA sub_FFEF5518]
 * Callers (13): FFEDED67, FFEE683A, FFEE7985, FFEE86D6, FFEE8A44, FFEEAE29,
 * FFEEB2A1, FFEEBB19, FFEEBD3E, FFF4026F, FFF4112D, FFF44EE1, FFF453BB.
 * In a digital mode the slot shows the DG-ID pair instead (tail call to
 * bandrow_draw_dgid).  Otherwise rec[0x3D] bits 4-5 (tri-state) show the
 * 12x12 icon FFED2F7C, or its grey-tinted twin FFED2F8C on a dimmed row.
 *                                                                  Confirmed
 * ========================================================================== */
void bandrow_draw_icon3d_b45_or_dgid(void)
{
    u8 *rec = band_rec_ptr();
    u8 mode = rec[0x3F];
    u16 x, y, dim;
    u8 vis;

    pos_icon3d_b45(&x, &y, &dim);
    if (OFFSCREEN(x, y)) return;
    lcd_restore_bg(x, y, 12, 12);

    mode = mode_fold(mode);
    if (mode_is_digital(mode)) { bandrow_draw_dgid(); return; }

    vis = tri_state((rec[0x3D] & 0x30) >> 4);
    icon_draw_or_erase(x, y, vis, (dim == 0xFFFF) ? &icon_FFED2F7C : &icon_FFED2F8C);
}

/* ==========================================================================
 * FFEF55FB-FFEF566C (113)  bandrow_draw_icon3d_b67   [IDA sub_FFEF55FB]
 * Callers: FFEE86D6, FFEEB2A1, FFEEBB76, FFF44EE1, FFF453BB.
 * rec[0x3D] bits 6-7 (tri-state) show the 30x14 icon FFECEECC.      Confirmed
 * ========================================================================== */
void bandrow_draw_icon3d_b67(void)
{
    u8 *rec = band_rec_ptr();
    u16 x, y;
    u8 vis;

    pos_icon3d_b67(&x, &y);
    if (OFFSCREEN(x, y)) return;
    lcd_restore_bg(x, y, 30, 14);
    vis = tri_state(rec[0x3D] >> 6);
    if (vis == 1) icon_draw_or_erase(x, y, vis, &icon_FFECEECC);
}

/* two-digit 00..99 drawn from g_dgid_digits[style]; >99 erases both cells */
static void dgid_two_digits(u16 *x, u16 y, u8 style, u8 v)
{
    if (v <= 99) {
        icon_draw_or_erase(*x, y, 1, g_dgid_digits[style][v / 10]);
        *x += 13;
        icon_draw_or_erase(*x, y, 1, g_dgid_digits[style][v % 10]);
    } else {
        icon_draw_or_erase(*x, y, 0, g_dgid_digits[style][0]);
        *x += 13;
        icon_draw_or_erase(*x, y, 0, g_dgid_digits[style][0]);
    }
}

/* ==========================================================================
 * FFEF566C-FFEF59E4 (888)  bandrow_draw_dgid   [IDA sub_FFEF566C]
 * Callers: bandrow_draw_icon3d_b45_or_dgid, bandrow_draw_mode_icon.
 * DG-ID readout: rec[0x49] = TX DG-ID, rec[0x4A] = RX DG-ID, 0..99 (0xFF =
 * absent).  Each is a 21x18 label icon followed by two digits 13 px apart.
 * Analog modes clear the RX row instead.  Screen-specific early exits:
 * F1/0x14 with frame[0x8E] bit1 clear, F1/0x12 with frame[0x20]==2 clear both
 * rows; F1/0x0B with frame[0x20]==2 clears the TX row.
 * Inferred: body traced fully; the "DG-ID" meaning rests on the 0..99 range
 * and the digital-mode gate.
 * ========================================================================== */
void bandrow_draw_dgid(void)
{
    u8 *rec = band_rec_ptr();
    u8 mode = rec[0x3F];
    u16 tx_x, tx_y, rx_x, rx_y, dim;
    u8 v, style;

    pos_dgid(&tx_x, &tx_y, &rx_x, &rx_y, &dim);

    if (FRAME_OP == 0xF1) {
        if (FRAME_SUB == 0x14) {
            if (!(g_frame[0x8E] & 0x02)) {
                lcd_restore_bg(tx_x, tx_y, 320 - tx_x, 20);
                lcd_restore_bg(rx_x, rx_y, 320 - rx_x, 20);
                return;
            }
        } else if (FRAME_SUB == 0x12) {
            if (g_frame[0x20] == 2) {
                lcd_restore_bg(tx_x, tx_y, 320 - tx_x, 20);
                lcd_restore_bg(rx_x, rx_y, 320 - rx_x, 20);
                return;
            }
        } else if (FRAME_SUB == 0x0B) {
            if (g_frame[0x20] == 2) { lcd_restore_bg(tx_x, tx_y, 320 - tx_x, 20); return; }
        }
    }

    if (OFFSCREEN(tx_x, tx_y)) return;
    if (rec[0x49] == 0xFF) return;
    lcd_restore_bg(tx_x, tx_y, 48, 20);

    if (!mode_is_digital(mode)) {                     /* note: raw rec[0x3F], not folded */
        if (rx_x <= 319 && rx_y <= 239)
            lcd_restore_bg(rx_x, rx_y, 320 - rx_x, 20);
        return;
    }

    v = rec[0x49];                                    /* ---- TX DG-ID ---- */
    if (v != 0xFF) {
        if (dim == 0xFFFF) { icon_draw_or_erase(tx_x, tx_y, 1, &icon_FFED3E9C); style = 2; }
        else               { icon_draw_or_erase(tx_x, tx_y, 1, &icon_FFED3EAC); style = 3; }
        tx_x += 23;
        dgid_two_digits(&tx_x, tx_y, style, v);
    }

    v = rec[0x4A];                                    /* ---- RX DG-ID ---- */
    if (v == 0xFF) return;
    if (OFFSCREEN(rx_x, rx_y)) return;
    lcd_restore_bg(rx_x, rx_y, 320 - rx_x, 20);
    lcd_restore_bg(rx_x, rx_y - 2, 320 - rx_x, 22);
    v = rec[0x4A];
    if (v == 0xFF) return;
    icon_draw_or_erase(rx_x, rx_y, 1, &icon_FFED3E7C);
    style = 4;
    rx_x += 23;
    dgid_two_digits(&rx_x, rx_y, style, v);
}

/* ==========================================================================
 * FFEF59E4-FFEF5E38 (1108)  bandrow_draw_tone_dcs   [IDA sub_FFEF59E4]
 * Callers (13): FFEDED67, FFEE683A, FFEE7985, FFEE86D6, FFEE8A44, FFEEAE29,
 * FFEEB2A1, FFEEBBD0, FFEEBD3E, FFF4026F, FFF4112D, FFF44EE1, FFF453BB.
 * Analog modes only.  rec[0x45] = tone mode (bit7 = blink, low 7 bits 0..11),
 * rec[0x46] = CTCSS index 0..49, rec[0x47] = DCS index 0..103.  Draws the
 * tone-mode icon g_tonemode_icons[dim][mode] (skipped for mode 0, 8, 100)
 * then, 0x29 px right, the value text built from flash text tables:
 *   modes 1,2,4,10 -> CTCSS "ddd.d" (index <= 11 means < 100 Hz: 4 glyphs,
 *                     leading 11-px skip); glyph pitch 11, 5 px after '.'
 *   modes 3,9,11   -> DCS "ddd", pitch 13.
 * 50 tones / 104 codes match the standard CTCSS / DCS sets.   Confirmed
 * ========================================================================== */
void bandrow_draw_tone_dcs(void)
{
    u8 *rec = band_rec_ptr();
    u8 tmode = rec[0x45];
    u8 mode  = mode_fold(rec[0x3F]);
    u16 x, y, dim, dx, dy;
    u8 wide, type, op, sub, kind, i, n, g;

    if (mode_is_digital(mode)) return;

    wide = pos_tone(&x, &y, &dim);
    if (OFFSCREEN(x, y)) return;
    if ((tmode & 0x7F) > 11) return;

    if (wide == 1) lcd_restore_bg(x, y - 2, 320 - x, 20);
    else           lcd_restore_bg(x, y - 2, 38, 18);

    if (tmode & 0x80) { if (blink_phase() != 1) return; }
    tmode &= 0x7F;

    if (!(tmode == 100 || tmode == 0 || tmode == 8))
        icon_draw_or_erase(x, y, 1, g_tonemode_icons[dim != 0xFFFF][tmode]);

    dx = 0x29; dy = 0;
    y -= 2;
    type = band_row_type(); op = FRAME_OP; sub = FRAME_SUB; kind = rec[0];

    /* Some screens put the value on a second line 19 px down, 10 px left;
     * DCS (3, 9) then shifts 10 px back right.  Value at (x+dx, y+dy).       */
    if (op == 0xF1) {
        int second_line = 0;
        if (sub == 0) {
            if (!(kind == 0 || kind == 2) &&
                ((DUAL_FLAG == 0 && type == 1) || (DUAL_FLAG != 0 && type == 2)))
                second_line = 1;
        } else if (sub == 0x14) {
            if (!(kind == 0 || kind == 2)) second_line = 1;
        } else if (sub == 3 || sub == 6 || sub == 0x0F) {
            return;
        } else if (sub == 0x12) {
            x = 0x110; y = 0x28; dx = 0; dy = 0;
            lcd_restore_bg(x, y, 320 - x, 20);
            if (tmode == 3 || tmode == 9) x += 10;
        }
        if (second_line) {
            x -= 10; dx = 0; dy = 0x13;
            lcd_restore_bg(x, y + dy, 320 - x, 20);
            if (tmode == 3 || tmode == 9) x += 10;
        }
    }

    if (tmode == 1 || tmode == 2 || tmode == 4 || tmode == 10) {      /* CTCSS */
        u8 t = rec[0x46];
        if (t > 49) return;
        if (t <= 11) { n = 4; dx += 11; } else n = 5;
        for (i = 0; i < n; i++) {
            g = (u8)ctcss_text_FFC3D8C2[t][i];
            icon_draw_or_erase(x + dx, y + dy, 1, g_tone_glyphs[g]);
            if ((n == 4 && i == 2) || (n == 5 && i == 3)) dx += 5; else dx += 11;
        }
    } else if (tmode == 3 || tmode == 9 || tmode == 11) {             /* DCS */
        u8 c = rec[0x47];
        if (c > 103) return;
        for (i = 0; i < 3; i++) {
            g = (u8)dcs_text_FFC3D9BC[c][i];
            icon_draw_or_erase(x + dx, y + dy, 1, g_tone_glyphs[g]);
            dx += 13;
        }
    }
}
/* note: the CTCSS loop index test is written as in the binary: the narrow
 * advance (5) is applied *after* glyph index 2 (4-glyph) or 3 (5-glyph), i.e.
 * after the '.' glyph.                                                       */

/* ==========================================================================
 * FFEF5E38-FFEF6023 (491)  bandrow_draw_mode_icon   [IDA sub_FFEF5E38]
 * Callers (20) incl. FFEEF77E, FFF12272 and the FFEE/FFF4 row redrawers.
 * Communication-mode icon g_mode_icons[dim][mode] at the mode slot, plus a
 * 28x4 under-bar for the folded variants (7..10 -> FFED39DC / dim FFED39EC,
 * 11..13 -> FFECEFDC / dim FFED39CC).  Raw 0x0E..0x14 blink the whole icon,
 * raw 0x15..0x1B blink only the under-bar.  Always also redraws DG-ID.
 * On F1/0x14 the icon is suppressed unless frame[0x8E] bit2.        Confirmed
 * ========================================================================== */
void bandrow_draw_mode_icon(void)
{
    u8 vis = 0, variant, dimstyle;
    u8 *rec = band_rec_ptr();
    u8 m = rec[0x3F];
    u16 x, y, dim;

    pos_mode(&x, &y, &dim);
    if (OFFSCREEN(x, y)) return;
    lcd_restore_bg(x, y, 320 - x, 20);
    if (m > 0x1B) return;

    if (m <= 0x0D)      { vis = 1;             variant = 0; }
    else if (m <= 0x14) { vis = blink_phase(); m -= 7;  variant = 1; }
    else                { vis = blink_phase(); m -= 14; variant = 2; }

    bandrow_draw_dgid();

    if (FRAME_OP == 0xF1 && FRAME_SUB == 0x14 && !(g_frame[0x8E] & 0x04)) return;

    dimstyle = (dim == 0xFFFF) ? 0 : 1;
    if (dimstyle == 0) {
        if (m >= 7 && m <= 10)       icon_draw_or_erase(x, y, vis, &icon_FFED39DC);
        else if (m >= 11 && m <= 13) icon_draw_or_erase(x, y, vis, &icon_FFECEFDC);
        if (variant == 2) vis = 1;
        icon_draw_or_erase(x, y, vis, g_mode_icons[0][m]);
    } else {
        if (vis == 1) {
            if (m >= 7 && m <= 10)       icon_draw_or_erase(x, y, vis, &icon_FFED39EC);
            else if (m >= 11 && m <= 13) icon_draw_or_erase(x, y, vis, &icon_FFED39CC);
        }
        if (variant == 2) vis = 1;
        if (vis == 1) icon_draw_or_erase(x, y, vis, g_mode_icons[1][m]);
    }
}

/* ==========================================================================
 * FFEF6023-FFEF6096 (115)  bandrow_draw_vol_sql   [IDA sub_FFEF6023]
 * Callers (13) incl. FFEEBE51, FFF12272.
 * Label in a 36x14 cell: rec[1]==0 -> 33x14 white FFED3D9C, else 36x14
 * yellow-tinted FFECEF7C; then bandrow_draw_level_bar().  Pairs with the bar's
 * 0..31 (rec[1]==0) / 0..15 range -> VOL / SQL level display.     Inferred
 * ========================================================================== */
void bandrow_draw_vol_sql(void)
{
    u8 *rec = band_rec_ptr();
    u16 x, y;

    pos_volsql(&x, &y);
    if (OFFSCREEN(x, y)) return;
    lcd_restore_bg(x, y, 36, 14);
    icon_draw_or_erase(x, y, 1, rec[1] == 0 ? &icon_FFED3D9C : &icon_FFECEF7C);
    bandrow_draw_level_bar();
}

/* ==========================================================================
 * FFEF6096-FFEF631E (648)  bandrow_draw_main   [IDA sub_FFEF6096]
 * Callers (20) incl. FFEEBAAC, FFEEF77E, FFF12272 and the FFEE/FFF4 row
 * redrawers.  Draws the band row's main field according to the record's
 * display kind rec[0]:
 *   F1/0x15 screen  : frequency, and (kind != 0,2) the 16-char frame text at
 *                     frame+0x3F (dbcs mask frame[0x3D..0x3E]) at (41,23)
 *   kind 1          : frequency + 16-char tag rec+0x1F (mask rec[0x1D..0x1E])
 *   kind 2          : large RGB565 text rec+4 (12 chars, font20) only
 *   kind 3          : 16-char text rec+4 (mask rec[2..3]) only
 *   kind 4          : tag rec+0x1F + large text rec+4 (9 chars) below it
 *   kind 0 / other  : frequency only
 * Text rows are at y=0x17 (upper row) or 0x57 (lower row).  Kinds 2-4 set
 * g_redraw_freq_b so the digits are fully redrawn when the frequency comes
 * back.  Kind names (VFO / memory+tag / name-only) are Inferred.  Confirmed
 * ========================================================================== */
void bandrow_draw_main(void)
{
    u8 *rec  = band_rec_ptr();
    u8 kind  = rec[0];
    u8 type  = band_row_type();
    u8 dual  = DUAL_FLAG;
    u8 sub   = FRAME_SUB, op = FRAME_OP;
    u16 x = 0, y = 0, x2, y2, tint;

    if (op == 0xF1 && sub == 0x15) {
        freq_draw_digits(rec);
        if (!(kind == 0 || kind == 2)) {
            x = 0x29; y = 0x17;
            lcd_restore_bg(x, y, 0xE0, 0x1C);
            text_draw_mixed(x, y, (u16)(g_frame[0x3D] << 8 | g_frame[0x3E]), (const u8 *)&g_frame[0x3F]);
        }
        bandrow_draw_rec3e_thunk();
        return;
    }

    switch (kind) {
    case 1:
        freq_draw_digits(rec);
        if (dual == 0) {
            if (type == 1)      { x = 0x29; y = 0x17; }
            else if (type == 3) { if (sub == 0x14 || sub == 0x12) { x = 0x29; y = 0x17; }
                                  /* else: falls to the draw with x,y unset (as compiled) */ }
            else return;
        } else {
            if (type == 2)      { x = 0x29; y = 0x57; }
            else if (type == 3) { if (sub == 0x14 || sub == 0x12) { x = 0x29; y = 0x17; } }
            else return;
        }
        lcd_restore_bg(x, y, 0xE0, 0x1C);
        text_draw_mixed(x, y, (u16)(rec[0x1D] << 8 | rec[0x1E]), &rec[0x1F]);
        bandrow_draw_rec3e_thunk();
        return;

    case 2:
        pos_bigname(&x, &y, &tint);
        lcd_restore_bg(x, y, 0x106, 0x1E);
        rgbtext_draw_20(x, y, 2, &rec[4], 12, tint);
        g_redraw_freq_b = 1;
        return;

    case 3:
        if (dual == 0) {
            if (type == 1 || type == 3) { x = 0x29; y = 0x17; } else return;
        } else {
            if (type == 1) return;
            x = 0x29; y = (type == 3) ? 0x17 : 0x57;
        }
        lcd_restore_bg(x, y, 0xE0, 0x1C);
        text_draw_mixed(x, y, (u16)(rec[2] << 8 | rec[3]), &rec[4]);
        bandrow_draw_rec3e_thunk();
        g_redraw_freq_b = 1;
        return;

    case 4:
        if (dual == 0) { if (type != 1) return; x = 0x29; y = 0x17; x2 = 0x2F; y2 = 0x43; }
        else           { if (type != 2) return; x = 0x29; y = 0x57; x2 = 0x2F; y2 = 0x83; }
        lcd_restore_bg(x, y, 0xE0, 0x1C);
        text_draw_mixed(x, y, (u16)(rec[0x1D] << 8 | rec[0x1E]), &rec[0x1F]);
        lcd_restore_bg(x2, y2, 0xC4, 0x1E);
        rgbtext_draw_20(x2, y2, 2, &rec[4], 9, 0xFFFF);
        g_redraw_freq_b = 1;
        return;

    default:                                         /* kind 0 and >= 5 */
        freq_draw_digits(rec);
        bandrow_draw_rec3e_thunk();
        return;
    }
}

/* ==========================================================================
 * FFEF631E-FFEF637D (95)  bandrow_draw_level_bar   [IDA sub_FFEF631E]
 * Callers: FFEEBEB2, bandrow_draw_vol_sql.
 * rec[1]==0 -> level_bar_draw(0, x, y, rec[0x40])  (0..31, orange)
 * else      -> level_bar_draw(1, x, y, rec[0x41])  (0..15, yellow)  Confirmed
 * ========================================================================== */
void bandrow_draw_level_bar(void)
{
    u8 *rec = band_rec_ptr();
    u16 x, y;

    pos_levelbar(&x, &y);
    if (OFFSCREEN(x, y)) return;
    if (rec[1] == 0) level_bar_draw(0, x, y, rec[0x40]);
    else             level_bar_draw(1, x, y, rec[0x41]);
}

/* ==========================================================================
 * FFEF637D-FFEF643C (191)  bandrow_draw_smeter   [IDA sub_FFEF637D]
 * Callers (13) incl. FFEEBF13, FFF12272.
 * Clears a 184x18 area, draws the 18x18 meter caption (FFECEF3C on the upper
 * row / single screen, FFECEF4C on the lower row), the 150x6 scale FFECF17C
 * 28 px right of it, then the segments (smeter_draw_segments).    Inferred
 * ========================================================================== */
void bandrow_draw_smeter(void)
{
    u8 *rec = band_rec_ptr(); (void)rec;
    u8 type = band_row_type();
    u8 alt;
    u16 x, y;

    pos_smeter_frame(&x, &y);
    if (OFFSCREEN(x, y)) return;
    lcd_restore_bg(x, y, 0xB8, 0x12);

    if (type == 1)      alt = 0;
    else if (type == 2) alt = 1;
    else                alt = DUAL_FLAG ? 1 : 0;

    icon_draw_or_erase(x, y, 1, alt ? &icon_FFECEF4C : &icon_FFECEF3C);
    x += 0x1C;
    icon_draw_or_erase(x, y, 1, &icon_FFECF17C);
    y += 8;                                            /* dead store in the binary */
    smeter_draw_segments();
}

/* ==========================================================================
 * FFEF643C-FFEF64D2 (150)  bandrow_draw_icon48_lo   [IDA sub_FFEF643C]
 * Callers: FFEE683A, FFEE86D6, FFEEB2A1, FFEEBD3E, FFEEBFD3, FFF4026F,
 * FFF44EE1, FFF453BB.
 * rec[0x48] bits 0-1: 1 -> icon g_rec48_icons[dim][0], 2 -> [dim][1], else
 * erase.  12x18 cell.  (Same byte's bits 2-4 drive the APRS tag below.)
 *                                                                  Confirmed
 * ========================================================================== */
void bandrow_draw_icon48_lo(void)
{
    u8 *rec = band_rec_ptr();
    u8 vis, idx = 0, dimstyle;
    u16 x, y, dim;

    pos_icon48(&x, &y, &dim);
    if (OFFSCREEN(x, y)) return;
    lcd_restore_bg(x, y, 12, 18);
    dimstyle = (dim == 0xFFFF) ? 0 : 1;
    switch (rec[0x48] & 3) {
    case 2:  vis = 1; idx = 1; break;
    case 1:  vis = 1; idx = 0; break;
    default: vis = 0; break;
    }
    icon_draw_or_erase(x, y, vis, g_rec48_icons[dimstyle][idx]);
}

/* ==========================================================================
 * FFEF64D2-FFEF6580 (174)  bandrow_draw_aprs_baud   [IDA sub_FFEF64D2]
 * Callers: FFEE683A, FFEE86D6, FFEEB2A1, FFEEBD3E, FFEEC030, FFF4026F,
 * FFF44EE1, FFF453BB.
 * rec[0x48] bits 2-3 tri-state; bit4 selects "A96" (9600 bps) over "A12"
 * (1200 bps); drawn with the 12-px RGB565 font in the tint from the position
 * helper.  38x18 cell.   Inferred: body traced fully; APRS meaning rests on
 * the two literal strings.
 * ========================================================================== */
void bandrow_draw_aprs_baud(void)
{
    u8 *rec = band_rec_ptr();
    u8 f = rec[0x48];
    u16 x, y, tint;

    pos_aprs(&x, &y, &tint);
    if (OFFSCREEN(x, y)) return;
    lcd_restore_bg(x, y, 0x26, 0x12);
    if (tri_state((f & 0x0C) >> 2) != 1) return;
    rgbtext_draw_12(x, y, 1, (const u8 *)((f & 0x10) ? aA96_0 : aA12_0), 3, tint);
}

/* ==========================================================================
 * FFEF6580-FFEF65E8 (104)  statusbar_icon_2dfc   [IDA sub_FFEF6580]
 * Caller: FFEFBE81 (status-bar painter).  args (x, y, show, state).
 * If show==1 and state&0x7F != 0: visible (bit7 = blink).  Draws the 15x22
 * icon FFED2DFC or restores its rectangle.                          Confirmed
 * ========================================================================== */
void statusbar_icon_2dfc(u16 x, u16 y, u8 show, u8 state)
{
    const BmpDesc *d = &icon_FFED2DFC;
    u8 vis = 0;

    if (show == 1 && (state & 0x7F) != 0)
        vis = (state >> 7) ? blink_phase() : 1;
    if (vis == 1) icon_draw_or_erase(x, y, 1, d);
    else          lcd_restore_bg(x, y, d->w, d->h);
}

/* ==========================================================================
 * FFEF65E8-FFEF66C0 (216)  statusbar_icon_sel8   [IDA sub_FFEF65E8]
 * Caller: FFEFBE81.  args (x, y, show, state).  state&0x7F picks one of eight
 * 22x22 icons: 1 2DCC, 2 2E5C, 3 2E3C, 4 2E4C, 5 2E2C, 6 340C, 7 33FC,
 * 12 2E0C (all FFEDxxxx); any other value returns without touching the
 * screen.  bit7 = blink.                                            Confirmed
 * ========================================================================== */
void statusbar_icon_sel8(u16 x, u16 y, u8 show, u8 state)
{
    const BmpDesc *d = &icon_FFED2DCC;
    u8 vis = 0;

    if (show == 1) vis = (state >> 7) ? blink_phase() : 1;
    switch (state & 0x7F) {
    case 1:  d = &icon_FFED2DCC; break;
    case 2:  d = &icon_FFED2E5C; break;
    case 3:  d = &icon_FFED2E3C; break;
    case 4:  d = &icon_FFED2E4C; break;
    case 5:  d = &icon_FFED2E2C; break;
    case 6:  d = &icon_FFED340C; break;
    case 7:  d = &icon_FFED33FC; break;
    case 12: d = &icon_FFED2E0C; break;
    default: return;
    }
    if (vis == 1) icon_draw_or_erase(x, y, 1, d);
    else          lcd_restore_bg(x, y, d->w, d->h);
}

/* ==========================================================================
 * FFEF66C0-FFEF6764 (164)  statusbar_icon_sel4   [IDA sub_FFEF66C0]
 * Caller: FFEFBE81.  args (x, y, show, state).  When visible, state&0x7F
 * picks 1 2E1C, 2 342C, 3 2DDC, 4 341C (22x22); other values hide it.  The
 * erase uses the default descriptor's (2E1C) size.                  Confirmed
 * ========================================================================== */
void statusbar_icon_sel4(u16 x, u16 y, u8 show, u8 state)
{
    const BmpDesc *d = &icon_FFED2E1C;
    u8 vis = 0;

    if (show == 1) {
        vis = (state >> 7) ? blink_phase() : 1;
        if (vis == 1) {
            switch (state & 0x7F) {
            case 1:  d = &icon_FFED2E1C; break;
            case 2:  d = &icon_FFED342C; break;
            case 3:  d = &icon_FFED2DDC; break;
            case 4:  d = &icon_FFED341C; break;
            default: vis = 0; break;
            }
        }
    }
    if (vis == 1) icon_draw_or_erase(x, y, 1, d);
    else          lcd_restore_bg(x, y, d->w, d->h);
}

/* ==========================================================================
 * FFEF6764-FFEF682C (200)  header_draw_title   [IDA sub_FFEF6764]
 * Callers: FFEE6AE4, FFEE7047, FFEEA894, FFEEAD7B.  args (x, y, show, str).
 * Only on F1 screens.  F1/0x0F: clear the 24-px band and draw 22 chars of str
 * in the 12-px RGB565 font.  Other F1 screens: frame[0x6C]==2 / 4 paints a
 * 238x33 bar at (0,23) in 0x03FF / 0x0580, then draws 10 chars of str with
 * the 1-bpp font at the fixed point (4,26) (x,y,show are not used on this
 * path).                                                            Confirmed
 * ========================================================================== */
void header_draw_title(u16 x, u16 y, u8 show, const u8 *str)
{
    u8 v;

    if (FRAME_OP != 0xF1) return;
    if (FRAME_SUB == 0x0F) {
        lcd_restore_bg(x, y, 320 - x, 0x18);
        if (show == 1) rgbtext_draw_12(x, y, 1, str, 0x16, 0xFFFF);
        return;
    }
    v = g_frame[0x6C];
    x = 0; y = 0x17;
    if (v == 2)      lcd_fill_rect(x, y, 0xEE, 0x21, 0x03FF);
    else if (v == 4) lcd_fill_rect(x, y, 0xEE, 0x21, 0x0580);
    glyph_draw_sbcs(4, 0x1A, 0x0D, 0, 10, str, 1);
}

/* ==========================================================================
 * FFEF682C-FFEF68A1 (117)  header_draw_text7   [IDA sub_FFEF682C]
 * Callers: FFEE6AE4, FFEE7047, FFEEA8D6, FFEEAD7B.  args (x, y, str).
 * F1/0x0F: clear the band, 7 chars in the 12-px font; other F1 screens: 7
 * chars in the small numeric font (no clear).                       Confirmed
 * ========================================================================== */
void header_draw_text7(u16 x, u16 y, const u8 *str)
{
    if (FRAME_OP != 0xF1) return;
    if (FRAME_SUB == 0x0F) {
        lcd_restore_bg(x, y, 320 - x, 0x18);
        rgbtext_draw_12(x, y, 1, str, 7, 0xFFFF);
    } else {
        rgbtext_draw_num8(x, y, 1, str, 7, 0xFFFF);
    }
}

/* FFEF68A1-FFEF68D5 (52)  header_draw_text17  [IDA sub_FFEF68A1]
 * Callers: FFEEA916, FFEEA957, FFEEAD7B.  Clear to the right edge (24 px
 * high) and draw 17 chars of str in the 12-px font.               Confirmed */
void header_draw_text17(u16 x, u16 y, const u8 *str)
{
    lcd_restore_bg(x, y, 320 - x, 0x18);
    rgbtext_draw_12(x, y, 1, str, 0x11, 0xFFFF);
}

/* ==========================================================================
 * FFEF68D5-FFEF690B (54)  icon_draw_or_erase   [IDA sub_FFEF68D5]
 * 330 call sites (whole UI).  visible==1 -> RGB565 blit of d at (x,y);
 * otherwise restore the background over d's w x h.  NULL d -> no-op.
 * (Doc 16/31 "icon/bitmap blit wrapper", now with the erase half.) Confirmed
 * ========================================================================== */
void icon_draw_or_erase(u16 x, u16 y, u8 visible, const BmpDesc *d)
{
    if (d == 0) return;
    if (visible == 1) lcd_blit(x, y, d);
    else              lcd_restore_bg(x, y, d->w, d->h);
}

/* ==========================================================================
 * FFEF690B-FFEF693B (48)  shape_draw_or_erase   [IDA sub_FFEF690B]
 * 60 call sites, all in freq_draw_digits.  visible==1 -> span-masked blit
 * (sub_FFEF0949), else span-masked background restore (sub_FFEF0BD4).  The
 * spans come from the GLYPH_METRIC tables keyed by glyph height (16/20/28/38/
 * 52), so these are the rounded frequency-digit cells.  Doc 31 called this a
 * "text/number draw wrapper"; it draws pre-rendered digit bitmaps.  Confirmed
 * ========================================================================== */
void shape_draw_or_erase(u16 x, u16 y, u8 visible, const BmpDesc *d)
{
    if (d == 0) return;
    if (visible == 1) lcd_blit_shaped(x, y, d);
    else              lcd_erase_shaped(x, y, d);
}

/* ==========================================================================
 * FFEF693B-FFEF6A0D (210)  battery_draw   [IDA sub_FFEF693B]
 * Caller: sub_FFEF4FB7, which passes level = frame[0x12].  args (x, y, level).
 * Erases then (if visible) draws the 26x12 battery outline FFECE72C.  Visible
 * for level 1..8 and 10, blinking for 9.  Draws (8-level) two-pixel segments
 * (two 1x8 strokes, FFED1F2C) for level < 8, starting at the ABSOLUTE x
 * 27-3*(8-level) (the x argument is not added - as compiled); level 10 adds
 * the 16x8 charge mark FFED2DEC at (x+7, y+2).   Inferred: body traced
 * fully; "battery" rests on the outline + segment + charge-mark structure.
 * ========================================================================== */
void battery_draw(u16 x, u16 y, u8 level)
{
    u8 vis = 0, n, i;
    u16 bx, by;

    icon_draw_or_erase(x, y, 0, &icon_FFECE72C);
    if (level == 10)                 vis = 1;
    else if (level == 9)             vis = blink_phase();
    else if (level >= 1 && level <= 8) vis = 1;
    if (vis != 1) return;

    icon_draw_or_erase(x, y, 1, &icon_FFECE72C);
    n  = (level >= 8) ? 0 : (u8)(8 - level);
    by = y + 2;
    bx = (u16)(0x1B - n * 3);
    for (i = 0; i < n; i++) {
        icon_draw_or_erase(bx, by, 1, &icon_FFED1F2C); bx += 1;
        icon_draw_or_erase(bx, by, 1, &icon_FFED1F2C); bx += 2;
    }
    if (level == 10) icon_draw_or_erase(x + 7, y + 2, 1, &icon_FFED2DEC);
}

/* ==========================================================================
 * FFEF6A0D-FFEF6A78 (107)  frame_draw_tag3   [IDA sub_FFEF6A0D]
 * Callers: FFEE67C7, FFEE6889.  args (x, y).
 * frame[0x24] bits 2-3 tri-state; when shown, draws the 3 characters at
 * frame+0x25 with the 12-px font.  38x18 cell.                      Confirmed
 * ========================================================================== */
void frame_draw_tag3(u16 x, u16 y)
{
    u8 f = g_frame[0x24];
    u8 vis;

    lcd_restore_bg(x, y, 0x26, 0x12);
    switch ((f & 0x0C) >> 2) {
    case 0:  vis = 0; break;
    case 1:  vis = 1; break;
    case 2:  vis = blink_phase(); break;
    default: vis = 0; break;
    }
    if (vis == 1) rgbtext_draw_12(x, y, 1, (const u8 *)&g_frame[0x25], 3, 0xFFFF);
}

/* ==========================================================================
 * FFEF6A78-FFEF6AF8 (128)  dead_draw_label_composite   [IDA dead_FFEF6A78]
 * No xrefs (doc 48: true head of a lane-4 body, whole function unreferenced).
 * Six args (x, y, a, b, c, ptr), only x,y used: blits 38x18 FFECEE4C at (x,y),
 * then 12x18 FFECE7BC, FFECE7BC, FFECE81C at x' = 0+38+3, +13, +13 (absolute,
 * the running x starts at 0 not at x).                              Confirmed
 * ========================================================================== */
void dead_draw_label_composite(u16 x, u16 y, u8 a, u8 b, u8 c, const void *p)
{
    u16 cx = 0;
    (void)a; (void)b; (void)c; (void)p;
    lcd_blit(x, y, &icon_FFECEE4C);
    cx = cx + icon_FFECEE4C.w + 3;  lcd_blit(cx, y, &icon_FFECE7BC);
    cx = cx + icon_FFECE7BC.w + 1;  lcd_blit(cx, y, &icon_FFECE7BC);
    cx = cx + icon_FFECE7BC.w + 1;  lcd_blit(cx, y, &icon_FFECE81C);
}

/* ==========================================================================
 * FFEF6AF8-FFEF6C42 (330)  bandrow_draw_rec3e   [IDA sub_FFEF6AF8]
 * Caller: bandrow_draw_rec3e_thunk.
 * rec[0x3E]: 1..10 -> glyph g_rec3e_icons[dim][v-1] then the 38x16 suffix
 * FFED220C (dim FFED221C) 13 px right / 1 px down; 15 -> the fixed 3-glyph
 * group F43C,F59C,F59C (dim F44C,F5AC,F5AC) at 13-px pitch; anything else
 * leaves the area alone.  (A 1..10 numeric + unit tag; meaning Unknown.)
 *                                                                  Confirmed
 * ========================================================================== */
void bandrow_draw_rec3e(void)
{
    u8 *rec = band_rec_ptr();
    u8 v = rec[0x3E];
    u8 d;
    u16 x, y, dim;

    pos_rec3e(&x, &y, &dim);
    if (OFFSCREEN(x, y)) return;
    d = (dim == 0xFFFF) ? 0 : 1;

    if (v == 15) {
        y += 1;
        if (d == 0) {
            icon_draw_or_erase(x, y, 1, &icon_FFECF43C); x += 13;
            icon_draw_or_erase(x, y, 1, &icon_FFECF59C); x += 13;
            icon_draw_or_erase(x, y, 1, &icon_FFECF59C);
        } else {
            icon_draw_or_erase(x, y, 1, &icon_FFECF44C); x += 13;
            icon_draw_or_erase(x, y, 1, &icon_FFECF5AC); x += 13;
            icon_draw_or_erase(x, y, 1, &icon_FFECF5AC);
        }
        return;
    }
    if (v < 1 || v > 10) return;
    lcd_restore_bg(x, y, 320 - x, 0x12);
    icon_draw_or_erase(x, y, 1, g_rec3e_icons[d][v - 1]);
    x += 13; y += 1;
    icon_draw_or_erase(x, y, 1, d == 0 ? &icon_FFED220C : &icon_FFED221C);
}

/* ==========================================================================
 * FFEF6C42-FFEF9A49 (11783)  freq_draw_digits   [IDA sub_FFEF6C42]
 * Callers: sub_FFEE6899 (FFEE68BA), bandrow_draw_main (FFEF60E8, FFEF613C,
 * FFEF6314).  Arg r1 = band display record (from band_rec_ptr()).
 *
 * WHAT IT IS - the large FREQUENCY READOUT of a band row (Confirmed).
 *   rec[0x30..0x33] hold the frequency as 8 packed-BCD nibbles (high nibble
 *   first, nibble >= 10 treated as 0).  Digit positions 0..2 are the MHz part,
 *   3..5 the kHz part, 6..7 the two small trailing digits.  The routine:
 *     - blanks leading zeros,
 *     - hides the small trailing pair when both are 0,
 *     - shows the decimal point only while the MHz part is non-zero,
 *     - redraws ONLY digits that changed, using a per-row-type 10-byte cache
 *       (8 digits + [8] "trailing pair hidden" + [9] "dot shown"; cache value
 *       0xFE = blanked leading zero, 0xFF = unknown/force redraw),
 *     - rec[0x2F] = blink mode: 0 steady, 1 whole readout blinks, 2 digits are
 *       repainted solid every call while the point blinks.
 *   Glyphs are 10-entry pointer tables (g_freq_digits[n], 0x28 bytes apart);
 *   the six layouts returned by pos_freq() pick a big/small digit pair, a
 *   decimal-point bitmap, a FIELD_COORD table (x absolute, y relative to the
 *   row origin) and the point position.
 *
 * CORRECTION TO doc 31 (sec. "sub_FFEF6C42"): the "slot array 0x68F20, 10 x
 * 0x28" is ten digit-glyph tables of 10 pointers; the "three 10-byte per-slot
 * caches" are per-row digit caches; the 8x28..11x52 "increasing bars" are the
 * decimal points of the six digit sizes; FFEF690B draws the digit bitmaps
 * (not text); "FFEF95BD sibling draw block" is not a routine: FFEF95BD is
 * the middle of `cmp #6,r14` (61 6E) at FFEF95BC in layout 5's change-list
 * loop (the doc-48 pushm misread), and nothing branches to it.  The screen is the operating screen's
 * frequency display, not a member/station grid.
 *
 * The six layout blocks (dispatch at FFEF738A) are byte-for-byte the same code
 * with different constants (verified by normalised diff); they are written
 * once here, driven by FREQ_LAYOUT[].  Block entries: 0 FFEF73AB, 3 FFEF79F2,
 * 1 FFEF8039, 4 FFEF86BE, 2 FFEF8D23, 5 FFEF93DC; common exit FFEF9A47.
 * ========================================================================== */

typedef struct {
    const BmpDesc    *dot;          /* decimal point bitmap                       */
    const FieldCoord *coord;        /* 10 x {idx, x, y}                           */
    u32 big_tab, small_tab;         /* g_freq_digits[] table addresses            */
    u16 dot_x;                      /* point x                                    */
    u16 dot_y_t13, dot_y_t2, dot_y_t4;   /* point y per row type (0 = none)       */
} FreqLayout;

static const FreqLayout FREQ_LAYOUT[6] = {
 /*0*/ { &icon_FFED3A7C /*11x52*/, freq_coord_FFEC61A8, 0x68F20, 0x68F48, 131,  45, 108,   0 },
 /*1*/ { &icon_FFED3A5C /*11x38*/, freq_coord_FFEC61E4, 0x68FE8, 0x69010, 140,  23, 123,   0 },
 /*2*/ { &icon_FFED3A2C /* 8x28*/, freq_coord_FFEC6220, 0x68F48, 0x69038, 114,  77, 132,  22 },
 /*3*/ { &icon_FFED3A6C /*11x38*/, freq_coord_FFEC61E4, 0x68F98, 0x68FC0, 140,  23, 123,   0 },
 /*4*/ { &icon_FFED3A3C /* 8x28*/, freq_coord_FFEC6220, 0x68F70, 0x69060, 114,  77, 132,  22 },
 /*5*/ { &icon_FFED3A4C /*11x30*/, freq_coord_FFEC625C, 0x69088, 0x69038, 140,  50,  50,   0 },
};
/* Per-layout point-y exceptions (prologue of each block):
 *   layout 1, type 1/3: y = 59 if frame[0x20]==1 or screen F1/0x15
 *   layout 2, type 1/3: y = 23 on screens F1/0x0F and F1/0x06
 *   layout 5, type 1/3: y = 44 on screen F7/0x01
 * Layouts 0,1,3,5 have no type-4 case (point coordinates stay unset).         */

#define DIGITS(tab)  ((const BmpDesc * const *)(uintptr_t)(tab))

static volatile u8 *freq_cache(u8 type)
{
    switch (type) {
    case 1: case 3: return g_freq_cache_t13;
    case 2:         return g_freq_cache_t2;
    case 4:         return g_freq_cache_t4;
    default:        return 0;      /* type 0/other: every cache access is skipped */
    }
}

void freq_draw_digits(u8 *rec)
{
    u8  digit[8];               /* var_E..var_7 (sp+0x5A..0x61)                 */
    u8  newblank[8], nnew = 0;  /* var_52 list / var_5D: zeros to erase now      */
    u8  lead[8], nlead = 0;     /* var_5C list / var_60: all leading zeros       */
    u8  lead_mhz = 0;           /* var_5F: leading zeros among positions 0..2    */
    u8  chg[8][3], nchg = 0;    /* var_2F list / var_30: {pos,new,old}           */
    u8  mode_changed = 0;       /* var_35 */
    u8  ch_t4 = 0, ch_t13 = 0, ch_t2 = 0;   /* var_36 / var_37 / var_38          */
    u8  small_hide_changed = 0; /* var_34 */
    u8  dot_action = 0;         /* var_48: 1 draw point, 2 erase point            */
    u8  phase = 0;              /* var_33 */
    u8  blinkmode, type, layout = 0, i, k;
    u16 x0, y0, px = 0, py = 0;
    volatile u8 *cache;
    const FreqLayout *L;
    const BmpDesc * const *big, * const *small;

    /* ---- stage 1: blink-mode change per row type (FFEF6C8B) ------------- */
    type = band_row_type();
    switch (type) {
    case 4: if (g_freq_blinkmode_t4 != rec[0x2F])  { g_freq_blinkmode_t4  = rec[0x2F]; mode_changed = 1; ch_t4  = 1; } break;
    case 1: case 3:
            if (g_freq_blinkmode_t13 != rec[0x2F]) { g_freq_blinkmode_t13 = rec[0x2F]; mode_changed = 1; ch_t13 = 1; } break;
    case 2: if (g_freq_blinkmode_t2 != rec[0x2F])  { g_freq_blinkmode_t2  = rec[0x2F]; mode_changed = 1; ch_t2  = 1; } break;
    }

    /* ---- stage 2: forced full redraw (FFEF6D0F) ------------------------- */
    cache = freq_cache(type);
    if (g_ui_substate == 2 || g_redraw_freq_a == 1 || g_redraw_freq_b == 1 || mode_changed == 1)
        if (cache) for (i = 0; i < 10; i++) cache[i] = 0xFF;
    g_redraw_freq_a = 0;
    g_redraw_freq_b = 0;

    blinkmode = rec[0x2F];
    if (blinkmode == 1 || blinkmode == 2) phase = blink_phase();

    pos_freq(&x0, &y0, &layout);
    if (OFFSCREEN(x0, y0)) return;

    /* ---- unpack 8 BCD digits (FFEF6E39) --------------------------------- */
    for (i = 0; i < 8; i++) {
        u8 b = rec[0x30 + (i >> 1)];
        digit[i] = (i & 1) ? (b & 0x0F) : (u8)(b >> 4);
        if (digit[i] >= 10) digit[i] = 0;
    }

    /* ---- leading zeros (FFEF6E85) --------------------------------------- */
    for (i = 0; i < 8 && digit[i] == 0; i++) {
        if (cache && cache[i] != 0xFE) newblank[nnew++] = i;
        if (i <= 2) lead_mhz++;
        lead[nlead++] = i;
    }

    /* ---- decimal point state, cache[9] (FFEF6F40) ----------------------- */
    if (cache) {
        if (digit[0] == 0 && digit[1] == 0 && digit[2] == 0) {
            if (cache[9] != 0) { dot_action = 2; cache[9] = 0; }
        } else {
            if (cache[9] != 1) { dot_action = 1; cache[9] = 1; }
        }
    }

    /* ---- trailing small pair state, cache[8] (FFEF7054) ----------------- */
    if (cache) {
        if (digit[6] == 0 && digit[7] == 0) {
            if (cache[8] != 1) { small_hide_changed = 1; cache[8] = 1; }
        } else {
            cache[8] = 0;
        }
    }

    /* ---- change list (FFEF7131-FFEF7387) -------------------------------- */
    for (i = 0; i < 8 && cache; i++) {
        int is_lead = 0;
        for (k = 0; k < nlead; k++) if (lead[k] == i) is_lead = 1;
        if (is_lead)                         { cache[i] = 0xFE; continue; }
        if (digit[6] == 0 && digit[7] == 0 && (i == 6 || i == 7))
                                             { cache[6] = 0xFF; cache[7] = 0xFF; continue; }
        if (digit[i] != cache[i]) {
            chg[nchg][0] = i; chg[nchg][1] = digit[i]; chg[nchg][2] = cache[i];
            nchg++;
            cache[i] = digit[i];
        }
    }

    /* ---- stage 4: draw with the layout's tables (FFEF738A) -------------- */
    if (layout > 5) return;
    L = &FREQ_LAYOUT[layout];
    big   = DIGITS(L->big_tab);
    small = DIGITS(L->small_tab);
#define GLYPH(pos, d)  (((pos) == 6 || (pos) == 7) ? small[d] : big[d])
#define CX(pos)        (L->coord[pos].x)
#define CY(pos)        ((u16)(L->coord[pos].y + y0))

    px = L->dot_x;
    if ((type == 1 || type == 3) && L->dot_y_t13) {
        py = L->dot_y_t13;
        /* (per-layout exceptions listed above FREQ_LAYOUT) */
        if (ch_t13 == 1) lcd_erase_glyph(px, py, L->dot);
    } else if (type == 2) {
        py = L->dot_y_t2;
        if (ch_t2 == 1) lcd_erase_glyph(px, py, L->dot);
    } else if (type == 4 && L->dot_y_t4) {
        py = L->dot_y_t4;
        if (ch_t4 == 1) lcd_erase_glyph(px, py, L->dot);
    }
    if (dot_action == 1)      icon_draw_or_erase(px, py, 1, L->dot);
    else if (dot_action == 2) lcd_erase_glyph(px, py, L->dot);

    for (i = 0; i < nnew; i++)                     /* newly blank leading zeros */
        shape_draw_or_erase(CX(newblank[i]), CY(newblank[i]), 0, GLYPH(newblank[i], 0));

    if (small_hide_changed == 1)                   /* hide trailing "00"         */
        for (i = 6; i < 8; i++) shape_draw_or_erase(CX(i), CY(i), 0, small[0]);

    for (i = 0; i < nchg; i++) {                   /* changed digits only        */
        u8 pos = chg[i][0], nv = chg[i][1], ov = chg[i][2];
        if (nv < 10)       shape_draw_or_erase(CX(pos), CY(pos), 1, GLYPH(pos, nv));
        else if (ov <= 9)  shape_draw_or_erase(CX(pos), CY(pos), 0, GLYPH(pos, ov));
    }

    if (blinkmode == 1) {                          /* ---- blink whole readout -- */
        if (nlead <= 2) {
            if (phase == 1) icon_draw_or_erase(px, py, 1, L->dot);
            else            lcd_erase_glyph(px, py, L->dot);
        } else if (nlead == 8) {
            lcd_erase_glyph(px, py, L->dot);
        }
        for (i = 0; i < 8; i++) {
            int is_lead = 0;
            if ((i == 6 || i == 7) && digit[6] == 0 && digit[7] == 0 && nlead != 8) continue;
            for (k = 0; k < nlead; k++) if (lead[k] == i) { is_lead = 1; break; }
            if (is_lead) shape_draw_or_erase(CX(k), CY(k), 0, GLYPH(i, 0));
            else if (digit[i] >= 10) shape_draw_or_erase(CX(i), CY(i), 0, GLYPH(i, 0));
            else shape_draw_or_erase(CX(i), CY(i), phase, GLYPH(i, digit[i]));
        }
    } else if (blinkmode == 2) {                   /* ---- solid repaint, point blinks */
        if (nlead < 3 || lead_mhz == 3) {
            if (phase == 1) icon_draw_or_erase(px, py, 1, L->dot);
            else            lcd_erase_glyph(px, py, L->dot);
        } else if (nlead == 8) {
            lcd_erase_glyph(px, py, L->dot);
        }
        for (i = 0; i < 8; i++) {
            int is_lead = 0;
            if ((i == 6 || i == 7) && digit[6] == 0 && digit[7] == 0 && nlead != 8) continue;
            for (k = 0; k < nlead; k++) if (lead[k] == i) { is_lead = 1; break; }
            if (is_lead) shape_draw_or_erase(CX(k), CY(k), 0, GLYPH(i, 0));
            else if (digit[i] >= 10) shape_draw_or_erase(CX(i), CY(i), 0, GLYPH(i, 0));
            else shape_draw_or_erase(CX(i), CY(i), 1, GLYPH(i, digit[i]));
        }
    }
#undef GLYPH
#undef CX
#undef CY
}
/* Notes on fidelity:
 *  - The binary repeats every cache access as a 4-way switch on the row type
 *    (1/3 -> 0x8F83, 2 -> 0x8F8D, 4 -> 0x8F79); freq_cache() is that switch.
 *  - Blink mode 2's point test is (nlead < 3 || lead_mhz == 3) as compiled
 *    (FFEF77FF); blink mode 1's is (nlead <= 2) (FFEF7615).
 *  - For leading zeros in the blink paths the binary indexes the coordinate
 *    table with the list index k; since leading zeros form a prefix, k == i.
 *  - TODO(waveC): the per-layout point-y exceptions are summarised in the
 *    comment above FREQ_LAYOUT rather than coded into the table.               */

/* ==========================================================================
 * FFEF9A49-FFEF9A8A (65)  vol_sql_label_draw   [IDA sub_FFEF9A49]
 * Caller: FFEE69A4.  args (x, y, kind).  Same label as bandrow_draw_vol_sql
 * but at an explicit point: kind 0 -> FFED3D9C, else FFECEF7C, 36x14 cell.
 *                                                                   Inferred
 * ========================================================================== */
void vol_sql_label_draw(u16 x, u16 y, u8 kind)
{
    lcd_restore_bg(x, y, 36, 14);
    icon_draw_or_erase(x, y, 1, kind == 0 ? &icon_FFED3D9C : &icon_FFECEF7C);
}

/* ==========================================================================
 * FFEF9A8A-FFEF9B13 (137)  level_bar_draw   [IDA sub_FFEF9A8A]
 * Callers: FFEE6274, FFEE69A4, bandrow_draw_level_bar.  args (kind, x, y, v).
 * 5-px high bar from x to 318: grey (0x7BEF) track, then a filled part
 * v/max of the track width; kind 0: max 31, colour 0xF980; else max 15,
 * colour 0xFEC0.  v is clamped to max.                              Confirmed
 * ========================================================================== */
void level_bar_draw(u8 kind, u16 x, u16 y, u8 v)
{
    u16 w = (u16)(0x13E - x), len, max, col;

    lcd_restore_bg(x, y, 320 - x, 5);
    lcd_fill_rect(x, y, w, 5, 0x7BEF);
    if (kind == 0) { max = 0x1F; col = 0xF980; }
    else           { max = 0x0F; col = 0xFEC0; }
    if (v > max) v = (u8)max;
    len = (v == max) ? w : (u16)(v * w / max);
    lcd_fill_rect(x, y, len, 5, col);
}

/* FFEF9B13-FFEF9B22 (15)  dead_stub_args5  [IDA dead_FFEF9B13]  no xrefs.
 * Spills (u16,u16,u16,u8,u8 stack) and returns; an emptied draw routine.
 *                                                                  Confirmed */
void dead_stub_args5(u16 a, u16 b, u16 c, u8 d, u8 e) { (void)a;(void)b;(void)c;(void)d;(void)e; }

/* ==========================================================================
 * FFEF9B22-FFEF9CA7 (389)  smeter_draw_segments   [IDA sub_FFEF9B22]
 * Callers: FFEE62C9, FFEE67C7, FFEEBF6D, bandrow_draw_smeter, FFF01F70.
 * 10-segment meter, 15-px pitch, 14x8 segments.  level = rec[0x43] (bit7 =
 * alternate colouring, e.g. TX/PO), peak = rec[0x44].  Special sources:
 * screen F1/0x03 on row type 4 uses frame[0x2D]/[0x2E]; screen F3/0x48 shows
 * a full meter (10) with peak frame[0x20].  Segments 1..7 use FFED3B9C (or
 * FFED3BAC when bit7), 8..10 always FFED3BAC.  A non-zero peak blinks: past
 * the level, the loop jumps to the peak segment and draws it only in the
 * visible phase.   Inferred: body traced fully; "S-meter" is the reading.
 * ========================================================================== */
void smeter_draw_segments(void)
{
    u8 *rec = band_rec_ptr();
    u8 level = rec[0x43], peak = rec[0x44];
    u8 type = band_row_type();
    u8 op = FRAME_OP, sub = FRAME_SUB;
    u8 vis = 1, alt, i;
    u16 x, y;

    pos_smeter(&x, &y);
    if (OFFSCREEN(x, y)) return;
    lcd_restore_bg(x - 7, y - 1, 0xA4, 10);

    if (op == 0xF1) {
        if (sub == 3 && type == 4) { level = g_frame[0x2D]; peak = g_frame[0x2E]; }
    } else if (op == 0xF3 && sub == 0x48) {
        level = 10; peak = g_frame[0x20];
    }
    alt = (level & 0x80) ? 1 : 0;
    level &= 0x7F;
    if (level >= 11) level = 10;
    if (peak >= 11)  peak = 0;
    if (peak != 0) vis = blink_phase();

    for (i = 1; i < 11; i++) {
        if (i > level) {
            if (vis == 1 && i <= peak) i = peak;
            else return;
        }
        if (vis == 0 && i == peak) continue;
        if (i <= 7) icon_draw_or_erase(x + i * 15 - 15, y, 1, alt ? &icon_FFED3BAC : &icon_FFED3B9C);
        else        icon_draw_or_erase(x + i * 15 - 15, y, 1, &icon_FFED3BAC);
    }
}

/* ==========================================================================
 * FFEF9CA7-FFEF9D01 (90)  dead_row_param   [IDA dead_FFEF9CA7]  no xrefs.
 * Returns 15, except: type 1 with dual flag -> 10; type 2 without -> 9.
 *                                                                  Confirmed
 * ========================================================================== */
u8 dead_row_param(void)
{
    u8 dual = DUAL_FLAG, r = 15;
    switch (band_row_type()) {
    case 1: r = (dual == 0) ? 15 : 10; break;
    case 2: r = (dual == 1) ? 15 : 9;  break;
    case 3: case 4: r = 15; break;
    }
    return r;
}

/* ==========================================================================
 * FFEF9D01-FFEF9D7D (124)  list_scroll_thumb_draw   [IDA sub_FFEF9D01]
 * Callers: FFF0F4F3, FFF41F5E.  args (y_top, y_bottom).
 * Item index = BE16 frame[0x14..0x15], item count = BE16 frame[0x16..0x17]
 * (index > count -> both 1; zero -> 1).  Draws a white 6-px thumb at x=311,
 * height (y_bottom-y_top)/count, at y_top + (index-1)*height.       Confirmed
 * ========================================================================== */
void list_scroll_thumb_draw(u16 y_top, u16 y_bot)
{
    u16 idx = (u16)(g_frame[0x14] << 8 | g_frame[0x15]);
    u16 cnt = (u16)(g_frame[0x16] << 8 | g_frame[0x17]);
    u16 span = y_bot - y_top, h;

    if (idx > cnt) { cnt = 1; idx = 1; }
    if (idx == 0) idx = 1;
    if (cnt == 0) cnt = 1;
    h = span / cnt;
    lcd_fill_rect(0x137, (u16)(y_top + (idx - 1) * h), 6, h, 0xFFFF);
}

/* ==========================================================================
 * FFEF9D7D-FFEF9E8F (274)  bevel_box_row_draw   [IDA sub_FFEF9D7D]
 * Caller: screen_grid_draw (12 sites).  args (x, y, w, h, gap, first, end).
 * For i = first .. end-1, draws a 3-px bevelled frame around the cell at
 * x + (w+gap)*i: top/left in 0x4A69, bottom/right in 0x2124, the two 3x3
 * corner joins in 0x39E7.                                           Confirmed
 * ========================================================================== */
void bevel_box_row_draw(u16 x, u16 y, u16 w, u16 h, u16 gap, u8 first, u8 end)
{
    u8 i;
    for (i = first; i < end; i++) {
        u16 cx = (u16)((w + gap) * i + x);
        lcd_fill_rect(cx, y, w, 3, 0x4A69);                  /* top    */
        lcd_fill_rect(cx, y + h - 3, w, 3, 0x2124);          /* bottom */
        lcd_fill_rect(cx, y, 3, h, 0x4A69);                  /* left   */
        lcd_fill_rect(cx + w - 3, y, 3, h, 0x2124);          /* right  */
        lcd_fill_rect(cx + w - 3, y, 3, 3, 0x39E7);          /* top-right join   */
        lcd_fill_rect(cx, y + h - 3, 3, 3, 0x39E7);          /* bottom-left join */
    }
}

/* ==========================================================================
 * FFEF9E8F-FFEFA54D (1726)  screen_grid_draw   [IDA sub_FFEF9E8F]
 * 66 callers across the menu / function screens (FFEE2284 ... FFF0EBxx).
 * Arg: grid id 0..20 (jump table at FFEF9EA7; >20 does nothing).  Clears the
 * screen below the grid's top to black and paints a grid of bevelled cells;
 * a few ids paint bitmap tiles instead.  Parameters per id (x, y, w, h, gap,
 * row gap, cells per row, rows):
 *    0      : (0, 75, 80,55, gap 0)  4 cells x 3 rows
 *    1      : (0, 33,106,51, gap 1, row gap 1) 3 x 4 rows
 *    2      : (0, 32, 64,52, gap 0)  5 x 4 rows
 *    3,15   : (0,183, 78,57, gap 2)  4 x 1
 *    6      : (0,183,106,57, gap 1)  3 x 1
 *    7,8,9  : (0,183,106,57, gap 1)  3 x 1; clears only cell id-7 first and
 *             redraws only that cell's frame (cell selection highlight)
 *    10     : (0,183,106,57, gap 107) 2 x 1, both cells cleared
 *    11     : (0,183,106,57, gap 1)  cells 1..2, both cleared
 *    12,13  : (0,125,106,57, gap 1, row gap 1) 3 x 2 rows
 *    14     : (0, 67,106,57, gap 1, row gap 1) 3 x 3 rows
 *    18     : (0, 33,106,57, gap 1)  cell 2 only, cleared
 *    19     : (20,153,106,57, gap 68) 2 x 1, both cleared
 *    4      : twelve 106x60 tiles FFED3C1C..FFED3D7C at x 0/107/214,
 *             y 0/60/120/180 (function-key / home tile screen)
 *    16     : FFED241C (44x44) at (0,59) and (0,193), FFED242C (78x51) x4 at
 *             x=242, y = 24 + 54*k
 *    17     : FFED2B5C (62x53) x5 at x = 1 + 64*k, y = 187
 *    20     : FFED241C at (0,193), (191,193), (0,59)
 *    5      : nothing.                                              Confirmed
 * (x=0x..: IDA's #-49h etc. are UIMM8: -49h=183, -45h=187, -3Fh=193,
 *  -67h=153, -0Eh=242.)
 * ========================================================================== */
void screen_grid_draw(u16 id)
{
    u16 x, y, w, h, gap, rowgap = 0;
    u8 first = 0, end, rows = 1, r, k;

    switch (id) {
    case 0:  x = 0; y = 75;  w = 80;  h = 55; gap = 0; rowgap = 0; end = 4; rows = 3; break;
    case 1:  x = 0; y = 33;  w = 106; h = 51; gap = 1; rowgap = 1; end = 3; rows = 4; break;
    case 2:  x = 0; y = 32;  w = 64;  h = 52; gap = 0; rowgap = 0; end = 5; rows = 4; break;
    case 3: case 15:
             x = 0; y = 183; w = 78;  h = 57; gap = 2; end = 4; break;
    case 6:  x = 0; y = 183; w = 106; h = 57; gap = 1; end = 3; break;
    case 7: case 8: case 9:
             x = 0; y = 183; w = 106; h = 57; gap = 1;
             first = (u8)(id - 7);
             lcd_fill_rect((u16)(x + (w + gap) * first), y, w, h, 0x0000);
             bevel_box_row_draw(x, y, w, h, gap, first, (u8)(first + 1));
             return;
    case 10: x = 0; y = 183; w = 106; h = 57; gap = 107; end = 2;
             lcd_fill_rect(x, y, w, h, 0);  lcd_fill_rect(x + w + gap, y, w, h, 0);
             bevel_box_row_draw(x, y, w, h, gap, 0, end);
             return;
    case 11: x = 0; y = 183; w = 106; h = 57; gap = 1;
             lcd_fill_rect(x + w + gap, y, w, h, 0);  lcd_fill_rect(x + (w + gap) * 2, y, w, h, 0);
             bevel_box_row_draw(x, y, w, h, gap, 1, 3);
             return;
    case 12: case 13:
             x = 0; y = 125; w = 106; h = 57; gap = 1; rowgap = 1; end = 3; rows = 2; break;
    case 14: x = 0; y = 67;  w = 106; h = 57; gap = 1; rowgap = 1; end = 3; rows = 3; break;
    case 18: x = 0; y = 33;  w = 106; h = 57; gap = 1;
             lcd_fill_rect(x + (w + gap) * 2, y, w, h, 0);
             bevel_box_row_draw(x, y, w, h, gap, 2, 3);
             return;
    case 19: x = 20; y = 153; w = 106; h = 57; gap = 68;
             lcd_fill_rect(x, y, w, h, 0);  lcd_fill_rect(x + w + gap, y, w, h, 0);
             bevel_box_row_draw(x, y, w, h, gap, 0, 2);
             return;
    case 4: {
        static const BmpDesc *const tile[4][3] = {
            { &icon_FFED3C7C, &icon_FFED3D5C, &icon_FFED3CBC },
            { &icon_FFED3D3C, &icon_FFED3CFC, &icon_FFED3C9C },
            { &icon_FFED3D7C, &icon_FFED3C5C, &icon_FFED3C1C },
            { &icon_FFED3D1C, &icon_FFED3CDC, &icon_FFED3C3C } };
        static const u16 tx[3] = { 0, 107, 214 };
        for (r = 0; r < 4; r++) for (k = 0; k < 3; k++)
            icon_draw_or_erase(tx[k], (u16)(r * 60), 1, tile[r][k]);
        return; }
    case 16:
        icon_draw_or_erase(0, 59, 1, &icon_FFED241C);
        icon_draw_or_erase(0, 193, 1, &icon_FFED241C);
        for (k = 0, y = 24; k < 4; k++, y += 54) icon_draw_or_erase(242, y, 1, &icon_FFED242C);
        return;
    case 17:
        for (k = 0, x = 1; k < 5; k++, x += 64) icon_draw_or_erase(x, 187, 1, &icon_FFED2B5C);
        return;
    case 20:
        icon_draw_or_erase(0, 193, 1, &icon_FFED241C);
        icon_draw_or_erase(191, 193, 1, &icon_FFED241C);
        icon_draw_or_erase(0, 59, 1, &icon_FFED241C);
        return;
    default:                                    /* 5 and > 20 */
        return;
    }
    /* common "grid" path: black from y to the bottom, then rows of frames */
    lcd_fill_rect(x, y, 320 - x, 240 - y, 0x0000);
    for (r = 0; r < rows; r++) {
        bevel_box_row_draw(x, y, w, h, gap, first, end);
        y = (u16)(h + rowgap + y);
    }
}
/* note: grid ids 3/15 and 6 run the frame row once (no loop in the binary). */

/* FFEFA54F-FFEFA571 (34)  scroll_track_draw  [IDA sub_FFEFA54F]
 * 12 callers.  args (y_top, y_bottom): grey 6-px track at x=311.  Confirmed */
void scroll_track_draw(u16 y_top, u16 y_bot)
{
    lcd_fill_rect(0x137, y_top, 6, (u16)(y_bot - y_top), 0x7BEF);
}

/* FFEFA571-FFEFA588 (23)  lcd_clear_black  [IDA sub_FFEFA571]
 * Caller: FFF0CE38.  Fills the whole 320x240 screen with 0x0000.  Confirmed */
void lcd_clear_black(void) { lcd_fill_rect(0, 0, 320, 240, 0x0000); }

/* ==========================================================================
 * FFEFA588-FFEFA747 (447)  screen_title_bar_draw   [IDA sub_FFEFA588]
 * 17 callers.  Paints the 20-px title band (0x3186), black below it, then a
 * white 1-px divider whose y depends on the screen:
 *   F1/0x00: 119 single / 83 dual   F1/0x01, 0x14, 0x15: 119
 *   F1/0x03: 73 and 128             F1/0x0B: 83     F1/0x0F: 76
 *   F1/0x12: 104                    F1/0x13: 83     F8/0x00, FD/0x00: 83
 * Other screens: no divider.                                       Confirmed
 * ========================================================================== */
void screen_title_bar_draw(void)
{
    u8 op = FRAME_OP, sub = FRAME_SUB, dual = DUAL_FLAG;
    u16 ty = 0x14, ly;

    lcd_fill_rect(0, 0, 320, ty, 0x3186);
    lcd_fill_rect(0, 0x14, 320, 240 - ty, 0x0000);

    if (op == 0xF1) {
        if (sub == 0x14 || sub == 0x15 || sub == 1) ly = 0x77;
        else if (sub == 3) { lcd_fill_rect(0, 0x49, 320, 1, 0xFFFF); ly = 0x80; }
        else if (sub == 0x0B) ly = 0x53;
        else if (sub == 0x0F) ly = 0x4C;
        else if (sub == 0x12) ly = 0x68;
        else if (sub == 0x13) ly = 0x53;
        else if (sub == 0)    ly = dual ? 0x53 : 0x77;
        else return;
    } else if ((op == 0xF8 || op == 0xFD) && sub == 0) {
        ly = 0x53;
    } else return;
    lcd_fill_rect(0, ly, 320, 1, 0xFFFF);
}

/* FFEFA747-FFEFA75E (23)  lcd_clear_black_2  [IDA sub_FFEFA747]
 * 23 callers.  Byte-identical twin of lcd_clear_black.            Confirmed */
void lcd_clear_black_2(void) { lcd_fill_rect(0, 0, 320, 240, 0x0000); }

/* FFEFA75E-FFEFA78C (46)  lcd_clear_with_title  [IDA sub_FFEFA75E]
 * 15 callers.  Black screen, then a 26-px 0x3186 title band.       Confirmed */
void lcd_clear_with_title(void)
{
    lcd_fill_rect(0, 0, 320, 240, 0x0000);
    lcd_fill_rect(0, 0, 320, 0x1A, 0x3186);
}

/* FFEFA78C-FFEFA7E7 (91)  rect_outline_white  [IDA sub_FFEFA78C]
 * Caller: FFF376C7.  1-px white outline of (x, y, w, h).          Confirmed */
void rect_outline_white(u16 x, u16 y, u16 w, u16 h)
{
    lcd_fill_white(x, y, w, 1);
    lcd_fill_white(x, y + h - 1, w, 1);
    lcd_fill_white(x, y + 1, 1, h - 2);
    lcd_fill_white(x + w - 1, y + 1, 1, h - 2);
}

/* ==========================================================================
 * FFEFA7E7-FFEFA924 (317)  text_draw_mixed   [IDA sub_FFEFA7E7]
 * 441 call sites (doc 27/45 "string renderer").  args (x, y, dbcs_mask, s).
 * Up to 16 bytes; stops at NUL.  Bit (15-i) of dbcs_mask marks s[i] as the
 * first byte of a double-byte code (a lead marked at i==15 stops).  Double
 * byte: code = s[i]<<8|s[i+1] (0xFFFF -> 0x2121), drawn with
 * glyph_draw_dbcs(.., block 2, code, big), advance 28 (big) / 14.  Single
 * byte: 0xFF -> ' ', glyph_draw_sbcs(.., block 0x0D, 0, 1, &c, big), advance
 * 14 / 7.  Glyphs that would pass x=308 stop the string.  big = 1 except on
 * screen F3/0xD1.  (Doc 20 lists the args as (x,y,str,color); the third arg
 * is the mask, the fourth the string - doc 45's reading is right.) Confirmed
 * ========================================================================== */
void text_draw_mixed(u16 x, u16 y, u16 dbcs_mask, const u8 *s)
{
    u16 dx = 0;
    u8 big = 1, i, dbl;

    if (FRAME_OP == 0xF3 && FRAME_SUB == 0xD1) big = 0;

    for (i = 0; i <= 15; i++) {
        if (s[i] == 0) return;
        dbl = (u8)((dbcs_mask >> (15 - i)) & 1);
        if (i == 15 && dbl == 1) return;
        if (dbl == 1) {
            u16 code;
            if (x + dx + 0x1C > 0x134) return;
            code = (u16)(s[i] << 8 | s[i + 1]);
            if (code == 0xFFFF) code = 0x2121;
            glyph_draw_dbcs(x + dx, y, 2, code, big);
            dx += big ? 0x1C : 0x0E;
            i++;                                        /* consumes two bytes */
        } else {
            u8 c;
            if (x + dx + 0x0E > 0x134) return;
            c = s[i];
            if (c == 0xFF) c = ' ';
            glyph_draw_sbcs(x + dx, y, 0x0D, 0, 1, &c, big);
            dx += big ? 0x0E : 0x07;
        }
    }
}

/* ==========================================================================
 * FFEFA924-FFEFAA2B (263)  text_draw_mixed_colour   [IDA sub_FFEFA924]
 * Caller: FFF448F5.  args (x, y, dbcs_mask, s, colour).
 * As text_draw_mixed, always big, through the coloured glyph blitters
 * sub_FFEF1A16 / sub_FFEF1BB1.  As compiled, double-byte glyphs use the
 * colour argument while single-byte glyphs are always drawn in 0x7BEF grey.
 *                                                                  Confirmed
 * ========================================================================== */
void text_draw_mixed_colour(u16 x, u16 y, u16 dbcs_mask, const u8 *s, u16 colour)
{
    u16 dx = 0;
    u8 i, dbl;

    for (i = 0; i <= 15; i++) {
        if (s[i] == 0) return;
        dbl = (u8)((dbcs_mask >> (15 - i)) & 1);
        if (i == 15 && dbl == 1) return;
        if (dbl == 1) {
            u16 code;
            if (x + dx + 0x1C > 0x134) return;
            code = (u16)(s[i] << 8 | s[i + 1]);
            if (code == 0xFFFF) code = 0x2121;
            glyph_draw_dbcs_col(x + dx, y, 2, code, 1, colour);
            dx += 0x1C;
            i++;
        } else {
            u8 c;
            if (x + dx + 0x0E > 0x134) return;
            c = s[i];
            if (c == 0xFF) c = ' ';
            glyph_draw_sbcs_col(x + dx, y, 0x0D, 0, 1, 0x7BEF, &c, 1);
            dx += 0x0E;
        }
    }
}

/* ==========================================================================
 * FFEFAA2B-FFEFAA9D (114)  scroll_thumb_draw   [IDA sub_FFEFAA2B]
 * 13 callers.  args (x, y, w, h, total, visible, first).
 * unit = h/total; grey 0x7BEF track (x,y,w,h); white thumb at y+first*unit,
 * height h-(total-visible)*unit when total > visible, else h.     Confirmed
 * ========================================================================== */
void scroll_thumb_draw(u16 x, u16 y, u16 w, u16 h, u8 total, u8 visible, u8 first)
{
    u16 unit = h / total, th;

    th = (total > visible) ? (u16)(h - (total - visible) * unit) : h;
    lcd_fill_rect(x, y, w, h, 0x7BEF);
    lcd_fill_rect(x, (u16)(y + first * unit), w, th, 0xFFFF);
}

/* ==========================================================================
 * FFEFAA9D-FFEFAB3E (161)  page_thumb_draw   [IDA sub_FFEFAA9D]
 * Callers: FFF44235, FFF448F5.  args (x, y, w, h, n_a, n_b, page).
 * a = n_a ? h/n_a : 0, b = n_b ? h/n_b : 0; page 0 or page > n_a -> thumb
 * size 0; thumb at y+(page-1)*a (last page: y+h-b), height b.  Grey track,
 * white thumb.                                                      Confirmed
 * ========================================================================== */
void page_thumb_draw(u16 x, u16 y, u16 w, u16 h, u8 n_a, u8 n_b, u8 page)
{
    u16 a = n_a ? (u16)(h / n_a) : 0;
    u16 b = n_b ? (u16)(h / n_b) : 0;
    u16 off = 0;

    if (page > n_a || page == 0) { a = 0; b = 0; }
    else {
        off = (u16)((page - 1) * a);
        if (page == n_a) off = (u16)(h - b);
    }
    lcd_fill_rect(x, y, w, h, 0x7BEF);
    lcd_fill_rect(x, (u16)(y + off), w, b, 0xFFFF);
}

/* RGB565 font renderers share this: copy the glyph's descriptor to the stack
 * with a caller tint (tint_on = tint != 0xFFFF) and blit it.  These are the
 * "stack-built wrapper descriptors" at FFEFAC8B / FFEFADCF / FFEFAEF3 that
 * doc 23 left unaudited: the copy's source is the flash descriptor reached
 * through the RAM glyph table, only tint/tint_on come from the caller.      */
static void tinted_blit(u16 x, u16 y, u8 vis, const BmpDesc *g, u16 tint)
{
    BmpDesc t;
    t.w = g->w; t.h = g->h; t.pix = g->pix; t.key = g->key;
    t.tint = tint; t.tint_on = (tint != 0xFFFF) ? 1 : 0;
    icon_draw_or_erase(x, y, vis, &t);
}

/* ==========================================================================
 * FFEFAB3E-FFEFAD3F (513)  rgbtext_draw_12   [IDA sub_FFEFAB3E]
 * 44 callers.  args (x, y, spacing, s, len, tint).  Font g_font12 (0x688BC),
 * chars 0x21..0x7E; pitch 12+spacing.  Byte 0x06 draws the 6x18 glyph
 * FFED214C.  6-px-wide glyphs are centred (+3) except on screens F7/01,
 * F7/03 and, for '.'/':' only, F6/40.  On F7/01|03 glyphs go through
 * sub_FFEF0D92 and a '.' pulls the next glyph 6 px left; on F6/40 '.' and
 * ':' do the same.  Space and other bytes just advance.            Confirmed
 * ========================================================================== */
void rgbtext_draw_12(u16 x, u16 y, u16 spacing, const u8 *s, u16 len, u16 tint)
{
    u8 op = FRAME_OP, sub = FRAME_SUB, i, c, vis = 0;
    int f7 = (op == 0xF7 && (sub == 1 || sub == 3));
    int f640 = (op == 0xF6 && sub == 0x40);

    for (i = 0; i < len; i++) {
        c = s[i];
        if (c >= 0x21 && c <= 0x7E) {
            const BmpDesc *g = g_font12[c - 0x21];
            u16 off = 0;
            vis = 1;
            if (g->w == 6) {
                off = 3;
                if (f7) off = 0;
                else if (f640 && (c == '.' || c == ':')) off = 0;
            }
            if (f7) {
                BmpDesc t = *g; t.tint = tint; t.tint_on = (tint != 0xFFFF);
                lcd_blit_alt(x + off, y, &t);
            } else {
                tinted_blit(x + off, y, vis, g, tint);
            }
        } else if (c == 0x06) {
            vis = 1;
            icon_draw_or_erase(x, y, vis, &icon_FFED214C);
        }
        x = (u16)(spacing + x + 12);
        if (c == '.' && f7) x -= 6;
        if (f640 && (c == '.' || c == ':')) x -= 6;
    }
}

/* ==========================================================================
 * FFEFAD3F-FFEFADF3 (180)  rgbtext_draw_20   [IDA sub_FFEFAD3F]
 * Callers: bandrow_draw_main (x2).  args (x, y, spacing, s, len, tint).
 * Font g_font20 (0x68A34), chars 0x21..0x7E, pitch 20+spacing.    Confirmed
 * ========================================================================== */
void rgbtext_draw_20(u16 x, u16 y, u16 spacing, const u8 *s, u16 len, u16 tint)
{
    u8 i, c, vis = 0;
    for (i = 0; i < len; i++) {
        c = s[i];
        if (c >= 0x21 && c <= 0x7E) { vis = 1; tinted_blit(x, y, vis, g_font20[c - 0x21], tint); }
        x = (u16)(spacing + x + 20);
    }
}

/* ==========================================================================
 * FFEFADF3-FFEFAF18 (293)  rgbtext_draw_num8   [IDA sub_FFEFADF3]
 * Caller: header_draw_text7.  args (x, y, spacing, s, len, tint).
 * Small font g_font8num (0x68BAC); only '0'..':', 'i', 'k', 'm', '.', '-'
 * are drawn (distance / numeric labels such as km, mi); pitch 8+spacing.
 *                                                                  Confirmed
 * ========================================================================== */
void rgbtext_draw_num8(u16 x, u16 y, u16 spacing, const u8 *s, u16 len, u16 tint)
{
    u8 i, c;
    for (i = 0; i < len; i++) {
        c = s[i];
        if ((c >= '0' && c <= ':') || c == 'i' || c == 'k' || c == 'm' || c == '.' || c == '-')
            tinted_blit(x, y, 1, g_font8num[c - 0x21], tint);
        x = (u16)(spacing + x + 8);
    }
}

/* ==========================================================================
 * FFEFAF18-FFEFB267 (847)  rounded_panel_draw   [IDA sub_FFEFAF18]
 * Callers: FFEE8AEF, FFF11E60, FFF12386.  args (x, y, w, h).
 * Fills the panel 0x3186, draws a 1-px 0xAD95 border, then hand-plots the
 * four anti-aliased rounded corners pixel by pixel (lcd_fill_rect 1x1) with
 * 0x0000 (outside), 0x94B2, 0x73AE, 0x528A.                         Confirmed
 * ========================================================================== */
void rounded_panel_draw(u16 x, u16 y, u16 w, u16 h)
{
    static const struct { s8 dx, dy; u16 c; } corner[6] = {
        {0,0,0x0000}, {1,1,0x94B2}, {1,0,0x73AE}, {0,1,0x73AE}, {2,1,0x528A}, {1,2,0x528A} };
    u8 k;

    lcd_fill_rect(x, y, w, h, 0x3186);
    lcd_fill_rect(x, y, w, 1, 0xAD95);
    lcd_fill_rect(x, y + h - 1, w, 1, 0xAD95);
    lcd_fill_rect(x, y, 1, h, 0xAD95);
    lcd_fill_rect(x + w - 1, y, 1, h, 0xAD95);
    for (k = 0; k < 6; k++) {          /* same 6-pixel pattern mirrored per corner */
        lcd_fill_rect(x + corner[k].dx,         y + corner[k].dy,         1, 1, corner[k].c); /* TL */
        lcd_fill_rect(x + w - 1 - corner[k].dx, y + corner[k].dy,         1, 1, corner[k].c); /* TR */
        lcd_fill_rect(x + corner[k].dx,         y + h - 1 - corner[k].dy, 1, 1, corner[k].c); /* BL */
        lcd_fill_rect(x + w - 1 - corner[k].dx, y + h - 1 - corner[k].dy, 1, 1, corner[k].c); /* BR */
    }
}
/* The binary writes the 24 pixels in TL, TR, BL, BR order as straight-line
 * code; the table is the same pixel set.                                     */

/* FFEFB267-FFEFB268 (1)  nop_callback  [IDA sub_FFEFB267]
 * Bare rts.  No code xrefs; its address is the first code pointer of the
 * CALLBACK_REGINIT table at FFECE4E4 (doc 27), i.e. a default no-op hook.
 *                                                                  Confirmed */
void nop_callback(void) { }

/* FFEFB268-FFEFB29A (50)  memcpy_bytes  [IDA sub_FFEFB268]  11 callers (doc 25).
 * Byte copy dst=r1, src=r2, n=r3; returns nothing useful.          Confirmed */
void memcpy_bytes(u8 *dst, const u8 *src, u32 n) { while (n != 0) { *dst++ = *src++; n--; } }

/* FFEFB29A-FFEFB2C2 (40)  memset_bytes  [IDA sub_FFEFB29A]  16 callers.
 * Byte fill dst=r1, value=r2 (u8), n=r3.                           Confirmed */
void memset_bytes(u8 *dst, u8 v, u32 n) { while (n != 0) { *dst++ = v; n--; } }
