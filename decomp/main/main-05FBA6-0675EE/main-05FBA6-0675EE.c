/* ============================================================================
 * main-05FBA6-0675EE.c  -  Hand-reconstructed C for MAIN 0x05FBA6-0x0675EE.
 * Wave C lane main-05FBA6-0675EE.
 *
 * DOCUMENTATION ONLY.  By-hand transcription of the H8SX disassembly of
 * FT3D_MAIN_ver102_EXP.bin (big-endian, base 0, file offset == address),
 * taken from the IDA listing rebuilt by decomp/tools/build_listings.py.
 * Nothing compiled or run; no image is needed.
 *
 * Subsystem: the WIRES-X user interface (home app mode 9), the mode-10
 * group screens (GM candidate, doc 122) that share its B3EA state machine,
 * the `]` WIRES-X request builders handed to the DSP (doc 86), the node
 * answer handlers, and the message box / message editor (F6xx pages,
 * doc 103) with its SD-card record handling.
 *
 * Register conventions in this block are NOT the compiler's er0-er2 ABI:
 * most routines take arguments in er1/er5/er6/r1l/r3l and return results in
 * r3l / r4l and the Z flag (e.g. "beq" after a builder = refused).  The C
 * models those as ordinary parameters / return values.
 *
 * Helpers used everywhere:
 *   consume_key()  = sub_3FFA0 (tone 0, A9ED = 0xFF, 817E.b1 clear)
 *   reject_beep()  = sub_3FF9C (tone 0x1D, then consume)
 *   silent_ack()   = { popup_tmr (FF9599) = 0; tone_ev = 0; }
 *   dial_step(d)   = sub_3F62E, d = {u8 min, u8 max, u8 *var}, wraps,
 *                    direction A9EE.b0, returns the new value (r3l)
 *   dial_step_b092(&v) = sub_3F676 with min/max in B092/B093
 *   id5_valid(id)  = first char not 0xFF and in '0'..'y'
 *   id5_eq_blank(a,b) = 5-byte compare with 0xFF in a read as ' '
 *   copy_lenpfx(dst, src) = copy a word-length-prefixed ROM template
 * Functions named name_XXXXXX are calls out of this lane (address suffix).
 * Confidence per function: Confirmed / Inferred / Skeleton (see header).
 * ========================================================================== */

#include <stdint.h>
#include <string.h>
typedef uint8_t u8; typedef uint16_t u16; typedef uint32_t u32;
typedef int8_t s8; typedef int16_t s16;

/* ---- RAM / IO cells named in this lane (see globals.tsv) ---------------- */
extern u8 key_flags;                        /* FFA9EE  b0 DIAL direction, b7 long press */
extern u8 key_code;                         /* FFA9ED  raw key code sink (0xFF = consumed) */
extern u8 tone_ev;                          /* FFAAE0  tone mailbox; 0x1D refuse, 0x54-0x5B WIRES-X result tones */
extern u8 popup_tmr;                        /* FF9599  slow-tier popup / reply timeout (0x78 = 12 s) */
extern u8 home_app_mode;                    /* FFA9F9  home application mode (9 WIRES-X, 10 GM cand., 8) */
extern u8 node_mode;                        /* FF8DDE  <0 = WIRES-X PDN mode */
extern u8 rpt_wires_freq_mode;              /* FF8D90  RPT/WIRES FREQ 0 manual 1 preset */
extern u8 wires_dgid_8D24;                  /* FF8D24  WIRES DG-ID setting (0 = auto) */
extern u8 pdn_dgid_8ED6;                    /* FF8ED6  PDN required DG-ID (0 any) */
extern u8 pdn_dgid_8ED7;                    /* FF8ED7  PDN DG-ID */
extern u8 dsq_8DD7;                         /* FF8DD7  setting tested ==1 by GM keys (Inferred DSQ) */
extern u8 wx_cat_mode_8D8F;                 /* FF8D8F  category request format selector */
extern u8 cfg_8997;                         /* FF8997  beep-on-send setting (Inferred) */
extern u8 band_8EA0;                        /* FF8EA0  b7/b6 band display flags */
extern u8 flags_8DE0;                       /* FF8DE0  b7 node-keyed */
extern u8 tx_state;                         /* FF94C0  0 idle 1 keyed 2 blocked */
extern u8 ptt_state;                        /* FFA9EA  PTT debounce state (2 = held) */
extern u8 aad4_flags;                       /* FFAAD4  b0 msg queued, b1 request rides voice, b2/b3/b4 TX attachmen */
extern u8 band_flags_AA3D;                  /* FFAA3D  b1 band moved to DN */
extern u8 flags_AA34;                       /* FFAA34  b5 result window active */
extern u8 flags_817E;                       /* FF817E  b1 display/beep refresh request */
extern u8 flags_B0AA;                       /* FFB0AA  b7 re-send 0x12 / refresh request */
extern u8 flags_B3D9;                       /* FFB3D9  PDN flags (b0 set by sub_6D04A, b1 PTT lock) */
extern u8 dsp_msg_type;                     /* FFB0B9  DSP message type (0x0D-0x15,0x1D WIRES-X) */
extern u8 dsp_msg_body[];                   /* FF0C3D  `]` message body */
extern u8 dsp_msg_len_B1C3;                 /* FFB1C3  message length */
extern u32 dsp_msg_ptr_B1D0;                /* FFB1D0  message body pointer */
extern u8 dsp_rx_0BF8;                      /* FF0BF8  received frame byte (b3-5 tested) */
extern u8 dsp_rx_0C5B[16];                  /* FF0C5B  received name field */
extern u8 wx_state;                         /* FFB3EA  WIRES-X/GM/message UI state (doc 103 page map) */
extern u8 wx_sel;                           /* FFB3EB  selected item (latched by row renderers, 0xFF before render) */
extern u8 wx_cursor;                        /* FFB3F1  cursor position moved by DIAL */
extern u8 wx_prev_state;                    /* FFB40E  state before popup/list */
extern u8 wx_app_kind;                      /* FFB2A5  1 mode 10, 2 WIRES-X */
extern u8 wx_req_flags;                     /* FFB26B  b0 search sent, b2 name search, b4 DNEWS, b5, b6 skip poll,  */
extern u8 wx_busy;                          /* FFB26C  outstanding request bits: b0 ]c b1 ]l b2 ]# b3 ]r b4 ]f b5 ] */
extern u8 wx_flags26D;                      /* FFB26D  b1 connect by number, b7 same room */
extern u8 wx_link;                          /* FFB39F  b0 WIRES-X view, b1 page drawn, b2 VFO view, b3 ID entry, b4 */
extern u8 wx_popup;                         /* FFB2A4  popup open (key -> close) */
extern u8 wx_conn_stage[0x31];              /* FFB2C8  room block: kind/stage char ('3'+ linked), ID at +1 */
extern u8 wx_room_id[5];                    /* FFB2C9  current room ID */
extern u8 wx_room_name_B2CE[16];            /* FFB2CE  room name */
extern u8 wx_node_id[5];                    /* FFB2AA  node ID (start of 0x66-byte node record) */
extern u8 wx_target_rec[0x31];              /* FF8D9E  target record (EEPROM 0xD07E) */
extern u8 wx_target_id[5];                  /* FF8D9F  target node/room ID */
extern u8 wx_req_id[10];                    /* FFB314  request ID + suffix */
extern u8 wx_pend_id[5];                    /* FFB349  ID asked for in last connect */
extern u8 wx_list_req[0x15];                /* FFB334  `]f` request block (kind, "nnn" start, text) */
extern u8 wx_open_rec[0x31];                /* FFB34E  opened list record */
extern u16 wx_list_total;                   /* FF1044  total list entries */
extern u16 wx_list_top;                     /* FF1046  first index of page (1-based) */
extern u16 wx_list_prev_top;                /* FF1048  previous page top */
extern u8 wx_list_rows[n*0x32];             /* FF104C  list page rows */
extern u8 wx_page;                          /* FFB269  page counter */
extern u8 wx_rows;                          /* FFB26A  rows on page */
extern u8 wx_sel_row;                       /* FFB2A2  row selected for connect */
extern u8 wx_saved_pos[4];                  /* FFB27B  saved list position */
extern u8 wx_menu_origin;                   /* FFB26E  return mode 0/1/2 */
extern u8 wx_menu6_sel;                     /* FFB27F  search menu selection */
extern u8 wx_menu12_sel;                    /* FFB280  state 0x12 selection */
extern u8 wx_menu13_sel;                    /* FFB281  state 0x13 selection */
extern u8 wx_menu2B_sel;                    /* FFB282  state 0x2B selection */
extern u8 wx_cat_bank;                      /* FFB270  category bank index */
extern u8 wx_cat_count;                     /* FFB272  used entries in category */
extern u8 wx_cat_open;                      /* FFB3F3  category opened */
extern u8 wx_cat_item;                      /* FFB3F4  category item / bank */
extern u8 wx_cat_cursor;                    /* FFB3F5  category entry cursor */
extern u8 wx_cat_list[0x300];               /* FFB5B8  category list (20x0x18) / GM members (24x0x20) */
extern u8 wx_settings_AE22[0x50];           /* FFAE22  category names (5x16) from EEPROM 0x1E000 */
extern u8 wx_text_buf[80];                  /* FF061A  text / message editor buffer */
extern u8 ram_FF0618;                       /* FF0618  text length */
extern u8 ram_FF0619;                       /* FF0619  text line count */
extern u8 edit_cursor;                      /* FFAD99  text edit cursor */
extern u8 wx_AD9A;                          /* FFAD9A  pending edit cursor (0xFF none) */
extern u8 wx_id_cursor;                     /* FFB3A0  ID entry cursor (1-based) */
extern u8 wx_id_char_save;                  /* FFB3A1  char before dial */
extern u8 wx_id_entry_m1[7];                /* FFB3A2  ID entry buffer (chars at +1..+5) */
extern u16 wx_search_tmr;                   /* FF95E4  search timeout (slow tier) */
extern u16 wx_tx_tmr_95E6;                  /* FF95E6  upload TX 60 s timer */
extern u8 hold_tmr_959B;                    /* FF959B  3.5 s hold-PTT timer */
extern u8 tmr_959A;                         /* FF959A  state 0x3C timer */
extern u8 tmr_959C;                         /* FF959C  0.7 s timer */
extern u8 tmr_9538;                         /* FF9538  2.5 s fast-tier result timer */
extern u8 tmr_9567;                         /* FF9567  message busy-indicator timer */
extern u8 popup_id;                         /* FFBBE1  popup id for SUB */
extern u8 sub_popup_sent;                   /* FF3D87  popup id last sent */
extern u16 frame_len_saved;                 /* FF4174  frame length for re-send */
extern u16 sub_frame_len;                   /* FF3D72  frame length to SUB */
extern u8 sub_frame[];                      /* FF3DE0  page frame payload to SUB */
extern u8 touch_reject;                     /* FFBBEA  touch probe result (1 reject) */
extern u8 disp_flags_BC59;                  /* FFBC59  b6/b7 redraw flags */
extern u8 line_buf_B05A[0x17];              /* FFB05A  text line buffer */
extern u32 draw_attr_B050;                  /* FFB050  draw attributes */
extern u8 line_len_BBE8;                    /* FFBBE8  line width */
extern u32 list_dst_BC2C;                   /* FFBC2C  list output pointer */
extern u32 row_cb_B288;                     /* FFB288  row callback */
extern u8 list_sel_BBFB;                    /* FFBBFB  list selected row */
extern u8 wx_B311;                          /* FFB311  node answer code (0 none) */
extern u8 wx_B312;                          /* FFB312  tone for send beep */
extern u8 wx_B324[5];                       /* FFB324  item key */
extern u8 wx_B329[5];                       /* FFB329  saved item key */
extern u8 wx_B32E[5];                       /* FFB32E  alternate key */
extern u8 wx_B31E[5];                       /* FFB31E  news item key */
extern u8 wx_B299[9];                       /* FFB299  `]l` argument */
extern u16 wx_B296;                         /* FFB296  list count shown "[nnn]" */
extern u8 wx_B2A7;                          /* FFB2A7  use target instead of room (Inferred) */
extern u8 pdn_state;                        /* FFB3E4  PDN state (4 = ready) */
extern u8 pdn_B3E7;                         /* FFB3E7  PDN flag */
extern u8 wx_B12F;                          /* FFB12F  search sent */
extern u8 wx_addr_mode;                     /* FFB130  0 preset freq, 1 DG-ID, 2 auto */
extern u8 wx_addr_dgid;                     /* FFB131  DG-ID used */
extern u8 wx_B132;                          /* FFB132  WIRES-X request in voice TX */
extern u8 wx_rx_letter;                     /* FFB267  received node message letter */
extern u8 wx_B3FA;                          /* FFB3FA  PDN/GM rx pending */
extern u8 wx_sent_state;                    /* FFB273  state at send */
extern u8 wx_B266;                          /* FFB266  misc flags b1-b3, b7 */
extern u8 wx_B275;                          /* FFB275  b4 timeout tone done, b5 */
extern u8 wx_B3EF;                          /* FFB3EF  GM member count / beacon index */
extern s8 wx_B95E;                          /* FFB95E  TX-end countdown */
extern u8 wx_hold_ret_state;                /* FFBC5B  state before hold */
extern u8 gm_group;                         /* FFB3EC  GM group index */
extern u8 gm_n_groups;                      /* FFB3EE  group count */
extern u8 gm_name_B4A8[0x110];              /* FFB4A8  group names (17x16) */
extern u8 gm_n_sel;                         /* FFB414  selected members */
extern u8 gm_B420;                          /* FFB420  GM flags b0 VFO view, b1 */
extern u8 gm_B963;                          /* FFB963  b0 alt table set */
extern u8 gm_row_map_B8C0[];                /* FFB8C0  row -> member map */
extern u16 gm_msg_B928;                     /* FFB928  message paging */
extern u8 gm_msg_B92A;                      /* FFB92A  last message index (0xFF none) */
extern u8 msg_slot_B92B;                    /* FFB92B  open message slot */
extern u8 msg_ret_B92C;                     /* FFB92C  return state of confirm */
extern u8 gm_folder_B92D;                   /* FFB92D  message folder 0/1/2 */
extern u8 msg_saved_sel;                    /* FFB961  saved list sel */
extern u8 msg_saved_cur;                    /* FFB962  saved list cursor */
extern u8 msg_store_FEEF20[20*0x80];        /* FEEF20  message records page */
extern u8 msg_cur[0x80];                    /* FF2FCA  open message record */
extern u8 msg_prev_2F4A[0x80];              /* FF2F4A  copy of record */
extern u8 msg_text_300A[16];                /* FF300A  message name field */
extern u32 msg_file_size_301A;              /* FF301A  attachment size */
extern u8 msg_file_name_301E[16];           /* FF301E  attachment file name */
extern u8 msg_text_074E[80];                /* FF074E  message text */
extern u8 msg_text_509E[80];                /* FF509E  text from SD */
extern u8 sd_job_BAA3;                      /* FFBAA3  pending SD job code */
extern u8 msg_flags_BA93;                   /* FFBA93  b6 busy */
extern u8 msg_B41D;                         /* FFB41D  editor purpose 1 reply 2 fwd 3 view */
extern u8 msg_ret_B40F;                     /* FFB40F  editor return state */
extern u8 msg_ret_B410;                     /* FFB410  forward return state */
extern u8 ed_pos_B283[3];                   /* FFB283  saved editor pos */
extern u8 wx_B286;                          /* FFB286  secondary cursor */
extern u8 edit_mode_BBED;                   /* FFBBED  editor mode */
extern u8 news_index_FEFDC8[n*0x2F];        /* FEFDC8  news index records */
extern u8 pos_flag_A856;                    /* FFA856  node position valid */
extern u8 pos_A857[15];                     /* FFA857  node position */
extern u8 pos_A866[12];                     /* FFA866  node position 2 */
extern u8 ram_BA32;                         /* FFBA32  gate for msg box */
extern u8 wx_B324_bytes[5];                /* FFB324  alias of wx_B324 as bytes */

/* ==========================================================================
 * Part 1: 05FBA6-06105A  WIRES-X entry/exit, the DIAL and key-7 state
 * dispatchers, the SEARCH & DIRECT / list request touch handlers.
 * ========================================================================== */

/* ---------------------------------------------------------------------------
 * 05FBA6-05FBE4 (62 B)  parse_dec3  [sub_5FBA6]  Confirmed
 * Callers: no absolute or table reference found (reached from code below
 * 05FBA6, outside this lane).
 * Parses three ASCII digits at *er5 (post-incrementing er5) into
 * d0*100 + d1*10 + d2.  Any non-digit, or a zero result, returns r3l = 0.
 * Private convention: input er5, result r3 (word, r3l tested by callers).
 * ------------------------------------------------------------------------- */
u16 parse_dec3(const u8 **pp /* er5 */)                 /* 05FBA6 */
{
    u8 c; u16 v;
    c = *(*pp)++; if (c < '0' || c > '9') return 0;     /* 05FBA8..05FBAE */
    v = (u16)(c - '0') * 100;                           /* 05FBB6 mulxu.b */
    c = *(*pp)++; if (c < '0' || c > '9') return 0;     /* 05FBBA..05FBC0 */
    v += (u16)(c - '0') * 10;                           /* 05FBC8/05FBCA  */
    c = *(*pp)++; if (c < '0' || c > '9') return 0;     /* 05FBCE..05FBD4 */
    v += (u16)(c - '0');                                /* 05FBDC          */
    return v;                     /* 05FBDE: bne rts / 05FBE0: r3l=0 if 0 */
}

/* ---------------------------------------------------------------------------
 * 05FC0E-05FD1C (270 B)  wx_enter  [sub_5FC0E]  Confirmed
 * Callers: 01C9E8 region (home key 6 short press, jsr at 0x01CA80; doc 103),
 *          and the internal label 05FC82 (wx_enter_common) from wx_key6 and
 *          the PDN path.
 * The X-key entry into WIRES-X (home app mode 9).  Loads the 0x50-byte
 * WIRES-X settings block from EEPROM, chooses how the node is addressed
 * (preset RPT/WIRES frequency, a DG-ID, or auto), resets the session, and
 * either arms the 2.8 s "moved to DN, search later" timer (doc 86 T6) or
 * sends the `]q` search request now.  On success: wx_state=1,
 * wx_app_kind=2, home_app_mode=9.  Any refusal plays tone 0x1D.
 * ------------------------------------------------------------------------- */
void wx_enter(void)                                      /* 05FC0E */
{
    load_wx_settings_3DD14();          /* EEPROM 0x1E000 -> FFAE22, 0x50 B  */

    if (!(node_mode & 0x80) && rpt_wires_freq_mode == 1) {   /* 05FC12/18: PRESET */
        if (tune_wires_preset_259B2()) goto refuse;     /* 05FC20: bne refuse */
        wx_addr_mode = 0;                               /* 05FC28: by freq    */
        goto common;
    }
    if (node_mode & 0x80) {                             /* 05FC30: PDN         */
        flags_B3D9 &= ~0x01;                            /* 05FC36              */
        if (!(flags_8DE0 & 0x80)) {                     /* 05FC3C              */
            u8 want = pdn_dgid_8ED6;                    /* 05FC44              */
            if (want != 0 && want != pdn_dgid_8ED7) goto refuse; /* 05FC50     */
        }
        wx_addr_mode = 1; wx_addr_dgid = pdn_dgid_8ED7; /* 05FC56..05FC60      */
    } else if (wires_dgid_8D24 != 0) {                  /* 05FC66              */
        wx_addr_mode = 1; wx_addr_dgid = wires_dgid_8D24; /* 05FC6C..05FC76    */
    } else {
        wx_addr_mode = 2;                               /* 05FC7C: auto        */
    }
common:                                                 /* 05FC82 (sub_5FC82)  */
    wx_AD9A = 0xFF;
    wx_req_flags = 0;                                   /* B26B                */
    wx_B26F = 0;
    wx_conn_stage = '0';                                /* B2C8                */
    wx_B329 = 0;
    wx_B3EF = 0;
    wx_session_reset();                                 /* 05FCA6 bsr 5FD1C    */
    wx_B2C7 = '0';
    wx_state = 0;
    wx_req_flags &= ~0x80;                              /* 05FCB4              */
    if (band_flags_AA3D & 0x02) {                       /* 05FCBA: band moved to DN */
        aad4_flags &= ~0x01;                            /* 05FCC2              */
        if (tx_state == 1) goto refuse;                 /* 05FCC8: keyed       */
        if (!dn_link_ready_22F60()) goto refuse;        /* 05FCD0: Z -> refuse */
        wx_req_flags |= 0x80 | 0x01;                    /* 05FCD6/05FCDC       */
        wx_search_tmr = 0x1C;                           /* 05FCE2: 2.8 s slow tier */
    } else {
        if (!wx_send_search_q())  goto refuse;          /* 05FCEC sub_62DA4    */
        wx_req_flags |= 0x01;                           /* 05FCF2              */
        wx_search_tmr = 0x12C;                          /* 05FCF8: 30 s        */
    }
    wx_state = 1;  wx_app_kind = 2;  home_app_mode = 9; /* 05FD00..05FD0E      */
    return;
refuse:
    tone_ev = 0x1D;                                     /* 05FD14              */
}

/* ---------------------------------------------------------------------------
 * 05FD1C-05FD2C (16 B)  wx_session_reset  [sub_5FD1C]  Confirmed
 * 05FD2C-05FDA6 (122 B) wx_session_reset_tail  [sub_5FD2C]  Confirmed
 * Callers: wx_enter (05FCA6), 06363C; 05FD2C also from 0638C6.
 * 5FD1C has no rts: it clears the 5-byte key B324..B328 and falls into
 * 5FD2C, which clears the per-session WIRES-X UI cells and resets the
 * "connected" text fields (FF8DB4..6 = "00 ").
 * ------------------------------------------------------------------------- */
void wx_session_reset(void)                              /* 05FD1C */
{
    wx_B324 = 0; wx_B328 = 0;                           /* dword + byte        */
    /* falls through */
    wx_session_reset_tail();
}
void wx_session_reset_tail(void)                         /* 05FD2C */
{
    wx_list_req[0] = 0x80;                              /* B334: request kind  */
    wx_B266 = 0; wx_busy = 0; wx_flags26D = 0;          /* B266, B26C, B26D    */
    wx_link = 0;                                        /* B39F                */
    wx_B267 = 0; wx_B3FA = 0; wx_B2A6 = 0; wx_B2A7 = 0;
    wx_B2A3 = 0; wx_popup = 0; wx_B311 = 0;             /* B2A4 = popup        */
    wx_req_flags &= ~0x30;                              /* 05FD6E/74 b4,b5     */
    wx_text_8DB4[0] = '0'; wx_text_8DB4[1] = '0'; wx_text_8DB4[2] = ' ';
    wx_B275 = 0; wx_B265 = 0;
    wx_sel = 0; wx_cursor = 0;                  /* B3EB, B3F1          */
    wx_misc_reset_617D4();                              /* 05FDA0              */
}

/* ---------------------------------------------------------------------------
 * 05FDA6-05FDAE (8 B)   wx_key6  [sub_5FDA6]  Confirmed
 * 05FDAE-05FE38 (138 B) wx_exit  [sub_5FDAE]  Confirmed
 * Callers: key table #11 slot 6 (0x0113A0) -> 5FDA6; 063216 -> 5FDAE.
 * Key 6 (the X key) while in WIRES-X.  Long press (A9EE.b7) leaves WIRES-X:
 * clears the session state, app mode 0, sets B0AA.b7 (the "re-send 0x12"
 * flag, doc 86) .  Short press: popup -> close it; B39F.b3 -> the content
 * browser key (sub_66428); B39F.b2 -> ignore; in state 1 re-run the search
 * (PDN: sub_6D0B6); otherwise sub_66428.
 * ------------------------------------------------------------------------- */
void wx_key6(void)                                       /* 05FDA6 */
{
    if (!(key_flags & 0x80)) goto short_press;          /* 05FDA6 -> 05FDF6    */
    /* falls into wx_exit */
    wx_exit();
    return;
short_press:                                            /* 05FDF6              */
    if (wx_popup)              { wx_popup_close_62112(); return; }
    if (wx_link & 0x08)        { wx_content_key_66428(); return; }
    if (wx_link & 0x04)        { consume_key();       return; }
    if (wx_state != 1)         { wx_content_key_66428(); return; }
    if (node_mode & 0x80)        pdn_research_6D0B6();  /* 05FE20              */
    else                         wx_enter_common();     /* 05FE26: 05FC82      */
}
void wx_exit(void)                                       /* 05FDAE */
{
    if (node_mode & 0x80) pdn_state = 0;                /* 05FDAE: B3E4        */
    wx_req_flags = 0; wx_link = 0; wx_B265 = 0;
    wx_B12F = 0; wx_state = 0; wx_B132 = 0;
    ui_9D3F = 3;
    wx_app_kind = 0; home_app_mode = 0;                 /* 05FDE2..05FDEA      */
    flags_B0AA |= 0x80;                                 /* 05FDEE              */
}

/* ---------------------------------------------------------------------------
 * 05FE38-05FEA2 (106 B)  wx_dial  [sub_5FE38]  Confirmed
 * Callers: key table #11 slot 13 (0x0113BC) = DIAL step (doc 123).
 * DIAL in WIRES-X.  Popup -> close; B39F.b3 -> text-entry dial (state
 * table, below); B39F.b2 -> consume.  Otherwise dial_min (B092)=0 and
 * dispatch on wx_state through off_5FEA2[69] (states 0..0x44).  The case
 * at 05FE76 (B39F.b3 path) steps the ID-entry character at
 * B3A2[B3A0] through the character set byte_601B0.
 * Table: 4->5FFB6, 6->6001E, 7->6003A, 9->600A4, 0xA->600D2, 0xB->60074,
 *   0x10->600E0, 0x11->6011A, 0x12->60146, 0x13->6016E, 0x14..0x44 -> the
 *   content-browser dial handlers 063F4A..06430C, others -> 60186 (consume).
 * dial_step(desc) is sub_3F62E: desc = {min,max,&var}, wraps; A9EE.b0 is
 * the direction.  dial_step_b092(&var) is sub_3F676 with min/max in
 * B092/B093.
 * ------------------------------------------------------------------------- */
void wx_dial(void)                                       /* 05FE38 */
{
    if (wx_popup)              { wx_popup_close_62112(); return; }  /* 05FE3A */
    if (wx_link & 0x08)        goto id_entry;           /* 05FE48 -> 05FE76    */
    if (wx_link & 0x04)        { consume_key(); return; }
    dial_min = 0;                                       /* 05FE5A B092         */
    off_5FEA2[wx_state]();                              /* 05FE60..05FE74      */
    return;
id_entry:                                               /* 05FE76              */
    if (wx_busy & 0x04)        { consume_key(); return; }
    {
        u8 i = wx_id_cursor;                            /* B3A0                */
        wx_id_char_save = wx_id_entry_m1[i];            /* @(-0x4C5E,er2) = FFB3A2-1+i */
        wx_id_entry_m1[i] = dial_step(&byte_601B0);     /* char-set descriptor */
    }
}

/* ---------------------------------------------------------------------------
 * 05FFB6-060002 (76 B)  wx_dial_s4  [sub_5FFB6]  Confirmed
 * 060002-06001E (28 B)  wx_dial_s4_tail  [sub_60002]  Confirmed
 * Callers: off_5FEA2[4].
 * DIAL in state 4 (the "connected" screen).  Busy bits 0/2/6 -> consume.
 * Compares the current target ID FF8D9F[5] (0xFF counts as ' ') with the
 * room ID B2C9[5].  If the target is invalid (not '0'..'y') or equal to the
 * room, B2A7 = 0 and the key is consumed; otherwise the dial steps the
 * selector described at byte_6018C (Inferred: B2A7, "use target").
 * IDA split this routine at 060002 (the loop's bne); one body.
 * ------------------------------------------------------------------------- */
void wx_dial_s4(void)                                    /* 05FFB6 */
{
    if (wx_busy & 0x45) { consume_key(); return; }      /* b0, b2, b6          */
    if (!id5_valid(wx_target_id) ||                     /* 05FFD4..05FFE2      */
        id5_eq_blank(wx_target_id, wx_room_id)) {       /* 05FFE4..060004      */
        wx_B2A7 = 0;                                    /* 060006              */
        consume_key(); return;                          /* 06000C: Z -> 60186  */
    }
    dial_step(&byte_6018C);    /* 060010: target differs from room: toggle
                                  the room/target selector (B2A7, Inferred) */
}

/* ---------------------------------------------------------------------------
 * 06001E-06003A (28 B)  wx_dial_s6  [sub_6001E]  Confirmed
 * State 6 (search menu, three items): steps B27F through desc 060192.
 * ------------------------------------------------------------------------- */
void wx_dial_s6(void)                                    /* 06001E */
{
    if (wx_busy & 0x01) { consume_key(); return; }
    wx_menu6_sel = dial_step(&byte_60192);              /* B27F                */
}

/* ---------------------------------------------------------------------------
 * 06003A-060074 (58 B)  wx_dial_s7  [sub_6003A]  Confirmed
 * 060074-0600A4 (48 B)  wx_dial_sB  [sub_60074]  Confirmed
 * 0600E0-06011A (58 B)  wx_dial_s10 [sub_600E0]  Confirmed
 * List states (7 = list, 0xB = list B, 0x10 = list C): moves the list
 * cursor B3F1 within 0..B26A-1 (B26A = rows on the page).  Each first
 * tests its own set of busy bits.
 * ------------------------------------------------------------------------- */
static void wx_dial_list(u8 busy_mask)
{
    if (wx_busy & busy_mask) { consume_key(); return; }
    if (wx_rows == 0)        { consume_key(); return; } /* B26A                */
    dial_max = wx_rows - 1;                             /* B093                */
    dial_step_b092(&wx_cursor);                    /* B3F1                */
}
void wx_dial_s7(void)  { wx_dial_list(0x54); }           /* 06003A: b2,b6,b4 */
void wx_dial_sB(void)  { wx_dial_list(0x11); }           /* 060074: b0,b4    */
void wx_dial_s10(void) { wx_dial_list(0x64); }           /* 0600E0: b5,b2,b6 */

/* ---------------------------------------------------------------------------
 * 0600A4-0600D2 (46 B)  wx_dial_s9  [sub_600A4]  Confirmed
 * State 9 (text entry, 16 chars at FF061A): steps the character at the
 * edit cursor AD99 (sub_5E160, limit 0x0F).
 * ------------------------------------------------------------------------- */
void wx_dial_s9(void)                                    /* 0600A4 */
{
    if (wx_busy & 0x14) { consume_key(); return; }      /* b2, b4              */
    text_dial_char_5E160(wx_text_buf /*FF061A*/, edit_cursor /*AD99*/, 0x0F);
}

/* ---------------------------------------------------------------------------
 * 0600D2-0600E0 (14 B)  wx_dial_sA  [sub_600D2]  Confirmed
 * State 0xA: steps the selector at desc 060198 (no gate).
 * ------------------------------------------------------------------------- */
void wx_dial_sA(void) { dial_step(&byte_60198); }        /* 0600D2 */

/* ---------------------------------------------------------------------------
 * 06011A-060146 (44 B)  wx_dial_s11  [sub_6011A]  Confirmed
 * State 0x11 (category screen).  If a category is open (B3F3 != 0) moves
 * the entry cursor B3F5 within 0..B272-1 (B272 = used entries); with no
 * entries the key goes to 06422C.  Otherwise steps the category selector
 * (desc 06019E).
 * ------------------------------------------------------------------------- */
void wx_dial_s11(void)                                   /* 06011A */
{
    if (wx_cat_open) {                                  /* B3F3                */
        if (wx_cat_count == 0) { wx_dial_63F4A_tail_6422C(); return; }
        dial_max = wx_cat_count - 1;
        dial_step_b092(&wx_cat_cursor);                 /* B3F5                */
    } else {
        dial_step(&byte_6019E);
    }
}

/* ---------------------------------------------------------------------------
 * 060146-06015E (24 B)  wx_dial_s12  [sub_60146]  Confirmed
 * 06015E-06018C (46 B)  wx_dial_s13_common  [sub_6015E]  Confirmed
 * State 0x12: B280 = dial_step(060A4).  06015E (also reached from the
 * content-browser table slot 0x2B) steps B282 via the same descriptor;
 * 06016E (state 0x13) steps B281 via desc 0601AA.  060186/06018A is the
 * shared "consume_key(); return" tail every handler above branches to.
 * ------------------------------------------------------------------------- */
void wx_dial_s12(void)                                   /* 060146 */
{
    if (wx_busy & 0x01) { consume_key(); return; }
    wx_menu12_sel = dial_step(&byte_601A4);             /* B280                */
}
void wx_dial_s2B(void)                                   /* 06015E */
{
    wx_menu2B_sel = dial_step(&byte_601A4);             /* B282                */
}
void wx_dial_s13(void)                                   /* 06016E */
{
    if (wx_busy & 0x01) { consume_key(); return; }
    wx_menu13_sel = dial_step(&byte_601AA);             /* B281                */
}

/* ---------------------------------------------------------------------------
 * 0601B6-0601F4 (62 B)  wx_key7  [sub_601B6]  Confirmed
 * Callers: key table #11 slot 7 (0x0113A4).
 * Key 7 (the "select/enter" role in every WIRES-X screen).  Popup -> close;
 * B39F.b3 -> ID-entry enter (sub_60A9E); B39F.b2 -> consume; otherwise
 * off_601F4[wx_state]: 0,1,5,8 -> reject beep (60308), 2 -> 60334,
 * 3 -> 604BC, 4 -> 60522, 6 -> 60614, 7 -> 6087E, 9 -> 60A4A, 0xA -> 60ADA,
 * 0xB -> 60B98, 0x10 -> 60D30, 0x11 -> 60E08, 0x12 -> 60E5E,
 * 0x13 -> 60F4A, 0x14.. -> the content-browser handlers (658B6...).
 * ------------------------------------------------------------------------- */
void wx_key7(void)                                       /* 0601B6 */
{
    if (wx_popup)          { wx_popup_close_62112(); return; }
    if (wx_link & 0x08)    { wx_id_entry_enter(); return; }  /* 0601E8 sub_60A9E */
    if (wx_link & 0x04)    { consume_key(); return; }
    off_601F4[wx_state]();
}

/* 060308-06030E (6 B)  wx_reject  [sub_60308]  Confirmed:
 * off_601F4[0,1,5,8]: reject beep (sub_3FF9C: tone 0x1D + consume).      */
void wx_reject(void) { reject_beep(); }                  /* 060308 */

/* ---------------------------------------------------------------------------
 * 06030E-060334 (38 B)  wx_touch_s2_probe  [sub_6030E]  Confirmed
 * 060334-060354 (32 B)  wx_key7_s2  [sub_60334]  Confirmed
 * 060354-06038C (56 B)  wx_connect_target  [sub_60354]  Confirmed
 * 06038C-0603A8 (28 B)  wx_goto_search_menu  [sub_6038C]  Confirmed
 * Callers: 02AEE4 (touch F800 probe) -> 6030E; off_601F4[2] -> 60334;
 *          060554 -> 60354; 02AEFA[] (doc 103: F800) and 60334 -> 6038C.
 * State 2 = "SEARCH & DIRECT" (F800).  The touch probe sets the
 * touch-reject flag BBEA, then clears it if the screen would accept the
 * key (no busy b2/b6 and link b0 set).  Key 7 short press reconnects to
 * the last target (wx_connect_target); long press opens the search menu
 * (state 6 with B26E = 2).  wx_connect_target refreshes the target ID
 * (sub_603E0: blank or own ID -> replace with "-----"/FF), builds the
 * 10-byte request B314 = target[5] + ROM 067FA4[5], and sends `]#`
 * (sub_62E14).  Refusal -> consume.  Busy b2/b6 -> silent (FF9599=0,
 * tone 0) at 060396.
 * ------------------------------------------------------------------------- */
void wx_touch_s2_probe(void)                             /* 06030E */
{
    touch_reject = 1;                                   /* BBEA                */
    if (wx_busy & 0x44) { silent_ack(); return; }       /* 060396              */
    if (!(wx_link & 0x01)) { consume_key(); return; }   /* 0603A2              */
    touch_reject = 0;
}
void wx_key7_s2(void)                                    /* 060334 */
{
    if (wx_busy & 0x44)     { silent_ack(); return; }
    if (!(wx_link & 0x01))  { consume_key(); return; }
    if (key_flags & 0x80)   { wx_goto_search_menu(); return; }   /* 06038C */
    wx_connect_target();                                /* falls into 060354   */
}
void wx_connect_target(void)                             /* 060354 */
{
    if (wx_check_target_id())  return;                  /* 060354: nz = beeped */
    memcpy(wx_req_id, wx_target_id, 5);                 /* 06035A eepmov       */
    memcpy(wx_req_id + 5, rom_67FA4, 5);                /* 060372              */
    if (!wx_send_connect_hash())  consume_key();        /* 060384 sub_62E14    */
}
void wx_goto_search_menu(void)                           /* 06038C */
{
    wx_menu_origin = 2;                                 /* B26E                */
    wx_enter_search_menu();                             /* bsr 603A8           */
}

/* ---------------------------------------------------------------------------
 * 0603A8-0603AE (6 B)   wx_enter_search_menu  [sub_603A8]  Confirmed
 * 0603AE-0603C8 (26 B)  wx_enter_search_menu_keep  [sub_603AE]  Confirmed
 * State 6 (the SEARCH menu): cursor = B27F (603A8 first resets it to 0).
 * ------------------------------------------------------------------------- */
void wx_enter_search_menu(void) { wx_menu6_sel = 0; wx_enter_search_menu_keep(); }
void wx_enter_search_menu_keep(void)                     /* 0603AE */
{
    wx_sel = wx_cursor = wx_menu6_sel;          /* B3EB, B3F1          */
    wx_busy &= ~0x01;
    wx_state = 6;
}

/* ---------------------------------------------------------------------------
 * 0603C8-0603CE (6 B)   wx_set_linked_goto2  [sub_603C8]  Confirmed
 * 0603CE-0603E0 (18 B)  wx_goto_state2  [sub_603CE]  Confirmed
 * Callers: 06345E, 06363C (603C8); 06081C, 0620E2 (603CE).
 * 603C8 sets B39F.b0 ("link up") and falls into 603CE: clear busy and
 * flags26D, wx_state = 2 (SEARCH & DIRECT).
 * ------------------------------------------------------------------------- */
void wx_set_linked_goto2(void) { wx_link |= 0x01; wx_goto_state2(); }
void wx_goto_state2(void)                                /* 0603CE */
{
    wx_busy = 0; wx_flags26D = 0;
    wx_state = 2;
}

