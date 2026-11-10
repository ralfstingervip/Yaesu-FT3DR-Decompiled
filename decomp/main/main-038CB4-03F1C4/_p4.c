
/* ######################################################################### *
 * PART 6  -  Settings writers, DTMF memories, special memory areas and     *
 *            the device-A2 (EEPROM 0x1xxxx) store accessors, 03CCBC..03DF86*
 * ######################################################################### */

/* 03CCBC-03CCD0 size 20  settings_R1_save_byte (sub_3CCBC)  Confirmed
 * (doc 32 "writer family").  52 callers (menu exit stubs 0x192xx).
 * r1 = n: writes byte FF8920+n to EEPROM 0x580+n (r6 = 1, enters 03CCD4).
 * 03CCD0-03CCEC size 28  settings_R1_save_range (sub_3CCD0)  Confirmed.
 * er1 = RAM pointer inside R1, r6 = length: EEPROM 0x580 + (er1-FF8920).   */
void settings_R1_save_byte(u16 n)            { settings_R1_save_range(settings_R1 + n, 1); }
void settings_R1_save_range(const u8 *p, u16 len) { eeprom_write(0x580 + (p - settings_R1), p, len); }

/* 03CCEC-03CD1C size 48  settings_R2_save_byte (sub_3CCEC)  Confirmed
 * (doc 32).  10 callers.  Byte FF8AA0+n -> EEPROM 0xC000+n.  The second
 * entry 03CD00 (settings_R2_save_range, er1/r6 given) is inside this
 * IDA function.                                                            */
void settings_R2_save_byte(u16 n)            { settings_R2_save_range(settings_R2 + n, 1); }
void settings_R2_save_range(const u8 *p, u16 len) { eeprom_write(0xC000 + (p - settings_R2), p, len); }

/* 03CD1C-03CD30 size 20  settings_R3_save_byte (sub_3CD1C)  Confirmed.
 * 03CD30-03CD4C size 28  settings_R3_save_range (sub_3CD30)  Confirmed.
 * Byte/range of R3 at FF8D20 -> EEPROM 0xD000 + offset (doc 32).          */
void settings_R3_save_byte(u16 n)            { settings_R3_save_range(settings_R3 + n, 1); }
void settings_R3_save_range(const u8 *p, u16 len) { eeprom_write(0xD000 + (p - settings_R3), p, len); }

/* 03CD4C-03CD5C size 16  rec1034_load (sub_3CD4C)  Confirmed (addressing).
 * 03CD5C-03CD6C size 16  rec1034_save (sub_3CD5C)  Confirmed.
 * 03CD6C-03CD82 size 22  rec1034_args (sub_3CD6C)  Confirmed.
 * 18-byte record r1 at EEPROM 0x1034 + 0x12*r1 <-> FFAD6E.  Callers
 * sub_15342, 15CCE, 4F38, 4FEA, 66EE / 19454, DEFA.  Meaning unknown
 * (18 = 2-byte attribute + 16-char text, like the name blocks; Inferred). */
void rec1034_load(u16 i) { eeprom_read(0x1034 + 0x12 * i, rec1034_buf, 0x12); }
void rec1034_save(u16 i) { eeprom_write(0x1034 + 0x12 * i, rec1034_buf, 0x12); }

/* 03CD82-03CDA0 size 30  bt_list_load (sub_3CD82)  Confirmed (doc 124).
 * 03CDA0-03CDBE size 30  bt_list_save (sub_3CDA0)  Confirmed (doc 124).
 * Bluetooth paired/found-device list: EEPROM 0x1EA00 (device A2), 0x8E
 * bytes <-> FFAAEA (list at FFAAEC, <= 5 entries).                         */
void bt_list_load(void) { eeprom2_read(0xEA00 /*0x1EA00*/, bt_list, 0x8E); }
void bt_list_save(void) { eeprom2_write(0xEA00 /*0x1EA00*/, bt_list, 0x8E); }

/* 03CDEA-03CDFC size 18  dtmf_mem_save_hi (sub_3CDEA)  Confirmed.
 * Caller sub_DEFA (defaults).  Saves FFAC24 as DTMF memory r3l + 16.
 * 03CE22-03CE32 size 16  dtmf_mem_load (sub_3CE22)  Confirmed.
 * 6 callers incl. dtmf_enqueue_request.  03CE32-03CE42 dtmf_mem_save
 * (sub_3CE32, caller DEFA).  03CE42-03CE5A dtmf_mem_args (sub_3CE42):
 * er0 = 0xA80 + 0x10*r3l, er1 = FFAC24, r6 = 0x10.  All Confirmed.
 * DTMF memories: 16 bytes each at EEPROM 0x0A80 (codes 0..15, 0xFF end). */
void dtmf_mem_load(u8 n)    { eeprom_read(0xA80 + 0x10 * n, dtmf_mem_buf, 0x10); }
void dtmf_mem_save(u8 n)    { eeprom_write(0xA80 + 0x10 * n, dtmf_mem_buf, 0x10); }
void dtmf_mem_save_hi(u8 n) { dtmf_mem_save((u8)(n + 0x10)); }

/* 03CE5A-03CE9A size 64  dtmf_mem_save_if_changed (sub_3CE5A)  Confirmed.
 * Caller sub_194E8.  Reads the stored memory into FFAC9A, compares 4
 * longs with FFAC24 and writes only on a difference.                      */
void dtmf_mem_save_if_changed(u8 n)
{
    eeprom_read(0xA80 + 0x10 * n, cmp_buf, 0x10);     /* 03CE62             */
    if (!blk_equal((u32 *)dtmf_mem_buf, (u32 *)cmp_buf, 4))
        dtmf_mem_save(n);                             /* 03CE8E             */
}

