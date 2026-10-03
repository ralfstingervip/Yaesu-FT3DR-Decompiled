/* ============================================================================
 * l15_tx_gate.c  -  Hand-reconstructed C for the MAIN transmit gate.  Lane L15.
 *
 * DOCUMENTATION ONLY.  By-hand transcription of H8SX disassembly in
 * decrypted\FT3D_MAIN_ver102_EXP.bin (sha256 8e3ecd05...), big-endian, base 0,
 * so each comment address is file offset == mapped address.  Nothing compiled
 * or run.  Cross-checked against docs 93 and 97; byte cites in citations.tsv.
 *
 * Register model: the band/channel-record pointer lives in er0 and is read as
 * er0+disp fields (e.g. @(1,er0)=screen/mode id, @(0x90,er0)=band squelch byte,
 * @(0x86,er0) record flag byte, @(0x15,er0) shift index, @(0x1A,er0) RX long,
 * @(0x1E,er0) TX/offset long, @(0x46,er0) keep-shift flag).  The range-check
 * predicate returns its result in the CCR Z flag AND in r4l (0 = allow / Z set,
 * 1 = block / Z clear); callers test with bne/beq (doc 97 sec.1).
 *
 * RAM globals (address, name, meaning, source):
 *   FFFF4E b7  ptt_in     PTT key port input bit (doc 93: pin "active low";
 *                         at the register the firmware treats bit7=1 as PRESSED
 *                         - see note on ptt_debounce)                 [doc 93]
 *   FFFF4D b3  rf_status  band-A RF-status interlock (low=OK); band-B uses b2;
 *                         best fit synthesizer lock-detect (Inferred)  [doc 93]
 *   FFA9EA  ptt_state     PTT debounce state 0..3                      [doc 93]
 *   FF89B0  ptt_delay     PTT DELAY menu index (F38C)                  [doc 93]
 *   FF953D  ptt_delaycnt  10ms-tier countdown for PTT DELAY            [doc 93]
 *   FFA9ED  key_event     raw key code sink (0x17 press / 0x18 release) [doc 93]
 *   FFAAD2  ptt_misc      b0 = PTT currently asserted (shared w/ keyers)[doc 93]
 *   FF956D  settle        10ms-tier post-retune settle (const 2 = 10-20ms)[doc 93]
 *   FF9568  rf_fault_tmr  30-40ms RF-fault timer                        [doc 93]
 *   FF94C0  tx_state      0 idle, 1 TX keyed, 2 blocked                 [doc 93/97]
 *   FFAACF  tx_req_flag   transmit requested                           [doc 93]
 *   FFAAE0  tone_ev       tone mailbox; 0x1D = TX-refused tone         [doc 93/97]
 *   FFAA30  tx_bits       b2 = TOT trigger (TX started), b4 = alt end   [doc 93]
 *   FFA4F0  tx_req_bits   b6/b7 = data/APRS TX-request flags            [doc K8]
 *   FF89C1 b3  key_lock   KEY LOCK on                                   [doc 49]
 *   FF89AB  lock_type     >=3 locks PTT                                 [doc 93]
 *   FF8DDE  node_mode     <0 (b7 set) = node/PC-keyed mode              [doc 93]
 *   FF8DE0 b7 / FFB3D9 b2  node-keyed skips the RF interlock            [doc 93]
 *   FF8EA0 b6  band_sel   selects band-B (FF8DD5) vs band-A (FF8D20)    [doc 93]
 *   FF89BF b4  busy_lock  busy-channel TX lockout                       [doc 93]
 *   FF8EA6  slot_chk      slot-consistency / cross-band check           [doc 93]
 *   B0A4 b2 (FFB0A4) dsp_ready  DSP initialised (digital TX precond.)   [doc 93]
 *   FFAAAE  cand_freq     packed-BCD TX freq under test (10 Hz units)   [doc 97]
 *   FF92CE / FF92D6  tx_win_a / tx_win_b  inclusive allowed windows     [doc 97]
 *   FF800F  market        market/destination byte                      [doc 96/97]
 *   FF8011  market2       second market byte                           [doc 97]
 * ========================================================================== */

