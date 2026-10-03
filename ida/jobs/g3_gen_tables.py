r"""Lane G3 - plain Python (NOT an IDA script). Read-only over the decrypted images.

Builds ida\out\sub-labels\f3xx-codes.tsv and mode-step.tsv from:
  MAIN  row-code -> sender-stub table @0x782C (index = row code, dispatched by
        `mov.l @(0x782C,er3),er6 ; jsr @er6` at 0x4814/0x6C66/... after
        `mov.b @(1,er0),r3l ; and.l #0xFF ; shll.l #2`), the F-code each stub
        loads (`79 0B Fx xx` mov.w #Fxxx,e3 / `79 04 Fx xx` mov.w #Fxxx,r4) up to
        its first rts, and the menu row-code lists @0x1515C (doc 32).
  SUB   python models of sub_FFF092FC (code -> menu group) and sub_FFF09396
        (code -> row index), transcribed instruction-by-instruction from
        ida\out\sub-labels\code2label.lst; menu table @0xFFED74E8 (8-byte
        entries {u8 count, pad[3], u32 labels}, 20-byte label stride); value-
        draw jump tables @0xFFF481F0 / 0xFFF4820A / 0xFFF48232.

    python "ida/jobs/g3_gen_tables.py"
"""
import sys
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root
import os
import struct

ROOT = str(_REPO)
OUT = os.path.join(ROOT, r"ida\out\sub-labels")
M = sys.exit("The firmware image is not in this repository.")
S = sys.exit("The firmware image is not in this repository.")
SB = 0xFFC00000


def s8(a, n=1):
    return S[a - SB:a - SB + n]


def cstr(a, n=32):
    return s8(a, n).split(b"\0")[0].decode("latin-1")


# ---------------- SUB models -------------------------------------------------
def sub_grp(code):                       # sub_FFF092FC
    hi = code >> 4
    if hi == 0xE:
        return 0xC
    if hi in (8, 9):
        return 8
    if hi in (0xA, 0xB):
        return 9
    if hi == 0xC:
        return 0xA
    if hi == 0xD:
        return 0xB
    if hi == 2:
        if code <= 0x22:
            return 0x15
        if code <= 0x25:
            return 0x16
        if code <= 0x28:
            return 0x17
        if code <= 0x2A:
            return 0x16
        return 0x17
    return hi


def sub_idx(code):                       # sub_FFF09396 (default 0 @FFF093B0)
    hi, lo = code >> 4, code & 0xF
    if hi == 1:
        if lo <= 5:
            return (lo - 1) & 0xFF
        if lo <= 9:
            return lo - 2
        if lo <= 0xB:
            return lo - 3
        return 0
    if hi == 2:
        if lo in (0, 4, 6):
            return 0
        if lo in (1, 5, 7):
            return 1
        if lo in (2, 8, 9):
            return 2
        if lo in (0xA, 0xB):
            return 3
        if lo == 0xC:
            return 4
        return 0
    if hi in (3, 4, 5, 0xA):
        return lo
    if hi == 6:
        return 1 if lo == 3 else 0
    if hi == 7:
        if lo <= 4:
            return (lo - 1) & 0xFF
        if lo == 5:
            return 3
        if lo == 6:
            return 4
        return 0
    if hi == 8:
        if lo <= 2:
            return lo
        if lo <= 6:
            return lo + 1
        return lo
    if hi == 9:
        if lo <= 4:
            return lo + 0x10
        if lo == 6:
            return 0x15
        if lo == 7:
            return 3
        return 0
    if hi == 0xB:
        if lo <= 2:
            return 0x10 if lo == 0 else 0x11
        if lo <= 9:
            return lo + 0xE
        if lo <= 0xE:
            return lo + 0xD
        return 0
    if hi == 0xC:
        if lo <= 1:
            return lo
        return 2 if lo == 4 else 0
    if hi == 0xD:
        if lo == 0:
            return 0
        if lo == 1:
            return 0x29
        if lo <= 4:
            return lo - 1
        return 0
    return 0


def menu_entry(g):
    e = s8(0xFFED74E8 + 8 * g, 8)
    return e[0], struct.unpack("<I", e[4:8])[0]


def label(g, i):
    cnt, ptr = menu_entry(g)
    if ptr == 0:
        return None, "", cnt
    a = ptr + 20 * i
    return a, cstr(a, 20), cnt


VALTAB = {  # group -> (table, base bra.l, first code, n)
    "2x": (0xFFF481F0, 0xFFF01085, 0x20, 13),
    "4x": (0xFFF4820A, 0xFFF01FA9, 0x40, 14),
    "8x": (0xFFF48232, 0xFFF040C7, 0x80, 24),
}
VALDEF = {"2x": 0xFFF01C09, "4x": 0xFFF030D3, "8x": 0xFFF05385}


