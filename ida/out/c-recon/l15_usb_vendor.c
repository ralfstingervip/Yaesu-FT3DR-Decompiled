/* ============================================================================
 * l15_usb_vendor.c  -  Hand-reconstructed C for the MAIN vendor-class USB
 *                      device path (personality 26AA:0001).  Lane L15.
 *
 * DOCUMENTATION ONLY.  This is a by-hand transcription of H8SX disassembly in
 * decrypted\FT3D_MAIN_ver102_EXP.bin (sha256 8e3ecd05...), big-endian, base 0,
 * so the hex address in every comment is both the file offset and the mapped
 * address.  There is no Hex-Rays for H8SX; nothing here was compiled or run.
 * Every statement block carries the address of the bytes it stands for.
 * Cross-checked against docs 64/73/74/75; byte citations in citations.tsv.
 *
 * Calling / register model (Renesas H8S C compiler, docs\compiler.md, and as
 * observed): the control stack is a cooperatively-scheduled polled machine plus
 * three interrupt handlers.  The poll handlers take no C argument; they read the
 * state byte FF8183 and the USB register page at 0xFFEE00.  r4/er4..er6 are
 * scratch.  Return values that matter are carried in RAM, not registers.
 *
 * RAM globals (address, name, meaning, source):
 *   FF8180  usb_ev        event/VBUS flag byte (b0 VBUS, b3 EP0IN-done, b4 EP0OUT,
 *                         b6 bus-reset-seen)                       [doc 64 sec.2]
 *   FF8181  usb_cfgstep   b0: config descriptor already sent once  [doc 64 sec.3]
 *   FF8182  usb_latch     next FSM state latched after our ZLP     [doc 64 sec.3]
 *   FF8183  usb_state     control-transfer FSM state 0..11         [doc 64 sec.3]
 *   FF8184  rep_b0        EP0x83 report byte0 (0/1 audio-routing)   [doc 73]
 *   FF8185  rep_b0_shadow send-on-change shadow of byte0           [doc 73]
 *   FF8186  rep_w12_shadow send-on-change shadow of bytes 1..2     [doc 73]
 *   FF8152  setup_wr      SETUP-ring write pointer (ISR fills)     [doc 64 sec.2]
 *   FF8156  setup_wr2     mirror of FF8152                         [doc 64 sec.2]
 *   FF8158  setup_rd      SETUP-ring read pointer (poll drains)    [doc 64 sec.3]
 *   FF813A  usb_personality  0 = vendor stack active, 1 = CDC      [BRIEF corr.1]
 *   FFB094  ep0in_cnt     bytes still to push to EP0-IN            [doc 64 sec.2]
 *   FFB09E  ep0in_ptr     EP0-IN source pointer                    [doc 64 sec.2]
 *   FFB095  d4_reply      one-byte D4 quality reply staging        [doc 64 sec.4]
 *   FFB096  d3_param      last 41 D3 wValueL (remote button level) [doc 64 sec.7]
 *   FF89CE  cam_size      USB CAMERA SIZE index (report byte 1)    [doc 73]
 *   FF89CD  cam_quality   USB CAMERA QUALITY 0/1/>=2 (-> code)     [doc 73]
 *   FF89CF  cfg_variant   config-descriptor variant index (forced 0)[doc 64]
 *   FF94C0  tx_state      transmit state (0 idle,1 TX,2 blocked)   [doc 93/97]
 *   FF89C1  key_flags     b3 = KEY LOCK on                         [doc 49]
 *   FF89AB  lock_type     LOCK type; b0=0 means keys locked        [doc 64 sec.5]
 *   FF2EC9  pic_busy      picture operation in progress            [doc 64 sec.5]
 *   FFB098  push_remain   image bytes still to forward             [doc 64 sec.5]
 *   FFBA46  push_recsize  record size                              [doc 64 sec.5]
 *   FFBA6E  push_expect   bytes still expected on EP1              [doc 64 sec.5]
 *   FFBA6C  push_index    EP1 write index into FF5806 (0..0x3FF)   [doc 64/75]
 *   FFBA72  push_refuse   D1 refused -> drain EP1 into nothing     [doc 64 sec.5]
 *   FFBA38  push_wrapflag set when the 1KB window wrapped          [doc 64 sec.5]
 *   FFA9E3  audio_ev      b4 = kick audio/TX machine (image push)  [doc 73]
 *   FFAAE0  tone_ev       tone/event mailbox (0x4F=upload beep)    [doc 74]
 *   FFAAE8  tone_phase    tone sequencer phase (0 idle)            [doc 74]
 *   USB register page 0xFFEE00 (names Inferred, behaviour Confirmed, doc 64/75):
 *     EE00 IFR0  EE01 IFR1  EE02 IFR2   EE04/05/06 IER0/1/2  EE08/09/0A ISR0/1/2
 *     EE0C EPDR0i EE0D EPDR0o EE0E EPDR0s  EE10 EPDR1  EE18 EPDR3
 *     EE24 EPSZ0o EE25 EPSZ1  EE27 DASTS  EE28 FCLR0  EE2C TRG  EE2D ctrl
 *     EE32 EPIR
 * ========================================================================== */

