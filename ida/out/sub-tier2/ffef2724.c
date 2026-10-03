/* ============================================================================
 * sub_FFEF2724   [0xFFEF2724 .. 0xFFEF34B1)   3469 bytes
 * Lane F7 hand-reconstruction.  Renesas RX64M (rx), little-endian, ROM@0xFFC00000.
 * Full annotated disassembly: ffef2724.lst
 *
 * ROLE: menu / settings field-fetch dispatcher.  Given a menu-row descriptor,
 *       look up the row's current value(s) in the settings RAM shadow and tag
 *       the value type.  Pure leaf (0 callees), straight-line (0 loops).
 *
 * Confirmed facts (addresses cite ffef2724.lst):
 *   - arg R1 = pointer to a 6+ byte row descriptor on the caller's stack.
 *       desc[0] = category code, valid 0xF0..0xFD        (@FFEF2728 movu.b [r1])
 *       desc[1] = sub-index                               (@FFEF2742 / FFEF2819)
 *       desc[2] = OUT: value-type tag                     (mov.b #k, 2[r1])
 *       desc[3] = base adjust (VFO/band/slot), byte       (add 3[r1], r14)
 *       desc[4] = OUT: value byte A                       (mov.b off[base], 4[r1])
 *       desc[5] = OUT: value byte B                       (mov.b off[base], 5[r1])
 *   - settings shadow base = 0x00008C4D (RAM)             (mov.l #8C4Dh,r14, x40)
 *       record = (u8*)(0x8C4D + desc[3]); fields read at record[+0xNN].
 *   - sub-mode selector byte = *(u8*)0x00008CBA           (@FFEF2981, FFEF2A23)
 *       (= shadow[0x6D]); selects between 0/1/2 variants in several cases.
 *   - primary dispatch: 14-entry PC-relative jump table @0xFFF480CE,
 *       indexed by (desc[0]-0xF0), base = the bra.l @0xFFEF273E.
 *   - secondary dispatch for category 0xF1: 22-entry table @0xFFF480EA,
 *       indexed by desc[1] (0..0x15), base = the bra.l @0xFFEF282C.
 *   - RX note: `bra.l rN` is PC-relative (target = insn_ea + rN); that is why
 *       the 16-bit table entries (0x0002, 0x00D9, ...) resolve into the body.
 *
 * Both jump tables decoded from the image (see 34-sub-tier2.md):
 *   FFF480CE: F0->2740 F1->2817 F2->2B4E F3->2BA1 F4->2E02 F5->2EAB F6->30D9
 *             F7->325E F8->3318 F9..FC->34AF(default) FD->3482
 *   FFF480EA: 0->282E 1->2853 2->34AF 3->2878 4,5->289D 6->28C2 7->28E7 8->290C
 *             9->2931 10->2956 11->297B 12->2A94 13->2AB9 14->2ADE 15->2B04
 *             16,17->34AF 18->29F5 19->2A1A 20->2B29 21->2853
 *
 * VERDICT: real logic (a large, hand-written two-level computed-jump switch),
 *          but the per-case bodies are near-identical 2-field byte copies -
 *          structurally real, individually trivial.  No hardware, no USB/DSP.
 * ==========================================================================*/

#include <stdint.h>

/* One menu-row descriptor as the callers pass it (R1). */
typedef struct {
    uint8_t  cat;        /* [0] category 0xF0..0xFD                       */
    uint8_t  sub;        /* [1] sub-index                                 */
    uint8_t  type;       /* [2] OUT: value-type tag                       */
    uint8_t  adj;        /* [3] base adjust added to the shadow base      */
    uint8_t  valA;       /* [4] OUT: value byte A                         */
    uint8_t  valB;       /* [5] OUT: value byte B                         */
} menu_row_t;

#define SETTINGS   ((volatile uint8_t *)0x00008C4D)  /* settings RAM shadow   */
#define SUBMODE    (*(volatile uint8_t *)0x00008CBA)  /* = SETTINGS[0x6D]      */

