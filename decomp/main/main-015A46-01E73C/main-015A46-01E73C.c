/* ============================================================================
 * main-015A46-01E73C.c  -  Hand-reconstructed C for MAIN 0x015A46-0x01E73C.
 * Lane main-015A46-01E73C, C-reconstruction wave C.
 *
 * DOCUMENTATION ONLY.  By-hand transcription of the H8SX disassembly of
 * FT3D_MAIN_ver102_EXP.bin (big-endian, base 0; comment addresses = file
 * offsets).  Not compiled.  Function order = address order.  Each header
 * carries a machine-readable marker:  @start-end ida_name new_name conf: text
 *
 * Register model (Renesas H8S/H8 C): args er0/er1/er2 (r0l.. for bytes),
 * result r0/r4l and the CCR Z flag.  In this range almost every routine is a
 * setup-menu key/dial handler called with er0 = rec = [FF812A], the active
 * band/UI record (rec+1 = screen id, rec+0 = previous screen; field map in
 * doc 35 / ida/out/chanrec/fields.tsv).  Results come back in r4l / r3l.
 *
 * Shared helpers outside this range (names used below):
 *   key_consume()          sub_3FFA0  AAE0=0, A9ED=0xFF, 817E.1=0 (doc 49)
 *   key_reject_beep()      sub_3FF9C  AAE0=0x1D then as above
 *   ui_pop_screen(rec)     sub_3FF3A  runs exit handler for 0x0E..0xDB, pops
 *   ui_push_screen(rec,id) sub_3FF10
 *   dial_step_clamp(r)     sub_3F600  saturating step of record {lo,hi,u8*};
 *                                     at a limit key_consume + r4l=0xFF
 *   dial_step_wrap_dirty(r) sub_3F628 AA30|=0x40 then dial_step_wrap
 *   dial_step_wrap(r)      sub_3F62E  wrap step by A9EE.0; new value in r3l
 *   dial_step_up_wrap(r)   sub_3F636
 *   eep_save_r1/2/3(n)     sub_3CCBC/3CCEC/3CD1C  save byte n of region R1/R2/R3
 *   eep_save_rX_block(a,n) sub_3CCD0/3CD00/3CD30  save n bytes at RAM a
 *   eep_reload_3CD4C / 3CE22   EEPROM reads through sub_3AB80 (I2C, 0xA1)
 *   menu_list_dial(rec)    loc_14E04  item-list scroll (level 0)
 *   menu_level_or_list(rec) sub_151EC level 0 -> list scroll and return 0
 *   menu_level_or_call(rec,cb) sub_15206 as above; ctx stacked -> cb
 *   menu_dispatch_by_level(rec,tbl) loc_15260 tbl[AD68] (tbl[0] if AD9D)
 *   menu_close_screen(rec) sub_15968  menu_key_back(rec) sub_15948
 *   menu_ctx_push/pop      sub_15910 / sub_15A02
 *   menu_exit_all(rec)     sub_14BBA/14BBC  pop twice, re-push 0x0A/0x0B
 *   rec_is_not_b_slot(rec) sub_3FFB4  rec==FF90F0 -> key_consume, false
 *   chan_bitpos(ch,&off,&bit) sub_1C2A4 (this lane)
 *   Step-record tables (rec_XXXXX) are ROM data at the named address; their
 *   bytes are not in the repo, so limits are cited by address only.
 * ========================================================================== */

#include <stdint.h>
#include <string.h>
typedef uint8_t u8; typedef int8_t s8; typedef uint16_t u16; typedef uint32_t u32;
typedef struct rec rec_t;          /* band/UI record, fields per doc 35:      */
/* +0 prev_screen +1 screen +3 band03 +4 band04 +5 vfo_mode(1 VFO,2 MEM,5..)
 * +7 f07 (b2-3 MEMORY SKIP) +0x12 flags12 +0x13 +0x14 step14 +0x15 shift15
 * +0x16 sqltype16 +0x17 f17 (tone) +0x18 f18 (DCS code) +0x19 rxmode19
 * +0x1A rx freq +0x1E ofs1E +0x22 name22[16] +0x34 pr34 +0x35 dcs_inv35
 * +0x36 mode36 +0x37 sql_s37 +0x38 f38 +0x39 gate39 +0x46 f46 (b0 keep shift)
 * +0x5A f5A +0x86 f86 +0x8C f8C (pending reprogram code 3/4/5)            */
typedef struct { u8 lo, hi; u8 *p; } step_rec_t;
typedef void (*handler_t)(rec_t *);
extern handler_t dial_tbl_12268[];  /* 0x012268 BE32 x219, idx id-0x0E   */
extern const u16 exit_tbl_19A9E[];  /* 0x019A9E BE16 x206, +0x148A0       */

/* ---- RAM / IO cells (see globals.tsv) ---- */
extern rec_t *ui_rec;              /* FF812A */
#define REC_B_SLOT ((rec_t *)0xFF90F0)
extern u8 menu_level;   /* FFAD68 setup-menu level: 0 = item list, 1 = item open, 2+ = editing; in text  */
extern u8 menu_ctx_live;   /* FFAD9D 1 = edit context live, 0 = stacked in AD9E..ADA0 (nested editor) */
extern u8 menu_ctx_saved_level;   /* FFAD9E stacked AD68 */
extern u8 nested_stage;   /* FFAD9C nested-edit stage (1/2 select pop, other values post key 4) */
extern u8 menu_subpage;   /* FFAD6A setup sub-page (2 = open, AD6B = key that opened it); most setup keys  */
extern u8 subpage_key_AD6B;   /* FFAD6B key/digit that opened the sub-page */
extern u8 confirm_pending;   /* FFAD98 BACK swallowed once after a confirm prompt (tone 0x46) */
extern u8 sub_cursor_AD99;   /* FFAD99 sub-cursor inside the auto-reply editor (call col / text col) */
extern u8 char_mode_AD81;   /* FFAD81 1 = character step offers '*' (wildcard charset) */
extern u8 pw_buf_AD88[6];   /* FFAD88 PASSWORD edit digits; AD8A..AD8D = 4-digit code copied to FF896C */
extern u8 seq_buf_AD8E[4];   /* FFAD8E typed-digit unlock buffer compared as one long */
extern u16 ui_AD92;   /* FFAD92 working copy of FF898C (screen 0x79 band bitmap) */
extern u8 ui_AD94;   /* FFAD94 band of the record when screen 0x79 opened */
extern u8 text_buf_AD6E[0x12];   /* FFAD6E 16-char text edit buffer */
extern u8 text_ADA2[60];   /* FFADA2 BEACON STATUS TEXT edit buffer */
extern u8 ar_text_ADDE[0x43];   /* FFADDE APRS auto-reply text */
extern u8 key_event;   /* FFA9ED key code mailbox (0xFF = consumed; 4/6 synthesized cursor keys) */
extern u8 key_flags;   /* FFA9EE b0 = dial direction down / CCW, b7 = long press */
extern u8 key_digit;   /* FFA9F0 digit of a keypad key (0 = none) */
extern u8 ui_flags;   /* FFAA30 b6 = value changed (exit handler saves, then clears), b7 = item opened */
extern u8 ui_flags_AA31;   /* FFAA31 b2 = coarse step in RPT SHIFT FREQ editor (cleared on pop) */
extern u8 ui_flags_AA34;   /* FFAA34 b6 = PASSWORD edited */
extern u8 ui_flags_AA37;   /* FFAA37 b2 gates screens 0xD4/0xD5 and nullsub_30; b6 cleared by B-slot squelc */
extern u8 dial_scratch;   /* FFAA56 scratch byte the step records point at when a record field is edited */
extern u8 tone_ev;   /* FFAAE0 tone / prompt mailbox (0x39 beep preview, 0x16 unlock ok, 0x46 prompt, */
extern u8 edit_row_B054;   /* FFB054 editor row, reset 0 on entry/exit */
extern u8 edit_col_B055;   /* FFB055 editor column, reset 1 */
extern u8 edit_cursor;   /* FFB3F4 edit cursor / selected slot */
extern u8 edit_cursor_max;   /* FFB3F5 shadow of B3F4 (list selection) */
extern u8 edit_sub_flags;   /* FFB380 b0 = sub-edit active (BACK calls sub_214BA) */
extern u8 list_top_A4F5;   /* FFA4F5 first visible row of multi-row editors */
extern u8 win_mode_B091;   /* FFB091 1 = page-mode window scroll */
extern u8 ui_9542;   /* FF9542 cursor-blink / edit timer (0x96 after a char change) */
extern u8 setup_group;   /* FF8F2E 0-based setup group of the item list */
extern u16 ui_mode_8F2C;   /* FF8F2C UI mode word (0x10 enables the 08030706 sequence) */
extern u8 node_mode;   /* FF8DDE node / PC-keyed mode; many dials refused when nonzero */
extern u8 band_sel;   /* FF8EA0 b6 = band B active; b4 = mirror squelch to the other band */
extern u8 slot_chk;   /* FF8EA6 b0 = B record in use */
extern u8 comm_mode_a;   /* FF8D20 band-A comm mode (1 = digital: suppress reprogram request) */
extern u8 comm_mode_b;   /* FF8DD5 band-B comm mode */
extern u8 tx_state;   /* FF94C0 0 idle, nonzero transmitting */
extern u8 tx_req_flag;   /* FFAACF reprogram code posted while transmitting */
extern u8 tsearch_a_state;   /* FF8FE0 tone-search state band A (1 start, 3 stop) */
extern u8 tsearch_a_active;   /* FF8FE2 tone search running band A */
extern u8 tsearch_b_state;   /* FF90E8 tone-search state band B */
extern u8 tsearch_b_active;   /* FF90EA tone search running band B */
extern u8 r1_base[];   /* FF8920 EEPROM region R1 image; R1 n -> FF8920+n, EEPROM 0x580+n */
extern u8 r2_base[];   /* FF8AA0 EEPROM region R2 image; R2 n -> FF8AA0+n, EEPROM 0xC000+n */
extern u8 r3_base[];   /* FF8D20 EEPROM region R3 image; R3 n -> FF8D20+n, EEPROM 0xD000+n */
extern u8 r1_set_89BE;   /* FF89BE R1 0x9E bit flags (b1 SQL EXPANSION, b3 RPT ARS, b5 SCAN LAMP, b7 VFO  */
extern u8 r1_set_89BF;   /* FF89BF R1 0x9F bit flags (b4 BCLO ...) */
extern u8 r1_set_89C0;   /* FF89C0 R1 0xA0 bit flags (b0 MONI/T-CALL, b7 gates RPT ARS) */
extern u8 r1_set_89C1;   /* FF89C1 R1 0xA1 bit flags (b0 MEMORY WRITE, b2 MEMORY PROTECT, b3 KEY LOCK) */
extern u8 r1_set_89C2;   /* FF89C2 R1 0xA2 bit flags (b0 password on, b1 LANGUAGE, b4 WX ALERT, b6 12/24h */
extern u8 r1_set_89C3;   /* FF89C3 R1 0xA3 bit flags (b0 PRIORITY REVERT, b3 HOME VFO ...) */
extern u8 r1_set_89C4;   /* FF89C4 R1 0xA4 feature flags (b1/b2/b3 group13/b4 RAM DISPLAY), b0 toggled by */
extern u8 r1_set_89C5;   /* FF89C5 R1 0xA5 bit flags (b0 TARGET LOCATION, b7 LAMP field) */
extern u8 r1_set_89A4;   /* FF89A4 LCD DIMMER level */
extern u8 r1_set_89B4;   /* FF89B4 screens 0xD4 (b4-6) / 0xD5 (b0-2) */
extern u8 r1_set_8936;   /* FF8936 DTMF memory slot */
extern u8 r1_sql_8970;   /* FF8970 SQL LEVEL band A (8971 band B, 8972/8973 AM) */
extern u8 att_bitmap_8976[];   /* FF8976 per-memory-channel ANT ATT bitmap */
extern u16 r1_set_898C_w;   /* FF898C band bitmap edited on screen 0x79 */
extern u16 r1_set_898E_w;   /* FF898E word setting 0..0x7F8 step 8 (screen 0xD6) */
extern u32 r1_pw_896C;   /* FF896C PASSWORD code */
extern u8 r2_callsign_8AA2[6];   /* FF8AA2 APRS callsign; FF8AA8 = SSID */
extern u8 r2_set_8AAB;   /* FF8AAB APRS bits (b1 SmartBeacon, b6 AUTO beacon, b0/b3/b7 AF DUAL/MUTE/GPS T */
extern u8 r2_aprs_filter_8AAE;   /* FF8AAE APRS filter mask (8AAF b0 continues it) */
extern u8 aprs_pos_src;   /* FF8AB8 position source: 0 GPS, 1/2 manual, >=3 stored slot */
extern u8 r2_sb_type_8BCC;   /* FF8BCC SmartBeaconing type (0 = off) */
extern u8 beacon_mode_A90C;   /* FFA90C beacon mode 0/1 AUTO/2 SMART */
extern u8 sb_edit_A90E[7];   /* FFA90E SmartBeaconing parameter edit block (A90E low, A90F high speed) */
extern u8 r2_digipath_8BE5;   /* FF8BE5 DIGI PATH type (>=3 full path) */
extern u8 r2_digi_hop_8AC2;   /* FF8AC2 selected hop (7-byte entries from table 0x0186F6) */
extern u8 r2_sym_set_8C1E;   /* FF8C1E symbol set (3 = user) */
extern u8 r2_symbol_8AA1;   /* FF8AA1 symbol code (0xC4 = user-defined) */
extern u8 r2_com_8C26;   /* FF8C26 COM PORT: b7 STATUS, b0 INPUT */
extern u8 r2_com_8C2A;   /* FF8C2A COM PORT Mic-E/POSITION/WEATHER/OBJECT/ITEM bits */
extern u8 r2_ar_call_8CFC[7];   /* FF8CFC auto-reply to-call (wildcards allowed) */
extern u8 msg_text_A574[67];   /* FFA574 APRS message compose text (A56C/A56D call, A573 SSID) */
extern u8 rtc_edit_A9CC[7];   /* FFA9CC DATE & TIME edit image (BCD); A9C4 = clock image */
extern u8 PORT_FBA5;   /* FFFBA5 port pull-up register; low nibble set for screen 0x42, cleared on exit */
extern u8 PORT_52;   /* FFFF52 output port; b5 = inverse of rec+0x12.4 (RF path) */
extern u8 IO_FE90;   /* FFFE90 serial register zeroed before reopening the COM port (FE92 too) */

/* Remaining cells are named <area>_<addr> in the bodies (e.g. ui_A507 = FFA507, r1_set_89AA = FF89AA). */

/* --------------------------------------------------------------------------
 * @015A46-015A4E sub_15A46 setup_key_tail_15A46 Inferred: IDA fragment; AD6A==0 -> shared key path loc_159E6 in sub_159C2, else loc_15A4E (unlisted)
 * Pure branch fragment.  loc_159E6 (inside sub_159C2) is the shared
 * "node-mode / sub-page / long-press" filter for setup keys; loc_15A4E is
 * code IDA left outside any function (0x015A4E-0x015A78).
 * -------------------------------------------------------------------------- */
void setup_key_tail_15A46(rec_t *rec)                     /* 015A46 */
{
    if (menu_subpage == 0) setup_key_common_159E6(rec);   /* 015A4A beq loc_159E6 */
    else                   setup_key_15A4E(rec);          /* 015A4C unlisted code */
}

/* --------------------------------------------------------------------------
 * @015A78-015A96 sub_15A78 setup_key_back Inferred: BACK-type key in a setup screen: leaves the value editor (running the save/exit handler) or closes the screen
 * Callers: key table (no direct xref).  Falls through into sub_15A96.
 * Refused (key_consume) while a sub-page is open (AD6A) or on a long press
 * (A9EE.7).  If the item editor is open (menu_level != 0) the pending-confirm
 * check sub_15AB8 may swallow the key; otherwise the item's exit handler
 * (sub_19158) runs and the level drops to 0.  At level 0 the screen is
 * popped (sub_15968).
 * -------------------------------------------------------------------------- */
void setup_key_back(rec_t *rec)                           /* 015A78 */
{
    if (menu_subpage != 0 || (key_flags & 0x80)) {        /* 015A78..015A84 */
        key_consume();                                    /* 015AB2 */
        return;
    }
    ui_flags_AA3D &= ~0x02;                               /* 015A86 bclr #1 */
    if (menu_level != 0) {
        if (setup_confirm_pending()) return;              /* 015A92 bsr sub_15AB8 */
        setup_exit_and_close_level(rec);                  /* 015A96 fall-through */
        return;
    }
    /* 015A9C: level 0 */
    menu_close_screen(rec);                               /* 015AA6 jsr sub_15968 */
    menu_level = 0;                                       /* 015AAC */
}

/* --------------------------------------------------------------------------
 * @015A96-015AB8 sub_15A96 setup_exit_and_close_level Confirmed: run the current item's exit (save) handler, then menu_level = 0
 * Callers: sub_15A78 (fall-through), 0x02AA86.  The tail (015A9C..015AB6) is
 * the rest of sub_15A78 (level-0 close and the key_consume exit).
 * -------------------------------------------------------------------------- */
void setup_exit_and_close_level(rec_t *rec)               /* 015A96 */
{
    setup_run_exit_handler(rec);                          /* 015A96 jsr sub_19158 */
    menu_level = 0;                                       /* 015AAA..015AAC */
}

/* --------------------------------------------------------------------------
 * @015AB8-015ABE sub_15AB8 setup_confirm_pending Confirmed: returns 1 (and clears AD98) if a confirm prompt was pending; else falls into sub_15ABE's check
 * Callers: 0x014C0E, sub_15A78, sub_15A96 body.  Result in r4l / Z.
 * -------------------------------------------------------------------------- */
u8 setup_confirm_pending(void)                            /* 015AB8 */
{
    if (confirm_pending == 0) return setup_confirm_check_15AC8();  /* 015ABC beq */
    confirm_pending = 0;                                  /* 015ABE */
    return 1;
}

/* --------------------------------------------------------------------------
 * @015ABE-015AF0 sub_15ABE setup_confirm_check Confirmed: body of sub_15AB8; at entry clears AD98 and returns 1; loc_15AC8 raises the 0x46 prompt when R2 n=9 (F3BC POSITION COMMENT byte) == 0x0E
 * Callers: 0x02AA64, 0x02AA74, sub_15AB8.
 * loc_15AC8: if FF8AA9 == 0x0E the code posts message/tone 0x46 to AAE0,
 * sets both B3F4/B3F5 (edit cursor / its shadow) to 2 and calls sub_6FBE2,
 * then records AD98 = 1 so the next BACK press is swallowed once.
 * -------------------------------------------------------------------------- */
u8 setup_confirm_check(void)                              /* 015ABE */
{
    confirm_pending = 0;                                  /* 015ABE..015AC0 */
    return 1;                                             /* 015AC4 */
}
u8 setup_confirm_check_15AC8(void)                        /* 015AC8 (label) */
{
    u8 r;
    if (r2_set_8AA9 == 0x0E) {                            /* 015AC8 cmp #0xE */
        tone_ev     = 0x46;                               /* 015AD0 */
        edit_cursor = 2;  edit_cursor_max = 2;            /* 015AD8/015ADC B3F4/B3F5 */
        sub_6FBE2();                                      /* 015AE0 */
        r = 1;
    } else {
        r = 0;
    }
    confirm_pending = r;                                  /* 015AEA */
    return r;
}

/* --------------------------------------------------------------------------
 * @015AF0-015B26 sub_15AF0 setup_key_close_if_valid Inferred: key handler: close the screen unless R3 n=6 (FF8D26) is 0xFF, in which case the reject tone is used
 * Refused on sub-page / AA35.5 / long press.  0x015B14 (jsr ui_pop_screen)
 * is an unreachable-by-fallthrough label kept in the body.
 * -------------------------------------------------------------------------- */
void setup_key_close_if_valid(rec_t *rec)                 /* 015AF0 */
{
    if (menu_subpage || (ui_flags_AA35 & 0x20) || (key_flags & 0x80)) {
        key_consume();                                    /* 015B20 */
        return;
    }
    if (r3_set_8D26 == 0xFF) key_reject_beep();           /* 015B1A jsr sub_3FF9C */
    else                     menu_close_screen(rec);      /* 015B0E jsr sub_15968 */
    /* 015B14: ui_pop_screen(rec) - only reached by a branch from elsewhere */
}

/* --------------------------------------------------------------------------
 * @015B26-015B66 sub_15B26 setup_key_back_b380 Inferred: BACK variant: if B380.0 is set, clear it and call sub_214BA instead of saving
 * B380 bit 0 is a "sub-edit active" flag (cleared by the entry hook 0x015CDA).
 * -------------------------------------------------------------------------- */
void setup_key_back_b380(rec_t *rec)                      /* 015B26 */
{
    if (menu_subpage || (key_flags & 0x80)) { key_consume(); return; }
    if (menu_level == 0) { menu_close_screen(rec); return; }   /* 015B5A */
    if (edit_sub_flags & 0x01) {                          /* 015B3A btst #0,B380 */
        edit_sub_flags &= ~0x01;
        sub_214BA();                                      /* 015B48 */
        return;
    }
    setup_run_exit_handler(rec);                          /* 015B4E */
    menu_level = 0;
}

/* --------------------------------------------------------------------------
 * @015B66-015BA6 sub_15B66 setup_key_back_bbef Inferred: BACK variant: if BBEF is set, step back to level 1 (and clear BBEF) instead of saving
 * -------------------------------------------------------------------------- */
void setup_key_back_bbef(rec_t *rec)                      /* 015B66 */
{
    if (menu_subpage || (key_flags & 0x80)) { key_consume(); return; }
    if (menu_level == 0) { menu_close_screen(rec); return; }   /* 015B9A */
    if (ui_BBEF != 0) {                                   /* 015B7A */
        menu_level = 1;
        ui_BBEF = 0;
        return;
    }
    setup_run_exit_handler(rec);                          /* 015B8E */
    menu_level = 0;
}

/* --------------------------------------------------------------------------
 * @015BA6-015C16 sub_15BA6 setup_key_enter_editor Inferred: ENTER-type key: at level 0 opens the value editor (level 2) and runs the entry hook; at level>0 stacks/restores a nested edit context or posts key 4 to sub_1690A
 * Refused in node/PC mode (FF8DDE != 0) once inside the editor.
 * AD9C is a nested-edit stage counter: 2 -> restore the stacked context
 * (sub_15A02), otherwise synthesize key event 4 and call sub_1690A.
 * -------------------------------------------------------------------------- */
void setup_key_enter_editor(rec_t *rec)                   /* 015BA6 */
{
    if (menu_subpage || (key_flags & 0x80)) { key_consume(); return; }
    if (menu_level == 0) {
        menu_level   = 2;                                 /* 015BBA */
        menu_ctx_live = 1;                                /* 015BC2 AD9D */
        setup_item_enter(rec, 0);                         /* 015BC6 jsr sub_15CCE (r4l=1 here, see note) */
        edit_col_B055 = 2;                                /* 015BCA */
        return;
    }
    if (node_mode != 0) { key_consume(); return; }        /* 015BD2 FF8DDE */
    if (menu_ctx_live != 0) {                             /* 015BDE */
        menu_ctx_push(/*r4l*/);                           /* 015BE4 jsr sub_15910 */
        nested_stage = 0;                                 /* 015BEA AD9C */
        return;
    }
    if (nested_stage == 2) {                              /* 015BF0 */
        menu_ctx_pop();                                   /* 015BF8 jsr sub_15A02 */
        nested_stage = 0;
        return;
    }
    key_event = 4;                                        /* 015C04 A9ED */
    sub_1690A(rec);                                       /* 015C0A */
    /* note: sub_15CCE stores r4l to AD98 first; r4l is 1 here (set at 015BC0) */
}

/* --------------------------------------------------------------------------
 * @015C28-015C30 sub_15C28 setup_key_select_guard Confirmed: fragment: long press -> key_consume (loc_15C96), else falls into sub_15C30
 * -------------------------------------------------------------------------- */
void setup_key_select_guard(rec_t *rec)                   /* 015C28 */
{
    if (key_flags & 0x80) { key_consume(); return; }      /* 015C2E -> 015C96 */
    setup_key_select(rec);                                /* fall into 015C30 */
}

/* --------------------------------------------------------------------------
 * @015C30-015C9C sub_15C30 setup_key_select Inferred: SELECT key: level 0 -> enter item (sub_15CB8); live ctx -> stack it; level 1 -> refused; nested stage 1 -> pop (and set sub-page 2 if one was open); else post key 4 to sub_169DC
 * Callers: 0x015C2E (fall-through from sub_15C28).
 * -------------------------------------------------------------------------- */
void setup_key_select(rec_t *rec)                         /* 015C30 */
{
    if (menu_level == 0) { setup_item_open(rec); return; }     /* 015C36 jsr sub_15CB8 */
    if (menu_ctx_live != 0) {                             /* 015C3C */
        if (menu_level == 1) nested_stage = 0;            /* 015C42..015C4C */
        menu_ctx_push();                                  /* 015C50 */
        return;
    }
    if (menu_level == 1) { key_consume(); return; }       /* 015C5C */
    if (nested_stage == 1) {                              /* 015C5E */
        menu_ctx_pop();                                   /* 015C6C / 015C7E */
        nested_stage = 0;
        if (menu_subpage != 0) menu_subpage = 2;          /* 015C76 */
        return;
    }
    key_event = 4;                                        /* 015C8A */
    sub_169DC(rec);                                       /* 015C90 */
}

/* --------------------------------------------------------------------------
 * @015C9C-015CB8 sub_15C9C setup_key_6_169DC Inferred: key: if setup_key_allowed (sub_15318) returns 1 -> consume; any other nonzero -> post key 6 and call sub_169DC
 * -------------------------------------------------------------------------- */
void setup_key_6_169DC(rec_t *rec)                        /* 015C9C */
{
    u8 r = setup_key_allowed();                           /* 015C9C jsr sub_15318 */
    if (r == 0) return;
    if (r == 1) { key_consume(); return; }                /* 015CB2 */
    key_event = 6;                                        /* 015CA6 */
    sub_169DC(rec);
}

/* --------------------------------------------------------------------------
 * @015CB8-015CCE sub_15CB8 setup_item_open Confirmed: open the selected setup item: menu_level=1, ctx live, clear BC34/BC03, then falls into the entry hook with r4l=0
 * Callers: 13 sites (0x01553C..0x0158FA key tables, 0x02A63E, sub_14AF4, sub_152D4, sub_152F4, sub_15C30).
 * -------------------------------------------------------------------------- */
void setup_item_open(rec_t *rec)                          /* 015CB8 */
{
    menu_level    = 1;                                    /* 015CBA */
    menu_ctx_live = 1;                                    /* 015CBE */
    edit_mode_BC34 = 0;                                   /* 015CC4 */
    ui_BC03        = 0;                                   /* 015CCA */
    setup_item_enter(rec, 0);                             /* fall into 015CCE, r4l = 0 */
}

/* --------------------------------------------------------------------------
 * @015CCE-015E1E sub_15CCE setup_item_enter Confirmed: per-item entry hook keyed on screen id rec[1]: resets edit state, then snapshots / preloads the value a few items need
 * Callers: 0x0152BC, 0x015BC6, sub_14DB6, sub_15CB8.
 * Common prologue: AD98 = r4l (confirm flag), BA33 = 0, B380 = 0,
 * B054 = 0, B055 = 1, AA30.7 = 1 ("setup item opened").  Then by screen id:
 * -------------------------------------------------------------------------- */
void setup_item_enter(rec_t *rec, u8 confirm)             /* 015CCE */
{
    confirm_pending = confirm;                            /* 015CCE */
    ui_BA33 = 0;  edit_sub_flags = 0;                     /* 015CD4 / 015CDA (B380) */
    edit_row_B054 = 0;  edit_col_B055 = 1;                /* 015CE0 / 015CE6 */
    ui_flags |= 0x80;                                     /* 015CEA AA30.7 */

    switch (rec->screen) {                                /* 015CF0 @(1,er0) */
    case 0x1A: case 0x1B:                                 /* BANK LINK / bank (g3) */
        eep_reload_3CD4C(0);                              /* 015E08 r1 = 0 */
        edit_cursor = 0;  edit_cursor_max = 0;            /* B3F4 / B3F5 */
        break;
    case 0x1D:                                            /* DEVICE LIST (Bluetooth) */
        if (menu_level != 0 && bt_AAEA != 0) sub_73268(); /* 015DF6 */
        break;
    case 0x2C:                                            /* DTMF (g4[4]) */
        eep_reload_3CE22(r1_set_8936);                    /* 015DE0 R1 n=0x16 */
        edit_cursor = edit_cursor_max = r1_set_8936;      /* 015DEC/015DF0 */
        break;
    case 0x42:                                            /* HOME VFO (F387) */
        if (menu_subpage == 2 || menu_level != 0) {       /* 015DBE */
            ui_flags_AA32 |= 0x08;                        /* 015DCC */
            PORT_FBA5 = (PORT_FBA5 & 0xF0) | 0x08;        /* 015DD2 pull-up nibble */
        }
        break;
    case 0x55:                                            /* PASSWORD (F38B) */
        ui_flags_AA34 &= ~0x40;                           /* 015DAA */
        pw_edit_copy = r1_set_896C;                       /* 015DB0 long FF896C -> AD8A */
        break;
    case 0x71:                                            /* DATE & TIME ADJ */
        sub_3F36E(8, &rtc_A9C4, &rtc_A9CC);               /* 015D94: copy 8 B clock image */
        break;
    case 0x79:                                            /* (unlabelled, 0x79) */
        ui_AD94 = rec->b3;                                /* 015D80 @(3,er0) */
        ui_AD92 = r1_set_898C_w;                          /* 015D88 word */
        break;
    case 0xA4:                                            /* MY POSITION */
        if (aprs_pos_src >= 3) sub_3D4A4(aprs_pos_src - 3);  /* 015D68 FF8AB8 */
        break;
    case 0xA8:                                            /* SmartBeaconing */
        sub_18262();                                      /* 015D60 */
        break;
    case 0x94:                                            /* APRS (g9[6]) */
        sub_508B6();                                      /* 015D58 */
        break;
    case 0x9B:                                            /* BEACON STATUS TEXT */
        sub_3D5AC(r2_set_8ABB);  sub_508B6();             /* 015D50 */
        break;
    case 0xAF:
        sub_3D5E4(r2_set_8CFB);  sub_508B6();             /* 015D46 */
        break;
    case 0xB6:
        sub_3D6D6(r3_set_8D84);  sub_508B6();             /* 015D3C */
        break;
    default:
        break;
    }
}

/* --------------------------------------------------------------------------
 * @015E1E-015E42 sub_15E1E setup_dial Confirmed: DIAL event in a setup screen: level 0 scrolls the item list (sub_14E04); otherwise calls dial_tbl_12268[rec[1]-0x0E]
 * Callers: key slot 0x0D (doc 49).  sub_15E42 computes the index.
 * -------------------------------------------------------------------------- */
void setup_dial(rec_t *rec)                               /* 015E1E */
{
    if (menu_level == 0) { menu_list_dial(rec); return; } /* 015E3C jsr loc_14E04 */
    u8 idx = setup_dial_index(rec);                       /* 015E26 bsr sub_15E42 */
    dial_tbl_12268[idx](rec);                             /* 015E30 BE32 table, jsr @er6 */
}

/* --------------------------------------------------------------------------
 * @015E42-015E62 sub_15E42 setup_dial_index Confirmed: returns rec[1]-0x0E; for screen 0xB3 (unless AA35.5 or a sub-page) first calls loc_14C90
 * Callers: sub_15E1E, sub_19158, sub_4DF2.
 * -------------------------------------------------------------------------- */
u8 setup_dial_index(rec_t *rec)                           /* 015E42 */
{
    u8 id = rec->screen;                                  /* 015E42 */
    if (!(id == 0xB3 && (ui_flags_AA35 & 0x20)) && menu_subpage == 0)
        menu_push_14C90(rec);                             /* 015E58 jsr loc_14C90 */
    /* NB: the 0xB3 test only short-circuits when AA35.5 is set; for every other
     * id the subpage==0 path also calls loc_14C90 (015E48 bne -> 015E52). */
    return id - 0x0E;                                     /* 015E5C */
}

/* @015E62-015E64 sub_15E62 setup_key_refuse_jump Confirmed: bra loc_15EA2 (key_consume). Callers 0x0167B6, 0x016C74, 0x01F28E, sub_1633E */
#define setup_key_refuse_jump(rec)   setup_key_refuse()

/* @015EA2-015EA8 sub_15EA2 setup_key_refuse Confirmed: key_consume(); rts.  Target of the 0x015E64..0x015EA2 unlisted branch ladder */
void setup_key_refuse(void) { key_consume(); }            /* 015EA2 */

/* --------------------------------------------------------------------------
 * @015ED0-015EE6 sub_15ED0 dial_0E Inferred: dial for screen 0x0E: toggle FF89C3.5 (sub_17788); if the B record was used (8EA6.0) set FF917C = 1
 * -------------------------------------------------------------------------- */
void dial_0E(rec_t *rec)                                  /* 015ED0 */
{
    setup_toggle_89C3(5);                               /* 015ED2 jsr sub_17788 */
    if (slot_chk & 0x01) b_rec_dirty_917C = 1;            /* 015ED6 8EA6.0 */
}

/* @015EE6-015EFE sub_15EE6 dial_0F_apo Confirmed: APO (F380): refused in node mode, else wrap-step record 0x015EFE (R1 n=0x73 FF8993) */
void dial_0F_apo(rec_t *rec)                              /* 015EE6 */
{
    if (node_mode != 0) { key_consume(); return; }
    dial_step_wrap_dirty(&rec_15EFE);                     /* 015EF8 sub_3F628 */
}

/* @015F04-015F10 sub_15F04 dial_10 Confirmed: screen 0x10: wrap-step record 0x015F10 */
void dial_10(rec_t *rec) { dial_step_wrap_dirty(&rec_15F10); }   /* 015F04 */

/* @015F16-015F1E sub_15F16 dial_11 Confirmed: screen 0x11: toggle bit 4 of the R1 n=0xA1 byte via sub_17778 */
void dial_11(rec_t *rec) { setup_toggle_89C1(4); }        /* 015F16 jsr sub_17778 */

/* @015F1E-015F34 sub_15F1E dial_12_rpt_ars Confirmed: RPT ARS (F38D): only when FF89C0.7 is set, toggle bit 3 of FF89BE (sub_17760); else refuse */
void dial_12_rpt_ars(rec_t *rec)                          /* 015F1E */
{
    if (r1_set_89C0 & 0x80) setup_toggle_89BE(3);         /* 015F28 jsr sub_17760 */
    else                    key_consume();
}

/* --------------------------------------------------------------------------
 * @015F34-015F96 sub_15F34 dial_13_antenna_att Confirmed: ANTENNA ATT (F320): toggles rec+0x39 bit5, or for a memory channel the per-channel bit in the FF8976 bitmap, then pushes the new state to the RF side
 * Refused for the B-slot record (sub_3FFB4).  rec[5]==2 means memory mode;
 * sub_3F1DC gives the channel number (>=2) used to index the bitmap through
 * sub_1C2A4 (byte offset er6, bit r5l).  The final RF push depends on the
 * operating band (FF8EA0.6): B -> sub_3138E + sub_37A3A, A -> sub_2F8E6 +
 * sub_37A1E (doc 35: these copy +0x39.5 to 0x8176.1 / 0x8173.4).
 * -------------------------------------------------------------------------- */
void dial_13_antenna_att(rec_t *rec)                      /* 015F34 */
{
    if (!rec_is_not_b_slot(rec)) return;                  /* 015F34 jsr sub_3FFB4 */
    rec->f86 &= ~0x01;                                    /* 015F3A */
    u8 ch;
    if (rec->vfo_mode == 2 && (ch = sub_3F1DC(rec)) != 0) {     /* 015F44..015F50 */
        u16 off; u8 bit;
        chan_bitpos(ch - 2, &off, &bit);                  /* 015F64 jsr sub_1C2A4 */
        att_bitmap_8976[off] ^= (u8)(1u << bit);          /* 015F68 bnot r5l */
        att_sync_from_bitmap(rec, ch - 2);                /* 015F72 bsr sub_15F96 */
        ui_flags |= 0x40;                                 /* 015F74 */
    } else {
        rec->gate39 ^= 0x20;                              /* 015F52 bnot #5 */
    }
    if (band_sel & 0x40) { sub_3138E(); sub_37A3A(); }    /* 015F7A */
    else                 { sub_2F8E6(); sub_37A1E(); }
}

/* @015F96-015FB6 sub_15F96 att_sync_from_bitmap Confirmed: rec+0x39 bit5 := bit (ch) of the FF8976 bitmap. Callers 0x015F72, sub_3D022 */
void att_sync_from_bitmap(rec_t *rec, u8 ch)              /* 015F96 */
{
    u16 off; u8 bit;
    chan_bitpos(ch, &off, &bit);                          /* 015F96 */
    if (att_bitmap_8976[off] & (1u << bit)) rec->gate39 |= 0x20;
    else                                     rec->gate39 &= ~0x20;
}

/* @015FB6-015FBE sub_15FB6 dial_14_bclo Confirmed: BCLO (F381): toggle bit 4 of FF89BF via sub_17768 */
void dial_14_bclo(rec_t *rec) { setup_toggle_89BF(4); }   /* 015FB6 */

/* @015FBE-015FC8 sub_15FBE setup_level_dispatch_15FC8 Confirmed: menu_dispatch_by_level(rec, tbl 0x015FC8) (jmp loc_15260) */
void setup_level_dispatch_15FC8(rec_t *rec) { menu_dispatch_by_level(rec, tbl_15FC8); }

/* @015FD4-015FE8 sub_15FD4 setup_toggle_89BF_b3 Inferred: level-table slot: toggle FF89BF.3 (sub_17768(3)); label loc_15FDC is a second slot that wrap-steps record 0x015FE8 */
void setup_toggle_89BF_b3(rec_t *rec)                     /* 015FD4 */
{
    setup_toggle_89BF(3);
}
void setup_step_15FE8(rec_t *rec) { dial_step_wrap_dirty(&rec_15FE8); }  /* 015FDC (label) */

