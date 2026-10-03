r"""Lane 5: MAIN raw remainder -- classify every byte outside functions.tsv.

Seeded --copy-from ida\db\jobs\MAIN_FULL\MAIN_FULL.i64 into DB MAIN_RAW.

Raw = bytes in content [0x000000, 0x07B754) that are NOT inside any function
listed in ida\out\main-full\functions.tsv (the parent's authoritative denominator).
A "run" = maximal contiguous span outside functions, split where the type changes.
Types: recovered code | pointer table | parameter table | string | fill | font | other.

Outputs under ida\out\main-raw\ :
  runs.tsv                  start,end,length,type,evidence          (one row per run)
  recovered-functions.tsv   start,end,validated,xref,purpose,evidence
  runs_diag.tsv             per-'other' run shape stats for review
  l5_counts.txt             counts the score needs
  l5_log.txt                run log / traceback
"""
from __future__ import annotations
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root

import collections
import csv
import os
import traceback

import ida_auto
import ida_bytes
import ida_funcs
import ida_segment
import ida_ua
import idautils
import idc

ROOT = str(_REPO)
MF = os.path.join(ROOT, "ida", "out", "main-full")
OUT = os.path.join(ROOT, "ida", "out", "main-raw")
os.makedirs(OUT, exist_ok=True)
LOG_PATH = os.path.join(OUT, "l5_log.txt")
_LOG = []

CONTENT_END = 0x07B754      # content is 0..0x07B753 inclusive; fill_FF above
CODE_LO = 0x400             # lowest plausible code target (above vector table)
RAM_LO = 0xFE0000           # H8S on-chip RAM window
RAM_HI = 0x1000000
# Closed boundary: CDC-ACM / USB<->DSP download loader personality (26AA:0020).
# Classify byte-class only in this window; do not probe-decode or add functions.
LOADER_LO = 0x78106
LOADER_HI = 0x7B100         # first vetted data sub-region above the loader code

# doc-04 (04-main-recovery.md) vetted data tables not carried in region_map rows
DOC04_REGIONS = [
    (0x01226C, 0x0148A0, "pointer table", "doc04 s7: 32-bit BE code pointer tables"),
    (0x02702A, 0x02853E, "parameter table", "doc04 s7: 16-bit parameter/calibration table"),
    (0x046E10, 0x047110, "parameter table", "doc04 s7: rolling 0..15 index table"),
]

RET = ("rts", "rte", "rtsl")
CALL = ("jsr", "bsr")
BRANCH = ("bra", "beq", "bne", "bcs", "bcc", "bhi", "bls", "bmi", "bpl", "bvs",
          "bvc", "bge", "blt", "bgt", "ble", "bt", "bf", "jmp")


def log(t):
    _LOG.append(t)
    with open(LOG_PATH, "w", encoding="utf-8", newline="\n") as h:
        h.write("\n".join(_LOG) + "\n")


def esc(t):
    return (t or "").replace("\t", " ").replace("\n", " ").replace("\r", " ")


def load_tsv(name):
    rows = []
    with open(os.path.join(MF, name), encoding="utf-8") as h:
        r = csv.reader(h, delimiter="\t")
        hdr = next(r)
        for x in r:
            if x and not x[0].startswith("#"):
                rows.append(x)
    return rows


# ---- map a region_map named-subregion note to one of our types ----
def note_to_type(note):
    n = note.lower()
    if "vector table" in n:
        return "pointer table"
    if "code pointer" in n or "pointer table" in n or "descriptor-pointer" in n:
        return "pointer table"
    if ("name" in n or "text" in n or "boilerplate" in n or "status text" in n
            or "device-id" in n):
        return "string"
    if "fill" in n:
        return "fill"
    # byte table, JIS index, 16-bit parameter/calibration, index table,
    # endpoint table, descriptor(s), .data/initialised-data image, BRR table
    return "parameter table"


