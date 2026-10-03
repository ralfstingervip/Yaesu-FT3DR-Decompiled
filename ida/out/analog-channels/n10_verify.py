# -*- coding: utf-8 -*-
r"""Lane N10 verifier: analog channels AN1-AN5 (MAIN) and the labels that name them.

Read-only. Checks both image hashes, asserts every byte citation in
docs\deep\137-analog-channels.md, re-runs the raw census of the AN result bytes,
re-derives the alignment item -> label -> calibration-offset -> row -> stub map,
and regenerates channels.tsv, readers.tsv and align-items.tsv next to this file.

    python "ida/out/analog-channels/n10_verify.py" [outdir]
"""
from __future__ import annotations
import sys
from pathlib import Path as _Path
_REPO_S = _Path(__file__).resolve().parents[3].as_posix()
import hashlib, os, struct, sys

ROOT = _REPO_S
MAINP = os.path.join(ROOT, r"decrypted\FT3D_MAIN_ver102_EXP.bin")
SUBP = os.path.join(ROOT, r"decrypted\FT3D_SUB_ver102_ALL.bin")
MAIN_SHA = "8e3ecd05409b2c314ebed77320ece5930bf31c8333cd84aeef4f6b0264c1bcce"
SUB_SHA = "b93570b3c2f69ccb51c113c893b4bc4c414cf78ceddde478748404e0768c6230"
SB = 0xFFC00000
OUT = sys.argv[1] if len(sys.argv) > 1 else os.path.dirname(os.path.abspath(__file__))

sys.exit("The firmware image is not in this repository.")
sys.exit("The firmware image is not in this repository.")
assert hashlib.sha256(M).hexdigest() == MAIN_SHA, "MAIN hash changed"
assert hashlib.sha256(S).hexdigest() == SUB_SHA, "SUB hash changed"

