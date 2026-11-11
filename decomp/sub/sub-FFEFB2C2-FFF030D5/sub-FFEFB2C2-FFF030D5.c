/* ============================================================================
 * sub-FFEFB2C2-FFF030D5.c  -  Hand-reconstructed C for SUB 0xFFEFB2C2..0xFFF030D5
 * Wave C, lane sub-FFEFB2C2-FFF030D5.
 *
 * DOCUMENTATION ONLY.  By-hand transcription of the RX64M (CC-RX, little-endian,
 * mapped at 0xFFC00000) disassembly listing of FT3D_SUB_ver102_ALL.bin.  It does
 * not need to compile.  Nothing here was run against a radio.
 *
 * CC-RX ABI: args r1..r4 (then stack), return r1, r6..r13 callee-saved, r0 = SP.
 * All code in this range is unoptimised CC-RX output: every local lives on the
 * stack; the C below folds those spills away.
 *
 * Immediate-operand convention used throughout (RX encoding trap, doc 38):
 * IDA prints #UIMM8 operands with the top bit set as negative numbers
 * ("mov.w #-10h", "mov.l #-65h", "cmp #-1").  Where the operand is a byte
 * compare, a coordinate or a height the value is the unsigned byte
 * (-10h = 240, -2Ah = 214, -65h = 155, -6Bh = 149, -67h = 153, -30h = 208,
 * -49h = 183, -2Dh = 211, -1 = 0xFF, -0Dh = 0xF3, -4Dh = 0xB3 ...).  A 16-bit
 * colour written "#-1" is a sign-extended SIMM8 and is 0xFFFF (white); 16-bit
 * colours such as "#-680h" are full IMM16 (0xF980).
 *
 * WHAT THE RANGE IS
 *   1. 0xFFEFB2C2-0xFFEFB7F8  small bit/BCD/byte-order helpers (most are dead).
 *   2. 0xFFEFB7F8-0xFFEFE223  five touch-screen "screens" of the SUB UI, each a
 *      4-phase machine on ui_phase (0x8C4C) plus a per-event handler table:
 *        screen 0x29  (IPC F600/F610) digital message/picture folder list
 *        screen 0x2A  (IPC F620/F621) message header + text ("TO:", "NEW")
 *        screen 0x2B  (IPC F622)      20-char edit line + 4-row pick list
 *        screen 0x2C  (IPC F630-F632) picture/message detail viewer overlay
 *        screen 0x20  (IPC F3B3/F3B8/F513-F515/F623) shared text keyboard
 *   3. 0xFFEFE223-0xFFF004C2  screen 0x1F, the SET-MODE item page: phase
 *      machine, frame latching and the per-group "store" handlers (docs 38/44/45).
 *   4. 0xFFF004C2-0xFFF030D5  the per-group value drawers for groups 1, 2
 *      (TX/RX), 3 (MEMORY) and 4 (SIGNALING) (docs 38/44).
 *
 * Shared screen framework (Confirmed from the callees, see globals.tsv):
 *   ui_phase 0  init: latch the IPC frame, phase++
 *   ui_phase 1  draw the static frame (title, dividers, soft-key bar), phase++
 *   ui_phase 2  open a full-screen layer, draw the dynamic content, queue it
 *               (layer_end() also does phase++)
 *   ui_phase 3  event loop: latch new frame bytes (which post "events"), then
 *               take one event and run its handler from the screen's table.
 * Events are bit numbers in the 64-bit word ui_events (0x1D3B0/0x1D3B4); the
 * frame latchers post bit 15 (0x8000, "value changed") or bits 16.. (one per
 * list row / soft key); touch zones post the same bit numbers.
 * ========================================================================== */

#include <stdint.h>
typedef uint8_t u8;  typedef int8_t s8;  typedef uint16_t u16;  typedef int16_t s16;
typedef uint32_t u32; typedef int32_t s32;

/* ---- RAM (addresses are SUB data addresses) ----------------------------- */
extern u8   ui_phase;              /* 0x00008C4C  per-screen phase 0..3            */
extern u8   frame_latched[300];    /* 0x00008C4D  latched IPC frame; [0]=opcode hi, [1]=item code, [0x20..]=values (doc 38) */
extern u8   frame_pending[300];    /* 0x00008E46  newest received frame (doc 25/38) */
extern u8   ui_8D79;               /* 0x00008D79  cleared before every full redraw (meaning Unknown) */
extern u8   ui_hdr_resync;         /* 0x00008D7A  set by hdr_latch_13_1A(); non-zero blocks ui_next_event() */
extern u8   ui_lang;               /* 0x00008F72  0 = Japanese strings, else English (doc 38) */
extern u8   ui_event;              /* 0x00008F73  last event / touch zone taken from ui_events */
extern u8   ui_blink_armed;        /* 0x00008F74  one-shot: blink timer registered for this screen */
extern u8   lcd_xfer_pending;      /* 0x00008F76  queued layer transfers (lcd_queue_busy) */
extern u8   pict_state;            /* 0x00008A8B  picture-decoder state (2 = picture ready, Inferred) */
extern u32  ui_events[2];          /* 0x0001D3B0  event bits 0..31 / 32..63 */
extern struct layer ui_layer;      /* 0x0001D3B8  off-screen layer descriptor {flag,slot,x,y,w,h,buf} */
extern u32 *softkey_slot_rects;    /* 0x00068868  [slot] -> u16 rect[4] per soft key (doc 79) */
extern const u16 *title_glyphs_690B0[3], *title_glyphs_690BC[5], *title_glyphs_690D0[3],
                 *title_glyphs_690DC[4], *row_icons_690EC[3], *title_glyphs_690F8[11],
                 *title_glyphs_69124[11]; /* RAM pointer arrays to bitmap descriptors; word 0 = width */
extern const u16 scr2C_info_height[16];   /* 0x00012580  info-area height by (code & 0xF) */
extern const u16 kbd_field_rect[6][4];    /* 0x00012586  keyboard edit-field rect by kbd type */
extern const u16 item_value_rect[16][16][4]; /* 0x000125B6  value-area rect by item code hi/lo nibble */
/* ---- ROM ----------------------------------------------------------------- */
extern const u32 bit_mask_u32[32];        /* 0xFFED71A8  1<<i (doc 127) */
extern const u16 key_rects[20][4];        /* 0xFFEC5E80  keyboard key rectangles */
extern const struct { u16 x, y; } layout_FFEC6100, layout_FFEC6008; /* +2 = soft-key bar top y (Inferred) */
extern const u8  title_len_by_group[13];  /* 0xFFC3DF35  05 07 05 06 09 05 02 07 06 04 07 06 08 (doc 08/23) */

/* ---- callees outside this range (names given by this lane; Inferred) ---- */
u8   ui_next_event(void);                 /* sub_FFEF003F: 0xFF = none */
void ui_clear_event(u8 ev);               /* sub_FFEEFFEA */
void ui_clear_all_events(void);           /* sub_FFEF002C */
void post_event_lo(u32 mask);             /* sub_FFEEFEA4: ui_events[0] |= mask */
void post_event_hi(u32 mask);             /* sub_FFEEFEEE: ui_events[1] |= mask */
u8   lcd_queue_busy(void);                /* sub_FFEEFB84: lcd_xfer_pending > 0 */
void blink_register(u32 hi, u32 lo);      /* sub_FFEF0163: post these events on every blink tick */
void blink_unregister(u32 hi, u32 lo);    /* sub_FFEF019E */
u8   blink_phase(void);                   /* sub_FFEF02F2 */
void ui_flush_events(void);               /* sub_FFEF0294: blink tick -> post registered events */
void hdr_latch_0_1(void);                 /* sub_FFEF4069: frame bytes 0/1, event 0 */
void hdr_latch_13_1A(void);               /* sub_FFEF40BA: frame bytes 0x13/0x1A -> ui_hdr_resync */
void hdr_reconcile(void);                 /* sub_FFEF4142 (doc 43) */
int  compare_copy(u8 *dst, const u8 *src, u8 n, u32 ev_mask); /* sub_FFEF208D: post_event_lo on change */
int  compare_copy_hi(u8 *dst, const u8 *src, u8 n, u32 ev_mask); /* sub_FFEF20DD: post_event_hi on change */
void surface_reset(void);                 /* sub_FFEF032D: ui_layer = full 320x240 LCD @0x07000000 */
u8   layer_begin(struct layer *l, u16 x, u16 y, u16 w, u16 h); /* sub_FFEEF9BB: 1 = got a buffer */
void layer_end(void);                     /* sub_FFEF036F: queue ui_layer, ui_phase++ */
void layer_copy_lcd(u16 x, u16 y);        /* sub_FFEF0408 */
void layer_copy_rect(u16 x, u16 y, u16 w, u16 h); /* sub_FFEF04F7: copy LCD rect into the layer */
void fill_rect(u16 x, u16 y, u16 w, u16 h, u16 rgb565); /* sub_FFEF1C48 */
void clear_screen(void);                  /* sub_FFEFA747: fill_rect(0,0,320,240,0) */
void clear_screen_with_bar(void);         /* sub_FFEFA75E: black + top bar 0x3186, 26 px */
void draw_scroll_track(u16 top, u16 bottom); /* sub_FFEFA54F: fill_rect(0x137,top,6,bottom-top,0x7BEF) */
void draw_softkey_bar(u8 layout);         /* sub_FFEF9E8F: 21-case soft-key layout switch */
void draw_list_divider(u16 y, u8 narrow); /* sub_FFF0FF6E: fill_rect(6,y,narrow?0x12D:0x134,1,0xAD95) */
void draw_row_divider(u8 row);            /* sub_FFF08826: fill_rect(6,0x18+0x24*row,0x134,1,0xAD95) */
void draw_bitmap(u16 x, u16 y, u8 mode, const void *bmp); /* sub_FFEF68D5 */
void blit(u16 x, u16 y, const void *bmp); /* sub_FFEF0648 */
void draw_icon(u8 idx);                   /* sub_FFEF2505: soft-key/icon record idx (doc 79) */
void softkey_lookup(u8 *desc);            /* sub_FFEF2724: field fetch (doc 34) */
void draw_text(u16 x, u16 y, u8 font, u8 style, u8 len, const char *s, u8 wide); /* sub_FFEF1B23 */
void draw_glyph(u16 x, u16 y, u8 font, u16 code, u8 wide); /* sub_FFEF190D: one (JIS) glyph */
void draw_label(u16 x, u16 y, u16 attr_bits, const char *s); /* sub_FFEFA7E7: mixed ASCII/JIS */
void msg_icon_a(u16 x, u16 y, u8 m, u8 v), msg_icon_b(u16 x, u16 y, u8 m, u8 v),
     msg_icon_c(u16 x, u16 y, u8 m, u8 v); /* sub_FFEF6580 / 65E8 / 66C0 */
void draw_status_bar(void);               /* sub_FFEF399F: the top status icons */
void draw_picture(void);                  /* sub_FFEDE61C: decoded picture @0x1230C, fit to LCD */
u8   pict_get_state(void);                /* sub_FFEDE929: return pict_state */
u8   item_group(void);                    /* sub_FFF092FC (doc 38) */
u8   item_row(void);                      /* sub_FFF09396 (doc 38) */
void draw_group_title(u16 x, u16 y, u8 grp); /* sub_FFF08D14 */
void draw_item_label(u16 x, u16 y, u8 grp, u8 row); /* sub_FFF0964A (walker, doc 38) */
void fmt_uint(char *s, u16 v);            /* sub_FFEE1CE5: no padding */
void fmt_2sp(char *s, u16 v);             /* sub_FFEE1DE8: 2 chars, space padded (doc 44) */
void fmt_2z(char *s, u16 v);              /* sub_FFEE1D6D: 2 digits, zero padded (doc 44) */

#define L(k) (frame_latched[(k)])
#define P(k) (frame_pending[(k)])
#define EV_VALUE   0x8000u                /* event 15: value area must be redrawn       */
#define EV_ROW(i)  (0x10000u << (i))      /* event 16+i                                  */
#define EV_ROW2(i) (0x20000u << (i))      /* event 17+i                                  */

/* Generic latch idioms (each is an open-coded loop in the binary). */
static void latch1(u8 k) { if (L(k) != P(k)) { post_event_lo(EV_VALUE); L(k) = P(k); } }
static void latch_pair(u8 k) {
    if (L(k) != P(k) || L(k + 1) != P(k + 1)) { post_event_lo(EV_VALUE); L(k) = P(k); L(k + 1) = P(k + 1); }
}
static void latch_each(u8 k, u8 n, u32 ev) {
    for (u8 i = 0; i < n; i++) if (L(k + i) != P(k + i)) { post_event_lo(ev); L(k + i) = P(k + i); }
}
#define LATCH_BLOCK(k, n, ev) compare_copy(&L(k), &P(k), (n), (ev))

/* Touch/event loop used by phase 3 of every screen in this range. */
#define SCREEN_EVENT_LOOP(relatch, table, max_ev)                         \
    do {                                                                  \
        ui_event = ui_next_event();                                       \
        if (ui_event == 0xFF) relatch(0);                                 \
        if (ui_event != 0xFF && ui_event <= (max_ev) && !lcd_queue_busy()) { \
            ui_clear_event(ui_event);                                     \
            (table)[ui_event]();                                          \
        }                                                                 \
        if (ui_phase >= 4) ui_phase = 3;                                  \
    } while (0)

/* ========================================================================== *
 * 1. Bit / BCD / byte-order helpers
 * ========================================================================== */

/* FFEFB2C2-FFEFB2E2 (32 B)  bit_mask  (alias sub_FFEFB2C2)               Confirmed
 * Callers: ui_clear_event (FFEEFFB7..FFEF0016).  1<<n from the ROM table, 0 for n>31. */
u32 bit_mask(u8 n) { return (n <= 31) ? bit_mask_u32[n] : 0; }

/* FFEFB2E2-FFEFB369 (135 B)  msb_index  (alias dead_FFEFB2E2)            Confirmed, dead
 * Index of the highest set bit (binary search 16/8/4/2/1); 0xFF for 0.  No callers. */
u8 msb_index(u32 v)
{
    u8 n = 0;
    if (v == 0) return 0xFF;
    if (v & 0xFFFF0000) { n += 16; v >>= 16; }
    if (v & 0x0000FF00) { n += 8;  v >>= 8;  }
    if (v & 0xFFFFFFF0) { n += 4;  v >>= 4;  }  /* mov.l #-10h: tests 0xFFFFFFF0 */
    if (v & 0x0000000C) { n += 2;  v >>= 2;  }
    if (v & 2)          { n += 1;  v >>= 1;  }
    return n;
}

/* FFEFB369-FFEFB3E3 (122 B)  lsb_index  (alias sub_FFEFB369)             Confirmed
 * Callers: FFEEC2B8, FFEEC2CE, ui_next_event (FFEF007E, FFEF0134, FFEF0149).
 * Index of the lowest set bit; 0xFF for 0.  This is how the UI picks the
 * lowest-numbered pending event. */
u8 lsb_index(u32 v)
{
    u8 n = 0;
    if (v == 0) return 0xFF;
    if ((u16)v == 0)      { n += 16; v >>= 16; }
    if ((u8)v == 0)       { n += 8;  v >>= 8;  }
    if ((v & 0xF) == 0)   { n += 4;  v >>= 4;  }
    if ((v & 3) == 0)     { n += 2;  v >>= 2;  }
    if ((v & 1) == 0)     { n += 1;  v >>= 1;  }
    return n;
}

/* FFEFB3E3-FFEFB3FC (25 B)  bcd8_to_bin  (alias dead_FFEFB3E3)           Confirmed, dead */
u8 bcd8_to_bin(u8 b) { return b - (b >> 4) * 6; }

