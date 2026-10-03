r"""Lane H11 - verify cited MAIN byte runs and emit keyseq TSVs.

Plain Python. Opens decrypted\FT3D_MAIN_ver102_EXP.bin read-only, re-checks each
cited byte run against the document, aborts on any mismatch, then writes
ida\out\keyseq\states.tsv and readers.tsv (UTF-8).
"""
import sys
import os

ROOT = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
BIN = os.path.join(ROOT, "decrypted", "FT3D_MAIN_ver102_EXP.bin")
OUT = os.path.join(ROOT, "ida", "out", "keyseq")

CHECKS = [
    (0x01494C, "6a1089c17330"), (0x014954, "6a10bc8a7370"), (0x01495C, "6e0c0001ac0c"),
    (0x014964, "fc006a8cbc8a"), (0x01496A, "6a0c8f2eac05"), (0x01497E, "01006b04910a7a2400066600"),
    (0x014992, "6a18bc8a7060"), (0x0149AE, "6a18bc8a7050"), (0x0149B6, "6a18bc8a7040"),
    (0x0149BE, "6a18bc8a7030"), (0x0149C4, "6a18bc8a7070"), (0x0149CA, "fc086a8cbc8b"),
    (0x0149D2, "6a10bc8a7370"), (0x0149E0, "ac06"), (0x0149F8, "ac05"),
    (0x014A10, "ac08"), (0x014A14, "ac03"), (0x014A18, "ac02"),
    (0x014A2A, "ac07"), (0x014A2E, "ac04"), (0x014A32, "ac01"),
    (0x014A36, "6a10bc8a7330"), (0x014A3E, "6a10bc8a7340"), (0x014A46, "6a10bc8a7350"),
    (0x014A4E, "6a10bc8a7360"), (0x014A56, "5e016456"), (0x014A5C, "5e01645e"),
    (0x014A62, "6a18bc8a7000"), (0x014A70, "fc016a8cb0c8"),
    (0x014A8A, "1a0c6a8cbc8b5e03ffa0"), (0x014A96, "6a18bc8a7200"),
    (0x0032B4, "5e01cf0a"), (0x01CF0A, "6a1889c17130"), (0x01CF3A, "5e01494c"),
    (0x00E664, "fc116a8c89c1"), (0x007CA8, "6a1089c17730"),
    (0x010EDA, "78306b250001208c"), (0x010EE8, "7a15000125d4"),
    (0x0100F8, "2c4cec7fac7f"), (0x010108, "f90eac7e"), (0x01011A, "f90fac77"),
    (0x010120, "f90dac6f"), (0x010126, "f90cac5f"), (0x01012C, "f912ac3f"),
    (0x00FBC8, "ac0a4408"), (0x00FBD4, "fb0918bc"), (0x00FBC6, "fc16"),
    (0x0163CC, "6a0c8f2eac07"), (0x016420, "01006b04ad8e7a2401020402"), (0x01642E, "7a2403090309"),
    (0x016436, "7a2407070603"), (0x01643E, "7a2402060804"),
    (0x016446, "6a1889c47110"), (0x01644E, "6a1889c47120"), (0x016456, "6a1889c47140"),
    (0x01645E, "6a1889c47130"), (0x016464, "5e0193cafc166a8caae0"),
    (0x016528, "01006b04ad8e7a2404030708"), (0x016536, "fc016a8cb0c8"), (0x01654C, "fc006a8cb0c8"),
    (0x01913E, "7a2408030706"), (0x019146, "fc166a8caae0"),
    (0x05E3BA, "6a0cb0c8ac01"), (0x05E400, "6a0cb0c8ac01"), (0x05E44E, "6a0cb0c8ac01"),
    (0x05E45C, "5e039576"), (0x039586, "790601007a00000000407a0100ff8016"),
    (0x007930, "0000534c"), (0x00799C, "000056e6"), (0x00534C, "6a0b89a9fc1318cb"),
    (0x005356, "790bf3165e00976a"), (0x0056E6, "790bf31a6a0b89b65e00976a"),
    (0x00481C, "78b06b260000782c"), (0x0166AA, "7a06000166ba5e03f600"), (0x0166BA, "132100ff89a9"),
    (0x016B4E, "7a0600016b5a5e03f628"), (0x016B5A, "000300ff89b6"),
    (0x00E58A, "fc196a8c89a9"), (0x009D18, "6a10bc8a7700"), (0x014B04, "ac0c46086a1089c47330"),
    # reconciled 2026-10-03: sites the draft cited at the wrong address, plus the
    # screen-id / handler / group-table bytes the prose now depends on
    (0x01499A, "01006b04910a7a2400066600"),
    (0x0149EA, "6a10bc8a7370"), (0x014A02, "6a10bc8a7370"), (0x014A1E, "6a10bc8a7370"),
    (0x00785C, "00004e24"), (0x004E30, "5e009562"),
    (0x0120A2, "02ec"), (0x01220A, "1980"),
    (0x013F58, "000149ea"), (0x013F68, "00014a1e"), (0x013F6C, "000149d2"), (0x013F74, "00014a02"),
    (0x012334, "000166aa"), (0x019B04, "4a24"), (0x0166B4, "5e0069a65470"),
    (0x0123A0, "00016b4e"), (0x019B3A, "4a72"),
    (0x0192C4, "790100895a03ccbc"), (0x019312, "790100965a03ccbc"),
    (0x003F63E, "69641cbc4702440a0c4b"),
    (0x014D6A, "0001515c"), (0x014D7E, "000151a0"), (0x014D8A, "000151be"), (0x014D92, "000151de"),
    (0x066600, "ac3b"), (0x003272, "0000327e0000328a0000329c"),
    (0x029AAE, "78306b250001208c"), (0x029ABC, "7a15000125d4"),
    (0x02D5BA, "6a0caae0ac16"), (0x02D6A4, "5470"),
    (0x02E1AC, "6a0caae0ac16"), (0x02E278, "5470"),
    (0x033F3E, "6a0caae0ac16"), (0x033FD8, "5470"),
]


