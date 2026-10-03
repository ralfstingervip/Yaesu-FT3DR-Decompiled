# L2: emit runs.tsv / proposed-demotions.tsv / proposed-seeds.tsv for fnindex-only runs < 0x030000.
# Every cited (address, bytes) pair is asserted against the image. Read-only on all inputs.
import sys
from pathlib import Path as _Path
_REPO_S = _Path(__file__).resolve().parents[4].as_posix()
import sys, pickle, hashlib, os
sys.dont_write_bytecode = True
ROOT = (_REPO_S + "/")
SCR = r"local-temp"
OUT = ROOT + "ida/out/fnindex-lo/"
sys.exit("The firmware image is not in this repository.")
assert hashlib.sha256(IMG).hexdigest().startswith("8e3ecd05409b2c31")
P = pickle.load(open(SCR + "reach.pkl", "rb"))
RUNS = [(s, e) for s, e in P["runs"] if s < 0x30000]
P4 = open(ROOT + "ida/out/main-final4/final4_proven_mask.bin", "rb").read()
N4 = open(ROOT + "ida/out/main-final4/final4_named_mask.bin", "rb").read()
NCITE = 0
def B(a, hx):
    global NCITE
    b = bytes.fromhex(hx.replace(" ", ""))
    assert IMG[a:a + len(b)] == b, ("cite mismatch", hex(a), hx, IMG[a:a + len(b)].hex())
    NCITE += 1
    return "%06X %s" % (a, hx)

D, R, S, T, U = "DEAD", "REACHED", "SPLIT-TAIL", "DATA-MISTYPED", "UNCERTAIN"
C = {}   # start -> (class, evidence, why_seed_only)
NOREF = "whole-image 0 BE32 / 0 abs24 jsr-jmp / 0 rel8-16 / 0 vector or @@ slot to head"
C[0x00245C] = (T, "16-B eepmov source: %s (mov.l #0x245C,er5) + %s (r4=0x10) copies to FFA998/FFA9A8 via %s; bytes 00x8 FFx8; J4 lists twin 0x00244C as DATA" %
               (B(0x002416, "7a05 0000 245c"), B(0x002412, "fc10"), B(0x002422, "7bd4 598f")), "fnindex start placed on data after rts 0x00244A")
C[0x00619C] = (D, "only caller %s (jsr @0x619C) is J4-DEAD stub 0x04FB44-0x04FB49 preceded by data .word %s; %s for 0x04FB44 (IDA 0 xrefs)" %
               (B(0x04FB44, "5e00 619c 5470"), B(0x04FB40, "0002 5458"), NOREF), "entry is an alternate prologue (B050=4) falling into reached 0x0061A4")
C[0x00C63C] = (T, "inside 6-B record list base 0xC624 (len word 0006) read by %s + sub_B516 %s/%s; 0x00C63C = tail of record 3 + head of record 4 %s" %
               (B(0x00D4A2, "7a05 0000 c624"), B(0x00B52E, "6d54"), B(0x00B534, "7bd4 598f"), B(0x00C638, "0101 01eb 5ade 0102 01eb fcde")),
               "only 'edge' is a data-byte misdecode 0x00C5EE ble")
C[0x00CFC2] = (D, "only caller %s sits in proven-unreached stub 0x0076D8-0x0076DF after %s; %s for 0x0076D8 (IDA 0 xrefs); sibling 0x00CFE4 is reached via %s" %
               (B(0x0076D8, "8b0b 5e00 cfc2 5470"), B(0x0076D6, "5470"), NOREF, B(0x00771A, "5e00 cfe4")), "caller stub itself unreached")
C[0x0151E6] = (T, "byte lookup table read by %s (mov.b @(0x151E6:32,er3),r3l); pointer cell %s in H9-excluded data table 0x014D6A" %
               (B(0x01509A, "7830 6a2b 0001 51e6"), B(0x014D9A, "0001 51e6")), "fnindex start placed on table tail before code 0x0151EC")
C[0x01522E] = (D, "routine 0x01522E-0x01525F (push/pop er5, AD68-indexed jsr @er6 %s); %s for 0x01522E (IDA 0 xrefs); preceded by %s" %
               (B(0x015256, "5d60"), NOREF, B(0x01522C, "5470")), "fnindex seed only")
C[0x01525E] = (D, "rts of routine 0x01522E (targets of %s/%s/%s); same dead routine" %
               (B(0x015248, "4014"), B(0x015254, "4708"), B(0x015258, "4004")), "inside dead routine 0x01522E")
