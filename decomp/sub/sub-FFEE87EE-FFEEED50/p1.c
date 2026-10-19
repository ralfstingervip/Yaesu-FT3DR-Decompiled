/* ============================================================================
 * sub-FFEE87EE-FFEEED50.c  -  Hand-reconstructed C, SUB (RX64M, CC-RX),
 * address range 0xFFEE87EE-0xFFEEED50 (119 functions).  Wave C lane.
 *
 * DOCUMENTATION ONLY.  Transcribed by hand from the IDA listing chunk
 * (decomp/tools/build_listings.py output).  Nothing compiled or run.
 *
 * WHAT THIS RANGE IS
 *   The SUB-side "screen handlers" for five MAIN->SUB F1xx screens plus the
 *   shared element-redraw machinery of the main operating (frequency) screen:
 *     screen 0x06 (F106, F-menu grid)       scr06_*   FFEE87EE..FFEE8AA5
 *     screen 0x11 (F111, GPS information)   scr11_*   FFEE8AA5..FFEEA1AE
 *     screen 0x08 (F108/9/A, F280, text entry line + 20 icon slots)
 *                                           scr08_*   FFEEA1AE..FFEEA7DB
 *     screen 0x0F (F10F, four text fields over the operating area)
 *                                           scr0F_*   FFEEA7DB..FFEEAE5E
 *     screen 0x01 (F101, main operating screen, single band)
 *                                           scr01_*   FFEEAE5E..FFEEB8E4
 *     element redraw handlers, layout classifiers and per-element
 *     position "locators" shared by the operating screens
 *                                           FFEEB8E4..FFEEED50
 *   Screen ids and handler slots: off_FFED4050[id] (ida/out/abi-ipc/SUB_abi.txt,
 *   ida/out/ipc-reach/opcode-matrix.tsv).  Event tables are the dword tables
 *   at FFED50E0.. (ida/out/sub-final/raw/apply_pass1_changes.tsv ptr_dword rows;
 *   FFED54B0..5514 rebuilt from the "undefine" byte rows of the same file).
 *
 * THE SCREEN FRAMEWORK (one paragraph; every scrNN_* below follows it)
 *   Each screen handler is called from the SUB UI loop while its screen id is
 *   current.  It switches on g_ui_step (RAM 0x8C4C) through a 4-entry table:
 *     step 0  scrNN_sync(1): copy the pending IPC frame (0x8E46) into the
 *             applied shadow (0x8C4D) field by field and clear all events
 *     step 1  draw the static frame (framebuffer init, header bar, title)
 *     step 2  open a full-screen region, draw everything, commit
 *     step 3  event loop: ev = ui_next_event(); if none, scrNN_sync(0);
 *             if ev is in range and the blit queue is idle, clear the event
 *             bit and call the screen's per-event table entry
 *   Every step that draws ends in lcd_commit_region_and_step() (FFEF036F),
 *   which queues the surface for the blitter AND increments g_ui_step; a step
 *   whose region could not be opened is simply retried next pass.  Step > 3
 *   is clamped back to 3.  "Events" are 64 dirty bits in g_ui_events[2]
 *   (0x1D3B0/0x1D3B4): event n<32 is word0 bit n, event 0x20+n is word1 bit n.
 *   The sync routines raise the bits for the fields that changed; event 0
 *   (word0 bit0, raised by the common header reconcilers) restarts the screen
 *   at step 1; event 1 redraws the frame; event 2 clears the screen.
 *
 * RX ENCODING NOTE.  IDA prints the zero-extended 8-bit immediate forms
 * (75 4x uimm8, 3C/3D/3E #uimm8 stores) as negative numbers.  Every such
 * operand in this range was resolved from ida/out/protocols/sub_operands.tsv
 * (decoded operand values) - e.g. "cmp #-0Fh" is cmp #0xF1, "mov.w #-10h,[sp]"
 * is 0xF0 (240), "mov.l #-66h,r2" is 0x9A, but "mov.l #-4,r14" (FB form) is -4.
 * ========================================================================== */

#include <stdint.h>
typedef uint8_t u8;  typedef uint16_t u16;  typedef uint32_t u32;
typedef int8_t  s8;  typedef int16_t  s16;  typedef int32_t  s32;

/* ---------------------------------------------------------------------------
 * RAM globals (address, meaning).  See globals.tsv for evidence.
 * ------------------------------------------------------------------------- */
extern u8   g_shadow[];          /* 0x00008C4D applied shadow of the last IPC frame:
                                    [0]=opcode hi (F0..FF), [1]=opcode lo, [9] b4 =
                                    two-row layout flag, [0x20..] current record   */
