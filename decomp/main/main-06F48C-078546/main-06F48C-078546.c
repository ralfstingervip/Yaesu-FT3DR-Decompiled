/* ============================================================================
 * main-06F48C-078546.c  -  Wave C hand reconstruction, MAIN H8SX 06F48C-078546
 *
 * DOCUMENTATION ONLY: by-hand transcription of the IDA listing chunk
 * (decomp/tools/build_listings.py output) plus the binutils oracle
 * (ida/out/h8s-decode/work/bu_all.tsv) for bytes that are not in a function.
 * Big-endian, base 0, file offset == address.  Not compiled.
 *
 * Subsystems in this range (address order):
 *   06F48C-070146  SD / file-server client: QSO store defaults, QSO list paging,
 *                  BACKUP / MEMORY-CH "Write to SD / Read from SD" menu,
 *                  SD task state machine FFBA30, card mount + file probes
 *   07015A-07131E  SD substates, step dispatcher off_703E6, voice recorder,
 *                  GPS log, SD request posters, request builder sub_71196
 *   071326-073030  ROM: SD request templates (name at +0x56)
 *   073030-073412  SD job gate, Bluetooth link FSM (doc 124)
 *   073412-073B62  SCO hold, clone / extension port (doc 24), node parser
 *   073B6C-074472  DATA-jack node-command handlers off_74472 (doc 104)
 *   074562-0750C2  BACKUP.dat / MEMORY.dat writer + reader (pc-02)
 *   0750C2-075F34  restore apply hooks: per-destination channel conversion
 *   075F36-078105  H8SX-compiled USB function-module (CDC-ACM) service code
 *                  and edit-list helpers (doc 36/42/119)
 *   078106-078545  service window code (doc 95): CDC init/ISR/rings/SCI-C
 *
 * Register model: this code mostly passes values in r4/er5/er6 and returns
 * flags/r4l (hand-tuned or older compiler idioms); where a routine's ABI is
 * non-standard the header says so.  "Z" results are written as return values.
 * Globals are declared in the EXTERNS block below; addresses in comments.
 * ========================================================================== */
#include <stdint.h>
#include <string.h>
typedef uint8_t u8; typedef uint16_t u16; typedef uint32_t u32;
typedef int8_t s8; typedef int16_t s16; typedef int32_t s32;
struct screen { u8 b0; u8 id; };           /* er0 screen record, +1 = screen id */
struct rec;                                /* per-band VFO / channel record     */

/* ---------------------------- EXTERNS ------------------------------------ *
 * (see globals.tsv for width, meaning and evidence of each cell)            */
extern u8  sd_task_state;      /* FFBA30  b7 = request pending, low = state 0..5 */
extern u8  sd_card_state;      /* FFBA32  0 none, 2/3 card ready (reply +0x0C)   */
extern u8  backup_dat_ok;      /* FFBA41  BACKUP.dat size == 0x1FDC0             */
extern u8  memory_dat_ok;      /* FFBA42  MEMORY.dat size == 0xAC80              */
extern u8  sd_BA43, sd_BA44;   /* FFBA43/44 cleared with the above               */
extern u8  qso_store_kind;     /* FFBA45  0 msg, >0 picture, <0 voice            */
extern u32 camera_jpeg_size_BA46; /* FFBA46                                      */
extern u8  sd_scratch_BA4A[16];/* FFBA4A                                         */
extern u8  sd_photo_name_BA5A[16]; /* FFBA5A  "<stem>.jpg"                       */
extern u32 sd_sum_BA7A;        /* FFBA7A  running additive sum (BACKUP/MEMORY)   */
extern u16 sd_req_len_BA86;    /* FFBA86  request total length                   */
extern const u8 *sd_req_tmpl;  /* FFBA88  request template pointer               */
extern u16 sd_req_seq;         /* FFBA8C  request sequence 1..0xFF               */
extern u8  sd_rx_flags_BA92;   /* FFBA92  b0 FE reply, b1 EA, b2 E4, b3 E6, b4 E5*/
extern u8  qso_flags_BA93;     /* FFBA93  b0 polling, b1/b2 SD job, b6 list busy */
extern u32 sd_req_length;      /* FFBA96  -> request +0x76                       */
extern u32 sd_req_offset;      /* FFBA9A  -> request +0x7A                       */
extern u8  sd_req_op;          /* FFBA9E  -> +0x10 op code                       */
extern u8  sd_req_param;       /* FFBA9F  -> +0x12                               */
extern u8  sd_req_dir;         /* FFBAA0  -> +0x14 directory index               */
extern u8  sd_substate;        /* FFBAA1  off_7031E index                        */
extern u8  sd_probe_step;      /* FFBAA2  off_70118 index                        */
extern u8  sd_next_step;       /* FFBAA3  off_703E6 continuation index           */
extern u8  sd_last_step;       /* FFBAA4                                         */
extern u8  qso_fat_window;     /* FFBAA5                                         */
extern u8  sd_probe_retries;   /* FFBAA7                                         */
extern u8  sd_req_name[32];    /* FFBAC2  -> +0x56 file name                     */
extern u8  sd_req_namelen;     /* FFBAD4                                         */
extern u8  voicerec_state;     /* FFBAD6                                         */
extern u8  ea_payload;         /* FFBAD7  EA frame payload (doc 108)             */
extern u8  sd_reply_payload[]; /* FF509E  reply data (= FF5006 + 0x98)           */
extern u16 sd_reply_status;    /* FF5014  reply +0x0E, non-zero = error          */
extern struct { u8 pad0[0x0C]; u16 card_0C; u8 pad1[0x0A]; u16 event_18;
                u8 pad2[0x64]; u32 file_size; } sd_reply; /* FF5006, +0x7E size  */
extern u8  popup_id;           /* FFBBE1  popup channel                          */
extern u8  tone_event;         /* FFAAE0  tone mailbox (0x1D error)              */
extern u8  key_event;          /* FFA9ED  key cell                               */
extern u8  redraw_flags_817E;  /* FF817E  b1 = redraw                            */
extern u8  band_sel_8EA0;      /* FF8EA0  b6 band B selected, b7 dual            */
extern u8  bandA_mode_8D20, bandB_mode_8DD5; /* digital mode bytes               */
extern u8  tx_state;           /* FF94C0  0 idle, 1 TX, 2 blocked                */
extern u8  picture_busy;       /* FF2EC9                                         */
extern u8  remote_mode_8004;   /* FF8004                                         */
extern u8  market_800F, market_8010, market_8011; /* destination bytes (doc 96) */
/* ... remaining cells are named inline (suffix = address) and listed in
 *     globals.tsv; ROM_xxxxxx / TMPL_xxxxxx are ROM tables at that address. */
/* ************************************************************************** *
 * PART 1  06F48C-070146 : QSO-store defaults, QSO list paging over the SD
 *         file server, BACKUP/MEMORY "Write to SD / Read from SD" menu,
 *         SD task (FFBA30) states 0..5, card-mount + file-size probes.
 * ************************************************************************** */

/* ------------------------------------------------------------------------ *
 * 06F48C-06F4A6  size 26   wavmng_load_defaults   (sub_6F48C)   Confirmed
 * Copies the 16-byte WAVMNG.dat default block (06F4A6: 16 x FF, i.e. "index
 * 0xFFFF = empty") into the voice-store management image FF304A.
 * ------------------------------------------------------------------------ */
void wavmng_load_defaults(void)                        /* 06F48C */
{
    memcpy(wavmng_img, ROM_WAVMNG_DEFAULT_06F4A6, 0x10); /* eepmov 0x10 */
}

/* ------------------------------------------------------------------------ *
 * 06F4C6-06F4E0  size 26   qso_dirrec_load_default   (sub_6F4C6)   Confirmed
 * Copies the 128-byte default QSO*DIR record template (06F534, pc-02 sec.4:
 * 4x00, 42x20, 18x00, 16x20, 4x00, 16x20, 20xFF, 8x00) into FF2ECA.
 * Caller 06541C.  NB: the template's tail 06F586-06F5B3 is what IDA decoded
 * as the head of "sub_6F586" (doc 129 row 95).
 * ------------------------------------------------------------------------ */
void qso_dirrec_load_default(void)                     /* 06F4C6 */
{
    memcpy(qso_dirrec_a, ROM_DIRREC_TEMPLATE_06F534, 0x80);
}

/* ------------------------------------------------------------------------ *
 * 06F4E0-06F512  size 50   qso_dirrec_load_default_split (sub_6F4E0) Confirmed
 * Same template, but only bytes 0..0x39 go to FF2ECA; then 0x40 bytes from
 * 06F574 (a 17-char string head + following template bytes) go to FF2F0A.
 * ------------------------------------------------------------------------ */
void qso_dirrec_load_default_split(void)               /* 06F4E0 */
{
    memcpy(qso_dirrec_a,          ROM_DIRREC_TEMPLATE_06F534, 0x3A);
    memcpy(qso_dirrec_a + 0x40,   ROM_06F574,                 0x40); /* FF2F0A */
}

/* ------------------------------------------------------------------------ *
 * 06F512-06F534  size 34   pct_dirrec_begin   (sub_6F512)   Confirmed
 * Marks a picture operation in progress (FF2EC9 = 1) and loads the 128-byte
 * default record into the picture DIR record buffer FF2F4A.  Called by the
 * USB 41 D1 "start of image" handler (055478) before sub_6A700 (doc 53/64).
 * ------------------------------------------------------------------------ */
void pct_dirrec_begin(void)                            /* 06F512 */
{
    picture_busy = 1;                                  /* FF2EC9 */
    memcpy(pct_dirrec, ROM_DIRREC_TEMPLATE_06F534, 0x80);
}

/* ------------------------------------------------------------------------ *
 * 06F586-06F6A4  size 286  key14_open_last_picture  (sub_6F586)  Confirmed
 *   real entry 06F5B4 (06F586-06F5B3 is template data, see above); second
 *   entry 06F5D0 = key index 0x0B handler (raw key 0x14, USB 41 D3, doc 74);
 *   third entry 06F656 = SD continuation step 0x25 (off_703E6[37]).
 * 06F5B4: if popup flag BBF2.2 is set the key only dismisses the popup
 * (BBE1 = 0) and falls into 06F5D0; otherwise it is the invalid-key stub.
 * 06F5D0: operating band must be digital, SD card ready (FFBA32 != 0) and no
 * picture op running (FF2EC9 == 0).  Fetch the last-picture 12-byte stem,
 * reject 0xFFFFFFFF, build "<stem>.jpg" in FFBA5A and post an SD "get size"
 * request for \PHOTO\<stem>.jpg (sd_post_photo_stat).  Next SD step = 0x25.
 * 06F656 (reply): if the server returned OK and a non-zero size (+0x7E),
 * copy the picture DIR record FF2F4A -> FF2FCA, call sub_5EE14 and, if it
 * returns Z, set picture_busy and start the picture send (sub_6A610).
 * CORRECTION to doc 74: FFBA32 is the SD-card state written by the card-mount
 * handler sd_state_mount_wait (06FE5E stores reply +0x0C = 2/3), not a
 * "picture on-screen" flag; doc 74's gate reading should be "card ready".
 * ------------------------------------------------------------------------ */
void key14_open_last_picture(void)                     /* 06F5B4 */
{
    if (popup_flags_BBF2 & 0x04) {                     /* 06F5B4 */
        if (popup_id) popup_id = 0;                    /* 06F5BC: BBE1      */
        goto key14;                                    /* 06F5C8            */
    }
    key_invalid();                                     /* 06F5CA sub_3FFA0  */
    return;
key14:                                                 /* 06F5D0            */
    {
        u8 m = (band_sel_8EA0 & 0x40) ? bandB_mode_8DD5 : bandA_mode_8D20;
        if (m == 0 || sd_card_state == 0 || picture_busy != 0) {
            key_invalid(); return;                     /* 06F69E            */
        }
        last_picture_stem_fetch(0);                    /* 06F5FA sub_3DD98(r3l=0) -> FF2F9E */
        memcpy(sd_scratch_BA4A, last_pic_stem_2F9E, 12);
        if (*(u32 *)sd_scratch_BA4A == 0xFFFFFFFF) { key_invalid(); return; }
        memcpy(sd_photo_name_BA5A, sd_scratch_BA4A, 12);
        *(u32 *)(sd_photo_name_BA5A + 12) = 0x2E6A7067; /* ".jpg"  06F640    */
        sd_post_photo_stat();                          /* 06F64A sub_708B6  */
        sd_next_step = 0x25;                           /* 06F64E FFBAA3     */
    }
}
void sd_step25_photo_stat_reply(void)                  /* 06F656 (BAA3=0x25) */
{
    sd_next_step = 0;
    if (sd_reply_status != 0) { key_invalid(); return; }        /* FF5014   */
    if (sd_reply.file_size == 0) { key_invalid(); return; }     /* FF5006+7E*/
    memcpy(pct_dirrec_copy_2FCA, pct_dirrec, 0x80);    /* 06F672            */
    if (sub_5EE14() == 0) {                            /* 06F68A (Z set)    */
        picture_busy = 1;                              /* 06F690            */
        picture_send_start();                          /* 06F698 sub_6A610  */
    }
}

/* ------------------------------------------------------------------------ *
 * 06F6E2-06F6EC  size 10 (+tail 06F786-06F795)  qso_fat_window_ptr
 *   (sub_6F6E2)  Confirmed (tail read from the binutils oracle)
 * Returns, in er5 / r6l, the pointer to the last FAT entry of interest in the
 * SD reply payload FF509E and the number of entries to walk backwards:
 *   window flag BAA5 == 0 : er5 = FF509E + 4*cur_index, r6l = cur_index + 1
 *   BAA5 != 0 (30-entry window) : er5 = FF509E + 0x74, r6l = 0x1E.
 * Register-returning helper (non-standard ABI: er5/r6 out).
 * ------------------------------------------------------------------------ */
struct fatwin { u32 *last; u8 count; };
struct fatwin qso_fat_window_ptr(void)                 /* 06F6E2 */
{
    struct fatwin w;
    if (qso_fat_window != 0) {                         /* BAA5              */
        w.last = (u32 *)(sd_reply_payload + 0x74);     /* 06F786            */
        w.count = 0x1E;                                /* 06F792            */
    } else {
        w.last = (u32 *)sd_reply_payload + qso_cur_index; /* 06F730 B956    */
        w.count = (u8)(qso_cur_index + 1);
    }
    return w;
}

/* ------------------------------------------------------------------------ *
 * 06F6EC-06F786  size 154  qso_fat_read_window   (sub_6F6EC)   Confirmed
 * Requests the slice of QSO*FAT.dat (4-byte entries) that ends at record
 * qso_cur_index (B956): if index < 30 read entries 0..index (offset 0,
 * len 4*(index+1), window flag 0); else read the 30 entries ending at index
 * (offset 4*(index-29), len 0x78, window flag 1).  The FAT file is chosen
 * by the store kind BA45: 0 = message (sd_post_qsomsgfat_read), >0 = picture
 * (sd_post_qsopctfat_read), <0 = voice (sd_post_qsowavfat_read).
 * ------------------------------------------------------------------------ */
void qso_fat_read_window(void)                         /* 06F6EC */
{
    u16 i = qso_cur_index;                             /* B956 */
    if (i < 0x1E) {
        sd_req_offset = 0;                             /* BA9A */
        sd_req_length = 4u * (i + 1);                  /* BA96 */
        qso_post_fat_read();
        qso_fat_window = 0;                            /* BAA5 */
    } else {
        sd_req_offset = 4u * (u16)(i - 0x1D);
        sd_req_length = 0x78;
        qso_post_fat_read();
        qso_fat_window = 1;
    }
}
/* the three-way pick used above (and by 06FA08) */
static void qso_post_fat_read(void)
{
    if ((s8)qso_store_kind < 0)  sd_post_qsowavfat_read(); /* sub_70CD2 */
    else if (qso_store_kind)     sd_post_qsopctfat_read(); /* sub_70BD4 */
    else                         sd_post_qsomsgfat_read(); /* sub_70E2A */
}

/* ------------------------------------------------------------------------ *
 * 06F796-06F816  size 128  qso_list_open_page   (sub_6F796)   Confirmed
 * Clears the 20-entry visible-record table B92E (10 longs).  On the first
 * page (B928 == 0) it resets B95C and seeds B95A with (mng index - 1) taken
 * from the management block of the current store (FEEF00 msg / FEEF10 pct /
 * FF304A wav).  Then cur_index = B95A, saves the walk context (er1 = index,
 * er2 = B92E, er3 = 0) in BAB2/BAB6/BABA for the asynchronous continuation,
 * requests the FAT window and sets SD step 0x0E (qso_list_collect_step).
 * ------------------------------------------------------------------------ */
void qso_list_open_page(void)                          /* 06F796 */
{
    memset(qso_vis_tab, 0, 0x28);                      /* B92E, 10 x u32    */
    if (qso_page_no == 0) {                            /* B928              */
        qso_page_no = 0;
        qso_B95C = 0;
        u16 n = ((s8)qso_store_kind < 0) ? wavmng_img_idx /* FF304A */
              : qso_store_kind ? qsomng_pct_idx        /* FEEF10 */
              :                  qsomng_msg_idx;       /* FEEF00 */
        qso_page_top = n - 1;                          /* B95A              */
    }
    qso_cur_index = qso_page_top;                      /* B956              */
    ctx_er1 = qso_page_top; ctx_er2 = (u32)qso_vis_tab; ctx_er3 = 0; /* BAB2/6/A */
    qso_fat_read_window();
    sd_next_step = 0x0E;
}

/* ------------------------------------------------------------------------ *
 * 06F816-06F89C  size 134  qso_list_collect_step   (sub_6F816)   Confirmed
 * SD step 0x0E.  Walks the returned FAT entries backwards (newest first):
 * every entry whose top bit is clear (entry in use) has its record number
 * stored into the visible table (the first one also into B958) until 20
 * (0x14) are collected.  If the window is exhausted before index 0 it reads
 * the previous window (loops back into 06F7F8 = re-post).  At the end
 * B95D/B95A record whether more pages exist, B92A = count (or 0xFF = none:
 * also clears BA93.6 and arms timer 9567 = 10), and with count > 0 it goes on
 * to read the DIR records (qso_dir_read_batch).
 * ------------------------------------------------------------------------ */
void qso_list_collect_step(void)                       /* 06F816 */
{
    sd_next_step = 0;
    struct fatwin w = qso_fat_window_ptr();
    u16 rec = ctx_er1; u16 *out = (u16 *)ctx_er2; u8 n = (u8)ctx_er3;
    u32 *e = w.last; u8 left = w.count;
    for (;;) {
        if (!(*(u8 *)e & 0x80)) {                      /* 06F832 entry used */
            *out++ = rec;
            if (n == 0) qso_first_rec = rec;           /* B958              */
            if (++n >= 0x14) {                         /* page full         */
                if (rec == 0) { qso_more = 0; break; }
                rec--; qso_more = 0xFF;                /* B95D              */
                qso_page_top = rec;                    /* B95A (via e3)     */
                break;
            }
        }
        e--;
        if (rec == 0) { qso_more = 0; break; }        /* 06F878            */
        rec--;
        if (--left == 0) {                             /* need older window */
            qso_cur_index = rec;
            ctx_er1 = rec; ctx_er2 = (u32)out; ctx_er3 = n;
            qso_fat_read_window(); sd_next_step = 0x0E; /* 06F7F8 path     */
            return;
        }
    }
    if (n == 0) {                                      /* 06F880            */
        qso_flags_BA93 &= ~0x40;
        timer_9567 = 0x0A;
        n = 0xFF;
    }
    qso_vis_count = n;                                 /* B92A              */
    if ((s8)n >= 0) qso_dir_read_batch(n);             /* bsr 06F89C        */
}

/* ------------------------------------------------------------------------ *
 * 06F89C-06F8F6  size 90   qso_dir_read_batch   (sub_6F89C)   Confirmed
 * r3l = number of records.  For the next record number in the table B92E
 * read 0x80 bytes of QSO*DIR.dat at offset rec*0x80 into the list buffer
 * walk (destination FEEF20, saved in BAB6).  Kind selects
 * sd_post_qsomsgdir_read / qsopctdir / qsowavdir.  Next SD step 0x0F.
 * ------------------------------------------------------------------------ */
void qso_dir_read_batch(u8 count)                      /* 06F89C */
{
    u16 *src = qso_vis_tab; u8 *dst = qso_list_buf_EF20; /* FEEF20 */
    /* 06F8AA is also the loop head re-entered from qso_dir_store_step     */
    sd_req_offset = (u32)(*src++) * 0x80;              /* BA9A              */
    sd_req_length = 0x80;                              /* BA96              */
    ctx_er1 = (u32)src; ctx_er2 = (u32)dst; ctx_er3 = count;
    if ((s8)qso_store_kind < 0) sd_post_qsowavdir_read();   /* sub_70CB0 */
    else if (qso_store_kind)    sd_post_qsopctdir_read();   /* sub_70BB2 */
    else                        sd_post_qsomsgdir_read(0);  /* sub_70DA2 */
    sd_next_step = 0x0F;
}

/* ------------------------------------------------------------------------ *
 * 06F8F6-06F942  size 76   qso_dir_store_step   (sub_6F8F6)   Confirmed
 * SD step 0x0F.  Copies the 0x80-byte DIR record from the reply payload to
 * the list buffer, advances, and loops back into qso_dir_read_batch's body
 * (06F8AA) until all records are read; then requests a redraw (817E.1),
 * clears BA93.6 and arms timer 9567 = 10.
 * ------------------------------------------------------------------------ */
void qso_dir_store_step(void)                          /* 06F8F6 */
{
    sd_next_step = 0;
    u8 *dst = (u8 *)ctx_er2; u8 n = (u8)ctx_er3;
    memcpy(dst, sd_reply_payload, 0x80);
    if (--n) { ctx_er2 = (u32)(dst + 0x80); /* er1 still = next src */
               goto_06F8AA(ctx_er1, dst + 0x80, n); return; }
    redraw_flags_817E |= 0x02;
    qso_flags_BA93 &= ~0x40;
    timer_9567 = 0x0A;
}

