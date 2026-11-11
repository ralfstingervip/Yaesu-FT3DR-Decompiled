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

/* ============================================================================
 * GPS page drawing helpers (screen 0x11)
 * ========================================================================== */

/* FFEE9282-FFEE9477  size 501  gps_draw_datetime_box  (sub_FFEE9282)
 * Callers: scr11_ev31_datetime, scr11_draw_all.  Panel at (x,y) 0x74x0x34:
 * line 1 "HH:MM AM" (12-hour clock), line 2 "Mmm DD".  The UTC fix time is
 * shifted by the time-zone menu value tz (half-hour steps, 26 = UTC) with a
 * date carry.  Nothing but the cleared panel is drawn until year, month,
 * day, hour and minute are all valid (!= 0xFF).  Confirmed. */
static void gps_draw_datetime_box(u16 x, u16 y, u8 tz)
{
    char date_s[8], time_s[8];        /* templates "       " FFF485A8, "  :    " FFF485B0 */
    u8 hm[2], ymd[3], i;
    memcpy_(date_s, "       ", 8);
    memcpy_(time_s, "  :    ", 8);
    lcd_clear_rect(x, y, 0x74, 0x34);
    if (g_gps[0] != 0xFF && g_gps[1] != 0xFF && g_gps[2] != 0xFF &&
        g_gps[3] != 0xFF && g_gps[4] != 0xFF) {
        memcpy_(hm,  &g_gps[3], 2);
        memcpy_(ymd, &g_gps[0], 3);
        gps_apply_timezone(tz, hm, ymd);
        if (ymd[1] <= 12 && ymd[1] > 0)                        /* month name */
            for (i = 0; i < 3; i++) date_s[i] = k_month_abbr[ymd[1] * 4 + i - 4];
        if (ymd[2] <= 9)          date_s[5] = '0';
        else if (ymd[2] <= 0x1F)  date_s[5] = '0' + ymd[2] / 10;
        date_s[6] = '0' | (ymd[2] % 10);
        if (hm[0] <= 23) {                                     /* 12-hour */
            if (hm[0] <= 11) fmt_dec2(&time_s[0], hm[0]);
            else             fmt_dec2(&time_s[0], hm[0] - 12); /* 12:xx shows 00 */
        }
        if (hm[1] <= 59) fmt_dec2(&time_s[3], hm[1]);
        time_s[5] = (hm[0] <= 11) ? 'A' : 'P';
        time_s[6] = 'M';
    }
    lcd_draw_text(x + 0x0D, y + 5,    1, time_s, 7, RGB_WHITE);
    lcd_draw_text(x + 0x0D, y + 0x1D, 1, date_s, 7, RGB_WHITE);
}

/* FFEE9477-FFEE956A  size 243  gps_bcd_frac_to_ascii  (sub_FFEE9477)
 * Writes the minute fraction of a coordinate.  fmt==1: the top three BCD
 * nibbles as ".mmm" digits (stops at an 0xF nibble).  fmt!=1: converts the
 * 4-digit BCD minute fraction to seconds (value*6/10) and writes two digits.
 * Note "mul [sp].uw" multiplies by the running place value 1,10,100,1000.
 * Confirmed. */
static void gps_bcd_frac_to_ascii(u16 bcd, char *out, u8 fmt)
{
    u8 shift, n, i; u16 val, place;
    if (fmt == 1) {
        for (shift = 12, i = 0; i < 3; i++) {
            n = (bcd >> shift) & 0x0F;  shift -= 4;
            if (n == 0x0F) return;
            out[i] = hex_digit_char(n);
        }
        return;
    }
    n = 0; val = 0; place = 1;
    for (i = 0; i < 4; i++) {
        if ((bcd & 0x0F) != 0x0F) { n++; val = (u16)(val + (bcd & 0x0F) * place); }
        bcd >>= 4;  place *= 10;
    }
    if (n == 0) return;
    val = (u16)(val * 6) / 10;                 /* fraction of a minute -> seconds*100 */
    *out++ = hex_digit_char(val / 1000);  val %= 1000;
    *out++ = hex_digit_char((u8)(val / 100)); val %= 100;   /* last remainder unused */
}

/* FFEE956A-FFEE97B0  size 582  gps_draw_latlon_box  (sub_FFEE956A)
 * Panel at (x,y) 0xC2x0x34.  Two 13-char lines built from templates
 * "N    \x06  .    " / "E    \x06  .    " (\x06 = degree glyph, Inferred):
 * degrees, minutes, then seconds (fmt 0, ' and " marks) or decimal minutes
 * (fmt !=0, '.' and ').  Hemisphere letters from g_gps[6].  show: 0 hidden,
 * 1 shown, 2 blinking.  Confirmed. */
static void gps_draw_latlon_box(u16 x, u16 y, u8 show, u8 fmt)
{
    char lat[14], lon[14]; u8 vis = 0;
    memcpy_(lat, "N    \x06  .    ", 14);
    memcpy_(lon, "E    \x06  .    ", 14);
    lcd_clear_rect(x, y, 0xC2, 0x34);
    if (g_gps[7]  != 0xFF && g_gps[7]  <= 90)   fmt_dec2(&lat[3], g_gps[7]);
    if (g_gps[8]  != 0xFF && g_gps[8]  <= 59)   fmt_dec2(&lat[6], g_gps[8]);
    if (*(u16 *)&g_gps[0xC] != 0xFFFF && *(u16 *)&g_gps[0xC] <= 0x9999)
        gps_bcd_frac_to_ascii(*(u16 *)&g_gps[0xC], &lat[9], fmt);
    if (g_gps[9]  != 0xFF && g_gps[9]  <= 0xB3) fmt_dec3_blank(&lon[2], g_gps[9]);
    if (g_gps[10] != 0xFF && g_gps[10] <= 59)   fmt_dec2(&lon[6], g_gps[10]);
    if (*(u16 *)&g_gps[0xE] != 0xFFFF && *(u16 *)&g_gps[0xE] <= 0x9999)
        gps_bcd_frac_to_ascii(*(u16 *)&g_gps[0xE], &lon[9], fmt);
    if (fmt == 0) { lat[8] = '\''; lat[0xB] = '"';  lon[8] = '\''; lon[0xB] = '"'; }
    else          { lat[8] = '.';  lat[0xC] = '\''; lon[8] = '.';  lon[0xC] = '\''; }
    switch (g_gps[6]) {
    case 0: lat[0] = 'N'; lon[0] = 'E'; break;
    case 1: lat[0] = 'N'; lon[0] = 'W'; break;
    case 2: lat[0] = 'S'; lon[0] = 'E'; break;
    case 3: lat[0] = 'S'; lon[0] = 'W'; break;
    }
    if (show == 0) vis = 0; else if (show == 1) vis = 1; else if (show == 2) vis = ui_blink_phase();
    if (vis == 1) {
        lcd_draw_text(x + 0x0D, y + 5,    1, lat, 0x0D, RGB_WHITE);
        lcd_draw_text(x + 0x0D, y + 0x1D, 1, lon, 0x0D, RGB_WHITE);
    }
}

/* FFEE97B0-FFEE993E  size 398  gps_draw_speed_box  (sub_FFEE97B0)
 * Panel (x,y) 0x74x0x1C.  Speed word g_gps[0x12] is BCD in 0.1 knot:
 * knot = v/10, mph = v*11507/100000, km/h = v*1852/10000 (exact nautical
 * conversions).  Four digits with leading-zero blanking + unit.  Confirmed. */
static void gps_draw_speed_box(u16 x, u16 y, u8 unit)
{
    char s[9]; u32 v; u8 i;
    memcpy_(s, "    knot", 8); s[8] = 0;
    lcd_clear_rect(x, y, 0x74, 0x1C);
    if (unit == 1)      memcpy_(&s[4], "knot", 4);
    else if (unit == 2) memcpy_(&s[4], "mph ", 4);
    else                memcpy_(&s[4], "km/h", 4);
    if (*(u16 *)&g_gps[0x12] != 0xFFFF) {
        u16 b = *(u16 *)&g_gps[0x12];
        v = (b >> 12) * 1000 + ((b & 0xF00) >> 8) * 100 + ((b & 0xF0) >> 4) * 10 + (b & 0xF);
        if (unit == 1)      v = v / 10;
        else if (unit == 2) v = v * 0x2CF3 / 100000;
        else                v = v * 0x73C / 10000;
        s[0] = '0' + v / 1000; v %= 1000;
        s[1] = '0' + v / 100;  v %= 100;
        s[2] = '0' + v / 10;   v %= 10;
        s[3] = '0' + v;
        for (i = 0; i < 3 && s[i] == '0'; i++) s[i] = ' ';
    }
    lcd_draw_text(x, y + 5, 1, s, 8, RGB_WHITE);
}

/* FFEE993E-FFEE9A8E  size 336  gps_draw_altitude_box  (sub_FFEE993E; IDA's
 * lane-4 head sub_FFEE9A71 is the shared draw tail)
 * Panel (x,y) 0xC2x0x1C, text "ALTI nnnnn m " or "ALTI nnnnn ft".  Feet are
 * computed in IEEE double: alt / 0.3048 (constant 0x3FD381D7_DBF487FD) via the
 * CC-RX runtime.  g_gps[0x1D]==1 puts a '-' before the first digit; "-0"
 * collapses to " 0".  NOTE: the text position is hard-coded (0x89,0xD7), not
 * derived from x,y.  Confirmed. */
static void gps_draw_altitude_box(u16 x, u16 y, u8 unit)
{
    char s[14]; u16 a; u8 i;
    memcpy_(s, "ALTI       m ", 14);
    lcd_clear_rect(x, y, 0xC2, 0x1C);
    if (unit == 1) { s[0xB] = 'f'; s[0xC] = 't'; }
    a = *(u16 *)&g_gps[0x1E];
    if (a != 0xFFFF) {
        if (unit == 1) a = double_to_u16(double_div(u16_to_double(a), 0.3048));
        s[6]  = '0' | (a / 10000);  a %= 10000;
        s[7]  = '0' + a / 1000;     a %= 1000;
        s[8]  = '0' + a / 100;      a %= 100;
        s[9]  = '0' + a / 10;       a %= 10;
        s[10] = '0' + a;
        for (i = 0; i < 4 && s[6 + i] == '0'; i++) s[6 + i] = ' ';
        if (g_gps[0x1D] == 1) s[5 + i] = '-';
        if (s[10] == '0' && s[9] == '-') s[9] = ' ';
    }
    lcd_draw_text(0x89, 0xD7, 1, s, 0x0D, RGB_WHITE);
}

/* FFEE9A8E-FFEE9DA5  size 791  gps_draw_snr_bars  (sub_FFEE9A8E)
 * SNR bar graph right of the sky plot: up to 14 satellites, scanned in
 * ascending PRN order (outer loop prn 0..254, inner loop over the 36
 * records).  Bar height = 3*min(snr/2,25) px (snr >= 100 -> 0 = invalid),
 * blue 0x041F if used in the fix else grey 0x7BEF, second colour 0xC73F.
 * Two-character label under each bar: PRN 33..64 -> "AS", 193 -> "QZ"
 * (QZSS), else two digits.  QUIRK: for a blank label character the icon call
 * still runs with mode 0 and the previous glyph pointer.  Confirmed. */
static void gps_draw_snr_bars(u16 x, u16 y)
{
    const u8 x0 = 0x87, ybase = 0x76, lx1 = 0x86, ly1 = 0x7B, lx2 = 0x86, ly2 = 0x88;
    u8 n, drawn = 0, prn, i, k, h, mode; u16 col = 0;
    const void *glyph = 0; char lab[3];
    n = (g_gps[0x30] <= 0x0D) ? g_gps[0x30] : 0x0E;
    lcd_clear_rect(x, y, 0x140 - x, 0x98 - y);
    if (g_gps[0x30] == 0 || g_gps[0x30] == 0xFF) return;
    for (prn = 0; prn < 0xFF; prn++) {
        for (i = 0; i < 36; i++) {
            const u8 *r = &g_gps[0x32 + i * 6];   /* prn, elev, az.w, snr, used */
            if (r[0] != prn) continue;
            memcpy_(lab, "  ", 3);                /* asc_FFF485EB */
            h = (r[4] >= 100) ? 0 : (r[4] >= 0x31) ? 0x19 : (r[4] >> 1);
            h *= 3;
            if (r[5] == 0) lcd_fill_rect2(x0 + col, ybase - h, 6, h, RGB_GREY, 0xC73F);
            else           lcd_fill_rect2(x0 + col, ybase - h, 6, h, 0x041F,  0xC73F);
            if (r[0] >= 0x21 && r[0] <= 0x40) { lab[0] = 'A'; lab[1] = 'S'; }
            else if (r[0] == 0xC1)            { lab[0] = 'Q'; lab[1] = 'Z'; }
            else fmt_dec2(lab, r[0]);
            for (k = 0; k < 2; k++) {
                mode = 1;
                switch (lab[k]) {
                case '0': case '1': case '2': case '3': case '4':
                case '5': case '6': case '7': case '8': case '9':
                          glyph = k_prn_glyph[lab[k] - '0']; break;   /* FFED24BC + 0x10*d */
                case 'A': glyph = stru_FFED336C; break;
                case 'S': glyph = stru_FFED338C; break;
                case 'Q': glyph = stru_FFED337C; break;
                case 'Z': glyph = stru_FFED339C; break;
                default:  mode = 0; break;
                }
                if (k == 0) lcd_draw_icon(lx1 + col, ly1, mode, glyph);
                else        lcd_draw_icon(lx2 + col, ly2, mode, glyph);
            }
            col += 0x0D;
            if (++drawn >= n) return;
        }
    }
}