def main():
    ida_auto.auto_wait()
    seg = ida_segment.get_first_seg()
    base = seg.start_ea
    log("base=%08X content_end=%08X" % (base, CONTENT_END))

    # ---- function intervals from functions.tsv (authoritative raw boundary) ----
    funcs = []
    for x in load_tsv("functions.tsv"):
        s = int(x[0], 16); e = int(x[1], 16)
        funcs.append((s, e))
    funcs.sort()
    func_starts = set(s for s, _ in funcs)
    log("functions.tsv rows=%d starts=%d" % (len(funcs), len(func_starts)))

    # raw complement inside content
    raw_segs = []
    cur = base
    for s, e in funcs:
        if s > cur:
            raw_segs.append((cur, min(s, CONTENT_END)))
        cur = max(cur, e)
        if cur >= CONTENT_END:
            break
    if cur < CONTENT_END:
        raw_segs.append((cur, CONTENT_END))
    raw_segs = [(s, e) for s, e in raw_segs if e > s and s < CONTENT_END]
    raw_total = sum(e - s for s, e in raw_segs)
    log("raw segments=%d bytes=%d" % (len(raw_segs), raw_total))

    # ---- paint named sub-regions (small wins over large -> nesting handled) ----
    lab = bytearray(CONTENT_END)          # 0 = unlabeled
    labtype = {}                          # code -> type string
    tcodes = {}
    def tcode(t):
        if t not in tcodes:
            tcodes[t] = len(tcodes) + 1
            labtype[tcodes[t]] = t
        return tcodes[t]
    named = []
    for x in load_tsv("region_map.tsv"):
        # only the named sub-region rows carry a note in col 5 (index 4)
        if len(x) < 5 or not x[4].strip():
            continue
        s = int(x[0], 16); e = int(x[1], 16); note = x[4]
        if s >= CONTENT_END:
            continue
        named.append((s, min(e, CONTENT_END), note_to_type(note), note))
    for s, e, t, note in DOC04_REGIONS:
        named.append((s, min(e, CONTENT_END), t, note))
    # jump/switch tables (verified 4-byte BE dword pointer arrays)
    for x in load_tsv("jumptables.tsv"):
        ea = int(x[0], 16); n = int(x[1])
        if ea < CONTENT_END and n >= 1:
            named.append((ea, min(ea + n * 4, CONTENT_END), "pointer table",
                          "jump table, %d entries" % n))
    for x in load_tsv("switch_tables.tsv"):
        ea = int(x[0], 16); n = int(x[1])
        if ea < CONTENT_END and n >= 1:
            named.append((ea, min(ea + n * 4, CONTENT_END), "pointer table",
                          "switch table, %d entries" % n))
    # paint large first so smaller inner regions override
    for s, e, t, note in sorted(named, key=lambda r: -(r[1] - r[0])):
        code = tcode(t)
        for a in range(s, e):
            lab[a] = code
    log("named subregions painted=%d" % len(named))
    note_at = {}
    for s, e, t, note in named:
        note_at[(s, e)] = note

    # ---- byte-content helpers ----
    insn_probe = ida_ua.insn_t()

    def ffrun(pos, limit):
        n = 0
        while pos + n < limit and ida_bytes.get_byte(pos + n) == 0xFF:
            n += 1
        return n

    def zerorun(pos, limit):
        n = 0
        while pos + n < limit and ida_bytes.get_byte(pos + n) == 0x00:
            n += 1
        return n

    def strrun(pos, limit):
        # length of printable-ascii run (space..~), tabs allowed
        n = 0
        while pos + n < limit:
            b = ida_bytes.get_byte(pos + n)
            if 0x20 <= b <= 0x7E or b in (0x09,):
                n += 1
            else:
                break
        return n

    def byterun(pos, limit):
        # length of a run of one identical byte
        b0 = ida_bytes.get_byte(pos)
        n = 0
        while pos + n < limit and ida_bytes.get_byte(pos + n) == b0:
            n += 1
        return b0, n

    def ptrrun(pos, limit):
        # consecutive aligned 4-byte BE values that look like addresses:
        # ROM/code range [0x400,content) or on-chip RAM [0xFE0000,0x1000000)
        cnt = 0; fs_hits = 0; code_hits = 0; cur = pos
        while cur + 4 <= limit:
            v = int.from_bytes(ida_bytes.get_bytes(cur, 4), "big")
            in_rom = CODE_LO <= v < CONTENT_END
            in_ram = RAM_LO <= v < RAM_HI
            if in_rom or in_ram:
                cnt += 1
                if in_rom and ida_bytes.is_code(ida_bytes.get_flags(v)):
                    code_hits += 1
                if v in func_starts:
                    fs_hits += 1
                cur += 4
            else:
                break
        return cnt, fs_hits, code_hits

    def code_probe(pos, limit):
        # read-only linear decode; accept if it is predominantly instructions
        cur = pos; n = 0; seen_ret = False; covered = 0
        while cur < limit and n < 400:
            sz = ida_ua.decode_insn(insn_probe, cur)
            if sz <= 0 or insn_probe.itype == 0:
                break
            m = (ida_ua.print_insn_mnem(cur) or "").lower().split(".")[0]
            n += 1; covered += sz; cur += sz
            if m in RET:
                seen_ret = True
                # keep going: a run may hold several routines
        L = max(1, limit - pos)
        ok = n >= 6 and (covered >= 0.65 * L or (seen_ret and covered >= 0.5 * L))
        return ok, n

    def sample_text(pos, n):
        raw = ida_bytes.get_bytes(pos, n) or b""
        return "".join(chr(c) if 0x20 <= c <= 0x7E else "." for c in raw)

    # ---- classify each raw segment into runs ----
    runs = []          # (start, end, type, evidence)
    diag = []          # (start, end, len, stats, first16hex, sample)

    def is_boundary(pos, limit):
        """True if a special (non-'other') run begins exactly at pos."""
        if pos >= CONTENT_END:
            return True
        if lab[pos]:
            return True
        if ida_bytes.is_code(ida_bytes.get_flags(pos)):
            return True
        b0, rn = byterun(pos, limit)
        if (b0 == 0xFF and rn >= 4) or (b0 in (0x00, 0x20) and rn >= 8):
            return True
        if strrun(pos, limit) >= 6:
            return True
        if pos % 2 == 0:
            cnt, fs, ch = ptrrun(pos, limit)
            if cnt >= 4 and (ch >= 1 or fs >= 1 or cnt >= 6):
                return True
        return False

    for s, e in raw_segs:
        pos = s
        while pos < e:
            # 1) named sub-region
            if lab[pos]:
                code = lab[pos]
                end = pos
                while end < e and lab[end] == code:
                    end += 1
                t = labtype[code]
                # find owning note for evidence
                note = ""
                for (ns, ne), nt in note_at.items():
                    if ns <= pos < ne:
                        note = nt
                        break
                runs.append((pos, end, t, "region_map: %s" % esc(note)))
                pos = end
                continue
            # 2) recovered code
            if ida_bytes.is_code(ida_bytes.get_flags(pos)):
                end = pos
                while end < e and not lab[end] and ida_bytes.is_code(ida_bytes.get_flags(end)):
                    end = max(end + 1, ida_bytes.get_item_end(end))
                if end > e:
                    end = e
                runs.append((pos, end, "recovered code",
                             "is_code items outside functions.tsv, %d bytes" % (end - pos)))
                pos = end
                continue
            b = ida_bytes.get_byte(pos)
            # 3) fill: padding/erase byte run (0xFF>=4, 0x00/0x20>=8)
            b0, rn = byterun(pos, e)
            if (b0 == 0xFF and rn >= 4) or (b0 in (0x00, 0x20) and rn >= 8):
                runs.append((pos, pos + rn, "fill", "0x%02X padding/erase, %d bytes" % (b0, rn)))
                pos += rn
                continue
            # 5) string
            sr = strrun(pos, e)
            if sr >= 6:
                end = pos + sr
                # absorb a single trailing NUL terminator
                if end < e and ida_bytes.get_byte(end) == 0x00:
                    end += 1
                runs.append((pos, end, "string",
                             'ASCII "%s"' % esc(sample_text(pos, min(sr, 40)))))
                pos = end
                continue
            # 6) pointer table
            if pos % 2 == 0:
                cnt, fs, ch = ptrrun(pos, e)
                if cnt >= 4 and (ch >= 1 or fs >= 1 or cnt >= 6):
                    end = pos + cnt * 4
                    runs.append((pos, end, "pointer table",
                                 "%d BE dwords in ROM/RAM range (%d code, %d func-starts)"
                                 % (cnt, ch, fs)))
                    pos = end
                    continue
            # 7) other -- greedily consume until next boundary
            start = pos
            pos += 1
            while pos < e and not is_boundary(pos, e):
                pos += 1
            blob = ida_bytes.get_bytes(start, pos - start) or b""
            npr = sum(1 for c in blob if 0x20 <= c <= 0x7E)
            nz = blob.count(0)
            nff = blob.count(0xFF)
            first16 = blob[:16].hex()
            stats = "len=%d pr=%.2f zero=%.2f ff=%.2f" % (
                len(blob), npr / max(1, len(blob)), nz / max(1, len(blob)),
                nff / max(1, len(blob)))
            runs.append((start, pos, "other", stats + " first=" + first16))
            diag.append((start, pos, len(blob), stats, first16, sample_text(start, 32)))

    # ---- stage 2: reclassify residual 'other' runs by byte shape ----
    def reclass_other(s, e):
        blob = ida_bytes.get_bytes(s, e - s) or b""
        L = len(blob)
        if L == 0:
            return "other", None
        distinct = len(set(blob))
        if distinct == 1:
            if blob[0] in (0x00, 0xFF, 0x20):
                return "fill", "0x%02X padding/erase, %d bytes" % (blob[0], L)
            return "parameter table", "constant 0x%02X value block, %d bytes" % (blob[0], L)
        in_loader = LOADER_LO <= s < LOADER_HI
        npr = sum(1 for c in blob if 0x20 <= c <= 0x7E)
        # monotonic curve / lookup table (data-specific; safe before code probe)
        if L >= 24:
            deltas = [abs(blob[i] - blob[i - 1]) for i in range(1, L)]
            if deltas and sum(1 for d in deltas if d <= 8) / len(deltas) >= 0.80 and npr / L < 0.45:
                return "parameter table", "monotonic curve/lookup table, %d bytes" % L
        if not in_loader:
            ok, n = code_probe(s, e)
            if ok:
                return "recovered code", "code-probe: %d insns decode from start" % n
        if in_loader:
            return "other", None      # boundary: byte-level only, no shape inference
        # permutation / scramble map (all-distinct short table, not code)
        if 16 <= L <= 64 and distinct >= 0.9 * L:
            return "parameter table", "high-entropy mapping table, %d/%d distinct" % (distinct, L)
        # 16-bit BE value table: even length, words predominantly small
        if L >= 16 and L % 2 == 0:
            u16 = [int.from_bytes(blob[i:i + 2], "big") for i in range(0, L - 1, 2)]
            if u16 and sum(1 for v in u16 if v < 0x8000) / len(u16) >= 0.60:
                return "parameter table", "16-bit BE value table, %d entries" % len(u16)
        # byte / index table: small alphabet, non-textual
        if L >= 16 and distinct <= 56 and npr / L < 0.60:
            return "parameter table", "byte/index table, %d distinct values, %d bytes" % (distinct, L)
        return "other", None

    for i, (s, e, t, ev) in enumerate(runs):
        if t == "other":
            nt, nev = reclass_other(s, e)
            if nt != "other":
                runs[i] = (s, e, nt, nev)
    log("stage2 reclassified other runs")

    # ---- merge adjacent same-type contiguous runs ----
    merged = []
    nsrc = []
    for r in runs:
        if merged and merged[-1][2] == r[2] and merged[-1][1] == r[0]:
            merged[-1] = (merged[-1][0], r[1], merged[-1][2], merged[-1][3])
            nsrc[-1] += 1
        else:
            merged.append(list(r))
            nsrc.append(1)
    # recompute evidence for spans built from more than one source run
    for i, (s, e, t, ev) in enumerate(merged):
        if nsrc[i] > 1:
            if t == "fill":
                blob = ida_bytes.get_bytes(s, e - s) or b""
                dom = collections.Counter(blob).most_common(1)[0][0] if blob else 0
                merged[i] = (s, e, t, "padding/erase, %d bytes (dominant 0x%02X)" % (e - s, dom))
            else:
                merged[i] = (s, e, t, "%s (+%d contiguous spans, %d B total)"
                             % (ev, nsrc[i] - 1, e - s))
    runs = merged
    log("runs after merge=%d" % len(runs))

    # ---- recovered-functions: validate/build functions inside code runs ----
    insn = ida_ua.insn_t()

    def validate_func(f):
        st = collections.Counter()
        ea = f.start_ea
        bad = 0
        first = None
        while ea < f.end_ea:
            fl = ida_bytes.get_flags(ea)
            if ida_bytes.is_code(fl) and ida_ua.decode_insn(insn, ea) > 0:
                m = (ida_ua.print_insn_mnem(ea) or "").lower().split(".")[0]
                if first is None:
                    first = m
                st["insn"] += 1
                if m in RET:
                    st["ret"] += 1
                elif m in CALL:
                    st["call"] += 1
                elif m in BRANCH:
                    st["branch"] += 1
                if not m:
                    bad += 1
            else:
                bad += 1
            ea = max(ea + 1, ida_bytes.get_item_end(ea))
        nrefs = len(list(idautils.XrefsTo(f.start_ea, 0)))
        structural = st["ret"] + st["call"] + st["branch"]
        prologue = first in ("push", "stm", "mov", "sub") if first else False
        byte_ok = (st["ret"] >= 1 and st["insn"] >= 3 and bad == 0
                   and structural > 0 and prologue)
        validated = (nrefs > 0 and structural > 0) or byte_ok
        return validated, nrefs, st, first

    recfns = []
    for rs, re, t, ev in runs:
        if t != "recovered code":
            continue
        if LOADER_LO <= rs < LOADER_HI:
            continue          # closed boundary: do not enumerate loader functions
        cur = rs
        while cur < re:
            f = ida_funcs.get_func(cur)
            if f is None:
                fl = ida_bytes.get_flags(cur)
                if ida_bytes.is_code(fl) and ida_bytes.is_head(fl):
                    ida_funcs.add_func(cur)
                    f = ida_funcs.get_func(cur)
            if f and rs <= f.start_ea < re:
                validated, nrefs, st, first = validate_func(f)
                purpose = "%s entry; %d insn ret=%d call=%d br=%d" % (
                    first or "?", st["insn"], st["ret"], st["call"], st["branch"])
                ev2 = "%s; xrefs=%d" % ("reachable" if nrefs else "sweep/byte", nrefs)
                recfns.append((f.start_ea, f.end_ea, "yes" if validated else "no",
                               nrefs, purpose, ev2))
                cur = max(f.end_ea, cur + 1)
            else:
                nh = ida_bytes.next_head(cur, re)
                cur = nh if nh != idc.BADADDR and nh > cur else cur + 1
    ida_auto.auto_wait()
    log("recovered functions=%d" % len(recfns))

    # ---- write outputs ----
    with open(os.path.join(OUT, "runs.tsv"), "w", encoding="utf-8", newline="\n") as h:
        h.write("start\tend\tlength\ttype\tevidence\n")
        for s, e, t, ev in runs:
            h.write("%06X\t%06X\t%d\t%s\t%s\n" % (s, e, e - s, t, esc(ev)))

    with open(os.path.join(OUT, "recovered-functions.tsv"), "w", encoding="utf-8", newline="\n") as h:
        h.write("start\tend\tvalidated\txref\tpurpose\tevidence\n")
        for s, e, v, nr, pp, ev in sorted(recfns):
            h.write("%06X\t%06X\t%s\t%d\t%s\t%s\n" % (s, e, v, nr, esc(pp), esc(ev)))

    with open(os.path.join(OUT, "runs_diag.tsv"), "w", encoding="utf-8", newline="\n") as h:
        h.write("start\tend\tlength\tstats\tfirst16\tsample\n")
        others = []
        for s, e, t, ev in runs:
            if t != "other":
                continue
            blob = ida_bytes.get_bytes(s, e - s) or b""
            L = max(1, len(blob))
            stt = "len=%d pr=%.2f zero=%.2f ff=%.2f distinct=%d" % (
                len(blob), sum(1 for c in blob if 0x20 <= c <= 0x7E) / L,
                blob.count(0) / L, blob.count(0xFF) / L, len(set(blob)))
            others.append((s, e, len(blob), stt, blob[:16].hex(), sample_text(s, 32)))
        for s, e, ln, stt, f16, sm in sorted(others, key=lambda r: -(r[2])):
            h.write("%06X\t%06X\t%d\t%s\t%s\t%s\n" % (s, e, ln, stt, f16, esc(sm)))

    # ---- counts ----
    by_type = collections.Counter()
    cnt_type = collections.Counter()
    for s, e, t, ev in runs:
        by_type[t] += e - s
        cnt_type[t] += 1
    typed = sum(cnt_type[t] for t in cnt_type if t not in ("other",))
    # instruction bytes in content (is_code) -- independent recount
    instr_bytes = 0
    ea = base
    while ea < CONTENT_END:
        fl = ida_bytes.get_flags(ea)
        step = max(1, ida_bytes.get_item_end(ea) - ea)
        if ida_bytes.is_code(fl):
            instr_bytes += step
        ea += step
    rec_bytes = by_type.get("recovered code", 0)
    rec_valid = sum(1 for r in recfns if r[2] == "yes")

    counts = [
        "T_run\t%d" % len(runs),
        "D_run (typed, not other)\t%d" % typed,
        "raw_total_bytes\t%d" % raw_total,
        "content_bytes\t%d" % (CONTENT_END - base),
        "instruction_bytes_content (is_code recount)\t%d" % instr_bytes,
        "doc04_instruction_bytes\t380620",
        "recovered_code_bytes\t%d" % rec_bytes,
        "recovered_functions_total\t%d" % len(recfns),
        "recovered_functions_validated\t%d" % rec_valid,
    ]
    for t in ("recovered code", "pointer table", "parameter table", "string",
              "fill", "font", "other"):
        counts.append("bytes[%s]\t%d\truns=%d" % (t, by_type.get(t, 0), cnt_type.get(t, 0)))
    with open(os.path.join(OUT, "l5_counts.txt"), "w", encoding="utf-8", newline="\n") as h:
        h.write("\n".join(counts) + "\n")
    log("COUNTS:\n" + "\n".join(counts))


try:
    main()
except Exception:
    _LOG.append("TRACEBACK\n" + traceback.format_exc())
    with open(LOG_PATH, "w", encoding="utf-8", newline="\n") as h:
        h.write("\n".join(_LOG) + "\n")
idc.qexit(0)