#include <stdint.h>
typedef uint8_t  u8;  typedef uint16_t u16;  typedef uint32_t u32;

/* ---- hardware endpoint table written once at cold boot (sub_54BF8, 054BF8) --
 * 50 bytes from byte_54C12 pushed to EPIR; EP0 ctrl/8, EP1 bulk-OUT/64 FIFO1,
 * EP2 bulk-IN/64 FIFO2 (CDC only), EP3 interrupt-IN/8 FIFO3.               */
void usb_epir_load(void)                               /* 054BF8 */
{
    for (int n = 0x32; n; n--)                         /* 054BF8: 0x32 bytes  */
        EE32 = *table_54C12++;                         /* 054C00: @er5+ -> EE32*/
    return;                                            /* 054C10: rts         */
}

/* ---- module reset (sub_54CAE, 054CAE): clear flags, fill SETUP ring ------- */
void usb_module_reset(void)                            /* 054CAE */
{
    EE28 = 0x73;                                       /* 054CAE: FCLR0       */
    EE00 = EE01 = EE02 = 0;                             /* 054CB4: IFR0/1/2=0  */
    EE2D = 0; EE2E = 0; EE2F = 0;                       /* 054CC2: ctrl/aux=0  */
    EE2A = 0; EE44 = 0;                                 /* 054CD4: EPSTL/aux=0 */
    for (u32 *p = (u32*)0xFF3C6A, n = 0x42; n; n--)     /* 054CE0: 0x42 longs  */
        *p++ = 0;                                       /* 054CEE: SETUP ring  */
}

/* ---- interrupt-enable init (sub_54C44, 054C44) --------------------------- */
void usb_init(void)                                    /* 054C44 */
{
    usb_module_reset();                                /* 054C44: bsr         */
    FF8180 = FF8181 = 0;                               /* 054C46              */
    FF8183 = FF8182 = 0;                               /* 054C52: state = 0   */
    FF8184_dword = 0x0100FFFF;                         /* 054C64: rep byte0=1 */
    setup_wr = setup_wr2 = 0xFF3CEA;                   /* 054C6A: ring base   */
    EE08 = 0x00; EE09 = 0x07; EE0A = 0x1F;             /* 054C7E: ISR0/1/2    */
    EE04 = 0x8D; EE05 = 0x03; EE06 = 0x18;             /* 054C94: IER0/1/2    */
    EE2D |= 0x04;                                      /* 054CA6: bset#2 enable*/
}

/* ========================================================================== *
 * Interrupt vector 234 -> 0x054D50 : the main USB function ISR.
 * If the CDC personality is active (FF813A != 0) it hands off through the
 * closed window at 0x07827C (not decoded).  Otherwise it services IFR0.
 * ========================================================================== */