#include <stdint.h>
typedef uint8_t u8; typedef uint32_t u32;

/* ========================================================================== *
 * PTT debounce (sub_FC66, 00FC66).  Reads port FFFF4E bit 7, dispatches on
 * ptt_state through off_FC80.  r2l = (P4E & 0x80): the code treats r2l != 0
 * as PRESSED and r2l == 0 as RELEASED (doc 93 labels the pin active-low, so an
 * inverting buffer sits between pin and port, or the doc's note is the external
 * level; the firmware-visible sense is pressed = bit7 set).  (doc 93 sec.1)
 * ========================================================================== */
void ptt_debounce(void)                                /* 00FC66 */
{
    u8 pressed = PORT_4E & 0x80;                        /* 00FC66: 2a4e ea80   */
    switch (ptt_state) {                                /* 00FC6A: state*4 jmp */

    case 0:                                             /* 00FC90 sub_FC90     */
        if (pressed == 0) ptt_state = 1;                /* ignore held-at-boot */
        break;                                          /*   until released    */

    case 1:                                             /* 00FC9C sub_FC9C     */
        if (pressed == 0) break;                        /* 00FC9C: not pressed */
        if (ptt_delay == 0) {                           /* 00FCA0: no delay    */
            ptt_misc &= ~0x03;                          /* 00FCC2: clear b0/b1 */
            key_event = 0x17;                           /* 00FCCE: press event */
            ptt_state = 2;                              /* 00FCD4              */
        } else {                                        /* 00FCA8: start delay */
            ptt_delaycnt = ptt_delay_tbl[ptt_delay];    /* 00FCAE: 0/2/5/0xA/0x14*/
            ptt_state = 3;                              /* 00FCBA              */
        }
        break;

    case 2:                                             /* 00FCE2 sub_FCE2     */
        if (pressed != 0) break;                        /* 00FCE2: still held  */
        key_event = 0x18;                               /* 00FCE6: release     */
        ptt_state = 1;                                  /* 00FCEC              */
        break;

    case 3:                                             /* 00FCF4 sub_FCF4     */
        if (pressed == 0)   { ptt_state = 1; break; }   /* 00FCF4: released    */
        if (ptt_delay == 0) { ptt_state = 1; break; }   /* 00FCFC              */
        if (ptt_delaycnt != 0) break;                   /* 00FD00: still waiting*/
        ptt_misc &= ~0x01;                              /* 00FD06              */
        key_event = 0x17;                               /* 00FD0C: delayed press*/
        ptt_state = 2;                                  /* 00FD12              */
        break;
    }
    /* ptt_delay_tbl @ 00FCDC = {0,2,5,0x0A,0x14} on the 10ms tier =
       OFF / 20 / 50 / 100 / 200 ms  (SUB "PTT DELAY" list).                 */
}

/* ========================================================================== *
 * TX request (sub_2244C, 02244C): the PTT key-event-14 handler and the only
 * normal TX-start.  Runs the digital/DSP precondition, PTT LOCK, busy lockout,
 * slot check and the frequency-range gate, then keys TX (FF94C0=1) or refuses
 * (FF94C0=2, tone 0x1D).  Returns Z set when FF94C0==1 (doc 93, doc 97 sec.4).
 * ========================================================================== */
