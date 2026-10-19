
/* ######################################################################### *
 * PART 1  -  DTMF digit sender (038CB4..039030)                             *
 *                                                                           *
 * The DTMF queue is a 20-slot ring of key codes at FFAC0E..FFAC21           *
 * (0xFF = empty).  Read index FFAC0B, write index FFAC0C.  Codes 0..15      *
 * are the keys 0-9 A B C D * # (doc 120 sec.6); 0x10 is a "pause" code.     *
 * A digit is played by loading the two phase increments from               *
 * dtmf_incr_tbl[d] (0x039040, f x 10 scale) into FFAABE, zeroing the       *
 * phases FFAABA, setting FFAAD2.b2 and starting TPU1 (tpu1_tone_start);    *
 * the TPU1 ISR synthesises the two sines on DA0.  In a digital band mode   *
 * the code is instead also posted to FFB0C0 (d+1; 0xFE = tone off,         *
 * 0xFF = idle), which the DSP side consumes (Inferred).                     *
 *                                                                           *
 * FFAC0A is the sender state; FF9545 is a 10 ms-tier on/off timer.         *
 * ######################################################################### */

/* Shared predicate, inlined 6x by the compiler in this part:               *
 * "operating band is in a digital comm mode that carries DTMF via DSP".    *
 * comm = FF8EA0.b6 ? FF8DD5 : FF8D20;  sub = FF8EA0.b6 ? FF8EC5 : FF8EB6.  *
 * Result: comm != 0 && (comm == 1 || sub < 4).                              */
static inline int band_dtmf_via_dsp(void)
{
    u8 comm = (band_sel & 0x40) ? bandB_comm_mode : bandA_comm_mode;
    if (comm == 0) return 0;
    if (comm == 1) return 1;
    return ((band_sel & 0x40) ? bandB_dig_mode : bandA_dig_mode) < 4;
}

/* ==========================================================================
 * 038CB4-038CCA  size 22   dtmf_next_digit_guarded   (sub_38CB4)
 * Confidence: Confirmed.   Callers: none static (state-table handler, falls
 * through).  Guard prologue that falls into dtmf_next_digit (038CCA):
 * returns at once unless the on/off timer FF9544 is 0, AAE1.b7 (audio
 * route held, set by the audio machine) is set and the DTMF sender is
 * active (FFAC09.b6).  The early exits reuse the rts at 038CB2.
 * ========================================================================== */
void dtmf_next_digit_guarded(void)
{
    if (dtmf_gap_timer != 0) return;                  /* 038CB4 FF9544      */
    if (!(audio_route_flags & 0x80)) return;          /* 038CBA AAE1.b7     */
    if (!(dtmf_flags & 0x40)) return;                 /* 038CC2 AC09.b6     */
    dtmf_next_digit();                                /* falls into 038CCA  */
}

/* ==========================================================================
 * 038CCA-038D66  size 156  dtmf_next_digit   (sub_38CCA)
 * Confidence: Confirmed (doc 120 sec.6).  Callers: sub_38E0E, sub_38FA8.
 * Pops one code from the DTMF ring.  Empty slot (0xFF, N set) -> returns
 * with N set ("queue empty"; callers test bpl).  Otherwise frees the slot,
 * advances the read index mod 20, and for a real digit (code != 0x10):
 * posts d+1 to the DSP mailbox when the band is digital, loads the two
 * DTMF increments, zeroes the phases, sets AAD2.b2 and starts TPU1.  Both
 * the digit and the pause code then continue in dtmf_digit_started.
 * Return: modelled as int; < 0 = queue was empty (N flag).
 * ========================================================================== */
int dtmf_next_digit(void)
{
    u8 idx = dtmf_rd;                                 /* 038CCA FFAC0B      */
    u8 d   = dtmf_queue[idx];                         /* 038CD4 FFAC0E[idx] */
    if (d & 0x80) return -1;                          /* 038CD8 empty       */
    dtmf_cur = d;                                     /* 038CDC FFAC08      */
    dtmf_queue[idx] = 0xFF;                           /* 038CE2 free slot   */
    if (++idx == 20) idx = 0;                         /* 038CE6..038CF2     */
    dtmf_rd = idx;
    if (d != 0x10) {                                  /* 038CF6 0x10 = pause*/
        if (band_dtmf_via_dsp())
            dsp_dtmf_code = d + 1;                    /* 038D34 FFB0C0      */
        dtmf_phase_inc = dtmf_incr_tbl[d];            /* 038D40 -> FFAABE   */
        dtmf_phase     = 0;                           /* 038D54 FFAABA      */
        tone_flags    |= 0x04;                        /* 038D5A AAD2.b2     */
        tpu1_tone_start();                            /* 038D60 sub_351D6   */
    }
    return dtmf_digit_started();                      /* bra 038D6C         */
}

/* ==========================================================================
 * 038D6C-038D90  size 36   dtmf_digit_started   (sub_38D6C)
 * Confidence: Confirmed.  Callers: tail of dtmf_next_digit.
 * Arms the tone-on timer, counts the digit (FFAC07, the position shown on
 * screen), requests a redraw (817E.b1) and moves the sender to state 4
 * (manual single key, AC09.b1) or state 2 (memory string).  Returns the
 * state (positive, so N = 0 for the callers' bpl).
 * ========================================================================== */
int dtmf_digit_started(void)
{
    dtmf_set_timer();                                 /* 038D6C bsr 038DA0  */
    dtmf_count++;                                     /* 038D6E FFAC07      */
    ui_refresh_flags |= 0x02;                         /* 038D78 817E.b1     */
    dtmf_state = (dtmf_flags & 0x02) ? 4 : 2;         /* 038D7E..038D8A     */
    return dtmf_state;
}

/* ==========================================================================
 * 038DA0-038DBA  size 26   dtmf_set_timer   (sub_38DA0)
 * Confidence: Confirmed (values); Inferred (89BE.b2 = DTMF SPEED slow).
 * Callers: 38D6C, 38DEE, 38F7C.
 * Loads FF9545 with 6 ticks, or 10 when a memory string is running
 * (AC09.b0) and setting bit 89BE.b2 is set.
 * ========================================================================== */
void dtmf_set_timer(void)
{
    u8 t = 6;                                         /* 038DA0             */
    if ((dtmf_flags & 0x01) && (set_89BE & 0x04))     /* 038DA2 / 038DAA    */
        t = 10;
    dtmf_tone_timer = t;                              /* 038DB4 FF9545      */
}