/* ------------------------------------------------------------------------ *
 * 06F942-06F970  size 46   qso_list_scroll_back_begin   (sub_6F942) Confirmed
 * Marks the list busy (BA93.6, timer 9567 = 25), saves context with
 * er1 = cur_index and requests the FAT window; next SD step 0x26
 * (qso_list_step_prev, off_703E6[38]).
 * ------------------------------------------------------------------------ */
void qso_list_scroll_back_begin(void)                  /* 06F942 */
{
    qso_flags_BA93 |= 0x40;  timer_9567 = 0x19;
    ctx_er1 = qso_cur_index;  /* er2/er3 saved as they come in */
    qso_fat_read_window();
    sd_next_step = 0x26;
}

/* ------------------------------------------------------------------------ *
 * 06F970-06F9E4  size 116  qso_list_step_prev   (sub_6F970)   Confirmed
 * SD steps 0x26/0x28/0x29.  Walks the FAT window backwards looking for the
 * previous used entry.  Found: B95D = 1, ++page_no (B928), then dispatches
 * through off_6F9E4[kind_list B92D] (064D50 / 064A70 / 064F34, the
 * message / picture / voice list screens).  Index reaches 0 with nothing
 * found: B95D = 0 and dispatch through off_6F9FC (064D68/064AB6/064F5E).
 * Window exhausted: re-read the previous window (back to 06F94E).
 * ------------------------------------------------------------------------ */
void qso_list_step_prev(void)                          /* 06F970 */
{
    sd_next_step = 0;
    struct fatwin w = qso_fat_window_ptr();
    u16 rec = ctx_er1; u32 *e = w.last; u8 left = w.count;
    for (;;) {
        if (!(*(u8 *)e & 0x80)) {                      /* 06F98E bpl        */
            qso_more = 1; qso_page_no++;               /* 06F9BE            */
            off_6F9E4[qso_list_kind_B92D]();           /* jmp @er6          */
            return;
        }
        e--;
        if (rec == 0) {                                /* 06F9A2            */
            qso_more = 0;
            off_6F9FC[qso_list_kind_B92D]();
            return;
        }
        rec--;
        if (--left == 0) { qso_cur_index = rec; qso_list_scroll_back_begin_06F94E(); return; }
    }
}

/* ------------------------------------------------------------------------ *
 * 06FA08-06FAC2  size 186  qso_list_scroll_fwd_begin   (sub_6FA08) Confirmed
 * Forward paging: start at B958 + 1 (record after the newest shown), read up
 * to 30 FAT entries (fewer if the management count r3 is reached; then
 * BAAC = 1 "last window").  Count in BAA6.  Next SD step 0x27.
 * ------------------------------------------------------------------------ */
void qso_list_scroll_fwd_begin(void)                   /* 06FA08 */
{
    qso_flags_BA93 |= 0x40;  timer_9567 = 0x19;
    u8 n = 0;
    qso_fwd_last = 0;                                  /* BAAC (e1)         */
    qso_fwd_start = qso_first_rec + 1;                 /* BAAA              */
again:                                                 /* 06FA28            */
    {
        u16 end = qso_fwd_start + 0x1D;
        qso_fwd_count = 0x1E;                          /* BAA6              */
        u16 total = ((s8)qso_store_kind < 0) ? wavmng_img_idx
                  : qso_store_kind ? qsomng_pct_idx : qsomng_msg_idx;
        if (end >= total) {                            /* 06FA56            */
            qso_fwd_last = 1;
            qso_fwd_count = (u8)(total - qso_fwd_start);
        }
        ctx_er1 = end; ctx_er3 = n;                    /* er2 untouched     */
        sd_req_offset = 4u * qso_fwd_start;
        sd_req_length = 4u * qso_fwd_count;
        qso_post_fat_read();
        sd_next_step = 0x27;
    }
}

/* ------------------------------------------------------------------------ *
 * 06FAC2-06FB42  size 128  qso_list_step_next   (sub_6FAC2)   Confirmed
 * SD step 0x27.  Scans the returned window forwards for a used entry; on
 * hit at count r3l >= 20 (0x14) ... (see code) stores B95A = record,
 * --page_no and dispatches off_6F9E4[B92D].  Window exhausted: if BAAC (last
 * window) dispatch off_6F9F0[B92D] (064D22/064A42/064F06, "no newer
 * entries"), else read the next window (06FA28).
 * ------------------------------------------------------------------------ */
void qso_list_step_next(void)                          /* 06FAC2 */
{
    sd_next_step = 0;
    u8 *e = sd_reply_payload; u8 left = qso_fwd_count;
    u16 rec = qso_fwd_start; u8 n = (u8)ctx_er3;
    while (left--) {
        if (!(*e & 0x80) && ++n >= 0x14) {             /* 06FAEA..06FAF0    */
            qso_page_top = rec;                        /* 06FB08 B95A       */
            qso_page_no--;
            off_6F9E4[qso_list_kind_B92D]();
            return;
        }
        e += 4; rec++;
    }
    if (qso_fwd_last) { off_6F9F0[qso_list_kind_B92D](); return; } /* 06FB2C */
    qso_fwd_start = rec;  /* and back to 06FA28 */
    /* goto again (inside qso_list_scroll_fwd_begin) */
}

/* ------------------------------------------------------------------------ *
 * 06FB42 / 06FB66  size 36 each   sdmenu_reset_item1 / sdmenu_reset_item2
 *   (sub_6FB42 / sub_6FB66)   Confirmed
 * BACKUP / MEMORY-CH "Write to SD / Read from SD" menu reset: selected item
 * B3F4 = cursor B3F5 = 1 (or 2), clear the 17-byte buffer B482, leave the
 * confirm stage (B3F3 = 0).
 * ------------------------------------------------------------------------ */
void sdmenu_reset_item1(void)                          /* 06FB42 */
{
    sdmenu_sel = 1; sdmenu_cursor = 1;                 /* B3F4, B3F5        */
    memset(sdmenu_buf_B482, 0, 0x11);
    sdmenu_confirm = 0;                                /* B3F3              */
}
void sdmenu_reset_item2(void)                          /* 06FB66 */
{
    sdmenu_sel = 2; sdmenu_cursor = 2;
    memset(sdmenu_buf_B482, 0, 0x11);
    sdmenu_confirm = 0;
}

/* 06FB8A-06FB90  size 6   sdmenu_enter_confirm_thunk (sub_6FB8A) Confirmed */
void sdmenu_enter_confirm_thunk(void) { sdmenu_enter_confirm(); } /* 06FB8A */

/* ------------------------------------------------------------------------ *
 * 06FB90-06FBBC  size 44   sdmenu_dial_backup   (sub_6FB90)   Confirmed
 * DIAL step on the BACKUP screen.  Only when sub_151EC() reports an
 * editable screen (AD68 == 0 path).  In the confirm stage the cursor B3F5
 * cycles 1..2 (record 06FBC2 {1,2,&B3F5}) and the confirm popup is
 * refreshed (sdmenu_popup_confirm); otherwise it cycles via record 06FBBC
 * and the new value is also the selected item B3F4.
 * ------------------------------------------------------------------------ */
void sdmenu_dial_backup(void)                          /* 06FB90 */
{
    if (!screen_editable_151EC()) return;
    if (sdmenu_confirm) {
        menu_value_cycle(&REC_06FBC2);                 /* sub_3F62E         */
        sdmenu_popup_confirm();                        /* sub_6FBEA         */
    } else {
        sdmenu_sel = menu_value_cycle(&REC_06FBBC);    /* r3l -> B3F4       */
    }
}

/* ------------------------------------------------------------------------ *
 * 06FBC8-06FBE2  size 26   sdmenu_dial_simple   (sub_6FBC8)   Confirmed
 * As above, but only when sd_job_blocked() returns 0; cycles 06FBC2
 * and shows the "0x40+cursor" popup (sdmenu_popup_select).
 * ------------------------------------------------------------------------ */
void sdmenu_dial_simple(void)                          /* 06FBC8 */
{
    if (!screen_editable_151EC()) return;
    if (sd_job_blocked() != 0) return;
    menu_value_cycle(&REC_06FBC2);
    sdmenu_popup_select();
}

/* ------------------------------------------------------------------------ *
 * 06FBE2-06FBE6 size 4  sdmenu_popup_D0   (sub_6FBE2)     Confirmed
 * 06FBE6-06FC04 size 30 sdmenu_popup_select (sub_6FBE6) Confirmed, second
 *   entry 06FBEA = sdmenu_popup_confirm.
 * popup_id (BBE1) = base + cursor(B3F5); base 0xD0, 0x40, or for the
 * confirm popup 0xB0 when the chosen op B3F6 == 1 (write) else 0xC0 (read).
 * ------------------------------------------------------------------------ */
void sdmenu_popup_D0(void)      { popup_id = 0xD0 + sdmenu_cursor; } /* 06FBE2 */
void sdmenu_popup_select(void)  { popup_id = 0x40 + sdmenu_cursor; } /* 06FBE6 */
void sdmenu_popup_confirm(void)                        /* 06FBEA */
{
    u8 base = (sdmenu_op == 1) ? 0xB0 : 0xC0;          /* B3F6              */
    popup_id = base + sdmenu_cursor;
}

/* ------------------------------------------------------------------------ *
 * 06FC04-06FC38  size 52   sdmenu_enter_backup   (sub_6FC04)   Confirmed
 * ENTER on the BACKUP item.  No item -> invalid key.  Already confirming ->
 * cancel (sdmenu_cancel).  Needs a ready card (BA32); item 2 (read from SD)
 * additionally needs BACKUP.dat of the exact size (BA41, set by the 0x1FDC0
 * stat probe).  Then op B3F6 = item, enter confirm stage, show popup.
 * ------------------------------------------------------------------------ */
void sdmenu_enter_backup(void)                         /* 06FC04 */
{
    u8 it = sdmenu_sel;
    if (it == 0) { key_invalid(); return; }
    if (sdmenu_confirm) { sdmenu_cancel(); return; }
    if (sd_card_state == 0) { key_invalid(); return; }
    if (it != 1 && backup_dat_ok == 0) { key_invalid(); return; } /* BA41 */
    sdmenu_op = it;
    sdmenu_enter_confirm();
    sdmenu_popup_confirm();
}

/* 06FC38-06FC4A size 18  sdmenu_cancel (sub_6FC38) Confirmed:
 * error tone 0x1D, clear popup, reset menu (06FB42). */
void sdmenu_cancel(void)                               /* 06FC38 */
{
    tone_event = 0x1D;  popup_id = 0;  sdmenu_reset_item1();
}

/* 06FC4A-06FC7E size 52  sdmenu_enter_memory (sub_6FC4A) Confirmed:
 * identical to sdmenu_enter_backup but gated on MEMORY.dat size (BA42). */
void sdmenu_enter_memory(void)                         /* 06FC4A */
{
    u8 it = sdmenu_sel;
    if (it == 0) { key_invalid(); return; }
    if (sdmenu_confirm) { sdmenu_cancel(); return; }
    if (sd_card_state == 0) { key_invalid(); return; }
    if (it != 1 && memory_dat_ok == 0) { key_invalid(); return; } /* BA42 */
    sdmenu_op = it;
    sdmenu_enter_confirm();
    sdmenu_popup_confirm();
}

/* 06FC7E-06FC90 size 18  sdmenu_enter_confirm (sub_6FC7E) Confirmed:
 * B3F4 = B3F5 = 2 (cursor on "No"/second choice), B3F3 = 1. */
void sdmenu_enter_confirm(void)                        /* 06FC7E */
{
    sdmenu_sel = 2; sdmenu_cursor = 2; sdmenu_confirm = 1;
}

/* 06FC90  nullsub_70  rts */
void nullsub_70(void) { }                              /* 06FC90 */

/* ------------------------------------------------------------------------ *
 * 06FC94-06FCBA  size 38   sd_begin_stat_card   (sub_6FC94)   Confirmed
 * 06FC94: post a "0x50" request (sd_post_op50, card information) and set
 * SD step 1.  Second entry 06FCA0 = SD step 1 (off_703E6[1]): on reply,
 * error -> sd_card_error_popup (sub_70302) else jsr 070146 (sd_substate_start).
 * ------------------------------------------------------------------------ */
void sd_begin_stat_card(void)                          /* 06FC94 */
{
    sd_post_op50();                                    /* sub_708FC         */
    sd_next_step = 1;
}
void sd_step01_op50_reply(void)                        /* 06FCA0 */
{
    sd_next_step = 0;
    if (sd_reply_status == 0) sd_substate_start();     /* 070146            */
    else                      sd_card_error_popup();   /* sub_70302         */
}

/* ------------------------------------------------------------------------ *
 * 06FCBA-06FCF8  size 62   sdmenu_send_screen_cursor   (sub_6FCBA) Confirmed
 * Tells the SUB which line of the BACKUP (screen id 0x88 -> item frame
 * F3C0) or MEMORY-CH (other -> F3C1) screen is highlighted: r3l = op-1 in
 * the confirm stage, else cursor-1; when BA93.2 (SD job running) also shows
 * popup 3.  Sent with sub_976A (generic item-frame sender, doc 49).
 * ------------------------------------------------------------------------ */
void sdmenu_send_screen_cursor(struct screen *er0)     /* 06FCBA */
{
    u8 v;
    if (sdmenu_confirm) v = sdmenu_op - 1;
    else {
        v = sdmenu_cursor - 1;
        if (qso_flags_BA93 & 0x04) popup_id = 3;
    }
    sub_976A(er0->id == 0x88 ? 0xF3C0 : 0xF3C1, v);    /* e3 = opcode, r3l = v */
}

/* 06FCF8-06FD0C size 20  sd_send_busy_frame (sub_6FCF8) Confirmed:
 * popup 3 if BA93.2, then send the F301 item frame (loc_95C0:
 * FF3D72=0x2B, FF3D74=0xF301, FF3D76=0x21, jsr 7C20). */
void sd_send_busy_frame(void)                          /* 06FCF8 */
{
    if (qso_flags_BA93 & 0x04) popup_id = 3;
    send_item_F301_95C0();
}

/* ------------------------------------------------------------------------ *
 * 06FD0C-06FD56  size 74   sdmenu_screen_back   (sub_6FD0C)   Inferred
 * Leaving a sub-screen: if a popup is up (AA34.5) just close it (sub_5EA0C).
 * Else restore the previous screen id (ADA1 -> er0->id): 0x85 -> AD68 = 0 and
 * loc_4D92; 0x88/0x89 (BACKUP / MEMORY-CH) -> AD68 = 1, menu reset and
 * resend the cursor; any other -> AD68 = 1 and menu reset.
 * ------------------------------------------------------------------------ */
void sdmenu_screen_back(struct screen *er0)            /* 06FD0C */
{
    if (popup_flags_AA34 & 0x20) { popup_close_5EA0C(); return; }
    u8 id = prev_screen_ADA1;  er0->id = id;
    if (id == 0x85) { edit_mode_AD68 = 0; loc_4D92(); return; }
    edit_mode_AD68 = 1;
    sdmenu_reset_item1();
    if (id == 0x88 || id == 0x89) sdmenu_send_screen_cursor(er0);
}

/* 06FD56-06FD82 size 44  sdmenu_popup_back (sub_6FD56) Inferred:
 * clear the popup (AA34.5, timer 9538), restore er0->id from ADA1;
 * id 0x85 -> AD68 = 0, else AD68 = 1 and menu reset. */
void sdmenu_popup_back(struct screen *er0)             /* 06FD56 */
{
    popup_flags_AA34 &= ~0x20;  popup_timer_9538 = 0;
    u8 id = prev_screen_ADA1;  er0->id = id;
    if (id == 0x85) edit_mode_AD68 = 0;
    else { edit_mode_AD68 = 1; sdmenu_reset_item1(); }
}

/* ------------------------------------------------------------------------ *
 * 06FD82-06FDA2  size 32   sd_task   (sub_6FD82)   Confirmed
 * Main-loop tick of the SD/file-server client (ticks 0x2C0C/0x3812/0x3956,
 * doc 74).  First runs the Bluetooth link FSM (loc_73072, doc 124), then, unless a
 * request is still pending (BA30.7), dispatches on FFBA30 through off_6FDAA:
 *   0 sd_state_reset_start 06FDC2   1 sd_state_mount_wait 06FE02
 *   2 sd_state_card_info   06FECE   3 sd_state_idle       06FEF2
 *   4 sd_state_init_probe  06FF00   5 sd_state_substate   070130
 * ------------------------------------------------------------------------ */
void sd_task(void)                                     /* 06FD82 */
{
    bt_link_fsm();                                     /* loc_73072 */
    if (sd_task_state & 0x80) return;                  /* request in flight */
    off_6FDAA[sd_task_state]();
}

/* 06FDA2 nullsub_75 (rts);  06FDA4-06FDAA size 6 sd_reset_thunk (sub_6FDA4)
 * Confirmed: jsr sd_reset (sub_6FDD6). */
void nullsub_75(void) { }                              /* 06FDA2 */
void sd_reset_thunk(void) { sd_reset(); }              /* 06FDA4 */

/* 06FDC2-06FDD6 size 20  sd_state_reset_start (sub_6FDC2) Confirmed:
 * state 0.  BA93 = 0, BA8C = 1, timer 9555 = 0xEA, then falls into
 * sd_reset (06FDD6). */
void sd_state_reset_start(void)                        /* 06FDC2 */
{
    qso_flags_BA93 = 0;  sd_BA8C = 1;  sd_poll_timer_9555 = 0xEA;
    sd_reset();
}

/* 06FDD6-06FE02 size 44  sd_reset (sub_6FDD6) Confirmed:
 * forget the cached file-size verdicts BA41..BA44, clear SD step, card
 * state, substate, and enter state 1 (wait for card mount). */
void sd_reset(void)                                    /* 06FDD6 */
{
    backup_dat_ok = memory_dat_ok = sd_BA43 = sd_BA44 = 0;
    sd_next_step = 0;  sd_card_state = 0;  sd_substate = 0;
    sd_task_state = 1;
}

/* ------------------------------------------------------------------------ *
 * 06FE02-06FECE  size 204  sd_state_mount_wait   (sub_6FE02)   Confirmed
 * State 1.  On an FE reply (BA92.0):
 *   card_state = 0;  code = reply+0x18:
 *   0xC9 with reply+0x0C == 0  -> BA93.0 (no card, stop polling)
 *   0xC8/0xC9, status OK, reply+0x0C in {2,3}:
 *      card_state(BA32) = that value, redraw;
 *      0xC8 (card mounted) -> sd_init_probe_start (06FF16, state 4)
 *      0xC9 -> BBF1.1, state 2, post op 0x78 (template 071326)
 *   status error -> sd_reset.
 * No reply: if not polling (BA93.0 clear) and 9555 expired, set BA93.0
 * and post the 0x64 status poll (sd_post_poll_64).
 * Dead-looking tail 06FEA6: redraw + popup 0xA7 ("no card" class popup).
 * ------------------------------------------------------------------------ */
void sd_state_mount_wait(void)                         /* 06FE02 */
{
    if (!(sd_rx_flags_BA92 & 0x01)) {                  /* 06FEB4            */
        if (!(qso_flags_BA93 & 0x01) && sd_poll_timer_9555 == 0) {
            qso_flags_BA93 |= 0x01;
            sd_post_poll_64();                         /* sub_70800         */
        }
        return;
    }
    sd_rx_flags_BA92 &= ~0x01;
    sd_card_state = 0;
    u16 code = sd_reply.event_18;                      /* FF5006+0x18       */
    if (code != 0xC8) {
        if (code != 0xC9) return;
        if (sd_reply.card_0C == 0) { qso_flags_BA93 |= 0x01; return; }
    }
    if (sd_reply_status != 0) { sd_reset(); return; }  /* -> 06FDA4         */
    u16 cs = sd_reply.card_0C;
    if (cs != 2 && cs != 3) return;
    sd_card_state = (u8)cs;                            /* 06FE5E            */
    redraw_flags_817E |= 0x02;
    if (code == 0xC8) { sd_init_probe_start(); return; } /* 06FEA0 -> 06FF16 */
    flags_BBF1 |= 0x02;
    sd_task_state = 2 | 0x80;
    sd_req_len_BA86 = 0x98;  sd_req_tmpl = TMPL_071326;
    sd_req_op = 0x78;
}

/* 06FECE-06FEF2 size 36  sd_state_card_info (sub_6FECE) Confirmed:
 * state 2.  On reply: redraw; error -> sd_reset; else sd_substate_start. */
void sd_state_card_info(void)                          /* 06FECE */
{
    if (!(sd_rx_flags_BA92 & 0x01)) return;
    sd_rx_flags_BA92 &= ~0x01;
    redraw_flags_817E |= 0x02;
    if (sd_reply_status) { sd_reset(); return; }
    sd_substate_start();                               /* 070146            */
}

/* 06FEF2-06FF00 size 14  sd_state_idle (sub_6FEF2) Confirmed:
 * state 3 (card ready): run the step dispatcher, the voice-recorder FSM and
 * the GPS-log watcher. */
void sd_state_idle(void)                               /* 06FEF2 */
{
    sd_step_dispatch();                                /* loc_70356         */
    voicerec_fsm();                                    /* sub_7055E         */
    gpslog_watch();                                    /* sub_707CC         */
}

/* 06FF00-06FF16 size 22  sd_state_init_probe (sub_6FF00) Confirmed:
 * state 4: dispatch off_70118[BAA2] (6 probe steps 06FF30..0700A8). */
void sd_state_init_probe(void) { off_70118[sd_probe_step](); } /* 06FF00 */

/* 06FF16-06FF30 size 26  sd_init_probe_start (sub_6FF16) Confirmed:
 * retry count BAA7 = 3; (06FF1C, retry re-entry) delay 9563 = 5,
 * probe step 0, state 4. */
