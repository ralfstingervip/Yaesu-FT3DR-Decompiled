/* ==========================================================================
 * PART 1  0x02FE44-0x030B00   Band-A receive (squelch) state handlers
 *
 * Band-A RX state machine: dispatcher sub_2F1DA (outside this lane) runs
 *   rec->state (= +0x93) through table 0x02F2A8:
 *     0 2F69E  1 2FA7C  2 2FC0A(rts, parked)  3 2FC0C  4 2FE44  5 302A0
 *     6 30310  7 30410  8 304DC  9 3000C  0xA 3008C  0xB 3019E  0xC 2FF78
 *     0xD 2FC0C
 *   The selector sub_2FAEC (doc 136) picks the state from the SQL TYPE
 *   (rec+0x16): JR FREQ -> 7, PR FREQ -> 8, WX-alert -> 6, others through
 *   table 0x003B5C (OFF/TONE -> 3, PAGER -> 9 ...; table not re-read here).
 *   Band B is a byte-for-byte twin in part 2 (dispatcher sub_30CE6).
 *
 * Every state handler opens with the same prologue (written once here as
 * rxa_common_prologue() for readability; in the binary it is inlined in
 * each handler, byte-identical):
 *
 *   if (band_a_comm_mode != 0)              digital (C4FM) receive
 *       -> rxa_digital_rx(r) (sub_2FCC8, outside): nonzero = "digital
 *          path handled it", zero = fall through to the analog tail with
 *          the audio decision already made.
 *   else
 *       rxa_dig_open = 0;
 *       if (node_mode < 0) {                PDN / node-keyed
 *           node_flags_B3D9 &= ~0x02;
 *           if (node_mode_8DE0 & 0x80) { r->sq = 2; return; }  (forced mute)
 *       }
 *       if (rxa_squelch_eval(r) != 0) return;     (sub_30590, r4l)
 *       sq = r3l result: 2 = closed -> "closed" arm; 1 = S-meter closed ->
 *       return; 0 = open -> rxa_busy_led_update() (0x030A24) then the arm.
 * ========================================================================== */

/* ---- shared prologue (documentation helper, not a binary routine) -------- */
enum { PRO_NODE_MUTE,   /* node-keyed forced mute: every handler returns     */
       PRO_ABORT,       /* rxa_squelch_eval returned r4l != 0 (RX saver)      */
       PRO_SMETER,      /* r3l == 1: S-meter squelch closed                   */
       PRO_CLOSED,      /* r3l == 2: muted / no carrier                       */
       PRO_OPEN,        /* r3l == 0 (busy LED already updated)                */
       PRO_DIGITAL_HANDLED, PRO_DIGITAL_FALL };
#define PRO_RETURN_ANY(p) ((p) == PRO_NODE_MUTE || (p) == PRO_ABORT || (p) == PRO_SMETER)
static int rxa_common_prologue(u8 *r)
{
    if (band_a_comm_mode != 0)                               /* FF8D20 */
        return rxa_digital_rx(r) ? PRO_DIGITAL_HANDLED : PRO_DIGITAL_FALL;
    rxa_dig_open = 0;                                        /* FF94BB */
    if ((s8)node_mode < 0) {                                 /* FF8DDE */
        node_flags_B3D9 &= ~0x02;
        if (node_flags_8DE0 & 0x80) { r_sq(r) = 2; return PRO_NODE_MUTE; }
    }
    if (rxa_squelch_eval(r) != 0) return PRO_ABORT;          /* r4l != 0 */
    if (g_r3l == 2) return PRO_CLOSED;                       /* r3l */
    if (g_r3l == 1) return PRO_SMETER;
    rxa_busy_led_update(r);                                  /* 0x030A24 */
    return PRO_OPEN;
}

/* --------------------------------------------------------------------------
 * 02FE44-02FEB2  size 110   rxa_state4_code_sql        (IDA sub_2FE44)
 * Band-A RX state 4 (table 0x02F2A8[4]).  Confirmed.
 * Tone/code squelch whose detect flag is rxa_tone_flags.b0 (FF8F86.b0, doc
 * 136: set by the DCS/CTCSS decoders).  Copies the detect flag into
 * rec+0x91.b2 ("audio wanted") and lets rxa_gate_audio() act on it.  r3l=2
 * is passed but no callee reads it.  Twin of state 5 (sub_302A0, r3l=3)
 * and of band-B sub_3197A.
 * -------------------------------------------------------------------------- */
void rxa_state4_code_sql(u8 *r)
{
    switch (rxa_common_prologue(r)) {
    case PRO_DIGITAL_HANDLED:                                /* 02FEA4 */
        if (r_sq(r) == 2) rxa_close_hold_tail(r);            /* sub_2FF4C */
        return;
    case PRO_CLOSED: rxa_close_hold(r); return;              /* 02FE9E */
    case PRO_NODE_MUTE: case PRO_ABORT: case PRO_SMETER: return;
    default: break;                                          /* open / dig. fall */
    }
    BIT_COPY(r_flags91(r), 2, rxa_tone_flags & 0x01);        /* 02FE88 bld/bst */
    rxa_gate_audio(r);                                       /* r3l = 2 (unused) */
}

/* --------------------------------------------------------------------------
 * 02FEB2-02FF0A  size 88   rxa_gate_audio              (IDA sub_2FEB2)
 * Callers: 2FE44, 2FF78, 302A0.  Confirmed.
 * Final audio decision for the tone-squelch states.  Monitor (AA35.b6, set
 * by rx_monitor_active) always opens.  Otherwise, when the tone/code flag
 * (+0x91.b2) is set and the S-meter squelch (rxa_smeter_sql, sub_2FC6E)
 * passes, ring the bell once and open; if the S-meter closes, drop b2 and
 * mute.  With no tone: if the band is still flagged "open hold" (FF8FE2)
 * and busy-lock bit FF89BF.b6 is clear, open "if enabled" (sub_309D6).
 * -------------------------------------------------------------------------- */