int tx_request(struct chanrec *er0)                    /* 02244C */
{
    u8 mode = (FF8EA0 & 0x40) ? FF8DD5 : FF8D20;        /* 02244C: op band mode*/
    int digital;                                        /* 02245E..022480     */
    if (mode == 0)            digital = 0;              /* 02245E: analog      */
    else if (mode == 1)       digital = 1;              /* 022460              */
    else {                                              /* 022464: C4FM sub    */
        u8 v = (FF8EA0 & 0x40) ? FF8EC5 : FF8EB6;       /* 022464              */
        digital = (v < 4) ? 1 : 0;                      /* 022476: cmp #4      */
    }
    if (digital && !(FFB0A4 & 0x04)) goto refuse;       /* 022482: DSP ready   */

    FFAA39 &= ~0x04;                                    /* 02248C              */
    if (ptt_lock())                  goto locked;       /* 022492: PTT LOCK    */

    if ((FF89BF & 0x10) &&                              /* 02249A: busy lockout*/
        er0->f90 != 2)               goto locked;       /* 0224A2: band !=2    */

    u8 ea6 = FF8EA6;                                    /* 0224AC: slot check  */
    if (ea6 == 0 || (ea6 & 0x80)) {                     /* 0224B0/0224B2       */
        /* straight to the range gate path at 022504 */
    } else if (ea6 & 0x02) {                            /* 0224B4              */
        struct chanrec *c = (void*)FF812A;              /* 0224C6              */
        if (!cross_band_ok_2EAF2(c)) goto range_only;   /* 0224D0: -> 022504   */
        FF8EA6 |= 0x80;                                 /* 0224D6              */
        er0 = (void*)FF812A;                            /* 0224DC              */
        er0 = ptr_from_32FA2(er0);                      /* 0224E2              */
        if (FF8992 == 0x0A) {                           /* 0224E6              */
            if (txfreq_vfo(er0)) { sub_33136(); goto block; } /* 0224EE blocked*/
            sub_32FF4(); goto keyed;                    /* 0224F4: allow       */
        }
        sub_33136();                                    /* 022500              */
    } else if (!(FF8EA0 & 0x40)) {                      /* 0224B8              */
        goto block;                                     /* 0224C0              */
    }

range_only:
    if (txfreq_vfo(er0)) goto block;                    /* 022504: jsr sub_34DC2*/
keyed:                                                  /* 02250A              */
    sub_2257A();                                        /* 02250A: TX setup    */
    tone_ev = 0xFF;                                     /* 022522              */
    cand_to_last();                                     /* 02252E: FFAAAE->AAAA*/
    FFAACF = 1;                                         /* 02253C: TX requested*/
    tx_state = 1;                                       /* 022542: FF94C0 = 1  */
    FFAAB8 = 0;                                         /* 022546              */
    goto done;

block:                                                  /* 02254E              */
    tx_state = 2;                                       /* 022550: FF94C0 = 2  */
    tone_ev  = 0x1D;                                    /* 022554: refuse tone */
    goto done;
locked:                                                 /* 02255A: FF94C0 kept */
done:
    return (tx_state == 1);                             /* 02255A: Z = allowed */
}

/* ---- PTT LOCK (sub_22562, 022562) ---------------------------------------*/
int ptt_lock(void)                                     /* 022562 */
{
    if (!(FF89C1 & 0x08)) return 0;                     /* 022562: KEY LOCK off*/
    return (FF89AB >= 3);                               /* 02256A: types 3..6  */
}

/* ========================================================================== *
 * TX state-machine state 1 (sub_34966, 034966): waits for the settle timer and
 * the RF-status interlock, then actually keys the PA.  This is the gate around
 * 034984 (the FFFF4D b3 read) and 034A5A (the FFA4F0 TX-request bits).
 * (doc 93 sec.2, doc K8)
 * ========================================================================== */