void sd_init_probe_start(void)                         /* 06FF16 */
{
    sd_probe_retries = 3;
    /* 06FF1C: */ sd_delay_9563 = 5;  sd_probe_step = 0;  sd_task_state = 4;
}

/* ------------------------------------------------------------------------ *
 * 06FF30-06FF88  size 88   sd_probe0_stat_backup   (sub_6FF30)  Confirmed
 * Probe step 0 (after the 9563 delay): "get size" (op 0x14) of
 * \FT3D\BACKUP\BACKUP.dat (dir 1, name from 0717EA); timeout 9562 = 250;
 * probe step 1.
 * ------------------------------------------------------------------------ */
void sd_probe0_stat_backup(void)                       /* 06FF30 */
{
    if (sd_delay_9563) return;
    sd_task_state |= 0x80;  sd_req_len_BA86 = 0x98;  sd_req_tmpl = TMPL_071326;
    sd_req_op = 0x14;  sd_req_dir = 1;  sd_req_namelen = 10;
    memcpy(sd_req_name, "BACKUP.dat", 10);             /* ROM 0717EA        */
    sd_timeout_9562 = 0xFA;
    sd_probe_step = 1;
}

/* ------------------------------------------------------------------------ *
 * 06FF88-070118  size 400  sd_probe_steps   (sub_6FF88 = probe step 1, plus
 *   entries 06FFD4 (2), 070018 (3), 07005C (4), 0700A8 (5))   Confirmed
 * 1: BACKUP.dat size == 0x1FDC0 -> BA41 = 1 else 0; stat QSOMNG.dat.
 * 2: QSOMNG.dat size must be 0x20 -> read it (sd_req_qsomng_read 071066);
 *    otherwise give up (retry path 0700FC).
 * 3: copy the 0x20-byte QSOMNG image to FEEF00; stat MEMORY.dat (070870).
 * 4: MEMORY.dat size == 0xAC80 -> BA42; read WAVMNG.dat (071046).
 * 5: copy 0x20 bytes to FF304A (WAVMNG), redraw, state 3 (idle/ready).
 * Common no-reply path 0700E4: wait while timeout 9562 runs; when it
 * expires step back one probe step (BAA2--) and retry; at step 0 or on an
 * error, 0700FC: if retries (BAA7) remain: port FBA5 &= 0xF0 and BAA7 =
 * (that value - 1) [literal: the decrement is applied to the port value,
 * a compiler register-reuse quirk or a real bug], then restart at 06FF1C.
 * ------------------------------------------------------------------------ */
void sd_probe1_backup_reply(void)                      /* 06FF88 */
{
    if (!(sd_rx_flags_BA92 & 1)) { sd_probe_wait(); return; }
    sd_rx_flags_BA92 &= ~1;
    backup_dat_ok = (sd_reply_status == 0 && sd_reply.file_size == 0x1FDC0);
    sd_post_stat_qsomng();                             /* sub_7082A         */
    sd_timeout_9562 = 0xFA;  sd_probe_step = 2;
}
void sd_probe2_qsomng_reply(void)                      /* 06FFD4 */
{
    if (!(sd_rx_flags_BA92 & 1)) { sd_probe_wait(); return; }
    sd_rx_flags_BA92 &= ~1;
    if (sd_reply_status == 0 && sd_reply.file_size == 0x20) {
        sd_req_qsomng_read();                          /* sub_71066         */
        sd_timeout_9562 = 0xFA;  sd_probe_step = 3;
    } else sd_probe_retry();                           /* 0700FC            */
}
void sd_probe3_qsomng_data(void)                       /* 070018 */
{
    if (!(sd_rx_flags_BA92 & 1)) { sd_probe_wait(); return; }
    sd_rx_flags_BA92 &= ~1;
    if (sd_reply_status) { sd_probe_retry(); return; }
    memcpy(qsomng_img_EF00, sd_reply_payload, 0x20);   /* -> FEEF00         */
    sd_post_stat_memory();                             /* sub_70870         */
    sd_timeout_9562 = 0xFA;  sd_probe_step = 4;
}
void sd_probe4_memory_reply(void)                      /* 07005C */
{
    if (!(sd_rx_flags_BA92 & 1)) { sd_probe_wait(); return; }
    sd_rx_flags_BA92 &= ~1;
    memory_dat_ok = (sd_reply_status == 0 && sd_reply.file_size == 0xAC80);
    sd_req_wavmng_read();                              /* sub_71046         */
    sd_timeout_9562 = 0xFA;  sd_probe_step = 5;
}
void sd_probe5_wavmng_data(void)                       /* 0700A8 */
{
    if (!(sd_rx_flags_BA92 & 1)) { sd_probe_wait(); return; }
    sd_rx_flags_BA92 &= ~1;
    if (sd_reply_status) { sd_probe_retry(); return; }
    memcpy(wavmng_img, sd_reply_payload, 0x20);        /* -> FF304A         */
    redraw_flags_817E |= 0x02;
    sd_task_state = 3;                                 /* card ready / idle */
}
static void sd_probe_wait(void)                        /* 0700E4 */
{
    if (sd_timeout_9562) return;
    if (sd_probe_step == 0) { sd_probe_retry(); return; }
    sd_probe_step--;
}
static void sd_probe_retry(void)                       /* 0700FC */
{
    if (sd_probe_retries == 0) return;
    u8 v = port_FBA5 & 0xF0;  port_FBA5 = v;
    sd_probe_retries = v - 1;                          /* literal, see above */
    /* 06FF1C */ sd_delay_9563 = 5; sd_probe_step = 0; sd_task_state = 4;
}

/* 070130-070146 size 22  sd_state_substate (sub_70130) Confirmed:
 * state 5: dispatch off_7031E[BAA1] (14 entries, odd ones = wait-for-reply
 * 0702C4). */
void sd_state_substate(void) { off_7031E[sd_substate](); } /* 070130 */

/* 070146-070158 size 18  sd_substate_start (sub_70146) Confirmed:
 * delay 9563 = 5, substate 0, state 5 (falls into 07015A). */
void sd_substate_start(void)                           /* 070146 */
{
    sd_delay_9563 = 5;  sd_substate = 0;  sd_task_state = 5;
}
/* ************************************************************************** *
 * PART 2  07015A-07131E : SD substate sequence (QSOLOG store creation),
 *         SD step dispatcher, voice-recorder FSM, GPS-log watcher, and the
 *         family of SD request "posters" + the request sender sub_71196.
 *
 * Every poster arms one request for the SUB file server (pc-02 sec.1):
 *   sd_task_state |= 0x80 (BA30.7, request pending), BA86 = total length,
 *   BA88 = request template (ROM 071326..073030, file name at +0x56),
 *   optionally op BA9E, param BA9F, dir BAA0, name BAC2/BAD4 (generic
 *   template 071326 only), length BA96, offset BA9A.
 * The macro below stands for those three common stores.
 * ************************************************************************** */
#define SD_POST(len, tmpl) do { sd_task_state |= 0x80; \
        sd_req_len_BA86 = (len); sd_req_tmpl = (tmpl); } while (0)

/* 07015A-070170 size 22  sd_sub0_stat_qsomng (sub_7015A) Confirmed:
 * substate 0 - after the 9563 delay, stat QSOMNG.dat; substate++. */
void sd_sub0_stat_qsomng(void)                         /* 07015A */
{
    if (sd_delay_9563) return;
    sd_post_stat_qsomng();                             /* sub_7082A         */
    sd_substate++;
}

/* ------------------------------------------------------------------------ *
 * 070170-0701C6  size 86   sd_sub1_create_qsomsg   (sub_70170)   Confirmed
 * Substate 1.  On reply (any result: the status / size==0x20 test at
 * 07017E-070198 branches to the same place either way - vestigial check)
 * post template 0713BC (QSOMSG.dat, 0x118 B = 0x90 header + 0x88 data),
 * delay 5, substate++.  Substates 1,3,5,7,9,11 post one file each and the
 * even ones (sd_sub_wait_ok 0702C4) wait for the reply: this is the
 * QSOLOG store initialisation run after a card-info reply (state 2).
 * ------------------------------------------------------------------------ */
void sd_sub1_create_qsomsg(void)                       /* 070170 */
{
    if (!(sd_rx_flags_BA92 & 1)) return;
    sd_rx_flags_BA92 &= ~1;
    (void)(sd_reply_status == 0 && sd_reply.file_size == 0x20); /* no effect */
    sd_delay_9563 = 5;
    SD_POST(0x118, TMPL_0713BC_QSOMSG);
    sd_substate++;
}

/* 0701C6 / 0701F2 / 07021E  size 44 each   Confirmed
 * sd_sub3_create_qsomsgfat (sub_701C6): template 0714D2 QSOMSGFAT.dat, 0x118
 * sd_sub5_create_qsopctfat (sub_701F2): template 0715E8 QSOPCTFAT.dat, 0x98
 * sd_sub7_create_qsowavfat (sub_7021E): template 07167E QSOWAVFAT.dat, 0x118
 * each: wait for delay 9563, post, substate++. */
void sd_sub3_create_qsomsgfat(void)                    /* 0701C6 */
{ if (sd_delay_9563) return; SD_POST(0x118, TMPL_0714D2_QSOMSGFAT); sd_substate++; }
void sd_sub5_create_qsopctfat(void)                    /* 0701F2 */
{ if (sd_delay_9563) return; SD_POST(0x098, TMPL_0715E8_QSOPCTFAT); sd_substate++; }
void sd_sub7_create_qsowavfat(void)                    /* 07021E */
{ if (sd_delay_9563) return; SD_POST(0x118, TMPL_07167E_QSOWAVFAT); sd_substate++; }

/* 07024A-070264 size 26  sd_sub9_create_wavmng (sub_7024A) Confirmed:
 * post WAVMNG.dat write (sd_post_wavmng_write 070C18), then sub_6F450
 * (outside this lane; WAVMNG RAM image helper), substate++. */
void sd_sub9_create_wavmng(void)                       /* 07024A */
{
    if (sd_delay_9563) return;
    sd_post_wavmng_write();  sub_6F450();  sd_substate++;
}

/* 070264-07027A size 22  sd_sub11_create_qsomng (sub_70264) Confirmed:
 * post QSOMNG.dat write (070AFE, template 07205E, 0xB8 - a poster that is
 * not a defined function in the main-final7 list), substate++. */
void sd_sub11_create_qsomng(void)                      /* 070264 */
{
    if (sd_delay_9563) return;
    sd_post_qsomng_write_070AFE();  sd_substate++;
}
/* 070AFE-070B18 (not in the function list; read from the oracle):        */
void sd_post_qsomng_write_070AFE(void) { SD_POST(0xB8, TMPL_07205E_QSOMNG); }

/* 07027A-07029C size 34  sd_sub13_done (sub_7027A) Confirmed:
 * redraw, clear BBF1.1 and BA93.2 (SD job), substate 0, then restart the
 * card-file probes (jsr 06FF16).  Falls through into 07029C in the image. */
void sd_sub13_done(void)                               /* 07027A */
{
    if (sd_delay_9563) return;
    redraw_flags_817E |= 0x02;  flags_BBF1 &= ~0x02;  qso_flags_BA93 &= ~0x04;
    sd_substate = 0;
    sd_init_probe_start();
}

/* 07029C-0702C4 size 40  sd_job_end_if_screen85 (sub_7029C) Inferred:
 * if the current screen record (sub_10748 -> er0) has id 0x85: redraw,
 * AD68 = 0 and sub_1BF8E (screen exit helper). */
void sd_job_end_if_screen85(void)                      /* 07029C */
{
    struct screen *s = current_record_10748();
    if (s->id != 0x85) return;
    redraw_flags_817E |= 0x02;  edit_mode_AD68 = 0;  sub_1BF8E();
}

/* ------------------------------------------------------------------------ *
 * 0702C4-070302  size 62   sd_sub_wait_ok   (sub_702C4)   Confirmed
 * Even substates.  Reply OK -> delay 5, substate++.  Error -> on screen
 * 0x85 sd_card_error_popup, else error tone 0x1D and sd_reset.
 * ------------------------------------------------------------------------ */
void sd_sub_wait_ok(struct screen *er0)                /* 0702C4 */
{
    if (!(sd_rx_flags_BA92 & 1)) return;
    sd_rx_flags_BA92 &= ~1;
    if (sd_reply_status == 0) { sd_delay_9563 = 5; sd_substate++; return; }
    if (er0->id == 0x85) { sd_card_error_popup(); return; }
    tone_event = 0x1D;  sd_reset();
}

/* 070302-07031E size 28  sd_card_error_popup (sub_70302) Confirmed:
 * clear BA93.2, redraw, AD68 = 0, sub_1BF98 (error popup/screen), sd_reset. */
void sd_card_error_popup(void)                         /* 070302 */
{
    qso_flags_BA93 &= ~0x04;  redraw_flags_817E |= 0x02;  edit_mode_AD68 = 0;
    sub_1BF98();  sd_reset();
}

/* ------------------------------------------------------------------------ *
 * 070356-0703C4  size 110  sd_step_dispatch   (sub_70356)   Confirmed
 * State-3 dispatcher.  On an FE reply: BA9E = 0, BAA4 = last step, and jump
 * through off_703E6[BAA3] (47 continuation steps: 0 sd_step0_idle 0703C4,
 * 1 06FCA0, 3..9 BACKUP 0745EE..0749D6, 14 06F816, 15 06F8F6, 17..20 MEMORY
 * 074B90..07501C, 37 06F656, 38/40/41 06F970, 39 06FAC2, 43..46 MEMORY
 * writer/reader tails, the rest in 055A9E/06xxxx).
 * No reply: if a step is pending, the 10ms word 95DE has expired and the
 * timeout table dword_704A2[BAA3] is non-zero (entries 11-13 -> 06F2BA/
 * 06F2F6/06F31C, 21-24 -> 06F190/06F1AC/06F1E8/06F20E), set BA78.7 and jump
 * to that timeout handler.
 * ------------------------------------------------------------------------ */
void sd_step_dispatch(void)                            /* 070356 */
{
    if (sd_rx_flags_BA92 & 1) {
        sd_rx_flags_BA92 &= ~1;
        sd_req_op = 0;                                 /* BA9E              */
        sd_last_step = sd_next_step;                   /* BAA4              */
        off_703E6[sd_next_step]();
        return;
    }
    if (sd_next_step == 0) return;                     /* 070388            */
    if (sd_timer_95DE != 0) return;
    if (dword_704A2[sd_next_step] == 0) return;
    flags_BA78 |= 0x80;
    dword_704A2[sd_next_step]();
}

/* 0703C4-0703E6 size 34  sd_step0_idle (sub_703C4) Confirmed:
 * unsolicited reply with event 0xCD (card removed) -> sd_reset + redraw.
 * (doc 36 notes IDA made this code only as a data-offset side effect: it is
 *  in fact off_703E6[0].) */
void sd_step0_idle(void)                               /* 0703C4 */
{
    sd_next_step = 0;
    if (sd_reply.event_18 == 0xCD) { sd_reset(); redraw_flags_817E |= 0x02; }
}

/* ------------------------------------------------------------------------ *
 * 07055E-07075A  size 508  voicerec_fsm   (sub_7055E)   Inferred
 * Voice-recorder (\VOICE\*.wav) state machine, run in SD state 3.
 * State byte BAD6: 0 idle, 1/2 armed (auto-record conditions), 0x80 start
 * requested, 0x90 stop requested, 0x81/0x82/0xC2 = TX-side variants.
 * BAD7 = last EA-frame payload from the SUB (doc 108: EA = transfer
 * handshake; values 0x00/0x10/0xA0), BAD8 = recorder sub-state (b7 masked),
 * BADC = retry count.  95A5 = 10ms hold-off timer.
 *  - BAD6 == 0: on an EA frame (BA92.1): BAD7==0 & BAD8==1 -> BADC = 0;
 *    BAD7==0x10 -> sub_2C360 (BAD8 in {0,1,0x10}) / sub_2C368 (BAD8==2);
 *    BAD7==0xA0 & BAD8==1 & BADC: BADC--, redraw, BAD8 = 1; else BAD6 = 0.
 *  - BAD6 not in {2,0x82,0xC2,0x81}: on an EA frame redraw and
 *    0x80 + BAD7==0 -> popup 0xAC, 95A5 = 30, BAD6 = 1;
 *    0x90 -> BAD6 = 0;  1/2 + BAD7==0xA0 -> error tone 0x1D, BAD6 = 0.
 *    No frame and BAD6 == 0x90 -> wait.
 *  - otherwise (070654..): evaluates TX state (FF94C0 == 1), the record
 *    source setting 89D1 (0/1/2) against the band busy states BB96/BB97,
 *    AA37.1 / 9183 / 9180, and 89D2 vs 817E.0 to move between 1, 2, 0x81
 *    and 0x82, re-arming 95A5 = 30 when a condition drops.
 * TODO(waveC): name 89D1/89D2/BB96/BB97 precisely (record-source and
 * squelch-open cells; see doc 73 open item).
 * ------------------------------------------------------------------------ */
void voicerec_fsm(void)                                /* 07055E */
{
    u8 st = voicerec_state;                            /* BAD6              */
    if (st == 0) {                                     /* 0705E4            */
        if (!(sd_rx_flags_BA92 & 0x02)) return;
        sd_rx_flags_BA92 &= ~0x02;
        u8 sub = voicerec_sub & 0x7F;                  /* BAD8              */
        u8 ev = ea_payload;                            /* BAD7              */
        if (ev == 0) { if (sub == 1) voicerec_retries = 0; return; }
        if (ev == 0x10) {
            if (sub == 1 || sub == 0x10 || sub == 0) sub_2C360();
            else if (sub == 2) sub_2C368();
            return;
        }
        if (ev != 0xA0) return;
        if (sub == 1 && voicerec_retries) {
            voicerec_retries--;  redraw_flags_817E |= 0x02;  voicerec_sub = 1;
        } else voicerec_state = 0;
        return;
    }
    if (st == 2 || st == 0x82 || st == 0xC2 || st == 0x81) goto conditions;
    if (!(sd_rx_flags_BA92 & 0x02)) {                  /* 070654            */
        if (st == 0x90) return;
        goto conditions;
    }
    sd_rx_flags_BA92 &= ~0x02;  redraw_flags_817E |= 0x02;
    if (st == 0x80) {                                  /* 0705CA            */
        if (ea_payload == 0) {
            popup_show(0xAC);  voicerec_hold_95A5 = 0x1E;  voicerec_state = 1;
        } else voicerec_state = 0;
        return;
    }
    if (st == 0x90) { voicerec_state = 0; return; }    /* 0705BA            */
    if ((st == 1 || st == 2) && ea_payload == 0xA0) {
        tone_event = 0x1D;  voicerec_state = 0;
    }
    return;

conditions:                                            /* 07065E            */
    if (tx_state != 1) {                               /* FF94C0            */
        if (st == 0x82) voicerec_state = 2;
        else if (st == 0xC2 || st == 0x81) {
            redraw_flags_817E |= 0x02;  voicerec_hold_95A5 = 0x1E;  voicerec_state = 1;
        }
        int busy_ok;                                   /* 070692            */
        switch (rec_source_89D1) {
        case 0:  busy_ok = -1; break;                  /* check band A path */
        case 1:  busy_ok = (bandB_busy_BB97 == 2) ? 1 : 0; break;
        default: busy_ok = (bandB_busy_BB97 == 2) ? -1 : 0; break;
        }
        if (busy_ok < 0) {                             /* 0706B0            */
            busy_ok = (!(flags_AA37 & 0x02) || cell_9183 == 0 || cell_9180 == 2)
                      && bandA_busy_BB96 == 2;
        }
        if (busy_ok) {                                 /* 0706CE            */
            st = voicerec_state;
            if (st == 0x80 || st == 0x90 || voicerec_hold_95A5) return;
            redraw_flags_817E |= 0x02;  voicerec_state = 2;
        } else {                                       /* 0706F2            */
            voicerec_hold_95A5 = 0x1E;
            if (voicerec_state == 2) { redraw_flags_817E |= 0x02; voicerec_state = 1; }
        }
        return;
    }
    /* transmitting (07070E) */
    if (setting_89D2 == 0 ||
        (rec_source_89D1 != 2 && rec_source_89D1 != (redraw_flags_817E & 1))) {
        st = voicerec_state;                           /* 07072A            */
        if (st == 2) { voicerec_state = 0x82; return; }
        if (st == 1) { redraw_flags_817E |= 0x02; voicerec_state = 0x82; }
        return;
    }
    if (voicerec_state != 1) redraw_flags_817E |= 0x02; /* 070744           */
    voicerec_state = 0x81;
}

/* ------------------------------------------------------------------------ *
 * 07075A-0707CC  size 114  voicerec_audio_route_toggle  (sub_7075A) Inferred
 * Called from the F10B screen key (doc 103, with 024E7E).  When the recorder
 * is active (BAD6 != 0), the band is in a mode with 8EA0.4 and 89D1 != 2,
 * toggles BAD5.0 and rewrites the low two bits of the 16-bit latch image
 * 817A/817B from byte_70FA6[89D1] ({1,2,3,0}) or 070FAA ({2,1,3,0}), then
 * clocks it out with sub_37A56 (serial latch on port FF5A).
 * ------------------------------------------------------------------------ */
void voicerec_audio_route_toggle(void)                 /* 07075A */
{
    if (voicerec_state == 0) return;
    if (!(band_sel_8EA0 & 0x10)) return;
    if (rec_source_89D1 == 2) return;
    u8 v;
    if (!(voicerec_flags_BAD5 & 1)) { voicerec_flags_BAD5 |= 1;  v = ROM_070FAA[rec_source_89D1]; }
    else                            { voicerec_flags_BAD5 &= ~1; v = ROM_070FA6[rec_source_89D1]; }
    latch_817B = (latch_817B & 0xFC) | v;
    latch_shift_out_37A56();
}

