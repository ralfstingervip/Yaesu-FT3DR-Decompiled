r"""Lane N12 verifier: re-reads every byte run cited in docs\deep\139-irq-knobs.md from the two plaintext
images, checks the image hashes, checks the cited MAIN ranges against the FINAL7 masks, and re-derives the
sprite geometry. Read-only. Writes verify.tsv and mask.tsv next to this script."""
import sys
import hashlib, os, struct
HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.dirname(os.path.dirname(os.path.dirname(HERE)))
sys.exit('The firmware image is not in this repository.')
SB = 0xFFC00000
H_MAIN = '8e3ecd05409b2c314ebed77320ece5930bf31c8333cd84aeef4f6b0264c1bcce'
H_SUB = 'b93570b3c2f69ccb51c113c893b4bc4c414cf78ceddde478748404e0768c6230'

# (image, mapped address, bytes, note)
C = [
 ('M', 0x00011C, '00 00 29 ca', 'vector 71 (IRQ7) -> 0x29CA'),
 ('M', 0x000128, '00 00 2a 60', 'vector 74 (IRQ10) -> 0x2A60'),
 ('M', 0x00012C, '00 00 2a 1e', 'vector 75 (IRQ11) -> 0x2A1E (standby wake, not a knob)'),
 ('M', 0x0029CA, '6d f4 6b 04 ff 36 72 7c 6b 84 ff 36', 'IRQ7 ISR: clear ISR.IRQ7F (FFFF36 b7)'),
 ('M', 0x0029D6, '6a 10 81 7f 73 00 47 2a 6a 0c 94 b9 46 24', 'IRQ7 latch gated by FF817F.b0 and debounce FF94B9==0'),
 ('M', 0x0029E4, '2c 4e 6a 10 81 70 73 00 46 06 73 3c 47 0a 40 04 73 3c 46 04 fc 80 40 02 fc 81', 'IRQ7 direction = PORTF(FFFF4E).b3 == 8170.b0 -> 0x81 else 0x80'),
 ('M', 0x0029FE, '6a 8c 81 71 fc 04 6a 8c 94 b9', 'IRQ7 stores latch FF8171, debounce FF94B9=4'),
 ('M', 0x002A08, '6b 04 fd 6a 71 74 71 64 6b 84 fd 6a 6a 18 81 70 71 00 6d 74 56 70', 'IRQ7 flips ISCRL bits 15:14 and 8170.b0, rte'),
 ('M', 0x002A60, '6d f4 6b 04 ff 36 72 24 6b 84 ff 36', 'IRQ10 ISR: clear ISR.IRQ10F (FFFF36 b10)'),
 ('M', 0x002A6C, '2c 4e 6a 10 81 70 73 10 46 06 73 1c 47 0a 40 04 73 1c 46 04 fc 80 40 02 fc 81', 'IRQ10 direction = PORTF.b1 == 8170.b1'),
 ('M', 0x002A86, '6a 8c bb e3', 'IRQ10 stores latch FFBBE3 (no gate, no debounce)'),
 ('M', 0x002A8A, '6b 04 fd 68 71 5c 71 4c 6b 84 fd 68 6a 18 81 70 71 10 6d 74 56 70', 'IRQ10 flips ISCRH bits 5:4 and 8170.b1, rte'),
 ('M', 0x002A30, '6d f4 6a 18 fe f5 72 00', 'TGI5A ISR (debounce tick)'),
 ('M', 0x002A44, '6a 0c 94 b9 47 06 1a 0c 6a 8c 94 b9', 'TGI5A decrements FF94B9'),
 ('M', 0x002382, 'fc 00 6a 8c 81 71 6a 8c 81 70 6a 8c 81 7e 6a 8c 81 7f 6a 8c 94 b9', 'init clears latch, edge state, gate, debounce'),
 ('M', 0x002398, '79 03 40 00 2c 40 ec 80 46 0a 79 03 80 00 6a 18 81 70 70 00 6b 83 fd 6a', 'IRQ7 initial edge from PORT1(FFFF40).b7 -> ISCRL'),
 ('M', 0x0023B0, 'fc 80 6a 8c fb 90', 'P1ICR = 0x80 (P17 input buffer)'),
 ('M', 0x0023B6, '79 03 00 10 2c 45 ec 04 46 0a 79 03 00 20 6a 18 81 70 70 10 6b 83 fd 68', 'IRQ10 initial edge from PORT6(FFFF45).b2 -> ISCRH'),
 ('M', 0x0023CE, 'fc 04 6a 8c fb 95', 'P6ICR = 0x04 (P62 input buffer)'),
 ('M', 0x0023DA, '79 04 04 80 6b 84 ff 34', 'IER = 0x0480 (IRQ10 + IRQ7)'),
 ('M', 0x002874, '79 04 08 08 6b 84 fb ce 79 04 08 08 6b 84 ff 34', 'standby path: SSIER = IER = 0x0808 (IRQ11 + IRQ3); knobs off'),
 ('M', 0x004888, '6a 18 81 7f 70 00 5e 01 07 60 54 70', 'only setter of the IRQ7 gate FF817F.b0'),
 ('M', 0x00FB40, '6a 2c 00 ff 89 b5 46 1c', 'scan: FF89B5 (DIAL KNOB CHANGE) selects latch roles'),
 ('M', 0x00FB48, 'fc 00 6a 0b 81 71 6a 8c 81 71 73 7b 46 68', 'value 0: FF8171 (IRQ7) b7 -> DIAL event'),
 ('M', 0x00FB56, '6a 0b bb e3 6a 8c bb e3 73 7b 47 22 40 1a', 'value 0: FFBBE3 (IRQ10) b7 -> sub_FC56 (other knob)'),
 ('M', 0x00FB64, 'fc 00 6a 0b bb e3 6a 8c bb e3 73 7b 46 4c', 'value !=0: FFBBE3 (IRQ10) b7 -> DIAL event'),
 ('M', 0x00FB72, '6a 0b 81 71 6a 8c 81 71 73 7b 47 06 5e 00 fc 56 54 70', 'value !=0: FF8171 (IRQ7) b7 -> sub_FC56'),
 ('M', 0x00FBBE, '77 0b 6a 18 a9 ee 67 00 fc 16', 'DIAL step: A9EE.b0 = dir, raw key 0x16'),
 ('M', 0x00FBD4, 'fb 09 18 bc 6a 8c a9 ed', 'event = raw - 9 = 13 -> A9ED'),
 ('M', 0x00FC56, '6a 18 aa 38 70 60 77 0b 6a 18 a9 ee 67 00 54 70', 'sub_FC56: AA38.b6 = 1, A9EE.b0 = dir'),
 ('M', 0x00E634, 'fc 01 6a 8c 89 b5', 'factory default FF89B5 = 1'),
 ('M', 0x00A210, '79 04 f3 96', 'sends F396 to SUB'),
 ('M', 0x00A228, '6a 0b 89 b5 47 02 fb 01 7a 06 00 ff 3d 94 68 eb', 'F396 value byte = (FF89B5 != 0)'),
 ('M', 0x0107B0, '6a 10 aa 38 73 60 46 14', 'sub_1079E consumes AA38.b6'),
 ('M', 0x0107EE, '5e 01 0a 30', '-> sub_10A30'),
 ('M', 0x010A40, '5e 01 e7 44 6a 18 aa 38 72 70 6a 18 aa 38 72 60', 'sub_10A30 -> sub_1E744, then clears AA38.b7/b6'),
 ('M', 0x01E752, '6e 0c 00 6c 6a 8c aa 56 7a 06 00 01 e7 96 5e 01 e8 40 4b 2e 6e 8b 00 6c', 'record +0x6C stepped through step record 0x1E796'),
 ('M', 0x01E796, '00 1f 00 ff aa 56', 'step record: lo 0, hi 0x1F, scratch FFAA56'),
 ('M', 0x01E848, '6a 10 a9 ee 73 00 46 0a', 'stepper direction from A9EE.b0'),
 ('M', 0x01E7EE, '6e 4c 3a 68 6a 0d a9 b8', 'level -> taper table 0x3A68'),
 ('M', 0x01E804, '6a 8c a9 9b', '-> DAC shadow A99B'),
 ('M', 0x01E836, '6e 4c 3a 68 6a 8c a9 9a', '-> DAC shadow A99A'),
 ('M', 0x003A68, '00 01 02 03 04 05 06 07 08 09 0a 0c 0e 10 12 15 18 1b 1e 21 26 2b 31 39 43 4e 5d 6e 84 a1 c8 ff', '32-entry taper (index 0..0x1F)'),
 ('M', 0x003490, '7a 01 00 00 00 00 6e 1a a9 98 6e 12 a9 a0 1c a2 47 38', 'sub_3490: 8 shadow bytes A998..A99F vs sent copy A9A0..'),
 ('M', 0x0034AA, '6e 12 35 6c 10 52 10 52 fe 0c 7f 5a 72 10', 'address nibble 0x356C[i], 12 clocks on PBDR(FFFF5A).b1'),
 ('M', 0x0034BC, '10 12 7f 5a 67 00', 'data bit on PBDR.b0'),
 ('M', 0x0034D2, '7f 5a 70 50', 'load strobe PBDR.b5'),
 ('M', 0x00356C, '08 04 0c 02 0a 06 0e 01', 'channel address nibbles'),
 ('S', 0xFFC3E475, '44 49 41 4c 20 4b 4e 4f 42 20 43 48 41 4e 47 45 00', '"DIAL KNOB CHANGE" setup label'),
 ('S', 0xFFF491A7, '56 4f 4c 00 44 49 41 4c 00', '"VOL" "DIAL" option strings'),
 ('S', 0xFFF052D7, 'fb 32 8c 0a ed ff 75 42 4d 75 41 41 05 65 b3 fe', 'F396 screen: blit sprite 0xFFED0A8C at x=0x41 y=0x4D'),
 ('S', 0xFFF052E7, '5a 01 bb 01 61 01 21 28', 'value byte; != 0 -> FFF05315'),
 ('S', 0xFFF052EF, 'fb 42 a7 91 f4 ff 66 03 75 42 64 75 41 be 05 ea 54 ff', 'value 0: "VOL" at x=0xBE y=0x64'),
 ('S', 0xFFF05301, 'fb 42 ab 91 f4 ff 66 03 75 42 85 75 41 be 05 d8 54 ff 2e 26', 'value 0: "DIAL" at x=0xBE y=0x85'),
 ('S', 0xFFF05315, 'fb 42 ab 91 f4 ff 66 03 75 42 64 75 41 be 05 c4 54 ff', 'value 1: "DIAL" at x=0xBE y=0x64'),
 ('S', 0xFFF05327, 'fb 42 a7 91 f4 ff 66 03 75 42 85 75 41 be 05 b2 54 ff', 'value 1: "VOL" at x=0xBE y=0x85'),
 ('S', 0xFFED0A8C, '60 00 62 00 ea f9 cb ff 00 00 ff ff 00 00', 'sprite descriptor: w 96, h 98, src 0xFFCBF9EA, key 0, tint FFFF, mode 0'),
 ('S', 0xFFEF0661, 'fb ea 40 01 06 c1 0e 1f', 'blit clip: 0x140 - r1 (r1 = x)'),
 ('S', 0xFFEF066F, '75 4e f0 06 c1 0e 1e', 'blit clip: 0xF0 - r2 (r2 = y)'),
 ('S', 0xFFEFA7EA, '93 09 93 02', 'text renderer saves r1 -> sp+0x1A, r2 -> sp+0x18'),
 ('S', 0xFFEFA894, 'bb 09 06 c9 01 05 b1 0b b9 84 bb 02', 'text renderer passes r1 = [sp+0x1A] + advance, r2 = [sp+0x18] to the glyph blit'),
 ('S', 0xFFEFA8A8, '05 65 70 ff', 'bsr.a sub_FFEF190D (glyph blit)'),
 ('S', 0xFFEF19C5, 'be 01 06 c9 01 0a 76 11 40 01 06 c9 01 19', 'glyph blit: (r2 + row) * 0x140 + r1 -> r2 is the top row'),
]

