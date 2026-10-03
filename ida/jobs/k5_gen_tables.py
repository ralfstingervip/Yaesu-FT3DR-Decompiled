r"""Lane K5 - plain read-only Python (not an IDA script).

Re-reads every cited byte run from the two decrypted images, aborts on mismatch, then writes
ida\out\dsp-payload-labels\f3-label-map.tsv, opcode-payload-names.tsv and location-service.txt.

    python "ida/jobs/k5_gen_tables.py"
"""
import sys
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root
import os
import struct

ROOT = str(_REPO)
OUT = os.path.join(ROOT, r"ida\out\dsp-payload-labels")
M = sys.exit("The firmware image is not in this repository.")
S = sys.exit("The firmware image is not in this repository.")
SB = 0xFFC00000
checks = 0


def mchk(addr, hexs):
    global checks
    want = bytes.fromhex(hexs)
    got = M[addr:addr + len(want)]
    assert got == want, "MAIN %06X: want %s got %s" % (addr, want.hex(" "), got.hex(" "))
    checks += 1
    return "%06X %s" % (addr, hexs)


def schk(addr, hexs):
    global checks
    want = bytes.fromhex(hexs)
    got = S[addr - SB:addr - SB + len(want)]
    assert got == want, "SUB %08X: want %s got %s" % (addr, want.hex(" "), got.hex(" "))
    checks += 1
    return "%08X %s" % (addr, hexs)


def sstr(addr):
    return S[addr - SB:addr - SB + 40].split(b"\0")[0].decode("latin-1")


# ---------------- shared evidence ----------------
E = {}
# SUB code->group (sub_FFF092FC) and code->row (sub_FFF09396)
E["grp_hiA_B"] = schk(0xFFF09317, "71 1e f6 61 2e 23 60")          # hi-0xA <2 -> group 9
E["grp_2x_25"] = schk(0xFFF09344, "75 51 25 2a 07 3c 02 16")       # code<=0x25 -> group 0x16
E["row_hiA"] = schk(0xFFF09551, "61 a1 18 c5 00 05 04")           # hi==0xA -> row = lo
E["row_2x_15"] = schk(0xFFF09417, "b1 09 61 11 16 b1 09 61 51 1d")  # lo 1 or 5 -> row 1
E["walker"] = schk(0xFFF09695, "fb e2 e8 74 ed ff 4b 1e b3 83 75 13 14 06 89 e3 01")
E["mt_g9"] = schk(0xFFED7530, "1c 00 00 00 89 e4 c3 ff")
E["mt_g16"] = schk(0xFFED7598, "04 00 00 00 bd e7 c3 ff")
E["sub_store_A3_AB"] = schk(0xFFEFFF01, "c5 fe 20 20")
E["sub_store_25"] = schk(0xFFEFEA6A, "71 1e dc 61 7e 23 0c")
E["jt_g9_A3"] = schk(0xFFF48262 + 2 * 3, "b7 01")    # -> FFF059FD
E["jt_g9_AB"] = schk(0xFFF48262 + 2 * 11, "11 09")   # -> FFF06157
assert 0xFFF05846 + struct.unpack("<h", bytes.fromhex("b701"))[0] == 0xFFF059FD
assert 0xFFF05846 + struct.unpack("<h", bytes.fromhex("1109"))[0] == 0xFFF06157
E["jt_txrx_25"] = schk(0xFFF481F0 + 2 * 5, "dd 00")  # -> FFF01162
assert 0xFFF01085 + 0x00DD == 0xFFF01162
E["modem_draw"] = schk(0xFFF05A2F, "fb 42 f3 99 f4 ff")
E["txd_draw"] = schk(0xFFF06157, "75 43 90 fb 22 e0 9b f4 ff")
E["txd_clamp"] = schk(0xFFF0616A, "61 91 29 07 fa 04 db 09 08")
E["ls_draw"] = schk(0xFFF01172, "fb 22 dd 86 f4 ff")
E["jp_modem"] = schk(0xFFF4A8CA, "41 50 52 53 20 f4 2d da 2d c4 20 40 5f 44 6a 00")
E["jp_txd"] = schk(0xFFF4A92F, "41 50 52 53 20 54 58 20 ee a8 da b2 00")
E["jp_ls"] = schk(0xFFF4A5F7, "30 4c 43 56 3e 70 4a 73 00 4f 4e 2f 4f 46 46 00")
E["jp_ls_call"] = schk(0xFFF09AEA, "fb 42 f7 a5 f4 ff fb 3e 00 aa 00")
assert sstr(0xFFC3E4C5) == "APRS MODEM" and sstr(0xFFC3E565) == "APRS TX DELAY"
assert sstr(0xFFC3E7D1) == "LOCATION SERVICE" and sstr(0xFFC3E015) == "DIGITAL"
assert sstr(0xFFF499F3) == "1200bps" and sstr(0xFFF499FB) == "9600bps"
delays = [sstr(0xFFF49BE0 + 16 * i) for i in range(9)]
assert delays == ["100ms", "150ms", "200ms", "250ms", "300ms", "400ms", "500ms", "750ms", "1000ms"]

