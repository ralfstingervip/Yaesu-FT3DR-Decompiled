import sys
from pathlib import Path as _Path
_REPO = _Path(__file__).resolve().parents[3]
# K12 -- independent re-verification of the J-wave ledger and citations.
# Read-only. Reads decrypted\*.bin, published masks and lane tables; writes only
# into ida\out\ledger-reverify-j\ (citations.tsv, counts.tsv, coverage.tsv).
# Run:  python "ida/out/ledger-reverify-j/k12_reverify.py"
import hashlib, os, re, struct, glob, csv

ROOT = str(_REPO)
OUT = os.path.join(ROOT, r'ida\out\ledger-reverify-j')
DOCS = os.path.join(ROOT, r'docs\deep')
P = lambda *a: os.path.join(ROOT, *a)

sys.exit('The firmware image is not in this repository.')
SUBB = 0xFFC00000
CONTENT = 0x7B754                       # MAIN content end (505,684 B)
WIN = (0x078106, 0x07B754)              # closed window [lo, hi)

def img(a):
    return (S, a - SUBB) if a >= SUBB else (M, a)

def rd(a, n):
    b, o = img(a)
    return b[o:o + n]

def hx(b):
    return ' '.join('%02x' % x for x in b)

def pat(exp):
    """'6a 8? ee ??' -> regex bytes; ?-nibble wildcards allowed."""
    out = b''
    for tok in exp.split():
        if tok == '??':
            out += b'.'
        elif '?' in tok:
            hi, lo = tok[0], tok[1]
            if hi == '?':
                out += b'[' + b''.join(re.escape(bytes([(h << 4) | int(lo, 16)])) for h in range(16)) + b']'
            else:
                out += b'[' + re.escape(bytes([int(hi, 16) << 4])) + b'-' + re.escape(bytes([(int(hi, 16) << 4) | 15])) + b']'
        else:
            out += re.escape(bytes([int(tok, 16)]))
    return re.compile(out, re.S)

# ------------------------------------------------------------------ docs / lines
DOCFILES = {}
for f in os.listdir(DOCS):
    m = re.match(r'(\d\d)-.*\.md$', f)
    if m and 69 <= int(m.group(1)) <= 82:
        DOCFILES[m.group(1)] = f
DOCFILES['R'] = 'RESUME-FULL.md'
LINES = {k: open(os.path.join(DOCS, v), encoding='utf-8').read().split('\n') for k, v in DOCFILES.items()}
R_LO, R_HI = 10, 227          # J-wave section of RESUME-FULL.md (1-based, inclusive)

def find_line(doc, anchor):
    lines = LINES[doc]
    lo, hi = (R_LO, R_HI) if doc == 'R' else (1, len(lines))
    for i in range(lo - 1, hi):
        if anchor in lines[i]:
            return i + 1
    return None

# ------------------------------------------------------------------ citations
# kind: eq (bytes at addr, ?? wildcards) | be32 | le32 | ascii | contains (within addr..addr+span)
#       | mono (non-decreasing run of N bytes) | na (not a located byte run; recorded, not checked)
C = []
def c(doc, anchor, addr, kind, exp, note='', span=16):
    C.append(dict(doc=doc, anchor=anchor, addr=addr, kind=kind, exp=exp, note=note, span=span))