/* ==========================================================================
 * 038DBA-038DEE  size 52   dtmf_tone_off_step   (sub_38DBA)
 * 038DEE-038E0E  size 32   (its tail, sub_38DEE)
 * Confidence: Confirmed.  Callers: none static (state-table handler).
 * When the tone-on timer expires: stop the tone, post 0xFE ("tone off")
 * to the DSP mailbox if digital, reload the timer as the inter-digit gap
 * and enter state 3.  IDA split the shared predicate tail at 038DEE into
 * its own "function"; it has no entry of its own.
 * ========================================================================== */
void dtmf_tone_off_step(void)
{
    if (dtmf_tone_timer != 0) return;                 /* 038DBA FF9545      */
    dtmf_tone_stop();                                 /* 038DC0 sub_39030   */
    if (band_dtmf_via_dsp())                          /* 038DC4..038DF8     */
        dsp_dtmf_code = 0xFE;                         /* 038DFC FFB0C0      */
    dtmf_set_timer();                                 /* 038E02             */
    dtmf_state = 3;                                   /* 038E06 FFAC0A      */
}

/* ==========================================================================
 * 038E0E-038E84  size 118  dtmf_gap_step   (sub_38E0E)
 * Confidence: Confirmed (control flow); Inferred (er0 meaning).
 * Callers: none static (state-table handler; er0 = caller's record ptr).
 * After the inter-digit gap: if another digit is queued, play it.  When
 * the queue is empty, unless er0->[1] == 0x2C (screen id, Inferred: the
 * DTMF entry screen), set FF958F = 10 (hold-off), state 5, stop the tone,
 * post 0xFE when digital and, for a manual key (AC09.b1) stop there; a
 * memory string (or screen 0x2C) finishes via dtmf_finish.
 * ========================================================================== */
void dtmf_gap_step(const u8 *er0)
{
    if (dtmf_tone_timer != 0) return;                 /* 038E0E             */
    if (!(dtmf_flags & 0x40)) return;                 /* 038E14 AC09.b6     */
    if (dtmf_next_digit() >= 0) return;               /* 038E1C bpl -> ret  */
    if (er0[1] != 0x2C) {                             /* 038E22             */
        dtmf_holdoff = 10;                            /* 038E2C FF958F      */
        dtmf_state = 5;                               /* 038E32             */
        dtmf_tone_stop();                             /* 038E36             */
        if (band_dtmf_via_dsp()) dsp_dtmf_code = 0xFE;/* 038E74             */
        if (dtmf_flags & 0x02) return;                /* 038E78 manual key  */
    }
    dtmf_finish();                                    /* 038E80 bsr 38E84   */
}

/* ==========================================================================
 * 038E84-038F00  size 124  dtmf_finish   (sub_38E84)
 * Confidence: Confirmed (flow); Inferred (A9E3 bit roles).
 * Callers: sub_38E0E, sub_38FA8.
 * Ends a DTMF transmission: dtmf_reset, then asks the audio machine to drop
 * the route (A9E3: clear b0 and b3, set b7 = event).  While transmitting
 * (FF94C0 != 0): if the PTT is not latched by a keyer (AAD2.b1 clear) and
 * the PTT debounce state FFA9EA == 2 (key still held), flag AAD1.b1 and set
 * FF9546 = 5 (Inferred: delayed TX end); otherwise end TX via sub_22718.
 * Requests a redraw.  The band_dtmf predicate is evaluated and ignored
 * (bne to the next instruction, 038EBA).
 * ========================================================================== */
void dtmf_finish(void)
{
    dtmf_reset();                                     /* 038E84 bsr 38F00   */
    (void)band_dtmf_via_dsp();                        /* 038E86..038EBA dead*/
    audio_req &= ~0x01;                               /* 038EBC A9E3.b0     */
    audio_req |=  0x80;                               /* 038EC2 A9E3.b7     */
    audio_req &= ~0x08;                               /* 038EC8 A9E3.b3     */
    if (tx_state != 0) {                              /* 038ECE FF94C0      */
        if (!(ptt_misc & 0x02) && ptt_state == 2) {   /* 038ED6 / 038EDE    */
            flags_AAD1 |= 0x02;                       /* 038EE6             */
            tx_end_delay = 5;                         /* 038EEC FF9546      */
        } else {
            tx_end_path();                            /* 038EF4 sub_22718   */
        }
    }
    ui_refresh_flags |= 0x02;                         /* 038EF8 817E.b1     */
}

/* ==========================================================================
 * 038F00-038F3C  size 60   dtmf_reset         (sub_38F00)
 * 038F3C-038F7C  size 64   dtmf_reset_quiet   (sub_38F3C, second entry)
 * Confidence: Confirmed.  Callers: sub_34FF4, sub_38E84 / sub_ED16 (boot).
 * Stops the tone.  In a digital band mode dtmf_reset also clears
 * 8173.b1, calls sub_37A1E (DSP mode refresh, Inferred) and posts 0xFF
 * (idle) to the DSP mailbox.  Both entries then clear the sender (flags,
 * state, indices), set the digit counter to 0xFF and fill the ring with
 * 0xFF (pre-decrement store loop from FFAC22 down).
 * ========================================================================== */
void dtmf_reset(void)
{
    dtmf_tone_stop();                                 /* 038F00             */
    if (band_dtmf_via_dsp()) {                        /* 038F04..038F38     */
        flags_8173 &= ~0x02;                          /* 038F42             */
        dsp_mode_refresh();                           /* 038F48 sub_37A1E   */
        dsp_dtmf_code = 0xFF;                         /* 038F4C             */
    }
    dtmf_clear_queue();                               /* 038F52             */
}
void dtmf_reset_quiet(void)                           /* 038F3C             */
{
    dtmf_tone_stop();
    dtmf_clear_queue();
}
static void dtmf_clear_queue(void)                    /* 038F52..038F7A     */
{
    dtmf_flags = 0; dtmf_state = 0; dtmf_wr = 0; dtmf_rd = 0;
    dtmf_count = 0xFF;                                /* 038F66 FFAC07      */
    for (int i = 20; i; --i) dtmf_queue[i - 1] = 0xFF;
}

