
/* ######################################################################### *
 * PART 5  -  Bit-banged I2C serial-EEPROM drivers (03AB80..03CCBC)         *
 *                                                                           *
 * One GPIO port (doc 82: registers Confirmed, port letter Inferred):       *
 *   FFFBA4 (P_DR)   b0 = SDA level, b1 = SCL level (1 = high)             *
 *   FFFBA8 (P_DDR)  write-only; b0 = SDA direction (1 = output), kept in   *
 *                   the RAM shadow FF816E (copied to r2l on entry and      *
 *                   stored back on exit)                                   *
 *   FFFBA0 (PORT)   b0 = SDA input                                         *
 * Every edge is followed by 5 or 10 nops (bit-time padding, elided here). *
 * Two device pairs (doc 82, doc pc-02):                                    *
 *   0xA0/0xA1  EEPROM 0x00000-0x0FFFF  (16-bit word address)              *
 *   0xA2/0xA3  EEPROM 0x10000-0x1FFFF  (block-select bit = A16)            *
 * Bytes go out MSB first (rotxl -> C, bst C -> SDA); after 8 bits SDA is   *
 * released (DDR b0 = 0), SCL pulsed and the ACK sampled from PORT b0.      *
 * A NACK on the device/address bytes branches to a retry stub outside this *
 * chunk (loc_3B0E4 / loc_3C310: ACK polling while a write cycle runs).     *
 * Writes split at 256-byte boundaries (eeprom_write / eeprom2_write); the  *
 * page writers below send 64 bytes per START.                              *
 * ######################################################################### */

#define SDA_H()   (P_DR |=  0x01)
#define SDA_L()   (P_DR &= ~0x01)
#define SCL_H()   (P_DR |=  0x02)
#define SCL_L()   (P_DR &= ~0x02)
#define SDA_IN()  (P_DDR = (ddr &= ~0x01))
#define SDA_OUT() (P_DDR = (ddr |=  0x01))

/* i2c_stop (inlined everywhere): SCL low, SDA low, SCL high, SDA high.    */
#define I2C_STOP() do { SCL_L(); SDA_L(); SCL_H(); SDA_H(); } while (0)

/* ==========================================================================
 * 03AB80-03AD20  size 416  eeprom_read   (sub_3AB80)
 * Confidence: Confirmed (doc 25/82/96).  51 callers.
 * er0 = EEPROM address (device A0), er1 = RAM dst, r6 = count.
 * START + 0xA0 + address (i2c_addr_A0), repeated START, 0xA1, then clocks
 * in r6 bytes, ACKing all but the last; the last byte is followed directly
 * by STOP (no separate NACK clock).
 * ========================================================================== */
void eeprom_read(u32 ee, u8 *dst, u16 n)
{
    u8 ddr = io_ddr_shadow;                           /* 03AB80 FF816E      */
    i2c_addr_A0(ee);                                  /* 03AB84 sub_3B14C   */
    SDA_H(); SCL_H(); SDA_L(); SCL_L();               /* 03AB88 rep. START  */
    i2c_put_A0(0xA1);                                 /* 03ABF0 sub_3B19A   */
    for (;;) {
        SDA_IN();                                     /* 03ABF6             */
        u8 b = 0;
        for (u8 i = 8; i; --i) {                      /* 03AC06 r4h = 8     */
            SCL_H();                                  /* 03AC08             */
            b = (b << 1) | (P_PORT & 1);              /* 03AC22 bld/rotxl   */
            SCL_L();                                  /* 03AC34             */
        }
        *dst++ = b;                                   /* 03AC52             */
        SDA_OUT();                                    /* 03AC56             */
        if (--n == 0) break;                          /* 03AC5C             */
        SDA_L(); SCL_H(); SCL_L();                    /* 03AC60 ACK         */
    }
    I2C_STOP();                                       /* 03ACB2             */
    io_ddr_shadow = ddr;                              /* 03AD1A             */
}

/* ==========================================================================
 * 03AD20-03B0E4  size 964  eeprom_write   (sub_3AD20)
 * Confidence: Confirmed.  44 callers.
 * er0 = EEPROM address, er1 = RAM src, r6 = count.  Sends bytes after one
 * START/address; when the address crosses a 256-byte boundary it issues
 * STOP and re-addresses (the NACK retry inside i2c_addr_A0 waits out the
 * internal write cycle).  Data-byte ACKs are sampled but not checked.  The
 * 8 bit-times per byte are fully unrolled in ROM.
 * ========================================================================== */
