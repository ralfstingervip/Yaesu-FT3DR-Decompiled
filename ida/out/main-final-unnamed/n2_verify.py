import sys
from pathlib import Path as _Path
_REPO = _Path(__file__).resolve().parents[3]
# Lane N2 - FINAL7 MAIN unnamed residue: decisions, byte-checked citations, whole-image edge/reader scan.
# Read-only. Inputs: decrypted MAIN image, ida\out\m-wave-recon\final7_*_mask.bin, work\n2_heads.tsv
# (from ida\jobs\n2_dump.py on private DB N2_UNNAMED). Outputs in this folder only.
import sys, hashlib, bisect
sys.path.insert(0, str(_REPO) + r"/ida/out/main-final-unnamed")
from n2_lib import *
load_heads()
LOG = []
def log(s): LOG.append(s); print(s)

# 0. image hashes
mh = hashlib.sha256(img).hexdigest()
sys.exit('The firmware image is not in this repository.')
assert mh == "8e3ecd05409b2c314ebed77320ece5930bf31c8333cd84aeef4f6b0264c1bcce", mh
assert sh == "b93570b3c2f69ccb51c113c893b4bc4c414cf78ceddde478748404e0768c6230", sh
log("MAIN sha256 %s\nSUB  sha256 %s" % (mh, sh))
assert sum(1 for x in NM if x) == 505165 and sum(1 for x in PM if x) == 365358

# 1. runs
RUNS = runs()
assert len(RUNS) == 46 and sum(b - a for a, b in RUNS) == 519
log("unset runs in final7_named_mask over 0x000000-0x07B753: %d runs, %d B" % (len(RUNS), sum(b - a for a, b in RUNS)))

# 2. decisions: (start, end_excl, class, conf, tier, typing, why)
CURVE = [(0x03628D,7),(0x03629A,4),(0x0362A8,6),(0x0362BC,2),(0x0362D8,4),(0x0362F4,2),(0x036338,6),(0x036346,6),
         (0x036354,6),(0x036362,6),(0x036372,18),(0x03638C,6),(0x0363AA,2),(0x0367BE,2),(0x0367F0,7),(0x036980,4),
         (0x0369E4,6),(0x036A16,2),(0x036A48,8),(0x036A7A,4),(0x036AAC,10),(0x036ADE,6),(0x036B10,12),(0x036B4A,6),
         (0x0376C8,152),(0x03776A,88)]
