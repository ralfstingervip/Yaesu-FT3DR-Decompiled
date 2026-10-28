
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
