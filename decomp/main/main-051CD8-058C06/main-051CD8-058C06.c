/* ========================================================================== *
 * PART 1  0x051CD8-0x052B7C : APRS address-field encoder, caller/log lines,
 *         APRS duplicate-packet extent helpers, decimal formatters, list
 *         row-callback runners.
 *
 * The APRS address encoder works on a 10-byte "address slot":
 *     +0..+5  callsign characters, bit 7 cleared, space padded
 *     +6..+8  SSID text as typed ("-NN", "- N") or callsign overflow chars;
 *             prefilled with "    " by the long store at +6 on entry
 *     +9      AX.25-style SSID octet  0x40 | (code << 1), where code =
 *             0x10|ssid for a valid SSID (so 0x60|ssid<<1, the AX.25
 *             reserved bits set), bit 0 = address-extension end, bit 7 =
 *             H ("has been repeated") bit.
 * Register convention (hand-written asm helpers, not the C ABI):
 *     er1 = output cursor, er2 = input cursor, r5h/r5l = the two caller-
 *     chosen field terminators, r6h = ':' in the path parser.  Result r4l:
 *     0 = ok, 1 = end of path (':' seen), 0xFF = syntax error.
 * ========================================================================== */

/* ---- sub_51CD8 (051CD8-051D6A, 146 B)  aprs_addr_encode_call  [Confirmed] --
 * Callers: sub_51AC8, sub_51AFC, sub_51B46 (APRS frame builders).
 * Parse one "CALL[-SSID]" token from er2 into the 10-byte slot at er1.     */
u8 aprs_addr_encode_call(u8 *dst /*er1*/, const u8 **src /*er2*/,
                         u8 term_a /*r5h*/, u8 term_b /*r5l*/)
{
    u8 c, code;
    aprs_addr_status = 0;                               /* 051CD8: FFA50A = 0  */
    *(u32 *)(dst + 6) = 0x20202020;                     /* 051CDE              */
    for (u8 n = 6; n; n--) {                            /* 051CEA: <= 6 chars  */
        c = *(*src)++;
        if (c == term_a || c == term_b || c == '-') {   /* 051CEE              */
            do { *dst++ = ' '; } while (--n);           /* 051D16: pad to 6    */
            goto after_call;
        }
        *dst++ = c & 0x7F;                              /* 051CFA: bclr #7     */
    }
    c = *(*src)++;                                      /* 051D04: 7th char    */
    if (c != term_a && c != term_b && c != '-')
        return aprs_addr_long_call(dst, src, c, term_a, term_b); /* 051D12 */
after_call:
    if (c == term_a || c == term_b) {                   /* 051D20 / 051D50     */
        dst += 3;  code = 0x10;                         /* no SSID -> 0        */
    } else if (c != '-') {
        return 0xFF;                                    /* 051D66              */
    } else if ((*src)[1] == term_a || (*src)[1] == term_b) {
        code = aprs_ssid_1digit(&dst, src);             /* 051D4A: "-N"        */
    } else if ((*src)[2] == term_a || (*src)[2] == term_b) {
        code = aprs_ssid_2digit(&dst, src);             /* 051D44: "-NN"       */
    } else {
        return 0xFF;                                    /* 051D42 -> 051D66    */
    }
    *dst++ = (u8)(code << 1) | 0x40;                    /* 051D5A: SSID octet  */
    return 0;                                           /* 051D62              */
}

/* ---- sub_51D6A (051D6A-051DCA, 96 B)  aprs_addr_long_call  [Confirmed] ----
 * Tail of sub_51CD8 for 7..9-character callsigns (not AX.25-legal).
 * Stores the 7th char plus up to 2 more in slot +6..+8, sets
 * aprs_addr_status = 2 and emits SSID octet 0x44 ((2<<1)|0x40).           */
u8 aprs_addr_long_call(u8 *dst, const u8 **src, u8 c7, u8 ta, u8 tb)
{
    *dst++ = c7 & 0x7F;                                 /* 051D6A              */
    const u8 *s = *src;
    if (s[0] == ta || s[0] == tb)       { dst += 2; }   /* 051DAE: 7 chars     */
    else if (s[1] == ta || s[1] == tb)  { *dst = *(*src)++ & 0x7F; dst += 2; } /* 051DA4 */
    else if (s[2] == ta || s[2] == tb)  {               /* 051D92: 9 chars     */
        *dst++ = *(*src)++ & 0x7F;  *dst++ = *(*src)++ & 0x7F;
    } else return 0xFF;                                 /* 051DC6              */
    aprs_addr_status = 2;                               /* 051DB0: FFA50A = 2  */
    (*src)++;                                           /* 051DB8: eat term    */
    *dst++ = (2 << 1) | 0x40;                           /* 051DBA: 0x44        */
    return 0;
}

/* ---- sub_51DCA (051DCA-051ED4, 266 B)  aprs_path_encode_digis  [Inferred] --
 * Callers: sub_51B46, sub_51C5E.  Encodes the digipeater path list
 * (e5 = element index, e6 = count; the closing "bcs sub_51DCA" re-enters
 * the top for the next element).  Same slot format as above; ':' (r6h) also
 * terminates.  aprs_path_hbit_done (FFA55A) gives the first element that is
 * terminated by term_a the H bit (bit 7 of its SSID octet); aprs_path_count
 * (FFA55B) counts encoded elements.  A leading ':' sets the end bit of the
 * previous SSID octet and returns 1.  Meaning of the H-bit rule Inferred.  */
u8 aprs_path_encode_digis(u8 *dst, const u8 **src, u8 ta, u8 tb,
                          u16 idx /*e5*/, u16 count /*e6*/)
{
    const u8 COLON = ':';                               /* 051DCA: r6h         */
    u8 c, code;
    for (; idx < count; idx++) {                        /* 051EB2: inc/cmp e5  */
        *(u32 *)(dst + 6) = 0x20202020;                 /* 051DCC              */
        c = **src;
        if (c == COLON) {                               /* 051DDA: path end    */
            (*src)++;
            if (aprs_path_count) dst[-1] |= 0x01;       /* 051DEE: EA bit      */
            return 1;
        }
        if (c == ta || c == tb) { (*src)++; continue; } /* 051DE6: empty elem  */
        u8 n;
        for (n = 6; n; n--) {                           /* 051E02              */
            c = *(*src)++;
            if (c == COLON || c == ta || c == tb || c == '-') {
                do { *dst++ = ' '; } while (--n);       /* 051E3C: pad         */
                break;
            }
            *dst++ = c & 0x7F;
        }
        if (n == 0 && !(c == COLON || c == ta || c == tb || c == '-')) {
            c = *(*src)++;                              /* 051E20: 7th char    */
            if (c != COLON && c != ta && c != tb && c != '-') {
                if ((s8)(code = aprs_path_long_call(&dst, src, c)) < 0)  /* 051E32 */
                    return 0xFF;
                goto emit;
            }
        }
        if (c == COLON || c == ta || c == tb) { dst += 3; code = 0x10; }   /* 051E80 */
        else if (c != '-') return 0xFF;                 /* 051E54              */
        else if (is_term3((*src)[1]))  code = aprs_ssid_1digit(&dst, src);  /* 051E7C */
        else if (is_term3((*src)[2]))  code = aprs_ssid_2digit(&dst, src);  /* 051E76 */
        else return 0xFF;
emit:
        code <<= 1;                                     /* 051E8A              */
        if (c == COLON) {                               /* 051E8C: last elem   */
            *dst++ = code | 0x01 | 0x40;                /* 051EBE: EA end bit  */
            aprs_path_count++;
            return 1;
        }
        if (c == ta && aprs_path_hbit_done == 0) {      /* 051E90              */
            aprs_path_hbit_done = 1;  code |= 0x80;     /* 051E9A: H bit       */
        }
        *dst++ = code | 0x40;                           /* 051EA2              */
        aprs_path_count++;                              /* 051EA8              */
    }
    return 0xFF;                                        /* 051EBA: ran out     */
}

/* ---- sub_51ED4 (051ED4-051F08, 52 B)  aprs_ssid_1digit  [Confirmed] --------
 * Writes "- d" into the SSID text, returns code 0x10|d for '1'..'9'.  Any
 * other char sets aprs_addr_status = 1 and returns code 2.  Consumes the
 * terminator into r3l.                                                     */
u8 aprs_ssid_1digit(u8 **dst, const u8 **src)
{
    *(*dst)++ = '-';  *(*dst)++ = ' ';                  /* 051ED4              */
    u8 c = *(*src)++, code;
    if (c >= '1' && c <= '9') { *(*dst)++ = c; code = (c - '0') | 0x10; }
    else { *(*dst)++ = c & 0x7F; aprs_addr_status = 1; code = 2; } /* 051EF6 */
    (*src)++;                                           /* 051F04: r3l = term  */
    return code;
}

/* ---- sub_51F08 (051F08-051F48, 64 B)  aprs_ssid_2digit  [Confirmed] --------
 * "-10".."-15" -> code 0x10|(10..15); anything else -> status 1, code 0x0D.*/
u8 aprs_ssid_2digit(u8 **dst, const u8 **src)
{
    *(*dst)++ = '-';                                    /* 051F08              */
    u8 hi = *(*src)++, lo = *(*src)++, code;
    if (hi == '1' && lo >= '0' && lo <= '5') {          /* 051F12              */
        *(*dst)++ = hi; *(*dst)++ = lo; code = (lo - '0' + 10) | 0x10;
    } else {                                            /* 051F30              */
        *(*dst)++ = hi & 0x7F; *(*dst)++ = lo & 0x7F;
        aprs_addr_status = 1; code = 0x0D;
    }
    (*src)++;                                           /* 051F44              */
    return code;
}

/* ---- sub_51F48 (051F48-051FA6, 94 B)  aprs_path_long_call  [Confirmed] ----
 * Path-element twin of aprs_addr_long_call (also accepts ':' as a
 * terminator).  Returns code 2 (r4l = 0, N clear) or 0xFF (N set).  Unlike
 * the call variant it does NOT set aprs_addr_status.                     */
u8 aprs_path_long_call(u8 **dst, const u8 **src, u8 c7);   /* body as 051D6A */

/* ---- sub_51FA6 (051FA6-052000, 90 B)  aprs_skip_addr_token  [Confirmed] ----
 * Caller: sub_51AFC.  Advances er2 past one "CALL[-SS]" token, stopping at
 * ':' ',' '>' '*' (r3l = the stopping char).  Its rts is nullsub_27.      */
void aprs_skip_addr_token(const u8 **src)
{
    u8 c;
    for (u8 n = 6; n; n--) {                            /* 051FA6              */
        c = *(*src)++;
        if (c == ':' || c == ',' || c == '>' || c == '*') return;
        if (c == '-') goto ssid;
    }
    c = *(*src)++;                                      /* 051FC2: 7th         */
    if (c != '-') return;                               /* delimiter or not '-' */
ssid:                                                   /* 051FD8: peek 2      */
    /* only peeks src[1] and src[2] for a delimiter; nothing is consumed   */
    return;
}

/* ---- nullsub_27 (052000-052002, 2 B)  aprs_skip_addr_token_rts  [Confirmed]
 * The shared 'rts' of sub_51FA6 (fall-through target of 051FFE).  The 10
 * BE32 hits on 0x00052000 elsewhere are table values, not callers.        */

/* ---- sub_52002 (052002-05206E, 108 B)  aprs_open_station_detail  [Inferred]
 * No direct caller found.  Twin of the head of sub_4AAE8 (which clears
 * FFBC0B b4 where this sets it).  With no message context (FFA9FD == 0):
 * cursors A4F2/A4F3/A7A4 = 0xFF, latch FF8AAC b0/b3/b1 into A919/A918/A91A
 * and FF8AAD into A917, clear AA3A b0 and A9FA b3, then jump into
 * sub_4AAE8's type dispatch (loc_4AB3E: table 0x04AB70 by the record type
 * FF9E1F).  Else clear AA3A b1 / A9FA b3 and call sub_4B1B4.             */
void aprs_open_station_detail(void)
{
    FFBC0B |= 0x10;                                     /* 052002              */
    if (FFA9FD == 0) {                                  /* 052008              */
        FFA4F2 = FFA4F3 = FFA7A4 = 0xFF;                /* 05200E              */
        FFA919 = (FF8AAC >> 0) & 1;                     /* 05201E: bld/bst     */
        FFA918 = (FF8AAC >> 3) & 1;                     /* 05202A              */
        FFA91A = (FF8AAC >> 1) & 1;                     /* 052036              */
        FFA917 = FF8AAD;                                /* 052042              */
        FFAA3A &= ~0x01;  FFA9FA &= ~0x08;              /* 05204A              */
        aprs_station_type_dispatch_4AB3E();             /* 052056: jsr loc_4AB3E */
    } else {
        FFAA3A &= ~0x02;  FFA9FA &= ~0x08;              /* 05205C              */
        sub_4B1B4();                                    /* 052068              */
    }
}

/* ---- sub_5206E (05206E-0520F8, 138 B)  log_line_mode_tag  [Inferred] ------
 * Callers: sub_6A7C, sub_6D0A, sub_6EAC, sub_7078.  If FF8DD5 != 0 and
 * FFBBFF != 0, defer to the band-B caller line (sub_52164).  Otherwise
 * build a 12-byte line in the staging buffer FFB05A:
 *   [tag][FFA4E7]['>'][9 bytes from FFA4DE]
 * where the tag letter by FFA9FE is 1 'D', 2 'A', 3 'R', 4 'M', 0/5..9 'O',
 * >= 10 'N' (the 2nd char of the ROM word is overwritten by FFA4E7), and
 * queue it with post_line12 (sub_C7E4).  Meaning of FFA9FE Inferred.     */
void log_line_mode_tag(void)
{
    if (FF8DD5 != 0 && FFBBFF != 0) { caller_line_band_b(); return; } /* 05206E */
    u32 tag;
    u8 m = FFA9FE;                                      /* 052080              */
    if (m >= 10)      tag = 0x4E503E20;                 /* "NP> " 0520C4       */
    else if (m == 1)  tag = 0x44503E20;                 /* "DP> "              */
    else if (m == 2)  tag = 0x414D3E20;                 /* "AM> "              */
    else if (m == 3)  tag = 0x524D3E20;                 /* "RM> "              */
    else if (m == 4)  tag = 0x4D4D3E20;                 /* "MM> "              */
    else              tag = 0x4F4D3E20;                 /* "OM> "              */
    *(u32 *)&stage[0] = tag;                            /* 0520CA: FFB05A      */
    stage[1] = FFA4E7;                                  /* 0520D0              */
    memcpy(&stage[3], (u8 *)0xFFA4DE, 9);               /* 0520DA: eepmov      */
    post_line12();                                      /* 0520F2: sub_C7E4    */
}

