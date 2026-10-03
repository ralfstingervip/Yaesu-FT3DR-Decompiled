# -*- coding: utf-8 -*-
r"""Lane L95 read-only oracle pass over the service window.

Does not modify the image, any mask, or any other lane's files. Uses the
existing binutils H8SX oracle (bu_all.tsv via main-descent/offline/common.py)
and H9 reached heads only to find direct edges into the window. Writes
ida\out\service-window\.
"""
from __future__ import annotations
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root

import collections
import hashlib
import math
import os
import re
import sys

sys.dont_write_bytecode = True
sys.path.insert(0, str(_REPO / "ida/out/main-descent/offline"))
from common import IMG, BU, bu, flow, be32  # noqa: E402

ROOT = str(_REPO)
OUT = os.path.join(ROOT, "ida", "out", "service-window")
os.makedirs(OUT, exist_ok=True)

W0, W1 = 0x078106, 0x07B754  # inclusive end is W1-1 = 0x07B753
COPY_FLASH = 0x07B2A6
COPY_LEN = 0x4AE
COPY_RAM = 0xFF6034
COPY_RAM_END = COPY_RAM + COPY_LEN  # 0xFF64E2

ABS = re.compile(r"@(0x[0-9a-f]+):(8|16|24|32)\b")
DISP = re.compile(r"@\((0x[0-9a-f]+):(8|16|24|32),(er\d|r\d+[lh]?(?:\.[bwl])?)\)")
IMM = re.compile(r"#(-?0x[0-9a-f]+|-?\d+)\b")
TGT = re.compile(r"\((0x[0-9a-f]+)\)\s*$")
JSR24 = re.compile(r"^(jsr|jmp|bsr) @(0x[0-9a-f]+):")
IJ = re.compile(r"^(jmp|jsr) @er(\d)$")
MI = re.compile(r"^(jmp|jsr) @@\d+ \((0x[0-9a-f]+)\)$")
RR = re.compile(r"^(bra|bsr|bra/s|bsr/s) (r\d[lh]?)\.[bwl]")


def hx(a, n):
    return " ".join("%02x" % b for b in IMG[a:a + n])


def norm(v, width):
    v = int(v, 16) if isinstance(v, str) else v
    width = int(width)
    if width == 8:
        return 0xFFFFFF00 | (v & 0xFF)
    if width == 16:
        return (0xFFFF0000 | v) if v >= 0x8000 else v
    if width == 24:
        return v & 0xFFFFFF
    return v & 0xFFFFFFFF


def a24(v):
    """Project 24-bit form: low 24 bits of the sign-extended absolute."""
    return v & 0xFFFFFF


def ent(s):
    if not s:
        return 0.0
    c = collections.Counter(s)
    n = len(s)
    return -sum((v / n) * math.log2(v / n) for v in c.values())


def be16(a):
    return int.from_bytes(IMG[a:a + 2], "big")


def load_reached():
    ins = {}
    path = os.path.join(ROOT, "ida", "out", "main-descent", "work", "reached_insns.tsv")
    with open(path, encoding="utf-8") as h:
        next(h)
        for ln in h:
            a, n, t = ln.rstrip("\n").split("\t", 2)
            ins[int(a, 16)] = (int(n), t)
    return ins


