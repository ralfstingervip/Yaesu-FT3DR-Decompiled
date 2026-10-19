
/* ==========================================================================
 * Surfaces, frames and framebuffer primitives.  Every primitive addresses
 * cur_surface->base + ((y+row)*320 + x+col)*2, i.e. absolute screen
 * coordinates inside a full-screen buffer.  "Erase" means "copy back from
 * the background layer BASE_FRAME (0x07000000)".
 * ======================================================================== */

/* FFEF032D-FFEF036F  size 66  surface_main_init (alias sub_FFEF032D)
 * 59 callers (each screen's background phase).  Points the main surface at
 * the background layer itself, full screen, and makes it current.
 * Confidence: Confirmed (doc 51 agrees) */
void surface_main_init(void)
{
    main_surface.base = BASE_FRAME;
    main_surface.r.x = 0; main_surface.r.y = 0;
    main_surface.r.w = LCD_W; main_surface.r.h = LCD_H;
    cur_surface = &main_surface;
}

/* FFEF036F-FFEF0385  size 22  surface_main_commit (alias sub_FFEF036F)
 * 253 callers.  Queue the main surface for the LCD and advance the screen
 * phase (handlers in phase 3 rely on the phase>=4 clamp).    Confirmed */
void surface_main_commit(void)
{
    lcd_flush_enqueue(&main_surface);
    screen_phase++;
}

/* FFEF0385-FFEF039B  size 22  ui_pending_load (alias sub_FFEF0385)
 * Sole caller sub_FFEDC1F6 (IPC ring dequeue): copy one 300-byte frame
 * slot into ui_pending (doc 51/43: the only writer of 0x8E46).  Confirmed */
void ui_pending_load(const u8 *frame) { memcpy_b(ui_pending, frame, 0x12C); }

/* FFEF039B-FFEF03BC  size 33  ui_frames_clear (alias sub_FFEF039B)
 * Caller: sub_FFEDEF41.                                    Confirmed */
void ui_frames_clear(void)
{
    memset_b(ui_shadow, 0, 0x12C);
    memset_b(ui_pending, 0, 0x12C);
}

/* FFEF03BC-FFEF03DA  size 30  base_pixel_addr (alias dead_FFEF03BC)
 * Dead.  Returns 0x07000000 + y*320 + x - note: no *2, so a byte address
 * that is wrong for a 16-bit frame (the live twin below doubles it). Confirmed */
u32 base_pixel_addr(u16 x, u16 y) { return 0x07000000u + (u32)y * LCD_W + x; }

/* FFEF03DA-FFEF0408  size 46  base_pixel_read (alias dead_FFEF03DA)     Confirmed */
u16 base_pixel_read(u16 x, u16 y) { return BASE_FRAME[(u32)y * LCD_W + x]; }

/* FFEF0408-FFEF0453  size 75  surface_fill_from_base (alias sub_FFEF0408)
 * 60 callers; doc 06 "sub_FFEF0408(0,0) blanks the screen".  x and y are
 * stored but unused: the whole 320x240 background layer is copied into the
 * current surface (surface_xform_copy mode 0x0E = plain copy). Confirmed */
void surface_fill_from_base(u16 x, u16 y)
{
    surface_t src = { 0, 0, {0, 0, LCD_W, LCD_H}, 0, BASE_FRAME };
    surface_t dst = src;
    (void)x; (void)y;
    dst.base = cur_surface->base;
    surface_xform_copy(&src, &src.r, 0x0E, &dst, &dst.r);
}

/* FFEF0453-FFEF04F7  size 164  base_put_bitmap (alias sub_FFEF0453)
 * Caller: sub_FFEDE8F8.  Opaque copy of a bitmap into the BACKGROUND layer
 * (not the current surface); clipped by size only.          Confirmed */
void base_put_bitmap(u16 x, u16 y, const bmp_desc_t *b)
{
    u16 w = b->w, h = b->h;
    if (w > LCD_W - x || h > LCD_H - y) return;
    for (u16 r = 0; r < h; r++)
        for (u16 c = 0; c < w; c++)
            BASE_FRAME[(u32)(y + r) * LCD_W + x + c] = b->pix[(u32)w * r + c];
}

/* FFEF04F7-FFEF0553  size 92  gfx_erase_rect (alias sub_FFEF04F7)
 * 132 callers ("clears a 320-pixel region", docs 12/13).  Restores the
 * rectangle from the background layer into the current surface. Confirmed */
