import sys
from pathlib import Path as _Path
_REPO = _Path(__file__).resolve().parents[3]
# M13 -- byte-check every address/bytes citation written in docs\deep\125-ledger-reverify-l.md. Read-only.
import os
R = str(_REPO) + "/"
sys.exit('The firmware image is not in this repository.')
def g(a, n):
    return (S[a - 0xFFC00000:a - 0xFFC00000 + n] if a >= 0xFFC00000 else M[a:a + n]).hex(" ")
C = [(0x035140, "00 0a 00 02 30 00 00 00 41 99 95 00 00 05 42 00 00 00 57 99 95 00 00 06"), (0x035144, "30 00 00 00"),
     (0x073E86, "5e 03 4a 52"), (0x073E8E, "5e 03 50 e4"), (0x073E88, "4a 52 fc 01"), (0x073E90, "50 e4 fc 00"),
     (0x0743BA, "fc 01 6a 8c b0 cc"), (0x0743BC, "6a 8c b0 cc 40 12"), (0x030240, "fc 05 6a 8c aa ce"), (0x031CD2, "fc 05 6a 8c aa ce"),
     (0x030242, "6a 8c aa ce fc ff"), (0x031BEE, "fc c8 6a 8c 95 89"), (0x031BF0, "6a 8c 95 89"), (0x03013C, "6a 8c 95 78"),
     (0x00FAFE, "6a 0c 89 bb 47 14"), (0x00FB04, "6a 10 89 20 73 00 46 0c"), (0x062962, "7a 05 00 06 21 78"), (0x062972, "7a 05 00 ff b3 2e"),
     (0x01D33E, "6e 0c 00 06 46 0e"), (0x01D340, "00 06 46 0e"), (0x053490, "00 06 45 a8"), (0x054D50, "01 10 6d f4 6a 0c 81 3a"),
     (0x054D54, "6a 0c 81 3a 58 60 01 4c"), (0x073A34, "78 b0 6b 26 00 07 44 72"),
     (0x03F5B2, "01 00 6d f2 6d 62 79 0a 00 00 6d 63 01 00 69 64"), (0xFFEDD539, "c9 0e 0f f6 95"), (0xFFEDD70C, "c9 0e 0f 76 96"),
     (0xFFEDC2A6, "ca 1e 17 80 c9 84"), (0xFFEDC292, "ca 1e 16 80 c8 84"), (0x015224, "5d 10"), (0x03C996, "58 60 fc ce"),
     (0x0460C0, "40 6e"), (0x01C27C, "40 1a"), (0x01D932, "40 12"), (0x07B4B4, "80 00 00 00 00 00 00 07 84 be"),
     (0x018276, "7a 01 00 01 82 50 5e 01 52 06"), (0x018AD2, "7a 01 00 01 8a be 5e 01 52 06"), (0x018BE8, "7a 01 00 01 a0 94 5e 01 52 06"),
     (0x05E862, "7a 01 00 05 e8 e0 5e 01 52 06"), (0x067246, "55"), (0x06AB36, "5e 06 6f be"), (0x06AE10, "5e 06 6f be"),
     (0x06AB2A, "5e 06 72 6a"), (0x06AE04, "5e 06 72 6a"), (0x0076DA, "5e 00 cf c2"), (0x01C28E, "5e 01 c4 d2"), (0x0460C8, "5e 04 62 10"),
     (0x04612A, "5e 04 5f 88"), (0xFFF392C3, "fb e2 a0 22 01 00 f8 e4 03"), (0xFFF3935D, "fb e2 a0 22 01 00 f8 e4 03"), (0xFFF3943C, "fb e2 a0 22 01 00 f8 e4 03")]
# FFEDD533-area base load: find the mov.l #12D44h,r14 just before each builder disp
C += [(0xFFEDD533, "fb e2 44 2d 01 00")]
bad = 0
with open(os.environ.get("OUTDIR", os.path.dirname(os.path.abspath(__file__))) + "/selfcheck.tsv", "w", encoding="utf-8", newline="\n") as f:
    f.write("address\tcited\timage\tverdict\n")
    for a, h in C:
        n = len(h.split()); im = g(a, n); ok = im == h; bad += not ok
        f.write("%X\t%s\t%s\t%s\n" % (a, h, im, "PASS" if ok else "FAIL"))
print("doc 125 citations:", len(C), "fail", bad)