/* ==========================================================================
 * 038F7C-038FA8  size 44   dtmf_start_pause   (sub_38F7C)
 * Confidence: Confirmed (flow).  Callers: none static (state handler).
 * If AAE1.b0 clear, FFBBC7 == 0 and the timer is idle: arm the timer, set
 * current code 0x10 (pause), redraw, state 3.
 * ========================================================================== */
void dtmf_start_pause(void)
{
    if (audio_route_flags & 0x01) return;             /* 038F7C AAE1.b0     */
    if (busy_BBC7 != 0) return;                       /* 038F84             */
    if (dtmf_tone_timer != 0) return;                 /* 038F8A             */
    dtmf_set_timer();                                 /* 038F90             */
    dtmf_cur = 0x10;                                  /* 038F94             */
    ui_refresh_flags |= 0x02;                         /* 038F9A             */
    dtmf_state = 3;                                   /* 038FA0             */
}

/* ==========================================================================
 * 038FA8-038FC2  size 26   dtmf_poll_end   (sub_38FA8)
 * Confidence: Confirmed.  Callers: none static (state handler).
 * While active, try the next digit; when the queue is empty and the
 * hold-off FF958F has run out, finish.
 * ========================================================================== */
void dtmf_poll_end(void)
{
    if (!(dtmf_flags & 0x40)) return;                 /* 038FA8             */
    if (dtmf_next_digit() >= 0) return;               /* 038FB0             */
    if (dtmf_holdoff != 0) return;                    /* 038FB6 FF958F      */
    dtmf_finish();                                    /* 038FBC             */
}

/* ==========================================================================
 * 038FC2-039002  size 64   dtmf_enqueue_request   (sub_38FC2)
 * Confidence: Confirmed.  Callers: sub_38B9E, sub_38C06 (DTMF key/menu).
 * r2l < 0x50: DTMF memory n = r2l -> dtmf_mem_load (sub_3CE22, EEPROM
 *   0xA80 + 16n -> FFAC24, up to 16 codes, 0xFF-terminated); if the memory
 *   has codes, mark a string send (AC09.b0 set, b1 clear) and queue them.
 *   An empty memory (first byte >= 0x80) takes the 038FF6 path: marked
 *   manual and r3l = r2l itself is queued (quirk; & 0x1F in dtmf_enqueue).
 * r2l >= 0x50: a single key, code r2l - 0x50, marked manual (AC09.b1).
 * ========================================================================== */
void dtmf_enqueue_request(u8 r2l)
{
    if (r2l < 0x50) {                                 /* 038FC6             */
        dtmf_mem_load(r2l);                           /* 038FCA sub_3CE22   */
        const u8 *p = dtmf_mem_buf;                   /* 038FD0 FFAC24      */
        if (*p & 0x80) {                              /* 038FD8 empty mem   */
            dtmf_flags |= 0x02;                       /* 038FF6             */
            dtmf_enqueue(r2l);                        /* 038FFC             */
            return;
        }
        dtmf_flags |=  0x01;                          /* 038FDA             */
        dtmf_flags &= ~0x02;                          /* 038FE0             */
        for (u8 n = 16; n; --n) {                     /* 038FCE r6l = 16    */
            u8 c = *p++;                              /* 038FE6             */
            if (c & 0x80) break;                      /* 038FE8 terminator  */
            dtmf_enqueue(c);                          /* 038FEA             */
        }
    } else {
        dtmf_flags |= 0x02;                           /* 038FF6 manual key  */
        dtmf_enqueue(r2l - 0x50);                     /* 038FF2..038FFC     */
    }
}

/* ==========================================================================
 * 039002-039030  size 46   dtmf_enqueue   (sub_39002)
 * Confidence: Confirmed.  Callers: sub_38FC2.
 * Stores code & 0x1F at the write index unless the ring is full (write ==
 * read and that slot still occupied); advances the write index mod 20.
 * ========================================================================== */
void dtmf_enqueue(u8 code)
{
    code &= 0x1F;                                     /* 039002             */
    u8 w = dtmf_wr;                                   /* 039004 FFAC0C      */
    if (w == dtmf_rd && dtmf_queue[w] != 0xFF) return;/* 039012..03901C     */
    dtmf_queue[w] = code;                             /* 03901E             */
    if (++w == 20) w = 0;                             /* 039022..039028     */
    dtmf_wr = w;                                      /* 03902A             */
}

/* ==========================================================================
 * 039030-039040  size 16   dtmf_tone_stop   (sub_39030)
 * Confidence: Confirmed.  Callers: 38DBA, 38E0E, 38F00, 38F3C.
 * Clears AAD2.b2 (DTMF active), lets sub_351BC stop TPU1 when no CTCSS is
 * running either, and parks DA0 (FFFF68) at mid-scale 0x7F.
 * 039040-039120 is not in this chunk: dtmf_incr_tbl (16 x u32 at 0x039040)
 * and the audio state machine prologue + dispatch table 0x0390FC (doc 73).
 * ========================================================================== */
void dtmf_tone_stop(void)
{
    tone_flags &= ~0x04;                              /* 039030 AAD2.b2     */
    tpu1_tone_stop();                                 /* 039036 sub_351BC   */
    DA0_DADR0 = 0x7F;                                 /* 03903C FFFF68      */
}

/* ######################################################################### *
 * PART 2  -  Audio-route / TX-session state machine handlers               *
 * (doc 73: dispatch table at 0x0390FC indexed by FFA9E5, prologue 0x039080 *
 * outside this chunk; ida/out/usb-status0/state-machine.tsv).  FFA9E3 is  *
 * the request byte: b0 = band-B/dual RX route request, b1 = band-A route,  *
 * mask 0x2C (b2/b3/b5) = TX-path / mute bits, b4 = force session (state 5),*
 * b6 = route latched, b7 = event pending (roles Inferred except b4, 0x2C). *
 * Port FFFF59.b2 = speaker/accessory audio mux (doc 73).                   *
 * ######################################################################### */

/* Shared mux route, inlined 2x: FFBB70 != 0 -> SP SEL (89C5.b1) = CAMERA
 * sets the mux, else the mux = !VBUS (bld 8180.b0 / bist); FFBB70 == 0
 * clears it.                                                              */
