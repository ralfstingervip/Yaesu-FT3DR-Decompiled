
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
