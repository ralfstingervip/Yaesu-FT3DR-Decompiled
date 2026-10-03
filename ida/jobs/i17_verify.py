r"""Lane I17 -- byte-verify the cites of docs\deep\68-sub-final2-seed.md against the image (plain Python).
    python "ida/jobs/i17_verify.py"
Output: ida\out\sub-final2\raw\verify.txt
"""
import sys
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root
import hashlib, os, struct

ROOT = str(_REPO)
BIN = os.path.join(ROOT, r"decrypted\FT3D_SUB_ver102_ALL.bin")
img = sys.exit("The firmware image is not in this repository.")
B = 0xFFC00000
out = ["sha256 %s size %d" % (hashlib.sha256(img).hexdigest(), len(img))]
bad = 0

CITES = [
    # merges
    ("FFEDFFFD", "fbe2d4cd0100", "mov.l #1CDD4h,r14 (end of sub_FFEDFEB9 body)"),
    ("FFEE0003", "f8e601", "mov.l #1,[r14] -- not a stop, falls into FFEE0006"),
    ("FFEE0006", "fbe2c4240100", "old lane-4 start sub_FFEE0006, now inside sub_FFEDFEB9"),
    ("FFEDB0A9", "2e7e", "bra.b FFEDB127 (stop) inside sub_FFEDB081"),
    ("FFEDB0AB", "a889", "loop head reached by jump from FFEDB125"),
    ("FFEDB0B0", "fbe2d82c0100", "old lane-4 start sub_FFEDB0B0"),
    ("FFEDB125", "2986", "blt.b FFEDB0AB (loop back edge)"),
    ("FFEF1F7B", "2e15", "bra.b FFEF1F90"),
    ("FFEF1F87", "09", "bra.s FFEF1F90"),
    ("FFEF1F8D", "e11e03", "mov.l 0Ch[r1],[r14] -- falls into FFEF1F90"),
    ("FFEF1F90", "fbee002808", "mov.l #82800h,r14 (EXDMAC0, doc 16)"),
    ("FFF25700", "200f", "beq.b FFF2570F (from dead sub_FFF256BD)"),
    ("FFF2570D", "2e5e", "bra.b FFF2576B"),
    ("FFF2570F", "fbe22c5e0600", "old lane-4 'xref' start sub_FFF2570F"),
    ("FFF387F8", "10", "beq.s FFF38800 (from dead sub_FFF387C9)"),
    ("FFF13EE8", "2a19", "bgt.b FFF13F01 (from sub_FFF13DEF)"),
    ("FFF13EFF", "2e17", "bra.b FFF13F16 (from sub_FFF13EEA into FFF13F01's body)"),
    # descriptor table
    ("FFECE51C", "00" * 64, "64 B zero pad before descriptor record 0"),
    ("FFECE55C", "1c00140080ebc3ff0000ffff00000000", "descriptor record 0: 28x20 src FFC3EB80"),
    ("FFECE56C", "1c001400", "record 1 starts 16 B later"),
    ("FFECFFFC", "14001e003461c8ff0000ffff00000000", "record 426 straddles FFED0000"),
    ("FFED337C", "08000b001420e4ff0000ffff00000000", "record 1250 (I2 DB: bogus 6-B strlit)"),
    ("FFED3F5C", "1e001e00d06debff0000ffff00000000", "record 1440, ends at FFED3F6C"),
    # low tables
    ("FFEDFBED", "fb3a0c01fb227c41edfffb1290cc01007f8f", "sub_FFEDFBE2: mov.l #10Ch,r3 / #FFED417C,r2 / #1CC90h,r1 / smovf"),
    ("FFED428C", "f383f4ff2284f4ff2d84f4ff", "PMTK char* slots"),
    ("FFED42CC", "0001c0ff44ebc3ffe8e4ecffd17ff4ff6480f4ffc883f4ffc883f4fffc980600348aedff588aedff708aedff708aedff708aedff", "section-address list"),
    ("FFEE4E22", "fbe2a445edff", "mov.l #FFED45A4,r14"),
    ("FFED4644", "0e0e21935675ebff5d01c0ff", "font block 0 (doc 27)"),
    ("FFED4770", "04072000d64becffc862c3ff", "font block 25 (last)"),
    ("FFED477C", "05000700ac62c3ff00000000", "1-bpp glyph descriptor 0"),
    ("FFED49E0", "2224000016a7c3ff", "glyph-table index record 0"),
    ("FFEE59C8", "6c31fbe2e049edff", "shll #3,r1 / mov.l #FFED49E0,r14"),
    ("FFEEF8C9", "fbe2d055edff", "mov.l #FFED55D0,r14"),
    ("FFED55FC", "0100000000000e000200000000000000000000000000000000000000"[:48] + "8ce7ecff", "icon record 1 {id 1, f06 0x0E, f08 2, desc FFECE78C}"),
    ("FFED5614", "8ce7ecff", "icon record 1 desc FFECE78C"),
    ("FFEF34BF", "75111cfb22e055edff", "mul #1Ch,r1 / mov.l #FFED55E0,r2"),
    ("FFED71A8", "0100000002000000", "bit mask table 1<<i"),
    ("FFEFB2C6", "75511f2410fbe2a871edff", "cmp #1Fh,r1 / bgtu / mov.l #FFED71A8,r14"),
    ("FFED74E8", "0000000055ddc3ff090000004ddfc3ff", "menu category table"),
    ("FFF095E9", "6c31fbe2e874edff", "shll #3,r1 / mov.l #FFED74E8,r14"),
    ("FFED7A64", "cc33edff454d455247454e4359202020", "news table A rec 0"),
    ("FFED7AB4", "0c2eedff564f49434520200000000000", "news table B rec 1 'VOICE'"),
    ("FFF0F57F", "6c41fb22a47aedff", "shll #4,r1 / mov.l #FFED7AA4,r2"),
    ("FFF34925", "5eef6301fb52187fedff", "movu.w 2C6h[r14],r15 / mov.l #FFED7F18,r5"),
    ("FFF362F7", "7701ffff7d241575432cfbe2607fedff", "cmp #7DFFFFh,r1 / bgtu / mov.l #2Ch,r3 / mov.l #FFED7F60,r14"),
    ("FFF3B7C1", "751324fb22f881edff", "mul #24h,r3 / mov.l #FFED81F8,r2"),
    ("FFF42A03", "fdc31efbf2d884edff", "shll #3,r1,r14 / mov.l #FFED84D8,r15"),
    ("FFED8528", "0000000000000000" "0100000015efc33e", "sin table k=0,1 (0.0, 0.38268)"),
    ("FFED8974", "14000000", "_nfiles = 20"),
    ("FFF45EA4", "754348", "mov.l #48h,r3 (FILE template size)"),
    ("FFF45EA9", "fb227889edff", "mov.l #FFED8978,r2"),
    ("FFED89E8", "0000000000002440" "0000000000005940", "1e1, 1e2 (double)"),
    ("FFF4601E", "fbd2c089edff", "mov.l #FFED89C0,r13"),
    ("FFF46D32", "fb82308aedff", "mov.l #FFED8A30,r8"),
    # pool
    ("FFF48063", "ff", "pad between 1-byte and 2-byte switch tables"),
    ("FFF483C8", "8004080100000000", "6-B const record + pad"),
    ("FFEDAB4E", "fbe2c883f4ffd4e001", "sub_FFEDAB4C: mov.l #FFF483C8,r14 / mov.w [r14],..."),
    ("FFF4A120", "5b00650010001a00", "rect record 0 (I2 DB: bogus 2-B strlit)"),
    ("FFF07125", "754328fb2248a1f4ff", "mov.l #28h,r3 / mov.l #FFF4A148,r2"),
    ("FFF054C9", "754326fb220098f4ff", "mov.l #26h,r3 / mov.l #FFF49800,r2"),
    ("FFF495E0", "504f534954494f4e00", "'POSITION' slot (char[16])"),
]
for a, hx, what in CITES:
    ea = int(a, 16)
    got = img[ea - B:ea - B + len(hx) // 2].hex()
    ok = got == hx
    bad += not ok
    out.append("%s %s %s  %s%s" % ("ok  " if ok else "FAIL", a, hx[:48], what, "" if ok else "  got " + got))
# font selector bound in sub_FFEF2184 (doc 27: rejects selector >= 0x1A)
seg = img[0xFFEF2184 - B:0xFFEF21C0 - B]
k = seg.find(bytes.fromhex("75511a"))
out.append("%s FFEF2184+%X cmp #1Ah,r1 (75 51 1a) inside sub_FFEF2184 prologue" % ("ok  " if k >= 0 else "FAIL", k))
bad += k < 0
out.append("FAILED %d" % bad)
with open(os.path.join(ROOT, r"ida\out\sub-final2\raw\verify.txt"), "w", encoding="utf-8", newline="\n") as h:
    h.write("\n".join(out) + "\n")
print("\n".join(out[-6:]))
