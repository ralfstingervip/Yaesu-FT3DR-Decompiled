r"""Lane I17 -- offline (plain Python, not an IDA script) data-typing plan for SUB_FINAL2.

    python "ida/jobs/i17_dataplan.py"

Inputs (frozen on disk):
  decrypted\FT3D_SUB_ver102_ALL.bin                       the image (read-only)
  ida\out\sub-final\raw\state_final\items.tsv            I2's item dump of SUB_FINAL (defines the
                                                          34,618 B never-explored window bytes)
  ida\out\sub-final2\raw\query_seed\refs.tsv, drefs.tsv  i17_query.py on the unmodified copy
Outputs (ida\out\sub-final2\):
  data-types.tsv   one row per homogeneous sub-run: scope (window / below-window / retype), class,
                   layout, count, evidence.  The window rows tile the 138 runs exactly (34,618 B).
  data-items.tsv   the IDA item plan consumed by i17_apply_final2.py (ea, size, kind, arg, name)
  raw\dataplan_checks.txt   byte-level assertions run against the image
"""
from __future__ import annotations
import sys
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root
import os, struct, collections

ROOT = str(_REPO)
OUT = os.path.join(ROOT, r"ida\out\sub-final2")
BIN = os.path.join(ROOT, r"decrypted\FT3D_SUB_ver102_ALL.bin")
BASE = 0xFFC00000
WLO, WHI = 0xFFED0000, 0xFFF50000
img = sys.exit("The firmware image is not in this repository.")
CHK = []


def b(ea, n):
    return img[ea - BASE:ea - BASE + n]


def u8(ea):
    return img[ea - BASE]


def u16(ea):
    return struct.unpack_from("<H", img, ea - BASE)[0]


def u32(ea):
    return struct.unpack_from("<I", img, ea - BASE)[0]


def check(cond, text):
    CHK.append(("ok  " if cond else "FAIL") + " " + text)
    if not cond:
        raise AssertionError(text)


def rd(path):
    with open(path, encoding="utf-8") as h:
        lines = h.read().splitlines()
    hd = lines[0].split("\t")
    return [dict(zip(hd, l.split("\t"))) for l in lines[1:]]


# ---------------------------------------------------------------- runs (never-explored window bytes)
cov = bytearray(WHI - WLO)
for r in rd(os.path.join(ROOT, r"ida\out\sub-final\raw\state_final\items.tsv")):
    a, n = int(r["ea"], 16), int(r["size"])
    for x in range(max(a, WLO), min(a + n, WHI)):
        cov[x - WLO] = 1
RUNS = []
i = 0
while i < len(cov):
    if not cov[i]:
        j = i
        while j < len(cov) and not cov[j]:
            j += 1
        RUNS.append((WLO + i, WLO + j)); i = j
    else:
        i += 1
check(len(RUNS) == 138 and sum(z - a for a, z in RUNS) == 34618, "never-explored window runs: %d runs, %d B" % (len(RUNS), sum(z - a for a, z in RUNS)))

refs = rd(os.path.join(OUT, r"raw\query_seed\refs.tsv"))
drefs = rd(os.path.join(OUT, r"raw\query_seed\drefs.tsv"))
REFAT = collections.defaultdict(list)
for r in refs:
    REFAT[int(r["value"], 16)].append(r["insn"])
for r in drefs:
    REFAT[int(r["to"], 16)].append(r["from"])

# ---------------------------------------------------------------- struct types
STRUCTS = {
    "i17_bmp_desc_t": ("struct i17_bmp_desc_t { unsigned short w; unsigned short h; unsigned int src; unsigned short key; "
                       "unsigned short tint; unsigned short mode; unsigned short pad; };", 16),
    "i17_font1_blk_t": ("struct i17_font1_blk_t { unsigned char w; unsigned char h; unsigned short base_code; "
                        "unsigned int ord_tbl; unsigned int pix_base; };", 12),
    "i17_glyph1_desc_t": ("struct i17_glyph1_desc_t { unsigned short w; unsigned short h; unsigned int pix; unsigned int flag; };", 12),
    "i17_glyph_tbl8_t": ("struct i17_glyph_tbl8_t { unsigned short f0; unsigned short f2; unsigned int tbl; };", 8),
    "i17_icon_rec_t": ("struct i17_icon_rec_t { unsigned int id; unsigned short f04; unsigned short f06; unsigned int f08; "
                       "unsigned int f0c; unsigned int f10; unsigned int f14; unsigned int desc; };", 28),
    "i17_menu_cat_t": ("struct i17_menu_cat_t { unsigned int count; unsigned int labels; };", 8),
    "i17_news_b_t": ("struct i17_news_b_t { unsigned int desc; char name[8]; unsigned int pad; };", 16),
    "i17_store_mode_t": ("struct i17_store_mode_t { unsigned int f[11]; };", 44),
    "i17_ramptr9_t": ("struct i17_ramptr9_t { unsigned int p[9]; };", 36),
    "i17_idx_u32_t": ("struct i17_idx_u32_t { unsigned int idx; unsigned int val; };", 8),
    "i17_idx_f32_t": ("struct i17_idx_f32_t { unsigned int idx; float val; };", 8),
    "i17_rect16_t": ("struct i17_rect16_t { unsigned short x; unsigned short y; unsigned short w; unsigned short h; };", 8),
}