# MAIN senders / dial / exit / row lists
E["m_snd_A3"] = mchk(0x5AAE, "79 0b f3 a3 6a 0b 8a a0 5e 00 97 6a 54 70")
E["m_snd_AB"] = mchk(0x5D1A, "79 0b f3 ab 6a 0b 8a bd 5e 00 97 6a 54 70")
E["m_snd_25"] = mchk(0x5E9B2, "79 0b f3 25 6a 0b 8d 82 5e 00 97 6a 54 70")
E["m_dial_A3"] = mchk(0x17822, "6a 0c 8d de 47 06 5e 03 ff a0 54 70 6a 18 b0 ce 70 30 7a 06 00 01 78 6a 5e 03 f6 28")
E["m_rec_A3"] = mchk(0x1786A, "00 02 00 ff 8a a0")
E["m_dial_AB"] = mchk(0x17990, "6a 18 b0 ce 70 30 6a 10 89 c4 73 10 47 0c 7a 06 00 01 79 bc 5e 03 f6 28 40 0a 7a 06 00 01 79 b6 5e 03 f6 28 54 70 00 08 00 ff 8a bd 00 0a 00 ff 8a bd")
E["m_dial_25"] = mchk(0x5E526, "7a 06 00 05 e5 32 5e 03 f6 28 54 70 00 01 00 ff 8d 82")
E["m_step"] = mchk(0x3F62E, "6a 10 a9 ee 73 00 46 20 01 00 6f 65 00 02 68 5b 69 64 1c bc 47 02 44 0a 0c 4b")
E["m_rows_g9"] = mchk(0x151BE, "90 9f 91 92 93 a2 94 95 ac 96 98 99")
E["m_rows_g2b"] = mchk(0x1516A, "b8 b5 c1 b2 c2 c3 c4 c5 c6 c7 c8 c9 ca cb cc cd ce cf d0 d1 d6 d3")
E["m_g2b_clamp"] = mchk(0x14F24, "7a 06 00 01 51 0e 5e 03 f6 2e ab 04 45 02 40 f0")
E["m_rec_1510E"] = mchk(0x1510E, "00 14 00 ff ad 9b")
E["m_exit_A3"] = mchk(0x1976C, "79 01 00 00 5a 03 cc ec")
E["m_exit_AB"] = mchk(0x19774, "79 01 00 1d 5a 03 cc ec")
E["m_exit_25"] = mchk(0x19976, "79 01 00 62 5a 03 cd 1c")
E["m_def_25"] = mchk(0xE728, "fc 01 6a 8c 8d 82")
E["m_def_A3"] = mchk(0xE684, "6a ac 00 ff 8a a0")
E["m_def_AB"] = mchk(0xE68A, "fc 04 6a 8c 8a bd")
E["m_force_A3_0"] = mchk(0x4525C, "fc 00 6a 8c 8a a0")
E["m_op32"] = mchk(0x5EB8A, "f3 32 fb 00 6a 0c 8a a0 47 02 70 7b 6a 0c 8a a0 10 4c 14 cb 6a 0c 8a a0 14 cb 6b 83 b1 3e 6a 0c 8a bd ac 09 45 02 fc 00 8c 03 10 4c 10 4c")
E["m_op11_hdr"] = mchk(0x5909A, "f3 11 6a 0b 8e 2a 70 7b 6a 0c 8d de 47 02 70 1b 6b 83 b1 3e")
E["m_op11_rom"] = mchk(0x5913E, "fc 0c f4 00 7a 05 00 00 f9 a8 7a 06 00 ff b1 4d 7b d4 59 8f")
E["m_op11_ovl"] = mchk(0x59156, "6a 0c 8e 3c ac 69 46 18 fc 03 f4 00 7a 05 00 ff 8e 3d 7a 06 00 ff b1 4d 7b d4 59 8f")
E["m_op11_tail"] = mchk(0x59176, "f4 c0 6a 84 b1 59 6a 0c 8d de 47 08 fc 10 6a 8c b1 5a 40 06 fc 20 6a 8c b1 5a fc 10 6a 8c b1 5b 6a 0c b1 5a ec f8 cc 07 6a 8c b1 5a fc f0 6a 8c b1 5c")
E["m_rom_F9A8"] = mchk(0xF9A8, "39 2a 2a 00 28 04 30 60 3f 6f 19 19")
E["m_def_8E3C"] = mchk(0xE7A6, "fc 69 6a 8c 8e 3c fc 03 f4 00 7a 05 00 00 f9 a8 7a 06 00 ff 8e 3d 7b d4")
E["m_op12_b1"] = mchk(0x59286, "f3 12 6a 0b 8d 85 eb fc 6a 0c b1 1e ec 03 14 cb")
E["m_op12_b2"] = mchk(0x592A8, "6a 03 8d 86")
E["m_op12_b3"] = mchk(0x5930C, "6a 0b 8d 87 6b 83 b1 40")
E["m_op1c"] = mchk(0x5A092, "6a 0b 8e 2d 40 12 6a 0c 8e 2b 10 4c 10 4c 10 0c 6a 0b 8e 2c eb 1f 14 cb 6a 8b b1 40")
E["m_notify_rts"] = mchk(0x5EA38, "54 70")

