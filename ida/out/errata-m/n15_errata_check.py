# n15_errata_check.py -- lane N15, errata index for the M wave (doc 142).
# Read-only. No IDA, no device, no write outside this directory.
# Re-reads every anchor byte run from the two plaintext images, runs the computed
# checks, text-checks each row against the owning doc line and the recording line,
# and writes bytecheck.tsv, errata.tsv, sweep.tsv and run.txt next to this script.
# MAIN: H8SX, big-endian, base 0 (file offset = address).
# SUB : RX, little-endian, base 0xFFC00000 (file offset = address - 0xFFC00000).
import sys
from pathlib import Path as _Path
_REPO_S = _Path(__file__).resolve().parents[3].as_posix()
import hashlib, os, re, sys, collections

ROOT = _REPO_S
OUT = os.path.dirname(os.path.abspath(__file__))
MP = os.path.join(ROOT, r"decrypted\FT3D_MAIN_ver102_EXP.bin")
SP = os.path.join(ROOT, r"decrypted\FT3D_SUB_ver102_ALL.bin")
SHA_M = "8e3ecd05409b2c314ebed77320ece5930bf31c8333cd84aeef4f6b0264c1bcce"
SHA_S = "b93570b3c2f69ccb51c113c893b4bc4c414cf78ceddde478748404e0768c6230"
sys.exit("The firmware image is not in this repository.")
sys.exit("The firmware image is not in this repository.")
hm, hs = hashlib.sha256(M).hexdigest(), hashlib.sha256(S).hexdigest()
if hm != SHA_M or hs != SHA_S:
    sys.exit("IMAGE HASH MISMATCH: %s %s" % (hm, hs))
RECON = os.path.join(ROOT, r"ida\out\m-wave-recon")
P7 = open(os.path.join(RECON, "final7_proven_mask.bin"), "rb").read()
N7 = open(os.path.join(RECON, "final7_named_mask.bin"), "rb").read()
P6 = open(os.path.join(ROOT, r"ida\out\l-wave-recon\final6_proven_mask.bin"), "rb").read()
SUBBASE = 0xFFC00000

def rd(addr, n):
    if addr >= SUBBASE:
        o = addr - SUBBASE
        return S[o:o + n], "S", o
    return M[addr:addr + n], "M", addr

def hx(b):
    return " ".join("%02x" % x for x in b)

def findall(img, pat, lo=0, hi=None):
    hi = len(img) if hi is None else hi
    r, i = [], img.find(pat, lo, hi)
    while i >= 0:
        r.append(i)
        i = img.find(pat, i + 1, hi)
    return r

