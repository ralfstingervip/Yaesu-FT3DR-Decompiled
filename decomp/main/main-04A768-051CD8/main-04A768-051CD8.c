/* ============================================================================
 * main-04A768-051CD8.c  -  Hand-reconstructed C, MAIN H8SX 0x04A768-0x051CD8.
 * Wave C lane main-04A768-051CD8.
 *
 * DOCUMENTATION ONLY.  Transcribed by hand from the rebuilt IDA listing
 * (decomp/tools/build_listings.py); big-endian, base 0, address == file
 * offset.  Nothing here compiles against the image or touches a radio.
 *
 * SUBSYSTEM.  This whole range is the APRS *application layer* on MAIN:
 *   - station / message pop-up arming after a received packet (04A768..)
 *   - the per-packet-type "station detail" pages: position (Mic-E,
 *     uncompressed, compressed), Mic-E status / device type, speed,
 *     course, altitude, PHG, range, DF, weather fields, comment / status /
 *     raw-data text (04AAE8..04F3E4).  Each page is a list of row-render
 *     callbacks walked by sub_52DB0/sub_5314A (outside range); every row
 *     callback formats one 22-char line into disp_line[] (FFB05A).
 *   - SUB display-frame builders for the station and message lists
 *     (04F564..04FD8E, 04FF10..)
 *   - the APRS DTI classifier and generic-destination filter (05015A..)
 *   - station / message list cursor handling (050402..0507AC)
 *   - message compose / edit buffer handling (0507AC..050E08)
 *   - transmit frame builders: message, ack, Mic-E destination,
 *     own-call field (050E1E..0513D6)
 *   - SUB key handlers for the list screens (051408..0514B2)
 *   - the AX.25 address/digipeater-path decoder and the third-party ('}')
 *     header parser (0518AE..051CD8).
 *
 * REGISTER MODEL.  This code is hand-written-assembly style, NOT the C
 * compiler ABI: a parse cursor lives in er2 and is advanced across helper
 * calls; a display write cursor lives in er6; small results come back in
 * r3l / r4l *and* in the CCR (callers use beq/bmi/bne directly after the
 * call).  In the C below:
 *     P   == er2   (u8 *, packet parse cursor, shared by helpers)
 *     D   == er6   (u8 *, display/frame write cursor)
 * Return values model r4l (or r3l where the header says so); "<0" means the
 * routine returned 0xFF with N set, which callers test with bmi.
 *
 * DISPLAY MODEL (Inferred from use; outside-range helpers named here):
 *   disp_line[]  FFB05A  22-byte text line being built (len FFBBE8=0x16)
 *   disp_col     FFBBE9  column where a row's label starts
 *   line_attr    FFB050  word: row style/index handed to SUB with the line
 *   sub_frame[]  FF3D94  MAIN->SUB display frame (doc 108: +0x20 phase)
 *   frame_wp     FFBC2C  write pointer into sub_frame
 *   label tables: { u16 stride; char row[n][stride]; } - a row copy stops
 *   at 0xFF or after `stride` bytes (macro PUT_LBL below).
 * Outside-range number formatters (0x05270A..0x0528DA), all write ASCII
 * digits with leading-zero suppression flag FFAA33 b6 (a suppressed digit
 * is skipped, not blanked):
 *   fmt_u32_8   05270A  8 digits from 10^7, dst er1
 *   fmt_u17_5   052780  5 digits from 10^4, dst er1
 *   fmt_u16_4   052788  4 digits from 10^3, dst er1
 *   fmt_2z      052816  2 digits, zero padded, dst er6
 *   fmt_2       05281E  2 digits, leading zero suppressed
 *   fmt_3z      052826  3 digits zero padded
 *   fmt_3       05282E  3 digits suppressed
 *   blank_lz2   052888  disp_line[col..col+1]: "00"->"  ", "0x"->" x"
 *   blank_lz2b  0528AE  as above, also " 0"->"  "
 *   udivmod32   03F778  er6 = er6/er4, er5 = er5%er4
 *   umul32      03F900  er3 = er3*er4
 *   page_open   052DB0  render title + rows of a page descriptor (er4);
 *                       returns r4l!=0 when the page went to the alt path
 *   page_rows   05314A  render 5 rows from row-list er4 + 4*scroll
 *   page_sym    0531C8  symbol/direction cells of the page header
 *   key_discard 03FFA0  AAE0=0, key_event A9ED=0xFF, clr 817E.1 (doc 93)
 *   wrap_inc    03F62E/03F636  {u8 min,u8 max,u8 *p} wrap-increment
 * ========================================================================== */

#include <stdint.h>
typedef uint8_t u8;  typedef uint16_t u16; typedef uint32_t u32;
typedef int8_t  s8;  typedef int16_t  s16; typedef int32_t  s32;

/* ---- pseudo registers (see REGISTER MODEL) ------------------------------ */
static u8 *P;                                   /* er2 parse cursor          */
static u8 *D;                                   /* er6 display/frame cursor  */

/* ---- display ------------------------------------------------------------ */
extern u8  disp_line[0x16];      /* FFB05A  row text being built            */
extern u8  disp_col;             /* FFBBE9  label column of current row     */
extern u8  disp_len;             /* FFBBE8  row length (0x16)               */
extern u16 line_attr;            /* FFB050  row style word sent to SUB      */
extern u8  disp_fmt_ok;          /* FFB411  last value-format result        */
extern u8  sub_frame[];          /* FF3D94  MAIN->SUB display frame         */
extern u8 *frame_wp;             /* FFBC2C  write pointer into sub_frame    */
extern u8  sfr_mode;             /* FF3DA4  frame +0x10: page kind 1/2/0x12 */
extern u8  sfr_sym_flags;        /* FF3DA6  frame: symbol cell flags        */
extern u8  sfr_sym_a, sfr_sym_b; /* FF3DAB/FF3DAC symbol table/code cells   */
extern u8  sfr_dir16;            /* FF3DA9  16-point bearing cell           */
extern u8  sfr_cnt8, sfr_cntA;   /* FF3DA8/FF3DAA counters (list index)     */
extern u8  fmt_flags_AA33;       /* FFAA33  b6 = digit already emitted      */
extern u8  sign_flags_AA34;      /* FFAA34  b7 = value negative (altitude)  */

/* ---- APRS station record / decoded frames ------------------------------- */
/* Station & message slots are 0x20-byte records (doc 90: +0x1A flags,
   +0x1B retry).  rx_hdr is the newest packet's record, cur_stn the copy
   being displayed.  Decoded frames: 10-byte address records (6 chars,
   4-byte SSID suffix from 0x444C, raw SSID byte at +9, b7 = H bit):
   +0 dest, +0xA source, +0x14.. digis, +0x28 ctl/PID word, +0x2A info.  */
extern u8  rx_hdr[0x20];         /* FF9DE8  newest station record           */
extern u8  rx_hdr_call[9];       /* FF9DF0  (rx_hdr+8) source callsign      */
extern u8  rx_dti;               /* FF9DFE  (rx_hdr+0x16) DTI char          */
extern u8  rx_type;              /* FF9DFF  (rx_hdr+0x17) packet type 0..29 */
extern u8  rx_hdr_18;            /* FF9E00  (rx_hdr+0x18)                   */
extern u8  rx_hdr_19, rx_hdr_1A, rx_hdr_1B;   /* FF9E01..FF9E03             */
extern u16 rx_len;               /* FF9E04  (rx_hdr+0x1C) frame length      */
extern u8  cur_stn[0x20];        /* FF9E08  displayed record (copy)         */
extern u8  cur_dti;              /* FF9E1E  (+0x16) DTI char                */
extern u8  cur_type;             /* FF9E1F  (+0x17) packet type, FF = none  */
extern u8  cur_cmp;              /* FF9E20  (+0x18) 1 = compressed position */
extern u8  cur_msgno;            /* FF9E21  (+0x19) message number 0..99    */
extern u8  cur_flags;            /* FF9E22  (+0x1A) slot flags              */
extern u8  cur_retry;            /* FF9E23  (+0x1B) retry count             */
extern u16 cur_len;              /* FF9E24  (+0x1C) frame length            */
extern u8  msg_tmp[0x20];        /* FF9E28  scratch slot copy (flags +0x1A) */
extern u8  cur_frame[];          /* FF9E48  decoded frame being displayed   */
extern u8  cur_src[10];          /* FF9E52  cur_frame+0xA source address    */
extern u8  cur_digi1[10], cur_digi2[10];      /* FF9E5C / FF9E66            */
extern u8  cur_info[];           /* FF9E72  cur_frame+0x2A info field       */
extern u8  rx_frame[];           /* FF9EF8  decoded newest frame            */
extern u8  rx_digi1[10], rx_digi2[10];        /* FF9F0C / FF9F16            */
extern u8  rx_info[];            /* FF9F22  rx_frame+0x2A                   */
extern u8  own_frame[];          /* FF1A18  own-position frame (Inferred)   */
extern u8  dec_addr[];           /* FFA432  address decode scratch          */
extern u8  hdlc_buf[];           /* FFA1B6  raw received frame (doc 90)     */
extern u8 *rx_fcs_ptr;           /* FFA4EA  ptr to FCS / frame end (doc 90) */
extern u8  rx_hops;              /* FFA55B  digipeater count                */
extern u8  thirdparty_kind;      /* FFA55A  0 / 1 / 2 ('*>' form)          */
extern u8  thirdparty_flag;      /* FFA509  copy of FFA50A on '}' frames    */
extern u8 *disp_info;            /* FFA4B6  -> info field of shown frame    */
extern u8 *disp_end;             /* FFA4BA  -> end of shown frame           */
extern u8 *cmp_base, *cmp_end;   /* FFA4BE / FFA4C2  dup-check cursors      */
extern u8 *frame_start;          /* FFA526  frame being classified          */
extern u32 dest_w0;  extern u16 dest_w1;      /* FFA52A / FFA52E dest chars */
extern u8  dti_compressed;       /* FFA4F9  1 = compressed form found       */

/* ---- APRS lists / UI state ---------------------------------------------- */
extern u8  ui_mode;              /* FFA9F9  main screen mode (0,5,9,10..)   */
extern u8  ui_inh_B420, ui_inh_B39F, ui_inh_AE90, ui_inh_AD69, ui_inh_AA38;
extern u8  aprs_ui;              /* FFA9FA  b0 detail open, b1 compose,
                                            b3 alt layout                   */
extern u8  aprs_ui2;             /* FFAA3A  b0/b1 list view toggles         */
extern u8  aprs_ui3;             /* FFAA3C  b4 = page redraw request        */
extern u8  aprs_ui4;             /* FFAA30  b6/b7 redraw requests           */
extern u8  ipc_req;              /* FF817E  b1 = display update request     */
extern u8  key_event;            /* FFA9ED  key code sink (doc 93)          */
extern u8  tone_ev;              /* FFAAE0  tone mailbox (doc 93)           */
extern u8  popup_kind;           /* FFA9FD  0 station / 1 station+id        */
extern u8  stn_popup_type;       /* FFA9FC                                  */
extern u8  msg_popup_type;       /* FFA9FE                                  */
extern u16 popup_tmr_stn;        /* FF95CE  100 ms tier (doc 76)            */
extern u16 popup_tmr_msg;        /* FF95D0  100 ms tier                     */
extern u8  popup_call[9];        /* FFA4DE  callsign shown in pop-up        */
extern u8  popup_sym;            /* FFA4E7  type letter / 'M' for message   */
extern u8  page_scroll;          /* FFA4F5  top row of detail page          */
extern u8  page_max;             /* FFA4F7  last scroll position            */
extern u8  page_var;             /* FFA4F8  page variant / FF = list page   */
extern u8  page_tbl;             /* FFA98A  bearing-callback selector       */
extern u8  page_step;            /* FFA98B  scroll step                     */
extern u8  hdr_sym_t, hdr_sym_c; /* FFA4F2 / FFA4F3 symbol table / code     */
extern u8  stn_cursor;           /* FF8EAB  station list cursor             */
extern u8  msg_cursor;           /* FF8EAC  message list cursor             */
extern u8  stn_order[0x3C];      /* FFA6EC  station list order (slot nos.)  */
extern u8  msg_order[0x3C];      /* FFA764  message list order              */
extern u8  stn_slots[][0x20];    /* FEE000  station list slots              */
extern u8  msg_slots[][0x20];    /* FEE780  message list slots (doc 90)     */
extern u8  cur_stn_slot;         /* FFA50C                                  */
extern u8  cur_msg_slot;         /* FFA50D                                  */
extern u8  list_hit;             /* FFA506  b0 stn / b1 msg entry exists    */
extern u8  rx_seq;               /* FFA505  receive sequence (doc 90)       */
extern u32 clk_date;  extern u16 clk_time;    /* FFA9C4 / FFA9C8 (doc 90)   */
extern u8  status_sel_A7A4;      /* FFA7A4  status-icon index or <0         */

/* ---- position decode state ---------------------------------------------- */
extern u8  lat_flags;            /* FFA7C8  b7 invalid, b6 exact (no
                                    ambiguity print), b4 south               */
extern u8  lat_deg, lat_min, lat_hh_t, lat_hh_u;  /* FFA7C9..FFA7CC          */
extern u8  lon_flags;            /* FFA7CD  b7 invalid, b6 exact, b4 west,
                                    b0 = +100 degrees                        */
extern u8  lon_deg, lon_min, lon_hh_t, lon_hh_u;  /* FFA7CE..FFA7D1          */
extern u8  mice_ns, mice_lonoff; /* FFA51E / FFA51F  Mic-E dest chars 4,5/6 */
extern u8  ambig_bits;           /* FFA4FC  position-ambiguity digit mask   */
extern u8  rng_valid_A7BE[2];    /* FFA7BE  word, FFFF = no own fix         */
extern u32 dist_digits;          /* FFA7A0  4 unpacked digits, <0 invalid   */
extern u8  dist_flags;           /* FFA7A5  b4 >=1000, b3 >=100             */
extern u32 brg_digits;           /* FFA7D2  as above, bearing variant       */
extern u8  brg_flags;            /* FFA7D7                                  */
extern u8  pos_src_A7D8, pos_src_A7DD;
extern u8  cs_kind;              /* FFA4FA  compressed cs byte kind
                                    0 alt, 1 course/speed, 2 range           */
extern u8  ext_off;              /* FFA4FD  offset into data extension      */
extern u8  ext_adj;              /* FFA504  offset correction               */
extern u32 b91_q1, b91_q2;       /* FFA8AA / FFA8AE base-91 partials        */
extern u16 b91_frac;             /* FFA8B2                                  */
extern u32 b91_val;              /* FFA8B4  degrees*10^4                    */
extern u16 b91_rem;              /* FFA8B8                                  */
extern u32 b91_div1, b91_div2;   /* FFA8BA / FFA8BE                         */
extern u16 b91_div3;             /* FFA8C2                                  */
extern u8 *pos_src_ptr;          /* FFA986  alt-source frame pointer        */
extern u8  item_dti_A523;        /* FFA523  DTI of the own-position frame   */

/* ---- weather -------------------------------------------------------------- */
extern u8  wx_found;             /* FFA4FF  bit n = slot n stored; b7 = '-'  */
extern u8  wx_neg;               /* FFA500  b7 = temperature negative       */
extern u8  wx_lum;               /* FFA501  1 = L/l/s field seen            */
extern u8  wx_res;               /* FFA502  field check result 0..4         */
extern u8  wx_res2;              /* FFA503  second checker result           */
extern u8 *wx_dir, *wx_spd;      /* FFA530 / FFA534  "c..." / "s..." fields */
extern u8 *wx_slot[7];           /* FFA538  g t r p P h b                   */

