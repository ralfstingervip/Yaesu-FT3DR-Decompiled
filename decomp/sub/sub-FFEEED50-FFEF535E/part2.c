
/* ==========================================================================
 * LCD flush pipeline.  Drawing goes into one off-screen 320x240 buffer
 * (0x0704B000); surface_begin claims it and records the dirty rectangle,
 * surface_main_commit queues it, lcd_flush_poll (main loop) DMAs the
 * rectangle to the LCD and frees the buffer when EXDMAC0 reports done.
 * ======================================================================== */

/* FFEEF94F-FFEEF9BB  size 108  lcd_flush_poll (alias sub_FFEEF94F)
 * Callers: sub_FFEDE897, sub_FFEDF016 (main loop).        Confidence: Confirmed
 * flush_job.state: 0 idle -> 1 job copied from queue -> 2 DMA running.  After a
 * frame completes with the display flag (0x8A8A) still 0 it steps the
 * display-on sequencer (0x8A87 = 2; Inferred: "first frame ready, enable"). */
void lcd_flush_poll(void)
{
    switch (flush_job.state) {
    case 0:
        if (lcd_flush_peek(&flush_job) != 1) return;
        flush_job.state = 1;
        /* fall through */
    case 1:
        lcd_flush_start(&flush_job);
        flush_job.state = 2;
        return;
    case 2:
        if (exdmac0_done() != 1) return;
        flush_job.state = 0;
        lcd_flush_retire_head();
        if (lcd_display_flag() == 0) lcd_seq_set(2);
        return;
    }
}

/* FFEEF9BB-FFEEFA62  size 167  surface_begin (alias sub_FFEEF9BB)
 * 256 callers (every screen's redraw).  Doc 12 read it as a "display-update
 * predicate"; it is the allocator: claim a free off-screen slot (only slot 0
 * exists: the loop runs i<=0), point desc at it, record the dirty rectangle
 * and make desc the current surface.  Returns 1 on success, 0 when w or h is
 * zero or the buffer is still waiting for its flush.        Confidence: Confirmed */
u8 surface_begin(surface_t *desc, u16 x, u16 y, u16 w, u16 h /* stack */)
{
    u8 ok = 0;
    if (w == 0 || h == 0) return 0;
    for (u8 i = 0; i <= 0; i++) {
        if (surface_busy[i] != 0) continue;
        surface_busy[i] = 1;
        desc->state = 0;
        desc->slot  = i;
        desc->base  = (u16 *)((u8 *)OFFSCREEN0 + i * SLOT_STRIDE);
        desc->r.x = x; desc->r.y = y; desc->r.w = w; desc->r.h = h;
        ok = 1;
        cur_surface = desc;
        break;
    }
    return ok;
}

/* FFEEFA62-FFEEFA75  size 19  surface_release (alias dead_FFEEFA62)
 * No caller (dead).  Frees desc's slot.                   Confidence: Confirmed */
void surface_release(surface_t *desc) { surface_busy[desc->slot] = 0; }

/* FFEEFA75-FFEEFA9E  size 41  lcd_flush_init (alias sub_FFEEFA75)
 * Callers: sub_FFEDEEFC, sub_FFEDF677.  Note the queue clear starts at
 * 0x1D3CD (entry byte 1), 16 bytes.                       Confidence: Confirmed */
void lcd_flush_init(void)
{
    memset_b(surface_busy, 0, 1);
    memset_b((u8 *)flush_queue + 1, 0, 0x10);
    flush_count = 0;
}

/* FFEEFA9E-FFEEFB66  size 200  lcd_flush_enqueue (alias sub_FFEEFA9E)
 * Callers: sub_FFEDE590, surface_main_commit, sub_FFF0B1DB, sub_FFF3CAD0.
 * Queue depth is 1: a second enqueue while one is pending is dropped.
 * Confidence: Confirmed */
void lcd_flush_enqueue(const surface_t *s)
{
    if (flush_count > 0) return;
    surface_t *q = &flush_queue[flush_count];
    q->state = 0;
    q->slot  = s->slot;
    q->r     = s->r;
    q->base  = s->base;
    flush_count++;
}

/* FFEEFB66-FFEEFB84  size 30  lcd_flush_queue_empty (alias sub_FFEEFB66)   Confirmed */
u8 lcd_flush_queue_empty(void) { return flush_count == 0 ? 1 : 0; }

/* FFEEFB84-FFEEFBA3  size 31  lcd_flush_queue_busy (alias sub_FFEEFB84)
 * 58 callers: every screen's phase-3 service tests it.     Confirmed */
