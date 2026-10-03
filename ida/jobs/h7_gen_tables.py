r"""Lane H7 - plain Python (NOT an IDA script). Read-only over the decrypted images.

Builds ida\out\value-tables\b-items.tsv and b-options.tsv for SUB menu groups 9 (APRS),
0xA (SD CARD) and 0xB (OPTION): value-draw dispatchers sub_FFF057FF (jump table FFF48262,
31 x s16, base = bra.l FFF05846), sub_FFF07E49 and sub_FFF08201 (compare chains).
Per-case semantics were read from the H7 linear listings (h7_g9a.txt, h7_g9b.txt,
h7_gab.txt, h7_misc.txt) produced by ida\jobs\h7_dump.py on private DB H7_SUB; every
string table below is decoded here from the image bytes. MAIN links come from
h7_main_senders.tsv (h7_main_senders.py).

    python "ida/jobs/h7_gen_tables.py"
"""
import sys
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root
import os, re, struct, unicodedata

ROOT = str(_REPO)
OUT = os.path.join(ROOT, r"ida\out\value-tables")
S = sys.exit("The firmware image is not in this repository.")
SB = 0xFFC00000


def b(a, n=1):
    return S[a - SB:a - SB + n]


def u16le(a):
    return struct.unpack("<H", b(a, 2))[0]


def u32(a):
    return struct.unpack("<I", b(a, 4))[0]


# ---- text decoding (sub_FFEFA7E7 model, font record 13 single-byte repertoire) ----
VOICED = "ヴガギグゲゴザジズゼゾダヂヅデドバビブベボパピプペポ"


def sb(c):
    if 0xA1 <= c <= 0xDE:
        return unicodedata.normalize("NFKC", bytes([c]).decode("cp932"))
    if c == 0xDF:
        return "°"          # JIS X 0201 handakuten glyph, used as degree sign ("\xdfC", "\xdfF")
    if 0xE0 <= c <= 0xF9:
        return VOICED[c - 0xE0]
    if c == 0xFF:
        return " "
    if 0x20 <= c < 0x7F:
        return chr(c)
    return "<%02X>" % c


def txt(raw, mask=0):
    out, i = "", 0
    while i <= 15 and i < len(raw) and raw[i] != 0:
        bit = (mask >> (15 - i)) & 1
        if bit and i == 15:
            break
        if bit:
            c = (raw[i] << 8) | raw[i + 1]
            if c == 0xFFFF:
                c = 0x2121
            try:
                out += bytes([(c >> 8) | 0x80, (c & 0xFF) | 0x80]).decode("euc_jp")
            except Exception:
                out += "<%04X>" % c
            i += 2
        else:
            out += sb(raw[i])
            i += 1
    return re.sub(r"(?<=[\u30A0-\u30FF])-", "ー", out)


def s(a, n=16, mask=0):
    return txt(b(a, n + 1), mask)


def table(a, count, stride=16, masks=None):
    return [(a + stride * i, s(a + stride * i, stride, masks[i] if masks else 0), masks[i] if masks else 0)
            for i in range(count)]


OFF, ON = 0xFFF486DD, 0xFFF48787

# ---- MAIN sender rows -----------------------------------------------------------
SEND = {}
for ln in open(os.path.join(OUT, "h7_main_senders.tsv"), encoding="utf-8"):
    p = ln.rstrip("\n").split("\t")
    if p[0].startswith("F3"):
        SEND.setdefault(p[0], []).append(p)


def main_of(code):
    rows = SEND.get("F3%02X" % code)
    if not rows:
        return "-", "-", "-"
    r = rows[0]
    site = ",".join(x[1] for x in rows)
    ram = r[5]
    link = r[8]
    # compact the settings link: unique ram -> region/n/eeprom/backup/default
    seen, parts = set(), []
    for m in re.finditer(r"@(FF[0-9A-F]{4})[^>]*-> (R\d n=0x[0-9A-F]+ EEPROM 0x[0-9A-F]+ BACKUP 0x[0-9A-F]+(?: default=0x[0-9A-F]+)?)", link):
        if m.group(1) not in seen:
            seen.add(m.group(1))
            parts.append("%s=%s" % (m.group(1), m.group(2)))
    return "stub %s (mov.w #F3%02X at %s)" % (r[2], code, site), ram, "; ".join(parts) or "-"


# ---- SUB group-9 store handler (jump table FFF4819C, base bra.l FFEFFED5) --------
def store9(code):
    t = (0xFFEFFED5 + struct.unpack("<h", b(0xFFF4819C + 2 * (code - 0xA0), 2))[0]) & 0xFFFFFFFF
    if t == 0xFFF000AB:
        return t, "none (rts)"
    if t == 0xFFEFFED7:
        return t, "1 B (+0x20), compare+copy FFEFFF01 c5 fe 20 20"
    raw = b(t, 0x24)
    i = raw.find(bytes([0x71, 0xEE]))
    if i >= 0:
        n = raw[i + 2] - 0x20
    else:
        i = raw.find(bytes([0x72, 0xEE]))
        n = struct.unpack("<H", raw[i + 2:i + 4])[0] - 0x20
    return t, "%d B (+0x20..+0x%02X) via sub_FFEF208D(0x8C6D,0x8E66,len) at %08X" % (n, 0x20 + n - 1, t)