/* ---- units (doc 45: UNIT menu bits of FF8AAC, speed in FF8AAD) ---------- */
extern u8  unit_bits;            /* FF8AAC  b0 pos fmt, b1 distance,
                                    b3 altitude, b4 temp, b5 rain, b6 wind   */
extern u8  unit_speed;           /* FF8AAD  0 km/h, 1 knot, 2 mph           */
extern u8  u_speed;              /* FFA917  copy of FF8AAD                  */
extern u8  u_alt_ft;             /* FFA918  FF8AAC b3                       */
extern u8  u_pos_dms;            /* FFA919  FF8AAC b0                       */
extern u8  u_dist_mi;            /* FFA91A  FF8AAC b1                       */
extern u8  aprs_flt_AAF;         /* FF8AAF  b0 = accept any destination     */

/* ---- message compose ---------------------------------------------------- */
extern u8  ed_pos;               /* FFAD68  editor cursor / row             */
extern u8  ed_pos_ar;            /* FFAD99  auto-reply text cursor          */
extern u8  ed_state;             /* FFA507  pending edit operation          */
extern u8  ed_aux;               /* FFA508                                  */
extern u8  ed_B090;              /* FFB090                                  */
extern u8  msg_to_flag;          /* FFA56C                                  */
extern u8  msg_to[7];            /* FFA56D  addressee: 6 chars + SSID       */
extern u8  msg_text[0x43];       /* FFA574  message text, FF-terminated     */
extern u8  ar_text[0x43];        /* FFADDE  auto-reply text (doc 90)        */
extern u8  grp_text[0x3C];       /* FFADA2  group/bulletin text buffer      */
extern u8  tx_buf[];             /* FFA332  APRS transmit buffer (doc 90)   */
extern u16 tx_len;               /* FFA330                                  */
extern u8  own_call[6];          /* FF8AA2  own APRS callsign, FF padded    */
extern u8  own_ssid;             /* FF8AA8  SSID index                      */
extern u8  own_call_fmt[10];     /* FFA8D0  formatted "CALL-SS  " (doc 90)  */

/* ---- ROM tables referenced below (addresses only; not quoted) ----------- */
extern const u16 popup_time_tbl[];   /* 0x003F8A  per-type pop-up time       */
extern const u8  type_letter[];      /* 0x003EA2  "EEPpWw..." per packet type */
extern const u8  type_name_uc[];     /* 0x003CBE  {u16 8; "Mic-E  ","FIXED  ",..} */
extern const u8  type_name_lc[];     /* 0x003DB0  second type-name table      */
extern const u8  ssid_suffix[];      /* 0x00444C  4-byte "-SS " per SSID      */
extern const u8  two_digit[];        /* 0x004004  "00".."99" as u16 pairs     */
extern const u8  dev_suffix_len[];   /* 0x003F1E  Mic-E device trailer length */
extern void (*const detail_page_by_type[29])(void); /* 0x04AB70 by cur_type */
extern void (*const dup_extent_by_type[29])(void);  /* 0x04ABE4 by rx_type  */
/* 0x04AC58.. 0x04B154: page descriptors = arrays of row-callback pointers
   (first = title row).  See NOTES.md: doc 70's "slot 68 of 0x04ABE4" is row
   10 of the descriptor at 0x04ACCC, not a 256-way table slot.            */

/* label-table copy: { u16 stride; char rows[][stride] }  (see header) */
#define LBL_ROW(t, i)   ((const u8 *)(t) + 2 + (u16)(i) * *(const u16 *)(t))
static u8 *PUT_LBL(const void *t, u8 idx)       /* copy at disp_col, stop FF */
{   u8 n = (u8)*(const u16 *)t; const u8 *s = LBL_ROW(t, idx);
    u8 *d = &disp_line[disp_col];
    while (n-- && *s != 0xFF) *d++ = *s++;
    return d; }
static void PUT_LBL_FULL(const void *t, u8 idx) /* eepmov whole row to [0] */
{   memcpy(disp_line, LBL_ROW(t, idx), *(const u16 *)t); }

/* ========================================================================== *
 * 04A768-04A88A  size 290   aprs_popup_arm            (sub_4A768)  Confirmed
 * Callers: sub_4986A (APRS receive handler).  r3l = pop-up type.
 * Gate: only on main screens 0, 9 (needs B39F b2 && !b3) or 10 (needs B420
 * b0), and only when AE90.0, AD69.7, AA38.7 are all clear.  Types < 10 are
 * station pop-ups: the newest station record and decoded frame are copied
 * to the "displayed" copies and the 100-ms timer FF95CE is loaded from the
 * per-type table at 0x3F8A.  Types >= 10 are message pop-ups: the sender's
 * callsign and the type letter go to FFA4DE/FFA4E7 and timer FF95D0 runs.
 * ========================================================================== */
static int popup_gate(void)                         /* shared 04A768..04A7A6 */
{
    switch (ui_mode) {
    case 0:  break;
    case 9:  if ((ui_inh_B39F & 0x08) || !(ui_inh_B39F & 0x04)) return 0; break;
    case 10: if (!(ui_inh_B420 & 0x01)) return 0; break;
    default: return 0;
    }
    if (ui_inh_AE90 & 0x01) return 0;
    if (ui_inh_AD69 & 0x80) return 0;
    if (ui_inh_AA38 & 0x80) return 0;
    return 1;
}
void aprs_popup_arm(u8 type /* r3l */)              /* 04A768 */
{
    if (!popup_gate()) return;
    if (type < 10) {                                 /* 04A7A8 */
        page_scroll = 0; popup_kind = 0; stn_popup_type = type;
        memcpy(cur_stn, rx_hdr, 0x20);               /* 04A7BC eepmov 0x20  */
        memcpy(cur_frame, rx_frame, cur_len);        /* 04A7D4 len = new copy*/
        disp_end  = cur_frame + cur_len;             /* 04A7EC              */
        disp_info = cur_info;                        /* 04A800 = FF9E72     */
        ipc_req  |= 0x02;                            /* 04A80C              */
        popup_tmr_stn = popup_time_tbl[stn_popup_type];
        popup_tmr_msg = 0; msg_popup_type = 0;
    } else {                                         /* 04A834              */
        msg_popup_type = type;
        memcpy(popup_call, rx_hdr_call, 9);
        popup_sym = type_letter[rx_type];
        ipc_req  |= 0x02;
        popup_tmr_msg = popup_time_tbl[msg_popup_type];
        popup_tmr_stn = 0; stn_popup_type = 0;
    }
}

/* ========================================================================== *
 * 04A88C-04A8DA  size 78   aprs_popup_arm_msg_A8E8     (sub_4A88C)  Confirmed
 * 04A8DA-04A91C  size 66   (tail, IDA split)           (sub_4A8DA)  Confirmed
 * Callers: sub_4986A.  Same gate; message pop-up whose callsign comes from
 * FFA8E8 (a 9-byte callsign cell, Inferred: the addressee seen in the frame)
 * instead of the sender.  Ends by forcing FFA9FE = 1.  0x04A8DA is entered
 * only by fall-through with er5/r4 already loaded (copy length 9).
 * ========================================================================== */
extern u8 call_A8E8[9];                              /* FFA8E8 */
void aprs_popup_arm_msg_A8E8(u8 type)                /* 04A88C */
{
    if (!popup_gate()) return;
    msg_popup_type = type;
    memcpy(popup_call, call_A8E8, 9);                /* 04A8D0..04A8E6       */
    popup_sym = type_letter[rx_type];                /* 04A8E8               */
    ipc_req |= 0x02;
    popup_tmr_msg = popup_time_tbl[msg_popup_type];  /* 04A900               */
    msg_popup_type = 1;                              /* 04A914               */
}

/* ========================================================================== *
 * 04A91E-04AA44  size 294  aprs_popup_arm_msglist      (sub_4A91E)  Confirmed
 * Callers: sub_4986A.  As aprs_popup_arm, but popup_kind = 1 and the
 * message-list slot shown is msg_order[0] (FFA764[0] -> FFA50D); message
 * pop-ups use the fixed type letter 'M'.
 * ========================================================================== */
void aprs_popup_arm_msglist(u8 type)                 /* 04A91E */
{
    if (!popup_gate()) return;
    if (type < 10) {
        page_scroll = 0; popup_kind = 1; stn_popup_type = type;
        memcpy(cur_stn, rx_hdr, 0x20);
        memcpy(cur_frame, rx_frame, cur_len);
        disp_end = cur_frame + cur_len; disp_info = cur_info;
        cur_msg_slot = msg_order[0];                 /* 04A9C4 @(-0x589C,0)  */
        ipc_req |= 0x02;
        popup_tmr_stn = popup_time_tbl[stn_popup_type];
        popup_tmr_msg = 0; msg_popup_type = 0;
    } else {
        msg_popup_type = type;
        memcpy(popup_call, rx_hdr_call, 9);
        popup_sym = 'M';                             /* 04AA16               */
        ipc_req |= 0x02;
        popup_tmr_msg = popup_time_tbl[msg_popup_type];
        popup_tmr_stn = 0; stn_popup_type = 0;
    }
}

/* 04AAC8-04AAE8 size 32  aprs_popup_clear (sub_4AAC8)  Confirmed.
   Callers: sub_1079E, sub_3E354.  FF9DDF = 0, both pop-up timers/types 0. */
extern u8 flag_9DDF;                                 /* FF9DDF */
void aprs_popup_clear(void)
{ flag_9DDF = 0; popup_tmr_stn = 0; stn_popup_type = 0;
  popup_tmr_msg = 0; msg_popup_type = 0; }

/* ========================================================================== *
 * 04AAE8-04AB70  size 136  aprs_detail_open            (sub_4AAE8)  Confirmed
 * No direct caller in the listings (reached by table / key map).  Latches
 * the UNIT settings (doc 45: FF8AAC bits, FF8AAD) into the working copies,
 * then either redraws the list (sub_52B7C) or opens the per-type detail
 * page through table 0x04AB70 indexed by cur_type.
 * ========================================================================== */
extern u8 ui_BC0B;                                   /* FFBC0B */
extern void list_redraw_52B7C(void);                 /* sub_52B7C */
void aprs_detail_open(void)                          /* 04AAE8 */
{
    ui_BC0B &= ~0x10;
    hdr_sym_t = 0xFF; hdr_sym_c = 0xFF; status_sel_A7A4 = 0xFF;
    u_pos_dms = unit_bits & 1;                       /* 04AAFE bld #0       */
    u_alt_ft  = (unit_bits >> 3) & 1;                /* bld #3              */
    u_dist_mi = (unit_bits >> 1) & 1;                /* bld #1              */
    u_speed   = unit_speed;                          /* FF8AAD              */
    if (!(aprs_ui & 0x01)) { aprs_ui3 |= 0x10; list_redraw_52B7C(); return; }
    if (cur_type == 0xFF) return;
    ext_off = 0; page_tbl = 0; page_step = 3;
    detail_page_by_type[cur_type]();                 /* 04AB64 jsr @er6     */
}

/* ========================================================================== *
 * 04B192-04B1B4  size 34   aprs_list_refresh           (sub_4B192)  Confirmed
 * 04B1B4-04B1EC  size 56   aprs_msg_detail_refresh     (sub_4B1B4)  Confirmed
 * Callers of 4B1B4: fall-through from 4B192, sub_52002.  Chooses the SUB
 * frame builder: compose screen (aprs_ui.1), received-message detail
 * (cur_flags.0 clear) or sent-message detail.  0x04B1D0 is a second,
 * table-reached entry that picks the narrow list layouts 514C6/516FE.
 * ========================================================================== */
extern void list_redraw_52E8A(void);
void msg_rx_detail_frame(void); void msg_tx_detail_frame(void);
void compose_redraw(void); void msg_list_frame_514C6(void);
void msg_list_frame_516FE(void);
void aprs_msg_detail_refresh(void);
void aprs_list_refresh(void)                         /* 04B192 */
{
    ui_BC0B &= ~0x10;
    if (aprs_ui & 0x02) { compose_redraw(); return; }        /* 04B1E6 */
    if (aprs_ui & 0x01) { aprs_msg_detail_refresh(); return; }
    aprs_ui3 |= 0x10; list_redraw_52E8A();
}
void aprs_msg_detail_refresh(void)                   /* 04B1B4 */
{
    if (!(cur_flags & 0x01)) { if (cur_type != 0xFF) msg_rx_detail_frame(); }
    else msg_tx_detail_frame();
}
void aprs_msg_list_layout_04B1D0(void)               /* 04B1D0 alt entry */
{
    if (!(cur_flags & 0x01)) msg_list_frame_514C6(); else msg_list_frame_516FE();
}

/* ========================================================================== *
 * 04B1F6-04B20A size 20  row_src_call      (sub_4B1F6)  Confirmed
 * 04B20A-04B238 size 46  put_addr_text     (sub_4B20A)  Confirmed
 * Callers: sub_4B8D4 / sub_4F76C.  Prints the 9-char "CALL-SS" text of a
 * 10-byte address record (er5) plus a space at disp_line[disp_col]; the
 * station row forces column 7 unless it is already 5.
 * ========================================================================== */
void put_addr_text(const u8 *a /* er5 */)            /* 04B20A */
{
    u8 *d = &disp_line[disp_col];
    memcpy(d, a, 8); d[8] = a[8]; d[9] = ' ';
}
void row_src_call(void)                              /* 04B1F6 */
{
    if (disp_col != 5) disp_col = 7;
    put_addr_text(cur_src);                          /* FF9E52 */
}

/* ========================================================================== *
 * 04B238-04B280 size 72   row_type_date_alt    (sub_4B238)  Confirmed
 * 04B280-04B314 size 148  row_type_date        (sub_4B280)  Confirmed
 * Callers of 4B280: fall-through, sub_4C284.  Type name (FF -> 0x1D
 * "???????") from one of two 8-byte name tables, then the record's BCD
 * date "MM/DD" (cur_stn[1]&0x1F, cur_stn[2]&0x3F) at column+9.  The _alt
 * entry uses the second table when cs_kind == 1.
 * ========================================================================== */
static void put_bcd2(u8 **d, u8 v) { *(*d)++ = '0' + (v >> 4); *(*d)++ = '0' + (v & 15); }
static void put_type_name(const u8 *tbl)
{
    u8 t = (cur_type == 0xFF) ? 0x1D : cur_type;
    disp_col = 7; PUT_LBL(tbl, t);
}
static void put_date(void)                           /* 04B2BE */
{
    u8 *d = &disp_line[disp_col + 9];
    put_bcd2(&d, cur_stn[1] & 0x1F); *d++ = '/';
    put_bcd2(&d, cur_stn[2] & 0x3F);
}
void row_type_date(void)  { put_type_name(type_name_uc); put_date(); } /* 04B280 */
void row_type_date_alt(void)                                          /* 04B238 */
{   if (cs_kind != 1) { row_type_date(); return; }
    put_type_name(type_name_lc); put_date(); }

/* ========================================================================== *
 * 04B314-04B378 size 100  row_dist_time        (sub_4B314)  Confirmed
 * Distance row (show_distance) then the record time "HH:MM" from BCD
 * cur_stn[3]&0x3F, cur_stn[4]&0x7F at column+9; leaves disp_col = 8.
 * ========================================================================== */
u8 show_distance(void);
void row_dist_time(void)                             /* 04B314 */
{
    disp_col = 7; show_distance();
    u8 *d = &disp_line[disp_col + 9];
    put_bcd2(&d, cur_stn[3] & 0x3F); *d++ = ':';
    put_bcd2(&d, cur_stn[4] & 0x7F);
    disp_col = 8;
}