__interrupt void usb_isr_main(void)                    /* 054D50  vector 234 */
{
    if (usb_personality != 0) { cdc_isr_0x7827C(); return; }  /* 054D54: FF813A edge */

    u8 ifr0 = EE00;                                    /* 054D5C              */

    if (ifr0 & 0x80) {                                 /* 054D60: b7 bus reset*/
        EE00 = (ifr0 & ~0x80) | 0x2F;                  /* 054D64: ack b7      */
        setup_wr = setup_wr2 = 0xFF3CEA;               /* 054D74: ring reset  */
        EE28 = 0x73;                                   /* 054D86: FCLR0       */
        FF8180 |= 0x40;                                /* 054D8C: b6 seen     */
        return;                  /* NOTE: FF8183 state is NOT reset here      */
    }
    if (ifr0 & 0x08) {                                 /* 054D98: b3 SETUP    */
        EE00 = (ifr0 & ~0x08) | 0xA7;                  /* 054D9C: ack b3      */
        u8 *w = (u8*)setup_wr2;                         /* 054DAE              */
        for (int i = 8; i; i--) {                      /* 054DAC: 8 bytes     */
            *w++ = EE0E;                               /* 054DB4: EPDR0s      */
            if ((u16)(u32)w >= 0x3D6A) w = (u8*)0xFF3CEA; /* 054DBC: 16-slot wrap */
        }
        setup_wr2 = (u32)w;                            /* 054DCC              */
        EE2C = 0x04;                                   /* 054DD2: TRG         */
        return;
    }
    if (ifr0 & 0x04) {                                 /* 054DDE: b2 EP0-OUT  */
        EE00 = (ifr0 & ~0x04) | 0xAB;                  /* 054DE2: ack b2      */
        for (u8 n = EE24; n; n--)                       /* 054DF2: EPSZ0o count*/
            *dst_FF3C6A++ = EE0D;                      /* 054DFE: EPDR0o      */
        EE2C = 0x02;                                   /* 054E0A: TRG         */
        FF8180 |= 0x10;                                /* 054E10: b4          */
        return;
    }
    if (ifr0 & 0x02) {                                 /* 054E1C: b1 EP0-IN req*/
        EE00 = (ifr0 & ~0x02) | 0xAD;                  /* 054E20: ack b1      */
        if (FF8183 == 4) {                             /* 054E30: only state 4*/
            EE04 = 0x8D;                               /* 054E38: IER0        */
            FFB094 = 0;                                /* 054E40: count 0     */
            EE2C = 0x01;                               /* 054E44: TRG -> ZLP  */
        }
        return;
    }
    if (ifr0 & 0x01) {                                 /* 054E50: b0 EP0-IN sent*/
        EE00 = (ifr0 & ~0x01) | 0xAE;                  /* 054E54: ack b0      */
        if (FFB094 != 0) {                             /* 054E64: more to send*/
            u8 cnt = FFB094;                           /* 054E6A              */
            u8 *src = (u8*)FFB09E;                      /* 054E6E              */
            FFB094 = (cnt < 9) ? cnt : (cnt - 8);      /* 054E76: min(.,8)    */
            u8 chunk = (cnt < 9) ? cnt : 8;            /* 054E76..            */
            for (; chunk; chunk--) EE0C = *src++;      /* 054E84: EPDR0i      */
            FFB09E = (u32)src;                         /* 054E8E              */
            EE2C = 0x01;                               /* 054E94: TRG         */
        } else {
            FF8180 |= 0x08;                            /* 054E9C: b3 done     */
        }
        return;
    }
}

/* ========================================================================== *
 * Interrupt vector 235 -> 0x054EC2 : VBUS / suspend ISR (IFR1/IFR2).
 * ========================================================================== */
