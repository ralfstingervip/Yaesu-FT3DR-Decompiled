# Lane L6. Python model of the MAIN key-table resolver, sub_1079E (0x01079E-0x0109B7) and its
# selectors sub_10CC4 (home), sub_10EB8 (screen table), sub_10EF0 ([94C1] layer), sub_10FA8 ([94C0] TX),
# hand-transcribed from the bytes (each branch carries the address it models). Read-only.
# state keys (defaults 0): key=A9ED, BBF5, AA38_b6, BBF4_b7, BBF4_b1, BC4E, BBDE, A9FC, A9FE, A9FF,
#   C94C0, C94C1, A9F9, A9FA_b1, D8DDE (signed), B3E0, D8DE0_b7, B2A5, rec0, rec1, rec5, rec46_b0,
#   BBE0_b2, C89C5_b0, A506, BBF1_b5, AD6A, AAD1, AAD3, AAD4, f3ECB8, f328DA, f3F1F2 (signed), f4906,
#   f10EA0, lock (=sub_10C00 discards the key)
from l6lib import *

TX_SCREEN = {}
for i in range(12):
    w = be16(0x011038 + 2 * i); TX_SCREEN[w >> 8] = w & 0xFF   # 0x011038: 12 x {screen id, TX table index}


def sel_home(s, why):                      # sub_10CC4
    k = s.get('key', 0x0A)
    d = s.get('D8DDE', 0)
    if d > 0:                               # 0x010CC8 beq / 0x010CCC bmi not taken
        why.append('8DDE>0 @010CC8')
        if s.get('B3E0', 0) == 0: return 0x114DC  # 0x010CD8
        if not s.get('D8DE0_b7', 0): return 0x11520  # 0x010CE8
        if s.get('A9F9', 0) != 1: return 0x11564  # 0x010CF8
        return 0x11124
    if d < 0:                               # 0x010CCC bmi -> 0x010D06
        why.append('8DDE<0 @010CCC')
        if s.get('A9F9', 0) == 9: return 0x11388  # 0x010D12
        b = 0x111AC if s.get('B2A5', 0) else 0x11168  # 0x010D20
        if s.get('A9F9', 0) == 1: return b  # 0x010D2E
        return 0x11850 if s.get('rec46_b0', 0) else 0x115A8  # 0x010D3E
    why.append('8DDE==0 @010CC8')
    if s.get('rec46_b0', 0): return 0x1180C   # 0x010D62
    if s.get('f3ECB8', 0) and s.get('f328DA', 0): return 'skip(AAE0=FF,8F89=2) @010D70'
    a9f9 = s.get('A9F9', 0)
    if a9f9 == 1:                           # 0x010D7A
        if (not s.get('BBE0_b2', 0)) and s.get('C89C5_b0', 0):
            b = 0x1109C; allowed = (5, 4, 8, 0xD, 0xE)   # 0x010DA6..0x010DCA
        else:
            b = 0x110E0; allowed = (0xE,)              # 0x010D8C..0x010DA0
        if s.get('B2A5', 0) or k not in allowed: return b
        r1 = s.get('rec1', 0)                         # 0x010DCE
        if r1 == 0: return sel_rec5(s, why)
        if r1 >= 0xC: return b
        return sel_screen(s, why, r1)
    if a9f9 in (4, 5):                      # 0x010DEA / 0x010DEE
        b = 0x111F0
        if a9f9 == 5:
            if s.get('A9FA_b1', 0): return 0x11278  # 0x010DF8
            b = 0x11234
        if s.get('A506', 0) == 0 or k in (0x0A, 0x0D): return b   # 0x010E0E..0x010E1E
        return 0x1485C                                            # 0x010E26 (after jsr 0x2888C)
    if a9f9 == 8: return 0x11344             # 0x010E38
    if a9f9 == 9: return 0x11388             # 0x010E42
    if a9f9 == 10: return 0x113CC            # 0x010E4C
    return sel_rec5(s, why)


def sel_rec5(s, why):                       # 0x010E4E
    r5 = s.get('rec5', 0)
    if r5 == 2:
        f = s.get('f3F1F2', 0)                # jsr 0x3F1F2 @0x010E5C
        if f > 0:
            return 0x117C8 if s.get('f10EA0', 0) else 0x11784   # 0x010E64..0x010E6E
        if f == 0 and s.get('f4906', 0) == 0:
            return 0x1276C                    # 0x010E7C
    return 0x115EC + 0x44 * r5                # 0x010E92


