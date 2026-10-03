/* ============================================================================
 * m7_cdc_datapump.c  -- Hand-reconstructed C, DOCUMENTATION ONLY.
 * Lane M7. The CDC-ACM DATA plane: a transparent byte bridge between the two
 * USB bulk endpoints and the on-chip SCI-C serial link (0xFFFF88..0xFFFF8D),
 * which BRIEF correction 6 identifies as the DSP/vocoder link.
 *
 * So the PC side of this virtual COM port talks to the DSP, NOT to a general
 * console and NOT to any sample/IQ source.
 *
 * Image decrypted/FT3D_MAIN_ver102_EXP.bin, H8SX big-endian, base 0,
 * file offset == mapped address. All lines byte-checked (verify.py, 0 mismatch).
 *
 * Endpoints (CDC config descriptor @0x07B711, verified):
 *   EP 0x01  bulk OUT 64   data host -> radio   (IFR0 b6 -> handler 0x0767BE)
 *   EP 0x82  bulk IN  64   data radio -> host   (IFR0 b4 -> handler 0x0768A8)
 *   EP 0x83  interrupt IN 8  notification       (declared; serviced via EE2C)
 *
 * SCI-C registers (Inferred names, H8S SCI): SMR 0xFFFF88, BRR 0xFFFF89,
 *   SCR 0xFFFF8A, TDR 0xFFFF8B, SSR 0xFFFF8C, RDR 0xFFFF8D.
 *
 * Two RAM rings in the copied .data block:
 *   FF62D8 : USB-OUT -> SCI-C ring  (host bytes waiting to go to the DSP)
 *   FF62C8 : SCI-C -> USB-IN  ring  (DSP bytes waiting to go to the host)
 * Both are {rd,wr,base,limit} byte rings managed by sub_78334/sub_7837C.
 * ============================================================================ */

#include <stdint.h>
typedef uint8_t u8; typedef uint16_t u16; typedef uint32_t u32;

#define SCI_TDR (*(volatile u8*)0xFFFF8B)
#define SCI_SSR (*(volatile u8*)0xFFFF8C)   /* b7 TDRE, b6 RDRF, b5 ORER, b4 FER, b3 PER */
#define SCI_RDR (*(volatile u8*)0xFFFF8D)
#define SCI_SCR (*(volatile u8*)0xFFFF8A)
#define IER0    (*(volatile u8*)0xFFFFEE04)
#define TRG     (*(volatile u8*)0xFFFFEE2C)

struct ring { u8 *rd; /*+0*/ u8 *wr; /*+4 also the "4" field*/ u8 *base; u8 *limit; };
extern struct ring OUT_ring;   /* 0xFF62D8 : USB-OUT -> SCI-C */
extern struct ring IN_ring;    /* 0xFF62C8 : SCI-C  -> USB-IN */
struct qeng { /* 0xFF6288 generic queue engine; +0x50/+0x54 OUT-ring head/tail */
    u8 *f[0x20]; };
extern struct qeng QE;         /* 0xFF6288 */

/* ---------------------------------------------------------------------------
 * sub_76FC8 @ 0x076FC8 -- SCI-C TRANSMIT pump (the "data pump"). Drains up to
 * 64 bytes from the OUT ring to SCI-C TDR by polled I/O, then re-arms the USB
 * bulk-OUT endpoint interrupt (flow control). Sole caller is 0x0781C0 inside the
 * gated service loop 0x07815C (runs only in DSP-WRITE state >= 5). doc 42.
 * Argument er0 = per-channel control block (0xFF62D8); er6 fixed = 0xFF6288.
 * --------------------------------------------------------------------------- */
void sci_c_tx_pump(struct ring *ch)   /* ch == &OUT_ring */
{
    /* count = pending bytes in the 0xFF6288 OUT window (fields +0x50/+0x54) */
    u32 count = qe_pending(&QE);                        /* 0x076FD8..0x077006       */
    if (count > 0x40) count = 0x40;                     /* 0x077008 clamp to 64     */

    while (count--) {                                   /* 0x077018 loop            */
        u8 byte = *ch->wr;                              /* 0x07701C @(4,er3)=next   */
        while (!(SCI_SSR & 0x80)) { }                   /* 0x07701E/20 wait TDRE    */
        SCI_TDR = byte;                                 /* 0x077022 write TDR       */
        SCI_SSR &= ~0x80;                               /* 0x077024 clear TDRE      */
        if (++ch->wr >= ch->limit) ch->wr = ch->base;   /* advance/wrap @(4,er3)    */
    }

    /* tail: if the 0xFF6288 OUT ring now has room, re-enable the USB bulk-OUT
     * interrupt so the host can send the next packet. */
    if (qe_has_room(&QE))                               /* 0x07704C..               */
        IER0 |= 0x40;                                   /* 0x07709E bset #6 @EE04   */
    /* rebuild the IER snapshot at 0xFF62F8 (0x0770A4..0x077110) */
}

/* ---------------------------------------------------------------------------
 * sub_7711E @ 0x07711E -- SCI-C RECEIVE bridge, called from the SCI-C interrupt
 * sub_5615C at 0x0561B0 ONLY when 0xFF813A != 0. Reads the SCI-C status, handles
 * the error bits, and on a normal receive pushes RDR into the IN ring, which the
 * IFR0-b4 handler (0x0768A8) later drains to the USB bulk-IN endpoint (EP 0x82).
 * --------------------------------------------------------------------------- */
