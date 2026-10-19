/* ==========================================================================
 * PART 2  0x030CE6-0x032442   Band-B receive: dispatcher, retune, latch,
 *                             RX states (twins of part 1), APRS hook
 *
 * Band B uses the record [FF8126] (normally FF8FE8; FF922C alternate) in
 * er0, RAM block +0x108 above band A (FF8F86 -> FF908E, FF8F88 -> FF9090,
 * FF8F89 -> FF9091, FF8F85 -> FF908D, FF8FE2 -> FF90EA), its own timers,
 * RF-status line 0xFFFF4D.b2 (doc 93) and AN4 (doc 137).
 *
 * Twin map (band A part 1 -> band B here):
 *   2FE44->3197A  2FEB2->319C8  2FF0A->31A20  2FF48->31A5E  2FF78->31A8E
 *   3000C->31B02  3008C->31B62  3016C->31C20  3019E->31C52  302A0->31D32
 *   30310->31D82  30410->31E60  304DC->31F0A  30590->31F9E  30654->32058
 *   306B2->320B6  306EA->3210C  307E0/3080C->32202/32240  308BE->322D6
 *   309D6->32354  309F2->3236A  30A0C->32378  30A24->32386  30A66->323B8
 *   30ADC->3242E  30AEE->32430   (outside: 2F4AA->30FA4, 2FB94->3163C,
 *   2FBE2->3168A, 2FAEC->31594, 2F5EE->310E8, 2F550->3104A, 2F55A->31054,
 *   2F578->31072, 2FCC8->31836, 2FA7C->31524, 2F69E->3118C, 2FC6E->317DC)
 * ========================================================================== */

/* --------------------------------------------------------------------------
 * 030CE6-030DA8  size 194  rxb_dispatch                (IDA sub_30CE6)
 * Caller: sub_30A2 (main loop, doc 90).  Confirmed.
 * Band-B receiver tick.  Clears AA36.b5 (band-B busy); an external "6"
 * posted in FFAAB9 becomes this band's event.  The one-shot event byte
 * rec+0x8C is dispatched through table 0x030DA8:
 *   1,2,7 -> rxb_decoder_reinit, state 0
 *   3     -> reinit; if state >= 3 re-select the squelch state
 *   4,5   -> reinit; if state >= 3: pager hold FF95AD = 0, decoder setup
 *   6     -> reinit + rxb_retune_start (frequency change)
 * Events other than 6/7 also clear rec+0x92.  Then the state handler from
 * table 0x030DC8[rec+0x93] runs:
 *   0 3118C 1 31524 2 316B2(rts) 3 316B4 4 3197A 5 31D32 6 31D82 7 31E60
 *   8 31F0A 9 31B02 0xA 31B62 0xB 31C52 0xC 31A8E 0xD 316B4
 * Tail: DT indicator (digital mode), AF-dual monitor sub_32E8E, band-B
 * serial IF/AGC refresh sub_380EA, synthesizer retune when +0x94, and the
 * squelch byte is mirrored to BB97.
 * -------------------------------------------------------------------------- */
typedef void (*rx_state_fn)(u8 *r);
extern const rx_state_fn rxb_state_tbl[14];                 /* 0x030DC8 */

void rxb_dispatch(u8 *r)
{
    u8 ev;
    rx_busy_AA36 &= ~0x20;
    if (rxb_ext_event_AAB9 == 6) { rxb_ext_event_AAB9 = 0; r_event(r) = 6; }
    ev = r_event(r);
    if (ev != 0) {
        if (ev != 6 && ev != 7) r_flags92(r) = 0;
        switch (ev) {                                        /* off_30DA8 */
        case 1: case 2: case 7:
            rxb_decoder_reinit(r); r_state(r) = 0; break;
        case 3:
            rxb_decoder_reinit(r);
            if (r_state(r) >= 3) rxb_select_state(r);
            break;
        case 4: case 5:
            rxb_decoder_reinit(r);
            if (r_state(r) >= 3) { t100_rxb_pager_hold = 0; rxb_tone_decoder_setup(r); }
            break;
        case 6:
            rxb_decoder_reinit(r); rxb_retune_start(r); break;
        }
    }
    rxb_state_tbl[r_state(r)](r);                            /* jsr @er6 */
    r_event(r) = 0;
    if (band_b_comm_mode != 0) rxb_dt_indicator(r);          /* bsr 0x030E00 */
    af_dual_monitor_b(r);                                    /* sub_32E8E */
    rxb_serial_if_refresh(r);                                /* sub_380EA */
    if (r_retune(r) != 0) rxb_synth_retune(r);               /* sub_382BE */
    rxb_sq_mirror_BB97 = r_sq(r);
}

/* --------------------------------------------------------------------------
 * 030E00-030E62  size 98   rxb_dt_indicator            (IDA sub_30E00)
 * 030E62-030F00  size 158  (IDA sub_30E62: continuation of the same
 *                           routine; entry 0x030EA2 used by sub_32058)
 * Callers: 30CE6, 32058 (0x030EA2), 32058's twin path.  Confirmed flow,
 * DT meaning Inferred from doc 77 (FF8EC5/FF8EC3 = band-B DT pair).
 * Decides the digital-type byte shown for band B (FF8EC5):
 *  - DG-ID mismatch: outside modes 3/0xB/0xA-with-8EA9.b7, if FF8ED8 !=
 *    B0D8 set BBF9.b7.
 *  - comm mode 1: the DSP-reported type BC5F while a band-B frame
 *    sequence runs, otherwise the selected type FF8EC3.
 *  - other digital modes: BC5F while a sequence runs or BC5F == 1 (then
 *    also remember the previous value in FF8EC6) or B113 == 2; else 4/5
 *    (5 when rec+0x19 != 0) while band B audio is open (A9E3.b1), else
 *    keep FF8EC5.
 *  - On change, request a redraw unless suppressed (screen A9F9 rules,
 *    AD69.b7).  With dual watch on band A (8EA0.b4, !b6) and band A
 *    digital with its +0x8A set, copy the result to band A's FF8EB6.
 * -------------------------------------------------------------------------- */
void rxb_dt_indicator(u8 *r)
{
    u8 dt, old, m = r_mode(r);
    if (!(m == 3 || m == 0xB || (m != 0xA && (ui_8EA9 & 0x80)))) {
        if (dgid_8ED8 != dsp_dgid_B0D8) rxb_dgflags_BBF9 |= 0x80;
    }
    if (band_b_comm_mode == 1) {                             /* 030E7C */
        dt = dsp_rx_dt_BC5F;
        if (dsp_rx_seq_B111 != 0) { if (dsp_rx_owner_BC5D == 0) dt = rxb_dt_sel_8EC3; }
        else if (dt != 1)          dt = rxb_dt_sel_8EC3;
    } else {
        dt = dsp_rx_dt_BC5F;                                 /* 030E32 */
        if (dsp_rx_seq_B111 != 0) {
            if (dsp_rx_owner_BC5D != 0) goto store;
        } else {
            if (dt == 1) {                                   /* 030E6A */
                if (rxb_dt_8EC5 != 1) rxb_dt_prev_8EC6 = rxb_dt_8EC5;
                goto store;
            }
            if (dsp_rx_B113 == 2) goto store;
        }
        dt = rxb_dt_8EC5;                                    /* 030E50 */
        if (audio_req & 0x02) dt = (r_19(r) != 0) ? 5 : 4;   /* 0x030E62 tail */
    }
store:                                                       /* 030E96 */
    old = rxb_dt_8EC5;
    rxb_dt_8EC5 = dt;
    if (old != dt) {
        u8 s = screen_A9F9;
        int redraw = (s == 0 || s == 1 ||
                      (s == 0xA && (scr_B420 & 0x01)) ||
                      (s == 9 && (scr_B39F & 0x04)));
        if (redraw && !(scr_AD69 & 0x80)) disp_flags_817E |= 0x02;
    }
    if ((band_cfg_8EA0 & 0x10) && !(band_cfg_8EA0 & 0x40) && band_a_comm_mode != 0 &&
        REC8(rec_a_ptr, 0x8A) != 0)                          /* [FF8122]+0x8A */
        rxa_dt_8EB6 = rxb_dt_8EC5;
}
/* Entry 0x030EA2 (from sub_32058) starts at the "old != dt" redraw test
 * with r4l = old value; documented as part of the routine above. */

/* --------------------------------------------------------------------------
 * 030F00-030FA4  size 164  rxb_shutdown                (IDA sub_30F00)
 * Callers: sub_34706 (TX-request reset), sub_74B08.  Confirmed (power-down
 * meaning Inferred from the latch/port pattern, shared with the RX saver).
 * Only if band B's last-written latch word FF8178 has any of 0xFE2F set:
 * make band B the active record ([FF812A] = [FF8126]), clear AA35.b4 /
 * AA38.b1, stop its tone decoder and TPU2, clear +0x91/+0x83, cancel a
 * pending DSP RX sequence (unless the last frame was 0xA6), rec+0x8D =
 * 0xFF, latch word FF8176 = FF8178 & 0x00C0 (all band-B RF bits off),
 * 0xFFFF5B.b2 = 1, 0xFFFF5D.b0 = 0, DACs A9AB/A9AC = 0, 0xFFFF52.b5 = 1,
 * mute band B, +0x90 = 2, state 0, shift the latch out, BB97 = 2.
 * er0 is preserved (push/pop) - note the routine also leaves [FF812A]
 * pointing at band B.
 * -------------------------------------------------------------------------- */