/* @015FEE-015FF8 sub_15FEE setup_level_dispatch_15FF8 Confirmed: menu_dispatch_by_level(rec, tbl 0x015FF8) */
void setup_level_dispatch_15FF8(rec_t *rec) { menu_dispatch_by_level(rec, tbl_15FF8); }

/* --------------------------------------------------------------------------
 * @016004-01602C sub_16004 setup_step_bell_field Inferred: level-table slot: wrap-steps rec+0x38 (F340 BELL field) through the AA56 scratch byte using record 0x01602C; loc_16020 is a second slot stepping record 0x016034
 * -------------------------------------------------------------------------- */
void setup_step_bell_field(rec_t *rec)                    /* 016004 */
{
    dial_scratch = rec->f38;                              /* 016004 -> AA56 */
    dial_step_wrap_dirty(&rec_1602C);                     /* {lo,hi,&AA56} */
    rec->f38 = dial_scratch;                              /* 01601A */
}
void setup_step_16034(rec_t *rec) { dial_step_wrap_dirty(&rec_16034); }  /* 016020 (label) */

/* @016032-016034 nullsub_78 dial_17_nop Confirmed: screen 0x17 dial: empty */
void dial_17_nop(rec_t *rec) { }                          /* 016032 rts */

/* @01603A-016056 sub_1603A dial_18_beep_level Confirmed: BEEP LEVEL (F397): clamp-step record 0x016056 (R1 n=0x76 FF8996), post preview tone 0x39, clear AAE1.3, re-apply via sub_1E79C */
void dial_18_beep_level(rec_t *rec)                       /* 01603A */
{
    dial_step_clamp(&rec_16056);                          /* 016040 sub_3F600 */
    tone_ev = 0x39;                                       /* 016044 preview beep */
    tone_flags_AAE1 &= ~0x08;                             /* 01604A */
    sub_1E79C();                                          /* 016050 (in this lane's neighbour) */
}

/* @01605C-016064 sub_1605C ui_mark_dirty Confirmed: AA30 |= 0x40 (value changed / redraw). Callers 0x01632E, 0x017452, 0x01A418, sub_16A2E, sub_1A58C */
void ui_mark_dirty(void) { ui_flags |= 0x40; }            /* 01605C */

/* @016064-01607C sub_16064 setup_step_16098_l1 Inferred: level helper: at level 1 wrap-steps record 0x016098 (no dirty flag); other levels do nothing */
void setup_step_16098_l1(rec_t *rec)                      /* 016064 */
{
    u8 lvl = menu_level_or_list(rec);                     /* 016064 jsr sub_151EC */
    if (lvl == 1) dial_step_wrap(&rec_16098);             /* 016076 sub_3F62E */
}

/* @01607C-016098 sub_1607C setup_step_16098_or_1A33C Inferred: level 1 -> wrap-step record 0x016098; level 2+ -> sub_1A33C */
void setup_step_16098_or_1A33C(rec_t *rec)                /* 01607C */
{
    u8 lvl = menu_level_or_list(rec);
    if (lvl == 0) return;
    if (lvl == 1) dial_step_wrap(&rec_16098);
    else          sub_1A33C(rec);                         /* 016086 */
}

/* @01609E-0160BC sub_1609E setup_clear_text_AD6E Inferred: clears/edit-fills the 16-char text buffer FFAD6E (cursor block at +0x12) via sub_160F0 path sub_167F0(r6l=0x10,r6h=2); label 0x0160B6 = sub_14BBA. Callers 0x0153A4, sub_1609C */
void setup_clear_text_AD6E(rec_t *rec)                    /* 01609E */
{
    text_edit_backspace(rec, text_buf_AD6E, text_buf_AD6E + 0x12, 0x10, 2);  /* 0160B0 jsr sub_167F0 */
}

/* @0160BC-0160D8 sub_160BC setup_toggle_89C8_row Inferred: via sub_15206 (level helper with callback sub_1A0B4): at level n toggles bit (n-1) of FF89C8, marks dirty */
void setup_toggle_89C8_row(rec_t *rec)                    /* 0160BC */
{
    u8 lvl = menu_level_or_call(rec, sub_1A0B4);          /* 0160C2 jsr sub_15206 */
    if (lvl == 0) return;
    r1_set_89C8 ^= (u8)(1u << (lvl - 1));                 /* 0160CA bnot r2l */
    ui_flags |= 0x40;
}

/* @0160D8-0160EE sub_160D8 dial_20_rf_path Confirmed: screen 0x20 dial: toggle rec+0x12 bit4 (RF band/path) and copy its inverse to port FF52 bit5 */
void dial_20_rf_path(rec_t *rec)                          /* 0160D8 */
{
    rec->flags12 ^= 0x10;                                 /* 0160DC bnot #4 */
    if (rec->flags12 & 0x10) PORT_52 &= ~0x20;            /* 0160E6 bld/bist #5 */
    else                     PORT_52 |=  0x20;
}

/* @0160EE-0160F0 sub_160EE dial_22_nop Confirmed: screen 0x22 dial: empty */
void dial_22_nop(rec_t *rec) { }

/* --------------------------------------------------------------------------
 * @0160F0-01611E sub_160F0 text_edit_clear_tail Inferred: text editor DELETE: on key 2 or long press at level>=2, writes 0xFF backwards from er5 for (r6l+2-level) bytes, marks dirty and sends glyph 0x1E (sub_1BF40)
 * Args: er5 = end of buffer, r6l = buffer length.  Callers: sub_163AC.
 * -------------------------------------------------------------------------- */
void text_edit_clear_tail(u8 *end, u8 len)                /* 0160F0 */
{
    if (!(key_event == 2 || (key_flags & 0x80)) || menu_level < 2) {
        key_consume(); return;                            /* 016118 */
    }
    u8 n = len + 2 - menu_level;                          /* 016108 */
    do { *--end = 0xFF; } while (--n);                    /* 01610E pad with 0xFF */
    text_edit_refresh();                                  /* 016114 bsr sub_1611E */
}

/* @01611E-01612C sub_1611E text_edit_refresh Confirmed: AA30 |= 0x40; sub_1BF40(0x1E) */
void text_edit_refresh(void) { ui_flags |= 0x40; sub_1BF40(0x1E); }  /* 01611E */

/* @01612C-01613E sub_1612C setup_key_back_2244C Inferred: level>0 -> sub_2244C, else ui_pop_screen */
void setup_key_back_2244C(rec_t *rec)                     /* 01612C */
{
    if (menu_level != 0) sub_2244C(rec);
    else                 ui_pop_screen(rec);
}

/* @01613E-016152 sub_1613E setup_step_rec18_nodirty Inferred: wrap-step rec+0x18 (via AA56, record 0x01619A, no dirty flag) then joins sub_16152 at loc_16164 */
void setup_step_rec18_nodirty(rec_t *rec)                 /* 01613E */
{
    dial_scratch = rec->f18;
    u8 v = dial_step_wrap(&rec_1619A);
    rec18_store_and_fix_mode(rec, v);                     /* -> 016164 */
}

/* --------------------------------------------------------------------------
 * @016152-01619A sub_16152 setup_step_rec18 Inferred: wrap-step rec+0x18 (record 0x01619A); unless rec+0x8C is 1/2/6/7 or the band's comm mode (8D20/8DD5) is 1, force rec+0x8C = 5
 * -------------------------------------------------------------------------- */
void setup_step_rec18(rec_t *rec)                         /* 016152 */
{
    dial_scratch = rec->f18;
    u8 v = dial_step_wrap_dirty(&rec_1619A);
    rec18_store_and_fix_mode(rec, v);
}
static void rec18_store_and_fix_mode(rec_t *rec, u8 v)    /* 016164 */
{
    rec->f18 = v;
    u8 m = rec->f8C;
    if (m == 1 || m == 2 || m == 6 || m == 7) return;
    u8 comm = (band_sel & 0x40) ? comm_mode_b : comm_mode_a;   /* 8DD5 / 8D20 */
    if (comm == 1) return;
    rec->f8C = 5;                                         /* 016192 */
}

/* @0161A0-0161BE sub_161A0 dial_27_dcs_inversion Confirmed: DCS INVERSION (F342): wrap-step rec+0x35 via AA56 (record 0x0161BE), then rec+0x8C = 5 */
void dial_27_dcs_inversion(rec_t *rec)                    /* 0161A0 */
{
    dial_scratch = rec->dcs_inv35;
    rec->dcs_inv35 = dial_step_wrap_dirty(&rec_161BE);
    rec->f8C = 5;
}

/* --------------------------------------------------------------------------
 * @0161C4-0161D6 sub_161C4 dial_28_lcd_dimmer Confirmed: LCD DIMMER (F317): clamp-step record 0x016202 (R1 n=0x84 FF89A4); unless FF89AA==0x0A falls into sub_161D6 to push the new level
 * -------------------------------------------------------------------------- */
void dial_28_lcd_dimmer(rec_t *rec)                       /* 0161C4 */
{
    dial_step_clamp(&rec_16202);                          /* 0161CA */
    if (r1_set_89AA == 0x0A) return;                      /* 0161D4 */
    lcd_dimmer_apply();                                   /* fall into 0161D6 */
}

/* @0161D6-0161F2 sub_161D6 lcd_dimmer_apply Confirmed: if FF8004 < 2: A999 = tbl_3B42[FF89A4] (backlight PWM level) */
void lcd_dimmer_apply(void)                               /* 0161D6 */
{
    if (sys_8004 >= 2) return;
    backlight_A999 = dimmer_tbl_3B42[r1_set_89A4];        /* 0161E8 */
}

/* @0161F2-016202 sub_161F2 lcd_dimmer_apply_onoff Confirmed: A999 = tbl_3B42[FF89A4 ? 6 : 0] (reuses the store at loc_161E2) */
void lcd_dimmer_apply_onoff(void)                         /* 0161F2 */
{
    backlight_A999 = dimmer_tbl_3B42[r1_set_89A4 ? 6 : 0];
}

/* @016208-016210 sub_16208 dial_29 Confirmed: screen 0x29: toggle FF89BF.1 (sub_17768(1)) */
void dial_29(rec_t *rec) { setup_toggle_89BF(1); }

/* @016210-016212 sub_16210 dial_2A_nop Confirmed: screen 0x2A dial: empty */
void dial_2A_nop(rec_t *rec) { }

/* @016212-01621C sub_16212 setup_level_dispatch_1621C Confirmed: menu_dispatch_by_level(rec, tbl 0x01621C) */
void setup_level_dispatch_1621C(rec_t *rec) { menu_dispatch_by_level(rec, tbl_1621C); }

/* @01622C-016248 sub_1622C setup_toggle_89BE_b0 Inferred: level slot: toggle FF89BE.0; labels 0x016234 (wrap-step record 0x016248) and 0x016240 (toggle FF89BE.2) are further slots */
void setup_toggle_89BE_b0(rec_t *rec) { setup_toggle_89BE(0); }      /* 01622C */
void setup_step_16248(rec_t *rec)     { dial_step_wrap_dirty(&rec_16248); }  /* 016234 */
void setup_toggle_89BE_b2(rec_t *rec) { setup_toggle_89BE(2); }      /* 016240 */

/* @01626A-01627E sub_1626A setup_key_dtmf_enter Inferred: key: level 0 -> sub_152D4 (open); level 1 -> reload DTMF slot (fall into sub_1627E); level>=2 -> exit handler sub_194E8, back to level 1 */
void setup_key_dtmf_enter(rec_t *rec)                     /* 01626A */
{
    if (menu_level == 0) { setup_key_open_152D4(rec); return; }   /* 01629A */
    if (menu_level >= 2) { exit_2C_dtmf(rec); menu_level = 1; return; }  /* 01628E */
    setup_dtmf_reload(rec);                               /* fall into 01627E */
}

/* @01627E-0162A2 sub_1627E setup_dtmf_reload Confirmed: eep_reload_3CE22(FF8936 = R1 n=0x16, DTMF slot); menu_level = 2 */
void setup_dtmf_reload(rec_t *rec)                        /* 01627E */
{
    eep_reload_3CE22(r1_set_8936);
    menu_level = 2;
}

/* @0162A2-0162B8 sub_162A2 setup_key_back_to_level1 Confirmed: level>=2 -> level 1; else BACK (sub_15948) */
void setup_key_back_to_level1(rec_t *rec)                 /* 0162A2 */
{
    if (menu_level >= 2) menu_level = 1;
    else                 menu_key_back(rec);              /* jsr sub_15948 */
}

/* @0162B8-0162D6 sub_162B8 dtmf_key_digit Inferred: digit key in the DTMF editor: at level>=2 stores digit A9F0 at AC22[level] (sub_162D6); levels 0/1 -> sub_148E6 */
void dtmf_key_digit(rec_t *rec)                           /* 0162B8 */
{
    u8 lvl = menu_level;
    if (lvl == 0 || lvl == 1) { sub_148E6(rec); return; }
    dtmf_store_digit(lvl, key_digit);                     /* 0162CC */
}

/* @0162D6-0162F2 sub_162D6 dtmf_store_digit Confirmed: AC22[idx] = r3l (-0x53DE = 0xFFAC22), cursor up-wrap record 0x01A210, dirty, clear 9542 */
void dtmf_store_digit(u8 idx, u8 digit)                   /* 0162D6 */
{
    dtmf_buf_AC22[idx] = digit;                           /* 0162D6 @(-0x53DE,er2) */
    dial_step_up_wrap(&rec_1A210);                        /* 0162E0 sub_3F636 */
    ui_flags |= 0x40;
    ui_9542 = 0;
}

/* --------------------------------------------------------------------------
 * @0162F2-016334 sub_162F2 dtmf_dial Inferred: dial in the DTMF editor: level 1 -> wrap-step the slot index (record 0x016334) and mirror FF8936 to B3F5; level>=2 -> wrap-step digit AC22[level] (0xFF/negative restarts at 0), then sub_1605C
 * -------------------------------------------------------------------------- */
void dtmf_dial(rec_t *rec)                                /* 0162F2 */
{
    u8 lvl = menu_level_or_list(rec);
    if (lvl == 0) return;
    if (lvl == 1) {
        dial_step_wrap_dirty(&rec_16334);                 /* 01631A */
        edit_cursor_max = r1_set_8936;                    /* 016328 */
        return;
    }
    s8 d = (s8)dtmf_buf_AC22[lvl];                        /* 0162FC */
    u8 v;
    if (d < 0) v = 0;                                     /* 016312 */
    else { dial_scratch = d; v = dial_step_wrap_dirty(&rec_1633A); }  /* 016306 */
    dtmf_buf_AC22[lvl] = v;                               /* 016314 */
    ui_mark_dirty();                                      /* 01632E jsr 0x1605C */
}

/* --------------------------------------------------------------------------
 * @016340-016394 sub_16340 dtmf_key_send Inferred: level 0 -> refuse (sub_15E62); level 1 -> if the band is not digital-only (8D20/8DD5 == 0) and AC24 >= 0: save (sub_194E8) and transmit DTMF slot FF8936 (sub_22E64); level>=2 -> commit text (sub_163AC) and post key 6 to sub_19E82
 * -------------------------------------------------------------------------- */
void dtmf_key_send(rec_t *rec)                            /* 016340 */
{
    u8 lvl = menu_level;
    if (lvl == 0) { setup_key_refuse(); return; }         /* 016378 */
    if (lvl != 1) {                                       /* 01637E */
        dtmf_commit(rec);                                 /* sub_163AC */
        key_event = 6;
        sub_19E82(rec);
        return;
    }
    u8 comm = (band_sel & 0x40) ? comm_mode_b : comm_mode_a;
    if (comm != 0 || (s8)dtmf_buf_AC22[2] < 0) { key_consume(); return; }  /* 016362/016368 */
    exit_2C_dtmf(rec);                                    /* 01636A sub_194E8 */
    dtmf_transmit(r1_set_8936);                           /* 016372 sub_22E64 */
}

/* @0163AC-0163C8 sub_163AC dtmf_commit Inferred: terminate the 16-digit DTMF buffer at AC34 (sub_160F0 with len 0x10); labels 0x0163BA (store digit 0x0C via sub_162D6) and 0x0163C2 (sub_14BBA) are further key slots */
void dtmf_commit(rec_t *rec)                              /* 0163AC */
{
    text_edit_clear_tail(dtmf_buf_AC22 + 0x12 /*AC34*/, 0x10);
}
void dtmf_key_star(rec_t *rec) { dtmf_store_digit(menu_level, 0x0C); }  /* 0163BA (label; r2 = level from caller) */

/* @0163C8-0163CA sub_163C8 dial_2D_nop Confirmed: screen 0x2D dial: empty */
void dial_2D_nop(rec_t *rec) { }

/* @0163CA-0163CC sub_163CA dial_30_nop Confirmed: screen 0x30 dial: empty */
void dial_30_nop(rec_t *rec) { }

/* --------------------------------------------------------------------------
 * @0163CC-016456 sub_163CC hidden_digit_sequence Confirmed: typed-digit unlock: in group 7/sub 4 (or group 2) collects up to 4 digits in AD8E; a full match toggles a FF89C4 feature bit (doc 49)
 * Entry gate: FF8F2E (setup group, 0-based) == 7 needs FF8F4E == 4; group 2
 * jumps to loc_1647A (outside this function, the 0x04030708 matcher for
 * FFB0C8); others refuse.  0x0163EA is a second entry that requires level>0.
 * Digits (A9F0, 0 = none) fill AD8E[0..3]; when the 4th arrives the long is
 * compared:  01020402 -> FF89C4 ^= 0x08 (group 13), 03090309 -> ^= 0x10
 * (RAM DISPLAY), 07070603 -> ^= 0x04, 02060804 -> ^= 0x02.  A match saves
 * R1 0xA4 (sub_193CA) and posts tone 0x16.  Mismatch: clears the slot and
 * key_consume.
 * -------------------------------------------------------------------------- */
void hidden_digit_sequence(rec_t *rec)                    /* 0163CC */
{
    if (setup_group == 7) { if (setup_sub_8F4E != 4) goto refuse; }
    else if (setup_group == 2) { hidden_seq_b0c8_1647A(rec); return; }
    else goto refuse;
    /* 0163EA: alternative entry, if (menu_level == 0) goto refuse; */
    u8 d = key_digit;                                     /* 0163F2 A9F0 */
    if (d == 0) goto refuse;
    int i;
    for (i = 0; i < 4; i++) if (seq_buf_AD8E[i] == 0) break;
    if (i < 3) { seq_buf_AD8E[i] = d; goto refuse; }      /* 016470 then consume */
    if (i == 4) goto refuse;                              /* 01641A bne */
    seq_buf_AD8E[3] = d;                                  /* 01641C */
    switch (*(u32 *)seq_buf_AD8E) {
    case 0x01020402: r1_set_89C4 ^= 0x08; break;          /* -> sub_1645E */
    case 0x03090309: r1_set_89C4 ^= 0x10; break;          /* -> sub_16456 */
    case 0x07070603: r1_set_89C4 ^= 0x04; break;          /* 01644E */
    case 0x02060804: r1_set_89C4 ^= 0x02; break;          /* 016446 */
    default: goto refuse;
    }
    exit_save_r1_A4();                                    /* 016464 jsr sub_193CA */
    tone_ev = 0x16;
    return;
refuse:
    key_consume();                                        /* 016474 */
}

/* @016456-01645E sub_16456 hidden_toggle_ram_display Confirmed: FF89C4 ^= 0x10 (RAM DISPLAY), then the common save + tone 0x16 tail */
void hidden_toggle_ram_display(void) { r1_set_89C4 ^= 0x10; exit_save_r1_A4(); tone_ev = 0x16; }

/* @01645E-01647A sub_1645E hidden_toggle_group13 Confirmed: FF89C4 ^= 0x08 (hidden group 13), save R1 0xA4, tone 0x16.  Also holds the 016470/016474 refuse tail */
void hidden_toggle_group13(void) { r1_set_89C4 ^= 0x08; exit_save_r1_A4(); tone_ev = 0x16; }

/* @016558-016574 sub_16558 setup_clear_band_flags Inferred: if not at list level and FF89C4.1 is set: FF8EA0 = 0 (clears band-select/dual flags); else refuse */
void setup_clear_band_flags(rec_t *rec)                   /* 016558 */
{
    if (menu_level_or_list(rec) == 0) return;
    if (r1_set_89C4 & 0x02) band_sel = 0;                 /* 016566 */
    else                    key_consume();
}

/* @016574-016582 sub_16574 setup_toggle_89C3_b1 Inferred: if not at list level: toggle FF89C3.1 (sub_17788) */
void setup_toggle_89C3_b1(rec_t *rec)
{
    if (menu_level_or_list(rec) != 0) setup_toggle_89C3(1);
}

/* @016582-01658C sub_16582 setup_level_dispatch_1658C Confirmed: menu_dispatch_by_level(rec, tbl 0x01658C) */
void setup_level_dispatch_1658C(rec_t *rec) { menu_dispatch_by_level(rec, tbl_1658C); }

/* @016598-0165C0 sub_16598 setup_step_mode_low2 Inferred: wrap-steps the low 2 bits of rec+0x36 (F395 field) through AA56 (record 0x0165CC), keeping the high nibble; falls to the rts in sub_165C0 */
void setup_step_mode_low2(rec_t *rec)                     /* 016598 */
{
    dial_scratch = rec->mode36 & 0x03;
    dial_step_wrap_dirty(&rec_165CC);
    rec->mode36 = (rec->mode36 & 0xF0) | (dial_scratch & 0x03);
    /* NB: bits 2-3 of +0x36 are dropped by the 0xF0 mask (0165B6 and.b #0xF0) */
}

/* @0165C0-0165CC sub_165C0 setup_step_165D4 Confirmed: wrap-step record 0x0165D4 */
void setup_step_165D4(rec_t *rec) { dial_step_wrap_dirty(&rec_165D4); }

/* @0165D2-0165D4 sub_165D2 dial_81_nop Confirmed: screen 0x81 dial: empty */
void dial_81_nop(rec_t *rec) { }

/* @0165DA-0165F0 sub_165DA dial_33 Confirmed: screen 0x33: toggle FF89C3.6 (sub_17788); FF917C = 1 if 8EA6.0 */
void dial_33(rec_t *rec)
{
    setup_toggle_89C3(6);                               /* 0165DC jsr loc_17788 */
    if (slot_chk & 0x01) b_rec_dirty_917C = 1;
}

/* @0165F0-0165FC sub_165F0 dial_34 Confirmed: screen 0x34: toggle FF89C3.4 (sub_17788) and re-apply audio via sub_1E79C */
void dial_34(rec_t *rec) { setup_toggle_89C3(4); sub_1E79C(); }      /* 0165F0 */

/* @0165FC-016608 sub_165FC dial_35_fm_bandwidth Confirmed: FM BANDWIDTH (F321): rec+0x12 ^= 0x20 (doc 35: +0x12.5 is the F321 on/off) */
void dial_35_fm_bandwidth(rec_t *rec) { rec->flags12 ^= 0x20; }      /* 016600 bnot #5 */

/* @016608-016610 sub_16608 dial_36 Confirmed: screen 0x36: toggle FF89C0.1 (sub_17770) */
void dial_36(rec_t *rec) { setup_toggle_89C0(1); }

/* @016610-016618 sub_16610 dial_37_home_vfo Confirmed: HOME VFO (F386): toggle FF89C3.3 (sub_17788) */
void dial_37_home_vfo(rec_t *rec) { setup_toggle_89C3(3); }

/* @016618-016624 sub_16618 dial_3E Confirmed: screen 0x3E: wrap-step record 0x016624 (R1 n=0x87 FF89A7) */
void dial_3E(rec_t *rec) { dial_step_wrap_dirty(&rec_16624); }

/* @01662A-016642 sub_1662A apply_89A7_to_953F Confirmed: FF953F = tbl_16642[FF89A7] */
void apply_89A7_to_953F(void) { ui_953F = tbl_16642[r1_set_89A7]; }  /* 016634 */

/* @016648-016660 sub_16648 apply_89A7_to_958E Confirmed: FF958E = tbl_16660[FF89A7] */
void apply_89A7_to_958E(void) { ui_958E = tbl_16660[r1_set_89A7]; }  /* 016652 */

/* @016666-01666E sub_16666 dial_3F_language Confirmed: LANGUAGE (F315): toggle FF89C2.1 (sub_17780) */
void dial_3F_language(rec_t *rec) { setup_toggle_89C2(1); }

/* @01666E-016678 sub_1666E setup_level_dispatch_16678 Confirmed: menu_dispatch_by_level(rec, tbl 0x016678) (LAMP screen 0x40 field table, doc 49) */
void setup_level_dispatch_16678(rec_t *rec) { menu_dispatch_by_level(rec, tbl_16678); }

/* @016684-016696 sub_16684 lamp_key_field_step Confirmed: LAMP KEY field: wrap-step record 0x0166A4 (doc 49: {0..0x0A,&FF89AA}), AA30 |= 0x08 (apply lamp) */
void lamp_key_field_step(rec_t *rec)                      /* 016684 */
{
    dial_step_wrap_dirty(&rec_166A4);
    ui_flags |= 0x08;                                     /* 01668E bset #3 */
}

/* @016696-0166A4 sub_16696 lamp_toggle_89C5_b7 Confirmed: LAMP field: toggle FF89C5.7 (sub_17798), AA30 |= 0x08 */
void lamp_toggle_89C5_b7(rec_t *rec) { setup_toggle_89C5(7); ui_flags |= 0x08; }

/* @0166C0-0166D8 sub_166C0 dial_43_lock Confirmed: LOCK (F388): refused in node mode, else wrap-step record 0x0166D8 (R1 n=0x8B FF89AB) */
void dial_43_lock(rec_t *rec)
{
    if (node_mode) { key_consume(); return; }
    dial_step_wrap_dirty(&rec_166D8);
}

/* @0166DE-0166F2 sub_166DE dial_44_moni_tcall Confirmed: MONI/T-CALL (F389): refused in node mode, else toggle FF89C0.0 */
void dial_44_moni_tcall(rec_t *rec)
{
    if (node_mode) { key_consume(); return; }
    setup_toggle_89C0(0);
}

/* @0166F2-016710 sub_166F2 dial_45_mic_gain Confirmed: MIC GAIN (F326): only on screen 0x45 (label 016700 is the table target): clamp-step record 0x016710 (R1 n=0x8D FF89AD), then sub_34C58 pushes the gain */
void dial_45_mic_gain(rec_t *rec)                         /* 0166F2 */
{
    if (rec->screen != 0x45) { key_consume(); return; }
    dial_step_clamp(&rec_16710);                          /* 016700 */
    sub_34C58();                                          /* 01670A */
}

/* @016716-016722 sub_16716 dial_49 Confirmed: screen 0x49: wrap-step record 0x016722 (R1 n=0x8C) */
void dial_49(rec_t *rec) { dial_step_wrap_dirty(&rec_16722); }

/* @016728-016730 sub_16728 dial_4A_memory_write Confirmed: MEMORY WRITE (F335): toggle FF89C1.0 */
void dial_4A_memory_write(rec_t *rec) { setup_toggle_89C1(0); }

/* @016730-016738 sub_16730 dial_4B_memory_protect Confirmed: MEMORY PROTECT (F333): toggle FF89C1.2 */
void dial_4B_memory_protect(rec_t *rec) { setup_toggle_89C1(2); }

/* --------------------------------------------------------------------------
 * @016738-01676E sub_16738 dial_4C Inferred: screen 0x4C: toggle FF89BF.7 if rec[5]==5, or memory mode with channel class (tbl_3CF64[type] >= 0); else refuse
 * -------------------------------------------------------------------------- */
void dial_4C(rec_t *rec)                                  /* 016738 */
{
    u8 m = rec->vfo_mode;
    if (m != 5) {
        if (m != 2) goto refuse;
        u8 t = sub_3F1DC(rec);                            /* channel type */
        if (t != 0 && (s8)chan_class_3CF64[t] < 0) goto refuse;
    }
    r1_set_89BF ^= 0x80;  ui_flags |= 0x40;               /* 01675A */
    return;
refuse:
    key_consume();
}

/* @01676E-016784 sub_1676E setup_key_guard_16784 Inferred: if chan_is_type3 (sub_16784) is false -> refuse; else if sub_152F4 returns nonzero -> refuse (the key is swallowed either way) */
void setup_key_guard_16784(rec_t *rec)                    /* 01676E */
{
    if (!chan_is_type3(rec)) { key_consume(); return; }  /* 016770 bne */
    if (setup_key_level_ok(rec)) key_consume();           /* 016772 */
}

/* @016784-01679A sub_16784 chan_is_type3 Inferred: Z/true when rec[5]==5, or rec[5]!=2, or the memory channel type (sub_3F1DC) is 0 or 3 */
u8 chan_is_type3(rec_t *rec)                              /* 016784 */
{
    u8 m = rec->vfo_mode;
    if (m == 5 || m != 2) return 1;
    u8 t = sub_3F1DC(rec);
    return t == 0 || t == 3;
}

/* @01679A-0167C2 sub_1679A name_edit_key_done Inferred: level 0 -> refuse (sub_15E62); else commit the 16-char name (sub_167C2) and post key 6 to sub_19D22 */
void name_edit_key_done(rec_t *rec)                       /* 01679A */
{
    if (menu_level == 0) { setup_key_refuse(); return; }
    name_edit_commit(rec);                                /* 0167A6 */
    key_event = 6;
    sub_19D22(rec);
}

/* @0167C2-0167F0 sub_167C2 name_edit_commit Inferred: picks the name buffer (AA96 if page 94C1==5, else rec+0x22) and pads it via text_edit_backspace(len 0x10, base level 1) */
void name_edit_commit(rec_t *rec)                         /* 0167C2 */
{
    u8 *buf = (ui_page_94C1 == 5) ? name_buf_AA96 : &rec->name22[0];
    text_edit_backspace(rec, buf, buf + 0x12, 0x10, 1);   /* bsr sub_167F0 */
}

/* --------------------------------------------------------------------------
 * @0167F0-01682C sub_167F0 text_edit_backspace Confirmed: text editor delete-to-end: if level >= base, fill (len+base-level) bytes before er5 with 0xFF and clear the matching bits of the word *er2 using mask table 0x01682C[level-base]; then refresh. Level below base -> sub_14BBA (leave)
 * Args: er2 = buffer (its first word holds per-char flags), er5 = buffer+0x12,
 * r6l = length, r6h = first editable level.  Callers 0x0160B0, 0x016972, sub_167C2.
 * -------------------------------------------------------------------------- */
void text_edit_backspace(rec_t *rec, u8 *buf, u8 *end, u8 len, u8 base)  /* 0167F0 */
{
    if (menu_level < base) { menu_exit_all(rec); return; }   /* 016826 sub_14BBA */
    u8 n = len + base - menu_level;
    do { *--end = 0xFF; } while (--n);
    *(u16 *)buf &= mask_tbl_1682C[menu_level - base];     /* 016812 */
    text_edit_refresh();                                  /* 016820 sub_1611E */
}

/* @01684C-01685E sub_1684C dial_4E_mute Confirmed: MUTE (F327): wrap-step record 0x01685E (R1 n=0x93), A9E2 = 0 */
void dial_4E_mute(rec_t *rec) { dial_step_wrap_dirty(&rec_1685E); ui_A9E2 = 0; }

/* @016864-01686E sub_16864 setup_level_dispatch_1686E Confirmed: menu_dispatch_by_level(rec, tbl 0x01686E) */
void setup_level_dispatch_1686E(rec_t *rec) { menu_dispatch_by_level(rec, tbl_1686E); }

/* @0168B4-0168BC sub_168B4 setup_toggle_89C1_b6 Confirmed: toggle FF89C1.6; branches to the rts at 0x0168F8 */
void setup_toggle_89C1_b6(rec_t *rec) { setup_toggle_89C1(6); }

/* @0168F2-0168FA sub_168F2 setup_toggle_89C1_b7 Confirmed: toggle FF89C1.7 */
void setup_toggle_89C1_b7(rec_t *rec) { setup_toggle_89C1(7); }

/* --------------------------------------------------------------------------
 * @01690A-016936 sub_1690A setup_key_as_dial_16936 Confirmed: turns key 4 into a dial-up and other keys into dial-down (A9EE.0) and wrap-steps record 0x016936; refused while the ctx is live (AD9D)
 * Callers: sub_15BA6 (key 4).
 * -------------------------------------------------------------------------- */
void setup_key_as_dial_16936(rec_t *rec)                  /* 01690A */
{
    if (menu_ctx_live) { key_consume(); return; }
    key_flags &= ~0x01;                                   /* up */
    if (key_event != 4) key_flags |= 0x01;                /* down */
    dial_step_wrap(&rec_16936);
}

/* @01693C-01693E nullsub_79 setup_nop_1693C Confirmed: empty level-table slot */
void setup_nop_1693C(rec_t *rec) { }

/* @01693E-01695A sub_1693E setup_step_1695A_or_1A350 Inferred: level 1 -> wrap-step record 0x01695A; level 2+ -> sub_1A350 */
void setup_step_1695A_or_1A350(rec_t *rec)
{
    u8 lvl = menu_level_or_list(rec);
    if (lvl == 0) return;
    if (lvl == 1) dial_step_wrap_dirty(&rec_1695A);
    else          sub_1A350(rec);
}

/* @016960-01697E sub_16960 text_edit_bs_8956 Inferred: text_edit_backspace on the 16-char setting text FF8956, base level 2; label 0x016978 = sub_14BBA */
void text_edit_bs_8956(rec_t *rec) { text_edit_backspace(rec, r1_text_8956, r1_text_8956 + 0x12, 0x10, 2); }

/* --------------------------------------------------------------------------
 * @01697E-0169CC sub_1697E pager_code_dial Inferred: PAGER code editor: level 1 toggles FF89C3.2; levels 2/3 step one digit of the code pairs FF8968 / FF896A, skipping the value equal to the partner digit
 * Uses sub_15206 with callback sub_1A0B4.  AD9C selects which of the two
 * digits is edited (0 -> second, else first); the loop at 0169B2 re-steps
 * while the new digit equals the other one (codes must differ).
 * -------------------------------------------------------------------------- */
void pager_code_dial(rec_t *rec)                          /* 01697E */
{
    u8 lvl = menu_level_or_call(rec, sub_1A0B4);
    if (lvl == 0) return;
    if (lvl == 1) { setup_toggle_89C3(2); return; }       /* 0169C4 */
    u8 *p = (lvl == 2) ? &r1_set_8968 : &r1_set_896A;
    u8 other;
    if (nested_stage) other = *p++;  else other = p[1];   /* 0169A4 / 0169A8 */
    dial_scratch = *p;
    u8 v;
    do { v = dial_step_wrap_dirty(&rec_169CC); } while (v == other);
    *p = v;
}

/* @0169DC-0169EE sub_169DC setup_key_as_dial_169EE Confirmed: wrap-step record 0x0169EE (no dirty); label 0x0169E8 = key_consume */
void setup_key_as_dial_169EE(rec_t *rec) { dial_step_wrap(&rec_169EE); }

/* @0169F4-016A16 sub_169F4 pw_dial Inferred: PASSWORD editor dial: level 1 sets AA34.6 and toggles FF89C2.0 (password on/off); level 2+ steps digit AD88[level] (sub_16A16) */
void pw_dial(rec_t *rec)                                  /* 0169F4 */
{
    u8 lvl = menu_level_or_list(rec);
    if (lvl == 0) return;
    if (lvl != 1) { pw_step_digit(lvl); return; }
    ui_flags_AA34 |= 0x40;
    setup_toggle_89C2(0);                                 /* 016A0A */
}

/* @016A16-016A2E sub_16A16 pw_step_digit Confirmed: digit = AD88[idx] (-0x5278 = 0xFFAD88); negative -> 0, else wrap-step via AA56 (record 0x016A3E); falls into sub_16A2E */
void pw_step_digit(u8 idx)                                /* 016A16 */
{
    s8 d = (s8)pw_buf_AD88[idx];
    u8 v = 0;
    if (d >= 0) { dial_scratch = d; v = dial_step_wrap_dirty(&rec_16A3E); }
    pw_store_digit(idx, v);
}

/* @016A2E-016A3E sub_16A2E pw_store_digit Confirmed: AD88[idx] = v; AA34 |= 0x40; ui_mark_dirty() */
void pw_store_digit(u8 idx, u8 v) { pw_buf_AD88[idx] = v; ui_flags_AA34 |= 0x40; ui_mark_dirty(); }

/* @016A44-016A4C sub_16A44 pw_all_set Confirmed: r6l = 4, er5 = &AD8A, then falls into the scan: stops early (N set) at the first negative (unset) digit */
u8 pw_all_set(void) { return pw_scan_neg(pw_buf_AD88 + 2, 4); }

/* @016A4C-016A56 sub_16A4C pw_scan_neg Confirmed: loop: while n--, if (*p++ & 0x80) return 'incomplete'; else 'complete' (flags only) */
u8 pw_scan_neg(const u8 *p, u8 n)                         /* 016A4C */
{
    do { if ((s8)*p++ < 0) return 0; } while (--n);
    return 1;
}

/* @016A56-016A78 sub_16A56 pw_key_digit Inferred: digit key r4l: store at AD88[level]; while level < 5 post key 4 to sub_19E92 (advance cursor) */
void pw_key_digit(rec_t *rec, u8 digit)                   /* 016A56 */
{
    pw_store_digit(menu_level, digit);
    if (menu_level < 5) { key_event = 4; sub_19E92(rec); }
}

/* @016A78-016A84 sub_16A78 dial_56_ptt_delay Confirmed: PTT DELAY (F38C): wrap-step record 0x016A84 (R1 n=0x90 FF89B0) */
void dial_56_ptt_delay(rec_t *rec) { dial_step_wrap_dirty(&rec_16A84); }

/* @016A8A-016A92 sub_16A8A dial_57_priority_revert Confirmed: PRIORITY REVERT (F355): toggle FF89C3.0 */
void dial_57_priority_revert(rec_t *rec) { setup_toggle_89C3(0); }

/* @016A92-016A9E sub_16A92 dial_58_dw_time Confirmed: DW TIME (F350): wrap-step record 0x016A9E (R1 n=0x8F) */
void dial_58_dw_time(rec_t *rec) { dial_step_wrap_dirty(&rec_16A9E); }

/* @016AA4-016AAE sub_16AA4 setup_level_dispatch_16AAE Confirmed: menu_dispatch_by_level(rec, tbl 0x016AAE) (fields incl. 0x016AD0, doc 117) */
void setup_level_dispatch_16AAE(rec_t *rec) { menu_dispatch_by_level(rec, tbl_16AAE); }

