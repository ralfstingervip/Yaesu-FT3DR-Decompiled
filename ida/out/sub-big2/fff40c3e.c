/* ============================================================================
 * Lane F4 — hand-reconstructed C for Routine A
 *
 * Assigned as "sub_FFF40C3E, 0xFFF40C3E-0xFFF410ED (1,199 B), body-validated,
 * no direct xref".  CORRECTION (Confirmed): 0xFFF40C3E is NOT a function start.
 * The bytes 6E 6E at FFF40C3E are the last two bytes of
 *     FFF40C3C  C5 FE 6E 6E   mov.b 6Eh[r15], 6Eh[r14]
 * so the lane-4 "body-validated" sweep seeded a decode mid-instruction and
 * mis-read 6E6E as `pushm r6-r14`.  The real routine is
 *
 *     sub_FFF40B7D   0xFFF40B7D .. 0xFFF410EB   (1,390 bytes)
 *
 * IDA over-split it into sub_FFF40B7D (FFF40B7D-FFF40C10) + sub_FFF40C3E
 * (FFF40C3E-FFF410ED); control flows straight through both halves
 * (FFF40C0E bra ->FFF40C4C forward, FFF40C5B blt ->FFF40C10 back).
 * Single real caller: FFF40B69 (inside sub_FFF40B61).
 *
 * WHAT IT DOES (Confirmed by disassembly):
 *   Field-by-field reconcile of the incoming MAIN->SUB menu/edit frame into the
 *   committed SUB shadow, marking changed fields "dirty", then flush.
 *       SRC = incoming frame   @ RAM 0x8E46   (MAIN writes it over IPC)
 *       DST = committed shadow @ RAM 0x8C4D   (SUB's persistent copy)
 *   For every field that differs, copy SRC->DST and OR an event bit into the
 *   32-bit dirty word at RAM 0x1D3B4 (helper sub_FFEEFEEE).  The set of fields
 *   reconciled depends on a 2-bit "mode" = frame[0x6C] & 3, and on the
 *   committed shadow[0x6C] (0/1/2) which selects one of three fixed field
 *   groups.  Ends by calling sub_FFEF0294 (the dirty-bit flush/dispatch).
 *
 * Call chain:  sub_FFF40ADB (reads menu cursor 0x8F73, dispatches via table
 *              off_FFED83E8) -> sub_FFF40B61 -> sub_FFF40B7D (this).
 * ==========================================================================*/

#include <stdint.h>

/* ---- RAM state ---------------------------------------------------------- */
#define SHADOW_BASE   0x8C4Du      /* committed shadow (DST) */
#define FRAME_BASE    0x8E46u      /* incoming IPC frame (SRC) */
#define S(off)  (*(volatile uint8_t *)(SHADOW_BASE + (off)))
#define F(off)  (*(volatile uint8_t *)(FRAME_BASE  + (off)))
#define PTR_1D39C (*(volatile void **)0x1D39Cu)   /* published "shadow+0x20" ptr */

/* ---- helpers (see ida\out\sub-big2\callees.txt / helpers_extra.txt) ------ */
extern void     FFEEFEEE(uint32_t mask);   /* *(uint32*)0x1D3B4 |= mask  (set dirty bits) */
extern void     FFEF0294(void);            /* flush: if lane3 ready, tx 'e', dispatch bits
                                              set in 0x6885C/0x68860 via FFEEFEA4/FFEEFEEE */
extern void     FFEF4142(void);            /* reconcile the COMMON header fields:
                                              0x07 bit0, 0x0A, 0x0B, 0x0C (dirty via FFEEFEA4) */
extern void     FFEF42A7(void *dst, const void *src, int n); /* small block copy (CC-RX r1,r2,r3) */

/* field-0x6E length per mode, flash table @0xFFC3E94E = { 0x13,0x27,0x4F,0x6B } */
extern const uint8_t tbl_len_FFC3E94E[4];  /* = {19, 39, 79, 107} */

/* reconcile one fixed-width group of `n` bytes at `off`, counting changes */
static void group(uint8_t off, uint8_t n, uint8_t *changed)
{
    for (uint8_t i = 0; i < n; i++)
        if (S(off + i) != F(off + i)) { S(off + i) = F(off + i); (*changed)++; }
}

/* reconcile `n` bytes at `off`, firing a per-index dirty bit (2<<i) on change */
static void group_bits(uint8_t off, uint8_t n)
{
    for (uint8_t i = 0; i < n; i++)
        if (S(off + i) != F(off + i)) { FFEEFEEE(2u << i); S(off + i) = F(off + i); }
}

