/* ============================================================================
 * sub_FFF4B084   [0xFFF4B084 .. 0xFFF4C226)   4514 bytes
 * Lane F7 hand-reconstruction.  RX64M, little-endian, ROM@0xFFC00000.
 * Full annotated disassembly: fff4b084.lst
 *
 * ROLE: baseline JPEG decoder core (header/frame/scan parser + Huffman entropy
 *       decode + IDCT set-up).  Serves the image-display subsystem (decoding
 *       stored / received JPEG pictures for the LCD).
 *
 * Confirmed facts (addresses cite fff4b084.lst):
 *   - prologue pushm r6-r13; 0xD0 frame; epilogue rtsd #0F0h,r6-r13 (@FFF4B683).
 *   - 2 callers FFF4B071/FFF4B07E (public shim FFF4B06C).
 *   - args: R1 = source descriptor; R2,R3 = output info structs (zeroed);
 *       R4 = mode (checked 0/1/2 @FFF4B0AA); stack arg_0 = destination/cb.
 *       R7 = decoder work context = R1[0x18]  (@FFF4B0B7).
 *   - argument validation returns large negative codes in R6:
 *       -1000(-0x3E8) null R1, -2000(-0x7D0) null R2, -3000(-0xBB8) null R3,
 *       -4000(-0xFA0) bad mode, -0x42E null ctx, -0x438/-0x492/-0x46A bad src.
 *   - BYTE READER = sub_FFF4C3A2 (41 callers): buffered getc; count @ctx+0x20,
 *       bytes at ctx+...+0x1E; refills via sub_FFF4C226 when empty (@FFF4C3C9).
 *       sub_FFF4C408 = read a full marker word; sub_FFF4C442 = (re)fill input.
 *   - MARKER FSM (16-bit markers built as byte|0xFF00):
 *       SOI  0xFFD8 (@FFF4B267)   SOF0 0xFFC0 (@FFF4B2A6, baseline only)
 *       SOS  0xFFDA (@FFF4B63D)   EOI  0xFFD9 (@FFF4BB55,C207,C216)
 *       RSTn 0xFFD0..0xFFD7 (@FFF4BC75), DNL/misc 0xFFDC (@FFF4BB5D,BCB5,...)
 *       stuffed byte 0xFF00 handled (@FFF4BEFD/BF11).
 *   - 2-byte big-endian segment length: get hi, shll #8, or lo, sub #2
 *       (@FFF4B2BD-C9, FFF4B647-57).
 *   - de-zigzag table @0xFFF508F8 (00 01 08 10 09 02 03 0A 11 18 20 ...)
 *       (@FFF4B965 mov.l #unk_FFF508F8,r3) -- definitive JPEG scan order.
 *   - ROM tables/sentinels @0xFFDA0000,0100,0200,0300,0400,0800, 0xFFDB0300,
 *       0xFFDC0000/0100, 0xFFD0FF00, 0xFFFF0100 referenced during table &
 *       component set-up (mostly 0xFF/0x00 fill; default/"not present" tables).
 *   - entropy decode: variable shifts (shll r14,rN @FFF4BEF1/BF11 = Huffman
 *       receive/extend), mul/div (IDCT & component up-sampling, e.g. FFF4BB8E
 *       div r1,r2; FFF4B5B9 divu r8,r4).  65 loop back-edges (clear loops,
 *       marker scan, MCU/component scans, IDCT).
 *   - a code pointer sub_FFF4FABD is stored into the context (@FFF4BA39) - a
 *       decode/output callback (this is the "nmXNr" that a printable-run scan
 *       mis-reported; it is code, not a string).
 *
 * VERDICT: real, heavy logic - the single most logic-dense routine in this lane.
 *          No hardware/USB/DSP; it consumes bytes from the SD/file layer and
 *          writes decoded pixels to a caller buffer.
 * ==========================================================================*/

#include <stdint.h>

#define SOI   0xFFD8u
#define EOI   0xFFD9u
#define SOF0  0xFFC0u
#define SOS   0xFFDAu

#define ZIGZAG  ((const uint8_t *)0xFFF508F8)   /* JPEG de-zigzag order */

