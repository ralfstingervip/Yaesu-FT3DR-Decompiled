/* ============================================================================
 * main-038CB4-03F1C4.c  -  Hand-reconstructed C for MAIN 0x038CB4..0x03F1C4
 * Wave C, lane main-038CB4-03F1C4.  286 functions, address order.
 *
 * DOCUMENTATION ONLY.  By-hand transcription of the H8SX disassembly
 * (IDA listing rebuilt by decomp/tools/build_listings.py), big-endian,
 * base 0.  Nothing compiled or run.  Comment addresses are instruction
 * addresses.  Doc cross-references are docs/deep/<n>-*.md.
 *
 * ABI: args er0/er1/er2 (+ r3/r6/e6 for the EEPROM helpers, whose fixed
 * ABI is er0 = EEPROM address, er1 = RAM buffer, r6 = count); results in
 * r4l / CCR (many predicates return Z).  Small "args" helpers that only
 * load er0/er1/r6 are folded into the callers.
 *
 * Contents:
 *   PART 1  DTMF sender                         038CB4-039030
 *   PART 2  audio-route state machine (doc 73)  039120-0394B2
 *   PART 3  EEPROM wrappers, mirrored blocks    0394B4-03A120
 *   PART 4  memory-store accessors              03A120-03AB80
 *   PART 5  bit-banged I2C EEPROM drivers       03AB80-03CCBC
 *   PART 6  settings writers, special areas,
 *           device-A2 stores, DG-ID cache       03CCBC-03DF86
 *   PART 7  S-meter, UI timers, RTC, standby,
 *           market/cal/tone helpers, stepping   03DF86-03F1C4
 * Globals: see globals.tsv (address, name, width, meaning, evidence).
 * ========================================================================== */
#include <stdint.h>
#include <string.h>
typedef uint8_t u8; typedef uint16_t u16; typedef uint32_t u32;
typedef int8_t s8;  typedef int16_t s16;  typedef int32_t s32;

/* ---- RAM / IO cells (address in comment; see globals.tsv) ------------- */
extern u8  pwr_state_8002;          /* FF8002 */
extern u8  boot_marker[4];          /* FF8006 */
extern u8  boot_marker2[4];         /* FF800A */
extern u8  region_blk[8];           /* FF800E (market = FF800F) */
extern u8  market;                  /* FF800F */
extern u8  cfg_image[0x100];        /* FF8016 */
extern u8  io_ddr_shadow;           /* FF816E */
extern u8  ui_refresh_flags;        /* FF817E b0 side B, b1 redraw, b2 S-meter restart */
extern u8  ui_flags_817F;           /* FF817F */
extern u8  usb_vbus_flags;          /* FF8180 */
extern u8  usb_ep3_status0;         /* FF8184 */
extern u8  mem_attr[0x540];         /* FF8188 */
extern u8 *bandA_rec;               /* FF812A */
extern u8 *bandA_rec_store;         /* FF8122 */
extern const u8 *cal_ptr_A, *cal_ptr_B;  /* FF8162 / FF8166 */
extern u8  flags_8173;              /* FF8173 */
extern u16 u16tab_A[0x64], u16tab_B[0x64], u16tab_C[0x64]; /* FF86C8 FF8790 FF8858 */
extern u8  settings_R1[0x180];      /* FF8920 */
extern u8  settings_R2[0x280];      /* FF8AA0 */
extern u8  settings_R3[0x180];      /* FF8D20 */
extern u8  bandA_comm_mode;         /* FF8D20 */
extern u8  bandB_comm_mode;         /* FF8DD5 */
extern u8  node_mode;               /* FF8DDE */
extern u8  flags_8DE0;              /* FF8DE0 */
extern u8  band_sel;                /* FF8EA0 */
extern u8  band_slot_chk;           /* FF8EA6 */
extern u8  bandA_dig_mode, bandB_dig_mode;   /* FF8EB6 / FF8EC5 */
extern u8  dgid_A_hi, dgid_A_lo, dgid_B_hi, dgid_B_lo; /* FF8ED6..FF8ED9 */
extern u8  rtc_status_save;         /* FF8EDE */
extern u8  cell_8F70;               /* FF8F70 */
extern u8  set_89A4, set_89AA, set_89BE, set_89C1, set_89C2, set_89C4,
           usb_cam_sp_sel /* FF89C5 */, usb_cam_flags_89C5, set_89D1;
extern u16 alarm_hm, off_timer_hm;  /* FF8988 / FF898A */
extern const u8 *bandplan_ptr;      /* FF92C8 */
extern u8  def_ctcss;               /* FF92CC */
extern u8  tx_state;                /* FF94C0 */
extern u16 scan_start;              /* FF94CA */
extern u8  align_state_94FE;        /* FF94FE */
extern u8  audio_sm_timer, audio_sm_timer2;  /* FF953B / FF953C */
extern u8  blink_timer;             /* FF9541 */
extern u8  dtmf_gap_timer, dtmf_tone_timer;  /* FF9544 / FF9545 */
extern u8  tx_end_delay;            /* FF9546 */
extern u8  timer_9549;              /* FF9549 */
extern u8  settle_timer;            /* FF956D */
extern u8  smeter_timer_A;          /* FF956E (B: FF9581) */
extern u8  dtmf_holdoff;            /* FF958F */
extern u8  charge_meas;             /* FF9590 */
extern u16 lamp_timeout;            /* FF95D6 */
extern u16 charge_timeout, charge_step_timer;  /* FF95F4 / FF95F6 */
extern u8  sci_a_alt_ring[0x168];   /* FF95F8 (shared staging) */
extern u8  buf_96F8[0x90];          /* FF96F8 */
extern u8  align_item, align_alt_FF97FF;    /* FF97F8 / FF97FF */
extern u8  rec_C280_buf[0x1C], buf9DB8[0x1E], msg_hdr[0x20], msg_hdr2[0x20];
                                    /* FF9D74 FF9DB8 FF9DE8 FF9E28 */
extern u16 msg_len_out, msg_len_in; /* FF9E04 / FF9E24 */
extern u8  msg_body_in[0xB0], msg_body_out[0xB0], msg_body_cmp[0xB0],
           msg_text_ref[0x80];      /* FF9E48 FF9EF8 FF9FA8 FF9F22 */
extern u8  msg_cmp_diff; extern u16 msg_cmp_len;   /* FFA557 / FFA558 */
extern u8  msg_tail[0x60], msg_tail2[0x60], msg_body_A62C[0x90];
extern u8  bufA7E2[0x1E], bufA800[0x1E];
extern u8  an3_level, an5_level;    /* FFA993 / FFA995 */
extern u8  lamp_A999, lamp_A9A1;    /* FFA999 / FFA9A1 */
extern u8  rxA_audio_active, rxB_audio_active;   /* FFA9AC / FFA9AD */
extern u8  rtc_time[7];             /* FFA9C4 */
extern u8  rtc_alarm[3];            /* FFA9CC */
extern u8  rtc_tmp;                 /* FFA9D4 */
extern u8  rtc_int_hist;            /* FFA9DC */
extern u8  charge_level, charge_full;   /* FFA9DD / FFA9DE */
extern u8  audio_req;               /* FFA9E3 */
extern u8  audio_sm_state;          /* FFA9E5 */
extern u8  lamp_state;              /* FFA9E9 */
extern u8  ptt_state;               /* FFA9EA */
extern u8  scan_dir;                /* FFA9EE */
extern u8  flag_A9F6, blink_ctl, blink_run;  /* FFA9F6 / FFA9F7 / FFA9F8 */
extern u8  screen_mode_A9F9, popup_A9FC;
extern u8  flags_AA30, flags_AA31, flags_AA32, flags_AA33, flags_AA35,
           flags_AA37, flags_AA38;
extern u8  name_tmp[0x12];          /* FFAA56 */
extern u8  name_buf[0x12];          /* FFAA96 */
extern u32 alt_bcd_tmp;             /* FFAA3E */
extern u32 dtmf_phase, dtmf_phase_inc;  /* FFAABA / FFAABE */
extern u8  flags_AAD1, tone_flags /* FFAAD2 */, ptt_misc /* FFAAD2 */;
extern u8  tone_event;              /* FFAAE0 */
extern u8  audio_route_flags;       /* FFAAE1 */
extern u8  tone_seq;                /* FFAAE8 */
extern u8  bt_list[0x8E];           /* FFAAEA */
extern u8  dtmf_count, dtmf_cur, dtmf_flags, dtmf_state, dtmf_rd, dtmf_wr; /* FFAC07..0C */
extern u8  dtmf_queue[20];          /* FFAC0E */
extern u8  dtmf_mem_buf[16];        /* FFAC24 */
extern u8 *vfo_rec_ptr;             /* FFAC72 */
extern u8  pack_buf[0x20];          /* FFAC76 */
extern u8  cmp_buf[0x3A];           /* FFAC9A */
extern u8  attr_tmp, pack_attr_D5, scan_wrapped, pack_attr_D8, pack_attr_D9; /* FFACD4..D9 */
extern u32 alt_rx_freq, alt_tx_freq;    /* FFACDA / FFACDE */
extern u8  area_tab[0x40];          /* FFACE2 */
extern u8  oprec_scratch[0x3A];     /* FFAD22 */
extern u8  flags_AD69;
extern u8  rec1034_buf[0x12], rec_C3A0_buf[0x3C], rec_C4D0_buf[0x43],
           rec_D280_buf[0x5D];      /* FFAD6E FFADA2 FFADDE FFAE22 */
extern u8  rec_B800_buf[8], rec_B8C0_buf[0x12];   /* FFAA10 / FFAA18 */
extern u8  dsp_dtmf_code;           /* FFB0C0 */
extern u8  flags_B057, link_B3D8, link_B3E0;
extern u8  buf_B4A8[0x110], tab24[0x300], buf_B8D8[0x50];
extern u8  group_name[0x10], group_items[0x1E];   /* FFB9F2 / FFBA12 */
extern u8  dig_audio_BAD6, usb_accessory_present /* FFBB70 */, flags_BB8F,
           busy_BBC7, usb_aud_BC6F;
extern u8  vfo_bak_invalid;         /* FFBCAA */
extern u8  shadow0[0x40], shadow1[0x80], shadow2[0x80], shadow3[0x80];
extern u8  timer_A505, timer_B1C4, timer_BA3D, timer_BADB;
extern u8  dgid_hdr[0x48], dgid_mem[0x898];   /* FF4726 / FF476E */
extern u8  buf_4576[0x180];         /* FF4576 */
extern u8  pic_state[0x80];         /* FF2F4A */
extern u8 *cur_rec;                 /* er0 of the caller */
extern const u16 mem_area_base[16]; /* ROM 0x03F1C4 */
extern const u32 dtmf_incr_tbl[16]; /* ROM 0x039040 */
extern const u32 rom_tab_3FFF4[], rom_tab_40362[], rom_tab_401BE[], rom_tab_4020E[];
/* IO ports */
extern volatile u8 P_PORT, P_DR, P_DDR;         /* FFFBA0 / FFFBA4 / FFFBA8 */
extern volatile u8 P_FBA5, P_FB8D;              /* FFFBA5 / FFFB8D */
extern volatile u8 P45_PORT, P4D_PORT, P59_DR, P5A_DR, P5D_DR;  /* FFFF45.. */
extern volatile u8 DA0_DADR0, DA_DADR1, DA_DACR;  /* FFFF68 / 69 / 6A */
extern volatile u16 MSTPCRA, MSTPCRB, MSTPCRC;    /* FFFDC8 / CA / CC */
extern volatile u8 USB_EE04, USB_EE05, USB_EE06, USB_EE2D;

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

/* ######################################################################### *
 * PART 4  -  Memory-area accessors (EEPROM device A0, 0x0180..0xB7FF)      *
 *                                                                           *
 * Layout established by this part (EEPROM device A0/A1 addresses):        *
 *   0x0180 + 0x3A*k  band operating records, side A (k = 0..7), 58 bytes   *
 *   0x0380 + 0x3A*k  same, side B (FF817E.b0 = 1)                          *
 *   0x0F80 + 0x12*n  name blocks of memory area 3 (18 bytes each)          *
 *   0x1200 + 0x20*n  32-byte records, the "0x1200 set" (role Inferred:     *
 *                    home/special channels)                                *
 *   0x1380 + 0x20*b  per-band VFO records, side A (b = working rec +3)     *
 *   0x1500 + 0x20*b  per-band VFO records, side B                          *
 *   0x1680 + 0xC8*i  24 x 0xC8 u16 tables (doc pc-02); RAM FF86C8 (A),     *
 *                    FF8790 (B), FF8858 (third copy)                       *
 *   0x2940 + n       memory attribute byte per slot; RAM mirror FF8188[n]  *
 *   0x2E80 + 0x20*n  1100 channel records (doc pc-02 3.1)                  *
 * FF812A = pointer to the live band-A operating record; FF90F0 = band B    *
 * record; FF817E.b0 = side B (written as SIDE_B); FFAC76 = 32-byte packed  *
 * record buffer (doc 35); FFAC9A = compare buffer; FFAD22 = 0x3A scratch.  *
 * "eepmov.w" = block move of R4 bytes @ER5 -> @ER6 (written as memcpy).    *
 * Memory "area" = vfo_mem_group(rec) (sub_3F1DC): rec[6] == 0 -> 0,        *
 * rec[6] == 1 -> rec[0x10], else rec[0x11]; 0 = regular channel area.      *
 * ######################################################################### */
#define SIDE_B (ui_refresh_flags & 0x01)

/* 03A120-03A130 size 16  eeprom_load_mem_attr (sub_3A120)  Confirmed.
 * EEPROM 0x2940 (0x540 = 1344 slot bytes) -> FF8188.
 * Callers sub_75160, sub_75EB6 (restore apply hooks, doc 96).             */
void eeprom_load_mem_attr(void) { eeprom_read(0x2940, mem_attr, 0x540); }
/* 03A130-03A140 size 16  eeprom_save_mem_attr (sub_3A130)  Confirmed.
 * Caller sub_22128.                                                       */
void eeprom_save_mem_attr(void) { eeprom_write(0x2940, mem_attr, 0x540); }
/* 03A140-03A152 size 18  eeprom_args_mem_attr (sub_3A140): r6 = 0x540,
 * er0 = 0x2940, er1 = FF8188.  Confirmed.                                 */

/* 03A152-03A162 size 16  eeprom_load_u16tab (sub_3A152)  Confirmed.
 * 03A162-03A172 size 16  eeprom_save_u16tab (sub_3A162)  Confirmed.
 * 03A172-03A196 size 36  eeprom_args_u16tab (sub_3A172)  Confirmed.
 * Table i (r1) of the 24 x 0xC8 area at EEPROM 0x1680 + 0xC8*i <-> RAM
 * FF86C8 (side A) or FF8790 (side B).  Meaning: Inferred (doc pc-02:
 * "probably 24 banks x 100 u16 entries").  9 load callers in 0x20xxx.     */
void eeprom_load_u16tab(u16 i) { eeprom_read(0x1680 + 0xC8 * i, SIDE_B ? u16tab_B : u16tab_A, 0xC8); }
void eeprom_save_u16tab(u16 i) { eeprom_write(0x1680 + 0xC8 * i, SIDE_B ? u16tab_B : u16tab_A, 0xC8); }

/* 03A196-03A1A6 size 16  eeprom_load_u16tab_C (sub_3A196)  Confirmed.
 * 03A1A6-03A1BC size 22  eeprom_args_u16tab_C (sub_3A1A6)  Confirmed.
 * Table i -> third RAM copy FF8858 (no side choice).                      */
void eeprom_load_u16tab_C(u16 i) { eeprom_read(0x1680 + 0xC8 * i, u16tab_C, 0xC8); }

/* ==========================================================================
 * 03A1BC-03A200  size 68   u16tab_put     (sub_3A1BC)
 * 03A200-03A22E  size 46   u16tab_C_put   (sub_3A200)
 * Confidence: Confirmed.  Callers: sub_201C2, sub_202FA, sub_20AF6 / 202FA.
 * Write-through store: *er5 = r3, then the same 2 bytes go to EEPROM at
 * 0x1680 + 0xC8*r1 + (er5 - table base).
 * ========================================================================== */
void u16tab_put(u16 i, u16 *slot, u16 v)
{
    *slot = v;                                        /* 03A1C0             */
    u16 *base = SIDE_B ? u16tab_B : u16tab_A;         /* 03A1D4             */
    eeprom_write(0x1680 + 0xC8 * i + ((u8 *)slot - (u8 *)base), slot, 2);
}
void u16tab_C_put(u16 i, u16 *slot, u16 v)
{
    *slot = v;                                        /* 03A204             */
    eeprom_write(0x1680 + 0xC8 * i + ((u8 *)slot - (u8 *)u16tab_C), slot, 2);
}

/* ==========================================================================
 * 03A22E-03A266  size 56   settings_R1_put_word   (sub_3A22E)
 * Confidence: Confirmed.  Callers: sub_201C2, sub_20290, sub_20392, 2053E.
 * word[r1] of the R1 table at FF8A20 (side A) / FF8A68 (side B) = r2, then
 * saved through the R1 range writer (settings_R1_save_range, 2 bytes).
 * ========================================================================== */
void settings_R1_put_word(u16 idx, u16 v)
{
    u16 *p = (SIDE_B ? (u16 *)0xFF8A68 : (u16 *)0xFF8A20) + idx;
    *p = v;                                           /* 03A246 / 03A256    */
    settings_R1_save_range(p, 2);                     /* 03A25C sub_3CCD0   */
}