extern u8   g_frame[];           /* 0x00008E46 pending IPC frame (300-byte copy)   */
extern u8   g_ui_step;           /* 0x00008C4C per-screen draw step 0..3           */
extern u8   g_cur_event;         /* 0x00008F73 event index being serviced (0xFF=none)*/
extern u8   g_blink_armed;       /* 0x00008F74 screen 08: blink mask already armed */
extern u8   g_redraw_8D79;       /* 0x00008D79 cleared before every full redraw    */
extern u8   g_multislot_redraw;  /* 0x00008F77 force full redraw of the multi-slot
                                    renderer (doc 31 "redraw trigger")             */
extern u32  g_ui_events[2];      /* 0x0001D3B0 / 0x0001D3B4 dirty-event bits       */
extern void *g_rec_ptr;          /* 0x0001D39C published &g_shadow[0x20]           */
extern u8   g_screen_type_ovr;   /* 0x00012285 ui_screen_type() override, 0xFF=off */
struct surface { u8 busy, layer; u16 x, y, w, h; u16 pad; u32 pixels; };
extern struct surface g_lcd_surf;/* 0x0001D3B8 full-screen surface descriptor      */
extern u8   g_gps[];             /* 0x0001D284 screen-11 cache of the GPS data:
                                    [0..2] yy,mm,dd [3..5] hh,mm,ss
                                    [6] hemisphere 0=NE 1=NW 2=SE 3=SW
                                    [7] lat deg [8] lat min [9] lon deg [10] lon min
                                    w[0xC] lat min-fraction BCD, w[0xE] lon frac BCD
                                    w[0x10] (sky-plot trigger) w[0x12] speed BCD
                                    (0.1 kn) [0x18..0x1F] altitude block:
                                    [0x1D] 1=negative w[0x1E] altitude (m)
                                    [0x30] satellites in view, [0x32+6i] i<36:
                                    prn, elev, w azimuth (BCD), snr, used-flag     */
extern void *g_tone_glyph[];     /* 0x00068E2C glyph descriptor ptrs for tone digits*/
extern void *g_font_digits[][11];/* 0x00068D24 per-font digit glyph ptrs (0x2C each)*/

/* Flash constants used here */
extern const u8  k_month_abbr[];   /* 0xFFC3D399 "Jan","Feb",... 4 bytes each        */
extern const u8  k_skyplot_xy[32][20]; /* 0xFFC3D3C9 [azimuth sector][ring*2]=(x,y) */
extern const u8  k_days_in_month[];/* 0xFFC3D649 indexed by month 1..12            */
extern const u8  k_ctcss_glyphs[][5];/* 0xFFC3D656 per CTCSS tone, 5 glyph indices  */
extern const u8  k_dcs_glyphs[][3];/* 0xFFC3D750 per DCS code, 3 glyph indices      */
extern const char k_tone_mode_str[];/* aTnTsqdcsrtnjrP "   TN TSQDCSRTNJR PR PAG..." 3/entry */
struct field_xy { u16 x, y, a, b; };
extern const struct field_xy k_scr01_fields[]; /* 0xFFEC6058 (rec 0 = top, rec 3) */
extern const u8 stru_FFED23CC[], stru_FFED303C[], stru_FFED305C[], stru_FFED307C[],
                stru_FFED236C[], stru_FFED333C[], stru_FFED334C[], stru_FFED2F7C[],
                stru_FFECF07C[], stru_FFECF09C[], stru_FFED3E9C[], stru_FFED3E7C[];
extern const u8 k_prn_glyph[10][16];   /* stru_FFED24BC..FFED254C digits '0'..'9'   */
extern const u8 stru_FFED336C[], stru_FFED338C[], stru_FFED337C[], stru_FFED339C[]; /* A S Q Z */

/* ---------------------------------------------------------------------------
 * Callees outside this range (names are this lane's; IDA name in comment).
 * ------------------------------------------------------------------------- */
u8   lcd_begin_region(struct surface *s, u16 x, u16 y, u16 w, u16 h); /* FFEEF9BB:
          claims the single draw layer (0x8F75), fills s, sets 0x1D3C8=s,
          buffer = 0x704B000 + layer*0x25800; returns 1, or 0 if busy/empty */