/* ---------------------------------------------------------------------------
 * 0603E0-06044E (110 B)  wx_check_target_id  [sub_603E0]  Confirmed
 * 06044E-0604BC (110 B)  wx_check_room_id    [sub_6044E]  Confirmed
 * Callers: 060354, 0611D4 (603E0); 061252, 06127A (6044E).
 * Validates a 5-char WIRES-X ID (FF8D9F, resp. B2C9).  Returns 0 when the
 * ID is usable.  First char 0xFF, or the ID equal to B2AA (Inferred: the
 * ID this radio is already linked to / own ID), -> reject beep, return 1.
 * First char outside '0'..'y', or the ID "DNEWS" (ROM 067FB0, the news
 * pseudo-room), -> the ID is blanked with ROM 067FAA (5 x 0xFF) and
 * rejected.  So a stale "DNEWS" target can never be connected as a node.
 * ------------------------------------------------------------------------- */
static u8 wx_check_id(u8 *id)
{
    if (id[0] == 0xFF)                          goto reject; /* 0603E8         */
    if (id[0] < '0' || id[0] >= 'z')            goto blank;  /* 0603EC/0603F0  */
    if (memcmp(id, wx_own_id /*B2AA*/, 5) == 0) goto reject; /* 0603F4..06040A */
    if (memcmp(id, "DNEWS", 5) == 0)            goto blank;  /* 06040C..060428 */
    return 0;                                   /* 06042A: r4l = 0, accept     */
blank:
    memcpy(id, rom_67FAA_blank, 5);             /* 06042E: 5 x 0xFF            */
reject:
    reject_beep();                              /* 060446: tone 0x1D           */
    return 1;                                   /* 06044A: r4l = 1             */
}
u8 wx_check_target_id(void) { return wx_check_id(wx_target_id); }  /* 0603E0 */
u8 wx_check_room_id(void)   { return wx_check_id(wx_room_id);   }  /* 06044E */

/* ---------------------------------------------------------------------------
 * 0604BC-0604CE (18 B)  wx_key7_s3  [sub_604BC]  Confirmed
 * 0604CE-0604DA (12 B)  wx_set_linked_goto4  [sub_604CE]  Confirmed
 * 0604DA-0604EC (18 B)  wx_goto_state4  [sub_604DA]  Confirmed
 * Callers: off_601F4[3]; 0604BC/063768/0638C6 (604CE); 06081C/0624CA (604DA)
 * State 3 short press -> link up, B2A7 = 0, wx_state = 4 (connected).
 * ------------------------------------------------------------------------- */
void wx_key7_s3(void)
{
    if (key_flags & 0x80) { consume_key(); return; }
    wx_set_linked_goto4();
}
void wx_set_linked_goto4(void) { wx_link |= 0x01; wx_B2A7 = 0; wx_goto_state4(); }
void wx_goto_state4(void)                                /* 0604DA */
{
    wx_busy = 0; wx_flags26D = 0;
    wx_state = 4;
}

/* ---------------------------------------------------------------------------
 * 0604EC-060522 (54 B)  wx_touch_s4_probe  [sub_604EC]  Confirmed
 * 060522-060554 (50 B)  wx_key7_s4  [sub_60522]  Confirmed
 * 060554-0605D8 (132 B) wx_connect_or_room  [sub_60554]  Confirmed
 * 0605D8-0605F6 (30 B)  wx_goto_search_menu_s4  [sub_605D8]  Confirmed
 * Callers: 02AF06 (touch probe); off_601F4[4]; 02AF38 (60554);
 *          02AF2C, 02AF38, 060522 (605D8).
 * State 4 (connected to a node).  Probe: busy b0/b2/b6 -> silent, link b0
 * clear -> consume, else accept.  Key 7: long press -> search menu (state
 * 6, B26E = 2).  Short: if the target ID is valid and equals the current
 * room B2C9, and B2A7 is set, reconnect via wx_connect_target; otherwise
 * build B314 = room B2C9 + 067FA4 and send `]c` (sub_62ACA, room
 * connect).  0605C6 (B26E = 1, then sub_646C2) is a tail used by the
 * touch table.
 * ------------------------------------------------------------------------- */
void wx_touch_s4_probe(void)                             /* 0604EC */
{
    touch_reject = 1;
    if (wx_busy & 0x45)   { silent_ack(); return; }     /* 0605E4              */
    if (!(wx_link & 0x01)){ consume_key(); return; }    /* 0605F0              */
    touch_reject = 0;
}
void wx_key7_s4(void)                                    /* 060522 */
{
    if (wx_busy & 0x45)   { silent_ack(); return; }
    if (!(wx_link & 0x01)){ consume_key(); return; }
    if (key_flags & 0x80) { wx_goto_search_menu_s4(); return; }
    wx_connect_or_room();
}
void wx_connect_or_room(void)                            /* 060554 */
{
    if (id5_valid(wx_target_id) && !id5_eq_blank(wx_target_id, wx_room_id)) {
        if (wx_B2A7 != 0) { wx_connect_target(); return; }  /* 06058E -> 605D2 */
    } else {
        wx_B2A7 = 0;                                    /* 060586              */
    }
    memcpy(wx_req_id, wx_room_id, 5);                   /* 060594              */
    memcpy(wx_req_id + 5, rom_67FA4, 5);                /* 0605AC              */
    if (!wx_send_room_c())  consume_key();              /* 0605BE sub_62ACA    */
}
/* 0605C6: alternate entry used by touch: B26E = 1; wx_show_msg_646C2(). */
void wx_goto_search_menu_s4(void)                        /* 0605D8 */
{
    wx_menu_origin = 2;
    wx_enter_search_menu();
}

/* ---------------------------------------------------------------------------
 * 0605F6-060614 (30 B)  wx_touch_s6_probe  [sub_605F6]  Confirmed
 * 060614-060656 (66 B)  wx_key7_s6  [sub_60614]  Confirmed
 * 060656-06073C (230 B) wx_search_menu_action  [sub_60656]  Confirmed
 * Callers: 02AFA2, 02BD80 (probe); off_601F4[6]; 060656 is the tail of
 * 60614 (IDA split it at the cmp #0xC).
 * State 6 = the SEARCH menu (page F813).  Long press -> back (sub_6081C, to state 2
 * or 4 by connection stage).  Item (B3EB):
 *   0..4  -> by category bank: B270 = item, load the category list
 *            (sub_3DD50), count it; if non-empty send `]g` (sub_63040)
 *            and go to state 0x10 (category list).
 *   5     -> ALL list: FF1046 = 0, B334 <- template 060830 (0x15 B),
 *            send `]f` (sub_62FC6), go to the list state (sub_60780).
 *   6     -> text search: clear FF0618/9, copy 0x5C bytes of the default
 *            search buffer from ROM 0x00F6D6 to FF061A, go to state 9.
 *   7,0xB -> consume.  8 -> (not in PDN) LOCAL NEWS list (sub_60FE0).
 *   9     -> sub_6073C ("DNEWS" room connect).  0xA -> sub_6080A.
 *   0xC   -> back (sub_6081C).
 * ------------------------------------------------------------------------- */
void wx_touch_s6_probe(void)                             /* 0605F6 */
{
    touch_reject = 1;
    if (wx_busy & 0x01) { wx_req_flags &= ~0x10; silent_ack(); return; } /* 060724 */
    wx_req_flags &= ~0x10;
    touch_reject = 0;
}
void wx_key7_s6(void)                                    /* 060614 */
{
    if (wx_busy & 0x01) { wx_req_flags &= ~0x10; silent_ack(); return; }
    wx_req_flags &= ~0x10;                              /* 06061E              */
    if (key_flags & 0x80) { wx_back(); return; }        /* 06071E sub_6081C    */
    wx_search_menu_action(wx_sel);
}
void wx_search_menu_action(u8 item)                      /* 060656 (tail) */
{
    switch (item) {
    case 7: case 0x0B: consume_key(); return;           /* 060736              */
    case 0: case 1: case 2: case 3: case 4:             /* 0606F4: bcs         */
        wx_cat_bank = wx_sel;                        /* B270                */
        load_cat_bank_3DD50();                          /* FFB5B8 <- EEPROM    */
        count_cat_entries_69AB6();                      /* -> B272             */
        if ((s8)wx_cat_count <= 0) { consume_key(); return; }
        if (!wx_send_cat_g())      { consume_key(); return; } /* 06070C sub_63040 */
        wx_req_flags &= ~0x04;
        wx_goto_list_C();                               /* 060718 sub_607E0    */
        return;
    case 5:                                             /* 0606C0              */
        wx_list_top = 0;                                /* FF1046              */
        memcpy(wx_list_req, rom_060830_list_tmpl, 0x15);
        if (!wx_send_list_f()) { consume_key(); return; } /* sub_62FC6         */
        wx_req_flags &= ~0x04;
        wx_goto_list();                                 /* sub_60780           */
        return;
    case 6:                                             /* 060692              */
        ram_FF0618 = 0; ram_FF0619 = 0;
        memcpy(wx_text_buf - 0 /*FF061A*/, rom_F6D6, 0x5C);
        wx_goto_text_entry();                           /* sub_607B6           */
        return;
    case 8:   /* LOCAL NEWS (`]f` kind 'A', state 0xB) */  /* 06067C              */
        if (node_mode & 0x80) { consume_key(); return; }
        wx_req_flags &= ~0x20;
        wx_request_news();                              /* sub_60FE0           */
        return;
    case 9:  wx_req_flags &= ~0x20; wx_connect_dnews(); return;  /* 06066E   */
    case 0xA: wx_req_flags &= ~0x20; wx_open_upload_6080A(); return; /* 060660 */
    case 0xC: wx_back(); return;                        /* 06065C              */
    default: consume_key(); return;
    }
}

/* ---------------------------------------------------------------------------
 * 06073C-060780 (68 B)  wx_connect_dnews  [sub_6073C]  Confirmed
 * Callers: 060656, 060F2C, 0657DC.
 * Request B314 = "DNEWS" + 067FA4 and send `]c` (sub_62ACA).  Success ->
 * B26B.b4.  (060774: jsr sub_60C78 is an unreferenced tail.)
 * ------------------------------------------------------------------------- */
void wx_connect_dnews(void)                              /* 06073C */
{
    memcpy(wx_req_id, "DNEWS", 5);                      /* ROM 067FB0          */
    memcpy(wx_req_id + 5, rom_67FA4, 5);
    if (!wx_send_room_c()) { consume_key(); return; }   /* 060766              */
    wx_req_flags |= 0x10;
}

/* ---------------------------------------------------------------------------
 * 060780-060792 (18 B)  wx_goto_list  [sub_60780]  Confirmed
 * 060792-0607B6 (36 B)  wx_goto_list_tail  [sub_60792]  Confirmed
 * State 7 = list of nodes/rooms.  Saves the old state in B40E, clears the
 * page counters B269/B26A, busy b2, flags26D b1/b7, cursor 0.
 * ------------------------------------------------------------------------- */
void wx_goto_list(void)                                  /* 060780 */
{
    wx_prev_state = wx_state;                           /* B40E                */
    wx_page = 0; wx_rows = 0;                           /* B269, B26A          */
    wx_goto_list_tail();
}
void wx_goto_list_tail(void)                             /* 060792 */
{
    wx_busy &= ~0x04;
    wx_flags26D &= ~0x82;
    wx_sel = wx_cursor = 0;
    wx_state = 7;
}

/* ---------------------------------------------------------------------------
 * 0607B6-0607D8 (34 B)  wx_goto_text_entry  [sub_607B6]  Confirmed
 * 0607D8-0607E0 (8 B)   wx_set_state9  [sub_607D8]  Confirmed
 * State 9 = free-text search entry (16 chars, FF061A).  The edit cursor
 * AD99 is set to the current text length (sub_19FDE, max 15).
 * ------------------------------------------------------------------------- */
void wx_goto_text_entry(void)                            /* 0607B6 */
{
    wx_busy &= ~0x04; wx_flags26D &= ~0x02;
    text_set_cursor_to_len_19FDE(wx_text_buf, 0x0F);
    wx_sel = wx_cursor = 0;
    wx_set_state9();
}
void wx_set_state9(void) { wx_state = 9; }               /* 0607D8 */

/* ---------------------------------------------------------------------------
 * 0607E0-06080A (42 B)  wx_goto_list_C  [sub_607E0]  Confirmed
 * State 0x10 = category result list (same bookkeeping as wx_goto_list).
 * ------------------------------------------------------------------------- */
void wx_goto_list_C(void)                                /* 0607E0 */
{
    wx_prev_state = wx_state;
    wx_flags26D &= ~0x80;
    wx_page = 0; wx_rows = 0;
    wx_sel = wx_cursor = 0;
    wx_state = 0x10;
}

/* 06080A-06081C (18 B)  wx_open_upload  [sub_6080A]  Inferred
 * Callers: 060656 (item 0xA), 060F2C.  Needs BA32 != 0 (the same gate
 * doc 103 shows for F-menu mode 8, "else popup 0xA7"), then sub_64660.  */
void wx_open_upload_6080A(void)
{
    if (ram_BA32 == 0) { consume_key(); return; }
    wx_open_msgbox_64660();
}

/* 06081C-060830 (20 B)  wx_back  [sub_6081C]  Confirmed
 * Callers: 060656, 060F2C, 06130E, 06194E.  Back out to SEARCH & DIRECT:
 * state 2 if B2C8 < '3' (not yet linked to a room), else state 4.        */
void wx_back(void)
{
    if (wx_conn_stage < '3') wx_goto_state2(); else wx_goto_state4();
}

/* ---------------------------------------------------------------------------
 * 060846-06087E (56 B)  wx_touch_s7_probe  [sub_60846]  Confirmed
 * 06087E-060936 (184 B) wx_key7_s7  [sub_6087E]  Confirmed
 * Callers: 02B012, 02BD90 (probe); off_601F4[7].
 * State 7 list: pick row B3EB of the page buffer FF104C (0x32-byte rows:
 * [0] kind, [1..5] ID, then name...).  Copies the row's ID to B314 (+
 * 067FA4) and to the target FF8D9F, copies the whole 0x31-byte row to the
 * target record FF8D9E, rewrites kind '1'/'2' as '3'/'4', saves it to
 * EEPROM 0xD07E (sub_3D6B0), then sends `]#` (sub_62E14).  Long press ->
 * back (609E8 = consume via loc).
 * ------------------------------------------------------------------------- */
void wx_touch_s7_probe(void)                             /* 060846 */
{
    touch_reject = 1;
    if (wx_busy & 0x54)  { silent_ack(); return; }      /* 0609DC              */
    if (wx_rows == 0)    { silent_ack(); return; }
    touch_reject = 0;
}
void wx_key7_s7(void)                                    /* 06087E */
{
    u8 *row;
    if (wx_busy & 0x54)   { silent_ack(); return; }
    if (key_flags & 0x80) { consume_key(); return; }    /* 0609E8              */
    wx_sel_row = wx_sel;                             /* B2A2                */
    row = &wx_list_rows[wx_sel * 0x32];              /* FF104C              */
    memcpy(wx_req_id, row + 1, 5);
    memcpy(wx_req_id + 5, rom_67FA4, 5);
    memcpy(wx_target_id, wx_req_id, 5);                 /* 0608E8              */
    memcpy(wx_target_rec, row, 0x31);                   /* FF8D9E              */
    if (wx_target_rec[0] == '1' || wx_target_rec[0] == '2')
        wx_target_rec[0] += 2;                          /* 060920              */
    save_target_rec_3D6B0();                            /* EEPROM 0xD07E       */
    if (!wx_send_connect_hash()) consume_key();         /* 06092A              */
}

/* ---------------------------------------------------------------------------
 * 060936-0609EE (184 B)  wx_list_paging  [sub_60936]  Confirmed
 * Callers: 060C34 (and its siblings 060C3A/060C40 via sub_6094C/sub_60976).
 * Three entry points for the "ALL" list page request:
 *   060936  reload the current page (top = FF1046, request from 1),
 *   06094C  page up: top -= 20 (min 1),
 *   060976  page down: top += 20 if within FF1044 (total).
 * Common tail 060994: clamp 1..999, write it as 3 ASCII digits into the
 * request block (B336, sub_609EE), clear B334.b7 and send `]f`; on
 * success cursor 0, else set B334.b7 again and consume.  060984 also
 * keeps the previous top in FF1048.
 * ------------------------------------------------------------------------- */
void wx_list_reload(void)                                /* 060936 */
{
    u16 top = wx_list_top; if (!top) { consume_key(); return; }
    wx_list_prev_top = top; wx_list_request_from(1);
}
void wx_list_page_up(void)                               /* 06094C */
{
    u16 top = wx_list_top; if (!top) { consume_key(); return; }
    wx_list_prev_top = top;
    if (top == 1) { consume_key(); return; }
    top = (top < 0x15) ? 1 : top - 0x14;                /* 060964..060970      */
    wx_list_request_from(top);
}
void wx_list_page_down(void)                             /* 060976 */
{
    u16 top = wx_list_top; if (!top) { consume_key(); return; }
    wx_list_prev_top = top;
    top += 0x14;
    if (top >= (u16)(wx_list_total + 1)) { consume_key(); return; } /* 060990 */
    wx_list_request_from(top);
}
static void wx_list_request_from(u16 n)                  /* 060994 */
{
    if (n == 0 || n >= 1000) n = 1;
    wx_list_top = n;
    fmt_dec3(n, &wx_list_req[2] /*B336*/);              /* sub_609EE           */
    wx_list_req[0] &= ~0x80;
    if (wx_send_list_f()) { wx_sel = wx_cursor = 0; return; }
    wx_list_req[0] |= 0x80;
    consume_key();
}
/* 0609D6: jsr sub_603AE (back to search menu keeping B27F) - shared tail.
 * 0609DC: silent_ack tail.  0609E8: consume tail.                        */

/* 0609EE-060A2C (62 B)  fmt_dec3  [sub_609EE]  Confirmed
 * Writes r5 (0..999) as 3 ASCII digits at er6[0..2]; hundreds > 9 -> '0'. */
void fmt_dec3(u16 v /* r5 */, u8 *out /* er6 */)
{
    if (v < 100) {
        out[0] = '0';
        if ((u8)v < 10) { out[1] = '0'; out[2] = '0' + v; return; }
    } else {
        u8 h = v / 100; v %= 100;                       /* divxu.b             */
        out[0] = '0' | (h < 10 ? h : 0);
    }
    out[1] = '0' | (v / 10);
    out[2] = '0' | (v % 10);
}

/* ---------------------------------------------------------------------------
 * 060A2C-060A8C (96 B)  wx_touch_s9_probe / wx_key7_s9  [sub_60A2C]  Confirmed
 * 060A8C-060A9E (18 B)  wx_goto_state_A  [sub_60A8C]  Confirmed
 * Callers: 02B052, 02BDA0 (probe at 060A2C); off_601F4[9] -> 060A4A;
 *          060A2C/0624CA -> 60A8C.
 * State 9 text entry.  Key 7 short press advances the edit cursor
 * (sub_1A006, max 15: next char if not 0xFF, else wrap to 0); long press
 * -> state 0xA (confirm menu, cursor 3).
 * ------------------------------------------------------------------------- */
void wx_touch_s9_probe(void)                             /* 060A2C */
{
    touch_reject = 1;
    if (wx_busy & 0x14) { silent_ack(); return; }
    touch_reject = 0;
}
void wx_key7_s9(void)                                    /* 060A4A */
{
    if (wx_busy & 0x14) { silent_ack(); return; }
    if (key_flags & 0x80) { wx_goto_state_A(); return; }
    text_cursor_next_1A006(wx_text_buf + edit_cursor, edit_cursor, 0x0F);
}
void wx_goto_state_A(void)                               /* 060A8C */
{
    wx_sel = wx_cursor = 3;
    wx_state = 0x0A;
}

/* ---------------------------------------------------------------------------
 * 060A9E-060ADA (60 B)  wx_id_entry_enter  [sub_60A9E]  Confirmed
 * Callers: wx_key7 (B39F.b3).  5-char ID entry (B3A2, 1-based cursor
 * B3A0): short press -> next position (sub_1A028, max 5, wraps to 1);
 * long press -> finish (sub_61B4C).
 * ------------------------------------------------------------------------- */
void wx_id_entry_enter(void)                             /* 060A9E */
{
    if (wx_busy & 0x04) { silent_ack(); return; }
    if (key_flags & 0x80) { wx_id_entry_done_61B4C(); return; }
    id_cursor_next_1A028(&wx_id_entry_m1[wx_id_cursor + 1], wx_id_cursor, 5);
}

/* ---------------------------------------------------------------------------
 * 060ADA-060AF0 (22 B)   wx_key7_sA  [sub_60ADA]  Confirmed
 * 060AF0-060B6A (122 B)  wx_text_search_send  [sub_60AF0]  Confirmed
 * Callers: off_601F4[0xA]; 02B09E (60AF0).
 * State 0xA (text-entry confirm: 3 = SEARCH, 4 = edit again, 5 = cancel).
 * SEARCH: if the text is empty (first char 0xFF) -> tone 0x1D; else
 * FF1046 = 0, B334 <- template, B334 = '1' (search by name), copy up to
 * 16 chars (stops at 0xFF) to B339, send `]f`; success -> B26B.b2,
 * state 9 again (sub_607D8).  4 -> wx_goto_text_entry; 5 -> search menu.
 * ------------------------------------------------------------------------- */
void wx_key7_sA(void)                                    /* 060ADA */
{
    if (key_flags & 0x80) { consume_key(); return; }
    if (wx_sel == 5) { wx_enter_search_menu_keep(); return; } /* 060B58   */
    if (wx_sel == 4) { wx_goto_text_entry(); return; }        /* 060B52   */
    wx_text_search_send();
}
void wx_text_search_send(void)                           /* 060AF0 */
{
    u8 *s = wx_text_buf, *d = &wx_list_req[5] /*B339*/; u8 n = 0x10;
    if (s[0] == 0xFF) { tone_ev = 0x1D; consume_key(); return; }
    wx_list_top = 0;
    memcpy(wx_list_req, rom_060830_list_tmpl, 0x15);
    wx_list_req[0] = '1';
    while (n-- && *s != 0xFF) *d++ = *s++;
    if (!wx_send_list_f()) { consume_key(); return; }
    wx_req_flags |= 0x04;
    wx_set_state9();
}

/* ---------------------------------------------------------------------------
 * 060B6A-060B98 (46 B)  wx_touch_sB_probe  [sub_60B6A]  Confirmed
 * 060B98-060BBA (34 B)  wx_key7_sB  [sub_60B98]  Confirmed (state 0xB)
 * 060BBA-060C34 (122 B) wx_list_open_row  [sub_60BBA]  Confirmed
 * 060C34-060C5E (42 B)  wx_list_paging_stubs  [sub_60C34]  Confirmed
 * Callers: 02B1DA, 02BDB6 (probe); off_601F4[0xB]; 02B1DA (60BBA).
 * State 0xB = LOCAL NEWS list (page F810, doc 103).  Selecting row B3EB copies its
 * ID into B314, saves the list position (sub_60CB8), copies the 0x31-byte
 * row to B34E and puts the absolute index (1, or B3EB on the first page)
 * in B34E[0], then sends `]c`.  060C34/3A/40/46 are the jsr stubs the
 * touch table uses for reload / page up / page down / back.
 * ------------------------------------------------------------------------- */
void wx_touch_sB_probe(void)                             /* 060B6A */
{
    touch_reject = 1;
    if (wx_busy & 0x11) { silent_ack(); return; }
    if (wx_rows == 0)   { silent_ack(); return; }
    touch_reject = 0;
}
void wx_key7_sB(void)                                    /* 060B98 */
{
    if (wx_busy & 0x11)   { silent_ack(); return; }
    if (key_flags & 0x80) { consume_key(); return; }
    wx_list_open_row(wx_sel);
}
void wx_list_open_row(u8 r)                              /* 060BBA */
{
    u8 *row; u8 idx;
    if (wx_list_top == 0) { silent_ack(); return; }
    row = &wx_list_rows[r * 0x32];
    memcpy(wx_req_id, row + 1, 5);
    memcpy(wx_req_id + 5, rom_67FA4, 5);
    wx_save_list_pos();                                 /* sub_60CB8           */
    memcpy(wx_open_rec /*B34E*/, row, 0x31);
    idx = 1; if (wx_list_top == 1) idx = wx_sel;     /* 060C16..060C24      */
    wx_open_rec[0] = idx;
    if (!wx_send_room_c()) consume_key();
}
void wx_stub_reload(void)    { wx_list_reload();    }    /* 060C34 */
void wx_stub_page_up(void)   { wx_list_page_up();   }    /* 060C3A */
void wx_stub_page_down(void) { wx_list_page_down(); }    /* 060C40 */
void wx_stub_back(void)      { wx_back_6071E();     }    /* 060C46 */

/* 060C5E-060C78 (26 B)  wx_goto_state12  [sub_60C5E]  Confirmed
 * State 0x12 with menu selection B280 = 1.  (060C64 = keep B280.)        */
void wx_goto_state12(void)
{
    wx_menu12_sel = 1;
    wx_sel = wx_cursor = wx_menu12_sel;
    wx_state = 0x12;
}
/* 060C78-060C98 / 060C98-060CB8 (32 B each)  wx_goto_state2B, twin
 * [sub_60C78, sub_60C98]  Confirmed.  Byte-identical twins: B282 = 1,
 * cursor = 1, B26B.b4 set, state 0x2B.  60C78 is called by 6073C's tail;
 * 60C98 has no caller in the listings.                                    */
void wx_goto_state2B(void)
{
    wx_menu2B_sel = 1;
    wx_sel = wx_cursor = wx_menu2B_sel;
    wx_req_flags |= 0x10;
    wx_state = 0x2B;
}
void wx_goto_state2B_twin(void) { wx_goto_state2B(); }

/* 060CB8-060CDA (34 B)  wx_save_list_pos  [sub_60CB8]  Confirmed
 * 060CDA-060CFC (34 B)  wx_restore_list_pos  [sub_60CDA]  Confirmed
 * Save / restore {B269 page, B26A rows, B3EB, B3F1} in B27B..B27E.       */
void wx_save_list_pos(void)
{
    wx_saved_pos[0] = wx_page; wx_saved_pos[1] = wx_rows;
    wx_saved_pos[2] = wx_sel; wx_saved_pos[3] = wx_cursor;
}
void wx_restore_list_pos(void)
{
    wx_page = wx_saved_pos[0]; wx_rows = wx_saved_pos[1];
    wx_sel = wx_saved_pos[2]; wx_cursor = wx_saved_pos[3];
}

/* ---------------------------------------------------------------------------
 * 060CFC-060E08 (268 B)  wx_touch_s10_probe / wx_key7_s10  [sub_60CFC]
 * Confirmed.  Callers: 02B250, 02BDC6 (probe); off_601F4[0x10] -> 060D30.
 * State 0x10 = category result list (rows FF104C as in state 7).  Key 7
 * on a row: sub_61562 (row selectable?) gate; copy ID to B314 and to the
 * target, copy the 0x31-byte record to FF8D9E ('1'/'2' -> '3'/'4'), save
 * it (sub_3D6B0), refresh the category bank match (sub_69E72), send `]#`.
 * 060DF0: tail -> search menu keep.
 * ------------------------------------------------------------------------- */
void wx_touch_s10_probe(void)                            /* 060CFC */
{
    touch_reject = 1;
    if (wx_busy & 0x64) { silent_ack(); return; }
    if (wx_rows == 0)   { silent_ack(); return; }
    touch_reject = 0;
}
void wx_key7_s10(void)                                   /* 060D30 */
{
    u8 *row;
    if (wx_busy & 0x64)   { silent_ack(); return; }
    if (key_flags & 0x80) { consume_key(); return; }
    wx_sel_row = wx_sel;
    row = &wx_list_rows[wx_sel * 0x32];
    if (!wx_row_selectable_61562(row)) return;          /* 060D6E: Z -> rts    */
    memcpy(wx_req_id, row + 1, 5);
    memcpy(wx_req_id + 5, rom_67FA4, 5);
    memcpy(wx_target_id, wx_req_id, 5);
    memcpy(wx_target_rec, row, 0x31);
    if (wx_target_rec[0] == '1' || wx_target_rec[0] == '2') wx_target_rec[0] += 2;
    save_target_rec_3D6B0();
    cat_find_target_69E72();
    if (!wx_send_connect_hash()) consume_key();
}

/* ---------------------------------------------------------------------------
 * 060E08-060E3A (50 B)  wx_key7_s11  [sub_60E08]  Confirmed
 * 060E3A-060E52 (24 B)  wx_cat_add_or_back  [sub_60E3A]  Confirmed
 * 060E52-060E5E (12 B)  wx_cat_add_target  [sub_60E52]  Confirmed
 * Callers: off_601F4[0x11]; 02B296/060E08 (60E52).
 * State 0x11 = category screen (EDIT CATEGORY / ADD TO CATEGORY).
 * With a category open: on the "add" row (B272+1 == B3F4) -> message box
 * (sub_646C8).  Without: item B3F4 < 5 -> add the current target to bank
 * B3F4 (sub_69DB2, which refuses when 20 entries are used); 5 -> consume;
 * > 5 -> PDN with B3E7 -> search menu, else message box.
 * ------------------------------------------------------------------------- */
void wx_key7_s11(void)                                   /* 060E08 */
{
    if (key_flags & 0x80) { consume_key(); return; }
    if (wx_cat_open) {
        u8 n = wx_cat_count;
        if (n == 0 || n == wx_cat_item) { consume_key(); return; }
        if ((u8)(n + 1) != wx_cat_item) { consume_key(); return; }
        wx_msgbox_646C8(); return;
    }
    if (wx_cat_item == 5) { consume_key(); return; }
    if (wx_cat_item < 5)  { wx_cat_add_target(); return; }
    wx_cat_add_or_back();
}
void wx_cat_add_or_back(void)                            /* 060E3A */
{
    if ((node_mode & 0x80) && pdn_B3E7) { wx_enter_search_menu(); return; }
    wx_msgbox_646C8();
}
void wx_cat_add_target(void) { cat_add_target_69DB2(); } /* 060E52 */

/* ==========================================================================
 * Part 1b: 060E5E-06105A  news menus (states 0x12/0x13/0x2B) and the
 * LOCAL NEWS / category entry helpers.
 * ========================================================================== */

/* ---------------------------------------------------------------------------
 * 060E5E-060E78 (26 B)  wx_key7_s12  [sub_60E5E]  Confirmed
 * 060E78-060EA4 (44 B)  wx_back_to_news_list  [sub_60E78]  Confirmed
 * Callers: off_601F4[0x12]; 02BDD6 (60E78).
 * State 0x12 (F811 news menu).  Long press consumes.  Item 0 -> sub_65854,
 * item 1 -> sub_658A4, any other item falls into 60E78: restore the saved
 * list position, clear the item key B324..B328 and return to the LOCAL
 * NEWS list (state 0xB, B26E = 2).
 * ------------------------------------------------------------------------- */
void wx_key7_s12(void)                                   /* 060E5E */
{
    if (key_flags & 0x80) { consume_key(); return; }
    if (wx_sel == 0) { wx_news_item0_65854(); return; }
    if (wx_sel == 1) { wx_news_item1_658A4(); return; }
    wx_back_to_news_list();
}
void wx_back_to_news_list(void)                          /* 060E78 */
{
    wx_restore_list_pos();
    wx_B324 = 0; wx_B328 = 0;
    wx_goto_news_list_61040();
}

/* ---------------------------------------------------------------------------
 * 060EA4-060EBE (26 B)  wx_key7_s2B  [sub_60EA4]  Confirmed
 * 060EBE-060ED4 (22 B)  wx_leave_item  [sub_60EBE]  Confirmed
 * 060ED4-060F2C (88 B)  wx_return_60ED4  [sub_60ED4]  Confirmed
 * Callers: off_601F4[0x2B] (60EA4); 06470C (60ED4, message box back).
 * State 0x2B (F814).  Item 0 -> sub_65854; item 1 -> sub_6592E when the
 * key byte B325 == '0', else consume; others leave: clear the key and
 * B26B.b4 (DNEWS), then 60ED4 returns by B26E: 0 -> state 0x13 from list
 * (sub_64690); else B26B.b5 -> message box state 0x13 (sub_646C8),
 * otherwise state 0x12 keeping B280 (060C64) and key B32E -> B324.
 * ------------------------------------------------------------------------- */
void wx_key7_s2B(void)                                   /* 060EA4 */
{
    if (key_flags & 0x80) { consume_key(); return; }
    if (wx_sel == 0) { wx_news_item0_65854(); return; }
    if (wx_sel == 1) {
        if (wx_B324_bytes[1] == '0') wx_news_play_6592E(); else consume_key();
        return;
    }
    wx_leave_item();
}
void wx_leave_item(void)                                 /* 060EBE */
{
    wx_B324 = 0; wx_B328 = 0;
    wx_req_flags &= ~0x10;
    wx_return_60ED4();
}
void wx_return_60ED4(void)                               /* 060ED4 */
{
    if (wx_menu_origin == 0) { wx_msg_return_64690(); return; }
    if (wx_req_flags & 0x20) { wx_msgbox_646C8(); return; }
    wx_goto_state12_keep();                             /* 060C64              */
    memcpy(&wx_B324, wx_B32E, 5);
}

/* ---------------------------------------------------------------------------
 * 060F2C-060FE0 (180 B)  wx_touch_s13_probe / wx_key7_s13  [sub_60F2C]
 * Confirmed.  Callers: 02B2C6/02B2F8/02BDD6/02BDE6 (probe); off_601F4[0x13]
 * -> 060F4A.
 * State 0x13 (F812, room / news menu).  busy.b0 -> B26B.b4 clear, silent.
 * Long press -> wx_back.  Item 0 -> sub_65854, 1 -> sub_658A4, 2 -> LOCAL
 * NEWS (B26B.b5, wx_request_news), 3 -> DNEWS room (B26B.b5,
 * wx_connect_dnews); other items consume.  (060F8E/060FB0, the 6080A and
 * 6104E arms, are unreachable compares against 0.)
 * ------------------------------------------------------------------------- */
void wx_touch_s13_probe(void)                            /* 060F2C */
{
    touch_reject = 1;
    if (wx_busy & 0x01) { wx_req_flags &= ~0x10; silent_ack(); return; }
    wx_req_flags &= ~0x10;
    touch_reject = 0;
}
void wx_key7_s13(void)                                   /* 060F4A */
{
    if (wx_busy & 0x01) { wx_req_flags &= ~0x10; silent_ack(); return; }
    wx_req_flags &= ~0x10;
    if (key_flags & 0x80) { wx_back(); return; }
    switch (wx_sel) {
    case 0: wx_news_item0_65854(); return;
    case 1: wx_news_item1_658A4(); return;
    case 2: wx_req_flags |= 0x20; wx_request_news(); return;
    case 3: wx_req_flags |= 0x20; wx_connect_dnews(); return;
    default: consume_key(); return;
    }
}

/* ---------------------------------------------------------------------------
 * 060FE0-06101E (62 B)  wx_request_news  [sub_60FE0]  Confirmed
 * 06101E-061040 (34 B)  wx_goto_news_list  [sub_6101E]  Confirmed
 * 061040-06104E (14 B)  wx_goto_news_list_61040  [sub_61040]  Confirmed
 * 06104E-06105A (12 B)  wx_goto_category  [sub_6104E]  Confirmed
 * Callers: 060656, 060F2C (60FE0); 060FE0 (6101E); 060E78 (61040);
 *          060F2C (6104E, unreachable arm).
 * LOCAL NEWS: FF1046 = 0, B334 <- template 060830, kind 'A', send `]f`;
 * success -> B26B.b2 clear, B40E = state, busy.b0 clear, page/rows 0,
 * cursor 0, B26E = 2, state 0xB (F810).  6104E reloads the WIRES-X
 * settings (sub_69AFE: B3F3/4/5 = 0) and enters state 0x11 (category).
 * ------------------------------------------------------------------------- */
void wx_request_news(void)                               /* 060FE0 */
{
    wx_list_top = 0;
    memcpy(wx_list_req, rom_060830_list_tmpl, 0x15);
    wx_list_req[0] = 'A';
    if (!wx_send_list_f()) { consume_key(); return; }
    wx_req_flags &= ~0x04;
    wx_goto_news_list();
}
void wx_goto_news_list(void)                             /* 06101E */
{
    wx_prev_state = wx_state;
    wx_busy &= ~0x01;
    wx_page = 0; wx_rows = 0;
    wx_sel = wx_cursor = 0;
    wx_goto_news_list_61040();                          /* falls through       */
}
void wx_goto_news_list_61040(void) { wx_menu_origin = 2; wx_state = 0x0B; }
void wx_goto_category(void) { wx_settings_reload_69AFE(); wx_state = 0x11; }

/* ==========================================================================
 * Part 2: 06105A-0625F6  PTT in WIRES-X (connect-by-PTT), the key 5/8
 * view toggles, and the first half of the mode-9 render dispatcher.
 * ========================================================================== */

/* ---------------------------------------------------------------------------
 * 06105A-0610BA (96 B)  wx_ptt  [sub_6105A]  Confirmed
 * Callers: key table #11 slot 14 (PTT press, doc L15 "key event 14") and
 *          table #4 slot 14.
 * PTT pressed while WIRES-X is up.  In PDN with B3D9.b1 set the key is
 * eaten.  An open popup is closed (and PTT is NOT forwarded).  In ID entry
 * (B39F.b3) it is eaten.  In the VFO view (B39F.b2) with 8EA0.b7 and .b6
 * set the plain tx_request (sub_2244C) runs.  Otherwise B132 = 0 and
 * off_610BA[wx_state] picks the WIRES-X behaviour:
 *   2 -> 611D4 (connect to target by PTT), 4 -> 6127A (target or room),
 *   6 -> 6130E (back), 7 -> 61314 (connect to list row), 0x10 -> 61442,
 *   0x12 -> 61590, 0x13 -> 615E4, 0x16/0x1E -> 615FE, 0x1B -> 6160C,
 *   0x14,0x15,0x18-0x1A,0x1F-0x25,0x29,0x2B,0x32-0x3B,0x3D -> 61252
 *   (talk into the connected room), all others -> 611CE (consume).
 * ------------------------------------------------------------------------- */
void wx_ptt(void)                                        /* 06105A */
{
    if ((node_mode & 0x80) && (flags_B3D9 & 0x02)) { consume_key(); return; }
    if (wx_popup) { wx_popup_close_62112(); return; }   /* 061070              */
    if (wx_link & 0x08) { consume_key(); return; }      /* ID entry            */
    if ((wx_link & 0x04) && (band_8EA0 & 0x80) && (band_8EA0 & 0x40)) {
        tx_request();                                   /* 0610B4 sub_2244C    */
        return;
    }
    wx_B132 = 0;                                        /* 061088              */
    off_610BA[wx_state]();
}

/* 0611CE-0611D4 (6 B)  wx_consume  [sub_611CE]  Confirmed: consume_key().
 * Default slot of off_610BA and off_661C8.                               */