void gfx_erase_rect(u16 x, u16 y, u16 w, u16 h)
{
    surface_t src = { 0, 0, {0, 0, LCD_W, LCD_H}, 0, BASE_FRAME };
    surface_t dst = src;
    rect_t r = { x, y, w, h };
    dst.base = cur_surface->base;
    surface_xform_copy(&src, &r, 0x0E, &dst, &r);
}

/* FFEF0553-FFEF0581  size 46  gfx_fill_rect_white (alias sub_FFEF0553)
 * Caller: sub_FFEFA78C.                                     Confirmed */
void gfx_fill_rect_white(u16 x, u16 y, u16 w, u16 h)
{
    rect_t r = { x, y, w, h };
    surface_fill_rect(cur_surface, &r, 0xFFFF);
}

/* FFEF0581-FFEF05DD  size 92  surface_fill_rect (alias sub_FFEF0581)  Confirmed */
void surface_fill_rect(surface_t *s, const rect_t *r, u16 colour)
{
    for (u16 row = 0; row < r->h; row++)
        for (u16 col = 0; col < r->w; col++)
            s->base[(u32)(r->y + row) * LCD_W + r->x + col] = colour;
}

/* FFEF05DD-FFEF0648  size 107  surface_recolour (alias dead_FFEF05DD)
 * Dead (doc 78/89: FFEF05DD+FFEF0609 are one nested-loop function).
 * Replace colour `from` by `to` inside rectangle r of the current surface.
 * Confidence: Confirmed */
void surface_recolour(const rect_t *r, u16 from, u16 to)
{
    for (u16 row = 0; row < r->h; row++)
        for (u16 col = 0; col < r->w; col++) {
            u16 *p = &cur_surface->base[(u32)(r->y + row) * LCD_W + r->x + col];
            if (*p == from) *p = to;
        }
}

/* Shared helpers for the blitters below (not functions in the image). */
#define CLIPPED(x,y,w,h) ((w) > LCD_W - (x) || (h) > LCD_H - (y))
#define FB(x,y)          (cur_surface->base[(u32)(y) * LCD_W + (x)])
static inline u16 blend565(u16 c0, u16 c100, u8 pct)
{   /* channel-wise c0 + (c100-c0)*pct/100, as FFEF0730..FFEF077D */
    s32 r0 = c0 >> 11, g0 = (c0 & 0x7E0) >> 5, b0 = c0 & 0x1F;
    s32 r1 = c100 >> 11, g1 = (c100 & 0x7E0) >> 5, b1 = c100 & 0x1F;
    return RGB565((u8)(r0 + (r1 - r0) * pct / 100), (u8)(g0 + (g1 - g0) * pct / 100),
                  (u8)(b0 + (b1 - b0) * pct / 100));
}
static inline u8 half_toward(u8 c, u8 t)   /* FFEF12EE..: t +/- |c-t|*50/100 */
{ return (c > t) ? (u8)(t + (c - t) * 50 / 100) : (u8)(t - (t - c) * 50 / 100); }

/* FFEF0648-FFEF0949  size 769  gfx_draw_bitmap (alias sub_FFEF0648)
 * 30 direct callers + sub_FFEF68D5 (x176): the RGB565 sprite blit (doc 16).
 * Clips by size; mode 1: source pixel = intensity, output = blend from key
 * (0%) to tint (100%); mode 2: bitwise-inverted source; otherwise key-colour
 * transparency with a 2-pixel (32-bit) fast path.            Confirmed */
void gfx_draw_bitmap(u16 x, u16 y, const bmp_desc_t *d)
{
    u16 w, h, key, row, col;
    if (d == 0) return;
    w = d->w; h = d->h;
    if (CLIPPED(x, y, w, h)) return;
    key = d->key;
    if (d->mode == 1) {
        for (row = 0; row < h; row++)
            for (col = 0; col < w; col++) {
                u16 p = d->pix[(u32)w * row + col];
                if (p == key) continue;
                FB(x + col, y + row) = blend565(key, d->tint, (u8)(p * 100u / 0xFFFFu));
            }
    } else if (d->mode == 2) {
        for (row = 0; row < h; row++)
            for (col = 0; col < w; col++) {
                u16 p = d->pix[(u32)w * row + col];
                if (p != key) FB(x + col, y + row) = (u16)~p;
            }
    } else {
        for (row = 0; row < h; row++)
            for (col = 0; col < w; col++) {
                const u16 *s = &d->pix[(u32)w * row + col];
                u16 *o = &FB(x + col, y + row);
                if (col + 1 < w) {
                    if (s[0] != key && s[1] != key) *(u32 *)o = *(const u32 *)s;
                    else if (!(s[0] == key && s[1] == key)) {
                        if (s[0] == key) o[1] = s[1]; else o[0] = s[0];
                    }
                    col++;                         /* two pixels per step */
                } else if (s[0] != key) {
                    o[0] = s[0];
                }
            }
    }
}