/* 03A266-03A27C size 22  vfo_rec_load_sideA (sub_3A266)  Confirmed (flow).
 * Caller sub_21420.  Reads per-band VFO record r3l of side A (0x1380 +
 * 0x20*r3l, via the 03A2FA entry) into FFAC76 and unpacks it with
 * sub_3FAD0 (unpack variant, outside this chunk).                          */
void vfo_rec_load_sideA(u8 band) { eeprom_read(0x1380 + 0x20 * band, pack_buf, 0x20); rec_unpack_3FAD0(); }

/* 03A27C-03A29C size 32  vfo_rec_load_for (sub_3A27C)  Confirmed (flow).
 * Callers sub_1F1E2, sub_2511E.  band = er0->[4]; reads the side-selected
 * per-band VFO record and unpacks it (sub_3FB0C, doc 35).                  */
void vfo_rec_load_for(u8 *rec)
{
    u8 band = rec[4];                                 /* 03A280             */
    eeprom_read(vfo_rec_addr(band), pack_buf, 0x20);  /* 03A284 03A30C      */
    rec_unpack(pack_buf);                             /* 03A292 sub_3FB0C   */
}

/* 03A29C-03A2C0 size 36  vfo_rec_load (sub_3A29C)  Confirmed (flow).
 * 9 callers (band change / retune, doc 24).  FFAC72 = er0 (working
 * record); reads the VFO record for band rec[3], unpacks it, then
 * vfo_dgid_load (sub_3DF2E).                                              */
void vfo_rec_load(u8 *rec)
{
    vfo_rec_ptr = rec;                                /* 03A2A0 FFAC72      */
    eeprom_read(vfo_rec_addr(rec[3]), pack_buf, 0x20);/* 03A2A6/03A2A8      */
    rec_unpack(pack_buf);                             /* 03A2B2             */
    vfo_dgid_load(rec);                               /* 03A2BA sub_3DF2E   */
}

/* 03A2C0-03A2D0 size 16  vfo_rec_read_raw (sub_3A2C0)  Confirmed.
 * Caller sub_3FEDC.  Packed record for band r3l -> FFAC76, no unpack.     */
void vfo_rec_read_raw(u8 band) { eeprom_read(vfo_rec_addr(band), pack_buf, 0x20); }

/* ==========================================================================
 * 03A2D0-03A2FA  size 42   vfo_rec_save   (sub_3A2D0)
 * Confidence: Confirmed.  22 callers.
 * Packs the working record (sub_3FD48) into FFAC76, compares with the
 * EEPROM copy and writes only on change, then the per-band DG-ID word
 * (vfo_dgid_save, sub_3DEA8).
 * ========================================================================== */
void vfo_rec_save(u8 *rec)
{
    vfo_rec_ptr = rec;                                /* 03A2D4             */
    rec_pack(pack_buf);                               /* 03A2E0 sub_3FD48   */
    if (vfo_rec_differs(vfo_rec_addr(rec[3])))        /* 03A2E4/03A2E6      */
        eeprom_write(vfo_rec_addr(rec[3]), pack_buf, 0x20);  /* 03A2EC      */
    vfo_dgid_save(rec);                               /* 03A2F4 sub_3DEA8   */
}

/* 03A2FA-03A302 size 8  vfo_rec_addr_sideA (sub_3A2FA): er0 = 0x1380, then
 * the common tail at 03A320.  Confirmed.
 * 03A302-03A334 size 50  vfo_rec_addr (sub_3A302)  Confirmed.
 *   entry 03A302: r3l = [FFAC72]->[3];  entry 03A30C: r3l given.
 *   er0 = (SIDE_B ? 0x1500 : 0x1380) + 0x20*r3l; er1 = FFAC76; r6 = 0x20.  */
u32 vfo_rec_addr(u8 band)
{
    u32 a = SIDE_B ? 0x1500 : 0x1380;                 /* 03A30C/03A31A      */
    return a + 0x20u * band;                          /* 03A320..03A32A     */
}

/* 03A334-03A35E size 42  vfo_rec_differs (sub_3A334)  Confirmed.
 * Reads the EEPROM record at er0 (r6 = 0x20) into FFAC9A and compares 8
 * longs with FFAC76.  Z = equal (callers: beq = skip the write).          */
int vfo_rec_differs(u32 ee)
{
    eeprom_read(ee, cmp_buf, 0x20);                   /* 03A33A FFAC9A      */
    return !blk_equal((u32 *)pack_buf, (u32 *)cmp_buf, 8);
}

/* 03A35E-03A37C size 30  rec1200_load (sub_3A35E)  Confirmed (flow).
 * Callers sub_1C18E, sub_1C1D2, sub_1FFD2, sub_75554.  Record r3 of the
 * 0x1200 set -> FFAC76 -> unpack, then its DG-ID word (sub_3DF0A).        */
void rec1200_load(u16 n)
{
    eeprom_read(0x1200 + 0x20 * (u8)n, pack_buf, 0x20);
    rec_unpack(pack_buf);
    rec1200_dgid_load(n);                             /* 03A376 sub_3DF0A   */
}

/* 03A37C-03A390 size 20  rec1200_save_named (sub_3A37C)  Confirmed (flow).
 * Caller sub_20004.  Pack, mem_name_fetch, then the 03A39E tail of
 * rec1200_save.                                                           */
void rec1200_save_named(u16 n) { rec_pack(pack_buf); mem_name_fetch(); rec1200_save_tail(n); }

/* 03A390-03A3BE size 46  rec1200_save (sub_3A390)  Confirmed.
 * Callers sub_1FFD2, sub_75554, sub_EAB0, sub_EAD2.  Pack, write record n
 * of the 0x1200 set on change, then its DG-ID word (sub_3DE84).           */
void rec1200_save(u16 n) { rec_pack(pack_buf); rec1200_save_tail(n); }
static void rec1200_save_tail(u16 n)                  /* 03A39E             */
{
    if (vfo_rec_differs(0x1200 + 0x20 * (u8)n))       /* 03A3A2             */
        eeprom_write(0x1200 + 0x20 * (u8)n, pack_buf, 0x20);
    rec1200_dgid_save(n);                             /* 03A3B8 sub_3DE84   */
}
/* 03A3BE-03A3D8 size 26  rec1200_addr (sub_3A3BE): er0 = 0x1200 + 0x20*r3l,
 * er1 = FFAC76, r6 = 0x20.  Confirmed.                                    */

/* ==========================================================================
 * 03A3D8-03A40C  size 52   oprec_load_A   (sub_3A3D8)
 * Confidence: Confirmed (flow).  Caller: sub_24D42.
 * Reads operating-record slot r3 (0x3A bytes) into FFAD22, clears
 * 8EA6.b0 (band-A record in use), copies it to [FF812A] with mem_copy
 * (sub_3F36E: eepmov r4l bytes er5 -> er6), then reads 7 bytes of slot 7
 * into FFAC76.
 * ========================================================================== */
void oprec_load_A(u16 k)
{
    eeprom_read(oprec_addr(k), oprec_scratch, 0x3A);  /* 03A3DC/03A3E4      */
    band_slot_chk &= ~0x01;                           /* 03A3E8 8EA6.b0     */
    mem_copy(0x3A, oprec_scratch, bandA_rec);         /* 03A3FC sub_3F36E   */
    eeprom_read(oprec_addr(7), pack_buf, 7);          /* 03A400 03A448      */
}
/* 03A40C-03A432 size 38  oprec_addr_A (sub_3A40C): er1 = [FF812A],
 * er0 = (SIDE_B ? 0x380 : 0x180) + 0x3A*r3, r6 = 0x3A.  Confirmed.        */
u32 oprec_addr(u16 k) { return (SIDE_B ? 0x380 : 0x180) + 0x3Au * k; }

/* 03A432-03A448 size 22  oprec_save_A (sub_3A432)  Confirmed.
 * Caller sub_24A8A.  Writes [FF812A] to slot r3 and 7 bytes of FFAC76 to
 * slot 7.                                                                 */
void oprec_save_A(u16 k)
{
    eeprom_write(oprec_addr(k), bandA_rec, 0x3A);     /* 03A438             */
    eeprom_write(oprec_addr(7), pack_buf, 7);         /* 03A43E             */
}
/* 03A448-03A474 size 44  oprec_args_slot7 (sub_3A448): r3 = 7,
 * er1 = FFAC76, er0 = base + 0x3A*7, r6 = 7.  Confirmed.                  */

/* 03A474-03A47A size 6  oprec_save_live_0 (sub_3A474): r3 = 0 -> 03A4D2.
 * 03A47A-03A480 size 6  oprec_save_live_1 (sub_3A47A): r3 = 1 -> 03A4D2.
 * Confirmed.  9 / 8 callers (TX/RX, band and clone code).                 */
void oprec_save_live_0(void) { oprec_save_live(0); }
void oprec_save_live_1(void) { oprec_save_live(1); }

/* ==========================================================================
 * 03A480-03A4D2  size 82   oprec_load_live   (sub_3A480)
 * Confidence: Confirmed.  Callers: sub_1C178, sub_75554.
 * Reads slot r3 into FFAD22.  Byte +0x39 bit 7 (FFAD5B.b7) marks a band-B
 * record: copy into FF90F0 and set 8EA6.b0; otherwise copy into [FF812A]
 * and, unless band B is selected (8EA0.b6), clear 8EA6.b0.
 * ========================================================================== */
void oprec_load_live(u16 k)
{
    eeprom_read(oprec_live_addr(k), oprec_scratch, 0x3A);  /* 03A484      */
    u8 *dst;
    if (oprec_scratch[0x39] & 0x80) {                 /* 03A490 AD5B.b7     */
        dst = (u8 *)0xFF90F0;  band_slot_chk |= 0x01; /* 03A4AE             */
    } else {
        dst = bandA_rec;                              /* 03A498             */
        if (!(band_sel & 0x40)) band_slot_chk &= ~0x01;
    }
    memcpy(dst, oprec_scratch, 0x3A);                 /* 03A4C4 eepmov.w    */
}

/* 03A4D2-03A4F0 size 30  oprec_save_live (sub_3A4D2)  Confirmed.
 * Caller sub_23914 (and the two stubs).  Writes the live record
 * (live_band_rec = sub_10748, doc 122) to slot r3 only if it differs.     */
void oprec_save_live(u16 k)
{
    if (oprec_live_differs(k))                        /* 03A4DA sub_3A514   */
        eeprom_write(oprec_live_addr(k), live_band_rec(), 0x3A);
}
/* 03A4F0-03A514 size 36  oprec_live_addr (sub_3A4F0): er1 = live record
 * (sub_10748), er0 = (SIDE_B ? 0x380 : 0x180) + 0x3A*r3, r6 = 0x3A.       */
u32 oprec_live_addr(u16 k) { return oprec_addr(k); }

/* 03A514-03A538 size 36  oprec_live_differs (sub_3A514)  Confirmed.
 * Reads the slot into FFAC9A and compares 0x1D words (58 bytes) with the
 * live record (pointer re-fetched from sub_10748).  Z = equal.            */
int oprec_live_differs(u16 k)
{
    eeprom_read(oprec_addr(k), cmp_buf, 0x3A);        /* 03A51A             */
    return memcmp(live_band_rec(), cmp_buf, 0x3A) != 0;
}

/* 03A538-03A562 size 42  oprec_load_pair (sub_3A538)  Confirmed.
 * Caller sub_1D4DA.  Slot 3 -> [FF812A] (band A), slot 4 -> FF90F0 (B).   */
void oprec_load_pair(void)
{
    eeprom_read(oprec_addr(3), bandA_rec, 0x3A);
    eeprom_read(oprec_addr(4), (u8 *)0xFF90F0, 0x3A);
}

/* 03A562-03A5B6 size 84  oprec_save_pair (sub_3A562)  Confirmed (flow).
 * Caller sub_1D40E.  The inverse, each written only when "changed".  The
 * compare helper re-fetches er0 from sub_10748, so both tests compare the
 * slot against the OPERATING band's record, not the record being saved
 * (quirk as coded).                                                        */
void oprec_save_pair(void)
{
    if (oprec_live_differs(3)) eeprom_write(oprec_addr(3), bandA_rec, 0x3A);
    if (oprec_live_differs(4)) eeprom_write(oprec_addr(4), (u8 *)0xFF90F0, 0x3A);
}

/* ==========================================================================
 * 03A5B6-03A5F8  size 66   mem_recall       (sub_3A5B6)
 * 03A5F8-03A632  size 58   mem_recall_any   (sub_3A5F8)
 * Confidence: Confirmed (doc 35, doc 61).  Callers: sub_1C104, sub_1FD74 /
 * sub_1C124.
 * For a regular-area slot (mem_rec_addr returns Z): load the DG-ID word for
 * slot r3 (mem_dgid_load = sub_3DF1C), read the 32-byte record and unpack
 * it.  (A special area is synthesised by mem_rec_alt instead.)  Returns
 * er0 = working record: [FF812A], or FF90F0 when the unpack flagged band B
 * (8EA6.b0) - mem_recall only redirects when side A is edited (817E.b0 = 0).
 * ========================================================================== */
u8 *mem_recall(u16 slot)
{
    if (mem_rec_addr(slot) == 0) {                    /* 03A5BA sub_3A6EE   */
        mem_dgid_load(slot);                          /* 03A5C2 sub_3DF1C   */
        eeprom_read(0x2E80 + 0x20 * slot, pack_buf, 0x20);  /* 03A5C8       */
        rec_unpack(pack_buf);                         /* 03A5D2 sub_3FB0C   */
    }
    u8 *r = bandA_rec;                                /* 03A5DA             */
    if (!SIDE_B && (band_slot_chk & 0x01))            /* 03A5E0 / 03A5E8    */
        r = (u8 *)0xFF90F0;
    return r;
}
u8 *mem_recall_any(u16 slot)                          /* 03A5F8             */
{
    if (mem_rec_addr(slot) == 0) {
        mem_dgid_load(slot);
        eeprom_read(0x2E80 + 0x20 * slot, pack_buf, 0x20);
        rec_unpack(pack_buf);
    }
    return (band_slot_chk & 0x01) ? (u8 *)0xFF90F0 : bandA_rec;  /* 03A622 */
}

/* 03A632-03A666 size 52  mem_read_unpack_alt (sub_3A632)  Confirmed (flow).
 * Callers sub_75160, sub_753D4 (restore converters, doc 96).  Reads channel
 * record r3 into FFAC76, unpacks it with sub_3FAE8 (variant) and returns
 * Z = !(8EA6.b0).                                                          */
int mem_read_unpack_alt(u16 slot)
{
    eeprom_read(0x2E80 + 0x20 * slot, pack_buf, 0x20);   /* 03A64C          */
    rec_unpack_3FAE8(pack_buf);                       /* 03A656             */
    return band_slot_chk & 0x01;                      /* 03A65E             */
}

/* BCD frequency helper, inlined 3x here (03A672, 03A734, 03AAD6) and also
 * present as sub_3FD02: f = packed bytes +2..+5 as a big-endian long with
 * the last byte cleared; at or above 1.8 MHz (top word >= 0x0018) the
 * implied sub-kHz digits are restored: 12/37/62/87 -> +50, 06/31/56/81 ->
 * +25, 18/43/68/93 -> +75 (doc pc-02 3.1).  Result: 8 packed-BCD digits,
 * last digit = 10 Hz (0x14652000 = 146.520.00 MHz).                        */
static u32 rec_freq_bcd(const u8 *rec)
{
    u32 f = ((u32)rec[2] << 24) | ((u32)rec[3] << 16) | ((u32)rec[4] << 8);
    if ((f >> 16) >= 0x18) {
        switch (rec[4]) {
        case 0x12: case 0x37: case 0x62: case 0x87: f |= 0x50; break;
        case 0x06: case 0x31: case 0x56: case 0x81: f |= 0x25; break;
        case 0x18: case 0x43: case 0x68: case 0x93: f |= 0x75; break;
        }
    }
    return f;
}
/* Band-plan lookup inlined 2x: table at [FF92C8] = { u32 count;
 * { u32 lo, hi; u16 id; } rows[count] } (10-byte rows); returns the id of
 * the first row with lo <= f <= hi.  If none matches the loop leaves er6
 * on the row after the last and returns its +8 word (quirk as coded).     */
static u16 bandplan_find(u32 f)
{
    const u8 *t = bandplan_ptr;                       /* FF92C8             */
    u32 n = *(const u32 *)t; t += 4;
    for (;;) {
        if (f >= *(const u32 *)t && *(const u32 *)(t + 4) >= f) break;
        t += 10;
        if (--n == 0) break;
    }
    return *(const u16 *)(t + 8);
}

/* 03A666-03A6EE size 136  mem_band_of_slot (sub_3A666)  Confirmed.
 * Caller sub_32AB8.  Reads record r3 and returns r3 = band-plan id of its
 * RX frequency.                                                           */
u16 mem_band_of_slot(u16 slot)
{
    mem_rec_addr(slot);                               /* 03A66A             */
    eeprom_read(0x2E80 + 0x20 * slot, pack_buf, 0x20);/* 03A66E             */
    return bandplan_find(rec_freq_bcd(pack_buf));     /* 03A672..03A6E8     */
}

