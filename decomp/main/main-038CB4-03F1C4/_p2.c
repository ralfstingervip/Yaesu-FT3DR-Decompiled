
/* ######################################################################### *
 * PART 4  -  Memory-area accessors (EEPROM device A0, 0x0180..0xB7FF)      *
 *                                                                           *
 * Layout established by this part (EEPROM device A0/A1 addresses):        *
 *   0x0180 + 0x3A*k  band operating records, side A (k = 0..7), 58 bytes   *
 *   0x0380 + 0x3A*k  same, side B (FF817E.b0 = 1)                          *
 *   0x0F80 + 0x12*n  name blocks of memory area 3 (18 bytes each)          *
 *   0x1200 + 0x20*n  32-byte records, the "0x1200 set" (role Inferred:     *
 *                    home/special channels)                                *
 *   0x1380 + 0x20*b  per-band VFO records, side A (b = working rec +3)     *
 *   0x1500 + 0x20*b  per-band VFO records, side B                          *
 *   0x1680 + 0xC8*i  24 x 0xC8 u16 tables (doc pc-02); RAM FF86C8 (A),     *
 *                    FF8790 (B), FF8858 (third copy)                       *
 *   0x2940 + n       memory attribute byte per slot; RAM mirror FF8188[n]  *
 *   0x2E80 + 0x20*n  1100 channel records (doc pc-02 3.1)                  *
 * FF812A = pointer to the live band-A operating record; FF90F0 = band B    *
 * record; FF817E.b0 = side B (written as SIDE_B); FFAC76 = 32-byte packed  *
 * record buffer (doc 35); FFAC9A = compare buffer; FFAD22 = 0x3A scratch.  *
 * "eepmov.w" = block move of R4 bytes @ER5 -> @ER6 (written as memcpy).    *
 * Memory "area" = vfo_mem_group(rec) (sub_3F1DC): rec[6] == 0 -> 0,        *
 * rec[6] == 1 -> rec[0x10], else rec[0x11]; 0 = regular channel area.      *
 * ######################################################################### */
#define SIDE_B (ui_refresh_flags & 0x01)

/* 03A120-03A130 size 16  eeprom_load_mem_attr (sub_3A120)  Confirmed.
 * EEPROM 0x2940 (0x540 = 1344 slot bytes) -> FF8188.
 * Callers sub_75160, sub_75EB6 (restore apply hooks, doc 96).             */
void eeprom_load_mem_attr(void) { eeprom_read(0x2940, mem_attr, 0x540); }
/* 03A130-03A140 size 16  eeprom_save_mem_attr (sub_3A130)  Confirmed.
 * Caller sub_22128.                                                       */
void eeprom_save_mem_attr(void) { eeprom_write(0x2940, mem_attr, 0x540); }
/* 03A140-03A152 size 18  eeprom_args_mem_attr (sub_3A140): r6 = 0x540,
 * er0 = 0x2940, er1 = FF8188.  Confirmed.                                 */

/* 03A152-03A162 size 16  eeprom_load_u16tab (sub_3A152)  Confirmed.
 * 03A162-03A172 size 16  eeprom_save_u16tab (sub_3A162)  Confirmed.
 * 03A172-03A196 size 36  eeprom_args_u16tab (sub_3A172)  Confirmed.
 * Table i (r1) of the 24 x 0xC8 area at EEPROM 0x1680 + 0xC8*i <-> RAM
 * FF86C8 (side A) or FF8790 (side B).  Meaning: Inferred (doc pc-02:
 * "probably 24 banks x 100 u16 entries").  9 load callers in 0x20xxx.     */
void eeprom_load_u16tab(u16 i) { eeprom_read(0x1680 + 0xC8 * i, SIDE_B ? u16tab_B : u16tab_A, 0xC8); }
void eeprom_save_u16tab(u16 i) { eeprom_write(0x1680 + 0xC8 * i, SIDE_B ? u16tab_B : u16tab_A, 0xC8); }

/* 03A196-03A1A6 size 16  eeprom_load_u16tab_C (sub_3A196)  Confirmed.
 * 03A1A6-03A1BC size 22  eeprom_args_u16tab_C (sub_3A1A6)  Confirmed.
 * Table i -> third RAM copy FF8858 (no side choice).                      */
void eeprom_load_u16tab_C(u16 i) { eeprom_read(0x1680 + 0xC8 * i, u16tab_C, 0xC8); }

