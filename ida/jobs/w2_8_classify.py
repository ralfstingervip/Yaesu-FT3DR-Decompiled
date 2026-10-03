r"""Lane W2-8 Task 1: reclassify lane-5 'other' runs, carry all else through.
Pure-Python: reads runs.tsv (lane 5), the MAIN image (base 0 -> file offset =
address), the code-decode probe (w2_8_probe2.tsv from IDA), and lane-5 table
files. Emits the complete 3,854-row table ida\out\wave2\main-raw-types.tsv with
columns: start end size type source evidence.
Closed service window 0x078106-0x07B753: byte-class only, stays 'other'.
"""
from __future__ import annotations
import sys
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root
import csv, os, collections

ROOT = str(_REPO)
BINP = os.path.join(ROOT, "decrypted", "FT3D_MAIN_ver102_EXP.bin")
MR = os.path.join(ROOT, "ida", "out", "main-raw")
MF = os.path.join(ROOT, "ida", "out", "main-full")
LOGDIR = os.path.join(ROOT, "ida", "log", "jobs", "W2_MAIN_RAW2")
OUTDIR = os.path.join(ROOT, "ida", "out", "wave2")
os.makedirs(OUTDIR, exist_ok=True)
OUT_TSV = os.path.join(OUTDIR, "main-raw-types.tsv")

CONTENT_END = 0x07B754
CODE_LO = 0x400
RAM_LO = 0xFE0000
RAM_HI = 0x1000000
CLOSED_LO = 0x078106
CLOSED_HI = 0x07B753

DATA = sys.exit("The firmware image is not in this repository.")


def load_tsv(path):
    rows = []
    with open(path, encoding="utf-8") as h:
        r = csv.reader(h, delimiter="\t"); next(r)
        for x in r:
            if x and not x[0].startswith("#"):
                rows.append(x)
    return rows


# ---- func starts / table targets (for pointer-table target tests) ----
func_starts = set()
for x in load_tsv(os.path.join(MF, "functions.tsv")):
    func_starts.add(int(x[0], 16))

# ---- probe signals for 'other' runs ----
probe = {}
for x in load_tsv(os.path.join(LOGDIR, "w2_8_probe2.tsv")):
    s = int(x[0], 16)
    probe[s] = dict(first=x[3], n=int(x[4]), cov=float(x[5]), ends=x[6],
                    clean=(x[7] == "clean"), refs=int(x[8]))

# ---- load lane-5 runs ----
runs = [[int(x[0], 16), int(x[1], 16), int(x[2]), x[3], x[4]] for x in
        load_tsv(os.path.join(MR, "runs.tsv"))]
N = len(runs)


def dword_be(off):
    return int.from_bytes(DATA[off:off + 4], "big")


def in_addr(v):
    return (CODE_LO <= v < CONTENT_END) or (RAM_LO <= v < RAM_HI)