# --- doc 69 (J1)
c('69', 'skipped by `40 2a` at `0x054D20`', 0x054D20, 'eq', '40 2a')
c('69', '`0x003282 fc 01`', 0x003282, 'eq', 'fc 01')
c('69', '`0x003294 fc 02`', 0x003294, 'eq', 'fc 02')
c('69', '`0x0032B8 fc 01`', 0x0032B8, 'eq', 'fc 01')
c('69', '| `0x00325E` | read', 0x00325E, 'eq', '6a 0b a9 e0', 'mov.b @0xa9e0:16,r3l encoding')
c('69', '| `0x003284` | write', 0x003284, 'eq', '6a 8c a9 e0', 'mov.b r4l,@0xa9e0:16 encoding')
c('69', '| `0x003296` | write', 0x003296, 'eq', '6a 8c a9 e0', 'mov.b r4l,@0xa9e0:16 encoding')
c('69', '| `0x0032BA` | write', 0x0032BA, 'eq', '6a 8c a9 e0', 'mov.b r4l,@0xa9e0:16 encoding')
c('69', 'after the `rte` at `0x054F38`', 0x054F38, 'eq', '56 70', 'rte')
c('69', 'boot RAM-clear loop (`0x002132`', 0x002132, 'contains', '00 fe e0 00', 'mov.l #0xFEE000 inside 0x002132-0x002150', span=0x1F)
c('69', '| `0x028C2A` | +0x14 | `0x028C3E`', 0x028C3E, 'be32', 0x02A924)
c('69', '| `0x028C2A` | +0x1C | `0x028C46`', 0x028C46, 'be32', 0x028C4A)
c('69', '| `0x028C8A` | +0x14 | `0x028C9E`', 0x028C9E, 'be32', 0x02A9F4)
c('69', '| `0x028C8A` | +0x1C | `0x028CA6`', 0x028CA6, 'be32', 0x028CAA)
c('69', '| `0x02A924` | 10 | `bsr 0x2A92E', 0x02A924, 'eq', '55 08 47 ?? 5e 02 9c 56 54 70', 'bsr .+8 = 0x2A92E; jsr @0x29C56; rts')
c('69', '| `0x02A9F4` | 10 | `bsr 0x2A9FE', 0x02A9F4, 'eq', '55 08 47 ?? 5e 02 9c 56 54 70', 'bsr .+8 = 0x2A9FE; jsr @0x29C56; rts')
c('69', '| `0x028C4A` | 16 | `jsr @0x2A92E', 0x028C4A, 'eq', '5e 02 a9 2e', 'jsr @0x2A92E at stub start')
c('69', '| `0x028C4A` | 16 | `jsr @0x2A92E', 0x028C4A, 'contains', '5e 01 a5 8c 54 70', 'jsr @0x1A58C; rts ending the 16-B stub', span=16)
c('69', '| `0x028CAA` | 18 | `jsr @0x2A9FE', 0x028CAA, 'eq', '5e 02 a9 fe', 'jsr @0x2A9FE at stub start')
c('69', '| `0x028CAA` | 18 | `jsr @0x2A9FE', 0x028CAA, 'contains', '5e 01 a5 8c 54 70', 'jsr @0x1A58C; rts ending the 18-B stub', span=18)
c('69', '`0x028D8C` (+0x14)', 0x028D8C, 'eq', '5d 60', 'jsr @er6')
c('69', '`0x028DA8` (+0x1C)', 0x028DA8, 'eq', '5d 60', 'jsr @er6')
# --- doc 70 (J2)
c('70', '`0x054FF8 = 78 b0 6b 26 00 05 50 02 59 60`', 0x054FF8, 'eq', '78 b0 6b 26 00 05 50 02 59 60')
c('70', '`0x028D24 = 01 00 6f 16 00 04`', 0x028D24, 'eq', '01 00 6f 16 00 04')
c('70', '04E2D6 7a 05 00 04 e3 1e', 0x04E2D6, 'eq', '7a 05 00 04 e3 1e')
c('70', '04E2DC 6a 0c bb e9', 0x04E2DC, 'eq', '6a 0c bb e9')
c('70', '04E2E0 7a 64 00 00 00 ff', 0x04E2E0, 'eq', '7a 64 00 00 00 ff')
c('70', '04E2E6 7a 06 00 ff b0 5a', 0x04E2E6, 'eq', '7a 06 00 ff b0 5a')
c('70', '04E31A 5e 05 27 80', 0x04E31A, 'eq', '5e 05 27 80')
c('70', '04E31C 54 70', 0x04E31C, 'eq', '54 70', 'rts')
c('70', 'Slot 68', 0x04ACF4, 'be32', 0x0004E2D6, '0x04ABE4 + 68*4')
c('70', 'Slot 69 (`0x04E32E`)', 0x04ACF8, 'be32', 0x0004E32E, '0x04ABE4 + 69*4')
c('70', '`0x05222A mov.l @(0x04ABE4:32,er3),er6`', 0x05222A, 'eq', '78 b0 6b 26 00 04 ab e4', 'd32 indexed load, base 0x04ABE4')
c('70', 'Site `0x052232` `jsr @er6`', 0x052232, 'eq', '5d 60', 'jsr @er6')
c('70', '97/163/183', 0x04AB70 + 97 * 4, 'be32', 0x0004E2D6, '0x04AB70 slot 97')
c('70', '97/163/183', 0x04AB70 + 163 * 4, 'be32', 0x0004E2D6, '0x04AB70 slot 163')
c('70', '97/163/183', 0x04AB70 + 183 * 4, 'be32', 0x0004E2D6, '0x04AB70 slot 183')
c('70', 'site `0x04AB6C`', 0x04AB6C, 'eq', '5d 60', 'jsr @er6')
c('70', 'Baro', 0x04E31E, 'contains', '42 61 72 6f', '"Baro" in 0x04E31E-0x04E32E', span=16)
c('70', 'Baro', 0x04E31E, 'contains', '2d 68 50 61', '"-hPa" in 0x04E31E-0x04E32E', span=16)
c('70', '`0x055000` `jmp @er6`', 0x055000, 'eq', '59 60', 'jmp @er6')
# --- doc 71 (J3)
c('71', '`0x028CBC 6b 04 bb c2`', 0x028CBC, 'eq', '6b 04 bb c2')
c('71', '| `0x026F3C` | `mov.w r4,@0xFFBBC2`', 0x026F3C, 'eq', '6b 84 bb c2', 'mov.w r4,@0xFFBBC2 encoding')
c('71', '| `0x026F4A` | `mov.w r3,@0xFFBBC2`', 0x026F4A, 'eq', '6b 83 bb c2', 'mov.w r3,@0xFFBBC2 encoding (lane table also cites these bytes at 026F4A)')
c('71', '| `0x026F6A` | `mov.w r4,@0xFFBBC2`', 0x026F6A, 'eq', '6b 84 bb c2', 'mov.w r4,@0xFFBBC2 encoding')
c('71', 'The dword `00 FF BB C2`', 0x006618, 'eq', '00 ff bb c2')
c('71', 'Char map `0x01BE32` read directly', 0x01BE32, 'eq', '00 ' + ' '.join('%02x' % x for x in range(0x61, 0x7B)), '00 then a..z')
# --- doc 72 (J4)
c('72', 'PROVEN `0x028C20: 7A 01 00 02 8C 2A`', 0x028C20, 'eq', '7a 01 00 02 8c 2a')
c('72', '= `0x028C3E` = `00 02 A9 24`', 0x028C3E, 'eq', '00 02 a9 24')
c('72', 'Body `55 08 47 04 5E 02 9C 56`', 0x02A924, 'eq', '55 08 47 04 5e 02 9c 56')
c('72', 'PROVEN `0x028C82: 7A 01 00 02 8C 8A`', 0x028C82, 'eq', '7a 01 00 02 8c 8a')
c('72', '= `0x028C9E` = `00 02 A9 F4`', 0x028C9E, 'eq', '00 02 a9 f4')
c('72', 'Same stub body', 0x02A9F4, 'eq', '55 08 47 04 5e 02 9c 56', '"same stub body" as 0x02A924')
c('72', 'Body `5E 06 5B 66`', 0x065EFA, 'eq', '5e 06 5b 66')
c('72', 'proven `0x065EF8 bra→0x65F30`', 0x065EF8, 'eq', '40 36', 'bra .+0x36 -> 0x065F30')
c('72', '(`… 00 06 5E FA …`)', 0x02B3C0, 'contains', '00 06 5e fa', 'table ~0x02B3C0', span=0x24)
c('72', 'Table entry `00 06 5F 00` at `0x02B3DC`', 0x02B3DC, 'eq', '00 06 5f 00')
c('72', 'Table entry `00 06 5F 06` at `0x02B3E0`', 0x02B3E0, 'eq', '00 06 5f 06')
c('72', '| `0x065F00` | 6 |', 0x065F00, 'eq', '5e 06 5b 86 40 ??', 'jsr @0x65B86; bra')
c('72', '| `0x065F06` | 4 |', 0x065F06, 'eq', '5e 06 5b a6', 'jsr @0x65BA6')
c('72', '`0x07691A → 0x076C0A`', 0x07691A, 'eq', '5e 07 6c 0a', 'jsr @0x076C0A')
c('72', '`0x076C34 → 0x076EF8`', 0x076C34, 'eq', '5e 07 6e f8', 'jsr @0x076EF8')
c('72', '`0x076C56 → 0x076FC4`', 0x076C56, 'eq', '5e 07 6f c4', 'jsr @0x076FC4')
c('72', '`0x07B4C4 → 0x0769AA`', 0x07B4C4, 'be32', 0x0769AA, 'byte re-read inside closed window (no decode)')
c('72', '`0x07B4CE → 0x0768C8`', 0x07B4CE, 'be32', 0x0768C8, 'byte re-read inside closed window (no decode)')
c('72', '`0x07B4D8 → 0x0769AA`', 0x07B4D8, 'be32', 0x0769AA, 'byte re-read inside closed window (no decode)')
c('72', '`0x07B4EC → 0x0768A8`', 0x07B4EC, 'be32', 0x0768A8, 'byte re-read inside closed window (no decode)')
c('72', '`0x0044DA` `"373839404142', 0x0044DA, 'ascii', b'373839404142')
c('72', '`0x008352` `" : TX', 0x008352, 'ascii', b' : TX   ')
c('72', '`0x045308` `"ESU FT1D', 0x045308, 'ascii', b'ESU FT1D\r\n')
c('72', '`0x0458D8` `"$GPWPL,0000."`', 0x0458D8, 'ascii', b'$GPWPL,0000.')
c('72', '`0x0455B8: 7A 05 00 04 58 D8`', 0x0455B8, 'eq', '7a 05 00 04 58 d8')
c('72', '`0x04E012` `"P-Rate"`', 0x04E012, 'ascii', b'P-Rate')
c('72', '`0x06796A` `"M01', 0x06796A, 'ascii', b'M01\xffM02\xff')
c('72', '`0x067446` `":', 0x067446, 'ascii', b':\xffSENT:\xffD/L ')
c('72', '`0x06B69C` `"SEND', 0x06B69C, 'ascii', b'SEND   \xffFORW')
c('72', '`0x00D22C` `"   . Hz"`', 0x00D22C, 'ascii', b'   . Hz')
c('72', '`0x03619E` `"iiiihhhhgggg"`', 0x03619E, 'ascii', b'iiiihhhhgggg')
c('72', '`0x0376C8` (`11 11 … 12 12`', 0x0376C8, 'eq', '11 11')
c('72', '`0x0376C8` (`11 11 … 12 12`', 0x0376C8, 'contains', '12 12', span=152)
c('72', '`0x0376C8` (`11 11 … 12 12`', 0x0376C8, 'mono', 152, 'descriptor "152 B monotonic": bytes are three concatenated ascending ramps (11..1a, 11..19, 0f..5b), not one monotonic run')
c('72', '`0x009B34` (`1C 1D 1E 1F 20`)', 0x009B34, 'eq', '1c 1d 1e 1f 20')
c('72', '`0x010B40` is a 4-byte `bra .-140`', 0x010B40, 'eq', '58 00 ff 74', 'bra disp16 = -0x8C (-140)')
c('72', 'BE24 value at `0x078570`', 0x078570, 'eq', '02 36 02', 'BE24 0x023602 (byte re-read inside closed window)')
c('72', '`0x06DBE0` (2 B, a lone `rts`)', 0x06DBE0, 'eq', '54 70')
c('72', '(`0x061C54`, `0x0669DA`)', 0x061C54, 'eq', '5e 06 db e0', 'abs24 jsr match')
c('72', '(`0x061C54`, `0x0669DA`)', 0x0669DA, 'eq', '5e 06 db e0', 'abs24 jsr match')
c('72', '`jsr` operand `5A` at `0x074342`', 0x074342, 'eq', '5a 03 6b 84', '"5A" opcode of the false abs24 match ->0x036B84, inside the immediate of mov.w #0x5A03')
c('72', 'target `1D 1D … 1E 1E`', 0x036B84, 'eq', '1d 1d')
c('72', 'BE32 match at `0x01CFD3`', 0x01CFD3, 'be32', 0x00014C6A)
c('72', 'crosses the `bra` at `0x01CFD2`', 0x01CFD2, 'eq', '58 00', 'bra disp16')
# --- doc 73 (J5)
c('73', '| `0x0393DC` | `r3l`', 0x0393DC, 'eq', '6a 8b 81 84', 'mov.b r3l,@0xFF8184')
c('73', '| `0x039462` | 1 |', 0x039460, 'eq', 'fc 01 6a 8c 81 84', 'mov.b #1,r4l; mov.b r4l,@0xFF8184 (store at 0x039462)')
c('73', '| `0x055496` | 1 |', 0x055494, 'eq', 'fc 01 6a 8c 81 84', 'mov.b #1,r4l; mov.b r4l,@0xFF8184 (store at 0x055496)')
c('73', '| `0x0557A4` | 1 |', 0x0557A2, 'eq', 'fc 01 6a 8c 81 84', 'mov.b #1,r4l; mov.b r4l,@0xFF8184 (store at 0x0557A4)')
c('73', '| `0x054C64` | `0x0100FFFF` long', 0x054C64, 'eq', '01 00 6b 84 81 84', 'mov.l er4,@0xFF8184 (form cited in Method)')
c('73', '| `0x054F1E` | `0x0100FFFF` long', 0x054F1E, 'eq', '01 00 6b 84 81 84', 'mov.l er4,@0xFF8184 (form cited in Method)')
c('73', '| `0x05601E` | `0x0100FFFF` long', 0x05601E, 'eq', '01 00 6b 84 81 84', 'mov.l er4,@0xFF8184 (form cited in Method)')
for a in (0x05520A, 0x055336, 0x0557D8):
    c('73', 'three push byte 0 to EPDR3', a, 'eq', '6a 0? 81 84', 'byte read of FF8184')
for a in (0x0551DA, 0x055306, 0x0557A8):
    c('73', 'three read the `FF8184/FF8185` word', a, 'eq', '6b 0? 81 84', 'word read of FF8184')
c('73', 'the known-dead block `0x054F4E`', 0x054F4E, 'eq', '6a 0? 81 84', 'byte read of FF8184')
c('73', 'dispatcher `sub_54FEC` (`0x054FEC`', 0x054FEC, 'eq', '6a 0? 81 83', 'read of FF8183')
c('73', 'the SETUP handler (`0x05512A`)', 0x05512A, 'eq', '6a 0? 81 83', 'read of FF8183')
c('73', 'the EP0-IN ZLP check (`0x054E30`)', 0x054E30, 'eq', '6a 0? 81 83', 'read of FF8183')
c('73', 'TRG = 0x40', 0x05523A, 'eq', 'fc 40', 'mov.b #0x40')
# --- doc 74 (J6)
c('74', '00fdfe  fc 14', 0x00FDFE, 'eq', 'fc 14')
c('74', '00fe00  6a 8c a9 ed', 0x00FE00, 'eq', '6a 8c a9 ed')
c('74', '`0x03839C` (`4f 1e 35 5d ff`)', 0x03839C, 'eq', '4f 1e 35 5d ff')
c('74', '05548e  fc 4f 6a 8c aa e0', 0x05548E, 'eq', 'fc 4f 6a 8c aa e0')
c('74', '05549c  fc 08 6a 8c 81 83', 0x05549C, 'eq', 'fc 08 6a 8c 81 83')
c('74', '03835e  6a 0a aa e0', 0x03835E, 'eq', '6a 0a aa e0')
c('74', '038674  fc 00 6a 8c aa e8', 0x038674, 'eq', 'fc 00 6a 8c aa e8')
c('74', '(also 0x038762)', 0x038760, 'contains', 'fc 00 6a 8c aa e8', 'FFAAE8 := 0 store at 0x038762', span=8)
c('74', '055520  6a 0c aa e8 46 f8', 0x055520, 'eq', '6a 0c aa e8 46 f8')
c('74', '`0x055520 = 6a 0c aa e8 46 f8`', 0x055520, 'eq', '6a 0c aa e8 46 f8')
c('74', '055526  fc 09', 0x055526, 'eq', 'fc 09')
c('74', '00fb9e  jsr sub_FDC8', 0x00FB9E, 'eq', '5e 00 fd c8', 'jsr @0x00FDC8')
c('74', '00fba2  mov.b @FFA9ED, r4l', 0x00FBA2, 'eq', '6a 0c a9 ed', 'mov.b @0xFFA9ED,r4l')
c('74', '06f640  mov.l #0x2E6A7067', 0x06F640, 'contains', '2e 6a 70 67', '".jpg"', span=8)
c('74', '06f5d0  btst #6,@FF8EA0', 0x06F5D0, 'eq', '6a 10 8e a0 73 60', 'btst #6,@0xFF8EA0')
c('74', 'viewer reset `sub_6FDD6` (`0x06FDF0`)', 0x06FDF0, 'eq', '6a 8? ba 32', 'store to FFBA32')
c('74', 'the shared remap at `0x00FBC8`', 0x00FBC8, 'contains', 'fb 09 18 bc', 'mov.b #9,r3l; sub.b r3l,r4l (the -9 remap)', span=24)
# --- doc 75 (J7)
for a, e in [(0x054C7C, 'fc 00'), (0x054C7E, '6a 8c ee 08'), (0x054C82, 'fc 07'), (0x054C84, '6a 8c ee 09'),
             (0x054C88, 'fc 1f'), (0x054C8A, '6a 8c ee 0a'), (0x054C8E, '00 00 00 00 00 00'), (0x054C94, 'fc 8d'),
             (0x054C96, '6a 8c ee 04'), (0x054CA6, '6a 18 ee 2d 70 20'), (0x054D1E, '46 2c'), (0x054D20, '40 2a')]:
    c('75', '%06x  %s' % (a, e.split()[0] + ' ' + e.split()[1]) if a != 0x054C8E else '054c8e  00 00', a, 'eq', e)