/* 03CE9A/03CEAA/03CEBA  area4_tab_load / _save / _args (sub_3CE9A,
 * sub_3CEAA, sub_3CEBA)  Confirmed.  EEPROM 0xBC00, 0x28 bytes <-> FFACE2
 * (two 20-byte arrays FFACE2[], FFACF6[] consumed by area 4 of
 * mem_rec_alt: tone mode / tone index per preset, Inferred).
 * Callers 195D2, 19674, 3CFE8 / 195D2, 19674, DEFA.                       */
void area4_tab_load(void) { eeprom_read(0xBC00, area_tab, 0x28); }
void area4_tab_save(void) { eeprom_write(0xBC00, area_tab, 0x28); }

/* 03CECC/03CEDC/03CEEC  area7_tab_load / _save / _args (sub_3CECC,
 * sub_3CEDC, sub_3CEEC)  Confirmed.  EEPROM 0xBBC0, 0x40 bytes <-> FFACE2
 * (three 20-byte arrays FFACE2/FFACF6/FFAD0A used by area 7).  The save
 * uses the single-page writer eeprom_write_page64.                        */
void area7_tab_load(void) { eeprom_read(0xBBC0, area_tab, 0x40); }
void area7_tab_save(void) { eeprom_write_page64(0xBBC0, area_tab); }

/* ==========================================================================
 * 03CEFE-03CF34  size 54   mem_rec_alt   (sub_3CEFE)
 * 03CF70-03CF72  size 2    nullsub_91 (area 2 handler)
 * 03CF72-03CF9C  size 42   area3_synth   (sub_3CF72)
 * 03CF9C-03CFE4  size 72   area5_synth   (sub_3CF9C)
 * 03CFE8-03D004  size 28   area4_synth   (sub_3CFE8)
 * 03D004-03D022  size 30   area6_synth   (sub_3D004)
 * 03D022-03D36E  size 844  area_synth_common (sub_3D022: area 6 tail,
 *                          areas 7/8/9/10/11, dead 800-MHz case, and the
 *                          shared record builder at 03D1EE)
 * Confidence: Confirmed (flow, constants); Inferred (what the areas are).
 * Entered by jmp from mem_rec_addr / mem_rec_addr_g with r3 = slot and
 * r4l = area.  Synthesises a channel for a "special memory area" instead
 * of reading the regular channel store:
 *   1. push er3; copy the 18-byte ROM blank block 0x00F6D4 to FFAC7A.
 *   2. jump through the table at 0x03CF34 (doc 115 / M5 heads):
 *        0,1 -> 03A700 (regular addressing; reached here this would return
 *               through the pushed er3 - unreachable, Inferred)
 *        2   -> 03CF70 rts (same stack caveat)
 *        3 -> area3_synth   4 -> area4_synth   5 -> area5_synth
 *        6 -> area6_synth   7 -> 03D090        8 -> 03D04A
 *        9 -> 03D150       10 -> 03D198       11 -> 03D1CA
 *      The case at 03D0EE (779.125 / 797.125 / 806.125 MHz bases, 71
 *      channels each) has no table slot: dead (doc 115).
 *   Each case leaves FFAC76 = frequency (8-digit BCD, 10 Hz), FFAC7A.. =
 *   name, r6h = area kind, r4h:r4l = two mode parameters, e6 = tone info.
 * ========================================================================== */
int mem_rec_alt(u16 slot, u8 area)
{
    /* push.l er3 / push.w r4 */
    memcpy(pack_buf + 4, (const u8 *)0x00F6D4, 0x12);   /* 03CF04           */
    switch (area) {                                   /* 03CF2A jmp @er6    */
    case 3:   /* 03CF72: user-named presets; names at EEPROM 0xF80+0x12n   */
        *(u32 *)pack_buf = rom_tab_3FFF4[slot];       /* 03CF76             */
        eeprom_read(0x0F80 + 0x12 * slot, pack_buf + 4, 0x12); /* 03CF8E    */
        return area_build(3, 0x00, 0x08, 0, slot);    /* jmp 03D1EE         */
    case 5: { /* 03CF9C: table 0x040362; low byte b0 = has shift          */
        u32 v = rom_tab_40362[slot];
        alt_tx_freq = 0;                              /* 03CFA4 FFACDE      */
        *(u32 *)pack_buf = v & 0xFFFFFF00;            /* 03CFBA             */
        if (v & 1) {
            alt_tx_freq = v & 0xFFFFFF00;             /* 03CFC4             */
            bcd_sub(&alt_tx_freq, (const u32 *)0x03CFE4); /* 03CFD6 3F94C   */
        }
        return area_build(5, 0x00, 0x07, 0, slot);
    }
    case 4: { /* 03CFE8: ROM table 0x04001C (0x16-byte rows) + EEPROM tab */
        area4_tab_load();                             /* 03CFE8             */
        u16 e6 = (u16)area_tab[0x14 + slot] << 8;     /* FFACF6[slot]       */
        return area_row(4, 0x04001C, 0x16, slot, area_tab[slot], e6, 0x12, 0);
    }
    case 6:   /* 03D004: ROM table 0x0415BA, 0x16-byte rows               */
        return area_row(6, 0x0415BA, 0x16, slot, 0, 0, 0x10, 1);
    case 8:   /* 03D04A: ROM table 0x040480, 0x14-byte rows, no attr word */
        return area_row(8, 0x040480, 0x14, slot, 0, 0, 0x10, 2);
    case 7: { /* 03D090: ROM table 0x040B74 + EEPROM tab (3 arrays)       */
        area7_tab_load();                             /* 03D090             */
        u16 e6 = ((u16)area_tab[0x14 + slot] << 8) | area_tab[0x28 + slot];
        return area_row(7, 0x040B74, 0x16, slot, area_tab[slot], e6, 0x12, 0);
    }
    case 9: { /* 03D150: computed; 6 channels from 322.025.00, then
                 322.250.00 upward, step 0x9C4 = 2500 x 10 Hz (25 kHz)   */
        u32 base = 0x32202500; u16 n = slot;
        if (n >= 6) { n -= 6; base = 0x32225000; }    /* 03D15C             */
        alt_bcd_tmp = base;                           /* FFAA3E             */
        *(u32 *)pack_buf = bin_to_bcd(bcd_to_bin(&alt_bcd_tmp) + 2500u * n);
        return area_build(9, 0x00, 0x07, 0, slot);    /* 03D146..03D194     */
    }
    case 10: { /* 03D198: table 0x0401BE; TX = RX - BCD const at 0x03D1C6 */
        u32 f = rom_tab_401BE[slot];
        *(u32 *)pack_buf = f; alt_tx_freq = f;        /* 03D1A2 / 03D1A8    */
        bcd_sub(&alt_tx_freq, (const u32 *)0x03D1C6); /* 03D1BA             */
        return area_build(10, 0x00, 0x03, 0, slot);
    }
    case 11: { /* 03D1CA: table 0x04020E; mode 4 for slots 11..27        */
        *(u32 *)pack_buf = rom_tab_4020E[slot];       /* 03D1CE             */
        u8 r4l = (slot >= 0x0B && slot < 0x1C) ? 4 : 3;
        return area_build(11, 0x00, r4l, 0, slot);
    }
    default:  /* 0..2: see header */
        return 0;
    }
    /* dead 03D0EE: bases 0x77912500 / 0x79712500 (slot-0x47) / 0x80612500
       (slot-0x8E), step 0x30D4 = 12500 x 10 Hz, r6h = 8, r4 = 0x0207.     */
}

