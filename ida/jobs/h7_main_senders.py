r"""Lane H7 - plain Python, read-only. For every F3Ax/F3Bx/F3Cx/F3Dx code, find the MAIN
mov.w #F3xx load (79 0B/79 04 F3 xx), take the enclosing stub (back to the previous
rts 54 70, or the 0x782C stub start from G3's f3xx-codes.tsv), and list the RAM bytes,
record-field displacements and jsr targets it uses (H8S abs16 forms 6A 0r/6A 1r/6A 8r/
6B 0r aaaa, abs32 6A 2r/6B 2r 00 FF aaaa, @(d16,ERn) 6E/6F, jsr 5E). Joins RAM bytes to
ida\out\settings\settings-bytes.tsv. Output: ida\out\value-tables\h7_main_senders.tsv."""
import sys
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root
import re, os
ROOT = str(_REPO)
M = sys.exit("The firmware image is not in this repository.")
SET = {}
for ln in open(os.path.join(ROOT, r"ida\out\settings\settings-bytes.tsv"), encoding="utf-8"):
    p = ln.rstrip("\n").split("\t")
    if p[0].startswith("R"):
        SET[int(p[2], 16)] = "%s n=%s EEPROM %s BACKUP %s%s" % (p[0], p[1], p[3], p[4], (" " + p[8]) if len(p) > 8 and p[8] else "")
G3 = {}
for ln in open(os.path.join(ROOT, r"ida\out\sub-labels\f3xx-codes.tsv"), encoding="utf-8"):
    p = ln.split("\t")
    if len(p) > 4 and re.match(r"F3[A-D][0-9A-F]$", p[0]):
        G3.setdefault(int(p[0], 16), []).append((int(p[4], 16), p[3]))

def scan(a0, a1):
    ram, disp, jsr = [], [], []
    i = a0
    while i < a1:
        b0, b1 = M[i], M[i + 1]
        if b0 == 0x6A and (b1 & 0xF0) in (0x00, 0x10, 0x80):
            ad = 0xFF0000 | (M[i + 2] << 8) | M[i + 3]
            kind = {0x00: "rd", 0x10: "bit", 0x80: "wr"}[b1 & 0xF0]
            extra = ""
            if kind == "bit":
                op = M[i + 4]; bit = (M[i + 5] >> 4) & 7
                extra = {0x77: "bld", 0x73: "btst", 0x70: "bset", 0x72: "bclr", 0x67: "bst", 0x71: "bnot"}.get(op, "%02X" % op) + " #%d" % bit
                i += 6
            else:
                i += 4
            ram.append("%s@%06X%s" % (kind, ad, (" " + extra) if extra else ""))
            continue
        if b0 == 0x6B and (b1 & 0xF0) in (0x00, 0x80):
            ram.append("%sw@%06X" % ("rd" if b1 < 0x80 else "wr", 0xFF0000 | (M[i + 2] << 8) | M[i + 3])); i += 4; continue
        if b0 in (0x6A, 0x6B) and (b1 & 0xF0) in (0x20, 0xA0) and M[i + 2] == 0 and M[i + 3] == 0xFF:
            ram.append("%s%s@FF%02X%02X" % ("rd" if b1 < 0x80 else "wr", "w" if b0 == 0x6B else "", M[i + 4], M[i + 5])); i += 6; continue
        if b0 in (0x6E, 0x6F) and M[i + 2] == 0:
            disp.append("%s @(0x%02X,er%d)" % ("rd" if b1 < 0x80 else "wr", M[i + 3], (b1 >> 4) & 7)); i += 4; continue
        if b0 == 0x5E:
            jsr.append("%06X" % ((M[i + 1] << 16) | (M[i + 2] << 8) | M[i + 3])); i += 4; continue
        if b0 == 0x54 and b1 == 0x70:
            break
        i += 2
    return ram, disp, jsr

rows = ["code\tsite\tstub_start\tmain_row_code\tstub_bytes\tram_refs\trecord_disp\tjsr\tsettings_link"]
for c in list(range(0xA0, 0xBF)) + list(range(0xC0, 0xC5)) + list(range(0xD0, 0xD7)):
    for m in re.finditer(bytes([0xF3, c]), M):
        p = m.start() - 2
        if M[p] != 0x79 or M[p + 1] & 0xF0:
            continue
        st = None; rc = "-"
        for s0, r in G3.get(0xF300 | c, []):
            if s0 <= p < s0 + 0x60:
                st, rc = s0, r
        if st is None:
            q = p
            while q > p - 0x80 and not (M[q] == 0x54 and M[q + 1] == 0x70):
                q -= 2
            st = q + 2 if q > p - 0x80 else p - 0x20
        end = p + 4
        while end < p + 0x40 and not (M[end] == 0x54 and M[end + 1] == 0x70):
            end += 2
        ram, disp, jsr = scan(st, end)
        link = "; ".join("%s -> %s" % (r, SET[int(r.split("@")[1][:6], 16)]) for r in ram if int(r.split("@")[1][:6], 16) in SET)
        rows.append("\t".join(["F3%02X" % c, "%05X" % p, "%05X" % st, rc, M[st:end + 2].hex(" "), " ".join(ram) or "-",
                               " ".join(disp) or "-", " ".join(jsr) or "-", link or "-"]))
open(os.path.join(ROOT, r"ida\out\value-tables\h7_main_senders.tsv"), "w", encoding="utf-8", newline="\n").write("\n".join(rows) + "\n")
print(len(rows) - 1)