c('75', '054c9a  fc 03', 0x054C9A, 'eq', 'fc 03 6a 8c ee 05', 'IER1 = 3 (tail bytes per mnemonic)')
c('75', '054ca0  fc 18', 0x054CA0, 'eq', 'fc 18 6a 8c ee 06', 'IER2 = 0x18 (tail bytes per mnemonic)')
c('75', '054d22  fc 08 / 6a 8c ee 2f', 0x054D22, 'eq', 'fc 08 6a 8c ee 2f')
c('75', '054d24..054d44  15x nop', 0x054D28, 'eq', ' '.join(['00'] * 30), '15 nops; they occupy 0x054D28-0x054D45 (label in doc is 054d24..054d44)')
c('75', '054d46  fc 00 / 6a 8c ee 2f', 0x054D46, 'eq', 'fc 00 6a 8c ee 2f')
c('75', '| FFEE2E | 1 W', 0x054CCA, 'eq', '6a 8c ee 2e', 'store EE2E')
c('75', '| FFEE2F | 3 W', 0x054CD0, 'eq', '6a 8c ee 2f', 'store EE2F (init)')
c('75', '| FFEE2F | 3 W', 0x054D24, 'eq', '6a 8c ee 2f', 'store EE2F (dead)')
c('75', '| FFEE2F | 3 W', 0x054D48, 'eq', '6a 8c ee 2f', 'store EE2F (dead)')
c('75', '| FFEE44 | 1 W', 0x054CDC, 'eq', '6a 8c ee 44', 'store EE44')
c('75', '| FFEE50 | 3 W', 0x0022C0, 'eq', '6a 8? ee 50', 'store EE50 (boot)')
c('75', '| FFEE50 | 3 W', 0x002748, 'eq', '6a 8a ee 50', 'mov.b r2l,@EE50 (NMI)')
c('75', '| FFEE50 | 3 W', 0x0027FC, 'eq', '6a 8a ee 50', 'mov.b r2l,@EE50 (NMI)')
c('75', '| FFEE51 | 1 W', 0x0022BA, 'eq', '6a 8? ee 51', 'store EE51 (boot)')
c('75', '| FFEE53 | 1 W', 0x0446C4, 'eq', '6a 18 ee 53 70 10', 'bset #1,@0xFFEE53')
c('75', '055678  mov.w @0xFFBA6C,r5', 0x055678, 'eq', '6b 05 ba 6c', 'mov.w @0xFFBA6C,r5')
c('75', '05567e  add.l #0xFF5806,er5', 0x05567E, 'eq', '7a 15 00 ff 58 06', 'add.l #0xFF5806,er5')
c('75', '055684  mov.b @0xFFEE10,r4l', 0x055684, 'eq', '6a 0c ee 10')
c('75', '055688  mov.b r4l,@er5', 0x055688, 'eq', '68 dc')
c('75', '05568e  bne   055684', 0x05568E, 'eq', '46 f4', 'bne -> 0x055684')
c('75', '05569e  cmp.w #0x400,r5', 0x05569E, 'eq', '79 25 04 00')
c('75', '0556a2  bcs   loc_556C0', 0x0556A2, 'eq', '45 1c', 'bcs -> 0x0556C0')
# --- doc 76 (J8)
for a, e in [(0x002482, 'fc 21 6a 8c fe f0'), (0x002488, 'fc c0 6a 8c fe f1'), (0x00248E, 'fc 00 6a 8c fe f2'),
             (0x002494, 'fc 41 6a 8c fe f4'), (0x00249A, '79 04 00 00 6b 84 fe f6'), (0x0024A2, '79 04 4e 20 6b 84 fe f8'),
             (0x0024AA, 'fc 20 3c bc'), (0x0024AE, 'fc 00 3c bd')]:
    c('76', '%06X  %s' % (a, e[:5]), a, 'eq', e)
c('76', 'Vector 110 (file offset `0x1B8`, bytes `00 00 2a 30`)', 0x1B8, 'eq', '00 00 2a 30')
c('76', '0001B8  00 00 2a 30', 0x1B8, 'eq', '00 00 2a 30')
c('76', '002A32  6a 18 fe f5 72 00', 0x002A32, 'eq', '6a 18 fe f5 72 00')
c('76', '002A38  6a 0c 94 b8 47 06 1a 0c 6a 8c 94 b8', 0x002A38, 'eq', '6a 0c 94 b8 47 06 1a 0c 6a 8c 94 b8')
c('76', '002A5A  56 70', 0x002A5A, 'eq', '56 70', 'listed as "rts"; 56 70 encodes rte')
c('76', 'slot 66 (`0x108`) = `00 05 61', 0x108, 'eq', '00 05 61 c2')
c('76', '`0x0030B8: 5e 05 62 72', 0x0030B8, 'eq', '5e 05 62 72')
c('76', '0022F6  fc 00 3c f0', 0x0022F6, 'eq', 'fc 00 3c f0')
c('76', '0022FA  fc c0 3c f1', 0x0022FA, 'eq', 'fc c0 3c f1')
c('76', '002304  fc 40 3c f4', 0x002304, 'eq', 'fc 40 3c f4')
for a, e in [(0x05B8A0, '7e bc 73 30'), (0x05B8A4, '47 20'), (0x05B8A6, '2c f5'), (0x05B8A8, '6b 0c ff f6'),
             (0x05B8AC, '79 2c 89 80'), (0x05B8B0, '44 06'), (0x05B8B2, '73 4c')]:
    c('76', '%06X  %s' % (a, e), a, 'eq', e)
for a in (0x056776, 0x056826, 0x056950):
    c('76', '056776 / 056826 / 056950   79 04 00 00  3c f0  6b 84 ff f6', a, 'eq', '79 04 00 00 3c f0 6b 84 ff f6', 'restart write')
c('76', 'The store `6a 8c fe f0` (TCR5)', 0x002484, 'eq', '6a 8c fe f0')
c('76', '`79 04 4e 20` (TGRA = 20000)', 0x0024A2, 'eq', '79 04 4e 20')
c('76', '`SCKCR 0xFFFDC4 = 0x0111` at `0x0020FC`', 0x0020FC, 'eq', '79 0? 01 11 6b 8? fd c4', 'mov.w #0x0111; mov.w ->@0xFFFDC4')
# guard-sites.tsv rows are checked further below (table-backed citations of doc 76 Findings 4)
# --- doc 77 (J9)
c('77', '`39 2a 2a 00 28 04 30 60 3f 6f 19 19`', 0x00F9A8, 'eq', '39 2a 2a 00 28 04 30 60 3f 6f 19 19')
c('77', '0x034984  btst #3, @0x4D:8', 0x034984, 'eq', '7e 4d 73 30', 'btst #3,@0xFFFF4D:8')
c('77', '0x034A6A  jsr  sub_35872', 0x034A6A, 'eq', '5e 03 58 72')
c('77', '0x03497C  mov.b @0xFF956D', 0x03497C, 'eq', '6a 0? 95 6d')
c('77', '`sub_5A2F8` (`0x0359C8`)', 0x0359C8, 'eq', '5e 05 a2 f8', 'jsr @0x05A2F8')
c('77', '`sub_5A28A` (`0x0359A8`)', 0x0359A8, 'eq', '5e 05 a2 8a', 'jsr @0x05A28A')
c('77', '`sub_5A1BE` (`0x03596A`)', 0x03596A, 'eq', '5e 05 a1 be', 'jsr @0x05A1BE')
c('77', '(`0x0358CA`/`0x0358D4`)', 0x0358CA, 'eq', '6a 10 b0 cc', 'bit test on B0CC')
c('77', '(`0x0358CA`/`0x0358D4`)', 0x0358D4, 'eq', '6a 10 aa d4', 'bit test on AAD4')
c('77', 'forced to 2 (`0x03594C`)', 0x03594C, 'eq', 'fc 02 6a 8c b0 c7', 'mov.b #2 -> @B0C7')
c('77', 'giving `0x0B` (DT2) at `0x05A224`', 0x05A224, 'contains', 'fc 0b', '0x0B immediate in 0x05A224..+12', span=12)
c('77', '| `B0CC.b0` set | `0x15` (table `05C40A`, `1C 03`)', 0x05C40A, 'na', '1c 03',
  '05C40A holds BE32 step pointers (0x05B4E4, 0x05B522, ...); "1C 03" is opcode notation, not a byte run at this address')
