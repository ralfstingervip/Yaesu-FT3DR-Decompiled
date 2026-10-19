
/* ============================================================================
 * GPS page drawing helpers (screen 0x11)
 * ========================================================================== */

/* FFEE9282-FFEE9477  size 501  gps_draw_datetime_box  (sub_FFEE9282)
 * Callers: scr11_ev31_datetime, scr11_draw_all.  Panel at (x,y) 0x74x0x34:
 * line 1 "HH:MM AM" (12-hour clock), line 2 "Mmm DD".  The UTC fix time is
 * shifted by the time-zone menu value tz (half-hour steps, 26 = UTC) with a
 * date carry.  Nothing but the cleared panel is drawn until year, month,
 * day, hour and minute are all valid (!= 0xFF).  Confirmed. */
static void gps_draw_datetime_box(u16 x, u16 y, u8 tz)
{
    char date_s[8], time_s[8];        /* templates "       " FFF485A8, "  :    " FFF485B0 */
    u8 hm[2], ymd[3], i;
    memcpy_(date_s, "       ", 8);
    memcpy_(time_s, "  :    ", 8);
    lcd_clear_rect(x, y, 0x74, 0x34);
    if (g_gps[0] != 0xFF && g_gps[1] != 0xFF && g_gps[2] != 0xFF &&
        g_gps[3] != 0xFF && g_gps[4] != 0xFF) {
        memcpy_(hm,  &g_gps[3], 2);
        memcpy_(ymd, &g_gps[0], 3);
        gps_apply_timezone(tz, hm, ymd);
        if (ymd[1] <= 12 && ymd[1] > 0)                        /* month name */
            for (i = 0; i < 3; i++) date_s[i] = k_month_abbr[ymd[1] * 4 + i - 4];
        if (ymd[2] <= 9)          date_s[5] = '0';
        else if (ymd[2] <= 0x1F)  date_s[5] = '0' + ymd[2] / 10;
        date_s[6] = '0' | (ymd[2] % 10);
        if (hm[0] <= 23) {                                     /* 12-hour */
            if (hm[0] <= 11) fmt_dec2(&time_s[0], hm[0]);
            else             fmt_dec2(&time_s[0], hm[0] - 12); /* 12:xx shows 00 */
        }
        if (hm[1] <= 59) fmt_dec2(&time_s[3], hm[1]);
        time_s[5] = (hm[0] <= 11) ? 'A' : 'P';
        time_s[6] = 'M';
    }
    lcd_draw_text(x + 0x0D, y + 5,    1, time_s, 7, RGB_WHITE);
    lcd_draw_text(x + 0x0D, y + 0x1D, 1, date_s, 7, RGB_WHITE);
}

/* FFEE9477-FFEE956A  size 243  gps_bcd_frac_to_ascii  (sub_FFEE9477)
 * Writes the minute fraction of a coordinate.  fmt==1: the top three BCD
 * nibbles as ".mmm" digits (stops at an 0xF nibble).  fmt!=1: converts the
 * 4-digit BCD minute fraction to seconds (value*6/10) and writes two digits.
 * Note "mul [sp].uw" multiplies by the running place value 1,10,100,1000.
 * Confirmed. */
static void gps_bcd_frac_to_ascii(u16 bcd, char *out, u8 fmt)
{
    u8 shift, n, i; u16 val, place;
    if (fmt == 1) {
        for (shift = 12, i = 0; i < 3; i++) {
            n = (bcd >> shift) & 0x0F;  shift -= 4;
            if (n == 0x0F) return;
            out[i] = hex_digit_char(n);
        }
        return;
    }
    n = 0; val = 0; place = 1;
    for (i = 0; i < 4; i++) {
        if ((bcd & 0x0F) != 0x0F) { n++; val = (u16)(val + (bcd & 0x0F) * place); }
        bcd >>= 4;  place *= 10;
    }
    if (n == 0) return;
    val = (u16)(val * 6) / 10;                 /* fraction of a minute -> seconds*100 */
    *out++ = hex_digit_char(val / 1000);  val %= 1000;
    *out++ = hex_digit_char((u8)(val / 100)); val %= 100;   /* last remainder unused */
}

