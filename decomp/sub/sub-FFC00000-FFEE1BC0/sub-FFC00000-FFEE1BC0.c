/* ============================================================================
 * sub-FFC00000-FFEE1BC0.c  -  Hand-reconstructed C for SUB (RX64M) range
 *                             FFC00000 (reset) + FFEDAB4C..FFEE1BC0.
 * Lane sub-FFC00000-FFEE1BC0, C-reconstruction wave C.
 *
 * DOCUMENTATION ONLY.  By-hand transcription of the IDA listing of
 * decrypted\FT3D_SUB_ver102_ALL.bin (RX64M, CC-RX, little-endian, mapped at
 * 0xFFC00000).  Nothing compiled or run.  Static analysis only.
 *
 * ABI (CC-RX): args r1..r4, return r1, r6..r13 callee-saved, r0 = SP.
 * IDA RX display traps that matter here (doc BRIEF item 4, doc 84, doc 109):
 *   - `mov.l #-NNh,rX` / `cmp #-NNh,rX` / `mov.w #-NNh,dsp[rX]` on the 75 4x /
 *     75 5x / 3D xx forms are UNSIGNED 8-bit immediates that IDA prints signed.
 *     So #-1 = 0xFF, #-2 = 0xFE, #-10h = 0xF0 (240), #-11h = 0xEF (239),
 *     #-20h = 0xE0, #-1Fh = 0xE1, #-1Dh = 0xE3, #-1Eh = 0xE2, #-0Dh = 0xF3,
 *     #-4Ch = 0xB4 (180), #-26h = 0xDA (218), #-70h = 0x90, #-40h = 0xC0.
 *     Where the encoding is a true simm16 (e.g. PRCR #-5AFEh) the sign-
 *     extended value is meant (0xA502).
 *   - Arithmetic with an unsuffixed memory operand (`and [r15],r14`,
 *     `tst 4[r14],r15`) is the .UB memex form, i.e. a byte read.
 *
 * Subsystems in this range (address order):
 *   1. reset entry (PowerON_Reset_PC)
 *   2. generic 3-channel SCI ring driver (SCI0 = MAIN link 500 kbit/s,
 *      SCI2 = GPS 9600, SCI3 = Bluetooth 115200)  - docs 14, 02, 109
 *   3. MAIN<->SUB link layer: deframer, frame dispatcher, 4-slot queue,
 *      SUB->MAIN frame builders E0/E1/E2/E3/FF/FE/EA  - docs 51, 84, 109, 43
 *   4. LCD panel driver (ILI934x-class command set on CS5 0x06000000) and
 *      LCD power sequencer - doc 51 sec.4
 *   5. Picture (screen 0x3E: FFFF block image -> JPEG decode -> blit) and
 *      alignment (screen 0x3F, FD00) screen state machines - docs 30, 137
 *   6. UI phase machine, IPC opcode->screen classifier (F0..FF) - docs 25, 43
 *   7. GPS: power, NMEA assembler/parsers, $PMTK sequencer - doc 14
 *   8. 5.46 ms TPU0 tick, software timers, resistive touch panel - doc 84
 *   9. CC-RX low-level I/O runtime (lowsrc.c: _INIT_IOLIB, open, write...)
 *
 * Globals are declared once below with their RAM address.  Names reuse the
 * docs where a name exists.  Offsets from the link control block 0x12D44
 * are given both ways (base+disp = absolute).
 * ========================================================================== */

#include <stdint.h>
typedef uint8_t  u8;  typedef int8_t  s8;
typedef uint16_t u16; typedef int16_t s16;
typedef uint32_t u32; typedef int32_t s32;

#define REG8(a)   (*(volatile u8  *)(a))
#define REG16(a)  (*(volatile u16 *)(a))
#define REG32(a)  (*(volatile u32 *)(a))

/* ---------------------------------------------------------------- I/O ---- */
/* SCI channels (SMR+0 BRR+1 SCR+2 TDR+3 SSR+4 RDR+5 SCMR+6 SEMR+7)        */
#define SCI0_BASE   0x0008A000u          /* ch0: MAIN link                 */
#define SCI2_BASE   0x0008A040u          /* ch1: GPS receiver              */
#define SCI3_BASE   0x0008A060u          /* ch2: Bluetooth module          */
#define SCR_TIE   0x80   /* SCR bits: TIE b7, RIE b6, TE b5, RE b4, TEIE b2 */
#define SCR_RIE   0x40
#define SCR_TE    0x20
#define SCR_RE    0x10
#define SCR_TEIE  0x04
#define SSR_ERRS  0x38   /* ORER|FER|PER                                    */
/* ICU (IR 0x87000+v, IER 0x87200+v/8, IPR 0x87300+v, GRPBL0 0x87630,
 * GENBL0 0x87670, SLIBXR 0x87700+v)                                         */
#define ICU_IR(v)     REG8(0x00087000u + (v))
#define ICU_IER(n)    REG8(0x00087200u + (n))
#define ICU_IPR(v)    REG8(0x00087300u + (v))
#define ICU_GRPBL0    REG32(0x00087630u)
#define ICU_GENBL0    REG32(0x00087670u)
#define ICU_SLIBXR(v) REG8(0x00087700u + (v))
/* TPU: TSTR 0x88100; TPU0 regs at 0x88110 (TCR,TMDR,TIORH,TIORL,TIER,TSR=+5,
 * TCNT=+6,TGRA=+8); TPU2 at 0x88130; TPU3 TSR 0x88145 (vector 136)          */
#define TPU_TSTR      REG8(0x00088100u)
#define TPU0          0x00088110u
#define TPU2          0x00088130u
/* S12AD1 (touch ADC): ADCSR +0, ADANSA0 +4, ADANSA1 +6, ADADS0 +8, ADADS1 +A,
 * +0x0E (ADCER), ADDR18 +0x44, ADDR19 +0x46                                 */
#define S12AD1        0x00089100u
/* Ports: PODR = 0x8C020 + port (P1=..21, P2=..22, P5=..25, P7=..27, P8=..28),
 * PMR 0x8C060+port, MPC.PWPR 0x8C11F, P00PFS 0x8C140, P01PFS 0x8C141        */
#define P1_PODR       REG8(0x0008C021u)   /* b5 GPS power, b7 ext ctl (frame+7 b2) */
#define P2_PODR       REG8(0x0008C022u)
#define P5_PODR       REG8(0x0008C025u)   /* touch drive lines P54/P55/P56   */
#define P7_PODR       REG8(0x0008C027u)   /* b3 LCD RESX                     */
#define P8_PODR       REG8(0x0008C028u)   /* b2 LCD D/CX strobe, b3 touch P83 */
#define LCD_PORT      (*(volatile u8  *)0x06000000u)  /* CS5 LCD controller   */
#define LCD_PORT16    (*(volatile u16 *)0x06000000u)
#define EXDMAC_STAT   REG8(0x0008281Eu)   /* b7 busy (doc 51 open item 2), b4 */

/* ------------------------------------------------------- external RAM ---- */
#define JPEG_IN_BUF   ((u8  *)0x070E1000u)   /* image staging, 0x14000 bytes   */
#define FRAMEBUF_DEC  ((u16 *)0x070BB800u)   /* decode target, 320x240 RGB565  */
#define JPEG_WORK     ((u8  *)0x070F5000u)   /* decoder work area 0x69C        */

/* --------------------------------------------------------- SCI driver ---- */
typedef struct {                 /* 0x12CD8 + ch*0x18                        */
    u16  flags;                  /* +00 b0 = TX open, b8 = RX open           */
    u8  *rx_buf;                 /* +04  (ROM table 0xFFECE4E8 row +0)        */
    u8  *tx_buf;                 /* +08  (row +4)                             */
    u16  rx_size;                /* +0C  (row +8)                             */
    u16  tx_size;                /* +0E  (row +A)                             */
    u16  tx_head;                /* +10 written by sci_write                  */
    u16  tx_tail;                /* +12 read by the TXI/TEI callback          */
    u16  rx_head;                /* +14 written by the RXI callback           */
    u16  rx_tail;                /* +16 read by sci_read                      */
} sci_chan_t;
typedef u16 (*sci_cb_t)(u32 id, u8 *buf, u16 n);
typedef struct {                 /* 0x12D20 + ch*0x0C                        */
    sci_cb_t tx_cb;              /* +0 fetch next TX byte(s) (= sci_tx_ring_fetch) */
    sci_cb_t rx_cb;              /* +4 store RX byte(s)     (= sci_rx_ring_store)  */
    u16      tx_id;              /* +8 channel id passed back to tx_cb        */
    u16      rx_id;              /* +A                                         */
} sci_cbs_t;
typedef struct { u16 rate_div100; u8 data_bits, stop_bits, parity, flow; } sci_cfg_t;

extern sci_chan_t sci_chan[3];          /* 0x00012CD8 */
extern sci_cbs_t  sci_cb[3];            /* 0x00012D20 */
extern u8         sci0_scr_shadow;      /* 0x00008A84  SCR0 copy written by sci0_rx_open */
extern const sci_cfg_t sci_cfg_rom[2];  /* 0xFFC3EB44  ch0 {0x1388,8,1,0,0}, ch1 {0x0060,8,1,0,0} */
extern const u8   sci_cfg_ch2_rom[6];   /* 0xFFF483C8  {0x0480,8,1,0,0} (copied to stack) */
extern const struct { u8 *rx; u8 *tx; u16 rx_size, tx_size; } sci_ring_rom[3]; /* 0xFFECE4E8 */
extern const u8   sci_smr_brr_rom[18];  /* 0xFFC00100  9 (SMR,BRR) pairs, doc 14 table */

/* -------------------------------------------------------- link layer ----- */
#define LINK            0x00012D44u
extern u32  link_rx_state;              /* 0x00012D44 (+0)  deframer state 0..9 */
extern u8   link_rx_byte;               /* 0x00012D48 (+4)  one-byte read buffer */
extern u8   link_frame[0x8001];         /* 0x00012D49 (+5)  frame being assembled; [0]=op hi */
extern u16  link_frame_cnt;             /* 0x0001AD4A (+8006) bytes stored        */
extern u16  link_frame_len;             /* 0x0001AD4C (+8008) length field (+2)   */
extern u16  link_sum_calc;              /* 0x0001AD4E (+800A) running byte sum     */
extern u16  link_sum_recv;              /* 0x0001AD50 (+800C) received checksum    */
extern u16  link_q_len[4];              /* 0x0001AD52 (+800E) queued frame lengths */
extern u8   link_q_slot[4][300];        /* 0x0001AD5A (+8016) 4 x 0x12C slots      */
extern u8   link_q_wr;                  /* 0x0001B20A (+84C6) */
extern u8   link_q_rd;                  /* 0x0001B20B (+84C7) */
extern u8   link_echo[2];               /* 0x0001B20C (+84C8) last MAIN opcode (hi,lo) */
extern u8   link_payload[0x12C];        /* 0x0001B20E (+84CA) staging for sub2main_frame_a */
extern u8   link_txbuf_a[0x800];        /* 0x0001B33A (+85F6) */
extern u8   link_txbuf_b[0x800];        /* 0x0001BB3A (+8DF6) */
extern u8   link_txbuf_c[0x80];         /* 0x0001C33A (+95F6) doc 109 prints 0x2433A: arithmetic slip */
extern u8   link_txbuf_d[0x80];         /* 0x0001C3BA (+9676) doc 109 prints 0x243BA: arithmetic slip */
extern u8   link_txbuf_fe[0x800];       /* 0x0001C43A (+96F6) */
extern u16  blk_cur;                    /* 0x0001CC3A (+9EF6) current FFFF block no. */
extern u16  blk_total;                  /* 0x0001CC3C (+9EF8) */
extern u32  blk_bytes;                  /* 0x0001CC40 (+9EFC) bytes received so far */
extern u32  blk_sum;                    /* 0x0001CC44 (+9F00) running 32-bit sum    */
extern u32  blk_expect;                 /* 0x0001CC48 (+9F04) sum sent by MAIN      */
extern u32  blk_state;                  /* 0x0001CC4C 0 idle,1 rx,2 ok,3 error      */
extern u32  link_timer_grp;             /* 0x0001CC50 swtimer group of the link     */
extern u16  link_byte_timer;            /* 0x0001230A inter-byte timeout counter     */
extern const u16 link_timer_reload[1];  /* 0xFFC3EB7E */
extern u8   gpslog_g_seen;              /* 0x0001217E */
extern u8   blk_last_lo;                /* 0x0001217F last FF-frame low byte notified */
extern u8   tpu3_slow_mode;             /* 0x00012180 TPU3 reprogrammed (doc 109 sec.3) */
extern u8   gps_relay_block;            /* 0x00008A86 doc 109 "0x8A86 gate"         */
extern u8   gpslog_state;               /* 0x00010C65 1 = GPS log active (SD task)  */
extern u8   pending_frame[300];         /* 0x00008E46 latest dequeued MAIN frame    */
extern u8   frame_shadow[300];          /* 0x00008C4D applied shadow (doc pc-04)    */

/* ------------------------------------------------- display / screens ----- */
extern u8   lcd_seq[3];                 /* 0x00008A87 [0]=state 0..8 [1]=done [2]=substep */
extern u8   lcd_display_on;             /* 0x00008A8A */
extern s8   picture_state;              /* 0x00008A8B 0 none,1 transfer done,2 decoded */
extern u8   screen_id;                  /* 0x00008A8C current UI screen (table 0xFFED4050) */
extern u8   screen_id_prev;             /* 0x00008A8D */
extern u8   screen_valid;               /* 0x00008A8E classifier produced a screen   */
extern u8   ui_wake_req;                /* 0x00008A8F */
extern u8   mode_byte_saved;            /* 0x00008A90 copy of frame byte +0x13       */
extern u8   screen_step;                /* 0x00008C4C per-screen sub-state           */
extern u8   ui_8D79, ui_8D7A, ui_8D7B, ui_8D7C, ui_8D7D; /* 0x00008D79..7D UI flags   */
extern u8   ui_8F72;                    /* 0x00008F72 frame byte +7 bit0             */
extern u8   ui_event;                   /* 0x00008F73 touch/key event code (0xFF none) */
extern u8   ui_8F74;                    /* 0x00008F74 */
extern u32  ui_phase;                   /* 0x0001CC60 0 power-up,1 wait,2 run,3 idle */
extern u8   last_waiting_state;         /* 0x00012181 */
extern u16  jpeg_wh[2];                 /* 0x0001230C decoded image width,height     */
extern u32  jpeg_len;                   /* 0x0001CC58 bytes consumed by the decoder   */
extern u8   align_labels[16][16];       /* 0x00012182 RAM copy of FFED8E74 (doc 137) */
extern u8   render_state[16];           /* 0x0001D3A0 */
extern u8   fb_surface[];               /* 0x0001D3B8 320x240 surface descriptor     */
typedef void (*fn_t)(void);
extern const fn_t lcd_seq_tbl[4];       /* 0xFFECE50C {nop,power_on,display_on,blank} */
extern const fn_t ui_phase_tbl[4];      /* 0xFFED4040 */
extern const fn_t screen_tbl[];         /* 0xFFED4050 indexed by screen_id           */
extern const fn_t picture_step_tbl[8];  /* 0xFFED3F6C */
extern const fn_t picture_event_tbl[5]; /* 0xFFED3F8C */
extern const fn_t align_step_tbl[4];    /* 0xFFED3FA0 */
extern const fn_t align_event_tbl[0x24];/* 0xFFED3FB0 */

/* --------------------------------------------------------------- GPS ----- */
typedef struct {                        /* 0x0001CC90, 0x10C bytes, ROM default 0xFFED417C */
    u8  date[3];        /* +00 yy,mm,dd (RMC)                 */
    u8  time[3];        /* +03 hh,mm,ss (RMC)                 */
    u8  hemi;           /* +06 b1 = S, b0 = W                 */
    u8  lat_deg, lat_min, lon_deg, lon_min;    /* +07..+0A    */
    u8  pad0b;
    u16 lat_frac_bcd;   /* +0C 4 BCD digits of minutes, F=missing */
    u16 lon_frac_bcd;   /* +0E */
    u16 course_bcd1;    /* +10 BCD, 1 implied decimal          */
    u16 speed_bcd1;     /* +12 knots, BCD x10                   */
    u16 magvar_bcd1;    /* +14 */
    u8  magvar_w;       /* +16 */
    u8  pad17;
    u32 fix_quality;    /* +18 GGA 0/1/2                        */
    u8  sats_used;      /* +1C */
    u8  alt_negative;   /* +1D */
    u16 altitude_m;     /* +1E integer part                     */
    u32 fix_type;       /* +20 GSA 0 none,1 2D,2 3D             */
    u8  prn_used[12];   /* +24 */
    u8  sats_in_view;   /* +30 */
    u8  pad31;
    struct { u8 prn, elev; u16 az_bcd1; u8 snr, used; } sat[36]; /* +32 stride 6 */
} gps_fix_t;
extern gps_fix_t gps_fix;               /* 0x0001CC90 */
extern const gps_fix_t gps_fix_default; /* 0xFFED417C */
extern u32  gps_power;                  /* 0x0001CC64 0 off,1 on,2 off(commanded) */
extern u32  gps_init_step;              /* 0x0001CC68 0..3 index into $PMTK init list, 4 = done */
extern u32  gps_datum_step, gps_datum_cur, gps_datum_req;   /* 0x1CC6C/70/74 */
extern u32  gps_nav_step,   gps_nav_cur,   gps_nav_req;     /* 0x1CC78/7C/80 */
extern u32  gps_dgps_step,  gps_dgps_cur,  gps_dgps_req;    /* 0x1CC84/88/8C */
extern u32  nmea_rx_state;              /* 0x0001CDD0 0 hunt,1 body,2 cksum,3 complete */
extern u32  gps_valid[3];               /* 0x0001CDD4 RMC, GGA, GSV data fresh        */
extern u32  gps_timer_grp;              /* 0x0001CDE0 */
extern u8   gps_cold_req;               /* 0x00008A91 */
extern u8   gps_warm_req;               /* 0x00008A92 no-fix timeout -> $PMTK102      */
extern char nmea_line[256];             /* 0x00008A93 raw sentence incl. '$'          */
extern u8   nmea_xor;                   /* 0x00008B93 */
extern u8   nmea_rx_cksum;              /* 0x00008B94 */
extern u8   nmea_cksum_digits;          /* 0x00008B95 */
extern char nmea_field[32];             /* 0x00008B96 current field (not NUL-terminated) */
extern char pmtk_txbuf[64];             /* 0x00008BB6 */
extern u16  nmea_len;                   /* 0x000124C0 */
extern u16  nmea_cursor;                /* 0x000124C2 */
extern u16  gps_valid_ttl[3];           /* 0x000124C4 */
extern u16  gps_timer[3];               /* 0x000124CA counters of gps_timer_grp       */
extern u16  gps_nofix_cnt;              /* 0x000124D0 */
extern u16  gps_nofix_reload;           /* 0x000124D2 60 after a fix, 180 at start    */
extern const u16 gps_timer_reload[3];   /* 0xFFEB74D8 */
extern u8   gsv_work[4 + 0xDA];         /* 0x000123E2 {total,msgno,n,pad, sat block}  */
extern u8   rmc_work[0x1C];             /* 0x0001CD9C */
extern u8   gga_work[0x18];             /* 0x0001CDB8 */
extern const char *const pmtk_init[4];  /* 0xFFED4288 "$PMTK313,1", "$PMTK314,...", "$PMTK225,0", "$PMTK286,1" */
extern const char *const pmtk_datum[];  /* 0xFFED4298 {"", "$PMTK330,0", ...}  */
extern const char *const pmtk_nav[];    /* 0xFFED42B0 {"", "$PMTK386,0.6", "$PMTK386,1.0"} */
extern const char *const pmtk_dgps[];   /* 0xFFED42BC {"", "$PMTK301,0", ",1", ",2"} */

/* ------------------------------------------------ tick / timers / touch -- */
typedef struct { u16 count; u16 *ctr; const u16 *reload; } swtimer_grp_t;
extern swtimer_grp_t swtimer[4];        /* 0x0001CDE4 stride 0xC */
extern volatile u16 tick_pending;       /* 0x000124D4 */
extern u8   touch_state;                /* 0x00008BF6 1 detect,2 X,3 Y */
extern u8   touch_ring_idx;             /* 0x00008BF7 */
extern u8   touch_press_cnt;            /* 0x00008BF8 */
extern u8   touch_release_cnt;          /* 0x00008BF9 */
extern u8   touch_pair_ok;              /* 0x00008BFA */
extern u16  touch_ring[4][2];           /* 0x000124D6 */
extern u16  touch_cur[2];               /* 0x000124E6 */
extern u16  touch_last[2];              /* 0x000124EA X, 0x000124EC Y */

/* --------------------------------------------------------- runtime ------- */
extern u8   rt_fd_mode[3];              /* 0x00008BFB */
extern void *rt_iob_ptr[3];             /* 0x0001CE14 -> 0x696B0/0x696F8/0x69740 */
extern u8   *rt_heap_ptr;               /* 0x00068758 */
extern u8   rt_heap[0x400];             /* 0x0001CE64 */
extern const s32 rt_nfiles;             /* 0xFFED8974 (doc 68: stream count 20) */

/* ============================================================================
 * 1. RESET
 * ========================================================================== */

/* ----------------------------------------------------------------------------
 * FFC00000-FFC0003C (60 B)  reset_entry  [IDA: reset_handler]   Confirmed
 * Fixed reset vector target.  CC-RX sample PowerON_Reset_PC (doc compiler.md):
 * USP=0x6A8FC, ISP=0x6B8FC, EXTB=0xFFFFFF80, INTB=0xFFED8A70, FPSW=0x100,
 * _INITSCT (sub_FFF45DBC), PSW=0x10000 (user stack, I=0), main(0)
 * (sub_FFF36C53), then brk.
 * ------------------------------------------------------------------------- */
void reset_entry(void)
{
    __set_usp(0x0006A8FC);
    __set_isp(0x0006B8FC);
    __set_extb(0xFFFFFF80);
    __set_intb(0xFFED8A70);
    __set_fpsw(0x00000100);
    _INITSCT();                         /* sub_FFF45DBC: .data copy / .bss clear */
    __set_psw(0x00010000);
    sub_main(0);                        /* sub_FFF36C53 (never returns)          */
    __brk();
}

/* ============================================================================
 * 2. SCI RING DRIVER  (doc 14 sec.1, doc 02, doc 109 sec.1)
 * Three logical channels 0/1/2 -> SCI0/SCI2/SCI3.  Each SCI has its own
 * open/close/kick/ISR set; the ring logic is shared and reached through the
 * callback block sci_cb[] (0x12D20).
 * ========================================================================== */

/* ----------------------------------------------------------------------------
 * FFEDAB4C-FFEDAC17 (203 B)  sci_init_all  [sub_FFEDAB4C]   Confirmed
 * Callers: sub_main (FFF36C53).  Copies the ch2 config from ROM FFF483C8 to
 * the stack, runs the pin/ICU/SCI reset, programs the three line formats and
 * fills the three ring descriptors from ROM table 0xFFECE4E8.
 * ------------------------------------------------------------------------- */