def jt9(code):
    return (0xFFF05846 + struct.unpack("<h", b(0xFFF48262 + 2 * (code - 0xA0), 2))[0]) & 0xFFFFFFFF


# ---- labels -------------------------------------------------------------------
def grp_row(code):
    hi, lo = code >> 4, code & 0xF
    if hi == 0xA:
        return 9, lo
    if hi == 0xB:
        if lo <= 2:
            return 9, (0x10 if lo == 0 else 0x11)
        if lo <= 9:
            return 9, lo + 0xE
        if lo <= 0xE:
            return 9, lo + 0xD
        return 9, 0
    if hi == 0xC:
        return 0xA, (lo if lo <= 1 else (2 if lo == 4 else 0))
    if hi == 0xD:
        return 0xB, {0: 0, 1: 0x29, 2: 1, 3: 2, 4: 3}.get(lo, 0)


def en_label(g, r):
    cnt = b(0xFFED74E8 + 8 * g)[0]
    p = u32(0xFFED74E8 + 8 * g + 4)
    if r >= cnt:
        return "-", "(row %d >= count %d; no label)" % (r, cnt)
    return "%08X" % (p + 20 * r), b(p + 20 * r, 20).split(b"\0")[0].decode("latin-1")


JP = {}
for ln in open(os.path.join(OUT, "jp-labels.tsv"), encoding="utf-8"):
    p = ln.rstrip("\n").split("\t")
    if p[0].startswith("0x"):
        JP[(int(p[0], 16), int(p[1]))] = p[8]

# ---- per-code semantics (read from listings; addresses are the instruction sites) --
opts = []      # rows for b-options.tsv


def opt(code, field, idx, en, jp="", addr_en="", addr_jp="", mask="", site="", st="C"):
    opts.append(["F3%02X" % code, field, str(idx), en, jp, addr_en, addr_jp, mask, site, st])


def offon(code, field, site, jp_off="", jp_on=""):
    opt(code, field, 0, "OFF", "", "%08X" % OFF, "", "", site)
    opt(code, field, "1..255", "ON", "", "%08X" % ON, "", "", site)


ITEMS = {}

# A0 / A7  OFF/ON
for c, site in ((0xA0, "FFF0584C cmp #0 / FFF0585C OFF / FFF0586E ON"), (0xA7, "same body FFF05848 (jump-table entries A0 and A7 equal)")):
    offon(c, "+0x20", site)
    ITEMS[c] = ("+0x20", "0 -> OFF (FFF486DD), else ON (FFF48787); cursor icon FFECFDCC", "C")

ITEMS[0xA1] = ("none", "fixed text 'MODEL CODE : APY03D' (FFF4995F, sub_FFEF1B23 len 0x13 at FFF058B0); no value field", "C")
opt(0xA1, "-", "-", s(0xFFF4995F, 20), "", "FFF4995F", "", "", "FFF05898 mov.l #FFF4995F,r1; FFF058A3 len #13h")

# A2 APRS FILTER
for i, (a, t, _) in enumerate(table(0xFFF49973, 8)):
    opt(0xA2, "row label %d" % i, i, t, "", "%08X" % a, "", "", "FFF058DE smovf 0x80 from FFF49973")
offon(0xA2, "+0x23+row", "FFF0595D movu.b 23h[r14+row]; OFF FFF0596A / ON FFF0597D")
ITEMS[0xA2] = ("+0x21 top row, +0x22 cursor (clamp 8, FFF058CF), +0x23..+0x2A per-row",
               "8-row list (labels FFF49973, 8x16) each OFF/ON; rows wrap mod 8 (FFF05914); 5 rows visible", "C")

# A3 APRS MODEM
opt(0xA3, "+0x20", 0, "OFF", "", "FFF486DD", "", "", "FFF05A01 cmp #0")
opt(0xA3, "+0x20", 1, s(0xFFF499F3), "", "FFF499F3", "", "", "FFF05A1F cmp #1")
opt(0xA3, "+0x20", "2..255", s(0xFFF499FB), "", "FFF499FB", "", "", "FFF05A41")
ITEMS[0xA3] = ("+0x20", "0 OFF, 1 1200bps, else 9600bps", "C")

# A4 APRS MSG FLASH (sub_FFF05387: EN table FFF493C0, JP table FFF491B0 with value-dependent masks)
def a4mask(v):
    if v == 0: return 0
    if v <= 4: return 0x4000
    if v <= 8: return 0x2000
    if v == 9: return 0xA000
    if v <= 0x11: return 0x9000
    if v <= 0x16: return 0x8800
    if v <= 0x1F: return 0x9000
    return 0x8800
for v in range(33):
    opt(0xA4, "+0x22 MSG / +0x23 GRP / +0x24 BLN", v, s(0xFFF493C0 + 16 * v), s(0xFFF491B0 + 16 * v, 16, a4mask(v)),
        "%08X" % (0xFFF493C0 + 16 * v), "%08X" % (0xFFF491B0 + 16 * v), "%04X" % a4mask(v),
        "sub_FFF05387: [0x8F72]==0 -> FFF491B0 + mask ladder FFF053B9..FFF05428; else FFF493C0 (FFF05453)")