/* Row-table cases (03D0AA / 03D0DE tail): er2 = table + stride*slot;
 * f = row[0..3] with the sub-kHz fix (sub_3FD02) -> FFAC76; name copied
 * from row+4 (18 bytes) or attr word row+4 / 16-byte name row+6 (area 6),
 * or attr 0 / name row+4 (area 8); r4h = row[3] >> 4, r4l = row[3] & 0xF. */
static int area_row(u8 kind, u32 tab, u16 stride, u16 slot, u8 r6l, u16 e6,
                    u16 namelen, int style)
{
    const u8 *row = (const u8 *)(tab + stride * slot);
    *(u32 *)pack_buf = bcd_fix_subkhz(*(const u32 *)row);   /* sub_3FD02    */
    if (style == 0) memcpy(pack_buf + 4, row + 4, 0x12);    /* 03D0C4       */
    else if (style == 1) { *(u16 *)(pack_buf + 4) = *(const u16 *)(row + 4);
                           memcpy(pack_buf + 6, row + 6, 0x10); } /* 03D02A */
    else { *(u16 *)(pack_buf + 4) = 0; memcpy(pack_buf + 6, row + 4, 0x10); }
    (void)namelen;
    return area_build(kind, row[3] >> 4, row[3] & 0x0F, ((u32)e6 << 16) | r6l, slot);
}

/* ==========================================================================
 * 03D1EE  area_build  (shared tail of sub_3D022)   Confirmed (flow).
 * If AA33.b2 (called from mem_same_band): return the frequency in er5,
 * copy FFAC7C.l to FFAC96 and exit (pop er3, r4l = 1).
 * Otherwise build a 0x3A-byte operating record in FFAD22:
 *   +0x19 = r4h, +0x14 = r4l, +0x12 = 0, +0x22..+0x33 = 18-byte name,
 *   +0x1A = frequency (also FFACDA), +0x1E/+0x15 = shift frequency and
 *   shift mode 3 for kinds 5/10 when FFACDE != 0 (else 0/0), +0x13 = 3,
 *   +0x37 = 0; tone fields: kind 4 -> +0x16 = r6l, +0x34 = e6 hi;
 *   kind 7 -> +0x16 = r6l, +0x17/+0x18 = e6 hi/lo; others -> +0x16 = 0,
 *   +0x17 = [FF92CC] (default CTCSS index), +0x18 = 0; +0x34 = 0x0D
 *   unless kind 4.  (Working-record offsets per doc 35 / doc 120.)
 * Then choose the target band: market 2..4 (sub_3ECDE Z) tests the range
 * table 0x0221F6, other markets 0x0221A8 (sub_3F5B2); in range -> band B
 * record FF90F0 (+8EA6.b0), else [FF812A] (8EA6.b0 cleared unless side B).
 * Copy FFAD34 (40 bytes, +0x12..) into target+0x12, target+0x39 = 0x98;
 * for band A: sub_15F96(r3l = kind-2) and clear +0x39.b7.  Finally
 * sub_EC0A (shift/tone fix-up), target+0x36 = 0, sub_1CBE6 (mode icons).
 * Return r4l = 1 (Z clear = "handled, not a regular slot").
 * ========================================================================== */
