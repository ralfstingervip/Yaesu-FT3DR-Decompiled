# Repository layout: this script lives under ida/out/; paths below are derived from its location.
from pathlib import Path as _Path
_HERE = _Path(__file__).resolve().parent
_REPO = _Path(__file__).resolve().parents[4]
# I9: write the machine tables under ida\out\suspect-tables\ and byte-verify every key cite from the image.
# Inputs: decrypted MAIN image, H9 oracle/pickles (via i9_masks.py / i9_descent.py pickles in the I9 scratchpad),
# H9 demoted.tsv, the I9 IDA probe (work\ida_probe.tsv). Read-only on every input.
import sys, pickle, re, collections
sys.dont_write_bytecode = True
sys.path.insert(0, str(_REPO / "ida/out/main-descent/offline"))
import descent as D9
from common import IMG, HI, CW, be32, BU
SCR = (str(_HERE / "local-temp") + "/")
OUT = (str(_REPO / "ida/out/suspect-tables") + "/")
M = pickle.load(open(SCR + "i9_masks.pkl", "rb"))
P = pickle.load(open(SCR + "i9_descent.pkl", "rb"))
base = D9.run("full"); R = base["reached"]
ext = D9.run("full", extra_seeds=P["extra"]); RX = ext["reached"]
ends = {a + v[0]: a for a, v in R.items()}
IDA = {}
for ln in open(OUT + "work/ida_probe.tsv", encoding="utf-8").read().splitlines()[1:]:
    c = ln.split("\t"); IDA.setdefault(int(c[0], 16), c)
CHK = [0]
def vb(addr, hexbytes):
    b = bytes.fromhex(hexbytes.replace(" ", ""))
    assert IMG[addr:addr + len(b)] == b, ("byte check failed", hex(addr), hexbytes, IMG[addr:addr + len(b)].hex())
    CHK[0] += 1
    return hexbytes
def hx(a, n): return IMG[a:a + n].hex(" ")
def oracle(a): return BU.get(a, (0, "-"))[1]
def w(name, header, rows):
    with open(OUT + name, "w", encoding="utf-8", newline="\n") as f:
        f.write("\t".join(header) + "\n")
        for r in rows: f.write("\t".join(str(x) for x in r) + "\n")

# ---------------------------------------------------------------- 1. the three tables
TABLES = [
    (0x02941C, 8, 0x029406, "6a 0b b9 e4 7a 63 00 00 00 ff 10 73 78 b0 6b 26 00 02 94 1c 59 60", 0xFFB9E4,
     "0..7 (immediates at 0x01C610 0, 0x02945E 1, 0x0294E2 2, 0x029582 3, 0x02955A 4, 0x029600 5, 0x0294F0 6, 0x029596 7, plus others)",
     "none in the dispatcher; every writer stores an immediate 0..7", "code-pointer table (pure); targets 4/5 pass key records 0x0296E8/0x029712 (mixed: data + code pointers) to 0x028CBC"),
    (0x0357CC, 7, 0x035704, "6a 0b aa d0 7a 63 00 00 00 ff 10 73 78 b0 6b 26 00 03 57 cc 59 60", 0xFFAAD0,
     "0..6: written only at 0x0347D8/0x035DE6 from sub_3F5B2 range lookup over band maps 0x03510A (5 rows, values 0..4) and 0x035140 (2 rows, values 5..6)",
     "indirect: the writer is guarded by sub_3F5EE range checks (0x034794/0x035DB4) so a row always matches (Inferred); the fall-out defaults would be 0x99 / 0x02",
     "code-pointer table (pure); 7 case labels inside the dispatcher's own function body"),
    (0x07308C, 4, 0x073076, "6a 0b bb 90 7a 63 00 00 00 ff 10 73 78 b0 6b 26 00 07 30 8c 59 60", 0xFFBB90,
     "0..3: immediates 1 (0x0730B8), 2 (0x073106, 0x073352), 3 (0x0730CA, 0x0730E2, 0x073124); 0 = cleared RAM",
     "none in the dispatcher; every writer stores an immediate 1..3", "code-pointer table (pure); state machine of 4 states"),
]
srows = []; erows = []
for T, n, disp, dbytes, cell, vals, bound, verdict in TABLES:
    vb(disp, dbytes)
    lost = len(P["lost"][T])
    srows.append(("%06X" % T, "%06X" % (T + 4 * n), n, 4 * n, "%06X" % disp, dbytes, "%06X" % cell, vals, bound, verdict,
                  lost, "all %d targets IDA code heads in I9_MAIN (h8sxa, MAIN_H8SX seed); H9's notIDAcode %s B came from H1_RECOUNT (h8s300a lineage)" % (n, {0x02941C: "56 (0x028682-0x0286A6, 0x02943C-0x029446, 0x029708-0x029712)", 0x0357CC: "20 (0x03571A-0x03572E)", 0x07308C: "36 (0x073280-0x0732A4: target of nested table 0x073162, not IDA code in I9_MAIN either)"}[T]),
                  "none: stays one of the 149; 0 B change to proven/named"))
    for i in range(n):
        s = T + 4 * i; t = be32(s)
        ik = IDA.get(t, ["", "", "?"])[2]
        erows.append(("%06X" % T, i, "%06X" % s, hx(s, 4), "%06X" % t, "even" if t % 2 == 0 else "ODD",
                      "yes" if t in R else "no", "yes" if t in base["reached"] and ends.get(t) is None or True else "", ik,
                      hx(t, 6), oracle(t)))