__interrupt void usb_isr_vbus(void)                    /* 054EC2  vector 235 */
{
    u8 ifr1 = EE01 & 0x0F;                             /* 054EC4              */
    if (ifr1 & 0x01) {                                 /* 054ECA: b0 VBUS chg */
        EE01 = (ifr1 & ~0x01) | 0x06;                  /* 054ED0: ack b0      */
        u8 v = EE01;                                   /* 054EDC              */
        FF8180 = (FF8180 & ~0x01) | ((v >> 3) & 1);    /* 054EE0: b0 = IFR1.b3*/
        FF817E |= 0x02;                                /* 054EE8              */
        FF8183 = 0;                                    /* 054EEE: state = 0   */
        if (FF8180 & 0x01) return;                     /* 054EF4: VBUS present*/
        /* VBUS gone: full soft reset -------------------------------- 054EFC */
        FF8180 = FF8181 = 0;                           /* 054F00              */
        FF8183 = FF8182 = 0;                           /* 054F08              */
        FF8184_dword = 0x0100FFFF;                     /* 054F1C: report=idle */
        setup_wr = setup_wr2 = 0xFF3CEA;               /* 054F22: ring base   */
        return;                                        /* 054F38: rte         */
    }
    /* ---- 054F3A: EP3-report writer (IFR1 b2).  DEAD: IER1=0x03 masks b2,
     * and the b0-false branch at 054ECC jumps straight to 054F88, so this
     * block is never entered (doc 64 sec.2).  It is the same 3-byte report. */
    if (ifr1 & 0x04) {                                 /* 054F3A: b2 (dead)   */
        EE01 = (ifr1 & ~0x04) | 0x03;                  /* 054F3E              */
        EE18 = FF8184; FF8185 = FF8184;                /* 054F4E: byte0       */
        EE18 = FF89CE;                                 /* 054F5A: byte1 SIZE  */
        EE18 = (FF89CD==0)?0x18:(FF89CD==1)?0x30:0x50; /* 054F62: byte2 qual  */
        FF8186 = (FF89CE<<8) | code;                   /* 054F7A              */
        EE2C = 0x40;                                   /* 054F7E: send 3B     */
        return;
    }
    if (ifr1 & 0x02) {                                 /* 054F88: b1 EP3 sent */
        EE01 = (ifr1 & ~0x02) | 0x05;                  /* 054F8C              */
        FF8180 |= 0x04;                                /* 054F9C: b2 (no rdr) */
        return;
    }
    /* ---- 054FA6: IFR2 suspend/resume -------------------------------------*/
    u8 ifr2 = EE02 & 0x3B;                             /* 054FA6              */
    if (ifr2 & 0x10) {                                 /* 054FAC: b4 suspend  */
        EE02 = (ifr2 & ~0x10) | 0x0B;                  /* 054FB0: ack         */
        FF8180 = (FF8180 & ~0x20) | (((EE02)>>5 &1)<<5); /* 054FC2: b5=IFR2.b5*/
        /* ... (rest of IFR2 handling below 054FC6, not on the vendor path) */
    }
}

/* ========================================================================== *
 * Interrupt vector 238 -> 0x054CFA : IFR2 b4 edge.
 * Sets FF8180.1, acks IFR2 b4.  The EE2F resume-pulse tail (054D22) is DEAD
 * (both 054D1E/054D20 branch past it; doc 64 sec.2, doc 75).
 * ========================================================================== */
__interrupt void usb_isr_ifr2(void)                    /* 054CFA  vector 238 */
{
    FF8180 |= 0x02;                                    /* 054CFC: bset#1      */
    u8 ifr2 = EE02 & 0x3B;                             /* 054D02              */
    if (ifr2 & 0x10) {                                 /* 054D08: b4          */
        EE02 = (ifr2 & ~0x10) | 0x0B;                  /* 054D0C: ack b4      */
        (void)EE02;                                    /* 054D18: readback    */
    }
    /* 054D1E/054D20 both -> 054D4C: the #8->#0 pulse on EE2F is unreachable */
    return;                                            /* 054D4E: rte         */
}

/* ========================================================================== *
 * Control-transfer FSM dispatcher (sub_54FEC, 054FEC).  Called from the main
 * loop only while usb_personality == 0.  Jumps through the 12-slot table
 * off_55002 indexed by usb_state.
 * ========================================================================== */
void usb_poll(void)                                    /* 054FEC */
{
    switch (FF8183) {                                  /* 054FEC: state*4 -> jmp */
    case 0:  st0_wait_vbus();     break;   /* 055034 */
    case 1:  st_setup_descr();    break;   /* 055042 (shared with case 5)    */
    case 2:  st2_wait_ep0in();    break;   /* 055196 */
    case 3:  st3_wait_status();   break;   /* 0551AA */
    case 4:  st4_our_zlp_sent();  break;   /* 0551C2 */
    case 5:  st_setup_descr();    break;   /* 055042 */
    case 6:  st6_d4();            break;   /* 0551DA */
    case 7:  st7_d1_d3();         break;   /* 055306 (shared with case 10)   */
    case 8:  st8_wait_tone();     break;   /* 055520 */
    case 9:  st9_ep1_data();      break;   /* 055552 */
    case 10: st7_d1_d3();         break;   /* 055306 */
    case 11: st11_sink();         break;   /* 0556C8 */
    default: /* table rts */      break;   /* 055032 */
    }
}