# (image, address, hex bytes, what)
CIT = [
    # --- A/D setup ---------------------------------------------------------
    ("M", 0x00010C, "00 00 24 b6", "vector 67 slot -> sub_24B6"),
    ("M", 0x0021EE, "fc 00 3c a0 3c a1", "init: ADCSR = ADCR = 0 (sub_20FA)"),
    ("M", 0x00258E, "fc 00 3c a0 3c a1", "vector-67 handler zeroes ADCSR/ADCR"),
    ("M", 0x0032C0, "fc 02 3c a0 7f a0 70 50 7e a0 73 50 46 fa 7f a0 72 70 2c 94 6a 8c a9 92", "AN2 -> A992"),
    ("M", 0x0032D8, "fc 03 3c a0 7f a0 70 50 7e a0 73 50 46 fa 7f a0 72 70 2c 96 6a 8c a9 93", "AN3 -> A993"),
    ("M", 0x0032F0, "6a 0c 8d de 46 30", "AN4/AN5 skipped when FF8DDE != 0"),
    ("M", 0x0032F6, "fc 04 3c a0 7f a0 70 50 7e a0 73 50 46 fa 7f a0 72 70 2c 98 6a 8c a9 94", "AN4 -> A994"),
    ("M", 0x00330E, "fc 05 3c a0 7f a0 70 50 7e a0 73 50 46 fa 7f a0 72 70 2c 9a 6a 8c a9 95", "AN5 -> A995"),
    ("M", 0x002BD4, "5e 00 32 c0", "sub_32C0 caller (sub_2070)"),
    ("M", 0x0037E6, "5e 00 32 c0", "sub_32C0 caller (sub_2070)"),
    ("M", 0x003928, "5e 00 32 c0", "sub_32C0 caller (sub_2070)"),
    ("M", 0x003130, "5e 00 32 c0", "sub_32C0 caller (sub_30E0)"),
    ("M", 0x034544, "fc 01 3c a0 7f a0 70 50 7e a0 73 50 46 fa 7f a0 72 70 2c 92 6a 8c a9 96", "AN1 -> A996 (sub_34538)"),
    ("M", 0x035C20, "fc 01 3c a0 7f a0 70 50 7e a0 73 50 46 fa 7f a0 72 70 2c 92 6a 8c a9 96", "AN1 -> A996 (sub_35C14)"),
    ("M", 0x035BB6, "6a 0c a9 96 ac eb 45 54 ac ef 45 1c ac f4 45 20", "only A996 reader, sub_35BAA"),
    ("M", 0x003346, "2c 90 6a 8c a9 8c", "AN0 read (sub_32C0)"),
    ("M", 0x003478, "2c 90", "AN0 read (sub_3466)"),
    ("M", 0x000E20, "31 9c", "false census hit: DCS ramp data (doc 120)"),
    ("M", 0x04E96A, "22 a0", "false census hit: u16 table 0x04E8D8 (doc 118)"),
    ("M", 0x04E970, "2b 9e", "false census hit: u16 table 0x04E8D8 (doc 118)"),
    # --- AN2..AN5 readers --------------------------------------------------
    ("M", 0x0067DA, "6a 10 8e a0 73 60 47 06 6a 0d a9 94 40 18 6a 0d a9 92 40 12", "stub 67DA: AN4 if 8EA0.b6 else AN2"),
    ("M", 0x0067EE, "6a 10 8e a0 73 60 47 06 6a 0d a9 95 40 04 6a 0d a9 93", "stub 67EE: AN5 if 8EA0.b6 else AN3"),
    ("M", 0x006800, "6d f5 5e 00 d1 56 6a 0b 97 f8 6a 0c 97 ff 47 02 fb 12 5e 00 d0 e6", "stub: label code from item"),
    ("M", 0x006816, "6d 75 6a 10 aa 33 73 10 46 06 5e 03 ed aa 68 4d 5e 00 d1 16", "live value if AA33.b1 else stored cal byte"),
    ("M", 0x023496, "6a 10 8e a0 73 60 47 06 6a 0a a9 94 40 18 6a 0a a9 92 40 12", "capture 23496: AN4/AN2"),
    ("M", 0x0234AA, "6a 10 8e a0 73 60 47 06 6a 0a a9 95 40 04 6a 0a a9 93", "capture 234AA: AN5/AN3"),
    ("M", 0x0234BC, "6a 10 aa 33 73 10 47 06 5e 03 ed aa 68 ca 6a 18 aa 33 71 10", "store live value into cal byte, toggle AA33.b1"),
    ("M", 0x014468, "00 02 34 96", "key-handler pointer -> 23496"),
    ("M", 0x014478, "00 02 34 96", "key-handler pointer -> 23496"),
    ("M", 0x0144AC, "00 02 34 aa", "key-handler pointer -> 234AA"),
    ("M", 0x0144BC, "00 02 34 aa", "key-handler pointer -> 234AA"),
    ("M", 0x030756, "01 00 6b 03 81 62 6e 35 00 01 6e 3d 00 02 6e 36 00 00 0c 6e 11 0e 18 ed 18 e5 6a 0a 89 70", "band-A squelch: cal[0..2], SQL LEVEL FF8970"),
    ("M", 0x030786, "fc 0e 51 c3 1a 0a 50 a3", "threshold interpolated over SQL LEVEL 1..15"),
    ("M", 0x03079A, "6a 0d a9 92 1c db 44 3a", "AN2 compared with threshold"),
    ("M", 0x0307A2, "6e 0c 00 90 ac 02 47 06 08 6b 1c db 44 2c fb 02", "hysteresis cal[0]; result 2 above threshold"),
    ("M", 0x0306B2, "55 36 ab 02 47 24", "sub_30654 consumes squelch result"),
    ("M", 0x032178, "01 00 6b 03 81 66", "band-B squelch uses FF8166"),
    ("M", 0x032192, "6a 0a 89 71", "band-B SQL LEVEL FF8971"),
    ("M", 0x0321BC, "6a 0d a9 94 1c db 44 3a", "AN4 compared with threshold"),
    ("M", 0x0320B6, "55 54 ab 02 47 42", "sub_320B6 consumes band-B result"),
    ("M", 0x0057C4, "6a 10 8e a0 73 60 46 06 6a 0d 89 70 40 16 6a 0d 89 71", "SQL LEVEL sender: A=FF8970, B=FF8971"),
    ("M", 0x0057EC, "79 0b f3 47", "SQL LEVEL code F347"),
    ("M", 0x0056F4, "79 0b f3 48 6e 0b 00 37", "SQL S-METER code F348 = record +0x37"),
    ("M", 0x03E074, "6e 0c 00 37 58 70 00 84", "S-level only when SQL S-METER != 0 (meter path)"),
    ("M", 0x03E07C, "01 00 6b 03 81 62 6e 3a 00 03 6e 32 00 04 6a 0d a9 93 1c 2d 44 20", "AN3 vs cal[3]=S1, cal[4]=S9"),
    ("M", 0x03E098, "fb 08 51 b4", "(S9-S1)/8"),
    ("M", 0x03E09E, "fe 09", "9 thresholds"),
    ("M", 0x03E0B2, "fa 0a", ">= S9 byte -> level 10"),
    ("M", 0x03E0B4, "fc 00 6e 8c 00 80 6e 8a 00 81", "level -> record +0x81"),
    ("M", 0x03E0C2, "01 00 6b 03 81 62 6e 3a 00 03 6e 32 00 04 6a 0d a9 93", "second AN3 read in sub_3E060"),
    ("M", 0x03E110, "01 00 6b 03 81 62 6e 3a 00 03 6e 32 00 04 6a 0d a9 93 1c 2d 44 20", "sub_3E110 AN3 level in r2l"),
    ("M", 0x03E288, "01 00 6b 03 81 66 6e 3a 00 03 6e 32 00 04 6a 0d a9 95 1c 2d 44 20", "band-B sub_3E26C AN5"),
    ("M", 0x03E2CC, "01 00 6b 03 81 66 6e 3a 00 03 6e 32 00 04 6a 0d a9 95", "second AN5 read"),
    ("M", 0x03E31A, "01 00 6b 03 81 66 6e 3a 00 03 6e 32 00 04 6a 0d a9 95 1c 2d 44 20", "sub_3E31A AN5 level"),
    ("M", 0x02FCA6, "6e 04 00 81 6e 0d 00 37 7a 65 00 00 00 ff 6e 5c 3b 6e 1c c4 44 08 fc 01 6e 8c 00 90", "S-level < table[SQL S-METER] -> +0x90 = 1"),
    ("M", 0x031814, "6e 04 00 81 6e 0d 00 37 7a 65 00 00 00 ff 6e 5c 3b 6e 1c c4 44 08 fc 01 6e 8c 00 90", "band-B twin"),
    ("M", 0x003B6E, "00 01 02 03 04 05 06 07 08 09 0a", "SQL S-METER -> level table (identity)"),
    ("M", 0x02D70E, "5e 03 e1 10 0c ad 55 26", "sub_2D708 -> sub_2D73C"),
    ("M", 0x02D73C, "fc 27 6e 8c 00 8a 6a 0b ae 9d 7a 63 00 00 00 ff 6e bd ae c5", "level stored to FFAEC5[AE9D]"),
    ("M", 0x02E2E2, "5e 03 e3 1a 0c ad 55 26", "sub_2E2DC -> sub_2E310"),
    # --- calibration block ---------------------------------------------------
    ("M", 0x02F6C8, "5e 03 ee 9a 01 00 6b 83 81 62", "band A cal pointer FF8162"),
    ("M", 0x0311B6, "5e 03 ee c4 01 00 6b 83 81 66", "band B cal pointer FF8166"),
    ("M", 0x03EE9A, "7a 03 00 ff 80 16 6e 0c 00 8e ac 03 45 1a 7a 03 00 ff 80 26 ac 09 45 10 7a 03 00 ff 80 46 ac 0b 45 06 7a 03 00 ff 80 36", "A blocks by +0x8E"),
    ("M", 0x03EEC4, "7a 03 00 ff 80 96", "B blocks from FF8096"),
    ("M", 0x00DE26, "7a 05 00 00 ef 92 7a 06 00 ff 80 16", "defaults ROM EF92 -> FF8016"),
    ("M", 0x00DE38, "7a 05 00 00 ef 92 7a 06 00 ff 80 96", "defaults ROM EF92 -> FF8096"),
    ("M", 0x00DE4A, "7a 05 00 00 f0 12 7a 06 00 ff 80 c6", "defaults ROM F012 -> FF80C6"),
    ("M", 0x00EF92, "00 89 4e 20 49 3b 59 91 5f 37 08", "default block 0: HIS THLD TIGH S1 S9 S1' S9' HI L3 L2 L1"),
    # --- alignment items -----------------------------------------------------
    ("M", 0x0102EC, "6a 18 aa 33 70 00 fc dc 6e 8c 00 01 fc 00 6a 8c 97 f8", "entry: row DC, item 0"),
    ("M", 0x02311C, "78 40 6a 2b 00 02 31 56 6e 8b 00 01", "row = byte_23156[item]"),
    ("M", 0x023112, "78 40 6a 2b 00 02 31 44 4b 22", "band-B permit byte_23144[item]"),
    ("M", 0x023144, "ff 00 00 00 00 00 ff ff ff ff ff ff ff ff ff 00 ff ff", "band-B permit table"),
    ("M", 0x023156, "dd de df df e0 e0 e0 e0 e1 e1 e1 e1 e2 e3 e4 e5 e6 e7", "row table"),
    ("M", 0x0231C2, "7a 06 00 02 31 ec 5e 03 f6 2e", "item stepper"),
    ("M", 0x0231E0, "ab 06 47 de ab 07 47 da", "stepper skips items 6, 7"),
    ("M", 0x0231EC, "00 11 00 ff 97 f8", "item range 0..0x11 at FF97F8"),
    ("M", 0x03F636, "01 00 6f 65 00 02 68 5b 69 64 1c bc", "range helper (min,max,ptr)"),
    ("M", 0x004810, "6e 0b 00 01 7a 63 00 00 00 ff 10 73 78 b0 6b 26 00 00 78 2c fb 00 5d 60", "row stub dispatch table 0x782C"),
    ("M", 0x007BA8, "00 00 67 da 00 00 67 ee", "rows DF, E0 -> stubs 67DA, 67EE"),
    ("M", 0x007BA4, "00 00 67 6c", "row DE -> stub 676C (no A/D)"),
    ("M", 0x00D0F0, "78 50 6a 2b 00 00 d1 04 7a 06 00 ff 3d e0 68 eb", "label code = D104[item] -> FF3DE0"),
    ("M", 0x00D104, "00 01 02 03 04 05 04 05 06 07 08 09 0a 0b 0c 0d 0f 0e", "item -> SUB label index"),
    ("M", 0x00D11A, "7a 06 00 ff 3d e1 68 eb", "value -> FF3DE1"),
    ("M", 0x03EE02, "6a 0b 97 f8 7a 63 00 00 00 ff ab 08 45 10 ab 0f 44 0c 1a 0b 0a b4 7a 14 00 ff 80 16", "cal byte = block + item - 1"),
    ("M", 0x03EE20, "1a 0b 0a b4 6a 10 8e a0 73 60 47 08 7a 14 00 ff 80 96 40 06 7a 14 00 ff 80 16", "items 1-7, 0xF: side A/B"),
    ("M", 0x03EDCC, "6e 0b 00 04 7a 04 00 00 00 00 ab 02 47 10 fc 10 ab 06 47 22 fc 30 ab 08 47 1c fc 20", "band offsets 0/10/30/20"),
    ("M", 0x0232EA, "6e 0c 00 19 6a 0b 97 f8 ab 06 47 0c ab 07 47 08", "items 6/7 handle record +0x19"),
    ("M", 0x023302, "ac 02 47 06 fc 02 6e 8c 00 19", "items 6/7: +0x19 = 2"),
    ("M", 0x03E0C2, "01 00 6b 03 81 62", "FF8162 load (offsets 3,4)"),
    ("M", 0x03E2CC, "01 00 6b 03 81 66", "FF8166 load (offsets 3,4)"),
    ("M", 0x03EDB2, "7a 04 00 ff 80 56", "item 0 (PLL REF) -> FF8056"),
    ("M", 0x03E060, "fa 00 6e 0c 00 90 ac 02 58 70 00 94 6e 0c 00 8f 73 1c 46 4e", "S-level gate +0x90 / +0x8F.b1"),
    # --- SUB -------------------------------------------------------------------
    ("S", 0xFFED8A4C, "70 8e ed ff fb 8f ed ff 7e 21 01 00", "DTBL: FFED8E70..FFED8FFB -> RAM 0x1217E"),
    ("S", 0xFFED8E70, "00 00 00 01 50 4c 4c 20 52 45 46 00", "record 0 PLL REF"),
    ("S", 0xFFED8E84, "48 49 53 20 53 51 4c 00", "label 1 HIS SQL"),
    ("S", 0xFFED8E94, "54 48 4c 44 20 53 51 4c", "label 2 THLD SQL"),
    ("S", 0xFFED8EA4, "54 49 47 48 20 53 51 4c", "label 3 TIGH SQL"),
    ("S", 0xFFED8EB4, "53 31 20 4c 45 56 45 4c", "label 4 S1 LEVEL"),
    ("S", 0xFFED8EC4, "53 39 20 4c 45 56 45 4c", "label 5 S9 LEVEL"),
    ("S", 0xFFED8F64, "4c 43 44 20 43 4f 4e 54 52 41 53 54", "label 15 LCD CONTRAST"),
    ("S", 0xFFEDEDB9, "fb e2 4d 8c 00 00 c5 e0 6c 0f b3 89 61 f1 2b 05 3c 0f 00", "label index = [8C4D+0x6C], >0xF -> 0"),
    ("S", 0xFFEDEDDC, "6c 42 fb 42 82 21 01 00 4b 24", "label = 0x12182 + 16*index"),
    ("S", 0xFFEDEE14, "fb e2 4d 8c 00 00 c5 e0 6d 0a", "value = [8C4D+0x6D]"),
    ("S", 0xFFC3E141, "53 51 4c 20 4c 45 56 45 4c 00", "SQL LEVEL"),
    ("S", 0xFFC3E155, "53 51 4c 20 53 2d 4d 45 54 45 52 00", "SQL S-METER"),
    ("S", 0xFFF02C09, "5a 01 f7 03 61 01 21 27", "SQL S-METER 0 -> OFF"),
    ("S", 0xFFF02C1B, "fb 32 dd 86 f4 ff", "'OFF' at FFF486DD"),
    ("S", 0xFFF02C9F, "fb e2 ec 8a f4 ff", "'LEVEL  ' at FFF48AEC"),
    ("S", 0xFFF02B8B, "fb e2 de 8a f4 ff", "SQL LEVEL 'LEVEL  ' at FFF48ADE"),
    ("S", 0xFFF48AEC, "4c 45 56 45 4c 20 20 00", "LEVEL"),
    ("S", 0xFFF486DD, "4f 46 46 00", "OFF"),
    ("S", 0xFFF4AAD9, "57 20 50 52 4f 54 45 43 54 00", "W PROTECT (SD)"),
]