void sub_FFF40B7D(void)
{
    uint8_t mode;             /* var_1 (sp+3): frame[0x6C] & 3, 0..3   */
    uint8_t d;                /* var_4 (sp+0): frame[0x6D] snapshot     */
    uint8_t changed;          /* var_3 (sp+1): change accumulator       */
    uint8_t i;                /* var_2 (sp+2): loop index               */

    changed = 0; i = 0; mode = 0; d = 0;

    mode = F(0x6C) & 3;                 /* FFF40B8B-B96 */
    d    = F(0x6D);                     /* FFF40B98-B9E */

    FFEF4142();                         /* FFF40BA1: reconcile header fields */

    PTR_1D39C = (void *)(SHADOW_BASE + 0x20);          /* FFF40BA5-BB4 */
    FFEF42A7((void *)(SHADOW_BASE + 0x20),             /* FFF40BB6-BCA */
             (const void *)(FRAME_BASE + 0x20), 3);     /* copy the 0x20 triplet */

    if (S(0x6C) != mode) { FFEEFEEE(1); S(0x6C) = mode; }   /* FFF40BCE-BE8 */
    if (S(0x6D) != d)    { FFEEFEEE(1); S(0x6D) = d;    }   /* FFF40BEC-C05 */

    /* variable-length body field at +0x6E; length = tbl_len_FFC3E94E[mode].
       (outer loop FFF40C10..FFF40C5B; copies changed bytes, counts in `changed`) */
    changed = 0;
    for (i = 0; i < tbl_len_FFC3E94E[mode]; i++)
        if (S(0x6E + i) != F(0x6E + i)) { S(0x6E + i) = F(0x6E + i); changed++; }
    if (changed) FFEEFEEE(1);           /* FFF40C5D-C64 */

    /* mode-group switch on the (now committed) shadow[0x6C]; FFF40C68-C7D */
    switch (S(0x6C)) {
    case 0:                             /* FFF40C80 */
        changed = 0;
        group(0x81, 4, &changed);
        group(0x85, 4, &changed);
        group(0x89, 4, &changed);
        if (changed) FFEEFEEE(1);       /* FFF40D58-5F */
        /* paired 0x8D / 0x90 loop, 3 each, per-index dirty bit; FFF40D68-DE8 */
        for (i = 0; i < 3; i++) {
            if (S(0x8D + i) != F(0x8D + i)) { FFEEFEEE(2u << i); S(0x8D + i) = F(0x8D + i); }
            if (S(0x90 + i) != F(0x90 + i)) { FFEEFEEE(2u << i); S(0x90 + i) = F(0x90 + i); }
        }
        break;

    case 1:                             /* FFF40DED */
        changed = 0;
        group(0x95, 4, &changed);
        group(0x99, 4, &changed);
        group(0x9D, 4, &changed);
        if (changed) FFEEFEEE(1);       /* FFF41032-39 */
        for (i = 0; i < 3; i++) {
            if (S(0xA1 + i) != F(0xA1 + i)) { FFEEFEEE(2u << i); S(0xA1 + i) = F(0xA1 + i); }
            if (S(0xA4 + i) != F(0xA4 + i)) { FFEEFEEE(2u << i); S(0xA4 + i) = F(0xA4 + i); }
        }
        break;

    case 2:                             /* FFF40F5A */
        changed = 0;
        group(0xBD, 4, &changed);
        group(0xC1, 4, &changed);
        group(0xC5, 4, &changed);
        if (changed) FFEEFEEE(1);
        for (i = 0; i < 3; i++) {
            if (S(0xC9 + i) != F(0xC9 + i)) { FFEEFEEE(2u << i); S(0xC9 + i) = F(0xC9 + i); }
            if (S(0xCC + i) != F(0xCC + i)) { FFEEFEEE(2u << i); S(0xCC + i) = F(0xCC + i); }
        }
        break;

    default:                            /* shadow[0x6C] not 0/1/2 -> no group */
        break;
    }

    /* tail (FFF410C4): reconcile the single byte at +0x09 WITHOUT a dirty bit */
    if (S(0x09) != F(0x09)) S(0x09) = F(0x09);

    FFEF0294();                         /* FFF410E7: flush/dispatch dirty bits */
}

/* NOTE on naming: this file keeps the assigned name fff40c3e.c, but the entry
 * is sub_FFF40B7D.  "group()" matches the FFF40C88/CCF/D16-style 4-byte copy
 * loops; "group_bits()" is provided for symmetry but the 0x8D/0x90, 0xA1/0xA4,
 * 0xC9/0xCC loops are inlined above because they interleave two offsets. */
