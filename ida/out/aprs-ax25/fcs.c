/*
 * fcs.c -- hand-reconstructed C for the FT3D MAIN (H8SX, ver 1.02) AX.25
 * FCS check and HDLC transmit encoder, plus an offline self-test.
 *
 * Lane K8. Source: decrypted\FT3D_MAIN_ver102_EXP.bin (base 0, file offset ==
 * address). Static reconstruction only; nothing here talks to a radio.
 *
 *   rx_fcs_check()   == sub_4986A, CRC loop 0x04986A..0x049908
 *   tx_hdlc_encode() == sub_49494, 0x049494..0x0495A0
 *   crc16_x25_ref()  == textbook CRC-16/X.25 (poly 0x1021 reflected = 0x8408,
 *                       init 0xFFFF, refin/refout, xorout 0xFFFF), for checking
 *
 * Register model. Both firmware routines keep the CRC in the 16-bit register
 * r2 but shift it as "rotxr.b r2l ; rotxr.b r2h" (0x04989A/0x04989C,
 * 0x0494C6/0x0494C8), i.e. r2l is the HIGH byte of the logical shift register
 * and r2h the LOW byte. The polynomial is loaded as mov.w #0x0884,e2
 * (0x049892 / 0x0494A8, bytes 79 0a 08 84): with the same byte swap that is the
 * logical constant 0x8408 -- the reflected CCITT polynomial. (The earlier
 * "0x8408 at 0x494AA/0x49894" hit was these two little-endian bytes 08 84.)
 *
 * The routines use the AUGMENTED (message-shifting) form: the first two frame
 * bytes are preloaded and complemented (= init 0xFFFF), each further bit is
 * shifted in at the top, and the polynomial is XORed when a 1 falls out of the
 * bottom. Two zero bytes are appended so the register ends holding the remainder.
 */
#include <stdio.h>
#include <stdint.h>
#include <string.h>
#include <stdlib.h>

/* one "shlr.b rX ; rotxr.b r2l ; rotxr.b r2h ; bcc ; xor.w e2,r2" step */
static void crc_step(uint8_t *r2h, uint8_t *r2l, unsigned inbit)
{
    unsigned c2 = *r2l & 1u;
    *r2l = (uint8_t)((inbit << 7) | (*r2l >> 1));
    unsigned c3 = *r2h & 1u;
    *r2h = (uint8_t)((c2 << 7) | (*r2h >> 1));
    if (c3) { *r2h ^= 0x08; *r2l ^= 0x84; }       /* xor.w e2(=0x0884),r2 */
}

/*
 * sub_4986A, CRC part. RX frame buffer: 0xFFA1AE[0] = opening 0x7E, frame
 * bytes from 0xFFA1B6 (index 8) up to the closing flag; word 0xFFA32E is the
 * index after the closing flag. The routine overwrites the closing flag and
 * the next byte with 0 (0x049874/0x049878), preloads r2 = ~[0xFFA1B6] (word,
 * big-endian, 0x04988A/0x04988E), runs bytes 0xFFA1B8.. through the
 * two zero bytes, then:  cmp.w #0xB8F0,r2 (0x049904) ; bne loc_49C30.
 * 0xB8F0 in the swapped register is logical 0xF0B8, the X.25 good residue.
 * Returns the raw r2 so the caller can compare with 0xB8F0.
 */
uint16_t rx_fcs_check(const uint8_t *frame, size_t n /* incl. 2 FCS bytes */)
{
    uint8_t *buf = calloc(n + 2, 1);
    memcpy(buf, frame, n);                         /* + two appended zeros */
    uint8_t r2h = (uint8_t)~buf[0], r2l = (uint8_t)~buf[1];
    for (size_t i = 2; i < n + 2; i++) {           /* cmp.l er6,er5 ; bcs */
        uint8_t r3l = buf[i];
        for (int k = 0; k < 8; k++) { unsigned c = r3l & 1u; r3l >>= 1; crc_step(&r2h, &r2l, c); }
    }
    free(buf);
    return (uint16_t)((r2h << 8) | r2l);
}

/*
 * sub_49494. Input: length word 0xFFA330, bytes from 0xFFA332. Output: NRZ
 * (not NRZI) bit stream packed MSB-first into bytes at er1 (=0xFF95F8 from the
 * caller sub_49476), which the SCI-B TXI ISR 0x0454E2 later sends. State byte
 * r6h: 1 data, 2 last data byte, 3 FCS lo, 4 FCS hi, 5/6 closing flags.
 * Ones counter e6 (5) implements bit stuffing in states 1..5. There is NO
 * opening flag and NO NRZI step in this routine. Trailing flags: e3 = 8, or
 * 0x20 when 0xFF9DDE != 0 (9600 bps, set by sub_48B9A when 0xFF8AA0 == 2).
 * On exit 0xFFA330 = 0xFFFF. Returns number of output bytes; a trailing
 * partial byte is not stored (matches the firmware's exit at 0x049598).
 */