# ---------------------------------------------------------------- byte checks
# (id, address, expected bytes, meaning). PASS = image equals expected.
C = [
 ("C01", 0x009294, "6a 0c 8e b2 7a 64 00 00 00 ff 78 40 6a 2b 00 00 93 2c",
  "mov.b @0x8EB2:16,r4l (009294); and.l #0xFF,er4 (009298); mov.b @(0x932C:32,er4),r3l (00929E): base 0x932C, index 0..0xFF"),
 ("C02", 0x00932A, "05 04 02 03 04 04 04 00", "0x932A..0x9331; 0x932A-0x932B (05 04) lie 2 B below the reader base"),
 ("C03", 0x063C04, "fc 00 6a 8c b2 a3 fc 01 6a 8c b2 a5 fc 0a 6a 8c a9 f9",
  "routine entry 063C04: B2A3=0 (063C04); B2A5=1 (063C0A); mode 10: mov.b #0x0A,r4l (063C10), mov.b r4l,@A9F9 (063C12)"),
 ("C04", 0x01CE9A, "5e 06 3c 04", "jsr @0x063C04 (caller 1)"),
 ("C05", 0x01CEAA, "5e 06 3c 04", "jsr @0x063C04 (caller 2)"),
 ("C06", 0xFFEDCE56, "fb 12 44 2d 01 00 b1 19 75 51 f3",
  "mov.l #0x12D44,r1; movu.b 5[r1],r1 (= F[0], F = 0x12D49); cmp #0xF3,r1"),
 ("C07", 0xFFEDCE76, "fb 12 44 2d 01 00 b6 11 61 31",
  "mov.l #0x12D44,r1; movu.b 0x18[r1],r1 (= byte 0x12D5C = F+0x13); cmp #3,r1"),
 ("C08", 0x03510A, "00 0a 00 05 04 00 00 00 07 59 95 00 00 00", "VHF table: stride 10, count 5; 40.000-75.995 MHz -> 0"),
 ("C09", 0x035140, "00 0a 00 02 30 00 00 00 41 99 95 00 00 05 42 00 00 00 57 99 95 00 00 06",
  "UHF table: stride 10, count 2; 300.000-419.995 -> 5; 420.000-579.995 -> 6"),
 ("C10", 0x01BF40, "ac 02 45 32 ac 0c 44 2e", "sub_1BF40: cmp.b #2,r4l; bcs; cmp.b #0x0C,r4l; bcc -> codes >= 0x0C dropped"),
 ("C11", 0x000476, "79 04 0b a0", "mov.w #0x0BA0,r4 (TPU0 period 2976+1 = 2977 -> 16e6/2977 = 5374.5 Hz)"),
 ("C12", 0x0351D6, "fc 20 3c d0 79 04 00 00 6b 84 ff d6 79 04 09 89 6b 84 ff d8",
  "sub_351D6: TCR1 (FFFFD0) = 0x20; TCNT1 = 0; TGRA1 (FFFFD8) = 0x0989 (2441+1 = 2442 -> 6552.0 Hz)"),
 ("C13", 0x002336, "fc 02 6a 8c fe c1", "mov.b #2,r4l; mov.b r4l,@0xFEC1:16 (8-bit timer clock select = 2)"),
 ("C14", 0x00FBBE, "77 0b 6a 18 a9 ee 67 00 fc 16", "A9EE.b0 = r3l.b0; mov.b #0x16 (raw event 13)"),
 ("C15", 0x00A210, "79 04 f3 96", "mov.w #0xF396 (DIAL KNOB CHANGE F-code)"),
 ("C16", 0x00A228, "6a 0b 89 b5", "mov.b @0x89B5:16,r3l (FF89B5)"),
 ("C17", 0x06ADE6, "0c cb 58 70 00 28 eb 07 5e 06 ac d6 58 00 00 1e",
  "M4 dead-arm head: mov.b r4l,r3l; beq; and.b #7,r3l; jsr @0x06ACD6; bra"),
 ("C18", 0x06ACD6, "0f 95 7a 15 00 00 00 2e", "0x06ACD6 is an ordinary routine prologue (not a switch helper)"),
 ("C19", 0x06B14C, "ab 06 47 40 f2 00 fa 08 5e 06 75 22", "jsr @0x067522 at 06B154 (region 06B10E-06B25B, after rts 06B10C)"),
 ("C20", 0x06B18C, "b1 ec 59 60 f2 00 fa 0a 5e 06 75 22", "jsr @0x067522 at 06B194 (same region)"),
 ("C21", 0x06B3C4, "5e 06 1d 6e f2 00 fa 01 5e 06 75 22", "jsr @0x067522 at 06B3CC (region 06B3BE-06B407, after rts 06B3BC)"),
 ("C22", 0x06B4F6, "5e 06 75 22", "jsr @0x067522 inside 06B4B0 (M1)"),
 ("C23", 0x06B536, "5e 06 75 22", "jsr @0x067522 inside 06B4B0 (M1)"),
 ("C24", 0x02B3F6, "5e 06 5d 26", "jsr @0x065D26 covers claimed 02B3F8"),
 ("C25", 0x02B44E, "5e 06 5d 66", "jsr covers claimed 02B450"),
 ("C26", 0x05569A, "5e 05 59 76", "jsr covers claimed 05569C"),
 ("C27", 0x0559B0, "7a 05 00 ff 59 06", "mov.l #0xFF5906,er5 covers claimed 0559B4"),
 ("C28", 0x0559C6, "7a 06 00 ff 59 06", "mov.l covers claimed 0559CA"),
 ("C29", 0x076308, "59 06", "the one real bra r0.w"),
 ("C30", 0x03F5B2, "01 00 6d f2 6d 62 79 0a 00 00 6d 63 01 00 69 64", "sub_3F5B2 head as in the image"),
 ("C31", 0x01E1BE, "10 73 78 b0 6b 26 00 01 e1 de", "shll.l #2,er3 (01E1BE); mov.l @(0x1E1DE:32,er3),er6 (01E1C0, 8 B)"),
 ("C32", 0x01E1C8, "01 10 6d 75", "first dead instruction after the operand tail"),
 ("C33", 0x017924, "7a 05 00 01 79 2e 5a 01 52 60", "mov.l #0x01792E,er5; jmp @0x015260"),
 ("C34", 0x01792E, "00 01 a0 d4 00 01 79 4e 00 01 79 56 00 01 79 5e", "record 0x01792E fields 0-3"),
 ("C35", 0x01794E, "fc 00 5e 01 8f aa 40 32", "field 1 handler: mov.b #0,r4l; jsr @0x018FAA; bra"),
 ("C36", 0x015288, "10 72 0a a5 01 00 69 56 47 08 5d 60", "sub_15260: er6 = [rec + 4*AD68]; jsr @er6"),
 ("C37", 0x018FAA, "6a 18 8a ac 61 c0", "bnot r4l,@0x8AAC:16 (live twin entry)"),
 ("C38", 0x000E1E, "00 7f 31 9c", "slot 13 of 0x000DEA {u8 flag,u8 level,u16 mag}; 0x000E20 = 31 9c"),
 ("C39", 0x000938, "78 e0 6b 26 00 00 0d ea", "reader of base 0x000DEA"),
 ("C40", 0x014F8E, "78 30 6a 2b 00 01 51 8c", "mov.b @(0x01518C:32,er3),r3l -> u8 map 0x01518C"),
 ("C41", 0x006A06, "40 12", "bra before 0x006A08 block"),
 ("C42", 0x0077CC, "40 36", "bra before 0x0077CE block"),
 ("C43", 0x073EB4, "a1 17 44 24", "'A': cmp.b #0x17,r1h; bcc (>= 0x17 NAK)"),
 ("C44", 0x073ECE, "fc 09 18 c1 6a 81 a9 ed", "'A': key-event store to A9ED"),
 ("C45", 0x073E86, "5e 03 4a 52", "jsr @0x034A52"),
 ("C46", 0x073E8E, "5e 03 50 e4", "jsr @0x0350E4"),
 ("C47", 0x0743BA, "fc 01 6a 8c b0 cc", "B0CC = 1 (imm 0743BA, store 0743BC)"),
 ("C48", 0x0743CA, "fc 00 6a 8c b0 cc", "B0CC = 0 (imm 0743CA, store 0743CC)"),
 ("C49", 0x031BEE, "fc c8 6a 8c 95 89", "imm 031BEE, store FF9589 at 031BF0"),
 ("C50", 0x030240, "fc 05 6a 8c aa ce", "AACE = 5"),
 ("C51", 0x031CD2, "fc 05 6a 8c aa ce", "AACE = 5 (band-B twin)"),
 ("C52", 0x00FAFE, "6a 0c 89 bb 47 14", "VOX test (what 0x00FAFE really holds)"),
 ("C53", 0x00FB04, "6a 10 89 20 73 00 46 0c", "btst #0,@0x8920:16; bne (the Bluetooth-ON test)"),
 ("C54", 0xFFF387B6, "fb e2 b8 2c 01 00 f8 e5 02", "mov.l #0x12CB8,r14; mov.w #2,[r14]"),
 ("C55", 0xFFF38759, "fb e2 b8 2c 01 00 f8 e5 01", "12CB8 = 1"),
 ("C56", 0xFFF388EB, "fb e2 b8 2c 01 00 f8 e5 01", "12CB8 = 1"),
 ("C57", 0xFFF38F75, "fb e2 b8 2c 01 00 f8 e5 01", "12CB8 = 1 (mov.w at FFF38F7B)"),
 ("C58", 0xFFF38467, "39 7b 00", "bsr.w FFF384E2 (TXAT=1 re-send path per M12)"),
 ("C59", 0xFFEDD019, "05 f2 b4 05", "bsr.a FFF3850B from the common frame path"),
 ("C60", 0xFFF3851D, "b6 11 75 21 20", "movu.b 0x18[r1],r1; and #0x20,r1 -> 1229D"),
 ("C61", 0xFFEDD533, "fb e2 44 2d 01 00 c9 0e 0f f6 95", "mov.l #0x12D44,r14; mov.b 0x0F[r0],0x95F6[r14] -> 0x1C33A"),
 ("C62", 0xFFEDD706, "fb e2 44 2d 01 00 c9 0e 0f 76 96", "mov.l #0x12D44,r14; mov.b 0x0F[r0],0x9676[r14] -> 0x1C3BA"),
 ("C63", 0xFFEDD8F4, "fb e2 44 2d 01 00 c9 0e 0b f6 96", "FE builder: 0x96F6[r14] -> 0x1C43A"),
 ("C64", 0xFFF394CF, "05 59 40 fa", "bsr.a FFEDD528 (E5/E6 sender)"),
 ("C65", 0xFFF39516, "05 12 40 fa", "bsr.a FFEDD528"),
 ("C66", 0xFFF38AEA, "05 3e 4a fa", "bsr.a FFEDD528 (E4 path per M12)"),
 ("C67", 0x073292, "ac 03", "cmp.b #3,r4l (MAIN E4 reader)"),
 ("C68", 0x054D50, "01 10 6d f4 6a 0c 81 3a", "vector-234 entry: push; mov.b @0x813A:16,r4l at 054D54"),
 ("C69", 0x05E376, "00 0f 00 ff b9 ed", "descriptor for 0x0296E8: max 15"),
 ("C70", 0x05E3B4, "00 03 00 ff b9 ed", "descriptor for 0x029712: max 3"),
 ("C71", 0x014984, "7a 24 00 06 66 00", "cmp.l #0x00066600,er4 (666.00 kHz BCD)"),
 ("C72", 0x0149A0, "7a 24 00 06 66 00", "cmp.l #0x00066600,er4"),
 ("C73", 0x03FB32, "7a 06 00 ff 91 02", "mov.l #0xFF9102,er6 (= FF90F0+0x12)"),
 ("C74", 0x022176, "00 05 00 00 00 17 95 00", "broadcast band row 0.50000-1.79500 MHz (BCD, 10 Hz)"),
 ("C75", 0x00216A, "7a 04 00 ff 8e e0", "A record FF8EE0"),
 ("C76", 0x00217E, "7a 04 00 ff 8f e8", "B record FF8FE8"),
 ("C77", 0xFFF3A50B, "61 c1", "cmp #12,r1 (FIND <addr12>)"),
 ("C78", 0xFFF3A57F, "61 f1", "cmp #15,r1"),
 ("C79", 0xFFF3A77B, "f8 e4 05", "mov.b #5,[r14] (PAIR=<addr> -> linked)"),
 ("C80", 0xFFF3A8CF, "75 51 2b", "cmp #0x2B,r1 ('+' of ERROR+SCOI)"),
 ("C81", 0x07336C, "ac 09", "cmp.b #9,r4l (F3D5 delete flow -> PINF)"),
 ("C82", 0xFFF383DE, "05 8a 18 00", "F3D5 flow: bsr.a FFF39C68"),
 ("C83", 0xFFF381A8, "05 9d 16 00", "F3D6 flow: bsr.a FFF39845"),
 ("C84", 0x0032D2, "2c 94", "mov.b @0x94:8,r4l (byte read of FFFF94)"),
 ("C85", 0x003346, "2c 90", "mov.b @0x90:8,r4l (AN0, byte read)"),
 ("C86", 0x00010C, "00 00 24 b6", "vector 67 (0x10C = 67*4) -> sub_24B6"),
 ("C87", 0x0021EE, "fc 00 3c a0 3c a1", "ADCSR/ADCR zeroed at init"),
 ("C88", 0x0029A8, "3e 68", "mov.b r6l,@0x68:8 (DA0 at FFFF68)"),
 ("C89", 0xFFEE2220, "66 03 7f 13", "mov.l #0,r3; jsr r3"),
 ("C90", 0xFFEE223B, "66 03 7f 13", "mov.l #0,r3; jsr r3"),
 ("C91", 0x073A34, "78 b0 6b 26 00 07 44 72", "8-byte indexed load; 0x073A36 is inside it"),
 ("C92", 0x01101A, "6a 0c aa d4 ec 01 46 02", "mov.b @AAD4,r4l; and.b #1,r4l; bne -> n = 9"),
 ("C93", 0x062972, "7a 05 00 ff b3 2e", "mov.l #0xFFB32E,er5 (the er5 overwrite)"),
 ("C94", 0x062962, "7a 05 00 06 21 78", "what 0x062962 holds: mov.l #0x062178,er5"),
 ("C95", 0x01D33E, "6e 0c 00 06 46 0e", "mov.b @(6,er0),r4l; bne: BE32 00 06 46 0e starts at 01D340"),
 ("C96", 0x01D35E, "6e 0c 00 06 46 10", "the second cite 0x01D360 = 00 06 46 10 is right as written"),
 ("C97", 0x0767BC, "54 13", "one rts/l (er2-er3)"),
 ("C98", 0x062806, "40 16 5e 06 6f b4 40 10 5e 06 72 50 40 0a 5e 06 72 6a 40 04 5e 06 6f aa 54 70",
  "arms: jsr 066FB4 (062808), jsr 067250 (06280E), jsr 06726A (062814), jsr 066FAA (06281A)"),
 ("C99", 0x06723A, "5e 06 6f b4 58 00 00 0c 55 0c 40 08 55 22 40 04 5e 06 6f aa 54 70",
  "jsr 066FB4 (06723A); jsr 066FAA (06724A)"),
]
# as-written runs that must DIFFER from the image at the cited address (the slip itself)
W = [
 ("W01", 0x063C04, "fc 0a 6a 8c a9 f9", "122:117 as written"),
 ("W02", 0x06ADE4, "0c cb 58 70 00 28 eb 07 5e 06 ac d6 58 00 00 1e", "RESUME:36 / recon README:22 as written"),
 ("W03", 0x03F5B2, "6d 62 6d 63 01 00 69 64", "100:126 as written (contiguous)"),
 ("W04", 0x073E88, "5e 03 4a 52", "104:164 as written"),
 ("W05", 0x073E90, "5e 03 50 e4", "104:164 as written"),
 ("W06", 0x0743BC, "fc 01 6a 8c b0 cc", "106:130 and opcode-1c.tsv:39 as written"),
 ("W07", 0x0743CC, "fc 00 6a 8c b0 cc", "opcode-1c.tsv:40 as written (new)"),
 ("W08", 0x030242, "fc 05 6a 8c aa ce", "106:153 as written"),
 ("W09", 0x031CD4, "fc 05 6a 8c aa ce", "106:153 as written"),
 ("W10", 0x00FAFE, "6a 10 89 20 73 00 46 0c", "107:119 as written"),
 ("W11", 0x054D50, "6a 0c 81 3a 58 60 01 4c", "112:84 as written"),
 ("W12", 0x062962, "7a 05 00 ff b3 2e", "101:99 as written"),
 ("W13", 0x01D33E, "00 06 46 0e", "101:103 as written (BE32 at 01D33E)"),
 ("W14", 0x031BEE, "6a 8c 95 89", "106:151 as written (store at 031BEE)"),
]

