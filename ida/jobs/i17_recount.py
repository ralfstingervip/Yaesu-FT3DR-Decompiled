r"""Lane I17 -- recount SUB_FINAL2 with lane I2's rules (this file is i2_recount.py with its outputs
redirected to ida\out\sub-final2\ and four additions: a byte-level ledger against I2's final masks,
a code-head comparison against I2's target-heads.tsv, the unexplored-byte count, and the merged-start
column of functions.tsv).  Read-only on the DB.

    python ida/run_job.py --script ida\jobs\i17_recount.py --db SUB_FINAL2 --reopen

Counting rules (same as H8 doc 46 / H10 doc 48, evaluated on this DB's items and xrefs):
  headline   = bytes of every code head lying in a lane-4 xref/body range (wave-2 rejects
               excluded), clipped to the range, UNION every head reached from those heads, the
               256 INTB + 32 EXTB vectors and H8's 141 tier-2 pointer roots by decoded flow,
               decoded branch/call targets, DB code xrefs and H8's 643 switch edges.
               Variant "+w2ptr" adds the 49 wave-2 entries that aligned LE32 table slots point at.
  reach-only = H10 section 5: roots = lane-4 xref starts, pointer roots (H10 rule), H8 T2 roots,
               vectors (variant "+w2ptr" adds the 49 entries); bytes of reached heads, within headline.
  all-well-formed = DB code bytes in the window outside the typed-data mask.
  code+typed = headline + typed (published data net of code 48,854 + H8 7,435).
Outputs ida\out\sub-final2\: counts.txt, ledger-delta.tsv, functions.tsv, switches.tsv, sanity.txt,
  raw\recount_status.txt, raw\mask_final2_*.bin
"""
from __future__ import annotations
import sys
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root
import os, struct, traceback, bisect

ROOT = str(_REPO)
OUT = os.path.join(ROOT, r"ida\out\sub-final2")
RAW = os.path.join(OUT, "raw")
I2 = os.path.join(ROOT, r"ida\out\sub-final")
GAP = os.path.join(ROOT, r"ida\out\sub-gap")
STATUS = os.path.join(RAW, "recount_status.txt")
BIN = os.path.join(ROOT, r"decrypted\FT3D_SUB_ver102_ALL.bin")
BASE = 0xFFC00000
WIN_LO, WIN_HI = 0xFFED0000, 0xFFF50000
TOP = 0xFFF509DE
HI = 0xFFF50A00
INTB = 0xFFED8A70
CF_STOP = 0x1
DATA = [(0xFFED0000, 0xFFED8E70), (0xFFF48000, 0xFFF4C000)]       # H8 published (closure filter)
PUB5 = [(0xFFED0000, 0xFFED3F6C), (0xFFED3F6C, 0xFFED5800), (0xFFED5800, 0xFFED8A70),
        (0xFFED8A70, 0xFFED8E70), (0xFFF48000, 0xFFF4C000)]


def log(t):
    with open(STATUS, "a", encoding="utf-8", newline="\n") as h:
        h.write(t + "\n")


def rd(path):
    with open(path, encoding="utf-8") as h:
        lines = h.read().splitlines()
    hd = lines[0].split("\t")
    return [dict(zip(hd, l.split("\t"))) for l in lines[1:]]