/* FFEE956A-FFEE97B0  size 582  gps_draw_latlon_box  (sub_FFEE956A)
 * Panel at (x,y) 0xC2x0x34.  Two 13-char lines built from templates
 * "N    \x06  .    " / "E    \x06  .    " (\x06 = degree glyph, Inferred):
 * degrees, minutes, then seconds (fmt 0, ' and " marks) or decimal minutes
 * (fmt !=0, '.' and ').  Hemisphere letters from g_gps[6].  show: 0 hidden,
 * 1 shown, 2 blinking.  Confirmed. */
static void gps_draw_latlon_box(u16 x, u16 y, u8 show, u8 fmt)
{
    char lat[14], lon[14]; u8 vis = 0;
    memcpy_(lat, "N    \x06  .    ", 14);
    memcpy_(lon, "E    \x06  .    ", 14);
    lcd_clear_rect(x, y, 0xC2, 0x34);
    if (g_gps[7]  != 0xFF && g_gps[7]  <= 90)   fmt_dec2(&lat[3], g_gps[7]);
    if (g_gps[8]  != 0xFF && g_gps[8]  <= 59)   fmt_dec2(&lat[6], g_gps[8]);
    if (*(u16 *)&g_gps[0xC] != 0xFFFF && *(u16 *)&g_gps[0xC] <= 0x9999)
        gps_bcd_frac_to_ascii(*(u16 *)&g_gps[0xC], &lat[9], fmt);
    if (g_gps[9]  != 0xFF && g_gps[9]  <= 0xB3) fmt_dec3_blank(&lon[2], g_gps[9]);
    if (g_gps[10] != 0xFF && g_gps[10] <= 59)   fmt_dec2(&lon[6], g_gps[10]);
    if (*(u16 *)&g_gps[0xE] != 0xFFFF && *(u16 *)&g_gps[0xE] <= 0x9999)
        gps_bcd_frac_to_ascii(*(u16 *)&g_gps[0xE], &lon[9], fmt);
    if (fmt == 0) { lat[8] = '\''; lat[0xB] = '"';  lon[8] = '\''; lon[0xB] = '"'; }
    else          { lat[8] = '.';  lat[0xC] = '\''; lon[8] = '.';  lon[0xC] = '\''; }
    switch (g_gps[6]) {
    case 0: lat[0] = 'N'; lon[0] = 'E'; break;
    case 1: lat[0] = 'N'; lon[0] = 'W'; break;
    case 2: lat[0] = 'S'; lon[0] = 'E'; break;
    case 3: lat[0] = 'S'; lon[0] = 'W'; break;
    }
    if (show == 0) vis = 0; else if (show == 1) vis = 1; else if (show == 2) vis = ui_blink_phase();
    if (vis == 1) {
        lcd_draw_text(x + 0x0D, y + 5,    1, lat, 0x0D, RGB_WHITE);
        lcd_draw_text(x + 0x0D, y + 0x1D, 1, lon, 0x0D, RGB_WHITE);
    }
}

/* FFEE97B0-FFEE993E  size 398  gps_draw_speed_box  (sub_FFEE97B0)
 * Panel (x,y) 0x74x0x1C.  Speed word g_gps[0x12] is BCD in 0.1 knot:
 * knot = v/10, mph = v*11507/100000, km/h = v*1852/10000 (exact nautical
 * conversions).  Four digits with leading-zero blanking + unit.  Confirmed. */