/* Row-span lookup shared by the two "rounded" routines (FFEF09AE, FFEF0C3A). */
static inline void rounded_span(u16 w, u16 h, u16 row, u16 *start, u16 *end)
{
    const span_t *t = 0;
    switch (h) {
    case 0x34: t = span_h34; break;   case 0x26: t = span_h26; break;
    case 0x1C: t = span_h1C; break;   case 0x14: t = span_h14; break;
    case 0x10: t = span_h10; break;
    }
    if (t) { *start = t[row].start; *end = t[row].end; }
    else   { *start = 0; *end = w - 1; }
}

/* FFEF0949-FFEF0AFE  size 437  gfx_blit_rounded (alias sub_FFEF0949)
 * Caller: sub_FFEF690B (text/number box, doc 31).  Opaque copy of the
 * bitmap but only between per-row start/end columns taken from 6-byte
 * span tables for the five box heights 0x10/0x14/0x1C/0x26/0x34 (rounded
 * ends); other heights copy whole rows.  Copies in 32-bit pairs, so a span
 * always moves at least one pair.                            Confirmed */
void gfx_blit_rounded(u16 x, u16 y, const bmp_desc_t *d)
{
    u16 s, e, n, row, k;
    if (d == 0) return;
    if (CLIPPED(x, y, d->w, d->h)) return;
    for (row = 0; row < d->h; row++) {
        rounded_span(d->w, d->h, row, &s, &e);
        const u32 *src = (const u32 *)&d->pix[(u32)d->w * row + s];
        u32 *dst = (u32 *)&FB(x + s, y + row);
        n = (u16)((e - s + 1) / 2);
        *dst = *src;
        for (k = 1; k < n; k++) *++dst = *++src;
    }
}

/* FFEF0AFE-FFEF0BD4  size 214  gfx_erase_shape (alias sub_FFEF0AFE)
 * Caller: sub_FFEF6C42 (x40, doc 31 "bitmap compositor").  For every
 * non-key pixel of the bitmap, restore the background-layer pixel at that
 * screen position: erases exactly the shape a previous blit drew. Confirmed */
void gfx_erase_shape(u16 x, u16 y, const bmp_desc_t *d)
{
    if (d == 0 || CLIPPED(x, y, d->w, d->h)) return;
    for (u16 row = 0; row < d->h; row++)
        for (u16 col = 0; col < d->w; col++) {
            u32 off = (u32)(y + row) * LCD_W + x + col;
            if (d->pix[(u32)d->w * row + col] != d->key)
                cur_surface->base[off] = BASE_FRAME[off];
        }
}

/* FFEF0BD4-FFEF0D92  size 446  gfx_erase_rounded (alias sub_FFEF0BD4)
 * Caller: sub_FFEF690B.  Same spans as gfx_blit_rounded but the source is
 * the background layer at the same screen offset (descriptor supplies only
 * w and h).                                                   Confirmed */
void gfx_erase_rounded(u16 x, u16 y, const bmp_desc_t *d)
{
    u16 s, e, n, row, k;
    if (d == 0 || CLIPPED(x, y, d->w, d->h)) return;
    for (row = 0; row < d->h; row++) {
        rounded_span(d->w, d->h, row, &s, &e);
        u32 off = (u32)(y + row) * LCD_W + x + s;
        const u32 *src = (const u32 *)&BASE_FRAME[off];
        u32 *dst = (u32 *)&cur_surface->base[off];
        n = (u16)((e - s + 1) / 2);
        *dst = *src;
        for (k = 1; k < n; k++) *++dst = *++src;
    }
}