void lcd_commit_region_and_step(void);   /* FFEF036F: queue g_lcd_surf (FFEEFA9E), g_ui_step++ */
void lcd_init_fullscreen_surface(void);  /* FFEF032D: g_lcd_surf = {0,0,320,240,0x07000000} */
u8   lcd_queue_busy(void);               /* FFEEFB84: blit queue count 0x8F76 > 0     */
void lcd_clear_rect(u16 x, u16 y, u16 w, u16 h);           /* FFEF04F7 */
void lcd_fill_rect(u16 x, u16 y, u16 w, u16 h, u16 rgb565);/* FFEF1C48 */
void lcd_fill_rect2(u16 x, u16 y, u16 w, u16 h, u16 c1, u16 c2); /* FFEF1C79 (two-colour fill) */
void lcd_blit(u16 x, u16 y, const void *bmp);              /* FFEF0648 RGB565 blit (doc 16) */
void lcd_draw_icon(u16 x, u16 y, u8 mode, const void *d);  /* FFEF68D5 icon blit (doc 16) */
void lcd_draw_text(u16 x, u16 y, u8 font, const char *s, u16 len, u16 rgb); /* FFEFAB3E */
void lcd_draw_string_dw(u16 x, u16 y, u16 dw_mask, const u8 *s); /* FFEFA7E7 string renderer,
                                                     bit (15-i) = char i double width */
void lcd_draw_text_ex(u16 x, u16 y, u8 a, u8 b, u8 len, u8 c, const u8 *s); /* FFEF1B23 */
void lcd_draw_panel(u16 x, u16 y, u16 w, u16 h);           /* FFEFAF18 framed box */
void ui_restore_background(u16 x, u16 y);                  /* FFEF0408 (Inferred) */
void ui_draw_status_bar(void);                             /* FFEF399F */
void ui_draw_header_bar(void);                             /* FFEFA588 */
void ui_draw_header_bar_alt(void);                         /* FFEFA747 */
void ui_draw_title(u16 n);                                 /* FFEF9E8F 21-case title box */
void ui_draw_icon_slot(u8 slot);                           /* FFEF2505 icon record renderer (doc J11) */
u8   ui_next_event(void);                /* FFEF003F: 0xFF if 0x8D7A set or hdr[0x13]
                                            pending, else highest-priority set bit */
void ui_clear_event(u8 ev);              /* FFEEFFEA */
void ui_clear_all_events(void);          /* FFEF002C */
void ui_raise_w0(u32 m);                 /* FFEEFEA4: g_ui_events[0] |= m */
void ui_raise_w1(u32 m);                 /* FFEEFEEE: g_ui_events[1] |= m */
void ui_raise_elem(u32 idx, u8 kind);    /* FFEEFE0E: kind 0 w0|=idx, 1/3 w0|=0x8000<<idx, 2 w1|=1<<idx */
void ui_clear_elem(u32 idx, u8 kind);    /* FFEEFF4C: inverse of ui_raise_elem */
void ui_clear_w0(u32 m);                 /* FFEEFF25 */
u8   copy_raise_w1(u8 *dst, const u8 *src, u8 n, u32 m); /* FFEF20DD: copy n, w1|=m if any differed */
u8   copy_raise_w0(u8 *dst, const u8 *src, u8 n, u32 m); /* FFEF208D: same, word 0 */
void ui_blink_enable(u32 w1bits, u32 w0bits);  /* FFEF0163: start blink timer, OR masks */
void ui_blink_disable(u32 w1bits, u32 w0bits); /* FFEF019E */
u8   ui_blink_phase(void);               /* FFEF02F2: 0x68854[1] & 1 */
void ui_flush_blink_events(void);        /* FFEF0294 (doc 31) */
void ipc_sync_opcode(void);              /* FFEF4069: shadow[0],[1] <- frame, w0 bit0 */
void ipc_sync_hdr13(void);               /* FFEF40BA: shadow[0x13],[0x1A] -> 0x8D7A */
void ipc_sync_common_header(void);       /* FFEF4142 (doc 31) */
void ipc_sync_record_block(u8 *dst, const u8 *src, u8 n); /* FFEF42A7 (doc 31) */
void *memcpy_(void *d, const void *s, u32 n);             /* FFEFB268 */
u8   bit_index(u32 v);                   /* FFEFB369: index of lowest set bit, 0xFF if none */
void gps_get_date(u8 *o3);               /* FFEDF972  from 0x1CC90 (or defaults FFED417C) */
void gps_get_time(u8 *o3);               /* FFEDF9A6 */
void gps_get_position(u8 *o10);          /* FFEDF9DC */
void gps_get_motion(u8 *o8);             /* FFEDFA32 */
void gps_get_altitude(u8 *o8);           /* FFEDF904 */
void gps_get_satellites(u8 *o218);       /* FFEDF942: count + 36 x 6-byte records */
void fmt_dec2(char *o, u8 v);            /* FFEE1C9A: two ASCII digits if v<=99 */
char hex_digit_char(u8 n);               /* FFEE1C4D */
void fmt_dec3_blank(char *o, u16 v);     /* FFEE1DE8: three digits, leading blanks */
u16  bcd4_to_bin(u16 bcd);               /* FFEE1BC0 */
double u16_to_double(u16);               /* FFF45A88 (runtime) */
double double_div(double, double);       /* FFF4568F (runtime) */
u16  double_to_u16(double);              /* FFF45AC6 (runtime) */
u8   op_single_row_q(void);              /* FFEF4CED (returns 1 = single-row variant) */
/* operating-display element drawers, outside this range (named by address) */
void opd_FFEF4FCE(void), opd_FFEF5202(void), opd_FFEF535E(void), opd_FFEF5421(void),
     opd_FFEF5494(void), opd_FFEF5518(void), opd_FFEF55FB(void), opd_FFEF59E4(void),
     opd_FFEF5E38(void), opd_FFEF6023(void), opd_FFEF631E(void), opd_FFEF637D(void),
     opd_FFEF643C(void), opd_FFEF64D2(void), opd_FFEF9B22(void), opd_FFEF541D(void);