rows_b = []
res = {}
for cid, a, exp, mean in C:
    e = bytes.fromhex(exp.replace(" ", ""))
    got, img, off = rd(a, len(e))
    ok = got == e
    res[cid] = "PASS" if ok else "FAIL"
    rows_b.append((cid, img, "%06X" % a if img == "M" else "%08X" % a, "0x%06X" % off, exp, hx(got), res[cid], mean))
for wid, a, exp, mean in W:
    e = bytes.fromhex(exp.replace(" ", ""))
    got, img, off = rd(a, len(e))
    res[wid] = "SLIP-CONFIRMED" if got != e else "NO-SLIP"
    rows_b.append((wid, img, "%06X" % a if img == "M" else "%08X" % a, "0x%06X" % off, exp, hx(got), res[wid], mean))

# ---------------------------------------------------------------- computed checks
X = []
def xadd(xid, ok, detail, scope):
    res[xid] = "PASS" if ok else "FAIL"
    X.append((xid, res[xid], detail, scope))

# X01 no reference of any form to 0x00932A; base 0x932C referenced once
r32a = findall(M, bytes.fromhex("00932a"), 0, 0x80000)
r32c = findall(M, bytes.fromhex("0000932c"), 0, 0x80000)
xadd("X01", r32a == [] and r32c == [0x0092A2],
     "BE24/BE32/abs24 '00 93 2a' hits=%s; '00 00 93 2c' hits=%s" % ([hex(x) for x in r32a], [hex(x) for x in r32c]),
     "MAIN 0x000000-0x07FFFF, every offset")
# X02 jsr 063C04 sites, and every A9F9 <- 0x0A store
j = findall(M, bytes.fromhex("5e063c04"), 0, 0x80000)
s0a = findall(M, bytes.fromhex("fc0a6a8ca9f9"), 0, 0x80000)
xadd("X02", j == [0x01CE9A, 0x01CEAA] and 0x063C10 in s0a,
     "jsr @063C04 at %s; 'fc 0a 6a 8c a9 f9' at %s (P7: %s)" % ([hex(x) for x in j], [hex(x) for x in s0a], [P7[x] for x in s0a]),
     "MAIN 0x000000-0x07FFFF")
# X03 band tables decoded
def bcd(b): return int(b.hex()) / 1e5   # 10 Hz units -> MHz
def tbl(a):
    st, n = int.from_bytes(M[a:a+2], "big"), int.from_bytes(M[a+2:a+4], "big")
    out = []
    for k in range(n):
        e = M[a+4+st*k:a+4+st*k+st]
        out.append("%.3f-%.3f->%d" % (bcd(e[0:4]), bcd(e[4:8]), int.from_bytes(e[8:10], "big")))
    return out
v, u = tbl(0x03510A), tbl(0x035140)
xadd("X03", u[0] == "300.000-419.995->5" and v[-1] == "222.000-229.995->4",
     "VHF 0x03510A %s ; UHF 0x035140 %s" % (v, u), "two tables")
# X04 DCS table: bit-reversed low 9 bits = standard list; Golay(23,12) g=0xC75
STD = ("023 025 026 031 032 036 043 047 051 053 054 065 071 072 073 074 114 115 116 122 125 131 132 134 143 145 "
       "152 155 156 162 165 172 174 205 212 223 225 226 243 244 245 246 251 252 255 261 263 265 266 271 274 306 "
       "311 315 325 331 332 343 346 351 356 364 365 371 411 412 413 423 431 432 445 446 452 454 455 462 464 465 "
       "466 503 506 516 523 526 532 546 565 606 612 624 627 631 632 654 662 664 703 712 723 731 732 734 743 754").split()
E = [int.from_bytes(M[0xB8C+4*i:0xB90+4*i], "big") for i in range(104)]
def rev23(x): return int(bin(x)[2:].zfill(23)[::-1], 2)
def gmod(x, g=0xC75):
    for b in range(22, 10, -1):
        if x >> b & 1: x ^= g << (b - 11)
    return x
W23 = [rev23(e >> 9) for e in E]
codes = [oct(w & 0x1FF)[2:].zfill(3) for w in W23]
xadd("X04", all(e & 0x1FF == 0 for e in E) and codes == STD and all(gmod(w) == 0 for w in W23),
     "104 BE32 at 0x000B8C, low 9 bits zero; bit-reversed low 9 = D023..D754 in order; all 104 divisible by g=0xC75",
     "0x000B8C-0x000D2B")
# X05 tone arithmetic
xadd("X05", round(16e6/2442, 1) == 6552.0 and round(16e6/2977/40, 2) == 134.36 and round(250000/(2*72), 1) == 1736.1,
     "TPU1 16e6/2442=%.1f Hz; DCS 16e6/2977/40=%.2f bps; T-CALL 250 kHz/(2*(0x47+1))=%.1f Hz" %
     (16e6/2442, 16e6/2977/40, 250000/144), "arithmetic on C11-C13")
# X06 off_74472 entries; leaf call sites; mask state
tab = [int.from_bytes(M[0x074472+4*i:0x074476+4*i], "big") for i in range(48)]
leaves = [0x066FB4, 0x067250, 0x066FBE, 0x06726A]
sites = {}
for t in leaves + [0x066FAA]:
    sites[t] = [x for op in (0x5E, 0x5A) for x in findall(M, bytes([op, t >> 16 & 255, t >> 8 & 255, t & 255]), 0, 0x80000)]
be = {t: findall(M, t.to_bytes(4, "big"), 0, 0x80000) for t in leaves}
leafsites = sorted(x for t in leaves for x in sites[t])
xadd("X06", not (set(tab) & set(leaves)) and all(P7[x] == 0 for x in leafsites) and all(v == [] for v in be.values()),
     "off_74472 (48 BE32) contains none of the 4 leaves; BE32 refs to leaves=%s; jsr/jmp sites to leaves: %s ; to 066FAA: %s" %
     ({hex(k): v for k, v in be.items()},
      " ".join("%06X:P6=%d,P7=%d" % (x, P6[x], P7[x]) for x in leafsites),
      " ".join("%06X:P7=%d" % (x, P7[x]) for x in sites[0x066FAA])), "MAIN 0x000000-0x07FFFF")
# X07 callers of 0x067522; inbound edges into their regions
c522 = findall(M, bytes.fromhex("5e067522"), 0, 0x80000) + findall(M, bytes.fromhex("5a067522"), 0, 0x80000)
def inbound(lo, hi):
    hits = []
    for i in range(1, 0x80000 - 3):
        if lo <= int.from_bytes(M[i:i+3], "big") < hi and not (lo <= i < hi):
            hits.append("%06X:%s" % (i - 1, M[i-1:i+3].hex()))
    for i in range(0, 0x80000 - 4, 2):
        if lo <= i < hi: continue
        b = M[i]
        if 0x40 <= b <= 0x4F or b == 0x55:
            d = M[i+1] - 256 if M[i+1] > 127 else M[i+1]
            if lo <= i + 2 + d < hi: hits.append("rel8 %06X" % i)
        if (b == 0x58 and M[i+1] & 0x0F == 0) or (b == 0x5C and M[i+1] == 0):
            d = int.from_bytes(M[i+2:i+4], "big", signed=True)
            if lo <= i + 4 + d < hi: hits.append("rel16 %06X" % i)
    return hits
regs = [(0x06B10E, 0x06B25C), (0x06B3BE, 0x06B408), (0x06B4B0, 0x06B556)]
ib = {"%06X-%06X" % r: inbound(*r) for r in regs}
# the only 'hit' from outside 06B10E.. is 0x05D23E '6b 06 b1 26' = mov.w @0xB126:16 (abs16 RAM), not an edge
ib_real = {k: [h for h in v if h != "05D23E:6b06b126"] for k, v in ib.items()}
pre = {"%06X" % lo: M[lo-2:lo].hex() for lo, _ in regs}
xadd("X07", sorted(c522) == [0x06B154, 0x06B194, 0x06B3CC, 0x06B4F6, 0x06B536] and all(v == [] for v in ib_real.values())
     and all(P7[x] == 0 and N7[x] == 1 for x in c522),
     "jsr @0x067522 at %s (all P7=0, N7=1); inbound from outside: %s (excluded abs16 operand 05D23E 6b 06 b1 26); bytes before region: %s" %
     ([hex(x) for x in sorted(c522)], ib, pre),
     "MAIN 0x000000-0x07FFFF: BE24 value at every offset (covers BE32 hi=00 and abs24 jsr/jmp/mov.l), rel8 Bcc/bsr and rel16 Bcc/bsr at even offsets")
# X08 stale copy identity
k = 0
while M[0x069964+k] == M[0x069A7F+k]: k += 1
xadd("X08", k == 37, "0x069A7F matches 0x069964 for %d B; first difference at +%d (%02x vs %02x)" % (k, k, M[0x069964+k], M[0x069A7F+k]), "two runs")
# X09 0x000DEA readers; 5e 01 8f aa sites
r_dea = findall(M, bytes.fromhex("78e06b2600000dea"), 0, 0x80000)
r_faa = findall(M, bytes.fromhex("5e018faa"), 0, 0x80000)
xadd("X09", r_dea == [0x000938, 0x00095C, 0x000A04] and r_faa == [0x017950, 0x017958, 0x01796C, 0x017974, 0x01797C, 0x017984],
     "readers '78 e0 6b 26 00 00 0d ea' at %s; jsr @0x018FAA at %s" % ([hex(x) for x in r_dea], [hex(x) for x in r_faa]),
     "MAIN 0x000000-0x07FFFF")
