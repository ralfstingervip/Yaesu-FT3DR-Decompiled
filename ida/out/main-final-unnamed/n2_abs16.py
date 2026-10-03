from pathlib import Path as _Path
_REPO = _Path(__file__).resolve().parents[3]
# Lane N2: raw abs16 / d:16 / #imm16 operand scan for the four runs below 0x8000.
# An H8SX instruction is word-aligned, so a 16-bit operand sits at an even offset s.
# Opcode forms checked at s-2: 6A/6B (mov.b/w @aa:16 and bit ops), 6E/6F (@(d:16,ERn)),
# 7A 08..0F (mov.l #imm16,ERd), 79 0r (mov.w #imm16), and any 4-byte prefix 01/7x before 6B/6F.
import sys; sys.path.insert(0, str(_REPO) + r"/ida/out/main-final-unnamed")
from n2_lib import *
load_heads()
LOWRUNS = [(a, b) for a, b in runs() if a < 0x8000]
out = open(os.path.join(O, "work", "abs16.txt"), "w", encoding="utf-8", newline="\n")
for a, b in LOWRUNS:
    out.write("=== %06X-%06X\n" % (a, b - 1))
    for s in range(2, E - 1, 2):
        v = be16(s)
        if not (a - 0x100 <= v < b): continue
        o1, o2 = img[s - 2], img[s - 1]
        form = None
        if o1 in (0x6A, 0x6B) and (o2 >> 4) in (0x0, 0x1, 0x8, 0x3, 0x9, 0xC, 0x4, 0xA): form = "@aa:16"
        elif o1 in (0x6E, 0x6F): form = "@(d:16,ERn)"
        elif o1 == 0x7A and 0x08 <= o2 <= 0x0F: form = "mov.l #imm16"
        elif o1 == 0x79 and (o2 >> 4) == 0: form = "mov.w #imm16"
        elif o1 == 0x79 and (o2 >> 4) in (1, 2, 3): form = "add/cmp/sub.w #imm16"
        if form:
            out.write("   %06X %s v=%04X %s P=%d N=%d  %s\n" % (s - 2, form, v, "IN" if v >= a else "  ", PM[s - 2], NM[s - 2], hx(s - 4, 8)))
out.close(); print("ok")