/* FFEE9DA5-FFEE9E2D  size 136  gps_azimuth_sector  (sub_FFEE9DA5)
 * BCD azimuth -> compass sector.  The value wraps at 3600 (so 0.1-degree
 * units, Inferred).  mode 0x20: 32 sectors of 11.25 deg (centred), else 16
 * sectors of 22.5 deg.  0xFFFF counts as 0.  Confirmed (arithmetic). */
static u8 gps_azimuth_sector(u16 az_bcd, u8 mode)
{
    u32 a = (az_bcd == 0xFFFF) ? 0 : bcd4_to_bin(az_bcd);
    while (a > 0xE0F) a -= 0xE10;
    a *= 20;
    if (mode == 0x20) { a += 0x465; if (a >= 72000) a -= 72000; return (u8)(a / 0x8CA); }
    a += 0x8CA; if (a >= 72000) a -= 72000; return (u8)(a / 0x1194);
}

/* FFEE9E2D-FFEE9F83  size 342  gps_draw_skyplot  (sub_FFEE9E2D)
 * Places one marker per satellite on the sky-plot circle: position from the
 * flash table k_skyplot_xy[sector 0..31][ring 0..9], ring = elevation tens
 * (elev <5 or >90 -> ring 0, >=85 -> ring 9).  Filled marker FFED333C when
 * used in the fix, hollow FFED334C otherwise.  Confirmed. */
static void gps_draw_skyplot(u16 x, u16 y)
{
    u8 i, sec, ring, e;
    lcd_clear_rect(x, y, 0x7D - x, 0x96 - y);
    if (g_gps[0x30] == 0 || g_gps[0x30] == 0xFF) return;
    for (i = 0; i < 36; i++) {
        const u8 *r = &g_gps[0x32 + i * 6];
        if (r[0] == 0xFF) continue;
        sec = gps_azimuth_sector(*(u16 *)&r[2], 0x20);
        e = r[1];
        if (e < 5 || e >= 0x5B) ring = 0;
        else if (e >= 0x55)     ring = 9;
        else                    ring = (u8)((s32)(e + 5) / 10);
        lcd_draw_icon(k_skyplot_xy[sec][ring * 2], k_skyplot_xy[sec][ring * 2 + 1], 1,
                      r[5] ? stru_FFED333C : stru_FFED334C);
    }
}

/* FFEE9F83-FFEE9FDB  size 88  gps_apply_timezone  (sub_FFEE9F83)
 * tz is the TIME ZONE menu index: 26 = UTC, each step = 30 minutes (so
 * 0..51 covers -13:00..+12:30).  Shifts hh:mm and steps the date on carry
 * (only if the year byte is valid).  Confirmed. */
static void gps_apply_timezone(u8 tz, u8 *hm, u8 *ymd)
{
    u8 east = (tz >= 0x1A), n, carry;
    n = east ? (u8)(tz - 0x1A) : (u8)(0x1A - tz);
    if (n == 0) return;
    carry = gps_shift_time_halfhours(east, n, hm);
    if (ymd[0] != 0xFF) gps_step_date(carry, ymd);
}

/* FFEE9FDB-FFEEA0A3  size 200  gps_shift_time_halfhours  (sub_FFEE9FDB)
 * Adds (east) or subtracts n half-hours from hm = {hour, minute}.
 * Returns 1 = next day, 2 = previous day, 0 = same day.  Confirmed. */
static u8 gps_shift_time_halfhours(u8 east, u8 n, u8 *hm)
{
    u8 ret = 0, odd = n & 1;
    if (east) {
        if (odd) { hm[1] += 0x1E; if (hm[1] >= 0x3C) { hm[1] -= 0x3C; n += 2; } }
        n >>= 1;
        hm[0] += n;
        if (hm[0] >= 0x18) { hm[0] -= 0x18; ret = 1; }
    } else {
        if (odd) { if (hm[1] <= 0x1D) { hm[1] += 0x3C; n += 2; } hm[1] -= 0x1E; }
        n >>= 1;
        if (hm[0] < n) { hm[0] += 0x18; ret = 2; }
        hm[0] -= n;
    }
    return ret;
}

/* FFEEA0A3-FFEEA189  size 230  gps_step_date  (sub_FFEEA0A3)
 * ymd = {yy, mm, dd}.  dir 1 = +1 day, 2 = -1 day, else nothing.
 * Uses k_days_in_month (FFC3D649) and is_leap_yy.  Confirmed. */
static void gps_step_date(u8 dir, u8 *ymd)
{
    if (dir == 1) {
        ymd[2]++;
        if (ymd[2] <= k_days_in_month[ymd[1]]) return;
        if (ymd[1] == 2) {
            if (!is_leap_yy(ymd[0])) { ymd[1] = 3; ymd[2] = 1; return; }
            if (ymd[2] == 0x1E)      { ymd[1] = 3; ymd[2] = 1; }
            return;                                   /* Feb 29 in a leap year */
        }
        ymd[1]++; ymd[2] = 1;
        if (ymd[1] == 0x0D) { ymd[1] = 1; ymd[0]++; }
    } else if (dir == 2) {
        ymd[2]--;
        if (ymd[2] != 0) return;
        ymd[1]--;
        if (ymd[1] == 0) { ymd[1] = 0x0C; ymd[0]--; }
        ymd[2] = k_days_in_month[ymd[1]];
        if (ymd[1] == 2 && is_leap_yy(ymd[0])) ymd[2] = 0x1D;
    }
}

/* FFEEA189-FFEEA1AE  size 37  is_leap_yy  (sub_FFEEA189)
 * Two-digit year leap test.  QUIRK: yy == 0 (2000, a leap year) returns 0.
 * Confirmed. */
static u8 is_leap_yy(u8 yy)
{
    if (yy == 0) return 0;
    return (yy & 3) == 0;
}

/* ============================================================================
 * SCREEN 0x08  (IPC F108, and the SUB-only F109/F10A; also F280 from the F2
 * classifier).  A 16-character text-entry line with a blinking block cursor
 * across the top 32 px, and 20 icon slots below.  F280 (shadow[1]==0x80) is
 * a variant whose line is drawn by FFEF1B23 from shadow[0x21..0x30] with the
 * cursor at shadow[0x20]; F108 uses shadow[0x6C] cursor, shadow[0x6D:0x6E]
 * double-width mask and shadow[0x6F..0x7E] text.  Inferred purpose
 * ("entry line": cursor + per-character width mask), Confirmed mechanics.
 *   step table   off_FFED5288 = { FFEEA1D8, FFEEA1EA, FFEEA205, FFEEA2D7 }
 *   event table  off_FFED5298[0..0x36]: 0 restart, 1 frame, 2 clear,
 *     0x20..0x33 FFEF23EE icon slots, 0x34 FFEEA298 slots, 0x35 FFEEA232
 *     entry line, 0x36 FFEEA265 entry line (F280)
 * ========================================================================== */

static void scr08_sync(u8 full); static void scr08_reconcile_fields(void);
static void scr08_draw_all(void); static void scr08_draw_entry_line(u16 x, u16 y);
static void scr08_draw_entry_line_f280(u16 x, u16 y); static void scr08_draw_20_slots(void);

/* FFEEA1AE-FFEEA1D8  size 42  scr08_text_entry_handler  (sub_FFEEA1AE)
 * off_FFED4050[8], [9], [10].  Confirmed. */
extern step_fn off_FFED5288[4];
void scr08_text_entry_handler(void)
{
    if (g_ui_step <= 3) off_FFED5288[g_ui_step]();
    else                g_ui_step = 3;
}

/* FFEEA1D8-FFEEA1EA  size 18  scr08_step0_sync  (sub_FFEEA1D8)  Confirmed. */
void scr08_step0_sync(void) { scr08_sync(1); g_ui_step++; }

/* FFEEA1EA-FFEEA205  size 27  scr08_step1_frame  (sub_FFEEA1EA; merged
 * lane-4 head sub_FFEEA1F8).  Also event 1.  Confirmed. */
void scr08_step1_frame(void)
{
    lcd_init_fullscreen_surface();
    ui_draw_header_bar_alt();
    ui_draw_title(2);
    g_ui_step++;
}

/* FFEEA205-FFEEA232  size 45  scr08_step2_full_draw  (sub_FFEEA205)  Confirmed. */
void scr08_step2_full_draw(void)
{
    if (lcd_begin_region(&g_lcd_surf, 0, 0, 0x140, 0xF0) == 1) {
        scr08_draw_all();
        lcd_commit_region_and_step();
    }
}

/* FFEEA232-FFEEA265  size 51  scr08_ev35_entry_line  (sub_FFEEA232)  Confirmed. */
void scr08_ev35_entry_line(void)
{
    if (lcd_begin_region(&g_lcd_surf, 0, 0, 0x140, 0x20) == 1) {
        scr08_draw_entry_line(0x30, 3);
        lcd_commit_region_and_step();
    }
}

/* FFEEA265-FFEEA298  size 51  scr08_ev36_entry_line_f280  (sub_FFEEA265)  Confirmed. */
void scr08_ev36_entry_line_f280(void)
{
    if (lcd_begin_region(&g_lcd_surf, 0, 0, 0x140, 0x20) == 1) {
        scr08_draw_entry_line_f280(0x30, 3);
        lcd_commit_region_and_step();
    }
}

/* FFEEA298-FFEEA2D7  size 63  scr08_ev34_slots  (sub_FFEEA298)  Confirmed. */
void scr08_ev34_slots(void)
{
    if (lcd_begin_region(&g_lcd_surf, 0, 0x20, 0x140, 0xD0) == 1) {
        lcd_clear_rect(0, 0x20, 0x140, 0xD0);
        scr08_draw_20_slots();
        lcd_commit_region_and_step();
    }
}

/* FFEEA2D7-FFEEA35D  size 134  scr08_step3_events  (sub_FFEEA2D7)  Confirmed. */
extern event_fn off_FFED5298[0x37];
void scr08_step3_events(void)
{
    g_cur_event = ui_next_event();
    if (g_cur_event == 0xFF) scr08_sync(0);
    if (g_cur_event != 0xFF && g_cur_event <= 0x36 && !lcd_queue_busy()) {
        ui_clear_event(g_cur_event);
        off_FFED5298[g_cur_event]();
    }
    UI_CLAMP_STEP();
}

/* FFEEA35D-FFEEA379  size 28  scr08_sync  (sub_FFEEA35D)  Confirmed. */
static void scr08_sync(u8 full)
{
    ipc_sync_opcode();
    scr08_reconcile_fields();
    ipc_sync_hdr13();
    if (full == 1) ui_clear_all_events();
}

/* FFEEA379-FFEEA67E  size 773  scr08_reconcile_fields  (sub_FFEEA379; IDA
 * lane-4 heads sub_FFEEA38D and the out-of-phase item FFEEA555 lie inside)
 * The first pass arms the cursor blink (0x8F74 latch).  Confirmed. */