/* ==========================================================================
 * 03A1BC-03A200  size 68   u16tab_put     (sub_3A1BC)
 * 03A200-03A22E  size 46   u16tab_C_put   (sub_3A200)
 * Confidence: Confirmed.  Callers: sub_201C2, sub_202FA, sub_20AF6 / 202FA.
 * Write-through store: *er5 = r3, then the same 2 bytes go to EEPROM at
 * 0x1680 + 0xC8*r1 + (er5 - table base).
 * ========================================================================== */
void u16tab_put(u16 i, u16 *slot, u16 v)
{
    *slot = v;                                        /* 03A1C0             */
    u16 *base = SIDE_B ? u16tab_B : u16tab_A;         /* 03A1D4             */
    eeprom_write(0x1680 + 0xC8 * i + ((u8 *)slot - (u8 *)base), slot, 2);
}
void u16tab_C_put(u16 i, u16 *slot, u16 v)
{
    *slot = v;                                        /* 03A204             */
    eeprom_write(0x1680 + 0xC8 * i + ((u8 *)slot - (u8 *)u16tab_C), slot, 2);
}

/* ==========================================================================
 * 03A22E-03A266  size 56   settings_R1_put_word   (sub_3A22E)
 * Confidence: Confirmed.  Callers: sub_201C2, sub_20290, sub_20392, 2053E.
 * word[r1] of the R1 table at FF8A20 (side A) / FF8A68 (side B) = r2, then
 * saved through the R1 range writer (settings_R1_save_range, 2 bytes).
 * ========================================================================== */
void settings_R1_put_word(u16 idx, u16 v)
{
    u16 *p = (SIDE_B ? (u16 *)0xFF8A68 : (u16 *)0xFF8A20) + idx;
    *p = v;                                           /* 03A246 / 03A256    */
    settings_R1_save_range(p, 2);                     /* 03A25C sub_3CCD0   */
}

/* 03A266-03A27C size 22  vfo_rec_load_sideA (sub_3A266)  Confirmed (flow).
 * Caller sub_21420.  Reads per-band VFO record r3l of side A (0x1380 +
 * 0x20*r3l, via the 03A2FA entry) into FFAC76 and unpacks it with
 * sub_3FAD0 (unpack variant, outside this chunk).                          */
void vfo_rec_load_sideA(u8 band) { eeprom_read(0x1380 + 0x20 * band, pack_buf, 0x20); rec_unpack_3FAD0(); }

/* 03A27C-03A29C size 32  vfo_rec_load_for (sub_3A27C)  Confirmed (flow).
 * Callers sub_1F1E2, sub_2511E.  band = er0->[4]; reads the side-selected
 * per-band VFO record and unpacks it (sub_3FB0C, doc 35).                  */
void vfo_rec_load_for(u8 *rec)
{
    u8 band = rec[4];                                 /* 03A280             */
    eeprom_read(vfo_rec_addr(band), pack_buf, 0x20);  /* 03A284 03A30C      */
    rec_unpack(pack_buf);                             /* 03A292 sub_3FB0C   */
}

/* 03A29C-03A2C0 size 36  vfo_rec_load (sub_3A29C)  Confirmed (flow).
 * 9 callers (band change / retune, doc 24).  FFAC72 = er0 (working
 * record); reads the VFO record for band rec[3], unpacks it, then
 * vfo_dgid_load (sub_3DF2E).                                              */
void vfo_rec_load(u8 *rec)
{
    vfo_rec_ptr = rec;                                /* 03A2A0 FFAC72      */
    eeprom_read(vfo_rec_addr(rec[3]), pack_buf, 0x20);/* 03A2A6/03A2A8      */
    rec_unpack(pack_buf);                             /* 03A2B2             */
    vfo_dgid_load(rec);                               /* 03A2BA sub_3DF2E   */
}

/* 03A2C0-03A2D0 size 16  vfo_rec_read_raw (sub_3A2C0)  Confirmed.
 * Caller sub_3FEDC.  Packed record for band r3l -> FFAC76, no unpack.     */
void vfo_rec_read_raw(u8 band) { eeprom_read(vfo_rec_addr(band), pack_buf, 0x20); }

/* ==========================================================================
 * 03A2D0-03A2FA  size 42   vfo_rec_save   (sub_3A2D0)
 * Confidence: Confirmed.  22 callers.
 * Packs the working record (sub_3FD48) into FFAC76, compares with the
 * EEPROM copy and writes only on change, then the per-band DG-ID word
 * (vfo_dgid_save, sub_3DEA8).
 * ========================================================================== */
