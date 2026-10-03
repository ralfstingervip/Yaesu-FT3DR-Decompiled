r"""M15: byte-check every citation in docs\deep\127-sub-residue-final.md against the SUB image (read-only)."""
# Repository layout: this script lives under ida/out/; paths below are derived from its location.
from pathlib import Path as _Path
_REPO = _Path(__file__).resolve().parents[3]
def _no_image():
    import sys
    sys.exit("The firmware image is not in this repository.")
import hashlib, struct, os
R = str(_REPO)
img = open(os.path.join(R, _no_image()), "rb").read()
B = 0xFFC00000
ok = fail = 0
def chk(ea, hx, what=""):
    global ok, fail
    want = bytes.fromhex(hx.replace(" ", ""))
    got = img[ea - B:ea - B + len(want)]
    if got == want: ok += 1
    else:
        fail += 1; print("FAIL %08X want %s got %s %s" % (ea, want.hex(), got.hex(), what))
assert hashlib.sha256(img).hexdigest() == "b93570b3c2f69ccb51c113c893b4bc4c414cf78ceddde478748404e0768c6230"
assert hashlib.sha256(open(os.path.join(R, _no_image()), "rb").read()).hexdigest().startswith("8e3ecd05409b2c31")
C = [
 (0xFFC0000E, "fb e2 80 ff ff ff"), (0xFFC00014, "fd 68 ed"), (0xFFC00017, "fb e2 70 8a ed ff"), (0xFFC0001D, "fd 68 ec"),
 (0xFFF2A7EE, "20 0f"), (0xFFF2A7F9, "a0 09 2e 7e a9 8c 72 41 0c 10"), (0xFFF2A7FB, "2e 7e"),
 (0xFFEE177D, "67 02 02"), (0xFFEE177F, "02"), (0xFFF3758E, "02 02"), (0xFFF375A3, "02 02 02 fb"),
 (0xFFF47E5E, "7f 95 02 7f 95"), (0xFFEF202A, "75 41 28 05 6b c2 fe 02"), (0xFFEF2032, "02 71 00 ec"),
 (0xFFF13DDA, "72 00 e0 fe f9 05 8e 00 f9 05 8d 00 3c 84 00 3e 02 00 3e 01 00"), (0xFFF13DEF, "fb e2 78 02 02 00"),
 (0xFFF3B8CB, "75 42 64 66 51 05 08 e6 ff"), (0xFFF3B8D4, "fb e2 60 08 01 00"),
 (0xFFEDAE05, "71 00 ec a1 01 a0 8a a9"), (0xFFF1743B, "71 00 ec"), (0xFFF17440, "05 56 ea ff"),
 (0xFFEF05DD, "71 00 ec a1 01 91 8a 91 83 3d 04 00 2e 53"),
 (0xFFF2A718, "fb e2 2c 5e 06 00"), (0xFFEF03F1, "70 11 00 00 00 07"),
 (0xFFEE2220, "66 03 7f 13"), (0xFFEE223B, "66 03 7f 13"),
 (0xFFF0F2F6, "fb 5e 00 00 04 ef"), (0xFFEDF024, "05 04 ef ff"), (0xFFED9B0B, "ff bc f1 ec"), (0xFFED222F, "00 78 f1 d9"),
 (0xFFC46712, "96 b5 ef 7b"),
]
for ea, hx in C:
    chk(ea, hx)
# branch arithmetic
def s8(v): return v - 256 if v > 127 else v
assert 0xFFF2A7EE + s8(0x0F) == 0xFFF2A7FD; assert 0xFFF2A7FB + s8(0x7E) == 0xFFF2A879; assert 0xFFEF05E9 + 0x53 == 0xFFEF063C
assert (0xFFEDF024 + (0xFFEF04 - (1 << 24))) & 0xFFFFFFFF == 0xFFEDDF28
ok += 4
# vectors: none of the 288 slots lands in the residue (recomputed here from the masks)
M = os.path.join(R, "ida/out/sub-final3/raw/mask_final3_after_%s.bin")
HW = open(M % "headline_w2", "rb").read(); A = open(M % "allwf", "rb").read()
res = set(0xFFED0000 + i for i in range(len(A)) if A[i] and not HW[i])
assert len(res) == 3736 and 0xFFF2A7FC in res and 0xFFF2A7FD not in res; ok += 1
vec = [struct.unpack_from("<I", img, 0xFFED8A70 - B + 4 * i)[0] for i in range(256)] + [struct.unpack_from("<I", img, 0xFFFFFF80 - B + 4 * i)[0] for i in range(32)]
assert not (set(vec) & res); ok += 1
# runs.tsv first_bytes and lengths
L = open(os.path.join(R, "ida/out/sub-residue-final/runs.tsv"), encoding="utf-8").read().splitlines()
hd = L[0].split("\t"); tot = 0
for l in L[1:]:
    r = dict(zip(hd, l.split("\t")))
    s, e = int(r["start"], 16), int(r["end"], 16)
    assert int(r["bytes"]) == e - s and int(r["file_off"], 16) == s - B
    assert all(x in res for x in range(s, e)) and (s - 1) not in res and e not in res
    chk(s, r["first_bytes"], r["start"]); tot += e - s
assert tot == 3736; ok += 1
print("citations ok %d fail %d" % (ok, fail))
# RAM-copied images (DTBL FFED8A34: 3 entries) scanned as if executed at their RAM destination: bra.a/bsr.a into residue
dt = [struct.unpack_from("<3I", img, 0xFFED8A34 - B + 12 * i) for i in range(3)]
hits = []
for src, end, dst in dt:
    for o in range(src, end - 3):
        b0 = img[o - B]
        if b0 in (4, 5):
            d = int.from_bytes(img[o - B + 1:o - B + 4], "little"); d = d - (1 << 24) if d >> 23 else d
            t = (dst + (o - src) + d) & 0xFFFFFFFF
            if t in res: hits.append((o, t))
print("DTBL", ["%08X-%08X->%08X" % x for x in dt], "RAM-relative bra.a/bsr.a patterns into residue:", len(hits))