/* ---- sub_520F8 (0520F8-052164, 108 B)  caller_line_band_a  [Confirmed] ---
 * doc 56 sec.5: band-A caller registration.  If the radio-ID flag FFAA0E
 * is nonzero with bit 7 clear: "R>" + 10-byte ID FFAA04.  Else tag " >",
 * "X>" or "E>" by FFAA00 (0 / 'X' / other; FFAA02 = FFAA00) + 10-byte
 * callsign FFB1C6.  Queued with post_line12 (12 bytes to *[FFBC2C]+4).   */
void caller_line_band_a(void)
{
    if (FFAA0E != 0 && !(FFAA0E & 0x80)) {              /* 0520F8              */
        *(u16 *)&stage[0] = ('R'<<8)|'>';               /* 052106              */
        memcpy(&stage[2], (u8 *)0xFFAA04, 10);          /* 05210E              */
    } else {
        u16 t = (' '<<8)|'>';                           /* 052128              */
        if (FFAA00) t = (FFAA00 == 'X') ? (('X'<<8)|'>') : (('E'<<8)|'>');
        FFAA02 = FFAA00;                                /* 05213E              */
        *(u16 *)&stage[0] = t;
        memcpy(&stage[2], (u8 *)0xFFB1C6, 10);          /* 052146              */
    }
    post_line12();                                      /* 05215E              */
}

/* ---- sub_52164 (052164-0521D0, 108 B)  caller_line_band_b  [Confirmed] ---
 * Band-B twin: flag FFBC2A, ID FFBC20, tag byte FFBBFE (copied to FFBC00),
 * callsign FFBC0C.                                                       */
void caller_line_band_b(void);   /* identical shape to caller_line_band_a */

/* ---- sub_521D0 (0521D0-0521F6, 38 B)  caller_line_band_b_plain  [Confirmed]
 * Caller: sub_6A7C.  " >" + 10 bytes from FFBC16, then post_line12.       */
void caller_line_band_b_plain(void)
{
    *(u16 *)&stage[0] = (' '<<8)|'>';                   /* 0521D0              */
    memcpy(&stage[2], (u8 *)0xFFBC16, 10);              /* 0521D8              */
    post_line12();                                      /* 0521F0              */
}

/* ---- sub_521F6 (0521F6-05223E, 72 B) + sub_5223E (05223E-052278, 58 B) ----
 * aprs_dup_compare  [Inferred].  IDA split one routine at 05223E (there is
 * no rts between).  Caller: sub_49EBE (APRS receive).  er5 = the stored
 * packet record (length word at +0x1C).  Scan window FFA4BE = FF9FD2 and
 * FFA4C2 = FF9FA8 + len; sub_3D854 copies the stored packet (0xB0-byte
 * record) into FF9FA8; then the per-packet-type extent routine from table
 * 0x04ABE4 indexed by aprs_pkt_type (FF9DFF) returns r3h/r3l = the two
 * payload classes, r6 = length of the new payload, er2 = its start, and
 * leaves the old payload's length/pointer in FFA4C6/FFA4CA.  r4l: 2 = same
 * class, length and bytes (duplicate), 1 = different.
 * NOTE: doc 70 calls 0x04ABE4 a "sensor display" table; its first 29 slots
 * are this file's extent routines (0x052278 x2, 0x05230E x12, 0x0523D0 x8,
 * 0x052470 x4, 0x052504, 0x052582, 0x0525F6; ida/out/hidden ptrindex).    */
u8 aprs_dup_compare(const u8 *rec /*er5*/)
{
    aprs_scan_beg = 0xFF9FD2;                           /* 0521F8              */
    aprs_scan_end = 0xFF9FA8 + *(u16 *)(rec + 0x1C);    /* 052204: FFA4C2      */
    copy_stored_packet_3D854();                         /* 05221A              */
    u8 cls_old, cls_new; u16 len_new; const u8 *pnew;
    aprs_extent_tbl_4ABE4[aprs_pkt_type](&cls_old, &cls_new, &len_new, &pnew); /* 052232 */
    if (cls_old != cls_new)       return 1;             /* 052234              */
    u16 n = aprs_old_len;                               /* 052238: FFA4C6      */
    if (len_new != n)             return 1;             /* 05223C              */
    const u8 *pold = (const u8 *)aprs_old_ptr;          /* 052244: FFA4CA      */
    while (n) { if (*pnew++ != *pold++) return 1; n--; }/* 05224E / 052264     */
    return 2;                                           /* 052270              */
}

/* ---- Per-packet-type extent routines (slots of table 0x04ABE4) -----------
 * Each runs its helper twice: first on the window the caller set up (the
 * stored packet, FFA4BE/FFA4C2), saving class / len / start / end to
 * FFA4C8 (or C9) / FFA4C6 / FFA4CA / FFA4CE; then on the received packet
 * (start FF9F22, end FF9EF8 + FF9E04, sub-type FF9E00) saving to FFA4D4
 * (or D5) / FFA4D2 / FFA4D6 / FFA4DA.  Returns r3h = first class, r3l =
 * second class, r6 = second length, er2 = second start.  Every helper trims
 * one trailing CR (0x0D) from the end and clamps a negative length to 0.  */
typedef struct { u8 cls; u16 len; const u8 *beg, *end; } aprs_extent;

static void extent_pair(void (*h)(aprs_extent *, u8 subtype), u8 sub_old)
{
    aprs_extent e;
    h(&e, sub_old);                                     /* first bsr           */
    aprs_cls_old = e.cls; aprs_old_len = e.len;         /* FFA4C8|C9, FFA4C6   */
    aprs_old_ptr = (u32)e.beg; aprs_old_end = (u32)e.end; /* FFA4CA, FFA4CE   */
    aprs_scan_beg = 0xFF9F22;                           /* new packet body     */
    aprs_scan_end = 0xFF9EF8 + FF9E04;                  /* new packet end      */
    h(&e, FF9E00);                                      /* second bsr          */
    aprs_cls_new = e.cls; FFA4D2 = e.len;               /* FFA4D4|D5           */
    FFA4D6 = (u32)e.beg;   FFA4DA = (u32)e.end;
}

/* sub_52278 (052278-0522CA, 82 B) aprs_extent_pos  [Inferred]
 *   slots 0,1.  Helper sub_522CA; classes in FFA4C8 / FFA4D4.             */
/* sub_522CA (0522CA-05230E, 68 B) aprs_extent_pos_helper  [Confirmed body,
 *   Inferred meaning]: beg = scan_beg + 9 (+4 when sub_4C7DC returns
 *   positive, an optional 4-byte field); end = scan_end (minus trailing CR)
 *   minus a per-class tail length from the ROM byte table 0x3F1E[class].  */
void aprs_extent_pos_helper(aprs_extent *e)
{
    const u8 *b = (const u8 *)aprs_scan_beg + 9;        /* 0522CA              */
    s8 r = sub_4C7DC(&e->cls);                          /* 0522D6: classify    */
    if (r > 0) b += 4;                                  /* 0522DE              */
    const u8 *end = (const u8 *)aprs_scan_end;          /* 0522E0              */
    if (end[-1] == 0x0D) end--;                         /* 0522E6: strip CR    */
    end -= rom_tail_len_3F1E[e->cls];                   /* 0522F6              */
    e->beg = b; e->end = end;
    e->len = (end - b) < 0 ? 0 : (u16)(end - b);        /* 052304              */
}

/* sub_5230E (05230E-052368, 90 B) aprs_extent_t1  [Inferred]
 *   12 slots.  Sub-types: record byte @(0x18,er1) and FF9E00; helper
 *   sub_52368 -> sub_5236C.  Classes FFA4C9 / FFA4D5.                     */
/* sub_52368 (052368-05236C, 4 B)  = jsr sub_4D9E6 (er2 = FFA4BE, branch on
 *   sub-type r5l == 1), then falls into sub_5236C.            [Confirmed] */
/* sub_5236C (05236C-0523D0, 100 B) aprs_extent_t1_tail  [Inferred]
 *   sub_4CF74 classifies; result -> skip count FFA4FE and class r3l:
 *     Z         -> FFA4FE = sub_4E020(), class 0
 *     N         -> FFA4FE = 7,  class 0xFF
 *     r4l == 2  -> FFA4FE = 0,  class 2;   else FFA4FE = 0, class 1
 *   beg = er2 + FFA4FE; end/len as above.                                 */
/* sub_523D0 (0523D0-05242A, 90 B) aprs_extent_t2  [Inferred]  8 slots;
 *   helper sub_5242A (jsr 4D9E6) -> sub_5242E.                            */
/* sub_5242E (05242E-052470, 66 B) aprs_extent_t2_tail  [Inferred]
 *   class = sub_4CBDC() (0/1/2, or 0xFF when N), skip FFA4FE = 3.         */
/* sub_52470 (052470-0524CA, 90 B) aprs_extent_t3  [Inferred]  4 slots;
 *   helper sub_524CA (jsr 4D9E6) -> sub_524CE.                            */
/* sub_524CE (0524CE-052504, 54 B) aprs_extent_t3_tail  [Inferred]
 *   class = sub_4CBDC(); beg = er2 - 4 (FFA4FE not written).             */
/* sub_52504 (052504-05255E, 90 B) aprs_extent_t4  [Inferred]  1 slot;
 *   helper sub_5255E.                                                     */
/* sub_5255E (05255E-052570) + sub_52570 (052570-052582)  [Confirmed]
 *   one helper split by IDA: jsr 4D9E6; beg = er2 - 1; class 0; CR trim.  */
/* sub_52582 (052582-0525D4, 82 B) aprs_extent_t5  [Inferred]  1 slot;
 *   helper sub_525D4 = jsr sub_4EFA8; class 0; CR trim.                   */
/* sub_525F6 (0525F6-052648, 82 B) aprs_extent_raw  [Inferred]  1 slot;
 *   helper sub_52648: whole window, class 0.                              */
void aprs_extent_raw_helper(aprs_extent *e)              /* 052648 */
{
    e->beg = (const u8 *)aprs_scan_beg;
    const u8 *end = (const u8 *)aprs_scan_end;
    if (end[-1] == 0x0D) end--;                         /* 052654              */
    e->cls = 0;
    e->end = end;
    e->len = (end - e->beg) < 0 ? 0 : (u16)(end - e->beg);
}

/* ========================================================================== *
 * Decimal formatter with leading-zero blanking (0x05270A-0x052888).
 * One routine with nine entry points.  FFAA33 b6 = "a nonzero digit has
 * been emitted" (set on entry to force zero padding).  A suppressed digit
 * still advances the cursor (callers pre-fill spaces).  The 10^7..10^5
 * places divide with sub_3F778 (u32 er6 / er4 -> quotient er6, remainder
 * er5), the rest with divxu.
 * Entry (er1 = dst, er3 = value):
 *   05270A 8 digits  sub_5270A        callers sub_4C8E4, sub_4CE8A
 *   052712 7 digits  (inside sub_5270A)
 *   052778 6 digits  (inside)
 *   052780 5 digits  (inside)  callers sub_4C8E4 and the baro handler 4E2D6
 *   052788 4 digits  (inside)  callers sub_4C62E, sub_4CCEE, sub_4EC6C
 * Entry (er6 = dst, r3 = value; 052810 switches the cursor to er6):
 *   052826 3 digits zero-padded   sub_52826   callers 44B6A, 46D90
 *   05282E 3 digits blanked       sub_5282E   8 callers (APRS screens)
 *   052816 2 digits zero-padded   sub_52816   7 callers
 *   05281E 2 digits blanked       sub_5281E   caller 4D050
 * The units digit is always written.  Returns er6 = cursor after the field.
 * ========================================================================== */
static u8 *put_digit(u8 *p, u8 d)
{
    if (d) FFAA33 |= 0x40;
    if (d || (FFAA33 & 0x40)) *p = '0' + d;
    return p + 1;
}
u8 *fmt_dec_u32(u8 *p /*er1/er6*/, u32 v /*er3*/, int digits, int zero_pad)
{
    static const u32 pow10[] = {10000000, 1000000, 100000, 10000, 1000, 100, 10};
    if (zero_pad) FFAA33 |= 0x40; else FFAA33 &= ~0x40;
    for (int i = 8 - digits; i < 7; i++) {              /* 05271A..05286E      */
        p = put_digit(p, (u8)(v / pow10[i]));
        v %= pow10[i];
    }
    *p++ = '0' + (u8)v;                                 /* 052880: units       */
    return p;
}
u8 *fmt_dec8_blank(u8 *dst, u32 v)  { return fmt_dec_u32(dst, v, 8, 0); } /* 05270A */
u8 *fmt_dec2_zero (u8 *dst, u8  v)  { return fmt_dec_u32(dst, v, 2, 1); } /* 052816 */
u8 *fmt_dec2_blank(u8 *dst, u8  v)  { return fmt_dec_u32(dst, v, 2, 0); } /* 05281E */
u8 *fmt_dec3_zero (u8 *dst, u16 v)  { return fmt_dec_u32(dst, v, 3, 1); } /* 052826 */
u8 *fmt_dec3_blank(u8 *dst, u16 v)  { return fmt_dec_u32(dst, v, 3, 0); } /* 05282E */

/* ---- sub_52888 (052888-0528AE, 38 B)  blank_lead0_2ch  [Confirmed] --------
 * Field at stage+er3 (@(-0x4FA6,er3) = FFB05A+er3): "00" -> "  ",
 * "0x" -> " x".  9 callers (APRS detail rows).                           */
void blank_lead0_2ch(u16 off /*er3*/)
{
    u8 *f = &stage[off];
    if (f[0] == '0' && f[1] == '0') { f[0] = f[1] = ' '; return; }
    if (f[0] == '0') f[0] = ' ';
}