void vfo_rec_save(u8 *rec)
{
    vfo_rec_ptr = rec;                                /* 03A2D4             */
    rec_pack(pack_buf);                               /* 03A2E0 sub_3FD48   */
    if (vfo_rec_differs(vfo_rec_addr(rec[3])))        /* 03A2E4/03A2E6      */
        eeprom_write(vfo_rec_addr(rec[3]), pack_buf, 0x20);  /* 03A2EC      */
    vfo_dgid_save(rec);                               /* 03A2F4 sub_3DEA8   */
}

/* 03A2FA-03A302 size 8  vfo_rec_addr_sideA (sub_3A2FA): er0 = 0x1380, then
 * the common tail at 03A320.  Confirmed.
 * 03A302-03A334 size 50  vfo_rec_addr (sub_3A302)  Confirmed.
 *   entry 03A302: r3l = [FFAC72]->[3];  entry 03A30C: r3l given.
 *   er0 = (SIDE_B ? 0x1500 : 0x1380) + 0x20*r3l; er1 = FFAC76; r6 = 0x20.  */
u32 vfo_rec_addr(u8 band)
{
    u32 a = SIDE_B ? 0x1500 : 0x1380;                 /* 03A30C/03A31A      */
    return a + 0x20u * band;                          /* 03A320..03A32A     */
}

/* 03A334-03A35E size 42  vfo_rec_differs (sub_3A334)  Confirmed.
 * Reads the EEPROM record at er0 (r6 = 0x20) into FFAC9A and compares 8
 * longs with FFAC76.  Z = equal (callers: beq = skip the write).          */
int vfo_rec_differs(u32 ee)
{
    eeprom_read(ee, cmp_buf, 0x20);                   /* 03A33A FFAC9A      */
    return !blk_equal((u32 *)pack_buf, (u32 *)cmp_buf, 8);
}

/* 03A35E-03A37C size 30  rec1200_load (sub_3A35E)  Confirmed (flow).
 * Callers sub_1C18E, sub_1C1D2, sub_1FFD2, sub_75554.  Record r3 of the
 * 0x1200 set -> FFAC76 -> unpack, then its DG-ID word (sub_3DF0A).        */
void rec1200_load(u16 n)
{
    eeprom_read(0x1200 + 0x20 * (u8)n, pack_buf, 0x20);
    rec_unpack(pack_buf);
    rec1200_dgid_load(n);                             /* 03A376 sub_3DF0A   */
}

/* 03A37C-03A390 size 20  rec1200_save_named (sub_3A37C)  Confirmed (flow).
 * Caller sub_20004.  Pack, mem_name_fetch, then the 03A39E tail of
 * rec1200_save.                                                           */
void rec1200_save_named(u16 n) { rec_pack(pack_buf); mem_name_fetch(); rec1200_save_tail(n); }

/* 03A390-03A3BE size 46  rec1200_save (sub_3A390)  Confirmed.
 * Callers sub_1FFD2, sub_75554, sub_EAB0, sub_EAD2.  Pack, write record n
 * of the 0x1200 set on change, then its DG-ID word (sub_3DE84).           */
void rec1200_save(u16 n) { rec_pack(pack_buf); rec1200_save_tail(n); }
static void rec1200_save_tail(u16 n)                  /* 03A39E             */
{
    if (vfo_rec_differs(0x1200 + 0x20 * (u8)n))       /* 03A3A2             */
        eeprom_write(0x1200 + 0x20 * (u8)n, pack_buf, 0x20);
    rec1200_dgid_save(n);                             /* 03A3B8 sub_3DE84   */
}
/* 03A3BE-03A3D8 size 26  rec1200_addr (sub_3A3BE): er0 = 0x1200 + 0x20*r3l,
 * er1 = FFAC76, r6 = 0x20.  Confirmed.                                    */

/* ==========================================================================
 * 03A3D8-03A40C  size 52   oprec_load_A   (sub_3A3D8)
 * Confidence: Confirmed (flow).  Caller: sub_24D42.
 * Reads operating-record slot r3 (0x3A bytes) into FFAD22, clears
 * 8EA6.b0 (band-A record in use), copies it to [FF812A] with mem_copy
 * (sub_3F36E: eepmov r4l bytes er5 -> er6), then reads 7 bytes of slot 7
 * into FFAC76.
 * ========================================================================== */