# hidden group-2b rows: id -> (exit stub, exit bytes, RAM, n/len, opcode/byte)
HID = [
    (0xC2, 0x19926, "79 01 01 0a 5a 03 cd 1c", "FF8E2A", "R3 n=0x10A", "0x11 [1]"),
    (0xC3, 0x1997E, "7a 01 00 ff 8e 20 79 06 00 02", "FF8E20-FF8E21", "R3 n=0x100 x2", "0x11 [2]"),
    (0xC4, 0x1998C, "7a 01 00 ff 8e 22 79 06 00 04", "FF8E22-FF8E25", "R3 n=0x102 x4", "0x11 [3]"),
    (0xC5, 0x1999A, "7a 01 00 ff 8e 26 79 06 00 04", "FF8E26-FF8E29", "R3 n=0x106 x4", "0x11 [4..7]"),
    (0xC6, 0x199A8, "79 01 01 0e 5a 03 cd 1c", "FF8E2E", "R3 n=0x10E", "0x11 [8]"),
    (0xC7, 0x199B0, "7a 01 00 ff 8e 2f 79 06 00 05", "FF8E2F-FF8E33", "R3 n=0x10F x5", "0x11 [9..11]"),
    (0xC8, 0x199BE, "7a 01 00 ff 8e 34 79 06 00 02", "FF8E34-FF8E35", "R3 n=0x114 x2", "0x11 [12..13]"),
    (0xC9, 0x199CC, "79 01 01 16 5a 03 cd 1c", "FF8E36", "R3 n=0x116", "0x11 [14]"),
    (0xCA, 0x199D4, "79 01 01 1d 5a 03 cd 1c", "FF8E3D", "R3 n=0x11D", "0x11 [15] (only if FF8E3C==0x69)"),
    (0xCB, 0x199DC, "79 01 01 1e 5a 03 cd 1c", "FF8E3E", "R3 n=0x11E", "0x11 [16] (only if FF8E3C==0x69)"),
    (0xCC, 0x199E4, "79 01 01 1f 5a 03 cd 1c", "FF8E3F", "R3 n=0x11F", "0x11 [17] (only if FF8E3C==0x69)"),
    (0xCD, 0x19910, "7a 01 00 ff 8d 85 79 06 00 02", "FF8D85-FF8D86", "R3 n=0x65 x2", "0x12 [1] b2-6, 0x12 [2]"),
    (0xCE, 0x1991E, "79 01 00 67 5a 03 cd 1c", "FF8D87", "R3 n=0x67", "0x12 [3]"),
    (0xCF, 0x1992E, "79 01 01 0b 5a 03 cd 1c", "FF8E2B", "R3 n=0x10B", "0x1C [2] (B0B8==9)"),
    (0xD0, 0x19936, "79 01 01 0c 5a 03 cd 1c", "FF8E2C", "R3 n=0x10C", "0x1C [2] (B0B8==9)"),
    (0xD1, 0x1993E, "79 01 01 0d 5a 03 cd 1c", "FF8E2D", "R3 n=0x10D", "0x1C [2] (B0B8==0x0D)"),
]
be32 = lambda a: struct.unpack(">I", M[a:a + 4])[0]
be16 = lambda a: struct.unpack(">H", M[a:a + 2])[0]
for rid, ex, exb, *_ in HID:
    assert be32(0x782C + 4 * rid) == 0x5EA38, hex(rid)
    assert be32(0x12268 + 4 * (rid - 0x0E)) == 0x3FFA0, hex(rid)
    assert 0x148A0 + be16(0x19A9E + 2 * (rid - 0x0E)) == ex, hex(rid)
    mchk(ex, exb)