/* ------------------------------------------------------------------------ *
 * 0707CC-0707D8 size 12  gpslog_watch       (sub_707CC)  Confirmed
 * 0707D8-070800 size 40  gpslog_watch_tail  (sub_707D8)  Confirmed
 * GPS LOG setting watcher (89D0 = GPS LOG interval, 0 = off; BADA = last
 * seen value).  Off -> on: create a new log file (gpslog_create, 070FAE).
 * Value changed while on: append/reopen (070FE8).  Then BADA = 89D0.
 * ------------------------------------------------------------------------ */
void gpslog_watch(void)                                /* 0707CC */
{
    if (gpslog_last_BADA == 0) {
        if (gps_log_setting_89D0 == 0) return;
        gpslog_create();                               /* 0707D8: sub_70FAE */
    } else {
        if (gps_log_setting_89D0 == gpslog_last_BADA) return;  /* 0707DE */
        if (gps_log_setting_89D0 == 0) gpslog_append();        /* sub_70FE8 */
    }
    gpslog_last_BADA = gps_log_setting_89D0;           /* 0707F6            */
}

/* 070800-07082A size 42  sd_post_poll_64 (sub_70800) Confirmed:
 * only in state 1: generic template, op 0x64 (card status poll). */
void sd_post_poll_64(void)                             /* 070800 */
{
    if (sd_task_state != 1) return;
    SD_POST(0x98, TMPL_071326);  sd_req_op = 0x64;
}

/* 07082A / 070870 / 0708B6  size 70 each   Confirmed
 * sd_post_stat_qsomng (sub_7082A): op 0x14 (get size), dir 4, "QSOMNG.dat"
 * sd_post_stat_memory (sub_70870): op 0x14, dir 3, "MEMORY.dat"
 * sd_post_photo_stat  (sub_708B6): op 0x14, dir 5, 16-byte name FFBA5A
 *   (doc 74: "<stem>.jpg"). */
void sd_post_stat_qsomng(void)                         /* 07082A */
{
    SD_POST(0x98, TMPL_071326);  sd_req_op = 0x14;  sd_req_dir = 4;
    sd_req_namelen = 10;  memcpy(sd_req_name, ROM_0720B4_QSOMNG, 10);
}
void sd_post_stat_memory(void)                         /* 070870 */
{
    SD_POST(0x98, TMPL_071326);  sd_req_op = 0x14;  sd_req_dir = 3;
    sd_req_namelen = 10;  memcpy(sd_req_name, ROM_071D30_MEMORY, 10);
}
void sd_post_photo_stat(void)                          /* 0708B6 */
{
    SD_POST(0x98, TMPL_071326);  sd_req_op = 0x14;  sd_req_dir = 5;
    sd_req_namelen = 0x10;  memcpy(sd_req_name, sd_photo_name_BA5A, 0x10);
}

/* 0708FC-07092A size 46  sd_post_op50 (sub_708FC) Confirmed:
 * mark SD job (BA93 |= 0x06), generic template, op 0x50. */
void sd_post_op50(void)                                /* 0708FC */
{
    qso_flags_BA93 |= 0x02 | 0x04;
    SD_POST(0x98, TMPL_071326);  sd_req_op = 0x50;
}

/* ------------------------------------------------------------------------ *
 * 07092A-070AE2  BACKUP / MEMORY posters (all Confirmed, one-liners).
 * "job" = also sets BA93 bits 1 and 2 (SD job running).
 *   07092A sd_post_backup_0  job  0x398  071794  (BACKUP.dat first chunk)
 *   070952 sd_post_backup_1        0x358  07182A
 *   07096E sd_post_backup_2        0x398  0718C0
 *   07098A sd_post_backup_3        0x398  071956
 *   0709A6 sd_post_backup_4  job  0x098  0719EC
 *   0709CE sd_post_backup_5        0x098  071A82
 *   0709EA sd_post_backup_6        0x098  071B18
 *   070A06 sd_post_backup_7        0x098  071BAE
 *   070A22 sd_post_backup_8        0x098  071C44
 *   070A3E sd_post_memory_0  job  0x398  071CDA (MEMORY.dat)
 *   070A66 sd_post_memory_1        0x398  071D70
 *   070A82 sd_post_memory_2        0x218  071E06
 *   070A9E sd_post_memory_3  job  0x098  071E9C
 *   070AC6 sd_post_memory_4        0x098  071F32
 *   070AE2 sd_post_memory_5        0x098  071FC8
 * 0x398 = 0x98 header + 0x300 chunk (pc-02: 0x300-byte chunks), 0x358 =
 * last 0x2C0 chunk of region A, 0x218 = 0x280-byte last MEMORY chunk.
 * The 0x98-length ones carry no data (read/stat side of the transfer).
 * ------------------------------------------------------------------------ */
void sd_post_backup_0(void) { qso_flags_BA93 |= 6; SD_POST(0x398, TMPL_071794); } /* 07092A */
void sd_post_backup_1(void) { SD_POST(0x358, TMPL_07182A); }                      /* 070952 */
void sd_post_backup_2(void) { SD_POST(0x398, TMPL_0718C0); }                      /* 07096E */
void sd_post_backup_3(void) { SD_POST(0x398, TMPL_071956); }                      /* 07098A */
void sd_post_backup_4(void) { qso_flags_BA93 |= 6; SD_POST(0x98, TMPL_0719EC); }  /* 0709A6 */
void sd_post_backup_5(void) { SD_POST(0x98, TMPL_071A82); }                       /* 0709CE */
void sd_post_backup_6(void) { SD_POST(0x98, TMPL_071B18); }                       /* 0709EA */
void sd_post_backup_7(void) { SD_POST(0x98, TMPL_071BAE); }                       /* 070A06 */
void sd_post_backup_8(void) { SD_POST(0x98, TMPL_071C44); }                       /* 070A22 */
void sd_post_memory_0(void) { qso_flags_BA93 |= 6; SD_POST(0x398, TMPL_071CDA); } /* 070A3E */
void sd_post_memory_1(void) { SD_POST(0x398, TMPL_071D70); }                      /* 070A66 */
void sd_post_memory_2(void) { SD_POST(0x218, TMPL_071E06); }                      /* 070A82 */
void sd_post_memory_3(void) { qso_flags_BA93 |= 6; SD_POST(0x98, TMPL_071E9C); }  /* 070A9E */
void sd_post_memory_4(void) { SD_POST(0x98, TMPL_071F32); }                       /* 070AC6 */
void sd_post_memory_5(void) { SD_POST(0x98, TMPL_071FC8); }                       /* 070AE2 */

/* ------------------------------------------------------------------------ *
 * 070B1A-070E4C  QSO store posters (all Confirmed).  "card" = returns
 * without posting when no card is ready (BA32 == 0).
 *   070B1A sd_post_qsomng_rewrite       BA9A=0, 0xB8, 0720F4 QSOMNG.dat
 *   070B42 sd_post_qsopctdir_append     0x118  07218A QSOPCTDIR.dat
 *   070B5E sd_post_qsopctdir_update     0x118  072220 QSOPCTDIR.dat
 *   070B7A sd_post_qsopctfat_append     0x09C  0722B6 QSOPCTFAT.dat
 *   070B96 sd_post_qsopctfat_update     0x09C  07234C QSOPCTFAT.dat
 *   070BB2 sd_post_qsopctdir_read  card 0x098  0723E2 QSOPCTDIR.dat
 *   070BD4 sd_post_qsopctfat_read  card 0x098  072478 QSOPCTFAT.dat
 *   070BF6 sd_post_qsopct_072_50E  card 0x098  07250E (no name string)
 *   070C18 sd_post_wavmng_write         0x0B8  0725A4 WAVMNG.dat
 *   070C34 sd_post_wavmng_rewrite  BA9A=0, 0xB8 07263A WAVMNG.dat
 *   070C5C sd_post_qsowavdir_append     0x118  0726D0 QSOWAVDIR.dat
 *   070C78 sd_post_qsowavfat_append     0x09C  072766 QSOWAVFAT.dat
 *   070C94 sd_post_qsowavfat_update     0x09C  0727FC QSOWAVFAT.dat
 *   070CB0 sd_post_qsowavdir_read  card 0x098  072892 QSOWAVDIR.dat
 *   070CD2 sd_post_qsowavfat_read  card 0x098  072928 QSOWAVFAT.dat
 *   070CF4 sd_post_qsomsg_append        0x0E8  0729BE QSOMSG.dat (0x50 B)
 *   070D10 sd_post_qsomsgdir_append     0x118  072A54 QSOMSGDIR.dat
 *   070D2C sd_post_qsomsgdir_update     0x118  072AEA QSOMSGDIR.dat
 *   070D48 sd_post_qsomsgfat_append     0x09C  072B80 QSOMSGFAT.dat
 *   070D64 sd_post_qsomsgfat_update     0x09C  072C16 QSOMSGFAT.dat
 *   070D80 sd_post_qsomsg_read     card 0x098  072CAC QSOMSG.dat
 *   070DA2 sd_post_qsomsgdir_read  card 0x098  072D42 QSOMSGDIR.dat
 *   070E2A sd_post_qsomsgfat_read  card 0x098  072F9A QSOMSGFAT.dat
 * 0x118 = header + 0x80 record, 0x9C = header + 4-byte FAT entry,
 * 0xE8 = header + 0x50 message unit, 0xB8 = header + 0x20 mng block.
 * "append"/"update" naming follows the paired templates (pc-06 sec.4 uses
 * 07218A/0722B6 for append and 0720F4 for the QSOMNG rewrite); the second
 * template of each pair is Inferred to be the update-in-place variant.
 * ------------------------------------------------------------------------ */
void sd_post_qsomng_rewrite(void)   { sd_req_offset = 0; SD_POST(0xB8, TMPL_0720F4); } /* 070B1A */
void sd_post_qsopctdir_append(void) { SD_POST(0x118, TMPL_07218A); }   /* 070B42 */
void sd_post_qsopctdir_update(void) { SD_POST(0x118, TMPL_072220); }   /* 070B5E */
void sd_post_qsopctfat_append(void) { SD_POST(0x09C, TMPL_0722B6); }   /* 070B7A */
void sd_post_qsopctfat_update(void) { SD_POST(0x09C, TMPL_07234C); }   /* 070B96 */
void sd_post_qsopctdir_read(void)   { if (sd_card_state) SD_POST(0x98, TMPL_0723E2); } /* 070BB2 */
void sd_post_qsopctfat_read(void)   { if (sd_card_state) SD_POST(0x98, TMPL_072478); } /* 070BD4 */
void sd_post_qsopct_07250E(void)    { if (sd_card_state) SD_POST(0x98, TMPL_07250E); } /* 070BF6 */
void sd_post_wavmng_write(void)     { SD_POST(0xB8, TMPL_0725A4); }    /* 070C18 */
void sd_post_wavmng_rewrite(void)   { sd_req_offset = 0; SD_POST(0xB8, TMPL_07263A); } /* 070C34 */
void sd_post_qsowavdir_append(void) { SD_POST(0x118, TMPL_0726D0); }   /* 070C5C */
void sd_post_qsowavfat_append(void) { SD_POST(0x09C, TMPL_072766); }   /* 070C78 */
void sd_post_qsowavfat_update(void) { SD_POST(0x09C, TMPL_0727FC); }   /* 070C94 */
void sd_post_qsowavdir_read(void)   { if (sd_card_state) SD_POST(0x98, TMPL_072892); } /* 070CB0 */
void sd_post_qsowavfat_read(void)   { if (sd_card_state) SD_POST(0x98, TMPL_072928); } /* 070CD2 */
void sd_post_qsomsg_append(void)    { SD_POST(0x0E8, TMPL_0729BE); }   /* 070CF4 */
void sd_post_qsomsgdir_append(void) { SD_POST(0x118, TMPL_072A54); }   /* 070D10 */
void sd_post_qsomsgdir_update(void) { SD_POST(0x118, TMPL_072AEA); }   /* 070D2C */
void sd_post_qsomsgfat_append(void) { SD_POST(0x09C, TMPL_072B80); }   /* 070D48 */
void sd_post_qsomsgfat_update(void) { SD_POST(0x09C, TMPL_072C16); }   /* 070D64 */
void sd_post_qsomsg_read(void)      { if (sd_card_state) SD_POST(0x98, TMPL_072CAC); } /* 070D80 */

/* 070DA2-070E2A size 136  sd_post_qsomsgdir_read (sub_70DA2) Confirmed:
 * card-gated; the entry branches straight to template 072D42.  The code at
 * 070DAA-070DB8 (choose 072D42 / 072DD8 / 072E6E / 072F04 from r3 =
 * {r3h total, r3l remaining}: 0x0101 -> first, r3h == r3l -> 072DD8,
 * r3l == 1 -> 072F04, else 072E6E) is unreachable from the entry - no other
 * xref in this lane's listing; left as documented dead code. */
void sd_post_qsomsgdir_read(u16 r3)                    /* 070DA2 */
{
    if (sd_card_state == 0) return;
    SD_POST(0x98, TMPL_072D42);                        /* 070DBA            */
    /* dead: if (r3==0x101) 072D42; else if (hi==lo) 072DD8;
             else if (lo==1) 072F04; else 072E6E;                           */
}
void sd_post_qsomsgfat_read(void)   { if (sd_card_state) SD_POST(0x98, TMPL_072F9A); } /* 070E2A */

/* ------------------------------------------------------------------------ *
 * 070E4C-070EF4  size 168  voicerec_key   (sub_70E4C)   Inferred
 * Voice-record key.  No card -> popup 0xA7 + error tone (070F9A).
 * SD not idle (BA30 != 3) or BAD6 == 0x80 -> invalid key.  BAD6 != 0 ->
 * stop (070F6E: clear latch bits, popup 0xAD, BAD6 = 0x90, sub_1F38C).
 * BAD6 == 0: check that the band/source allows recording (8EA0.7, 89D1,
 * 8EA0.6), else sub_3FF9C (error-tone invalid key).  Then A9E6 = 2, build
 * the name "YYMMDDHHMM" + 2 digits of BADB + ".wav" (070FA2) at BADE,
 * BA3D++, BAD6 = 0x80, sub_6A97A (SUB "start recording" command).
 * 070EF4 (= sub_70EF4) is the continuation that issues the file create.
 * ------------------------------------------------------------------------ */
void voicerec_key(void)                                /* 070E4C */
{
    if (sd_card_state == 0) { popup_show_err(0xA7); return; } /* sub_1BF78 */
    if (sd_task_state != 3) { key_invalid(); return; }
    u8 st = voicerec_state;
    if (st == 0x80) { key_invalid(); return; }
    if (st != 0) { voicerec_stop_070F6E(); return; }
    voicerec_flags_BAD5 &= ~1;
    if (!(band_sel_8EA0 & 0x80) && rec_source_89D1 != 2) {
        int bandB = (band_sel_8EA0 & 0x40) != 0;
        if ((rec_source_89D1 == 0 &&  bandB) ||
            (rec_source_89D1 != 0 && !bandB)) { key_invalid_tone(); return; } /* sub_3FF9C */
    }
    rec_cmd_A9E6 = 2;
    make_datetime_name_6EFFA(voicerec_name_BADE);      /* 12 chars + 2 NUL  */
    u8 n = voicerec_seq_BADB;                          /* 070EB0            */
    voicerec_name_BADE[10] = '0' + n / 10;             /* BAE8: divxu quot  */
    voicerec_name_BADE[11] = '0' + n % 10;             /* BAE9: remainder   */
    /* (these overwrite the two BA3D digits sub_6EFFA put there)            */
    memcpy(voicerec_name_BADE + 12, ".wav", 4);        /* ROM 070FA2        */
    file_seq_BA3D++;
    voicerec_state = 0x80;
    sub_6A97A();                                       /* SUB: start record */
}

/* ------------------------------------------------------------------------ *
 * 070EF4-070FA2  size 174  voicerec_file_create   (sub_70EF4)   Inferred
 * Sets the audio latch bits from byte_70FA6[89D1], then posts a generic
 * request: op 1 (create "w"), param 5 (data from SUB voice buffer),
 * dir 6 (\VOICE), name BADE (16), length 0, then sub_1F38C.  Shares tails:
 * 070F6E stop, 070F8E/070F94 invalid key, 070F9A no-card popup.
 * ------------------------------------------------------------------------ */
void voicerec_file_create(void)                        /* 070EF4 */
{
    latch_817B = (latch_817B & 0xFC) | ROM_070FA6[rec_source_89D1];
    latch_shift_out_37A56();
    sd_req_op = 1;  sd_req_param = 5;
    SD_POST(0x98, TMPL_071326);
    sd_req_dir = 6;  sd_req_namelen = 0x10;
    memcpy(sd_req_name, voicerec_name_BADE, 0x10);
    sd_req_length = 0;
    sub_1F38C();
}
void voicerec_stop_070F6E(void)                        /* 070F6E */
{
    latch_817B &= 0xFC;  latch_shift_out_37A56();
    popup_show(0xAD);  voicerec_state = 0x90;  sub_1F38C();
}

/* ------------------------------------------------------------------------ *
 * 070FAE-071040  size 146  gpslog_create   (sub_70FAE)   Confirmed
 *   second entry 070FE8 = gpslog_append.
 * Create: op 1 / param 2, name = "YYMMDDHHMMnn" (sub_6EFFA, nn = BA3D) +
 * ".log" (071040) at BAF0, BA3D++.  Append: op 2 / param 3.  Both then post
 * a generic request: dir 2 (\FT3D\GPSLOG), name BAF0 (16), length 0.
 * ------------------------------------------------------------------------ */
void gpslog_create(void)                               /* 070FAE */
{
    sd_req_op = 1;  sd_req_param = 2;
    make_datetime_name_6EFFA(gpslog_name_BAF0);
    memcpy(gpslog_name_BAF0 + 12, ".log", 4);          /* ROM 071040        */
    file_seq_BA3D++;
    gpslog_post_070FF4();
}
void gpslog_append(void)                               /* 070FE8 */
{
    sd_req_op = 2;  sd_req_param = 3;
    gpslog_post_070FF4();
}
static void gpslog_post_070FF4(void)
{
    SD_POST(0x98, TMPL_071326);
    sd_req_dir = 2;  sd_req_namelen = 0x10;
    memcpy(sd_req_name, gpslog_name_BAF0, 0x10);
    sd_req_length = 0;
}

/* 071044 nullsub_14 (rts) */
void nullsub_14(void) { }                              /* 071044 */

/* ------------------------------------------------------------------------ *
 * 071046-071066 size 32  sd_req_wavmng_read  (sub_71046)  Confirmed
 * 071066-0710C4 size 94  sd_req_qsomng_read  (sub_71066)  Confirmed
 * Name "WAVMNG.dat" (0725FA) or "QSOMNG.dat" (0720B4), then the shared
 * tail 071084: generic template, op 0x0A (read len at off), dir 4,
 * length 0x20, offset 0.
 * ------------------------------------------------------------------------ */
void sd_req_wavmng_read(void)                          /* 071046 */
{
    sd_req_namelen = 10;  memcpy(sd_req_name, ROM_0725FA_WAVMNG, 10);
    sd_req_mng_read_071084();
}
void sd_req_qsomng_read(void)                          /* 071066 */
{
    sd_req_namelen = 10;  memcpy(sd_req_name, ROM_0720B4_QSOMNG, 10);
    sd_req_mng_read_071084();
}
static void sd_req_mng_read_071084(void)
{
    SD_POST(0x98, TMPL_071326);
    sd_req_op = 0x0A;  sd_req_dir = 4;
    sd_req_length = 0x20;  sd_req_offset = 0;
}

/* ------------------------------------------------------------------------ *
 * 0710C4-0710D2 size 14  photo_save_rx   (sub_710C4)  Confirmed
 * 0710D2-07111E size 76  photo_save_camera (sub_710D2) Confirmed
 * 07111E-071150 size 50  photo_save_name_tail (sub_7111E) Confirmed
 * Save a picture to \PHOTO (pc-06 sec.3/5, doc 63): length from B208
 * (received over the air) or BA46 (camera upload), generic template,
 * op 1 ("w"), param 4 (data from SUB picture buffer 070E1000), dir 5.
 * sub_6EE38 builds "H<radio id>0DDDDD" at BA4A; ".jpg" (ROM 06A976) is
 * appended at BA56; the 16-char name is copied to BAC2; BA3D++.
 * ------------------------------------------------------------------------ */
void photo_save_rx(void)                               /* 0710C4 */
{
    sd_req_length = rx_picture_size_B208;
    photo_save_post_0710DE();
}
void photo_save_camera(void)                           /* 0710D2 */
{
    sd_req_length = camera_jpeg_size_BA46;
    photo_save_post_0710DE();
}
static void photo_save_post_0710DE(void)
{
    SD_POST(0x98, TMPL_071326);
    sd_req_op = 1;  sd_req_param = 4;  sd_req_dir = 5;
    make_photo_name_6EE38();                           /* -> FFBA4A         */
    memcpy(sd_scratch_BA4A + 12, ".jpg", 4);           /* ROM 06A976 -> BA56 */
    photo_save_name_tail();                            /* 07111E            */
}
void photo_save_name_tail(void)                        /* 07111E */
{
    /* 07111E is the eepmov of the ".jpg" copy itself (entered with r4/er5/er6
       set up by the caller) */
    sd_req_namelen = 0x10;  memcpy(sd_req_name, sd_scratch_BA4A, 0x10);
    file_seq_BA3D++;
}

/* 071150-071196 size 70  sd_post_photo_open (sub_71150) Confirmed:
 * op 0x0B (open, read len at off), dir 5 (\PHOTO), name FF301E (16). */
void sd_post_photo_open(void)                          /* 071150 */
{
    SD_POST(0x98, TMPL_071326);
    sd_req_op = 0x0B;  sd_req_dir = 5;
    sd_req_namelen = 0x10;  memcpy(sd_req_name, photo_name_301E, 0x10);
}
/* ************************************************************************** *
 * PART 3  071196-073B62 : SD request frame builder, SD-job gate, Bluetooth
 *         link FSM (doc 124), SCO hold, clone/extension-port (doc 24) and
 *         the DATA-jack node-command parser (doc 104).
 * ************************************************************************** */