void eeprom_write(u32 ee, const u8 *src, u16 n)
{
    u8 ddr = io_ddr_shadow;                           /* 03AD20             */
    SDA_H(); SCL_H();                                 /* 03AD24 idle bus    */
    for (;;) {
        i2c_addr_A0(ee);                              /* 03AD58             */
        for (;;) {
            u8 b = *src++;                            /* 03AD5C             */
            for (u8 i = 0; i < 8; i++) {              /* unrolled           */
                SCL_L(); if (b & 0x80) SDA_H(); else SDA_L(); b <<= 1; SCL_H();
            }
            SCL_L(); SDA_L(); SDA_IN(); SCL_H();      /* 03AF8E..03AFC8     */
            (void)P_PORT;                             /* 03AFE2 ack ignored */
            SCL_L(); SDA_OUT();                       /* 03AFE6..03AFF8     */
            if (--n == 0) {                           /* 03AFFC             */
                I2C_STOP(); io_ddr_shadow = ddr;      /* 03B076..03B0DE     */
                return;
            }
            ee++;                                     /* 03B000             */
            if ((ee & 0xFF) == 0) break;              /* 03B002 page wrap   */
        }
        I2C_STOP();                                   /* 03B00A..03B058     */
    }
}

/* ==========================================================================
 * 03B14C-03B19A  size 78   i2c_addr_A0   (sub_3B14C)
 * Confidence: Confirmed (doc 96).  Callers: 3AB80, 3AD20, 3B43C, 3B770,
 * 3BA90.  START (SDA low then SCL low; the bus is high on entry), then
 * 0xA0, r0h, r0l; any NACK -> loc_3B0E4 retry (outside this chunk).
 * ========================================================================== */
void i2c_addr_A0(u32 ee)
{
    SDA_L(); SCL_L();                                 /* 03B14C START       */
    if (i2c_put_A0(0xA0))           goto retry;       /* 03B180             */
    if (i2c_put_A0((u8)(ee >> 8)))  goto retry;       /* 03B188 r0h         */
    if (i2c_put_A0((u8)ee))         goto retry;       /* 03B190 r0l         */
    return;
retry:
    i2c_retry_A0(ee);                                 /* loc_3B0E4          */
}

/* ==========================================================================
 * 03B19A-03B43C  size 674  i2c_put_A0   (sub_3B19A)
 * Confidence: Confirmed.  Clocks r5l out MSB first, releases SDA, clocks
 * the 9th bit and returns r5l = PORT & 1 (0 = ACK, Z set).  Unrolled.
 * ========================================================================== */
u8 i2c_put_A0(u8 b)
{
    u8 ddr = io_ddr_shadow;  /* (r2l of the caller) */
    for (u8 i = 0; i < 8; i++) {
        SCL_L(); if (b & 0x80) SDA_H(); else SDA_L(); b <<= 1; SCL_H();
    }
    SCL_L(); SDA_L(); SDA_IN(); SCL_H();              /* 03B3CA..03B404     */
    u8 ack = P_PORT;                                  /* 03B41E             */
    SCL_L(); SDA_OUT();                               /* 03B422..03B434     */
    return ack & 1;                                   /* 03B438             */
}

/* ==========================================================================
 * 03B43C-03B770  size 820  eeprom_write_pages   (sub_3B43C)
 * Confidence: Confirmed.  Callers: the vfo_blkN_restore family, 398D8,
 * 39A46.  Writes e6 consecutive 64-byte pages from er1 to er0 (STOP after
 * each page, er0 += 0x40, e6--, loop back to the entry).
 * ========================================================================== */
void eeprom_write_pages(u32 ee, const u8 *src, u16 pages)
{
    do {
        u8 ddr = io_ddr_shadow;                       /* 03B440             */
        i2c_addr_A0(ee);                              /* 03B448             */
        for (u16 n = 0x40; n; --n) i2c_put_A0(*src++);/* 03B44C..03B6EE     */
        I2C_STOP();                                   /* 03B6F2..03B740     */
        io_ddr_shadow = ddr;                          /* 03B75A             */
        ee += 0x40;                                   /* 03B762             */
    } while (--pages);                                /* 03B768 e6          */
}