static inline void route_speaker_mux(void)
{
    if (usb_accessory_present != 0) {                 /* FFBB70             */
        if (usb_cam_sp_sel & 0x02) P59_DR |= 0x04;    /* SP SEL = CAMERA    */
        else if (usb_vbus_flags & 0x01) P59_DR &= ~0x04;  /* bist = !b0     */
        else P59_DR |= 0x04;
    } else {
        P59_DR &= ~0x04;
    }
}

/* ==========================================================================
 * 039120-039136  size 22   audio_sm_teardown   (sub_39120)  [state 4]
 * Confidence: Confirmed (doc 73).  Callers: sub_393E2, sub_394A8.
 * ========================================================================== */
void audio_sm_teardown(void)
{
    P59_DR &= ~0x04;                                  /* 039120 mux off     */
    audio_rx_route_update();                          /* 039124 sub_391C0   */
    audio_route_flags &= ~0x80;                       /* 039128 AAE1.b7     */
    audio_sm_state = 0;                               /* 039130 FFA9E5      */
}

/* ==========================================================================
 * 039136-039182  size 76   audio_sm_idle   (sub_39136)  [state 0]
 * Confidence: Confirmed (doc 73).  r2l = latched request byte (prologue).
 * Only acts on an event (b7).  With no band request (b0/b1 clear) it needs
 * a TX-path bit (0x2C): then clear AAE1.b7 and route the mux.  Recompute
 * byte 0, arm FF953B = 2 and go to state 1.
 * ========================================================================== */
void audio_sm_idle(u8 req)
{
    if (!(req & 0x80)) return;                        /* 039136             */
    if ((req & 0x03) == 0) {                          /* 03913A             */
        if ((audio_req & 0x2C) == 0) return;          /* 03913E             */
        audio_route_flags &= ~0x80;                   /* 039146             */
        route_speaker_mux();                          /* 03914C..03916E     */
    }
    audio_rx_route_update();                          /* 039172             */
    audio_sm_timer = 2;                               /* 039176 FF953B      */
    audio_sm_state = 1;                               /* 03917C             */
}

/* ==========================================================================
 * 039184-0391C0  size 60   audio_sm_route   (sub_39184)  [states 1 and 2]
 * Confidence: Confirmed (doc 73).  State 1 waits for FF953B == 0, then
 * becomes state 2; state 2 enters at 039190.  Sets AAE1.b7 (route held),
 * routes the mux and recomputes byte 0.
 * ========================================================================== */
void audio_sm_route(void)
{
    if (audio_sm_timer != 0) return;                  /* 039184             */
    audio_sm_state = 2;                               /* 03918A             */
/* state 2 entry, 039190: */
    audio_route_flags |= 0x80;                        /* 039190 AAE1.b7     */
    route_speaker_mux();                              /* 039196..0391B8     */
    audio_rx_route_update();                          /* 0391BC             */
}

/* ==========================================================================
 * 0391C0-0393E2  size 546  audio_rx_route_update   (sub_391C0)
 * Confidence: Confirmed (flow; decodes doc 73 Open #1); Inferred (names
 * of the squelch helpers and override bits).
 * Callers: 39120, 39136, 39184, 393E2.
 * Recomputes the per-band "RX audio active" flags FFA9AC (band A) and
 * FFA9AD (band B / dual side), then USB EP3 report byte 0 FF8184
 * (1 = audio path free for the accessory).
 *   sq_open_A = sub_1E80A, sq_open_B = sub_1E7C2: squelch/busy queries,
 *     r4l != 0 = open (Inferred).  AA38.b1/b0 = forced open (monitor, Inf.).
 *   AA35.b4/b3 = per-band inhibit.  BAD6 == 1 with 89D1 in {1,2} (A) or
 *   {0,2} (B) also counts as active (Inferred: digital audio via DSP).
 *   FF8EA6 b0/b1 (positive, non-zero) = dual-receive in use; BC6F = USB
 *   audio claimed (sub_3373E sets it, sub_33762 clears it).
 * ========================================================================== */
static u8 rx_active(u8 req_bit, u8 inhibit_bit, u8 mon_bit, u8 (*sq)(void),
                    u8 want_89D1)
{
    if (!(audio_req & req_bit)) return 0;             /* 0391C8             */
    if (flags_AA35 & inhibit_bit) return 0;           /* 0391D0             */
    u8 open = sq();                                   /* 0391D8             */
    if (flags_AA38 & mon_bit) return 0xFF;            /* 0391DC             */
    if (open) return 0xFF;                            /* 0391E4             */
    if (dig_audio_BAD6 == 1 && (set_89D1 == 2 || set_89D1 == want_89D1))
        return 0xFF;                                  /* 0391E8..0391FA     */
    return 0;
}

void audio_rx_route_update(void)
{
    if (band_sel & 0x80) {                            /* 0391C0 8EA0.b7     */
        rxA_audio_active = rx_active(0x02, 0x10, 0x02, sq_open_A, 1); /*A9AC*/
    } else if (band_sel & 0x40) {                     /* 03920C 8EA0.b6     */
        rxA_audio_active = rx_active(0x02, 0x10, 0x02, sq_open_A, 1);
        goto decide;                                  /* 039256             */
    }
    /* 03925A: band-B / dual half, keyed by FF8EA6 */
    {
        u8 m = band_slot_chk;                         /* FF8EA6             */
        if (m != 0 && !(m & 0x80) && (m & 0x03)) {    /* 03925E..039268     */
            flags_BB8F |= 0x40;                       /* 03926A             */
            rxB_audio_active = 0;                     /* 039272 FFA9AD      */
            if (audio_req & 0x01) {                   /* 039276             */
                u8 open = (flags_AA38 & 0x01) ? 1 : sq_open_B();
                if (open || (dig_audio_BAD6 == 1 &&
                             (set_89D1 == 2 || set_89D1 == 0))) {
                    usb_aud_release();                /* 03928E sub_33762   */
                    goto decide;
                }
            }
            if (!(audio_req & 0x20)) {                /* 0392AA A9E3.b5     */
                audio_req &= ~0x40;                   /* 0392B2             */
                usb_aud_claim();                      /* 0392B8 sub_3373E   */
            } else {
                audio_req |= 0x40;                    /* 0392C0             */
                usb_aud_stop();                       /* 0392C6 sub_33136   */
            }
            goto decide;
        }
        if (m & 0x80) usb_aud_claim();                /* 0392CE             */
        flags_BB8F &= ~0x40;                          /* 0392D2             */
        if (node_mode != 0 && link_B3E0 != 0 &&       /* 0392D8 FF8DDE      */
            (flags_8DE0 & 0x80) && (link_B3D8 & 0x80) && (flags_8DE0 & 0x40)) {
            if (audio_req & 0x01) {                   /* 0392FC             */
                node_audio_hook();                    /* 039304 sub_6CFF8   */
                rxB_audio_active = 0xFF;
            } else rxB_audio_active = 0;
            goto decide;
        }
        rxB_audio_active = rx_active(0x01, 0x08, 0x01, sq_open_B, 0); /* 039318 */
    }
decide:                                               /* 03935A             */
    {
        u8 r3;
        if (usb_cam_sp_sel & 0x02) r3 = 1;            /* SP SEL = CAMERA    */
        else if (audio_req & 0x2C) r3 = 0;            /* TX path busy       */
        else {
            r3 = 1;
            u8 m = band_slot_chk;
            int dual = (m != 0 && !(m & 0x80) && (m & 0x03));
            if (band_sel & 0x80) {                    /* 039374             */
                if (dual ? (usb_aud_BC6F == 0) : (rxB_audio_active != 0))
                    r3 = 0;
                if (r3 && rxA_audio_active) r3 = 0;   /* 0393A0             */
            } else if (band_sel & 0x40) {             /* 0393AA             */
                if (rxA_audio_active) r3 = 0;
            } else {                                  /* 0393BC             */
                if (dual ? (usb_aud_BC6F == 0) : (rxB_audio_active != 0))
                    r3 = 0;
            }
        }
        usb_ep3_status0 = r3;                         /* 0393DC FF8184      */
    }
}