/* ------------------------------------------------------------------------ *
 * 071196-07131E  size 392  sd_request_build   (sub_71196)   Confirmed
 * Called by the IPC sender sub_D53A (frame 0xFC00, doc 63) to fill the
 * outgoing SD request at FF3D7A:
 *   FF3D7A  = request sequence BA8C, then BA8C is advanced 1..0xFF by
 *             sub_3F6FA (wrap record 07131E {1,0xFF,&BA8C})
 *   FF3D7C+ = template header (its first u16 = header length L, 0x90),
 *             then, if the u16 at template+L is non-zero, that many payload
 *             bytes from the pointer at template+L+2 (and the length word
 *             at FF3D7C is increased by it)          [pc-02: +0x90 / +0x92]
 *   +0x04 (FF3D80) = card state BA32
 *   +0x08 (FF3D84) = BCD date A9C4 (3 B), +0x0B = 0, +0x0C = time A9C8 (2 B)
 * Fixed templates (BA88 != 071326): op = template+0x10:
 *   3          -> +0x7A offset only
 *   0x12       -> +0x76 length, then the name copy (BAC2/BAD4 -> +0x56)
 *   A,B,D,E,F,0x10 -> +0x76 length, +0x7A offset
 * Generic template 071326: +0x10 = op BA9E;
 *   0x14       -> dir + name
 *   1,2,3      -> +0x12 = param BA9F, +0x76 length, dir + name
 *   A,B,D,E,F,0x10 -> length + offset, dir + name
 *   other      -> nothing more
 *   dir: +0x14 = BAA0;  name: BAD4 bytes of BAC2 -> +0x56.
 * ------------------------------------------------------------------------ */
void sd_request_build(void)                            /* 071196 */
{
    ipc_txhdr_3D7A = sd_req_seq;                       /* BA8C              */
    wrap_inc16(&REC_07131E);                           /* sub_3F6FA         */
    const u8 *t = sd_req_tmpl;                         /* BA88              */
    u16 L = *(const u16 *)t;
    memcpy(ipc_req, t, L);                             /* -> FF3D7C         */
    t += L;
    u16 P = *(const u16 *)t;  t += 2;
    if (P) {
        *(u16 *)ipc_req += P;
        memcpy(ipc_req + L, *(const u8 *const *)t, P);
    }
    *(u16 *)(ipc_req + 0x04) = sd_card_state;
    memcpy(ipc_req + 0x08, rtc_date_A9C4, 3);  ipc_req[0x0B] = 0;
    memcpy(ipc_req + 0x0C, rtc_time_A9C8, 2);

    if (sd_req_tmpl != TMPL_071326) {                  /* 071228            */
        u8 op = (u8)*(const u16 *)(sd_req_tmpl + 0x10);
        switch (op) {
        case 0x03: *(u32 *)(ipc_req + 0x7A) = sd_req_offset; return;
        case 0x12: *(u32 *)(ipc_req + 0x76) = sd_req_length; goto name;
        case 0x0A: case 0x0B: case 0x0D: case 0x0E: case 0x10: case 0x0F:
            *(u32 *)(ipc_req + 0x76) = sd_req_length;
            *(u32 *)(ipc_req + 0x7A) = sd_req_offset; return;
        default: return;
        }
    }
    *(u16 *)(ipc_req + 0x10) = sd_req_op;              /* 071288            */
    switch (sd_req_op) {
    case 0x14: break;
    case 1: case 2: case 3:
        *(u16 *)(ipc_req + 0x12) = sd_req_param;
        *(u32 *)(ipc_req + 0x76) = sd_req_length; break;
    case 0x0A: case 0x0B: case 0x0D: case 0x0E: case 0x10: case 0x0F:
        *(u32 *)(ipc_req + 0x76) = sd_req_length;
        *(u32 *)(ipc_req + 0x7A) = sd_req_offset; break;
    default: return;
    }
    *(u16 *)(ipc_req + 0x14) = sd_req_dir;             /* 0712F6            */
name:                                                  /* 071302            */
    memcpy(ipc_req + 0x56, sd_req_name, sd_req_namelen);
}

/* ------------------------------------------------------------------------ *
 * 073030-073072  size 66   sd_job_blocked   (sub_73030)   Confirmed
 * Returns 0 (job may start) when a card is ready (BA32 = 2 or 3), the SD
 * task is idle (BA30 == 3), no voice recording (BAD6 == 0), GPS log off
 * (89D0 == 0) and no op-0x50 request is outstanding (BA9E != 0x50).
 * Otherwise sounds the invalid key (or, with no card at all, popup 0xA7 +
 * error tone) and returns 1.
 * ------------------------------------------------------------------------ */
u8 sd_job_blocked(void)                                /* 073030 */
{
    if (sd_card_state == 0) { popup_show_err(0xA7); return 1; }
    if (sd_task_state == 3 &&
        (sd_card_state == 2 || sd_card_state == 3) &&
        voicerec_state == 0 && gps_log_setting_89D0 == 0 &&
        sd_req_op != 0x50)
        return 0;
    key_invalid();
    return 1;
}

/* ------------------------------------------------------------------------ *
 * 073072-07308C  size 26   bt_link_fsm   (sub_73072)   Confirmed
 * Bluetooth bring-up machine (doc 124 sec.5).  Runs the SCO hold logic
 * (bt_sco_hold 073412) then dispatches off_7308C[BB90]:
 *   0 bt_boot 07309C, 1 bt_wait_hello 0730E8, 2 bt_autoconnect 07310C,
 *   3 bt_running 07312A.
 * ------------------------------------------------------------------------ */
void bt_link_fsm(void)                                 /* 073072 */
{
    bt_sco_hold();
    off_7308C[bt_bringup];                             /* BB90              */
}

/* ------------------------------------------------------------------------ *
 * 07309C-0730D0  size 52   bt_boot   (sub_7309C)   Confirmed
 * BB90 == 0.  Bluetooth off (8920.0 clear) -> bt_set_idle.  On: if the last
 * F3D2 sub-op 8EAF == 1 (disconnected) -> BB70 = 1, BB8E = 0, BB90 = 3;
 * else 8EAF = BB70 = 2 and BB90 = 1 (wait for HELL).
 * ------------------------------------------------------------------------ */
void bt_boot(void)                                     /* 07309C */
{
    if (!(bt_setting_8920 & 1)) { bt_set_idle(); return; }
    if (bt_subop_8EAF == 1) {
        bt_status = 1;  bt_userop = 0;  bt_bringup = 3;
    } else {
        bt_subop_8EAF = 2;  bt_status = 2;  bt_bringup = 1;
    }
}

/* 0730D0-0730E8 size 24  bt_set_idle (sub_730D0) Confirmed:
 * 8EAF = BB70 = 1 (disconnected/ready), BB8E = 0, BB90 = 3.  Also the
 * E4-5 "link failure" action (doc 124 row 7). */
void bt_set_idle(void)                                 /* 0730D0 */
{
    bt_subop_8EAF = 1;  bt_status = 1;  bt_userop = 0;  bt_bringup = 3;
}

/* 0730E8-07310C size 36  bt_wait_hello (sub_730E8) Confirmed:
 * BB90 == 1.  With the SUB link up (813E) and an E4 frame (BA92.2) whose
 * code BB71 == 1 ("HELL") -> BB90 = 2. */
void bt_wait_hello(void)                               /* 0730E8 */
{
    if (sub_link_up_813E == 0) return;
    if (!(sd_rx_flags_BA92 & 0x04)) return;
    sd_rx_flags_BA92 &= ~0x04;
    if (e4_code_BB71 == 1) bt_bringup = 2;
}

/* 07310C-07312A size 30  bt_autoconnect (sub_7310C) Confirmed:
 * BB90 == 2.  When timer 9561 and BBE4 are clear, send F3D6 (sub_D2B2,
 * "link now"), BB8E = 2 (connect), BB90 = 3. */
void bt_autoconnect(void)                              /* 07310C */
{
    if (timer_9561 || cell_BBE4) return;
    send_F3D6_D2B2();  bt_userop = 2;  bt_bringup = 3;
}

/* ------------------------------------------------------------------------ *
 * 07312A-073162  size 56   bt_running   (sub_7312A)   Confirmed
 * BB90 == 3.  Pending delete (BB8F.1) -> bt_wait_delete_ack (073358).
 * Linked (BB70 == 0) -> bt_watch_unpair (073310).  Otherwise dispatch the
 * user operation off_73162[BB8E]: 0 rts, 1 bt_search 073172,
 * 2 bt_connect 073280, 3 bt_await_connected 0732C8.
 * ------------------------------------------------------------------------ */
void bt_running(void)                                  /* 07312A */
{
    if (bt_flags_BB8F & 0x02) { bt_wait_delete_ack(); return; }
    if (bt_status == 0)       { bt_watch_unpair();    return; }
    if (bt_userop == 0) return;
    off_73162[bt_userop]();
}

/* ------------------------------------------------------------------------ *
 * 073172-0731C0  size 78   bt_search   (sub_73172)   Confirmed
 * BB8E == 1.  E4 0x12 (FIND result) -> BB70 = 0x12, add device, redraw.
 * E4 0x11 (search timeout, no device) -> BB70 = 0x11, error tone 0x1D,
 * redraw, BB8E = 0.  E4 0x10 ignored.  (07319E: dead "BBE1 = 0" arm.)
 * ------------------------------------------------------------------------ */
void bt_search(void)                                   /* 073172 */
{
    if (!(sd_rx_flags_BA92 & 0x04)) return;
    sd_rx_flags_BA92 &= ~0x04;
    u8 c = e4_code_BB71;
    if (c == 0x12) { bt_status = c; bt_add_device(); redraw_flags_817E |= 2; }
    else if (c == 0x11) {
        bt_status = c;  tone_event = 0x1D;
        redraw_flags_817E |= 2;  bt_userop = 0;
    }
}

/* ------------------------------------------------------------------------ *
 * 0731C0-073268  size 168  bt_add_device   (sub_731C0)   Confirmed
 * The E4 record tail BB72 (28 B: 16-char name + 12-char address) is looked
 * up in the 5-slot device list AAEC (stride 0x1C, count AAEA, "unseen"
 * bitmap AAEB).  Already known -> select it (8EB0 = slot, clear its AAEB
 * bit), return 0.  List full (count >= 5) -> count = 5, return 0xFF.
 * Else take the first empty slot (first byte has bit 7 set), select it,
 * count++, copy the record, save the list to EEPROM (sub_3CDA0, 0x8E B at
 * 0x1EA00 per doc 124), redraw, cursor AD68 = slot+1, return 1.
 * ------------------------------------------------------------------------ */
u8 bt_add_device(void)                                 /* 0731C0 */
{
    u8 *slot = bt_devlist;                             /* FFAAEC            */
    for (u16 i = 0; i < 5; i++, slot += 0x1C) {
        if (memcmp(slot, e4_record_BB72, 0x1C) == 0) {
            bt_sel_8EB0 = (u8)i;  bt_unseen_AAEB &= ~(1u << i);
            return 0;
        }
    }
    if (bt_devcount_AAEA >= 5) goto full;
    slot = bt_devlist;
    for (u16 i = 0; i < 5; i++, slot += 0x1C) {
        if (slot[0] & 0x80) {                          /* empty             */
            bt_sel_8EB0 = (u8)i;  bt_unseen_AAEB &= ~(1u << i);
            bt_devcount_AAEA++;
            memcpy(slot, e4_record_BB72, 0x1C);
            bt_devlist_save_3CDA0();
            redraw_flags_817E |= 2;
            bt_cursor_from_sel();
            return 1;
        }
    }
full:
    bt_devcount_AAEA = 5;
    return 0xFF;
}

/* 073268 / 073274  size 12 each   Confirmed
 * bt_cursor_from_sel (sub_73268): AD68 = 8EB0 + 1.
 * bt_sel_from_cursor (sub_73274): 8EB0 = AD68 - 1. */
void bt_cursor_from_sel(void) { edit_mode_AD68 = bt_sel_8EB0 + 1; } /* 073268 */
void bt_sel_from_cursor(void) { bt_sel_8EB0 = edit_mode_AD68 - 1; } /* 073274 */

/* 073280-0732A4 size 36  bt_connect (sub_73280) Confirmed:
 * BB8E == 2.  E4 3 ("LINK") -> BB70 = 8EAF = 3, BB8E = 3, then falls into
 * bt_resend_link_unless_screen1E (0732A4). */
void bt_connect(void)                                  /* 073280 */
{
    if (!(sd_rx_flags_BA92 & 0x04)) return;
    sd_rx_flags_BA92 &= ~0x04;
    if (e4_code_BB71 != 3) return;
    bt_status = 3;  bt_subop_8EAF = 3;  bt_userop = 3;
    bt_resend_link_unless_screen1E();
}

/* 0732A4-0732C8 size 36  bt_resend_link_unless_screen1E (sub_732A4)
 * Confirmed: on screen 0x1E (Bluetooth screen) just redraw, else re-send
 * F3D6 (doc 124 row 5). */
void bt_resend_link_unless_screen1E(void)              /* 0732A4 */
{
    struct screen *s = current_record_10748();
    if (s->id == 0x1E) redraw_flags_817E |= 2;
    else               send_F3D6_D2B2();
}

/* 0732C8-073310 size 72  bt_await_connected (sub_732C8) Confirmed:
 * BB8E == 3.  E4 0 ("PAIR", linked) -> BB70 = 8EAF = 0, redraw, BB8E = 0.
 * E4 5 (link failure) -> bt_set_idle, popup 6, redraw, BB8E = 0. */
void bt_await_connected(void)                          /* 0732C8 */
{
    if (!(sd_rx_flags_BA92 & 0x04)) return;
    sd_rx_flags_BA92 &= ~0x04;
    u8 c = e4_code_BB71;
    if (c == 5) {
        bt_set_idle();  popup_id = 6;  redraw_flags_817E |= 2;  bt_userop = 0;
    } else if (c == 0) {
        bt_status = 0;  bt_subop_8EAF = 0;  redraw_flags_817E |= 2;  bt_userop = 0;
    }
}

/* 073310-07333A size 42  bt_watch_unpair (sub_73310) Confirmed:
 * while linked, E4 2 (remote PAIR=0) -> BB70 = 8EAF = 2, BB8E = 2, redraw,
 * then falls into 07333A. */
void bt_watch_unpair(void)                             /* 073310 */
{
    if (!(sd_rx_flags_BA92 & 0x04)) return;
    sd_rx_flags_BA92 &= ~0x04;
    if (e4_code_BB71 != 2) return;
    bt_status = 2;  bt_subop_8EAF = 2;  bt_userop = 2;  redraw_flags_817E |= 2;
    bt_relink_unless_screen1E();
}

/* 07333A-073358 size 30  bt_relink_unless_screen1E (sub_7333A) Confirmed:
 * off screen 0x1E restart the auto-connect (BB90 = 2). */
void bt_relink_unless_screen1E(void)                   /* 07333A */
{
    struct screen *s = current_record_10748();
    if (s->id != 0x1E) bt_bringup = 2;
}

/* ------------------------------------------------------------------------ *
 * 073358-0733E0  size 136  bt_wait_delete_ack   (sub_73358)   Confirmed
 * After the user deleted a paired device: on E4 9 clear BB8F.1; if the list
 * is non-empty: count--, close the gap with the memmove record
 * 0733E0[AD68-1] ({u16 len, src, dst}: 0x70/AB08->AAEC, 0x54/AB24->AB08,
 * 0x38/AB40->AB24, 0x1C/AB5C->AB40, 0/AB5C->AB5C), blank the last slot
 * FFAB5C from ROM 00F6D6 (0x1C B), save (sub_3CDA0), select slot 0 and
 * set the cursor.  Always redraw.
 * ------------------------------------------------------------------------ */
void bt_wait_delete_ack(void)                          /* 073358 */
{
    if (!(sd_rx_flags_BA92 & 0x04)) return;
    sd_rx_flags_BA92 &= ~0x04;
    if (e4_code_BB71 != 9) return;
    bt_flags_BB8F &= ~0x02;
    if (bt_devcount_AAEA) {
        bt_devcount_AAEA--;
        const struct { u16 len; u8 *src; u8 *dst; } *r = &ROM_0733E0[edit_mode_AD68 - 1];
        if (r->len) memcpy(r->dst, r->src, r->len);
        memcpy(bt_devlist + 4 * 0x1C, ROM_00F6D6_BLANK_DEV, 0x1C);
        bt_devlist_save_3CDA0();
        bt_sel_8EB0 = 0;
        bt_cursor_from_sel();
    }
    redraw_flags_817E |= 2;
}

/* ------------------------------------------------------------------------ *
 * 073412-0734B0  size 158  bt_sco_hold   (sub_73412)   Confirmed
 * (doc 124: "SCO needed" = BB8F.7 clear.)  Only in Bluetooth save mode
 * (8920.0 and 8920.7 set, VOX 89BB == 0); otherwise BB8F.7 is cleared.
 * Audio activity (TX keyed, or the selected band's busy byte A9AC/A9AD ==
 * 0xFF, or BB8F.6 with BC6F == 0) -> 0734 8C: hold 95A1 = 100 and clear
 * BB8F.7 (redraw if it changes).  No activity and the hold expired -> set
 * BB8F.7 (redraw).
 * ------------------------------------------------------------------------ */
void bt_sco_hold(void)                                 /* 073412 */
{
    if (!(bt_setting_8920 & 0x01) || vox_89BB != 0 || !(bt_setting_8920 & 0x80)) {
        bt_flags_BB8F &= ~0x80;  return;               /* 0734A8            */
    }
    int active = 0;
    if (tx_state == 1) active = 1;
    else if (band_sel_8EA0 & 0x80) {
        if (busy_A9AC == 0xFF) active = 1;
        else goto check_b;
    } else if (band_sel_8EA0 & 0x40) {
        if (busy_A9AC == 0xFF) active = 1;
        /* else 073470: no further checks */
    } else {
check_b:
        if (busy_A9AD == 0xFF) active = 1;
        else if ((bt_flags_BB8F & 0x40) && cell_BC6F == 0) active = 1;
    }
    if (active) { bt_sco_keep(); return; }             /* 07348C            */
    if (bt_hold_95A1) return;
    if (bt_flags_BB8F & 0x80) return;
    redraw_flags_817E |= 2;  bt_flags_BB8F |= 0x80;
}
/* 07348C (sub_7348C, a tail of the above) */
void bt_sco_keep(void)                                 /* 07348C */
{
    bt_hold_95A1 = 0x64;
    if (!(bt_flags_BB8F & 0x80)) return;
    redraw_flags_817E |= 2;  bt_flags_BB8F &= ~0x80;
}

/* 0734B0-0734BE size 14  bt_sco_force (sub_734B0) Confirmed:
 * 95A1 = 200, clear BB8F.7 (keep SCO for 2 s). */
void bt_sco_force(void) { bt_hold_95A1 = 0xC8; bt_flags_BB8F &= ~0x80; } /* 0734B0 */

/* 0734BE-0734C2 size 4  clone_version_byte (sub_734BE) Confirmed:
 * returns 2 = the version byte of the "AH72M" clone/backup ID. */
u8 clone_version_byte(void) { return 2; }              /* 0734BE */

/* ------------------------------------------------------------------------ *
 * 0734C2-0734F4  size 50   extport_restore   (sub_734C2)   Confirmed
 * After a clone send (doc 24): re-inits the RX ring and reprograms SCI_4
 * (FFFE90 SMR=0, FFFE91 BRR=0x0C, FFFE92 SCR: 0 -> 0x30 -> +RIE b6), module
 * stop bit FB95.1, clone state 8131 = 0.
 * ------------------------------------------------------------------------ */
void extport_restore(void)                             /* 0734C2 */
{
    extport_ring_init();                               /* sub_734F4         */
    SCI4_SCR = 0;  MSTPCR_FB95 |= 0x02;  SCI4_SMR = 0;
    SCI4_BRR = 0x0C;
    clone_state_8131 = 0;
    SCI4_SCR = 0x30;  /* 3 x nop */  SCI4_SCR |= 0x40;
}

/* 0734F4-07351E size 42  extport_ring_init (sub_734F4) Confirmed:
 * 817F.7, AA35.0, RX ring head/tail 8132/8136 = FF95F8 (ring FF95F8-
 * FF96F7), latch bit 817B.5 on (sub_37A56: route the DATA jack). */
void extport_ring_init(void)                           /* 0734F4 */
{
    flags_817F |= 0x80;  flags_AA35 |= 0x01;
    ext_rx_head = ext_rx_tail = (u8 *)0xFF95F8;        /* 8132 / 8136       */
    latch_817B |= 0x20;  latch_shift_out_37A56();
}

/* 07351E-073540 size 34  extport_boot_mode (sub_7351E) Confirmed:
 * FF8004 (remote/clone mode byte) 0 -> nothing; != 3 -> clone port setup
 * (073540); == 3 (after node reset command '1') -> port setup then
 * enter remote mode (sub_73AFE). */
void extport_boot_mode(void)                           /* 07351E */
{
    if (remote_mode_8004 == 0) return;
    if (remote_mode_8004 != 3) { extport_clone_setup(); return; }
    extport_clone_setup();  /* 8 x nop */
    node_cmd_0_enter_remote();
}

/* 073540-07357A size 58  extport_clone_setup (sub_73540) Confirmed:
 * SCI_4 19200 8N1 polled (BRR FFFE91 = 0x19), FF8004 = 1, node parser
 * phase 97FE = 4 (ready), SCR = 0x30 | 0x40; returns 1. */
u8 extport_clone_setup(void)                           /* 073540 */
{
    extport_ring_init();
    SCI4_SCR = 0;  MSTPCR_FB95 |= 0x02;  SCI4_SMR = 0;  SCI4_BRR = 0x19;
    remote_mode_8004 = 1;  node_phase_97FE = 4;
    SCI4_SCR = 0x30;  SCI4_SCR |= 0x40;
    return 1;
}

/* 07357A-07358E size 20  region_code_get (sub_7357A) Confirmed:
 * er4 = {00, FF800F, FF8010, FF8011} = the 3-byte region/market code
 * (doc 96), compared by the clone/backup ID check. */
