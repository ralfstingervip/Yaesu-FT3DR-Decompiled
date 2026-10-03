/* ============================================================================
 * m7_cdc_requests.c  -- Hand-reconstructed C, DOCUMENTATION ONLY.
 * Lane M7. CDC-ACM enumeration + control-request handling, MAIN USB personality
 * selected when 0xFF813A != 0 (held-key strap at boot, key code 0x11).
 *
 * Source: decrypted/FT3D_MAIN_ver102_EXP.bin, H8SX big-endian, base 0,
 * file offset == mapped address, sha256 8e3ecd05409b2c31...
 * Every block carries the mapped address of the bytes it stands for. There is
 * no Hex-Rays for H8SX; this is a hand transcription from disassembly, each
 * line byte-checked by ida/out/cdc-personality/verify.py (66 cites, 0 mismatch).
 *
 * Register-page names (Inferred, per docs 64/75, Renesas H8S USB Function Module):
 *   IFR0/1/2 = EE00/01/02   interrupt flags
 *   IER0/1/2 = EE04/05/06   interrupt enables
 *   EPDR*    = EE0C/0D/0E/10 endpoint data FIFOs
 *   FCLR     = EE28          FIFO clear
 *   EPSTL    = EE2A          endpoint stall
 *   TRG      = EE2C          packet trigger
 *   EE32     = EPIR          endpoint-info table write port
 * SETUP packet for THIS stack is read into on-chip RAM 0xFEE000..0xFEE007
 * (bmRequestType, bRequest, wValueL, wValueH, wIndexL, wIndexH, wLengthL, wLengthH).
 * NOTE: this differs from the vendor stack, which rings SETUP at 0xFF3CEA.
 * ============================================================================ */

#include <stdint.h>
typedef uint8_t  u8;  typedef uint16_t u16;  typedef uint32_t u32;

/* on-chip USB working RAM / SETUP packet */
#define SETUP   ((volatile u8 *)0xFEE000)   /* 8-byte SETUP, big buffer at 0xFEE000 */
#define IFR0 (*(volatile u8*)0xFFFFEE00)
#define IER0 (*(volatile u8*)0xFFFFEE04)
#define IER1 (*(volatile u8*)0xFFFFEE05)
#define IER2 (*(volatile u8*)0xFFFFEE06)
#define FCLR (*(volatile u8*)0xFFFFEE28)
#define EPSTL(*(volatile u8*)0xFFFFEE2A)
#define TRG  (*(volatile u8*)0xFFFFEE2C)

/* copied-RAM state (the .data block boot copies 0x07B2A6->0xFF6034) */
extern u16 ep0_state;        /* 0xFF6314 / == FF6304+0x10 : 1=IN data, 2=status, 3=STALL */
extern u8  line_coding[8];   /* 0xFF63DE : CDC line coding store (dwDTERate,stop,parity,bits) */

/* descriptor pointer records in copied RAM. {length, dword flash/RAM pointer @+2} */
struct desc_rec { u16 len; u8 *ptr; };       /* device/config: len, ptr */
extern struct desc_rec dev_rec;   /* 0xFF637C -> len 18, ptr 0xFF640E (device desc RAM) */
extern struct desc_rec cfg_rec;   /* 0xFF6382 -> len 0x43, ptr 0xFF649F (config desc RAM) */
extern u8  str_tab[];             /* 0xFF6388 -> string table: +0 LANGID, +0x12 iSerial(idx3) */

/* generic queue-engine block 0xFF6288: EP0-IN "send these bytes" window.
 * fields read/written: [0]=rd, [4]=wr, [8]=base, [0xC]=limit (byte pointers). */
struct qblk { u8 *rd; u8 *wr; u8 *base; u8 *limit; /* ... */ };
extern struct qblk Q;             /* 0xFF6288 */

extern u16 le16_at(const void *p);        /* sub_78442 : little-endian u16 load */
extern void ring_fill (void *src, struct qblk *q);   /* sub_78334 */
extern void queue_init_open(void);        /* sub_78508 : arm the FF6288 data queue */

/* ---------------------------------------------------------------------------
 * sub_76EF8 @ 0x076EF8 -- CDC CLASS request decode (bmRequestType 0x21 / 0xA1).
 * Returns 1 (=> caller STALLs) only for an unsupported bRequest; 0 otherwise.
 * The four requests are the only class requests this COM port answers.
 * --------------------------------------------------------------------------- */