for rid, snd, dial, ex in ((0x92, 0x5AAE, 0x17822, 0x1976C), (0x99, 0x5D1A, 0x17990, 0x19774), (0xB5, 0x5E9B2, 0x5E526, 0x19976)):
    assert be32(0x782C + 4 * rid) == snd and be32(0x12268 + 4 * (rid - 0x0E)) == dial
    assert 0x148A0 + be16(0x19A9E + 2 * (rid - 0x0E)) == ex
    checks += 3

# ---------------- f3-label-map.tsv ----------------
hdr = ["f3_code", "main_row_id", "main_menu_position", "main_notifier", "main_dial_handler", "main_exit_save",
       "ram", "region_n", "eeprom", "default", "sub_group", "sub_row", "en_label_addr", "en_label",
       "jp_label_addr", "jp_label", "jp_raw", "sub_value_draw", "values", "status", "evidence"]
rows = [
    ["F3A3", "0x92", "group 9 (APRS) row list 0x151BE[3]", "0x5AAE (mov.w #F3A3; [FF8AA0] -> sub_976A)",
     "0x17822 (if FF8DDE!=0 consume key; else bset #3,@FFB0CE then step FF8AA0 via record 0x1786A {0,2})",
     "0x1976C save R2 n=0x00", "FF8AA0", "R2 0x00", "0xC000", "0x00 (0xE684)", "0x09", "3", "FFC3E4C5", "APRS MODEM",
     "FFF4A8CA (mask 0x0014)", "APRS ボーレート 設定", "41 50 52 53 20 f4 2d da 2d c4 20 40 5f 44 6a",
     "FFF059FD (jt FFF48262[3])", "0=OFF (FFF486DD); 1=1200bps (FFF499F3); else 9600bps (FFF499FB); MAIN range 0..2 (wrapping step)",
     "C", "; ".join([E["grp_hiA_B"], E["row_hiA"], E["mt_g9"], E["jt_g9_A3"], E["modem_draw"], E["m_snd_A3"], E["m_dial_A3"], E["m_rec_A3"], E["m_rows_g9"]])],
    ["F3AB", "0x99", "group 9 (APRS) row list 0x151BE[11]", "0x5D1A (mov.w #F3AB; [FF8ABD] -> sub_976A)",
     "0x17990 (bset #3,@FFB0CE; record 0x179B6 {0,8}, or 0x179BC {0,10} when FF89C4 b1 set)",
     "0x19774 save R2 n=0x1D", "FF8ABD", "R2 0x1D", "0xC01D", "0x04 = 300ms (0xE68A)", "0x09", "11", "FFC3E565", "APRS TX DELAY",
     "FFF4A92F (mask 0x0000)", "APRS TX ディレイ", "41 50 52 53 20 54 58 20 ee a8 da b2",
     "FFF06157 (jt FFF48262[11])", "v>=9 drawn as 8; 0..8 = " + "/".join(delays) + " (16-B entries at FFF49BE0)",
     "C", "; ".join([E["row_hiA"], E["jt_g9_AB"], E["txd_draw"], E["txd_clamp"], E["m_snd_AB"], E["m_dial_AB"], E["m_rows_g9"]])],
    ["F325", "0xB5", "group 2 (TX/RX) sub-list b DIGITAL (FF8F4F==1) row list 0x1516A[1]", "0x5E9B2 (mov.w #F325; [FF8D82] -> sub_976A)",
     "0x5E526 (step FF8D82 via record 0x5E532 {0,1})", "0x19976 save R3 n=0x62", "FF8D82 (b0 read)", "R3 0x62", "0xD062",
     "0x01 = ON (0xE728)", "0x16", "1", "FFC3E7D1", "LOCATION SERVICE", "FFF4A5F7 (mask 0xAA00) + FFF4A600",
     "位置情報ON/OFF", "30 4c 43 56 3e 70 4a 73 | 4f 4e 2f 4f 46 46", "FFF01162 (jt FFF481F0[5], shared)",
     "0=OFF (FFF486DD); else ON (FFF48787)", "C",
     "; ".join([E["grp_2x_25"], E["row_2x_15"], E["mt_g16"], E["jt_txrx_25"], E["ls_draw"], E["jp_ls_call"], E["m_snd_25"], E["m_dial_25"], E["m_rows_g2b"], E["m_g2b_clamp"]])],
]
for i, (rid, ex, exb, ram, rn, op) in enumerate(HID):
    rows.append(["none (notifier 0x5EA38 = rts; no frame to SUB)", "0x%02X" % rid,
                 "group 2 sub-list b DIGITAL row list 0x1516A[%d] - HIDDEN (cursor forced <4 at 0x14F2E)" % (i + 4),
                 "0x5EA38 rts", "0x3FFA0 (consume key only; no edit)", "0x%05X %s" % (ex, exb), ram, rn,
                 "0xD%03X" % (int(rn.split("n=0x")[1].split()[0], 16)), "see doc 87 table", "-", "-", "-",
                 "Not found (no SUB label: menu_table[0x16] has 4 rows)", "-", "-", "-", "-",
                 "feeds DSP opcode " + op, "C (path) / NF (label)",
                 "; ".join([E["m_rows_g2b"], E["m_g2b_clamp"], E["m_rec_1510E"], E["m_notify_rts"], "exit %05X %s" % (ex, exb)])])