void rxa_gate_audio(u8 *r)
{
    r_flags92(r) &= ~0x04;
    if (!(rx_flags_AA35 & 0x40)) {                           /* not monitor */
        if (r_flags91(r) & 0x04) {
            if (rxa_smeter_sql(r) != 0) {                    /* S-meter closed */
                r_flags91(r) &= ~0x04;
                rxa_audio_mute();                            /* sub_309F2 */
                return;
            }
            rxa_ring_bell_once(r);                           /* bsr sub_2FF0A */
        } else {
            if (rxa_open_hold_8FE2 != 0 && !(cfg_89BF & 0x40) &&
                rxa_smeter_sql(r) == 0) {
                rxa_audio_open_if_enabled(r);                /* sub_309D6 */
                return;
            }
            rxa_audio_mute();
            return;
        }
    }
    rxa_audio_open(r);                                       /* sub_308BE */
}

/* --------------------------------------------------------------------------
 * 02FF0A-02FF48  size 62   rxa_ring_bell_once          (IDA sub_2FF0A)
 * Callers: 2FEB2, 3008C.  Confirmed (bell meaning Inferred).
 * First open after a quiet period: latch +0x92.b0; if the record's BELL
 * setting (+0x38) is non-zero play the bell tone (sub_32924), mark
 * +0x92.b1 / +0x9B.b1 (bell indicator) and request a redraw (817E.b1).
 * Returns 1 when the bell was started, else 0.
 * -------------------------------------------------------------------------- */
u8 rxa_ring_bell_once(u8 *r)
{
    if (r_flags92(r) & 0x01) return 0;
    r_flags92(r) |= 0x01;
    if (r_bell(r) == 0) return 0;                            /* +0x38 */
    bell_tone_start();                                       /* sub_32924 */
    r_flags92(r) |= 0x02;
    r_flags9B(r) |= 0x02;
    disp_flags_817E |= 0x02;
    return 1;
}

/* --------------------------------------------------------------------------
 * 02FF48-02FF78  size 48   rxa_close_hold              (IDA sub_2FF48)
 * Second entry 0x02FF4C = rxa_close_hold_tail (no mute call).  Callers:
 * 2FE44, 2FF78, 302A0 (and the tail from the digital arms).  Confirmed.
 * Squelch closed: mute (sub_30A00).  On the first pass arm the 100 ms-tier
 * timer FF95AB = 0x32 (5 s) and set +0x92.b2; when it expires clear
 * +0x92.b0 so the next opening rings the bell again.
 * -------------------------------------------------------------------------- */
void rxa_close_hold(u8 *r)
{
    rxa_audio_mute_af_dual();                                /* sub_30A00 */
    rxa_close_hold_tail(r);
}
void rxa_close_hold_tail(u8 *r)                              /* 02FF4C */
{
    if (!(r_flags92(r) & 0x04)) {
        r_flags92(r) |= 0x04;
        t100_rxa_bell_rearm = 0x32;                          /* FF95AB, 5 s */
    } else if (t100_rxa_bell_rearm == 0) {
        r_flags92(r) &= ~0x01;
    }
}

/* --------------------------------------------------------------------------
 * 02FF78-03000C  size 148  rxa_stateC_rev_code         (IDA sub_2FF78)
 * Band-A RX state 0xC.  Confirmed (REV TONE label Inferred from the
 * inverted copy).
 * Like state 4 but the tone flag is copied INVERTED (bist) into +0x91.b2:
 * audio opens when no tone is detected.  When the carrier closes
 * (r3l==2) a 300 ms holdoff FF957A = 0x1E is armed; while it runs and no
 * tone is seen the previous decision is kept, so a short tone gap does not
 * open the speaker.
 * -------------------------------------------------------------------------- */
void rxa_stateC_rev_code(u8 *r)
{
    switch (rxa_common_prologue(r)) {
    case PRO_DIGITAL_HANDLED:
        if (r_sq(r) == 2) rxa_close_hold_tail(r);
        return;
    case PRO_CLOSED:                                         /* 02FFF2 */
        t10_rxa_rev_holdoff = 0x1E;                          /* FF957A 300 ms */
        rxa_close_hold(r);
        return;
    case PRO_NODE_MUTE: case PRO_ABORT: case PRO_SMETER: return;
    default: break;
    }
    r_flags91(r) &= ~0x04;                                   /* 02FFBC */
    if ((rxa_tone_flags & 0x01) || t10_rxa_rev_holdoff == 0) {
        t10_rxa_rev_holdoff = 0;
        BIT_COPY(r_flags91(r), 2, !(rxa_tone_flags & 0x01)); /* bist #2 */
    }
    rxa_gate_audio(r);                                       /* r3l = 2 */
}

/* --------------------------------------------------------------------------
 * 03000C-03008C  size 128  rxa_state9_pager_wait1      (IDA sub_3000C)
 * Band-A RX state 9: PAGER, waiting for the first tone.  Confirmed
 * (PAGER label from doc 86 / doc 120 class 7).
 * On first-tone detect (8F86.b0) with the S-meter squelch passing: start
 * the 1.1 s second-tone window FF9577 = 0x6E, go to state 0xA and re-arm
 * the decoder for the second tone (sub_2F4AA + sub_2FB94).  Audio stays
 * muted unless MONITOR.
 * -------------------------------------------------------------------------- */
void rxa_state9_pager_wait1(u8 *r)
{
    int p = rxa_common_prologue(r);
    if (p == PRO_DIGITAL_HANDLED || PRO_RETURN_ANY(p)) return;
    if (p == PRO_CLOSED) { rxa_audio_mute_af_dual(); return; }   /* 030086 */
    if (rx_flags_AA35 & 0x40) { rxa_audio_open(r); return; }      /* monitor */
    if ((rxa_tone_flags & 0x01) && rxa_smeter_sql(r) == 0) {
        t10_rxa_pager_win = 0x6E;                            /* FF9577 1.1 s */
        r_state(r) = 0x0A;
        rxa_decoder_reinit(r);                               /* sub_2F4AA */
        rxa_tone_decoder_setup(r);                           /* sub_2FB94 */
    }
    rxa_audio_mute();
}