/* ========================================================================== *
 * 04B378-04B484 size 268  show_distance        (sub_4B378)  Confirmed
 * 04B4AA-04B5B6 size 268  show_distance_B      (sub_4B4AA)  Confirmed
 * 04B5B6-04B6F4 size 318  show_distance_C      (sub_4B5B6)  Confirmed
 * Callers: 4B314 / sub_469C6 / sub_485F2.  Label "  -.-km"/"  -.-mi"
 * (0x4B484, by u_dist_mi), then, if an own fix exists (FFA7BE != FFFF) and
 * both coordinates decoded, the 4 unpacked digits of the distance long
 * (A7A0 / A7D2) as "ddd.d", " dddd" (flag b3) or "1dddd" (flag b4); a
 * negative long prints "*****".  Returns FFB411 = 1 when a value was shown.
 * Variant B uses the second distance record (A7D2/A7D7, validity A7D8/A7DD);
 * variant C additionally short-circuits to a blank label when FF8EB2 == 1.
 * ========================================================================== */
extern const u8 dist_lbl[];                          /* 0x04B484 */
extern void blank_lz2(u8 col);                       /* sub_52888 */
extern u8 flag_8EB2;                                 /* FF8EB2 */
static u8 show_dist_common(u8 v_ok1, u8 v_ok2, s32 val, u8 flg)
{
    disp_fmt_ok = 0;
    u8 *d = &disp_line[disp_col];
    if (*(u16 *)rng_valid_A7BE == 0xFFFF || (s8)v_ok1 < 0 || (s8)v_ok2 < 0)
        return disp_fmt_ok;
    if (val < 0) { memset(d, '*', 5); return disp_fmt_ok; }      /* 04B46A */
    u8 c0 = '0' + (u8)(val >> 24), c1 = '0' + (u8)(val >> 16),
       c2 = '0' + (u8)(val >> 8),  c3 = '0' + (u8)val;
    if (flg & 0x10) {                                /* >= 1000 */
        d[1] = c0; d[2] = c1; d[3] = c2; d[4] = c3; d[0] = '1';
    } else if (flg & 0x08) {                         /* >= 100  */
        d[1] = (c0 == '0') ? ' ' : c0; d[2] = c1; d[3] = c2; d[4] = c3; d[0] = ' ';
    } else {                                         /* ddd.d, '.' from label */
        d[0] = c0; d[1] = c1; d[2] = c2; d[4] = c3;
        blank_lz2(disp_col);
    }
    disp_fmt_ok = 1;
    return disp_fmt_ok;
}
u8 show_distance(void)                               /* 04B378 */
{   PUT_LBL(dist_lbl, u_dist_mi);
    return show_dist_common(lat_flags, lon_flags, (s32)dist_digits, dist_flags); }
u8 show_distance_B(void)                             /* 04B4AA */
{   PUT_LBL(dist_lbl, u_dist_mi);
    return show_dist_common(pos_src_A7D8, pos_src_A7DD, (s32)brg_digits, brg_flags); }
u8 show_distance_C(void)                             /* 04B5B6 */
{
    if (flag_8EB2 == 1) { PUT_LBL_FULL(dist_lbl, u_dist_mi); disp_fmt_ok = 0; return 0; }
    return show_distance_B();
}

/* 04B6F4-04B724 size 48  get_distance_B (sub_4B6F4) Confirmed.  Caller
   sub_46652.  Returns er3 = A7D2 when valid and not the ">=100" form, else -1. */
s32 get_distance_B(void)
{
    if (*(u16 *)rng_valid_A7BE == 0xFFFF) return -1;
    if ((s8)pos_src_A7D8 < 0 || (s8)pos_src_A7DD < 0) return -1;
    if ((s32)brg_digits < 0) return -1;
    if (brg_flags & 0x08) return -1;
    return (s32)brg_digits;
}

/* ========================================================================== *
 * 04B724-04B88C  ASCII decimal parsers.  All read from P (er2) and advance
 * it.  The "check" pass walks a copy (er5) first; a non-digit aborts.
 *   04B724 size 64  parse_dec5      (sub_4B724) -> er3, 0 if not 5 digits
 *   04B764 size 30  parse_dec4      (sub_4B764) -> r3,  0 if bad   Confirmed
 *   04B782 size 30  parse_dec3      (sub_4B782) -> r3,  0 if bad   Confirmed
 *   04B7A0 size 30  parse_dec2      (sub_4B7A0) -> r3,  0 if bad   Confirmed
 *   04B7BE size 54  dec_core4       (sub_4B7BE) 4-digit core; entries
 *                   0x4B7CC (3 digits) and 0x4B7D8 (2 digits)      Confirmed
 *   04B7F4 size 30  parse_dec4_m1   (sub_4B7F4) -> -1 if bad       Confirmed
 *   04B812 size 122 parse_dec3_m1   (sub_4B812) -> -1 if bad; entry
 *                   0x4B830 = parse_dec2_m1                         Confirmed
 * Callers include the weather rows, the SmartBeaconing code (sub_4490C...)
 * and the GPS parser (sub_06212).
 * ========================================================================== */
static int all_digits(const u8 *s, u8 n)
{ while (n--) { if (*s < '0' || *s > '9') return 0; s++; } return 1; }
static u16 dec_n(u8 n) { u16 v = 0; while (n--) v = v * 10 + (*P++ - '0'); return v; }
u32 parse_dec5(void) { if (!all_digits(P, 5)) return 0;
                       u32 v = (u32)(*P++ - '0') * 10000; return v + dec_n(4); }
u16 parse_dec4(void) { return all_digits(P, 4) ? dec_n(4) : 0; }
u16 parse_dec3(void) { return all_digits(P, 3) ? dec_n(3) : 0; }
u16 parse_dec2(void) { return all_digits(P, 2) ? dec_n(2) : 0; }
s32 parse_dec4_m1(void) { return all_digits(P, 4) ? dec_n(4) : -1; }
s32 parse_dec3_m1(void) { return all_digits(P, 3) ? dec_n(3) : -1; }
s32 parse_dec2_m1(void) { return all_digits(P, 2) ? dec_n(2) : -1; } /* 04B830 */

/* ========================================================================== *
 * 04B88C-04B8D4 size 72   page_mice               (sub_4B88C)  Confirmed
 * Detail page for Mic-E packets (type 0/1, reached through 0x04AB70).
 * Decodes Mic-E latitude (from the destination) and longitude (info+1..3),
 * computes distance/bearing (sub_539C6), opens descriptor 0x04AC58, and
 * takes the header symbol from info[7] (code) / info[8] (table).
 * ========================================================================== */
extern void calc_dist_brg_539C6(void); extern u8 page_open(const void *desc);
extern void page_sym(void);                          /* sub_531C8 */
u8 mice_lat_cur(void); u8 mice_lon_cur(void);
void page_mice(void)                                 /* 04B88C */
{
    page_max = 7; page_var = 0;
    mice_lat_cur(); mice_lon_cur(); calc_dist_brg_539C6();
    page_tbl = 2;
    if (page_open((const void *)0x4AC58)) return;
    hdr_sym_c = disp_info[7]; hdr_sym_t = disp_info[8];
    page_sym();
}

/* ========================================================================== *
 * 04B8D4-04B9EA size 278  row_mice_call_comment   (sub_4B8D4)  Inferred
 * Prints the source callsign, then decides whether a free-text comment
 * follows the Mic-E device trailer.  Dispatch on the device code through
 * the 17-slot jump table 0x04B9EA (index <= 0x10, doc 129).  The handlers
 * accept "nothing left", a bare "\r", "=\r", or one of the Yaesu trailers
 * " _ \r", "_\"\r", "_#\r", "_$\r", "_%\r", "_(\r", "_)\r", "_0\r"; anything
 * else sets line_attr = 0x12 and frame byte FF3DA4 = 1 (comment present).
 * TODO(waveC): map each table slot to its handler (0x4B908 / 0x4B934 /
 * 0x4B95E / 0x4B9C2) - needs the table bytes.
 * ========================================================================== */
s8 mice_type(u8 *code);
void row_mice_call_comment(void)                     /* 04B8D4 */
{
    row_src_call();
    P = disp_info + 9;
    u8 code; s8 alt = mice_type(&code);
    if (alt < 0) return;
    if (alt) P += 4;                                 /* skip "xxx}" altitude */
    u8 *end = disp_end; u32 n;
    switch (code) {                                  /* jmp @(0x4B9EA,code*4)*/
    case_4B908:                                      /* Kenwood-style        */
        if (P >= end) return; n = end - P;
        if (n < 3) { if (n == 1) return;
                     if (P[0] == '=' && P[1] == '\r') return; }
        break;
    case_4B934:                                      /* 3-char Yaesu trailer */
    case_4B95E: {                                    /* 4-char Yaesu trailer */
        if (P >= end) return; n = end - P;
        if (n >= 4) break; if (n < 3) return;
        u32 w = ((u32)' ' << 24) | ((u32)P[0] << 16) | (P[1] << 8) | P[2];
        if (w == 0x205F200D || w == 0x205F220D || w == 0x205F230D ||
            w == 0x205F240D || w == 0x205F250D || w == 0x205F280D ||
            w == 0x205F290D || w == 0x205F300D) return;
        break; }
    case_4B9C2:                                      /* plain               */
        if (P >= end) return; n = end - P;
        if (n < 2 && *P == '\r') return;
        break;
    }
    line_attr = 0x12; sfr_mode = 1;                  /* 04B9D6               */
}

/* ========================================================================== *
 * Mic-E latitude (from the 6-char destination address).
 * 04BA32 size 118  row_lat_mice         (sub_4BA32)  Confirmed
 * 04BAA8 size 38   row_lat_mice_own     (sub_4BAA8)  Confirmed  (sub_488B6)
 * 04BAF4 size 82   row_lat_mice_A7F4    (sub_4BAF4)  Confirmed  (sub_486D2)
 * 04BB46 size 14   mice_lat_own         (sub_4BB46)  Confirmed  P=FF1A18
 * 04BB54 size 14   mice_lat_rx          (sub_4BB54)  Confirmed  P=rx_frame
 * 04BB62 size 8    mice_lat_at          (sub_4BB62)  Confirmed  P=caller
 * 04BB6A size 692  mice_lat_A7F4        (sub_4BB6A)  Confirmed  + entries
 *                  0x4BB78 (P=FFA882) and 0x4BB86 mice_lat_cur (P=cur_frame)
 *                  and the shared core 0x4BB92.
 * Digit rules (APRS Mic-E): '0'-'9' -> d; 'A'-'J' -> d (custom msg bit);
 * 'P'-'Y' -> d (std msg bit); 'K','L','Z' -> ambiguity (shown ' ', value 0,
 * FFA4FC bit 5..0 for digit 1..6).  dest[3] decides N/S (P..Z north).
 * Writes deg FFA7C9, min FFA7CA, thousandths-of-minute FFA7CB:CC (u16 BE,
 * = hundredths*10), b4 = south; clears lat_flags.7.  Returns 1 / 0.
 * ========================================================================== */
extern const u8 pos_lbl[];      /* 0x04BE62  { "     ...  .  ' " rows }      */
extern const u8 lat_dash_lbl[]; /* 0x04BE80  "   --","--.--'" placeholders   */
extern const u8 lon_dash_lbl[]; /* 0x04BE9E                                */
extern void blank_lz2b(u8 col);                      /* sub_528AE */
extern void fmt_2z(u16 v), fmt_2(u16 v), fmt_3(u16 v), fmt_3z(u16 v); /* via D */
void dms_secs(u16 hh, u8 amb);
static int mice_digit(u8 c, u8 bit, u8 *v)
{
    if (c >= '0' && c <= '9') { *v = c - '0'; *D++ = c; return 1; }
    if (c >= 'A' && c <= 'J') { *v = c - 'A'; *D++ = '0' + *v; return 1; }
    if (c == 'K' || c == 'L' || c == 'Z') { ambig_bits |= bit; *v = 0; *D++ = ' '; return 1; }
    if (c >= 'P' && c <= 'Y') { *v = c - 'P'; *D++ = '0' + *v; return 1; }
    return 0;
}
static u8 mice_lat_core(void)                        /* 04BB92 */
{
    u8 a, b, c, d, e, f;
    mice_ns = P[3]; ambig_bits = 0;
    D = &disp_line[disp_col + 3];
    if (!mice_digit(*P++, 0x20, &a)) return 0;
    if (!mice_digit(*P++, 0x10, &b)) return 0;
    lat_deg = a * 10 + b; D++;                       /* 04BC4E               */
    if (!mice_digit(*P++, 0x08, &c)) return 0;
    if (!mice_digit(*P++, 0x04, &d)) return 0;
    lat_min = c * 10 + d; D++;                       /* 04BCF0               */
    if (!mice_digit(*P++, 0x02, &e)) return 0;
    if (!mice_digit(*P++, 0x01, &f)) return 0;
    u16 hh = e * 10 + f;
    *(u16 *)&lat_hh_t = hh * 10;                     /* 04BD9C mulxu, A7CB:CC*/
    if (!(lat_flags & 0x40) && u_pos_dms) { D -= 2; dms_secs(hh, ambig_bits); }
    D++;
    u8 ns = mice_ns, r;
    if ((ns >= '0' && ns <= '9') || ns == 'L') r = 'S';
    else if (ns >= 'P' && ns <= 'Z') r = 'N';
    else return 0;
    disp_line[disp_col] = r;
    lat_flags &= ~0x80;
    if (r == 'S') lat_flags |= 0x10;
    return 1;
}
u8 mice_lat_own(void)  { lat_flags = 0x80; P = own_frame;  return mice_lat_core(); }
u8 mice_lat_rx(void)   { lat_flags = 0xC0; P = rx_frame;   return mice_lat_core(); }
u8 mice_lat_at(void)   { lat_flags = 0xC0;                 return mice_lat_core(); }
u8 mice_lat_A7F4(void) { lat_flags = 0x80; P = (u8 *)0xFFA7F4; return mice_lat_core(); }
u8 mice_lat_A882(void) { lat_flags = 0x80; P = (u8 *)0xFFA882; return mice_lat_core(); }
u8 mice_lat_cur(void)  { lat_flags = 0x80; P = cur_frame;  return mice_lat_core(); }

void row_lat_mice(void)                              /* 04BA32 */
{
    PUT_LBL(pos_lbl, u_pos_dms);
    if (!mice_lat_cur()) PUT_LBL(lat_dash_lbl, u_pos_dms);
    blank_lz2b(10);
}
static void row_lat_full(u8 (*dec)(void))           /* 04BAA8 / 04BAF4 */
{
    PUT_LBL_FULL(pos_lbl, u_pos_dms);
    if (!dec()) PUT_LBL_FULL(lat_dash_lbl, u_pos_dms);
    blank_lz2b(2);
}
void row_lat_mice_own(void)  { row_lat_full(mice_lat_own); }
void row_lat_mice_A7F4(void) { row_lat_full(mice_lat_A7F4); }

/* ========================================================================== *
 * 04BEDC-04BEF2 size 22  dms_secs_auto   (sub_4BEDC)  Confirmed
 * 04BEF2-04BF46 size 84  dms_secs        (sub_4BEF2)  Confirmed
 * Seconds field.  In MM.mm mode (u_pos_dms == 0) prints hh as 2 digits.
 * In MM'SS mode converts hundredths to seconds (round half up) and honours
 * ambiguity: amb.1 -> "  ", amb.0 -> tens digit (rounded) + ' '.
 * dms_secs_auto derives amb from blanks already echoed at D[0]/D[1].
 * ========================================================================== */