void opd_multislot(void);                /* FFEF6096 -> FFEF6C42 multi-slot renderer (doc 31) */
void draw_field_FFEF6764(u16 x, u16 y, u8 mode, const u8 *s);
void draw_field_FFEF682C(u16 x, u16 y, const u8 *s);
void draw_field_FFEF68A1(u16 x, u16 y, const u8 *s);
/* other screen-family main-area drawers (other lanes) */
void sub_FFEE86D6(void), sub_FFEE683A(void), sub_FFEE5EF8(void), sub_FFEE806F(void),
     sub_FFEE7985(void), sub_FFF4026F(void), sub_FFF4112D(void), sub_FFF44EE1(void),
     sub_FFF44FA3(void), sub_FFF453BB(void), sub_FFF12272(void), sub_FFEEF77E(void),
     sub_FFEDED67(void);

/* forward declarations for this range */
static void scr06_sync(u8 full);  static void scr06_reconcile_fields(void);
static void scr06_draw_all(void); void scr06_draw_operating_area(void);
static void scr06_draw_12_slots(void);
static void scr11_sync(u8 full);  static void scr11_reconcile_fields(void);
static void scr11_poll_gps_data(void); static void scr11_draw_all(void);
static void gps_draw_datetime_box(u16 x, u16 y, u8 tz);
static void gps_draw_latlon_box(u16 x, u16 y, u8 show, u8 fmt);
static void gps_draw_speed_box(u16 x, u16 y, u8 unit);
static void gps_draw_altitude_box(u16 x, u16 y, u8 unit);
static void gps_draw_snr_bars(u16 x, u16 y);
static void gps_draw_skyplot(u16 x, u16 y);
static void gps_apply_timezone(u8 tz, u8 *hm, u8 *ymd);
static u8   gps_shift_time_halfhours(u8 east, u8 n, u8 *hm);
static void gps_step_date(u8 dir, u8 *ymd);
static u8   is_leap_yy(u8 yy);
u8   ui_screen_type(void);  u8 *ui_current_record(void);
void ui_set_screen_type_override(u8 t);

#define UI_CLAMP_STEP()  do { if (g_ui_step >= 4) g_ui_step = 3; } while (0)
#define RGB_WHITE 0xFFFF
#define RGB_GREY  0x7BEF
#define LAYOUT_B4 ((g_shadow[9] & 0x10) >> 4)   /* two-row layout flag (Inferred) */

/* Generic 4-step dispatcher used by every screen handler in this range.     */
typedef void (*step_fn)(void);
typedef void (*event_fn)(void);

/* ============================================================================
 * SCREEN 0x06  (IPC F106, the F-menu grid; doc 103/RESUME: "F106 = F-menu grid")
 *   step table   off_FFED50E0 = { FFEE8818, FFEE882A, FFEE8845, FFEE88A0 }
 *   event table  off_FFED50F0[0..0x2C]: 0 FFEF3991 restart, 1 FFEE882A frame,
 *                2 FFEF395E clear, 0x0F/0x10 main-screen elements,
 *                0x20..0x2B FFEF23EE icon slots, 0x2C FFEE8872 grid redraw
 * ========================================================================== */

/* FFEE87EE-FFEE8818  size 42  scr06_fmenu_grid_handler  (sub_FFEE87EE)
 * Caller: SUB screen dispatcher via off_FFED4050[6].  Confirmed. */