/* --------------------------------------------------------------------------
 * 03008C-03016C  size 224  rxa_stateA_pager_wait2      (IDA sub_3008C)
 * Band-A RX state 0xA: PAGER, waiting for the second tone.  Confirmed.
 * Second tone inside the 1.1 s window: page received -> redraw, open
 * (+0x91.b2, bell, sub_308BE), stop TPU0 (sub_2F550), hold the call open
 * for 10 s (FF95AC = 0x64), state 0xB.  If the PAGER answer-back setting
 * FF89C3.b2 (F345) is on, arm the answer-back: +0x86.b7 and a 2 s delay
 * FF9578 = 0xC8 (doc 86).  Window expiry returns to state 9.
 * In digital mode with the digital path handling it -> rxa_pager_reset.
 * -------------------------------------------------------------------------- */
void rxa_stateA_pager_wait2(u8 *r)
{
    int p = rxa_common_prologue(r);
    if (p == PRO_DIGITAL_HANDLED) { rxa_pager_reset(r); return; }   /* 030168 */
    if (p == PRO_NODE_MUTE) return;                          /* bmi rts */
    if (p == PRO_OPEN || p == PRO_DIGITAL_FALL) {
        if (rx_flags_AA35 & 0x40) {
            rxa_audio_open(r);
        } else if ((rxa_tone_flags & 0x01) && rxa_smeter_sql(r) == 0) {
            disp_flags_817E |= 0x02;
            r_flags91(r) |= 0x04;
            rxa_ring_bell_once(r);
            rxa_audio_open(r);
            tpu0_stop();                                     /* sub_2F550 */
            t100_rxa_pager_hold = 0x64;                      /* FF95AC 10 s */
            r_state(r) = 0x0B;
            r_flags86(r) &= ~0x80;
            t10_rxa_ansback_delay = 0;                       /* FF9578 */
            if (cfg_89C3 & 0x04) {                           /* PAGER ans-back */
                r_flags86(r) |= 0x80;
                t10_rxa_ansback_delay = 0xC8;                /* 2 s */
            }
            return;
        } else {
            rxa_audio_mute();
        }
    } else if (p == PRO_CLOSED) {
        rxa_audio_mute_af_dual();
    }
    /* 030152: window check (also reached from the r4l!=0 / r3l==1 exits) */
    if (t10_rxa_pager_win == 0) {
        r_state(r) = 9;
        rxa_decoder_reinit(r);
        rxa_tone_decoder_setup(r);
    }
}

/* --------------------------------------------------------------------------
 * 03016C-03019E  size 50   rxa_pager_reset             (IDA sub_3016C)
 * Callers: 3008C, 3019E.  Confirmed.
 * Abandon a page: clear answer-back arm, the three pager timers and the
 * bell latch, back to state 9 with the decoder re-armed.
 * -------------------------------------------------------------------------- */
void rxa_pager_reset(u8 *r)
{
    r_flags86(r) &= ~0x80;
    t10_rxa_pager_win = 0;  t10_rxa_ansback_delay = 0;  t100_rxa_pager_hold = 0;
    r_flags92(r) &= ~0x01;
    r_state(r) = 9;
    rxa_decoder_reinit(r);
    rxa_tone_decoder_setup(r);
}

/* --------------------------------------------------------------------------
 * 03019E-0302A0  size 258  rxa_stateB_pager_call       (IDA sub_3019E)
 * Band-A RX state 0xB: page received, call held open.  Confirmed (doc 86
 * T4 / doc 105 sec.7 for the answer-back).
 * While a carrier is present the 2 s answer-back delay and the 10 s hold
 * are re-loaded and the audio follows the S-meter squelch.  Once the
 * carrier has gone and the 2 s delay expired with the answer-back armed
 * (+0x86.b7, F345 on), the radio keys itself: TX range check
 * (sub_34DC2), AAD1.b0 = answer-back, AACE = 5 elements, stop tone,
 * candidate freq AAAA = AAAE, AACF = 1 (TX request), FF94C0 = 1 - this
 * bypasses sub_2244C's gates (doc 105).  When the 10 s hold expires:
 * back to state 9.
 * -------------------------------------------------------------------------- */
void rxa_stateB_pager_call(u8 *r)
{
    int p = rxa_common_prologue(r);
    if (p == PRO_DIGITAL_HANDLED) {                          /* 030290 */
        if (r_sq(r) == 0) { rxa_pager_reset(r); return; }
        goto ansback;
    }
    if (p == PRO_NODE_MUTE) return;
    if (p == PRO_OPEN || p == PRO_DIGITAL_FALL) {            /* 0301E6 */
        t10_rxa_ansback_delay = 0xC8;
        t100_rxa_pager_hold   = 0x64;
        if (!(rx_flags_AA35 & 0x40) && rxa_smeter_sql(r) != 0) rxa_audio_mute();
        else                                                   rxa_audio_open(r);
        return;
    }
    if (p == PRO_CLOSED) rxa_audio_mute_af_dual();
ansback:                                                     /* 030214 */
    if ((cfg_89C3 & 0x04) && (r_flags86(r) & 0x80) && t10_rxa_ansback_delay == 0) {
        r_flags86(r) &= ~0x80;
        if (tx_build_and_check_range(r) == 0) {              /* sub_34DC2: allow */
            tx_aux_AAD1 |= 0x01;                             /* answer-back TX */
            ansback_elem_count = 5;                          /* FFAACE */
            tone_req = 0xFF;                                 /* FFAAE0 stop */
            disp_flags_817E |= 0x02;
            tx_freq_AAAA = tx_cand_freq;                     /* FFAAAA = FFAAAE */
            tx_event = 1;                                    /* FFAACF */
            tx_state_94C0 = 1;                               /* FF94C0 */
        }
    }
    if (t100_rxa_pager_hold == 0) {                          /* 03026A */
        disp_flags_817E |= 0x02;
        r_flags92(r) &= ~0x01;
        r_state(r) = 9;
        rxa_decoder_reinit(r);
        rxa_tone_decoder_setup(r);
    }
}

/* --------------------------------------------------------------------------
 * 0302A0-030310  size 112  rxa_state5_code_sql         (IDA sub_302A0)
 * Band-A RX state 5.  Confirmed.  Byte-identical to state 4 except it
 * passes r3l = 3 to rxa_gate_audio (unused there).  Doc 136/120 class map
 * suggests 4 = TONE SQL and 5 = DCS (both report through 8F86.b0); the
 * exact split depends on table 0x003B5C (not read).
 * -------------------------------------------------------------------------- */