/* ==========================================================================
 * 0393E2-03941A  size 56   audio_sm_hold   (sub_393E2)  [state 3]
 * Confidence: Confirmed (doc 73).
 * On a new event with b0 set (and FF953C expired): drop the mux, recompute
 * and go back to state 1 (FF953B = 0).  Otherwise, once FF953C has
 * expired: TX-path bits still set -> state 1, else tear down (state 4).
 * ========================================================================== */
void audio_sm_hold(u8 req)
{
    if (req & 0x80) {                                 /* 0393E2             */
        if (audio_sm_timer2 != 0) return;             /* 0393E6 FF953C      */
        if (req & 0x01) {                             /* 0393EC             */
            P59_DR &= ~0x04;                          /* 039404             */
            audio_rx_route_update();                  /* 039408             */
            goto to_state1;
        }
    }
    if (audio_sm_timer2 != 0) return;                 /* 0393F0             */
    if ((audio_req & 0x2C) == 0) { audio_sm_teardown(); return; } /* 0393FE */
to_state1:
    audio_sm_timer = 0;                               /* 03940E FF953B      */
    audio_sm_state = 1;                               /* 039414             */
}

/* ==========================================================================
 * 03941A-039454  size 58   audio_sm_rx_release   (sub_3941A)
 * Confidence: Confirmed (flow); doc 93 lists the call at 0x039436.
 * Callers: sub_2D4A4, sub_2E0DE, sub_33D54.
 * On A9E3.b0: clear it and FFA9AD, arm FF953C = 5 (hold), FF956D = 2
 * (post-retune settle, doc 93) and FF8F70 = 2, request redraw bits
 * (817E.b2, 817F.b1) and go to state 3.
 * ========================================================================== */
void audio_sm_rx_release(void)
{
    if (!(audio_req & 0x01)) return;                  /* 03941A             */
    audio_req &= ~0x01;                               /* 039422             */
    rxB_audio_active = 0;                             /* 03942A             */
    audio_sm_timer2 = 5;                              /* 039430 FF953C      */
    settle_timer = 2;                                 /* 039436 FF956D      */
    cell_8F70 = 2;                                    /* 03943C             */
    ui_refresh_flags |= 0x04;                         /* 039440 817E.b2     */
    ui_flags_817F |= 0x02;                            /* 039446 817F.b1     */
    audio_sm_state = 3;                               /* 03944E             */
}

/* ==========================================================================
 * 039454-03948E  size 58   audio_sm_session_start   (sub_39454)  [state 5]
 * Confidence: Confirmed (doc 73).
 * ========================================================================== */
void audio_sm_session_start(void)
{
    audio_req &= ~0x10;                               /* 039454 A9E3.b4     */
    audio_route_flags &= ~0x80;                       /* 03945A             */
    usb_ep3_status0 = 1;                              /* 039462 FF8184 = 1  */
    P59_DR |= 0x04;                                   /* 039466 mux on      */
    rxB_audio_active = 0; rxA_audio_active = 0;       /* 03946C / 039470    */
    if (flags_AA37 & 0x02) usb_aud_claim();           /* 039474 sub_3373E   */
    audio_sm_timer = 2;                               /* 039482             */
    audio_sm_state = 6;                               /* 039488             */
}

/* ==========================================================================
 * 03948E-0394A8  size 26   audio_sm_session_wait   (sub_3948E)  [6 and 7]
 * Confidence: Confirmed (doc 73).  State 6 waits FF953B and writes 7; the
 * state-7 entry (03949A) sets AAE1.b7 and moves to state 8.
 * ========================================================================== */
void audio_sm_session_wait(void)
{
    if (audio_sm_timer != 0) return;                  /* 03948E             */
    audio_sm_state = 7;                               /* 039494             */
    audio_route_flags |= 0x80;                        /* 03949A (state 7)   */
    audio_sm_state = 8;                               /* 0394A0             */
}

/* 0394A8-0394B4 size 12  audio_sm_session_end (sub_394A8) [state 8]
 * Confirmed (doc 73): waits for the tone/event sequencer FFAAE8 to idle.  */
void audio_sm_session_end(void) { if (tone_seq == 0) audio_sm_teardown(); }

/* ######################################################################### *
 * PART 3  -  Serial-EEPROM (device A0/A1) block wrappers, 0394B4..03A120   *
 *                                                                           *
 * Driver ABI (doc 25/32/96; Confirmed here):                               *
 *   eeprom_read  (sub_3AB80): er0 = EEPROM address, er1 = RAM dst,        *
 *                             r6 = byte count.                             *
 *   eeprom_write (sub_3AD20): same registers, RAM src.                     *
 * Most wrappers are "stm er0-er3; bsr <args>; jsr read|write; ldm; rts";   *
 * written here as one-liners.  The <args> helpers only load r6/er0/er1.    *
 * ######################################################################### */