void wx_consume(void) { consume_key(); }

/* ---------------------------------------------------------------------------
 * 0611D4-061252 (126 B)  wx_ptt_connect_target  [sub_611D4]  Confirmed
 * Callers: off_610BA[2]; 06127A.
 * PTT on SEARCH & DIRECT: validate the target ID, start TX (sub_2244C,
 * nonzero = refused), then put the connect request into the TX:
 * B314 = target + 067FA4, B132 = 1, AAD4.b1 (message queued with the
 * voice), busy.b6 ("connect pending"), B311 = 0, B349 = copy of the ID.
 * In PDN also B3D9.b0 (sub_6D04A).
 * ------------------------------------------------------------------------- */
void wx_ptt_connect_target(void)                         /* 0611D4 */
{
    if (wx_busy & 0x04) return;
    if (wx_check_target_id()) return;                   /* 0611DE              */
    if (tx_request()) return;                           /* 0611E6: nz=refused  */
    memcpy(wx_req_id, wx_target_id, 5);
    memcpy(wx_req_id + 5, rom_67FA4, 5);
    wx_B132 = 1;
    aad4_flags |= 0x02;                                 /* 06121C              */
    wx_busy |= 0x40;                                    /* 061222              */
    wx_B311 = 0;
    memcpy(wx_pend_id /*B349*/, wx_req_id, 5);
    if (node_mode & 0x80) pdn_mark_B3D9_6D04A();
}

/* ---------------------------------------------------------------------------
 * 061252-06127A (40 B)  wx_ptt_talk  [sub_61252]  Confirmed
 * Callers: off_610BA[many]; 061590, 0615E4, 0615FE, 06160C.
 * PTT while linked to a room (B2C8 >= '3'): validate the room ID, start TX,
 * then AAD4.b4 and .b1, B132 = 1 (the room ID rides the voice header).
 * ------------------------------------------------------------------------- */
void wx_ptt_talk(void)                                   /* 061252 */
{
    if (wx_conn_stage < '3') return;
    if (wx_check_room_id()) return;
    if (tx_request()) return;
    aad4_flags |= 0x10;
    wx_B132 = 1;
    aad4_flags |= 0x02;
}

/* ---------------------------------------------------------------------------
 * 06127A-06130E (148 B)  wx_ptt_s4  [sub_6127A]  Confirmed
 * Callers: off_610BA[4].
 * PTT on the connected screen: same choice as wx_connect_or_room (060554):
 * a valid target different from the room with B2A7 set -> connect to the
 * target (wx_ptt_connect_target); else B2A7 = 0 and key up into the room:
 * room ID check, TX, B314 = room + 067FA4, B132 = 1, AAD4.b1, PDN mark.
 * ------------------------------------------------------------------------- */
void wx_ptt_s4(void)                                     /* 06127A */
{
    if (id5_valid(wx_target_id) && !id5_eq_blank(wx_target_id, wx_room_id)) {
        if (wx_B2A7 != 0) { wx_ptt_connect_target(); return; } /* 061308     */
    } else {
        wx_B2A7 = 0;
    }
    if (wx_check_room_id()) return;
    if (tx_request()) return;
    memcpy(wx_req_id, wx_room_id, 5);
    memcpy(wx_req_id + 5, rom_67FA4, 5);
    wx_B132 = 1;
    aad4_flags |= 0x02;
    if (node_mode & 0x80) pdn_mark_B3D9_6D04A();
}

/* 06130E-061314 (6 B)  wx_ptt_back  [sub_6130E]  Confirmed: wx_back().   */
void wx_ptt_back(void) { wx_back(); }

/* ---------------------------------------------------------------------------
 * 061314-06140E (250 B)  wx_ptt_list_row  [sub_61314]  Confirmed
 * 06140E-061442 (52 B)   wx_mark_same_room  [sub_6140E]  Confirmed
 * Callers: off_610BA[7] (61314); 061314, 061442 (6140E).
 * PTT on a list row connects to it while keying up.  If a PTT connect is
 * already pending (busy.b6) the row selected then (B2A2) is reused.
 * After TX starts: B2A2 = row, flags26D.b7 = "row is the current room"
 * (6140E: only when B2C8 >= '3' and row ID == B2C9), copy the row ID to
 * B314/target, the 0x31-byte row to FF8D9E ('1'/'2' -> '3'/'4'), save to
 * EEPROM, then the same request bookkeeping as 611D4.
 * ------------------------------------------------------------------------- */
void wx_ptt_list_row(void)                               /* 061314 */
{
    u8 *row;
    wx_flags26D &= ~0x80;
    if (wx_busy & 0x14) return;                         /* b2, b4              */
    if (wx_busy & 0x40) wx_sel = wx_sel_row;            /* 061336              */
    if (tx_request()) return;                           /* 061342              */
    wx_sel_row = wx_sel;
    row = &wx_list_rows[wx_sel * 0x32];
    wx_mark_same_room(row);
    memcpy(wx_req_id, row + 1, 5);
    memcpy(wx_req_id + 5, rom_67FA4, 5);
    memcpy(wx_target_id, wx_req_id, 5);
    memcpy(wx_target_rec, row, 0x31);
    if (wx_target_rec[0] == '1' || wx_target_rec[0] == '2') wx_target_rec[0] += 2;
    save_target_rec_3D6B0();
    wx_B132 = 1; aad4_flags |= 0x02; wx_busy |= 0x40; wx_B311 = 0;
    memcpy(wx_pend_id, wx_req_id, 5);
    if (node_mode & 0x80) pdn_mark_B3D9_6D04A();
}
void wx_mark_same_room(const u8 *row /* er1 */)          /* 06140E */
{
    if (wx_conn_stage < '3') return;
    if (id5_eq_blank(row + 1, wx_room_id)) wx_flags26D |= 0x80;
}

/* ---------------------------------------------------------------------------
 * 061442-0614E4 (162 B)  wx_ptt_cat_row  [sub_61442]  Confirmed
 * 0614E4-061562 (126 B)  wx_ptt_cat_row_tail  [sub_614E4]  Confirmed
 * Callers: off_610BA[0x10].  (IDA split the body at 0614E4.)
 * PTT on a category-list row (state 0x10).  Rows B26A and B26A+1 are the
 * page-navigation pseudo rows and are ignored; a row whose ID equals B2AA
 * is refused (wx_row_selectable).  Then as wx_ptt_list_row, plus the
 * category bank re-match (sub_69E72).
 * ------------------------------------------------------------------------- */
void wx_ptt_cat_row(void)                                /* 061442 */
{
    u8 r, n, *row;
    wx_flags26D &= ~0x80;
    if (wx_busy & 0x04) return;
    if (wx_busy & 0x40) wx_sel = wx_sel_row;
    r = wx_sel; n = wx_rows;
    if (n == 0 || r == n || r == (u8)(n + 1)) return;
    row = &wx_list_rows[r * 0x32];
    if (!wx_row_selectable_61562(row)) return;
    if (tx_request()) return;
    wx_sel_row = wx_sel;
    row = &wx_list_rows[wx_sel * 0x32];
    wx_mark_same_room(row);
    memcpy(wx_req_id, row + 1, 5);
    memcpy(wx_req_id + 5, rom_67FA4, 5);
    /* 0614E4: */
    memcpy(wx_target_id, wx_req_id, 5);
    memcpy(wx_target_rec, row, 0x31);
    if (wx_target_rec[0] == '1' || wx_target_rec[0] == '2') wx_target_rec[0] += 2;
    save_target_rec_3D6B0();
    cat_find_target_69E72();
    wx_B132 = 1; aad4_flags |= 0x02; wx_busy |= 0x40; wx_B311 = 0;
    memcpy(wx_pend_id, wx_req_id, 5);
    if (node_mode & 0x80) pdn_mark_B3D9_6D04A();
}

/* 061562-061590 (46 B)  wx_row_selectable  [sub_61562]  Confirmed
 * Callers: 060CFC, 061442.  er1 = row; compares row ID (0xFF as ' ') with
 * B2AA; equal -> tone 0x1D and r4l = 0 (Z: not selectable).              */
u8 wx_row_selectable_61562(const u8 *row)
{
    if (id5_eq_blank(row + 1, wx_node_id)) { tone_ev = 0x1D; return 0; }
    return 1;
}

/* ---------------------------------------------------------------------------
 * 061590-0615AA (26 B)  wx_ptt_s12  [sub_61590]  Confirmed
 * 0615AA-0615E4 (58 B)  wx_arm_hold_tx  [sub_615AA]  Confirmed
 * 0615E4-0615FE (26 B)  wx_ptt_s13  [sub_615E4]  Confirmed
 * Callers: off_610BA[0x12] / [0x13]; 0662E8 also calls 615AA.
 * States 0x12/0x13 (news content menus F811/F812).  PTT on item 0, when
 * B327 == '0', arms a held key-up: cursor 0, FF959B = 0x23 (3.5 s on the
 * 100 ms tier, doc 86 T7), tone 0x46, BC5B = old state, state 0x29,
 * AA34.b5 clear, popup 0x0D.  sub_63304 fires sub_61624 when FF959B
 * reaches 0 in state 0x29; PTT release before that cancels (wx_ptt_up).
 * Other items: wx_ptt_talk.
 * ------------------------------------------------------------------------- */
void wx_ptt_s12(void)
{
    if (wx_busy & 0x01) return;
    if (wx_sel != 0) wx_ptt_talk(); else wx_arm_hold_tx();
}
void wx_arm_hold_tx(void)                                /* 0615AA */
{
    if (wx_B327 != '0') return;
    wx_sel = wx_cursor = 0;
    hold_tmr_959B = 0x23;
    tone_ev = 0x46;
    wx_hold_ret_state = wx_state;                       /* BC5B                */
    wx_state = 0x29;
    flags_AA34 &= ~0x20;
    popup_id = 0x0D;                                    /* BBE1                */
}
void wx_ptt_s13(void) { wx_ptt_s12(); }                  /* 0615E4: same body */

/* 0615FE-06160C (14 B)  wx_ptt_s16  [sub_615FE]  Confirmed
 * States 0x16/0x1E: talk unless busy.b1.                                 */
void wx_ptt_s16(void) { if (!(wx_busy & 0x02)) wx_ptt_talk(); }

/* ---------------------------------------------------------------------------
 * 06160C-06161C (16 B)  wx_ptt_s1B  [sub_6160C]  Confirmed
 * 06161C-061624 (8 B)   wx_ptt_upload_check  [sub_6161C]  Confirmed
 * 061624-06163E (26 B)  wx_hold_tx_fire  [sub_61624]  Confirmed
 * Callers: off_610BA[0x1B]; 06160C/06630E (6161C); 063304 (61624).
 * State 0x1B (UPLOAD, F816): item 0 with B326 == '0' starts the upload
 * transmission at once: popup timer FF9599 = 0x78 (12 s), B275.b4 clear,
 * FF95E6 = 0x258 (60 s, slow tier), then sub_6631E (sets up and calls
 * tx_request).  Other items: wx_ptt_talk.
 * ------------------------------------------------------------------------- */
void wx_ptt_s1B(void)
{
    if (wx_sel != 0) wx_ptt_talk(); else wx_ptt_upload_check();
}
void wx_ptt_upload_check(void)                           /* 06161C */
{
    if (wx_B326 != '0') return;
    wx_hold_tx_fire();                                  /* falls through       */
}
void wx_hold_tx_fire(void)                               /* 061624 */
{
    popup_tmr = 0x78;                                   /* FF9599              */
    wx_B275 &= ~0x10;
    wx_tx_tmr_95E6 = 0x258;
    wx_upload_tx_6631E();
}

/* ---------------------------------------------------------------------------
 * 06163E-0616A4 (102 B)  wx_tx_end  [sub_6163E]  Inferred
 * 0616A4-0616BA (22 B)   wx_tx_end_3C_a  [sub_616A4]  Confirmed
 * 0616BA-0616F2 (56 B)   wx_tx_end_3C_b  [sub_616BA]  Confirmed
 * Callers: 035ABE (6163E; TX-state code); 06163E and 068DC0 (616BA).
 * Runs after a WIRES-X transmission.  B95E is a signed countdown: while
 * it stays >= 0 after the decrement, sub_616A4 (state 0x3C: FF959A = 0x78,
 * BC59.b7 redraw); when it goes negative sub_616BA (state 0x3C: B266.b7 =
 * AAD9.b0, tone 0x59 + that bit, AA34.b5, FF9538 = 0xFA (2.5 s fast tier),
 * 817E.b1).  Then: busy.b6 (connect was sent) -> BC59.b7 + popup timer 12 s;
 * flags26D.b7 cleared; AAD4.b2|b3 -> redraw, popup timer, B3B2 = FF95E6.
 * Finally AAD4 = 0 (all WIRES-X TX attachments consumed).
 * ------------------------------------------------------------------------- */
void wx_tx_end(void)                                     /* 06163E */
{
    if ((s8)wx_B95E >= 0) {
        if ((s8)--wx_B95E >= 0) wx_tx_end_3C_a(); else wx_tx_end_3C_b();
    }
    if (wx_busy & 0x40) { disp_flags_BC59 |= 0x80; popup_tmr = 0x78; }
    if (wx_flags26D & 0x80) wx_flags26D &= ~0x80;
    if (aad4_flags & 0x0C) {
        disp_flags_BC59 |= 0x80; popup_tmr = 0x78;
        wx_B3B2 = wx_tx_tmr_95E6;
    }
    aad4_flags = 0;
}
void wx_tx_end_3C_a(void)
{
    if (wx_state != 0x3C) return;
    tmr_959A = 0x78; disp_flags_BC59 |= 0x80;
}
void wx_tx_end_3C_b(void)
{
    u8 b;
    if (wx_state != 0x3C) return;
    b = flags_AAD9 & 0x01;                              /* bld/bst             */
    wx_B266 = (wx_B266 & 0x7F) | (b << 7);
    tone_ev = 0x59 + b;
    flags_AA34 |= 0x20;
    tmr_9538 = 0xFA;
    flags_817E |= 0x02;
}

/* ---------------------------------------------------------------------------
 * 0616F2-061724 (50 B)  wx_ptt_up  [sub_616F2]  Confirmed
 * Callers: key tables #4/#11/#12 slot 15 (PTT release).
 * Releasing PTT during the 3.5 s hold (state 0x29) cancels it: tone 0xFF
 * and return by B26E (0 -> sub_64690, 1 -> sub_646C8, else 060C64 =
 * state 0x12 keeping B280).  Any other state: consume.
 * ------------------------------------------------------------------------- */
void wx_ptt_up(void)                                     /* 0616F2 */
{
    if (wx_state != 0x29) { consume_key(); return; }
    tone_ev = 0xFF;
    switch (wx_menu_origin) {                           /* B26E                */
    case 0:  wx_msg_return_64690(); break;
    case 1:  wx_msgbox_646C8();     break;
    default: wx_goto_state12_keep(); break;             /* 060C64              */
    }
}

/* ---------------------------------------------------------------------------
 * 061724-0617D4 (176 B)  wx_key8  [sub_61724]  Confirmed
 * 0617D4-0617EA (22 B)   wx_vfo_refresh  [sub_617D4]  Confirmed
 * Callers: key table #11 slot 8 (61724); 617D4 from 05FD2C, 061724,
 *          061A2E, 061ABC, 061B88.
 * Key 8 toggles between the WIRES-X screen (B39F.b0) and the normal
 * display.  Popup -> close.  Long press: PDN -> node-mode hook (06CCF4)
 * unless 8DE0.b7; else if 8EA0.b7, no ID entry, and (VFO view, or state
 * 2/4 with the WIRES-X screen off) -> the normal key-8 function
 * (sub_20FF2); otherwise consume.  Short press: in ID entry, leave it
 * (if not busy.b2); in PDN or VFO view consume; else refresh the band
 * display (sub_617D4), clear B39F.b4 and run off_617EA[state].
 * off_617EA: 2 -> 6194E (toggle view), 4 -> 61964, 6 -> 61996,
 * 7 -> 619A2, 9 -> 619BC, 0xB -> 619CE, 0x10 -> 619E0, 0x11/0x12 -> 619FA,
 * 0x16 -> 61A04, 0x3/8/0xA/0x13/0x14/... -> 61A0E (leave), else consume.
 * 617D4: if 8EA0.b7 and .b6 -> sub_21002 (band display refresh).
 * ------------------------------------------------------------------------- */
void wx_key8(void)                                       /* 061724 */
{
    if (wx_popup) { wx_popup_close_62112(); return; }
    if (key_flags & 0x80) {                             /* long: 061784        */
        if (node_mode & 0x80) {
            if (flags_8DE0 & 0x80) { consume_key(); return; }
            pdn_key8_long_6CCF4();
            return;
        }
        if (!(band_8EA0 & 0x80))   { consume_key(); return; }
        if (wx_link & 0x08)        { consume_key(); return; }
        if (!(wx_link & 0x04)) {
            if (wx_state != 2 && wx_state != 4) { consume_key(); return; }
            if (wx_link & 0x01)    { consume_key(); return; }
        }
        main_key8_20FF2();                              /* 0617CE              */
        return;
    }
    if (wx_link & 0x08) {                               /* 061772              */
        if (wx_busy & 0x04) { consume_key(); return; }
        wx_link &= ~0x08;
    } else {
        if (node_mode & 0x80)  { consume_key(); return; }
        if (wx_link & 0x04)    { consume_key(); return; }
    }
    wx_vfo_refresh();                                   /* 061754              */
    wx_link &= ~0x10;
    off_617EA[wx_state]();
}
void wx_vfo_refresh(void)                                /* 0617D4 */
{
    if ((band_8EA0 & 0x80) && (band_8EA0 & 0x40)) band_disp_refresh_21002();
}

/* ---------------------------------------------------------------------------
 * 06194E-061A26 (216 B)  wx_key8_cases  [sub_6194E]  Confirmed
 * 061A26-061A2E (8 B)    wx_key8_refuse  [sub_61A26]  Confirmed
 * Callers: off_617EA[] (the body holds several case entries), 061724.
 * Each case first checks its busy bits (refuse -> consume, r4l = 1), then:
 *   6194E/61964 (states 2/4): if B39F.b4 -> r4l = 0, else toggle
 *               B39F.b0 (WIRES-X screen on/off).
 *   others      (61996..61A04 -> 61A0E): if B39F.b4 -> r4l = 0, else
 *               clear B39F.b0 and wx_back().
 * Busy masks: 6194E b2|b6; 61964 b0|b2|b6; 61996 b0; 619A2 b2|b6|b4;
 * 619BC b2|b4; 619CE b0|b4; 619E0 b5|b2|b6; 619FA b0; 61A04 b1.
 * The return value (r4l, 0 = "not handled yet") is used by the key-5 and
 * mode-10 key paths that call through off_617EA with B39F.b4 set.
 * ------------------------------------------------------------------------- */
static u8 wx_key8_toggle(u8 busy_mask)
{
    if (wx_busy & busy_mask) return wx_key8_refuse();
    if (wx_link & 0x10) return 0;
    wx_link ^= 0x01;                                    /* 06198C bnot         */
    return 0;  /* r4l not written: value of the caller's r4l */
}
static u8 wx_key8_leave(u8 busy_mask)
{
    if (wx_busy & busy_mask) return wx_key8_refuse();
    if (wx_link & 0x10) return 0;
    wx_link &= ~0x01;
    wx_back();
    return 0;
}
u8 wx_key8_s2(void)  { return wx_key8_toggle(0x44); }    /* 06194E */
u8 wx_key8_s4(void)  { return wx_key8_toggle(0x45); }    /* 061964 */
u8 wx_key8_s6(void)  { return wx_key8_leave(0x01); }     /* 061996 */
u8 wx_key8_s7(void)  { return wx_key8_leave(0x54); }     /* 0619A2 */
u8 wx_key8_s9(void)  { return wx_key8_leave(0x14); }     /* 0619BC */
u8 wx_key8_sB(void)  { return wx_key8_leave(0x11); }     /* 0619CE */
u8 wx_key8_s10(void) { return wx_key8_leave(0x64); }     /* 0619E0 */
u8 wx_key8_s11(void) { return wx_key8_leave(0x01); }     /* 0619FA */
u8 wx_key8_s16(void) { return wx_key8_leave(0x02); }     /* 061A04 */
u8 wx_key8_leave0(void) { return wx_key8_leave(0x00); }  /* 061A0E */
u8 wx_key8_refuse(void) { consume_key(); return 1; }     /* 061A26 */

/* ---------------------------------------------------------------------------
 * 061A2E-061A88 (90 B)  gm_key8  [sub_61A2E]  Confirmed
 * 061A88-061ABC (52 B)  gm_key8_short  [sub_61A88]  Confirmed
 * Callers: key table #12 slot 8 (mode 10).  061A9E/061AA8 are the
 *          off_618FE case bodies (busy.b0 -> refuse, else r4l = 0).
 * Mode 10 (GM candidate) key 8.  Long press: if B420.b0 refuse; else
 * refresh, B39F.b4 = 1, run off_618FE[state] (state < 0x14) or
 * off_617EA[state]; if that returned 0 call sub_644B8.  Short press:
 * with 8EA0.b7 and B420.b0 -> normal key 8 (sub_20FF2); else refuse.
 * ------------------------------------------------------------------------- */
void gm_key8(void)                                       /* 061A2E */
{
    if (!(key_flags & 0x80)) { gm_key8_short(); return; }
    if (gm_B420 & 0x01) { consume_key(); return; }
    wx_vfo_refresh();
    wx_link |= 0x10;
    if ((wx_state < 0x14 ? off_618FE[wx_state]() : off_617EA[wx_state]()) != 0)
        return;
    gm_enter_644B8();
}
void gm_key8_short(void)                                 /* 061A88 */
{
    if ((band_8EA0 & 0x80) && (gm_B420 & 0x01)) { main_key8_20FF2(); return; }
    consume_key();
}
u8 gm_case_busy0(void) { if (wx_busy & 0x01) return wx_key8_refuse(); return 0; } /* 061A9E/AA8 */
u8 gm_case_refuse(void) { return wx_key8_refuse(); }    /* 061AB4 */

/* ---------------------------------------------------------------------------
 * 061ABC-061B36 (122 B)  wx_key5  [sub_61ABC]  Confirmed
 * 061B36-061B4C (22 B)   wx_id_entry_leave  [sub_61B36]  Confirmed
 * Callers: key table #11 slot 5 (61ABC); 02B09E and 061ABC (61B36).
 * Key 5: B2A3 = 0; long press -> consume.  Popup -> close.  ID entry ->
 * leave it (61B36, refused while busy.b2).  Otherwise refresh, B39F.b4,
 * run off_617EA[state] as a "can I?" probe; if it returned 0: in states
 * 2/4 toggle the WIRES-X view (b0) and set b2 = !b0, else toggle the VFO
 * view (b2) and set b0 = !b2.  So key 5 flips WIRES-X <-> VFO view.
 * ------------------------------------------------------------------------- */
void wx_key5(void)                                       /* 061ABC */
{
    wx_B2A3 = 0;
    if (key_flags & 0x80) { consume_key(); return; }
    if (wx_popup) { wx_popup_close_62112(); return; }
    if (wx_link & 0x08) { wx_id_entry_leave(); return; }
    wx_vfo_refresh();
    wx_link |= 0x10;
    if (off_617EA[wx_state]() != 0) return;
    if (wx_state == 2 || wx_state == 4) {
        wx_link ^= 0x01;
        wx_link = (wx_link & ~0x04) | ((wx_link & 0x01) ? 0 : 0x04);
    } else {
        wx_link ^= 0x04;
        wx_link = (wx_link & ~0x01) | ((wx_link & 0x04) ? 0 : 0x01);
    }
}
void wx_id_entry_leave(void)                             /* 061B36 */
{
    if (wx_busy & 0x04) { consume_key(); return; }
    wx_link &= ~0x08;
}

/* ---------------------------------------------------------------------------
 * 061B4C-061B88 (60 B)  wx_id_entry_done  [sub_61B4C]  Confirmed
 * Callers: 060A9E (long press in ID entry).
 * DIRECT entry: the 5 chars at B3A3.. must all be '0'..'9' and be followed
 * by 0xFF; then send the `]#` connect-by-number request (sub_62EAC).
 * Bad entry -> tone 0x1D; send refused -> consume.  The alternate entry
 * 061B56 checks FF061A instead (no caller found).
 * ------------------------------------------------------------------------- */
void wx_id_entry_done_61B4C(void)                        /* 061B4C */
{
    const u8 *p = &wx_id_entry_m1[2];   /* FFB3A3 */
    u8 n = 5;
    do { if (*p < '0' || *p > '9') goto bad; p++; } while (--n);
    if (*p != 0xFF) goto bad;
    if (!wx_send_connect_num()) consume_key();          /* sub_62EAC           */
    return;
bad:
    tone_ev = 0x1D;
}

/* ---------------------------------------------------------------------------
 * 061B88-061BDC (84 B)  gm_key5  [sub_61B88]  Confirmed
 * 061BDC-061BE2 (6 B)   gm_key5_refuse  [sub_61BDC]  Confirmed
 * Callers: key table #12 slot 5.  Long press -> consume.  Short: refresh,
 * B39F.b4, off_618FE / off_617EA probe; if 0 -> toggle B420.b0.
 * ------------------------------------------------------------------------- */
void gm_key5(void)
{
    if (key_flags & 0x80) { consume_key(); return; }
    wx_vfo_refresh();
    wx_link |= 0x10;
    if ((wx_state < 0x14 ? off_618FE[wx_state]() : off_617EA[wx_state]()) != 0)
        return;
    gm_B420 ^= 0x01;
}
void gm_key5_refuse(void) { consume_key(); }

/* ---------------------------------------------------------------------------
 * 061BE2-061C54 (114 B)  wx_render  [sub_61BE2]  Confirmed
 * 061C58-061C5A (2 B)    nullsub_74 (rts)
 * Callers: the home render dispatcher for [A9F9] == 9 (doc 103).
 * Builds the mode-9 page for SUB.  B08D = 0; a pending edit cursor in AD9A
 * is moved into AD99; B39F.b1 cleared; an open popup renders through
 * wx_render_popup (sub_620EE) and stops if it drew.  B3EB = 0xFF (the
 * row renderers set it to the cursor row as they draw it).  ID entry ->
 * sub_6262A; VFO view -> state-2 page if B2C8 < '3' (sub_61E5E) else the
 * state-4 page (sub_6201A); else off_61C5A[state]:
 *   0,1 -> 61E58 (home display), 2 -> 61E5E, 3 -> 61F2C, 4 -> 6201A,
 *   5 -> 620B8, 6 -> 62122, 7 -> 62282, 8 -> 62488, 9 -> 62514,
 *   0xA -> 6267E, 0xB -> 62692, 0x10 -> 62850, 0x11 -> 62904,
 *   0x12 -> 62954, 0x13 -> 62A32, 0x14.. -> 66ED0/6703A/... (content).
 * ------------------------------------------------------------------------- */
void wx_render(void)                                     /* 061BE2 */
{
    ram_B08D = 0;
    if ((s8)wx_AD9A >= 0) { edit_cursor = wx_AD9A; wx_AD9A = 0xFF; }
    wx_link &= ~0x02;
    if (wx_popup && wx_render_popup()) return;          /* 061C08              */
    wx_sel = 0xFF;
    if (wx_link & 0x08) { wx_render_id_entry(); return; }  /* sub_6262A      */
    if (wx_link & 0x04) {
        if (wx_conn_stage < '3') wx_render_s2(); else wx_render_s4();
        return;
    }
    off_61C5A[wx_state]();
}

/* 061D6E-061D7C / 061D7C-061D8A (14 B each)  wx_row_mark_sel, twin
 * [sub_61D6E, sub_61D7C]  Confirmed.  Byte-identical: if the cursor B3F1
 * equals the row being drawn (r1l) latch it into B3EB.  They head the
 * per-row callbacks registered in B288 for sub_5363A.                    */
void wx_row_mark_sel(u8 row) { if (wx_cursor == row) wx_sel = row; }
void wx_row_mark_sel2(u8 row) { if (wx_cursor == row) wx_sel = row; }

/* 061D8A-061D8C (2 B)  nullsub_38 (rts).                                  */

/* ---------------------------------------------------------------------------
 * 061D8C-061DBC (48 B)  wx_busy_popup  [sub_61D8C]  Confirmed
 * 061DBC-061DD2 (22 B)  wx_busy_popup_expired  [sub_61DBC]  Confirmed
 * 061DD2-061E06 (52 B)  wx_busy_popup_gm  [sub_61DD2]  Confirmed
 * 061E06-061E4A (68 B)  wx_result_popup  [sub_61E06]  Confirmed
 * 061E4A-061E58 (14 B)  wx_popup_active  [sub_61E4A]  Confirmed
 * Callers: every page renderer's "request in flight" branch (via the
 *          label 061D8C), 06764C/067786 (61DD2), 067054/0677EA (61E4A).
 * While a request is outstanding the page shows a popup instead of the
 * list.  show_popup(n) = { BBE1 = n; if (FF3D87 != n) { FF3D87 = n;
 * FF3D72 = FF4174; } } (re-send the frame).
 *   61D8C: popup timer FF9599 running -> popup 3 ("waiting"), r4l = 1;
 *          expired -> 61DBC: BC59.b6, popup 0, tone 0x1D, r4l = 0.
 *   61DD2: GM variant: AAD4.b2|b3 or timer -> popup 0x10/0x11/0x12 by
 *          B47B (sub_67734), r4l = 1; else as 61DBC.
 *   61E06: an answer arrived (B311 != 0): if the timer still runs, popup
 *          8 (B311 == '0') or 7 (sub_5EA1C), AA34.b5, FF9538 = 0xFA;
 *          returns 0 either way.
 *   61E4A: r4l = (FF9599 != 0).
 * ------------------------------------------------------------------------- */
static void show_popup(u8 n)
{
    popup_id = n;
    if (sub_popup_sent != n) { sub_popup_sent = n; sub_frame_len = frame_len_saved; }
}
u8 wx_busy_popup(void)                                   /* 061D8C */
{
    if (popup_tmr) { show_popup(3); return 1; }
    return wx_busy_popup_expired();
}
u8 wx_busy_popup_expired(void)                           /* 061DBC */
{
    disp_flags_BC59 |= 0x40; popup_id = 0; tone_ev = 0x1D; return 0;
}
u8 wx_busy_popup_gm(void)                                /* 061DD2 */
{
    if ((aad4_flags & 0x0C) || popup_tmr) { gm_popup_67734(); return 1; }
    disp_flags_BC59 |= 0x40; popup_id = 0; tone_ev = 0x1D; return 0;
}
u8 wx_result_popup(void)                                 /* 061E06 */
{
    if (popup_tmr == 0) return 0;
    disp_flags_BC59 |= 0x40;
    popup_id = (wx_B311 == '0') ? 8 : 7;                /* sub_5EA1C           */
    show_popup(popup_id);
    flags_AA34 |= 0x20; tmr_9538 = 0xFA;
    return 0;
}
u8 wx_popup_active(void) { return popup_tmr ? 1 : 0; }   /* 061E4A */

/* 061E58-061E5E (6 B)  wx_render_home  [sub_61E58]  Confirmed
 * States 0/1: the normal home display (sub_6A32).                        */
void wx_render_home(void) { home_display_6A32(); }

/* Common "request in flight" prologue used by the page renderers below:
 * if no answer yet (B311 == 0): while PTT is held (A9EA == 2) during a
 * PTT-connect (busy.b6) keep the 12 s popup timer up; show the waiting
 * popup (61D8C).  With an answer: result popup (61E06).  If a popup was
 * drawn return; else clear the in-flight bits and draw the page.         */
static u8 wx_inflight_popup(void)
{
    if (wx_B311 == 0) {
        if ((wx_busy & 0x40) && ptt_state == 2) popup_tmr = 0x78;
        return wx_busy_popup();
    }
    return wx_result_popup();
}

/* ---------------------------------------------------------------------------
 * 061E5E-061EEA (140 B)  wx_render_s2  [sub_61E5E]  Confirmed
 * Callers: off_61C5A[2]; wx_render; 0620E2.
 * SEARCH & DIRECT page (F800).  While busy b2/b6 the in-flight popup is
 * drawn instead.  Page: B39F.b1 = 1; WIRES-X view off -> normal home
 * display; on -> sub_6C9E frame header, copy template 0x02C4D6 (word
 * length + body) to FF3DE0, header lines (sub_6E8E4: node/room names
 * B2AF/B2B9) and the target line (sub_6E942).
 * ------------------------------------------------------------------------- */
void wx_render_s2(void)                                  /* 061E5E */
{
    if (wx_busy & 0x44) {
        if (wx_inflight_popup()) return;
        wx_busy &= ~0x44; wx_flags26D &= ~0x02;
    }
    wx_link |= 0x02;                                    /* 061E72              */
    if (!(wx_link & 0x01)) { home_display_6A32(); return; }
    frame_header_6C9E();
    copy_lenpfx(sub_frame /*FF3DE0*/, rom_2C4D6);
    wx_hdr_names_6E8E4();
    wx_target_line_6E942();
}

/* ---------------------------------------------------------------------------
 * 061EEA-061F2C (66 B)  wx_target_line_icon  [sub_61EEA]  Inferred
 * Callers: 06E942.  If the target ID is valid: A9F7.b7 clear; when
 * A9F7.b0 is set, B050 = 0x00010003 and draw the target record's icon
 * (062004 with er1 = FF8D9E: kind '3'/'4' -> sub_627CC else sub_6277E).
 * 061F16 is a second entry with B050 = 0x00010000.
 * ------------------------------------------------------------------------- */
void wx_target_line_icon(void)                           /* 061EEA */
{
    if (!id5_valid(wx_target_id)) return;
    flags_A9F7 &= ~0x80;
    if (!(flags_A9F7 & 0x01)) return;
    draw_attr_B050 = 0x00010003;
    wx_draw_kind_icon(wx_target_rec);                   /* 062004              */
}
void wx_target_line_icon_b(void)                         /* 061F16 */
{
    draw_attr_B050 = 0x00010000;
    wx_draw_kind_icon(wx_target_rec);
}

/* ---------------------------------------------------------------------------
 * 061F2C-061FFE (210 B)  wx_render_s3  [sub_61F2C]  Confirmed
 * 061FFE-06201A (28 B)   wx_draw_kind_icon  [sub_61FFE]  Confirmed
 * Callers: off_61C5A[3], 06201A (61F2C); 061F2C (61FFE), and 062004 is
 * shared with 061EEA.
 * Connected-to-node page (state 3/4 body).  Header as in state 2.  If the
 * target is valid and differs from the room (and B2A7) the target line is
 * drawn (sub_6E942); else the room line: B050 = 0, FF3DF6 = 1, copy the
 * 0x15-byte blank line ROM 02C3CF to B05A, draw the stage icon for B2C8
 * (61FFE), copy 0x15 bytes B05B -> FF3DF7, FF3DF4 = FF3DF5 = 1 and set
 * the page id (sub_B17A: page F800, frame 0xA0).
 * 61FFE: er1 = &B2C8 (or a record): kind '3'/'4' -> room icon
 * (sub_627CC), else node icon (sub_6277E).
 * ------------------------------------------------------------------------- */
void wx_render_s3(void)                                  /* 061F2C */
{
    frame_header_6C9E();
    copy_lenpfx(sub_frame, rom_2C4D6);
    wx_hdr_names_6E8E4();
    if (id5_valid(wx_target_id) && !id5_eq_blank(wx_target_id, wx_room_id)) {
        draw_attr_B050 = 0;  /* 061F8C (word) */
        sub_frame_F6 = 1;                               /* FF3DF6              */
        if (wx_B2A7) { wx_target_line_6E942(); return; }
    } else {
        wx_B2A7 = 0;
    }
    line_len_BBE8 = 0x15;
    memcpy(line_buf_B05A, rom_2C3CF_blank, 0x15);
    wx_draw_kind_icon(&wx_conn_stage);                  /* bsr 61FFE           */
    memcpy(&sub_frame[0x17] /*FF3DF7*/, &line_buf_B05A[1], 0x15);
    sub_frame_F4 = 1; sub_frame_F5 = 1;
    page_F800_B17A();
}
void wx_draw_kind_icon(const u8 *kind /* er1 */)         /* 061FFE / 062004 */
{
    if (*kind == '3' || *kind == '4') draw_room_icon_627CC();
    else                              draw_node_icon_6277E();
}

/* ---------------------------------------------------------------------------
 * 06201A-0620A6 (140 B)  wx_render_s4  [sub_6201A]  Confirmed
 * Callers: off_61C5A[4]; 061BE2, 0624CA.
 * Connected page.  busy.b0 (`]c` room connect outstanding): the in-flight
 * popup with the callback 0620A6 (vestigial er5 argument, doc 101); when
 * it clears, busy.b0 = 0.  busy b2/b6: as wx_render_s2.  Then B39F.b1 = 1
 * and either the home display (view off) or wx_render_s3.
 * ------------------------------------------------------------------------- */
void wx_render_s4(void)                                  /* 06201A */
{
    if (wx_busy & 0x45) {
        if (wx_busy & 0x01) {
            if (wx_busy_popup()) return;                /* er5 = 0620A6 unused */
            wx_busy &= ~0x01;
        } else {
            if (wx_inflight_popup()) return;
            wx_busy &= ~0x44; wx_flags26D &= ~0x02;
        }
    }
    wx_link |= 0x02;
    if (!(wx_link & 0x01)) home_display_6A32(); else wx_render_s3();
}

/* ---------------------------------------------------------------------------
 * 0620B8-0620E2 (42 B)  wx_render_s5  [sub_620B8]  Inferred
 * 0620E2-0620EE (12 B)  wx_goto2_render  [sub_620E2]  Confirmed
 * Callers: off_61C5A[5]; 0620B8 and 0624CA (620E2).
 * State 5 = a transient "result" state.  While AA34.b5 is set (the 2.5 s
 * result window) draw the result line: from state 2 the target line
 * (061F16) else sub_62A5A, then nullsub_32.  When it ends: back to state
 * 2 and draw it (both arms of 0620DC go to 620E2).
 * ------------------------------------------------------------------------- */
void wx_render_s5(void)                                  /* 0620B8 */
{
    if (flags_AA34 & 0x20) {
        if (wx_prev_state == 2) wx_target_line_icon_b(); else wx_result_line_62A5A();
        nullsub_32();
        return;
    }
    wx_goto2_render();
}
void wx_goto2_render(void) { wx_goto_state2(); wx_render_s2(); }   /* 0620E2 */

/* ---------------------------------------------------------------------------
 * 0620EE-062122 (52 B)  wx_render_popup / wx_popup_close  [sub_620EE]
 * Confirmed.  Callers: wx_render (620EE); 062112 is the popup close used by
 * every key handler (jsr sub_62112 / loc_62112).
 * Render: AA34.b5 clear -> close the popup (062112) and return 0.
 * Otherwise draw sub_62A5A + nullsub_33 (r4l != 1) or sub_62A5A +
 * nullsub_32 (r4l == 1, caller's r4l) and return 1.
 * Close (062112): wx_state = B40E (state before the popup), B2A4 = 0.
 * ------------------------------------------------------------------------- */