void oprec_load_A(u16 k)
{
    eeprom_read(oprec_addr(k), oprec_scratch, 0x3A);  /* 03A3DC/03A3E4      */
    band_slot_chk &= ~0x01;                           /* 03A3E8 8EA6.b0     */
    mem_copy(0x3A, oprec_scratch, bandA_rec);         /* 03A3FC sub_3F36E   */
    eeprom_read(oprec_addr(7), pack_buf, 7);          /* 03A400 03A448      */
}
/* 03A40C-03A432 size 38  oprec_addr_A (sub_3A40C): er1 = [FF812A],
 * er0 = (SIDE_B ? 0x380 : 0x180) + 0x3A*r3, r6 = 0x3A.  Confirmed.        */
u32 oprec_addr(u16 k) { return (SIDE_B ? 0x380 : 0x180) + 0x3Au * k; }

/* 03A432-03A448 size 22  oprec_save_A (sub_3A432)  Confirmed.
 * Caller sub_24A8A.  Writes [FF812A] to slot r3 and 7 bytes of FFAC76 to
 * slot 7.                                                                 */
void oprec_save_A(u16 k)
{
    eeprom_write(oprec_addr(k), bandA_rec, 0x3A);     /* 03A438             */
    eeprom_write(oprec_addr(7), pack_buf, 7);         /* 03A43E             */
}
/* 03A448-03A474 size 44  oprec_args_slot7 (sub_3A448): r3 = 7,
 * er1 = FFAC76, er0 = base + 0x3A*7, r6 = 7.  Confirmed.                  */

/* 03A474-03A47A size 6  oprec_save_live_0 (sub_3A474): r3 = 0 -> 03A4D2.
 * 03A47A-03A480 size 6  oprec_save_live_1 (sub_3A47A): r3 = 1 -> 03A4D2.
 * Confirmed.  9 / 8 callers (TX/RX, band and clone code).                 */
void oprec_save_live_0(void) { oprec_save_live(0); }
void oprec_save_live_1(void) { oprec_save_live(1); }

/* ==========================================================================
 * 03A480-03A4D2  size 82   oprec_load_live   (sub_3A480)
 * Confidence: Confirmed.  Callers: sub_1C178, sub_75554.
 * Reads slot r3 into FFAD22.  Byte +0x39 bit 7 (FFAD5B.b7) marks a band-B
 * record: copy into FF90F0 and set 8EA6.b0; otherwise copy into [FF812A]
 * and, unless band B is selected (8EA0.b6), clear 8EA6.b0.
 * ========================================================================== */
void oprec_load_live(u16 k)
{
    eeprom_read(oprec_live_addr(k), oprec_scratch, 0x3A);  /* 03A484      */
    u8 *dst;
    if (oprec_scratch[0x39] & 0x80) {                 /* 03A490 AD5B.b7     */
        dst = (u8 *)0xFF90F0;  band_slot_chk |= 0x01; /* 03A4AE             */
    } else {
        dst = bandA_rec;                              /* 03A498             */
        if (!(band_sel & 0x40)) band_slot_chk &= ~0x01;
    }
    memcpy(dst, oprec_scratch, 0x3A);                 /* 03A4C4 eepmov.w    */
}

/* 03A4D2-03A4F0 size 30  oprec_save_live (sub_3A4D2)  Confirmed.
 * Caller sub_23914 (and the two stubs).  Writes the live record
 * (live_band_rec = sub_10748, doc 122) to slot r3 only if it differs.     */
void oprec_save_live(u16 k)
{
    if (oprec_live_differs(k))                        /* 03A4DA sub_3A514   */
        eeprom_write(oprec_live_addr(k), live_band_rec(), 0x3A);
}
/* 03A4F0-03A514 size 36  oprec_live_addr (sub_3A4F0): er1 = live record
 * (sub_10748), er0 = (SIDE_B ? 0x380 : 0x180) + 0x3A*r3, r6 = 0x3A.       */
u32 oprec_live_addr(u16 k) { return oprec_addr(k); }

/* 03A514-03A538 size 36  oprec_live_differs (sub_3A514)  Confirmed.
 * Reads the slot into FFAC9A and compares 0x1D words (58 bytes) with the
 * live record (pointer re-fetched from sub_10748).  Z = equal.            */
