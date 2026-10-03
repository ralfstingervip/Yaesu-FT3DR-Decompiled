r"""Lane H10 -- build conflicts-resolved.tsv, orphans.tsv, ledger-delta.tsv from the raw job outputs.
Plain Python (no IDA).  python "ida/out/sub-phase/raw/h10_build.py"
"""
# Repository layout: this script lives under ida/out/; paths below are derived from its location.
from pathlib import Path as _Path
_REPO = _Path(__file__).resolve().parents[4]
def _no_image():
    import sys
    sys.exit("The firmware image is not in this repository.")
import os

ROOT = str(_REPO)
RAW = os.path.join(ROOT, "ida/out/sub-phase/raw")
OUT = os.path.join(ROOT, "ida/out/sub-phase")
GAP = os.path.join(ROOT, "ida/out/sub-gap")
BIN = os.path.join(ROOT, _no_image())
img = open(BIN, "rb").read()
B = 0xFFC00000


def rd(path):
    with open(path, encoding="utf-8") as h:
        lines = h.read().splitlines()
    hdr = lines[0].split("\t")
    return [dict(zip(hdr, ln.split("\t"))) for ln in lines[1:] if ln]


H = lambda s: int(s, 16)
fnc = {H(r["start"]): (H(r["end"]), r["validated"]) for r in rd(os.path.join(ROOT, "ida/out/sub-window/functions.tsv"))}
rep = rd(os.path.join(RAW, "repairs.tsv"))
crow = {H(r["target"]): r for r in rd(os.path.join(RAW, "conflict_rows.tsv"))}
new = rd(os.path.join(RAW, "fix_new.tsv"))
gap = rd(os.path.join(GAP, "gap-runs.tsv"))
gaplen = {H(r["start"]): int(r["len"]) for r in gap}

BLK = (0xFFEEC133, 0xFFEEC18A)
UNIT = {0xFFF366C7: (0xFFF3627B, 116, "true bsr.w at FFF366CB `39 b0 fb` -> orphan FFF3627B"),
        0xFFF4030A: (0xFFF40314, 21, "true bsr.w at FFF4030C `39 08 00` -> orphan FFF40314"),
        0xFFEEA550: (0xFFEEA555, 3, "true beq.s at FFEEA550 `15` -> fragment FFEEA555 `f8 06 00`")}

done_t = set()
rows = []
for i, r in enumerate(rep, 1):
    T = H(r["target"]); src = r["src"]; kind = r["kind"]
    spur = r["anchor"].startswith("SPURIOUS")
    td = r["true_decode"]
    fh = [x for x in r["fake_heads"].split(",") if x]
    ffs = [x for x in fh if H(x) in fnc]
    origin = {"gap-conflict": "H8 gap code-conflict run", "manual": "H10 (found after first repair pass)"}.get(kind, "H8 conflicts.tsv")
    if spur:
        cl = "S"; verdict = "IDA decode at target is correct; the edge comes from an out-of-phase IDA item (source lies inside a true instruction), so the edge is not real"
    elif BLK[0] <= T < BLK[1]:
        cl = "C"; verdict = "true decode (linear bsr.a/bra pairs from case FFEEC133) correct; IDA items FFEEC134..FFEEC186 out of phase"
    elif kind == "gap-conflict":
        cl = "G"; verdict = "H8 linear decode correct; bytes sat under an out-of-phase non-validated IDA item"
    elif td.split(" ")[1:2] and td.split(" ")[1][:6] in ("710460", "710360", "71045c", "710464"):
        cl = "A"; verdict = "true decode correct: call-site argument block (add #imm,sp,rN ; mov.l rN,dsp[sp]); lane-4 'function' starting with `60 a0` is a mis-split tail"
    elif crow.get(T, {}).get("ida_insn", "").startswith("pushm") or crow.get(T, {}).get("ida_insn", "").startswith("pushm"):
        cl = "P"; verdict = "true decode correct: the `6e` operand byte of the previous insn was read as a pushm opcode"
    else:
        cl = "O"; verdict = "true decode correct; IDA item out of phase"
    add = 0; note = ""
    if T not in done_t and not spur:
        try:
            a0 = H(r["anchor"]); a1 = H(r["resync"])
        except ValueError:
            a0 = a1 = 0
        if kind == "gap-conflict":
            add = gaplen.get(T, 0); note = "H8 'code-conflict' run %08X (%d B) is code" % (T, add)
        else:
            add = sum(int(n["new_bytes"]) for n in new if n["kind"] == "repair" and a0 <= H(n["ea"]) < a1)
            if add:
                note = "`f8 04 00` (mov.l #0,[sp]) completed; 2 B H8 fragment now code"
        if T in UNIT:
            u = UNIT[T]; add += u[1]; note = u[2] + " (%d B)" % u[1]
        done_t.add(T)
    c = crow.get(T, {})
    rows.append((i, origin, r["target"], src, kind, cl, verdict, r["cover_head"], c.get("ida_bytes", ""),
                 c.get("ida_insn", ""), td, r["resync"], ",".join(fh), ",".join(ffs), add, 0, note))