def ipc_screen(c):                       # sub_FFEDF3A7 (F3 @FFEDF3B4.., F4 @FFEDF407..)
    hi, lo = c >> 8, c & 0xFF
    if hi == 0xF4:
        return {0: 0x1F, 1: 0x45, 2: 0x46, 3: 0x47, 4: 0x48}.get(lo, -1)
    if lo in (0xD5, 0xD6):
        return -1
    return {0x00: 0x1D, 0x01: 0x1E, 0x66: 0x43, 0xB3: 0x20, 0xB8: 0x20, 0xD1: 0x21}.get(lo, 0x1F)


def value_draw(code):
    for key, (tab, base, first, n) in VALTAB.items():
        if first <= code < first + n:
            w = struct.unpack("<h", s8(tab + 2 * (code - first), 2))[0]
            t = (base + w) & 0xFFFFFFFF
            return "%08X%s" % (t, " (default/no-draw)" if t == VALDEF[key] else "")
    return "-"


# ---------------- MAIN sender table -------------------------------------------
def stub(r):
    return struct.unpack(">I", M[0x782C + 4 * r:0x7830 + 4 * r])[0]


def stub_code(a, depth=0):
    i = a
    while i < a + 0x60:
        b = M[i:i + 4]
        if b[:2] == b"\x54\x70":            # rts
            return None
        if b[0] == 0x79 and b[1] in (0x0B, 0x04) and b[2] in (0xF3, 0xF4):
            return (b[2] << 8) | b[3]
        if b[0] == 0x5E and depth == 0:     # jsr @abs24 -> follow once
            t = (b[1] << 16) | (b[2] << 8) | b[3]
            c = stub_code(t, 1)
            if c:
                return c
        i += 2
    return None


rows = {}
for ln in open(os.path.join(ROOT, r"ida\out\settings\1515c-rowcodes.tsv"), encoding="utf-8"):
    p = ln.rstrip("\n").split("\t")
    if p[0].startswith("0x0"):
        rows.setdefault(int(p[2], 16), []).append("%s[%s]" % (p[0], p[1]))

TARGET = {
    0xF320: "record +0x39 b5 (packed +0x1F b5) [doc35]; sender 0x4E70 bld #5 @(0x39,er0)",
    0xF321: "record +0x12 b5 (packed +0x00 b5) [doc35]; sender 0x52E4 bld #5 @(0x12,er0)",
    0xF340: "record +0x38 (packed +0x1F b0-2) -> frame+0x22; [0xFF8995] R1 n=0x75 EEPROM 0x5F5 BACKUP 0x4B5 -> frame+0x23; sender 0x4EB4",
    0xF34A: "record +0x16 (packed +0x05 b0-3), band-remapped by sub_3EFEE tables 0x3C70..0x3C94; sender 0x57F8",
    0xF395: "record +0x36 b0-1 (packed +0x1E b4-5) -> frame+0x22; [0xFF89C7] R1 n=0xA7 EEPROM 0x627 BACKUP 0x4E7 -> frame+0x23; sender 0x52CC",
    0xF400: "record +0x13 (packed +0x05 b6-7); sender 0x597E",
}
SPECIAL_LABEL = {0xF400: ("FFF4A509", "TX POWER (title drawn directly by sub_FFF0878C, group 0; not from the setup-label table)")}

lines = ["# Lane G3. MAIN row code -> sender stub (table 0x782C) -> F-code; SUB code -> group (sub_FFF092FC) / row (sub_FFF09396) -> label = menu[grp].labels + 20*row (walker sub_FFF0964A @FFF09695..FFF096A2).",
         "# status: C=Confirmed (bytes/insn read) I=Inferred U=Unknown NF=Not found. target=1 marks the lane's six codes.",
         "code\ttarget\tsub_screen\tmain_row_code\tmain_stub\tmenu_rowlists\tsub_group\tsub_row\tlabel_addr\tlabel_text\tsub_value_draw\tsettings_byte\tstatus\tnote"]