# X10 666 kHz constant
r666 = findall(M, bytes.fromhex("00066600"), 0, 0x80000)
xadd("X10", r666 == [0x014986, 0x0149A2], "'00 06 66 00' at %s" % [hex(x) for x in r666], "MAIN 0x000000-0x07FFFF")
# X11 SUB 12CB8 sites: mov.l #0x12CB8,Rn then classify the next instruction
r12 = findall(S, bytes.fromhex("b82c0100"))
sites12 = []
for o in r12:
    a = o - 2 + SUBBASE
    nxt = S[o+4:o+7]
    kind = "write mov.w #%d" % nxt[2] if nxt[0] == 0xF8 and (nxt[1] & 0x0F) == 0x05 else "other " + nxt.hex()
    sites12.append("%08X(%s):%s" % (a, S[o-2:o].hex(), kind))
writes = sorted(s for s in sites12 if "write" in s)
xadd("X11", len(writes) == 6 and all(x in " ".join(writes) for x in ("FFF38627", "FFF3865A", "FFF387B6", "FFF38759", "FFF388EB", "FFF38F75")),
     "mov.l #0x12CB8 sites: " + " ; ".join(sites12), "SUB whole image (4 MB), LE immediate 'b8 2c 01 00'")
# X12 SUB displacement arithmetic
xadd("X12", 0x12D44 + 0x95F6 == 0x1C33A and 0x12D44 + 0x9676 == 0x1C3BA and 0x12D44 + 0x96F6 == 0x1C43A
     and 0x12D44 + 0x85F6 == 0x1B33A and 0x12D44 + 5 == 0x12D49 and 0x12D49 + 0x13 == 0x12D44 + 0x18,
     "0x12D44+0x95F6=0x1C33A, +0x9676=0x1C3BA, +0x96F6=0x1C43A (doc 109 row above: +0x85F6=0x1B33A); F=0x12D49, F+0x13 = 0x12D44+0x18 = 0x12D5C",
     "arithmetic on C06/C07/C61-C63")
# X13 SUB bsr.a targets
def bsra(a):
    o = a - SUBBASE
    d = int.from_bytes(S[o+1:o+4], "little")
    if d & 0x800000: d -= 0x1000000
    return a + d
tg = {"%08X" % a: "%08X" % bsra(a) for a in (0xFFF394CF, 0xFFF39516, 0xFFF38AEA, 0xFFEDD019, 0xFFF383DE, 0xFFF381A8)}
xadd("X13", tg["FFF394CF"] == tg["FFF39516"] == tg["FFF38AEA"] == "FFEDD528" and tg["FFEDD019"] == "FFF3850B",
     "bsr.a targets %s; FFF3851D lies in FFF3850B's body" % tg, "six SUB sites")
# X14 the 120 B: no LE24/LE32 value anywhere in SUB points into them
rngs = [(0xFFF2570F, 0xFFF25771), (0xFFF38800, 0xFFF3880B), (0xFFF38871, 0xFFF3887C)]
hit = []
for i in range(len(S) - 3):
    v = S[i] | S[i+1] << 8 | S[i+2] << 16
    va = v | 0xFF000000
    for lo, hi in rngs:
        if lo <= va < hi:
            hit.append("%08X" % (i + SUBBASE))
nb = sum(hi - lo for lo, hi in rngs)
xadd("X14", nb == 120 and 457462 - nb == 457342,
     "half-open ranges sum %d B; 457,462 - %d = %d; LE24 values pointing into them at: %s" % (nb, nb, 457462 - nb, hit[:20] or "none"),
     "SUB whole image, every offset, 3-byte LE value | 0xFF000000 (also covers LE32 with hi byte FF)")
# X15 rts/l, rte/l counts in bu_all.tsv
cnt = collections.Counter()
for ln in open(os.path.join(ROOT, r"ida\out\h8s-decode\work\bu_all.tsv"), encoding="utf-8", errors="replace"):
    f = ln.rstrip("\n").split("\t")
    if len(f) < 3 or f[2] not in ("rts/l", "rte/l"): continue
    a = int(f[0], 16)
    cnt[(f[2], "all")] += 1
    if a % 2 == 0: cnt[(f[2], "even")] += 1
    if P7[a] and a % 2 == 0: cnt[(f[2], "even&P7")] += 1
    if P6[a] and a % 2 == 0: cnt[(f[2], "even&P6")] += 1
got = {k[0] + "/" + k[1]: v for k, v in sorted(cnt.items())}
xadd("X15", not any(v in (301, 251) for v in got.values()),
     "bu_all.tsv counts %s; neither 301 nor 251 appears in any of these scopes" % got,
     "bu_all.tsv: every offset 0..0x7B753; even offsets; even & proven (final6 / final7)")
# X16 the inline citation sweep over the M-wave RESUME section and the recon README
pat = re.compile(r"`(?:0x)?([0-9A-Fa-f]{6,8})((?: [0-9a-f]{2}){2,})(?: …)?`")
sweep = []
def sweepfile(path, lo, hi, tag):
    for n, line in enumerate(open(path, encoding="utf-8"), 1):
        if not (lo <= n <= hi): continue
        for m in pat.finditer(line):
            a = int(m.group(1), 16)
            e = bytes.fromhex(m.group(2).replace(" ", ""))
            got, img, off = rd(a, len(e))
            near = M.find(e, max(0, a-8), a+8+len(e)) if img == "M" else -1
            r = "PASS" if got == e else ("FOUND%+d" % (near - a) if near >= 0 else "FAIL")
            sweep.append((tag, n, m.group(1), m.group(2).strip(), hx(got), r))
sweepfile(os.path.join(ROOT, r"docs\deep\RESUME-FULL.md"), 13, 250, "RESUME-FULL.md")
sweepfile(os.path.join(RECON, "README.md"), 1, 200, "m-wave-recon/README.md")
n_before = len(sweep)
DOC142 = os.path.join(ROOT, "docs", "deep", "142-errata-m.md")
if not os.path.exists(DOC142):
    sys.exit("doc 142 missing")
if True:
    sweepfile(DOC142, 1, 100000, "142-errata-m.md")
self_rows = sweep[n_before:]
bad = [s for s in sweep[:n_before] if s[5] != "PASS"]
# the RESUME/README run '0x06ADE4 0c cb 58 70 00 28 eb 07 5e 06 ac d6' wraps a line in RESUME, so the sweep sees
# only the first part there; both are recorded as E57.
xadd("X16", all(s[2] in ("06ADE4",) for s in bad),
     "%d inline ADDR-bytes citations; non-PASS: %s" % (n_before, [(s[0], s[1], s[2], s[5]) for s in bad]),
     "RESUME-FULL.md lines 13-250 (M wave) and m-wave-recon/README.md, backticked 'ADDR hh hh ..' runs")

xadd("X17", len(self_rows) > 0 and all(r[5] == "PASS" for r in self_rows),
     "doc 142 inline 'ADDR bytes' citations: %d, non-PASS: %s" % (len(self_rows), [(r[1], r[2], r[5]) for r in self_rows if r[5] != "PASS"]),
     "docs/deep/142-errata-m.md, every backticked 'ADDR hh hh ..' run")

# ---------------------------------------------------------------- text checks
DD = os.path.join(ROOT, r"docs\deep")
def L(path, n):
    p = path if os.path.isabs(path) else os.path.join(DD, path)
    try:
        return open(p, encoding="utf-8").read().split("\n")[n-1]
    except Exception:
        return ""
def tc(spec):
    out = []
    for path, n, sub in spec:
        out.append("PASS" if sub in L(path, n) else "FAIL(%s:%d)" % (os.path.basename(path), n))
    return "PASS" if all(o == "PASS" for o in out) else ";".join(o for o in out if o != "PASS")
RES = "RESUME-FULL.md"
UNN = os.path.join(ROOT, r"ida\out\main-unnamed\runs.tsv")
OPC = os.path.join(ROOT, r"ida\out\dsp-1c03\opcode-1c.tsv")
BLD = os.path.join(ROOT, r"ida\out\sub-frames-sub\builders.tsv")
CNT2 = os.path.join(ROOT, r"ida\out\sub-final2\counts.txt")
CNT3 = os.path.join(ROOT, r"ida\out\sub-final3\counts.txt")
RDM = os.path.join(RECON, "README.md")

def mk(addrs):
    out = []
    for a in addrs:
        if a >= SUBBASE: out.append("%08X SUB(n/a)" % a)
        else: out.append("%06X P7=%d N7=%d" % (a, P7[a], N7[a]))
    return ", ".join(out)