with open(os.path.join(OUT, "f3-label-map.tsv"), "w", encoding="utf-8", newline="\n") as fh:
    fh.write("# Lane K5. F3xx item code -> MAIN screen/row -> SUB (group,row) -> English/Japanese label -> value list. Hidden group-2b rows 0xC2-0xD1 carry the DSP config bytes but have no F3 code and no SUB label.\n")
    fh.write("\t".join(hdr) + "\n")
    for r in rows:
        fh.write("\t".join(r) + "\n")

# ---------------- opcode-payload-names.tsv ----------------
oh = ["opcode", "frame_byte", "main_ram_source", "packing", "menu_name", "hidden_row_id", "value_meaning", "status", "evidence"]
op = []
A = op.append
A(["0x32", "[0]", "const", "0x32", "-", "-", "opcode: APRS data-modem config (power-on init step 6; resent when FFB0CE b3 set by dial handlers 0x1782E/0x17990)", "C", E["m_op32"]])
A(["0x32", "[1]", "FF8AA0", "(v!=0)<<7 | v<<2 | v", "APRS > APRS MODEM (F3A3)", "0x92", "v=0 OFF -> 0x00; v=1 1200bps -> 0x85; v=2 9600bps -> 0x8A (MAIN range 0..2)", "C (packing+label) / Unknown (DSP interpretation)", E["m_op32"] + "; " + E["m_rec_A3"]])
A(["0x32", "[2]", "FF8ABD", "((v<9 ? v : 0) + 3) << 4", "APRS > APRS TX DELAY (F3AB)", "0x99",
   "v=0..8 = 100/150/200/250/300/400/500/750/1000 ms -> 0x30..0xB0 (default 4 = 300ms -> 0x70); v=9/10 (only with FF89C4 b1) -> 0x30 while SUB shows 1000ms", "C (packing+label) / Inferred (9/10 quirk) / Unknown (DSP units)", E["m_op32"] + "; " + E["m_dial_AB"]])