void sci_init_all(void)
{
    sci_cfg_t cfg2;
    s32 ch;
    memcpy(&cfg2, sci_cfg_ch2_rom, 6);   /* {0x0480 (115200), 8, 1, 0, 0}      */
    sci_hw_init();                       /* FFEDB300 */
    sci0_set_format(&sci_cfg_rom[0]);    /* 0x1388 -> 500000 8N1 */
    sci2_set_format(&sci_cfg_rom[1]);    /* 0x0060 -> 9600 8N1   */
    sci3_set_format(&cfg2);
    for (ch = 0; ch < 3; ch++) {
        sci_chan[ch].flags   = 0;
        sci_chan[ch].rx_buf  = sci_ring_rom[ch].rx;
        sci_chan[ch].tx_buf  = sci_ring_rom[ch].tx;
        sci_chan[ch].rx_size = sci_ring_rom[ch].rx_size;
        sci_chan[ch].tx_size = sci_ring_rom[ch].tx_size;
        sci_chan[ch].tx_head = sci_chan[ch].tx_tail = 0;
        sci_chan[ch].rx_head = sci_chan[ch].rx_tail = 0;
    }
}

/* ----------------------------------------------------------------------------
 * FFEDAC17-FFEDAD26 (271 B)  sci_channel_enable(ch, mask)  [sub_FFEDAC17]
 * Confirmed.  Callers: link_init (ch0, 0x101), gps_set_power (ch1, 0x101),
 * sub_FFF395DF Bluetooth init (ch2).  mask bit0 = open TX, bit8 = open RX.
 * Each side is opened only if not already open; it resets that side's ring
 * indices and registers sci_tx_ring_fetch / sci_rx_ring_store with the SCI.
 * ------------------------------------------------------------------------- */
void sci_channel_enable(u32 ch, u16 mask)
{
    u16 f;
    if (ch > 2) return;
    f = sci_chan[ch].flags;
    if (!(f & 0x0001) && (mask & 0x0001)) {
        sci_chan[ch].tx_head = sci_chan[ch].tx_tail = 0;
        switch (ch) {
        case 0: sci0_tx_open(0, sci_tx_ring_fetch); break;   /* FFEDB63A */
        case 1: sci2_tx_open(1, sci_tx_ring_fetch); break;   /* FFEDBA44 */
        case 2: sci3_tx_open(2, sci_tx_ring_fetch); break;   /* FFEDBEB2 */
        }
        sci_chan[ch].flags |= 0x0001;
    }
    if (!(f & 0x0100) && (mask & 0x0100)) {
        sci_chan[ch].rx_head = sci_chan[ch].rx_tail = 0;
        switch (ch) {
        case 0: sci0_rx_open(0, sci_rx_ring_store); break;   /* FFEDB6BD */
        case 1: sci2_rx_open(1, sci_rx_ring_store); break;   /* FFEDBAC8 */
        case 2: sci3_rx_open(2, sci_rx_ring_store); break;   /* FFEDBF3F */
        }
        sci_chan[ch].flags |= 0x0100;
    }
}

/* ----------------------------------------------------------------------------
 * FFEDAD26-FFEDAE05 (223 B)  sci_channel_disable(ch, mask)  [sub_FFEDAD26]
 * Confirmed.  Callers: gps_set_power, gps_power_off (ch1, 0x101).  Mirror of
 * sci_channel_enable: closes TX/RX on the SCI and clears the open flag.
 * ------------------------------------------------------------------------- */
void sci_channel_disable(u32 ch, u16 mask)
{
    u16 f;
    if (ch > 2) return;
    f = sci_chan[ch].flags;
    if ((f & 0x0001) && (mask & 0x0001)) {
        sci_chan[ch].tx_head = sci_chan[ch].tx_tail = 0;
        switch (ch) { case 0: sci0_tx_close(); break;
                      case 1: sci2_tx_close(); break;
                      case 2: sci3_tx_close(); break; }
        sci_chan[ch].flags &= 0xFFFE;
    }
    if ((f & 0x0100) && (mask & 0x0100)) {
        sci_chan[ch].rx_head = sci_chan[ch].rx_tail = 0;
        switch (ch) { case 0: sci0_rx_close(); break;
                      case 1: sci2_rx_close(); break;
                      case 2: sci3_rx_close(); break; }
        sci_chan[ch].flags &= 0xFEFF;
    }
}

/* ----------------------------------------------------------------------------
 * FFEDAE05-FFEDAF2D (296 B)  sci_config_from_string(ch, str)  [dead_FFEDAE05]
 * Confirmed (unreached: no caller, doc 46/133).  Parses
 * "<rate/100>,<bits>,<stop>,<parity>,<flow>" (doc 14): up to 6 rate digits
 * before ','; unknown rates fall back to 0x60 (9600).  '7' -> 7 data bits,
 * '2' -> 2 stop, 'O' -> parity 1 (odd), 'E' -> 2 (even), 'H' -> flow 1,
 * 'X' -> flow 2.  Each later field is assumed to be one char + ','.
 * Channel 2 is ignored.
 * ------------------------------------------------------------------------- */
void sci_config_from_string(u32 ch, const char *s)
{
    sci_cfg_t c;
    u16 v = 0;
    u8 i;
    if (ch > 2) return;
    for (i = 0; i < 6; i++) {
        if (s[i] == ',') { i++; break; }
        v = v * 10 + (u8)s[i] - '0';
    }
    switch (v) {
    case 0x1388: case 0x0090: case 0x00C0: case 0x0180:
    case 0x01E0: case 0x09C4: case 0x0030: c.rate_div100 = v; break;
    default:                                c.rate_div100 = 0x0060; break;
    }
    c.data_bits = (s[i] == '7') ? 7 : 8;  i += 2;
    c.stop_bits = (s[i] == '2') ? 2 : 1;  i += 2;
    c.parity    = (s[i] == 'E') ? 2 : (s[i] == 'O') ? 1 : 0;  i += 2;
    c.flow      = (s[i] == 'X') ? 2 : (s[i] == 'H') ? 1 : 0;
    if (ch == 0)      sci0_set_format(&c);
    else if (ch == 1) sci2_set_format(&c);
}

/* ----------------------------------------------------------------------------
 * FFEDAF2D-FFEDB081 (340 B)  sci_write(ch, src, len) -> u16  [sub_FFEDAF2D]
 * Confirmed.  Callers: sub2main_frame_a/b/c/d, sub2main_send_fe_record
 * (ch0), gps_send_pmtk (ch1), sub_FFF3B630 Bluetooth printf (ch2).
 * Copies len bytes into the TX ring.  When the ring is full it calls the
 * channel's kick (which starts the TXI chain) and spins until space frees:
 * a busy-wait (doc 109).  After the copy it kicks once more and returns a
 * ring level.  NOTE: the returned level is computed inconsistently - for
 * head >= tail it is (size - head + tail) i.e. FREE space, for head < tail it
 * is (size - tail + head) i.e. USED space.  The same slip is in
 * sci_rx_ring_level.  No caller uses the value for anything critical.
 * ------------------------------------------------------------------------- */
u16 sci_write(u32 ch, const u8 *src, u16 len)
{
    sci_chan_t *c;
    u16 i, next, lvl = 0;
    if (ch > 2) return 0;
    c = &sci_chan[ch];
    if (!(c->flags & 0x0001)) return 0;
    for (i = 0; i < len; ) {
        next = c->tx_head + 1;
        if (next >= c->tx_size) next = 0;
        if (next != c->tx_tail) {
            c->tx_buf[c->tx_head] = src[i];
            c->tx_head = next;
            i++;
        } else {                               /* ring full: kick and retry */
            switch (ch) { case 0: sci0_tx_kick(); break;
                          case 1: sci2_tx_kick(); break;
                          case 2: sci3_tx_kick(); break; }
        }
    }
    if (c->tx_head >= c->tx_tail) lvl = c->tx_size - c->tx_head + c->tx_tail;
    else                          lvl = c->tx_size - c->tx_tail + c->tx_head;
    switch (ch) { case 0: sci0_tx_kick(); break;
                  case 1: sci2_tx_kick(); break;
                  case 2: sci3_tx_kick(); break; }
    return lvl;
}

/* ----------------------------------------------------------------------------
 * FFEDB081-FFEDB131 (176 B)  sci_tx_ring_fetch(ch, dst, n) -> u16
 * [sub_FFEDB081]  Confirmed.  Registered as every SCI's tx_cb by
 * sci_channel_enable (pointer store at FFEDAC72).  Pops up to n bytes (the
 * ISRs ask for 1) from the TX ring; returns how many were delivered.
 * ------------------------------------------------------------------------- */
u16 sci_tx_ring_fetch(u32 ch, u8 *dst, u16 n)
{
    sci_chan_t *c;
    u16 i = 0, t;
    if (ch > 2) return 0;
    c = &sci_chan[ch];
    if (!(c->flags & 0x0001)) return 0;
    while (i < n) {
        t = c->tx_tail;
        if (t == c->tx_head) break;          /* empty */
        dst[i] = c->tx_buf[t];
        if (++t >= c->tx_size) t = 0;
        c->tx_tail = t;
        i++;
    }
    return i;
}

/* ----------------------------------------------------------------------------
 * FFEDB131-FFEDB1EE (189 B)  sci_rx_ring_store(ch, src, n) -> u16
 * [sub_FFEDB131]  Confirmed.  Registered as every SCI's rx_cb (FFEDACE7).
 * Called from the RXI ISRs with one byte.  Bytes are dropped when the ring is
 * full.  Returns sci_rx_ring_level(ch).  (doc 51 sec.1 "SCI0 RX byte callback")
 * ------------------------------------------------------------------------- */
u16 sci_rx_ring_store(u32 ch, const u8 *src, u16 n)
{
    sci_chan_t *c;
    u16 i, next;
    if (ch > 2) return 0;
    c = &sci_chan[ch];
    if (!(c->flags & 0x0100)) return 0;
    for (i = 0; i < n; i++) {
        next = c->rx_head + 1;
        if (next >= c->rx_size) next = 0;
        if (next == c->rx_tail) break;       /* full: drop the rest */
        c->rx_buf[c->rx_head] = src[i];
        c->rx_head = next;
    }
    return sci_rx_ring_level(ch);
}

/* ----------------------------------------------------------------------------
 * FFEDB1EE-FFEDB250 (98 B)  sci_rx_ring_level(ch) -> u16  [sub_FFEDB1EE]
 * Confirmed.  Caller: sci_rx_ring_store.  Same inconsistent formula as
 * sci_write (free space when head >= tail, used bytes otherwise).
 * ------------------------------------------------------------------------- */
u16 sci_rx_ring_level(u32 ch)
{
    sci_chan_t *c = &sci_chan[ch];
    if (c->rx_head >= c->rx_tail) return c->rx_size - c->rx_head + c->rx_tail;
    return c->rx_size - c->rx_tail + c->rx_head;
}

/* ----------------------------------------------------------------------------
 * FFEDB250-FFEDB300 (176 B)  sci_read(ch, dst, n) -> u16  [sub_FFEDB250]
 * Confirmed.  Callers: link_deframe (ch0, 1 byte at a time), gps_rx_assemble
 * (ch1), sub_FFF3A11F Bluetooth receive (ch2).  Non-blocking ring read.
 * ------------------------------------------------------------------------- */
u16 sci_read(u32 ch, u8 *dst, u16 n)
{
    sci_chan_t *c;
    u16 i = 0, t;
    if (ch > 2) return 0;
    c = &sci_chan[ch];
    if (!(c->flags & 0x0100)) return 0;
    while (i < n) {
        t = c->rx_tail;
        if (t == c->rx_head) break;
        dst[i] = c->rx_buf[t];
        if (++t >= c->rx_size) t = 0;
        c->rx_tail = t;
        i++;
    }
    return i;
}

/* ----------------------------------------------------------------------------
 * FFEDB300-FFEDB4E8 (488 B)  sci_hw_init  [sub_FFEDB300]   Confirmed
 * Caller: sci_init_all.  ICU and SCI register reset for SCI0/2/3:
 *   IPR58 (SCI0 RXI) |= 0x0F -> priority 15; IPR62 (SCI2), IPR110 (GROUPBL0),
 *   IPR80 (SCI3) = 3.  Clears IR58/59/62/63/110/80/81.  Sets IER bits for
 *   vectors 58,59,62,63 (IER07 b2,b3,b6,b7), 110 (IER0D b6), 80,81 (IER0A
 *   b0,b1) and GENBL0 bits 0,1,4,5,6,7 (TEI/ERI of SCI0/2/3; SCI1's bits 2/3
 *   untouched, doc 02).  Per SCI: SEMR=0x10 (ABCS), SMR=0, SCR=0, clear any
 *   error flag (SSR=0xC7), SCMR=0xF2 (SCI0) / 0x10 (SCI2, SCI3).  Finally
 *   zeroes the three callback blocks at 0x12D20.
 * ------------------------------------------------------------------------- */
void sci_hw_init(void)
{
    static const u32 base[3] = { SCI0_BASE, SCI2_BASE, SCI3_BASE };
    int k;
    ICU_IPR(58)  |= 0x0F;
    ICU_IPR(62)   = (ICU_IPR(62)  | 3) & 0xF3;
    ICU_IPR(110)  = (ICU_IPR(110) | 3) & 0xF3;
    ICU_IR(58) = 0; ICU_IR(59) = 0; ICU_IR(62) = 0; ICU_IR(63) = 0; ICU_IR(110) = 0;
    ICU_IER(0x07) |= 0x08 | 0x04 | 0x80 | 0x40;      /* vectors 59,58,63,62 */
    ICU_IER(0x0D) |= 0x40;                           /* vector 110          */
    ICU_GENBL0 |= (1u << 1) | (1u << 0) | (1u << 5) | (1u << 4);
    ICU_IPR(80)   = (ICU_IPR(80)  | 3) & 0xF3;
    ICU_IR(81) = 0; ICU_IR(80) = 0;
    ICU_IER(0x0A) |= 0x02 | 0x01;                    /* vectors 81,80       */
    ICU_GENBL0 |= (1u << 6) | (1u << 7);
    for (k = 0; k < 3; k++) {
        REG8(base[k] + 7) = 0x10;                    /* SEMR.ABCS          */
        REG8(base[k] + 0) = 0;                       /* SMR                */
        REG8(base[k] + 2) = 0;                       /* SCR                */
        if (REG8(base[k] + 4) & SSR_ERRS) REG8(base[k] + 4) = 0xC7;
        REG8(base[k] + 6) = (k == 0) ? 0xF2 : 0x10;  /* SCMR               */
    }
    memset(sci_cb, 0, sizeof sci_cb);                /* 0x12D20..0x12D43   */
}

/* ----------------------------------------------------------------------------
 * FFEDB4E8-FFEDB63A (338 B)  sci0_set_format(cfg)  [sub_FFEDB4E8]  Confirmed
 * Callers: sci_init_all, sci_config_from_string.  Stops SCI0 (SCR=0), picks
 * (SMR,BRR) from the 9-pair ROM table 0xFFC00100 by rate/100 (doc 14 table;
 * SCI0 knows 500000 but not 115200), then SMR |= CHR(b6) for 7 bits,
 * STOP(b3) for 2 stop bits, PE|PM (0x30) for odd, PE (b5) for even.
 * NOTE: if SCR had any of TIE/RIE/TE/RE set on entry, the routine falls into
 * an endless loop (FFEDB630: `i++; bra`) - a u8 delay counter whose loop
 * condition the compiler proved always true (Inferred: `for(u8 i=0;i<256;)`).
 * It is only reached with SCR already cleared by sci_hw_init.  The same
 * pattern is in sci2_set_format and sci3_set_format.
 * ------------------------------------------------------------------------- */
static u8 sci_pick_smr_brr(u16 rate, int allow_500k, int allow_115k, u8 *brr)
{
    int k;
    switch (rate) {
    case 0x0030: k = 0; break;              /*   4800 */
    case 0x0090: k = 2; break;              /*  14400 */
    case 0x00C0: k = 3; break;              /*  19200 */
    case 0x0180: k = 4; break;              /*  38400 */
    case 0x01E0: k = 5; break;              /*  48000 */
    case 0x09C4: k = 6; break;              /* 250000 */
    case 0x0480: k = allow_115k ? 7 : 1; break;
    case 0x1388: k = allow_500k ? 8 : 1; break;
    default:     k = 1; break;              /*   9600 (table +2) */
    }
    *brr = sci_smr_brr_rom[2 * k + 1];
    return sci_smr_brr_rom[2 * k];
}
static void sci_set_format(u32 base, const sci_cfg_t *cfg, int a500k, int a115k)
{
    u8 scr_old = REG8(base + 2), smr, brr, i;
    REG8(base + 2) = 0;
    smr = sci_pick_smr_brr(cfg->rate_div100, a500k, a115k, &brr);
    if (cfg->data_bits == 7) smr |= 0x40;
    if (cfg->stop_bits == 2) smr |= 0x08;
    if (cfg->parity == 1)      smr |= 0x30;
    else if (cfg->parity == 2) smr |= 0x20;
    REG8(base + 0) = smr;
    REG8(base + 1) = brr;
    if (scr_old & 0xF0)
        for (i = 0; ; i++) ;                 /* hangs: see header note */
}
void sci0_set_format(const sci_cfg_t *cfg) { sci_set_format(SCI0_BASE, cfg, 1, 0); }

/* ----------------------------------------------------------------------------
 * FFEDB63A-FFEDB690 (86 B)  sci0_tx_open(id, cb)  [sub_FFEDB63A]  Confirmed
 * Caller: sci_channel_enable.  If SCR0.TE clear: register cb/id, SCR0 |= TE,
 * ~0x300-iteration settle loop, clear IR59 (TXI0) and IR110 (GROUPBL0).
 * ------------------------------------------------------------------------- */
void sci0_tx_open(u16 id, sci_cb_t cb)
{
    u8 scr = REG8(SCI0_BASE + 2);
    u16 d;
    if (scr & SCR_TE) return;
    sci_cb[0].tx_cb = cb;
    sci_cb[0].tx_id = id;
    REG8(SCI0_BASE + 2) = scr | SCR_TE;
    for (d = 0; d < 0x300; d++) ;
    ICU_IR(59) = 0;
    ICU_IR(110) = 0;                         /* 0x8703B + 0x33 */
}

/* FFEDB690-FFEDB6BD (45 B) sci0_tx_close [sub_FFEDB690] Confirmed.
 * SCR0 &= 0x5F (clear TIE, TE); forget the TX callback. */
void sci0_tx_close(void)
{
    REG8(SCI0_BASE + 2) &= 0x5F;
    sci_cb[0].tx_cb = 0; sci_cb[0].tx_id = 0;
}

/* ----------------------------------------------------------------------------
 * FFEDB6BD-FFEDB733 (118 B)  sci0_rx_open(id, cb)  [sub_FFEDB6BD]  Confirmed
 * Caller: sci_channel_enable.  Keeps a RAM shadow of SCR0 at 0x8A84 (SCI0
 * only).  If neither RIE nor RE is set: register cb, SCR0 |= RIE|RE, settle,
 * clear IR58.
 * ------------------------------------------------------------------------- */
void sci0_rx_open(u16 id, sci_cb_t cb)
{
    u8 scr = REG8(SCI0_BASE + 2);
    u16 d;
    sci0_scr_shadow = scr;
    REG8(SCI0_BASE + 2) = sci0_scr_shadow;
    if (scr & (SCR_RIE | SCR_RE)) return;
    sci_cb[0].rx_cb = cb;
    sci_cb[0].rx_id = id;
    scr |= SCR_RIE | SCR_RE;
    sci0_scr_shadow = scr;
    REG8(SCI0_BASE + 2) = scr;
    for (d = 0; d < 0x300; d++) ;
    ICU_IR(58) = 0;
}

/* FFEDB733-FFEDB761 (46 B) sci0_rx_close [sub_FFEDB733] Confirmed.
 * SCR0 &= 0xAF (clear RIE, RE); forget the RX callback. */
void sci0_rx_close(void)
{
    REG8(SCI0_BASE + 2) &= 0xAF;
    sci_cb[0].rx_cb = 0; sci_cb[0].rx_id = 0;
}

/* ----------------------------------------------------------------------------
 * FFEDB761-FFEDB7B6 (85 B)  sci0_tx_kick  [sub_FFEDB761]  Confirmed
 * Caller: sci_write.  If no transmission is running (SCR0.TIE clear), fetch
 * one byte through the TX callback; if there is one, write TDR0 and set
 * TIE and TEIE so TXI0/TEI0 continue the chain (doc 109 sec.1).
 * ------------------------------------------------------------------------- */
void sci0_tx_kick(void)
{
    u8 b; u16 n = 0;
    if (REG8(SCI0_BASE + 2) & SCR_TIE) return;
    if (sci_cb[0].tx_cb) n = sci_cb[0].tx_cb(sci_cb[0].tx_id, &b, 1);
    if (n == 0) return;
    REG8(SCI0_BASE + 3) = b;                 /* TDR0 */
    REG8(SCI0_BASE + 2) |= SCR_TIE;
    REG8(SCI0_BASE + 2) |= SCR_TEIE;
}

/* FFEDB7B6-FFEDB7E7 (49 B) sci0_eri_handler [sub_FFEDB7B6] Confirmed.
 * GROUPBL0 bit1 (ERI0).  If RIE: SSR0 = (SSR0 & 0xC7) | 0xC0, i.e. clear
 * ORER/FER/PER.  (Doc 20 calls these "polled twins"; they are the group-BL0
 * error/transmit-end handlers.) */
void sci0_eri_handler(void)
{
    if (REG8(SCI0_BASE + 2) & SCR_RIE)
        REG8(SCI0_BASE + 4) = (REG8(SCI0_BASE + 4) & 0xC7) | 0xC0;
}

/* ----------------------------------------------------------------------------
 * FFEDB7E7-FFEDB857 (112 B)  sci0_rxi_isr  [vec_intb_058]  Confirmed
 * RXI0 (INTB slot 58).  If RIE: clear error flags if any, read RDR0 and hand
 * the byte to the RX callback (sci_rx_ring_store).  The callback runs with
 * interrupts masked at this vector's priority (15, sci_hw_init).
 * ------------------------------------------------------------------------- */
void __interrupt sci0_rxi_isr(void)
{
    u8 ssr, b;
    if (!(REG8(SCI0_BASE + 2) & SCR_RIE)) return;
    ssr = REG8(SCI0_BASE + 4);
    if (ssr & SSR_ERRS) REG8(SCI0_BASE + 4) = (ssr & 0xC7) | 0xC0;
    b = REG8(SCI0_BASE + 5);                 /* RDR0 */
    if (sci_cb[0].rx_cb) sci_cb[0].rx_cb(sci_cb[0].rx_id, &b, 1);
}

/* ----------------------------------------------------------------------------
 * FFEDB857-FFEDB8A5 (78 B)  sci0_txi_isr  [vec_intb_059]  Confirmed
 * TXI0.  Next byte from the TX callback into TDR0; when the ring is empty,
 * clear TIE (TEIE stays set so TEI0 fires once more).
 * ------------------------------------------------------------------------- */
void __interrupt sci0_txi_isr(void)
{
    u8 b; u16 n = 0;
    if (sci_cb[0].tx_cb) n = sci_cb[0].tx_cb(sci_cb[0].tx_id, &b, 1);
    if (n) REG8(SCI0_BASE + 3) = b;
    else   REG8(SCI0_BASE + 2) &= ~SCR_TIE;
}