void rxb_shutdown(void)
{
    u8 *r;
    if ((latch_b_written & 0xFE2F) == 0) return;             /* FF8178 word */
    r = rec_b_ptr;                                           /* [FF8126] */
    rec_active_ptr = r;                                      /* [FF812A] */
    rx_flags_AA35 &= ~0x10;
    ui_flags_AA38 &= ~0x02;
    rxb_decoder_stop();                                      /* sub_31072 */
    rxb_tpu_stop();                                          /* sub_3104A */
    r_flags91(r) = 0; r_83(r) = 0;
    if (dsp_last_frame_BC02 != 0xA6) { dsp_req_B0C6 = 2; dsp_rx_seq_B111 = 0; dsp_rx_B113 = 0; }
    r_offs_class(r) = 0xFF;                                  /* +0x8D */
    latch_b = latch_b_written & 0x00C0;                      /* FF8176 word */
    PORT_5B |= 0x04;
    PORT_5D &= ~0x01;
    dac_A9AB = 0; dac_A9AC = 0;
    PORT_52 |= 0x20;
    rxb_audio_mute_and_led(r);                               /* sub_32378 */
    r_sq(r) = 2;
    r_state(r) = 0;
    latch_b_shift_out();                                     /* sub_37A3A */
    rxb_sq_mirror_BB97 = 2;
}

/* --------------------------------------------------------------------------
 * 030FA4-03104A  size 166  rxb_decoder_reinit          (IDA sub_30FA4)
 * Callers: 30CE6, 31B02, 31B62, 31C20, 31C52.  Confirmed.
 * Band-B twin of sub_2F4AA.  Stops decoder + TPU2, clears +0x91/+0x83,
 * cancels a DSP RX sequence, then by RX squelch class (sub_3EF2E):
 *  - 7 (PAGER): unless the pager hold FF95AD runs, load the CTCSS decoder
 *    (sub_1A40) with pager tone 1 (FF8968) or, in state 0xA, tone 2
 *    (FF8969);
 *  - 3 (DCS): FF95AD = 0; re-run DCS setup sub_E22 if the code (+0x18)
 *    differs from the cached FF90E6;
 *  - 2 (TONE SQL): FF95AD = 0; sub_1A40(+0x17);
 *  - others: FF95AD = 0 and return.
 * For 2/3/7 it then zeroes the 24-byte decoder work area FF90CE..FF90E5
 * and FF908E (band-B tone flags).
 * -------------------------------------------------------------------------- */
void rxb_decoder_reinit(u8 *r)
{
    u8 cls; u32 *p;
    rxb_decoder_stop();
    rxb_tpu_stop();
    r_flags91(r) = 0; r_83(r) = 0;
    if (dsp_last_frame_BC02 != 0xA6) { dsp_req_B0C6 = 2; dsp_rx_seq_B111 = 0; dsp_rx_B113 = 0; }
    cls = rx_sql_class(r);                                   /* sub_3EF2E */
    if (cls == 7) {
        if (t100_rxb_pager_hold != 0) return;
        ctcss_decoder_load(r_state(r) == 0xA ? pager_tone2 : pager_tone1);
    } else {
        t100_rxb_pager_hold = 0;
        if (cls == 3) {
            if (r_dcs(r) != rxb_dcs_cache_90E6) dcs_decoder_setup_b();   /* sub_E22 */
        } else if (cls == 2) {
            ctcss_decoder_load(r_ctcss(r));                  /* sub_1A40 */
        } else return;
    }
    for (p = (u32 *)0xFF90E6; p > (u32 *)0xFF90CE; ) *--p = 0;
    rxb_tone_flags = 0;                                      /* FF908E */
}

/* 03104A-031054  size 10   rxb_tpu_stop                (IDA sub_3104A)
 * Callers: 30F00, 30FA4, 31B62, 3EA28.  Confirmed.
 * TPU channel 2 stop (TSTR 0xFFFFBC.b2 = 0) and its TGIA interrupt off
 * (0xFFFFE4.b0 = 0). */
void rxb_tpu_stop(void) { TPU_TSTR &= ~0x04; TPU2_TIER &= ~0x01; }

/* 031054-031072  size 30   rxb_tpu_start               (IDA sub_31054)
 * Caller: 3163C.  Confirmed.  Twin of sub_2F55A for TPU2:
 * TCR2 = 0x20, TCNT2 = 0, TGRA2 = FF909E (band-B period word), start,
 * interrupt on. */
void rxb_tpu_start(void)
{
    TPU2_TCR = 0x20; TPU2_TCNT = 0; TPU2_TGRA = rxb_period_909E;
    TPU_TSTR |= 0x04; TPU2_TIER |= 0x01;
}

/* 031072-03109A  size 40   rxb_decoder_stop            (IDA sub_31072)
 * Callers: 30F00, 30FA4, 31D82, 3EA28.  Confirmed.  Twin of sub_2F578.
 * Capture interrupt off (word FF34.b5, FB90.b5), TPU2 stop, decode result
 * / run-state / alert latch FF9090/908F/9091 = 0. */
void rxb_decoder_stop(void)
{
    TPU_TIER_FF34 &= ~0x0020;
    PIN_FB90 &= ~0x20;
    TPU_TSTR &= ~0x04;
    rxb_tone_result = 0; rxb_tone_runstate = 0; rxb_alert_latch = 0;
}

/* --------------------------------------------------------------------------
 * 03109A-0310E8  size 78   rxb_capture_start_div1      (IDA sub_3109A)
 * Second entry 0x0310A2 = rxb_capture_start_div0 (TCR2 = 0).
 * Callers: 31594 (both entries).  Confirmed (register roles from doc 136).
 * Arm the band-B tone-period capture: TCR2 = 1 (entry 3109A) or 0,
 * FF9587 = 0, TCNT2 = 0, start TPU2, FD6A |= 0x0400, FB90.b5 = 1,
 * FF34.b5 = 1, three NOPs, FF36.b5 = 0 (clear pending flag).
 * -------------------------------------------------------------------------- */
void rxb_capture_start(u8 tcr)                               /* 1 or 0 */
{
    TPU2_TCR = tcr;
    t10_rxb_hold = 0;                                        /* FF9587 */
    TPU2_TCNT = 0;
    TPU_TSTR |= 0x04;
    IRQ_FD6A |= 0x0400;
    PIN_FB90 |= 0x20;
    TPU_TIER_FF34 |= 0x0020;
    __nop(); __nop(); __nop();
    TPU_TSR_FF36 &= ~0x0020;
}

/* --------------------------------------------------------------------------
 * 0310E8-031152  size 106  rxb_retune_start            (IDA sub_310E8)
 * Caller: 30CE6 (event 6).  Confirmed.  Twin of sub_2F5EE.
 * Per-retune reset: TX-aux reset sub_3266E, sub_48B86, clear hold
 * +0x92.b2, AF-dual resume timer sub_32FDA, band-B lamp off, post event 1,
 * state 0, band-B settle FF9580 = 2 (10-20 ms) and, in dual receive,
 * band-A settle FF956D = 2 (doc 93 lists 0x03111E), clear answer-back
 * arm/delay; PAGER class: pager hold FF95AD = 10 s, else clear +0x92.b1
 * and FF95AD.  Falls into rxb_dt_restore.
 * -------------------------------------------------------------------------- */
void rxb_retune_start(u8 *r)
{
    tx_aux_reset();                                          /* sub_3266E */
    aprs_rx_retune_48B86();                                  /* jsr 0x048B86 */
    r_flags92(r) &= ~0x04;
    af_dual_resume_time();                                   /* sub_32FDA */
    rxb_audio_mute_led(r);                                   /* sub_323B8 */
    r_event(r) = 1;
    r_state(r) = 0;
    t10_rxb_settle = 2;                                      /* FF9580 */
    if (band_cfg_8EA0 & 0x80) t10_rxa_settle_tx = 2;         /* FF956D */
    r_flags86(r) &= ~0x80;
    t10_rxb_ansback_delay = 0;                               /* FF9589 */
    if (rx_sql_class(r) == 7) t100_rxb_pager_hold = 0x64;
    else { r_flags92(r) &= ~0x02; t100_rxb_pager_hold = 0; }
    rxb_dt_restore();
}

/* --------------------------------------------------------------------------
 * 031152-03118C  size 58   rxb_dt_restore              (IDA sub_31152)
 * Callers: 310E8 (fall-in), 32058, sub_ED16.  Confirmed.
 * In a digital comm mode, if the shown type is the transient 1 restore it
 * (mode 1: from FF8EC3, other modes: from FF8EC6), clear B11C.b1 and set
 * the DSP band-B type BC5F = 2.
 * -------------------------------------------------------------------------- */