# id, sec, owning doc:line, as written, corrected, verdict, class, anchors, mask addrs, owning text spec, source text spec, source
E = [
 ("E01","A","114:95 (also :20)","DATA-MISTYPED run 0x00932A-0x009332 \"(Confirmed by the reader)\"",
  "Reader 0x00929E 78 40 6a 2b 00 00 93 2c has base 0x932C; index r4 = byte @0x8EB2 (0x009294 6a 0c 8e b2) masked by and.l #0xFF (0x009298). It reads 0x932C..0x942B only. 0x932A-0x932B (05 04) are data by inference (adjacent, no other reference of any form). Demotion (not code) unaffected",
  "Confirmed","scope of 'Confirmed' (-2 B base)","C01 C02 X01",[0x00932A,0x00932B,0x00932C],
  [("114-proven-unreached-lo.md",95,"(Confirmed by the reader)"),("114-proven-unreached-lo.md",99,"into the table at `0x932C`")],
  [(RES,184,"the reader of `0x00932A` uses base `0x932C`")],"RESUME:184 (orchestrator)"),
 ("E02","A","122:117 (also :35)","mode 10 at `0x063C04` (`fc 0a 6a 8c a9 f9`)",
  "0x063C04 is the routine entry (fc 00 6a 8c b2 a3; jsr from 0x01CE9A and 0x01CEAA). The mode-10 run fc 0a 6a 8c a9 f9 is at 0x063C10 (store at 0x063C12; doc 122:106 '0x063C12=0xA' is right). As an entry address 0x063C04 is right; as the address of the cited bytes it is +12 off",
  "Confirmed","address (bytes cited at the routine entry)","C03 C04 C05 W01 X02",[0x063C04,0x063C10,0x063C12],
  [("122-touch-key-leftovers.md",117,"key 1 short → `0x063C04` (`fc 0a 6a 8c a9 f9`"),("122-touch-key-leftovers.md",35,"key-1 short press (`0x063C04`)")],
  [(RES,186,"is at `0x063C10`, not `0x063C04`")],"RESUME:186 (orchestrator)"),
 ("E03","A","121:139 vs 121:162","`[0x18] == 3` (l.139) and `[+0x13]==3` (l.162)",
  "Same byte. 0xFFEDCE76 fb 12 44 2d 01 00 b6 11 61 31 reads 0x18[0x12D44] = 0x12D5C. Doc 51:110 defines frame body F = 0x12D49 (= 0x12D44+5; the opcode-hi read is 0xFFEDCE5C b1 19 = movu.b 5[r1]). F+0x13 = 0x12D5C. No byte is wrong; the two lines use different bases",
  "Confirmed (no erratum)","notation (two frame bases)","C06 C07 X12",[0xFFEDCE7E],
  [("121-link-edge-cases.md",139,"byte `[0x18] == 3` (`0xFFEDCE7E 61 31`)"),("121-link-edge-cases.md",162,"`[+0x13]==3`"),("51-sub-link-layer.md",110,"0x12D49")],
  [(RES,187,"line 139 says `[0x18]==3` while line 162 says `[+0x13]==3`")],"RESUME:187 (orchestrator)"),
 ("E04","B","105:187","UHF: 230–419.995 and 420–579.995 MHz → 5, 6",
  "UHF table 0x035140 = 00 0a 00 02 | 30 00 00 00 41 99 95 00 00 05 | 42 00 00 00 57 99 95 00 00 06: index 5 = 300.000-419.995 MHz. VHF 0x03510A (stride 10, count 5) ends 222.000-229.995 -> 4, so 230.000-299.995 has no entry in either table",
  "Confirmed","value","C08 C09 X03",[0x035140,0x035144],
  [("105-tx-states.md",187,"UHF: 230–419.995 and 420–579.995 MHz → 5, 6")],[(RES,197,"**300.000**–419.995 MHz, not 230")],"M13 (125)"),
 ("E05","B","105:321 (also §6, Verdict)","AN1 step shows popup code `0x23` via `sub_1BF40`",
  "sub_1BF40 starts 0x01BF40 ac 02 45 32 ac 0c 44 2e: codes < 2 and >= 0x0C return, so 0x23 is never shown",
  "Confirmed","behaviour","C10",[0x01BF40],
  [("105-tx-states.md",321,"shows popup code `0x23` via `sub_1BF40`")],[(RES,198,"Popup `0x23` is never shown")],"M8 (120)"),
 ("E06","B","105:288","DCS class 3 \"fits a DCS turn-off code (Inferred, moderate)\"",
  "DCS Confirmed: 104 BE32 words at 0x000B8C, low 9 bits zero; bit-reversed, the low 9 bits are D023..D754 in standard order and all 104 are Golay(23,12) codewords (g = 0xC75). Tick 0x000476 79 04 0b a0 -> period 2977 -> 5374.5 Hz / 40 = 134.36 bps",
  "Confirmed","confidence upgrade","C11 X04 X05",[0x000B8C,0x000476],
  [("105-tx-states.md",288,"This fits a DCS turn-off code (Inferred, moderate).")],[(RES,199,"DCS and the TPU1 sine generator are Confirmed")],"M8 (120)"),
 ("E07","B","105:293","TPU1 \"looks like a sine-synthesis sample clock (Inferred)\"",
  "0x0351D6 fc 20 3c d0 79 04 00 00 6b 84 ff d6 79 04 09 89 6b 84 ff d8: TCR1=0x20, TGRA1=0x0989 -> 16e6/2442 = 6552.0 Hz; M8 reads DA1 = sine[AAB2>>8] (table 0x3656). Bytes Confirmed; the DDS reading is M8's (not re-derived here beyond the clock)",
  "Confirmed (clock bytes)","confidence upgrade","C12 X05",[0x0351D6],
  [("105-tx-states.md",293,"which looks like a sine-synthesis sample clock (Inferred).")],[(RES,199,"DCS and the TPU1 sine generator are Confirmed")],"M8 (120)"),
 ("E08","B","105:301","T-CALL: \"The clock select was not\" read",
  "0x002336 fc 02 6a 8c fe c1: FEC1 = 2 (phi/64 = 250 kHz); TCORA 0x47 -> 250000/(2*72) = 1736.1 Hz (1750 Hz design)",
  "Confirmed","gap closed","C13 X05",[0x002336],
  [("105-tx-states.md",301,"The clock select was not")],[(RES,199,"`0x002336 fc 02 6a 8c fe c1`")],"M8 (120)"),
 ("E09","B","105:432 (Open 4)","Identify key event 13 (raw `0x16`)",
  "Event 13 = one DIAL detent: raw 0x16 formed only at 0x00FBBE 77 0b 6a 18 a9 ee 67 00 fc 16; encoder chosen by DIAL KNOB CHANGE (0x00A210 79 04 f3 96, 0x00A228 6a 0b 89 b5 = FF89B5)",
  "Confirmed (bytes); meaning Inferred, strong (M11)","open item closed","C14 C15 C16",[0x00FBBE,0x00FBC6],
  [("105-tx-states.md",432,"**Identify key event 13** (raw `0x16`)")],[(RES,200,"Event 13 is the DIAL step.")],"M11 (123)"),
 ("E10","B","101:61","0x066FB4/0x067250 reached through indexed node-command dispatch (`off_74472`)",
  "off_74472 (48 BE32, 0x074472-0x074531) holds none of the four leaves; no BE32 to them anywhere. Every jsr site to the four leaves is P7=0: the arms 0x062808/0x06280E/0x062814, 0x06723A, 0x06AB1C.., 0x06ADF6.. (M4 dead arms after bra; arm head 0x06ADE6). Leaves dropped from proven (-72 B)",
  "Confirmed","mechanism","C17 C18 C98 C99 X06",[0x066FB4,0x067250,0x066FBE,0x06726A],
  [("101-fnindex-runs-hi.md",61,"reached through an indexed node-command dispatch (`off_74472`)")],[(RES,201,"are not reached through `off_74472`")],"M4 (116)"),
 ("E11","B","101:95; 113:223 (M1's correction); RESUME:201","101: `0x067522` \"lone rts … 0 inbound\"; M1/RESUME: \"two callers, both inside dead `0x06B4B0`\"",
  "FIVE abs24 callers, not two: 0x06B154, 0x06B194, 0x06B3CC, 0x06B4F6, 0x06B536 (all 5e 06 75 22, all FINAL6 code heads, all P7=0 N7=1). 06B154/06B194 lie in 0x06B10E-0x06B25B (after rts 0x06B10C), 06B3CC in 0x06B3BE-0x06B407 (after rts 0x06B3BC); no BE24/abs24 value, rel8 or rel16 branch from outside enters any of the three regions. DEAD verdict stands; the count is 5",
  "Refined (M1 count 2 -> 5)","count","C19 C20 C21 C22 C23 X07",[0x06B154,0x06B194,0x06B3CC,0x06B4F6,0x06B536,0x067522],
  [("101-fnindex-runs-hi.md",95,"`0x067522` (2, lone `rts`"),("113-main-final6-seed.md",223,"two abs24 calls to it exist")],
  [(RES,201,"`0x067522` has two callers, both inside dead `0x06B4B0`")],"M1 (113), M4"),
 ("E12","B","100:68 (Method 2)","6 proven `bra/bsr rN.w` (`0x02B3F8`, `0x02B450`, ...)",
  "Five are mid-instruction: 02B3F6 5e 06 5d 26, 02B44E 5e 06 5d 66, 05569A 5e 05 59 76 (jsr), 0559B0 7a 05 00 ff 59 06, 0559C6 7a 06 00 ff 59 06 (mov.l). Only 0x076308 59 06 is a real bra r0.w",
  "Confirmed","count / decode","C24 C25 C26 C27 C28 C29",[0x076308],
  [("100-fnindex-runs-mid.md",68,"There are 6 proven `bra/bsr rN.w` in the image")],[(RES,202,"5 of 6 `rN.w` sites are mid-instruction")],"M3 (115)"),
 ("E13","B","100:126","`jsr 0x3F5B2` (`6d 62 6d 63 01 00 69 64`)",
  "Image 0x03F5B2 01 00 6d f2 6d 62 79 0a 00 00 6d 63 01 00 69 64: the cited run drops the push and mov.w #0,e2; the instructions named are present, not contiguous",
  "Confirmed","bytes not contiguous","C30 W03",[0x03F5B2],
  [("100-fnindex-runs-mid.md",126,"`jsr 0x3F5B2` (`6d 62 6d 63 01 00 69 64`)")],[(RES,202,"`0x3F5B2` run not contiguous")],"M13 (125)"),
 ("E14","B","main-unnamed/runs.tsv:279 (doc 102)","0x01E1C2 = \"operand tail of named insn 0x01E1BE (mov.w @(0x1e1de:32,er3),r6)\"",
  "0x01E1BE is 10 73 (shll.l #2,er3); the covering instruction is 0x01E1C0 78 b0 6b 26 00 01 e1 de, mov.l @(0x1E1DE:32,er3),er6 (8 B)",
  "Confirmed","address/mnemonic","C31",[0x01E1C0,0x01E1C2],
  [(UNN,279,"operand tail of named insn 0x01E1BE (mov.w @(0x1e1de:32,er3),r6)")],[(RES,203,"operand tail of the 8-byte `0x01E1C0`")],"M1 (113)"),
 ("E15","B","main-unnamed/runs.tsv:280 (doc 102)","dead piece starts 0x01E1C6 (24 B)",
  "0x01E1C6-0x01E1C7 (e1 de) is the tail of 0x01E1C0; dead code starts 0x01E1C8 01 10 6d 75",
  "Confirmed","split point","C31 C32",[0x01E1C6,0x01E1C8],
  [(UNN,280,"01E1C6\t01E1DE\t24")],[(RES,203,"`0x01E1C2` / `0x01E1C6`")],"M5 (117)"),
 ("E16","B","main-unnamed/runs.tsv:185 (doc 102 §5)","0x018FAA \"unreachable fragment after bra\"",
  "Live: 0x017924 7a 05 00 01 79 2e 5a 01 52 60 hands record 0x01792E to sub_15260 (0x015288 ... 5d 60 jsr @er6); fields 1-7 call jsr @0x018FAA six times (0x017950..0x017984). Now proven by the record rule",
  "Confirmed","reachability","C33 C34 C35 C36 C37 X09",[0x018FAA],
  [(UNN,185,"unreachable fragment after bra")],[(RES,203,"`0x018FAA` is live")],"M5 (117), M6 (118)"),
 ("E17","B","main-unnamed/runs.tsv:2 (doc 102)","0x000E20 = \"last u16 (0x319C) of 4-B pair table 0x000E00\"",
  "Table base is 0x000DEA (readers 78 e0 6b 26 00 00 0d ea at 0x000938, 0x00095C, 0x000A04); 0x000E1E 00 7f 31 9c is slot 13 {u8,u8,u16}",
  "Confirmed","table base","C38 C39 X09",[0x000E20],
  [(UNN,2,"last u16 (0x319C) of 4-B pair table 0x000E00")],[(RES,203,"`0x000E20` belongs to `0x000DEA`")],"M6 (118), M8 (120)"),
 ("E18","B","main-unnamed/runs.tsv:77 (doc 102)","0x015192 = \"byte inside list 0x015164\"",
  "Index 6 of u8 map 0x01518C[14], read by 0x014F8E 78 30 6a 2b 00 01 51 8c",
  "Confirmed","table membership","C40",[0x015192],
  [(UNN,77,"byte inside list 0x015164")],[(RES,203,"`0x015192` is in `u8[14]` `0x01518C`")],"M6 (118)"),
 ("E19","B","102:199 (§6)","0x069A7F-0x069AA9 \"Un-nameable: 43 B\"",
  "Stale odd-address copy of sub_69964: first 37 B identical (byte 38 differs, 02 vs 0e). Held for the owner (not named in FINAL7)",
  "Confirmed","identification","X08",[0x069A7F],
  [("102-main-unnamed-residue.md",199,"### 6. Un-nameable: 43 B")],[(RES,203,"`0x069A7F` is a stale copy")],"M6 (118)"),
 ("E20","B","102:122 (§1)","\"the proven mask would grow by 4 B\"",
  "Does not hold: 0x006A0C / 0x0077F8 sit in blocks after 0x006A06 40 12 / 0x0077CC 40 36 (bra) that the descent does not reach; P7 = 0 at both",
  "Confirmed","ledger","C41 C42",[0x006A0C,0x0077F8],
  [("102-main-unnamed-residue.md",122,"so the proven mask would grow by 4 B")],[(RES,203,"The \"+4 B\" does not hold.")],"M1 (113)"),
 ("E21","B","104:145","'A' = \"channel index `A9F0`\"",
  "Remote key injector: args 0x00-0x09 digit, 0x0A-0x16 events 1-13, >= 0x17 NAK (0x073EB4 a1 17 44 24); event store 0x073ECE fc 09 18 c1 6a 81 a9 ed. Cannot inject event 14 (TX)",
  "Confirmed (bytes); semantics M11","semantics","C43 C44",[0x073EB4,0x073ECE],
  [("104-pdn-node-table.md",145,"'A' channel index `A9F0`")],[(RES,204,"`'A'` is a remote key injector")],"M11 (123)"),
 ("E22","B","104:164","`0x073E88 5e 03 4a 52`","0x073E86 5e 03 4a 52 (jsr @0x034A52); 0x073E88 is the operand",
  "Confirmed","address +2","C45 W04",[0x073E86],
  [("104-pdn-node-table.md",164,"`0x073E88 5e 03 4a 52`")],[(RES,204,"`0x073E86`")],"M13, M14"),
 ("E23","B","104:164","`0x073E90 5e 03 50 e4`","0x073E8E 5e 03 50 e4 (jsr @0x0350E4)",
  "Confirmed","address +2","C46 W05",[0x073E8E],
  [("104-pdn-node-table.md",164,"`0x073E90 5e 03 50 e4`")],[(RES,204,"`0x073E8E`")],"M13, M14"),
 ("E24","B","104:28","`0x073E88 jsr sub_34A52 → sub_35872`","0x073E86 (same slip as E22)",
  "Confirmed","address +2","C45 W04",[0x073E86],
  [("104-pdn-node-table.md",28,"`0x073E88 jsr sub_34A52")],[(RES,204,"Lines 28/164")],"M14 (126)"),
 ("E25","B","106:130","`0x0743BC fc 01 6a 8c b0 cc`","0x0743BA fc 01 6a 8c b0 cc (store at 0x0743BC)",
  "Confirmed","listing convention +2","C47 W06",[0x0743BA],
  [("106-dsp-1c03-leftovers.md",130,"`0x0743BC fc 01 6a 8c b0 cc`")],[(RES,205,"`0x0743BA`")],"M13, M14"),
 ("E26","B","106:151","store `0x031BEE` (FF9589)","0x031BEE is the immediate fc c8; the store 6a 8c 95 89 is at 0x031BF0",
  "Confirmed","listing convention -2","C49 W14",[0x031BF0],
  [("106-dsp-1c03-leftovers.md",151,"`0x031BEE`")],[(RES,205,"`0x031BF0`")],"M13 (125)"),
 ("E27","B","106:153","`0x030242` … `fc 05 6a 8c aa ce`","0x030240 fc 05 6a 8c aa ce",
  "Confirmed","listing convention +2","C50 W08",[0x030240],
  [("106-dsp-1c03-leftovers.md",153,"`0x030242`")],[(RES,205,"`0x030240`")],"M13, M14"),
 ("E28","B","106:153","`0x031CD4` (same run)","0x031CD2 fc 05 6a 8c aa ce",
  "Confirmed","listing convention +2","C51 W09",[0x031CD2],
  [("106-dsp-1c03-leftovers.md",153,"`0x031CD4`")],[(RES,205,"`0x031CD2`")],"M13, M14"),
 ("E29","B","107:119","`0x00FAFE`: Bluetooth ON (`6a 10 89 20 73 00 46 0c`)","0x00FB04 6a 10 89 20 73 00 46 0c; 0x00FAFE is 6a 0c 89 bb 47 14 (the VOX test)",
  "Confirmed","address +6","C52 C53 W10",[0x00FB04],
  [("107-accessory-ptt.md",119,"`0x00FAFE`: with Bluetooth ON (`6a 10 89 20 73 00 46 0c`)")],[(RES,206,"Line 119: `0x00FB04`")],"M13 (125)"),
 ("E30","B","107:280-281","12CB8 = 2 at `0xFFF38627`/`0xFFF3865A`; = 1 at `0xFFF38F7B`",
  "Six writers (whole-image scan of mov.l #0x12CB8): =2 at FFF38627, FFF3865A, FFF387B6; =1 at FFF38759, FFF388EB, FFF38F75 (mov.w at FFF38F7B). The other 7 sites read",
  "Confirmed","incomplete list","C54 C55 C56 C57 X11",[0xFFF387B6],
  [("107-accessory-ptt.md",280,"set to 2 at `0xFFF38627`/`0xFFF3865A`"),("107-accessory-ptt.md",281,"`0xFFF38F7B`")],[(RES,206,"`12CB8` has more writers"),(RES,182,"`FFF387B6` (= 2)")],"M13 (125)"),
 ("E31","B","107:151","SUB sends `TXAT=1` from `sub_FFF39BAF` (single path)",
  "Also re-sent on every non-F3D2 MAIN frame while linked (FFF38467 39 7b 00 = bsr.w FFF384E2). Bytes Confirmed; the path meaning is M12's",
  "Confirmed (bytes); behaviour Inferred here","addition","C58",[0xFFF38467],
  [("107-accessory-ptt.md",151,"SUB sends `TXAT=1` from `sub_FFF39BAF`")],[(RES,206,"TXAT=1 is re-sent while linked")],"M12 (124)"),
 ("E32","B","107:181","`[1229D]` is `frame[0x18] & 0x20` from MAIN's `F3D2` frame",
  "Taken from the common header path: FFEDD019 05 f2 b4 05 = bsr.a FFF3850B, whose body holds FFF3851D b6 11 75 21 20. The F3D2 restriction does not hold",
  "Confirmed","scope","C59 C60 X13",[0xFFEDD019],
  [("107-accessory-ptt.md",181,"from MAIN's `F3D2` frame")],[(RES,206,"`1229D` comes from every frame")],"M12 (124)"),
 ("E33","B","109:100-101","TX buffers `0x2433A` / `0x243BA`",
  "0x1C33A / 0x1C3BA: FFEDD533 fb e2 44 2d 01 00 (r14 = 0x12D44) + disp 0x95F6 (FFEDD539 c9 0e 0f f6 95) / 0x9676 (FFEDD70C). The doc is 0x8000 high; its own rows above (0x85F6 -> 0x1B33A) are right",
  "Confirmed","arithmetic +0x8000","C61 C62 X12",[0xFFEDD539,0xFFEDD70C],
  [("109-sub-frames-sub.md",100,"`0x2433A`"),("109-sub-frames-sub.md",101,"`0x243BA`")],[(RES,207,"`0x1C33A` / `0x1C3BA`")],"M13 (125)"),
 ("E34","B","sub-frames-sub/builders.tsv:7","FE row `0x2443A (disp 0x96F6)`","0x1C43A (FFEDD8F4 fb e2 44 2d 01 00 c9 0e 0b f6 96)",
  "Confirmed","arithmetic +0x8000","C63 X12",[0xFFEDD8FA],
  [(BLD,7,"0x2443A (disp 0x96F6)")],[(RES,207,"(FE row `0x1C43A`)")],"M13 (125)"),
 ("E35","B","109:272","`E5`'s exact link is Unknown",
  "E5 is sent through the E5/E6 sender FFEDD528 from FFF394CF 05 59 40 fa and FFF39516 05 12 40 fa (bsr.a), M12's BT-VOX level result. Bytes Confirmed; label Inferred (M12)",
  "Confirmed (bytes); label Inferred","Unknown -> Inferred","C64 C65 X13",[0xFFF394CF,0xFFF39516],
  [("109-sub-frames-sub.md",272,"`E5`'s exact link is Unknown.")],[(RES,207,"E5 is the BT-VOX level")],"M12 (124)"),
 ("E36","B","109:147","channel-2 sends ... `PAIR=…`, `FIND=…`",
  "PAIR= (FFF4AF11, FFF4AF1A) and FIND= (FFF4AEF5, FFF4AF01) formats are the radio's replies/echoes to module lines (PAIR=<addr> sets linked: FFF3A77B f8 e4 05). Role per M12",
  "Confirmed (bytes); role Inferred","role","C79",[0xFFF3A77B],
  [("109-sub-frames-sub.md",147,"`PAIR=…`, `FIND=…`")],[(RES,207,"PAIR= / FIND= are replies")],"M12 (124)"),
 ("E37","B","108:130,134","E4 = 29-B WIRES-X/node status; \"Inferred: WIRES-X connection/GM status\"",
  "Bluetooth link/scan status record (codes 0-3, 5, 9, 0x10-0x13): SUB FFF38AEA 05 3e 4a fa (bsr.a FFEDD528), MAIN reader 0x073292 ac 03",
  "Confirmed (bytes); label Inferred (M12)","label","C66 C67 X13",[0x073292],
  [("108-sub-frames-main.md",130,"WIRES-X/node status record"),("108-sub-frames-main.md",134,"Inferred: WIRES-X connection/GM status.")],[(RES,208,"E4 is Bluetooth link/scan status")],"M12 (124)"),
 ("E38","B","112:84","`usb_isr_main` (`0x054D50`): `6a 0c 81 3a 58 60 01 4c`","0x054D50 = 01 10 6d f4 (push); the cited run starts at 0x054D54",
  "Confirmed","address +4","C68 W11",[0x054D54],
  [("112-c-reconstruction.md",84,"(`0x054D50`): `6a 0c 81 3a 58 60 01 4c`")],[(RES,209,"The bytes are at `0x054D54`")],"M13 (125)"),
 ("E39","B","85:61,202,203","16-character and 4-character fields of screen 0x0A",
  "Descriptors 0x05E376 00 0f 00 ff b9 ed (max 15) and 0x05E3B4 00 03 00 ff b9 ed (max 3)",
  "Confirmed","value","C69 C70",[0x05E376,0x05E3B4],
  [("85-touch-screens.md",61,"16-character and 4-character fields"),("85-touch-screens.md",202,"16-char name"),("85-touch-screens.md",203,"4-char item")],[(RES,210,"are 15 / 3 characters")],"M10 (122)"),
 ("E40","B","49-key-sequence-hidden:400 (Open 4); 112:210 (Open 3)","`[FF910A] == 0x66600` narrowed, not identified",
  "0x00066600 is BCD 666.00 kHz (10 Hz units) of record FF90F0+0x1A; the constant occurs only at 0x014986 and 0x0149A2 (cmp.l at 0x014984 / 0x0149A0)",
  "Confirmed","identification","C71 C72 C73 X10",[0x014986,0x0149A2],
  [("49-key-sequence-hidden.md",400,"`[FF910A] == 0x66600`.** Narrowed, not identified"),("112-c-reconstruction.md",210,"`FF910A == 0x00066600`")],[(RES,211,"`0x66600` is 666.00 kHz BCD")],"M11 (123)"),
 ("E41","B","35:134","slot B (`0xFF90F0`) = **sub/B band**",
  "FF90F0 is the broadcast-segment record (0x03FB32 7a 06 00 ff 91 02; band row 0x022176 0.500-1.795 MHz); A = FF8EE0 (0x00216A), B = FF8FE8 (0x00217E)",
  "Confirmed (bytes); label Inferred (M11)","identification","C73 C74 C75 C76",[0x00216A,0x00217E],
  [("35-channel-record.md",134,"slot B = **sub/B band**")],[(RES,212,"`FF90F0` is the broadcast record")],"M11 (123)"),
 ("E42","B","14:229,235,237","PINF feeds DEVICE LIST; FIND= are discovery results; PAIR= is pairing",
  "FIND/PAIR/SCOI/HELL/ERAT/RXAT formats are the radio's acks/echoes; module FIND line is <addr12>,<name>,<4> (FFF3A50B 61 c1, FFF3A57F 61 f1); PAIR=<addr> = linked (FFF3A77B f8 e4 05); PINF only from F3D5 delete flow (0x07336C ac 09); ERROR+SCOI (FFF3A8CF 75 51 2b)",
  "Confirmed (bytes); roles Inferred (M12)","roles","C77 C78 C79 C80 C81",[0x07336C],
  [("14-bluetooth-gps-wiresx.md",229,"is the paired-device record that feeds the `DEVICE LIST`"),("14-bluetooth-gps-wiresx.md",235,"are discovery results"),("14-bluetooth-gps-wiresx.md",237,"is pairing.")],
  [(RES,213,"The FIND / PAIR lines are acks.")],"M12 (124)"),
 ("E43","B","51:251","F3D5/F3D6 are an identity/pairing handshake",
  "Bluetooth pairing-delete (F3D5, FFF383DE flow) and (re)connect (F3D6, FFF381A8 flow) frames",
  "Confirmed (bytes); labels Inferred (M12)","label","C82 C83",[0xFFF383DE,0xFFF381A8],
  [("51-sub-link-layer.md",251,"F3D5/F3D6 are an identity/pairing handshake")],[(RES,213,"F3D5 / F3D6 are Bluetooth delete / (re)connect frames")],"M12 (124)"),
 ("E44","B","07:103","sub_32C0 reads 10-bit results from `@0xFFFF90/95/96/99`, S-meter thresholds",
  "Byte reads of the upper 8 bits: 2c 94 (0x32D2), 2c 96 (0x32EA), 2c 98 (0x3308), 2c 9a (0x3320), 2c 90 (0x3346, AN0). Thresholds are AN0 battery BCD",
  "Confirmed (reads); threshold meaning M8","mnemonic / semantics","C84 C85",[0x0032D2,0x003346],
  [("07-rf-sdr-and-iq-path.md",103,"reads 10-bit results from `@0xFFFF90/95/96/99`")],[(RES,214,"`sub_32C0` reads AN0 battery BCD")],"M8 (120)"),
 ("E45","B","04:195","ADCSR touched \"by no vector handler at all\"",
  "Vector 67 (0x00010C 00 00 24 b6) is sub_24B6, which zeroes ADCSR",
  "Confirmed","fact","C86 C87",[0x00010C],
  [("04-main-recovery.md",195,"and by no vector handler at all.")],[(RES,214,"The ADC vector is 67")],"M8 (120)"),
 ("E46","B","04:213,219","`0xFFFEC0`–`0xFFFECB` 16-bit timer channel; `0xFFFF90`.. word reads; no D/A row",
  "8-bit timer pair (T-CALL clock 0x002336 fc 02 6a 8c fe c1); A/D reads are byte reads (E44); D/A DA0 at 0xFFFF68 (0x0029A8 3e 68), DA1 0xFFFF69. Identities Inferred (M8)",
  "Confirmed (bytes); identities Inferred","register map","C13 C84 C88",[0x002336,0x0029A8],
  [("04-main-recovery.md",213,"16-bit timer channel"),("04-main-recovery.md",219,"word reads from `sub_32C0`")],[(RES,214,"the D/A is at `0xFFFF68`")],"M8 (120)"),
 ("E47","B","48:119; 62:26,91-92","every `jsr Rn` loads its target from memory",
  "317 of 319 do; 2 load the constant 0: FFEE2220 66 03 7f 13 and FFEE223B 66 03 7f 13 (mov.l #0,r3; jsr r3)",
  "Confirmed","prose overstatement","C89 C90",[0xFFEE2220,0xFFEE223B],
  [("48-sub-phase-orphans.md",119,"Every `jsr` loads its target from memory"),("62-sub-residue.md",26,"every `jsr Rn` loads from memory"),("62-sub-residue.md",92,"loads its target from memory")],
  [(RES,215,"2 of 319 `jsr Rn` load the constant 0")],"M15 (127)"),
 ("E48","B","68:30,290; 89:32,159; sub-final2|3/counts.txt:5","reach-only companion 457,462",
  "Strict 457,342: 120 B (FFF2570F-FFF25771 98 B, FFF38800-FFF3880B 11 B, FFF38871-FFF3887C 11 B; half-open) are reached only through stale lane-4 xref roots; no 3-byte LE value in SUB points into them",
  "Confirmed (arithmetic, no inbound value)","count","X14",[0xFFF2570F,0xFFF38800],
  [("68-sub-final2-seed.md",30,"457,462"),("89-sub-final3-seed.md",32,"457,462"),(CNT2,5,"457462"),(CNT3,5,"457462")],[(RES,216,"strictly 457,342")],"M15 (127)"),
 ("E49","B","93:64","\"The command dispatcher `0x073A36`\"","0x073A36 is inside the 8-byte load 0x073A34 78 b0 6b 26 00 07 44 72; the routine is sub_739FA",
  "Confirmed","mid-instruction address","C91",[0x073A34],
  [("93-tx-gate.md",64,"The command dispatcher `0x073A36`")],[(RES,217,"`0x073A36` is mid-instruction")],"M14 (126)"),
 ("E50","B","93:98-99","`sub_10FA8` selects the TX-time tables (n via AAD3 only, per doc 110)",
  "AAD4.b0 also selects n = 9: 0x01101A 6a 0c aa d4 ec 01 46 02",
  "Confirmed","scope addition","C92",[0x01101A],
  [("93-tx-gate.md",98,"`sub_10FA8` selects the TX-time tables")],[(RES,217,"`AAD4.b0` also selects n=9")],"M14 (126)"),
 ("E51","B","dsp-1c03/opcode-1c.tsv:39","`0743BC\tfc 01 6a 8c b0 cc`","0743BA (as E25)",
  "Confirmed","listing convention +2","C47 W06",[0x0743BA],
  [(OPC,39,"0743BC\tfc 01 6a 8c b0 cc")],[(RES,217,"Row 39: `0743BA`")],"M14 (126)"),
 ("E52","B","101:99","at `0x062962` er5 is overwritten (`mov.l #0xffb32e,er5`)","0x062972 7a 05 00 ff b3 2e; 0x062962 is 7a 05 00 06 21 78 (load of handler 0x062178). Conclusion holds",
  "Confirmed","address +0x10","C93 C94 W12",[0x062972],
  [("101-fnindex-runs-hi.md",99,"at `0x062962` er5 is overwritten (`mov.l #0xffb32e,er5`)")],[(RES,218,"`0x062972`")],"M13 (125)"),
 ("E53","B","101:103 (recorded as 101:104)","interior \"BE32 pointer\" at `0x01D33E`",
  "The BE32 00 06 46 0e starts at 0x01D340, inside 0x01D33E 6e 0c 00 06 (operand) + 0x01D342 46 0e. The cite is on line 103, not 104; its twin 0x01D360 (00 06 46 10) is right",
  "Confirmed (+ line-number nit)","address +2","C95 C96 W13",[0x01D340],
  [("101-fnindex-runs-hi.md",103,"`0x01D33E`/")],[(RES,218,"`0x01D340`")],"M13 (125)"),
 ("E54","B","103:78","\"the image has 301 `rts/l` and 251 `rte/l`\"",
  "Not reproduced in any scope tried (see X15: bu_all.tsv every-offset 654/530, even 181/73, even&P6 and even&P7 below). No scope given in doc 103; one rts/l byte-checked (0x0767BC 54 13)",
  "Confirmed (not reproducible)","count","C97 X15",[0x0767BC],
  [("103-home-keytable.md",78,"the image has 301 `rts/l` and 251 `rte/l`")],[(RES,218,"The rts/l / rte/l counts are not reproducible.")],"M13, M14"),
 ("E55","C","dsp-1c03/opcode-1c.tsv:40 (NEW)","`0743CC\tfc 00 6a 8c b0 cc`",
  "0x0743CA fc 00 6a 8c b0 cc; 0x0743CC is the store (6a 8c b0 cc). Twin of E51 one row lower; doc 106:131 cites 0x0743CC without bytes and is right",
  "Confirmed (new)","listing convention +2","C48 W07",[0x0743CA],
  [(OPC,40,"0743CC\tfc 00 6a 8c b0 cc")],[],"N15 (this lane)"),
 ("E56","C","RESUME-FULL:36-37; m-wave-recon/README.md:22 (NEW)","`0x06ADE4 0c cb 58 70 00 28 eb 07 5e 06 ac d6 58 00 00 1e`",
  "The run is at 0x06ADE6. 0x06ADE4 holds 00 2e (end of the previous instruction). The arm structure the orchestrator describes is unaffected",
  "Confirmed (new)","address +2","C17 W02",[0x06ADE6],
  [(RES,36,"`0x06ADE4 0c cb 58 70 00 28 eb 07 5e 06 ac d6"),(RDM,22,"`0x06ADE4 0c cb 58 70 00 28 eb 07 5e 06 ac d6 58 00 00 1e`")],[],"N15 (this lane)"),
 ("E57","C","RESUME-FULL:39-40 (NEW)","\"The other `jsr` sites to the leaves (`0x06281A`, `0x06724A`, `0x062814`) are not proven\"",
  "0x06281A and 0x06724A are jsr @0x066FAA (5e 06 6f aa), which is not one of the four dropped leaves (0x066FAA is P7=1). Only 0x062814 (jsr @0x06726A) is a leaf site outside M4's demoted runs. All twelve jsr sites to the four leaves are P7=0, so the conclusion stands",
  "Confirmed (new)","mislabel","C98 C99 X06",[0x062814,0x06281A,0x06724A],
  [(RES,40,"(`0x06281A`, `0x06724A`, `0x062814`) are not proven")],[],"N15 (this lane)"),
]