/* ---- sub_528AE (0528AE-0528DA, 44 B)  blank_lead0_2ch_b  [Confirmed] ------
 * Same, and " 0" is also blanked fully.  6 callers.                      */
void blank_lead0_2ch_b(u16 off)
{
    u8 *f = &stage[off];
    if ((f[0] == '0' || f[0] == ' ') && f[1] == '0') { f[0] = f[1] = ' '; return; }
    if (f[0] == '0') f[0] = ' ';
}

/* ========================================================================== *
 * Row-callback runners (0x0528DA-0x0529AC).  er4 = table of 4-byte function
 * pointers.  Starting at table[first], call each nonzero entry with row_ctx
 * (FFB050) = er3 (the row word), for rows er3..3.  FFB08D (row cursor) is
 * cleared by every entry.
 * ========================================================================== */
static void run_rows(void (*const *tbl)(void), u8 first, u32 row, u32 last)
{
    tbl += first;
    for (; (u16)row < last; row++) {                    /* 052958: cmp #4      */
        void (*fn)(void) = *tbl++;
        if (fn) { row_ctx = row; fn(); }                /* 05294C: FFB050      */
    }
}
/* sub_528DA (0528DA-0528EC, 18 B) rows4_from_B286  [Confirmed]  first =
 *   FFB286, joins the loop at 052938.  No direct caller found; the entries
 *   0528F2/0528FC that follow it are dead (doc 115).                      */
void rows4_from_B286(void (*const *t)(void)) { FFB08D = 0; run_rows(t, FFB286, 0, 4); }
/* sub_5290E (05290E-052962, 84 B) rows4  [Confirmed]  first = 0.  Caller
 *   sub_52AE8.  Holds the dead page-scroll entry 05291E (er3 = 0x70000,
 *   first = FFA4F5 clamped to <= FFA4F7; 0 refs, doc 115).                */
void rows4(void (*const *t)(void)) { FFB08D = 0; run_rows(t, 0, 0, 4); }
/* sub_52962 (052962-05298C, 42 B) rows1to3_from_B3F1  [Confirmed]  er3 = 1,
 *   first = FFB3F1.  Its second entry 052974 (first = 0) is what sub_52A3A
 *   calls; the loop body is the split fragment sub_52992.                 */
void rows1to3_from_B3F1(void (*const *t)(void)) { FFB08D = 0; run_rows(t, FFB3F1, 1, 4); }
void rows1to3(void (*const *t)(void))           { FFB08D = 0; run_rows(t, 0, 1, 4); } /* 052974 */
/* sub_52992 (052992-0529AC, 26 B)  [Confirmed]  IDA-split loop body of
 *   sub_52962 (stm, FFB050 = er3, jsr @er5, ldm, inc, cmp #4).  The fetch
 *   "mov.l @er2+,er5 / beq" at 05298C-052991 sits in the gap before it.  */

/* ---- sub_52A3A (052A3A-052A5E, 36 B)  list3_draw  [Inferred] --------------
 * Caller: sub_66C56.  list_sel FFB2A8 = FFB3F1; rows 1..3 from table
 * 0x052A5E (absolute rows) if the selection < 3, else 0x052A6A (rows
 * relative to the selection).                                           */
void list3_draw(void)
{
    list_sel = FFB3F1;                                  /* 052A3E: FFB2A8      */
    rows1to3(list_sel < 3 ? tbl_52A5E : tbl_52A6A);     /* 052A42              */
}

/* ---- row thunks: tail-jump into the owning screen's row painter *FFB288 --
 * (row_painter; e.g. 0x0060BE stores 0x617C there, doc 41), r1 = row.
 * sub_52A76/52A82/52A8E/52A9A (12 B each): r1 = 0/1/2/3.        [Confirmed]
 * sub_52AA6/52ABA/52ACE (20 B):  r1 = FFB2A8 - 3 + 1/2/3.        [Confirmed]
 * sub_52B2C/52B40/52B54/52B68 (20 B): r1 = FFB2A8 - 4 + 1..4.     [Confirmed] */
#define ROW_ABS(n)     (row_painter((u16)(n)))
#define ROW_REL3(k)    (row_painter((u16)(list_sel - 3 + (k))))
#define ROW_REL4(k)    (row_painter((u16)(list_sel - 4 + (k))))
void row_abs0(void)   { ROW_ABS(0); }   /* 052A76 */
void row_abs1(void)   { ROW_ABS(1); }   /* 052A82 */
void row_abs2(void)   { ROW_ABS(2); }   /* 052A8E */
void row_abs3(void)   { ROW_ABS(3); }   /* 052A9A */
void row_rel3_1(void) { ROW_REL3(1); }  /* 052AA6 */
void row_rel3_2(void) { ROW_REL3(2); }  /* 052ABA */
void row_rel3_3(void) { ROW_REL3(3); }  /* 052ACE */
void row_rel4_1(void) { ROW_REL4(1); }  /* 052B2C */
void row_rel4_2(void) { ROW_REL4(2); }  /* 052B40 */
void row_rel4_3(void) { ROW_REL4(3); }  /* 052B54 */
void row_rel4_4(void) { ROW_REL4(4); }  /* 052B68 */

/* ---- sub_52AE8 (052AE8-052B0C, 36 B)  list4_draw  [Inferred] --------------
 * Caller: sub_6267E.  4-row version: tables 0x052B0C (absolute rows 0..3)
 * or 0x052B1C (relative rows) when FFB3F1 >= 4.                         */
void list4_draw(void)
{
    list_sel = FFB3F1;                                  /* 052AEC              */
    rows4(list_sel < 4 ? tbl_52B0C : tbl_52B1C);        /* 052AF0              */
}
/* ========================================================================== *
 * PART 2  0x052B7C-0x054AC0 : APRS list/detail screen builders, own-
 *         position and distance/bearing, the APRS automatic-TX tasks.
 * MAIN renders nothing itself: it fills the MAIN->SUB IPC frame at FF3D72
 * (doc 50: total/opcode/len at FF3D72/74/76, payload from frame+0x20 =
 * FF3D92) one 19..22-byte text line at a time through the staging buffer
 * FFB05A (`stage`) and the frame cursor FFBC2C (`frame_cur`), then calls a
 * per-opcode frame sender (doc 37): sub_A6FE = F500, sub_A776 = F502,
 * sub_A87A = F511, sub_AB7E = F518.  FFBBE8 = current line length
 * (`line_len`), FFBBE9 = screen sub-state.  ROM 0x02C3CF = blank-line
 * template, ROM 0x050146 = 9-byte "no data" text.
 * Station/message records are 32 bytes:
 *     FEE000 + 32*n   received-station list (display order map FFA6EC[])
 *     FEE780 + 32*n   message list, 60 slots (display order map FFA764[])
 * A record is copied to the work copy FF9E08..FF9E27 before formatting:
 *     +0..+2 date (+1 month, +2 day; BCD)  +3/+4 hour/min (BCD)
 *     +8..+0x10 callsign (9 chars)         +0x17 (FF9E1F) station-type index
 *     +0x1A (FF9E22) flags: b0 outgoing (needs ack), b2 ack owed, b5
 *           EMERGENCY, b6 auto-reply wanted, b7 acked   +0x1B (FF9E23) retries
 *     +0x19 TX request argument, +0x1C text offset (into FFA62C)
 * ========================================================================== */

/* ---- sub_52B7C (052B7C-052C72, 246 B)  aprs_station_list_page  [Inferred] -
 * Caller: sub_4AAE8 (APRS station list).  Builds five 20-char lines
 * (er3 = 1..5) of the station list from list position FF8EAB and sends IPC
 * opcode F502.                                                           */
void aprs_station_list_page(void)
{
    frame_cur = 0xFF3D97;                               /* 052B7C: FFBC2C      */
    line_len  = 0x14;                                   /* 052B88: 20 chars    */
    FF3D94 = beacon_mode;                               /* 052B8E: FFA90C      */
    FF3D95 = 0;
    const u8 *ord = &rom_50106[FF8EAB];                 /* 052BA4: page table  */
    FF3D96 = *ord + 1;                                  /* 052BB4              */
    for (u16 row = 1; row < 6; row++) {                 /* 052BC0..052C4E      */
        u8 pos  = *ord++;
        u8 slot = station_map[pos];                     /* 052BD0: FFA6EC[pos] */
        memcpy(stage, rom_2C3CF, line_len);             /* 052BDA: blank line  */
        const u8 *rec = (const u8 *)0xFEE000 + slot * 32;
        if (!(slot & 0x80) && rec[0] != 0xFF) {         /* 052BF4 / 052C08     */
            memcpy((u8 *)0xFF9E08, rec, 32);            /* 052C0C              */
            aprs_station_line();                        /* 052C1E: sub_52C8C   */
        } else {
            aprs_no_data_line();                        /* 052C22: sub_52C72   */
        }
        memcpy((u8 *)frame_cur, stage, line_len);       /* 052C24              */
        frame_cur += line_len;                          /* 052C3E              */
    }
    *(u8 *)frame_cur++ = FFBBEC & 1;                    /* 052C52: trailer bit */
    ipc_send_F502();                                    /* 052C6C: sub_A776    */
}

/* ---- sub_52C72 (052C72-052C8C, 26 B)  aprs_no_data_line  [Confirmed] ------*/
void aprs_no_data_line(void) { memcpy(&stage[4], rom_50146, 9); }

/* ---- sub_52C8C (052C8C-052DB0, 292 B)  aprs_station_line  [Confirmed] -----
 * Formats one station-list line from the work record FF9E08:
 *   stage[0..3] = type char ROM 0x003EA2[FF9E1F] (0x1D when 0xFF) + 3
 *                 spaces, or "Emg " (ROM 0x003EC0) when FF9E22 b5;
 *   the 9-char callsign FF9E10 + ' ' (at stage+4: the "cmp.b #0x13" tests
 *   the constant 0x14, so the stage+2 branch is dead here);
 *   "HH:MM" when the record date (FF9E08 bytes 0..2) equals today FFA9C4,
 *   else "MM/DD".
 * CONTRADICTS doc 12 sec.8.4, which reads FF9E1F as the stored destination
 * index; here FF9E08..FF9E27 is a copy of an APRS list record (NOTES).    */
void aprs_station_line(void)
{
    u32 head;
    if (FF9E22 & 0x20) head = (*(u32 *)rom_3EC0 & 0xFFFFFF00) | ' ';  /* "Emg " */
    else {
        u8 t = (FF9E1F == 0xFF) ? 0x1D : FF9E1F;        /* 052C94              */
        head = ((u32)rom_3EA2[t] << 24) | 0x202020;     /* 052CA4              */
    }
    *(u32 *)&stage[0] = head;                           /* 052CBA              */
    u8 *p = &stage[4];                                  /* 052CC0 (const test) */
    memcpy(p, (u8 *)0xFF9E10, 9); p += 9; *p++ = ' ';   /* 052CF0..052D16      */
    const u8 *r = (const u8 *)0xFF9E08;
    if ((*(u32 *)r & ~0xFFu) == (today_date & ~0xFFu)) {/* 052D18: same day    */
        u8 h = r[3] & 0x3F, m = r[4] & 0x7F;            /* 052D32              */
        *p++ = '0' + (h >> 4); *p++ = '0' + (h & 15); *p++ = ':';
        *p++ = '0' + (m >> 4); *p++ = '0' + (m & 15);
    } else {
        u8 mo = r[1] & 0x1F, d = r[2] & 0x3F;           /* 052D74              */
        *p++ = '0' + (mo >> 4); *p++ = '0' + (mo & 15); *p++ = '/';
        *p++ = '0' + (d >> 4);  *p++ = '0' + (d & 15);
    }
}

/* ---- sub_52DB0 (052DB0-052DEE, 62 B) + sub_52DEE (052DEE-052E4E, 96 B) ----
 * aprs_detail_page  [Inferred].  One routine split by IDA (no rts at the
 * boundary).  Callers: 13 APRS detail screens (sub_4B88C, sub_4CB42 ...).
 * er4 = the screen's line table: entry 0 = title builder, entries 1.. =
 * row builders.  Copies the frame header template (count word at ROM
 * 0x02C3C4, bytes from 0x02C3C6) to FF3DA4, line_len = 22, runs the title
 * builder with FFBBE9 = 5, patches the station type char (sub_52E4E),
 * moves 16 bytes FFB05B -> FF3D94, then (unless FFA9FA b3) draws seven
 * rows with aprs_rows7 (sub_530CC) from FF3DAD and leaves frame_cur =
 * FF3E47.  r4l = 0, or 1 after sub_514C6 when FFA9FA b3 (compose mode).  */
u8 aprs_detail_page(void (*const *tbl)(void) /*er4*/)
{
    u16 n = *(const u16 *)rom_2C3C4;                    /* 052DB2              */
    memcpy((u8 *)0xFF3DA4, rom_2C3C4 + 2, n);           /* 052DC0              */
    line_len = 0x16;                                    /* 052DC8              */
    memcpy(stage, rom_2C3CF, line_len);                 /* 052DCE              */
    FFBBE9 = 5;                                         /* 052DF2              */
    tbl[0]();                                           /* 052DF8: jsr @er6    */
    aprs_type_tag();                                    /* 052DFA: sub_52E4E   */
    memcpy((u8 *)0xFF3D94, &stage[1], 16);              /* 052DFC              */
    frame_cur = 0xFF3DAD;  FFBBE9 = 8;                  /* 052E14              */
    if (!(FFA9FA & 0x08)) {                             /* 052E2A              */
        aprs_rows7(tbl + 1);                            /* 052E32: sub_530CC   */
        frame_cur = 0xFF3E47;                           /* 052E36              */
        return 0;
    }
    aprs_compose_screen_514C6();                        /* 052E46              */
    return 1;
}

/* ---- sub_52E4E (052E4E-052E8A, 60 B)  aprs_type_tag  [Confirmed] -----------
 * stage[2] = ROM 0x003EA2[FF9E1F or 0x1D], or stage[1..3] = "Emg" when
 * FF9E22 b5.                                                              */
void aprs_type_tag(void)
{
    if (FF9E22 & 0x20) { stage[1] = rom_3EC0[0]; stage[2] = rom_3EC0[1]; stage[3] = rom_3EC0[2]; }
    else stage[2] = rom_3EA2[FF9E1F == 0xFF ? 0x1D : FF9E1F];
}