void rxb_dt_restore(void)
{
    if (band_b_comm_mode == 0) return;
    if (rxb_dt_8EC5 != 1) return;
    rxb_dt_8EC5 = (band_b_comm_mode == 1) ? rxb_dt_sel_8EC3 : rxb_dt_prev_8EC6;
    dsp_rx_flags_B11C &= ~0x02;
    dsp_rx_dt_BC5F = 2;
}

/* --------------------------------------------------------------------------
 * 03118C-0311E8  size 92   rxb_state0_retune           (IDA sub_3118C)
 * Band-B RX state 0 (table 0x030DC8[0]).  Confirmed.  Twin of 2F69E.
 * On an event: wake the receivers from RX-save (sub_3411E) unless the
 * event is 7; with VOX/short-TX FF89BB on, build the TX candidate
 * (sub_34DC2); compute the operating frequency +0x42 (sub_32590),
 * sub-band index -> FFA9BB (sub_326BA), offset class / retune request
 * (sub_3270A), band-B latch (sub_311E8), squelch calibration pointer
 * [FF8166] = sub_3EEC4(); timers FF956A = 100 ms, FF957D = 200 ms;
 * clear +0x8F b2/b3; state 1.
 * -------------------------------------------------------------------------- */
void rxb_state0_retune(u8 *r)
{
    u8 ev = r_event(r);
    if (ev == 0) return;
    if (ev != 7) rx_save_wake();                             /* sub_3411E */
    if (vox_89BB != 0) tx_build_and_check_range(r);          /* sub_34DC2 */
    rx_build_op_freq(r);                                     /* 0x032590 */
    subband_A9BB = rx_subband_index(r);                      /* sub_326BA r3l */
    rx_offset_class_update(r);                               /* sub_3270A */
    rxb_latch_setup(r, subband_A9BB);                        /* bsr sub_311E8 */
    sq_cal_b = sq_cal_ptr_lookup();                          /* sub_3EEC4 */
    t10_956A = 0x0A;
    t10_rxb_rf_fault = 0x14;                                 /* FF957D */
    r_flags8F(r) &= ~0x0C;
    r_state(r) = 1;
}

/* --------------------------------------------------------------------------
 * 0311E8-0312E2  size 250  rxb_latch_setup             (IDA sub_311E8)
 * Caller: 3118C.  Confirmed transliteration; latch-bit roles Unknown
 * (doc 105 open item 3).  In: r3l = sub-band index, er2 = rec+0x8E (left
 * by sub_3270A).
 *  - DG/sync byte BBF9: low bit = index^1, b1 kept; b7 set (and b3
 *    cleared) when the parity changed outside modes 0xA/3/8EA9.b7 cases.
 *  - FF8176 = byte_312FC[idx] (market groups 2-4 via sub_3ECDE, else the
 *    same table except idx 2 above the ROM limit [0x02220E] -> byte at
 *    0x031300);  FF8177 = (FF8179 & 0xDD) | byte_31310[idx].
 *  - FF8177.b5 = frequency inside window 0x032790 (sub_3F5EE);
 *    FF8177.b3 = (rec+0x19 != 0).
 *  - DAC tune value (sub_313E2), filter/preamp bits (sub_31324), the
 *    +0x39.b5 latch bit (sub_3138E), then falls into rxb_latch_digital_bit.
 * -------------------------------------------------------------------------- */
void rxb_latch_setup(u8 *r, u8 idx)
{
    u8 v = idx ^ 0x01, sub = r_subband(r);                   /* er2 = +0x8E */
    int changed;
    if (rxb_dgflags_BBF9 & 0x04) { rxb_dgflags_BBF9 &= ~0x04; changed = 1; }
    else changed = ((v & 1) != ((rxb_dgflags_BBF9 >> 1) & 1)) ||
                   (rxb_dgflags_BBF9 & 0x08) ||
                   ((rxb_dgflags_BBF9 & 0x01) != v);
    if (changed) {                                           /* 03121C */
        u8 m = r_mode(r);
        BIT_COPY(v, 1, rxb_dgflags_BBF9 & 0x02);
        if ((m != 0xA && (ui_8EA9 & 0x80)) || m == 3) {
            rxb_dgflags_BBF9 = v;
        } else {
            rxb_dgflags_BBF9 = v | 0x80;
            rxb_dgflags_BBF9 &= ~0x08;
        }
    }
    {   u8 b = byte_312FC[sub];                              /* 031252 */
        if (!market_alt_table() && sub == 2 &&
            r_op_freq(r) >= rom_u32(0x02220E)) b = rom_u8(0x031300);
        latch_b_lo = b;                                      /* FF8176 */
    }
    latch_b_hi = (latch_b_written_hi & 0xDD) | byte_31310[sub];   /* FF8177 */
    if (bcd_in_window(r_op_freq(r), (const void *)0x032790)) latch_b_hi |= 0x20;
    if (r_19(r) != 0) latch_b_hi |= 0x08; else latch_b_hi &= ~0x08;
    rxb_tune_dac_calc(r);                                    /* sub_313E2 */
    rxb_filter_select(r);                                    /* bsr sub_31324 */
    rxb_latch_attn(r);                                       /* sub_3138E */
    rxb_latch_digital_bit();                                 /* falls into 312E2 */
}

/* 0312E2-0312FC  size 26   rxb_latch_digital_bit       (IDA sub_312E2)
 * Callers: 311E8 (fall-in), sub_5E636.  Confirmed.
 * FF8177.b1 = (band-B comm mode != 0); shift the band-B latch out. */
void rxb_latch_digital_bit(void)
{
    if (band_b_comm_mode != 0) latch_b_hi |= 0x02; else latch_b_hi &= ~0x02;
    latch_b_shift_out();                                     /* sub_37A3A */
}

/* --------------------------------------------------------------------------
 * 031324-03138E  size 106  rxb_filter_select           (IDA sub_31324)
 * Caller: 311E8.  Confirmed transliteration; output roles Unknown.
 * Unless rec+0x12.b4: look the operating frequency up in range table
 * 0x030C3E (sub-band < 0xB) or 0x030C62 (>= 0xB); found -> 0xFFFF52.b5 =
 * 1, else 0 (b4 set -> 0).  Second lookup 0x030C86 / 0x030CBA: found ->
 * BBE0.b7 = 0, not found (or b4) -> 1.
 * -------------------------------------------------------------------------- */
void rxb_filter_select(u8 *r)
{
    const void *t;
    if (!(r_flags12(r) & 0x10)) {
        t = (r_subband(r) >= 0xB) ? (const void *)0x030C62 : (const void *)0x030C3E;
        if (bcd_range_lookup(r_op_freq(r), t)) PORT_52 |= 0x20;
        else                                   PORT_52 &= ~0x20;
    } else PORT_52 &= ~0x20;
    if (!(r_flags12(r) & 0x10)) {
        t = (r_subband(r) >= 0xB) ? (const void *)0x030CBA : (const void *)0x030C86;
        if (bcd_range_lookup(r_op_freq(r), t)) { flags_BBE0 &= ~0x80; return; }
    }
    flags_BBE0 |= 0x80;
}

/* 03138E-0313B0  size 34   rxb_latch_attn              (IDA sub_3138E)
 * Callers: sub_15F34, 311E8.  Confirmed (doc 35: +0x39.b5 = F320 bit
 * propagated to latch FF8176.b1).  If +0x86.b0 is pending, take the
 * one-shot path sub_313C6 (also shifts out); else just copy the bit.
 * 0x0313A8 (bset 8176.b1) is unreachable after the bra. */
void rxb_latch_attn(u8 *r)
{
    if (r_flags86(r) & 0x01) { rxb_latch_attn_now(r); return; }
    BIT_COPY(latch_b_lo, 1, r_39(r) & 0x20);
}

/* 0313C6-0313E2  size 28   rxb_latch_attn_now          (IDA sub_313C6)
 * Caller: 3138E.  Confirmed.  Clear +0x86.b0, copy +0x39.b5 to
 * FF8176.b1 and shift the latch out immediately. */
void rxb_latch_attn_now(u8 *r)
{
    r_flags86(r) &= ~0x01;
    BIT_COPY(latch_b_lo, 1, r_39(r) & 0x20);
    latch_b_shift_out();
}

/* --------------------------------------------------------------------------
 * 0313E2-0314DC  size 250  rxb_tune_dac_calc           (IDA sub_313E2)
 * Caller: 311E8.  Confirmed arithmetic; physical role Inferred (a
 * frequency-tracking DAC for the band-B front end, value in FFA9AB).
 *  1. f = BCD->binary(rec+0x42) / (rec+4 == 0 ? 1000 : 10000) -> FFAA44.
 *  2. Segment record from range table 0x032442 (market groups 2-4) or
 *     0x0324E6 (sub_3F5B2): r3 = payload word.
 *  3. Alignment trim r2 (signed word): segment code < 0x12 -> [FF80A4];
 *     0x12 (or 0x24..0x35 from [FF80C4]) ...; codes 0x12..0x23 (and 0x12
 *     above ROM limit [0x022204]) -> [FF80B4], +0x19 when sub-band index
 *     A9BB == 4.  Code 0 -> DAC 0; code 0x48 -> DAC 0xFF.
 *  4. v = (f * slope - offset) / 0x493 rounded (remainder >= 0x24A),
 *     slope/offset at 0x0314DC + payload; negative -> 0.  FF8118 = v.
 *  5. DAC = clamp(v + trim, 0, 0xFF) -> FFA9AB.
 * -------------------------------------------------------------------------- */