static void scr08_reconcile_fields(void)
{
    u8 i;
    ipc_sync_common_header();
    if (g_frame[1] == 0x80) {                         /* F280 variant */
        g_rec_ptr = 0;
        if (g_blink_armed == 0) { ui_blink_enable(0x400000, 0); g_blink_armed = 1; }
        if (g_shadow[0x20] != g_frame[0x20]) { ui_raise_w1(0x400000); g_shadow[0x20] = g_frame[0x20]; }
        for (i = 0; i <= 0x0F; i++)
            if (g_shadow[0x21 + i] != g_frame[0x21 + i]) { ui_raise_w1(0x400000); g_shadow[0x21 + i] = g_frame[0x21 + i]; }
        for (i = 0; i < 0x14; i++) {
            if (g_shadow[0x31 + i] != g_frame[0x31 + i]) { ui_raise_w1(0x100000); g_shadow[0x31 + i] = g_frame[0x31 + i]; }
            if (g_shadow[0x45 + i] != g_frame[0x45 + i]) { ui_raise_w1(0x100000); g_shadow[0x45 + i] = g_frame[0x45 + i]; }
        }
    } else {                                          /* F108 / F109 / F10A */
        g_rec_ptr = &g_shadow[0x20];
        ipc_sync_record_block(&g_shadow[0x20], &g_frame[0x20], 3);
        if (g_blink_armed == 0) { ui_blink_enable(0x200000, 0); g_blink_armed = 1; }
        if (g_shadow[0x6C] != g_frame[0x6C]) { ui_raise_w1(0x200000); g_shadow[0x6C] = g_frame[0x6C]; }
        if (g_shadow[0x6D] != g_frame[0x6D] || g_shadow[0x6E] != g_frame[0x6E]) {
            ui_raise_w1(0x200000);
            g_shadow[0x6D] = g_frame[0x6D];
            g_shadow[0x6E] = g_frame[0x6E];
        }
        for (i = 0; i <= 0x0F; i++)
            if (g_shadow[0x6F + i] != g_frame[0x6F + i]) { ui_raise_w1(0x200000); g_shadow[0x6F + i] = g_frame[0x6F + i]; }
        for (i = 0; i < 0x14; i++) {
            if (g_shadow[0x7F + i] != g_frame[0x7F + i]) { ui_raise_w1(0x100000); g_shadow[0x7F + i] = g_frame[0x7F + i]; }
            if (g_shadow[0x93 + i] != g_frame[0x93 + i]) { ui_raise_w1(0x100000); g_shadow[0x93 + i] = g_frame[0x93 + i]; }
        }
        if (g_shadow[9] != g_frame[9]) g_shadow[9] = g_frame[9];
    }
    ui_flush_blink_events();
}

/* FFEEA67E-FFEEA6B7  size 57  scr08_draw_all  (sub_FFEEA67E)  Confirmed. */
static void scr08_draw_all(void)
{
    u8 sub = g_shadow[1];
    g_redraw_8D79 = 0;
    ui_restore_background(0, 0);
    if (sub == 0x80) scr08_draw_entry_line_f280(0x30, 3);
    else             scr08_draw_entry_line(0x30, 3);
    scr08_draw_20_slots();
}

/* FFEEA6B7-FFEEA6B8  size 1  scr08_main_area_stub  (sub_FFEEA6B7)
 * A bare rts.  Called from ev_main_area_redraw for F1 subs 8..10, i.e. the
 * text-entry screen has no operating-area part.  Confirmed. */
void scr08_main_area_stub(void) { }

/* FFEEA6B8-FFEEA74D  size 149  scr08_draw_entry_line  (sub_FFEEA6B8)
 * Cursor index shadow[0x6C] (clamped to 15), 16-bit double-width mask
 * shadow[0x6D]:shadow[0x6E] (bit 15-i = char i is wide).  The cursor block is
 * 14 px per cell, 28 px when the cell holds a wide char, colour 0xF980, and
 * is drawn only in the "on" blink phase.  Confirmed. */
static void scr08_draw_entry_line(u16 x, u16 y)
{
    u8 cur = g_shadow[0x6C], w;
    u16 mask = (u16)((g_shadow[0x6D] << 8) | g_shadow[0x6E]);
    lcd_clear_rect(0, 0, 0x140, 0x20);
    if (ui_blink_phase() == 1) {
        if (cur > 0x0F) cur = 0x0F;
        w = (mask & (0x8000 >> cur)) ? 0x1C : 0x0E;
        lcd_fill_rect(x + cur * 0x0E, y, w, 0x1C, 0xF980);
    }
    lcd_draw_string_dw(x, y, mask, &g_shadow[0x6F]);
}

/* FFEEA74D-FFEEA7BF  size 114  scr08_draw_entry_line_f280  (sub_FFEEA74D)
 * F280 variant: cursor shadow[0x20], text shadow[0x21..0x30] (16 chars).
 * Confirmed. */
static void scr08_draw_entry_line_f280(u16 x, u16 y)
{
    u8 cur = g_shadow[0x20];
    lcd_clear_rect(0, 0, 0x140, 0x20);
    if (ui_blink_phase() == 1)
        lcd_fill_rect(x + cur * 0x0E, y, 0x0E, 0x1C, 0xF980);
    lcd_draw_text_ex(x, y, 0x0D, 0, 0x10, 1, &g_shadow[0x21]);
}

/* FFEEA7BF-FFEEA7DB  size 28  scr08_draw_20_slots  (sub_FFEEA7BF)  Confirmed. */
static void scr08_draw_20_slots(void)
{
    u8 i;
    for (i = 0; i < 0x14; i++) ui_draw_icon_slot(i);
}

/* ============================================================================
 * SCREEN 0x0F  (IPC F10F; doc 103: one of the F10D/F10F/F111 status/info
 * displays).  Operating area at the top plus four text fields drawn by
 * FFEF6764 (22 chars, shadow[0x70]), FFEF682C (7 chars, shadow[0x86]) and
 * FFEF68A1 (two 17-char rows, shadow[0x8D], shadow[0x9E]); five icon slots.
 * Field meaning Unknown (no string anchor in this range).
 *   step table   off_FFED5374 = { FFEEA813, FFEEA825, FFEEA867, FFEEA998 }
 *   event table  off_FFED5384[0..0x38]: 0 restart, 1 frame, 2 clear,
 *     0x2F (no-op FFEF2032), 0x30..0x33 fields, 0x34..0x38 icon slots
 * ========================================================================== */

static void scr0F_sync(u8 full); static void scr0F_reconcile_fields(void);
static void scr0F_draw_all(void); void scr0F_draw_operating_area(void);

/* FFEEA7DB-FFEEA813  size 56  scr0F_info_handler  (sub_FFEEA7DB)
 * off_FFED4050[0x0F]; acts only on F1xx frames.  Confirmed. */
extern step_fn off_FFED5374[4];
void scr0F_info_handler(void)
{
    if (g_frame[0] != 0xF1) return;
    if (g_ui_step <= 3) off_FFED5374[g_ui_step]();
    else                g_ui_step = 3;
}

/* FFEEA813-FFEEA825  size 18  scr0F_step0_sync  (sub_FFEEA813)  Confirmed. */
void scr0F_step0_sync(void) { scr0F_sync(1); g_ui_step++; }

/* FFEEA825-FFEEA867  size 66  scr0F_step1_frame  (sub_FFEEA825)
 * Also event 1.  Draws a white separator line at y=0x83.  Confirmed. */
void scr0F_step1_frame(void)
{
    u16 m = 0x0A, y = 0x83;
    lcd_init_fullscreen_surface();
    ui_draw_header_bar();
    lcd_fill_rect(m, y, 0x140 - 2 * m, 1, RGB_WHITE);
    ui_draw_title(0x11);
    g_ui_step++;
}

/* FFEEA867-FFEEA894  size 45  scr0F_step2_full_draw  (sub_FFEEA867)  Confirmed. */
void scr0F_step2_full_draw(void)
{
    if (lcd_begin_region(&g_lcd_surf, 0, 0, 0x140, 0xF0) == 1) {
        scr0F_draw_all();
        lcd_commit_region_and_step();
    }
}

/* FFEEA894-FFEEA8D6  size 66  scr0F_ev30_field0  (sub_FFEEA894)  Confirmed. */
void scr0F_ev30_field0(void)
{
    if (lcd_begin_region(&g_lcd_surf, 0, 0x53, 0x140, 0x18) == 1) {
        draw_field_FFEF6764(0x11, 0x53, g_shadow[0x6C], &g_shadow[0x70]);
        lcd_commit_region_and_step();
    }
}

/* FFEEA8D6-FFEEA916  size 64  scr0F_ev31_field1  (sub_FFEEA8D6)  Confirmed. */
void scr0F_ev31_field1(void)
{
    if (lcd_begin_region(&g_lcd_surf, 0x93, 0x6B, 0xAD, 0x18) == 1) {
        draw_field_FFEF682C(0x93, 0x6B, &g_shadow[0x86]);
        lcd_commit_region_and_step();
    }
}

/* FFEEA916-FFEEA957  size 65  scr0F_ev32_field2  (sub_FFEEA916)  Confirmed. */
void scr0F_ev32_field2(void)
{
    if (lcd_begin_region(&g_lcd_surf, 0x38, 0x8A, 0x108, 0x18) == 1) {
        draw_field_FFEF68A1(0x38, 0x8A, &g_shadow[0x8D]);
        lcd_commit_region_and_step();
    }
}

/* FFEEA957-FFEEA998  size 65  scr0F_ev33_field3  (sub_FFEEA957)  Confirmed. */
void scr0F_ev33_field3(void)
{
    if (lcd_begin_region(&g_lcd_surf, 0x38, 0xA2, 0x108, 0x18) == 1) {
        draw_field_FFEF68A1(0x38, 0xA2, &g_shadow[0x9E]);
        lcd_commit_region_and_step();
    }
}

/* FFEEA998-FFEEAA1E  size 134  scr0F_step3_events  (sub_FFEEA998)  Confirmed. */
extern event_fn off_FFED5384[0x39];
void scr0F_step3_events(void)
{
    g_cur_event = ui_next_event();
    if (g_cur_event == 0xFF) scr0F_sync(0);
    if (g_cur_event != 0xFF && g_cur_event <= 0x38 && !lcd_queue_busy()) {
        ui_clear_event(g_cur_event);
        off_FFED5384[g_cur_event]();
    }
    UI_CLAMP_STEP();
}

/* FFEEAA1E-FFEEAA3A  size 28  scr0F_sync  (sub_FFEEAA1E)  Confirmed. */
static void scr0F_sync(u8 full)
{
    ipc_sync_opcode();
    scr0F_reconcile_fields();
    ipc_sync_hdr13();
    if (full == 1) ui_clear_all_events();
}

/* FFEEAA3A-FFEEAD7B  size 833  scr0F_reconcile_fields  (sub_FFEEAA3A)
 * shadow[0x6C] (field mode) change invalidates every field.  Bytes 0x6D..0x6F
 * carry a bit-7 "blink" flag: a byte arriving with b7 set and a non-zero low
 * part arms blinking on word1 bit 15 (event 0x2F); when the last such byte
 * clears, blinking is disarmed.  Event 0x2F is a no-op in this screen's table,
 * so the flags are consumed elsewhere (Inferred: by the operating-area
 * drawers).  Confirmed. */
static void scr0F_reconcile_fields(void)
{
    u8 i, was_blinking = 0;
    ipc_sync_common_header();
    g_rec_ptr = &g_shadow[0x20];
    ipc_sync_record_block(&g_shadow[0x20], &g_frame[0x20], 3);
    if (g_shadow[0x6C] != g_frame[0x6C]) {
        ui_raise_w1(0x8000);  ui_raise_w1(0x10000); ui_raise_w1(0x20000);
        ui_raise_w1(0x40000); ui_raise_w1(0x80000);
        g_shadow[0x6C] = g_frame[0x6C];
    }
    for (i = 0; i < 3; i++) {
        if (g_shadow[0x6D + i] == g_frame[0x6D + i]) continue;
        if ((g_frame[0x6D + i] >> 7) != 0 && (g_frame[0x6D + i] & 0x7F) != 0)
            ui_blink_enable(0x8000, 0);
        else if ((g_shadow[0x6D + i] >> 7) != 0)
            was_blinking = 1;
        ui_raise_w1(0x8000);
        g_shadow[0x6D + i] = g_frame[0x6D + i];
    }
    if (was_blinking) {
        for (i = 0; i < 3 && (g_shadow[0x6D + i] >> 7) == 0; i++) ;
        if (i == 3) ui_blink_disable(0x8000, 0);
    }
    for (i = 0; i < 0x16; i++)
        if (g_shadow[0x70 + i] != g_frame[0x70 + i]) { ui_raise_w1(0x10000); g_shadow[0x70 + i] = g_frame[0x70 + i]; }
    for (i = 0; i < 7; i++)
        if (g_shadow[0x86 + i] != g_frame[0x86 + i]) { ui_raise_w1(0x20000); g_shadow[0x86 + i] = g_frame[0x86 + i]; }
    for (i = 0; i < 0x11; i++)
        if (g_shadow[0x8D + i] != g_frame[0x8D + i]) { ui_raise_w1(0x40000); g_shadow[0x8D + i] = g_frame[0x8D + i]; }
    for (i = 0; i < 0x11; i++)
        if (g_shadow[0x9E + i] != g_frame[0x9E + i]) { ui_raise_w1(0x80000); g_shadow[0x9E + i] = g_frame[0x9E + i]; }
    for (i = 0; i < 5; i++) {                       /* icon slots -> events 0x34+i */
        if (g_shadow[0xAF + i] != g_frame[0xAF + i]) { ui_raise_w1(0x100000u << i); g_shadow[0xAF + i] = g_frame[0xAF + i]; }
        if (g_shadow[0xB4 + i] != g_frame[0xB4 + i]) { ui_raise_w1(0x100000u << i); g_shadow[0xB4 + i] = g_frame[0xB4 + i]; }
    }
    if (g_shadow[9] != g_frame[9]) g_shadow[9] = g_frame[9];
    ui_flush_blink_events();
}