with open(os.path.join(OUT, "conflicts-resolved.tsv"), "w", encoding="utf-8", newline="\n") as h:
    h.write("row\torigin\ttarget\tsrc\tkind\tcluster\tverdict\tida_cover_head\tida_cover_bytes\tida_cover_insn\t"
            "true_decode(anchor..resync)\tresync\tida_heads_out_of_phase\tof_which_lane4_fn_starts\tbytes_added\tbytes_deducted\tnote\n")
    for x in rows:
        h.write("\t".join(str(v) for v in x) + "\n")
cnt = {}
for x in rows:
    cnt[(x[1], x[5])] = cnt.get((x[1], x[5]), 0) + 1
print("conflict rows", len(rows), cnt, "added", sum(x[14] for x in rows))
allf = set(); allff = set()
for x in rows:
    allf.update(y for y in x[12].split(",") if y); allff.update(y for y in x[13].split(",") if y)
print("fake heads", len(allf), "fake lane-4 fn starts", len(allff), sorted(allff))

# ---------------- orphans
op = rd(os.path.join(RAW, "orphan_probe.tsv"))
brute = {0xFFEF13A1: "bs10 at FFEF1399 lies inside `06 c5 01 10` (cmp 20[sp],r1 @FFEF1396)",
         0xFFF177D7: "bs08 at FFF177CF lies inside `e5 00 08 01` @FFF177CD",
         0xFFF1EB84: "bs09 at FFF1EB7B lies inside `e5 00 09 01` @FFF1EB79",
         0xFFF281C3: "bs12 at FFF281B9 lies inside `c2 12 43 04` @FFF281B8",
         0xFFF2C17D: "bgt.b at FFF2C1D5 lies inside `2e 28` @FFF2C1D4",
         0xFFF2CC9F: "bra.b at FFF2CC45 lies inside `05 2e 5a ff` @FFF2CC44"}
fam_note = {
    "FFF15E96": "screen-handler clone: mov.l #-31,r1 (`fb 16 e1`), bsr FFF15E96, then bsr FFF1EE20/FFF1EE7B",
}
with open(os.path.join(OUT, "orphans.tsv"), "w", encoding="utf-8", newline="\n") as h:
    h.write("start\tend\tlen\tfirst_bytes\tclass\treached_by\tfamily\tcallees\tram_imm\tnext_validated_fn\treference_search\n")
    tot = {}
    for r in op:
        s = H(r["start"]); e = H(r["end"])
        if r["start"] not in [g["start"] for g in gap if g["class"] == "code-unref-fn"]:
            continue
        n = int(r["len"])
        if int(r["bytes_in_FIX"]) == n:
            cls = "reached"; how = r["reached_by"]
        else:
            cls = "dead-app"; how = ""
        cal = r["callees"]
        if "FFF15E96" in cal:
            fam = fam_note["FFF15E96"]
        elif "FFEF0648" in cal:
            fam = "blit/draw wrapper (bsr FFEF0648 x4)"
        elif cal:
            fam = "UI routine calling " + cal
        else:
            fam = "no call in first linear block"
        nf = fnc.get(e)
        nfs = ("%08X %s" % (e, nf[1])) if nf else "-"
        if cls != "reached" and nf and nf[1] == "body" and H(r["decode_end"]) > e:
            fam += "; true head of lane-4 'body' fn %08X (the whole function is unreferenced)" % e
        ref = brute.get(s, "")
        ref = ("no LE32/LE24 value = start anywhere in the 4 MB image; no bsr/bra .a/.w/.b/.s at any window offset reaching it; " + (ref + "; " if ref else "") + "not a switch target") if cls != "reached" else "reached once the out-of-phase caller was re-decoded"
        tot[cls] = tot.get(cls, 0) + n
        h.write("%s\t%s\t%d\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n" % (r["start"], r["end"], n, r["first16"][:16], cls, how, fam, cal, r["ram_imm"], nfs, ref))
