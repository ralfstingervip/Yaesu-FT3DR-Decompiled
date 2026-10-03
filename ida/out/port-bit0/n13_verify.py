# -*- coding: utf-8 -*-
"""Lane N13 (doc 140): byte-check every citation and write sites.tsv / verify.tsv.
Read-only. Run: python n13_verify.py   (paths are absolute)."""
import sys
from pathlib import Path
REPO = Path(__file__).resolve().parents[3].as_posix()  # repository root
import hashlib, os, sys
ROOT = REPO
OUT = os.path.join(ROOT, r"ida\out\port-bit0")
sys.exit('The firmware image is not in this repository.')
MAIN = open(os.path.join(ROOT, r"decrypted\FT3D_MAIN_ver102_EXP.bin"), "rb").read()
SUB = open(os.path.join(ROOT, r"decrypted\FT3D_SUB_ver102_ALL.bin"), "rb").read()
H = {"MAIN": "8e3ecd05409b2c314ebed77320ece5930bf31c8333cd84aeef4f6b0264c1bcce",
     "SUB": "b93570b3c2f69ccb51c113c893b4bc4c414cf78ceddde478748404e0768c6230"}
assert hashlib.sha256(MAIN).hexdigest() == H["MAIN"], "MAIN hash"
assert hashlib.sha256(SUB).hexdigest() == H["SUB"], "SUB hash"


def off(img, a):
    return a if img == "MAIN" else a - 0xFFC00000


def get(img, a, n):
    d = MAIN if img == "MAIN" else SUB
    o = off(img, a)
    return d[o:o + n]