/* FFEFB3FC-FFEFB430 (52 B)  bcd16_to_bin  (alias dead_FFEFB3FC)          Confirmed, dead
 * 0xC18 = 0x1000-1000, 0x9C = 0x100-100, 6 = 0x10-10. */
u16 bcd16_to_bin(u16 b)
{
    return b - (b >> 12) * 0xC18 - ((b & 0xF00) >> 8) * 0x9C - ((b & 0xF0) >> 4) * 6;
}

/* FFEFB430-FFEFB4AA (122 B)  bcd_byte_to_ascii  (alias sub_FFEFB430)     Confirmed
 * Caller: bcd_string_to_ascii.  Writes two characters for one packed-BCD byte.
 * With mode 1 the marker bytes '-' (0x2D) and ' ' (0x20) are expanded to "--"/"  ". */
void bcd_byte_to_ascii(u8 b, char *dst, u8 mode)
{
    if (mode == 1) {
        if (b == '-') { dst[0] = '-'; dst[1] = '-'; return; }
        if (b == ' ') { dst[0] = ' '; dst[1] = ' '; return; }
    }
    dst[0] = (b >> 4) | '0';
    dst[1] = (b | '0') & 0x3F;          /* '0' + low nibble */
}

/* FFEFB4AA-FFEFB54C (162 B)  bcd_string_to_ascii  (alias sub_FFEFB4AA)   Confirmed
 * Caller: FFEF2044.  ndigits packed-BCD digits -> ASCII.  An odd count starts with
 * a single low-nibble digit.  While still "leading", bytes '-'/' ' are markers
 * that print as "--"/"  "; the first real digit ends the leading section. */
void bcd_string_to_ascii(const u8 *src, u8 ndigits, char *dst)
{
    s8 n = ndigits; u8 leading = 1;
    if (n & 1) {
        if (*src == '-')      *dst = '-';
        else if (*src == ' ') *dst = ' ';
        else { *dst = (*src | '0') & 0x3F; leading = 0; }
        dst++; src++; n--;
    }
    while (n > 0) {
        if (leading == 1 && *src != ' ' && *src != '-') leading = 0;
        bcd_byte_to_ascii(*src, dst, leading);
        src++; dst += 2; n -= 2;
    }
}

/* FFEFB54C-FFEFB58E (66 B)  ascii2_to_bin  (alias dead_FFEFB54C)         Confirmed, dead
 * Two ASCII digits -> binary; a character above '9' counts as 0. */
u8 ascii2_to_bin(const char *s)
{
    u8 v = (s[0] <= '9') ? (u8)(s[0] * 10 - 0x1E0) : 0;   /* 0x1E0 = '0'*10 */
    if (s[1] <= '9') v = v + s[1] - '0';
    return v;
}

/* FFEFB58E-FFEFB623 (149 B)  u8_to_dec_buggy  (alias dead_FFEFB58E)      Confirmed, dead
 * Intended: u8 -> decimal without leading zeros.  As compiled it emits
 * (v % div) instead of (v / div) % 10 and never reduces v, so it is wrong for
 * most inputs.  Unreachable, so harmless.  A NULL dst stops it early. */
void u8_to_dec_buggy(u8 v, char *dst)
{
    u8 idx = 0, div = 100;
    for (u8 i = 0; i < 3; i++) {
        if ((v / div) != 0 || idx != 0 || v == 0) {
            if (dst + idx == 0) return;
            dst[idx++] = '0' + v % div;          /* sic */
            if (v == 0) break;
        }
        div /= 10;
    }
    dst[idx] = 0;
}

/* FFEFB623-FFEFB645 (34 B)  bin8_to_bcd  (alias dead_FFEFB623)           Confirmed, dead */
u8 bin8_to_bcd(u8 v) { return (u8)(((v / 10) << 4) | (v % 10)); }

/* FFEFB645-FFEFB6B0 (107 B)  bin16_to_bcd  (alias dead_FFEFB645)         Confirmed, dead */
u16 bin16_to_bcd(u16 v)
{
    u16 r = (v / 1000) << 12;  v %= 1000;
    r |= (v / 100) << 8;       v %= 100;
    r |= (v / 10) << 4;        v %= 10;
    return r | v;
}

/* FFEFB6B0-FFEFB6DF (47 B)  bcd8_inc  (alias dead_FFEFB6B0)              Confirmed, dead
 * Wraps 0x99 -> 0.  NB: a low nibble of 9 adds 6 (0x09 -> 0x0F), not 7; dead code. */
u8 bcd8_inc(u8 v)
{
    if (v >= 0x99) return 0;
    return ((v & 0xF) >= 9) ? (u8)(v + 6) : (u8)(v + 1);
}

/* FFEFB6DF-FFEFB707 (40 B)  bcd8_dec  (alias dead_FFEFB6DF)              Confirmed, dead
 * Wraps 0 -> 0x99.  Mirror of bcd8_inc, with the same 6-instead-of-7 slip. */
u8 bcd8_dec(u8 v)
{
    if (v == 0) return 0x99;
    return ((v & 0xF) == 0) ? (u8)(v - 6) : (u8)(v - 1);
}

/* FFEFB707-FFEFB729 (34 B)  load_be16  (alias dead_FFEFB707)             Confirmed, dead */
u16 load_be16(const u8 *p) { return (u16)(p[0] << 8 | p[1]); }

/* FFEFB729-FFEFB76A (65 B)  load_be32  (alias dead_FFEFB729)             Confirmed, dead */
u32 load_be32(const u8 *p) { return (u32)p[0] << 24 | (u32)p[1] << 16 | (u32)p[2] << 8 | p[3]; }

/* FFEFB76A-FFEFB78C (34 B)  load_le16  (alias dead_FFEFB76A)             Confirmed, dead */
u16 load_le16(const u8 *p) { return (u16)(p[0] | p[1] << 8); }

/* FFEFB78C-FFEFB7CD (65 B)  load_le32  (alias dead_FFEFB78C)             Confirmed, dead */
u32 load_le32(const u8 *p) { return (u32)p[0] | (u32)p[1] << 8 | (u32)p[2] << 16 | (u32)p[3] << 24; }

/* FFEFB7CD-FFEFB7F8 (43 B)  popcount32  (alias dead_FFEFB7CD)            Confirmed, dead */
u8 popcount32(u32 v) { u8 n = 0; while (v) { v &= v - 1; n++; } return n; }

/* ========================================================================== *
 * 2a. Screen 0x29 - digital message/picture folder (IPC F600 / F610)
 *     Screen table 0xFFED4050[0x29] = scr29_handler.  Phase table 0xFFED7228,
 *     event table 0xFFED7238 ([1] = title, [0xF] = list, [0x10..0x13] = soft keys).
 *     F600 (code 0x00): category menu VOICE / MESSAGE / PICT, cursor +0x20.
 *     F610 (code 0x10): 5-row list of 0x18-byte entries at +0x26, cursor +0x25,
 *     scroll position word +0x21/22 of total word +0x23/24, mode +0x20
 *     (selects the title word and the text column).
 * ========================================================================== */
extern void (*const scr29_phase_tbl[4])(void);   /* 0xFFED7228 */
extern void (*const scr29_event_tbl[0x14])(void);/* 0xFFED7238 */

/* FFEFB7F8-FFEFB822 (42 B)  scr29_handler  (alias sub_FFEFB7F8)          Confirmed
 * Referenced from the screen table at 0xFFED40F4 (= 0xFFED4050 + 4*0x29). */
void scr29_handler(void)
{
    if (ui_phase <= 3) scr29_phase_tbl[ui_phase]();
    else ui_phase = 3;
}

/* FFEFB822-FFEFB834 (18 B)  scr29_phase0_init  (alias sub_FFEFB822)      Confirmed */
void scr29_phase0_init(void) { scr29_latch(1); ui_phase++; }

/* FFEFB834-FFEFBAEF (699 B)  scr29_phase1_frame  (alias sub_FFEFB834)    Confirmed
 * Also event 1 (0xFFED723C).  Draws the title as a centred row of bitmap
 * glyphs at y=4 (glyph word 0 = width, 1 px gap): a 3-glyph word, then for
 * F610 a blank of glyph-0 width and a category word of 5/3/4 glyphs chosen by
 * +0x20.  F610 also gets 4 list dividers, the scroll track and soft-key bar 0xF. */
void scr29_phase1_frame(void)
{
    u8 code = L(1);
    u16 y = 4, gap = 1, x; u8 i;
    surface_reset();
    clear_screen_with_bar();
    if (code == 0) {                                   /* F600 */
        x = (0x140 - (gap * 3 + 0x2A)) / 2;
        for (i = 0; i < 3; i++) { draw_bitmap(x, y, 1, title_glyphs_690B0[i]); x += *title_glyphs_690B0[i] + gap; }
        ui_phase++;
        return;
    }
    switch (L(0x20)) {                                 /* F610 */
    case 0:  x = (0x140 - (gap * 9 + 0x7E)) / 2; break;
    case 1:  x = (0x140 - (gap * 7 + 0x62)) / 2; break;
    default: x = (0x140 - ((gap + 0x0E) << 3)) / 2; break;
    }
    for (i = 0; i < 3; i++) { draw_bitmap(x, y, 1, title_glyphs_690B0[i]); x += *title_glyphs_690B0[i] + gap; }
    x += *title_glyphs_690B0[0] + gap;                 /* word space */
    switch (L(0x20)) {
    case 0:  for (i = 0; i < 5; i++) { draw_bitmap(x, y, 1, title_glyphs_690BC[i]); x += *title_glyphs_690BC[i] + gap; } break;
    case 1:  for (i = 0; i < 3; i++) { draw_bitmap(x, y, 1, title_glyphs_690D0[i]); x += *title_glyphs_690D0[i] + gap; } break;
    default: for (i = 0; i < 4; i++) { draw_bitmap(x, y, 1, title_glyphs_690DC[i]); x += *title_glyphs_690DC[i] + gap; } break;
    }
    for (y = 0x39, i = 0; i < 4; i++, y += 0x1F) draw_list_divider(y, 1);
    draw_scroll_track(0x1E, layout_FFEC6100.y - 2);
    draw_softkey_bar(0x0F);
    ui_phase++;
}

/* FFEFBAEF-FFEFBB1C (45 B)  scr29_phase2_body  (alias sub_FFEFBAEF, +FFEFBAF1) Confirmed */
void scr29_phase2_body(void)
{
    if (layer_begin(&ui_layer, 0, 0, 0x140, 240) == 1) { scr29_draw_all(); layer_end(); }
}

/* FFEFBB1C-FFEFBB52 (54 B)  scr29_ev15_list  (alias sub_FFEFBB1C, +FFEFBB21) Confirmed
 * Event 0xF: redraw the list area below the 26-px title bar. */
void scr29_ev15_list(void)
{
    if (layer_begin(&ui_layer, 0, 0x1A, 0x140, scr29_list_height()) == 1) { scr29_draw_list(0, 0x1A); layer_end(); }
}

/* FFEFBB52-FFEFBBC4 (114 B)  scr29_ev_softkey  (alias sub_FFEFBB52, +FFEFBB55/BB9D) Confirmed
 * Events 0x10..0x13: redraw soft key (ev-0x10) inside its slot rectangle.
 * The same shape recurs as scr2A/2B/2C/1F_ev_softkey (only the base differs). */
static void softkey_redraw(u8 idx)
{
    u8 desc[5]; const u16 *r;
    desc[0] = L(0); desc[1] = L(1); desc[3] = idx;
    softkey_lookup(desc);                              /* fills desc[2] = slot */
    r = (const u16 *)(softkey_slot_rects[desc[2]] + idx * 8);
    if (layer_begin(&ui_layer, r[0], r[1], r[2], r[3]) == 1) { draw_icon(idx); layer_end(); }
}
void scr29_ev_softkey(void) { softkey_redraw(ui_event - 0x10); }

/* FFEFBBC4-FFEFBC4A (134 B)  scr29_phase3_events  (alias sub_FFEFBBC4)   Confirmed */
void scr29_phase3_events(void) { SCREEN_EVENT_LOOP(scr29_latch, scr29_event_tbl, 0x13); }

/* FFEFBC4A-FFEFBC66 (28 B)  scr29_latch  (alias sub_FFEFBC4A)            Confirmed
 * Callers: scr29_phase0_init (1), scr29_phase3_events (0). */
void scr29_latch(u8 clear_events)
{
    hdr_latch_0_1();
    scr29_latch_body();
    hdr_latch_13_1A();
    if (clear_events == 1) ui_clear_all_events();
}

/* FFEFBC66-FFEFBD58 (242 B)  scr29_latch_body  (alias sub_FFEFBC66)      Confirmed */
void scr29_latch_body(void)
{
    hdr_reconcile();
    if (L(1) == 0x10) {
        LATCH_BLOCK(0x20, 0x7E, EV_VALUE);             /* +0x20..+0x9D */
        for (u8 i = 0; i < 4; i++) {                   /* soft-key state bytes */
            if (L(0x9E + i) != P(0x9E + i)) { post_event_lo(EV_ROW(i)); L(0x9E + i) = P(0x9E + i); }
            if (L(0xA2 + i) != P(0xA2 + i)) { post_event_lo(EV_ROW(i)); L(0xA2 + i) = P(0xA2 + i); }
        }
    } else if (L(1) == 0x00) {
        LATCH_BLOCK(0x20, 1, EV_VALUE);
    }
    ui_flush_events();
}

/* FFEFBD58-FFEFBD82 (42 B)  scr29_draw_all  (alias sub_FFEFBD58)         Confirmed */
void scr29_draw_all(void)
{
    ui_8D79 = 0;
    layer_copy_lcd(0, 0);
    scr29_draw_list(0, 0x1A);
    if (L(1) == 0x10) scr29_draw_softkeys();
}

/* FFEFBD82-FFEFBE3A (184 B)  scr29_draw_list  (alias sub_FFEFBD82, +FFEFBE19) Confirmed
 * F600 -> category menu.  F610 -> scroll thumb + rows.  Thumb height =
 * track/total, offset (pos-1)*height, white, at x=0x138. */
void scr29_draw_list(u16 x, u16 y)
{
    u8 code = L(1);
    layer_copy_rect(x, y, 0x140, scr29_list_height());
    if (code == 0) { scr29_draw_category_menu(); return; }
    u16 track = layout_FFEC6100.y - 0x20;
    u16 pos   = (u16)(L(0x21) << 8 | L(0x22));
    u16 total = (u16)(L(0x23) << 8 | L(0x24));
    u16 th    = track / total;
    fill_rect(0x138, (u16)((pos - 1) * th + 0x1E), 6, th, 0xFFFF);
    scr29_draw_rows(x, y);
}

/* FFEFBE3A-FFEFBE55 (27 B)  scr29_draw_softkeys  (alias sub_FFEFBE3A)    Confirmed */
void scr29_draw_softkeys(void) { for (u8 i = 0; i < 4; i++) draw_icon(i); }

/* FFEFBE55-FFEFBE81 (44 B)  scr29_list_height  (alias sub_FFEFBE55)      Confirmed
 * NB the result is truncated to a byte by the code. */
u8 scr29_list_height(void) { return (L(1) == 0x10) ? (u8)(layout_FFEC6100.y - 0x1A) : 214; }

/* FFEFBE81-FFEFBFF6 (373 B)  scr29_draw_rows  (alias sub_FFEFBE81, +BEB2/BFB7) Confirmed
 * Entry i (0..4) = &L[0x26 + 0x18*i]: [0] used flag, [1..3] status icons,
 * [4..] text.  Row pitch 0x1F; the selected row (cursor +0x25, max 4) gets an
 * orange (0xF980) bar.  Text column/length: mode +0x20 == 0 -> x+0x30, 18
 * chars; else x+0x4C, 16 chars. */
