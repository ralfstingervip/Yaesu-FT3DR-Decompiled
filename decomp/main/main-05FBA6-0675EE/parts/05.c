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