/* ---- state 0 (055034): wait for VBUS, then arm enumeration ---------------*/
void st0_wait_vbus(void)                               /* 055034 */
{
    if (!(FF8180 & 0x01)) return;                      /* 055034: b0 VBUS     */
    FF8183 = 1;                                        /* 05503C: -> state 1  */
    /* falls into st_setup_descr (055042)                                    */
}

/* ---- SETUP consume + GET_DESCRIPTOR (states 1 and 5, 055042) -------------*/
void st_setup_descr(void)                              /* 055042 */
{
    if (setup_rd == setup_wr) return;                  /* 055042: ring empty  */
    u8 pkt[8]; dequeue_setup(pkt);                     /* 055050: 8B -> FF3D6A*/
    u16 w = *(u16*)&pkt[0];                             /* 055074              */
    if (w!=0x8006 && w!=0xC1D4 && w!=0x41D3 &&
        w!=0x41D1 && w!=0x41D2)                         /* 05507C: known words */
        w = resync_rotations(pkt);                     /* 05509A: 8 rotations */
    if (w != 0x8006) return;                           /* 0550D8: only GET_DESC*/

    if (pkt[2] == 1) {                                 /* 0550E0: DEVICE      */
        if (FF8183 == 1) ep0in_setup(8,  &stub_55810); /* 055128/05513E       */
        else             ep0in_setup(18, &dev_55818);  /* 055132: next=18     */
        FF8182 = 5;                                    /* 055128: latch 5     */
    } else if (pkt[2] == 2) {                           /* 0550E4: CONFIG      */
        if (!(FF8181 & 1)) {                           /* 0550F2: first time  */
            FF8181 |= 1;                               /* 055116              */
            ep0in_setup(9, &cfg9_5582A);               /* 05511C: 9 B, latch 5*/
            FF8182 = 5;
        } else {                                       /* 0550FA: latch 6     */
            FF89CF = 0;                                /* 055102: variant = 0 */
            ep0in_setup(0x20, variant_table[0]);       /* 05510C: 32 B        */
            FF8182 = 6;
        }
    }
    /* ep0in_setup (sub_55144, 055144): FFB094=len, FFB09E=src, FF8183=2,
     * then prime first <=8 bytes to EE0C and TRG=1.                         */
}

/* ---- states 2/3/4 (055196/0551AA/0551C2): EP0-IN done, host status, our ZLP*/
void st2_wait_ep0in(void)                              /* 055196 */
{   if (FF8180 & 0x08) { FF8180 &= ~0x08; FF8183 = 3; } /* fallthrough */
    if (FF8180 & 0x10) { FF8180 &= ~0x10; FF8183 = FF8182; } }  /* 0551AA */
void st4_our_zlp_sent(void)                            /* 0551C2 */
{   if (FF8180 & 0x08) { FF8180 &= ~0x08; FF8183 = FF8182; } }  /* latch */

/* ---- state 6 (0551DA): EP3 report (if changed), then accept C1 D4 --------*/
void st6_d4(void)                                      /* 0551DA */
{
    ep3_report();                                      /* 0551DA..055240     */
    if (setup_rd == setup_wr) return;                  /* 055240              */
    u16 w = dequeue_and_match();                       /* 055250..0552D0     */
    if (w != 0xC1D4) return;                            /* 0552D8: only D4     */
    FFB095 = (FF89CD==0)?0x18:(FF89CD==1)?0x30:0x50;   /* 0552E2: quality code*/
    FF8182 = 7;                                        /* 0552DE: latch 7     */
    ep0in_setup(1, &FFB095);                           /* 0552F6: 1-byte reply*/
}