void scr29_draw_rows(u16 x, u16 y)
{
    u8 sel = L(0x25); if (sel >= 5) sel = 4;
    for (u8 i = 0; i < 5; i++) {
        const u8 *e = &L(0x26 + 0x18 * i);
        if (i == sel) fill_rect(x + 6, y + 1, 0x132 - (x + 6), 0x1E, 0xF980);
        if (e[0] == 0) continue;
        if (e[1]) msg_icon_a(x + 6,    y + 4, 1, e[1]);
        if (e[2]) msg_icon_b(x + 0x17, y + 4, 1, e[2]);
        if (e[3]) msg_icon_c(x + 0x2F, y + 4, 1, e[3]);
        if (L(0x20) == 0) draw_text(x + 0x30, y + 3, 0x0D, 0, 0x12, (const char *)&e[4], 1);
        else              draw_text(x + 0x4C, y + 3, 0x0D, 0, 0x10, (const char *)&e[4], 1);
        y += 0x1F;
    }
}

/* FFEFBFF6-FFEFC0F7 (257 B)  scr29_draw_category_menu  (alias sub_FFEFBFF6, +C023/C05F/C083/C0A7/C0CE) Confirmed
 * Three rows at y=0x1B+0x1F*i: icon row_icons_690EC[i] at x=0x2F and the
 * strings "VOICE " / "MESSAGE" / "PICT" at x=0x4C; cursor +0x20 (max 2). */
void scr29_draw_category_menu(void)
{
    static const char *const name[3] = { "VOICE ", "MESSAGE", "PICT" };
    static const u8 len[3] = { 5, 7, 4 };
    u8 sel = L(0x20); if (sel >= 3) sel = 2;
    u16 y = 0x1B;
    for (u8 i = 0; i < 3; i++) {
        if (i == sel) fill_rect(6, y, 0x12D, 0x1E, 0xF980);
        draw_bitmap(0x2F, y + 3, 1, row_icons_690EC[i]);
        draw_text(0x4C, y + 2, 0x0D, 0, len[i], name[i], 1);
        y += 0x1F;
        fill_rect(6, y - 1, 0x12D, 1, 0xAD95);
    }
}

/* ========================================================================== *
 * 2b. Screen 0x2A - message header + body (IPC F620 / F621)
 *     Phase table 0xFFED7288, event table 0xFFED7298 ([1] frame, [0xF] header,
 *     [0x10] body, [0x11..0x13] soft keys 0..2).
 *     F620: "TO:" + 16-char callsign/name at +0x23, 3-page scroll (+0x33) over
 *           4 x 20-char text lines (+0x3A), "FROM:" + 10 chars (+0x8A),
 *           SENT/RCVD date (+0x35, BCD yy mm dd hh mm), "D/L:" date (+0x94).
 *     F621: header mode +0x20 (0 = "TO:" line, 1 = icon + "NEW"),
 *           4 x 20-char text lines at +0x34.
 * ========================================================================== */
extern void (*const scr2A_phase_tbl[4])(void);   /* 0xFFED7288 */
extern void (*const scr2A_event_tbl[0x14])(void);/* 0xFFED7298 */

/* FFEFC0F7-FFEFC121 (42 B)  scr2A_handler  (alias sub_FFEFC0F7)          Confirmed (table 0xFFED40F8) */
void scr2A_handler(void) { if (ui_phase <= 3) scr2A_phase_tbl[ui_phase](); else ui_phase = 3; }

/* FFEFC121-FFEFC133 (18 B)  scr2A_phase0_init  (alias sub_FFEFC121)      Confirmed */
void scr2A_phase0_init(void) { scr2A_latch(1); ui_phase++; }

/* FFEFC133-FFEFC15D (42 B)  scr2A_phase1_frame  (alias sub_FFEFC133, +FFEFC13B) Confirmed */
void scr2A_phase1_frame(void)
{
    surface_reset(); clear_screen();
    draw_scroll_track(0x20, layout_FFEC6008.y);
    draw_softkey_bar(6);
    ui_phase++;
}

/* FFEFC15D-FFEFC18A (45 B)  scr2A_phase2_body  (alias sub_FFEFC15D, +C15F) Confirmed */
void scr2A_phase2_body(void)
{ if (layer_begin(&ui_layer, 0, 0, 0x140, 240) == 1) { scr2A_draw_all(); layer_end(); } }

/* FFEFC18A-FFEFC1BC (50 B)  scr2A_ev15_header  (alias sub_FFEFC18A, +C18C) Confirmed */
void scr2A_ev15_header(void)
{ if (layer_begin(&ui_layer, 0, 0, 0x140, 0x1E) == 1) { scr2A_draw_header(0, 0); layer_end(); } }

/* FFEFC1BC-FFEFC1F0 (52 B)  scr2A_ev16_body  (alias sub_FFEFC1BC, +C1BE) Confirmed */
void scr2A_ev16_body(void)
{ if (layer_begin(&ui_layer, 0, 0x1E, 0x140, 155) == 1) { scr2A_draw_body(0, 0x1E); layer_end(); } }

/* FFEFC1F0-FFEFC262 (114 B)  scr2A_ev_softkey  (alias sub_FFEFC1F0, +C1F3/C23B) Confirmed */
void scr2A_ev_softkey(void) { softkey_redraw(ui_event - 0x11); }

/* FFEFC262-FFEFC2E8 (134 B)  scr2A_phase3_events  (alias sub_FFEFC262)   Confirmed */
void scr2A_phase3_events(void) { SCREEN_EVENT_LOOP(scr2A_latch, scr2A_event_tbl, 0x13); }

/* FFEFC2E8-FFEFC304 (28 B)  scr2A_latch  (alias sub_FFEFC2E8)            Confirmed */
void scr2A_latch(u8 clear_events)
{ hdr_latch_0_1(); scr2A_latch_body(); hdr_latch_13_1A(); if (clear_events == 1) ui_clear_all_events(); }

/* FFEFC304-FFEFC4D3 (463 B)  scr2A_latch_body  (alias sub_FFEFC304)      Confirmed
 * Header bytes -> event 15, body bytes -> event 16, soft-key bytes -> 17..19. */
void scr2A_latch_body(void)
{
    u8 i;
    hdr_reconcile();
    if (L(1) == 0x20) {
        LATCH_BLOCK(0x20, 0x13, EV_VALUE);
        LATCH_BLOCK(0x33, 0x66, EV_ROW(0));
        for (i = 0; i < 3; i++) { latch_each(0x99 + i, 1, EV_ROW2(i)); latch_each(0x9C + i, 1, EV_ROW2(i)); }
    } else if (L(1) == 0x21) {
        LATCH_BLOCK(0x20, 0x14, EV_VALUE);
        LATCH_BLOCK(0x34, 0x50, EV_ROW(0));
        for (i = 0; i < 3; i++) { latch_each(0x84 + i, 1, EV_ROW2(i)); latch_each(0x87 + i, 1, EV_ROW2(i)); }
    }
    ui_flush_events();
}

/* FFEFC4D3-FFEFC4F7 (36 B)  scr2A_draw_all  (alias sub_FFEFC4D3)         Confirmed */
void scr2A_draw_all(void)
{
    ui_8D79 = 0; layer_copy_lcd(0, 0);
    scr2A_draw_header(0, 0); scr2A_draw_body(0, 0x1E); scr2A_draw_softkeys();
}

/* FFEFC4F7-FFEFC60F (280 B)  scr2A_draw_header  (alias sub_FFEFC4F7, +C542/C577/C5B3) Confirmed */
void scr2A_draw_header(u16 x, u16 y)
{
    u8 code = L(1);
    u16 xx = x + 3;
    layer_copy_rect(0, 0, 0x140, 0x1E);
    if (code == 0x20) {
        draw_label(xx, y + 1, 0, "TO:");
        draw_text(xx + 0x2A, y + 1, 0x0D, 0, 0x10, (const char *)&L(0x23), 1);
    } else if (code == 0x21) {
        u8 mode = L(0x20);
        fill_rect(0, 0, 0x140, 0x1E, 0x03FF);          /* cyan header bar */
        if (mode == 0) {
            draw_label(xx, y + 1, 0, "TO:");
            draw_text(xx + 0x2A, y + 1, 0x0D, 0, 0x10, (const char *)&L(0x23), 1);
        } else if (mode == 1) {
            draw_bitmap(xx, y + 4, 1, (const void *)0xFFED2DDC);
            draw_label(xx + 0x19, y + 1, 0, "NEW");
        }
    }
}

/* FFEFC60F-FFEFC637 (40 B)  scr2A_draw_body  (alias sub_FFEFC60F)        Confirmed */
void scr2A_draw_body(u16 x, u16 y)
{
    if (L(1) == 0x20) scr2A_draw_msg_page();
    else if (L(1) == 0x21) scr2A_draw_text_lines();
}

/* FFEFC637-FFEFC652 (27 B)  scr2A_draw_softkeys  (alias sub_FFEFC637)    Confirmed */
void scr2A_draw_softkeys(void) { for (u8 i = 0; i < 3; i++) draw_icon(i); }

/* Build "yy/mm/dd hh:mm" from 5 packed-BCD bytes using a 5-entry offset table
 * (ROM 0xFFF4862B / 0xFFF4865F / 0xFFF4868D, presumably {0,3,6,9,12}). */
static void fmt_bcd_datetime(char out[15], const u8 *bcd, const u8 ofs[5])
{
    for (u8 i = 0; i < 5; i++) {
        out[ofs[i]]     = (bcd[i] >> 4) | '0';
        out[ofs[i] + 1] = (bcd[i] | '0') & 0x3F;
    }
}

/* FFEFC652-FFEFC909 (695 B)  scr2A_draw_msg_page  (alias sub_FFEFC652, +C6E1/C73B/C812/C8BD/C8F0) Confirmed
 * F620 body: page = +0x33 (0..2, a 3-step scroll).  Page 0 shows text lines
 * 0..3, page 1 lines 1..3 + date, page 2 lines 2..3 + date + D/L date.
 * Direction byte +0x34: 1 = "SENT:", 2 = "RCVD:", else "    :". */
void scr2A_draw_msg_page(void)
{
    char date[15] = "yy/mm/dd hh:mm"; extern const u8 dt_ofs_FFF4862B[5];
    u16 x0 = 0x11, y = 0x1E;
    u8 dir = L(0x34), page = L(0x33), first, n;
    layer_copy_rect(0, 0x1E, 0x140, 155);
    if (page == 0)      { first = 0;    n = 4; }
    else if (page == 1) { first = 0x14; n = 3; }
    else                { first = 0x28; n = 2; }
    for (u8 i = 0; i < n; i++, y += 0x1E)
        draw_text(x0, y + 1, 0x0D, 0, 0x14, (const char *)&L(0x3A + first + 0x14 * i), 1);
    draw_label(x0, y + 1, 0, "FROM:");
    draw_text(x0 + 0x46, y + 1, 0x0D, 0, 0x0A, (const char *)&L(0x8A), 1);
    if (page != 0) {
        y += 0x1E;
        draw_label(x0, y + 1, 0, dir == 1 ? "SENT:" : dir == 2 ? "RCVD:" : "    :");
        fmt_bcd_datetime(date, &L(0x35), dt_ofs_FFF4862B);
        draw_text(x0 + 0x46, y + 1, 0x0D, 0, 0x0F, date, 1);
    }
    if (page != 0 && page != 1) {
        y += 0x1E;
        draw_label(x0, y + 1, 0, "D/L:");
        fmt_bcd_datetime(date, &L(0x94), dt_ofs_FFF4862B);
        draw_text(x0 + 0x38, y + 1, 0x0D, 0, 0x0F, date, 1);
    }
    if (page >= 3) page = 2;
    fill_rect(0x138, page * 0x33 + 0x20, 6, 0x33, 0xFFFF);  /* scroll thumb, 1/3 of track */
}

/* FFEFC909-FFEFC987 (126 B)  scr2A_draw_text_lines  (alias sub_FFEFC909, +C934/C96D) Confirmed
 * F621 body: 4 lines x 20 chars at +0x34, thumb fills the whole track. */
void scr2A_draw_text_lines(void)
{
    u16 y = 0x1E;
    layer_copy_rect(0, 0x1E, 0x140, 155);
    for (u8 i = 0; i < 4; i++, y += 0x1E)
        draw_text(0x11, y + 1, 0x0D, 0, 0x14, (const char *)&L(0x34 + 0x14 * i), 1);
    fill_rect(0x138, 0x20, 6, 153, 0xFFFF);
}

/* ========================================================================== *
 * 2c. Screen 0x2B - 20-char edit line + 4-row pick list (IPC F622)
 *     Phase table 0xFFED72E8, event table 0xFFED72F8 ([1] frame, [0xF] edit
 *     line, [0x10] list, [0x11] soft key 0); events above 0x11 are ignored.
 *     +0x20 cursor, +0x21..+0x34 text, +0x41 list cursor, +0x42 4 x 22 chars.
 * ========================================================================== */
extern void (*const scr2B_phase_tbl[4])(void);   /* 0xFFED72E8 */
extern void (*const scr2B_event_tbl[0x12])(void);/* 0xFFED72F8 */

/* FFEFC987-FFEFC9B1 (42 B)  scr2B_handler  (alias sub_FFEFC987)          Confirmed (table 0xFFED40FC) */
void scr2B_handler(void) { if (ui_phase <= 3) scr2B_phase_tbl[ui_phase](); else ui_phase = 3; }

/* FFEFC9B1-FFEFC9C3 (18 B)  scr2B_phase0_init  (alias sub_FFEFC9B1)      Confirmed */
void scr2B_phase0_init(void) { scr2B_latch(1); ui_phase++; }

/* FFEFC9C3-FFEFCA04 (65 B)  scr2B_phase1_frame  (alias sub_FFEFC9C3)     Confirmed */
void scr2B_phase1_frame(void)
{
    surface_reset(); clear_screen();
    for (u16 y = 0x22, i = 0; i < 4; i++, y += 0x24) draw_list_divider(y, 0);
    draw_softkey_bar(6);
    ui_phase++;
}

/* FFEFCA04-FFEFCA31 (45 B)  scr2B_phase2_body  (alias sub_FFEFCA04, +CA06) Confirmed */
void scr2B_phase2_body(void)
{ if (layer_begin(&ui_layer, 0, 0, 0x140, 240) == 1) { scr2B_draw_all(); layer_end(); } }

/* FFEFCA31-FFEFCA72 (65 B)  scr2B_ev15_edit  (alias sub_FFEFCA31, +CA33)  Confirmed */
void scr2B_ev15_edit(void)
{
    if (layer_begin(&ui_layer, 0, 0, 0x140, 0x22) == 1) {
        layer_copy_rect(0, 0, 0x140, 0x22); scr2B_draw_edit_line(0, 0); layer_end();
    }
}

/* FFEFCA72-FFEFCAB6 (68 B)  scr2B_ev16_list  (alias sub_FFEFCA72, +CA74)  Confirmed */
void scr2B_ev16_list(void)
{
    if (layer_begin(&ui_layer, 0, 0x22, 0x140, 149) == 1) {
        layer_copy_rect(0, 0x22, 0x140, 149); scr2B_draw_list(0, 0x22); layer_end();
    }
}

/* FFEFCAB6-FFEFCB28 (114 B)  scr2B_ev_softkey  (alias sub_FFEFCAB6, +CAB9/CB01) Confirmed */
void scr2B_ev_softkey(void) { softkey_redraw(ui_event - 0x11); }

/* FFEFCB28-FFEFCBAE (134 B)  scr2B_phase3_events  (alias sub_FFEFCB28)   Confirmed (max event 0x11) */
void scr2B_phase3_events(void) { SCREEN_EVENT_LOOP(scr2B_latch, scr2B_event_tbl, 0x11); }

/* FFEFCBAE-FFEFCBCA (28 B)  scr2B_latch  (alias sub_FFEFCBAE)            Confirmed */
void scr2B_latch(u8 clear_events)
{ hdr_latch_0_1(); scr2B_latch_body(); hdr_latch_13_1A(); if (clear_events == 1) ui_clear_all_events(); }