ITEMS[0xA4] = ("+0x21 cursor, +0x22 MSG (clamp 0x20, FFF05A8C), +0x23 GRP (clamp 9, FFF05AD2), +0x24 BLN (clamp 9, FFF05B16)",
               "three rows 'MSG :'/'GRP :'/'BLN :' (FFF49A03/09/0F); value text = 33-entry table (OFF, then alert-pattern names) drawn by sub_FFF05387", "C")

# A5 / A6 lists
ITEMS[0xA5] = ("+0x20 sel, +0x21 top, +0x22+9*i (6 x 9-char names)",
               "6 group-name slots copied to 0x12-byte list records (sub_FFEFB268 len 9 at FFF05BFC) and drawn by list widget sub_FFF03652(sel,top,5,list) + scroll bar sub_FFEFAA2B; empty slot when first byte is 0xDE-relative test FFF05BE4", "C")
ITEMS[0xA6] = ("+0x20 sel, +0x21 top, +0x22+16*i (5 x 16-char texts)",
               "5 message-text slots (sub_FFEFB268 len 0x10 at FFF05CAB) in list widget sub_FFF03652(sel,top,1,list)", "C")
opt(0xA5, "+0x22+9*i", "i=0..5", "(user text, 9 chars)", "", "", "", "", "FFF05BEF..FFF05BFC")
opt(0xA6, "+0x22+16*i", "i=0..4", "(user text, 16 chars)", "", "", "", "", "FFF05C8F..FFF05CAB")

# A8 APRS POPUP (sub_FFF0547A)
for i, (a, t, _) in enumerate(table(0xFFF495D0, 16)):
    opt(0xA8, "row label %d" % i, i, t, "", "%08X" % a, "", "", "FFF054AD smovf 0x100 from FFF495D0")
pm = [struct.unpack("<H", b(0xFFF49800 + 2 * v, 2))[0] for v in range(19)]
for v in range(19):
    opt(0xA8, "+0x23+row", v, s(0xFFF49826 + 16 * v), s(0xFFF496D0 + 16 * v, 16, pm[v]),
        "%08X" % (0xFFF49826 + 16 * v), "%08X" % (0xFFF496D0 + 16 * v), "%04X" % pm[v],
        "FFF0556E [0x8F72]==0 -> JP table FFF496D0, mask u16 FFF49800[v] (FFF0558A movu.w [r2,r14]); else FFF49826")
ITEMS[0xA8] = ("+0x20 focus, +0x21 top, +0x22 cursor (clamp 0x10), +0x23..+0x32 per-row",
               "16-row list (labels FFF495D0) each with a 19-entry value table (EN FFF49826 / JP FFF496D0 + per-value masks FFF49800)", "C")

# A9 APRS RINGER
for i, (a, t, _) in enumerate(table(0xFFF49A15, 18)):
    opt(0xA9, "row label %d" % i, i, t, "", "%08X" % a, "", "", "FFF05D2E smovf 0x120 from FFF49A15")
offon(0xA9, "+0x23+row", "FFF05DB0 movu.b 23h[r14+row]; OFF FFF05DBD / ON FFF05DD0")
ITEMS[0xA9] = ("+0x21 top, +0x22 cursor (clamp 0x12, FFF05D1E), +0x23..+0x34 per-row",
               "18-row list (labels FFF49A15) each OFF/ON", "C")

# AA APRS UNIT
for i, (a, t, _) in enumerate(table(0xFFF49B35, 7)):
    opt(0xAA, "row label %d" % i, i, t, "", "%08X" % a, "", "", "FFF05E79 smovf 0x70 from FFF49B35")
for row, pairs, site in ((0, ((0, 0xFFF49BA5), ("1..", 0xFFF49BAC)), "FFF05F14"),
                         (1, ((0, 0xFFF49BB3), ("1..", 0xFFF49BB6)), "FFF05F51"),
                         (2, ((0, 0xFFF49BBB), (1, 0xFFF49BC0), ("2..", 0xFFF49BC5)), "FFF05F8E"),
                         (3, ((0, 0xFFF49BC9), ("1..", 0xFFF49BCB)), "FFF05FF2"),
                         (4, ((0, 0xFFF49BCE), ("1..", 0xFFF49BD1)), "FFF0602F"),
                         (5, ((0, 0xFFF49BD4), ("1..", 0xFFF49BD7)), "FFF0606B"),
                         (6, ((0, 0xFFF49BDC), ("1..", 0xFFF49BC5)), "FFF060A6")):
    for v, a in pairs:
        opt(0xAA, "+0x23+%d (%s)" % (row, s(0xFFF49B35 + 16 * row)), v, s(a, 8), "", "%08X" % a, "", "", site)
ITEMS[0xAA] = ("+0x21 top, +0x22 cursor (clamp 7, FFF05E6A), +0x23..+0x29 per-row",
               "7 unit rows: POSITION MM.MM'/MM'SS\", DISTANCE km/mile, SPEED km/h/knot/mph, ALTITUDE m/ft, TEMP °C/°F, RAIN mm/inch, WIND m/s/mph", "C")