/* ---- sub_52E8A (052E8A-052F88, 254 B)  aprs_message_list_page  [Inferred] -
 * Caller: sub_4B192.  Message-list twin of aprs_station_list_page: list
 * position FF8EAC, order map FFA764[], records at FEE780, 19-char lines,
 * stage[0..1] = 0, then aprs_message_line (sub_52FA2) or "no data"
 * (sub_52F88, stage+2); five rows; IPC opcode F500 (sub_A6FE).           */
void aprs_message_list_page(void);   /* same shape as 052B7C            */

/* ---- sub_52F88 (052F88-052FA2, 26 B)  aprs_no_data_line_msg  [Confirmed] -*/
void aprs_no_data_line_msg(void) { memcpy(&stage[2], rom_50146, 9); }

/* ---- sub_52FA2 (052FA2-0530CA, 296 B)  aprs_message_line  [Confirmed] -----
 * stage[0] = status glyph code, stage[1] = direction:
 *   outgoing (FF9E22 b0): dir 1; code 3 when retries FF9E23 == 0, 4 when
 *       retries is negative (gave up), else 10 - (retries - 1);
 *   incoming: dir 2; code 2, or 1 when FF9E22 b7 (acked).
 * Then callsign (stage+2) + time or date exactly as aprs_station_line.   */
void aprs_message_line(void)
{
    u8 dir, code;
    if (FF9E22 & 0x01) {                                /* 052FA2              */
        dir = 1; code = 3;
        if (FF9E23 != 0) { code = 4; if (!(FF9E23 & 0x80)) code = 10 - (FF9E23 - 1); }
    } else { dir = 2; code = (FF9E22 & 0x80) ? 1 : 2; } /* 052FC4              */
    stage[0] = code; stage[1] = dir;                    /* 052FD2              */
    /* 052FDA..0530C8: callsign at stage+2 and HH:MM / MM/DD as above       */
}

/* ---- nullsub_50 (0530CA-0530CC, 2 B)  aprs_row_none  [Confirmed] ----------
 * Empty row builder; 15 slots of the APRS detail tables (0x04AD30 ..
 * 0x04B150) point here.                                                  */
void aprs_row_none(void) { }

/* ---- sub_530CC (0530CC-053110) + sub_53110 (053110-05314A)  aprs_rows7 -----
 * [Confirmed]  One routine split by IDA.  er3 = 0x70000 (row tag 7 in the
 * high word); first item FFA4F5 reset to 0 when > FFA4F7.  For rows 0..6:
 * blank the stage line, call the row builder (if nonzero) with row_ctx =
 * er3, append the line to the frame.  An empty slot appends nothing.     */
void aprs_rows7(void (*const *tbl)(void))
{
    u32 row = 0x70000;                                  /* 0530CC              */
    if (FFA4F5 >= (u8)(FFA4F7 + 1)) FFA4F5 = 0;         /* 0530D2: clamp       */
    tbl += FFA4F5;
    for (; (u16)row < 7; row++) {                       /* 053142: cmp #7      */
        memcpy(stage, rom_2C3CF, line_len);             /* 0530F0              */
        void (*fn)(void) = *tbl++;
        if (!fn) continue;                              /* 05310E              */
        row_ctx = row; fn();                            /* 053114              */
        memcpy((u8 *)frame_cur, stage, line_len);       /* 05311C              */
        frame_cur += line_len;
    }
}

/* ---- sub_5314A (05314A-0531C8, 126 B)  aprs_rows5_scroll  [Confirmed] -----
 * Callers: sub_514C6, sub_5150A, sub_516FE (message compose screens).
 * As aprs_rows7 but five rows.                                           */
void aprs_rows5_scroll(void (*const *tbl)(void));

/* ---- sub_531C8 (0531C8-05327C, 180 B)  aprs_scroll_marks_F511  [Inferred] -
 * 12 callers (APRS detail screens).  FFA4F8 = last item index (negative =
 * no list).  With a list, compare the first item FFA4F5 with it (mode
 * FFA98B == 2 uses '<', else '<='; FFA98B also the window size) and call
 * sub_4F30A (top) or sub_4F46A (scrolled) to set the scroll markers; past
 * the end, or with no list, clear the frame bytes FF3DA5..FF3DAC.  Then
 * FF3DA6 bits 2/3 = (FFAA3A b0 ? 8 : 4) and send IPC F511 (sub_A87A).   */
void aprs_scroll_marks_F511(void)
{
    s8 n = (s8)FFA4F8;                                  /* 0531C8              */
    if (n >= 0) {
        u8 lim = (n == 1) ? 1 : (u8)(n + 1);            /* 0531CE              */
        u8 first = FFA4F5;
        int at_top = (FFA98B == 2) ? (first < lim) : (first <= lim);
        if (at_top) {
            sub_4F30A();                                /* 053200              */
            if ((s8)FFA4F8 < 0) goto clr_tail;          /* 053208              */
            goto send;
        }
        if (first >= (u8)(lim + FFA98B)) goto clr_all;  /* 0531F8              */
        sub_4F46A();                                    /* 0531FA              */
        goto send;
    }
clr_all:
    for (u8 *p = (u8 *)0xFF3DA5; p <= (u8 *)0xFF3DAA; p++) *p = 0; /* 05320C */
clr_tail:
    FF3DAB = 0; FF3DAC = 0;                             /* 053248              */
send:
    FF3DA6 = (FF3DA6 & 0xF3) | ((FFAA3A & 0x01) ? 0x08 : 0x04); /* 05325C    */
    ipc_send_F511();                                    /* 053276: sub_A87A    */
}

/* ---- sub_5327C (05327C-0532EE, 114 B)  aprs_scroll_clear_F518  [Confirmed]
 * Callers: sub_5150A, sub_516FE.  Clear FF3DA5..FF3DAA; FF3DA6 bits 2/3 by
 * FFAA3A b1; send F518 (sub_AB7E).  0532BA..0532CD (clear AB/AC) is dead
 * (doc 115).                                                             */
void aprs_scroll_clear_F518(void)
{
    for (u8 *p = (u8 *)0xFF3DA5; p <= (u8 *)0xFF3DAA; p++) *p = 0;
    FF3DA6 = (FF3DA6 & 0xF3) | ((FFAA3A & 0x02) ? 0x08 : 0x04); /* 0532CE    */
    ipc_send_F518();                                    /* 0532E8: sub_AB7E    */
}

/* ---- framed row runners (blank / build / append per row) -----------------
 * sub_532EE (0532EE-053300, 18 B)  rows4_framed_from_A4F5  [Confirmed]
 * sub_53300 (053300-053372, 114 B) rows4_framed  [Confirmed]  caller
 *   sub_536EA.
 * sub_53372 (053372-053384, 18 B)  rows5_framed_from_A4F5  [Confirmed]
 * sub_53384 (053384-0533F6, 114 B) rows5_framed  [Confirmed]  caller
 *   sub_5363A (doc 41: jsr @er5 at 0x0533C6).
 * sub_53496 (053496-0534C0, 42 B)  rows_framed_from1  [Skeleton]  er3 = 1,
 *   first = FFB3F1 (0 at the 0534A8 entry).  Its loop body 0534C0-053519
 *   lies outside this chunk; doc 117 puts it in the dead tier (only the
 *   dead routine 0x05351A calls 0x0534A8).                                */
static void rows_framed(void (*const *t)(void), u8 first, u32 row, u16 last)
{
    FFB08D = 0;  t += first;
    for (; (u16)row < last; row++) {
        memcpy(stage, rom_2C3CF, line_len);
        void (*fn)(void) = *t++;
        if (!fn) continue;
        row_ctx = row; fn();
        memcpy((u8 *)frame_cur, stage, line_len); frame_cur += line_len;
    }
}
void rows4_framed_from_A4F5(void (*const *t)(void)) { rows_framed(t, FFA4F5, 0, 4); } /* 0532EE */
void rows4_framed(void (*const *t)(void))           { rows_framed(t, 0, 0, 4); }      /* 053300 */
void rows5_framed_from_A4F5(void (*const *t)(void)) { rows_framed(t, FFA4F5, 0, 5); } /* 053372 */
void rows5_framed(void (*const *t)(void))           { rows_framed(t, 0, 0, 5); }      /* 053384 */
/* TODO(waveC): rows_framed_from1 limit lives in the 0534C0 tail (not in chunk) */

/* ---- row thunks, second family (tail-jump into *FFB288) -------------------
 * sub_53574..sub_535B0 (12 B each): r1 = 0..5.                 [Confirmed]
 * sub_535BC..sub_53620 (20 B each): r1 = FFB2A8 - 6 + 1..6.     [Confirmed]
 * sub_53686/536AE/536C2/536D6 (20 B): r1 = FFB2A8 - 5 + 1/3/4/5 (the +2
 *   thunk 0x05369A is in the gap before 0x0536AE, not in this chunk).
 * sub_53734..sub_53770 (20 B): r1 = FFB2A8 - 4 + 1..4.          [Confirmed]
 * Tables: 0x053544/0x053560 (from the dead 0x05351A), 0x05365E/0x053672
 * (sub_5363A), 0x053714/0x053724 (sub_536EA).                            */
#define ROW_REL6(k) (row_painter((u16)(list_sel - 6 + (k))))
#define ROW_REL5(k) (row_painter((u16)(list_sel - 5 + (k))))
void row_abs4(void) { ROW_ABS(4); }    /* 0535A4 */
void row_abs5(void) { ROW_ABS(5); }    /* 0535B0 */

/* ---- sub_53634 (053634-05363A, 6 B) / sub_5363A (05363A-05365E, 36 B) -----
 * list5_draw  [Confirmed].  sub_53634 uses the selection FFB3F5 (10 callers
 * 0x004EE4..0x06EDB4); sub_5363A uses FFB3F1 (9 callers incl. sub_62692).
 * list_sel = sel; rows5_framed(sel < 5 ? 0x05365E : 0x053672).          */
void list5_draw_sel(u8 sel)
{
    list_sel = sel;                                     /* 05363E: FFB2A8      */
    rows5_framed(sel < 5 ? tbl_5365E : tbl_53672);      /* 053642              */
}
void list5_draw_B3F5(void) { list5_draw_sel(FFB3F5); }  /* 053634 */
void list5_draw(void)      { list5_draw_sel(FFB3F1); }  /* 05363A */

/* ---- sub_536EA (0536EA-053714, 42 B)  list4f_draw  [Confirmed] -------------
 * Entry 0536EA uses FFB3F5 (callers sub_5C36, sub_D910, sub_D9D2); entry
 * 0536F0 uses FFB3F1 (callers 0x06DC2E..0x06E13C).  rows4_framed(sel < 4 ?
 * 0x053714 : 0x053724).                                                 */
void list4f_draw_sel(u8 sel)
{
    list_sel = sel;
    rows4_framed(sel < 4 ? tbl_53714 : tbl_53724);      /* 0536F8              */
}

/* ========================================================================== *
 * Own position and the distance & bearing calculator.
 * Position record (10 bytes) at FFA7BE (own), FFA7C8 (other), FFA7D8
 * (last received position):
 *   [0] lat flags: b4 = South          [1] lat deg   [2] lat min
 *   [3..4] lat fraction in 1/1000 min (rounded to 1/100, then x10)
 *   [5] lon flags: b4 = West, b0 = deg >= 100    [6] lon deg mod 100
 *   [7] lon min   [8..9] lon fraction
 *   [0] = 0xFF means "no position".
 * Text form (FF9D60 GPS fix, FF9D7C stored position, FF9DC2 received):
 *   fixed offsets "N?DDMMfff?EDDDMMfff" (the '?' bytes are skipped); a non-
 *   digit makes that field 0.
 * ========================================================================== */

/* ---- sub_53784 (053784-053822, 158 B)  own_position_load  [Confirmed] -----
 * Callers: sub_539C6, sub_54484, sub_544F2.  By the MY POSITION source
 * FF8AB8 (doc 45: GPS / Manual / P1..P10):
 *   0     -> GPS fix text (falls into sub_53822);
 *   1..2  -> manual bytes FF8AB0..FF8AB7, FF9D43 = 1;
 *   >= 3  -> stored position FF9D7C when FF9D74 != 0xFFFF, FF9D43 = 2.
 * Returns N set (r4l = 0xFF) when there is no position.                  */
s8 own_position_load(void)
{
    u8 src = FF8AB8;                                    /* 053784              */
    if (src == 0) return own_position_from_gps();       /* 05378A: sub_53822   */
    if (src < 3) {                                      /* 05378E              */
        FF9D43 = 1;                                     /* 053792              */
        own_pos[0] = (FF8AB0 & 1) << 4;                 /* 053798: S flag      */
        own_pos[1] = FF8AB1;  own_pos[2] = FF8AB2;      /* 0537A6              */
        *(u16 *)&own_pos[3] = FF8AB3 * 10;              /* 0537B6              */
        own_pos[5] = (FF8AB4 & 1) << 4;                 /* 0537C6: W flag      */
        u8 lon = FF8AB5;
        if (lon >= 100) { own_pos[5] |= 1; lon -= 100; }/* 0537D4              */
        own_pos[6] = lon;  own_pos[7] = FF8AB6;         /* 0537E8              */
        *(u16 *)&own_pos[8] = FF8AB7 * 10;              /* 0537F4              */
        return 0;
    }
    FF9D43 = 2;                                         /* 053808              */
    if (FF9D74 == 0xFFFF) { memset(own_pos, 0xFF, 10); return -1; } /* 053986 */
    return parse_position_text((const u8 *)0xFF9D7C);   /* 05381A -> 05383A    */
}

/* ---- sub_53822 (053822-0539A0, 382 B)  own_position_from_gps  [Confirmed]
 * Callers: sub_53784 (fall-through), sub_54484.  FF9D43 = 0; FF9D60 ==
 * 0xFFFF means no fix (record = 0xFF..., N).  Else parse FF9D60.         */
