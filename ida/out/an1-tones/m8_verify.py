"""Lane M8 (doc 120): byte-check every citation against the images, recompute the tone math,
and regenerate sensor.tsv and tones.tsv. Read-only on both images.
    python "ida/out/an1-tones/m8_verify.py"
Exit code 0 only if every citation matches."""
import sys
from pathlib import Path as _Path
_REPO_S = _Path(__file__).resolve().parents[3].as_posix()
import hashlib, math, os, sys

ROOT = _REPO_S
OUT = os.path.join(ROOT, r"ida\out\an1-tones")
sys.exit("The firmware image is not in this repository.")
sys.exit("The firmware image is not in this repository.")
SB = 0xFFC00000
PHI = 16_000_000  # MAIN peripheral clock, doc 76 (TPU5 phi/4, TGRA 0x4E20 -> 5 ms)

fails = []
ncheck = 0


def chk(img, addr, hexbytes, note=""):
    global ncheck
    ncheck += 1
    exp = bytes.fromhex(hexbytes.replace(" ", ""))
    data, off = (M, addr) if img == "M" else (S, addr - SB)
    got = data[off:off + len(exp)]
    if got != exp:
        fails.append("%s %08X exp %s got %s %s" % (img, addr, exp.hex(" "), got.hex(" "), note))


def be16(o): return int.from_bytes(M[o:o + 2], "big")
def be32(o): return int.from_bytes(M[o:o + 4], "big")