static void gps_draw_speed_box(u16 x, u16 y, u8 unit)
{
    char s[9]; u32 v; u8 i;
    memcpy_(s, "    knot", 8); s[8] = 0;
    lcd_clear_rect(x, y, 0x74, 0x1C);
    if (unit == 1)      memcpy_(&s[4], "knot", 4);
    else if (unit == 2) memcpy_(&s[4], "mph ", 4);
    else                memcpy_(&s[4], "km/h", 4);
    if (*(u16 *)&g_gps[0x12] != 0xFFFF) {
        u16 b = *(u16 *)&g_gps[0x12];
        v = (b >> 12) * 1000 + ((b & 0xF00) >> 8) * 100 + ((b & 0xF0) >> 4) * 10 + (b & 0xF);
        if (unit == 1)      v = v / 10;
        else if (unit == 2) v = v * 0x2CF3 / 100000;
        else                v = v * 0x73C / 10000;
        s[0] = '0' + v / 1000; v %= 1000;
        s[1] = '0' + v / 100;  v %= 100;
        s[2] = '0' + v / 10;   v %= 10;
        s[3] = '0' + v;
        for (i = 0; i < 3 && s[i] == '0'; i++) s[i] = ' ';
    }
    lcd_draw_text(x, y + 5, 1, s, 8, RGB_WHITE);
}

/* FFEE993E-FFEE9A8E  size 336  gps_draw_altitude_box  (sub_FFEE993E; IDA's
 * lane-4 head sub_FFEE9A71 is the shared draw tail)
 * Panel (x,y) 0xC2x0x1C, text "ALTI nnnnn m " or "ALTI nnnnn ft".  Feet are
 * computed in IEEE double: alt / 0.3048 (constant 0x3FD381D7_DBF487FD) via the
 * CC-RX runtime.  g_gps[0x1D]==1 puts a '-' before the first digit; "-0"
 * collapses to " 0".  NOTE: the text position is hard-coded (0x89,0xD7), not
 * derived from x,y.  Confirmed. */
static void gps_draw_altitude_box(u16 x, u16 y, u8 unit)
{
    char s[14]; u16 a; u8 i;
    memcpy_(s, "ALTI       m ", 14);
    lcd_clear_rect(x, y, 0xC2, 0x1C);
    if (unit == 1) { s[0xB] = 'f'; s[0xC] = 't'; }
    a = *(u16 *)&g_gps[0x1E];
    if (a != 0xFFFF) {
        if (unit == 1) a = double_to_u16(double_div(u16_to_double(a), 0.3048));
        s[6]  = '0' | (a / 10000);  a %= 10000;
        s[7]  = '0' + a / 1000;     a %= 1000;
        s[8]  = '0' + a / 100;      a %= 100;
        s[9]  = '0' + a / 10;       a %= 10;
        s[10] = '0' + a;
        for (i = 0; i < 4 && s[6 + i] == '0'; i++) s[6 + i] = ' ';
        if (g_gps[0x1D] == 1) s[5 + i] = '-';
        if (s[10] == '0' && s[9] == '-') s[9] = ' ';
    }
    lcd_draw_text(0x89, 0xD7, 1, s, 0x0D, RGB_WHITE);
}

/* FFEE9A8E-FFEE9DA5  size 791  gps_draw_snr_bars  (sub_FFEE9A8E)
 * SNR bar graph right of the sky plot: up to 14 satellites, scanned in
 * ascending PRN order (outer loop prn 0..254, inner loop over the 36
 * records).  Bar height = 3*min(snr/2,25) px (snr >= 100 -> 0 = invalid),
 * blue 0x041F if used in the fix else grey 0x7BEF, second colour 0xC73F.
 * Two-character label under each bar: PRN 33..64 -> "AS", 193 -> "QZ"
 * (QZSS), else two digits.  QUIRK: for a blank label character the icon call
 * still runs with mode 0 and the previous glyph pointer.  Confirmed. */