static int area_build(u8 kind, u8 r4h, u8 r4l, u32 e6r6l, u16 slot)
{
    if (flags_AA33 & 0x04) {                          /* 03D1EE             */
        cmp_buf[0x1C / 1] = 0; *(u32 *)(pack_buf + 0x20) = *(u32 *)(pack_buf + 6);
        return 1;                                     /* er5 = FFAC76       */
    }
    u8 *r = oprec_scratch;                            /* FFAD22             */
    r[0x19] = r4h; r[0x14] = r4l; r[0x12] = 0;        /* 03D212..03D21C     */
    memcpy(r + 0x22, pack_buf + 4, 0x12);             /* 03D236             */
    *(u32 *)(r + 0x1A) = *(u32 *)pack_buf;            /* 03D248             */
    alt_rx_freq = *(u32 *)pack_buf;                   /* 03D24E FFACDA      */
    if ((kind == 5 || kind == 10) && alt_tx_freq) {   /* 03D25A..03D268     */
        *(u32 *)(r + 0x1E) = alt_tx_freq; r[0x15] = 3;
    } else { *(u32 *)(r + 0x1E) = 0; r[0x15] = 0; }
    r[0x13] = 3; r[0x37] = 0;                         /* 03D280..03D288     */
    u8 r6l = (u8)e6r6l; u16 e6 = (u16)(e6r6l >> 16);
    if (kind == 4) { r[0x16] = r6l; r[0x34] = e6 >> 8; r[0x17] = def_ctcss; r[0x18] = 0; }
    else {
        r[0x34] = 0x0D;                               /* 03D29C             */
        if (kind == 7) { r[0x16] = r6l; r[0x17] = e6 >> 8; r[0x18] = (u8)e6; }
        else { r[0x16] = 0; r[0x17] = def_ctcss; r[0x18] = 0; } /* 03D2B6   */
    }
    const void *tab = market_is_2_to_4() ? (const void *)0x0221F6
                                         : (const void *)0x0221A8;  /* 03D2CC */
    u8 *dst;
    if (freq_in_range_tab(alt_rx_freq, tab) == 0) {   /* sub_3F5B2 Z        */
        dst = (u8 *)0xFF90F0; band_slot_chk |= 0x01;  /* 03D30E             */
    } else {
        dst = bandA_rec;                              /* 03D2F8             */
        if (!SIDE_B) band_slot_chk &= ~0x01;
    }
    memcpy(dst + 0x12, r + 0x12, 0x28);               /* 03D31A eepmov      */
    dst[0x39] = 0x98;                                 /* 03D336             */
    if (dst != (u8 *)0xFF90F0) {
        rec_area_flag(dst, kind - 2);                 /* 03D34A sub_15F96   */
        dst[0x39] &= ~0x80;                           /* 03D352             */
    }
    rec_shift_tone_fixup(dst);                        /* 03D358 sub_EC0A    */
    dst[0x36] = 0;                                    /* 03D35E             */
    rec_mode_icons(dst);                              /* 03D362 sub_1CBE6   */
    (void)slot;
    return 1;                                         /* 03D36A r4l = 1     */
}

/* 03D37E-03D38E size 16  rec_B800_save (sub_3D37E)  Confirmed (addressing).
 * 03D38E-03D3A6 size 24  rec_B800_args (sub_3D38E): er0 = 0xB800 + 8*r3l,
 * er1 = FFAA10, r6 = 8.  Caller sub_DEFA.  Meaning unknown.              */
void rec_B800_save(u8 n) { eeprom_write(0xB800 + 8 * n, rec_B800_buf, 8); }

/* 03D40E-03D41E size 16  rec_B8C0_save (sub_3D40E)  Confirmed (addressing).
 * 03D41E-03D436 size 24  rec_B8C0_args (sub_3D41E): er0 = 0xB8C0 +
 * 0x12*r3l, er1 = FFAA18, r6 = 0x12.  Caller sub_DEFA.                   */
void rec_B8C0_save(u8 n) { eeprom_write(0xB8C0 + 0x12 * n, rec_B8C0_buf, 0x12); }

/* 03D472/03D482/03D492  eeprom_load_R2 / eeprom_save_R2 / eeprom_args_R2
 * (sub_3D472, sub_3D482, sub_3D492)  Confirmed (doc 32).  EEPROM 0xC000,
 * 0x280 bytes <-> settings region R2 FF8AA0.  Callers sub_452AC / 103F2. */
void eeprom_load_R2(void) { eeprom_read(0xC000, settings_R2, 0x280); }
void eeprom_save_R2(void) { eeprom_write(0xC000, settings_R2, 0x280); }

/* 03D4A4/03D4B4/03D4C4  rec_C280_load / _save / _args  Confirmed (addr.).
 * 0x1C-byte record r3l at EEPROM 0xC280 + 0x1C*r3l <-> FF9D74.           */
void rec_C280_load(u8 n) { eeprom_read(0xC280 + 0x1C * n, rec_C280_buf, 0x1C); }
void rec_C280_save(u8 n) { eeprom_write(0xC280 + 0x1C * n, rec_C280_buf, 0x1C); }

/* ==========================================================================
 * 03D4DC-03D542  size 102  rec_E000_load   (sub_3D4DC)
 * 03D542-03D5AC  size 106  rec_E000_save   (sub_3D542)
 * Confidence: Confirmed (flow); meaning unknown.  Callers sub_46850 /
 * sub_46BBC, sub_DEFA.  Slots r3l >= 2 only.  30-byte records at EEPROM
 * 0xE000 + 0x1E*r3l, staged through FF95F8 (shared with the SCI-A ring,
 * doc 05).  Byte 0 is a type: 0 -> RAM copy FFA7E2, 8 -> FFA800, other ->
 * FF9DB8.  Load copies the record to that buffer, then writes the type
 * byte into all three buffers.  Save takes type = r3h, copies the chosen
 * buffer to FF95F8 (forcing byte 0 = type), writes it, then stamps the
 * type into all three.
 * ========================================================================== */
