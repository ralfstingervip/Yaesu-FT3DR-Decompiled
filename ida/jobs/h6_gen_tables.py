r"""Lane H6 - plain Python (NOT an IDA script). Read-only over decrypted\*.bin.

Writes ida\out\value-tables\a-items.tsv and a-options.tsv for SUB menu groups
1, 3, 5, 6, 7 (value-draw routines, option strings, frame bytes, MAIN sender
and settings byte).  Every (address, bytes) citation below is re-read from the
images and the script aborts if any does not match, so the TSVs cannot drift
from the bytes.  Disassembly evidence: ida\out\value-tables\h6_draw-lin.txt,
h6_sub2..4.txt (SUB), h6_main-stubs.txt, h6_main2..4.txt (MAIN), h6_stores.txt (stores).

    python "ida/jobs/h6_gen_tables.py"
"""
import sys
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root
import os

ROOT = str(_REPO)
OUT = os.path.join(ROOT, r"ida\out\value-tables")
S = sys.exit("The firmware image is not in this repository.")
M = sys.exit("The firmware image is not in this repository.")
SB = 0xFFC00000

# ---------------------------------------------------------------- byte checks
SUB_CHECKS = [  # (addr, hex bytes) - instructions cited in the doc
    (0xFFF006AB, "61 a1"), (0xFFF006B2, "fb e2 da 81 f4 ff"), (0xFFF006BB, "7f 4e"),
    (0xFFF006CA, "fb 22 a4 86 f4 ff"), (0xFFF006EB, "fb 22 ac 86 f4 ff"),
    (0xFFF0072C, "fb 22 b4 86 f4 ff"), (0xFFF0074D, "fb 22 bd 86 f4 ff"),
    (0xFFF00785, "61 31"), (0xFFF00790, "fb 22 c8 86 f4 ff"), (0xFFF007A8, "63 53"),
    (0xFFF007DF, "59 e1 22"), (0xFFF007E4, "fd 74 9e 0b"), (0xFFF007F5, "fb e2 72 8f 00 00"),
    (0xFFF008E1, "fb 22 0d 87 f4 ff"), (0xFFF00918, "63 a3"), (0xFFF00960, "59 ee 23"),
    (0xFFF00860, "fb 4a 22 4f"), (0xFFF0087C, "fb 4a 33 42"), (0xFFF008D0, "fb 4a 43 49"),
    (0xFFF00A0D, "fb 22 8a 87 f4 ff"), (0xFFF00A43, "fb 22 9c 87 f4 ff"),
    (0xFFF00A8F, "61 f1"), (0xFFF00A9C, "62 12"), (0xFFF00B4B, "61 61"),
    (0xFFF00B5E, "05 87 11 fe"), (0xFFF00C0E, "61 31"), (0xFFF00C8C, "71 11 21"),
    (0xFFF00CF0, "59 43 31"), (0xFFF00DBE, "71 11 43"), (0xFFF00E01, "71 11 4d"),
    (0xFFF00E43, "fb 4a 45 45"), (0xFFF00E59, "fb 4a 35 30"), (0xFFF00EB4, "71 11 20"),
    (0xFFF00EFB, "3c 01 13"), (0xFFF00FE5, "59 ee 20"), (0xFFF00FED, "60 21"),
    (0xFFF0104D, "67 43"),
    (0xFFF01D23, "75 51 35"), (0xFFF01D29, "75 51 31"), (0xFFF01D2E, "75 51 33"),
    (0xFFF01D34, "75 51 34"), (0xFFF01D3A, "75 51 30"), (0xFFF01D66, "f8 04 18"),
    (0xFFF01C33, "75 11 24"), (0xFFF01CCD, "b4 91"), (0xFFF01E4F, "61 31"),
    (0xFFF0326C, "71 11 b0"), (0xFFF0326F, "61 51"), (0xFFF03276, "fb e2 26 82 f4 ff"),
    (0xFFF0328A, "75 51 1c"), (0xFFF03296, "61 81"), (0xFFF032BF, "71 11 31"),
    (0xFFF032D6, "75 51 1b"), (0xFFF03313, "60 72"), (0xFFF03315, "fd 74 82 02"),
    (0xFFF03376, "75 4f 49"), (0xFFF033AE, "75 4f 73"),
    (0xFFF0347C, "59 e3 22"), (0xFFF0349E, "59 e3 23"), (0xFFF03513, "61 3e"),
    (0xFFF03533, "61 4e"), (0xFFF035B0, "59 ee 24"),
    (0xFFF030E6, "75 51 13"), (0xFFF030F0, "75 51 10"), (0xFFF030F5, "75 51 12"),
    (0xFFF030FA, "75 51 11"), (0xFFF0317C, "68 11"), (0xFFF0317E, "71 11 32"),
    (0xFFF03824, "75 51 65"), (0xFFF03829, "75 51 63"), (0xFFF03849, "71 11 20"),
    (0xFFF03872, "61 31"), (0xFFF03891, "59 e2 25"), (0xFFF038D0, "59 e2 24"),
    (0xFFF0052E, "75 51 65"), (0xFFF00531, "20 76"),
    (0xFFF03AFA, "75 51 76"), (0xFFF03B00, "75 51 72"), (0xFFF03B06, "71 1e 8d"),
    (0xFFF03B10, "75 51 75"), (0xFFF03B16, "75 51 71"), (0xFFF03B22, "c5 e0 21 c3"),
    (0xFFF03B9B, "66 93"), (0xFFF03BA3, "39 a5 fd"), (0xFFF03D1D, "66 23"),
    (0xFFF03D21, "39 31 f9"), (0xFFF03D9F, "39 b3 f8"), (0xFFF03DC7, "c5 e0 20 05"),
    (0xFFF03DD1, "c5 e0 21 04"), (0xFFF03E5E, "fb 42 60 88 f4 ff"),
    (0xFFF03736, "f9 04 2b 43"), (0xFFF03798, "fb 22 6f 8e f4 ff"),
    (0xFFC0012D, "30 31 32 33 34 35 36 37 38 39"),
]
MAIN_CHECKS = [
    (0x0059F8, "6a 10 89 c5 77 00 79 0b f3 11"), (0x005938, "6a 10 8a be 77 70 79 0b f3 12"),
    (0x005788, "79 0b f3 13 6a 0b 89 b9"), (0x005326, "f3 00 6a 0c 89 aa ac 0a 47 04 0a 0c 0c c3"),
    (0x005336, "6a 10 89 c5 77 70 67 0b 6b 83 b0 5a 79 0b f3 14 5e 00 97 92"),
    (0x005310, "6a 10 89 c2 77 10 67 0b 6d f3 79 0b f3 15"),
    (0x00534C, "6a 0b 89 a9 fc 13 18 cb 6d f3 79 0b f3 16"),
    (0x005154, "79 0b f3 17 6a 0b 89 a4"),
    (0x0054C8, "6a 0b 89 55 7a 06 00 ff 3d 94 68 eb"),
    (0x0054F6, "79 04 00 12 7a 05 00 ff 89 56 7a 06 00 ff 3d a5"),
    (0x00550E, "79 04 00 0a 7a 05 00 ff 8d 26 7a 06 00 ff 3d b7"),
    (0x009C8E, "79 04 00 5f 6b a4 00 ff 3d 72 79 04 f3 18"),
    (0x009CB2, "79 04 00 31 6b a4 00 ff 3d 72 79 04 f3 19"),
    (0x0056E6, "79 0b f3 1a 6a 0b 89 b6"),
    (0x009CF4, "79 04 00 32 6b a4 00 ff 3d 72 79 04 f3 1b"),
    (0x009D18, "6a 10 bc 8a 77 00"), (0x009D2E, "fc 01"), (0x009D38, "fc 02"), (0x009D42, "fc 00"),
    (0x009D4A, "7a 05 00 ff 81 3f"), (0x009D62, "7a 05 00 ff b0 dc"),
    (0x056A0C, "6b 84 b0 dc"), (0x014A62, "6a 18 bc 8a 70 00"), (0x014A96, "6a 18 bc 8a 72 00"),
    (0x01494C, "6a 10 89 c1 73 30"),
    (0x004EE4, "7a 04 00 ff 3d 96 01 00 6b 84 bc 2c fc 13 6a 8c bb e8"),
    (0x004F96, "7a 04 00 ff 3d 96 01 00 6b 84 bc 2c fc 12 6a 8c bb e8"),
    (0x009DBC, "79 04 00 89 6b a4 00 ff 3d 72 79 04 f3 30"),
    (0x009DE0, "79 04 00 84 6b a4 00 ff 3d 72 79 04 f3 31"),
    (0x0053AE, "6a 10 89 c1 77 20 79 0b f3 33"),
    (0x00575C, "fb 00 6e 0c 00 07 ec 0c 47 08 fb 01 ac 04 47 02 fb 02"),
    (0x00539A, "6a 10 89 c1 77 00 79 0b f3 35"),
    (0x005690, "79 0b f3 50 6a 0b 89 af"), (0x00573A, "6a 10 89 be 77 50 79 0b f3 51"),
    (0x0056D8, "79 0b f3 52 6a 0b 89 b2"),
    (0x0056C2, "6a 03 89 90 6a 0b 89 91 6b 83 b0 5a 79 0b f3 53 5e 00 97 92"),
    (0x00569E, "6e 03 00 50 6e 0b 00 51 6b 83 b0 5a fb 00 6a 10 89 c5 77 60"),
    (0x0056B8, "79 0b f3 54 5e 00 98 ca"),
    (0x00567C, "6a 10 89 c3 77 00 79 0b f3 55"),
    (0x009EC2, "79 04 f3 63"), (0x0059C4, "3f 3f 3f 3f 3f"), (0x0059CA, "7a 05 00 ff 80 60"),
    (0x05E95C, "79 0b f3 64 6a 0b 8d d7"),
    (0x05E96A, "6a 04 8d d8 6a 0c 8d d9"), (0x05E974, "6a 10 8e a0 73 60"),
    (0x05E994, "79 0b f3 65 5e 00 99 22"),
    (0x069ADA, "6a 10 b3 80 73 00"), (0x069AEE, "6a 03 8d 90 7a 05 00 ff b3 86 5e 00 9f 9c"),
    (0x009FAC, "79 04 f3 71"), (0x00C41C, "00 00 02 f0"),
    (0x05E9C6, "79 0b f3 72 6a 0b 8d 8f"),
    (0x00A01A, "79 04 f3 73"), (0x00A03E, "79 04 f3 74"), (0x00A062, "79 04 f3 75"),
    (0x06ED3A, "5e 00 a0 10"), (0x06EDA4, "5e 00 a0 34"), (0x06EDE2, "5e 00 a0 58"),
    (0x05E944, "fc 00 6a 04 8d 24 47 02 fc 01 0c cb 47 02 0c 4b f3 00 5e 00 a0 7c"),
    (0x00A0A2, "7a 06 00 ff 3d 94 68 eb 0c 3b 7a 06 00 ff 3d 95 68 eb"),
    (0x00976A, "79 04 00 29 6b a4 00 ff 3d 72 6b ab 00 ff 3d 74"),
    (0x009784, "7a 06 00 ff 3d 94 68 eb"),
    (0x0097CC, "6b 04 b0 5a 6b a4 00 ff 3d 96"),
]


