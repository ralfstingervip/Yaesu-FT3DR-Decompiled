# Lane I4: byte-verify key cites from decrypted MAIN image (read-only). Writes verify.tsv.
import sys
from pathlib import Path as _Path
_REPO_S = _Path(__file__).resolve().parents[3].as_posix()
import struct, re, os
IMG = (_REPO_S + "/decrypted/FT3D_MAIN_ver102_EXP.bin")
OUT = os.path.join(os.path.dirname(os.path.abspath(__file__)), "verify.tsv")
sys.exit("The firmware image is not in this repository.")
C = [  # addr, expected hex, meaning
 (0x056B58, "6a0bb102", "mov.b @B102,r3l (state index)"),
 (0x056B5C, "7a63000000ff", "and.l #0xFF,er3 (only bound: zero-extend)"),
 (0x056B62, "1073", "shll.l #2,er3"),
 (0x056B64, "78b06b2600056b8a5960", "mov.l @(0x56B8A,er3),er6 ; jmp @er6"),
 (0x056B1A, "78406a2c00056b6e", "flag table 0x56B6E[B102]"),
 (0x056B6E, "00010100010101010100010101010100010101000101010100010101", "28 A6-resync flags"),
 (0x056A94, "01006b02b0e0", "mov.l @rx[0..3],er2"),
 (0x056A9C, "e9c0ea03", "r1l=rx[1]&0xC0 (FI), r2l=rx[3]&3 (DT)"),
 (0x056F06, "6a0cb0e1ec30114c114cac02", "(rx[1]&0x30)>>4 must == 2"),
 (0x056F14, "6a8cb110", "sole writer of B110 (value 2)"),
 (0x056FDE, "6a0cb0e4ec7fac7f", "DG-ID: rx[4]&0x7F vs 0x7F"),
 (0x056FFE, "0d4b5e056cbe", "dead DP-ID check (no xref)"),
 (0x057130, "7a0500ffb0e17a0600fef920", "A6 copy src rx+1 dst FEF920 (26 B)"),
 (0x057312, "7a0500ffb0e77a0600fef93a", "A7 copy rx+7 -> FEF93A (20 B)"),
 (0x0577C0, "7a0500ffb0e77a0600fef94e", "A8 copy rx+7 -> FEF94E (20 B)"),
 (0x0586C0, "fc14", "A9 V/D1: 20 B per frame"),
 (0x058C4E, "fc0a", "AA V/D2: 10 B per frame"),
 (0x0586A2, "eb0fab06", "V/D1 frame count nibble < 6"),
 (0x0588CC, "eb0fab0e", "Data FR frame count nibble < 0x0E"),
 (0x058C30, "eb0fab03", "V/D2 frame count nibble < 3"),
 (0x05892E, "6a0cb0e8ac4e", "Data FR first frame: rx[8]=='N'"),
 (0x058962, "79040400", "'Nb' default length 0x400"),
 (0x058E80, "7a0500059b44", "group dest compare ROM 0x59B44"),
 (0x059B44, "2a2a2a2a2a2a2a2a2a2a", "'**********' ALL"),
 (0x058EA0, "7a0500ffa8da", "individual dest compare own callsign FFA8DA"),
 (0x058E66, "0022615f300308", "canned voice-end message"),
 (0x05803E, "6ba400ff07a4", "'N' class store length FF07A4"),
 (0x0581B0, "6ba400ff0bf4", "']' class store length FF0BF4"),
 (0x058516, "6ba400ff1440", "'G' class store length FF1440"),
 (0x05EAAC, "7a0600fefd72", "host-link copy dst FEFD72"),
 (0x055E06, "790401187a0500ff98007a0600ff1489", "0x55DFC copies 0x118 B FF9800->FF1489"),
 (0x05A856, "acab476c", "trace: AB -> TERM RX"),
 (0x05A874, "acbb474e", "trace: BB -> TERM RX"),
 (0x056C46, "790400107a0500ffb0ec7a0600ff4706", "DP-ID capture rx+12 16 B -> FF4706"),
 (0x0569BE, "aca658500086acac58500084acb6457cacbc457c", "no-ACK for A6-AB / B6-BB"),
]
rows = ["addr\tlen\tbytes_in_image\texpected\tok\tmeaning"]
bad = 0
for a, h, m in C:
    if not h: continue
    b = bytes.fromhex(h); got = d[a:a+len(b)]
    ok = got == b; bad += (not ok)
    rows.append("%06x\t%d\t%s\t%s\t%s\t%s" % (a, len(b), got.hex(" "), b.hex(" "), "yes" if ok else "NO", m))
# strings
for a, s in [(0x05AF34, b"DSP>CPU: DATA TEXT SET"), (0x05AF4C, b"DSP>CPU: TERM TX"), (0x05AF5E, b"DSP>CPU: TERM RX")]:
    ok = d[a:a+len(s)] == s; bad += (not ok)
    rows.append("%06x\t%d\t%s\t%s\t%s\tstring" % (a, len(s), d[a:a+len(s)].hex(" "), s.decode(), "yes" if ok else "NO"))
# jump table
for i in range(28):
    a = 0x056B8A + 4*i; v = struct.unpack(">I", d[a:a+4])[0]
    rows.append("%06x\t4\t%s\tstate %d -> %06x\tyes\tjump table slot" % (a, d[a:a+4].hex(" "), i, v))
# B102 writers: every 6a 8c b1 02 must be preceded by fc XX (mov.b #XX,r4l)
vals = {}
for m in re.finditer(re.escape(bytes.fromhex("6a8cb102")), d[:0x80000]):
    p = m.start(); pre = d[p-2:p]
    if pre[0] == 0xFC: vals.setdefault(pre[1], []).append(p)
    else:
        # look back up to 12 bytes for fc XX with r4l untouched (power-off / reset paths)
        k = d.rfind(b"\xfc", p-12, p); vals.setdefault(("back", d[k+1] if k >= 0 else None), []).append(p)
n = sum(len(v) for v in vals.values())
rows.append("-\t-\t-\tB102 writers=%d\t-\t%s" % (n, "; ".join("%s:%d" % (k if not isinstance(k, int) else "0x%02x" % k, len(v)) for k, v in sorted(vals.items(), key=str))))
open(OUT, "w", encoding="utf-8", newline="\n").write("\n".join(rows) + "\n")
print("checks", len(rows)-1, "bad", bad, "B102 writers", n, sorted((str(k), len(v)) for k, v in vals.items()))
