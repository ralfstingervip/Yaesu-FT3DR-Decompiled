r"""Lane H13 - build ida\out\hidden-settings\screens.tsv and readers.tsv.

Plain read-only Python over decrypted\*.bin plus earlier lanes' TSVs
(sub-labels\f3xx-codes.tsv, main-banks\ipc-opcodes.tsv). Re-reads every cited
byte run first and aborts on any mismatch.

    python "ida/jobs/h13_gen_tables.py"
"""
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root
import os, struct, sys
ROOT = str(_REPO)
OUT = os.path.join(ROOT, "ida", "out", "hidden-settings")
M = sys.exit("The firmware image is not in this repository.")
S = sys.exit("The firmware image is not in this repository.")
SB = 0xFFC00000
L = lambda a: struct.unpack(">I", M[a:a + 4])[0]
W = lambda a: struct.unpack(">H", M[a:a + 2])[0]

# ---- cited byte runs (MAIN unless address >= SB) ----
CHECKS = [
    (0x0534C, "6a0b89a9fc1318cb6df3790bf3165e00976a6d735470"),   # F316 sender (screen 0x41)
    (0x056E6, "790bf31a6a0b89b65e00976a5470"),                     # F31A sender (screen 0x5C)
    (0x0E58A, "fc196a8c89a9"),                                     # FF89A9 default 0x19
    (0x166AA, "7a06000166ba5e03f6005e0069a65470132100ff89a9"),     # screen 0x41 dial handler + record
    (0x069A6, "5470"),                                             # nullsub_36
    (0x16B4E, "7a0600016b5a5e03f6285470000300ff89b6"),             # screen 0x5C dial handler + record
    (0x166A4, "000a00ff89aa"),                                     # LAMP record for comparison
    (0x3F600, "01006f650002685b"),                                 # sub_3F600 saturating step
    (0x3F628, "6a18aa307060"),                                     # loc_3F628 wrapping step
    (0x07930, "0000534c"), (0x0799C, "000056e6"),                  # 0x782C slots 0x41 / 0x5C
    (0x12334, "000166aa"), (0x123A0, "00016b4e"),                  # 0x12268 slots 0x41 / 0x5C
    (0x0481C, "78b06b260000782c"), (0x04DE4, "78b06b260000782c"),
    (0x06C6E, "78b06b260000782c"), (0x06E92, "78b06b260000782c"),
    (0x15E42, "6e0b0001abb3"), (0x15E5C, "fc0e18cb5470"),          # screen - 0x0E
    (0x15E30, "78b06b2600012268"),
    (0x29AA0, "6e0b00011a0b7a63000000ff103378306b250001208c"),     # key-table word index screen-1
    (0x29ABC, "7a15000125d4"),
    (0x29A8C, "6e8b0001"),                                         # screen = row code
    (0x3FF10, "6e0c00016e8c00006e8b00015470"),                     # push
    (0x3FF3A, "6e0c0001ac0e451eacdc441a"),                         # pop range check
    (0x3FF6A, "6e0b00006e8b0001fc006e8c00005470"),                 # pop tail
    (0x3FF02, "6a0c90f16a8c90f06a8b90f15470"),                     # push on FF90F0
    (0x3FF1E, "6e5c00016edc00006edb0001"),                         # push on er5
    (0x14924, "5e02407cfb0c5e03ff10"), (0x14940, "5e02407cfb0c5e03ff10"),
    (0x14BA6, "5e03ff6afb0c5e03ff10"), (0x14B42, "5e03ff6afb0d5e03ff10"),
    (0x14B04, "ac0c46086a1089c47330473e"),                         # group 13 gate (FF89C4 b3)
    (0x14C90, "6a0c8f2eac01"), (0x14CD8, "78c06b2500014d6a"), (0x14CEE, "78c06b2500014daa"),
    (0x14EE4, "78306a2b0001515cab69"),
    (0x1515C, "8e8468403f285170c000"),
    (0x023112, "78406a2b00023144"), (0x02311C, "78406a2b00023156"),
    (0x02CA90, "6e2b3bc6"), (0x06FD1A, "6a0cada16e8c0001"),
    (0x04E24, "6a18aa3c70106a18ad6970705e009562"),                 # screen 0x0C notify stub -> F300 builder 0x9562
    (0x192C4, "790100895a03ccbc"),                                 # exit handler screen 0x41: save R1 n=0x89
    (0x19312, "790100965a03ccbc"),                                 # exit handler screen 0x5C: save R1 n=0x96
    (0x1919A, "78606b2600019a9e7a16000148a05d60"),                 # sub_19158 exit dispatch
    (0x3FF46, "5e019158"),                                         # pop -> exit dispatch
    (0x148AE, "6a83ad6bfc026a8cad6a5e014c72"),                     # sub_148A0 direct entry
    (0x1F2C0, "fb8cf3015e0148a0"),                                 # direct entry of 0x8C (TX POWER)
    (0xFFEFE74F, "75511a200c"),                                   # SUB store: code 0x1A -> 1-byte latch
    (0xFFF00A8F, "61f1"),                                          # SUB clamp for code 0x16 (doc 44)
    (0xFFF0C2CE, "755ef8"),                                        # SUB F8xx path (not F3)
]