# ---------------- citations (MAIN) ----------------
C = [
    # A/D setup and readers
    (0x0021EE, "fc 00 3c a0 3c a1", "init ADCSR=0 ADCR=0"),
    (0x00010C, "00 00 24 b6", "vector 67 -> sub_24B6"),
    (0x00258E, "fc 00 3c a0 3c a1", "sub_24B6 ADCSR=0 ADCR=0"),
    (0x0032C0, "fc 02 3c a0 7f a0 70 50 7e a0 73 50 46 fa 7f a0 72 70 2c 94 6a 8c a9 92", "AN2 -> A992"),
    (0x0032D8, "fc 03 3c a0", "AN3 select"), (0x0032EA, "2c 96 6a 8c a9 93", "AN3 -> A993"),
    (0x0032F0, "6a 0c 8d de 46 30", "AN4/AN5 only when 8DDE==0"),
    (0x0032F6, "fc 04 3c a0", "AN4 select"), (0x003308, "2c 98 6a 8c a9 94", "AN4 -> A994"),
    (0x00330E, "fc 05 3c a0", "AN5 select"), (0x003320, "2c 9a 6a 8c a9 95", "AN5 -> A995"),
    (0x003326, "6a 0c 95 50 58 60 01 36 fc 06 6a 8c 95 50", "AN0 every 60 ms (9550 reload 6)"),
    (0x003334, "fc 00 3c a0", "AN0 select"),
    (0x003346, "2c 90 6a 8c a9 8c f4 00 79 06 1a e6 52 46 5e 03 fa 2c", "AN0 -> A98C, x0x1AE6, BCD"),
    (0x003362, "79 26 01 00 58 40 00 f4", ">= 10.0 V -> type 0 (external)"),
    (0x003374, "f3 01 fb 01 79 26 00 76", "type 1 (Li) 7.6 V threshold"),
    (0x0033C0, "f3 02 fb 01 ae 39", "type 2 (dry) 3.9 V threshold"),
    (0x00345E, "01 00 6b 83 a9 bc", "A9BC = BCD volts, A9BE type, A9BF bars"),
    (0x003478, "2c 90", "sub_3466 AN0 read"), (0x00348A, "79 26 00 90 54 70", "sub_3466: 9.0 V test"),
    (0x034AD6, "6a 0c a9 be ac 02 47 10", "sub_34AD2 battery type 2"),
    (0x034AF4, "aa 02 45 02 fa 01", "dry cell -> power <= 1 (LOW2)"),
    (0x0089E4, "20 56 6f 6c 74 20 45 78 74", "' Volt Ext'"),
    (0x04E586, "54 65 6d 70", "'Temp' (APRS weather text)"),
    (0x034D0A, "6a 0c aa ce 1a 0c 6a 8c aa ce 46 0c", "AACE countdown"),
    # AN1
    (0x034538, "6a 0c 95 51 46 1e fc 08 6a 8c 95 51 fc 01 3c a0 7f a0 70 50 7e a0 73 50 46 fa 7f a0 72 70 2c 92 6a 8c a9 96", "AN1 sample, main TX dispatcher"),
    (0x03455C, "fc 00 6a 8c aa d7", "AAD7 cleared each pass"),
    (0x035C14, "6a 0c 95 51 46 1e fc 08 6a 8c 95 51 fc 01 3c a0", "AN1 sample, node twin"),
    (0x035C32, "2c 92 6a 8c a9 96", "twin AN1 -> A996"),
    (0x035CD0, "6a 0c aa d9 46 00 54 70", "twin: AN1 protection not called"),
    (0x03465C, "6a 0c aa d7 47 10 fc 00 6a 8c aa d7 6a 0c aa d9 46 04 5e 03 5b aa", "tail: AAD7 && !AAD9 -> sub_35BAA"),
    (0x035BAA, "5e 03 4a d2 6a 0c aa d8 4b 02 0c ca 6a 0c a9 96 ac eb 45 54 ac ef 45 1c ac f4 45 20", "thresholds"),
    (0x035BC6, "6a 0c 8d de 46 06 fc 1d 6a 8c aa e0 5e 03 4f 74 fc 01 6a 8c aa d9", "cutoff: tone 1D, sub_34F74, AAD9=1"),
    (0x035BDE, "aa 02 45 30 fa 01 40 06 aa 00 47 28 fa 00", "step to 1 / to 0"),
    (0x035BF2, "fc 32 6a 8c aa e0 fc 23 5e 01 bf 40", "tone 0x32, popup call 0x23"),
    (0x035BFE, "6a 18 aa d2 72 30 6a 8a aa d8 5e 03 4b 06", "AAD8=level, apply"),
    (0x01BF40, "ac 02 45 32 ac 0c 44 2e 6a 8c 94 f5", "sub_1BF40 accepts 2..0x0B only"),
    (0x034D2C, "fc 01 6a 8c aa d7", "AAD7=1 state 2"),
    (0x035A18, "fc 01 6a 8c aa d7", "AAD7=1 state 0x10"), (0x035A62, "fc 01 6a 8c aa d7", "AAD7=1 state 0x10"),
    (0x035A9A, "fc 01 6a 8c aa d7", "AAD7=1 state 0x11"), (0x035B52, "fc 01 6a 8c aa d7", "AAD7=1 state 0x13"),
    (0x00EE0A, "fc 00 6a 8c aa d9", "AAD9 clear sub_ED16"), (0x03269C, "fc 00 6a 8c aa d9", "AAD9 clear sub_3266E"),
    (0x034774, "fc 00 6a 8c aa d9", "AAD9 clear sub_34706 (per TX)"), (0x035D88, "fc 00 6a 8c aa d9", "AAD9 clear twin"),
    (0x03476E, "fc ff 6a 8c aa d8", "AAD8 = 0xFF per TX"), (0x034750, "6a 8c aa da 6a 8c 95 51", "9551 = 0 per TX"),
    (0x035B5A, "6a 0c aa d9 46 38", "state 0x13 abort on AAD9"), (0x035B98, "5e 05 ec fe", "abort -> loc_5ECFE"),
    (0x0616C2, "6a 10 aa d9 77 00 6a 18 b2 66 67 70", "AAD9 -> B266.b7 (result tone)"),
    (0x0616D8, "8c 59 6a 8c aa e0", "tone 0x59 + trip"),
    # vectors
    (0x000160, "00 00 28 d0", "vec 88 TPU0 TGIA"), (0x000174, "00 00 29 50", "vec 93 TPU1 TGIA"),
    (0x000184, "00 00 28 e2", "vec 97 TPU2 TGIA"), (0x000110, "00 00 28 f4 00 00 29 22", "vec 68/69 IRQ4/5"),
    (0x0001B8, "00 00 2a 30", "vec 110 TPU5 tick"),
    # ISRs
    (0x0028D0, "01 20 6d f4 7f c5 72 00 2c 40 01 00 6b 06 81 1a 59 60", "TPU0 ISR -> @811A"),
    (0x0028E2, "01 20 6d f4 7f e5 72 00 2c 40 01 00 6b 06 81 1e 59 60", "TPU2 ISR -> @811E"),
    (0x0028F4, "01 10 6d f4 6b 0d ff c6 79 04 00 00 6b 84 ff c6 6b 04 ff 36 72 4c", "IRQ4: TCNT0 period"),
    (0x002950, "01 10 6d f4 7f d5 72 00 6a 10 aa d2 73 70 47 1c 7a 05 00 00 00 00 6b 04 aa b2 0c 4d 6e 5d 36 56 3d 69 6b 05 aa b4 09 45 6b 85 aa b2", "TPU1 ISR CTCSS DDS -> DA1"),
    (0x00297C, "6a 10 aa d2 73 20 47 40", "TPU1 ISR DTMF gate"),
    (0x0029A8, "3e 68", "DTMF -> DA0"), (0x0029AA, "01 00 6b 05 aa ba 01 00 6b 06 aa be 09 ed 09 65", "two phase adds"),
    # init TPU / TMR / DA
    (0x0022C4, "fc 20 3c c0 fc c0 3c c1 fc 00 3c c2 3c c3 fc 40 3c c4 fc 20 3c d0 fc c0 3c d1 fc 00 3c d2 fc 40 3c d4", "TPU0/1 init"),
    (0x002324, "fc 0c 6a 8c fe c0 fc 00 6a 8c fe ca fc 00 6a 8c fe c2 fc 02 6a 8c fe c1 fc 00 6a 8c fe cb fc 00 6a 8c fe c3", "TMR init"),
    (0x002350, "fc 03 3c 6b fc 7f 3c 69 fc 7f 3c 68", "DA0/DA1 mid-scale"),
    (0x002378, "fc df 3c 6a", "DACR = 0xDF"), (0x03EC90, "fc 1f 3c 6a", "DACR = 0x1F before standby"),
    # CTCSS / pager
    (0x0351D6, "fc 20 3c d0 79 04 00 00 6b 84 ff d6 79 04 09 89 6b 84 ff d8 7f bc 70 10 7f d4 70 00", "TPU1 start TGRA1=0x989"),
    (0x0351BC, "6a 10 aa d2 73 70 46 10 6a 10 aa d2 73 20 46 08 7f bc 72 10 7f d4 72 00", "TPU1 stop when no CTCSS/DTMF"),
    (0x034BD8, "ac 07 46 16 fc 32 6a 8c 95 79 6a 0b 89 6a 6a 10 aa d1 73 70 47 04 6a 0b 89 6b", "class 7 pager A/B"),
    (0x034BFA, "78 30 6b 24 00 03 51 58 6b 84 aa b4 79 04 00 00 6b 84 aa b2 6a 18 aa d2 70 70 5e 03 51 d6", "AAB4=word_35158[i]"),
    (0x034CF4, "5e 03 ef 6e ac 07 46 30 6a 0c 95 79 46 2a", "state 2 class-7 timer"),
    (0x034D22, "6a 18 aa d1 71 70 5e 03 4b ca", "toggle A/B"),
    (0x034B6A, "5e 03 ef 6e ac 00 47 32 ac 03 47 04 55 52", "class dispatch"),
    (0x03EF90, "6e 0c 00 16 7a 64 00 00 00 ff 6e 4c 3c 88", "class = 3C88[+0x16]"),
    (0x003C88, "00 01 02 03 00 00 00 07 00 03 02 03", "TX class map"),
    # DCS
    (0x034C1A, "55 ac 5e 03 57 e8 5e 02 fb e2 5e 00 04 50 fc 00 6a 8c aa cd 5e 02 f5 5a", "sub_34C1A"),
    (0x000450, "6e 0c 00 18 7a 05 00 00 07 06 55 d0", "sub_450: code idx, handler 0x706"),
    (0x00042C, "01 00 6b 85 81 1a 7a 64 00 00 00 ff 10 74 01 00 6f 45 0b 8c 79 04 74 40 6b 84 8f 96", "sub_42C"),
    (0x00045C, "6a 10 8f 85 73 20 46 06 7a 55 ff ff ff 00", "TX invert"),
    (0x000476, "79 04 0b a0 6b 84 8f 96", "TGRA0 = 0x0BA0"), (0x000490, "fc 17 6a 8c aa ca", "23 bits"),
    (0x02F55A, "fc 20 3c c0 79 04 00 00 6b 84 ff c6 6b 04 8f 96 6b 84 ff c8 7f bc 70 00 7f c4 70 00", "TPU0 start"),
    (0x000730, "6a 0c aa cb ac 08", "bit tick counter"), (0x00073E, "ac 21 45 46 47 06 ac 28 45 68", "40 ticks/bit"),
    (0x000762, "f4 17 6a 84 aa ca", "reload 23"), (0x000808, "3c 69", "DCS -> DA1"),
    (0x000D32, "00 7f 31 9c 00 70 2b c0", "ramp table"),
    (0x022794, "fc 01 6a 8c aa cd", "release: AACD.b0 turn-off"),
    (0x0008F0, "fc 02 6a 8c aa cd fc 1e 6a 8c aa cc fc 07 6a 8c aa cb", "turn-off start"),
    (0x00091A, "ac 0e 45 0e 47 06 ac 14 45 38", "20 ticks/half"),
    (0x000A7E, "5e 02 f5 50 fc 7f 3c 69", "turn-off end: stop TPU0, DA1 mid"),
    (0x02F550, "7f bc 72 00 7f c4 72 00 54 70", "sub_2F550 stop TPU0"),
    (0x034D66, "7e bc 73 00 46 02", "state 5 waits TSTR.b0"),
    (0x02FBE2, "6e 0b 00 35 7a 63 00 00 00 ff 6e 34 3b 68", "DCS INV -> 8F85"),
    (0x003B68, "00 01 02 04 05 06", "DCS INV map"),
    # T-CALL / TMR
    (0x0350C0, "79 04 00 47 5e 03 87 7a fc 02 6a 8c aa d6", "T-CALL 0x47"),
    (0x03877A, "6b 84 fe c4 79 04 00 00 6b 84 fe c8 6a 0c fe c3 cc 03 6a 8c fe c3", "TMR TCORA, toggle"),
    (0x0350EA, "5e 03 83 0a", "T-CALL stop"), (0x03830A, "6a 0c fe c3 ec f0 6a 8c fe c3", "TMR output off"),
    (0x038534, "6f 34 3a ce 6b 84 fe c4", "beep note -> TCORA"),
    # DTMF
    (0x038D38, "7a 63 00 00 00 ff 10 73 78 b0 6b 24 00 03 90 40 01 00 6b 84 aa be", "DTMF incs"),
    (0x038D5A, "6a 18 aa d2 70 20 5e 03 51 d6", "DTMF start TPU1"),
]
for a, h, n in C:
    chk("M", a, h, n)