void rxa_state5_code_sql(u8 *r)
{
    switch (rxa_common_prologue(r)) {
    case PRO_DIGITAL_HANDLED: if (r_sq(r) == 2) rxa_close_hold_tail(r); return;
    case PRO_CLOSED: rxa_close_hold(r); return;
    case PRO_NODE_MUTE: case PRO_ABORT: case PRO_SMETER: return;
    default: break;
    }
    BIT_COPY(r_flags91(r), 2, rxa_tone_flags & 0x01);
    rxa_gate_audio(r);                                       /* r3l = 3 */
}

/* --------------------------------------------------------------------------
 * 030310-030410  size 256  rxa_state6_wx_alert         (IDA sub_30310)
 * Band-A RX state 6.  Confirmed control flow; WX-alert label Inferred:
 * the decoder installed for this state (0x00171C, doc 136) accepts periods
 * 0x398C..0x3D84 at phi/1, which brackets 16 MHz/1050 Hz = 0x3B86, the
 * NOAA weather-alert tone; the state is only kept while
 * rx_wx_alert_armed() (sub_328A6, needs setting FF89C2.b4) holds.
 * Flow:
 *  - latch rxa_alert_latch (FF8F89) == 0 and alert no longer armed ->
 *    state 3 (normal) + sub_2F578.
 *  - tone decoded (rxa_tone_result FF8F88 != 0) and latch 0 and S-meter ok:
 *    stop the decoder interrupt (FF34.b4), latch = 1, open for 5 min
 *    (FF95EE = 0x12C, 1 s tier), play alert tone 0x35 continuously
 *    (AAE6 = 0xFF), +0x91.b2 = 1, open audio.
 *  - latch == 2: sub_2EAC2, open audio (alert already acknowledged).
 *  - squelch closed: reset decoder result/run-state, mute.
 *  - after 5 min with latch 1: stop the tone (AAE0 = 0xFF), sub_2EAC2,
 *    latch = 2.
 * -------------------------------------------------------------------------- */
void rxa_state6_wx_alert(u8 *r)
{
    if (rxa_alert_latch == 0 && !rx_wx_alert_armed(r)) {     /* 030310 */
        r_state(r) = 3;
        rxa_decoder_stop(r);                                 /* sub_2F578 */
        return;
    }
    int p = rxa_common_prologue(r);
    if (p == PRO_DIGITAL_HANDLED || p == PRO_NODE_MUTE) return;
    if (p == PRO_ABORT || p == PRO_SMETER) goto timer;       /* 0303E4 */
    if (p == PRO_CLOSED) {                                   /* 0303C8 */
        rxa_audio_mute_led(r);                               /* sub_30A66 */
        rxa_tone_result = 0; rxa_tone_runstate = 0;          /* 8F88/8F87 */
        r_flags91(r) &= ~0x04;
        rxa_audio_mute();
        goto timer;
    }
    if (rx_flags_AA35 & 0x40) { rxa_audio_open(r); goto timer; }
    if (rxa_alert_latch == 2) { ui_refresh_2EAC2(); rxa_audio_open(r); goto timer; }
    if (rxa_tone_result == 0) { r_flags91(r) &= ~0x04; rxa_audio_mute(); goto timer; }
    if (rxa_alert_latch != 0) { rxa_audio_mute(); goto timer; }
    if (rxa_smeter_sql(r) != 0) {                            /* 0303CC */
        rxa_tone_result = 0; rxa_tone_runstate = 0;
        r_flags91(r) &= ~0x04;
        rxa_audio_mute();
        goto timer;
    }
    TPU_TIER_FF34 &= ~0x0010;                                /* decoder IRQ off */
    rxa_alert_latch = 1;
    t1s_rxa_alert = 0x12C;                                   /* FF95EE 300 s */
    tone_repeat = 0xFF;                                      /* FFAAE6 */
    tone_req = 0x35;                                         /* alert tone */
    r_flags91(r) |= 0x04;
    rxa_audio_mute();                                        /* 0303E0 (as coded) */
timer:                                                       /* 0303E4 */
    if (rxa_alert_latch == 1 && t1s_rxa_alert == 0) {
        tone_req = 0xFF;
        ui_refresh_2EAC2();
        rxa_alert_latch = 2;
    }
}
/* note: the "latch set" path stores +0x91.b2 and then branches to 0x0303E0
 * (sub_309F2, mute) - the speaker is opened by the alert tone engine, not by
 * this state.  Kept as coded. */

/* --------------------------------------------------------------------------
 * 030410-0304DC  size 204  rxa_state7_jr_freq          (IDA sub_30410)
 * Band-A RX state 7 (SQL TYPE JR FREQ per sub_31594 band-B selector:
 * class 5 -> state 7).  Confirmed control flow, label Inferred.
 * rxa_tone_result (8F88): 0 = none yet, 1 = no tone (timeout), 2 = tone
 * matched (doc 136, decoder 0x001784).  Matched tone MUTES (reverse
 * squelch): +0x91.b7 set, and once the 1 s hold FF9576 is over the result
 * is reset to 1 with a 0.5 s re-check FF9575.  No tone and S-meter ok and
 * FF9575 expired: open with a 1 s hold.
 * -------------------------------------------------------------------------- */
void rxa_state7_jr_freq(u8 *r)
{
    int p = rxa_common_prologue(r);
    if (p == PRO_DIGITAL_HANDLED || PRO_RETURN_ANY(p)) return;
    if (p == PRO_CLOSED) {                                   /* 0304AE */
        r_flags91(r) &= ~0x80;
        rxa_tone_result = 0; rxa_tone_runstate = 0;
        rxa_audio_mute_led(r);
        t10_rxa_recheck = 0x32;                              /* FF9575 */
        goto mute;
    }
    if (rx_flags_AA35 & 0x40) goto open;
    if (rxa_tone_result >= 2) {                              /* matched */
        r_flags91(r) |= 0x80;
        if (t10_rxa_hold == 0) {                             /* FF9576 */
            rxa_tone_result = 1;
            t10_rxa_recheck = 0x32;
            goto mute;
        }
        goto open_b2;
    }
    if (rxa_smeter_sql(r) != 0 || t10_rxa_recheck != 0) goto mute;
    t10_rxa_hold = 0x64;                                     /* 1 s */
open_b2:
    r_flags91(r) |= 0x04;
open:
    rxa_audio_open(r);
    return;
mute:
    r_flags91(r) &= ~0x04;
    rxa_audio_mute();
}