def chk():
    bad = []
    for a, h in SUB_CHECKS:
        b = bytes.fromhex(h.replace(" ", ""))
        if S[a - SB:a - SB + len(b)] != b:
            bad.append("SUB %08X want %s got %s" % (a, h, S[a - SB:a - SB + len(b)].hex(" ")))
    for a, h in MAIN_CHECKS:
        b = bytes.fromhex(h.replace(" ", ""))
        if M[a:a + len(b)] != b:
            bad.append("MAIN %06X want %s got %s" % (a, h, M[a:a + len(b)].hex(" ")))
    if bad:
        raise SystemExit("byte check failed:" "\n" + "\n".join(bad))
    return len(SUB_CHECKS) + len(MAIN_CHECKS)


def cstr(a, n=24):
    o = a - SB
    e = S.find(b"\0", o, o + n)
    return S[o:(e if e >= 0 else o + n)]


def show(raw):
    if all(0x20 <= c < 0x7F for c in raw):
        return raw.decode("ascii")
    return "hex:" + raw.hex(" ")


# ---------------------------------------------------------------- items
# group, row, sub_code, label_addr, F-code, MAIN row code, MAIN sender, SUB store,
# SUB draw entry, frame bytes, value format, settings RAM (doc 32 row), status, note
I = [
 (1, 0, 0x11, 0xFFC3DF4D, "F311", "0x8E", "0x0059F8 bld #0,@FF89C5 -> sub_976A", "FFEFE727 (1 B)", "FFF006BD",
  "+0x20", "0 COMPASS / else NUMERIC", "FF89C5 b0 (R1 n=0xA5 EEPROM 0x625 BACKUP 0x4E5, byte default 0x40 -> b0=0)", "C", ""),
 (1, 1, 0x12, 0xFFC3DF61, "F312", "0x84", "0x005938 bld #7,@FF8ABE -> sub_976A", "FFEFE727 (1 B)", "FFF0071F",
  "+0x20", "0 NORTH UP / else HEADING UP", "FF8ABE b7 (R2 n=0x1E EEPROM 0xC01E BACKUP 0xBEDE, default 0x00)", "C", ""),
 (1, 2, 0x13, 0xFFC3DF75, "F313", "0x68", "0x005788 mov.b @FF89B9 -> sub_976A", "FFEFE727 (1 B)", "FFF00781",
  "+0x20", "clamp >=3 ->2; table FFF486C8 stride 5: 19 CH/39 CH/79 CH", "FF89B9 (R1 n=0x99 EEPROM 0x619 BACKUP 0x4D9, default 1 = 39 CH)", "C", ""),
 (1, 3, 0x14, 0xFFC3DF89, "F314", "0x40", "0x005326 word via sub_9792: hi=([FF89AA]==10?0:[FF89AA]+1), lo=FF89C5 b7", "FFEFE727 (+0x20..+0x23)", "FFF007D9",
  "+0x20 edit flag, +0x21 cursor line, +0x22 KEY, +0x23 SAVE", "KEY = (+0x22 mod 11) -> table FFF4870D stride 10 (EN) / FFF486E1 stride 4 + kanji (JP); SAVE 0 OFF/1 ON",
  "KEY FF89AA (R1 n=0x8A EEPROM 0x60A BACKUP 0x4CA, default 5 -> index 6 = 30 sec); SAVE FF89C5 b7 (default 0)", "C", "MAIN raw 0..9 -> 2 sec..CONTINUOUS, raw 10 -> OFF"),
 (1, 4, 0x15, 0xFFC3DF9D, "F315", "0x3F", "0x005310 bld #1,@FF89C2 -> sub_976A", "FFEFE727 (1 B)", "FFF00A00",
  "+0x20", "0 JAPANESE + JIS 日本語 / else ENGLISH + JIS 英語", "FF89C2 b1 (R1 n=0xA2 EEPROM 0x622 BACKUP 0x4E2, byte default 0x20 -> b1=0)", "C", ""),
 (1, 4, 0x16, 0xFFC3DF9D, "F316", "0x41", "0x00534C ([FF89A9]-0x13) -> sub_976A", "FFEFE727 (1 B)", "FFF00A8B",
  "+0x20", "clamp >=15 ->14; shown as LEVEL v+1 = 1..15", "FF89A9 (R1 n=0x89 EEPROM 0x609 BACKUP 0x4C9, default 0x19 -> sent 6 -> LEVEL 7)", "C(path)/I(hidden)",
  "no own label: sub_FFF09396 maps 0x16 to row 4 (LANGUAGE); row code 0x41 is in no MAIN menu row list (doc 32/38) -> unlisted 15-step LEVEL item"),
 (1, 5, 0x17, 0xFFC3DFB1, "F317", "0x28", "0x005154 mov.b @FF89A4 -> sub_976A", "FFEFE727 (1 B)", "FFF00B47",
  "+0x20", "clamp >=6 ->5; LEVEL v+1 = 1..6 (single digit, sub_FFEE1CE5)", "FF89A4 (R1 n=0x84 EEPROM 0x604 BACKUP 0x4C4, default 5 -> LEVEL 6)", "C", ""),
 (1, 6, 0x18, 0xFFC3DFC5, "F318", "-", "0x0054C8.. -> builder 0x009C8E (len 0x5F)", "FFEFE727 (+0x20..+0x56)", "FFF00C0A",
  "+0x20 mode, +0x21 DC text(10), +0x31..32 attr, +0x33 MESSAGE(16), +0x43 CALLSIGN(10), +0x4D (10)", "0 OFF / 1 DC: text / 2 MESSAGE: text / 3 CALLSIGN: text; >=4 nothing",
  "mode FF8955 (R1 n=0x35 EEPROM 0x5B5 BACKUP 0x475, default 1 = DC); message FF8956..FF8967 (0x12 B); callsign FF8D26 (R3 n=0x6, 10 B)", "C", "DC text built from ROM template 0x89B0 + digits of [FFA9C0] (sub_8986)"),
 (1, 7, 0x19, 0xFFC3DFD9, "F319", "0x70", "0x00583A -> builder 0x009CB2 (len 0x31)", "FFEFE727 (+0x20..+0x28)", "FFF00E32",
  "+0x20.. text(10)", "VOLT : <text> (EN) / JIS 電圧 (JP)", "voltage text from [FFA9C2]/[FFA9C0] (not a menu setting)", "C", ""),
 (1, 7, 0x1A, 0xFFC3DFD9, "F31A", "0x5C", "0x0056E6 mov.b @FF89B6 -> sub_976A", "FFEFE727 (1 B)", "none (jump-table slot -> FFF0104D rtsd)",
  "+0x20", "not drawn", "FF89B6 (R1 n=0x96 EEPROM 0x616 BACKUP 0x4D6)", "C", "latched but no value draw; label SENSOR INFO only"),
 (1, 8, 0x1B, 0xFFC3DFED, "F31B", "0xC0", "0x05E9C0 -> builder 0x009CF4 (len 0x32)", "FFEFE727 (10 B via sub_FFEF208D)", "FFF00ED1",
  "+0x20 ext flag, +0x21..23 MAIN, +0x24..26 SUB, +0x27..29 DSP", "three lines 'X.YY' (+ZZ when +0x20!=0): Main 1.02(00), Sub [FF813F..41], DSP [FFB0DC..DD]",
  "+0x20 = FFBC8A b0 (set only by key-sequence machine 0x01494C..0x014AA6)", "C(path)/I(key sequence)", "MAIN version digits are immediates 1,2,0 at 0x9D2E/0x9D38/0x9D42"),
 (3, 0, 0x30, 0xFFC3E03D, "F330", "-", "0x004EE4..0x004F32 list fill (sub_53634, stride 0x13, cb 0x4F38) -> builder 0x009DBC (len 0x89)", "FFEFECA4 (list)", "FFF01D40",
  "+0x20 top index, +0x21 cursor(1-based), +0x22 5 x 0x13 {attr2,name16,link1}", "rows 'nn name [link box]', nn = top+i; scrollbar 24 banks", "bank table (list callback 0x4F38)", "C", ""),
 (3, 1, 0x31, 0xFFC3E051, "F331", "-", "0x004F96..0x004FE4 list fill (stride 0x12, cb 0x4FEA) -> builder 0x009DE0 (len 0x84)", "FFEFECA4 (list)", "FFF01D7D",
  "+0x20 top, +0x21 cursor, +0x22 5 x 0x12 {attr2,name16}", "rows 'nn name'; scrollbar 24", "bank names (list callback 0x4FEA)", "C", ""),
 (3, 2, 0x32, 0xFFC3E065, "-", "-", "none found (MAIN-wide scan for 79 0x f3 32: 0 hits)", "no case", "no case in FFF01D02",
  "-", "label only", "-", "NF (scope: whole MAIN image for mov.w #F332; SUB group-3 store and draw chains)", "MEMORY NAME has no value page on screen 0x1F"),
 (3, 3, 0x33, 0xFFC3E079, "F333", "0x4B", "0x0053AE bld #2,@FF89C1 -> sub_976A", "FFEFECA4 (1 B)", "FFF01DEA",
  "+0x20", "0 OFF / else ON", "FF89C1 b2 (R1 n=0xA1 EEPROM 0x621 BACKUP 0x4E1, byte default 0x11 -> b2=0)", "C", ""),
 (3, 4, 0x34, 0xFFC3E08D, "F334", "0x64", "0x00575C (record+0x07 & 0x0C: 0->0, 4->1, else 2) -> sub_976A", "FFEFECA4 (1 B; 2 -> sub_FFEF0163)", "FFF01E4C",
  "+0x20", "clamp >=3 ->2; 0 OFF / 1 SKIP + icon FFECF18C / 2 SELECT + icon FFECEE9C", "per-channel record +0x07 bits 2-3 (er0 record, doc 35)", "C", "record field 0x08 and 0x0C both shown as SELECT"),
 (3, 5, 0x35, 0xFFC3E0A1, "F335", "0x4A", "0x00539A bld #0,@FF89C1 -> sub_976A", "FFEFECA4 (1 B)", "FFF01F0C",
  "+0x20", "0 LOWER / else NEXT", "FF89C1 b0 (default 0x11 -> b0=1 = NEXT)", "C", ""),
 (5, 0, 0x50, 0xFFC3E1CD, "F350", "0x58", "0x005690 mov.b @FF89AF -> sub_976A", "FFEFF4E5 (1 B)", "FFF03281",
  "+0x20", "v=min(v,27): 0..8 -> 0.1..0.9; 9..26 -> 1.0..9.5 step 0.5; 27 -> 10; + ' sec' / 秒", "FF89AF (R1 n=0x8F EEPROM 0x60F BACKUP 0x4CF, default 0x11 -> 5.0 sec)", "C", ""),
 (5, 1, 0x51, 0xFFC3E1E1, "F351", "0x62", "0x00573A bld #5,@FF89BE -> sub_976A", "FFEFF4E5 (1 B)", "FFF03408",
  "+0x20", "0 OFF / else ON", "FF89BE b5 (R1 n=0x9E EEPROM 0x61E BACKUP 0x4DE, byte default 0x20 -> ON)", "C", ""),
 (5, 2, 0x52, 0xFFC3E1F5, "F352", "0x5B", "0x0056D8 mov.b @FF89B2 -> sub_976A", "FFEFF4E5 (1 B)", "FFF03281 (shared with 0x50)",
  "+0x20", "same 28-step scale as DW TIME", "FF89B2 (R1 n=0x92 EEPROM 0x612 BACKUP 0x4D2, default 0x0B -> 2.0 sec)", "C", ""),
 (5, 3, 0x53, 0xFFC3E209, "F353", "0x5A", "0x0056C2 word via sub_9792: hi=[FF8990], lo=[FF8991]", "FFEFF4E5 (+0x20..+0x23)", "FFF03466",
  "+0x22 SCAN, +0x23 DW", "each via sub_FFF030D5: v=min(v,18): 0..15 -> 2.0..9.5 sec; 16 -> 10.0 sec; 17 BUSY; 18 HOLD",
  "SCAN FF8990 (R1 n=0x70 EEPROM 0x5F0 BACKUP 0x4B0, default 6 -> 5.0 sec); DW FF8991 (n=0x71 EEPROM 0x5F1 BACKUP 0x4B1, default 0x12 -> HOLD)", "C", ""),
 (5, 4, 0x54, 0xFFC3E21D, "F354", "0x59", "0x00569E 3 B via sub_98CA: record+0x50, record+0x51, FF89C5 b6", "FFEFF4E5 (+0x20..+0x24)", "FFF034FA",
  "+0x22 VFO, +0x23 MEMORY, +0x24 BANK LINK", "VFO 3 BAND / 4 ALL; MEMORY 3 BAND / 4 ALL CH; BANK LINK 0 OFF / 1 ON; any other value -> blank",
  "VFO/MEMORY = er0 record +0x50/+0x51 (writer not traced); BANK LINK FF89C5 b6 (default 1 = ON)", "C(draw)/U(record values)", ""),
 (5, 5, 0x55, 0xFFC3E231, "F355", "0x57", "0x00567C bld #0,@FF89C3 -> sub_976A", "FFEFF4E5 (1 B)", "FFF03408 (shared with 0x51)",
  "+0x20", "0 OFF / else ON", "FF89C3 b0 (R1 n=0xA3 EEPROM 0x623 BACKUP 0x4E3, byte default 0xA8 -> OFF)", "C", ""),
 (6, 0, 0x64, 0xFFC3E245, "F364", "0x38", "0x05E95C mov.b @FF8DD7 -> sub_976A", "no case (FFEFF68A handles 0x63/0x65 only)", "no case in FFF0381A",
  "+0x20 (not latched)", "label only", "FF8DD7 (R3 n=0xB7 EEPROM 0xD0B7 BACKUP 0xCF77, default 1)", "C", "DP-ID LIST value is sent but never latched or drawn by screen 0x1F"),
 (6, 0, 0x65, 0xFFC3E245, "F365", "0x39", "0x05E96A 4 B via sub_9922: [FF8DD8],[FF8DD9],[FF8ED8|FF8ED6],[FF8ED9|FF8ED7] (sel FF8EA0 b6)", "FFEFF68A (block, sub_FFEF208D)", "FFF03866",
  "+0x21 cursor, +0x24 RX, +0x25 TX (+0x22/+0x23 latched, not drawn)", "DG-ID TX : nn / DG-ID RX : nn (00..99, zero-padded)",
  "FF8ED6..FF8ED9 (not in doc 32 table); FF8DD8/FF8DD9 (R3 n=0xB8/0xB9, defaults 1/0)", "C",
  "label walker skipped for 0x65 (FFF0052E 75 51 65 / FFF00531 20 76): full-page DG-ID TX/RX view"),
 (6, 1, 0x63, 0xFFC3E259, "F363", "0x8D", "0x005990 (sub_59CA checks 5 chars at FF8060; else ROM '?????' 0x59C4) -> builder 0x009EB4", "FFEFF68A (5 B)", "FFF0382F",
  "+0x20..+0x24", "RADIO ID : <5 chars>", "radio ID text at FF8060 (not in doc 32 table)", "C", ""),
 (7, 0, 0x71, 0xFFC3E26D, "F371", "0xBC", "0x069ADA -> builder 0x009F9C: +0x20=FFB380 b0, +0x21=[FF8D90], +0x22..25=FFB386.., +0x26..27=ROM C41C/C41E", "FFEFF710 (block + +0x26/+0x27)", "FFF03B1C",
  "+0x20 edit flag, +0x21 mode, +0x22.. 9 BCD nibbles", "0 MANUAL / 1 PRESET : NNN.NNN[NN] MHz; >=2 nothing",
  "mode FF8D90 (R3 n=0x70 EEPROM 0xD070 BACKUP 0xCF30); frequency FFB386..", "C", ""),
 (7, 1, 0x72, 0xFFC3E281, "F372", "0xBD", "0x05E9C6 mov.b @FF8D8F -> sub_976A", "FFEFF710 (1 B)", "FFF03C78",
  "+0x20", "0 HISTORY / else ACTIVITY", "FF8D8F (R3 n=0x6F EEPROM 0xD06F BACKUP 0xCF2F)", "C", ""),
 (7, 2, 0x73, 0xFFC3E295, "F373", "-", "0x06ED0C list fill (sub_53634, stride 0x10, cb 0x69F4C) -> builder 0x00A010 (len 0x79)", "FFEFF710 (+0x20, 5 x 16 B)", "FFF03CBE",
  "+0x20 selected, +0x21 5 x 16 B", "rows 'C1'..'C5' + tag text (sub_FFF03652 mode 2, base 1)", "WIRES-X category tags (list callback 0x69F4C)", "C", ""),
 (7, 3, 0x74, 0xFFC3E2A9, "F374", "-", "0x06ED76 list fill (cb 0x69F4C) -> builder 0x00A034 (len 0x79)", "FFEFF710 (+0x20, 5 x 16 B)", "FFF03CBE (shared with 0x73)",
  "+0x20, +0x21 5 x 16 B", "rows 'C1'..'C5' + tag text", "category tags", "C", ""),
 (7, 3, 0x75, 0xFFC3E2A9, "F375", "-", "0x06EDB4 list fill (cb 0x69F9E) -> builder 0x00A058 (len 0x79)", "FFEFF710 (+0x20, 5 x 16 B)", "FFF03D43",
  "+0x20, +0x21 5 x 16 B", "rows: room/node names, no prefix (sub_FFF03652 mode 0, base 0)", "room/node list (callback 0x69F9E)", "C", "row 3 by sub_FFF09396 (lo 5 -> 3)"),
 (7, 4, 0x76, 0xFFC3E2BD, "F376", "0xB4", "0x05E944 -> builder 0x00A07C: +0x20=[FF8D24], +0x21=0 (f3 00 @0x05E954)", "FFEFF710 (+0x20,+0x21)", "FFF03DC1",
  "+0x20 DG-ID, +0x21 WIRES-X flag", "DG-ID: AUTO (0) / nn (01..99); '(WIRES-X)' if +0x21!=0", "FF8D24 (R3 n=0x4 EEPROM 0xD004 BACKUP 0xCEC4, default 0 = AUTO)", "C",
  "+0x21 is forced 0 by the only caller of 0xA07C -> '(WIRES-X)' suffix unreachable on this page"),
]