void rec_E000_load(u8 n)
{
    if (n < 2) return;                                /* 03D4DC             */
    eeprom_read(0xE000 + 0x1E * n, sci_a_alt_ring, 0x1E);   /* 03D4FA       */
    u8 t = sci_a_alt_ring[0];
    u8 *dst = (t == 0) ? bufA7E2 : (t == 8) ? bufA800 : buf9DB8;
    memcpy(dst, sci_a_alt_ring, 0x1E);                /* 03D524             */
    bufA7E2[0] = buf9DB8[0] = bufA800[0] = t;         /* 03D52C..03D538     */
}
void rec_E000_save(u8 n, u8 type)
{
    if (n < 2) return;                                /* 03D542             */
    sci_a_alt_ring[0] = type;                         /* 03D550             */
    const u8 *src = (type == 0) ? bufA7E2 : (type == 8) ? bufA800 : buf9DB8;
    memcpy(sci_a_alt_ring, src, 0x1E);                /* 03D570             */
    sci_a_alt_ring[0] = type;                         /* 03D578             */
    eeprom_write(0xE000 + 0x1E * n, sci_a_alt_ring, 0x1E);  /* 03D592       */
    bufA7E2[0] = buf9DB8[0] = bufA800[0] = sci_a_alt_ring[0];
}

/* 03D5AC/03D5BC/03D5CC  rec_C3A0_load / _save / _args  Confirmed (addr.).
 * 0x3C-byte record r3l at EEPROM 0xC3A0 + 0x3C*r3l <-> FFADA2.
 * 03D5E4/03D5F4/03D604  rec_C4D0_load / _save / _args  Confirmed (addr.).
 * 0x43-byte record r3l at EEPROM 0xC4D0 + 0x43*r3l <-> FFADDE.            */
void rec_C3A0_load(u8 n) { eeprom_read(0xC3A0 + 0x3C * n, rec_C3A0_buf, 0x3C); }
void rec_C3A0_save(u8 n) { eeprom_write(0xC3A0 + 0x3C * n, rec_C3A0_buf, 0x3C); }
void rec_C4D0_load(u8 n) { eeprom_read(0xC4D0 + 0x43 * n, rec_C4D0_buf, 0x43); }
void rec_C4D0_save(u8 n) { eeprom_write(0xC4D0 + 0x43 * n, rec_C4D0_buf, 0x43); }

/* 03D64E-03D66C size 30  eeprom_load_R3 (sub_3D64E)  Confirmed (doc 32).
 * 03D66C-03D68A size 30  eeprom_save_R3 (sub_3D66C)  Confirmed (doc 32).
 * EEPROM 0xD000, 0x180 bytes <-> settings region R3 FF8D20.               */
void eeprom_load_R3(void) { eeprom_read(0xD000, settings_R3, 0x180); }
void eeprom_save_R3(void) { eeprom_write(0xD000, settings_R3, 0x180); }

/* 03D6B0-03D6D6 size 38  eeprom_save_R3_7E (sub_3D6B0)  Confirmed.
 * 5 callers (0x60xxx-0x63xxx, digital/WIRES-X code).  Saves the R3
 * sub-block n = 0x7E..0xAE (0x31 bytes) FF8D9E -> EEPROM 0xD07E.  (Doc 32
 * says "n = 0x7E..0xAF"; the count is 0x31, so the last byte is 0xAE.)   */
void eeprom_save_R3_7E(void) { eeprom_write(0xD07E, settings_R3 + 0x7E, 0x31); }

/* 03D6D6/03D6E6/03D6F6  rec_D280_load / _save / _args  Confirmed (addr.).
 * 0x5D-byte record r3l at EEPROM 0xD280 + 0x5D*r3l <-> FFAE22.            */
void rec_D280_load(u8 n) { eeprom_read(0xD280 + 0x5D * n, rec_D280_buf, 0x5D); }
void rec_D280_save(u8 n) { eeprom_write(0xD280 + 0x5D * n, rec_D280_buf, 0x5D); }

/* 03D74A-03D75A size 16  eeprom2_load_marker (sub_3D74A)  Confirmed.
 * Caller sub_DDA0.  Device A2 address 0x10 (EEPROM 0x10010), 4 bytes ->
 * FF800A: the second device's boot marker (doc pc-02 "probably").
 * 03D75A-03D768 size 14  eeprom2_mark_valid (sub_3D75A)  Confirmed.
 * FF800A = "TAIS" (ROM 0xDD0E), falls into eeprom2_save_marker.  No
 * static caller.  03D768 eeprom2_save_marker (sub_3D768, caller sub_DBD8),
 * 03D778 eeprom2_args_marker (sub_3D778).                                 */
void eeprom2_load_marker(void) { eeprom2_read(0x10, boot_marker2, 4); }
void eeprom2_mark_valid(void)  { *(u32 *)boot_marker2 = *(const u32 *)0x00DD0E; eeprom2_save_marker(); }
void eeprom2_save_marker(void) { eeprom2_write(0x10, boot_marker2, 4); }

/* 03D78A/03D79A/03D7AA  eeprom2_load_10100 / _save / _args  Confirmed.
 * EEPROM 0x10100 (A2 0x0100), 0x780 bytes <-> FEE000 (clone staging RAM,
 * doc 05).  0x780 = 60 x 0x20 headers (Inferred from 03D7BC).             */
void eeprom2_load_10100(void) { eeprom2_read(0x0100, (u8 *)0xFEE000, 0x780); }
void eeprom2_save_10100(void) { eeprom2_write(0x0100, (u8 *)0xFEE000, 0x780); }

/* 03D7BC-03D7E0 size 36  msgA_hdr_save (sub_3D7BC)  Confirmed (addressing).
 * Caller sub_504F2.  32-byte header FF9DE8 -> EEPROM 0x10100 + 0x20*r3l.
 * 03D7E0-03D828 size 72  msgA_save (sub_3D7E0)  Confirmed.  Caller 49EBE.
 * Header as above plus body FF9EF8, length [FF9E04]+2, -> 0x10880 +
 * 0xB0*r3l.  03D828 msgA_body_load (sub_3D828, len [FF9E24]+2 -> FF9E48),
 * 03D854 msgA_body_load2 (sub_3D854, len e6+2 -> FF9FA8).  All Confirmed.
 * Record store "A": 60 headers of 0x20 + 60 bodies of 0xB0 (Inferred:
 * message/log records; the 0x50xxx callers are the APRS/message code).  */
