# N13 raw byte scan of MAIN for every byte pattern that can address 0xFFFF4E (read-only).
import sys
from pathlib import Path
REPO = Path(__file__).resolve().parents[3].as_posix()  # repository root
import hashlib, sys
P = (REPO + "/decrypted/FT3D_MAIN_ver102_EXP.bin")
sys.exit('The firmware image is not in this repository.')
d = open(P, "rb").read()
assert hashlib.sha256(d).hexdigest() == "8e3ecd05409b2c314ebed77320ece5930bf31c8333cd84aeef4f6b0264c1bcce"
END = 0x80000
def finds(pat):
    i = d.find(pat, 0)
    while 0 <= i < END:
        yield i
        i = d.find(pat, i + 1)
rows = []
for name, pat in [("abs16 FF4E", b"\xff\x4e"), ("abs32 00FFFF4E", b"\x00\xff\xff\x4e"),
                  ("abs32 FFFFFF4E", b"\xff\xff\xff\x4e"), ("abs8 7E4E", b"\x7e\x4e"), ("abs8 7F4E", b"\x7f\x4e")]:
    for i in finds(pat):
        rows.append((i, name, d[max(0, i - 4):i + 8].hex(" ")))
for i in range(END - 1):
    if d[i + 1] == 0x4E and (d[i] >> 4) in (2, 3):
        rows.append((i, "abs8 mov %Xx 4E" % (d[i] >> 4), d[max(0, i - 4):i + 8].hex(" ")))
rows.sort()
for r in rows:
    print("%06X\t%s\t%s" % r)
print("total", len(rows), file=sys.stderr)
