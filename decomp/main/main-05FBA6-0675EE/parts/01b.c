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
