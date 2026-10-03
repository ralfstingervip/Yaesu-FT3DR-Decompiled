# Lane M3: write runs.tsv, proposed-demotions.tsv, proposed-rules.tsv for the 22 proven-unreached runs 0x030000-0x057FFF.
# Proposals only: no mask, seed or DB is changed. Read-only on every input.
from pathlib import Path
REPO = Path(__file__).resolve().parents[4].as_posix()  # repository root
import sys, hashlib
sys.dont_write_bytecode = True
sys.path.insert(0, (REPO + "/ida/out/punr-mid/offline"))
from m3_common import MINE, IMG, P6, N6, MK
OUT = (REPO + "/ida/out/punr-mid/")
H9R = "A (fnindex-validated span x IDA items_before code; analyze.py PU=A|RC|D|G1A, only RC/D re-measured via RCU/DU)"
# start: (class, unit/head, inbound edges from reached code, evidence)
C = {
 0x0334A0: ("DEAD", "033494-0334A3 3-entry delay helper", 0, "third entry 0334A0 79 06 03 e8 (mov.w #1000,r6) of helper 033494 (#100) / 03349A (#500) / 0334A0 (#1000) -> common loop 0334A4; only 03349A is called (033488 55 10 bsr); 0334A0 has 0 inbound refs; preceded by 03349E 40 04 bra"),
 0x034032: ("DEAD", "sub_34022 034022-034043", 0, "cmp chain fd 00 ab 27 47 0c ab 29 47 04 ab 2a 46 e0 after unconditional 034030 40 0e (bra 0x34040); 0 inbound refs (BE24 hits 029B5C fb034032, 00DC2E 80034034, 04954E f6034038 straddle mov.b #3 + bra opcodes)"),
 0x0348EC: ("DEAD", "fnindex 03486C-034955", 0, "block 7e 5b 73 30 ... 5e 03 42 ec after unconditional 0348EA 40 2a (bra 0x34916); only inbound is its own 0348F0 beq"),
 0x03D0EE: ("DEAD", "sub_3D022 switch via table 03CF34 (jmp @er6 03CF32)", 0, "case body 7a 04 77 91 25 00 (BCD 779.125 MHz base; 797.125 / 806.125 follow) after 03D0EA 58 00 01 00 (bra 0x3D1EE); the 12-slot table 03CF34 holds 03A700 x2, 03CF70, 03CF72, 03CFE8, 03CF9C, 03D004, 03D090, 03D04A, 03D150, 03D198, 03D1CA, then 00FF0000 - no slot for 03D0EE; 0 inbound refs"),
 0x03D1C8: ("DATA-MISTYPED", "constant 03D1C6-03D1C9", 0, "low word of the 4-byte packed-BCD constant 00 40 00 00 at 03D1C6: 03D1B4 7a 06 00 03 d1 c6 mov.l #0x3D1C6,er6 -> 03D1BA 5e 03 f9 4c jsr 0x3F94C, a 32-bit BCD subtract reading @(2,er6) (03F954 6f 64 00 02) and @er6 (03F966 69 64)"),
 0x03EF60: ("DEAD", "fnindex 03EF2E-03EF6D", 0, "arm fc 07 40 08 after 03EF5E 40 0c (bra 0x3EF6C); 0 inbound refs; next arm 03EF64 fc 03 40 04 is also unreached (unnamed)"),
 0x03EFA0: ("DEAD", "fnindex 03EF6E-03EFAD", 0, "arm fc 07 40 08 after 03EF9E 40 0c (bra 0x3EFAC); 0 inbound refs; sibling arm 03EFA4 also unreached"),
 0x03EFE0: ("DEAD", "fnindex 03EFAE-03EFED", 0, "arm fc 07 40 08 after 03EFDE 40 0c (bra 0x3EFEC); 0 inbound refs; sibling arm 03EFE4 also unreached"),
 0x045D88: ("SPLIT-TAIL", "routine 045D18-045D95 (L3)", 0, "0b 01 fc 00 40 06 = beq target of 045D1C 47 6a inside head 045D18 (68 1b ab 2c 47 6a), which follows rts 045D16 and has 0 inbound refs (L3 doc 100); fnindex span 045D1E-045D95 cut the head off"),
 0x0460C2: ("DEAD", "sub_45FBA 045FBA-046177", 0, "block skipped by unconditional 0460C0 40 6e (bra 0x46130); only internal branches enter it; holds the only calls to dead 045F88/046210/046290/04633C (L3 doc 100)"),
 0x04B1D0: ("DEAD", "fnindex 04B1B4-04B1EB", 0, "block 6a 10 9e 22 73 00 58 60 00 06 5e 05 14 c6 ... 5e 05 16 fe after unconditional 04B1CE 40 1a (bra 0x4B1EA); 0 inbound refs (BE24 hit 05FADA 6b04b1d4 is mov.w @0xB1D4:16)"),
 0x04B830: ("DEAD", "digit-parser family 04B7F4 / 04B812 / 04B830", 0, "2-digit entry 7a 03 00 00 00 00 f4 02 (count 2); 3-digit entry 04B812 (f4 03) is called 9x (025AA0 ... 0634DA 5e 04 b8 12); 04B830 has 0 inbound refs; preceded by 04B82E 40 34 bra"),
 0x04B856: ("SPLIT-TAIL", "4-digit entry 04B7F4-04B811 (unnamed, unproven)", 0, "6c 2b 19 d3 47 08 79 04 03 e8 = x1000 step of the 4-digit entry; only inbound edge 04B810 40 44 (bra 0x4B856) in 04B7F4 (7a 03 00 00 00 00 f4 04), which follows rts 04B7F2 and has 0 inbound refs; fnindex span 04B812-04B88B swallowed the tail"),
 0x04BB78: ("DEAD", "entry 04BB78 of 04BB54..04BB86 entry family", 0, "fc 80 6a 8c a7 c8 7a 02 00 ff a8 82 40 0c; only caller 04BAEE 5e 04 bb 78 sits in arm 04BACE-04BAF3 after unconditional 04BACC 40 4a (bra 0x4BB18), which has 0 inbound refs; siblings 04BB54/62/6A/86 have live jsr callers"),
 0x04C198: ("DEAD", "entry 04C198 (sibling of 04C172)", 0, "7a 02 00 ff a8 88 ... 40 1e; only caller 04C04A 5e 04 c1 98 sits in arm 04C02A-04C04F after unconditional 04C028 40 4a (bra 0x4C074), which has 0 inbound refs; sibling 04C172 is called from 04692C/0469DE/04C070"),
 0x04F534: ("DEAD", "fnindex 04F4B0-04F563", 0, "arms fd 1e 40 02 fd 1d after unconditional 04F532 40 06 (bra 0x4F53A); 0 inbound refs"),
 0x04F87C: ("DEAD", "entry family 04F85C..04F8A4 -> bodies 04F8AC / 04F8DA", 0, "six entries 7a 01 00 00 00 {00,0c,18,24,30,3c} + bra 0x4F8DA at 04F87C/84/8C/94/9C/A4; 0 jsr/bsr/pointer refs (siblings 04F85C/64/6C/74 are called from 04F5E8/04F61E/04F654/04F68A); the beq/bhi 'edges' at 04F82E/04F832 are bytes of the string 'MSG GRP BLN ' 04F82A (read as data by 04F7D2 01 00 6b 24 00 04 f8 2a)"),
 0x04F8DA: ("DEAD", "shared body of the dead 04F87C entries", 0, "79 04 00 01 6b 84 b0 50 ...; only inbound edges are the six bra from 04F882/8A/92/9A/A2/AA, all in the dead entries; preceded by 04F8D8 40 2c bra"),
 0x050812: ("DEAD", "fnindex 0507AC-050827", 0, "block 5e 01 d0 fc fc 05 6a 8c a9 f9 ... 5e 05 09 5a after unconditional 050810 40 14 (bra 0x50826); 0 inbound refs"),
 0x050CD0: ("DEAD", "fnindex 050C9C-050CD5", 0, "5e 03 ff a0 after unconditional 050CCE 40 04 (bra 0x50CD4); only inbound 050C6E 47 60 (beq 0x50CD0) in routine 050C68 (6a 0c a5 07 ac 00 47 60), which follows rts 050C66 and has 0 inbound refs"),
 0x05291E: ("DEAD", "entry family 0528F2 / 0528FC / 05290E / 05291E -> 052938", 0, "entry 7a 03 00 07 00 00 6a 02 a4 f7 after 05291C 40 1a bra; 0 inbound refs (only 05290E is called: 052AFA/052B06 5e 05 29 0e)"),
 0x0532BA: ("DEAD", "fnindex 05327C-0532ED", 0, "block 7a 06 00 ff 3d ab fc 00 68 ec 7a 06 00 ff 3d ac fc 00 68 ec after unconditional 0532B8 40 14 (bra 0x532CE); 0 inbound refs"),
}
assert set(C) == {s for s, e, n in MINE}
R = ["# M3: the 22 proven-unreached runs with 0x030000 <= start < 0x058000 (ida\\out\\l-wave-recon\\proven-unreached-runs.tsv). Proven by H9 rule " + H9R + ". Classes: REACHED / DEAD / SPLIT-TAIL / DATA-MISTYPED / UNCERTAIN. Inbound rows in refs-detail.tsv.",
     "start\tend_excl\tlen\tclass\th9_rule\tunit\treached_inbound_edges\tdescent_reach_fn+8new\tdescent_reach_nofn+8new\tfirst_bytes\tevidence"]
