/* ============================================================================
 * l15_keyseq.c  -  Hand-reconstructed C for the MAIN 8-step hidden key machine
 *                  at 0x01494C.  Lane L15.
 *
 * DOCUMENTATION ONLY.  By-hand transcription of H8SX disassembly in
 * decrypted\FT3D_MAIN_ver102_EXP.bin (sha256 8e3ecd05...), big-endian, base 0,
 * so each comment address is file offset == mapped address.  Nothing compiled
 * or run.
 *
 * VERIFICATION NOTE.  Doc 49 (49-key-sequence-hidden.md, section F7) already
 * carries hand-written C for this machine.  Lane L15 checked that C line by
 * line against the bytes of 0x01494C-0x014AA6 (dumped in l15_dump.txt, cited in
 * citations.tsv).  RESULT: doc 49's C is CORRECT.  Every gate, the FF8F2E
 * switch arms (cases 0/5/8/10), the FF910A==0x66600 guard on cases 8 and 10,
 * the four armed bits (0x08/0x10/0x20/0x40), the four step handlers with their
 * expected counter values, the required slot order (8,5,6,1,5,8,8,5), the four
 * completions and the reset-clears-bit-0-only behaviour all match the bytes.
 * No rewrite was required.  Two framing clarifications only (not errors):
 *   (a) the "keyseq_step(keyslot)" in doc 49 is in reality four separate
 *       functions (0149D2 slot6, 0149EA slot1, 014A02 slot8, 014A1E slot5),
 *       each hard-coded to its own counter value(s); and
 *   (b) completion (014A36) falls to reset (014A96) if none of bits 3-6 is set.
 * Both are consistent with doc 49's prose.  This file reproduces the verified
 * reconstruction with per-block addresses.
 *
 * RAM globals (address, name, meaning, source):
 *   FF89C1 b3  key_lock   KEY LOCK on (must be ON to arm)              [doc 49]
 *   FFBC8A     seq_flags  b7 active, b3/b4/b5/b6 selected feature       [doc 49]
 *   FFBC8B     seq_count  step counter, counts DOWN 8..1                [doc 49]
 *   FF8F2E     grp_index  0-based setup-menu group index                [doc 49]
 *   FF910A     guard_dw   must equal 0x00066600 for cases 8/10          [doc 49]
 *   FFAAE0     ui_mode    UI-mode request (0x16 = menu/settings)         [doc 49]
 *   FFB0C8     radioid_unlock  1 = RADIO ID edit/save enabled            [doc 49]
 *   FF817E b1  ui_dirty   UI redraw request                             [doc 49]
 *   FF89C4     feat_bits  b3 group-13 enable, b4 RAM DISPLAY enable      [doc 23/32]
 *   er0+1      screen id  must be 0x0C (setup-menu group list)           [doc 49]
 * External: sub_1645E (0x1645E)=bnot #3 FF89C4; sub_16456 (0x16456)=bnot #4
 *   FF89C4; sub_3FFA0 (consume key); sub_14BBA (redraw); caller sub_1CF0A
 *   (LOCK-key handler, which toggles FF89C1 b3 then calls the arm).
 * ========================================================================== */

#include <stdint.h>
typedef uint8_t u8; typedef uint32_t u32;

/* ---- arm (sub_1494C, 01494C): called from the LOCK-key handler ----------*/
void keyseq_arm(struct screen *er0)                    /* 01494C */
{
    if (!(FF89C1 & 0x08)) return;                      /* 01494C: KEY LOCK on */
    if (FFBC8A & 0x80)    return;                      /* 014954: not active  */
    if (er0->id != 0x0C)  return;                      /* 01495C: group list  */

    FFBC8A = 0;                                        /* 014964: clear flags */
    switch (FF8F2E) {                                  /* 01496A: 0-based grp */
    case 0:                                            /* 014972 -> 0149B6    */
        FFBC8A |= 0x10;                                /* 0149B6: ext SW-VER  */
        break;
    case 5:                                            /* 01496E -> 0149BE    */
        FFBC8A |= 0x08;                                /* 0149BE: RADIO ID    */
        break;
    case 8:                                            /* 014976 -> 01499A    */
        if (FF910A != 0x00066600) return;              /* 01499A: guard       */
        FFAAE0 = 0x16;                                 /* 0149A8              */
        FFBC8A |= 0x20;                                /* 0149AE: -> sub_1645E*/
        break;
    case 10:                                           /* 01497A -> 01497E    */
        if (FF910A != 0x00066600) return;              /* 01497E: guard       */
        FFAAE0 = 0x16;                                 /* 01498C              */
        FFBC8A |= 0x40;                                /* 014992: -> sub_16456*/
        break;
    default:                                           /* 01497C: bne rts     */
        return;
    }
    FFBC8A |= 0x80;                                    /* 0149C4: ACTIVE      */
    FFBC8B  = 8;                                       /* 0149CA: counter = 8 */
}

/* ---- the four per-key step handlers --------------------------------------
 * Each is a key-table slot of screen 0xC0 (SOFTWARE VERSION) and runs only
 * while that screen is current and the machine is active.  Shown here folded
 * into one routine keyed on the slot number for readability; in the image they
 * are four distinct functions at the addresses in each case label.
 * The required slot order, read from the expected counter values, is
 * 8,5,6,1,5,8,8,5 for counter 8..1 (doc 49 F1).                             */
void keyseq_step(int slot)
{
    if (!(FFBC8A & 0x80)) { keyseq_reset(); return; }  /* each: btst #7, beq  */

    switch (slot) {
    case 6:   /* 0149D2 */ if (FFBC8B == 6) break;                   goto rst; /* 0149E0 */
    case 1:   /* 0149EA */ if (FFBC8B == 5) break;                   goto rst; /* 0149F8 */
    case 8:   /* 014A02 */ if (FFBC8B==8 || FFBC8B==3 || FFBC8B==2) break; goto rst; /* 014A10 */
    case 5:   /* 014A1E */ if (FFBC8B==7 || FFBC8B==4) break;        /* 014A2A */
              if (FFBC8B == 1) { keyseq_complete(); return; }        /* 014A34: done */
              goto rst;
    default:  goto rst;
    }
    FFBC8B--;                                          /* 014A8A: dec counter */
    sub_3FFA0();                                       /* 014A90: consume key */
    return;
rst:
    keyseq_reset();
}

/* ---- completion (014A36): apply the armed feature, request menu redraw ---*/
void keyseq_complete(void)                             /* 014A36 */
{
    if      (FFBC8A & 0x08) { FFB0C8 = 1; FFAAE0 = 0x16; }  /* 014A70: RADIO ID unlock */
    else if (FFBC8A & 0x10) { FFBC8A |= 1; FFAAE0 = 0x16; } /* 014A62: ext SW-VER digit*/
    else if (FFBC8A & 0x20) { sub_1645E(); }               /* 014A5C: bnot FF89C4 b3  */
    else if (FFBC8A & 0x40) { sub_16456(); }               /* 014A56: bnot FF89C4 b4  */
    else                    { keyseq_reset(); return; }    /* 014A54: none -> reset   */
    FF817E |= 0x02;                                    /* 014A7C: redraw      */
    FFBC8B  = 0;                                       /* 014A84              */
}

/* ---- reset (014A96): wrong key.  Clears ONLY bit 0; bit 7 stays set ------*/
void keyseq_reset(void)                                /* 014A96 */
{
    FFBC8A &= ~0x01;                                   /* 014A96: bclr #0     */
    FFBC8B  = 0xFF;                                    /* 014A9C              */
    sub_14BBA();                                       /* 014AA2: redraw      */
}
