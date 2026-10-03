# Lane M3: byte-check every citation in docs\deep\115-proven-unreached-mid.md against the MAIN image, plus mask counts.
# Read-only. Prints PASS/FAIL per row and a total; writes ../work/m3_verify.txt.
import sys
from pathlib import Path
REPO = Path(__file__).resolve().parents[4].as_posix()  # repository root
import sys, hashlib
sys.dont_write_bytecode = True
sys.path.insert(0, (REPO + "/ida/out/punr-mid/offline"))
from m3_common import IMG, P6, N6, MK, MINE, flow, RK
ROOT = (REPO + "/")
CIT = """
0334A0 790603e8
033494 79060064
03349A 790601f4
033488 5510
03349E 4004
034030 400e
034032 fd00ab27470cab294704ab2a46e0
029B5C fb034032
00DC2E 80034034
04954E f6034038
0348EA 402a
0348EC 7e5b7330
0348F0 4712
03D0EA 58000100
03D0EE 7a0477912500
03D10A 7a0479712500
03D11C 7a0480612500
03CF2A 78c06b260003cf34
03CF32 5960
03CF34 0003a7000003a7000003cf700003cf720003cfe80003cf9c0003d0040003d0900003d04a0003d1500003d1980003d1ca00ff0000
03D1B4 7a060003d1c6
03D1BA 5e03f94c
03D1C6 00400000
03F954 6f640002
03F966 6964
03EF5E 400c
03EF60 fc074008
03EF64 fc034004
03EF9E 400c
03EFA0 fc074008
03EFDE 400c
03EFE0 fc074008
045D16 5470
045D18 681bab2c476a
045D88 0b01fc004006
0460C0 406e
0460C2 7a0600ff9c32
0460C8 5e046210
0460D6 5e046290
046104 5e04633c
04612A 5e045f88
04B1CE 401a
04B1D0 6a109e22730058600006
04B1DA 5e0514c6
04B1E0 5e0516fe
05FADA 6b04b1d4
04B7F2 5470
04B7F4 7a0300000000f404
04B810 4044
04B812 7a0300000000f403
04B82E 4034
04B830 7a0300000000f402
04B856 6c2b19d34708790403e8
025AA0 5e04b812
0634DA 5e04b812
04BACC 404a
04BAEE 5e04bb78
04BB78 fc806a8ca7c87a0200ffa882400c
04BB14 5e04bb6a
047332 5e04bb62
045654 5e04bb54
04C028 404a
04C04A 5e04c198
04C198 7a0200ffa888
04C070 5e04c172
04692C 5e04c172
0469DE 5e04c172
04F532 4006
04F534 fd1e4002fd1d
04F82A 4d53472047525020424c4e20
04F7D2 01006b240004f82a
04F87C 7a01000000004056
04F884 7a010000000c
04F8A4 7a010000003c402e
04F5E8 5e04f85c
04F61E 5e04f864
04F654 5e04f86c
04F68A 5e04f874
04F8D8 402c
04F8DA 790400016b84b050
050810 4014
050812 5e01d0fcfc056a8ca9f9
050822 5e05095a
050CCE 4004
050CD0 5e03ffa0
050C66 5470
050C68 6a0ca507ac004760
02A9C2 5e050c9c
05291C 401a
05291E 7a03000700006a02a4f7
052AFA 5e05290e
052B06 5e05290e
0532B8 4014
0532BA 7a0600ff3dabfc0068ec7a0600ff3dacfc0068ec
02B3F6 5e065d26
02B44E 5e065d66
05569A 5e055976
0559B0 7a0500ff5906
0559C6 7a0600ff5906
076308 5906
"""
L = []; ok = bad = 0
for ln in CIT.strip().splitlines():
    a, h = ln.split(); a = int(a, 16); b = bytes.fromhex(h)
    r = IMG[a:a + len(b)] == b
    ok += r; bad += (not r)
    L.append("%s %06X %s%s" % ("PASS" if r else "FAIL", a, h, "" if r else " image=" + IMG[a:a + len(b)].hex()))
# mid-instruction claims: bra/bsr rN.w decodes at these addresses are NOT instruction starts in the K1 descent
for a in (0x02B3F8, 0x02B450, 0x05569C, 0x0559B4, 0x0559CA):
    r = a not in RK and any(h in RK and h < a < h + RK[h][0] for h in (a - 2, a - 4))
    ok += r; bad += (not r); L.append("%s %06X mid-instruction (%s)" % ("PASS" if r else "FAIL", a, flow(a)[1]))
r = 0x076308 in RK; ok += r; bad += (not r); L.append("%s 076308 reached bra r0.w" % ("PASS" if r else "FAIL"))
sys.exit('The firmware image is not in this repository.')
chk = [("sha256 MAIN 8e3ecd05409b2c31", hashlib.sha256(IMG).hexdigest().startswith("8e3ecd05409b2c31")),
       ("SUB sha256 b93570b3c2f69ccb", hashlib.sha256(open(ROOT + "decrypted/FT3D_SUB_ver102_ALL.bin", "rb").read()).hexdigest().startswith("b93570b3c2f69ccb")),
       ("P6 popcount 364786", sum(P6) == 364786), ("N6 popcount 501656", sum(N6) == 501656),
       ("22 runs / 574 B", len(MINE) == 22 and sum(n for s, e, n in MINE) == 574),
       ("runs all P6 and N6", all(P6[x] and N6[x] for s, e, n in MINE for x in range(s, e))),
       ("runs not in MK", not any(MK[x] for s, e, n in MINE for x in range(s, e))),
       ("P6 - 574 = 364212", sum(P6) - 574 == 364212)]
for k, r in chk:
    ok += r; bad += (not r); L.append("%s %s" % ("PASS" if r else "FAIL", k))
L.append("TOTAL pass %d fail %d" % (ok, bad))
open(ROOT + "ida/out/punr-mid/work/m3_verify.txt", "w", encoding="utf-8").write("\n".join(L) + "\n")
print("\n".join(l for l in L if not l.startswith("PASS")) or "all pass"); print(L[-1])