extern step_fn off_FFED50E0[4];
void scr06_fmenu_grid_handler(void)
{
    if (g_ui_step <= 3) off_FFED50E0[g_ui_step]();
    else                g_ui_step = 3;
}

/* FFEE8818-FFEE882A  size 18  scr06_step0_sync  (sub_FFEE8818)  Confirmed.
 * Full sync (clears all events) then advance to step 1. */
void scr06_step0_sync(void) { scr06_sync(1); g_ui_step++; }

/* FFEE882A-FFEE8845  size 27  scr06_step1_frame  (sub_FFEE882A; IDA merged
 * lane-4 sub_FFEE8838).  Also event 1.  Confirmed. */
void scr06_step1_frame(void)
{
    lcd_init_fullscreen_surface();
    ui_draw_header_bar();
    ui_draw_title(0);
    g_ui_step++;
}

/* FFEE8845-FFEE8872  size 45  scr06_step2_full_draw  (sub_FFEE8845)  Confirmed. */
void scr06_step2_full_draw(void)
{
    if (lcd_begin_region(&g_lcd_surf, 0, 0, 0x140, 0xF0) == 1) {
        scr06_draw_all();
        lcd_commit_region_and_step();
    }
}

/* FFEE8872-FFEE88A0  size 46  scr06_ev2C_redraw_grid  (sub_FFEE8872)
 * Event 0x2C (word1 bit 12, raised by scr06_reconcile_fields).  Confirmed. */
void scr06_ev2C_redraw_grid(void)
{
    if (lcd_begin_region(&g_lcd_surf, 0, 0x4D, 0x140, 0xA3) == 1) {
        scr06_draw_12_slots();
        lcd_commit_region_and_step();
    }
}

/* FFEE88A0-FFEE8926  size 134  scr06_step3_events  (sub_FFEE88A0)  Confirmed. */
extern event_fn off_FFED50F0[0x2D];
void scr06_step3_events(void)
{
    g_cur_event = ui_next_event();
    if (g_cur_event == 0xFF) scr06_sync(0);
    if (g_cur_event != 0xFF && g_cur_event <= 0x2C && !lcd_queue_busy()) {
        ui_clear_event(g_cur_event);
        off_FFED50F0[g_cur_event]();
    }
    UI_CLAMP_STEP();
}

/* FFEE8926-FFEE8942  size 28  scr06_sync  (sub_FFEE8926)  Confirmed.
 * Shape shared by every scrNN_sync in this range. */
static void scr06_sync(u8 full)
{
    ipc_sync_opcode();
    scr06_reconcile_fields();
    ipc_sync_hdr13();
    if (full == 1) ui_clear_all_events();
}

/* FFEE8942-FFEE8A1B  size 217  scr06_reconcile_fields  (sub_FFEE8942)
 * Copies the screen-6 fields from the pending frame into the shadow.  Twelve
 * grid cells, two bytes each (shadow[0x6C+i], shadow[0x7C+i]); any change
 * raises event 0x2C.  Confirmed. */
static void scr06_reconcile_fields(void)
{
    u8 i;
    ipc_sync_common_header();
    g_rec_ptr = &g_shadow[0x20];
    ipc_sync_record_block(&g_shadow[0x20], &g_frame[0x20], 3);
    for (i = 0; i < 12; i++) {
        if (g_shadow[0x6C + i] != g_frame[0x6C + i]) { ui_raise_w1(0x1000); g_shadow[0x6C + i] = g_frame[0x6C + i]; }
        if (g_shadow[0x7C + i] != g_frame[0x7C + i]) { ui_raise_w1(0x1000); g_shadow[0x7C + i] = g_frame[0x7C + i]; }
    }
    if (g_shadow[9] != g_frame[9]) g_shadow[9] = g_frame[9];   /* no event */
    ui_flush_blink_events();
}

/* FFEE8A1B-FFEE8A44  size 41  scr06_draw_all  (sub_FFEE8A1B)  Confirmed. */
static void scr06_draw_all(void)
{
    g_redraw_8D79 = 0;
    ui_restore_background(0, 0);
    ui_draw_status_bar();
    ui_set_screen_type_override(3);      /* draw operating area as single row */
    scr06_draw_operating_area();
    ui_set_screen_type_override(0xFF);
    scr06_draw_12_slots();
}

/* FFEE8A44-FFEE8A8A  size 70  scr06_draw_operating_area  (sub_FFEE8A44)
 * Callers: scr06_draw_all, ev_main_area_redraw (F1 sub 6).  Draws the part of
 * the operating display visible behind the grid.  Inferred (callee roles). */
