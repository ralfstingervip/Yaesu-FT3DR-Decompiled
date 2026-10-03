# M2: byte-check every citation used in the doc against the image. Read-only.
from pathlib import Path
REPO = Path(__file__).resolve().parents[4].as_posix()  # repository root
import sys
sys.path.insert(0, (REPO + "/ida/out/main-descent/offline"))
from common import IMG
def chk(off, hexs, label):
    b = bytes.fromhex(hexs)
    got = IMG[off:off+len(b)]
    ok = got == b
    print(("OK " if ok else "FAIL ") + "%06X %-28s exp=%s got=%s" % (off, label, hexs, got.hex()))
    return ok
import hashlib
print("sha256 MAIN", hashlib.sha256(IMG).hexdigest()[:16])
# DATA-MISTYPED 00932A: run bytes + the reached reader at 00929E
chk(0x00932A, "0504020304040400", "run 00932A byte-table")
chk(0x009298, "7a64000000ff", "009298 and.l #0xff,er4 (index mask)")
chk(0x00929E, "78406a2b0000932c", "00929E mov.b @(0x932c:32,er4),r3l")
# companion 0076D8 stub after rts, jsr 0x00CFC2
chk(0x0076D6, "5470", "rts at 0076D6 (pred)")
chk(0x0076D8, "8b0b5e00cfc25470", "run 0076D8 stub jsr 0xCFC2")
# companion 01C27E dead arm after bra, jsr 0x01C4D2
chk(0x01C27C, "401a", "bra .+26 at 01C27C (pred)")
chk(0x01C27E, "6a108ea0736047006a108ea8731046065e01c4d24004", "run 01C27E (jsr 0x1C4D2)")
# a '5e03ffa0' else-landing dead arm + its bra pred
chk(0x0167E8, "4004", "bra .+4 at 0167E8 (pred)")
chk(0x0167EA, "5e03ffa0", "run 0167EA jsr 0x03FFA0")
# the first run and its bra pred
chk(0x0049D2, "4062", "bra .+98 at 0049D2 (pred)")
chk(0x0049D4, "6e0c0087730c4714", "run 0049D4 head")
# er1-callback-style dead arm 019EA0
chk(0x019E9E, "400e", "bra .+14 at 019E9E (pred)")
chk(0x019EA0, "7a0100ffad8a7a060001a1bc4000", "run 019EA0 (mov.l #FFAD8A,er1;#1A1BC,er6)")