A(["0x32", "[3]", "FFAA35 b7 -> b0", "bit", "- (runtime flag, not persisted)", "-", "runtime DG-ID/monitor flag (doc 77)", "C (source)", "doc 77 sec 6"])
A(["0x11", "[0]", "const", "0x11", "-", "-", "opcode: DSP digital-audio config block (power-on init step 0)", "C", E["m_op11_hdr"]])
A(["0x11", "[1]", "FF8E2A", "v | 0x80 | (FF8DDE!=0 ? 0x02 : 0)", "no menu name (hidden row)", "0xC2", "default 0x08 -> 0x88", "C (source) / NF (label)", E["m_op11_hdr"]])
for b, src, pk, rid, dflt in [("[2]", "FF8E20,FF8E21", "E20<<4 | (E21&0x0F)", "0xC3", "0x04/0x07 -> 0x47"),
                              ("[3]", "FF8E22..FF8E25", "(E22<<6)|((E23&3)<<4)|((E24&3)<<2)|(E25&3)", "0xC4", "0x02/0x03/-/-"),
                              ("[4..7]", "FF8E26..FF8E29", "mov.l raw", "0xC5", "06 06 FC 0C"),
                              ("[8]", "FF8E2E", "raw", "0xC6", "0x02"),
                              ("[9]", "FF8E2F", "raw", "0xC7 (block FF8E2F..33)", "0x23"),
                              ("[10]", "FF8E30,FF8E31", "E30<<4 | (E31&0x0F)", "0xC7", "0x02/0x0D -> 0x2D"),
                              ("[11]", "FF8E32,FF8E33", "E32<<4 | (E33&0x0F)", "0xC7", "0x06/0x08 -> 0x68"),
                              ("[12..13]", "FF8E34 (word)", "mov.w raw", "0xC8", "no abs writer (EEPROM only)"),
                              ("[14]", "FF8E36", "raw", "0xC9", "no abs writer (EEPROM only)")]:
    A(["0x11", b, src, pk, "no menu name (hidden row)", rid, "default " + dflt, "C (source) / NF (label) / Unknown (DSP meaning)", "doc 77 sec 4; exit stub per f3-label-map.tsv"])