w("suspect-tables.tsv", ["table", "end", "entries", "bytes", "dispatch_site", "dispatch_bytes", "index_cell", "index_values", "bound_check",
                         "verdict", "bytes_reached_only_via_table", "ida_status", "correction_to_149"], srows)
w("table-entries.tsv", ["table", "slot", "slot_addr", "slot_bytes", "target", "align", "target_is_insn_head_in_H9_descent", "-", "ida_kind_I9_MAIN",
                        "target_bytes", "oracle_insn"], [r[:7] + r[8:] for r in erows])

# ---------------------------------------------------------------- 2. key records consumed by 0x028CBC
CONS = {0x00: "0x028D0C mov.l @(0x0:16,er1),er6 ; 0x028D12 jsr @er6 (keys 10..19)", 0x04: "0x028D24 mov.l @(0x4:16,er1),er6 ; beq (null) ; 0x028D2C jsr @er6 (key 0x14)",
        0x08: "0x028D40 ... 0x028D46 jsr @er6 (keys 4,5)", 0x0C: "0x028D4A ... 0x028D50 jsr @er6 (key 3)", 0x10: "not loaded by 0x028CBC",
        0x14: "0x028D86 ... 0x028D8C jsr @er6 (key 6)", 0x18: "0x028D90 ... 0x028D96 jsr @er6 (key 7)", 0x1C: "not loaded by 0x028CBC"}
vb(0x028D0C, "01 00 6f 16 00 00 5d 60"); vb(0x028D24, "01 00 6f 16 00 04 47 6e 5d 60"); vb(0x028D40, "01 00 6f 16 00 08 5d 60")
vb(0x028D4A, "01 00 6f 16 00 0c 5d 60"); vb(0x028D86, "01 00 6f 16 00 14 5d 60"); vb(0x028D90, "01 00 6f 16 00 18 5d 60")
vb(0x0296DE, "7a 01 00 02 96 e8 58 00 f5 d4"); vb(0x029708, "7a 01 00 02 97 12 58 00 f5 aa")
rrows = []
for rec, gate in ((0x0296E8, 0x0296DE), (0x029712, 0x029708)):
    for off in range(0, 0x20, 4):
        v = be32(rec + off)
        st = "null" if v == 0 else ("reached by H9" if v in R else ("newly reached (I9)" if v in RX else "unreached"))
        rrows.append(("%06X" % rec, "%06X" % gate, "+%02X" % off, hx(rec + off, 4), "%06X" % v, CONS[off], st))
w("record-fields.tsv", ["record", "loaded_by", "field", "bytes", "value", "consumer", "target_status"], rrows)