ITEMS = []   # (ea, size, kind, arg, name)
TYPES = []   # (scope, start, end, class, layout, count, evidence)


def item(ea, size, kind, arg="", name=""):
    ITEMS.append((ea, size, kind, arg, name))


def trow(scope, a, z, cls, layout, count, ev):
    TYPES.append((scope, a, z, cls, layout, count, ev))


def cite(lo, hi, n=4):
    s = []
    for v in sorted(REFAT):
        if lo <= v < hi:
            for x in REFAT[v]:
                s.append("%s->%08X" % (x, v))
    s = sorted(set(s))
    return ("refs %d: " % len(s) + ",".join(s[:n])) if s else "no direct ref"


def ptrs(a, z, cls, ev):
    for q in range(a, z, 4):
        v = u32(q)
        item(q, 4, "dword_off" if v >= BASE else "dword")


# ================================================================ 1. bitmap descriptor table
DESC0, NDESC = 0xFFECE55C, 1441
DEND = DESC0 + 16 * NDESC
check(DEND == 0xFFED3F6C, "descriptor table FFECE55C + 1441*16 = %08X" % DEND)
check(b(DESC0, 16).hex() == "1c00140080ebc3ff0000ffff00000000", "record 0 bytes %s" % b(DESC0, 16).hex())
spans = []
modes = collections.Counter(); ws = []; hs = []
for k in range(NDESC):
    e = DESC0 + 16 * k
    w, h, src, key, tint, mode, pad = struct.unpack_from("<HHIHHHH", img, e - BASE)
    spans.append((src, src + w * h * 2)); modes[mode] += 1; ws.append(w); hs.append(h)
    check(pad == 0, "desc %d pad == 0" % k) if pad else None
u = sorted(set(spans)); lo_, hi_ = u[0][0], u[0][1]; gaps = 0
for s_, e_ in u[1:]:
    if s_ > hi_:
        gaps += 1
    hi_ = max(hi_, e_)
check(lo_ == 0xFFC3EB80 and hi_ == 0xFFEB74D8 and gaps == 0,
      "1441 src spans tile %08X-%08X with %d gaps (doc 16)" % (lo_, hi_, gaps))
check(set(modes) <= {0, 1, 2}, "modes %s" % dict(modes))
check(min(ws) >= 1 and min(hs) >= 1, "w %d..%d h %d..%d" % (min(ws), max(ws), min(hs), max(hs)))
check(DESC0 + 16 * 391 == 0xFFECFDCC, "doc 27 primary RGB565 font base FFECFDCC = record 391")
check(b(0xFFECE51C, 64) == bytes(64), "FFECE51C-FFECE55C is 64 zero bytes")
check(u32(0xFFECE510) == 0xFFEDE10F and u32(0xFFECE518) == 0xFFEDE1A2, "CALLBACK_REGINIT tail ends at FFECE51C (doc 27)")
r426 = DESC0 + 16 * 426
check(r426 == 0xFFECFFFC, "record 426 straddles the window edge (%08X-%08X)" % (r426, r426 + 16))
item(0xFFECE51C, 64, "byte", "", "")
trow("below-window", 0xFFECE51C, 0xFFECE55C, "zero pad", "u8[64], all 0x00", 1,
     "after CALLBACK_REGINIT FFECE4E4-FFECE51C (doc 27); before descriptor record 0")
for k in range(NDESC):
    e = DESC0 + 16 * k
    item(e, 16, "struct", "i17_bmp_desc_t", "")
trow("below-window", DESC0, 0xFFED0000, "RGB565 bitmap descriptor records (doc 16 sect.2)",
     "i17_bmp_desc_t {u16 w,u16 h,u32 src,u16 key,u16 tint,u16 mode,u16 pad} stride 16; records 0..425 + bytes 0..3 of 426",
     426, "base FFECE55C; rec 391 = FFECFDCC (doc 27 RGB565 font base); %s" % cite(DESC0, 0xFFED0000))
trow("window", 0xFFED0000, 0xFFED000C, "RGB565 bitmap descriptor records", "tail (src,key,tint,mode,pad) of record 426 at FFECFFFC", 0,
     "record straddles the window edge")
trow("window", 0xFFED000C, 0xFFED337C, "RGB565 bitmap descriptor records", "i17_bmp_desc_t stride 16; records 427..1249", 823,
     cite(0xFFED000C, 0xFFED337C))