u8 wx_render_popup(void)                                 /* 0620EE */
{
    if (!(flags_AA34 & 0x20)) { wx_popup_close_62112(); return 0; }
    wx_result_line_62A5A();
    /* r4l (left from the caller: B2A4 value) selects nullsub_33 / _32 */
    return 1;
}
void wx_popup_close_62112(void)                          /* 062112 */
{
    wx_state = wx_prev_state;
    wx_popup = 0;
}

/* ---------------------------------------------------------------------------
 * 062122-062178 (86 B)  wx_render_s6  [sub_62122]  Confirmed
 * Callers: off_61C5A[6]; 0624CA.
 * SEARCH menu page (F813).  While busy.b0 the waiting popup (callback
 * 062178, vestigial).  Else: list destination BC2C = FF3D95, BBE8 = 0x10
 * (row width), row callback B288 = 062186, draw rows (sub_5363A: 5 or more
 * rows from cursor B3F1), FF3D94 = BBFB = selected row, page F813
 * (sub_B302: frame 0x7F; 6 header bytes from ROM C5E0 in PDN with B3E7,
 * else C5DA).
 * ------------------------------------------------------------------------- */
void wx_render_s6(void)                                  /* 062122 */
{
    if (wx_busy & 0x01) {
        if (wx_busy_popup()) return;
        wx_busy &= ~0x01;
    }
    list_dst_BC2C = &sub_frame_raw[0x95 - 0x60];        /* FF3D95              */
    line_len_BBE8 = 0x10;
    row_cb_B288 = wx_row_s6_62186;
    list_draw_5363A();
    sub_frame_raw_94 = wx_sel;                          /* FF3D94              */
    list_sel_BBFB = wx_sel;
    page_F813_B302();
}

/* ---------------------------------------------------------------------------
 * 062186-0621A6 (32 B)  wx_row_s6  [sub_62186]  Confirmed
 * 0621DE-062220 (66 B)  wx_row_cat_name  [sub_621DE]  Confirmed
 * 062220-062236 (22 B)  wx_row_attr_on  [sub_62220]  Confirmed
 * 062236-062240 (10 B)  wx_row_attr1  [sub_62236]  Confirmed
 * Row callback for the SEARCH menu: mark the selected row (061D6E, er5 =
 * 0621DA vestigial), then off_621A6[row]:
 *   0-4 -> 621DE: category bank name = 16 chars at FFAE22 + 16*row (stops
 *          at 0xFF) into B05A; empty -> ROM default 066AF6 (16 B).
 *   5 -> 6222C (B050 = 0x10000 then word 1), 6 -> 62236 (B050 word 1),
 *   7/0xB -> 66CD0, 8 -> 66D22, 9 -> 66D34, 0xA -> 66D58, 0xC -> 66FAA
 *   (the fixed menu labels: ALL, text search, LOCAL NEWS, ...).
 * ------------------------------------------------------------------------- */
void wx_row_s6_62186(u8 row /* r1l */)
{
    wx_row_mark_sel(row);
    off_621A6[row](row);
}
void wx_row_cat_name(u8 row /* r2l */)                   /* 0621DE */
{
    const u8 *s = &wx_settings_AE22[row * 0x10];
    u8 *d = line_buf_B05A, n = 0x10;
    if (*s == 0xFF) { memcpy(d, rom_66AF6_cat_default, 0x10); return; }
    while (n-- && *s != 0xFF) *d++ = *s++;
}
void wx_row_attr_on(void)  { draw_attr_B050 = 0x00010000; *(u16 *)&draw_attr_B050 = 1; } /* 062220 */
void wx_row_attr1(void)    { *(u16 *)&draw_attr_B050 = 1; }                               /* 062236 */

/* ---------------------------------------------------------------------------
 * 062282-0623C6 (324 B)  wx_render_s7  [sub_62282]  Confirmed
 * 0623C6-0623DC (22 B)   wx_row_list_attr  [sub_623C6]  Confirmed
 * 0623DC-062434 (88 B)   wx_list_title  [sub_623DC]  Confirmed
 * 062434-062488 (84 B)   wx_row_s7  [sub_62434]  Confirmed
 * Callers: off_61C5A[7]; 062282 (623DC, 62434 as callback); 0623C6 has no
 * caller in the listings (calls 06244E, inside 62434).
 * List page (F824).  No rows -> in-flight popup or, once it clears, the
 * "no data" popup (sub_624BE).  busy.b4 (page request in flight): popup;
 * on clear, top = previous top (FF1048) and busy.b4 = 0.  busy b2 (or b6
 * without flags26D.b7): popup and clear.  Then: title line (623DC: the
 * search text from FF061A when B26B.b2, else ROM 06226A "ALL" style
 * title, 0x17 B), if B296 != 0 the count "[nnn]" at B06B..B06F
 * (sub_D240), copy 0x17 B to FF3D94, list into FF3DAC with width 0x18 and
 * callback 62434, FF3DAB = selected index relative (sub_9B5A), page F824
 * (sub_B4DA).
 * 62434 (row r1l): B05A = 0; if row < B26A, draw the kind icon of
 * FF104C[row]: '1'..'4' -> room icon (627CC), '5'..'7' -> node icon
 * (6277E).
 * ------------------------------------------------------------------------- */
void wx_render_s7(void)                                  /* 062282 */
{
    if (wx_rows == 0) {                                 /* 062398              */
        if (wx_inflight_popup()) return;
        wx_no_data_popup_624BE();
        return;
    }
    if (wx_busy & 0x10) {                               /* 06235A              */
        if (wx_inflight_popup()) return;
        wx_list_top = wx_list_prev_top;
        wx_busy &= ~0x10;
    } else if ((wx_busy & 0x04) || (!(wx_flags26D & 0x80) && (wx_busy & 0x40))) {
        if (wx_inflight_popup()) return;
        wx_busy &= ~0x44; wx_flags26D &= ~0x02;
    }
    wx_list_title();                                    /* 0622AC              */
    if (wx_B296) {
        fmt_count_D240(wx_B296, &line_buf_B05A[0x12]);  /* B06C                */
        line_buf_B05A[0x11] = '['; line_buf_B05A[0x15] = ']';
    }
    memcpy(&sub_frame_raw_94, line_buf_B05A, 0x17);     /* FF3D94              */
    list_dst_BC2C = (u8 *)0xFF3DAC;
    line_len_BBE8 = 0x18;
    row_cb_B288 = wx_row_s7;
    list_draw_5363A();
    sub_frame_AB = sel_rel_9B5A();                      /* FF3DAB              */
    page_F824_B4DA();
}
void wx_row_list_attr(void)                              /* 0623C6 */
{
    draw_attr_B050 = 0x00010000;
    wx_row_s7_body(wx_sel_row);                         /* 06244E              */
}
void wx_list_title(void)                                 /* 0623DC */
{
    if (wx_req_flags & 0x04) {
        u8 *s = wx_text_buf, *d = line_buf_B05A, n = 0x10;
        memcpy(line_buf_B05A, rom_2C3CF_blank, 0x17);
        while (n-- && *s != 0xFF) *d++ = *s++;
    } else {
        memcpy(line_buf_B05A, rom_6226A_title, 0x17);
    }
}
void wx_row_s7(u8 row)                                   /* 062434 */
{
    line_buf_B05A[0] = 0;
    if (wx_rows == 0) return;
    wx_row_mark_sel2(row);
    if (row >= wx_rows) return;
    wx_row_s7_body(row);
}
static void wx_row_s7_body(u8 row)                       /* 06244E */
{
    u8 k = wx_list_rows[row * 0x32];
    if (k >= '1' && k <= '4')      draw_room_icon_627CC();
    else if (k >= '5' && k <= '7') draw_node_icon_6277E();
}

/* ---------------------------------------------------------------------------
 * 062488-0624BE (54 B)  wx_render_s8  [sub_62488]  Inferred
 * 0624BE-0624CA (12 B)  wx_no_data_popup  [sub_624BE]  Confirmed
 * 0624CA-062514 (74 B)  wx_no_data_return  [sub_624CA]  Confirmed
 * Callers: off_61C5A[8]; 062282/062488/062692/062850 (624BE); 063AAA
 * (624CA, which 624BE falls into).
 * State 8 = "no data / error" notice.  While AA34.b5: from state 6 with
 * B27F < 5 draw sub_628C2, == 5 sub_62220, from 0xA nullsub_35, then
 * nullsub_34.  When it ends (or directly from 624BE: BC59.b6, popup 0)
 * return to the state saved in B40E: 6/0x10 -> search menu, 0xA -> 0xA,
 * 0x13 -> msgbox + 62A32, 4 -> state 4, 2 -> state 2, each redrawn.
 * ------------------------------------------------------------------------- */
void wx_render_s8(void)                                  /* 062488 */
{
    if (!(flags_AA34 & 0x20)) { wx_no_data_popup_624BE(); return; }
    if (wx_prev_state == 6) {
        if (wx_menu6_sel < 5) wx_draw_cat_notice_628C2();
        else if (wx_menu6_sel == 5) wx_row_attr_on();
    } else if (wx_prev_state == 0x0A) {
        nullsub_35();
    }
    nullsub_34();
}
void wx_no_data_popup_624BE(void)                        /* 0624BE */
{
    disp_flags_BC59 |= 0x40; popup_id = 0;
    wx_no_data_return();                                /* falls through       */
}
void wx_no_data_return(void)                             /* 0624CA */
{
    switch (wx_prev_state) {
    case 0x0A: wx_goto_state_A(); wx_render_sA_6267E(); break;
    case 0x13: wx_msgbox_646C8(); wx_render_s13_62A32(); break;
    case 4:    wx_goto_state4();  wx_render_s4();       break;
    case 2:    wx_goto2_render();                       break;
    default:   /* 6, 0x10 and anything else */
               wx_enter_search_menu_keep(); wx_render_s6(); break;
    }
}

/* ---------------------------------------------------------------------------
 * 062514-062568 (84 B)  wx_render_s9  [sub_62514]  Confirmed
 * 062568-06256A (2 B)   nullsub_57 (rts)
 * 06256A-062574 (10 B)  wx_attr7  [sub_6256A]  Confirmed: B050 word = 7.
 * Callers: off_61C5A[9]; 06262A.
 * Text-entry page: busy b2/b4 -> in-flight popup, then clear b2, b4 and
 * flags26D.b1; draw with sub_6E99E (template 0x02C504, cursor AD99, the
 * 16-char text FF061A).
 * ------------------------------------------------------------------------- */
void wx_render_s9(void)                                  /* 062514 */
{
    if (wx_busy & 0x14) {
        if (wx_inflight_popup()) return;
        wx_busy &= ~0x14; wx_flags26D &= ~0x02;
    }
    wx_text_page_6E99E();
}
void wx_attr7(void) { *(u16 *)&draw_attr_B050 = 7; }

/* ---------------------------------------------------------------------------
 * 062598-0625F6 (94 B)  wx_text_line  [sub_62598]  Inferred
 * Callers: none in the listings (a row callback).  Copies 16 chars from
 * FF061A (+r2l = 0) to B070 and prints them (sub_5E468) with B050 word 2,
 * then B050 = 0, then 0x13.  The leading 'bld #2,r0h' and both arms of the
 * AD99 test reach 0625D0, so the cursor test has no effect.
 * ------------------------------------------------------------------------- */
void wx_text_line(void)                                  /* 062598 */
{
    memcpy(line_buf_B05A + 0x16 /*B070*/, wx_text_buf, 0x10);
    *(u16 *)&draw_attr_B050 = 2;
    copy_until_ff_5E468(/*from*/ line_buf_B05A + 0x16, /*n*/ 0x10);
    *(u16 *)&draw_attr_B050 = 0;
    *(u16 *)&draw_attr_B050 = 0x13;
}

/* ==========================================================================
 * Part 3: 06262A-063BB8  remaining mode-9 page renderers, the `]` WIRES-X
 * request builders (DSP message types 0x0D-0x15, 0x1D), the periodic
 * poller and the node-answer handlers.
 * ========================================================================== */

/* ---------------------------------------------------------------------------
 * 06262A-06267E (84 B)  wx_render_id_entry  [sub_6262A]  Confirmed
 * Callers: wx_render (ID entry), 061BE2.
 * ID-entry page: busy b2/b4 -> in-flight popup, then clear b2, b4,
 * flags26D.b1; then the text page (wx_render_s9, 062514).
 * ------------------------------------------------------------------------- */
void wx_render_id_entry(void)                            /* 06262A */
{
    if (wx_busy & 0x14) {
        if (wx_inflight_popup()) return;
        wx_busy &= ~0x14; wx_flags26D &= ~0x02;
    }
    wx_render_s9();
}

/* 06267E-062690 (18 B)  wx_render_sA  [sub_6267E]  Confirmed
 * State 0xA (search confirm): row callback B288 = nullsub_46, draw with
 * sub_52AE8 (the SEARCH / EDIT / CANCEL button page).                    */
void wx_render_sA_6267E(void)
{
    row_cb_B288 = nullsub_46;
    button_page_52AE8();
}
/* 062690-062692 (2 B)  nullsub_17 (rts).                                  */

/* ---------------------------------------------------------------------------
 * 062692-062722 (144 B)  wx_render_sB  [sub_62692]  Confirmed
 * Callers: off_61C5A[0xB].
 * LOCAL NEWS list page (F810): no rows -> waiting popup, then "no data";
 * busy.b4 (page request) -> popup, then top = FF1048; busy.b0 (`]c`) ->
 * popup (callback 062990), then clear.  Draw: BC2C = FF3D95, width 0x18,
 * row callback 062730, sub_5363A, FF3D94 = relative selection, page id via
 * sub_B23E.  (The er5 callbacks 062722/062990 passed to 061D8C are not
 * used by it; doc 101 calls 062722 a vestigial handler.)
 * ------------------------------------------------------------------------- */
void wx_render_sB(void)                                  /* 062692 */
{
    if (wx_rows == 0) {
        if (wx_busy_popup()) return;
        wx_no_data_popup_624BE(); return;
    }
    if (wx_busy & 0x10) {
        if (wx_busy_popup()) return;
        wx_list_top = wx_list_prev_top; wx_busy &= ~0x10;
    } else if (wx_busy & 0x01) {
        if (wx_busy_popup()) return;
        wx_busy &= ~0x01;
    }
    list_dst_BC2C = (u8 *)0xFF3D95;
    line_len_BBE8 = 0x18;
    row_cb_B288 = wx_row_sB;
    list_draw_5363A();
    sub_frame_raw_94 = sel_rel_9B5A();
    page_news_B23E();
}

/* ---------------------------------------------------------------------------
 * 062730-06277E (78 B)  wx_row_sB  [sub_62730]  Confirmed
 * 06277E-0627BE (64 B)  draw_node_icon  [sub_6277E]  Confirmed
 * 0627BE-0627CC (14 B)  wx_row_sB_first  [sub_627BE]  Confirmed
 * 0627CC-062820 (84 B)  draw_room_icon  [sub_627CC]  Confirmed
 * Callers: row callback (62730); 6277E/627CC from many renderers
 * (061FFE, 062434, 062990, 062A5A, 066F26); 627BE from 062730.
 * er1 = 0x32-byte list record (or the 0x31-byte "current" record B2C8 /
 * FF8D9E / B34E).  B05A[0] = 1 (row present), then:
 *   node row (6277E): 16 chars of name at rec+6, ' ', and if rec[0x16]
 *       != 0 the 3-char member count from rec+0x16 (sub_62820, leading
 *       '0's blanked) else the time/status field (sub_6EDE8).
 *   room row (627CC): 10 chars at rec+6, ' ', 10 chars at rec+0x23
 *       (room name + city/comment).
 * 062730: on page 1 row 0 is the room line (627BE), and a 1-row page
 * shows nothing more.  062808/0E/14/1A are jsr stubs to the node-command
 * leaf handlers 066FB4/067250/06726A/066FAA (doc 101).
 * ------------------------------------------------------------------------- */
void wx_row_sB(u8 row)                                   /* 062730 */
{
    line_buf_B05A[0] = 0;
    if (wx_rows == 0) return;
    wx_row_mark_sel2(row);
    if (row >= wx_rows) return;
    if (wx_list_top == 0) return;
    if (wx_list_top == 1) {
        if (row == 0) { draw_room_icon_627CC_rec(&wx_list_rows[0]); return; } /* 0627BE */
        if (wx_rows == 1) return;
    }
    draw_node_icon_6277E_rec(&wx_list_rows[row * 0x32]);
}
void draw_node_icon_6277E_rec(const u8 *rec)             /* 06277E */
{
    u8 *d = &line_buf_B05A[1];
    line_buf_B05A[0] = 1;
    memcpy(d, rec + 6, 0x10); d += 0x10;
    *d++ = ' ';
    if (rec[0x16]) { *d++ = ' '; fmt_count3_62820(rec + 0x16, d); }
    else           status_field_6EDE8();
}
void draw_room_icon_627CC_rec(const u8 *rec)             /* 0627CC */
{
    u8 *d = &line_buf_B05A[1];
    line_buf_B05A[0] = 1;
    memcpy(d, rec + 6, 0x0A); d += 0x0A;
    *d++ = ' ';
    memcpy(d, rec + 0x23, 0x0A);
}

/* 062820-062850 (48 B)  fmt_count3  [sub_62820]  Confirmed
 * Copies a 3-digit ASCII count from *er5 to er6[0..2], blanking leading
 * '0's (only the first two positions).                                    */
void fmt_count3_62820(const u8 *s, u8 *d)
{
    u8 a, b, c;
    if (s[0] != '0') { a = s[0]; b = s[1]; c = s[2]; }
    else {
        a = ' ';
        if (s[1] != '0') { b = s[1]; c = s[2]; } else { b = ' '; c = s[2]; }
    }
    d[0] = a; d[1] = b; d[2] = c;
}

/* ---------------------------------------------------------------------------
 * 062850-0628C2 (114 B)  wx_render_s10  [sub_62850]  Confirmed
 * 0628C2-0628DA (24 B)   wx_cat_title  [sub_628C2]  Confirmed
 * 0628DA-062904 (42 B)   wx_row_s10  [sub_628DA]  Confirmed
 * Callers: off_61C5A[0x10]; 062488/062850 (628C2); 06EC30 (628DA).
 * Category list page (F823): no rows -> popup (callback 628C2) then "no
 * data"; busy b2 or (b6 without flags26D.b7) -> popup and clear; then
 * sub_6EC30.  628C2: B050 = 0x10000, category name of bank B270
 * (069F58).  628DA: row callback; rows < B26A draw via 06244E.
 * ------------------------------------------------------------------------- */
void wx_render_s10(void)                                 /* 062850 */
{
    if (wx_rows == 0) {
        if (wx_busy_popup()) return;
        wx_no_data_popup_624BE(); return;
    }
    if ((wx_busy & 0x04) || (!(wx_flags26D & 0x80) && (wx_busy & 0x40))) {
        if (wx_inflight_popup()) return;
        wx_busy &= ~0x44; wx_flags26D &= ~0x02;
    }
    wx_cat_page_6EC30();
}
void wx_draw_cat_notice_628C2(void)                      /* 0628C2 */
{
    draw_attr_B050 = 0x00010000;
    cat_draw_name_69F58(wx_cat_bank);
}
void wx_row_s10(u8 row)                                  /* 0628DA */
{
    line_buf_B05A[0] = 0;
    if (wx_rows == 0) return;
    wx_row_mark_sel2(row);
    if (row >= wx_rows) return;
    line_buf_B05A[0] = 1;
    wx_row_s7_body(row);                                /* 06244E              */
    /* 0628FE: jsr sub_66FAA stub (unreached tail) */
}

/* 062904-062916 (18 B)  wx_render_s11  [sub_62904]  Confirmed
 * Category screen: open category -> sub_6EAC4, else bank list sub_6EA54. */
void wx_render_s11(void)
{
    if (wx_cat_open) wx_cat_entries_6EAC4(); else wx_cat_banks_6EA54();
}

/* 062916-062938 (34 B)  wx_row_cat  [sub_62916]  Confirmed
 * Callers: 06EA54 (row callback).  If B3F5 == row, B3F4 = row; then
 * off_62938[row]: 0-4 -> 621DE (bank name), 5 -> 66CD0, 6 -> 66FAA.     */
void wx_row_cat(u8 row)
{
    if (wx_cat_cursor == row) wx_cat_item = row;
    off_62938[row](row);
}

/* ---------------------------------------------------------------------------
 * 062954-062990 (60 B)  wx_render_s12  [sub_62954]  Confirmed
 * 062990-0629B4 (36 B)  wx_draw_open_rec  [sub_62990]  Confirmed
 * Callers: off_61C5A[0x12]; 062692 and 06EB60 (62990).
 * News content menu (F811): while busy.b0 popup; when it clears copy the
 * 5-byte key B32E -> B324 and clear busy.b0; then sub_6EB60.
 * 62990: B050 = 0x10000; draw the opened record B34E as a node row if
 * B34E[0] != 0 else as a room row.
 * ------------------------------------------------------------------------- */
void wx_render_s12(void)                                 /* 062954 */
{
    if (wx_busy & 0x01) {
        if (wx_busy_popup()) return;
        memcpy(&wx_B324, wx_B32E, 5);
        wx_busy &= ~0x01;
    }
    wx_news_menu_6EB60();
}
void wx_draw_open_rec(void)                              /* 062990 */
{
    draw_attr_B050 = 0x00010000;
    if (wx_open_rec[0]) draw_node_icon_6277E_rec(wx_open_rec);
    else                draw_room_icon_627CC_rec(wx_open_rec);
}

/* 0629EA-0629FC (18 B)  wx_render_upload_page  [sub_629EA]  Confirmed
 * Callers: 0677EA; off_61C5A[0x2B].  FF3D94 = cursor, page via sub_B35C. */
void wx_render_upload_page(void)
{
    sub_frame_raw_94 = wx_cursor;
    page_B35C();
}

/* 062A32-062A5A (40 B)  wx_render_s13  [sub_62A32]  Confirmed
 * Callers: off_61C5A[0x13]; 0624CA, 0679E4, 06ECEA.  While busy.b0 popup;
 * on clear sub_646DA and clear busy.b0; then sub_6EBC8.                  */
void wx_render_s13_62A32(void)
{
    if (wx_busy & 0x01) {
        if (wx_busy_popup()) return;
        wx_news_got_646DA();
        wx_busy &= ~0x01;
    }
    wx_news_item_6EBC8();
}

/* 062A5A-062A80 (38 B)  wx_result_line  [sub_62A5A]  Confirmed
 * Callers: 0620B8, 0620EE, 06EA54, 06EBC8.  B050 = 0x10000; draw the
 * current room record (B2C8) as node row if B26F.b0 else as room row.   */
void wx_result_line_62A5A(void)
{
    draw_attr_B050 = 0x00010000;
    if (wx_B26F & 0x01) draw_node_icon_6277E_rec(&wx_conn_stage);
    else                draw_room_icon_627CC_rec(&wx_conn_stage);
}

/* ===========================================================================
 * The `]` request builders.  Each one queues a WIRES-X control message for
 * the DSP (B0B9 = message type, body at FF0C3D, terminated by 0xFF) and
 * keys the radio (sub_22FEE -> sub_2244C), or in PDN arms DSP session 0x17
 * (sub_6D052) instead (doc 86 sec. 2).  Shared prologue:
 *     AAD4.b0 = 0;  if (tx_state == 1) fail;  if (!dn_ready_22F78()) fail;
 *     if (sw_tx_request_22FEE()) fail;  AAD4.b0 = 1;
 * and epilogue wx_msg_commit (sub_631C4).  The result is returned as
 * "AAD4.b0 set" (Z clear = sent).  Air letters per doc 86.
 * ======================================================================== */
static u8 wx_msg_begin(void)
{
    aad4_flags &= ~0x01;
    if (tx_state == 1)        return 0;
    if (!dn_ready_22F78())    return 0;                 /* Z -> fail           */
    if (sw_tx_request_22FEE()) return 0;                /* nz -> fail          */
    aad4_flags |= 0x01;
    return 1;
}
/* dest + node: WIRES-X mode (B2A5 == 2) sends B314[0..4] + the node ID
 * B2AA; mode 10 sends the 10 bytes of B314 (ID + ROM 067FA4).            */
static u8 *wx_put_dest(u8 *p)
{
    if (wx_app_kind == 2) { memcpy(p, wx_req_id, 5); memcpy(p + 5, wx_node_id, 5); }
    else                    memcpy(p, wx_req_id, 10);
    return p + 10;
}

/* ---------------------------------------------------------------------------
 * 062ACA-062B46 (124 B)  wx_send_room_c  [sub_62ACA]  Confirmed
 * 062B46-062B7A (52 B)   wx_send_room_c_tail  [sub_62B46]  Confirmed
 * Callers: 060554, 06073C, 060BBA (via loc_62AC9+1).
 * `]c` (B0B9 = 0x0D): connect to a room / open an item.  Clears the key
 * B324..B328 and busy.b0 first; on success busy.b0 = "`]c` outstanding",
 * BC59.b7 redraw.
 * ------------------------------------------------------------------------- */
u8 wx_send_room_c(void)                                  /* 062ACA */
{
    u8 *p;
    wx_B324 = 0; wx_B328 = 0;
    wx_busy &= ~0x01;
    if (!wx_msg_begin()) return 0;
    dsp_msg_type = 0x0D;                                /* B0B9                */
    p = wx_put_dest(dsp_msg_body);                      /* FF0C3D              */
    *p = 0xFF;
    wx_busy |= 0x01;
    wx_msg_commit();
    disp_flags_BC59 |= 0x80;
    return 1;
}

/* ---------------------------------------------------------------------------
 * 062B7A-062C32 (184 B)  wx_send_list_l  [sub_62B7A]  Confirmed
 * Callers: 065854, 065974, 065BA6.
 * `]l` (B0B9 = 0x0E): dest + the 9-byte argument B299, busy.b1.  Clears
 * busy.b1 and B275.b5 first.
 * ------------------------------------------------------------------------- */
u8 wx_send_list_l(void)                                  /* 062B7A */
{
    u8 *p;
    wx_busy &= ~0x02; wx_B275 &= ~0x20;
    if (!wx_msg_begin()) return 0;
    dsp_msg_type = 0x0E;
    p = wx_put_dest(dsp_msg_body);
    memcpy(p, wx_B299, 9); p += 9;
    *p = 0xFF;
    wx_busy |= 0x02;
    wx_msg_commit();
    disp_flags_BC59 |= 0x80;
    return 1;
}

/* ---------------------------------------------------------------------------
 * 062C32-062DA4 (370 B)  wx_send_read_r  [sub_62C32]  Confirmed
 * Callers: 065AF0, 065D1C, 065EC2 (touch handlers; doc 86 census
 *          "] 'r' (incl. DNEWS)").
 * `]r` (B0B9 = 0x0F): read item r1l of the news index.  Item record =
 * FEFDC8 + 0x2F*r1l; its 5-byte key -> B31E.  Destination: "DNEWS" when
 * B26B.b4 (local news), the opened record's ID B34F when B26E == 2, else
 * the room B2C9; + ROM 067FA4.  Body = dest + key(5) + 0xFF.  busy.b3 is
 * the outstanding flag (b7 also cleared).
 * ------------------------------------------------------------------------- */
u8 wx_send_read_r(u8 item /* r1l */)                     /* 062C32 */
{
    u8 *p; const u8 *rec = &news_index_FEFDC8[item * 0x2F];
    memcpy(wx_B31E, rec, 5);
    if (wx_req_flags & 0x10)        memcpy(wx_req_id, "DNEWS", 5);
    else if (wx_menu_origin == 2)   memcpy(wx_req_id, &wx_open_rec[1], 5);
    else                            memcpy(wx_req_id, wx_room_id, 5);
    memcpy(wx_req_id + 5, rom_67FA4, 5);
    wx_busy &= ~0x88;
    if (!wx_msg_begin()) return 0;
    dsp_msg_type = 0x0F;
    p = wx_put_dest(dsp_msg_body);
    memcpy(p, wx_B31E, 5); p += 5;
    *p = 0xFF;
    wx_busy |= 0x08;
    wx_msg_commit();
    disp_flags_BC59 |= 0x80;
    return 1;
}

/* ---------------------------------------------------------------------------
 * 062DA4-062E14 (112 B)  wx_send_search_q  [sub_62DA4]  Confirmed
 * Callers: wx_enter (05FCEC), wx_poll (0632CC), 06D0F6.
 * `]q` (B0B9 = 0x12): "who is the node" query sent on entry.  In PDN only
 * when B3E4 == 4, through DSP session 0x17 (sub_6D052).  B12F = 1, body =
 * the 10 ROM bytes at 0x004C14 + 0xFF (doc 86 C2).  No busy bit.
 * ------------------------------------------------------------------------- */
u8 wx_send_search_q(void)                                /* 062DA4 */
{
    u8 *p;
    if (node_mode & 0x80) {
        if (pdn_state != 4) return 0;      /* returns AAD4.b0 as left: Inferred 0 */
        if (!pdn_session17_6D052()) return aad4_flags & 0x01;
    } else if (!wx_msg_begin()) {
        return 0;
    }
    wx_B12F = 1;
    dsp_msg_type = 0x12;
    p = dsp_msg_body; memcpy(p, rom_4C14, 10); p += 10; *p = 0xFF;
    wx_msg_commit();
    return aad4_flags & 0x01;
}

/* ---------------------------------------------------------------------------
 * 062E14-062EAC (152 B)  wx_send_connect_hash  [sub_62E14]  Confirmed
 * Callers: 060354, 06087E, 060CFC.
 * `]#` (B0B9 = 0x13): connect to node/room B314.  Clears busy.b2,
 * flags26D.b1, B311 (answer code); PDN via session 0x17.  B349 = the ID
 * asked for (matched against the answer by sub_63858).  Body = B314[10] +
 * 0xFF.  busy.b2 = connect outstanding.
 * ------------------------------------------------------------------------- */
u8 wx_send_connect_hash(void)                            /* 062E14 */
{
    u8 *p;
    wx_busy &= ~0x04; wx_flags26D &= ~0x02; wx_B311 = 0;
    if (node_mode & 0x80) { if (!pdn_session17_6D052()) return aad4_flags & 0x01; }
    else if (!wx_msg_begin()) return 0;
    memcpy(wx_pend_id, wx_req_id, 5);
    dsp_msg_type = 0x13;
    p = dsp_msg_body; memcpy(p, wx_req_id, 10); p += 10; *p = 0xFF;
    wx_busy |= 0x04;
    wx_msg_commit();
    disp_flags_BC59 |= 0x80;
    return aad4_flags & 0x01;
}

/* ---------------------------------------------------------------------------
 * 062EAC-062F64 (184 B)  wx_send_connect_num  [sub_62EAC]  Confirmed
 * Callers: 061B4C (DIRECT ID entry).
 * `]#` (0x13) with the typed 5-digit number B3A3 + ROM 0x004C14[0..4];
 * also sets flags26D.b1 ("connect by number").
 * ------------------------------------------------------------------------- */
u8 wx_send_connect_num(void)                             /* 062EAC */
{
    u8 *p;
    wx_busy &= ~0x04; wx_flags26D &= ~0x02; wx_B311 = 0;
    if (node_mode & 0x80) { if (!pdn_session17_6D052()) return aad4_flags & 0x01; }
    else if (!wx_msg_begin()) return 0;
    memcpy(wx_pend_id, &wx_id_entry_m1[2], 5);
    dsp_msg_type = 0x13;
    p = dsp_msg_body;
    memcpy(p, &wx_id_entry_m1[2], 5); memcpy(p + 5, rom_4C14, 5); p += 10;
    *p = 0xFF;
    wx_busy |= 0x04; wx_flags26D |= 0x02;
    wx_msg_commit();
    disp_flags_BC59 |= 0x80;
    return aad4_flags & 0x01;
}

/* 062F64-062FC6 (98 B)  wx_send_star  [sub_62F64]  Confirmed
 * Callers: 0663CA.  `]*` (B0B9 = 0x1D): body = ROM 0x004C14[10] + 0xFF;
 * no busy bit, no redraw (doc 86: disconnect-type request, Inferred).   */
u8 wx_send_star(void)
{
    u8 *p;
    if (node_mode & 0x80) { if (!pdn_session17_6D052()) return aad4_flags & 0x01; }
    else if (!wx_msg_begin()) return 0;
    dsp_msg_type = 0x1D;
    p = dsp_msg_body; memcpy(p, rom_4C14, 10); p += 10; *p = 0xFF;
    wx_msg_commit();
    return aad4_flags & 0x01;
}

/* ---------------------------------------------------------------------------
 * 062FC6-063040 (122 B)  wx_send_list_f  [sub_62FC6]  Confirmed
 * Callers: 060656, 060936, 060AF0, 060FE0.
 * `]f` (B0B9 = 0x14): list/search request.  Body = the 0x15-byte block
 * B334 (kind byte: 0x80/'1' name search/'A' news..., start index "nnn" at
 * B336, search text at B339) + 0xFF.  busy.b4 = list request outstanding;
 * B311 cleared.
 * ------------------------------------------------------------------------- */
u8 wx_send_list_f(void)                                  /* 062FC6 */
{
    u8 *p;
    wx_busy &= ~0x10; wx_B311 = 0;
    if (node_mode & 0x80) { if (!pdn_session17_6D052()) return aad4_flags & 0x01; }
    else if (!wx_msg_begin()) return 0;
    dsp_msg_type = 0x14;
    p = dsp_msg_body; memcpy(p, wx_list_req, 0x15); p += 0x15; *p = 0xFF;
    wx_busy |= 0x10;
    wx_msg_commit();
    disp_flags_BC59 |= 0x80;
    return aad4_flags & 0x01;
}

/* ---------------------------------------------------------------------------
 * 063040-0630E8 (168 B)  wx_send_cat_g  [sub_63040]  Confirmed
 * 0630E8-0631B8 (208 B)  wx_send_cat_g_tail  [sub_630E8]  Confirmed
 * Callers: 060656 (search menu items 0-4).
 * `]g` (B0B9 = 0x15): ask the node for the status of every ID in the
 * opened category bank.  A 5-byte prefix (ROM 0631B8 if FF8D8F == 0,
 * else 0631BE; both 6-byte strings) goes to B334 and the body, then the
 * 2-char count word_5E08A[B272] (ASCII "nn", Inferred), then the IDs.
 * FF8D8F == 0: each used entry of FFB5B8 (20 x 0x18) is placed at
 * FF0C44 + 5*entry[0x16] (its slot number); else they are packed in
 * order.  Terminator after B272 IDs; busy.b5 outstanding.
 * ------------------------------------------------------------------------- */
u8 wx_send_cat_g(void)                                   /* 063040 */
{
    u8 *p, n, *e;
    wx_busy &= ~0x20;
    if (node_mode & 0x80) { if (!pdn_session17_6D052()) return aad4_flags & 0x01; }
    else if (!wx_msg_begin()) return 0;
    dsp_msg_type = 0x15;
    if (wx_cat_mode_8D8F == 0) {
        memcpy(wx_list_req, rom_631B8, 5); memcpy(dsp_msg_body, rom_631B8, 5);
        p = dsp_msg_body + 5;
        *p++ = word_5E08A[wx_cat_count] >> 8; *p++ = (u8)word_5E08A[wx_cat_count];
        for (n = wx_cat_count, e = wx_cat_list; n; n--, e += 0x18)   /* 0630E8 */
            if (e[0] != 0xFF) memcpy(&dsp_msg_body[7 + 5 * e[0x16]], e, 5);
        p = &dsp_msg_body[7 + 5 * wx_cat_count];
    } else {                                            /* 063126              */
        memcpy(wx_list_req, rom_631BE, 5); memcpy(dsp_msg_body, rom_631BE, 5);
        p = dsp_msg_body + 5;
        *p++ = word_5E08A[wx_cat_count] >> 8; *p++ = (u8)word_5E08A[wx_cat_count];
        for (n = wx_cat_count, e = wx_cat_list; n; n--, e += 0x18)
            if (e[0] != 0xFF) { memcpy(p, e, 5); p += 5; }
    }
    *p = 0xFF;                                          /* 06319C              */
    wx_busy |= 0x20;
    wx_msg_commit();
    disp_flags_BC59 |= 0x80;
    return aad4_flags & 0x01;
}

/* ---------------------------------------------------------------------------
 * 0631C4-063216 (82 B)  wx_msg_commit  [sub_631C4]  Confirmed
 * Callers: every builder above (8 sites) and 062B46.
 * If FF8997 != 0 (a beep-on-send setting, Inferred) AAD4.b7 and tone
 * B312.  B12E = 0, B273 = state at send, B274 = B287 = 0.  Build the
 * ']' message header (sub_5CAF0, letter 0x5D) and store its length
 * (er6 - FF0206) in B1C3, body pointer B1D0 = FF0C3D, and the 12 s reply
 * timer FF9599 = 0x78.
 * ------------------------------------------------------------------------- */
void wx_msg_commit(void)                                 /* 0631C4 */
{
    u8 *end;
    if (cfg_8997 != 0) { aad4_flags |= 0x80; tone_ev = wx_B312; }
    wx_B12E = 0;
    wx_sent_state = wx_state;                           /* B273                */
    wx_B274 = 0; wx_B287 = 0;
    end = dsp_msg_header_5CAF0();                       /* letter ']'          */
    dsp_msg_len_B1C3 = (u8)(end - (u8 *)0xFF0206);
    dsp_msg_ptr_B1D0 = dsp_msg_body;
    popup_tmr = 0x78;                                   /* 12 s reply timeout  */
}

/* ---------------------------------------------------------------------------
 * 063216-0632F4 (222 B)  wx_poll  [sub_63216]  Confirmed
 * Callers: main loop 002E60, 002F7E.
 * WIRES-X background poll.  PDN with B3E4 == 4 runs sub_6D0F6 first.  Only
 * in WIRES-X proper (B2A5 == 2).  B26B.b6 is a one-shot skip.  While not
 * transmitting: a received node message letter (B267, or B3FA in PDN via
 * sub_583F2) is dispatched: 'A' -> 063590, 'B' -> 063582, 'Q' -> 0633A0,
 * 'R' -> 063390, 'F' -> 063904, others -> sub_68E9A.  Else the GM ACK /
 * delivery pollers (sub_68304 on B3FA, sub_68242).  Then: state != 1 ->
 * wx_timers (sub_63304).  State 1 (searching): when FF95E4 expires, if
 * B26B.b7 (deferred search after the DN move) send `]q` now and re-arm
 * 30 s; otherwise give up: tone 0x1D, 817E.b1, wx_exit().
 * ------------------------------------------------------------------------- */