# ---------------------------------------------------------------- options
# code, item, field, raw value, string address (or None), display override, draw site, reachable, status, note
O = []


def opt(code, item, field, raw, addr, disp, site, reach="yes", st="C", note=""):
    d = disp if disp is not None else show(cstr(addr))
    O.append((code, item, field, raw, ("%08X" % addr) if addr else "-", d, site, reach, st, note))


opt(0x11, "TARGET LOCATION", "+0x20", "0", 0xFFF486A4, None, "FFF006CA")
opt(0x11, "TARGET LOCATION", "+0x20", "!=0", 0xFFF486AC, None, "FFF006EB")
opt(0x12, "COMPASS", "+0x20", "0", 0xFFF486B4, None, "FFF0072C")
opt(0x12, "COMPASS", "+0x20", "!=0", 0xFFF486BD, None, "FFF0074D")
for i in range(3):
    opt(0x13, "BAND SCOPE", "+0x20", str(i) + (" (and >=3)" if i == 2 else ""), 0xFFF486C8 + 5 * i,
        S[0xFFF486C8 - SB + 5 * i:0xFFF486C8 - SB + 5 * i + 5].decode(), "FFF00790 (stride 5)")
for i in range(11):
    a = 0xFFF4870D + 10 * i
    mr = "MAIN [FF89AA]=10" if i == 0 else "MAIN [FF89AA]=%d" % (i - 1)
    opt(0x14, "LAMP KEY (EN)", "+0x22 mod 11", str(i), a, show(S[a - SB:a - SB + 10].split(b"\0")[0]), "FFF008E1 (stride 10)", "yes", "C", mr)