/* ---- states 7/10 (055306): EP3 report, then D3 or D1 ---------------------*/
void st7_d1_d3(void)                                   /* 055306 */
{
    ep3_report();                                      /* 055306..05536C     */
    if (setup_rd == setup_wr) return;                  /* 05536C              */
    u16 w = dequeue_and_match();                       /* 055380..0553FC     */

    if (w == 0x41D3) {                                 /* 055404: remote btn  */
        FFB096 = setup_wValueL;                        /* 0554E6: level       */
        FF8182 = 7; FF8183 = 4;                        /* 0554F0/0554FC: ZLP->7*/
        arm_ep0_zlp();                                 /* 055502: IER0=0x8F   */
        return;
    }
    if (w != 0x41D1) return;                           /* 05540C: else D1     */

    /* ---- 41 D1: start image upload.  Refuse gates (055414) -------------- */
    if (tx_state != 0)                goto refuse;     /* 055414: TX active   */
    if ((key_flags & 0x08) &&                          /* 05541E: KEY LOCK    */
        !(lock_type & 0x01))          goto refuse;     /* 055426: locks keys  */
    if (pic_busy != 0)                goto refuse;     /* 055430: FF2EC9      */

    push_refuse = 0;                                   /* 055438              */
    u32 size = ld3(&setup_at_FF3D6C);                  /* 05543E: wVal|wIdxL<<16*/
    push_remain = push_recsize = push_expect = size;   /* 05544E              */
    if (size == 0)                    goto refuse;     /* 055460              */
    push_packets = (size + 63) / 64;                   /* 055462: ceil, unused*/
    push_index = 0;                                    /* 055472              */
    pic_setup_6F512(); index_record_6A700();           /* 05547A/05547E       */
    FFBA38 = 0;                                        /* 055482              */
    audio_ev |= 0x10;                                  /* 055488: kick 039080 */
    tone_ev  = 0x4F;                                   /* 05548E: upload beep */
    rep_b0   = 1;                                      /* 055494: FF8184 = 1  */
    FF8183   = 8;                                      /* 05549A: -> state 8  */
    sub_55B28();                                       /* 0554A0              */
    push_dst = 0xFF5806;                               /* 0554A4: FFBC48      */
    return;

refuse:                                                /* 0554B2              */
    push_refuse = 1;                                   /* 0554B4: drain mode  */
    FF8182 = 0x0B; FF8183 = 4;                         /* 0554B8: ZLP -> 11   */
    arm_ep0_zlp();                                     /* 0554CA: IER0=0x8F   */
}

/* ---- state 8 (055520): hold the D1 status stage until the beep finishes --*/
void st8_wait_tone(void)                               /* 055520 */
{
    if (tone_phase != 0) return;                       /* 055520: NAK status  */
    FF8182 = 9; FF8183 = 4;                            /* 055526: ZLP -> 9    */
    arm_ep0_zlp();                                     /* 055538: IER0=0x8F   */
}

/* ========================================================================== *
 * state 9 (055552): EP1 bulk-OUT data, then accept 41 D2.
 * The copy loop at 055684 and the wrap check at 05569E are the 63-byte
 * overrun the brief asks for (doc 64 sec.5, doc 75 sec.5).
 * ========================================================================== */