/* FFEEAD7B-FFEEAE29  size 174  scr0F_draw_all  (sub_FFEEAD7B)
 * The four text fields are drawn only when shadow[0x6C] == 1.  Confirmed. */
static void scr0F_draw_all(void)
{
    u8 mode = g_shadow[0x6C], i;
    g_redraw_8D79 = 0;
    ui_restore_background(0, 0);
    ui_draw_status_bar();
    ui_set_screen_type_override(3);
    scr0F_draw_operating_area();
    ui_set_screen_type_override(0xFF);
    if (mode == 1) {
        draw_field_FFEF6764(0x11, 0x53, mode, &g_shadow[0x70]);
        draw_field_FFEF682C(0x93, 0x6B, &g_shadow[0x86]);
        draw_field_FFEF68A1(0x38, 0x8A, &g_shadow[0x8D]);
        draw_field_FFEF68A1(0x38, 0xA2, &g_shadow[0x9E]);
    }
    for (i = 0; i < 5; i++) ui_draw_icon_slot(i);
}

/* FFEEAE29-FFEEAE5E  size 53  scr0F_draw_operating_area  (sub_FFEEAE29)
 * Callers: scr0F_draw_all, ev_main_area_redraw (F1 sub 0x0F).  Inferred. */
void scr0F_draw_operating_area(void)
{
    opd_FFEF4FCE(); opd_FFEF5202(); opd_multislot(); opd_FFEF5E38();
    if (op_single_row_q() != 1) {
        if (g_shadow[0x20] != 2) opd_FFEF5518();      /* record mode byte */
        opd_FFEF59E4();
    }
    opd_FFEF6023(); opd_FFEF637D();
}

/* ============================================================================
 * SCREEN 0x01  (IPC F101, main operating screen, single-band layout).
 *   step table   off_FFED5468 = { FFEEAE96, FFEEAEA8, FFEEAEFB, FFEEAFB5 }
 *   event table  off_FFED5478[0..0x27] (rebuilt from bytes, see header):
 *     0 restart, 1 frame, 2 clear, 3 no-op, 4..0x0E FFEF3A3E..FFEF3C28
 *     status-bar items, 0x0F..0x1F element handlers FFEEB8E4..FFEEC030
 *     (0x18 and 0x1D = FFEEC08D whole operating area), 0x20 FFEEAF28 bottom
 *     strip, 0x21..0x26 FFEF23EE icon slots, 0x27 FFEEAF5E all slots
 * ========================================================================== */

static void scr01_sync(u8 full); static void scr01_reconcile_fields(void);
static void scr01_draw_all(void); void scr01_draw_operating_area(void);
static void scr01_draw_slots(void); void scr01_draw_bottom_strip(void);

/* FFEEAE5E-FFEEAE96  size 56  scr01_main_handler  (sub_FFEEAE5E)
 * off_FFED4050[1]; acts only on F1xx frames.  Confirmed. */
extern step_fn off_FFED5468[4];
void scr01_main_handler(void)
{
    if (g_frame[0] != 0xF1) return;
    if (g_ui_step <= 3) off_FFED5468[g_ui_step]();
    else                g_ui_step = 3;
}

/* FFEEAE96-FFEEAEA8  size 18  scr01_step0_sync  (sub_FFEEAE96)  Confirmed. */
void scr01_step0_sync(void) { scr01_sync(1); g_ui_step++; }

/* FFEEAEA8-FFEEAEFB  size 83  scr01_step1_frame  (sub_FFEEAEA8; merged lane-4
 * head sub_FFEEAEB0).  Also event 1.  shadow[0x7C] != 0 selects the compact
 * variant: black fill below field record 0 and title 0x0C, else title 6.
 * Confirmed. */
void scr01_step1_frame(void)
{
    lcd_init_fullscreen_surface();
    ui_draw_header_bar();
    if (g_shadow[0x7C] != 0) {
        lcd_fill_rect(k_scr01_fields[0].x, k_scr01_fields[0].y,
                      0x140 - k_scr01_fields[0].x, 0xF0 - k_scr01_fields[0].y, 0x0000);
        ui_draw_title(0x0C);
    } else {
        ui_draw_title(6);
    }
    g_ui_step++;
}

/* FFEEAEFB-FFEEAF28  size 45  scr01_step2_full_draw  (sub_FFEEAEFB)  Confirmed. */
void scr01_step2_full_draw(void)
{
    if (lcd_begin_region(&g_lcd_surf, 0, 0, 0x140, 0xF0) == 1) {
        scr01_draw_all();
        lcd_commit_region_and_step();
    }
}

/* FFEEAF28-FFEEAF5E  size 54  scr01_ev20_bottom_strip  (sub_FFEEAF28)
 * QUIRK: the commit runs even when lcd_begin_region failed (unlike every
 * other handler here), so a busy layer still queues g_lcd_surf and bumps
 * g_ui_step (re-clamped to 3).  Confirmed. */
void scr01_ev20_bottom_strip(void)
{
    if (lcd_begin_region(&g_lcd_surf, 0, 0x78, 0x140, k_scr01_fields[3].y - 0x78) == 1)
        scr01_draw_bottom_strip();
    lcd_commit_region_and_step();
}

/* FFEEAF5E-FFEEAFB5  size 87  scr01_ev27_slots  (sub_FFEEAF5E)  Confirmed. */
void scr01_ev27_slots(void)
{
    u8 r = (g_shadow[0x7C] == 0) ? 3 : 0;
    const struct field_xy *f = &k_scr01_fields[r];
    if (lcd_begin_region(&g_lcd_surf, f->x, f->y, 0x140 - f->x, 0xF0 - f->y) == 1) {
        scr01_draw_slots();
        lcd_commit_region_and_step();
    }
}

/* FFEEAFB5-FFEEB03B  size 134  scr01_step3_events  (sub_FFEEAFB5)  Confirmed. */
extern event_fn off_FFED5478[0x28];
void scr01_step3_events(void)
{
    g_cur_event = ui_next_event();
    if (g_cur_event == 0xFF) scr01_sync(0);
    if (g_cur_event != 0xFF && g_cur_event <= 0x27 && !lcd_queue_busy()) {
        ui_clear_event(g_cur_event);
        off_FFED5478[g_cur_event]();
    }
    UI_CLAMP_STEP();
}

/* FFEEB03B-FFEEB057  size 28  scr01_sync  (sub_FFEEB03B)  Confirmed. */
static void scr01_sync(u8 full)
{
    ipc_sync_opcode();
    scr01_reconcile_fields();
    ipc_sync_hdr13();
    if (full == 1) ui_clear_all_events();
}

/* FFEEB057-FFEEB275  size 542  scr01_reconcile_fields  (sub_FFEEB057)
 * NOTE: the "[0x8C4E] = [0x8E47]" copy at FFEEB09F cited by doc 12 / pc-04
 * is this screen's own copy of the opcode low byte (it raises event 0x20);
 * the copy that matters on every screen is the common ipc_sync_opcode
 * (FFEF4069).  Label (0x3D..0x4E) changes raise event 0x1D (whole operating
 * area) and then cancel the per-element events 0x0F..0x1C, 0x1E, 0x1F.
 * Confirmed. */
static void scr01_reconcile_fields(void)
{
    u8 i, start;
    ipc_sync_common_header();
    g_rec_ptr = &g_shadow[0x20];
    ipc_sync_record_block(&g_shadow[0x20], &g_frame[0x20], 3);
    if (g_shadow[1] != g_frame[1]) { ui_raise_w1(1); g_shadow[1] = g_frame[1]; }   /* FFEEB09F */
    for (i = 0; i < 2; i++)                                     /* label width mask */
        if (g_shadow[0x3D + i] != g_frame[0x3D + i]) { ui_raise_elem(0x0E, 3); g_shadow[0x3D + i] = g_frame[0x3D + i]; }
    for (i = 0; i <= 0x0F; i++)                                 /* 16-char label */
        if (g_shadow[0x3F + i] != g_frame[0x3F + i]) { ui_raise_elem(0x0E, 3); g_shadow[0x3F + i] = g_frame[0x3F + i]; }
    if (g_shadow[1] == 1)
        copy_raise_w1(&g_shadow[0x6C], &g_frame[0x6C], 0x10, 1);  /* -> event 0x20 */
    copy_raise_w0(&g_shadow[0x7C], &g_frame[0x7C], 1, 1);         /* layout -> restart */
    start = (g_frame[0x7C] == 0) ? 3 : 0;
    for (i = start; i < 6; i++) {
        if (g_shadow[0x7D + i] != g_frame[0x7D + i]) { ui_raise_w1(2u << i); g_shadow[0x7D + i] = g_frame[0x7D + i]; }
        if (g_shadow[0x83 + i] != g_frame[0x83 + i]) { ui_raise_w1(2u << i); g_shadow[0x83 + i] = g_frame[0x83 + i]; }
    }
    if (g_ui_events[0] & (1u << 0x1D)) {
        for (i = 0; i < 0x0E; i++) ui_clear_elem(i, 3);         /* events 0x0F..0x1C */
        ui_clear_w0(0xC0000000);                                /* events 0x1E, 0x1F */
    }
    if (g_shadow[9] != g_frame[9]) g_shadow[9] = g_frame[9];
    ui_flush_blink_events();
}

/* FFEEB275-FFEEB2A1  size 44  scr01_draw_all  (sub_FFEEB275)  Confirmed. */
static void scr01_draw_all(void)
{
    g_redraw_8D79 = 0;
    ui_restore_background(0, 0);
    ui_draw_status_bar();
    ui_set_screen_type_override(3);
    scr01_draw_operating_area();
    scr01_draw_bottom_strip();
    ui_set_screen_type_override(0xFF);
    scr01_draw_slots();
}

/* FFEEB2A1-FFEEB34A  size 169  scr01_draw_operating_area  (sub_FFEEB2A1)
 * Callers: scr01_draw_all, ev_main_area_redraw (F1 sub 1).  shadow[0x5F] is
 * the operating mode byte also decoded by scr01_draw_bottom_strip.  Inferred. */
void scr01_draw_operating_area(void)
{
    u8 b4, mode; u8 *rec;
    opd_FFEF4FCE(); opd_FFEF5202(); opd_FFEF535E(); opd_FFEF5421(); opd_FFEF5494();
    opd_FFEF5E38(); opd_multislot();
    if (op_single_row_q() == 1) {
        b4 = LAYOUT_B4;  mode = g_shadow[0x5F];
        if (b4 != 0 && !(mode < 4 || (mode >= 7 && mode <= 0x0A))) {
            opd_FFEF643C(); opd_FFEF64D2();
        }
        opd_FFEF55FB();
    } else {
        rec = ui_current_record();
        if (rec[0] != 3) { opd_FFEF5518(); opd_FFEF55FB(); opd_FFEF59E4(); }
    }
    opd_FFEF6023(); opd_FFEF637D(); opd_FFEF541D();
}

/* FFEEB34A-FFEEB397  size 77  scr01_draw_slots  (sub_FFEEB34A)
 * Compact layout (shadow[0x7C]!=0): clear below field record 0 and draw icon
 * slots 0..5; normal layout: slots 3..5 only.  Confirmed. */
static void scr01_draw_slots(void)
{
    u8 i, start = 0;
    if (g_shadow[0x7C] == 0) start = 3;
    else lcd_clear_rect(k_scr01_fields[0].x, k_scr01_fields[0].y,
                        0x140 - k_scr01_fields[0].x, 0xF0 - k_scr01_fields[0].y);
    for (i = start; i < 6; i++) ui_draw_icon_slot(i);
}

/* FFEEB397-FFEEB8E2  size 1355  scr01_draw_bottom_strip  (sub_FFEEB397; IDA
 * lane-4 heads FFEEB436/B530/B728/B746 are internal)
 * Callers: scr01_ev20_bottom_strip, scr01_draw_all, ev_main_area_redraw.
 * Normal layout only (shadow[0x7C]==0) and only for F101.  Draws:
 *   - the 16-char channel label shadow[0x3F..] (double-width mask 0x3D:0x3E)
 *   - a 9-char text shadow[0x6C..] at (0xC9,0x9E)
 *   - for analog modes (shadow[0x5F] in 7..0x1B, folded to 7..0x0A):
 *       either the tone block: tone icon (shadow[0x5D] b5:4 = off/on/blink),
 *       squelch type text (shadow[0x65], 3-char table "TN TSQDCSRTN..."),
 *       then the CTCSS frequency (shadow[0x66] < 50, 4 or 5 glyphs with a
 *       narrow decimal point) or DCS code (shadow[0x67] < 104, 3 glyphs);
 *     or, in the two-row layout with shadow[0x68] b3:2 != 0, the APRS block:
 *       icon by shadow[0x68] b1:0, "A12"/"A96" by b4 (1200/9600 bd, Inferred)
 *       shown/blinking by b3:2
 *   - for digital modes (folded value > 0x0A): icon FFED3E9C, two-digit
 *     value shadow[0x69] at x=0x24 (font 2), icon FFED3E7C, two-digit value
 *     shadow[0x6A] at x=0x62 (font 4); values > 99 draw blanks.  Inferred:
 *     the C4FM DG-ID TX/RX pair.
 * Confirmed control flow and constants; field names Inferred. */