s8 own_position_from_gps(void)
{
    FF9D43 = 0;                                         /* 053822              */
    if (*(u16 *)0xFF9D60 == 0xFFFF) { memset(own_pos, 0xFF, 10); return -1; }
    return parse_position_text((const u8 *)0xFF9D60);  /* 053834              */
}
/* shared body from 05383A */
s8 parse_position_text(const u8 *s)
{
    own_pos[0] = (*s++ == 'N') ? 0 : 0x10;  s++;        /* 05383A              */
    own_pos[1] = dec2(&s);  own_pos[2] = dec2(&s);      /* 05384A / 053872     */
    u8 f = dec2(&s); if (*s++ >= '5') f++;              /* 053898: round       */
    *(u16 *)&own_pos[3] = f * 10;                       /* 0538C2              */
    s++;
    own_pos[5] = (*s++ == 'E') ? 0 : 0x10;              /* 0538D0              */
    u16 d = dec3(&s);                                   /* 0538DE              */
    if (d >= 100) { own_pos[5] |= 1; d -= 100; }        /* 053916              */
    own_pos[6] = (u8)d;  own_pos[7] = dec2(&s);         /* 053924 / 053928     */
    f = dec2(&s); if (*s++ >= '5') f++;                 /* 05394E              */
    *(u16 *)&own_pos[8] = f * 10;                       /* 053978              */
    return 0;
}

/* ---- sub_539A0 (0539A0-0539C6, 38 B)  pos_convert_if_valid  [Inferred] -----
 * Callers: sub_649CC, sub_64DB2, sub_68C30, sub_68D44.  If *(u32*)er2 !=
 * 0xFFFFFFFF convert it with sub_49822 into FFA882 and set FFA872 = 1,
 * else FFA872 = 0.                                                       */
void pos_convert_if_valid(const u32 *p)
{
    if (*p != 0xFFFFFFFF) { sub_49822(p, (u8 *)0xFFA882); FFA872 = 1; }
    else FFA872 = 0;
}

/* ---- sub_539C6 (0539C6-0539DE, 24 B)  aprs_dist_bearing_entry  [Confirmed]
 * Callers: 11 APRS detail screens (sub_4B88C ...).  Return if the other-
 * station record (A7C8 or A7CD) is negative; load own position; when that
 * fails branch to 0x053FAE (the byte after sub_539DE, inside the ROM table
 * area; not decoded in the listings); else fall into sub_539DE.          */
void aprs_dist_bearing_entry(void)
{
    if ((s8)other_pos[0] < 0 || (s8)other_pos[5] < 0) return;   /* 0539C6   */
    if (own_position_load() < 0) { /* TODO(waveC): 053FAE target undecoded */ return; }
    aprs_dist_bearing();                                /* falls into 0539DE   */
}

/* ---- sub_539DE (0539DE-053FAE, 1488 B)  aprs_dist_bearing  [Inferred] ------
 * Callers: sub_539C6 (fall-through), sub_54484.  Flat-earth distance and
 * 16-point bearing from own_pos (A7BE) to other_pos (A7C8).
 * Outputs: FFA7A0..A7A3 = distance digits (thousands, hundreds, tens,
 * units; 0xFFFFFFFF = out of range), FFA7A4 = compass sector 0..15, FFA7A5
 * = flags (b0 own South, b7 own West, b3 legs scaled /10, b4 /20).
 * Units: positions in 1/100 arc-minute (0.01 nmi), x10/54 gives 0.1 km;
 * FF8AAC b1 (miles) applies x159/256.  Step structure transcribed; the
 * table maths is summarised.                                            */
void aprs_dist_bearing(void)
{
    /* 0539DE-053B24: v = (flags & 0x0F ? 600000 : 0) + deg*6000 + min*100
     * + frac/10.  own lat -> A7AE, own lon -> A7B2, other lat -> A7A6,
     * other lon -> A7AA; A7A5.b0 = own S, A7A5.b7 = own W.                */
    u32 olat = lin(&own_pos[0]),  olon = lin(&own_pos[5]);
    u32 tlat = lin(&other_pos[0]), tlon = lin(&other_pos[5]);
    u8 oct = 0;                                         /* 053B2A: FFA7BC      */
    u32 dlat, dlon;
    /* 053B30: |dlat|; opposite hemispheres add; oct = 8 when own >= other */
    if (((other_pos[0] ^ own_pos[0]) >> 4) & 1) { dlat = olat + tlat; oct = 8; }
    else if (olat >= tlat) { dlat = olat - tlat; oct = 8; }
    else dlat = tlat - olat;
    /* 053B6A: |dlon| with the 180-degree wrap (0x107AC0 = 180*6000,
     * 0x20F580 = 360*6000); oct += 4 when own >= other.                   */
    if (((other_pos[5] ^ own_pos[5]) >> 4) & 1) {
        u32 s = olon + tlon;
        if (s >= 0x107AC0) dlon = 0x20F580 - s; else { dlon = s; oct += 4; }
    } else if (olon >= tlon) { dlon = olon - tlon; oct += 4; }
    else dlon = tlon - olon;
    /* 053BCA-053C82: cos(latitude) scaling of dlon: latitudes in half
     * degrees (deg*2 + (min >= 30)), interpolated with ROM 0x0541CE; for an
     * index >= 8, dlon = dlon * ROM 0x054118[idx] >> 8.
     * 053C88-053CE6: same-hemisphere correction from ROM 0x054284 (row by
     * latitude band 20/40/60 degrees, column = high word of dlon, <= 9).  */
    dlon = cos_scale(dlon);                             /* TODO(waveC): table maths */
    /* 053CEC: A7A6 = larger leg, A7AA = smaller; oct += 2 if swapped     */
    u32 big = dlat, small = dlon;
    if (big < small) { u32 t = big; big = small; small = t; oct += 2; }
    /* 053D18-053E04: distance = isqrt(big^2 + small^2) by the halving loop
     * at 053DBE; if the squares exceed 0xADCEA100 the legs are divided by
     * 10 (A7A5.b3), or below 180 degrees by 20 (A7A5.b4), else 0xFFFF.
     * Result x10 / 0x36 -> A7A6.                                         */
    u16 dist = scaled_isqrt(big, small);
    /* 053E08-053E54: bearing: both legs shifted to 8 bits, r = small*256/
     * big -> ROM 0x054018 atan table (0..45 degrees); equal legs -> 45;
     * >= 23 bumps the octant (oct++).  A7AB = angle.                       */
    u8 ang = atan_lookup(big, small, &oct);
    /* 053E5A-053EF4: miles (FF8AAC b1): dist*159 >> 8; range limits 0x3085
     * (mi) / 0x4E20 (km) in /20 mode (value doubled, 10000 subtracted);
     * A7A0 = d/1000, A7A1 = (d%1000)/100, A7A2 = tens, A7A3 = units.      */
    put_distance_digits(dist);
    /* 053EFA-053FAA: bearing = ROM 0x053FB6[oct & ~1] +/- ang; sector =
     * first index with bearing < ROM 0x053FC6[i]; then mirrored for own
     * S/W hemispheres via ROM 0x053FE8 / 0x053FF8 / 0x054008 -> A7A4.     */
    FFA7A4 = bearing_sector(oct, ang);
}

/* ---- sub_542AC (0542AC-054484, 472 B)  rx_position_parse  [Inferred] ------
 * Caller: sub_46850 (APRS receive).  Parses the received-position text at
 * FF9DC2 into rx_pos (FFA7D8..FFA7E1, same format as above), then two
 * 3-digit decimal fields: FF9D34 = dec3(FF9DC8), FF9D36 = dec3(FF9DD2)
 * (overlap with the position text is as coded; meaning of 9D34/9D36 open).*/
void rx_position_parse(void)
{
    parse_position_text_to((const u8 *)0xFF9DC2, rx_pos);   /* 0542AC      */
    FF9D34 = dec3_at((const u8 *)0xFF9DC8);             /* 0543FE              */
    FF9D36 = dec3_at((const u8 *)0xFF9DD2);             /* 054440              */
}

/* ---- sub_54484 (054484-0544F2, 110 B)  aprs_rx_dist_bearing  [Confirmed] --
 * Caller: sub_46652.  If rx_pos is valid: own position via sub_53784, or
 * the GPS text (sub_53822) when FF8EB2 == 1, or FF8EB2 != 0 and FF9DB8 ==
 * 1; copy rx_pos to other_pos, run aprs_dist_bearing and keep the result
 * (A7D2..A7D5 digits, A7D6 sector, A7D7 flags).  Failure: A7D6 = 0xFF.   */
void aprs_rx_dist_bearing(void)
{
    if ((s8)rx_pos[0] < 0 || (s8)rx_pos[5] < 0) goto none;  /* 054484      */
    s8 r;
    if (FF8EB2 == 0)                         r = own_position_load();
    else if (FF8EB2 == 1 || FF9DB8 == 1)     r = own_position_from_gps();
    else                                     r = own_position_load();
    if (r < 0) goto none;
    memcpy(other_pos, rx_pos, 10);                      /* 0544B0              */
    aprs_dist_bearing();                                /* 0544C8              */
    *(u32 *)0xFFA7D2 = *(u32 *)0xFFA7A0;                /* 0544CC              */
    FFA7D6 = FFA7A4;  FFA7D7 = FFA7A5;                  /* 0544D8              */
    return;
none:
    FFA7D6 = 0xFF;                                      /* 0544EA              */
}

/* ---- sub_544F2 (0544F2-054502) + sub_54502 (054502-05450E)  [Confirmed] ---
 * aprs_rx_dist_bearing_cfg.  Caller: sub_469C6.  As above but always the
 * configured source (sub_53784).  IDA split it after the jsr (054502 bmi).*/

/* ---- sub_5450E (05450E-054524, 22 B)  aprs_ack_state_reset  [Confirmed] --
 * Callers: config load sub_ED16, sub_54A28.                               */
void aprs_ack_state_reset(void) { FFA514 = FFA515 = FFA518 = 0xFF; FFA519 = 0; }
/* ---- sub_54524 (054524-054536, 18 B)  aprs_autoreply_state_reset [Confirmed]*/
void aprs_autoreply_state_reset(void) { FFA51A = FFA51B = 0xFF; FFA51D = 0; }

/* ---- sub_54536 (054536-054568, 50 B)  aprs_beacon_mode_eval  [Confirmed] --
 * Caller: sub_ED16.  beacon_mode FFA90C from FF8AAB (b6 AUTO, b1 SMART,
 * doc 90): 0 off, 1 auto, 2 SmartBeaconing (needs FF8BCC != 0 and GPS
 * source FF8AB8 == 0; otherwise the SMART bit is cleared, mode 0).       */
void aprs_beacon_mode_eval(void)
{
    u8 m = 0;
    if (FF8AAB & 0x42) {                                /* 054538              */
        m = 1;
        if (!(FF8AAB & 0x40)) {                         /* 054542              */
            if (FF8BCC != 0 && FF8AB8 == 0) m = 2;      /* 05454A / 054552     */
            else { FF8AAB &= ~0x02; m = 0; }            /* 05455A              */
        }
    }
    beacon_mode = m;                                    /* 054562              */
}

/* ---- sub_54568 (054568-054592, 42 B)  aprs_band_ok  [Confirmed] ------------
 * Callers: sub_4477E, 545AC, 5469C, 548BE.  0 (Z) when the APRS modem
 * FF8AA0 is on, FF8EA0 b6 or b7 is set, and FF8DD5 is 0 or 2; else 1.   */
u8 aprs_band_ok(void)
{
    if (FF8AA0 == 0) return 1;
    if (!(FF8EA0 & 0xC0)) return 1;
    return (FF8DD5 == 0 || FF8DD5 == 2) ? 0 : 1;
}

/* ---- sub_54592 (054592-0545AC, 26 B)  aprs_tasks_arm  [Confirmed] ----------
 * Callers: sub_211B2, sub_211EE (settings apply).  FFA50E = 1 (beacon arm
 * request), retry/ack requests and slots idle (0).                       */
void aprs_tasks_arm(void) { FFA50E = 1; FFA510 = FFA511 = 0; FFA514 = FFA515 = 0; }

/* ---- sub_545AC (0545AC-0545F6, 74 B)  aprs_beacon_task  [Confirmed] --------
 * Main loop 0x002C10 (doc 90).  Disarm when the modem/band check fails or
 * beacon_mode != 1.  A pending arm request (FFA50E >= 0) is consumed.
 * Idle (FFA50F == 0) + request -> load the interval (sub_545F6), state 1.
 * State != 0 continues at 0x05460C (the send/busy-retry body, in the gap
 * after sub_545F6, outside this chunk).                                  */
void aprs_beacon_task(void)
{
    if (FF8AA0 == 0 || aprs_band_ok() != 0 || beacon_mode != 1) {
        FFA50E = 0xFF; FFA50F = 0;                      /* 0545C2              */
    }
    s8 req = (s8)FFA50E;                                /* 0545CE              */
    if (req >= 0) { FFA50E = 0xFF; FFA50F = 0; }        /* 0545D4              */
    if (FFA50F != 0) { beacon_task_run_5460C(); return; }   /* 0545E6       */
    if (req < 0) return;
    beacon_timer_load();                                /* 0545EC: sub_545F6   */
    FFA50F = 1;
}

/* ---- sub_545F6 (0545F6-05460C, 22 B)  beacon_timer_load  [Confirmed] ------
 * Callers: sub_545AC, sub_22ACC.  FF95EC = ROM word table 0x003FB0[FF8ABC]
 * (30 s .. 3600 s, doc 90).                                              */
void beacon_timer_load(void) { FF95EC = rom_beacon_intervals_3FB0[FF8ABC]; }

/* ---- sub_54630 (054630-05469C, 108 B)  aprs_tx_busy  [Confirmed] -----------
 * Callers: sub_4477E, 5469C, 548BE.  0 = clear to send an automatic APRS
 * frame, 1 = defer (doc 90 "busy channel").  Requires tx_state FF94C0 == 0;
 * FF8EA0 b6|b7; not (screen FFA9F9 == 5 and FFA9FA b1); FFAE90 b0 clear;
 * FFAD69 b7 clear; FF94C1 == 0; neither VFO mode byte FF8EE0/FF8EE1 is
 * 0x0B; FF9072 == 0; FF907B >= 3; FF9078 == 2.  The meaning of the last
 * three record bytes is not established here.                           */