/* --------------------------------------------------------------------------
 * 0304DC-030590  size 180  rxa_state8_pr_freq          (IDA sub_304DC)
 * Band-A RX state 8 (PR FREQ: decoder window loaded from the PR-frequency
 * index, doc 136 routine 0x00181A).  Confirmed flow, label Inferred.
 * Here result 1 OPENS (with a 1 s hold FF9576) when the S-meter passes;
 * result 2 sets +0x91.b7; result 0/2 keep the audio open only while the
 * hold runs.  Carrier gone: hold still running -> stay open, else reset
 * the decoder result and mute.
 * -------------------------------------------------------------------------- */
void rxa_state8_pr_freq(u8 *r)
{
    int p = rxa_common_prologue(r);
    if (p == PRO_DIGITAL_HANDLED || PRO_RETURN_ANY(p)) return;
    if (p == PRO_CLOSED) {                                   /* 030562 */
        if (t10_rxa_hold != 0) goto open_b2;
        r_flags91(r) &= ~0x80;
        rxa_tone_result = 0; rxa_tone_runstate = 0;
        rxa_audio_mute_led(r);
        goto mute;
    }
    if (rx_flags_AA35 & 0x40) goto open;
    if (rxa_tone_result == 1) {                              /* 030546 */
        if (rxa_smeter_sql(r) != 0) goto mute;
        t10_rxa_hold = 0x64;
        goto open_b2;
    }
    if (rxa_tone_result != 0) r_flags91(r) |= 0x80;          /* 030534 */
    if (t10_rxa_hold != 0) goto open_b2;
    goto mute;
open_b2:
    r_flags91(r) |= 0x04;
open:
    rxa_audio_open(r);
    return;
mute:
    r_flags91(r) &= ~0x04;
    rxa_audio_mute();
}

/* --------------------------------------------------------------------------
 * 030590-030654  size 196  rxa_squelch_eval            (IDA sub_30590)
 * Callers: every band-A analog RX state + sub_2FC0C.  Confirmed.
 * Returns r4l (0 = continue, 1 = abort: A9E7.b1 "RX saver asleep") and the
 * squelch class in r3l, also stored to rec+0x90:
 *   0 open, 1 S-meter squelch closed, 2 muted.
 *  - B057.b7 (DSP/RX disable) -> r3l = 2, r4l = 0, +0x90 untouched.
 *  - post-retune settle FF9570 running -> mute.
 *  - +0x89.b3 = 1 ("evaluated"), +0x8F.b3 = 0 (RF fault cleared).
 *  - MONITOR (rx_monitor_active) -> open.
 *  - RF-status interlock 0xFFFF4D.b3 high (doc 93) -> redraw, +0x8F.b3,
 *    mute.
 *  - else the noise/S-meter decision rxa_noise_squelch (0x0306B2).
 * Activity: open -> RX-activity timer FF9591 = 3 s and rx_activity = 2;
 * closed for 3 s with no other band/APRS/AF-dual activity -> rx_activity
 * = 1 (idle, feeds the RX saver sub_340A8).
 * -------------------------------------------------------------------------- */
u8 rxa_squelch_eval(u8 *r)
{
    u8 sq;
    if (dsp_flags_B057 & 0x80) { g_r3l = 2; return 0; }
    if (t10_rxa_settle != 0) { r_sq(r) = 2; g_r3l = 2; return 0; }   /* FF9570 */
    r_flags89(r) |= 0x08;
    r_flags8F(r) &= ~0x08;
    if (rx_monitor_active(r)) {                              /* sub_3286C */
        sq = 0;
    } else {
        if (rx_save_flags_A9E7 & 0x02) { r_sq(r) = 2; g_r3l = 2; return 1; }
        if (PORT_4D & 0x08) {                                /* RF status high */
            disp_flags_817E |= 0x02;
            r_flags8F(r) |= 0x08;
            r_sq(r) = 2; g_r3l = 2; return 0;
        }
        sq = rxa_noise_squelch(r);                           /* bsr 0x0306B2 */
    }
    r_sq(r) = sq; g_r3l = sq;
    if (sq != 2) {
        t100_rx_activity = 0x1E;                             /* FF9591 3 s */
        rx_activity = 2;                                     /* FFA9E6 */
    } else if (t100_rx_activity == 0) {
        if (band_b_comm_mode != 0 && (band_cfg_8EA0 & 0x80)) return 0;
        if ((band_cfg_8EA0 & 0x80) && aprs_modem != 0)    return 0;  /* FF8AA0 */
        if (rxa_open_hold_8FE2 != 0)                       return 0;
        if ((band_cfg_8EA0 & 0x80) && rxb_open_hold_90EA != 0) return 0;
        rx_activity = 1;
    }
    return 0;
}

/* --------------------------------------------------------------------------
 * 030654-0306EA  size 150  rxa_noise_squelch_dsp       (IDA sub_30654)
 * Entry 0x0306B2 = rxa_noise_squelch (the analog core; bsr target from
 * rxa_squelch_eval).  Callers: 30590 (core), 3080C.  Confirmed mechanics,
 * DSP-frame roles from doc 86 (B111/B112/B113/BC5D/BC5F/B11C).
 * Digital-side pre-step (full entry): when a DSP receive sequence is
 * pending (B111) and owned by band A (BC5D == 0): if FF9558 is idle and
 * the DSP did not report frame 0xB6, cancel it (B0C6 = 2, B111 = B113 = 0).
 * Otherwise, when B11C.b0 is set and FF957B expired (and B263 == 0): clear
 * it, B112 1->2, run sub_2F664 + sub_2F392.
 * Core (0x0306B2): rxa_noise_compare (sub_306EA).  r3l != 2 -> if the
 * band was open (+0x90 != 0) load the squelch-tail delay FF956B from
 * byte_3B7A[rec+0x83] and FF957C = 0x19 (250 ms); return 0 (open).
 * r3l == 2 -> return 1 while the tail FF956B runs, then 2 (closed).
 * -------------------------------------------------------------------------- */
