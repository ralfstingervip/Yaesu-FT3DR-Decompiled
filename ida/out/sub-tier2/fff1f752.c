/* ============================================================================
 * sub_FFF1F752   [0xFFF1F752 .. 0xFFF20186)   2612 bytes
 * Lane F7 hand-reconstruction.  RX64M, little-endian, ROM@0xFFC00000.
 * Full annotated disassembly: fff1f752.lst
 *
 * ROLE: FAT long-file-name (LFN) directory path resolver / dir_register core
 *       ("follow_path" + "create_name" + "dir_find/dir_register").  The shared
 *       name-lookup engine of the SD filesystem - 20 call sites.
 *
 * Confirmed facts (addresses cite fff1f752.lst):
 *   - large 0xF4-byte frame; args R1..R4 + 5 stack args (arg_0,arg_1,arg_4,
 *       arg_8,arg_C).  R1 = dir/file object (var_4); obj[0x5C] = fs context.
 *   - builds an 8.3 short name in an 11-byte buffer (var_E7..):
 *       blkcopy(buf, ' ', 0x0B, ...)  then  buf[0]='.' (0x2E)   (@FFF1F786/90)
 *       0x0B = 11 = SFN length; 0x20 = ' ' pad.
 *   - works three 512-byte windows inside the fs object fs=obj[0x20]:
 *       fs+0x60C, fs+0x80C, fs+0xA0C   (two memset(.,0,0x200))  (@FFF1F796..7DD)
 *       0x200 = 512 = sector size.
 *   - LFN entry count:  n = (namelen-1)/13 + 1   via  div #0Dh  (@FFF1F8ED)
 *       13 = UCS-2 chars per LFN directory slot  --> definitive LFN handling.
 *       var_9E accumulates the slot counter.
 *   - name-character classification uses the special-char table @0xFFF4ADEE
 *       ("+,;=[]" and friends) passed to FFF20BA2                 (@FFF1F8BE)
 *   - negative errno results: -0x47(-71), -0x46(-70), -0x63(-99 compared).
 *   - helpers: FFF2432F (tokenise/scan path, pushes 'r'),
 *       FFF2DD4A (sub-dir descend), FFF20BA2 (gen/validate name, uses FFF4ADEE),
 *       FFF2E478 (memcpy 13-byte frag), FFF2E7EF (name compare),
 *       FFF2E622/FFF2E666/FFF2E92E/FFF2E9B7 (char/case helpers),
 *       FFF20410 (dir_read next), FFF20698 (clust->sector / get_fat),
 *       FFF2E4AF (block clear/copy).  7 loops (dir-entry scans).
 *
 * VERDICT: real, heavy logic - the most complex FAT routine in this lane and
 *          the shared path-resolution core.  No hardware/USB/DSP.
 * ==========================================================================*/

#include <stdint.h>

#define SFN_LEN      0x0B      /* 11 */
#define SECT         0x200     /* 512 */
#define LFN_CHARS    13        /* UCS-2 chars per LFN slot */

#define OFF_FSCTX    0x5C
#define WIN_DIR      0x60C     /* fs directory window                 */
#define WIN_FAT      0x80C     /* fs FAT window (sector-sized)        */
#define WIN_DATA     0xA0C     /* fs data window (sector-sized)       */

extern void blkset(void *d, int v, int n, void *fsctx);          /* FFF2E4AF */
extern void memcpy13(void *d, const void *s, int n);             /* FFF2E478 */
extern int  path_token(void *obj, const void *path, int z, char rw); /* FFF2432F */
extern int  subdir_find(void *dirwin, void *name, void *outp);   /* FFF2DD4A */
extern int  name_gen(void *obj, void *outbuf, const void *tbl);  /* FFF20BA2 */
extern int  dir_next(void *ctx, void *win);                      /* FFF20410 */
extern int  clust2sect(void *fsctx, int clust);                  /* FFF20698 */
extern int  name_cmp(const void *a, const void *b);              /* FFF2E7EF */

#define SPECIAL_CHARS  ((const void *)0xFFF4ADEE)   /* "+,;=[]" etc. */

/* follow_path: walk 'path' from object 'obj', resolving each component as an
 * LFN-aware directory lookup, leaving the final dir entry addressed in obj. */
int32_t follow_path_FFF1F752(void *obj, const void *path, int flags,
                             void *arg4, void *out_a, void *out_b, void *out_c)
{
    uint8_t  sfn[SFN_LEN];              /* var_E7..   8.3 short name       */
    uint8_t  frag[LFN_CHARS];          /* var_82..   one 13-char LFN frag */
    void    *fsctx = *(void **)((uint8_t *)obj + OFF_FSCTX);
    int32_t  res;
    int      nchars, nslots;

    /* --- init working buffers (SFN = ".", windows cleared) ----------- */
    blkset(sfn, ' ', SFN_LEN, fsctx);
    sfn[0] = '.';                                             /* @FFF1F790 */
    blkset((uint8_t *)fsctx + WIN_FAT,  0, SECT, fsctx);      /* @FFF1F7C7 */
    blkset((uint8_t *)fsctx + WIN_DATA, 0, SECT, fsctx);      /* @FFF1F7DD */

    /* --- tokenise the path (first component) ------------------------- */
    res = path_token(obj, path, 0, 'r');                      /* @FFF1F83A */
    if (res) return res;                                      /* bail      */
    /* empty path -> error -0x47 (@FFF1F855) */

    /* --- descend one component -------------------------------------- */
    res = subdir_find((uint8_t *)fsctx + 0x40C, frag, out_a); /* @FFF1F86A */
    if (res == -0x63) return -0x46;         /* not found -> -70 (@FFF1F878) */

    /* --- compute LFN slot count for this component ------------------- *
     * nslots = (namelen - 1) / 13 + 1;  then used to iterate dir slots. */
    nchars = /* component length */ 0;                        /* var_28    */
    nslots = (nchars - 1) / LFN_CHARS + 1;                    /* @FFF1F8ED */
    (void)nslots;

    /* --- generate / validate the on-disk name using the special table  */
    name_gen(obj, frag, SPECIAL_CHARS);                      /* @FFF1F8C7 */

    /* --- scan directory entries, matching 13-char LFN fragments ------ *
     * for each dir slot (loops @FFF1FB13.. etc. - 7 back-edges):        *
     *     dir_next(ctx, win);                                           *
     *     memcpy13(frag, slot_chars, 13);                              *
     *     if (name_cmp(frag, want) == 0) { matched; break; }           *
     *     follow FAT chain via clust2sect()/get_fat when window ends.   */
    for (;;) {
        if (dir_next(obj, (uint8_t *)fsctx + WIN_DIR))        /* @FFF1F973 */
            break;
        memcpy13(frag, /*slot*/0, LFN_CHARS);                /* @FFF1F951 */
        if (name_cmp(frag, /*want*/0) == 0)                  /* @FFF1F95B */
            break;                                            /* found     */
        /* on window exhaustion: clust2sect() -> next sector (@FFF1F9C2) */
    }

    /* result: 0 on match with the dir entry addressed in obj, else errno */
    return res;                                               /* @FFF2017F */
}