void rxb_tune_dac_calc(u8 *r)
{
    u32 f = bcd_to_bin(&REC32(r, 0x42));                     /* sub_3F986 -> er6 */
    u16 seg; s16 trim = 0; u8 code; u32 x;
    aa44_freq = (u16)(f / (r_band(r) == 0 ? 1000 : 10000));
    code = bcd_range_lookup_w(r_op_freq(r),
                              market_alt_table() ? (const void *)0x032442
                                                 : (const void *)0x0324E6, &seg);
    if (code == 0)    { dac_A9AB = 0;    return; }
    if (code == 0x48) { dac_A9AB = 0xFF; return; }
    if (code < 0x12) trim = (s16)align_80A4;
    else if (code == 0x12 && !market_alt_table() && r_op_freq(r) < rom_u32(0x022204))
        trim = 0;
    else if (code > 0x12 && code >= 0x36) trim = 0;
    else if (code > 0x12 && code >= 0x24) trim = (s16)align_80C4;
    else {                                                   /* 03146E */
        trim = (s16)align_80B4;
        if (subband_A9BB == 4) trim += 0x19;
    }
    {   const u8 *row = (const u8 *)0x0314DC + seg;          /* er3 */
        x = (u32)aa44_freq * rom_u16(row);
        if ((s32)(x - rom_u32(row + 2)) < 0) { dac_A9AB = 0; return; }
        x -= rom_u32(row + 2);
        { u16 q = x / 0x493, rem = x % 0x493; if (rem >= 0x24A) q++; x = q; }
    }
    rxb_dac_raw_8118 = (u16)x;
    if (trim < 0) { if ((u16)(-trim) >= (u16)x) { dac_A9AB = 0; return; } x -= (u16)(-trim); }
    else { x += trim; if (x >= 0x100) x = 0xFF; }
    dac_A9AB = (u8)x;
}

/* --------------------------------------------------------------------------
 * 031524-031594  size 112  rxb_state1_settle           (IDA sub_31524)
 * Band-B RX state 1.  Confirmed (doc 93 sec.2).  Twin of 2FA7C.
 * Wait for the band-B settle FF9580 (mute meanwhile).  Then sample the
 * RF-status line 0xFFFF4D.b2: low -> clear fault +0x8F.b3, tail FF957E =
 * 0, activity FF9591 = 3 s (300 ms in mode 5 with FF95A9 idle), 817E.b2,
 * select the squelch state.  High for longer than FF957D (200 ms here) ->
 * fault +0x8F.b3, redraw, park in state 2.
 * -------------------------------------------------------------------------- */
void rxb_state1_settle(u8 *r)
{
    if (t10_rxb_settle != 0) { r_sq(r) = 2; return; }
    r_flags8F(r) |= 0x04;
    if (!(PORT_4D & 0x04)) {
        r_flags8F(r) &= ~0x08;
        t10_rxb_sq_tail = 0;                                 /* FF957E */
        t100_rx_activity = 0x1E;
        if (r_mode(r) == 5 && t100_95A9 == 0) t100_rx_activity = 3;
        disp_flags_817E |= 0x04;
        rxb_select_state(r);
        return;
    }
    if (t10_rxb_rf_fault != 0) return;
    r_flags8F(r) |= 0x08;
    disp_flags_817E |= 0x02;
    r_state(r) = 2;
}

/* --------------------------------------------------------------------------
 * 031594-03163C  size 168  rxb_select_state            (IDA sub_31594)
 * Callers: 30CE6 (event 3), 31524.  Confirmed (doc 136 sec.2).
 * Picks band-B RX state from the squelch class (sub_3EEEE):
 *   6 (PR FREQ) -> load window from +0x34 (sub_1FAA), FF811E = 0x1FEA,
 *                  state 8, latch b2, capture at TCR 1;
 *   WX channel (sub_3ECB8) and WX alert armed -> FF811E = 0x1EEC, state 6;
 *   5 (JR FREQ) -> FF811E = 0x1F54, state 7;  (both: latch b2, TCR 0)
 *   otherwise state = byte_3B5C[class] (PAGER with the hold running -> 0xB)
 *   and the CTCSS/DCS decoder setup (sub_3163C).
 * -------------------------------------------------------------------------- */
void rxb_select_state(u8 *r)
{
    u8 cls;
    r_flags86(r) &= ~0x04;
    cls = rx_sql_type(r);                                    /* sub_3EEEE */
    if (cls == 6) {
        pr_freq_window_load_b(r_prfreq(r));                  /* sub_1FAA(+0x34) */
        rxb_decoder_fn = (void *)0x001FEA;                   /* FF811E */
        r_state(r) = 8;
        latch_b_hi |= 0x04; latch_b_shift_out();
        rxb_capture_start(1);                                /* sub_3109A */
        return;
    }
    if (rx_is_wx_channel(r)) {                               /* sub_3ECB8 */
        if (rx_wx_alert_armed(r)) {
            rxb_decoder_fn = (void *)0x001EEC; r_state(r) = 6; goto cap;
        }
    } else if (cls == 5) {
        rxb_decoder_fn = (void *)0x001F54; r_state(r) = 7; goto cap;
    }
    cls = rx_sql_type(r);                                    /* 031618 */
    r_state(r) = (cls == 7 && t100_rxb_pager_hold != 0) ? 0x0B : byte_3B5C[cls];
    rxb_tone_decoder_setup(r);
    return;
cap:
    latch_b_hi |= 0x04; latch_b_shift_out();
    rxb_capture_start(0);                                    /* sub_310A2 */
}

/* --------------------------------------------------------------------------
 * 03163C-03168A  size 78   rxb_tone_decoder_setup      (IDA sub_3163C)
 * Callers: 30CE6, 31594, 31B02, 31B62, 31C20, 31C52.  Confirmed.
 * Twin of sub_2FB94.  FF8177.b2 = 0.  By RX class: DCS (3) -> FF8177.b0
 * = 1; TONE SQL (2) / PAGER (7, pager hold idle; tone 1 or, in state
 * 0xA, tone 2) -> FF8177.b0 = (tone index < 0x18).  Then decoder options
 * (sub_3168A), shift the latch out and start TPU2.  Other classes:
 * nothing.
 * -------------------------------------------------------------------------- */
void rxb_tone_decoder_setup(u8 *r)
{
    u8 cls, tone;
    latch_b_hi &= ~0x04;
    cls = rx_sql_class(r);
    if (cls == 3) { latch_b_hi |= 0x01; goto go; }
    tone = r_ctcss(r);
    if (cls == 7) {
        if (t100_rxb_pager_hold != 0) return;
        tone = (r_state(r) == 0xA) ? pager_tone2 : pager_tone1;
    } else if (cls != 2) return;
    if (tone >= 0x18) latch_b_hi &= ~0x01; else latch_b_hi |= 0x01;
go:
    rxb_decoder_options(r);                                  /* bsr sub_3168A */
    latch_b_shift_out();
    rxb_tpu_start();                                         /* sub_31054 */
}

/* 03168A-0316B2  size 40   rxb_decoder_options         (IDA sub_3168A)
 * Callers: 3163C.  Confirmed.  Twin of sub_2FBE2.
 * FF908D = (FF908D & 0xF8) | byte_3B68[rec+0x35]; FF908D.b3 =
 * !(rec+0x8F.b4). */
void rxb_decoder_options(u8 *r)
{
    rxb_dec_opts_908D = (rxb_dec_opts_908D & 0xF8) | byte_3B68[r_35(r)];
    BIT_COPY(rxb_dec_opts_908D, 3, !(r_flags8F(r) & 0x10));
}

/* 0316B2-0316B4  size 2    rxb_state2_parked           (IDA sub_316B2)
 * Band-B RX state 2 (RF-status fault park, doc 93).  rts. */
void rxb_state2_parked(u8 *r) { (void)r; }

/* --------------------------------------------------------------------------
 * 0316B4-0316B8  size 4    rxb_state3_normal           (IDA sub_316B4)
 * 0316B8-031734  size 124  (IDA sub_316B8: body of the same handler)
 * Band-B RX states 3 and 0xD (normal carrier squelch).  Confirmed.
 * Digital comm mode: rxb_digital_rx; nonzero -> done.  Analog: BC5C = 0.
 * Both then run the APRS receive hook when the APRS MODEM (FF8AA0) is on
 * (sub_48C44, and the ringer repeat sub_31734 while AA32.b5), evaluate
 * squelch, and open/mute: monitor opens; S-meter closed mutes; with APRS
 * on and FF8AAB.b3 set (and band B not a non-operating dual-watch band)
 * the audio stays muted (APRS-only listening, label Inferred).
 * -------------------------------------------------------------------------- */