# all TMR vectors 116..127 default
for v in range(116, 128):
    chk("M", v * 4, "00 00 20 92", "vec %d default" % v)

# ---------------- citations (SUB) ----------------
CS = [
    (0xFFF0B1E0, "fb e2 4d 8c 00 00 c5 e0 13 05", "popup id = [0x8C60]"),
    (0xFFF0B241, "71 1e ff 61 9e", "1..9"), (0xFFF0B256, "71 1e f4 61 3e", "0x0C..0x0E"),
    (0xFFF0B260, "71 1e f0 61 8e", "0x10..0x17"), (0xFFF0B26A, "71 1e e0 61 2e", "0x20..0x21"),
    (0xFFF0B2A6, "72 1e 60 ff 61 fe 25 3f", "0xA0..0xAF"), (0xFFF0B2DA, "60 a1 61 11 25 05", "0x0A..0x0B"),
    (0xFFF0B728, "75 51 a9 3a 7e 05", "case 0xA9"), (0xFFF0BCCB, "fb 42 33 ab f4 ff", "-> HEAT"),
    (0xFFF4AB33, "48 45 41 54 00", "'HEAT'"),
    (0xFFF49B75, "54 45 4d 50 00", "'TEMP' (APRS unit group)"),
    (0xFFF487E5, "56 4f 4c 54 00", "'VOLT'"),
]
for a, h, n in CS:
    chk("S", a, h, n)