# ---------------------------------------------------------------- 3. new edges and newly proven bytes
vb(0x034C24, "5e 00 04 50"); vb(0x000454, "7a 05 00 00 07 06 55 d0"); vb(0x00042C, "01 00 6b 85 81 1a")
vb(0x0028D0, "01 20 6d f4 7f c5 72 00 2c 40 01 00 6b 06 81 1a 59 60"); vb(0x000A86, "01 20 6d 76 56 70")
vb(0x0178F0, "7a 01 00 01 a0 84 5e 01 52 06"); vb(0x015224, "5d 10")
EDGES = [
    (0x029732, "record 0x0296E8/0x029712 +00", "0x0296DE 7a 01 00 02 96 e8 ; bra 0x028CBC ; 0x028D0C 01 00 6f 16 00 00 ; 0x028D12 5d 60 jsr @er6"),
    (0x05E33E, "record 0x0296E8 +08", "0x0296DE ; 0x028D40 01 00 6f 16 00 08 ; 0x028D46 jsr @er6"),
    (0x05E37C, "record 0x029712 +08", "0x029708 7a 01 00 02 97 12 ; 0x028D40 ; 0x028D46 jsr @er6"),
    (0x029764, "record 0x0296E8/0x029712 +0C", "0x028D4A 01 00 6f 16 00 0c ; 0x028D50 jsr @er6"),
    (0x000706, "RAM hook 0xFF811A (vector 88)", "0x034C24 jsr @0x450 ; 0x000454 7a 05 00 00 07 06 mov.l #0x706,er5 ; 0x00045A bsr 0x42c ; 0x00042C 01 00 6b 85 81 1a mov.l er5,@0xFF811A ; vector 88 stub 0x0028D0 stm.l er4-er6 ... 0x0028DA mov.l @0xFF811A,er6 ; 0x0028E0 jmp @er6; body exits ldm.l er4-er6 ; rte"),
    (0x01A084, "er1 callback of sub_15206", "0x0178F0 7a 01 00 01 a0 84 mov.l #0x1a084,er1 ; 0x0178F6 jsr @0x15206 ; 0x015224 5d 10 jsr @er1 (er1 not written on that path)"),
]
dem = []
for ln in open(str(_REPO / "ida/out/main-descent/demoted.tsv"), encoding="utf-8").read().splitlines():
    if ln.startswith("#") or ln.startswith("start"): continue
    c = ln.split("\t"); dem.append((int(c[0], 16), int(c[1], 16), c[3], c[4], c[6]))
def h9stat(x):
    for s, e, ad, cl, row in dem:
        if s <= x < e: return "H9-demoted %s (%s%s)" % (ad, cl, ", F1 row " + row if row != "-" else "")
    return "never proven"
new = set(P["new"])
def spans(f, lo=0, hi=HI):
    out = []; x = lo
    while x < hi:
        if f(x):
            s = x
            while x < hi and f(x): x += 1
            out.append((s, x))
        else: x += 1
    return out
erows2 = []
for tgt, kind, chain in EDGES:
    erows2.append(("%06X" % tgt, kind, chain, len(P["attr"].get(tgt, [])), "Confirmed", "I8 domain (indirect jmp/jsr @ERn); union by byte mask"))
w("new-edges.tsv", ["target", "edge", "gate_chain_bytes", "bytes_reached_by_this_seed_alone", "label", "overlap_note"], erows2)
nrows = []; tot = collections.Counter()
for s, e in spans(lambda x: x in new):
    # split by H9 status and named state
    x = s
    while x < e:
        k = (h9stat(x), M["NAMED"][x]); y = x
        while y < e and (h9stat(y), M["NAMED"][y]) == k: y += 1
        nrows.append(("%06X" % x, "%06X" % y, y - x, k[0], "yes" if k[1] else "no", hx(x, min(8, y - x))))
        tot["proven"] += y - x; tot["named"] += 0 if k[1] else y - x
        x = y
w("new-proven-bytes.tsv", ["start", "end", "bytes", "h9_status", "in_named_H9", "first_bytes"], nrows)
assert tot["proven"] == sum(1 for x in new if not M["PROV"][x]) == len(new)
assert tot["named"] == sum(1 for x in new if not M["NAMED"][x])
assert all(not M["RM"][x] for x in new)