void st9_ep1_data(void)                                /* 055552 */
{
    if (EE00 & 0x40) {                                 /* 055552: IFR0 b6 EP1 */
        u8 n = EE25;                                   /* 055652: EPSZ1 count */
        if (n == 0) { EE2C = 0x20; return; }           /* 055656: re-arm      */
        push_expect -= n;                              /* 055662              */
        if (push_refuse) {                             /* 055670              */
            for (; n; n--) (void)EE10;                 /* 0556B8: drain EPDR1 */
            EE2C = 0x20; return;                       /* 0556C0: re-arm      */
        }
        /* ---- byte copy: dst = FF5806 + push_index --------------- 055678 */
        u8 *dst = (u8*)(0xFF5806 + push_index);        /* 05567E: add.l       */
        for (; n; n--) *dst++ = EE10;                  /* 055684: EPDR1 -> mem*/
        push_index = (u16)((u32)dst - 0xFF5806);       /* 055690: new index   */
        forward_quarter_55976();                       /* 05569A: at 100/.../400*/
        /* NOTE: the wrap test runs AFTER the whole packet is copied, so an
         * index that started at e.g. 0x3C1 and took a 64-byte packet writes
         * up to FF5806+0x43E = FF5C44, 63 bytes past the 1KB window end
         * FF5C05 (unowned slack, doc 75).                                   */
        if (push_index >= 0x400) {                     /* 05569E: cmp.w 0x400 */
            busy_wait_55A2C();                         /* 0556A4              */
            push_index = 0; FFBA38 = 1;                /* 0556A8: wrap        */
        }
        EE2C = 0x20;                                   /* 0556C0: re-arm EP1  */
        return;
    }
    /* no EP1 packet: look for the closing 41 D2 -------------------- 05555C */
    if (setup_rd == setup_wr) return;                  /* 055568              */
    if (dequeue_and_match() != 0x41D2) return;         /* 0555F4              */
    if (push_expect != 0) FFBA73++;                    /* 055600: owed count  */
    finish_push_559F4();                               /* 055612: final block */
    pic_busy = 0;                                      /* 055616: FF2EC9 = 0  */
    FF8185 = 0xFF;                                     /* 05561E: force EP3   */
    FF8182 = 0x0A; FF8183 = 4;                         /* 055624: ZLP -> 10   */
    arm_ep0_zlp();                                     /* 055636              */
}

/* ---- state 11 (0556C8): sink.  Drain EP1, accept D2, force a report. -----*/
void st11_sink(void)                                   /* 0556C8 */
{
    if (EE00 & 0x40) { drain_ep1_55652(); return; }    /* 0556C8              */
    if (setup_rd == setup_wr) return;                  /* 0556DC              */
    if (dequeue_and_match() != 0x41D2) return;         /* 055768              */
    FF8185 = 0xFF;                                     /* 05576E: force EP3   */
    FF8182 = 4; FF8183 = 4;                            /* 055774: ZLP -> 10   */
    arm_ep0_zlp();                                     /* 055782              */
}

/* ========================================================================== *
 * The 3-byte EP 0x83 interrupt-IN report.  Three live builders are identical:
 * state 6 (055202), states 7/10 (05532E), and sub_557A2 (settings refresh,
 * which first forces rep_b0 = 1).  Shown as the state-7 copy at 05532E.
 * Sends [FF8184, FF89CE, quality] only when something changed and the previous
 * report has left the FIFO (doc 64 sec.6, doc 73).
 * ========================================================================== */
void ep3_report(void)                                  /* 05532E (and 055202)*/
{
    u8 q = (FF89CD==0)?0x18:(FF89CD==1)?0x30:0x50;      /* 055312: quality code*/
    if (FF8184 == FF8185 &&                             /* 055306: byte0 same  */
        FF8186 == ((FF89CE<<8)|q)) return;              /* 05530E: bytes1-2 same*/
    if (EE27 & 0x20) return;                            /* 05532E: DASTS prev  */
    EE18 = FF8184; FF8185 = FF8184;                    /* 055336: byte 0      */
    EE18 = FF89CE;                                     /* 055342: byte 1 SIZE */
    EE18 = q;                                          /* 05535E: byte 2      */
    FF8186 = (FF89CE<<8) | q;                          /* 055362: shadow 1-2  */
    EE2C = 0x40;                                       /* 055366: send 3 B    */
}

/* ========================================================================== *
 * 41 D3 edge detector (sub_FDC8, 00FDC8), run from the key scanner at 00FB9E
 * while no other key event is pending.  Injects raw key 0x14 on the 0->nonzero
 * edge of the D3 level FFB096 (doc 64 sec.7, doc 74).  3-state on FFB097.
 * ========================================================================== */
void d3_edge(void)                                     /* 00FDC8 */
{
    u8 level = FFB096;                                 /* 00FDC8              */
    switch (FFB097) {                                  /* 00FDD0: state*4 jmp */
    case 0: if (level == 0) FFB097 = 1; break;         /* arm on release      */
    case 1: if (level != 0) { FFA9ED = 0x14; FFB097 = 2; } break; /* 00FDFE  */
    case 2: if (level == 0) FFB097 = 1; break;         /* re-arm              */
    }
}