/* FFEDB8A5-FFEDB8F1 (76 B) sci0_tei_handler [sub_FFEDB8A5] Confirmed.
 * GROUPBL0 bit0 (TEI0): restart the chain if bytes arrived meanwhile,
 * otherwise clear TIE and TEIE (transmitter idle). */
void sci0_tei_handler(void)
{
    u8 b; u16 n = 0;
    if (sci_cb[0].tx_cb) n = sci_cb[0].tx_cb(sci_cb[0].tx_id, &b, 1);
    if (n) { REG8(SCI0_BASE + 3) = b; REG8(SCI0_BASE + 2) |= SCR_TIE; }
    else   { REG8(SCI0_BASE + 2) &= ~SCR_TIE; REG8(SCI0_BASE + 2) &= ~SCR_TEIE; }
}

/* ---------------- SCI2 (logical channel 1, GPS) - same shapes ----------- */

/* FFEDB8F1-FFEDBA44 (339 B) sci2_set_format(cfg) [sub_FFEDB8F1] Confirmed.
 * As sci0_set_format on SCI2; this copy knows 115200 (0x480) but not 500000.
 * Same endless-loop trap when SCR was live.  Callers: sci_init_all,
 * sci_config_from_string. */
void sci2_set_format(const sci_cfg_t *cfg) { sci_set_format(SCI2_BASE, cfg, 0, 1); }

/* FFEDBA44-FFEDBA9B (87 B) sci2_tx_open(id, cb) [sub_FFEDBA44] Confirmed.
 * Registers sci_cb[1].tx; SCR2 |= TE; settle; clear IR63, IR110. */
void sci2_tx_open(u16 id, sci_cb_t cb)
{
    u8 scr = REG8(SCI2_BASE + 2); u16 d;
    if (scr & SCR_TE) return;
    sci_cb[1].tx_cb = cb; sci_cb[1].tx_id = id;
    REG8(SCI2_BASE + 2) = scr | SCR_TE;
    for (d = 0; d < 0x300; d++) ;
    ICU_IR(63) = 0; ICU_IR(110) = 0;         /* 0x8703F + 0x2F */
}
/* FFEDBA9B-FFEDBAC8 (45 B) sci2_tx_close [sub_FFEDBA9B] Confirmed. */
void sci2_tx_close(void)
{ REG8(SCI2_BASE + 2) &= 0x5F; sci_cb[1].tx_cb = 0; sci_cb[1].tx_id = 0; }
/* FFEDBAC8-FFEDBB1F (87 B) sci2_rx_open(id, cb) [sub_FFEDBAC8] Confirmed. */
void sci2_rx_open(u16 id, sci_cb_t cb)
{
    u8 scr = REG8(SCI2_BASE + 2); u16 d;
    if (scr & (SCR_RIE | SCR_RE)) return;
    sci_cb[1].rx_cb = cb; sci_cb[1].rx_id = id;
    REG8(SCI2_BASE + 2) = scr | SCR_RIE | SCR_RE;
    for (d = 0; d < 0x300; d++) ;
    ICU_IR(62) = 0;
}
/* FFEDBB1F-FFEDBB4D (46 B) sci2_rx_close [sub_FFEDBB1F] Confirmed. */
void sci2_rx_close(void)
{ REG8(SCI2_BASE + 2) &= 0xAF; sci_cb[1].rx_cb = 0; sci_cb[1].rx_id = 0; }
/* FFEDBB4D-FFEDBBA2 (85 B) sci2_tx_kick [sub_FFEDBB4D] Confirmed. */
void sci2_tx_kick(void)
{
    u8 b; u16 n = 0;
    if (REG8(SCI2_BASE + 2) & SCR_TIE) return;
    if (sci_cb[1].tx_cb) n = sci_cb[1].tx_cb(sci_cb[1].tx_id, &b, 1);
    if (n == 0) return;
    REG8(SCI2_BASE + 3) = b;
    REG8(SCI2_BASE + 2) |= SCR_TIE; REG8(SCI2_BASE + 2) |= SCR_TEIE;
}
/* FFEDBBA2-FFEDBBD3 (49 B) sci2_eri_handler [sub_FFEDBBA2] Confirmed (GRPBL0 b5). */
void sci2_eri_handler(void)
{ if (REG8(SCI2_BASE + 2) & SCR_RIE) REG8(SCI2_BASE + 4) = (REG8(SCI2_BASE + 4) & 0xC7) | 0xC0; }
/* FFEDBBD3-FFEDBC43 (112 B) sci2_rxi_isr [vec_intb_062] Confirmed (RXI2). */
void __interrupt sci2_rxi_isr(void)
{
    u8 ssr, b;
    if (!(REG8(SCI2_BASE + 2) & SCR_RIE)) return;
    ssr = REG8(SCI2_BASE + 4);
    if (ssr & SSR_ERRS) REG8(SCI2_BASE + 4) = (ssr & 0xC7) | 0xC0;
    b = REG8(SCI2_BASE + 5);
    if (sci_cb[1].rx_cb) sci_cb[1].rx_cb(sci_cb[1].rx_id, &b, 1);
}
/* FFEDBC43-FFEDBC91 (78 B) sci2_txi_isr [vec_intb_063] Confirmed (TXI2). */
void __interrupt sci2_txi_isr(void)
{
    u8 b; u16 n = 0;
    if (sci_cb[1].tx_cb) n = sci_cb[1].tx_cb(sci_cb[1].tx_id, &b, 1);
    if (n) REG8(SCI2_BASE + 3) = b; else REG8(SCI2_BASE + 2) &= ~SCR_TIE;
}
/* FFEDBC91-FFEDBCDD (76 B) sci2_tei_handler [sub_FFEDBC91] Confirmed (GRPBL0 b4). */
void sci2_tei_handler(void)
{
    u8 b; u16 n = 0;
    if (sci_cb[1].tx_cb) n = sci_cb[1].tx_cb(sci_cb[1].tx_id, &b, 1);
    if (n) { REG8(SCI2_BASE + 3) = b; REG8(SCI2_BASE + 2) |= SCR_TIE; }
    else   { REG8(SCI2_BASE + 2) &= ~SCR_TIE; REG8(SCI2_BASE + 2) &= ~SCR_TEIE; }
}

/* ----------------------------------------------------------------------------
 * FFEDBCDD-FFEDBD53 (118 B)  icu_groupbl0_isr  [vec_intb_110]  Confirmed
 * GROUPBL0 dispatcher.  Reads GRPBL0 (0x87630) once per test and calls the
 * TEI/ERI handlers for bits 0,1 (SCI0), 4,5 (SCI2), 6,7 (SCI3).  doc 02.
 * ------------------------------------------------------------------------- */
void __interrupt icu_groupbl0_isr(void)
{
    if (ICU_GRPBL0 & (1u << 0)) sci0_tei_handler();
    if (ICU_GRPBL0 & (1u << 1)) sci0_eri_handler();
    if (ICU_GRPBL0 & (1u << 4)) sci2_tei_handler();
    if (ICU_GRPBL0 & (1u << 5)) sci2_eri_handler();
    if (ICU_GRPBL0 & (1u << 6)) sci3_tei_handler();
    if (ICU_GRPBL0 & (1u << 7)) sci3_eri_handler();
}

/* ---------------- SCI3 (logical channel 2, Bluetooth) ------------------- */

/* FFEDBD53-FFEDBEB2 (351 B) sci3_set_format(cfg) [sub_FFEDBD53] Confirmed.
 * Same table as sci2_set_format (115200 yes, 500000 no); same trap. */
void sci3_set_format(const sci_cfg_t *cfg) { sci_set_format(SCI3_BASE, cfg, 0, 1); }
/* FFEDBEB2-FFEDBF0F (93 B) sci3_tx_open(id, cb) [sub_FFEDBEB2] Confirmed.
 * Clears IR81 and IR110 (0x87051 + 0x1D). */
void sci3_tx_open(u16 id, sci_cb_t cb)
{
    u8 scr = REG8(SCI3_BASE + 2); u16 d;
    if (scr & SCR_TE) return;
    sci_cb[2].tx_cb = cb; sci_cb[2].tx_id = id;
    REG8(SCI3_BASE + 2) = scr | SCR_TE;
    for (d = 0; d < 0x300; d++) ;
    ICU_IR(81) = 0; ICU_IR(110) = 0;
}
/* FFEDBF0F-FFEDBF3F (48 B) sci3_tx_close [sub_FFEDBF0F] Confirmed. */
void sci3_tx_close(void)
{ REG8(SCI3_BASE + 2) &= 0x5F; sci_cb[2].tx_cb = 0; sci_cb[2].tx_id = 0; }
/* FFEDBF3F-FFEDBF9C (93 B) sci3_rx_open(id, cb) [sub_FFEDBF3F] Confirmed. */
void sci3_rx_open(u16 id, sci_cb_t cb)
{
    u8 scr = REG8(SCI3_BASE + 2); u16 d;
    if (scr & (SCR_RIE | SCR_RE)) return;
    sci_cb[2].rx_cb = cb; sci_cb[2].rx_id = id;
    REG8(SCI3_BASE + 2) = scr | SCR_RIE | SCR_RE;
    for (d = 0; d < 0x300; d++) ;
    ICU_IR(80) = 0;
}
/* FFEDBF9C-FFEDBFCA (46 B) sci3_rx_close [sub_FFEDBF9C] Confirmed. */
void sci3_rx_close(void)
{ REG8(SCI3_BASE + 2) &= 0xAF; sci_cb[2].rx_cb = 0; sci_cb[2].rx_id = 0; }
/* FFEDBFCA-FFEDC025 (91 B) sci3_tx_kick [sub_FFEDBFCA] Confirmed. */
void sci3_tx_kick(void)
{
    u8 b = 0; u16 n = 0;
    if (REG8(SCI3_BASE + 2) & SCR_TIE) return;
    if (sci_cb[2].tx_cb) n = sci_cb[2].tx_cb(sci_cb[2].tx_id, &b, 1);
    if (n == 0) return;
    REG8(SCI3_BASE + 3) = b;
    REG8(SCI3_BASE + 2) |= SCR_TIE; REG8(SCI3_BASE + 2) |= SCR_TEIE;
}
/* FFEDC025-FFEDC09B (118 B) sci3_rxi_isr [vec_intb_080] Confirmed (RXI3). */
void __interrupt sci3_rxi_isr(void)
{
    u8 ssr = 0, b = 0;
    if (!(REG8(SCI3_BASE + 2) & SCR_RIE)) return;
    ssr = REG8(SCI3_BASE + 4);
    if (ssr & SSR_ERRS) REG8(SCI3_BASE + 4) = (ssr & 0xC7) | 0xC0;
    b = REG8(SCI3_BASE + 5);
    if (sci_cb[2].rx_cb) sci_cb[2].rx_cb(sci_cb[2].rx_id, &b, 1);
}
/* FFEDC09B-FFEDC0EF (84 B) sci3_txi_isr [vec_intb_081] Confirmed (TXI3). */
void __interrupt sci3_txi_isr(void)
{
    u8 b = 0; u16 n = 0;
    if (sci_cb[2].tx_cb) n = sci_cb[2].tx_cb(sci_cb[2].tx_id, &b, 1);
    if (n) REG8(SCI3_BASE + 3) = b; else REG8(SCI3_BASE + 2) &= ~SCR_TIE;
}
/* FFEDC0EF-FFEDC13B (76 B) sci3_tei_handler [sub_FFEDC0EF] Confirmed (GRPBL0 b6). */
void sci3_tei_handler(void)
{
    u8 b; u16 n = 0;
    if (sci_cb[2].tx_cb) n = sci_cb[2].tx_cb(sci_cb[2].tx_id, &b, 1);
    if (n) { REG8(SCI3_BASE + 3) = b; REG8(SCI3_BASE + 2) |= SCR_TIE; }
    else   { REG8(SCI3_BASE + 2) &= ~SCR_TIE; REG8(SCI3_BASE + 2) &= ~SCR_TEIE; }
}
/* FFEDC13B-FFEDC16C (49 B) sci3_eri_handler [sub_FFEDC13B] Confirmed (GRPBL0 b7). */
void sci3_eri_handler(void)
{ if (REG8(SCI3_BASE + 2) & SCR_RIE) REG8(SCI3_BASE + 4) = (REG8(SCI3_BASE + 4) & 0xC7) | 0xC0; }

/* ============================================================================
 * 3. MAIN<->SUB LINK LAYER  (docs 51, 84, 109, 43, 121)
 * Byte stream on logical channel 0 (SCI0, 500 kbit/s).  MAIN->SUB frames are
 *   F op_hi | op_lo | len_hi | len_lo | hsum_hi | hsum_lo | payload... | fsum
 * (op_hi must have high nibble F).  SUB->MAIN frames are built by the
 * sub2main_* builders below.
 * ========================================================================== */

/* ----------------------------------------------------------------------------
 * FFEDC16C-FFEDC1F6 (138 B)  link_init  [sub_FFEDC16C]  Confirmed
 * Caller: sub_main.  Resets the deframer, the 4-slot queue and the block-
 * transfer counters, creates a one-slot software timer for the inter-byte
 * timeout (counter 0x1230A, reload table 0xFFC3EB7E) and opens channel 0 for
 * TX and RX.
 * ------------------------------------------------------------------------- */
void link_init(void)
{
    u8 i;
    link_rx_state = 0;
    for (i = 0; i < 4; i++) link_q_len[i] = 0;
    link_q_wr = 0;
    link_q_rd = 0;
    blk_total = 0;
    blk_bytes = 0;
    blk_sum   = 0;
    link_timer_grp = swtimer_group_create(1, &link_byte_timer, link_timer_reload);
    sci_channel_enable(0, 0x0101);
}

/* ----------------------------------------------------------------------------
 * FFEDC1F6-FFEDC2E1 (235 B)  link_dequeue_latest -> u16 len  [sub_FFEDC1F6]
 * Confirmed.  Caller: main-loop pump sub_FFF36CA2 (runs from TPU3 vector 136).
 * With IPL raised to 3 it drains the queue and keeps ONLY THE NEWEST frame:
 * every older slot is discarded (length zeroed).  The newest slot is copied
 * to pending_frame 0x8E46 (sub_FFEF0385 = memcpy 300 B) and its length is
 * returned (0 when the queue was empty).  So screen frames that arrive faster
 * than the pump runs are coalesced; only the last one is seen by the UI.
 * The echo (bytes 9..10 of every SUB->MAIN frame) is set to this frame's
 * opcode unless link_frame[0] - the DEFRAMER's current frame, not the slot -
 * is 0xFC (doc 84 says "skipped for 0xFCxx"; the test reads 0x12D49).
 * ------------------------------------------------------------------------- */
u16 link_dequeue_latest(void)
{
    u16 len = 0;
    u8  idx;
    if (link_q_rd == link_q_wr) return 0;
    __set_ipl(3);
    for (;;) {
        idx = link_q_rd;
        if (++link_q_rd > 3) link_q_rd = 0;
        if (link_q_rd == link_q_wr) break;
        link_q_len[idx] = 0;                     /* drop older frame */
    }
    len = link_q_len[idx];
    if (link_frame[0] != 0xFC) {
        link_echo[0] = link_q_slot[idx][0];
        link_echo[1] = link_q_slot[idx][1];
    }
    copy_to_pending_frame(link_q_slot[idx]);     /* sub_FFEF0385 */
    link_q_len[idx] = 0;
    __set_ipl(0);
    return len;
}

/* ----------------------------------------------------------------------------
 * FFEDC2E1-FFEDC3BD (220 B)  link_send_gps_sentence(src, n)  [sub_FFEDC2E1]
 * Confirmed.  Caller: nmea_process_sentence (RMC/GGA/GSA/VTG).  E1 frame
 * (doc 109 sec.3).  n > 0x12B: nothing.  The sentence is staged at 0x84CA;
 * it is sent only when gps_relay_block (0x8A86) is clear and sentence byte 4
 * (talker+type char at "$GPxGA": index 4 = 'G' of GGA, 'M' of RMC) is 'G' or
 * 'M' - so only $GPGGA/$GPRMC reach MAIN.  Independently, while the SD GPS
 * log is active (0x10C65 == 1) the sentence goes to sub_FFF14F8A starting
 * with the first GGA after the log opened, and a VTG ('T' at index 4) closes
 * the epoch: flag cleared and gpslog_state set to 2.
 * ------------------------------------------------------------------------- */
void link_send_gps_sentence(const u8 *src, u16 n)
{
    u16 i;
    if (n > 0x12B) return;
    for (i = 0; i < n; i++) link_payload[i] = src[i];
    if (gps_relay_block == 0 && (link_payload[4] == 'G' || link_payload[4] == 'M'))
        sub2main_frame_a(0xE1, 0, n);
    if (gpslog_state == 1) {
        if (link_payload[4] == 'G') gpslog_g_seen = 1;
        if (gpslog_g_seen == 1) {
            gpslog_write(link_payload, n);       /* sub_FFF14F8A */
            if (link_payload[4] == 'T') {
                gpslog_g_seen = 0;
                gpslog_state  = 2;
            }
        }
    }
}

/* ----------------------------------------------------------------------------
 * FFEDC3BD-FFEDC429 (108 B)  link_send_touch(pen, x, y)  [sub_FFEDC3BD]
 * Confirmed.  Caller: touch_report.  E0 frame, b1 = pen, payload
 * {pen?1:0, X be16, Y be16}, n = 5 (doc 84 sec.2).
 * ------------------------------------------------------------------------- */
void link_send_touch(u8 pen, u16 x, u16 y)
{
    link_payload[0] = pen ? 1 : 0;
    link_payload[1] = x >> 8;  link_payload[2] = (u8)x;
    link_payload[3] = y >> 8;  link_payload[4] = (u8)y;
    sub2main_frame_a(0xE0, link_payload[0], 5);
}

/* FFEDC429-FFEDC455 (44 B) link_send_ack [sub_FFEDC429] Confirmed.
 * Caller: link_dispatch_frame.  E3 acknowledgement: three zero bytes. */
void link_send_ack(void)
{
    link_payload[0] = link_payload[1] = link_payload[2] = 0;
    sub2main_frame_a(0xE3, 0, 3);
}

/* ----------------------------------------------------------------------------
 * FFEDC455-FFEDC493 (62 B)  link_send_status_b(status)  [dead_FFEDC455]
 * Confirmed bytes, unreached (no caller; doc 78/89).  Twin of
 * link_send_status that stages the BE16 status on the stack and goes through
 * the second builder (txbuf_b, 0x8DF6).
 * ------------------------------------------------------------------------- */
void link_send_status_b(u16 status)
{
    u8 p[2];
    blk_total = 0; blk_bytes = 0; blk_sum = 0;
    p[0] = status >> 8; p[1] = (u8)status;
    sub2main_frame_b(0xE2, 0, p, 2);
}

/* ----------------------------------------------------------------------------
 * FFEDC493-FFEDC4DD (74 B)  link_send_status(status)  [sub_FFEDC493]
 * Confirmed.  Callers: link_deframe (FFF0/FFF1/block-number), link_dispatch_
 * frame (FFFE), picture_step3_await_transfer and picture_step4_decode (FFFE).
 * E2 frame with the status word big-endian (doc 109 sec.4); resets the block
 * counters first.
 * ------------------------------------------------------------------------- */
void link_send_status(u16 status)
{
    blk_total = 0; blk_bytes = 0; blk_sum = 0;
    link_payload[0] = status >> 8;
    link_payload[1] = (u8)status;
    sub2main_frame_a(0xE2, 0, 2);
}

/* ----------------------------------------------------------------------------
 * FFEDC4DD-FFEDC5EE (273 B)  link_send_block_readback(n)  [sub_FFEDC4DD]
 * Confirmed.  Caller: link_dispatch_frame (FE00).  For 1 <= n <= blk_total
 * returns block n of the image staging buffer as an FF frame (doc 51 sec.2,
 * doc 109 sec.9).  Payload: n be16, total be16, blk_expect be32, then data.
 * Data length: 256, or for the last block the LOW BYTE of blk_bytes (the
 * running byte count; movu.b at FFEDC532).  That equals the last block's
 * length mod 256, so a final block of exactly 256 bytes is echoed with ZERO
 * data bytes.
 * ------------------------------------------------------------------------- */
void link_send_block_readback(u16 n)
{
    const u8 *src;
    u16 cnt, k;
    u32 i;
    if (!(n != 0 && n <= blk_total)) return;
    src = JPEG_IN_BUF + ((u32)(n - 1) << 8);
    cnt = (n == blk_total) ? (u8)blk_bytes : 0x100;
    link_payload[0] = n >> 8;          link_payload[1] = (u8)n;
    link_payload[2] = blk_total >> 8;  link_payload[3] = (u8)blk_total;
    link_payload[4] = blk_expect >> 24; link_payload[5] = blk_expect >> 16;
    link_payload[6] = blk_expect >> 8;  link_payload[7] = (u8)blk_expect;
    k = 8;
    for (i = 0; i < cnt; i++) link_payload[k++] = src[i];
    sub2main_frame_a(0xFF, 0xFF, k);
}

/* ----------------------------------------------------------------------------
 * FFEDC5EE-FFEDC615 (39 B)  link_rx_poll  [sub_FFEDC5EE]  Confirmed
 * Caller: tick fan-out sub_FFF36CAB (TPU0, every ~5.46 ms).  If a frame is
 * part-way through and the inter-byte timer expired, resynchronise; then run
 * the deframer and the dispatcher.
 * ------------------------------------------------------------------------- */
void link_rx_poll(void)
{
    if (link_rx_state != 0 && link_byte_timer == 0) link_rx_state = 0;
    link_deframe();
    link_dispatch_frame();
}

/* ----------------------------------------------------------------------------
 * FFEDC615-FFEDC976 (865 B)  link_deframe  [sub_FFEDC615]  Confirmed
 * Caller: link_rx_poll.  Nine-state deframer (doc 51 sec.1, table there).
 * Runs until a frame is complete (state 9) or the SCI0 ring is empty.  Every
 * byte that leaves the state != 0 re-arms the inter-byte timer.
 * Facts beyond doc 51: the length field counts from the first length byte, so
 * payload bytes = len - 4 (frame_cnt starts at 6 and ends at len+2); the
 * frame sum covers opcode, length AND the two header-sum bytes; and on a
 * frame-sum error of an FFxx frame the reply carries the block number
 * (frame +6..+7) - doc 109's correction - after which, unless the last echo
 * already starts with FF, a synthetic 2-byte FF FE / FF FF frame is queued so
 * the picture screen learns of the failure.  The 0x7FFF bound does not
 * protect the 300-byte queue slots (see link_enqueue).
 * ------------------------------------------------------------------------- */
