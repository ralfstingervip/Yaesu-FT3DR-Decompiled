# -*- coding: utf-8 -*-
"""Lane N3 - decisions for the 425 B M6 left Inferred, with byte-checked citations.

Offline, read-only. Reads the two images, the FINAL7 masks and M6's pieces.tsv.
Writes (this folder): pieces.tsv, proposed-named.tsv, verify.txt.
Every citation is (address, hex bytes); the script asserts image bytes == cited bytes.
"""
# Repository layout: this script lives under ida/out/; paths below are derived from its location.
from pathlib import Path as _Path
_REPO = _Path(__file__).resolve().parents[3]
def _no_image():
    import sys
    sys.exit("The firmware image is not in this repository.")
import hashlib, sys
sys.path.insert(0, str(_REPO / "ida/out/unread-tables"))
from n3_lib import *

SHA_MAIN = "8e3ecd05409b2c314ebed77320ece5930bf31c8333cd84aeef4f6b0264c1bcce"
SHA_SUB = "b93570b3c2f69ccb51c113c893b4bc4c414cf78ceddde478748404e0768c6230"
h_main = hashlib.sha256(img).hexdigest()
h_sub = hashlib.sha256(open(R + _no_image(), "rb").read()).hexdigest()
assert h_main == SHA_MAIN and h_sub == SHA_SUB, (h_main, h_sub)


def B(s):
    return bytes.fromhex(s.replace(" ", ""))


# ---- structure facts (byte-checked below) ----
T13 = (0x036273, 13, 35)    # u8[35][13], 0x036273-0x036439
T50 = (0x036692, 50, 86)    # u8[86][50], 0x036692-0x03775D (same 50-B grid runs back to 0x03643A)
A86 = (0x03776B, 1, 86)     # u8[86] step array, 0x03776B-0x0377C0


def rows(base, stride, n):
    return [img[base + r * stride: base + (r + 1) * stride] for r in range(n)]


def mono(r):
    return all(r[i] <= r[i + 1] for i in range(len(r) - 1))


checks = []
r13 = rows(*T13)
r50 = rows(*T50)
checks.append(("T13 rows non-decreasing (row 0 has one dip 23 22)", sum(map(mono, r13)), 34))
checks.append(("T13 value falls at every row boundary", sum(1 for i in range(34) if r13[i][-1] > r13[i + 1][0]), 34))
checks.append(("T50 rows non-decreasing", sum(map(mono, r50)), 86))
checks.append(("T50 value falls at every row boundary", sum(1 for i in range(85) if r50[i][-1] > r50[i + 1][0]), 85))
checks.append(("T13 end == 50-B grid start 0x03643A", T13[0] + 13 * 35, 0x03643A))
checks.append(("50-B grid 0x03643A + 12 rows == T50 base", 0x03643A + 12 * 50, T50[0]))
checks.append(("T50 end == 0x03775E", T50[0] + 50 * 86, 0x03775E))
a86 = img[A86[0]:A86[0] + 86]
checks.append(("A86 non-increasing", all(a86[i] >= a86[i + 1] for i in range(85)), True))
checks.append(("A86 value set", sorted(set(a86)), [0x3b, 0x3d, 0x3e]))
checks.append(("0x05B310 24-slot table end", 0x05B310 + 24 * 4, 0x05B370))
checks.append(("0x05B370 + 24 == slot-0 target", 0x05B370 + 24, be32(0x05B310)))
checks.append(("0x058FFE record stride", (0x05901E - 0x058FFE, 0x05903E - 0x05901E), (32, 32)))
checks.append(("0x005796 u16 header == row length", be16(0x005796), 5))
checks.append(("0x005796 rows share cols 0,3,4",
               len({(img[0x005798 + 5 * k], img[0x00579B + 5 * k], img[0x00579C + 5 * k]) for k in range(3)}), 1))
checks.append(("0x036218 index 0x32 -> last byte read", 0x036218 + 0x32, 0x03624A))
checks.append(("APRS row 15 / row 16 addresses (0x04C32E + 9k)", (0x04C32E + 9 * 15, 0x04C32E + 9 * 16), (0x04C3B5, 0x04C3BE)))

