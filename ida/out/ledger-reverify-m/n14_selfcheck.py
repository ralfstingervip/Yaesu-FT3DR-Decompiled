import sys
from pathlib import Path as _Path
_REPO = _Path(__file__).resolve().parents[3]
# N14 -- byte-check every citation written in docs\deep\141-ledger-reverify-m.md against the images. Read-only.
# MAIN: H8SX big-endian, base 0 (file offset = address). SUB: RX little-endian, base 0xFFC00000. Writes selfcheck.tsv.
import os, sys, hashlib
sys.dont_write_bytecode = True
ROOT = str(_REPO)
OUT = os.environ.get("OUTDIR", os.path.dirname(os.path.abspath(__file__)))
sys.exit('The firmware image is not in this repository.')
assert hashlib.sha256(M).hexdigest() == "8e3ecd05409b2c314ebed77320ece5930bf31c8333cd84aeef4f6b0264c1bcce"
assert hashlib.sha256(S).hexdigest() == "b93570b3c2f69ccb51c113c893b4bc4c414cf78ceddde478748404e0768c6230"
C = [
    (0x06ADE2, "58 60 00 2e", "4-B bcc before the arm (seed head 06ADE2, size 4)"),
    (0x06ADE4, "00 2e 0c cb", "image at the cited 0x06ADE4"),
    (0x06ADE6, "0c cb 58 70 00 28 eb 07 5e 06 ac d6 58 00 00 1e", "arm run the README/RESUME cite"),
    (0x06ACD6, "0f 95 7a 15", "ordinary routine"),
    (0xFFF394CC, "75 41 e5", "mov #0xE5 (first)"), (0xFFF394CF, "05 59 40 fa", "bsr.a at the cited address"),
    (0xFFF39513, "75 41 e5", "mov #0xE5 (second)"), (0xFFF39516, "05 12 40 fa", "bsr.a at the cited address"),
    (0xFFF3906C, "75 41 e6 05 b9 44 fa", "E6 sender, bsr.a at FFF3906F"),
    (0x062806, "40 16 5e 06 6f b4 40 10 5e 06 72 50", "doc 116:85 run"), (0x062808, "5e 06 6f b4", "jsr 0x066FB4"),
    (0x063C04, "fc 00 6a 8c b2 a3", "image at doc 122's address"), (0x063C10, "fc 0a 6a 8c a9 f9", "mode-10 store"),
    (0x03600E, "6a 10 b0 bb 73 70 46 08", "sub_3600E: btst #7,@B0BB ; bne"), (0x036016, "fc 01 6a 8c aa d7", "sixth AAD7=1 store"),
    (0x035D24, "00 03 60 0e", "BE32 slot -> sub_3600E"),
    (0x034D2C, "fc 01 6a 8c aa d7", "listed site"), (0x035A18, "fc 01 6a 8c aa d7", "listed site"), (0x035A62, "fc 01 6a 8c aa d7", "listed site"),
    (0x035A9A, "fc 01 6a 8c aa d7", "listed site"), (0x035B52, "fc 01 6a 8c aa d7", "listed site"),
    (0x067748, "6a 8e bb e1", "the one BBE1 store from r6l"),
    (0x077140, "01 5d 40 70 fd 62", "6-B head; 40 70 at +2 is not a branch"), (0x077156, "01 5d 40 60 fd 62", "6-B head; 40 60 at +2"),
    (0x0771AE, "01 00 6d f2 0c 9a", "first bytes of the unreached 52 B"),
    (0x07B4BA, "00 07 84 be", "CDC record 0"), (0x07B4C4, "00 07 69 aa", "CDC record 1"), (0x07B4CE, "00 07 68 c8", "CDC record 2"),
    (0x07B4D8, "00 07 69 aa", "CDC record 3"), (0x07B4E2, "00 07 67 be", "CDC record 4"), (0x07B4EC, "00 07 68 a8", "CDC record 5"),
    (0x034A52, "6a 18 aa 30 70 40", "bset #4,@AA30"), (0x04B812, "7a 03 00 00 00 00 f4 03", "3-digit entry"),
    (0x0482C8, "6a 8c bb 92", "store to BB92"),
    (0x0351E2, "79 04 09 89", "TGRA1 = 0x989"), (0x000476, "79 04 0b a0", "TGRA0 = 0xBA0"), (0x0350C0, "79 04 00 47", "TCORA 0x47"),
    (0x069964, "6a 0c b3 f5", "live routine"), (0x069A7F, "6a 0c b3 f5", "stale copy"),
    (0x015288, "10 72 0a a5 01 00 69 56 47 08 5d 60", "sub_15260 record call"),
    (0x014986, "00 06 66 00", "666.00 kHz BCD"), (0x0149A2, "00 06 66 00", "666.00 kHz BCD"),
    (0x002200, "2c 4c ec 7f ac 7d", "strap key test"), (0x076F04, "a8 20", "first class-request compare"),
]
rows = []; bad = 0
for a, h, what in C:
    want = bytes.fromhex(h.replace(" ", "")); got = (S[a - 0xFFC00000:a - 0xFFC00000 + len(want)] if a >= 0xFFC00000 else M[a:a + len(want)])
    ok = got == want; bad += not ok
    rows.append(("%X" % a, h, got.hex(" "), "PASS" if ok else "FAIL", what))
s7 = M[0x069A7F:0x069A7F + 37] == M[0x069964:0x069964 + 37]
rows.append(("069A7F", "first 37 B == 0x069964", str(s7), "PASS" if s7 else "FAIL", "stale copy")); bad += not s7
with open(os.path.join(OUT, "selfcheck.tsv"), "w", encoding="utf-8", newline="\n") as f:
    f.write("address\tcited\tactual\tresult\tnote\n")
    for r in rows: f.write("\t".join(r) + "\n")
print("selfcheck %d/%d pass" % (len(rows) - bad, len(rows)))
sys.exit(1 if bad else 0)
