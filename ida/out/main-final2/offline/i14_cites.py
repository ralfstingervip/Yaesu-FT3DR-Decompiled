from pathlib import Path as _Path
_REPO = _Path(__file__).resolve().parents[4]
# Lane I14: byte-verify every cite in docs\deep\65-main-ledger-merge.md against the MAIN image. Read-only.
# Run:  python -B "ida/out/main-final2/offline/i14_cites.py"
import sys
sys.dont_write_bytecode = True
sys.path.insert(0, str(_REPO) + r"/ida/out/main-descent/offline")
from common import IMG, bu
C = [  # addr, hex bytes, oracle text prefix (or None)
    (0x00325E, "6a0ba9e0", "mov.b @0xa9e0:16,r3l"), (0x003262, "7a63000000ff", "and.l #0xff,er3"), (0x003268, "1073", "shll.l #2,er3"),
    (0x00326A, "01006f363272", "mov.l @(0x3272:16,er3),er6"), (0x003270, "5960", "jmp @er6"),
    (0x003272, "0000327e0000328a0000329c", None),
    (0x003282, "fc016a8ca9e0", "mov.b #0x1,r4l"), (0x003294, "fc026a8ca9e0", "mov.b #0x2,r4l"), (0x0032B8, "fc016a8ca9e0", "mov.b #0x1,r4l"),
    (0x034642, "78b06b2600034674", "mov.l @(0x34674:32,er3),er6"), (0x03464A, "5d60", "jsr @er6"), (0x03467C, "00034cce", None),
    (0x034CCE, "7e4d7330", "btst #0x3,@0x4d:8"), (0x034D40, "5470", "rts"),
    (0x034C9A, "6a2b00034cba", "mov.b @0x34cba:32,r3l"), (0x034CAC, "78306a2b00034cc4", "mov.b @(0x34cc4:32,er3),r3l"),
    (0x034CBA, "08204060 80a0c0e0 ff00 0812 1c26 303a 444e 5800".replace(" ", ""), None),
    (0x034CD4, "6a0caad3", "mov.b @0xaad3:16,r4l"), (0x034D02, "6a10aad17300", "btst #0x0,@0xaad1:16"),
    (0x01919A, "78606b2600019a9e", "mov.w @(0x19a9e:32,er6),r6"), (0x0191A2, "7a16000148a0", "add.l #0x148a0,er6"), (0x0191A8, "5d60", "jsr @er6"),
    (0x019250, "790100735a03ccbc", "mov.w #0x73,r1"), (0x019C3A, "7a0500019c44", "mov.l #0x19c44,er5"),
    (0x034C24, "5e000450", "jsr @0x450:24"), (0x000454, "7a0500000706", "mov.l #0x706,er5"), (0x00042C, "01006b85811a", "mov.l er5,@0x811a:16"),
    (0x0028D0, "01206df4", "stm.l er4-er6,@-sp"), (0x0028DA, "01006b06811a5960", "mov.l @0x811a:16,er6"),
    (0x00075C, "01006b85aac2", "mov.l er5,@0xaac2:16"), (0x000A8C, "0001010201020203", None),
    (0x0296DE, "7a01000296e85800", "mov.l #0x296e8,er1"), (0x029708, "7a0100029712", "mov.l #0x29712,er1"),
    (0x0296E8, "0002973200000000 0005e33e00029764 000000000002976c 0003ffa000029756".replace(" ", ""), None),
    (0x029712, "0002973200000000 0005e37c00029764 000000000002976c 0003ffa000029756".replace(" ", ""), None),
    (0x028D0C, "01006f1600005d60", "mov.l @(0x0:16,er1),er6"),
    (0x0178F0, "7a010001a084", "mov.l #0x1a084,er1"), (0x015224, "5d10", "jsr @er1"),
    (0x006942, "fb015e0085da5470", "mov.b #0x1,r3l"), (0x006904, "4841", None), (0x04CA62, "416c", "brn"),
    (0x00FFF8, "6a18a9ee70706a0ca9f1", "bset #0x7,@0xa9ee:16"), (0x061F16, "7a0400010000", "mov.l #0x10000,er4"),
    (0x04CACC, "40167a0100000014400e", "bra"), (0x0169FE, "5516", "bsr .+22 (0x16a16)"), (0x016A16, "6e2bad88", "mov.b @(0xad88:16,er2),r3l"),
    (0x001FDA, "6f4d18866f451888", "mov.w @(0x1886:16,er4),e5"), (0x044F3A, "4602fc1d5470", "bne .+2 (0x44f3e)"),
]
bad = 0
for a, hx, txt in C:
    got = IMG[a:a + len(hx) // 2].hex()
    ok = got == hx and (txt is None or bu(a)[1].startswith(txt))
    if not ok:
        bad += 1; print("MISMATCH %06X want %s got %s | %s" % (a, hx, got, bu(a)[1]))
print("checks ok: %d / %d" % (len(C) - bad, len(C)))
sys.exit(1 if bad else 0)