/* ==========================================================================
 * 03A6EE-03A71A  size 44   mem_rec_addr   (sub_3A6EE)
 * Confidence: Confirmed.  Callers: 3A5B6, 3A5F8, 3A666, 3A71A.
 * Unless AA31.b4 forces the regular area, a non-zero area of the current
 * record (vfo_mem_group, sub_3F1DC on er0) diverts to mem_rec_alt (03CEFE,
 * by jmp - its own exit returns to our caller with r4l = 1, Z clear).
 * Regular: er0 = 0x2E80 + 0x20*r3, er1 = FFAC76, r6 = 0x20, r4l = 0 (Z).
 * ========================================================================== */
int mem_rec_addr(u16 slot)
{
    if (!(flags_AA31 & 0x10) && vfo_mem_group(cur_rec) != 0)
        return mem_rec_alt(slot, vfo_mem_group(cur_rec)); /* 03A6FC jmp     */
    /* er0 = 0x2E80 + 0x20*slot; er1 = FFAC76; r6 = 0x20 */
    return 0;                                         /* 03A716             */
}

/* 03A71A-03A784 size 106  mem_freq_of_slot (sub_3A71A)  Confirmed.
 * Caller sub_2011C.  Reads the 3 BCD frequency bytes of record r3 into
 * FFAC78 and returns er5 = rec_freq_bcd().                                */
u32 mem_freq_of_slot(u16 slot)
{
    mem_rec_addr(slot);                               /* 03A71E             */
    eeprom_read(0x2E80 + 0x20 * slot + 2, pack_buf + 2, 3);  /* 03A730      */
    return rec_freq_bcd(pack_buf);                    /* 03A734..03A77C     */
}

/* 03A784-03A796 size 18  mem_store_named (sub_3A784)  Confirmed (flow).
 * Caller sub_1FCBA.  Pack, mem_name_fetch, then the 03A7DC tail of
 * mem_store (record + attribute + DG-ID word).                            */
void mem_store_named(u16 slot) { rec_pack(pack_buf); mem_name_fetch(); mem_store_tail(slot); }

/* 03A796-03A7CE size 56  mem_name_fetch (sub_3A796)  Confirmed.
 * Callers 3A37C, 3A784.  Clears AA30.b6, copies packed +6..+0x17 (name
 * attribute word + 16-byte name) to FFAA96, then tests the 8 name words
 * for 0xFFFF.  Z = no name (doc pc-02 3.1).                                */
int mem_name_fetch(void)
{
    flags_AA30 &= ~0x40;                              /* 03A796             */
    memcpy(name_buf, pack_buf + 6, 0x12);             /* 03A7AC eepmov      */
    for (int i = 0; i < 8; i++)                       /* 03A7C0             */
        if (((u16 *)(name_buf + 2))[i] != 0xFFFF) return 0;
    return 1;
}

/* ==========================================================================
 * 03A7CE-03A838  size 106  mem_store   (sub_3A7CE)
 * Confidence: Confirmed (addresses: doc pc-02).
 * Callers: sub_1FD74, sub_2010C, sub_DEFA.
 * Packs the working record, writes it to 0x2E80 + 0x20*r3, rebuilds the
 * slot's attribute byte = (FFACD5 & 0xF3) | (FFACD9 & 0x0C) (two packer
 * scratch bytes; Inferred: header flags), stores it in FF8188[r3] and
 * EEPROM 0x2940 + r3, then the DG-ID word (mem_dgid_save, sub_3DE96).
 * ========================================================================== */
void mem_store(u16 slot) { rec_pack(pack_buf); mem_store_tail(slot); }
static void mem_store_tail(u16 slot)                  /* 03A7DC             */
{
    eeprom_write(0x2E80 + 0x20 * slot, pack_buf, 0x20);    /* 03A7F4        */
    u8 a = (pack_attr_D5 & 0xF3) | (pack_attr_D9 & 0x0C);  /* 03A7FA        */
    mem_attr[slot] = a;                               /* 03A810 FF8188[n]   */
    attr_tmp = a;                                     /* 03A814 FFACD4      */
    eeprom_write(0x2940 + slot, &attr_tmp, 1);        /* 03A82A             */
    mem_dgid_save(slot);                              /* 03A832 sub_3DE96   */
}

/* 03A838-03A892 size 90  mem_store_raw_attr (sub_3A838)  Confirmed.
 * Callers sub_75160, sub_753D4.  As mem_store but attribute = FFACD8 and
 * no DG-ID word write.                                                    */
void mem_store_raw_attr(u16 slot)
{
    rec_pack(pack_buf);
    eeprom_write(0x2E80 + 0x20 * slot, pack_buf, 0x20);
    mem_attr[slot] = attr_tmp = pack_attr_D8;         /* 03A864             */
    eeprom_write(0x2940 + slot, &attr_tmp, 1);
}

/* 03A892-03A8E2 size 80  mem_attr_put (sub_3A892)  Confirmed (flow).
 * Callers sub_16DCA, sub_1FE3A, sub_1FF1C.  r4l = attribute.  In a memory
 * area g != 0: areas 6 and 8 keep no attribute (return); otherwise the
 * slot is rebased by the word table mem_area_base[g] (0x03F1C4).  Store
 * FF8188[slot] = attr and EEPROM 0x2940 + slot.                            */
void mem_attr_put(u16 slot, u8 attr)
{
    u8 g = vfo_mem_group(cur_rec);                    /* 03A898 sub_3F1DC   */
    if (g) {
        if (g == 6 || g == 8) return;                 /* 03A89E / 03A8A2    */
        slot += mem_area_base[g];                     /* 03A8AE 0x03F1C4    */
    }
    mem_attr[slot] = attr; attr_tmp = attr;           /* 03A8BE / 03A8C2    */
    eeprom_write(0x2940 + slot, &attr_tmp, 1);        /* 03A8D8             */
}

/* 03A8E2-03A906 size 36  rec1200_name_store (sub_3A8E2)  Confirmed.
 * Caller sub_19516.  Name block (0x12 bytes at er0+0x22) -> FFAA56 ->
 * EEPROM 0x1200 + 0x20*r3 + 6.                                            */
void rec1200_name_store(const u8 *rec, u16 n)
{
    name_tmp_copy(rec);                               /* 03A8E6 sub_3A906   */
    eeprom_write(0x1200 + 0x20 * (u8)n + 6, name_tmp, 0x12);
}
/* 03A906-03A922 size 28  name_tmp_copy (sub_3A906): eepmov 0x12 bytes
 * er0+0x22 -> FFAA56 (the working record's name field).  Confirmed.       */
void name_tmp_copy(const u8 *rec) { memcpy(name_tmp, rec + 0x22, 0x12); }

/* 03A922-03A97A size 88  mem_name_store (sub_3A922)  Confirmed.
 * Caller sub_19516.  Area 0: name -> channel record 0x2E80+0x20*n+6;
 * area 3: name -> 0x0F80 + 0x12*n; any other area: nothing.               */
void mem_name_store(const u8 *rec, u16 n)
{
    u8 g = vfo_mem_group(rec);                        /* 03A926             */
    if (g == 0) {
        name_tmp_copy(rec);                           /* 03A948             */
        eeprom_write(0x2E80 + 0x20 * n + 6, name_tmp, 0x12);
    } else if (g == 3) {
        name_tmp_copy(rec);                           /* 03A930             */
        eeprom_write(0x0F80 + 0x12 * n, name_tmp, 0x12);
    }
}

/* 03A97A-03A98C size 18  area3_name_addr (sub_3A97A): er0 = 0xF80 +
 * 0x12*r3, r6 = 0x12.  Confirmed.
 * 03A98C-03A9A2 size 22  area3_name_clear (sub_3A98C)  Confirmed.
 * Caller sub_DEFA (factory defaults): writes the 18-byte ROM block at
 * 0x00F6D4 (blank name, Inferred) to area-3 name slot r3.                 */
void area3_name_clear(u16 n) { eeprom_write(0x0F80 + 0x12 * n, (const u8 *)0x00F6D4, 0x12); }

/* 03A9F6-03A9FC size 6  mem_flag_update_if_regular (sub_3A9F6)  Confirmed.
 * Caller sub_19406.  Returns when the band is in a special area, else
 * falls into mem_flag_update.
 * 03A9FC-03AA66 size 106  mem_flag_update (sub_3A9FC)  Confirmed (flow).
 * Read-modify-write of byte +5 of channel record r3: EEPROM -> FFAA56,
 * rec_byte5_edit (sub_3FAB2, outside chunk) edits it, EEPROM <- FFAA56.   */
void mem_flag_update(u16 slot)
{
    eeprom_read(0x2E80 + 0x20 * slot + 5, name_tmp, 1);  /* 03AA26          */
    rec_byte5_edit(name_tmp);                         /* 03AA2E sub_3FAB2   */
    eeprom_write(0x2E80 + 0x20 * slot + 5, name_tmp, 1); /* 03AA5C          */
}
/* 03AA66-03AAAC size 70  rec1200_flag_update (sub_3AA66)  Confirmed.
 * Same on byte +5 of the 0x1200-set record r3.  Caller sub_19406.         */
void rec1200_flag_update(u16 n)
{
    eeprom_read(0x1200 + 0x20 * (u8)n + 5, name_tmp, 1);
    rec_byte5_edit(name_tmp);
    eeprom_write(0x1200 + 0x20 * (u8)n + 5, name_tmp, 1);
}

/* ==========================================================================
 * 03AAAC-03AB5E  size 178  mem_same_band   (sub_3AAAC)
 * Confidence: Confirmed.  Callers: sub_1EF12, sub_20792, sub_23B60, 23C54.
 * r6l = memory area, r3 = slot, er0 = working record.  Sets AA33.b2, which
 * makes mem_rec_alt return early with er5 = its synthesised frequency.
 * Regular area: read the frequency bytes and rebuild the BCD value.  Then
 * band-plan lookup; clear AA33.b2; return Z = (id low byte == er0->[0x58])
 * - "the memory lies in the record's current band".
 * ========================================================================== */
int mem_same_band(u8 *rec, u16 slot, u8 area)
{
    u32 f;
    flags_AA33 |= 0x04;                               /* 03AAB0             */
    if (mem_rec_addr_g(slot, area) == 0) {            /* 03AABC sub_3AB5E   */
        eeprom_read(0x2E80 + 0x20 * slot + 2, pack_buf + 2, 3);  /* 03AAD2  */
        f = rec_freq_bcd(pack_buf);                   /* 03AAD6..03AB1E     */
    } else {
        f = *(u32 *)pack_buf;                         /* er5 from 03D1F6    */
    }
    u16 id = bandplan_find(f);                        /* 03AB20..03AB46     */
    flags_AA33 &= ~0x04;                              /* 03AB48             */
    return (u8)id == rec[0x58];                       /* 03AB56/03AB5A      */
}
/* 03AB5E-03AB80 size 34  mem_rec_addr_g (sub_3AB5E)  Confirmed.
 * r6l = area: non-zero -> jmp mem_rec_alt; else regular addressing.       */
int mem_rec_addr_g(u16 slot, u8 area) { return area ? mem_rec_alt(slot, area) : 0; }

/* ######################################################################### *
 * PART 5  -  Bit-banged I2C serial-EEPROM drivers (03AB80..03CCBC)         *
 *                                                                           *
 * One GPIO port (doc 82: registers Confirmed, port letter Inferred):       *
 *   FFFBA4 (P_DR)   b0 = SDA level, b1 = SCL level (1 = high)             *
 *   FFFBA8 (P_DDR)  write-only; b0 = SDA direction (1 = output), kept in   *
 *                   the RAM shadow FF816E (copied to r2l on entry and      *
 *                   stored back on exit)                                   *
 *   FFFBA0 (PORT)   b0 = SDA input                                         *
 * Every edge is followed by 5 or 10 nops (bit-time padding, elided here). *
 * Two device pairs (doc 82, doc pc-02):                                    *
 *   0xA0/0xA1  EEPROM 0x00000-0x0FFFF  (16-bit word address)              *
 *   0xA2/0xA3  EEPROM 0x10000-0x1FFFF  (block-select bit = A16)            *
 * Bytes go out MSB first (rotxl -> C, bst C -> SDA); after 8 bits SDA is   *
 * released (DDR b0 = 0), SCL pulsed and the ACK sampled from PORT b0.      *
 * A NACK on the device/address bytes branches to a retry stub outside this *
 * chunk (loc_3B0E4 / loc_3C310: ACK polling while a write cycle runs).     *
 * Writes split at 256-byte boundaries (eeprom_write / eeprom2_write); the  *
 * page writers below send 64 bytes per START.                              *
 * ######################################################################### */

#define SDA_H()   (P_DR |=  0x01)
#define SDA_L()   (P_DR &= ~0x01)
#define SCL_H()   (P_DR |=  0x02)
#define SCL_L()   (P_DR &= ~0x02)
#define SDA_IN()  (P_DDR = (ddr &= ~0x01))
#define SDA_OUT() (P_DDR = (ddr |=  0x01))

/* i2c_stop (inlined everywhere): SCL low, SDA low, SCL high, SDA high.    */
#define I2C_STOP() do { SCL_L(); SDA_L(); SCL_H(); SDA_H(); } while (0)

/* ==========================================================================
 * 03AB80-03AD20  size 416  eeprom_read   (sub_3AB80)
 * Confidence: Confirmed (doc 25/82/96).  51 callers.
 * er0 = EEPROM address (device A0), er1 = RAM dst, r6 = count.
 * START + 0xA0 + address (i2c_addr_A0), repeated START, 0xA1, then clocks
 * in r6 bytes, ACKing all but the last; the last byte is followed directly
 * by STOP (no separate NACK clock).
 * ========================================================================== */
void eeprom_read(u32 ee, u8 *dst, u16 n)
{
    u8 ddr = io_ddr_shadow;                           /* 03AB80 FF816E      */
    i2c_addr_A0(ee);                                  /* 03AB84 sub_3B14C   */
    SDA_H(); SCL_H(); SDA_L(); SCL_L();               /* 03AB88 rep. START  */
    i2c_put_A0(0xA1);                                 /* 03ABF0 sub_3B19A   */
    for (;;) {
        SDA_IN();                                     /* 03ABF6             */
        u8 b = 0;
        for (u8 i = 8; i; --i) {                      /* 03AC06 r4h = 8     */
            SCL_H();                                  /* 03AC08             */
            b = (b << 1) | (P_PORT & 1);              /* 03AC22 bld/rotxl   */
            SCL_L();                                  /* 03AC34             */
        }
        *dst++ = b;                                   /* 03AC52             */
        SDA_OUT();                                    /* 03AC56             */
        if (--n == 0) break;                          /* 03AC5C             */
        SDA_L(); SCL_H(); SCL_L();                    /* 03AC60 ACK         */
    }
    I2C_STOP();                                       /* 03ACB2             */
    io_ddr_shadow = ddr;                              /* 03AD1A             */
}

/* ==========================================================================
 * 03AD20-03B0E4  size 964  eeprom_write   (sub_3AD20)
 * Confidence: Confirmed.  44 callers.
 * er0 = EEPROM address, er1 = RAM src, r6 = count.  Sends bytes after one
 * START/address; when the address crosses a 256-byte boundary it issues
 * STOP and re-addresses (the NACK retry inside i2c_addr_A0 waits out the
 * internal write cycle).  Data-byte ACKs are sampled but not checked.  The
 * 8 bit-times per byte are fully unrolled in ROM.
 * ========================================================================== */
void eeprom_write(u32 ee, const u8 *src, u16 n)
{
    u8 ddr = io_ddr_shadow;                           /* 03AD20             */
    SDA_H(); SCL_H();                                 /* 03AD24 idle bus    */
    for (;;) {
        i2c_addr_A0(ee);                              /* 03AD58             */
        for (;;) {
            u8 b = *src++;                            /* 03AD5C             */
            for (u8 i = 0; i < 8; i++) {              /* unrolled           */
                SCL_L(); if (b & 0x80) SDA_H(); else SDA_L(); b <<= 1; SCL_H();
            }
            SCL_L(); SDA_L(); SDA_IN(); SCL_H();      /* 03AF8E..03AFC8     */
            (void)P_PORT;                             /* 03AFE2 ack ignored */
            SCL_L(); SDA_OUT();                       /* 03AFE6..03AFF8     */
            if (--n == 0) {                           /* 03AFFC             */
                I2C_STOP(); io_ddr_shadow = ddr;      /* 03B076..03B0DE     */
                return;
            }
            ee++;                                     /* 03B000             */
            if ((ee & 0xFF) == 0) break;              /* 03B002 page wrap   */
        }
        I2C_STOP();                                   /* 03B00A..03B058     */
    }
}

/* ==========================================================================
 * 03B14C-03B19A  size 78   i2c_addr_A0   (sub_3B14C)
 * Confidence: Confirmed (doc 96).  Callers: 3AB80, 3AD20, 3B43C, 3B770,
 * 3BA90.  START (SDA low then SCL low; the bus is high on entry), then
 * 0xA0, r0h, r0l; any NACK -> loc_3B0E4 retry (outside this chunk).
 * ========================================================================== */
void i2c_addr_A0(u32 ee)
{
    SDA_L(); SCL_L();                                 /* 03B14C START       */
    if (i2c_put_A0(0xA0))           goto retry;       /* 03B180             */
    if (i2c_put_A0((u8)(ee >> 8)))  goto retry;       /* 03B188 r0h         */
    if (i2c_put_A0((u8)ee))         goto retry;       /* 03B190 r0l         */
    return;
retry:
    i2c_retry_A0(ee);                                 /* loc_3B0E4          */
}

/* ==========================================================================
 * 03B19A-03B43C  size 674  i2c_put_A0   (sub_3B19A)
 * Confidence: Confirmed.  Clocks r5l out MSB first, releases SDA, clocks
 * the 9th bit and returns r5l = PORT & 1 (0 = ACK, Z set).  Unrolled.
 * ========================================================================== */
