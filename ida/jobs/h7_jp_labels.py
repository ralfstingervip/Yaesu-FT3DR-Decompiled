r"""Lane H7 - plain Python (NOT an IDA script). Read-only over decrypted SUB image
and the H7 linear listing ida\out\value-tables\h7_jp.txt (lin FFF097AF x1500,
produced by h7_dump.py on private DB H7_SUB).

Decodes the Japanese-language setup-label path of walker sub_FFF0964A
(taken when byte [0x8F72] != 1, branch FFF0968F bne -> FFF096C0): one handler per
menu group, each a jump table or compare chain on the row, each row drawing a
literal through sub_FFEFA7E7 (16-byte string + 16-bit double-byte mask in r3),
sub_FFEF1B23 (ASCII, explicit length) or sub_FFEF190D (one JIS X 0208 glyph).
Writes ida\out\value-tables\jp-labels.tsv.
"""
import sys
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root
import os, re, struct
ROOT = str(_REPO)
S = sys.exit("The firmware image is not in this repository.")
SB = 0xFFC00000
OUT = os.path.join(ROOT, r"ida\out\value-tables")
def b(a, n=1): return S[a - SB:a - SB + n]
def s16(a): return struct.unpack("<h", b(a, 2))[0]
def u32(a): return struct.unpack("<I", b(a, 4))[0]

# group -> JP handler (walker compare chain FFF096C0..FFF097AB, Confirmed)
HANDLERS = {1: 0xFFF097AF, 2: 0xFFF098CC, 3: 0xFFF09C73, 4: 0xFFF09E12, 5: 0xFFF0A108,
            6: 0xFFF0A22A, 7: 0xFFF0A262, 8: 0xFFF0A309, 9: 0xFFF0A4DE, 0xA: 0xFFF0A711,
            0xB: 0xFFF0A7B9, 0xC: 0xFFF0A84B, 0x15: 0xFFF09944, 0x16: 0xFFF09A75, 0x17: 0xFFF09B88}

ins = []
for ln in open(os.path.join(OUT, "h7_jp.txt"), encoding="utf-8"):
    if ln.startswith("######") and ins:
        break
    m = re.match(r"([0-9A-F]{8})  ([0-9a-f ]+?)\s{2,}(.*?)\s*; (.*)$", ln.rstrip("\n"))
    if m:
        ins.append((int(m.group(1), 16), m.group(2), re.sub(r"\s+", " ", m.group(3)), m.group(4)))
idx = {a: i for i, (a, _, _, _) in enumerate(ins)}

def imm(t):
    m = re.search(r"#0x([0-9A-F]+) R(\d+)", t[3])
    return (int(m.group(1), 16), int(m.group(2))) if m else None

def target(t):
    m = re.search(r"a=0x([0-9A-F]+)", t[3])
    return int(m.group(1), 16) if m else None

# Single-byte repertoire of font record 13 (7x14, base 0x20, ordinal table FFEC558A, pixels
# FFC38C54), selected by sub_FFEF1B23 r3=0x0D.  0x20-0x7E ASCII; 0xA1-0xDF JIS X 0201 half-width
# katakana; 0xE0-0xF9 precomposed voiced/semi-voiced katakana (identified by rendering each glyph,
# h7 glyph check); 0xFA-0xFF blank/unused.  Rendered here as full-width katakana; '-' after kana = long vowel.
import unicodedata
VOICED = "ヴガギグゲゴザジズゼゾダヂヅデドバビブベボパピプペポ"
def sb(c):
    if 0xA1 <= c <= 0xDF:
        return unicodedata.normalize("NFKC", bytes([c]).decode("cp932"))
    if 0xE0 <= c <= 0xF9:
        return VOICED[c - 0xE0]
    if c == 0xFF:
        return " "
    if 0x20 <= c < 0x7F:
        return chr(c)
    return "<%02X>" % c
def kana_fix(t):
    return re.sub(r"(?<=[゠-ヿ])-", "ー", t)

def jis_decode(raw, mask):
    """Model of sub_FFEFA7E7 loop FFEFA82D..FFEFA91F: i=0..15, stop at NUL; bit (15-i) of
    mask set -> big-endian JIS X 0208 code raw[i]<<8|raw[i+1] (0xFFFF -> 0x2121), i+=2."""
    out, codes, i = "", [], 0
    while i <= 15 and i < len(raw) and raw[i] != 0:
        bit = (mask >> (15 - i)) & 1
        if bit and i == 15:
            break
        if bit:
            c = (raw[i] << 8) | raw[i + 1]
            if c == 0xFFFF:
                c = 0x2121
            codes.append("%04X" % c)
            try:
                out += bytes([(c >> 8) | 0x80, (c & 0xFF) | 0x80]).decode("euc_jp")
            except Exception:
                out += "<%04X>" % c
            i += 2
        else:
            out += sb(raw[i])
            i += 1
    return out, codes