# ---- citations (addr, hex) ----
C = {
    "rd36218": (0x0354EA, "78 10 6a 2e 00 03 62 18"), "rd36218b": (0x0355A2, "78 10 6a 2e 00 03 62 18"),
    "rd36116": (0x035368, "78 60 6a 2e 00 03 61 16"), "mul33": (0x03535E, "79 04 00 33"),
    "clamp32": (0x03527C, "7a 01 00 00 00 32"), "cmp47": (0x035282, "7a 24 47 00 00 00"),
    "lo42": (0x03528C, "7a 06 00 03 53 2a"), "bcd42": (0x03532A, "42 00 00 00"),
    "t13r0": (0x036273, "23 23 22 23 23 23 25 25 25 26 26 26 26"),
    "t13r2": (0x03628D, "1e 1f 1f 1f 1f 1f 1f 21 21 21 21 22 22"),
    "t13r34": (0x03642D, "15 15 15 16 16 16 16 16 16 16 16 16 16"),
    "g50r0": (0x03643A, "2b 2b 2b 2b 2d 2d 2d 2d 2d 2d 2d 2e"),
    "t50r0": (0x036692, "21 21 21 21 24 24 24 24 24 2a 2a 2a"),
    "t50r95": (0x0376C8, "11 11 11 11 11 11 12 12 13 13 13 13"),
    "t50end": (0x03775A, "19 19 19 19"),
    "tail13": (0x03775E, "5b 5b 5b 5b 5b 00 2f 2f 2f 2f 00 00 00"),
    "a86h": (0x03776B, "3e 3e 3e 3e"), "a86t": (0x0377BD, "3b 3b 3b 3b 00"),
    "code377C2": (0x0377C2, "6a 10 fb a5"),
    "mul50ram": (0x0608B0, "79 04 00 32 52 41 7a 11 00 ff 10 4c"),
    "rts5794": (0x005794, "54 70"),
    "t5796": (0x005796, "00 05 a0 81 87 e3 e8 a0 83 85 e3 e8 a0 87 81 e3 e8 00"),
    "code57A8": (0x0057A8, "6a 10 89 be"),
    "rts58FFC": (0x058FFC, "54 70"), "rec0": (0x058FFE, "1f 01 00 00"), "rec0end": (0x05901D, "20"),
    "rec1": (0x05901E, "1f 02 00 00"), "rec1end": (0x05903D, "21"), "rec2": (0x05903E, "18 00 00 00"),
    "ld5901E": (0x058F86, "7a 04 00 05 90 1e"), "ld5903E": (0x058F94, "7a 04 00 05 90 3e"),
    "jt5B310": (0x0563DA, "78 b0 6b 26 00 05 b3 10"), "slot0": (0x05B310, "00 05 b3 88"),
    "map5B370": (0x05B370, "00 00 00 00 00 00 00 01 01 01 01 02 02 02 02 02 03 03 03 03 03 00 02 00"),
    "code5B388": (0x05B388, "6a 0b b0 bf"),
    "list4C3C5": (0x04C3C5, "ff 00 01 02 03 04 ff 05 06 07 08 09 ff"), "code4C3D2": (0x04C3D2, "6a 0b a5 1f"),
    "jt4B9EA": (0x04B8FE, "78 b0 6b 26 00 04 b9 ea"), "lastslot": (0x04BA2A, "00 04 b9 08"),
    "mul5": (0x0353EA, "79 04 00 05"), "rd3605A": (0x0353F4, "78 60 6a 2e 00 03 60 5a"),
    "mul26": (0x0353BC, "79 04 00 26"), "rd3607E": (0x0353C6, "78 60 6a 2e 00 03 60 7e"),
    "mul4": (0x03538E, "79 04 00 04"), "rd3606E": (0x035398, "78 60 6a 2e 00 03 60 6e"),
    "disp35402": (0x035402, "00 03 53 d0 00 03 53 d0 00 03 53 a2 00 03 53 a2 00 03 53 74 00 03 53 44 00 03 53 44"),
    "rd361F2": (0x03550A, "78 10 6a 2e 00 03 61 f2"), "zero3624B": (0x03624B, "00" * 40),
    "p4BA2E": (0x04BA2E, "07 08 ff 00"), "idx4B8F6": (0x04B8F6, "7a 63 00 00 00 ff 10 73"),
    "r3_0": (0x04C7EA, "fb 00"), "r3_a": (0x04C7F4, "f3 0a fb 01"), "r3_3": (0x04C7FC, "f3 03 fb 02"),
    "r3_7": (0x04C808, "fb 07"), "r3_10": (0x04C84E, "fb 10 40 02 0c 3b"), "r3_4": (0x04C874, "fb 04"),
    "r3_f": (0x04C8D2, "fe 0f"), "r3_r6": (0x04C8E0, "0c eb"),
    "aprs_dec": (0x04C29A, "ab 00 46 08"), "aprs_dec2": (0x04C2A6, "1a 0b"), "aprs_row": (0x04C2C0, "6d 54 f3 00 52 43 0a b5"),
    "aprs_r15": (0x04C3B5, "54 48 2d 44 37 34 20 ff ff"), "aprs_r16": (0x04C3BE, "2d 2d 2d 2d 2d 2d 2d ff 00"), "code4BA32": (0x04BA32, "7a 05 00 04 be 62"),
    "p62592": (0x062592, "00 05 77 13 00 12 77 20"), "code6259A": (0x06259A, "f2 10 fa 00"),
    "ff67FAA": (0x067FAA, "ff ff ff ff ff 00 44 4e 45 57 53"),
    "ee67FAA": (0x00DF62, "fc 05 f4 00 7a 05 00 06 7f aa"),
    "rec6C538": (0x06BD3E, "79 04 00 37 7a 05 00 06 c5 38"), "end6C538": (0x06C56E, "04 00"),
    "end6C570": (0x06C596, "04 00"), "rd6C598": (0x06BEB8, "79 04 00 08 7a 05 00 06 c5 98"),
}
fails = [k for k, (a, h) in C.items() if img[a:a + len(B(h))] != B(h)]
cfail = [c for c in checks if c[1] != c[2]]