void wx_poll(void)                                       /* 063216 */
{
    u8 c;
    if ((node_mode & 0x80) && pdn_state == 4) pdn_poll_6D0F6();
    if (wx_app_kind != 2) return;
    if (wx_req_flags & 0x40) { wx_req_flags &= ~0x40; return; }
    if (node_mode & 0x80) {
        if (tx_state == 1) return;
        if (wx_B3FA == 0) goto timers_gm;
        c = pdn_rx_letter_583F2();
        goto dispatch;
    }
    if (tx_state == 1) return;
    if (wx_rx_letter == 0) {                            /* B267                */
        if (tx_state == 1) return;
        if (wx_B3FA) { wx_B3FA = 0; gm_rx_ack_68304(); }
        goto timers_gm;
    }
    c = wx_rx_letter; wx_rx_letter = 0;
dispatch:
    switch (c) {
    case 'A': wx_rx_A_63590(); return;
    case 'B': wx_rx_B_63582(); return;
    case 'Q': wx_rx_Q_633A0(); return;
    case 'R': wx_rx_R_63390(); return;
    case 'F': wx_rx_F_63904(); return;
    default:  wx_rx_other_68E9A(); return;
    }
timers_gm:
    gm_ack_poll_68242();                                /* 0632AE              */
    if (wx_state != 1) { wx_timers(); return; }
    if (wx_search_tmr != 0) return;
    if ((wx_req_flags & 0x80) && wx_send_search_q()) {
        wx_req_flags &= ~0x80;
        wx_search_tmr = 0x12C;
        return;
    }
    tone_ev = 0x1D;
    flags_817E |= 0x02;
    wx_exit();
}

/* 0632F4-063304 (16 B)  wx_keep_popup_on_ptt  [sub_632F4]  Confirmed
 * Callers: 035A8C (TX path).  busy.b6 -> popup timer 12 s.               */
void wx_keep_popup_on_ptt(void) { if (wx_busy & 0x40) popup_tmr = 0x78; }

/* ---------------------------------------------------------------------------
 * 063304-063360 (92 B)  wx_timers  [sub_63304]  Confirmed
 * Callers: wx_poll, 06802A.
 * State 0x29 with PTT held (A9EA == 2) and FF959B expired -> fire the held
 * transmission (sub_61624).  States 0x17 (B266.b2) / 0x28 (B266.b3): when
 * B111 != 0 and B266.b1 not yet set: 817E.b1, FF959C = 7 (0.7 s), B266.b1.
 * Always ends in 06DBE2 (PDN/GM timer tail).
 * ------------------------------------------------------------------------- */
void wx_timers(void)                                     /* 063304 */
{
    u8 s = wx_state;
    if (s == 0x29) {
        if (ptt_state == 2 && hold_tmr_959B == 0) wx_hold_tx_fire();
    } else if ((s == 0x17 && (wx_B266 & 0x04)) || (s == 0x28 && (wx_B266 & 0x08))) {
        if (ram_B111 && !(wx_B266 & 0x02)) {
            flags_817E |= 0x02; tmr_959C = 7; wx_B266 |= 0x02;
        }
    }
    timer_tail_6DBE2();
}

/* 063360-063390 (48 B)  wx_upload_timeout_tone  [sub_63360]  Confirmed
 * Callers: 035A04 (TX path).  States 0x1C/0x1D with PTT held: when the
 * 60 s FF95E6 runs out, once (B275.b4) play tone 0x5B.                    */
void wx_upload_timeout_tone(void)
{
    if (wx_state != 0x1C && wx_state != 0x1D) return;
    if (ptt_state != 2) return;
    if (wx_tx_tmr_95E6 != 0) return;
    if (wx_B275 & 0x10) return;
    wx_B275 |= 0x10;
    tone_ev = 0x5B;
}

/* ---------------------------------------------------------------------------
 * 06345E-0634A4 (70 B)  wx_rx_node_info  [sub_6345E]  Confirmed
 * 0634A4-063514 (112 B) wx_store_node_info  [sub_634A4]  Confirmed
 * 063514-063552 (62 B)  wx_store_node_pos  [sub_63514]  Confirmed
 * Callers: 06345E is reached from the node-answer code (not listed);
 *          634A4 from 06345E; 63514 from 0634A4 and 063552.
 * er1 -> received node record (0x66 bytes).  634A4 copies it to B2AA..
 * (node ID, names, B2C8 room block ...), then unless FF0BF8 & 0x38, tunes
 * (sub_25A8A; refuse -> 1) and sub_1CDBA; parses the DG-ID / channel field
 * (sub_4B812 into B302; negative or >= 0x7F -> 1): nonzero -> B130 = 1,
 * B131 = value, else B130 = 0; B39D = value; stores the node position
 * (63514: B310 flag -> A856, 15 bytes er1 -> A857, 12 bytes er1-0x12 ->
 * A866) and sets B0AA.b7.  Returns 0 on success.
 * 6345E: on success clear B26B.b0, B314 = blank+067FA4, tone 0x55,
 * 817E.b1, and enter SEARCH & DIRECT with the link up (sub_603C8).
 * ------------------------------------------------------------------------- */
void wx_rx_node_info(const u8 *rec /* er1 */)            /* 06345E */
{
    if (wx_store_node_info(rec)) return;
    wx_req_flags &= ~0x01;
    memcpy(wx_req_id, rom_67FAA_blank, 5);
    memcpy(wx_req_id + 5, rom_67FA4, 5);
    tone_ev = 0x55;
    flags_817E |= 0x02;
    wx_set_linked_goto2();
}
u8 wx_store_node_info(const u8 *rec)                     /* 0634A4 */
{
    s16 v;
    memcpy(wx_node_id, rec, 0x66);                      /* B2AA..B30F          */
    if (!(dsp_rx_0BF8 & 0x38)) {
        if (tune_25A8A()) return 1;
        retune_1CDBA();
    }
    v = parse_field_4B812(rec, wx_B302);
    if (v < 0) return 1;
    wx_B39D = (u8)v;
    if ((u16)v >= 0x7F) return 1;
    if (v) { wx_addr_mode = 1; wx_addr_dgid = (u8)v; } else wx_addr_mode = 0;
    wx_store_node_pos(rec);
    flags_B0AA |= 0x80;
    return 0;
}
void wx_store_node_pos(const u8 *rec)                    /* 063514 */
{
    pos_flag_A856 = wx_B310;
    if (wx_B310 == 0) return;
    memcpy(pos_A857, rec, 0x0F);
    memcpy(pos_A866, rec - 0x12, 0x0C);
}

/* 063552-063582 (48 B)  wx_rx_node_update  [sub_63552]  Confirmed
 * er1 = node ID in the message, er2 = room block.  Only when linked
 * (B2C8 >= '3') and er1 == B2AA: refresh the position, and if the room
 * block kind is '2' (disconnected, Inferred) run sub_6363C.              */
void wx_rx_node_update(const u8 *id, const u8 *room)
{
    if (wx_conn_stage < '3') return;
    if (memcmp(id, wx_node_id, 5) != 0) return;
    wx_store_node_pos(id);
    if (room[0] == '2') wx_room_lost_6363C();
}

/* ---------------------------------------------------------------------------
 * 0635EE-06363C (78 B)  wx_rx_conn_fail  [sub_635EE]  Confirmed
 * 06363C-0636B2 (118 B) wx_room_lost  [sub_6363C]  Confirmed
 * Callers: none listed for 635EE (node-answer code); 063552, 0635EE (6363C).
 * A failed connect (busy b2/b6 outstanding, or a name search from states
 * 7/9 with busy.b4 and B26B.b2): B2C8 = '2', B311 = r3l (answer code),
 * tone 0x58, 817E.b1, popup timer 2.5 s (0x19).  Otherwise 6363C.
 * 6363C (only when B2C8 >= '3'): the room link is gone.  In the news /
 * content states (0xB, 0x12, 0x14..0x31 with B26B.b4, or B26E == 2) keep
 * the screen (B26E = 2) and clear B26B.b5; otherwise reset the session
 * (sub_5FD1C) and go to SEARCH & DIRECT.  B2C8 = '2', B40E = state,
 * tone 0x57, AA34.b5, FF9538 = 2.5 s, popup 6.
 * ------------------------------------------------------------------------- */
void wx_rx_conn_fail(u8 code /* r3l */)                  /* 0635EE */
{
    if ((wx_busy & 0x44) ||
        ((wx_state == 7 || wx_state == 9) && (wx_busy & 0x10) && (wx_req_flags & 0x04))) {
        wx_conn_stage = '2';
        wx_B311 = code;
        tone_ev = 0x58;
        flags_817E |= 0x02;
        popup_tmr = 0x19;
        return;
    }
    wx_room_lost_6363C();
}
void wx_room_lost_6363C(void)                            /* 06363C */
{
    u8 s = wx_state;
    if (wx_conn_stage < '3') return;
    if (s == 0x0B || s == 0x12 || ((s >= 0x14 && s < 0x32) && (wx_req_flags & 0x10))) {
        wx_menu_origin = 2;
        goto keep;
    }
    if (s >= 0x14 && s < 0x32 && wx_menu_origin == 2) goto keep2;
    wx_conn_stage = '2';
    wx_session_reset();
    wx_set_linked_goto2();
    goto out;
keep:
keep2:
    wx_conn_stage = '2';
    wx_req_flags &= ~0x20;
out:
    wx_prev_state = wx_state;
    tone_ev = 0x57;
    flags_AA34 |= 0x20; tmr_9538 = 0xFA;
    flags_817E |= 0x02;
    popup_id = 6;
}

/* ---------------------------------------------------------------------------
 * 0636B2-063720 (110 B)  wx_rx_room_status  [sub_636B2]
 * Confirmed.  Callers: node-answer code (not listed).
 * r4l = room kind char, er1 = node block, er2 = room block (0x31 + key).
 * B26F = 0 for kinds '3'/'4' else 1.  If already linked and the room block
 * equals the current one (6 bytes from B2C8) and nothing is outstanding:
 * just refresh (63720).  Otherwise refresh, then if a PTT-connect or
 * connect is outstanding compare the answer with the asked ID (sub_63858
 * -> r3l = 0 on match), clear busy.b6, and on match run wx_connected
 * (63768), else wx_connected_other (638C6).
 * ------------------------------------------------------------------------- */
void wx_rx_room_status(u8 kind, const u8 *node, const u8 *room)  /* 0636B2 */
{
    u8 other = 0;
    wx_B26F = (kind == '3' || kind == '4') ? 0 : 1;
    if (wx_conn_stage >= '3' && memcmp(room, &wx_conn_stage, 6) == 0 &&
        !(wx_busy & 0x44)) {
        wx_store_room(node, room);                      /* 063720              */
        return;
    }
    wx_store_room(node, room);
    if (wx_busy & 0x44) other = wx_answer_is_other_63858(room);
    wx_busy &= ~0x40;
    if (other == 0) wx_connected_63768(); else wx_connected_other_638C6();
}

/* 063720-063768 (72 B)  wx_store_room  [sub_63720]  Confirmed
 * Copies 0x4F bytes er1 -> B2AA (node + room block), the 5-byte key at
 * room+0x31 -> B324 and B324 -> B329.                                    */
void wx_store_room(const u8 *node, const u8 *room)
{
    memcpy(wx_node_id, node, 0x4F);
    memcpy(&wx_B324, room + 0x31, 5);
    memcpy(&wx_B329, &wx_B324, 5);
}

/* ---------------------------------------------------------------------------
 * 063768-063858 (240 B)  wx_connected  [sub_63768]  Confirmed
 * Callers: 0636B2.
 * The node confirmed the link to the room we asked for.  In ID entry: leave
 * it; if the connect was by number (flags26D.b1) remember the new room as
 * the target (B2C9 -> FF8D9F, 0x31 B from B2C8 -> FF8D9E, EEPROM save).
 * States 7/9: a pending name search (6387A) also stores the room as
 * target.  State 0x10 / searches with busy.b2 outside PDN: clear the
 * connect flags and show the room (sub_646C2).  States 2/4 and the
 * fall-backs: clear VFO view, busy.b2, flags26D.b1 and go to state 4
 * (sub_604CE).  Always ends with the "connected" notice (6389E: tone
 * 0x56, popup 5, 2.5 s).
 * ------------------------------------------------------------------------- */
void wx_connected_63768(void)                            /* 063768 */
{
    u8 s;
    if (wx_link & 0x08) {
        wx_link &= ~0x08;
        if (!(wx_busy & 0x04)) goto notice;
        if (!(wx_flags26D & 0x02)) goto to_state4;
        memcpy(wx_target_id, wx_room_id, 5);
        memcpy(wx_target_rec, &wx_conn_stage, 0x31);
        save_target_rec_3D6B0();
        goto to_state4;
    }
    s = wx_state;
    if (s == 2 || s == 4) goto to_state4;
    if (s == 7 || s == 9) {
        if (wx_search_hit_6387A()) {
            memcpy(wx_target_id, wx_room_id, 5);
            memcpy(wx_target_rec, &wx_conn_stage, 0x31);
            save_target_rec_3D6B0();
            goto show_room;
        }
        goto check_b2;
    }
    if (s != 0x10) goto notice;
check_b2:
    if (!(wx_busy & 0x04)) goto to_state4;
show_room:
    if (node_mode & 0x80) goto to_state4;
    wx_busy &= ~0x04; wx_flags26D &= ~0x02;
    wx_show_msg_646C2();
    goto notice;
to_state4:
    wx_link &= ~0x04;
    wx_busy &= ~0x04; wx_flags26D &= ~0x02;
    wx_set_linked_goto4();
notice:
    wx_connected_notice_6389E();
}

/* 063858-06387A (34 B)  wx_answer_is_other  [sub_63858]  Confirmed
 * r3l = 0 when room+1[0..4] equals the asked ID B349, else 1.            */
u8 wx_answer_is_other_63858(const u8 *room)
{
    return memcmp(room + 1, wx_pend_id, 5) == 0 ? 0 : 1;
}

/* 06387A-06389E (36 B)  wx_search_hit  [sub_6387A]  Confirmed
 * With a name search outstanding (busy.b4 and B26B.b2): if the room name
 * B2CE[16] equals the search text B339 (63B3E) clear B26B.b2, return 1. */
u8 wx_search_hit_6387A(void)
{
    if (!(wx_busy & 0x10) || !(wx_req_flags & 0x04)) return 0;
    if (!wx_name_eq_search_63B3E()) return 0;
    wx_req_flags &= ~0x04;
    return 1;
}

/* 06389E-0638C6 (40 B)  wx_connected_notice  [sub_6389E]  Confirmed
 * B40E = state, tone 0x56, AA34.b5, FF9538 = 2.5 s, 817E.b1, popup 5.   */
void wx_connected_notice_6389E(void)
{
    wx_prev_state = wx_state;
    tone_ev = 0x56;
    flags_AA34 |= 0x20; tmr_9538 = 0xFA;
    flags_817E |= 0x02;
    popup_id = 5;
}

/* 0638C6-063904 (62 B)  wx_connected_other  [sub_638C6]  Confirmed
 * The node linked us to a different room than asked: in the content states
 * keep the page (B26E = 2, B26B.b5 clear); otherwise reset the session tail
 * (sub_5FD2C) and go to state 4.  Then the notice.                       */
void wx_connected_other_638C6(void)
{
    u8 s = wx_state;
    if (s == 0x0B || s == 0x12 || ((s >= 0x14 && s < 0x32) && (wx_req_flags & 0x10))) {
        wx_menu_origin = 2; wx_req_flags &= ~0x20;
    } else if (s >= 0x14 && s < 0x32 && wx_menu_origin == 2) {
        wx_req_flags &= ~0x20;
    } else {
        wx_session_reset_tail();
        wx_set_linked_goto4();
    }
    wx_connected_notice_6389E();
}

/* ---------------------------------------------------------------------------
 * 063AAA-063AF6 (76 B)  wx_rx_no_data  [sub_63AAA]  Confirmed
 * Callers: none listed (node-answer code, 063904 region).
 * "No data / not found" answer: cursor 0, tone 0x54, AA34.b5, 2.5 s,
 * 817E.b1, popup 0x0C, BC59.b6.  In state 9 stay; if the request came from
 * state 9 return there; else wx_no_data_return.
 * ------------------------------------------------------------------------- */
void wx_rx_no_data(void)                                 /* 063AAA */
{
    wx_sel = wx_cursor = 0;
    tone_ev = 0x54;
    flags_AA34 |= 0x20; tmr_9538 = 0xFA;
    flags_817E |= 0x02;
    popup_id = 0x0C;
    disp_flags_BC59 |= 0x40;
    if (wx_state == 9) return;
    if (wx_prev_state == 9) { wx_state = 9; return; }
    wx_no_data_return();
}

/* 063AF6-063B3E (72 B)  wx_search_text_in_answer  [sub_63AF6]  Confirmed
 * Length n of the search text B339 (up to the first ' ', max 16); returns
 * 0 if those n chars occur anywhere in the 16-char answer field FF0C5B
 * (sliding compare), 1 otherwise (also 1 for an empty text).            */
u8 wx_search_text_in_answer(void)
{
    u8 n = 0, i, k; const u8 *s = &wx_list_req[5];
    for (k = 0x10; k && s[n] != ' '; k--) n++;
    if (n == 0) return 1;
    for (i = 0; i < (u8)(0x10 - n); i++)
        if (memcmp(&dsp_rx_0C5B[i], s, n) == 0) return 0;
    return 1;
}

/* 063B3E-063B5A (28 B)  wx_name_eq_search  [sub_63B3E]  Confirmed
 * Z set when the 16-char room name B2CE equals the search text B339.    */
u8 wx_name_eq_search_63B3E(void) { return memcmp(wx_room_name_B2CE, &wx_list_req[5], 0x10) == 0; }

/* ---------------------------------------------------------------------------
 * 063B5A-063B74 (26 B)  wx_defaults_settings  [sub_63B5A]  Confirmed
 * 063B74-063BB8 (68 B)  gm_defaults_tables  [sub_63B74]  Confirmed
 * Callers: 00DEFA (the factory-default / EEPROM rebuild code).
 * 63B5A: 16 bytes of ROM 0x00F6D6 -> FFAE22 (first category name), then
 * shares the tail at 063B8C: 0x100 bytes of 0xFF after it, then 0x300
 * bytes of 0xFF at FFB5B8 (category / member table).  63B74: same with
 * the 16-byte GM group name ROM 05DDEC -> FFB4A8.
 * ------------------------------------------------------------------------- */
void wx_defaults_settings(void)
{
    memcpy(wx_settings_AE22, rom_F6D6, 0x10);
    memset(wx_settings_AE22 + 0x10, 0xFF, 0x100);
    memset(wx_cat_list, 0xFF, 0x300);
}
void gm_defaults_tables(void)
{
    memcpy(gm_name_B4A8, rom_5DDEC, 0x10);
    memset(gm_name_B4A8 + 0x10, 0xFF, 0x100);
    memset(wx_cat_list, 0xFF, 0x300);
}

/* 063BB8-063BFC (68 B)  gm_init_cold  [sub_63BB8]  Confirmed
 * Callers: 00ED16.  8 bytes ROM 063BFC -> FFB8B8, B3EC = 0, B3EB = 0,
 * B92A = 0xFF, B928 = 0, B95C = B95D = 0, then gm_reset (063C16).        */
void gm_init_cold(void)
{
    memcpy(gm_B8B8, rom_63BFC, 8);
    gm_group = 0; wx_sel = gm_group;
    gm_B92A = 0xFF; gm_B928 = 0; gm_B95C = 0; gm_B95D = 0;
    gm_reset();
}

/* ==========================================================================
 * Part 4: 063C04-064874  mode 10 (GM candidate, shares the B3EA machine),
 * the content-browser DIAL handlers (states 0x13-0x44) and the message
 * box / message-list entry helpers.
 * ========================================================================== */

/* ---------------------------------------------------------------------------
 * 063C04-063C16 (18 B)   gm_enter  [sub_63C04]  Confirmed
 * 063C16-063C8E (120 B)  gm_reset  [sub_63C16]  Confirmed
 * Callers: key 1 short press in home (0x01CE9A, doc 103/122) -> 63C04;
 *          02BF44, 063BB8 -> 63C16; 063C3A (entry inside) from 063DC6.
 * Enter mode 10: B2A3 = 0, B2A5 = 1, home_app_mode = 10, then reset:
 * group index B3EC = 0, load the group table from EEPROM (sub_3DA80),
 * count groups (63D2C), load the member table (63C94), select group 0
 * (cursor via 64212), BC06 = 0, AD9A = 0xFF, B26F = 0x80, clear B275,
 * B265, B420, B267, B3FA, B3F2, state 0, B3F9; B963.b0 = sub_3ECB8()
 * (then B421 = 4).
 * ------------------------------------------------------------------------- */
void gm_enter(void)                                      /* 063C04 */
{
    wx_B2A3 = 0;
    wx_app_kind = 1;
    home_app_mode = 10;
    gm_reset();                                         /* falls through       */
}
void gm_reset(void)                                      /* 063C16 */
{
    gm_group = 0;                                       /* B3EC                */
    gm_load_groups_3DA80();
    gm_count_groups();                                  /* 63D2C               */
    gm_load_members();                                  /* 63C94               */
    wx_sel = gm_group;
    gm_set_cursor_64212(gm_group);
    ram_BC06 = 0;
    /* 063C3A: second entry used by gm_key1 */
    wx_AD9A = 0xFF;
    wx_B26F = 0x80;
    wx_B275 = 0; wx_B265 = 0; gm_B420 = 0;
    wx_rx_letter = 0; wx_B3FA = 0;
    gm_B3F2 = 0;
    wx_state = 0;
    gm_B3F9 = 0;
    gm_B963 &= ~0x01;
    if (gm_check_3ECB8()) { gm_B963 |= 0x01; gm_B421 = 4; }
}

/* ---------------------------------------------------------------------------
 * 063C94-063CEC (88 B)  gm_load_members  [sub_63C94]  Confirmed
 * 063CEC-063D2C (64 B)  gm_members_default  [sub_63CEC]  Confirmed
 * Callers: 063C16, 064446 (63C94); 063C94 (63CEC).
 * Group name: 16 B ROM 05DDEC -> FFB4A8 (default "ALL"-style name), load
 * group B3EC's member table (sub_3DBB2, r3l = 0 -> failed -> defaults:
 * 24 x 32 B from ROM 06981E into FFB5B8).  Then mark every member's
 * status block (FFB5C7 + 32*i: [0] = 0xFF, words [1..4] = 0) and count
 * the members (B3FC = 0, 63D50).
 * ------------------------------------------------------------------------- */
void gm_load_members(void)                               /* 063C94 */
{
    u8 i; u8 *e;
    memcpy(gm_name_B4A8, rom_5DDEC, 0x10);
    if (gm_load_group_3DBB2(gm_group) == 0) gm_members_default();
    for (i = 0, e = &wx_cat_list[0x0F]; i < 0x18; i++, e += 0x20) {
        e[0] = 0xFF; *(u16 *)&e[1] = 0; *(u16 *)&e[3] = 0;
    }
    gm_B3FC = 0;
    gm_count_members();
}
void gm_members_default(void)                            /* 063CEC */
{
    u8 i;
    memcpy(gm_name_B4A8, rom_5DDEC, 0x10);
    for (i = 0; i < 0x18; i++) memcpy(&wx_cat_list[i * 0x20], rom_6981E, 0x20);
}

/* 063D2C-063D50 (36 B)  gm_count_groups  [sub_63D2C]  Confirmed
 * B3EE = number of the 17 16-byte names at FFB4A8 that are not 0xFF.    */
void gm_count_groups(void)
{
    u8 n = 0, i;
    for (i = 0; i < 0x11; i++) if (gm_name_B4A8[i * 0x10] != 0xFF) n++;
    gm_n_groups = n;                                    /* B3EE                */
}
/* 063D50-063D74 (36 B)  gm_count_members  [sub_63D50]  Confirmed
 * Callers: 063C94, 0644A0, 0689A2.  B3EF = members with byte +5 != 0xFF
 * among the 24 32-byte records at FFB5B8 (doc 86 reuses B3EF as the GM
 * beacon interval index: word_5DFD0[B3EF]).                              */
void gm_count_members(void)
{
    u8 n = 0, i;
    for (i = 0; i < 0x18; i++) if (wx_cat_list[i * 0x20 + 5] != 0xFF) n++;
    wx_B3EF = n;
}
/* 063D74-063DA2 (46 B)  gm_select_new_group  [sub_63D74]  Confirmed
 * Callers: 064504.  First free 16-byte slot among FFB4B8.. (1-based,
 * capped at 16) -> B3EC and B3EB; cursor via 64212.                     */
void gm_select_new_group(void)
{
    u8 n = 1, i;
    for (i = 0; i < 0x10; i++, n++) if (gm_name_B4A8[0x10 + i * 0x10] == 0xFF) break;
    if (i == 0x10) n = 0x10;
    gm_group = n; wx_sel = n;
    gm_set_cursor_64212(n);
}
/* 063DA2-063DC6 (36 B)  gm_count_selected  [sub_63DA2]  Confirmed
 * B414 = members whose byte +0x12 has bit 0 set (selected).             */
u8 gm_count_selected(void)
{
    u8 n = 0, i;
    for (i = 0; i < 0x18; i++) if (wx_cat_list[i * 0x20 + 0x12] & 0x01) n++;
    gm_n_sel = n;                                       /* B414                */
    return n;
}

/* ---------------------------------------------------------------------------
 * 063DC6-063E0E (72 B)  gm_key1  [sub_63DC6]  Confirmed
 * Callers: key table #12 slot 1.
 * Key 1 in mode 10: long press with FF8DD7 == 1 -> sub_1CEC4.  Otherwise
 * leave mode 10: 063C3A (reset tail), state 0, B132 = 0, 9D3F = 3,
 * B2A5 = 0, home_app_mode = 0, B0AA.b7.
 * ------------------------------------------------------------------------- */
void gm_key1(void)                                       /* 063DC6 */
{
    if ((key_flags & 0x80) && dsq_8DD7 == 1) { key1_long_1CEC4(); return; }
    gm_reset_tail_63C3A();
    wx_state = 0; wx_B132 = 0; ui_9D3F = 3;
    wx_app_kind = 0; home_app_mode = 0;
    flags_B0AA |= 0x80;
}

/* 063E0E-063E36 (40 B)  gm_dial  [sub_63E0E]  Confirmed
 * Callers: key tables #10/#12 slot 13 (DIAL in modes 8/10).  B420.b0 ->
 * consume; else B092 = 0 and off_63E36[wx_state]: 7/8 -> 63F4C, 0x13 ->
 * 64134, 0x14.. the same content handlers as wx_dial, else 63F4A (rts). */
void gm_dial(void)
{
    if (gm_B420 & 0x01) { consume_key(); return; }
    dial_min = 0;
    off_63E36[wx_state]();
}

/* ===========================================================================
 * Content-browser DIAL handlers (off_5FEA2 / off_63E36, states 0x13-0x44).
 * 064230 is their shared rts, 06422C the shared consume_key().  The dial
 * descriptors 064232..0642DC (and 06424C/6965A) are {min,max,&var} byte
 * records for sub_3F62E; their targets are not visible in the listing.
 * ======================================================================== */
/* 063F4A-063F4C (2 B)  content_dial_nop  [sub_63F4A]  Confirmed: rts.   */
void content_dial_nop(void) { }

/* 063F4C-063F76 (42 B)  gm_dial_members  [sub_63F4C]  Confirmed
 * GM states 7/8: busy.b0 -> consume; B3EF (members) <= 0 -> consume;
 * else move cursor B3F1 over 0..B3EF-1 (sub_3F6AE, the non-wrapping
 * stepper, Inferred).                                                    */
void gm_dial_members(void)
{
    if (wx_busy & 0x01) { consume_key(); return; }
    if ((s8)wx_B3EF <= 0) { consume_key(); return; }
    dial_max = wx_B3EF - 1;
    dial_step_clamp_3F6AE(&wx_cursor);
}

/* 063F76-063F84 (14 B)  content_dial_s32  [sub_63F76]  Confirmed:
 * dial_step(desc 064252).                                                */
void content_dial_s32(void) { dial_step(&byte_64252); }

/* 063F84-063F9C (24 B)  content_dial_text  [sub_63F84]  Confirmed
 * 063F9C-063FA0 (4 B)   content_dial_ret  [sub_63F9C]  Confirmed
 * States 0x20/0x33: dial the character at FF061A[AD99] (sub_1B992).     */
void content_dial_text(void) { text_dial_1B992(&wx_text_buf[edit_cursor]); }
void content_dial_ret(void) { }

/* 063FA0-063FDA (58 B)  content_dial_s35  [sub_63FA0]  Confirmed
 * States 0x35/0x36: B3EF < 0 -> consume.  B3EF == 0 -> range 0..1;
 * BBF2.b5 -> step desc 06425E; else range 0..B3EF-1 on B3F1.  (063FC4
 * inc is unreachable.)                                                   */
void content_dial_s35(void)
{
    s8 n = (s8)wx_B3EF;
    if (n < 0) { consume_key(); return; }
    if (n == 0) dial_max = 1;
    else if (flags_BBF2 & 0x20) { dial_step(&byte_6425E); return; }
    else dial_max = n - 1;
    dial_step_b092(&wx_cursor);
}

/* 063FDA-063FFE (36 B)  content_dial_s37  [sub_63FDA]  Confirmed
 * State 0x37 (message list): B92A (count-1?) < 0 -> consume; range
 * 0..B92A, or 0..B92A-1 when B928 != 0.                                  */
void content_dial_s37(void)
{
    s8 n = (s8)gm_msg_B92A;
    if (n < 0) { consume_key(); return; }
    dial_max = (gm_msg_B928 != 0) ? (u8)(n - 1) : (u8)n;
    dial_step_b092(&wx_cursor);
}

/* 06400C-064050 (68 B)  content_dial_s38  [sub_6400C]  Confirmed
 * State 0x38: chooses the descriptor by the open message's type byte
 * FF2FCA: b3 set or type 4/6 -> 064276; b0 set -> 064270; else 06426A. */
void content_dial_s38(void)
{
    u8 t = msg_cur[0];                                  /* FF2FCA              */
    if ((t & 0x08) || (t & 7) == 4 || (t & 7) == 6) dial_step(&byte_64276);
    else if (t & 0x01) dial_step(&byte_64270);
    else dial_step(&byte_6426A);
}

/* 064050-06406C (28 B)  content_dial_s39  [sub_64050]  Confirmed
 * State 0x39: range 0..B92A-1 on the cursor (B92A < 0 -> consume).      */
void content_dial_s39(void)
{
    if ((s8)gm_msg_B92A < 0) { consume_key(); return; }
    dial_max = gm_msg_B92A - 1;
    dial_step_b092(&wx_cursor);
}

/* ---------------------------------------------------------------------------
 * 06407A-064082 (8 B)    content_dial_s3A  [sub_6407A]  Confirmed
 * 064082-0640E6 (100 B)  content_dial_s3A_body  [sub_64082]  Confirmed
 * State 0x3A (message options).  By FF2FCA: type 0 -> desc 06428E; b3 or
 * type 4/6 -> 06429A; b0 -> 064288; else 064282.  For the three typed
 * cases the step repeats while the new value is 1 or 2 (those items are
 * skipped for this message type).
 * ------------------------------------------------------------------------- */
void content_dial_s3A(void)                              /* 06407A */
{
    u8 t = msg_cur[0]; const void *d; u8 v;
    if (!(t & 0x08)) {
        if (t == 0) { dial_step(&byte_6428E); return; }
        if ((t & 7) != 4 && (t & 7) != 6) {
            d = (t & 0x01) ? &byte_64288 : &byte_64282;
            do v = dial_step(d); while (v == 1 || v == 2);
            return;
        }
    }
    do v = dial_step(&byte_6429A); while (v == 1 || v == 2);
}

/* 0640E6-064106 (32 B)  content_dial_s3B  [sub_640E6]  Confirmed
 * State 0x3B: dial the character FF300A[AD99]; repeat while the result is
 * 0xFE (skip code).                                                      */
void content_dial_s3B(void)
{
    while (text_dial_1B992(&msg_text_300A[edit_cursor]) == 0xFE) ;
}

/* 064106-06410A (4 B)  content_dial_s3C  [sub_64106]  Confirmed: return.
 * 06410A-064118 (14 B) content_dial_s3D  [sub_6410A]  Confirmed:
 *                      dial_step(desc 06965A).                           */
void content_dial_s3C(void) { }
void content_dial_s3D(void) { dial_step(&unk_6965A); }

/* 064118-064134 (28 B)  content_dial_s3E  [sub_64118]  Confirmed
 * Same body as content_dial_s39.                                         */
void content_dial_s3E(void) { content_dial_s39(); }

/* 064134-064150 (28 B)  gm_dial_s13  [sub_64134]  Confirmed
 * GM state 0x13: B281 = dial_step(06424C) unless busy.b0.                */
void gm_dial_s13(void)
{
    if (wx_busy & 0x01) { consume_key(); return; }
    wx_menu13_sel = dial_step(&unk_6424C);
}

/* 064150 / 06415E (14 B each)  content_dial_s14 / _s15  [sub_64150,
 * sub_6415E]  Confirmed: dial_step(0642A0) / dial_step(0642A6).          */
void content_dial_s14(void) { dial_step(&byte_642A0); }
void content_dial_s15(void) { dial_step(&byte_642A6); }

/* 06416C-064192 (38 B)  content_dial_list  [sub_6416C]  Confirmed
 * States 0x16/0x1E: busy.b1 or no rows -> consume; cursor 0..B26A-1.    */
void content_dial_list(void)
{
    if (wx_busy & 0x02) { consume_key(); return; }
    if (wx_rows == 0)   { consume_key(); return; }
    dial_max = wx_rows - 1;
    dial_step_b092(&wx_cursor);
}

/* 064192 (4 B) content_dial_s17 [sub_64192]: consume.  064196 (14 B)
 * content_dial_s18 [sub_64196]: dial_step(0642AC).  0641A4 (8 B)
 * content_dial_s19 [sub_641A4]: sub_2B422.  0641AC (14 B) content_dial_s1B
 * [sub_641AC]: dial_step(0642A6).  0641BA/0641BC (2 B) content_dial_s1C/
 * _s1D [sub_641BA, sub_641BC]: consume.  0641BE (4 B) content_dial_s1F
 * [sub_641BE]: -> 063FDA.  0641C2 (4 B) content_dial_s22 [sub_641C2]:
 * -> 064050.  0641C6 (12 B) content_dial_s23 [sub_641C6]:
 * dial_step(0642B8).  All Confirmed.                                     */
void content_dial_s17(void) { consume_key(); }
void content_dial_s18(void) { dial_step(&byte_642AC); }
void content_dial_s19(void) { content_dial_2B422(); }
void content_dial_s1B(void) { dial_step(&byte_642A6); }
void content_dial_s1C(void) { consume_key(); }
void content_dial_s1D(void) { consume_key(); }
void content_dial_s1F(void) { content_dial_s37(); }
void content_dial_s22(void) { content_dial_s39(); }
void content_dial_s23(void) { dial_step(&byte_642B8); }

/* 0641D2 / 0641F2 (32 B each)  content_dial_s24 / _s25  [sub_641D2,
 * sub_641F2]  Confirmed.  Descriptor chosen by B963.b0 (the gm_check
 * result): 0642BE/0642C4 resp. 0642CA/0642D0.                            */
void content_dial_s24(void) { dial_step((gm_B963 & 1) ? &byte_642C4 : &byte_642BE); }
void content_dial_s25(void) { dial_step((gm_B963 & 1) ? &byte_642D0 : &byte_642CA); }

/* 064212-064232 (32 B)  gm_set_cursor  [sub_64212]  Confirmed
 * Callers: 063C16, 063D74, 0644A0, 064212 also holds the shared tails
 * 06422C (consume_key) and 064230 (rts).
 * Cursor B3F1 = byte_64232[r3l] (per-state initial cursor), B286 = 0.   */
void gm_set_cursor_64212(u8 i)
{
    wx_cursor = byte_64232[i];
    wx_B286 = 0;
}

/* 0642DC-064300 (36 B)  content_dial_s34  [sub_642DC]  Confirmed
 * State 0x34: range 0..byte_64300[FF0619] (= {3,4,5,6,7,0}) on B286.    */
void content_dial_s34(void)
{
    dial_max = byte_64300[ram_FF0619];
    dial_step_b092(&wx_B286);
}

/* 064306-06430C (6 B)  content_consume  [sub_64306]  Confirmed.          */
void content_consume(void) { consume_key(); }

/* 064444-064446 (2 B)  nullsub_93: rts.  Default slot of off_601F4,
 * off_64330 and the touch tables.                                        */

/* ---------------------------------------------------------------------------
 * 064446-064492 (76 B)  gm_key_enter_group  [sub_64446]  Inferred
 * 0644A0-0644B8 (24 B)  gm_goto_state3  [sub_644A0]  Confirmed
 * 0644B8-0644DC (24 B)  gm_goto_state7  [sub_644B8]  Confirmed
 * Callers: off_64330? (64446 is a table target, not listed); 064446
 * (644A0); 061A2E, 064446, 06470C, 0657DC (644B8).
 * Reloads the member table, er5 = group name record.  Short press: on
 * row 0, or a group row with members (B3EF > 0) -> sub_68ADA then
 * state 7; a group row without members -> reject beep.  Long press on a group row ->
 * state 3 (644A0: recount, cursor via 64212(0)); on row 0 consume.
 * 644B8: B3F2 = 3, cursor 0, busy.b0 clear, B3F8 = 1, state 7.
 * ------------------------------------------------------------------------- */
void gm_key_enter_group(void)                            /* 064446 */
{
    gm_load_members();
    /* er5 = FFB4A8 + 16*B3EC (group name), consumed by sub_68ADA */
    if (key_flags & 0x80) {
        if (wx_sel) gm_goto_state3(); else consume_key();
        return;
    }
    if (wx_sel != 0 && (s8)wx_B3EF <= 0) { reject_beep(); return; } /* 06446A */
    gm_open_group_68ADA();                              /* 064478              */
    gm_goto_state7();
}
void gm_goto_state3(void)                                /* 0644A0 */
{
    gm_count_members();
    wx_sel = 0;
    gm_set_cursor_64212(0);
    wx_state = 3;
}
void gm_goto_state7(void)                                /* 0644B8 */
{
    gm_B3F2 = 3;
    wx_sel = wx_cursor = 0;
    wx_busy &= ~0x01;
    gm_B3F8 = 1;
    wx_state = 7;
}
/* ---------------------------------------------------------------------------
 * 0644DC-0644FA (30 B)  gm_touch_s7_probe  [sub_644DC]  Confirmed
 * 0644FA-064504 (10 B)  gm_key_s7  [sub_644FA]  Confirmed
 * 064504-06457C (120 B) gm_member_toggle  [sub_64504]  Confirmed
 * Callers: 02BB9A, 02BC00 (probe); off_64330[7] (644FA); 02BBAE (64504).
 * GM member list (state 7, page F701).  The probe clears the long-press
 * flag.  B3EB indexes the row map at FFB8C0 (@-0x4740): a valid member
 * (< 0x18, record +5 != 0xFF) is required (else 06462E consume).  With
 * FF8DD7 == 1 nothing happens.  Short press toggles the member's select
 * bit (+0x12 b0); long press, if any member is selected (63DA2), saves
 * B413 = group, creates a new group from the selection (63D74) and goes to
 * state 2 (64678).
 * ------------------------------------------------------------------------- */