static int cdc_class_request(void)
{
    u8 bRequest = SETUP[1];                           /* 0x076EFE  @FEE001        */
    switch (bRequest) {

    case 0x20:  /* SET_LINE_CODING          0x076F7E                              */
        /* Arm EP0-OUT to receive the 7(+1)-byte line-coding block into 0xFF63DE.
         * Q is pointed at the on-chip OUT FIFO staging 0xFEE008/0xFEE010, and
         * FF62FC/FF6300 are set to line_coding .. line_coding+len (0x076F7E..).
         * The bytes are STORED but NOT applied to the SCI-C UART (see note). */
        setup_ep0_out_into(line_coding, /*len*/8);    /* 0x076F84..0x076FBE       */
        return 0;

    case 0x21:  /* GET_LINE_CODING          0x076F38                              */
        /* Return the stored line coding on EP0-IN, clamped to wLength and to the
         * 8-byte record length. Q.wr = ptr; Q.rd = ptr+min(wLength,len).        */
        Q.wr    = line_coding;                        /* 0x076F4A @(4,er6)=ptr    */
        Q.rd    = line_coding + le16_at(&SETUP[6]);   /* 0x076F54 sub_78442=wLen  */
        Q.limit = line_coding + 8;                    /* 0x076F6C clamp to len    */
        if (Q.wr > Q.limit) Q.wr = Q.limit;           /* 0x076F74 bls/clamp       */
        return 0;                                     /* caller: ep0_state=1 (IN) */

    case 0x22:  /* SET_CONTROL_LINE_STATE   0x076F24                              */
        /* wValue low byte = control line bits (b0 DTR, b1 RTS). Only the exact
         * value 3 (DTR|RTS) acts: it (re)initialises the data queue == the host
         * opening the port. Any other value is a silent ACK (no action).        */
        if (SETUP[2] == 3)                            /* 0x076F24 cmp #3 @FEE002  */
            queue_init_open();                        /* 0x076F30 jsr sub_78508   */
        return 0;

    case 0x23:  /* SEND_BREAK               0x076FC0                              */
        return 0;                                     /* accepted, no action      */

    default:    /* 0x00 SEND_ENCAPSULATED_COMMAND, 0x01 GET_ENCAPSULATED_RESPONSE,
                 * and everything else: 0x076F18 -> r3l = 1                       */
        return 1;                                     /* 0x076F1E -> caller STALL */
    }
}

/* ---------------------------------------------------------------------------
 * sub_76C0A @ 0x076C0A -- control-request dispatcher. Reads the SETUP packet at
 * 0xFEE000 and sets ep0_state (0xFF6314 == FF6304+0x10):
 *     1 = EP0 has IN data to send   2 = status/ZLP stage   3 = STALL
 * --------------------------------------------------------------------------- */
static void control_request(void)
{
    u8 bmRequestType = SETUP[0];                      /* 0x076C18 @FEE000         */
    int stall = 0;

    if (bmRequestType == 0x80) {                      /* 0x076C1A                 */
        /* ---- standard device GET (device/config/string descriptor) ---------- */
        if (SETUP[1] != 0x06) { stall = 1; goto fin; } /* 0x076D4A GET_DESCRIPTOR */
        u8 idx = SETUP[2], typ = SETUP[3];            /* wValueL, wValueH         */
        struct desc_rec *r = 0; u16 len = 0; u8 *p = 0;
        if (idx == 0 && typ == 1) {                   /* DEVICE    0x076D5A       */
            p = dev_rec.ptr; len = (u8)dev_rec.len;   /* byte length 0x12         */
        } else if (idx == 0 && typ == 2) {            /* CONFIG    0x076DBC       */
            p = cfg_rec.ptr; len = cfg_rec.len;       /* word length 0x43         */
        } else if (idx == 0 && typ == 3) {            /* STRING 0  0x076E18 LANGID*/
            /* str_tab+0 : {byteLen, flashPtr 0x07B272} */
            setup_ep0_in_from_strtab(0); goto fin;
        } else if (idx == 3 && typ == 3) {            /* STRING 3  0x076E72 serial*/
            setup_ep0_in_from_strtab(3); goto fin;    /* uses @(0x12),@(0x14)     */
        } else { stall = 1; goto fin; }               /* 0x076ECC                 */
        /* arm EP0-IN window over [p, p+min(wLength,len)] via Q (0x076D70..) */
        Q.wr = p; Q.rd = p + le16_at(&SETUP[6]); Q.limit = p + len;
        if (Q.wr > Q.limit) Q.rd = Q.limit;           /* clamp 0x076DAA           */
        goto fin;
    }
    if (bmRequestType == 0x00) {                      /* 0x076C22 std device SET  */
        if (SETUP[1] != 0x07) { stall = 1; goto fin; } /* 0x076C6A bRequest==7     */
        /* SET_DESCRIPTOR-shaped: arm EP0-OUT into 0xFEE008 window, pick the
         * matching descriptor record by wValue type (0x076C70..0x076D40). Rare;
         * the host normally never sends it. Bytes Confirmed; meaning Inferred.  */
        setup_set_descriptor();                       /* 0x076C70..               */
        goto fin;
    }
    if ((bmRequestType >= 0x20 && bmRequestType <= 0x23) ||   /* class  H2D 0x076C24 */
        (bmRequestType >= 0xA0 && bmRequestType <= 0xA3)) {   /* class  D2H 0x076C2C */
        stall = cdc_class_request();                  /* 0x076C34 jsr sub_76EF8   */
        goto fin;
    }
    if ((bmRequestType >= 0x40 && bmRequestType <= 0x43) ||   /* vendor H2D 0x076C42 */
        (bmRequestType >= 0xC0 && bmRequestType <= 0xC3)) {   /* vendor D2H 0x076C4A */
        stall = 1;                                    /* 0x076C56 sub_76FC4 ret 1 */
        goto fin;                                     /* NO vendor requests exist */
    }
    stall = 1;                                        /* else: 0x076ECC STALL     */

fin:                                                  /* 0x076ED2                 */
    if (ep0_state == 3) return;                       /* already stalling         */
    if (stall)       ep0_state = 3;                   /* 0x076ECC                 */
    else if (SETUP[0] & 0x80) ep0_state = 1;          /* 0x076EE4 D2H -> IN data  */
    else                      ep0_state = 2;          /* 0x076EEC H2D -> status   */
}

