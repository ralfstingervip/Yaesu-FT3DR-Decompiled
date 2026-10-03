r"""Lane J10 -- apply the I17 continuation-merge rule to the 156 dead / credited-unreached
SUB functions, classify each, and reproduce I10's whole-image dead scan.  Read-only on the DB.

    python ida/run_job.py --script ida\jobs\j10_merge.py \
        --db J10_SUBMERGE --copy-from ida\db\jobs\SUB_FINAL2\SUB_FINAL2.i64
    python ida/run_job.py --script ida\jobs\j10_merge.py --db J10_SUBMERGE --reopen

Universe U: SUB_FINAL2 functions.tsv rows with reach in {dead, credited-unreached} (156).
For each C in U with chunk set K(C), collect every edge from outside K(C) into a head of K(C):
  flow    head before a chunk start is code outside K(C), not a stop, ending exactly at the start
  jump    a code xref fl_JF/fl_JN into a head of K(C)
  switch  an H8 switch edge or an IDA switch-table xref into a head of K(C)
  call    fl_CF/fl_CN  -> record (does not refuse a dead-chain merge, but names a live root)
  dref    data xref    -> refuse (pointer)
  vector  INTB/EXTB slot == a head of K(C) -> refuse
  ptr     o_imm anywhere == entry, or a non-code LE32/LE24 store of entry -> refuse
Root resolution (fixpoint over U): the owner of an edge source is get_func(src).start_ea.
A root is (a) a function NOT in U  -> the chain is LIVE, so C is reached-by that root;
         (b) a U-function with no external edge -> chain head, candidate genuinely dead;
         (c) a refused C.
Disposition per C:
  reached-by <root>   resolved root is a live (non-U) function reached by call/flow/jump/switch
  merge-into <root>   resolved root is a dead U chain head (owner stays dead)
  dead                no external edge into C at all (a chain head), confirmed by the image scan
I10 scan: for every U entry, its 3-byte LE prefix at every image offset (LE32 ptr + RX imm24),
its LE32 value, and membership in all 288 INTB+EXTB vector slots.
Peripheral scan: every operand (o_imm / o_displ op.value / o_mem) of every instruction in every
U function tested against USB0 0xA0000-0xA0400, USBA 0xD0000-0xD0200, FCU/flash 0x7E0000-0x800000,
the SCI0 IPC block 0x12D00-0x12E00, and the whole peripheral window 0x80000-0x100000.
Outputs ida\out\sub-merge\: disposition.tsv, dead-scan.tsv, peripheral.tsv, chains.tsv, raw\status.txt
"""
from __future__ import annotations
import sys
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root
import os, struct, traceback

ROOT = str(_REPO)
OUT = os.path.join(ROOT, r"ida\out\sub-merge")
RAW = os.path.join(OUT, "raw")
STATUS = os.path.join(RAW, "status.txt")
BIN = os.path.join(ROOT, r"decrypted\FT3D_SUB_ver102_ALL.bin")
FUNCS = os.path.join(ROOT, r"ida\out\sub-final2\functions.tsv")
BASE = 0xFFC00000
INTB = 0xFFED8A70
ATLAS = (0xFFC3EB80, 0xFFEB74D8)
CF_STOP = 0x1

PERIPH = {
    "USB0": (0xA0000, 0xA0400),
    "USBA": (0xD0000, 0xD0200),
    "FCU_flash": (0x7E0000, 0x800000),
    "SCI0_IPC": (0x12D00, 0x12E00),
    "periph_window": (0x80000, 0x100000),
}


def log(t):
    with open(STATUS, "a", encoding="utf-8", newline="\n") as h:
        h.write(t + "\n")


def rd(path):
    with open(path, encoding="utf-8") as h:
        lines = h.read().splitlines()
    hd = lines[0].split("\t")
    return [dict(zip(hd, l.split("\t"))) for l in lines[1:]]