void link_deframe(void)
{
    while (link_rx_state != 9) {
        if (sci_read(0, &link_rx_byte, 1) == 0) return;
        switch (link_rx_state) {
        case 0:
            if ((link_rx_byte & 0xF0) == 0xF0) {
                link_frame[0] = link_rx_byte;
                link_sum_calc = link_rx_byte;
                link_rx_state = 1;
            }
            break;
        case 1:
            link_frame[1] = link_rx_byte; link_sum_calc += link_rx_byte;
            link_rx_state = 2; break;
        case 2:
            link_frame[2] = link_rx_byte; link_sum_calc += link_rx_byte;
            link_frame_len = (u16)link_rx_byte << 8;
            link_rx_state = 3; break;
        case 3:
            link_frame[3] = link_rx_byte; link_sum_calc += link_rx_byte;
            link_frame_len += link_rx_byte;
            if (link_frame_len <= 0x7FFF) link_rx_state = 4;
            else {
                link_rx_state = 0;
                if (link_frame[0] == 0xFF) link_send_status(0xFFF1);
            }
            break;
        case 4:
            link_frame[4] = link_rx_byte;
            link_sum_recv = (u16)link_rx_byte << 8;
            link_rx_state = 5; break;
        case 5:
            link_frame[5] = link_rx_byte;
            link_sum_recv += link_rx_byte;
            if (link_sum_recv == link_sum_calc) {
                link_sum_calc += link_frame[4];
                link_sum_calc += link_frame[5];
                link_frame_cnt = 6;
                link_frame_len += 2;
                link_rx_state = (link_frame_cnt == link_frame_len) ? 7 : 6;
            } else {
                link_rx_state = 0;
                if (link_frame[0] == 0xFF) link_send_status(0xFFF0);
            }
            break;
        case 6:
            link_frame[link_frame_cnt] = link_rx_byte;
            link_sum_calc += link_rx_byte;
            if (++link_frame_cnt >= link_frame_len) link_rx_state = 7;
            break;
        case 7:
            link_sum_recv = (u16)link_rx_byte << 8;
            link_rx_state = 8; break;
        case 8:
            link_sum_recv += link_rx_byte;
            if (link_sum_recv == link_sum_calc) { link_rx_state = 9; break; }
            link_rx_state = 0;
            if (link_frame[0] == 0xFF) {
                link_send_status(((u16)link_frame[6] << 8) | link_frame[7]);
                if (link_echo[0] != 0xFF) {
                    link_frame[0] = 0xFF;
                    link_frame[1] = (link_frame[1] == 0xFE) ? 0xFE : 0xFF;
                    link_enqueue(link_frame, 2);
                }
            }
            break;
        }
        if (link_rx_state != 0) swtimer_restart(link_timer_grp, 0);
    }
}

/* ----------------------------------------------------------------------------
 * FFEDC976-FFEDD0D4 (1886 B)  link_dispatch_frame  [sub_FFEDC976]  Confirmed
 * Caller: link_rx_poll.  Acts on a complete frame (state 9), then rearms the
 * deframer (state 0).  Frame offsets below are relative to link_frame
 * (0x12D49 = 0x12D44+5); docs 43/51 quote them relative to 0x12D44.
 *   - F00F: power-down prep - P7.3 (LCD RESX), P1.5 (GPS power), P2.2, P8.7
 *     driven low.  Falls through to normal handling.
 *   - Pump priority: an FFxx frame raises IPR136 (TPU3 = UI pump) from 1 to 2
 *     (same level as the TPU0 tick, so the tick's link RX cannot preempt the
 *     pump mid-image); any frame other than FFxx/F6xx drops it back to 1.
 *   - FFxx: block transfer (FFFE/FFFF) into JPEG_IN_BUF, 32-bit sum check on
 *     the last block (doc 51 sec.3); "UI notify" = queue synthetic FF FE /
 *     FF FF on the first frame after a non-FF echo or when the low byte flips;
 *     other FFxx clear the counters and, if the echo starts FF, queue FF 01.
 *     Reception is skipped while EXDMAC_STAT bit7 is set (doc 51 open 2).
 *   - FE00: block read-back, only when frame +8..9 equals blk_total.
 *   - FC00: bulk apply sub_FFF3BC97(frame), nothing else.
 *   - F6 3x with tpu3_slow_mode set: restore TPU3 (sub_FFF36B1E).
 *   - F3D5: handshake step sub_FFF38338, nothing else.
 *   - all other frames (the "common header" path, doc 43 table):
 *       TPU3 slow mode on F301 / F3C0 / F3C1 with frame +0x13 == 3
 *       (sub_FFF36B9D; gps_relay_block = 1), off again for any frame whose
 *       +0x13 != 3;  frame +7 b6 -> echo = opcode and E3 ack;
 *       enqueue (except F3D5/F3D6);  frame +7 b1 GPS power, +8 b0..1 datum,
 *       +7 b3 static-nav, +7 b4 DGPS, +7 b2 -> P1.7;  sub_FFF3C165(frame);
 *       +0x18 b7 -> sub_FFF37CB9 / sub_FFF37CF4;  F3D2/F3D3/F3D6 BT steps;
 *       sub_FFF3850B, sub_FFF38402;  +9 bits 3:2 = 2/1/0 -> voice player
 *       sub_FFF3F037 / sub_FFF3F0BA / sub_FFF3EF94 (the last skipped for FC00);
 *       F640 -> sub_FFF3E98C.
 * ------------------------------------------------------------------------- */
static void link_notify_block(void)
{
    if (link_echo[0] != 0xFF) {                     /* first notification */
        link_frame[0] = 0xFF;
        link_frame[1] = (link_frame[1] == 0xFE) ? 0xFE : 0xFF;
        link_enqueue(link_frame, 2);
    } else if (blk_last_lo == 0xFE && link_frame[1] == 0xFF) {
        link_frame[0] = 0xFF; link_frame[1] = 0xFF; link_enqueue(link_frame, 2);
    } else if (blk_last_lo == 0xFF && link_frame[1] == 0xFE) {
        link_frame[0] = 0xFF; link_frame[1] = 0xFE; link_enqueue(link_frame, 2);
    }
    blk_last_lo = link_frame[1];
}

void link_dispatch_frame(void)
{
    u8 *f = link_frame;
    u8 hi;
    if (link_rx_state != 9) return;

    if (f[0] == 0xF0 && f[1] == 0x0F) {             /* F00F */
        P7_PODR &= ~0x08;  P1_PODR &= ~0x20;
        P2_PODR &= ~0x04;  P8_PODR &= ~0x80;
    }
    if (f[0] == 0xFF && (ICU_IPR(136) & 0x0F) == 1) {
        ICU_IER(0x11) &= ~0x01;
        ICU_IPR(136) = (ICU_IPR(136) | 0x02) & 0xF2;    /* priority 2 */
        ICU_IER(0x11) |= 0x01;
    } else if (f[0] != 0xF6 && f[0] != 0xFF && (ICU_IPR(136) & 0x0F) == 2) {
        ICU_IER(0x11) &= ~0x01;
        ICU_IPR(136) = (ICU_IPR(136) | 0x01) & 0xF1;    /* priority 1 */
        ICU_IER(0x11) |= 0x01;
    }

    hi = f[0];
    if (hi == 0xFF) {
        if (f[1] == 0xFE || f[1] == 0xFF) {
            u8 *dst; u16 n; u32 i; u16 off;
            if (EXDMAC_STAT & 0x80) return;              /* state stays 9 */
            blk_cur = ((u16)f[6] << 8) | f[7];
            if (blk_cur == 1) {
                blk_state = 1;
                blk_total = ((u16)f[8] << 8) | f[9];
                blk_bytes = 0; blk_sum = 0; blk_last_lo = 0;
            }
            if (blk_state == 1) {
                dst = JPEG_IN_BUF + ((u32)(blk_cur - 1) << 8);
                n = (((u16)f[2] << 8) | f[3]) - 0x0C;    /* 0x100 for a full block */
                blk_bytes = ((u32)(blk_cur - 1) << 8) + n;
                for (i = 0, off = 0x0E; i < n; i++, off++) {
                    dst[i] = f[off];
                    blk_sum += f[off];
                }
                if (blk_cur == blk_total) {
                    blk_expect = ((u32)f[0x0A] << 24) | ((u32)f[0x0B] << 16)
                               | ((u32)f[0x0C] << 8)  |  f[0x0D];
                    if (blk_expect != blk_sum) { link_send_status(0xFFFE); blk_state = 3; }
                    else                       { blk_state = 2; }
                    goto done;
                }
            }
            link_notify_block();
        } else {                                       /* other FFxx */
            blk_total = 0; blk_bytes = 0; blk_sum = 0;
            if (link_echo[0] == 0xFF) {
                f[0] = 0xFF; f[1] = 0x01;
                link_enqueue(f, 2);
            }
        }
        goto done;
    }
    if (hi == 0xFE) {
        if (f[1] == 0 && (((u16)f[8] << 8) | f[9]) == blk_total)
            link_send_block_readback(((u16)f[6] << 8) | f[7]);
        goto done;
    }
    if (hi == 0xFC) {
        if (f[1] == 0) sd_bulk_apply_fc00(f);           /* sub_FFF3BC97 */
        goto done;
    }
    if (hi == 0xF6 && (f[1] >> 4) == 3 && tpu3_slow_mode == 1) {
        tpu3_restore();                                  /* sub_FFF36B1E */
        tpu3_slow_mode = 0;
    }
    if (f[0] == 0xF3 && f[1] == 0xD5) { bt_handshake_f3d5(f); goto done; } /* sub_FFF38338 */

    if (tpu3_slow_mode == 0) {
        if (f[0] == 0xF3 && (f[1] == 0x01 || (u8)(f[1] - 0xC0) <= 1) && f[0x13] == 3) {
            tpu3_slow_start();                           /* sub_FFF36B9D */
            tpu3_slow_mode = 1;
            gps_relay_block = 1;
        }
    } else if (f[0x13] != 3) {
        tpu3_restore();
        tpu3_slow_mode = 0;
        gps_relay_block = 0;
    }
    if (f[7] & 0x40) {                                   /* ack requested */
        link_echo[0] = f[0];
        link_echo[1] = f[1];
        link_send_ack();
    }
    if (!(f[0] == 0xF3 && (f[1] == 0xD5 || f[1] == 0xD6)))
        link_enqueue(f, link_frame_cnt);
    if (f[7] & 0x02) gps_set_power(1); else gps_power_off();
    gps_request_datum((f[8] & 3) == 2 ? 2 : 0);
    gps_request_static_nav((f[7] & 0x08) ? 1 : 0);
    gps_request_dgps((f[7] & 0x10) ? 2 : 0);
    if (f[7] & 0x04) P1_PODR |= 0x80; else P1_PODR &= ~0x80;
    sub_FFF3C165(f);
    if (f[0x18] & 0x80) sub_FFF37CB9(); else sub_FFF37CF4();
    if (f[0] == 0xF3) {
        if (f[1] == 0xD2)      bt_f3d2(f, 1);            /* sub_FFF37D88 */
        else if (f[1] == 0xD3) bt_f3d3(f);               /* sub_FFF38292 */
        else if (f[1] == 0xD6) bt_f3d6(f);               /* sub_FFF38107 */
    }
    sub_FFF3850B(f);
    sub_FFF38402(f);
    if ((f[9] & 0x0C) == 0x08)      voice_cmd_2(f);      /* sub_FFF3F037 */
    else if ((f[9] & 0x0C) == 0x04) voice_cmd_1(f);      /* sub_FFF3F0BA */
    if (f[0] == 0xF6 && f[1] == 0x40) voice_play_f640(f); /* sub_FFF3E98C */
    if (!(f[0] == 0xFC && f[1] == 0x00) && (f[9] & 0x0C) == 0)
        voice_cmd_0();                                   /* sub_FFF3EF94 */
done:
    link_rx_state = 0;
}

/* ----------------------------------------------------------------------------
 * FFEDD0D4-FFEDD182 (174 B)  link_enqueue(src, len)  [sub_FFEDD0D4]
 * Confirmed.  Callers: link_deframe, link_dispatch_frame.  4-slot ring; when
 * full the OLDEST slot is overwritten (read index advanced).  No interrupt
 * masking here (it runs in the tick ISR; the reader masks to IPL 3).
 * NOTE: len is not bounded to the 300-byte slot (link_frame_cnt can reach
 * 0x8001); a MAIN frame longer than 300 bytes on the common path would
 * overrun into the next slot / link_q_wr.  MAIN's frames are <= 0x116 bytes
 * (Inferred from docs 51/109), so this is latent.
 * ------------------------------------------------------------------------- */
void link_enqueue(const u8 *src, u16 len)
{
    u8 next = link_q_wr + 1;
    u8 *dst;
    u16 i;
    if (next >= 4) next = 0;
    if (next == link_q_rd) {
        if (++link_q_rd >= 4) link_q_rd = 0;
    }
    dst = link_q_slot[link_q_wr];
    for (i = 0; i < len; i++) dst[i] = src[i];
    link_q_len[link_q_wr] = len;
    link_q_wr = next;
}

/* ----------------------------------------------------------------------------
 * FFEDD182-FFEDD355 (467 B)  sub2main_frame_a(type, b1, n)  [sub_FFEDD182]
 * Confirmed.  Callers: link_send_gps_sentence (E1), link_send_touch (E0),
 * link_send_ack (E3), link_send_status (E2), link_send_block_readback (FF).
 * K2 frame in link_txbuf_a (0x1B33A) from payload pre-staged at 0x1B20E:
 *   [0]=type [1]=b1 [2..3]=BE(n+9) [4..5]=BE(sum[0..3]) [6..8]=01 02 00
 *   [9..10]=echo [11..]=payload [..]=BE(sum[0..10+n]) then 6 x 00.
 * Total n+19 bytes to channel 0 (docs 84/109).
 * ------------------------------------------------------------------------- */
static u16 k2_build(u8 *f, u8 type, u8 b1, const u8 *p, u16 n)
{
    u16 i, k, sum = 0, l = n + 9;
    f[0] = type; f[1] = b1; f[2] = l >> 8; f[3] = (u8)l;
    for (i = 0; i < 4; i++) sum += f[i];
    f[4] = sum >> 8; f[5] = (u8)sum;
    f[6] = 0x01; f[7] = 0x02; f[8] = 0x00;
    f[9] = link_echo[0]; f[10] = link_echo[1];
    for (k = 11, i = 0; i < n; i++) f[k++] = p[i];
    for (i = 4; i < k; i++) sum += f[i];             /* sum continues from [0..3] */
    f[k++] = sum >> 8; f[k++] = (u8)sum;
    for (i = 0; i < 6; i++) f[k++] = 0;
    return k;
}
void sub2main_frame_a(u8 type, u8 b1, u16 n)
{
    sci_write(0, link_txbuf_a, k2_build(link_txbuf_a, type, b1, link_payload, n));
}

/* FFEDD355-FFEDD528 (467 B) sub2main_frame_b(type, b1, p, n) [sub_FFEDD355]
 * Confirmed.  Same body with an explicit payload pointer and buffer
 * link_txbuf_b (0x1BB3A).  Only caller is the dead link_send_status_b. */
void sub2main_frame_b(u8 type, u8 b1, const u8 *p, u16 n)
{
    sci_write(0, link_txbuf_b, k2_build(link_txbuf_b, type, b1, p, n));
}

/* FFEDD528-FFEDD6FB (467 B) sub2main_frame_c(type, b1, p, n) [sub_FFEDD528]
 * Confirmed.  Buffer link_txbuf_c (0x1C33A; doc 107 calls it
 * sub2main_send_frame).  Callers: the Bluetooth layer (E4/E5/E6, doc 109
 * sec.6): FFF37D88, FFF38107, FFF389E7, FFF38BDA, FFF38EFB, FFF39216,
 * FFF3945C. */
void sub2main_frame_c(u8 type, u8 b1, const u8 *p, u16 n)
{
    sci_write(0, link_txbuf_c, k2_build(link_txbuf_c, type, b1, p, n));
}

/* FFEDD6FB-FFEDD8DC (481 B) sub2main_frame_d(type, b1, p, n) [sub_FFEDD6FB]
 * Confirmed.  Buffer link_txbuf_d (0x1C3BA).  Voice player status EA (doc
 * 109 sec.8), 15 callers in FFF3E98C..FFF3F8A5.  Masks the TPU0 tick
 * (IER10 b7, vector 135) around sci_write, because the tick ISR runs the other
 * builders on the same channel-0 ring (doc 109). */
void sub2main_frame_d(u8 type, u8 b1, const u8 *p, u16 n)
{
    u16 len = k2_build(link_txbuf_d, type, b1, p, n);
    ICU_IER(0x10) &= ~0x80;
    sci_write(0, link_txbuf_d, len);
    ICU_IER(0x10) |= 0x80;
}

/* ----------------------------------------------------------------------------
 * FFEDD8DC-FFEDDED5 (1529 B)  sub2main_send_fe_record(type, b1, A, B)
 * [sub_FFEDD8DC]  Confirmed.  22 callers in the SD task FFF3B8DE..FFF3E398
 * (doc 109 sec.7: card in/out, SD command results).  A (20-byte header, by
 * value) and B (36-byte SD record, by value) are on the stack.  Layout in
 * link_txbuf_fe (0x1C43A):
 *   [0]=type [1]=b1 [2..3]=BE(A.w0+6) [4..5]=hdr sum [6..7]=echo
 *   [8..15]=BE A.w0,w2,w4,w6
 *   [16],[17],[18],[20],[21] = pack(A.w8,wA,wC,wE,w10), [19]=[22]=[23]=0
 *        pack(v) = (tens_tbl[i].d << 4) | (v & 0x0F), i = first i<10 with
 *        v - tens_tbl[i].v < 10 (table 0xFFC3EB56 {d, 10*d}); true BCD only
 *        for v < 10 (doc 109 "packing quirk")
 *   [24..29]=BE B.w0,w2,w4  [30..93]=64 B from *B.p8  [94..125]=32 B *B.pC
 *   [126..129]=BE B.l10  [130..133]=BE B.l14  [134..135]=BE B.w18
 *   [136..137]=BE low 16 of B.l1C  [138..151]=0  [152..]=B.w18 bytes *B.p20
 *   then BE16 sum (over all bytes, header sum included) and 6 x 00.
 * Masks the tick (IER10 b7) around sci_write like sub2main_frame_d.
 * ------------------------------------------------------------------------- */
typedef struct { u16 w0, w2, w4, w6, w8, wA, wC, wE, w10, pad; } fe_hdr_t;
typedef struct { u16 w0, w2, w4, pad; const u8 *p8, *pC; u32 l10, l14;
                 u16 w18, pad1a; u32 l1C; const u8 *p20; } sd_rec_t;
extern const struct { u16 d, v; } tens_tbl[10];   /* 0xFFC3EB56 */
static u8 fe_pack(u16 v)
{
    u16 i;
    for (i = 0; i < 10; i++)
        if ((u16)(v - tens_tbl[i].v) < 10) break;
    return (u8)((tens_tbl[i].d << 4) | (v & 0x0F));
}
void sub2main_send_fe_record(u8 type, u8 b1, fe_hdr_t A, sd_rec_t B)
{
    u8 *f = link_txbuf_fe;
    u16 i, k, sum = 0, l = A.w0 + 6;
    f[0] = type; f[1] = b1; f[2] = l >> 8; f[3] = (u8)l;
    for (i = 0; i < 4; i++) sum += f[i];
    f[4] = sum >> 8; f[5] = (u8)sum;
    f[6] = link_echo[0]; f[7] = link_echo[1];
    f[8]  = A.w0 >> 8; f[9]  = (u8)A.w0;  f[10] = A.w2 >> 8; f[11] = (u8)A.w2;
    f[12] = A.w4 >> 8; f[13] = (u8)A.w4;  f[14] = A.w6 >> 8; f[15] = (u8)A.w6;
    f[16] = fe_pack(A.w8); f[17] = fe_pack(A.wA); f[18] = fe_pack(A.wC); f[19] = 0;
    f[20] = fe_pack(A.wE); f[21] = fe_pack(A.w10); f[22] = 0; f[23] = 0;
    f[24] = B.w0 >> 8; f[25] = (u8)B.w0; f[26] = B.w2 >> 8; f[27] = (u8)B.w2;
    f[28] = B.w4 >> 8; f[29] = (u8)B.w4;
    for (i = 0; i < 0x40; i++) f[0x1E + i] = B.p8[i];
    for (i = 0; i < 0x20; i++) f[0x5E + i] = B.pC[i];
    f[0x7E] = B.l10 >> 24; f[0x7F] = B.l10 >> 16; f[0x80] = B.l10 >> 8; f[0x81] = (u8)B.l10;
    f[0x82] = B.l14 >> 24; f[0x83] = B.l14 >> 16; f[0x84] = B.l14 >> 8; f[0x85] = (u8)B.l14;
    f[0x86] = B.w18 >> 8;  f[0x87] = (u8)B.w18;
    f[0x88] = B.l1C >> 8;  f[0x89] = (u8)B.l1C;
    for (i = 0; i < 14; i++) f[0x8A + i] = 0;
    for (k = 0x98, i = 0; i < B.w18; i++) f[k++] = B.p20[i];
    for (i = 4; i < k; i++) sum += f[i];
    f[k++] = sum >> 8; f[k++] = (u8)sum;
    for (i = 0; i < 6; i++) f[k++] = 0;
    ICU_IER(0x10) &= ~0x80;                         /* mask TPU0 tick */
    sci_write(0, link_txbuf_fe, k);
    ICU_IER(0x10) |= 0x80;
}

/* ============================================================================
 * 4. LCD PANEL DRIVER + POWER SEQUENCER
 * The controller sits on CS5 at 0x06000000: a command byte is written with
 * P8.2 (D/CX) low, data bytes with it high (doc 51 sec.4).  Hardware reset on
 * P7.3.  The init sequence (C8h FF 93 42 "set EXTC", then MADCTL/COLMOD/power/
 * VCOM/frame-rate/gamma/sleep-out) is the ILITEK ILI9341/ILI9342 command set;
 * with the 320x240 window it points to an ILI9342-class panel (Inferred).
 * ========================================================================== */

/* FFEDDED5-FFEDDEF1 (28 B) lcd_seq_reset [sub_FFEDDED5] Confirmed.
 * Callers: ui_reset_phase, ui_phase0_power_up, ui_phase2_run. */
void lcd_seq_reset(void) { lcd_seq[0] = 0; lcd_seq[1] = 0; lcd_seq[2] = 0; }

/* FFEDDEF1-FFEDDF1A (41 B) lcd_seq_set(state) [sub_FFEDDEF1] Confirmed.
 * Callers: ui_phase0_power_up, sub_FFEEF94F.  Accepts 0..8; resets done/substep. */
void lcd_seq_set(u8 state)
{
    if (state > 8) return;
    lcd_seq[0] = state; lcd_seq[1] = 0; lcd_seq[2] = 0;
}

/* FFEDDF1A-FFEDDF28 (14 B) lcd_seq_get_state [sub_FFEDDF1A] Confirmed. */
u32 lcd_seq_get_state(void) { return lcd_seq[0]; }

/* FFEDDF28-FFEDDF3A (18 B) lcd_seq_get_done [sub_FFEDDF28] Confirmed. */
u8 lcd_seq_get_done(void) { return lcd_seq[1]; }

/* ----------------------------------------------------------------------------
 * FFEDDF3A-FFEDDF7F (69 B)  lcd_seq_step  [sub_FFEDDF3A]  Confirmed
 * Caller: ui_phase_dispatch (every pump pass).  Skipped while render_state[0]
 * (0x1D3A0) == 2 and the EXDMAC busy bit4 test sub_FFEF1E63() returns 0 -
 * i.e. while a frame push is running.  Otherwise runs lcd_seq_tbl[state].
 * The ROM table 0xFFECE50C holds 4 code pointers {sub_FFEFB267 (rts),
 * lcd_seq_power_on, lcd_seq_display_on, lcd_seq_blank} followed by data, yet
 * states up to 8 pass the bound check (lcd_seq_set); states 4..8 would jump
 * through non-code (Inferred: never requested).
 * ------------------------------------------------------------------------- */