/* @016B02-016B0C sub_16B02 setup_level_dispatch_16B0C Confirmed: menu_dispatch_by_level(rec, tbl 0x016B0C) */
void setup_level_dispatch_16B0C(rec_t *rec) { menu_dispatch_by_level(rec, tbl_16B0C); }

/* @016B18-016B24 sub_16B18 setup_step_16B30 Confirmed: wrap-step record 0x016B30 */
void setup_step_16B30(rec_t *rec) { dial_step_wrap_dirty(&rec_16B30); }

/* @016B24-016B30 sub_16B24 setup_step_16B36 Confirmed: wrap-step record 0x016B36 */
void setup_step_16B36(rec_t *rec) { dial_step_wrap_dirty(&rec_16B36); }

/* @016B3C-016B48 sub_16B3C dial_5B_scan_restart Confirmed: SCAN RE-START (F352): wrap-step record 0x016B48 (R1 n=0x92) */
void dial_5B_scan_restart(rec_t *rec) { dial_step_wrap_dirty(&rec_16B48); }

/* @016B4E-016B5A sub_16B4E dial_5C_hidden Confirmed: dead hidden item 0x5C (doc 49 sec.2): wrap-step {0,3,&FF89B6} at 0x016B5A */
void dial_5C_hidden(rec_t *rec) { dial_step_wrap_dirty(&rec_16B5A); }

/* @016B60-016B78 sub_16B60 dial_5D_sql_smeter Confirmed: SQL S-METER (F348): clamp-step rec+0x37 via AA56 (record 0x016B78) */
void dial_5D_sql_smeter(rec_t *rec)
{
    dial_scratch = rec->sql_s37;
    rec->sql_s37 = dial_step_clamp(&rec_16B78);           /* r3l is the new value */
}

/* @016B7E-016BBA sub_16B7E dial_5E_rpt_shift Confirmed: RPT SHIFT (F38E): refused when rec+0x15==3; wrap-step it via AA56 (record 0x016BBA); if the keep-shift flag rec+0x46.0 was set, clear it and recompute the TX offset (sub_1C050) */
void dial_5E_rpt_shift(rec_t *rec)                        /* 016B7E */
{
    if (rec->shift15 == 3) { key_consume(); return; }
    dial_scratch = rec->shift15;
    rec->shift15 = dial_step_wrap_dirty(&rec_16BBA);
    if (rec->f46 & 0x01) { rec->f46 &= ~0x01; sub_1C050(rec); }
}

/* --------------------------------------------------------------------------
 * @016BC0-016C1A sub_16BC0 dial_5F_rx_mode Confirmed: RX MODE (F322): steps rec+0x19 via record 0x016C1A; reaching 2 (AM) sets the fixed-AM gate +0x39.3 and calls sub_1E63E; with the gate set, the next step clears it and lands on 0 (up) / 1 (down)
 * Refused for the B-slot record.  Ends with dirty + sub_1C050.
 * -------------------------------------------------------------------------- */
void dial_5F_rx_mode(rec_t *rec)                          /* 016BC0 */
{
    if (!rec_is_not_b_slot(rec)) return;
    if (!(rec->gate39 & 0x08)) {
        dial_scratch = rec->rxmode19;
        u8 v = dial_step_wrap_dirty(&rec_16C1A);
        if (v == 2) { rec->gate39 |= 0x08; sub_1E63E(rec); goto done; }
        rec->rxmode19 = v;
    } else {
        rec->gate39 &= ~0x08;
        rec->rxmode19 = (key_flags & 0x01) ? 1 : 0;
    }
done:
    ui_flags |= 0x40;
    sub_1C050(rec);
}

/* @016C20-016C36 sub_16C20 dial_60_save_rx Confirmed: SAVE RX (F390): refused in node mode; wrap-step record 0x016C40 (R1 n=0x91) then falls into sub_16C36 */
void dial_60_save_rx(rec_t *rec)
{
    if (node_mode) { key_consume(); return; }
    u8 v = dial_step_wrap_dirty(&rec_16C40);
    save_rx_apply(v);
}

/* @016C36-016C40 sub_16C36 save_rx_apply Confirmed: if the new SAVE RX value is 0 (OFF) call sub_3411E */
void save_rx_apply(u8 v) { if (v == 0) sub_3411E(); }

/* @016C46-016C4E sub_16C46 dial_61 Confirmed: screen 0x61: toggle FF89C0.5 */
void dial_61(rec_t *rec) { setup_toggle_89C0(5); }

/* @016C4E-016C56 sub_16C4E dial_62_scan_lamp Confirmed: SCAN LAMP (F351): toggle FF89BE.5 */
void dial_62_scan_lamp(rec_t *rec) { setup_toggle_89BE(5); }

/* @016C56-016C80 sub_16C56 shift_freq_key_coarse Inferred: in the RPT SHIFT FREQ editor toggles the coarse/fine step flag AA31.2; refused at level 0, with keep-shift set, or shift==3 */
void shift_freq_key_coarse(rec_t *rec)                    /* 016C56 */
{
    if (menu_level == 0) { setup_key_refuse(); return; }
    if ((rec->f46 & 0x01) || rec->shift15 == 3) { key_consume(); return; }
    ui_flags_AA31 ^= 0x04;
}

/* --------------------------------------------------------------------------
 * @016C80-016D08 sub_16C80 dial_63_rpt_shift_freq Confirmed: RPT SHIFT FREQ (F38F): steps the 4-byte offset at rec+0x1E with wrap between the ROM limits K_LO (0x016D08) / K_HI (0x016D0C) and the alternate value at 0x016D14
 * Down at K_LO -> K_ALT (0x16D14), then K_HI unless coarse (AA31.2);
 * up at K_HI -> K_LO; otherwise fine step (sub_16D1C) or coarse step
 * (sub_16D3E).  Refused while keep-shift (+0x46.0) is set or shift==3.
 * -------------------------------------------------------------------------- */
void dial_63_rpt_shift_freq(rec_t *rec)                   /* 016C80 */
{
    if ((rec->f46 & 0x01) || rec->shift15 == 3) { key_consume(); return; }
    if (key_flags & 0x01) {                               /* down */
        if (rec->ofs1E == K_16D08) {
            rec->ofs1E = K_16D14;
            if (!(ui_flags_AA31 & 0x04)) rec->ofs1E = K_16D0C;
            return;
        }
    } else {
        if (rec->ofs1E == K_16D0C) { rec->ofs1E = K_16D08; return; }
    }
    if (ui_flags_AA31 & 0x04) shift_step_coarse(rec);     /* sub_16D3E */
    else                      shift_step_fine(rec);       /* sub_16D1C */
}

/* @016D1C-016D3E sub_16D1C shift_step_fine Confirmed: BCD add (sub_3F924, up) or subtract (sub_3F94C, down) the step constant at 0x01DE3C to the 4-byte offset rec+0x1E */
void shift_step_fine(rec_t *rec)
{
    if (key_flags & 0x01) bcd4_sub(&rec->ofs1E, &K_1DE3C);
    else                  bcd4_add(&rec->ofs1E, &K_1DE3C);
}

/* --------------------------------------------------------------------------
 * @016D3E-016DB4 sub_16D3E shift_step_coarse Confirmed: coarse (MHz) step of the offset using constant 0x01DE4C, clamping to the K_LO/K_HI limits via sub_16DB4 (which keeps the low nibble of +0x1F)
 * -------------------------------------------------------------------------- */
void shift_step_coarse(rec_t *rec)                        /* 016D3E */
{
    if (key_flags & 0x01) {                               /* down */
        if (rec->ofs1E < K_1DE4C) {                       /* would underflow */
            shift_set_keep_fine(rec, &K_16D0C);           /* bsr sub_16DB4 */
            if (K_16D0C >= rec->ofs1E) return;
        }
        bcd4_sub(&rec->ofs1E, &K_1DE4C);
    } else {
        bcd4_add(&rec->ofs1E, &K_1DE4C);
        if (K_16D0C < rec->ofs1E) shift_set_keep_fine(rec, &K_16D08);
    }
}

/* @016DB4-016DC6 sub_16DB4 shift_set_keep_fine Confirmed: word rec+0x1E = (word *er5 & 0xFFF0) | (rec+0x1F & 0x0F) */
void shift_set_keep_fine(rec_t *rec, const u32 *lim)      /* 016DB4 */
{
    u16 w = *(const u16 *)lim;
    w = (w & 0xFFF0) | (((u8 *)rec)[0x1F] & 0x0F);
    *(u16 *)&((u8 *)rec)[0x1E] = w;
}

/* @016DC6-016DCA sub_16DC6 dial_64_memory_skip Confirmed: MEMORY SKIP (F334): if mem_skip_refused (sub_16E1A) -> return; else falls into sub_16DCA */
void dial_64_memory_skip(rec_t *rec)
{
    if (mem_skip_refused(rec)) return;
    mem_skip_step(rec);
}

/* --------------------------------------------------------------------------
 * @016DCA-016E1A sub_16DCA mem_skip_step Confirmed: cycles rec+7 bits 2-3 OFF(0) -> 4 -> 8 -> OFF (down: OFF -> 8 -> 4 -> OFF); re-stores the channel attribute (sub_3F21A/sub_3A892) and for channel numbers 1000..1099 calls sub_3298A
 * -------------------------------------------------------------------------- */
void mem_skip_step(rec_t *rec)                            /* 016DCA */
{
    u8 cur = rec->f07 & 0x0C, up, dn;
    if (cur == 0)      { up = 4; dn = 8; }
    else if (cur == 4) { up = 8; dn = 0; }
    else               { up = 0; dn = 4; }
    u8 nv = (key_flags & 0x01) ? dn : up;
    rec->f07 = (rec->f07 & 0xF3) | nv;
    u16 ch = sub_3F21A(rec);                              /* channel number in r3 */
    sub_3A892(rec->f07);                                  /* store attribute */
    if (ch >= 0x3E8 && ch < 0x44C) sub_3298A();           /* 016E08 */
}

/* @016E1A-016E4E sub_16E1A mem_skip_refused Confirmed: returns 1 (+key_consume) unless memory mode and channel type not 6/8; type-0 channels 900..999 are refused too */
u8 mem_skip_refused(rec_t *rec)                           /* 016E1A */
{
    if (rec->vfo_mode != 2) goto no;
    u8 t = sub_3F1DC(rec);
    if (t == 6 || t == 8) goto no;
    if (t == 0) {
        u16 ch = sub_3F21A(rec);
        if (ch >= 0x384 && ch < 0x3E8) goto no;
    }
    return 0;
no:
    key_consume();
    return 1;
}

/* @016E4E-016E5A sub_16E4E dial_65 Confirmed: screen 0x65: wrap-step record 0x016E5A (R1 n=0x97) */
void dial_65(rec_t *rec) { dial_step_wrap_dirty(&rec_16E5A); }

/* @016E60-016E6C sub_16E60 setup_refuse_unless_list Confirmed: if not at list level -> key_consume */
void setup_refuse_unless_list(rec_t *rec) { if (menu_level_or_list(rec)) key_consume(); }

/* @016E6C-016E78 sub_16E6C setup_step_16E78 Confirmed: wrap-step record 0x016E78 */
void setup_step_16E78(rec_t *rec) { dial_step_wrap_dirty(&rec_16E78); }

/* @016E7E-016E86 sub_16E7E dial_67 Confirmed: screen 0x67: toggle FF89C4.0 (sub_17790; doc 35 lists no individual b0 user - this is one) */
void dial_67(rec_t *rec) { setup_toggle_89C4(0); }

/* @016E86-016E9E sub_16E86 dial_69 Confirmed: screen 0x69: wrap-step record 0x016E9E; if previous screen (rec[0]) is 0x0B call sub_24D42 */
void dial_69(rec_t *rec)
{
    dial_step_wrap_dirty(&rec_16E9E);
    if (rec->prev_screen == 0x0B) sub_24D42();
}

/* @016EA4-016EBE sub_16EA4 dial_68_band_scope Confirmed: BAND SCOPE (F313): wrap-step record 0x016EBE (R1 n=0x99); if previous screen is 0x0B set AFF1.0 (re-push request seen in sub_14BBC) */
void dial_68_band_scope(rec_t *rec)
{
    dial_step_wrap_dirty(&rec_16EBE);
    if (rec->prev_screen == 0x0B) ui_AFF1 |= 0x01;
}

/* @016EC4-016ECC sub_16EC4 dial_6A_sql_expansion Confirmed: SQL EXPANSION (F349): toggle FF89BE.1 */
void dial_6A_sql_expansion(rec_t *rec) { setup_toggle_89BE(1); }

/* @016ECC-016EDC sub_16ECC sql_level_frag_a Confirmed: duplicate head of sub_16EE8 (B-slot -> loc_16EDE, band B -> loc_16EFA); falls into sub_16EDC */

/* @016EDC-016EDE sub_16EDC sql_level_frag_b Confirmed: bra loc_16F16 (band-A squelch step) */

/* @016EE4-016EE8 sub_16EE4 sql_level_frag_c Confirmed: beq loc_16F58 / bra loc_16F46 (B-slot AM / FM squelch step) */
#define sql_level_frag_a(rec)  dial_6B_sql_level(rec)
#define sql_level_frag_b(rec)  sql_level_step_a(rec)
#define sql_level_frag_c(rec)  sql_level_step_bslot(rec)

/* --------------------------------------------------------------------------
 * @016EE8-016F64 sub_16EE8 dial_6B_sql_level Confirmed: SQL LEVEL (F347): clamp-steps the squelch level of the active band
 * Band A -> record 0x016F64 (FF8970), band B -> 0x016F6A (FF8971); when
 * FF8EA0.4 is set the new value is mirrored to the other band.  The B-slot
 * record (FF90F0) uses 0x016F76 (clears AA37.6) or, for AM (+0x19==2),
 * 0x016F7C.  Label 0x016F32 (record 0x016F70) is an unreached alternative.
 * -------------------------------------------------------------------------- */
void dial_6B_sql_level(rec_t *rec)                        /* 016EE8 */
{
    if (rec == REC_B_SLOT) {                              /* 016F3E */
        if (rec->rxmode19 == 2) dial_step_clamp(&rec_16F7C);
        else { dial_step_clamp(&rec_16F76); ui_flags_AA37 &= ~0x40; }
        return;
    }
    if (band_sel & 0x40) {
        dial_step_clamp(&rec_16F6A);
        if (band_sel & 0x10) r1_sql_8970 = r1_sql_8971;
    } else {
        dial_step_clamp(&rec_16F64);
        if (band_sel & 0x10) r1_sql_8971 = r1_sql_8970;
    }
}

/* --------------------------------------------------------------------------
 * @016F82-016FFE sub_16F82 dial_6C_sql_type Confirmed: SQL TYPE (F34A): steps rec+0x16 over the squelch types (record 0x016FFE, or 0x017004 when SQL EXPANSION FF89BE.1 is on), skipping 8, skipping 5 when sub_3ECB8 says so, and >= 9 without expansion; then requests reprogram code 3 in rec+0x8C
 * -------------------------------------------------------------------------- */
void dial_6C_sql_type(rec_t *rec)                         /* 016F82 */
{
    if (!rec_is_not_b_slot(rec)) return;
    dial_scratch = rec->sqltype16;
    const step_rec_t *r = (r1_set_89BE & 0x02) ? &rec_17004 : &rec_16FFE;
    u8 v;
    for (;;) {
        v = dial_step_wrap_dirty(r);
        if (v == 8) continue;
        if (sub_3ECB8() && v == 5) continue;
        if (!(r1_set_89BE & 0x02) && v >= 9) continue;
        break;
    }
    rec->sqltype16 = v;
    rec_request_reprogram(rec, 3);                        /* 016FC6..016FF2, same gate as sub_16152 */
}

/* --------------------------------------------------------------------------
 * @01700A-0170F8 sub_1700A dial_6D_step Confirmed: STEP (F391): steps the tuning-step index rec+0x14; reaching index 0x0A (or 0x0B on the rec[4]==0 path) turns on the fixed-step gate +0x39.4 (sub_1E6D4) and leaving it clears the gate
 * Refused when rec[5]==4 and either word +0x3C or +0x40 is nonzero.  Sets
 * +0x12.6 (custom step valid) and dirty.  rec[4]!=0 uses table 0x0170F8
 * (index 2 skipped unless rec[4]==5); rec[4]==0 uses 0x0170FE and only
 * stops on 3, 0x0A or 0x0B.  Exit through sub_3F3B4 on the rec[4]==0 path.
 * (doc 35: +0x39.4 = FIXED-STEP flag.)
 * -------------------------------------------------------------------------- */
void dial_6D_step(rec_t *rec)                             /* 01700A */
{
    if (rec->vfo_mode == 4 && (rec->w3C != 0 || rec->w40 != 0)) { key_consume(); return; }
    dial_scratch = rec->step14;
    rec->flags12 |= 0x40;  ui_flags |= 0x40;
    u8 v;
    if (rec->band04 != 0) {
        if (!(rec->gate39 & 0x10)) {
            do { v = dial_step_wrap_dirty(&rec_170F8); }
            while (rec->band04 != 5 && v == 2);
            if (v == 0x0A) { rec->gate39 |= 0x10; sub_1E6D4(rec); }
        } else {
            rec->gate39 &= ~0x10;
            v = (key_flags & 0x01) ? 9 : 0;
        }
        rec->step14 = v;
        return;
    }
    if (!(rec->gate39 & 0x10)) {
        for (;;) {
            v = dial_step_wrap_dirty(&rec_170FE);
            if (v == 3 || v == 0x0A) goto out;            /* not stored to +0x14 here */
            if (v == 0x0B) break;
        }
        rec->gate39 |= 0x10;  sub_1E6D4(rec);
    } else {
        rec->gate39 &= ~0x10;
        v = (key_flags & 0x01) ? 0x0A : 3;
    }
    rec->step14 = v;
out:
    sub_3F3B4(rec);
}

/* @017104-017120 sub_17104 dial_6E Confirmed: screen 0x6E: toggle FF89C3.7; if the B record is in use (8EA6.0) and AA37.2, call nullsub_30 */
void dial_6E(rec_t *rec)
{
    setup_toggle_89C3(7);
    if ((slot_chk & 0x01) && (ui_flags_AA37 & 0x04)) nullsub_30();
}

/* @017134-017140 sub_17134 dial_6F_rx_af_dual Confirmed: RX AF DUAL (F328): wrap-step record 0x017140 (R1 n=0x72 FF8992) */
void dial_6F_rx_af_dual(rec_t *rec) { dial_step_wrap_dirty(&rec_17140); }

/* --------------------------------------------------------------------------
 * @017146-017174 sub_17146 date_time_dial Inferred: DATE & TIME ADJ editor dial: level 7 refused, level 6 toggles FF89C2.6 (12/24h), other levels BCD-step one clock field of the edit image FFA9CC with per-level limits (tables 0x0171BC / 0x0171B4)
 * -------------------------------------------------------------------------- */
void date_time_dial(rec_t *rec)                           /* 017146 */
{
    u8 lvl = menu_level_or_list(rec);
    if (lvl == 0) return;
    if (lvl == 7) { key_consume(); return; }
    if (lvl == 6) { setup_toggle_89C2(6); return; }       /* sub_17180 */
    u16 lim = dt_limits_171BC[lvl];                       /* hi byte = min, lo byte = max */
    u8 idx  = dt_index_171B4[lvl];
    rtc_edit_A9CC[idx] = bcd_step_wrap(rtc_edit_A9CC[idx], lim >> 8, lim & 0xFF);
}

/* @017180-01718E sub_17180 date_time_toggle_12h Confirmed: toggle FF89C2.6; label 0x017188 = key_consume */
void date_time_toggle_12h(rec_t *rec) { setup_toggle_89C2(6); }

/* @01718E-0171B4 sub_1718E bcd_step_wrap Confirmed: packed-BCD +1 (daa) up to max then wrap to min, or -1 (das) down to min then wrap to max; direction from A9EE.0 */
u8 bcd_step_wrap(u8 v, u8 min, u8 max)                    /* 01718E */
{
    if (!(key_flags & 0x01)) return (v == max) ? min : bcd_inc(v);
    else                     return (v == min) ? max : bcd_dec(v);
}

/* @0171D2-0171FC sub_171D2 date_time_commit Inferred: validate/convert the 7-byte edit image (sub_3E90A, r2l=0x64), leave the editor (AD68 = 0, 8EDE = 0) and write the clock from A9C4 (sub_3E828); label 0x0171F6 = key_consume */
void date_time_commit(rec_t *rec)                         /* 0171D2 */
{
    sub_3E90A(rtc_edit_A9CC, 7, 0x64);
    menu_level = 0;  ui_8EDE = 0;
    sub_3E828(rtc_A9C4);
}

/* @0171FC-017210 sub_171FC setup_step_rec17_nodirty Inferred: wrap-step rec+0x17 (record 0x017264) without dirty, then joins sub_17210 at loc_17222 */
void setup_step_rec17_nodirty(rec_t *rec)
{
    dial_scratch = rec->f17;
    rec17_store_and_request(rec, dial_step_wrap(&rec_17264));
}

/* --------------------------------------------------------------------------
 * @017210-017264 sub_17210 setup_step_rec17 Inferred: wrap-step rec+0x17 (record 0x017264, the tone-frequency index); then unless +0x8C is 1/2/6/7 or comm mode 1, request reprogram 4 in rec+0x8C, or via AACF while transmitting (94C0 != 0)
 * -------------------------------------------------------------------------- */
void setup_step_rec17(rec_t *rec)                         /* 017210 */
{
    dial_scratch = rec->f17;
    rec17_store_and_request(rec, dial_step_wrap_dirty(&rec_17264));
}
static void rec17_store_and_request(rec_t *rec, u8 v)     /* 017222 */
{
    rec->f17 = v;
    u8 m = rec->f8C;
    if (m == 1 || m == 2 || m == 6 || m == 7) return;
    if (((band_sel & 0x40) ? comm_mode_b : comm_mode_a) == 1) return;
    if (tx_state == 0) rec->f8C = 4;                      /* 017258 */
    else               tx_req_flag = 4;                   /* 01725E AACF */
}

/* --------------------------------------------------------------------------
 * @01726A-0172BC sub_1726A tone_freq_dial Inferred: dial in TONE / DCS screens: while a tone search runs on the band (8FE2 / 90EA) the dial only sets the search direction rec+0x5A.0 = A9EE.0; otherwise steps DCS code (+0x18, screen 0x26) or tone freq (+0x17)
 * -------------------------------------------------------------------------- */
void tone_freq_dial(rec_t *rec)                           /* 01726A */
{
    if (menu_level_or_list(rec) == 0) return;
    u8 searching = (band_sel & 0x40) ? tsearch_b_active : tsearch_a_active;  /* 90EA / 8FE2 */
    if (searching) {
        rec->f5A = (rec->f5A & ~0x01) | (key_flags & 0x01);   /* bld/bst #0 */
        return;
    }
    if (rec->screen == 0x26) setup_step_rec18(rec);       /* DCS CODE -> sub_16152 */
    else                     setup_step_rec17(rec);       /* sub_17210 */
}

/* @0172BC-0172F4 sub_172BC tone_search_key_back Inferred: level 0 -> ui_pop_screen; running search -> state 3 (stop) on that band (90E8 / 8FE0); else sub_2244C */
void tone_search_key_back(rec_t *rec)                     /* 0172BC */
{
    if (menu_level == 0) { ui_pop_screen(rec); return; }
    if (band_sel & 0x40) { if (tsearch_b_active) { tsearch_b_state = 3; return; } }
    else                 { if (tsearch_a_active) { tsearch_a_state = 3; return; } }
    sub_2244C(rec);
}

/* --------------------------------------------------------------------------
 * @0172F4-01734A sub_172F4 tone_search_start Inferred: start (or stop) the tone/DCS search when the band's SQL type (sub_3EF2E) equals the screen's type: r2l = 2 at 0x0172F4, 3 at label 0x0172F8; state := running ? 3 : 1, 8FE1 := 2
 * -------------------------------------------------------------------------- */
void tone_search_start(rec_t *rec, u8 want_type /*2 or 3*/)   /* 0172F4 / 0172F8 */
{
    if (menu_level == 0 || sub_3EF2E(rec) != want_type) { key_consume(); return; }
    u8 running = (band_sel & 0x40) ? tsearch_b_active : tsearch_a_active;
    u8 st = running ? 3 : 1;
    if (band_sel & 0x40) tsearch_b_state = st; else tsearch_a_state = st;
    tsearch_8FE1 = 2;                                     /* both paths write 8FE1 */
}

/* @01734A-017394 sub_1734A tone_search_key_digit Inferred: on sub-page 2, the key that opened it (AD6B == A9F0) stops a running search (state 3) or falls back to sub_148E6 */
void tone_search_key_digit(rec_t *rec)                    /* 01734A */
{
    if (menu_level == 0 || menu_subpage != 2 || key_digit != subpage_key_AD6B) { key_consume(); return; }
    if (band_sel & 0x40) { if (tsearch_b_active) { tsearch_b_state = 3; return; } }
    else                 { if (tsearch_a_active) { tsearch_a_state = 3; return; } }
    sub_148E6(rec);
}

/* @017394-0173AC sub_17394 dial_73_tot Confirmed: TOT (F393): refused in node mode, else wrap-step record 0x0173AC (R1 n=0x9A FF89BA) */
void dial_73_tot(rec_t *rec)
{
    if (node_mode) { key_consume(); return; }
    dial_step_wrap_dirty(&rec_173AC);
}

/* @0173B2-0173D2 sub_173B2 setup_toggle_89BE4_89BF6 Inferred: via sub_15206 (callback sub_1A0AC): level 2 toggles FF89BE.4, other levels FF89BF.6 */
void setup_toggle_89BE4_89BF6(rec_t *rec)
{
    u8 lvl = menu_level_or_call(rec, sub_1A0AC);
    if (lvl == 0) return;
    if (lvl == 2) setup_toggle_89BE(4); else setup_toggle_89BF(6);
}

/* @0173D2-0173D4 sub_173D2 dial_77_nop Confirmed: screen 0x77 dial: empty */
void dial_77_nop(rec_t *rec) { }

/* @0173D4-0173DC sub_173D4 dial_78 Confirmed: screen 0x78: toggle FF89BF.0 */
void dial_78(rec_t *rec) { setup_toggle_89BF(0); }

/* @0173DC-0173E4 sub_173DC dial_7A_vfo_mode Confirmed: VFO MODE (F394): toggle FF89BE.7 */
void dial_7A_vfo_mode(rec_t *rec) { setup_toggle_89BE(7); }

/* @0173E4-0173EC sub_173E4 dial_7B Confirmed: screen 0x7B: toggle FF89C2.7 */
void dial_7B(rec_t *rec) { setup_toggle_89C2(7); }

/* @0173EC-017400 sub_173EC setup_key_vfo_only_19F82 Inferred: only in VFO mode (rec[5]==1) call sub_19F82, else refuse */
void setup_key_vfo_only_19F82(rec_t *rec)
{
    if (rec->vfo_mode == 1) sub_19F82(rec); else key_consume();
}

/* --------------------------------------------------------------------------
 * @017400-017476 sub_17400 band_skip_dial Inferred: screen 0x79 editor: level 1 runs sub_1C394 (A) / sub_1C498 (B-slot); deeper levels toggle the bit for band rec[3] in the word AD92 (copy of FF898C), refusing the current band (AD94) and refusing to set every bit of the slot's mask (0x0FE6 for A, 0x0019 for the B slot)
 * Only valid in VFO mode (rec[5]==1).  The entry hook (sub_15CCE case 0x79)
 * loads AD94 = rec[3] and AD92 = FF898C.  -0x526E = 0xFFAD92.
 * -------------------------------------------------------------------------- */
void band_skip_dial(rec_t *rec)                           /* 017400 */
{
    u8 lvl = menu_level_or_list(rec);
    if (lvl == 0) return;
    if (rec->vfo_mode != 1) goto refuse;
    if (lvl == 1) {
        if (rec == REC_B_SLOT) sub_1C498(rec); else sub_1C394(rec);
        return;
    }
    if (rec->band03 == ui_AD94) goto refuse;
    u16 off; u8 bit;
    chan_bitpos(rec->band03, &off, &bit);                 /* 01741E */
    u16 old = ui_AD92;
    ((u8 *)&ui_AD92)[off] ^= (u8)(1u << bit);
    u16 mask = (rec == REC_B_SLOT) ? 0x0019 : 0x0FE6;
    if ((ui_AD92 & mask) == mask) { ui_AD92 = old; goto refuse; }
    r1_set_898C_w = ui_AD92;
    ui_mark_dirty();
    return;
refuse:
    key_consume();
}

/* @017488-01749E sub_17488 dial_84_compass Confirmed: COMPASS (F312): toggle R2 FF8ABE.7, 9D2E = 0xFFFF (force heading redraw), dirty */
void dial_84_compass(rec_t *rec)
{
    r2_set_8ABE ^= 0x80;
    heading_cache_9D2E = 0xFFFF;
    ui_flags |= 0x40;
}

/* @0174D0-0174DA sub_174D0 setup_level_dispatch_174DA Confirmed: menu_dispatch_by_level(rec, tbl 0x0174DA) */
void setup_level_dispatch_174DA(rec_t *rec) { menu_dispatch_by_level(rec, tbl_174DA); }

/* @0174EA-0174F6 sub_174EA setup_step_1750A Confirmed: wrap-step record 0x01750A (level-table slot) */
void setup_step_1750A(rec_t *rec) { dial_step_wrap_dirty(&rec_1750A); }

/* @0174F6-017502 sub_174F6 setup_step_17510 Confirmed: wrap-step record 0x017510 */
void setup_step_17510(rec_t *rec) { dial_step_wrap_dirty(&rec_17510); }

/* @017502-01750A sub_17502 setup_toggle_89C5_b1 Confirmed: toggle FF89C5.1 */
void setup_toggle_89C5_b1(rec_t *rec) { setup_toggle_89C5(1); }

/* @017516-017518 sub_17516 setup_exit_jump_17516 Confirmed: bra sub_1752A */

/* @01752A-017530 sub_1752A setup_exit_all_1752A Confirmed: menu_exit_all (sub_14BBA) */
void setup_exit_all_1752A(rec_t *rec) { menu_exit_all(rec); }
#define setup_exit_jump_17516(rec) setup_exit_all_1752A(rec)

/* @01758E-01759A sub_1758E setup_clear_BA33_1A0A4 Inferred: BA33 = 0; sub_1A0A4 */
void setup_clear_BA33_1A0A4(rec_t *rec) { ui_BA33 = 0; sub_1A0A4(rec); }

/* @01759A-0175C8 sub_1759A dial_8B_gps_log Confirmed: GPS LOG (F385): refused in node mode; wrap-step record 0x0175C8 (R1 n=0xB0 FF89D0); when it becomes OFF, or BA3E is clear, call 0x047210 (log restart/stop) */
void dial_8B_gps_log(rec_t *rec)
{
    if (node_mode) { key_consume(); return; }
    dial_step_wrap_dirty(&rec_175C8);
    if (r1_set_89D0 == 0 || ui_BA3E == 0) gps_log_47210();
}

/* @0175CE-017614 sub_175CE dial_7F_pr_frequency Confirmed: PR FREQUENCY (F346): wrap-step rec+0x34 (record 0x017614), then sub_1C050 unless +0x8C is 1/2/6/7 or comm mode 1 */
void dial_7F_pr_frequency(rec_t *rec)
{
    dial_scratch = rec->pr34;
    rec->pr34 = dial_step_wrap_dirty(&rec_17614);
    u8 m = rec->f8C;
    if (m == 1 || m == 2 || m == 6 || m == 7) return;
    if (((band_sel & 0x40) ? comm_mode_b : comm_mode_a) == 1) return;
    sub_1C050(rec);
}

/* @01761A-017622 sub_1761A dial_8E_target_location Confirmed: TARGET LOCATION (F311): toggle FF89C5.0 */
void dial_8E_target_location(rec_t *rec) { setup_toggle_89C5(0); }

/* @017622-01762E sub_17622 dial_8F_wx_alert Confirmed: WX ALERT (F34D): toggle FF89C2.4, then sub_1C050 */
void dial_8F_wx_alert(rec_t *rec) { setup_toggle_89C2(4); sub_1C050(rec); }

/* @01762E-01766A sub_1762E dial_D4 Confirmed: screen 0xD4 (doc 80): only with B record + AA37.2: wrap-step FF89B4 bits 4-6 via AA56 (record 0x01766A), apply hook nullsub_30 */
void dial_D4(rec_t *rec)
{
    if (!((slot_chk & 0x01) && (ui_flags_AA37 & 0x04))) { key_consume(); return; }
    dial_scratch = get_89B4_hi();
    u8 v = dial_step_wrap_dirty(&rec_1766A);
    r1_set_89B4 = (r1_set_89B4 & 0x07) | (u8)(v << 4);
    nullsub_30();
}

/* @017670-01767E sub_17670 get_89B4_hi Confirmed: return (FF89B4 & 0x70) >> 4 (in r5) */
u8 get_89B4_hi(void) { return (r1_set_89B4 & 0x70) >> 4; }

/* @01767E-0176A0 sub_1767E dial_D5 Confirmed: screen 0xD5: wrap-step FF89B4 bits 0-2 (record 0x0176A0), apply hook nullsub_30 */
void dial_D5(rec_t *rec)
{
    dial_scratch = get_89B4_lo();
    u8 v = dial_step_wrap_dirty(&rec_176A0);
    r1_set_89B4 = (r1_set_89B4 & 0x70) | v;
    nullsub_30();
}

/* @0176A6-0176B0 sub_176A6 get_89B4_lo Confirmed: return FF89B4 & 7 */
u8 get_89B4_lo(void) { return r1_set_89B4 & 0x07; }

/* --------------------------------------------------------------------------
 * @0176B0-01770C sub_176B0 setup_step_898E Inferred: steps the word setting FF898E by 8 in 0..0x7F8 with wrap; when FF89C6&0x7F == 0x29 and BA35 is set, steps through sub_3F6F2 (record 0x01770C) instead
 * -------------------------------------------------------------------------- */
void setup_step_898E(rec_t *rec)                          /* 0176B0 */
{
    if (menu_level_or_list(rec) == 0) return;
    if ((r1_set_89C6 & 0x7F) == 0x29 && ui_BA35 != 0) { dial_step_tbl_3F6F2(&rec_1770C); return; }
    ui_flags |= 0x40;
    u16 v = r1_set_898E_w;
    if (!(key_flags & 0x01)) v = (v == 0x7F8) ? 0 : v + 8;
    else                     v = (v == 0)     ? 0x7F8 : v - 8;
    r1_set_898E_w = v;
}

/* @017714-01771C sub_17714 setup_force_down_17734 Confirmed: A9EE.0 = 1 (down) then joins sub_1771C at loc_17722 */
void setup_force_down_17734(rec_t *rec) { key_flags |= 0x01; dial_step_wrap(&rec_17734); ui_flags |= 0x40; }

/* @01771C-017734 sub_1771C setup_force_up_17734 Confirmed: A9EE.0 = 0 (up), wrap-step record 0x017734, dirty */
void setup_force_up_17734(rec_t *rec) { key_flags &= ~0x01; dial_step_wrap(&rec_17734); ui_flags |= 0x40; }

/* @01773A-017758 sub_1773A setup_toggle_BA35 Inferred: if FF89CC != 0 and (FF89C6 & 0x7F) == 0x29 toggle BA35.0, else refuse */
void setup_toggle_BA35(rec_t *rec)
{
    if (r1_set_89CC != 0 && (r1_set_89C6 & 0x7F) == 0x29) ui_BA35 ^= 0x01;
    else key_consume();
}

/* @017758-01775E sub_17758 setup_refuse_17758 Confirmed: key_consume() */
void setup_refuse_17758(rec_t *rec) { key_consume(); }

/* @01775E-017760 sub_1775E setup_nop_1775E Confirmed: rts */
void setup_nop_1775E(rec_t *rec) { }

/* @017760-017768 sub_17760 setup_toggle_89BE Confirmed: FF89BE ^= 1<<r4l, dirty (shared tail loc_1779E) */
void setup_toggle_89BE(u8 bit) { r1_set_89BE ^= (u8)(1u << bit); ui_flags |= 0x40; }

/* @017768-017770 sub_17768 setup_toggle_89BF Confirmed: FF89BF ^= 1<<r4l, dirty */
void setup_toggle_89BF(u8 bit) { r1_set_89BF ^= (u8)(1u << bit); ui_flags |= 0x40; }

/* @017770-017778 sub_17770 setup_toggle_89C0 Confirmed: FF89C0 ^= 1<<r4l, dirty */
void setup_toggle_89C0(u8 bit) { r1_set_89C0 ^= (u8)(1u << bit); ui_flags |= 0x40; }

/* @017778-017780 sub_17778 setup_toggle_89C1 Confirmed: FF89C1 ^= 1<<r4l, dirty */
void setup_toggle_89C1(u8 bit) { r1_set_89C1 ^= (u8)(1u << bit); ui_flags |= 0x40; }

/* --------------------------------------------------------------------------
 * @017780-0177A6 sub_17780 setup_toggle_89C2 Confirmed: FF89C2 ^= 1<<r4l, dirty.  The same block holds the entry points 0x017788 (FF89C3), 0x017790 (FF89C4), 0x017798 (FF89C5) and the shared tail 0x01779E (AA30 |= 0x40)
 * -------------------------------------------------------------------------- */
void setup_toggle_89C2(u8 bit) { r1_set_89C2 ^= (u8)(1u << bit); ui_flags |= 0x40; }  /* 017780 */
void setup_toggle_89C3(u8 bit) { r1_set_89C3 ^= (u8)(1u << bit); ui_flags |= 0x40; }  /* 017788 */
void setup_toggle_89C4(u8 bit) { r1_set_89C4 ^= (u8)(1u << bit); ui_flags |= 0x40; }  /* 017790 */
void setup_toggle_89C5(u8 bit) { r1_set_89C5 ^= (u8)(1u << bit); ui_flags |= 0x40; }  /* 017798 */

/* @0177A6-0177AE sub_177A6 dial_90_aprs_af_dual Confirmed: APRS AF DUAL (F3A0): aprs_toggle_8AAB(0) (sub_18FA2) */
void dial_90_aprs_af_dual(rec_t *rec) { aprs_toggle_8AAB(0); }