# ---------------------------------------------------------------- 4. ledger
PV, NV = 365570, 497139
assert sum(M["PROV"]) == PV and sum(M["NAMED"]) == NV
U = bytearray(M["PROV"])
for x in new: U[x] = 1
UN = bytearray(M["NAMED"])
for x in new: UN[x] = 1
w("ledger-delta.tsv", ["term", "delta_bytes", "value", "source", "note"], [
    ("MAIN proven code, H9", "", PV, "main-descent/ledger-delta.tsv; mask rebuilt by offline/i9_masks.py", "reproduced byte for byte (365,570)"),
    ("new edges: key records 0x0296E8/0x029712 via 0x028CBC", "+%d" % len([x for x in new if x not in set(P['attr'][0x000706]) | set(P['attr'][0x01A084])]), "", "new-proven-bytes.tsv", "0x029732 36, 0x029764 8, 0x05E33E 56, 0x05E37C 56, 0x01BEF2 70"),
    ("new edge: RAM hook 0xFF811A <- 0x000706 (installed through helper 0x00042C)", "+%d" % len(P["attr"][0x000706]), "", "new-proven-bytes.tsv", "0x000706-0x000A8C; re-proves H9 RC 0x000706.. and F1 rows 0x000760/0x000800"),
    ("new edge: er1 callback 0x01A084 via sub_15206", "+%d" % len(P["attr"][0x01A084]), "", "new-proven-bytes.tsv", "0x01A084-0x01A08C"),
    ("MAIN proven code, I9", "+%d" % len(new), sum(U), "asserted = byte union of H9 proven mask and I9 new bytes", "%.2f%% of 505,684; %.2f%% of 388,490 decodable" % (100 * sum(U) / 505684, 100 * sum(U) / 388490)),
    ("MAIN named/typed, H9", "", NV, "main-descent/ledger-delta.tsv; mask rebuilt by offline/i9_masks.py", "reproduced byte for byte (497,139)"),
    ("joins named: newly reached bytes outside H9 named mask", "+%d" % tot["named"], "", "new-proven-bytes.tsv in_named_H9=no", "0x000706 span 63 B (H9 'leaves' junk/D code), 0x01BEF2 span 66 B"),
    ("MAIN named/typed, I9", "+%d" % tot["named"], sum(UN), "asserted = byte union", "%.2f%% of 505,684" % (100 * sum(UN) / 505684)),
    ("three suspect tables reclassified", "0", "", "suspect-tables.tsv", "all three are code-pointer tables; no change to the 149 or to any mask"),
    ("EEPROM cache 0x1A080 -> 0xFF476E (RAM)", "0", "", "eeprom-cache.tsv", "not a ROM copy; ROM 0x01A080 bytes keep their H9 status except the 8 B above"),
])

# ---------------------------------------------------------------- 5. EEPROM cache
for a, b in [(0x03DE24, "79 06 00 48 7a 00 00 01 a0 00 7a 01 00 ff 47 26 5e 03 bd ac"), (0x03DE38, "79 06 08 98 7a 00 00 01 a0 80 7a 01 00 ff 47 6e 5e 03 bd ac"),
             (0x03DE56, "79 06 00 48 7a 00 00 01 a0 00 7a 01 00 ff 47 26 5e 03 bf 4c"), (0x03DE6A, "79 06 08 98 7a 00 00 01 a0 80 7a 01 00 ff 47 6e 5e 03 bf 4c"),
             (0x03DE9A, "7a 00 00 01 a0 80 7a 01 00 ff 47 6e 40 2a"), (0x03DED2, "79 06 00 02 0d 34 52 64 0a c0 0a c1 69 1c"), (0x03DEFE, "69 94 5e 03 bf 4c"),
             (0x03DF20, "7a 00 00 01 a0 80 7a 01 00 ff 47 6e 40 2a"), (0x03DF64, "69 14"), (0x00E55A, "79 06 08 98 7a 05 00 ff 47 6e fb 00 68 db 0b 05 1b 56 46 f8 5e 03 de 52"),
             (0x00EF8C, "5e 03 de 20 54 70"), (0x03C3AC, "fd a2"), (0x03BE1C, "fd a3"), (0x03ABF0, "fd a1"), (0x03B180, "fd a0"), (0x05E6CA, "6a 0c 8e d6 ac 64"),
             (0x05E6DA, "6a 0c 8e d7 ac 64"), (0x03A5C2, "5e 03 df 1c"), (0x03A832, "5e 03 de 96"), (0x002152, "79 04 04 ae 7a 05 00 07 b2 a6 7a 06 00 ff 60 34 7b d4 59 8f"),
             (0x002132, "7a 06 00 00 00 00 7a 04 00 ff 73 00 7a 05 00 fe e0 00")]:
    vb(a, b)