# AB APRS TX DELAY
for i, (a, t, _) in enumerate(table(0xFFF49BE0, 9)):
    opt(0xAB, "+0x20", i, t, "", "%08X" % a, "", "", "FFF0615A smovf 0x90; FFF0616A cmp #9 clamp 8")
ITEMS[0xAB] = ("+0x20 (clamp 8)", "9-entry delay table FFF49BE0", "C")

# AC BEACON INFO
opt(0xAC, "+0x22 AMBIGUITY", 0, "OFF", "", "FFF486DD", "", "", "FFF061DE cmp #0")
for n in range(1, 5):
    opt(0xAC, "+0x22 AMBIGUITY", n if n < 4 else "4..255", "%d%s" % (n, s(0xFFF49C7B, 8)[1:]), "", "FFF49C7B", "", "",
        "FFF061F8 template '  digit'; FFF0623B add #30h (>4 -> '4' FFF06243)")
offon(0xAC, "+0x23 SPD/CSE", "FFF06273 / FFF06280 / FFF06293")
offon(0xAC, "+0x24 ALTITUDE", "FFF062BB / FFF062C8 / FFF062DB")
ITEMS[0xAC] = ("+0x21 cursor (clamp 2), +0x22 AMBIGUITY, +0x23 SPD/CSE, +0x24 ALTITUDE",
               "AMBIGUITY OFF / 'n digit' (1..4); SPD/CSE OFF/ON; ALTITUDE OFF/ON", "C")

# AD BEACON INTERVAL
for i in range(20):
    ae, aj = 0xFFF49DD9 + 16 * i, 0xFFF49C99 + 16 * i
    opt(0xAD, "+0x20", i, s(ae), s(aj, 16, 0x2000), "%08X" % ae, "%08X" % aj, "2000",
        "FFF0635E cmp #14h clamp 13h; FFF0636C [0x8F72]==0 -> JP table, FFF06390 mov.l #2000h,r3")
ITEMS[0xAD] = ("+0x20 (clamp 0x13)", "20-entry interval table EN FFF49DD9 / JP FFF49C99 (mask 0x2000 = byte 2 is a JIS kanji, '秒'/'分')", "C")

# AE BEACON STATUS TEXT
offon(0xAE, "+0x22 S.TXT", "FFF063F8 / FFF0640B / FFF0641E")
for n in range(8):
    opt(0xAE, "+0x23 TX RATE", n if n < 7 else "7..255", "1/%d" % (n + 1), "", "FFF49F2B", "", "", "FFF06440 template '1/ '; FFF0646F add #31h (>7 -> '8')")
for n in range(5):
    opt(0xAE, "+0x24 TEXT", n if n < 4 else "4..255", "Text %d" % (n + 1), "", "FFF49F38", "", "", "FFF0649F template 'Text  '; FFF064DD add #31h (>4 -> '5')")
ITEMS[0xAE] = ("+0x21 cursor (clamp 2), +0x22 S.TXT, +0x23 TX RATE, +0x24 TEXT slot",
               "S.TXT OFF/ON; TX RATE 1/1..1/8; TEXT 'Text 1'..'Text 5'; PUSH/DISP hint when +0x20==1 and cursor==2", "C")

# AF BEACON TX
opt(0xAF, "+0x20", 0, s(0xFFF48A69), "", "FFF48A69", "", "", "FFF065DF")
opt(0xAF, "+0x20", 1, s(0xFFF4883A), "", "FFF4883A", "", "", "FFF065FD; icon FFED31CC")
opt(0xAF, "+0x20", "2..255", s(0xFFF49F3F), "", "FFF49F3F", "", "", "FFF06630; icon FFED31DC")
ITEMS[0xAF] = ("+0x20", "0 MANUAL, 1 AUTO, else SMART", "C")

# B0 COM PORT SETTING
lab = table(0xFFF49F45, 10)
for i, (a, t, _) in enumerate(lab):
    opt(0xB0, "row label %d" % i, i, t, "", "%08X" % a, "", "", "FFF0668C smovf 0xA0 from FFF49F45")
offon(0xB0, "+0x23 (row 0 %s)" % lab[0][1], "FFF06728")
for i, (a, t, _) in enumerate(table(0xFFF49FE5, 4)):
    opt(0xB0, "+0x24 (row 1 %s)" % lab[1][1], i if i < 3 else "3..255", t, "", "%08X" % a, "", "", "FFF067DF smovf 0x40; FFF067FE cmp #4 clamp 3")
opt(0xB0, "+0x25 (row 2 %s)" % lab[2][1], 0, "OFF", "", "FFF486DD", "", "", "FFF06830")
opt(0xB0, "+0x25 (row 2 %s)" % lab[2][1], "1..255", s(0xFFF4A025), "", "FFF4A025", "", "", "FFF0684E")
for i, (a, t, _) in enumerate(table(0xFFF4A029, 6)):
    opt(0xB0, "+0x26 (row 3 %s)" % lab[3][1], i, t, "", "%08X" % a, "", "", "FFF06863 smovf 0x60; FFF06882 cmp #6 (>=6 -> 0)")
for v in range(4):
    opt(0xB0, "+0x27 (row 4 %s)" % lab[4][1], v, "NMEA%c" % (0x36 + v), "", "FFF4A089", "", "", "FFF068A7 template 'NMEA '; FFF068D7 add #36h ('6'+v)")