void dms_secs(u16 v /* r3 */, u8 amb /* r5l */)     /* 04BEF2 */
{
    if (!u_pos_dms) { fmt_2z(v); return; }
    if (v) { u32 t = (u32)v * 60; v = t / 100; if (t % 100 >= 50) v++; }
    if (amb & 0x02) { *D++ = ' '; *D++ = ' '; return; }
    if (amb & 0x01) {
        u8 tens = v / 10, un = v % 10;
        if (v && un >= 5 && tens < 5) tens++;
        *D++ = '0' + tens; *D++ = ' '; return;
    }
    fmt_2z(v);
}
void dms_secs_auto(u16 v)                            /* 04BEDC */
{
    u8 amb = 0;
    if (D[0] == ' ') amb |= 2; else if (D[1] == ' ') amb |= 1;
    dms_secs(v, amb);
}

/* ========================================================================== *
 * Mic-E longitude (info+1..3, offset/E-W from dest[4]/dest[5]).
 * 04BF46 size 174 row_lon_mice        (sub_4BF46)  Confirmed
 * 04BFF4 size 16  blank_masked        (sub_4BFF4)  Confirmed
 * 04C004 size 38  row_lon_mice_own    (sub_4C004)  Confirmed (sub_488B6)
 * 04C050 size 144 row_lon_mice_A7F4   (sub_4C050)  Confirmed (sub_486D2)
 * 04C0E0 size 36  mice_lon_own        (sub_4C0E0)  Confirmed
 * 04C104 size 76  mice_lon_rx         (sub_4C104)  Confirmed (455E6,4723C)
 * 04C150 size 34  mice_lon_packed     (sub_4C150)  Inferred  (sub_47326):
 *                 er2 -> {dest[6], lon[3]}: dest[5]=E/W, dest[4]=offset.
 * 04C172 size 274 mice_lon_A7F4       (sub_4C172)  Confirmed, + entries
 *                 0x4C198 (FFA888 record) and 0x4C1BE mice_lon_cur, and
 *                 the core 0x4C1DC.
 * 04C3D2 size 84  mice_lon_deg        (sub_4C3D2)  Confirmed
 * 04C426 size 24  mice_lon_min        (sub_4C426)  Confirmed
 * 04C43E size 34  mice_lon_hh         (sub_4C43E)  Confirmed
 * ========================================================================== */
u8 mice_lon_deg(u16 *deg)                            /* 04C3D2 */
{
    u8 c = mice_lonoff, off;
    if ((c >= '0' && c <= '9') || c == 'L') off = 0;
    else if (c >= 'P' && c <= 'Z') off = 100;
    else return 0;
    u8 v = *P++ - 0x1C + off;
    if (v >= 0xB4 && v < 0xBE) v -= 0x50;            /* 180..189 -> 100..109 */
    else if (v >= 0xBE && v < 0xC8) v -= 0xBE;       /* 190..199 -> 0..9     */
    *deg = v; fmt_3(v);                              /* sub_5282E            */
    return 1;
}
u8 mice_lon_min(void)                                /* 04C426 */
{   u8 v = *P++ - 0x1C; if (v >= 60) v -= 60; fmt_2z(v); return v; }
u8 mice_lon_hh(void)                                 /* 04C43E */
{   u8 v = *P++ - 0x1C;
    if (!(lon_flags & 0x40)) dms_secs(v, ambig_bits); else fmt_2z(v);
    return v; }
static u8 mice_lon_core(void)                        /* 04C1DC */
{
    u16 deg;
    D = &disp_line[disp_col + 2];
    if (!mice_lon_deg(&deg)) return 0;
    if (deg >= 100) { lon_flags |= 0x01; deg -= 100; }
    lon_deg = (u8)deg; D++;
    lon_min = mice_lon_min(); D++;
    *(u16 *)&lon_hh_t = (u16)mice_lon_hh() * 10;     /* FFA7D0:D1            */
    D++;
    u8 c = mice_ns, ew;                              /* here = dest[5]       */
    if ((c >= '0' && c <= '9') || c == 'L') ew = 'E';
    else if (c >= 'P' && c <= 'Z') ew = 'W';
    else return 0;
    disp_line[disp_col] = ew;
    lon_flags &= ~0x80;
    if (ew == 'W') lon_flags |= 0x10;
    return 1;
}
u8 mice_lon_own(void)
{ P = own_frame + 0x2B; mice_ns = own_frame[5]; mice_lonoff = own_frame[4];
  lon_flags = 0x80; return mice_lon_core(); }
u8 mice_lon_A7F4(void)
{ P = (u8 *)0xFFA7FA; mice_ns = *(u8 *)0xFFA7F9; mice_lonoff = *(u8 *)0xFFA7F8;
  lon_flags = 0x80; return mice_lon_core(); }
u8 mice_lon_A888(void)                               /* 04C198 */
{ P = (u8 *)0xFFA888; mice_ns = *(u8 *)0xFFA887; mice_lonoff = *(u8 *)0xFFA886;
  lon_flags = 0x80; return mice_lon_core(); }
u8 mice_lon_cur(void)                                /* 04C1BE */
{ P = disp_info + 1; mice_ns = cur_frame[5]; mice_lonoff = cur_frame[4];
  lon_flags = 0x80; return mice_lon_core(); }
u8 mice_lon_packed(void)                             /* 04C150 */
{ u8 *r = P; P += 6; mice_ns = r[5]; mice_lonoff = r[4];
  lon_flags = 0xC0; return mice_lon_core(); }

void blank_masked(u8 mask, u8 bit /*r4h*/, u8 n /*r3h*/, u8 fill /*r3l*/) /* 04BFF4 */
{   do { if (mask & (1 << bit)) *D = fill; D++; bit--; } while (--n); }
static void blank_amb_lon(u8 *at)                    /* 04BFCC.. pattern     */
{
    if (!ambig_bits) return;
    D = at; blank_masked(ambig_bits, 6, 3, ' '); D++;
    blank_masked(ambig_bits, 3, 2, ' '); D++;
    if (!(u_pos_dms & 1)) blank_masked(ambig_bits, 1, 2, ' '); else D += 2;
}
u8 mice_lon_rx(void)                                 /* 04C104 */
{
    P = rx_info + 1; mice_ns = rx_frame[5]; mice_lonoff = rx_frame[4];
    lon_flags = 0xC0;
    if (!mice_lon_core()) return 0;
    if (ambig_bits) { D = &disp_line[2]; blank_masked(ambig_bits, 6, 3, ' '); D++;
                      blank_masked(ambig_bits, 3, 2, ' '); D++;
                      blank_masked(ambig_bits, 1, 2, ' '); }
    return 1;
}
void row_lon_mice(void)                              /* 04BF46 */
{
    PUT_LBL(pos_lbl, u_pos_dms);
    if (!mice_lon_cur()) { PUT_LBL(lon_dash_lbl, u_pos_dms); blank_lz2(10); return; }
    blank_lz2(10);
    blank_amb_lon(&disp_line[10]);                   /* FFB064               */
}
static void row_lon_full(u8 (*dec)(void))           /* 04C004 / 04C050 */
{
    PUT_LBL_FULL(pos_lbl, u_pos_dms);
    if (!dec()) { PUT_LBL_FULL(lon_dash_lbl, u_pos_dms); blank_lz2(2); return; }
    blank_lz2(2);
    blank_amb_lon(&disp_line[2]);                    /* FFB05C               */
}
void row_lon_mice_own(void)  { row_lon_full(mice_lon_own); }
void row_lon_mice_A7F4(void) { row_lon_full(mice_lon_A7F4); }

/* ========================================================================== *
 * 04C284-04C32C size 168  row_mice_device_date  (sub_4C284)  Confirmed
 * Mic-E device / model name (table 0x04C32C, 9-byte rows: "TH-D7",
 * "TM-D700", "TM-D710", "McE-Msg", "YAESU", "VX-8", "McE-Trk", "FTM-350",
 * "VX-8G", "TH-D72", "FT1D", "FTM-400D", "FT2D", "FTM-100D", "FT3D",
 * "TH-D74", "-------"), then the date.  Code 0 falls back to the type name.
 * ========================================================================== */
extern const u8 mice_dev_lbl[];                      /* 0x04C32C */
void row_mice_device_date(void)                      /* 04C284 */
{
    disp_col = 7;
    P = disp_info + 9;
    u8 code; mice_type(&code);
    if (code == 0) { row_type_date(); return; }
    PUT_LBL(mice_dev_lbl, code - 1);
    put_date();
}

/* ========================================================================== *
 * 04C460-04C49A size 58  row_mice_status   (sub_4C460)  Confirmed
 * 04C49A-04C4E2 size 72  mice_msg_code     (sub_4C49A)  Confirmed
 * Callers of 4C49A: sub_4986A, 4C460.  Mic-E message from dest[0..2]:
 * per char, digit/'L' -> 0, 'A'-'K' -> 1 + custom, 'P'-'Z' -> 1 + std;
 * result bits: 0 = EMERGENCY, 1..7 = Priority..Off Duty, custom adds 7
 * (Custom-6..Custom-0), any other char -> 15 "(???????????)".
 * Labels: 13-byte rows at 0x04C4E2.
 * ========================================================================== */
extern const u8 mice_msg_lbl[];                      /* 0x04C4E2 */
u8 mice_msg_code(const u8 *dst /* er6 */)            /* 04C49A */
{
    u8 bits = 0, custom = 0;
    for (int i = 0; i < 3; i++) {
        u8 c = *dst++; bits <<= 1;
        if (c >= '0' && c <= '9') { bits &= ~1; continue; }
        if (c >= 'A' && c < 'L')  { custom = 1; bits |= 1; continue; }
        if (c == 'L')             { bits &= ~1; continue; }
        if (c >= 'P' && c <= 'Z') { custom = 0; bits |= 1; continue; }
        return 0x0F;
    }
    if (bits && custom) bits += 7;
    return bits;
}
void row_mice_status(void)                           /* 04C460 */
{   PUT_LBL(mice_msg_lbl, mice_msg_code(cur_frame)); }

/* ========================================================================== *
 * Mic-E speed / course.
 * 04C5C4 size 106 row_mice_speed   (sub_4C5C4) Confirmed  spd = (SP-28)*10 +
 *                 (DC-28)/10, mod 800, knots
 * 04C62E size 18  speed_print      (sub_4C62E) Confirmed  (4CC84, 4E0FE)
 * 04C640 size 40  speed_conv       (sub_4C640) Confirmed  1 knot: as is;
 *                 2 mph: *115/100; else km/h: *185/100 (round half up)
 * 04C6C0 size 100 row_mice_course  (sub_4C6C0) Confirmed  crs = ((DC-28)%10)
 *                 *100 + (SE-28), mod 400
 * 04C724 size 12  course_print     (sub_4C724) Confirmed  3 digits at col 16
 * 04C750 size 62  mice_course_val  (sub_4C750) Confirmed  value only (bearing
 *                 callback, reached through table 0x4F3E4)
 * ========================================================================== */
extern const u8 speed_lbl[];                         /* 0x04C668 */
extern const u8 course_lbl[];                        /* 0x04C730 */
extern void fmt_u16_4(u8 *dst, u16 v);               /* sub_52788 */
extern void fmt_u17_5(u8 *dst, u32 v);               /* sub_52780 */
extern void fmt_u32_8(u8 *dst, u32 v);               /* sub_5270A */
u16 speed_conv(u8 unit, u16 kn)                      /* 04C640 */
{
    if (unit == 1) return kn;
    u32 t = (u32)kn * ((unit == 2) ? 0x73 : 0xB9);
    u16 q = t / 100; if (t % 100 >= 50) q++;
    return q;
}
void speed_print(u16 kn)                             /* 04C62E */
{   fmt_u16_4(&disp_line[0x0D], speed_conv(u_speed, kn)); }   /* FFB067 */
void row_mice_speed(void)                            /* 04C5C4 */
{
    PUT_LBL(speed_lbl, u_speed);
    P = disp_info + 4;
    u16 v = (u8)(*P++ - 0x1C) * 10;
    u8 dc = *P++ - 0x1C;
    v += dc ? dc / 10 : 0;
    if (v >= 800) v -= 800;
    speed_print(v);
}
static u16 mice_course_calc(void)
{
    P = disp_info + 5;
    u8 dc = *P++ - 0x1C;
    u16 v = (u16)(dc ? dc % 10 : 0) * 100;
    v += (u8)(*P - 0x1C);
    if (v >= 400) v -= 400;
    return v;
}
void course_print(u16 v) { D = &disp_line[0x10]; fmt_3(v); }  /* FFB06A */
void row_mice_course(void) { PUT_LBL(course_lbl, 0); course_print(mice_course_calc()); }
u16  mice_course_val(void) { return mice_course_calc(); }

/* ========================================================================== *
 * 04C78E-04C7DC size 78   row_mice_alt     (sub_4C78E)  Confirmed
 * 04C7DC-04C7E4 size 8    mice_type_cmp    (sub_4C7DC)  Confirmed (sub_522CA,
 *                         same as mice_type with end = FFA4C2)
 * 04C7E4-04C874 size 144  mice_type        (sub_4C7E4)  Confirmed
 * 04C874-04C8E4 size 112  mice_yaesu_code  (sub_4C874)  Confirmed
 * mice_type(): P = first byte after the symbol (info+9).  Device code from
 * the type byte: '>' -> 1 (TH-D7; '=' trailer -> 0x0A TH-D72; '^' -> 0x10
 * TH-D74), ']' -> 2 (TM-D700; '=' -> 3 TM-D710), '`' -> Yaesu "_x" trailer
 * code 4..0x0F, '\'' -> 7 (McE-Trk), else 0.  Returns -1 when no data,
 * 1 when a "xxx}" altitude follows, else 0; P is advanced past the type
 * byte (except in the "else" case where it is not consumed).
 * ========================================================================== */
static u8 *mt_end;
s8 mice_type(u8 *code)                               /* 04C7E4 / core 04C7EA */
{
    u8 *end = mt_end ? mt_end : disp_end; mt_end = 0;
    *code = 0;
    if (P >= end) return -1;
    u8 c = *P, alt_code = 0;
    if (c == '>' || c == ']') {
        *code = (c == '>') ? 1 : 2; alt_code = (c == '>') ? 0x0A : 3;
        u8 n = (u8)(end - P) - 1;
        if (n) {
            u8 *q = end - 1; u8 last = *q;
            if (n != 1 && last == '\r') last = *--q;
            if (last == '=') *code = alt_code;
            else if (last == '^') *code = 0x10;
        }
    } else if (c == '`') {
        *code = 4; /* mice_yaesu_code() refines */
        extern u8 mice_yaesu_code(u8 *end); *code = mice_yaesu_code(end);
    } else if (c == '\'') {
        *code = 7;
    } else {
        if (P + 3 < end && P[3] == '}') return 1;     /* 04C81C               */
        return 0;
    }
    if (P + 4 < end && P[4] == '}') { P++; return 1; }
    P++; return 0;
}
s8 mice_type_cmp(u8 *code) { mt_end = cmp_end; return mice_type(code); } /* 04C7DC */
u8 mice_yaesu_code(u8 *end)                          /* 04C874 */
{
    u8 r = 4, n = (u8)(end - P) - 1, m;
    if (n == 0 || n == 1) return r;
    u8 *q = end - 1; u8 last = *q;
    if (n != 2 && last == '\r') last = *--q;
    switch (last) {
    case '0': m = 0x0F; break;  case ')': m = 0x0E; break;
    case '(': m = 0x0D; break;  case '%': m = 0x0C; break;
    case '$': m = 0x0B; break;  case '#': m = 0x09; break;
    case '"': m = 0x08; break;  case ' ': m = 0x06; break;
    default:  m = 0x05; break;
    }
    if (q[-1] == '_') r = m;
    return r;
}
void mice_alt_print(void);
extern const u8 alt_lbl[];                           /* 0x04CA52 */
void row_mice_alt(void)                              /* 04C78E */
{
    PUT_LBL(alt_lbl, u_alt_ft);
    P = disp_info + 9;
    u8 code; if (mice_type(&code) > 0) mice_alt_print();
}