void scr06_draw_operating_area(void)
{
    u8 *rec = ui_current_record();
    if (rec[0] == 2) {
        opd_multislot();
        opd_FFEF5E38();
    } else {
        opd_FFEF4FCE();
        opd_FFEF5202();
        opd_multislot();
        opd_FFEF5E38();
        if (op_single_row_q() != 1) { opd_FFEF5518(); opd_FFEF59E4(); }
    }
    opd_FFEF6023();
    opd_FFEF637D();
}

/* FFEE8A8A-FFEE8AA5  size 27  scr06_draw_12_slots  (sub_FFEE8A8A)  Confirmed. */
static void scr06_draw_12_slots(void)
{
    u8 i;
    for (i = 0; i < 12; i++) ui_draw_icon_slot(i);
}

/* ============================================================================
 * SCREEN 0x11  (IPC F111, GPS information: sky plot, SNR bars, date/time,
 * lat/lon, speed, altitude).  doc 103/122: [A9F9]=1 status/GPS-info display;
 * this lane confirms F111 is the GPS page.
 *   step table   off_FFED51A4 = { FFEE8ADD, FFEE8AEF, FFEE8C67, FFEE8DF3 }
 *   event table  off_FFED51B4[0..0x34]: 0 restart, 1 frame, 2 clear,
 *     0x2F skyplot, 0x30 SNR bars, 0x31 date/time, 0x32 lat/lon,
 *     0x33 speed, 0x34 altitude
 * ========================================================================== */

/* FFEE8AA5-FFEE8ADD  size 56  scr11_gps_info_handler  (sub_FFEE8AA5)
 * off_FFED4050[0x11].  Acts only while the pending frame is an F1xx frame.
 * Confirmed. */
extern step_fn off_FFED51A4[4];
void scr11_gps_info_handler(void)
{
    if (g_frame[0] != 0xF1) return;
    if (g_ui_step <= 3) off_FFED51A4[g_ui_step]();
    else                g_ui_step = 3;
}

/* FFEE8ADD-FFEE8AEF  size 18  scr11_step0_sync  (sub_FFEE8ADD)  Confirmed. */
void scr11_step0_sync(void) { scr11_sync(1); g_ui_step++; }

/* FFEE8AEF-FFEE8C67  size 376  scr11_step1_frame  (sub_FFEE8AEF)
 * Also event 1.  Static parts: sky-plot circle in four 60x60 quadrant bitmaps
 * at (2..122, 30..150), the north marker, the SNR graph axes and 14 baseline
 * ticks, and the four data panels.  Confirmed. */
void scr11_step1_frame(void)
{
    u16 x, y; u8 i;
    lcd_init_fullscreen_surface();
    ui_draw_header_bar();
    x = 2; y = 0x1E;
    lcd_blit(x + 0x3C, y,        stru_FFED23CC);
    lcd_blit(x + 0x3C, y + 0x3C, stru_FFED303C);
    lcd_blit(x,        y + 0x3C, stru_FFED305C);
    lcd_blit(x,        y,        stru_FFED307C);
    x = 0x33; y = 0x14;
    lcd_draw_icon(x, y, 0, stru_FFED236C);
    lcd_blit(x, y, stru_FFED236C);
    lcd_fill_rect(0x7F,  0x1C, 1, 0x5B, RGB_WHITE);   /* SNR graph left axis  */
    lcd_fill_rect(0x13D, 0x1C, 1, 0x5B, RGB_WHITE);   /* right axis           */
    for (x = 0x80, y = 0x1C, i = 0; i < 4; i++, y += 0x1E) {
        lcd_fill_rect(x,        y, 2, 1, RGB_WHITE);  /* scale ticks          */
        lcd_fill_rect(x + 0xBB, y, 2, 1, RGB_WHITE);
    }
    for (x = 0x85, y = 0x76, i = 0; i < 14; i++, x += 0x0D)
        lcd_fill_rect(x, y, 10, 1, RGB_WHITE);        /* bar baselines        */
    lcd_draw_panel(2,    0x9A, 0x74, 0x34);           /* date/time            */
    lcd_draw_panel(0x7C, 0x9A, 0xC2, 0x34);           /* lat/lon              */
    lcd_draw_panel(2,    0xD2, 0x74, 0x1C);           /* speed                */
    lcd_draw_panel(0x7C, 0xD2, 0xC2, 0x1C);           /* altitude             */
    g_ui_step++;
}

/* FFEE8C67-FFEE8C94  size 45  scr11_step2_full_draw  (sub_FFEE8C67)  Confirmed. */
void scr11_step2_full_draw(void)
{
    if (lcd_begin_region(&g_lcd_surf, 0, 0, 0x140, 0xF0) == 1) {
        scr11_draw_all();
        lcd_commit_region_and_step();
    }
}

