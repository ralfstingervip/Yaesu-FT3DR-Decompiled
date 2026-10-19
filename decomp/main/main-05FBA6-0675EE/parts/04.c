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
 * 0644DC-0644FA (30 B)  gm_touch_s7_probe  [sub_0644DC]  Confirmed
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