# ---------------- derived facts ----------------
facts = []
# AN1 read census: mov.b @0x92:8 (0x2r 0x92) at even offsets outside the vector table
an1 = [i for r in range(16) for i in range(0x400, 0x7B754, 2) if M[i] == (0x20 | r) and M[i + 1] == 0x92]
an1 = sorted(set(an1))
facts.append("even-aligned '2r 92' outside vectors: %s" % " ".join("%06X" % x for x in an1))
adcsr = []
i = M.find(b"\x3c\xa0")
while i >= 0:
    if i % 2 == 0 and i < 0x7B754:
        adcsr.append((i, M[i - 1] if M[i - 2] == 0xFC else None))
    i = M.find(b"\x3c\xa0", i + 1)
facts.append("ADCSR byte writes (site, value): %s" % " ".join("%06X=%s" % (a, "?" if v is None else v) for a, v in adcsr))

# CTCSS
fs1 = PHI / (0x0989 + 1)
ctcss = [be16(0x35158 + 2 * k) for k in range(50)]
STD = [67.0, 69.3, 71.9, 74.4, 77.0, 79.7, 82.5, 85.4, 88.5, 91.5, 94.8, 97.4, 100.0, 103.5, 107.2, 110.9, 114.8,
       118.8, 123.0, 127.3, 131.8, 136.5, 141.3, 146.2, 151.4, 156.7, 159.8, 162.2, 165.5, 167.9, 171.3, 173.8,
       177.3, 179.9, 183.5, 186.2, 189.9, 192.8, 196.6, 199.5, 203.5, 206.5, 210.7, 218.1, 225.7, 229.1, 233.6,
       241.8, 250.3, 254.1]