u8 lcd_flush_queue_busy(void) { return (s8)flush_count > 0 ? 1 : 0; }

/* FFEEFBA3-FFEEFC15  size 114  lcd_flush_peek (alias sub_FFEEFBA3)
 * Copy the head entry to *out (all 16 bytes incl. state 0); 1 if one existed.
 * Confidence: Confirmed */
u8 lcd_flush_peek(surface_t *out)
{
    if (flush_count == 0) return 0;
    *out = flush_queue[0];
    return 1;
}

/* FFEEFC15-FFEEFC2C  size 23  lcd_flush_retire_head (alias sub_FFEEFC15)
 * Free the flushed slot and pop the queue.                Confidence: Confirmed */
void lcd_flush_retire_head(void)
{
    surface_busy[flush_queue[0].slot] = 0;
    lcd_flush_dequeue();
}

/* FFEEFC2C-FFEEFD64  size 312  lcd_flush_dequeue (alias sub_FFEEFC2C)
 * Generic shift-down pop (written for a deeper queue than the 1 used).
 * Confidence: Confirmed */
void lcd_flush_dequeue(void)
{
    u8 i;
    if (flush_count == 0) return;
    if (flush_count == 1) {
        flush_queue[0].slot = 0; flush_queue[0].r = (rect_t){0,0,0,0};
        flush_queue[0].base = 0; flush_count = 0;
        return;
    }
    for (i = 0; i < flush_count - 1; i++) {
        flush_queue[i].slot = flush_queue[i + 1].slot;
        flush_queue[i].r    = flush_queue[i + 1].r;
        flush_queue[i].base = flush_queue[i + 1].base;
    }
    flush_queue[i].slot = 0; flush_queue[i].r = (rect_t){0,0,0,0};
    flush_queue[i].base = 0;
    flush_count--;
}

/* ==========================================================================
 * UI soft timers: a 4-entry group registered with the generic timer service
 * at sub_FFEE1229 (4 groups of {n, counters, reloads} at 0x1CDE4).
 * ======================================================================== */

/* FFEEFD64-FFEEFD91  size 45  ui_timers_init (alias sub_FFEEFD64)
 * Caller: sub_FFEDEEF1.                                   Confidence: Confirmed */
void ui_timers_init(void)
{
    memcpy_b(ui_timer_reload, ui_timer_reload_init, 8);
    ui_timer_group = timer_group_register(4, ui_timer_cnt, ui_timer_reload);
}

/* FFEEFD91-FFEEFDA5  size 20  ui_timer_start (alias sub_FFEEFD91)   Confirmed */
void ui_timer_start(u32 idx) { timer_group_start(ui_timer_group, (u16)idx); }

/* FFEEFDA5-FFEEFDB9  size 20  ui_timer_stop (alias sub_FFEEFDA5)    Confirmed */
void ui_timer_stop(u32 idx)  { timer_group_stop(ui_timer_group, (u16)idx); }

/* FFEEFDB9-FFEEFDDA  size 33  ui_timer_expired (alias sub_FFEEFDB9)
 * 1 when counter idx has reached 0 (decremented elsewhere).  Confirmed */
u8 ui_timer_expired(u32 idx) { return ui_timer_cnt[idx] == 0 ? 1 : 0; }

/* FFEEFDDA-FFEEFDED  size 19  ui_timer_set_reload (alias sub_FFEEFDDA)  Confirmed */
void ui_timer_set_reload(u32 idx, u16 v) { ui_timer_reload[idx] = v; }

/* ==========================================================================
 * UI redraw events: a 64-bit mask, ui_event[0] = events 0..31, ui_event[1] =
 * events 32..63.  Reconcilers post bits; the active screen's phase-3 handler
 * takes one at a time (ui_event_next), acks it and calls its table entry.
 * Doc 31/50 called FFEEFEA4/FFEEFEEE "dirty flags"; they are this mask.
 * "field/kind" form (FFEEFE0E): kind 0 -> lo |= field (raw mask);
 * kind 1 or 3 -> lo |= 0x8000<<field; kind 2 -> hi |= 1<<field.
 * ======================================================================== */

/* FFEEFDED-FFEEFE0E  size 33  ui_event_post2 (alias sub_FFEEFDED)
 * Caller: dead_FFEF212D only.                             Confirmed */
void ui_event_post2(u32 hi, u32 lo) { ui_event[0] |= lo; ui_event[1] |= hi; }

/* FFEEFE0E-FFEEFE52  size 68  ui_event_post_field (alias sub_FFEEFE0E)   Confirmed */
void ui_event_post_field(u32 field, u8 kind)
{
    switch (kind) {
    case 0:          ui_event_post_lo(field);              return;
    case 1: case 3:  ui_event_post_lo(0x8000u << field);   return;
    case 2:          ui_event_post_hi(1u << field);        return;
    }
}