seen = set()
for r in range(0, (0x7BE8 - 0x782C) // 4):
    a = stub(r)
    c = stub_code(a)
    if c is None:
        continue
    key = (c, r)
    seen.add(c)
    low = c & 0xFF
    if c >> 8 == 0xF4:
        g, i = 0, 0
        la, lt, note = SPECIAL_LABEL.get(c, ("-", "", ""))[0], SPECIAL_LABEL.get(c, ("-", ""))[1], "F4 family: SUB 0x8C4E=0x%02X -> group 0 path" % low
        vd = "FFF0878C" if c == 0xF400 else "-"
        st = "C" if c == 0xF400 else "I"
    else:
        g, i = sub_grp(low), sub_idx(low)
        la_, lt, cnt = label(g, i)
        la = ("%08X" % la_) if la_ else "-"
        note = ""
        if la_ is None:
            note = "group %d has no label table" % g
        elif i >= cnt:
            note = "row %d >= group count %d (out of table; label not drawn from a valid slot)" % (i, cnt)
            lt = ""
        vd = value_draw(low)
        st = "C"
        if c == 0xF395:
            note = "sub_FFF09396 has no case for 0x95 -> default row 0 -> label is group-8 row 0 (APO) fallback; value page draws MODE OFF/BUSY/SIGNALING + SELECT PATTERN1-3"
            st = "C(path)/I(meaning)"
    scr = ipc_screen(c)
    if scr != 0x1F:
        note = ("IPC routes this code to screen 0x%02X, not setup-item screen 0x1F; the label path is not used. " % scr
                if scr >= 0 else "IPC excludes this sub-op. ") + note
    lines.append("\t".join([
        "%04X" % c, "1" if c in TARGET else "0", ("0x%02X" % scr) if scr >= 0 else "excluded",
        "0x%02X" % r, "0x%05X" % a,
        ",".join(rows.get(r, [])) or "-", "0x%02X" % g, "%d" % i, la, lt, vd,
        TARGET.get(c, "-"), st, note]))
GB = {0x1515C: 1, 0x15166: 0x15, 0x1516A: 0x16, 0x15180: 0x17, 0x15186: 3, 0x1518C: 4,
      0x1519A: 5, 0x151A0: 6, 0x151A2: 7, 0x151A8: 8, 0x151BE: 9, 0x151DA: 0xA, 0x151DE: 0xB, 0x151E4: 0xC}
agree = disagree = 0
bad = []
for ln in lines[3:]:
    p = ln.split("	")
    for ent in p[5].split(","):
        if ent == "-":
            continue
        base, pos = ent.split("[")
        base, pos = int(base, 16), int(pos.rstrip("]"))
        if base not in GB:
            continue
        if (GB[base], pos) == (int(p[6], 16), int(p[7])):
            agree += 1
        else:
            disagree += 1
            bad.append("%s %s" % (p[0], ent))
lines.insert(2, "# cross-check MAIN menu row lists (doc 32) vs SUB model: %d (group,row) agree, %d disagree: %s" % (agree, disagree, "; ".join(bad)))
with open(os.path.join(OUT, "f3xx-codes.tsv"), "w", encoding="utf-8", newline="\n") as fh:
    fh.write("\n".join(lines) + "\n")

# ---------------- mode / step tables -------------------------------------------
ml = ["# Lane G3 mode/step tables. status C = bytes read.",
      "table\tindex\taddr\tbytes\ttext_or_value\tselector_site\tstatus"]
for idx, a in ((0, 0xFFF48834), (1, 0xFFF48837), (2, 0xFFF4883A)):
    ml.append("\t".join(["SUB RX MODE (code 0x22, frame+0x20)", str(idx), "%08X" % a,
                         s8(a, 5).hex(" "), cstr(a), "FFF011CE cmp #2 / FFF011D2 cmp #1 / FFF011D6 cmp #0 (value-draw FFF011C5)", "C"]))
for i in range(13):
    a = 0xFFF4908C + 10 * i
    ml.append("\t".join(["SUB STEP strings (code 0x91, 13x10 B, copied by smovf #0x82 @FFF04CBA)", "0x%02X" % i, "%08X" % a,
                         s8(a, 10).hex(" "), cstr(a, 10), "FFF04CCC cmp #0Dh; clamp to 0x0C; FFF04CDF mul #0Ah", "C"]))
for i in range(12):
    a = 0x1E07C + 2 * i
    v = struct.unpack(">H", M[a:a + 2])[0]
    ml.append("\t".join(["MAIN step table unk_1E07C (BE u16, x10 Hz)", "0x%02X" % i, "0x%05X" % a,
                         M[a:a + 2].hex(" "), "%d (= %.2f kHz)" % (v, v / 100.0), "read by sub_1DF7A (doc 35)", "C"]))
for i in range(12):
    a = 0xFFF48AF4 + 16 * i
    b = 0xFFF48BB4 + 16 * i
    ml.append("\t".join(["SUB SQL TYPE strings (code 0x4A; long/short)", "0x%02X" % i, "%08X/%08X" % (a, b),
                         s8(a, 16).hex(" "), "%s / %s" % (cstr(a, 16), cstr(b, 16)), "FFF02DAA cmp #0Ch; clamp 0x0B; shll #4", "C"]))
for i in range(4):
    a = 0xFFF4A51F + 16 * i
    ml.append("\t".join(["SUB TX POWER strings (F400, frame+0x20)", str(i), "%08X" % a, s8(a, 16).hex(" "), cstr(a, 16),
                         "FFF087F0 cmp #4; clamp 3; shll #4", "C"]))
with open(os.path.join(OUT, "mode-step.tsv"), "w", encoding="utf-8", newline="\n") as fh:
    fh.write("\n".join(ml) + "\n")
print("ok", len(lines) - 3, "codes;", len(ml) - 2, "mode/step rows")