for r in range(5, 10):
    offon(0xB0, "+0x%02X (row %d %s)" % (0x23 + r, r, lab[r][1]), "FFF068F1")
ITEMS[0xB0] = ("+0x20 focus, +0x21 top, +0x22 cursor (clamp 10), +0x23..+0x2C per-row",
               "10 rows (labels FFF49F45): row 0 OFF/ON, row 1 4-entry table FFF49FE5, row 2 OFF/GPS, row 3 6-entry table FFF4A029, row 4 NMEA6..NMEA9, rows 5-9 OFF/ON", "C")

# B1 DIGI PATH select grid
for i in range(8):
    opt(0xB1, "+0x20", i, "P%d (cell %d)" % (i + 1, i), "", "FFF4A08F", "", "", "FFF069CF cmp #8 clamp 7; FFF06A52 template 'P '; FFF06A71 add #31h")
ITEMS[0xB1] = ("+0x20 (clamp 7)", "2x4 grid of path slots P1..P8; selected cell framed (sub_FFEF1C48 / sub_FFF088FC)", "C")

# B2 DIGI PATH address edit
opt(0xB2, "+0x20..+0x29", "-", "(10-char title)", "", "", "", "", "FFF06AB9..FFF06AD0 sub_FFEF1B23 len 0Ah")
opt(0xB2, "+0x2D+10*i / +0x2E+10*i", "i=0..3", "'Address'+digit, 9-char callsign when +0x2D+10*i != 0; none -> OFF", "", "", "", "", "FFF06AEE 'Addr' 'ess ' immediates; FFF06B17; FFF06BC2 OFF")
ITEMS[0xB2] = ("+0x20..+0x29 title, +0x2A edit flag, +0x2B/+0x2C cursor/base, +0x2D.. 4 x 10-byte address records",
               "+0x2A==0: up to 2 'AddressN' lines with 9-char callsigns; +0x2A!=0: 8-slot address editor sub_FFF05622(+0x2B,+0x2C,&+0x2D)", "C")

ITEMS[0xB3] = ("none", "jump-table entry = FFF07E44 (no draw); IPC routes F3B3 to screen 0x20 (G3)", "C")
ITEMS[0xB8] = ("none", "jump-table entry = FFF07E44 (no draw); IPC routes F3B8 to screen 0x20 (G3)", "C")

# B4 GPS SETUP
opt(0xB4, "+0x22 DATUM", 0, s(0xFFF4A0A5), "", "FFF4A0A5", "", "", "FFF06C49 cmp #0")
opt(0xB4, "+0x22 DATUM", 1, "(nothing drawn)", "", "", "", "", "FFF06C4B bne FFF06C90 skips value 1", "C")
opt(0xB4, "+0x22 DATUM", 2, s(0xFFF4A0AC) + " " + s(0xFFF4A0B2), "", "FFF4A0AC/FFF4A0B2", "", "", "FFF06C45 cmp #2 -> FFF06C63")
offon(0xB4, "+0x23 PINNING", "FFF06CA3")
offon(0xB4, "+0x24 DGPS", "FFF06CEB")
ITEMS[0xB4] = ("+0x21 cursor (mod 3, FFF06C10 divu #3), +0x22 DATUM, +0x23 PINNING, +0x24 DGPS",
               "DATUM 0 WGS-84 / 2 Tokyo (Mean) / 1 blank; PINNING OFF/ON; DGPS OFF/ON", "C")

# B5 / B6
opt(0xB5, "+0x20", 0, s(0xFFF4A0CD), "", "FFF4A0CD", "", "", "FFF06D87")
opt(0xB5, "+0x20", "1..255", s(0xFFF4A0D5), "", "FFF4A0D5", "", "", "FFF06DA9")
ITEMS[0xB5] = ("+0x20", "0 GPS OFF, else GPS ON", "C")
opt(0xB6, "+0x20", 0, "AUTO", "", "FFF4883A", "", "", "FFF06DD5")
opt(0xB6, "+0x20", "1..255", "MANUAL", "", "FFF48A69", "", "", "FFF06DF7")
ITEMS[0xB6] = ("+0x20", "0 AUTO, else MANUAL", "C")

# B7 GPS UNIT
opt(0xB7, "+0x22 POSITION", 0, s(0xFFF4A0E7), "", "FFF4A0E7", "", "", "FFF06E5A")
opt(0xB7, "+0x22 POSITION", "1..255", s(0xFFF4A0ED), "", "FFF4A0ED", "", "", "FFF06E7C")
for v, a in ((0, 0xFFF49BBB), (1, 0xFFF49BC0), ("2..255", 0xFFF49BC5)):
    opt(0xB7, "+0x23 SPEED", v, s(a), "", "%08X" % a, "", "", "FFF06EA4/FFF06EC6")
for v, a in ((0, 0xFFF49BC9), ("1..255", 0xFFF49BCB)):
    opt(0xB7, "+0x24 ALTITUDE", v, s(a), "", "%08X" % a, "", "", "FFF06F0E")
ITEMS[0xB7] = ("+0x21 cursor (clamp 2), +0x22 POSITION, +0x23 SPEED, +0x24 ALTITUDE",
               "POSITION .MMM' / 'SS\"; SPEED km/h/knot/mph; ALTITUDE m/ft", "C")

