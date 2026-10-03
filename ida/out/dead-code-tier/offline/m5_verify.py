# Lane M5 - byte-check every (address, bytes) citation written in docs\deep\117-dead-code-tier.md against the image,
# and re-check the mask facts the doc states. Read-only. Writes ..\verify.txt
import sys
from pathlib import Path as _Path
_REPO_S = _Path(__file__).resolve().parents[4].as_posix()
import sys, hashlib
sys.path.insert(0, (_REPO_S + "/ida/out/dead-code-tier/offline"))
from m5_lib import *

CIT = [
    # dead prefix 0x0169D2 and stub 0x0169E8
    (0x0169B2, "7a 06 00 01 69 cc"), (0x0169CC, "00 31 00 ff aa 56"), (0x0169D2, "5e 01 51 ec 47 14 aa 01 47 0c"),
    (0x0169DC, "7a 06 00 01 69 ee 5e 03 f6 2e"), (0x0169E6, "40 04"), (0x0169E8, "5e 03 ff a0"), (0x0169EC, "54 70"),
    (0x015C90, "5e 01 69 dc"), (0x015CAC, "5e 01 69 dc"),
    (0x05DCD8, "40 06"), (0x05DCDA, "6a 0c b0 c4 46 18"), (0x05DCF6, "40 04 5e 03 ff a0 54 70"),
    # 01758E
    (0x01756E, "54 70"), (0x017570, "7a 01 00 01 75 8e 5e 01 52 06"), (0x01758E, "fc 00 6a 8c ba 33 5e 01 a0 a4 54 70"),
    (0x015224, "5d 10"),
    # 053496
    (0x053494, "54 70"), (0x053496, "fd 00 6a 8d b0 8d"), (0x0534A8, "fd 00 6a 8d b0 8d"), (0x053518, "54 70"),
    (0x05352C, "7a 04 00 05 35 44 5e 05 34 a8"), (0x05353E, "5e 05 34 a8 54 70"),
    # 06259A
    (0x062576, "44 49 52 45 43 54 20 45 4e 54 52 59"), (0x0625F4, "54 70"), (0x062624, "5e 06 25 d0 54 70"),
    (0x06259A, "f2 10 fa 00"),
    # 076C06
    (0x076B1E, "54 02 6d f2"), (0x076BE8, "47 1c"), (0x076C00, "6b f0 00 ff 63 14 6d 72 54 70"),
    # chained pieces
    (0x018726, "40 6e"), (0x01872A, "47 54"), (0x01872E, "47 36"), (0x061C52, "40 04 5e 06 db e0 54 70"),
    (0x0669D8, "40 04 5e 06 db e0 54 70"), (0x06DBE0, "54 70"),
    # 018FAA: reached through the 0x015260 record dispatch
    (0x017924, "7a 05 00 01 79 2e 5a 01 52 60"),
    (0x01792E, "00 01 a0 d4 00 01 79 4e 00 01 79 56 00 01 79 5e 00 01 79 6a 00 01 79 72 00 01 79 7a 00 01 79 82"),
    (0x01794E, "fc 00 5e 01 8f aa 40 32"), (0x017958, "5e 01 8f aa"), (0x01796C, "5e 01 8f aa"), (0x017974, "5e 01 8f aa"),
    (0x01797C, "5e 01 8f aa"), (0x017984, "5e 01 8f aa 54 70"),
    (0x01526A, "7a 02 00 00 00 00 6a 0a ad 68"), (0x01527C, "6a 0c ad 9d 47 06 01 00 69 56"),
    (0x015288, "10 72 0a a5 01 00 69 56 47 08 5d 60"),
    (0x018FA2, "6a 18 8a ab 61 c0 40 06 6a 18 8a ac 61 c0 6a 18 aa 30 70 60 54 70"),
    # 01E1C6 split
    (0x01E1A2, "54 70 79 24 96 60 47 24 79 24 94 01 46 2c"), (0x01E1C0, "78 b0 6b 26 00 01 e1 de"),
    (0x01E1C8, "01 10 6d 75 40 06"), (0x01E1DC, "54 70"),
    # 00835E
    (0x008318, "4d 55 54 45 20 3a 20 4f 46 46"), (0x00835E, "fd 00 6a 10 8d e0 73 70"), (0x00840A, "54 70"),
    (0x037E9C, "00 00 84 09"),
    # 0x019A9E offset switch
    (0x01919A, "78 60 6b 26 00 01 9a 9e 7a 16 00 01 48 a0 5d 60"), (0x019C3A, "7a 05"),
    (0x0762FE, "78 01 6b 20 00 07 85 46"),
    (0x076BC2, "01 7d 40 fd ee 00"), (0x076B88, "6a 89 ee 2c"), (0x076BBA, "01 00 6b a1 00 ff 62 f8"), (0x06256C, "00 07 6b 84"),
    (0x05E350, "00 01 0a 04"), (0x015224, "5d 10"), (0x018FB0, "6a 18 aa 30 70 60 54 70"),
    # example pieces in the doc
    (0x003532, "6a 8c a9 a4"), (0x024CCA, None), (0x046482, None),
    (0x0048C0, "00 00 48 e0"), (0x048C6 - 0x0000, "48 d8"),
    # Task 2 readers
    (0x03793E, "7a 06 00 03 79 88"), (0x037988, "00 08 00 11"), (0x01E174, "7a 05 00 01 e2 2c"),
    (0x0742F2, "7a 05 00 07 43 10"), (0x06597E, "78 40 6a 2b 00 06 5a 88"), (0x002416, "7a 05 00 00 24 5c"),
    (0x023F9E, "78 40 6a 2b 00 02 40 00"), (0x02D6FA, "7a 05 00 02 d7 04"), (0x02D7F4, "7a 05 00 02 d7 fe"),
    (0x02E2CE, "7a 05 00 02 e2 d8"), (0x02E3C8, "7a 05 00 02 e3 d2"), (0x034004, "7a 05 00 03 40 0e"),
    (0x02E61A, "7a 05 00 02 e6 40"), (0x033B4A, "7a 05 00 03 3b 70"), (0x0352EC, "7a 06 00 03 53 1e"),
    (0x0353D0, "78 20 6a 25 00 03 54 22"), (0x05C57C, "7a 05 00 05 c6 00"), (0x074444, "6a 2b 00 07 39 09"),
    (0x073ABA, "7a 01 00 07 39 08"), (0x01E5BE, "7a 06 00 01 e5 ee"), (0x016634, "78 40 6a 2c 00 01 66 42"),
    (0x01509A, "78 30 6a 2b 00 01 51 e6"), (0x04C2A8, "7a 05 00 04 c3 2c"), (0x04C32C, "00 09 54 48 2d 44 37"),
    (0x04C3C6, "00 01 02 03 04 ff 05 06 07 08 09 ff"),
    (0x02D71A, "7a 63 00 00 00 ff 0a b5 68 5b"), (0x03F768, "6c 5c ac ff"), (0x03F5EE, "01 00 69 64"),
    (0x05C9D6, "6c 5c ac ff"), (0x03F5B2, "01 00 6d f2 6d 62"),
]

out, bad = [], 0
for a, hx in CIT:
    if hx is None:
        out.append("%06X (existence only) %s" % (a, img[a:a + 8].hex(" "))); continue
    want = bytes.fromhex(hx.replace(" ", ""))
    got = img[a:a + len(want)]
    ok = got == want
    bad += not ok
    out.append("%s %06X want %s got %s" % ("OK  " if ok else "FAIL", a, hx, got.hex(" ")))

# mask facts
facts = []
pieces_b = sum(b - a for a, b, _ in pieces)
facts.append("pieces %d, bytes %d, named-in-final6 %d, proven-in-final6 %d" % (
    len(pieces), pieces_b, sum(sum(NM[a:b]) for a, b, _ in pieces), sum(sum(PM[a:b]) for a, b, _ in pieces)))
facts.append("final6 proven popcount %d named popcount %d" % (sum(PM), sum(NM)))
sys.exit("The firmware image is not in this repository.")
sys.exit("The firmware image is not in this repository.")
txt = "\n".join(out + ["", "citations %d, failed %d" % (len(CIT), bad)] + facts) + "\n"
open(O + r"\verify.txt", "w", encoding="utf-8", newline="\n").write(txt)
print(txt[-600:])