/* 0394B4-0394D2 size 30  eeprom_load_FF8002 (sub_394B4)  Confirmed.
 * Caller: boot sub_20EA.  EEPROM 0xFFFE (1 byte) -> FF8002.               */
void eeprom_load_FF8002(void)  { eeprom_read(0xFFFE, &pwr_state_8002, 1); }

/* 0394D2-0394F4 size 34  eeprom_save_FF8002 (sub_394D2)  Confirmed.
 * Callers: nmi_handler, sub_39CE0.  FF8002 = r4l, then EEPROM 0xFFFE.
 * Saved from the NMI (power-fail) path: a "last state" byte (Inferred).   */
void eeprom_save_FF8002(u8 v)  { pwr_state_8002 = v; eeprom_write(0xFFFE, &pwr_state_8002, 1); }

/* 0394F4-039504 size 16  eeprom_load_marker (sub_394F4) Confirmed (doc 96).
 * Callers sub_747DE, sub_74DCA, sub_DD5C.  EEPROM 0x10 (4 bytes, boot
 * marker "TAIS"/"MARU") -> FF8006.                                         */
void eeprom_load_marker(void)  { eeprom_read(0x10, boot_marker, 4); }

/* 039504-039512 size 14  eeprom_mark_valid (sub_39504)  Confirmed (doc 96).
 * FF8006 = ROM 0xDD0E ("TAIS"), then falls into eeprom_save_marker.       */
void eeprom_mark_valid(void)
{
    *(u32 *)boot_marker = *(const u32 *)0x00DD0E;     /* 039504 "TAIS"      */
    eeprom_save_marker();                             /* falls into 039512  */
}
/* 039512-039522 size 16  eeprom_save_marker (sub_39512)  Confirmed.       */
void eeprom_save_marker(void)  { eeprom_write(0x10, boot_marker, 4); }
/* 039522-039534 size 18  eeprom_args_marker (sub_39522): r6 = 4,
 * er0 = 0x10, er1 = FF8006.  Confirmed.                                   */

/* 039534-039544 size 16  eeprom_load_region (sub_39534)  Confirmed (doc 96).
 * EEPROM 0x20..0x27 -> FF800E..FF8015 (market bytes FF800F/10/11).        */
void eeprom_load_region(void)  { eeprom_read(0x20, region_blk, 8); }
/* 039544-039554 size 16  eeprom_save_region (sub_39544)  Confirmed.       */
void eeprom_save_region(void)  { eeprom_write(0x20, region_blk, 8); }
/* 039554-039566 size 18  eeprom_args_region (sub_39554): r6 = 8,
 * er0 = 0x20, er1 = FF800E.  Confirmed (doc 96).                          */

/* 039566-039576 size 16  eeprom_load_cfgimg (sub_39566)  Confirmed (doc 96).
 * EEPROM 0x40..0x13F (0x100) -> FF8016: alignment/calibration image
 * (FF8016 / FF8096 / FF80C6 blocks, doc 137) with 0x9669 check words.     */
void eeprom_load_cfgimg(void)  { eeprom_read(0x40, cfg_image, 0x100); }
/* 039576-039586 size 16  eeprom_save_cfgimg (sub_39576)  Confirmed.       */
void eeprom_save_cfgimg(void)  { eeprom_write(0x40, cfg_image, 0x100); }
/* 039586-039598 size 18  eeprom_args_cfgimg (sub_39586): r6 = 0x100,
 * er0 = 0x40, er1 = FF8016.  Confirmed.                                   */

/* 039598-0395A8 size 16  eeprom_load_R1 (sub_39598)  Confirmed (doc 32).
 * EEPROM 0x580..0x6FF (0x180) -> settings region R1 at FF8920.            */
void eeprom_load_R1(void)      { eeprom_read(0x580, settings_R1, 0x180); }
/* 0395A8-0395B8 size 16  eeprom_save_R1 (sub_395A8)  Confirmed (doc 32).  */
void eeprom_save_R1(void)      { eeprom_write(0x580, settings_R1, 0x180); }
/* 0395B8-0395CA size 18  eeprom_args_R1 (sub_395B8): r6 = 0x180,
 * er0 = 0x580, er1 = FF8920.  Confirmed (doc 32).                         */

/* ==========================================================================
 * Mirrored working blocks (Confirmed by this lane).  Four RAM blocks are
 * kept in EEPROM twice, with a byte-sum checksum in the last byte
 * (sum of bytes [0, n-1) stored at [n-1]):
 *   blk  RAM      len   primary  backup   shadow (last saved)  BCAA bit
 *   0    FF8EA0   0x40  0x700    0x740    FFBCB6               b0
 *   1    FF8EE0   0x80  0x780    0x800    FFBCF6               b1
 *   2    FF8FE8   0x80  0x880    0x900    FFBD76               b2
 *   3    FF90F0   0x80  0x980    0xA00    FFBDF6               b3
 * FF8EA0 starts the band/VFO state block (band_sel etc.), FF90F0 is the
 * band-B working record (doc 35).  FFBCAA bit n = "backup n invalid".
 * AA31.b5 = shadows valid (autosave armed).  eeprom_write_pages (3B43C)
 * writes e6 64-byte pages; the flushes use eeprom_write_page64 (3B770)
 * and eeprom_write_burst (3BA90, r6 = 0x80) for the backup copy only.
 * Every block is processed by the same inlined code in ROM.
 * ========================================================================== */
static u8 blk_checksum(u8 *p, u16 n)                  /* inlined ~30 times  */
{
    u8 s = 0;
    for (u16 i = 0; i < n - 1; i++) s += p[i];        /* r4l = n-1 loop     */
    p[n - 1] = s;                                     /* mov.b r3l,@er5     */
    return s;
}
static int blk_equal(const u32 *a, const u32 *b, u16 nlongs)
{
    while (nlongs--) if (*a++ != *b++) return 0;      /* cmp.l loop         */
    return 1;
}

/* ==========================================================================
 * 0395CA-0395E8  size 30   vfo_blocks_restore   (sub_395CA)
 * Confidence: Confirmed.  Callers: sub_39E22, sub_452AC, sub_754BC,
 * sub_75EB6.  Marks all four backups invalid (BCAA = 0x0F), restores each
 * block, then falls into vfo_blocks_snapshot.
 * ========================================================================== */