u8 aprs_tx_busy(void)
{
    if (tx_state != 0)                         return 1;
    if (!(FF8EA0 & 0xC0))                      return 1;
    if (FFA9F9 == 5 && (FFA9FA & 0x02))        return 1;
    if (FFAE90 & 0x01)                         return 1;
    if (FFAD69 & 0x80)                         return 1;
    if (FF94C1 != 0)                           return 1;
    if (FF8EE1 == 0x0B || FF8EE0 == 0x0B)      return 1;
    if (FF9072 != 0)                           return 1;
    if (FF907B < 3)                            return 1;
    if (FF9078 != 2)                           return 1;
    return 0;
}

/* ---- sub_5469C (05469C-0547D2, 310 B)  aprs_msg_retry_task  [Confirmed] ----
 * Main loop 0x002C14 (doc 90).  State FFA513 (0 idle / 1 timing), slot
 * FFA511, request FFA510, timer FF95B6 (10 ms): 0x1770 = 60 s between
 * retries, 0x12C = 3 s after a busy channel or a found slot.            */
void aprs_msg_retry_task(void)
{
    if (aprs_band_ok() != 0 || FF8AA0 == 0) { FFA510 = 0xFF; FFA513 = 0; }
    s8 req = (s8)FFA510;
    if (req >= 0) { FFA510 = 0xFF; FFA513 = 0; }        /* 0546BC              */
    if (FFA513 == 0) {                                  /* 0546C8              */
        if (req < 0) return;
        FFA511 = (u8)req; FF95B6 = 0x1770; FFA513 = 1;  /* 0546D4: 60 s        */
        return;
    }
    if (FF95B6 != 0) return;                            /* 0546E8              */
    if (FFA511 != 0xFF) {
        if (aprs_tx_busy()) goto busy;                  /* 0546FA              */
        u8 *rec = (u8 *)0xFEE780 + FFA511 * 32;
        if (rec[0] != 0xFF && (rec[0x1A] & 1) &&        /* 054714: outgoing    */
            !(rec[0x1B] & 0x80) && rec[0x1B] != 1) {    /* retries left        */
            FFA512 = FFA511;
            sub_3DA52();                                /* 054736              */
            if (aprs_req_msg_retry_22D76(rec[0x19]) == 0) tone_ev = 0; /* 054750 */
            rec[0x1B]--;                                /* 05476E              */
            /* 054778: re-timestamp: rec[0..2] = today FFA9C4[0..2], rec[3..4]
             * = time word FFA9C8, rec[5] = sequence FFA505++.               */
            *(u32 *)rec = (today_date & ~0xFFu) | (FFA9C8 >> 8);
            *(u16 *)(rec + 4) = (u16)(((FFA9C8 & 0xFF) << 8) | FFA505++);
            aprs_msg_saved(rec);                        /* 05479A: sub_547D2   */
        } else {
            rec[0x1B] = 0xFF;                           /* 05479E: give up     */
            aprs_msg_saved(rec);
            FFA511 = 0xFF;
        }
    }
    if (aprs_next_retry_slot() == 0) {                  /* 0547AC: sub_5484C   */
        FF95B6 = 0x1770; FFA513 = 1; return;            /* 0547B2: idle 60 s   */
    }
busy:
    FF95B6 = 0x12C; FFA513 = 1;                         /* 0547C2: 3 s         */
}

/* ---- sub_547D2 (0547D2-05482C, 90 B)  aprs_msg_saved  [Inferred] -----------
 * Persist slot FFA511 (sub_3D8F8); if the message screen is up (FFA9F9 ==
 * 5, FFA9FA b1 clear): when FFA9FA b0 and FFA764[FF8EAC] is this slot,
 * refresh the detail copy FF9E08 from er3; then request a redraw (FF817E
 * b1).  Entry 0547E2 (used by sub_5482C) skips the persist.             */
void aprs_msg_saved(const u8 *rec /*er3*/)
{
    sub_3D8F8(FFA511);                                  /* 0547DA              */
    if (FFA9F9 != 5 || (FFA9FA & 0x02)) return;         /* 0547E2              */
    if (FFA9FA & 0x01) {
        if (msg_map[FF8EAC] != FFA511) return;          /* 0547FA: FFA764      */
        memcpy((u8 *)0xFF9E08, rec, 32);                /* 054810              */
    }
    FF817E |= 0x02;                                     /* 054824              */
}

/* ---- sub_5482C (05482C-05484C, 32 B)  aprs_msg_retry_stop  [Confirmed] ----
 * Caller: sub_4A4D0 (":ack"/":rej" received, doc 90).                     */
void aprs_msg_retry_stop(void)
{
    aprs_msg_saved_noload((u8 *)0xFEE780 + FFA511 * 32);/* 05483E: bsr 547E2   */
    FFA512 = FFA511 = 0xFF;
}

/* ---- sub_5484C (05484C-0548BE, 114 B)  aprs_next_retry_slot  [Confirmed] --
 * Scan slots FFA512+1 .. 59 for an outgoing message with retries > 0,
 * other than FFA511.  Found: FFA511 = FFA512 = n, return 1.  None:
 * FFA511 = FFA512 = 0xFF, return 0.                                      */
u8 aprs_next_retry_slot(void)
{
    u8 n = (FFA512 == 0xFF) ? 0 : (u8)(FFA512 + 1);     /* 054850              */
    for (; n < 60; n++) {
        const u8 *r = (const u8 *)0xFEE780 + n * 32;
        if (r[0] == 0xFF || !(r[0x1A] & 1)) continue;
        if ((s8)r[0x1B] <= 0) continue;                 /* 054882              */
        if (FFA511 != 0xFF && FFA511 == n) continue;
        FFA511 = FFA512 = n; return 1;
    }
    FFA512 = FFA511 = 0xFF; return 0;                   /* 0548AA              */
}

/* ---- sub_548BE (0548BE-054A28, 362 B)  aprs_ack_task  [Confirmed] ----------
 * Main loop 0x002C18 (doc 90).  State FFA519 (0 idle, 1 timing, 2 sent),
 * slot FFA515, request FFA514, timer FF95B8 = 0x12C (3.00 s).  When the
 * timer expires and the channel is clear, for an incoming record (b0 clear)
 * with ack owed (b2): request the TX (sub_22DB8; tone_ev = 0 when it
 * returns Z), persist (sub_3D970), clear b2, addressee rec+8 -> FFA55C (9),
 * find the message number (sub_4F83C on FFA62C + rec[0x1C]) and build
 * ":ADDRESSEE:ackNN" (sub_51094).  If b6 (auto-reply wanted) and none is
 * pending (FFA51B == 0xFF, FFA51D == 0): FFA51A = slot (the auto-reply
 * sender 0x054AC0 has no caller, doc 90).  State 2.                     */
void aprs_ack_task(void)
{
    if (aprs_band_ok() != 0 || FF8AA0 == 0) aprs_ack_state_reset(); /* 0548CC */
    s8 req = (s8)FFA514;
    if (req >= 0) { FFA514 = 0xFF; FFA519 = 0; }        /* 0548E6              */
    if (FFA519 == 0) {
        if (req >= 0) { FFA515 = (u8)req; FF95B8 = 0x12C; FFA519 = 1; }
        return;
    }
    if (FFA519 == 2 || FF95B8 != 0) return;             /* 054916              */
    if (FFA515 == 0xFF) { aprs_next_ack_slot(); return; }
    if (aprs_tx_busy()) { FF95B8 = 0x12C; FFA519 = 1; return; } /* 054A18     */
    u8 *rec = (u8 *)0xFEE780 + FFA515 * 32;
    if (rec[0] == 0xFF || (rec[0x1A] & 0x01) || !(rec[0x1A] & 0x04)) {
        rec[0x1A] &= ~0x04; FFA515 = 0xFF;              /* 054A04              */
        aprs_next_ack_slot(); return;
    }
    if (aprs_req_ack_22DB8() == 0) tone_ev = 0;         /* 054960              */
    sub_3D970(FFA515);                                  /* 054970              */
    rec[0x1A] &= ~0x04;                                 /* 05498A              */
    memcpy((u8 *)0xFFA55C, rec + 8, 9);                 /* 054990              */
    const u8 *txt = (const u8 *)0xFFA62C + *(u16 *)(rec + 0x1C);
    u8 num;
    if (!aprs_find_msgno_4F83C(&txt, &num)) { aprs_next_ack_slot(); return; }
    FFA56A = num; FFA566 = (u32)txt;                    /* 0549BE              */
    aprs_build_ack_51094();                             /* 0549C8              */
    if ((rec[0x1A] & 0x40) && FFA51B == 0xFF && FFA51D == 0)
        FFA51A = FFA515;                                /* 0549F4              */
    FFA519 = 2;                                         /* 0549FC              */
}

/* ---- sub_54A28 (054A28-054AC0, 152 B)  aprs_next_ack_slot  [Confirmed] ----
 * Next incoming record (b0 clear, b2 set) after FFA518, not FFA515.  Found:
 * FFA515 = FFA518 = n, timer 3 s, state 1, return 1.  None: reset the ack
 * and auto-reply state, return 0.                                        */
u8 aprs_next_ack_slot(void)
{
    u8 n = (FFA518 == 0xFF) ? 0 : (u8)(FFA518 + 1);
    for (; n < 60; n++) {
        const u8 *r = (const u8 *)0xFEE780 + n * 32;
        if (r[0] == 0xFF || (r[0x1A] & 1) || !(r[0x1A] & 4)) continue;
        if (FFA515 != 0xFF && FFA515 == n) continue;
        FFA515 = FFA518 = n; FF95B8 = 0x12C; FFA519 = 1; return 1;
    }
    aprs_ack_state_reset(); aprs_autoreply_state_reset();   /* 054A94       */
    return 0;
}
/* ========================================================================== *
 * PART 3  0x054BF8-0x055FFE : on-chip USB Function Module driver (vendor
 *         personality 26AA:0001) and the picture block-transfer engine.
 * The USB part re-verifies ida/out/c-recon/l15_usb_vendor.c (lane L15) and
 * docs 05/53/64/73/75 against this listing; bodies already written there
 * are summarised, with corrections marked "L15 FIX".
 *
 * L15 FIX (SETUP ring pointers): FF8156 is the ISR WRITE pointer (054DAE
 * loads it, 054DCC stores it back), FF8152 is the poll READ pointer
 * (055042 loads it, 05506E stores it after dequeuing 8 bytes), and FF8158
 * is simply the low word of FF8156 used for the empty test
 * "(u16)rd == (u16)wr" (055048 cmp.w r4,r6).  l15 labels FF8152 as the
 * write pointer and FF8158 as the read pointer.
 * ========================================================================== */

/* ---- sub_54BF8 (054BF8-054C12, 26 B)  usb_epir_load  [Confirmed] ----------
 * Caller: boot sub_20FA (0x002214).  50 bytes ROM 0x054C12 -> EPIR FFEE32.*/
void usb_epir_load(void)
{
    const u8 *p = rom_54C12;
    for (u8 n = 0x32; n; n--) USB_EPIR = *p++;          /* 054C00              */
}

/* ---- sub_54C44 (054C44-054CAE, 106 B)  usb_init  [Confirmed] ---------------
 * Caller: sub_20FA (0x002218).  Module reset, soft state, SETUP ring =
 * FF3CEA, ISR0/1/2 = 00/07/1F, IER0/1/2 = 8D/03/18, EE2D b2 (pull-up/
 * enable).  Report word FF8184 = 0x0100FFFF (rep_b0 = 1, shadow 0, w12
 * shadow 0xFFFF).                                                        */
void usb_init(void)
{
    usb_module_reset();                                 /* 054C44              */
    usb_ev = usb_cfgstep = 0;  usb_state = usb_latch = 0;
    *(u32 *)&rep_b0 = 0x0100FFFF;                       /* 054C64              */
    setup_rd = setup_wr = 0xFF3CEA;                     /* 054C6A              */
    USB_ISR0 = 0x00; USB_ISR1 = 0x07; USB_ISR2 = 0x1F;  /* 054C7E              */
    USB_IER0 = 0x8D; USB_IER1 = 0x03; USB_IER2 = 0x18;  /* 054C94              */
    USB_CTRL_EE2D |= 0x04;                              /* 054CA6              */
}

/* ---- sub_54CAE (054CAE-054CFA, 76 B)  usb_module_reset  [Confirmed] --------
 * FCLR0 = 0x73, IFR0..2 = 0, EE2D/EE2E/EE2F/EE2A/EE44 = 0, clear the 0x42
 * longs at FF3C6A (EP0-OUT buffer + SETUP ring).                          */
void usb_module_reset(void)
{
    USB_FCLR0 = 0x73;
    USB_IFR0 = USB_IFR1 = USB_IFR2 = 0;
    USB_CTRL_EE2D = 0; USB_EE2E = 0; USB_EE2F = 0; USB_EPSTL_EE2A = 0; USB_EE44 = 0;
    for (u32 *p = (u32 *)0xFF3C6A, n = 0x42; n; n--) *p++ = 0;  /* 054CE6     */
}

/* ---- sub_54CFA (054CFA-054D50, 86 B)  usb_isr_ifr2  [Confirmed] ------------
 * Vector 238.  usb_ev |= 0x02; acknowledge IFR2 b4 (|0x0B) with readback.
 * The resume pulse at 054D22 (EE2F = 8, nops, = 0) is unreachable: both
 * 054D1E and 054D20 branch past it (doc 64 sec.2).                         */
__interrupt void usb_isr_ifr2(void)
{
    usb_ev |= 0x02;                                     /* 054CFC              */
    u8 f = USB_IFR2 & 0x3B;
    if (f & 0x10) { USB_IFR2 = (f & ~0x10) | 0x0B; (void)USB_IFR2; }
}

/* ---- sub_54D50 (054D50-054EC2, 370 B)  usb_isr_main  [Confirmed] -----------
 * Vector 234.  CDC personality (FF813A != 0): save er0-er6 and call the
 * closed-window handler 0x07827C.  Otherwise service IFR0 in priority:
 *  b7 bus reset  -> ack (|0x2F), ring pointers = FF3CEA, FCLR0 = 0x73,
 *                   usb_ev |= 0x40  (usb_state is NOT reset);
 *  b3 SETUP      -> ack (|0xA7), copy 8 bytes EPDR0s (FFEE0E) into the ring
 *                   at setup_wr (wrap at 0x3D6A -> FF3CEA), TRG = 0x04;
 *  b2 EP0-OUT    -> ack (|0xAB), EPSZ0o (FFEE24) bytes of EPDR0o -> FF3C6A,
 *                   TRG = 0x02, usb_ev |= 0x10;
 *  b1 EP0-IN req -> ack (|0xAD); in usb_state 4: IER0 = 0x8D, FFB094 = 0,
 *                   TRG = 0x01 (zero-length status packet);
 *  b0 EP0-IN done-> ack (|0xAE); push next <= 8 bytes from FFB09E, TRG = 1,
 *                   or usb_ev |= 0x08 when nothing is left.
 * Full transcription: ida/out/c-recon/l15_usb_vendor.c usb_isr_main().    */