print("orphans", tot)

# ---------------- ledger
L = [
    ("H8 baseline (doc 46): validated 438,300 + reached gap 25,758", 464058, "", "doc 46 finding 8"),
    ("H8 'code-conflict' runs (18 runs) decoded: true code", 40, "FFEE97C5 `71 01 0a`, FFEF4947 `7c 1e`, FFF0D77A `a0 0b`, 13x `a0 84` after `71 04 60`, FFF33683 `3e 01 00 2e 1c`, FFF454E2 `ef 18`", "conflicts-resolved.tsv cluster G; reached by flow from H8-credited heads"),
    ("13 `f8 04` fragments completed as `f8 04 00` mov.l #0,[sp]", 26, "e.g. FFF2A98E `f8 04 00` after `71 03 60 | a0 0b`", "cluster A rows; IDA had `00` brk at FFF2A990 (fake)"),
    ("fragment FFEEA555 reached by true beq.s", 3, "FFEEA550 `15` -> FFEEA555 `f8 06 00`", "cluster P"),
    ("orphan FFF3627B reached", 116, "FFF366CB `39 b0 fb` bsr.w (true phase; IDA had `fb a2 09 a8 89 39` at FFF366C6)", "orphans.tsv"),
    ("orphan FFF40314 reached", 21, "FFF4030C `39 08 00` bsr.w (true phase; IDA had `fb 62 40 39 08 00` at FFF40309)", "orphans.tsv"),
    ("49 wave-2 rejects `60 40` (sub #4,sp) 2-byte slivers: unreferenced", -98, "e.g. FFF0F05B `60 40` before validated FFF0F05D `60 40 f8 05 1f`", "raw/rej2.tsv; FIX closure does not reach them"),
    ("19 other wave-2 rejects (149 B) re-reached by flow", 0, "e.g. FFEF3715 59 B, FFF1B3A9 `71 04 5c a0 84`", "stay credited as reached code, not as validated"),
    ("phase repairs: 108 out-of-phase IDA heads replaced by 187 true heads", 0, "all bytes are code in both decodes; 1 byte covered only by a fake head is re-reached", "raw/closure_cmp.txt"),
    ("FFF4B077 13 B twin wrapper (task e): unreferenced, sits inside published string-pool data", 0, "`60 40 66 04 f8 06 01 39 06 00 62 40 02`; no LE32/LE24, no relative branch; twin FFF4B06C is called by bsr.a at FFEDE86F", "dead; moves data->residue only if the pool bound is corrected to FFF4B059"),
    ("FFEDFFFD 9 B hand-decoded pair (H8 finding 5)", 0, "kept as H8 credited it; IDA cannot decode across 0xFFEE0000", "explains FIX 464,157 vs final 464,166"),
]
final = sum(x[1] for x in L)
with open(os.path.join(OUT, "ledger-delta.tsv"), "w", encoding="utf-8", newline="\n") as h:
    h.write("item\tbytes\tevidence\tsource\n")
    for x in L:
        h.write("%s\t%+d\t%s\t%s\n" % (x[0], x[1], x[2], x[3]) if x[1] != 464058 else "%s\t%d\t%s\t%s\n" % x)
    h.write("FINAL SUB window code (H8 standard)\t%d\t%d / 524288 = %.2f %%\tdelta %+d on 464,058\n" % (final, final, 100.0 * final / 524288, final - 464058))
    h.write("typed data (unchanged from H8)\t56289\t\t\n")
    h.write("unresolved residue\t%d\t3,692 B in 52 dead orphan runs + 43 B fragments + 98 B `60 40` slivers\t524288-final-56289\n" % (524288 - final - 56289))
    h.write("reachability-only cross-check (informative)\t454630\tclosure from xref-class starts, vectors, pointers only; 8,782 B of lane-4 'body' functions + 102 B xref-class + 643 B gap code are not reached\traw/reach_only.txt\n")
print("final", final, 524288 - final - 56289)