# B9 MY POSITION select
opt(0xB9, "+0x20", 0, "GPS", "", "FFF4A025", "", "", "FFF07055 cell 0")
opt(0xB9, "+0x20", 1, "Manual", "", "FFF4A100", "", "", "FFF07067 cell 1")
for i in range(1, 10):
    opt(0xB9, "+0x20", i + 1, "P%d" % i, "", "FFF4A0FD", "", "", "FFF07080 add #30h, cell i+1")
opt(0xB9, "+0x20", 11, "P10", "", "FFF4A107", "", "", "FFF070C9 cell 11")
ITEMS[0xB9] = ("+0x20 (clamp 0x0B)", "3x4 grid: GPS, Manual, P1..P9, P10; selected cell framed", "C")

ITEMS[0xBA] = ("+0x21 slot (Manual / P1..P10, cmp #4/#0Ah at FFF07147..FFF07159), +0x22..+0x30 LAT/LON digits, hemisphere, cursor",
               "manual position editor: title 'Manual:'/'P10:'/'P n:' (FFF4A170/78/7D), 'LAT' DD°MM.MM' N/S and 'LON' DDD°MM.MM' E/W from templates FFF4A10B/FFF4A118, '-' placeholders when unset (FFF071DE..)", "C")
opt(0xBA, "+0x22.. hemisphere", "0/1/other", "N / S / ' '", "", "", "", "", "FFF07224 #4Eh / FFF0722B #53h / FFF07231 #20h")
opt(0xBA, "+0x2A.. hemisphere", "0/1/other", "E / W / ' '", "", "", "", "", "FFF0744D #45h / FFF07454 #57h / FFF0745A #20h")

ITEMS[0xBB] = ("+0x20 icon slot (cmp #3/#1/#2/#0 FFF0778B..), +0x21 symbol table char, +0x22..+0x31 16-char text, +0x34/+0x35 overlay",
               "MY SYMBOL: four slots labelled '1'..'4' (FFF4A19C..A2), '(User)' tag (FFF4A190, both language branches FFF0771B), 'ICON' row, symbol-table/overlay characters with '\\\\' marker (FFF4A1A4), symbol sprites from RAM 0x68584/0x68658", "C")

for i, (a, t, _) in enumerate(table(0xFFF4A1A6, 15)):
    opt(0xBC, "+0x20", i if i < 14 else "14..255", t, "", "%08X" % a, "", "", "FFF079DB smovf 0xF0; FFF079EB cmp #0Fh clamp 0Eh")
ITEMS[0xBC] = ("+0x20 (clamp 0x0E)", "15-entry Mic-E/position comment table FFF4A1A6", "C")

# BD SmartBeaconing
bl = table(0xFFF4A296, 8)
for i, (a, t, _) in enumerate(bl):
    opt(0xBD, "row label %d" % i, i, t, "", "%08X" % a, "", "", "FFF07A32 smovf 0x80 from FFF4A296")
for i, (a, t, _) in enumerate(table(0xFFF4A346, 4)):
    opt(0xBD, "+0x23&3 (row 0 STATUS)", i, t, "", "%08X" % a, "", "", "FFF07A56 and #3; FFF07B3A smovf 0x40")
for i, (a, t, _) in enumerate(table(0xFFF4A316, 3)):
    opt(0xBD, "speed unit (rows 1-2), +0x24 mod 3", i, t, "", "%08X" % a, "", "", "FFF07A41 smovf 0x30; FFF07C06 divu #3")
for r, u, a in ((3, "min", 0xFFF4A386), (4, "sec", 0xFFF489B8), (5, "°", 0xFFF4A38A), (6, "(none)", ""), (7, "sec", 0xFFF489B8)):
    opt(0xBD, "row %d %s unit" % (r, bl[r][1]), "-", u, "", ("%08X" % a) if a else "", "", "", "FFF07C34/FFF07C64/FFF07C94/FFF07CC4")
ITEMS[0xBD] = ("+0x20 focus, +0x21 top, +0x22 cursor (mod 8), +0x23 STATUS (&3), +0x24 speed-unit index (mod 3), +0x24+row values for rows 1-7 (FFF07AE0..FFF07AFD: index row, +1 when row!=0)",
               "8 rows (STATUS, LOW SPD, HIGH SPD, SLOW RATE, FAST RATE, TURN ANGL, TURN SLOP, TURN TIME); STATUS OFF/TYPE1-3; numeric rows via sub_FFEE1FCB with units km/h|knot|mph, min, sec, °; STATUS=OFF hides rows 1-7 and shows PUSH/DISP hint", "C")

# BE TIME ZONE
for v in range(53):
    if v <= 0x19:
        h, sg = 13 - (v + 1) // 2, "-"
    elif v == 0x1A:
        h, sg = 0, " "
    else:
        h, sg = (v - 0x1A) // 2, "+"
    mm = "30" if v & 1 else "00"
    opt(0xBE, "+0x20", v if v < 52 else "52..255", "UTC %s%02d:%s" % (sg, h, mm), "", "FFF4A38C", "", "",
        "FFF07D94 cmp #35h clamp 34h; FFF07DAF cmp #19h; FFF07DBD div #2; FFF07E07 btst #0 -> '0'/'3'")