assert [round(x / 10, 1) for x in ctcss] == STD, "CTCSS list"
facts.append("TPU1 fs = 16e6/2442 = %.3f Hz; f = inc*fs/65536 = inc*%.6f Hz" % (fs1, fs1 / 65536))
# sine
err = max(abs(M[0x3656 + k] - (127 + 127 * math.sin(2 * math.pi * k / 256))) for k in range(256))
facts.append("sine table 0x3656: 256 B, max |err| vs 127+127 sin = %.2f LSB" % err)
assert err < 1.5
# DTMF
ROW, COL = [697, 770, 852, 941], [1209, 1336, 1477, 1633]
KEYS = "0123456789ABCD*#"
GRID = {"1": (0, 0), "2": (0, 1), "3": (0, 2), "A": (0, 3), "4": (1, 0), "5": (1, 1), "6": (1, 2), "B": (1, 3),
        "7": (2, 0), "8": (2, 1), "9": (2, 2), "C": (2, 3), "*": (3, 0), "0": (3, 1), "#": (3, 2), "D": (3, 3)}
dtmf = []
for k in range(16):
    w = be32(0x39040 + 4 * k)
    lo, hi = w >> 16, w & 0xFFFF
    r, c = GRID[KEYS[k]]
    assert lo == ROW[r] * 10 and hi == COL[c] * 10, ("dtmf", k)
    dtmf.append((k, KEYS[k], lo, hi))
# DCS: 104 codewords, LSB-first data + '100' flag + Golay parity
DCS = [0o23, 0o25, 0o26, 0o31, 0o32, 0o36, 0o43, 0o47, 0o51, 0o53, 0o54, 0o65, 0o71, 0o72, 0o73, 0o74, 0o114,
       0o115, 0o116, 0o122, 0o125, 0o131, 0o132, 0o134, 0o143, 0o145, 0o152, 0o155, 0o156, 0o162, 0o165, 0o172,
       0o174, 0o205, 0o212, 0o223, 0o225, 0o226, 0o243, 0o244, 0o245, 0o246, 0o251, 0o252, 0o255, 0o261, 0o263,
       0o265, 0o266, 0o271, 0o274, 0o306, 0o311, 0o315, 0o325, 0o331, 0o332, 0o343, 0o346, 0o351, 0o356, 0o364,
       0o365, 0o371, 0o411, 0o412, 0o413, 0o423, 0o431, 0o432, 0o445, 0o446, 0o452, 0o454, 0o455, 0o462, 0o464,
       0o465, 0o466, 0o503, 0o506, 0o516, 0o523, 0o526, 0o532, 0o546, 0o565, 0o606, 0o612, 0o624, 0o627, 0o631,
       0o632, 0o654, 0o662, 0o664, 0o703, 0o712, 0o723, 0o731, 0o732, 0o734, 0o743, 0o754]