D = [
 (0x00244C,0x00245C,"fill","Confirmed","F","fill u8[16] (00x8 ffx8)","after rts 0x00244A; byte-identical to the read block 0x00245C (mov.l #0x245C at 0x002416/0x00242E, eepmov 0x10); no reader, no entry"),
 (0x004399,0x00439A,"typed data","Confirmed","C-read","u8 slot 0x4D of u8 table 0x00434C","0x05D414/0x05D8AE mov.b @(0x434C:16,er4) with er4 = received byte and.l #0xFF (0x05D40C/0x05D8A6), after ']' (0x05D3FC ac 5d)"),
 (0x005796,0x0057A8,"typed data","Inferred","no-reader","byte array (3 x 5-B groups a0 8x 8x e3 e8)","between rts 0x005794 and proven 0x0057A8; not a slot of callback table 0x0079BC..; no reader, no entry"),
 (0x006648,0x00664C,"typed data","Confirmed","C-read","BE32 slot 127 (NULL) of 0x00644C[128]","0x00A654 r4l=FF89C6&0x7F, shll #2, 0x00A664 mov.l @(0x644C:32,er4); 0x7F produced by sub_3F62E dec-wrap with record 0x017734 {00 7f, FF89C6}"),
 (0x00664C,0x006654,"fill","Confirmed","F","fill 00x8","beyond index bound 0x7F of 0x00644C; code at 0x006654; no reader, no entry"),
 (0x023145,0x023149,"typed data","Confirmed","C-read","u8 slots 1-4 of 0x023144[0x12]","0x023112 mov.b @(0x23144:32,er4), er4=FF97F8 (0..0x11 via record 0x0231EC, 1..5 not skipped by sub_231C2), when 8EA0.6 (bset 0x0211C4)"),
 (0x0254CF,0x0254D1,"typed data","Confirmed","C-extent","bytes 1-2 of step record 0 of sequence 0x0254CE (10 x 4 B)","sub_25464: er5 = [0x025496+4*r1] + 4*AE88; reads byte0, byte1 if byte0<0, byte2 (0x025492), byte3 (0x025428); AE88 = BCD digit 0..9 from FFAE80[] (sub_3FA8A)"),
 (0x0254E1,0x0254E5,"typed data","Confirmed","C-extent","byte 3 of step record 4, bytes 0-2 of record 5, sequence 0x0254CE","same reader; next sequence 0x0254F6 abuts (10 records)"),
 (0x034960,0x034965,"typed data","Confirmed","C-read","u8 slots 2-6 of 0x03495E[8]","0x034916 AAD0, 0x034934 mov.b @(0x3495E:32,er4); AAD0 = sub-band index 0..6 from range tables 0x03510A/0x035140 via sub_3F5B2 (0x0347D4/0x035DE2)"),
 (0x034965,0x034966,"typed data","Confirmed","C-extent","u8 slot 7 of 0x03495E[8]","twin 0x034956[8] ends at 0x03495D; code at 0x034966"),
] + [(a, a + n, "typed data", "Inferred", "no-reader", "byte-curve region 0x03624B-0x0377C1 (rows of 0x33)",
      "readers 0x0354EA..0x0355D2 / 0x035368 index <= 0x03624A (er1<=0x32 clamp 0x03527C, er2 from 0x03541E[4]); no operand/cell/branch into 0x03624B-0x0377C1") for a, n in CURVE] + [
 (0x03CFE6,0x03CFE8,"typed data","Confirmed","C-read","low u16 of BCD u32 0x03CFE4 = 00 46 00 00 (4.6 MHz marine duplex offset)","0x03CFD0 mov.l #0x3CFE4,er6; jsr sub_3F94C reads @(2:16,er6) (0x03F954) and @er6; taken when channel entry bit0 set (0x03CFC0, entry 0x040362 = 16 06 50 01)"),
 (0x04BA2E,0x04BA32,"typed data","Inferred","no-reader","4 B 07 08 ff 00 after jump table 0x04B9EA[17]","dispatch index from sub_4C7E4 max 0x10 (0x04C84E fb 10); no reader, no entry"),
 (0x04C3C7,0x04C3C8,"typed data","Inferred","no-reader","head byte of list 01 02 03 04 ff 05..09 ff","device-name rows 0x04C32E stride 9 end at row 16; no reader of 0x04C3C7..0x04C3D1"),
 (0x058FFE,0x059000,"typed data","Inferred","no-reader","header 1f 01 of 32-B frame 0x058FFE (checksum 0x20 at 0x05901D)","siblings 0x05901E/0x05903E loaded at 0x058F86/0x058F94; nothing loads 0x058FFE"),
 (0x05B370,0x05B37C,"typed data","Inferred","no-reader","first 12 B of 24-B class map 0x05B370","handler table 0x05B310[24] read at 0x0563DA; no reader of 0x05B370"),
 (0x062598,0x06259A,"typed data","Inferred","no-reader","last u16 of 00 05 77 13 00 12 77 20","no reader; dead routine 0x06259A follows"),
 (0x067FAF,0x067FB0,"fill","Confirmed","F","fill 00","all five 0x067FAA readers copy exactly 5 B (fc 05, e.g. 0x00DF62); 'DNEWS' starts 0x067FB0; no reader"),
 (0x069A7F,0x069AAA,"stale copy","Confirmed","S","byte array, stale copy of sub_69964","first 37 B identical to proven 0x069964-0x069988; odd address; after label buffer 0x069A4A+0x35"),
 (0x06C56F,0x06C570,"fill","Confirmed","F","fill 00","eepmov 0x37 from 0x06C538 (0x06BD3E) ends at 0x06C56E; no reader"),
 (0x06C596,0x06C598,"typed data","Inferred","no-reader","04 00 tail of FT2D version record 0x06C570","record 0x06C570 has no reader"),
 (0x06F586,0x06F588,"typed data","Confirmed","C-read","bytes 0x52-0x53 of 128-B template 0x06F534","sub_6F4C6 (0x06F4C6 fc 80; mov.l #0x6F534; eepmov) and sub_6F512 copy 0x80 B"),
 (0x073408,0x07340A,"typed data","Confirmed","C-read","u16 len of record 4 of {u16 len; u32 src; u32 dst}[5] at 0x0733E0","0x073382 r2=AD68-1, *10; 0x073390 mov.w @(0x733E0:32,er2); AD68=5 stored at 0x0184AC (fc 05 6a 8c ad 68)"),
]
D.sort()
for i in range(len(D) - 1): assert D[i][1] <= D[i + 1][0], (hex(D[i][0]), hex(D[i + 1][0]))
cov = bytearray(E)
for a, b, *_ in D:
    for x in range(a, b): cov[x] += 1