def sel_screen(s, why, r3):                 # sub_10EB8
    if s.get('BBF1_b5', 0) and s.get('key', 0x0A) == 0x0A: return 0x14818
    return scr_kt(r3)


def sel_layer(s, why):                      # sub_10EF0, r3l = [94C1]
    r3 = s.get('C94C1', 0); d = s.get('D8DDE', 0); a9f9 = s.get('A9F9', 0)
    idx = lambda b: b + 0x44 * (r3 - 1)
    if d < 0 and r3 == 1 and a9f9 == 0: return 0x12048          # 0x010EF4..0x010F04
    if a9f9 in (4, 5, 6): return idx(0x11F7C)                    # 0x010F12..0x010F1E
    if a9f9 == 9: return idx(0x12004)                            # 0x010F28
    if a9f9 == 10: return idx(0x11FC0)                           # 0x010F32
    r1 = s.get('rec1', 0)
    if r1 in (3, 4): return idx(0x11D5C)                         # jsr 0x2EAEE @0x010F3A
    if r3 not in (2, 4, 5):
        if s.get('rec0', 0) in (0xA, 0xB): return idx(0x11DE4)   # jsr 0x11082 @0x010F56, cmp #0xA @0x010F5C
        if s.get('AD6A', 0): return 0x11F38                      # 0x010F6A (no index)
        if s.get('rec5', 0) == 2 and s.get('f3F1F2', 0) > 0: return idx(0x11EB0)   # 0x010F72..0x010F80
    why.append('jsr 0x21A22 @0x010F82 (touch idx 0x16 exempt)')
    if s.get('rec5', 0) == 0: return 0x11D18                     # 0x010F92 (no index)
    return idx(0x11BC4)                                          # 0x010F94


def sel_tx(s, why):                         # sub_10FA8, r3l = [94C0]
    r3 = s.get('C94C0', 0); d = s.get('D8DDE', 0)
    if d > 0:
        if not s.get('D8DE0_b7', 0): return 0x11894              # 0x010FBC
        r1 = s.get('rec1', 0)
        if r1 == 0x40: return 0x12CBC                            # 0x010FCA
        if r1 == 0x28: return 0x12948                            # 0x010FCE
        return 0x118D8
    if d < 0 and r3 != 2: return 0x1191C                         # 0x010FE2
    if r3 == 1:                                                  # 0x010FEC
        r1 = s.get('rec1', 0)
        if r1 in TX_SCREEN: r3 = TX_SCREEN[r1]                   # loop 0x010FFC..0x011004 over table 0x011038
        else:
            r3 = 4
            if not (s.get('AAD1', 0) & 0xC):
                r3 = 9
                if not (s.get('AAD3', 0) & 0xF) and not (s.get('AAD4', 0) & 1): r3 = 1
    return 0x11960 + 0x44 * (r3 - 1)                             # 0x011024


def select(s):
    """returns (kt, why) or (None, why) when the key is consumed before dispatch"""
    why = []
    if s.get('BBF5', 0): return None, ['BBF5!=0 @0107A4']
    k = s.get('key', 0x0A)
    if k >= 0x80: return None, ['no key']
    if s.get('lock', 0): return None, ['sub_10C00 discards key @01080E']
    bc = s.get('BC4E', 0)
    if bc: return {1: 0x11498, 2: 0x11410}.get(bc, 0x11454), ['BC4E=%d @01083E' % bc]
    if s.get('BBF4_b7', 0): return None, ['BBF4.7 -> sub_10A78 @01086E (not modelled)']
    if s.get('BBDE', 0) and s.get('rec1', 0) == 0 and k not in (0, 0x0A):
        return 0x12590, ['BBDE @01087A']
    if s.get('BBF4_b1', 0): return 0x147D4, ['BBF4.1 @0108A0']
    if (s.get('A9FC', 0) or s.get('A9FE', 0)) and k != 0x0E: return 0x112BC, ['A9FC/A9FE @0108B2']
    if s.get('A9FF', 0): return None, ['A9FF!=0 -> er5 from caller @0108DA (not modelled)']
    if s.get('C94C0', 0): return sel_tx(s, why), why + ['94C0!=0 @010918']
    if s.get('C94C1', 0): return sel_layer(s, why), why + ['94C1!=0 @01091E']
    r1 = s.get('rec1', 0)
    if (s.get('A9F9', 0) == 1 and r1 < 0xC) or r1 == 0:          # 0x010920..0x010934
        return sel_home(s, why), why
    if r1 in (1, 2): why.append('rec+1 in {1,2}: sub_10B9C may return the home table @010948')
    return sel_screen(s, why, r1), why