ITEMS[0xBE] = ("+0x20 (clamp 0x34)", "UTC-13:00 .. UTC+13:00 in 30-min steps (53 values); template 'UTC -  : 0' FFF4A38C", "C")

# Group A
for code in (0xC0, 0xC1, 0xC2):
    for i in range(2):
        ae, aj = 0xFFF4A3F1 + 0x12 * i, 0xFFF4A397 + 0x12 * i
        mk = (b(aj)[0] << 8) | b(aj + 1)[0]
        opt(code, "+0x20 cursor", i, s(ae + 2), s(aj + 2, 16, mk), "%08X" % ae, "%08X" % aj, "%04X" % mk,
            "FFF07E8C [0x8F72]==0 -> FFF4A397 else FFF4A3F1 (0x5A = 5 x 0x12 records {u16 mask BE, 16 chars}); list sub_FFF03652")
ITEMS[0xC0] = ("+0x20 cursor (clamp 2, FFF07E7C)", "two-entry action list: Write to SD / Read from SD (JP SDに書き込み / SDから読み込み)", "C")
ITEMS[0xC1] = ITEMS[0xC0]
ITEMS[0xC2] = ("+0x20 cursor", "same list path as C0/C1 (FFF07E6E add #-0C0h; cmp #1 bleu); no label row (sub_FFF09396 default 0)", "C")
ITEMS[0xC3] = ("none drawn; store latches +0x20 and 4 x 0x13-byte records (+0x21,+0x22,+0x33 flags, +0x23 16 chars) at FFF000F6",
               "draw = soft-key icons only (FFF07EE9 bsr sub_FFF005A9 -> FFF0066B); label suppressed (FFF0054F cmp #0C3h)", "C")
ITEMS[0xC4] = ("none from frame; values from sub_FFF12B18 (SD statistics)",
               "MEMORY INFO: usage bar = used/total * 276.0 px (FFF07F30 fdiv, FFF07F3D fmul #438A0000h), 'Used space'/'Free space'/'Capacity' + 'MB' with ',' grouping (sub_FFEE1E8D); JP labels at FFF4A44E/57/60", "C")
for a, en_a, mk in ((0xFFF4A44E, 0xFFF4A465, 0xAA00), (0xFFF4A457, 0xFFF4A470, 0xAA00), (0xFFF4A460, 0xFFF4A47B, 0xA000)):
    opt(0xC4, "label", "-", s(en_a), s(a, 16, mk), "%08X" % en_a, "%08X" % a, "%04X" % mk, "FFF080B9 [0x8F72]==0 -> JP (FFF08126/3B/50), else EN (FFF081C7/D9/EB)")
opt(0xC4, "unit", "-", "MB", "", "FFF4A44B", "", "", "FFF07FB5")

# Group B
opt(0xD0, "label", "-", s(0xFFF4A48D), s(0xFFF4A484, 16, 0xA800), "FFF4A48D", "FFF4A484", "A800", "FFF08250 [0x8F72]==0 -> FFF08264")
opt(0xD0, "label", "-", s(0xFFF4A4AF), s(0xFFF4A4A6, 16, 0xA000), "FFF4A4AF", "FFF4A4A6", "A000", "FFF082BF -> FFF082D3")
opt(0xD0, "label", "-", s(0xFFF4A4B8), "", "FFF4A4B8", "", "", "FFF08351 (English only)")
opt(0xD0, "+0x22 SIZE", 0, s(0xFFF4A496), "", "FFF4A496", "", "", "FFF0828E")
opt(0xD0, "+0x22 SIZE", "1..255", s(0xFFF4A49E), "", "FFF4A49E", "", "", "FFF082AC")
for v, a in ((0, 0xFFF48982), (1, 0xFFF48A4D), ("2..255", 0xFFF48986)):
    opt(0xD0, "+0x23 QUALITY", v, s(a), "", "%08X" % a, "", "", "FFF082FD/FFF0831C")
opt(0xD0, "+0x24 SP SEL", 0, s(0xFFF4A4C1), "", "FFF4A4C1", "", "", "FFF08366")
opt(0xD0, "+0x24 SP SEL", "1..255", s(0xFFF4A4C8), "", "FFF4A4C8", "", "", "FFF08384")
ITEMS[0xD0] = ("+0x21 cursor (clamp 2), +0x22 SIZE, +0x23 QUALITY, +0x24 SP SEL",
               "SIZE 320*240/160*120; QUALITY LOW/NORMAL/HIGH; SP SEL CAMERA/INT SP", "C")
offon(0xD2, "+0x20 (clamp 1)", "FFF08424 / FFF08439 / FFF0844C")
for v, en_a, jp_a, mk, site in ((0, 0xFFF4A4E6, 0xFFF4A4CF, 0xAA00, "FFF084DB / JP FFF0847F"),
                                ("1..2", 0xFFF4A4F0, 0xFFF4A4D8, 0xA800, "FFF084F0 / JP FFF08496"),
                                (3, 0xFFF4A4FE, 0xFFF4A4DF, 0xA800, "FFF08519 / JP FFF084B6 (only if sub_FFEF02F2()!=0)")):
    opt(0xD2, "+0x21 link status", v, s(en_a), s(jp_a, 16, mk), "%08X" % en_a, "%08X" % jp_a, "%04X" % mk, site)