/* ========================================================================== *
 * 04C8E4-04CA1A size 310  mice_alt_print   (sub_4C8E4)  Confirmed
 * 04CA1A-04CA52 size 56   m_to_ft          (sub_4CA1A)  Confirmed
 * Altitude "xxx}" = base-91, metres + 10000:  (c1-33)*8281 + (c2-33)*91 +
 * (c3-33) - 10000.  Feet = (m*328 + m*8/100)/100 (== m*3.2808).  Negative
 * values use the second label row set at 0x04CA70 ("Alt  -     m") and a
 * 5-digit field at col+6; positive use 0x04CA52 and 8 digits at col+3.
 * ========================================================================== */
extern const u8 alt_neg_lbl[];                       /* 0x04CA70 */
u32 m_to_ft(u32 m)                                   /* 04CA1A (er2 in/out) */
{
    if (!m) return 0;
    u32 a = m * 0x148;                               /* *328                 */
    u32 b = (u16)((m * 8) / 100);
    return (a + b) / 100;
}
void mice_alt_print(void)                            /* 04C8E4 */
{
    u8 c1 = P[0], c2 = P[1], c3 = P[2];
    if (c1 < 0x21 || c1 >= 0x7D) return;
    s32 v = (s32)(c1 - 0x21) * 0x2059;
    if (c2 < 0x21 || c2 >= 0x7D) return;
    v += (c2 - 0x21) * 0x5B;
    if (c3 < 0x21 || c3 >= 0x7D) return;
    v += (c3 - 0x21) - 10000;
    int neg;
    if (u_alt_ft) {
        sign_flags_AA34 &= ~0x80;
        if (v < 0) { sign_flags_AA34 |= 0x80; v = -v; }
        v = (s32)m_to_ft((u32)v);
        neg = (sign_flags_AA34 & 0x80) != 0;
    } else { neg = v < 0; if (neg) v = -v; }
    if (neg) { PUT_LBL(alt_neg_lbl, u_alt_ft);
               fmt_u17_5(&disp_line[disp_col + 6], (u32)v); }
    else     { PUT_LBL(alt_lbl, u_alt_ft);
               fmt_u32_8(&disp_line[disp_col + 3], (u32)v); }
}

/* ========================================================================== *
 * 04CA8E-04CAB6 size 40  row_status_title   (sub_4CA8E)  Confirmed
 * Copies the 15-byte label "[ STATUS TEXT ]" (0x04CAB6) to disp_col-5.
 * (IDA names the source j_reset_handler_1: it is a string, not code.)
 * ========================================================================== */
void row_status_title(void)
{   memcpy(&disp_line[(u8)(disp_col - 5)], (const u8 *)0x4CAB6, 0x0F); }

/* ========================================================================== *
 * 04CAC6-04CB42 size 124  row_mice_text     (sub_4CAC6)  Confirmed
 * Four entries (0x4CAC6/CE/D6/DE) = text window 0/20/40/60 of the Mic-E
 * comment: after the type byte (and a "xxx}" altitude), up to the end of
 * the frame minus '\r' minus the device trailer length (0x3F1E[code]).
 * The line is pre-filled from the 20-dot template at 0x04F96A.
 * ========================================================================== */
void copy_window(u32 skip /*er1*/, u8 *end /*er5*/, u8 n /*r3l*/);  /* 4F94A */
void row_mice_text(u8 win /* 0,0x14,0x28,0x3C */)    /* 04CAC6.. */
{
    memcpy(&disp_line[1], (const u8 *)0x4F96A, 0x14);
    P = disp_info + 9;
    u8 code; s8 a = mice_type(&code);
    if (a > 0) P += 4;
    u8 *end = disp_end;
    if (end[-1] == '\r') end--;
    end -= dev_suffix_len[code];
    line_attr = 0;
    copy_window(win, end, 0x14);                     /* sub_4F948            */
}

/* ========================================================================== *
 * Compressed-position detail pages ('/' '@' and '!' '=' with base-91).
 * 04CB42 size 66  page_cmp_ts_wx     (sub_4CB42)  Confirmed  desc 0x04ACCC
 * 04CB84 size 56  page_cmp_ts        (sub_4CB84)  Confirmed  desc 0x04AC90
 * 04CBBC size 28  hdr_sym_cmp_ts     (sub_4CBBC)  Confirmed  info[8]/[0x11]
 * 04DAEC size 66  page_cmp_wx        (sub_4DAEC)  Confirmed  desc 0x04ACCC
 * 04DB2E size 56  page_cmp           (sub_4DB2E)  Confirmed  desc 0x04AC90
 * 04DB66 size 28  hdr_sym_cmp        (sub_4DB66)  Confirmed  info[1]/[0x0A]
 * Each: decode lat/lon (base-91), distance/bearing, the cs-byte kind, then
 * (weather pages) parse the weather extension starting 4 chars in, and open
 * the page.  The "_ts" forms are DTI '/' '@' (7-char timestamp).
 * ========================================================================== */
void cmp_lat_cur(void); void cmp_lon_cur(void);      /* 04D05E / 04D282      */
u8   cmp_cs_kind(void);                               /* 04CBD8               */
void wx_parse(void);                                  /* 04F084               */
static void hdr_sym_from(u8 it, u8 ic)
{   hdr_sym_t = disp_info[it]; hdr_sym_c = disp_info[ic]; page_sym(); }
void hdr_sym_cmp_ts(void) { hdr_sym_from(0x08, 0x11); }   /* 04CBBC */
void hdr_sym_cmp(void)    { hdr_sym_from(0x01, 0x0A); }   /* 04DB66 */
static void page_cmp_common(u8 wx, const void *desc, void (*hdr)(void))
{
    page_max = wx ? 0x0D : 8; page_var = wx ? 5 : 0;
    cmp_lat_cur(); cmp_lon_cur(); calc_dist_brg_539C6();
    cs_kind = cmp_cs_kind();
    if (wx) { ext_adj = 4; wx_parse(); page_tbl = 1; }
    else    { ext_off = 3; page_tbl = 3; }
    if (page_open(desc)) return;
    hdr();
}
void page_cmp_ts_wx(void) { page_cmp_common(1, (void *)0x4ACCC, hdr_sym_cmp_ts); }
void page_cmp_ts(void)    { page_cmp_common(0, (void *)0x4AC90, hdr_sym_cmp_ts); }
void page_cmp_wx(void)    { page_cmp_common(1, (void *)0x4ACCC, hdr_sym_cmp); }
void page_cmp(void)       { page_cmp_common(0, (void *)0x4AC90, hdr_sym_cmp); }

/* ========================================================================== *
 * 04CBD8 size 4   cmp_cs_kind     (sub_4CBD8)  Confirmed (thunk: ext_ptr, then
 *                 falls into 04CBDC)
 * 04CBDC size 44  cs_kind_at      (sub_4CBDC)  Confirmed (also 5242E/524CE)
 * Compressed "csT": T-33 must be 0..0x5A; ((T-33)&0x18)==0x10 (GGA
 * source) -> 0 altitude; c=='{' -> 2 radio range; else 1 course/speed;
 * bad T -> 0xFF.
 * ========================================================================== */
u8 *ext_ptr(void);
u8 cs_kind_at(void)                                  /* 04CBDC */
{
    u8 t = P[2] - 0x21;
    if ((s8)t < 0 || t >= 0x5B) return 0xFF;
    if ((t & 0x18) == 0x10) return 0;
    return (P[0] == '{') ? 2 : 1;
}
u8 cmp_cs_kind(void) { ext_ptr(); return cs_kind_at(); }

/* ========================================================================== *
 * Compressed cs rows.  Speed table 0x04E76C u16[91] (knots, 1.08^s-1),
 * range tables 0x04E822 (mi) / 0x04E8D8 (km) u16[91] in tenths, altitude
 * tables 0x04E98E u32[91] (by c) and 0x04EAFA u16[91] (by s) - this names
 * the "base-91 decode" tables doc 118 left Inferred.
 * 04CC08 size 82  row_cmp_course   (sub_4CC08) Confirmed  course = (c-33)*4
 * 04CC5A size 42  cmp_course_val   (sub_4CC5A) Confirmed  or 0xFFFF
 * 04CC84 size 106 row_cmp_speed    (sub_4CC84) Confirmed
 * 04CCEE size 144 row_cmp_range    (sub_4CCEE) Confirmed
 * 04CD9C size 238 row_cmp_alt      (sub_4CD9C) Confirmed (alt = 1.002^cs ft)
 * 04CE8A size 40  (tail of 04CD9C, IDA split)  Confirmed
 * ========================================================================== */
extern const u16 b91_speed_kn[91];   /* 0x04E76C */
extern const u16 b91_range_mi[91];   /* 0x04E822 */
extern const u16 b91_range_km[91];   /* 0x04E8D8 */
extern const u32 b91_alt_hi[91];     /* 0x04E98E */
extern const u16 b91_alt_lo[91];     /* 0x04EAFA */
extern const u8  range_lbl[];        /* 0x04CD7E */
extern const u8  speed2_lbl[];       /* 0x04C694 "Speed   -km/h".. */
static int b91(u8 c, u8 *v) { u8 t = c - 0x21; if ((s8)t < 0 || t >= 0x5B) return 0; *v = t; return 1; }
void row_cmp_course(void)                            /* 04CC08 */
{
    PUT_LBL((const void *)0x4C740, 0);               /* "Course    -"         */
    if (cs_kind != 1) return;
    ext_ptr(); u8 c; if (!b91(P[0], &c)) return;
    course_print((u16)c * 4);
}
u16 cmp_course_val(void)                             /* 04CC5A */
{
    if (cs_kind != 1) return 0xFFFF;
    ext_ptr(); u8 c; if (!b91(P[0], &c)) return 0xFFFF;   /* r3 untouched: TODO */
    return (u16)c * 4;
}
void row_cmp_speed(void)                             /* 04CC84 */
{
    PUT_LBL(speed2_lbl, u_speed);
    if (cs_kind != 1) return;
    ext_ptr(); u8 s; if (!b91(P[1], &s)) return;
    speed_print(b91_speed_kn[s]);
}
void row_cmp_range(void)                             /* 04CCEE */
{
    PUT_LBL(range_lbl, u_dist_mi);
    if (cs_kind != 2) return;
    ext_ptr(); u8 s; if (!b91(P[1], &s)) return;
    u16 r = u_dist_mi ? b91_range_mi[s] : b91_range_km[s];
    disp_line[0x12] = '0' + r % 10;                  /* FFB06C tenths        */
    fmt_u16_4(&disp_line[0x0D], r / 10);             /* FFB067               */
}
void row_cmp_alt(void)                               /* 04CD9C + 04CE8A */
{
    PUT_LBL(alt_lbl, u_alt_ft);
    if (cs_kind != 0) return;
    ext_ptr();
    u8 raw = P[0], c, s;
    if (!b91(P[0], &c) || !b91(P[1], &s)) return;
    u32 m = b91_alt_lo[s] + 1000;
    u32 v = b91_alt_hi[c] * m;
    v = (raw < 'h') ? v / 10000 : v / 100;           /* 04CE22 cmp #0x68     */
    if (!u_alt_ft && v) {                            /* feet -> metres       */
        u32 a = v * 3, b = v * 0x30;
        v = (b / 1000 + a) / 10;                     /* = v*0.3048           */
    }
    fmt_u32_8(&disp_line[0x0B], v);                  /* FFB065               */
}

/* ========================================================================== *
 * Uncompressed-position detail pages.
 * 04CEB2 size 190  page_unc_ts   (sub_4CEB2) Confirmed  DTI '/' '@'
 * 04DB82 size 190  page_unc      (sub_4DB82) Confirmed  DTI '!' '='
 * 04ED2E size 184  page_obj_unc  (sub_4ED2E) Confirmed  DTI ';'
 * 04EE66 size 182  page_item_unc (sub_4EE66) Confirmed  DTI ')'
 * Choose the page by the data extension (ext_kind):
 *   0 "PHG"  -> rows desc A (PHG),  ext_off = phg_ext_len()  (7 or 9)
 *   2 weather -> desc W, ext_adj 0, wx_parse()
 *  -1 CSE/SPD -> desc C, ext_off 7, page_tbl 4 (course bearing)
 *   1 none    -> desc P
 * Descriptors:            P        W        C        A
 *   '/' '@'            0x4AD1C  0x4ADD4  0x4AD98  0x4AD58
 *   '!' '='            0x4AD1C  0x4ADD4  0x4AD98  0x4AD58
 *   ';'                0x4AED0  0x4AF8C  0x4AF50  0x4AF0C
 *   ')'                0x4B020  0x4B0DC  0x4B0A0  0x4B05C
 * Header symbol: '/'@' info[0x10]/[0x1A]; '!' '=' info[9]/[0x13];
 * ';' info[0x1A]/[0x24]; ')' name_end[9]/[0x13].
 * ========================================================================== */
void unc_lat_cur(void); void unc_lon_cur(void);       /* 04D4C6 / 04D762      */
s8   ext_kind_cur(void);                              /* 04CF70               */
u8   phg_ext_len(void);                               /* 04E020               */
u8  *item_name_end_cur(void);                         /* 04EF4C               */
struct unc_desc { u32 P, W, C, A; u8 wxmax, wxvar, phgmax; };
static void page_unc_common(const struct unc_desc *d, const u8 *(*hdr)(u8 *it, u8 *ic))
{
    unc_lat_cur(); unc_lon_cur(); calc_dist_brg_539C6();
    const void *desc; s8 k = ext_kind_cur();
    if (k == 0) {                                    /* PHG                  */
        page_max = d->phgmax; page_var = 2; ext_off = phg_ext_len();
        page_tbl = 1; page_step = 2; desc = (void *)d->A;
    } else if (k < 0) {                              /* course/speed         */
        page_max = 8; page_var = 0; ext_off = 7; page_tbl = 4; desc = (void *)d->C;
    } else if (k == 2) {                             /* weather              */
        page_max = d->wxmax; page_var = d->wxvar; ext_adj = 0; wx_parse();
        page_tbl = 1; desc = (void *)d->W;
    } else {
        page_max = 8; page_var = 0; page_tbl = 1; desc = (void *)d->P;
    }
    if (page_open(desc)) return;
    u8 it, ic; const u8 *b = hdr(&it, &ic);
    hdr_sym_t = b[it]; hdr_sym_c = b[ic]; page_sym();
}
static const u8 *hdr_info(u8 *a, u8 *b, u8 x, u8 y) { *a = x; *b = y; return disp_info; }
static const u8 *h_ts(u8 *a, u8 *b)   { return hdr_info(a, b, 0x10, 0x1A); }
static const u8 *h_nts(u8 *a, u8 *b)  { return hdr_info(a, b, 0x09, 0x13); }
static const u8 *h_obj(u8 *a, u8 *b)  { return hdr_info(a, b, 0x1A, 0x24); }
static const u8 *h_item(u8 *a, u8 *b) { *a = 9; *b = 0x13; return item_name_end_cur(); }
static const struct unc_desc D_TS  = {0x4AD1C,0x4ADD4,0x4AD98,0x4AD58,0x0D,5,9};
static const struct unc_desc D_OBJ = {0x4AED0,0x4AF8C,0x4AF50,0x4AF0C,0x0E,6,0x0A};
static const struct unc_desc D_ITM = {0x4B020,0x4B0DC,0x4B0A0,0x4B05C,0x0E,6,0x0A};
void page_unc_ts(void)   { page_unc_common(&D_TS,  h_ts);   }  /* 04CEB2 */
void page_unc(void)      { page_unc_common(&D_TS,  h_nts);  }  /* 04DB82 */
void page_obj_unc(void)  { page_unc_common(&D_OBJ, h_obj);  }  /* 04ED2E */
void page_item_unc(void) { page_unc_common(&D_ITM, h_item); }  /* 04EE66 */
/* (In the PHG branch 04CF28 the scroll step FFA98B = 2 is set; the weather
   branch also sets FFA504 = 0 before wx_parse.)                            */

