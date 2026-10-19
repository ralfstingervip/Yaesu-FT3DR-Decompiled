
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