u8 i2c_put_A0(u8 b)
{
    u8 ddr = io_ddr_shadow;  /* (r2l of the caller) */
    for (u8 i = 0; i < 8; i++) {
        SCL_L(); if (b & 0x80) SDA_H(); else SDA_L(); b <<= 1; SCL_H();
    }
    SCL_L(); SDA_L(); SDA_IN(); SCL_H();              /* 03B3CA..03B404     */
    u8 ack = P_PORT;                                  /* 03B41E             */
    SCL_L(); SDA_OUT();                               /* 03B422..03B434     */
    return ack & 1;                                   /* 03B438             */
}

/* ==========================================================================
 * 03B43C-03B770  size 820  eeprom_write_pages   (sub_3B43C)
 * Confidence: Confirmed.  Callers: the vfo_blkN_restore family, 398D8,
 * 39A46.  Writes e6 consecutive 64-byte pages from er1 to er0 (STOP after
 * each page, er0 += 0x40, e6--, loop back to the entry).
 * ========================================================================== */
void eeprom_write_pages(u32 ee, const u8 *src, u16 pages)
{
    do {
        u8 ddr = io_ddr_shadow;                       /* 03B440             */
        i2c_addr_A0(ee);                              /* 03B448             */
        for (u16 n = 0x40; n; --n) i2c_put_A0(*src++);/* 03B44C..03B6EE     */
        I2C_STOP();                                   /* 03B6F2..03B740     */
        io_ddr_shadow = ddr;                          /* 03B75A             */
        ee += 0x40;                                   /* 03B762             */
    } while (--pages);                                /* 03B768 e6          */
}

/* 03B770-03BA90 size 800  eeprom_write_page64 (sub_3B770)  Confirmed.
 * Callers: 39BA0, 39CE0, 39E22, 39F5A, sub_3CEDC, sub_735F0.
 * One 64-byte page (r6 = 0x40) at er0 from er1, then STOP.                */
void eeprom_write_page64(u32 ee, const u8 *src)
{
    u8 ddr = io_ddr_shadow;                           /* 03B770             */
    i2c_addr_A0(ee);                                  /* 03B778             */
    for (u16 n = 0x40; n; --n) i2c_put_A0(*src++);    /* 03B77C..03BA1E     */
    I2C_STOP(); io_ddr_shadow = ddr;                  /* 03BA3C..03BA8A     */
}

/* 03BA90-03BDAC size 796  eeprom_write_burst (sub_3BA90)  Confirmed.
 * Callers: 39BA0, 39CE0, 39E22, 39F5A, 3A034.  As page64 but the count is
 * the caller's r6 (0x80 in every caller: one burst inside a 256-byte page,
 * no boundary split).                                                     */
void eeprom_write_burst(u32 ee, const u8 *src, u16 n)
{
    u8 ddr = io_ddr_shadow;
    i2c_addr_A0(ee);                                  /* 03BA94             */
    while (n--) i2c_put_A0(*src++);                   /* 03BA98..03BD3A     */
    I2C_STOP(); io_ddr_shadow = ddr;                  /* 03BD58..03BDA6     */
}

/* ==========================================================================
 * 03BDAC-03BF4C  size 416  eeprom2_read   (sub_3BDAC)
 * Confidence: Confirmed (doc 82 claim 1).  26 callers (0x3C/0x3D, 0x73..).
 * Device A2/A3 twin of eeprom_read: er0 = address in the upper 64 KB
 * (EEPROM 0x1xxxx; the A16 bit is implied by the device code), er1 = dst,
 * r6 = count.  i2c_addr_A2, repeated START, 0xA3, read loop as above.
 * ========================================================================== */
void eeprom2_read(u32 ee, u8 *dst, u16 n)
{
    u8 ddr = io_ddr_shadow;                           /* 03BDAC             */
    i2c_addr_A2(ee);                                  /* 03BDB0 sub_3C378   */
    SDA_H(); SCL_H(); SDA_L(); SCL_L();               /* 03BDB4 rep. START  */
    i2c_put_A2(0xA3);                                 /* 03BE1E             */
    for (;;) {
        SDA_IN();
        u8 b = 0;
        for (u8 i = 8; i; --i) { SCL_H(); b = (b << 1) | (P_PORT & 1); SCL_L(); }
        *dst++ = b;                                   /* 03BE7E             */
        SDA_OUT();
        if (--n == 0) break;                          /* 03BE88             */
        SDA_L(); SCL_H(); SCL_L();                    /* ACK                */
    }
    I2C_STOP(); io_ddr_shadow = ddr;                  /* 03BEDE..03BF46     */
}

/* 03BF4C-03C310 size 964  eeprom2_write (sub_3BF4C)  Confirmed (doc 82).
 * 27 callers.  Device A2 twin of eeprom_write, same 256-byte page split
 * (03C22C..03C29E).                                                       */
void eeprom2_write(u32 ee, const u8 *src, u16 n);   /* = eeprom_write, A2 */

/* 03C378-03C3C6 size 78  i2c_addr_A2 (sub_3C378)  Confirmed (doc 82).
 * START + 0xA2 + r0h + r0l; NACK -> loc_3C310 retry (outside chunk).      */
void i2c_addr_A2(u32 ee);                           /* = i2c_addr_A0, 0xA2 */

/* 03C3C6-03C668 size 674  i2c_put_A2 (sub_3C3C6)  Confirmed (doc 82).
 * Byte transmitter for the A2 device; byte-for-byte the same as
 * i2c_put_A0 (returns PORT & 1).                                          */
u8 i2c_put_A2(u8 b);

/* 03C99C-03CCBC size 800  eeprom2_write_page64 (sub_3C99C)  Confirmed.
 * Caller sub_735F0 (clone/extension receive commit, doc 24).  One 64-byte
 * page (r6 = 0x40) to device A2 at er0, then STOP.  (The multi-page
 * sibling 03C668 is dead code, doc 82 claim 4, outside this chunk.)       */
void eeprom2_write_page64(u32 ee, const u8 *src);

/* ######################################################################### *
 * PART 6  -  Settings writers, DTMF memories, special memory areas and     *
 *            the device-A2 (EEPROM 0x1xxxx) store accessors, 03CCBC..03DF86*
 * ######################################################################### */

/* 03CCBC-03CCD0 size 20  settings_R1_save_byte (sub_3CCBC)  Confirmed
 * (doc 32 "writer family").  52 callers (menu exit stubs 0x192xx).
 * r1 = n: writes byte FF8920+n to EEPROM 0x580+n (r6 = 1, enters 03CCD4).
 * 03CCD0-03CCEC size 28  settings_R1_save_range (sub_3CCD0)  Confirmed.
 * er1 = RAM pointer inside R1, r6 = length: EEPROM 0x580 + (er1-FF8920).   */
void settings_R1_save_byte(u16 n)            { settings_R1_save_range(settings_R1 + n, 1); }
void settings_R1_save_range(const u8 *p, u16 len) { eeprom_write(0x580 + (p - settings_R1), p, len); }

/* 03CCEC-03CD1C size 48  settings_R2_save_byte (sub_3CCEC)  Confirmed
 * (doc 32).  10 callers.  Byte FF8AA0+n -> EEPROM 0xC000+n.  The second
 * entry 03CD00 (settings_R2_save_range, er1/r6 given) is inside this
 * IDA function.                                                            */
void settings_R2_save_byte(u16 n)            { settings_R2_save_range(settings_R2 + n, 1); }
void settings_R2_save_range(const u8 *p, u16 len) { eeprom_write(0xC000 + (p - settings_R2), p, len); }

/* 03CD1C-03CD30 size 20  settings_R3_save_byte (sub_3CD1C)  Confirmed.
 * 03CD30-03CD4C size 28  settings_R3_save_range (sub_3CD30)  Confirmed.
 * Byte/range of R3 at FF8D20 -> EEPROM 0xD000 + offset (doc 32).          */
void settings_R3_save_byte(u16 n)            { settings_R3_save_range(settings_R3 + n, 1); }
void settings_R3_save_range(const u8 *p, u16 len) { eeprom_write(0xD000 + (p - settings_R3), p, len); }

/* 03CD4C-03CD5C size 16  rec1034_load (sub_3CD4C)  Confirmed (addressing).
 * 03CD5C-03CD6C size 16  rec1034_save (sub_3CD5C)  Confirmed.
 * 03CD6C-03CD82 size 22  rec1034_args (sub_3CD6C)  Confirmed.
 * 18-byte record r1 at EEPROM 0x1034 + 0x12*r1 <-> FFAD6E.  Callers
 * sub_15342, 15CCE, 4F38, 4FEA, 66EE / 19454, DEFA.  Meaning unknown
 * (18 = 2-byte attribute + 16-char text, like the name blocks; Inferred). */
void rec1034_load(u16 i) { eeprom_read(0x1034 + 0x12 * i, rec1034_buf, 0x12); }
void rec1034_save(u16 i) { eeprom_write(0x1034 + 0x12 * i, rec1034_buf, 0x12); }

/* 03CD82-03CDA0 size 30  bt_list_load (sub_3CD82)  Confirmed (doc 124).
 * 03CDA0-03CDBE size 30  bt_list_save (sub_3CDA0)  Confirmed (doc 124).
 * Bluetooth paired/found-device list: EEPROM 0x1EA00 (device A2), 0x8E
 * bytes <-> FFAAEA (list at FFAAEC, <= 5 entries).                         */
void bt_list_load(void) { eeprom2_read(0xEA00 /*0x1EA00*/, bt_list, 0x8E); }
void bt_list_save(void) { eeprom2_write(0xEA00 /*0x1EA00*/, bt_list, 0x8E); }

/* 03CDEA-03CDFC size 18  dtmf_mem_save_hi (sub_3CDEA)  Confirmed.
 * Caller sub_DEFA (defaults).  Saves FFAC24 as DTMF memory r3l + 16.
 * 03CE22-03CE32 size 16  dtmf_mem_load (sub_3CE22)  Confirmed.
 * 6 callers incl. dtmf_enqueue_request.  03CE32-03CE42 dtmf_mem_save
 * (sub_3CE32, caller DEFA).  03CE42-03CE5A dtmf_mem_args (sub_3CE42):
 * er0 = 0xA80 + 0x10*r3l, er1 = FFAC24, r6 = 0x10.  All Confirmed.
 * DTMF memories: 16 bytes each at EEPROM 0x0A80 (codes 0..15, 0xFF end). */
void dtmf_mem_load(u8 n)    { eeprom_read(0xA80 + 0x10 * n, dtmf_mem_buf, 0x10); }
void dtmf_mem_save(u8 n)    { eeprom_write(0xA80 + 0x10 * n, dtmf_mem_buf, 0x10); }
void dtmf_mem_save_hi(u8 n) { dtmf_mem_save((u8)(n + 0x10)); }

/* 03CE5A-03CE9A size 64  dtmf_mem_save_if_changed (sub_3CE5A)  Confirmed.
 * Caller sub_194E8.  Reads the stored memory into FFAC9A, compares 4
 * longs with FFAC24 and writes only on a difference.                      */
void dtmf_mem_save_if_changed(u8 n)
{
    eeprom_read(0xA80 + 0x10 * n, cmp_buf, 0x10);     /* 03CE62             */
    if (!blk_equal((u32 *)dtmf_mem_buf, (u32 *)cmp_buf, 4))
        dtmf_mem_save(n);                             /* 03CE8E             */
}

/* 03CE9A/03CEAA/03CEBA  area4_tab_load / _save / _args (sub_3CE9A,
 * sub_3CEAA, sub_3CEBA)  Confirmed.  EEPROM 0xBC00, 0x28 bytes <-> FFACE2
 * (two 20-byte arrays FFACE2[], FFACF6[] consumed by area 4 of
 * mem_rec_alt: tone mode / tone index per preset, Inferred).
 * Callers 195D2, 19674, 3CFE8 / 195D2, 19674, DEFA.                       */
void area4_tab_load(void) { eeprom_read(0xBC00, area_tab, 0x28); }
void area4_tab_save(void) { eeprom_write(0xBC00, area_tab, 0x28); }

/* 03CECC/03CEDC/03CEEC  area7_tab_load / _save / _args (sub_3CECC,
 * sub_3CEDC, sub_3CEEC)  Confirmed.  EEPROM 0xBBC0, 0x40 bytes <-> FFACE2
 * (three 20-byte arrays FFACE2/FFACF6/FFAD0A used by area 7).  The save
 * uses the single-page writer eeprom_write_page64.                        */
void area7_tab_load(void) { eeprom_read(0xBBC0, area_tab, 0x40); }
void area7_tab_save(void) { eeprom_write_page64(0xBBC0, area_tab); }

/* ==========================================================================
 * 03CEFE-03CF34  size 54   mem_rec_alt   (sub_3CEFE)
 * 03CF70-03CF72  size 2    nullsub_91 (area 2 handler)
 * 03CF72-03CF9C  size 42   area3_synth   (sub_3CF72)
 * 03CF9C-03CFE4  size 72   area5_synth   (sub_3CF9C)
 * 03CFE8-03D004  size 28   area4_synth   (sub_3CFE8)
 * 03D004-03D022  size 30   area6_synth   (sub_3D004)
 * 03D022-03D36E  size 844  area_synth_common (sub_3D022: area 6 tail,
 *                          areas 7/8/9/10/11, dead 800-MHz case, and the
 *                          shared record builder at 03D1EE)
 * Confidence: Confirmed (flow, constants); Inferred (what the areas are).
 * Entered by jmp from mem_rec_addr / mem_rec_addr_g with r3 = slot and
 * r4l = area.  Synthesises a channel for a "special memory area" instead
 * of reading the regular channel store:
 *   1. push er3; copy the 18-byte ROM blank block 0x00F6D4 to FFAC7A.
 *   2. jump through the table at 0x03CF34 (doc 115 / M5 heads):
 *        0,1 -> 03A700 (regular addressing; reached here this would return
 *               through the pushed er3 - unreachable, Inferred)
 *        2   -> 03CF70 rts (same stack caveat)
 *        3 -> area3_synth   4 -> area4_synth   5 -> area5_synth
 *        6 -> area6_synth   7 -> 03D090        8 -> 03D04A
 *        9 -> 03D150       10 -> 03D198       11 -> 03D1CA
 *      The case at 03D0EE (779.125 / 797.125 / 806.125 MHz bases, 71
 *      channels each) has no table slot: dead (doc 115).
 *   Each case leaves FFAC76 = frequency (8-digit BCD, 10 Hz), FFAC7A.. =
 *   name, r6h = area kind, r4h:r4l = two mode parameters, e6 = tone info.
 * ========================================================================== */
int mem_rec_alt(u16 slot, u8 area)
{
    /* push.l er3 / push.w r4 */
    memcpy(pack_buf + 4, (const u8 *)0x00F6D4, 0x12);   /* 03CF04           */
    switch (area) {                                   /* 03CF2A jmp @er6    */
    case 3:   /* 03CF72: user-named presets; names at EEPROM 0xF80+0x12n   */
        *(u32 *)pack_buf = rom_tab_3FFF4[slot];       /* 03CF76             */
        eeprom_read(0x0F80 + 0x12 * slot, pack_buf + 4, 0x12); /* 03CF8E    */
        return area_build(3, 0x00, 0x08, 0, slot);    /* jmp 03D1EE         */
    case 5: { /* 03CF9C: table 0x040362; low byte b0 = has shift          */
        u32 v = rom_tab_40362[slot];
        alt_tx_freq = 0;                              /* 03CFA4 FFACDE      */
        *(u32 *)pack_buf = v & 0xFFFFFF00;            /* 03CFBA             */
        if (v & 1) {
            alt_tx_freq = v & 0xFFFFFF00;             /* 03CFC4             */
            bcd_sub(&alt_tx_freq, (const u32 *)0x03CFE4); /* 03CFD6 3F94C   */
        }
        return area_build(5, 0x00, 0x07, 0, slot);
    }
    case 4: { /* 03CFE8: ROM table 0x04001C (0x16-byte rows) + EEPROM tab */
        area4_tab_load();                             /* 03CFE8             */
        u16 e6 = (u16)area_tab[0x14 + slot] << 8;     /* FFACF6[slot]       */
        return area_row(4, 0x04001C, 0x16, slot, area_tab[slot], e6, 0x12, 0);
    }
    case 6:   /* 03D004: ROM table 0x0415BA, 0x16-byte rows               */
        return area_row(6, 0x0415BA, 0x16, slot, 0, 0, 0x10, 1);
    case 8:   /* 03D04A: ROM table 0x040480, 0x14-byte rows, no attr word */
        return area_row(8, 0x040480, 0x14, slot, 0, 0, 0x10, 2);
    case 7: { /* 03D090: ROM table 0x040B74 + EEPROM tab (3 arrays)       */
        area7_tab_load();                             /* 03D090             */
        u16 e6 = ((u16)area_tab[0x14 + slot] << 8) | area_tab[0x28 + slot];
        return area_row(7, 0x040B74, 0x16, slot, area_tab[slot], e6, 0x12, 0);
    }
    case 9: { /* 03D150: computed; 6 channels from 322.025.00, then
                 322.250.00 upward, step 0x9C4 = 2500 x 10 Hz (25 kHz)   */
        u32 base = 0x32202500; u16 n = slot;
        if (n >= 6) { n -= 6; base = 0x32225000; }    /* 03D15C             */
        alt_bcd_tmp = base;                           /* FFAA3E             */
        *(u32 *)pack_buf = bin_to_bcd(bcd_to_bin(&alt_bcd_tmp) + 2500u * n);
        return area_build(9, 0x00, 0x07, 0, slot);    /* 03D146..03D194     */
    }
    case 10: { /* 03D198: table 0x0401BE; TX = RX - BCD const at 0x03D1C6 */
        u32 f = rom_tab_401BE[slot];
        *(u32 *)pack_buf = f; alt_tx_freq = f;        /* 03D1A2 / 03D1A8    */
        bcd_sub(&alt_tx_freq, (const u32 *)0x03D1C6); /* 03D1BA             */
        return area_build(10, 0x00, 0x03, 0, slot);
    }
    case 11: { /* 03D1CA: table 0x04020E; mode 4 for slots 11..27        */
        *(u32 *)pack_buf = rom_tab_4020E[slot];       /* 03D1CE             */
        u8 r4l = (slot >= 0x0B && slot < 0x1C) ? 4 : 3;
        return area_build(11, 0x00, r4l, 0, slot);
    }
    default:  /* 0..2: see header */
        return 0;
    }
    /* dead 03D0EE: bases 0x77912500 / 0x79712500 (slot-0x47) / 0x80612500
       (slot-0x8E), step 0x30D4 = 12500 x 10 Hz, r6h = 8, r4 = 0x0207.     */
}