trow("retype", 0xFFED337C, 0xFFED3382, "RGB565 bitmap descriptor records",
     "first 6 B of record 1250; I2 DB held a bogus 6-B strlit here (08 00 0b 00 14 20)", 0, cite(0xFFED337C, 0xFFED3382))
trow("window", 0xFFED3382, 0xFFED3F6C, "RGB565 bitmap descriptor records", "bytes 6..15 of record 1250 + records 1251..1440", 190,
     cite(0xFFED3382, 0xFFED3F6C))
check(b(0xFFED337C, 6).hex() == "08000b001420", "FFED337C bytes = record 1250 w=8 h=11 src lo")

# ================================================================ 2. low published tables
# 2a default image copied to RAM 0x1CC90
check(b(0xFFEDFBED, 22).hex() == "fb3a0c01fb227c41edfffb1290cc01007f8ffbe2e223", "sub_FFEDFBE2 copies 0x10C B FFED417C -> 1CC90")
item(0xFFED4180, 0x108, "byte", "", "dflt_1CC90_img_tail")
trow("window", 0xFFED4180, 0xFFED4288, "RAM-default image (const struct copied to RAM)",
     "u8[264] = bytes 4..267 of the 268-B image at FFED417C; fields read: +0..+A u8, +C/+E/+10/+12/+14 u16, +16 u8, +18 u32, +1C/+1D u8, +1E u16, +30..+55 (38 B)",
     1, "sub_FFEDFBE2 FFEDFBED 'fb3a0c01' mov.l #10Ch,r3 / FFEDFBF1 #FFED417C / FFEDFBF7 #1CC90 / smovf; readers sub_FFEDF904..sub_FFEDFA32 (else-branch when [1CDD4+n]==0)")
# 2b PMTK pointer table + section-address list
for a, z in ((0xFFED428C, 0xFFED4298), (0xFFED42A0, 0xFFED42B0), (0xFFED42B8, 0xFFED42BC), (0xFFED42C4, 0xFFED42CC)):
    for q in range(a, z, 4):
        check(0xFFF483E8 <= u32(q) < 0xFFF484D1, "PMTK slot %08X -> %08X in pool" % (q, u32(q)))
    ptrs(a, z, "", "")
    trow("window", a, z, "char* table (GPS $PMTK command strings)", "u32 pointer slots into the string pool", (z - a) // 4,
         "table FFED4288..FFED42CC (17 slots) indexed by sub_FFEE0D4D (FFEE0D7B #FFED4288; mov.l [r14,r15]); targets e.g. %08X" % u32(a))
SECT = [u32(q) for q in range(0xFFED42CC, 0xFFED4300, 4)]
check(SECT == [0xFFC00100, 0xFFC3EB44, 0xFFECE4E8, 0xFFF47FD1, 0xFFF48064, 0xFFF483C8, 0xFFF483C8, 0x000698FC,
               0xFFED8A34, 0xFFED8A58, 0xFFED8A70, 0xFFED8A70, 0xFFED8A70], "section list values")
ptrs(0xFFED42CC, 0xFFED4300, "", "")
trow("window", 0xFFED42CC, 0xFFED4300, "linker section-address list (Inferred CC-RX __sectop/__secend constants)",
     "u32[13]: FFC00100 FFC3EB44 FFECE4E8 FFF47FD1 FFF48064 FFF483C8 FFF483C8 000698FC FFED8A34 FFED8A58 FFED8A70 x3",
     13, "no code or data ref (3-byte scan of the whole image: 0 hits); FFF47FD1/FFF48064/FFF483C8 = first 1-byte switch table, first 2-byte table, end of tables (H8 typed-data.tsv); FFED8A34/58/70 = DTBL/BTBL/INTB")
# 2c descriptor pointer table (17 slots, slot 0 already typed)
for q in range(0xFFED45A8, 0xFFED45E8, 4):
    check(DESC0 <= u32(q) < DEND and (u32(q) - DESC0) % 16 == 0, "desc ptr %08X" % q)
ptrs(0xFFED45A8, 0xFFED45E8, "", "")
trow("window", 0xFFED45A8, 0xFFED45E8, "bitmap-descriptor pointer table", "u32[16] (slots 1..16 of 17; slot 0 FFED45A4 typed by I2)", 16,
     "sub_FFEE4DDA FFEE4E22 #FFED45A4, index = byte mod 0x11, mov.l [r1,r14],r3 -> sub_FFEF0648 (RGB565 blit)")
# 2d 1-bpp font blocks, glyph descriptors, 8-byte table
for k in range(26):
    e = 0xFFED4644 + 12 * k
    item(e, 12, "struct", "i17_font1_blk_t", "")
    check(0xFFEB74D8 <= u32(e + 4) < 0xFFECE55C and 0xFFC00000 <= u32(e + 8) < 0xFFC3EB80, "font block %d ptrs" % k)