def main():
    import ida_auto, ida_bytes, ida_ua, ida_funcs, ida_nalt, ida_xref, ida_name, idautils, idc
    ida_auto.auto_wait()
    img = sys.exit("The firmware image is not in this repository.")

    def le32(ea):
        return struct.unpack_from("<I", img, ea - BASE)[0]

    def b(ea, n):
        return img[ea - BASE:ea - BASE + n]

    # ---- DB heads
    heads = {}; dbytes = set()
    ea = ida_bytes.get_item_head(WIN_LO)   # I17: a record straddles FFED0000
    while ea < HI:
        fl = ida_bytes.get_flags(ea)
        if ida_bytes.is_code(fl):
            sz = max(ida_bytes.get_item_size(ea), 1); heads[ea] = sz; ea += sz
        elif ida_bytes.is_data(fl):
            sz = max(ida_bytes.get_item_size(ea), 1); dbytes.update(range(ea, ea + sz)); ea += sz
        else:
            ea += 1
    hk = sorted(heads)
    log("DB code heads %d (window+past)" % len(heads))

    rows = []; xstarts = set(); cls = {}
    for r in rd(os.path.join(ROOT, r"ida\out\sub-window\functions.tsv")):
        s, e = int(r["start"], 16), int(r["end"], 16)
        cls[s] = r["validated"]
        if r["validated"] in ("xref", "body"):
            rows.append((s, e))
            if r["validated"] == "xref":
                xstarts.add(s)
    rej2 = set()
    for i in range(1, 6):
        for r in rd(os.path.join(ROOT, r"ida\out\wave2\sub-purpose-%d.tsv" % i)):
            if r.get("validated") == "rejected":
                rej2.add(int(r["ea"], 16))
    valid = set(); vbytes = set()
    for s, e in rows:
        if s in rej2:
            continue
        i = bisect.bisect_left(hk, s)
        while i < len(hk) and hk[i] < e:
            ea = hk[i]; valid.add(ea)
            for k in range(heads[ea]):
                if ea + k < e and WIN_LO <= ea + k < WIN_HI:
                    vbytes.add(ea + k)
            i += 1

    SW = {}; SWB = set()
    with open(os.path.join(GAP, r"raw\switch_edges.tsv"), encoding="utf-8") as h:
        for ln in h:
            a_, t_, e_ = ln.split()
            SW.setdefault(int(a_, 16), []).append(int(t_, 16))
            SWB.add(int(e_, 16)); SWB.add(int(e_, 16) + 1)
    t2 = set()
    for r in rd(os.path.join(GAP, r"raw\reach.tsv")):
        if r["tier"].startswith("T2") and r["kind"].startswith("ptr"):
            t2.add(int(r["ea"], 16))
    w2ptr = set(int(r["entry"], 16) for r in rd(os.path.join(I2, "w2-pointer-entries.tsv")))
    vec = set(le32(INTB + 4 * i) for i in range(256)) | set(le32(0xFFFFFF80 + 4 * i) for i in range(32))

    succ_cache = {}

    def succ(ea):
        if ea in succ_cache:
            return succ_cache[ea]
        insn = ida_ua.insn_t(); ln = ida_ua.decode_insn(insn, ea)
        if ln <= 0:
            succ_cache[ea] = None; return None
        out = []
        mn = insn.get_canon_mnem()
        if not (insn.get_canon_feature() & CF_STOP):
            out.append((ea + ln, "flow"))
        for op in insn.ops:
            if op.type == 0:
                break
            if op.type in (ida_ua.o_near, ida_ua.o_far):
                out.append((op.addr, "call" if mn.startswith(("bsr", "jsr")) else "jump"))
        for t in idautils.CodeRefsFrom(ea, 0):
            out.append((t, "xref"))
        for t in SW.get(ea, ()):
            out.append((t, "switch"))
        succ_cache[ea] = (out, ln)
        return succ_cache[ea]

    def closure(roots, extra_roots):
        reached = {}; work = list(roots) + list(extra_roots); bad = []
        seen = set()
        while work:
            t = work.pop()
            if t in seen or not (WIN_LO <= t < TOP):
                continue
            seen.add(t)
            r = succ(t)
            if r is None:
                bad.append(t); continue
            out, ln = r
            reached[t] = ln
            for t2_, k in out:
                if t2_ not in seen:
                    work.append(t2_)
        return reached, bad

    def bytes_of(reached, clip=None):
        s = set()
        for ea, ln in reached.items():
            for k in range(ln):
                if WIN_LO <= ea + k < WIN_HI:
                    s.add(ea + k)
        return s

    # headline
    roots = set(valid)
    extra = vec | t2
    rH, badH = closure(roots, extra)
    nonhead = [t for t in rH if t not in heads]
    setH = vbytes | bytes_of(rH)
    rHw, _ = closure(roots, extra | w2ptr)
    setHw = vbytes | bytes_of(rHw)
    log("headline: valid heads %d vbytes %d reached heads %d (not DB heads %d, invalid %d) credited %d ; +w2ptr %d"
        % (len(valid), len(vbytes), len(rH), len(nonhead), len(badH), len(setH), len(setHw)))

    # reach-only (H10 section 5 rule, evaluated on this DB)
    psites = set(); prows = []
    for r in rd(os.path.join(GAP, r"raw\ptr_sites.tsv")):
        prows.append((int(r["site"], 16), int(r["target"], 16), r["site_kind"])); psites.add(int(r["site"], 16))
    proots = set()
    for site, v, sk in prows:
        if any(lo <= site < hi for lo, hi in ((0xFFED0000, 0xFFED8E70), (0xFFF48000, 0xFFF4B059))) and sk.startswith("insn"):
            sk = "data-item"
        ok = (sk == "insn-imm") or (sk in ("data-item", "unk") and (site % 4 == 0 or (site - 4) in psites or (site + 4) in psites))
        if ok and v in valid and not any(lo <= v < hi for lo, hi in DATA):
            proots.add(v)
    r0roots = (xstarts & valid) | proots | t2 | vec
    credited_heads = set(h_ for h_ in heads if any((h_ + k) in setH for k in range(heads[h_])))

    def reach_only(rts):
        seen = set(); work = list(rts)
        while work:
            t = work.pop()
            if t in seen or not (WIN_LO <= t < TOP) or t not in credited_heads:
                continue
            seen.add(t)
            r = succ(t)
            if r is None:
                continue
            for t2_, k in r[0]:
                if t2_ not in seen:
                    work.append(t2_)
        s = set()
        for ea in seen:
            for k in range(heads[ea]):
                if WIN_LO <= ea + k < WIN_HI:
                    s.add(ea + k)
        return s, seen
    set0, seen0 = reach_only(r0roots)
    set0 &= setH
    credited_heads_w = set(h_ for h_ in heads if any((h_ + k) in setHw for k in range(heads[h_])))
    credited_heads_save = credited_heads
    credited_heads = credited_heads_w
    set0w, seen0w = reach_only(r0roots | w2ptr)
    set0w &= setHw
    credited_heads = credited_heads_save
    log("reach-only: roots xref %d ptr %d t2 %d vec %d -> %d ; +w2ptr %d" % (len(xstarts & valid), len(proots), len(t2), len(vec), len(set0), len(set0w)))

    # typed data mask: published 5 regions net of H8-validated code (pool code from FFF4B059) + H8 typed
    typed = set()
    for lo, hi in PUB5:
        typed.update(range(lo, hi))
    typed -= set(range(0xFFF4B059, 0xFFF4C000)) - set(range(0xFFF4B077, 0xFFF4B084))
    h8typed = 0
    for r in rd(os.path.join(GAP, "typed-data.tsv")):
        if r["counted_in"].startswith("gap"):
            s, e = int(r["start"], 16), int(r["end"], 16)
            if r["counted_in"] == "gap(part)":
                e = min(e, 0xFFF48000)
            typed.update(range(s, e)); h8typed += 0
    typed = set(x for x in typed if WIN_LO <= x < WIN_HI)
    codeb = set()
    for ea, sz in heads.items():
        for k in range(sz):
            if WIN_LO <= ea + k < WIN_HI:
                codeb.add(ea + k)
    allwf = codeb - typed
    code_in_typed = codeb & typed
    unk_window = set(range(WIN_LO, WIN_HI)) - codeb - dbytes
    log("typed mask %d ; DB code bytes in window %d ; code inside typed mask %d ; all-well-formed (code outside typed) %d ; unexplored bytes %d ; DB data bytes in window %d"
        % (len(typed), len(codeb), len(code_in_typed), len(allwf), len(unk_window), len(dbytes & set(range(WIN_LO, WIN_HI)))))
    log("typed bytes not data items in DB %d ; non-typed non-code bytes %d" % (len(typed - dbytes - codeb), len(set(range(WIN_LO, WIN_HI)) - typed - codeb)))

    # ---- compare with H10 FIX mask
    def rdmask(p):
        m = open(p, "rb").read()
        return set(WIN_LO + i for i, v in enumerate(m) if v)
    ledger = []
    fixm = rdmask(os.path.join(I2, r"raw\h10fix\mask_fix.bin")) | set(range(0xFFEDFFFD, 0xFFEE0006))
    r0m = rdmask(os.path.join(I2, r"raw\h10fix\mask_reach_only.bin"))
    for nm, s in (("headline", setH), ("headline_w2", setHw), ("reach", set0), ("reach_w2", set0w), ("allwf", allwf)):
        m = bytearray(WIN_HI - WIN_LO)
        for x in s:
            m[x - WIN_LO] = 1
        with open(os.path.join(RAW, "mask_final2_%s.bin" % nm), "wb") as hb:
            hb.write(bytes(m))
        # ledger against I2's final mask of the same figure
        old = rdmask(os.path.join(I2, r"raw\mask_final_%s.bin" % nm))
        ledger.append((nm, s, old))

    def runs(xs):
        out = []
        for x in sorted(xs):
            if out and out[-1][1] == x:
                out[-1][1] = x + 1
            else:
                out.append([x, x + 1])
        return out
    with open(os.path.join(OUT, "ledger-delta.tsv"), "w", encoding="utf-8", newline="\n") as h:
        h.write("compare\tsign\tstart\tend\tbytes\tfirst_bytes\n")
        for nm, new, old in [("SUB_FINAL2 %s vs I2 SUB_FINAL" % a, b_, c) for a, b_, c in ledger]:
            for sgn, xs in (("+", new - old), ("-", old - new)):
                for s, e in runs(xs):
                    h.write("%s\t%s\t%08X\t%08X\t%d\t%s\n" % (nm, sgn, s, e, e - s, b(s, min(e - s, 8)).hex()))
            h.write("%s\ttotal\t\t\t%+d\t(+%d -%d)\n" % (nm, len(new) - len(old), len(new - old), len(old - new)))
            log("ledger %s: +%d -%d" % (nm, len(new - old), len(old - new)))
    with open(os.path.join(RAW, "mask-diff-h10.tsv"), "w", encoding="utf-8", newline="\n") as h:
        h.write("compare\tsign\tstart\tend\tbytes\tfirst_bytes\n")
        for nm, new, old in (("headline vs H10 FIX(+H8 9B)", setH, fixm), ("headline+w2ptr vs headline", setHw, setH),
                              ("reach-only vs H10 reach-only", set0, r0m), ("reach-only+w2ptr vs reach-only", set0w, set0)):
            for sgn, xs in (("+", new - old), ("-", old - new)):
                for s, e in runs(xs):
                    h.write("%s\t%s\t%08X\t%08X\t%d\t%s\n" % (nm, sgn, s, e, e - s, b(s, min(e - s, 8)).hex()))
            log("%s: +%d -%d" % (nm, len(new - old), len(old - new)))

    with open(os.path.join(OUT, "counts.txt"), "w", encoding="utf-8", newline="\n") as h:
        W = WIN_HI - WIN_LO
        h.write("SUB window FFED0000-FFF50000 = %d B, recounted on DB SUB_FINAL2 with I2's rules\n" % W)
        h.write("headline (H8/H10 rule, this DB)          %7d  %.2f %%\n" % (len(setH), 100.0 * len(setH) / W))
        h.write("headline + 49 pointer-reached w2 entries %7d  %.2f %%\n" % (len(setHw), 100.0 * len(setHw) / W))
        h.write("reach-only companion (H10 rule)          %7d  %.2f %%\n" % (len(set0), 100.0 * len(set0) / W))
        h.write("reach-only + 49 w2 entries as roots      %7d  %.2f %%\n" % (len(set0w), 100.0 * len(set0w) / W))
        h.write("typed data mask                          %7d\n" % len(typed))
        h.write("all-well-formed (DB code outside typed)  %7d  %.2f %%\n" % (len(allwf), 100.0 * len(allwf) / W))
        h.write("code+typed (headline)                    %7d  %.2f %%\n" % (len(setH | typed), 100.0 * len(setH | typed) / W))
        h.write("code+typed (headline+w2)                 %7d  %.2f %%\n" % (len(setHw | typed), 100.0 * len(setHw | typed) / W))
        h.write("DB code bytes in window                  %7d ; inside typed mask %d ; unexplored %d\n" % (len(codeb), len(code_in_typed), len(unk_window)))
        h.write("headline bytes that are not DB code      %7d\n" % len(setH - codeb))
        h.write("functions in DB                          %7d\n" % len(list(idautils.Functions())))

    # ---- sanity
    sl = open(os.path.join(OUT, "sanity.txt"), "w", encoding="utf-8", newline="\n")
    # (a) phase: every decoded flow/branch target and DB code xref in FFED0000..FFF50A00 lands on a head
    def cover(t):
        i = bisect.bisect_right(hk, t) - 1
        return hk[i] if i >= 0 and hk[i] < t < hk[i] + heads[hk[i]] else None
    mid = []; nflow_unk = []
    for ea in hk:
        r = succ(ea)
        if r is None:
            mid.append((ea, "INVALID", 0, 0)); continue
        for t, k in r[0]:
            if WIN_LO <= t < HI:
                c = cover(t)
                if c is not None:
                    mid.append((ea, k, t, c))
                elif t not in heads and k in ("flow", "jump", "call", "switch"):
                    nflow_unk.append((ea, k, t))
    sl.write("(a) edges from %d code heads into the middle of an instruction: %d\n" % (len(hk), len(mid)))
    for x in mid[:50]:
        sl.write("    %08X %s -> %08X inside %08X\n" % x)
    sl.write("    edges landing on non-code bytes: %d\n" % len(nflow_unk))
    for x in nflow_unk[:50]:
        sl.write("    %08X %s -> %08X\n" % x)
    # (b) switches
    nsw = 0; swbad = []
    with open(os.path.join(OUT, "switches.tsv"), "w", encoding="utf-8", newline="\n") as h:
        h.write("bra_site\ttable\tentry_size\tcases\tsigned\tida_targets_match_H8\ttable_item\tfunction\n")
        for r in rd(os.path.join(GAP, r"raw\switches.tsv")):
            site = int(r["bra_site"], 16)
            si = ida_nalt.get_switch_info(site)
            tg = []
            if si:
                res = ida_xref.calc_switch_cases(site, si)
                if res:
                    for i in range(len(res.targets)):
                        tg.append(res.targets[i])
            ok = sorted(set(tg)) == sorted(set(SW[site]))
            tbl = int(r["table"], 16)
            fl = ida_bytes.get_flags(tbl)
            item = "%s%d" % ("word" if ida_bytes.is_word(fl) else ("byte" if ida_bytes.is_byte(fl) else "other"), ida_bytes.get_item_size(tbl)) if ida_bytes.is_data(fl) else "none"
            f = ida_funcs.get_func(site)
            if si and ok:
                nsw += 1
            else:
                swbad.append(site)
            h.write("%08X\t%08X\t%s\t%s\t%s\t%s\t%s\t%s\n" % (site, tbl, r["entry_size"], r["entries"],
                    "yes" if si and si.flags & 0x2000 else "no", "yes" if ok else "NO", item, ("%08X" % f.start_ea) if f else ""))
    sl.write("(b) switch tables with IDA switch info whose cases equal H8's edges: %d of 40 ; bad %s\n" % (nsw, ",".join("%08X" % x for x in swbad)))
    # (c) RX encoding traps
    n24 = m24 = n32 = m32 = n75 = m75 = nd = md = 0; ex = []
    for ea in hk:
        bb = b(ea, 7)
        insn = ida_ua.insn_t(); ln = ida_ua.decode_insn(insn, ea)
        if ln <= 0:
            continue
        if bb[0] == 0xFB and (bb[1] & 3) == 2:
            li = (bb[1] >> 2) & 3
            if li == 3:
                v = int.from_bytes(bb[2:5], "little"); v = (v | 0xFF000000) if v & 0x800000 else v; n24 += 1
            elif li == 0:
                v = int.from_bytes(bb[2:6], "little"); n32 += 1
            elif li == 1:
                v = bb[2]; v = (v | 0xFFFFFF00) if v & 0x80 else v
            else:
                v = int.from_bytes(bb[2:4], "little"); v = (v | 0xFFFF0000) if v & 0x8000 else v
            got = insn.ops[0].value & 0xFFFFFFFF
            if got != v:
                if li == 3: m24 += 1
                if li == 0: m32 += 1
                if len(ex) < 10: ex.append("%08X %s imm IDA %08X bytes %08X" % (ea, bb[:6].hex(), got, v))
        if bb[0] == 0x75 and (bb[1] & 0xE0) == 0x40:
            n75 += 1
            got = insn.ops[0].value & 0xFFFFFFFF
            if got != bb[2]:
                m75 += 1
                if len(ex) < 20: ex.append("%08X %s 75-form IDA %08X want %02X" % (ea, bb[:3].hex(), got, bb[2]))
        if 0xA8 <= bb[0] <= 0xAF:
            # MOV.L dsp5[Rs],Rd : dsp = b0[2:0]<<2 | b1[7]<<1 | b1[3], scaled x4
            dsp = (((bb[0] & 7) << 2) | ((bb[1] >> 7) << 1) | ((bb[1] >> 3) & 1)) * 4
            nd += 1
            op = insn.ops[0]
            if not (op.type == ida_ua.o_displ and (op.value & 0xFFFFFFFF) == dsp):
                md += 1
                if len(ex) < 30: ex.append("%08X %s displ IDA type %d value %X addr %X want %X" % (ea, bb[:2].hex(), op.type, op.value, op.addr, dsp))
    sl.write("(c) RX traps: FB 24-bit MOV.L immediates %d (IDA value != sign-extended bytes: %d); 32-bit %d (mismatch %d)\n" % (n24, m24, n32, m32))
    sl.write("    75 4x/75 5x uimm8 forms %d (IDA value != zero-extended byte: %d)\n" % (n75, m75))
    sl.write("    MOV.L dsp5[Rs],Rd (A8..AF) %d (o_displ op.value != byte-decoded displacement: %d)\n" % (nd, md))
    for x in ex:
        sl.write("    " + x + "\n")
    # (d) function-level checks
    fn_win = [s for s in idautils.Functions(WIN_LO, HI)]
    starts_not_head = [s for s in fn_win if s not in heads]
    unowned = [h_ for h_ in hk if not ida_funcs.get_func(h_)]
    sl.write("(d) functions starting in window+past %d ; starts that are not code heads %d ; code heads in no function %d\n" % (len(fn_win), len(starts_not_head), len(unowned)))
    sl.write("    unowned heads: %s\n" % ",".join("%08X" % x for x in unowned[:80]))
    tg = {}
    for r in rd(os.path.join(I2, "target-heads.tsv")):
        tg[int(r["ea"], 16)] = int(r["size"])
    extra = [h_ for h_ in heads if tg.get(h_) != heads[h_]]
    miss = [h_ for h_ in tg if heads.get(h_) != tg[h_]]
    sl.write("(e) code heads vs I2 target-heads.tsv (%d): extra %d missing %d\n" % (len(tg), len(extra), len(miss)))
    sl.write("(f) never-explored (unknown) bytes in the window: %d\n" % len(unk_window))
    tails_shared = 0
    for s_ in idautils.Functions():
        for a_, z_ in idautils.Chunks(s_):
            c_ = ida_funcs.get_fchunk(a_)
            if c_ and c_.start_ea != s_ and c_.refqty > 1:
                tails_shared += 1
    sl.write("(g) tail chunks with more than one parent: %d\n" % tails_shared)
    sl.close()

    # ---- function index (whole DB)
    callers = {}
    with open(os.path.join(OUT, "functions.tsv"), "w", encoding="utf-8", newline="\n") as h:
        merged = {}
        for r in rd(os.path.join(OUT, "alias.tsv")):
            if r["decision"] == "merged" and r["new_owner"]:
                merged.setdefault(int(r["new_owner"], 16), []).append(r["old_start"])
        h.write("start\tend\tsize\tchunks\tname\treach\tentry_refs\tlane4_class\tmerged_old_starts\n")
        for s in idautils.Functions():
            f = ida_funcs.get_func(s)
            ch = list(idautils.Chunks(s))
            size = sum(z - a for a, z in ch)
            xin = [x for x in idautils.XrefsTo(s, 0) if x.type != 21]
            kinds = []
            if s in vec:
                kinds.append("vector")
            nc = sum(1 for x in xin if x.iscode and x.type in (16, 17))
            nj = sum(1 for x in xin if x.iscode and x.type in (18, 19))
            ndr = sum(1 for x in xin if not x.iscode)
            if nc: kinds.append("call%d" % nc)
            if nj: kinds.append("jump%d" % nj)
            if ndr: kinds.append("dref%d" % ndr)
            if s in t2 or s in proots or s in w2ptr: kinds.append("ptr-root")
            if not (WIN_LO <= s < WIN_HI):
                reach = "outside-window"
            elif s in seen0w:
                reach = "reachable"
            elif any((s + k) in setHw for k in range(heads.get(s, 1))):
                reach = "credited-unreached"
            else:
                reach = "dead"
            h.write("%08X\t%08X\t%d\t%d\t%s\t%s\t%s\t%s\t%s\n" % (s, f.end_ea, size, len(ch), ida_name.get_name(s), reach,
                    ",".join(kinds), cls.get(s, "new"), ",".join(sorted(merged.get(s, [])))))
    log("done")


try:
    os.makedirs(RAW, exist_ok=True)
    main()
except Exception:
    with open(STATUS, "a", encoding="utf-8", newline="\n") as h:
        h.write(traceback.format_exc())
finally:
    import idc
    idc.qexit(0)