u32 region_code_get(void)                              /* 07357A */
{
    return ((u32)market_800F << 16) | ((u32)market_8010 << 8) | market_8011;
}

/* ------------------------------------------------------------------------ *
 * 07358E-0735DE (+0735DE-0735EF oracle-only) size 80   clone_receive
 *   (sub_7358E)   Confirmed;  continues in sub_735F0 (0735F0-073686, 150).
 * Cable clone receive (doc 24 surface B): state 8131 = 1, sum 812E = 0;
 * wait for 'A' and the 10-byte header (clone_rx_header 0736E6), check the
 * "AH72M"/version/region ID (clone_id_check 0737C8); state 2, redraw,
 * mark EEPROM "MARU" (copy ROM 00DD16 -> FF8006, sub_39512), send ACK 0x06
 * (sub_73AB4).  Then 0x3FB blocks of 64 B -> EEPROM 0x140.. (sub_3B770)
 * and 0x3FC blocks -> 0x10100.. (sub_3C99C) with progress (073686/0736B6),
 * read the trailer (state 0), compare with the 8-bit sum: equal ->
 * sub_75EB6, "TAIS" (sub_39504), mask interrupts and jmp 0x2050 (reboot);
 * any failure -> state 4, redraw.
 * ------------------------------------------------------------------------ */
void clone_receive(void)                               /* 07358E */
{
    clone_sum_812E = 0;  clone_state_8131 = 1;
    ui_refresh_45F6();
    if (clone_rx_header() != 0) goto fail;
    if (clone_id_check() != 0) goto fail;              /* Z clear = bad     */
    clone_state_8131 = 2;  redraw_flags_817E |= 2;  ui_refresh_45F6();
    eeprom_marker_8006 = *(u32 *)ROM_00DD16_MARU;      /* "MARU"            */
    eeprom_marker_save_39512();
    ext_send_ack();                                    /* sub_73AB4         */
    u32 a = 0x140;
    for (u16 n = 0x3FB; n; n--, a += 0x40) {           /* 0735DE            */
        if (ext_rx_block(clone_buf_96F8, 0x40)) goto fail;
        eep_write_block_3B770(a, clone_buf_96F8);
        clone_progress_a(n);                           /* sub_73686         */
    }
    a = 0x10100;
    for (u16 n = 0x3FC; n; n--, a += 0x40) {
        if (ext_rx_block(clone_buf_96F8, 0x40)) goto fail;
        eep_write_block_3C99C(a, clone_buf_96F8);
        clone_progress_b(n);                           /* sub_736B6         */
    }
    clone_state_8131 = 0;
    if (ext_rx_block(&clone_trailer_812F, 1)) goto fail;
    if (clone_sum_812E != clone_trailer_812F) goto fail;
    apply_hook_75EB6();
    eeprom_marker_tais_39504();
    disable_interrupts();  goto_0x2050();              /* reboot            */
fail:                                                  /* 073678            */
    clone_state_8131 = 4;  redraw_flags_817E |= 2;
}
void clone_receive_tail_735F0(void) { /* body is the loop above, 0735F0 */ }

/* 073686-0736A2 size 28  clone_progress_a (sub_73686) Confirmed:
 * if the remaining block count r1 equals 0x3FB - 0xDC*k (k = 0..4) set the
 * progress segment A9DD = k+1 and fall into 0736A2 (redraw + refresh). */
void clone_progress_a(u16 left)                        /* 073686 */
{
    u16 mark = 0x3FB;
    for (u8 seg = 1; seg < 6; seg++, mark -= 0xDC)
        if (left == mark) { progress_A9DD = seg; clone_redraw(); return; }
}
/* 0736A2-0736B6 size 20  clone_redraw (sub_736A2) Confirmed:
 * 817E.1 and loc_45F6 (screen refresh), preserving er0/er1. */
void clone_redraw(void) { redraw_flags_817E |= 2; ui_refresh_45F6(); } /* 0736A2 */

/* 0736B6-0736D2 size 28  clone_progress_b (sub_736B6) Confirmed:
 * same for region B: segments 6..10 at 0x3FC - 0xDC*k. */
void clone_progress_b(u16 left)                        /* 0736B6 */
{
    u16 mark = 0x3FC;
    for (u8 seg = 6; seg < 0x0B; seg++, mark -= 0xDC)
        if (left == mark) { progress_A9DD = seg; clone_redraw2(); return; }
}
/* 0736D2-0736E6 size 20  clone_redraw2 (sub_736D2) Confirmed: copy of 0736A2. */
void clone_redraw2(void) { redraw_flags_817E |= 2; ui_refresh_45F6(); } /* 0736D2 */

/* ------------------------------------------------------------------------ *
 * 0736E6-07374A  size 100  clone_rx_header   (sub_736E6)   Confirmed
 * Waits, unbounded, servicing timers (sub_3576, sub_325A), for the sync
 * byte 'A' in the RX ring (FF95F8..FF96F7, head 8132, tail 8136); bytes
 * before it are dropped.  'A' is stored at FF96F8 and summed, then the
 * remaining 9 header bytes are read with ext_rx_block (falls into 07374A
 * with r3 = 9, er5 = FF96F9).
 * ------------------------------------------------------------------------ */
u8 clone_rx_header(void)                               /* 0736E6 */
{
    u8 c;
    for (;;) {
        timers_3576();  timers_325A();
        if (ext_rx_head == ext_rx_tail) continue;
        c = *ext_rx_head++;
        if (ext_rx_head >= (u8 *)0xFF96F8) ext_rx_head = (u8 *)0xFF95F8;
        if (c == 'A') break;
    }
    clone_buf_96F8[0] = c;  clone_sum_812E += c;
    return ext_rx_block(clone_buf_96F8 + 1, 9);
}

/* ------------------------------------------------------------------------ *
 * 07374A-0737A8  size 94   ext_rx_block   (sub_7374A)   Confirmed
 * Reads r3 bytes from the RX ring into er5.  Each byte waits at most
 * 0x4B0 ticks of the 94B8 timer flag (reloaded to 2 per tick); timeout ->
 * returns 1.  In clone states 1/2 each byte is added to the 8-bit sum 812E.
 * ------------------------------------------------------------------------ */
u8 ext_rx_block(u8 *dst, u16 n)                        /* 07374A */
{
    do {
        u16 t = 0x4B0;
        while (ext_rx_head == ext_rx_tail) {
            if (tick_94B8) continue;
            tick_94B8 = 2;
            if (--t == 0) return 1;
        }
        u8 c = *ext_rx_head++;
        *dst++ = c;
        if (clone_state_8131 == 1 || clone_state_8131 == 2) clone_sum_812E += c;
        if (ext_rx_head >= (u8 *)0xFF96F8) ext_rx_head = (u8 *)0xFF95F8;
    } while (--n);
    return 0;
}

/* 0737A8-0737C8 size 32  clone_send_header_wait_ack (sub_737A8) Confirmed:
 * send r3 bytes (sub_738CC), then read single bytes until 0x06 arrives;
 * timeout -> 1. */
u8 clone_send_header_wait_ack(const u8 *p, u16 n)      /* 0737A8 */
{
    ext_tx_block(p, n);
    do { if (ext_rx_block(clone_buf_96F8, 1)) return 1; }
    while (clone_buf_96F8[0] != 0x06);
    return 0;
}

/* ------------------------------------------------------------------------ *
 * 0737C8-0737FC  size 52   clone_id_check   (sub_737C8)   Confirmed
 * Header at FF96F8: bytes 0..4 == "AH72M" (ROM 0738A2), byte 5 == 2
 * (clone_version_byte), bytes 6..9 == region_code_get().  Result in Z
 * (0 = match).  Also used by the BACKUP.dat restore (pc-02).
 * ------------------------------------------------------------------------ */
u8 clone_id_check(void)                                /* 0737C8 */
{
    if (memcmp(clone_buf_96F8, "AH72M", 5)) return 1;
    if (clone_buf_96F8[5] != clone_version_byte()) return 1;
    return *(u32 *)(clone_buf_96F8 + 6) != region_code_get();
}

/* ------------------------------------------------------------------------ *
 * 0737FC-07382A size 46  clone_send (sub_737FC) Confirmed; continues in
 * 07382A-0738A2 size 120 clone_send_body (sub_7382A).
 * State 3, sum 0; build the header (clone_build_header 07390A); send it and
 * wait for ACK; stream EEPROM 0x140 (0x3FB x 64, sub_3AB80 read) and
 * 0x10100 (0x3FC x 64, sub_3BDAC read) with clone_send_block and
 * progress; send the 1-byte sum; restore the port.  Failure -> state 4.
 * ------------------------------------------------------------------------ */
void clone_send(void)                                  /* 0737FC */
{
    clone_state_8131 = 3;  clone_sum_812E = 0;
    ui_refresh_45F6();
    clone_build_header();
    if (clone_send_header_wait_ack(clone_buf_96F8, 10)) {
        clone_state_8131 = 4;  redraw_flags_817E |= 2;  return; /* 073894 */
    }
    u32 a = 0x140;
    for (u16 n = 0x3FB; n; n--, a += 0x40) {           /* 07382A            */
        eep_read_3AB80(a, clone_buf_96F8, 0x40);
        clone_send_block();                            /* 0738AC            */
        clone_progress_a(n);
    }
    a = 0x10100;
    for (u16 n = 0x3FC; n; n--, a += 0x40) {
        i2c_eep_read_3BDAC(a, clone_buf_96F8, 0x40);
        clone_send_block();
        clone_progress_b(n);
    }
    ext_tx_block(&clone_sum_812E, 1);
    extport_restore();
    redraw_flags_817E |= 2;
}

/* 0738AC-0738CC size 32  clone_send_block (sub_738AC) Confirmed:
 * send 64 bytes of FF96F8, then wait 5 ticks of the 94B8 flag. */
void clone_send_block(void)                            /* 0738AC */
{
    ext_tx_block(clone_buf_96F8, 0x40);
    for (u8 i = 5; i; i--) { while (tick_94B8) ; tick_94B8 = 2; }
}

/* ------------------------------------------------------------------------ *
 * 0738CC-073908  size 60   ext_tx_block   (sub_738CC)   Confirmed
 * Polled SCI_4 transmit: wait TDRE (SSR FFFE94.7), write TDR FFFE93, clear
 * TDRE; in clone state 3 add each byte to the sum; finally wait TEND
 * (SSR.2) and store the sum back.
 * ------------------------------------------------------------------------ */
void ext_tx_block(const u8 *p, u16 n)                  /* 0738CC */
{
    u8 sum = clone_sum_812E, st = clone_state_8131;
    do {
        while (!(SCI4_SSR & 0x80)) ;
        u8 c = *p++;
        SCI4_TDR = c;  SCI4_SSR &= 0x7F;
        if (st == 3) sum += c;
    } while (--n);
    while (!(SCI4_SSR & 0x04)) ;
    if (st == 3) clone_sum_812E = sum;
}

/* 07390A-073930 size 38  clone_build_header (sub_7390A) Confirmed:
 * FF96F8 = "AH72M", [5] = 2, [6..9] = region code.  (073908/073909 hold
 * the ACK 0x06 / NAK 0x15 bytes; IDA's "sub_73908" is that data.) */
void clone_build_header(void)                          /* 07390A */
{
    memcpy(clone_buf_96F8, "AH72M", 5);
    clone_buf_96F8[5] = clone_version_byte();
    *(u32 *)(clone_buf_96F8 + 6) = region_code_get();
}

/* ------------------------------------------------------------------------ *
 * 073930-073974  size 68   node_rx_poll   (sub_73930)   Confirmed
 * Pulls at most one byte from the DATA-jack RX ring (r2l = byte, r2h =
 * 1 if one was read) and runs the node-command parser phase off_73974
 * [97FE] (doc 104 sec.2): 0 nullsub_96, 1 node_ph1_len, 2 node_ph2_data,
 * 3 node_ph3_dispatch, 4 node_ph4_cmd, 5 node_ph5_err, 6 node_ph6_resync.
 * er0 = current record from sub_10748 (passed to the handlers).
 * ------------------------------------------------------------------------ */
void node_rx_poll(void)                                /* 073930 */
{
    struct rec *er0 = current_record_10748();
    u8 got = 0, c = 0;
    if (ext_rx_head != ext_rx_tail) {
        c = *ext_rx_head++;
        if (ext_rx_head >= (u8 *)0xFF96F8) ext_rx_head = (u8 *)0xFF95F8;
        got = 1;
    }
    off_73974[node_phase_97FE](er0, c, got);
}

/* 073990 nullsub_96 (phase 0, idle) */
void nullsub_96(void) { }                              /* 073990 */

/* 073992-0739C4 size 50  node_ph1_len (sub_73992) Confirmed:
 * the byte after the command is its argument count; must equal
 * byte_74532[cmd] unless that is 0xFF (variable).  Store it (node_store),
 * 97FD = count, phase 2; mismatch -> phase 5. */
void node_ph1_len(struct rec *er0, u8 c, u8 got)       /* 073992 */
{
    if (!got) return;
    s8 want = (s8)ROM_074532_ARGLEN[node_cmd_97FC];
    if (want >= 0 && (u8)want != c) { node_phase_97FE = 5; return; }
    node_store(c);  node_left_97FD = c;  node_phase_97FE = 2;
}

/* 0739C4-0739DA size 22  node_store (sub_739C4) Confirmed:
 * FF96F8[97FB++] = byte (@(-0x6908,er4) = FF96F8 + idx). */
void node_store(u8 c) { node_buf_96F8[node_cnt_97FB++] = c; } /* 0739C4 */

/* 0739DA-0739FA size 32  node_ph2_data (sub_739DA) Confirmed:
 * store data bytes; when the count reaches 0: 9547 = 2 (2-tick gap timer)
 * and phase 3. */
void node_ph2_data(struct rec *er0, u8 c, u8 got)      /* 0739DA */
{
    if (!got) return;
    node_store(c);
    if (--node_left_97FD == 0) { timer_9547 = 2; node_phase_97FE = 3; }
}

/* ------------------------------------------------------------------------ *
 * 0739FA-073A54  size 90   node_ph3_dispatch   (sub_739FA)   Confirmed
 * Any further byte -> phase 5.  After the 9547 gap: additive checksum over
 * FF96F8[0 .. count] (count = FF96F9 + 1 bytes: command, count, args) must
 * equal the next byte; then r1 = args (96FA), e1 = 0, call
 * off_74472[97FC](er0, r1); bad sum -> NAK (073AC2).  Back to phase 4.
 * ------------------------------------------------------------------------ */
void node_ph3_dispatch(struct rec *er0, u8 c, u8 got)  /* 0739FA */
{
    if (got) { node_phase_97FE = 5; return; }
    if (timer_9547) return;
    u8 n = node_buf_96F8[1] + 1, s = 0;
    const u8 *p = node_buf_96F8;
    while (n--) s += *p++;
    if (*p == s) off_74472[node_cmd_97FC](er0, *(u16 *)(node_buf_96F8 + 2));
    else         ext_send_nak();
    node_phase_97FE = 4;
}

/* 073A54-073A86 size 50  node_ph4_cmd (sub_73A54) Confirmed (doc 104):
 * accept '0'..'_' ('0' always, the rest only in remote mode 8004 >= 2):
 * 97FC = byte - '0', 97FB = 0, store the byte, phase 1. */
void node_ph4_cmd(struct rec *er0, u8 c, u8 got)       /* 073A54 */
{
    if (!got || c < '0') return;
    if (c != '0') {
        if (c >= 0x60) return;
        if (remote_mode_8004 < 2) return;
    }
    node_cmd_97FC = c - '0';  node_cnt_97FB = 0;
    node_store(c);
    node_phase_97FE = 1;
}

/* 073A86-073A98 size 18  node_ph5_err (sub_73A86) Confirmed:
 * once the line is quiet: 9547 = 10, phase 6. */
void node_ph5_err(struct rec *er0, u8 c, u8 got)       /* 073A86 */
{
    if (got) return;
    timer_9547 = 0x0A;  node_phase_97FE = 6;
}

/* 073A98-073AB4 size 28  node_ph6_resync (sub_73A98) Confirmed:
 * a byte arriving -> back to phase 5; quiet for 10 ticks -> phase 4 and
 * NAK. */
void node_ph6_resync(struct rec *er0, u8 c, u8 got)    /* 073A98 */
{
    if (got) { node_phase_97FE = 5; return; }
    if (timer_9547) return;
    node_phase_97FE = 4;  ext_send_nak();
}

/* ------------------------------------------------------------------------ *
 * 073AB4-073AEC  size 56   ext_send_ack   (sub_73AB4)   Confirmed
 * Entries: 073AB4 send 1 byte 0x06 (ROM 073908); 073AC2 ext_send_nak:
 * 1 byte 0x15 (073909); 073AD0 ext_send_reply(r4 = length 8130):
 * checksum (sub_73AEC) and send FF96F8[0..len).  Length is kept in 8130.
 * ------------------------------------------------------------------------ */
void ext_send_ack(void)                                /* 073AB4 */
{ ext_tx_len_8130 = 1; ext_tx_block(ROM_073908_ACK, 1); }
void ext_send_nak(void)                                /* 073AC2 */
{ ext_tx_len_8130 = 1; ext_tx_block(ROM_073909_NAK, 1); }
void ext_send_reply(void)                              /* 073AD0 */
{
    node_checksum_append(node_buf_96F8, ext_tx_len_8130);
    ext_tx_block(node_buf_96F8, ext_tx_len_8130);
}

/* 073AEC-073AFE size 18  node_checksum_append (sub_73AEC) Confirmed:
 * sum of the first len-1 bytes of er1 stored at er1[len-1]. */
void node_checksum_append(u8 *p, u16 len)              /* 073AEC */
{
    u8 s = 0;
    for (u16 i = len - 1; i; i--) s += *p++;
    *p = s;
}

/* ------------------------------------------------------------------------ *
 * 073AFE-073B62  size 100  node_cmd_0_enter_remote   (sub_73AFE) Confirmed
 * Node command '0' (slot 0): remote mode 8004 = 2, AA35.1, clear 89C0.7,
 * 8010 = 8011 = 1 (doc 96: does not touch 800F), clear 8ABE.6, link state
 * 94FE = 1, sub_2D7C, redraw, ACK, TOT 89BA = 0, B0CC = 0; if the callsign
 * FF8D26 is unset (0xFF) load the 10-byte default from ROM 073B62 and run
 * sub_19954 / sub_323C.
 * ------------------------------------------------------------------------ */
void node_cmd_0_enter_remote(void)                     /* 073AFE */
{
    remote_mode_8004 = 2;  flags_AA35 |= 0x02;  setting_89C0 &= ~0x80;
    market_8010 = 1;  market_8011 = 1;
    setting_8ABE &= ~0x40;
    link_state_94FE = 1;
    sub_2D7C();
    redraw_flags_817E |= 2;
    ext_send_ack();
    tot_89BA = 0;  dsp_txmode_B0CC = 0;
    if (callsign_8D26[0] == 0xFF) {
        memcpy(callsign_8D26, ROM_073B62, 10);
        sub_19954();  sub_323C();
    }
}
/* ************************************************************************** *
 * PART 4  073B6C-074472 : node-command handlers off_74472['0'..'_']
 * (doc 104 table.tsv).  Calling convention for every handler:
 *   er0 = current record (sub_10748), r1 = first two argument bytes
 *   (r1h = arg0 = FF96FA, r1l = arg1 = FF96FB), FF96FC.. further args.
 * Replies are staged at FF96F8 = {tag, length}, data from FF96FA, total
 * length in 8130, and sent by ext_send_reply (073AD0, appends a checksum).
 * "ACK"/"NAK" = ext_send_ack / ext_send_nak (single 0x06 / 0x15 byte).
 * ************************************************************************** */

/* 073B6C-073BB4 size 72  node_cmd_2_identity (sub_73B6C) Confirmed:
 * '2': sub_39534, reply tag '2' len 0x0A: {version 2, region long FF800E,
 * 0x0102 0x0000}; 8010 = 8011 = 1; length 12. */
void node_cmd_2_identity(void)                         /* 073B6C */
{
    sub_39534();
    *(u16 *)node_buf_96F8 = 0x320A;
    *(u16 *)(node_buf_96F8 + 2) = clone_version_byte();     /* 00 02        */
    *(u32 *)(node_buf_96F8 + 4) = *(u32 *)&market_800E;     /* FF800E..11   */
    *(u32 *)(node_buf_96F8 + 8) = 0x01020000;
    market_8010 = 1;  market_8011 = 1;
    ext_tx_len_8130 = 0x0C;
    ext_send_reply();
}

/* ------------------------------------------------------------------------ *
 * 073BB4-073BE2  size 46   node_cmd_3_ptt   (sub_73BB4)   Confirmed
 * '3': injects a key index into FFA9ED (dispatched like a key press):
 *   not transmitting: arg 1 -> 0x0E (PTT press), arg 0 -> 0x0F (release)
 *   transmitting:     arg 0 -> 0x0F, arg 1 -> stores r4l, which still holds
 *                     FF94C0 (= 1), i.e. key index 1 - looks like a source
 *                     bug; a second "press" while keyed is not a press.
 *   other args -> NAK.
 * CORRECTION to doc 104 / table.tsv: the polarity is arg 1 = press, arg 0 =
 * release (0x0E / 0x0F are the remapped PTT codes 0x17-9 / 0x18-9, doc 108).
 * ------------------------------------------------------------------------ */
void node_cmd_3_ptt(u8 arg0)                           /* 073BB4 */
{
    u8 k;
    if (tx_state == 1) {
        if (arg0 == 1)      k = tx_state;              /* = 1 (!)           */
        else if (arg0 == 0) k = 0x0F;
        else { ext_send_nak(); return; }
    } else {
        if (arg0 == 0)      k = 0x0F;
        else if (arg0 == 1) k = 0x0E;
        else { ext_send_nak(); return; }
    }
    key_event = k;                                     /* FFA9ED            */
    ext_send_ack();
}