void scr01_draw_bottom_strip(void)
{
    u8 sub = g_shadow[1], mode = g_shadow[0x5F], tonef = g_shadow[0x5D];
    u8 sq = g_shadow[0x65], vis = 0, b4 = LAYOUT_B4, aprs = g_shadow[0x68];
    u16 x, y; u8 n, i, cnt, g; u8 f;

    if (g_shadow[0x7C] != 0) return;
    lcd_clear_rect(0, 0x78, 0x140, k_scr01_fields[3].y - 0x78);
    if (sub != 1) return;
    lcd_draw_string_dw(0x0E, 0x7B, (u16)((g_shadow[0x3D] << 8) | g_shadow[0x3E]), &g_shadow[0x3F]);
    lcd_draw_text(0xC9, 0x9E, 1, (const char *)&g_shadow[0x6C], 9, RGB_WHITE);
    if (mode > 0x1B || mode < 7) return;
    if (mode >= 0x0E) mode = (mode <= 0x14) ? mode - 7 : mode - 0x0E;
    if (mode > 0x0A) goto digital;

    if (b4 == 0 || ((aprs & 0x0C) >> 2) == 0) {
        /* ---- tone / squelch block ---- */
        x = 0x0D; y = 0x9E;
        switch ((tonef & 0x30) >> 4) {
        case 2: vis = ui_blink_phase(); break;
        case 1: vis = 1; break;
        }
        if (vis == 1) lcd_draw_icon(x, y, vis, stru_FFED2F7C);
        if (sq & 0x80) { if (ui_blink_phase() != 1) return; }
        sq &= 0x7F;
        x = 0x27;
        if (sq <= 0x0B && sq != 0 && sq != 8)
            lcd_draw_text(x, y, 1, &k_tone_mode_str[sq * 3], 3, RGB_WHITE);
        x = 0x5B;
        if (sq == 1 || sq == 2 || sq == 4 || sq == 0x0A) {        /* CTCSS */
            n = g_shadow[0x66];
            if (n > 0x31) return;
            if (n <= 0x0B) { cnt = 4; x += 0x0D; } else cnt = 5;
            for (i = 0; i < cnt; i++) {
                g = k_ctcss_glyphs[n][i];
                lcd_draw_icon(x, y, 1, g_tone_glyph[g]);
                if ((cnt == 4 && i == 2) || (cnt == 5 && i == 3)) x += 7;   /* '.' cell */
                else x += 0x0D;
            }
        } else if (sq == 3 || sq == 9 || sq == 0x0B) {           /* DCS */
            n = g_shadow[0x67];
            if (n > 0x67) return;
            for (i = 0; i < 3; i++) {
                g = k_dcs_glyphs[n][i];
                lcd_draw_icon(x, y, 1, g_tone_glyph[g]);
                x += 0x0D;
            }
        }
        return;
    }
    /* ---- APRS / data block (two-row layout, shadow[0x68] b3:2 != 0) ---- */
    if (((aprs & 0x0C) >> 2) == 0) return;
    x = 0x0D; y = 0x9E;
    switch (aprs & 3) {
    case 1: lcd_draw_icon(x, y, 1, stru_FFECF07C); break;
    case 2: lcd_draw_icon(x, y, 1, stru_FFECF09C); break;
    }
    switch ((aprs & 0x0C) >> 2) {
    case 1:  vis = 1; break;
    case 2:  vis = ui_blink_phase(); break;
    default: vis = 0; break;
    }
    x = 0x27;
    if (vis != 1) return;
    lcd_draw_text(x, y, 1, ((aprs & 0x10) >> 4) ? "A96" : "A12", 3, RGB_WHITE);
    return;

digital:
    lcd_draw_icon(0x0D, 0x9E, 1, stru_FFED3E9C);
    n = g_shadow[0x69]; x = 0x24; y = 0x9E; f = 2;
    if (n <= 0x63) {
        lcd_draw_icon(x, y, 1, g_font_digits[f][n / 10]);  x += 0x0D;
        lcd_draw_icon(x, y, 1, g_font_digits[f][n % 10]);
    } else {
        lcd_draw_icon(x, y, 0, g_font_digits[f][0]);       x += 0x0D;
        lcd_draw_icon(x, y, 0, g_font_digits[f][0]);
    }
    lcd_draw_icon(0x4B, 0x9E, 1, stru_FFED3E7C);
    n = g_shadow[0x6A]; x = 0x62; f = 4;
    if (n <= 0x63) {
        lcd_draw_icon(x, y, 1, g_font_digits[f][n / 10]);  x += 0x0D;
        lcd_draw_icon(x, y, 1, g_font_digits[f][n % 10]);
    } else {
        lcd_draw_icon(x, y, 0, g_font_digits[f][0]);       x += 0x0D;
        lcd_draw_icon(x, y, 0, g_font_digits[f][0]);
    }
}

/* ============================================================================
 * OPERATING-SCREEN ELEMENT EVENT HANDLERS  (FFEEB8E4..FFEEC1C9)
 * Entries 0x0F..0x1F of the screen-0 (F100, both band rows: 0x0F..0x1F and
 * again 0x20..0x2E at off_FFED5088) and screen-1 (F101) event tables, plus
 * sparse use by screens 6 and 0x0F.  Each handler asks its locator where the
 * element is in the current layout (loc_* below); if the position is on
 * screen (x <= 319, y < 240) it opens a region of the element's fixed size
 * there, calls the element drawer (outside this range) and commits.  The
 * locators read ui_screen_type(), which depends on g_cur_event, so the same
 * handler draws the upper row when serviced as event 0x0F..0x1D and the lower
 * row when serviced as 0x20..0x2E (see ui_screen_type).  Confirmed pattern.
 * ========================================================================== */

void loc_elem0F(u16 *x, u16 *y, u16 *c); void loc_elem10(u16 *x, u16 *y, u16 *c);
void loc_elem11(u16 *x, u16 *y);         void loc_elem12(u16 *x, u16 *y);
void loc_elem13(u16 *x, u16 *y);         void loc_elem15(u16 *x, u16 *y, u16 *c);
void loc_elem16(u16 *x, u16 *y);         u8   loc_elem17(u16 *x, u16 *y, u16 *c);
void loc_elem1E(u16 *x, u16 *y, u16 *c); void loc_elem1F(u16 *x, u16 *y, u16 *c);
void loc_elem19(u16 *x, u16 *y);         void loc_elem1A(u16 *x, u16 *y);
void loc_elem1B(u16 *x, u16 *y);         void loc_elem1C(u16 *x, u16 *y);
void loc_main_area(u16 *x, u16 *y, u16 *w, u16 *h);
void loc_elem18_pair(u16 *x1, u16 *y1, u16 *x2, u16 *y2, u16 *c);
void sub_FFEEED50(u16 *x, u16 *y, u16 *c);                 /* next lane's locator */

#define OFFSCREEN(x, y)  ((x) > 0x13F || (y) >= 0xF0)

/* FFEEB8E4-FFEEB941  size 93  ev_elem0F  (sub_FFEEB8E4)  0x26x0x16.  Confirmed. */
void ev_elem0F(void)
{
    u16 x, y, c;
    loc_elem0F(&x, &y, &c);
    if (OFFSCREEN(x, y)) return;
    if (lcd_begin_region(&g_lcd_surf, x, y, 0x26, 0x16) == 1) { opd_FFEF4FCE(); lcd_commit_region_and_step(); }
}

/* FFEEB941-FFEEB99E  size 93  ev_elem10  (sub_FFEEB941)  0x26x0x16.  Confirmed. */
void ev_elem10(void)
{
    u16 x, y, c;
    loc_elem10(&x, &y, &c);
    if (OFFSCREEN(x, y)) return;
    if (lcd_begin_region(&g_lcd_surf, x, y, 0x26, 0x16) == 1) { opd_FFEF5202(); lcd_commit_region_and_step(); }
}

/* FFEEB99E-FFEEB9F8  size 90  ev_elem11  (sub_FFEEB99E)  0x10x0x10.  Confirmed. */
void ev_elem11(void)
{
    u16 x, y;
    loc_elem11(&x, &y);
    if (OFFSCREEN(x, y)) return;
    if (lcd_begin_region(&g_lcd_surf, x, y, 0x10, 0x10) == 1) { opd_FFEF535E(); lcd_commit_region_and_step(); }
}

/* FFEEB9F8-FFEEBA52  size 90  ev_elem12  (sub_FFEEB9F8)  0x0Cx0x10.  Confirmed. */
void ev_elem12(void)
{
    u16 x, y;
    loc_elem12(&x, &y);
    if (OFFSCREEN(x, y)) return;
    if (lcd_begin_region(&g_lcd_surf, x, y, 0x0C, 0x10) == 1) { opd_FFEF5421(); lcd_commit_region_and_step(); }
}

/* FFEEBA52-FFEEBAAC  size 90  ev_elem13  (sub_FFEEBA52)  0x0Cx0x10.  Confirmed. */
void ev_elem13(void)
{
    u16 x, y;
    loc_elem13(&x, &y);
    if (OFFSCREEN(x, y)) return;
    if (lcd_begin_region(&g_lcd_surf, x, y, 0x0C, 0x10) == 1) { opd_FFEF5494(); lcd_commit_region_and_step(); }
}

/* FFEEBAAC-FFEEBB19  size 109  ev_elem14_multislot  (sub_FFEEBAAC; merged
 * lane-4 head sub_FFEEBAAF)  Region = the whole operating area width from x;
 * forces a full redraw of the multi-slot renderer (doc 31 Routine B) through
 * g_multislot_redraw.  Confirmed. */
void ev_elem14_multislot(void)
{
    u16 x, y, w, h;
    loc_main_area(&x, &y, &w, &h);
    if (OFFSCREEN(x, y)) return;
    w = 0x140 - x;
    if (lcd_begin_region(&g_lcd_surf, x, y, w, h) == 1) {
        g_multislot_redraw = 1;
        opd_multislot();
        lcd_commit_region_and_step();
    }
}

/* FFEEBB19-FFEEBB76  size 93  ev_elem15  (sub_FFEEBB19)  0x0Cx0x0C.  Confirmed. */
void ev_elem15(void)
{
    u16 x, y, c;
    loc_elem15(&x, &y, &c);
    if (OFFSCREEN(x, y)) return;
    if (lcd_begin_region(&g_lcd_surf, x, y, 0x0C, 0x0C) == 1) { opd_FFEF5518(); lcd_commit_region_and_step(); }
}

/* FFEEBB76-FFEEBBD0  size 90  ev_elem16  (sub_FFEEBB76)  0x1Ex0x0E.  Confirmed. */
void ev_elem16(void)
{
    u16 x, y;
    loc_elem16(&x, &y);
    if (OFFSCREEN(x, y)) return;
    if (lcd_begin_region(&g_lcd_surf, x, y, 0x1E, 0x0E) == 1) { opd_FFEF55FB(); lcd_commit_region_and_step(); }
}

/* FFEEBBD0-FFEEBD3E  size 366  ev_elem17  (sub_FFEEBBD0; lane-4 heads
 * FFEEBC11, FFEEBD11 internal)
 * Region from (x,y-2) to the right edge, height 50.  QUIRK: a height h
 * (23, or 53 after the "-10 px / +30" adjustments) is computed but never
 * used - the region call passes the constant 0x32; the locator's return
 * value is also ignored.  For F100 the redraw is skipped while event 0x18
 * (word0 bit 24) or 0x29 (word1 bit 9) is pending (they redraw it anyway).
 * Confirmed. */
void ev_elem17(void)
{
    u16 x, y, c, h; u8 *rec, type, op, sub, m;
    (void)loc_elem17(&x, &y, &c);
    if (OFFSCREEN(x, y)) return;
    y -= 2;  h = 0x17;
    rec = ui_current_record();  type = ui_screen_type();
    op = g_shadow[0];  sub = g_shadow[1];  m = rec[0];
    if (op == 0xF1) {
        if (sub == 0) {
            if (!(m == 0 || m == 2)) {
                if (LAYOUT_B4 == 0) { if (type == 1) { x -= 0x0A; h += 0x1E; } }
                else                { if (type == 2) { x -= 0x0A; h += 0x1E; } }
            }
            if (g_ui_events[0] & 0x01000000) return;
            if (g_ui_events[1] & 0x00000200) return;
        } else if (sub == 0x14) {
            if (!(m == 0 || m == 2)) { x -= 0x0A; h += 0x1E; }
            if (g_ui_events[0] & 0x01000000) return;
        } else if (sub == 0x12) {
            x -= 0x0A;
        }
    }
    (void)h;
    if (lcd_begin_region(&g_lcd_surf, x, y, 0x140 - x, 0x32) == 1) { opd_FFEF59E4(); lcd_commit_region_and_step(); }
}