void rxb_state3_normal(u8 *r)
{
    if (band_b_comm_mode != 0) {
        if (rxb_digital_rx(r) != 0) return;                  /* sub_31836 */
    } else rxb_dig_open = 0;                                 /* FFBC5C */
    if (aprs_modem != 0) {                                   /* FF8AA0 */
        aprs_rx_tick();                                      /* sub_48C44 */
        if (aprs_flags_AA32 & 0x20) aprs_ringer_repeat();    /* bsr sub_31734 */
    }
    if (rxb_squelch_eval(r) != 0) return;
    if (g_r3l == 2) { rxb_audio_mute_and_led(r); return; }
    if (g_r3l == 1) return;
    rxb_busy_led_update(r);                                  /* 0x032386 */
    if (rx_flags_AA35 & 0x40) { rxb_audio_open(r); return; }
    if (rxb_smeter_sql(r) != 0) { rxb_audio_mute(); return; }
    if (aprs_modem != 0 && (aprs_cfg_8AAB & 0x08) &&
        (!(band_cfg_8EA0 & 0x10) || (band_cfg_8EA0 & 0x40))) {
        rxb_audio_mute(); return;
    }
    rxb_audio_open(r);
}

/* --------------------------------------------------------------------------
 * 031734-0317B6  size 130  aprs_ringer_repeat          (IDA sub_31734)
 * Caller: 316B8.  Confirmed flow; APRS ringer meaning Inferred (flags
 * A90D, settings FF8BE2..E4, repeat count A982/A983, interval A980).
 * For each pending alert bit in A90D (b0 unless b6, b1, b2) whose setting
 * byte is 9, or while FF95DA runs: re-trigger the ringer sub_3E5DA when
 * FF9549 is idle.  b0 with setting >= 0xA (or b6 after sub_49CF0): when
 * the interval FF95D8 and FF9549 are idle, ring, count down A983 and on
 * zero clear AA32.b1 and reload count/interval.  Nothing pending ->
 * aprs_ringer_clear.
 * -------------------------------------------------------------------------- */
void aprs_ringer_repeat(void)
{
    u8 f = aprs_alert_A90D;
    if ((f & 0x01) && !(f & 0x40)) {
        if (aprs_ring_cfg_8BE2 == 9) goto ring_now;
        if (aprs_ring_cfg_8BE2 >= 0xA) goto ring_repeat;
    }
    if ((f & 0x02) && aprs_ring_cfg_8BE3 == 9) goto ring_now;
    if ((f & 0x04) && aprs_ring_cfg_8BE4 == 9) goto ring_now;
    if (t10w_95DA != 0) goto ring_now;
    if (!(f & 0x40)) { aprs_ringer_clear(); return; }
    aprs_ringer_49CF0();
ring_repeat:                                                 /* 031772 */
    if (t10w_95D8 != 0 || t10_9549 != 0) return;
    aprs_ring_3E5DA();
    if (--aprs_ring_count_A983 != 0) return;
    aprs_flags_AA32 &= ~0x02;
    aprs_ring_count_A983 = aprs_ring_reload_A982;
    t10w_95D8 = aprs_ring_interval_A980;
    return;
ring_now:                                                    /* 0317A6 */
    if (t10_9549 == 0) aprs_ring_3E5DA();
}

/* 0317B6-0317DC  size 38   aprs_ringer_clear           (IDA sub_317B6)
 * Caller: 31734.  Confirmed.  Lamps off (FBA5 &= 0xF0), clear the two
 * word timers 95DA/95D8, FF9549, alert flags A90D and AA32.b5. */
void aprs_ringer_clear(void)
{
    LED_PORT_FBA5 &= 0xF0;
    t10w_95DA = 0; t10w_95D8 = 0; t10_9549 = 0;
    aprs_alert_A90D = 0;
    aprs_flags_AA32 &= ~0x20;
}

/* --------------------------------------------------------------------------
 * 0317DC-031836  size 90   rxb_smeter_sql              (IDA sub_317DC)
 * Callers: band-B RX states.  Confirmed (doc 137 sec.4).  Twin of 2FC6E.
 * Comm mode 2 without a digital open: hold while FF958D runs or
 * 0xFFFF41.b3 is high (return r4l unchanged = non-zero).  Then if SQL
 * S-METER (+0x37) is set: refresh the S-meter once per opening
 * (sub_3E26C, +0x86.b2) and close (+0x90 = 1, return 1) when the level
 * +0x81 is below byte_3B6E[+0x37].  Else return 0.
 * -------------------------------------------------------------------------- */
u8 rxb_smeter_sql(u8 *r)
{
    if (band_b_comm_mode == 2 && rxb_dig_open != 1) {
        if (t10_rxb_smeter_hold != 0) return t10_rxb_smeter_hold; /* r4l != 0 */
        if (PORT_41 & 0x08) return PORT_41;                      /* non-zero */
    }
    if (r_sqsmeter(r) == 0) return 0;
    if (!(r_flags86(r) & 0x04)) { smeter_update_b(r); r_flags86(r) |= 0x04; }
    if (r_81(r) < byte_3B6E[r_sqsmeter(r)]) { r_sq(r) = 1; return 1; }
    return 0;
}

/* --------------------------------------------------------------------------
 * 031836-03197A  size 324  rxb_digital_rx              (IDA sub_31836)
 * Callers: 316B8, 3197A, 31A8E, 31B02, 31B62, 31C52, 31D32, 31D82, 31E60,
 * 31F0A.  Confirmed (DSP frame roles from doc 86).  Twin of sub_2FCC8.
 * Returns 1 ("digital path owns the audio": BC5C = 1, latch FF8177.b1 =
 * digital audio path) or 0 (BC5C = 0, analog tail continues).
 *  - squelch eval (sub_32202); r4l != 0 -> return 1 path.
 *  - closed (r3l == 2): if a call just ended (B115 b1+b5) play the
 *    STANDBY BEEP ']' (FF8DD4, F329) unless node mode says otherwise
 *    (sub_6CA56), close-hold, return 1.
 *  - open: busy LED; DSP sequence owned by band B (B111 && BC5D) ->
 *    B115.b5 = call in progress, open audio; MONITOR -> open, return 0;
 *    DSP says type 1 or B113 == 2 -> mute; end-of-call -> standby beep.
 *    Comm mode 2: 0xFFFF41.b3 high reloads FF958D (250 ms) and mutes;
 *    when it has been low for 250 ms -> return 0 (analog squelch decides).
 *  - the return-1 tail also sets FBA4.b4 when band B is open.
 * -------------------------------------------------------------------------- */
u8 rxb_digital_rx(u8 *r)
{
    if (rxb_squelch_eval_dig(r) != 0) goto own;              /* sub_32202 */
    if (g_r3l == 2) {                                        /* 0318E8 */
        rxb_call_end_beep();
        rxb_close_hold(r);                                   /* sub_31A5E */
        goto own;
    }
    rxb_busy_led_update(r);                                  /* sub_32386 */
    if (dsp_rx_seq_B111 != 0) {
        if (dsp_rx_owner_BC5D != 0) {                        /* 0318DC */
            dsp_call_B115 |= 0x20;
            rxb_audio_open(r);
            goto own;
        }
    } else {
        if (rx_flags_AA35 & 0x40) { rxb_audio_open(r); goto analog; }   /* 031956 */
        if (dsp_rx_dt_BC5F == 1 || dsp_rx_B113 == 2) goto mute;
        rxb_call_end_beep();
    }
    if (band_b_comm_mode == 2) {                             /* 0318AC */
        if (PORT_41 & 0x08) { t10_rxb_smeter_hold = 0x19; goto mute; }
        if (t10_rxb_smeter_hold == 0) goto analog;           /* 03195A */
    }
mute:                                                        /* 0318CA */
    dsp_call_B115 &= ~0x22;
    rxb_audio_mute();
own:                                                         /* 031926 */
    if ((audio_req & 0x02) && !(PIN_FBA4 & 0x10)) PIN_FBA4 |= 0x10;
    if (!(latch_b_written_hi & 0x02)) { latch_b_hi |= 0x02; latch_b_shift_out(); }
    rxb_dig_open = 1;
    return 1;
analog:                                                      /* 03195A */
    dsp_call_B115 &= ~0x02;
    if (latch_b_written_hi & 0x02) { latch_b_hi &= ~0x02; latch_b_shift_out(); }
    rxb_dig_open = 0;
    return 0;
}
static void rxb_call_end_beep(void)          /* inlined twice: 031872 / 0318E8 */
{
    if (!(dsp_call_B115 & 0x02)) return;
    dsp_call_B115 &= ~0x02;
    if (!(dsp_call_B115 & 0x20)) return;
    dsp_call_B115 &= ~0x20;
    if ((s8)node_mode < 0) { node_AA01 = 0; if (node_end_6CA56() != 0) return; }
    if (standby_beep != 0) tone_req = 0x5D;                  /* ']' */
}

/* ---------------- band-B RX states: twins of part 1 ----------------------- */
/* Common prologue: as rxa_common_prologue with FF8DD5 / sub_31836 /
 * FFBC5C / sub_31F9E / sub_32386.                                          */
static int rxb_common_prologue(u8 *r)
{
    if (band_b_comm_mode != 0)
        return rxb_digital_rx(r) ? PRO_DIGITAL_HANDLED : PRO_DIGITAL_FALL;
    rxb_dig_open = 0;
    if (rxb_squelch_eval(r) != 0) return PRO_ABORT;
    if (g_r3l == 2) return PRO_CLOSED;
    if (g_r3l == 1) return PRO_SMETER;
    rxb_busy_led_update(r);
    return PRO_OPEN;
}
/* (no node-mode forced-mute step in the band-B prologue) */