def at(img, a, n):
    return M[a:a + n] if img == "M" else S[a - SB:a - SB + n]


bad = 0
for img, a, hx, what in CIT:
    want = bytes.fromhex(hx)
    got = at(img, a, len(want))
    if got != want:
        bad += 1
        print("FAIL %s %08X want %s got %s (%s)" % (img, a, hx, got.hex(" "), what))
print("citations: %d/%d pass" % (len(CIT) - bad, len(CIT)))
# ---- every `0xADDR xx xx ...` span in the doc, up to the first non-hex token or ellipsis
import re
DOC = os.path.join(ROOT, "docs", "deep", "137-analog-channels.md")
dbad = dn = 0
for span in re.findall(r"`([^`]+)`", open(DOC, encoding="utf-8").read()):
    t = span.split()
    if len(t) < 2 or not re.fullmatch(r"0x[0-9A-Fa-f]{6,8}", t[0]):
        continue
    hx = []
    for w in t[1:]:
        if re.fullmatch(r"[0-9a-f]{2}", w):
            hx.append(w)
        else:
            break
    if not hx:
        continue
    a = int(t[0], 16)
    img = "S" if a >= SB else "M"
    dn += 1
    if at(img, a, len(hx)) != bytes.fromhex(" ".join(hx)):
        dbad += 1
        print("DOC FAIL", span)