/* FFEEBD3E-FFEEBE51  size 275  ev_elem18_pair  (sub_FFEEBD3E; merged lane-4
 * heads FFEEBD41, FFEEBD48, FFEEBDD1)  Screen-0 entry 0x18 (FFED5068).  Uses
 * the first position of loc_elem18_pair, falling back to the next lane's
 * locator sub_FFEEED50; the region reaches 0x17 px below the fallback y.
 * After opd_FFEF5E38 it also redraws the two-row extras unless the record's
 * byte 0x3F is <4 or 7..10.  Confirmed. */
void ev_elem18_pair(void)
{
    u16 x1, y1, x2, y2, c, ex, ey, x, y; u8 v, type; u8 *rec;
    loc_elem18_pair(&x1, &y1, &x2, &y2, &c);
    sub_FFEEED50(&ex, &ey, &c);
    if (OFFSCREEN(x1, y1)) { x = ex; y = ey; } else { x = x1; y = y1; }
    if (OFFSCREEN(x, y)) return;
    if (lcd_begin_region(&g_lcd_surf, x, y, 0x140 - x, (u16)(ey + 0x12 - y + 5)) != 1) return;
    opd_FFEF5E38();
    rec = ui_current_record();
    v = rec[0x3F];
    type = ui_screen_type();
    if (!(v < 4 || (v >= 7 && v <= 0x0A))) {
        if (op_single_row_q() == 1) {
            if (type == 2) { opd_FFEF643C(); opd_FFEF64D2(); }
        } else {
            opd_FFEF5518(); opd_FFEF59E4();
        }
    }
    lcd_commit_region_and_step();
}

/* FFEEBE51-FFEEBEB2  size 97  ev_elem19  (sub_FFEEBE51)  to right edge x 0x10.  Confirmed. */
void ev_elem19(void)
{
    u16 x, y;
    loc_elem19(&x, &y);
    if (OFFSCREEN(x, y)) return;
    if (lcd_begin_region(&g_lcd_surf, x, y, 0x140 - x, 0x10) == 1) { opd_FFEF6023(); lcd_commit_region_and_step(); }
}

/* FFEEBEB2-FFEEBF13  size 97  ev_elem1A  (sub_FFEEBEB2)  to right edge x 5.  Confirmed. */
void ev_elem1A(void)
{
    u16 x, y;
    loc_elem1A(&x, &y);
    if (OFFSCREEN(x, y)) return;
    if (lcd_begin_region(&g_lcd_surf, x, y, 0x140 - x, 5) == 1) { opd_FFEF631E(); lcd_commit_region_and_step(); }
}

/* FFEEBF13-FFEEBF6D  size 90  ev_elem1B  (sub_FFEEBF13)  0xB8x0x17.  Confirmed. */
void ev_elem1B(void)
{
    u16 x, y;
    loc_elem1B(&x, &y);
    if (OFFSCREEN(x, y)) return;
    if (lcd_begin_region(&g_lcd_surf, x, y, 0xB8, 0x17) == 1) { opd_FFEF637D(); lcd_commit_region_and_step(); }
}

/* FFEEBF6D-FFEEBFD3  size 102  ev_elem1C  (sub_FFEEBF6D)
 * Region (x-7, y-1) 0xA4x0x0F.  Confirmed. */
void ev_elem1C(void)
{
    u16 x, y;
    loc_elem1C(&x, &y);
    if (OFFSCREEN(x, y)) return;
    x -= 7;  y -= 1;
    if (lcd_begin_region(&g_lcd_surf, x, y, 0xA4, 0x0F) == 1) { opd_FFEF9B22(); lcd_commit_region_and_step(); }
}

/* FFEEBFD3-FFEEC030  size 93  ev_elem1E  (sub_FFEEBFD3)  0x0Cx0x12.  Confirmed. */
void ev_elem1E(void)
{
    u16 x, y, c;
    loc_elem1E(&x, &y, &c);
    if (OFFSCREEN(x, y)) return;
    if (lcd_begin_region(&g_lcd_surf, x, y, 0x0C, 0x12) == 1) { opd_FFEF643C(); lcd_commit_region_and_step(); }
}

/* FFEEC030-FFEEC08D  size 93  ev_elem1F  (sub_FFEEC030)  0x26x0x12.  Confirmed. */
void ev_elem1F(void)
{
    u16 x, y, c;
    loc_elem1F(&x, &y, &c);
    if (OFFSCREEN(x, y)) return;
    if (lcd_begin_region(&g_lcd_surf, x, y, 0x26, 0x12) == 1) { opd_FFEF64D2(); lcd_commit_region_and_step(); }
}

/* FFEEC08D-FFEEC1C9  size 316  ev_main_area_redraw  (sub_FFEEC08D; merged
 * lane-4 head FFEEC090; the case block FFEEC133..FFEEC188 is the one docs
 * 46/48 call "out of phase" - this listing decodes it correctly)
 * Events 0x18/0x1D (screen 1) and 0x1D/0x2E (screen 0): clear the operating
 * area and redraw it with the drawer of the current opcode.  Jump table
 * jpt_FFEEC131 (22 entries, F1 sub 0..0x15).  Confirmed. */
void ev_main_area_redraw(void)
{
    u8 op = g_shadow[0], sub = g_shadow[1];
    u16 x, y, w, h;
    loc_main_area(&x, &y, &w, &h);
    if (OFFSCREEN(x, y)) return;
    if (lcd_begin_region(&g_lcd_surf, x, y, 0x140 - x, 0xF0 - y) != 1) return;
    lcd_clear_rect(x, y, w, h);
    switch (op) {
    case 0xF1:
        if (sub > 0x15) break;
        switch (sub) {
        case 0:  sub_FFEE86D6(); break;                         /* F100 */
        case 1:  scr01_draw_operating_area(); scr01_draw_bottom_strip(); break;
        case 3:  sub_FFEE683A(); break;
        case 4: case 5: sub_FFEE5EF8(); break;
        case 6:  scr06_draw_operating_area(); break;
        case 7:  sub_FFEE806F(); break;
        case 8: case 9: case 10: scr08_main_area_stub(); break;
        case 11: sub_FFEE7985(); break;
        case 15: scr0F_draw_operating_area(); break;
        case 18: sub_FFF4026F(); break;
        case 19: sub_FFF4112D(); break;
        case 20: sub_FFF44EE1(); sub_FFF44FA3(); break;
        case 21: sub_FFF453BB(); break;
        default: break;                                       /* 2, 12-14, 16, 17 */
        }
        break;
    case 0xF8: if (sub == 0) sub_FFF12272(); break;
    case 0xF7: if (sub == 1) sub_FFEEF77E(); break;
    case 0xFD: if (sub == 0) sub_FFEDED67(); break;
    }
    opd_FFEF541D();
    lcd_commit_region_and_step();
}

/* ============================================================================
 * LAYOUT CLASSIFIERS
 * ========================================================================== */

/* FFEEC1C9-FFEEC232  size 105  ui_icon_layout_index  (sub_FFEEC1C9)
 * Caller: FFEF23EE (generic icon-slot event handler), which subtracts a
 * per-layout base from g_cur_event.  F1xx -> opcode low byte; F280 -> 8;
 * F7 -> 0x13; F8 -> 0x14; FD -> 0x15.  QUIRKS: for F0 sub 6 the value 7 is
 * stored and immediately overwritten by the low byte (dead store); for F2
 * other than 0x80 and for any other family the result is an uninitialised
 * stack byte.  Confirmed. */
u8 ui_icon_layout_index(void)
{
    u8 r;                                    /* uninitialised on some paths */
    switch (g_shadow[0]) {
    case 0xFD: r = 0x15; break;
    case 0xF1: r = g_shadow[1]; break;
    case 0xF2: if (g_shadow[1] == 0x80) r = 8; break;
    case 0xF7: r = 0x13; break;
    case 0xF8: r = 0x14; break;
    case 0xF0: if (g_shadow[1] == 6) r = 7;  /* dead */
               r = g_shadow[1]; break;
    default: break;
    }
    return r;
}

/* FFEEC232-FFEEC35B  size 297  ui_screen_type  (sub_FFEEC232)
 * doc 31's "screen-type classifier".  Returns the band-row type that the
 * locators branch on: 3 = single-row layout; for the dual-row F1 screens
 * (subs 0, 3, 0x0C, 0x0E, 0x10) 1 = upper row while servicing events
 * 0x00..0x1D, 2 = lower row for events 0x1E..0xFF (bit_index(0x40000000)=30,
 * bit_index(0x80000000)=31, so 30/31 and >=32 give 2).  The override cell
 * 0x12285 wins when != 0xFF (set to 3 during full redraws; FFEF42A7 sets its
 * own argument).  Value 4 only arrives through the override (doc 31 "1..4").
 * QUIRK: unmatched opcodes return an uninitialised byte.  Confirmed. */
u8 ui_screen_type(void)
{
    u8 r;                                    /* uninitialised on some paths */
    u8 ev, sub;
    if (g_screen_type_ovr != 0xFF) return g_screen_type_ovr;
    sub = g_shadow[1];
    switch (g_shadow[0]) {
    case 0xFD: if (sub == 0) r = 3; break;
    case 0xF7: if (sub == 1 || sub == 2) r = 3; break;
    case 0xF8: if (sub == 0) r = 3; break;
    case 0xF1:
        if ((u8)(sub - 0x11) < 5 || sub == 1 || (u8)(sub - 4) < 8 || sub == 0x0D || sub == 0x0F) {
            r = 3;
        } else if (sub == 0 || sub == 3 || sub == 0x0C || sub == 0x0E || sub == 0x10) {
            ev = g_cur_event;
            if (ev >= bit_index(0x40000000) && ev <= bit_index(0x80000000)) r = 2;
            else r = (ev <= 0x1F) ? 1 : 2;
        }
        break;
    default: break;
    }
    return r;
}

/* FFEEC35B-FFEEC369  size 14  ui_set_screen_type_override  (sub_FFEEC35B)
 * 40 call sites (pairs 3 / 0xFF around full redraws).  Confirmed. */
void ui_set_screen_type_override(u8 t) { g_screen_type_ovr = t; }

/* FFEEC369-FFEEC3BD  size 84  dead_ui_layout_9_or_10  (dead_FFEEC369)
 * No caller anywhere (IDA "dead_").  Returns 10 for F7, and for F1 subs 3,
 * 6..10, 0x0C..0x11; 9 otherwise.  Meaning Unknown.  Confirmed body. */
u8 dead_ui_layout_9_or_10(void)
{
    u8 r = 9, sub = g_shadow[1];
    switch (g_shadow[0]) {
    case 0xFD: r = 9; break;
    case 0xF7: r = 0x0A; break;
    case 0xF8: r = 9; break;
    case 0xF1:
        if (sub == 3 || (u8)(sub - 6) < 5 || (u8)(sub - 0x0C) <= 5) r = 0x0A;
        break;
    }
    return r;
}

/* FFEEC3BD-FFEEC5AB  size 494  ui_current_record  (sub_FFEEC3BD)
 * Pointer to the channel/VFO record the locators and drawers read (rec[0] =
 * record mode byte, 0/2 = the "z" layouts below; rec[0x3F] used by
 * ev_elem18_pair).  Normally &shadow[0x20]; &shadow[0x6C] for the lower row
 * (type 2) of F1 subs 0, 0x0C, 0x0E, 0x10; F103: type 2 -> +0x7D,
 * type 4 -> +0x20, else +0x31.  QUIRK: NULL for F102, F1 subs > 0x15, F7
 * other than sub 1/2 and every non F1/F7/F8/FD family; callers dereference
 * rec[0] without a check (reads RAM 0).  Confirmed. */
u8 *ui_current_record(void)
{
    u8 type = ui_screen_type();
    u8 *p = 0;
    switch (g_shadow[0]) {
    case 0xFD: p = &g_shadow[0x20]; break;
    case 0xF7: if (g_shadow[1] == 1 || g_shadow[1] == 2) p = &g_shadow[0x20]; break;
    case 0xF8: p = &g_shadow[0x20]; break;
    case 0xF1:
        if (g_shadow[1] > 0x15) break;
        switch (g_shadow[1]) {                         /* jpt_FFEEC400 */
        case 0: case 0x0C: case 0x0E: case 0x10:
            p = (type == 2) ? &g_shadow[0x6C] : &g_shadow[0x20]; break;
        case 2: break;
        case 3:
            p = (type == 2) ? &g_shadow[0x7D] : (type == 4) ? &g_shadow[0x20] : &g_shadow[0x31];
            break;
        default: p = &g_shadow[0x20]; break;
        }
        break;
    }
    return p;
}

