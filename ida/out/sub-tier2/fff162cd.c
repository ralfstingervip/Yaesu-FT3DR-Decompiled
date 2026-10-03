/* ============================================================================
 * sub_FFF162CD   [0xFFF162CD .. 0xFFF16CAD)   2528 bytes
 * Lane F7 hand-reconstruction.  RX64M, little-endian, ROM@0xFFC00000.
 * Full annotated disassembly: fff162cd.lst
 *
 * ROLE: f_open() of the SD-card FAT/exFAT filesystem layer.
 *       Resolve a path+mode into (or out of) the open-file handle table.
 *
 * Confirmed facts (addresses cite fff162cd.lst):
 *   - single caller FFF162AC (the public f_open shim).
 *   - 3 args: R1 = path/key (var_4), R2 = mode string (var_8), R3 (var_C).
 *   - open-file handle table:
 *       count  = *(int16_t *)0x00012512                 (@FFF163CB)
 *       base   = *(FIL **)   0x00065E24  -> var_6C walker(@FFF162F7)
 *       ctx    = *(void **)  0x00065E2C  -> var_68       (@FFF162EE)
 *       stride = 0x468 bytes per handle                  (@FFF163C5 add #468h)
 *       rec->name  @ +0x23C   (compared via FFF224CF)    (@FFF1634E)
 *       rec->flags @ +0x442   (0=free, 0xFF=opening, 0x20=open, bit0=write)
 *       rec->fsctx @ +0x5C                               (@FFF1644D)
 *   - mode chars parsed: 'r'(0x72) 'w'(0x77) 'a'(0x61) '+'(0x2B) ' '(0x20).
 *   - negative errno returned via FFF1EE7B(code,0):
 *       -1 generic, -2, -3, -4, -5, -7, -10(-0xA), -13(-0xD), -40(-0x28).
 *   - helpers: FFF15D69 (lock/acquire), FFF224CF (name compare, 0==match),
 *       FFF1EF1F/FFF1EF5D/FFF1EF91 (validate/open on fsctx),
 *       FFF2E4AF (block copy/clear), FFF2E78B (char/flag map),
 *       FFF1F18B/FFF1F752/FFF20186/FFF20698/FFF2086D (FAT dir/path ops),
 *       FFF26289/FFF26346/FFF26BE9 (create / truncate / dir update),
 *       FFF2ECA4/FFF2ED1A/FFF2E68E (misc fs helpers), FFF15D74 (unlock),
 *       FFF1EE7B (build result/errno).
 *
 * VERDICT: real logic - the core open path (table scan, free-slot tracking,
 *          mode parse, create/truncate dispatch, error mapping).  Calls the
 *          Lane F7 path resolver FFF1F752.  No hardware/USB/DSP.
 * ==========================================================================*/

#include <stdint.h>

#define FIL_STRIDE   0x468
#define OFF_NAME     0x23C
#define OFF_FLAGS    0x442
#define OFF_FSCTX    0x5C

#define FILES_COUNT  (*(volatile int16_t *)0x00012512)
#define FILES_BASE   (*(volatile uint8_t **)0x00065E24)
#define FILES_CTX    (*(volatile void    **)0x00065E2C)

/* external fs helpers (names only; see fff162cd.lst / callees.txt) */
extern int  f_lock(void);                                   /* FFF15D69 */
extern void f_unlock(void);                                 /* FFF15D74 */
extern void *mk_result(int32_t code, int32_t aux);          /* FFF1EE7B */
extern int  name_cmp(const uint8_t *rec_name, const void *key); /* FFF224CF */
extern uint8_t  mode_map(uint8_t c);                        /* FFF2E78B */
extern int  fs_prepare(void *fsctx);                        /* FFF1EF1F */
extern int  fs_open_lo(void *fsctx);                        /* FFF1EF5D */
extern int  fs_open_lo2(void *fsctx);                       /* FFF1EF91 */
extern void blkcopy(void *d, int v, int n, const void *s);  /* FFF2E4AF */
extern int  dir_resolve(void *fp, const void *key, int flg);/* FFF1F752 */
extern int  file_create(void *fp /*...*/);                  /* FFF26289 */
extern int  file_truncate(void *fp /*...*/);                /* FFF26346 */

void *f_open_FFF162CD(const void *path, const char *mode, void *arg3)
{
    uint8_t *rec;
    int      i, free_seen = 0;
    uint8_t *free_slot = 0;

    if (f_lock() != 0)                        /* @FFF16303 */
        return mk_result(-40, 0);             /* lock busy */

    /* ---- scan the handle table ------------------------------------- */
    rec = FILES_BASE;                         /* *0x65E24 */
    for (i = 0; i < FILES_COUNT; i++, rec += FIL_STRIDE) {   /* @FFF163CB loop */
        if (rec[OFF_FLAGS] == 0) {            /* a free slot              */
            if (!free_seen) { free_seen = 1; free_slot = rec; }
            continue;
        }
        if (name_cmp(rec + OFF_NAME, path) == 0)     /* @FFF16352 match   */
            break;                            /* already-open handle found */
    }

    /* ---- already open: reject unless sharing allowed (mode "r+") ---- */
    if (i < FILES_COUNT) {                     /* matched an open handle   */
        if (!(mode[0] == 'r' && mode[1] == '+')) {   /* @FFF1635E/16366  */
            f_unlock();
            return mk_result(-7, 0);          /* sharing violation        */
        }
        /* ... re-open same handle for r+ ... */
    }

    if (free_slot == 0) {                      /* table full               */
        f_unlock();
        return mk_result(-10, 0);             /* @FFF163F5 too many open  */
    }
    rec = free_slot;

    /* ---- claim the slot, set up fs context ------------------------- */
    rec[OFF_FLAGS] = 0xFF;                      /* "opening"  (@FFF1645D)  */
    blkcopy(/*dst*/0, 0, FIL_STRIDE, /*src ctx field*/ *(void **)(rec+OFF_FSCTX));

    /* ---- parse mode string, dispatch create/open/truncate ---------- */
    /* 'r' : open existing (-2/-3 if missing)                            */
    /* 'w' : create / truncate                                          */
    /* 'a' : create if absent, seek end                                 */
    /* '+' : set read-write bit:  flags = 0x20 | bit0   (@FFF168E0/EF)  */
    switch (mode[0]) {
    case 'r':  /* ... dir_resolve(); if missing -> mk_result(-3) ... */ break;
    case 'w':  /* ... file_create()/file_truncate() ...              */ break;
    case 'a':  /* ... open or create, position at EOF ...            */ break;
    default:   f_unlock(); return mk_result(-1, 0);
    }

    rec[OFF_FLAGS] = 0x20;                      /* open                    */
    if (mode[1] == '+' /* or mode[2] */)       /* @FFF168E9 cmp '+'       */
        rec[OFF_FLAGS] |= 0x01;                /* read-write (bset #0)    */

    f_unlock();                                /* @various FFF15D74       */
    return mk_result(0, (int32_t)(intptr_t)rec);   /* success: handle     */
}