/* @0177AE-0177B8 sub_177AE setup_level_dispatch_177B8 Confirmed: menu_dispatch_by_level(rec, tbl 0x0177B8) */
void setup_level_dispatch_177B8(rec_t *rec) { menu_dispatch_by_level(rec, tbl_177B8); }

/* --------------------------------------------------------------------------
 * @0177DC-017822 sub_177DC aprs_filter_toggle Confirmed: APRS FILTER rows: eight entry points (0x0177DC, E4, EC, F4, FC, 017804, 0C, 14) toggle FF8AAE bits 0..6 and FF8AAF bit 0; shared tail marks dirty
 * doc 14: FF8AAE is the APRS filter mask (default 0x3F).
 * -------------------------------------------------------------------------- */
void aprs_filter_toggle(u8 row)                           /* 0177DC + 8*row */
{
    if (row < 7) r2_aprs_filter_8AAE ^= (u8)(1u << row);
    else         r2_aprs_filter_8AAF ^= 0x01;             /* 017814 */
    ui_flags |= 0x40;                                     /* 01781A */
}

/* @017822-01786A sub_17822 dial_92_aprs_modem Confirmed: APRS MODEM (F3A3): refused in node mode; B0CE.3 = 1, wrap-step record 0x01786A (R2 n=0 FF8AA0), sub_48B9A (modem on/off), then resets the APRS TX/RX state cells A50E=1, A9E6=2, A510/A511/A514/A515/A51A/A51B = 0 */
void dial_92_aprs_modem(rec_t *rec)
{
    if (node_mode) { key_consume(); return; }
    ui_B0CE |= 0x08;
    dial_step_wrap_dirty(&rec_1786A);
    sub_48B9A();
    aprs_A50E = 1;  aprs_A9E6 = 2;
    aprs_A510 = aprs_A511 = aprs_A514 = aprs_A515 = aprs_A51A = aprs_A51B = 0;
}

/* @017870-01788C sub_17870 setup_step_by_level_1788E Confirmed: via sub_15206 (callback sub_1A0B4): wrap-step record off_1788E[level-1]; falls into nullsub_80 */
void setup_step_by_level_1788E(rec_t *rec)
{
    u8 lvl = menu_level_or_call(rec, sub_1A0B4);
    if (lvl) dial_step_wrap_dirty(recs_1788E[lvl - 1]);
}

/* @01788C-01788E nullsub_80 setup_nop_1788C Confirmed: rts */
void setup_nop_1788C(rec_t *rec) { }

/* @0178AC-0178C8 sub_178AC setup_step_by_level_178CA Confirmed: as sub_17870 with record table off_178CA */
void setup_step_by_level_178CA(rec_t *rec)
{
    u8 lvl = menu_level_or_call(rec, sub_1A0B4);
    if (lvl) dial_step_wrap_dirty(recs_178CA[lvl - 1]);
}

/* @0178C8-0178CA nullsub_81 setup_nop_178C8 Confirmed: rts */
void setup_nop_178C8(rec_t *rec) { }

/* @0178E8-0178F0 sub_178E8 dial_95_aprs_mute Confirmed: APRS MUTE (F3A7): aprs_toggle_8AAB(3) */
void dial_95_aprs_mute(rec_t *rec) { aprs_toggle_8AAB(3); }

/* @0178F0-017914 sub_178F0 setup_step_8C41_row Inferred: via sub_15206 (callback 0x01A084): wrap-step byte FF8C41[level] (-0x73BF) through AA56 with record 0x017918 */
void setup_step_8C41_row(rec_t *rec)
{
    u8 lvl = menu_level_or_call(rec, setup_cb_1A084);
    if (lvl == 0) return;
    dial_scratch = r2_tbl_8C41[lvl];
    r2_tbl_8C41[lvl] = dial_step_wrap_dirty(&rec_17918);
}

/* @017916-017918 nullsub_82 setup_nop_17916 Confirmed: rts */
void setup_nop_17916(rec_t *rec) { }

/* @01791E-017924 sub_1791E dial_97_refuse Confirmed: screen 0x97 dial: key_consume */
void dial_97_refuse(rec_t *rec) { key_consume(); }

/* @017924-01792E sub_17924 setup_level_dispatch_1792E Confirmed: menu_dispatch_by_level(rec, tbl 0x01792E) */
void setup_level_dispatch_1792E(rec_t *rec) { menu_dispatch_by_level(rec, tbl_1792E); }

/* @017990-0179B6 sub_17990 dial_99_aprs_tx_delay Confirmed: APRS TX DELAY (F3AB): B0CE.3 = 1; wrap-step record 0x0179BC when FF89C4.1 is set (extended range), else 0x0179B6 (R2 n=0x1D) */
void dial_99_aprs_tx_delay(rec_t *rec)
{
    ui_B0CE |= 0x08;
    dial_step_wrap_dirty((r1_set_89C4 & 0x02) ? &rec_179BC : &rec_179B6);
}

/* @0179C2-0179D4 sub_179C2 dial_9A_beacon_interval Confirmed: BEACON INTERVAL (F3AD): wrap-step record 0x0179D4 (R2 n=0x1C), A50E = 1 */
void dial_9A_beacon_interval(rec_t *rec) { dial_step_wrap_dirty(&rec_179D4); aprs_A50E = 1; }

/* @0179DA-0179E2 sub_179DA beacon_tx_key_guard Confirmed: if A9FA.0 is clear jump to the step path loc_17A00, else fall into sub_179E2 */
void beacon_tx_key_guard(rec_t *rec)
{
    if (!(page_flags_A9FA & 0x01)) { beacon_tx_step_17A00(rec); return; }
    beacon_tx_toggle_page(rec);
}

/* @0179E2-0179F0 sub_179E2 beacon_tx_toggle_page Confirmed: A9FA ^= 0x08; A4F5 = 0 (list top) */
void beacon_tx_toggle_page(rec_t *rec) { page_flags_A9FA ^= 0x08; list_top_A4F5 = 0; }

/* @0179F0-017A18 sub_179F0 beacon_tx_key Inferred: A9FA.1 -> refuse; A9FA.0 -> toggle page; else up-wrap record 0x017A96, apply (sub_17A50) and save R2 n=0xB (sub_19842) */
void beacon_tx_key(rec_t *rec)
{
    if (page_flags_A9FA & 0x02) { key_consume(); return; }
    if (page_flags_A9FA & 0x01) { beacon_tx_toggle_page(rec); return; }
    beacon_tx_step_17A00(rec);
}
static void beacon_tx_step_17A00(rec_t *rec)             /* 017A00 */
{
    u8 v = dial_step_up_wrap(&rec_17A96);
    beacon_mode_apply(v);
    exit_save_r2_0B();                                    /* sub_19842 */
}

/* @017A18-017A3A sub_17A18 dial_9C_beacon_tx Confirmed: BEACON TX (F3AF): wrap-step record 0x017A90, or 0x017A96 (includes SmartBeaconing) when FF8BCC != 0 and position source FF8AB8 == 0 (GPS); apply via sub_17A50 */
void dial_9C_beacon_tx(rec_t *rec)
{
    const step_rec_t *r = &rec_17A90;
    if (r2_sb_type_8BCC != 0 && aprs_pos_src == 0) r = &rec_17A96;
    beacon_mode_apply(dial_step_wrap_dirty(r));
}

/* @017A3A-017A50 sub_17A3A beacon_mode_recheck Confirmed: if A90C (beacon mode) == 2 (SMART): re-apply mode 2 (may fall back to OFF), save R2 n=0xB, sub_44814 */
void beacon_mode_recheck(void)
{
    if (beacon_mode_A90C != 2) return;
    beacon_mode_apply(2);
    exit_save_r2_0B();
    sub_44814();
}

/* --------------------------------------------------------------------------
 * @017A50-017A90 sub_17A50 beacon_mode_apply Confirmed: maps BEACON TX value r3l to FF8AAB bits: 0 OFF, 1 AUTO (b6), 2 SMART (b1, only if FF8BCC != 0 and GPS source, else A90C = 0); then A50E = 1
 * doc 14: A90C==1 from 8AAB.b6, A90C==2 from 8AAB.b1.
 * -------------------------------------------------------------------------- */
void beacon_mode_apply(u8 v)                              /* 017A50 */
{
    r2_set_8AAB &= ~0x02;  r2_set_8AAB &= ~0x40;
    if (v == 1) r2_set_8AAB |= 0x40;
    else if (v != 0) {
        if (r2_sb_type_8BCC != 0 && aprs_pos_src == 0) r2_set_8AAB |= 0x02;
        else beacon_mode_A90C = 0;
    }
    aprs_A50E = 1;
}

/* @017A9C-017AA6 sub_17A9C setup_level_dispatch_17AA6 Confirmed: menu_dispatch_by_level(rec, tbl 0x017AA6) */
void setup_level_dispatch_17AA6(rec_t *rec) { menu_dispatch_by_level(rec, tbl_17AA6); }

/* @017ADC-017AF4 sub_17ADC dial_A9_gps_power Confirmed: GPS POWER (F3B5): toggle R2 FF8ABE.6, sub_44700 (GPS power), dirty; returns the new bit in C */
void dial_A9_gps_power(rec_t *rec) { r2_set_8ABE ^= 0x40; sub_44700(); ui_flags |= 0x40; }

/* @017AF4-017AFC sub_17AF4 dial_A0_gps_time_set Confirmed: GPS TIME SET (F3B6): aprs_toggle_8AAB(7) */
void dial_A0_gps_time_set(rec_t *rec) { aprs_toggle_8AAB(7); }

/* @017AFC-017B04 sub_17AFC callsign_cursor_8AA2 Confirmed: er1 = FF8AA2 (APRS callsign) and bra sub_17B0A */

/* @017B04-017B0A sub_17B04 callsign_cursor_8AA2_b Confirmed: er1 = FF8AA2, falls into sub_17B0A */
#define callsign_cursor_8AA2(rec)    callsign_cursor_move(rec, r2_callsign_8AA2)
#define callsign_cursor_8AA2_b(rec)  callsign_cursor_move(rec, r2_callsign_8AA2)

/* --------------------------------------------------------------------------
 * @017B0A-017B58 sub_17B0A callsign_cursor_move Inferred: moves the callsign-editor cursor (record 0x017B58 via sub_19F3A): columns 2..6 skip over a gap of two empty (0xFF) chars, column 7+ (SSID) is only reachable when the call is non-empty; an empty call sends the cursor back to the field (level 1)
 * -------------------------------------------------------------------------- */
void callsign_cursor_move(rec_t *rec, u8 *call)           /* 017B0A */
{
again:;
    u8 col = cursor_step_19F3A(&rec_17B58);               /* r3l, Z if refused */
    if (col == 0 || col < 2) return;
    if (col >= 7) { if (call[0] == 0xFF) menu_level = 1; return; }
    if (call[col - 2] != 0xFF || call[col - 1] != 0xFF) return;
    if (key_flags & 0x01) goto again;                     /* moving left: keep going */
    if (call[0] == 0xFF) goto again;
    menu_level = 7;                                       /* jump to SSID */
}

/* --------------------------------------------------------------------------
 * @017B5E-017C1A sub_17B5E msg_editor_cursor Inferred: cursor key in the two-field message/destination editor (call at A56D, text at A574): moves AD68 between the call columns (<7), the SSID column (7) and text columns (>=8, sub_17C1A), then recomputes the scrolled window (sub_17C4C with layout 0x017CBA / 0x017CCA by FF8C2C.1) and resets edit timers
 * -------------------------------------------------------------------------- */
void msg_editor_cursor(rec_t *rec)                        /* 017B5E */
{
    ui_flags |= 0x80;  win_mode_B091 = 0;
    u8 right = (key_event == 4);
    if (msg_call_A56D == 0xFF) {                          /* empty call */
        if (msg_text_A574 == 0xFF || !right) goto other;  /* 017B7A..017B88 */
        if (menu_level < 7) { menu_level = 7; goto layout; }
    }
    if (!right) goto other;                               /* 017B92 */
    if (menu_level < 7) { callsign_cursor_move(rec, &msg_call_A56D); goto layout; }
    if (menu_level == 7) { menu_level = 1; goto layout; }
    msg_text_cursor(rec);                                 /* bsr sub_17C1A */
    if (menu_level == 8) menu_level = 8;                  /* 017BAE (no-op store) */
    goto layout;
other:                                                    /* 017BBE */
    if (menu_level == 1) { menu_level = 7; goto layout; }
    if (menu_level < 8) { callsign_cursor_move(rec, &msg_call_A56D); goto layout; }
    msg_text_cursor(rec);
layout:                                                   /* 017BE0 */
    text_window_scroll((r2_set_8C2C & 0x02) ? layout_17CBA : layout_17CCA, menu_level);
    ui_A507 = 0;  ui_B090 = 0;  ui_A9F7 &= ~0x01;  ui_9542 = 0;
}

/* @017C1A-017C46 sub_17C1A msg_text_cursor Inferred: moves the text cursor in A574 (record 0x017C46); for columns >= 9 skips gaps of two empty chars */
void msg_text_cursor(rec_t *rec)                          /* 017C1A */
{
    u8 col;
    do {
        col = cursor_step_19F3A(&rec_17C46);
        if (col == 0 || col < 9) return;
    } while ((&msg_text_A574)[col - 9] == 0xFF && (&msg_text_A574)[col - 8] == 0xFF);
}

/* --------------------------------------------------------------------------
 * @017C4C-017CBA sub_17C4C text_window_scroll Inferred: computes the first visible row A4F5 of a multi-row text editor from cursor column r5l and a layout record {u16 first_col; u8 row_len; u8 rows; u8 r0lo,r0hi; ...}: page mode (B091 != 0) uses (col-first)/row_len, otherwise scrolls by one row when the cursor leaves the current row
 * -------------------------------------------------------------------------- */
void text_window_scroll(const u8 *lay, u8 col)            /* 017C4C */
{
    u16 first = *(const u16 *)lay;  u8 row_len = lay[2], rows = lay[3];
    const u8 *last = lay + 4;
    u8 top;
    if (win_mode_B091) {                                  /* 017CA8 */
        s8 d = (s8)(col - (u8)first);
        top = (d <= 0) ? 0 : (u8)d / row_len;
        list_top_A4F5 = top;  return;
    }
    top = list_top_A4F5;
    const u8 *row = lay + 4 + 2 * top;                    /* {lo,hi} of row 'top' */
    if (col >= row[0] && col < (u8)(row[1] + 1)) {        /* inside current row */
        if (key_event != 4 || col != last[0]) return;
        top = 0;
    } else if (key_event == 4) {
        if (++top >= rows || col >= (u8)(last[0] + 1)) top = 0;
    } else {
        if ((s8)--top < 0) top = 0;
    }
    list_top_A4F5 = top;
}

/* @017CFE-017D30 sub_17CFE callsign_dial Inferred: APRS CALLSIGN editor dial: column 7 steps the SSID (record 0x017D30); columns 1..6 step character (level-1) of FF8AA2 via sub_189B2 (charset 5); an emptied call clears the SSID FF8AA8 */
void callsign_dial(rec_t *rec)
{
    u8 lvl = menu_level_or_list(rec);
    if (lvl == 0) return;
    if (lvl == 7) { dial_step_wrap_dirty(&rec_17D30); return; }
    text_char_step(r2_callsign_8AA2, lvl - 1, 5);         /* sub_189B2 */
    if ((s8)r2_callsign_8AA2[0] < 0) r2_ssid_8AA8 = 0;
}

/* @017D36-017D42 sub_17D36 callsign_set_ssid Confirmed: FF8AA8 = r4l; dirty */
void callsign_set_ssid(u8 v) { r2_ssid_8AA8 = v; ui_flags |= 0x40; }

/* @017D90-017DC4 sub_17D90 callsign_format Confirmed: renders FF8AA2 (6 chars, 0xFF -> ' ') into A8C4 and appends the 3-byte SSID suffix from the ROM table 0x00444C[ssid] */
void callsign_format(void)                                /* 017D90 */
{
    u8 *s = r2_callsign_8AA2, *d = disp_A8C4;
    for (int i = 0; i < 6; i++) { u8 c = *s++; *d++ = (c == 0xFF) ? ' ' : c; }
    u32 suf = ssid_suffix_444C[*s];                       /* 4-byte entries, 3 used */
    d[0] = suf >> 24; d[1] = suf >> 16; d[2] = suf >> 8;  /* mov.w e4 / mov.b r4h */
}

/* --------------------------------------------------------------------------
 * @017DC4-017E2A sub_17DC4 msg_editor_dial Inferred: message editor dial (needs BBED != 0): call columns 1..6 -> sub_189B8 on A56D (empty clears A573); column 7 -> SSID record 0x017E2A; columns >= 8 -> text char at A574[col-8] (sub_17E3C) unless BBF1.3 selects record 0x017E30
 * -------------------------------------------------------------------------- */
void msg_editor_dial(rec_t *rec)                          /* 017DC4 */
{
    u8 lvl = menu_level_or_list(rec);
    if (lvl == 0) return;
    if (ui_BBED == 0) { key_consume(); return; }
    if (lvl >= 8) {
        if (ui_BBF1 & 0x08) dial_step_wrap(&rec_17E30);
        else text_char_step_nodirty(&msg_text_A574, lvl - 8);   /* 017E42 inside sub_17E3C */
        return;
    }
    if (lvl == 7) { dial_step_wrap(&rec_17E2A); return; }
    text_char_step_b(&msg_call_A56D, lvl - 1, 5);         /* sub_189B8 */
    if ((s8)msg_call_A56D < 0) msg_ssid_A573 = 0;
}

/* @017E36-017E3C sub_17E36 msg_set_ssid Confirmed: A573 = r4l */
void msg_set_ssid(u8 v) { msg_ssid_A573 = v; }

/* @017E3C-017E74 sub_17E3C text_char_step Inferred: dirty; char = buf[i]; empty -> seed with previous char or 'A' (sub_17E74), else step through charset record 0x017E84 skipping '{' and '|'; store, AA30.7 = 1, 9542 = 0x96 (cursor blink timer) */
void text_char_step_7E3C(u8 *buf, u8 i)                   /* 017E3C */
{
    ui_flags |= 0x40;
    text_char_step_nodirty(buf, i);
}
void text_char_step_nodirty(u8 *buf, u8 i)                /* 017E42 */
{
    u8 *p = buf + i, c = *p;
    if (c == 0xFF) c = text_seed_char(p, i);
    else {
        dial_scratch = c;
        do { c = dial_step_wrap(&rec_17E84); } while (c == '{' || c == '|');
    }
    *p = c;
    ui_flags |= 0x80;
    ui_9542 = 0x96;
}

/* @017E74-017E84 sub_17E74 text_seed_char Confirmed: returns the previous char (p[-1]) or 'A' at position 0 */
u8 text_seed_char(const u8 *p, u8 i) { return i ? p[-1] : 'A'; }

/* @017E8A-017EB6 sub_17E8A callsign_key_delete Inferred: delete key in the APRS callsign editor: columns 1..6 -> sub_1A90E(FF8AA2, col-1, 6); dirty.  Level 0 / 7 refused */
void callsign_key_delete(rec_t *rec)
{
    u8 lvl = menu_level;
    if (lvl == 0 || lvl == 7) { key_consume(); return; }
    text_delete_char(r2_callsign_8AA2, lvl - 1, 6);
    ui_flags |= 0x40;
}

/* @017EB6-017EFE sub_17EB6 msg_key_delete Inferred: delete key in the message editor (buffer A56C): text columns via sub_1A84E(len 0x4B), scrolling one row (A4F5++) when the cursor sits at 0x30 or 0x44; call columns via sub_1A90E(len 7) */
void msg_key_delete(rec_t *rec)
{
    u8 lvl = menu_level;
    if (lvl == 0 || lvl == 7) { key_consume(); return; }
    if (lvl >= 8) {
        if (!text_insert_1A84E(&msg_buf_A56C, lvl, 0x4B)) return;
        if (menu_level == 0x30 || menu_level == 0x44) list_top_A4F5++;
        return;
    }
    text_delete_char(&msg_buf_A56C, lvl, 7);
}

/* --------------------------------------------------------------------------
 * @017EFE-017F84 sub_17EFE text_editor_cursor_long Inferred: cursor key for the long-text editors (level >= 3): sets page mode B091 when moving left from column 3 at row 0, resets the top row when leaving row 1 at column 4, advances the cursor (sub_19ED6) and re-scrolls with layout 0x017CEA / 0x017CF8 (by FF8C2C.0); resets edit timers
 * -------------------------------------------------------------------------- */
void text_editor_cursor_long(rec_t *rec)                  /* 017EFE */
{
    if (menu_level < 3) { key_consume(); return; }
    u8 page = 0;
    if (key_event != 4 && list_top_A4F5 == 0 && menu_level == 3) page = 1;
    win_mode_B091 = page;
    if (key_event != 4) {
        if (list_top_A4F5 == 1 && menu_level == 4) { list_top_A4F5 = 0; goto reset; }  /* 017F42 beq */
        /* NB: the beq at 017F42 tests the Z left by the previous compare */
    }
    sub_19ED6(rec);
    text_window_scroll((r2_set_8C2C & 0x01) ? layout_17CEA : layout_17CF8, menu_level);
reset:
    ui_A507 = 0;  ui_B090 = 0;  ui_A9F7 &= ~0x01;  ui_9542 = 0;
}

/* --------------------------------------------------------------------------
 * @017F84-017FF6 sub_17F84 status_text_dial Inferred: BEACON STATUS TEXT style editor: rows 1..3 (sub_15206 cb sub_1A0B4) step: row1 record 0x017FF6 (A984 = 0), row2 record 0x017FFC (A984 = value), row3 reload text (sub_508B6, sub_196D6, record 0x018002, sub_3D5AC); text columns >= 4 step chars of ADA2 (sub_18008) when BBEE != 0
 * -------------------------------------------------------------------------- */
void status_text_dial(rec_t *rec)                         /* 017F84 */
{
    u8 lvl = menu_level_or_list(rec);
    if (lvl == 0) return;
    if (lvl >= 4) {
        if (ui_BBEE) text_char_step_18008(text_ADA2, lvl - 4);
        else key_consume();
        return;
    }
    lvl = menu_level_or_call(rec, sub_1A0B4);
    if (lvl == 0) return;
    if (lvl == 1) { dial_step_wrap_dirty(&rec_17FF6); ui_A984 = 0; }
    else if (lvl == 2) ui_A984 = dial_step_wrap_dirty(&rec_17FFC);
    else { sub_508B6(); exit_9B_status_text(rec); dial_step_wrap_dirty(&rec_18002); sub_3D5AC(); }
}

/* @018008-01803A sub_18008 text_char_step_18008 Inferred: like sub_17E3C for buffer er1 with charset record 0x01803A (no skips): store, AA30 |= 0xC0, 9542 = 0x96 */
void text_char_step_18008(u8 *buf, u8 i)
{
    u8 *p = buf + i, c = *p;
    if (c == 0xFF) c = text_seed_char(p, i);
    else { dial_scratch = c; c = dial_step_wrap_dirty(&rec_1803A); }
    *p = c;
    ui_flags |= 0x40;  ui_flags |= 0x80;
    ui_9542 = 0x96;
}

/* @018040-01806E sub_18040 status_text_key_delete Inferred: text columns >= 4: sub_1A84E(ADA2, col-4, 0x3C), dirty; else refuse */
void status_text_key_delete(rec_t *rec)
{
    if (menu_level == 0 || menu_level < 4) { key_consume(); return; }
    text_insert_1A84E(text_ADA2, menu_level - 4, 0x3C);
    ui_flags |= 0x40;
}

/* @018090-0180B8 sub_18090 status_text_key_insert Inferred: text columns >= 4: sub_188F6(ADA2, col-4, 0x3C); label 0x0180B2 = key_consume */
void status_text_key_insert(rec_t *rec)
{
    if (menu_level == 0 || menu_level < 4) return;
    text_insert_188F6(text_ADA2, menu_level - 4, 0x3C);
}

/* @0180B8-0180DA sub_180B8 symbol_key_next Inferred: if symbol set FF8C1E == 3 and the symbol code FF8AA1 == 0xC4 (user-defined) -> sub_19F92, else sub_19F82; label 0x0180D4 = key_consume */
void symbol_key_next(rec_t *rec)
{
    if (r2_sym_set_8C1E == 3 && r2_symbol_8AA1 == 0xC4) sub_19F92(rec);
    else sub_19F82(rec);
}

/* --------------------------------------------------------------------------
 * @0180DA-018180 sub_180DA my_symbol_dial Inferred: MY SYMBOL editor dial: row 1 steps the symbol set (record 0x018192); for preset sets steps FF8AA1 via record off_18198[set] skipping codes whose ROM flag tbl_44596[code] == 0; for the user set (3, code 0xC4) column 2 steps the table char FF8AC0 ('/' or '\' or sub_18A32-valid) and column 3+ uses record 0x01818C, otherwise record 0x018180
 * -------------------------------------------------------------------------- */
void my_symbol_dial(rec_t *rec)                           /* 0180DA */
{
    u8 lvl = menu_level_or_list(rec);
    if (lvl == 0) return;
    if (menu_level == 1) { dial_step_wrap_dirty(&rec_18192); return; }
    if (r2_sym_set_8C1E != 3) {
        u8 v;
        do v = dial_step_wrap_dirty(recs_18198[r2_sym_set_8C1E]);
        while (sym_valid_44596[v] == 0);
        return;
    }
    if (r2_symbol_8AA1 == 0xC4 && lvl >= 3 && --lvl != 0) {   /* -> 0180E8 */
        if (lvl == 2) {
            dial_scratch = r2_symtab_8AC0;
            u8 c;
            do c = dial_step_wrap_dirty(&rec_18186);
            while (c != '/' && c != '\\' && sym_overlay_ok(c) == 0);   /* sub_18A32 */
            r2_symtab_8AC0 = c;
        } else {
            dial_step_wrap_dirty(&rec_1818C);
        }
        return;
    }
    dial_step_wrap_dirty(&rec_18180);
}

/* @0181B6-0181FE sub_181B6 my_symbol_key_user Inferred: in the user symbol set (FF8C1E == 3, column >= 2) swaps FF8AA1 between the remembered preset code (FF8C2D) and 0xC4; else menu_exit_all */
void my_symbol_key_user(rec_t *rec)
{
    u8 lvl = menu_level;
    if (lvl == 0 || r2_sym_set_8C1E != 3 || lvl < 2) { menu_exit_all(rec); return; }
    ui_flags |= 0x40;
    if (r2_symbol_8AA1 != 0xC4) { r2_sym_save_8C2D = r2_symbol_8AA1; r2_symbol_8AA1 = 0xC4; }
    else { menu_level = 2; r2_symbol_8AA1 = r2_sym_save_8C2D; }
}

/* @0181FE-01822C sub_181FE setup_step_confirm_1822C Inferred: if no confirm is pending: wrap-step record 0x01822C and clear AD98; else wrap-step record 0x018232 (no dirty) and call sub_6FBE2 */
void setup_step_confirm_1822C(rec_t *rec)
{
    if (menu_level_or_list(rec) == 0) return;
    if (confirm_pending == 0) { dial_step_wrap_dirty(&rec_1822C); confirm_pending = 0; }
    else { dial_step_wrap(&rec_18232); sub_6FBE2(); }
}

/* @018238-01824A sub_18238 dial_A7_time_zone Confirmed: TIME ZONE (F3BE): wrap-step record 0x01824A (R2 n=0x129), clear 9D26.0 */
void dial_A7_time_zone(rec_t *rec) { dial_step_wrap_dirty(&rec_1824A); ui_9D26 &= ~0x01; }

/* @018250-018262 sub_18250 sb_level_cb Inferred: callback for sub_15206 in the SmartBeaconing editor: if a type is selected (FF8BCC != 0) sub_1A0DC, else refuse */
void sb_level_cb(rec_t *rec) { if (r2_sb_type_8BCC) sub_1A0DC(rec); else key_consume(); }

/* @018262-018276 sub_18262 sb_load_params Confirmed: copies the 7 SmartBeaconing parameters of the current type (pointer from sub_449A8) to the edit block A90E */
void sb_load_params(void) { sub_3F36E(7, sub_449A8(), sb_edit_A90E); }

/* @018276-01829A sub_18276 sb_dial Confirmed: SmartBeaconing editor dial: via sub_15206 (callback 0x018250) jumps through off_1832C[level] into the case labels of sub_1829A */
void sb_dial(rec_t *rec)
{
    if (menu_level_or_call(rec, sb_level_cb) == 0) return;
    sb_cases_1832C[menu_level](rec);                      /* jmp @er6 */
}

/* --------------------------------------------------------------------------
 * @01829A-01832C sub_1829A sb_dial_cases Inferred: SmartBeaconing per-row dial cases; every successful edit sets A916 = 1 (params changed)
 *   0x01829A type row: save (sub_1972C), step type (record 0x018364); type != 0 reloads the parameter block (sub_18262), type 0 re-checks the beacon mode (sub_17A3A)
 *   0x0182B6 low speed: sub_183AA handles the lo<hi wrap, else record 0x01836A
 *   0x0182C4 high speed: sub_183E4, else record 0x018370
 *   0x0182D2..0x0182F2 rows: records 0x018376, 0x01837C, 0x018382, 0x018388, 0x01838E
 *   0x0182FE: only when type == 0: record 0x018394
 *   0x01830C / 0x018314: table steps (sub_3F6F2) records 0x01839A / 0x0183A2
 * -------------------------------------------------------------------------- */
void sb_case_type(rec_t *rec)                             /* 01829A */
{
    exit_A8_smartbeaconing(rec);                          /* sub_1972C */
    if (dial_step_wrap_dirty(&rec_18364) != 0) sb_load_params();
    else { beacon_mode_recheck(); return; }
    sb_changed_A916 = 1;
}
void sb_case_low(rec_t *rec)  { if (!sb_wrap_low())  dial_step_wrap_dirty(&rec_1836A); sb_changed_A916 = 1; }  /* 0182B6 */
void sb_case_high(rec_t *rec) { if (!sb_wrap_high()) dial_step_wrap_dirty(&rec_18370); sb_changed_A916 = 1; }  /* 0182C4 */
void sb_case_row(const step_rec_t *r) { dial_step_wrap_dirty(r); sb_changed_A916 = 1; }                 /* 0182D2.. */
void sb_case_182FE(rec_t *rec)
{
    if (r2_sb_type_8BCC != 0) { key_consume(); return; }
    sb_case_row(&rec_18394);
}
void sb_case_tbl(const step_rec_t *r) { dial_step_tbl_3F6F2(r); sb_changed_A916 = 1; }                  /* 01830C/018314 */

/* @0183AA-0183E4 sub_183AA sb_wrap_low Confirmed: keeps low speed A90E < high speed A90F: up past (hi-1) wraps to 2; down from 2 wraps to min(0x1E, hi-1); returns 1 when it handled the step */
u8 sb_wrap_low(void)                                      /* 0183AA */
{
    u8 hi = sb_edit_A90E[1], lo = sb_edit_A90E[0], v;
    if (!(key_flags & 0x01)) { if ((u8)(lo + 1) < hi) return 0; v = 2; }
    else { if (lo != 2) return 0; v = 0x1E; if (v < hi) return 0; v = hi - 1; }
    sb_edit_A90E[0] = v;  ui_flags |= 0x40;
    return 1;
}

/* @0183E4-018420 sub_183E4 sb_wrap_high Confirmed: high speed A90F wraps 0x5A -> lo+1 (up, when lo >= 2) and lo+1 -> 0x5A (down); returns 1 when handled */
u8 sb_wrap_high(void)                                     /* 0183E4 */
{
    u8 hi = sb_edit_A90E[1], lo = sb_edit_A90E[0], v;
    if (!(key_flags & 0x01)) {
        if (hi != 0x5A || lo < 2) return 0;
        v = lo + 1;
    } else {
        if (lo < (u8)(hi - 1)) return 0;
        v = 0x5A;
    }
    sb_edit_A90E[1] = v;  ui_flags |= 0x40;
    return 1;
}

/* --------------------------------------------------------------------------
 * @01848E-0184DC sub_1848E my_position_cursor Inferred: MY POSITION cursor key: manual source (FF8AB8 == 2) enters the lat/lon editor at column 5 (record 0x0184E2, wrapping back to 1 at 5); source 1 uses record 0x0184DC; GPS (0) and stored slots (>= 3) are refused at row 1
 * -------------------------------------------------------------------------- */
void my_position_cursor(rec_t *rec)                       /* 01848E */
{
    u8 lvl = menu_level;
    if (lvl == 0) goto refuse;
    if (lvl >= 6) goto deep;
    if (lvl >= 2) { cursor_step_19FAE(&rec_184DC); return; }
    if (aprs_pos_src == 0 || aprs_pos_src >= 3) goto refuse;
    if (aprs_pos_src == 1) { cursor_step_19FAE(&rec_184DC); return; }
    menu_level = 5;
deep:
    if (cursor_step_19FAE(&rec_184E2) && /*r3l*/ menu_level == 5) menu_level = 1;   /* cmp r3l,#5 */
    return;
refuse:
    key_consume();
}

/* --------------------------------------------------------------------------
 * @0184E8-018568 sub_184E8 my_position_dial Inferred: MY POSITION dial: row 1 steps the position source FF8AB8 (record off_1856A[1]; value 2 is turned into 3/1 by direction); a stored slot (>= 3) is loaded with sub_3D4A4(src-3); non-GPS sources re-check the beacon mode.  With BBEF set only sources 1/2 step (record 0x0185C8)
 * -------------------------------------------------------------------------- */
void my_position_dial(rec_t *rec)                         /* 0184E8 */
{
    u8 lvl = menu_level_or_list(rec);
    if (lvl == 0) return;
    if (ui_BBEF && menu_level == 1) {
        if (aprs_pos_src == 1 || aprs_pos_src == 2) dial_step_wrap_dirty(&rec_185C8);
        else key_consume();
        return;
    }
    u8 v = dial_step_wrap_dirty(recs_1856A[lvl]);
    if (menu_level != 1) return;
    if (v == 2) aprs_pos_src = (key_flags & 0x01) ? 1 : 3;
    if (aprs_pos_src >= 3) sub_3D4A4(aprs_pos_src - 3);
    if (aprs_pos_src != 0) beacon_mode_recheck();
}

/* @018568-01856A nullsub_83 setup_nop_18568 Confirmed: rts (tail of sub_184E8) */
void setup_nop_18568(rec_t *rec) { }

/* @0185CE-018618 sub_185CE my_position_store_gps Inferred: at row 1 with a stored-slot source (>= 3) and a valid GPS fix (9D60 / 9D6A not negative): copy the 0x1C-byte live position 9D58 -> 9D74 (eepmov) and save it to slot src-3 (sub_3D4B4) */
void my_position_store_gps(rec_t *rec)
{
    if (menu_level != 1 || aprs_pos_src < 3 || (s8)gps_9D60 < 0 || (s8)gps_9D6A < 0) { key_consume(); return; }
    memcpy(gps_pos_9D74, gps_pos_9D58, 0x1C);             /* eepmov.w loop */
    sub_3D4B4(aprs_pos_src - 3);
}

/* @018618-018622 sub_18618 setup_level_dispatch_18622 Confirmed: menu_dispatch_by_level(rec, tbl 0x018622) */
void setup_level_dispatch_18622(rec_t *rec) { menu_dispatch_by_level(rec, tbl_18622); }

/* --------------------------------------------------------------------------
 * @01865A-0186CC sub_1865A digipath_cursor Inferred: DIGI PATH editor cursor: only for full paths (FF8BE5 >= 3); moves within the 7-byte hop entry (sub_186CC) with record 0x0186F0: columns 4..8 skip double gaps, column 9 (SSID) needs a non-empty call; while the cursor is below 3 it re-steps; leaving to column < 2 resets the hop index FF8AC2
 * -------------------------------------------------------------------------- */
void digipath_cursor(rec_t *rec)                          /* 01865A */
{
    if (r2_digipath_8BE5 < 3) { key_consume(); goto tail; }
    u8 *e = digipath_entry();                             /* bsr loc_186CC */
    for (;;) {
        u8 col = cursor_step_19F3A(&rec_186F0);
        if (col == 0 || col < 4) break;
        if (col >= 9) { if (e[0] == 0xFF) menu_level = 1; break; }
        if (e[col - 4] != 0xFF || e[col - 3] != 0xFF) break;
        if (key_flags & 0x01) continue;
        if (e[0] == 0xFF) continue;
        menu_level = 9;  break;
    }
tail:
    if (menu_level < 3) { /* 0186BA: loops back to the cursor step (loc_18664) */ }
    if (menu_level < 2) r2_digi_hop_8AC2 = 0;             /* 0186C4 */
}

/* @0186CC-0186F0 sub_186CC digipath_entry Confirmed: er1 = off_186F6[FF8BE5] + FF8AC2 * 7 (7-byte hop entries: 6 call chars + SSID) */
u8 *digipath_entry(void)                                  /* 0186CC */
{
    return digipath_tbl_186F6[r2_digipath_8BE5] + r2_digi_hop_8AC2 * 7;
}

/* --------------------------------------------------------------------------
 * @01871E-018798 sub_1871E digipath_dial Inferred: DIGI PATH dial: not at list level -> sub_18798.  The body 0x018728..0x018796 (reached from sub_18798 via bsr 0x018730) steps: row 1 path type (record 0x0187F6, hop = 0), row 2 hop count (record 0x0187FC or 0x018802 for types >= 7), column 9 the hop SSID (record 0x0187F0), columns 3..8 a call character (sub_189B2, last index 5); an emptied call clears the SSID
 * -------------------------------------------------------------------------- */
void digipath_dial(rec_t *rec)                            /* 01871E */
{
    if (menu_level_or_list(rec) == 0) return;
    digipath_dial_state(rec, menu_level);                 /* bsr sub_18798 */
}
static void digipath_dial_chars(u8 lvl)                   /* 018730 */
{
    u8 *e = digipath_entry();
    if (lvl == 9) { dial_scratch = e[6]; e[6] = dial_step_wrap_dirty(&rec_187F0); return; }
    text_char_step(e, lvl - 3, 5);                        /* sub_189B2 */
    e = digipath_entry();
    if ((s8)e[0] < 0) e[6] = 0;
}