/* ============================================================================
 * ELEMENT LOCATORS  (FFEEC5AB..FFEEED50)
 * Each returns where an operating-screen element sits in the current layout:
 * x, y and (some) an RGB565 colour (white = active row, grey 0x7BEF =
 * inactive row).  All outputs start at 0xFFFF (= "not shown", rejected by
 * the OFFSCREEN test).  Inputs common to all:
 *   rec = ui_current_record(); type = ui_screen_type();
 *   op = shadow[0]; sub = shadow[1]; m = rec[0];
 *   z  = (m == 0 || m == 2)        b4c = (shadow[9] & 0x10) == 0
 * All Confirmed (decision trees transcribed from the listing; uimm8 operands
 * resolved, e.g. 0x82, 0x84, 0xBD, 0xE4).
 * ========================================================================== */

#define LOC_PROLOGUE  u8 *rec = ui_current_record(); u8 type = ui_screen_type(); \
                      u8 op = g_shadow[0], sub = g_shadow[1], m = rec[0];       \
                      u8 z = (m == 0 || m == 2), b4c = (g_shadow[9] & 0x10) == 0; \
                      (void)z; (void)b4c; (void)type
#define SET3(X, Y, C) do { *x = (X); *y = (Y); *c = (C); return; } while (0)
#define SET2(X, Y)    do { *x = (X); *y = (Y); return; } while (0)

/* FFEEC5AB-FFEEC7E1  size 566  loc_elem0F  (sub_FFEEC5AB)  Confirmed. */
void loc_elem0F(u16 *x, u16 *y, u16 *c)
{
    LOC_PROLOGUE;
    *x = *y = *c = 0xFFFF;
    if (op == 0xF1) {
        if (sub == 0) {
            if (b4c) { if (type == 2) SET3(0, 0x79, RGB_GREY); SET3(0, 0x15, RGB_WHITE); }
            if (type == 1) SET3(0, 0x15, RGB_GREY);
            if (type == 2) SET3(0, 0x55, RGB_WHITE);
            SET3(0, 0x15, RGB_WHITE);
        }
        if (sub == 1 || sub == 6 || sub == 0x15 || sub == 0x14 || sub == 0x12 || sub == 0x0F) SET3(0, 0x15, RGB_WHITE);
        if (sub == 3) {
            if (type == 4) SET3(0, 0x14, RGB_WHITE);
            if (type == 1) SET3(0, 0x4B, b4c ? RGB_WHITE : RGB_GREY);
            if (type == 2) SET3(0, 0x82, b4c ? RGB_GREY : RGB_WHITE);
            return;
        }
        if ((sub == 0x0B || sub == 0x13) && m != 2) SET3(0, 0x15, RGB_WHITE);
    } else if (op == 0xF8) { if (sub == 0) SET3(1, 0x1F, RGB_WHITE); }
    else if (op == 0xFD)   { if (sub == 0) SET3(0, 0x15, RGB_WHITE); }
}

/* FFEEC7E1-FFEECAE0  size 767  loc_elem10  (sub_FFEEC7E1)  Confirmed. */
void loc_elem10(u16 *x, u16 *y, u16 *c)
{
    LOC_PROLOGUE;
    *x = *y = *c = 0xFFFF;
    if (op == 0xF1) {
        if (sub == 0) {
            if (z) {
                if (b4c) { if (type == 1) SET3(0x29, 0x17, RGB_WHITE);
                           if (type == 3) SET3(0, 0x2B, RGB_WHITE); SET3(0, 0x8F, RGB_GREY); }
                if (type == 1) SET3(0, 0x2B, RGB_GREY);
                if (type == 2) SET3(0x29, 0x57, RGB_WHITE);
                SET3(0, 0x2B, RGB_WHITE);
            }
            if (b4c) { if (type == 1) SET3(0, 0x2B, RGB_WHITE);
                       if (type == 3) SET3(0, 0x2B, RGB_WHITE); SET3(0, 0x8F, RGB_GREY); }
            if (type == 1) SET3(0, 0x2B, RGB_GREY);
            if (type == 2) SET3(0, 0x6B, RGB_WHITE);
            SET3(0x29, 0x17, RGB_WHITE);
        }
        if (sub == 1) SET3(0x29, 0x17, RGB_WHITE);
        if (sub == 0x14 || sub == 0x15) { if (z) SET3(0x29, 0x17, RGB_WHITE); SET3(0, 0x2B, RGB_WHITE); }
        if (sub == 0x0B || sub == 0x13) { if (m != 2) SET3(0, 0x2B, RGB_WHITE); return; }
        if (sub == 0x12) SET3(0, 0x2B, RGB_WHITE);
        if (sub == 0x0F || sub == 6) SET3(0, 0x17, RGB_WHITE);
        if (sub == 3 && type != 4) {
            if (type == 1) SET3(0, 0x4D, b4c ? RGB_WHITE : RGB_GREY);
            if (type == 2) SET3(0, 0x84, b4c ? RGB_GREY : RGB_WHITE);
        }
    } else if (op == 0xFD && sub == 0) SET3(0, 0x2B, RGB_WHITE);
}

/* Shared shape of the 2-output locators 11/12/13/16 (Confirmed per body):
 *   F1 sub0: z: (b4c&&type1)->(XA,YA) (!b4c&&type2)->(XA,YA+0x40)
 *           !z: (b4c&&type1)->(XB,YB) (!b4c&&type2)->(XB,YB+0x40)
 *   sub1 -> (XA,YA); sub 0x14/0x15 -> z?(XA,YA):(XB,YB); sub 0x12 -> (XB,YB) [not elem16] */
static void loc_two_row(u16 *x, u16 *y, u16 xa, u16 ya, u16 xb, u16 yb, u8 has12)
{
    LOC_PROLOGUE;
    *x = *y = 0xFFFF;
    if (op != 0xF1) return;
    if (sub == 0) {
        if (z) { if (b4c) { if (type == 1) SET2(xa, ya); return; } if (type == 2) SET2(xa, ya + 0x40); return; }
        if (b4c) { if (type == 1) SET2(xb, yb); return; } if (type == 2) SET2(xb, yb + 0x40); return;
    }
    if (sub == 1) SET2(xa, ya);
    if (sub == 0x14 || sub == 0x15) { if (z) SET2(xa, ya); SET2(xb, yb); }
    if (has12 && sub == 0x12) SET2(xb, yb);
}
/* FFEECAE0-FFEECC17  size 311  loc_elem11  (sub_FFEECAE0)  (0x52,0x18)/(0,0x40).  Confirmed. */
void loc_elem11(u16 *x, u16 *y) { loc_two_row(x, y, 0x52, 0x18, 0x00, 0x40, 1); }
/* FFEECC17-FFEECD4E  size 311  loc_elem12  (sub_FFEECC17)  (0x73,0x18)/(0x1D,0x40).  Confirmed. */
void loc_elem12(u16 *x, u16 *y) { loc_two_row(x, y, 0x73, 0x18, 0x1D, 0x40, 1); }
/* FFEECD4E-FFEECE85  size 311  loc_elem13  (sub_FFEECD4E)  (0x64,0x18)/(0x10,0x40).  Confirmed. */
void loc_elem13(u16 *x, u16 *y) { loc_two_row(x, y, 0x64, 0x18, 0x10, 0x40, 1); }
/* FFEED16E-FFEED293  size 293  loc_elem16  (sub_FFEED16E)  (0x82,0x19)/(0,0x53), no sub 0x12. Confirmed. */
void loc_elem16(u16 *x, u16 *y) { loc_two_row(x, y, 0x82, 0x19, 0x00, 0x53, 0); }

/* FFEECE85-FFEED16E  size 745  loc_elem15  (sub_FFEECE85)  Confirmed. */
void loc_elem15(u16 *x, u16 *y, u16 *c)
{
    LOC_PROLOGUE;
    *x = *y = *c = 0xFFFF;
    if (op == 0xF1) {
        if (sub == 0) {
            if (b4c) { if (type == 1) { if (z) SET3(0xD8, 0x1A, RGB_WHITE); SET3(0x102, 0x3A, RGB_WHITE); }
                       if (type == 2) SET3(0x10B, 0x7C, RGB_GREY); return; }
            if (type == 1) SET3(0x10B, 0x18, RGB_GREY);
            if (type == 2) { if (z) SET3(0xD8, 0x5A, RGB_WHITE); SET3(0x102, 0x7A, RGB_WHITE); }
            return;
        }
        if (sub == 1) SET3(0xD8, 0x1A, RGB_WHITE);
        if (sub == 0x14 || sub == 0x15) { if (z) SET3(0xD8, 0x1A, RGB_WHITE); SET3(0x102, 0x3A, RGB_WHITE); }
        if (sub == 6) SET3(0xEC, 0x17, RGB_WHITE);
        if (sub == 0x0B || sub == 0x12) SET3(0x10B, 0x17, RGB_WHITE);
        if (sub == 0x13) SET3(0x10B, 0x18, RGB_WHITE);
        if (sub == 0x0F) SET3(0xEC, 0x18, RGB_WHITE);
        if (sub == 3 && type != 4) {
            if (type == 1) SET3(0xEC, 0x4D, b4c ? RGB_WHITE : RGB_GREY);
            if (type == 2) SET3(0xEC, 0x84, b4c ? RGB_GREY : RGB_WHITE);
        }
    } else if (op == 0xF8) { if (sub == 0) SET3(0x10B, 0x17, RGB_WHITE); }
    else if (op == 0xFD)   { if (sub == 0) SET3(0x10B, 0x18, RGB_WHITE); }
}

/* FFEED293-FFEED5A7  size 788  loc_elem17  (sub_FFEED293)
 * Returns 1 for the "frequency row" placements (flag var_19), else 0.
 * Confirmed. */
u8 loc_elem17(u16 *x, u16 *y, u16 *c)
{
    LOC_PROLOGUE;
    *x = *y = *c = 0xFFFF;
#define SETF(X, Y, C, F) do { *x = (X); *y = (Y); *c = (C); return (F); } while (0)
    if (op == 0xF1) {
        if (sub == 0) {
            if (b4c) { if (type == 1) { if (z) SETF(0xE7, 0x19, RGB_WHITE, 1); SETF(0x11A, 0x17, RGB_WHITE, 1); }
                       if (type == 2) SETF(0x11A, 0x7B, RGB_GREY, 0); return 0; }
            if (type == 1) SETF(0x11A, 0x17, RGB_GREY, 0);
            if (type == 2) { if (z) SETF(0xE7, 0x59, RGB_WHITE, 1); SETF(0x11A, 0x57, RGB_WHITE, 1); }
            return 0;
        }
        if (sub == 1) SETF(0xE7, 0x19, RGB_WHITE, 1);
        if (sub == 0x14 || sub == 0x15) { if (z) SETF(0xE7, 0x19, RGB_WHITE, 1); SETF(0x11A, 0x17, RGB_WHITE, 1); }
        if (sub == 0x0B || sub == 0x12 || sub == 0x13) SETF(0x11A, 0x17, RGB_WHITE, 0);
        if (sub == 6)    SETF(0xFA, 0x17, RGB_WHITE, 0);
        if (sub == 0x0F) SETF(0xFB, 0x17, RGB_WHITE, 0);
        if (sub == 3 && type != 4) {
            if (type == 1) SETF(0xFB, 0x4D, b4c ? RGB_WHITE : RGB_GREY, 0);
            if (type == 2) SETF(0xFB, 0x84, b4c ? RGB_GREY : RGB_WHITE, 0);
        }
    } else if ((op == 0xF8 || op == 0xFD) && sub == 0) SETF(0x11A, 0x17, RGB_WHITE, 0);
    return 0;
#undef SETF
}

/* FFEED5A7-FFEED748  size 417  loc_elem1E  (sub_FFEED5A7)
 * Lower-row only (type 2) for F100; sub3 x=0xEE.  Confirmed. */
static void loc_1E_1F(u16 *x, u16 *y, u16 *c, u16 xr, u16 x3)
{
    LOC_PROLOGUE;
    *x = *y = *c = 0xFFFF;
    if (op != 0xF1) return;
    if (sub == 0) { if (type == 2) SET3(xr, b4c ? 0x79 : 0x57, b4c ? RGB_GREY : RGB_WHITE); return; }
    if (sub == 1 || sub == 0x12) SET3(xr, 0x17, RGB_WHITE);
    if (sub == 0x14 || sub == 0x15) { if (z) SET3(xr, 0x17, RGB_WHITE); return; }
    if (sub == 3 && type == 2) SET3(x3, 0x84, b4c ? RGB_GREY : RGB_WHITE);
}
void loc_elem1E(u16 *x, u16 *y, u16 *c) { loc_1E_1F(x, y, c, 0x10D, 0xEE); }
/* FFEED748-FFEED8E9  size 417  loc_elem1F  (sub_FFEED748)  same with x 0x11A / 0xFB.  Confirmed. */
void loc_elem1F(u16 *x, u16 *y, u16 *c) { loc_1E_1F(x, y, c, 0x11A, 0xFB); }