C[0x015EB4] = (D, "callers %s/%s lie in block 0x015E64-0x015EA1 skipped by reached %s (0 refs to 0x015E64); also fall/bra tail of unreferenced 0x015EA8 (after %s, bra %s)" %
               (B(0x015E80, "5532"), B(0x015E86, "552c"), B(0x015E62, "403e"), B(0x015EA6, "5470"), B(0x015EB2, "400a")), "both entries come from unreached code")
C[0x016642] = (T, "byte value table (30,50,70,100,150,0) read by %s (mov.b @(0x16642:32,er4),r4l)" % B(0x016634, "7840 6a2c 0001 6642"),
               "fnindex start placed on table after rts 0x016640")
C[0x018250] = (R, "er1 callback: %s (mov.l #0x18250,er1) then %s (jsr @0x15206); sub_15206 reaches %s (jsr @er1) via %s/%s when FFAD68!=0 and FFAD9D!=0, er1 untouched on that path" %
               (B(0x018276, "7a01 0001 8250"), B(0x01827C, "5e01 5206"), B(0x015224, "5d10"), B(0x015212, "4606"), B(0x01521E, "4604")),
               "I9 seeded only one target (0x01A084) of this er1-callback helper; the other registrations were never added")
C[0x018464] = (D, "only caller %s in 0x01844E-0x018462, preceded by unproven 0x018420-0x01844D and %s; 0 refs to 0x01844E or 0x018420 (IDA 0 xrefs)" %
               (B(0x018460, "5502"), B(0x01841E, "5470")), "caller chain unreached")
C[0x018A74] = (D, "callers %s (fragment 0x0188D0 after %s) and %s (fragment 0x018A94 after %s); 0 refs to either fragment (IDA 0 xrefs)" %
               (B(0x0188D0, "5e01 8a74"), B(0x0188CE, "5470"), B(0x018A94, "55de"), B(0x018A92, "5470")), "caller fragments unreached")
C[0x018ABE] = (R, "er1 callback: %s then %s -> sub_15206 -> %s; tests FF8C26 b7 %s" %
               (B(0x018AD2, "7a01 0001 8abe"), B(0x018AD8, "5e01 5206"), B(0x015224, "5d10"), B(0x018ABE, "6a10 8c26 7370")),
               "same as 0x018250 (I9 rule applied to one target only)")
C[0x0192A0] = (D, "EEPROM writer stub (r1=0x16 -> sub_3CCBC) %s; only caller %s inside DEAD run 0x022DF0" %
               (B(0x0192A0, "7901 0016 5a03 ccbc"), B(0x022E24, "5e01 92a0")), "caller dead")
C[0x0198C4] = (D, "EEPROM writer stub (r1=0x18C -> sub_3CCEC) %s; callers %s/%s sit in arms 0x051422/0x051468 skipped by reached %s/%s, 0 refs to either arm" %
               (B(0x0198C4, "7901 018c 5a03 ccec"), B(0x05142C, "5e01 98c4"), B(0x051472, "5e01 98c4"), B(0x051420, "4024"), B(0x051466, "401e")), "callers in dead arms")
C[0x01A094] = (R, "er1 callback: %s then %s -> sub_15206 -> %s; landing pad mov.l #0x1A1EC,er2; bra 0x1A0EA %s" %
               (B(0x018BE8, "7a01 0001 a094"), B(0x018BEE, "5e01 5206"), B(0x015224, "5d10"), B(0x01A094, "7a02 0001 a1ec 404e")),
               "same as 0x018250")
C[0x01A0A4] = (R, "called %s from REACHED callback 0x018ABE; landing pad %s (record 0x1A1E0); second caller %s is in dead 0x017570 block" %
               (B(0x018AC6, "5e01 a0a4"), B(0x01A0A4, "7a02 0001 a1e0 403e"), B(0x017594, "5e01 a0a4")), "its caller was itself seed-only")
C[0x01C4D2] = (D, "callers %s in proven-unreached arm 0x01C27E-0x01C293 skipped by reached %s, and %s in arm 0x01D934 skipped by reached %s; 0 refs to either arm (IDA 0 xrefs); touches DSP mode gates FF8D20/FF8DD5/FF8EA0" %
               (B(0x01C28E, "5e01 c4d2"), B(0x01C27C, "401a"), B(0x01D93C, "5e01 c4d2"), B(0x01D932, "4012")), "callers in dead arms")
C[0x01CCD6] = (S, "tail of unreferenced head 0x01CCB0 (after reached %s): %s and %s flow into 0x01CCD6; 0 refs to 0x01CCB0 (IDA 0 xrefs)" %
               (B(0x01CCAE, "4042"), B(0x01CCC8, "470c"), B(0x01CCD4, "4000")), "H9 split one routine 0x01CCB0-0x01CCF1 at its join point")