u8 sci_c_rx_bridge(void)
{
    u8 ssr = SCI_SSR;                                   /* 0x077122 @FFFF8C         */
    SCI_SSR &= ~0x80;                                   /* 0x077124 clear TDRE      */
    u8 orer = ssr & 0x20;                               /* 0x077128                 */

    if (ssr & 0x10) {                                   /* 0x07712A FER framing err */
        if (orer) return SCI_SSR;                       /* 0x07712E                 */
        /* frame-error housekeeping: toggle SCR b4, poke 0xFFFD62/0xFFFD54 */
        /*   0x07713C..0x077160 (break/line-state bookkeeping)                   */
        return SCI_SSR;
    }
    if (ssr & 0x08) {                                   /* 0x077162 PER parity err  */
        if (orer) return SCI_SSR;
        SCI_SCR &= ~0x08;                               /* 0x07716C                 */
        return SCI_SSR;
    }
    /* normal path: a received byte is in RDR */
    u8 rx = SCI_RDR;                                    /* 0x077172 @FFFF8D         */
    SCI_SCR &= ~0x40;                                   /* 0x077174                 */
    if (orer) SCI_SCR &= ~0x38;                         /* 0x07717C overrun recover */
    /* push rx into the SCI-C -> USB-IN ring at 0xFF62C8 */
    *IN_ring.rd = rx;                                   /* 0x07718E store byte      */
    if (++IN_ring.base >= IN_ring.limit)                /* 0x077198 wrap            */
        IN_ring.rd = *(u8**)((u8*)&IN_ring + 8);        /* 0x07719C base            */
    else
        IN_ring.base += 1;                              /* 0x0771A2                 */
    return SCI_SSR;                                     /* 0x0771AA                 */
}

/* ---------------------------------------------------------------------------
 * sub_767BE @ 0x0767BE -- IFR0 b6 handler (record mask 0x40000000). EP 0x01
 * bulk-OUT data-ready. Moves the received packet into the OUT ring (via
 * sub_78334, er0=FF6368 src, er1=FF62D8 ring) and manages IER0 b6 flow control
 * against the free space (limit FF637A). When the ring is full it clears IER0 b6
 * so the host is NAKed until the pump (above) drains it.
 * --------------------------------------------------------------------------- */
void on_ep1_bulk_out(u32 pending)
{
    if (out_ring_free(&QE) <= *(u8*)0xFF637A) {         /* 0x0767F6 bgt else        */
        IER0 &= ~0x40;                                  /* 0x0767FA bclr #6 (NAK)   */
        /* rebuild IER snapshot, clear busy flag FF6240 (0x076800..0x076836) */
    } else {
        ring_fill((void*)0xFF6368, &OUT_ring);          /* 0x076844 jsr sub_78334   */
    }
}

/* ---------------------------------------------------------------------------
 * sub_768A8 @ 0x0768A8 -- IFR0 b4 handler (record mask 0x10000000). EP 0x82
 * bulk-IN serviceable: drain the SCI-C->USB IN ring (0xFF62C8) into the IN FIFO
 * via sub_7837C, store the moved count at 0xFF63F8.
 * --------------------------------------------------------------------------- */
void on_ep2_bulk_in(void)
{
    if (!(IFR0 & 0x10)) return;                          /* 0x0768A8 btst #4         */
    u16 n = ring_drain((void*)0xFF6354, &IN_ring);       /* 0x0768BC jsr sub_7837C   */
    *(u16*)0xFF63F8 = n;                                 /* 0x0768C0                 */
}

/* ============================================================================
 * DATA-PLANE SUMMARY
 *   PC  --(CDC bulk OUT EP 0x01)-->  OUT ring 0xFF62D8  --(sci_c_tx_pump)-->  SCI-C TDR --> DSP
 *   PC  <--(CDC bulk IN  EP 0x82)--  IN  ring 0xFF62C8  <--(sci_c_rx_bridge)-- SCI-C RDR <-- DSP
 *
 *   Gating:
 *     - Enumeration + RX half require only  0xFF813A != 0  (boot strap held).
 *     - TX half (sci_c_tx_pump) additionally requires DSP-WRITE state >= 5
 *       (0xFFB0C4 >= 5): its only caller 0x0781C0 sits in the service loop
 *       0x07815C, reached only from 0x05DD12.
 *   The SCI-C is reconfigured async 8-N-2 (SMR 0x08 / BRR 0x0C / SCR 0x70) by
 *   0x078222; the DSP reset/boot pins on port 0xFFFF52 are pulsed by the
 *   DSP-WRITE state machine sub_5DD00 BEFORE the pump runs.
 *
 *   What flows: raw bytes to/from the DSP (command/firmware-download stream),
 *   max one 64-byte full-speed bulk packet per pump call. No ADC, no IQ, no
 *   sample buffer, no DMA, no isochronous pipe touches this path.
 *   Sinks/sources are exactly 0xFFEExx (USB module) and 0xFFFF8x (SCI-C); no
 *   program-flash control register is referenced on any decoded CDC routine.
 * ============================================================================ */