void lcd_seq_step(void)
{
    if (render_state[0] == 2 && exdmac_stat_bit4() == 0) return;  /* sub_FFEF1E63: EXDMAC 0x8281E bit4 */
    if (lcd_seq[0] > 8) return;
    lcd_seq_tbl[lcd_seq[0]]();
}

/* ----------------------------------------------------------------------------
 * FFEDDF7F-FFEDE10F (400 B)  lcd_panel_init_sequence  [sub_FFEDDF7F]
 * Confirmed.  Caller: lcd_seq_power_on.  (cmd = lcd_write_cmd, d = data8)
 * ------------------------------------------------------------------------- */
void lcd_panel_init_sequence(void)
{
    lcd_hw_reset_pulse();
    delay_ms(120);
    lcd_write_cmd(0x01);                              /* software reset   */
    delay_ms(50);
    lcd_write_cmd(0xC8); lcd_write_data8(0xFF); lcd_write_data8(0x93);
                         lcd_write_data8(0x42);       /* SETEXTC          */
    lcd_write_cmd(0x20); lcd_write_data8(0x00);       /* inversion off    */
    lcd_write_cmd(0x36); lcd_write_data8(0x08);       /* MADCTL: BGR      */
    lcd_write_cmd(0x3A); lcd_write_data8(0x55);       /* COLMOD: 16 bpp   */
    lcd_write_cmd(0xC0); lcd_write_data8(0x09); lcd_write_data8(0x09); /* PWCTR1 */
    lcd_write_cmd(0xC1); lcd_write_data8(0x02);       /* PWCTR2           */
    lcd_write_cmd(0x21); lcd_write_data8(0x00);       /* inversion on     */
    lcd_write_cmd(0xC5); lcd_write_data8(0xE0);       /* VCOM             */
    lcd_write_cmd(0xB1); lcd_write_data8(0x00); lcd_write_data8(0x1C); /* frame rate */
    lcd_write_cmd(0xB4); lcd_write_data8(0x02);       /* inversion ctl    */
    lcd_write_cmd(0x2A); lcd_write_data8(0x00); lcd_write_data8(0x00);
                         lcd_write_data8(0x01); lcd_write_data8(0x3F); /* col 0..319 */
    lcd_write_cmd(0x2B); lcd_write_data8(0x00); lcd_write_data8(0x00);
                         lcd_write_data8(0x00); lcd_write_data8(0xEF); /* row 0..239 */
    lcd_write_cmd(0xE0); /* 15 positive-gamma bytes (FFEDE057..FFEDE0A5) */
    lcd_write_gamma_pos();
    lcd_write_cmd(0xE1); /* 15 negative-gamma bytes (FFEDE0AE..FFEDE0FF) */
    lcd_write_gamma_neg();
    lcd_write_cmd(0x11);                              /* sleep out        */
    delay_ms(120);
}

/* FFEDE10F-FFEDE161 (82 B) lcd_seq_power_on [sub_FFEDE10F] Confirmed.
 * lcd_seq_tbl[1].  Substep 0: start UI timer 0 with 2 ticks.  Substep 1: once
 * it expired, stop it, run the panel init, mark display off, done=1.
 * (sub_FFEEFDDA/FD91/FDB9/FDA5 = ui timer set/start/expired/stop.) */
void lcd_seq_power_on(void)
{
    if (lcd_seq[2] == 0) {
        ui_timer_set(0, 2); ui_timer_start(0);
        lcd_seq[2]++;
    } else if (lcd_seq[2] == 1 && ui_timer_expired(0) == 1) {
        ui_timer_stop(0);
        lcd_panel_init_sequence();
        lcd_display_on = 0;
        lcd_seq[1] = 1;
    }
}

/* FFEDE161-FFEDE17A (25 B) lcd_seq_display_on [sub_FFEDE161] Confirmed.
 * lcd_seq_tbl[2]: DISPON (0x29), flag on, done. */
void lcd_seq_display_on(void)
{
    lcd_write_cmd(0x29);
    lcd_display_on = 1;
    lcd_seq[1] = 1;
}

/* FFEDE17A-FFEDE1A2 (40 B) lcd_clear_black [sub_FFEDE17A] Confirmed.
 * Window 320x240, then 0x12C00 (76800) zero pixels. */
void lcd_clear_black(void)
{
    u32 n = 0x12C00;
    lcd_set_window(0, 0x13F, 0, 0xEF);
    do { lcd_write_data16(0); } while (--n);
}

/* FFEDE1A2-FFEDE1F5 (83 B) lcd_seq_blank [sub_FFEDE1A2] Confirmed.
 * lcd_seq_tbl[3].  Substep 0: clear to black, UI timer 0 = 0x65 ticks.
 * Substep 1: when expired: stop, display flag 0, done. */
void lcd_seq_blank(void)
{
    if (lcd_seq[2] == 0) {
        lcd_clear_black();
        ui_timer_set(0, 0x65); ui_timer_start(0);
        lcd_seq[2]++;
    } else if (lcd_seq[2] == 1 && ui_timer_expired(0) == 1) {
        ui_timer_stop(0);
        lcd_display_on = 0;
        lcd_seq[1] = 1;
    }
}

/* FFEDE1F5-FFEDE259 (100 B) lcd_set_window(x, dx, y, dy) [sub_FFEDE1F5]
 * Confirmed.  Callers: lcd_clear_black, lcd_blit_fullscreen_cpu,
 * sub_FFEF1EFA (EXDMAC push).  CASET x..x+dx, PASET y..y+dy, RAMWR. */
void lcd_set_window(u16 x, u16 dx, u16 y, u16 dy)
{
    lcd_write_cmd(0x2A);
    lcd_write_data8(x >> 8); lcd_write_data8((u8)x);
    lcd_write_data8((u8)((x + dx) >> 8)); lcd_write_data8((u8)(x + dx));
    lcd_write_cmd(0x2B);
    lcd_write_data8(y >> 8); lcd_write_data8((u8)y);
    lcd_write_data8((u8)((y + dy) >> 8)); lcd_write_data8((u8)(y + dy));
    lcd_write_cmd(0x2C);
}

/* FFEDE259-FFEDE267 (14 B) lcd_set_display_on_flag(v) [sub_FFEDE259] Confirmed.
 * Callers: ui_reset_phase (0), ipc_classify_f0 (F000 -> 0, F001 -> 1). */
void lcd_set_display_on_flag(u8 v) { lcd_display_on = v; }

/* FFEDE267-FFEDE278 (17 B) lcd_get_display_on_flag [sub_FFEDE267] Confirmed. */
u8 lcd_get_display_on_flag(void) { return lcd_display_on; }

/* FFEDE278-FFEDE298 (32 B) lcd_hw_reset_pulse [sub_FFEDE278] Confirmed.
 * P7.3 high, 10 ms, low, 1 ms, high. */
void lcd_hw_reset_pulse(void)
{
    P7_PODR |= 0x08;  delay_ms(10);
    P7_PODR &= ~0x08; delay_ms(1);
    P7_PODR |= 0x08;
}

/* FFEDE298-FFEDE2B5 (29 B) lcd_write_cmd(c) [sub_FFEDE298] Confirmed (doc 51). */
void lcd_write_cmd(u8 c) { P8_PODR &= ~0x04; LCD_PORT = c; P8_PODR |= 0x04; }

/* FFEDE2B5-FFEDE2C3 (14 B) lcd_write_data8(d) [sub_FFEDE2B5] Confirmed. */
void lcd_write_data8(u8 d) { LCD_PORT = d; }

/* FFEDE2C3-FFEDE2D1 (14 B) lcd_write_data16(d) [sub_FFEDE2C3] Confirmed. */
void lcd_write_data16(u16 d) { LCD_PORT16 = d; }

/* ----------------------------------------------------------------------------
 * FFEDE2D1-FFEDE2FB (42 B)  tpu2_delay_init  [sub_FFEDE2D1]  Confirmed
 * Caller: sub_main.  TPU2 stopped, TCR2 = 0x22 (PCLK/16, clear on TGRA),
 * TIORH = 0, TGRA2 = 3000, TMDR = 0.  At PCLKB 48 MHz: 3 MHz / 3000 = 1 ms.
 * ------------------------------------------------------------------------- */
void tpu2_delay_init(void)
{
    TPU_TSTR &= ~0x04;
    REG8(TPU2 + 0)  = 0x22;
    REG8(TPU2 + 2)  = 0;
    REG16(TPU2 + 8) = 3000;
    REG8(TPU2 + 1)  = 0;
}

/* FFEDE2FB-FFEDE33C (65 B) delay_ms(n) [sub_FFEDE2FB] Confirmed.
 * Busy-wait on TPU2 compare-A flag (TSR2 0x88135), n periods of 1 ms. */
void delay_ms(u16 n)
{
    u16 i;
    REG16(TPU2 + 6) = 0;                   /* TCNT2 = 0x88136 */
    TPU_TSTR |= 0x04;
    for (i = 0; i < n; i++) {
        while (!(REG8(TPU2 + 5) & 0x01)) ;
        REG8(TPU2 + 5) &= ~0x01;
    }
    TPU_TSTR &= ~0x04;
}

/* FFEDE33C-FFEDE387 (75 B) lcd_blit_fullscreen_cpu(fb) [dead_FFEDE33C]
 * Confirmed, unreached.  CPU copy of a 320x240 RGB565 buffer (row stride
 * 0x280 bytes) to the panel; the live path uses EXDMAC (sub_FFEF1EFA). */
void lcd_blit_fullscreen_cpu(const u16 *fb)
{
    u16 x, y;
    lcd_set_window(0, 0x13F, 0, 0xEF);
    for (y = 0; y < 0xF0; y++)
        for (x = 0; x < 0x140; x++)
            lcd_write_data16(fb[y * 0x140 + x]);
}

/* ============================================================================
 * 5a. PICTURE SCREEN (screen id 0x3E; FF01 / FFFE / FFFF and F63x-busy)
 * Step table 0xFFED3F6C indexed by screen_step (0x8C4C), event table
 * 0xFFED3F8C indexed by ui_event (0x8F73).  doc 30, doc 51 sec.3, doc 109.
 * ========================================================================== */

/* ----------------------------------------------------------------------------
 * FFEDE387-FFEDE3E2 (91 B)  picture_screen_step  [sub_FFEDE387]  Confirmed
 * screen_tbl[0x3E] (0xFFED4148).  Clamps the step to 7; at step 0 of a new
 * FFxx frame the picture state is cleared; then runs picture_step_tbl[step]:
 *   0 picture_step0_enter      1 picture_step1_wait     2 picture_step2_draw_waiting
 *   3 picture_step3_await_transfer  4 picture_step4_decode  5 picture_step5_blit
 *   6 picture_step6_redraw     7 picture_step7_events
 * ------------------------------------------------------------------------- */
void picture_screen_step(void)
{
    if (screen_step > 7) { screen_step = 7; return; }
    if (pending_frame[0] == 0xFF && screen_step == 0) picture_state = 0;
    picture_step_tbl[screen_step]();
}

/* FFEDE3E2-FFEDE3F4 (18 B) picture_step0_enter [sub_FFEDE3E2] Confirmed.
 * Latch the frame into the shadow (with event reset) and advance. */
void picture_step0_enter(void) { picture_latch_frame(1); screen_step++; }

/* FFEDE3F4-FFEDE438 (68 B) picture_step1_wait [sub_FFEDE3F4] Confirmed.
 * Also picture_event_tbl[1].  If no picture is in progress (state <= 0):
 * for an FFFF frame re-init the surface (sub_FFEF032D) and sub_FFEFA747,
 * then advance; if a picture is already decoded, jump to step 5 (re-blit). */
void picture_step1_wait(void)
{
    if (picture_state > 0) { screen_step = 5; return; }
    if (frame_shadow[0] == 0xFF && frame_shadow[1] == 0xFF) {
        fb_surface_init();                   /* sub_FFEF032D */
        sub_FFEFA747();
    }
    screen_step++;
}

/* FFEDE438-FFEDE480 (72 B) picture_step2_draw_waiting [sub_FFEDE438]
 * Confirmed.  Open the full-screen surface (sub_FFEEF9BB(&fb_surface,0,0,
 * 320,240)); on success reset the overlay, draw "Waiting", start UI timer 3
 * with 0x65 ticks and flush (sub_FFEF0273, sub_FFEF0294). */
void picture_step2_draw_waiting(void)
{
    if (surface_open(fb_surface, 0, 0, 0x140, 0xF0) != 1) return;
    picture_reset_overlay();
    picture_draw_waiting();
    surface_close_rect();                    /* sub_FFEF036F */
    ui_timer_set(3, 0x65); ui_timer_start(3);
    sub_FFEF0273();
    sub_FFEF0294();
}

/* ----------------------------------------------------------------------------
 * FFEDE480-FFEDE523 (163 B)  picture_step3_await_transfer  [sub_FFEDE480]
 * Confirmed.  Latch the frame, refresh the "Waiting" banner.  For an F63x
 * shadow (camera/picture busy screens): when the block transfer finished OK
 * (blk_state 2) mark picture_state >= 1 and advance; if no transfer is
 * running (blk_state <= 1) report FFFE to MAIN and set blk_state 3.  Other
 * shadows: computes (shadow == FF01) into a local and drops it (dead store).
 * ------------------------------------------------------------------------- */
void picture_step3_await_transfer(void)
{
    picture_latch_frame(1);
    picture_update_waiting_banner();
    if (frame_shadow[0] == 0xF6 && (frame_shadow[1] >> 4) == 3) {
        if (blk_state == 2) {
            if (picture_state <= 0) picture_state = 1;
            screen_step++;
        } else if (blk_state <= 1) {
            link_send_status(0xFFFE);
            blk_state = 3;
        }
    }
    /* else: (frame_shadow == FF 01) evaluated and discarded */
}

/* ----------------------------------------------------------------------------
 * FFEDE523-FFEDE590 (109 B)  picture_step4_decode  [sub_FFEDE523]  Confirmed
 * Clear the decode target (0x25800 B at 0x070BB800, sub_FFEFB29A = memset),
 * decode the staged JPEG.  Success: stop UI timer 1, picture_state >= 2,
 * advance, blk_state = 0.  Failure: FFFE to MAIN, blk_state 3, back to step 2.
 * ------------------------------------------------------------------------- */
void picture_step4_decode(void)
{
    memset(FRAMEBUF_DEC, 0, 0x25800);
    if (jpeg_decode_to_framebuffer() == 1) {
        ui_timer_stop(1);
        if (picture_state <= 1) picture_state = 2;
        screen_step++;
        blk_state = 0;
    } else {
        link_send_status(0xFFFE);
        blk_state = 3;
        screen_step = 2;
    }
}

/* ----------------------------------------------------------------------------
 * FFEDE590-FFEDE61C (140 B)  picture_update_waiting_banner  [sub_FFEDE590]
 * Confirmed bytes, purpose Inferred.  Flush, then w = sub_FFEF02F2(); if it
 * changed since last time (0x12181) and the surface opens: w==1 -> draw the
 * "Waiting" text, else -> set shadow +0x13 = 3 and redraw icon
 * sub_FFF0B399(0x3B, 0x37); close the surface; remember w.
 * ------------------------------------------------------------------------- */
void picture_update_waiting_banner(void)
{
    u8 w;
    sub_FFEF0294();
    w = sub_FFEF02F2();
    if (last_waiting_state == w) return;
    if (surface_open(fb_surface, 0, 0, 0x140, 0xF0) != 1) return;
    if (w == 1) draw_text(0x6F, 0x42, 0x0D, 0, 7, "Waiting", 1);  /* sub_FFEF1B23 */
    else { frame_shadow[0x13] = 3; sub_FFF0B399(0x3B, 0x37); }
    surface_flush(fb_surface);               /* sub_FFEEFA9E */
    last_waiting_state = w;
}

/* ----------------------------------------------------------------------------
 * FFEDE61C-FFEDE6C4 (168 B)  picture_step5_blit  [sub_FFEDE61C]  Confirmed
 * Also called from sub_FFEFCE52.  Centres the decoded image: if it is larger
 * than 320x240 (w > 320 or h > 240) both are halved; if then w <= 160 and
 * h <= 120 both are doubled (the decoder up-scaled it, see jpeg_header_cb).
 * x = (320-w)/2, y = (240-h)/2, blit from 0x070BB800, advance.
 * ------------------------------------------------------------------------- */
void picture_step5_blit(void)
{
    u16 w = jpeg_wh[0], h = jpeg_wh[1];
    s16 x, y;
    if (w > 0x140 || h >= 0xF1) { w >>= 1; h >>= 1; }
    if (w <= 0xA0 && h <= 0x78) { w <<= 1; h <<= 1; }
    x = (s16)((0x140 - w) / 2);
    y = (s16)((0xF0 - h) / 2);
    blit_rgb565(x, y, w, h, FRAMEBUF_DEC);
    screen_step++;
}

/* FFEDE6C4-FFEDE6F1 (45 B) picture_step6_redraw [sub_FFEDE6C4] Confirmed.
 * Open the surface; on success reset the overlay and close (redraw frame). */
void picture_step6_redraw(void)
{
    if (surface_open(fb_surface, 0, 0, 0x140, 0xF0) == 1) {
        picture_reset_overlay();
        surface_close_rect();
    }
}

/* ----------------------------------------------------------------------------
 * FFEDE6F1-FFEDE776 (133 B)  picture_step7_events  [sub_FFEDE6F1]  Confirmed
 * Poll the touch/key event (sub_FFEF003F) into ui_event; none -> relatch the
 * frame without event reset.  Events 0..4, when no popup is up
 * (sub_FFEEFB84() == 0), are acknowledged (sub_FFEEFFEA) and dispatched via
 * picture_event_tbl {FFEF3991 (step=1), step1_wait, FFEF395E, step5_blit,
 * step6_redraw}.  Step is clamped to 7.
 * ------------------------------------------------------------------------- */
void picture_step7_events(void)
{
    ui_event = ui_poll_event();
    if (ui_event == 0xFF) picture_latch_frame(0);
    if (ui_event != 0xFF && ui_event <= 4 && ui_popup_active() == 0) {
        ui_event_ack(ui_event);
        picture_event_tbl[ui_event]();
    }
    if (screen_step >= 8) screen_step = 7;
}

/* FFEDE776-FFEDE792 (28 B) picture_latch_frame(reset_evt) [sub_FFEDE776]
 * Confirmed.  Shadow-latch helpers sub_FFEF4069 (bytes 0..1 etc.),
 * empty hook, sub_FFEF40BA (byte +0x13 popup); reset_evt==1 also clears the
 * event mask (sub_FFEF002C). */
void picture_latch_frame(u8 reset_evt)
{
    shadow_latch_header();                   /* sub_FFEF4069 */
    nop_hook();                              /* FFEDE792     */
    shadow_latch_mode();                     /* sub_FFEF40BA */
    if (reset_evt == 1) ui_event_mask_clear();
}

/* FFEDE792-FFEDE793 (1 B) nop_hook [sub_FFEDE792] Confirmed. rts only. */
void nop_hook(void) { }

/* FFEDE793-FFEDE7D0 (61 B) picture_reset_overlay [sub_FFEDE793] Confirmed.
 * Unless the shadow is FFFE: clear 0x8D79 and sub_FFEF0408(0,0). */
void picture_reset_overlay(void)
{
    if (frame_shadow[0] == 0xFF && frame_shadow[1] == 0xFE) return;
    ui_8D79 = 0;
    sub_FFEF0408(0, 0);
}

/* FFEDE7D0-FFEDE804 (52 B) picture_draw_waiting [sub_FFEDE7D0] Confirmed.
 * shadow +0x13 = 3, icon sub_FFF0B399(0x3B,0x37), text "Waiting" at
 * (0x6F,0x42). */
void picture_draw_waiting(void)
{
    frame_shadow[0x13] = 3;
    sub_FFF0B399(0x3B, 0x37);
    draw_text(0x6F, 0x42, 0x0D, 0, 7, "Waiting", 1);
}

/* ----------------------------------------------------------------------------
 * FFEDE804-FFEDE897 (147 B)  jpeg_decode_to_framebuffer -> u8  [sub_FFEDE804]
 * Confirmed (doc 30).  Callers: picture_step4_decode, sub_FFF3CAD0 (SD
 * preview).  Builds the decoder context on the stack: input 0x070E1000 /
 * 0x14000, output 0x070BB800 / 0x25800, sample clamp sub_FFF4C9D1, work
 * 0x070F5000 / 0x69C, mode 0x20, header callback jpeg_header_cb, and runs the
 * engine sub_FFF4B06C(ctx, &jpeg_wh, &consumed, 0).  Returns 1 on result 0;
 * stores the consumed length in jpeg_len (0x1CC58).
 * ------------------------------------------------------------------------- */
u8 jpeg_decode_to_framebuffer(void)
{
    struct {
        u8 *in; u32 in_len; u16 *out; u32 out_len; u32 z0;
        void *clamp; u8 *work; u32 work_len; u32 z1, z2, z3, z4;
        u32 mode; void *hdr_cb; u32 z5, z6; u8 b0, b1, b2;
    } ctx = { JPEG_IN_BUF, 0x14000, FRAMEBUF_DEC, 0x25800, 0,
              sub_FFF4C9D1, JPEG_WORK, 0x69C, 0, 0, 0, 0,
              0x20, jpeg_header_cb, 0, 0, 0, 0, 0 };
    u32 consumed;
    s32 r = jpeg_engine(&ctx, jpeg_wh, &consumed, 0);   /* sub_FFF4B06C */
    jpeg_len = consumed;
    return (r == 0) ? 1 : 0;
}

/* ----------------------------------------------------------------------------
 * FFEDE897-FFEDE8F8 (97 B)  jpeg_header_cb(ctx, wh, a3, mode) -> 0
 * [sub_FFEDE897]  Confirmed bytes, meaning Inferred.  Called by the decoder
 * through the context (pointer at FFEDE847).  In mode 0x20: output stride
 * 0x280 (640 B = 320 px) and ctx+0x42 = 1 (2x scale) when the image is at
 * most 160x120.  Then, if no popup (sub_FFEEFB66()==1), queries the screen id
 * (ui_get_screen_id, result unused) and runs the renderer sub_FFEEF94F so the
 * UI keeps updating during a long decode.
 * ------------------------------------------------------------------------- */
s32 jpeg_header_cb(u8 *ctx, const u16 *wh, void *a3, const u32 *mode)
{
    u16 w = wh[0], h = wh[1];
    if (*mode == 0x20) {
        *(u32 *)(ctx + 0x10) = 0x280;
        ctx[0x42] = (w <= 0xA0 && h <= 0x78) ? 1 : 0;
    }
    if (ui_no_popup() == 1) (void)ui_get_screen_id();
    ui_render();                             /* sub_FFEEF94F */
    return 0;
}

/* FFEDE8F8-FFEDE929 (49 B) blit_rgb565(x, y, w, h, src) [sub_FFEDE8F8]
 * Confirmed.  Builds {w, h, src, 0, 0xFFFF (key: none), 0} and calls
 * sub_FFEF0453(x, y, &desc).  Callers: picture_step5_blit, sub_FFF3CAD0. */
void blit_rgb565(u16 x, u16 y, u16 w, u16 h, const u16 *src)
{
    struct { u16 w, h; const u16 *src; u16 a, key, b; } d = { w, h, src, 0, 0xFFFF, 0 };
    surface_blit(x, y, &d);
}