C[0x01CD26] = (S, "tail of unreferenced head 0x01CCFA (after reached %s): %s falls in and %s branches to 0x01CD26; J4 lists 0x01CCFA-0x01CD25 DEAD" %
               (B(0x01CCF8, "403c"), B(0x01CD22, "6a8c 8eb3"), B(0x01CD14, "4010")), "H9 split one routine 0x01CCFA-0x01CD37 at its join point")
C[0x01CD38] = (D, "only caller %s inside DEAD run 0x01C4D2; second fnindex seed 0x01CD5E is internal (%s, %s)" %
               (B(0x01C584, "5e01 cd38"), B(0x01CD50, "470c"), B(0x01CD5C, "4000")), "caller dead")
C[0x01E22C] = (T, "word table indexed by r3: %s then %s (mov.w @er5,r4); also loaded at 0x01E360 and 0x032630" %
               (B(0x01E174, "7a05 0001 e22c"), B(0x01E184, "6954")), "fnindex start placed on table after rts")
C[0x01E5EE] = (T, "8-B range pair {0x38021250,0x38131250}: %s passed to sub_3F5EE %s / %s (cmp.l lo, hi)" %
               (B(0x01E5BE, "7a06 0001 e5ee"), B(0x03F5EE, "0100 6964 1fc5"), B(0x03F5F6, "0100 6f64 0004")), "fnindex start placed on data after rts 0x01E5EC")
C[0x01F540] = (D, "callers %s/%s lie in 0x01F4DA-0x01F507 and 0x01F508-0x01F53F, both after rts and 0 refs (0x01F508 has only a coincidental 3-byte match at odd 0x0494E1 inside reached code)" %
               (B(0x01F4F2, "554c"), B(0x01F520, "551e")), "caller routines unreached")
C[0x01F930] = (D, "callers %s (in 0x01F916-0x01F92F) and %s (J4-DEAD 0x01F96E-0x01F995); 0 refs to either head" %
               (B(0x01F926, "5508"), B(0x01F98C, "55a2")), "caller routines unreached")
C[0x01F996] = (D, "callers %s (J4-DEAD 0x01F96E) and %s (0x01F940-0x01F94F after rts); 0 refs to 0x01F940 or 0x01F96E" %
               (B(0x01F976, "551e"), B(0x01F94C, "5566")), "caller routines unreached")
C[0x022DF0] = (D, "callers %s/%s in 0x022DDE-0x022DEF (after reached %s); 0 refs to 0x022DDE (IDA 0 xrefs)" %
               (B(0x022DE6, "5508"), B(0x022DEA, "5e02 2e3a"), B(0x022DDC, "5470")), "caller routine unreached")
C[0x02370E] = (D, "callers %s (0x01DB3A, after BE32 pointer table ending %s) and %s (0x01E870 after %s); 0 refs to either head" %
               (B(0x01DB46, "5e02 370e"), B(0x01DB36, "0003 ffa0"), B(0x01E87C, "5e02 370e"), B(0x01E86E, "5470")), "caller routines unreached")
C[0x024000] = (T, "byte table read by %s and %s (mov.b @(0x24000:32,er4),r3l)" %
               (B(0x023F9E, "7840 6a2b 0002 4000"), B(0x023FD6, "7840 6a2b 0002 4000")), "fnindex start placed on table after rts")
C[0x024440] = (D, "only caller %s, an arm skipped by reached %s with no compare-branch to it; 0 refs to 0x010B44 (IDA 0 xrefs)" %
               (B(0x010B44, "5e02 4440"), B(0x010B40, "5800 ff74")), "caller in dead arm")
C[0x02AAE8] = (D, "2-B empty routine %s; only caller %s, an arm skipped by reached %s" %
               (B(0x02AAE8, "5470"), B(0x02AB92, "5e02 aae8"), B(0x02AB90, "4014")), "caller in dead arm")
for a, ld, bsr in ((0x02D704, 0x02D6FA, 0x02D700), (0x02D7FE, 0x02D7F4, 0x02D7FA), (0x02E2D8, 0x02E2CE, 0x02E2D4), (0x02E3D2, 0x02E3C8, 0x02E3CE)):
    tgt = bsr + 2 + IMG[bsr + 1]
    C[a] = (T, "4-B byte table: %s then %s -> 0x%06X %s (and.l #0xFF,er3; add.l er3,er5; mov.b @er5,r3l)" %
            (B(ld, IMG[ld:ld + 6].hex()), B(bsr, "5518"), tgt, B(tgt, "7a63 0000 00ff 0ab5 685b")), "fnindex start 4 B before the real routine")