/* @018798-0187DC sub_18798 digipath_dial_state Inferred: by edit state BC03: 0 -> step path type (hop index reset); 1 -> step hop count (types >= 3 only, record 0x0187FC / 0x018802); >= 2 -> characters (columns >= 3) */
void digipath_dial_state(rec_t *rec, u8 lvl)              /* 018798 */
{
    if (ui_BC03 == 0) { r2_digi_hop_8AC2 = 0; dial_step_wrap_dirty(&rec_187F6); return; }
    if (ui_BC03 == 1) {
        if (r2_digipath_8BE5 < 3) { key_consume(); return; }
        dial_step_wrap_dirty(r2_digipath_8BE5 < 7 ? &rec_187FC : &rec_18802);
        return;
    }
    if (lvl < 3) { key_consume(); return; }
    digipath_dial_chars(lvl);
}

/* @0187DC-0187F0 sub_187DC digipath_set_ssid Confirmed: current hop entry[6] = r4l; dirty */
void digipath_set_ssid(u8 v) { digipath_entry()[6] = v; ui_flags |= 0x40; }

/* @018808-018840 sub_18808 digipath_key_delete Inferred: in state BC03 == 2, columns 3..8: delete char (sub_1A90E, entry, col-3, len 6); dirty */
void digipath_key_delete(rec_t *rec)
{
    u8 lvl = menu_level;
    if (lvl == 0 || ui_BC03 != 2 || lvl < 3 || lvl == 9) { key_consume(); return; }
    text_delete_char(digipath_entry(), lvl - 3, 6);
    ui_flags |= 0x40;
}

/* @018840-018866 sub_18840 grp_text_cursor Inferred: cursor key in the 16-char group/bulletin text editor (entry from sub_18894): sub_19E8A, then reset edit timers */
void grp_text_cursor(rec_t *rec)
{
    (void)grp_text_entry();                               /* bsr 0x018894 */
    sub_19E8A(rec);
    ui_A507 = 0;  ui_B090 = 0;  ui_A9F7 &= ~0x01;  ui_9542 = 0;
}

/* @018866-01888E sub_18866 grp_text_dial Inferred: row 1 selects the entry FF8AFC (sub_508B6, record 0x01888E, B3F5 mirrors it); columns >= 2 step a character of the 16-byte entry (sub_17E3C) */
void grp_text_dial(rec_t *rec)
{
    u8 lvl = menu_level_or_list(rec);
    if (lvl == 0) return;
    if (lvl == 1) { sub_508B6(); edit_cursor_max = dial_step_wrap_dirty(&rec_1888E); return; }
    text_char_step_7E3C(grp_text_entry(), lvl - 2);
}

/* @018894-0188A8 sub_18894 grp_text_entry Confirmed: er1 = 0xFF8AFE + FF8AFC * 16 */
u8 *grp_text_entry(void) { return r2_grp_text_8AFE + r2_grp_idx_8AFC * 16; }

/* @0188A8-0188D0 sub_188A8 grp_text_key_delete Inferred: columns >= 2: sub_1A854(entry, col-2, 0x10) (delete char, shift left); dirty */
void grp_text_key_delete(rec_t *rec)
{
    u8 lvl = menu_level;
    if (lvl == 0 || lvl == 1) { key_consume(); return; }
    text_delete_shift_1A854(grp_text_entry(), lvl - 2, 0x10);
    ui_flags |= 0x40;
}

/* @0188E0-0188F6 sub_188E0 grp_text_key_clear Inferred: columns >= 2: clear from the cursor to the end (sub_188F6, len 0x10) */
void grp_text_key_clear(rec_t *rec)
{
    if (!edit_level_ge2()) return;                        /* sub_18A7C */
    text_clear_from(grp_text_entry(), menu_level - 2, 0x10);
}

/* @0188F6-01890C sub_188F6 text_clear_from Confirmed: for (i = r2; i < r5l; i++) buf[i] = 0xFF; dirty */
void text_clear_from(u8 *buf, u8 i, u8 len)               /* 0188F6 */
{
    do { buf[i] = 0xFF; } while (++i < len);
    ui_flags |= 0x40;
}

/* --------------------------------------------------------------------------
 * @01890C-018962 sub_1890C grp_code_cursor Inferred: cursor in the 9-byte group-code entries (FF8B80 + FF8B7E*9, sub_18962) with record 0x018976; entries 0..4 skip double gaps from column 3, entries >= 5 are limited to columns 2..5 (column 6 forced)
 * -------------------------------------------------------------------------- */
void grp_code_cursor(rec_t *rec)                          /* 01890C */
{
    u8 *e = grp_code_entry();
    for (;;) {
        u8 col = cursor_step_19F3A(&rec_18976);
        if (col == 0) return;
        if (r2_grp_code_idx_8B7E < 5) {
            if (col < 3) return;
        } else {
            if (col < 2) return;
            if (col < 6) { menu_level = 6; }              /* both directions store 6 */
        }
        if (e[col - 3] != 0xFF || e[col - 2] != 0xFF) return;  /* 018926 */
    }
}

/* @018962-018966 sub_18962 grp_code_entry Confirmed: r1l = FF8B7E then falls into sub_18966 */
u8 *grp_code_entry(void) { return grp_code_entry_n(r2_grp_code_idx_8B7E); }

/* @018966-018976 sub_18966 grp_code_entry_n Confirmed: er1 = 0xFF8B80 + idx * 9 */
u8 *grp_code_entry_n(u8 idx) { return r2_grp_code_8B80 + idx * 9; }

/* @01897C-0189A2 sub_1897C grp_code_dial Inferred: row 1 selects the entry (record 0x0189A2, B3F5 mirrors it); columns >= 2 step a character with the wildcard charset (sub_189A8, last index 8) */
void grp_code_dial(rec_t *rec)
{
    u8 lvl = menu_level_or_list(rec);
    if (lvl == 0) return;
    if (lvl == 1) { edit_cursor_max = dial_step_wrap_dirty(&rec_189A2); return; }
    text_char_step_wild(grp_code_entry(), lvl - 2, 8);
}

/* @0189A8-0189B2 sub_189A8 text_char_step_wild Confirmed: dirty; mode AD81 = 1 (charset also offers '*'), then joins sub_189B2 at loc_189BA */
u8 text_char_step_wild(u8 *buf, u8 i, u8 last) { ui_flags |= 0x40; return text_char_step_mode(buf, i, last, 1); }

/* --------------------------------------------------------------------------
 * @0189B2-018A32 sub_189B2 text_char_step Confirmed: callsign-style character step: dirty, mode AD81 = 0; interior positions cycle through upper-case letters / digits (charset 0x018A4A, or 0x018A56 with '*' in wildcard mode) and an empty slot seeds 'A'; the last position (i == last) or a position followed by an empty one may also become empty (space -> 0xFF, charset 0x018A50).  Sets AA30.7; returns the char in r3l
 * -------------------------------------------------------------------------- */
u8 text_char_step(u8 *buf, u8 i, u8 last) { ui_flags |= 0x40; return text_char_step_mode(buf, i, last, 0); }
static u8 text_char_step_mode(u8 *buf, u8 i, u8 last, u8 wild)   /* 0189BA */
{
    char_mode_AD81 = wild;
    u8 *p = buf + i, c = *p;
    dial_scratch = c;
    if (i == last || (s8)p[1] < 0) {                      /* 0189FA: tail position */
        if ((s8)c < 0) dial_scratch = ' ';
        for (;;) {
            c = dial_step_wrap(&rec_18A50);
            if (c == ' ') { c = 0xFF; break; }
            if (char_mode_AD81 && c == '*') break;
            if (!is_not_alnum(c)) break;
        }
    } else if ((s8)c < 0) {
        c = 'A';                                          /* 018A26 */
    } else {
        for (;;) {
            if (char_mode_AD81) { c = dial_step_wrap(&rec_18A56); if (c == '*') break; }
            else                  c = dial_step_wrap(&rec_18A4A);
            if (!is_not_alnum(c)) break;
        }
    }
    *p = c;
    ui_flags |= 0x80;
    return c;
}

/* @018A32-018A4A sub_18A32 is_not_alnum Confirmed: returns 0 (Z) for '0'..'9' or 'A'..'Z', else 1 */
u8 is_not_alnum(u8 c)                                     /* 018A32 */
{
    if (c >= '0' && c <= '9') return 0;
    if (c >= 'A' && c <= 'Z') return 0;
    return 1;
}

/* @018A5C-018A74 sub_18A5C grp_code_key_delete Inferred: columns >= 2: sub_1A90E(group-code entry, col-2, 9); dirty */
void grp_code_key_delete(rec_t *rec)
{
    if (!edit_level_ge2()) return;
    text_delete_char(grp_code_entry(), menu_level - 2, 9);
    ui_flags |= 0x40;
}

/* @018A7C-018A94 sub_18A7C edit_level_ge2 Confirmed: level 0 or 1 -> key_consume, return 0 (Z); otherwise nonzero */
u8 edit_level_ge2(void)
{
    u8 lvl = menu_level;
    if (lvl == 0 || lvl == 1) { key_consume(); return 0; }
    return 1;
}

/* @018AA6-018ABE sub_18AA6 grp_code_key_clear Inferred: columns >= 2: clear group-code entry to the end (sub_188F6, len 9); label 0x018AB8 = key_consume */
void grp_code_key_clear(rec_t *rec)
{
    if (!edit_level_ge2()) return;
    text_clear_from(grp_code_entry(), menu_level - 2, 9);
}

/* @018ABE-018AD2 sub_18ABE com_port_level_cb Inferred: level callback: if COM port STATUS (FF8C26.7) is ON -> sub_1A0A4, else refuse */
void com_port_level_cb(rec_t *rec) { if (r2_com_8C26 & 0x80) sub_1A0A4(rec); else key_consume(); }

/* @018AD2-018AF6 sub_18AD2 com_port_dial Confirmed: COM PORT SETTING dial: via sub_15206 (callback sub_18ABE) jumps through off_18B82[level] to the row handlers below */
void com_port_dial(rec_t *rec)
{
    if (menu_level_or_call(rec, com_port_level_cb) == 0) return;
    com_rows_18B82[menu_level](rec);                      /* jmp @er6 */
}

/* --------------------------------------------------------------------------
 * @018AF6-018AFE sub_18AF6 com_toggle_mice Confirmed: COM PORT row: toggle FF8C2A.0 (Mic-E), then the shared dirty tail loc_18B38
 * @018AFE-018B06 sub_18AFE com_toggle_position Confirmed: toggle FF8C2A.1 (POSITION)
 * @018B06-018B0E sub_18B06 com_toggle_weather Confirmed: toggle FF8C2A.2 (WEATHER)
 * @018B0E-018B16 sub_18B0E com_toggle_object Confirmed: toggle FF8C2A.3 (OBJECT)
 * @018B16-018B1E sub_18B16 com_toggle_item Confirmed: toggle FF8C2A.4 (ITEM)
 * Row names per doc 38 (COM PORT SETTING rows, FF8C26..FF8C2A).
 * -------------------------------------------------------------------------- */
void com_toggle_mice(rec_t *rec)     { r2_com_8C2A ^= 0x01; ui_flags |= 0x40; }
void com_toggle_position(rec_t *rec) { r2_com_8C2A ^= 0x02; ui_flags |= 0x40; }
void com_toggle_weather(rec_t *rec)  { r2_com_8C2A ^= 0x04; ui_flags |= 0x40; }
void com_toggle_object(rec_t *rec)   { r2_com_8C2A ^= 0x08; ui_flags |= 0x40; }
void com_toggle_item(rec_t *rec)     { r2_com_8C2A ^= 0x10; ui_flags |= 0x40; }

/* @018B1E-018B40 sub_18B1E com_toggle_status Confirmed: COM PORT STATUS: refused in node mode, else toggle FF8C26.7; label 0x018B32 toggles FF8C26.0 (INPUT); shared tail 0x018B38 marks dirty */
void com_toggle_status(rec_t *rec)
{
    if (node_mode) { key_consume(); return; }
    r2_com_8C26 ^= 0x80;  ui_flags |= 0x40;
}
void com_toggle_input(rec_t *rec) { r2_com_8C26 ^= 0x01; ui_flags |= 0x40; }   /* 018B32 */

/* @018B40-018B60 sub_18B40 com_step_speed Inferred: COM PORT SPEED: wrap-step record 0x018BAE, zero the serial registers FFFE92 / FFFE90 (3 nops), re-open the port (sub_45186) */
void com_step_speed(rec_t *rec)
{
    dial_step_wrap_dirty(&rec_18BAE);
    IO_FE92 = 0;  IO_FE90 = 0;                            /* 018B4C / 018B50 */
    sub_45186();
}

/* @018B60-018B80 sub_18B60 com_step_output Inferred: COM PORT OUTPUT: wrap-step record 0x018BB4, or 0x018BBA (more choices: DSP H/A/D) when FF89C4.4 (RAM DISPLAY flag) is set; label 0x018B76 uses record 0x018BC6 */
void com_step_output(rec_t *rec)
{
    dial_step_wrap_dirty((r1_set_89C4 & 0x10) ? &rec_18BBA : &rec_18BB4);
}
void com_step_18BC6(rec_t *rec) { dial_step_wrap_dirty(&rec_18BC6); }       /* 018B76 */

/* @018B80-018B82 nullsub_84 com_nop_18B80 Confirmed: rts (shared return of the COM rows) */
void com_nop_18B80(rec_t *rec) { }

/* @018BE8-018C40 sub_18BE8 aprs_popup_dial Inferred: APRS POPUP rows (sub_15206, callback 0x01A094): steps byte FF8C2D[row] (-0x73D3) with record 0x018C40; rows 12..16 (index 0x0B..0x0F) skip values 1..9 and 0x12 */
void aprs_popup_dial(rec_t *rec)
{
    u8 lvl = menu_level_or_call(rec, setup_cb_1A094);
    if (lvl == 0) return;
    dial_scratch = r2_popup_8C2D[lvl];
    u8 row = lvl - 1, v;
    if (row >= 0x0B && row <= 0x0F) {
        do v = dial_step_wrap_dirty(&rec_18C40);
        while (v != 0 && (v < 0x0A || v == 0x12));
    } else v = dial_step_wrap_dirty(&rec_18C40);
    r2_popup_8C2D[lvl] = v;
}

/* @018C46-018CA0 sub_18C46 msg_grp_cursor Inferred: cursor in the 10-byte call entries FF8C58 + FF8C56*10 (record 0x018CB4): column >= 8 needs a non-empty call (else back to 2/1), columns 3..7 skip double gaps (forced to 8) */
void msg_grp_cursor(rec_t *rec)
{
    u8 *e = msg_grp_entry();
    for (;;) {
        u8 col = cursor_step_19F3A(&rec_18CB4);
        if (col == 0 || col < 3) return;
        if (col >= 8) {
            if ((s8)e[0] >= 0) return;
            menu_level = (key_flags & 0x01) ? 2 : 1;
            return;
        }
        if (e[col - 3] != 0xFF || e[col - 2] != 0xFF) return;
        if (key_flags & 0x01) continue;
        if ((s8)e[0] < 0) continue;
        menu_level = 8;  return;
    }
}

/* @018CA0-018CB4 sub_18CA0 msg_grp_entry Confirmed: er1 = 0xFF8C58 + FF8C56 * 10 */
u8 *msg_grp_entry(void) { return r2_msg_grp_8C58 + r2_msg_grp_idx_8C56 * 10; }

/* @018CBA-018CCE sub_18CBA msg_grp_dial Inferred: row 1 -> record 0x018D0C; column 8 -> SSID entry[6] (record 0x0187F0); falls into sub_18CCE for call characters */
void msg_grp_dial(rec_t *rec)
{
    u8 lvl = menu_level_or_list(rec);
    if (lvl == 0) return;
    if (lvl == 1) { dial_step_wrap_dirty(&rec_18D0C); return; }
    u8 *e = msg_grp_entry();
    if (lvl == 8) { dial_scratch = e[6]; e[6] = dial_step_wrap_dirty(&rec_187F0); return; }
    msg_grp_char(e, lvl - 2);
}

/* @018CCE-018D0C sub_18CCE msg_grp_char Inferred: sub_189B2(entry, col, last 5); an emptied call clears entry[6]; also holds the SSID (0x018CE8) and row-1 (0x018D00) steps of sub_18CBA */
void msg_grp_char(u8 *e, u8 i)
{
    text_char_step(e, i, 5);
    if ((s8)e[0] < 0) e[6] = 0;
}

/* @018D12-018D42 sub_18D12 msg_grp_key_delete Inferred: columns 2..7: sub_1A90E(entry, col-2, 6); dirty */
void msg_grp_key_delete(rec_t *rec)
{
    u8 lvl = menu_level;
    if (lvl == 0 || lvl < 2 || lvl == 8) { key_consume(); return; }
    text_delete_char(msg_grp_entry(), lvl - 2, 6);
    ui_flags |= 0x40;
}

/* @018D42-018D6E sub_18D42 beacon_info_dial Inferred: row 1 -> record 0x018D6E; rows >= 2 toggle bit (row-2) of FF8CF9 (display option bits, doc 38); dirty */
void beacon_info_dial(rec_t *rec)
{
    u8 lvl = menu_level_or_call(rec, sub_1A0B4);
    if (lvl == 0) return;
    if (lvl == 1) { dial_step_wrap_dirty(&rec_18D6E); return; }
    r2_8CF9 ^= (u8)(1u << (lvl - 2));
    ui_flags |= 0x40;
}

/* --------------------------------------------------------------------------
 * @018D74-018E68 sub_18D74 autoreply_cursor Inferred: auto-reply editor cursor (sub-cursor AD99): row 2 moves inside the reply-to call FF8CFC (record 0x018E68 via sub_19F54, SSID column 7, double-gap skip); rows >= 3 move in the reply text FFADDE and re-scroll (sub_1A246, layout 0x017CD4 / 0x017CE2 by FF8C2C.1)
 * -------------------------------------------------------------------------- */
void autoreply_cursor(rec_t *rec)                         /* 018D74 */
{
    u8 lvl = menu_level;
    if (lvl == 0 || lvl == 1) { key_consume(); return; }
    if (lvl == 2) {
        u8 *call = r2_ar_call_8CFC;
        for (;;) {
            u8 col = cursor_step_19F54(call, &rec_18E68);
            if (col == 0 || col < 2) return;
            if (col >= 7) {
                if ((s8)call[0] >= 0) return;
                sub_cursor_AD99 = (key_flags & 0x01) ? 1 : 0;
                return;
            }
            if (call[col - 2] != 0xFF || call[col - 1] != 0xFF) return;
            if (key_flags & 0x01) continue;
            if ((s8)call[0] < 0) continue;
            sub_cursor_AD99 = 7;  return;
        }
    }
    u8 page = 0;
    if (key_event != 4 && list_top_A4F5 == 0 && sub_cursor_AD99 == 0) page = 1;
    win_mode_B091 = page;
    if (key_event == 4 || !(list_top_A4F5 == 1 && sub_cursor_AD99 == 1 && (list_top_A4F5 = 0, 1))) {
        text_cursor_1A246(rec);
        text_window_scroll((r2_set_8C2C & 0x02) ? layout_17CD4 : layout_17CE2, sub_cursor_AD99);
    }
    ui_A507 = 0;  ui_B090 = 0;  ui_A9F7 &= ~0x01;  ui_9542 = 0;
}

/* --------------------------------------------------------------------------
 * @018E6E-018EC4 sub_18E6E autoreply_dial Inferred: auto-reply dial (sub_15206 cb sub_1A0B4): row 1 -> record 0x018F10; row 2 -> reply-to call: SSID column 7 (record 0x018F1C) or wildcard char step (sub_189A8), an empty result becomes '*' (up) / 'Z' (down); row 3 -> column 0 reloads the text slot (sub_508B6, save sub_19702, record 0x018F16, load sub_3D5E4), other columns step text chars at FFADDE (sub_17E3C)
 * -------------------------------------------------------------------------- */
void autoreply_dial(rec_t *rec)                           /* 018E6E */
{
    u8 lvl = menu_level_or_call(rec, sub_1A0B4);
    if (lvl == 0) return;
    if (lvl == 1) { dial_step_wrap_dirty(&rec_18F10); return; }
    if (lvl == 2) {
        u8 c = sub_cursor_AD99;
        if (c == 0) { key_consume(); return; }
        if (c == 7) { u8 *e = r2_ar_call_8CFC; dial_scratch = e[6]; e[6] = dial_step_wrap_dirty(&rec_18F1C); return; }
        autoreply_call_char(r2_ar_call_8CFC, c - 1);      /* sub_18EC4 */
        return;
    }
    if (sub_cursor_AD99 == 0) {
        sub_508B6();  exit_AF_autoreply(rec);
        dial_step_wrap_dirty(&rec_18F16);
        sub_3D5E4();
        return;
    }
    text_char_step_7E3C(ar_text_ADDE, sub_cursor_AD99 - 1);
}

/* @018EC4-018F10 sub_18EC4 autoreply_call_char Inferred: wildcard char step (sub_189A8, last 5); a resulting 0xFF is replaced by '*' (up) or 'Z' (down); also holds the SSID / row-1 cases of sub_18E6E */
void autoreply_call_char(u8 *call, u8 i)
{
    u8 c = text_char_step_wild(call, i, 5);
    if (c == 0xFF) call[i] = (key_flags & 0x01) ? 'Z' : '*';
}

/* @018F22-018F4E sub_18F22 autoreply_call_changed Confirmed: A51C = (the 10 bytes at FF8CFC differ from the ROM default at 0x00F7FA) */
void autoreply_call_changed(void)                         /* 018F22 */
{
    aprs_A51C = memcmp(r2_ar_call_8CFC, rom_default_F7FA, 10) != 0;
}

/* @018F4E-018FA2 sub_18F4E autoreply_key_delete Inferred: row 3 text: sub_1A88E(FFADDE, AD99-1, 0x43); row 2 call (columns 1..6): sub_1A924(FF8CFC, AD99-1, 6); dirty */
void autoreply_key_delete(rec_t *rec)
{
    u8 lvl = menu_level, c = sub_cursor_AD99;
    if (lvl == 0 || lvl < 2 || c == 0) goto refuse;
    if (lvl != 2) { text_delete_1A88E(ar_text_ADDE, c - 1, 0x43); ui_flags |= 0x40; return; }
    if (c == 7) goto refuse;
    text_delete_1A924(r2_ar_call_8CFC, c - 1, 6);
    ui_flags |= 0x40;
    return;
refuse:
    key_consume();
}

/* @018FA2-018FB8 sub_18FA2 aprs_toggle_8AAB Confirmed: FF8AAB ^= 1<<r4l; entry 0x018FAA toggles FF8AAC instead; both mark dirty */
void aprs_toggle_8AAB(u8 bit) { r2_set_8AAB ^= (u8)(1u << bit); ui_flags |= 0x40; }   /* 018FA2 */
void aprs_toggle_8AAC(u8 bit) { r2_set_8AAC ^= (u8)(1u << bit); ui_flags |= 0x40; }   /* 018FAA */

/* @018FB8-018FC6 sub_18FB8 callsign_clear_tail Confirmed: call_clear_to_end(FF8AA2, mode 0x0E, base 1) */
void callsign_clear_tail(rec_t *rec) { call_clear_to_end(r2_callsign_8AA2, 0x0E, 1); }

/* @018FD0-018FD8 sub_18FD0 call_clear_longpress Confirmed: only on a long press (A9EE.7), else refuse; falls into sub_18FD8 */
void call_clear_longpress(u8 *call, u8 mode, u8 base)
{
    if (!(key_flags & 0x80)) { key_consume(); return; }
    call_clear_to_end(call, mode, base);
}

/* --------------------------------------------------------------------------
 * @018FD8-01901C sub_18FD8 call_clear_to_end Confirmed: clears a 6-char call + SSID from the cursor: at the SSID column (base+6) only the SSID is zeroed; otherwise chars from the cursor to the end become 0xFF and, at the first column, the SSID is zeroed too; mode 0x0E also refreshes the editor
 * -------------------------------------------------------------------------- */
void call_clear_to_end(u8 *call, u8 mode, u8 base)        /* 018FD8 */
{
    u8 lvl = menu_level;
    if (lvl < base) { key_consume(); return; }
    if (lvl != base + 6) {
        u8 *p = call + 6, n = 6 + base - lvl;
        do { *--p = 0xFF; } while (--n);
        if (menu_level != base) goto done;
    }
    call[6] = 0;
done:
    if (mode == 0x0E) text_edit_refresh();
}

/* @01901C-01903C sub_1901C digipath_key_clear_long Inferred: in hop state (BC03 >= 2) of a full path: long-press clear of the current hop call from column 3; otherwise menu_exit_all (loc_1905A) */
void digipath_key_clear_long(rec_t *rec)
{
    if (ui_BC03 == 0 || ui_BC03 == 1 || r2_digipath_8BE5 < 3) { menu_exit_all(rec); return; }
    call_clear_longpress(digipath_entry(), 0x0E, 3);
}

/* @01903C-019060 sub_1903C digipath_key_clear Inferred: full path, column >= 3: clear the hop call (no long-press check); else return (loc_1901A) */
void digipath_key_clear(rec_t *rec)
{
    if (r2_digipath_8BE5 < 3) return;
    if (menu_level < 3) return;
    call_clear_to_end(digipath_entry(), 0x0E, 3);
}

/* @019060-019070 sub_19060 msg_grp_key_clear_long Confirmed: long-press clear of the message-group call entry from column 2 */
void msg_grp_key_clear_long(rec_t *rec) { call_clear_longpress(msg_grp_entry(), 0x0E, 2); }

/* @019070-01909A sub_19070 autoreply_key_clear Inferred: row 2 with a sub-cursor: clear the reply-to call FF8CFC with wildcards (sub_1909A, base 1) */
void autoreply_key_clear(rec_t *rec)
{
    if (menu_level != 2 || sub_cursor_AD99 == 0) { key_consume(); return; }
    call_wild_clear(r2_ar_call_8CFC, 0x0E, 1);
}

/* @01909A-0190E6 sub_1909A call_wild_clear Confirmed: like sub_18FD8 but uses AD99 as the cursor, needs a long press, fills with '*' and sets the SSID byte to 0x10 */
void call_wild_clear(u8 *call, u8 mode, u8 base)          /* 01909A */
{
    if (!(key_flags & 0x80)) { key_consume(); return; }
    u8 c = sub_cursor_AD99;
    if (c < base) { key_consume(); return; }
    if (c != base + 6) {
        u8 *p = call + 6, n = 6 + base - c;
        do { *--p = '*'; } while (--n);
        if (sub_cursor_AD99 != base) goto done;
    }
    call[6] = 0x10;
done:
    if (mode == 0x0E) text_edit_refresh();
}

/* @0190E6-0190F2 sub_190E6 dial_D7 Confirmed: screen 0xD7 (hidden group 13): wrap-step record 0x0190F2 (R2 n=0x18B) */
void dial_D7(rec_t *rec) { dial_step_wrap_dirty(&rec_190F2); }

/* @0190F8-019100 sub_190F8 toggle_AFF4_b0 Confirmed: AFF4 ^= 0x01 */
void toggle_AFF4_b0(void) { ui_AFF4 ^= 0x01; }

/* --------------------------------------------------------------------------
 * @019100-019158 sub_19100 hidden_digit_sequence_ui10 Confirmed: in UI mode 0x10 (word FF8F2C) collects up to 4 typed digits in AD8E; 08030706 posts event 0x16 to AAE0 (doc 49 calls this "requests UI mode 0x16"; the code only writes AAE0)
 * -------------------------------------------------------------------------- */
void hidden_digit_sequence_ui10(rec_t *rec)               /* 019100 */
{
    if (ui_mode_8F2C != 0x10) goto refuse;
    u8 d = key_digit;
    if (d == 0) goto refuse;
    int i;
    for (i = 0; i < 4; i++) if (seq_buf_AD8E[i] == 0) break;
    if (i < 3) { seq_buf_AD8E[i] = d; goto refuse; }
    if (i == 4) goto refuse;
    seq_buf_AD8E[3] = d;
    if (*(u32 *)seq_buf_AD8E != 0x08030706) goto refuse;
    tone_ev = 0x16;
    return;
refuse:
    key_consume();
}

/* --------------------------------------------------------------------------
 * @019158-019208 sub_19158 setup_run_exit_handler Confirmed: if the value changed (AA30.6) runs exit handler 0x148A0+BE16[0x019A9E+2*(id-0x0E)] (ids 0xD8..0xDB use fixed slots 0xCA..0xCD); then resets the menu state, undoes the screen-0x42 pull-up and stops a running tone search
 * Callers: 0x0152B0, 0x015B4E, 0x015B8E, sub_15948, sub_15A02, sub_15A96,
 * sub_3FF3A (pop).  doc 49 sec.3 describes the table.
 * -------------------------------------------------------------------------- */
void setup_run_exit_handler(rec_t *rec)                   /* 019158 */
{
    if (ui_flags & 0x40) {
        u8 id = rec->screen;
        u32 off;
        if      (id == 0xD8) off = 0x194;                 /* fixed slots avoid the */
        else if (id == 0xD9) off = 0x196;                 /* loc_14C90 side effect */
        else if (id == 0xDA) off = 0x198;                 /* of sub_15E42          */
        else if (id == 0xDB) off = 0x19A;
        else off = (u32)setup_dial_index(rec) << 1;       /* 01918C */
        ((handler_t)(0x148A0 + *(const u16 *)((const u8 *)exit_tbl_19A9E + off)))(rec);
        ui_flags &= ~0x40;
    }
    menu_subpage = 0;  menu_level = 0;
    edit_row_B054 = 0;  edit_col_B055 = 1;
    sub_508B6();
    if (ui_flags_AA32 & 0x08) { ui_flags_AA32 &= ~0x08; PORT_FBA5 &= 0xF0; }
    if (band_sel & 0x40) { if (tsearch_b_active) tsearch_b_state = 3; }
    else                 { if (tsearch_a_active) tsearch_a_state = 3; }
}

/* @019208-019250 sub_19208 exit_6B_sql_level Confirmed: SQL LEVEL save: A records save the 2-byte pair FF8970 (FM) or FF8972 (AM, +0x19==2); the B-slot record saves R1 n=0x54 (FM) or 0x55 (AM) */
void exit_6B_sql_level(rec_t *rec)
{
    if (rec == REC_B_SLOT) { eep_save_r1(rec->rxmode19 == 2 ? 0x55 : 0x54); return; }
    eep_save_r1_block(rec->rxmode19 == 2 ? 0xFF8972 : 0xFF8970, 2);
}

/* @019250-019258 sub_19250 exit_19250 Confirmed: exit/save stub: eep_save_r1(0x73) [exit slot x0F:APO] */
void exit_19250(rec_t *rec) { eep_save_r1(0x73); }

/* @019258-019260 sub_19258 exit_19258 Confirmed: exit/save stub: eep_save_r1(0x74) [exit slot x10] */
void exit_19258(rec_t *rec) { eep_save_r1(0x74); }

/* @019260-019270 sub_19260 exit_19260 Confirmed: exit/save stub: eep_save_r1(0x77) eep_save_r1(0x9F) [exit slot x15:BEEP] */
void exit_19260(rec_t *rec) { eep_save_r1(0x77); eep_save_r1(0x9F); }

/* @019270-019278 sub_19270 exit_19270 Confirmed: exit/save stub: eep_save_r1(0x75) [exit slot x16:BELL x17] */
void exit_19270(rec_t *rec) { eep_save_r1(0x75); }

/* @019278-019280 sub_19278 exit_19278 Confirmed: exit/save stub: eep_save_r1(0x76) [exit slot x18:BEEP LEVEL] */
void exit_19278(rec_t *rec) { eep_save_r1(0x76); }

/* @019280-019288 sub_19280 exit_19280 Confirmed: exit/save stub: eep_save_r1(0x80) [exit slot x22] */
void exit_19280(rec_t *rec) { eep_save_r1(0x80); }

/* @019288-019290 sub_19288 exit_19288 Confirmed: exit/save stub: eep_save_r1(0x84) [exit slot x28:LCD DIMMER] */
void exit_19288(rec_t *rec) { eep_save_r1(0x84); }

/* @019290-0192A0 sub_19290 exit_19290 Confirmed: exit/save stub: eep_save_r1(0x85) eep_save_r1(0x9E) [exit slot x2B:DTMF MODE] */
void exit_19290(rec_t *rec) { eep_save_r1(0x85); eep_save_r1(0x9E); }

/* @0192B0-0192B8 sub_192B0 exit_192B0 Confirmed: exit/save stub: eep_save_r1(0x87) [exit slot x3E] */
void exit_192B0(rec_t *rec) { eep_save_r1(0x87); }

/* @0192B8-0192C4 sub_192B8 exit_192B8 Confirmed: exit/save stub: eep_save_r1(0x8A) eep_save_r1(0xA5)   /* bra 0x0193D2 */ [exit slot x40:LAMP] */
void exit_192B8(rec_t *rec) { eep_save_r1(0x8A); eep_save_r1(0xA5);   /* bra 0x0193D2 */ }

/* @0192C4-0192CC sub_192C4 exit_192C4 Confirmed: exit/save stub: eep_save_r1(0x89) [exit slot x41:LANGUAGE] */
void exit_192C4(rec_t *rec) { eep_save_r1(0x89); }

/* @0192CC-0192D4 sub_192CC exit_192CC Confirmed: exit/save stub: eep_save_r1(0x8B) [exit slot x43:LOCK] */
void exit_192CC(rec_t *rec) { eep_save_r1(0x8B); }

/* @0192D4-0192DC sub_192D4 exit_192D4 Confirmed: exit/save stub: eep_save_r1(0x8D) [exit slot x45:MIC GAIN] */
void exit_192D4(rec_t *rec) { eep_save_r1(0x8D); }

/* @0192DC-0192E4 sub_192DC exit_192DC Confirmed: exit/save stub: eep_save_r1(0x8C) [exit slot x49] */
void exit_192DC(rec_t *rec) { eep_save_r1(0x8C); }

/* @0192E4-0192EC sub_192E4 exit_192E4 Confirmed: exit/save stub: eep_save_r1(0x93) [exit slot x4E:MUTE] */
void exit_192E4(rec_t *rec) { eep_save_r1(0x93); }

/* @0192EC-0192F4 sub_192EC exit_192EC Confirmed: exit/save stub: eep_save_r1(0x90) [exit slot x56:PTT DELAY] */
void exit_192EC(rec_t *rec) { eep_save_r1(0x90); }

/* @0192F4-0192FC sub_192F4 exit_192F4 Confirmed: exit/save stub: eep_save_r1(0x8F) [exit slot x58:DW TIME] */
void exit_192F4(rec_t *rec) { eep_save_r1(0x8F); }

/* @0192FC-01930A sub_192FC exit_192FC Confirmed: exit/save stub: eep_save_r1_block(0xFF8990, 2) [exit slot x5A:SCAN RESUME] */
void exit_192FC(rec_t *rec) { eep_save_r1_block(0xFF8990, 2); }

/* @01930A-019312 sub_1930A exit_1930A Confirmed: exit/save stub: eep_save_r1(0x92) [exit slot x5B:SCAN RE-START] */
void exit_1930A(rec_t *rec) { eep_save_r1(0x92); }

/* @019312-01931A sub_19312 exit_19312 Confirmed: exit/save stub: eep_save_r1(0x96) [exit slot x5C:SENSOR INFO] */
void exit_19312(rec_t *rec) { eep_save_r1(0x96); }

/* @01931A-019322 sub_1931A exit_1931A Confirmed: exit/save stub: eep_save_r1(0x91) [exit slot x60:SAVE RX] */
void exit_1931A(rec_t *rec) { eep_save_r1(0x91); }

/* @019322-01932A sub_19322 exit_19322 Confirmed: exit/save stub: eep_save_r1(0x97) [exit slot x65] */
void exit_19322(rec_t *rec) { eep_save_r1(0x97); }

/* @01932A-019332 sub_1932A exit_1932A Confirmed: exit/save stub: eep_save_r1(0x95) [exit slot x66:DIAL KNOB CHANGE] */
void exit_1932A(rec_t *rec) { eep_save_r1(0x95); }

/* @019332-01933A sub_19332 exit_19332 Confirmed: exit/save stub: eep_save_r1(0x99) [exit slot x68:BAND SCOPE] */
void exit_19332(rec_t *rec) { eep_save_r1(0x99); }

/* @01933A-019342 sub_1933A exit_1933A Confirmed: exit/save stub: eep_save_r1(0x9A) [exit slot x73:TOT] */
void exit_1933A(rec_t *rec) { eep_save_r1(0x9A); }

/* @019342-01934A sub_19342 exit_19342 Confirmed: exit/save stub: eep_save_r1(0x72) [exit slot x6F:RX AF DUAL] */
void exit_19342(rec_t *rec) { eep_save_r1(0x72); }

/* @01934A-019352 sub_1934A exit_1934A Confirmed: exit/save stub: eep_save_r1(0xA7) [exit slot x80:APO x81] */
void exit_1934A(rec_t *rec) { eep_save_r1(0xA7); }

/* @019362-01936A sub_19362 exit_19362 Confirmed: exit/save stub: eep_save_r1(0xAC) [exit slot x85] */
void exit_19362(rec_t *rec) { eep_save_r1(0xAC); }

/* @01936A-01937A sub_1936A exit_1936A Confirmed: exit/save stub: eep_save_r1_block(0xFF89CD, 3) eep_save_r1(0xA5)   /* bra 0x0193D2 */ [exit slot x87:USB CAMERA] */
void exit_1936A(rec_t *rec) { eep_save_r1_block(0xFF89CD, 3); eep_save_r1(0xA5);   /* bra 0x0193D2 */ }

/* @01937A-019382 sub_1937A exit_1937A Confirmed: exit/save stub: eep_save_r1(0xB0) [exit slot x8B:GPS LOG] */
void exit_1937A(rec_t *rec) { eep_save_r1(0xB0); }

/* @019382-01938A sub_19382 exit_19382 Confirmed: exit/save stub: eep_save_r1(0xA8) [exit slot x1C:BUSY LED] */
void exit_19382(rec_t *rec) { eep_save_r1(0xA8); }

/* @01938A-019392 sub_1938A exit_1938A Confirmed: exit/save stub: eep_save_r1(0xAB) */
void exit_1938A(rec_t *rec) { eep_save_r1(0xAB); }

