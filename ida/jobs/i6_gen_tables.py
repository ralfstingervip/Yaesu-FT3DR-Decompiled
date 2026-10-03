r"""Lane I6 - orphaned setup screens -> settings bytes. Plain read-only Python (no IDA).

Inputs (read-only): decrypted\FT3D_MAIN_ver102_EXP.bin, ida\out\hidden-settings\screens.tsv (H13),
ida\out\settings\settings-bytes.tsv (F5), ida\out\orphan-screens\readers_raw.tsv (i6_readers.py),
ida\out\main-descent\work\reached_insns.tsv (H9), H9's binutils oracle via main-descent\offline\common.py.
Outputs: ida\out\orphan-screens\{orphans.tsv, other-unopened.tsv, settings-bytes-ext.tsv, bitfield-map.tsv,
exit-table-runs.tsv, ledger-delta.tsv, gen_log.txt}.

    python "ida/jobs/i6_gen_tables.py"

Aborts before writing anything if any cited byte run differs from the image.
"""
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root
import os, re, sys, struct, collections
sys.dont_write_bytecode = True
sys.path.insert(0, str(_REPO / "ida/out/main-descent/offline"))
from common import IMG, flow, HI, CW, R as OUTR, runtype   # read-only loaders (H9)

ROOT = str(_REPO)
OUT = ROOT + "ida/out/orphan-screens/"
B = IMG
be32 = lambda a: struct.unpack(">I", B[a:a + 4])[0]
be16 = lambda a: struct.unpack(">H", B[a:a + 2])[0]

