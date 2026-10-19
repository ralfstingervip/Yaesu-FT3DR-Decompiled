
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