D = ["# M3 proposals only - no mask, seed or DB was edited. Each range is set in final6_proven_mask.bin and final6_named_mask.bin. Demotion = clear from proven; named unchanged (I12 convention; the DATA-MISTYPED 2 B to be retyped as data, staying named). byte_sum = sum of image bytes in range.",
     "start\tend_excl\tlen\tclass\tproven_bytes_P6\tnamed_bytes_N6\tbyte_sum\tsha256_16\tnote"]
tot = {}; bs = 0
for s, e, n in MINE:
    cl, unit, inb, ev = C[s]
    R.append("%06X\t%06X\t%d\t%s\tA\t%s\t%d\t0\t0\t%s\t%s" % (s, e, n, cl, unit, inb, IMG[s:min(e, s + 8)].hex(), ev))
    b = sum(IMG[s:e]); bs += b
    D.append("%06X\t%06X\t%d\t%s\t%d\t%d\t%d\t%s\t%s" % (s, e, n, cl, sum(P6[s:e]), sum(N6[s:e]), b, hashlib.sha256(IMG[s:e]).hexdigest()[:16], ev.split(";")[0][:120]))
    tot[cl] = tot.get(cl, 0) + n
    assert sum(P6[s:e]) == n and sum(N6[s:e]) == n and sum(MK[s:e]) == 0