/* FFEE8C94-FFEE8CC7  size 51  scr11_ev2F_skyplot  (sub_FFEE8C94)  Confirmed. */
void scr11_ev2F_skyplot(void)
{
    if (lcd_begin_region(&g_lcd_surf, 0, 0x14, 0x7D, 0x9B) == 1) {
        gps_draw_skyplot(2, 0x1E);
        lcd_commit_region_and_step();
    }
}

/* FFEE8CC7-FFEE8CFC  size 53  scr11_ev30_snr_bars  (sub_FFEE8CC7)  Confirmed. */
void scr11_ev30_snr_bars(void)
{
    if (lcd_begin_region(&g_lcd_surf, 0x7D, 0x14, 0xC3, 0x84) == 1) {
        gps_draw_snr_bars(0x7D, 0x14);
        lcd_commit_region_and_step();
    }
}

/* FFEE8CFC-FFEE8D38  size 60  scr11_ev31_datetime  (sub_FFEE8CFC)
 * shadow[0x70] = time-zone index (26 = UTC).  Confirmed. */
void scr11_ev31_datetime(void)
{
    if (lcd_begin_region(&g_lcd_surf, 2, 0x9A, 0x74, 0x37) == 1) {
        gps_draw_datetime_box(2, 0x9A, g_shadow[0x70]);
        lcd_commit_region_and_step();
    }
}

/* FFEE8D38-FFEE8D79  size 65  scr11_ev32_latlon  (sub_FFEE8D38)
 * shadow[0x6C] = show mode (0 off, 1 on, 2 blink), shadow[0x6D] = format
 * (0 = dd mm'ss", else dd mm.mmm').  Confirmed. */
void scr11_ev32_latlon(void)
{
    if (lcd_begin_region(&g_lcd_surf, 0x7C, 0x9A, 0xC2, 0x34) == 1) {
        gps_draw_latlon_box(0x7C, 0x9A, g_shadow[0x6C], g_shadow[0x6D]);
        lcd_commit_region_and_step();
    }
}

/* FFEE8D79-FFEE8DB5  size 60  scr11_ev33_speed  (sub_FFEE8D79)
 * shadow[0x6E] = speed unit (1 knot, 2 mph, else km/h).  Confirmed. */
void scr11_ev33_speed(void)
{
    if (lcd_begin_region(&g_lcd_surf, 2, 0xD2, 0x74, 0x1C) == 1) {
        gps_draw_speed_box(2, 0xD2, g_shadow[0x6E]);
        lcd_commit_region_and_step();
    }
}

/* FFEE8DB5-FFEE8DF3  size 62  scr11_ev34_altitude  (sub_FFEE8DB5)
 * shadow[0x6F] = altitude unit (1 = ft, else m).  Confirmed. */
void scr11_ev34_altitude(void)
{
    if (lcd_begin_region(&g_lcd_surf, 0x7C, 0xD2, 0xC2, 0x1C) == 1) {
        gps_draw_altitude_box(0x7C, 0xD2, g_shadow[0x6F]);
        lcd_commit_region_and_step();
    }
}

/* FFEE8DF3-FFEE8E79  size 134  scr11_step3_events  (sub_FFEE8DF3)  Confirmed. */
extern event_fn off_FFED51B4[0x35];
void scr11_step3_events(void)
{
    g_cur_event = ui_next_event();
    if (g_cur_event == 0xFF) scr11_sync(0);
    if (g_cur_event != 0xFF && g_cur_event <= 0x34 && !lcd_queue_busy()) {
        ui_clear_event(g_cur_event);
        off_FFED51B4[g_cur_event]();
    }
    UI_CLAMP_STEP();
}

/* FFEE8E79-FFEE8E95  size 28  scr11_sync  (sub_FFEE8E79)  Confirmed. */
static void scr11_sync(u8 full)
{
    ipc_sync_opcode();
    scr11_reconcile_fields();
    ipc_sync_hdr13();
    if (full == 1) ui_clear_all_events();
}

/* FFEE8E95-FFEE9013  size 382  scr11_reconcile_fields  (sub_FFEE8E95)
 * Shadow fields 0x6C..0x70 of the GPS page, then polls the GPS parser data
 * (scr11_poll_gps_data).  A change of the layout bit shadow[9].4 restarts the
 * screen (event 0).  Confirmed. */