/* FFEF0D92-FFEF0FCC  size 570  gfx_draw_bitmap_whites (alias sub_FFEF0D92)
 * Caller: sub_FFEFAB3E (coloured text).  Modes 1 and 2 as gfx_draw_bitmap;
 * the default mode copies only source pixels equal to 0xFFFF (no key
 * test) - used for white-on-transparent glyph art.          Confirmed */
void gfx_draw_bitmap_whites(u16 x, u16 y, const bmp_desc_t *d)
{
    if (d == 0 || CLIPPED(x, y, d->w, d->h)) return;
    for (u16 row = 0; row < d->h; row++)
        for (u16 col = 0; col < d->w; col++) {
            u16 p = d->pix[(u32)d->w * row + col];
            if (d->mode == 1) { if (p != d->key) FB(x + col, y + row) = blend565(d->key, d->tint, (u8)(p * 100u / 0xFFFFu)); }
            else if (d->mode == 2) { if (p != d->key) FB(x + col, y + row) = (u16)~p; }
            else if (p == 0xFFFF) FB(x + col, y + row) = p;
        }
}

/* FFEF0FCC-FFEF121F  size 595  gfx_draw_bitmap_2x (alias sub_FFEF0FCC)
 * Caller: sub_FFEE4BB7.  Pixel-doubled gfx_draw_bitmap (no 32-bit fast
 * path).  Quirk: the clip test uses 4*w and 4*h (the doubled size doubled
 * again), so it rejects sprites that would still fit.         Confirmed */
void gfx_draw_bitmap_2x(u16 x, u16 y, const bmp_desc_t *d)
{
    u16 W, H;
    if (d == 0) return;
    W = (u16)(d->w << 1); H = (u16)(d->h << 1);
    if ((u32)W * 2 > LCD_W - x || (u32)H * 2 > LCD_H - y) return;
    for (u16 row = 0; row < H; row++)
        for (u16 col = 0; col < W; col++) {
            u16 p = d->pix[(u32)(W >> 1) * (row >> 1) + (col >> 1)];
            if (p == d->key) continue;
            if (d->mode == 1)      FB(x + col, y + row) = blend565(d->key, d->tint, (u8)(p * 100u / 0xFFFFu));
            else if (d->mode == 2) FB(x + col, y + row) = (u16)~p;
            else                   FB(x + col, y + row) = p;
        }
}

/* FFEF121F-FFEF13A1  size 386  gfx_draw_bitmap_dim (alias sub_FFEF121F)
 * Callers: widget_draw, sub_FFF0C46F.  Key-transparent blit with every
 * channel pulled half-way toward grey (13,27,13) = 0x6B6D: the "disabled /
 * inactive" look of widget icons.                             Confirmed */
void gfx_draw_bitmap_dim(u16 x, u16 y, const bmp_desc_t *d)
{
    if (d == 0 || CLIPPED(x, y, d->w, d->h)) return;
    for (u16 row = 0; row < d->h; row++)
        for (u16 col = 0; col < d->w; col++) {
            u16 p = d->pix[(u32)d->w * row + col];
            if (p == d->key) continue;
            FB(x + col, y + row) = RGB565(half_toward(p >> 11, 0x0D),
                                          half_toward((p & 0x7E0) >> 5, 0x1B),
                                          half_toward(p & 0x1F, 0x0D));
        }
}

/* FFEF13A1-FFEF153B  size 410  gfx_draw_bitmap_dark (alias dead_FFEF13A1)
 * Dead (doc 127).  As above but toward black, and a pure-white source pixel
 * is first rewritten IN THE SOURCE to red 0xF800 (a write to the bitmap,
 * harmless only because flash ignores it) and treated as (31,0,0). Confirmed */
void gfx_draw_bitmap_dark(u16 x, u16 y, const bmp_desc_t *d)
{
    if (d == 0 || CLIPPED(x, y, d->w, d->h)) return;
    for (u16 row = 0; row < d->h; row++)
        for (u16 col = 0; col < d->w; col++) {
            u16 *s = (u16 *)&d->pix[(u32)d->w * row + col];
            u8 r, g, b;
            if (*s == d->key) continue;
            if (*s == 0xFFFF) { *s = 0xF800; r = 0x1F; g = 0; b = 0; }
            else { r = *s >> 11; g = (*s & 0x7E0) >> 5; b = *s & 0x1F; }
            FB(x + col, y + row) = RGB565(half_toward(r, 0), half_toward(g, 0), half_toward(b, 0));
        }
}