/* FFEEFE52-FFEEFEA4  size 82  ui_event_post_shifted (alias dead_FFEEFE52)
 * Dead.  mask<<bit into the 64-bit set when bit<=0x3F and bit<=limit. Confirmed */
void ui_event_post_shifted(u32 mask, u8 bit, u8 limit)
{
    if (!(bit <= 0x3F && bit <= limit)) return;
    if (bit <= 0x1F) ui_event[0] |= mask << bit;
    else             ui_event[1] |= mask << (bit - 0x20);
}

/* FFEEFEA4-FFEEFEB5  size 17  ui_event_post_lo (alias sub_FFEEFEA4)
 * 63 callers.                                             Confidence: Confirmed */
void ui_event_post_lo(u32 mask) { ui_event[0] |= mask; }

/* FFEEFEB5-FFEEFEEE  size 57  ui_event_post_lo_shifted (alias dead_FFEEFEB5)  Confirmed */
void ui_event_post_lo_shifted(u32 mask, u8 bit, u8 limit)
{
    if (bit <= 0x1F && bit <= limit) ui_event[0] |= mask << bit;
}

/* FFEEFEEE-FFEEFF00  size 18  ui_event_post_hi (alias sub_FFEEFEEE)
 * 25 callers.  Doc 31: "*(u32*)0x1D3B4 |= arg" - same cell.   Confirmed */
void ui_event_post_hi(u32 mask) { ui_event[1] |= mask; }

/* FFEEFF00-FFEEFF25  size 37  ui_event_clear2 (alias dead_FFEEFF00)          Confirmed */
void ui_event_clear2(u32 hi, u32 lo) { ui_event[0] &= ~lo; ui_event[1] &= ~hi; }

/* FFEEFF25-FFEEFF38  size 19  ui_event_clear_lo (alias sub_FFEEFF25)         Confirmed */
void ui_event_clear_lo(u32 mask) { ui_event[0] &= ~mask; }

/* FFEEFF38-FFEEFF4C  size 20  ui_event_clear_hi (alias sub_FFEEFF38)         Confirmed */
void ui_event_clear_hi(u32 mask) { ui_event[1] &= ~mask; }

/* FFEEFF4C-FFEEFF90  size 68  ui_event_clear_field (alias sub_FFEEFF4C)
 * Inverse of ui_event_post_field.                         Confirmed */
void ui_event_clear_field(u32 field, u8 kind)
{
    switch (kind) {
    case 0:          ui_event_clear_lo(field);             return;
    case 1: case 3:  ui_event_clear_lo(0x8000u << field);  return;
    case 2:          ui_event_clear_hi(1u << field);       return;
    }
}

/* FFEEFF90-FFEEFF9E  size 14  ui_event_get_lo (alias sub_FFEEFF90)   Confirmed */
u32 ui_event_get_lo(void) { return ui_event[0]; }

/* FFEEFF9E-FFEEFFAC  size 14  ui_event_get_hi (alias sub_FFEEFF9E)   Confirmed */
u32 ui_event_get_hi(void) { return ui_event[1]; }

/* FFEEFFAC-FFEEFFEA  size 62  ui_event_set (alias dead_FFEEFFAC)     Confirmed */
void ui_event_set(u8 n)
{
    if (n <= 0x1F)      ui_event[0] |= bit_u32(n);
    else if (n <= 0x3F) ui_event[1] |= bit_u32(n - 0x20);
}

/* FFEEFFEA-FFEF002C  size 66  ui_event_ack (alias sub_FFEEFFEA)
 * 58 callers (every phase-3 service).                     Confirmed */
void ui_event_ack(u8 n)
{
    if (n <= 0x1F)      ui_event[0] &= ~bit_u32(n);
    else if (n <= 0x3F) ui_event[1] &= ~bit_u32(n - 0x20);
}

/* FFEF002C-FFEF003F  size 19  ui_event_clear_all (alias sub_FFEF002C)  Confirmed */
void ui_event_clear_all(void) { ui_event[0] = 0; ui_event[1] = 0; }

/* FFEF003F-FFEF0163  size 292  ui_event_next (alias sub_FFEF003F)
 * 59 callers.  Returns 0xFF while ui_hold is set or while a new screen
 * selector byte [0x13] is pending (the screen is about to change).  Fixed
 * priority list first, then any hi-word event (32+n), then any lo event.
 * Confidence: Confirmed */