size_t tx_hdlc_encode(const uint8_t *data, uint16_t L, int is9600, uint8_t *out)
{
    uint8_t *buf = calloc((size_t)L + 8, 1);       /* buf[L], buf[L+1] = 0 (0x0494A0/0x0494A4) */
    memcpy(buf, data, L);
    uint8_t r2h = (uint8_t)~buf[0], r2l = (uint8_t)~buf[1];   /* not.w r2 */
    unsigned e6 = 5, e5, e3 = 1, r6l0, r6h;
    uint8_t r5l = 0, r5h, r3h = buf[2], r3l = buf[0];
    size_t no = 0;
    for (int k = 0; k < 2; k++) { unsigned c = r3h & 1u; r3h >>= 1; crc_step(&r2h, &r2l, c); }
    r6l0 = r3l & 1u; r3l >>= 1;                     /* 0x0494D8 shlr ; bst #0,r6l */
    e5 = 7; r6h = 1;
    for (;;) {                                      /* loc_494E2 */
        r5h = 8;
        for (;;) {                                  /* loc_494E4 */
            enum { L506, L580, L58A } go;
            r5l = (uint8_t)((r5l << 1) | r6l0);     /* bld #0,r6l ; rotxl.b r5l */
            if (r6h == 0 || r6h == 6) go = L506;
            else if (r6l0) {
                if (--e6) go = L506;
                else { r6l0 = 0; e6 = 5; go = L58A; } /* stuffed 0 is the next bit */
            } else { e6 = 5; go = L506; }
            if (go == L506) {
                r6l0 = r3l & 1u; r3l >>= 1;
                if (--e5) {                         /* loc_49570 */
                    if (r6h == 5) { r6h = 6; go = L58A; }
                    else if (r6h == 0 || r6h >= 3) go = L58A;
                    else go = L580;
                } else {
                    int l51a = 0, l52c = 0;
                    e5 = 8;
                    if (r6h == 0 || r6h == 6) l51a = 1;
                    else if (r6h == 1) l52c = 1;
                    else if (r6h == 2) { r3l = (uint8_t)~r2h; r6h = 3; go = L58A; }
                    else if (r6h == 3) { r3l = (uint8_t)~r2l; r6h = 4; e3 = is9600 ? 0x20 : 8; go = L58A; }
                    else { r6h = 5; l51a = 1; }
                    if (l51a) {
                        r3l = 0x7E;
                        if (--e3) go = L58A;
                        else if (r6h == 6) { free(buf); return no; }   /* loc_49598 */
                        else { r6h = 1; l52c = 1; }
                    }
                    if (l52c) {
                        r3h = buf[e3 + 2]; r3l = buf[e3]; e3++;
                        if (e3 >= L) r6h = 2;
                        go = L580;
                    }
                }
            }
            if (go == L580) { unsigned c = r3h & 1u; r3h >>= 1; crc_step(&r2h, &r2l, c); }
            if (--r5h == 0) { out[no++] = r5l; break; }  /* mov.b r5l,@er1 ; adds #1,er1 */
        }
    }
}

uint16_t crc16_x25_ref(const uint8_t *p, size_t n)
{
    uint16_t c = 0xFFFF;
    while (n--) { c ^= *p++; for (int k = 0; k < 8; k++) c = (c & 1) ? (uint16_t)((c >> 1) ^ 0x8408) : (uint16_t)(c >> 1); }
    return (uint16_t)~c;
}

/* NRZ HDLC decoder for the encoder output (MSB-first packing, LSB-first bytes) */
static size_t hdlc_decode(const uint8_t *in, size_t nin, uint8_t *frame, int *nflags)
{
    size_t nf = 0; int ones = 0, nb = 0; uint8_t cur = 0; int run1 = 0;
    *nflags = 0;
    for (size_t i = 0; i < nin * 8; i++) {
        int bit = (in[i / 8] >> (7 - i % 8)) & 1;
        if (bit) { run1++; } else {
            if (run1 == 6) { (*nflags)++; run1 = 0; ones = 0; continue; }   /* flag seen */
            run1 = 0;
        }
        if (*nflags) continue;                      /* stop collecting after first flag */
        if (bit) { ones++; } else { if (ones == 5) { ones = 0; continue; } ones = 0; }
        cur |= (uint8_t)(bit << nb); if (++nb == 8) { frame[nf++] = cur; cur = 0; nb = 0; }
    }
    /* the last 7 bits collected belong to the first closing flag: drop partial */
    return nf;
}

static int put_call(uint8_t *p, const char *call, int ssid, int last)
{
    int i; for (i = 0; i < 6; i++) p[i] = (uint8_t)(((call[i] && i < (int)strlen(call)) ? call[i] : ' ') << 1);
    p[6] = (uint8_t)(0x60 | (ssid << 1) | (last ? 1 : 0));
    return 7;
}