# sites.tsv: every instruction naming MAIN 0xFFFF4E, the bit-0 consumers, and the SUB P24 writers.
# (id, img, addr, bytes, insn, func, reg, bits, access, feeds, status, note)
SITES = [
 ("R01", "MAIN", 0x002564, "2a 4e ea 40", "mov.b @0x4E:8,r2l ; and.b #0x40,r2l", "sub_24B6", "0xFFFF4E", "b6", "read", "boot loop exit test", "Confirmed", "bit 0 masked off"),
 ("R02", "MAIN", 0x0029E4, "2c 4e", "mov.b @0x4E:8,r4l", "sub_29CA (vec 71 IRQ7)", "0xFFFF4E", "b3", "read", "FF8171 (btst #3,r4l at 0x0029EE/0x0029F4)", "Confirmed", "bit 0 unused"),
 ("R03", "MAIN", 0x002A6C, "2c 4e", "mov.b @0x4E:8,r4l", "sub_2A60 (vec 74 IRQ10)", "0xFFFF4E", "b1", "read", "FFBBE3 (btst #1,r4l at 0x002A76/0x002A7C)", "Confirmed", "bit 0 unused"),
 ("R04", "MAIN", 0x00325A, "2a 4e ea 40", "mov.b @0x4E:8,r2l ; and.b #0x40,r2l", "sub_325A", "0xFFFF4E", "b6", "read", "state table via A9E0", "Confirmed", "bit 0 masked off"),
 ("R05", "MAIN", 0x00DDE6, "7e 4e 77 20", "bld #2,@0x4E:8", "sub_DDE4", "0xFFFF4E", "b2", "read", "FF8011 market strap (docs 50/96)", "Confirmed", ""),
 ("R06", "MAIN", 0x00DDEE, "7e 4e 77 20", "bld #2,@0x4E:8", "sub_DDE4", "0xFFFF4E", "b2", "read", "FF8011 (second sample)", "Confirmed", ""),
 ("R07", "MAIN", 0x00FC66, "2a 4e ea 80", "mov.b @0x4E:8,r2l ; and.b #0x80,r2l", "sub_FC66", "0xFFFF4E", "b7", "read", "PTT state A9EA / raw 0x17,0x18", "Confirmed", "bit 0 masked off"),
 ("R08", "MAIN", 0x00FD5E, "2a 4e ea 10", "mov.b @0x4E:8,r2l ; and.b #0x10,r2l", "sub_FD5E", "0xFFFF4E", "b4", "read", "side key A9EB", "Confirmed", "bit 0 masked off"),
 ("R09", "MAIN", 0x01013C, "7e 4e 73 50", "btst #5,@0x4E:8", "sub_100E4", "0xFFFF4E", "b5", "read", "FFBBF4.b6/b7", "Confirmed", ""),
 ("R10", "MAIN", 0x0106DC, "7e 4e 73 00", "btst #0,@0x4E:8", "sub_106D4 (keyer state 1)", "0xFFFF4E", "b0", "read", "set -> A9ED=0x17, BB93=2, 95A3=byte[0x1070C+FF89BC]", "Confirmed", "BIT 0 READER"),
 ("R11", "MAIN", 0x010712, "7e 4e 73 00", "btst #0,@0x4E:8", "sub_10712 (keyer state 2)", "0xFFFF4E", "b0", "read", "set -> 95A3 reload; clear and 95A3==0 -> A9ED=0x18, BB93=3/0", "Confirmed", "BIT 0 READER"),
 ("R12", "MAIN", 0x049468, "2c 4e ec 80", "mov.b @0x4E:8,r4l ; and.b #0x80,r4l", "sub_49468", "0xFFFF4E", "b7", "read", "gate for jsr sub_49400", "Confirmed", "bit 0 masked off"),
 ("D01", "MAIN", 0x01AD98, "23 4e 23 4e", "(IDA head, no function)", "-", "-", "-", "none", "-", "Data", "JIS label count table 0x01AD1C-0x01AFEE (doc 102); not proven code"),
 ("D02", "MAIN", 0x01AEBA, "25 4e 25 4e", "(IDA head, no function)", "-", "-", "-", "none", "-", "Data", "same JIS table"),
 ("D03", "MAIN", 0x01AFAE, "24 4e 24 4e", "(IDA head, no function)", "-", "-", "-", "none", "-", "Data", "same JIS table"),
 ("D04", "MAIN", 0x0458E6, "2c 4e 2c 30", "(IDA head in sub_458D8)", "-", "-", "-", "none", "-", "Data", "ASCII ',N,0' inside $GPWPL template 0x0458D8 (docs 05/14); not proven code"),
 ("F01", "MAIN", 0x00FBB2, "5e 01 05 be", "jsr sub_105BE", "key scan", "-", "-", "call", "only caller of the keyer; runs when A9ED<0 (no other key event)", "Confirmed", ""),
 ("F02", "MAIN", 0x0105BE, "6a 0c 89 bb 46 14", "mov.b @FF89BB,r4l ; bne", "sub_105BE", "FF89BB", "-", "read", "VOX setting 0 -> BB93=0 (0x0105D2)", "Confirmed", ""),
 ("F03", "MAIN", 0x010690, "6a 10 89 20 73 00 46 12", "btst #0,@FF8920 ; bne", "sub_105BE", "FF8920", "b0", "read", "BT on -> bclr #6,@0x50 (0x0106AA) else bset (0x01069E)", "Confirmed", ""),
 ("F04", "MAIN", 0x0106AE, "6a 0b bb 93", "mov.b @FFBB93,r3l", "sub_105BE", "FFBB93", "-", "read", "jump table 0x0106C4 by state", "Confirmed", ""),
 ("F05", "MAIN", 0x0106C4, "00 01 05 d6 00 01 06 d4 00 01 07 12 00 01 07 38", "BE32 x4", "sub_105BE", "-", "-", "table", "state 0 rts / 1 sub_106D4 / 2 sub_10712 / 3 sub_10738", "Confirmed", "data, named"),
 ("F06", "MAIN", 0x0106E8, "fc 17 6a 8c a9 ed", "mov.b #0x17 ; mov.b r4l,@FFA9ED", "sub_106D4", "FFA9ED", "-", "write", "raw key code 0x17", "Confirmed", "same code as PTT press 0x00FCCE"),
 ("F07", "MAIN", 0x0106EE, "fc 02 6a 8c bb 93", "mov.b #2 ; mov.b r4l,@FFBB93", "sub_106D4", "FFBB93", "-", "write", "keyer state 2", "Confirmed", ""),
 ("F08", "MAIN", 0x010706, "6a 8c 95 a3", "mov.b r4l,@FF95A3", "sub_106D4/sub_10712", "FF95A3", "-", "write", "hang count from byte[0x01070C+FF89BC]", "Confirmed", ""),
 ("F09", "MAIN", 0x01071E, "fc 18 6a 8c a9 ed", "mov.b #0x18 ; mov.b r4l,@FFA9ED", "sub_10712", "FFA9ED", "-", "write", "raw key code 0x18", "Confirmed", "same code as PTT release 0x00FCE6"),
 ("F10", "MAIN", 0x010732, "6a 8c bb 93", "mov.b r4l,@FFBB93", "sub_10712", "FFBB93", "-", "write", "3 if FF94C0==1 else 0", "Confirmed", ""),
 ("F11", "MAIN", 0x00FBD4, "fb 09 18 bc 6a 8c a9 ed", "mov.b #9,r3l ; sub.b ; mov.b r4l,@FFA9ED", "key scan", "FFA9ED", "-", "write", "raw >= 0x0A minus 9: 0x17 -> 14, 0x18 -> 15", "Confirmed", ""),
 ("F12", "MAIN", 0x00FB0C, "7e 50 73 60 46 14 6a 0c bb 93 46 0e", "btst #6,@0x50 ; bne ; mov.b @FFBB93 ; bne", "key scan", "FFBB93", "-", "read", "armed keyer skips PTT scan sub_FC66 and zeroes A9EA (0x00FB26)", "Confirmed", "only BB93 reader outside keyer"),
 ("P01", "MAIN", 0x00229A, "fc 00 6a 8c fb 8e", "mov.b #0 ; mov.b r4l,@FFFB8E", "sub_20FA", "FFFB8E", "all", "write", "DDR (port F, Inferred) = 0", "Confirmed", "bit 0 input"),
 ("P02", "MAIN", 0x002548, "fc 00 6a 8c fb 8e", "mov.b #0 ; mov.b r4l,@FFFB8E", "sub_24B6", "FFFB8E", "all", "write", "DDR = 0", "Confirmed", ""),
 ("P03", "MAIN", 0x002740, "6a 8a fb 8e", "mov.b r2l,@FFFB8E (r2l=0 from 0x00271A fa 00)", "nmi_handler", "FFFB8E", "all", "write", "DDR = 0", "Confirmed", ""),
 ("P04", "MAIN", 0x0027F0, "6a 8a fb 8e", "mov.b r2l,@FFFB8E (r2=0 from 0x0027C4 79 02 00 00)", "nmi_handler", "FFFB8E", "all", "write", "DDR = 0", "Confirmed", ""),
 ("P05", "MAIN", 0x002290, "fc 00 3c 5e", "mov.b #0 ; mov.b r4l,@0x5E:8", "sub_20FA", "FFFF5E", "all", "write", "data register = 0", "Confirmed", ""),
 ("P06", "MAIN", 0x00253E, "fc 00 3c 5e", "mov.b #0 ; mov.b r4l,@0x5E:8", "sub_24B6", "FFFF5E", "all", "write", "data register = 0", "Confirmed", ""),
 ("S01", "SUB", 0xFFF36F7B, "fb ee 22 c0 08 f8 e4 00", "mov.l #8C022h,r14 ; mov.b #0,[r14]", "sub_FFF36F03", "P2.PODR", "all", "write", "init 0", "Confirmed", ""),
 ("S02", "SUB", 0xFFF36F9F, "fb ee 02 c0 08 f0 e4", "mov.l #8C002h,r14 ; bset #4,[r14].b", "sub_FFF36F03", "P2.PDR", "b4", "write", "P24 output", "Confirmed", ""),
 ("S03", "SUB", 0xFFF3B12E, "fb ee 22 c0 08 f0 e4", "mov.l #8C022h,r14 ; bset #4,[r14].b", "sub_FFF3B115", "P2.PODR", "b4", "write", "level >= [1252C+4]<<4", "Confirmed", ""),
 ("S04", "SUB", 0xFFF3B136, "fb ee 22 c0 08 f0 ec", "mov.l #8C022h,r14 ; bclr #4,[r14].b", "sub_FFF3B115", "P2.PODR", "b4", "write", "level below threshold", "Confirmed", "bclr itself at FFF3B13B"),
 ("S05", "SUB", 0xFFF39E11, "fb ee 22 c0 08 f0 ec", "mov.l #8C022h,r14 ; bclr #4,[r14].b", "sub_FFF39D6B op 2", "P2.PODR", "b4", "write", "detector stop", "Confirmed", ""),
 ("S06", "SUB", 0xFFF3B74C, "39 c9 f9", "bsr.w sub_FFF3B115", "sub_FFF3B69B pump", "-", "-", "call", "only when [122B0]==6 (FFF3B71F)", "Confirmed", ""),
 ("S07", "SUB", 0xFFF3853B, "b6 11 64 31 fb 22 20 25 01 00 80 29", "movu.b 18h[r1],r1 ; and #3 ; mov.b r1,1[12520h]", "sub_FFF3850B", "hdr+0x18", "b1-0", "read", "VOX mode from MAIN header (MAIN 0x007DE0/0x007DEE)", "Confirmed", ""),
 ("S08", "SUB", 0xFFF38582, "b6 19 fb 22 20 25 01 00 90 a1", "movu.b 19h[r1],r1 ; mov.w r1,4[12520h]", "sub_FFF3850B", "hdr+0x19", "-", "read", "threshold (MAIN table 0x007E2C by FF89BB)", "Confirmed", ""),
]