print("doc spans: %d/%d pass" % (dn - dbad, dn))
bad += dbad


# ---- raw census: abs16 operands A992..A996 in 6a-form instructions, whole MAIN image
END = 0x7B754
census = {}
for lo in range(0x92, 0x97):
    pat = bytes([0xA9, lo])
    i = M.find(pat, 0)
    while 0 <= i < END:
        op = M[i - 2:i]
        if (i - 2) % 2 == 0 and op[0] == 0x6A:
            census.setdefault(0xA900 | lo, []).append((i - 2, op[1]))
        i = M.find(pat, i + 1)
# no abs32/abs24 forms of FFA992..FFA996
for lo in range(0x92, 0x97):
    assert M.find(bytes([0xFF, 0xA9, lo]), 0, END) < 0
exp_counts = {0xA992: 4, 0xA993: 6, 0xA994: 4, 0xA995: 6, 0xA996: 3}
for k, v in exp_counts.items():
    assert len(census.get(k, [])) == v, (hex(k), census.get(k))
print("raw census A992..A996:", {hex(k): len(v) for k, v in sorted(census.items())})

FN = [(0x0032C0, "sub_32C0"), (0x0067DA, "stub_67DA"), (0x0067EE, "stub_67EE"), (0x023496, "sub_23496"),
      (0x0234AA, "sub_234AA"), (0x0306EA, "sub_306EA"), (0x03210C, "sub_3210C"), (0x034538, "sub_34538"),
      (0x035BAA, "sub_35BAA"), (0x035C14, "sub_35C14"), (0x03E060, "sub_3E060"), (0x03E110, "sub_3E110"),
      (0x03E26C, "sub_3E26C"), (0x03E31A, "sub_3E31A")]


