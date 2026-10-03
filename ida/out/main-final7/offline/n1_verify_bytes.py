# -*- coding: utf-8 -*-
r"""Lane N1 - byte-check every image citation used in doc 128 (read-only). MAIN = file offset = address."""
import sys
from pathlib import Path as _Path
_REPO = _Path(__file__).resolve().parents[4]
import hashlib
R = str(_REPO) + "/"
sys.exit('The firmware image is not in this repository.')
assert hashlib.sha256(IMG).hexdigest().startswith("8e3ecd05409b2c31")
C = [
    (0x00932A, "0504020304040400", "M2 DATA-MISTYPED byte table (retyped to data)"),
    (0x03D1C6, "00400000", "M3 packed-BCD cell (retyped to 4-B data)"),
    (0x01687E, "6a0aad9c", "M6 core record 0x01686E+8 handler (now proven code)"),
    (0x018FAA, "6a188aac61c0", "M6/M5 sub_15260 handler, jsr'd 6x (proven code)"),
    (0x017924, "7a050001792e5a015260", "M6 companion record loader mov.l #0x01792E,er5 ; jmp sub_15260"),
    (0x07B4BA, "000784be", "M7 CDC handler record 0 +6: handler 0x0784BE (bus reset)"),
    (0x07B4E2, "000767be", "M7 CDC handler record EP1 bulk-OUT +6: handler 0x0767BE"),
    (0x066FB4, "790400086b84", "dropped leaf 0x066FB4 (now out of proven; stays named code)"),
    (0x018276, "7a0100018250", "kept L2 er1 callback source (reaches 0x018250)"),
    (0x05E862, "7a010005e8e0", "kept L4 er1 callback source (reaches 0x05E8E0)"),
]
bad = 0
for ea, hx, note in C:
    got = IMG[ea:ea + len(hx) // 2].hex()
    ok = got == hx
    bad += 0 if ok else 1
    print("%06X %-18s %s  %s" % (ea, hx, "OK " if ok else "MISMATCH got=%s" % got, note))
print("citations: %d, mismatches: %d" % (len(C), bad))
assert bad == 0