# extra citations used in doc 140 (img, addr, bytes)
CITES = [
 ("MAIN", 0x0029EE, "73 3c"), ("MAIN", 0x002A76, "73 1c"), ("MAIN", 0x0105D2, "6a 8c bb 93"),
 ("MAIN", 0x01069E, "7f 50 70 60"), ("MAIN", 0x0106AA, "7f 50 72 60"), ("MAIN", 0x01070C, "06 0b 10 15 1a 1f"),
 ("MAIN", 0x00FCCE, "fc 17 6a 8c a9 ed"), ("MAIN", 0x00FCE6, "fc 18 6a 8c a9 ed"), ("MAIN", 0x00FB26, "fc 00 6a 8c a9 ea"),
 ("MAIN", 0x00FAFE, "6a 0c 89 bb 47 14"), ("MAIN", 0x00FB04, "6a 10 89 20 73 00 46 0c"),
 ("MAIN", 0x00FBAC, "6a 0c a9 ed 4a 34 5e 01 05 be"),
 ("MAIN", 0x007DDA, "6a 0d 89 bb 47 14 f5 01"), ("MAIN", 0x007DEE, "f5 02 8d 02 14 5b"),
 ("MAIN", 0x007DF4, "6a 0c 89 bc ec 07 10 4c 14 cb 6a ab 00 ff 3d 8c"),
 ("MAIN", 0x007E0A, "78 50 6a 2b 00 00 7e 2c 6a ab 00 ff 3d 8d"), ("MAIN", 0x007E2C, "00 28 14 2d 18 00"),
 ("MAIN", 0x0482C4, "6a 0c 98 0b 6a 8c bb 92"), ("MAIN", 0x00271A, "fa 00"), ("MAIN", 0x0027C4, "79 02 00 00"),
 ("MAIN", 0x010738, "6a 0c 94 c0 ac 00 46 06 fc 00 6a 8c bb 93"),
 ("SUB", 0xFFF3B13B, "f0 ec"), ("SUB", 0xFFF3B133, "f0 e4"), ("SUB", 0xFFF39E16, "f0 ec"),
 ("SUB", 0xFFF3B11A, "05 c5 a8 fd fb 12 2c 25 01 00 b8 91 6c 41 b8 0a 47 12 29 0a"),
 ("SUB", 0xFFF3B71F, "fb e2 b0 22 01 00 58 ee 61 6e 21 26"),
 ("SUB", 0xFFF385C5, "fb e2 1e 25 01 00 f8 e5 06"), ("SUB", 0xFFF385D0, "fb e2 1e 25 01 00 f8 e5 06"),
 ("SUB", 0xFFF385BA, "fb e2 1e 25 01 00 f8 e5 00"), ("SUB", 0xFFF385EE, "39 7f 01"), ("SUB", 0xFFF38673, "39 92 00"),
 ("SUB", 0xFFF38739, "66 11 05 30 16 00"), ("SUB", 0xFFF3875F, "f8 e5 01"),
 ("SUB", 0xFFF387AE, "66 21 05 bb 15 00"), ("SUB", 0xFFF387BC, "f8 e5 02"),
 ("SUB", 0xFFF39DB1, "fb e2 b0 22 01 00 f8 e4 06"), ("SUB", 0xFFF39DEA, "fb e2 b0 22 01 00 f8 e4 00"),
 ("SUB", 0xFFF39DC3, "fb 12 2c 25 01 00 b0 19 71 1e fe 61 2e 23 10"),
 ("MAIN", 0x0106DC, "7e 4e 73 00 47 28"), ("MAIN", 0x010712, "7e 4e 73 00 46 dc"), ("MAIN", 0x010718, "6a 0c 95 a3"),
 ("MAIN", 0x053EB2, "79 22 4e 20"), ("SUB", 0xFFF3B731, "ec ef 62 1f e3 ef"),
 ("SUB", 0xFFF396B9, "fb ee 22 c0 08 f0 e2"), ("SUB", 0xFFF396F8, "fb ee 22 c0 08 f0 ea"), ("SUB", 0xFFEDC9AD, "fb ee 22 c0 08 f0 ea"),
]