assert len(DCS) == 104


def polymod(v, g, n):
    for b in range(n - 1, 11 - 1, -1):
        if v >> b & 1:
            v ^= g << (b - 11)
    return v


dcs_ok = 0
for k in range(104):
    w = be32(0xB8C + 4 * k)
    assert w & 0x1FF == 0
    bits = [(w >> (31 - j)) & 1 for j in range(23)]          # transmission order (MSB first)
    data = sum(bits[j] << j for j in range(12))               # first 12 bits, LSB first
    code = data & 0x1FF
    assert code == DCS[k] and (data >> 9) == 0b100, ("dcs", k, oct(code))
    cw = sum(bits[j] << j for j in range(23))                 # codeword polynomial, bit j = x^j
    if polymod(cw, 0xC75, 23) == 0 or polymod(cw, 0xAE3, 23) == 0:
        dcs_ok += 1
facts.append("DCS table 0xB8C: 104/104 entries = standard DCS list in order; Golay(23,12) divisible: %d/104" % dcs_ok)
assert dcs_ok == 104
fs0 = PHI / (0x0BA0 + 1)
facts.append("TPU0 DCS tick = 16e6/2977 = %.2f Hz; /40 = %.3f bps; turn-off tone /40 = %.2f Hz" % (fs0, fs0 / 40, fs0 / 40))
# DCS ramp tables: 0xD32/0xD72 16 x 4 B, 0xDB2/0xDEA 14 x 4 B; word == 100 * amplitude byte
ramp_ok = 0
for base, n in ((0xD32, 16), (0xD72, 16), (0xDB2, 14), (0xDEA, 14)):
    for k in range(n):
        e = M[base + 4 * k:base + 4 * k + 4]
        assert e[0] in (0x00, 0x80) and int.from_bytes(e[2:4], "big") == 100 * e[1], ("ramp", hex(base), k)
        ramp_ok += 1
assert 0xDEA + 14 * 4 == 0xE22
facts.append("DCS ramp tables 0xD32/0xD72 (16) 0xDB2/0xDEA (14): %d/60 entries word==100*amp; 0xDEA ends at 0x000E21" % ramp_ok)
# TMR / T-CALL
clk = PHI / 64
notes = [be16(0x3ACE + 2 * k) for k in range(37)]
C4 = 261.6256
worst = max(abs(clk / (2 * n) / (C4 * 2 ** (k / 12)) - 1) for k, n in enumerate(notes))
facts.append("TMR clk phi/64 = %.0f Hz; note table 0x3ACE 37 entries C4..C7 fit f=clk/(2N) within %.2f%%" % (clk, 100 * worst))
tcall_act = clk / (2 * (0x47 + 1))
tcall_nom = clk / (2 * 0x47)
facts.append("T-CALL TCORA 0x47: actual clk/(2*(N+1)) = %.1f Hz; design N=clk/(2*1750)=%.1f -> 71" % (tcall_act, clk / 3500))

# ---------------- tables ----------------
cls_names = ["OFF", "TONE", "TONE SQL", "DCS", "REV TONE", "JR FREQ", "PR FREQ", "PAGER", "(blank)", "D CD",
             "TONE-DCS", "D CD-TONE SQL"]