/* ---------------------------------------------------------------------------
 * sub_76C8 handler (IFR0 b3 == SETUP), record mask 0x08000000, called from the
 * ISR demux 0x07827C with r1l = record +4 byte (0 => endpoint 0).
 * @ 0x0768C8
 * --------------------------------------------------------------------------- */
void on_setup_packet(u8 ep /* r1l, 0 */)
{
    IFR0 = 0xF7;                                       /* 0x0768CC clear b3 (SETUP)*/
    IFR0 = 0xFD;                                       /* 0x0768D2 clear b1        */
    struct ep_ctrl *E = &ep_ctrl[ep];                  /* 0x0768D8 FF6304 + ep*20  */
    FCLR = E->fclr_byte;                               /* 0x0768EE  = [E+0xE]      */
    ep0_state = 0;                                     /* 0x0768F2 FF6314 = 0      */
    /* copy the 8 SETUP bytes from 0xFEE000 into the control engine, then parse */
    ring_fill((void*)0xFEE000, (struct qblk*)E);       /* 0x076916 jsr sub_78334   */
    control_request();                                 /* 0x07691A jsr sub_76C0A   */

    switch (ep0_state) {                               /* 0x07691E                 */
    case 1:  /* IN data stage: enable EP0 ints, kick EP0-IN FIFO from Q          */
        IER0 |= 0x07; IER0 &= ~0x02;                   /* 0x07692C / 0x076932      */
        ring_drain((void*)0xFF6318, &Q);               /* 0x076944 jsr sub_7837C   */
        break;
    case 2:  /* status stage: enable EP0 ints + EP0-IN-request (ZLP)             */
        IER0 |= 0x07; IER0 |= 0x02;                    /* 0x076952 / 0x076958      */
        break;
    default: /* 3 == STALL: disable EP0 ints, assert EPSTL for this endpoint     */
        IER0 &= ~0x07;                                 /* 0x076964                 */
        EPSTL |= E->stall_mask;                        /* 0x076974  = [E+0xF]      */
        break;
    }
    /* rebuild the IER snapshot word at 0xFF62F8 (0x076978..0x0769A0) */
}

/* ---------------------------------------------------------------------------
 * sub_784BE @ 0x0784BE -- IFR0 b7 (bus reset) handler, record mask 0x80000000.
 * Re-initialises the two data rings and clears the USB FIFOs. Does NOT touch
 * ep0_state, and does NOT re-run enumeration: a bus reset alone does not
 * re-enumerate (same design as the vendor stack).
 * --------------------------------------------------------------------------- */
void on_bus_reset(void)
{
    Q.rd = Q.wr = (u8*)0xFEE008;                        /* 0x0784CA/CE              */
    *(u8**)0xFF62D8+0x50 /*ring*/ ;                     /* 0x0784D4/DA set to FEE010*/
    *(u8**)0xFF62D8+0x40 /*ring*/ ;                     /* 0x0784E2/E8 set to FEE1E1*/
    *(u8*)0xFF6240 = 1;                                 /* 0x0784EE busy flag       */
    *(u16*)0xFF63F8 = 0;                               /* 0x0784F4                 */
    IFR0 = 0x7F;                                        /* 0x0784FA                 */
    FCLR = 0x73;                                        /* 0x078500                 */
}

/* ============================================================================
 * SUMMARY OF THE VIRTUAL COM PORT CONTROL PLANE
 *   Enumeration:   standard GET_DESCRIPTOR(device/config/string) from RAM/flash
 *                  images; SET_DESCRIPTOR-shaped SET path (rare).
 *   Class requests answered (Confirmed bRequest compares at 0x076F04..0x076F12):
 *       0x20 SET_LINE_CODING        -> store 7-8 bytes at 0xFF63DE (NOT applied)
 *       0x21 GET_LINE_CODING        -> echo those bytes back
 *       0x22 SET_CONTROL_LINE_STATE -> wValue==3 (DTR|RTS) opens the data queue
 *       0x23 SEND_BREAK             -> accepted, no effect
 *   Everything else (incl. all 0x40/0xC0 vendor requests) -> EPSTL STALL.
 *   The baud rate / framing the PC sets via SET_LINE_CODING is held but never
 *   programmed into SCI-C; the DSP link runs at the fixed 8-N-2 rate set by
 *   0x078222 (SMR 0x08 / BRR 0x0C / SCR 0x70 at 0xFFFF88..0xFFFF8A).
 * ============================================================================ */