/* ------------------------------------------------------------------------ *
 * 073BE2-073C02  size 32   node_cmd_4_ram_peek   (sub_73BE2)   Confirmed
 * '4': args {addr_hi, addr_lo, n}; n = 1..0x80 (node_len_check).  Reply
 * tag '4', length n+1, data = n bytes copied from er5 = 0x00FF0000 | r1
 * (073BEC: mov.w r1,r5 ; mov.w #0xFF,e5), i.e. ANY address FF0000-FFFFFF:
 * on-chip RAM and the I/O register page.
 * CONTRADICTS doc 104 ("no node command exposes host-chosen memory
 * access"): in remote mode (FF8004 >= 2, entered with command '0') the
 * DATA-jack host can read any FFxxxx byte with '4'.
 * ------------------------------------------------------------------------ */
void node_cmd_4_ram_peek(u16 r1)                       /* 073BE2 */
{
    u8 len;
    if (node_len_check(&len)) return;
    node_buf_96F8[0] = '4';  node_buf_96F8[1] = len;   /* len = n+1         */
    memcpy(node_buf_96F8 + 2, (u8 *)(0x00FF0000u | r1), len - 1);
    ext_send_reply();                                  /* 8130 = n+3        */
}

/* 073C02-073C24 size 34  node_len_check (sub_73C02) Confirmed:
 * length byte FF96FC must be 1..0x80: 8130 = len+3, r2l = len+1, return 0;
 * otherwise NAK and return 1 (r6l). */
u8 node_len_check(u8 *r2l)                             /* 073C02 */
{
    u8 n = node_buf_96F8[4];
    if (n == 0 || n >= 0x81) { ext_send_nak(); return 1; }
    ext_tx_len_8130 = n + 3;  *r2l = n + 1;
    return 0;
}

/* ------------------------------------------------------------------------ *
 * 073C24-073C3E  size 26   node_cmd_5_ram_poke   (sub_73C24)   Confirmed
 * '5': args {addr_hi, addr_lo, n, data[n]}: copies n (1..0x80) bytes from
 * FF96FD to er6 = 0x00FF0000 | r1 (073C2E: mov.w r1,r6 ; mov.w #0xFF,e6)
 * and ACKs.  A host-chosen WRITE anywhere in FF0000-FFFFFF (RAM and I/O
 * registers) - see the note on '4'.
 * ------------------------------------------------------------------------ */
void node_cmd_5_ram_poke(u16 r1)                       /* 073C24 */
{
    u8 len;
    if (node_len_check(&len)) return;
    memcpy((u8 *)(0x00FF0000u | r1), node_buf_96F8 + 5, len - 1);
    ext_send_ack();
}

/* 073C3E-073C48 size 10  node_cmd_6_eeprom_read (sub_73C3E) Confirmed,
 * falls into 073C48-073C66 size 30 node_eeprom_read_reply (sub_73C48):
 * '6': reply tag '6', read r4l bytes of EEPROM at address er1 (= the two
 * argument bytes, so 0..0xFFFF) into FF96FA (sub_3AB80) and send.  The
 * address is host-chosen (er0 = 0x0000xxxx from r1/e1 = 0), within the
 * 16-bit range of the EEPROM read helper sub_3AB80 (device A0/A1). */
void node_cmd_6_eeprom_read(u16 r1)                    /* 073C3E */
{
    u8 len;
    if (node_len_check(&len)) return;
    node_buf_96F8[0] = '6';  node_buf_96F8[1] = len;
    node_eeprom_read_reply(r1, len - 1);
}
void node_eeprom_read_reply(u32 addr, u8 n)            /* 073C48 */
{
    eep_read_3AB80(addr, node_buf_96F8 + 2, n);
    ext_send_reply();
}

/* 073C66-073C6C size 6  node_cmd_7_eeprom_write (sub_73C66) Confirmed,
 * falls into 073C6C-073C8A size 30 node_eeprom_write_ack (sub_73C6C):
 * '7': write r4l bytes from FF96FD to EEPROM address er1 (sub_3AD20); ACK.
 * NOTE: like '6' this is a host-chosen EEPROM address (16-bit, device
 * A0/A1), not a fixed region; doc 104 lists it as "fixed FF96FD". */
void node_cmd_7_eeprom_write(u16 r1)                   /* 073C66 */
{
    u8 len;
    if (node_len_check(&len)) return;
    node_eeprom_write_ack(r1, len - 1);
}
void node_eeprom_write_ack(u32 addr, u8 n)             /* 073C6C */
{
    eep_write_3AD20(addr, node_buf_96F8 + 5, n);
    ext_send_ack();
}

/* 073C8A-073CB0 size 38  node_cmd_8_read_8016 (sub_73C8A) Confirmed:
 * '8': reply 0x38 0x81 + 128 bytes of FF8016, length 0x83. */
void node_cmd_8_read_8016(void)                        /* 073C8A */
{
    *(u16 *)node_buf_96F8 = 0x3881;
    memcpy(node_buf_96F8 + 2, ram_8016, 0x80);
    ext_tx_len_8130 = 0x83;  ext_send_reply();
}

/* 073CB0-073CBA size 10  node_cmd_9_action (sub_73CB0) Confirmed:
 * '9': sub_39576 then ACK. */
void node_cmd_9_action(void) { sub_39576(); ext_send_ack(); } /* 073CB0 */

/* 073CBA-073CE0 size 38  node_cmd_colon_read_A98C (sub_73CBA) Confirmed:
 * ':': reply 0x3A 0x0D + 12 bytes FFA98C, length 15. */
void node_cmd_colon_read_A98C(void)                    /* 073CBA */
{
    *(u16 *)node_buf_96F8 = 0x3A0D;
    memcpy(node_buf_96F8 + 2, ram_A98C, 0x0C);
    ext_tx_len_8130 = 0x0F;  ext_send_reply();
}

/* 073CE0-073CFC size 28  node_cmd_semicolon_status (sub_73CE0) Confirmed:
 * ';': reply 0x3B 0x02 + byte @(0x84,er0), length 4. */
void node_cmd_semicolon_status(struct rec *er0)        /* 073CE0 */
{
    *(u16 *)node_buf_96F8 = 0x3B02;
    node_buf_96F8[2] = er0->b84;
    ext_tx_len_8130 = 4;  ext_send_reply();
}

/* ------------------------------------------------------------------------ *
 * 073CFC-073D4C  size 80   node_cmd_lt_set_mode   (sub_73CFC)   Inferred
 * '<': clear A9EE.7, A9ED = 5; arg0 is the wanted mode (1 or 2) of record
 * byte er0[5]: equal -> redraw + ACK; switch 2->1 via sub_1D3A4, 1->2 via
 * sub_1C7B2 and ACK if the key cell A9ED stayed non-negative; anything
 * else NAK.  Always leaves A9ED = 0xFF.
 * ------------------------------------------------------------------------ */
void node_cmd_lt_set_mode(struct rec *er0, u8 arg0)    /* 073CFC */
{
    key_flags_A9EE &= ~0x80;  key_event = 5;
    u8 cur = er0->b5;
    int ok = 0;
    if (arg0 == 1) {
        if (cur == 1) ok = 1;
        else if (cur == 2) { sub_1D3A4(); ok = (s8)key_event >= 0; }
    } else if (arg0 == 2) {
        if (cur == 2) ok = 1;
        else if (cur == 1) { sub_1C7B2(); ok = (s8)key_event >= 0; }
    }
    if (ok) { redraw_flags_817E |= 2; ext_send_ack(); }
    else    ext_send_nak();
    key_event = 0xFF;
}

/* 073D4C-073D7E size 50  node_cmd_eq_set_AE8C (sub_73D4C) Confirmed:
 * '=': only in record mode 1: copy 4 arg bytes to FFAE8C, validate with
 * sub_25086 (Z = ok): redraw + ACK, else NAK. */
void node_cmd_eq_set_AE8C(struct rec *er0)             /* 073D4C */
{
    if (er0->b5 != 1) { ext_send_nak(); return; }
    memcpy(ram_AE8C, node_buf_96F8 + 2, 4);
    if (sub_25086() != 0) { ext_send_nak(); return; }
    redraw_flags_817E |= 2;  ext_send_ack();
}

/* ------------------------------------------------------------------------ *
 * 073D7E-073E20  size 162  node_cmd_gt_set_channel_fields  (sub_73D7E)
 *   Confirmed (field meanings Inferred)
 * '>': 9 args.  r1h < 2, r1l < 4, 96FC < 3, 96FD (tone mode t) < 7,
 * 96FF < 2, 9701 < 2.  Value 96FE goes, by t: 3 -> er0[0x18] (DCS index,
 * < 0x68 = 104), 6 -> er0[0x34] (< 0x1C), 0/5 -> nothing, other -> er0[0x17]
 * (CTCSS index, < 0x32 = 50).  Then er0[0x15] = 96FC, er0[0x16] = t,
 * er0[0x19] = r1h, er0[0x13] = r1l, er0[0x12].5 = 96FF.0,
 * er0[0x39].5 = 9701.0; sub_1C050 (apply), redraw, ACK.  Out of range: NAK.
 * (Offsets match the VFO layout of pc-02 sec.3.1: +0x17 CTCSS, +0x18 DCS.)
 * ------------------------------------------------------------------------ */
void node_cmd_gt_set_channel_fields(struct rec *er0, u8 a0, u8 a1) /* 073D7E */
{
    u8 b2 = node_buf_96F8[4], t = node_buf_96F8[5], v = node_buf_96F8[6];
    u8 f7 = node_buf_96F8[7], f9 = node_buf_96F8[9];
    if (a0 >= 2 || a1 >= 4 || b2 >= 3 || t >= 7 || f7 >= 2 || f9 >= 2) goto nak;
    switch (t) {
    case 0: case 5: break;
    case 6: if (v >= 0x1C) goto nak; er0->f34 = v; break;
    case 3: if (v >= 0x68) goto nak; er0->dcs_18 = v; break;
    default: if (v >= 0x32) goto nak; er0->ctcss_17 = v; break;
    }
    er0->f15 = b2;  er0->tonemode_16 = t;  er0->f19 = a0;  er0->f13 = a1;
    er0->f12 = (er0->f12 & ~0x20) | ((f7 & 1) << 5);
    er0->f39 = (er0->f39 & ~0x20) | ((f9 & 1) << 5);
    vfo_apply_1C050();
    redraw_flags_817E |= 2;  ext_send_ack();
    return;
nak:
    ext_send_nak();
}

/* 073E20-073E58 size 56  node_cmd_q_set_channel_no (sub_73E20) Confirmed:
 * '?': only in record mode 2 and when sub_3F1F2 returns 0 (N clear, Z set):
 * r1 < 0x44B and sub_3F172(r1) == 0 -> er0[8] = r1, sub_1C0DC, redraw,
 * ACK; else NAK.  (0x44B = 1099 = last memory slot, pc-02 sec.3.1.) */
void node_cmd_q_set_channel_no(struct rec *er0, u16 r1) /* 073E20 */
{
    if (er0->b5 != 2) goto nak;
    if (sub_3F1F2() != 0) goto nak;
    if (r1 >= 0x44B) goto nak;
    if (mem_slot_check_3F172(r1) != 0) goto nak;
    er0->chan_8 = r1;  mem_recall_1C0DC();
    redraw_flags_817E |= 2;  ext_send_ack();  return;
nak:
    ext_send_nak();
}

/* ------------------------------------------------------------------------ *
 * 073E58-073EB4  size 92   node_cmd_at_tx_control   (sub_73E58) Confirmed
 * '@' (doc 104 slot 0x10): only while transmitting (FF94C0 == 1):
 *   arg 0x11 -> sub_34A52 (DSP TX start), A99D = 0, sub_3490, ACK
 *   arg 0x12 -> sub_350E4 (TX stop), sub_34C58, sub_3490, ACK
 *   arg < 0x10 -> AC09.7 = 1, AC06 = arg + 0x50, AAE1.0 = 1, ACK
 *   arg 0x13..0xFF -> AAE1.0 = 0, ACK
 * not transmitting -> NAK.
 * ------------------------------------------------------------------------ */
void node_cmd_at_tx_control(u8 arg0)                   /* 073E58 */
{
    if (tx_state != 1) { ext_send_nak(); return; }
    if (arg0 == 0x12)      { dsp_tx_stop_350E4();  sub_34C58(); sub_3490(); }
    else if (arg0 == 0x11) { dsp_tx_start_34A52(); tx_A99D = 0; sub_3490(); }
    else {
        u8 b = 0;
        if (arg0 < 0x10) { tx_AC09 |= 0x80; tx_AC06 = arg0 + 0x50; b = 1; }
        tone_flags_AAE1 = (tone_flags_AAE1 & ~1) | b;
    }
    ext_send_ack();
}

/* 073EB4-073EE2 size 46  node_cmd_A_key_or_channel (sub_73EB4) Confirmed:
 * 'A': arg < 0x17; clear A9EE.7; arg < 10 -> A9ED = 0 and A9F0 = arg
 * (numeric key digit); arg >= 10 -> A9ED = arg - 9 (key index); ACK.
 * (doc 104 calls it "channel index"; it is a remote key/digit press.) */
void node_cmd_A_key_or_channel(u8 arg0)                /* 073EB4 */
{
    if (arg0 >= 0x17) { ext_send_nak(); return; }
    key_flags_A9EE &= ~0x80;
    if (arg0 < 0x0A) { key_event = 0; key_digit_A9F0 = arg0; }
    else             key_event = arg0 - 9;
    ext_send_ack();
}

/* 073EE2-073F08 size 38  node_cmd_B_read_8096 (sub_73EE2) Confirmed:
 * 'B': reply 0x42 0x81 + 128 bytes FF8096, length 0x83. */
void node_cmd_B_read_8096(void)                        /* 073EE2 */
{
    *(u16 *)node_buf_96F8 = 0x4281;
    memcpy(node_buf_96F8 + 2, ram_8096, 0x80);
    ext_tx_len_8130 = 0x83;  ext_send_reply();
}

/* 073F08-073F1E size 22  node_cmd_C_restart (sub_73F08) Confirmed:
 * 'C': arg 0 -> ACK, short spin (0xF0), jmp 0xDBD8 (warm restart);
 * other -> jmp 0xDBC4. */
void node_cmd_C_restart(u8 arg0)                       /* 073F08 */
{
    if (arg0 != 0) goto_DBC4();
    ext_send_ack();
    for (volatile u8 i = 0xF0; --i; ) ;
    goto_DBD8();
}

/* ------------------------------------------------------------------------ *
 * 073F1E-073FC4  size 166  node_cmd_D_set_flag   (sub_73F1E)   Confirmed
 * 'D': arg0 = index < 0x10, arg1 = value.
 *   0..3 -> A9A8/A9A9/A9AA/A9AB = value, sub_34E0
 *   4..7 -> A9A8[idx] = value; idx 4: AA35.4 = (value == 0);
 *           idx 5: AA35.3 = (value == 0)
 *   8..15 -> A998[idx-8] (= FFA9A0 + idx - 8 via @(-0x5668)) = value;
 *           idx 10 -> AA38.1, idx 11 -> AA38.0, then sub_3490
 *   ACK; idx >= 16 NAK.
 * ------------------------------------------------------------------------ */
void node_cmd_D_set_flag(u8 idx, u8 val)               /* 073F1E */
{
    if (idx >= 0x10) { ext_send_nak(); return; }
    if (idx < 8) {
        switch (idx) {
        case 0: flags_A9A8[0] = val; sub_34E0(); break;
        case 1: flags_A9A8[1] = val; sub_34E0(); break;
        case 2: flags_A9A8[2] = val; sub_34E0(); break;
        case 3: flags_A9A8[3] = val; sub_34E0(); break;
        default:
            flags_A9A8[idx] = val;
            if (idx == 4) { flags_AA35 |= 0x10; if (val) flags_AA35 &= ~0x10; }
            if (idx == 5) { flags_AA35 |= 0x08; if (val) flags_AA35 &= ~0x08; }
        }
    } else {
        flags_A998[idx - 8] = val;                     /* FFA998 + idx - 8  */
        if (idx == 0x0B)      { flags_AA38 |= 0x01; sub_3490(); }
        else if (idx == 0x0A) { flags_AA38 |= 0x02; sub_3490(); }
    }
    ext_send_ack();
}

/* 073FC4-073FEA size 38  node_cmd_E_set_8970 (sub_73FC4) Confirmed:
 * 'E': arg0 must be 0, arg1 < 16 -> FF8971 (band B selected) or FF8970
 * (band A); ACK.  (doc 104 mentions only 8971.) */
void node_cmd_E_set_8970(u8 a0, u8 a1)                 /* 073FC4 */
{
    if (a0 != 0 || a1 >= 0x10) { ext_send_nak(); return; }
    if (band_sel_8EA0 & 0x40) setting_8971 = a1; else setting_8970 = a1;
    ext_send_ack();
}

/* 073FEA-074010 size 38  node_cmd_M_set_8974 (sub_73FEA) Confirmed:
 * 'M': arg0 0 -> FF8974, 1 -> FF8975 (value < 9); ACK, else NAK. */
void node_cmd_M_set_8974(u8 a0, u8 a1)                 /* 073FEA */
{
    if (a1 >= 9 || a0 > 1) { ext_send_nak(); return; }
    if (a0 == 0) setting_8974 = a1; else setting_8975 = a1;
    ext_send_ack();
}

/* 074010-07402A size 26  node_cmd_F_set_89B1 (sub_74010) Confirmed:
 * 'F': arg < 11 -> FF89B1, sub_16C36(arg), ACK. */
void node_cmd_F_set_89B1(u8 a0)                        /* 074010 */
{
    if (a0 >= 0x0B) { ext_send_nak(); return; }
    setting_89B1 = a0;  sub_16C36(a0);  ext_send_ack();
}

/* 07402A-074050 size 38  node_cmd_G_tx_aux (sub_7402A) Confirmed:
 * 'G': while transmitting, arg 0 -> loc_356C8, arg 1 -> loc_357E8; ACK. */
void node_cmd_G_tx_aux(u8 a0)                          /* 07402A */
{
    if (tx_state != 1 || a0 >= 2) { ext_send_nak(); return; }
    if (a0 == 1) loc_357E8(); else loc_356C8();
    ext_send_ack();
}

/* 074050 size 10  node_cmd_H_action (sub_74050): sub_395A8, ACK. Confirmed */
void node_cmd_H_action(void) { sub_395A8(); ext_send_ack(); }   /* 074050 */
/* 07405A size 6  node_cmd_I_halt (sub_7405A): mask IRQs, jmp 0x25AC. Confirmed */
void node_cmd_I_halt(void) { disable_interrupts(); goto_25AC(); } /* 07405A */
/* 074060 size 16  node_cmd_J_port52 (sub_74060): AA35.2, port FF52.7, ACK. */
void node_cmd_J_port52(void)                           /* 074060 */
{ flags_AA35 |= 0x04; PORT_FF52 |= 0x80; ext_send_ack(); }
/* 074070 size 6  node_cmd_K_nak (sub_74070): NAK. Confirmed */
void node_cmd_K_nak(void) { ext_send_nak(); }          /* 074070 */

/* ------------------------------------------------------------------------ *
 * 074076-0740D8  size 98   node_cmd_L_set_offset   (sub_74076)   Confirmed
 * 'L': signed arg1, |v| < 0x41.  Band B: arg0 0/1/2 -> FF80B4/FF80C4/
 * FF80A4; band A: 0/1/2 -> FF8034/FF8044/FF8024 (s16 = sign-extended v);
 * sub_1C050, ACK.  (doc 104 lists only 80A4.)
 * ------------------------------------------------------------------------ */
void node_cmd_L_set_offset(u8 a0, s8 a1)               /* 074076 */
{
    s16 v = a1;
    if ((v < 0 ? -v : v) >= 0x41) goto nak;
    s16 *dst;
    if (band_sel_8EA0 & 0x40)
        dst = a0 == 0 ? &trim_80B4 : a0 == 1 ? &trim_80C4 : a0 == 2 ? &trim_80A4 : 0;
    else
        dst = a0 == 0 ? &trim_8034 : a0 == 1 ? &trim_8044 : a0 == 2 ? &trim_8024 : 0;
    if (!dst) goto nak;
    *dst = v;
    vfo_apply_1C050();  ext_send_ack();  return;
nak:
    ext_send_nak();
}

/* 0740D8-0740E2 size 10  node_cmd_N_market (sub_740D8) Confirmed:
 * 'N': bsr sub_740E2 (which does not return on success); the NAK tail at
 * 0740DC is unreachable from here (doc 96). */
void node_cmd_N_market(u8 a0, u8 a1) { market_set_restart(a0, a1); } /* 0740D8 */

/* 0740E2-07410C size 42  market_set_restart (sub_740E2) Confirmed (doc 96):
 * arg0 < 8, arg1 < 2: FF800F = arg0, FF8010 = (arg0 6/7 ? 0 : arg1);
 * save to EEPROM (sub_39544) and jmp 0xDBC4 (restart). */
void market_set_restart(u8 a0, u8 a1)                  /* 0740E2 */
{
    if (a0 >= 8 || a1 >= 2) { ext_send_nak(); return; }
    market_800F = a0;
    market_8010 = (a0 == 6 || a0 == 7) ? 0 : a1;
    eeprom_market_save_39544();
    goto_DBC4();
}

/* 07410C-074134 size 40  node_cmd_O_band_b (sub_7410C) Confirmed:
 * 'O': arg < 2; if 8EA0.7 differs from arg toggle it (sub_2113C) and
 * redraw; ACK. */
void node_cmd_O_band_b(u8 a0)                          /* 07410C */
{
    if (a0 >= 2) { ext_send_nak(); return; }
    if (((band_sel_8EA0 >> 7) & 1) != a0) { sub_2113C(); redraw_flags_817E |= 2; }
    ext_send_ack();
}

/* 074134-074150 size 28  node_cmd_P_band_a (sub_74134) Confirmed, tail
 * 074150-07415C size 12 node_ack_or_nak_tail (sub_74150):
 * 'P': same for 8EA0.6 via sub_21176. */