assert all(cov[x] == (0 if NM[x] else 1) for x in range(E)), "decisions must tile the 519 unset bytes exactly"
log("decisions tile all 519 bytes exactly (%d rows)" % len(D))

# 3. citations: (addr, hex bytes, must_be_proven)
CIT = [
 (0x002416,"7a 05 00 00 24 5c",1),(0x00242E,"7a 05 00 00 24 5c",1),(0x00244A,"54 70",1),
 (0x00244C,"00 00 00 00 00 00 00 00 ff ff ff ff ff ff ff ff",0),(0x00245C,"00 00 00 00 00 00 00 00 ff ff ff ff ff ff ff ff",0),
 (0x05D3FC,"ac 5d 47 06",1),(0x05D406,"6a 2c 00 fe f9 64 7a 64 00 00 00 ff 0c cb 6e 4c 43 4c",1),
 (0x05D8A0,"6a 2c 00 ff 0c 3a 7a 64 00 00 00 ff 0c cb 6e 4c 43 4c",1),(0x004399,"00",0),
 (0x00643A,"6a 0c 89 c6 ec 7f ac 29 47 04 5e 00 a6 54",1),(0x00A654,"6a 0c 89 c6 ec 7f f4 00 10 54 7a 64 00 00 ff ff 78 c0 6b 25 00 00 64 4c",1),
 (0x017714,"6a 18 a9 ee 70 00",1),(0x017722,"7a 06 00 01 77 34 5e 03 f6 2e",1),(0x017734,"00 7f 00 ff 89 c6",0),
 (0x03F656,"01 00 6f 65 00 02 68 5b 69 64 1c 4b 47 02 44 0a 0c cb",1),(0x006644,"00 ff a4 f5 00 00 00 00",0),
 (0x00664C,"00 00 00 00 00 00 00 00 55 10",0),
 (0x0230FC,"6a 0c 97 f8 7a 64 00 00 00 ff 6a 10 8e a0 73 60 47 0e ac 10 47 0a 78 40 6a 2b 00 02 31 44",1),
 (0x023144,"ff 00 00 00 00 00 ff",0),(0x0231C2,"7a 06 00 02 31 ec 5e 03 f6 2e",1),(0x0231EC,"00 11 00 ff 97 f8",0),
 (0x0231D4,"ab 00 47 ea ac 02 46 04 ab 11 47 e2 ab 06 47 de ab 07 47 da",1),(0x0102F8,"fc 00 6a 8c 97 f8",1),(0x0211C4,"6a 18 8e a0 70 60",1),
 (0x03F636,"01 00 6f 65 00 02 68 5b 69 64 1c bc 47 02 44 0a",1),(0x03F650,"0a 0b 68 db",1),
 (0x025464,"78 90 6b 25 00 02 54 96 6a 0c ae 88 7a 64 00 00 00 ff 10 4c 0a c5 6c 5b 4b 04 0b 05",1),
 (0x02548C,"6c 5b 5e 02 52 a0 6c 5b 54 70",1),(0x025420,"5e 02 54 64 5e 02 52 a0 68 5b",1),
 (0x025496,"00 02 54 ce 00 02 54 ce 00 02 54 ce 00 02 54 ce 00 02 55 1e 00 02 54 ce",0),
 (0x0254CE,"00 00 00 00 ff 00 00 00 ff 00 00 00 ff 00 00 00 ff 00 00 00 00 00 00 00 ff 05",0),
 (0x0253C0,"7a 05 00 ff ae 80 5e 03 fa 8a",1),(0x0253D0,"78 10 6a 2c 00 02 53 34 7a 64 00 00 00 ff 1a 0c 6e 4c ae 80 6a 8c ae 88",1),
 (0x03FA8A,"6d 56 10 46 10 46 14 e6",1),(0x025416,"6a 0c ae 88 ac 05 47 1a",1),
 (0x034916,"6a 0c aa d0 7a 64 00 00 00 ff 78 40 6a 2b 00 03 49 56",1),(0x034934,"78 40 6a 2b 00 03 49 5e",1),
 (0x034956,"02 02 04 04 04 08 08 00 00 00 00 00 00 00 00 00 6a 0c",0),(0x0347D4,"5e 03 f5 b2 6a 8b aa d0",1),(0x035DE2,"5e 03 f5 b2 6a 8b aa d0",1),
 (0x03510A,"00 0a 00 05 04 00 00 00 07 59 95 00 00 00",0),(0x035140,"00 0a 00 02 30 00 00 00 41 99 95 00 00 05 42 00 00 00 57 99 95 00 00 06",0),
 (0x03F5E2,"6f 63 00 08",1),
 (0x03527C,"7a 01 00 00 00 32",1),(0x03535E,"79 04 00 33 0f a6 52 46 0a 96 78 60 6a 2e 00 03 61 16",1),(0x03541E,"03 02 01 00",0),
 (0x0354EA,"78 10 6a 2e 00 03 62 18",1),(0x0355A2,"78 10 6a 2e 00 03 62 18",1),(0x036273,"23 23 22 23",0),
 (0x03CFC0,"73 0c 47 16",1),(0x03CFD0,"7a 06 00 03 cf e4 5e 03 f9 4c",1),(0x03CFE0,"5a 03 d1 ee 00 46 00 00 5e 03 ce 9a",0),
 (0x03F94C,"fc 00 08 cc 6f 53 00 02 6f 64 00 02",1),(0x040362,"16 06 50 01",0),
 (0x04B8FE,"78 b0 6b 26 00 04 b9 ea 59 60",1),(0x04C84E,"fb 10",1),(0x04BA2A,"00 04 b9 08 07 08 ff 00 7a 05",0),
 (0x04C2A8,"7a 05 00 04 c3 2c",1),(0x04C2C0,"6d 54 f3 00 52 43 0a b5 6c 54 a4 ff 47 08",1),(0x04C3BE,"2d 2d 2d 2d 2d 2d 2d ff 00 01 02 03 04 ff 05 06 07 08 09 ff",0),
 (0x058F86,"7a 04 00 05 90 1e",1),(0x058F94,"7a 04 00 05 90 3e",1),(0x058FFE,"1f 01 00 00",0),(0x05901C,"00 20 1f 02",0),
 (0x0563DA,"78 b0 6b 26 00 05 b3 10",1),(0x05B370,"00 00 00 00 00 00 00 01 01 01 01 02 02 02 02 02 03 03 03 03 03 00 02 00",0),
 (0x062590,"ff 00 00 05 77 13 00 12 77 20 f2 10",0),
 (0x00DF62,"fc 05 f4 00 7a 05 00 06 7f aa",1),(0x00E4AA,"fc 05 f4 00 7a 05 00 06 7f aa",1),(0x06042E,"fc 05 f4 00 7a 05 00 06 7f aa",1),
 (0x06049C,"fc 05 f4 00 7a 05 00 06 7f aa",1),(0x063468,"fc 05 f4 00 7a 05 00 06 7f aa",1),(0x067FAA,"ff ff ff ff ff 00 44 4e 45 57 53 00",0),
 (0x069914,"7a 06 00 06 99 64 01 00 6b 86 b2 88",1),(0x069A48,"00 35",0),(0x0699A6,"7a 05 00 06 9a 48",1),
 (0x069964,"6a 0c b3 f5 1c 9c 46 04 6a 89 b3 f4 79 04 00 10 52 41 7a 11 00 ff 45 76 0f 95 7a 15 00 00 00 05 68 5c ac ff 47 02",1),
 (0x069A7F,"6a 0c b3 f5 1c 9c 46 04 6a 89 b3 f4 79 04 00 10 52 41 7a 11 00 ff 45 76 0f 95 7a 15 00 00 00 05 68 5c ac ff 47 0e 79 04 00 01 6b",0),
 (0x06BD3E,"79 04 00 37 7a 05 00 06 c5 38 7a 06 00 fe e0 00 7b d4 59 8f",1),(0x06C56A,"30 43 30 31 04 00 01 56 30 30 32 30 46 54 32 44",0),(0x06C594,"31 38 04 00 01 42",0),
 (0x06F4C6,"fc 80 f4 00 7a 05 00 06 f5 34 7a 06 00 ff 2e ca 7b d4 59 8f",1),(0x06F51A,"fc 80 f4 00 7a 05 00 06 f5 34",1),(0x06541C,"5e 06 f4 c6",1),
 (0x06F584,"00 00 00 00 20 20",0),(0x06F5B4,"6a 10 bb f2",1),
 (0x073382,"6a 0a ad 68 1a 0a f2 00 79 04 00 0a 52 42 78 20 6b 24 00 07 33 e0 47 18",1),
 (0x0733E0,"00 70 00 ff ab 08 00 ff aa ec",0),
 (0x020D50,"00 0a 00 01 43 90 00 00 43 99 95 00 00 01",0),(0x030B70,"00 30 55 00 00 00 57 99 95 00 00 48",0),(0x00F190,"00 00 47 00 00 00 30 00 00 00 57 99 95 00",0),
 (0x02853C,"00 03 6b 04 bb c2",0),(0x04B49C,"ff 20 2d 2e 2d ff 00 03 6b 6d ff 6d 69 ff",0),(0x073408,"00 00 00 ff ab 5c 00 ff ab 5c 6a 10",0),(0x0184AC,"fc 05 6a 8c ad 68",1),
]
fails = 0
for a, h, p in CIT:
    b = bytes.fromhex(h.replace(" ", ""))
    ok = img[a:a + len(b)] == b and (not p or all(PM[x] for x in range(a, a + len(b))))
    if not ok:
        fails += 1; log("CITATION FAIL %06X want %s got %s P=%s" % (a, h, hx(a, len(b)), [PM[x] for x in range(a, a + len(b))]))