D.append("total\t-\t%d\tALL\t%d\t%d\t%d\t-\t%s" % (sum(tot.values()), sum(tot.values()), sum(tot.values()), bs, " ".join("%s=%d" % kv for kv in sorted(tot.items()))))
P6n = sum(P6); N6n = sum(N6)
D.append("# ledger if applied: MAIN proven %d - %d = %d (%.2f%% of 505,684 content; %.2f%% of 389,260 decodable); named %d unchanged; headline unchanged 965,919 / 1,029,972 = 93.78%%"
         % (P6n, sum(tot.values()), P6n - sum(tot.values()), 100 * (P6n - sum(tot.values())) / 505684, 100 * (P6n - sum(tot.values())) / 389260, N6n))
open(OUT + "runs.tsv", "w", encoding="utf-8", newline="\n").write("\n".join(R) + "\n")
open(OUT + "proposed-demotions.tsv", "w", encoding="utf-8", newline="\n").write("\n".join(D) + "\n")
RU = ["# M3 proposed rules (proposals only). scope_effect = bytes in this lane's 0x030000-0x057FFF scope.",
 "rule\tkind\tstatement\tscope_effect\tevidence",
 "M3-R1\tmask rule\tRe-measure H9 addend A (fnindex-validated span x items_before code) against the descent exactly as analyze.py already does for RC (RCU) and D (DU): an A byte the descent does not reach leaves proven unless it is data typed by a reader. A is the only addend that keeps unreached bytes in this scope.\t-574 B proven (all 22 runs are A-only; RC/D/G1A/NEWP = 0)\twork/m3_rules.txt: every run byte is A and not RM/RC/D/G1A",
 "M3-R2\tdescent non-rule\tDo NOT give a multi-entry routine's unreferenced entries the reach of its called siblings (entry = mov #param ; bra shared-body). Each entry needs its own jsr/bsr/pointer. fnindex spans that cover the whole family credit the dead entries.\t4 families: 033494/9A/A0, 04B7F4/12/30, 04F85C..04F8A4, 0528F2/FC/0E/1E\tpositive control: every reached sibling has an abs24 jsr or bsr (04F5E8 5e04f85c, 04F61E 5e04f864, 04F654 5e04f86c, 04F68A 5e04f874, 0634DA 5e04b812, 052AFA 5e05290e, 033488 5510); the unreached entries have none",
 "M3-R3\ttyping rule\tA mov.l #K,erN whose erN feeds a BCD/word helper (here jsr 0x3F94C, 32-bit BCD subtract @er5 -= @er6) types K..K+3 as data even when K lies inside a fnindex span.\t2 B (03D1C8-03D1C9; 03D1C6-03D1C7 already outside proven)\t03D1B4 7a 06 00 03 d1 c6; 03F954 6f 64 00 02; 03F966 69 64",
 "M3-R4\tno new edge\tNo descent rule is missing in this scope: whole-image scan (flow, operands, @@aa:8, mov.w pairs, BE32 exact and &0xFFFFFF at every offset, BE24 at every offset), doc 60's 267 reached jmp/jsr @erN (all in sites.tsv, 0 targets in the runs), the single reached bra r0.w (076308, out of range) and IDA XrefsTo agree. K1 folded descent + L-wave 8 entries reaches 0 of 574 B with or without fnindex seeds.\t0 B\twork/m3_even.txt, work/m3_descent.txt, work/m3_ida_xrefs.tsv"]
open(OUT + "proposed-rules.tsv", "w", encoding="utf-8", newline="\n").write("\n".join(RU) + "\n")
print(tot, bs, P6n, N6n, P6n - sum(tot.values()))
print(D[-2]); print(D[-1])