static void gps_draw_snr_bars(u16 x, u16 y)
{
    const u8 x0 = 0x87, ybase = 0x76, lx1 = 0x86, ly1 = 0x7B, lx2 = 0x86, ly2 = 0x88;
    u8 n, drawn = 0, prn, i, k, h, mode; u16 col = 0;
    const void *glyph = 0; char lab[3];
    n = (g_gps[0x30] <= 0x0D) ? g_gps[0x30] : 0x0E;
    lcd_clear_rect(x, y, 0x140 - x, 0x98 - y);
    if (g_gps[0x30] == 0 || g_gps[0x30] == 0xFF) return;
    for (prn = 0; prn < 0xFF; prn++) {
        for (i = 0; i < 36; i++) {
            const u8 *r = &g_gps[0x32 + i * 6];   /* prn, elev, az.w, snr, used */
            if (r[0] != prn) continue;
            memcpy_(lab, "  ", 3);                /* asc_FFF485EB */
            h = (r[4] >= 100) ? 0 : (r[4] >= 0x31) ? 0x19 : (r[4] >> 1);
            h *= 3;
            if (r[5] == 0) lcd_fill_rect2(x0 + col, ybase - h, 6, h, RGB_GREY, 0xC73F);
            else           lcd_fill_rect2(x0 + col, ybase - h, 6, h, 0x041F,  0xC73F);
            if (r[0] >= 0x21 && r[0] <= 0x40) { lab[0] = 'A'; lab[1] = 'S'; }
            else if (r[0] == 0xC1)            { lab[0] = 'Q'; lab[1] = 'Z'; }
            else fmt_dec2(lab, r[0]);
            for (k = 0; k < 2; k++) {
                mode = 1;
                switch (lab[k]) {
                case '0': case '1': case '2': case '3': case '4':
                case '5': case '6': case '7': case '8': case '9':
                          glyph = k_prn_glyph[lab[k] - '0']; break;   /* FFED24BC + 0x10*d */
                case 'A': glyph = stru_FFED336C; break;
                case 'S': glyph = stru_FFED338C; break;
                case 'Q': glyph = stru_FFED337C; break;
                case 'Z': glyph = stru_FFED339C; break;
                default:  mode = 0; break;
                }
                if (k == 0) lcd_draw_icon(lx1 + col, ly1, mode, glyph);
                else        lcd_draw_icon(lx2 + col, ly2, mode, glyph);
            }
            col += 0x0D;
            if (++drawn >= n) return;
        }
    }
}

/* FFEE9DA5-FFEE9E2D  size 136  gps_azimuth_sector  (sub_FFEE9DA5)
 * BCD azimuth -> compass sector.  The value wraps at 3600 (so 0.1-degree
 * units, Inferred).  mode 0x20: 32 sectors of 11.25 deg (centred), else 16
 * sectors of 22.5 deg.  0xFFFF counts as 0.  Confirmed (arithmetic). */
static u8 gps_azimuth_sector(u16 az_bcd, u8 mode)
{
    u32 a = (az_bcd == 0xFFFF) ? 0 : bcd4_to_bin(az_bcd);
    while (a > 0xE0F) a -= 0xE10;
    a *= 20;
    if (mode == 0x20) { a += 0x465; if (a >= 72000) a -= 72000; return (u8)(a / 0x8CA); }
    a += 0x8CA; if (a >= 72000) a -= 72000; return (u8)(a / 0x1194);
}

/* FFEE9E2D-FFEE9F83  size 342  gps_draw_skyplot  (sub_FFEE9E2D)
 * Places one marker per satellite on the sky-plot circle: position from the
 * flash table k_skyplot_xy[sector 0..31][ring 0..9], ring = elevation tens
 * (elev <5 or >90 -> ring 0, >=85 -> ring 9).  Filled marker FFED333C when
 * used in the fix, hollow FFED334C otherwise.  Confirmed. */
static void gps_draw_skyplot(u16 x, u16 y)
{
    u8 i, sec, ring, e;
    lcd_clear_rect(x, y, 0x7D - x, 0x96 - y);
    if (g_gps[0x30] == 0 || g_gps[0x30] == 0xFF) return;
    for (i = 0; i < 36; i++) {
        const u8 *r = &g_gps[0x32 + i * 6];
        if (r[0] == 0xFF) continue;
        sec = gps_azimuth_sector(*(u16 *)&r[2], 0x20);
        e = r[1];
        if (e < 5 || e >= 0x5B) ring = 0;
        else if (e >= 0x55)     ring = 9;
        else                    ring = (u8)((s32)(e + 5) / 10);
        lcd_draw_icon(k_skyplot_xy[sec][ring * 2], k_skyplot_xy[sec][ring * 2 + 1], 1,
                      r[5] ? stru_FFED333C : stru_FFED334C);
    }
}