/* FFEFCBCA-FFEFCCCC (258 B)  scr2B_latch_body  (alias sub_FFEFCBCA)      Confirmed
 * First call registers event 15 with the blink timer (blinking text cursor). */
void scr2B_latch_body(void)
{
    hdr_reconcile();
    if (ui_blink_armed == 0) { blink_register(0, EV_VALUE); ui_blink_armed = 1; }
    LATCH_BLOCK(0x20, 0x21, EV_VALUE);
    LATCH_BLOCK(0x41, 0x59, EV_ROW(0));
    latch_each(0x9A, 1, EV_ROW2(0));
    latch_each(0x9B, 1, EV_ROW2(0));
    ui_flush_events();
}

/* FFEFCCCC-FFEFCCF3 (39 B)  scr2B_draw_all  (alias sub_FFEFCCCC)         Confirmed */
void scr2B_draw_all(void)
{
    ui_8D79 = 0; layer_copy_lcd(0, 0);
    scr2B_draw_edit_line(0, 0); scr2B_draw_list(0, 0x22); draw_icon(0);
}

/* FFEFCCF3-FFEFCD87 (148 B)  scr2B_draw_edit_line  (alias sub_FFEFCCF3, +CD3F/CD61) Confirmed
 * Up to 20 glyphs at x=0x14+14*i; the cursor cell blinks (orange box). */
void scr2B_draw_edit_line(u16 x, u16 y)
{
    u8 blink = blink_phase(), cur = L(0x20);
    u16 xx = 0x14;
    for (u8 i = 0; i < 20; i++, xx += 0x0E) {
        u8 ch = L(0x21 + i);
        if (ch == 0) return;
        if (i == cur && blink == 1) fill_rect(x + xx, y + 3, 0x0E, 0x1C, 0xF980);
        draw_glyph(x + xx, y + 3, 0x0D, ch, 1);
    }
}

/* FFEFCD87-FFEFCE16 (143 B)  scr2B_draw_list  (alias sub_FFEFCD87, +CDB4/CDDB) Confirmed */
void scr2B_draw_list(u16 x, u16 y)
{
    u8 sel = L(0x41); if (sel >= 4) sel = 3;
    for (u8 i = 0; i < 4; i++, y += 0x24) {
        if (i == sel) fill_rect(6, y + 1, 0x134, 0x23, 0xF980);
        draw_text(x + 6, y + 5, 0x0D, 0, 0x16, (const char *)&L(0x42 + 0x16 * i), 1);
    }
}

/* ========================================================================== *
 * 2d. Screen 0x2C - picture / message detail viewer (IPC F630 / F631 / F632)
 *     Phase table 0xFFED7340, event table 0xFFED7350 ([1] frame, [0xF] info
 *     panel, [0x10..0x13] soft keys).  +0x20 = info overlay on/off.  MAIN's
 *     F630 sender is sub_AE3C with a 104-byte record (doc 09).
 * ========================================================================== */
extern void (*const scr2C_phase_tbl[4])(void);   /* 0xFFED7340 */
extern void (*const scr2C_event_tbl[0x14])(void);/* 0xFFED7350 */

/* FFEFCE16-FFEFCE40 (42 B)  scr2C_handler  (alias sub_FFEFCE16)          Confirmed (table 0xFFED4100) */
void scr2C_handler(void) { if (ui_phase <= 3) scr2C_phase_tbl[ui_phase](); else ui_phase = 3; }

/* FFEFCE40-FFEFCE52 (18 B)  scr2C_phase0_init  (alias sub_FFEFCE40)      Confirmed */
void scr2C_phase0_init(void) { scr2C_latch(1); ui_phase++; }

/* FFEFCE52-FFEFCEC0 (110 B)  scr2C_phase1_frame  (alias sub_FFEFCE52, +CE68/CE8D) Confirmed
 * Black screen, the decoded picture when pict_state == 2, then (overlay on)
 * a 20-px 0x2A69 header bar and soft-key bar 0xF.  NB the phase only advances
 * when pict_state != 2, so a ready picture keeps the screen in phase 1
 * (re-drawn each pass) - Inferred to be the picture-display hold. */
void scr2C_phase1_frame(void)
{
    u8 overlay = L(0x20), st = pict_get_state();
    surface_reset();
    fill_rect(0, 0, 0x140, 240, 0x0000);
    if (st == 2) draw_picture();
    if (overlay) { fill_rect(0, 0, 0x140, 0x14, 0x2A69); draw_softkey_bar(0x0F); }
    if (st != 2) ui_phase++;
}

/* FFEFCEC0-FFEFCEED (45 B)  scr2C_phase2_body  (alias sub_FFEFCEC0, +CEC2) Confirmed */
void scr2C_phase2_body(void)
{ if (layer_begin(&ui_layer, 0, 0, 0x140, 240) == 1) { scr2C_draw_all(); layer_end(); } }

/* FFEFCEED-FFEFCF37 (74 B)  scr2C_ev15_info  (alias sub_FFEFCEED, +CF06)  Confirmed */
void scr2C_ev15_info(void)
{
    u16 h = scr2C_info_height[L(1) & 0x0F];
    if (layer_begin(&ui_layer, 0, 0x14, 0x140, h) == 1) { scr2C_draw_info(0, 0x14); layer_end(); }
}

/* FFEFCF37-FFEFCFA9 (114 B)  scr2C_ev_softkey  (alias sub_FFEFCF37, +CF3A/CF82) Confirmed */
void scr2C_ev_softkey(void) { softkey_redraw(ui_event - 0x10); }

/* FFEFCFA9-FFEFD02F (134 B)  scr2C_phase3_events  (alias sub_FFEFCFA9)   Confirmed */
void scr2C_phase3_events(void) { SCREEN_EVENT_LOOP(scr2C_latch, scr2C_event_tbl, 0x13); }

/* FFEFD02F-FFEFD04B (28 B)  scr2C_latch  (alias sub_FFEFD02F)            Confirmed */
void scr2C_latch(u8 clear_events)
{ hdr_latch_0_1(); scr2C_latch_body(); hdr_latch_13_1A(); if (clear_events == 1) ui_clear_all_events(); }

/* FFEFD04B-FFEFD2CA (639 B)  scr2C_latch_body  (alias sub_FFEFD04B)      Confirmed
 * The overlay flag posts event 0; the rest is latched only while the overlay is on. */
void scr2C_latch_body(void)
{
    u8 i, hdr_n = 0, a = 0;
    if (L(0x20) != P(0x20)) { post_event_lo(1); L(0x20) = P(0x20); }
    if (P(0x20) != 1) return;
    hdr_reconcile();
    switch (L(1)) {
    case 0x30: hdr_n = 0x37; a = 0x58; break;          /* +0x21..+0x57, then 4+4 */
    case 0x31: hdr_n = 0x33; a = 0x54; break;
    case 0x32: hdr_n = 0x13; a = 0x34; break;
    default:   ui_flush_events(); return;
    }
    LATCH_BLOCK(0x21, hdr_n, EV_VALUE);
    for (i = 0; i < 4; i++) { latch_each(a + i, 1, EV_ROW(i)); latch_each(a + 4 + i, 1, EV_ROW(i)); }
    ui_flush_events();
}

/* FFEFD2CA-FFEFD300 (54 B)  scr2C_draw_all  (alias sub_FFEFD2CA)         Confirmed */
void scr2C_draw_all(void)
{
    u8 overlay = L(0x20);
    ui_8D79 = 0; layer_copy_lcd(0, 0);
    if (overlay) { draw_status_bar(); scr2C_draw_info(0, 0x14); scr2C_draw_softkeys(); }
}

/* FFEFD300-FFEFD33A (58 B)  scr2C_draw_info  (alias sub_FFEFD300)        Confirmed */
void scr2C_draw_info(u16 x, u16 y)
{
    switch (L(1)) {
    case 0x30: scr2C_info_F630(x, y); break;
    case 0x31: scr2C_info_F631(x, y); break;
    case 0x32: scr2C_info_F632(x, y); break;
    }
}

/* FFEFD33A-FFEFD355 (27 B)  scr2C_draw_softkeys  (alias sub_FFEFD33A)    Confirmed */
void scr2C_draw_softkeys(void) { for (u8 i = 0; i < 4; i++) draw_icon(i); }

/* FFEFD355-FFEFD518 (451 B)  scr2C_info_F630  (alias sub_FFEFD355, +D393/D3C7/D3FB/D47D/D4F9) Confirmed
 * Absolute coordinates (args unused): TO + 16 chars (+0x24), icon 0xFFED2E1C
 * + 16 chars (+0x39), FROM + 10 chars (+0x4E), "    :20" + date (+0x34) and
 * "D/L :20" + date (+0x49).  The "20" prefix makes a 4-digit year. */
void scr2C_info_F630(u16 x, u16 y)
{
    char date[15] = "yy/mm/dd hh:mm"; extern const u8 dt_ofs_FFF4865F[5];
    draw_label(6, 0x14, 0, "TO:");   draw_text(0x30, 0x14, 0x0D, 0, 0x10, (const char *)&L(0x24), 1);
    draw_bitmap(9, 0x35, 1, (const void *)0xFFED2E1C);
    draw_text(0x22, 0x32, 0x0D, 0, 0x10, (const char *)&L(0x39), 1);
    draw_label(6, 0x5D, 0, "FROM:"); draw_text(0x4C, 0x5D, 0x0D, 0, 0x0A, (const char *)&L(0x4E), 1);
    draw_label(6, 0x7B, 0, "    :20");
    fmt_bcd_datetime(date, &L(0x34), dt_ofs_FFF4865F); draw_text(0x68, 0x7B, 0x0D, 0, 0x0F, date, 1);
    draw_label(6, 153, 0, "D/L :20");
    fmt_bcd_datetime(date, &L(0x49), dt_ofs_FFF4865F); draw_text(0x68, 153, 0x0D, 0, 0x0F, date, 1);
}

/* FFEFD518-FFEFD69B (387 B)  scr2C_info_F631  (alias sub_FFEFD518, +D560/D594/D5C8/D67C) Confirmed
 * As F630 but subject at +0x3A, FROM at y=0x7B (+0x4A), and one date line
 * labelled by direction +0x34: 1 "SENT:20", 2 "RCVD:20", else "    :20". */
void scr2C_info_F631(u16 x, u16 y)
{
    char date[15] = "yy/mm/dd hh:mm"; extern const u8 dt_ofs_FFF4868D[5];
    u8 dir = L(0x34);
    draw_label(6, 0x14, 0, "TO:");   draw_text(0x30, 0x14, 0x0D, 0, 0x10, (const char *)&L(0x24), 1);
    draw_bitmap(9, 0x35, 1, (const void *)0xFFED2E1C);
    draw_text(0x22, 0x32, 0x0D, 0, 0x10, (const char *)&L(0x3A), 1);
    draw_label(6, 0x7B, 0, "FROM:"); draw_text(0x4C, 0x7B, 0x0D, 0, 0x0A, (const char *)&L(0x4A), 1);
    draw_label(6, 153, 0, dir == 1 ? "SENT:20" : dir == 2 ? "RCVD:20" : "    :20");
    fmt_bcd_datetime(date, &L(0x35), dt_ofs_FFF4868D); draw_text(0x68, 153, 0x0D, 0, 0x0F, date, 1);
}

/* FFEFD69B-FFEFD6E9 (78 B)  scr2C_info_F632  (alias sub_FFEFD69B, +D6C4) Confirmed
 * Two icons (0xFFED2DCC at 9, 0xFFED2E1C at 0x22, y=0x17) and 16 chars (+0x24). */
void scr2C_info_F632(u16 x, u16 y)
{
    draw_bitmap(9,    0x17, 1, (const void *)0xFFED2DCC);
    draw_bitmap(0x22, 0x17, 1, (const void *)0xFFED2E1C);
    draw_text(0x3E, 0x14, 0x0D, 0, 0x10, (const char *)&L(0x24), 1);
}

/* ========================================================================== *
 * 2e. Screen 0x20 - shared text keyboard (IPC F3B3, F3B8, F513, F514, F515, F623)
 *     Phase table 0xFFED73A0, event table 0xFFED73B0 ([1] frame, [0x20..0x33]
 *     the 20 keys, [0x34] key block, [0x35] edit field).  Edit-field events
 *     go to the HIGH event word (post_event_hi): 0x200000 = event 0x35,
 *     0x100000 = event 0x34.  The blink timer re-posts event 0x35.
 *     Per page: a header block from +0x20 (cursor at +0x20, text at +0x21..)
 *     then 20 key-label bytes and 20 key-attribute bytes.
 * ========================================================================== */
extern void (*const scr20_phase_tbl[4])(void);   /* 0xFFED73A0 */
extern void (*const scr20_event_tbl[0x36])(void);/* 0xFFED73B0 */

/* FFEFD6E9-FFEFD713 (42 B)  scr20_kbd_handler  (alias sub_FFEFD6E9)      Confirmed (table 0xFFED40D0, doc 23) */
void scr20_kbd_handler(void) { if (ui_phase <= 3) scr20_phase_tbl[ui_phase](); else ui_phase = 3; }

/* FFEFD713-FFEFD725 (18 B)  scr20_phase0_init  (alias sub_FFEFD713)      Confirmed */
void scr20_phase0_init(void) { scr20_latch(1); ui_phase++; }

/* FFEFD725-FFEFD740 (27 B)  scr20_phase1_frame  (alias sub_FFEFD725, +D733) Confirmed */
void scr20_phase1_frame(void) { surface_reset(); clear_screen(); draw_softkey_bar(2); ui_phase++; }

/* FFEFD740-FFEFD76D (45 B)  scr20_phase2_body  (alias sub_FFEFD740, +D742) Confirmed */
void scr20_phase2_body(void)
{ if (layer_begin(&ui_layer, 0, 0, 0x140, 240) == 1) { scr20_draw_all(); layer_end(); } }

/* FFEFD76D-FFEFD7BA (77 B)  scr20_ev35_field  (alias sub_FFEFD76D, +D786) Confirmed */
void scr20_ev35_field(void)
{
    const u16 *r = kbd_field_rect[scr20_kbd_type()];
    if (layer_begin(&ui_layer, r[0], r[1], r[2], r[3]) == 1) { scr20_draw_field(r[0], r[1]); layer_end(); }
}

/* FFEFD7BA-FFEFD7E8 (46 B)  scr20_ev34_keys  (alias sub_FFEFD7BA, +D7BC)  Confirmed */
void scr20_ev34_keys(void)
{ if (layer_begin(&ui_layer, 0, 0x20, 0x140, 208) == 1) { scr20_draw_keys(); layer_end(); } }

/* FFEFD7E8-FFEFD830 (72 B)  scr20_ev_key  (alias sub_FFEFD7E8, +D809)     Confirmed
 * Events 0x20..0x33 (twenty table slots): redraw key ev-0x20 in its ROM rectangle. */
void scr20_ev_key(void)
{
    u8 k = ui_event - 0x20; const u16 *r = key_rects[k];
    if (layer_begin(&ui_layer, r[0], r[1], r[2], r[3]) == 1) { draw_icon(k); layer_end(); }
}

/* FFEFD830-FFEFD8B6 (134 B)  scr20_phase3_events  (alias sub_FFEFD830)   Confirmed (max event 0x35) */
void scr20_phase3_events(void) { SCREEN_EVENT_LOOP(scr20_latch, scr20_event_tbl, 0x35); }

/* FFEFD8B6-FFEFD8D2 (28 B)  scr20_latch  (alias sub_FFEFD8B6)            Confirmed */
void scr20_latch(u8 clear_events)
{ hdr_latch_0_1(); scr20_latch_body(); hdr_latch_13_1A(); if (clear_events == 1) ui_clear_all_events(); }

