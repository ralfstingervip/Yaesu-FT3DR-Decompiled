# extra scan: 3-byte big-endian values equal to a piece instruction head, at any offset, whose preceding byte is
# neither 0x00 (covered by the BE32 scan) nor 0x5E/0x5A (covered by the abs24 jsr/jmp scan). Also u16 == low half
# of a piece head below 0x10000 at even offsets inside data items (16-bit pointer tables).
from pathlib import Path as _Path
_REPO_S = _Path(__file__).resolve().parents[4].as_posix()
import sys
sys.path.insert(0, (_REPO_S + "/ida/out/dead-code-tier/offline"))
from m5_lib import *
PCH = {}
for a, b, _ in pieces:
    for i, ln, mn, op in lin(a, b): PCH[i] = a
n24 = []
for s in range(1, HI - 2):
    v = (img[s] << 16) | (img[s + 1] << 8) | img[s + 2]
    if v in PCH and img[s - 1] not in (0x00, 0x5E, 0x5A):
        h = headof[s]
        n24.append((s, v, cls(s), heads[h][1] if h is not None else "-", img[s - 1:s + 3].hex(" ")))
print("be24 hits (prefix not 00/5E/5A):", len(n24))
for x in n24: print("  %06X -> %06X cls %s item %s bytes %s" % x)
n16 = []
for s in range(0, HI - 1, 2):
    v = (img[s] << 8) | img[s + 1]
    h = headof[s]
    if v in PCH and h is not None and heads[h][1] != "code":
        n16.append((s, v, cls(s), heads[h][1], img[s:s + 2].hex(" ")))
print("u16 hits inside IDA data items:", len(n16))
for x in n16: print("  %06X -> %06X cls %s item %s bytes %s" % x)