int oprec_live_differs(u16 k)
{
    eeprom_read(oprec_addr(k), cmp_buf, 0x3A);        /* 03A51A             */
    return memcmp(live_band_rec(), cmp_buf, 0x3A) != 0;
}

/* 03A538-03A562 size 42  oprec_load_pair (sub_3A538)  Confirmed.
 * Caller sub_1D4DA.  Slot 3 -> [FF812A] (band A), slot 4 -> FF90F0 (B).   */
void oprec_load_pair(void)
{
    eeprom_read(oprec_addr(3), bandA_rec, 0x3A);
    eeprom_read(oprec_addr(4), (u8 *)0xFF90F0, 0x3A);
}

/* 03A562-03A5B6 size 84  oprec_save_pair (sub_3A562)  Confirmed (flow).
 * Caller sub_1D40E.  The inverse, each written only when "changed".  The
 * compare helper re-fetches er0 from sub_10748, so both tests compare the
 * slot against the OPERATING band's record, not the record being saved
 * (quirk as coded).                                                        */
void oprec_save_pair(void)
{
    if (oprec_live_differs(3)) eeprom_write(oprec_addr(3), bandA_rec, 0x3A);
    if (oprec_live_differs(4)) eeprom_write(oprec_addr(4), (u8 *)0xFF90F0, 0x3A);
}

/* ==========================================================================
 * 03A5B6-03A5F8  size 66   mem_recall       (sub_3A5B6)
 * 03A5F8-03A632  size 58   mem_recall_any   (sub_3A5F8)
 * Confidence: Confirmed (doc 35, doc 61).  Callers: sub_1C104, sub_1FD74 /
 * sub_1C124.
 * For a regular-area slot (mem_rec_addr returns Z): load the DG-ID word for
 * slot r3 (mem_dgid_load = sub_3DF1C), read the 32-byte record and unpack
 * it.  (A special area is synthesised by mem_rec_alt instead.)  Returns
 * er0 = working record: [FF812A], or FF90F0 when the unpack flagged band B
 * (8EA6.b0) - mem_recall only redirects when side A is edited (817E.b0 = 0).
 * ========================================================================== */
u8 *mem_recall(u16 slot)
{
    if (mem_rec_addr(slot) == 0) {                    /* 03A5BA sub_3A6EE   */
        mem_dgid_load(slot);                          /* 03A5C2 sub_3DF1C   */
        eeprom_read(0x2E80 + 0x20 * slot, pack_buf, 0x20);  /* 03A5C8       */
        rec_unpack(pack_buf);                         /* 03A5D2 sub_3FB0C   */
    }
    u8 *r = bandA_rec;                                /* 03A5DA             */
    if (!SIDE_B && (band_slot_chk & 0x01))            /* 03A5E0 / 03A5E8    */
        r = (u8 *)0xFF90F0;
    return r;
}
u8 *mem_recall_any(u16 slot)                          /* 03A5F8             */
{
    if (mem_rec_addr(slot) == 0) {
        mem_dgid_load(slot);
        eeprom_read(0x2E80 + 0x20 * slot, pack_buf, 0x20);
        rec_unpack(pack_buf);
    }
    return (band_slot_chk & 0x01) ? (u8 *)0xFF90F0 : bandA_rec;  /* 03A622 */
}

/* 03A632-03A666 size 52  mem_read_unpack_alt (sub_3A632)  Confirmed (flow).
 * Callers sub_75160, sub_753D4 (restore converters, doc 96).  Reads channel
 * record r3 into FFAC76, unpacks it with sub_3FAE8 (variant) and returns
 * Z = !(8EA6.b0).                                                          */
int mem_read_unpack_alt(u16 slot)
{
    eeprom_read(0x2E80 + 0x20 * slot, pack_buf, 0x20);   /* 03A64C          */
    rec_unpack_3FAE8(pack_buf);                       /* 03A656             */
    return band_slot_chk & 0x01;                      /* 03A65E             */
}

/* BCD frequency helper, inlined 3x here (03A672, 03A734, 03AAD6) and also
 * present as sub_3FD02: f = packed bytes +2..+5 as a big-endian long with
 * the last byte cleared; at or above 1.8 MHz (top word >= 0x0018) the
 * implied sub-kHz digits are restored: 12/37/62/87 -> +50, 06/31/56/81 ->
 * +25, 18/43/68/93 -> +75 (doc pc-02 3.1).  Result: 8 packed-BCD digits,
 * last digit = 10 Hz (0x14652000 = 146.520.00 MHz).                        */