MAIN_RANGES = [  # cited MAIN code/data ranges for the mask check [lo, hi)
 (0x00011C, 0x000120), (0x000128, 0x000130), (0x002382, 0x0023E2), (0x002874, 0x002884), (0x0029CA, 0x002A1E),
 (0x002A30, 0x002AA0), (0x003490, 0x0034E0), (0x00356C, 0x003574), (0x003A68, 0x003ACE), (0x004888, 0x004894),
 (0x00A206, 0x00A252), (0x00E634, 0x00E63A), (0x00FB40, 0x00FBDC), (0x00FC56, 0x00FC66), (0x0107B0, 0x0107F2),
 (0x010A30, 0x010A78), (0x01E744, 0x01E870)]


def hx(b):
    return ' '.join('%02x' % x for x in b)


rows = []
hm, hs = hashlib.sha256(MAIN).hexdigest(), hashlib.sha256(SUB).hexdigest()
rows.append(('HASH', 'MAIN', '-', hm, H_MAIN, 'PASS' if hm == H_MAIN else 'FAIL', 'sha256'))
rows.append(('HASH', 'SUB', '-', hs, H_SUB, 'PASS' if hs == H_SUB else 'FAIL', 'sha256'))
for img, a, want, note in C:
    w = bytes.fromhex(want.replace(' ', ''))
    off, data = (a, MAIN) if img == 'M' else (a - SB, SUB)
    got = data[off:off + len(w)]
    rows.append((img, '0x%08X' % a, '0x%06X' % off, hx(got), want, 'PASS' if got == w else 'FAIL', note))