__interrupt void usb_isr_main(void);

/* ---- sub_54EC2 (054EC2-054FEC, 298 B)  usb_isr_vbus  [Confirmed] -----------
 * Vector 235.  IFR1 & 0x0F:
 *  b0 VBUS change -> ack (|6); usb_ev.b0 = IFR1.b3; FF817E |= 2; usb_state=0;
 *                    VBUS gone -> soft reset (as usb_soft_reset, 055FFE);
 *  b2 EP3 sent-request (dead: IER1 = 0x03 and 054ECC skips it) -> 3-byte
 *                    report [rep_b0, cam_size, quality] to EPDR3, TRG 0x40;
 *  b1 EP3 done    -> ack (|5), usb_ev |= 0x04.
 * Then IFR2 & 0x3B:
 *  b4 suspend     -> ack (|0x0B), usb_ev.b5 = IFR2.b5 (054FC2);
 *  b3             -> ack (|0x13), usb_ev |= 0x80 (054FCE..054FE2; not in
 *                    the l15 transcription).                             */
__interrupt void usb_isr_vbus(void);

/* ---- sub_54FEC (054FEC-055002, 22 B)  usb_poll  [Confirmed] ----------------
 * Main loop, vendor personality only.  jmp table 0x055002[usb_state]
 * (12 slots: 55034 55042 55196 551AA 551C2 55042 551DA 55306 55520 55552
 * 55306 556C8).                                                           */
void usb_poll(void) { usb_state_tbl_55002[usb_state](); }

/* ---- nullsub_97 (055032-055034, 2 B)  usb_state_ret  [Confirmed] -----------
 * The shared 'rts' that every state handler's early-outs branch to
 * (loc_55031+1).                                                          */

/* ---- sub_55034 (055034-055116, 226 B)  usb_st0_st1_setup  [Confirmed] -----
 * State 0 waits for VBUS (usb_ev b0) then sets state 1 and falls into the
 * state-1/5 entry 055042: dequeue one 8-byte SETUP packet into FF3D6A,
 * accept 80 06 / C1 D4 / 41 D3 / 41 D1 / 41 D2 directly, else match the 8
 * byte packet against the 8 entries of ROM 0x0558FE and on a hit take the
 * first entry's word (re-sync of a rotated ring); only GET_DESCRIPTOR
 * (80 06) is handled here: DEVICE -> 8-byte stub 0x055810 (state 1) or the
 * 18-byte descriptor 0x055818 (state 5); CONFIG -> first 9 bytes (0x05582A,
 * via sub_55116) then the 32-byte variant from table 0x05584A[0] (FF89CF
 * is read and then overwritten by 0: "mov.b #0,r5l" at 055102).          */
void usb_st0_st1_setup(void);

/* ---- sub_55116 (055116-055128, 18 B)  usb_send_cfg9  [Confirmed] -----------
 * Tail of sub_55034: usb_cfgstep |= 1; latch 5; 9 bytes from 0x05582A;
 * falls into ep0in_setup.                                                 */
void usb_send_cfg9(void) { usb_cfgstep |= 1; ep0in_setup(5, 9, rom_5582A); }

/* ---- sub_55144 (055144-055196, 82 B)  ep0in_setup  [Confirmed] -------------
 * r3l = next state latch, r6l = length, er5 = source.  FFB094 = remaining,
 * FFB09E = source, usb_latch = r3l, clear usb_ev b3/b4, usb_state = 2, push
 * the first min(len,8) bytes to EPDR0i (FFEE0C) and TRG = 0x01.           */
void ep0in_setup(u8 latch, u8 len, const u8 *src)
{
    ep0in_cnt = len; ep0in_ptr = (u32)src; usb_latch = latch;   /* 055144   */
    usb_ev &= ~0x18;  usb_state = 2;                    /* 055152              */
    u8 n = len;
    ep0in_cnt = (n < 9) ? 0 : (u8)(n - 8);              /* 055170              */
    if (n >= 9) n = 8;
    while (n--) USB_EPDR0I = *src++;                    /* 05517E              */
    ep0in_ptr = (u32)src;  USB_TRG = 0x01;              /* 055188              */
}

/* ---- sub_55196 (055196-0551C2, 44 B)  usb_st2_st3  [Confirmed] -------------
 * State 2: IN data done (usb_ev b3) -> state 3; falls into state 3
 * (0551AA): host OUT status (b4) -> usb_state = usb_latch.                */
void usb_st2_st3(void)
{
    if (usb_ev & 0x08) { usb_ev &= ~0x08; usb_state = 3; }
    else return;                                        /* 05519C              */
    if (usb_ev & 0x10) { usb_ev &= ~0x10; usb_state = usb_latch; }
}
/* NOTE: entry 055196 returns when b3 is clear; the state-3 entry 0551AA
 * (table slot 3) tests b4 alone.                                          */

/* ---- sub_551C2 (0551C2-0551DA, 24 B)  usb_st4_zlp_done  [Confirmed] --------*/
void usb_st4_zlp_done(void)
{ if (usb_ev & 0x08) { usb_ev &= ~0x08; usb_state = usb_latch; } }

/* ---- sub_551DA (0551DA-055306, 300 B)  usb_st6_d4  [Confirmed] -------------
 * EP3 report if changed (see ep3_report in l15), then accept C1 D4 and
 * answer the 1-byte quality code (0x18/0x30/0x50 from FF89CD) through
 * ep0in_setup(latch 7, 1, &FFB095).                                      */
void usb_st6_d4(void);

/* ---- sub_55306 (055306-05551E, 536 B)  usb_st7_d1_d3  [Confirmed] ----------
 * States 7/10.  EP3 report, then 41 D3 (remote button level -> FFB096,
 * ZLP -> state 7) or 41 D1 (start of image: refuse when tx_state, KEY LOCK
 * with lock type b0 clear, or picture busy FF2EC9; else latch the 24-bit
 * size into FFB098/FFBA46/FFBA6E, packet count, index 0, sub_6F512 +
 * sub_6A700 (QSO picture index record), FFA9E3 |= 0x10, tone 0x4F,
 * rep_b0 = 1, state 8, block counter init (loc_55B28), source FF5806).
 * Full transcription: l15_usb_vendor.c st7_d1_d3().                       */
void usb_st7_d1_d3(void);

/* ---- sub_55520 (055520-055652, 306 B)  usb_st8_st9  [Confirmed] -----------
 * State 8 (055520): hold the D1 status stage until the tone sequencer
 * FFAAE8 is idle, then ZLP -> 9.  State 9 (055552): EP1 bulk-OUT data
 * (IFR0 b6 -> usb_ep1_rx 055652) or the closing 41 D2: count short
 * transfers in FFBA73, final block (sub_559F4), FF2EC9 = 0, force an EP3
 * report (FF8185 = 0xFF), ZLP -> 10.  (l15 st8_wait_tone/st9_ep1_data.)  */
void usb_st8_st9(void);

/* ---- sub_55652 (055652-055684) + sub_5568A (05568A-0556C8)  usb_ep1_rx -----
 * [Confirmed]  One routine split by IDA inside the copy loop (054684..
 * 05568E).  n = EPSZ1 (FFEE25); 0 -> just re-arm.  push_expect FFBA6E -= n.
 * Refused transfer (FFBA72): drain n bytes of EPDR1.  Otherwise copy n
 * bytes EPDR1 -> FF5806 + push_index, store the new index, forward a full
 * 256-byte quarter (sub_55976) and wrap at 0x400 after a short busy wait
 * (sub_55A2C), setting FFBA38.  Finally TRG = 0x20 (re-arm EP1).
 * The wrap test follows the copy, so a packet that starts at index 0x3C1
 * writes up to 63 bytes past FF5C05 (doc 64 sec.5 / doc 75).            */
void usb_ep1_rx(void)
{
    u8 n = USB_EPSZ1;                                   /* 055652              */
    if (n) {
        push_expect -= n;                               /* 055662              */
        if (push_refuse) { while (n--) (void)USB_EPDR1; }   /* 0556B8       */
        else {
            u8 *d = (u8 *)0xFF5806 + push_index;        /* 05567E              */
            while (n--) *d++ = USB_EPDR1;               /* 055684              */
            push_index = (u16)((u32)d - 0xFF5806);      /* 055690              */
            img_forward_quarter(push_index);            /* 05569A: sub_55976   */
            if (push_index >= 0x400) {                  /* 05569E              */
                img_busy_wait_20000();                  /* 0556A4: sub_55A2C   */
                push_index = 0; push_wrapflag = 1;      /* 0556A8              */
            }
        }
    }
    USB_TRG = 0x20;                                     /* 0556C0              */
}

/* ---- sub_556C8 (0556C8-0557A2, 218 B)  usb_st11_sink  [Confirmed] ----------
 * State 11 (refused D1): drain EP1 packets; on 41 D2 force an EP3 report,
 * usb_latch = 0x0A (L15 FIX: l15 wrote "FF8182 = 4"; the code stores 0x0A
 * at 055774), usb_state = 4, IFR0 b1 ack, IER0 = 0x8F (arm the ZLP).     */
void usb_st11_sink(void);

/* ---- sub_557A2 (0557A2-055810, 110 B)  usb_report_refresh  [Confirmed] -----
 * Caller: sub_74B08 (settings change).  rep_b0 = 1, then the same send-on-
 * change 3-byte EP3 report as ep3_report (skip when unchanged or DASTS
 * FFEE27 b5 says the previous report is still in the FIFO).               */
void usb_report_refresh(void)
{
    rep_b0 = 1;                                         /* 0557A2              */
    ep3_report();                                       /* 0557A8..05580A      */
}

/* ========================================================================== *
 * Picture block-transfer engine (doc 53, corrected by doc 63).
 * FFBC48 = source pointer, FFBC3E = this block's length, FFBC40 = block
 * number, FFBC42 = total blocks, FFBC44 = running 32-bit checksum,
 * FFB098 = bytes still to forward, FFBA74 = bytes left in the current
 * 1 KB staging block, FFB208 = picture size (send path), FFB25A = 1 KB
 * block count.  sub_B610 builds one 0xFFFF IPC block frame (doc 53).
 * ========================================================================== */

/* ---- sub_55976 (055976-0559F4, 126 B)  img_forward_quarter  [Confirmed] ----
 * Caller: usb_ep1_rx.  When the write index reaches 0x100/0x200/0x300/0x400
 * send the quarter just completed (FF5806/5906/5A06/5B06) as one 256-byte
 * block; FFBC48 is left pointing at the NEXT quarter for the final short
 * block; FFB098 -= 0x100.                                                */
void img_forward_quarter(u16 idx /*r5*/)
{
    const u8 *src, *next;
    switch (idx) {
    case 0x100: src = (u8 *)0xFF5806; next = (u8 *)0xFF5906; break;
    case 0x200: src = (u8 *)0xFF5906; next = (u8 *)0xFF5A06; break;
    case 0x300: src = (u8 *)0xFF5A06; next = (u8 *)0xFF5B06; break;
    case 0x400: src = (u8 *)0xFF5B06; next = (u8 *)0xFF5806; break;
    default: return;
    }
    blk_src = (u32)next;  blk_len = 0x100;              /* 0559CC              */
    ipc_block_send_B610(src);                           /* 0559DA              */
    push_remain -= 0x100;                               /* 0559DE              */
}

/* ---- sub_559F4 (0559F4-055A24, 48 B)  img_push_finish  [Confirmed] ---------
 * Caller: usb_st8_st9 (41 D2).  Send the remaining FFB098 bytes from FFBC48
 * (then a short delay, sub_55A24), clear FFBBF2 b2, set FFBBF1 b4, call
 * sub_AF94 (SD/preview request), FFBC4E = 2.                            */
void img_push_finish(void)
{
    if (push_remain) {
        blk_len = (u16)push_remain;                     /* 0559FC              */
        ipc_block_send_B610((const u8 *)blk_src);       /* 055A06              */
        img_short_wait();                               /* 055A0A: sub_55A24   */
    }
    FFBBF2 &= ~0x04; FFBBF1 |= 0x10;                    /* 055A0C              */
    sub_AF94();  FFBC4E = 2;                            /* 055A18              */
}

/* ---- sub_55A24 (055A24-055A2C, 8 B) / sub_55A2C (055A2C-055A42, 22 B) ------
 * img_short_wait / img_busy_wait_20000  [Confirmed]: busy loops of 20000
 * iterations of 5 nops (both entries load the same count 0x4E20; 055A24
 * branches into the loop of 055A2C).                                     */
void img_busy_wait_20000(void) { for (u32 n = 0x4E20; n; n--) { __nop(); __nop(); __nop(); __nop(); __nop(); } }
#define img_short_wait() img_busy_wait_20000()

/* ---- sub_55A42 (055A42-055A70, 46 B)  pic_save_camera  [Confirmed] ---------
 * Caller: 0x02AC4C (camera picture dialog confirm, doc 63/pc-06).
 * FFBC52 = 2 (source = camera), SD write request sub_710D2, FFBAA3 = 0x0A,
 * FFBBF1 b1, FFBBE1 = 3, FFBBF2 b2, FFBBF1 b4, sub_AF94.                 */
void pic_save_camera(void)
{
    FFBC52 = 2; sub_710D2();                            /* 055A42              */
    FFBAA3 = 0x0A; FFBBF1 |= 0x02; FFBBE1 = 3;
    FFBBF2 |= 0x04; FFBBF1 |= 0x10; sub_AF94();
}
/* ---- sub_55A70 (055A70-055A9E, 46 B)  pic_save_received  [Confirmed] -------
 * Caller: 0x02ACAA (doc 63 sec.5).  FFBC52 = 3, sub_710C4, FFBAA3 = 0x10,
 * FFBBF1 b1, FFBBE1 = 3, FFBBF2 b1, FFBBF1 b4, sub_AF06.                 */