/* 03197A-0319C8  size 78   rxb_state4_code_sql         (IDA sub_3197A)
 * Band-B RX state 4.  Confirmed.  Twin of 2FE44 (FF908E.b0). */
void rxb_state4_code_sql(u8 *r)
{
    switch (rxb_common_prologue(r)) {
    case PRO_DIGITAL_HANDLED: if (r_sq(r) == 2) rxb_close_hold_tail(r); return;
    case PRO_CLOSED: rxb_close_hold(r); return;
    case PRO_OPEN: case PRO_DIGITAL_FALL: break;
    default: return;
    }
    BIT_COPY(r_flags91(r), 2, rxb_tone_flags & 0x01);
    rxb_gate_audio(r);                                       /* r3l = 2 */
}

/* 0319C8-031A20  size 88   rxb_gate_audio              (IDA sub_319C8)
 * Twin of 2FEB2 (open-hold flag FF90EA, smeter 317DC, mute 3236A, open
 * 322D6, open-if-enabled 32354).  Confirmed. */
void rxb_gate_audio(u8 *r)
{
    r_flags92(r) &= ~0x04;
    if (!(rx_flags_AA35 & 0x40)) {
        if (r_flags91(r) & 0x04) {
            if (rxb_smeter_sql(r) != 0) { r_flags91(r) &= ~0x04; rxb_audio_mute(); return; }
            rxb_ring_bell_once(r);
        } else {
            if (rxb_open_hold_90EA != 0 && !(cfg_89BF & 0x40) && rxb_smeter_sql(r) == 0) {
                rxb_audio_open_if_enabled(r); return;
            }
            rxb_audio_mute(); return;
        }
    }
    rxb_audio_open(r);
}

/* 031A20-031A5E  size 62   rxb_ring_bell_once          (IDA sub_31A20)
 * Twin of 2FF0A.  Confirmed. */
u8 rxb_ring_bell_once(u8 *r)
{
    if (r_flags92(r) & 0x01) return 0;
    r_flags92(r) |= 0x01;
    if (r_bell(r) == 0) return 0;
    bell_tone_start();
    r_flags92(r) |= 0x02; r_flags9B(r) |= 0x02; disp_flags_817E |= 0x02;
    return 1;
}

/* 031A5E-031A8E  size 48   rxb_close_hold              (IDA sub_31A5E)
 * Entry 0x031A62 = rxb_close_hold_tail.  Twin of 2FF48 with FF95B1
 * (100 ms tier, 5 s) and mute+LED sub_32378.  Confirmed. */
void rxb_close_hold(u8 *r) { rxb_audio_mute_and_led(r); rxb_close_hold_tail(r); }
void rxb_close_hold_tail(u8 *r)
{
    if (!(r_flags92(r) & 0x04)) { r_flags92(r) |= 0x04; t100_rxb_bell_rearm = 0x32; }
    else if (t100_rxb_bell_rearm == 0) r_flags92(r) &= ~0x01;
}

/* 031A8E-031B02  size 116  rxb_stateC_rev_code         (IDA sub_31A8E)
 * Twin of 2FF78 (holdoff FF958B).  Confirmed. */
void rxb_stateC_rev_code(u8 *r)
{
    switch (rxb_common_prologue(r)) {
    case PRO_DIGITAL_HANDLED: if (r_sq(r) == 2) rxb_close_hold_tail(r); return;
    case PRO_CLOSED: t10_rxb_rev_holdoff = 0x1E; rxb_close_hold(r); return;
    case PRO_OPEN: case PRO_DIGITAL_FALL: break;
    default: return;
    }
    r_flags91(r) &= ~0x04;
    if ((rxb_tone_flags & 0x01) || t10_rxb_rev_holdoff == 0) {
        t10_rxb_rev_holdoff = 0;
        BIT_COPY(r_flags91(r), 2, !(rxb_tone_flags & 0x01));
    }
    rxb_gate_audio(r);
}

/* 031B02-031B62  size 96   rxb_state9_pager_wait1      (IDA sub_31B02)
 * Twin of 3000C (window FF9588).  Confirmed. */
void rxb_state9_pager_wait1(u8 *r)
{
    int p = rxb_common_prologue(r);
    if (p == PRO_CLOSED) { rxb_audio_mute_and_led(r); return; }
    if (p != PRO_OPEN && p != PRO_DIGITAL_FALL) return;
    if (rx_flags_AA35 & 0x40) { rxb_audio_open(r); return; }
    if ((rxb_tone_flags & 0x01) && rxb_smeter_sql(r) == 0) {
        t10_rxb_pager_win = 0x6E;
        r_state(r) = 0x0A;
        rxb_decoder_reinit(r);
        rxb_tone_decoder_setup(r);
    }
    rxb_audio_mute();
}

/* 031B62-031C20  size 190  rxb_stateA_pager_wait2      (IDA sub_31B62)
 * Twin of 3008C (stops TPU2 via sub_3104A, hold FF95AD, ans-back FF9589).
 * Confirmed. */
void rxb_stateA_pager_wait2(u8 *r)
{
    int p = rxb_common_prologue(r);
    if (p == PRO_DIGITAL_HANDLED) { rxb_pager_reset(r); return; }
    if (p == PRO_OPEN || p == PRO_DIGITAL_FALL) {
        if (rx_flags_AA35 & 0x40) rxb_audio_open(r);
        else if ((rxb_tone_flags & 0x01) && rxb_smeter_sql(r) == 0) {
            disp_flags_817E |= 0x02;
            r_flags91(r) |= 0x04;
            rxb_ring_bell_once(r);
            rxb_audio_open(r);
            rxb_tpu_stop();
            t100_rxb_pager_hold = 0x64;
            r_state(r) = 0x0B;
            r_flags86(r) &= ~0x80;
            t10_rxb_ansback_delay = 0;
            if (cfg_89C3 & 0x04) { r_flags86(r) |= 0x80; t10_rxb_ansback_delay = 0xC8; }
            return;
        } else rxb_audio_mute();
    } else if (p == PRO_CLOSED) rxb_audio_mute_and_led(r);
    if (t10_rxb_pager_win == 0) {
        r_state(r) = 9; rxb_decoder_reinit(r); rxb_tone_decoder_setup(r);
    }
}

/* 031C20-031C52  size 50   rxb_pager_reset             (IDA sub_31C20)
 * Twin of 3016C.  Confirmed. */
void rxb_pager_reset(u8 *r)
{
    r_flags86(r) &= ~0x80;
    t10_rxb_pager_win = 0; t10_rxb_ansback_delay = 0; t100_rxb_pager_hold = 0;
    r_flags92(r) &= ~0x01;
    r_state(r) = 9;
    rxb_decoder_reinit(r); rxb_tone_decoder_setup(r);
}

/* 031C52-031D32  size 224  rxb_stateB_pager_call       (IDA sub_31C52)
 * Twin of 3019E: the band-B pager answer-back also keys the radio
 * directly (AACF = 1, FF94C0 = 1 at 0x031CF0/0x031CF6).  Confirmed. */
void rxb_stateB_pager_call(u8 *r)
{
    int p = rxb_common_prologue(r);
    if (p == PRO_DIGITAL_HANDLED) {
        if (r_sq(r) == 0) { rxb_pager_reset(r); return; }
        goto ansback;
    }
    if (p == PRO_OPEN || p == PRO_DIGITAL_FALL) {
        t10_rxb_ansback_delay = 0xC8; t100_rxb_pager_hold = 0x64;
        if (!(rx_flags_AA35 & 0x40) && rxb_smeter_sql(r) != 0) rxb_audio_mute();
        else rxb_audio_open(r);
        return;
    }
    if (p == PRO_CLOSED) rxb_audio_mute_and_led(r);
ansback:
    if ((cfg_89C3 & 0x04) && (r_flags86(r) & 0x80) && t10_rxb_ansback_delay == 0) {
        r_flags86(r) &= ~0x80;
        if (tx_build_and_check_range(r) == 0) {
            tx_aux_AAD1 |= 0x01; ansback_elem_count = 5; tone_req = 0xFF;
            disp_flags_817E |= 0x02;
            tx_freq_AAAA = tx_cand_freq;
            tx_event = 1; tx_state_94C0 = 1;
        }
    }
    if (t100_rxb_pager_hold == 0) {
        disp_flags_817E |= 0x02; r_flags92(r) &= ~0x01; r_state(r) = 9;
        rxb_decoder_reinit(r); rxb_tone_decoder_setup(r);
    }
}

/* 031D32-031D82  size 80   rxb_state5_code_sql         (IDA sub_31D32)
 * Twin of 302A0.  Confirmed. */
void rxb_state5_code_sql(u8 *r)
{
    switch (rxb_common_prologue(r)) {
    case PRO_DIGITAL_HANDLED: if (r_sq(r) == 2) rxb_close_hold_tail(r); return;
    case PRO_CLOSED: rxb_close_hold(r); return;
    case PRO_OPEN: case PRO_DIGITAL_FALL: break;
    default: return;
    }
    BIT_COPY(r_flags91(r), 2, rxb_tone_flags & 0x01);
    rxb_gate_audio(r);                                       /* r3l = 3 */
}

