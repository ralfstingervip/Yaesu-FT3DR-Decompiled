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