void node_cmd_P_band_a(u8 a0)                          /* 074134 */
{
    if (a0 >= 2) { ext_send_nak(); return; }
    if (((band_sel_8EA0 >> 6) & 1) != a0) { sub_21176(); redraw_flags_817E |= 2; }
    ext_send_ack();                                    /* 074150            */
}

/* 07415C size 6  node_cmd_Q_nak (sub_7415C): NAK. Confirmed */
void node_cmd_Q_nak(void) { ext_send_nak(); }          /* 07415C */

/* ------------------------------------------------------------------------ *
 * 074162-0741F6  size 148  node_cmd_R_digital_mode   (sub_74162) Confirmed
 * 'R': arg < 2.  For the selected band (8EA0.6 = B): arg 1 and not already
 * digital -> mode = 1, sub-mode (8EB3 / 8EC2) = 2, the other band's mode
 * byte = 0 and its sub-mode = 0; arg 0 and digital -> mode = 0, sub = 0.
 * Band A then calls sub_5E59E, band B loc_5E636; ACK.
 * ------------------------------------------------------------------------ */
void node_cmd_R_digital_mode(u8 a0)                    /* 074162 */
{
    if (a0 >= 2) { ext_send_nak(); return; }
    if (!(band_sel_8EA0 & 0x40)) {
        if (a0) {
            if (bandA_mode_8D20 != 1) {
                bandA_mode_8D20 = 1; bandA_sub_8EB3 = 2;
                bandB_mode_8DD5 = 0; bandB_sub_8EC2 = 0;
                sub_5E59E();
            }
        } else if (bandA_mode_8D20) {
            bandA_mode_8D20 = 0; bandA_sub_8EB3 = 0; sub_5E59E();
        }
    } else {
        if (a0) {
            if (bandB_mode_8DD5 != 1) {
                bandB_mode_8DD5 = 1; bandB_sub_8EC2 = 2;
                bandA_mode_8D20 = 0; bandA_sub_8EB3 = 0;
                loc_5E636();
            }
        } else if (bandB_mode_8DD5) {
            bandB_mode_8DD5 = 0; bandB_sub_8EC2 = 0; loc_5E636();
        }
    }
    ext_send_ack();
}

/* 0741F6-07421E size 40  node_cmd_S_digital_ready (sub_741F6) Confirmed:
 * 'S': ACK if the selected band is digital and the DSP is ready
 * (B0A4.2), else NAK. */
void node_cmd_S_digital_ready(void)                    /* 0741F6 */
{
    u8 m = (band_sel_8EA0 & 0x40) ? bandB_mode_8DD5 : bandA_mode_8D20;
    if (m && (dsp_ready_B0A4 & 0x04)) ext_send_ack(); else ext_send_nak();
}

/* 07421E-07424E size 48  node_cmd_T_set_89C9 (sub_7421E) Confirmed:
 * 'T': arg < 2 -> FF89C9 = arg (written only on change); ACK. */
void node_cmd_T_set_89C9(u8 a0)                        /* 07421E */
{
    if (a0 >= 2) { ext_send_nak(); return; }
    if (setting_89C9 != a0) setting_89C9 = a0;
    ext_send_ack();
}

/* 07424E-074286 size 56  node_cmd_U_tx_level (sub_7424E) Confirmed:
 * 'U': band A digital and transmitting, arg < 2: arg 0 -> A99E =
 * *sub_3EE46(), arg 1 -> A99F = *sub_3EE70(); ACK. */
void node_cmd_U_tx_level(u8 a0)                        /* 07424E */
{
    if (!bandA_mode_8D20 || tx_state != 1 || a0 >= 2) { ext_send_nak(); return; }
    if (a0 == 1) tx_A99F = *sub_3EE70();
    else         tx_A99E = *sub_3EE46();
    ext_send_ack();
}

/* 074286-07429E size 24  node_cmd_V_reload_defaults (sub_74286) Confirmed:
 * 'V': when not transmitting (94C0 == 0): sub_DE20 (copy ROM defaults to
 * FF8016/8096/80C6, doc on sub_DE20), ACK. */
void node_cmd_V_reload_defaults(void)                  /* 074286 */
{
    if (tx_state != 0) { ext_send_nak(); return; }
    sub_DE20();  ext_send_ack();
}

/* 07429E-0742BC size 30  node_cmd_W_set_radio_id (sub_7429E) Confirmed:
 * 'W': copy 5 bytes FF96FA -> FF8060 (WRITES the radio ID; doc 104's
 * "read" label is reversed - eepmov er5=96FA src, er6=8060 dst); ACK. */
void node_cmd_W_set_radio_id(void)                     /* 07429E */
{
    memcpy(radio_id_8060, node_buf_96F8 + 2, 5);
    ext_send_ack();
}

/* 0742BC-0742E8 size 44  node_cmd_X_read_radio_id (sub_742BC) Confirmed:
 * 'X': reply 0x58 0x06 + 5 bytes FF8060, length 8. */
void node_cmd_X_read_radio_id(void)                    /* 0742BC */
{
    *(u16 *)node_buf_96F8 = 0x5806;
    memcpy(node_buf_96F8 + 2, radio_id_8060, 5);
    ext_tx_len_8130 = 8;  ext_send_reply();
}

/* 0742E8-074310 size 40  node_cmd_Y_load_8956 (sub_742E8) Confirmed:
 * 'Y': FF8955 = 2, copy the 18-byte ROM block 074310 (IDA "sub_74310" is
 * data) to FF8956, sub_194D2, ACK.  (Source is ROM, not the host.) */
void node_cmd_Y_load_8956(void)                        /* 0742E8 */
{
    setting_8955 = 2;
    memcpy(ram_8956, ROM_074310, 0x12);
    sub_194D2();  ext_send_ack();
}

/* 074322-074364 size 66  node_cmd_Z_read_B0DC (sub_74322) Confirmed:
 * 'Z': selected band digital and B0A4.1 -> reply 0x5A 0x03 + word FFB0DC
 * (big-endian), length 5; else NAK. */
void node_cmd_Z_read_B0DC(void)                        /* 074322 */
{
    u8 m = (band_sel_8EA0 & 0x40) ? bandB_mode_8DD5 : bandA_mode_8D20;
    if (!m || !(dsp_ready_B0A4 & 0x02)) { ext_send_nak(); return; }
    *(u16 *)node_buf_96F8 = 0x5A03;
    node_buf_96F8[2] = dsp_B0DC >> 8;  node_buf_96F8[3] = (u8)dsp_B0DC;
    ext_tx_len_8130 = 5;  ext_send_reply();
}

/* 074364-074390 size 44  node_cmd_lbracket_read_813F (sub_74364) Confirmed:
 * '[': reply 0x5B 0x04 + 3 bytes FF813F (SUB link triple), length 6. */
void node_cmd_lbracket_read_813F(void)                 /* 074364 */
{
    *(u16 *)node_buf_96F8 = 0x5B04;
    memcpy(node_buf_96F8 + 2, sub_link_813F, 3);
    ext_tx_len_8130 = 6;  ext_send_reply();
}

/* 074390 size 6  node_cmd_backslash_nak (sub_74390): NAK. Confirmed */
void node_cmd_backslash_nak(void) { ext_send_nak(); }  /* 074390 */

/* 074396-0743E0 size 74  node_cmd_rbracket_dsp15 (sub_74396) Confirmed:
 * ']': digital + DSP ready: arg 1 -> B0CC = 1 (arm DSP session 0x15);
 * arg 0 -> if B0CC.0 clear it and call sub_56046; ACK.  Else NAK. */
void node_cmd_rbracket_dsp15(u8 a0)                    /* 074396 */
{
    u8 m = (band_sel_8EA0 & 0x40) ? bandB_mode_8DD5 : bandA_mode_8D20;
    if (!m || !(dsp_ready_B0A4 & 0x04)) goto nak;
    if (a0 == 1) dsp_txmode_B0CC = 1;
    else if (a0 == 0) { if (dsp_txmode_B0CC & 1) { dsp_txmode_B0CC = 0; sub_56046(); } }
    else goto nak;
    ext_send_ack();  return;
nak:
    ext_send_nak();
}

/* ------------------------------------------------------------------------ *
 * 0743E0-07445A  size 122  node_cmd_caret_rf_status  (sub_743E0) Confirmed
 * '^': reply 0x5E 0x02 + one byte, length 4.  arg 0 = band A record
 * FF8122, arg 1 = band B record FF8126; only if that band is active
 * (8EA0.7 dual or the 8EA0.6 selection) and its record byte +0x8F has
 * bit 2: value = port FFFF4D bit 3 (A) / bit 2 (B) (RF-status / lock line,
 * doc 93).  Otherwise the value is the byte at 073909 (0x15, NAK code).
 * ------------------------------------------------------------------------ */
void node_cmd_caret_rf_status(u8 a0)                   /* 0743E0 */
{
    *(u16 *)node_buf_96F8 = 0x5E02;
    u8 v = ROM_073909_NAK[0];
    if (a0 == 0) {
        if ((band_sel_8EA0 & 0x80) || !(band_sel_8EA0 & 0x40)) {
            struct rec *r = rec_bandA_8122;
            if (r->b8F & 0x04) v = (PORT_FF4D & 0x08) ? 1 : 0;
        }
    } else if (a0 == 1) {
        if ((band_sel_8EA0 & 0x80) || (band_sel_8EA0 & 0x40)) {
            struct rec *r = rec_bandB_8126;
            if (r->b8F & 0x04) v = (PORT_FF4D & 0x04) ? 1 : 0;
        }
    }
    node_buf_96F8[2] = v;
    ext_tx_len_8130 = 4;  ext_send_reply();
}

/* 07445A-074472 size 24  node_cmd_underscore_link_state (sub_7445A)
 * Confirmed: '_': arg 1 or 2 -> FF94FE = arg, ACK; else NAK. */
void node_cmd_underscore_link_state(u8 a0)             /* 07445A */
{
    if (a0 < 1 || a0 >= 3) { ext_send_nak(); return; }
    link_state_94FE = a0;  ext_send_ack();
}
/* ************************************************************************** *
 * PART 5  074562-0750C2 : BACKUP.dat / MEMORY.dat writer and reader
 *         (pc-02 sec.2/3).  All steps are SD continuations (off_703E6):
 *         each runs when the FE reply for the previous chunk arrives.
 * Common cells: BA7A = running 32-bit additive sum, BB04 = current EEPROM
 * address, BB02 = remaining chunk count, FF5406 = outgoing chunk buffer,
 * FF509E = incoming reply payload.  On the writers a reply error (FF5014)
 * ends the job (sub_2ABC4) and clears the file-ok cache BA41/BA42.
 * ************************************************************************** */

static u32 sum_bytes(const u8 *p, u16 n, u32 s) { while (n--) s += *p++; return s; }

/* 074562-0745EE  size 140  backup_write_start (sub_74562) Confirmed
 * Rebuild the ID block and store it at EEPROM 0x360 (sub_3A028, 14 B), read
 * EEPROM 0x140 (0x300 B), add it to the sum, post create+chunk0
 * (sd_post_backup_0), step 3.  Region A = 0x54 x 0x300 + 1 x 0x2C0. */
void backup_write_start(void)                          /* 074562 */
{
    sd_sum_BA7A = 0;  loc_39CE6();
    clone_build_header();  *(u32 *)(clone_buf_96F8 + 10) = 0;    /* FF9702 */
    eep_write_3A028(0x360, clone_buf_96F8, 0x0E);
    sd_eep_addr_BB04 = 0x140;  sd_chunks_BB02 = 0x54;
    eep_read_3AB80(0x140, sd_chunk_5406, 0x300);
    sd_sum_BA7A = sum_bytes(sd_chunk_5406, 0x300, sd_sum_BA7A);
    sd_post_backup_0();  sd_next_step = 3;
}

/* 0745EE-0747DE  size 496  backup_write_steps (sub_745EE) Confirmed
 *   step 3 = 0745EE (region A), step 4 = 07469E (begin B), step 5 = 074702.
 * Each: advance BB04 by 0x300, decrement BB02, read the next EEPROM chunk
 * (A: sub_3AB80; B: sub_3BDAC), add it to BA7A, post the matching chunk
 * poster (sd_post_backup_2/1/5...) and stay/advance the step.  The last A
 * chunk is 0x2C0 (sd_post_backup_1, step 4).  The last B chunk is 0x2FC and
 * its sum is stored to FF5702 before the final send (sd_post_backup_3).
 * Final step: step 0, sub_2ABC4 (end job) and resume the FE idle
 * (loc_6FF15).  Reply error anywhere -> 0747C8: end job, BA41 = 0. */
void backup_write_steps(void)                          /* 0745EE */
{
    if (sd_reply_status) { backup_write_abort(); return; }   /* 0747C8     */
    /* region A body (step 3): */
    sd_eep_addr_BB04 += 0x300;
    if (--sd_chunks_BB02 != 0) {
        eep_read_3AB80(sd_eep_addr_BB04, sd_chunk_5406, 0x300);
        sd_sum_BA7A = sum_bytes(sd_chunk_5406, 0x300, sd_sum_BA7A);
        sd_post_backup_2();  sd_next_step = 3;  return;
    }
    /* last A chunk 0x2C0 */
    eep_read_3AB80(sd_eep_addr_BB04, sd_chunk_5406, 0x2C0);
    sd_sum_BA7A = sum_bytes(sd_chunk_5406, 0x2C0, sd_sum_BA7A);
    sd_post_backup_1();  sd_next_step = 4;
}
void backup_write_region_b(void)                       /* 07469E step 4 */
{
    if (sd_reply_status) { backup_write_abort(); return; }
    sd_eep_addr_BB04 = 0x10100;  sd_chunks_BB02 = 0x55;
    i2c_eep_read_3BDAC(0x10100, sd_chunk_5406, 0x300);
    sd_sum_BA7A = sum_bytes(sd_chunk_5406, 0x300, sd_sum_BA7A);
    sd_post_backup_2();  sd_next_step = 5;
}
void backup_write_region_b_body(void)                  /* 074702 step 5 */
{
    if (sd_reply_status) { backup_write_abort(); return; }
    sd_eep_addr_BB04 += 0x300;
    if (--sd_chunks_BB02 == 0) { backup_write_finish(); return; } /* 0747B4 */
    i2c_eep_read_3BDAC(sd_eep_addr_BB04, sd_chunk_5406, 0x300);
    if (sd_chunks_BB02 == 1) {                          /* last: 0x2FC + sum */
        sd_sum_BA7A = sum_bytes(sd_chunk_5406, 0x2FC, sd_sum_BA7A);
        sd_sum_5702 = sd_sum_BA7A;                       /* FF5702          */
        sd_post_backup_3();
    } else {
        sd_sum_BA7A = sum_bytes(sd_chunk_5406, 0x300, sd_sum_BA7A);
        sd_post_backup_2();
    }
    sd_next_step = 5;
}
void backup_write_finish(void)                         /* 0747B4 */
{ sd_next_step = 0; end_sd_job_2ABC4(); fe_idle_resume_6FF15(); }
void backup_write_abort(void)                          /* 0747C8 */
{ sd_next_step = 0; end_sd_job_2ABC4(); backup_dat_ok = 0; }

/* 0747DE-07481A  size 60  backup_read_start (sub_747DE) Confirmed
 * (pc-02 restore step 1-2) clear sum, sub_394F4 (quiesce), request 0x40
 * bytes of BACKUP.dat at file offset 0x220 (the ID block, sd_post_backup_4),
 * step 6. */
void backup_read_start(void)                           /* 0747DE */
{
    sd_sum_BA7A = 0;  sub_394F4();
    sd_req_length = 0x40;  sd_req_offset = 0x220;
    sd_post_backup_4();  sd_next_step = 6;
}

/* 07481A-074B08  size 750  backup_restore_steps (sub_7481A) Confirmed
 *   step 6 = 07481A (ID check), step 7 = 0748A0 (region A),
 *   step 8 = 07494E (begin B), step 9 = 0749D6 (region B + finish).
 * Step 6: copy 14 B of the reply to FF96F8, run clone_id_check (the
 *   "AH72M"/version/region check, pc-02); fail -> 074AF0 abort (redraw,
 *   clear BA93.2, popup 2).  OK: sub_74B08 (quiesce subsystems), write
 *   "MARU" to EEPROM 0x10 (copy ROM DD15 -> FF8006, sub_39512), set up the
 *   region-A stream (BB04 = 0x140, BB02 = 0x54, length 0x300, off 0), post
 *   read (sd_post_backup_5), step 7.
 * Step 7: add the reply chunk to the sum, write it to EEPROM 0x140.. with
 *   sub_3AD20, advance; last A chunk is 0x2C0, then step 8.
 * Step 8: same for region B via sub_3BF4C to 0x10100.., step 9.
 * Step 9: region B body; the final 0x2FC/0x300 handling and then 074A9C:
 *   compare the running sum BA7A with the file's trailing sum FF539A; on
 *   mismatch jmp 0xDC4E with "MARU" still set (reset to defaults on reboot).
 *   On match: 89C4 = 5, sub_193CA, read the market variant (sub_3F386,
 *   F1FA[er4]); run the apply hooks (sub_750C2/75160/754BC/nullsub_44) only
 *   if the variant byte is 0, then sub_75EB6, write "TAIS" (sub_39504), and
 *   jmp 0xDC4E (restart).  Reply error anywhere -> 074AEC jmp 0xDC4E. */
void backup_restore_id_check(void)                     /* 07481A step 6 */
{
    sd_next_step = 0;
    if (sd_reply_status) { backup_restore_reject(); return; }
    memcpy(clone_buf_96F8, sd_reply_payload, 0x0E);
    if (clone_id_check() != 0) { backup_restore_reject(); return; }
    sub_74B08();
    eeprom_marker_8006 = *(u32 *)ROM_00DD16_MARU;  eeprom_marker_save_39512();
    sd_eep_addr_BB04 = 0x140;  sd_chunks_BB02 = 0x54;
    sd_req_length = 0x300;  sd_req_offset = 0;
    sd_post_backup_5();  sd_next_step = 7;
}
/* steps 7/8/9 mirror the writer: read chunk from reply, sum, write to
 * EEPROM (3AD20 region A, 3BF4C region B), paged by BB02; final compares
 * BA7A == *FF539A and branches as above.  Full bodies in the listing. */
void backup_restore_region_a(void) { /* 0748A0 */ }
void backup_restore_region_b_begin(void) { /* 07494E */ }
void backup_restore_region_b(void) { /* 0749D6; finish at 074A9C */ }
void backup_restore_reject(void)                       /* 074AF0 */
{ redraw_flags_817E |= 2; qso_flags_BA93 &= ~0x04; popup_show_err2(2); }

/* 074B08-074B2A  size 34  sd_quiesce (sub_74B08) Confirmed
 * Stop the subsystems before a bulk EEPROM operation: sub_557A2 (USB/
 * picture), sub_2F400, sub_30F00, sub_330F0, loc_3907F, sub_3490. */
void sd_quiesce(void)                                  /* 074B08 */
{ sub_557A2(); sub_2F400(); sub_30F00(); sub_330F0(); loc_3907F(); sub_3490(); }

/* 074B2A-074DCA  MEMORY.dat writer (sub_74B2A start, sub_74B90 steps)
 *   Confirmed.  Same shape as BACKUP: region 0x1680 (0x35 x 0x300 + a
 *   0x280 tail), then 0x1A000 (3 x 0x300 + a 0x18 tail, whose last sum is
 *   stored to FF541E).  Chunks posted by sd_post_memory_0..5; UI step ids
 *   0x11/0x2B/0x2C/0x12.  074D92 = done step; 074DB4 = error -> BA42 = 0.
 * The MEMORY file is EEPROM 0x1680-0xB7FF then 0x1A000-0x1A917 (pc-02). */
void memory_write_start(void)                          /* 074B2A */
{
    sd_sum_BA7A = 0;  sd_eep_addr_BB04 = 0x1680;  sd_chunks_BB02 = 0x35;
    eep_read_3AB80(0x1680, sd_chunk_5406, 0x300);
    sd_sum_BA7A = sum_bytes(sd_chunk_5406, 0x300, sd_sum_BA7A);
    sd_post_memory_0();  sd_next_step = 0x11;
}
void memory_write_steps(void) { /* 074B90; regions & tails as above */ }

/* 074DCA-074E38  size 110  memory_restore_start (sub_74DCA) Confirmed
 * No ID/region check (pc-02): sub_74B08, clear sum, sub_394F4, write "MARU"
 * (FF8006), sub_E934, loc_39CE6, set up region 0x1680 (0x35 chunks), post
 * read (sd_post_memory_3), step 0x13. */
void memory_restore_start(void)                        /* 074DCA */
{
    sd_quiesce();  sd_sum_BA7A = 0;  sub_394F4();
    eeprom_marker_8006 = *(u32 *)ROM_00DD16_MARU;  eeprom_marker_save_39512();
    sub_E934();  loc_39CE6();
    sd_eep_addr_BB04 = 0x1680;  sd_chunks_BB02 = 0x35;
    sd_req_length = 0x300;  sd_req_offset = 0;
    sd_post_memory_3();  sd_next_step = 0x13;
}

/* 074E38-0750C2  size 650  memory_restore_steps (sub_74E38) Confirmed
 *   step 0x13 = 074E38 (region 0x1680 -> EEPROM via sub_3AD20), step 0x2D/
 *   0x2E (region 0x1A000 via sub_3BF4C), step 0x14 = 07501C (finish).
 * Finish 075084: compare BA7A with the file trailing sum FF50B6; mismatch
 * -> 750BE jmp 0xDC4E (leaves "MARU"); match -> market variant (sub_3F386)
 * 0 -> apply hooks sub_750C2/75160/nullsub_44, then sub_75EB6, "TAIS"
 * (sub_39504), jmp 0xDC4E.  Reply error -> 750BE. */
void memory_restore_steps(void) { /* 074E38; see above */ }