def tsvsafe(s): return str(s).replace("\t", "\\t").replace("\n", " ")
err_rows = []
for (eid, sec, doc, asw, corr, verdict, cls, anchors, maddr, own, src, srcname) in E:
    ar = " ".join("%s:%s" % (a, res.get(a, "?")) for a in anchors.split())
    allpass = all(res.get(a) in ("PASS", "SLIP-CONFIRMED") for a in anchors.split())
    err_rows.append((eid, sec, doc, asw, corr, verdict if allpass else "CHECK-FAILED", cls, ar, mk(maddr),
                     "no (named delta 0, proven delta 0)", "no", srcname, tc(own), tc(src) if src else "n/a (new)"))

with open(os.path.join(OUT, "bytecheck.tsv"), "w", encoding="utf-8", newline="\n") as f:
    f.write("id\timage\taddr\tfile_off\texpected\tactual\tresult\tmeaning\n")
    for r in rows_b: f.write("\t".join(tsvsafe(x) for x in r) + "\n")
    for r in X: f.write("%s\tcomputed\t\t\t\t\t%s\t%s [scope: %s]\n" % (r[0], r[1], tsvsafe(r[2]), r[3]))
with open(os.path.join(OUT, "errata.tsv"), "w", encoding="utf-8", newline="\n") as f:
    f.write("id\tsection\tdoc_line\tas_written\tcorrected\tverdict\tclass\tanchors\tmask_at_corrected (final7 P7/N7)\tcredited_byte_affected\tmission_answer_affected\tsource\towning_text_check\tsource_text_check\n")
    for r in err_rows: f.write("\t".join(tsvsafe(x) for x in r) + "\n")