void gm_touch_s7_probe(void)                             /* 0644DC */
{
    touch_reject = 1;
    if (wx_busy & 0x01) { gm_silent_64622(); return; }
    key_flags &= ~0x80;
    touch_reject = 0;
}
void gm_key_s7(void)                                     /* 0644FA */
{
    if (wx_busy & 0x01) { gm_silent_64622(); return; }
    gm_member_toggle();
}
void gm_member_toggle(void)                              /* 064504 */
{
    u8 m = gm_row_map_B8C0[wx_sel]; u8 *rec;
    if (m == 0xFF || m >= 0x18) { consume_key(); return; }
    rec = &wx_cat_list[m * 0x20];
    if (rec[5] == 0xFF)         { consume_key(); return; }
    if (dsq_8DD7 == 1) return;
    if (!(key_flags & 0x80)) { rec[0x12] ^= 0x01; return; }
    if (gm_count_selected() == 0) { consume_key(); return; }
    gm_B413 = gm_group;
    gm_select_new_group();
    gm_goto_state2_64678();
}
/* 06457C-064634: not in this lane's function list (contains the 06462E
 * consume and 064622 silent tails).                                      */

/* ---------------------------------------------------------------------------
 * 064634-064640 (12 B)  msg_box_sel3  [sub_64634]  Confirmed
 * 064640-064648 (8 B)   msg_box_from_fmenu  [sub_64640]  Confirmed
 * 064648-064654 (12 B)  msg_box_sel1  [sub_64648]  Confirmed
 * 064654-064660 (12 B)  msg_box_sel2  [sub_64654]  Confirmed
 * 064660-064678 (24 B)  wx_open_msgbox  [sub_64660]  Confirmed
 * Callers: 064B96 (64634/48/54); F-menu mode-8 entry 0x01F5C8 (64640,
 * doc 103); 06080A, 064640, 06685C (64660).
 * Enter state 0x32 (message box menu, F600) with cursor 3/1/2/1, A872 = 0.
 * 64640 additionally clears B3EF.
 * ------------------------------------------------------------------------- */
static void msg_box_enter(u8 sel) { wx_sel = wx_cursor = sel; msg_A872 = 0; wx_state = 0x32; }
void msg_box_sel3(void)        { msg_box_enter(3); }
void msg_box_from_fmenu(void)  { wx_B3EF = 0; wx_open_msgbox_64660(); }
void msg_box_sel1(void)        { msg_box_enter(1); }
void msg_box_sel2(void)        { msg_box_enter(2); }
void wx_open_msgbox_64660(void){ msg_box_enter(1); }

/* 064678-06468A (18 B)  gm_goto_state2  [sub_64678]  Confirmed
 * cursor 0, state 2.                                                     */
void gm_goto_state2_64678(void) { wx_sel = wx_cursor = 0; wx_state = 2; }

/* ---------------------------------------------------------------------------
 * 06468A-0646C2 (56 B)  wx_news_menu_enter  [sub_6468A]  Confirmed
 * 0646C2-0646C8 (6 B)   wx_show_msg  [sub_646C2]  Confirmed
 * 0646C8-0646DA (18 B)  wx_msgbox  [sub_646C8]  Confirmed
 * 0646DA-0646FA (32 B)  wx_news_got  [sub_646DA]  Confirmed
 * Callers: none listed (6468A, a table target; its 064690 entry from
 * 060ED4/0616F2); 060554/063768 (646C2); 060E08, 060E3A, 060ED4, 0616F2,
 * 0624CA, 0658CE, 0679E4 (646C8); 062A32 (646DA).
 * State 0x13 (F812, the room/news item menu): cursor = B281 (6468A sets
 * it to 1, 646C2 too), B26E = 0 (6468A, "from list") or 1 (646C8, "from
 * connected room"), restore the key B329 -> B324, state 0x13.
 * ------------------------------------------------------------------------- */
void wx_news_menu_enter(void)                            /* 06468A */
{
    wx_menu13_sel = 1;
    wx_msg_return_64690();
}
void wx_msg_return_64690(void)                           /* 064690 */
{
    wx_sel = wx_cursor = wx_menu13_sel;
    wx_menu_origin = 0;
    memcpy(&wx_B324, &wx_B329, 5);
    wx_state = 0x13;
}
void wx_show_msg_646C2(void) { wx_menu13_sel = 1; wx_msgbox_646C8(); }
void wx_msgbox_646C8(void)
{
    wx_sel = wx_cursor = wx_menu13_sel;
    wx_menu_origin = 1;
    wx_news_got_646DA();
}
void wx_news_got_646DA(void)
{
    memcpy(&wx_B324, &wx_B329, 5);
    wx_state = 0x13;
}

/* ---------------------------------------------------------------------------
 * 0646FA-064706 (12 B)  msgbox_touch_sel  [sub_646FA]  Confirmed
 * 064706-06470C (6 B)   msgbox_key7  [sub_64706]  Confirmed
 * 06470C-0647B4 (168 B) msgbox_action  [sub_6470C]  Confirmed
 * Callers: 02B4EC (646FA: r4l = touched row - 1); off_601F4[0x32] (64706).
 * State 0x32 = message box menu (F600).  Long press = back: mode 8 ->
 * home (A9F9 = 0); mode 9 -> sub_60ED4 (return to WIRES-X screen); mode
 * 10 -> B420.b1 ? (clear it, 60ED4) : state 7.  Item 0 consume; item 1
 * -> received list (B92D = 0, clear FEEF20, B928/B95C/B95D = 0,
 * sub_6F064, state 0x3E); item 2 -> B92D = 1, sub_6F07E, if B92A < 0
 * state 0x37 (647C6); item 3 -> B92D = 2, sub_6F076.
 * (06477E 'bsr 647EA' is an unreferenced tail.)
 * ------------------------------------------------------------------------- */
void msgbox_touch_sel(u8 idx) { wx_sel = wx_cursor = idx + 1; msgbox_action_item(); }
void msgbox_key7(void)
{
    if (key_flags & 0x80) { msgbox_back(); return; }
    msgbox_action_item();
}
static void msgbox_back(void)                            /* 064726 */
{
    if (home_app_mode == 8) { home_app_mode = 0; return; }
    if (home_app_mode == 9) { wx_return_60ED4(); return; }
    if (gm_B420 & 0x02) { gm_B420 &= ~0x02; wx_return_60ED4(); return; }
    gm_goto_state7();
}
static void msg_folder_open(u8 folder)
{
    gm_folder_B92D = folder;
    msg_store_clear_64846();
    gm_msg_B928 = 0; gm_B95C = 0; gm_B95D = 0;
}
void msgbox_action_item(void)                            /* 06470E */
{
    switch (wx_sel) {
    case 0: consume_key(); return;
    case 1: msg_folder_open(0); msg_load_6F064(); return;    /* 0647FC       */
    case 2: msg_folder_open(1); msg_load_6F07E();
            if ((s8)gm_msg_B92A < 0) msg_list_empty_647C6();  /* bpl skip   */
            return;
    case 3: msg_folder_open(2); msg_load_6F076(); return;
    default: msgbox_back(); return;
    }
}

/* ---------------------------------------------------------------------------
 * 0647B4-0647C6 (18 B)  msg_list_restore_37  [sub_647B4]  Confirmed
 * 0647C6-0647D8 (18 B)  msg_list_empty  [sub_647C6]  Confirmed
 * 0647D8-0647EA (18 B)  msg_list_restore_39  [sub_647D8]  Confirmed
 * 0647EA-0647FC (18 B)  msg_list_39  [sub_647EA]  Confirmed
 * 0647FC-06481E (34 B)  msg_open_inbox  [sub_647FC]  Confirmed
 * 06481E-064822 (4 B)   msg_list_3E_stub  [sub_6481E]  Confirmed
 * 064822-064846 (36 B)  msg_list_restore_3E  [sub_64822]  Confirmed
 * Callers: 064C5A (647B4); 06470C/065350/06B5DC (647C6); 06470C/064DB2/
 * 06B5DC (647EA); 06470C/0657CC (647FC); 06F090 (6481E); 06B6E2 (64822).
 * Message-list states: 0x37 (folder 1), 0x39, 0x3E (inbox).  "restore"
 * versions put back the saved cursor B961/B962; the others start at 0.
 * ------------------------------------------------------------------------- */
void msg_list_restore_37(void) { wx_sel = msg_saved_sel; wx_cursor = msg_saved_cur; wx_state = 0x37; }
void msg_list_empty_647C6(void) { wx_sel = wx_cursor = 0; wx_state = 0x37; }
void msg_list_restore_39(void) { wx_sel = msg_saved_sel; wx_cursor = msg_saved_cur; wx_state = 0x39; }
void msg_list_39(void)          { wx_sel = wx_cursor = 0; wx_state = 0x39; }
void msg_open_inbox(void)       { msg_folder_open(0); msg_load_6F064(); }
void msg_list_3E_stub(void)     { wx_sel = wx_cursor = 0; wx_state = 0x3E; }
void msg_list_restore_3E(void)  { wx_sel = msg_saved_sel; wx_cursor = msg_saved_cur; wx_state = 0x3E; }

/* 064846-064874 (46 B)  msg_store_clear  [sub_64846]  Confirmed
 * B92A = 0xFF (empty); 20 x 0x80-byte message slots at FEEF20 are filled
 * from the blank record ROM 064874.                                      */
void msg_store_clear_64846(void)
{
    u8 i;
    gm_msg_B92A = 0xFF;
    for (i = 0; i < 0x14; i++) memcpy(&msg_store_FEEF20[i * 0x80], rom_64874_blank, 0x80);
}

/* ==========================================================================
 * Part 5: 0648F4-0652F6  the message box: message list / open / option
 * menus and the 80-character message editor (states 0x1F-0x3F).
 * Messages are the 20 x 128-byte records at FEEF20 (one SD folder page);
 * FF2FCA is the open record (doc 63: FF301A size, FF301E file name).
 * Record byte 0: b7 empty slot, b4 "read", b3 / type 4 / type 6 = has a
 * file attachment (picture or voice, Inferred), b0 outgoing (Inferred),
 * 0 = plain.
 * ========================================================================== */

/* ---------------------------------------------------------------------------
 * 0648F4-0648FE (10 B)   msg_key7_s37  [sub_648F4]  Confirmed
 * 0648FE-0649CC (206 B)  msg_open_selected  [sub_648FE]  Confirmed
 * Callers: off_601F4[0x37] / 065F32 (648F4); 02B7C2, 02B7D6 (648FE).
 * Message list (state 0x37).  Long press -> back to the box (064B96 via
 * 064A94).  Row 0 is "load more" when B92A < 0 or B928 == 0 -> 064A9A
 * (paging tails at 064A42..064A70).  Otherwise: BA93.b6 + FF9567 = 0x19
 * (busy indicator 2.5 s), save the list position in B961/B962, B92B =
 * slot (row-1 when B928 == 0), copy the 128-byte record to FF2FCA.
 * Empty slot (b7) -> 064AB6 consume.  An unread plain message gets b4
 * set in the store and in FF2FCA and is written back (sub_6A37C), SD job
 * BAA3 = 0x1C.  Read / typed messages: BAA3 = 0, B41D = 3, load the
 * attachment (sub_6F294 with FF301A), BAA3 = 0x1A.
 * ------------------------------------------------------------------------- */
void msg_key7_s37(void)                                  /* 0648F4 */
{
    if (key_flags & 0x80) { msgbox_back_64B96(); return; }
    msg_open_selected();
}
void msg_open_selected(void)                             /* 0648FE */
{
    u8 r = wx_sel, slot; u8 *rec;
    if (r == 0 && ((s8)gm_msg_B92A < 0 || gm_msg_B928 == 0)) { msg_more_64A9A(); return; }
    msg_flags_BA93 |= 0x40; tmr_9567 = 0x19;
    msg_saved_sel = wx_sel; msg_saved_cur = wx_cursor;
    slot = (gm_msg_B928 == 0) ? r - 1 : r;
    msg_slot_B92B = slot;
    rec = &msg_store_FEEF20[slot * 0x80];
    memcpy(msg_cur, rec, 0x80);
    if (msg_cur[0] & 0x80) { consume_key(); return; }   /* 064AB6              */
    if (!(msg_cur[0] & 0x01) && !(msg_cur[0] & 0x10)) {
        msg_cur[0] |= 0x10; rec[0] = msg_cur[0];        /* mark read           */
        msg_write_back_6A37C();
        sd_job_BAA3 = 0x1C;
        return;
    }
    /* 0649AC */
    sd_job_BAA3 = 0;
    msg_B41D = 3;
    msg_load_file_6F294(msg_file_size_301A);
    sd_job_BAA3 = 0x1A;
}

/* ---------------------------------------------------------------------------
 * 0649CC-064A3A (110 B)  msg_loaded  [sub_649CC]  Confirmed
 * Callers: none listed (an SD-job completion handler for BAA3 = 0x1A).
 * BAA3 = 0, 817E.b1, BA93.b6 off (FF9567 = 1 s), copy the 80-byte text
 * FF509E -> FF074E.  State 0x1F (editor return): sub_64B02 + 0651D6.
 * Else: length/lines (sub_652F6), header line (sub_539A0, er2 = FF302E),
 * and state 0x38 (message view) - via sub_64C5A from state 0x3D.
 * ------------------------------------------------------------------------- */
void msg_loaded(void)                                    /* 0649CC */
{
    sd_job_BAA3 = 0;
    flags_817E |= 0x02;
    msg_flags_BA93 &= ~0x40; tmr_9567 = 0x0A;
    memcpy(msg_text_074E, msg_text_509E, 0x50);
    if (wx_state == 0x1F) { msg_text_to_editor_64B02(); msg_goto_s21_651D6(); return; }
    msg_count_lines_652F6();
    msg_header_539A0((u8 *)0xFF302E);
    if (wx_state == 0x3D) { msg_goto_view_64B58(); msg_view_back_64C5A(); return; }
    msg_goto_view_64B58();
}

/* 064A42-064A58 (22 B)  msg_page_first  [sub_64A42]  Confirmed
 * 064A58-064A5E (6 B)   msg_page_prev  [sub_64A58]  Confirmed
 * 064A5E-064A64 (6 B)   msg_page_prev_go  [sub_64A5E]  Confirmed
 * 064A64-064A70 (12 B)  msg_page_next  [sub_64A64]  Confirmed
 * 064A94-064A9A (6 B)   msg_back_stub  [sub_64A94]  Confirmed
 * Paging inside the message list: first page (B928 = B95C = B95D = 0,
 * then the reload at 064A70), previous page (B928 != 0 -> 06FA08), next
 * page (B95D != 0 -> sub_6F942); empty -> 064AB6 consume.  64A94 is the
 * jsr stub to msgbox_back_64B96.                                         */
void msg_page_first(void)  { gm_msg_B928 = 0; gm_B95C = 0; gm_B95D = 0; msg_reload_64A70(); }
void msg_page_prev(void)   { if (gm_msg_B928 == 0) { consume_key(); return; } msg_page_prev_go(); }
void msg_page_prev_go(void){ msg_prev_6FA08(); }
void msg_page_next(void)   { if (gm_B95D == 0) { consume_key(); return; } msg_next_6F942(); }
void msg_back_stub(void)   { msgbox_back_64B96(); }

/* 064AD4-064B02 (46 B)  msg_editor_clear  [sub_64AD4]  Confirmed
 * Callers: 064BF6, 064FB0.  FF0618 = FF0619 = 0, copy the 0x5C-byte blank
 * editor block ROM 0x00F6D6 -> FF061A, BBED = 0.                          */
void msg_editor_clear(void)
{
    ram_FF0618 = 0; ram_FF0619 = 0;
    memcpy(wx_text_buf, rom_F6D6, 0x5C);
    edit_mode_BBED = 0;
}

/* 064B02-064B38 (54 B)  msg_text_to_editor  [sub_64B02]  Confirmed
 * Callers: 0649CC.  80 chars FF074E -> FF061A; trailing ' ' (from FF0669
 * backwards) become 0xFF; then length/lines (652F6).                     */
void msg_text_to_editor_64B02(void)
{
    u8 n = 0x50, *p = &wx_text_buf[0x4F];
    memcpy(wx_text_buf, msg_text_074E, 0x50);
    while (n-- && *p == ' ') *p-- = 0xFF;
    msg_count_lines_652F6();
}
/* 064B38-064B58 (32 B)  msg_text_to_editor_raw  [sub_64B38]  Confirmed
 * Callers: 064C5A tail (064C60).  Copy 80 chars and set length 0x50 via
 * the 06530A entry.                                                      */
void msg_text_to_editor_raw(void)
{
    memcpy(wx_text_buf, msg_text_074E, 0x50);
    msg_set_len_6530A(0x50);
}

/* 064B58-064B6A (18 B)  msg_goto_view  [sub_64B58]  Confirmed
 * cursor 0, state 0x38 (message view, F640 "VOICE PLAY" page family).   */
void msg_goto_view_64B58(void) { wx_sel = wx_cursor = 0; wx_state = 0x38; }

/* 064B6A-064B8C (34 B)  msg_goto_editor  [sub_64B6A]  Confirmed
 * 064B8C-064B96 (10 B)  msg_goto_editor_20  [sub_64B8C]  Confirmed
 * Editor: AD99 = text length (max 0x4F), cursor 0, B286 = 0, state 0x33;
 * 64B8C then forces state 0x20 (the F621 "NEW" page).                   */
void msg_goto_editor(void)
{
    text_set_cursor_to_len_19FDE(wx_text_buf, 0x4F);
    wx_sel = wx_cursor = 0; wx_B286 = 0;
    wx_state = 0x33;
}
void msg_goto_editor_20(void) { msg_goto_editor(); wx_state = 0x20; }

/* ---------------------------------------------------------------------------
 * 064B96-064BD0 (58 B)  msgbox_back  [sub_64B96]  Confirmed
 * Callers: 064A94, 064C8C, 064DB2.
 * Back from a message list: in mode 9/10 from states 0x1F/0x22 -> 065940;
 * else to the box menu with the cursor on the folder: 0x39 -> 3 (64634),
 * 0x37 -> 2 (64654), others -> 1 (64648).
 * ------------------------------------------------------------------------- */
void msgbox_back_64B96(void)
{
    if (home_app_mode != 8 && (wx_state == 0x1F || wx_state == 0x22)) { msg_back_65940(); return; }
    if (wx_state == 0x39)      msg_box_sel3();
    else if (wx_state == 0x37) msg_box_sel2();
    else                       msg_box_sel1();
}

/* 064BD0-064BE6 (22 B)  msg_goto_confirm  [sub_64BD0]  Confirmed
 * B92C = state, B3F6 = 0, state 0x3D (delete/confirm dialog, Inferred). */
void msg_goto_confirm(void) { msg_ret_B92C = wx_state; msg_B3F6 = 0; wx_state = 0x3D; }

/* ---------------------------------------------------------------------------
 * 064BE6 / 064BEE (8 B each)  msg_opt_A / msg_opt_B  [sub_64BE6,
 * sub_64BEE]  Confirmed (touch: preset B3EB = 0xA / 0xB).
 * 064BF6-064C4A (84 B)  msg_key7_s38  [sub_64BF6]  Confirmed
 * 064C5A-064C82 (40 B)  msg_view_back  [sub_64C5A]  Confirmed
 * Callers: off_601F4[0x38] (64BF6); 02B7D6, 0649CC, 064BF6, 064DB2 (64C5A).
 * State 0x38 = message view, items 0xA..0xC: long press consume.  For a
 * plain received message: < 0xA -> back to the list (647B4), 0xA ->
 * confirm (064C4A region / 64C5A -> 64BD0), 0xB -> REPLY: B41D = 1, clear
 * the editor, open it (64B6A), 0xC -> list.  For typed / outgoing
 * messages only 0xA (confirm) is allowed.  064C60: copy-back + 0653B8.
 * ------------------------------------------------------------------------- */
void msg_opt_A(void) { wx_sel = 0x0A; msg_key7_s38_body(); }
void msg_opt_B(void) { wx_sel = 0x0B; msg_key7_s38_body(); }
void msg_key7_s38(void)
{
    if (key_flags & 0x80) { consume_key(); return; }
    msg_key7_s38_body();
}
static void msg_key7_s38_body(void)                      /* 064C00 */
{
    u8 i = wx_sel, t = msg_cur[0];
    if ((t & 0x08) || (t & 7) == 4 || (t & 7) == 6 || (t & 0x01)) {
        if (i == 0x0A) { msg_view_back_64C5A(); return; }   /* 064C6A -> 64C4A */
        consume_key(); return;
    }
    if (i < 0x0A || i == 0x0C) { msg_list_restore_37(); return; }
    if (i == 0x0B) { msg_B41D = 1; msg_editor_clear(); msg_goto_editor(); return; }
    msg_view_back_64C5A();                              /* 0xA and > 0xC       */
}
void msg_view_back_64C5A(void) { msg_goto_confirm(); }   /* 064C5A */
void msg_view_copyback(void) { msg_text_to_editor_raw(); msg_after_copy_653B8(); } /* 064C60 */

/* ---------------------------------------------------------------------------
 * 064C82-064C8C (10 B)   msg_key7_s3E  [sub_64C82]  Confirmed
 * 064C8C-064D80 (244 B)  msg_open_inbox_row  [sub_64C8C]  Confirmed
 * Callers: off_601F4[0x3E] (64C82); 02BA0A (64C8C).
 * Inbox list (state 0x3E): long press -> box menu.  Select row: save list
 * position, B92B = row, copy the record; empty -> consume (A872 = 0).
 * Otherwise BAD C = 3, the 16-byte file name FF301E -> BADE and state 0x3F
 * (attachment viewer), sub_2C30A.  064D22..064D5C are the paging tails
 * (first / prev / next) as in 064A42.
 * ------------------------------------------------------------------------- */
void msg_key7_s3E(void)
{
    if (key_flags & 0x80) { msgbox_back_64B96(); return; }
    msg_open_inbox_row();
}
void msg_open_inbox_row(void)                            /* 064C8C */
{
    u8 r = wx_sel;
    msg_flags_BA93 |= 0x40; tmr_9567 = 0x19;
    msg_saved_sel = wx_sel; msg_saved_cur = wx_cursor;
    msg_slot_B92B = r;
    memcpy(msg_cur, &msg_store_FEEF20[r * 0x80], 0x80);
    if (msg_cur[0] & 0x80) {                            /* 064D68              */
        msg_A872 = 0; msg_flags_BA93 &= ~0x40; tmr_9567 = 0x0A;
        consume_key(); return;
    }
    msg_flags_BA93 &= ~0x40; tmr_9567 = 0x0A;
    viewer_kind_BADC = 3;
    memcpy(viewer_name_BADE, msg_file_name_301E, 0x10);
    wx_state = 0x3F;
    open_viewer_2C30A();
}

/* ---------------------------------------------------------------------------
 * 064DA8-064DB2 (10 B)   msg_key7_s39  [sub_64DA8]  Confirmed
 * 064DB2-064F76 (452 B)  msg_open_outbox_row  [sub_64DB2]  Confirmed
 * Callers: off_601F4[0x39] (64DA8); 02B84A, 02B85E, 065F36 (64DB2).
 * Folder-2 list (state 0x39; also 0x1F/0x22 when attaching): long press ->
 * back.  Select: copy the record; empty -> consume.  Plain unread ->
 * mark read, write back (sub_6A420), BAA3 = 0x22.  Otherwise (064E3E):
 * keep a second copy FF2F4A, BAD4 = 0x10, file name -> BAC2, size
 * FF301A -> BA96, start the SD read (sub_70BF6), BAA3 = 0x19.
 * 064E8E is the completion for BAA3 0x19/0x22: BAA3 = 0, 817E.b1,
 * busy indicator off; state 0x22 -> header (539A0), set reply fields
 * (64F9E), BBF1.b4, sub_ADC0; else header, then 0x3D -> 64F76 + 64C5A,
 * otherwise 64F76 + BBF1.b4 + sub_ADC0.  064EFE..064F52 are paging
 * tails (first page reload ends in sub_6F076 then 647EA, or 65E2C from
 * state 0x22).
 * ------------------------------------------------------------------------- */
void msg_key7_s39(void)
{
    if (key_flags & 0x80) { msgbox_back_64B96(); return; }
    msg_open_outbox_row();
}
void msg_open_outbox_row(void)                           /* 064DB2 */
{
    u8 r = wx_sel; u8 *rec; u8 t;
    msg_flags_BA93 |= 0x40; tmr_9567 = 0x19;
    msg_saved_sel = wx_sel; msg_saved_cur = wx_cursor;
    msg_slot_B92B = r;
    rec = &msg_store_FEEF20[r * 0x80];
    memcpy(msg_cur, rec, 0x80);
    t = msg_cur[0];
    if (t & 0x80) {                                     /* 064F5E              */
        msg_A872 = 0; msg_flags_BA93 &= ~0x40; tmr_9567 = 0x0A;
        consume_key(); return;
    }
    if (t != 0 && !(t & 0x01) && !(t & 0x10)) {
        t |= 0x10; rec[0] = t; msg_cur[0] = t;
        msg_write_back_6A420();
        sd_job_BAA3 = 0x22;
        return;
    }
    memcpy(msg_prev_2F4A, msg_cur, 0x80);               /* 064E3E              */
    sd_len_BAD4 = 0x10;
    memcpy(sd_name_BAC2, msg_file_name_301E, 0x10);
    sd_size_BA96 = msg_file_size_301A;
    sd_read_70BF6();
    sd_job_BAA3 = 0x19;
}
void msg_outbox_loaded(void)                             /* 064E8E */
{
    sd_job_BAA3 = 0;
    flags_817E |= 0x02;
    msg_flags_BA93 &= ~0x40; tmr_9567 = 0x0A;
    msg_header_539A0((u8 *)0xFF302E);
    if (wx_state == 0x22) {
        msg_set_reply_64F9E();
    } else if (wx_state == 0x3D) {
        msg_goto_options_64F76(); msg_view_back_64C5A(); return;
    } else {
        msg_goto_options_64F76();
    }
    flags_BBF1 |= 0x10;
    redraw_ADC0();
}

/* 064F76-064F9E (40 B)  msg_goto_options  [sub_64F76]  Confirmed
 * Callers: 064DB2, 0650A4, 065350, 0655B0.  State 0x3A (message options)
 * with cursor 0 for a typed record, 3 for an empty-type one.             */
void msg_goto_options_64F76(void)
{
    u8 c = (msg_cur[0] != 0) ? 0 : 3;
    wx_sel = wx_cursor = c;
    wx_state = 0x3A;
}
/* 064F9E-064FB0 (18 B)  msg_set_reply  [sub_64F9E]  Confirmed
 * cursor 2, state 0x23.                                                  */
void msg_set_reply_64F9E(void) { wx_sel = wx_cursor = 2; wx_state = 0x23; }

/* ---------------------------------------------------------------------------
 * 064FB0-065024 (116 B)  msg_key7_s3A  [sub_64FB0]  Confirmed
 * 065024-06502A (6 B)    msg_opt_confirm  [sub_65024]  Confirmed
 * 06502E-065030 (2 B)    j_nullsub_61 (bra to rts)
 * Callers: 02B924 (64FB0 entry, B3EB = 7); 064FB8 (B3EB = 8); off_601F4
 * [0x3A] -> 064FC0; 02B85E/02BA26/064FB0 (65024).
 * Options of an outgoing / plain message (state 0x3A, items 7..9+).
 * Plain received: < 7 or 9 -> 065036 (not listed), 7 -> forward list
 * (65076, state 0x36), 8 -> REPLY (B41D = 2, clear editor, open editor),
 * > 9 -> confirm (65024).  Outgoing (b0): only item 7 (06502A).  Typed:
 * 065030.  (Several targets 065030..06506A sit outside the function list.)
 * ------------------------------------------------------------------------- */
void msg_key7_s3A(void)                                  /* 064FB0 */
{
    u8 i = wx_sel, t = msg_cur[0];
    if ((t & 0x08) || t == 0 || (t & 7) == 4 || (t & 7) == 6) { msg_opt_typed_65030(t); return; }
    if (t & 0x01) { if (i == 7) msg_opt_out7_6502A(); else consume_key(); return; }
    if (i < 7 || i == 9) { msg_opt_list_65036(); return; }
    if (i == 7) { msg_goto_forward_65076(); return; }
    if (i == 8) { msg_B41D = 2; msg_editor_clear(); msg_goto_editor(); return; }
    msg_opt_confirm();
}
void msg_opt_confirm(void) { msg_goto_confirm(); }       /* 065024 */

/* 065058-065064 (12 B)  msg_forward_or_mode8  [sub_65058]  Confirmed
 * 065064-06506A (6 B)   msg_mode8_forward  [sub_65064]  Confirmed
 * 065074-065076 (2 B)   nullsub_61 (rts)
 * Callers: 02B91C (65058); 02AC1A, 065058 (65064).
 * Mode 8 -> sub_65668; else the forward list (65076).                    */
void msg_forward_or_mode8(void) { if (home_app_mode == 8) msg_mode8_forward(); else msg_goto_forward_65076(); }
void msg_mode8_forward(void)    { msg_forward_65668(); }

/* 065076-065090 (26 B)  msg_goto_forward  [sub_65076]  Confirmed
 * Callers: 064FB0, 065058.  B410 = state, cursor 0, state 0x36.          */
void msg_goto_forward_65076(void) { msg_ret_B410 = wx_state; wx_sel = wx_cursor = 0; wx_state = 0x36; }

/* 065090-0650A4 (20 B)  msg_goto_rename  [sub_65090]  Confirmed
 * AD99 = length of the 16-char name FF300A (max 0x0F), state 0x3B.       */
void msg_goto_rename(void)
{
    text_set_cursor_to_len_19FDE(msg_text_300A, 0x0F);
    wx_state = 0x3B;
}

/* ---------------------------------------------------------------------------
 * 0650A4-065138 (148 B)  msg_key7_s3B  [sub_650A4]  Confirmed
 * 065138-06514A (18 B)   pad_ff_to_space  [sub_65138]  Confirmed
 * Callers: off_601F4[0x3B] (650A4); 0650A4, 06F15E (65138).
 * State 0x3B (rename, 16 chars FF300A).  Short press: next char position
 * (sub_1A006, max 15).  Long press (if not empty): 0xFF -> ' ' over the
 * 16 chars, nullsub_42 with the SD block number word_FFB92E[B92B]*0x80
 * (the write is stubbed out in this build), copy FF2FCA back into the
 * store slot and FF2F4A, then the option menu (64F76).
 * ------------------------------------------------------------------------- */
void msg_key7_s3B(void)                                  /* 0650A4 */
{
    if (!(key_flags & 0x80)) {
        text_cursor_next_1A006(&msg_text_300A[edit_cursor], edit_cursor, 0x0F);
        return;
    }
    if (msg_text_300A[0] == 0xFF) return;
    pad_ff_to_space(msg_text_300A, 0x10);
    nullsub_42(/* er1 = */ (u32)word_FFB92E[msg_slot_B92B] * 0x80);
    memcpy(&msg_store_FEEF20[msg_slot_B92B * 0x80], msg_cur, 0x80);
    memcpy(msg_prev_2F4A, msg_cur, 0x80);
    msg_goto_options_64F76();
}
void pad_ff_to_space(u8 *p /* er5 */, u8 n /* r6l */)    /* 065138 */
{
    while (n--) { if (*p == 0xFF) *p = ' '; p++; }
}

/* ---------------------------------------------------------------------------
 * 06514A-06519E (84 B)  msg_editor_key7  [sub_6514A]  Confirmed
 * 06519E-0651E8 (74 B)  msg_editor_done  [sub_6519E]  Confirmed
 * 0651E8-065202 (26 B)  msg_goto_symbols  [sub_651E8]  Confirmed
 * Callers: off_601F4[0x20]/[0x33] (6514A); 06514A/0660D6 (6519E);
 *          06514A (651E8); 02B92C (06517A, doc 103: F621 IDX 3).
 * Message editor (80 chars at FF061A, cursor AD99).  Short press: cursor
 * on 0xFF -> consume; on 0xFE (symbol placeholder) -> symbol picker
 * (state 0x24, B40F = return state); else next char (sub_1A006, max 0x4F).
 * Long press (06517A): count length/lines (652F6), then states 0x20/0x21
 * -> state 0x21 (send page), others -> state 0x34 with B286 =
 * byte_652F0[lines]; then 0x21 -> sub_65410, 0x34 -> sub_6537A.
 * ------------------------------------------------------------------------- */
void msg_editor_key7(void)                               /* 06514A */
{
    u8 c;
    if (key_flags & 0x80) { msg_editor_finish(); return; }
    c = wx_text_buf[edit_cursor];
    if (c == 0xFF) { consume_key(); return; }
    if (c == 0xFE) { msg_goto_symbols(); return; }
    text_cursor_next_1A006(&wx_text_buf[edit_cursor], edit_cursor, 0x4F);
}
void msg_editor_finish(void)                             /* 06517A */
{
    msg_count_lines_652F6();
    msg_editor_done();
    if (wx_state == 0x34)      msg_preview_6537A();
    else if (wx_state == 0x21) msg_send_page_65410();
}
void msg_editor_done(void)                               /* 06519E */
{
    if (wx_state == 0x20 || wx_state == 0x21) { msg_goto_s21_651D6(); return; }
    wx_sel = 0;
    wx_B286 = byte_652F0[ram_FF0619];                   /* {0,1,2,3,4,0}       */
    wx_cursor = 0;
    wx_state = 0x34;
}
void msg_goto_s21_651D6(void) { wx_sel = wx_cursor = 0; wx_state = 0x21; }  /* 0651D6 */
void msg_goto_symbols(void)                              /* 0651E8 */
{
    msg_ret_B40F = wx_state;
    wx_sel = wx_cursor = 0;
    wx_state = 0x24;
}

/* ---------------------------------------------------------------------------
 * 065202-0652B0 (174 B)  msg_goto_templates  [sub_65202]  Confirmed
 * 0652B0-0652D0 (32 B)   msg_save_editor_pos  [sub_652B0]  Confirmed
 * 0652D0-0652F0 (32 B)   msg_restore_editor_pos  [sub_652D0]  Confirmed
 * Callers: 065374 (65202); 065202 (652B0); 0660D6 (652D0).
 * Template picker (state 0x25).  B40F = state, save the editor position
 * in FFB283..5.  The list has a ROM part (16-byte entries at 0x0432C6,
 * 0x2B of them, or 0x043576, 0x13 of them, chosen by B963.b0) followed by
 * the user templates loaded from EEPROM (sub_3DC7A -> FFB8D8).  The
 * cursor starts at the first empty user slot (0xFF), capped at the last
 * slot (0x34 resp. 0x1C).
 * ------------------------------------------------------------------------- */
void msg_goto_templates(void)                            /* 065202 */
{
    u8 base = (gm_B963 & 1) ? 0x13 : 0x2B, last = (gm_B963 & 1) ? 0x1C : 0x34, i;
    const u8 *e;
    msg_ret_B40F = wx_state;
    msg_save_editor_pos();
    for (i = base; ; i++) {
        if (i < base) e = ((gm_B963 & 1) ? rom_43576 : rom_432C6) + i * 0x10;
        else { load_template_3DC7A(i - base); e = tmpl_buf_B8D8; }
        if (*e == 0xFF) break;
        if (i + 1 > last) { i = last; break; }
    }
    wx_sel = wx_cursor = i;
    wx_state = 0x25;
}
void msg_save_editor_pos(void)    { ed_pos_B283[0] = wx_sel; ed_pos_B283[1] = wx_cursor; ed_pos_B283[2] = wx_B286; }
void msg_restore_editor_pos(void) { wx_sel = ed_pos_B283[0]; wx_cursor = ed_pos_B283[1]; wx_B286 = ed_pos_B283[2]; }
/* (0652F0: byte_652F0 = {0,1,2,3,4,0}, the per-line-count first row.)   */

/* ==========================================================================
 * Part 9: auto-extracted skeletons for the functions not hand-transcribed.
 * ========================================================================== */

/* ---------------------------------------------------------------------------
 * 0652F6-065302 (12 B)  msg_0652F6  [sub_652F6]  Confirmed
 * Callers: 0649CC, 064B02, 06514A.
 * Body (complete):
 *   0652F6  mov.b   #0, r3l
 *   0652F8  mov.l   #0xFF061A, er5
 *   0652FE  mov.b   @er5+, r4l
 *   065300  cmp.b   #0xFF, r4l
 * ------------------------------------------------------------------------- */
void msg_0652F6(void) { /* see body above */ }

/* ---------------------------------------------------------------------------
 * 065302-06533C (58 B)  msg_065302  [sub_65302]  Skeleton
 * Callers: table/indirect or fall-through (none by absolute reference).
 * writes ram_FF0618, ram_FF0619
 * ------------------------------------------------------------------------- */
void msg_065302(void)
{
    /* TODO(waveC): 25-instruction body not hand-transcribed; the facts
       above are extracted from the listing (065302..06533C). */
}

/* ---------------------------------------------------------------------------
 * 06533C-065350 (20 B)  msg_06533C  [sub_6533C]  Skeleton
 * Callers: table/indirect or fall-through (none by absolute reference).
 * reads wx_sel
 * ------------------------------------------------------------------------- */
void msg_06533C(void)
{
    /* TODO(waveC): 9-instruction body not hand-transcribed; the facts
       above are extracted from the listing (06533C..065350). */
}

/* ---------------------------------------------------------------------------
 * 065350-06536E (30 B)  msg_065350  [sub_65350]  Skeleton
 * Callers: 02BF76.
 * calls sub_647C6, sub_64B58, sub_64F76
 * reads msg_B41D
 * ------------------------------------------------------------------------- */
void msg_065350(void)
{
    /* TODO(waveC): 11-instruction body not hand-transcribed; the facts
       above are extracted from the listing (065350..06536E). */
}

/* ---------------------------------------------------------------------------
 * 06536E-065374 (6 B)  msg_06536E  [sub_6536E]  Confirmed
 * Callers: 02B622, 06533C.
 * calls sub_64B6A
 * Body (complete):
 *   06536E  jsr     sub_64B6A:24
 *   065372  bra     locret_653B6:8
 * ------------------------------------------------------------------------- */
void msg_06536E(void) { /* see body above */ }