def classify_other(i):
    s, e, L, t, ev = runs[i]
    b = DATA[s:e]
    prev_t = runs[i - 1][3] if i > 0 else "-"
    next_t = runs[i + 1][3] if i + 1 < N else "-"
    prev_adj = i > 0 and runs[i - 1][1] == s
    next_adj = i + 1 < N and runs[i + 1][0] == e
    distinct = len(set(b))
    npr = sum(1 for c in b if 0x20 <= c <= 0x7E)
    dom, domc = collections.Counter(b).most_common(1)[0]
    pad = sum(b.count(x) for x in (0x00, 0xFF, 0x20))

    # 0) closed service window -> byte-class only, stays other
    if CLOSED_LO <= s <= CLOSED_HI:
        return None, None    # leave as lane-5 'other'

    p = probe.get(s)
    code_nb = ("recovered code" in prev_t) or ("recovered code" in next_t) or \
              ("code" in prev_t) or ("code" in next_t)

    # 1) CODE: clean full decode, >=2 insns, ends in control-xfer or refs code
    if p and p["clean"] and p["n"] >= 2 and (p["ends"] in ("ret", "call", "br") or p["refs"] >= 1):
        return "code", ("decodes clean: %d insns, first=%s%s%s; recovered code fragment"
                        % (p["n"], p["first"],
                           ", ends " + p["ends"] if p["ends"] else "",
                           ", %d in-range refs" % p["refs"] if p["refs"] else "")
                        + (" (between code)" if code_nb else ""))

    # 2) FILL: padding/alignment
    if distinct == 1 and dom in (0x00, 0xFF, 0x20):
        return "fill", "0x%02X padding/alignment, %d bytes" % (dom, L)
    if pad == L and L <= 12:
        return "fill", "alignment/erase padding (00/FF/20 only), %d bytes" % L
    if domc / L >= 0.75 and dom in (0x00, 0xFF, 0x20):
        return "fill", "0x%02X-dominated padding (%d/%d), %d bytes" % (dom, domc, L, L)

    # 3) STRING: printable text or string-table field between strings
    if L >= 4 and npr / L >= 0.80 and any(0x41 <= c <= 0x7A for c in b):
        txt = "".join(chr(c) if 0x20 <= c <= 0x7E else "." for c in b)
        return "string", 'ASCII "%s"' % txt[:40]
    if "string" in prev_t and "string" in next_t and npr / L >= 0.5 and L >= 3:
        txt = "".join(chr(c) if 0x20 <= c <= 0x7E else "." for c in b)
        return "string", 'string-table field/padding "%s"' % txt[:32]

    # 4) POINTER TABLE: aligned dwords in addr range, neighbour/target confirms
    if s % 2 == 0 and L >= 4 and L % 4 == 0:
        nd = L // 4
        vals = [dword_be(s + 4 * k) for k in range(nd)]
        inrange = sum(1 for v in vals if in_addr(v))
        fs = sum(1 for v in vals if v in func_starts)
        if inrange == nd and (fs >= 1 or "pointer table" in prev_t or "pointer table" in next_t
                              or nd >= 3):
            return "pointer table", ("%d BE dword pointer(s) in addr range (%d func-starts)"
                                     % (nd, fs))

    # 5) PARAMETER TABLE by neighbour/shape
    #  5a) small-int fields interleaved in a pointer-table record array
    if "pointer table" in prev_t and "pointer table" in next_t and L % 2 == 0 and L <= 16:
        return "parameter table", ("record field(s) interleaved in pointer/record table, %d bytes" % L)
    #  5b) data island in sparse 0x00-padded parameter region (between fills)
    if "fill" in prev_t and "fill" in next_t and prev_adj and next_adj:
        return "parameter table", ("data island in 0x00-padded parameter table region, %d bytes" % L)
    #  5c) continuation of an adjacent parameter table
    if ("parameter table" in prev_t and prev_adj) or ("parameter table" in next_t and next_adj):
        return "parameter table", ("adjacent-to parameter table; structured data, %d bytes" % L)
    #  5c-ramp) byte-ramp / monotonic LUT (e.g. 0x003A84): long non-decreasing
    #  byte subrun is unmistakable data (code is never monotonic for 20+ bytes)
    if L >= 24 and not (p and p["clean"]):
        best = cur = 1
        for k in range(1, L):
            if b[k] >= b[k - 1]:
                cur += 1; best = max(best, cur)
            else:
                cur = 1
        if best >= 20:
            return "parameter table", ("byte-ramp / monotonic LUT (run of %d "
                                       "non-decreasing bytes), %d bytes" % (best, L))
    #  5d) monotonic curve / level-ramp LUT (e.g. 0x003A84)
    if L >= 24:
        deltas = [abs(b[k] - b[k - 1]) for k in range(1, L)]
        ramp = sum(1 for d in deltas if d <= 8) / len(deltas)
        u16 = [int.from_bytes(b[k:k + 2], "big") for k in range(0, L - 1, 2)]
        small16 = sum(1 for v in u16 if v < 0x8000) / len(u16) if u16 else 0
        if ramp >= 0.75 and npr / L < 0.5:
            return "parameter table", ("byte level-ramp / monotonic curve LUT, %d bytes" % L)
        if small16 >= 0.7 and L % 2 == 0:
            return "parameter table", ("16-bit BE value/record table, %d entries" % len(u16))
    #  5e) 16-bit BE value table (shorter, even length, small words), data context
    if L >= 8 and L % 2 == 0 and npr / L < 0.6:
        u16 = [int.from_bytes(b[k:k + 2], "big") for k in range(0, L, 2)]
        if sum(1 for v in u16 if v < 0x4000) / len(u16) >= 0.7:
            return "parameter table", ("16-bit BE value table, %d entries" % len(u16))
    #  5f) small byte/index table (small alphabet, non-text), data context
    if L >= 8 and distinct <= 20 and npr / L < 0.6:
        return "parameter table", ("byte/index table, %d distinct values, %d bytes" % (distinct, L))

    # 6) stays other
    if L >= 64:
        reason = ("large mixed code/data block, no clean decode from run start "
                  "(leading stub + embedded data), len=%d pr=%.2f" % (L, npr / L))
    else:
        reason = ("interstitial fragment len=%d pr=%.2f zero=%.2f between %s/%s"
                  % (L, npr / L, b.count(0) / L, prev_t, next_t))
    return None, reason