/* @019392-01939A sub_19392 exit_19392 Confirmed: exit/save stub: eep_save_r1(0x94) [exit slot xD4 xD5] */
void exit_19392(rec_t *rec) { eep_save_r1(0x94); }

/* @01939A-0193A2 sub_1939A exit_1939A Confirmed: exit/save stub: eep_save_r1(0x9E) [exit slot x12:RPT ARS x2A x2D x62:SCAN LAMP x6A:SQL EXPANSION x77 x7A:VFO MODE] */
void exit_1939A(rec_t *rec) { eep_save_r1(0x9E); }

/* @0193A2-0193AA sub_193A2 exit_193A2 Confirmed: exit/save stub: eep_save_r1(0x9F) [exit slot x14:BCLO x29 x30 x78] */
void exit_193A2(rec_t *rec) { eep_save_r1(0x9F); }

/* @0193AA-0193B2 sub_193AA exit_193AA Confirmed: exit/save stub: eep_save_r1(0xA0) [exit slot x2E x36 x44:MONI/T-CALL x61] */
void exit_193AA(rec_t *rec) { eep_save_r1(0xA0); }

/* @0193B2-0193BA sub_193B2 exit_193B2 Confirmed: exit/save stub: eep_save_r1(0xA1) [exit slot x11 x4A:MEMORY WRITE x4B:MEMORY PROTECT] */
void exit_193B2(rec_t *rec) { eep_save_r1(0xA1); }

/* @0193BA-0193C2 sub_193BA exit_193BA Confirmed: exit/save stub: eep_save_r1(0xA2) [exit slot x3F:LANGUAGE x71:DATE & TIME ADJ x7B x8F:WX ALERT] */
void exit_193BA(rec_t *rec) { eep_save_r1(0xA2); }

/* @0193C2-0193CA sub_193C2 exit_193C2 Confirmed: exit/save stub: eep_save_r1(0xA3) [exit slot x0E x32 x33 x34 x37:HOME VFO x57:PRIORITY REVERT x6E] */
void exit_193C2(rec_t *rec) { eep_save_r1(0xA3); }

/* @0193CA-0193D2 sub_193CA exit_193CA Confirmed: exit/save stub: eep_save_r1(0xA4) [exit slot x67] */
void exit_193CA(rec_t *rec) { eep_save_r1(0xA4); }

/* @0193D2-0193DA sub_193D2 exit_193D2 Confirmed: exit/save stub: eep_save_r1(0xA5) [exit slot x59:SCAN WIDTH x8E:TARGET LOCATION] */
void exit_193D2(rec_t *rec) { eep_save_r1(0xA5); }

/* @0193DA-0193DC sub_193DA exit_none Confirmed: rts - exit slot of the ~40 items that save nothing */
void exit_none(rec_t *rec) { }

/* @0193DC-0193EA sub_193DC exit_193DC Confirmed: exit/save stub: eep_save_r1_block(0xFF89BB, 2) [exit slot x7C:VOX] */
void exit_193DC(rec_t *rec) { eep_save_r1_block(0xFF89BB, 2); }

/* @0193EA-0193F8 sub_193EA exit_193EA Confirmed: exit/save stub: eep_save_r1_block(0xFF89D1, 2) [exit slot x7D:RECORDING] */
void exit_193EA(rec_t *rec) { eep_save_r1_block(0xFF89D1, 2); }

/* @0193F8-019406 sub_193F8 exit_193F8 Confirmed: exit/save stub: eep_save_r1_block(0xFF8A58, 2) */
void exit_193F8(rec_t *rec) { eep_save_r1_block(0xFF8A58, 2); }

/* @019406-019426 sub_19406 exit_8C_tx_power Inferred: TX POWER: memory mode -> store the channel (sub_3F21A + sub_3A9F6); rec[5]==5 -> sub_3AA66(rec[3]) */
void exit_8C_tx_power(rec_t *rec)
{
    if (rec->vfo_mode == 2) { sub_3A9F6(sub_3F21A(rec)); return; }
    if (rec->vfo_mode == 5) sub_3AA66(rec->band03);
}

/* @019426-019444 sub_19426 exit_13_antenna_att Confirmed: memory mode with a channel (sub_3F1DC != 0): save the ATT bitmap FF8976 (2 bytes) */
void exit_13_antenna_att(rec_t *rec)
{
    if (rec->vfo_mode == 2 && sub_3F1DC(rec)) eep_save_r1_block(0xFF8976, 2);
}

/* @019444-019454 sub_19444 exit_19 Confirmed: just clears AA30.6 */
void exit_19(rec_t *rec) { if (ui_flags & 0x40) ui_flags &= ~0x40; }

/* @019454-01946C sub_19454 exit_1B_bank Inferred: if changed: clear AA30.6 and save bank AD6C via sub_3CD5C */
void exit_1B_bank(rec_t *rec)
{
    if (!(ui_flags & 0x40)) return;
    ui_flags &= ~0x40;
    sub_3CD5C(ui_AD6C);
}

/* @01946C-019474 sub_1946C exit_1946C Confirmed: exit/save stub: eep_save_r1(0x0) [exit slot x1E:Bluetooth x1F:Bluetooth Save] */
void exit_1946C(rec_t *rec) { eep_save_r1(0x0); }

/* @019474-01948A sub_19474 exit_19474 Confirmed: exit/save stub: eep_save_r1_block(0xFF8926, 16) eep_save_r1(0x9E) [exit slot x21] */
void exit_19474(rec_t *rec) { eep_save_r1_block(0xFF8926, 16); eep_save_r1(0x9E); }

/* @01948A-0194AE sub_1948A exit_1948A Confirmed: exit/save stub: eep_save_r1_block(0xFF8999, 7) eep_save_r1_block(0xFF89C1, 1) eep_save_r1(0xA0) [exit slot x23] */
void exit_1948A(rec_t *rec) { eep_save_r1_block(0xFF8999, 7); eep_save_r1_block(0xFF89C1, 1); eep_save_r1(0xA0); }

/* @0194AE-0194D2 sub_194AE exit_194AE Confirmed: exit/save stub: eep_save_r1_block(0xFF89A1, 1) eep_save_r1_block(0xFF89A2, 1) eep_save_r1(0xA0) [exit slot x24] */
void exit_194AE(rec_t *rec) { eep_save_r1_block(0xFF89A1, 1); eep_save_r1_block(0xFF89A2, 1); eep_save_r1(0xA0); }

/* @0194D2-0194E8 sub_194D2 exit_194D2 Confirmed: exit/save stub: eep_save_r1_block(0xFF8956, 18) eep_save_r1(0x35) [exit slot x51] */
void exit_194D2(rec_t *rec) { eep_save_r1_block(0xFF8956, 18); eep_save_r1(0x35); }

/* @0194E8-01950E sub_194E8 exit_2C_dtmf Confirmed: if changed: clear AA30.6, write DTMF memory FF8936 (sub_3CE5A) and save the slot byte */
void exit_2C_dtmf(rec_t *rec)
{
    if (!(ui_flags & 0x40)) return;
    ui_flags &= ~0x40;
    sub_3CE5A(r1_set_8936);
    eep_save_r1_block(0xFF8936, 1);
}

/* @01950E-019516 sub_1950E exit_1950E Confirmed: exit/save stub: eep_save_r1(0x9F) [exit slot x4C] */
void exit_1950E(rec_t *rec) { eep_save_r1(0x9F); }

/* @019516-01954A sub_19516 exit_4D Inferred: sets rec+0x12.7 and stores the record: rec[5]==5 -> sub_3A8E2(rec[3]); memory -> sub_3A922(sub_3F21A()) */
void exit_4D(rec_t *rec)
{
    if (rec->vfo_mode == 2) { rec->flags12 |= 0x80; sub_3A922(sub_3F21A(rec)); return; }
    if (rec->vfo_mode == 5) { rec->flags12 |= 0x80; sub_3A8E2(rec->band03); }
}

/* @01954A-01956E sub_1954A exit_1954A Confirmed: exit/save stub: eep_save_r1_block(0xFF8988, 2) eep_save_r1_block(0xFF898A, 2) eep_save_r1(0xA1) [exit slot x4F:TIMER] */
void exit_1954A(rec_t *rec) { eep_save_r1_block(0xFF8988, 2); eep_save_r1_block(0xFF898A, 2); eep_save_r1(0xA1); }

/* @01956E-019584 sub_1956E exit_1956E Confirmed: exit/save stub: eep_save_r1_block(0xFF898A, 2) eep_save_r1(0xA1) [exit slot x50] */
void exit_1956E(rec_t *rec) { eep_save_r1_block(0xFF898A, 2); eep_save_r1(0xA1); }

/* @019584-01959A sub_19584 exit_19584 Confirmed: exit/save stub: eep_save_r1_block(0xFF8968, 4) eep_save_r1(0xA3) [exit slot x52:PAGER x53 x54] */
void exit_19584(rec_t *rec) { eep_save_r1_block(0xFF8968, 4); eep_save_r1(0xA3); }

/* @01959A-0195D2 sub_1959A exit_55_password Confirmed: if edited (AA34.6): clear it; if all 4 digits set (sub_16A44), copy AD8A -> FF896C and save it (4 bytes) plus R1 n=0xA2 */
void exit_55_password(rec_t *rec)
{
    if (!(ui_flags_AA34 & 0x40)) return;
    ui_flags_AA34 &= ~0x40;
    if (!pw_all_set()) return;
    r1_pw_896C = *(u32 *)(pw_buf_AD88 + 2);
    eep_save_r1_block(0xFF896C, 4);
    eep_save_r1(0xA2);
}

/* @0195D2-01961E sub_195D2 exit_6C_sql_type Inferred: special memory channels keep a per-channel SQL type: type 7 -> window ACE2 (sub_3CECC / sub_3CEDC), type 4 -> sub_3CE9A / sub_3CEAA; ACE2[ch] = rec+0x16 */
void exit_6C_sql_type(rec_t *rec)
{
    if (rec->vfo_mode != 2) return;
    u8 t = sub_3F1DC(rec);
    if (t == 7) { sub_3CECC(); chx_ACE2[sub_3F21A(rec)] = rec->sqltype16; sub_3CEDC(); }
    else if (t == 4) { sub_3CE9A(); chx_ACE2[sub_3F21A(rec)] = rec->sqltype16; sub_3CEAA(); }
}

/* @01961E-01962C sub_1961E exit_72_tone_freq Confirmed: chan_extra_store(offset 0x14, rec+0x17) */
void exit_72_tone_freq(rec_t *rec) { chan_extra_store(rec, 0x14, rec->f17); }

/* @01962C-01963A sub_1962C exit_26_dcs_code Confirmed: chan_extra_store(offset 0x28, rec+0x18) */
void exit_26_dcs_code(rec_t *rec) { chan_extra_store(rec, 0x28, rec->f18); }

/* @01963A-019664 sub_1963A chan_extra_store Confirmed: for a type-7 memory channel: ACE2[ch + off] = v inside sub_3CECC / sub_3CEDC */
void chan_extra_store(rec_t *rec, u32 off, u8 v)
{
    if (rec->vfo_mode != 2 || sub_3F1DC(rec) != 7) return;
    sub_3CECC();
    chx_ACE2[sub_3F21A(rec) + off] = v;
    sub_3CEDC();
}

/* @019664-019674 sub_19664 exit_19664 Confirmed: exit/save stub: eep_save_r1(0x9E) eep_save_r1(0x9F) [exit slot x76:TONE SEARCH] */
void exit_19664(rec_t *rec) { eep_save_r1(0x9E); eep_save_r1(0x9F); }

/* @019674-0196A0 sub_19674 exit_7F_pr_frequency Confirmed: type-4 memory channel: ACF6[ch] = rec+0x34 inside sub_3CE9A / sub_3CEAA */
void exit_7F_pr_frequency(rec_t *rec)
{
    if (rec->vfo_mode != 2 || sub_3F1DC(rec) != 4) return;
    u16 ch = sub_3F21A(rec);
    sub_3CE9A();
    chx_ACF6[ch] = rec->pr34;
    sub_3CEAA();
}

/* @0196A0-0196B0 sub_196A0 exit_196A0 Confirmed: exit/save stub: eep_save_r1_block(0xFF898C, 2) [exit slot x79] */
void exit_196A0(rec_t *rec) { eep_save_r1_block(0xFF898C, 2); }

/* @0196B0-0196C6 sub_196B0 exit_196B0 Confirmed: exit/save stub: eep_save_r1_block(0xFF898E, 2) eep_save_r1(0xA6) [exit slot xD6] */
void exit_196B0(rec_t *rec) { eep_save_r1_block(0xFF898E, 2); eep_save_r1(0xA6); }

/* @0196C6-0196D6 sub_196C6 exit_196C6 Confirmed: exit/save stub: eep_save_r1_block(0xFF8A1C, 4) [exit slot x1A:BANK LINK xDB] */
void exit_196C6(rec_t *rec) { eep_save_r1_block(0xFF8A1C, 4); }

/* @0196D6-019702 sub_196D6 exit_9B_status_text Confirmed: if changed: write status text slot FF8ABB (sub_3D5BC), save R2 block FF8AB9 x3, A984 = 0 */
void exit_9B_status_text(rec_t *rec)
{
    if (!(ui_flags & 0x40)) return;
    ui_flags &= ~0x40;
    sub_3D5BC(r2_8ABB);
    eep_save_r2_block(0xFF8AB9, 3);
    ui_A984 = 0;
}

/* @019702-01972C sub_19702 exit_AF_autoreply Confirmed: if changed: write auto-reply text slot FF8CFB (sub_3D5F4), save R2 block FF8CFA x0x0C, recompute A51C (sub_18F22) */
void exit_AF_autoreply(rec_t *rec)
{
    if (!(ui_flags & 0x40)) return;
    ui_flags &= ~0x40;
    sub_3D5F4(r2_8CFB);
    eep_save_r2_block(0xFF8CFA, 0x0C);
    autoreply_call_changed();
}

/* @01972C-01973E sub_1972C exit_A8_smartbeaconing Confirmed: if changed: clear AA30.6, then (sub_1973E) copy the edit block back when a type is selected and save */
void exit_A8_smartbeaconing(rec_t *rec)
{
    if (!(ui_flags & 0x40)) return;
    ui_flags &= ~0x40;
    sb_store_params(r2_sb_type_8BCC);
}

/* @01973E-019762 sub_1973E sb_store_params Confirmed: if type != 0 copy A90E (7 bytes) to the type's parameter block (sub_449A8); save R2 block FF8BCC x0x16 */
void sb_store_params(u8 type)
{
    if (type) sub_3F36E(7, sb_edit_A90E, sub_449A8());
    eep_save_r2_block(0xFF8BCC, 0x16);
}

/* @019762-019764 sub_19762 exit_8D_none Confirmed: rts (RADIO ID CHECK exit) */
void exit_8D_none(rec_t *rec) { }

/* @019764-01976C sub_19764 exit_19764 Confirmed: exit/save stub: eep_save_r2(0xA) */
void exit_19764(rec_t *rec) { eep_save_r2(0xA); }

/* @01976C-019774 sub_1976C exit_1976C Confirmed: exit/save stub: eep_save_r2(0x0) [exit slot x92:APRS MODEM] */
void exit_1976C(rec_t *rec) { eep_save_r2(0x0); }

/* @019774-01977C sub_19774 exit_19774 Confirmed: exit/save stub: eep_save_r2(0x1D) [exit slot x99:APRS TX DELAY] */
void exit_19774(rec_t *rec) { eep_save_r2(0x1D); }

/* @01977C-019784 sub_1977C exit_1977C Confirmed: exit/save stub: eep_save_r2(0x1C) [exit slot x9A:BEACON INTERVAL] */
void exit_1977C(rec_t *rec) { eep_save_r2(0x1C); }

/* @019784-019794 sub_19784 exit_19784 Confirmed: exit/save stub: eep_save_r2(0x128) eep_save_r2(0x12A) [exit slot x9E:GPS SETUP] */
void exit_19784(rec_t *rec) { eep_save_r2(0x128); eep_save_r2(0x12A); }

/* @019794-0197C0 sub_19794 exit_19794 Confirmed: exit/save stub: eep_save_r2(0x18D) eep_save_r2(0x1) eep_save_r2_block(0xFF8AC0, 2) eep_save_r2_block(0xFF8C1E, 4) [exit slot xA5:MY SYMBOL] */
void exit_19794(rec_t *rec) { eep_save_r2(0x18D); eep_save_r2(0x1); eep_save_r2_block(0xFF8AC0, 2); eep_save_r2_block(0xFF8C1E, 4); }

/* @0197C0-0197CE sub_197C0 exit_197C0 Confirmed: exit/save stub: eep_save_r2_block(0xFF8AFC, 130) [exit slot x94] */
void exit_197C0(rec_t *rec) { eep_save_r2_block(0xFF8AFC, 130); }

/* @0197CE-0197F0 sub_197CE exit_9D_digi_path Confirmed: hop index FF8AC2 = 0, save R2 blocks FF8AC2 x0x3A and FF8BE5 x0x39 */
void exit_9D_digi_path(rec_t *rec)
{
    r2_digi_hop_8AC2 = 0;
    eep_save_r2_block(0xFF8AC2, 0x3A);
    eep_save_r2_block(0xFF8BE5, 0x39);
}

/* @0197F0-0197FE sub_197F0 exit_197F0 Confirmed: exit/save stub: eep_save_r2_block(0xFF8B7E, 74) [exit slot xA2] */
void exit_197F0(rec_t *rec) { eep_save_r2_block(0xFF8B7E, 74); }

/* @0197FE-019816 sub_197FE exit_A3_callsign Confirmed: save R2 FF8AA2 x7 (call + SSID), rebuild the display string (sub_17D90), sub_50FE8 */
void exit_A3_callsign(rec_t *rec)
{
    eep_save_r2_block(0xFF8AA2, 7);
    callsign_format();
    sub_50FE8();
}

/* @019816-019824 sub_19816 exit_19816 Confirmed: exit/save stub: eep_save_r2_block(0xFF8AB0, 9) [exit slot xA4:MY POSITION] */
void exit_19816(rec_t *rec) { eep_save_r2_block(0xFF8AB0, 9); }

/* @019824-01982C sub_19824 exit_19824 Confirmed: exit/save stub: eep_save_r2(0x9) [exit slot xA6:POSITION COMMENT] */
void exit_19824(rec_t *rec) { eep_save_r2(0x9); }

/* @01982C-019834 sub_1982C exit_1982C Confirmed: exit/save stub: eep_save_r2(0x129) [exit slot xA7:TIME ZONE] */
void exit_1982C(rec_t *rec) { eep_save_r2(0x129); }

/* @019834-019842 sub_19834 exit_19834 Confirmed: exit/save stub: eep_save_r2_block(0xFF8C42, 20) [exit slot x96:APRS RINGER] */
void exit_19834(rec_t *rec) { eep_save_r2_block(0xFF8C42, 20); }

/* @019842-01984A sub_19842 exit_19842 Confirmed: exit/save stub: eep_save_r2(0xB) [exit slot x90:APRS AF DUAL x95:APRS MUTE x97 x9C:BEACON TX xA0:GPS TIME SET] */
void exit_19842(rec_t *rec) { eep_save_r2(0xB); }

/* @01984A-019858 sub_1984A exit_1984A Confirmed: exit/save stub: eep_save_r2_block(0xFF8AAC, 2) [exit slot x98:APRS UNIT] */
void exit_1984A(rec_t *rec) { eep_save_r2_block(0xFF8AAC, 2); }

/* @019858-019866 sub_19858 exit_19858 Confirmed: exit/save stub: eep_save_r2_block(0xFF8ABE, 2) [exit slot x84:COMPASS xA1:GPS UNIT xA9:GPS POWER] */
void exit_19858(rec_t *rec) { eep_save_r2_block(0xFF8ABE, 2); }

/* @019866-019874 sub_19866 exit_19866 Confirmed: exit/save stub: eep_save_r2_block(0xFF8AAE, 2) [exit slot x91] */
void exit_19866(rec_t *rec) { eep_save_r2_block(0xFF8AAE, 2); }

/* @019874-019882 sub_19874 exit_19874 Confirmed: exit/save stub: eep_save_r2_block(0xFF8BE2, 3) [exit slot x93:APRS MSG FLASH] */
void exit_19874(rec_t *rec) { eep_save_r2_block(0xFF8BE2, 3); }

/* @019882-019890 sub_19882 exit_19882 Confirmed: exit/save stub: eep_save_r2_block(0xFF8C22, 3) [exit slot xAA] */
void exit_19882(rec_t *rec) { eep_save_r2_block(0xFF8C22, 3); }

/* @019890-01989E sub_19890 exit_19890 Confirmed: exit/save stub: eep_save_r2_block(0xFF8C26, 5) [exit slot xAB] */
void exit_19890(rec_t *rec) { eep_save_r2_block(0xFF8C26, 5); }

/* @01989E-0198AC sub_1989E exit_1989E Confirmed: exit/save stub: eep_save_r2_block(0xFF8C2E, 20) [exit slot xAC:APRS POPUP] */
void exit_1989E(rec_t *rec) { eep_save_r2_block(0xFF8C2E, 20); }

/* @0198AC-0198AE sub_198AC exit_AD_none Confirmed: rts */
void exit_AD_none(rec_t *rec) { }

/* @0198AE-0198BC sub_198AE exit_198AE Confirmed: exit/save stub: eep_save_r2_block(0xFF8CF8, 2) [exit slot xAE:BEACON INFO] */
void exit_198AE(rec_t *rec) { eep_save_r2_block(0xFF8CF8, 2); }

/* @0198BC-0198C4 sub_198BC exit_198BC Confirmed: exit/save stub: eep_save_r2(0x18B) [exit slot xD7] */
void exit_198BC(rec_t *rec) { eep_save_r2(0x18B); }

/* @0198CC-0198D4 sub_198CC exit_198CC Confirmed: exit/save stub: eep_save_r3(0x0) */
void exit_198CC(rec_t *rec) { eep_save_r3(0x0); }

/* @0198D4-0198DC sub_198D4 exit_198D4 Confirmed: exit/save stub: eep_save_r3(0xB5) */
void exit_198D4(rec_t *rec) { eep_save_r3(0xB5); }

/* @0198DC-0198FA sub_198DC exit_198DC Confirmed: exit/save stub: eep_save_r3_block(0xFF8D20, 2) eep_save_r3(0x6A) eep_save_r3(0xB2) [exit slot xB0] */
void exit_198DC(rec_t *rec) { eep_save_r3_block(0xFF8D20, 2); eep_save_r3(0x6A); eep_save_r3(0xB2); }

/* @0198FA-019902 sub_198FA exit_198FA Confirmed: exit/save stub: eep_save_r3(0xBC) [exit slot xB2:DIGITAL VW] */
void exit_198FA(rec_t *rec) { eep_save_r3(0xBC); }

/* @019902-019910 sub_19902 exit_19902 Confirmed: exit/save stub: eep_save_r3_block(0xFF8DD5, 2) */
void exit_19902(rec_t *rec) { eep_save_r3_block(0xFF8DD5, 2); }

/* @019910-01991E sub_19910 exit_19910 Confirmed: exit/save stub: eep_save_r3_block(0xFF8D85, 2) [exit slot xCD] */
void exit_19910(rec_t *rec) { eep_save_r3_block(0xFF8D85, 2); }

/* @01991E-019926 sub_1991E exit_1991E Confirmed: exit/save stub: eep_save_r3(0x67) [exit slot xCE] */
void exit_1991E(rec_t *rec) { eep_save_r3(0x67); }

/* @019926-01992E sub_19926 exit_19926 Confirmed: exit/save stub: eep_save_r3(0x10A) [exit slot xC2] */
void exit_19926(rec_t *rec) { eep_save_r3(0x10A); }

/* @01992E-019936 sub_1992E exit_1992E Confirmed: exit/save stub: eep_save_r3(0x10B) [exit slot xCF] */
void exit_1992E(rec_t *rec) { eep_save_r3(0x10B); }

/* @019936-01993E sub_19936 exit_19936 Confirmed: exit/save stub: eep_save_r3(0x10C) [exit slot xD0] */
void exit_19936(rec_t *rec) { eep_save_r3(0x10C); }

/* @01993E-019946 sub_1993E exit_1993E Confirmed: exit/save stub: eep_save_r3(0x10D) [exit slot xD1] */
void exit_1993E(rec_t *rec) { eep_save_r3(0x10D); }

/* @019946-019954 sub_19946 exit_19946 Confirmed: exit/save stub: eep_save_r3_block(0xFF8D22, 2) [exit slot xB1:DIGITAL POPUP] */
void exit_19946(rec_t *rec) { eep_save_r3_block(0xFF8D22, 2); }

/* @019954-01996E sub_19954 exit_B3 Confirmed: save R3 block FF8D26 x0x0A, set B0C9.7, sub_5E0C0 */
void exit_B3(rec_t *rec)
{
    eep_save_r3_block(0xFF8D26, 0x0A);
    ui_B0C9 |= 0x80;
    sub_5E0C0();
}

/* @01996E-019976 sub_1996E exit_1996E Confirmed: exit/save stub: eep_save_r3(0x4) [exit slot xB4:DG-ID] */
void exit_1996E(rec_t *rec) { eep_save_r3(0x4); }

/* @019976-01997E sub_19976 exit_19976 Confirmed: exit/save stub: eep_save_r3(0x62) [exit slot xB5:LOCATION SERVICE] */
void exit_19976(rec_t *rec) { eep_save_r3(0x62); }

/* @01997E-01998C sub_1997E exit_1997E Confirmed: exit/save stub: eep_save_r3_block(0xFF8E20, 2) [exit slot xC3] */
void exit_1997E(rec_t *rec) { eep_save_r3_block(0xFF8E20, 2); }

/* @01998C-01999A sub_1998C exit_1998C Confirmed: exit/save stub: eep_save_r3_block(0xFF8E22, 4) [exit slot xC4] */
void exit_1998C(rec_t *rec) { eep_save_r3_block(0xFF8E22, 4); }

/* @01999A-0199A8 sub_1999A exit_1999A Confirmed: exit/save stub: eep_save_r3_block(0xFF8E26, 4) [exit slot xC5] */
void exit_1999A(rec_t *rec) { eep_save_r3_block(0xFF8E26, 4); }

/* @0199A8-0199B0 sub_199A8 exit_199A8 Confirmed: exit/save stub: eep_save_r3(0x10E) [exit slot xC6] */
void exit_199A8(rec_t *rec) { eep_save_r3(0x10E); }

/* @0199B0-0199BE sub_199B0 exit_199B0 Confirmed: exit/save stub: eep_save_r3_block(0xFF8E2F, 5) [exit slot xC7] */
void exit_199B0(rec_t *rec) { eep_save_r3_block(0xFF8E2F, 5); }

/* @0199BE-0199CC sub_199BE exit_199BE Confirmed: exit/save stub: eep_save_r3_block(0xFF8E34, 2) [exit slot xC8] */
void exit_199BE(rec_t *rec) { eep_save_r3_block(0xFF8E34, 2); }

/* @0199CC-0199D4 sub_199CC exit_199CC Confirmed: exit/save stub: eep_save_r3(0x116) [exit slot xC9] */
void exit_199CC(rec_t *rec) { eep_save_r3(0x116); }

/* @0199D4-0199DC sub_199D4 exit_199D4 Confirmed: exit/save stub: eep_save_r3(0x11D) [exit slot xCA] */
void exit_199D4(rec_t *rec) { eep_save_r3(0x11D); }

/* @0199DC-0199E4 sub_199DC exit_199DC Confirmed: exit/save stub: eep_save_r3(0x11E) [exit slot xCB] */
void exit_199DC(rec_t *rec) { eep_save_r3(0x11E); }

/* @0199E4-0199EC sub_199E4 exit_199E4 Confirmed: exit/save stub: eep_save_r3(0x11F) [exit slot xCC] */
void exit_199E4(rec_t *rec) { eep_save_r3(0x11F); }

/* @0199EC-0199FA sub_199EC exit_199EC Confirmed: exit/save stub: eep_save_r3_block(0xFF8D88, 2) [exit slot xD2 xD3] */
void exit_199EC(rec_t *rec) { eep_save_r3_block(0xFF8D88, 2); }

/* @0199FA-019A02 sub_199FA exit_199FA Confirmed: exit/save stub: eep_save_r3(0x6C) [exit slot xB7] */
void exit_199FA(rec_t *rec) { eep_save_r3(0x6C); }

/* @019A02-019A0A sub_19A02 exit_19A02 Confirmed: exit/save stub: eep_save_r3(0x6D) [exit slot xB8:DIGITAL POPUP] */
void exit_19A02(rec_t *rec) { eep_save_r3(0x6D); }

/* @019A0A-019A12 sub_19A0A exit_19A0A Confirmed: exit/save stub: eep_save_r3(0x6E) [exit slot xB9] */
void exit_19A0A(rec_t *rec) { eep_save_r3(0x6E); }

/* @019A12-019A1A sub_19A12 exit_19A12 Confirmed: exit/save stub: eep_save_r3(0x6F) [exit slot xBD:SEARCH SETUP] */
void exit_19A12(rec_t *rec) { eep_save_r3(0x6F); }

/* @019A1A-019A22 sub_19A1A exit_19A1A Confirmed: exit/save stub: eep_save_r3(0xB4) [exit slot xC1:STANDBY BEEP] */
void exit_19A1A(rec_t *rec) { eep_save_r3(0xB4); }

/* @019A22-019A30 sub_19A22 exit_19A22 Confirmed: exit/save stub: eep_save_r3_block(0xFF8D90, 14) [exit slot xBC:RPT/WIRES FREQ] */
void exit_19A22(rec_t *rec) { eep_save_r3_block(0xFF8D90, 14); }

/* @019A30-019A3E sub_19A30 exit_19A30 Confirmed: exit/save stub: eep_save_r3_block(0xFF8DD0, 2) */
void exit_19A30(rec_t *rec) { eep_save_r3_block(0xFF8DD0, 2); }

/* @019A3E-019A4C sub_19A3E exit_19A3E Confirmed: exit/save stub: eep_save_r3_block(0xFF8DD7, 5) [exit slot x38:DP-ID LIST x39:DP-ID LIST] */
void exit_19A3E(rec_t *rec) { eep_save_r3_block(0xFF8DD7, 5); }

/* @019A4C-019A54 sub_19A4C exit_19A4C Confirmed: exit/save stub: eep_save_r3(0xBE) */
void exit_19A4C(rec_t *rec) { eep_save_r3(0xBE); }

/* @019A54-019A5C sub_19A54 exit_19A54 Confirmed: exit/save stub: eep_save_r3(0xBF) */
void exit_19A54(rec_t *rec) { eep_save_r3(0xBF); }

/* @019A5C-019A64 sub_19A5C exit_19A5C Confirmed: exit/save stub: eep_save_r3(0xC0) */
void exit_19A5C(rec_t *rec) { eep_save_r3(0xC0); }

/* @019A64-019A6C sub_19A64 exit_19A64 Confirmed: exit/save stub: eep_save_r3(0xC1) */
void exit_19A64(rec_t *rec) { eep_save_r3(0xC1); }

/* @019A6C-019A74 sub_19A6C exit_19A6C Confirmed: exit/save stub: eep_save_r3(0xC2) */
void exit_19A6C(rec_t *rec) { eep_save_r3(0xC2); }

/* @019A74-019A7C sub_19A74 exit_19A74 Confirmed: exit/save stub: eep_save_r3(0xC7) */
void exit_19A74(rec_t *rec) { eep_save_r3(0xC7); }

/* @019A7C-019A8A sub_19A7C exit_19A7C Confirmed: exit/save stub: eep_save_r3_block(0xFF8E40, 15) */
void exit_19A7C(rec_t *rec) { eep_save_r3_block(0xFF8E40, 15); }

/* @019A8A-019A9E sub_19A8A exit_BE Confirmed: if changed: clear AA30.6 and call sub_3DD32 */
void exit_BE(rec_t *rec)
{
    if (!(ui_flags & 0x40)) return;
    ui_flags &= ~0x40;
    sub_3DD32();
}

/* @019C3A-019C44 sub_19C3A setup_level_dispatch_19C44 Confirmed: menu_dispatch_by_level(rec, tbl 0x019C44) */
void setup_level_dispatch_19C44(rec_t *rec) { menu_dispatch_by_level(rec, tbl_19C44); }

/* @019C50-019C76 sub_19C50 bt_step_19C82 Inferred: Bluetooth row: wrap-step record 0x019C82, set B0AA.7; when Bluetooth is on (FF8920.0) and FF8920.7 is set call sub_7348C (re-apply) */
void bt_step_19C82(rec_t *rec)
{
    dial_step_wrap_dirty(&rec_19C82);
    ui_B0AA |= 0x80;
    if ((r1_set_8920 & 0x01) && (r1_set_8920 & 0x80)) sub_7348C();
}

/* @019C76-019C82 sub_19C76 bt_step_19C88 Confirmed: wrap-step record 0x019C88 */
void bt_step_19C88(rec_t *rec) { dial_step_wrap_dirty(&rec_19C88); }

/* @019C8E-019C98 sub_19C8E setup_level_dispatch_19C98 Confirmed: menu_dispatch_by_level(rec, tbl 0x019C98) */
void setup_level_dispatch_19C98(rec_t *rec) { menu_dispatch_by_level(rec, tbl_19C98); }

/* @019CA4-019CB6 sub_19CA4 setup_step_19CCE_unless_BAD6 Confirmed: if BAD6 == 0 wrap-step record 0x019CCE, else key_reject_beep (loc_19CC8) */
void setup_step_19CCE_unless_BAD6(rec_t *rec)
{
    if (ui_BAD6 == 0) dial_step_wrap_dirty(&rec_19CCE); else key_reject_beep();
}

/* @019CB6-019CCE sub_19CB6 setup_step_19CD4_unless_BAD6 Confirmed: if BAD6 == 0 wrap-step record 0x019CD4, else key_reject_beep */
void setup_step_19CD4_unless_BAD6(rec_t *rec)
{
    if (ui_BAD6 == 0) dial_step_wrap_dirty(&rec_19CD4); else key_reject_beep();
}

/* @019CDA-019CF8 sub_19CDA dial_1D_device_list Inferred: DEVICE LIST (Bluetooth): with n = AAEA paired devices, wrap-steps record 0x019CF8 until the index is < n+1; none -> key_consume */
void dial_1D_device_list(rec_t *rec)
{
    u8 n = bt_AAEA;
    if (n == 0) { key_consume(); return; }
    n++;
    while (dial_step_wrap(&rec_19CF8) >= n) ;
}

/* @019CFE-019D10 sub_19CFE dial_1E_bluetooth Confirmed: Bluetooth (F3D2): dirty, toggle FF8920.0 (R1 n=0), sub_730D0 (power the module) */
void dial_1E_bluetooth(rec_t *rec) { ui_flags |= 0x40; r1_set_8920 ^= 0x01; sub_730D0(); }

/* @019D10-019D22 sub_19D10 dial_1F_bluetooth_save Confirmed: Bluetooth Save (F3D4): dirty, toggle FF8920.7, sub_734B0 */
void dial_1F_bluetooth_save(rec_t *rec) { ui_flags |= 0x40; r1_set_8920 ^= 0x80; sub_734B0(); }

/* @019D22-019D4A sub_19D22 name_cursor Inferred: cursor in the 16-char name (AA96 when page 94C1 == 5, else rec+0x22): text_cursor_2b(er5, first col 2, record 0x01A204) */
void name_cursor(rec_t *rec)
{
    u8 *buf = (ui_page_94C1 == 5) ? name_buf_AA96 : &rec->name22[0];
    text_cursor_2b(buf, 2, &rec_1A204);                   /* bra sub_19DDE */
}

/* @019D4A-019D58 sub_19D4A text_cursor_AD6E_guard Confirmed: level >= 2 -> sub_19D58, else menu_exit_all */
void text_cursor_AD6E_guard(rec_t *rec) { if (menu_level >= 2) text_cursor_AD6E(rec); else menu_exit_all(rec); }

/* @019D58-019D60 sub_19D58 text_cursor_AD6E Confirmed: er5 = FFAD6E, bra loc_19D74 */
void text_cursor_AD6E(rec_t *rec) { text_cursor_2b_back(text_buf_AD6E); }

/* @019D60-019D6E sub_19D60 text_cursor_8956_guard Confirmed: level >= 2 -> sub_19D6E, else menu_exit_all */
void text_cursor_8956_guard(rec_t *rec) { if (menu_level >= 2) text_cursor_8956(rec); else menu_exit_all(rec); }

/* @019D6E-019D74 sub_19D6E text_cursor_8956 Confirmed: er5 = FF8956, falls into sub_19D74 */
void text_cursor_8956(rec_t *rec) { text_cursor_2b_back(r1_text_8956); }

/* --------------------------------------------------------------------------
 * @019D74-019DDE sub_19D74 text_cursor_2b_back Inferred: cursor move (first col 3, record 0x01A210) that also keeps the cursor on the first half of a 2-byte character: BBBA = -1, and for a left move onto an odd column whose previous slot is a 2-byte char (sub_1A436) the cursor steps back one more
 * -------------------------------------------------------------------------- */
void text_cursor_2b_back(u8 *buf)                         /* 019D74 */
{
    text_cursor_2b(buf, 3, &rec_1A210);
    ui_BBBA = 0xFFFFFFFF;
    if (key_event == 4) return;
    u8 col = menu_level;
    *(u8 *)&ui_BBBA = col;
    if (col < 2 || !(col & 1)) return;
    text_ptr_AD82 = buf;
    if (is_wide_char(col - 2)) return;                    /* sub_1A436 */
    if (!is_wide_char(col - 3)) return;
    menu_level--;
}

/* --------------------------------------------------------------------------
 * @019DDE-019E58 sub_19DDE text_cursor_2b Inferred: generic text cursor: remembers buffer (AD82) and step record (AD86); moves AD68 via sub_19E58, skipping the second half of 2-byte chars (per-char flag word, sub_1A436) and gaps of two empty bytes; level 0 -> key_consume
 * Args: er5 = buffer, er1 = first text column, er6 = cursor step record.
 * -------------------------------------------------------------------------- */