u8 rxa_noise_squelch_dsp(u8 *r)
{
    if (dsp_rx_seq_B111 != 0 && dsp_rx_owner_BC5D == 0) {    /* 03065A */
        if (t10_dsp_9558 != 0) goto tail_open;               /* 0306B8 */
        if (dsp_last_frame_BC02 != 0xB6) {
            dsp_req_B0C6 = 2; dsp_rx_seq_B111 = 0; dsp_rx_B113 = 0;
        }
    } else if (dsp_B263 == 0 && (dsp_rx_flags_B11C & 0x01) && t10_dsp_957B == 0) {
        dsp_rx_flags_B11C &= ~0x01;
        if (dsp_rx_B112 == 1) dsp_rx_B112 = 2;
        rxa_dsp_seq_done_2F664();
        rxa_dsp_seq_done_2F392();
    }
    return rxa_noise_squelch(r);
tail_open:
    return rxa_noise_squelch_tail_open(r);
}
u8 rxa_noise_squelch(u8 *r)                                  /* 0306B2 */
{
    if (rxa_noise_compare(r) == 2) {                         /* 0306DC */
        return (t10_rxa_sq_tail != 0) ? 1 : 2;               /* FF956B */
    }
    return rxa_noise_squelch_tail_open(r);
}
static u8 rxa_noise_squelch_tail_open(u8 *r)                 /* 0306B8 */
{
    if (r_sq(r) != 0) {
        t10_rxa_sq_tail = byte_3B7A[r_83(r)];               /* tail by setting */
        t10_rxa_smeter_hold = 0x19;                          /* FF957C */
    }
    return 0;
}

/* --------------------------------------------------------------------------
 * 0306EA-0307E0  size 246  rxa_noise_compare           (IDA sub_306EA)
 * Caller: 0x0306B2.  Confirmed (doc 137 sec.3).
 * Returns 2 (mute) or 0 (open).  Forced 2 when AA33.b0 (TX/clone hold) or
 * in modes 0xA/0xB with +0x8A set.  When the channel-busy override
 * FF8EBD.b7 applies (b6/b5 and FF8EAD select) and FF9072 is zero -> 2.
 * Otherwise the calibration block [FF8162] = {HIS, THLD, TIGH} gives the
 * threshold for SQL LEVEL FF8970 (1 -> THLD-h, 15 -> TIGH-h, 2..14
 * interpolated, h = HIS/2); AN2 (FFA992) above it opens, with HIS of
 * hysteresis unless already muted.  SQL LEVEL 0: open only on tone-class
 * evidence (class 3 or 2 with 8F86.b0, class 7 with no pager hold).
 * -------------------------------------------------------------------------- */
u8 rxa_noise_compare(u8 *r)
{
    const u8 *cal; u8 hys, t1, t15, thr, lvl, an2, cls;
    if (rx_hold_AA33 & 0x01) return 2;
    if ((r_mode(r) == 0xA || r_mode_alt(r) == 0xA ||
         r_mode(r) == 0xB || r_mode_alt(r) == 0xB) && r_8A(r) != 0) return 2;
    if (busy_ovr_8EBD & 0x80) {                              /* 03071E */
        int check_other = 0;
        if (!(busy_ovr_8EBD & 0x40)) {
            if (ui_8EAD != 0 && (busy_ovr_8EBD & 0x20)) check_other = 1;
        } else if (busy_ovr_8EBD & 0x20) {                   /* 030740 */
            if (ui_8EAD == 0) return 2;
            check_other = 1;
        }
        if (check_other && rxb_8A == 0) return 2;            /* FF9072 = recB+0x8A */
    }
    cal = sq_cal_a;                                          /* [FF8162] */
    hys = cal[0]; t1 = cal[1] - (hys >> 1); t15 = cal[2] - (hys >> 1);
    lvl = sql_level_a;                                       /* FF8970 */
    if (lvl == 0) {                                          /* 0307B4 */
        cls = rx_sql_class(r);                               /* sub_3EF2E */
        if (cls == 2 || (cls == 7 && t100_rxa_pager_hold == 0) || cls == 3) {
            if (rxa_tone_flags & 0x01) thr = t1; else return 0;
        } else return 0;
    } else if (lvl == 1)  thr = t1;
    else if (lvl == 15)   thr = t15;
    else                  thr = t1 - ((u8)(t1 - t15) / 14) * (lvl - 1);
    an2 = adc_an2;                                           /* FFA992 */
    if (thr >= an2) return 0;
    if (r_sq(r) == 2) return 2;
    if ((u8)(thr + hys) >= an2) return 0;
    return 2;
}
/* note: the SQL LEVEL 0 arm jumps back to 0x030794 (thr = t1) when the tone
 * flag is set: noise squelch then still applies at the THLD point. */

/* --------------------------------------------------------------------------
 * 0307E0-03080C  size 44   rxa_squelch_eval_dig        (IDA sub_307E0)
 * 03080C-0308BE  size 178  (IDA sub_3080C: mis-split continuation of the
 *                           same routine, entered only by fall-through)
 * Caller: sub_2FCC8 (band-A digital RX).  Confirmed.
 * Same contract as rxa_squelch_eval (r4l, r3l, +0x90) for the digital
 * path, using the full DSP-aware rxa_noise_squelch_dsp.  Differences:
 * open clears the B0AC low request bits (DSP audio request); closed for
 * 3 s requests B0AC = 1 when SAVE RX (FF89B1) is on or a link is busy,
 * else marks the band idle (rx_activity = 1).
 * -------------------------------------------------------------------------- */