void msgA_hdr_save(u8 n)  { eeprom2_write(0x0100 + 0x20 * n, msg_hdr, 0x20); }
void msgA_save(u8 n)
{
    eeprom2_write(0x0100 + 0x20 * n, msg_hdr, 0x20);                 /* 03D7FC */
    eeprom2_write(0x0880 + 0xB0 * n, msg_body_out, msg_len_out + 2); /* 03D81E */
}
void msgA_body_load(u8 n)          { eeprom2_read(0x0880 + 0xB0 * n, msg_body_in, msg_len_in + 2); }
void msgA_body_load2(u8 n, u16 e6) { eeprom2_read(0x0880 + 0xB0 * n, msg_body_cmp, e6 + 2); }

/* 03D87E/03D88E/03D89E  eeprom2_load_131C0 / _save / _args  Confirmed.
 * EEPROM 0x131C0 (A2 0x31C0), 0x780 bytes <-> FEE780.
 * 03D8B0 msgB_hdr_save (FF9DE8), 03D8D4 msgB_hdr_save2 (FF9E28),
 * 03D8F8 msgB_hdr_put (er3 = src, r5l = slot): 0x20 bytes -> 0x131C0 +
 * 0x20*n.  03D918 msgB_body_load ([9E24]+2 -> FF9E48), 03D944 msgB_body_
 * save (FF9EF8, [9E04]+2), 03D970 msgB_body_load_full (0x90 -> FFA62C):
 * bodies at 0x13940 + 0x90*n.  All Confirmed (addressing).  Store "B" =
 * 60 x 0x20 headers + 60 x 0x90 bodies.                                    */
void eeprom2_load_131C0(void) { eeprom2_read(0x31C0, (u8 *)0xFEE780, 0x780); }
void eeprom2_save_131C0(void) { eeprom2_write(0x31C0, (u8 *)0xFEE780, 0x780); }
void msgB_hdr_save(u8 n)  { eeprom2_write(0x31C0 + 0x20 * n, msg_hdr, 0x20); }
void msgB_hdr_save2(u8 n) { eeprom2_write(0x31C0 + 0x20 * n, msg_hdr2, 0x20); }
void msgB_hdr_put(u8 n, const u8 *src) { eeprom2_write(0x31C0 + 0x20 * n, src, 0x20); }
void msgB_body_load(u8 n)      { eeprom2_read(0x3940 + 0x90 * n, msg_body_in, msg_len_in + 2); }
void msgB_body_save(u8 n)      { eeprom2_write(0x3940 + 0x90 * n, msg_body_out, msg_len_out + 2); }
void msgB_body_load_full(u8 n) { eeprom2_read(0x3940 + 0x90 * n, msg_body_A62C, 0x90); }

/* ==========================================================================
 * 03D994-03DA10  size 124  msgB_body_compare   (sub_3D994)
 * Confidence: Confirmed (flow); Inferred (duplicate-message test).
 * Caller sub_4A266.  e6 = stored body length, r6 = reference length.
 * n = min(e6 - 0x2A, r6 - 1) -> FFA558; reads body r3l (e6+2 bytes) into
 * FF9FA8 and compares n bytes of its text (FF9FD2 = +0x2A) with FF9F22.
 * FFA557 = 0 when equal, 1 when different.  Compares word-wise, with a
 * byte step when n is odd.
 * ========================================================================== */
void msgB_body_compare(u8 n, u16 e6, u16 r6)
{
    u16 cnt = e6 - 0x2A;                              /* 03D998             */
    if (cnt >= r6) cnt = r6 - 1;                      /* 03D99E..03D9A4     */
    msg_cmp_len = cnt;                                /* 03D9A6 FFA558      */
    eeprom2_read(0x3940 + 0x90 * n, msg_body_cmp, e6 + 2);   /* 03D9C6      */
    msg_cmp_diff = memcmp(msg_text_ref, msg_body_cmp + 0x2A, cnt) ? 1 : 0;
}

/* 03DA10/03DA20/03DA30  msgB_tail_load / _save / _args  Confirmed.
 * 0x60 bytes at body+0x2A (EEPROM 0x13940 + 0x90*n + 0x2A) <-> FFA56C.
 * 03DA52 msgB_tail_load2 (sub_3DA52): same bytes -> FFA5CC.  Callers
 * 0x5066E / 0x50EA8 / 0x5469C.                                            */
void msgB_tail_load(u8 n)  { eeprom2_read(0x3940 + 0x90 * n + 0x2A, msg_tail, 0x60); }
void msgB_tail_save(u8 n)  { eeprom2_write(0x3940 + 0x90 * n + 0x2A, msg_tail, 0x60); }
void msgB_tail_load2(u8 n) { eeprom2_read(0x3940 + 0x90 * n + 0x2A, msg_tail2, 0x60); }

/* 03DA80/03DA90/03DAA0  eeprom2_load_1C000 / _save / _args  Confirmed.
 * EEPROM 0x1C000, 0x110 bytes <-> FFB4A8.  NB: 03DCB2/03DCD0 read and
 * write 0x180 bytes at the SAME address into FF4576 - two views of one
 * region (finding; which is current is not resolved).                     */
void eeprom2_load_1C000(void) { eeprom2_read(0xC000, buf_B4A8, 0x110); }
void eeprom2_save_1C000(void) { eeprom2_write(0xC000, buf_B4A8, 0x110); }