with open(os.path.join(OUT, "tones.tsv"), "w", encoding="utf-8", newline="\n") as h:
    h.write("generator\titem\taddress\tbytes\tvalue\tmath\tresult\tconfidence\n")
    w = lambda *r: h.write("\t".join(str(x) for x in r) + "\n")
    w("CTCSS", "TPU1 TCR/TGRA1", "0x0351D6", M[0x351D6:0x351EA].hex(" "), "TCR=0x20 TGRA1=0x0989", "16e6/(0x989+1)", "%.3f Hz sample rate" % fs1, "Confirmed bytes; phi from doc 76")
    w("CTCSS", "TPU1 ISR vec 93", "0x002950", M[0x2950:0x297C].hex(" "), "AAB2+=AAB4; DA1=sine[AAB2>>8]", "f=AAB4*fs/65536", "%.6f Hz per unit" % (fs1 / 65536), "Confirmed")
    w("CTCSS", "sine table", "0x003656", M[0x3656:0x365E].hex(" ") + " ...", "256 B 0x00..0xFE", "127+127sin", "max err %.2f LSB" % err, "Confirmed")
    for k, v in enumerate(ctcss):
        w("CTCSS", "word_35158[%d]" % k, "0x%06X" % (0x35158 + 2 * k), M[0x35158 + 2 * k:0x3515A + 2 * k].hex(" "), v, "%d*%.6f" % (v, fs1 / 65536), "%.2f Hz (nominal %.1f)" % (v * fs1 / 65536, STD[k]), "Confirmed")
    w("PAGER", "class 7 tones", "0x034BD8", M[0x34BD8:0x34BF2].hex(" "), "FF896A/FF896B alternate", "FF9579=0x32 (10 ms tier)", "490-500 ms per tone", "Confirmed bytes")
    w("PAGER", "answer-back length", "0x034D0A", M[0x34D0A:0x34D1C].hex(" "), "AACE=5 decrements per toggle", "5 x 0.5 s", "~2.5 s (L8)", "Confirmed bytes")
    for k, n in enumerate(cls_names):
        w("CLASS", "3C88[%d] %s" % (k, n), "0x%06X" % (0x3C88 + k), "%02x" % M[0x3C88 + k], M[0x3C88 + k], "0 none,1/2 CTCSS,3 DCS,7 pager", "", "Confirmed bytes; names doc 38")
    w("DCS", "TPU0 TGRA0", "0x000476", M[0x476:0x47E].hex(" "), "0x0BA0", "16e6/2977", "%.2f Hz tick" % fs0, "Confirmed")
    w("DCS", "bit length", "0x00073E", M[0x73E:0x748].hex(" "), "AACB 1..0x28", "40 ticks/bit", "%.3f bps (nominal 134.4)" % (fs0 / 40), "Confirmed")
    w("DCS", "word length", "0x000490", M[0x490:0x496].hex(" "), "AACA=0x17", "23-bit word, repeats", "", "Confirmed")
    w("DCS", "codeword table", "0x000B8C", M[0xB8C:0xB94].hex(" ") + " ...", "104 x BE32", "LSB-first code+100+Golay", "104/104 standard codes", "Confirmed")
    w("DCS", "TX invert", "0x00045C", M[0x45C:0x46A].hex(" "), "8F85.b2 -> xor 0xFFFFFF00", "F342 DCS INVERSION via 0x3B68", "", "Confirmed bytes; setting name doc 38")
    w("DCS", "edge ramps", "0x000D32", M[0xD32:0xD3A].hex(" ") + " ...", "16-step +/-127 ramps 0xD32/0xD72; 14-step 0xDB2/0xDEA", "DA1=0x7F -/+ (w-amp*AADE)/100", "AADE never written by abs16", "Confirmed bytes")
    w("DCS", "turn-off", "0x0008F0", M[0x8F0:0x902].hex(" "), "AACC=0x1E half-cycles, 20 ticks each", "fs0/40", "%.2f Hz for ~%.0f ms" % (fs0 / 40, (30 * 20 - 6) / fs0 * 1000), "Confirmed bytes")
    for k in range(104):
        w("DCS", "code[%d]" % k, "0x%06X" % (0xB8C + 4 * k), M[0xB8C + 4 * k:0xB90 + 4 * k].hex(" "), "D%03o" % DCS[k], "", "", "Confirmed")
    w("T-CALL", "TMR init TCR", "0x002324", M[0x2324:0x2348].hex(" "), "FEC0=0x0C FEC1=0x02 FECB=0", "CKS=010,ICKS=00 -> phi/64; 16-bit cascade", "%.0f Hz count" % clk, "Inferred (TMR map)")
    w("T-CALL", "TCORA", "0x0350C0", M[0x350C0:0x350C8].hex(" "), "0x0047", "clk/(2*(N+1))", "%.1f Hz (design 1750)" % tcall_act, "Inferred (clock); bytes Confirmed")
    w("T-CALL", "note table cross-check", "0x003ACE", M[0x3ACE:0x3AD6].hex(" ") + " ...", "37 notes", "clk/(2N)", "C4..C7 within %.2f%%" % (100 * worst), "Confirmed fit")
    for k, key, lo, hi in dtmf:
        w("DTMF", "dword_39040[%d] '%s'" % (k, key), "0x%06X" % (0x39040 + 4 * k), M[0x39040 + 4 * k:0x39044 + 4 * k].hex(" "), "%d/%d" % (lo, hi), "inc*fs/65536", "%.1f + %.1f Hz -> DA0" % (lo * fs1 / 65536, hi * fs1 / 65536), "Confirmed")