/* ---------------------------------------------------------------------------
 * 065374-06537A (6 B)  msg_065374  [sub_65374]  Confirmed
 * Callers: 06533C.
 * calls sub_65202
 * Body (complete):
 *   065374  jsr     sub_65202:24
 *   065378  bra     locret_653B6:8
 * ------------------------------------------------------------------------- */
void msg_065374(void) { /* see body above */ }

/* ---------------------------------------------------------------------------
 * 06537A-0653B8 (62 B)  msg_06537A  [sub_6537A]  Skeleton
 * Callers: 06514A, 06533C.
 * calls sub_653B8, sub_654F8, sub_3FFA0
 * writes ram_FFB3FD
 * reads msg_B41D
 * ------------------------------------------------------------------------- */
void msg_06537A(void)
{
    /* TODO(waveC): 21-instruction body not hand-transcribed; the facts
       above are extracted from the listing (06537A..0653B8). */
}

/* ---------------------------------------------------------------------------
 * 0653B8-0653D2 (26 B)  msg_goto_s35_0653B8  [sub_653B8]  Skeleton
 * Callers: 064C5A, 06537A.
 * sets wx_state = 0x35
 * writes msg_ret_B410, wx_cursor, wx_sel, wx_state
 * ------------------------------------------------------------------------- */
void msg_goto_s35_0653B8(void)
{
    /* TODO(waveC): 8-instruction body not hand-transcribed; the facts
       above are extracted from the listing (0653B8..0653D2). */
}

/* ---------------------------------------------------------------------------
 * 0653D2-0653F8 (38 B)  msg_0653D2  [sub_653D2]  Skeleton
 * Callers: table/indirect or fall-through (none by absolute reference).
 * reads ram_FF0619, wx_sel
 * ------------------------------------------------------------------------- */
void msg_0653D2(void)
{
    /* TODO(waveC): 16-instruction body not hand-transcribed; the facts
       above are extracted from the listing (0653D2..0653F8). */
}

/* ---------------------------------------------------------------------------
 * 0653F8-0653FE (6 B)  msg_0653F8  [sub_653F8]  Confirmed
 * Callers: 02BF60.
 * calls sub_65E3E
 * Body (complete):
 *   0653F8  jsr     sub_65E3E:24
 *   0653FC  bra     locret_65440:8
 * ------------------------------------------------------------------------- */
void msg_0653F8(void) { /* see body above */ }

/* ---------------------------------------------------------------------------
 * 065410-065442 (50 B)  msg_065410  [sub_65410]  Skeleton
 * Callers: 06514A, 0653D2.
 * calls sub_67B6A, sub_6F4C6, sub_65442, sub_6A1AE, sub_65E76, sub_3FFA0
 * writes ram_FFB3FD
 * reads home_app_mode
 * ------------------------------------------------------------------------- */
void msg_065410(void)
{
    /* TODO(waveC): 18-instruction body not hand-transcribed; the facts
       above are extracted from the listing (065410..065442). */
}

/* ---------------------------------------------------------------------------
 * 065442-06545A (24 B)  msg_065442  [sub_65442]  Skeleton
 * Callers: 05F5D0, 065410, 065F5C.
 * reads wx_menu_origin
 * ------------------------------------------------------------------------- */
void msg_065442(void)
{
    /* TODO(waveC): 7-instruction body not hand-transcribed; the facts
       above are extracted from the listing (065442..06545A). */
}

/* ---------------------------------------------------------------------------
 * 06545A-0654F8 (158 B)  msg_06545A  [sub_6545A]  Skeleton
 * Callers: 02B5E6.
 * writes ram_FFB3FD
 * reads wx_B3EF, wx_sel
 * ------------------------------------------------------------------------- */
void msg_06545A(void)
{
    /* TODO(waveC): 55-instruction body not hand-transcribed; the facts
       above are extracted from the listing (06545A..0654F8). */
}

/* ---------------------------------------------------------------------------
 * 0654F8-06558E (150 B)  msg_0654F8  [sub_654F8]  Skeleton
 * Callers: 06537A, 06545A.
 * calls sub_67B6A, sub_6F4C6, sub_6F4E0, sub_6A1AE, sub_6558E,
 *     sub_651AA, sub_64B58, sub_3FFA0
 * writes ram_FFB3FD, wx_B95E
 * reads home_app_mode, msg_ret_B410
 * ------------------------------------------------------------------------- */
void msg_0654F8(void)
{
    /* TODO(waveC): 52-instruction body not hand-transcribed; the facts
       above are extracted from the listing (0654F8..06558E). */
}

/* ---------------------------------------------------------------------------
 * 06558E-0655A0 (18 B)  msg_goto_s3C_06558E  [sub_6558E]  Skeleton
 * Callers: 0654F8, 0655B0.
 * sets wx_state = 0x3C
 * writes wx_cursor, wx_sel, wx_state
 * ------------------------------------------------------------------------- */
void msg_goto_s3C_06558E(void)
{
    /* TODO(waveC): 6-instruction body not hand-transcribed; the facts
       above are extracted from the listing (06558E..0655A0). */
}

/* ---------------------------------------------------------------------------
 * 0655B0-0656BA (266 B)  msg_0655B0  [sub_655B0]  Skeleton
 * Callers: 02B6CA.
 * calls sub_5EE1A, sub_6A628, sub_6558E, sub_64F76, sub_3FFA0
 * writes ram_FF2EC9, ram_FFB3FD, wx_B275, wx_B95E
 * reads home_app_mode, wx_B3EF, wx_sel
 * ------------------------------------------------------------------------- */
void msg_0655B0(void)
{
    /* TODO(waveC): 89-instruction body not hand-transcribed; the facts
       above are extracted from the listing (0655B0..0656BA). */
}

/* ---------------------------------------------------------------------------
 * 0656BA-0656BC (2 B)  msg_nop_0656BA  [sub_656BA]  Confirmed
 * Callers: table/indirect or fall-through (none by absolute reference).
 * Body (complete):
 *   0656BA  rts
 * ------------------------------------------------------------------------- */
void msg_nop_0656BA(void) { /* see body above */ }

/* ---------------------------------------------------------------------------
 * 0656BC-0656C6 (10 B)  msg_0656BC  [sub_656BC]  Confirmed
 * Callers: table/indirect or fall-through (none by absolute reference).
 * reads ram_FFB3F6
 * Body (complete):
 *   0656BC  mov.b   @0xFFFFB3F6:16, r4l
 *   0656C0  cmp.b   #1, r4l
 *   0656C2  beq     sub_6579A:16
 * ------------------------------------------------------------------------- */
void msg_0656BC(void) { /* see body above */ }

/* ---------------------------------------------------------------------------
 * 0656C6-06579A (212 B)  msg_0656C6  [sub_656C6]  Skeleton
 * Callers: 02B988.
 * calls sub_6F414, sub_1BF8E, sub_6475A, sub_65D84, nullsub_41,
 *     sub_64F06, sub_6F3F6, sub_64782, sub_65DAE, nullsub_40, sub_64A42
 * writes sd_job_BAA3, wx_state
 * reads msg_ret_B92C, msg_slot_B92B
 * ------------------------------------------------------------------------- */
void msg_0656C6(void)
{
    /* TODO(waveC): 69-instruction body not hand-transcribed; the facts
       above are extracted from the listing (0656C6..06579A). */
}

/* ---------------------------------------------------------------------------
 * 06579A-0657AA (16 B)  msg_06579A  [sub_6579A]  Skeleton
 * Callers: 02B9A8, 0656BC.
 * calls sub_3FFA0
 * writes wx_state
 * reads msg_ret_B92C
 * ------------------------------------------------------------------------- */
void msg_06579A(void)
{
    /* TODO(waveC): 5-instruction body not hand-transcribed; the facts
       above are extracted from the listing (06579A..0657AA). */
}

/* ---------------------------------------------------------------------------
 * 0657CC-0657DC (16 B)  msg_0657CC  [sub_657CC]  Skeleton
 * Callers: table/indirect or fall-through (none by absolute reference).
 * calls sub_1BF8E, sub_647FC
 * writes sd_job_BAA3
 * ------------------------------------------------------------------------- */
void msg_0657CC(void)
{
    /* TODO(waveC): 5-instruction body not hand-transcribed; the facts
       above are extracted from the listing (0657CC..0657DC). */
}

/* ---------------------------------------------------------------------------
 * 0657DC-065854 (120 B)  msg_0657DC  [sub_657DC]  Skeleton
 * Callers: table/indirect or fall-through (none by absolute reference).
 * calls sub_6080A, sub_6073C, sub_658A4, sub_65854, sub_644B8, sub_3FFA0
 * writes gm_B420, popup_tmr, tone_ev, wx_req_flags
 * reads key_flags, wx_busy, wx_sel
 * ------------------------------------------------------------------------- */
void msg_0657DC(void)
{
    /* TODO(waveC): 41-instruction body not hand-transcribed; the facts
       above are extracted from the listing (0657DC..065854). */
}

/* ---------------------------------------------------------------------------
 * 065854-06587C (40 B)  msg_065854  [sub_65854]  Skeleton
 * Callers: 060E78, 060ED4, 060F2C, 0657DC.
 * calls sub_659AE, sub_62B7A, sub_6587C, sub_3FFA0
 * writes ram_FFB47B
 * reads ram_FFB328
 * ------------------------------------------------------------------------- */
void msg_065854(void)
{
    /* TODO(waveC): 15-instruction body not hand-transcribed; the facts
       above are extracted from the listing (065854..06587C). */
}

/* ---------------------------------------------------------------------------
 * 06587C-065890 (20 B)  msg_06587C  [sub_6587C]  Skeleton
 * Callers: 065854.
 * writes wx_cursor, wx_page, wx_rows, wx_sel
 * ------------------------------------------------------------------------- */
void msg_06587C(void)
{
    /* TODO(waveC): 6-instruction body not hand-transcribed; the facts
       above are extracted from the listing (06587C..065890). */
}

/* ---------------------------------------------------------------------------
 * 065890-065898 (8 B)  msg_goto_s1E_065890  [sub_65890]  Confirmed
 * Callers: 067A0E.
 * sets wx_state = 0x1E
 * writes wx_state
 * Body (complete):
 *   065890  mov.b   #0x1E, r4l
 *   065892  mov.b   r4l, @0xFFFFB3EA:16
 *   065896  rts
 * ------------------------------------------------------------------------- */
void msg_goto_s1E_065890(void) { /* see body above */ }

/* ---------------------------------------------------------------------------
 * 065898-0658A4 (12 B)  msg_065898  [sub_65898]  Confirmed
 * Callers: 065974.
 * writes wx_cursor, wx_sel
 * Body (complete):
 *   065898  mov.b   #1, r4l
 *   06589A  mov.b   r4l, @0xFFFFB3EB:16
 *   06589E  mov.b   r4l, @0xFFFFB3F1:16
 *   0658A2  bra     loc_658AE:8
 * ------------------------------------------------------------------------- */
void msg_065898(void) { /* see body above */ }

/* ---------------------------------------------------------------------------
 * 0658A4-0658B6 (18 B)  msg_goto_s14_0658A4  [sub_658A4]  Skeleton
 * Callers: 060E78, 060F2C, 0657DC, 065D5E.
 * sets wx_state = 0x14
 * writes wx_cursor, wx_sel, wx_state
 * ------------------------------------------------------------------------- */
void msg_goto_s14_0658A4(void)
{
    /* TODO(waveC): 6-instruction body not hand-transcribed; the facts
       above are extracted from the listing (0658A4..0658B6). */
}

/* ---------------------------------------------------------------------------
 * 0658B6-0658CE (24 B)  msg_0658B6  [sub_658B6]  Skeleton
 * Callers: table/indirect or fall-through (none by absolute reference).
 * reads key_flags, wx_sel
 * ------------------------------------------------------------------------- */
void msg_0658B6(void)
{
    /* TODO(waveC): 9-instruction body not hand-transcribed; the facts
       above are extracted from the listing (0658B6..0658CE). */
}

/* ---------------------------------------------------------------------------
 * 0658CE-065920 (82 B)  msg_0658CE  [sub_658CE]  Skeleton
 * Callers: 065F0C.
 * calls sub_60C64, sub_646C8, sub_64690, sub_6592E, sub_6594E,
 *     sub_3FF9C, sub_3FFA0
 * writes ram_FFB328
 * reads ram_FFB326, wx_B324, wx_menu_origin
 * ------------------------------------------------------------------------- */
void msg_0658CE(void)
{
    /* TODO(waveC): 28-instruction body not hand-transcribed; the facts
       above are extracted from the listing (0658CE..065920). */
}

/* ---------------------------------------------------------------------------
 * 065920-065940 (32 B)  msg_goto_s15_065920  [sub_65920]  Skeleton
 * Callers: 065BA6, 067A0E.
 * sets wx_state = 0x15
 * writes wx_cursor, wx_sel, wx_state
 * reads ram_FFB47B
 * ------------------------------------------------------------------------- */
void msg_goto_s15_065920(void)
{
    /* TODO(waveC): 10-instruction body not hand-transcribed; the facts
       above are extracted from the listing (065920..065940). */
}

/* ---------------------------------------------------------------------------
 * 065940-06594E (14 B)  msg_065940  [sub_65940]  Confirmed
 * Callers: 064B96, 067A0E.
 * writes wx_cursor, wx_sel
 * reads ram_FFB47B
 * Body (complete):
 *   065940  mov.b   @0xFFFFB47B:16, r4l
 *   065944  mov.b   r4l, @0xFFFFB3EB:16
 *   065948  mov.b   r4l, @0xFFFFB3F1:16
 *   06594C  bra     loc_65958:8
 * ------------------------------------------------------------------------- */
void msg_065940(void) { /* see body above */ }

/* ---------------------------------------------------------------------------
 * 06594E-065950 (2 B)  msg_06594E  [sub_6594E]  Confirmed
 * Callers: 0658CE.
 * Body (complete):
 *   06594E  mov.b   #0, r4l
 * ------------------------------------------------------------------------- */
void msg_06594E(void) { /* see body above */ }

/* ---------------------------------------------------------------------------
 * 065950-065960 (16 B)  msg_goto_s1B_065950  [sub_65950]  Skeleton
 * Callers: table/indirect or fall-through (none by absolute reference).
 * sets wx_state = 0x1B
 * writes wx_cursor, wx_sel, wx_state
 * ------------------------------------------------------------------------- */
void msg_goto_s1B_065950(void)
{
    /* TODO(waveC): 5-instruction body not hand-transcribed; the facts
       above are extracted from the listing (065950..065960). */
}

/* ---------------------------------------------------------------------------
 * 065960-065974 (20 B)  msg_065960  [sub_65960]  Skeleton
 * Callers: table/indirect or fall-through (none by absolute reference).
 * reads key_flags, wx_sel
 * ------------------------------------------------------------------------- */
void msg_065960(void)
{
    /* TODO(waveC): 7-instruction body not hand-transcribed; the facts
       above are extracted from the listing (065960..065974). */
}

/* ---------------------------------------------------------------------------
 * 065974-0659AE (58 B)  msg_065974  [sub_65974]  Skeleton
 * Callers: 02B33C.
 * calls sub_659AE, sub_62B7A, sub_65A6C, sub_65898, sub_60C7E, sub_3FFA0
 * writes ram_FFB47B
 * reads wx_req_flags
 * ------------------------------------------------------------------------- */
void msg_065974(void)
{
    /* TODO(waveC): 16-instruction body not hand-transcribed; the facts
       above are extracted from the listing (065974..0659AE). */
}

/* ---------------------------------------------------------------------------
 * 0659AE-065A6C (190 B)  msg_0659AE  [sub_659AE]  Skeleton
 * Callers: 065854, 065974.
 * writes ram_FFB29A, ram_FFB2A1, wx_B299
 * reads wx_menu_origin, wx_req_flags
 * ------------------------------------------------------------------------- */
void msg_0659AE(void)
{
    /* TODO(waveC): 59-instruction body not hand-transcribed; the facts
       above are extracted from the listing (0659AE..065A6C). */
}

/* ---------------------------------------------------------------------------
 * 065A6C-065A80 (20 B)  msg_065A6C  [sub_65A6C]  Skeleton
 * Callers: 065974.
 * writes wx_cursor, wx_page, wx_rows, wx_sel
 * ------------------------------------------------------------------------- */
void msg_065A6C(void)
{
    /* TODO(waveC): 6-instruction body not hand-transcribed; the facts
       above are extracted from the listing (065A6C..065A80). */
}

/* ---------------------------------------------------------------------------
 * 065A80-065A88 (8 B)  msg_goto_s16_065A80  [sub_65A80]  Confirmed
 * Callers: 065CEE, 065D1C, 067A0E.
 * sets wx_state = 0x16
 * writes wx_state
 * Body (complete):
 *   065A80  mov.b   #0x16, r4l
 *   065A82  mov.b   r4l, @0xFFFFB3EA:16
 *   065A86  rts
 * ------------------------------------------------------------------------- */
void msg_goto_s16_065A80(void) { /* see body above */ }

/* ---------------------------------------------------------------------------
 * 065A8C-065AAE (34 B)  msg_065A8C  [sub_65A8C]  Skeleton
 * Callers: 065AF0, 065EC2.
 * writes ram_FFB277, ram_FFB278, ram_FFB279, ram_FFB27A
 * reads wx_cursor, wx_page, wx_rows, wx_sel
 * ------------------------------------------------------------------------- */
void msg_065A8C(void)
{
    /* TODO(waveC): 9-instruction body not hand-transcribed; the facts
       above are extracted from the listing (065A8C..065AAE). */
}

/* ---------------------------------------------------------------------------
 * 065AAE-065AD0 (34 B)  msg_065AAE  [sub_65AAE]  Skeleton
 * Callers: 065CEE, 065D1C, 067A0E.
 * writes wx_cursor, wx_page, wx_rows, wx_sel
 * reads ram_FFB277, ram_FFB278, ram_FFB279, ram_FFB27A
 * ------------------------------------------------------------------------- */
void msg_065AAE(void)
{
    /* TODO(waveC): 9-instruction body not hand-transcribed; the facts
       above are extracted from the listing (065AAE..065AD0). */
}

/* ---------------------------------------------------------------------------
 * 065AD0-065AF0 (32 B)  msg_065AD0  [sub_65AD0]  Skeleton
 * Callers: 02B356, 02BDF6.
 * writes touch_reject
 * reads wx_busy, wx_rows
 * ------------------------------------------------------------------------- */
void msg_065AD0(void)
{
    /* TODO(waveC): 9-instruction body not hand-transcribed; the facts
       above are extracted from the listing (065AD0..065AF0). */
}

/* ---------------------------------------------------------------------------
 * 065AF0-065B66 (118 B)  msg_065AF0  [sub_65AF0]  Skeleton
 * Callers: table/indirect or fall-through (none by absolute reference).
 * calls sub_65A8C, sub_65BF8, sub_62C32, sub_65E62, sub_65C84
 * writes ram_FFB47C
 * reads key_flags, ram_FFB47B, wx_busy, wx_rows, wx_sel
 * ------------------------------------------------------------------------- */
void msg_065AF0(void)
{
    /* TODO(waveC): 30-instruction body not hand-transcribed; the facts
       above are extracted from the listing (065AF0..065B66). */
}

/* ---------------------------------------------------------------------------
 * 065B66-065B86 (32 B)  msg_065B66  [sub_65B66]  Skeleton
 * Callers: 065EFA.
 * writes ram_FFB2A1
 * ------------------------------------------------------------------------- */
void msg_065B66(void)
{
    /* TODO(waveC): 10-instruction body not hand-transcribed; the facts
       above are extracted from the listing (065B66..065B86). */
}

/* ---------------------------------------------------------------------------
 * 065B86-065BA6 (32 B)  msg_065B86  [sub_65B86]  Skeleton
 * Callers: 065F00.
 * writes ram_FFB2A1
 * ------------------------------------------------------------------------- */
void msg_065B86(void)
{
    /* TODO(waveC): 10-instruction body not hand-transcribed; the facts
       above are extracted from the listing (065B86..065BA6). */
}

/* ---------------------------------------------------------------------------
 * 065BA6-065BF8 (82 B)  msg_065BA6  [sub_65BA6]  Skeleton
 * Callers: 065F06.
 * calls sub_62B7A, sub_65920, sub_3FFA0
 * writes popup_tmr, ram_FFB2A1, tone_ev, wx_cursor, wx_sel
 * reads ram_FF1434
 * ------------------------------------------------------------------------- */
void msg_065BA6(void)
{
    /* TODO(waveC): 26-instruction body not hand-transcribed; the facts
       above are extracted from the listing (065BA6..065BF8). */
}

/* ---------------------------------------------------------------------------
 * 065BF8-065C50 (88 B)  msg_065BF8  [sub_65BF8]  Skeleton
 * Callers: 065AF0.
 * sets wx_state = 0x19
 * calls sub_2B42C
 * writes ram_FFBBE2, wx_state
 * reads ram_FFB47C
 * ------------------------------------------------------------------------- */
void msg_065BF8(void)
{
    /* TODO(waveC): 27-instruction body not hand-transcribed; the facts
       above are extracted from the listing (065BF8..065C50). */
}

/* ---------------------------------------------------------------------------
 * 065C50-065C84 (52 B)  msg_goto_s18_065C50  [sub_65C50]  Skeleton
 * Callers: 06754C.
 * sets wx_state = 0x18
 * tone_ev = 0x59
 * calls sub_673C6
 * writes ram_FF071A, tone_ev, wx_cursor, wx_sel, wx_state
 * ------------------------------------------------------------------------- */
void msg_goto_s18_065C50(void)
{
    /* TODO(waveC): 12-instruction body not hand-transcribed; the facts
       above are extracted from the listing (065C50..065C84). */
}

/* ---------------------------------------------------------------------------
 * 065C84-065CA4 (32 B)  msg_goto_s17_065C84  [sub_65C84]  Skeleton
 * Callers: 065AF0.
 * sets wx_state = 0x17
 * writes wx_B266, wx_B275, wx_state
 * ------------------------------------------------------------------------- */
void msg_goto_s17_065C84(void)
{
    /* TODO(waveC): 7-instruction body not hand-transcribed; the facts
       above are extracted from the listing (065C84..065CA4). */
}

/* ---------------------------------------------------------------------------
 * 065CA4-065CCE (42 B)  msg_goto_s28_065CA4  [sub_65CA4]  Skeleton
 * Callers: 065EC2.
 * sets wx_state = 0x28
 * writes wx_B266, wx_B275, wx_cursor, wx_sel, wx_state
 * ------------------------------------------------------------------------- */
void msg_goto_s28_065CA4(void)
{
    /* TODO(waveC): 10-instruction body not hand-transcribed; the facts
       above are extracted from the listing (065CA4..065CCE). */
}

/* ---------------------------------------------------------------------------
 * 065CCE-065CD6 (8 B)  msg_065CCE  [sub_65CCE]  Confirmed
 * Callers: table/indirect or fall-through (none by absolute reference).
 * reads key_flags
 * Body (complete):
 *   065CCE  btst    #7, @0xFFFFA9EE:16
 *   065CD4  bne     loc_65CE8:8
 * ------------------------------------------------------------------------- */
void msg_065CCE(void) { /* see body above */ }

/* ---------------------------------------------------------------------------
 * 065CD6-065CEE (24 B)  msg_065CD6  [sub_65CD6]  Skeleton
 * Callers: table/indirect or fall-through (none by absolute reference).
 * calls sub_3FFA0
 * writes popup_tmr, tone_ev, wx_B266
 * ------------------------------------------------------------------------- */
void msg_065CD6(void)
{
    /* TODO(waveC): 7-instruction body not hand-transcribed; the facts
       above are extracted from the listing (065CD6..065CEE). */
}

/* ---------------------------------------------------------------------------
 * 065CEE-065D06 (24 B)  msg_065CEE  [sub_65CEE]  Skeleton
 * Callers: table/indirect or fall-through (none by absolute reference).
 * calls sub_65AAE, sub_65A80, sub_3FFA0
 * reads key_flags
 * ------------------------------------------------------------------------- */
void msg_065CEE(void)
{
    /* TODO(waveC): 7-instruction body not hand-transcribed; the facts
       above are extracted from the listing (065CEE..065D06). */
}

/* ---------------------------------------------------------------------------
 * 065D06-065D1C (22 B)  msg_065D06  [sub_65D06]  Skeleton
 * Callers: table/indirect or fall-through (none by absolute reference).
 * reads key_flags, wx_sel
 * ------------------------------------------------------------------------- */
void msg_065D06(void)
{
    /* TODO(waveC): 8-instruction body not hand-transcribed; the facts
       above are extracted from the listing (065D06..065D1C). */
}

/* ---------------------------------------------------------------------------
 * 065D1C-065D3C (32 B)  msg_065D1C  [sub_65D1C]  Skeleton
 * Callers: 02B3EC, 065D06, 06754C.
 * calls sub_65AAE, sub_65A80, sub_62C32, sub_65E62, sub_3FFA0
 * reads ram_FFB47C
 * ------------------------------------------------------------------------- */
void msg_065D1C(void)
{
    /* TODO(waveC): 10-instruction body not hand-transcribed; the facts
       above are extracted from the listing (065D1C..065D3C). */
}

/* ---------------------------------------------------------------------------
 * 065D3C-065D44 (8 B)  msg_065D3C  [sub_65D3C]  Confirmed
 * Callers: table/indirect or fall-through (none by absolute reference).
 * reads key_flags
 * Body (complete):
 *   065D3C  btst    #7, @0xFFFFA9EE:16
 *   065D42  bne     loc_65D58:8
 * ------------------------------------------------------------------------- */
void msg_065D3C(void) { /* see body above */ }

/* ---------------------------------------------------------------------------
 * 065D44-065D5E (26 B)  msg_065D44  [sub_65D44]  Skeleton
 * Callers: 05F422, 05F458, 05F4EE, 05F53E, 05F5D0, 05F6CC, 05F6EC, 06754C.
 * calls sub_3FFA0
 * writes popup_tmr, wx_B266, wx_B275
 * ------------------------------------------------------------------------- */
void msg_065D44(void)
{
    /* TODO(waveC): 7-instruction body not hand-transcribed; the facts
       above are extracted from the listing (065D44..065D5E). */
}

/* ---------------------------------------------------------------------------
 * 065D5E-065DD8 (122 B)  msg_065D5E  [sub_65D5E]  Skeleton
 * Callers: table/indirect or fall-through (none by absolute reference).
 * calls sub_658A4, sub_65E2C, sub_6F076, sub_65E50, sub_6F07E, sub_3FFA0
 * writes gm_msg_B928, ram_FFB47B, ram_FFB95C, ram_FFB95D
 * reads key_flags, ram_BA32, wx_sel
 * ------------------------------------------------------------------------- */
void msg_065D5E(void)
{
    /* TODO(waveC): 40-instruction body not hand-transcribed; the facts
       above are extracted from the listing (065D5E..065DD8). */
}

/* ---------------------------------------------------------------------------
 * 065DD8-065DF6 (30 B)  msg_goto_s1C_065DD8  [sub_65DD8]  Skeleton
 * Callers: 06631E.
 * sets wx_state = 0x1C
 * writes wx_B266, wx_B275, wx_cursor, wx_sel, wx_state
 * ------------------------------------------------------------------------- */
void msg_goto_s1C_065DD8(void)
{
    /* TODO(waveC): 8-instruction body not hand-transcribed; the facts
       above are extracted from the listing (065DD8..065DF6). */
}

/* ---------------------------------------------------------------------------
 * 065DF6-065E1A (36 B)  msg_goto_s1D_065DF6  [sub_65DF6]  Skeleton
 * Callers: 06631E.
 * sets wx_state = 0x1D
 * writes disp_flags_BC59, wx_B266, wx_B275, wx_cursor, wx_sel, wx_state
 * ------------------------------------------------------------------------- */
void msg_goto_s1D_065DF6(void)
{
    /* TODO(waveC): 9-instruction body not hand-transcribed; the facts
       above are extracted from the listing (065DF6..065E1A). */
}

/* ---------------------------------------------------------------------------
 * 065E1A-065E2C (18 B)  msg_065E1A  [sub_65E1A]  Skeleton
 * Callers: 065F5C.
 * writes wx_cursor, wx_sel
 * reads msg_saved_cur, msg_saved_sel
 * ------------------------------------------------------------------------- */
void msg_065E1A(void)
{
    /* TODO(waveC): 5-instruction body not hand-transcribed; the facts
       above are extracted from the listing (065E1A..065E2C). */
}

/* ---------------------------------------------------------------------------
 * 065E2C-065E3E (18 B)  msg_goto_s22_065E2C  [sub_65E2C]  Skeleton
 * Callers: 064DB2, 065D5E.
 * sets wx_state = 0x22
 * writes wx_cursor, wx_sel, wx_state
 * ------------------------------------------------------------------------- */
void msg_goto_s22_065E2C(void)
{
    /* TODO(waveC): 6-instruction body not hand-transcribed; the facts
       above are extracted from the listing (065E2C..065E3E). */
}

/* ---------------------------------------------------------------------------
 * 065E3E-065E62 (36 B)  msg_goto_s1F_065E3E  [sub_65E3E]  Skeleton
 * Callers: 0653F8.
 * sets wx_state = 0x1F
 * writes wx_cursor, wx_sel, wx_state
 * reads msg_saved_cur, msg_saved_sel
 * ------------------------------------------------------------------------- */
void msg_goto_s1F_065E3E(void)
{
    /* TODO(waveC): 11-instruction body not hand-transcribed; the facts
       above are extracted from the listing (065E3E..065E62). */
}

/* ---------------------------------------------------------------------------
 * 065E62-065E76 (20 B)  msg_goto_s1A_065E62  [sub_65E62]  Skeleton
 * Callers: 065AF0, 065D1C.
 * sets wx_state = 0x1A
 * writes wx_B266, wx_B275, wx_state
 * ------------------------------------------------------------------------- */
void msg_goto_s1A_065E62(void)
{
    /* TODO(waveC): 5-instruction body not hand-transcribed; the facts
       above are extracted from the listing (065E62..065E76). */
}

/* ---------------------------------------------------------------------------
 * 065E76-065E9A (36 B)  msg_goto_s26_065E76  [sub_65E76]  Skeleton
 * Callers: 065410, 065F5C.
 * sets wx_state = 0x26
 * writes disp_flags_BC59, wx_B266, wx_B275, wx_cursor, wx_sel, wx_state
 * ------------------------------------------------------------------------- */
void msg_goto_s26_065E76(void)
{
    /* TODO(waveC): 9-instruction body not hand-transcribed; the facts
       above are extracted from the listing (065E76..065E9A). */
}

/* ---------------------------------------------------------------------------
 * 065E9A-065EA0 (6 B)  msg_nop_065E9A  [sub_65E9A]  Confirmed
 * Callers: table/indirect or fall-through (none by absolute reference).
 * calls sub_66146
 * Body (complete):
 *   065E9A  jsr     sub_66146:24
 *   065E9E  rts
 * ------------------------------------------------------------------------- */
void msg_nop_065E9A(void) { /* see body above */ }

/* ---------------------------------------------------------------------------
 * 065EA0-065EA6 (6 B)  msg_nop_065EA0  [sub_65EA0]  Confirmed
 * Callers: table/indirect or fall-through (none by absolute reference).
 * calls sub_66146
 * Body (complete):
 *   065EA0  jsr     sub_66146:24
 *   065EA4  rts
 * ------------------------------------------------------------------------- */
void msg_nop_065EA0(void) { /* see body above */ }

/* ---------------------------------------------------------------------------
 * 065EA6-065EC2 (28 B)  msg_065EA6  [sub_65EA6]  Skeleton
 * Callers: 02B39E.
 * writes touch_reject
 * reads wx_busy, wx_rows
 * ------------------------------------------------------------------------- */
void msg_065EA6(void)
{
    /* TODO(waveC): 9-instruction body not hand-transcribed; the facts
       above are extracted from the listing (065EA6..065EC2). */
}

/* ---------------------------------------------------------------------------
 * 065EC2-065EFA (56 B)  msg_065EC2  [sub_65EC2]  Skeleton
 * Callers: table/indirect or fall-through (none by absolute reference).
 * calls sub_62C32, sub_65A8C, sub_65CA4
 * writes ram_FFB47C
 * reads key_flags, wx_busy, wx_rows, wx_sel
 * ------------------------------------------------------------------------- */
void msg_065EC2(void)
{
    /* TODO(waveC): 15-instruction body not hand-transcribed; the facts
       above are extracted from the listing (065EC2..065EFA). */
}

/* ---------------------------------------------------------------------------
 * 065EFA-065F00 (6 B)  msg_065EFA  [sub_65EFA]  Confirmed
 * Callers: table/indirect or fall-through (none by absolute reference).
 * calls sub_65B66
 * Body (complete):
 *   065EFA  jsr     sub_65B66:24
 *   065EFE  bra     locret_65F30:8
 * ------------------------------------------------------------------------- */
void msg_065EFA(void) { /* see body above */ }

/* ---------------------------------------------------------------------------
 * 065F00-065F06 (6 B)  msg_065F00  [sub_65F00]  Confirmed
 * Callers: table/indirect or fall-through (none by absolute reference).
 * calls sub_65B86
 * Body (complete):
 *   065F00  jsr     sub_65B86:24
 *   065F04  bra     locret_65F30:8
 * ------------------------------------------------------------------------- */
void msg_065F00(void) { /* see body above */ }

/* ---------------------------------------------------------------------------
 * 065F06-065F0A (4 B)  msg_065F06  [sub_65F06]  Confirmed
 * Callers: table/indirect or fall-through (none by absolute reference).
 * calls sub_65BA6
 * Body (complete):
 *   065F06  jsr     sub_65BA6:24
 * ------------------------------------------------------------------------- */
void msg_065F06(void) { /* see body above */ }

/* ---------------------------------------------------------------------------
 * 065F0A-065F0C (2 B)  j_nullsub_62  [j_nullsub_62]  Confirmed
 * Callers: table/indirect or fall-through (none by absolute reference).
 * Body (complete):
 *   065F0A  bra     locret_65F30:8
 * ------------------------------------------------------------------------- */
void j_nullsub_62(void) { /* see body above */ }

/* ---------------------------------------------------------------------------
 * 065F0C-065F20 (20 B)  msg_065F0C  [sub_65F0C]  Skeleton
 * Callers: table/indirect or fall-through (none by absolute reference).
 * calls sub_658CE, sub_60C7E
 * reads wx_req_flags
 * ------------------------------------------------------------------------- */
void msg_065F0C(void)
{
    /* TODO(waveC): 6-instruction body not hand-transcribed; the facts
       above are extracted from the listing (065F0C..065F20). */
}

/* ---------------------------------------------------------------------------
 * 065F20-065F2C (12 B)  msg_065F20  [sub_65F20]  Confirmed
 * Callers: 065EA6, 065EC2.
 * writes popup_tmr, tone_ev
 * Body (complete):
 *   065F20  mov.b   #0, r4l
 *   065F22  mov.b   r4l, @0xFFFF9599:16
 *   065F26  mov.b   r4l, @0xFFFFAAE0:16
 *   065F2A  bra     locret_65F30:8
 * ------------------------------------------------------------------------- */
void msg_065F20(void) { /* see body above */ }

/* ---------------------------------------------------------------------------
 * 065F30-065F32 (2 B)  nullsub_62  [nullsub_62]  Confirmed
 * Callers: table/indirect or fall-through (none by absolute reference).
 * Body (complete):
 *   065F30  rts
 * ------------------------------------------------------------------------- */
void nullsub_62(void) { /* see body above */ }

/* ---------------------------------------------------------------------------
 * 065F32-065F36 (4 B)  msg_065F32  [sub_65F32]  Confirmed
 * Callers: table/indirect or fall-through (none by absolute reference).
 * Body (complete):
 *   065F32  bra     loc_648F4:16
 * ------------------------------------------------------------------------- */
void msg_065F32(void) { /* see body above */ }

/* ---------------------------------------------------------------------------
 * 065F36-065F42 (12 B)  msg_065F36  [sub_65F36]  Confirmed
 * Callers: 02B45E.
 * writes ram_FFB47C
 * reads wx_sel
 * Body (complete):
 *   065F36  mov.b   @0xFFFFB3EB:16, r4l
 *   065F3A  mov.b   r4l, @0xFFFFB47C:16
 *   065F3E  bra     sub_64DB2:16
 * ------------------------------------------------------------------------- */
void msg_065F36(void) { /* see body above */ }

/* ---------------------------------------------------------------------------
 * 065F42-065F5C (26 B)  msg_065F42  [sub_65F42]  Skeleton
 * Callers: table/indirect or fall-through (none by absolute reference).
 * reads key_flags, wx_sel
 * ------------------------------------------------------------------------- */
void msg_065F42(void)
{
    /* TODO(waveC): 10-instruction body not hand-transcribed; the facts
       above are extracted from the listing (065F42..065F5C). */
}

/* ---------------------------------------------------------------------------
 * 065F5C-065FA6 (74 B)  msg_065F5C  [sub_65F5C]  Skeleton
 * Callers: 065F42.
 * calls sub_65E1A, sub_64BD0, sub_5EE1A, sub_65442, sub_6A628,
 *     sub_65E76, sub_3FFA0
 * writes ram_FF2EC9, ram_FFB3FD, wx_B275
 * reads home_app_mode
 * ------------------------------------------------------------------------- */
void msg_065F5C(void)
{
    /* TODO(waveC): 24-instruction body not hand-transcribed; the facts
       above are extracted from the listing (065F5C..065FA6). */
}

/* ---------------------------------------------------------------------------
 * 065FA6-065FB0 (10 B)  msg_065FA6  [sub_65FA6]  Confirmed
 * Callers: table/indirect or fall-through (none by absolute reference).
 * reads key_flags
 * Body (complete):
 *   065FA6  btst    #7, @0xFFFFA9EE:16
 *   065FAC  bne     loc_660C8:16
 * ------------------------------------------------------------------------- */
void msg_065FA6(void) { /* see body above */ }

/* ---------------------------------------------------------------------------
 * 065FB0-066028 (120 B)  msg_065FB0  [sub_65FB0]  Skeleton
 * Callers: 02B4B6.
 * reads edit_cursor, gm_B963, wx_sel
 * ------------------------------------------------------------------------- */
void msg_065FB0(void)
{
    /* TODO(waveC): 36-instruction body not hand-transcribed; the facts
       above are extracted from the listing (065FB0..066028). */
}

/* ---------------------------------------------------------------------------
 * 066028-06609E (118 B)  msg_066028  [sub_66028]  Skeleton
 * Callers: 065FB0.
 * calls sub_3DC7A
 * writes edit_cursor
 * reads gm_B963, wx_sel
 * ------------------------------------------------------------------------- */
void msg_066028(void)
{
    /* TODO(waveC): 45-instruction body not hand-transcribed; the facts
       above are extracted from the listing (066028..06609E). */
}