void tx_state1(struct chanrec *er0)                    /* 034966 */
{
    if ((FF8DDE & 0x80) &&                              /* 034966: node mode   */
        ((FF8DE0 & 0x80) || (FFB3D9 & 0x04)))           /* 03496C/034974       */
        goto key_ok;                                    /* 03497A: skip interlock*/

    if (FF956D != 0) return;                            /* 03497C: still settling*/
    if (PORT_4D & 0x08) goto not_ready;                 /* 034984: RF status b3 */

key_ok:                                                 /* 03498C              */
    if ((FFAAD3 & 0x04) || (FFAAD3 & 0x01))             /* 03498C/034994       */
        goto do_key;                                    /* 034A00: data path   */

    /* compute digital/analog for this band ------------------------ 03499C */
    u8 m = (FF8EA0 & 0x40) ? FF8DD5 : FF8D20;           /* 03499C              */
    int digital;
    if (m == 0)      digital = 0;                       /* 0349AE              */
    else if (m == 1) digital = 1;                       /* 0349B0              */
    else {
        u8 v = (FF8EA0 & 0x40) ? FF8EC5 : FF8EB6;       /* 0349B4              */
        digital = (v < 4) ? 1 : 0;                      /* 0349C6: cmp #4      */
    }
    if (digital) goto do_voice;                         /* 0349D0 -> 034A6A    */
    if (FF89BB == 0) goto do_key;                       /* 0349D4: VOX off     */
    BB95 = 3; FFB0BB |= 1; BB94 = 1;                    /* 0349DA..0349E8      */
    FFB0AC = FFB0BD = FFB0BE = FFB0BF = 0;              /* 0349EE..0349FC      */

do_key:                                                /* 034A00              */
    sub_34A7C(er0);                                     /* 034A00: key PA      */
    sub_34B30();                                        /* 034A04              */
    FFAA30 |= 0x04;                                     /* 034A08: TOT trigger */
    FFAAD1 &= ~0x80;                                    /* 034A0E              */
    sub_34B44();                                        /* 034A14              */
    FFAAD5 = 2;                                         /* 034A18: next state  */
    if (FFAAD3 & 0x04) { FFAA34_tx_data_b2(); return; } /* 034A1E -> 034A62    */
    if (FFAAD3 & 0x01) { FFA4F0 |= 0x40; return; }      /* 034A26 -> 034A5A: b6*/
    if (FFAAD1 & 0x04) { FFAAD1 &= ~0x04;               /* 034A2E -> 034A4C    */
                         FFAA30 |= 0x10; return; }      /* 034A52              */
    if (FFAA36 & 0x08) { tone_ev = 0x1F; return; }      /* 034A36 -> 034A44    */
    sub_34C34(); return;                                /* 034A3E              */

    /* 034A5A: FFA4F0 |= 0x40 (data TX request, b6)     */
    /* 034A62: FFA4F0 |= 0x80 (APRS TX request, b7)     */
do_voice:                                              /* 034A6A              */
    sub_35872(); return;                               /* 034A6A              */

not_ready:                                             /* 034A70              */
    if (FF9568 != 0) return;                           /* 034A70: fault timer */
    sub_34FF4();                                       /* 034A76: force TX off*/
}

/* ========================================================================== *
 * TX frequency-range check (sub_34E42, 034E42), 64 bytes, ends rts at 034E80.
 * Allows when the packed-BCD long at FFAAAE lies inside window A (FF92CE) OR
 * window B (FF92D6); blocks when outside both.  Sets/clears record bit
 * er0+0x86 b4 and returns r4l=0/Z set (allow) or r4l=1/Z clear (block).
 * Byte-identical to doc 97 sec.1 (re-cited from the image).
 * ========================================================================== */
int txfreq_check(struct chanrec *er0)                  /* 034E42 */
{
    if (in_window(FFAAAE, &FF92CE) == 0) goto allow;    /* 034E42: C clear = in A*/
    if (in_window(FFAAAE, &FF92D6) != 0) goto block;    /* 034E54: outside B    */
allow:                                                  /* 034E66              */
    er0->f86 |= 0x10;                                   /* 034E66: bset #4      */
    return 0;                      /* r4l=0, Z set */   /* 034E70: fc 00        */
block:                                                  /* 034E74              */
    er0->f86 &= ~0x10;                                  /* 034E74: bclr #4      */
    return 1;                      /* r4l=1, Z clear */ /* 034E7E: fc 01        */
}
/* in_window (sub_3F5EE, 03F5EE): C set iff value<lo OR hi<value; both equal
 * ends are inside (doc 97 sec.1).  The windows are filled only by sub_3F4A2:
 * FF800F==6 or FF8011==0 -> indexed F0A2 pairs; else fixed F672
 * (140.00000-174.00000 and 420.00000-470.00000 MHz) (doc 97 sec.3).
 * txfreq_vfo = sub_34DC2 (034DC2): builds FFAAAE from er0+0x1A with an optional
 * packed-BCD shift from er0+0x1E, then calls sub_325FA (which does not store on
 * the live path) and txfreq_check (doc 97 sec.2).                           */