/* 031D82-031E60  size 222  rxb_state6_wx_alert         (IDA sub_31D82)
 * Twin of 30310 (latch FF9091, result FF9090, 5-min word FF95F0, capture
 * enable FF34.b5).  Confirmed flow, WX label Inferred as in part 1. */
void rxb_state6_wx_alert(u8 *r)
{
    int p;
    if (rxb_alert_latch == 0 && !rx_wx_alert_armed(r)) {
        r_state(r) = 3; rxb_decoder_stop(); return;
    }
    p = rxb_common_prologue(r);
    if (p == PRO_DIGITAL_HANDLED) return;
    if (p == PRO_CLOSED) {
        rxb_audio_mute_led(r);
        rxb_tone_result = 0; rxb_tone_runstate = 0;
        r_flags91(r) &= ~0x04; rxb_audio_mute(); goto timer;
    }
    if (p != PRO_OPEN && p != PRO_DIGITAL_FALL) goto timer;
    if (rx_flags_AA35 & 0x40) { rxb_audio_open(r); goto timer; }
    if (rxb_alert_latch == 2) { ui_refresh_2EAC2(); rxb_audio_open(r); goto timer; }
    if (rxb_tone_result == 0) { r_flags91(r) &= ~0x04; rxb_audio_mute(); goto timer; }
    if (rxb_alert_latch != 0) { rxb_audio_mute(); goto timer; }
    if (rxb_smeter_sql(r) != 0) {
        rxb_tone_result = 0; rxb_tone_runstate = 0;
        r_flags91(r) &= ~0x04; rxb_audio_mute(); goto timer;
    }
    TPU_TIER_FF34 &= ~0x0020;
    rxb_alert_latch = 1;
    t1s_rxb_alert = 0x12C;
    tone_repeat = 0xFF; tone_req = 0x35;
    r_flags91(r) |= 0x04;
    rxb_audio_mute();
timer:
    if (rxb_alert_latch == 1 && t1s_rxb_alert == 0) {
        tone_req = 0xFF; ui_refresh_2EAC2(); rxb_alert_latch = 2;
    }
}

/* 031E60-031F0A  size 170  rxb_state7_jr_freq          (IDA sub_31E60)
 * Twin of 30410 (FF9586 re-check, FF9587 hold).  Confirmed. */
void rxb_state7_jr_freq(u8 *r)
{
    int p = rxb_common_prologue(r);
    if (p == PRO_CLOSED) {
        r_flags91(r) &= ~0x80; rxb_tone_result = 0; rxb_tone_runstate = 0;
        rxb_audio_mute_led(r); t10_rxb_recheck = 0x32; goto mute;
    }
    if (p != PRO_OPEN && p != PRO_DIGITAL_FALL) return;
    if (rx_flags_AA35 & 0x40) goto open;
    if (rxb_tone_result >= 2) {
        r_flags91(r) |= 0x80;
        if (t10_rxb_hold == 0) { rxb_tone_result = 1; t10_rxb_recheck = 0x32; goto mute; }
        goto open_b2;
    }
    if (rxb_smeter_sql(r) != 0 || t10_rxb_recheck != 0) goto mute;
    t10_rxb_hold = 0x64;
open_b2: r_flags91(r) |= 0x04;
open:    rxb_audio_open(r); return;
mute:    r_flags91(r) &= ~0x04; rxb_audio_mute();
}

/* 031F0A-031F9E  size 148  rxb_state8_pr_freq          (IDA sub_31F0A)
 * Twin of 304DC.  Confirmed. */
void rxb_state8_pr_freq(u8 *r)
{
    int p = rxb_common_prologue(r);
    if (p == PRO_CLOSED) {
        if (t10_rxb_hold != 0) goto open_b2;
        r_flags91(r) &= ~0x80; rxb_tone_result = 0; rxb_tone_runstate = 0;
        rxb_audio_mute_led(r); goto mute;
    }
    if (p != PRO_OPEN && p != PRO_DIGITAL_FALL) return;
    if (rx_flags_AA35 & 0x40) goto open;
    if (rxb_tone_result == 1) {
        if (rxb_smeter_sql(r) != 0) goto mute;
        t10_rxb_hold = 0x64; goto open_b2;
    }
    if (rxb_tone_result != 0) r_flags91(r) |= 0x80;
    if (t10_rxb_hold != 0) goto open_b2;
    goto mute;
open_b2: r_flags91(r) |= 0x04;
open:    rxb_audio_open(r); return;
mute:    r_flags91(r) &= ~0x04; rxb_audio_mute();
}

/* --------------------------------------------------------------------------
 * 031F9E-032058  size 186  rxb_squelch_eval            (IDA sub_31F9E)
 * Twin of 30590 (settle FF9583, RF status 0xFFFF4D.b2, core 0x0320B6).
 * The idle test order differs from band A: band A digital with dual
 * receive -> keep; APRS modem on (any band config) -> keep; FF90EA ->
 * keep; dual receive with FF8FE2 -> keep; else rx_activity = 1.
 * Confirmed.
 * -------------------------------------------------------------------------- */
u8 rxb_squelch_eval(u8 *r)
{
    u8 sq;
    if (dsp_flags_B057 & 0x80) { g_r3l = 2; return 0; }
    if (t10_rxb_settle2 != 0) { r_sq(r) = 2; g_r3l = 2; return 0; }   /* FF9583 */
    r_flags89(r) |= 0x08; r_flags8F(r) &= ~0x08;
    if (rx_monitor_active(r)) sq = 0;
    else {
        if (rx_save_flags_A9E7 & 0x02) { r_sq(r) = 2; g_r3l = 2; return 1; }
        if (PORT_4D & 0x04) {
            disp_flags_817E |= 0x02; r_flags8F(r) |= 0x08;
            r_sq(r) = 2; g_r3l = 2; return 0;
        }
        sq = rxb_noise_squelch(r);                           /* bsr 0x0320B6 */
    }
    r_sq(r) = sq; g_r3l = sq;
    if (sq != 2) { t100_rx_activity = 0x1E; rx_activity = 2; }
    else if (t100_rx_activity == 0) {
        if (band_a_comm_mode != 0 && (band_cfg_8EA0 & 0x80)) return 0;
        if (aprs_modem != 0) return 0;
        if (rxb_open_hold_90EA != 0) return 0;
        if ((band_cfg_8EA0 & 0x80) && rxa_open_hold_8FE2 != 0) return 0;
        rx_activity = 1;
    }
    return 0;
}

/* --------------------------------------------------------------------------
 * 032058-0320B6  size 94   rxb_noise_squelch_dsp       (IDA sub_32058)
 * 0320B6-03210C  size 86   rxb_noise_squelch           (IDA sub_320B6)
 * Twin of 30654/306B2.  Band-B ownership is BC5D != 0; the per-frame
 * completion uses B11C.b1, FF958C, BC5F, then sub_31152 + 0x030EA2.
 * In the core, with the APRS modem on the squelch tail is a fixed 100 ms
 * (FF957E = 0x0A) instead of byte_3B7A[+0x83].  Confirmed.
 * -------------------------------------------------------------------------- */
u8 rxb_noise_squelch_dsp(u8 *r)
{
    if (dsp_rx_seq_B111 != 0 && dsp_rx_owner_BC5D != 0) {    /* 032098 */
        if (t10_dsp_9558 != 0) return rxb_noise_tail_open(r);
        if (dsp_last_frame_BC02 != 0xA6) {
            dsp_req_B0C6 = 2; dsp_rx_seq_B111 = 0; dsp_rx_B113 = 0;
        }
    } else if (dsp_B263 == 0 && (dsp_rx_flags_B11C & 0x02) && t10_dsp_958C == 0) {
        dsp_rx_flags_B11C &= ~0x02;
        if (dsp_rx_dt_BC5F == 1) dsp_rx_dt_BC5F = 2;
        rxb_dt_restore();                                    /* sub_31152 */
        rxb_dt_indicator_tail();                             /* 0x030EA2 */
    }
    return rxb_noise_squelch(r);
}
u8 rxb_noise_squelch(u8 *r)                                  /* 0320B6 */
{
    if (rxb_noise_compare(r) == 2) return (t10_rxb_sq_tail != 0) ? 1 : 2;
    return rxb_noise_tail_open(r);
}
static u8 rxb_noise_tail_open(u8 *r)                         /* 0320BC */
{
    if (aprs_modem != 0) {
        t10_rxb_sq_tail = 0x0A;
        if (r_sq(r) != 0) t10_rxb_smeter_hold = 0x19;
    } else if (r_sq(r) != 0) {
        t10_rxb_sq_tail = byte_3B7A[r_83(r)];
        t10_rxb_smeter_hold = 0x19;
    }
    return 0;
}
/* note: the last-frame test is 0xA6 here and 0xB6 in band A (0x03069E),
 * the two frame-owner bytes of doc 86 (A6 -> BC5D = 0, B6 -> BC5D = 1). */