void vfo_blocks_restore(void)
{
    vfo_bak_invalid = 0x0F;                           /* 0395CE FFBCAA      */
    vfo_blk0_restore();                               /* 0395D4             */
    vfo_blk1_restore();                               /* 0395D8             */
    vfo_blk2_restore();                               /* 0395DC             */
    vfo_blk3_restore();                               /* 0395E0             */
    vfo_blocks_snapshot();                            /* falls into 0395E8  */
}

/* ==========================================================================
 * 0395E8-039670  size 136  vfo_blocks_snapshot   (sub_395E8)
 * Confidence: Confirmed.  Reads the four primaries into the shadows, then
 * normalises band_sel (FF8EA0): b5 -> clear b5 and b6; b3 -> clear b3 and
 * set b6 (Inferred: a pending band swap applied at load).  Sets AA31.b5.
 * ========================================================================== */
void vfo_blocks_snapshot(void)
{
    eeprom_read(0x700, shadow0, 0x40);                /* 0395EC             */
    eeprom_read(0x780, shadow1, 0x80);                /* 039600             */
    eeprom_read(0x880, shadow2, 0x80);                /* 039614             */
    eeprom_read(0x980, shadow3, 0x80);                /* 039628             */
    if (band_sel & 0x20) band_sel &= ~0x60;           /* 03963C             */
    if (band_sel & 0x08) { band_sel &= ~0x08; band_sel |= 0x40; } /* 039650 */
    flags_AA31 |= 0x20;                               /* 039664             */
}

/* ==========================================================================
 * 039670-03970A  size 154  vfo_blk0_restore  (sub_39670)   Confirmed.
 * 03970A-0397A4  size 154  vfo_blk1_restore  (sub_3970A)   Confirmed.
 * 0397A4-03983E  size 154  vfo_blk2_restore  (sub_397A4)   Confirmed.
 * 03983E-0398D8  size 154  vfo_blk3_restore  (sub_3983E)   Confirmed.
 * Caller: vfo_blocks_restore.  Each: read the BACKUP into the shadow; if
 * its checksum is good, clear the BCAA bit, read the primary into RAM and
 * compare; on a mismatch copy the backup over the primary
 * (eeprom_write_pages) and fall to the final re-read.  A bad backup leaves
 * the BCAA bit set and just loads the primary.  (Blk0: e6 = 1 page;
 * blocks 1-3: e6 = 2 pages.)
 * ========================================================================== */
static void vfo_blk_restore(u32 bak, u32 pri, u8 *shadow, u8 *ram, u16 n,
                            u8 bit, u16 pages)
{
    eeprom_read(bak, shadow, n);                      /* 039670             */
    u8 s = 0;
    for (u16 i = 0; i < n - 1; i++) s += shadow[i];   /* 039684..03969C     */
    if (s == shadow[n - 1]) {                         /* 0396A0             */
        vfo_bak_invalid &= ~bit;                      /* 0396A4             */
        eeprom_read(pri, ram, n);                     /* 0396AA             */
        if (blk_equal((u32 *)ram, (u32 *)shadow, n / 4)) return; /* 0396BE  */
        eeprom_write_pages(pri, shadow, pages);       /* 0396E0             */
    }
    eeprom_read(pri, ram, n);                         /* 0396F4             */
}
void vfo_blk0_restore(void) { vfo_blk_restore(0x740, 0x700, shadow0, (u8 *)0xFF8EA0, 0x40, 0x01, 1); }
void vfo_blk1_restore(void) { vfo_blk_restore(0x800, 0x780, shadow1, (u8 *)0xFF8EE0, 0x80, 0x02, 2); }
void vfo_blk2_restore(void) { vfo_blk_restore(0x900, 0x880, shadow2, (u8 *)0xFF8FE8, 0x80, 0x04, 2); }
void vfo_blk3_restore(void) { vfo_blk_restore(0xA00, 0x980, shadow3, (u8 *)0xFF90F0, 0x80, 0x08, 2); }

/* ==========================================================================
 * 0398D8-039A46  size 366  vfo_blocks_save_all   (sub_398D8)
 * Confidence: Confirmed.  Caller: sub_103F2.
 * Checksums and writes all four blocks to both primary and backup, then
 * sets the RAM marker FF8006 = ROM 0xDD1E ("0000", not saved here) and
 * clears AA31.b5 (shadows stale).
 * ========================================================================== */
static const struct { u32 ee; u8 *ram; u16 n, pg; } vfo_all[8] = {
    {0x700, (u8 *)0xFF8EA0, 0x40, 1}, {0x740, (u8 *)0xFF8EA0, 0x40, 1},
    {0x780, (u8 *)0xFF8EE0, 0x80, 2}, {0x800, (u8 *)0xFF8EE0, 0x80, 2},
    {0x880, (u8 *)0xFF8FE8, 0x80, 2}, {0x900, (u8 *)0xFF8FE8, 0x80, 2},
    {0x980, (u8 *)0xFF90F0, 0x80, 2}, {0xA00, (u8 *)0xFF90F0, 0x80, 2} };

void vfo_blocks_save_all(void)
{
    for (int i = 0; i < 8; i++) {                     /* unrolled in ROM    */
        blk_checksum(vfo_all[i].ram, vfo_all[i].n);
        eeprom_write_pages(vfo_all[i].ee, vfo_all[i].ram, vfo_all[i].pg);
    }
    *(u32 *)boot_marker = *(const u32 *)0x00DD1E;     /* 039A2C "0000"      */
    flags_AA31 &= ~0x20;                              /* 039A3A             */
}

/* ==========================================================================
 * 039A46-039BA0  size 346  vfo_blocks_write_all   (sub_39A46)
 * Confidence: Confirmed.  Callers: sub_1F2DE, sub_21DAC.
 * The same eight checksum+write pairs as 0398D8, leaving FF8006 and
 * AA31 untouched.
 * ========================================================================== */
void vfo_blocks_write_all(void)
{
    for (int i = 0; i < 8; i++) {
        blk_checksum(vfo_all[i].ram, vfo_all[i].n);
        eeprom_write_pages(vfo_all[i].ee, vfo_all[i].ram, vfo_all[i].pg);
    }
}