/* FFEFD8D2-FFEFDDD4 (1282 B)  scr20_latch_body  (alias sub_FFEFD8D2)     Confirmed
 * First call registers HIGH event 0x35 (0x200000) with the blink timer.
 * Header block -> event 0x35; key labels/attributes -> event 0x34. */
void scr20_latch_body(void)
{
    u8 i, k_lab = 0, n_hdr = 0, k_hdr = 0x20;
    hdr_reconcile();
    if (ui_blink_armed == 0) { blink_register(0x200000, 0); ui_blink_armed = 1; }
    if (L(0) == 0xF3) {
        if (L(1) == 0xB3) {              /* F3B3 (vestigial, doc 43) */
            if (L(0x20) != P(0x20)) { post_event_hi(0x200000); L(0x20) = P(0x20); }
            if (L(0x21) != P(0x21)) { post_event_hi(0x200000); L(0x21) = P(0x21); }
            compare_copy_hi(&L(0x22), &P(0x22), 9, 0x200000);
            k_lab = 0x2B;
        } else if (L(1) == 0xB8) {       /* F3B8 CALLSIGN */
            if (L(0x20) != P(0x20)) { post_event_hi(0x200000); L(0x20) = P(0x20); }
            compare_copy_hi(&L(0x21), &P(0x21), 9, 0x200000);
            k_lab = 0x2A;
        }
    } else if (L(0) == 0xF5) {
        if      (L(1) == 0x13) { n_hdr = 0x0A; k_lab = 0x2A; }
        else if (L(1) == 0x14) { n_hdr = 0x29; k_lab = 0x49; }
        else if (L(1) == 0x15) { n_hdr = 0x14; k_lab = 0x34; }
        if (n_hdr) compare_copy_hi(&L(k_hdr), &P(k_hdr), n_hdr, 0x200000);
    } else if (L(0) == 0xF6 && L(1) == 0x23) {
        compare_copy_hi(&L(0x20), &P(0x20), 0x15, 0x200000);
        k_lab = 0x35;
    }
    if (k_lab)
        for (i = 0; i < 20; i++) {       /* 20 key labels and 20 key attributes */
            if (L(k_lab + i) != P(k_lab + i))           { post_event_hi(0x100000); L(k_lab + i) = P(k_lab + i); }
            if (L(k_lab + 20 + i) != P(k_lab + 20 + i)) { post_event_hi(0x100000); L(k_lab + 20 + i) = P(k_lab + 20 + i); }
        }
    ui_flush_events();
}

/* FFEFDDD4-FFEFDE04 (48 B)  scr20_draw_all  (alias sub_FFEFDDD4)         Confirmed */
void scr20_draw_all(void)
{
    u8 t = scr20_kbd_type();
    ui_8D79 = 0; layer_copy_lcd(0, 0);
    scr20_draw_field(kbd_field_rect[t][0], kbd_field_rect[t][1]);
    scr20_draw_keys();
}

/* FFEFDE04-FFEFE19E (922 B)  scr20_draw_field  (alias sub_FFEFDE04, +DE8C/DEAD/DF38/DF50/DF73/DFFE/E016/E039/E0B7/E0DA/E155/E178) Confirmed
 * Draws the edit field for the current page.  Glyph pitch 14 px; the cursor
 * cell blinks as an orange box (0xF980); 0xFF bytes print as ' ' or '.'.
 *   F623: 20 cells from x+0x14, stops at NUL.
 *   F3B8 / F513: 9 cells from x+0x61, y+2; cursor index 6 draws a 42-px box.
 *   F514: 20 cells from x+0x14; NUL and 0xFF both print '.'.
 *   F515: 19 cells from x+0x1B, stops at NUL, 0xFF -> '.'; cursor = +0x20 + 3.
 *   F3B3: no case -> the field stays empty. */
void scr20_draw_field(u16 x, u16 y)
{
    u8 t = scr20_kbd_type(), op = L(0), code = L(1), blink = blink_phase(), i, ch, cur = L(0x20);
    const u16 *r = kbd_field_rect[t];
    u16 xx;
    layer_copy_rect(r[0], r[1], r[2], r[3]);
    if (op == 0xF6) {
        if (code != 0x23) return;
        for (xx = 0x14, i = 0; i < 20; i++, xx += 0x0E) {          /* F623 */
            if ((ch = L(0x21 + i)) == 0) return;
            if (i == cur && blink == 1) fill_rect(x + xx, y + 3, 0x0E, 0x1C, 0xF980);
            draw_glyph(x + xx, y + 3, 0x0D, ch, 1);
        }
    } else if ((op == 0xF3 && code == 0xB8) || (op == 0xF5 && code == 0x13)) {
        for (xx = 0x61, i = 0; i < 9; i++, xx += 0x0E) {           /* F3B8 CALLSIGN, F513 */
            if ((ch = L(0x21 + i)) == 0) return;
            if (ch == 0xFF) ch = ' ';
            if (i == cur && blink == 1) fill_rect(x + xx, y + 2, (cur == 6) ? 0x2A : 0x0E, 0x1C, 0xF980);
            draw_glyph(x + xx, y + 2, 0x0D, ch, 1);
        }
    } else if (op == 0xF5 && code == 0x14) {
        for (xx = 0x14, i = 0; i < 20; i++, xx += 0x0E) {           /* F514 */
            ch = L(0x21 + i);
            if (ch == 0 || ch == 0xFF) ch = '.';
            if (i == cur && blink == 1) fill_rect(x + xx, y + 2, 0x0E, 0x1C, 0xF980);
            draw_glyph(x + xx, y + 2, 0x0D, ch, 1);
        }
    } else if (op == 0xF5 && code == 0x15) {
        for (xx = 0x1B, i = 0; i < 19; i++, xx += 0x0E) {           /* F515 */
            if ((ch = L(0x21 + i)) == 0) return;
            if (ch == 0xFF) ch = '.';
            if (i == cur + 3 && blink == 1) fill_rect(x + xx, y + 2, 0x0E, 0x1C, 0xF980);
            draw_glyph(x + xx, y + 2, 0x0D, ch, 1);
        }
    }                                                              /* F3B3: nothing */
}

/* FFEFE19E-FFEFE1BA (28 B)  scr20_draw_keys  (alias sub_FFEFE19E)        Confirmed */
void scr20_draw_keys(void) { for (u8 i = 0; i < 20; i++) draw_icon(i); }

/* FFEFE1BA-FFEFE223 (105 B)  scr20_kbd_type  (alias sub_FFEFE1BA)        Confirmed
 * F3B3 -> 0, F3B8 -> 1, F513 -> 2, F514 -> 3, F515 -> 4, any F6xx -> 5, else 0.
 * Index into kbd_field_rect (0x12586). */
u8 scr20_kbd_type(void)
{
    switch (L(0)) {
    case 0xF3: return (L(1) == 0xB8) ? 1 : 0;
    case 0xF5: return (L(1) == 0x13) ? 2 : (L(1) == 0x14) ? 3 : (L(1) == 0x15) ? 4 : 0;
    case 0xF6: return 5;
    default:   return 0;
    }
}

/* ========================================================================== *
 * 3. Screen 0x1F - SET-MODE item page (IPC F3xx / F400; docs 23, 38, 44, 45)
 *    Phase table 0xFFED7488, event table 0xFFED7498 ([0xF] value area,
 *    [0x10] soft-key strip, [0x11..0x13] soft keys 0..2).
 * ========================================================================== */
extern void (*const scr1F_phase_tbl[4])(void);   /* 0xFFED7488 */
extern void (*const scr1F_event_tbl[0x14])(void);/* 0xFFED7498 */

/* FFEFE223-FFEFE28F (108 B)  scr1F_item_handler  (alias sub_FFEFE223)    Confirmed (table 0xFFED40CC)
 * Phase dispatch, except that a pending frame with header byte 6 == 0 for
 * item 0x4D while the latched group is 4 (SIGNALING) suspends the screen
 * (nothing runs).  Item 0x4D is the only store case that also latches byte 6. */
void scr1F_item_handler(void)
{
    if (ui_phase > 3) { ui_phase = 3; return; }
    u8 grp = item_group();
    if (P(6) == 0 && grp == 4 && P(1) == 0x4D) return;
    scr1F_phase_tbl[ui_phase]();
}

/* FFEFE28F-FFEFE2A1 (18 B)  scr1F_phase0_init  (alias sub_FFEFE28F)      Confirmed */
void scr1F_phase0_init(void) { scr1F_latch(1); ui_phase++; }

/* FFEFE2A1-FFEFE438 (407 B)  scr1F_phase1_title  (alias sub_FFEFE2A1, +E2B5) Confirmed
 * Title row: item 0xD3 and item 0x65 draw an 11-glyph bitmap title
 * (0x690F8 / 0x69124) centred with 1 px gaps; every other item draws its
 * group title text, centred on a 13-px pitch using title_len_by_group
 * (odd lengths add one cell).  Then the soft-key layout for the item. */
void scr1F_phase1_title(void)
{
    u8 grp, i, code; u16 x, y = 0;
    surface_reset(); clear_screen_with_bar();
    grp = item_group(); code = L(1);
    if (code == 0xD3 || code == 0x65) {
        const u16 *const *g = (code == 0xD3) ? title_glyphs_690F8 : title_glyphs_69124;
        x = (0x140 - (11 * 13 + 13)) / 2;
        for (i = 0; i < 11; i++) { draw_bitmap(x, y + 4, 1, g[i]); x += *g[i] + 1; }
    } else {
        u8 n = title_len_by_group[grp];
        x = (n & 1) ? (0x140 - (n * 13 + 13)) / 2 : (0x140 - n * 13) / 2;
        draw_group_title(x, y, grp);
    }
    switch (code) {
    case 0xD2: case 0xD3: case 0x92:           draw_softkey_bar(6);    break;
    case 0x4B: case 0x41: case 0xC3:           draw_softkey_bar(0x0A); break;
    case 0x71: case 0x8A: case 0x96:           draw_softkey_bar(8);    break;
    case 0xB9: case 0xBA:                      draw_softkey_bar(0x12); break;
    default: break;
    }
    ui_phase++;
}

/* FFEFE438-FFEFE465 (45 B)  scr1F_phase2_body  (alias sub_FFEFE438)      Confirmed */
void scr1F_phase2_body(void)
{ if (layer_begin(&ui_layer, 0, 0, 0x140, 240) == 1) { item_draw_page(); layer_end(); } }

/* FFEFE465-FFEFE50C (167 B)  scr1F_ev15_value  (alias sub_FFEFE465, +E4DD) Confirmed
 * Value-area rectangle per item code from RAM table 0x125B6 [hi nibble][lo nibble]. */
void scr1F_ev15_value(void)
{
    const u16 *r = item_value_rect[L(1) >> 4][L(1) & 0x0F];
    if (layer_begin(&ui_layer, r[0], r[1], r[2], r[3]) == 1) {
        layer_copy_rect(r[0], r[1], r[2], r[3]); item_draw_value(); layer_end();
    }
}

/* FFEFE50C-FFEFE54B (63 B)  scr1F_ev16_softkeys  (alias sub_FFEFE50C, +E50E) Confirmed
 * Soft-key strip y=183..240. */
void scr1F_ev16_softkeys(void)
{
    if (layer_begin(&ui_layer, 0, 183, 0x140, 0x39) == 1) {
        layer_copy_rect(0, 183, 0x140, 0x39); item_draw_softkeys(); layer_end();
    }
}

/* FFEFE54B-FFEFE5BD (114 B)  scr1F_ev_softkey  (alias sub_FFEFE54B, +E54E/E596) Confirmed */
void scr1F_ev_softkey(void) { softkey_redraw(ui_event - 0x11); }

/* FFEFE5BD-FFEFE649 (140 B)  scr1F_phase3_events  (alias sub_FFEFE5BD)   Confirmed
 * Unlike the other screens it re-latches on every pass, and clears all
 * events when a handler dropped the phase back to 0..2. */
void scr1F_phase3_events(void)
{
    scr1F_latch(0);
    ui_event = ui_next_event();
    if (ui_event != 0xFF && ui_event <= 0x13 && !lcd_queue_busy()) {
        ui_clear_event(ui_event);
        scr1F_event_tbl[ui_event]();
    }
    if (ui_phase >= 4) { ui_phase = 3; return; }
    if (ui_phase <= 2) ui_clear_all_events();
}

/* FFEFE649-FFEFE664 (27 B)  scr1F_latch  (alias sub_FFEFE649)            Confirmed */
void scr1F_latch(u8 clear_events)
{ scr1F_latch_header(); item_store_dispatch(); hdr_latch_13_1A(); if (clear_events == 1) ui_clear_all_events(); }

/* FFEFE664-FFEFE6AF (75 B)  scr1F_latch_header  (alias sub_FFEFE664)     Confirmed (doc 38 A1)
 * Byte 0 is copied silently; a new item code (byte 1) posts event 0. */
void scr1F_latch_header(void)
{
    if (L(0) != P(0)) L(0) = P(0);
    if (L(1) != P(1)) { post_event_lo(1); L(1) = P(1); }
}

/* FFEFE6AF-FFEFE727 (120 B)  item_store_dispatch  (alias sub_FFEFE6AF)   Confirmed (doc 38) */
void item_store_dispatch(void)
{
    switch (item_group()) {
    case 0:    item_store_g0();      break;
    case 1:    item_store_display(); break;
    case 2: case 0x15: case 0x16: case 0x17: item_store_txrx(); break;
    case 3:    item_store_memory();  break;
    case 4:    item_store_signaling(); break;
    case 5:    item_store_scan();    break;
    case 6:    item_store_dpid();    break;
    case 7:    item_store_wiresx();  break;
    case 8:    item_store_config();  break;
    case 9:    item_store_aprs();    break;
    case 0x0A: item_store_grpA();    break;
    case 0x0B: item_store_grpB();    break;
    default:   break;
    }
    ui_flush_events();
}

/* --- Store handlers.  Each compares frame_latched[k] with frame_pending[k],
 *     posts EV_VALUE (or a row event) and copies on change.  Item names are
 *     from docs 38/44/45.  ------------------------------------------------- */

/* FFEFE727-FFEFEA4B (804 B)  item_store_display  (alias sub_FFEFE727)    Confirmed (group 1) */
void item_store_display(void)
{
    switch (L(1)) {
    case 0x10: case 0x11: case 0x12: case 0x13:   /* TARGET LOCATION, COMPASS, BAND SCOPE */
    case 0x15: case 0x16: case 0x17: case 0x1A:   /* LANGUAGE, (LEVEL 1..15), LCD DIMMER, F31A */
        latch1(0x20); break;
    case 0x14:                                    /* LAMP: +0x20/21 flags, KEY +0x22, SAVE +0x23 */
        latch_pair(0x20); latch_each(0x22, 2, EV_VALUE); break;
    case 0x18:                                    /* OPENING MESSAGE */
        latch1(0x20);
        latch_each(0x21, 16, EV_VALUE);           /* DC text            */
        latch_each(0x31, 2,  EV_VALUE);           /* message attribute  */
        latch_each(0x33, 16, EV_VALUE);           /* message text       */
        latch_each(0x43, 10, EV_VALUE);           /* callsign 1         */
        latch_each(0x4D, 10, EV_VALUE);           /* callsign 2         */
        break;
    case 0x19: latch_each(0x20, 9, EV_VALUE); break;      /* SENSOR INFO (VOLT text) */
    case 0x1B: LATCH_BLOCK(0x20, 0x0A, EV_VALUE); break;  /* SOFTWARE VERSION */
    default: break;
    }
}