# --- doc 78 (J10, SUB)
c('78', '`FFF13DEC 3e 01 00`', 0xFFF13DEC, 'eq', '3e 01 00')
c('78', '`FFF13EE8 2a 19` bgt.b `FFF13F01`', 0xFFF13EE8, 'eq', '2a 19', 'bgt.b +0x19 -> FFF13F01')
c('78', '`FFF13EFF 2e 17` bra.b `FFF13F16`', 0xFFF13EFF, 'eq', '2e 17', 'bra.b +0x17 -> FFF13F16')
c('78', '`FFEF05E9 2e 53` bra.b `FFEF063C`', 0xFFEF05E9, 'eq', '2e 53', 'bra.b +0x53 -> FFEF063C')
c('78', '`FFF2A6F7 39 14 00` bsr.w', 0xFFF2A6F7, 'eq', '39 14 00', 'bsr.w +0x14 -> FFF2A70B')
c('78', '`FFEDC459 fb e2 44 2d 01 00`', 0xFFEDC459, 'eq', 'fb e2 44 2d 01 00')
c('78', '`fa e5 7c 4f 00` mov.w #0,9EF8h[r14]', 0xFFEDC45F, 'eq', 'fa e5 7c 4f 00', 'immediately after the mov.l')
c('78', '(`f0 e1` bset #1,[r14].b', 0xFFF3753A, 'contains', 'f0 e1', 'FFF3753A family body', span=0x60)
c('78', '`#0x83812` (mov.w #0', 0xFFF3753A, 'contains', 'fb ee 12 38 08', 'imm24 0x083812 -> r14', span=0x60)
c('78', '`#0x8C100` (`f0 e1`', 0xFFF3753A, 'contains', 'fb ee 00 c1 08', 'imm24 0x08C100 -> r14', span=0x60)
c('78', '`#0x80004` with `mov.w #0xA503,3FAh[r14]`', 0xFFF3753A, 'contains', 'fb ee 04 00 08', 'imm24 0x080004 -> r14', span=0x60)
c('78', '`#0x80004` with `mov.w #0xA503,3FAh[r14]`', 0xFFF3753A, 'contains', 'fa e9 fd 01 03 a5', 'mov.w #0xA503,3FAh[r14]', span=0x60)
# --- doc 79 (J11, SUB)
c('79', '`0x0080003F`, `0x00FF003F`', 0xFFED7F60, 'le32', 0x0080003F, 'geometry record 0 field 0')
c('79', '`0x0080003F`, `0x00FF003F`', 0xFFED7F8C, 'le32', 0x00FF003F, 'geometry record 1 field 0')
c('79', '`if (value <= 0x7DFFFF)', 0xFFF362F7, 'contains', 'ff ff 7d', 'imm 0x7DFFFF in FFF362F7-FFF3631D', span=0x27)
c('79', '`if (value <= 0x7DFFFF)', 0xFFF362F7, 'contains', 'fb e2 60 7f ed ff', 'mov.l #FFED7F60', span=0x27)
# --- doc 80 (J12)
c('80', 'table `0xCE40` = `02 03 04 05 06 07', 0x00CE40, 'eq', '02 03 04 05 06 07 08 09 01 0f 00')
c('80', 'save stub at `0x1935E` is unreachable', 0x01935E, 'eq', '79 01 00 aa 5a', 'stub start for n=0xAA')
c('80', '`0x192A8` (`mov.w #0x17,r1; jmp sub_3CCBC`)', 0x0192A8, 'eq', '79 01 00 17 5a 03 cc bc')
c('80', '`0x192A0` (`n=0x16`)', 0x0192A0, 'eq', '79 01 00 16 5a', 'mov.w #0x16,r1; jmp')
c('80', '`0x19352` (`n=0xA9`)', 0x019352, 'eq', '79 01 00 a9 5a', 'mov.w #0xA9,r1; jmp')
c('80', '`0x1935A` (`n=0xAA`)', 0x01935A, 'eq', '79 01 00 aa 5a', 'mov.w #0xAA,r1; jmp')
c('80', 'factory-default store at `0x0E678`', 0x00E678, 'eq', '6a 8? 89 ca', 'store to FF89CA')
# --- doc 81 (J13) -- its own cited runs
for a, e, anc in [(0x055684, '6a 0c ee 10', '0x055684 `6a 0c ee 10`'), (0x0554A4, '7a 04 00 ff 58 06', '0x0554A4 `7a 04 00 ff 58 06`'),
                  (0x054C1C, '24 28 80 00 02', '`24 28 80 00 02` (I12)'), (0x056B58, '6a 0b b1 02', '0x056B58 `6a 0b b1 02`'),
                  (0x05F4B0, '7a 04 00 ff 50 06', '0x05F4B0 `7a 04 00 ff 50 06`'), (0x028D0C, '01 00 6f 16 00 00 5d 60', '0x028D0C'),
                  (0x00326A, '01 00 6f 36 32 72 59 60', '0x00326A'), (0x003272, '00 00 32 7e 00 00 32 8a 00 00 32 9c', 'table 0x003272'),
                  (0xFFED7990, '5b f0 f0 ff', '0xFFED7990'), (0xFFF0F05B, '60 40 60 40 f8 05', '0xFFF0F05B'),
                  (0xFFEDFFFD, 'fb e2 d4 cd 01 00', '0xFFEDFFFD'), (0x0178F0, '7a 01 00 01 a0 84', 'holds `7a 01 00 01 a0 84`'),
                  (0x015224, '5d 10', '**0x015224**'), (0x05567E, '7a 15 00 ff 58 06', 'base 0x05567E'),
                  (0x055520, '6a 0c aa e8 46 f8', '0x055520\n')]:
    c('81', anc if not anc.endswith('\n') else '0x055520', a, 'eq', e)
c('81', '("Connected\\0")', 0xFFF4A4E6, 'ascii', b'Connected\x00')
for a, v in [(0x028C2A + 0x14, 0x02A924), (0x028C2A + 0x18, 0x03FFA0), (0x028C2A + 0x1C, 0x028C4A),
             (0x028C8A + 0x14, 0x02A9F4), (0x028C8A + 0x18, 0x03FFA0), (0x028C8A + 0x1C, 0x028CAA)]:
    c('81', 'I15 record fields confirm byte-exact', a, 'be32', v)
# --- doc 82 (J14)
for a, e, anc in [(0x3BDB4, '6a 18 fb a4 70 00', '`0x3BDB4` `6a 18 fb a4 70 00`'),
                  (0x3BDCE, '6a 18 fb a4 70 10', '`0x3BDCE` `bset #1,@0xFFFBA4`'),
                  (0x3BDE8, '6a 18 fb a4 72 00', '`0x3BDE8` `bclr #0`'),
                  (0x3BE02, '6a 18 fb a4 72 10', '`0x3BE02` `bclr #1`'),
                  (0x3BE4E, '6a 10 fb a0', '`0x3BE4E` `6a 10 fb a0`'), (0x3BE84, '6a 8a fb a8', '`0x3BE84` `6a 8a fb a8`'),
                  (0x3C3E2, '6a 18 fb a4 67 00', '`0x3C3E2` `6a 18 fb a4 67 00`'), (0x3C3AC, 'fd a2', '`0x3C3AC` `fd a2`'),
                  (0x3BE1C, 'fd a3', '`0x3BE1C` `fd a3`'), (0x33536, '7f 5c 72 70', '`0x33536` `7f 5c 72 70`'),
                  (0x335BC, '7f 5c 70 70', '`0x335BC` `7f 5c 70 70`'), (0x33554, '7f 5a 67 00', '`0x33554` `7f 5a 67 00`'),
                  (0x335A4, '7e 4a 77 00', '`0x335A4` `7e 4a 77 00`'), (0x33580, '6a 8c fb 8a', '(`0x33580`/`0x335D0` `6a 8c fb 8a`)'),
                  (0x335D0, '6a 8c fb 8a', '(`0x33580`/`0x335D0` `6a 8c fb 8a`)'), (0x335B8, '6b 83 bc 68', '`0x335B8` `mov.w r3,@0xFFBC68`'),
                  (0x77DB2, '5e 03 35 32', '`0x77DB2` `5e 03 35 32`'), (0x77DF6, '5e 03 35 32', '`0x77DF6` `5e 03 35 32`'),
                  (0x3C996, '58 60', '`0x3C996` `bne sub_3C668:16`')]:
    c('82', anc, a, 'eq', e)
for a, e in [(0x05E96A, '6a 04 8d d8'), (0x05E96E, '6a 0c 8d d9'), (0x05E972, '0d 4c'), (0x05E974, '6a 10 8e a0 73 60'),
             (0x05E97A, '47 0a'), (0x05E97C, '6a 04 8e d8'), (0x05E980, '6a 0c 8e d9'), (0x05E984, '40 08'),
             (0x05E986, '6a 04 8e d6'), (0x05E98A, '6a 0c 8e d7'), (0x05E98E, '01 00 6b 84 b0 5a'), (0x05E994, '79 0b f3 65'),
             (0x05E998, '5e 00 99 22')]:
    c('82', '%06X %s' % (a, e), a, 'eq', e)
c('82', '`.long sub_5E96A` at `0x007910`', 0x007910, 'be32', 0x0005E96A)
# --- RESUME-FULL.md, J-wave section
c('R', 'Vector 110 @ file `0x1B8` =', 0x1B8, 'eq', '00 00 2a 30', 'bytes continue on next line')
c('R', 'device bytes `fd a2`/`fd a3`', 0x3C3AC, 'eq', 'fd a2', 'address from doc 82')
c('R', 'device bytes `fd a2`/`fd a3`', 0x3BE1C, 'eq', 'fd a3', 'address from doc 82')
c('R', 'Confirmed reachable via `jsr @er6` at `0x052232`', 0x052232, 'eq', '5d 60')
c('R', '`final3_proven` 0/72, `rts` at `0x04E31C`', 0x04E31C, 'eq', '54 70')
c('R', 'slot 68 of table `0x04ABE4`', 0x04ABE4 + 68 * 4, 'be32', 0x0004E2D6)
c('R', '(`0x14−9` remap at `0x00FBC8`)', 0x00FBC8, 'contains', 'fb 09 18 bc', span=24)
c('R', '(vendor `41 D3` →', 0x00FDFE, 'eq', 'fc 14', 'the only injector')
c('R', 'TGRA `0x4E20`', 0x0024A2, 'eq', '79 04 4e 20')
c('R', 'TCR `0x21`', 0x002482, 'eq', 'fc 21 6a 8c fe f0')