u8 ui_event_next(void)
{
    u8 n;
    if (ui_hold != 0 || ui_shadow[0x13] != ui_pending[0x13]) return 0xFF;
    n = lowest_set_bit(ui_event[1]);           /* computed, overwritten below */
    if (ui_event[0] & (1u << 24)) return 0x18;
    if (ui_event[1] & (1u << 9))  return 0x29;
    if (ui_event[0] & (1u << 21)) return 0x15;
    if (ui_event[1] & (1u << 6))  return 0x26;
    if (ui_event[0] & (1u << 23)) return 0x17;
    if (ui_event[1] & (1u << 8))  return 0x28;
    if (ui_event[0] & (1u << 30)) return 0x1E;
    if (ui_event[0] & (1u << 31)) return 0x1F;
    n = lowest_set_bit(ui_event[1]);
    if (n == 0xFF) n = lowest_set_bit(ui_event[0]);
    else           n += 0x20;
    return n;
}

/* ==========================================================================
 * Blink scheduler (0x68854): every time soft timer 3 expires (reload 0x65
 * ticks) the phase flips 0x10<->0x11 and every registered event bit is
 * re-posted, so blinking elements redraw twice per period.
 * ======================================================================== */

/* FFEF0163-FFEF019E  size 59  blink_start (alias sub_FFEF0163)
 * 24 callers.                                             Confidence: Confirmed */
void blink_start(u32 hi, u32 lo)
{
    ui_timer_set_reload(blink.timer, blink.period);
    ui_timer_start(blink.timer);
    blink.lo |= lo;
    blink.hi |= hi;
}

/* FFEF019E-FFEF01D1  size 51  blink_stop (alias sub_FFEF019E)
 * Note it stops the shared timer even if other bits are still registered;
 * the next blink_start re-arms it.                         Confidence: Confirmed */
void blink_stop(u32 hi, u32 lo)
{
    ui_timer_stop(blink.timer);
    blink.lo &= ~lo;
    blink.hi &= ~hi;
}

/* FFEF01D1-FFEF0220  size 79  blink_start_field (alias sub_FFEF01D1)
 * Caller: band_rec_reconcile.  Field/kind mapping as ui_event_post_field
 * (kind 2 -> hi 1<<field, otherwise lo 0x8000<<field).    Confirmed */
void blink_start_field(u8 field, u8 kind)
{
    ui_timer_set_reload(blink.timer, blink.period);
    ui_timer_start(blink.timer);
    if (kind == 2) blink.hi |= 1u << field;
    else           blink.lo |= 0x8000u << field;
}

/* FFEF0220-FFEF0265  size 69  blink_stop_field (alias sub_FFEF0220)  Confirmed */
void blink_stop_field(u8 field, u8 kind)
{
    ui_timer_stop(blink.timer);
    if (kind == 2) blink.hi &= ~(1u << field);       /* bnot on -1 */
    else           blink.lo &= ~(0x8000u << field);
}

/* FFEF0265-FFEF0273  size 14  blink_get_phase (alias sub_FFEF0265)
 * Raw phase word, 0x10 or 0x11.                            Confirmed */
u32 blink_get_phase(void) { return blink.phase; }

/* FFEF0273-FFEF0294  size 33  blink_toggle (alias sub_FFEF0273)      Confirmed */
void blink_toggle(void) { blink.phase = (blink.phase == 0x10) ? 0x11 : 0x10; }

/* FFEF0294-FFEF02F2  size 94  blink_tick (alias sub_FFEF0294)
 * 57 callers (every reconciler ends with it).  Doc 31 calls it "the
 * dirty-bit flush"; it is the blink re-post.               Confirmed */
void blink_tick(void)
{
    if (ui_timer_expired(3) != 1) return;
    ui_timer_set_reload(3, 0x65);
    ui_timer_start(3);
    blink_toggle();
    for (u8 b = 0; b < 32; b++) {
        u32 m = 1u << b;
        if (blink.lo & m) ui_event_post_lo(m);
        if (blink.hi & m) ui_event_post_hi(m);
    }
}

/* FFEF02F2-FFEF0306  size 20  blink_on (alias sub_FFEF02F2)
 * 50 callers: "draw the blinking element in this half-period?"  Confirmed */
u8 blink_on(void) { return (u8)(blink.phase & 1); }

/* FFEF0306-FFEF032D  size 39  blink_reset (alias sub_FFEF0306)
 * Caller: sub_FFEDF677.                                    Confirmed */
void blink_reset(void)
{
    ui_timer_stop(blink.timer);
    blink.phase = 0; blink.lo = 0; blink.hi = 0;
}