/* 03DAB2-03DAD4 size 34  group_name_load (sub_3DAB2)  Confirmed (doc 122).
 * 03DAD4-03DAF6 size 34  group_name_save (sub_3DAD4)  Confirmed.
 * 16-byte group name r1 at EEPROM 0x1B000 + 0x10*r1 <-> FFB9F2 (doc 122:
 * "GROUP 01".."GROUP 16" defaults are copied to FFB9F2).                  */
void group_name_load(u16 i) { eeprom2_read(0xB000 + 0x10 * i, group_name, 0x10); }
void group_name_save(u16 i) { eeprom2_write(0xB000 + 0x10 * i, group_name, 0x10); }

/* 03DAF6-03DB18 size 34  group_items_load (sub_3DAF6)  Confirmed.
 * 03DB18-03DB3A size 34  group_items_save (sub_3DB18)  Confirmed.
 * 30-byte item list of group r1 at EEPROM 0x1B0A0 + 0x1E*r1 <-> FFBA12
 * (doc 122: 6-byte-stride entries -> 5 per group).                       */
void group_items_load(u16 i) { eeprom2_read(0xB0A0 + 0x1E * i, group_items, 0x1E); }
void group_items_save(u16 i) { eeprom2_write(0xB0A0 + 0x1E * i, group_items, 0x1E); }

/* 03DB3A/03DB58  blk_1B200_load / _save (sub_3DB3A/sub_3DB58), and
 * 03DB76/03DB94  blk_1B300_load / _save (sub_3DB76/sub_3DB94)  Confirmed.
 * 0x90 bytes at EEPROM 0x1B200 / 0x1B300 <-> FF96F8.  Callers 0x24xxx.   */
void blk_1B200_load(void) { eeprom2_read(0xB200, buf_96F8, 0x90); }
void blk_1B200_save(void) { eeprom2_write(0xB200, buf_96F8, 0x90); }
void blk_1B300_load(void) { eeprom2_read(0xB300, buf_96F8, 0x90); }
void blk_1B300_save(void) { eeprom2_write(0xB300, buf_96F8, 0x90); }

/* ==========================================================================
 * 03DBB2-03DBCC  size 26   tab24_load    (sub_3DBB2)
 * 03DBCC-03DBEA  size 30   tab24_save    (sub_3DBCC)
 * 03DBEA-03DC00  size 22   tab24_args    (sub_3DBEA)
 * 03DC00-03DC24  size 36   tab24_unpack  (sub_3DC00)
 * 03DC24-03DC48  size 36   tab24_pack    (sub_3DC24)
 * Confidence: Confirmed.  Callers sub_63C94 / sub_6876E, sub_DEFA.
 * Record r3l of 0x168 bytes at EEPROM 0x1C110 + 0x168*r3l, staged in
 * FF95F8: 24 entries of 15 bytes, expanded into FFB5B8 with a 0x20 stride
 * (unpack) or compacted back (pack).
 * ========================================================================== */
void tab24_unpack(void)
{
    const u8 *s = sci_a_alt_ring;
    for (u8 i = 0; i < 24; i++, s += 15) memcpy(tab24 + 0x20 * i, s, 15);
}
void tab24_pack(void)
{
    u8 *d = sci_a_alt_ring;
    for (u8 i = 0; i < 24; i++, d += 15) memcpy(d, tab24 + 0x20 * i, 15);
}
void tab24_load(u8 n) { eeprom2_read(0xC110 + 0x168 * n, sci_a_alt_ring, 0x168); tab24_unpack(); }
void tab24_save(u8 n) { tab24_pack(); eeprom2_write(0xC110 + 0x168 * n, sci_a_alt_ring, 0x168); }

/* 03DC7A/03DC8A/03DC9A  rec_1D8F8_load / _save / _args  Confirmed (addr.).
 * 0x50-byte record r3l at EEPROM 0x1D8F8 + 0x50*r3l <-> FFB8D8 (IDA shows
 * the immediate as "sub_1D8F8"; it is an EEPROM address).                 */
void rec_1D8F8_load(u8 n) { eeprom2_read(0xD8F8 + 0x50 * n, buf_B8D8, 0x50); }
void rec_1D8F8_save(u8 n) { eeprom2_write(0xD8F8 + 0x50 * n, buf_B8D8, 0x50); }

/* 03DCB2-03DCD0 size 30  blk_1C000_load_wide (sub_3DCB2)  Confirmed.
 * 03DCD0-03DCEE size 30  blk_1C000_save_wide (sub_3DCD0)  Confirmed.
 * 0x180 bytes EEPROM 0x1C000 <-> FF4576 (see the note at 03DA80).
 * 03DCEE-03DD14 size 38  blk_1C000_put16 (sub_3DCEE)  Confirmed.
 * Writes entry r3l (16 bytes) FF4576 + 0x10n -> 0x1C000 + 0x10n.          */
void blk_1C000_load_wide(void) { eeprom2_read(0xC000, buf_4576, 0x180); }
void blk_1C000_save_wide(void) { eeprom2_write(0xC000, buf_4576, 0x180); }
void blk_1C000_put16(u8 n)     { eeprom2_write(0xC000 + 0x10 * n, buf_4576 + 0x10 * n, 0x10); }

/* 03DD14/03DD32  blk_1E000_load / _save (sub_3DD14/sub_3DD32)  Confirmed.
 * 0x50 bytes EEPROM 0x1E000 <-> FFAE22 (the same RAM as rec_D280).
 * 03DD50/03DD74  rec_1E050_load / _save (sub_3DD50/sub_3DD74) Confirmed.
 * 0x1E0-byte record r3l at 0x1E050 + 0x1E0*r3l <-> FFB5B8 (the tab24 RAM). */