static u32 rec_freq_bcd(const u8 *rec)
{
    u32 f = ((u32)rec[2] << 24) | ((u32)rec[3] << 16) | ((u32)rec[4] << 8);
    if ((f >> 16) >= 0x18) {
        switch (rec[4]) {
        case 0x12: case 0x37: case 0x62: case 0x87: f |= 0x50; break;
        case 0x06: case 0x31: case 0x56: case 0x81: f |= 0x25; break;
        case 0x18: case 0x43: case 0x68: case 0x93: f |= 0x75; break;
        }
    }
    return f;
}
/* Band-plan lookup inlined 2x: table at [FF92C8] = { u32 count;
 * { u32 lo, hi; u16 id; } rows[count] } (10-byte rows); returns the id of
 * the first row with lo <= f <= hi.  If none matches the loop leaves er6
 * on the row after the last and returns its +8 word (quirk as coded).     */
static u16 bandplan_find(u32 f)
{
    const u8 *t = bandplan_ptr;                       /* FF92C8             */
    u32 n = *(const u32 *)t; t += 4;
    for (;;) {
        if (f >= *(const u32 *)t && *(const u32 *)(t + 4) >= f) break;
        t += 10;
        if (--n == 0) break;
    }
    return *(const u16 *)(t + 8);
}

/* 03A666-03A6EE size 136  mem_band_of_slot (sub_3A666)  Confirmed.
 * Caller sub_32AB8.  Reads record r3 and returns r3 = band-plan id of its
 * RX frequency.                                                           */
u16 mem_band_of_slot(u16 slot)
{
    mem_rec_addr(slot);                               /* 03A66A             */
    eeprom_read(0x2E80 + 0x20 * slot, pack_buf, 0x20);/* 03A66E             */
    return bandplan_find(rec_freq_bcd(pack_buf));     /* 03A672..03A6E8     */
}

/* ==========================================================================
 * 03A6EE-03A71A  size 44   mem_rec_addr   (sub_3A6EE)
 * Confidence: Confirmed.  Callers: 3A5B6, 3A5F8, 3A666, 3A71A.
 * Unless AA31.b4 forces the regular area, a non-zero area of the current
 * record (vfo_mem_group, sub_3F1DC on er0) diverts to mem_rec_alt (03CEFE,
 * by jmp - its own exit returns to our caller with r4l = 1, Z clear).
 * Regular: er0 = 0x2E80 + 0x20*r3, er1 = FFAC76, r6 = 0x20, r4l = 0 (Z).
 * ========================================================================== */
int mem_rec_addr(u16 slot)
{
    if (!(flags_AA31 & 0x10) && vfo_mem_group(cur_rec) != 0)
        return mem_rec_alt(slot, vfo_mem_group(cur_rec)); /* 03A6FC jmp     */
    /* er0 = 0x2E80 + 0x20*slot; er1 = FFAC76; r6 = 0x20 */
    return 0;                                         /* 03A716             */
}

/* 03A71A-03A784 size 106  mem_freq_of_slot (sub_3A71A)  Confirmed.
 * Caller sub_2011C.  Reads the 3 BCD frequency bytes of record r3 into
 * FFAC78 and returns er5 = rec_freq_bcd().                                */
u32 mem_freq_of_slot(u16 slot)
{
    mem_rec_addr(slot);                               /* 03A71E             */
    eeprom_read(0x2E80 + 0x20 * slot + 2, pack_buf + 2, 3);  /* 03A730      */
    return rec_freq_bcd(pack_buf);                    /* 03A734..03A77C     */
}

/* 03A784-03A796 size 18  mem_store_named (sub_3A784)  Confirmed (flow).
 * Caller sub_1FCBA.  Pack, mem_name_fetch, then the 03A7DC tail of
 * mem_store (record + attribute + DG-ID word).                            */
void mem_store_named(u16 slot) { rec_pack(pack_buf); mem_name_fetch(); mem_store_tail(slot); }

/* 03A796-03A7CE size 56  mem_name_fetch (sub_3A796)  Confirmed.
 * Callers 3A37C, 3A784.  Clears AA30.b6, copies packed +6..+0x17 (name
 * attribute word + 16-byte name) to FFAA96, then tests the 8 name words
 * for 0xFFFF.  Z = no name (doc pc-02 3.1).                                */