/* FFEFEA4B-FFEFECA4 (601 B)  item_store_txrx  (alias sub_FFEFEA4B)       Confirmed (groups 2, 0x15-0x17) */
void item_store_txrx(void)
{
    u8 c = L(1);
    if (c == 0x2B || c == 0x2C) { latch_pair(0x20); latch_each(0x22, 2, EV_VALUE); }
    else if (c == 0x22) latch_pair(0x20);                     /* RX MODE */
    else if (c == 0x23) {                                     /* 5 bytes as one unit */
        if (L(0x20) != P(0x20) || L(0x21) != P(0x21) || L(0x22) != P(0x22) ||
            L(0x23) != P(0x23) || L(0x24) != P(0x24)) {
            post_event_lo(EV_VALUE);
            for (u8 k = 0x20; k <= 0x24; k++) L(k) = P(k);
        }
    }
    else if ((c >= 0x24 && c <= 0x2A) || c == 0x20 || c == 0x21) latch1(0x20);
}

/* FFEFECA4-FFEFF034 (912 B)  item_store_memory  (alias sub_FFEFECA4)     Confirmed (group 3)
 * 0x34 MEMORY SKIP: value 2 (SELECT) registers the value area with the blink
 * timer, any other value unregisters it. */
void item_store_memory(void)
{
    u8 i;
    switch (L(1)) {
    case 0x33: case 0x35: latch1(0x20); break;              /* MEMORY PROTECT / WRITE */
    case 0x34:
        if (L(0x20) != P(0x20)) {
            if (P(0x20) == 2) blink_register(0, EV_VALUE); else blink_unregister(0, EV_VALUE);
            post_event_lo(EV_VALUE); L(0x20) = P(0x20);
        }
        break;
    case 0x30:                                              /* BANK LINK: 5 x 0x13 records */
        latch_pair(0x20);
        for (i = 0; i < 5; i++) {
            u8 r = 0x13 * i;
            if (L(0x22 + r) != P(0x22 + r) || L(0x23 + r) != P(0x23 + r) || L(0x34 + r) != P(0x34 + r)) {
                post_event_lo(EV_VALUE);
                L(0x22 + r) = P(0x22 + r); L(0x23 + r) = P(0x23 + r); L(0x34 + r) = P(0x34 + r);
            }
            latch_each(0x24 + r, 16, EV_VALUE);
        }
        break;
    case 0x31:                                              /* BANK NAME: 5 x 0x12 records */
        latch_pair(0x20);
        for (i = 0; i < 5; i++) {
            u8 r = 0x12 * i;
            latch_pair(0x22 + r);
            latch_each(0x24 + r, 16, EV_VALUE);
        }
        break;
    }
}

/* FFEFF034-FFEFF4E5 (1201 B)  item_store_signaling  (alias sub_FFEFF034) Confirmed (group 4, table 0xFFF48150)
 * Jump table on code-0x40 (14 cases). */
void item_store_signaling(void)
{
    u8 i, c = L(1);
    if ((u8)(c - 0x40) > 0x0D) return;
    switch (c) {
    case 0x42: case 0x46: case 0x47: case 0x49: case 0x4A: latch1(0x20); break;
    case 0x40: case 0x4C: latch_pair(0x20); latch_each(0x22, 2, EV_VALUE); break; /* BELL ... */
    case 0x41: case 0x4B:
        if (L(0x20) != P(0x20)) {                          /* bit 7 = blinking field */
            if ((P(0x20) >> 7) == 1) blink_register(0, EV_VALUE); else blink_unregister(0, EV_VALUE);
            post_event_lo(EV_VALUE); L(0x20) = P(0x20);
        }
        for (i = 0; i < 2; i++) { latch_each(0x21 + i, 1, EV_ROW2(i)); latch_each(0x23 + i, 1, EV_ROW2(i)); }
        break;
    case 0x43: latch_pair(0x20); latch_each(0x22, 3, EV_VALUE); break;
    case 0x45: latch_pair(0x20); latch_each(0x22, 5, EV_VALUE); break;
    case 0x48:
        if (L(0x20) != P(0x20)) {
            /* movu.b then signed "cmp #0 / ble": only 0 takes the else */
            if (P(0x20) != 0) blink_register(0, EV_VALUE); else blink_unregister(0, EV_VALUE);
            post_event_lo(EV_VALUE); L(0x20) = P(0x20);
        }
        break;
    case 0x44:                                             /* 5 x 16-byte rows */
        latch_pair(0x20);
        for (i = 0; i < 5; i++) latch_each(0x22 + 16 * i, 16, EV_VALUE);
        break;
    case 0x4D: latch1(0x20); latch1(6); break;             /* also header byte 6 */
    }
}

/* FFEFF4E5-FFEFF68A (421 B)  item_store_scan  (alias sub_FFEFF4E5)       Confirmed (group 5) */
void item_store_scan(void)
{
    u8 c = L(1);
    if ((c >= 0x50 && c <= 0x52) || c == 0x55) latch1(0x20);   /* DW TIME, SCAN LAMP, RE-START, PRI REVERT */
    else if (c == 0x53) { latch_pair(0x20); latch_each(0x22, 2, EV_VALUE); }   /* SCAN RESUME */
    else if (c == 0x54) { latch_pair(0x20); latch_each(0x22, 3, EV_VALUE); }   /* SCAN WIDTH  */
}

/* FFEFF68A-FFEFF710 (134 B)  item_store_dpid  (alias sub_FFEFF68A)       Confirmed (group 6; 0x64 has no case, doc 44) */
void item_store_dpid(void)
{
    if (L(1) == 0x63) latch_each(0x20, 5, EV_VALUE);               /* RADIO ID */
    else if (L(1) == 0x65) LATCH_BLOCK(0x20, 6, EV_VALUE);         /* DG-ID TX/RX page */
}

/* FFEFF710-FFEFF906 (502 B)  item_store_wiresx  (alias sub_FFEFF710)     Confirmed (group 7) */
void item_store_wiresx(void)
{
    u8 i, c = L(1);
    if (c == 0x71) { LATCH_BLOCK(0x20, 6, EV_VALUE); latch1(0x26); latch1(0x27); }   /* RPT/WIRES FREQ */
    else if (c == 0x72) latch1(0x20);                                                /* SEARCH SETUP */
    else if (c >= 0x73 && c <= 0x75) {                                               /* 5 x 16 tag rows */
        latch1(0x20);
        for (i = 0; i < 5; i++) latch_each(0x21 + 16 * i, 16, EV_VALUE);
    }
    else if (c == 0x76) { latch1(0x20); latch1(0x21); }                              /* DG-ID */
}

/* FFEFF906-FFEFFEB8 (1458 B)  item_store_config  (alias sub_FFEFF906)    Confirmed (group 8, table 0xFFF4816C) */
void item_store_config(void)
{
    u8 i, c = L(1);
    if ((u8)(c - 0x80) > 0x17) return;
    switch (c) {
    case 0x80: case 0x81: case 0x84: case 0x85: case 0x86: case 0x88: case 0x89:
    case 0x8C: case 0x8D: case 0x8E: case 0x90: case 0x91: case 0x93: case 0x94: case 0x97:
        latch1(0x20); break;
    case 0x82: case 0x95: latch_pair(0x20); latch_each(0x22, 2, EV_VALUE); break;
    case 0x83: latch_pair(0x20); latch_each(0x22, 3, EV_VALUE); break;
    case 0x87: break;                                       /* no store */
    case 0x8A: LATCH_BLOCK(0x20, 8, EV_VALUE); latch_each(0x28, 1, EV_ROW2(0)); latch_each(0x29, 1, EV_ROW2(0)); break;
    case 0x8B: latch1(0x20); latch_each(0x21, 4, EV_VALUE); break;
    case 0x8F: latch_each(0x20, 3, EV_VALUE); break;
    case 0x92:                                              /* 7 bytes as one unit + 3 soft keys */
        if (L(0x20) != P(0x20) || L(0x26) != P(0x26) || L(0x21) != P(0x21) || L(0x22) != P(0x22) ||
            L(0x23) != P(0x23) || L(0x24) != P(0x24) || L(0x25) != P(0x25)) {
            post_event_lo(EV_VALUE);
            for (u8 k = 0x20; k <= 0x26; k++) L(k) = P(k);
        }
        for (i = 0; i < 3; i++) { latch_each(0x27 + i, 1, EV_ROW2(i)); latch_each(0x2A + i, 1, EV_ROW2(i)); }
        break;
    case 0x96: LATCH_BLOCK(0x20, 1, EV_VALUE); latch_each(0x21, 1, EV_ROW2(0)); latch_each(0x22, 1, EV_ROW2(0)); break;
    }
}

/* FFEFFEB8-FFF000AC (500 B)  item_store_aprs  (alias sub_FFEFFEB8)       Confirmed (group 9, table 0xFFF4819C, doc 45)
 * Jump table on code-0xA0 (31 cases): one-byte latch, a block of n bytes, or nothing. */
void item_store_aprs(void)
{
    u8 c = L(1), n;
    if ((u8)(c - 0xA0) > 0x1E) return;
    switch (c) {
    case 0xA0: case 0xA3: case 0xA7: case 0xAB: case 0xAD: case 0xAF:
    case 0xB1: case 0xB5: case 0xB6: case 0xB9: case 0xBC: case 0xBE: latch1(0x20); return;
    case 0xA1: case 0xB3: case 0xB8: return;                /* no store */
    case 0xA2: n = 0x0B; break;
    case 0xA4: case 0xAC: case 0xAE: case 0xB4: case 0xB7: n = 0x05; break;
    case 0xA5: n = 0x38; break;                             /* MSG GROUP: 6 x 9-char names (doc 45) */
    case 0xA6: n = 0x62; break;
    case 0xA8: n = 0x13; break;
    case 0xA9: n = 0x15; break;
    case 0xAA: n = 0x0A; break;
    case 0xB0: n = 0x0D; break;
    case 0xB2: n = 0x35; break;
    case 0xBA: n = 0x11; break;
    case 0xBB: n = 0x18; break;
    case 0xBD: n = 0x0C; break;
    default: return;
    }
    LATCH_BLOCK(0x20, n, EV_VALUE);
}

/* FFF000AC-FFF00220 (372 B)  item_store_grpA  (alias sub_FFF000AC)       Confirmed (group 0xA, doc 45) */
void item_store_grpA(void)
{
    u8 i, c = L(1);
    if (c == 0xC3) {                                        /* +0x20 then 4 records of 0x13 */
        LATCH_BLOCK(0x20, 1, EV_VALUE);
        for (i = 0; i < 4; i++) {
            u8 r = 0x13 * i;
            LATCH_BLOCK(0x21 + r, 1, EV_VALUE);
            LATCH_BLOCK(0x22 + r, 1, EV_VALUE);
            LATCH_BLOCK(0x33 + r, 1, EV_VALUE);
            LATCH_BLOCK(0x23 + r, 0x10, EV_VALUE);
        }
        for (i = 0; i < 2; i++) { LATCH_BLOCK(0x6D + i, 1, EV_ROW2(i)); LATCH_BLOCK(0x6F + i, 1, EV_ROW2(i)); }
    } else if (c >= 0xC0 && c <= 0xC2) latch1(0x20);
}

/* FFF00220-FFF00462 (578 B)  item_store_grpB  (alias sub_FFF00220)       Confirmed (group 0xB, doc 45) */
void item_store_grpB(void)
{
    u8 i, c = L(1);
    if (c == 0xD0) { latch_pair(0x20); latch_each(0x22, 3, EV_VALUE); }
    else if (c == 0xD2) {
        if (L(0x21) != P(0x21)) {                          /* value 3 blinks */
            if (P(0x21) == 3) blink_register(0, EV_VALUE); else blink_unregister(0, EV_VALUE);
            post_event_lo(EV_VALUE);                       /* copied by the block below */
        }
        LATCH_BLOCK(0x20, 0x1E, EV_VALUE);
        for (i = 0; i < 3; i++) { LATCH_BLOCK(0x3E + i, 1, EV_ROW2(i)); LATCH_BLOCK(0x41 + i, 1, EV_ROW2(i)); }
    }
    else if (c == 0xD3) {
        LATCH_BLOCK(0x20, 0x52, EV_VALUE);
        for (i = 0; i < 3; i++) { LATCH_BLOCK(0x72 + i, 1, EV_ROW2(i)); LATCH_BLOCK(0x75 + i, 1, EV_ROW2(i)); }
    }
    else if (c == 0xD4) latch1(0x20);
}

/* FFF00462-FFF0049D (59 B)  item_store_g0  (alias sub_FFF00462)          Confirmed (group 0: F400 TX POWER, doc 38) */
void item_store_g0(void) { if (L(1) == 0) latch1(0x20); }

/* FFF0049D-FFF004C2 (37 B)  item_draw_page  (alias sub_FFF0049D)         Confirmed
 * Phase-2 body of screen 0x1F: everything below the 29-px title row. */
void item_draw_page(void)
{
    ui_8D79 = 0; layer_copy_lcd(0, 0);
    layer_copy_rect(0, 0x1D, 0x140, 211);
    item_draw_value();
}

/* FFF004C2-FFF005A9 (231 B)  item_draw_value  (alias sub_FFF004C2)       Confirmed (doc 38 A1 step 4, doc 45)
 * Per-group value drawer, then the row label (walker) and the divider under
 * row 1.  Items 0x65, 0xC3 and 0xD3 are full-page views: no label. */
void item_draw_value(void)
{
    u8 grp = item_group(), row = item_row(), c;
    switch (grp) {
    case 0:  draw_value_g0(); return;                     /* sub_FFF0878C (F400 TX POWER) */
    case 1:  draw_value_display(); break;
    case 2: case 0x15: case 0x16: case 0x17: draw_value_txrx(); break;
    case 3:  draw_value_memory(); break;
    case 4:  draw_value_signaling(); break;
    case 5:  draw_value_scan(); break;                    /* sub_FFF0324E */
    case 6:  draw_value_dpid();  if (L(1) == 0x65) return; break; /* sub_FFF0381A */
    case 7:  draw_value_wiresx(); break;                  /* sub_FFF03AD8 */
    case 8:  draw_value_config(); break;                  /* sub_FFF04090 */
    case 9:  draw_value_aprs(); break;                    /* sub_FFF057FF */
    case 0xA: draw_value_grpA(); if (L(1) == 0xC3) return; break; /* sub_FFF07E49 */
    case 0xB: draw_value_grpB(); if (L(1) == 0xD3) return; break; /* sub_FFF08201 */
    default: break;
    }
    draw_item_label(6, 0x1D, grp, row);
    c = L(1);
    if (c != 0xB2 && c != 0xBA) draw_row_divider(1);
}

/* FFF005A9-FFF00684 (219 B)  item_draw_softkeys  (alias sub_FFF005A9, +FFF00652) Confirmed
 * Callers: scr1F_ev16_softkeys and many group drawers (FFF02292, FFF02EE9 ...).
 * The icon set matches the soft-key bar chosen in scr1F_phase1_title. */
void item_draw_softkeys(void)
{
    u8 i, c = L(1);
    switch (c) {
    case 0xD2: case 0xD3: case 0x92: for (i = 0; i < 3; i++) draw_icon(i); break;
    case 0x4B: case 0x41: case 0xC3: for (i = 0; i < 2; i++) draw_icon(i); break;
    case 0x8A: case 0x96: case 0xBA: draw_icon(0); break;
    case 0x71:                                   /* RPT/WIRES FREQ: icon only for PRESET with data */
        if (L(0x21) == 1 && L(0x20) != 0) draw_icon(0);
        else fill_rect(0x6B, 183, 0x6A, 0x39, 0x0000);
        break;
    default: break;
    }
}

/* ========================================================================== *
 * 4. Value drawers for the SET-MODE item page (screen 0x1F).
 *    Layout constants shared by all of them: value column x=0x22, rows at
 *    y=0x41/0x65/0x89/0xAD (pitch 0x24), the row cursor bitmap
 *    CURSOR = stru_FFECFDCC blitted at x=6 (or at the column being edited),
 *    and draw_row_divider(n) under row n.  Font 0x0D throughout.
 *    ui_lang == 0 selects the Japanese strings/JIS glyphs (doc 38/44).
 *    Item names: ida/out/sub-labels/f3xx-codes.tsv (doc 38) and doc 44.
 * ========================================================================== */