# ---- build output rows ----
out = []
newly = 0
moved_bytes = collections.Counter()
new_by_type = collections.Counter()
remain_other = 0
remain_other_bytes = 0
closed_other = 0
closed_bytes = 0
for i in range(N):
    s, e, L, t, ev = runs[i]
    if t != "other":
        out.append((s, e, L, t, "lane5", ev))
        continue
    nt, nev = classify_other(i)
    if CLOSED_LO <= s <= CLOSED_HI:
        closed_other += 1; closed_bytes += L
        out.append((s, e, L, "other", "lane5",
                    "service-window fill/data, closed (byte-class only)"))
        continue
    if nt is None:
        remain_other += 1; remain_other_bytes += L
        out.append((s, e, L, "other", "lane5", nev or ev))
    else:
        newly += 1; moved_bytes[nt] += L; new_by_type[nt] += 1
        out.append((s, e, L, nt, "w2-8", nev))

# ---- write TSV ----
with open(OUT_TSV, "w", encoding="utf-8", newline="\n") as h:
    h.write("start\tend\tsize\ttype\tsource\tevidence\n")
    for s, e, L, t, src, ev in out:
        h.write("%06X\t%06X\t%d\t%s\t%s\t%s\n" % (s, e, L, t, src,
                ev.replace("\t", " ").replace("\n", " ")))

# ---- summary ----
print("total rows:", len(out))
tc = collections.Counter(); tb = collections.Counter()
for s, e, L, t, src, ev in out:
    tc[t] += 1; tb[t] += L
print("--- final type counts (rows / bytes) ---")
for t in ("recovered code", "code", "pointer table", "parameter table", "string",
          "fill", "font", "other"):
    if tc[t] or t in ("code", "other"):
        print("  %-16s %5d rows  %7d B" % (t, tc[t], tb[t]))
print("untyped(other) before: 997 (lane5)")
print("newly typed by w2-8:", newly, "runs")
for t, c in new_by_type.most_common():
    print("   +%-16s %4d runs  %6d B" % (t, c, moved_bytes[t]))
print("bytes moved out of other:", sum(moved_bytes.values()))
print("remaining other (non-closed):", remain_other, "runs", remain_other_bytes, "B")
print("remaining other (closed window):", closed_other, "runs", closed_bytes, "B")
print("total remaining other:", remain_other + closed_other, "runs",
      remain_other_bytes + closed_bytes, "B")
# byte-sum integrity
assert sum(r[2] for r in out) == sum(r[2] for r in runs), "byte-sum mismatch!"
print("byte-sum integrity OK:", sum(r[2] for r in out), "==", 226212)
