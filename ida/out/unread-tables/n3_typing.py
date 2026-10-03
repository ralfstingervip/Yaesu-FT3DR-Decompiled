# Repository layout: this script lives under ida/out/; paths below are derived from its location.
from pathlib import Path as _Path
_REPO = _Path(__file__).resolve().parents[3]
# Lane N3: proposed retyping of IDA items (proposal only; no DB is edited). Counts the FINAL6-seed heads
# (N3_TABLES dump) that overlap each data structure identified by this lane or read by proven code.
import sys; sys.path.insert(0, str(_REPO / "ida/out/unread-tables"))
from n3_lib import *
H = []
for l in list(open(R + "/ida/out/unread-tables/work/n3_heads.tsv", encoding="utf-8"))[1:]:
    p = l.rstrip("\n").split("\t"); H.append((int(p[0], 16), int(p[1]), p[2]))
S = [
 (0x03605A, 0x03624B, "u8 curve tables read by 0x035344/0x0354E4/0x03559C (bases 0x03605A/6E/7E, 0x036116, 0x0361E2/EE/F2, 0x036218)"),
 (0x03624B, 0x036273, "u8 zero fill (40 B)"),
 (0x036273, 0x03643A, "u8[35][13] stride 13 (unread)"),
 (0x03643A, 0x036692, "u8[12][50] stride 50 (rows 9-11 zero; unread)"),
 (0x036692, 0x03775E, "u8[86][50] stride 50 (unread)"),
 (0x03775E, 0x03776B, "u8[13] block 5b x5 00 2f x4 00 x3 (unread)"),
 (0x03776B, 0x0377C1, "u8[86] step array (unread)"),
 (0x0377C1, 0x0377C2, "pad 00"),
 (0x005796, 0x0057A8, "{u16 5; 3 x 5-B rows} + pad"),
 (0x04BA2E, 0x04BA32, "u8 07 08 ff 00"),
 (0x04C3C7, 0x04C3D2, "u8 FF-terminated lists"),
 (0x05B370, 0x05B388, "u8[24] map"),
 (0x06C570, 0x06C598, "version record 0x06C570 + 04 terminator + pad"),
]
with open(R + "/ida/out/unread-tables/proposed-typing.tsv", "w", encoding="utf-8", newline="\n") as o:
    o.write("start\tend_excl\tlen\tproposed_type\tfinal6_code_heads\tfinal6_data_heads\tnamed_in_final7\tproven_in_final7\n")
    for s, e, t in S:
        hs = [h for h in H if h[0] < e and h[0] + h[1] > s]
        c = sum(1 for h in hs if h[2] == "code"); d = len(hs) - c
        o.write("%06X\t%06X\t%d\t%s\t%d\t%d\t%d\t%d\n" % (s, e, e - s, t, c, d, sum(NM7[s:e]), sum(PM7[s:e])))
print(open(R + "/ida/out/unread-tables/proposed-typing.tsv", encoding="utf-8").read())