# ------------------------------------------------------------------ evaluate citations
rows = []
def evaluate(ci):
    a, k, e = ci['addr'], ci['kind'], ci['exp']
    line = find_line(ci['doc'], ci['anchor'])
    note = ci['note']
    if k == 'na':
        return line, '%X' % a, e, hx(rd(a, 8)), 'N/A', note
    if k in ('eq',):
        n = len(e.split())
        act = rd(a, n)
        rx = pat(e)
        if rx.fullmatch(act):
            return line, '%X' % a, e, hx(act), 'PASS', note
        # search nearby (+-8) for the exact run -> address-offset discrepancy
        for d in sorted(range(-8, 9), key=abs):
            if d and rx.fullmatch(rd(a + d, n)):
                return line, '%X' % a, e, hx(act), 'FAIL-OFFSET', (note + '; ' if note else '') + 'run found at %X (delta %+d)' % (a + d, d)
        return line, '%X' % a, e, hx(act), 'FAIL', note
    if k in ('be32', 'le32'):
        act = rd(a, 4)
        v = struct.unpack('>I' if k == 'be32' else '<I', act)[0]
        return line, '%X' % a, '%s 0x%08X' % (k, e), hx(act), 'PASS' if v == e else 'FAIL', note
    if k == 'ascii':
        act = rd(a, len(e))
        return line, '%X' % a, repr(e)[2:-1], repr(act)[2:-1], 'PASS' if act == e else 'FAIL', note
    if k == 'contains':
        win = rd(a, ci['span'])
        m = pat(e).search(win)
        return line, '%X' % a, '%s within +0x%X' % (e, ci['span']), (('found at %X: ' % (a + m.start())) + hx(m.group(0))) if m else hx(win[:16]) + '..', 'PASS' if m else 'FAIL', note
    if k == 'mono':
        b = rd(a, e)
        ok = all(b[i] <= b[i + 1] for i in range(len(b) - 1))
        return line, '%X' % a, 'non-decreasing over %d B' % e, '%s .. %s' % (hx(b[:4]), hx(b[-4:])), 'PASS' if ok else 'FAIL', note
    raise ValueError(k)

for ci in C:
    if ci is None:
        continue
    line, addr, exp, act, res, note = evaluate(ci)
    rows.append((DOCFILES[ci['doc']], line if line else 'ANCHOR-NOT-FOUND', addr, exp, act, res, ci['kind'], note))

# doc 76 guard-sites.tsv: every row's bytes at its site
for r in csv.DictReader(open(P(r'ida\out\dsp-tick\guard-sites.tsv'), encoding='utf-8'), delimiter='\t'):
    a = int(r['site'], 16)
    act = rd(a, 4)
    rows.append((DOCFILES['76'], find_line('76', 'All nine `0x8980` compares'), '%X' % a, r['bytes'], hx(act),
                 'PASS' if hx(act) == r['bytes'] else 'FAIL', 'eq', 'guard-sites.tsv row (doc 76 Findings 4)'))
C.clear()

# ------------------------------------------------------------------ table-structure citations (computed)
def lut(addr):
    n = struct.unpack('>H', M[addr:addr + 2])[0]
    z = []
    for i in range(n):
        o = addr + 2 + 10 * i
        lo, hi, v = struct.unpack('>IIH', M[o:o + 10])
        z.append((lo >> 16, lo & 0xFFFF, hi >> 16, hi & 0xFFFF, v))
    return z
l1 = lut(0x028452)
rows.append((DOCFILES['71'], find_line('71', 'LUT @0x028452'), '28452', 'n=5; X 0..319; Y [31,59][61,89][91,119][121,149][151,179]; idx 1..5',
             'n=%d; X %s; Y %s; idx %s' % (len(l1), sorted({(x0, x1) for x0, y0, x1, y1, v in l1}), [(y0, y1) for x0, y0, x1, y1, v in l1], [v for *_, v in l1]),
             'PASS' if (len(l1) == 5 and all((x0, x1) == (0, 319) for x0, y0, x1, y1, v in l1)
                        and [(y0, y1) for x0, y0, x1, y1, v in l1] == [(31, 59), (61, 89), (91, 119), (121, 149), (151, 179)]
                        and [v for *_, v in l1] == [1, 2, 3, 4, 5]) else 'FAIL', 'lut', 'zone table decode'))
l2 = lut(0x02706C)
rows.append((DOCFILES['71'], find_line('71', '`LUT @0x02706C`'), '2706C', 'n=4; Y [128,180]; X [14,64][94,144][174,224][254,304]; idx 10..13',
             'n=%d; Y %s; X %s; idx %s' % (len(l2), sorted({(y0, y1) for x0, y0, x1, y1, v in l2}), [(x0, x1) for x0, y0, x1, y1, v in l2], [v for *_, v in l2]),
             'PASS' if (len(l2) == 4 and all((y0, y1) == (128, 180) for x0, y0, x1, y1, v in l2)
                        and [(x0, x1) for x0, y0, x1, y1, v in l2] == [(14, 64), (94, 144), (174, 224), (254, 304)]
                        and [v for *_, v in l2] == [10, 11, 12, 13]) else 'FAIL', 'lut', 'zone table decode'))
l3 = lut(0x027274)
idx3 = sorted(v for *_, v in l3)
rows.append((DOCFILES['71'], find_line('71', '`LUT @0x027274`'), '27274', 'n=19; indices 30..45 plus 3 [others]', 'n=%d; idx %s' % (len(l3), idx3),
             'PASS' if len(l3) == 19 and set(range(30, 46)) <= set(idx3) and len(set(idx3) - set(range(30, 46))) == 3 else 'FAIL', 'lut', 'zone table decode; "plus 3" read as three further zones (indices 3/4/5)'))
nine = [0x028452, 0x02839A, 0x02843C, 0x02704C, 0x02706C, 0x027096, 0x0271E6, 0x027274, 0x0270CA]
allz = [z for a in nine for z in lut(a)]
mx, my = max(z[2] for z in allz), max(z[3] for z in allz)
miny = min(z[1] for z in allz)
rows.append((DOCFILES['71'], find_line('71', 'carry `X` up to `0x013F`'), 'nine LUTs', 'max X 0x13F (319), max Y 0xEE (238)',
             'max X 0x%X, max Y 0x%X, min Y 0x%X, %d zones' % (mx, my, miny, len(allz)), 'PASS' if (mx, my) == (0x13F, 0xEE) else 'FAIL', 'lut', 'all nine zone tables'))

# doc 79 SUB record tables
def s32(a): return struct.unpack('<I', rd(a, 4))[0]
def s16(a): return struct.unpack('<H', rd(a, 2))[0]
kinds = {}
inrange = 0
for i in range(254):
    a = 0xFFED55E0 + 28 * i
    kd = s32(a + 8)
    kinds[kd] = kinds.get(kd, 0) + 1
    if kd == 2 and 0xFFECE55C <= s32(a + 0x18) < 0xFFED3F6C:
        inrange += 1
rows.append((DOCFILES['79'], find_line('79', 'All 223 populated records carry'), 'FFED55E0', '223 kind=2 (bmp_desc in FFECE55C-FFED3F6C); 30 kind=0; 1 stray',
             'kind histogram %s; kind=2 with desc in range %d' % (dict(sorted(kinds.items())), inrange),
             'PASS' if kinds.get(2) == 223 and inrange == 223 and kinds.get(0) == 30 and sum(kinds.values()) == 254 else 'FAIL', 'table', '254 x 28 B icon records'))
fb = [rd(0xFFED4644 + 12 * i, 12) for i in range(26)]
bcodes = [struct.unpack('<H', b[2:4])[0] for b in fb]
ok = fb[8] == fb[2] and all(x == 0x20 for x in bcodes[9:26]) and {0x2121, 0x5021, 0x9321} <= set(bcodes[:8])
rows.append((DOCFILES['79'], find_line('79', 'block 8 duplicates block 2'), 'FFED4644', 'block8==block2; blocks 9-25 base 0x0020; blocks 0-7 incl 0x2121/0x5021/0x9321',
             'base codes 0-8: %s; 9-25 all 0x20: %s; b8==b2: %s' % ([hex(x) for x in bcodes[:9]], all(x == 0x20 for x in bcodes[9:]), fb[8] == fb[2]),
             'PASS' if ok else 'FAIL', 'table', '26 x 12 B font blocks; prose descriptor only: block 3 is 7x14 base 0x0020, blocks 11/18 have base 0x0023/0x002E (lane font_blocks.tsv agrees with image)'))
g8 = [(s16(0xFFED49E0 + 8 * i), s16(0xFFED49E0 + 8 * i + 2)) for i in range(45)]
rows.append((DOCFILES['79'], find_line('79', '`base_code` (+0, ascending JIS'), 'FFED49E0', 'first base_code 0x2422; +2 always 0; ascending',
             'first 0x%X; rsvd all 0: %s; ascending: %s' % (g8[0][0], all(r == 0 for _, r in g8), all(g8[i][0] <= g8[i + 1][0] for i in range(44))),
             'PASS' if g8[0][0] == 0x2422 and all(r == 0 for _, r in g8) and all(g8[i][0] <= g8[i + 1][0] for i in range(44)) else 'FAIL', 'table', '45 x 8 B glyph_tbl8'))
f7 = [s32(0xFFED7F60 + 44 * i + 28) for i in range(13)]
rows.append((DOCFILES['79'], find_line('79', 'field 7 = 1 for records 2–12'), 'FFED7F60', 'field 7 == 1 for records 2..12',
             'field7 = %s' % f7, 'PASS' if all(x == 1 for x in f7[2:]) else 'FAIL', 'table', '13 x 44 B geometry records'))

# doc 80: exit table 0x19A9E (206 BE16, handler 0x148A0+val)
vals = [struct.unpack('>H', M[0x19A9E + 2 * i:0x19A9E + 2 * i + 2])[0] for i in range(206)]
tg = [0x148A0 + v for v in vals]
dead = {0x192A0, 0x192A8, 0x19352, 0x1935A}
rows.append((DOCFILES['80'], find_line('80', 'are **not** targets of any exit'), '19A9E', 'no exit slot targets 0x192A0/0x192A8/0x19352/0x1935A',
             'hits=%s' % [hex(x) for x in tg if x in dead], 'PASS' if not any(x in dead for x in tg) else 'FAIL', 'table', '206 BE16 exit offsets'))
i29, i2b0 = tg.index(0x19290), tg.index(0x192B0)
between = [hex(x) for x in tg if 0x19290 < x < 0x192B0]
rows.append((DOCFILES['80'], find_line('80', 'id `0x2B`→`0x19290`'), '19A9E', 'id 0x2B->0x19290 then id 0x3E->0x192B0, nothing in between',
             'index 0x%X->0x19290, index 0x%X->0x192B0 (index+0x0E = 0x%X/0x%X); targets strictly between: %s' % (i29, i2b0, i29 + 0x0E, i2b0 + 0x0E, between),
             'PASS' if not between else 'FAIL', 'table', 'id numbering = table index + 0x0E (bias not independently verified)'))