# ---- decisions: (start, end_excl, tier, typing, element/stride, reader_and_bound, cites) ----
NR = ("Not found (scope: every byte offset of MAIN 0x000000-0x0FFFFF for a BE32 or abs24 value in range; "
      "every operand of every head in N3_TABLES (FINAL6 seed copy); word-immediate forms; "
      "every mulxu with a 12/13/50/86/98 multiplier)")
D = []
t13 = [(0x03628D, 0x036294), (0x03629A, 0x03629E), (0x0362A8, 0x0362AE), (0x0362BC, 0x0362BE), (0x0362D8, 0x0362DC),
       (0x0362F4, 0x0362F6), (0x036338, 0x03633E), (0x036346, 0x03634C), (0x036354, 0x03635A), (0x036362, 0x036368),
       (0x036372, 0x036384), (0x03638C, 0x036392), (0x0363AA, 0x0363AC)]
for s, e in t13:
    D.append((s, e, "C-unread", "u8 table",
              "u8[35][13] at 0x036273, stride 13, row %d col %d" % ((s - 0x036273) // 13, (s - 0x036273) % 13),
              NR, "t13r0 t13r2 t13r34 g50r0 rd36218 clamp32"))
t50 = [(0x0367BE, 0x0367C0), (0x0367F0, 0x0367F7), (0x036980, 0x036984), (0x0369E4, 0x0369EA), (0x036A16, 0x036A18),
       (0x036A48, 0x036A50), (0x036A7A, 0x036A7E), (0x036AAC, 0x036AB6), (0x036ADE, 0x036AE4), (0x036B10, 0x036B1C),
       (0x036B4A, 0x036B50), (0x0376C8, 0x03775E)]
for s, e in t50:
    D.append((s, e, "C-unread", "u8 table",
              "u8[86][50] at 0x036692, stride 50, row %d col %d" % ((s - 0x036692) // 50, (s - 0x036692) % 50),
              NR + "; the only stride-50 multiplies (0x0608B0 and 9 others) index RAM 0xFF104C",
              "t50r0 t50r95 t50end mul50ram"))
D.append((0x03775E, 0x037760, "Inferred", "data bytes", "first 2 B of the 13-B block 5b x5, 00, 2f x4, 00 x3 (no stride)", NR, "tail13"))
D.append((0x03776A, 0x03776B, "Inferred", "data byte 00", "last byte of the 13-B block, or a lead byte of the u8[86] array", NR, "tail13 a86h"))
D.append((0x03776B, 0x0377C1, "C-unread", "u8 array",
          "u8[86] at 0x03776B, stride 1, non-increasing 3e x20, 3d x15, 3b x51; count equals the 86 rows of 0x036692 (link Inferred)",
          NR, "a86h a86t t50end"))
D.append((0x0377C1, 0x0377C2, "Inferred", "pad byte 00", "before proven code 0x0377C2 (pad or terminator)", NR, "a86t code377C2"))
D.append((0x005796, 0x0057A7, "C-unread", "{u16 len; rows}", "u16 5 + 3 x 5-B rows (a0 xx xx e3 e8), stride 5", NR + "; abs16 forms included",
          "rts5794 t5796 code57A8"))
D.append((0x0057A7, 0x0057A8, "Inferred", "pad byte 00", "before proven code 0x0057A8", NR, "t5796 code57A8"))
D.append((0x04BA2E, 0x04BA32, "Inferred", "data bytes 07 08 ff 00",
          "after 17-slot jump table 0x04B9EA; the index r3l = sub_4C7E4() is one of 0..0x10, so slot 17 is never read "
          "(Confirmed); shape 07 08 ff + 00 resembles the FF-terminated lists at 0x04C3C7 (Inferred)", NR,
          "jt4B9EA idx4B8F6 lastslot p4BA2E code4BA32 r3_0 r3_a r3_3 r3_7 r3_10 r3_4 r3_f r3_r6"))
D.append((0x04C3C7, 0x04C3C8, "C-unread", "u8 list",
          "FF-terminated lists 01 02 03 04 ff | 05..09 ff, 0x04C3C7-0x04C3D1, stride 1; nothing references 0x04C3C0-0x04C3D1",
          NR, "list4C3C5 code4C3D2"))
D.append((0x058FFE, 0x059000, "C-unread", "record header",
          "record [0] of 32-B records 0x058FFE/0x05901E/0x05903E, stride 32 (records [1] and [2] are loaded)", NR,
          "rts58FFC rec0 rec0end rec1 rec1end rec2 ld5901E ld5903E"))
D.append((0x05B370, 0x05B37C, "C-unread", "u8 map",
          "u8[24] at 0x05B370 parallel to 24-slot table 0x05B310, stride 1; ends at slot-0 target 0x05B388", NR,
          "jt5B310 slot0 map5B370 code5B388"))
D.append((0x062598, 0x06259A, "Inferred", "data u16", "second u16 of {0005,7713},{0012,7720}; two records only", NR, "p62592 code6259A"))
D.append((0x067FAF, 0x067FB0, "Inferred", "pad byte 00", "between the 5-B FF block (eepmov 5) and 'DNEWS'", NR, "ff67FAA ee67FAA"))
D.append((0x06C56F, 0x06C570, "Inferred", "pad byte 00", "after 55-B record 0x06C538", NR, "rec6C538 end6C538"))
D.append((0x06C596, 0x06C598, "Inferred", "terminator 04 + pad 00", "end of record 0x06C570, which has no reader", NR, "end6C570 rd6C598"))

D.sort()
cov = [(d[0], d[1]) for d in D]
want = bytearray(0x100000)
got = bytearray(0x100000)
for s, e in PIECES:
    want[s:e] = b"\1" * (e - s)
for s, e in cov:
    assert not any(got[s:e]), "overlap %06X" % s
    got[s:e] = b"\1" * (e - s)
assert want == got, "decisions do not tile M6's pieces"
assert not any(any(NM7[s:e]) or any(PM7[s:e]) for s, e in cov)


def tot(t, curve=None):
    return sum(d[1] - d[0] for d in D if d[2] == t and (curve is None or (0x03624B <= d[0] < 0x0377C2) == curve))


with open("pieces.tsv", "w", encoding="utf-8", newline="\n") as o:
    o.write("start\tend_excl\tlen\tn3_tier\ttyping\telement_stride\treader_and_bound\tcitations\tbytes\n")
    for s, e, tier, ty, el, rd, ci in D:
        cites = "; ".join("%06X `%s`" % (C[k][0], C[k][1]) for k in ci.split())
        o.write("%06X\t%06X\t%d\t%s\t%s\t%s\t%s\t%s\t%s\n" % (s, e, e - s, tier, ty, el, rd, cites, hx(s, min(e - s, 24))))
named = [(d[0], d[1], d[3] + "; " + d[4]) for d in D if d[2] == "C-unread"]
with open("proposed-named.tsv", "w", encoding="utf-8", newline="\n") as o:
    o.write("start\tend_excl\tlen\ttyping\n")
    for s, e, ty in named:
        o.write("%06X\t%06X\t%d\t%s\n" % (s, e, e - s, ty))
    o.write("SUM\t\t%d\tproposed named delta (Confirmed unread constants), %d disjoint ranges; proven delta 0\n"
            % (sum(e - s for s, e, _ in named), len(named)))
with open("verify.txt", "w", encoding="utf-8", newline="\n") as o:
    o.write("MAIN sha256 %s\nSUB  sha256 %s\n" % (h_main, h_sub))
    o.write("citations %d, failures %d %s\n" % (len(C), len(fails), fails))
    o.write("structure checks %d, failures %d %s\n" % (len(checks), len(cfail), cfail))
    for c in checks:
        o.write("  %s: %s (want %s)\n" % c)
    o.write("decisions %d covering %d B; they tile M6's 35 Inferred pieces exactly; none is in FINAL7 named or proven\n"
            % (len(D), sum(e - s for s, e in cov)))
    o.write("C-unread %d B (curve %d, other %d); Inferred %d B (curve %d, other %d)\n" % (
        tot("C-unread"), tot("C-unread", True), tot("C-unread", False), tot("Inferred"), tot("Inferred", True), tot("Inferred", False)))
    o.write("proposed named delta: %d disjoint ranges, %d B; proven delta 0\n" % (len(named), sum(e - s for s, e, _ in named)))
print(open("verify.txt", encoding="utf-8").read())
