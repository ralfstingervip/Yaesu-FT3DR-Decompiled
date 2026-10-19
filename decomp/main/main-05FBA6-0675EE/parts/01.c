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