/* Row-table cases (03D0AA / 03D0DE tail): er2 = table + stride*slot;
 * f = row[0..3] with the sub-kHz fix (sub_3FD02) -> FFAC76; name copied
 * from row+4 (18 bytes) or attr word row+4 / 16-byte name row+6 (area 6),
 * or attr 0 / name row+4 (area 8); r4h = row[3] >> 4, r4l = row[3] & 0xF. */
static int area_row(u8 kind, u32 tab, u16 stride, u16 slot, u8 r6l, u16 e6,
                    u16 namelen, int style)
{
    const u8 *row = (const u8 *)(tab + stride * slot);
    *(u32 *)pack_buf = bcd_fix_subkhz(*(const u32 *)row);   /* sub_3FD02    */
    if (style == 0) memcpy(pack_buf + 4, row + 4, 0x12);    /* 03D0C4       */
    else if (style == 1) { *(u16 *)(pack_buf + 4) = *(const u16 *)(row + 4);
                           memcpy(pack_buf + 6, row + 6, 0x10); } /* 03D02A */
    else { *(u16 *)(pack_buf + 4) = 0; memcpy(pack_buf + 6, row + 4, 0x10); }
    (void)namelen;
    return area_build(kind, row[3] >> 4, row[3] & 0x0F, ((u32)e6 << 16) | r6l, slot);
}

/* ==========================================================================
 * 03D1EE  area_build  (shared tail of sub_3D022)   Confirmed (flow).
 * If AA33.b2 (called from mem_same_band): return the frequency in er5,
 * copy FFAC7C.l to FFAC96 and exit (pop er3, r4l = 1).
 * Otherwise build a 0x3A-byte operating record in FFAD22:
 *   +0x19 = r4h, +0x14 = r4l, +0x12 = 0, +0x22..+0x33 = 18-byte name,
 *   +0x1A = frequency (also FFACDA), +0x1E/+0x15 = shift frequency and
 *   shift mode 3 for kinds 5/10 when FFACDE != 0 (else 0/0), +0x13 = 3,
 *   +0x37 = 0; tone fields: kind 4 -> +0x16 = r6l, +0x34 = e6 hi;
 *   kind 7 -> +0x16 = r6l, +0x17/+0x18 = e6 hi/lo; others -> +0x16 = 0,
 *   +0x17 = [FF92CC] (default CTCSS index), +0x18 = 0; +0x34 = 0x0D
 *   unless kind 4.  (Working-record offsets per doc 35 / doc 120.)
 * Then choose the target band: market 2..4 (sub_3ECDE Z) tests the range
 * table 0x0221F6, other markets 0x0221A8 (sub_3F5B2); in range -> band B
 * record FF90F0 (+8EA6.b0), else [FF812A] (8EA6.b0 cleared unless side B).
 * Copy FFAD34 (40 bytes, +0x12..) into target+0x12, target+0x39 = 0x98;
 * for band A: sub_15F96(r3l = kind-2) and clear +0x39.b7.  Finally
 * sub_EC0A (shift/tone fix-up), target+0x36 = 0, sub_1CBE6 (mode icons).
 * Return r4l = 1 (Z clear = "handled, not a regular slot").
 * ========================================================================== */
static int area_build(u8 kind, u8 r4h, u8 r4l, u32 e6r6l, u16 slot)
{
    if (flags_AA33 & 0x04) {                          /* 03D1EE             */
        cmp_buf[0x1C / 1] = 0; *(u32 *)(pack_buf + 0x20) = *(u32 *)(pack_buf + 6);
        return 1;                                     /* er5 = FFAC76       */
    }
    u8 *r = oprec_scratch;                            /* FFAD22             */
    r[0x19] = r4h; r[0x14] = r4l; r[0x12] = 0;        /* 03D212..03D21C     */
    memcpy(r + 0x22, pack_buf + 4, 0x12);             /* 03D236             */
    *(u32 *)(r + 0x1A) = *(u32 *)pack_buf;            /* 03D248             */
    alt_rx_freq = *(u32 *)pack_buf;                   /* 03D24E FFACDA      */
    if ((kind == 5 || kind == 10) && alt_tx_freq) {   /* 03D25A..03D268     */
        *(u32 *)(r + 0x1E) = alt_tx_freq; r[0x15] = 3;
    } else { *(u32 *)(r + 0x1E) = 0; r[0x15] = 0; }
    r[0x13] = 3; r[0x37] = 0;                         /* 03D280..03D288     */
    u8 r6l = (u8)e6r6l; u16 e6 = (u16)(e6r6l >> 16);
    if (kind == 4) { r[0x16] = r6l; r[0x34] = e6 >> 8; r[0x17] = def_ctcss; r[0x18] = 0; }
    else {
        r[0x34] = 0x0D;                               /* 03D29C             */
        if (kind == 7) { r[0x16] = r6l; r[0x17] = e6 >> 8; r[0x18] = (u8)e6; }
        else { r[0x16] = 0; r[0x17] = def_ctcss; r[0x18] = 0; } /* 03D2B6   */
    }
    const void *tab = market_is_2_to_4() ? (const void *)0x0221F6
                                         : (const void *)0x0221A8;  /* 03D2CC */
    u8 *dst;
    if (freq_in_range_tab(alt_rx_freq, tab) == 0) {   /* sub_3F5B2 Z        */
        dst = (u8 *)0xFF90F0; band_slot_chk |= 0x01;  /* 03D30E             */
    } else {
        dst = bandA_rec;                              /* 03D2F8             */
        if (!SIDE_B) band_slot_chk &= ~0x01;
    }
    memcpy(dst + 0x12, r + 0x12, 0x28);               /* 03D31A eepmov      */
    dst[0x39] = 0x98;                                 /* 03D336             */
    if (dst != (u8 *)0xFF90F0) {
        rec_area_flag(dst, kind - 2);                 /* 03D34A sub_15F96   */
        dst[0x39] &= ~0x80;                           /* 03D352             */
    }
    rec_shift_tone_fixup(dst);                        /* 03D358 sub_EC0A    */
    dst[0x36] = 0;                                    /* 03D35E             */
    rec_mode_icons(dst);                              /* 03D362 sub_1CBE6   */
    (void)slot;
    return 1;                                         /* 03D36A r4l = 1     */
}

/* 03D37E-03D38E size 16  rec_B800_save (sub_3D37E)  Confirmed (addressing).
 * 03D38E-03D3A6 size 24  rec_B800_args (sub_3D38E): er0 = 0xB800 + 8*r3l,
 * er1 = FFAA10, r6 = 8.  Caller sub_DEFA.  Meaning unknown.              */
void rec_B800_save(u8 n) { eeprom_write(0xB800 + 8 * n, rec_B800_buf, 8); }

/* 03D40E-03D41E size 16  rec_B8C0_save (sub_3D40E)  Confirmed (addressing).
 * 03D41E-03D436 size 24  rec_B8C0_args (sub_3D41E): er0 = 0xB8C0 +
 * 0x12*r3l, er1 = FFAA18, r6 = 0x12.  Caller sub_DEFA.                   */
void rec_B8C0_save(u8 n) { eeprom_write(0xB8C0 + 0x12 * n, rec_B8C0_buf, 0x12); }

/* 03D472/03D482/03D492  eeprom_load_R2 / eeprom_save_R2 / eeprom_args_R2
 * (sub_3D472, sub_3D482, sub_3D492)  Confirmed (doc 32).  EEPROM 0xC000,
 * 0x280 bytes <-> settings region R2 FF8AA0.  Callers sub_452AC / 103F2. */
void eeprom_load_R2(void) { eeprom_read(0xC000, settings_R2, 0x280); }
void eeprom_save_R2(void) { eeprom_write(0xC000, settings_R2, 0x280); }

/* 03D4A4/03D4B4/03D4C4  rec_C280_load / _save / _args  Confirmed (addr.).
 * 0x1C-byte record r3l at EEPROM 0xC280 + 0x1C*r3l <-> FF9D74.           */
void rec_C280_load(u8 n) { eeprom_read(0xC280 + 0x1C * n, rec_C280_buf, 0x1C); }
void rec_C280_save(u8 n) { eeprom_write(0xC280 + 0x1C * n, rec_C280_buf, 0x1C); }

/* ==========================================================================
 * 03D4DC-03D542  size 102  rec_E000_load   (sub_3D4DC)
 * 03D542-03D5AC  size 106  rec_E000_save   (sub_3D542)
 * Confidence: Confirmed (flow); meaning unknown.  Callers sub_46850 /
 * sub_46BBC, sub_DEFA.  Slots r3l >= 2 only.  30-byte records at EEPROM
 * 0xE000 + 0x1E*r3l, staged through FF95F8 (shared with the SCI-A ring,
 * doc 05).  Byte 0 is a type: 0 -> RAM copy FFA7E2, 8 -> FFA800, other ->
 * FF9DB8.  Load copies the record to that buffer, then writes the type
 * byte into all three buffers.  Save takes type = r3h, copies the chosen
 * buffer to FF95F8 (forcing byte 0 = type), writes it, then stamps the
 * type into all three.
 * ========================================================================== */
void rec_E000_load(u8 n)
{
    if (n < 2) return;                                /* 03D4DC             */
    eeprom_read(0xE000 + 0x1E * n, sci_a_alt_ring, 0x1E);   /* 03D4FA       */
    u8 t = sci_a_alt_ring[0];
    u8 *dst = (t == 0) ? bufA7E2 : (t == 8) ? bufA800 : buf9DB8;
    memcpy(dst, sci_a_alt_ring, 0x1E);                /* 03D524             */
    bufA7E2[0] = buf9DB8[0] = bufA800[0] = t;         /* 03D52C..03D538     */
}
void rec_E000_save(u8 n, u8 type)
{
    if (n < 2) return;                                /* 03D542             */
    sci_a_alt_ring[0] = type;                         /* 03D550             */
    const u8 *src = (type == 0) ? bufA7E2 : (type == 8) ? bufA800 : buf9DB8;
    memcpy(sci_a_alt_ring, src, 0x1E);                /* 03D570             */
    sci_a_alt_ring[0] = type;                         /* 03D578             */
    eeprom_write(0xE000 + 0x1E * n, sci_a_alt_ring, 0x1E);  /* 03D592       */
    bufA7E2[0] = buf9DB8[0] = bufA800[0] = sci_a_alt_ring[0];
}

/* 03D5AC/03D5BC/03D5CC  rec_C3A0_load / _save / _args  Confirmed (addr.).
 * 0x3C-byte record r3l at EEPROM 0xC3A0 + 0x3C*r3l <-> FFADA2.
 * 03D5E4/03D5F4/03D604  rec_C4D0_load / _save / _args  Confirmed (addr.).
 * 0x43-byte record r3l at EEPROM 0xC4D0 + 0x43*r3l <-> FFADDE.            */
void rec_C3A0_load(u8 n) { eeprom_read(0xC3A0 + 0x3C * n, rec_C3A0_buf, 0x3C); }
void rec_C3A0_save(u8 n) { eeprom_write(0xC3A0 + 0x3C * n, rec_C3A0_buf, 0x3C); }
void rec_C4D0_load(u8 n) { eeprom_read(0xC4D0 + 0x43 * n, rec_C4D0_buf, 0x43); }
void rec_C4D0_save(u8 n) { eeprom_write(0xC4D0 + 0x43 * n, rec_C4D0_buf, 0x43); }

/* 03D64E-03D66C size 30  eeprom_load_R3 (sub_3D64E)  Confirmed (doc 32).
 * 03D66C-03D68A size 30  eeprom_save_R3 (sub_3D66C)  Confirmed (doc 32).
 * EEPROM 0xD000, 0x180 bytes <-> settings region R3 FF8D20.               */
void eeprom_load_R3(void) { eeprom_read(0xD000, settings_R3, 0x180); }
void eeprom_save_R3(void) { eeprom_write(0xD000, settings_R3, 0x180); }

/* 03D6B0-03D6D6 size 38  eeprom_save_R3_7E (sub_3D6B0)  Confirmed.
 * 5 callers (0x60xxx-0x63xxx, digital/WIRES-X code).  Saves the R3
 * sub-block n = 0x7E..0xAE (0x31 bytes) FF8D9E -> EEPROM 0xD07E.  (Doc 32
 * says "n = 0x7E..0xAF"; the count is 0x31, so the last byte is 0xAE.)   */
void eeprom_save_R3_7E(void) { eeprom_write(0xD07E, settings_R3 + 0x7E, 0x31); }

/* 03D6D6/03D6E6/03D6F6  rec_D280_load / _save / _args  Confirmed (addr.).
 * 0x5D-byte record r3l at EEPROM 0xD280 + 0x5D*r3l <-> FFAE22.            */
void rec_D280_load(u8 n) { eeprom_read(0xD280 + 0x5D * n, rec_D280_buf, 0x5D); }
void rec_D280_save(u8 n) { eeprom_write(0xD280 + 0x5D * n, rec_D280_buf, 0x5D); }

/* 03D74A-03D75A size 16  eeprom2_load_marker (sub_3D74A)  Confirmed.
 * Caller sub_DDA0.  Device A2 address 0x10 (EEPROM 0x10010), 4 bytes ->
 * FF800A: the second device's boot marker (doc pc-02 "probably").
 * 03D75A-03D768 size 14  eeprom2_mark_valid (sub_3D75A)  Confirmed.
 * FF800A = "TAIS" (ROM 0xDD0E), falls into eeprom2_save_marker.  No
 * static caller.  03D768 eeprom2_save_marker (sub_3D768, caller sub_DBD8),
 * 03D778 eeprom2_args_marker (sub_3D778).                                 */
void eeprom2_load_marker(void) { eeprom2_read(0x10, boot_marker2, 4); }
void eeprom2_mark_valid(void)  { *(u32 *)boot_marker2 = *(const u32 *)0x00DD0E; eeprom2_save_marker(); }
void eeprom2_save_marker(void) { eeprom2_write(0x10, boot_marker2, 4); }

/* 03D78A/03D79A/03D7AA  eeprom2_load_10100 / _save / _args  Confirmed.
 * EEPROM 0x10100 (A2 0x0100), 0x780 bytes <-> FEE000 (clone staging RAM,
 * doc 05).  0x780 = 60 x 0x20 headers (Inferred from 03D7BC).             */
void eeprom2_load_10100(void) { eeprom2_read(0x0100, (u8 *)0xFEE000, 0x780); }
void eeprom2_save_10100(void) { eeprom2_write(0x0100, (u8 *)0xFEE000, 0x780); }

/* 03D7BC-03D7E0 size 36  msgA_hdr_save (sub_3D7BC)  Confirmed (addressing).
 * Caller sub_504F2.  32-byte header FF9DE8 -> EEPROM 0x10100 + 0x20*r3l.
 * 03D7E0-03D828 size 72  msgA_save (sub_3D7E0)  Confirmed.  Caller 49EBE.
 * Header as above plus body FF9EF8, length [FF9E04]+2, -> 0x10880 +
 * 0xB0*r3l.  03D828 msgA_body_load (sub_3D828, len [FF9E24]+2 -> FF9E48),
 * 03D854 msgA_body_load2 (sub_3D854, len e6+2 -> FF9FA8).  All Confirmed.
 * Record store "A": 60 headers of 0x20 + 60 bodies of 0xB0 (Inferred:
 * message/log records; the 0x50xxx callers are the APRS/message code).  */
void msgA_hdr_save(u8 n)  { eeprom2_write(0x0100 + 0x20 * n, msg_hdr, 0x20); }
void msgA_save(u8 n)
{
    eeprom2_write(0x0100 + 0x20 * n, msg_hdr, 0x20);                 /* 03D7FC */
    eeprom2_write(0x0880 + 0xB0 * n, msg_body_out, msg_len_out + 2); /* 03D81E */
}
void msgA_body_load(u8 n)          { eeprom2_read(0x0880 + 0xB0 * n, msg_body_in, msg_len_in + 2); }
void msgA_body_load2(u8 n, u16 e6) { eeprom2_read(0x0880 + 0xB0 * n, msg_body_cmp, e6 + 2); }