with open(os.path.join(OUT, "sensor.tsv"), "w", encoding="utf-8", newline="\n") as h:
    h.write("channel\trole\treader\taddress\tbytes\tstore\tconsumer\tconfidence\n")
    w = lambda *r: h.write("\t".join(str(x) for x in r) + "\n")
    w("AN0 (ADDRA 0xFFFF90)", "supply/battery voltage", "sub_32C0 every 60 ms; sub_3466 at boot", "0x003346", M[0x3346:0x3358].hex(" "), "A98C raw; A9BC BCD volts, A9BE type 0/1/2, A9BF bars", "main loop, sub_34AD2 (dry cell -> LOW2 cap), display", "Inferred strong (BCD V, 'Volt Ext/Lit/Dry')")
    w("AN1 (ADDRB 0xFFFF92)", "TX protection sensor", "sub_34538 / sub_35C14 every 80 ms while FF94C0==1", "0x034544", M[0x34544:0x3455C].hex(" "), "A996", "sub_35BAA only (main machine)", "Unknown identity; PA temperature Inferred low-moderate")
    w("AN2 (ADDRC 0xFFFF94)", "per-band level (band A)", "sub_32C0", "0x0032D2", M[0x32D2:0x32D8].hex(" "), "A992", "sub_67DA, sub_23496, sub_306EA", "Unknown")
    w("AN3 (ADDRD 0xFFFF96)", "per-band level (band A)", "sub_32C0", "0x0032EA", M[0x32EA:0x32F0].hex(" "), "A993", "sub_67DA, sub_23496, sub_3E060, sub_3E110", "Unknown")
    w("AN4 (ADDRE 0xFFFF98)", "per-band level (band B)", "sub_32C0 if 8DDE==0", "0x003308", M[0x3308:0x330E].hex(" "), "A994", "sub_67DA, sub_23496, sub_3210C", "Unknown")
    w("AN5 (ADDRF 0xFFFF9A)", "per-band level (band B)", "sub_32C0 if 8DDE==0", "0x003320", M[0x3320:0x3326].hex(" "), "A995", "sub_67DA, sub_23496, sub_3E26C, sub_3E31A", "Unknown")
    w("AN1 thresholds", "foldback/cutoff", "sub_35BAA", "0x035BBA", M[0x35BBA:0x35BC6].hex(" "), ">=0xEB L<=1, >=0xEF L=0, >=0xF4 cut", "AAD8, AAD9", "Confirmed")
    w("AAD9 clear", "trip latch", "sub_34706 per TX; sub_3266E; sub_ED16; twin sub_35D4C", "0x034774", M[0x34774:0x3477A].hex(" "), "AAD9=0", "next TX request", "Confirmed")
    w("popup 0x23", "dropped", "sub_1BF40", "0x01BF40", M[0x1BF40:0x1BF4C].hex(" "), "94F5 only for 2..0x0B", "never shown", "Confirmed")
    w("SUB HEAT", "message popup id 0xA9", "sub_FFF0B665", "0xFFF0B728", S[0xFFF0B728 - SB:0xFFF0B72E - SB].hex(" "), "string 0xFFF4AB33", "no MAIN imm writer of 0xA9 to BBE1 found", "Confirmed string; link Not found")

# ---------------- report ----------------
print("sha256 MAIN", hashlib.sha256(M).hexdigest()[:16], "SUB", hashlib.sha256(S).hexdigest()[:16])
for f in facts:
    print(f)
print("citations checked: %d, failed: %d" % (ncheck, len(fails)))
for f in fails:
    print("FAIL", f)
sys.exit(1 if fails else 0)