/* FFEDE929-FFEDE93A (17 B) picture_get_state [sub_FFEDE929] Confirmed.
 * Callers: ipc_classify_f6, sub_FFEFCE52. */
s8 picture_get_state(void) { return picture_state; }

/* FFEDE93A-FFEDE96D (51 B) picture_get_jpeg_span(out) -> u8 [sub_FFEDE93A]
 * Confirmed.  Caller: sub_FFF3C911 (save to SD, doc pc-06).  out = {0x070E1000,
 * jpeg_len}; returns 1 only if a picture is decoded (state 2). */
u8 picture_get_jpeg_span(u32 *out)
{
    u8 ok = (picture_state == 2) ? 1 : 0;
    out[0] = 0x070E1000u;
    out[1] = jpeg_len;
    return ok;
}

/* FFEDE96D-FFEDE97B (14 B) picture_set_state(s) [sub_FFEDE96D] Confirmed.
 * Caller: sub_FFF3CAD0 (SD image load sets it). */
void picture_set_state(s8 s) { picture_state = s; }

/* ============================================================================
 * 5b. ALIGNMENT SCREEN (screen id 0x3F, IPC FD00; doc 137 sec.5)
 * Step table 0xFFED3FA0, event table 0xFFED3FB0 (0x24 entries).
 * The entry condition is deliberately not described (doc 137 scope note).
 * ========================================================================== */

/* FFEDE97B-FFEDE9A5 (42 B) align_screen_step [sub_FFEDE97B] Confirmed.
 * screen_tbl[0x3F]: steps 0..3, clamp to 3. */
void align_screen_step(void)
{
    if (screen_step > 3) { screen_step = 3; return; }
    align_step_tbl[screen_step]();
}

/* FFEDE9A5-FFEDE9B7 (18 B) align_step0_enter [sub_FFEDE9A5] Confirmed. */
void align_step0_enter(void) { align_latch_frame(1); screen_step++; }

/* FFEDE9B7-FFEDEA6A (179 B) align_step1_draw_headers [sub_FFEDE9B7]
 * Confirmed.  Also align_event_tbl[1].  Surface init, sub_FFEFA588, then the
 * three column headings "Adj", "Data", "Mode" 0x20 px apart starting at
 * (0x0A, 0x55); sub_FFEF9E8F(6); advance. */
void align_step1_draw_headers(void)
{
    u16 x0 = 0, y0 = 0x55, dx = 0x0A, dy = 5;
    fb_surface_init();
    sub_FFEFA588();
    draw_text(x0 + dx, y0 + dy, 0x0D, 0, 3, "Adj", 1);  dy += 0x20;
    draw_text(x0 + dx, y0 + dy, 0x0D, 0, 4, "Data", 1); dy += 0x20;
    draw_text(x0 + dx, y0 + dy, 0x0D, 0, 4, "Mode", 1);
    sub_FFEF9E8F(6);
    screen_step++;
}

/* FFEDEA6A-FFEDEA97 (45 B) align_step2_draw_body [sub_FFEDEA6A] Confirmed. */
void align_step2_draw_body(void)
{
    if (surface_open(fb_surface, 0, 0, 0x140, 0xF0) == 1) {
        align_draw_body();
        surface_close_rect();
    }
}

/* FFEDEA97-FFEDEACC (53 B) align_redraw_item [sub_FFEDEA97] Confirmed.
 * align_event_tbl[0x20]: reopen the item rectangle (0x42,0x5A,0xFE,0x61) and
 * redraw the item at (0x42, 0x5A). */
void align_redraw_item(void)
{
    if (surface_open(fb_surface, 0x42, 0x5A, 0xFE, 0x61) == 1) {
        align_draw_item(0x42, 0x5A);
        surface_close_rect();
    }
}

/* FFEDEACC-FFEDEB14 (72 B) align_redraw_footer [sub_FFEDEACC] Confirmed.
 * align_event_tbl[0x21] and [0x23]: rectangle (0, 0xB7, 320, 0x39) cleared by
 * sub_FFEF04F7, then sub_FFEF2505(0) and (2) (soft-key rows, Inferred). */
void align_redraw_footer(void)
{
    if (surface_open(fb_surface, 0, 0xB7, 0x140, 0x39) == 1) {
        surface_fill(0, 0xB7, 0x140, 0x39);  /* sub_FFEF04F7 */
        sub_FFEF2505(0);
        sub_FFEF2505(2);
        surface_close_rect();
    }
}

/* FFEDEB14-FFEDEB9A (134 B) align_step3_events [sub_FFEDEB14] Confirmed.
 * As picture_step7_events with events 0..0x23 and align_event_tbl; step
 * clamped to 3. */
void align_step3_events(void)
{
    ui_event = ui_poll_event();
    if (ui_event == 0xFF) align_latch_frame(0);
    if (ui_event != 0xFF && ui_event <= 0x23 && ui_popup_active() == 0) {
        ui_event_ack(ui_event);
        align_event_tbl[ui_event]();
    }
    if (screen_step >= 4) screen_step = 3;
}

/* FFEDEB9A-FFEDEBB6 (28 B) align_latch_frame(reset_evt) [sub_FFEDEB9A]
 * Confirmed.  As picture_latch_frame but with align_apply_frame_fields. */
void align_latch_frame(u8 reset_evt)
{
    shadow_latch_header();
    align_apply_frame_fields();
    shadow_latch_mode();
    if (reset_evt == 1) ui_event_mask_clear();
}

/* ----------------------------------------------------------------------------
 * FFEDEBB6-FFEDED2C (374 B)  align_apply_frame_fields  [sub_FFEDEBB6]
 * Confirmed.  Field-by-field apply of the FD00 frame into the shadow with
 * dirty flags (sub_FFEEFEEE(bit)): sub_FFEF4142 generic apply; pointer
 * 0x1D39C = &shadow[0x20]; sub_FFEF42A7(&shadow[0x20], &pending[0x20], 3);
 * item index/value +0x6C/+0x6D -> dirty 1; label/text bytes +0x6E..+0x7D
 * (16) -> dirty 1; +0x7E..+0x80 and +0x81..+0x83 -> dirty 2; +9 copied
 * silently; then flush (sub_FFEF0294).
 * ------------------------------------------------------------------------- */
void align_apply_frame_fields(void)
{
    u8 i;
    shadow_apply_common();                   /* sub_FFEF4142 */
    *(u8 **)0x0001D39C = &frame_shadow[0x20];
    sub_FFEF42A7(&frame_shadow[0x20], &pending_frame[0x20], 3);
    if (frame_shadow[0x6C] != pending_frame[0x6C] || frame_shadow[0x6D] != pending_frame[0x6D]) {
        ui_dirty(1);
        frame_shadow[0x6C] = pending_frame[0x6C];
        frame_shadow[0x6D] = pending_frame[0x6D];
    }
    for (i = 0; i <= 0x0F; i++)
        if (frame_shadow[0x6E + i] != pending_frame[0x6E + i]) {
            ui_dirty(1); frame_shadow[0x6E + i] = pending_frame[0x6E + i];
        }
    for (i = 0; i < 3; i++) {
        if (frame_shadow[0x7E + i] != pending_frame[0x7E + i]) {
            ui_dirty(2); frame_shadow[0x7E + i] = pending_frame[0x7E + i];
        }
        if (frame_shadow[0x81 + i] != pending_frame[0x81 + i]) {
            ui_dirty(2); frame_shadow[0x81 + i] = pending_frame[0x81 + i];
        }
    }
    if (frame_shadow[9] != pending_frame[9]) frame_shadow[9] = pending_frame[9];
    sub_FFEF0294();
}

/* FFEDED2C-FFEDED67 (59 B) align_draw_body [sub_FFEDED2C] Confirmed.
 * 0x8D79 = 0; sub_FFEF0408(0,0); sub_FFEF399F (frame); clip level 3;
 * indicators; clip off; item at (0x42,0x5A); soft-key rows 0 and 2. */
void align_draw_body(void)
{
    ui_8D79 = 0;
    sub_FFEF0408(0, 0);
    sub_FFEF399F();
    sub_FFEEC35B(3);
    align_draw_indicators();
    sub_FFEEC35B(-1);
    align_draw_item(0x42, 0x5A);
    sub_FFEF2505(0);
    sub_FFEF2505(2);
}

/* FFEDED67-FFEDED8F (40 B) align_draw_indicators [sub_FFEDED67] Inferred.
 * Callers: align_draw_body, sub_FFEEC08D.  Status-row icon painters
 * FFEF4FCE, FFEF5202, FFEF6096, FFEF5E38; if sub_FFEF4CED() != 1 also
 * FFEF5518 and FFEF59E4; then FFEF6023, FFEF637D. */
void align_draw_indicators(void)
{
    sub_FFEF4FCE(); sub_FFEF5202(); sub_FFEF6096(); sub_FFEF5E38();
    if (sub_FFEF4CED() != 1) { sub_FFEF5518(); sub_FFEF59E4(); }
    sub_FFEF6023(); sub_FFEF637D();
}

/* ----------------------------------------------------------------------------
 * FFEDED8F-FFEDEEF1 (354 B)  align_draw_item(x, y)  [sub_FFEDED8F]
 * Confirmed (doc 137 sec.5).  Clears the item area (x,y,320-x,0xBB-y), then
 * line 1: label align_labels[idx] (idx = shadow+0x6C, >15 -> 0; RAM copy of
 * FFED8E74 at 0x12182, 16-byte stride), max 15 chars;
 * line 2 (+0x0E, +0x20): the value shadow+0x6D printed with sub_FFEE1CE5
 * (decimal).  Item 13 with value > 0x40 is shown as "-" followed by
 * (0x100 - value), i.e. a signed byte (Confirmed code; the item's label is
 * table-driven);  line 3 (+0x20): the 16-char text shadow+0x6E.
 * ------------------------------------------------------------------------- */
void align_draw_item(u16 x, u16 y)
{
    char buf[5];
    u8 idx, val;
    u16 dx = 0, dy = 0;
    surface_fill(x, y, 0x140 - x, 0xBB - y);           /* -45h as uimm8 = 0xBB */
    idx = frame_shadow[0x6C];
    if (idx > 0x0F) idx = 0;
    draw_text(x + dx, y + dy, 0x0D, 0, 0x0F, (char *)align_labels[idx], 1);
    dx += 0x0E; dy += 0x20;
    memset(buf, 0, 4);
    val = frame_shadow[0x6D];
    if (idx != 0x0D || val <= 0x40) {
        utoa_dec(buf, val);                            /* sub_FFEE1CE5 */
        draw_text(x + dx, y + dy, 0x0D, 0, 3, buf, 1);
    } else {
        utoa_dec(buf + 1, 0x100 - val);
        buf[0] = '-';
        draw_text(x + dx, y + dy, 0x0D, 0, 4, buf, 1);
    }
    dy += 0x20;
    draw_text(x + dx, y + dy, 0x0D, 0, 0x10, (char *)&frame_shadow[0x6E], 1);
}

/* ============================================================================
 * 6. UI PHASE MACHINE AND IPC OPCODE -> SCREEN CLASSIFIER  (docs 25, 37, 43)
 * ui_phase (0x1CC60): 0 LCD power-up, 1 wait for wake, 2 run, 3 idle.
 * Phase table 0xFFED4040 = {ui_phase0_power_up, ui_phase1_wait_wake,
 * ui_phase2_run, ui_phase3_idle}.
 * ========================================================================== */

/* FFEDEEF1-FFEDEEFC (11 B) ui_init [sub_FFEDEEF1] Confirmed.
 * Caller: sub_main.  Phase reset, UI timer group (sub_FFEEFD64), screen reset. */
void ui_init(void) { ui_reset_phase(); ui_timers_init(); ui_reset_screen_state(); }

/* FFEDEEFC-FFEDEF41 (69 B) ui_reset_phase [sub_FFEDEEFC] Confirmed.
 * Phase 1 (wait), clear wake/valid, display flag 0, LCD sequencer reset,
 * sub_FFEF1E4C, sub_FFEF1DDA, sub_FFEEFA75, clear render_state[16], TPU3
 * normal rate (sub_FFF36B1E). */
void ui_reset_phase(void)
{
    ui_phase = 1;
    ui_wake_req = 0;
    screen_valid = 0;
    lcd_set_display_on_flag(0);
    lcd_seq_reset();
    sub_FFEF1E4C();
    sub_FFEF1DDA();
    sub_FFEEFA75();
    memset(render_state, 0, 0x10);
    tpu3_restore();
}

/* FFEDEF41-FFEDEF97 (86 B) ui_reset_screen_state [sub_FFEDEF41] Confirmed.
 * screen_id 0, prev 0xFF, step 0, 0x8D7D 0, clear shadow (sub_FFEF039B),
 * event mask clear, 0x8D7A/0x8A90 0, 0x8D7B = 0x8D7C = 3. */
void ui_reset_screen_state(void)
{
    screen_id = 0; screen_id_prev = 0xFF; screen_step = 0; ui_8D7D = 0;
    shadow_clear();
    ui_event_mask_clear();
    ui_8D7A = 0; mode_byte_saved = 0;
    ui_8D7B = 3; ui_8D7C = ui_8D7B;
}

/* FFEDEF97-FFEDEFC2 (43 B) ui_phase_dispatch [sub_FFEDEF97] Confirmed.
 * Caller: pump sub_FFF36CA2 (doc 51: "dispatches through off_FFED4040").
 * Steps the LCD sequencer, then the phase handler; out-of-range -> reset. */
void ui_phase_dispatch(void)
{
    lcd_seq_step();
    if (ui_phase <= 3) { ui_phase_tbl[ui_phase](); return; }
    ui_reset_phase();
    ui_reset_screen_state();
}

/* FFEDEFC2-FFEDEFF9 (55 B) ui_phase0_power_up [sub_FFEDEFC2] Confirmed.
 * LCD sequencer idle -> start state 1 (power-on); state 1 done -> reset the
 * sequencer and enter phase 2. */
void ui_phase0_power_up(void)
{
    u8 st = lcd_seq_get_state(), done = lcd_seq_get_done();
    if (st == 0) { lcd_seq_set(1); return; }
    if (st == 1 && done == 1) { lcd_seq_reset(); ui_phase = 2; }
}

/* FFEDEFF9-FFEDF016 (29 B) ui_phase1_wait_wake [sub_FFEDEFF9] Confirmed.
 * When ui_request_wake() has run (0x8A8F == 1): full reset, phase 0. */
void ui_phase1_wait_wake(void)
{
    if (ui_wake_req != 1) return;
    ui_reset_phase();
    ui_reset_screen_state();
    ui_phase = 0;
}

/* ----------------------------------------------------------------------------
 * FFEDF016-FFEDF1AA (404 B)  ui_phase2_run  [sub_FFEDF016]  Confirmed
 * The frame processor (doc 43 sec.?, "frame processor FFEDF069").  If the
 * LCD sequencer is busy, only wait for it.  Otherwise classify pending_frame
 * into screen_id; a change resets the screen state (ui_screen_change_reset).
 * Last step is 7 for the picture screen 0x3E, else 3.  Only when the
 * classifier produced a screen (0x8A8E == 1): 0x8D79 = 1 and, with no popup:
 *   - 0x8F72 = frame +7 bit0;
 *   - if step < last, or an event is pending, or no mode change (0x8D7A==0):
 *     run screen_tbl[screen_id]();
 *   - else a mode change is pending: 0x8D7A != 1 -> sub_FFF0B1DB() and, if it
 *     returns 1, remember mode byte (+0x13) in 0x8A90; 0x8D7A = 0.
 *     0x8D7A == 1 -> 0x8D7A = 2 and, if ui_mode_byte_changed(), run the
 *     screen twice (step 1 then step last-1) and sub_FFF0C9E3();
 *   - mode byte (+0x13) != 0 or 0x8D7A != 0 -> sub_FFEEFF25(0xFFFF800F),
 *     sub_FFEEFF38(-1) (event mask edits; constant shown as IDA's -7FF1h).
 * Finally the renderer sub_FFEEF94F runs whenever a screen was classified.
 * ------------------------------------------------------------------------- */
void ui_phase2_run(void)
{
    u8 last, run;
    if (lcd_seq_get_state() != 0) {
        if (lcd_seq_get_done() == 1) lcd_seq_reset();
        return;
    }
    screen_id = ipc_classify_opcode();
    if (screen_id != screen_id_prev) ui_screen_change_reset();
    last = (screen_id == 0x3E) ? 7 : 3;
    if (screen_valid != 1) return;
    ui_8D79 = 1;
    if (ui_no_popup() == 1) {
        ui_8F72 = pending_frame[7] & 1;
        run = (screen_step < last) || (ui_poll_event() != 0xFF) || (ui_8D7A == 0);
        if (run) {
            screen_tbl[screen_id]();
        } else if (ui_8D7A != 1) {
            if (sub_FFF0B1DB() == 1) mode_byte_saved = frame_shadow[0x13];
            ui_8D7A = 0;
        } else {
            ui_8D7A = 2;
            if (ui_mode_byte_changed() != 0) {
                ui_event_mask_clear();
                screen_step = 1;
                screen_tbl[screen_id]();
                screen_step = last - 1;
                screen_tbl[screen_id]();
                sub_FFF0C9E3();
            }
        }
        if (frame_shadow[0x13] != 0 || ui_8D7A != 0) {
            sub_FFEEFF25(0xFFFF800Fu);
            sub_FFEEFF38(-1);
        }
    }
    ui_render();
}

/* FFEDF1AA-FFEDF1AB (1 B) ui_phase3_idle [sub_FFEDF1AA] Confirmed. rts only. */
void ui_phase3_idle(void) { }

/* FFEDF1AB-FFEDF1BD (18 B) ui_get_phase [dead_FFEDF1AB] Confirmed, unreached. */
u8 ui_get_phase(void) { return (u8)ui_phase; }

/* FFEDF1BD-FFEDF1CE (17 B) ui_get_screen_id [sub_FFEDF1BD] Confirmed.
 * Caller: jpeg_header_cb. */
u8 ui_get_screen_id(void) { return screen_id; }

/* FFEDF1CE-FFEDF1D8 (10 B) ui_request_wake [sub_FFEDF1CE] Confirmed. Caller: sub_main. */
void ui_request_wake(void) { ui_wake_req = 1; }

/* ----------------------------------------------------------------------------
 * FFEDF1D8-FFEDF269 (145 B)  ipc_classify_opcode -> u8 screen  [sub_FFEDF1D8]
 * Confirmed (docs 25/37/43).  Caller: ui_phase2_run.  Family switch on
 * pending_frame[0] - 0xF0 (16 slots; F9..FC are unused and give 0xFF).
 * A result != 0xFF sets screen_valid = 1; 0xFF clears it and keeps the
 * current screen_id.
 * ------------------------------------------------------------------------- */
u8 ipc_classify_opcode(void)
{
    u8 r = 0;
    switch (pending_frame[0]) {
    case 0xF0: r = ipc_classify_f0(); break;
    case 0xF1: r = ipc_classify_f1(); break;
    case 0xF2: r = ipc_classify_f2(); break;
    case 0xF3: case 0xF4: r = ipc_classify_f3_f4(); break;
    case 0xF5: r = ipc_classify_f5(); break;
    case 0xF6: r = ipc_classify_f6(); break;
    case 0xF7: r = ipc_classify_f7(); break;
    case 0xF8: r = ipc_classify_f8(); break;
    case 0xFD: r = ipc_classify_fd(); break;
    case 0xFE: case 0xFF: r = ipc_classify_fe_ff(); break;
    default: break;                /* < F0 (bgtu) or F9..FC: r stays 0 */
    }
    if (r != 0xFF) { screen_valid = 1; return r; }
    screen_valid = 0;
    return screen_id;
}

/* ----------------------------------------------------------------------------
 * FFEDF269-FFEDF2E0 (119 B)  ipc_classify_f0 -> u8  [sub_FFEDF269]  Confirmed
 * F000 display off (flag 0 + DISPOFF via sub_FFEF2022), F001 display on
 * (flag 1 + sub_FFEF201A); both keep the screen (0xFF).  F002 0x12,
 * F003 AND F004 0x15 (missing break: 0x14 is stored and overwritten, doc 43),
 * F005 0x13, F006 0x16, F007 0x17, F008 0x18 (DSP WRITE), F009 0x19,
 * F00A 0x1A, F00B 0x1B.
 * ------------------------------------------------------------------------- */
u8 ipc_classify_f0(void)
{
    u8 r = 0xFF;
    if (pending_frame[0] != 0xF0) return r;
    switch (pending_frame[1]) {
    case 0: lcd_set_display_on_flag(0); lcd_display_off_cmd(); break;
    case 1: lcd_set_display_on_flag(1); lcd_display_on_cmd();  break;
    case 2: r = 0x12; break;
    case 3: case 4: r = 0x14; r = 0x15; break;
    case 5: r = 0x13; break;
    case 6: r = 0x16; break;
    case 7: r = 0x17; break;
    case 8: r = 0x18; break;
    case 9: r = 0x19; break;
    case 10: r = 0x1A; break;
    case 11: r = 0x1B; break;
    }
    return r;
}

/* FFEDF2E0-FFEDF36A (138 B) ipc_classify_f1 -> u8 [sub_FFEDF2E0] Confirmed.
 * F100..F10B -> 0..0x0B, F10D 0x0D, F10F 0x0F, F111 0x11, F112 0x42,
 * F113 0x41, F114 0x49, F115 0x4A; F102/F10C/F10E/F110 -> 0xFF. */
u8 ipc_classify_f1(void)
{
    static const u8 map[0x16] = { 0x00,0x01,0xFF,0x03,0x04,0x05,0x06,0x07,0x08,0x09,0x0A,
                                  0x0B,0xFF,0x0D,0xFF,0x0F,0xFF,0x11,0x42,0x41,0x49,0x4A };
    if (pending_frame[0] != 0xF1 || pending_frame[1] > 0x15) return 0xFF;
    return map[pending_frame[1]];
}

/* FFEDF36A-FFEDF3A7 (61 B) ipc_classify_f2 -> u8 [sub_FFEDF36A] Confirmed.
 * F280 -> 8; F200..F22C -> 0x1C. */
u8 ipc_classify_f2(void)
{
    if (pending_frame[0] != 0xF2) return 0xFF;
    if (pending_frame[1] == 0x80) return 0x08;
    if (pending_frame[1] <= 0x2C) return 0x1C;
    return 0xFF;
}

/* ----------------------------------------------------------------------------
 * FFEDF3A7-FFEDF447 (160 B)  ipc_classify_f3_f4 -> u8  [sub_FFEDF3A7]
 * Confirmed.  F3D5/F3D6 -> 0xFF (handled in the link layer); F300 0x1D,
 * F301 0x1E, F366 0x43, F3B3/F3B8 0x20, F3D1 0x21, any other F3xx 0x1F.
 * F400 0x1F, F401 0x45, F402 0x46, F403 0x47, F404 0x48.
 * ------------------------------------------------------------------------- */