# ------------------------------------------------------------------ cite verification
CITES = [
    (0x0782C + 4 * 0x0E, "00004e48"), (0x04E48, "5470"),
    (0x15ED0, "fc055e017788"), (0x193C2, "790100a35a03ccbc"),
    (0x15F04, "7a0600015f105e03f628"), (0x15F10, "000200ff8994"), (0x19258, "790100745a03ccbc"),
    (0x15F16, "fc045e017778"), (0x193B2, "790100a15a03ccbc"),
    (0x16032, "5470011500ff8995"), (0x16020, "7a06000160345e03f628"), (0x19270, "790100755a03ccbc"),
    (0x160EE, "5470"), (0x19280, "790100805a03ccbc"),
    (0x16208, "fc015e017768"), (0x193A2, "7901009f5a03ccbc"),
    (0x16210, "5470"), (0x1939A, "7901009e5a03ccbc"), (0x163C8, "54705470"),
    (0x193AA, "790100a05a03ccbc"),
    (0x16574, "5e0151ec4706fc015e017788"), (0x0163EA, "6a0cad68"),
    (0x165DA, "fc065e017788"), (0x165F0, "fc045e0177885e01e79c"),
    (0x16608, "fc015e017770"),
    (0x16618, "7a06000166245e03f628"), (0x16624, "000400ff89a7"), (0x192B0, "790100875a03ccbc"),
    (0x1662A, "6a0c89a7"), (0x16642, "1e32466496"), (0x1663C, "6a8c953f"),
    (0x16648, "6a0c89a7"), (0x16660, "1e32466496"), (0x1665A, "6a8c958e"),
    (0x0FEE4, "a90b4746"), (0x0FF2E, "5e01662a"), (0x0FF04, "fc646a8c953f"),
    (0x01099E, "5e016648"), (0x01FAAE, "5e016648"), (0x0200C2, "5e016648"),
    (0x16716, "7a06000167225e03f628"), (0x16722, "000300ff89ac"), (0x192DC, "7901008c5a03ccbc"),
    (0x1EDFE, "6a0989ac10497a61000000ff78906b220001edee"), (0x1EDEE, "00090442001304380031041a006303e8"),
    (0x1F8E2, "0001ed5e0001db540001ed5e0001db540001db540001f17c"), (0x1ED7A, "5e01edfe"),
    (0x1675A, "6a1889bf7170"), (0x1950E, "7901009f5a03ccbc"),
    (0x28F46, "6a1889bf71705e0193a2"), (0x12808, "00028f46"),
    (0x07300, "6a1089bf7370"), (0x0D786, "6a1089bf7370"), (0x0DACC, "6a1089bf7370"),
    (0x16C46, "fc055e017770"),
    (0x16E4E, "7a0600016e5a5e03f628"), (0x16E5A, "000200ff89b7"), (0x19322, "790100975a03ccbc"),
    (0x16E7E, "fc005e017790"), (0x17790, "6a1889c461c0"), (0x193CA, "790100a45a03ccbc"),
    (0x17104, "fc075e017788"), (0x446BC, "5470"),
    (0x173D4, "fc005e017768"), (0x173E4, "fc075e017780"), (0x193BA, "790100a25a03ccbc"),
    (0x052CC, "6e030036e3036a0b89c76b83b05a790bf3955e009792"),
    (0x16582, "7a050001658c5a015260"), (0x1658C, "0001a0ac0001659800016 5c0".replace(" ", "")),
    (0x16598, "6e0c0036ec036a8caa56"), (0x165C0, "7a06000165d45e03f628"), (0x165D2, "5470000200ff89c7"),
    (0x1934A, "790100a75a03ccbc"),
    (0x1791E, "5e03ffa05470"), (0x19842, "7901000b5a03ccec"),
    (0x19A0A, "7901006e5a03cd1c"), (0x1B998, "5470681b6a0c8d8e"),
    (0x1762E, "6a108ea67300"), (0x17644, "7a060001766a5e03f628"), (0x1766A, "000700ffaa56"),
    (0x17652, "6a0d89b4ed07"), (0x17692, "ed70"), (0x19392, "790100945a03ccbc"),
    (0x17760, "6a1889be61c040366a1889bf61c0402e6a1889c061c040266a1889c161c0401e"
               "6a1889c261c040166a1889c361c0400e6a1889c461c040066a1889c561c06a18aa307060"),
    (0x1919A, "78606b2600019a9e7a160001 48a05d60".replace(" ", "")),
    (0x19158, "6a10aa307360"),
    (0x103D4, "fbee4006"), (0x103DC, "fbec5e03ff10"), (0x103EE, "fbed40ec"),
    (0x0E5D6, "fc016a8c8994"), (0x0E596, "fc016a8c8995"), (0x0E5AC, "fc066a8c89a0"),
    (0x0E5EE, "fc016a8c89a7"), (0x0E652, "fc206a8c89be"), (0x0E658, "fc426a8c89bf"),
    (0x0E65E, "fc086a8c89c0"), (0x0E664, "fc116a8c89c1"), (0x0E66A, "fc206a8c89c2"),
    (0x0E670, "fca86a8c89c3"), (0x0E67C, "fc056a8c89c4"), (0x0E6C6, "fc046a8c8aab"),
    (0x0E83E, "fc016a8c8d8e"), (0x0E82C, "6a1889c07010"),
    (0x1F4D8, "54706a10a9ee7370"), (0x1F506, "54706a10a9ee7370"), (0x1F4E2, "6a1089c07310"),
]
bad = []
for a, h in CITES:
    h = h.replace(" ", "")
    got = B[a:a + len(h) // 2].hex()
    if got != h:
        bad.append("%06X want %s got %s" % (a, h, got))
if bad:
    open(OUT + "gen_error.txt", "w", encoding="utf-8").write("\n".join(bad) + "\n")
    print("CITE MISMATCH", bad)
    sys.exit(1)

# ------------------------------------------------------------------ reach masks
REACH = {}
for l in open(OUTR + "main-descent/work/reached_insns.tsv", encoding="utf-8"):
    p = l.rstrip("\n").split("\t")
    try:
        REACH[int(p[0], 16)] = int(p[1])
    except ValueError:
        pass

# exit-table gated descent (this lane's ledger term): roots = 0x148A0 + BE16[0x19A9E + 2i], i < 206,
# dispatch 0x1919A..0x191A8 (mov.w @(0x19a9e:32,er6),r6 ; add.l #0x148a0,er6 ; jsr @er6) is H9-reached.
assert all(x in REACH for x in (0x19158, 0x1919A, 0x191A2, 0x191A8))
EXIT_ENTS = sorted(set(0x148A0 + be16(0x19A9E + 2 * i) for i in range(206)))
NEW = {}
todo = list(EXIT_ENTS)
while todo:
    a = todo.pop()
    while True:
        if a in NEW or a in REACH:
            break
        assert not (CW[0] <= a < CW[1]) and a < HI
        n, t, k, tg = flow(a)
        assert n > 0, "undecodable %06X" % a
        NEW[a] = (n, t)
        for x in tg:
            if x not in REACH and x not in NEW:
                todo.append(x)
        if k in ("stop", "stops"):
            break
        a += n
H9M = bytearray(HI)
for a, n in REACH.items():
    for x in range(a, a + n):
        H9M[x] = 1
NEWM = bytearray(HI)
for a, (n, t) in NEW.items():
    for x in range(a, a + n):
        assert not H9M[x], "overlap %06X" % a
        NEWM[x] = 1
NEWBYTES = sum(NEWM)
reached = lambda a: a in REACH or a in NEW

# ------------------------------------------------------------------ inputs: H13 screens, F5 bytes, readers
SCR = {}
for l in open(OUTR + "hidden-settings/screens.tsv", encoding="utf-8"):
    if l.startswith("#") or l.startswith("screen_id"):
        continue
    c = l.rstrip("\n").split("\t")
    SCR[int(c[0], 16)] = c
UNOPENED = [s for s, c in SCR.items() if "NF(writer)" in c[12]]
F5 = {}
for l in open(OUTR + "settings/settings-bytes.tsv", encoding="utf-8"):
    c = l.rstrip("\n").split("\t")
    if c[0] == "region":
        F5H = c
        continue
    F5[(c[0], int(c[1], 16))] = dict(zip(F5H, c))
def f5class(reg, n):
    r = F5[(reg, n)]
    if r["menu_item"]:
        return "attributed"
    if "single" in r["writer"] or "[blk" in r["writer"]:
        return "dedicated-unattributed"
    return "bulk-only"
RD = collections.defaultdict(list)
for l in open(OUT + "readers_raw.tsv", encoding="utf-8"):
    if l.startswith("#") or l.startswith("ea\t"):
        continue
    c = l.rstrip("\n").split("\t")
    RD[int(c[2], 16)].append((int(c[0], 16), c[1], c[3], c[4], c[5]))

REG = [("R1", 0xFF8920, 0x180, 0x580), ("R2", 0xFF8AA0, 0x280, 0xC000), ("R3", 0xFF8D20, 0x180, 0xD000)]
def region(ram):
    for nm, base, ln, eep in REG:
        if base <= ram < base + ln:
            return nm, ram - base, eep + ram - base, eep + ram - base - 0x140
    return None
def ramof(reg, n):
    return {"R1": 0xFF8920, "R2": 0xFF8AA0, "R3": 0xFF8D20}[reg] + n

# ------------------------------------------------------------------ per-screen table slots
def notifier(s): return be32(0x782C + 4 * s)
def dial(s): return be32(0x12268 + 4 * (s - 0x0E)) if 0 <= s - 0x0E < 219 else None
def exith(s): return 0x148A0 + be16(0x19A9E + 2 * (s - 0x0E)) if 0x0E <= s < 0xDC else None
def keytab(s): return 0x125D4 + be16(0x1208C + 2 * (s - 1)) if s >= 1 else None
WRITERS = {0x3CCBC: ("R1", "single"), 0x3CCD0: ("R1", "block"), 0x3CCEC: ("R2", "single"), 0x3CD00: ("R2", "block"),
           0x3CD1C: ("R3", "single"), 0x3CD30: ("R3", "block")}
def parse_exit(e):
    """walk the exit handler (flow + cond branches, no calls followed) and list EEPROM writer calls."""
    saves, seen, todo = [], set(), [e]
    while todo:
        a = todo.pop(); r1 = er1 = r6 = None
        while a not in seen:
            seen.add(a)
            n, t, k, tg = flow(a)
            if n == 0:
                break
            m = re.match(r"mov\.w #(0x[0-9a-f]+),r1$", t)
            if m: r1 = int(m.group(1), 16)
            m = re.match(r"mov\.l #(0x[0-9a-f]+),er1$", t)
            if m: er1 = int(m.group(1), 16)
            m = re.match(r"mov\.w #(0x[0-9a-f]+),r6$", t)
            if m: r6 = int(m.group(1), 16)
            if k in ("call", "stop") and tg and tg[0] in WRITERS:
                reg, kind = WRITERS[tg[0]]
                if kind == "single":
                    saves.append((reg, r1, 1, a))
                else:
                    rr = region(er1)
                    saves.append((rr[0], rr[1], r6, a))
            if k == "cond":
                todo.append(tg[0])
            if k in ("stop", "stops"):
                break
            a += n
    return saves
def fmt_saves(sv):
    return "; ".join("%s n=0x%X%s @%05X" % (r, n, (" x%d" % c) if c > 1 else "", a) for r, n, c, a in sv) or "-"

# ------------------------------------------------------------------ the 32: manual classification (evidence in doc 58)
# kind: bit = bnot r4l,@FF89xx helper (0x17760 + 8*(n-0x9E)) ; rec = {lo,hi,ptr} step record ; none = no editor
O = collections.OrderedDict()
def o(sid, tgt, edit, live, why, label, ev):
    O[sid] = dict(tgt=tgt, edit=edit, live=live, why=why, label=label, ev=ev)
o(0x0E, ("R1", 0xA3, "b5"), "bit toggle: dial 0x15ED0 r4l=5 -> bnot @FF89C3", "dead",
  "leftover: feature code removed (no reader of the bit), notifier rts", "Unknown",
  "readers of FF89C3 test b0,b2,b3 and clear b1 only (readers_raw.tsv); default 0xA8 sets b5=1 (0x0E670)")
o(0x10, ("R1", 0x74, "0..2"), "wrap step 0..2: rec 0x15F10 {00,02,FF8994}", "dead",
  "leftover: no reader, notifier rts", "Unknown",
  "only other ref is default store 0x0E5D8 (=1); no abs16/abs32/base+disp reader")
o(0x11, ("R1", 0xA1, "b4"), "bit toggle: dial 0x15F16 r4l=4 -> bnot @FF89C1", "dead",
  "leftover: no reader of the bit, notifier rts", "Unknown",
  "FF89C1 readers test b0,b2,b3,b6,b7 only; default 0x11 sets b4=1")
o(0x17, ("R1", 0x75, "1..0x15"), "none: dial 0x16032 = rts; the next bytes are record 0x16034 {01,15,FF8995}, used by the live BELL field-2 editor 0x16020",
  "live byte, dead screen", "superseded layout: BELL ringer count is edited by the live BELL screen 0x16 (key table 0x129D0, list editor 0x15FEE)",
  "BELL ringer (F340 frame+0x23)",
  "FF8995 read by BELL notifier 0x4EB4 (cmp #0x15 = CONTI) and 0x32924; 0x16 saves the same n=0x75")
o(0x22, ("R1", 0x80, "byte"), "none: dial 0x160EE = rts (shared stub)", "dead",
  "leftover: no editor, no reader, notifier rts", "Unknown", "only ref default store 0x0E5AE (=6)")
o(0x29, ("R1", 0x9F, "b1"), "bit toggle: dial 0x16208 r4l=1 -> bnot @FF89BF", "dead",
  "leftover: no reader of the bit, notifier rts", "Unknown", "FF89BF readers test b3,b4,b6,b7 only; default 0x42 sets b1=1")
o(0x2A, ("R1", 0x9E, "byte"), "none: dial 0x16210 = rts", "no edit (byte live via other bits)",
  "stub: save-only slot", "Unknown", "exit saves n=0x9E unchanged; FF89BE bits b1,b3,b5,b7 belong to live items")
o(0x2D, ("R1", 0x9E, "byte"), "none: dial 0x163C8 = rts", "no edit (byte live via other bits)",
  "stub: save-only slot", "Unknown", "as 0x2A")
o(0x2E, ("R1", 0xA0, "byte"), "none: dial 0x3FFA0 (consume key)", "no edit (byte live via other bits)",
  "stub: save-only slot", "Unknown", "exit saves n=0xA0 unchanged")
o(0x30, ("R1", 0x9F, "byte"), "none: dial 0x163CA = rts", "no edit (byte live via other bits)",
  "stub: save-only slot", "Unknown", "exit saves n=0x9F unchanged")
o(0x32, ("R1", 0xA3, "b1"), "bit toggle from key table 0x12E10 slot 13 -> 0x16574 r4l=1 -> bnot @FF89C3; slot 0 enters the shared code-entry routine 0x163EA",
  "dead", "factory/test-type screen (Inferred): own key table shares the code-entry routine of screen 0x0C; bit has no tester",
  "Unknown", "FF89C3 b1 is only cleared (0x02DDA bclr #1 in sub_2DCE); no btst/bld of b1")
o(0x33, ("R1", 0xA3, "b6"), "bit toggle: dial 0x165DA r4l=6 -> bnot @FF89C3", "dead",
  "leftover: no reader of the bit, notifier rts", "Unknown", "default 0xA8 -> b6=0")
o(0x34, ("R1", 0xA3, "b4"), "bit toggle: dial 0x165F0 r4l=4 -> bnot @FF89C3, then jsr 0x1E79C", "dead",
  "leftover: no reader of the bit, notifier rts", "Unknown", "default 0xA8 -> b4=0")
o(0x36, ("R1", 0xA0, "b1"), "bit toggle: dial 0x16608 r4l=1 -> bnot @FF89C0", "dead (readers unreachable)",
  "leftover: the two testers sit in unreferenced fragments", "Unknown",
  "FF89C0 b1 tested only at 0x1F4E2/0x1F510 inside fragments 0x1F4DA/0x1F508 (preceded by rts, no xref, no BE32/abs24 ref, not H9-reached); default bset #1 at 0x0E82C")
o(0x3E, ("R1", 0x87, "0..4"), "wrap step 0..4: rec 0x16624 {00,04,FF89A7}", "LIVE",
  "hidden-but-active: value consumed, no menu row, notifier rts", "Inferred: long-press time for one key (index -> 30/50/70/100/150 ticks)",
  "FF89A7 -> table 0x16642 -> key-hold timer FF953F for key code 0x0B (0x0FEE4 cmp #0xB -> 0x0FF2E jsr 0x1662A; other keys load 0x64); and table 0x16660 -> FF958E (0x16648, called 0x1099E/0x1FAAE/0x200C2); default 1 (0x0E5F0)")
o(0x41, ("R1", 0x89, "0x13..0x21"), "saturating step: rec 0x166BA {13,21,FF89A9} (H13)", "dead",
  "leftover (H13 doc 49)", "SUB draws 'LEVEL n' (F316)", "H13: only reader is the F316 sender 0x534C; apply hook nullsub_36")
o(0x49, ("R1", 0x8C, "0..3"), "wrap step 0..3: rec 0x16722 {00,03,FF89AC}", "LIVE",
  "hidden-but-active: value consumed, no menu row, notifier rts", "Inferred: memory-channel jump size (10/20/50/100 channels)",
  "sub_1EDFE: index*4 into 0x1EDEE pairs {9,0x442}{0x13,0x438}{0x31,0x41A}{0x63,0x3E8} -> step AA56 by 10/20/50/100; reached via 0x1ED5E <- array 0x1F8E2 (H3 tier A)")
o(0x4C, ("R1", 0x9F, "b7"), "bit toggle: dial 0x16738 bnot #7,@FF89BF (gated on band mode +5 = 2/5)", "LIVE",
  "superseded layout: the same bit is toggled by sub_28F46 from screen 0x09's key table (slot 5, 0x12808) and saved there", "Inferred: memory-name vs frequency display",
  "readers 0x07300 (sub_72D0), 0x0D786 (sub_D76E), 0x0DACC; set -> skip the 8-word name at record+0x24 / FFAC7C")
o(0x5C, ("R1", 0x96, "0..3"), "wrap step 0..3: rec 0x16B5A {00,03,FF89B6} (H13)", "dead",
  "leftover (H13 doc 49)", "F31A (SUB never draws it)", "H13: only reader is the F31A sender 0x56E6")
o(0x61, ("R1", 0xA0, "b5"), "bit toggle: dial 0x16C46 r4l=5 -> bnot @FF89C0", "dead",
  "leftover: no reader of the bit, notifier rts", "Unknown", "FF89C0 b5 has no tester")
o(0x65, ("R1", 0x97, "0..2"), "wrap step 0..2: rec 0x16E5A {00,02,FF89B7}", "dead",
  "leftover: no reader and no default, notifier rts", "Unknown", "only ref is the record itself (abs32 at 0x16E5C)")
o(0x67, ("R1", 0xA4, "b0"), "bit toggle: dial 0x16E7E r4l=0 -> 0x17790 bnot @FF89C4 (helper is data in the MAIN_H8SX seed; only caller)", "dead",
  "leftover: flag-byte bit 0 has no tester (doc 32 Open 4)", "Unknown", "default 5 -> b0=1")
o(0x6E, ("R1", 0xA3, "b7"), "bit toggle: dial 0x17104 r4l=7 -> bnot @FF89C3; apply hook nullsub_63 (0x446BC)", "dead",
  "leftover: no reader, apply hook emptied", "Unknown", "default 0xA8 -> b7=1")
o(0x77, ("R1", 0x9E, "byte"), "none: dial 0x173D2 = rts", "no edit (byte live via other bits)",
  "stub: save-only slot", "Unknown", "as 0x2A")
o(0x78, ("R1", 0x9F, "b0"), "bit toggle: dial 0x173D4 r4l=0 -> bnot @FF89BF", "dead",
  "leftover: no reader of the bit", "Unknown", "default 0x42 -> b0=0")
o(0x7B, ("R1", 0xA2, "b7"), "bit toggle: dial 0x173E4 r4l=7 -> bnot @FF89C2", "dead",
  "leftover: no reader of the bit", "Unknown", "FF89C2 testers use b0,b1,b4,b6 only")
o(0x80, ("R1", 0xA7, "0..2 (+ record +0x36 b0-1)"), "two-field list editor: key table 0x133E8 slot 13 -> 0x16582 -> sub_15260 via 0x1658C; field1 0x16598 rec {0,2,AA56} -> band record +0x36 b0-1; field2 0x165C0 rec 0x165D4 {00,02,FF89C7}",
  "dead", "removed feature (Inferred): complete screen, SUB has no own label row (falls back to APO); no MAIN consumer of either field",
  "SUB value page MODE OFF/BUSY/SIGNALING + SELECT PATTERN1..3 (F395, doc 38)", "FF89C7 read only by notifier 0x52CC; no default store")
o(0x81, ("R1", 0xA7, "byte"), "none: dial 0x165D2 = rts", "dead",
  "stub: save-only twin of 0x80", "as 0x80", "saves the same n=0xA7 as 0x80")
o(0x97, ("R2", 0x0B, "byte"), "none: dial 0x1791E = jsr 0x3FFA0", "no edit (byte live via other bits)",
  "stub: save-only slot", "Unknown", "FF8AAB bits are used by APRS items 0x90/0x95/0x9C/0xA0 (same save n=0x0B)")
o(0xB9, ("R3", 0x6E, "byte"), "none: dial 0x3FFA0, generic key table", "dead (reader unreachable)",
  "leftover: no editor; only tester is an unreferenced fragment", "Inferred: text-entry character-set switch",
  "FF8D8E read only at 0x1B99C in fragment 0x1B99A (preceded by rts 0x1B998, no xref, no ref, not H9-reached); default 1 (0x0E840)")
o(0xD4, ("R1", 0x94, "b4-6 (0..7)"), "step 0..7 on AA56 (rec 0x1766A) then FF89B4 = (FF89B4&7)|(v<<4); apply hook nullsub_63", "dead",
  "leftover: no reader outside the two dials", "Unknown", "readers of FF89B4: 0x17652..0x176A6 only (the dials and their helpers)")
o(0xD5, ("R1", 0x94, "b0-2 (0..7)"), "step 0..7 on AA56 (rec 0x176A0) then FF89B4 = (FF89B4&0x70)|v; apply hook nullsub_63", "dead",
  "leftover: no reader outside the two dials", "Unknown", "as 0xD4")
assert set(O) == {s for s in UNOPENED if "save" in SCR[s][5]}, sorted(set(O) ^ {s for s in UNOPENED if "save" in SCR[s][5]})

# ------------------------------------------------------------------ write orphans.tsv
log = []
def w(path, rows, hdr):
    with open(OUT + path, "w", encoding="utf-8", newline="\n") as f:
        f.write(hdr + "\n")
        for r in rows:
            f.write("\t".join(str(x) for x in r) + "\n")
rows = []
for s, d in O.items():
    reg, n, bits = d["tgt"]
    ram = ramof(reg, n); _, _, eep, bk = region(ram)
    e = exith(s)
    kt = keytab(s)
    nt = notifier(s)
    rows.append(["0x%02X" % s, "%05X%s" % (nt, " (rts)" if B[nt:nt + 2] == b"\x54\x70" else ""),
                 "%05X" % dial(s), "%05X" % e, fmt_saves(parse_exit(e)), "%05X%s" % (kt, " generic" if kt == 0x12948 else ""),
                 reg, "0x%X" % n, "0x%06X" % ram, "0x%04X" % eep, "0x%04X" % bk, bits, d["edit"], d["live"], d["why"],
                 d["label"], d["ev"], f5class(reg, n)])
w("orphans.tsv", rows, "screen_id\tnotifier_0x782C\tdial_0x12268\texit_0x19A9E\texit_saves\tkey_table\tregion\tn\tram\teeprom\tbackup_dat\tbits_or_range\teditor\tlive_dead\twhy_unopened\tlabel_or_meaning\tevidence\tf5_class_of_byte")

# ------------------------------------------------------------------ other unopened (no single-byte save)
OTHER_NOTE = {
    0x08: "rts notifier, all-3FFA0 key table: empty slot",
    0x19: "exit 0x19444 only clears FFAA30 b6; no save; empty",
    0x21: "16-char text editor (key slot 0 0x1AA46 edits FF8926 x16 via 0x1A94C); exit saves FF8926 x16 + R1 n=0x9E; rts notifier",
    0x23: "exit saves FF8999 x7, FF89C1, R1 n=0xA0; key slots 2/8/13 = rts stub 0x160EE; rts notifier",
    0x24: "exit saves FF89A1, FF89A2, R1 n=0xA0; key slots = rts stub 0x160EE; rts notifier",
    0x25: "rts notifier; key table 0x12C78 shared with 0x42/0x45; no save",
    0x2F: "empty slot", 0x31: "empty slot (navigation-only key table)",
    0x38: "DP-ID LIST edit variant: notifier 0x5E95C sends F364 with FF8DD7; dial rec 0x5E7D2 {0,1,FF8DD7}; exit saves R3 FF8DD7 x5 (live DP-ID LIST is 0x39, direct entry 0x1CEC8)",
    0x3A: "empty slot", 0x3B: "empty slot", 0x3C: "empty slot", 0x3D: "empty slot",
    0x42: "notifier 0x5362 -> 0xA0B6 sends F387 (+0x28/+0x1E words) via 0x7C20; SUB labels it HOME VFO (fallback, G3); no save",
    0x46: "empty slot", 0x47: "empty slot", 0x48: "empty slot",
    0x50: "exit saves FF898A x2 + R1 n=0xA1; key slots 4/6 0x19F8A (record editors 0x1A1AA..), slot 13 rts 0x1693C; rts notifier",
    0x53: "PAGER clone: key table 0x13074 = PAGER 0x52's; exit 0x19584 saves FF8968 x4 + R1 n=0xA3; notifier rts",
    0x54: "PAGER clone (as 0x53)",
    0x69: "dial rec 0x16E9E {0,2,FF8EAD} then sub_24D42 if previous screen = 0x0B; FF8EAD is a live band-mode byte (13 readers); no save; only ref to id is the inert cmp #0x69 at 0x14EEC (doc 32)",
    0x74: "navigation key table, slot 8 0x1A0AC; empty", 0x75: "navigation key table, slot 8 0x1A0B4; empty",
    0x79: "memory editor: key slots 4/6 0x173EC, slot 13 0x17400 writes word FF898C; exit 0x196A0 saves FF898C x2; rts notifier",
    0x7E: "empty slot",
    0x83: "notifier 0x44B36 rts; key slot 4 0x44AC8 bnot #7,@FF8ABE + save 0x19858 (R2 FF8ABE block); slot 13 0x44AEA; no own save",
    0x86: "BACKUP sub-screen dispatcher: notifier 0x6FD0C reads FFADA1 (doc 49 Open 1); all 17 key slots 0x6FD56; no save",
    0x8A: "empty slot",
    0xAA: "exit saves R2 FF8C22 x3; key slots 3/7 list nav, slot 13 0x178AC (table 0x178CA); rts notifier",
    0xAD: "key slots 0/1/4/6/13 = 0x18D12/0x19060/0x18C46/0x18CBA (text editors on FFADDE/FF8CFC); exit rts",
    0xAF: "key slots edit FF8CFC/FFADDE (0x18F4E, 0x18D74, 0x50D7E, 0x50B0A); exit 0x19702 (if FFAA30 b6) saves R2 FF8CFA x12; rts notifier",
    0xB0: "exit 0x198DC saves R3 FF8D20 x2, R3 n=0x6A, R3 n=0xB2; key slot 13 0x5E576 list editor; rts notifier",
    0xB6: "empty slot", 0xBA: "empty slot",
    0xD8: "all-3FFA0 key table, exit rts (pop dispatch maps 0xD8..0xDB specially at 0x1916A)",
    0xD9: "key slot 14 = pop 0x3FF3A only", 0xDA: "key slot 14 = pop 0x3FF3A only",
    0xED: "CORRECTION: opened. Pushed at 0x103DE after mov.b #0xED,r3l at 0x103EE (power-on handler 0x103E6, H9-reached). Notifier 0x6942 = mov.b #1,r3l; jsr 0x85DA (screen 0xEC uses r3l=0). Key slots: 0x0DC40 x16 (sets SP=0xFF7F00, writes 0x20 to FF8000; Inferred restart), slot 7 0x103F2 (zero-fills FF8970-FF8A1B, defaults 0xE58A, saves R1/R2/R3, then 0xDC32)",
    0xEE: "CORRECTION: opened. Pushed at 0x103DE after mov.b #0xEE,r3l at 0x103D4 (power-on handler 0x103C0, H9-reached). Notifier 0x5E9E2 sends F008 via 0x8532 with two bytes chosen from [FFB0C4] (thresholds 5 and 7) and [FF813A]; key slot 3 0x5DCD8",
}
rows = []
for s in sorted(UNOPENED):
    if s in O:
        continue
    nt = notifier(s); e = exith(s); kt = keytab(s); d = dial(s)
    sv = parse_exit(e) if e else []
    rows.append(["0x%02X" % s, "%05X%s" % (nt, " (rts)" if B[nt:nt + 2] == b"\x54\x70" else ""),
                 ("%05X" % d) if d is not None else "-", ("%05X" % e) if e else "-", fmt_saves(sv),
                 ("%05X" % kt) if kt else "-", "yes" if sv else "no", OTHER_NOTE.get(s, "")])
w("other-unopened.tsv", rows, "screen_id\tnotifier_0x782C\tdial_0x12268\texit_0x19A9E\texit_saves_parsed\tkey_table\tcorrection_saves_eeprom\twhat_the_code_shows")
log.append("unopened (H13) %d; 32 single-save orphans; other %d; of these with EEPROM-writing exits %d; corrected-opened 0xED,0xEE"
           % (len(UNOPENED), len(rows), sum(1 for r in rows if r[6] == "yes")))

# ------------------------------------------------------------------ bitfield map R1 0x9E..0xA5 (dial helpers 0x17760 + 8k)
HELP = {0x17760 + 8 * k: 0x9E + k for k in range(8)}
bitrows = []
for s in range(0x0E, 0xDC):
    d = dial(s)
    x = B[d:d + 40]
    for i in range(0, 34, 2):
        if x[i:i + 2] == b"Tp":
            break
        if x[i] == 0xFC and x[i + 2:i + 4] == b"\x5e\x01" and (0x10000 | x[i + 4] << 8 | x[i + 5]) in HELP:
            n = HELP[0x10000 | x[i + 4] << 8 | x[i + 5]]
            bitrows.append(("R1", n, x[i + 1], "0x%02X" % s, "dial %05X" % d, SCR[s][11] if SCR[s][11] != "-" else "", "unopened" if s in UNOPENED else "opened"))
            break
bitrows.append(("R1", 0xA3, 1, "0x32", "key 0x12E10[13] 0x16574", "", "unopened"))
bitrows.append(("R1", 0x9F, 7, "0x4C", "dial 16738 bnot #7", "", "unopened"))
bitrows.append(("R1", 0x9F, 7, "(0x09 key slot 5)", "sub_28F46 bnot #7 + save n=0x9F", "", "opened path"))
bitrows.sort()
w("bitfield-map.tsv", [[r, "0x%X" % n, "0x%06X" % ramof(r, n), "b%d" % b, s, h, l, st] for r, n, b, s, h, l, st in bitrows],
  "region\tn\tram\tbit\tscreen\thandler\tsub_label(G3)\tstatus")

# ------------------------------------------------------------------ settings-bytes-ext.tsv
EXT = collections.OrderedDict()
def add(reg, n, sid, handler, label, live, ev, src):
    k = (reg, n)
    e = EXT.setdefault(k, dict(sids=[], handlers=[], labels=[], live=[], ev=[], src=set()))
    e["sids"].append(sid); e["handlers"].append(handler)
    if label: e["labels"].append(label)
    if live: e["live"].append(live)
    if ev: e["ev"].append(ev)
    e["src"].add(src)
for s, d in O.items():
    reg, n, bits = d["tgt"]
    add(reg, n, "0x%02X" % s, "exit %05X / %s" % (exith(s), d["edit"].split(":")[0]), "%s [%s]" % (d["label"], bits),
        "%s(%s)" % (d["live"], bits), d["ev"], "orphan-32")
for r in rows:
    s = int(r[0], 16)
    if r[6] != "yes" or s in (0xED, 0xEE):
        continue
    for reg, n, c, a in parse_exit(exith(s)):
        for k in range(c):
            add(reg, n + k, r[0], "exit %s @%05X" % (r[3], a), "", "", "block save in unopened screen", "unopened-block")
for s in range(0x0E, 0xDC):
    if s in UNOPENED:
        continue
    lab = SCR[s][11] if SCR[s][11] != "-" else ""
    for reg, n, c, a in parse_exit(exith(s)):
        for k in range(c):
            add(reg, n + k, "0x%02X" % s, "exit %05X @%05X" % (exith(s), a), lab, "live screen", "", "live-exit")
ext_rows = []; cnt = collections.Counter(); cnt_bytes = collections.defaultdict(set)
for (reg, n), e in sorted(EXT.items()):
    if (reg, n) not in F5:
        continue
    ram = ramof(reg, n); _, _, eep, bk = region(ram)
    cl = f5class(reg, n)
    src = "+".join(sorted(e["src"]))
    ext_rows.append([reg, "0x%X" % n, "0x%06X" % ram, "0x%X" % eep, "0x%X" % bk, ",".join(e["sids"]), " | ".join(e["handlers"]),
                     " | ".join(sorted(set(e["labels"]))), " | ".join(sorted(set(e["live"]))), " | ".join(sorted(set(e["ev"]))), src, cl])
    for sname in e["src"]:
        cnt_bytes[(sname, cl)].add((reg, n))
w("settings-bytes-ext.tsv", ext_rows, "region\tn\tram_addr\teeprom_addr\tbackup_off\tscreen_id\thandler\tlabel\tlive_dead\tevidence\tsource\tf5_class")
f5_663 = {k for k in F5 if f5class(*k) == "dedicated-unattributed"}
orph = {k for k, e in EXT.items() if "orphan-32" in e["src"]}
unb = {k for k, e in EXT.items() if "unopened-block" in e["src"]}
lv = {k for k, e in EXT.items() if "live-exit" in e["src"]}
lvl = {k for k, e in EXT.items() if "live-exit" in e["src"] and e["labels"]}
log.append("F5 dedicated-unattributed %d" % len(f5_663))
log.append("orphan-32 bytes %d, of which in F5's 663: %d (%s)" % (len(orph), len(orph & f5_663), " ".join("%s:%X" % k for k in sorted(orph & f5_663))))
log.append("unopened-block bytes %d, in 663: %d" % (len(unb), len(unb & f5_663)))
log.append("live-exit bytes %d, in 663: %d; with a G3 label %d, in 663: %d" % (len(lv), len(lv & f5_663), len(lvl), len(lvl & f5_663)))
U = (orph | unb | lv) & f5_663
log.append("union attributed to a screen, in 663: %d; still unattributed: %d" % (len(U), len(f5_663) - len(U)))
log.append("of the union, new beyond orphan-32: %d" % len(U - orph))

# ------------------------------------------------------------------ ledger delta + runs
runs = []; s0 = None
for x in range(HI + 1):
    v = NEWM[x] if x < HI else 0
    if v and s0 is None: s0 = x
    if not v and s0 is not None: runs.append((s0, x)); s0 = None
DEM = {}
for l in open(OUTR + "main-descent/demoted.tsv", encoding="utf-8"):
    if l.startswith("#") or l.startswith("start"): continue
    c = l.rstrip("\n").split("\t")
    for x in range(int(c[0], 16), int(c[1], 16)): DEM[x] = (c[3], c[4], c[7])
cls = collections.Counter()
for x in range(HI):
    if NEWM[x]:
        cls[DEM.get(x, ("not-demoted", runtype(x) or "untyped", "-"))] += 1
rrows = []
for a, b_ in runs:
    c = collections.Counter(DEM.get(x, ("not-demoted", runtype(x) or "untyped", "-")) for x in range(a, b_))
    rrows.append(["%06X" % a, "%06X" % b_, b_ - a, "; ".join("%s/%s/%s:%d" % (k[0], k[1], k[2], v) for k, v in c.items())])
w("exit-table-new-insns.tsv", [["%06X" % a, n, B[a:a + n].hex(" "), t] for a, (n, t) in sorted(NEW.items())], "addr	len	bytes	text")
w("exit-table-runs.tsv", rrows, "start\tend\tbytes\th9_status(addend/class/named_after:bytes)")
outside_named = sum(v for k, v in cls.items() if k[2] == "leaves") + sum(v for k, v in cls.items() if k[0] == "not-demoted" and k[1] == "other")
led = [
    ["MAIN proven code, H9", "", "365570", "main-descent/ledger-delta.tsv", ""],
    ["exit/save table 0x19A9E (BE16 rel. 0x148A0) gated descent", "+%d" % NEWBYTES, "", "exit-table-runs.tsv, exit-table-new-insns.tsv",
     "%d roots (%d already H9-reached), %d new insns, 0 overlap with H9 reach mask (asserted), IDA h8sxa length check 383/383" % (len(EXIT_ENTS), sum(1 for e in EXIT_ENTS if e in REACH), len(NEW))],
    ["MAIN proven code, H9 + I6", "", str(365570 + NEWBYTES), "", ""],
    ["MAIN named/typed, H9", "", "497139", "main-descent/ledger-delta.tsv", ""],
    ["joins named: new proven bytes outside H9's named masks", "+%d" % outside_named, "", "exit-table-runs.tsv",
     "H9 'RC junk -> leaves' bytes re-proven + W2-8 'other' 0x19762-0x19763 (rts)"],
    ["MAIN named/typed, H9 + I6", "", str(497139 + outside_named), "", ""],
    ["Headline numerator (rule of RESUME-FULL: MAIN named + SUB 464,166)", "+%d" % outside_named, str(961305 + outside_named), "", "of 1,029,972"],
]
w("ledger-delta.tsv", led, "term\tdelta_bytes\tvalue\tsource\tnote")
log.append("exit descent new bytes %d in %d runs; class %s" % (NEWBYTES, len(runs), dict(cls)))
log.append("checks ok: %d" % len(CITES))
open(OUT + "gen_log.txt", "w", encoding="utf-8").write("\n".join(log) + "\n")
print("\n".join(log))
