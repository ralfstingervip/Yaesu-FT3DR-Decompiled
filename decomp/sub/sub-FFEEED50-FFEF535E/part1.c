
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