C[0x02E640] = (T, "FF-terminated byte list 03 06 0D 10 FF %s searched by sub_3F768 %s" % (B(0x02E61A, "7a05 0002 e640"), B(0x03F768, "6c5c acff")),
               "fnindex start placed on data after rts")

assert sorted(C) == [s for s, e in RUNS], set(C) ^ {s for s, e in RUNS}
os.makedirs(OUT, exist_ok=True)
bysum = lambda s, e: sum(IMG[s:e])
cnt = {}
with open(OUT + "runs.tsv", "w", encoding="utf-8", newline="\n") as f:
    f.write("# L2: fnindex-only runs with start < 0x030000 (from ida\\out\\main-final4\\fnindex-only-runs.tsv); class per whole-image edge check\n")
    f.write("start\tend_excl\tlen\tclass\tevidence\twhy_descent_saw_only_the_seed\n")
    for s, e in RUNS:
        k, ev, why = C[s]
        cnt.setdefault(k, [0, 0]); cnt[k][0] += 1; cnt[k][1] += e - s
        f.write("%06X\t%06X\t%d\t%s\t%s\t%s\n" % (s, e, e - s, k, ev, why))
DEM = [(s, e) for s, e in RUNS if C[s][0] in (D, S, T)]
tot = sum(e - s for s, e in DEM)
assert all(P4[x] for s, e in DEM for x in range(s, e)) and all(N4[x] for s, e in DEM for x in range(s, e))
with open(OUT + "proposed-demotions.tsv", "w", encoding="utf-8", newline="\n") as f:
    f.write("# L2 proposals only (masks and seeds NOT edited). Remove from final4_proven_mask; I12 convention: named unchanged (DEAD/SPLIT-TAIL stay typed code, DATA-MISTYPED should be retyped data).\n")
    f.write("# bytesum = additive sum of the image bytes in [start,end_excl) (integrity check, not a checksum the firmware uses)\n")
    f.write("start\tend_excl\tlen\tclass\tbytesum\tfirst_bytes\n")
    for s, e in DEM:
        f.write("%06X\t%06X\t%d\t%s\t%d\t%s\n" % (s, e, e - s, C[s][0], bysum(s, e), IMG[s:min(e, s + 8)].hex()))
    for k in (D, S, T):
        rr = [(s, e) for s, e in DEM if C[s][0] == k]
        f.write("# subtotal %s: %d runs, %d B\n" % (k, len(rr), sum(e - s for s, e in rr)))
    f.write("# TOTAL proposed demotion: %d runs, %d B (of %d B in %d lo runs); REACHED kept: %d B\n" % (len(DEM), tot, sum(e - s for s, e in RUNS), len(RUNS), cnt[R][1]))
    f.write("# companions (NOT fnindex-only; proven but reached by nothing, the callers of DEAD runs) - optional, same evidence:\n")
    for s, e, why in ((0x0076D8, 0x0076E0, "stub calling 0x00CFC2, 0 refs, after rts 0x0076D6"), (0x01C27E, 0x01C294, "arm calling 0x01C4D2, skipped by bra 0x01C27C, 0 refs")):
        assert all(P4[x] for x in range(s, e))
        f.write("#C\t%06X\t%06X\t%d\tCOMPANION-DEAD\t%d\t%s\t%s\n" % (s, e, e - s, bysum(s, e), IMG[s:s + 8].hex(), why))
with open(OUT + "proposed-seeds.tsv", "w", encoding="utf-8", newline="\n") as f:
    f.write("# L2: er1-callback edges (generalises I9's single 0x01A084 seed): mov.l #T,er1 ; jsr @0x15206 -> 0x015224 jsr @er1\n")
    f.write("target\tload_site\tcall_site\tbytes_load\tnote\n")
    for t, ld, cs in ((0x018250, 0x018276, 0x01827C), (0x018ABE, 0x018AD2, 0x018AD8), (0x01A094, 0x018BE8, 0x018BEE)):
        f.write("%06X\t%06X\t%06X\t%s\tload+call reached (H9 RN); adds exactly 0x018250-0x018261, 0x018ABE-0x018AD1, 0x01A094-0x01A09B, 0x01A0A4-0x01A0AB (54 B) in a verify run\n" % (t, ld, cs, IMG[ld:ld + 6].hex()))
    f.write("# outside this lane (>=0x030000): 05E862 mov.l #0x5E8E0,er1 ; 05E868 jsr @0x15206 is the same pattern (target 0x05E8E0 is fnindex-only)\n")
print(cnt, "demote", len(DEM), tot, "cites", NCITE)