extern int   jpd_byte(void *ctx);            /* FFF4C3A2  getc (buffered)     */
extern int   jpd_word(void *ctx);            /* FFF4C408  read marker word    */
extern int   jpd_fill(void *ctx, void *d);   /* FFF4C442  fill input          */
extern int   jpd_refill(void *ctx, int a, int b); /* FFF4C226 refill buffer  */
extern int   jpd_init2(void *ctx);           /* FFF4C408 variant / probe      */
extern int   jpd_tables(void *ctx);          /* FFF4C3A2-driven table parse   */

/* R7 decoder context: large struct; key fields used below */
#define CTX_SRC(c)     (*(void   **)((uint8_t*)(c)+0x00))
#define CTX_IN(c)      (*(void   **)((uint8_t*)(c)+0x04))   /* input obj   */
#define CTX_OUT1(c)    (*(void   **)((uint8_t*)(c)+0x08))
#define CTX_NCOMP(c)   (*(uint8_t *)((uint8_t*)(c)+0xE9))   /* #components */
#define CTX_RSTCNT(c)  (*(int32_t *)((uint8_t*)(c)+0x20))

/*
 * int jpeg_decode(src, out_info1, out_info2, mode, dest)
 *   mode 0 = full decode to 'dest'; 1/2 = header-only / info (no pixel output).
 * returns 0 on success, negative error otherwise.
 */
int32_t jpeg_decode_FFF4B084(void *src, void *oi1, void *oi2, int mode,
                             void *dest /* stack arg_0 */)
{
    void   *ctx;
    int     m;

    /* ---- argument validation (@FFF4B08A..B0FA) --------------------- */
    if (!src)            return -1000;
    if (!oi1)            return -2000;
    if (!oi2)            return -3000;
    if ((unsigned)mode >= 2) { /* mode must be 0..1 (2 used as reset) */ }
    ctx = *(void **)((uint8_t *)src + 0x18);
    if (!ctx)            return -0x42E;

    /* ---- zero the two output info structs & the context header ------ *
     * (the three tight clear loops @FFF4B133/B14D/B211, plus explicit    *
     *  field stores for oi1/oi2/ctx)                                     */
    /* memset(oi1, 0, ...); memset(oi2, 0, ...); ctx fields = 0 / -1    */

    jpd_init2(ctx);                         /* FFF4F560 set up callbacks  */
    /* store decode/output callback pointer into ctx (@FFF4BA39):        */
    /* ctx->cb = (void*)sub_FFF4FABD;                                     */

    /* ---- open input / read first marker ----------------------------- */
    if (jpd_fill(ctx, dest))     return /* -err @FFF4B665 */ -0x492;
    m = (mode == 0) ? jpd_word(ctx) : 0;    /* FFF4C408                   */
    if (m != (int)SOI)           return -0x492;   /* expect SOI          */

    /* ---- marker loop: parse segments until SOS, then decode scan ---- */
    for (;;) {
        /* skip 0xFF fill bytes, then read the marker (@FFF4B295 loop):  */
        int mk;
        do { mk = jpd_byte(ctx); } while (mk == 0xFF);
        mk |= 0xFF00;

        if (mk == SOF0) {                    /* baseline frame header     */
            /* read Lf, precision, Y, X, Nf; per-component: Ci, Hi/Vi, Tqi
             * (@FFF4B2AE..B5D5 - fills oi1 width/height, ctx component tbl,
             *  quant-table selectors; uses ROM tables @FFDA0000+).       */
        } else if (mk == SOS) {              /* start of scan (@FFF4B63D)  */
            /* read Ls, Ns, per-component (Cs, Td/Ta), Ss,Se,Ah/Al; then
             * decode entropy-coded MCUs:
             *   for each MCU / block:
             *     for each coeff: s = huff_decode(ctx);   (jpd_byte bits)
             *                     v = receive_extend(s);  (shll r14,..)
             *                     block[ZIGZAG[k]] = v * quant[k];
             *     idct_8x8(block);           (@FFF4BB8E div / mul)
             *     emit to dest / callback.
             *   handle RSTn (0xFFD0..D7) resync (@FFF4BC75).             */
            break;                           /* scan done -> EOI handling */
        } else {                             /* DQT/DHT/APPn/COM/DRI ...   */
            jpd_tables(ctx);                 /* consume segment by length  */
        }
    }

    /* ---- finish: expect EOI (@FFF4BB55/C207) ----------------------- */
    return 0;                                /* success (@FFF4C1xx)       */
}