/* FFEE9F83-FFEE9FDB  size 88  gps_apply_timezone  (sub_FFEE9F83)
 * tz is the TIME ZONE menu index: 26 = UTC, each step = 30 minutes (so
 * 0..51 covers -13:00..+12:30).  Shifts hh:mm and steps the date on carry
 * (only if the year byte is valid).  Confirmed. */
static void gps_apply_timezone(u8 tz, u8 *hm, u8 *ymd)
{
    u8 east = (tz >= 0x1A), n, carry;
    n = east ? (u8)(tz - 0x1A) : (u8)(0x1A - tz);
    if (n == 0) return;
    carry = gps_shift_time_halfhours(east, n, hm);
    if (ymd[0] != 0xFF) gps_step_date(carry, ymd);
}

/* FFEE9FDB-FFEEA0A3  size 200  gps_shift_time_halfhours  (sub_FFEE9FDB)
 * Adds (east) or subtracts n half-hours from hm = {hour, minute}.
 * Returns 1 = next day, 2 = previous day, 0 = same day.  Confirmed. */
static u8 gps_shift_time_halfhours(u8 east, u8 n, u8 *hm)
{
    u8 ret = 0, odd = n & 1;
    if (east) {
        if (odd) { hm[1] += 0x1E; if (hm[1] >= 0x3C) { hm[1] -= 0x3C; n += 2; } }
        n >>= 1;
        hm[0] += n;
        if (hm[0] >= 0x18) { hm[0] -= 0x18; ret = 1; }
    } else {
        if (odd) { if (hm[1] <= 0x1D) { hm[1] += 0x3C; n += 2; } hm[1] -= 0x1E; }
        n >>= 1;
        if (hm[0] < n) { hm[0] += 0x18; ret = 2; }
        hm[0] -= n;
    }
    return ret;
}

/* FFEEA0A3-FFEEA189  size 230  gps_step_date  (sub_FFEEA0A3)
 * ymd = {yy, mm, dd}.  dir 1 = +1 day, 2 = -1 day, else nothing.
 * Uses k_days_in_month (FFC3D649) and is_leap_yy.  Confirmed. */
static void gps_step_date(u8 dir, u8 *ymd)
{
    if (dir == 1) {
        ymd[2]++;
        if (ymd[2] <= k_days_in_month[ymd[1]]) return;
        if (ymd[1] == 2) {
            if (!is_leap_yy(ymd[0])) { ymd[1] = 3; ymd[2] = 1; return; }
            if (ymd[2] == 0x1E)      { ymd[1] = 3; ymd[2] = 1; }
            return;                                   /* Feb 29 in a leap year */
        }
        ymd[1]++; ymd[2] = 1;
        if (ymd[1] == 0x0D) { ymd[1] = 1; ymd[0]++; }
    } else if (dir == 2) {
        ymd[2]--;
        if (ymd[2] != 0) return;
        ymd[1]--;
        if (ymd[1] == 0) { ymd[1] = 0x0C; ymd[0]--; }
        ymd[2] = k_days_in_month[ymd[1]];
        if (ymd[1] == 2 && is_leap_yy(ymd[0])) ymd[2] = 0x1D;
    }
}

/* FFEEA189-FFEEA1AE  size 37  is_leap_yy  (sub_FFEEA189)
 * Two-digit year leap test.  QUIRK: yy == 0 (2000, a leap year) returns 0.
 * Confirmed. */
static u8 is_leap_yy(u8 yy)
{
    if (yy == 0) return 0;
    return (yy & 3) == 0;
}
