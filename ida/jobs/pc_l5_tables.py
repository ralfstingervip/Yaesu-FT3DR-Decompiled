r"""PC_L5 (plain Python, no IDA): reproduce the key-code evidence tables from the
MAIN image. Read-only over decrypted\FT3D_MAIN_ver102_EXP.bin.

    python ida\jobs\pc_l5_tables.py
"""
import sys
import os, struct

ROOT = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
D = sys.exit("The firmware image is not in this repository.")
L = lambda a: struct.unpack(">I", D[a:a + 4])[0]
W = lambda a: struct.unpack(">H", D[a:a + 2])[0]

# 1. sub_100E4 decode: pairs "F9 kk AC pp 47 xx" = mov.b #kk,r1l ; cmp.b #pp,r4l ; beq
print("sub_100E4 port(&0x7F) -> raw key code")
a = 0x010108
while D[a] == 0xF9 and D[a + 2] == 0xAC:
    kk, pp = D[a + 1], D[a + 3]
    bit = [b for b in range(7) if not (pp >> b) & 1]
    print("  0x%02X  bit%s low -> raw 0x%02X  event %d" % (pp, bit, kk, kk - 9))
    a += 6

# 2. power-on hold table: values 0x010216, handlers 0x010242 (11 entries)
print("\npower-on hold table (0x010216 / 0x010242)")
for i in range(11):
    v = L(0x10216 + 4 * i)
    low = [b for b in range(7) if not (v >> b) & 1]
    print("  idx%-2d port 0x%02X bits-low %-10s handler 0x%06X" % (i, v, low, L(0x10242 + 4 * i)))

# 3. 17-column per-screen key tables (event = raw-9 for raw>=0x0A)
def row(t):
    return " ".join("%05X" % L(t + 4 * i) for i in range(17))
print("\nmain frequency screen tables 0x0115EC + mode*0x44 (cols = events 0..16)")
for m in range(4):
    print("  mode%d %s" % (m, row(0x115EC + 0x44 * m)))
print("\nscreen tables via word_1208C (+0x0125D4)")
for scr in (0xEC, 0xED, 0xEE):
    t = 0x125D4 + W(0x1208C + 2 * (scr - 1))
    print("  scr 0x%02X @0x%06X %s" % (scr, t, row(t)))

# 4. hard-coded 18-event key sequence checked by sub_3756
print("\nsub_3756 sequence @0x0037B6:", " ".join("%d" % b for b in D[0x37B6:0x37B6 + 18]))