/* ---------------------------------------------------------------------------
 * 06609E-0660B4 (22 B)  msg_06609E  [sub_6609E]  Skeleton
 * Callers: 065FB0.
 * reads edit_cursor
 * ------------------------------------------------------------------------- */
void msg_06609E(void)
{
    /* TODO(waveC): 6-instruction body not hand-transcribed; the facts
       above are extracted from the listing (06609E..0660B4). */
}

/* ---------------------------------------------------------------------------
 * 0660B4-0660CE (26 B)  msg_0660B4  [sub_660B4]  Skeleton
 * Callers: 066028, 0660D6.
 * calls sub_64B6A, sub_64B8C, sub_3FFA0
 * reads msg_ret_B40F
 * ------------------------------------------------------------------------- */
void msg_0660B4(void)
{
    /* TODO(waveC): 9-instruction body not hand-transcribed; the facts
       above are extracted from the listing (0660B4..0660CE). */
}

/* ---------------------------------------------------------------------------
 * 0660CE-0660D6 (8 B)  msg_0660CE  [sub_660CE]  Confirmed
 * Callers: table/indirect or fall-through (none by absolute reference).
 * reads key_flags
 * Body (complete):
 *   0660CE  btst    #7, @0xFFFFA9EE:16
 *   0660D4  bne     loc_66140:8
 * ------------------------------------------------------------------------- */
void msg_0660CE(void) { /* see body above */ }

/* ---------------------------------------------------------------------------
 * 0660D6-066146 (112 B)  msg_0660D6  [sub_660D6]  Skeleton
 * Callers: 02B4C8.
 * calls sub_3DC8A, sub_660B4, sub_6519E, sub_652D0, sub_3FFA0
 * writes wx_state
 * reads gm_B963, msg_ret_B40F, wx_sel
 * ------------------------------------------------------------------------- */
void msg_0660D6(void)
{
    /* TODO(waveC): 37-instruction body not hand-transcribed; the facts
       above are extracted from the listing (0660D6..066146). */
}

/* ---------------------------------------------------------------------------
 * 066146-06616E (40 B)  msg_066146  [sub_66146]  Skeleton
 * Callers: 065E9A, 065EA0.
 * calls sub_3FFA0
 * writes popup_tmr, wx_B266, wx_B275, wx_flags26D
 * reads key_flags
 * ------------------------------------------------------------------------- */
void msg_066146(void)
{
    /* TODO(waveC): 10-instruction body not hand-transcribed; the facts
       above are extracted from the listing (066146..06616E). */
}

/* ---------------------------------------------------------------------------
 * 06616E-06618E (32 B)  msg_06616E  [sub_6616E]  Skeleton
 * Callers: table/indirect or fall-through (none by absolute reference).
 * calls sub_3FFA0
 * writes popup_tmr, tone_ev, wx_B266
 * reads key_flags
 * ------------------------------------------------------------------------- */
void msg_06616E(void)
{
    /* TODO(waveC): 9-instruction body not hand-transcribed; the facts
       above are extracted from the listing (06616E..06618E). */
}

/* ---------------------------------------------------------------------------
 * 06618E-0661C8 (58 B)  msg_06618E  [sub_6618E]  Skeleton
 * Callers: table/indirect or fall-through (none by absolute reference).
 * dispatches through off_661C8
 * calls sub_2244C
 * writes wx_B132
 * reads band_8EA0, gm_B420, wx_state
 * ------------------------------------------------------------------------- */
void msg_06618E(void)
{
    /* TODO(waveC): 15-instruction body not hand-transcribed; the facts
       above are extracted from the listing (06618E..0661C8). */
}

/* ---------------------------------------------------------------------------
 * 0662DC-0662E8 (12 B)  wx_0662DC  [sub_662DC]  Confirmed
 * Callers: table/indirect or fall-through (none by absolute reference).
 * calls sub_6631E
 * reads wx_busy
 * Body (complete):
 *   0662DC  btst    #0, @0xFFFFB26C:16
 *   0662E2  bne     locret_662E6:8
 *   0662E4  bsr     sub_6631E:8
 *   0662E6  rts
 * ------------------------------------------------------------------------- */
void wx_0662DC(void) { /* see body above */ }

/* ---------------------------------------------------------------------------
 * 0662E8-066302 (26 B)  wx_0662E8  [sub_662E8]  Skeleton
 * Callers: table/indirect or fall-through (none by absolute reference).
 * calls sub_6631E, sub_615AA
 * reads wx_busy, wx_sel
 * ------------------------------------------------------------------------- */
void wx_0662E8(void)
{
    /* TODO(waveC): 9-instruction body not hand-transcribed; the facts
       above are extracted from the listing (0662E8..066302). */
}

/* ---------------------------------------------------------------------------
 * 066302-06630E (12 B)  wx_066302  [sub_66302]  Confirmed
 * Callers: table/indirect or fall-through (none by absolute reference).
 * calls sub_6631E
 * reads wx_busy
 * Body (complete):
 *   066302  btst    #1, @0xFFFFB26C:16
 *   066308  bne     locret_6630C:8
 *   06630A  bsr     sub_6631E:8
 *   06630C  rts
 * ------------------------------------------------------------------------- */
void wx_066302(void) { /* see body above */ }

/* ---------------------------------------------------------------------------
 * 06630E-06631E (16 B)  wx_06630E  [sub_6630E]  Skeleton
 * Callers: table/indirect or fall-through (none by absolute reference).
 * calls sub_6631E, sub_6161C
 * reads wx_sel
 * ------------------------------------------------------------------------- */
void wx_06630E(void)
{
    /* TODO(waveC): 6-instruction body not hand-transcribed; the facts
       above are extracted from the listing (06630E..06631E). */
}

/* ---------------------------------------------------------------------------
 * 06631E-066398 (122 B)  wx_06631E  [sub_6631E]  Skeleton
 * Callers: 061624, 0662DC, 0662E8, 066302, 06630E.
 * calls sub_2244C, sub_65DF6, sub_65DD8, sub_66398
 * writes aad4_flags, ram_FFB47B, wx_B132, wx_B266
 * reads wx_sel, wx_state
 * ------------------------------------------------------------------------- */
void wx_06631E(void)
{
    /* TODO(waveC): 36-instruction body not hand-transcribed; the facts
       above are extracted from the listing (06631E..066398). */
}

/* ---------------------------------------------------------------------------
 * 066398-0663CA (50 B)  wx_066398  [sub_66398]  Skeleton
 * Callers: 06631E.
 * ------------------------------------------------------------------------- */
void wx_066398(void)
{
    /* TODO(waveC): 18-instruction body not hand-transcribed; the facts
       above are extracted from the listing (066398..0663CA). */
}

/* ---------------------------------------------------------------------------
 * 0663CA-066428 (94 B)  wx_0663CA  [sub_663CA]  Skeleton
 * Callers: 02B092.
 * calls sub_62112, sub_66428, sub_62F64, sub_3FFA0
 * reads key_flags, wx_link, wx_popup, wx_state
 * ------------------------------------------------------------------------- */
void wx_0663CA(void)
{
    /* TODO(waveC): 30-instruction body not hand-transcribed; the facts
       above are extracted from the listing (0663CA..066428). */
}

/* ---------------------------------------------------------------------------
 * 066428-0664B6 (142 B)  wx_066428  [sub_66428]  Skeleton
 * Callers: 05FDAE, 0663CA.
 * calls sub_66500, sub_6652A, sub_19F54, sub_19F62, sub_3FFA0
 * reads wx_busy, wx_link, wx_state
 * ------------------------------------------------------------------------- */
void wx_066428(void)
{
    /* TODO(waveC): 47-instruction body not hand-transcribed; the facts
       above are extracted from the listing (066428..0664B6). */
}

/* ---------------------------------------------------------------------------
 * 0664C2-066500 (62 B)  wx_0664C2  [sub_664C2]  Skeleton
 * Callers: table/indirect or fall-through (none by absolute reference).
 * calls sub_67FB6
 * reads gm_B420, wx_state
 * ------------------------------------------------------------------------- */
void wx_0664C2(void)
{
    /* TODO(waveC): 20-instruction body not hand-transcribed; the facts
       above are extracted from the listing (0664C2..066500). */
}

/* ---------------------------------------------------------------------------
 * 066500-06652A (42 B)  wx_066500  [sub_66500]  Skeleton
 * Callers: 066428.
 * calls sub_19F54
 * ------------------------------------------------------------------------- */
void wx_066500(void)
{
    /* TODO(waveC): 13-instruction body not hand-transcribed; the facts
       above are extracted from the listing (066500..06652A). */
}

/* ---------------------------------------------------------------------------
 * 06652A-0665BA (144 B)  wx_06652A  [sub_6652A]  Skeleton
 * Callers: 066428, 0664C2.
 * calls sub_19F54, sub_3FFA0
 * reads gm_group, ram_FFB3ED
 * ------------------------------------------------------------------------- */
void wx_06652A(void)
{
    /* TODO(waveC): 49-instruction body not hand-transcribed; the facts
       above are extracted from the listing (06652A..0665BA). */
}

/* ---------------------------------------------------------------------------
 * 0665D2-066666 (148 B)  wx_0665D2  [sub_665D2]  Skeleton
 * Callers: table/indirect or fall-through (none by absolute reference).
 * calls loc_62112, sub_66688, sub_666A2, sub_1A924, sub_3FFA0
 * writes wx_id_cursor
 * reads edit_cursor, ram_FFA9F0, wx_busy, wx_link, wx_popup, wx_state
 * ------------------------------------------------------------------------- */
void wx_0665D2(void)
{
    /* TODO(waveC): 45-instruction body not hand-transcribed; the facts
       above are extracted from the listing (0665D2..066666). */
}

/* ---------------------------------------------------------------------------
 * 066666-066688 (34 B)  wx_066666  [sub_66666]  Skeleton
 * Callers: table/indirect or fall-through (none by absolute reference).
 * reads gm_B420, wx_state
 * ------------------------------------------------------------------------- */
void wx_066666(void)
{
    /* TODO(waveC): 13-instruction body not hand-transcribed; the facts
       above are extracted from the listing (066666..066688). */
}

/* ---------------------------------------------------------------------------
 * 066688-0666A2 (26 B)  wx_066688  [sub_66688]  Skeleton
 * Callers: 0665D2.
 * calls sub_1A8CE
 * reads edit_cursor
 * ------------------------------------------------------------------------- */
void wx_066688(void)
{
    /* TODO(waveC): 7-instruction body not hand-transcribed; the facts
       above are extracted from the listing (066688..0666A2). */
}

/* ---------------------------------------------------------------------------
 * 0666A2-06670C (106 B)  wx_0666A2  [sub_666A2]  Skeleton
 * Callers: 0665D2, 066666.
 * calls sub_1A8CE, sub_1A924, sub_3FFA0
 * reads edit_cursor, gm_group, ram_FFB3ED
 * ------------------------------------------------------------------------- */
void wx_0666A2(void)
{
    /* TODO(waveC): 30-instruction body not hand-transcribed; the facts
       above are extracted from the listing (0666A2..06670C). */
}

/* ---------------------------------------------------------------------------
 * 06670C-0667A0 (148 B)  wx_06670C  [sub_6670C]  Skeleton
 * Callers: table/indirect or fall-through (none by absolute reference).
 * calls sub_62112, sub_667D0, sub_667EA, sub_1A04A, sub_1F26A,
 *     sub_1A062, sub_3FFA0
 * reads edit_cursor, flags_8DE0, node_mode, wx_id_cursor, wx_link,
 *     wx_popup, wx_state
 * ------------------------------------------------------------------------- */
void wx_06670C(void)
{
    /* TODO(waveC): 45-instruction body not hand-transcribed; the facts
       above are extracted from the listing (06670C..0667A0). */
}

/* ---------------------------------------------------------------------------
 * 0667A0-0667D0 (48 B)  wx_0667A0  [sub_667A0]  Skeleton
 * Callers: table/indirect or fall-through (none by absolute reference).
 * calls sub_1F26A
 * reads gm_B420, wx_state
 * ------------------------------------------------------------------------- */
void wx_0667A0(void)
{
    /* TODO(waveC): 17-instruction body not hand-transcribed; the facts
       above are extracted from the listing (0667A0..0667D0). */
}

/* ---------------------------------------------------------------------------
 * 0667D0-0667EA (26 B)  wx_0667D0  [sub_667D0]  Skeleton
 * Callers: 06670C, 0667A0.
 * calls sub_1A04A
 * reads edit_cursor
 * ------------------------------------------------------------------------- */
void wx_0667D0(void)
{
    /* TODO(waveC): 7-instruction body not hand-transcribed; the facts
       above are extracted from the listing (0667D0..0667EA). */
}

/* ---------------------------------------------------------------------------
 * 0667EA-06685C (114 B)  wx_0667EA  [sub_667EA]  Skeleton
 * Callers: 06670C, 0667A0.
 * calls sub_1A04A, sub_1F26A, sub_3FFA0
 * reads edit_cursor, gm_group, ram_FFB3ED
 * ------------------------------------------------------------------------- */
void wx_0667EA(void)
{
    /* TODO(waveC): 33-instruction body not hand-transcribed; the facts
       above are extracted from the listing (0667EA..06685C). */
}

/* ---------------------------------------------------------------------------
 * 06685C-0668E2 (134 B)  wx_06685C  [sub_6685C]  Skeleton
 * Callers: table/indirect or fall-through (none by absolute reference).
 * calls sub_1F2B6, sub_64660, sub_1FA26, sub_1FA22, sub_1F386, sub_1F340
 * writes gm_B420
 * reads ram_BA32, ram_FFA9F0, wx_state
 * ------------------------------------------------------------------------- */
void wx_06685C(void)
{
    /* TODO(waveC): 44-instruction body not hand-transcribed; the facts
       above are extracted from the listing (06685C..0668E2). */
}

/* ---------------------------------------------------------------------------
 * 0668E2-066924 (66 B)  wx_0668E2  [sub_668E2]  Skeleton
 * Callers: 02B09E.
 * calls sub_1FA26, sub_1FA22
 * writes wx_busy, wx_flags26D, wx_id_cursor, wx_id_entry_m1, wx_link
 * ------------------------------------------------------------------------- */
void wx_0668E2(void)
{
    /* TODO(waveC): 18-instruction body not hand-transcribed; the facts
       above are extracted from the listing (0668E2..066924). */
}

/* ---------------------------------------------------------------------------
 * 066966-0669D4 (110 B)  wx_content_066966  [sub_66966]  Skeleton
 * Callers: table/indirect or fall-through (none by absolute reference).
 * dispatches through off_669E0
 * writes edit_cursor, ram_FFA917, ram_FFA918, ram_FFA919, ram_FFA91A,
 *     ram_FFB08D, wx_AD9A, wx_sel
 * reads gm_B420, ram_FF8AAC, ram_FF8ABE, wx_state
 * ------------------------------------------------------------------------- */
void wx_content_066966(void)
{
    /* TODO(waveC): 31-instruction body not hand-transcribed; the facts
       above are extracted from the listing (066966..0669D4). */
}

/* ---------------------------------------------------------------------------
 * 0669D4-0669E0 (12 B)  wx_content_0669D4  [sub_669D4]  Confirmed
 * Callers: table/indirect or fall-through (none by absolute reference).
 * calls sub_6A32
 * Body (complete):
 *   0669D4  jsr     sub_6A32:24
 *   0669D8  bra     locret_669DE:8
 *   0669DA  .byte 0x5E ; ^
 *   0669DE  rts
 * ------------------------------------------------------------------------- */
void wx_content_0669D4(void) { /* see body above */ }

/* ---------------------------------------------------------------------------
 * 066AF4-066AF6 (2 B)  nullsub_94  [nullsub_94]  Confirmed
 * Callers: table/indirect or fall-through (none by absolute reference).
 * Body (complete):
 *   066AF4  rts
 * ------------------------------------------------------------------------- */
void nullsub_94(void) { /* see body above */ }

/* ---------------------------------------------------------------------------
 * 066B06-066B2C (38 B)  wx_content_066B06  [sub_66B06]  Skeleton
 * Callers: table/indirect or fall-through (none by absolute reference).
 * calls sub_6DC2E, loc_61D8B+1
 * writes wx_busy
 * ------------------------------------------------------------------------- */
void wx_content_066B06(void)
{
    /* TODO(waveC): 10-instruction body not hand-transcribed; the facts
       above are extracted from the listing (066B06..066B2C). */
}

/* ---------------------------------------------------------------------------
 * 066B36-066B4A (20 B)  wx_content_066B36  [sub_66B36]  Skeleton
 * Callers: table/indirect or fall-through (none by absolute reference).
 * calls sub_ABC8
 * reads wx_cursor
 * ------------------------------------------------------------------------- */
void wx_content_066B36(void)
{
    /* TODO(waveC): 6-instruction body not hand-transcribed; the facts
       above are extracted from the listing (066B36..066B4A). */
}

/* ---------------------------------------------------------------------------
 * 066B4A-066B50 (6 B)  wx_content_nop_066B4A  [sub_66B4A]  Confirmed
 * Callers: table/indirect or fall-through (none by absolute reference).
 * calls sub_6E18A
 * Body (complete):
 *   066B4A  jsr     sub_6E18A:24
 *   066B4E  rts
 * ------------------------------------------------------------------------- */
void wx_content_nop_066B4A(void) { /* see body above */ }

/* ---------------------------------------------------------------------------
 * 066B60-066B66 (6 B)  wx_content_066B60  [sub_66B60]  Confirmed
 * Callers: 06E292.
 * Body (complete):
 *   066B60  mov.b   #0x14, r2h
 *   066B62  mov.b   #0, r2l
 *   066B64  bra     loc_66B7E:8
 * ------------------------------------------------------------------------- */
void wx_content_066B60(void) { /* see body above */ }

/* ---------------------------------------------------------------------------
 * 066B66-066B6C (6 B)  wx_content_066B66  [sub_66B66]  Confirmed
 * Callers: 06E292.
 * Body (complete):
 *   066B66  mov.b   #0x28, r2h ; '('
 *   066B68  mov.b   #0x14, r2l
 *   066B6A  bra     loc_66B7E:8
 * ------------------------------------------------------------------------- */
void wx_content_066B66(void) { /* see body above */ }

/* ---------------------------------------------------------------------------
 * 066B6C-066B72 (6 B)  wx_content_066B6C  [sub_66B6C]  Confirmed
 * Callers: 06E292.
 * Body (complete):
 *   066B6C  mov.b   #0x3C, r2h ; '<'
 *   066B6E  mov.b   #0x28, r2l ; '('
 *   066B70  bra     loc_66B7E:8
 * ------------------------------------------------------------------------- */
void wx_content_066B6C(void) { /* see body above */ }

/* ---------------------------------------------------------------------------
 * 066B72-066BE8 (118 B)  wx_content_066B72  [sub_66B72]  Skeleton
 * Callers: 06E292.
 * calls sub_5E468
 * writes draw_attr_B050
 * reads edit_cursor, wx_state
 * ------------------------------------------------------------------------- */
void wx_content_066B72(void)
{
    /* TODO(waveC): 37-instruction body not hand-transcribed; the facts
       above are extracted from the listing (066B72..066BE8). */
}

/* ---------------------------------------------------------------------------
 * 066C20-066C22 (2 B)  nullsub_95  [nullsub_95]  Confirmed
 * Callers: table/indirect or fall-through (none by absolute reference).
 * Body (complete):
 *   066C20  rts
 * ------------------------------------------------------------------------- */
void nullsub_95(void) { /* see body above */ }

/* ---------------------------------------------------------------------------
 * 066C22-066C56 (52 B)  wx_content_066C22  [sub_66C22]  Skeleton
 * Callers: table/indirect or fall-through (none by absolute reference).
 * calls sub_6E326, sub_6E2EA, sub_6E31E
 * writes ram_FFBC04
 * reads home_app_mode, wx_state
 * ------------------------------------------------------------------------- */
void wx_content_066C22(void)
{
    /* TODO(waveC): 19-instruction body not hand-transcribed; the facts
       above are extracted from the listing (066C22..066C56). */
}

/* ---------------------------------------------------------------------------
 * 066C56-066C8E (56 B)  wx_content_066C56  [sub_66C56]  Skeleton
 * Callers: 0679E4, 06ECEA.
 * calls sub_66DD6, sub_52A3A, loc_61D8B+1, sub_646A2
 * writes wx_busy
 * reads row_cb_B288
 * ------------------------------------------------------------------------- */
void wx_content_066C56(void)
{
    /* TODO(waveC): 14-instruction body not hand-transcribed; the facts
       above are extracted from the listing (066C56..066C8E). */
}

/* ---------------------------------------------------------------------------
 * 066C8E-066CAC (30 B)  wx_content_066C8E  [sub_66C8E]  Skeleton
 * Callers: 066C56.
 * dispatches through off_66CAC
 * calls loc_61D6D+1
 * ------------------------------------------------------------------------- */
void wx_content_066C8E(void)
{
    /* TODO(waveC): 7-instruction body not hand-transcribed; the facts
       above are extracted from the listing (066C8E..066CAC). */
}

/* ---------------------------------------------------------------------------
 * 066CD0-066CD2 (2 B)  wx_content_nop_066CD0  [sub_66CD0]  Confirmed
 * Callers: table/indirect or fall-through (none by absolute reference).
 * Body (complete):
 *   066CD0  rts
 * ------------------------------------------------------------------------- */
void wx_content_nop_066CD0(void) { /* see body above */ }

/* ---------------------------------------------------------------------------
 * 066CD2-066CFE (44 B)  wx_content_066CD2  [sub_66CD2]  Skeleton
 * Callers: table/indirect or fall-through (none by absolute reference).
 * writes draw_attr_B050, line_buf_B05A, ram_FFA9F7
 * reads ram_FFB328
 * ------------------------------------------------------------------------- */
void wx_content_066CD2(void)
{
    /* TODO(waveC): 14-instruction body not hand-transcribed; the facts
       above are extracted from the listing (066CD2..066CFE). */
}

/* ---------------------------------------------------------------------------
 * 066CFE-066D10 (18 B)  wx_content_066CFE  [sub_66CFE]  Skeleton
 * Callers: table/indirect or fall-through (none by absolute reference).
 * writes draw_attr_B050, line_buf_B05A
 * ------------------------------------------------------------------------- */
void wx_content_066CFE(void)
{
    /* TODO(waveC): 6-instruction body not hand-transcribed; the facts
       above are extracted from the listing (066CFE..066D10). */
}

/* ---------------------------------------------------------------------------
 * 066D10-066D22 (18 B)  wx_content_066D10  [sub_66D10]  Skeleton
 * Callers: table/indirect or fall-through (none by absolute reference).
 * writes draw_attr_B050, line_buf_B05A
 * ------------------------------------------------------------------------- */
void wx_content_066D10(void)
{
    /* TODO(waveC): 6-instruction body not hand-transcribed; the facts
       above are extracted from the listing (066D10..066D22). */
}

/* ---------------------------------------------------------------------------
 * 066D22-066D34 (18 B)  wx_content_066D22  [sub_66D22]  Skeleton
 * Callers: table/indirect or fall-through (none by absolute reference).
 * writes draw_attr_B050, line_buf_B05A
 * ------------------------------------------------------------------------- */
void wx_content_066D22(void)
{
    /* TODO(waveC): 6-instruction body not hand-transcribed; the facts
       above are extracted from the listing (066D22..066D34). */
}

/* ---------------------------------------------------------------------------
 * 066D34-066D46 (18 B)  wx_content_066D34  [sub_66D34]  Skeleton
 * Callers: table/indirect or fall-through (none by absolute reference).
 * writes draw_attr_B050, line_buf_B05A
 * ------------------------------------------------------------------------- */
void wx_content_066D34(void)
{
    /* TODO(waveC): 6-instruction body not hand-transcribed; the facts
       above are extracted from the listing (066D34..066D46). */
}

/* ---------------------------------------------------------------------------
 * 066D58-066D6A (18 B)  wx_content_066D58  [sub_66D58]  Skeleton
 * Callers: table/indirect or fall-through (none by absolute reference).
 * writes draw_attr_B050, line_buf_B05A
 * ------------------------------------------------------------------------- */
void wx_content_066D58(void)
{
    /* TODO(waveC): 6-instruction body not hand-transcribed; the facts
       above are extracted from the listing (066D58..066D6A). */
}

/* ---------------------------------------------------------------------------
 * 066DD6-066ED0 (250 B)  wx_content_066DD6  [sub_66DD6]  Skeleton
 * Callers: 066C56, 067370, 067394, 06752A, 0675F4, 06764C, 0679A4.
 * calls sub_702C, sub_6B7E
 * reads draw_attr_B050, ram_FFB26F, wx_menu_origin, wx_open_rec,
 *     wx_req_flags
 * ------------------------------------------------------------------------- */
void wx_content_066DD6(void)
{
    /* TODO(waveC): 69-instruction body not hand-transcribed; the facts
       above are extracted from the listing (066DD6..066ED0). */
}

/* ---------------------------------------------------------------------------
 * 066ED0-066ED6 (6 B)  wx_content_nop_066ED0  [sub_66ED0]  Confirmed
 * Callers: table/indirect or fall-through (none by absolute reference).
 * calls sub_6E062
 * Body (complete):
 *   066ED0  jsr     sub_6E062:24
 *   066ED4  rts
 * ------------------------------------------------------------------------- */
void wx_content_nop_066ED0(void) { /* see body above */ }

/* ---------------------------------------------------------------------------
 * 066F26-066F6E (72 B)  wx_content_066F26  [sub_66F26]  Skeleton
 * Callers: 067054, 06E0D8.
 * calls sub_6277E, sub_627CC
 * reads ram_FFB26F, wx_menu_origin, wx_open_rec
 * ------------------------------------------------------------------------- */
void wx_content_066F26(void)
{
    /* TODO(waveC): 19-instruction body not hand-transcribed; the facts
       above are extracted from the listing (066F26..066F6E). */
}

/* ---------------------------------------------------------------------------
 * 066F6E-066F8C (30 B)  wx_content_066F6E  [sub_66F6E]  Skeleton
 * Callers: table/indirect or fall-through (none by absolute reference).
 * writes draw_attr_B050, line_buf_B05A
 * reads ram_FFB326
 * ------------------------------------------------------------------------- */
void wx_content_066F6E(void)
{
    /* TODO(waveC): 11-instruction body not hand-transcribed; the facts
       above are extracted from the listing (066F6E..066F8C). */
}

/* ---------------------------------------------------------------------------
 * 066F8C-066FAA (30 B)  wx_content_066F8C  [sub_66F8C]  Skeleton
 * Callers: table/indirect or fall-through (none by absolute reference).
 * writes draw_attr_B050, line_buf_B05A
 * reads wx_B324
 * ------------------------------------------------------------------------- */
void wx_content_066F8C(void)
{
    /* TODO(waveC): 11-instruction body not hand-transcribed; the facts
       above are extracted from the listing (066F8C..066FAA). */
}

/* ---------------------------------------------------------------------------
 * 066FAA-066FB4 (10 B)  wx_content_066FAA  [sub_66FAA]  Confirmed
 * Callers: 0627CC, 0628DA, 067194, 06AA82, 06AD7E.
 * writes draw_attr_B050
 * Body (complete):
 *   066FAA  mov.w   #8, r4
 *   066FAE  mov.w   r4, @0xFFFFB050:16
 *   066FB2  rts
 * ------------------------------------------------------------------------- */
void wx_content_066FAA(void) { /* see body above */ }

/* ---------------------------------------------------------------------------
 * 066FB4-066FBE (10 B)  wx_content_066FB4  [sub_66FB4]  Confirmed
 * Callers: 0627CC, 067194, 06AA82, 06AD7E.
 * writes draw_attr_B050
 * Body (complete):
 *   066FB4  mov.w   #8, r4
 *   066FB8  mov.w   r4, @0xFFFFB050:16
 *   066FBC  rts
 * ------------------------------------------------------------------------- */
void wx_content_066FB4(void) { /* see body above */ }

/* ---------------------------------------------------------------------------
 * 066FBE-066FC8 (10 B)  wx_content_066FBE  [sub_66FBE]  Confirmed
 * Callers: 06AA82, 06AD7E.
 * writes draw_attr_B050
 * Body (complete):
 *   066FBE  mov.w   #5, r4
 *   066FC2  mov.w   r4, @0xFFFFB050:16
 *   066FC6  rts
 * ------------------------------------------------------------------------- */
void wx_content_066FBE(void) { /* see body above */ }

/* ---------------------------------------------------------------------------
 * 06703A-06704E (20 B)  wx_content_06703A  [sub_6703A]  Skeleton
 * Callers: table/indirect or fall-through (none by absolute reference).
 * calls sub_6E0D8
 * reads wx_req_flags
 * ------------------------------------------------------------------------- */
void wx_content_06703A(void)
{
    /* TODO(waveC): 7-instruction body not hand-transcribed; the facts
       above are extracted from the listing (06703A..06704E). */
}

/* ---------------------------------------------------------------------------
 * 06704E-067054 (6 B)  wx_content_06704E  [sub_6704E]  Confirmed
 * Callers: 067394, 067524, 067A0E.
 * reads wx_busy
 * Body (complete):
 *   06704E  btst    #1, @0xFFFFB26C:16
 * ------------------------------------------------------------------------- */
void wx_content_06704E(void) { /* see body above */ }

/* ---------------------------------------------------------------------------
 * 067054-067128 (212 B)  wx_content_067054  [sub_67054]  Skeleton
 * Callers: table/indirect or fall-through (none by absolute reference).
 * calls sub_66F26, sub_5363A, sub_9B5A, sub_B40A, loc_61D8B+1,
 *     sub_61E4A, sub_67A0E
 * writes line_len_BBE8, wx_B275, wx_busy
 * reads list_dst_BC2C, ram_FFB47B, row_cb_B288, wx_rows
 * ------------------------------------------------------------------------- */
void wx_content_067054(void)
{
    /* TODO(waveC): 57-instruction body not hand-transcribed; the facts
       above are extracted from the listing (067054..067128). */
}

/* ---------------------------------------------------------------------------
 * 06712A-067194 (106 B)  wx_content_06712A  [sub_6712A]  Skeleton
 * Callers: 067054.
 * calls loc_61D7B+1
 * writes line_buf_B05A
 * reads ram_FFB47B, wx_req_flags, wx_rows
 * ------------------------------------------------------------------------- */
void wx_content_06712A(void)
{
    /* TODO(waveC): 32-instruction body not hand-transcribed; the facts
       above are extracted from the listing (06712A..067194). */
}

/* ---------------------------------------------------------------------------
 * 067194-067250 (188 B)  wx_content_067194  [sub_67194]  Skeleton
 * Callers: 06712A.
 * calls sub_67284, sub_672B2, sub_66FB4, sub_67250, sub_6726A, sub_66FAA
 * writes draw_attr_B050, line_buf_B05A
 * reads wx_req_flags
 * ------------------------------------------------------------------------- */
void wx_content_067194(void)
{
    /* TODO(waveC): 56-instruction body not hand-transcribed; the facts
       above are extracted from the listing (067194..067250). */
}

/* ---------------------------------------------------------------------------
 * 067250-06726A (26 B)  wx_content_067250  [sub_67250]  Skeleton
 * Callers: 0627CC, 067194, 06AA82, 06AD7E.
 * writes line_buf_B05A
 * ------------------------------------------------------------------------- */
void wx_content_067250(void)
{
    /* TODO(waveC): 11-instruction body not hand-transcribed; the facts
       above are extracted from the listing (067250..06726A). */
}

/* ---------------------------------------------------------------------------
 * 06726A-067284 (26 B)  wx_content_06726A  [sub_6726A]  Skeleton
 * Callers: 0627CC, 067194, 06AA82, 06AD7E.
 * writes line_buf_B05A
 * ------------------------------------------------------------------------- */
void wx_content_06726A(void)
{
    /* TODO(waveC): 11-instruction body not hand-transcribed; the facts
       above are extracted from the listing (06726A..067284). */
}

/* ---------------------------------------------------------------------------
 * 067284-06729C (24 B)  wx_content_067284  [sub_67284]  Skeleton
 * Callers: 067194.
 * reads wx_req_flags
 * ------------------------------------------------------------------------- */
void wx_content_067284(void)
{
    /* TODO(waveC): 6-instruction body not hand-transcribed; the facts
       above are extracted from the listing (067284..06729C). */
}

/* ---------------------------------------------------------------------------
 * 06729C-0672B2 (22 B)  wx_content_06729C  [sub_6729C]  Skeleton
 * Callers: 067284.
 * calls sub_5E468
 * ------------------------------------------------------------------------- */
void wx_content_06729C(void)
{
    /* TODO(waveC): 6-instruction body not hand-transcribed; the facts
       above are extracted from the listing (06729C..0672B2). */
}

/* ---------------------------------------------------------------------------
 * 0672B2-06732E (124 B)  wx_content_0672B2  [sub_672B2]  Skeleton
 * Callers: 067194.
 * calls sub_67502, sub_674C4
 * ------------------------------------------------------------------------- */
void wx_content_0672B2(void)
{
    /* TODO(waveC): 48-instruction body not hand-transcribed; the facts
       above are extracted from the listing (0672B2..06732E). */
}

/* ---------------------------------------------------------------------------
 * 067370-067394 (36 B)  wx_content_067370  [sub_67370]  Skeleton
 * Callers: table/indirect or fall-through (none by absolute reference).
 * calls sub_66DD6
 * reads ram_FFB111, tmr_959C, wx_B266
 * ------------------------------------------------------------------------- */
void wx_content_067370(void)
{
    /* TODO(waveC): 9-instruction body not hand-transcribed; the facts
       above are extracted from the listing (067370..067394). */
}

/* ---------------------------------------------------------------------------
 * 067394-0673C4 (48 B)  wx_content_067394  [sub_67394]  Skeleton
 * Callers: 067370, 067A52.
 * calls sub_6704E, sub_67A18, loc_61D8B+1, sub_6754C
 * writes disp_flags_BC59, popup_id
 * ------------------------------------------------------------------------- */
void wx_content_067394(void)
{
    /* TODO(waveC): 14-instruction body not hand-transcribed; the facts
       above are extracted from the listing (067394..0673C4). */
}

/* ---------------------------------------------------------------------------
 * 0673C6-0673CC (6 B)  wx_content_nop_0673C6  [sub_673C6]  Confirmed
 * Callers: 065C50.
 * calls sub_6E4B0
 * Body (complete):
 *   0673C6  jsr     sub_6E4B0:24
 *   0673CA  rts
 * ------------------------------------------------------------------------- */
void wx_content_nop_0673C6(void) { /* see body above */ }

/* ---------------------------------------------------------------------------
 * 0673CC-067432 (102 B)  wx_content_0673CC  [sub_673CC]  Skeleton
 * Callers: 06E4B0.
 * calls sub_66DFA, sub_66E30
 * reads ram_FF071A, ram_FFB26F
 * ------------------------------------------------------------------------- */
void wx_content_0673CC(void)
{
    /* TODO(waveC): 28-instruction body not hand-transcribed; the facts
       above are extracted from the listing (0673CC..067432). */
}

/* ---------------------------------------------------------------------------
 * 067472-06748C (26 B)  wx_content_067472  [sub_67472]  Skeleton
 * Callers: 06E540.
 * ------------------------------------------------------------------------- */
void wx_content_067472(void)
{
    /* TODO(waveC): 8-instruction body not hand-transcribed; the facts
       above are extracted from the listing (067472..06748C). */
}

/* ---------------------------------------------------------------------------
 * 06748C-0674C4 (56 B)  wx_content_06748C  [sub_6748C]  Skeleton
 * Callers: table/indirect or fall-through (none by absolute reference).
 * writes draw_attr_B050
 * reads ram_FF071A
 * ------------------------------------------------------------------------- */
void wx_content_06748C(void)
{
    /* TODO(waveC): 19-instruction body not hand-transcribed; the facts
       above are extracted from the listing (06748C..0674C4). */
}

/* ---------------------------------------------------------------------------
 * 0674C4-0674E4 (32 B)  wx_content_0674C4  [sub_674C4]  Skeleton
 * Callers: 0672B2.
 * ------------------------------------------------------------------------- */
void wx_content_0674C4(void)
{
    /* TODO(waveC): 16-instruction body not hand-transcribed; the facts
       above are extracted from the listing (0674C4..0674E4). */
}

/* ---------------------------------------------------------------------------
 * 0674E4-067502 (30 B)  wx_content_0674E4  [sub_674E4]  Skeleton
 * Callers: table/indirect or fall-through (none by absolute reference).
 * writes draw_attr_B050
 * reads ram_FF071A
 * ------------------------------------------------------------------------- */
void wx_content_0674E4(void)
{
    /* TODO(waveC): 6-instruction body not hand-transcribed; the facts
       above are extracted from the listing (0674E4..067502). */
}

/* ---------------------------------------------------------------------------
 * 067502-067522 (32 B)  wx_content_067502  [sub_67502]  Skeleton
 * Callers: 0672B2.
 * ------------------------------------------------------------------------- */
void wx_content_067502(void)
{
    /* TODO(waveC): 16-instruction body not hand-transcribed; the facts
       above are extracted from the listing (067502..067522). */
}

/* ---------------------------------------------------------------------------
 * 067524-06752A (6 B)  wx_content_nop_067524  [sub_67524]  Confirmed
 * Callers: table/indirect or fall-through (none by absolute reference).
 * calls sub_6704E
 * Body (complete):
 *   067524  jsr     sub_6704E:24
 *   067528  rts
 * ------------------------------------------------------------------------- */
void wx_content_nop_067524(void) { /* see body above */ }

/* ---------------------------------------------------------------------------
 * 06752A-06754C (34 B)  wx_content_06752A  [sub_6752A]  Skeleton
 * Callers: table/indirect or fall-through (none by absolute reference).
 * calls loc_61D8B+1
 * reads wx_B275, wx_busy
 * ------------------------------------------------------------------------- */
void wx_content_06752A(void)
{
    /* TODO(waveC): 8-instruction body not hand-transcribed; the facts
       above are extracted from the listing (06752A..06754C). */
}

/* ---------------------------------------------------------------------------
 * 06754C-0675EE (162 B)  wx_content_06754C  [sub_6754C]  Skeleton
 * Callers: 067394, 067A52.
 * calls sub_65D44, sub_65C50, sub_67A18, sub_65D1C, sub_1BF84, sub_1BF98
 * writes disp_flags_BC59, popup_id, sub_frame_len, sub_popup_sent,
 *     tmr_9538, wx_prev_state, wx_state
 * reads frame_len_saved, ram_FFB274, ram_FFB287, ram_FFB47B, wx_B266
 * ------------------------------------------------------------------------- */
void wx_content_06754C(void)
{
    /* TODO(waveC): 48-instruction body not hand-transcribed; the facts
       above are extracted from the listing (06754C..0675EE). */
}