def owner(a):
    return max((x for x in FN if x[0] <= a), key=lambda x: x[0])[1]


ROLE = {
    "sub_32C0": "sampler (writes result)",
    "stub_67DA": "alignment rows DF (THLD/TIGH SQL): shows live value",
    "stub_67EE": "alignment row E0 (S1/S9 LEVEL): shows live value",
    "sub_23496": "alignment key: stores live value into current cal byte",
    "sub_234AA": "alignment key: stores live value into current cal byte",
    "sub_306EA": "band-A squelch decision vs HIS/THLD/TIGH SQL and SQL LEVEL",
    "sub_3210C": "band-B squelch decision vs HIS/THLD/TIGH SQL and SQL LEVEL",
    "sub_3E060": "band-A S-level 0..10 from S1/S9 LEVEL -> +0x80/+0x81",
    "sub_3E110": "band-A S-level 0..10 in r2l (band-scope sample path)",
    "sub_3E26C": "band-B S-level 0..10 -> +0x80/+0x81",
    "sub_3E31A": "band-B S-level 0..10 in r2l (band-scope sample path)",
    "sub_34538": "TX dispatcher sampler (writes A996)",
    "sub_35C14": "node-mode twin sampler (writes A996)",
    "sub_35BAA": "TX power foldback / cutoff (only reader)",
}
rows = []
for k in sorted(census):
    for a, mod in census[k]:
        kind = "write" if mod & 0xF0 == 0x80 else "read"
        n = owner(a)
        rows.append((a, k, kind, n, ROLE.get(n, "?"), M[a:a + 4].hex(" ")))