assert img[0x069964:0x069964 + 37] == img[0x069A7F:0x069A7F + 37] and img[0x069964 + 37] != img[0x069A7F + 37]
log("citations: %d checked, %d failed; stale copy 37-B identity holds" % (len(CIT), fails))

# 4. whole-image edge/reader scan per run
ks = sorted(heads)
def head_of(x):
    i = bisect.bisect_right(ks, x) - 1
    if i < 0: return None
    h = ks[i]
    return h if x < h + heads[h][0] else None
def hit_kind(s, v):
    h = head_of(s)
    if h is None: return "unk-bytes", None
    sz, k, fn, d, ops = heads[h]
    if k == "code":
        if any(v in (ov, oa) for t, ov, oa in ops): return "code-operand", h
        return "straddle", h
    return "data-cell:" + k, h
refrows = []
summary = {}
for a, b in RUNS:
    cnt = {}
    def add(kind, s, v, how):
        cnt[kind] = cnt.get(kind, 0) + 1
        if kind != "straddle":
            refrows.append("%06X\t%06X\t%s\t%06X\t%06X\t%s\t%d\t%d" % (a, b - 1, how, s, v, kind, PM[s], NM[s]))
    for s in range(E - 3):
        v = int.from_bytes(img[s:s + 4], "big")
        if a <= v < b:
            k, h = hit_kind(s, v); add(k, s, v, "BE32")
    for s in range(0, E - 3, 2):
        if img[s] in (0x5A, 0x5E):
            v = int.from_bytes(img[s + 1:s + 4], "big")
            if a <= v < b:
                k, h = hit_kind(s + 1, v); add("abs24-" + k, s, v, "jsr/jmp")
        o = img[s]
        if (o & 0xF0) == 0x40 or o == 0x55:
            d8 = img[s + 1]; t = s + 2 + (d8 - 256 if d8 > 127 else d8)
            if a <= t < b: add("rel8-" + hit_kind(s, t)[0], s, t, "rel8")
        if (o == 0x58 and (img[s + 1] & 0x0F) == 0) or (o == 0x5C and img[s + 1] == 0):
            d16 = be16(s + 2); t = s + 4 + (d16 - 65536 if d16 > 32767 else d16)
            if a <= t < b: add("rel16-" + hit_kind(s, t)[0], s, t, "rel16")
    for s in range(0, 0x400, 4):
        v = int.from_bytes(img[s:s + 4], "big")
        if a <= v < b: add("vector", s, v, "vector")
    for ea, (sz, k, fn, d, ops) in heads.items():
        if k == "code":
            for t, ov, oa in ops:
                if t != 7 and any(a <= x < b for x in (ov, oa)): add("ida-operand", ea, ov if a <= ov < b else oa, "op")
    if a < 0x8000:   # abs16 / d:16 / #imm16 forms (sign-extended addressing reaches 0..0x7FFF)
        for s in range(2, E - 1, 2):
            v = be16(s)
            if a <= v < b:
                o1, o2 = img[s - 2], img[s - 1]
                if (o1 in (0x6A, 0x6B) and (o2 >> 4) in (0, 1, 3, 4, 8, 9, 0xA, 0xC)) or o1 in (0x6E, 0x6F) or (o1 == 0x7A and 8 <= o2 <= 0xF):
                    add("abs16-" + hit_kind(s, v)[0], s - 2, v, "abs16/d16")
    summary[(a, b)] = cnt
