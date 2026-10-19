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
 * 0636B2-063720 (110 B)  wx_rx_room_status  [sub_6363C sibling, sub_636B2]
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