#define CURSOR ((const void *)0xFFECFDCC)
#define TXT(x, y, len, s) draw_text((x), (y), 0x0D, 0, (len), (s), 1)
#define JIS(x, y, code)   draw_glyph((x), (y), 2, (code), 1)
void draw_list_divider_narrow(u8 row);   /* sub_FFF0884A: fill_rect(6,0x18+0x24*row,0x12D,1,0xAD95) */
void draw_checkbox(u16 x, u16 y, u8 on); /* sub_FFF0886E: 20x20 white box, ticked when on */
void draw_scrollbar(u16 x, u16 y, u16 w, u16 h, u8 total, u8 visible, u8 pos); /* sub_FFEFAA2B */
void draw_smeter_preview(void);          /* sub_FFEF9B22 (Inferred) */
void *memcpy(void *d, const void *s, u32 n); /* sub_FFEFB268 (doc 25); smovf block copies are shown as memcpy too */
/* ROM strings/tables are named by their IDA symbols (addresses in comments where a doc gives them). */
extern const char aOff[], aOff_0[], aOff_5[], aOff_7[], aFK8l[], a1q8l[], aLevel_1[], aLevel_2[], aLevel_3[],
                  aO51015202530se[], aOB3[], aTimes[], a02302502603103[], aU[], aAw[], a00hz[], a670[];

/* FFF00684-FFF0104F (2507 B)  draw_value_display  (alias sub_FFF00684, +006C8..00EAC, 00ED4..0102F) Confirmed
 * Group 1 DISPLAY, jump table 0xFFF481DA on code-0x11 (11 cases).  Values and
 * tables match doc 44 F2; coordinates are added here. */
void draw_value_display(void)
{
    u8 v = L(0x20); char buf[4], t[20];
    switch (L(1)) {
    case 0x11: TXT(0x22, 0x41, 7, v == 0 ? "COMPASS" : "NUMERIC"); break;     /* TARGET LOCATION */
    case 0x12: if (v == 0) TXT(0x22, 0x41, 8, "NORTH UP"); else TXT(0x22, 0x41, 10, "HEADING UP"); break;
    case 0x13: {                                                                /* BAND SCOPE */
        static const char tbl[15] = "19 CH\0" "39 CH\0" "79 CH";               /* stride 5 */
        if (v >= 3) v = 2;
        TXT(0x22, 0x41, 5, &tbl[5 * v]); break; }
    case 0x14: {                                                                /* LAMP: KEY + SAVE */
        u8 key = L(0x22) % 11;
        if (ui_lang == 0) {
            TXT(0x22, 0x41, 6, (const char *)0xFFF486D7);                       /* JIS-X0201 "ｷｰ :" */
            if (key == 0)       TXT(0x8C, 0x41, 3, "OFF");
            else if (key == 10) { JIS(0x8C, 0x41, 0x4F22); JIS(0x8C + 0x1F, 0x41, 0x4233); } /* 継続 */
            else { TXT(0x8C, 0x41, 3, aOff_5 /*0xFFF486E1, doc 44*/ + 4 * key); JIS(0x8C + 0x2B, 0x41, 0x4943); } /* n 秒 */
        } else {
            TXT(0x22, 0x41, 6, "KEY :");
            TXT(0x8C, 0x41, 10, (const char *)0xFFF4870D + 10 * key);           /* OFF..CONTINUOUS (doc 44) */
        }
        draw_row_divider(2);
        TXT(0x22, 0x65, 6, "SAVE:");
        if (L(0x23) == 1) TXT(0x8C, 0x65, 4, "ON"); else if (L(0x23) == 0) TXT(0x8C, 0x65, 3, "OFF");
        blit(L(0x20) == 0 ? 6 : 0x6E, L(0x21) == 0 ? 0x41 : 0x65, CURSOR);      /* column x row */
        draw_row_divider(3);
        return; }
    case 0x15:                                                                  /* LANGUAGE */
        if (v == 0) { TXT(0x22, 0x41, 10, "JAPANESE :"); draw_label(0xBC, 0x41, 0xA800, aFK8l /* JIS 日本語 */); }
        else        { TXT(0x22, 0x41, 10, "ENGLISH  :"); draw_label(0xBC, 0x41, 0xA000, a1q8l /* JIS 英語 */); }
        break;
    case 0x16:                                                                  /* hidden LEVEL 1..15 (doc 44 F8) */
        if (v >= 15) v = 14;
        fmt_2sp(buf, v + 1);
        if (ui_lang == 0) { TXT(0x22, 0x41, 3, (const char *)0xFFF487AC); TXT(0x60, 0x41, 2, buf + 1); }
        else              { TXT(0x22, 0x41, 5, "LEVEL");                  TXT(0x8B, 0x41, 2, buf + 1); }
        break;
    case 0x17:                                                                  /* LCD DIMMER 1..6 */
        if (v >= 6) v = 5;
        fmt_uint(buf, v + 1);
        if (ui_lang == 0) { memcpy(t, (const void *)0xFFF487B6, 6); t[4] = buf[0]; TXT(0x22, 0x41, 5, t); }
        else              { memcpy(t, aLevel_1, 8);                 t[6] = buf[0]; TXT(0x22, 0x41, 7, t); }
        break;
    case 0x18:                                                                  /* OPENING MESSAGE */
        switch (v) {
        case 0: TXT(0x22, 0x41, 3, "OFF"); break;
        case 1: TXT(0x22, 0x41, 2, "DC"); TXT(0x22, 0x65, 2, ": "); TXT(0x61, 0x65, 10, (const char *)&L(0x21)); break;
        case 2:
            TXT(0x22, 0x41, 7, "MESSAGE"); TXT(0x22, 0x65, 2, ": ");
            draw_label(0x46, 0x65, (u16)(L(0x31) << 8 | L(0x32)), (const char *)&L(0x33)); /* attr word = JIS map */
            TXT(0x22, 0xAD, 4, "PUSH"); JIS(0x5A, 0xAD, 0x2148);                 /* PUSH “DISP” */
            TXT(0x76, 0xAD, 4, "DISP"); JIS(0xAE, 0xAD, 0x2149);
            break;
        case 3:
            TXT(0x22, 0x41, 8, "CALLSIGN");
            TXT(0x22, 0x65, 2, ": "); TXT(0x61, 0x65, 10, (const char *)&L(0x43));
            TXT(0x22, 0x89, 2, ": "); TXT(0x61, 0x89, 10, (const char *)&L(0x4D));
            break;
        default: break;                                                         /* >= 4: blank */
        }
        blit(6, 0x41, CURSOR); draw_row_divider(4);
        return;
    case 0x19:                                                                  /* SENSOR INFO */
        if (ui_lang == 0) { JIS(0x0F, 0x59, 0x4545); JIS(0x2D, 0x59, 0x3035); } /* 電圧 */
        else TXT(0x0F, 0x59, 4, "VOLT");
        TXT(0x6C, 0x59, 1, ":");
        TXT(0x9C, 0x5A, 10, (const char *)&L(0x20));
        return;                                                                 /* no cursor, no divider */
    case 0x1A: return;                                                          /* slot 9 = rtsd: never drawn (doc 44) */
    case 0x1B: {                                                                /* SOFTWARE VERSION */
        char m[20] = "Main Ver.  :  .    ", s[20] = "Sub  Ver.  :  .    ", d[20] = "DSP  Ver.  :  .    ";
        u8 len = 0x13;
        fmt_2sp(buf, L(0x21)); m[0x0C] = buf[1]; m[0x0D] = buf[2];
        fmt_2z (buf, L(0x22)); m[0x0F] = buf[1]; m[0x10] = buf[2];
        fmt_2z (buf, L(0x23)); m[0x11] = buf[1]; m[0x12] = buf[2];
        fmt_2sp(buf, L(0x24)); s[0x0C] = buf[1]; s[0x0D] = buf[2];
        fmt_2z (buf, L(0x25)); s[0x0F] = buf[1]; s[0x10] = buf[2];
        fmt_2z (buf, L(0x26)); s[0x11] = buf[1]; s[0x12] = buf[2];
        fmt_2sp(buf, L(0x27)); d[0x0C] = buf[1]; d[0x0D] = buf[2];
        fmt_2z (buf, L(0x28)); d[0x0F] = buf[1]; d[0x10] = buf[2];
        fmt_2z (buf, L(0x29)); d[0x11] = buf[1]; d[0x12] = buf[2];
        if (L(0x20) == 0) len -= 2;                       /* hide the extra 2 digits (doc 44 F7) */
        TXT(0x22, 0x65, len, m); TXT(0x22, 0x89, len, s); TXT(0x22, 0xAD, len, d);
        return; }
    default: return;
    }
    blit(6, 0x41, CURSOR);                                /* common tail of the one-line items */
    draw_row_divider(2);
}

/* FFF0104F-FFF01C0B (3004 B)  draw_value_txrx  (alias sub_FFF0104F, +01095..01B99) Confirmed
 * Groups 2/0x15-0x17 TX/RX, jump table 0xFFF481F0 on code-0x20 (13 cases).
 * NB code 0x23 has no row of its own (sub_FFF09396 maps it to row 0, so the
 * title shows DIGITAL POPUP), yet its value page is a digital squelch page:
 * "SQL TYPE: OFF/CODE/BREAK", "SQL CODE: nn" and "(WIRES-X)". */
void draw_value_txrx(void)
{
    u8 v = L(0x20); char buf[4], t[0x82];
    switch (L(1)) {
    case 0x20:                                                                  /* ANTENNA ATT */
        if (v == 0) TXT(0x22, 0x41, 3, "OFF");
        else { TXT(0x22, 0x41, 2, "ON"); blit(0x108, 0x46, (const void *)0xFFECEECC); }
        break;
    case 0x21: if (v == 0) TXT(0x22, 0x41, 4, "WIDE"); else TXT(0x22, 0x41, 6, "NARROW"); break;
    case 0x25: case 0x29: case 0x2A:                                            /* LOCATION SERVICE, STANDBY BEEP, DIGITAL VW */
        if (v == 0) TXT(0x22, 0x41, 3, "OFF"); else TXT(0x22, 0x41, 2, "ON");
        break;
    case 0x22:                                                                  /* RX MODE (doc 38: 2 = AUTO) */
        if (v == 0) TXT(0x22, 0x41, 2, "FM"); else if (v == 1) TXT(0x22, 0x41, 2, "AM");
        else if (v == 2) TXT(0x22, 0x41, 4, "AUTO");
        if (L(0x21) == 1) blit(0x108, 0x41, (const void *)0xFFECE5EC);         /* resolved-mode badge */
        else if (L(0x21) == 2) blit(0x108, 0x41, (const void *)0xFFECE5FC);
        else if (L(0x21) == 3) blit(0x108, 0x41, (const void *)0xFFECE60C);
        break;
    case 0x23:                                                                  /* digital SQL page */
        TXT(0x22, 0x60, 10, "SQL TYPE :");
        if (L(0x22) == 0) TXT(0xDE, 0x60, 3, "OFF");
        else if (L(0x22) == 1) TXT(0xDE, 0x60, 4, "CODE");
        else if (L(0x22) == 2) TXT(0xDE, 0x60, 5, "BREAK");
        TXT(0x22, 0x87, 10, "SQL CODE :");
        fmt_2z(buf, L(0x23)); TXT(0xDE, 0x87, 3, buf);
        blit(L(0x20) == 0 ? 0x0B : 0xC2, L(0x21) == 0 ? 0x60 : 0x87, CURSOR);
        if (L(0x24) == 1) TXT(0x36, 0xAE, 9, "(WIRES-X)");
        draw_row_divider(4);
        return;
    case 0x24:                                                                  /* DIGITAL POPUP */
        if (v >= 10) v = 9;
        if (ui_lang == 0) {
            memcpy(t, aOff, 0x46);                          /* 10 x 7 */
            TXT(0x22, 0x41, 7, t + 7 * v);
            if (v != 0) {
                if (v == 9) { JIS(0x22 + 0x46, 0x41, 0x4F22); JIS(0x22 + 0x62, 0x41, 0x4233); } /* 継続 */
                else JIS(0x22 + 0x62, 0x41, 0x4943);                            /* 秒 */
            }
        } else {
            memcpy(t, aOff_7, 0x82);                          /* 10 x 13 */
            TXT(0x22, 0x41, 13, t + 13 * v);
        }
        break;
    case 0x26:                                                                  /* MIC GAIN 1..9 */
        if (v >= 9) v = 8;
        fmt_2sp(buf, v + 1);
        if (ui_lang == 0) { TXT(0x22, 0x41, 4, (const char *)0xFFF48932); TXT(0x22 + 0x38, 0x41, 2, buf + 1); }
        else              { TXT(0x22, 0x41, 6, "LEVEL ");                 TXT(0x22 + 0x46, 0x41, 2, buf + 1); }
        break;
    case 0x27:                                                                  /* MUTE: 4 x 9-char table */
        memcpy(t, aOff_0, 0x24);
        if (v >= 4) v = 3;
        TXT(0x22, 0x41, 9, t + 9 * v);
        if (v != 0) { blit(0x108, 0x44, (const void *)0xFFECE71C); blit(0x108, 0x44, (const void *)0xFFECEF8C); }
        break;
    case 0x28:                                                                  /* RX AF DUAL */
        if (v >= 0x15) v = 0x14;
        if (v <= 9) {                                                           /* TRX 1..10 sec */
            fmt_2sp(buf, v + 1);
            if (ui_lang == 0) { JIS(0x22, 0x41, 0x4177); JIS(0x22 + 0x1C, 0x41, 0x3C75); JIS(0x22 + 0x38, 0x41, 0x3F2E); /* 送受信 */
                                TXT(0x22 + 0x54, 0x41, 2, buf + 1); JIS(0x22 + 0x70, 0x41, 0x4943); }
            else { TXT(0x22, 0x41, 9, "TRX   sec"); TXT(0x22 + 0x38, 0x41, 2, buf + 1); }
        } else if (v >= 11) {                                                   /* TX 1..10 sec */
            fmt_2sp(buf, v - 10);
            if (ui_lang == 0) { JIS(0x22, 0x41, 0x4177); JIS(0x22 + 0x1C, 0x41, 0x3F2E);              /* 送信 */
                                TXT(0x22 + 0x38, 0x41, 2, buf + 1); JIS(0x22 + 0x54, 0x41, 0x4943); }
            else { TXT(0x22, 0x41, 8, "TX   sec"); TXT(0x22 + 0x2A, 0x41, 2, buf + 1); }
        } else {                                                                /* 10 = HOLD */
            if (ui_lang == 0) { JIS(0x22, 0x41, 0x3847); JIS(0x22 + 0x1C, 0x41, 0x446A); }          /* 固定 */
            else TXT(0x22, 0x41, 4, "HOLD");
        }
        break;
    case 0x2B: {                                                                /* VOX: level + delay */
        static const char *const lvl[5] = { "OFF", "LOW", "HIGH", "SEMI LOW", "SEMI HIGH" };
        static const u8 ll[5] = { 3, 3, 4, 8, 9 };
        TXT(0x22, 0x41, 7, "VOX   :");
        if (L(0x22) <= 4) TXT(0xB4, 0x41, ll[L(0x22)], lvl[L(0x22)]);
        TXT(0x22, 0x65, 7, "DELAY :");
        memcpy(t, aO51015202530se, 0x12);                     /* IDA shows "O.51.01.52.02.53.0sec" */
        TXT(0xB4, 0x65, 3, t + 3 * L(0x23));                                    /* NB index not clamped */
        if (ui_lang == 0) JIS(0xEC, 0x65, 0x4943); else TXT(0xEC, 0x65, 3, aO51015202530se + 0x12); /* "sec" */
        blit(L(0x20) == 0 ? 6 : 0x98, L(0x21) == 0 ? 0x41 : 0x65, CURSOR);
        draw_row_divider(2); draw_row_divider(3);
        return; }
    case 0x2C:                                                                  /* RECORDING: band + mic */
        TXT(0x22, 0x41, 5, "BAND:");
        if (L(0x22) == 0) TXT(0xD0, 0x41, 1, "A"); else if (L(0x22) == 1) TXT(0xD0, 0x41, 1, "B");
        else if (L(0x22) == 2) TXT(0xD0, 0x41, 3, "A+B");
        TXT(0x22, 0x65, 5, "MIC :");
        if (L(0x23) == 1) TXT(0xD0, 0x65, 2, "ON"); else if (L(0x23) == 0) TXT(0xD0, 0x65, 3, "OFF");
        blit(L(0x20) == 0 ? 6 : 0xB4, L(0x21) == 0 ? 0x41 : 0x65, CURSOR);
        draw_row_divider(2); draw_row_divider(3);
        return;
    default: return;
    }
    blit(6, 0x41, CURSOR);
    draw_row_divider(2);
}