rows.sort()
with open(os.path.join(OUT, "readers.tsv"), "w", encoding="utf-8", newline="\n") as h:
    h.write("site\tram\tAN\taccess\tfunction\trole\tbytes\n")
    an = {0xA992: "AN2", 0xA993: "AN3", 0xA994: "AN4", 0xA995: "AN5", 0xA996: "AN1"}
    for a, k, kind, n, role, b in rows:
        h.write("0x%06X\tFF%04X\t%s\t%s\t%s\t%s\t%s\n" % (a, k, an[k], kind, n, role, b))

# ---- alignment item map
D104 = M[0xD104:0xD104 + 18]
ROWA = M[0x23156:0x23156 + 18]
PERMB = M[0x23144:0x23144 + 18]


def sub_str(a):
    o = a - SB
    e = S.index(b"\x00", o)
    return S[o:e].decode("ascii")


with open(os.path.join(OUT, "align-items.tsv"), "w", encoding="utf-8", newline="\n") as h:
    h.write("item\tlabel_index\tSUB_label_addr\tlabel\trow\tstub\tlive_AD_shown\tband_B_allowed\tcal_byte\tdefault_block0\n")
    for i in range(18):
        li = D104[i]
        la = 0xFFED8E74 + 16 * li
        lab = sub_str(la)
        row = ROWA[i]
        stub = struct.unpack(">I", M[0x782C + 4 * row:0x782C + 4 * row + 4])[0]
        live = {0x67DA: "AN2 (A) / AN4 (B)", 0x67EE: "AN3 (A) / AN5 (B)"}.get(stub, "-")
        if i == 0:
            cal = "FF8056"
        elif i == 0x10:
            cal = "FF8059"
        elif i == 0x11:
            cal = "FF8079/805E/807A/805F by band"
        elif 8 <= i < 0xF:
            cal = "FF8016+band+0x%X" % (i - 1)
        else:
            cal = "FF8016|FF8096 + band + 0x%X" % (i - 1)
        dflt = "%02X" % M[0xEF92 + i - 1] if 1 <= i <= 0xF else "-"
        permb = "yes" if (PERMB[i] < 0x80 or i == 0x10) else "no"
        h.write("0x%02X\t%d\t%08X\t%s\t0x%02X\t0x%06X\t%s\t%s\t%s\t%s\n" % (i, li, la, lab, row, stub, live, permb, cal, dflt))
        if i in (2, 3):
            assert stub == 0x67DA and lab.endswith("SQL")
        if i in (4, 5, 6, 7):
            assert stub == 0x67EE and lab.endswith("LEVEL")
        if i == 1:
            assert lab == "HIS SQL" and stub == 0x676C