# ------------------------------------------------------------------ write citations.tsv
with open(os.path.join(OUT, 'citations.tsv'), 'w', encoding='utf-8', newline='') as f:
    f.write('source_doc\tline\taddress\texpected\tactual\tpass\tkind\tnote\n')
    for r in rows:
        f.write('\t'.join(str(x).replace('\t', ' ').replace('\n', ' ') for x in r) + '\n')

# ------------------------------------------------------------------ counts / ledger
K = []
def k(item, value, expect, ok=None, note=''):
    if ok is None:
        ok = value == expect
    K.append((item, value, expect, 'PASS' if ok else 'FAIL', note))

sha_m = hashlib.sha256(M).hexdigest(); sha_s = hashlib.sha256(S).hexdigest()
k('sha256 MAIN', sha_m, '8e3ecd05409b2c314ebed77320ece5930bf31c8333cd84aeef4f6b0264c1bcce')
k('sha256 SUB', sha_s, 'b93570b3c2f69ccb51c113c893b4bc4c414cf78ceddde478748404e0768c6230')
k('MAIN size', len(M), 1048576); k('SUB size', len(S), 4194304)

def mask(p):
    b = open(P(p), 'rb').read()
    return b
f3p = mask(r'ida\out\main-final3\final3_proven_mask.bin')
f3n = mask(r'ida\out\main-final3\final3_named_mask.bin')
f2p = mask(r'ida\out\main-final2\final2_proven_mask.bin')
pc = lambda b, lo=0, hi=None: sum(1 for x in b[lo:hi] if x)
k('final3_proven_mask length', len(f3p), CONTENT)
k('final3_proven_mask values', sorted(set(f3p)), [0, 1])
k('final3_proven popcount (MAIN_FINAL3 proven)', pc(f3p), 368366)
k('final3_named popcount (MAIN named)', pc(f3n), 497314)
k('final2_proven popcount', pc(f2p), 368432)
k('|final3 \\ final2|  (I15 +54)', sum(1 for a, b in zip(f3p, f2p) if a and not b), 54)
k('|final2 \\ final3|  (I12 -120)', sum(1 for a, b in zip(f3p, f2p) if b and not a), 120)
k('I12 block 0x054D22-0x054D4B in final3_proven', pc(f3p, 0x054D22, 0x054D4C), 0, note='42 B block')
k('I12 block 0x054F3A-0x054F87 in final3_proven', pc(f3p, 0x054F3A, 0x054F88), 0, note='78 B block')
k('I12 block 0x054D22-0x054D4B in final2_proven', pc(f2p, 0x054D22, 0x054D4C), 42)
k('I12 block 0x054F3A-0x054F87 in final2_proven', pc(f2p, 0x054F3A, 0x054F88), 78)
k('final2 \\ final3 == the two I12 blocks', {i for i in range(CONTENT) if f2p[i] and not f3p[i]} == set(range(0x054D22, 0x054D4C)) | set(range(0x054F3A, 0x054F88)), True)
runs = list(csv.DictReader(open(P(r'ida\out\main-final3\final3_proven_runs.tsv'), encoding='utf-8'), delimiter='\t'))
k('final3_proven_runs.tsv rows', len(runs), 928); k('final3_proven_runs.tsv sum(len)', sum(int(r['len']) for r in runs), 368366)
J2 = (0x04E2D6, 0x04E31E)
k('J2 range length 0x04E2D6-0x04E31D', J2[1] - J2[0], 72)
k('J2 range in final3_proven', pc(f3p, *J2), 0)
k('J2 range in final2_proven', pc(f2p, *J2), 0)
k('J2 range already in final3_named', pc(f3n, *J2), 2, note='so +70 named')
k('J2 named increment', (J2[1] - J2[0]) - pc(f3n, *J2), 70)
k('J2 rts at 0x04E31C', hx(M[0x04E31C:0x04E31E]), '54 70')
k('J2 slot 68 of 0x04ABE4 (0x04ACF4) BE32', '%08X' % struct.unpack('>I', M[0x04ACF4:0x04ACF8])[0], '0004E2D6')
k('J2 0x04ABE4 + 68*4', '%06X' % (0x04ABE4 + 68 * 4), '04ACF4')
k('J2 jsr @er6 at 0x052232', hx(M[0x052232:0x052234]), '5d 60')
k('J2 load at 0x05222A uses base 0x04ABE4', hx(M[0x05222E:0x052232]), '00 04 ab e4')
J4 = [(0x065EFA, 6), (0x065F00, 6), (0x065F06, 4)]
k('J4 +16 Inferred bytes', sum(n for _, n in J4), 16)
k('J4 +16 in final3_proven', sum(pc(f3p, a, a + n) for a, n in J4), 0, note='not credited')
k('J4 0x02A924/0x02A9F4 already in final3_proven (I15 +54)', pc(f3p, 0x02A924, 0x02A92E) + pc(f3p, 0x02A9F4, 0x02A9FE), 20, note='rediscovery, not new')
MP = pc(f3p) + 72; MN = pc(f3n) + 70
k('MAIN proven 368,366 + 72', MP, 368438)
k('MAIN named 497,314 + 70', MN, 497384)
k('MAIN proven + J4 Inferred (not credited)', MP + 16, 368454, note='informational')
sub_paths = sorted(glob.glob(P(r'ida\out\sub-final2\raw\mask_final2_headline_w2.bin'))) + sorted(glob.glob(P(r'ida\out\sub-final\raw\*headline_w2*.bin')))
SUBW = None
for sp in sub_paths:
    b = open(sp, 'rb').read()
    v = pc(b)
    k('SUB headline+w2 popcount %s' % os.path.relpath(sp, ROOT), v, 464263)
    k('SUB mask length %s' % os.path.relpath(sp, ROOT), len(b), 524288)
    SUBW = SUBW or v
TOT = 505684 + 524288
k('denominator 505,684 + 524,288', TOT, 1029972)
k('content end 0x7B754', CONTENT, 505684)
k('headline numerator 497,384 + 464,263', MN + SUBW, 961647)
k('headline numerator = I-wave 961,577 + 70', 961577 + 70, 961647)
k('headline % (2 dp)', '%.2f' % (100 * (MN + SUBW) / TOT), '93.37', note='%.4f%%' % (100 * (MN + SUBW) / TOT))
k('MAIN named % of 505,684', '%.2f' % (100 * MN / 505684), '98.36', note='%.4f%%' % (100 * MN / 505684))
k('MAIN proven % of content', '%.2f' % (100 * MP / 505684), '72.86', note='%.4f%%' % (100 * MP / 505684))
k('MAIN proven % of 388,490 decodable', '%.2f' % (100 * MP / 388490), '94.84', note='%.4f%%' % (100 * MP / 388490))
k('SUB window % of 524,288', '%.2f' % (100 * SUBW / 524288), '88.55', note='%.4f%%' % (100 * SUBW / 524288))
k('SUB code+typed % (520,552)', '%.2f' % (100 * 520552 / 524288), '99.29', note='%.4f%%' % (100 * 520552 / 524288))
# doc 69 arithmetic
k('doc69 one-descent union 365570+1544+116+66+1136+54', 365570 + 1544 + 116 + 66 + 1136 + 54, 368486)
k('doc69 368,486 - 120', 368486 - 120, 368366)
k('doc69 named 497139+141+34', 497139 + 141 + 34, 497314); k('doc69 named 497280+34', 497280 + 34, 497314)
k('doc69 72.845% of 505,684', '%.3f' % (100 * 368366 / 505684), '72.845')
k('doc69 94.82% of 388,490', '%.2f' % (100 * 368366 / 388490), '94.82')
k('doc69 build: 16+18 code bytes', 16 + 18, 34); k('doc69 build: 5+6 heads', 5 + 6, 11)
k('doc69 I12 blocks 42+78', 42 + 78, 120)
k('doc69 no ff a9 e0 in content', len(pat('ff a9 e0').findall(M[:CONTENT])), 0)
# doc 70
k('doc70 368,432 + 72', 368432 + 72, 368504)
ds = list(csv.DictReader(open(P(r'ida\out\dern-dispatch\sites.tsv'), encoding='utf-8'), delimiter='\t'))
k('doc70 sites.tsv rows', len(ds), 188); k('doc70 sites reached Y', sum(r['reached'] == 'Y' for r in ds), 174)
k('doc70 sites reached N', sum(r['reached'] == 'N' for r in ds), 14); k('doc70 distinct roots', len({r['root'] for r in ds}), 173)
k('doc70 d32 sites', sum(r['form'] == 'd32' for r in ds), 178); k('doc70 d16 sites', sum(r['form'] == 'd16' for r in ds), 10)
k('doc70 I8 split 166+7+1', 166 + 7 + 1, 174)
fam = list(csv.DictReader(open(P(r'ida\out\dern-dispatch\families.tsv'), encoding='utf-8'), delimiter='\t'))
k('doc70 families.tsv rows', len(fam), 173)
k('doc70 new targets (sum n_new over families)', sum(int(r['n_new']) for r in fam), 1)
# doc 71
k('doc71 "bb c2" occurrences, whole image', len(pat('bb c2').findall(M)), 88)
k('doc71 "bb c3" occurrences, whole image', len(pat('bb c3').findall(M)), 0)
k('doc71 stores 6b 8X bb c2, whole image', len(pat('6b 8? bb c2').findall(M)), 3)
# doc 72
fd = list(csv.DictReader(open(P(r'ida\out\main-unreached\functions-disposition.tsv'), encoding='utf-8'), delimiter='\t'))
cnt = lambda d: sum(r['disposition'] == d for r in fd); byt = lambda d: sum(int(r['size']) for r in fd if r['disposition'] == d)
k('doc72 functions rows', len(fd), 83)
for d, n in [('REACHED', 5), ('WINDOW', 3), ('DATA', 15), ('DEAD', 60)]:
    k('doc72 %s count' % d, cnt(d), n)