void text_cursor_2b(u8 *buf, u8 first, const step_rec_t *r)   /* 019DDE */
{
    text_ptr_AD82 = buf;  cursor_rec_AD86 = r;
again:;
    u8 c = menu_level;
    if (c == 0) { key_consume(); return; }
    c--;
    u8 col;
    if (key_event != 4) {                                 /* moving left */
        if (c == 0) {
            col = cursor_step_rec();
            if (!is_wide_char(col - first)) goto chk;
            goto step2;
        }
        if (c >= first && is_wide_char(c - first)) cursor_step_rec();
    } else {                                              /* moving right */
        if (first != 2) { if (c == 0) goto step2; c--; }
        if (is_wide_char(c)) cursor_step_rec();
    }
step2:
    col = cursor_step_rec();
chk:
    if (col < first) return;
    {
        u8 *p = text_ptr_AD82 + 2 - first + col;
        if (p[0] == 0xFF && p[1] == 0xFF) goto again;     /* double gap */
    }
}

/* @019E58-019E6C sub_19E58 cursor_step_rec Confirmed: sub_19F3A with the record saved in AD86 (er1 preserved); returns the new column */
u8 cursor_step_rec(void) { return cursor_step_19F3A(cursor_rec_AD86); }

/* --------------------------------------------------------------------------
 * @019E6C-019E92 sub_19E6C text_cursor_entries Inferred: entry points that pick a buffer and fall into the shared cursor loop loc_19EAE (record 0x01A210): 0x019E6C FF8926; 0x019E74 level guard (else menu_exit_all) then 0x019E82 FFAC24 (DTMF digits); 0x019E8A buffer from the caller
 * -------------------------------------------------------------------------- */
void text_cursor_8926(rec_t *rec) { text_cursor_skipgap(r1_text_8926, &rec_1A210); }   /* 019E6C */
void text_cursor_dtmf_guard(rec_t *rec)                   /* 019E74 */
{
    if (menu_level >= 2) text_cursor_skipgap(dtmf_buf_AC22 + 2, &rec_1A210);
    else menu_exit_all(rec);
}

/* --------------------------------------------------------------------------
 * @019E92-019ED6 sub_19E92 text_cursor_skipgap Inferred: cursor loop loc_19EAE: step with the given record (AD86) and repeat while the column >= 3 sits on two empty bytes; entries 0x019E92 / 0x019EA0 use the password buffer FFAD8A with records 0x01A1C2 / 0x01A1BC
 * -------------------------------------------------------------------------- */
void text_cursor_skipgap(u8 *buf, const step_rec_t *r)   /* 019EAE */
{
    cursor_rec_AD86 = r;
    u8 col;
    do {
        col = cursor_step_rec();
        if (col < 3) return;
    } while (buf[col - 3] == 0xFF && buf[col - 2] == 0xFF);
}
void pw_cursor_right(rec_t *rec) { text_cursor_skipgap(pw_buf_AD88 + 2, &rec_1A1C2); }  /* 019E92 */
void pw_cursor_left(rec_t *rec)  { text_cursor_skipgap(pw_buf_AD88 + 2, &rec_1A1BC); }  /* 019EA0 */

/* @019ED6-019F08 sub_19ED6 status_text_cursor Confirmed: cursor over FFADA2 (record 0x01A228) from column 5, skipping double gaps */
void status_text_cursor(rec_t *rec)
{
    u8 col;
    cursor_rec_AD86 = &rec_1A228;
    do { col = cursor_step_rec(); if (col < 5) return; }
    while (text_ADA2[col - 5] == 0xFF && text_ADA2[col - 4] == 0xFF);
}

/* @019F3A-019F54 sub_19F3A cursor_step_19F3A Confirmed: level 0 -> key_consume; else AA30 |= 0x80 and cursor_step_19FAE(er6); returns AD68 (r4l) with the stepped value in r3l */
u8 cursor_step_19F3A(const step_rec_t *r)
{
    if (menu_level == 0) key_consume();
    else { ui_flags |= 0x80; cursor_step_19FAE(r); }
    return menu_level;
}

/* @019F54-019F62 sub_19F54 cursor_step_19F54 Confirmed: AA30 |= 0x80, cursor_step_19FAE(er6), return AD99 (auto-reply sub-cursor) */
u8 cursor_step_19F54(const step_rec_t *r) { ui_flags |= 0x80; cursor_step_19FAE(r); return sub_cursor_AD99; }

/* @019F62-019F70 sub_19F62 cursor_step_19F62 Confirmed: AA30 |= 0x80, cursor_step_19FAE(er6), return B3A0 */
u8 cursor_step_19F62(const step_rec_t *r) { ui_flags |= 0x80; cursor_step_19FAE(r); return ui_B3A0; }

/* @019F78-019F82 sub_19F78 cursor_key_1A1BC Confirmed: record 0x01A1BC then loc_19FA8 (level check + cursor step) */
void cursor_key_1A1BC(rec_t *rec) { cursor_key(&rec_1A1BC); }

/* @019F82-019F8A sub_19F82 cursor_key_1A1A4 Confirmed: record 0x01A1A4 then loc_19FA8 */
void cursor_key_1A1A4(rec_t *rec) { cursor_key(&rec_1A1A4); }

/* @019F8A-019FAE sub_19F8A cursor_key_1A1AA Confirmed: record 0x01A1AA; entries 0x019F92 (0x01A1B6), 0x019F9A (0x01A1CE), 0x019FA2 (0x01A1D4); loc_19FA8: level 0 -> key_consume (loc_19FD4), else falls into sub_19FAE */
void cursor_key_1A1AA(rec_t *rec) { cursor_key(&rec_1A1AA); }
static void cursor_key(const step_rec_t *r)               /* 019FA8 */
{
    if (menu_level == 0) { key_consume(); return; }
    cursor_step_19FAE(r);
}

/* @019FAE-019FD4 sub_19FAE cursor_step_19FAE Confirmed: 9542 = 0; key 4 -> up, any other key -> down (A9EE.0); wrap-step the record; returns the new value zero-extended in er3 */
u8 cursor_step_19FAE(const step_rec_t *r)
{
    ui_9542 = 0;
    key_flags &= ~0x01;
    if (key_event != 4) key_flags |= 0x01;
    return dial_step_wrap(r);
}

/* @019FDE-01A006 sub_19FDE text_len_to_AD99 Confirmed: AD99 = number of leading non-0xFF bytes of er5, capped at r3l; AA30 |= 0x80 */
void text_len_to_AD99(const u8 *p, u8 max)
{
    u8 n = 0;
    while (n < max && *p++ != 0xFF) n++;
    sub_cursor_AD99 = n;
    ui_flags |= 0x80;
}

/* @01A006-01A028 sub_1A006 ad99_advance Confirmed: if *er5 is a char and r2l < r4h: AD99 = r2l+1, else AD99 = 0; label 0x01A022 = key_consume */
void ad99_advance(const u8 *p, u8 cur, u8 max) { sub_cursor_AD99 = (*p != 0xFF && cur < max) ? cur + 1 : 0; }

/* @01A028-01A04A sub_1A028 b3a0_advance Confirmed: as sub_1A006 for cursor B3A0, wrapping to 1 */
void b3a0_advance(const u8 *p, u8 cur, u8 max) { ui_B3A0 = (*p != 0xFF && cur < max) ? cur + 1 : 1; }

/* @01A04A-01A062 sub_1A04A text_clear_ad99 Confirmed: fill (r3l-r2l) bytes at er5 with 0xFF; AD99 = r2l-1 unless r2l == 0 */
void text_clear_ad99(u8 *p, u8 i, u8 end)
{
    u8 n = end - i;
    do *p++ = 0xFF; while (--n);
    if (i) sub_cursor_AD99 = i - 1;
}

/* @01A062-01A07C sub_1A062 text_clear_b3a0 Confirmed: fill (r3l-r2l+1) bytes with 0xFF; B3A0 = r2l-1 unless r2l == 1 */
void text_clear_b3a0(u8 *p, u8 i, u8 end)
{
    u8 n = end - i + 1;
    do *p++ = 0xFF; while (--n);
    if (i != 1) ui_B3A0 = i - 1;
}

/* --------------------------------------------------------------------------
 * @01A084-01A08C sub_1A084 setup_cb_1A084 Confirmed: row/column cursor with layout 0x01A1F8 (loc_1A0EA)
 * @01A094-01A09C sub_1A094 setup_cb_1A094 Confirmed: layout 0x01A1EC
 * @01A0A4-01A0AC sub_1A0A4 setup_cb_1A0A4 Confirmed: layout 0x01A1E0
 * @01A0AC-01A0B4 sub_1A0AC setup_cb_1A0AC Confirmed: layout 0x01A1A4
 * @01A0B4-01A0BC sub_1A0B4 setup_cb_1A0B4 Confirmed: layout 0x01A1AA
 * These are the "ctx stacked" callbacks passed to sub_15206: they move the
 * two-level cursor (B054 window top, B055 row) of a multi-row page.
 * -------------------------------------------------------------------------- */
void setup_cb_1A084(rec_t *rec) { rowcol_cursor(lay_1A1F8); }
void setup_cb_1A094(rec_t *rec) { rowcol_cursor(lay_1A1EC); }
void setup_cb_1A0A4(rec_t *rec) { rowcol_cursor(lay_1A1E0); }
void setup_cb_1A0AC(rec_t *rec) { rowcol_cursor(lay_1A1A4); }
void setup_cb_1A0B4(rec_t *rec) { rowcol_cursor(lay_1A1AA); }

/* --------------------------------------------------------------------------
 * @01A0DC-01A17C sub_1A0DC rowcol_cursor Inferred: multi-row page cursor: layout byte [1] = item count. Up (dial up / key 4) on row 3 scrolls the window B054 down until top+3 == count, wrapping B054 to 0; down on row 1 scrolls up, wrapping to count-3 (if count >= 4); otherwise steps the row B055 with record 0x01A23A (0x01A234 for 2-item pages). AD68 = B054 + B055.  Entries 0x01A0DC (layout 0x01A1D4) and 0x01A0E4 (0x01A1DA); level 0 -> key_consume
 * -------------------------------------------------------------------------- */
void rowcol_cursor(const u8 *lay)                         /* 01A0EA */
{
    if (menu_level == 0) { key_consume(); return; }
    u8 cnt = lay[1];
    if (!(key_flags & 0x01)) {
        if (edit_col_B055 == 3) {
            if ((u8)(edit_row_B054 + 3) != cnt) { edit_row_B054++; goto set; }
            if (edit_row_B054) edit_row_B054 = 0;
        }
    } else {
        if (edit_col_B055 == 1) {
            if (edit_row_B054) { edit_row_B054--; goto set; }
            if (cnt >= 4) edit_row_B054 = cnt - 3;
        }
    }
    dial_step_wrap(cnt == 2 ? &rec_1A234 : &rec_1A23A);  /* steps B055 */
set:
    menu_level = edit_row_B054 + edit_col_B055;
}
void sb_cb_1A0DC(rec_t *rec)  { rowcol_cursor(lay_1A1D4); }   /* 01A0DC */
void rowcol_1A1DA(rec_t *rec) { rowcol_cursor(lay_1A1DA); }   /* 01A0E4 */

/* @01A246-01A254 sub_1A246 text_cursor_1A246 Confirmed: auto-reply text cursor: er1 = FFADDE, record 0x01A254, then the gap-skipping loop at 0x01A25A */
void text_cursor_1A246(rec_t *rec) { cursor_rec_AD86 = &rec_1A254; ar_text_cursor(ar_text_ADDE); }

/* @01A260-01A28C sub_1A260 ar_text_cursor Confirmed: step AD99 (sub_19F54 with record AD86) and repeat while AD99 >= 2 sits on two empty bytes */
void ar_text_cursor(u8 *buf)
{
    u8 c;
    do { c = cursor_step_19F54(cursor_rec_AD86); if (c < 2) return; }
    while (buf[c - 2] == 0xFF && buf[c - 1] == 0xFF);
}

/* @01A2C0-01A2D8 sub_1A2C0 list_select_dial Inferred: not at list level: if BBF2.6 (list page active) -> sub_1A2D8, else refuse */
void list_select_dial(rec_t *rec)
{
    if (menu_level_or_list(rec) == 0) return;
    if (ui_BBF2 & 0x40) list_select_step(); else key_consume();
}

/* @01A2D8-01A302 sub_1A2D8 list_select_step Inferred: B092 = 0; B093 = 0x27 (40 rows) unless on the last page (BC77 == BC78) where it is BC7A; steps the row BC79 with sub_3F676 (limits from word B092) */
void list_select_step(void)
{
    ui_B092 = 0;
    ui_B093 = (list_page_BC77 != list_pages_BC78) ? 0x27 : list_last_rows_BC7A;
    sub_3F676(&list_row_BC79);
}

/* @01A302-01A31C sub_1A302 list_page_prev Confirmed: BC77 > 0 -> BC77--, row BC79 = 0; else key_consume */
void list_page_prev(rec_t *rec) { if (list_page_BC77) { list_page_BC77--; list_row_BC79 = 0; } else key_consume(); }

/* @01A31C-01A33C sub_1A31C list_page_next Confirmed: BC77 < BC78 -> BC77++, row 0; else key_consume */
void list_page_next(rec_t *rec) { if (list_page_BC77 < list_pages_BC78) { list_page_BC77++; list_row_BC79 = 0; } else key_consume(); }

/* @01A33C-01A350 sub_1A33C list_select_if_active Confirmed: BBF2.6 -> sub_1A2D8, else key_consume */
void list_select_if_active(rec_t *rec) { if (ui_BBF2 & 0x40) list_select_step(); else key_consume(); }

/* @01A350-01A364 sub_1A350 list_select_if_active_b Confirmed: identical copy of sub_1A33C */
void list_select_if_active_b(rec_t *rec) { if (ui_BBF2 & 0x40) list_select_step(); else key_consume(); }

/* @01A432-01A436 sub_1A432 is_wide_cur Confirmed: r2l = AD80 (current char index), falls into sub_1A436 */
u8 is_wide_cur(void) { return is_wide_char(char_idx_AD80); }

/* @01A436-01A43C sub_1A436 is_wide_char Confirmed: er5 = AD82 (buffer), falls into sub_1A43C */

/* @01A43C-01A458 sub_1A43C wide_flag_test Confirmed: tests bit tbl_1A458[i] of the buffer's first word (high byte for i < 8, low byte otherwise): per-character "2-byte" flag */
u8 is_wide_char(u8 i)
{
    u16 w = *(u16 *)text_ptr_AD82;
    u8 bit = wide_bit_1A458[i];
    return (i < 8) ? ((w >> 8) >> bit) & 1 : (w >> bit) & 1;
}

/* @01A468-01A46C sub_1A468 wide_clear_cur Confirmed: r2l = AD80, falls into sub_1A46C */

/* @01A46C-01A490 sub_1A46C wide_flag_clear Confirmed: clears the "2-byte" flag of char i in the buffer's first word */
void wide_flag_clear(u8 i)
{
    u16 *w = (u16 *)text_ptr_AD82;
    u8 bit = wide_bit_1A458[i];
    if (i < 8) *w &= ~(u16)(0x100u << bit); else *w &= ~(u16)(1u << bit);
}
void wide_clear_cur(void) { wide_flag_clear(char_idx_AD80); }

/* --------------------------------------------------------------------------
 * @01A490-01A4C8 sub_1A490 name_key_convert Inferred: "convert" key in a name editor (AA96/AA98 on page 5, else rec+0x22/+0x24): shared tail loc_1A50C toggles the character at the cursor between full-width (2-byte JIS 0x2340..0x237F via table 0x01BE72) and half-width (ASCII 0x40..0x7F via table 0x01BE32); unconvertible -> key_consume (loc_1A4C8)
 * @01A4CE-01A4EE sub_1A4CE text_key_convert_AD6E Inferred: same for FFAD6E (columns >= 2)
 * @01A4EE-01A558 sub_1A4EE text_key_convert_8956 Inferred: same for FF8956; holds the shared tail 0x01A50C..0x01A554
 * -------------------------------------------------------------------------- */
void text_key_convert(u8 *flags, u8 *chars, u8 i)         /* 01A50C */
{
    char_idx_AD80 = i;  text_ptr_AD82 = flags;
    if (is_wide_cur()) {
        u16 *p = (u16 *)(chars + char_idx_AD80);
        if (*p < 0x2340 || *p >= 0x2380) goto no;
        u16 n = wide_to_half_1BE72[*p - 0x2340];
        if (!n) goto no;
        *p = n;                                           /* then continues at 0x01A588 */
        return;
    }
    text_key_convert_half(chars, char_idx_AD80);          /* 01A554 -> sub_1A58C */
    return;
no:
    key_consume();
}
void name_key_convert(rec_t *rec)
{
    if (menu_level == 0) { key_consume(); return; }
    if (ui_page_94C1 == 5) text_key_convert(name_buf_AA96, name_buf_AA96 + 2, menu_level - 1);
    else text_key_convert(&rec->name22[0], &rec->name22[2], menu_level - 1);
}
void text_key_convert_AD6E(rec_t *rec)
{
    if (menu_level < 2) { key_consume(); return; }
    text_key_convert(text_buf_AD6E, text_buf_AD6E + 2, menu_level - 2);
}
void text_key_convert_8956(rec_t *rec)
{
    if (menu_level < 2) { key_consume(); return; }
    text_key_convert(r1_text_8956, r1_text_8956 + 2, menu_level - 2);
}

/* @01A58C-01A5CC sub_1A58C text_key_convert_half Inferred: unless AD69.7: single-byte char 0x40..0x7F -> tbl_1BE32[c-0x40] (case / kana variant), 0 -> key_consume (the AD69.7 path goes to 0x01A558, outside any function) */
void text_key_convert_half(u8 *chars, u8 i)
{
    if (ui_AD69 & 0x80) { text_convert_1A558(chars, i); return; }
    u8 *p = chars + i, c = *p;
    if (c < 0x40 || c >= 0x80) { key_consume(); return; }
    u8 n = half_conv_1BE32[c - 0x40];
    if (!n) { key_consume(); return; }
    *p = n;
}

/* --------------------------------------------------------------------------
 * @01A5CC-01A60A sub_1A5CC name_key_delete Inferred: delete key in a name editor (same buffer choice as sub_1A490), shared tail loc_1A648 (outside this listing) removes the character at the cursor; level 0 -> menu_exit_all (loc_1A604)
 * @01A60A-01A62A sub_1A60A text_key_delete_AD6E Inferred: same for FFAD6E (columns >= 2)
 * @01A62A-01A648 sub_1A62A text_key_delete_8956 Inferred: same for FF8956; falls into the unlisted 0x01A648 tail
 * -------------------------------------------------------------------------- */
void name_key_delete(rec_t *rec)
{
    if (menu_level == 0) { menu_exit_all(rec); return; }
    if (ui_page_94C1 == 5) text_delete_1A648(name_buf_AA96, name_buf_AA96 + 2, menu_level - 1);
    else text_delete_1A648(&rec->name22[0], &rec->name22[2], menu_level - 1);
}
void text_key_delete_AD6E(rec_t *rec)
{
    if (menu_level < 2) { menu_exit_all(rec); return; }
    text_delete_1A648(text_buf_AD6E, text_buf_AD6E + 2, menu_level - 2);
}
void text_key_delete_8956(rec_t *rec)
{
    if (menu_level < 2) { menu_exit_all(rec); return; }
    text_delete_1A648(r1_text_8956, r1_text_8956 + 2, menu_level - 2);
}

/* --------------------------------------------------------------------------
 * @01A6B4-01A6EC sub_1A6B4 keypad_enter_wide Inferred: keypad multi-tap entry with a 16-char limit through sub_1A950, table selected by entry point: 0x01A6B4 -> 0x01B1D0, 0x01A6BC -> 0x01BCFE, 0x01A6C4 -> 0x01B352, 0x01A6CC -> 0x01BBD8; if the char at the cursor was 2-byte, its second byte becomes ' ' and the flag is cleared
 * -------------------------------------------------------------------------- */
void keypad_enter_wide(const u8 *tbl)                     /* 01A6D4 */
{
    u8 *p = keypad_put_1A950(tbl, 0x10);                  /* returns er1 = slot */
    if (is_wide_cur()) { p[1] = ' '; wide_clear_cur(); }
}

/* --------------------------------------------------------------------------
 * @01A6EC-01A754 sub_1A6EC keypad_enter_2byte Inferred: multi-tap entry of 2-byte characters (tables 0x01B4DA, 0x01B62E, 0x01B6AA, 0x01B77A, 0x01B88C by entry point); refused at column 0x0F. sub_1A9C8 positions the slot; the current code is looked up in the table's {count; u16 code; ...} list to find the next code; a new key starts with the first code (sub_1A754 may advance the cursor by 2); AA30.7 cleared, code stored big-endian, flag set by sub_1A7A4
 * -------------------------------------------------------------------------- */
void keypad_enter_2byte(const u8 *tbl, u8 col)            /* 01A714 */
{
    if (col == 0x0F) { key_consume(); return; }
    u8 *p = keypad_slot_1A9C8(tbl, 0x10);                 /* er1 slot, er5 list, er6 end */
    /* TODO(waveC): exact register use of the lookup loop 0x01A726..0x01A732 (er5 list walk, e4 count) */
    u16 cur = (p[0] << 8) | p[1], code = 0;
    if (!keypad_lookup_next(tbl, cur, &code)) {
        code = *(const u16 *)(tbl + 2);                   /* @(2,er2) first code */
        s8 r = (s8)keypad_advance_2(p, code);             /* sub_1A754 */
        if (r < 0) { key_consume(); return; }
        if (r > 0) goto flag;
    }
    ui_flags &= ~0x80;
    p[0] = code >> 8;  p[1] = (u8)code;
flag:
    wide_set_cur();                                       /* sub_1A7A4 */
}

/* @01A754-01A7A4 sub_1A754 keypad_advance_2 Inferred: when a different key was pressed (AA30.5 set, AA30.7 clear) on a non-empty slot and room remains, moves to the next 2-byte slot (AD80 += 2, AD68 += 2), writes the code there and returns 1; no room -> 0xFF; otherwise 0 */
s8 keypad_advance_2(u8 *p, u16 code)
{
    /* er6 = end of buffer, er1 = slot */
    if ((ui_flags & 0x80) || !(ui_flags & 0x20)) return 0;
    if (p[0] == 0xFF && p[1] == 0xFF) return 0;
    if (p + 2 > keypad_end_er6) return -1;               /* cmp er4,er6 ; bcs */
    p += 2;  p[0] = code >> 8;  p[1] = (u8)code;
    char_idx_AD80 += 2;  menu_level += 2;
    return 1;
}

/* @01A7A4-01A7BC sub_1A7A4 wide_set_cur Inferred: unless AA30.5: if the next char was 2-byte, falls into sub_1A7BC to blank it; then sets this char's 2-byte flag */

/* @01A7BC-01A7F6 sub_1A7BC wide_set_flag Confirmed: p[2] = ' ', clear flag of char AD80+1; then word flags = (flags & (0xFFFF3FFF >> i)) | (0x8000 >> i) for i = AD80 */
void wide_set_cur(void)
{
    if (!(ui_flags & 0x20)) {
        u8 n = char_idx_AD80 + 1;
        if (n < 0x0F && is_wide_char(n)) {
            /* 01A7BC */ keypad_slot_er1[2] = ' ';
            wide_flag_clear(char_idx_AD80 + 1);
        }
    }
    u32 m = 0xFFFF3FFF, s = 0x8000;
    for (u8 i = char_idx_AD80; i; i--) { m >>= 1; s >>= 1; }
    u16 *w = (u16 *)text_ptr_AD82;
    *w = (*w & (u16)m) | (u16)s;
}

/* @01A84E-01A854 sub_1A84E text_insert_1A84E Confirmed: 9542 = 0x96, falls into sub_1A854 */

/* --------------------------------------------------------------------------
 * @01A854-01A88E sub_1A854 keypad_put_by_mode Inferred: multi-tap character entry by input mode BC34: 0 -> table 0x01B1D0, 1 -> 0x01BCFE, other -> 0x01B31E (BBF1.2) or 0x01B352; tail-jumps to sub_1A94C
 * -------------------------------------------------------------------------- */
u8 text_insert_1A84E(u8 *buf, u8 i, u8 len) { ui_9542 = 0x96; return keypad_put_by_mode(buf, i, len); }
u8 keypad_put_by_mode(u8 *buf, u8 i, u8 len)
{
    const u8 *t;
    if (edit_mode_BC34 == 0) t = kp_tbl_1B1D0;
    else if (edit_mode_BC34 == 1) t = kp_tbl_1BCFE;
    else t = (ui_BBF1 & 0x04) ? kp_tbl_1B31E : kp_tbl_1B352;
    return keypad_put_1A94C(buf, i, len, t);
}
/* compatibility aliases used by earlier parts */
#define text_delete_shift_1A854(b,i,n)  keypad_put_by_mode(b,i,n)

/* @01A88E-01A8CE sub_1A88E keypad_put_by_mode_b Inferred: same table choice as sub_1A854 with 9542 = 0x96, tail-jumps to loc_1A960 */
u8 text_delete_1A88E(u8 *buf, u8 i, u8 len)
{
    ui_9542 = 0x96;
    const u8 *t;
    if (edit_mode_BC34 == 0) t = kp_tbl_1B1D0;
    else if (edit_mode_BC34 == 1) t = kp_tbl_1BCFE;
    else t = (ui_BBF1 & 0x04) ? kp_tbl_1B31E : kp_tbl_1B352;
    return keypad_put_1A960(buf, i, len, t);
}

/* @01A8CE-01A8E4 sub_1A8CE fn_1A8CE Skeleton: 7 insns; calls loc_1A960; RAM 9542,BC34 */
void fn_1A8CE(rec_t *rec)
{
    /* TODO(waveC): body not transcribed (7 instructions). */
}

/* @01A8E4-01A90E sub_1A8E4 fn_1A8E4 Skeleton: 12 insns; calls sub_1A9EC; RAM AD68,AD80,BC34 */
void fn_1A8E4(rec_t *rec)
{
    /* TODO(waveC): body not transcribed (12 instructions). */
}

/* @01A90E-01A974 sub_1A90E fn_1A90E Skeleton: 33 insns; calls sub_1A94C,sub_1A974,sub_3FFA0; RAM A9F0,AD68,AD80,AD99,BC34 */
void fn_1A90E(rec_t *rec)
{
    /* TODO(waveC): body not transcribed (33 instructions). */
}

/* @01A974-01A9C8 sub_1A974 fn_1A974 Skeleton: 32 insns; calls sub_1A9C8; RAM 9542,AA30,AD80 */
void fn_1A974(rec_t *rec)
{
    /* TODO(waveC): body not transcribed (32 instructions). */
}

/* @01A9C8-01A9EC sub_1A9C8 fn_1A9C8 Skeleton: 12 insns; calls -; RAM A9F0 */
void fn_1A9C8(rec_t *rec)
{
    /* TODO(waveC): body not transcribed (12 instructions). */
}

/* @01A9EC-01AA46 sub_1A9EC fn_1A9EC Skeleton: 34 insns; calls sub_1A9C8; RAM 9542,AA30,AD80 */
void fn_1A9EC(rec_t *rec)
{
    /* TODO(waveC): body not transcribed (34 instructions). */
}

/* @01AA46-01AA80 sub_1AA46 fn_1AA46 Skeleton: 16 insns; calls sub_1A94C,sub_3FFA0; RAM AA30,AD68 */
void fn_1AA46(rec_t *rec)
{
    /* TODO(waveC): body not transcribed (16 instructions). */
}

/* @01B992-01B99A sub_1B992 fn_1B992 Skeleton: 3 insns; calls sub_3FFA0; RAM - */
void fn_1B992(rec_t *rec)
{
    /* TODO(waveC): body not transcribed (3 instructions). */
}

/* @01BEF2-01BF28 sub_1BEF2 fn_1BEF2 Skeleton: 16 insns; calls sub_1A9EC; RAM AD80,B9ED,BC34 */
void fn_1BEF2(rec_t *rec)
{
    /* TODO(waveC): body not transcribed (16 instructions). */
}

/* @01BF28-01BF38 sub_1BF28 fn_1BF28 Skeleton: 4 insns; calls sub_19FAE; RAM AA30,B9ED */
void fn_1BF28(rec_t *rec)
{
    /* TODO(waveC): body not transcribed (4 instructions). */
}

/* @01BF38-01BF40 sub_1BF38 fn_1BF38 Skeleton: 3 insns; calls sub_3FF9C; RAM - */
void fn_1BF38(rec_t *rec)
{
    /* TODO(waveC): body not transcribed (3 instructions). */
}

/* @01BF40-01BF78 sub_1BF40 fn_1BF40 Skeleton: 21 insns; calls -; RAM 817E,94F5,9539 */
void fn_1BF40(rec_t *rec)
{
    /* TODO(waveC): body not transcribed (21 instructions). */
}

/* @01BF78-01BF84 sub_1BF78 fn_1BF78 Skeleton: 4 insns; calls loc_1BFAC; RAM AAE0,BBE1 */
void fn_1BF78(rec_t *rec)
{
    /* TODO(waveC): body not transcribed (4 instructions). */
}

/* @01BF84-01BF8E sub_1BF84 fn_1BF84 Skeleton: 4 insns; calls sub_1BFA8; RAM AAE0 */
void fn_1BF84(rec_t *rec)
{
    /* TODO(waveC): body not transcribed (4 instructions). */
}

/* @01BF8E-01BF98 sub_1BF8E fn_1BF8E Skeleton: 4 insns; calls sub_1BFA8; RAM AAE0 */
void fn_1BF8E(rec_t *rec)
{
    /* TODO(waveC): body not transcribed (4 instructions). */
}

/* @01BF98-01BFBA sub_1BF98 fn_1BF98 Skeleton: 11 insns; calls sub_1BFA8; RAM 9538,AA34,AAE0,BBE1 */
void fn_1BF98(rec_t *rec)
{
    /* TODO(waveC): body not transcribed (11 instructions). */
}

/* @01BFBA-01BFEC sub_1BFBA fn_1BFBA Skeleton: 13 insns; calls sub_1C050,sub_3A29C,sub_3F3B4,sub_3FEEC; RAM 8EA6,8EA7 */
void fn_1BFBA(rec_t *rec)
{
    /* TODO(waveC): body not transcribed (13 instructions). */
}

/* @01BFEC-01C050 sub_1BFEC fn_1BFEC Skeleton: 28 insns; calls sub_3A29C,sub_3F3B4,sub_3FEEC; RAM 812A,817E,8EA6 */
void fn_1BFEC(rec_t *rec)
{
    /* TODO(waveC): body not transcribed (28 instructions). */
}

/* @01C050-01C0B2 sub_1C050 fn_1C050 Skeleton: 32 insns; calls -; RAM 817E,8EA6,8F6C,8F73,917C,9183,AA36 */
void fn_1C050(rec_t *rec)
{
    /* TODO(waveC): body not transcribed (32 instructions). */
}

/* @01C0B2-01C0DC sub_1C0B2 fn_1C0B2 Skeleton: 11 insns; calls sub_1C124,sub_3FEEC; RAM 8EA6,8EA7,AA39 */
void fn_1C0B2(rec_t *rec)
{
    /* TODO(waveC): body not transcribed (11 instructions). */
}

/* @01C0DC-01C104 sub_1C0DC fn_1C0DC Skeleton: 13 insns; calls sub_1C104,sub_2D5A6,sub_3FEEC; RAM 817E,90F5 */
void fn_1C0DC(rec_t *rec)
{
    /* TODO(waveC): body not transcribed (13 instructions). */
}

/* @01C104-01C124 sub_1C104 fn_1C104 Skeleton: 9 insns; calls sub_1C050,sub_3A5B6,sub_3F172,sub_3F21A,sub_3F3B4,sub_3F586; RAM - */
void fn_1C104(rec_t *rec)
{
    /* TODO(waveC): body not transcribed (9 instructions). */
}

/* @01C124-01C144 sub_1C124 fn_1C124 Skeleton: 9 insns; calls sub_1C050,sub_3A5F8,sub_3F172,sub_3F21A,sub_3F3B4,sub_3F586; RAM - */
void fn_1C124(rec_t *rec)
{
    /* TODO(waveC): body not transcribed (9 instructions). */
}

/* @01C144-01C172 sub_1C144 fn_1C144 Skeleton: 15 insns; calls sub_1C0DC,sub_3293A,sub_3F184,sub_3F356,sub_3FEEC; RAM - */
void fn_1C144(rec_t *rec)
{
    /* TODO(waveC): body not transcribed (15 instructions). */
}

/* @01C172-01C178 sub_1C172 fn_1C172 Skeleton: 2 insns; calls sub_1C17C; RAM - */
void fn_1C172(rec_t *rec)
{
    /* TODO(waveC): body not transcribed (2 instructions). */
}

/* @01C178-01C18E sub_1C178 fn_1C178 Skeleton: 6 insns; calls sub_1C050,sub_3A480,sub_3F3A4,sub_3F586; RAM - */
void fn_1C178(rec_t *rec)
{
    /* TODO(waveC): body not transcribed (6 instructions). */
}

/* @01C18E-01C1CE sub_1C18E fn_1C18E Skeleton: 18 insns; calls sub_1C050,sub_3A35E,sub_3F3B4,sub_3F586,sub_3FEEC; RAM 8EA6,8EA7 */
void fn_1C18E(rec_t *rec)
{
    /* TODO(waveC): body not transcribed (18 instructions). */
}

/* @01C1CE-01C1D2 sub_1C1CE fn_1C1CE Skeleton: 1 insns; calls -; RAM - */
void fn_1C1CE(rec_t *rec)
{
    /* TODO(waveC): body not transcribed (1 instructions). */
}

/* @01C1D2-01C1FC sub_1C1D2 fn_1C1D2 Skeleton: 13 insns; calls sub_1C050,sub_3A35E,sub_3F3B4,sub_3F586,sub_3FEEC; RAM - */
void fn_1C1D2(rec_t *rec)
{
    /* TODO(waveC): body not transcribed (13 instructions). */
}

/* @01C1FC-01C20C sub_1C1FC fn_1C1FC Skeleton: 5 insns; calls sub_3FFA0; RAM A9EE */
void fn_1C1FC(rec_t *rec)
{
    /* TODO(waveC): body not transcribed (5 instructions). */
}

/* @01C20C-01C222 sub_1C20C fn_1C20C Skeleton: 7 insns; calls sub_1BF78,sub_1C6DA; RAM A9EE */
void fn_1C20C(rec_t *rec)
{
    /* TODO(waveC): body not transcribed (7 instructions). */
}

/* @01C222-01C238 sub_1C222 fn_1C222 Skeleton: 7 insns; calls sub_1BF78,sub_3FFA0; RAM A9EE */
void fn_1C222(rec_t *rec)
{
    /* TODO(waveC): body not transcribed (7 instructions). */
}

/* @01C24A-01C252 sub_1C24A fn_1C24A Skeleton: 2 insns; calls -; RAM A9EE */
void fn_1C24A(rec_t *rec)
{
    /* TODO(waveC): body not transcribed (2 instructions). */
}

/* @01C252-01C29A sub_1C252 fn_1C252 Skeleton: 21 insns; calls sub_1C050,sub_1C2BA,sub_1C408,sub_1C4D2,sub_3A29C,sub_3A2D0,sub_3F3B4,sub_3FFA0; RAM 8EA0,8EA8,A9EE */
void fn_1C252(rec_t *rec)
{
    /* TODO(waveC): body not transcribed (21 instructions). */
}

/* @01C29A-01C2A4 sub_1C29A fn_1C29A Skeleton: 4 insns; calls sub_1C2A4; RAM - */
void fn_1C29A(rec_t *rec)
{
    /* TODO(waveC): body not transcribed (4 instructions). */
}

/* @01C2A4-01C2BA sub_1C2A4 fn_1C2A4 Skeleton: 8 insns; calls -; RAM - */
void fn_1C2A4(rec_t *rec)
{
    /* TODO(waveC): body not transcribed (8 instructions). */
}

/* @01C2BA-01C348 sub_1C2BA fn_1C2BA Skeleton: 43 insns; calls sub_1C348,sub_1C3BE,sub_1C3F0,sub_1CCAA,sub_1D5B4,sub_3F386; RAM 8EA0,8EA8,A9EE,AA56 */
void fn_1C2BA(rec_t *rec)
{
    /* TODO(waveC): body not transcribed (43 instructions). */
}

/* @01C348-01C360 sub_1C348 fn_1C348 Skeleton: 7 insns; calls sub_1BFBA,sub_1CCAA,sub_1D5B4; RAM - */
void fn_1C348(rec_t *rec)
{
    /* TODO(waveC): body not transcribed (7 instructions). */
}

/* @01C360-01C394 sub_1C360 fn_1C360 Skeleton: 15 insns; calls sub_1C29A,sub_1C3BE,sub_1C3F0,sub_3F386; RAM AA56 */
void fn_1C360(rec_t *rec)
{
    /* TODO(waveC): body not transcribed (15 instructions). */
}

/* @01C394-01C3BE sub_1C394 fn_1C394 Skeleton: 12 insns; calls sub_1C3BE,sub_1C3F0,sub_3F386; RAM AA56,AD94 */
void fn_1C394(rec_t *rec)
{
    /* TODO(waveC): body not transcribed (12 instructions). */
}

/* @01C3BE-01C3EA sub_1C3BE fn_1C3BE Skeleton: 17 insns; calls sub_3F62E; RAM 8EA0 */
void fn_1C3BE(rec_t *rec)
{
    /* TODO(waveC): body not transcribed (17 instructions). */
}

/* @01C3F0-01C3F4 sub_1C3F0 fn_1C3F0 Skeleton: 2 insns; calls sub_1C3F4; RAM - */
void fn_1C3F0(rec_t *rec)
{
    /* TODO(waveC): body not transcribed (2 instructions). */
}

/* @01C3F4-01C408 sub_1C3F4 fn_1C3F4 Skeleton: 7 insns; calls sub_3F62E; RAM - */
void fn_1C3F4(rec_t *rec)
{
    /* TODO(waveC): body not transcribed (7 instructions). */
}

/* @01C408-01C468 sub_1C408 fn_1C408 Skeleton: 32 insns; calls sub_1C46A,sub_1C4A8,sub_1CCF4,sub_1D5B4; RAM 812A,8EA8,A9EE */
void fn_1C408(rec_t *rec)
{
    /* TODO(waveC): body not transcribed (32 instructions). */
}