/* ==========================================================================
 * 039BA0-039CCA  size 298  vfo_blocks_flush_powerfail   (sub_39BA0)
 * 039CCA-039CE0  size 22   vfo_blocks_flush_done        (sub_39CCA)
 * Confidence: Confirmed.  Callers: nmi_handler, sub_2070 / sub_2648.
 * If the shadows are valid, every block that differs from its shadow is
 * checksummed and written to its BACKUP copy only.  The tail (039CCA, also
 * called alone) sets FF8006 = "0000" in RAM and clears AA31.b5.
 * Reached from the NMI handler: this is the power-fail save.
 * ========================================================================== */
void vfo_blocks_flush(void);
void vfo_blocks_flush_powerfail(void)
{
    vfo_blocks_flush();                               /* 039BA0..039CC6     */
    vfo_blocks_flush_done();                          /* falls into 039CCA  */
}
void vfo_blocks_flush_done(void)
{
    *(u32 *)boot_marker = *(const u32 *)0x00DD1E;     /* 039CCA "0000"      */
    flags_AA31 &= ~0x20;                              /* 039CD8             */
}

/* ==========================================================================
 * 039CE0-039E22  size 322  vfo_blocks_flush   (sub_39CE0)
 *   second entry 039CE6 (loc_39CE6): vfo_blocks_flush_save8002
 * Confidence: Confirmed.  Callers: sub_754BC; loc_39CE6 from the MEMORY
 * restore (doc pc-02 3).  Diff-and-write-backup for all four blocks; the
 * 039CE6 entry first re-saves FF8002 (eeprom_save_FF8002).
 * ========================================================================== */
void vfo_blocks_flush(void)
{
    if (!(flags_AA31 & 0x20)) return;                 /* 039CF2             */
    if (!blk_equal((u32 *)0xFF8EA0, (u32 *)shadow0, 0x10)) {
        blk_checksum((u8 *)0xFF8EA0, 0x40);
        eeprom_write_page64(0x740, (u8 *)0xFF8EA0);   /* 039D40 sub_3B770   */
    }
    if (!blk_equal((u32 *)0xFF8EE0, (u32 *)shadow1, 0x20)) {
        blk_checksum((u8 *)0xFF8EE0, 0x80);
        eeprom_write_burst(0x800, (u8 *)0xFF8EE0, 0x80);  /* 039D88 3BA90   */
    }
    if (!blk_equal((u32 *)0xFF8FE8, (u32 *)shadow2, 0x20)) {
        blk_checksum((u8 *)0xFF8FE8, 0x80);
        eeprom_write_burst(0x900, (u8 *)0xFF8FE8, 0x80);
    }
    if (!blk_equal((u32 *)0xFF90F0, (u32 *)shadow3, 0x20)) {
        blk_checksum((u8 *)0xFF90F0, 0x80);
        eeprom_write_burst(0xA00, (u8 *)0xFF90F0, 0x80);
    }
}
void vfo_blocks_flush_save8002(void)                  /* 039CE6             */
{
    eeprom_save_FF8002(pwr_state_8002);               /* 039CEA sub_394D2   */
    vfo_blocks_flush();
}

/* ==========================================================================
 * 039E22-039F5A  size 312  vfo_blocks_flush_reload   (sub_39E22)
 * Confidence: Confirmed.  Caller: sub_21958.
 * vfo_blocks_flush body, then vfo_blocks_restore (re-validate + snapshot).
 * ========================================================================== */
void vfo_blocks_flush_reload(void) { vfo_blocks_flush(); vfo_blocks_restore(); }

/* ==========================================================================
 * 039F5A-03A028  size 206  vfo_blocks_force_backup   (sub_39F5A)
 * Confidence: Confirmed.  Caller: sub_75EB6 (BACKUP.dat apply hook).
 * If shadows valid: blk0 is written to its backup only if changed; blocks
 * 1-3 are checksummed and written to their backups unconditionally.
 * ========================================================================== */
void vfo_blocks_force_backup(void)
{
    if (!(flags_AA31 & 0x20)) return;                 /* 039F5E             */
    if (!blk_equal((u32 *)0xFF8EA0, (u32 *)shadow0, 0x10)) {
        blk_checksum((u8 *)0xFF8EA0, 0x40);
        eeprom_write_page64(0x740, (u8 *)0xFF8EA0);
    }
    blk_checksum((u8 *)0xFF8EE0, 0x80); eeprom_write_burst(0x800, (u8 *)0xFF8EE0, 0x80);
    blk_checksum((u8 *)0xFF8FE8, 0x80); eeprom_write_burst(0x900, (u8 *)0xFF8FE8, 0x80);
    blk_checksum((u8 *)0xFF90F0, 0x80); eeprom_write_burst(0xA00, (u8 *)0xFF90F0, 0x80);
}

/* 03A028-03A034 size 12  eeprom_save_id_block (sub_3A028)  Confirmed
 * (doc pc-02 2: ID block at EEPROM 0x360).  er1/r6 come from the caller
 * sub_74562; only the address is fixed here.                               */
void eeprom_save_id_block(const u8 *src, u16 n) { eeprom_write(0x360, src, n); }

/* ==========================================================================
 * 03A034-03A120  size 236  vfo_blocks_flush_123   (sub_3A034)
 * Confidence: Confirmed.  Caller: sub_10556.
 * vfo_blocks_flush for blocks 1..3 only (block 0, band_sel, is skipped).
 * ========================================================================== */
void vfo_blocks_flush_123(void)
{
    if (!(flags_AA31 & 0x20)) return;                 /* 03A038             */
    if (!blk_equal((u32 *)0xFF8EE0, (u32 *)shadow1, 0x20)) {
        blk_checksum((u8 *)0xFF8EE0, 0x80); eeprom_write_burst(0x800, (u8 *)0xFF8EE0, 0x80);
    }
    if (!blk_equal((u32 *)0xFF8FE8, (u32 *)shadow2, 0x20)) {
        blk_checksum((u8 *)0xFF8FE8, 0x80); eeprom_write_burst(0x900, (u8 *)0xFF8FE8, 0x80);
    }
    if (!blk_equal((u32 *)0xFF90F0, (u32 *)shadow3, 0x20)) {
        blk_checksum((u8 *)0xFF90F0, 0x80); eeprom_write_burst(0xA00, (u8 *)0xFF90F0, 0x80);
    }
}