def chk():
    n = 0
    for a, hx in CHECKS:
        b = bytes.fromhex(hx)
        got = S[a - SB:a - SB + len(b)] if a >= SB else M[a:a + len(b)]
        if got != b:
            sys.exit("MISMATCH at %X: want %s got %s" % (a, hx, got.hex()))
        n += 1
    return n


def tsv(path):
    rows, hdr = [], None
    for ln in open(path, encoding="utf-8"):
        if ln.startswith("#") or not ln.strip():
            continue
        p = ln.rstrip("\n").split("\t")
        if hdr is None:
            hdr = p
            continue
        rows.append(dict(zip(hdr, p)))
    return rows


def main():
    n = chk()
    f3 = {}
    for r in tsv(os.path.join(ROOT, "ida", "out", "sub-labels", "f3xx-codes.tsv")):
        try:
            f3[int(r["main_row_code"], 16)] = r
        except Exception:
            pass
    builders = {}
    for r in tsv(os.path.join(ROOT, "ida", "out", "main-banks", "ipc-opcodes.tsv")):
        try:
            builders[int(r["sender_addr"], 16)] = r["opcode"]
        except Exception:
            pass
    generic = {0x976A: "sub_976A", 0x9792: "sub_9792", 0x98CA: "sub_98CA", 0x9922: "sub_9922",
               0x9A54: "sub_9A54", 0x9BDA: "sub_9BDA", 0x9C16: "sub_9C16", 0x9C52: "sub_9C52",
               0x97DC: "sub_97DC", 0x9D82: "sub_9D82"}

    def stub_ops(a):
        ops, calls = [], []
        p = a
        while p < a + 0x60:
            b = M[p:p + 4]
            if b[:2] == b"\x54\x70":
                break
            if b[0] == 0x79 and b[1] == 0x0B and b[2] >= 0xF0:
                ops.append("%02X%02X" % (b[2], b[3]))
            if b[0] in (0x5E, 0x5A):
                t = (b[1] << 16) | (b[2] << 8) | b[3]
                if t in builders:
                    ops.append(builders[t])
                calls.append(generic.get(t, "%05X" % t))
            p += 2
        return ops, calls

    recs = [(W(0x15102 + 6 * i), L(0x15102 + 6 * i + 2)) for i in range(15)]
    tabs = [L(0x14D6A + 4 * g) for g in range(13)]
    sub1 = [L(0x14DAA + 4 * k) for k in range(3)]
    order = [(0, tabs[0])] + [(1, t) for t in sub1] + [(g, tabs[g]) for g in range(2, 13)]
    member = {}
    for i, (g, t) in enumerate(order):
        mx = recs[i][0]
        for k in range(mx + 1):
            c = M[t + k]
            if c:
                tag = "g%d%s[%d]" % (g + 1, ("." + "abc"[sub1.index(t)]) if g == 1 else "", k)
                member.setdefault(c, []).append(tag)

    const_set = {
        0x00: "constant 0 (0x24064, 0x240B2, 0x24434, 0x2444E push; 0x3FF90, 0x2CE12, 0x23E62 clear)",
        0x01: "push 0x25294", 0x02: "push 0x257E8", 0x09: "push 0x21A1A",
        0x0A: "push 0x14BDA, 0x24554; sub_3FF1E at 0x24580", 0x0B: "push 0x14BEA, 0x24A2C",
        0x0C: "push 0x1492A, 0x14946, 0x14BAC", 0x0D: "push 0x14B48",
        0x1D: "store 0x2C1C0", 0x1E: "store 0x2C0BA", 0x6B: "push 0x1F968; store 0x1F9AE",
        0xB3: "store 0x3226", 0xDB: "push 0x1F7B4; sub_3FEFC at 0x1F79E", 0xDC: "store 0x102F4, 0x233B0",
        0xE8: "store 0x1029A (power-on handler, doc 50)", 0xE9: "store 0x3208",
        0xEA: "push 0x1053E (power-on handler)", 0xEB: "push 0x1051C (power-on handler)",
        0xEC: "push 0x103DE (power-on handler)",
    }
    tb = M[0x3BC6:0x3BDB]
    for v in sorted(set(tb) - {0}):
        const_set[v] = "table 0x3BC6 (0x2CA98, 0x2D0F6, 0x2D4EA, 0x2DD5C, 0x2E10C, 0x33BC4; 0x33D84 to FF90F1)"
    for v in sorted(set(M[0x23156:0x23168]) - {0xFF}):
        const_set[v] = "table 0x23156 via 0x23124"
    for v in (0x85, 0x88, 0x89):
        const_set[v] = "0x6FD1E from [FFADA1] (FFADA1 writer not found)"
    # direct entry: mov.b #id,r3l ; mov.b #k,r3h ; jsr sub_148A0 (opens item screen id, AD6A=2)
    direct = {}
    for a in range(0, 0x80000, 2):
        if 0x78106 <= a < 0x7B754:
            continue
        if M[a:a + 4] == b"\x5e\x01\x48\xa0" and M[a - 4] == 0xFB and M[a - 2] == 0xF3:
            direct.setdefault(M[a - 3], []).append("%05X" % a)
    for v, sites in direct.items():
        s = "direct entry sub_148A0 at " + ", ".join(sites)
        const_set[v] = (const_set[v] + "; " + s) if v in const_set else s
    SAVE = {0x3CCBC: "R1", 0x3CCEC: "R2", 0x3CD1C: "R3"}

    def exit_h(sid):
        if not (0x0E <= sid <= 0xDB):
            return "-"
        t = 0x148A0 + W(0x19A9E + 2 * (sid - 0x0E))
        b = M[t:t + 8]
        if b[:2] == b"\x79\x01" and b[4] == 0x5A:
            tgt = (b[5] << 16) | (b[6] << 8) | b[7]
            if tgt in SAVE:
                return "%05X save %s n=0x%X" % (t, SAVE[tgt], (b[2] << 8) | b[3])
        if b[:2] == b"\x54\x70":
            return "%05X rts" % t
        return "%05X" % t

    hdr = ["screen_id", "notify_stub_0x782C", "notify_opcodes", "notify_calls", "dial_handler_0x12268",
           "exit_handler_0x19A9E", "key_table_0x125D4", "key_table_generic", "menu_rows", "set_by", "f_code",
           "sub_label", "status", "note"]
    rows = []
    for sid in range(0, 0xEF):
        stub = L(0x782C + 4 * sid)
        ops, calls = stub_ops(stub) if stub != 0x4892 else ([], [])
        dial = ("%05X" % L(0x12268 + 4 * (sid - 0x0E))) if 0x0E <= sid <= 0xE8 else "-"
        if 1 <= sid <= 0xEE:
            off = W(0x1208C + 2 * (sid - 1))
            kt = "%05X" % (0x125D4 + off)
            gen = "yes" if off == 0x374 else "no"
        else:
            kt, gen = "-", "-"
        mem = ",".join(member.get(sid, [])) or "-"
        fr = f3.get(sid, {})
        setby = const_set.get(sid, "")
        if mem != "-":
            setby = "row code (0x29A8C / 0x14B22 / 0x14E50)" + ("; " + setby if setby else "")
        note, status = "", "C"
        if sid in (0x41, 0x5C):
            note = ("no writer of screen id 0x%02X: absent from row tables 0x1515C-0x151EB and from every "
                    "constant/table source of the screen byte (scan in doc 49 Method)" % sid)
        if sid == 0x69:
            note = "only reference is the inert cmp #0x69 at 0x14EEC (doc 32)"
        if not setby and mem == "-":
            setby = "none found"
            status = "C(table slot) / NF(writer)"
        rows.append(["0x%02X" % sid, "%05X" % stub + (" (rts)" if stub == 0x4892 else ""),
                     ",".join(dict.fromkeys(ops)) or "-", ",".join(calls[:4]) or "-", dial, exit_h(sid), kt, gen, mem,
                     setby, fr.get("code", "-"), fr.get("label_text", "") or "-", status, note])
    with open(os.path.join(OUT, "screens.tsv"), "w", encoding="utf-8", newline="\n") as fh:
        fh.write("# Lane H13. MAIN screen ids 0x00-0xEE. Screen byte = band record +1, previous = +0 (records FF8EE0/FF8FE8/FF90F0/FF9190/FF922C; active = [FF812A]).\n")
        fh.write("# notify_stub = BE32 at 0x782C+4*id, called on entry/refresh (0x0481C/0x04DE4/0x06C6E/0x06E92); 0x04892 = rts (no notification).\n")
        fh.write("# exit_handler = 0x148A0 + BE16 at 0x19A9E+2*(id-0x0E), run by sub_19158 from the pop sub_3FF3A for 0x0E<=id<0xDC ('save Rk n' = mov.w #n,r1; jmp EEPROM writer).\n")
        fh.write("# dial_handler = BE32 at 0x12268+4*(id-0x0E) (sub_15E1E via sub_15E42); key_table = 0x125D4 + BE16 at 0x1208C+2*(id-1) (0x29AA0); generic = offset 0x374.\n")
        fh.write("# menu_rows = 1-based group [index] in row tables 0x1515C-0x151EB inside the cursor clamp records at 0x15102; f_code/sub_label joined from ida\\out\\sub-labels\\f3xx-codes.tsv (lane G3).\n")
        fh.write("# set_by: screen-byte writers found by ida\\jobs\\h13_screens.py (all stores to @(1,ERn), push/pop callers, absolute aliases). checks ok: %d\n" % n)
        fh.write("\t".join(hdr) + "\n")
        for r in rows:
            fh.write("\t".join(r) + "\n")

    rd = [
        ["0xFF89A9", "MAIN", "0x0534C", "read", "6a 0b 89 a9", "sub_534C: value-0x13 sent as F316 via sub_976A; only entry = 0x782C slot 0x41 (0x7930)", "C"],
        ["0xFF89A9", "MAIN", "0x0E58C", "write", "fc 19 6a 8c 89 a9", "factory default 0x19 in sub_DEFA", "C"],
        ["0xFF89A9", "MAIN", "0x166B0", "read+write", "7a 06 00 01 66 ba 5e 03 f6 00", "dial handler for screen 0x41 (0x12268 slot 0x33 = 0x12334): sub_3F600 saturating step over record 0x166BA {lo 0x13, hi 0x21, ptr FF89A9}; then jsr nullsub_36 (0x69A6 = rts)", "C"],
        ["0xFF89A9", "MAIN", "0x395B8", "bulk", "79 06 01 80 7a 00 00 00 05 80", "R1 bulk EEPROM save/restore (n=0x89, EEPROM 0x609, BACKUP.dat 0x4C9; doc 32)", "C"],
        ["0xFF89A9", "MAIN", "-", "consumer", "-", "no other reader: abs16/abs32 raw scan 0..0x80000 (non-code '89 a9' hits are FFA9xx operands), no FF8920-based displacement, no FF89xx base load covering 0xA9", "NF"],
        ["0xFF89A9", "SUB", "0xFFEFE73C", "latch", "71 1e eb 61 3e", "group-1 store FFEFE727: code 0x16 falls into the generic 1-byte compare-and-copy 0x8E66->0x8C6D", "C"],
        ["0xFF89A9", "SUB", "0xFFF00A8F", "draw", "61 f1", "group-1 drawer: clamp >=15 -> 14, +1, 'LEVEL' (doc 44)", "C"],
        ["0xFF89A9", "SUB", "-", "consumer", "-", "no other SUB use of code 0x16 from the F3 frame: compare scan over all 172,474 code heads found only frame-copy loop bounds and the F8xx upload path (0xFFF0C2CE)", "NF"],
        ["0xFF89B6", "MAIN", "0x056EA", "read", "6a 0b 89 b6", "sub_56E6: sends F31A via sub_976A; only entry = 0x782C slot 0x5C (0x799C)", "C"],
        ["0xFF89B6", "MAIN", "0x16B54", "read+write", "7a 06 00 01 6b 5a 5e 03 f6 28", "dial handler for screen 0x5C (0x12268 slot 0x4E = 0x123A0): loc_3F628 wrapping step over record 0x16B5A {lo 0, hi 3, ptr FF89B6}", "C"],
        ["0xFF89B6", "MAIN", "0x395B8", "bulk", "79 06 01 80", "R1 bulk EEPROM save/restore (n=0x96, EEPROM 0x616, BACKUP.dat 0x4D6)", "C"],
        ["0xFF89B6", "MAIN", "-", "consumer", "-", "no other reader (same scans as FF89A9; '00 03 89 b6' at 0x3882C is pointer 0x000389B6 in table 0x387FA)", "NF"],
        ["0xFF89B6", "SUB", "0xFFEFE74F", "latch", "75 51 1a 20 0c", "group-1 store: code 0x1A -> generic 1-byte latch", "C"],
        ["0xFF89B6", "SUB", "0xFFF0104D", "draw", "67 43", "group-1 draw jump-table slot for 0x1A is rtsd: never drawn (doc 44)", "C"],
    ]
    with open(os.path.join(OUT, "readers.tsv"), "w", encoding="utf-8", newline="\n") as fh:
        fh.write("# Lane H13. Every reader/writer found for FF89A9 (F316) and FF89B6 (F31A), MAIN and SUB.\n")
        fh.write("variable\tside\tsite\tkind\tbytes\twhat\tstatus\n")
        for r in rd:
            fh.write("\t".join(r) + "\n")
    print("checks ok: %d; screens %d; readers %d" % (n, len(rows), len(rd)))


main()