int mem_name_fetch(void)
{
    flags_AA30 &= ~0x40;                              /* 03A796             */
    memcpy(name_buf, pack_buf + 6, 0x12);             /* 03A7AC eepmov      */
    for (int i = 0; i < 8; i++)                       /* 03A7C0             */
        if (((u16 *)(name_buf + 2))[i] != 0xFFFF) return 0;
    return 1;
}

/* ==========================================================================
 * 03A7CE-03A838  size 106  mem_store   (sub_3A7CE)
 * Confidence: Confirmed (addresses: doc pc-02).
 * Callers: sub_1FD74, sub_2010C, sub_DEFA.
 * Packs the working record, writes it to 0x2E80 + 0x20*r3, rebuilds the
 * slot's attribute byte = (FFACD5 & 0xF3) | (FFACD9 & 0x0C) (two packer
 * scratch bytes; Inferred: header flags), stores it in FF8188[r3] and
 * EEPROM 0x2940 + r3, then the DG-ID word (mem_dgid_save, sub_3DE96).
 * ========================================================================== */
void mem_store(u16 slot) { rec_pack(pack_buf); mem_store_tail(slot); }
static void mem_store_tail(u16 slot)                  /* 03A7DC             */
{
    eeprom_write(0x2E80 + 0x20 * slot, pack_buf, 0x20);    /* 03A7F4        */
    u8 a = (pack_attr_D5 & 0xF3) | (pack_attr_D9 & 0x0C);  /* 03A7FA        */
    mem_attr[slot] = a;                               /* 03A810 FF8188[n]   */
    attr_tmp = a;                                     /* 03A814 FFACD4      */
    eeprom_write(0x2940 + slot, &attr_tmp, 1);        /* 03A82A             */
    mem_dgid_save(slot);                              /* 03A832 sub_3DE96   */
}

/* 03A838-03A892 size 90  mem_store_raw_attr (sub_3A838)  Confirmed.
 * Callers sub_75160, sub_753D4.  As mem_store but attribute = FFACD8 and
 * no DG-ID word write.                                                    */
void mem_store_raw_attr(u16 slot)
{
    rec_pack(pack_buf);
    eeprom_write(0x2E80 + 0x20 * slot, pack_buf, 0x20);
    mem_attr[slot] = attr_tmp = pack_attr_D8;         /* 03A864             */
    eeprom_write(0x2940 + slot, &attr_tmp, 1);
}

/* 03A892-03A8E2 size 80  mem_attr_put (sub_3A892)  Confirmed (flow).
 * Callers sub_16DCA, sub_1FE3A, sub_1FF1C.  r4l = attribute.  In a memory
 * area g != 0: areas 6 and 8 keep no attribute (return); otherwise the
 * slot is rebased by the word table mem_area_base[g] (0x03F1C4).  Store
 * FF8188[slot] = attr and EEPROM 0x2940 + slot.                            */
void mem_attr_put(u16 slot, u8 attr)
{
    u8 g = vfo_mem_group(cur_rec);                    /* 03A898 sub_3F1DC   */
    if (g) {
        if (g == 6 || g == 8) return;                 /* 03A89E / 03A8A2    */
        slot += mem_area_base[g];                     /* 03A8AE 0x03F1C4    */
    }
    mem_attr[slot] = attr; attr_tmp = attr;           /* 03A8BE / 03A8C2    */
    eeprom_write(0x2940 + slot, &attr_tmp, 1);        /* 03A8D8             */
}

/* 03A8E2-03A906 size 36  rec1200_name_store (sub_3A8E2)  Confirmed.
 * Caller sub_19516.  Name block (0x12 bytes at er0+0x22) -> FFAA56 ->
 * EEPROM 0x1200 + 0x20*r3 + 6.                                            */
void rec1200_name_store(const u8 *rec, u16 n)
{
    name_tmp_copy(rec);                               /* 03A8E6 sub_3A906   */
    eeprom_write(0x1200 + 0x20 * (u8)n + 6, name_tmp, 0x12);
}
/* 03A906-03A922 size 28  name_tmp_copy (sub_3A906): eepmov 0x12 bytes
 * er0+0x22 -> FFAA56 (the working record's name field).  Confirmed.       */
void name_tmp_copy(const u8 *rec) { memcpy(name_tmp, rec + 0x22, 0x12); }

/* 03A922-03A97A size 88  mem_name_store (sub_3A922)  Confirmed.
 * Caller sub_19516.  Area 0: name -> channel record 0x2E80+0x20*n+6;
 * area 3: name -> 0x0F80 + 0x12*n; any other area: nothing.               */