/* ========================================================================== *
 * 04CF70 size 4   ext_kind_cur  (sub_4CF70)  Confirmed  thunk ext_ptr -> 4CF74
 * 04CF74 size 68  ext_kind      (sub_4CF74)  Confirmed  (also 50290, 5236C)
 * 04CFB8 size 48  dig3_or_fill  (sub_4CFB8)  Confirmed
 * ext_kind(P): "PHG" -> 0; "ddd/ddd" (each 3 digits or 3 equal '.'/' ')
 * -> 2 if the symbol code before it (P[-1]) is '_' or 'W', else -1 (CSE/SPD);
 * anything else -> 1.
 * ========================================================================== */
u8 dig3_or_fill(const u8 *s)                         /* 04CFB8: 0 ok, 1 bad */
{
    u8 c = *s;
    if (c == '.' || c == ' ') return (s[1] == c && s[2] == c) ? 0 : 1;
    return all_digits(s, 3) ? 0 : 1;
}
s8 ext_kind(void)                                    /* 04CF74 */
{
    if (P[0] == 'P' && P[1] == 'H' && P[2] == 'G') return 0;
    if (P[3] != '/' || dig3_or_fill(P) || dig3_or_fill(P + 4)) return 1;
    u8 s = P[-1];
    return (s == '_' || s == 'W') ? 2 : -1;
}
s8 ext_kind_cur(void) { ext_ptr(); return ext_kind(); }

/* ========================================================================== *
 * Base-91 (compressed) latitude / longitude.
 * 04CFE8 size 36  row_lat_cmp_own   (sub_4CFE8) Confirmed (sub_489A6)
 * 04D00C size 54  row_lat_cmp       (sub_4D00C) Confirmed
 * 04D042 size 14  cmp_lat_own       (sub_4D042) Confirmed
 * 04D050 size 214 cmp_lat_rx        (sub_4D050) Confirmed (455E6,4723C) +
 *                 entry 0x4D05E cmp_lat_cur, core 0x4D06A
 * 04D126 size 32  b91_word4         (sub_4D126) Confirmed
 * 04D146 size 56  b91_digit         (sub_4D146) Confirmed
 * 04D17E size 134 b91_to_deg4       (sub_4D17E) Confirmed
 * 04D204 size 36  row_lon_cmp_own   (sub_4D204) Confirmed (sub_489A6)
 * 04D228 size 54  row_lon_cmp       (sub_4D228) Confirmed
 * 04D25E size 18  cmp_lon_own       (sub_4D25E) Confirmed
 * 04D270 size 240 cmp_lon_rx        (sub_4D270) Confirmed + entry 0x4D282
 *                 cmp_lon_cur, core 0x4D292
 * lat = 90 - y/380926, lon = -180 + x/190463 (APRS spec); computed in
 * 1e-4 degree units with divisors {380926,38092,3809} / {190463,19046,1904}.
 * ========================================================================== */
u8 *pos_ptr_own(void); u8 *pos_ptr_rx(void); u8 *pos_ptr_cur(void);
u32 b91_digit(u8 pw /*r6l*/)                         /* 04D146 */
{
    u32 v = (u8)(*P++ - 0x21);
    while (pw--) v *= 0x5B;                          /* sub_3F900 x3/x2/x1   */
    return v;
}
u32 b91_word4(void)                                  /* 04D126 -> er1 */
{   u32 s = b91_digit(3); s += b91_digit(2); s += b91_digit(1); s += b91_digit(0); return s; }
void b91_to_deg4(u32 x /* er1 */)                    /* 04D17E */
{
    b91_q1 = x / b91_div1;                  x -= b91_q1 * b91_div1;
    x *= 10;
    b91_q2 = x / b91_div2;                  x -= b91_q2 * b91_div2;
    b91_frac = (u16)((u32)(u16)x * 10 / b91_div3);
    b91_val = (u32)(u16)b91_q1 * 10000 + (u32)(u16)b91_q2 * 100 + b91_frac;
}
static void cmp_lat_core(void)                       /* 04D06A */
{
    b91_div1 = 0x5CFFE; b91_div2 = 0x94CC; b91_div3 = 0x0EE1;
    b91_to_deg4(b91_word4());
    u8 ns = 'N'; s32 d = 900000 - (s32)b91_val;     /* 0xDBBA0              */
    if (d < 0) { d = -d; ns = 'S'; lat_flags |= 0x10; }
    disp_line[8] = ns;                               /* FFB062               */
    b91_rem = d % 10000; lat_deg = d / 10000;
    D = &disp_line[0x0B]; fmt_2(d / 10000);         /* FFB065 sub_5281E     */
    u32 t = (u32)b91_rem * 60; b91_rem = t % 10000; lat_min = t / 10000;
    D = &disp_line[0x0E]; fmt_2z(t / 10000);        /* FFB068               */
    u8 hh = b91_rem / 100;
    *(u16 *)&lat_hh_t = hh * 10;
    lat_flags &= ~0x80;
    D = &disp_line[0x11];                            /* FFB06B               */
    if (!(lat_flags & 0x40)) dms_secs(hh, 0); else fmt_2z(hh);
}
static void cmp_lon_core(void)                       /* 04D292 */
{
    b91_div1 = 0x2E7FF; b91_div2 = 0x4A66; b91_div3 = 0x0770;
    b91_to_deg4(b91_word4());
    u8 ew = 'E'; s32 d = (s32)b91_val - 1800000;    /* + 0xFFE488C0         */
    if (d < 0) { d = -d; ew = 'W'; lon_flags |= 0x10; }
    disp_line[8] = ew;
    b91_rem = d % 10000;
    u16 deg = d / 10000, r1 = deg;
    if (r1 >= 100) { lon_flags |= 0x01; r1 -= 100; }
    lon_deg = (u8)r1;
    D = &disp_line[0x0A]; fmt_3(deg);               /* FFB064, full degrees */
    u32 t = (u32)b91_rem * 60; b91_rem = t % 10000; lon_min = t / 10000;
    D = &disp_line[0x0E]; fmt_2z(t / 10000);
    u8 hh = b91_rem / 100;
    *(u16 *)&lon_hh_t = hh * 10;
    lon_flags &= ~0x80;
    D = &disp_line[0x11];
    if (!(lon_flags & 0x40)) dms_secs(hh, 0); else fmt_2z(hh);
}
void cmp_lat_own(void) { lat_flags = 0x80; pos_ptr_own(); P++; cmp_lat_core(); }
void cmp_lat_rx(void)  { lat_flags = 0xC0; pos_ptr_rx();  P++; cmp_lat_core(); }
void cmp_lat_cur(void) { lat_flags = 0x80; pos_ptr_cur(); P++; cmp_lat_core(); }
void cmp_lon_own(void) { lon_flags = 0x80; pos_ptr_own(); P += 5; cmp_lon_core(); }
void cmp_lon_rx(void)  { lon_flags = 0xC0; pos_ptr_rx();  P += 5; cmp_lon_core(); }
void cmp_lon_cur(void) { lon_flags = 0x80; pos_ptr_cur(); P += 5; cmp_lon_core(); }
void row_lat_cmp_own(void) { PUT_LBL_FULL(pos_lbl, u_pos_dms); cmp_lat_own(); }
void row_lat_cmp(void)     { PUT_LBL(pos_lbl, u_pos_dms);      cmp_lat_cur(); }
void row_lon_cmp_own(void) { PUT_LBL_FULL(pos_lbl, u_pos_dms); cmp_lon_own(); }
void row_lon_cmp(void)     { PUT_LBL(pos_lbl, u_pos_dms);      cmp_lon_cur(); }

/* ========================================================================== *
 * 04D360 size 20   pos_ptr_own  (sub_4D360) Confirmed  P = FF1A42 (own info),
 *                  DTI = FFA523, saved in FFA986
 * 04D374 size 116  pos_ptr_rx   (sub_4D374) Confirmed  P = rx_info, DTI = rx_dti
 *                  + entry 0x4D388 pos_ptr_cur (P = disp_info, DTI = cur_dti)
 * Offset of the position inside the info field by DTI:
 *   '/' '@' 8,  '!' '=' 1,  ';' 0x12,  ')' item-name end + 1,  else 0.
 * ========================================================================== */
u8 *item_name_end(void);                             /* 04EF52 */
static u8 *pos_ptr_core(u8 dti, u8 alt)              /* 04D394 */
{
    u32 off;
    if (dti == '/' || dti == '@') off = 8;
    else if (dti == '!' || dti == '=') off = 1;
    else if (dti == ';') off = 0x12;
    else if (dti == ')') {
        if (alt) P = pos_src_ptr; else P = disp_info;
        item_name_end(); off = 1;
    } else off = 0;
    P += off; return P;
}
u8 *pos_ptr_own(void) { P = own_frame + 0x2A; pos_src_ptr = P; return pos_ptr_core(item_dti_A523, 1); }
u8 *pos_ptr_rx(void)  { P = rx_info;          pos_src_ptr = P; return pos_ptr_core(rx_dti, 1); }
u8 *pos_ptr_cur(void) { P = disp_info;                         return pos_ptr_core(cur_dti, 0); }

/* ========================================================================== *
 * Uncompressed "DDMM.hhN" / "DDDMM.hhE" with ' ' ambiguity.
 * 04D3E8 size 82  row_lat_unc_own  (sub_4D3E8) Confirmed (sub_4892E)
 * 04D43A size 116 row_lat_unc      (sub_4D43A) Confirmed
 * 04D4AE size 12  unc_lat_own      (sub_4D4AE) Confirmed
 * 04D4BA size 430 unc_lat_rx       (sub_4D4BA) Confirmed + entry 0x4D4C6
 *                 unc_lat_cur, core 0x4D4D0
 * 04D668 size 82  row_lon_unc_own  (sub_4D668) Confirmed (sub_4892E)
 * 04D6BA size 116 row_lon_unc      (sub_4D6BA) Confirmed
 * 04D72E size 26  unc_lon_own      (sub_4D72E) Confirmed
 * 04D748 size 604 unc_lon_rx       (sub_4D748) Confirmed + entry 0x4D762
 *                 unc_lon_cur, core 0x4D774 (offsets 0x11/0x0A/0x1B/name+0x0A)
 * Each digit is echoed to the display; ' ' counts as 0.  Lat hemisphere
 * N/n/S/s, lon E/e/W/w; anything else -> 0 (row shows the dash label).
 * ========================================================================== */
static int unc_dig(u8 *v)
{   u8 c = *P++;
    if (c == ' ') *v = 0; else if (c >= '0' && c <= '9') *v = c - '0'; else return 0;
    *D++ = c; return 1; }
static u8 unc_tail(u8 *flags, u8 pos_c, u8 neg_c, u8 hi, u8 lo)
{
    u8 c = *P++, r;
    if (c == pos_c || c == (pos_c | 0x20)) r = pos_c;
    else if (c == neg_c || c == (neg_c | 0x20)) { *flags |= 0x10; r = neg_c; }
    else return 0;
    *flags &= ~0x80;
    disp_line[disp_col] = r;
    return r;
}
static u8 unc_lat_core(void)                         /* 04D4D0 */
{
    u8 a, b, c, d, e, f;
    D = &disp_line[disp_col + 3];
    if (!unc_dig(&a) || !unc_dig(&b)) return 0;  lat_deg = a * 10 + b;  D++;
    if (!unc_dig(&c) || !unc_dig(&d)) return 0;  lat_min = c * 10 + d;
    P++; D++;                                        /* skip '.'             */
    if (!unc_dig(&e) || !unc_dig(&f)) return 0;
    u8 hh = e * 10 + f;
    if (!(lat_flags & 0x40) && u_pos_dms) { D -= 2; dms_secs_auto(hh); }
    *(u16 *)&lat_hh_t = hh * 10; D++;
    return unc_tail(&lat_flags, 'N', 'S', 0, 0);
}
static u8 unc_lon_core(u8 dti, u8 alt)               /* 04D774 */
{
    u32 off;
    if (dti == '/' || dti == '@') off = 0x11;
    else if (dti == '!' || dti == '=') off = 0x0A;
    else if (dti == ';') off = 0x1B;
    else if (dti == ')') { if (alt) P = pos_src_ptr; item_name_end(); off = 0x0A; }
    else off = 0;
    P += off;
    D = &disp_line[disp_col + 2];
    u8 h, a, b, c, d, e, f;
    if (*P == '1') { unc_dig(&h); lon_flags |= 0x01; }
    else if (*P == '0') { P++; D++; }
    else return 0;
    if (!unc_dig(&a) || !unc_dig(&b)) return 0;  lon_deg = a * 10 + b;  D++;
    if (!unc_dig(&c) || !unc_dig(&d)) return 0;  lon_min = c * 10 + d;
    P++; D++;
    if (!unc_dig(&e) || !unc_dig(&f)) return 0;
    u8 hh = e * 10 + f;
    if (!(lon_flags & 0x40) && u_pos_dms) { D -= 2; dms_secs_auto(hh); }
    *(u16 *)&lon_hh_t = hh * 10; D++;
    return unc_tail(&lon_flags, 'E', 'W', 0, 0);
}
u8 unc_lat_own(void) { lat_flags = 0x80; pos_ptr_own(); return unc_lat_core(); }
u8 unc_lat_rx(void)  { lat_flags = 0xC0; pos_ptr_rx();  return unc_lat_core(); }
void unc_lat_cur(void){ lat_flags = 0x80; pos_ptr_cur(); unc_lat_core(); }
u8 unc_lon_own(void) { lon_flags = 0x80; P = own_frame + 0x2A; pos_src_ptr = P;
                       return unc_lon_core(item_dti_A523, 1); }
u8 unc_lon_rx(void)  { lon_flags = 0xC0; P = rx_info; pos_src_ptr = P;
                       return unc_lon_core(rx_dti, 1); }
void unc_lon_cur(void){ lon_flags = 0x80; P = disp_info; unc_lon_core(cur_dti, 0); }
void row_lat_unc_own(void)
{ PUT_LBL_FULL(pos_lbl, u_pos_dms); if (!unc_lat_own()) PUT_LBL_FULL(lat_dash_lbl, u_pos_dms); blank_lz2b(2); }
void row_lat_unc(void)
{ PUT_LBL(pos_lbl, u_pos_dms); lat_flags = 0x80; pos_ptr_cur();
  if (!unc_lat_core()) PUT_LBL(lat_dash_lbl, u_pos_dms); blank_lz2b(10); }
void row_lon_unc_own(void)
{ PUT_LBL_FULL(pos_lbl, u_pos_dms); if (!unc_lon_own()) PUT_LBL_FULL(lon_dash_lbl, u_pos_dms); blank_lz2b(2); }
void row_lon_unc(void)
{ PUT_LBL(pos_lbl, u_pos_dms); lon_flags = 0x80; P = disp_info;
  if (!unc_lon_core(cur_dti, 0)) PUT_LBL(lon_dash_lbl, u_pos_dms); blank_lz2b(10); }

/* ========================================================================== *
 * 04D9A4 size 8   row_comment_title_ext (sub_4D9A4) Confirmed
 * 04D9AC size 40  row_comment_title     (sub_4D9AC) Confirmed  16 bytes
 *                 "[ COMMENT TEXT ]" (0x04D9D4) at disp_col-6
 * 04D9E6 size 12  ext_ptr_cmp           (sub_4D9E6) Confirmed  dup-check form:
 *                 P = FFA4BE, compressed iff r5l == 1, DTI still cur_dti
 * 04D9F2 size 156 ext_ptr               (sub_4D9F2) Confirmed
 * Data-extension pointer.  Uncompressed: '/' '@' +0x1B, '!' '=' +0x14,
 * '_' +0x0A, ';' +0x25, ')' name_end+0x14.  Compressed (cur_cmp == 1): to
 * the cs bytes: '/' '@' +0x12, '!' '=' +0x0B, ';' +0x1C, ')' name_end+0x0B.
 * ========================================================================== */