rows, ok, bad = [], 0, 0
allc = [(s[1], s[2], s[3], s[0]) for s in SITES] + [(c[0], c[1], c[2], "cite") for c in CITES]
for img, a, hx, tag in allc:
    want = bytes.fromhex(hx.replace(" ", ""))
    got = get(img, a, len(want))
    r = "PASS" if got == want else "FAIL"
    ok += r == "PASS"
    bad += r != "PASS"
    rows.append("%s\t%s\t%08X\t%06X\t%s\t%s\t%s" % (tag, img, a, off(img, a), hx, got.hex(" "), r))
with open(os.path.join(OUT, "verify.tsv"), "w", encoding="utf-8", newline="\n") as h:
    h.write("tag\timage\taddr\tfile_off\twant\tgot\tresult\n" + "\n".join(rows) + "\n")
with open(os.path.join(OUT, "sites.tsv"), "w", encoding="utf-8", newline="\n") as h:
    h.write("id\timage\taddr\tfile_off\tbytes\tinsn\tfunc\treg\tbits\taccess\tfeeds\tstatus\tnote\n")
    for s in SITES:
        h.write("%s\t%s\t%08X\t%06X\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n" % ((s[0], s[1], s[2], off(s[1], s[2])) + tuple(s[3:])))
print("%d/%d PASS" % (ok, ok + bad))
sys.exit(1 if bad else 0)