void pic_save_received(void)
{
    FFBC52 = 3; sub_710C4();
    FFBAA3 = 0x10; FFBBF1 |= 0x02; FFBBE1 = 3;
    FFBBF2 |= 0x02; FFBBF1 |= 0x10; sub_AF06();
}
/* ---- sub_55A9E (055A9E-055ABC, 30 B)  pic_dialog_close_cam  [Inferred] -----
 * Pointer-only (0x07040E).  FFBAA3 = 0, FFBBF1 b1 clear, FFBBE1 = 0,
 * redraw (FF817E b1), sub_6A802.                                         */
void pic_dialog_close_cam(void)
{ FFBAA3 = 0; FFBBF1 &= ~0x02; FFBBE1 = 0; FF817E |= 0x02; sub_6A802(); }
/* ---- sub_55ABC (055ABC-055ADE, 34 B)  pic_preview_cam  [Inferred] ----------
 * Caller: sub_6F2AC.  FFBA81 b1 clear, sub_2AB28, FFBBF2 b2, FFBBF1 b4,
 * sub_AF94, FFBC4E = 2.                                                  */
void pic_preview_cam(void)
{ FFBA81 &= ~0x02; sub_2AB28(); FFBBF2 |= 0x04; FFBBF1 |= 0x10; sub_AF94(); FFBC4E = 2; }
/* ---- sub_55ADE (055ADE-055AFC, 30 B)  pic_dialog_close_rx  [Inferred] ------
 * Pointer-only (0x070426).  As 055A9E but sub_6A5C8.                     */
void pic_dialog_close_rx(void)
{ FFBAA3 = 0; FFBBF1 &= ~0x02; FFBBE1 = 0; FF817E |= 0x02; sub_6A5C8(); }
/* ---- sub_55AFC (055AFC-055B1E, 34 B)  pic_preview_rx  [Inferred] -----------
 * Caller: sub_6F2AC.  As 055ABC but FFBBF2 b1, sub_AF06, FFBC4E = 3.     */
void pic_preview_rx(void)
{ FFBA81 &= ~0x02; sub_2AB28(); FFBBF2 |= 0x02; FFBBF1 |= 0x10; sub_AF06(); FFBC4E = 3; }

/* ---- sub_55B1E (055B1E-055B58, 58 B)  img_block_count  [Confirmed] ---------
 * Two entries: 055B1E uses the picture size FFB208 (callers sub_55C1E,
 * sub_5F422), 055B28 (loc_55B28) uses FFB098 (callers usb D1 handler,
 * sub_55D8C).  FFBC42 = ceil(size / 256) (0 stays 0), FFBC44 = 0 (checksum),
 * FFBC40 = 0 (block number), FFBC4E = 1.                                 */
void img_block_count(u32 size)
{
    u16 n = 0;
    if (size) { n = (u16)(size / 0x100); if (size % 0x100) n++; }  /* 055B30 */
    blk_total = n; blk_csum = 0; blk_no = 0; FFBC4E = 1; /* 055B3C            */
}

/* ---- sub_55B7A (055B7A-055BF2, 120 B)  pic_xfer_tick  [Confirmed] ----------
 * Main-loop tick (doc 63: called from 0x02C20).  Three small state
 * machines, each with a one-shot restart trigger:
 *   FFBC4F -> reset FFBC50; run off_55BF2[FFBC50] (11 slots, send path);
 *   FFBC51 -> reset FFBC54; run off_55C06[FFBC54] (6 slots, read-back);
 *   FFBC55 -> reset FFBC57; jmp off_55C12[FFBC57] (3 slots, rx push).
 * The trigger byte is passed to the handler in r2l.                      */
void pic_xfer_tick(void)
{
    u8 t;
    if ((t = FFBC4F)) { FFBC4F = 0; FFBC50 = 0; }       /* 055B7A              */
    send_tbl_55BF2[FFBC50](t);                          /* 055BA0              */
    if ((t = FFBC51)) { FFBC51 = 0; FFBC54 = 0; }
    rdbk_tbl_55C06[FFBC54](t);                          /* 055BC8              */
    if ((t = FFBC55)) { FFBC55 = 0; FFBC57 = 0; }
    rxpush_tbl_55C12[FFBC57](t);                        /* 055BF0: jmp         */
}

/* ---- sub_55C1E (055C1E-055C7E, 96 B)  picsend_s0_open  [Confirmed] ---------
 * send state 0 (r2l = trigger).  Open the picture file named at FF301E
 * (sub_6EE2A), size FF301A -> FFB208, FFBA31 = 1, FFB25A = ceil(size/1024),
 * block counters (sub_55B1E), checksum FFB1D4 = 0, timer FF95B4 = 0,
 * FFBA3A = 0, next state 1.                                               */
void picsend_s0_open(u8 trig)
{
    if (!trig) return;                                  /* 055C1E              */
    sub_6EE2A((u8 *)0xFF301E);                          /* 055C28              */
    pic_size = *(u32 *)0xFF301A;  FFBA31 = 1;           /* 055C2C              */
    u32 s = pic_size; u16 k = 0;
    if (s) { k = (u16)(s / 0x400); if (s % 0x400) k++; }
    pic_blocks_1k = (u8)k;                              /* 055C54: FFB25A      */
    img_block_count(pic_size);                          /* 055C58              */
    FFB1D4 = 0; FF95B4 = 0; FFBA3A = 0; FFBC50 = 1;     /* 055C5C              */
}

/* ---- sub_55C7E (055C7E-055CEA, 108 B)  picsend_s1_read1k  [Confirmed] ------
 * send state 1: when timer FF95B4 is 0, take min(1024, remaining FFB208)
 * bytes, read them from the file into FF5006 (sub_6EF20), add them to the
 * checksum FFB1D4, FFBC48 = FF5006, state 2.  (The "beq loc_55CB2" after
 * sub_6EF20 is a no-op branch: a read error is ignored.)                 */
void picsend_s1_read1k(void)
{
    if (FF95B4) return;
    u16 n = (pic_size >= 0x400) ? 0x400 : (u16)pic_size;
    if (pic_size >= 0x400) pic_size -= 0x400;           /* 055C94              */
    blk_left = n;  sub_6EF20();                         /* 055CA8: FFBA74      */
    const u8 *p = (const u8 *)0xFF5006;
    for (u16 i = 0; i < n; i++) FFB1D4 += *p++;         /* 055CC8              */
    blk_src = 0xFF5006; FFBC50 = 2;                     /* 055CD6              */
}

/* ---- sub_55CEA (055CEA-055D6C, 130 B)  picsend_s2_push  [Confirmed] --------
 * send state 2: unless IPC busy (FFBBE4), push up to 256 bytes of the 1 KB
 * block (sub_B610).  When the block is done: more 1 KB blocks -> timer
 * FF95B4 = 5, FFBA3A = 1, state 1; otherwise state 3.                    */
void picsend_s2_push(void)
{
    if (FFBBE4) return;
    u16 left = blk_left;
    const u8 *src = (const u8 *)blk_src;
    if (left < 0x100) { blk_len = left; blk_left = 0; }  /* 055CFA            */
    else { blk_left = left - 0x100; blk_len = 0x100; blk_src += 0x100; }
    ipc_block_send_B610(src);                           /* 055D32              */
    if (blk_left) return;
    if (pic_blocks_1k && --pic_blocks_1k) { FF95B4 = 5; FFBA3A = 1; FFBC50 = 1; }
    else FFBC50 = 3;                                    /* 055D64              */
}

/* ---- sub_55D6C (055D6C-055D8A, 30 B)  picsend_s3_done  [Confirmed] ---------
 * send state 3: when IPC idle, FFBBF1 b4, sub_ADC0, FFBC4E = 0, state 4.  */
void picsend_s3_done(void)
{ if (FFBBE4) return; FFBBF1 |= 0x10; sub_ADC0(); FFBC4E = 0; FFBC50 = 4; }

/* ---- sub_55D8A (055D8A-055D8C, 2 B)  pic_state_idle  [Confirmed] -----------
 * 'rts' slot (send state 4 and others).                                   */
void pic_state_idle(void) { }

/* ---- sub_55D8C (055D8C-055DC6, 58 B)  rdbk_s0_start  [Confirmed] -----------
 * read-back state 0 (trigger in r2l): FFBA38 = 0; remaining = FFB208, or
 * FFBA46 (camera size) when the source FFBC52 == 2; block counters
 * (loc_55B28); falls into rdbk_init (sub_55DC6).                         */
void rdbk_s0_start(u8 trig)
{
    if (!trig) return;
    push_wrapflag = 0;
    push_remain = (FFBC52 == 2) ? push_recsize : pic_size;  /* 055D90        */
    img_block_count(push_remain);                       /* loc_55B28           */
    rdbk_init();
}
/* ---- sub_55DC6 (055DC6-055DE8, 34 B)  rdbk_init  [Confirmed] ---------------
 * push_index = 0, retry budget FFBC53 = 4, FFBC48 = FF5806, state 1.     */
void rdbk_init(void)
{ push_index = 0; FFBC53 = 4; blk_src = 0xFF5806; FFBC54 = 1; }

/* ---- sub_55DE8 (055DE8-055DFA, 18 B)  rdbk_s1_request  [Confirmed] ---------
 * When IPC idle, send the read-back request (sub_B5CE, opcode 0xFE00 per
 * doc 63), state 2.                                                      */
void rdbk_s1_request(void) { if (FFBBE4) return; sub_B5CE(); FFBC54 = 2; }

/* ---- sub_55DFA (055DFA-055DFC, 2 B)  pic_state_idle2  [Confirmed] ----------*/

/* ---- sub_55DFC (055DFC-055EAA) + sub_55EB2 (055EB2-055F84)  rdbk_s2_frame --
 * [Confirmed]  One routine split by IDA (the checksum loop 055EAA-055EB2
 * sits between).  Caller: 0x047A7E/0x047B66 on a reverse 0xFF SCI-D frame,
 * only in read-back state 2.  Copy 0x118 bytes FF9800 -> FF1489 (doc 63:
 * source FF9800, destination FF1489).  Validate: payload length
 * [9802..03] - 0x11 <= 0x100; block number [980B..0C] == FFBC40; total
 * [980D..0E] == FFBC42; length 0x100, or exactly the remainder on the last
 * block.  Then FFB098 -= len, push_index += len, and copy the payload from
 * FF9813 to *FFBC48 adding each byte to the checksum FFBC44.
 * More data: decrement retry budget FFBC53 -> state 1 (request next), or,
 * when the budget is exhausted, FFBA74 = push_index, nullsub_39, FFBA38 = 1
 * and restart (rdbk_init).  Last block: compare the sender's 32-bit sum
 * [980F..9812] with FFBC44; then by source FFBC52 (2 = camera: sub_6A802,
 * sub_2AB28, FFBBF2 b2, sub_AF94, FFBC4E = 2; else sub_6A5C8, sub_2AB28,
 * FFBBF2 b1, sub_AF06, FFBC4E = 3), state 0.
 * Any validation failure: tone_ev = 0x1D (refused), FFBC4E = 3.          */
void rdbk_s2_frame(void)
{
    if (FFBC54 != 2) return;                            /* 055DFC              */
    memcpy((u8 *)0xFF1489, (u8 *)0xFF9800, 0x118);      /* 055E06              */
    u16 len = ((FF9802 << 8) | FF9803) - 0x11;          /* 055E1E              */
    if (len >= 0x101) goto bad;
    if (((FF980B << 8) | FF980C) != blk_no) goto bad;   /* 055E34              */
    if (((FF980D << 8) | FF980E) != blk_total) goto bad;/* 055E46              */
    if (push_remain < 0x100) { if (len != push_remain) goto bad; push_remain = 0; }
    else { if (len != 0x100) goto bad; push_remain -= 0x100; }
    push_index += len;                                  /* 055E88              */
    u32 sum = blk_csum; u8 *d = (u8 *)blk_src; const u8 *s = (const u8 *)0xFF9813;
    for (u16 i = len; i; i--) { u8 b = *s++; *d++ = b; sum += b; }  /* 055EAA */
    blk_csum = sum; blk_src = (u32)d;                   /* 055EB6              */
    if (push_remain) {
        if (--FFBC53) { FFBC54 = 1; return; }           /* 055ECA              */
        blk_left = push_index; nullsub_39(); push_wrapflag = 1; rdbk_init(); return;
    }
    if ((((u32)FF980F << 24) | (FF9810 << 16) | (FF9811 << 8) | FF9812) != sum) goto bad;
    if (push_index) { blk_left = push_index; nullsub_39(); }   /* 055F10     */
    if (FFBC52 != 2) { sub_6A5C8(); sub_2AB28(); FFBBF2 |= 0x02; FFBBF1 |= 0x10; sub_AF06(); FFBC4E = 3; }
    else             { sub_6A802(); sub_2AB28(); FFBBF2 |= 0x04; FFBBF1 |= 0x10; sub_AF94(); FFBC4E = 2; }
    FFBC54 = 0;
    return;
bad:
    tone_ev = 0x1D; FFBC4E = 3;                         /* 055F76              */
}

/* ---- sub_55F84 (055F84-055F96, 18 B)  rxpush_s0_arm  [Confirmed] -----------
 * rx-push state 0: on trigger, FFBC56 = 0, state 1.                       */
void rxpush_s0_arm(u8 trig) { if (trig) { FFBC56 = 0; FFBC57 = 1; } }
/* ---- sub_55F96 (055F96-055FF0, 90 B)  rxpush_s1_push  [Confirmed] ----------
 * rx-push state 1 (doc 63 sec.3): push the received 1 KB block at FFBC48
 * (= FF5006, set by sub_5F458) in 256-byte frames via sub_B610 (055FDE);
 * when FFBA74 reaches 0 -> state 2.                                      */
void rxpush_s1_push(void);   /* same body as picsend_s2_push minus the 1 KB loop */
/* ---- sub_55FF0 (055FF0-055FFE, 14 B)  rxpush_s2_done  [Confirmed] ----------
 * When IPC idle, FFBC56 = 1 (block delivered; polled by the C4FM picture
 * engine).                                                               */
void rxpush_s2_done(void) { if (!FFBBE4) FFBC56 = 1; }