static u8 *ext_core(u8 cmp)
{
    u8 d = cur_dti; u32 off;
    if (cmp) {
        if (d == '/' || d == '@') off = 0x12; else if (d == '!' || d == '=') off = 0x0B;
        else if (d == ';') off = 0x1C; else if (d == ')') { item_name_end(); off = 0x0B; }
        else off = 0;
    } else {
        if (d == '/' || d == '@') off = 0x1B; else if (d == '!' || d == '=') off = 0x14;
        else if (d == '_') off = 0x0A; else if (d == ';') off = 0x25;
        else if (d == ')') { item_name_end(); off = 0x14; } else off = 0;
    }
    P += off; return P;
}
u8 *ext_ptr(void)          { P = disp_info; return ext_core(cur_cmp == 1); }  /* 04D9F2 */
u8 *ext_ptr_cmp(u8 r5l)    { P = cmp_base;  return ext_core(r5l == 1); }      /* 04D9E6 */
void row_comment_title(void)
{ memcpy(&disp_line[(u8)(disp_col - 6)], (const u8 *)0x4D9D4, 0x10); }
void row_comment_title_ext(void) { ext_ptr(); row_comment_title(); }

/* ========================================================================== *
 * 04DA8E size 22  row_ext_text     (sub_4DA8E) Confirmed  entries r1l = 0,
 *                 0x14,0x28,0x3C,0x50 (0x4DA8E/92/96/9A/9E), P = ext_ptr()
 * 04DAA4 size 72  text_window      (sub_4DAA4) Confirmed  (4DD0A, 4EFEA,
 *                 4F062, 516EC): dots template, P += ext_off, strip '\r',
 *                 line_attr 0, copy 20 chars from P+r1.
 * ========================================================================== */
void text_window(u8 win /* r1l */)                   /* 04DAA4 */
{
    memcpy(&disp_line[1], (const u8 *)0x4F96A, 0x14);
    P += ext_off;
    u8 *end = disp_end; if (end[-1] == '\r') end--;
    line_attr = 0;
    copy_window(win, end, 0x14);
}
void row_ext_text(u8 win) { ext_ptr(); text_window(win); }      /* 04DA8E.. */

/* ========================================================================== *
 * 04DC40 size 190 page_wx_nopos   (sub_4DC40) Confirmed  DTI '_' page:
 *   positionless weather "_MDHMcDDDsSSS...".  Pointers to the 'c' and 's'
 *   digits are kept in FFA530/534; descriptor 0x04AE24 (or 0x04AE6C when
 *   the c/s fields are malformed).  Position flags forced invalid.
 * 04DCFE size 12  row_wx_nopos_title (sub_4DCFE) Confirmed
 * 04DD0A size 30  row_wx_nopos_text  (sub_4DD0A) Confirmed  entries r1l =
 *                 0..0x50, P = ext_ptr()-1
 * ========================================================================== */
u8 wx_check_field(u8 letter /*r1h*/, u8 n /*r1l*/, u16 off /*e1*/);  /* 04E60A */
void page_wx_nopos(void)                             /* 04DC40 */
{
    lat_flags = 0x80; lon_flags = 0x80;
    ext_ptr(); P--;
    ext_adj = 0; wx_dir = 0; wx_spd = 0;
    const void *desc;
    u8 r = wx_check_field('c', 3, 0);
    if (r < 2) {
        if (r != 1) wx_dir = P;
        P += 3;
        r = wx_check_field('s', 3, 0);
        if (r < 2) {
            if (r != 1) wx_spd = P;
            page_max = 0x0B; page_var = 0xFF; wx_parse();
            ext_off++; page_tbl = 1; desc = (void *)0x4AE24;
            goto open;
        }
    }
    page_max = 2; page_var = 0xFF; wx_parse();
    ext_off++; page_tbl = 1; desc = (void *)0x4AE6C;
open:
    if (page_open(desc)) return;
    page_sym();
}
void row_wx_nopos_title(void) { ext_ptr(); P--; row_comment_title(); }
void row_wx_nopos_text(u8 w)  { ext_ptr(); P--; text_window(w); }

/* ========================================================================== *
 * PHG rows ("PHGphgd[r/]"): power p^2 W, height 10*2^h ft, gain dB,
 * directivity 45*d, beacon rate.
 * 04DD28 size 90  row_phg_power   (sub_4DD28) Confirmed table 0x04DD92
 * 04DDA6 size 128 row_phg_height  (sub_4DDA6) Confirmed tables 0x04DE44 (m)
 *                 / 0x04DE6C (ft), 4-char fields
 * 04DE94 size 78  row_phg_gain    (sub_4DE94) Confirmed
 * 04DEF2 size 110 row_phg_dir     (sub_4DEF2) Confirmed table 0x04DF70
 *                 ("omni","  45".." 360","   -")
 * 04DF98 size 120 row_phg_rate    (sub_4DF98) Inferred  rate char before '/'
 *                 ('0'-'9','A'-'Z') -> u16 from table 0x4490
 * 04E020 size 52  phg_ext_len     (sub_4E020) Confirmed 7, or 9 when
 *                 P[8]=='/' and P[7] is [0-9A-Z]
 * ========================================================================== */
void row_phg_power(void)
{
    PUT_LBL((const void *)0x4DD82, 0);
    ext_ptr(); P += 3;
    u8 c = *P; if (c < '0' || c > '9') return;
    const u8 *t = (const u8 *)0x4DD92 + (c - '0') * 2;
    disp_line[0x11] = t[0]; disp_line[0x12] = t[1];  /* FFB06B/6C            */
}
void row_phg_height(void)
{
    PUT_LBL((const void *)0x4DE26, u_alt_ft);
    ext_ptr(); P += 4;
    u8 c = *P; if (c < '0' || c > '9') return;
    const u8 *t = (const u8 *)(u_alt_ft ? 0x4DE6C : 0x4DE44) + (c - '0') * 4;
    memcpy(&disp_line[0x0F], t, 4);                  /* FFB069..6C           */
}
void row_phg_gain(void)
{
    PUT_LBL((const void *)0x4DEE2, 0);
    ext_ptr(); P += 5;
    u8 c = *P; if (c < '0' || c > '9') return;
    disp_line[0x12] = c;                             /* '0'+(c-'0')          */
}
void row_phg_dir(void)
{
    PUT_LBL((const void *)0x4DF60, 0);
    ext_ptr(); P += 6;
    u8 c = *P; if (c < '0' || c > '9') return;
    memcpy(&disp_line[0x0F], (const u8 *)0x4DF70 + (c - '0') * 4, 4);
    if (c == '0') disp_line[0x13] = ' ';             /* FFB06D after "omni"  */
}
void row_phg_rate(void)
{
    PUT_LBL((const void *)0x4E010, 0);
    ext_ptr(); P += 8;
    if (P >= disp_end || *P != '/') return;
    u8 c = *--P, i;
    if (c >= '0' && c <= '9') i = c - '0';
    else if (c >= 'A' && c <= 'Z') i = c - 'A' + 10;
    else return;
    const u8 *t = (const u8 *)0x4490 + i * 2;
    disp_line[0x11] = t[0]; disp_line[0x12] = t[1];
}
u8 phg_ext_len(void)                                 /* 04E020 */
{
    ext_ptr();
    u8 *q = P + 8;
    if (q >= disp_end || *q != '/') return 7;
    u8 c = q[-1];
    if ((c >= '0' && c <= '9') || (c >= 'A' && c <= 'Z')) return 9;
    return 7;
}

/* ========================================================================== *
 * CSE/SPD extension rows ("ddd/ddd", knots).
 * 04E054 size 102 row_cse_unc    (sub_4E054) Confirmed (copy 3 chars)
 * 04E0BA size 68  cse_unc_val    (sub_4E0BA) Confirmed (bearing callback)
 * 04E0FE size 96  row_spd_unc    (sub_4E0FE) Confirmed
 * A field of "..." or "   " is treated as absent.
 * ========================================================================== */
static int field3_absent(const u8 *s)
{   return (s[0]=='.'&&s[1]=='.'&&s[2]=='.') || (s[0]==' '&&s[1]==' '&&s[2]==' '); }
void row_cse_unc(void)
{
    PUT_LBL((const void *)0x4C740, 0);
    ext_ptr(); if (field3_absent(P)) return;
    memcpy(&disp_line[0x10], P, 3); blank_lz2(0x10);
}
u16 cse_unc_val(void)
{
    ext_ptr(); if (field3_absent(P)) return 0xFFFF;
    return (P[0]-'0') * 100 + (P[1]-'0') * 10 + (P[2]-'0');
}
void row_spd_unc(void)
{
    PUT_LBL(speed2_lbl, u_speed);
    ext_ptr(); P += 4; if (field3_absent(P)) return;
    speed_print(parse_dec3());
}

/* ========================================================================== *
 * Weather rows (pointers filled by wx_parse; NULL = field absent).
 * 04E15E size 64  row_rain_1h    (sub_4E15E) Confirmed 'r' (A540)
 * 04E19E size 62  row_rain_24h   (sub_4E19E) Confirmed 'p' (A544)
 * 04E1DC size 62  row_rain_mid   (sub_4E1DC) Confirmed 'P' (A548)
 * 04E21A size 98  rain_print     (sub_4E21A) Confirmed hundredths of inch;
 *                 inch: "d.dd"; mm: v*254/1000 with one decimal (rounded)
 * 04E2D6 size 72  row_baro       (sub_4E2D6) Confirmed 'b' (A550), tenths
 *                 of hPa -> whole hPa rounded (completes doc 70/83 K1a)
 * 04E32E size 100 row_humidity   (sub_4E32E) Confirmed 'h' (A54C), "00"=100%
 * 04E3A2 size 102 row_wdir_ext   (sub_4E3A2) Confirmed wind dir from ext
 * 04E418 size 88  row_wspd_ext   (sub_4E418) Confirmed wind speed from ext
 * 04E470 size 62  row_gust       (sub_4E470) Confirmed 'g' (A538)
 * 04E4AE size 92  wind_print     (sub_4E4AE) Confirmed mph or m/s (x0.4470)
 * 04E546 size 62  row_temp       (sub_4E546) Confirmed 't' (A53C)
 * 04E5A2 size 100 temp_print     (sub_4E5A2) Confirmed degF, or degC =
 *                 (F-32)*5/9 rounded; sign from FFA500.7
 * 04E6DE size 78  row_wdir_wx    (sub_4E6DE) Confirmed (A530, '_' pages)
 * 04E72C size 64  row_wspd_wx    (sub_4E72C) Confirmed (A534)
 * 04EBB0 size 86  row_wdir_cmp   (sub_4EBB0) Confirmed compressed c*4
 * 04EC06 size 102 row_wspd_cmp   (sub_4EC06) Confirmed compressed s
 * 04EC6C size 104 wind_print_kn  (sub_4EC6C) Confirmed knots -> mph x1.15
 *                 or m/s x0.5144
 * Unit bits: FF8AAC b5 rain inch, b6 wind mph, b4 temperature degF.
 * ========================================================================== */
static void lbl_unit(const void *t, u8 bit)          /* eepmov at disp_col */
{   memcpy(&disp_line[disp_col], LBL_ROW(t, (unit_bits >> bit) & 1), *(const u16 *)t); }
void rain_print(void)                                /* 04E21A */
{
    u16 v = parse_dec3();
    if (unit_bits & 0x20) {                          /* inch                 */
        disp_line[0x0F] = '0' + v / 100;             /* FFB069               */
        D = &disp_line[0x11]; fmt_2z(v % 100);       /* FFB06B               */
        return;
    }
    u8 tenth = 0; u16 mm = v;
    if (v) {
        u32 t = (u32)v * 0xFE; mm = t / 1000; u16 r = t % 1000;
        if (r) { tenth = r / 100; if (r % 100 >= 50) tenth++;
                 if (tenth >= 10) { mm++; tenth = 0; } }
    }
    disp_line[0x12] = '0' + tenth;                   /* FFB06C               */
    D = &disp_line[0x0E]; fmt_3(mm);                 /* FFB068               */
}
void row_rain_1h(void)  { lbl_unit((void *)0x4E27C, 5); if ((P = wx_slot[2])) rain_print(); }
void row_rain_24h(void) { lbl_unit((void *)0x4E29A, 5); if ((P = wx_slot[3])) rain_print(); }
void row_rain_mid(void) { lbl_unit((void *)0x4E2B8, 5); if ((P = wx_slot[4])) rain_print(); }
void row_baro(void)                                  /* 04E2D6 */
{
    PUT_LBL((const void *)0x4E31E, 0);               /* "Baro     -hPa"       */
    if (!(P = wx_slot[6])) return;
    u32 v = parse_dec4();
    if (*P++ >= '5') v++;
    fmt_u17_5(&disp_line[0x0D], v);                  /* FFB067               */
}
void row_humidity(void)                              /* 04E32E */
{
    PUT_LBL((const void *)0x4E392, 0);
    if (!(P = wx_slot[5])) return;
    disp_line[0x10] = (P[0] == '0' && P[1] == '0') ? '1' : '0';
    disp_line[0x11] = P[0]; disp_line[0x12] = P[1];
    blank_lz2(0x10);
}
void row_wdir_ext(void)                              /* 04E3A2 */
{
    PUT_LBL((const void *)0x4E408, 0);
    ext_ptr(); if (field3_absent(P)) return;
    memcpy(&disp_line[0x10], P, 3); blank_lz2(0x10);
}
void wind_print(void)                                /* 04E4AE */
{
    if (unit_bits & 0x40) { D = &disp_line[0x0F]; fmt_3(parse_dec3()); return; }
    u16 v = parse_dec3(); u8 tenth = 0; u16 ms = v;
    if (v) {
        u32 t = (u32)v * 0x1176; ms = t / 10000; u16 r = t % 10000;
        if (r) { tenth = r / 1000; if (r % 1000 >= 500) tenth++;
                 if (tenth >= 10) { ms++; tenth = 0; } }
    }
    disp_line[0x11] = '0' + tenth;                   /* FFB06B               */
    D = &disp_line[0x0D]; fmt_3(ms);                 /* FFB067               */
}
void row_wspd_ext(void)
{   lbl_unit((void *)0x4E50A, 6); ext_ptr(); P += 4; if (!field3_absent(P)) wind_print(); }
void row_gust(void)   { lbl_unit((void *)0x4E528, 6); if ((P = wx_slot[0])) wind_print(); }
void row_wdir_wx(void)
{   PUT_LBL((const void *)0x4E408, 0);
    if (!(P = wx_dir)) return; memcpy(&disp_line[0x10], P, 3); blank_lz2(0x10); }