/* @01C468-01C46A nullsub_45 fn_1C468 Skeleton: 1 insns; calls -; RAM - */
void fn_1C468(rec_t *rec)
{
    /* TODO(waveC): body not transcribed (1 instructions). */
}

/* @01C46A-01C482 sub_1C46A fn_1C46A Skeleton: 7 insns; calls sub_1BFEC,sub_1CCF4,sub_1D5B4; RAM - */
void fn_1C46A(rec_t *rec)
{
    /* TODO(waveC): body not transcribed (7 instructions). */
}

/* @01C498-01C4A8 sub_1C498 fn_1C498 Skeleton: 4 insns; calls sub_1C4A8; RAM - */
void fn_1C498(rec_t *rec)
{
    /* TODO(waveC): body not transcribed (4 instructions). */
}

/* @01C4A8-01C4D2 sub_1C4A8 fn_1C4A8 Skeleton: 19 insns; calls -; RAM A9EE */
void fn_1C4A8(rec_t *rec)
{
    /* TODO(waveC): body not transcribed (19 instructions). */
}

/* @01C594-01C5AE sub_1C594 fn_1C594 Skeleton: 6 insns; calls sub_1CD7C; RAM 8EA0,8EBD */
void fn_1C594(rec_t *rec)
{
    /* TODO(waveC): body not transcribed (6 instructions). */
}

/* @01C5AE-01C5D2 sub_1C5AE fn_1C5AE Skeleton: 11 insns; calls sub_24E08,sub_24E7E,sub_3FFA0; RAM B056 */
void fn_1C5AE(rec_t *rec)
{
    /* TODO(waveC): body not transcribed (11 instructions). */
}

/* @01C5D2-01C5E8 sub_1C5D2 fn_1C5D2 Skeleton: 5 insns; calls -; RAM B9E4 */
void fn_1C5D2(rec_t *rec)
{
    /* TODO(waveC): body not transcribed (5 instructions). */
}

/* @01C608-01C60E sub_1C608 fn_1C608 Skeleton: 2 insns; calls sub_24E30; RAM - */
void fn_1C608(rec_t *rec)
{
    /* TODO(waveC): body not transcribed (2 instructions). */
}

/* @01C60E-01C61E sub_1C60E fn_1C60E Skeleton: 5 insns; calls sub_21B46,sub_2458A; RAM B9E4 */
void fn_1C60E(rec_t *rec)
{
    /* TODO(waveC): body not transcribed (5 instructions). */
}

/* @01C61E-01C666 sub_1C61E fn_1C61E Skeleton: 22 insns; calls loc_1C666,sub_3DAB2,sub_3DAD4; RAM B9EB */
void fn_1C61E(rec_t *rec)
{
    /* TODO(waveC): body not transcribed (22 instructions). */
}

/* @01C666-01C67A sub_1C666 fn_1C666 Skeleton: 6 insns; calls -; RAM B3F4,B3F5,B9E4,B9EB */
void fn_1C666(rec_t *rec)
{
    /* TODO(waveC): body not transcribed (6 instructions). */
}

/* @01C67A-01C6C2 sub_1C67A fn_1C67A Skeleton: 24 insns; calls loc_1C6C2,sub_3DB18; RAM B9EB,B9EC */
void fn_1C67A(rec_t *rec)
{
    /* TODO(waveC): body not transcribed (24 instructions). */
}

/* @01C6C2-01C6CA sub_1C6C2 fn_1C6C2 Skeleton: 3 insns; calls -; RAM B9E4 */
void fn_1C6C2(rec_t *rec)
{
    /* TODO(waveC): body not transcribed (3 instructions). */
}

/* @01C6CA-01C6D2 sub_1C6CA fn_1C6CA Skeleton: 3 insns; calls -; RAM B9E4 */
void fn_1C6CA(rec_t *rec)
{
    /* TODO(waveC): body not transcribed (3 instructions). */
}

/* @01C6D2-01C6DA sub_1C6D2 fn_1C6D2 Skeleton: 3 insns; calls -; RAM B9E4 */
void fn_1C6D2(rec_t *rec)
{
    /* TODO(waveC): body not transcribed (3 instructions). */
}

/* @01C6DA-01C724 sub_1C6DA fn_1C6DA Skeleton: 27 insns; calls sub_1C724,sub_1C74E,sub_1C82E,sub_1D966,sub_2372C,sub_3FFA0; RAM 8EA6,8EA8 */
void fn_1C6DA(rec_t *rec)
{
    /* TODO(waveC): body not transcribed (27 instructions). */
}

/* @01C724-01C74E sub_1C724 fn_1C724 Skeleton: 13 insns; calls -; RAM 89BE */
void fn_1C724(rec_t *rec)
{
    /* TODO(waveC): body not transcribed (13 instructions). */
}

/* @01C74E-01C7B2 sub_1C74E fn_1C74E Skeleton: 32 insns; calls sub_3293A,sub_3F1F2,sub_3FEEC; RAM - */
void fn_1C74E(rec_t *rec)
{
    /* TODO(waveC): body not transcribed (32 instructions). */
}

/* @01C7B2-01C82E sub_1C7B2 fn_1C7B2 Skeleton: 36 insns; calls sub_1BF78,sub_1C0DC,sub_1C82E,sub_1E974,sub_22352,sub_223BC,sub_3A2D0,sub_3F356; RAM 812A,8EA0,8EA6,A9EE,AA39,ACD6 */
void fn_1C7B2(rec_t *rec)
{
    /* TODO(waveC): body not transcribed (36 instructions). */
}

/* @01C82E-01C85E sub_1C82E fn_1C82E Skeleton: 17 insns; calls -; RAM 817E,8EA6,8EA7 */
void fn_1C82E(rec_t *rec)
{
    /* TODO(waveC): body not transcribed (17 instructions). */
}

/* @01C914-01C93A sub_1C914 fn_1C914 Skeleton: 11 insns; calls sub_19902,sub_22060; RAM 8DD5,8EC3,8EC5,B11E,BBF9 */
void fn_1C914(rec_t *rec)
{
    /* TODO(waveC): body not transcribed (11 instructions). */
}

/* @01C940-01C9B4 sub_1C940 fn_1C940 Skeleton: 28 insns; calls sub_34DC2; RAM 8122,8126,812A,817E,8EA0 */
void fn_1C940(rec_t *rec)
{
    /* TODO(waveC): body not transcribed (28 instructions). */
}

/* @01C9B4-01C9C2 sub_1C9B4 fn_1C9B4 Skeleton: 3 insns; calls sub_1CA72; RAM A9EE */
void fn_1C9B4(rec_t *rec)
{
    /* TODO(waveC): body not transcribed (3 instructions). */
}

/* @01C9C2-01C9E8 sub_1C9C2 fn_1C9C2 Skeleton: 11 insns; calls sub_3FFB4; RAM 8D20,8EA0 */
void fn_1C9C2(rec_t *rec)
{
    /* TODO(waveC): body not transcribed (11 instructions). */
}

/* @01C9E8-01CA8C sub_1C9E8 fn_1C9E8 Skeleton: 49 insns; calls loc_1C93F,sub_198DC,sub_1CA90,sub_1CC80,sub_1CDBA,sub_3F636,sub_3FFA0,sub_5E5AE; RAM 8D20,8DDC,8EB5,8EB6,8EB7,A9E6,B0AA,B11E */
void fn_1C9E8(rec_t *rec)
{
    /* TODO(waveC): body not transcribed (49 instructions). */
}

/* @01CA8C-01CA90 sub_1CA8C fn_1CA8C Skeleton: 1 insns; calls -; RAM 8EB3 */
void fn_1CA8C(rec_t *rec)
{
    /* TODO(waveC): body not transcribed (1 instructions). */
}

/* @01CA90-01CAB6 sub_1CA90 fn_1CA90 Skeleton: 11 insns; calls sub_198DC,sub_1CC80; RAM 8D20,8EB4,8EB6,B0AA,B11E */
void fn_1CA90(rec_t *rec)
{
    /* TODO(waveC): body not transcribed (11 instructions). */
}

/* @01CAC0-01CAD0 sub_1CAC0 fn_1CAC0 Skeleton: 4 insns; calls sub_1CC80,sub_5E5AE; RAM B0AA */
void fn_1CAC0(rec_t *rec)
{
    /* TODO(waveC): body not transcribed (4 instructions). */
}

/* @01CAD0-01CAF8 sub_1CAD0 fn_1CAD0 Skeleton: 13 insns; calls -; RAM 8D20,8EB3,8EB4,8EB5,8EB6,8EB7,B11E */
void fn_1CAD0(rec_t *rec)
{
    /* TODO(waveC): body not transcribed (13 instructions). */
}

/* @01CAF8-01CB20 sub_1CAF8 fn_1CAF8 Skeleton: 13 insns; calls -; RAM 8D20,8EB3,8EB4,8EB5,8EB6,8EB7,B11E */
void fn_1CAF8(rec_t *rec)
{
    /* TODO(waveC): body not transcribed (13 instructions). */
}

/* @01CB20-01CB44 sub_1CB20 fn_1CB20 Skeleton: 11 insns; calls -; RAM 8D20,8EB3,8EB4,8EB5,8EB6,8EB7,B11E */
void fn_1CB20(rec_t *rec)
{
    /* TODO(waveC): body not transcribed (11 instructions). */
}

/* @01CB44-01CB68 sub_1CB44 fn_1CB44 Skeleton: 11 insns; calls -; RAM 8D20,8EB3,8EB4,8EB5,8EB6,8EB7,B11E */
void fn_1CB44(rec_t *rec)
{
    /* TODO(waveC): body not transcribed (11 instructions). */
}

/* @01CB68-01CB8C sub_1CB68 fn_1CB68 Skeleton: 11 insns; calls -; RAM 8D20,8EB3,8EB4,8EB5,8EB6,8EB7,B11E */
void fn_1CB68(rec_t *rec)
{
    /* TODO(waveC): body not transcribed (11 instructions). */
}

/* @01CB8C-01CBB0 sub_1CB8C fn_1CB8C Skeleton: 11 insns; calls -; RAM 8D20,8EB3,8EB4,8EB5,8EB6,8EB7,B11E */
void fn_1CB8C(rec_t *rec)
{
    /* TODO(waveC): body not transcribed (11 instructions). */
}

/* @01CBB0-01CBD4 sub_1CBB0 fn_1CBB0 Skeleton: 11 insns; calls -; RAM 8D20,8EB3,8EB4,8EB5,8EB6,8EB7,B11E */
void fn_1CBB0(rec_t *rec)
{
    /* TODO(waveC): body not transcribed (11 instructions). */
}

/* @01CBD4-01CBE6 sub_1CBD4 fn_1CBD4 Skeleton: 4 insns; calls sub_1CC80; RAM 8EA5 */
void fn_1CBD4(rec_t *rec)
{
    /* TODO(waveC): body not transcribed (4 instructions). */
}

/* @01CBE6-01CC62 sub_1CBE6 fn_1CBE6 Skeleton: 48 insns; calls sub_1CAD0,sub_1CAF8,sub_1CB20,sub_1CB44,sub_1CB68,sub_1CB8C,sub_1CBB0; RAM 8EB3,8EB6,B0AA */
void fn_1CBE6(rec_t *rec)
{
    /* TODO(waveC): body not transcribed (48 instructions). */
}

/* @01CC62-01CC80 sub_1CC62 fn_1CC62 Skeleton: 12 insns; calls -; RAM 8EB3,8EB6 */
void fn_1CC62(rec_t *rec)
{
    /* TODO(waveC): body not transcribed (12 instructions). */
}

/* @01CC80-01CCAA sub_1CC80 fn_1CC80 Skeleton: 16 insns; calls -; RAM 8EB3,8EB6 */
void fn_1CC80(rec_t *rec)
{
    /* TODO(waveC): body not transcribed (16 instructions). */
}

/* @01CCAA-01CCB0 sub_1CCAA fn_1CCAA Skeleton: 2 insns; calls sub_1CC80; RAM - */
void fn_1CCAA(rec_t *rec)
{
    /* TODO(waveC): body not transcribed (2 instructions). */
}

/* @01CCF4-01CCFA sub_1CCF4 fn_1CCF4 Skeleton: 2 insns; calls sub_1CBE6; RAM - */
void fn_1CCF4(rec_t *rec)
{
    /* TODO(waveC): body not transcribed (2 instructions). */
}

/* @01CCFA-01CD26 sub_1CCFA fn_1CCFA Skeleton: 13 insns; calls loc_1CD26; RAM 8D20,8EB3,8EBE,8EBF */
void fn_1CCFA(rec_t *rec)
{
    /* TODO(waveC): body not transcribed (13 instructions). */
}

/* @01CD7C-01CDBA sub_1CD7C fn_1CD7C Skeleton: 18 insns; calls sub_198DC,sub_5E5BE; RAM 8D20,8EB3,8EC0,8EC1 */
void fn_1CD7C(rec_t *rec)
{
    /* TODO(waveC): body not transcribed (18 instructions). */
}

/* @01CDBA-01CDFA sub_1CDBA fn_1CDBA Skeleton: 19 insns; calls sub_1C9E8,sub_1CA8C,sub_1CB8C,sub_20FC4,sub_5E5BE; RAM 8D20,8EB3,AA3D,B0AA */
void fn_1CDBA(rec_t *rec)
{
    /* TODO(waveC): body not transcribed (19 instructions). */
}

/* @01CDFA-01CE6C sub_1CDFA fn_1CDFA Skeleton: 40 insns; calls sub_1CB20,sub_1CB8C,sub_1CC80,sub_20FC4,sub_21F00,sub_21F6C,sub_22060,sub_5E5BE; RAM 8D20,8DD5,8EA0,8EB6,8EC5 */
void fn_1CDFA(rec_t *rec)
{
    /* TODO(waveC): body not transcribed (40 instructions). */
}

/* @01CE6C-01CE80 sub_1CE6C fn_1CE6C Skeleton: 6 insns; calls loc_1C93F,sub_1CE8A; RAM 8D20,A9EE */
void fn_1CE6C(rec_t *rec)
{
    /* TODO(waveC): body not transcribed (6 instructions). */
}

/* @01CE80-01CEB6 sub_1CE80 fn_1CE80 Skeleton: 15 insns; calls loc_63C03,loc_64445,sub_1CDBA,sub_1CDFA,sub_1CEB6,sub_3FFA0; RAM 8DD7,A9EE,AA3D */
void fn_1CE80(rec_t *rec)
{
    /* TODO(waveC): body not transcribed (15 instructions). */
}

/* @01CEB6-01CEC4 sub_1CEB6 fn_1CEB6 Skeleton: 5 insns; calls -; RAM 8DD7 */
void fn_1CEB6(rec_t *rec)
{
    /* TODO(waveC): body not transcribed (5 instructions). */
}

/* @01CEC4-01CF0A sub_1CEC4 fn_1CEC4 Skeleton: 25 insns; calls sub_148A0,sub_3FFA0; RAM 8DD8,AD68,AD9D,B054,B055 */
void fn_1CEC4(rec_t *rec)
{
    /* TODO(waveC): body not transcribed (25 instructions). */
}

/* @01CF0A-01CF4C sub_1CF0A fn_1CF0A Skeleton: 19 insns; calls sub_1494C,sub_193B2,sub_3FFA0; RAM 817E,89C1,9548,AAE0,BBEB */
void fn_1CF0A(rec_t *rec)
{
    /* TODO(waveC): body not transcribed (19 instructions). */
}

/* @01CF80-01D052 sub_1CF80 fn_1CF80 Skeleton: 61 insns; calls loc_1D122,sub_2B9BC,sub_2C342,sub_68B5C,sub_68C30,sub_68CC6; RAM A8CE,A9EE,A9F9,AD99,AD9A,B056 */
void fn_1CF80(rec_t *rec)
{
    /* TODO(waveC): body not transcribed (61 instructions). */
}

/* @01D052-01D06A sub_1D052 fn_1D052 Skeleton: 5 insns; calls sub_50498; RAM A9EE,BBEC */
void fn_1D052(rec_t *rec)
{
    /* TODO(waveC): body not transcribed (5 instructions). */
}

/* @01D06A-01D07A sub_1D06A fn_1D06A Skeleton: 4 insns; calls sub_505BE; RAM A9EE */
void fn_1D06A(rec_t *rec)
{
    /* TODO(waveC): body not transcribed (4 instructions). */
}

/* @01D07A-01D0FC sub_1D07A fn_1D07A Skeleton: 32 insns; calls loc_1D158,sub_1D0FC; RAM A9EE,A9F9,A9FA,AD9A,B056,B2A5 */
void fn_1D07A(rec_t *rec)
{
    /* TODO(waveC): body not transcribed (32 instructions). */
}

/* @01D0FC-01D15E sub_1D0FC fn_1D0FC Skeleton: 28 insns; calls sub_14924,sub_3F636,sub_3FFA0,sub_68D90; RAM 9D28,9D42,A4F5,A8CE,A9FA,B056 */
void fn_1D0FC(rec_t *rec)
{
    /* TODO(waveC): body not transcribed (28 instructions). */
}

/* @01D164-01D18C sub_1D164 fn_1D164 Skeleton: 12 insns; calls sub_14930,sub_3FFA0; RAM A9EE,AD9A,B056 */
void fn_1D164(rec_t *rec)
{
    /* TODO(waveC): body not transcribed (12 instructions). */
}

/* @01D18C-01D1BA sub_1D18C fn_1D18C Skeleton: 13 insns; calls -; RAM A4F5,A9F9,A9FA,BBEC,BBED */
void fn_1D18C(rec_t *rec)
{
    /* TODO(waveC): body not transcribed (13 instructions). */
}

/* @01D1CA-01D1EE sub_1D1CA fn_1D1CA Skeleton: 11 insns; calls loc_1D202,sub_1C82E,sub_1F782,sub_3F1F2; RAM 812A,A9EE */
void fn_1D1CA(rec_t *rec)
{
    /* TODO(waveC): body not transcribed (11 instructions). */
}

/* @01D1EE-01D220 sub_1D1EE fn_1D1EE Skeleton: 16 insns; calls sub_1C82E,sub_1D220,sub_1D332,sub_3F1F2,sub_3FFA0; RAM 812A,A9EE */
void fn_1D1EE(rec_t *rec)
{
    /* TODO(waveC): body not transcribed (16 instructions). */
}

/* @01D220-01D2BA sub_1D220 fn_1D220 Skeleton: 45 insns; calls loc_1D528,loc_1D56B,sub_1938A,sub_1BF40,sub_1C104,sub_1D2EE,sub_1EF08,sub_3ECB8; RAM 812A,9101,94C1,A9F9,AA39,AA56 */
void fn_1D220(rec_t *rec)
{
    /* TODO(waveC): body not transcribed (45 instructions). */
}

/* @01D2C0-01D2EE sub_1D2C0 fn_1D2C0 Skeleton: 14 insns; calls loc_1D300,sub_193F8,sub_3ECB8; RAM 8122,8A58,90FE */
void fn_1D2C0(rec_t *rec)
{
    /* TODO(waveC): body not transcribed (14 instructions). */
}

/* @01D2EE-01D300 sub_1D2EE fn_1D2EE Skeleton: 6 insns; calls loc_1D300,sub_193F8; RAM 8A58 */
void fn_1D2EE(rec_t *rec)
{
    /* TODO(waveC): body not transcribed (6 instructions). */
}

/* @01D300-01D332 sub_1D300 fn_1D300 Skeleton: 17 insns; calls -; RAM 89CB */
void fn_1D300(rec_t *rec)
{
    /* TODO(waveC): body not transcribed (17 instructions). */
}

/* @01D332-01D38C sub_1D332 fn_1D332 Skeleton: 29 insns; calls sub_1BF78,sub_1C0DC,sub_1C82E,sub_1D396,sub_20DB8,sub_3F356; RAM 812A,90F6,AA39 */
void fn_1D332(rec_t *rec)
{
    /* TODO(waveC): body not transcribed (29 instructions). */
}

/* @01D396-01D3A4 sub_1D396 fn_1D396 Skeleton: 5 insns; calls -; RAM - */
void fn_1D396(rec_t *rec)
{
    /* TODO(waveC): body not transcribed (5 instructions). */
}

/* @01D3A4-01D3D0 sub_1D3A4 fn_1D3A4 Skeleton: 13 insns; calls sub_1BFBA,sub_1BFEC,sub_1C82E,sub_1E9BC,sub_3FFA0; RAM 8EA7,A9EE */
void fn_1D3A4(rec_t *rec)
{
    /* TODO(waveC): body not transcribed (13 instructions). */
}

/* @01D3D0-01D3D4 sub_1D3D0 fn_1D3D0 Skeleton: 1 insns; calls -; RAM A9F0 */
void fn_1D3D0(rec_t *rec)
{
    /* TODO(waveC): body not transcribed (1 instructions). */
}

/* @01D3D4-01D3E2 sub_1D3D4 fn_1D3D4 Skeleton: 6 insns; calls sub_1D40E,sub_3FFA0; RAM - */
void fn_1D3D4(rec_t *rec)
{
    /* TODO(waveC): body not transcribed (6 instructions). */
}

/* @01D40E-01D4DA sub_1D40E fn_1D40E Skeleton: 60 insns; calls loc_1D516,loc_1D528,loc_1D56B,sub_1BF40,sub_1C104,sub_1C82E,sub_1CCAA,sub_1CCF4; RAM 800F,8010,812A,8EA6 */
void fn_1D40E(rec_t *rec)
{
    /* TODO(waveC): body not transcribed (60 instructions). */
}

/* @01D4DA-01D528 sub_1D4DA fn_1D4DA Skeleton: 22 insns; calls sub_1C050,sub_1CCF4,sub_1E9BC,sub_1FA1C,sub_1FA26,sub_2402E,sub_3A538,sub_3F3A4; RAM 8EA7 */
void fn_1D4DA(rec_t *rec)
{
    /* TODO(waveC): body not transcribed (22 instructions). */
}

/* @01D528-01D544 sub_1D528 fn_1D528 Skeleton: 7 insns; calls -; RAM - */
void fn_1D528(rec_t *rec)
{
    /* TODO(waveC): body not transcribed (7 instructions). */
}

/* @01D56C-01D584 sub_1D56C fn_1D56C Skeleton: 9 insns; calls sub_1D528,sub_3CCD0; RAM - */
void fn_1D56C(rec_t *rec)
{
    /* TODO(waveC): body not transcribed (9 instructions). */
}

/* @01D5B4-01D5E2 sub_1D5B4 fn_1D5B4 Skeleton: 13 insns; calls sub_342D8; RAM - */
void fn_1D5B4(rec_t *rec)
{
    /* TODO(waveC): body not transcribed (13 instructions). */
}

/* @01D5E2-01D64C sub_1D5E2 fn_1D5E2 Skeleton: 31 insns; calls loc_1DA5E,sub_1D67C,sub_1D6B4,sub_1D714,sub_33DC8,sub_342D8,sub_3A2D0,sub_3A474; RAM 800F,8010,812A,8EA7,8EA8,8EAA */
void fn_1D5E2(rec_t *rec)
{
    /* TODO(waveC): body not transcribed (31 instructions). */
}

/* @01D67C-01D6B4 sub_1D67C fn_1D67C Skeleton: 18 insns; calls sub_2EAF2,sub_2EB0C; RAM 8EE0,8EE1,AAE0 */
void fn_1D67C(rec_t *rec)
{
    /* TODO(waveC): body not transcribed (18 instructions). */
}

/* @01D6B4-01D6C2 sub_1D6B4 fn_1D6B4 Skeleton: 3 insns; calls loc_1D6CE; RAM 8EA6,8EA7 */
void fn_1D6B4(rec_t *rec)
{
    /* TODO(waveC): body not transcribed (3 instructions). */
}

/* @01D6C2-01D6CE sub_1D6C2 fn_1D6C2 Skeleton: 2 insns; calls -; RAM 8EA6,8EA7 */
void fn_1D6C2(rec_t *rec)
{
    /* TODO(waveC): body not transcribed (2 instructions). */
}

/* @01D714-01D744 sub_1D714 fn_1D714 Skeleton: 14 insns; calls sub_2D5A6,sub_3F36E; RAM 8EA6,8EA7,8EA8 */
void fn_1D714(rec_t *rec)
{
    /* TODO(waveC): body not transcribed (14 instructions). */
}

/* @01D744-01D774 sub_1D744 fn_1D744 Skeleton: 13 insns; calls sub_1D7FA,sub_3F356; RAM 812A */
void fn_1D744(rec_t *rec)
{
    /* TODO(waveC): body not transcribed (13 instructions). */
}

/* @01D774-01D786 sub_1D774 fn_1D774 Skeleton: 6 insns; calls -; RAM 812A */
void fn_1D774(rec_t *rec)
{
    /* TODO(waveC): body not transcribed (6 instructions). */
}

/* @01D786-01D7B4 sub_1D786 fn_1D786 Skeleton: 14 insns; calls sub_3F184,sub_3F2CA; RAM 812A */
void fn_1D786(rec_t *rec)
{
    /* TODO(waveC): body not transcribed (14 instructions). */
}

/* @01D7B4-01D7B8 sub_1D7B4 fn_1D7B4 Skeleton: 1 insns; calls sub_24006; RAM - */
void fn_1D7B4(rec_t *rec)
{
    /* TODO(waveC): body not transcribed (1 instructions). */
}

/* @01D7B8-01D7FA sub_1D7B8 fn_1D7B8 Skeleton: 17 insns; calls sub_2415A; RAM 8992,8EA7 */
void fn_1D7B8(rec_t *rec)
{
    /* TODO(waveC): body not transcribed (17 instructions). */
}

/* @01D7FA-01D80C sub_1D7FA fn_1D7FA Skeleton: 5 insns; calls loc_1D744,sub_32FA2,sub_32FF4,sub_33DB4; RAM - */
void fn_1D7FA(rec_t *rec)
{
    /* TODO(waveC): body not transcribed (5 instructions). */
}

/* @01D824-01D866 sub_1D824 fn_1D824 Skeleton: 17 insns; calls sub_23DC6; RAM 8992,8EA7 */
void fn_1D824(rec_t *rec)
{
    /* TODO(waveC): body not transcribed (17 instructions). */
}

/* @01D866-01D878 sub_1D866 fn_1D866 Skeleton: 5 insns; calls loc_1D744,sub_32FA2,sub_32FF4,sub_33DB4; RAM - */
void fn_1D866(rec_t *rec)
{
    /* TODO(waveC): body not transcribed (5 instructions). */
}

/* @01D888-01D89C sub_1D888 fn_1D888 Skeleton: 6 insns; calls sub_1C6DA,sub_3FFA0; RAM A9EE */
void fn_1D888(rec_t *rec)
{
    /* TODO(waveC): body not transcribed (6 instructions). */
}

/* @01D89C-01D8E8 sub_1D89C fn_1D89C Skeleton: 23 insns; calls sub_1BFEC,sub_1C0DC,sub_223BC,sub_3F184,sub_3F21A,sub_3F356,sub_3FEEC,sub_3FFA0; RAM 812A,8EA0,A9EE,ACD6 */
void fn_1D89C(rec_t *rec)
{
    /* TODO(waveC): body not transcribed (23 instructions). */
}

/* @01D8F8-01D906 sub_1D8F8 fn_1D8F8 Skeleton: 4 insns; calls sub_1C82E; RAM A9EE */
void fn_1D8F8(rec_t *rec)
{
    /* TODO(waveC): body not transcribed (4 instructions). */
}

/* @01D906-01D948 sub_1D906 fn_1D906 Skeleton: 17 insns; calls sub_1C144,sub_1C4D2,sub_1D950,sub_3F6F2,sub_3FFA0; RAM 812A,8EA8,A9EE,AA56 */
void fn_1D906(rec_t *rec)
{
    /* TODO(waveC): body not transcribed (17 instructions). */
}

/* @01D950-01D966 sub_1D950 fn_1D950 Skeleton: 9 insns; calls -; RAM - */
void fn_1D950(rec_t *rec)
{
    /* TODO(waveC): body not transcribed (9 instructions). */
}

/* @01D966-01D99A sub_1D966 fn_1D966 Skeleton: 19 insns; calls sub_1D950; RAM - */
void fn_1D966(rec_t *rec)
{
    /* TODO(waveC): body not transcribed (19 instructions). */
}

/* @01D99A-01DA32 sub_1D99A fn_1D99A Skeleton: 40 insns; calls sub_1C0DC,sub_1C17C,sub_1C82E,sub_3F36E,sub_3FFA0; RAM 812A,8EA0,A9EE */
void fn_1D99A(rec_t *rec)
{
    /* TODO(waveC): body not transcribed (40 instructions). */
}

/* @01DA54-01DA5E sub_1DA54 fn_1DA54 Skeleton: 2 insns; calls -; RAM A9EE */
void fn_1DA54(rec_t *rec)
{
    /* TODO(waveC): body not transcribed (2 instructions). */
}

/* @01DA5E-01DB04 sub_1DA5E fn_1DA5E Skeleton: 48 insns; calls sub_1C82E,sub_22352,sub_223BC,sub_3FEEC; RAM 812A,8EA0,8EAA,AA39 */
void fn_1DA5E(rec_t *rec)
{
    /* TODO(waveC): body not transcribed (48 instructions). */
}

/* @01DB04-01DB0A sub_1DB04 fn_1DB04 Skeleton: 2 insns; calls sub_3FFA0; RAM - */
void fn_1DB04(rec_t *rec)
{
    /* TODO(waveC): body not transcribed (2 instructions). */
}

/* @01DB4C-01DB54 sub_1DB4C fn_1DB4C Skeleton: 2 insns; calls loc_1DB60; RAM AA33 */
void fn_1DB4C(rec_t *rec)
{
    /* TODO(waveC): body not transcribed (2 instructions). */
}

/* @01DB54-01DB5A sub_1DB54 fn_1DB54 Skeleton: 2 insns; calls sub_1E73C; RAM - */
void fn_1DB54(rec_t *rec)
{
    /* TODO(waveC): body not transcribed (2 instructions). */
}

/* @01DB5A-01DBC8 sub_1DB5A fn_1DB5A Skeleton: 33 insns; calls sub_1C050,sub_1DBC8,sub_1DC52,sub_1E240,sub_1E260,sub_1E506,sub_1E63E; RAM 817E,95AC,95AD,AA33 */
void fn_1DB5A(rec_t *rec)
{
    /* TODO(waveC): body not transcribed (33 instructions). */
}

/* @01DBC8-01DC52 sub_1DBC8 fn_1DBC8 Skeleton: 46 insns; calls sub_1DCA6,sub_1DDE4,sub_1E388,sub_2EAEE,sub_325FA,sub_32798,sub_EC0A; RAM 94C1,A9EE,AA31 */
void fn_1DBC8(rec_t *rec)
{
    /* TODO(waveC): body not transcribed (46 instructions). */
}

/* @01DC52-01DCA6 sub_1DC52 fn_1DC52 Skeleton: 31 insns; calls -; RAM 89BE */
void fn_1DC52(rec_t *rec)
{
    /* TODO(waveC): body not transcribed (31 instructions). */
}

/* @01DCA6-01DDCC sub_1DCA6 fn_1DCA6 Skeleton: 80 insns; calls loc_1E093,sub_1DC52,sub_1DDE4,sub_1DF7A,sub_1E0DC,sub_1E110,sub_1E6D4; RAM A9EE */
void fn_1DCA6(rec_t *rec)
{
    /* TODO(waveC): body not transcribed (80 instructions). */
}

/* @01DDCC-01DDE4 sub_1DDCC fn_1DDCC Skeleton: 8 insns; calls -; RAM 94C1 */
void fn_1DDCC(rec_t *rec)
{
    /* TODO(waveC): body not transcribed (8 instructions). */
}

/* @01DDE4-01DE1C sub_1DDE4 fn_1DDE4 Skeleton: 17 insns; calls loc_1DE50,sub_3F924,sub_3F94C; RAM A9EE */
void fn_1DDE4(rec_t *rec)
{
    /* TODO(waveC): body not transcribed (17 instructions). */
}

/* @01DE50-01DE78 sub_1DE50 fn_1DE50 Skeleton: 11 insns; calls loc_1DEAE,sub_1DEC6; RAM A9EE */
void fn_1DE50(rec_t *rec)
{
    /* TODO(waveC): body not transcribed (11 instructions). */
}

/* @01DE78-01DE8C sub_1DE78 fn_1DE78 Skeleton: 5 insns; calls sub_3F94C; RAM - */
void fn_1DE78(rec_t *rec)
{
    /* TODO(waveC): body not transcribed (5 instructions). */
}

/* @01DEC6-01DEEA sub_1DEC6 fn_1DEC6 Skeleton: 11 insns; calls -; RAM - */
void fn_1DEC6(rec_t *rec)
{
    /* TODO(waveC): body not transcribed (11 instructions). */
}

/* @01DF7A-01E064 sub_1DF7A fn_1DF7A Skeleton: 60 insns; calls sub_3F778,sub_3F986,sub_3FA2C,sub_EC0A; RAM A9EE,AA3E,AA46,AA48 */
void fn_1DF7A(rec_t *rec)
{
    /* TODO(waveC): body not transcribed (60 instructions). */
}

/* @01E094-01E0DC sub_1E094 fn_1E094 Skeleton: 16 insns; calls sub_3F94C; RAM AA3E */
void fn_1E094(rec_t *rec)
{
    /* TODO(waveC): body not transcribed (16 instructions). */
}

/* @01E0DC-01E110 sub_1E0DC fn_1E0DC Skeleton: 14 insns; calls sub_3F924,sub_3F94C; RAM - */
void fn_1E0DC(rec_t *rec)
{
    /* TODO(waveC): body not transcribed (14 instructions). */
}

/* @01E110-01E1A4 sub_1E110 fn_1E110 Skeleton: 39 insns; calls sub_1DC52,sub_1E240,sub_32650,sub_3F5B2; RAM A9EE */
void fn_1E110(rec_t *rec)
{
    /* TODO(waveC): body not transcribed (39 instructions). */
}

/* @01E238-01E260 sub_1E238 fn_1E238 Skeleton: 13 insns; calls -; RAM 89BF,AAE0,AAE1 */
void fn_1E238(rec_t *rec)
{
    /* TODO(waveC): body not transcribed (13 instructions). */
}

/* @01E260-01E30A sub_1E260 fn_1E260 Skeleton: 47 insns; calls sub_1C360,sub_1DDCC,sub_1E30A,sub_1E6D4,sub_2EB02,sub_2EB08,sub_3A29C,sub_3A2D0; RAM 94C1,A9EE */
void fn_1E260(rec_t *rec)
{
    /* TODO(waveC): body not transcribed (47 instructions). */
}

/* @01E30A-01E388 sub_1E30A fn_1E30A Skeleton: 33 insns; calls sub_1E240,sub_32650,sub_3F586,sub_3F5B2; RAM A9EE */
void fn_1E30A(rec_t *rec)
{
    /* TODO(waveC): body not transcribed (33 instructions). */
}

/* @01E388-01E43E sub_1E388 fn_1E388 Skeleton: 39 insns; calls sub_1E4EC,sub_3F5EE,sub_3F94C; RAM A9EE,AA3E */
void fn_1E388(rec_t *rec)
{
    /* TODO(waveC): body not transcribed (39 instructions). */
}

/* @01E43E-01E4EC sub_1E43E fn_1E43E Skeleton: 48 insns; calls sub_1DC52,sub_1E110,sub_1E4EC,sub_1FA1C,sub_3F924,sub_3F94C; RAM - */
void fn_1E43E(rec_t *rec)
{
    /* TODO(waveC): body not transcribed (48 instructions). */
}

/* @01E4EC-01E506 sub_1E4EC fn_1E4EC Skeleton: 9 insns; calls -; RAM - */
void fn_1E4EC(rec_t *rec)
{
    /* TODO(waveC): body not transcribed (9 instructions). */
}

/* @01E506-01E59E sub_1E506 fn_1E506 Skeleton: 43 insns; calls sub_1E59E,sub_1E5F6,sub_1E620,sub_3ECD4,sub_3F5B2; RAM 800F,89BE,89C0 */
void fn_1E506(rec_t *rec)
{
    /* TODO(waveC): body not transcribed (43 instructions). */
}

/* @01E59E-01E5EE sub_1E59E fn_1E59E Skeleton: 25 insns; calls sub_32650,sub_3ECB8,sub_3F5EE; RAM - */
void fn_1E59E(rec_t *rec)
{
    /* TODO(waveC): body not transcribed (25 instructions). */
}

/* @01E5F6-01E620 sub_1E5F6 fn_1E5F6 Skeleton: 13 insns; calls sub_3ECB8,sub_3EFAE; RAM - */
void fn_1E5F6(rec_t *rec)
{
    /* TODO(waveC): body not transcribed (13 instructions). */
}

/* @01E620-01E63E sub_1E620 fn_1E620 Skeleton: 10 insns; calls sub_3ECB8,sub_3EFAE; RAM - */
void fn_1E620(rec_t *rec)
{
    /* TODO(waveC): body not transcribed (10 instructions). */
}

/* @01E63E-01E646 sub_1E63E fn_1E63E Skeleton: 3 insns; calls -; RAM - */
void fn_1E63E(rec_t *rec)
{
    /* TODO(waveC): body not transcribed (3 instructions). */
}

/* @01E646-01E6BE sub_1E646 fn_1E646 Skeleton: 39 insns; calls sub_3ECB8,sub_3F5B2; RAM - */
void fn_1E646(rec_t *rec)
{
    /* TODO(waveC): body not transcribed (39 instructions). */
}

/* @01E6BE-01E6D4 sub_1E6BE fn_1E6BE Skeleton: 6 insns; calls sub_1E6E8; RAM B383,B384,B386 */
void fn_1E6BE(rec_t *rec)
{
    /* TODO(waveC): body not transcribed (6 instructions). */
}

/* @01E6D4-01E6E2 sub_1E6D4 fn_1E6D4 Skeleton: 5 insns; calls -; RAM - */
void fn_1E6D4(rec_t *rec)
{
    /* TODO(waveC): body not transcribed (5 instructions). */
}

/* @01E6E2-01E73C sub_1E6E2 fn_1E6E2 Skeleton: 29 insns; calls sub_3ECB8,sub_3F5B2; RAM A9EE */
void fn_1E6E2(rec_t *rec)
{
    /* TODO(waveC): body not transcribed (29 instructions). */
}