/* FFEED8E9-FFEEDB0C  size 547  loc_elem19  (sub_FFEED8E9)  x always 0xBD.  Confirmed. */
void loc_elem19(u16 *x, u16 *y)
{
    LOC_PROLOGUE;
    *x = *y = 0xFFFF;
    if (op == 0xF1) {
        if (sub == 0) { if (type == 1) SET2(0xBD, b4c ? 0x66 : 0x42); if (type == 2) SET2(0xBD, 0xA6); return; }
        if (sub == 1 || sub == 0x15 || sub == 0x14) SET2(0xBD, 0x66);
        if (sub == 6 || sub == 0x0F) SET2(0xBD, 0x3B);
        if (sub == 3) { if (type == 4) SET2(0xBD, 0x38); if (type == 1) SET2(0xBD, 0x6F); if (type == 2) SET2(0xBD, 0xA6); return; }
        if (sub == 0x0B || sub == 0x13) SET2(0xBD, 0x42);
        if (sub == 0x12) SET2(0xBD, 0x57);
    } else if ((op == 0xF8 || op == 0xFD) && sub == 0) SET2(0xBD, 0x42);
}

/* FFEEDB0C-FFEEDD2E  size 546  loc_elem1A  (sub_FFEEDB0C)  Confirmed. */
void loc_elem1A(u16 *x, u16 *y)
{
    LOC_PROLOGUE;
    *x = *y = 0xFFFF;
    if (op == 0xF1) {
        if (sub == 0) { if (type == 1) SET2(0xE4, b4c ? 0x6F : 0x4B); if (type == 2) SET2(0xE4, 0xAF); return; }
        if (sub == 1 || sub == 0x15 || sub == 0x14) SET2(0xE4, 0x6F);
        if (sub == 6 || sub == 0x0F) SET2(0xE1, 0x44);
        if (sub == 0x0B) SET2(0xE4, 0x4B);
        if (sub == 0x12) SET2(0xE1, 0x60);
        if (sub == 0x13) SET2(0xE1, 0x4B);
        if (sub == 3) { if (type == 4) SET2(0xE4, 0x41); if (type == 1) SET2(0xE4, 0x78); if (type == 2) SET2(0xE4, 0xAF); }
    } else if (op == 0xF8) { if (sub == 0) SET2(0xE4, 0x4B); }
    else if (op == 0xFD)   { if (sub == 0) SET2(0xE1, 0x4B); }
}

/* FFEEDD2E-FFEEDF40  size 530  loc_elem1B  (sub_FFEEDD2E)  x always 0.  Confirmed. */
void loc_elem1B(u16 *x, u16 *y)
{
    LOC_PROLOGUE;
    *x = *y = 0xFFFF;
    if (op == 0xF1) {
        if (sub == 0) { if (type == 1) SET2(0, b4c ? 0x64 : 0x40); if (type == 2) SET2(0, 0xA4); return; }
        if (sub == 1 || sub == 0x15 || sub == 0x14) SET2(0, 0x64);
        if (sub == 6 || sub == 0x0F) SET2(0, 0x39);
        if (sub == 0x0B || sub == 0x13) SET2(0, 0x40);
        if (sub == 0x12) SET2(0, 0x55);
        if (sub == 3 && type != 4) { if (type == 1) SET2(0, 0x6D); if (type == 2) SET2(0, 0xA4); }
    } else if ((op == 0xF8 || op == 0xFD) && sub == 0) SET2(0, 0x40);
}

/* FFEEDF40-FFEEE179  size 569  loc_elem1C  (sub_FFEEDF40)  x 0x1C (F3B48: 0xA0).  Confirmed. */
void loc_elem1C(u16 *x, u16 *y)
{
    LOC_PROLOGUE;
    *x = *y = 0xFFFF;
    if (op == 0xF1) {
        if (sub == 0) { if (type == 1) SET2(0x1C, b4c ? 0x6C : 0x48); if (type == 2) SET2(0x1C, 0xAC); return; }
        if (sub == 1 || sub == 0x15 || sub == 0x14) SET2(0x1C, 0x6C);
        if (sub == 6 || sub == 0x0F) SET2(0x1C, 0x41);
        if (sub == 0x0B || sub == 0x13) SET2(0x1C, 0x48);
        if (sub == 0x12) SET2(0x1C, 0x5D);
        if (sub == 3) { if (type == 4) SET2(0x1C, 0x3E); if (type == 1) SET2(0x1C, 0x75); if (type == 2) SET2(0x1C, 0xAC); }
    } else if (op == 0xF3) { if (sub == 0x48) SET2(0xA0, 0x4D); }
    else if ((op == 0xF8 || op == 0xFD) && sub == 0) SET2(0x1C, 0x48);
}

/* FFEEE179-FFEEE512  size 921  loc_main_area  (sub_FFEEE179)
 * Operating-area rectangle: x=0, w=320, h = K - y.  Confirmed. */
void loc_main_area(u16 *x, u16 *y, u16 *w, u16 *h)
{
    LOC_PROLOGUE;
#define AREA(Y, K) do { *x = 0; *y = (Y); *w = 0x140; *h = (u16)((K) - *y); return; } while (0)
    *x = *y = 0xFFFF;
    if (op == 0xF1) {
        if (sub == 0x14 || sub == 0x15 || sub == 1) AREA(0x14, 0x77);
        if (sub == 3) { if (type == 4) AREA(0x14, 0x49); if (type == 1) AREA(0x4A, 0x80); if (type == 2) AREA(0x81, 0xB6); return; }
        if (sub == 4 || sub == 5 || (sub >= 7 && sub <= 10)) AREA(0, 0x20);
        if (sub == 6 || sub == 0x0F) AREA(0x14, 0x4B);
        if (sub == 0x0B || sub == 0x12 || sub == 0x13) AREA(0x14, 0x53);
        if (sub == 0) {                               /* z irrelevant: both arms equal */
            if (b4c) { if (type == 1) AREA(0x14, 0x77); if (type == 2) AREA(0x78, 0xB6); }
            else     { if (type == 1) AREA(0x14, 0x53); if (type == 2) AREA(0x54, 0xB6); }
        }
    } else if (op == 0xF8) { if (sub == 0) AREA(0x14, 0x53); }
    else if (op == 0xF7)   { if (sub == 1) AREA(0x14, 0x4B); }
    else if (op == 0xFD)   { if (sub == 0) AREA(0x14, 0x53); }
#undef AREA
}

/* FFEEE512-FFEEE7AB  size 665  loc_multislot_layout  (sub_FFEEE512)
 * Caller FFEF6E12 (inside FFEF6C42, doc 31 Routine B): position and the
 * "sub-layout code 0..5" that selects one of the six draw blocks.  Here the
 * record test is m == 0 (not m in {0,2}).  Confirmed. */
void loc_multislot_layout(u16 *x, u16 *y, u8 *lay)
{
    LOC_PROLOGUE;
#define LAY(X, Y, L) do { *x = (X); *y = (Y); *lay = (L); return; } while (0)
    *x = *y = 0xFFFF;
    if (op == 0xF1) {
        if (sub == 0x14 || sub == 0x15) { if (m == 0) LAY(0, 0x2D, 0); LAY(0x29, 0x3B, 1); }
        if (sub == 1) LAY(0, 0x2D, 0);
        if (sub == 3) { if (type == 4) LAY(0x30, 0x16, 2); if (type == 1) LAY(0x30, 0x4D, b4c ? 2 : 4);
                        if (type == 2) LAY(0x30, 0x84, b4c ? 4 : 2); return; }
        if (sub == 6 || sub == 0x0F) LAY(0x30, 0x17, 2);
        if (sub == 0x0B || sub == 0x13) LAY(0x29, 0x17, 1);
        if (sub == 0x12) LAY(0x29, 0x32, 5);
        if (sub == 0) {
            if (m == 0) { if (b4c) { if (type == 1) LAY(0, 0x2D, 0);    if (type == 2) LAY(0x29, 0x7B, 3); }
                          else     { if (type == 1) LAY(0x29, 0x17, 3); if (type == 2) LAY(0, 0x6C, 0); } }
            else        { if (b4c) { if (type == 1) LAY(0x29, 0x3B, 1); if (type == 2) LAY(0x29, 0x7B, 3); }
                          else     { if (type == 1) LAY(0x29, 0x17, 3); if (type == 2) LAY(0x29, 0x7B, 1); } }
        }
    } else if (op == 0xF7) { if (sub == 1) LAY(0x29, 0x2C, 5); }
    else if ((op == 0xF8 || op == 0xFD) && sub == 0) LAY(0x29, 0x17, 1);
#undef LAY
}

/* FFEEE7AB-FFEEE970  size 453  loc_FFEEE7AB  (sub_FFEEE7AB)
 * Caller FFEF6B10 (multi-slot cluster); x always 0x10D.  Confirmed. */
void loc_FFEEE7AB(u16 *x, u16 *y, u16 *c)
{
    LOC_PROLOGUE;
    *x = *y = *c = 0xFFFF;
    if (op == 0xF1) {
        if (sub == 0) { if (type == 1) { if (b4c) SET3(0x10D, 0x17, RGB_WHITE); SET3(0x10D, 0x15, RGB_GREY); } return; }
        if (sub == 0x0B || sub == 0x12 || sub == 0x13) SET3(0x10D, 0x15, RGB_WHITE);
        if (sub == 1 || sub == 0x15 || sub == 0x14) SET3(0x10D, 0x17, RGB_WHITE);
    } else if ((op == 0xF8 || op == 0xFD) && sub == 0) SET3(0x10D, 0x15, RGB_WHITE);
}

/* FFEEE970-FFEEED50  size 992  loc_elem18_pair  (sub_FFEEE970)
 * Two points (x1,y1)-(x2,y2) + colour; callers ev_elem18_pair, FFEF568E.
 * Several branches set only (x1,y1) and colour, leaving x2/y2 0xFFFF.
 * Confirmed. */
void loc_elem18_pair(u16 *x1, u16 *y1, u16 *x2, u16 *y2, u16 *c)
{
    LOC_PROLOGUE;
#define P4(A, B, C2, D, K) do { *x1 = (A); *y1 = (B); *x2 = (C2); *y2 = (D); *c = (K); return; } while (0)
#define P2(A, B, K)        do { *x1 = (A); *y1 = (B); *c = (K); return; } while (0)
    *x1 = *y1 = *x2 = *y2 = *c = 0xFFFF;
    if (op == 0xF1) {
        if (sub == 0) {
            if (z) {
                if (b4c) { if (type == 1) P4(0xDD, 0x17, 0x110, 0x17, RGB_WHITE);
                           if (type == 2 && m != 2) P2(0x110, 0x79, RGB_GREY); return; }
                if (type == 1) { if (m != 2) P2(0x110, 0x15, RGB_GREY); return; }
                if (type == 2) P4(0xDD, 0x57, 0x110, 0x57, RGB_WHITE);
                return;
            }
            if (b4c) { if (type == 1) P4(0x110, 0x17, 0x110, 0x2D, RGB_WHITE);
                       if (type == 2) P2(0x110, 0x79, RGB_GREY); return; }
            if (type == 1) P2(0x110, 0x15, RGB_GREY);
            if (type == 2) P4(0x110, 0x57, 0x110, 0x6D, RGB_WHITE);
            return;
        }
        if (sub == 1) P4(0xDD, 0x17, 0x110, 0x17, RGB_WHITE);
        if (sub == 0x14 || sub == 0x15) { if (z) P4(0xDD, 0x17, 0x110, 0x17, RGB_WHITE); P4(0x110, 0x17, 0x110, 0x2D, RGB_WHITE); }
        if (sub == 6)    { if (m != 2) P2(0xF1, 0x17, RGB_WHITE); return; }
        if (sub == 0x0B || sub == 0x13) { if (m != 2) P2(0x110, 0x16, RGB_WHITE); return; }
        if (sub == 0x12) P4(0x110, 0x15, 0x110, 0x29, RGB_WHITE);
        if (sub == 0x0F) P2(0xF1, 0x17, RGB_WHITE);
        if (sub == 3 && m != 2 && type != 4) {
            if (type == 1) P2(0xF1, 0x4D, b4c ? RGB_WHITE : RGB_GREY);
            if (type == 2) P2(0xF1, 0x84, b4c ? RGB_GREY : RGB_WHITE);
        }
    } else if (op == 0xF7) { if (sub == 1) P4(0xDD, 0x17, 0x110, 0x17, RGB_WHITE); }
    else if (op == 0xF8)   { if (sub == 0 && m != 2) P2(0x110, 0x15, RGB_WHITE); }
    else if (op == 0xFD)   { if (sub == 0) P2(0x110, 0x16, RGB_WHITE); }
#undef P4
#undef P2
}
/* end of range 0xFFEEED50 */