u8 rxa_squelch_eval_dig(u8 *r)
{
    u8 sq;
    if (t10_rxa_settle != 0) { r_sq(r) = 2; g_r3l = 2; return 0; }
    r_flags89(r) |= 0x08;
    r_flags8F(r) &= ~0x08;
    if (rx_monitor_active(r)) sq = 0;
    else {
        if (rx_save_flags_A9E7 & 0x02) { r_sq(r) = 2; g_r3l = 2; return 1; }
        /* ---- 0x03080C (IDA sub_3080C) ---- */
        if (PORT_4D & 0x08) {
            disp_flags_817E |= 0x02; r_flags8F(r) |= 0x08;
            r_sq(r) = 2; g_r3l = 2; return 0;
        }
        sq = rxa_noise_squelch_dsp(r);                       /* sub_30654 */
    }
    r_sq(r) = sq; g_r3l = sq;
    if (sq != 2) {
        t100_rx_activity = 0x1E; rx_activity = 2;
        if (dsp_audio_req_B0AC & 3) dsp_audio_req_B0AC = 0;
        return 0;
    }
    if (t100_rx_activity != 0) return 0;
    if (save_rx == 0 || dsp_busy_B3F9 != 0) goto req;        /* FF89B1 SAVE RX */
    if ((band_cfg_8EA0 & 0x80) &&
        (band_b_comm_mode == 0 || band_b_comm_mode == 2) && aprs_modem != 0) goto req;
    if (rxa_open_hold_8FE2 != 0) goto req;
    if ((band_cfg_8EA0 & 0x80) && rxb_open_hold_90EA != 0) goto req;
    rx_activity = 1;
    return 0;
req:
    if (!(dsp_audio_req_B0AC & 3)) dsp_audio_req_B0AC = 1;
    return 0;
}

/* --------------------------------------------------------------------------
 * 0308BE-030922  size 100  rxa_audio_open              (IDA sub_308BE)
 * Callers: 2FC0C, 2FCC8, 2FEB2, 3000C, 3008C, 3019E, 30310, 30410, 304DC.
 * Confirmed (MUTE label from F327 = FF89B3).
 * Request band-A speaker audio.  In mode 0xA (or with 8EA9.b7 outside it)
 * the request becomes a mute.  Requires +0x8F.b0 (band audio enabled).
 * In dual receive (8EA0.b7) with MUTE (F327) on: when band B is the
 * operating band and is itself open (A9E3.b1), mark band A as "muted by
 * the other band" (A9E2.b0); MUTE level 3 then keeps band A silent.
 * Falls into rxa_audio_open_tail (0x030922/0x030928).
 * -------------------------------------------------------------------------- */
void rxa_audio_open(u8 *r)
{
    if (r_mode(r) != 0xA && r_mode_alt(r) != 0xA && (ui_8EA9 & 0x80)) {
        rxa_audio_mute(); return;
    }
    if (!(r_flags8F(r) & 0x01)) return;
    if (!(band_cfg_8EA0 & 0x80) || mute_setting == 0) { rxa_audio_open_tail(); return; }
    audio_mute_by_other &= ~0x01;                            /* A9E2.b0 */
    if ((band_cfg_8EA0 & 0x40) && (audio_req & 0x02)) {
        audio_mute_by_other |= 0x01;
        if (mute_setting == 3) {
            audio_req |= 0x80; audio_req &= ~0x01;           /* stay muted */
            return;
        }
    }
    rxa_audio_open_set();                                    /* 0x030928 */
}

/* --------------------------------------------------------------------------
 * 030922-030942  size 32   rxa_audio_open_tail         (IDA sub_30922)
 * Callers: 308BE (fall-in), sub_6C8E8, sub_6CF30 (node handlers).
 * Confirmed.  A9E2 = 0 (entry 0x030922); then (0x030928): AA36.b6 =
 * band-A busy, A9E3 |= 0x81 (audio request: band A on), A9E4.b0 = 0.
 * -------------------------------------------------------------------------- */
void rxa_audio_open_tail(void)
{
    audio_mute_by_other = 0;
    rxa_audio_open_set();
}
void rxa_audio_open_set(void)                                /* 030928 */
{
    rx_busy_AA36 |= 0x40;
    audio_req |= 0x80 | 0x01;
    audio_aux_A9E4 &= ~0x01;
}

/* --------------------------------------------------------------------------
 * 030942-0309AC  size 106  rxa_audio_open_alt          (IDA sub_30942)
 * Callers: sub_333BC, sub_33450 (AF-dual broadcast monitor).  Confirmed.
 * Same decision as rxa_audio_open without the mode/8EA9 test and without
 * touching AA36; the final request sets A9E4.b0 (alternate source - the
 * broadcast receiver) instead of clearing it.
 * -------------------------------------------------------------------------- */
void rxa_audio_open_alt(u8 *r)
{
    if (!(r_flags8F(r) & 0x01)) return;
    if ((band_cfg_8EA0 & 0x80) && mute_setting != 0) {
        audio_mute_by_other &= ~0x01;
        if ((band_cfg_8EA0 & 0x40) && (audio_req & 0x02)) {
            audio_mute_by_other |= 0x01;
            if (mute_setting == 3) { audio_req |= 0x80; audio_req &= ~0x01; return; }
        }
    } else {
        audio_mute_by_other = 0;
    }
    audio_req |= 0x81;
    audio_aux_A9E4 &= ~0x01;
    audio_aux_A9E4 |= 0x01;                                  /* bclr then bset */
}

/* 0309AC-0309C0  size 20   audio_req_mute_a_aux_off    (IDA sub_309AC)
 * Caller: sub_331DC.  Confirmed.  A9E3.b7=1, b0=0; A9E4.b0=0. */
void audio_req_mute_a_aux_off(void)
{ audio_req |= 0x80; audio_req &= ~0x01; audio_aux_A9E4 &= ~0x01; }

/* 0309C0-0309D6  size 22   rxa_audio_mute_aux_led      (IDA sub_309C0)
 * Callers: 330F0, 33136, 333BC, 33450.  Confirmed.
 * As 309AC, then tail-jumps to rxa_audio_mute_led (sub_30A66). */
void rxa_audio_mute_aux_led(u8 *r)
{ audio_req_mute_a_aux_off(); rxa_audio_mute_led(r); }

/* 0309D6-0309F2  size 28   rxa_audio_open_if_enabled   (IDA sub_309D6)
 * Caller: 2FEB2.  Confirmed.  If +0x8F.b0: A9E3 |= 0x81, A9E4.b0 = 0. */
void rxa_audio_open_if_enabled(u8 *r)
{
    if (!(r_flags8F(r) & 0x01)) return;
    audio_req |= 0x81; audio_aux_A9E4 &= ~0x01;
}