u8 ipc_classify_f3_f4(void)
{
    u8 r = 0xFF, lo = pending_frame[1];
    if (pending_frame[0] == 0xF3 && (u8)(lo - 0xD5) >= 2) {
        switch (lo) {
        case 0x00: r = 0x1D; break;
        case 0x01: r = 0x1E; break;
        case 0x66: r = 0x43; break;
        case 0xB3: case 0xB8: r = 0x20; break;
        case 0xD1: r = 0x21; break;
        default:   r = 0x1F; break;
        }
    }
    if (pending_frame[0] == 0xF4) {
        switch (lo) {
        case 0: r = 0x1F; break; case 1: r = 0x45; break; case 2: r = 0x46; break;
        case 3: r = 0x47; break; case 4: r = 0x48; break;
        }
    }
    return r;
}

/* FFEDF447-FFEDF4B8 (113 B) ipc_classify_f5 -> u8 [sub_FFEDF447] Confirmed.
 * F500..F503 0x22, F510 0x23, F511 0x24, F512 0x25, F513..F515 0x20,
 * F516 0x26, F517 0x27, F518 0x28. */
u8 ipc_classify_f5(void)
{
    u8 lo = pending_frame[1];
    if (pending_frame[0] != 0xF5) return 0xFF;
    if (lo == 0x18) return 0x28;
    if (lo == 0x10) return 0x23;
    if (lo == 0x11) return 0x24;
    if (lo == 0x12) return 0x25;
    if ((u8)(lo - 0x13) < 3) return 0x20;
    if (lo == 0x16) return 0x26;
    if (lo == 0x17) return 0x27;
    if (lo <= 3)    return 0x22;
    return 0xFF;
}

/* ----------------------------------------------------------------------------
 * FFEDF4B8-FFEDF53E (134 B)  ipc_classify_f6 -> u8  [sub_FFEDF4B8]  Confirmed
 * F640 0x40; F600/F610 0x29; F620/F621 0x2A; F622 0x2B; F623 0x20;
 * F630..F632: if a decoded picture is up (picture_state == 2) screen 0x2C
 * (and step reset to 0 when it had reached 5), otherwise the picture screen
 * 0x3E (waits for the block transfer).
 * ------------------------------------------------------------------------- */
u8 ipc_classify_f6(void)
{
    u8 lo = pending_frame[1];
    if (pending_frame[0] != 0xF6) return 0xFF;
    if (lo == 0x40) return 0x40;
    if (lo == 0x10 || lo == 0x00) return 0x29;
    if ((u8)(lo - 0x20) < 2) return 0x2A;
    if (lo == 0x22) return 0x2B;
    if (lo == 0x23) return 0x20;
    if ((u8)(lo - 0x30) < 3) {
        if (picture_get_state() == 2) {
            if (screen_step >= 5) screen_step = 0;
            return 0x2C;
        }
        return 0x3E;
    }
    return 0xFF;
}

/* FFEDF53E-FFEDF56F (49 B) ipc_classify_f7 -> u8 [sub_FFEDF53E] Confirmed.
 * F701 0x2E, F703 0x44. */
u8 ipc_classify_f7(void)
{
    if (pending_frame[0] != 0xF7) return 0xFF;
    if (pending_frame[1] == 3) return 0x44;
    if (pending_frame[1] == 1) return 0x2E;
    return 0xFF;
}

/* FFEDF56F-FFEDF61B (172 B) ipc_classify_f8 -> u8 [sub_FFEDF56F] Confirmed.
 * F800 0x30, F801 0x31, F810..F816 0x32..0x38, F820..F824 0x39..0x3D. */
u8 ipc_classify_f8(void)
{
    u8 lo = pending_frame[1];
    if (pending_frame[0] != 0xF8) return 0xFF;
    if (lo == 0x00) return 0x30;
    if (lo == 0x01) return 0x31;
    if (lo >= 0x10 && lo <= 0x16) return 0x32 + (lo - 0x10);
    if (lo >= 0x20 && lo <= 0x24) return 0x39 + (lo - 0x20);
    return 0xFF;
}

/* FFEDF61B-FFEDF645 (42 B) ipc_classify_fd -> u8 [sub_FFEDF61B] Confirmed.
 * FD00 -> 0x3F (alignment screen). */
u8 ipc_classify_fd(void)
{
    return (pending_frame[0] == 0xFD && pending_frame[1] == 0) ? 0x3F : 0xFF;
}

/* FFEDF645-FFEDF677 (50 B) ipc_classify_fe_ff -> u8 [sub_FFEDF645] Confirmed.
 * FF01, FFFE, FFFF -> 0x3E (picture); FExx -> 0xFF. */
u8 ipc_classify_fe_ff(void)
{
    u8 lo = pending_frame[1];
    if (pending_frame[0] != 0xFF) return 0xFF;
    if (lo == 0x01 || (u8)(lo - 0xFE) <= 1) return 0x3E;
    return 0xFF;
}

/* FFEDF677-FFEDF6E3 (108 B) ui_screen_change_reset [sub_FFEDF677] Confirmed.
 * Caller: ui_phase2_run on a screen change. */
void ui_screen_change_reset(void)
{
    sub_FFEEFA75();
    memset(render_state, 0, 0x10);
    screen_id_prev = screen_id;
    ui_8D7C = ui_8D7B;
    screen_step = 0;
    memset(frame_shadow, 0, 0x12C);          /* sub_FFEFB29A */
    ui_event_mask_clear();
    ui_8D7A = 0; mode_byte_saved = 0; ui_8F74 = 0;
    sub_FFEF0306();
}

/* ----------------------------------------------------------------------------
 * FFEDF6E3-FFEDF777 (148 B)  ui_mode_byte_changed -> u8  [sub_FFEDF6E3]
 * Confirmed bytes, meaning Inferred.  For mode byte m = shadow +0x13 in the
 * families x0..x2 with x in {3,4,6,7,8,B,C,D,E} or F0..F2: returns 0 when the
 * saved byte 0x8A90 has the same high nibble (same family), else 1.  For any
 * other m it returns 1 whether or not it equals 0x8A90 (both branches leave
 * the initial 1).
 * ------------------------------------------------------------------------- */
u8 ui_mode_byte_changed(void)
{
    u8 m = frame_shadow[0x13];
    u8 hi = m >> 4, lo = m & 0x0F;
    int fam = (lo < 3) && (hi == 3 || hi == 4 || hi == 6 || hi == 7 || hi == 8 ||
                           hi == 0xB || hi == 0xC || hi == 0xD || hi == 0xE || hi == 0xF);
    if (fam) return ((mode_byte_saved >> 4) == hi) ? 0 : 1;
    return 1;                                /* (0x8A90 != m) -> 1, else stays 1 */
}

/* ============================================================================
 * 7. GPS  (doc 14 sec.3; SCI2 logical channel 1, MediaTek $PMTK)
 * ========================================================================== */

/* FFEDF777-FFEDF795 (30 B) gps_init [sub_FFEDF777] Confirmed.  Caller: sub_main.
 * Three-slot software timer group (counters 0x124CA, reloads 0xFFEB74D8):
 * slot 0 data-freshness tick, slot 1 command retry, slot 2 no-fix tick. */
void gps_init(void)
{
    gps_timer_grp = swtimer_group_create(3, gps_timer, gps_timer_reload);
    gps_reset_state();
}

/* ----------------------------------------------------------------------------
 * FFEDF795-FFEDF7F4 (95 B)  gps_set_power(on)  [sub_FFEDF795]  Confirmed
 * Caller: link_dispatch_frame (frame +7 b1 = 1 passes on=1).  want = on ? 1
 * : 2.  On a change: if it was on, P1.5 off and close channel 1; reset the
 * GPS state; if now on, P1.5 on (module power, Inferred) and open channel 1.
 * ------------------------------------------------------------------------- */
void gps_set_power(u8 on)
{
    u32 want = on ? 1 : 2;
    if (want == gps_power) return;
    if (gps_power == 1) { P1_PODR &= ~0x20; sci_channel_disable(1, 0x0101); }
    gps_reset_state();
    if (want == 1)      { P1_PODR |= 0x20;  sci_channel_enable(1, 0x0101); }
    gps_power = want;
}

/* FFEDF7F4-FFEDF81A (38 B) gps_power_off [sub_FFEDF7F4] Confirmed.
 * Caller: link_dispatch_frame (frame +7 b1 = 0).  Any non-0 state -> power
 * down (if on) and reset to 0. */
void gps_power_off(void)
{
    if (gps_power == 0) return;
    if (gps_power == 1) { P1_PODR &= ~0x20; sci_channel_disable(1, 0x0101); }
    gps_reset_state();
}

/* FFEDF81A-FFEDF86A (80 B) gps_request_datum(sel) [sub_FFEDF81A] Confirmed.
 * Only while on: 1..4 kept, anything else 0; stored in gps_datum_req.
 * (The link layer passes 2 or 0.) */
void gps_request_datum(u8 sel)
{
    u32 v;
    if (gps_power != 1) return;
    v = (sel >= 1 && sel <= 4) ? sel : 0;
    if (gps_datum_req != v) gps_datum_req = v;
}

/* FFEDF86A-FFEDF89E (52 B) gps_request_static_nav(on) [sub_FFEDF86A] Confirmed. */
void gps_request_static_nav(u8 on)
{
    u32 v;
    if (gps_power != 1) return;
    v = on ? 1 : 0;
    if (gps_nav_req != v) gps_nav_req = v;
}

/* FFEDF89E-FFEDF8DA (60 B) gps_request_dgps(sel) [sub_FFEDF89E] Confirmed.
 * 1 -> 1, 2 -> 2, else 0 (link layer passes 2 or 0). */
void gps_request_dgps(u8 sel)
{
    u32 v;
    if (gps_power != 1) return;
    v = (sel == 1) ? 1 : (sel == 2) ? 2 : 0;
    if (gps_dgps_req != v) gps_dgps_req = v;
}

/* FFEDF8DA-FFEDF904 (42 B) gps_init_pending [dead_FFEDF8DA] Confirmed, unreached.
 * 0 while on and the $PMTK init list is still being sent, else 1. */
u8 gps_init_pending(void)
{
    return (gps_power == 1 && (s32)gps_init_step <= 3) ? 0 : 1;
}

/* ---- accessors used by the GPS / position screen sub_FFEE9013.  Each one
 * returns the live fix data when its group is fresh, else the ROM defaults
 * at 0xFFED417C (same layout).  All Confirmed. ---- */

/* FFEDF904-FFEDF942 (62 B) gps_get_gga_info(out) [sub_FFEDF904]: quality, sats, alt. */
void gps_get_gga_info(u8 *out)
{
    const gps_fix_t *s = gps_valid[1] ? &gps_fix : &gps_fix_default;
    *(u32 *)out = s->fix_quality; out[4] = s->sats_used;
    out[5] = s->alt_negative; *(u16 *)(out + 6) = s->altitude_m;
}
/* FFEDF942-FFEDF972 (48 B) gps_get_satellites(out) [sub_FFEDF942]: 0xDA bytes from +0x30. */
void gps_get_satellites(u8 *out)
{
    const gps_fix_t *s = gps_valid[2] ? &gps_fix : &gps_fix_default;
    memcpy(out, &s->sats_in_view, 0xDA);     /* smovf */
}
/* FFEDF972-FFEDF9A6 (52 B) gps_get_date(out) [sub_FFEDF972]: yy, mm, dd. */
void gps_get_date(u8 *out)
{
    const gps_fix_t *s = gps_valid[0] ? &gps_fix : &gps_fix_default;
    out[0] = s->date[0]; out[1] = s->date[1]; out[2] = s->date[2];
}
/* FFEDF9A6-FFEDF9DC (54 B) gps_get_time(out) [sub_FFEDF9A6]: hh, mm, ss (UTC). */
void gps_get_time(u8 *out)
{
    const gps_fix_t *s = gps_valid[0] ? &gps_fix : &gps_fix_default;
    out[0] = s->time[0]; out[1] = s->time[1]; out[2] = s->time[2];
}
/* FFEDF9DC-FFEDFA32 (86 B) gps_get_position(out) [sub_FFEDF9DC]:
 * hemi, lat deg/min, lon deg/min, lat/lon minute fractions (BCD). */
void gps_get_position(u8 *out)
{
    const gps_fix_t *s = gps_valid[0] ? &gps_fix : &gps_fix_default;
    out[0] = s->hemi; out[1] = s->lat_deg; out[2] = s->lat_min;
    out[3] = s->lon_deg; out[4] = s->lon_min;
    *(u16 *)(out + 6) = s->lat_frac_bcd; *(u16 *)(out + 8) = s->lon_frac_bcd;
}
/* FFEDFA32-FFEDFA70 (62 B) gps_get_course_speed(out) [sub_FFEDFA32]:
 * course, speed, magnetic variation (BCD x10), variation-west flag. */
void gps_get_course_speed(u8 *out)
{
    const gps_fix_t *s = gps_valid[0] ? &gps_fix : &gps_fix_default;
    *(u16 *)out = s->course_bcd1; *(u16 *)(out + 2) = s->speed_bcd1;
    *(u16 *)(out + 4) = s->magvar_bcd1; out[6] = s->magvar_w;
}

/* ----------------------------------------------------------------------------
 * FFEDFA70-FFEDFB3B (203 B)  gps_tick  [sub_FFEDFA70]  Confirmed
 * Caller: tick fan-out sub_FFF36CAB.  While powered: assemble bytes, process
 * a complete sentence, step the $PMTK sequencer.  Timer slot 0 expiry:
 * restart it and age the three freshness flags (ttl 10 periods).  Slot 2
 * expiry: restart it and count down gps_nofix_cnt; at 0 request a warm
 * restart (0x8A92) and reload.
 * ------------------------------------------------------------------------- */
void gps_tick(void)
{
    s32 i;
    if (gps_power == 0) return;
    gps_rx_assemble();
    nmea_process_sentence();
    gps_command_sequencer();
    if (gps_timer[0] == 0) {
        swtimer_restart(gps_timer_grp, 0);
        for (i = 0; i < 3; i++)
            if (gps_valid[i]) {
                if (gps_valid_ttl[i] == 0) gps_valid[i] = 0;
                else                       gps_valid_ttl[i]--;
            }
    }
    if (gps_timer[2] != 0) return;
    swtimer_restart(gps_timer_grp, 2);
    if (gps_nofix_cnt != 0) { gps_nofix_cnt--; return; }
    gps_warm_req = 1;
    gps_nofix_cnt = gps_nofix_reload;
}

/* FFEDFB3B-FFEDFBE2 (167 B) gps_reset_state [sub_FFEDFB3B] Confirmed.
 * Callers: gps_init, gps_set_power, gps_power_off.  Power 0, init step 0,
 * datum/nav/dgps steps 1 (= nothing to send) with current/requested values
 * 5/5, 2/2, 3/3 (out-of-list "none" indices), no-fix counters 180, timers 1
 * and 2 restarted, fix data cleared. */
void gps_reset_state(void)
{
    gps_power = 0;
    gps_init_step = 0;
    gps_datum_step = 1; gps_datum_cur = 5; gps_datum_req = 5;
    gps_nav_step   = 1; gps_nav_cur   = 2; gps_nav_req   = 2;
    gps_dgps_step  = 1; gps_dgps_cur  = 3; gps_dgps_req  = 3;
    gps_cold_req = 0;
    gps_nofix_cnt = 0xB4; gps_nofix_reload = 0xB4;
    gps_warm_req = 0;
    swtimer_restart(gps_timer_grp, 1);
    swtimer_restart(gps_timer_grp, 2);
    gps_clear_fix();
}

/* FFEDFBE2-FFEDFC5D (123 B) gps_clear_fix [sub_FFEDFBE2] Confirmed.
 * Callers: gps_reset_state, gps_command_sequencer (cold start).  NMEA state 0,
 * fix struct <- ROM default (0x10C bytes), GSV work header FF FF FF and its
 * satellite block <- default, freshness flags and ttl 0. */
void gps_clear_fix(void)
{
    s32 i;
    nmea_rx_state = 0;
    memcpy(&gps_fix, &gps_fix_default, 0x10C);
    gsv_work[0] = gsv_work[1] = gsv_work[2] = 0xFF;
    memcpy(&gsv_work[4], &gps_fix_default.sats_in_view, 0xDA);
    for (i = 0; i < 3; i++) { gps_valid[i] = 0; gps_valid_ttl[i] = 0; }
}

/* ----------------------------------------------------------------------------
 * FFEDFC5D-FFEDFE33 (470 B)  gps_rx_assemble  [sub_FFEDFC5D]  Confirmed
 * Caller: gps_tick.  Reads channel 1 byte by byte while powered until the
 * ring is empty or a sentence is complete.  State 0 hunts '$'; state 1
 * stores bytes (max 255), XORs everything after '$' until '*', '\r' ends the
 * sentence (state 3; a sentence WITHOUT '*hh' is accepted), a new '$'
 * restarts; state 2 accumulates two hex digits and returns to state 1 when
 * they match the XOR (so the trailing '\r' completes it), else drops it.
 * ------------------------------------------------------------------------- */
void gps_rx_assemble(void)
{
    u8 c;
    while (gps_power == 1) {
        if (sci_read(1, &c, 1) == 0) return;
        switch (nmea_rx_state) {
        case 0:
            if (c == '$') { nmea_line[0] = '$'; nmea_len = 1; nmea_xor = 0; nmea_rx_state = 1; }
            break;
        case 1:
            nmea_line[nmea_len++] = c;
            if (nmea_len > 0xFF) { nmea_rx_state = 0; break; }
            nmea_line[nmea_len] = 0;
            if (c == '\r')      nmea_rx_state = 3;
            else if (c == '*')  { nmea_cksum_digits = 0; nmea_rx_cksum = 0; nmea_rx_state = 2; }
            else if (c == '$')  { nmea_line[0] = '$'; nmea_len = 1; nmea_xor = 0; }
            else                nmea_xor ^= c;
            break;
        case 2:
            nmea_line[nmea_len++] = c;
            if (nmea_len > 0xFF) { nmea_rx_state = 0; break; }
            nmea_line[nmea_len] = 0;
            nmea_rx_cksum = (u8)(nmea_rx_cksum << 4) + hexnib(c);   /* sub_FFEE206D */
            if (++nmea_cksum_digits >= 2)
                nmea_rx_state = (nmea_rx_cksum == nmea_xor) ? 1 : 0;
            break;
        }
        if (nmea_rx_state == 3) return;
    }
}

/* ----------------------------------------------------------------------------
 * FFEDFE33-FFEDFEB9 (134 B)  nmea_next_field -> u16 len  [sub_FFEDFE33]
 * Confirmed (doc 14: 30 call sites).  Copies the next field of nmea_line from
 * nmea_cursor into nmea_field (no terminator) and returns its length.  ','
 * and '\r' are consumed; '*' and NUL are not (so later calls return 0).  A
 * field longer than 31 characters returns 0xFFFF.
 * ------------------------------------------------------------------------- */
u16 nmea_next_field(void)
{
    u16 n = 0;
    u8  c = 0xFF;
    while (c != 0) {
        c = nmea_line[nmea_cursor];
        if (c == 0) break;
        if (c == '\r' || c == ',') { nmea_cursor++; c = 0; }
        else if (c == '*')         { c = 0; }
        else if (n <= 0x1F)        { nmea_field[n++] = c; nmea_cursor++; }
        else                       { c = 0; n = 0xFFFF; }
    }
    return n;
}

/* ----------------------------------------------------------------------------
 * FFEDFEB9-FFEE0191 (728 B)  nmea_process_sentence  [sub_FFEDFEB9]
 * Confirmed.  Caller: gps_tick.  Only when a sentence is complete.
 * Class (nmea_classify): 1 RMC, 2 GGA, 3 GSA, 4 VTG, 5 GSV, 6 $PMTK reply.
 *   RMC: relay (E1 / SD log), parse into rmc_work, and when status is 'A'
 *        copy date/time/position/course/speed into gps_fix, mark group 0
 *        fresh (ttl 10), cancel the warm-restart countdown (60 periods).
 *        Status 'V' only clears group 0 (ttl 10).
 *   GGA: relay, parse into gga_work, quality != 0 -> quality/sats/altitude
 *        into gps_fix, group 1 fresh, same no-fix reset.
 *   GSA: relay, skip mode, fix type -> +0x20, 12 PRNs -> +0x24, mark used.
 *   VTG: relay only.   GSV: nmea_parse_gsv.   PMTK: gps_pmtk_ack.
 * (doc 54/68: the function falls through FFEDFFFD..FFEE0006, once split.)
 * ------------------------------------------------------------------------- */
void nmea_process_sentence(void)
{
    u8 cls;
    if (nmea_rx_state != 3) return;
    nmea_cursor = 0;
    cls = nmea_classify();
    switch (cls) {
    case 1: /* RMC */
        link_send_gps_sentence((u8 *)nmea_line, nmea_len);
        nmea_parse_hhmmss(&rmc_work[7]);
        nmea_parse_status((u32 *)&rmc_work[0]);
        nmea_parse_latitude(&rmc_work[0x0A]);
        nmea_parse_ns(&rmc_work[0x0A]);
        nmea_parse_longitude(&rmc_work[0x0A]);
        nmea_parse_ew(&rmc_work[0x0A]);
        nmea_parse_speed(&rmc_work[0x14]);
        nmea_parse_course(&rmc_work[0x14]);
        nmea_parse_ddmmyy(&rmc_work[4]);
        nmea_parse_magvar(&rmc_work[0x14]);
        nmea_parse_magvar_ew(&rmc_work[0x14]);
        if (*(u32 *)&rmc_work[0]) {
            memcpy(gps_fix.date, &rmc_work[4], 3);
            memcpy(gps_fix.time, &rmc_work[7], 3);
            memcpy(&gps_fix.hemi, &rmc_work[0x0A], 5);
            gps_fix.lat_frac_bcd = *(u16 *)&rmc_work[0x10];
            gps_fix.lon_frac_bcd = *(u16 *)&rmc_work[0x12];
            gps_fix.course_bcd1  = *(u16 *)&rmc_work[0x14];
            gps_fix.speed_bcd1   = *(u16 *)&rmc_work[0x16];
            gps_fix.magvar_bcd1  = *(u16 *)&rmc_work[0x18];
            gps_fix.magvar_w     = rmc_work[0x1A];
            gps_valid[0] = 1; gps_valid_ttl[0] = 10;
            gps_warm_req = 0; gps_nofix_reload = 0x3C; gps_nofix_cnt = 0x3C;
            swtimer_restart(gps_timer_grp, 2);
        } else {
            gps_valid[0] = 0; gps_valid_ttl[0] = 10;
        }
        break;
    case 2: /* GGA */
        link_send_gps_sentence((u8 *)nmea_line, nmea_len);
        nmea_parse_hhmmss(&gga_work[0]);
        nmea_parse_latitude(&gga_work[4]);
        nmea_parse_ns(&gga_work[4]);
        nmea_parse_longitude(&gga_work[4]);
        nmea_parse_ew(&gga_work[4]);
        nmea_parse_fix_quality((u32 *)&gga_work[0x10]);
        nmea_parse_sat_count(&gga_work[0x14]);
        nmea_skip_field();                               /* HDOP */
        nmea_parse_altitude(&gga_work[0x15], (u16 *)&gga_work[0x16]);
        if (*(u32 *)&gga_work[0x10]) {
            gps_fix.fix_quality  = *(u32 *)&gga_work[0x10];
            gps_fix.sats_used    = gga_work[0x14];
            gps_fix.alt_negative = gga_work[0x15];
            gps_fix.altitude_m   = *(u16 *)&gga_work[0x16];
            gps_valid[1] = 1; gps_valid_ttl[1] = 10;
            gps_warm_req = 0; gps_nofix_reload = 0x3C; gps_nofix_cnt = 0x3C;
            swtimer_restart(gps_timer_grp, 2);
        } else {
            gps_valid[1] = 0; gps_valid_ttl[1] = 10;
        }
        break;
    case 3: /* GSA */
        link_send_gps_sentence((u8 *)nmea_line, nmea_len);
        nmea_skip_field();                               /* mode A/M */
        nmea_parse_gsa_fix(&gps_fix.fix_type);
        nmea_parse_gsa_prns(gps_fix.prn_used);
        gps_mark_used_sats();
        break;
    case 4: link_send_gps_sentence((u8 *)nmea_line, nmea_len); break;  /* VTG */
    case 5: nmea_parse_gsv(); break;
    case 6: gps_pmtk_ack();  break;
    }
    nmea_rx_state = 0;
}