void row_wspd_wx(void) { lbl_unit((void *)0x4E50A, 6); if ((P = wx_spd)) wind_print(); }
void temp_print(void)                                /* 04E5A2 */
{
    u16 v; u8 sign;
    if (wx_neg & 0x80) {
        v = parse_dec2(); sign = '-';
        if (unit_bits & 0x10) goto out;
        v += 0x20;                                   /* |(-v)-32|            */
    } else {
        v = parse_dec3(); sign = ' ';
        if (unit_bits & 0x10) goto out;
        if ((s16)(v -= 0x20) < 0) { v = -v; sign = '-'; }
    }
    { u32 t = (u32)v * 0x1F4; if (t) { t /= 9; v = t / 100; if (t % 100 >= 50) v++; } else v = 0; }
out:
    D = &disp_line[0x10]; fmt_3(v);                  /* FFB06A               */
    disp_line[0x0F] = sign;                          /* FFB069               */
}
void row_temp(void) { lbl_unit((void *)0x4E584, 4); if ((P = wx_slot[1])) temp_print(); }
void row_wdir_cmp(void)                              /* 04EBB0 */
{
    PUT_LBL((const void *)0x4E408, 0);
    if (cs_kind != 1) return;
    ext_ptr(); u8 c; if (!b91(P[0], &c)) return;
    D = &disp_line[0x10]; fmt_3((u16)c * 4);
}
void wind_print_kn(u16 kn)                           /* 04EC6C */
{
    if (unit_bits & 0x40) {                          /* mph                  */
        u32 t = (u32)kn * 0x73; u16 v = t / 100; if (t % 100 >= 50) v++;
        fmt_u16_4(&disp_line[0x0E], v); return;     /* FFB068               */
    }
    u8 tenth = 0; u16 ms = kn;
    if (kn) {
        u32 t = (u32)kn * 0x1418; ms = t / 10000; u16 r = t % 10000;
        if (r) { tenth = r / 1000; if (r % 1000 >= 500) tenth++;
                 if (tenth >= 10) { ms++; tenth = 0; } }
    }
    disp_line[0x11] = '0' + tenth;
    D = &disp_line[0x0D]; fmt_3(ms);
}
void row_wspd_cmp(void)                              /* 04EC06 */
{
    lbl_unit((void *)0x4E50A, 6);
    if (cs_kind != 1) return;
    ext_ptr(); u8 s; if (!b91(P[1], &s)) return;
    wind_print_kn(b91_speed_kn[s]);
}

/* ========================================================================== *
 * 04E606 size 128  wx_check_field_ext (sub_4E606) Confirmed: ext_ptr then
 *                  core 0x4E60A wx_check_field
 * 04E686 size 88   wx_check_temp      (sub_4E686) Confirmed: optional '-'
 *                  (sets FFA4FF.7), then the digit check at 0x4E63C
 * Result FFA502 (also returned in r3h): 4 end of frame, 3 letter mismatch,
 * 2 bad digits, 1 all filler (' ' or '.'), 0 n valid digits.  P is left
 * just after the letter.
 * ========================================================================== */
static u8 wx_digits(u8 n)                            /* 04E63C */
{
    wx_res = 2; u8 *q = P;
    if (q >= disp_end) return wx_res;
    u8 c0 = *q;
    if (c0 == ' ' || c0 == '.') {
        while (n--) { if (q >= disp_end || *q++ != c0) return wx_res; }
        return wx_res = 1;
    }
    while (n--) { if (q >= disp_end) return wx_res;
                  u8 c = *q++; if (c < '0' || c > '9') return wx_res; }
    return wx_res = 0;
}
u8 wx_check_field(u8 letter, u8 n, u16 off)          /* 04E60A */
{
    wx_res = 4;
    if (P >= disp_end) return wx_res;
    u16 o = off; if (ext_adj) o = (u8)(o - ext_adj);
    P += o;
    if (P >= disp_end) return wx_res;
    wx_res = 3;
    if (*P++ != letter) return wx_res;
    return wx_digits(n);
}
u8 wx_check_field_ext(u8 l, u8 n, u16 off) { ext_ptr(); return wx_check_field(l, n, off); }
u8 wx_check_temp(u8 n, u16 off)                      /* 04E686 */
{
    ext_ptr(); wx_res = 4;
    if (P >= disp_end) return wx_res;
    u16 o = off; if (ext_adj) o = (u8)(o - ext_adj);
    P += o;
    if (P >= disp_end) return wx_res;
    wx_res = 3;
    if (*P++ != 't') return wx_res;
    if (*P == '-') { wx_found |= 0x80; P++; n--; }
    else wx_found &= ~0x80;
    return wx_digits(n);
}

/* ========================================================================== *
 * Object / item pages.
 * 04ECD4 size 90  page_obj_cmp    (sub_4ECD4) Confirmed desc 0x04AE90,
 *                 symbol info[0x12]/[0x1B]
 * 04EDE6 size 40  row_obj_name    (sub_4EDE6) Confirmed 9 chars of info+1
 * 04EE0E size 44  page_item_cmp   (sub_4EE0E) Confirmed + tail 04EE3A
 * 04EE3A size 44  (tail: desc 0x04AFE0, symbol name_end[1]/[0x0A])
 * 04EF1C size 48  row_item_name   (sub_4EF1C) Confirmed up to '!' / '_'
 * 04EF4C size 6   item_name_end_cur (sub_4EF4C) Confirmed P = disp_info
 * 04EF52 size 22  item_name_end   (sub_4EF52) Confirmed P -> '!' or '_'
 *                 (<= 9 chars after the DTI)
 * ========================================================================== */
void page_obj_cmp(void)                              /* 04ECD4 */
{
    page_max = 9; page_var = 2;
    cmp_lat_cur(); cmp_lon_cur(); calc_dist_brg_539C6();
    cs_kind = cmp_cs_kind(); ext_off = 3; page_tbl = 3; page_step = 2;
    if (page_open((void *)0x4AE90)) return;
    hdr_sym_from(0x12, 0x1B);
}
void row_obj_name(void)                              /* 04EDE6 */
{
    const u8 *s = disp_info + 1; u8 *d = &disp_line[disp_col];
    for (int i = 0; i < 9; i++) *d++ = *s++ & 0x7F;
}
u8 *item_name_end(void)                              /* 04EF52 */
{
    P++;
    for (u8 n = 9; n; n--) { if (*P == '!' || *P == '_') break; P++; }
    return P;
}
u8 *item_name_end_cur(void) { P = disp_info; return item_name_end(); }
void page_item_cmp(void)                             /* 04EE0E + 04EE3A */
{
    page_max = 9; page_var = 2;
    cmp_lat_cur(); cmp_lon_cur(); calc_dist_brg_539C6();
    cs_kind = cmp_cs_kind(); ext_off = 3; page_tbl = 3;
    page_step = 2;
    if (page_open((void *)0x4AFE0)) return;
    item_name_end_cur(); hdr_sym_t = P[1]; hdr_sym_c = P[0x0A]; page_sym();
}
void row_item_name(void)                             /* 04EF1C */
{
    const u8 *s = disp_info + 1; u8 *d = &disp_line[disp_col];
    for (u8 n = 9; n; n--) { u8 c = *s++ & 0x7F; if (c == '!' || c == '_') break; *d++ = c; }
}

/* ========================================================================== *
 * Status / other / raw-data pages.
 * 04EF68 size 36  page_status     (sub_4EF68) Confirmed desc 0x04B130
 * 04EF8C size 22  page_open_blanksym (sub_4EF8C) Confirmed
 * 04EFA2 size 6   row_status_title2 (sub_4EFA2) Confirmed thunk -> 4CA8E
 * 04EFA8 size 8   status_ptr_cmp  (sub_4EFA8) Confirmed (sub_525D4)
 * 04EFB0 size 20  status_ptr      (sub_4EFB0) Confirmed skip DTI and a
 *                 "DDHHMMz" / "DDHHMM/" timestamp
 * 04EFC4 size 38  has_timestamp   (sub_4EFC4) Confirmed 0 = yes
 * 04EFEA size 24  row_status_text (sub_4EFEA) Confirmed entries r1l=0..0x3C
 * 04F002 size 42  page_other      (sub_4F002) Confirmed desc 0x04B154
 * 04F02C size 40  row_data_title  (sub_4F02C) Confirmed "[ DATA TEXT ]"
 * 04F062 size 34  row_data_text   (sub_4F062) Confirmed entries r1l=0..0x64
 * ========================================================================== */
static void page_open_blanksym(const void *desc)     /* 04EF8C */
{   if (page_open(desc)) return; hdr_sym_t = ' '; hdr_sym_c = ' '; page_sym(); }
void page_status(void)
{   page_max = 2; page_var = 0xFF; lat_flags = 0x80; lon_flags = 0x80;
    page_tbl = 1; page_open_blanksym((void *)0x4B130); }
void page_other(void)
{   page_max = 3; page_var = 0xFF; lat_flags = 0x80; lon_flags = 0x80;
    page_tbl = 1; page_open_blanksym((void *)0x4B154); }
void row_status_title2(void) { row_status_title(); }
u8 has_timestamp(void)                               /* 04EFC4 */
{
    if (P[6] != 'z' && P[6] != '/') return 1;
    return all_digits(P, 6) ? 0 : 1;
}
u8 *status_ptr(void)     { P = disp_info; P++; if (!has_timestamp()) P += 7; return P; }
u8 *status_ptr_cmp(void) { P = cmp_base;  P++; if (!has_timestamp()) P += 7; return P; }
void row_status_text(u8 w) { status_ptr(); text_window(w); }
void row_data_title(void)
{ memcpy(&disp_line[(u8)(disp_col - 5)], (const u8 *)0x4F054, 0x0D); }
void row_data_text(u8 w) { P = disp_info; text_window(w); }

/* ========================================================================== *
 * 04F084 size 136  wx_parse        (sub_4F084) Confirmed
 * 04F10C size 296  wx_field_parse  (sub_4F10C) Confirmed
 * 04F234 size 44   wx_store        (sub_4F234) Confirmed
 * Callers of wx_parse: every weather page.  Starts 7 chars into the data
 * extension (after "DDD/SSS" or the '_' header) and walks up to 10
 * fields: g(3) t(3, optional '-') r(3) p(3) P(3) h(2) b(5) and L/l/s(3,
 * skipped).  The first valid occurrence of each lettered field is stored in
 * FFA538 + 4*slot.  Stops on the first unknown letter or malformed field.
 * ========================================================================== */
static void wx_store(u8 slot /*r3l*/, u8 len /*r4h*/, u8 res /*r3h*/)
{
    ext_off += len;
    if (res == 1) return;
    if (wx_found & (1 << slot)) return;
    wx_found |= 1 << slot;
    wx_slot[slot] = P;                               /* @(-0x5AC8,slot*4)    */
}
u8 wx_field_parse(void)                              /* 04F10C */
{
    ext_ptr();
    wx_res = 4;
    if (P >= disp_end) goto out;
    { u8 o = ext_off; if (ext_adj) o -= ext_adj; P += o; }
    if (P >= disp_end) goto out;
    wx_res = 3;
    u8 c = *P++, r; u16 off = ext_off;
    P--;                       /* wx_check_* re-derive P from ext_ptr()+off */
    switch (c) {
    case 'g': if ((r = wx_check_field_ext('g', 3, off)) < 2) wx_store(0, 4, r); break;
    case 't': if ((r = wx_check_temp(3, off)) < 2) {
                  if (!(wx_found & 0x02))            /* first 't': keep sign */
                      wx_neg = (wx_neg & 0x7F) | (wx_found & 0x80);
                  wx_store(1, 4, r); }
              break;
    case 'r': if ((r = wx_check_field_ext('r', 3, off)) < 2) wx_store(2, 4, r); break;
    case 'p': if ((r = wx_check_field_ext('p', 3, off)) < 2) wx_store(3, 4, r); break;
    case 'P': if ((r = wx_check_field_ext('P', 3, off)) < 2) wx_store(4, 4, r); break;
    case 'h': if ((r = wx_check_field_ext('h', 2, off)) < 2) wx_store(5, 3, r); break;
    case 'b': if ((r = wx_check_field_ext('b', 5, off)) < 2) wx_store(6, 6, r); break;
    case 'L': case 'l': case 's':
              if (wx_check_field_ext(c, 3, off) < 2) { wx_lum = 1; ext_off += 4; }
              break;
    default:  break;                                 /* wx_res stays 3       */
    }
out:
    return wx_res;                                   /* caller: cmp #2       */
}
void wx_parse(void)                                  /* 04F084 */
{
    wx_found = 0; wx_neg = 0; wx_lum = 0;
    for (int i = 0; i < 7; i++) wx_slot[i] = 0;
    ext_off = 7;
    for (int i = 0; i < 10; i++) if (wx_field_parse() >= 2) break;
    u8 o = ext_off;
    if (wx_lum) o = 7;
    if (ext_adj) o -= ext_adj;
    ext_off = o;
}

/* ========================================================================== *
 * 04F260 size 54  wx_check_at   (sub_4F260) Confirmed (sub_502B0)
 * 04F296 size 56  (IDA split of 04F260's letter cases)
 * 04F2CE size 56  wx_digits_at  (sub_4F2CE) Confirmed
 * Same field grammar as above but on an arbitrary pointer (er6) with the
 * result in FFA503; used by the DTI classifier for compressed weather.
 * ========================================================================== */
static u8 *Q;                                        /* er6 here             */
u8 wx_digits_at(u8 n)                                /* 04F2CE */
{
    wx_res2 = 2; u8 c0 = *Q;
    if (c0 == ' ' || c0 == '.') { while (n--) if (*Q++ != c0) return wx_res2; return wx_res2 = 1; }
    while (n--) { u8 c = *Q++; if (c < '0' || c > '9') return wx_res2; }
    return wx_res2 = 0;
}
u8 wx_check_at(u8 *p)                                /* 04F260 */
{
    Q = p; wx_res2 = 3;
    switch (*Q++) {
    case 'g': case 'r': case 'p': case 'P': case 'L': case 'l': case 's':
        return wx_digits_at(3);
    case 'h': return wx_digits_at(2);
    case 'b': return wx_digits_at(5);
    case 't': if (*Q == '-') { Q++; return wx_digits_at(2); } return wx_digits_at(3);
    default:  return wx_res2;
    }
}

/* ========================================================================== *
 * 04F30A size 134  page_status_icon  (sub_4F30A) Inferred (caller 0x053200
 *                  in sub_531C8).  When the record type < 0x1A and FFA7A4
 *                  >= 0, frame cells FF3DA6='!', FF3DA8=idx, bearing cell,
 *                  sub_46CDC with FF8ABE.7 temporarily cleared, FF3DAA=idx,
 *                  FF3DA6='a'.  Else FF3DA6=' '.
 * 04F390 size 78   page_bearing      (sub_4F390) Confirmed: course from the
 *                  page's callback table 0x04F3E4[page_tbl] -> 16-point
 *                  index (r*100+1125)/2250 into FF3DA9; <0 -> 0x10 (none).
 * 04F3DE size 6    no_course         (sub_4F3DE) Confirmed returns 0xFFFF
 * ========================================================================== */
extern u8 flag_8ABE; extern void sub_46CDC(void);
extern u16 (*const course_cb[])(void);               /* 0x04F3E4 */
static u8 dir16(u16 r)
{
    if (r == 0) return 0;
    if ((s16)r < 0) return 0x10;
    if (r >= 360) return 0;
    u8 i = (u8)(((u32)r * 100 + 0x465) / 0x8CA);
    return (i < 0x10) ? i : 0;
}
void page_bearing(void)                              /* 04F390 */
{   if (!page_tbl) return; sfr_dir16 = dir16(course_cb[page_tbl]()); }
u16 no_course(void) { return 0xFFFF; }
void page_status_icon(void)                          /* 04F30A */
{
    u8 n = 0;
    if (cur_type != 0xFF && cur_type < 0x1A && (s8)status_sel_A7A4 >= 0) {
        n = 1; if (status_sel_A7A4 < 0x10) n = status_sel_A7A4 + 1;
    }
    if (!n) { sfr_sym_flags = ' '; return; }
    sfr_sym_flags = '!'; sfr_cnt8 = n - 1;
    page_bearing();
    u8 b = flag_8ABE & 0x80; flag_8ABE &= ~0x80; sub_46CDC(); flag_8ABE = (flag_8ABE & 0x7F) | b;
    sfr_cntA = n - 1; sfr_sym_flags = 'a';
}