# 5. outputs
with open(os.path.join(O, "refs.tsv"), "w", encoding="utf-8", newline="\n") as f:
    f.write("run_start\trun_end\tform\tsite\tvalue\tsite_kind\tsite_P\tsite_N\n")
    f.write("\n".join(refrows) + ("\n" if refrows else ""))
with open(os.path.join(O, "runs.tsv"), "w", encoding="utf-8", newline="\n") as f:
    f.write("run_start\trun_end\tlen\tbytes(first 24)\tdecision_rows\tclasses\tinbound_hits(non-straddle)\tstraddles\n")
    for a, b in RUNS:
        rows = [d for d in D if a <= d[0] < b]
        c = summary[(a, b)]
        ns = sum(v for k, v in c.items() if k != "straddle")
        f.write("%06X\t%06X\t%d\t%s\t%s\t%s\t%d\t%d\n" % (a, b - 1, b - a, hx(a, min(24, b - a)),
                ";".join("%06X-%06X" % (d[0], d[1] - 1) for d in rows), ";".join("%s/%s/%s" % (d[2], d[3], d[4]) for d in rows), ns, c.get("straddle", 0)))
tot = {}
with open(os.path.join(O, "proposed-typing.tsv"), "w", encoding="utf-8", newline="\n") as f:
    f.write("start\tend_incl\tlen\tclass\tconf\ttier\ttyping\tevidence\tin_named_delta\n")
    for a, b, cl, cf, tr, ty, why in D:
        nd = "yes" if cf == "Confirmed" else "no"
        f.write("%06X\t%06X\t%d\t%s\t%s\t%s\t%s\t%s\t%s\n" % (a, b - 1, b - a, cl, cf, tr, ty, why, nd))
        tot[(cl, cf, tr)] = tot.get((cl, cf, tr), 0) + (b - a)
named = sum(b - a for a, b, cl, cf, *_ in D if cf == "Confirmed")
inf = sum(b - a for a, b, cl, cf, *_ in D if cf != "Confirmed")
assert named + inf == 519
for k in sorted(tot): log("  %-12s %-9s %-10s %4d" % (k[0], k[1], k[2], tot[k]))
log("named delta (Confirmed, disjoint) = %d  -> MAIN named %d / 505684 = %.4f%%" % (named, 505165 + named, 100.0 * (505165 + named) / 505684))
log("still unnamed (Inferred, no reader) = %d" % inf)
log("proven delta = 0 (no run is reached code)")
for (a, b), c in summary.items():
    nonstr = {k: v for k, v in c.items() if k != "straddle"}
    if nonstr: log("  run %06X-%06X non-straddle hits: %s" % (a, b - 1, nonstr))
open(os.path.join(O, "verify.txt"), "w", encoding="utf-8", newline="\n").write("\n".join(LOG) + "\n")