k('doc72 REACHED bytes', byt('REACHED'), 36); k('doc72 DATA bytes', byt('DATA'), 604); k('doc72 DEAD bytes', byt('DEAD'), 2286)
k('doc72 WINDOW bytes 750+204+4', byt('WINDOW'), 958)
k('doc72 dbcode-runs rows', len(open(P(r'ida\out\main-unreached\dbcode-runs.tsv'), encoding='utf-8').read().strip().split('\n')) - 1, 598)
k('doc72 dbcode-runs sum(size)', sum(int(r['size']) for r in csv.DictReader(open(P(r'ida\out\main-unreached\dbcode-runs.tsv'), encoding='utf-8'), delimiter='\t')), 22262)
k('doc72 22,262 + 98', 22262 + 98, 22360); k('doc72 36+11996+9272+958+98', 36 + 11996 + 9272 + 958 + 98, 22360)
k('doc72 958 + 9272', 958 + 9272, 10230); k('doc72 22,360 - 36', 22360 - 36, 22324)
k('doc72 W2-8 runtypes sum', 13283 + 3680 + 3326 + 1532 + 266 + 149 + 26, 22262)
k('doc72 368,432 + 36 / + 20', (368432 + 36, 368432 + 20), (368468, 368452))
# doc 73
k('doc73 writers of FF8184 (byte/long store forms, whole image)', len(pat('6a 8? 81 84').findall(M)) + len(pat('01 00 6b 8? 81 84').findall(M)), 7, note='6a 8X 81 84 + 01 00 6b 8X 81 84')
# doc 74
inj = [m.start() for m in pat('6a 8? a9 ed').finditer(M) if b'\xfc\x14' in M[max(0, m.start() - 8):m.start()]]
k('doc74 fc 14 within 8 B before a 6a 8X a9 ed store', ['%06X' % (x - 2) for x in inj], ['00FDFE'])
k('doc74 "fc 4f 6a 8c aa e0" whole image', [('%06X' % m.start()) for m in pat('fc 4f 6a 8? aa e0').finditer(M)], ['05548E'])
# doc 75
for r_ in ('08', '09', '0a'):
    hits = [m.start() for m in pat('6a 8? ee ' + r_).finditer(M) if not (WIN[0] <= m.start() < WIN[1])]
    k('doc75 stores to FFEE%s outside window' % r_.upper(), len(hits), 1, note=','.join('%06X' % x for x in hits))
be = [o for o in range(0, len(M) - 3) if 0x00FF5C06 <= struct.unpack('>I', M[o:o + 4])[0] <= 0x00FF5C44 and not (WIN[0] <= o < WIN[1])]
k('doc75 BE32 in 0xFF5C06-0xFF5C44 outside window (all offsets)', len(be), 0)
k('doc75 0xFF5806 + 0x3FF', '%X' % (0xFF5806 + 0x3FF), 'FF5C05'); k('doc75 0xFF5806 + 0x43E', '%X' % (0xFF5806 + 0x43E), 'FF5C44')
k('doc75 overrun 0x43E - 0x3FF', 0x43E - 0x3FF, 63)
k('doc75 buffers tile 0xFF5006+3*0x400', '%X' % (0xFF5006 + 3 * 0x400 - 1), 'FF5C05')
# doc 76 (J8) timing
k('doc76 0x4E20', 0x4E20, 20000); k('doc76 0x8980', 0x8980, 35200)
k('doc76 TCR 0x21: CCLR (b7:5)', 0x21 >> 5, 1); k('doc76 TCR 0x21: TPSC (b2:0)', 0x21 & 7, 1)
k('doc76 TIER 0x41: TGIEA (b0)', 0x41 & 1, 1); k('doc76 TSTR 0x20 -> channel bit', (0x20).bit_length() - 1, 5)
k('doc76 TCR 0x00: TPSC', 0x00 & 7, 0)
k('doc76 tick = 20000 / (16 MHz/4) ms', '%.3f' % (20000 / 4e6 * 1e3), '5.000')
k('doc76 tick = (20000+1) / 4 MHz ms', '%.5f' % (20001 / 4e6 * 1e3), '5.00025', note='doc 76 uses TGRA+1 counts; RESUME rounds to 5.000')
k('doc76 guard = 35200 / 16 MHz ms', '%.4f' % (35200 / 16e6 * 1e3), '2.2000')
k('doc76 guard = 35200 x 62.5 ns', 35200 * 62.5, 2200000.0)
k('doc76 overflow 65536 / 16 MHz ms', '%.3f' % (65536 / 16e6 * 1e3), '4.096')
k('doc76 0x8980 < 0x10000', 0x8980 < 0x10000, True)
k('doc76 vector 110 offset', 110 * 4, 0x1B8); k('doc76 vector 66 offset', 66 * 4, 0x108)
k('doc76 tiers 5ms x2 x10 x10', (5 * 2, 5 * 2 * 10, 5 * 2 * 10 * 10), (10, 100, 1000))
k('doc76 "6a 8c fe f0" whole image', [('%06X' % m.start()) for m in pat('6a 8c fe f0').finditer(M)], ['002484'])
k('doc76 "79 04 4e 20" whole image (raw)', [('%06X' % m.start()) for m in pat('79 04 4e 20').finditer(M)], ['0024A2'])
cmpw = [('%06X' % m.start()) for m in pat('79 2? 89 80').finditer(M)]
k('doc76 cmp.w #0x8980 (79 2X 89 80) whole image', len(cmpw), 9, note=','.join(cmpw))
gs = [r['site'] for r in csv.DictReader(open(P(r'ida\out\dsp-tick\guard-sites.tsv'), encoding='utf-8'), delimiter='\t')]
k('doc76 guard-sites.tsv == scan', sorted(int(x, 16) for x in gs), sorted(int(x, 16) for x in cmpw))
# doc 78 (J10)
dp = list(csv.DictReader(open(P(r'ida\out\sub-merge\disposition.tsv'), encoding='utf-8'), delimiter='\t'))
sz = lambda f: sum(int(r['size']) for r in dp if f(r)); nn = lambda f: sum(1 for r in dp if f(r))
k('doc78 disposition rows', len(dp), 156)
k('doc78 merge-into count/bytes', (nn(lambda r: r['disposition'] == 'merge-into'), sz(lambda r: r['disposition'] == 'merge-into')), (31, 2279))
k('doc78 dead count/bytes', (nn(lambda r: r['disposition'] == 'dead'), sz(lambda r: r['disposition'] == 'dead')), (125, 7780))
k('doc78 cu count/bytes', (nn(lambda r: r['reach_prev'] == 'credited-unreached'), sz(lambda r: r['reach_prev'] == 'credited-unreached')), (89, 5321))
k('doc78 prev-dead count/bytes', (nn(lambda r: r['reach_prev'] == 'dead'), sz(lambda r: r['reach_prev'] == 'dead')), (67, 4738))
k('doc78 dead heads that were cu / dead', (nn(lambda r: r['disposition'] == 'dead' and r['reach_prev'] == 'credited-unreached'), nn(lambda r: r['disposition'] == 'dead' and r['reach_prev'] == 'dead')), (59, 66))
k('doc78 cu dead-head bytes', sz(lambda r: r['disposition'] == 'dead' and r['reach_prev'] == 'credited-unreached'), 3414)
k('doc78 merges into cu / dead owners (count,bytes)', ((nn(lambda r: r['disposition'] == 'merge-into' and r['root_reach'] == 'credited-unreached'), sz(lambda r: r['disposition'] == 'merge-into' and r['root_reach'] == 'credited-unreached')),
                                                     (nn(lambda r: r['disposition'] == 'merge-into' and r['root_reach'] == 'dead'), sz(lambda r: r['disposition'] == 'merge-into' and r['root_reach'] == 'dead'))), ((19, 824), (12, 1455)))
k('doc78 FFF2A70B size', [int(r['size']) for r in dp if r['start'] == 'FFF2A70B'], [372])
k('doc78 20+7+3+1', 20 + 7 + 3 + 1, 31); k('doc78 824+1455', 824 + 1455, 2279); k('doc78 31+125', 31 + 125, 156)
k('doc78 2279+7780', 2279 + 7780, 10059); k('doc78 5321+4738', 5321 + 4738, 10059); k('doc78 66+59', 66 + 59, 125)
k('doc78 peripheral.tsv rows', len(open(P(r'ida\out\sub-merge\peripheral.tsv'), encoding='utf-8').read().strip().split('\n')) - 1, 12)
for a, d, tgt in [(0xFFF13EE8, 0x19, 0xFFF13F01), (0xFFF13EFF, 0x17, 0xFFF13F16), (0xFFEF05E9, 0x53, 0xFFEF063C), (0xFFF2A6F7, 0x14, 0xFFF2A70B)]:
    k('doc78 branch %08X + disp 0x%X' % (a, d), '%08X' % (a + d), '%08X' % tgt)
# doc 79 extents
for nm, base, n, st, end in [('icon', 0xFFED55E0, 254, 28, 0xFFED71A8), ('font', 0xFFED4644, 26, 12, 0xFFED477C), ('glyph1', 0xFFED477C, 51, 12, 0xFFED49E0),
                             ('glyph_tbl8', 0xFFED49E0, 45, 8, 0xFFED4B48), ('mask', 0xFFED7F18, 18, 4, 0xFFED7F60), ('geometry', 0xFFED7F60, 13, 44, 0xFFED819C)]:
    k('doc79 %s %d x %d end' % (nm, n, st), '%08X' % (base + n * st), '%08X' % end)