w("eeprom-cache.tsv", ["role", "address", "bytes", "detail"], [
    ("bulk load (boot)", "03DE20", hx(0x03DE20, 0x30), "EEPROM 0x1A000 len 0x48 -> RAM 0xFF4726; EEPROM 0x1A080 len 0x898 -> RAM 0xFF476E; reader sub_3BDAC (I2C dev 0xA2/0xA3)"),
    ("caller of bulk load", "00EF8C", hx(0x00EF8C, 4), "last call of sub_ED16 (settings load); sub_ED16 called from boot 0x00DD06 and from 0x0452BC (via 0x010594)"),
    ("bulk save", "03DE52", hx(0x03DE52, 0x30), "same two ranges written back with sub_3BF4C (I2C write)"),
    ("caller of bulk save", "00E56E", hx(0x00E546, 0x2C), "reset-to-defaults sub_DEFA: zero 0xFF4726[0x48] and 0xFF476E[0x898], then save (EEPROM markers invalid path 0x00DCD4)"),
    ("slot write-through", "03DE96", hx(0x03DE96, 0x10), "er0=0x1A080+2n, er1=0xFF476E+2n (n = 16-bit r3); compares with 0xFF8ED6/D7 (or D8/D9 if 0xFF817E b0); if different: 0x03DEFE mov.w r4,@er1 then 2-byte EEPROM write"),
    ("slot read", "03DF1C", hx(0x03DF1C, 0x10), "loads slot n word into 0xFF8ED6/D7 (or 0xFF8ED8/D9)"),
    ("header word write/read", "03DE84 / 03DF0A", hx(0x03DE84, 0x10), "EEPROM 0x1A000+2*r3l <-> 0xFF4726 (header block, 0x48 B)"),
    ("band arrays write/read", "03DEA8 / 03DF2E", hx(0x03DEA8, 0x10), "EEPROM 0x1A018 / 0x1A030 (+2*band) <-> 0xFF473E / 0xFF4756"),
    ("channel save path", "03A832", hx(0x03A832, 4), "jsr 0x3DE96 after the 32-byte channel record write (sub_3AD20)"),
    ("channel load path", "03A5C2 / 03A604", hx(0x03A5C2, 4), "jsr 0x3DF1C next to the 32-byte channel record read (sub_3AB80, EEPROM 0x2E80+0x20*n)"),
    ("value range", "05E6CA / 05E6DA", hx(0x05E6CA, 6), "each byte of the working word clamped to < 100 (cmp.b #0x64); Inferred: per-channel pair of 0..99 values, consistent with DG-ID TX/RX"),
    ("I2C device bytes", "03C3AC / 03BE1C", "fd a2 / fd a3", "bank 1 (EEPROM 0x10000-0x1FFFF): 0xA2 write, 0xA3 read; bank 0 uses 0xA0 (0x03B180) / 0xA1 (0x03ABF0); address bytes r0h, r0l"),
])

# ---------------------------------------------------------------- 6. ROM -> RAM copies (eepmov scan, reached code)
rows = []
for a in sorted(R):
    t = R[a][1]
    if not t.startswith("eepmov"): continue
    src = dst = None; r4 = r4l = r4h = None; x = a; steps = 0
    while steps < 12:
        x = ends.get(x)
        if x is None: break
        tt = R[x][1]; steps += 1
        m = re.match(r"mov\.l #(0x[0-9a-f]+),er(\d)$", tt)
        if m:
            v = int(m.group(1), 16)
            if m.group(2) == "5" and src is None: src = v
            if m.group(2) == "6" and dst is None: dst = v
            if m.group(2) == "4" and r4 is None and r4l is None and r4h is None: r4 = v & 0xFFFF
        m = re.match(r"mov\.w #(0x[0-9a-f]+),r4$", tt)
        if m and r4 is None and r4l is None and r4h is None: r4 = int(m.group(1), 16)
        m = re.match(r"mov\.b #(0x[0-9a-f]+),r4([lh])$", tt)
        if m and r4 is None:
            if m.group(2) == "l" and r4l is None: r4l = int(m.group(1), 16)
            if m.group(2) == "h" and r4h is None: r4h = int(m.group(1), 16)
        if R[x][2] in ("stop", "stops", "call"): break
    if t.startswith("eepmov.b"): cnt = r4l if r4l is not None else (r4 & 0xFF if r4 is not None else None)
    else: cnt = r4 if r4 is not None else ((r4h << 8 | r4l) if (r4l is not None and r4h is not None) else None)
    if src is not None and src < 0x7B754 and dst is not None and dst >= 0xFE0000:
        inw = CW[0] <= src < CW[1]
        rows.append(("%06X" % a, t, "%06X" % src, "%06X" % (src + cnt) if cnt is not None else "?", "%06X" % dst, "%06X" % (dst + cnt) if cnt is not None else "?",
                     "%#x" % cnt if cnt is not None else "?", "closed window: edge only" if inw else ""))
rows.insert(0, ("002148", "loop mov.l er6,@er5", "-", "-", "FEE000", "FF7300", "0x9300", "boot RAM clear (zero) 0xFEE000-0xFF72FF; 0x002132 and again 0x0024FE (vector 67 entry)"))
w("ram-copies.tsv", ["site", "insn", "src", "src_end", "dst", "dst_end", "len", "note"], rows)
print("ROM->RAM eepmov sites", len(rows) - 1, "with known length", sum(1 for r in rows[1:] if r[6] != "?"))
print("checks ok:", CHK[0])
print("new proven", len(new), "named join", tot["named"], "proven", sum(U), "named", sum(UN))