int main(void)
{
    int fails = 0;
    /* 1. catalogue check value: CRC-16/X.25 ("CRC-16/IBM-SDLC") of "123456789" = 0x906E */
    const uint8_t cat[] = "123456789";
    uint16_t ref = crc16_x25_ref(cat, 9);
    printf("T1 reference CRC-16/X.25(\"123456789\") = 0x%04X (catalogue 0x906E) %s\n", ref, ref == 0x906E ? "PASS" : "FAIL");
    fails += ref != 0x906E;

    uint8_t out[4096], dec[2048]; int nflags;
    size_t no = tx_hdlc_encode(cat, 9, 0, out);
    size_t nd = hdlc_decode(out, no, dec, &nflags);
    uint16_t fw = (uint16_t)(dec[9] | (dec[10] << 8));
    printf("T2 firmware TX encoder sub_49494 on \"123456789\": %zu out bytes, decoded %zu bytes, emitted FCS = 0x%04X (lo byte first: %02X %02X) %s\n",
           no, nd, fw, dec[9], dec[10], (nd == 11 && memcmp(dec, cat, 9) == 0 && fw == 0x906E) ? "PASS" : "FAIL");
    fails += !(nd == 11 && memcmp(dec, cat, 9) == 0 && fw == 0x906E);

    uint8_t good[11]; memcpy(good, cat, 9); good[9] = 0x6E; good[10] = 0x90;
    uint16_t r = rx_fcs_check(good, 11);
    printf("T3 firmware RX check sub_4986A on \"123456789\"+6E 90: r2 = 0x%04X (accept iff 0xB8F0) %s\n", r, r == 0xB8F0 ? "PASS" : "FAIL");
    fails += r != 0xB8F0;

    /* 2. an AX.25 APRS UI frame as this radio would build it: APY03D <- N0CALL-7 via WIDE1-1 */
    uint8_t f[400]; int n = 0;
    n += put_call(f + n, "APY03D", 0, 0);
    n += put_call(f + n, "N0CALL", 7, 0);
    n += put_call(f + n, "WIDE1", 1, 1);
    f[n++] = 0x03; f[n++] = 0xF0;
    const char *info = "!4903.50N/07201.75W-PHG5132 test";
    memcpy(f + n, info, strlen(info)); n += (int)strlen(info);
    uint16_t fr = crc16_x25_ref(f, (size_t)n);
    no = tx_hdlc_encode(f, (uint16_t)n, 0, out);
    nd = hdlc_decode(out, no, dec, &nflags);
    uint16_t ef = (uint16_t)(dec[n] | (dec[n + 1] << 8));
    int ok = nd == (size_t)n + 2 && memcmp(dec, f, (size_t)n) == 0 && ef == fr;
    printf("T4 UI frame (%d B): ref FCS 0x%04X, firmware-encoded FCS 0x%04X, payload round-trip %s, closing flags seen %d -> %s\n",
           n, fr, ef, memcmp(dec, f, (size_t)n) == 0 ? "ok" : "BAD", nflags, ok ? "PASS" : "FAIL");
    fails += !ok;
    memcpy(good, f, 0);
    uint8_t g2[400]; memcpy(g2, f, (size_t)n); g2[n] = (uint8_t)fr; g2[n + 1] = (uint8_t)(fr >> 8);
    r = rx_fcs_check(g2, (size_t)n + 2);
    printf("T5 RX check on that frame: r2 = 0x%04X %s\n", r, r == 0xB8F0 ? "PASS" : "FAIL"); fails += r != 0xB8F0;
    g2[5] ^= 0x10; r = rx_fcs_check(g2, (size_t)n + 2);
    printf("T6 RX check after a 1-bit corruption: r2 = 0x%04X (must NOT be 0xB8F0) %s\n", r, r != 0xB8F0 ? "PASS" : "FAIL"); fails += r == 0xB8F0;

    /* 3. random frames 17..325 bytes (RX accepts index 0x14..0x14C), both rates */
    srand(12345); int rf = 0;
    for (int t = 0; t < 2000; t++) {
        int m = 15 + rand() % 309; for (int i = 0; i < m; i++) f[i] = (uint8_t)rand();
        if (t % 7 == 0) memset(f, 0xFF, (size_t)m);          /* stuffing-heavy */
        uint16_t c = crc16_x25_ref(f, (size_t)m);
        no = tx_hdlc_encode(f, (uint16_t)m, t & 1, out);
        nd = hdlc_decode(out, no, dec, &nflags);
        uint16_t e = (uint16_t)(dec[m] | (dec[m + 1] << 8));
        memcpy(g2, f, (size_t)m); g2[m] = (uint8_t)c; g2[m + 1] = (uint8_t)(c >> 8);
        if (!(nd == (size_t)m + 2 && memcmp(dec, f, (size_t)m) == 0 && e == c && rx_fcs_check(g2, (size_t)m + 2) == 0xB8F0)) rf++;
    }
    printf("T7 2000 random frames (15..323 B, half 9600-mode tails, 1/7 all-0xFF): %d mismatches %s\n", rf, rf ? "FAIL" : "PASS");
    fails += rf != 0;
    printf("RESULT: %s\n", fails ? "FAIL" : "ALL PASS");
    return fails;
}