/* ----------------------------------------------------------------------------
 * FFEE0191-FFEE0360 (463 B)  nmea_classify -> u8  [sub_FFEE0191]  Confirmed
 * Reads field 0.  Length 6 ("$xxYYY"): chars 3..5 GGA 2, GSA 3, RMC 1, VTG 4,
 * GSV 5 (talker ignored).  Length 8 "$PMTKnnn" -> 6.  Else 0.
 * ------------------------------------------------------------------------- */
u8 nmea_classify(void)
{
    u16 n = nmea_next_field();
    const char *f = nmea_field;
    if (n == 6) {
        if (f[3] == 'G' && f[4] == 'G' && f[5] == 'A') return 2;
        if (f[3] == 'G' && f[4] == 'S' && f[5] == 'A') return 3;
        if (f[3] == 'R' && f[4] == 'M' && f[5] == 'C') return 1;
        if (f[3] == 'V' && f[4] == 'T' && f[5] == 'G') return 4;
        if (f[3] == 'G' && f[4] == 'S' && f[5] == 'V') return 5;
    } else if (n == 8) {
        if (f[1] == 'P' && f[2] == 'M' && f[3] == 'T' && f[4] == 'K') return 6;
    }
    return 0;
}

/* FFEE0360-FFEE0364 (4 B) nmea_skip_field [sub_FFEE0360] Confirmed. */
void nmea_skip_field(void) { (void)nmea_next_field(); }

/* FFEE0364-FFEE03D2 (110 B) nmea_parse_hhmmss(dst) [sub_FFEE0364] Confirmed.
 * dst[0..2] = FF; >=4 chars: hh, mm (sub_FFEE20F8 = two ASCII digits ->
 * value via tens table 0xFFEB751A); >=6: ss else 0. */
void nmea_parse_hhmmss(u8 *dst)
{
    u16 n = nmea_next_field();
    if (!dst) return;
    dst[0] = dst[1] = dst[2] = 0xFF;
    if (n < 4) return;
    dst[0] = dec2(nmea_field[0], nmea_field[1]);
    dst[1] = dec2(nmea_field[2], nmea_field[3]);
    dst[2] = (n >= 6) ? dec2(nmea_field[4], nmea_field[5]) : 0;
}

/* FFEE03D2-FFEE03FB (41 B) nmea_parse_status(dst) [sub_FFEE03D2] Confirmed.
 * *dst = (field == "A"). */
void nmea_parse_status(u32 *dst)
{
    u16 n = nmea_next_field();
    *dst = 0;
    if (n == 1 && nmea_field[0] == 'A') *dst = 1;
}

/* FFEE03FB-FFEE045D (98 B) nmea_parse_ddmmyy(dst) [sub_FFEE03FB] Confirmed.
 * dst = {yy, mm, dd}, FF if the field is not exactly 6 chars. */
void nmea_parse_ddmmyy(u8 *dst)
{
    u16 n = nmea_next_field();
    if (!dst) return;
    dst[0] = dst[1] = dst[2] = 0xFF;
    if (n != 6) return;
    dst[2] = dec2(nmea_field[0], nmea_field[1]);
    dst[1] = dec2(nmea_field[2], nmea_field[3]);
    dst[0] = dec2(nmea_field[4], nmea_field[5]);
}

/* ----------------------------------------------------------------------------
 * FFEE045D-FFEE0547 (234 B)  nmea_parse_latitude(pos)  [sub_FFEE045D]
 * Confirmed.  "ddmm.ffff": pos[1] = deg, pos[2] = min, *(u16*)(pos+6) =
 * minute fraction as 4 packed BCD digits (field chars 5..8), missing digits
 * left as F (switch on length 6/7/8/>=9 with deliberate fall-through).
 * ------------------------------------------------------------------------- */
static u16 bcd4_from(const char *f, u16 n, u16 first)
{
    u16 v = 0xFFFF;
    switch (n - first) {                /* number of fraction digits present */
    default: v = (v & 0xFFF0) | (hexnib(f[first + 3]) & 0x0F);         /* fall through */
    case 3:  v = (v & 0xFF0F) | ((hexnib(f[first + 2]) & 0x0F) << 4);  /* fall through */
    case 2:  v = (v & 0xF0FF) | ((hexnib(f[first + 1]) & 0x0F) << 8);  /* fall through */
    case 1:  v = (v & 0x0FFF) | ((u16)hexnib(f[first]) << 12);
    }
    return v;
}
void nmea_parse_latitude(u8 *pos)
{
    u16 n = nmea_next_field();
    if (!pos) return;
    pos[1] = 0xFF; pos[2] = 0xFF; *(u16 *)(pos + 6) = 0xFFFF;
    if (n < 4) return;
    pos[1] = dec2(nmea_field[0], nmea_field[1]);
    pos[2] = dec2(nmea_field[2], nmea_field[3]);
    if (n < 6) return;
    *(u16 *)(pos + 6) = bcd4_from(nmea_field, n, 5);
}

/* FFEE0547-FFEE0650 (265 B) nmea_parse_longitude(pos) [sub_FFEE0547] Confirmed.
 * "dddmm.ffff": pos[3] = (first digit != 0 ? 100 : 0) + dd, pos[4] = min,
 * *(u16*)(pos+8) = fraction (chars 6..9).  The hundreds digit is treated as
 * 0/1 only, which suffices for 0..180. */
void nmea_parse_longitude(u8 *pos)
{
    u16 n = nmea_next_field();
    if (!pos) return;
    pos[3] = 0xFF; pos[4] = 0xFF; *(u16 *)(pos + 8) = 0xFFFF;
    if (n < 5) return;
    pos[3] = hexnib(nmea_field[0]) ? 100 : 0;
    pos[3] += dec2(nmea_field[1], nmea_field[2]);
    pos[4] = dec2(nmea_field[3], nmea_field[4]);
    if (n < 7) return;
    *(u16 *)(pos + 8) = bcd4_from(nmea_field, n, 6);
}

/* FFEE0650-FFEE067F (47 B) nmea_parse_ns(pos) [sub_FFEE0650] Confirmed.
 * pos[0] = 0, or 2 for "S" (also clears any W bit set earlier). */
void nmea_parse_ns(u8 *pos)
{
    u16 n = nmea_next_field();
    if (!pos) return;
    pos[0] = 0;
    if (n == 1 && nmea_field[0] == 'S') pos[0] = 2;
}

/* FFEE067F-FFEE06A8 (41 B) nmea_parse_ew(pos) [sub_FFEE067F] Confirmed. pos[0] |= 1 for "W". */
void nmea_parse_ew(u8 *pos)
{
    u16 n = nmea_next_field();
    if (pos && n == 1 && nmea_field[0] == 'W') pos[0] |= 0x01;
}

/* FFEE06A8-FFEE06C8 (32 B) nmea_parse_speed(cs) [sub_FFEE06A8] Confirmed.
 * cs+2 = BCD x10 of the speed field (knots). */
void nmea_parse_speed(u8 *cs) { u16 n = nmea_next_field(); if (cs) *(u16 *)(cs + 2) = nmea_field_to_bcd1(n); }

/* FFEE06C8-FFEE06E8 (32 B) nmea_parse_course(cs) [sub_FFEE06C8] Confirmed. cs+0. */
void nmea_parse_course(u8 *cs) { u16 n = nmea_next_field(); if (cs) *(u16 *)(cs + 0) = nmea_field_to_bcd1(n); }

/* FFEE06E8-FFEE0708 (32 B) nmea_parse_magvar(cs) [sub_FFEE06E8] Confirmed. cs+4. */
void nmea_parse_magvar(u8 *cs) { u16 n = nmea_next_field(); if (cs) *(u16 *)(cs + 4) = nmea_field_to_bcd1(n); }

/* FFEE0708-FFEE0737 (47 B) nmea_parse_magvar_ew(cs) [sub_FFEE0708] Confirmed. cs[6] = (field=="W"). */
void nmea_parse_magvar_ew(u8 *cs)
{
    u16 n = nmea_next_field();
    if (!cs) return;
    cs[6] = 0;
    if (n == 1 && nmea_field[0] == 'W') cs[6] = 1;
}

/* FFEE0737-FFEE077C (69 B) nmea_parse_fix_quality(dst) [sub_FFEE0737] Confirmed.
 * "1" -> 1, "2" -> 2, else 0. */
void nmea_parse_fix_quality(u32 *dst)
{
    u16 n = nmea_next_field();
    if (!dst) return;
    if (n == 1 && nmea_field[0] == '2')      *dst = 2;
    else if (n == 1 && nmea_field[0] == '1') *dst = 1;
    else                                     *dst = 0;
}

/* FFEE077C-FFEE07D0 (84 B) nmea_parse_sat_count(dst) [sub_FFEE077C] Confirmed.
 * *dst = FF; fields of <= 2 digits are converted. */
void nmea_parse_sat_count(u8 *dst)
{
    u16 n = nmea_next_field(), i;
    u8 v = 0;
    if (!dst) return;
    *dst = 0xFF;
    if (n > 2) return;
    for (i = 0; i < n; i++) v = v * 10 + hexnib(nmea_field[i]);
    *dst = v;
}

/* FFEE07D0-FFEE0853 (131 B) nmea_parse_altitude(neg, alt) [sub_FFEE07D0]
 * Confirmed.  *alt = FFFF for an empty field; else sign flag from a leading
 * '-', integer metres up to the '.'. */
void nmea_parse_altitude(u8 *neg, u16 *alt)
{
    u16 n = nmea_next_field(), i = 0;
    if (!alt) return;
    *alt = 0xFFFF;
    if (n == 0) return;
    *neg = 0;
    if (nmea_field[0] == '-') { *neg = 1; i = 1; }
    *alt = 0;
    for (; i < n; i++) {
        if (nmea_field[i] == '.') break;
        *alt = *alt * 10 + (hexnib(nmea_field[i]) & 0x0F);
    }
}

/* ----------------------------------------------------------------------------
 * FFEE0853-FFEE0B54 (769 B)  nmea_parse_gsv  [sub_FFEE0853]  Confirmed
 * Fields: total messages (1..9), message number (1..9), sats in view, then
 * groups {PRN, elevation, azimuth, SNR}.  Message 1 restarts the work table
 * 0x123E2 {total, msgno, n, pad, in_view, pad, rec[36] stride 6}; later
 * messages must match the expected (total, msgno).  A record with PRN 0
 * stops consuming its group (the next field is then read as a PRN).
 * Azimuth is parsed with nmea_field_to_bcd1, the rest with nmea_field_to_uint.
 * After the last message the records are ordered BY PRN ASCENDING (exchange
 * sort on byte 0 of each record - doc 14 says "by SNR"; the compared byte is
 * the PRN at record offset 0, SNR is offset 4) and all 36 slots are copied
 * through the index into gps_fix.sat[], count -> +0x30, used flags redone.
 * If no satellite is in view while the no-fix reload is 60 (i.e. a fix was
 * seen before), the warm-restart countdown is reset to 180.  Group 2 fresh.
 * ------------------------------------------------------------------------- */
void nmea_parse_gsv(void)
{
    u8 total = 0xFF, msgno = 0xFF, idx[36], i, j, t;
    u16 n;
    u8 *rec = &gsv_work[6];                         /* 0x123E8 */
    n = nmea_next_field();
    if (n == 1) total = hexnib(nmea_field[0]);
    if (total == 0 || total >= 10) return;
    n = nmea_next_field();
    if (n == 1) msgno = hexnib(nmea_field[0]);
    if (msgno == 0 || msgno >= 10) return;
    n = nmea_next_field();                          /* satellites in view */
    if (msgno == 1) {
        if (n == 0) return;
        gsv_work[0] = total; gsv_work[1] = msgno; gsv_work[2] = 0;
        memcpy(&gsv_work[4], &gps_fix_default.sats_in_view, 0xDA);
        gsv_work[4] = (u8)nmea_field_to_uint(n);
    } else if (gsv_work[0] != total || gsv_work[1] != msgno) {
        return;
    }
    while ((n = nmea_next_field()) != 0) {
        u8 k = gsv_work[2];
        rec[k * 6 + 0] = (u8)nmea_field_to_uint(n);
        if (rec[k * 6 + 0] == 0) continue;
        if ((n = nmea_next_field()) != 0) rec[k * 6 + 1] = (u8)nmea_field_to_uint(n);
        if ((n = nmea_next_field()) != 0) *(u16 *)&rec[k * 6 + 2] = nmea_field_to_bcd1(n);
        if ((n = nmea_next_field()) != 0) rec[k * 6 + 4] = (u8)nmea_field_to_uint(n);
        gsv_work[2]++;
    }
    if (gsv_work[1] < gsv_work[0]) { gsv_work[1]++; return; }

    for (i = 0; i < 36; i++) idx[i] = i;
    for (i = 0; (s32)i < (s32)gsv_work[2] - 1; i++)
        for (j = i + 1; j < gsv_work[2]; j++)
            if (rec[idx[i] * 6] > rec[idx[j] * 6]) { t = idx[j]; idx[j] = idx[i]; idx[i] = t; }
    for (i = 0; i < 36; i++) {
        gps_fix.sat[i].prn     = rec[idx[i] * 6 + 0];
        gps_fix.sat[i].elev    = rec[idx[i] * 6 + 1];
        gps_fix.sat[i].az_bcd1 = *(u16 *)&rec[idx[i] * 6 + 2];
        gps_fix.sat[i].snr     = rec[idx[i] * 6 + 4];
        gps_fix.sat[i].used    = rec[idx[i] * 6 + 5];
    }
    gps_fix.sats_in_view = gsv_work[2];
    gps_mark_used_sats();
    if (gps_fix.sats_in_view == 0 && gps_nofix_reload == 0x3C) {
        gps_warm_req = 0;
        gps_nofix_reload = 0xB4; gps_nofix_cnt = 0xB4;
        swtimer_restart(gps_timer_grp, 2);
    }
    gsv_work[0] = 0xFF; gsv_work[1] = 0xFF;
    gps_valid[2] = 1; gps_valid_ttl[2] = 10;
}

/* FFEE0B54-FFEE0B92 (62 B) nmea_parse_gsa_fix(dst) [sub_FFEE0B54] Confirmed.
 * "2" -> 1 (2D), "3" -> 2 (3D), else 0. */
void nmea_parse_gsa_fix(u32 *dst)
{
    u16 n = nmea_next_field();
    if (!dst || n != 1) return;
    *dst = (nmea_field[0] == '3') ? 2 : (nmea_field[0] == '2') ? 1 : 0;
}

/* FFEE0B92-FFEE0BE2 (80 B) nmea_parse_gsa_prns(dst) [sub_FFEE0B92] Confirmed.
 * dst[0..11] = FF, then up to 12 PRNs; stops at the first empty field. */
void nmea_parse_gsa_prns(u8 *dst)
{
    u8 i; u16 n;
    if (!dst) return;
    for (i = 0; i < 12; i++) dst[i] = 0xFF;
    for (i = 0; i < 12; i++) {
        if ((n = nmea_next_field()) == 0) return;
        dst[i] = (u8)nmea_field_to_uint(n);
    }
}

/* FFEE0BE2-FFEE0C85 (163 B) gps_mark_used_sats [sub_FFEE0BE2] Confirmed.
 * For 1..0xFE satellites in view: used = 1 where the PRN is in the GSA list. */
void gps_mark_used_sats(void)
{
    u8 i, k;
    if (gps_fix.sats_in_view == 0 || gps_fix.sats_in_view == 0xFF) return;
    for (i = 0; i < gps_fix.sats_in_view; i++) gps_fix.sat[i].used = 0;
    for (k = 0; k < 12; k++)
        for (i = 0; i < gps_fix.sats_in_view; i++)
            if (gps_fix.prn_used[k] == gps_fix.sat[i].prn) gps_fix.sat[i].used = 1;
}

/* FFEE0C85-FFEE0CF3 (110 B) nmea_field_to_bcd1(len) -> u16 [sub_FFEE0C85]
 * Confirmed.  Packed BCD with ONE implied decimal: digits shifted in as
 * nibbles, parsing stops after the first digit behind '.', and a missing
 * tenths digit is supplied as 0 ("12" -> 0x0120, "12.34" -> 0x0123).
 * (doc 14 described it as "hex with '.' handling".) */
u16 nmea_field_to_bcd1(u16 n)
{
    u8 dot = 0; u16 v = 0, i;
    for (i = 0; i < n; i++) {
        if (nmea_field[i] == '.') { dot = 1; continue; }
        v = (u16)(v << 4) | (hexnib(nmea_field[i]) & 0x0F);
        if (dot) { dot = 2; break; }
    }
    if (dot <= 1) v <<= 4;
    return v;
}

/* FFEE0CF3-FFEE0D4D (90 B) nmea_field_to_uint(len) -> u16 [sub_FFEE0CF3]
 * Confirmed.  Decimal, at most 4 digits.  A '-' yields 0 and stops (doc 14
 * called it signed; negative values collapse to 0). */
u16 nmea_field_to_uint(u16 n)
{
    u16 v = 0, i;
    if (n >= 5) n = 4;
    for (i = 0; i < n; i++) {
        if (nmea_field[i] == '-') { v = 0; break; }
        v = v * 10 + hexnib(nmea_field[i]);
    }
    return v;
}

/* ----------------------------------------------------------------------------
 * FFEE0D4D-FFEE0FA3 (598 B)  gps_command_sequencer  [sub_FFEE0D4D]
 * Confirmed (doc 14 "ACK-gated state machine").  Runs while powered and the
 * retry timer (slot 1) has expired.  Priority order:
 *   init list (step 0..3, re-sent on every timeout until ACKed);
 *   datum (step 0 -> send pmtk_datum[1 + cur]); static nav; DGPS (same);
 *   cold start ($PMTK103 + clear fix) if gps_cold_req;
 *   warm start ($PMTK102) if gps_warm_req (no fix for N slot-2 periods);
 *   otherwise copy changed requests into current and re-arm the step
 *   (a datum change from a real value also requests a cold start).
 * The "step <= 0" tests use signed compares; only 0 occurs, so the negative-
 * index branches (pmtk_xxx[step]) are unreachable.  Initial cur values 5/2/3
 * index one past each list (the next list's "" entry) = "none".
 * ------------------------------------------------------------------------- */
void gps_command_sequencer(void)
{
    if (gps_power != 1 || gps_timer[1] != 0) return;
    if ((s32)gps_init_step <= 3) {
        gps_send_pmtk(pmtk_init[gps_init_step]);
        swtimer_restart(gps_timer_grp, 1); return;
    }
    if ((s32)gps_datum_step <= 0) {
        gps_send_pmtk(gps_datum_step == 0 ? pmtk_datum[1 + gps_datum_cur] : pmtk_datum[gps_datum_step]);
        swtimer_restart(gps_timer_grp, 1); return;
    }
    if ((s32)gps_nav_step <= 0) {
        gps_send_pmtk(gps_nav_step == 0 ? pmtk_nav[1 + gps_nav_cur] : pmtk_nav[gps_nav_step]);
        swtimer_restart(gps_timer_grp, 1); return;
    }
    if ((s32)gps_dgps_step <= 0) {
        gps_send_pmtk(gps_dgps_step == 0 ? pmtk_dgps[1 + gps_dgps_cur] : pmtk_dgps[gps_dgps_step]);
        swtimer_restart(gps_timer_grp, 1); return;
    }
    if (gps_cold_req) {
        gps_send_pmtk("$PMTK103");                      /* cold restart */
        gps_clear_fix();
        gps_cold_req = 0; gps_warm_req = 0;
        gps_nofix_reload = 0xB4; gps_nofix_cnt = 0xB4;
        swtimer_restart(gps_timer_grp, 2);
        return;
    }
    if (gps_warm_req) {
        gps_send_pmtk("$PMTK102");                      /* warm restart */
        gps_warm_req = 0;
        gps_nofix_cnt = gps_nofix_reload;
        swtimer_restart(gps_timer_grp, 2);
        return;
    }
    if (gps_datum_req != gps_datum_cur) {
        if (gps_datum_cur != 5) gps_cold_req = 1;
        gps_datum_cur = gps_datum_req;
        gps_datum_step = 0;
    }
    if (gps_nav_req != gps_nav_cur)   { gps_nav_cur = gps_nav_req;   gps_nav_step = 0; }
    if (gps_dgps_req != gps_dgps_cur) { gps_dgps_cur = gps_dgps_req; gps_dgps_step = 0; }
}

/* ----------------------------------------------------------------------------
 * FFEE0FA3-FFEE103B (152 B)  gps_send_pmtk(cmd)  [sub_FFEE0FA3]  Confirmed
 * (doc 14 hand-reconstruction confirmed).  Appends "*hh\r\n" with the XOR of
 * all chars after the first; an empty string would go out as "*00\r\n".
 * hex2 = sub_FFEE1C6A (digits from 0xFFC0012D).  Sent on channel 1.
 * ------------------------------------------------------------------------- */
void gps_send_pmtk(const char *cmd)
{
    u8 cs = 0, c;
    u16 i = 0;
    while ((c = (u8)cmd[i]) != 0) {
        pmtk_txbuf[i] = c;
        if (i != 0) cs ^= c;
        i++;
    }
    pmtk_txbuf[i++] = '*';
    hex2(&pmtk_txbuf[i], cs);  i += 2;
    pmtk_txbuf[i++] = '\r';
    pmtk_txbuf[i++] = '\n';
    sci_write(1, (u8 *)pmtk_txbuf, i);
}

/* ----------------------------------------------------------------------------
 * FFEE103B-FFEE1105 (202 B)  gps_pmtk_ack  [sub_FFEE103B]  Confirmed
 * Caller: nmea_process_sentence (class 6).  While a command is outstanding
 * (powered, retry timer running), a reply whose field 0 is "$PMTK001" advances
 * the first incomplete stage (init, datum, nav, DGPS) and stops the retry
 * timer.  The acknowledged command number and the ACK status field are not
 * checked.
 * ------------------------------------------------------------------------- */
void gps_pmtk_ack(void)
{
    u16 i;
    if (gps_power != 1 || gps_timer[1] == 0) return;
    for (i = 0; i < 8; i++)
        if (nmea_field[i] != "$PMTK001"[i]) return;
    if ((s32)gps_init_step <= 3)      gps_init_step++;
    else if ((s32)gps_datum_step <= 0) gps_datum_step++;
    else if ((s32)gps_nav_step <= 0)   gps_nav_step++;
    else if ((s32)gps_dgps_step <= 0)  gps_dgps_step++;
    swtimer_stop(gps_timer_grp, 1);
}