for i in range(11):
    a = 0xFFF486E1 + 4 * i
    if i == 0:
        opt(0x14, "LAMP KEY (JP)", "+0x22 mod 11", "0", 0xFFF486DD, None, "FFF00832 (branch FFF00826)", "yes", "C", "JP table slot FFF486E1 'OFF' never indexed")
    elif i == 10:
        opt(0x14, "LAMP KEY (JP)", "+0x22 mod 11", "10", None, "JIS 0x4F22 0x4233 (連続)", "FFF00860/FFF0087C", "yes", "C", "JP table slot FFF48709 'CON' never indexed")
    else:
        opt(0x14, "LAMP KEY (JP)", "+0x22 mod 11", str(i), a, show(cstr(a)) + " + JIS 0x4943 (秒)", "FFF0088E (stride 4) / FFF008D0")
opt(0x14, "LAMP KEY (JP)", "table slot", "0", 0xFFF486E1, None, "-", "no", "C", "dead slot: value 0 handled by branch FFF00826 before table use")
opt(0x14, "LAMP KEY (JP)", "table slot", "10", 0xFFF48709, None, "-", "no", "C", "dead slot: value 10 handled by branch FFF00851 before table use")
opt(0x14, "LAMP SAVE", "+0x23", "0", 0xFFF486DD, None, "FFF00973")
opt(0x14, "LAMP SAVE", "+0x23", "1", 0xFFF48787, None, "FFF00995")
opt(0x15, "LANGUAGE", "+0x20", "0", 0xFFF4878A, "JAPANESE : + JIS 46 7C 4B 5C 38 6C (日本語) @FFF48795", "FFF00A0D/FFF00A2A")
opt(0x15, "LANGUAGE", "+0x20", "!=0", 0xFFF4879C, "ENGLISH  : + JIS 31 51 38 6C (英語) @FFF487A7", "FFF00A43/FFF00A60")
opt(0x16, "(unlisted, row-4 label)", "+0x20", "0..14 (>=15 -> 14)", 0xFFF487B0, "LEVEL 1..15", "FFF00A8F/FFF00AF6", "I", "I", "MAIN row code 0x41 in no menu row list")
opt(0x17, "LCD DIMMER", "+0x20", "0..5 (>=6 -> 5)", 0xFFF487BC, "LEVEL 1..6", "FFF00B4B/FFF00BAE")
opt(0x18, "OPENING MESSAGE", "+0x20", "0", 0xFFF486DD, None, "FFF00C26")
opt(0x18, "OPENING MESSAGE", "+0x20", "1", 0xFFF487C4, "DC : <10 chars @+0x21>", "FFF00C49")
opt(0x18, "OPENING MESSAGE", "+0x20", "2", 0xFFF487CA, "MESSAGE : <16 chars @+0x33, attr +0x31> + PUSH/DISP hints", "FFF00CAF")
opt(0x18, "OPENING MESSAGE", "+0x20", "3", 0xFFF487DC, "CALLSIGN : <10 @+0x43> : <10 @+0x4D>", "FFF00D7B")
opt(0x18, "OPENING MESSAGE", "+0x20", ">=4", None, "(nothing)", "FFF00C1E", "U", "C", "")
opt(0x19, "SENSOR INFO", "+0x20..", "text", 0xFFF487E5, "VOLT : <10 chars> / JIS 0x4545 0x3035 (電圧)", "FFF00E6F/FFF00E43")
opt(0x1A, "SENSOR INFO (F31A)", "+0x20", "any", None, "(not drawn)", "FFF0104D", "-", "C", "jump-table slot is the dispatcher's rtsd")
opt(0x1B, "SOFTWARE VERSION", "+0x21..+0x23", "1,2,0", 0xFFF487EC, "Main Ver. : 1.02 (1.0200 when +0x20!=0)", "FFF00ED4")
opt(0x1B, "SOFTWARE VERSION", "+0x24..+0x26", "FF813F..41", 0xFFF48800, "Sub  Ver. : X.YY(ZZ)", "FFF00EE2")
opt(0x1B, "SOFTWARE VERSION", "+0x27..+0x29", "FFB0DC hi, lo, 0", 0xFFF48814, "DSP  Ver. : X.YY(ZZ)", "FFF00EF0")
opt(0x1B, "SOFTWARE VERSION", "+0x20", "!=0", None, "show 2 extra digits (len 0x13 vs 0x11)", "FFF00FE5/FFF00FED", "I", "I", "flag = FFBC8A b0, set only at MAIN 0x014A62 after a key sequence")
opt(0x33, "MEMORY PROTECT", "+0x20", "0", 0xFFF486DD, None, "FFF01DF9")
opt(0x33, "MEMORY PROTECT", "+0x20", "!=0", 0xFFF48787, None, "FFF01E19")
opt(0x34, "MEMORY SKIP", "+0x20", "0", 0xFFF486DD, None, "FFF01E6F")
opt(0x34, "MEMORY SKIP", "+0x20", "1", 0xFFF489D0, None, "FFF01E91")
opt(0x34, "MEMORY SKIP", "+0x20", "2 (and >=3)", 0xFFF489D5, None, "FFF01EC8")
opt(0x35, "MEMORY WRITE", "+0x20", "0", 0xFFF489DC, None, "FFF01F1B")
opt(0x35, "MEMORY WRITE", "+0x20", "!=0", 0xFFF489E2, None, "FFF01F3B")
for v in range(28):
    if v <= 8:
        t = "0.%d" % (v + 1)
    elif v == 27:
        t = "10"
    else:
        t = "%d.%d" % ((v - 7) // 2, 5 if (v - 7) % 2 else 0)
    opt(0x50, "DW TIME / SCAN RE-START (0x52)", "+0x20", str(v) + (" (and >=27)" if v == 27 else ""), None, t + " sec", "FFF03281")
opt(0x51, "SCAN LAMP / PRIORITY REVERT (0x55)", "+0x20", "0", 0xFFF486DD, None, "FFF03415")
opt(0x51, "SCAN LAMP / PRIORITY REVERT (0x55)", "+0x20", "!=0", 0xFFF48787, None, "FFF03435")
for v in range(19):
    if v <= 15:
        t, a = "%d.%d sec" % (2 + v // 2, 5 if v & 1 else 0), None
    elif v == 16:
        t, a = "10.0 sec", None
    elif v == 17:
        t, a = None, 0xFFF48E28
    else:
        t, a = None, 0xFFF48975
    opt(0x53, "SCAN RESUME (SCAN +0x22 / DW +0x23)", "+0x22/+0x23", str(v) + (" (and >=18)" if v == 18 else ""), a, t, "sub_FFF030D5")
opt(0x54, "SCAN WIDTH VFO", "+0x22", "3", 0xFFF48E47, None, "FFF03519")
opt(0x54, "SCAN WIDTH VFO", "+0x22", "4", 0xFFF48E4C, None, "FFF03539")
opt(0x54, "SCAN WIDTH VFO", "+0x22", "0..2, >=5", None, "(blank)", "FFF03513/FFF03533", "U", "C", "MAIN record+0x50 writer not traced")
opt(0x54, "SCAN WIDTH MEMORY", "+0x23", "3", 0xFFF48E47, None, "FFF03566")
opt(0x54, "SCAN WIDTH MEMORY", "+0x23", "4", 0xFFF48E5C, None, "FFF03587")
opt(0x54, "SCAN WIDTH MEMORY", "+0x23", "0..2, >=5", None, "(blank)", "FFF03562/FFF03583", "U", "C", "MAIN record+0x51 writer not traced")
opt(0x54, "SCAN WIDTH BANK LINK", "+0x24", "0", 0xFFF486DD, None, "FFF035B7")
opt(0x54, "SCAN WIDTH BANK LINK", "+0x24", "1", 0xFFF48787, None, "FFF035D8")
opt(0x63, "RADIO ID CHECK", "+0x20..+0x24", "5 chars", 0xFFF48E87, "RADIO ID : <5 chars> ('?????' if invalid)", "FFF0382F")
opt(0x65, "DG-ID TX/RX page", "+0x25 / +0x24", "0..99", 0xFFF48E93, "DG-ID TX : nn / DG-ID RX : nn @FFF48E9F", "FFF03879/FFF038B8")
opt(0x71, "RPT/WIRES FREQ", "+0x21", "0", 0xFFF48A69, None, "FFF03B38")
opt(0x71, "RPT/WIRES FREQ", "+0x21", "1", 0xFFF48EAB, "PRESET : NNN.NNN MHz (@FFF48EB2)", "FFF03B74/FFF03BA3")
opt(0x71, "RPT/WIRES FREQ", "+0x21", ">=2", None, "(nothing)", "FFF03B2F", "U", "C", "")
opt(0x72, "SEARCH SETUP", "+0x20", "0", 0xFFF48EB6, None, "FFF03C89")
opt(0x72, "SEARCH SETUP", "+0x20", "!=0", 0xFFF48EBE, None, "FFF03C9B")
opt(0x73, "EDIT CATEGORY TAG / REMOVE ROOM/NODE (0x74)", "+0x21+16i", "5 rows", None, "C1..C5 + 16-char tag", "FFF03D21 (mode 2)")
opt(0x75, "REMOVE ROOM/NODE (0x75)", "+0x21+16i", "5 rows", None, "16-char name, no prefix", "FFF03D9F (mode 0)")
opt(0x76, "DG-ID", "+0x20", "0", 0xFFF4883A, None, "FFF03E0C")
opt(0x76, "DG-ID", "+0x20", "1..99", None, "nn (zero-padded)", "FFF03E28")
opt(0x76, "DG-ID", "+0x21", "!=0", 0xFFF48860, None, "FFF03E5E", "no", "C", "only MAIN caller of builder 0xA07C sends +0x21 = 0 (0x05E954 f3 00)")


def main():
    n = chk()
    with open(os.path.join(OUT, "a-items.tsv"), "w", encoding="utf-8", newline="\n") as f:
        f.write("# Lane H6: SUB menu groups 1,3,5,6,7 value pages (screen 0x1F). Frame offsets are relative to the latched frame at SUB RAM 0x8C4D (= MAIN 0xFF3D74).\n")
        f.write("# status C=Confirmed I=Inferred U=Unknown NF=Not found. %d cited byte runs re-verified against decrypted\\*.bin by ida\\jobs\\h6_gen_tables.py.\n" % n)
        f.write("group\trow\tsub_code\tlabel_addr\tlabel\tf_code\tmain_row_code\tmain_sender\tsub_store\tsub_draw\tframe_bytes\tvalue_format\tsettings_ram\tstatus\tnote\n")
        for (g, r, c, la, fc, rc, ms, st, dr, fb, vf, sr, s, note) in I:
            f.write("%d\t%d\t0x%02X\t%08X\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n" % (
                g, r, c, la, cstr(la, 20).decode("ascii"), fc, rc, ms, st, dr, fb, vf, sr, s, note))
    with open(os.path.join(OUT, "a-options.tsv"), "w", encoding="utf-8", newline="\n") as f:
        f.write("# Lane H6: option strings / numeric scales per SUB code. reachable: yes / no (with evidence) / U (raw value not shown to be produced) / I.\n")
        f.write("sub_code\titem\tfield\traw\tstring_addr\tdisplay\tdraw_site\treachable\tstatus\tnote\n")
        for row in O:
            f.write("0x%02X\t%s\n" % (row[0], "\t".join(str(x) for x in row[1:])))
    print("checks ok: %d; items %d; options %d" % (n, len(I), len(O)))


main()