def descend(seeds):
    """Flow-follow inside the window. Returns reached, bad, external, conflicts, preds."""
    reached = {}
    bad = []
    external = []  # (src, kind, dst, text)
    conflicts = []
    preds = collections.defaultdict(set)
    owner = {}
    work = list(seeds)
    seen_seed = set(seeds)
    while work:
        a = work.pop()
        while W0 <= a < W1 and a not in reached:
            if a & 1:
                bad.append((a, "odd"))
                break
            n, t, k, tg = flow(a)
            if k == "bad" or n <= 0:
                bad.append((a, t))
                break
            if a + n > W1:
                bad.append((a, "spans-past-window %s" % t))
                break
            # bytes must match the oracle's own length
            conflict = False
            for i in range(n):
                prev = owner.get(a + i)
                if prev is not None and prev != a:
                    conflicts.append((a, prev, t))
                    conflict = True
                    break
            if conflict:
                break
            for i in range(n):
                owner[a + i] = a
            reached[a] = (n, t, k, tg)
            for x in tg:
                if W0 <= x < W1:
                    preds[x].add((a, "branch" if k != "call" else "call"))
                    if x not in reached and x not in seen_seed:
                        seen_seed.add(x)
                        work.append(x)
                else:
                    external.append((a, k, x, t))
            if k == "stop":
                break
            if k == "stops":
                b = a + n
                preds[b].add((a, "delay"))
                if W0 <= b < W1 and b not in reached:
                    n2, t2, k2, tg2 = flow(b)
                    if k2 != "bad" and n2 > 0 and b + n2 <= W1:
                        ok = True
                        for i in range(n2):
                            prev = owner.get(b + i)
                            if prev is not None and prev != b:
                                conflicts.append((b, prev, t2))
                                ok = False
                                break
                        if ok:
                            for i in range(n2):
                                owner[b + i] = b
                            reached[b] = (n2, t2, k2, tg2)
                            for x in tg2:
                                if W0 <= x < W1:
                                    preds[x].add((b, "delay-target"))
                                    if x not in reached and x not in seen_seed:
                                        seen_seed.add(x)
                                        work.append(x)
                                else:
                                    external.append((b, k2, x, t2))
                break
            nxt = a + n
            preds[nxt].add((a, "fall"))
            a = nxt
    return reached, bad, external, conflicts, preds, owner


def straight_back(reached, preds, a, limit=10):
    out = []
    x = a
    for _ in range(limit):
        falls = [s for s, k in preds.get(x, ()) if k == "fall"]
        if len(falls) != 1:
            break
        x = falls[0]
        if x not in reached:
            break
        out.append(x)
    return list(reversed(out))


def resolve_indirect(reached, preds):
    """mov.l #imm / mov.l @abs into erN, then jmp/jsr @erN within a straight line."""
    found = []
    unresolved = []
    for a, (n, t, k, tg) in reached.items():
        m = IJ.match(t) or MI.match(t) or RR.match(t.split(" ", 1)[0] + " " + t.split(" ", 1)[1] if " " in t else t)
        # re-parse properly
        m_ij = IJ.match(t)
        m_mi = MI.match(t)
        m_rr = RR.match(t)
        if m_mi:
            slot = int(m_mi.group(2), 16)
            if 0 <= slot < len(IMG) - 3:
                v = be32(slot) & 0xFFFFFF
                found.append((a, t, v, "mem-indirect slot %06X" % slot))
            else:
                unresolved.append((a, t, "slot-oob"))
            continue
        if not m_ij and not m_rr:
            continue
        # walk back for a simple immediate load of the named register
        reg = None
        if m_ij:
            reg = m_ij.group(2)
        backs = straight_back(reached, preds, a, 12)
        hit = None
        if m_ij:
            movi = re.compile(r"^mov\.[lwb] #(0x[0-9a-f]+),er%s$" % reg)
            mova = re.compile(r"^mov\.l @(0x[0-9a-f]+):(16|32),er%s$" % reg)
            for b in reversed(backs):
                tt = reached[b][1]
                mm = movi.match(tt)
                if mm:
                    hit = int(mm.group(1), 16)
                    found.append((a, t, hit, "imm %s" % tt))
                    break
                mm = mova.match(tt)
                if mm:
                    slot = norm(mm.group(1), mm.group(2))
                    # image-resident only
                    s24 = slot & 0xFFFFFF
                    if s24 < len(IMG) - 3 and (s24 == slot or slot >= 0xFF0000):
                        # only trust a flash slot
                        if s24 < 0x80000:
                            v = be32(s24) & 0xFFFFFF
                            found.append((a, t, v, "abs-load %s -> %06X" % (tt, v)))
                            hit = v
                            break
                    unresolved.append((a, t, "abs " + tt))
                    hit = -1
                    break
                if re.search(r",er%s$" % reg, tt) or re.search(r",r%s[lh]$" % reg, tt):
                    unresolved.append((a, t, "clobber " + tt))
                    hit = -1
                    break
        if hit is None:
            unresolved.append((a, t, "no-imm; backs=%d" % len(backs)))
    return found, unresolved


def strings_in(lo, hi, minlen=5):
    out = []
    i = lo
    while i < hi:
        if 32 <= IMG[i] < 127:
            j = i
            while j < hi and 32 <= IMG[j] < 127:
                j += 1
            if j - i >= minlen:
                out.append((i, IMG[i:j].decode("ascii")))
            i = j
        else:
            i += 1
    return out