void blk_1E000_load(void) { eeprom2_read(0xE000, rec_D280_buf, 0x50); }
void blk_1E000_save(void) { eeprom2_write(0xE000, rec_D280_buf, 0x50); }
void rec_1E050_load(u8 n) { eeprom2_read(0xE050 + 0x1E0 * n, tab24, 0x1E0); }
void rec_1E050_save(u8 n) { eeprom2_write(0xE050 + 0x1E0 * n, tab24, 0x1E0); }

/* 03DD98/03DDA8/03DDB8  pic_state_load / _save / _args  Confirmed.
 * 0x80 bytes EEPROM 0x1FA00 <-> FF2F4A.  Doc 74: the last-picture name
 * stem is read from FF2F9E (= FF2F4A + 0x54) after this load.             */
void pic_state_load(void) { eeprom2_read(0xFA00, pic_state, 0x80); }
void pic_state_save(void) { eeprom2_write(0xFA00, pic_state, 0x80); }

/* 03DDFC-03DE20 size 36  mem_read_raw (sub_3DDFC)  Confirmed.
 * Callers sub_D642, sub_DA6E.  Channel record r3 -> FFAC76, no unpack.    */
void mem_read_raw(u16 slot) { eeprom_read(0x2E80 + 0x20 * slot, pack_buf, 0x20); }

/* ==========================================================================
 * DG-ID word cache (doc 61, doc 82).  EEPROM device A2:
 *   0x1A000 + 2n   0x1200-set records (12)       RAM FF4726
 *   0x1A018 + 2b   per-band VFO, side A (12)     RAM FF473E
 *   0x1A030 + 2b   per-band VFO, side B (12)     RAM FF4756
 *   0x1A080 + 2n   channel slots (1100)          RAM FF476E
 * The working word is FF8ED6/D7 for side A and FF8ED8/D9 for side B
 * (selected by FF817E.b0 here).  Doc 82 calls D6 the "RX" and D8 the "TX"
 * DG-ID word, chosen by FF8EA0.b6; in these routines the choice is the A/B
 * edit side, so each word is per band (two bytes, presumably one DG-ID per
 * direction) - a correction of the RX/TX reading, Inferred.
 * ========================================================================== */

/* 03DE20-03DE52 size 50  dgid_cache_load (sub_3DE20)  Confirmed (doc 61).
 * Caller sub_ED16 (boot).  0x48 bytes 0x1A000 -> FF4726 and 0x898 bytes
 * 0x1A080 -> FF476E.
 * 03DE52-03DE84 size 50  dgid_cache_save (sub_3DE52)  Confirmed.  Caller
 * sub_DEFA.  The same two ranges back.                                    */
void dgid_cache_load(void) { eeprom2_read(0xA000, dgid_hdr, 0x48); eeprom2_read(0xA080, dgid_mem, 0x898); }
void dgid_cache_save(void) { eeprom2_write(0xA000, dgid_hdr, 0x48); eeprom2_write(0xA080, dgid_mem, 0x898); }

/* Shared write-through tail 03DED0/03DED2: entry n (r3), table er0/er1;
 * old = cache[n]; new = SIDE_B ? FF8ED8:D9 : FF8ED6:D7; if changed store it
 * and write the 2 bytes to EEPROM2.                                       */
static void dgid_put(u32 ee, u16 *cache, u16 n)
{
    u16 nw = SIDE_B ? ((dgid_B_hi << 8) | dgid_B_lo) : ((dgid_A_hi << 8) | dgid_A_lo);
    if (cache[n] == nw) return;                       /* 03DEFA             */
    cache[n] = nw;                                    /* 03DEFE             */
    eeprom2_write(ee + 2 * n, &cache[n], 2);          /* 03DF00             */
}
static void dgid_get(u16 *cache, u16 n)               /* 03DF56/03DF58 tail */
{
    u16 w = cache[n];
    if (SIDE_B) { dgid_B_hi = w >> 8; dgid_B_lo = (u8)w; }
    else        { dgid_A_hi = w >> 8; dgid_A_lo = (u8)w; }
}
/* 03DE84-03DE96 size 18  rec1200_dgid_save (sub_3DE84)  Confirmed.        */
void rec1200_dgid_save(u16 n) { dgid_put(0xA000, (u16 *)dgid_hdr, (u8)n); }
/* 03DE96-03DEA8 size 18  mem_dgid_save (sub_3DE96)  Confirmed (doc 61).   */
void mem_dgid_save(u16 slot)  { dgid_put(0xA080, (u16 *)dgid_mem, slot); }
/* 03DEA8-03DF0A size 98  vfo_dgid_save (sub_3DEA8)  Confirmed.
 * Band = rec[3]; table 0x1A018/FF473E (A) or 0x1A030/FF4756 (B).         */
void vfo_dgid_save(const u8 *rec)
{
    if (SIDE_B) dgid_put(0xA030, (u16 *)(dgid_hdr + 0x30), rec[3]);
    else        dgid_put(0xA018, (u16 *)(dgid_hdr + 0x18), rec[3]);
}
/* 03DF0A-03DF1C size 18  rec1200_dgid_load (sub_3DF0A)  Confirmed.
 * 03DF1C-03DF2E size 18  mem_dgid_load (sub_3DF1C)  Confirmed (doc 61).
 * 03DF2E-03DF86 size 88  vfo_dgid_load (sub_3DF2E)  Confirmed.
 * RAM-cache reads into the working word (no EEPROM access).               */
void rec1200_dgid_load(u16 n) { dgid_get((u16 *)dgid_hdr, (u8)n); }
void mem_dgid_load(u16 slot)  { dgid_get((u16 *)dgid_mem, slot); }
void vfo_dgid_load(const u8 *rec)
{
    dgid_get((u16 *)(dgid_hdr + (SIDE_B ? 0x30 : 0x18)), rec[3]);
}