/* 03D87E/03D88E/03D89E  eeprom2_load_131C0 / _save / _args  Confirmed.
 * EEPROM 0x131C0 (A2 0x31C0), 0x780 bytes <-> FEE780.
 * 03D8B0 msgB_hdr_save (FF9DE8), 03D8D4 msgB_hdr_save2 (FF9E28),
 * 03D8F8 msgB_hdr_put (er3 = src, r5l = slot): 0x20 bytes -> 0x131C0 +
 * 0x20*n.  03D918 msgB_body_load ([9E24]+2 -> FF9E48), 03D944 msgB_body_
 * save (FF9EF8, [9E04]+2), 03D970 msgB_body_load_full (0x90 -> FFA62C):
 * bodies at 0x13940 + 0x90*n.  All Confirmed (addressing).  Store "B" =
 * 60 x 0x20 headers + 60 x 0x90 bodies.                                    */
void eeprom2_load_131C0(void) { eeprom2_read(0x31C0, (u8 *)0xFEE780, 0x780); }
void eeprom2_save_131C0(void) { eeprom2_write(0x31C0, (u8 *)0xFEE780, 0x780); }
void msgB_hdr_save(u8 n)  { eeprom2_write(0x31C0 + 0x20 * n, msg_hdr, 0x20); }
void msgB_hdr_save2(u8 n) { eeprom2_write(0x31C0 + 0x20 * n, msg_hdr2, 0x20); }
void msgB_hdr_put(u8 n, const u8 *src) { eeprom2_write(0x31C0 + 0x20 * n, src, 0x20); }
void msgB_body_load(u8 n)      { eeprom2_read(0x3940 + 0x90 * n, msg_body_in, msg_len_in + 2); }
void msgB_body_save(u8 n)      { eeprom2_write(0x3940 + 0x90 * n, msg_body_out, msg_len_out + 2); }
void msgB_body_load_full(u8 n) { eeprom2_read(0x3940 + 0x90 * n, msg_body_A62C, 0x90); }

/* ==========================================================================
 * 03D994-03DA10  size 124  msgB_body_compare   (sub_3D994)
 * Confidence: Confirmed (flow); Inferred (duplicate-message test).
 * Caller sub_4A266.  e6 = stored body length, r6 = reference length.
 * n = min(e6 - 0x2A, r6 - 1) -> FFA558; reads body r3l (e6+2 bytes) into
 * FF9FA8 and compares n bytes of its text (FF9FD2 = +0x2A) with FF9F22.
 * FFA557 = 0 when equal, 1 when different.  Compares word-wise, with a
 * byte step when n is odd.
 * ========================================================================== */
void msgB_body_compare(u8 n, u16 e6, u16 r6)
{
    u16 cnt = e6 - 0x2A;                              /* 03D998             */
    if (cnt >= r6) cnt = r6 - 1;                      /* 03D99E..03D9A4     */
    msg_cmp_len = cnt;                                /* 03D9A6 FFA558      */
    eeprom2_read(0x3940 + 0x90 * n, msg_body_cmp, e6 + 2);   /* 03D9C6      */
    msg_cmp_diff = memcmp(msg_text_ref, msg_body_cmp + 0x2A, cnt) ? 1 : 0;
}

/* 03DA10/03DA20/03DA30  msgB_tail_load / _save / _args  Confirmed.
 * 0x60 bytes at body+0x2A (EEPROM 0x13940 + 0x90*n + 0x2A) <-> FFA56C.
 * 03DA52 msgB_tail_load2 (sub_3DA52): same bytes -> FFA5CC.  Callers
 * 0x5066E / 0x50EA8 / 0x5469C.                                            */
void msgB_tail_load(u8 n)  { eeprom2_read(0x3940 + 0x90 * n + 0x2A, msg_tail, 0x60); }
void msgB_tail_save(u8 n)  { eeprom2_write(0x3940 + 0x90 * n + 0x2A, msg_tail, 0x60); }
void msgB_tail_load2(u8 n) { eeprom2_read(0x3940 + 0x90 * n + 0x2A, msg_tail2, 0x60); }

/* 03DA80/03DA90/03DAA0  eeprom2_load_1C000 / _save / _args  Confirmed.
 * EEPROM 0x1C000, 0x110 bytes <-> FFB4A8.  NB: 03DCB2/03DCD0 read and
 * write 0x180 bytes at the SAME address into FF4576 - two views of one
 * region (finding; which is current is not resolved).                     */
void eeprom2_load_1C000(void) { eeprom2_read(0xC000, buf_B4A8, 0x110); }
void eeprom2_save_1C000(void) { eeprom2_write(0xC000, buf_B4A8, 0x110); }

/* 03DAB2-03DAD4 size 34  group_name_load (sub_3DAB2)  Confirmed (doc 122).
 * 03DAD4-03DAF6 size 34  group_name_save (sub_3DAD4)  Confirmed.
 * 16-byte group name r1 at EEPROM 0x1B000 + 0x10*r1 <-> FFB9F2 (doc 122:
 * "GROUP 01".."GROUP 16" defaults are copied to FFB9F2).                  */
void group_name_load(u16 i) { eeprom2_read(0xB000 + 0x10 * i, group_name, 0x10); }
void group_name_save(u16 i) { eeprom2_write(0xB000 + 0x10 * i, group_name, 0x10); }

/* 03DAF6-03DB18 size 34  group_items_load (sub_3DAF6)  Confirmed.
 * 03DB18-03DB3A size 34  group_items_save (sub_3DB18)  Confirmed.
 * 30-byte item list of group r1 at EEPROM 0x1B0A0 + 0x1E*r1 <-> FFBA12
 * (doc 122: 6-byte-stride entries -> 5 per group).                       */
void group_items_load(u16 i) { eeprom2_read(0xB0A0 + 0x1E * i, group_items, 0x1E); }
void group_items_save(u16 i) { eeprom2_write(0xB0A0 + 0x1E * i, group_items, 0x1E); }

/* 03DB3A/03DB58  blk_1B200_load / _save (sub_3DB3A/sub_3DB58), and
 * 03DB76/03DB94  blk_1B300_load / _save (sub_3DB76/sub_3DB94)  Confirmed.
 * 0x90 bytes at EEPROM 0x1B200 / 0x1B300 <-> FF96F8.  Callers 0x24xxx.   */
void blk_1B200_load(void) { eeprom2_read(0xB200, buf_96F8, 0x90); }
void blk_1B200_save(void) { eeprom2_write(0xB200, buf_96F8, 0x90); }
void blk_1B300_load(void) { eeprom2_read(0xB300, buf_96F8, 0x90); }
void blk_1B300_save(void) { eeprom2_write(0xB300, buf_96F8, 0x90); }

/* ==========================================================================
 * 03DBB2-03DBCC  size 26   tab24_load    (sub_3DBB2)
 * 03DBCC-03DBEA  size 30   tab24_save    (sub_3DBCC)
 * 03DBEA-03DC00  size 22   tab24_args    (sub_3DBEA)
 * 03DC00-03DC24  size 36   tab24_unpack  (sub_3DC00)
 * 03DC24-03DC48  size 36   tab24_pack    (sub_3DC24)
 * Confidence: Confirmed.  Callers sub_63C94 / sub_6876E, sub_DEFA.
 * Record r3l of 0x168 bytes at EEPROM 0x1C110 + 0x168*r3l, staged in
 * FF95F8: 24 entries of 15 bytes, expanded into FFB5B8 with a 0x20 stride
 * (unpack) or compacted back (pack).
 * ========================================================================== */
void tab24_unpack(void)
{
    const u8 *s = sci_a_alt_ring;
    for (u8 i = 0; i < 24; i++, s += 15) memcpy(tab24 + 0x20 * i, s, 15);
}
void tab24_pack(void)
{
    u8 *d = sci_a_alt_ring;
    for (u8 i = 0; i < 24; i++, d += 15) memcpy(d, tab24 + 0x20 * i, 15);
}
void tab24_load(u8 n) { eeprom2_read(0xC110 + 0x168 * n, sci_a_alt_ring, 0x168); tab24_unpack(); }
void tab24_save(u8 n) { tab24_pack(); eeprom2_write(0xC110 + 0x168 * n, sci_a_alt_ring, 0x168); }

/* 03DC7A/03DC8A/03DC9A  rec_1D8F8_load / _save / _args  Confirmed (addr.).
 * 0x50-byte record r3l at EEPROM 0x1D8F8 + 0x50*r3l <-> FFB8D8 (IDA shows
 * the immediate as "sub_1D8F8"; it is an EEPROM address).                 */
void rec_1D8F8_load(u8 n) { eeprom2_read(0xD8F8 + 0x50 * n, buf_B8D8, 0x50); }
void rec_1D8F8_save(u8 n) { eeprom2_write(0xD8F8 + 0x50 * n, buf_B8D8, 0x50); }

/* 03DCB2-03DCD0 size 30  blk_1C000_load_wide (sub_3DCB2)  Confirmed.
 * 03DCD0-03DCEE size 30  blk_1C000_save_wide (sub_3DCD0)  Confirmed.
 * 0x180 bytes EEPROM 0x1C000 <-> FF4576 (see the note at 03DA80).
 * 03DCEE-03DD14 size 38  blk_1C000_put16 (sub_3DCEE)  Confirmed.
 * Writes entry r3l (16 bytes) FF4576 + 0x10n -> 0x1C000 + 0x10n.          */
void blk_1C000_load_wide(void) { eeprom2_read(0xC000, buf_4576, 0x180); }
void blk_1C000_save_wide(void) { eeprom2_write(0xC000, buf_4576, 0x180); }
void blk_1C000_put16(u8 n)     { eeprom2_write(0xC000 + 0x10 * n, buf_4576 + 0x10 * n, 0x10); }

/* 03DD14/03DD32  blk_1E000_load / _save (sub_3DD14/sub_3DD32)  Confirmed.
 * 0x50 bytes EEPROM 0x1E000 <-> FFAE22 (the same RAM as rec_D280).
 * 03DD50/03DD74  rec_1E050_load / _save (sub_3DD50/sub_3DD74) Confirmed.
 * 0x1E0-byte record r3l at 0x1E050 + 0x1E0*r3l <-> FFB5B8 (the tab24 RAM). */
void blk_1E000_load(void) { eeprom2_read(0xE000, rec_D280_buf, 0x50); }
void blk_1E000_save(void) { eeprom2_write(0xE000, rec_D280_buf, 0x50); }
void rec_1E050_load(u8 n) { eeprom2_read(0xE050 + 0x1E0 * n, tab24, 0x1E0); }
void rec_1E050_save(u8 n) { eeprom2_write(0xE050 + 0x1E0 * n, tab24, 0x1E0); }

/* 03DD98/03DDA8/03DDB8  pic_state_load / _save / _args  Confirmed.
 * 0x80 bytes EEPROM 0x1FA00 <-> FF2F4A.  Doc 74: the last-picture name
 * stem is read from FF2F9E (= FF2F4A + 0x54) after this load.             */
void pic_state_load(void) { eeprom2_read(0xFA00, pic_state, 0x80); }
void pic_state_save(void) { eeprom2_write(0xFA00, pic_state, 0x80); }

/* 03DDFC-03DE20 size 36  mem_read_raw (sub_3DDFC)  Confirmed.
 * Callers sub_D642, sub_DA6E.  Channel record r3 -> FFAC76, no unpack.    */
void mem_read_raw(u16 slot) { eeprom_read(0x2E80 + 0x20 * slot, pack_buf, 0x20); }

/* ==========================================================================
 * DG-ID word cache (doc 61, doc 82).  EEPROM device A2:
 *   0x1A000 + 2n   0x1200-set records (12)       RAM FF4726
 *   0x1A018 + 2b   per-band VFO, side A (12)     RAM FF473E
 *   0x1A030 + 2b   per-band VFO, side B (12)     RAM FF4756
 *   0x1A080 + 2n   channel slots (1100)          RAM FF476E
 * The working word is FF8ED6/D7 for side A and FF8ED8/D9 for side B
 * (selected by FF817E.b0 here).  Doc 82 calls D6 the "RX" and D8 the "TX"
 * DG-ID word, chosen by FF8EA0.b6; in these routines the choice is the A/B
 * edit side, so each word is per band (two bytes, presumably one DG-ID per
 * direction) - a correction of the RX/TX reading, Inferred.
 * ========================================================================== */

/* 03DE20-03DE52 size 50  dgid_cache_load (sub_3DE20)  Confirmed (doc 61).
 * Caller sub_ED16 (boot).  0x48 bytes 0x1A000 -> FF4726 and 0x898 bytes
 * 0x1A080 -> FF476E.
 * 03DE52-03DE84 size 50  dgid_cache_save (sub_3DE52)  Confirmed.  Caller
 * sub_DEFA.  The same two ranges back.                                    */
void dgid_cache_load(void) { eeprom2_read(0xA000, dgid_hdr, 0x48); eeprom2_read(0xA080, dgid_mem, 0x898); }
void dgid_cache_save(void) { eeprom2_write(0xA000, dgid_hdr, 0x48); eeprom2_write(0xA080, dgid_mem, 0x898); }

/* Shared write-through tail 03DED0/03DED2: entry n (r3), table er0/er1;
 * old = cache[n]; new = SIDE_B ? FF8ED8:D9 : FF8ED6:D7; if changed store it
 * and write the 2 bytes to EEPROM2.                                       */
static void dgid_put(u32 ee, u16 *cache, u16 n)
{
    u16 nw = SIDE_B ? ((dgid_B_hi << 8) | dgid_B_lo) : ((dgid_A_hi << 8) | dgid_A_lo);
    if (cache[n] == nw) return;                       /* 03DEFA             */
    cache[n] = nw;                                    /* 03DEFE             */
    eeprom2_write(ee + 2 * n, &cache[n], 2);          /* 03DF00             */
}
static void dgid_get(u16 *cache, u16 n)               /* 03DF56/03DF58 tail */
{
    u16 w = cache[n];
    if (SIDE_B) { dgid_B_hi = w >> 8; dgid_B_lo = (u8)w; }
    else        { dgid_A_hi = w >> 8; dgid_A_lo = (u8)w; }
}
/* 03DE84-03DE96 size 18  rec1200_dgid_save (sub_3DE84)  Confirmed.        */
void rec1200_dgid_save(u16 n) { dgid_put(0xA000, (u16 *)dgid_hdr, (u8)n); }
/* 03DE96-03DEA8 size 18  mem_dgid_save (sub_3DE96)  Confirmed (doc 61).   */
void mem_dgid_save(u16 slot)  { dgid_put(0xA080, (u16 *)dgid_mem, slot); }
/* 03DEA8-03DF0A size 98  vfo_dgid_save (sub_3DEA8)  Confirmed.
 * Band = rec[3]; table 0x1A018/FF473E (A) or 0x1A030/FF4756 (B).         */
void vfo_dgid_save(const u8 *rec)
{
    if (SIDE_B) dgid_put(0xA030, (u16 *)(dgid_hdr + 0x30), rec[3]);
    else        dgid_put(0xA018, (u16 *)(dgid_hdr + 0x18), rec[3]);
}
/* 03DF0A-03DF1C size 18  rec1200_dgid_load (sub_3DF0A)  Confirmed.
 * 03DF1C-03DF2E size 18  mem_dgid_load (sub_3DF1C)  Confirmed (doc 61).
 * 03DF2E-03DF86 size 88  vfo_dgid_load (sub_3DF2E)  Confirmed.
 * RAM-cache reads into the working word (no EEPROM access).               */
void rec1200_dgid_load(u16 n) { dgid_get((u16 *)dgid_hdr, (u8)n); }
void mem_dgid_load(u16 slot)  { dgid_get((u16 *)dgid_mem, slot); }
void vfo_dgid_load(const u8 *rec)
{
    dgid_get((u16 *)(dgid_hdr + (SIDE_B ? 0x30 : 0x18)), rec[3]);
}

/* ######################################################################### *
 * PART 7  -  S-meter, UI timers, RTC, standby/charge, market predicates,   *
 *            calibration pointers, tone classes, slot stepping (03DF86..)  *
 * ######################################################################### */

/* S-meter quantiser (doc 137 sec.4), inlined 4x:  cal = [FF8162] (band A)
 * or [FF8166] (band B); lo = cal[3] (S1 LEVEL), hi = cal[4] (S9 LEVEL).
 * adc >= hi -> 10; else step = (hi-lo)/8 and the level counts how many of
 * the 9 thresholds lo + k*step (k = 0..8) the reading reaches.            */
static u8 smeter_quant(const u8 *cal, u8 adc)
{
    u8 lo = cal[3], hi = cal[4];
    if (adc >= hi) return 10;                         /* 03E08E / 03E0B2    */
    u8 step = (u8)((hi - lo) / 8);                    /* 03E09A divxu       */
    u8 thr = lo, lvl = 0;
    for (u8 k = 9; k; --k) {                          /* 03E09E r6l = 9     */
        if (adc < thr) break;
        thr += step; lvl++;
    }
    return lvl;
}

/* ==========================================================================
 * 03E060-03E110  size 176  smeter_quantise_A   (sub_3E060)
 * 03E26C-03E31A  size 174  smeter_quantise_B   (sub_3E26C)
 * Confidence: Confirmed (doc 137).  er0 = band record.  A: AN3 FFA993 with
 * cal [FF8162]; B: AN5 FFA995 with cal [FF8166].
 *   +0x90 == 2 (band closed by S-meter squelch) -> 0 into +0x80/+0x81.
 *   +0x8F.b1 clear: if +0x37 (SQL S-METER) == 0 -> 0; else +0x80 = 0,
 *     +0x81 = level (squelch-compare value).
 *   +0x8F.b1 set (signal open): level, forced >= 1, into +0x80 and +0x81;
 *     a non-zero level also into +0x83.
 * ========================================================================== */