def main():
    import ida_auto, ida_bytes, ida_ua, ida_funcs, idautils, idc
    ida_auto.auto_wait()
    img = sys.exit("The firmware image is not in this repository.")

    def le32(ea):
        return struct.unpack_from("<I", img, ea - BASE)[0]

    def u8(ea):
        return img[ea - BASE]

    rows = rd(FUNCS)
    rowmap = {int(r["start"], 16): r for r in rows}
    allstarts = set(rowmap)
    U = [int(r["start"], 16) for r in rows if r["reach"] in ("dead", "credited-unreached")]
    Uset = set(U)
    log("universe U (dead + credited-unreached) = %d" % len(U))

    # all 288 vectors
    vec = {}
    for i in range(256):
        vec.setdefault(le32(INTB + 4 * i), []).append("INTB[%d]" % i)
    for i in range(32):
        vec.setdefault(le32(0xFFFFFF80 + 4 * i), []).append("EXTB[%d]" % i)

    # switch edges and tables (same sources as I17)
    sw = {}
    with open(os.path.join(ROOT, r"ida\out\sub-gap\raw\switch_edges.tsv"), encoding="utf-8") as h:
        for ln in h:
            a_, t_, e_ = ln.split()
            sw.setdefault(int(t_, 16), set()).add(int(a_, 16))
    swtab = []
    for r in rd(os.path.join(ROOT, r"ida\out\sub-gap\raw\switches.tsv")):
        if int(r["entries"]):
            t0 = int(r["table"], 16)
            swtab.append((t0, t0 + int(r["entries"]) * int(r["entry_size"]), int(r["bra_site"], 16)))

    def swsite(frm):
        for a, b, site in swtab:
            if a <= frm < b:
                return site
        return None

    def is_stop(ea):
        insn = ida_ua.insn_t()
        return ida_ua.decode_insn(insn, ea) > 0 and bool(insn.get_canon_feature() & CF_STOP)

    # o_imm operands anywhere in the DB equal to a U entry
    imm_hits = {}
    for seg_ea in idautils.Segments():
        for hd in idautils.Heads(seg_ea, idc.get_segm_end(seg_ea)):
            if not ida_bytes.is_code(ida_bytes.get_flags(hd)):
                continue
            insn = ida_ua.insn_t()
            if ida_ua.decode_insn(insn, hd) <= 0:
                continue
            for op in insn.ops:
                if op.type == 0:
                    break
                if op.type == ida_ua.o_imm and (op.value & 0xFFFFFFFF) in Uset:
                    imm_hits.setdefault(op.value & 0xFFFFFFFF, []).append(hd)

    # I10-style raw 3-byte LE prefix scan + LE32 value + vector membership
    dead_scan = {}
    raw_ptr = {}
    for s in U:
        pat = struct.pack("<I", s)[:3]
        hits = []
        o = img.find(pat)
        while o >= 0:
            ea = BASE + o
            hd = ida_bytes.get_item_head(ea)
            fl = ida_bytes.get_flags(hd)
            if ATLAS[0] <= ea < ATLAS[1]:
                k = "atlas-pixels"
            elif ida_bytes.is_code(fl):
                insn = ida_ua.insn_t(); ida_ua.decode_insn(insn, hd)
                k = "code-imm" if any(op.type == ida_ua.o_imm and (op.value & 0xFFFFFFFF) == s for op in insn.ops if op.type) else "inside-code-bytes"
            elif img[o + 3] != 0xFF:
                k = "data-3byte-only"
            else:
                k = "data-%s" % ("aligned" if ea % 4 == 0 else "unaligned")
            hits.append((ea, k))
            o = img.find(pat, o + 1)
        ptrlike = [(ea, k) for ea, k in hits if k in ("code-imm", "data-aligned", "data-unaligned")]
        raw_ptr[s] = ptrlike
        dead_scan[s] = dict(hits=hits, ptrlike=ptrlike, vec=vec.get(s, []))

    # per-function edges
    info = {}
    for s in U:
        f = ida_funcs.get_func(s)
        if not f or f.start_ea != s:
            info[s] = dict(err="not a function start in this DB"); continue
        chunks = sorted(tuple(c) for c in idautils.Chunks(s))
        inK = lambda ea: any(a <= ea < b for a, b in chunks)
        heads = []
        for a, b in chunks:
            heads.extend(idautils.Heads(a, b))
        edges = []; refuse = []; calls = []
        for a, b in chunks:
            p = ida_bytes.prev_head(a, 0)
            if p != idc.BADADDR and not inK(p) and ida_bytes.is_code(ida_bytes.get_flags(p)) and p + ida_bytes.get_item_size(p) == a:
                if not is_stop(p):
                    edges.append(("flow", p, a))
        for x in heads:
            for xr in idautils.XrefsTo(x, 0):
                if xr.type == 21 or inK(xr.frm):
                    continue
                if xr.iscode and xr.type in (18, 19):
                    edges.append(("jump", xr.frm, x))
                elif xr.iscode and xr.type in (16, 17):
                    calls.append(("call", xr.frm, x))
                elif xr.iscode:
                    calls.append(("cref%d" % xr.type, xr.frm, x))
                elif swsite(xr.frm) is not None:
                    if not inK(swsite(xr.frm)):
                        edges.append(("switch", swsite(xr.frm), x))
                else:
                    refuse.append("dref:%08X->%08X" % (xr.frm, x))
            for site in sw.get(x, ()):
                if not inK(site):
                    edges.append(("switch", site, x))
            if x in vec:
                refuse.append("vector:%08X(%s)" % (x, ";".join(vec[x])))
        if "ptr-root" in rowmap[s]["entry_refs"]:
            refuse.append("i2-ptr-root")
        for hd in imm_hits.get(s, []):
            refuse.append("imm:%08X" % hd)
        for ea, k in raw_ptr.get(s, []):
            if k != "code-imm":
                refuse.append("le32-%s:%08X" % (k, ea))
        # the edge/call source owners (current DB functions)
        srcf = set()
        for k, frm, to in edges:
            g = ida_funcs.get_func(frm)
            srcf.add(g.start_ea if g else None)
        callf = set()
        for k, frm, to in calls:
            g = ida_funcs.get_func(frm)
            callf.add(g.start_ea if g else None)
        entry_ft = any(k == "flow" and to == s for k, frm, to in edges)
        info[s] = dict(chunks=chunks, edges=edges, calls=calls, refuse=refuse, srcf=srcf,
                       callf=callf, entry_ft=entry_ft, end=f.end_ea)

    # resolve roots within U: a root is a non-U function, a refused C, or a U-function with no
    # external edge source.  Calls also tie a chain to a root (if a dead function is called by a
    # live function, it is reached).  We fold call-owners into the source set for root resolution,
    # but keep a separate record so we can report the edge kind.
    def allsrc(s):
        return info[s]["srcf"] | info[s]["callf"]

    roots = set()
    for c in U:
        d = info[c]
        if "err" in d or d["refuse"] or not allsrc(c) or None in allsrc(c):
            roots.add(c)
    # a source owner that is NOT in U is automatically a root (live)
    while True:
        rs = {c: set() for c in U if c not in roots}
        changed = True
        while changed:
            changed = False
            for c in rs:
                new = set()
                for g in allsrc(c):
                    if g in rs:
                        new |= rs[g]
                    else:
                        new.add(g)   # g is a root (non-U function or a U root)
                if new != rs[c]:
                    rs[c] = new; changed = True
        multi = [c for c in rs if len(rs[c]) != 1]
        if not multi:
            break
        roots.update(multi)
    rootset = rs

    def resolve_root(fs):
        return fs if fs not in rootset else (next(iter(rootset[fs])) if len(rootset[fs]) == 1 else None)

    # disposition
    os.makedirs(RAW, exist_ok=True)
    counts = dict(reached=0, merge=0, dead=0, ambiguous=0, refused=0, err=0)
    with open(os.path.join(OUT, "disposition.tsv"), "w", encoding="utf-8", newline="\n") as h:
        h.write("start\tend\tsize\treach_prev\tdisposition\troot\troot_reach\tedge_kinds\tentry_fallthrough\tedges\tcalls\trefuse\n")
        for s in sorted(U):
            d = info[s]
            r = rowmap[s]
            size = int(r["end"], 16) - s
            if "err" in d:
                h.write("%08X\t\t%d\t%s\tERR\t\t\t\t\t\t\t%s\n" % (s, size, r["reach"], d["err"]))
                counts["err"] += 1; continue
            kinds = "+".join(sorted(set(e[0] for e in d["edges"]))) or "-"
            ed = ";".join("%s:%08X->%08X" % e for e in d["edges"]) or ""
            cl = ";".join("%s:%08X->%08X" % c for c in d["calls"]) or ""
            rf = ",".join(d["refuse"]) or ""
            src = allsrc(s)
            if not src or None in src:
                # chain head -> genuinely dead candidate
                disp = "dead"; root = ""; rreach = ""
                counts["dead"] += 1
            else:
                root = resolve_root(s)
                if root is None:
                    disp = "ambiguous"; rreach = "multi"; root = ""
                    counts["ambiguous"] += 1
                else:
                    rreach = rowmap[root]["reach"] if root in rowmap else "reachable(non-U)"
                    if root in Uset:
                        disp = "merge-into"       # dead chain owner (stays dead)
                        counts["merge"] += 1
                    else:
                        disp = "reached-by"       # live root -> chain is actually reachable
                        counts["reached"] += 1
            root_s = ("%08X" % root) if root else ""
            h.write("%08X\t%08X\t%d\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n" % (
                s, d["end"], size, r["reach"], disp, root_s, rreach, kinds,
                "yes" if d["entry_ft"] else "no", ed, cl, rf))
    log("disposition: " + ", ".join("%s=%d" % kv for kv in counts.items()))

    # dead-scan.tsv (I10 reproduction)
    with open(os.path.join(OUT, "dead-scan.tsv"), "w", encoding="utf-8", newline="\n") as h:
        h.write("start\treach_prev\tle_prefix_hits\tpointer_like_hits\tvector_member\tpointer_like_detail\n")
        for s in sorted(U):
            ds = dead_scan[s]
            det = ";".join("%08X:%s" % (ea, k) for ea, k in ds["ptrlike"]) or ""
            h.write("%08X\t%s\t%d\t%d\t%s\t%s\n" % (
                s, rowmap[s]["reach"], len(ds["hits"]), len(ds["ptrlike"]),
                ";".join(ds["vec"]) or "none", det))

    # chains.tsv: group by resolved root
    bychain = {}
    for s in U:
        d = info[s]
        if "err" in d:
            continue
        src = allsrc(s)
        if not src or None in src:
            r = s  # own head
        else:
            r = resolve_root(s)
        bychain.setdefault(r, []).append(s)
    with open(os.path.join(OUT, "chains.tsv"), "w", encoding="utf-8", newline="\n") as h:
        h.write("root\troot_reach\tmembers_in_U\tmember_starts\n")
        for r in sorted(k for k in bychain if k is not None):
            rr = rowmap[r]["reach"] if r in rowmap else "reachable(non-U)"
            mem = sorted(bychain[r])
            h.write("%08X\t%s\t%d\t%s\n" % (r, rr, len(mem), ",".join("%08X" % m for m in mem)))

    # peripheral.tsv: scan every U function body
    def opvals(hd, insn):
        vals = []
        for op in insn.ops:
            if op.type == 0:
                break
            if op.type == ida_ua.o_imm:
                vals.append(("imm", op.value & 0xFFFFFFFF))
            elif op.type == ida_ua.o_displ:
                vals.append(("displ", op.value & 0xFFFFFFFF))
            elif op.type == ida_ua.o_mem:
                vals.append(("mem", op.addr & 0xFFFFFFFF))
            elif op.type == ida_ua.o_near or op.type == ida_ua.o_far:
                vals.append(("addr", op.addr & 0xFFFFFFFF))
        return vals

    periph_hits = []
    for s in U:
        d = info[s]
        if "err" in d:
            continue
        for a, b in d["chunks"]:
            for hd in idautils.Heads(a, b):
                if not ida_bytes.is_code(ida_bytes.get_flags(hd)):
                    continue
                insn = ida_ua.insn_t()
                if ida_ua.decode_insn(insn, hd) <= 0:
                    continue
                for kind, v in opvals(hd, insn):
                    # test the raw peripheral offset (value in 0..0xFFFFFF range)
                    for pname, (lo, hi) in PERIPH.items():
                        if lo <= v < hi:
                            periph_hits.append((s, hd, kind, v, pname))
    with open(os.path.join(OUT, "peripheral.tsv"), "w", encoding="utf-8", newline="\n") as h:
        h.write("func\tsite\top_kind\tvalue\tregion\n")
        for s, hd, kind, v, pname in periph_hits:
            h.write("%08X\t%08X\t%s\t%08X\t%s\n" % (s, hd, kind, v, pname))
    log("peripheral hits in U functions: %d" % len(periph_hits))
    for pname in PERIPH:
        n = sum(1 for x in periph_hits if x[4] == pname)
        log("  %s: %d" % (pname, n))

    # summary totals
    dead_starts = [s for s in U if (not allsrc(s) or None in allsrc(s)) and "err" not in info[s]]
    merge_starts = [s for s in U if "err" not in info[s] and allsrc(s) and None not in allsrc(s)
                    and resolve_root(s) is not None and resolve_root(s) in Uset]
    reached_starts = [s for s in U if "err" not in info[s] and allsrc(s) and None not in allsrc(s)
                      and resolve_root(s) is not None and resolve_root(s) not in Uset]
    # byte totals by previous reach class
    def bsum(starts):
        return sum(int(rowmap[s]["end"], 16) - s for s in starts)
    log("dead heads: %d funcs, %d B (of which prev-dead %d B, prev-cu %d B)" % (
        len(dead_starts), bsum(dead_starts),
        bsum([s for s in dead_starts if rowmap[s]["reach"] == "dead"]),
        bsum([s for s in dead_starts if rowmap[s]["reach"] == "credited-unreached"])))
    log("merge-into dead owner: %d funcs, %d B" % (len(merge_starts), bsum(merge_starts)))
    log("reached-by live root: %d funcs, %d B (prev-dead %d B, prev-cu %d B)" % (
        len(reached_starts), bsum(reached_starts),
        bsum([s for s in reached_starts if rowmap[s]["reach"] == "dead"]),
        bsum([s for s in reached_starts if rowmap[s]["reach"] == "credited-unreached"])))
    # net code change = bytes of prev-dead functions that are now reached-by live root
    net = bsum([s for s in reached_starts if rowmap[s]["reach"] == "dead"])
    log("NET code-count change to 464263 headline (prev-dead now reached): +%d B" % net)
    log("done")


try:
    os.makedirs(RAW, exist_ok=True)
    open(STATUS, "w").close()
    main()
except Exception:
    with open(STATUS, "a", encoding="utf-8", newline="\n") as h:
        h.write(traceback.format_exc())
finally:
    import idc
    idc.qexit(0)