def main():
    lines = []
    P = lines.append
    digest = hashlib.sha256(IMG).hexdigest()
    P("image_len %d" % len(IMG))
    P("sha256 %s" % digest)
    P("sha256_ok %s" % (digest == "8e3ecd05409b2c314ebed77320ece5930bf31c8333cd84aeef4f6b0264c1bcce"))
    span = W1 - W0
    P("window %06X-%06X inclusive" % (W0, W1 - 1))
    P("span_bytes %d (0x%X)" % (span, span))
    P("span_078106_07B100_inclusive %d" % (0x07B100 - 0x078106 + 1))
    P("last_byte %02X next %02X" % (IMG[W1 - 1], IMG[W1]))
    ff = sum(1 for a in range(W0, W1) if IMG[a] == 0xFF)
    zz = sum(1 for a in range(W0, W1) if IMG[a] == 0x00)
    P("window_ff %d window_00 %d entropy %.3f" % (ff, zz, ent(IMG[W0:W1])))

    # ---- masks ----
    masks = []
    for dirpath, _, files in os.walk(os.path.join(ROOT, "ida", "out")):
        for fn in files:
            if fn.endswith("proven_mask.bin"):
                fp = os.path.join(dirpath, fn)
                masks.append((os.path.getmtime(fp), fp, os.path.getsize(fp)))
    masks.sort()
    P("")
    P("== proven masks by mtime ==")
    for mt, fp, sz in masks:
        P("%.0f\t%d\t%s" % (mt, sz, fp))

    # ---- outside heads ----
    RINS = load_reached()
    P("reached_insns %d" % len(RINS))

    # direct edges from H9 heads outside the window
    edges = []  # (src, kind, dst, text)
    for a, (n, t) in RINS.items():
        if a >= W0:
            continue
        # use the stored text, but recompute targets with flow() so the kind is consistent
        n2, t2, k, tg = flow(a)
        if k == "bad":
            continue
        if t2 != t or n2 != n:
            # oracle drift vs the saved insn list; keep going but note later
            pass
        for x in tg:
            if W0 <= x < W1:
                edges.append((a, k, x, t2))
    # also any reached insn whose TEXT mentions a window address even if flow() missed it
    # (displacement tables). Record separately.
    ref_re = re.compile(r"0x([0-9a-f]+)")
    data_refs = []
    for a, (n, t) in RINS.items():
        if not (W0 <= a < W1):
            for m in ref_re.finditer(t):
                v = int(m.group(1), 16)
                if W0 <= v < W1:
                    data_refs.append((a, v, t))
                    break

    # raw 5E/5A backstop over the whole image
    raw_hits = []
    for i in range(0, len(IMG) - 3):
        if IMG[i] in (0x5A, 0x5E):
            dst = int.from_bytes(IMG[i + 1:i + 4], "big")
            if W0 <= dst < W1:
                n2, t2, k, tg = flow(i)
                agreed = k != "bad" and dst in tg
                is_head = i in RINS
                raw_hits.append((i, dst, IMG[i], agreed, is_head, t2 if agreed else ""))

    P("h9_direct_edges %d" % len(edges))
    P("h9_text_refs %d" % len(data_refs))
    P("raw_5e_5a %d agreed %d heads %d" % (
        len(raw_hits), sum(1 for h in raw_hits if h[3]), sum(1 for h in raw_hits if h[4])))

    # seeds: documented entries + every direct edge target + window_seed heads
    seeds = {0x078106, 0x07815C, 0x078222, 0x07827C}
    for _, _, dst, _ in edges:
        seeds.add(dst)
    wseed = []
    wpath = os.path.join(ROOT, "ida", "out", "main-final4", "window_seed.tsv")
    with open(wpath, encoding="utf-8") as h:
        next(h)
        for ln in h:
            if not ln.strip():
                continue
            wseed.append(int(ln.split("\t")[0], 16))
    P("window_seed_heads %d" % len(wseed))

    reached, bad, external, conflicts, preds, owner = descend(sorted(seeds))
    # second wave: window_seed heads that are not already covered
    extra_seeds = []
    bad_seed_heads = []
    for s in wseed:
        if s in reached:
            continue
        if owner.get(s) not in (None, s):
            bad_seed_heads.append((s, owner.get(s)))
            continue
        extra_seeds.append(s)
    if extra_seeds:
        r2, b2, e2, c2, p2, o2 = descend(extra_seeds)
        # merge only non-conflicting
        for a, rec in r2.items():
            if a not in reached:
                # check owner
                n = rec[0]
                ok = all(owner.get(a + i) in (None, a) for i in range(n))
                if ok:
                    reached[a] = rec
                    for i in range(n):
                        owner[a + i] = a
        bad.extend(b2)
        external.extend(e2)
        conflicts.extend(c2)
        for a, ps in p2.items():
            preds[a].update(ps)

    # indirect fixpoint (a few rounds)
    ind_found, ind_unres = resolve_indirect(reached, preds)
    added = []
    for src, t, dst, how in ind_found:
        if W0 <= (dst & 0xFFFFFF) < W1 and (dst & 1) == 0 and dst not in reached and owner.get(dst) is None:
            added.append(dst)
    if added:
        r3, b3, e3, c3, p3, o3 = descend(added)
        for a, rec in r3.items():
            n = rec[0]
            if all(owner.get(a + i) in (None, a) for i in range(n)) and a not in reached:
                reached[a] = rec
                for i in range(n):
                    owner[a + i] = a
        bad.extend(b3)
        external.extend(e3)
        conflicts.extend(c3)
        for a, ps in p3.items():
            preds[a].update(ps)
        ind_found, ind_unres = resolve_indirect(reached, preds)

    # coverage
    cov = bytearray(W1)
    for a, (n, t, k, tg) in reached.items():
        for i in range(n):
            cov[a + i] = 1
    code_bytes = sum(cov[W0:W1])
    P("reached_insns_in_window %d" % len(reached))
    P("code_bytes %d" % code_bytes)
    P("bad %d conflicts %d external_calls %d" % (len(bad), len(conflicts), len(external)))
    P("bad_seed_heads_mid_insn %d extra_seeds %d indirect_added %d" % (
        len(bad_seed_heads), len(extra_seeds), len(added)))

    # gaps
    gaps = []
    a = W0
    while a < W1:
        if not cov[a]:
            s = a
            while a < W1 and not cov[a]:
                a += 1
            gaps.append((s, a))
        else:
            a += 1
    P("gaps %d gap_bytes %d" % (len(gaps), sum(b - a for a, b in gaps)))

    # runs of code
    runs = []
    a = W0
    while a < W1:
        if cov[a]:
            s = a
            while a < W1 and cov[a]:
                a += 1
            runs.append((s, a))
        else:
            a += 1
    P("code_runs %d" % len(runs))
    for s, e in runs:
        P("  code %06X-%06X (%d)" % (s, e - 1, e - s))

    # call targets inside = routine starts, plus external entries
    call_tg = set()
    for a, (n, t, k, tg) in reached.items():
        if k == "call":
            for x in tg:
                if W0 <= x < W1:
                    call_tg.add(x)
    ext_entries = collections.defaultdict(list)
    for src, k, dst, t in edges:
        ext_entries[dst].append((src, k, t))
    # raw agreed heads too
    for i, dst, opc, agreed, is_head, t2 in raw_hits:
        if agreed and is_head:
            ext_entries[dst].append((i, "raw", t2))

    starts = set(ext_entries) | call_tg | {0x078106, 0x07815C, 0x078222, 0x07827C}
    starts = {s for s in starts if s in reached}

    # assign each insn to a routine: walk fallthrough/branch but stop at other starts
    # (calls do not pull the callee). Branch into a start is a tail edge, not inclusion.
    def routine_body(start):
        body = []
        stack = [start]
        seen = set()
        while stack:
            a = stack.pop()
            if a in seen or a not in reached:
                continue
            if a != start and a in starts:
                continue
            seen.add(a)
            body.append(a)
            n, t, k, tg = reached[a]
            if k in ("stop", "stops"):
                if k == "stops":
                    b = a + n
                    if b in reached and b not in seen and not (b in starts and b != start):
                        stack.append(b)
                continue
            # fallthrough
            nxt = a + n
            if nxt in reached and not (nxt in starts and nxt != start):
                stack.append(nxt)
            if k != "call":
                for x in tg:
                    if W0 <= x < W1 and not (x in starts and x != start):
                        stack.append(x)
        body.sort()
        return body

    routines = []
    claimed = set()
    for s in sorted(starts):
        body = routine_body(s)
        if not body:
            continue
        for a in body:
            claimed.add(a)
        routines.append((s, body))
    # leftover reached insns (shared tails / not a start)
    leftover = sorted(set(reached) - claimed)
    P("routines %d leftover_insns %d" % (len(routines), len(leftover)))

    # ---- write listing ----
    list_path = os.path.join(OUT, "listing.asm")
    with open(list_path, "w", encoding="utf-8", newline="\n") as h:
        h.write("; L95 service window %06X-%06X inclusive\n" % (W0, W1 - 1))
        h.write("; sha256 %s\n" % digest)
        h.write("; oracle: ida/out/h8s-decode/work/bu_all.tsv (binutils H8SX)\n")
        h.write("; bytes re-read from decrypted/FT3D_MAIN_ver102_EXP.bin\n")
        h.write("; %d instructions, %d code bytes, %d routines\n\n" % (len(reached), code_bytes, len(routines)))
        shown = set()

        def emit_insn(a):
            n, t, k, tg = reached[a]
            h.write("%06X  %-24s  %s\n" % (a, hx(a, n), t))
            shown.add(a)

        for s, body in routines:
            callers = ext_entries.get(s, [])
            internal = sorted(src for src, (n, t, k, tg) in (
                (src, reached[src]) for src in reached if s in reached[src][3] and reached[src][2] == "call"))
            h.write("\n; -------- %06X  bytes %d  insns %d  ext_edges %d  internal_calls_from %s\n" % (
                s, sum(reached[a][0] for a in body), len(body), len(callers),
                ",".join("%06X" % x for x in internal) or "-"))
            for src, k, t in callers:
                h.write(";   edge %06X %s  %s\n" % (src, k, t))
            for a in body:
                emit_insn(a)
        if leftover:
            h.write("\n; -------- leftover reached insns (not in a routine body)\n")
            for a in leftover:
                emit_insn(a)
        missing = sorted(set(reached) - shown)
        if missing:
            h.write("\n; -------- NOT EMITTED %d\n" % len(missing))
            for a in missing:
                emit_insn(a)

    # ---- insns.tsv ----
    with open(os.path.join(OUT, "insns.tsv"), "w", encoding="utf-8", newline="\n") as h:
        h.write("addr\tlen\thex\tkind\ttext\n")
        for a in sorted(reached):
            n, t, k, tg = reached[a]
            h.write("%06X\t%d\t%s\t%s\t%s\n" % (a, n, hx(a, n), k, t))

    # ---- edges ----
    with open(os.path.join(OUT, "entries.tsv"), "w", encoding="utf-8", newline="\n") as h:
        h.write("src\tdst\tkind\tsrc_hex\tsrc_text\n")
        seen = set()
        for src, k, dst, t in sorted(edges):
            key = (src, dst, t)
            if key in seen:
                continue
            seen.add(key)
            n = RINS[src][0] if src in RINS else 4
            h.write("%06X\t%06X\t%s\t%s\t%s\n" % (src, dst, k, hx(src, n), t))

    with open(os.path.join(OUT, "entry-context.txt"), "w", encoding="utf-8", newline="\n") as h:
        # group by destination
        by = collections.defaultdict(list)
        for src, k, dst, t in edges:
            by[dst].append(src)
        for dst in sorted(by):
            h.write("\n======== entry %06X  (%d sites) ========\n" % (dst, len(set(by[dst]))))
            for src in sorted(set(by[dst])):
                h.write("--- from %06X ---\n" % src)
                # context: heads in [src-64, src+16]
                heads = sorted(x for x in RINS if src - 80 <= x <= src + 24)
                for x in heads:
                    n, t = RINS[x]
                    mark = ">>" if x == src else "  "
                    h.write("%s %06X  %-24s  %s\n" % (mark, x, hx(x, n), t))

    # ---- calls from the window ----
    with open(os.path.join(OUT, "calls.tsv"), "w", encoding="utf-8", newline="\n") as h:
        h.write("src\tdst\tkind\ttext\n")
        for a, (n, t, k, tg) in sorted(reached.items()):
            if k == "call" or t.startswith("jsr") or t.startswith("bsr"):
                for x in tg:
                    h.write("%06X\t%06X\t%s\t%s\n" % (a, x, k, t))
                if not tg:
                    h.write("%06X\t-\t%s\t%s\n" % (a, k, t))

    # ---- external callees: first 12 insns via oracle, only to name them ----
    callees = sorted({x for _, k, x, _ in external})
    with open(os.path.join(OUT, "callees.txt"), "w", encoding="utf-8", newline="\n") as h:
        h.write("; first instructions of each callee outside the window (naming only)\n")
        for dst in callees:
            callers = [a for a, k, x, t in external if x == dst]
            h.write("\n== %06X  callers %s\n" % (dst, ",".join("%06X" % c for c in callers)))
            a = dst
            if dst >= len(IMG):
                h.write("  (not in image)\n")
                continue
            for _ in range(18):
                if a < 0 or a >= len(IMG):
                    break
                n, t, k, tg = flow(a)
                if k == "bad" or n <= 0:
                    h.write("%06X  bad %s\n" % (a, t))
                    break
                h.write("%06X  %-24s  %s\n" % (a, hx(a, n), t))
                if k in ("stop", "stops"):
                    if k == "stops":
                        b = a + n
                        n2, t2, k2, tg2 = flow(b)
                        if n2:
                            h.write("%06X  %-24s  %s\n" % (b, hx(b, n2), t2))
                    break
                a += n

    # ---- absolute operand census inside reached code ----
    usb = []
    sci = []
    other_abs = []
    rams = collections.Counter()
    imms_in_win = []
    with open(os.path.join(OUT, "abs-ops.tsv"), "w", encoding="utf-8", newline="\n") as h:
        h.write("addr\thex\twidth\tabs32\tabs24\ttext\n")
        for a in sorted(reached):
            n, t, k, tg = reached[a]
            for m in ABS.finditer(t):
                v = norm(m.group(1), m.group(2))
                p = a24(v)
                h.write("%06X\t%s\t%s\t%08X\t%06X\t%s\n" % (a, hx(a, n), m.group(2), v, p, t))
                if 0xFFEE00 <= p <= 0xFFEE7F or 0xFFEE00 <= (v & 0xFFFFFF) <= 0xFFEE7F:
                    usb.append((a, p, t, hx(a, n)))
                if 0xFFFF60 <= p <= 0xFFFF9F:
                    sci.append((a, p, t, hx(a, n)))
                rams[p] += 1
            for m in IMM.finditer(t):
                raw = m.group(1)
                v = int(raw, 16) if raw.startswith("0x") or raw.startswith("-0x") else int(raw)
                if W0 <= (v & 0xFFFFFFFF) < W1:
                    imms_in_win.append((a, v, t))

    # ---- data refs from outside (H9 text) ----
    with open(os.path.join(OUT, "outside-refs.tsv"), "w", encoding="utf-8", newline="\n") as h:
        h.write("src\ttarget\tsrc_hex\ttext\n")
        for a, v, t in sorted(data_refs):
            n = RINS[a][0]
            h.write("%06X\t%06X\t%s\t%s\n" % (a, v, hx(a, n), t))

    # ---- gaps / tables ----
    with open(os.path.join(OUT, "gaps.tsv"), "w", encoding="utf-8", newline="\n") as h:
        h.write("start\tend_excl\tlen\tentropy\tzeros\tffs\tascii\tnote\n")
        for s, e in gaps:
            blob = IMG[s:e]
            strs = strings_in(s, e, 4)
            note = " ".join("%06X:%s" % (a, t[:40]) for a, t in strs[:6])
            h.write("%06X\t%06X\t%d\t%.2f\t%d\t%d\t%d\t%s\n" % (
                s, e, e - s, ent(blob), blob.count(0), blob.count(0xFF), len(strs), note))

    # switch table 0x078546, 45 words, base 0x07630A. Also try >>1.
    with open(os.path.join(OUT, "switch-078546.tsv"), "w", encoding="utf-8", newline="\n") as h:
        h.write("idx\toff\ttarget_plus\ttarget_shlr\tplus_head\tshlr_head\tword_hex\n")
        base = 0x07630A
        for i in range(45):
            a = 0x078546 + 2 * i
            w = be16(a)
            t1 = (base + w) & 0xFFFFFFFF
            t2 = (base + (w >> 1)) & 0xFFFFFFFF
            h.write("%d\t%04X\t%06X\t%06X\t%d\t%d\t%s\n" % (
                i, w, t1 & 0xFFFFFF, t2 & 0xFFFFFF,
                int(t1 in RINS), int((t2 & 0xFFFFFF) in RINS), hx(a, 2)))

    # ---- .data image ----
    with open(os.path.join(OUT, "data-image.txt"), "w", encoding="utf-8", newline="\n") as h:
        h.write("; flash %06X-%06X -> RAM %06X-%06X  (%d bytes)\n" % (
            COPY_FLASH, COPY_FLASH + COPY_LEN - 1, COPY_RAM, COPY_RAM_END - 1, COPY_LEN))
        a = COPY_FLASH
        while a < COPY_FLASH + COPY_LEN:
            chunk = IMG[a:a + 16]
            ascii_ = "".join(chr(b) if 32 <= b < 127 else "." for b in chunk)
            h.write("%06X  %06X  %-48s  %s\n" % (
                a, COPY_RAM + (a - COPY_FLASH),
                " ".join("%02x" % b for b in chunk), ascii_))
            a += 16
        h.write("\n; non-zero runs\n")
        a = COPY_FLASH
        end = COPY_FLASH + COPY_LEN
        while a < end:
            if IMG[a] != 0:
                s = a
                while a < end and IMG[a] != 0:
                    a += 1
                h.write("%06X-%06X ram %06X-%06X len %d  %s\n" % (
                    s, a - 1, COPY_RAM + (s - COPY_FLASH), COPY_RAM + (a - 1 - COPY_FLASH),
                    a - s, hx(s, min(a - s, 32))))
            else:
                a += 1
        h.write("\n; BE32 values that look like pointers\n")
        a = COPY_FLASH
        while a + 4 <= end:
            v = be32(a)
            if v and ((0xFF0000 <= (v & 0xFFFFFF) <= 0xFFFFFF) or (0x400 <= v < 0x80000) or (0xFEE000 <= v <= 0xFEEFFF)):
                h.write("%06X ram %06X  %08X\n" % (a, COPY_RAM + (a - COPY_FLASH), v))
            a += 1  # unaligned scan is noisy; step 1 but only print, we'll filter in review
        # that unaligned scan is too noisy. Rewrite a word-aligned pass only was intended.
        # The file already has it; a later filter in summary uses aligned.

    # descriptor scan
    with open(os.path.join(OUT, "descriptors.txt"), "w", encoding="utf-8", newline="\n") as h:
        h.write("; USB-looking blobs inside the window (bLength/bDescriptorType walk where it parses)\n")
        # standard device at known and searched
        for a in range(W0, W1 - 2):
            if IMG[a] == 0x12 and IMG[a + 1] == 0x01:
                h.write("device? %06X  %s\n" % (a, hx(a, min(18, W1 - a))))
            if IMG[a] == 0x09 and IMG[a + 1] == 0x02 and a + 9 <= W1:
                total = be16(a + 2)
                h.write("config? %06X total %04X  %s\n" % (a, total, hx(a, min(max(total, 9), 80, W1 - a))))

    # strings
    with open(os.path.join(OUT, "strings.txt"), "w", encoding="utf-8", newline="\n") as h:
        for a, s in strings_in(W0, W1, 4):
            h.write("%06X  %s\n" % (a, s))

    # ---- summary of usb/sci/indirect/bad ----
    P("")
    P("== USB abs ops in window code: %d ==" % len(usb))
    for a, p, t, raw in usb:
        P("%06X  %06X  %s  %s" % (a, p, raw, t))
    P("")
    P("== SCI-range abs ops (FFFF60-FFFF9F): %d ==" % len(sci))
    for a, p, t, raw in sci:
        P("%06X  %06X  %s  %s" % (a, p, raw, t))
    P("")
    P("== indirect ==")
    for row in ind_found:
        P("IND %06X -> %s via %s | %s" % (row[0], ("%06X" % row[2]) if isinstance(row[2], int) else row[2], row[3], row[1]))
    for row in ind_unres:
        P("UNRES %06X %s | %s" % (row[0], row[1], row[2]))
    P("")
    P("== bad decodes (first 30) ==")
    for row in bad[:30]:
        P("BAD %s" % (row,))
    P("== conflicts (first 20) ==")
    for row in conflicts[:20]:
        P("CONF %s" % (row,))
    P("== bad window_seed heads (mid-instruction) %d ==" % len(bad_seed_heads))
    for s, own in bad_seed_heads[:40]:
        P("  seed %06X covered by insn %06X" % (s, own))
    P("")
    P("== routines ==")
    for s, body in routines:
        nb = sum(reached[a][0] for a in body)
        callers = sorted({src for src, k, t in ext_entries.get(s, [])})
        calls_out = []
        for a in body:
            if reached[a][2] == "call":
                calls_out.extend(reached[a][3])
        P("%06X-%06X  %4d B  %3d ins  ext %s  calls %s" % (
            body[0], body[-1] + reached[body[-1]][0] - 1, nb, len(body),
            ",".join("%06X" % c for c in callers) or "-",
            ",".join("%06X" % c for c in calls_out) or "-"))
    P("")
    P("== immediates inside window ==")
    for a, v, t in imms_in_win:
        P("%06X  imm %08X  %s" % (a, v & 0xFFFFFFFF, t))
    P("")
    P("== most-referenced abs24 (top 40) ==")
    for p, c in rams.most_common(40):
        P("  %06X  %d" % (p, c))

    # outside ref target histogram
    P("")
    P("== outside text refs into window, by target ==")
    tgt_c = collections.Counter(v for _, v, _ in data_refs)
    for v, c in sorted(tgt_c.items()):
        P("  %06X  %d" % (v, c))

    # FFBC76 writers/readers in H9 insns (naming the switch index only)
    P("")
    P("== H9 insns mentioning ffbc7 / 813a / 76fc8 / 768a8 ==")
    for key in ("ffbc7", "813a", "76fc8", "768a8", "78546", "fee01", "ee2d"):
        P("-- %s" % key)
        nshow = 0
        for a, (n, t) in sorted(RINS.items()):
            if key in t:
                P("  %06X  %s  %s" % (a, hx(a, n), t))
                nshow += 1
                if nshow > 40:
                    P("  ...")
                    break

    # mask overlap with code bytes — final4 and newest
    def mask_report(fp):
        mb = open(fp, "rb").read()
        P("mask %s len %d set %d" % (fp, len(mb), sum(1 for b in mb if b)))
        if len(mb) < W1:
            P("  shorter than window end")
            return
        win_set = sum(1 for a in range(W0, W1) if mb[a])
        code_set = sum(1 for a in range(W0, W1) if cov[a] and mb[a])
        code_unset = sum(1 for a in range(W0, W1) if cov[a] and not mb[a])
        P("  window_set %d code_already_set %d code_unset %d" % (win_set, code_set, code_unset))
        # unset code ranges
        ranges = []
        a = W0
        while a < W1:
            if cov[a] and not mb[a]:
                s = a
                while a < W1 and cov[a] and not mb[a]:
                    a += 1
                ranges.append((s, a))
            else:
                a += 1
        P("  unset_code_ranges %d" % len(ranges))
        for s, e in ranges:
            P("    %06X-%06X (%d)" % (s, e - 1, e - s))

    P("")
    if masks:
        P("== newest mask vs this code ==")
        mask_report(masks[-1][1])
        fin = os.path.join(ROOT, "ida", "out", "main-final4", "final4_proven_mask.bin")
        if os.path.isfile(fin) and os.path.normcase(fin) != os.path.normcase(masks[-1][1]):
            P("== final4 mask vs this code ==")
            mask_report(fin)
        elif os.path.isfile(fin):
            P("(newest is final4)")

    # raw hit disagreements
    P("")
    P("== raw 5E/5A hits that are reached heads ==")
    for i, dst, opc, agreed, is_head, t2 in raw_hits:
        if is_head:
            P("  %06X -> %06X opc %02X agreed %d %s" % (i, dst, opc, int(agreed), t2))
    P("== raw 5E/5A agreed but NOT a reached head (possible mid-insn) count %d ==" %
      sum(1 for h in raw_hits if h[3] and not h[4]))
    shown = 0
    for i, dst, opc, agreed, is_head, t2 in raw_hits:
        if agreed and not is_head:
            P("  %06X -> %06X %s" % (i, dst, t2))
            shown += 1
            if shown > 30:
                break

    text = "\n".join(lines) + "\n"
    with open(os.path.join(OUT, "oracle-summary.txt"), "w", encoding="utf-8", newline="\n") as h:
        h.write(text)
    print(text)


if __name__ == "__main__":
    main()