void smeter_quantise_A(u8 *rec)
{
    u8 lvl = 0;
    if (rec[0x90] == 2) goto store;                   /* 03E062             */
    if (!(rec[0x8F] & 0x02)) {                        /* 03E06C             */
        if (rec[0x37] == 0) goto store;               /* 03E074             */
        rec[0x80] = 0;                                /* 03E0B4             */
        rec[0x81] = smeter_quant(cal_ptr_A, an3_level);
        return;
    }
    lvl = smeter_quant(cal_ptr_A, an3_level);         /* 03E0C2             */
    if (lvl == 0) lvl = 1;                            /* 03E0FA             */
store:
    rec[0x80] = lvl; rec[0x81] = lvl;                 /* 03E100 / 03E104    */
    if (lvl) rec[0x83] = lvl;                         /* 03E10A             */
}
void smeter_quantise_B(u8 *rec);   /* identical with an5_level, cal_ptr_B */

/* 03E110-03E14A size 58  smeter_level_A (sub_3E110)  Confirmed (doc 137).
 * 03E31A-03E354 size 58  smeter_level_B (sub_3E31A)  Confirmed.
 * The bare quantiser, result in r2l (band scope callers sub_2D708.. /
 * sub_2E2DC..).                                                           */
u8 smeter_level_A(void) { return smeter_quant(cal_ptr_A, an3_level); }
u8 smeter_level_B(void) { return smeter_quant(cal_ptr_B, an5_level); }

/* Redraw rule inlined 4x and as sub_3E14A:  if +0x80 changed since +0x84
 * (and +0x84 updated), and no popup (A9FC == 0), and the screen mode A9F9
 * is 0 (or 9/10 with B057.b5), and AD69.b7 clear, and not (screen 0x0B
 * with +0x8A != 0): request a redraw (817E.b1).                           */
static void smeter_redraw_rule(u8 *rec, u8 b057)
{
    u8 cur = rec[0x80], old = rec[0x84];
    rec[0x84] = cur;                                  /* 03E152             */
    if (cur == old) return;
    if (popup_A9FC != 0) return;                      /* 03E15A             */
    u8 m = screen_mode_A9F9;
    if (m != 0) {
        if (m != 9 && m != 10) return;
        if (!(b057 & 0x20)) return;                   /* 03E16E             */
    }
    if (flags_AD69 & 0x80) return;                    /* 03E174             */
    if (rec[1] == 0x0B && rec[0x8A] != 0) return;     /* 03E17C             */
    ui_refresh_flags |= 0x02;                         /* 03E18A             */
}
/* 03E14A-03E192 size 72  smeter_redraw_check (sub_3E14A)  Confirmed.
 * Caller sub_33636; r5l = FFB057 supplied by the caller.                  */
void smeter_redraw_check(u8 *rec, u8 r5l) { smeter_redraw_rule(rec, r5l); }

/* ==========================================================================
 * 03DF86-03E060  size 218  smeter_update_A   (sub_3DF86)
 * 03E192-03E26C  size 218  smeter_update_B   (sub_3E192, FF9581, 3E26C)
 * Confidence: Confirmed.  Callers sub_2E60, sub_2F7E / sub_30A2.
 * 817E.b2 = restart: clear it, the divider FF956E and rec+0x85.  First
 * pass (+0x85 == 0) runs only on a restart: quantise, divider = 10,
 * redraw rule, +0x85 = 1.  Later passes run when the divider is 0:
 * quantise, divider = 10, redraw rule.
 * ========================================================================== */
void smeter_update_A(u8 *rec)
{
    u8 f = ui_refresh_flags;                          /* 03DF86             */
    if (f & 0x04) {
        ui_refresh_flags &= ~0x04; smeter_timer_A = 0; rec[0x85] = 0;
    }
    if (rec[0x85] == 0) {                             /* 03DF9E             */
        if (!(f & 0x04)) return;
        smeter_quantise_A(rec); smeter_timer_A = 10;  /* 03DFA8..03DFAE     */
        smeter_redraw_rule(rec, flags_B057);
        rec[0x85] = 1;                                /* 03DFFE             */
        return;
    }
    if (smeter_timer_A != 0) return;                  /* 03E004             */
    smeter_quantise_A(rec); smeter_timer_A = 10;
    smeter_redraw_rule(rec, flags_B057);
}
void smeter_update_B(u8 *rec);    /* identical with FF9581 / quantise_B */

/* ==========================================================================
 * 03E354-03E5DA  size 646  ui_timers_tick   (sub_3E354)
 * Confidence: Confirmed (flow); Inferred (names of most timers).
 * Caller sub_30E0 (periodic tick).  Each block: when a 10 ms-tier timer
 * (FF95xx) has expired, clear the matching popup/indicator and request a
 * redraw (817E.b1).  In order:
 *   - FF9537 / 8955==1 / FF953A shortcut to the 0x25-countdown block;
 *   - AA31.b6 -> redraw; node mode (8DDE) with FF959F==0 and B3D5.b6;
 *   - FF9538==0 and AA34.b5: clear, BBE1 = 0, call 0x7BE8 if BC4E;
 *   - FF9539==0 and FF94F5 != 0xFF: take code, FF94F5 = 0xFF, clear
 *     8F67.b0 / 906F.b0, codes 0x1F..0x22 call sub_1F9E4 (doc 120: FF94F5);
 *   - A9FC / A9FE / A9FF / AA01 / BBFF popups with timers 95CE/95D0/95D2/
 *     95D4 -> sub_4AAC8 / sub_5D80E / sub_5D852, AA0E/BC2A blink at 100;
 *   - BC5E.b7 with FF95E8; then every 0x50 ticks (FF953A) compare word
 *     pairs A9BE/A9C2 and A9BC/A9C0 (redraw on change);
 *   - FF9548==0 and BBEB != 0: clear and redraw;
 *   - 9D26.b7 && !b0 && !8AAB.b7 && 9C62/9CC4 >= 0 && 9C8F != '0' ->
 *     sub_44DA8;
 *   - RTC INT edge: A9DC = (A9DC << 1) | FFFF45.b3; on a 1 -> 0 edge read
 *     the RTC time (rtc_read_time -> FFA9C4) and redraw; then if 89C1.b7
 *     and (A9C8 & 0x3F7F) == FF898A: mask interrupts and jmp 0x25AC
 *     (Inferred: OFF timer power-down); else if 89C2.b6, tx_state != 1 and
 *     minute:second word A9C9 == 0 -> tone event FFAAE0 = 0x43 (hourly).
 * ========================================================================== */
void ui_timers_tick(void)
{
    /* TODO(waveC): the ~20 timer/popup blocks are listed in the header;
       only the RTC tail is written out. */
    u8 h = (u8)(rtc_int_hist << 1);                   /* 03E570             */
    if (P45_PORT & 0x08) h |= 1;                      /* 03E576 bld/bst     */
    rtc_int_hist = h;
    if (h & 1) return;                                /* 03E580             */
    if (!(h & 2)) return;                             /* 03E584 falling edge*/
    rtc_read_time(rtc_time);                          /* 03E58E             */
    ui_refresh_flags |= 0x02;
    if ((set_89C1 & 0x80) &&
        ((*(u16 *)(rtc_time + 4) & 0x3F7F) == off_timer_hm)) {   /* 03E598  */
        disable_interrupts(); power_down_25AC();      /* 03E5B0 orc / jmp   */
    }
    if ((set_89C2 & 0x40) && tx_state != 1 &&
        rtc_time[5] == 0 && rtc_time[6] == 0)         /* 03E5B6..03E5D0     */
        tone_event = 0x43;                            /* 03E5D4 FFAAE0      */
}

/* 03E5DA-03E60E size 52  led_blink_toggle (sub_3E5DA)  Inferred.
 * Caller sub_31734.  Toggles AA32.b1: set -> FF9549 = 4 and FFFBA5 low
 * nibble = 8; clear -> FF9549 = 0x55 and low nibble 0 (an LED/indicator
 * duty cycle; FFFBA5 called a port pull-up register in doc 05).           */
void led_blink_toggle(void)
{
    flags_AA32 ^= 0x02;
    if (flags_AA32 & 0x02) { timer_9549 = 4;    P_FBA5 = (P_FBA5 & 0xF0) | 0x08; }
    else                   { timer_9549 = 0x55; P_FBA5 =  P_FBA5 & 0xF0; }
}

/* 03E60E-03E66C size 94  blink_A9F7 (sub_3E60E)  Confirmed.
 * 03E99A-03E9F8 size 94  blink_B3E8 (sub_3E99A)  Confirmed (same shape on
 * B3E8/B3E9/FF9566; no static caller).
 * b7 = start request, b6 = stop request, b0 = visible phase, A9F8 =
 * running; toggles b0 every 0x32 ticks (500 ms) and requests a redraw.    */
void blink_A9F7(void)
{
    u8 r = blink_ctl;                                 /* 03E60E             */
    blink_ctl &= ~0xC0;
    if (blink_run == 0) {                             /* 03E61E             */
        blink_ctl |= 0x01;
        if (r & 0x80) { blink_timer = 0x32; blink_run = 1; }
        return;
    }
    if (!(r & 0x80) && (r & 0x40)) {                  /* 03E63C stop        */
        blink_ctl |= 0x01; blink_run = 0; return;
    }
    if (blink_timer != 0) return;                     /* 03E652             */
    blink_ctl ^= 0x01;                                /* 03E658 bnot        */
    ui_refresh_flags |= 0x02;
    blink_timer = 0x32;
}

/* 03E66C-03E682 size 22  ui_flags_clear_A7 (sub_3E66C)  Confirmed.
 * No caller.  FF817E &= 0xA7; both arms of the FFA9F6 test are rts.       */
void ui_flags_clear_A7(void) { ui_refresh_flags &= 0xA7; (void)flag_A9F6; }

/* ==========================================================================
 * 03E682-03E6FE  size 124  lamp_timer_event   (sub_3E682)
 * 03E6FE-03E70A  size 12   lamp_off           (sub_3E6FE)
 * 03E71A-03E728  size 14   lamp_state_clear   (sub_3E71A)
 * Confidence: Confirmed (flow); Inferred (lamp/backlight meaning).
 * Callers sub_30E0 / sub_2EAC2 / sub_3E682.  On event AA30.b3 the state
 * A9E9 is reset; with A9E9 == 0 and the event:
 *   setting 89AA == 10: if 89C5.b7 and A9A1 != 0 -> lamp_state_clear, and
 *     (89AA still 10) return, else lamp_off;  (89C5.b7 clear -> lamp_off)
 *   89AA == 9: when A9A1 in {0, 0x28, 0x3C} (and 89A4 for the latter two)
 *     -> sub_161D6 (A999 = lamp level from table 0x3B42[89A4]);
 *   otherwise sub_161D6, FF95D6 = word table 0x3B4A[89AA] (timeout),
 *     A9E9 = 1.
 * With A9E9 != 0 the code continues at 03E70C (outside chunk).
 * ========================================================================== */
void lamp_timer_event(void)
{
    u8 ev = flags_AA30;
    if (ev & 0x08) { flags_AA30 &= ~0x08; lamp_state = 0; }   /* 03E686     */
    if (lamp_state != 0) { lamp_running_3E70C(); return; }    /* 03E69A     */
    if (!(ev & 0x08)) return;
    u8 s = set_89AA;
    if (s == 10) {                                    /* 03E6E6             */
        if (usb_cam_flags_89C5 & 0x80) {
            if (lamp_A9A1 == 0) return;
            lamp_state_clear();
            if (set_89AA == 10) return;
        }
        lamp_off(); return;
    }
    if (s == 9) {                                     /* 03E6CC             */
        u8 a = lamp_A9A1;
        if (a == 0 || ((a == 0x28 || a == 0x3C) && set_89A4)) lamp_set_level();
        return;
    }
    lamp_set_level();                                 /* 03E6AC sub_161D6   */
    lamp_timeout = lamp_timeout_tbl[set_89AA];        /* 03E6BC 0x3B4A      */
    lamp_state = 1;
}
void lamp_off(void)         { lamp_level_default(); lamp_state = 0; }   /* sub_161F2 */
void lamp_state_clear(void) { lamp_A999 = 0; lamp_state = 0; }

/* ######################################################################### *
 * RTC driver (Inferred device: Seiko S-35190A-style 3-wire RTC).           *
 * Pins: FFFF5A.b1 = SCK, FFFF5D.b4 = SIO out, FFFF5D.b5 = CE, FFFF4D.b4 = *
 * SIO in, FFFB8D = port DDR (0xE3 = SIO input, 0xF3 = output).  Command   *
 * byte 0110 ccc r/w sent MSB first; data bytes LSB first.  Commands seen: *
 * 0x60 status1 W, 0x61 status1 R, 0x62 status2 W, 0x63 status2 R,         *
 * 0x64 time W, 0x65 time R, 0x68 INT1 (alarm) W.                          *
 * ######################################################################### */

/* 03E864-03E90A size 166  rtc_read (sub_3E864)  Confirmed (bit flow).
 * Callers 3E772, 3E828.  r2l = command, r6l = count, er5 = dst.           */
void rtc_read(u8 cmd, u8 n, u8 *dst)
{
    P5A_DR |= 0x02; P5D_DR |= 0x10; P5D_DR |= 0x20;   /* 03E864 CE high     */
    for (u8 i = 8; i; --i) {                          /* 03E87A MSB first   */
        if (cmd & 0x80) P5D_DR |= 0x10; else P5D_DR &= ~0x10; cmd <<= 1;
        P5A_DR &= ~0x02; P5A_DR |= 0x02;
    }
    P_FB8D = 0xE3;                                    /* 03E8A2 SIO input   */
    do {
        u8 b = 0;
        for (u8 i = 8; i; --i) {                      /* 03E8B2 LSB first   */
            P5A_DR &= ~0x02; P5A_DR |= 0x02;
            b = (u8)((b >> 1) | ((P4D_PORT & 0x10) ? 0x80 : 0)); /* rotxr   */
        }
        *dst++ = b;                                   /* 03E8DA             */
    } while (--n);
    P5D_DR &= ~0x20;                                  /* 03E8E2 CE low      */
    P_FB8D = 0xF3;                                    /* 03E8F0             */
    P5A_DR &= ~0x02; P5D_DR &= ~0x10;                 /* 03E900             */
}

/* 03E90A-03E98E size 132  rtc_write (sub_3E90A)  Confirmed (bit flow).
 * 5 callers (rtc_init, 3E772, 3E7EE, sub_171D2, sub_44DA8).  r2l = cmd,
 * r6l = count, er5 = src (bytes shifted out LSB first).                  */
void rtc_write(u8 cmd, u8 n, const u8 *src)
{
    P5A_DR |= 0x02; P5D_DR |= 0x10; P5D_DR |= 0x20;   /* 03E90A             */
    for (u8 i = 8; i; --i) {
        if (cmd & 0x80) P5D_DR |= 0x10; else P5D_DR &= ~0x10; cmd <<= 1;
        P5A_DR &= ~0x02; P5A_DR |= 0x02;
    }
    do {
        u8 b = *src++;                                /* 03E948             */
        for (u8 i = 8; i; --i) {                      /* 03E94C shlr        */
            if (b & 1) P5D_DR |= 0x10; else P5D_DR &= ~0x10; b >>= 1;
            P5A_DR &= ~0x02; P5A_DR |= 0x02;
        }
    } while (--n);
    P5D_DR &= ~0x20; P5A_DR &= ~0x02; P5D_DR &= ~0x10;    /* 03E976         */
}

/* 03E728-03E772 size 74  rtc_init (sub_3E728)  Inferred.
 * Callers 3E772, sub_DEFA.  Status1 <- ROM 0x3E98E (reset), ~64-nop wait,
 * status1 <- ROM 0x3E98F, status2 <- ROM 0x3E990, time (7 bytes) <- ROM
 * 0x3E992 (default date/time).                                            */
void rtc_init(void)
{
    rtc_write(0x60, 1, (const u8 *)0x03E98E);
    for (u8 i = 0x40; i; --i) { /* 5 nops */ }        /* 03E736             */
    rtc_write(0x60, 1, (const u8 *)0x03E98F);
    rtc_write(0x62, 1, (const u8 *)0x03E990);
    rtc_write(0x64, 7, (const u8 *)0x03E992);
}

/* 03E772-03E7EE size 124  rtc_boot_check (sub_3E772)  Inferred.
 * No static caller.  Status1 & 0xC0 (power-on / low-battery flags) ->
 * save it in FF8EDE, rtc_init, and tone 0x1B when 89C4.b1.  Otherwise
 * read status2 and rewrite it from ROM 0x3E990 if it differs.  Then read
 * the time into FFA9C4, set A505 = B1C4 = 0x78, BA3D = 0x1E, clear A9DC.b0.*/
void rtc_boot_check(void)
{
    rtc_read(0x61, 1, &rtc_tmp);                      /* 03E772 FFA9D4      */
    if (rtc_tmp & 0xC0) {
        rtc_status_save = rtc_tmp;                    /* 03E78C FF8EDE      */
        rtc_init();
        if (set_89C4 & 0x02) tone_event = 0x1B;       /* 03E79A             */
    } else {
        rtc_read(0x63, 1, &rtc_tmp);                  /* 03E7AC             */
        if (rtc_tmp != *(const u8 *)0x03E990)
            rtc_write(0x62, 1, (const u8 *)0x03E990); /* 03E7C8             */
    }
    rtc_read_time(rtc_time);                          /* 03E7D2             */
    timer_A505 = timer_B1C4 = 0x78; timer_BA3D = 0x1E;/* 03E7D6..03E7E2     */
    rtc_int_hist &= ~0x01;                            /* 03E7E6             */
}

