import sys
# Lane M1: byte-check every byte citation in docs/deep/113-main-final6-seed.md against the MAIN image. Read-only.
import hashlib
sys.exit('The firmware image is not in this repository.')
assert hashlib.sha256(IMG).hexdigest().startswith("8e3ecd05409b2c31")
C = [  # (address, hex bytes as cited)
    (0x018276, "7a01000182 50"), (0x01827C, "5e015206"), (0x015224, "5d10"), (0x05E862, "7a010005e8e05e015206"),
    (0x06AB36, "5e066fbe"), (0x06AE10, "5e066fbe"), (0x06AB2A, "5e06726a"), (0x06AE04, "5e06726a"),
    (0x006A08, "6e5c006d"), (0x006A0C, "6a108ea07340"), (0x006A06, "4012"), (0x0069EE, "4614"),
    (0x0077CC, "4036"), (0x0077F6, "6704"), (0x0077F8, "6a10817e7700"), (0x00738E, "5e0077cc"), (0x007484, "5e0077cc"),
    (0x06B4F6, "5e067522"), (0x06B536, "5e067522"), (0x067522, "5470"), (0x067520, "5470"),
    (0x06B530, "5960"), (0x06B532, "f200"), (0x01E1BE, "1073"), (0x01E1C0, "78b06b260001e1de"),
    (0x016AD6, "6e0c0051"), (0x050734, "4b08"),
    (0x03521A, "5e035432"), (0x065B1A, "5e065a8c"), (0x07380C, "5e07390a"), (0x074576, "5e07390a"), (0x073A3C, "5d60"),
    (0x056D1C, "55ac"), (0x009364, "5e0486d2"), (0x02CBAC, "0002d708"), (0x033984, "00034012"),
    (0x0151E6, "b7d2d3d7d600"), (0x03531E, "0500000013700000222000004200 0000"), (0x074310, "000041483036304d"),
    (0x065A88, "33313200"), (0x05C600, "ffff"), (0x03799E, "8000143300001438"),
    (0x03605A, "070707070739"), (0x04C336, "ff54"), (0x04E298, "6eff000e"), (0x06C59E, "300401"),
    (0x020CCA, "00020d5000020d5e"), (0x006528, "00ff8180"),
]
bad = 0
for a, h in C:
    want = bytes.fromhex(h.replace(" ", ""))
    ok = IMG[a:a + len(want)] == want
    bad += not ok
    print("%06X %-36s %s" % (a, want.hex(" "), "ok" if ok else "MISMATCH " + IMG[a:a + len(want)].hex(" ")))
print("citations %d, mismatches %d" % (len(C), bad))