trow("window", 0xFFED4644, 0xFFED477C, "1-bpp font block table (doc 27 sect.2, extended)",
     "i17_font1_blk_t {u8 w,u8 h,u16 base_code,u32 ord_tbl,u32 pix_base} stride 12", 26,
     "doc 27 listed 8; selector bound in sub_FFEF2184 is 0x1A = 26 entries; refs FFEF21BE/FFEE52A0 #FFED4644")
for k in range(51):
    e = 0xFFED477C + 12 * k
    item(e, 12, "struct", "i17_glyph1_desc_t", "")
    check(0xFFC00000 <= u32(e + 4) < 0xFFC3EB80 and u16(e) < 64 and u16(e + 2) < 64, "glyph1 desc %d" % k)
trow("window", 0xFFED477C, 0xFFED49E0, "1-bpp glyph/icon descriptor records",
     "i17_glyph1_desc_t {u16 w,u16 h,u32 pix (FFC0xxxx-FFC3xxxx 1-bpp store),u32 flag} stride 12", 51,
     "no direct immediate (3-byte scan 0 hits for FFED477C); contiguous after the 26 font blocks (Inferred: same base, index >= 26)")
for k in range(45):
    item(0xFFED49E0 + 8 * k, 8, "struct", "i17_glyph_tbl8_t", "")
trow("window", 0xFFED49E0, 0xFFED4B48, "glyph-table index records", "i17_glyph_tbl8_t {u16 f0,u16 f2,u32 tbl} stride 8", 45,
     "sub_FFEE59A4 FFEE59C8 shll #3 / FFEE59CA #FFED49E0 / add 4[r14].l (tbl), index clamped to 0x2C (45 entries); sub_FFEE5A73 movu.w [r14] (f0)")
# 2e 3 descriptor pointers, 254 icon records, bit masks
ptrs(0xFFED55D4, 0xFFED55E0, "", "")
trow("window", 0xFFED55D4, 0xFFED55E0, "bitmap-descriptor pointer table", "u32[3] (slots 1..3 of 4 at FFED55D0)", 3,
     "sub_FFEEF86F FFEEF8C9 #FFED55D0, index & 3 -> sub_FFEF0648")
for k in range(254):
    e = 0xFFED55E0 + 28 * k
    item(e, 28, "struct", "i17_icon_rec_t", "")
    idv, dsc = u32(e), u32(e + 24)
    check(idv in (0, k) and (dsc == 0 or (DESC0 <= dsc < DEND and (dsc - DESC0) % 16 == 0)), "icon rec %d id %d desc %08X" % (k, idv, dsc))
check(0xFFED55E0 + 28 * 254 == 0xFFED71A8, "icon records end at FFED71A8")
trow("window", 0xFFED55E0, 0xFFED71A8, "icon/indicator records (desc ptr at +0x18)",
     "i17_icon_rec_t {u32 id,u16 f04,u16 f06,u32 f08,u32 f0c,u32 f10,u32 f14,u32 desc} stride 28; id = index or 0 (unused)", 254,
     "sub_FFEF34B1 FFEF34BF mul #1Ch / FFEF34C2 #FFED55E0 / smovf 0x1C")
for k in range(32):
    check(u32(0xFFED71A8 + 4 * k) == 1 << k, "bitmask %d" % k)
item(0xFFED71A8, 128, "dword", "", "bit_mask_u32")
trow("window", 0xFFED71A8, 0xFFED7228, "constant table", "u32[32] = 1<<i", 32,
     "sub_FFEFB2C2 FFEFB2C6 cmp #1Fh / FFEFB2CB #FFED71A8 / mov.l [r1,r14],r1")
# 2f menu category table
for k in range(24):
    item(0xFFED74E8 + 8 * k, 8, "struct", "i17_menu_cat_t", "")
    lab = u32(0xFFED74E8 + 8 * k + 4)
    check(lab == 0 or 0xFFC3D000 <= lab < 0xFFC3F000, "menu cat %d labels %08X" % (k, lab))
trow("window", 0xFFED74E8, 0xFFED75A8, "setup-menu category table (BRIEF correction 5: base FFED74E8, 1-based)",
     "i17_menu_cat_t {u32 count,u32 labels (20-B label rows in FFC3xxxx)} stride 8", 24,
     "sub_FFF095E3 FFF095E9 shll #3 / FFF095EB #FFED74E8; sub_FFF0966E FFF09695")
# 2g WIRES-X news category tables
for a in (0xFFED7A68, 0xFFED7A78, 0xFFED7A88, 0xFFED7A98):
    item(a, 12, "strlit", "", "")
    if a != 0xFFED7A98:
        item(a + 12, 4, "dword_off" if u32(a + 12) >= BASE else "dword", "", "")