/* 03B770-03BA90 size 800  eeprom_write_page64 (sub_3B770)  Confirmed.
 * Callers: 39BA0, 39CE0, 39E22, 39F5A, sub_3CEDC, sub_735F0.
 * One 64-byte page (r6 = 0x40) at er0 from er1, then STOP.                */
void eeprom_write_page64(u32 ee, const u8 *src)
{
    u8 ddr = io_ddr_shadow;                           /* 03B770             */
    i2c_addr_A0(ee);                                  /* 03B778             */
    for (u16 n = 0x40; n; --n) i2c_put_A0(*src++);    /* 03B77C..03BA1E     */
    I2C_STOP(); io_ddr_shadow = ddr;                  /* 03BA3C..03BA8A     */
}

/* 03BA90-03BDAC size 796  eeprom_write_burst (sub_3BA90)  Confirmed.
 * Callers: 39BA0, 39CE0, 39E22, 39F5A, 3A034.  As page64 but the count is
 * the caller's r6 (0x80 in every caller: one burst inside a 256-byte page,
 * no boundary split).                                                     */
void eeprom_write_burst(u32 ee, const u8 *src, u16 n)
{
    u8 ddr = io_ddr_shadow;
    i2c_addr_A0(ee);                                  /* 03BA94             */
    while (n--) i2c_put_A0(*src++);                   /* 03BA98..03BD3A     */
    I2C_STOP(); io_ddr_shadow = ddr;                  /* 03BD58..03BDA6     */
}

/* ==========================================================================
 * 03BDAC-03BF4C  size 416  eeprom2_read   (sub_3BDAC)
 * Confidence: Confirmed (doc 82 claim 1).  26 callers (0x3C/0x3D, 0x73..).
 * Device A2/A3 twin of eeprom_read: er0 = address in the upper 64 KB
 * (EEPROM 0x1xxxx; the A16 bit is implied by the device code), er1 = dst,
 * r6 = count.  i2c_addr_A2, repeated START, 0xA3, read loop as above.
 * ========================================================================== */
void eeprom2_read(u32 ee, u8 *dst, u16 n)
{
    u8 ddr = io_ddr_shadow;                           /* 03BDAC             */
    i2c_addr_A2(ee);                                  /* 03BDB0 sub_3C378   */
    SDA_H(); SCL_H(); SDA_L(); SCL_L();               /* 03BDB4 rep. START  */
    i2c_put_A2(0xA3);                                 /* 03BE1E             */
    for (;;) {
        SDA_IN();
        u8 b = 0;
        for (u8 i = 8; i; --i) { SCL_H(); b = (b << 1) | (P_PORT & 1); SCL_L(); }
        *dst++ = b;                                   /* 03BE7E             */
        SDA_OUT();
        if (--n == 0) break;                          /* 03BE88             */
        SDA_L(); SCL_H(); SCL_L();                    /* ACK                */
    }
    I2C_STOP(); io_ddr_shadow = ddr;                  /* 03BEDE..03BF46     */
}

/* 03BF4C-03C310 size 964  eeprom2_write (sub_3BF4C)  Confirmed (doc 82).
 * 27 callers.  Device A2 twin of eeprom_write, same 256-byte page split
 * (03C22C..03C29E).                                                       */
void eeprom2_write(u32 ee, const u8 *src, u16 n);   /* = eeprom_write, A2 */

/* 03C378-03C3C6 size 78  i2c_addr_A2 (sub_3C378)  Confirmed (doc 82).
 * START + 0xA2 + r0h + r0l; NACK -> loc_3C310 retry (outside chunk).      */
void i2c_addr_A2(u32 ee);                           /* = i2c_addr_A0, 0xA2 */

/* 03C3C6-03C668 size 674  i2c_put_A2 (sub_3C3C6)  Confirmed (doc 82).
 * Byte transmitter for the A2 device; byte-for-byte the same as
 * i2c_put_A0 (returns PORT & 1).                                          */
u8 i2c_put_A2(u8 b);

/* 03C99C-03CCBC size 800  eeprom2_write_page64 (sub_3C99C)  Confirmed.
 * Caller sub_735F0 (clone/extension receive commit, doc 24).  One 64-byte
 * page (r6 = 0x40) to device A2 at er0, then STOP.  (The multi-page
 * sibling 03C668 is dead code, doc 82 claim 4, outside this chunk.)       */
void eeprom2_write_page64(u32 ee, const u8 *src);
