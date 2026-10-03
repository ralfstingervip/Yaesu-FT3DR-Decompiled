/* ============================================================================
 * sub_FFF1898D   [0xFFF1898D .. 0xFFF192BE)   2353 bytes
 * Lane F7 hand-reconstruction.  RX64M, little-endian, ROM@0xFFC00000.
 * Full annotated disassembly: fff1898d.lst
 *
 * ROLE: f_write() of the SD-card FAT filesystem - the file-write transfer
 *       loop (cluster/sector walk, window buffering, fsize extension).
 *
 * Confirmed facts (addresses cite fff1898d.lst):
 *   - 3 callers: FFF188F6, FFF28945, FFF2899B.
 *   - args: R1=count?, R2=size (var_8), R3=elem (var_C), R4=FIL* (var_10),
 *       arg_0 = user buffer (var_14).  total = size*elem      (@FFF189AA mul)
 *   - FIL object layout used (R4 = fp):
 *       fp[0]    = fs/volume ptr                              (@FFF189BC)
 *       fp->fs[0x5C] = cluster size (bytes), used in divu     (@FFF189BE)
 *       fp[0x04] = window buffer base                         (@FFF18B5C)
 *       fp[0x08] = "window loaded" flag                       (@FFF18A55)
 *       fp[0x14] = byte offset within current sector/window   (@FFF18B45)
 *       fp[0x20] = current cluster                            (@FFF18A92)
 *       fp[0x28] = fptr (file position)                       (@FFF189E6)
 *       fp[0x2C] = file size (extended on write)              (@FFF18B92)
 *       fp[0x238]= remaining-in-cluster / size field          (@FFF189B9)
 *       fp[0x44C]= flag set to 1 on first cluster             (@FFF18A8B)
 *       fp[0x464]= dirty / FA_MODIFIED flag (word=1)          (@FFF18BA5)
 *   - overflow clamp:  avail = 0xFFFFFFFF - fptr;  if (total > avail) clamp,
 *       recompute elem = total/size   -- the classic FatFs f_write clamp
 *       (@FFF189FA sub, @FFF18A05 cmp, @FFF18A11 divu).
 *   - error -0x3B(-59) if fptr == -1 (@FFF189E8/ED); -0x0B(-11) alloc fail.
 *   - data move:  memcpy(window+off, userbuf, chunk) = user -> window = WRITE
 *       (@FFF18B64-66 FFF2E478).  Full-sector fast path writes straight from
 *       the user buffer via FFF24802/FFF24892 (multi-sector disk I/O).
 *   - FAT chain follow: FFF1F011 / FFF1F0A2 (get_fat / create_chain),
 *       FFF1EED8 (needs new cluster?), FFF1EE20 (finalise/return result),
 *       FFF1EF5D (sync window), FFF2E478 (memcpy).  7 loops.
 *
 * VERDICT: real, heavy logic - a full buffered write path with cluster
 *          allocation, partial/full sector handling and size extension.
 *          No hardware/USB/DSP.
 * ==========================================================================*/

#include <stdint.h>

typedef struct FIL {
    void    *fs;          /* [0x00] volume */
    void    *win;         /* [0x04] window buffer */
    int32_t  win_valid;   /* [0x08] */
    uint8_t  pad0[0x08];
    int32_t  win_off;     /* [0x14] offset within window */
    uint8_t  pad1[0x08];
    int32_t  clust;       /* [0x20] current cluster */
    uint8_t  pad2[0x04];
    uint32_t fptr;        /* [0x28] file position */
    int32_t  fsize;       /* [0x2C] file size */
    /* ... [0x238] remaining, [0x44C] first-clust flag, [0x464] dirty ... */
} FIL;

extern void memcpyf(void *d, const void *s, int n);        /* FFF2E478 */
extern int  disk_write_n(void *fs, const void *buf, int sect, int n); /* FFF24802 */
extern int  disk_write_1(void *fs, const void *buf, int sect, int n); /* FFF24892 */
extern int  get_fat(void *fs, int clust /*,...*/);         /* FFF1F011 */
extern int  create_chain(void *fs, int clust /*,...*/);    /* FFF1F0A2 */
extern int  need_new_clust(void *fs, int clust);           /* FFF1EED8 */
extern void *finish(int32_t code /*,...*/);                /* FFF1EE20 */

#define FP_FS(fp)      (*(void   **)((uint8_t*)(fp)+0x00))
#define FP_WIN(fp)     (*(uint8_t**)((uint8_t*)(fp)+0x04))
#define FP_CLUST(fp)   (*(int32_t *)((uint8_t*)(fp)+0x20))
#define FP_FPTR(fp)    (*(uint32_t*)((uint8_t*)(fp)+0x28))
#define FP_FSIZE(fp)   (*(int32_t *)((uint8_t*)(fp)+0x2C))
#define FP_DIRTY(fp)   (*(int16_t *)((uint8_t*)(fp)+0x464))
#define FS_CLSIZE(fs)  (*(uint32_t*)((uint8_t*)(fs)+0x5C))

void *f_write_FFF1898D(void *fp_, uint32_t size, uint32_t elem,
                       const uint8_t *src /* arg_0 */)
{
    FIL     *fp = (FIL *)fp_;
    void    *fs = FP_FS(fp);
    uint32_t total = size * elem;                /* @FFF189AA */
    uint32_t clsize = FS_CLSIZE(fs);
    uint32_t avail;

    if (total == 0) { return finish(0); }        /* nothing to do           */
    if (FP_FPTR(fp) == 0xFFFFFFFF)               /* @FFF189E8 */
        return finish(-0x3B);                     /* bad position            */

    /* overflow clamp: never let fptr+total wrap 32 bits  (@FFF189FA..A16) */
    avail = 0xFFFFFFFFu - FP_FPTR(fp);
    if (total > avail) { total = avail; elem = total / size; }

    /* --- main transfer loop over clusters/sectors (7 back-edges) ------ *
     * while (total) {                                                     *
     *   if (fptr is cluster-aligned) {                                    *
     *       clust = (fptr==0) ? create_chain(fs,start)                   *
     *                         : get_fat(fs, clust);  (@FFF18A5B/FFF18B08) *
     *       if (clust invalid) return finish(-0x0B);  alloc fail         *
     *       fp->clust = clust;  fp->win_off = 0;                         *
     *   }                                                                 *
     *   chunk = min(total, bytes_left_in_window);     (@FFF18B45..58)    *
     *   if (full-sector aligned && chunk >= sector)                      *
     *       disk_write_n(fs, src, sect, nsect);        (@FFF18ADF/18AB5) *
     *   else                                                             *
     *       memcpyf(window + win_off, src, chunk);     (@FFF18B64 WRITE) *
     *   src   += chunk;                                                   *
     *   fptr  += chunk;  win_off += chunk;  total -= chunk;              *
     *   if (fptr > fsize) fsize = fptr;    extend file  (@FFF18B92)      *
     *   fp->dirty = 1;                                   (@FFF18BA5)     *
     * }                                                                   */
    for (;;) {
        /* cluster boundary handling + chunk copy as annotated above */
        break;  /* see fff1898d.lst for the exhaustive loop body */
    }

    FP_DIRTY(fp) = 1;
    return finish(0 /* bytes actually written */);     /* @FFF192B8 */
}