static void scr11_reconcile_fields(void)
{
    ipc_sync_common_header();
    if (((g_shadow[9] & 0x10) >> 4) != ((g_frame[9] & 0x10) >> 4)) ui_raise_w0(1);
    g_rec_ptr = &g_shadow[0x20];
    ipc_sync_record_block(&g_shadow[0x20], &g_frame[0x20], 3);
    if (g_shadow[0x6C] != g_frame[0x6C]) {               /* lat/lon show mode */
        if (g_frame[0x6C] == 2)       ui_blink_enable (0x40000, 0);
        else if (g_shadow[0x6C] == 2) ui_blink_disable(0x40000, 0);
        ui_raise_w1(0x40000);
        g_shadow[0x6C] = g_frame[0x6C];
    }
    if (g_shadow[0x6D] != g_frame[0x6D]) { ui_raise_w1(0x40000);  g_shadow[0x6D] = g_frame[0x6D]; }
    if (g_shadow[0x6E] != g_frame[0x6E]) { ui_raise_w1(0x80000);  g_shadow[0x6E] = g_frame[0x6E]; }
    if (g_shadow[0x6F] != g_frame[0x6F]) { ui_raise_w1(0x100000); g_shadow[0x6F] = g_frame[0x6F]; }
    copy_raise_w1(&g_shadow[0x70], &g_frame[0x70], 1, 0x20000);  /* time zone */
    scr11_poll_gps_data();
    if (g_shadow[9] != g_frame[9]) g_shadow[9] = g_frame[9];
    ui_flush_blink_events();
}

/* FFEE9013-FFEE9212  size 511  scr11_poll_gps_data  (sub_FFEE9013)
 * Pulls the current GPS fix from the parser's table at 0x1CC90 (getters
 * FFEDF904..FFEDFA32, doc 14 sec.3) into the screen cache g_gps and raises
 * the event of every panel whose data changed.  The satellite list is
 * compared record by record; any difference copies all 218 bytes and raises
 * both the sky plot (0x8000) and SNR bar (0x10000) events.  Confirmed. */
static void scr11_poll_gps_data(void)
{
    u8 date[3], tim[3], pos[10], mot[8], alt[8], sats[0xDA];
    u8 i, unused_5;
    gps_get_date(date);
    gps_get_time(tim);
    gps_get_position(pos);
    gps_get_motion(mot);
    gps_get_altitude(alt);
    gps_get_satellites(sats);
    copy_raise_w1(&g_gps[0], date, 3, 0x20000);           /* -> event 0x31 */
    unused_5 = 0;                                          /* dead store, FFEE905B */
    copy_raise_w1(&g_gps[3], tim, 3, 0x20000);
    copy_raise_w1(&g_gps[6], pos, 10, 0x40000);            /* -> event 0x32 */
    if (*(u16 *)&g_gps[0x10] != *(u16 *)&mot[0]) { ui_raise_w1(0x8000);  *(u16 *)&g_gps[0x10] = *(u16 *)&mot[0]; }
    if (*(u16 *)&g_gps[0x12] != *(u16 *)&mot[2]) { ui_raise_w1(0x80000); *(u16 *)&g_gps[0x12] = *(u16 *)&mot[2]; }
    copy_raise_w1(&g_gps[0x18], alt, 8, 0x100000);         /* -> event 0x34 */
    if (g_gps[0x30] != sats[0]) goto changed;
    for (i = 0; i < 36; i++) {
        const u8 *c = &g_gps[0x30 + i * 6], *n = &sats[i * 6];
        if (c[2] != n[2] || c[3] != n[3] || *(u16 *)&c[4] != *(u16 *)&n[4] ||
            c[6] != n[6] || c[7] != n[7])
            goto changed;
    }
    return;
changed:
    copy_raise_w1(&g_gps[0x30], sats, 0xDA, 0x8000);
    ui_raise_w1(0x10000);
    (void)unused_5;
}

/* FFEE9212-FFEE9282  size 112  scr11_draw_all  (sub_FFEE9212)  Confirmed. */
static void scr11_draw_all(void)
{
    g_redraw_8D79 = 0;
    ui_restore_background(0, 0);
    ui_draw_status_bar();
    gps_draw_skyplot(2, 0x1E);
    gps_draw_snr_bars(0x7D, 0x14);
    gps_draw_datetime_box(2, 0x9A, g_shadow[0x70]);
    gps_draw_latlon_box(0x7C, 0x9A, g_shadow[0x6C], g_shadow[0x6D]);
    gps_draw_speed_box(2, 0xD2, g_shadow[0x6E]);
    gps_draw_altitude_box(0x7C, 0xD2, g_shadow[0x6F]);
}
