# M4: byte-check every load-bearing citation in doc 116 against the MAIN image. Read-only.
from pathlib import Path
REPO = Path(__file__).resolve().parents[3].as_posix()  # repository root
import sys
sys.dont_write_bytecode = True
sys.path.insert(0, (REPO + "/ida/out/main-descent/offline"))
from common import IMG
def chk(a, hexs):
    b = bytes.fromhex(hexs); ok = IMG[a:a+len(b)] == b
    print(("OK  " if ok else "FAIL") + " %06X %s" % (a, hexs)); return ok
C = [
 (0x002234, "5e078106"),           # boot jsr @0x78106 (strap-match path)
 (0x002200, "2c4cec7fac7d4716"),   # mov @FFFF4C; and #7F; cmp #7D; beq
 (0x05DD12, "5e07815c"),           # DSP-WRITE gate -> polled service
 (0x05DD9E, "5e078222"),           # DSP-WRITE gate -> SCI reconfig
 (0x05C8D8, "580000da"),           # bra .+218 -> 05C9B6 (skips 05C8DC run)
 (0x062806, "40165e066fb440105e067250400a"),  # bra exit; dead arms jsr@66FB4 / jsr@67250
 (0x0628FC, "40045e066faa"),       # bra exit; dead arm jsr@66FAA
 (0x06723A, "5e066fb45800000c"),   # dead arm jsr@66FB4
 (0x06AB18, "5800003e5e066fb4"),   # bra->06AB5A; dead arm jsr@66FB4
 (0x06AB2A, "5e06726a"), (0x06AB36, "5e066fbe"),
 (0x06ADF2, "5800001e5e066fb4"), (0x06AE04, "5e06726a"), (0x06AE10, "5e066fbe"),
 (0x05CF22, "01006df66a0bb0b9"),   # dead B0B9 dispatcher head
 (0x05CF32, "78b06b260005d0285960"),  # mov.l @(0x5d028,er3); jmp @er6
 (0x06CCC0, "46267a060006ccee"),   # bne 0x6CCE8 (unreached predecessor)
 (0x06CCE8, "5e03ffa05470"),
 (0x070DA8, "401079230101"),       # bra->070DBA; dead selector 070DAA
 (0x074472, "00073afe0000207000073b6c"),  # off_74472[0..2] -> 073AFE/002070/073B6C
]
print("ALL OK" if all(chk(a, h) for a, h in C) else "SOME FAILED")