/* FFF01C0B-FFF01D02 (247 B)  draw_bank_list  (alias sub_FFF01C0B, +01C3A/01C70) Confirmed
 * Callers: draw_value_memory (BANK LINK, BANK NAME), draw_value_signaling (0x44).
 * Five 0x13-byte records {attr_hi, attr_lo, name[16], link}: row i at
 * y=0x3C+0x24*i, number (first+i) at x=6, name (draw_label, attr word) at
 * x=0x30, optional link checkbox at x=0x118, narrow divider under rows 0..3. */
void draw_bank_list(u8 sel, u8 first, u8 with_link, const u8 *rec)
{
    char buf[4];
    for (u8 i = 0; i < 5; i++) {
        const u8 *r = rec + 0x13 * i;
        u16 y = 0x3C + 0x24 * i;
        if (i == sel) fill_rect(6, y + 1, 0x12D, 0x23, 0xF980);
        fmt_2sp(buf, first + i);
        TXT(6, y + 5, 2, buf + 1);
        draw_label(0x30, y + 5, (u16)((r[0] << 8) + r[1]), (const char *)&r[2]);
        if (with_link == 1) draw_checkbox(0x118, y + 5 + 4, r[0x12] == 1);
        if (i <= 3) draw_list_divider_narrow(i + 2);
    }
}

/* FFF01D02-FFF01EFB (505 B)  draw_value_memory  (alias sub_FFF01D02, +01D5D/01DB9/01DCA/01DF7/01E17/01E6D/01E8F/01EC6)  Confirmed
 * Group 3 MEMORY (compare chain 35/31/33/34/30, doc 44 F3).  IDA cut this
 * function in three: the common tail FFF01EFB-FFF01F0C got its own
 * "function" sub_FFF01EFB, and the MEMORY WRITE case FFF01F0C-FFF01F6F is an
 * ownerless code chunk (both included below). */
void draw_value_memory(void)
{
    u8 v = L(0x20), i; u8 rec[5 * 0x13];
    switch (L(1)) {
    case 0x30:                                                     /* BANK LINK */
        draw_bank_list(L(0x20), L(0x21), 1, &L(0x22));
        draw_scrollbar(0x137, 0x3D, 6, 0xB3, 0x18, 5, L(0x21) - 1);  /* 24 banks */
        return;
    case 0x31:                                                     /* BANK NAME: re-pack 0x12 -> 0x13 */
        for (i = 0; i < 5; i++) memcpy(&rec[0x13 * i], &L(0x22 + 0x12 * i), 0x12);
        draw_bank_list(L(0x20), L(0x21), 0, rec);
        draw_scrollbar(0x137, 0x3D, 6, 0xB3, 0x18, 5, L(0x21) - 1);
        return;
    case 0x33:                                                     /* MEMORY PROTECT */
        if (v == 0) TXT(0x22, 0x41, 3, "OFF"); else TXT(0x22, 0x41, 2, "ON");
        break;
    case 0x34:                                                     /* MEMORY SKIP */
        if (v >= 3) v = 2;
        if (v == 0) TXT(0x22, 0x41, 3, "OFF");
        else if (v == 1) { TXT(0x22, 0x41, 4, "SKIP");   blit(0x108, 0x45, (const void *)0xFFECF18C); }
        else             { TXT(0x22, 0x41, 6, "SELECT"); blit(0x108, 0x45, (const void *)0xFFECEE9C); }
        /* falls into the tail at FFF01EFB (IDA "sub_FFF01EFB") */
        break;
    case 0x35:                                                     /* MEMORY WRITE (chunk FFF01F0C) */
        if (v == 0) TXT(0x22, 0x41, 5, "LOWER"); else TXT(0x22, 0x41, 4, "NEXT");
        break;
    default: return;
    }
    blit(6, 0x41, CURSOR);
    draw_row_divider(2);
}

/* FFF01EFB-FFF01F0C (17 B)  draw_value_memory_tail  (alias sub_FFF01EFB)  Confirmed
 * Not a real function: the cursor+divider tail of draw_value_memory's MEMORY
 * SKIP case, reached by fall-through from FFF01EF5 (ends in that function's
 * rtsd #1Ah).  IDA flagged it ptr-root but nothing calls it. */

/* FFF01F70-FFF030D5 (4453 B)  draw_value_signaling  (alias sub_FFF01F70, +01FB3..0309C) Confirmed
 * Group 4 SIGNALING, jump table 0xFFF4820A on code-0x40 (14 cases). */
void draw_value_signaling(void)
{
    u8 v = L(0x20), i; char buf[4], t[0x190]; u16 cx, cy;
    switch (L(1)) {
    case 0x40:                                                     /* BELL */
        TXT(0x22, 0x41, 8, "SELECT :");
        if (L(0x22) == 1) TXT(0xD0, 0x41, 4, "BELL"); else if (L(0x22) == 0) TXT(0xD0, 0x41, 3, "OFF");
        draw_row_divider(2);
        TXT(0x22, 0x65, 8, "RINGER :");
        if (ui_lang == 0) {
            if (L(0x23) == 0) draw_label(0xD0, 0x65, 0xA000, aOB3);   /* JIS "continuous" */
            else { fmt_2sp(buf, L(0x23)); TXT(0xD0, 0x65, 2, buf + 1); JIS(0xEC, 0x65, 0x3273); } /* n 回 */
        } else {
            if (L(0x23) == 0) TXT(0xD0, 0x65, 5, "CONTI");
            else {
                memcpy(t, aTimes, 8);                               /* "..times" */
                fmt_2sp(buf, L(0x23)); t[0] = buf[1]; t[1] = buf[2];
                TXT(0xD0, 0x65, L(0x23) == 1 ? 6 : 7, t);          /* " 1time" / " 5times" */
            }
        }
        blit(L(0x20) == 0 ? 6 : 0xB4, L(0x21) == 0 ? 0x41 : 0x65, CURSOR);
        draw_row_divider(3);
        return;
    case 0x41: {                                                   /* DCS CODE: 104 codes, blinks while editing */
        u8 idx = v & 0x7F, show = 0;
        TXT(0x22, 0x41, 8, "DCS    :");
        if (idx >= 0x69) idx = 0x68;
        if ((v >> 7) == 1) { if (blink_phase() != 0) show = 1; } else show = 1;
        if (show == 1) TXT(0xD0, 0x41, 3, a02302502603103 + 3 * idx);   /* "023025026..." */
        blit(0xB4, 0x41, CURSOR);
        draw_row_divider(2);
        item_draw_softkeys();
        return; }
    case 0x42: {                                                   /* DCS INVERSION: Rx/Tx pair */
        static const u8 rx_inv[6] = { 0, 1, 2, 0, 1, 2 };          /* 0 NORMAL, 1 INVERT, 2 BOTH */
        static const u8 tx_inv[6] = { 0, 0, 0, 1, 1, 1 };
        if (ui_lang == 0) {
            draw_label(0x22, 0x41, 0xA000, aU); /* JIS "Rx" label */
            draw_label(0x22, 0x65, 0xA000, aAw); /* JIS "Tx" label */
            /* values drawn with the JIS strings "F1Aj" (normal, 0xA000), "H?E>0LAj"
             * (invert, 0xAA00) and "N>Aj" (both, 0xA000) per the same 6-way map */
        } else {
            static const char *const w[3] = { "NORMAL", "INVERT", "BOTH" };
            static const u8 wl[3] = { 6, 6, 4 };
            TXT(0x22, 0x41, 7, "Rx    :"); TXT(0x22, 0x65, 7, "Tx    :");
            if (v <= 5) { TXT(0xB4, 0x41, wl[rx_inv[v]], w[rx_inv[v]]); TXT(0xB4, 0x65, wl[tx_inv[v]], w[tx_inv[v]]); }
        }
        blit(0x98, 0x41 + 0x10, CURSOR);
        draw_row_divider(3);
        return; }
    case 0x43:                                                     /* DTMF MODE / DELAY / SPEED */
        TXT(0x22, 0x41, 8, "MODE   :");
        if (L(0x22) == 0) TXT(0xD0, 0x41, 6, "MANUAL");
        else if (L(0x22) == 1) { TXT(0xD0, 0x41, 4, "AUTO"); blit(0x116, 0x45, (const void *)0xFFECE6FC); }
        TXT(0x22, 0x65, 8, "DELAY  :");
        memcpy(t, " 50 ms 250 ms 450 ms 750 ms1000 ms", 0x23);
        TXT(0xD0, 0x65, 7, t + 7 * (L(0x23) >= 5 ? 4 : L(0x23)));
        TXT(0x22, 0x89, 8, "SPEED  :");
        memcpy(t, " 50 ms 100 ms", 0x0E);
        TXT(0xD0, 0x89, 7, t + 7 * (L(0x24) >= 2 ? 1 : L(0x24)));
        if (L(0x21) <= 2) cy = L(0x21) * 0x24 + 0x41;              /* NB cy is left uninitialised */
        blit(L(0x20) == 0 ? 6 : 0xB4, cy, CURSOR);                 /*    (stack garbage) for row > 2 */
        draw_row_divider(2); draw_row_divider(3); draw_row_divider(4);
        return;
    case 0x44: {                                                   /* 5 x 16-char names, 10 in all (DTMF MEMORY, Inferred) */
        u8 rec[5 * 0x13];
        for (i = 0; i < 5; i++) { rec[0x13 * i] = 0; rec[0x13 * i + 1] = 0; memcpy(&rec[0x13 * i + 2], &L(0x22 + 16 * i), 16); }
        draw_bank_list(L(0x20), L(0x21), 0, rec);
        draw_scrollbar(0x137, 0x3D, 6, 0xB3, 0x0A, 5, L(0x21) - 1);
        return; }
    case 0x45: {                                                   /* PAGER */
        u8 row = L(0x21);
        TXT(0x22, 0x41, 9, "ANS-BACK:");
        if (L(0x22) == 0) TXT(0xCA, 0x41, 3, "OFF"); else TXT(0xCA, 0x41, 2, "ON");
        TXT(0x22, 0x65, 9, "CODE-RX :");
        fmt_2z(buf, L(0x23) + 1); TXT(0xCA,  0x65, 2, buf + 1);
        fmt_2z(buf, L(0x24) + 1); TXT(0x110, 0x65, 2, buf + 1);
        TXT(0x22, 0x89, 9, "CODE-TX :");
        fmt_2z(buf, L(0x25) + 1); TXT(0xCA,  0x89, 2, buf + 1);
        fmt_2z(buf, L(0x26) + 1); TXT(0x110, 0x89, 2, buf + 1);
        if (row >= 3) row = 2;
        cx = (L(0x20) == 0) ? 6 : (L(0x20) == 1) ? 0xBC : 0x102;
        blit(cx, row * 0x24 + 0x41, CURSOR);
        draw_row_divider(2); draw_row_divider(3); draw_row_divider(4);
        return; }
    case 0x46: {                                                   /* PR FREQUENCY: 300 + 100*v Hz */
        u16 hz = v * 100 + 300;
        memcpy(t, a00hz, 7);                                 /* "..00Hz" */
        fmt_2sp(buf, (u8)(hz / 100)); t[0] = buf[1]; t[1] = buf[2];
        TXT(0x22, 0x41, 6, t);
        break; }
    case 0x47:                                                     /* SQL LEVEL */
        fmt_2sp(buf, v);
        if (ui_lang == 0) { memcpy(t, (const void *)0xFFF48AD8, 6); t[3] = buf[1]; t[4] = buf[2]; TXT(0x22, 0x41, 5, t); }
        else              { memcpy(t, aLevel_2, 8);                t[5] = buf[1]; t[6] = buf[2]; TXT(0x22, 0x41, 7, t); }
        break;
    case 0x48:                                                     /* SQL S-METER */
        if (v == 0) TXT(0x22, 0x41, 3, "OFF");
        else {
            fmt_2sp(buf, v);
            if (ui_lang == 0) { memcpy(t, (const void *)0xFFF48AE6, 6); t[3] = buf[1]; t[4] = buf[2]; TXT(0x22, 0x41, 5, t); }
            else              { memcpy(t, aLevel_3, 8);                t[5] = buf[1]; t[6] = buf[2]; TXT(0x22, 0x41, 7, t); }
            draw_smeter_preview();
        }
        break;
    case 0x49: case 0x4D:                                          /* SQL EXPANSION, WX ALERT */
        if (v == 0) TXT(0x22, 0x41, 3, "OFF"); else TXT(0x22, 0x41, 2, "ON");
        break;
    case 0x4A: {                                                   /* SQL TYPE (doc 38) */
        char lng[0xC0], shr[0xC0];
        memcpy(lng, (const void *)0xFFF48AF4, 0xC0);
        memcpy(shr, (const void *)0xFFF48BB4, 0xC0);
        if (v >= 12) v = 11;
        TXT(0x22,  0x41, 16, lng + 16 * v);
        TXT(0x108, 0x41, 16, shr + 16 * v);
        break; }
    case 0x4B: {                                                   /* TONE SQL FREQ: 50 CTCSS tones */
        u8 idx = v & 0x7F, show = 0;
        TXT(0x22, 0x41, 6, "TONE :");
        memcpy(t, a670, 0x190);                               /* 50 x 8: " 67.0" ... */
        if (idx >= 0x32) idx = 0x31;
        t[8 * idx + 5] = ' '; t[8 * idx + 6] = 'H'; t[8 * idx + 7] = 'z';
        if ((v >> 7) == 1) { if (blink_phase() != 0) show = 1; } else show = 1;
        if (show == 1) TXT(0xC2, 0x41, 8, t + 8 * idx);
        blit(0xB4, 0x41, CURSOR);
        draw_row_divider(2);
        item_draw_softkeys();
        return; }
    case 0x4C:                                                     /* TONE SEARCH: MUTE + SPEED */
        TXT(0x22, 0x41, 8, "MUTE   :");
        if (L(0x22) == 1) TXT(0xD0, 0x41, 4, "ON"); else if (L(0x22) == 0) TXT(0xD0, 0x41, 3, "OFF");
        draw_row_divider(2);
        TXT(0x22, 0x65, 8, "SPEED  :");
        if (ui_lang == 0) draw_label(0xD0, 0x65, 0xA000, L(0x23) == 0 ? "9bB." : "DcB."); /* JIS fast/slow */
        else TXT(0xD0, 0x65, 4, L(0x23) == 0 ? "FAST" : "SLOW");
        blit(L(0x20) == 0 ? 6 : 0xB4, L(0x21) == 0 ? 0x41 : 0x65, CURSOR);
        draw_row_divider(3);
        return;
    default: return;
    }
    blit(6, 0x41, CURSOR);
    draw_row_divider(2);
}