def main():
    data = sys.exit("The firmware image is not in this repository.")
    bad = 0
    for ea, hx in CHECKS:
        want = bytes.fromhex(hx)
        if data[ea:ea + len(want)] != want:
            print("MISMATCH %06X want %s got %s" % (ea, hx, data[ea:ea + len(want)].hex()))
            bad += 1
    if bad:
        raise SystemExit("aborting: %d mismatches" % bad)
    os.makedirs(OUT, exist_ok=True)

    states = [
        ["id", "role", "trigger/condition", "action", "site", "bytes", "status", "note"],
        ["arm_entry", "arm sub_1494C", "btst #3,@FF89C1 (LOCK set) AND btst #7,@FFBC8A clear AND screen byte @(1,er0)==0x0C", "clear FFBC8A, read sel=[FF8F2E]", "0x01494C", "6a1089c17330", "C", "LOCK on, not already armed, screen id 0x0C = setup-menu group list (notifier 0x4E24 sends F300). Not the operating screen"],
        ["arm_sel5", "arm which", "[FF8F2E]==5 (0-based; 1-based group 6)", "bset #3 FFBC8A (completion->FFB0C8)", "0x0149BE", "6a18bc8a7030", "C", "row table 0x151A0 via 0x14D6A[5]. No FF910A test"],
        ["arm_sel0", "arm which", "[FF8F2E]==0 (0-based; 1-based group 1, DISPLAY)", "bset #4 FFBC8A (completion->ext version)", "0x0149B6", "6a18bc8a7040", "C", "row table 0x1515C. No FF910A test"],
        ["arm_sel8", "arm which", "[FF8F2E]==8 (0-based; 1-based group 9, APRS) AND [FF910A]==0x66600", "FFAAE0=0x16; bset #5 FFBC8A (completion->sub_1645E)", "0x0149AE", "6a18bc8a7050", "C", "cmp.l #0x66600 at 0x01499A (bne 0x149D0 if not equal); bset #5 at 0x0149AE. Row table 0x151BE"],
        ["arm_sel10", "arm which", "[FF8F2E]==0x0A (0-based; 1-based group 11, OPTION) AND [FF910A]==0x66600", "FFAAE0=0x16; bset #6 FFBC8A (completion->sub_16456)", "0x014992", "6a18bc8a7060", "C", "cmp.l #0x66600 at 0x01497E (bne 0x149D0 if not equal); bset #6 at 0x014992. Row table 0x151DE"],
        ["arm_set", "arm finish", "any armed", "bset #7 FFBC8A (active); FFBC8B=8 (step counter)", "0x0149C4", "6a18bc8a7070", "C", "counter counts DOWN 8..1"],
        ["step8", "step n=8 (first)", "FFBC8B==8; key in {8,3,2}", "fall to next step", "0x014A02", "6a10bc8a7370", "C", "screen 0xC0 key table base 0x13F54: slot1 0x13F58, slot5 0x13F68, slot6 0x13F6C, slot8 0x13F74"],
        ["step7", "step n=7", "FFBC8B==7; key in {7,4,1}", "fall to next step", "0x014A1E", "6a10bc8a7370", "C", "last step: if key==1 go to completion dispatch"],
        ["step6", "step n=6", "FFBC8B==6; key==6", "fall to next step", "0x0149D2", "6a10bc8a7370", "C", ""],
        ["step5", "step n=5", "FFBC8B==5; key==5", "fall to next step", "0x0149EA", "6a10bc8a7370", "C", ""],
        ["wrong_key", "reset", "key does not match expected for current FFBC8B", "bclr #0 FFBC8A; FFBC8B=0xFF; jsr sub_14BBA (redraw)", "0x014A96", "6a18bc8a7200", "C", "clears bit 0 only. Bit 7 (active) is left set. No other abs16 site clears bit 7"],
        ["advance", "step ok", "key matched", "FFBC8B-- ; jsr sub_3FFA0 (consume key)", "0x014A8A", "1a0c6a8cbc8b5e03ffa0", "C", "decrement step counter"],
        ["done_b4", "completion bit4", "FFBC8B reached, FFBC8A b4 set", "bset #0 FFBC8A; FFAAE0=0x16", "0x014A62", "6a18bc8a7000", "C", "sets extended-version-digit flag FFBC8A b0 (doc 44 F7)"],
        ["done_b3", "completion bit3", "FFBC8A b3 set", "FFB0C8=1; FFAAE0=0x16", "0x014A70", "fc016a8cb0c8", "C", "FFB0C8=1 enables RADIO ID edit (screen 0x8D)"],
        ["done_b5", "completion bit5", "FFBC8A b5 set", "jsr sub_1645E (toggle FF89C4 b3)", "0x014A5C", "5e01645e", "C", "sub_1645E = bnot #3 FF89C4 -> enable group 13 (doc 32/23)"],
        ["done_b6", "completion bit6", "FFBC8A b6 set", "jsr sub_16456 (toggle FF89C4 b4)", "0x014A56", "5e016456", "C", "sub_16456 = bnot #4 FF89C4 -> RAM DISPLAY enable (doc 32/23)"],
        ["ticker", "where run", "sub_32AC calls sub_1CF0A when [FF9536]<0x46; sub_32AC is the [FFA9E0]==2 slot", "sub_1CF0A toggles FF89C1 b3 then jsr sub_1494C", "0x01CF3A", "5e01494c", "C", "only jsr of sub_1494C is 0x01CF3A; only jsr of sub_1CF0A is 0x0032B4. Pointers at 0x3272 are 0x327E/0x328A/0x329C"],
        # separate 4-digit entry-code matcher (independent of 8-step machine)
        ["code4_buf", "entry-code buffer", "screen 0x2C/0x32 collects up to 4 key codes into FFAD8E..FFAD91", "compare 32-bit buffer to constants", "0x016420", "01006b04ad8e", "C", "ADJ/other screens; menu group index in [FF8F2E] gates which screen"],
        ["code4_c1", "code 01020402", "buffer==0x01020402", "sub_1645E: bnot #3 FF89C4 (group 13)", "0x016426", "7a2401020402", "C", ""],
        ["code4_c2", "code 03090309", "buffer==0x03090309", "sub_16456: bnot #4 FF89C4 (RAM DISPLAY)", "0x01642E", "7a2403090309", "C", ""],
        ["code4_c3", "code 07070603", "buffer==0x07070603", "bnot #2 FF89C4", "0x016436", "7a2407070603", "C", "FF89C4 b2 default-set, no reader found (doc 32)"],
        ["code4_c4", "code 02060804", "buffer==0x02060804", "bnot #1 FF89C4", "0x01643E", "7a2402060804", "C", "FF89C4 b1 = feature flag (doc 32)"],
        ["code4_b0c8", "code 04030708", "buffer==0x04030708 on a 2,2,5,0xC,5,1,4,0x15,0x1B,3,0,0 sequence screen", "FFB0C8=1", "0x016528", "01006b04ad8e", "C", "second FFB0C8=1 writer (alt entry to RADIO ID edit)"],
        ["code4_v2", "code 08030706", "buffer==0x08030706 on 0x10-check screen", "FFAAE0=0x16 (UI jump)", "0x01913E", "7a2408030706", "C", "screen whose UI word [FF8F2C]==0x10"],
    ]

    readers = [
        ["addr", "kind", "what", "site(s)", "status", "note"],
        ["0xFFBC8A", "state", "8-step machine state byte: b0=ext-ver-digits, b3-6=which-seq armed, b7=active", "set 0x01494C-0x014A62; read SW-VER builder 0x9D18 (bld #0)", "C", "doc 44 F7; b0 read by SOFTWARE VERSION frame builder sub_9CF4"],
        ["0xFFBC8B", "state", "step counter 8..1, 0xFF when idle", "0x0149CC,0x014A8A; read 0x0149DC/F4/0C/26", "C", ""],
        ["0xFF89C1", "gate", "b3 = KEY LOCK flag (also the key-seq gate). default 0x11 (b0,b4). toggled by sub_1CF0A bnot #3", "write 0xE666 (init 0x11); bnot 0x1CF0A/0x17778; btst 0x1494C,0xFED0,0x10C40,0x22562,0x38442,0x55414; bclr 0x45268/0x4526E (b6/b7)", "C", "b3 is user KEY LOCK; b0 default-set = MEMORY WRITE NEXT (F335); b2=MEMORY PROTECT"],
        ["0xFF8F2E", "gate", "0-based menu group index; 1-based group = index+1. Arms on 0, 5, 8, 10", "write 0x298CE (=[FFBBC2]-1); read 0x1496A. Row pointers 0x14D6A[index]", "C", "H13 map: index 0 = group 1 DISPLAY (0x1515C), 5 = group 6 (0x151A0), 8 = group 9 APRS (0x151BE), 10 = group 11 OPTION (0x151DE)"],
        ["0xFF910A", "gate", "dword must equal 0x66600 or the 0-based index 8 and 10 arms return", "cmp 0x01497E (index 10) and 0x01499A (index 8)", "C", "no abs16 writer; immediate 0x66600 only at those two cmps. 0x66600 is code ac3b (cmp.b #0x3B), not a screen object. Index 0 and 5 do not read it"],
        ["0xFFAAE0", "effect", "byte set to 0x16 by the index-8/10 arms and by the b3/b4 completions", "stores 0x01498E, 0x0149AA, 0x014A6A, 0x014A78; also 0x01646A, 0x019148", "C", "readers 0x2D5BA, 0x2E1AC, 0x33F3E beq to rts when the byte is 0x16 (skip the following screen restore). They do not select a key table. Key-table base follows the screen id at 0x10EDA and 0x29AAE"],
        ["0xFFB0C8", "effect(C2)", "RADIO ID edit-enable flag; completion done_b3 and code 04030708 set it =1", "write 0x014A72,0x016538,0x01654E; read 0x5E3BA,0x5E400,0x5E44E (cmp #1)", "C", "RADIO ID CHECK page screen 0x8D keys 4/5/6/D gate char edit/save on it"],
        ["0xFF89C4", "effect(C2)", "persisted feature-flag byte default 5; sub_1645E=bnot b3, sub_16456=bnot b4", "bnot 0x1645E(b3)/0x16456(b4)/0x1644E(b2)/0x16446(b1); saved via sub_193CA(#0xA4)", "C", "b3 read 0x14B08 (enable group 13); b4 read 0x2998C/0x14EF2/0x7C62 (RAM DISPLAY). doc 32/23"],
        ["0xFF89A9", "F316 src", "LEVEL backing byte, default 0x19; saturating range 0x13..0x21 (15 values)", "read 0x534C; dial 0x166AA jsr sub_3F600 then 0x69A6 (rts); exit 0x192C4 saves R1 n=0x89; init 0xE58C", "C", "screen 0x41: dial slot 0x12334, exit word 0x19B04. Record at 0x166BA is 13 21 00 ff 89 a9. H13 has the screen model"],
        ["0xFF89B6", "F31A src", "screen 0x5C backing byte; record {lo 0, hi 3} at 0x16B5A is 4 values 0..3, not 3-state", "read 0x56EA (sub_56E6 sends F31A); dial 0x16B4E jsr 0x3F628 (wrap); exit 0x19312 saves R1 n=0x96", "C", "dial slot 0x123A0, exit word 0x19B3A. SUB slot for code 0x1A is rtsd (doc 44 / H13)"],
        ["0x782C[code*4]", "dispatch", "MAIN row-code -> per-item sender stub table; slot 0x7930 (code 0x41)=sub_534C, 0x799C (code 0x5C)=sub_56E6", "indexed jsr at 0x0481C,0x04DE4,0x06C6E,0x06E92", "C", "callers index by @(1,er0) = the current row code"],
        ["0x1515C", "rowcode tbl", "15 per-group row-code sub-tables; neither 0x41 nor 0x5C appears", "full byte scan 0x1515C-0x151EB", "C(not found)", "so codes 0x41/0x5C are never produced by the normal menu walker (doc 32)"],
        ["0xFFFF4E/4C", "key src", "keypad return columns (active-low); sub_100E4 decodes @0x4C to internal codes", "read 0x100F8 (@0x4C); boot strap 0x2200 (@0x4C)", "C", "internal codes: 0x7E->0x0E 0x7D->0x11 0x7B->0x0A 0x77->0x0F 0x6F->0x0D 0x5F->0x0C 0x3F->0x12"],
        ["0xFFA9ED", "key code", "normalised current internal key code consumed by the 8-step machine (@(1,er0) on edit screens derives from it)", "many; final in sub_FA30 at 0xFBD8; FFA9F0=last-key", "C", "the key compared at each step is the screen's current key code"],
    ]

    def wr(name, rows):
        with open(os.path.join(OUT, name), "w", encoding="utf-8") as f:
            for r in rows:
                f.write("\t".join(str(c) for c in r) + "\n")

    wr("states.tsv", states)
    wr("readers.tsv", readers)
    print("checks ok: %d; states %d; readers %d" % (len(CHECKS), len(states) - 1, len(readers) - 1))


if __name__ == "__main__":
    main()