/* 0309F2-030A00  size 14   rxa_audio_mute              (IDA sub_309F2)
 * 25 callers (all band-A RX states, scan, node handlers).  Confirmed.
 * Audio request: band A off (A9E3.b0 = 0, b7 = 1 "request pending"). */
void rxa_audio_mute(void) { audio_req |= 0x80; audio_req &= ~0x01; }

/* --------------------------------------------------------------------------
 * 030A00-030A0C  size 12   rxa_audio_mute_af_dual      (IDA sub_30A00)
 * Callers: 2FC0C, 2FCC8, 2FF48, 3000C, 3008C, 3019E, sub_6CDEA.  Confirmed.
 * If the AF-dual state FF8EA6 is positive with b1 set (broadcast muted for
 * a ham signal), only mute band A (sub_309F2); otherwise fall into
 * rxa_audio_mute_and_led (0x030A0C).
 * -------------------------------------------------------------------------- */
void rxa_audio_mute_af_dual(void)
{
    u8 s = af_dual_state;                                    /* FF8EA6 */
    if (s != 0 && !(s & 0x80) && (s & 0x02)) { rxa_audio_mute(); return; }
    rxa_audio_mute_and_led(g_er0);
}

/* 030A0C-030A1A  size 14   rxa_audio_mute_and_led      (IDA sub_30A0C)
 * Callers: 2F400, 30A00 (fall-in), 34706.  Confirmed.
 * Band-A audio off, then busy-LED update (bra sub_30A66). */
void rxa_audio_mute_and_led(u8 *r) { rxa_audio_mute(); rxa_audio_mute_led(r); }

/* --------------------------------------------------------------------------
 * 030A1A-030A66  size 76   rxa_busy_led_update         (IDA sub_30A1A)
 * Entry 0x030A1A gated by FF89C8.b2; entry 0x030A24 (used by every RX
 * state, sub_35872, sub_35EC0) gated by node mode / FF89C8.b0.
 * Callers (both entries): 15 sites.  Confirmed (LED roles Inferred: the
 * byte reaches 0xFFFBA5 b1/b0, the band-A busy / TX lamps).
 * Lamp on: in modes other than 0xA with 8EA9.b7 set -> both lamps off
 * (AFF2 = 0); else AFF2 = 0x80 (busy) and continue in the shared tail of
 * rxa_audio_mute_led at 0x030A8E.  Lamp off: rxa_audio_mute_led.
 * -------------------------------------------------------------------------- */
void rxa_busy_led_update_C8b2(u8 *r)                         /* 030A1A */
{
    if (!(led_cfg_89C8 & 0x04)) { rxa_audio_mute_led(r); return; }
    rxa_busy_led_on(r);
}
void rxa_busy_led_update(u8 *r)                              /* 030A24 */
{
    if (node_mode != 0) {
        if (node_flags_B3D5 & 0x80) { rxa_audio_mute_led(r); return; }
    } else if (!(led_cfg_89C8 & 0x01)) { rxa_audio_mute_led(r); return; }
    rxa_busy_led_on(r);
}
static void rxa_busy_led_on(u8 *r)                           /* 030A3C */
{
    if (r_mode(r) != 0xA && r_mode_alt(r) != 0xA && (ui_8EA9 & 0x80)) {
        led_a_state = 0; led_write_A(0); return;             /* AFF2, 0x030AEE */
    }
    led_a_state = 0x80;
    rxa_led_tail(r, 0x80);                                   /* 0x030A8E */
}

/* --------------------------------------------------------------------------
 * 030A66-030ACE  size 104  rxa_audio_mute_led          (IDA sub_30A66)
 * (The routine ends at 0x030AFE inside IDA's sub_30AEE.)  Callers: 2F5EE,
 * 30310, 30410, 304DC, 35E88, 5B772 + tails.  Confirmed (lamp roles
 * Inferred).
 * Band-A busy lamp off (AFF2 = 0) and recompute the shared lamps:
 * unless B057.b4 freezes them, in modes 0xB (with +0x8A) or dual watch
 * (8EA0.b4) show band B's lamp state AFF3 when band B is not the operating
 * band.
 * -------------------------------------------------------------------------- */
void rxa_audio_mute_led(u8 *r)
{
    if (r_mode(r) != 0xA && r_mode_alt(r) != 0xA && (ui_8EA9 & 0x80)) {
        led_a_state = 0; led_write_A(0); return;
    }
    led_a_state = 0;
    rxa_led_tail(r, 0);
}
static void rxa_led_tail(u8 *r, u8 v)                        /* 030A8E */
{
    if (dsp_flags_B057 & 0x10) return;
    if (r_mode(r) == 0xB || r_mode_alt(r) == 0xB) {
        if (r_8A(r) == 0) { led_write_A(v); return; }
    } else if (!(band_cfg_8EA0 & 0x10)) { led_write_A(v); return; }
    v = 0;                                                   /* 030AB6 */
    if ((band_cfg_8EA0 & 0x10) && !(band_cfg_8EA0 & 0x40)) v = led_b_state;
    led_write_A(v);
}

/* 030ADC-030AEE  size 18   rxa_tx_led_on               (IDA sub_30ADC)
 * Callers: sub_34B30 (TX key-up, band A operating), sub_6CF30.  Confirmed.
 * In node mode with B3D5.b7 -> lamps off (sub_30A66); else lamp value
 * 0x40 (TX) -> led_write_A. */
void rxa_tx_led_on(u8 *r)
{
    if (node_mode != 0 && (node_flags_B3D5 & 0x80)) { rxa_audio_mute_led(r); return; }
    led_write_A(0x40);
}

/* 030AEE-030B00  size 18   led_write_A                 (IDA sub_30AEE)
 * Callers: 10528, 3EA28, 694A + tails.  Confirmed.
 * 0xFFFBA5.b1 = v.b7 (busy), 0xFFFBA5.b0 = v.b6 (TX). */
void led_write_A(u8 v)
{
    BIT_COPY(LED_PORT_FBA5, 1, v & 0x80);
    BIT_COPY(LED_PORT_FBA5, 0, v & 0x40);
}