k('doc79 record 2 address', '%08X' % (0xFFED7F60 + 2 * 0x2C), 'FFED7FB8'); k('doc79 0x7DFFFF', 0x7DFFFF, 8257535)
k('doc79 223+30+1', 223 + 30 + 1, 254)
# doc 80 (J12): 662/663 against tables
s49 = list(csv.DictReader(open(P(r'ida\out\settings-49\settings-49.tsv'), encoding='utf-8'), delimiter='\t'))
k('doc80 settings-49.tsv rows', len(s49), 49)
ld = [r['live_dead'] for r in s49]
k('doc80 dead rows', sum(x.upper() == 'DEAD' for x in ld), 1)
k('doc80 read-live/save-dead rows', sum(x == 'read-live/save-dead' for x in ld), 1)
k('doc80 live rows', sum(x.startswith('live') for x in ld), 47)
k('doc80 dead row is FF89CA', [r['ram_addr'] for r in s49 if r['live_dead'].upper() == 'DEAD'], ['0xFF89CA'])
k('doc80 save-dead row is FF8937', [r['ram_addr'] for r in s49 if r['live_dead'] == 'read-live/save-dead'], ['0xFF8937'])
f5 = list(csv.DictReader(open(P(r'ida\out\settings\settings-bytes.tsv'), encoding='utf-8'), delimiter='\t'))
ded = [r for r in f5 if ('single' in r['writer'] or '[blk' in r['writer']) and not r['menu_item'].strip()]   # dedicated writer (single stub or block save), no menu item
ext = list(csv.DictReader(open(P(r'ida\out\orphan-screens\settings-bytes-ext.tsv'), encoding='utf-8'), delimiter='\t'))
ek = {(r['region'], r['n']) for r in ext}
rest = [(r['region'], r['n']) for r in ded if (r['region'], r['n']) not in ek]
k('doc80 F5 dedicated-writer, no-menu-item rows', len(ded), 663)
k('doc80 I6 settings-bytes-ext rows', len(ext), 644)
k('doc80 I6 ext rows of class dedicated-unattributed', sum(r['f5_class'] == 'dedicated-unattributed' for r in ext), 614)
k('doc80 663 minus I6 keys', len(rest), 49)
k('doc80 that set == settings-49.tsv keys', set(rest) == {(r['region'], r['n']) for r in s49}, True)
k('doc80 attributed 614 + 48', 614 + 48, 662); k('doc80 662 + 1 dead', 662 + 1, 663); k('doc80 47+1+1', 47 + 1 + 1, 49)
k('doc80 live groups 16+1+2+1+1+1+2+2+1+3+1+1+15', 16 + 1 + 2 + 1 + 1 + 1 + 2 + 2 + 1 + 3 + 1 + 1 + 15, 47)
k('doc80 groups 13 live + 1 + 1', 13 + 1 + 1, 15)
k('doc80 R1 0x58-0x67 / R3 0x120-0x12E sizes', (0x67 - 0x58 + 1, 0x12E - 0x120 + 1), (16, 15))
k('doc80 abs16 refs to 89 ca (6a/6b xx 89 ca), whole image', ['%06X' % m.start() for m in re.finditer(rb'[\x6a\x6b].\x89\xca', M, re.S)], ['00E678'], note='"only image-wide reference"')
# doc 82
for p_ in ('5e 03 c6 68', '5a 03 c6 68', '00 03 c6 68'):
    k('doc82 "%s" whole image' % p_, len(pat(p_).findall(M)), 0)
k('doc82 "5e 03 35 32" whole image', ['%06X' % m.start() for m in pat('5e 03 35 32').finditer(M)], ['077DB2', '077DF6'])
k('doc82 bne at 0x3C996 target', '%X' % (0x3C996 + 4 + struct.unpack('>h', M[0x3C998:0x3C99A])[0]), '3C668')
k('doc82 jsr @0x3BDAC count (32 callers)', len(pat('5e 03 bd ac').findall(M)), 32, note='raw abs24 jsr count')
k('doc82 jsr @0x3BF4C count (31 callers)', len(pat('5e 03 bf 4c').findall(M)), 31, note='raw abs24 jsr count')

# ------------------------------------------------------------------ lane outputs exist
need = {
 'J1 main-final3': ['final3_proven_mask.bin', 'final3_named_mask.bin', 'ledger.tsv', 'overlaps.tsv', 'final3_proven_runs.tsv', 'i12-unreachable.tsv', 'ffa9e0-writers.tsv',
                    'MAIN_FINAL3_codemask.bin', 'MAIN_FINAL3_functions_raw.tsv', 'MAIN_FINAL3_log.txt', 'build_log.txt', r'offline\j1_build_masks.py'],
 'J2 dern-dispatch': ['sites.tsv', 'families.tsv', 'new-targets.tsv'],
 'J3 key-dispatch': ['writers-0xFFBBC2.tsv', 'touch-zone-luts.txt', 'record-layout.tsv', 'handler-map.tsv', r'work\disasm.txt', r'work\anchors.tsv', r'work\callers.tsv', r'work\disasm2.txt', r'work\luts.txt', r'work\context.tsv'],
 'J4 main-unreached': ['functions-disposition.tsv', 'dbcode-runs.tsv'],
 'J5 usb-status0': ['writers-readers.tsv', 'state-machine.tsv', r'work\sm_core.txt', r'work\sm_pre.txt', r'work\ep3_6.txt', r'work\ep3_sub.txt', r'work\init_c.txt', r'work\funcs.txt', r'work\xrefs.txt'],
 'J6 usb-key14': ['sub_708b6-trace.tsv', 'ffaae8-refs.tsv', 'event-4f-path.tsv', r'work\p1', r'work\p2'],
 'J7 usb-registers': ['reg-access.tsv', 'reg-analysis.tsv', 'ram-owner.tsv', 'ram-ff5c06.tsv', r'work\reg-fullmap.txt', r'work\reg-context.txt', r'work\ranges.txt', r'work\ep1-loop.txt',
                      r'work\ram-neighborhood.txt', r'work\buffer-probe.txt', r'work\ram-names.txt'],
 'J8 dsp-tick': ['tpu-config.tsv', 'period-calc.txt', 'guard-sites.tsv'],
 'J9 dsp-tx-src': ['session-caller-map.tsv', 'opcode-11-12-32-payload.tsv', 'caller-edges.tsv', 'caller-trace.txt', 'opcode-builders.txt', 'txstart-context.txt', 'txkey-chain.txt', 'flag-setters.tsv'],
 'J10 sub-merge': ['disposition.tsv', 'chains.tsv', 'dead-scan.tsv', 'peripheral.tsv', r'raw\dis.txt', r'raw\status.txt'],
 'J11 sub-icon-glyph': ['icon_records.tsv', 'font_blocks.tsv', 'glyph1_desc.tsv', 'glyph_tbl8.tsv', 'storage_mode_records.tsv', r'raw\dump.txt', r'raw\dump2.txt', r'raw\scan.txt'],
 'J12 settings-49': ['settings-49.tsv', 'dump.txt', 'probe.txt', 'probe2.txt'],
 'J13 ledger-reverify': ['byte-runs.tsv', 'mask-resum.tsv', 'overlaps-reverify.tsv'],
 'J14 eeprom-verify': ['j14_verify_table.tsv', 'j14_xrefs.tsv', 'j14_callsite.tsv'],
}
for lane, files in need.items():
    d = lane.split()[1]
    miss = [f for f in files if not os.path.exists(P('ida', 'out', d, f))]
    k('exists ida\\out\\%s (%s): %d files' % (d, lane.split()[0], len(files)), miss, [], note='missing listed' if miss else '')
jobs = ['j1_apply_main_final3.py', 'j3_keydisp.py', 'j3_keydisp2.py', 'j5_usbstat.py', 'j6_dump.py', 'j7_usbreg.py', 'j9_txsrc.py', 'j9_txsrc2.py',
        'j10_merge.py', 'j11_dump.py', 'j11_dump2.py', 'j11_scan.py', 'j12_set49.py', 'j12_probe.py', 'j12_probe2.py', 'j14_eeprom_verify.py']
k('job scripts named in J docs exist (ida\\jobs)', [j for j in jobs if not os.path.exists(P('ida', 'jobs', j))], [])
k('eeprom-verify j14_dis_*.txt present', len(glob.glob(P(r'ida\out\eeprom-verify\j14_dis_*.txt'))) > 0, True)

# ------------------------------------------------------------------ citation tallies
from collections import Counter
tal = Counter((r[0], r[5]) for r in rows)
for doc in sorted({r[0] for r in rows}):
    K.append(('citations %s' % doc, ' '.join('%s=%d' % (s, tal[(doc, s)]) for s in ('PASS', 'FAIL-OFFSET', 'FAIL', 'N/A') if tal[(doc, s)]), '', 'INFO', ''))
tot = Counter(r[5] for r in rows)
K.append(('citations TOTAL', ' '.join('%s=%d' % (s, tot[s]) for s in ('PASS', 'FAIL-OFFSET', 'FAIL', 'N/A') if tot[s]), '', 'INFO', 'rows=%d' % len(rows)))
K.append(('citations anchors not found', sum(1 for r in rows if r[1] == 'ANCHOR-NOT-FOUND'), 0, 'PASS' if not any(r[1] == 'ANCHOR-NOT-FOUND' for r in rows) else 'FAIL', ''))

with open(os.path.join(OUT, 'counts.tsv'), 'w', encoding='utf-8', newline='') as f:
    f.write('item\tvalue\texpected\tresult\tnote\n')
    for r in K:
        f.write('\t'.join(str(x) for x in r) + '\n')

# ------------------------------------------------------------------ coverage: every hex-run line in the J docs
cited = {(r[0], r[1]) for r in rows}
HEXRUN = re.compile(r'`[^`]*\b([0-9A-Fa-f]{2} ){1,}[0-9A-Fa-f]{2}\b[^`]*`|^\s*[0-9A-Fa-f]{6}\s+([0-9a-f]{2} )+[0-9a-f]{2}\b')
with open(os.path.join(OUT, 'coverage.tsv'), 'w', encoding='utf-8', newline='') as f:
    f.write('source_doc\tline\tcovered_by_citation_row\tdisposition_if_not\ttext\n')
    for key, lines in LINES.items():
        lo, hi = (R_LO, R_HI) if key == 'R' else (1, len(lines))
        for i in range(lo - 1, hi):
            t = lines[i]
            if not HEXRUN.search(t):
                continue
            cov = (DOCFILES[key], i + 1) in cited
            if cov:
                disp = ''
            elif re.search(r'`(bb c[23]|6b [08]X bb c2|5e 03 c6 68|5a 03 c6 68|00 03 c6 68|6a 8r a9 ed|fc 14|a9 ed)`', t):
                disp = 'whole-image pattern count -> counts.tsv'
            elif re.search(r'`41 D[13]`', t):
                disp = 'USB vendor request code, not an image location'
            elif (DOCFILES[key], i) in cited or (DOCFILES[key], i - 1) in cited or (DOCFILES[key], i + 2) in cited:
                disp = 'continuation of a cited line (checked there)'
            elif '01 00 6b 84 81 84' in t:
                disp = 'form checked at the 0x054C64/0x054F1E/0x05601E rows'
            else:
                disp = 'encoding/opcode notation with no image address'
            f.write('%s\t%d\t%s\t%s\t%s\n' % (DOCFILES[key], i + 1, 'Y' if cov else 'N', disp, t.strip()[:200]))

print('citations:', dict(tot), 'rows', len(rows))
print('counts FAIL:', [r[0] for r in K if r[3] == 'FAIL'])