void mem_name_store(const u8 *rec, u16 n)
{
    u8 g = vfo_mem_group(rec);                        /* 03A926             */
    if (g == 0) {
        name_tmp_copy(rec);                           /* 03A948             */
        eeprom_write(0x2E80 + 0x20 * n + 6, name_tmp, 0x12);
    } else if (g == 3) {
        name_tmp_copy(rec);                           /* 03A930             */
        eeprom_write(0x0F80 + 0x12 * n, name_tmp, 0x12);
    }
}

/* 03A97A-03A98C size 18  area3_name_addr (sub_3A97A): er0 = 0xF80 +
 * 0x12*r3, r6 = 0x12.  Confirmed.
 * 03A98C-03A9A2 size 22  area3_name_clear (sub_3A98C)  Confirmed.
 * Caller sub_DEFA (factory defaults): writes the 18-byte ROM block at
 * 0x00F6D4 (blank name, Inferred) to area-3 name slot r3.                 */
void area3_name_clear(u16 n) { eeprom_write(0x0F80 + 0x12 * n, (const u8 *)0x00F6D4, 0x12); }

/* 03A9F6-03A9FC size 6  mem_flag_update_if_regular (sub_3A9F6)  Confirmed.
 * Caller sub_19406.  Returns when the band is in a special area, else
 * falls into mem_flag_update.
 * 03A9FC-03AA66 size 106  mem_flag_update (sub_3A9FC)  Confirmed (flow).
 * Read-modify-write of byte +5 of channel record r3: EEPROM -> FFAA56,
 * rec_byte5_edit (sub_3FAB2, outside chunk) edits it, EEPROM <- FFAA56.   */
void mem_flag_update(u16 slot)
{
    eeprom_read(0x2E80 + 0x20 * slot + 5, name_tmp, 1);  /* 03AA26          */
    rec_byte5_edit(name_tmp);                         /* 03AA2E sub_3FAB2   */
    eeprom_write(0x2E80 + 0x20 * slot + 5, name_tmp, 1); /* 03AA5C          */
}
/* 03AA66-03AAAC size 70  rec1200_flag_update (sub_3AA66)  Confirmed.
 * Same on byte +5 of the 0x1200-set record r3.  Caller sub_19406.         */
void rec1200_flag_update(u16 n)
{
    eeprom_read(0x1200 + 0x20 * (u8)n + 5, name_tmp, 1);
    rec_byte5_edit(name_tmp);
    eeprom_write(0x1200 + 0x20 * (u8)n + 5, name_tmp, 1);
}

/* ==========================================================================
 * 03AAAC-03AB5E  size 178  mem_same_band   (sub_3AAAC)
 * Confidence: Confirmed.  Callers: sub_1EF12, sub_20792, sub_23B60, 23C54.
 * r6l = memory area, r3 = slot, er0 = working record.  Sets AA33.b2, which
 * makes mem_rec_alt return early with er5 = its synthesised frequency.
 * Regular area: read the frequency bytes and rebuild the BCD value.  Then
 * band-plan lookup; clear AA33.b2; return Z = (id low byte == er0->[0x58])
 * - "the memory lies in the record's current band".
 * ========================================================================== */
int mem_same_band(u8 *rec, u16 slot, u8 area)
{
    u32 f;
    flags_AA33 |= 0x04;                               /* 03AAB0             */
    if (mem_rec_addr_g(slot, area) == 0) {            /* 03AABC sub_3AB5E   */
        eeprom_read(0x2E80 + 0x20 * slot + 2, pack_buf + 2, 3);  /* 03AAD2  */
        f = rec_freq_bcd(pack_buf);                   /* 03AAD6..03AB1E     */
    } else {
        f = *(u32 *)pack_buf;                         /* er5 from 03D1F6    */
    }
    u16 id = bandplan_find(f);                        /* 03AB20..03AB46     */
    flags_AA33 &= ~0x04;                              /* 03AB48             */
    return (u8)id == rec[0x58];                       /* 03AB56/03AB5A      */
}
/* 03AB5E-03AB80 size 34  mem_rec_addr_g (sub_3AB5E)  Confirmed.
 * r6l = area: non-zero -> jmp mem_rec_alt; else regular addressing.       */
int mem_rec_addr_g(u16 slot, u8 area) { return area ? mem_rec_alt(slot, area) : 0; }