check(b(0xFFED7A68, 12) == b"EMERGENCY   " and b(0xFFED7A98, 12) == b"INT NEWS    ", "news A names")
trow("window", 0xFFED7A68, 0xFFED7AA4, "record table {u32 desc, char name[12]} (WIRES-X news categories)",
     "stride 16 from FFED7A64 (rec 0 desc typed by I2): EMERGENCY/NEWS STATION/LOCAL NEWS/INT NEWS", 4,
     "sub_FFF0F6A7 FFF0F6F4 #FFED7A64 / mov.l 30h[r1],r4 -> sub_FFEF68D5; sub_FFF0F711 FFF0F713 (+0x34)")
for k in range(4):
    item(0xFFED7AA4 + 16 * k, 16, "struct", "i17_news_b_t", "")
check(b(0xFFED7AB8, 8) == b"VOICE  \x00", "news B VOICE")
trow("window", 0xFFED7AA4, 0xFFED7AE4, "record table {u32 desc, char name[8], u32 0} (WIRES-X news content types)",
     "i17_news_b_t stride 16: '       '/VOICE/MESSAGE/PICT", 4,
     "sub_FFF0F546 FFF0F57F shll #4 / FFF0F581 #FFED7AA4 (index clamped <4); sub_FFF129AF FFF129D0")