with open(os.path.join(OUT, "sweep.tsv"), "w", encoding="utf-8", newline="\n") as f:
    f.write("file\tline\taddr\tcited\timage\tresult\n")
    for r in sweep: f.write("\t".join(tsvsafe(x) for x in r) + "\n")

nC = sum(1 for c in C if res[c[0]] == "PASS")
nW = sum(1 for w in W if res[w[0]] == "SLIP-CONFIRMED")
nX = sum(1 for x in X if x[1] == "PASS")
nO = sum(1 for r in err_rows if r[12] == "PASS")
nS = sum(1 for r in err_rows if r[13] in ("PASS", "n/a (new)"))
nV = sum(1 for r in err_rows if r[5] != "CHECK-FAILED")
summary = ["MAIN sha256 %s OK" % hm, "SUB  sha256 %s OK" % hs,
           "byte runs C: %d/%d PASS" % (nC, len(C)), "as-written W: %d/%d SLIP-CONFIRMED" % (nW, len(W)),
           "computed X: %d/%d PASS" % (nX, len(X)), "errata rows: %d, anchors all pass: %d" % (len(err_rows), nV),
           "owning-line text checks: %d/%d PASS" % (nO, len(err_rows)), "source-line text checks: %d/%d PASS or new" % (nS, len(err_rows)),
           "sweep: %d RESUME/README citations, %d non-PASS; doc 142 self-sweep %d" % (n_before, len(bad), len(self_rows)),
           "named delta 0 B, proven delta 0 B (no mask byte changed by any row)"]
for r in X: summary.append("%s %s %s" % r[:3])
for r in err_rows:
    if r[12] != "PASS" or r[13] not in ("PASS", "n/a (new)") or r[5] == "CHECK-FAILED":
        summary.append("ROW %s: verdict=%s own=%s src=%s" % (r[0], r[5], r[12], r[13]))
for c in C + W:
    if res[c[0]] not in ("PASS", "SLIP-CONFIRMED"): summary.append("BYTE %s %s" % (c[0], res[c[0]]))
open(os.path.join(OUT, "run.txt"), "w", encoding="utf-8", newline="\n").write("\n".join(summary) + "\n")
print("\n".join(summary))