A(["0x11", "[15..17]", "ROM 0x00F9A8[0..2], overlaid by FF8E3D..FF8E3F when FF8E3C==0x69", "eepmov 12 B then eepmov 3 B", "no menu name (hidden rows)", "0xCA/0xCB/0xCC",
   "defaults: FF8E3C=0x69 and FF8E3D..3F = ROM 39 2A 2A (0xE7A6) -> same bytes until EEPROM differs", "C (correction to doc 77)", E["m_op11_rom"] + "; " + E["m_op11_ovl"] + "; " + E["m_def_8E3C"]])
A(["0x11", "[18..26]", "ROM 0x00F9AB..0x00F9B3", "eepmov", "-", "-", "constant 00 28 04 30 60 3f 6f 19 19", "C", E["m_rom_F9A8"]])
A(["0x11", "[27]", "const", "0xC0", "-", "-", "constant", "C (new vs doc 77)", E["m_op11_tail"]])
A(["0x11", "[28]", "FF8DDE", "(FF8DDE!=0 ? 0x10 : 0x20) & 0xF8 | 7", "-", "-", "0x17 in node/host mode, else 0x27", "C (new vs doc 77)", E["m_op11_tail"]])
A(["0x11", "[29]", "const", "0x10", "-", "-", "constant", "C (new vs doc 77)", E["m_op11_tail"]])
A(["0x11", "[30]", "const", "0xF0", "-", "-", "constant", "C (new vs doc 77)", E["m_op11_tail"]])
A(["0x12", "[0]", "const", "0x12", "-", "-", "opcode: mode / data-type frame", "C", E["m_op12_b1"]])
A(["0x12", "[1]", "FF8D85 & 0xFC | B11E&3, b7 = NOT B0AA.b0", "pack", "no menu name (hidden row)", "0xCD", "FF8D85 default 0x3C (0xE740); low 2 bits = runtime DT", "C (source) / NF (label)", E["m_op12_b1"]])
A(["0x12", "[2]", "FF8D86 | runtime bits", "b6=B0AC.b1, b5=B0AC.b0, low |= sub_593C8 state", "no menu name (hidden row)", "0xCD", "no abs writer of FF8D86 (EEPROM only)", "C (source) / NF (label)", E["m_op12_b2"]])
A(["0x12", "[3]", "FF8D87", "raw", "no menu name (hidden row)", "0xCE", "default 0x04 (0xE758); doc 77 missed this byte", "C (correction to doc 77)", E["m_op12_b3"]])
A(["0x12", "[4..]", "runtime (sub_59448/594DA/594F2, B0AC, BBF9, B3D9)", "-", "-", "-", "not persisted settings; not mapped here", "Not covered", "0x59332.."])
A(["0x1C", "[2]", "FF8E2B/FF8E2C (B0B8==9) or FF8E2D (B0B8==0x0D)", "(E2B<<5)|(E2C&0x1F) or E2D", "no menu name (hidden rows)", "0xCF/0xD0/0xD1", "FF8E2D default 0xFF (0xE752)", "C (source) / NF (label)", E["m_op1c"]])
with open(os.path.join(OUT, "opcode-payload-names.tsv"), "w", encoding="utf-8", newline="\n") as fh:
    fh.write("# Lane K5. DSP opcode payload byte -> MAIN RAM source -> menu name (or hidden MAIN row id) -> value meaning. Frame base FFB13E = byte [0].\n")
    fh.write("\t".join(oh) + "\n")
    for r in op:
        fh.write("\t".join(r) + "\n")

print("checks ok:", checks, "f3 rows:", len(rows), "op rows:", len(op))