/* 03E7EE-03E828 size 58  rtc_set_alarm (sub_3E7EE)  Inferred.
 * No static caller.  Status2 <- ROM 0x3E991 (INT1 alarm mode); INT1
 * registers (cmd 0x68, 3 bytes) = {dow 0, hour | 0x80 (| 0x40 when hour
 * >= 0x12, PM flag), minute | 0x80} from the BCD word FF8988.            */
void rtc_set_alarm(void)
{
    rtc_write(0x62, 1, (const u8 *)0x03E991);         /* 03E7F8             */
    u8 hr = alarm_hm >> 8, mn = (u8)alarm_hm;         /* 03E7FC FF8988      */
    if (hr >= 0x12) hr |= 0x40;
    hr |= 0x80; mn |= 0x80;
    rtc_alarm[0] = 0; rtc_alarm[1] = hr; rtc_alarm[2] = mn;   /* FFA9CC..CE */
    rtc_write(0x68, 3, rtc_alarm);                    /* 03E822             */
}

/* 03E828-03E864 size 60  rtc_read_time (sub_3E828)  Inferred.
 * 4 callers.  6 bytes from cmd 0x65 into er5; masks byte 2 (day) and byte
 * 4 (hour, drops AM/PM flags) with 0x3F; byte 6 = 0; clears A505, B1C4,
 * BA3D, BADB.                                                             */
void rtc_read_time(u8 *t)
{
    rtc_read(0x65, 6, t);
    t[2] &= 0x3F; t[4] &= 0x3F; t[6] = 0;
    timer_A505 = timer_B1C4 = timer_BA3D = timer_BADB = 0;
}

/* ==========================================================================
 * 03E9F8-03E9FC  size 4    hw_reinit_then_standby  (sub_3E9F8)  Inferred.
 *   Caller sub_24B6.  jsr sub_20F6 (port/clock init, r1l = 1), falls into:
 * 03E9FC-03EA28  size 44   standby_entry   (sub_3E9FC)  Inferred.
 *   Caller reset_handler.  Band A (clear 8EA0.b6, 817E.b0, FF812A =
 *   [FF8122]), load R1 and the cal image, clear AA35.b2, join 03EA30.
 * 03EA28-03EBD6  size 430  charge_standby_loop   (sub_3EA28)  Inferred.
 *   No static caller (entry 3EA28 adds nullsub_25 + sub_56046).
 *   Hardware to a quiet state (sub_2F578/2F550/31072/3104A, low_power_
 *   modules, port bits, FFFF52.b7 off unless AA35.b2, DAC channels 0),
 *   timers 9534/9535 = 10, 9561 = 50, A999 = 0x28, sub_3490 (serial DAC),
 *   standby_ports_off, 817B.b5, sub_37A56.  Then a loop that calls
 *   sub_3466 (battery A/D; C set = leave) and sub_3576 (timer tick):
 *     - show charge levels via sub_694A, wait FF9561;
 *     - while FFFF42.b6 (charger status input, Inferred) ...;
 *     - charge phase: FF95F6 = 3600, FF95F4 = 39600 (11 h), A9DD = 1;
 *       per pass charge_level_hourly; FFFF42.b6 edges drive A9DF flags and
 *       FF9590 (0x3C) / charge_level_from_adc;
 *     - on timeout or both A9DF b0/b1: final level 2 (or 10 with A9DF.b7),
 *       sub_694A, FFFF52.b7 on, then wait until sub_3466 returns C.
 * ========================================================================== */
void standby_entry(void)
{
    band_sel &= ~0x40; ui_refresh_flags &= ~0x01;     /* 03E9FC             */
    bandA_rec = bandA_rec_store;                      /* 03EA08 FF8122      */
    eeprom_load_R1(); eeprom_load_cfgimg();           /* 03EA14 / 03EA18    */
    flags_AA35 &= ~0x04;                              /* 03EA20             */
    charge_standby_body();                            /* bra 03EA30         */
}
void charge_standby_loop(void)
{
    /* TODO(waveC): the loop's phases are summarised in the header; the
       exact meaning of FF9590, A9DF and FFFF42.b6 is unresolved. */
    charge_standby_body();
}

/* 03EBD6-03EC06 size 48  charge_level_hourly (sub_3EBD6)  Inferred.
 * If A9DE != 1, A9DD < 8 and FF95F6 has run out: reload 3600, A9DD++,
 * sub_694A(0) (redraw).                                                   */
void charge_level_hourly(void)
{
    if (charge_full == 1) return;
    if (charge_level >= 8) return;
    if (charge_step_timer != 0) return;
    charge_step_timer = 0x0E10;
    charge_level++;
    charge_show(0);                                   /* sub_694A           */
}

/* 03EC06-03EC3C size 54  charge_level_from_adc (sub_3EC06)  Inferred.
 * A9DE = 1; level = 2 + number of thresholds 0x2A, 0x27, ... (step 3, 8 of
 * them) that FF9590 is below; if level != 10 and level >= A9DD, store it
 * and redraw.                                                             */
void charge_level_from_adc(void)
{
    charge_full = 1;
    u8 lvl = 2, thr = 0x2A;
    for (u8 k = 8; k && charge_meas < thr; --k) { lvl++; thr -= 3; }
    if (lvl == 10) return;
    if (lvl < charge_level) return;
    charge_level = lvl; charge_show(0);
}

/* 03EC3C-03EC50 size 20  standby_ports_off (sub_3EC3C)  Inferred.
 * sub_38160 (display/driver off), clear FFFF5D b1/b0 and FFFBA5.b6.       */
void standby_ports_off(void)
{
    display_driver_off();                             /* sub_38160          */
    P5D_DR &= ~0x02; P5D_DR &= ~0x01; P_FBA5 &= ~0x40;
}

/* 03EC50-03ECB8 size 104  low_power_modules (sub_3EC50)  Confirmed (writes);
 * Inferred (register names).  Caller charge_standby_loop.  Interrupts off;
 * USB EE2D.b2 clear and EE04/05/06 = 0 (doc 05); DADR1 (FFFF69) = 0;
 * ~100 x 16-nop delay; DACR (FFFF6A) = 0x1F; MSTPCRA/B/C = 0x5CF4 /
 * 0xFFFF / 0x8D00 (stop unused modules); sub_284E (clock/port setup) and
 * sub_446BE (SCI-D re-init, doc 05); interrupts on.                       */
void low_power_modules(void)
{
    disable_interrupts();
    USB_EE2D &= ~0x04; USB_EE04 = USB_EE05 = USB_EE06 = 0;
    DA_DADR1 = 0;
    delay_nops(100 * 16);
    DA_DACR = 0x1F;
    MSTPCRA = 0x5CF4; MSTPCRB = 0xFFFF; MSTPCRC = 0x8D00;
    clock_port_setup();                               /* sub_284E           */
    sci_d_reinit();                                   /* sub_446BE          */
    enable_interrupts();
}

/* Market predicates (doc 50/59).  r4h = 1 on exit in each (callers use
 * the flags or r4l).
 * 03ECB8 market_is_0 (sub_3ECB8)        Z iff FF800F == 0.  19 callers.
 * 03ECC4 market_is_0_or_6 (sub_3ECC4)   Z iff FF800F in {0,6}; no caller.
 * 03ECD4 market_is_1 (sub_3ECD4)        Z iff FF800F == 1.
 * 03ECDE market_is_2_to_4 (sub_3ECDE)   r4l = 0 (Z) iff 2 <= FF800F <= 4.  */
int market_is_0(void)       { return market == 0; }
int market_is_0_or_6(void)  { return market == 0 || market == 6; }
int market_is_1(void)       { return market == 1; }
int market_is_2_to_4(void)  { return market >= 2 && market < 5; }

/* ==========================================================================
 * 03EDAA-03EDB2  size 8    cal_byte_ptr       (sub_3EDAA)
 * 03EDB2-03EE70  size 190  cal_byte_ptr_main  (sub_3EDB2)
 * 03EE70-03EE9A  size 42   cal_byte_ptr_alt   (sub_3EE70)
 * Confidence: Confirmed (doc 137 sec.5).  er0 = band record.
 * Returns er4 = address of the calibration byte for alignment item
 * FF97F8; FF97FF != 0 selects the alternate per-band map.  If FF94FE == 2
 * the code continues at 03ECF4 (outside chunk).
 * ========================================================================== */
u8 *cal_byte_ptr(const u8 *rec)
{
    if (align_alt_FF97FF) return cal_byte_ptr_alt(rec);
    return cal_byte_ptr_main(rec);
}
u8 *cal_byte_ptr_main(const u8 *rec)
{
    u8 *p; u8 it = align_item;                        /* FF97F8             */
    if (it == 0) { p = (u8 *)0xFF8056; goto out; }
    if (it == 0x10) { p = (u8 *)0xFF8059; goto out; }
    if (it == 0x11) {                                 /* 03EE46             */
        u8 b = rec[4];
        p = (b == 2) ? (u8 *)0xFF8079 : (b == 6) ? (u8 *)0xFF805E :
            (b == 8) ? (u8 *)0xFF807A : (u8 *)0xFF805F;
        goto out;
    }
    {
        u8 b = rec[4]; u32 off = 0;                   /* band offset        */
        if (b == 2) {
            if (it == 0x0C && rec[0x19] == 1) { p = (u8 *)0xFF8057; goto out; }
        } else off = (b == 6) ? 0x10 : (b == 8) ? 0x30 : 0x20;
        if (it >= 8 && it < 0x0F) p = (u8 *)0xFF8016 + off + it - 1;
        else p = ((band_sel & 0x40) ? (u8 *)0xFF8096 : (u8 *)0xFF8016) + off + it - 1;
    }
out:
    if (align_state_94FE == 2) return cal_byte_ptr_3ECF4(p);   /* 03EE40    */
    return p;
}
u8 *cal_byte_ptr_alt(const u8 *rec)
{
    u8 b = rec[4];
    u8 *p = (b == 2) ? (u8 *)0xFF805A : (b == 6) ? (u8 *)0xFF805B :
            (b == 8) ? (u8 *)0xFF805D : (u8 *)0xFF805C;
    return (align_state_94FE == 2) ? cal_byte_ptr_3ECF4(p) : p;
}

/* 03EE9A-03EEC4 size 42  cal_block_A (sub_3EE9A)  Confirmed (doc 137).
 * 03EEC4-03EEEE size 42  cal_block_B (sub_3EEC4)  Confirmed.
 * er3 = calibration block by rec+0x8E: < 3 -> +0x00, < 9 -> +0x10,
 * < 0xB -> +0x30, else +0x20; base FF8016 (A) / FF8096 (B).  Stored in
 * FF8162 / FF8166 by sub_2F69E / sub_3118C.                               */
u8 *cal_block_A(const u8 *rec)
{
    u8 v = rec[0x8E];
    return (u8 *)0xFF8016 + (v < 3 ? 0 : v < 9 ? 0x10 : v < 0xB ? 0x30 : 0x20);
}
u8 *cal_block_B(const u8 *rec)
{
    u8 v = rec[0x8E];
    return (u8 *)0xFF8096 + (v < 3 ? 0 : v < 9 ? 0x10 : v < 0xB ? 0x30 : 0x20);
}

/* ==========================================================================
 * 03EEEE-03EF2E  tone_class_3C70  (sub_3EEEE)   Confirmed (doc 136).
 * 03EF2E-03EF6E  tone_class_3C7C  (sub_3EF2E)   Confirmed.
 * 03EF6E-03EFAE  tx_tone_class    (sub_3EF6E)   Confirmed (doc 105/120).
 * 03EFAE-03EFEE  tone_class_3C94  (sub_3EFAE)   Confirmed.
 * 03EFEE-03F016  tone_class_3C94_b (sub_3EFEE)  Confirmed.
 * class = table[rec+0x16] (SQL TYPE index).  Returns 0 with r4h = 1 when
 * the edited side is digital: side B (817E.b0) with 8DD5 == 1 or
 * 8AA0 != 0 (APRS/data, doc 105); side A with 8D20 == 1.  The _b variant
 * tests only 8AA0 on side B and nothing on side A.  Each of the first
 * four has dead arms returning 7 and 3 (doc 115).
 * ========================================================================== */
static u8 tone_class(const u8 *rec, const u8 *tab)
{
    if (SIDE_B) { if (bandB_comm_mode == 1 || settings_R2[0] != 0) return 0; }
    else if (bandA_comm_mode == 1) return 0;
    return tab[rec[0x16]];
}
u8 tone_class_3C70(const u8 *rec) { return tone_class(rec, (const u8 *)0x3C70); }
u8 tone_class_3C7C(const u8 *rec) { return tone_class(rec, (const u8 *)0x3C7C); }
u8 tx_tone_class(const u8 *rec)   { return tone_class(rec, (const u8 *)0x3C88); }
u8 tone_class_3C94(const u8 *rec) { return tone_class(rec, (const u8 *)0x3C94); }
u8 tone_class_3C94_b(const u8 *rec)
{
    if (SIDE_B && settings_R2[0] != 0) return 0;
    return ((const u8 *)0x3C94)[rec[0x16]];
}

/* ==========================================================================
 * Memory-slot stepping.  er6 -> { u16 lo, hi; u16 *slot }; er0 = record.
 * A9EE.b0 = direction down.  Wrapping clears AAE1.b2.
 * 03F016-03F04A  mem_step_up_bank  (sub_3F016)  Confirmed.
 *   Up: step until the attribute is valid (attr & 3 == 3) and has b6
 *   (bank / preferential, Inferred).  Down twin at 03F04A (outside).
 * 03F068-03F076  mem_step_store_check (sub_3F068)  Confirmed.  Tail of the
 *   down twin: store slot, test, loop back to 03F04A.
 * 03F076-03F110  mem_step_skip  (sub_3F076)  Confirmed.  Up or down,
 *   skipping slots with attr.b7 (skip flag); FFACD7 = 0xFF when the walk
 *   returns to the starting slot FF94CA.
 * 03F110-03F164  mem_step_valid (sub_3F110)  Confirmed.  Up or down to the
 *   next valid slot.
 * ========================================================================== */
typedef struct { u16 lo, hi; u16 *slot; } step_ctl;
static u16 step_once(const step_ctl *c, int down)
{
    u16 s = *c->slot;
    if (!down) { if (s >= c->hi) { s = c->lo; audio_route_flags &= ~0x04; } else s++; }
    else       { if (s <= c->lo) { s = c->hi; audio_route_flags &= ~0x04; } else s--; }
    *c->slot = s;
    return s;
}
void mem_step_up_bank(u8 *rec, const step_ctl *c)
{
    if (scan_dir & 0x01) { mem_step_down_bank_3F04A(rec, c); return; }
    for (;;) {
        u16 s = step_once(c, 0);
        u8 a = mem_attr_of_slot(rec, s);
        if ((a & 3) == 3 && (a & 0x40)) return;
    }
}
void mem_step_skip(u8 *rec, const step_ctl *c)
{
    int down = scan_dir & 0x01;
    scan_wrapped = 0;                                 /* 03F076             */
    scan_start = *c->slot;                            /* 03F084 FF94CA      */
    for (int first = 1;; first = 0) {
        if (!first && *c->slot == scan_start) { scan_wrapped = 0xFF; return; }
        u16 s = step_once(c, down);
        u8 a = mem_attr_of_slot(rec, s);
        if ((a & 3) == 3 && !(a & 0x80)) return;
    }
}
void mem_step_valid(u8 *rec, const step_ctl *c)
{
    int down = scan_dir & 0x01;
    for (;;) {
        u16 s = step_once(c, down);
        if ((mem_attr_of_slot(rec, s) & 3) == 3) return;
    }
}

/* ==========================================================================
 * 03F164-03F172  mem_attr_of_packed (sub_3F164)  Confirmed.
 *   r3 = packed word: area = (r3h & 0x78) >> 3, slot = r3 & 0x7FF; then
 *   mem_attr_lookup.
 * 03F172-03F184  mem_attr_of_slot   (sub_3F172)  Confirmed.  28 callers.
 *   Regular lookup unless (!AA31.b4 && rec+5 == 2 (memory mode)), in which
 *   case the area comes from vfo_mem_group (falls into 03F184).
 * 03F184-03F1C4  mem_attr_lookup    (sub_3F184)  Confirmed.
 *   area 0 -> FF8188[slot]; area 6 -> loc_22212; area 8 -> loc_22276;
 *   other -> FF8188[slot + mem_area_base[area]].  Returns r4l = attr and
 *   Z iff (attr & 3) == 3 (valid).
 * ========================================================================== */
u8 mem_attr_lookup(u16 slot, u8 area)
{
    if (area == 0) return mem_attr[slot];
    if (area == 6) return area6_attr_22212(slot);
    if (area == 8) return area8_attr_22276(slot);
    return mem_attr[(u16)(slot + mem_area_base[area])];
}
u8 mem_attr_of_slot(const u8 *rec, u16 slot)
{
    if ((flags_AA31 & 0x10) || rec[5] != 2) return mem_attr[slot];
    return mem_attr_lookup(slot, vfo_mem_group(rec));
}
u8 mem_attr_of_packed(u16 w)
{
    return mem_attr_lookup(w & 0x07FF, (u8)((w >> 11) & 0x0F));
}