/* 03210C-032202  size 246  rxb_noise_compare           (IDA sub_3210C)
 * Twin of 306EA: calibration [FF8166], SQL LEVEL FF8971, AN4 (FFA994),
 * other-band flag FF8F6A (= band-A +0x8A), tone flag FF908E.b0, pager
 * hold FF95AD.  Confirmed (doc 137). */
u8 rxb_noise_compare(u8 *r)
{
    const u8 *cal; u8 hys, t1, t15, thr, lvl, an, cls;
    if (rx_hold_AA33 & 0x01) return 2;
    if ((r_mode(r) == 0xA || r_mode_alt(r) == 0xA ||
         r_mode(r) == 0xB || r_mode_alt(r) == 0xB) && r_8A(r) != 0) return 2;
    if (busy_ovr_8EBD & 0x80) {
        int check_other = 0;
        if (!(busy_ovr_8EBD & 0x40)) {
            if (ui_8EAD != 0 && !(busy_ovr_8EBD & 0x20)) check_other = 1;   /* 032158 bne */
        } else if (!(busy_ovr_8EBD & 0x20)) {                /* 032162 */
            if (ui_8EAD == 0) return 2;
            check_other = 1;
        }
        if (check_other && rxa_8A == 0) return 2;            /* FF8F6A */
    }
    cal = sq_cal_b;
    hys = cal[0]; t1 = cal[1] - (hys >> 1); t15 = cal[2] - (hys >> 1);
    lvl = sql_level_b;                                       /* FF8971 */
    if (lvl == 0) {
        cls = rx_sql_class(r);
        if (cls == 2 || (cls == 7 && t100_rxb_pager_hold == 0) || cls == 3) {
            if (rxb_tone_flags & 0x01) thr = t1; else return 0;
        } else return 0;
    } else if (lvl == 1) thr = t1;
    else if (lvl == 15)  thr = t15;
    else                 thr = t1 - ((u8)(t1 - t15) / 14) * (lvl - 1);
    an = adc_an4;                                            /* FFA994 */
    if (thr >= an) return 0;
    if (r_sq(r) == 2) return 2;
    if ((u8)(thr + hys) >= an) return 0;
    return 2;
}
/* NOTE: FF8EBD.b5 tests with the opposite branch sense in the two bands
 * (band A 0x030736 beq, band B 0x03215E bne), i.e. b5 selects which band
 * the busy override applies to (set: band A, clear: band B; Inferred). */

/* --------------------------------------------------------------------------
 * 032202-032240  size 62   rxb_squelch_eval_dig        (IDA sub_32202)
 * 032240-0322D6  size 150  (IDA sub_32240: continuation)
 * Caller: 31836.  Twin of 307E0/3080C (settle FF9583, RF status b2, DSP
 * core sub_32058; idle rules use FF8DD5 for band B).  Confirmed.
 * -------------------------------------------------------------------------- */
u8 rxb_squelch_eval_dig(u8 *r)
{
    u8 sq;
    if (t10_rxb_settle2 != 0) { r_sq(r) = 2; g_r3l = 2; return 0; }
    r_flags89(r) |= 0x08; r_flags8F(r) &= ~0x08;
    if (rx_monitor_active(r)) sq = 0;
    else {
        if (rx_save_flags_A9E7 & 0x02) { r_sq(r) = 2; g_r3l = 2; return 1; }
        if (PORT_4D & 0x04) {
            disp_flags_817E |= 0x02; r_flags8F(r) |= 0x08;
            r_sq(r) = 2; g_r3l = 2; return 0;
        }
        sq = rxb_noise_squelch_dsp(r);
    }
    r_sq(r) = sq; g_r3l = sq;
    /* ---- 0x032240 (IDA sub_32240) ---- */
    if (sq != 2) {
        t100_rx_activity = 0x1E; rx_activity = 2;
        if (dsp_audio_req_B0AC & 3) dsp_audio_req_B0AC = 0;
        return 0;
    }
    if (t100_rx_activity != 0) return 0;
    if (save_rx == 0 || dsp_busy_B3F9 != 0) goto req;
    if (band_b_comm_mode == 0 || band_b_comm_mode == 2) {
        if (aprs_modem != 0) goto req;
    }
    if (rxa_open_hold_8FE2 != 0) goto req;
    if ((band_cfg_8EA0 & 0x80) && rxb_open_hold_90EA != 0) goto req;
    rx_activity = 1; return 0;
req:
    if (!(dsp_audio_req_B0AC & 3)) dsp_audio_req_B0AC = 1;
    return 0;
}

/* --------------------------------------------------------------------------
 * 0322D6-032354  size 126  rxb_audio_open              (IDA sub_322D6)
 * Twin of 308BE.  MUTE: when band A is the operating band (8EA0.b6 clear)
 * and is open (A9E3.b0), band B is muted by the other band (A9E2.b1);
 * level 3 keeps it silent.  Open: AA36.b5 (band-B busy), A9E3 |= 0x82.
 * No A9E4 handling.  Confirmed.
 * -------------------------------------------------------------------------- */
void rxb_audio_open(u8 *r)
{
    if (r_mode(r) != 0xA && r_mode_alt(r) != 0xA && (ui_8EA9 & 0x80)) { rxb_audio_mute(); return; }
    if (!(r_flags8F(r) & 0x01)) return;
    if (!(band_cfg_8EA0 & 0x80) || mute_setting == 0) audio_mute_by_other = 0;
    else {
        audio_mute_by_other &= ~0x02;
        if (!(band_cfg_8EA0 & 0x40) && (audio_req & 0x01)) {
            audio_mute_by_other |= 0x02;
            if (mute_setting == 3) { audio_req |= 0x80; audio_req &= ~0x02; return; }
        }
    }
    rx_busy_AA36 |= 0x20;
    audio_req |= 0x80 | 0x02;
}

/* 032354-03236A  size 22   rxb_audio_open_if_enabled   (IDA sub_32354)
 * Twin of 309D6.  Confirmed. */
void rxb_audio_open_if_enabled(u8 *r)
{ if (r_flags8F(r) & 0x01) audio_req |= 0x82; }

/* 03236A-032378  size 14   rxb_audio_mute              (IDA sub_3236A)
 * Twin of 309F2: A9E3.b7 = 1, b1 = 0.  Confirmed. */
void rxb_audio_mute(void) { audio_req |= 0x80; audio_req &= ~0x02; }

/* --------------------------------------------------------------------------
 * 032378-032420  size 168  rxb_audio_mute_and_led      (IDA sub_32378)
 * Three entries in one IDA function (all Confirmed):
 *   0x032378 rxb_audio_mute_and_led : mute + bra 0x0323B8
 *   0x032386 rxb_busy_led_update    : FF89C8.b1 gate (twin of 30A24 minus
 *                                     the node test); lamp on -> AFF3
 *   0x0323B8 rxb_audio_mute_led     : AFF3 = 0 and shared-lamp recompute
 *                                     (twin of 30A66; when band B is the
 *                                     operating band in dual watch, show
 *                                     band A's AFF2)
 * All end in led_write_B (0x032430).
 * -------------------------------------------------------------------------- */
void rxb_audio_mute_and_led(u8 *r) { rxb_audio_mute(); rxb_audio_mute_led(r); }
void rxb_busy_led_update(u8 *r)                              /* 032386 */
{
    if (!(led_cfg_89C8 & 0x02)) { rxb_audio_mute_led(r); return; }
    if (r_mode(r) != 0xA && r_mode_alt(r) != 0xA && (ui_8EA9 & 0x80)) {
        led_b_state = 0; led_write_B(0); return;
    }
    led_b_state = 0x80;
    rxb_led_tail(r, 0x80);
}
void rxb_audio_mute_led(u8 *r)                               /* 0323B8 */
{
    if (r_mode(r) != 0xA && r_mode_alt(r) != 0xA && (ui_8EA9 & 0x80)) {
        led_b_state = 0; led_write_B(0); return;
    }
    led_b_state = 0;
    rxb_led_tail(r, 0);
}
static void rxb_led_tail(u8 *r, u8 v)                        /* 0323E0 */
{
    if (dsp_flags_B057 & 0x10) return;
    if (r_mode(r) == 0xB || r_mode_alt(r) == 0xB) {
        if (r_8A(r) == 0) { led_write_B(v); return; }
    } else if (!(band_cfg_8EA0 & 0x10)) { led_write_B(v); return; }
    v = 0;
    if ((band_cfg_8EA0 & 0x10) && (band_cfg_8EA0 & 0x40)) v = led_a_state;
    led_write_B(v);
}

/* 03242E-032430  size 2    rxb_tx_led_on               (IDA sub_3242E)
 * Caller: sub_34B30.  Confirmed.  r5l = 0x40, falls into led_write_B
 * (no node-mode test, unlike band A's 30ADC). */
void rxb_tx_led_on(void) { led_write_B(0x40); }

/* 032430-032442  size 18   led_write_B                 (IDA sub_32430)
 * Confirmed.  0xFFFBA5.b2 = v.b7 (band-B busy), 0xFFFBA5.b0 = v.b6 (TX). */
void led_write_B(u8 v)
{
    BIT_COPY(LED_PORT_FBA5, 2, v & 0x80);
    BIT_COPY(LED_PORT_FBA5, 0, v & 0x40);
}