# sprite geometry: small top knob (rows 0-55) over a wide ring (rows 57-97)
w, h, src = struct.unpack_from('<HHI', SUB, 0xFFED0A8C - SB)
ext = []
for y in range(h):
    xs = [x for x in range(w) if struct.unpack_from('<H', SUB, src - SB + (y * w + x) * 2)[0] != 0]
    ext.append(max(xs) - min(xs) + 1 if xs else 0)
upper, lower = max(ext[:56]), min(ext[57:98])
geo = 'rows 0-55 max width %d; rows 57-97 min width %d; at y=0x4D: upper y 77-132, lower y 133-174' % (upper, lower)
rows.append(('GEO', '0xFFED0A8C', '-', geo, 'upper<=64 and lower>=68',
             'PASS' if upper <= 64 and lower >= 68 else 'FAIL', 'sprite = small top knob over wide ring'))

with open(os.path.join(HERE, 'verify.tsv'), 'w', encoding='utf-8', newline='\n') as f:
    f.write('img\taddr\tfile_off\tgot\twant\tresult\tnote\n')
    for r in rows:
        f.write('\t'.join(r) + '\n')
npass = sum(1 for r in rows if r[5] == 'PASS')

mn = open(os.path.join(ROOT, 'ida', 'out', 'm-wave-recon', 'final7_named_mask.bin'), 'rb').read()
mp = open(os.path.join(ROOT, 'ida', 'out', 'm-wave-recon', 'final7_proven_mask.bin'), 'rb').read()
unn = 0
with open(os.path.join(HERE, 'mask.tsv'), 'w', encoding='utf-8', newline='\n') as f:
    f.write('lo\thi\tbytes\tnamed\tproven\tunnamed\n')
    for lo, hi in MAIN_RANGES:
        n = sum(1 for i in range(lo, hi) if mn[i])
        p = sum(1 for i in range(lo, hi) if mp[i])
        unn += (hi - lo) - n
        f.write('0x%06X\t0x%06X\t%d\t%d\t%d\t%d\n' % (lo, hi, hi - lo, n, p, (hi - lo) - n))
print('%d/%d PASS; cited MAIN bytes not in FINAL7 named mask: %d' % (npass, len(rows), unn))