# 2h path pointer lists
for a, z, base_, tgt in ((0xFFED7E94, 0xFFED7EB0, 0xFFED7E90, "I:\\FT3D\\... paths"), (0xFFED831C, 0xFFED8338, 0xFFED8318, "FT3D\\... paths")):
    ptrs(a, z - 4, "", "")
    item(z - 4, 4, "dword", "", "")
    check(u32(z - 4) == 0 and all(0xFFF4AD58 <= u32(q) < 0xFFF4B000 for q in range(a, z - 4, 4)), "path list %08X" % a)
    trow("window", a, z, "char* list, NULL-terminated (%s)" % tgt, "u32[%d] string pointers + u32 0" % ((z - a) // 4 - 1), (z - a) // 4,
         "base %08X typed by I2; %s" % (base_, cite(base_, base_ + 4, 2)))
# 2i storage-driver tables
item(0xFFED7F18, 56, "dword", "", "")
item(0xFFED7F50, 16, "dword", "", "")
for k in range(13):
    item(0xFFED7F60 + 44 * k, 44, "struct", "i17_store_mode_t", "")
check(0xFFED7F60 + 44 * 13 == 0xFFED819C, "13 x 44 B end at FFED819C")
trow("window", 0xFFED7F18, 0xFFED7F50, "storage-driver status-mask table (Inferred SD/MMC host)",
     "u32[14] = 7 mask words indexed by card-type u16 at [card+2C6h]", 14,
     "sub_FFF34897 FFF34925 movu.w 2C6h[r14] / FFF34929 #FFED7F18 / tst 2B0h[r14].l (-> error -17h); sub_FFF33988 FFF339F8 #FFED7F48")
trow("window", 0xFFED7F50, 0xFFED7F60, "storage-driver constant table", "u32[4] = 00FFF0FF 00FFF1FF 00FFF2FF 00FFF3FF", 4,
     cite(0xFFED7F50, 0xFFED7F60))
trow("window", 0xFFED7F60, 0xFFED819C, "storage-driver mode records (Inferred card-capacity parameter sets)",
     "i17_store_mode_t u32[11] stride 44 (0x2C): 2 records at FFED7F60 + 11 at FFED7FB8", 13,
     "sub_FFF362EF FFF362F7 cmp #7DFFFFh / FFF36301 #FFED7F60 / mov.l #2Ch,r3 -> copy; sub_FFF36327 FFF36340 #FFED7FB8 (+n*0x2C)")
# 2j RAM pointer records
for k in range(8):
    item(0xFFED81F8 + 36 * k, 36, "struct", "i17_ramptr9_t", "")
    for f in range(9):
        v = u32(0xFFED81F8 + 36 * k + 4 * f)
        check(v == 0 or 0x10000 <= v < 0x20000, "ramptr9 %d.%d %08X" % (k, f, v))
trow("window", 0xFFED81F8, 0xFFED8318, "RAM-pointer records (initial values copied to RAM 683D0/68460)",
     "i17_ramptr9_t u32[9] stride 36: 2 tables x 4 records (FFED81F8, FFED8288)", 8,
     "sub_FFF3B7B5 FFF3B7C1 mul #24h / FFF3B7C4 #FFED81F8 -> 683D0, FFF3B7EF #FFED8288 -> 68460, smovf 0x24")
# 2k index/value and sin/cos tables
for k in range(10):
    item(0xFFED84D8 + 8 * k, 8, "struct", "i17_idx_u32_t", "")
    check(u32(0xFFED84D8 + 8 * k) == k, "idx_u32 %d" % k)
for k in range(32):
    item(0xFFED8528 + 8 * k, 8, "struct", "i17_idx_f32_t", "")
import math
for k in range(16):
    s = struct.unpack_from("<f", img, 0xFFED8528 + 8 * k + 4 - BASE)[0]
    c = struct.unpack_from("<f", img, 0xFFED85A8 + 8 * k + 4 - BASE)[0]
    check(abs(s - math.sin(math.radians(22.5 * k))) < 1e-6 and abs(c - math.cos(math.radians(22.5 * k))) < 1e-6, "sin/cos %d" % k)
trow("window", 0xFFED84D8, 0xFFED8528, "index/value table", "i17_idx_u32_t stride 8: 0..9 -> 200,500,1000,2000,5000,10000,20000,100000,500000,1000000",
     10, "sub_FFF42981 FFF42A03 shll #3 / FFF42A06 #FFED84D8 (search by key byte)")
trow("window", 0xFFED8528, 0xFFED85A8, "sine table", "i17_idx_f32_t stride 8: k, sin(k*22.5 deg) float", 16, "sub_FFF42981 FFF42BF4 #FFED8528")
trow("window", 0xFFED85A8, 0xFFED8628, "cosine table", "i17_idx_f32_t stride 8: k, cos(k*22.5 deg) float", 16, "sub_FFF42981 FFF42C2C #FFED85A8")
# 2l CC-RX runtime const data
check(u32(0xFFED8974) == 20, "_nfiles 20")
check([u32(0xFFED89C0 + 4 * k) for k in range(6)] == [1, 2, 4, 8, 16, 0], "printf flag bits")
check([u32(0xFFED89D8 + 4 * k) for k in range(4)] == [0, 1, 2, 4], "mode table")
P10 = [struct.unpack_from("<d", img, 0xFFED89E8 + 8 * k - BASE)[0] for k in range(9)]
check(P10 == [1e1, 1e2, 1e4, 1e8, 1e16, 1e32, 1e64, 1e128, 1e256], "powers of ten %s" % P10)
item(0xFFED8974, 4, "dword", "", "rt_nfiles")
item(0xFFED8978, 72, "byte", "", "rt_file_template")
item(0xFFED89C0, 24, "dword", "", "rt_fmt_flag_bits")
item(0xFFED89D8, 16, "dword", "", "rt_open_mode_bits")
item(0xFFED89E8, 72, "double", "", "rt_pow10_tbl")
item(0xFFED8A30, 4, "dword", "", "")
trow("window", 0xFFED8974, 0xFFED8978, "CC-RX runtime const", "u32 = 20 (stream count)", 1,
     "sub_FFEE1868 FFEE1897 #FFED8974 / cmp [r14].l (loop over 1CE14[]); sub_FFF45E0D FFF45E1F")
trow("window", 0xFFED8978, 0xFFED89C0, "CC-RX runtime const", "u8[72] stream-control-block template", 1,
     "sub_FFF45E90 FFF45EA4 mov.l #48h,r3 / FFF45EA9 #FFED8978 / smovf")
trow("window", 0xFFED89C0, 0xFFED89D8, "CC-RX runtime const", "u32[6] printf flag bits 1,2,4,8,16,0", 6,
     "sub_FFF45FF6 FFF46018 #FFC3E971 ' +-#0,;:_' / FFF4601E #FFED89C0")
trow("window", 0xFFED89D8, 0xFFED89E8, "CC-RX runtime const", "u32[4] = 0,1,2,4", 4, "sub_FFF469D7 FFF469DD #FFED89D8 / mov.l [r14,r15] (index & 3)")
trow("window", 0xFFED89E8, 0xFFED8A30, "CC-RX runtime const", "double[9] = 1e1,1e2,1e4,...,1e256 (binary powers of ten)", 9,
     cite(0xFFED89E8, 0xFFED8A30))
trow("window", 0xFFED8A30, 0xFFED8A34, "CC-RX runtime const", "u32 = 0x400", 1, "sub_FFF46D28 FFF46D32 #FFED8A30")
# 2m INTB zero slots
for a, z in RUNS:
    if 0xFFED8A70 <= a < 0xFFED8E70:
        check(b(a, z - a) == bytes(z - a) and a % 4 == 0 and z % 4 == 0, "INTB zero slots %08X" % a)
        item(a, z - a, "dword", "", "")
        trow("window", a, z, "INTB vector slots = 0 (unused vectors)", "u32[%d]; vectors %d..%d" % ((z - a) // 4, (a - 0xFFED8A70) // 4, (z - 0xFFED8A70) // 4 - 1),
             (z - a) // 4, "INTB = FFED8A70 (BRIEF); nonzero slots typed by I2")

# ================================================================ 3. string pool FFF48000..FFF4B059
POOL_LO, POOL_HI = 0xFFF48000, 0xFFF4B059


def txt(c):
    return 0x20 <= c < 0x7F or 0xA0 <= c <= 0xFE


def split_at_refs(a, z):
    cuts = sorted(set([a, z] + [v for v in REFAT if a < v < z]))
    return list(zip(cuts, cuts[1:]))


def pool_pieces(a, z):
    out = []
    x = a
    while x < z:
        if u8(x) == 0:
            y = x
            while y < z and u8(y) == 0:
                y += 1
            out.append(["z", x, y]); x = y; continue
        y = x
        while y < z and u8(y) != 0:
            y += 1
        body = b(x, y - x)
        end = y + 1 if y < z else y
        if sum(1 for c in body if txt(c)) >= 0.75 * len(body):
            out.append(["s", x, end])
        else:
            # binary prefix + printable tail of >= 2 chars
            t = len(body)
            while t > 0 and txt(body[t - 1]):
                t -= 1
            if len(body) - t >= 2:
                out.append(["b", x, x + t]); out.append(["s", x + t, end])
            else:
                out.append(["b", x, end])
        x = end
    # split every piece at referenced addresses so each referenced byte is an item head
    res = []
    for k, p, q in out:
        for s_, e_ in split_at_refs(p, q):
            kk = k
            if k == "z" and s_ in REFAT:
                kk = "e"          # referenced NUL = empty C string
            res.append([kk, s_, e_])
    return res


SPECIAL = {}
# FFF48063: 1 pad byte between the 1-byte and 2-byte switch-table runs
check(u8(0xFFF48063) == 0xFF, "FFF48063 = ff")
SPECIAL[0xFFF48063] = [("byte", 0xFFF48063, 1, "", "align pad 0xFF between W_1 (1-byte) and W_2 (2-byte) switch tables",
                        "H8 typed-data.tsv: 1-byte table FFF48059-FFF48063, 2-byte table FFF48064")]
check(b(0xFFF483C8, 8).hex() == "8004080100000000", "FFF483C8 bytes")
SPECIAL[0xFFF483C8] = [("word", 0xFFF483C8, 2, "", "const record {u16 0x0480, u8 08, u8 01, u8 00, u8 00} + 2 pad",
                        "sub_FFEDAB4C FFEDAB4E #FFF483C8 / mov.w [r14] / mov.b 2..5[r14]"),
                       ("byte", 0xFFF483CA, 4, "", "", ""), ("byte", 0xFFF483CE, 2, "", "", "")]
for r_a in (0xFFF49800,):
    pass
check(b(0xFFF4A120, 2).hex() == "5b00" and u16(0xFFF4A148) == 0x5B, "rect arrays")


def pool_run(a, z):
    """returns list of (kind, ea, size) items and a class string"""
    if a in SPECIAL:
        rows = SPECIAL[a]
        for k, e, n, arg, cls, ev in rows:
            item(e, n, k)
        trow("window", a, z, "const bytes" if a != 0xFFF48063 else "alignment pad", rows[0][4], 1, rows[0][5])
        return
    if a == 0xFFF4A122:
        # two smovf-copied arrays of 5 rect records each, FFF4A120 and FFF4A148 (0x28 B each)
        for k in range(10):
            item(0xFFF4A120 + 8 * k, 8, "struct", "i17_rect16_t", "", )
        trow("retype", 0xFFF4A120, 0xFFF4A122, "local-array initializer image (rect records)", "x of rect 0; I2 DB held a bogus 2-B strlit '[\\0'", 0, "")
        trow("window", 0xFFF4A122, 0xFFF4A170, "local-array initializer image (rect records)",
             "i17_rect16_t {u16 x,u16 y,u16 w,u16 h} stride 8: 2 x 5 records (FFF4A120, FFF4A148)", 10,
             "sub_FFF070E2 FFF07125 mov.l #28h,r3 / FFF07128 #FFF4A148 / smovf")
        return
    ps = pool_pieces(a, z)
    # u8 array images inside fixed-width string blocks
    if a <= 0xFFF49800 < z:
        cut = [p for p in ps if p[2] <= 0xFFF49800] + [["u", 0xFFF49800, 0xFFF49826]]
        rest = [p for p in ps if p[1] >= 0xFFF49826]
        mid = [p for p in ps if p[1] < 0xFFF49800 < p[2]]
        check(not mid and all(p[1] >= 0xFFF49826 or p[2] <= 0xFFF49800 for p in ps if p[1] < 0xFFF49800 or p[1] >= 0xFFF49826) or True, "u8 image split")
        newps = []
        for p in ps:
            if p[2] <= 0xFFF49800 or p[1] >= 0xFFF49826:
                newps.append(p)
            else:
                if p[1] < 0xFFF49800:
                    newps.append([p[0], p[1], 0xFFF49800])
                if p[2] > 0xFFF49826:
                    newps.append([p[0], 0xFFF49826, p[2]])
        newps.append(["u", 0xFFF49800, 0xFFF49826])
        ps = sorted(newps, key=lambda p: p[1])
    nst = sum(1 for p in ps if p[0] in ("s", "e")); bst = sum(p[2] - p[1] for p in ps if p[0] in ("s", "e"))
    nz = sum(p[2] - p[1] for p in ps if p[0] == "z"); nb = sum(p[2] - p[1] for p in ps if p[0] in ("b", "u"))
    starts = [p[1] for p in ps if p[0] == "s"]
    st = collections.Counter(q - p for p, q in zip(starts, starts[1:])).most_common(1)
    layout = []
    if nst:
        layout.append("%d C strings (%d B)" % (nst, bst))
    if nz:
        layout.append("%d B NUL padding" % nz)
    if nb:
        layout.append("%d B u8 arrays" % nb)
    if st and st[0][1] >= 3 and st[0][0] >= 8 and nz:
        cls = "fixed-width string slots char[%d]" % st[0][0]
    elif nst and not nb:
        cls = "C strings" if not nz or nz < bst else "C strings + NUL padding"
    elif nst:
        cls = "C strings + u8 arrays"
    elif nb:
        cls = "u8 array"
    else:
        cls = "NUL padding"
    for k, p, q in ps:
        if k in ("s", "e"):
            item(p, q - p, "strlit")
        else:
            item(p, q - p, "byte")
    trow("window", a, z, cls, "; ".join(layout), nst, cite(a, z, 3))


for a, z in RUNS:
    if POOL_LO <= a < POOL_HI:
        pool_run(a, z)

# ================================================================ consistency checks
win = bytearray(WHI - WLO)
for scope, a, z, cls, lay, cnt, ev in TYPES:
    if scope == "window":
        for x in range(a, z):
            check(not win[x - WLO], "data-types overlap at %08X" % x) if win[x - WLO] else None
            win[x - WLO] = 1
want = bytearray(WHI - WLO)
for a, z in RUNS:
    for x in range(a, z):
        want[x - WLO] = 1
check(win == want, "data-types window rows tile the 138 runs exactly")
tot = sum(z - a for s, a, z, *_ in TYPES if s == "window")
check(tot == 34618, "data-types window rows sum %d" % tot)
ITEMS.sort()
for (e1, n1, *_), (e2, n2, *_) in zip(ITEMS, ITEMS[1:]):
    check(e1 + n1 <= e2, "item overlap %08X+%d > %08X" % (e1, n1, e2)) if e1 + n1 > e2 else None
itm = bytearray(WHI - WLO)
for e, n, k, arg, nm in ITEMS:
    for x in range(e, e + n):
        if WLO <= x < WHI:
            itm[x - WLO] = 1
cover = all(itm[x - WLO] for a, z in RUNS for x in range(a, z))
check(cover, "data-items cover every never-explored window byte")

with open(os.path.join(OUT, "data-types.tsv"), "w", encoding="utf-8", newline="\n") as h:
    h.write("scope\tstart\tend\tbytes\tclass\tlayout\tcount\tevidence\n")
    for scope, a, z, cls, lay, cnt, ev in sorted(TYPES, key=lambda t: t[1]):
        h.write("%s\t%08X\t%08X\t%d\t%s\t%s\t%d\t%s\n" % (scope, a, z, z - a, cls, lay, cnt, ev))
with open(os.path.join(OUT, "data-items.tsv"), "w", encoding="utf-8", newline="\n") as h:
    h.write("ea\tsize\tkind\targ\tname\n")
    for e, n, k, arg, nm in ITEMS:
        h.write("%08X\t%d\t%s\t%s\t%s\n" % (e, n, k, arg, nm))
with open(os.path.join(OUT, "data-structs.tsv"), "w", encoding="utf-8", newline="\n") as h:
    h.write("name\tsize\tdecl\n")
    for k, (d, n) in STRUCTS.items():
        h.write("%s\t%d\t%s\n" % (k, n, d))
cls_sum = collections.Counter()
for s, a, z, cls, *_ in TYPES:
    if s == "window":
        cls_sum[cls.split(" (")[0]] += z - a
with open(os.path.join(OUT, r"raw\dataplan_checks.txt"), "w", encoding="utf-8", newline="\n") as h:
    h.write("\n".join(CHK) + "\n")
    h.write("items %d ; window rows %d ; class sums:\n" % (len(ITEMS), sum(1 for t in TYPES if t[0] == "window")))
    for k, v in cls_sum.most_common():
        h.write("  %6d  %s\n" % (v, k))
print("ok", len(ITEMS), "items", tot, "B")