def block(start):
    """Walk from a row target to its rtsd, collecting draw calls in order."""
    i = idx[start]
    parts, regs, last_len, last_ptr = [], {}, None, None
    while i < len(ins):
        a, raw, dis, ops = ins[i]
        v = imm(ins[i])
        if v and dis.startswith("mov.l"):
            regs[v[1]] = v[0]
        if dis.startswith("mov.b") and "0Ch+var_C" in dis and v is None:
            m = re.search(r"#0x([0-9A-F]+)", ops)
            if m: last_len = int(m.group(1), 16)
        if dis.startswith("mov.l") and v and v[1] == 3 and v[0] >= 0xFFC00000:
            last_ptr = v[0]
        if "bsr" in dis:
            t = target(ins[i])
            if t == 0xFFEFA7E7:
                p, mask = regs.get(4), regs.get(3, 0)
                txt, codes = jis_decode(b(p, 17), mask)
                parts.append(("FFEFA7E7", p, mask, txt, codes))
            elif t == 0xFFEF1B23:
                p = last_ptr
                n = last_len or 0
                raw = b(p, n).split(bytes(1))[0]          # sub_FFEF1B23 stops at NUL (FFEF1B4F)
                txt = "".join(sb(c) for c in raw)
                parts.append(("FFEF1B23", p, None, txt, []))
            elif t == 0xFFEF190D:
                c = regs.get(4)
                txt = bytes([(c >> 8) | 0x80, (c & 0xFF) | 0x80]).decode("euc_jp")
                parts.append(("FFEF190D", None, c, txt, ["%04X" % c]))
        if dis.startswith("rtsd") or dis.startswith("rts"):
            break
        i += 1
    return parts

def rows_of(h):
    """Return {row: target} for handler h (jump table or compare chain)."""
    i = idx[h]
    seq = ins[i:i + 80]
    for k, t in enumerate(seq):                 # handler's dispatch ends at its first return
        if t[2].startswith("rts"):
            seq = seq[:k + 1]
            break
    rows = {}
    for k, t in enumerate(seq):
        if "mov.w [r1, r14], r14" in t[2] and "bra.l" in seq[k + 1][2]:
            tab = imm(seq[k - 1])[0]
            bra = seq[k + 1][0]
            n = None
            for q in range(k - 1, -1, -1):
                if seq[q][2].startswith("cmp"):
                    n = imm(seq[q])[0] + 1
                    break
            for r in range(n):
                rows[r] = (bra + s16(tab + 2 * r)) & 0xFFFFFFFF
            return rows, "jump table %08X (bra.l %08X, %d entries)" % (tab, bra, n)
    # compare chain
    for k, t in enumerate(seq):
        if t[2].startswith("cmp") and imm(t):
            val = imm(t)[0]
            nx = seq[k + 1]
            if nx[2].startswith("beq"):
                rows[val] = target(nx)
            elif nx[2].startswith("bne"):
                rows[val] = seq[k + 2][0]
                break
        if t[2].startswith("rtsd") and k > 3:
            break
    return rows, "compare chain"

S_MENU = 0xFFED74E8
def en_label(g, r):
    cnt = b(S_MENU + 8 * g)[0]
    p = u32(S_MENU + 8 * g + 4)
    if p == 0 or r >= cnt:
        return "", ""
    a = p + 20 * r
    return "%08X" % a, b(a, 20).split(b"\0")[0].decode("latin-1")

lines = ["# Lane H7. JP (Japanese-language) setup labels: walker sub_FFF0964A, [0x8F72]!=1 -> FFF096C0 per-group handler.",
         "# Encoding: 7-bit JIS X 0208 double-byte codes mixed with ASCII; r3 mask bit (15-i) marks byte i as the high byte of a JIS code (sub_FFEFA7E7 FFEFA839..FFEFA887); glyph via sub_FFEF190D -> sub_FFEF2184 -> font block 0x2121/0x5021 @FFED4644.",
         "# kind: FFEFA7E7=masked string, FFEF1B23=ASCII with length, FFEF190D=single JIS glyph. status C = handler/row/bytes read; unicode via EUC-JP (code|0x8080).",
         "group\trow\thandler\tdispatch\trow_target\tEN_label_addr\tEN_label\tJP_draws\tJP_text\tjis_codes\tstatus"]
total = 0; jis_rows = 0
for g, h in sorted(HANDLERS.items()):
    rows, how = rows_of(h)
    for r in sorted(rows):
        t = rows[r]
        parts = block(t)
        if not parts:
            continue
        ea, et = en_label(g, r)
        draws = "; ".join("%s(%s%s)" % (k, ("%08X" % p) if p else "", (" mask=%04X" % m) if (k == "FFEFA7E7") else ((" code=%04X" % m) if k == "FFEF190D" else "")) for k, p, m, _, _ in parts)
        text = kana_fix("".join(x[3] for x in parts).rstrip())
        codes = " ".join(c for x in parts for c in x[4])
        total += 1
        jis_rows += 1 if codes else 0
        lines.append("\t".join(["0x%02X" % g, str(r), "%08X" % h, how, "%08X" % t, ea, et, draws, text, codes or "-", "C"]))
lines.insert(3, "# rows decoded: %d (with at least one JIS glyph: %d)" % (total, jis_rows))
with open(os.path.join(OUT, "jp-labels.tsv"), "w", encoding="utf-8", newline="\n") as fh:
    fh.write("\n".join(lines) + "\n")
print("rows", total, "jis", jis_rows)