opt(0xD2, "+0x22..+0x31", "-", "(16-char device name)", "", "", "", "", "FFF08538 sub_FFEF1B23 len 10h")
ITEMS[0xD2] = ("+0x20 OFF/ON (clamp 1), +0x21 link status, +0x22..+0x31 device name",
               "OFF/ON; when ON: Connected / Not Connected / Connecting + device name; 6 help lines from RAM pointer table 0x69248 (sub_FFEF68D5)", "C")
ITEMS[0xD3] = ("+0x20 device count/sel, +0x21 cursor, +0x22+16*i names (5), flag byte tested with btst (FFF0869F)",
               "DEVICE LIST: 11 help lines from RAM pointer table 0x690F8; up to 5 paired-device names in a framed list; label suppressed (FFF00561 cmp #0D3h)", "C")
opt(0xD3, "+0x22+16*i", "i=0..4", "(16-char device name)", "", "", "", "", "FFF08686 shll #4; FFF086BD/FFF086D7")
offon(0xD4, "+0x20", "FFF0874B / FFF08757 / FFF08769")
ITEMS[0xD4] = ("+0x20", "OFF/ON", "C")
ITEMS[0xD1] = ("n/a", "not dispatched by sub_FFF08201 (falls to rtsd FFF0878A); IPC routes F3D1 to screen 0x21 (G3)", "C")

# ---- b-items.tsv --------------------------------------------------------------------
DRAW = {9: "sub_FFF057FF", 0xA: "sub_FFF07E49", 0xB: "sub_FFF08201"}
CASEA = {0xC0: "FFF07E79", 0xC1: "FFF07E79", 0xC2: "FFF07E79", 0xC3: "FFF07EE9", 0xC4: "FFF07EEE"}
CASEB = {0xD0: "FFF0823D", 0xD1: "-", 0xD2: "FFF083D6", 0xD3: "FFF0856F", 0xD4: "FFF08749"}
STOREA = {0xC0: "1 B (+0x20) FFF000F0", 0xC1: "1 B (+0x20) FFF000F0", 0xC2: "1 B (+0x20) FFF000F0",
          0xC3: "+0x20 + 4 x 0x13 B records (FFF000F6..FFF0021C)", 0xC4: "none (bleu range C0..C2 only)"}
STOREB = {0xD0: "+0x20,+0x21 then +0x22..+0x24 (FFF00242..FFF002E9)", 0xD1: "-", 0xD2: "+0x21.. (FFF002EC..)", 0xD3: "list records (FFF003B0..)", 0xD4: "1 B (+0x20) FFF0045A"}

hdr = ["code", "group", "row", "EN_label_addr", "EN_label", "JP_label", "value_draw_case", "frame_fields", "decoded_values",
       "sub_store", "main_sender", "main_ram_refs", "settings_link", "status"]
lines = ["# Lane H7. SUB value-draw tables for menu groups 9 (APRS), 0xA (SD CARD), 0xB (OPTION). Frame = latched IPC copy at 0x8C4D (+0x20.. value bytes, +1 code).",
         "# group/row from sub_FFF092FC/sub_FFF09396 (G3 model); EN label = menu[g].labels+20*row (0xFFED74E8); JP label from jp-labels.tsv; draw case = jump/compare target; status C = instruction/bytes read, I = inferred.",
         "\t".join(hdr)]
codes = list(range(0xA0, 0xBF)) + list(range(0xC0, 0xC5)) + list(range(0xD0, 0xD5))
for c in codes:
    g, r = grp_row(c)
    ea, et = en_label(g, r)
    jl = JP.get((g, r), "-") if ea != "-" else "-"
    if g == 9:
        case = "%08X (jt FFF48262[%d])" % (jt9(c), c - 0xA0)
        st = store9(c)[1]
    elif g == 0xA:
        case, st = CASEA[c], STOREA[c]
    else:
        case, st = CASEB[c], STOREB[c]
    ms, ram, link = main_of(c)
    f, d, status = ITEMS.get(c, ("?", "?", "U"))
    lines.append("\t".join(["F3%02X" % c, "0x%X" % g, str(r), ea, et, jl, case, f, d, st, ms, ram, link, status]))
with open(os.path.join(OUT, "b-items.tsv"), "w", encoding="utf-8", newline="\n") as fh:
    fh.write("\n".join(lines) + "\n")

oh = ["code", "field", "value", "text_EN", "text_JP", "addr_EN", "addr_JP", "jis_mask", "site", "status"]
with open(os.path.join(OUT, "b-options.tsv"), "w", encoding="utf-8", newline="\n") as fh:
    fh.write("# Lane H7. Option strings / formats per item (groups 9, 0xA, 0xB). JP text decoded with the sub_FFEFA7E7 mask model (bit 15-i = byte i is a JIS X 0208 high byte).\n")
    fh.write("\t".join(oh) + "\n")
    for o in opts:
        fh.write("\t".join(str(x) for x in o) + "\n")
print("items", len(lines) - 3, "options", len(opts))