/* Fetch the two display bytes for one settings field and tag the type. */
static inline void emit(menu_row_t *d, uint32_t offA, uint32_t offB, uint8_t type)
{
    volatile uint8_t *rec = SETTINGS + d->adj;   /* record = 0x8C4D + adj */
    d->valA = rec[offA];
    d->valB = rec[offB];
    d->type = type;
}

void sub_FFEF2724(menu_row_t *d)
{
    unsigned cat = (unsigned)d->cat - 0xF0;
    if (cat > 0x0D)                 /* @FFEF272E cmp #0Dh / bleu          */
        return;                      /* -> FFEF34AF (default, leaves desc) */

    switch (d->cat) {
    /* ---- category 0xF0 : sub-switch on desc[1] (@FFEF2740) ---------- */
    case 0xF0:
        switch (d->sub) {
        case 3: case 4: emit(d, 0x3F, 0x2B, 0x02); return;  /* FFEF275E */
        case 6:         emit(d, 0x3A, 0x26, 0x13); return;  /* FFEF2783 */
        case 9:         emit(d, 0x24, 0x22, 0x13); return;  /* FFEF27A8 */
        case 0xA:       emit(d, 0x23, 0x21, 0x13); return;  /* FFEF27CD */
        case 0xB:       emit(d, 0x24, 0x22, 0x0A); return;  /* FFEF27F2 */
        default:        return;                              /* -> 34AF  */
        }

    /* ---- category 0xF1 : table FFF480EA on desc[1] (@FFEF2817) ------ */
    case 0xF1:
        if (d->sub > 0x15) return;
        switch (d->sub) {               /* representative handlers:      */
        case 0:  emit(d, 0xBF, 0xB9, 0x0C); return;         /* FFEF282E */
        case 1:  emit(d, 0x83, 0x7D, 0x0C); return;         /* FFEF2853 */
        case 3:  emit(d, 0xD0, 0xCA, 0x0C); return;         /* FFEF2878 */
        case 4:  case 5: emit(d, 0x78, 0x6C, 0x01); return; /* FFEF289D */
        case 6:  emit(d, 0x7C, 0x6C, 0x00); return;         /* FFEF28C2 */
        case 7:  emit(d, 0x80, 0x6C, 0x02); return;         /* FFEF28E7 */
        case 8:  emit(d, 0x93, 0x7F, 0x02); return;         /* FFEF290C */
        case 9:  emit(d, 0x93, 0x7F, 0x02); return;         /* FFEF2931 */
        case 0xA:emit(d, 0x93, 0x7F, 0x02); return;         /* FFEF2956 */
        case 0xB:                                           /* FFEF297B */
            /* sub-mode branch on SUBMODE (=shadow[0x6D]=0x8CBA):        */
            switch (SUBMODE) {                 /* @FFEF2981 cmp 0/1/2    */
            case 0:  emit(d, 0x84, 0x81, 0x06); return;
            case 1:  emit(d, 0x98, 0x95, 0x06); return;
            case 2:  emit(d, 0xC0, 0xBD, 0x06); return;
            default: d->type = 0x06;           return;
            }
        /* cases 0x0C..0x15 -> similar field fetches, see ffef2724.lst  */
        default: return;
        }

    /* ---- categories 0xF2..0xF8, 0xFD : analogous field fetches ------
     * Each selects a different pair of settings offsets and a type tag;
     * 0xF3 (@FFEF2BA1) uses an explicit cmp-chain on desc[1] instead of a
     * jump table (compares 0xD3,0x41,0x4B,0x66,0x71,...).  See the .lst
     * for the exhaustive per-case offset map; the shape is identical.    */
    case 0xF2: case 0xF3: case 0xF4: case 0xF5:
    case 0xF6: case 0xF7: case 0xF8: case 0xFD:
        /* dispatched via FFF480CE to FFEF2B4E / 2BA1 / 2E02 / 2EAB /
         * 30D9 / 325E / 3318 / 3482 respectively */
        return;

    default:   /* 0xF9..0xFC : table entry == default */
        return;                                              /* FFEF34AF */
    }
}
