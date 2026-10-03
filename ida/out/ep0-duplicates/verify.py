r"""Lane N4 byte-verifier. Re-reads load-bearing byte runs straight from the
image and checks them. Read-only; opens no database, touches no radio.

Image: decrypted\FT3D_MAIN_ver102_EXP.bin (MAIN, H8SX, base 0, offset==address).
"""
import sys
from pathlib import Path as _Path
_REPO_S = _Path(__file__).resolve().parents[3].as_posix()
import hashlib, os

ROOT = _REPO_S
IMG = os.path.join(ROOT, "decrypted", "FT3D_MAIN_ver102_EXP.bin")
EXPECT_SHA = "8e3ecd05409b2c314ebed77320ece5930bf31c8333cd84aeef4f6b0264c1bcce"

sys.exit("The firmware image is not in this repository.")
sha = hashlib.sha256(b).hexdigest()

# (addr, expected hex bytes, note)
CITES = [
    (0x076ADC, "54 26", "rts/l er4-er6 -- return terminating the LIVE block, no fall-through into range"),
    (0x076ADE, "01 00 6D F2", "Handler A entry: push.l er2"),
    (0x076AF4, "47 16", "beq +0x16 -> 0x076B0C (internal, A)"),
    (0x076B0A, "54 02", "rts/l er2 (A exit)"),
    (0x076B1A, "5E 07 83 7C", "jsr sub_7837C (outbound)"),
    (0x076B1E, "54 02", "rts/l er2 (A exit)"),
    (0x076B20, "6D F2", "Handler B entry: push.w r2"),
    (0x076B2A, "47 22", "beq +0x22 -> 0x076B4E (internal, B)"),
    (0x076B46, "5E 07 83 34", "jsr sub_78334 (outbound)"),
    (0x076B4C, "54 70", "rts (B exit)"),
    (0x076B4E, "7A 00 01 00 00 00", "0x076B4E block head (mov.l #0x1000000,er0)"),
    (0x076B5A, "58 70 00 9C", "beq.w -> 0x076BFA (internal)"),
    (0x076B70, "58 70 00 7E", "beq.w -> 0x076BF2 (internal)"),
    (0x076BE8, "47 1C", "beq +0x1C -> 0x076C06 (internal)"),
    (0x076C06, "6D 72", "pop.w r2 (B epilogue)"),
    (0x076C08, "54 70", "rts (B exit, range end 0x076C0A)"),
    (0x076C0A, "01 20 6D F4", "sub_76C0A: stm.l er4-er6 -- LIVE request parser starts here"),
    # handler-record table 0x07B4B4, stride 10, +6 = BE32 handler pointer (doc 119)
    (0x07B4BA, "00 07 84 BE", "record0 handler -> 0x0784BE (not in range)"),
    (0x07B4C4, "00 07 69 AA", "record1 handler -> 0x0769AA (not in range)"),
    (0x07B4CE, "00 07 68 C8", "record2 handler -> 0x0768C8 (not in range)"),
    (0x07B4D8, "00 07 69 AA", "record3 handler -> 0x0769AA (not in range)"),
    (0x07B4E2, "00 07 67 BE", "record4 handler -> 0x0767BE (not in range)"),
    (0x07B4EC, "00 07 68 A8", "record5 handler -> 0x0768A8 (not in range)"),
]

ok = bad = 0
print("image sha256:", sha, "MATCH" if sha == EXPECT_SHA else "*** MISMATCH ***")
for addr, hexs, note in CITES:
    want = bytes(int(x, 16) for x in hexs.split())
    got = b[addr:addr + len(want)]
    good = got == want
    ok += good; bad += (not good)
    print("%s %06X  %-24s  %s" % ("OK " if good else "BAD", addr, hexs, note))
    if not good:
        print("      got:", " ".join("%02X" % x for x in got))

# verify no handler-record +6 pointer targets the range [0x076ADE,0x076C0A)
LO, HI = 0x076ADE, 0x076C0A
bad_ptr = []
ea = 0x07B4B4
while True:
    code = b[ea + 4]
    if code == 0xFF:  # end marker
        break
    ptr = int.from_bytes(b[ea + 6:ea + 10], "big")
    if LO <= ptr < HI:
        bad_ptr.append((ea, ptr))
    ea += 10
print("handler-record pointers into range:", bad_ptr if bad_ptr else "NONE (confirmed)")
print("RESULT: %d OK, %d BAD" % (ok, bad))