# runtime offsets used with each channel (from the cited code)
assert M[0x03075C:0x030768] == bytes.fromhex("6e 35 00 01 6e 3d 00 02 6e 36 00 00")  # cal[1], cal[2], cal[0]
assert M[0x03E082:0x03E08A] == bytes.fromhex("6e 3a 00 03 6e 32 00 04")  # cal[3], cal[4]

CH = [
    ("AN0", "FFFF90", "0x003346 2c 90; 0x003478 2c 90", "FFA98C, FFA9BC", "sub_32C0 (every 60 ms), sub_3466 (boot)",
     "supply voltage", "MAIN ' Volt Ext/Lit/Dry' (doc 120)", "Inferred strong (doc 120; not re-opened)"),
    ("AN1", "FFFF92", "0x034556 2c 92; 0x035C32 2c 92", "FFA996", "sub_35BAA only (0x035BB6)",
     "TX protection sensor; trips at >=0xEB/0xEF/0xF4", "none (whole-image vocabulary scan; no alignment label)", "Unknown (Not found)"),
    ("AN2", "FFFF94", "0x0032D2 2c 94", "FFA992", "sub_306EA (0x03079A), stub_67DA (0x0067E8), sub_23496 (0x0234A4)",
     "band-A squelch detector input; high = mute", "SUB 'THLD SQL' FFED8E94, 'TIGH SQL' FFED8EA4, 'HIS SQL' FFED8E84 (cal points); 'SQL LEVEL' FFC3E141 (setting)",
     "Confirmed: squelch input (labels). Noise-type detector Inferred (polarity)"),
    ("AN3", "FFFF96", "0x0032EA 2c 96", "FFA993", "sub_3E060 (0x03E08A, 0x03E0D0), sub_3E110 (0x03E11E), stub_67EE (0x0067FC), sub_234AA (0x0234B8)",
     "band-A signal strength, quantised S0..S9, 10", "SUB 'S1 LEVEL' FFED8EB4, 'S9 LEVEL' FFED8EC4 (cal points); 'SQL S-METER' FFC3E155 (setting compared)",
     "Confirmed: S-meter (labels)"),
    ("AN4", "FFFF98", "0x003308 2c 98 (only if FF8DDE == 0)", "FFA994", "sub_3210C (0x0321BC), stub_67DA (0x0067E2), sub_23496 (0x02349E)",
     "band-B squelch detector input; high = mute", "same labels as AN2, band-B side (8EA0.b6, FF8096 block, FF8971)",
     "Confirmed: squelch input (labels). Noise-type detector Inferred"),
    ("AN5", "FFFF9A", "0x003320 2c 9a (only if FF8DDE == 0)", "FFA995", "sub_3E26C (0x03E296, 0x03E2DA), sub_3E31A (0x03E328), stub_67EE (0x0067F6), sub_234AA (0x0234B2)",
     "band-B signal strength, quantised S0..S9, 10", "same labels as AN3, band-B side",
     "Confirmed: S-meter (labels)"),
]
with open(os.path.join(OUT, "channels.tsv"), "w", encoding="utf-8", newline="\n") as h:
    h.write("channel\tresult_reg\tconversion_site\tstore\treaders\trole\tnaming_string_or_unit\tidentity\n")
    for r in CH:
        h.write("\t".join(r) + "\n")

print("tables written to", OUT)
sys.exit(1 if bad else 0)
