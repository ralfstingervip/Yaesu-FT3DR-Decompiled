r"""Lane I17 -- frozen merge plan for the lane-4 split continuations (read-only on the DB).
Run once on the unmerged copy of SUB_FINAL (SUB_FINAL2 right after --copy-from):

    python ida/run_job.py --script ida\jobs\i17_plan.py --db SUB_FINAL2 --reopen

Universe: I2's 1,666 reachable functions whose entry has no call/pointer/vector reference
(ida\out\sub-final\functions.tsv: reach == reachable and entry_refs empty or jump-only).
For each candidate C with chunk set K(C), every edge from outside K(C) into a head of K(C) is
collected from the DB:
  flow    the head before a chunk start is code outside K(C) and is not a stop (no rts/rtsd/bra/jmp)
  jump    a code xref of type fl_JF/fl_JN into any head of K(C)
  switch  an H8 switch edge (ida\out\sub-gap\raw\switch_edges.tsv) into any head of K(C)
  call    a code xref of type fl_CF/fl_CN into any head of K(C)           -> refuse
  dref    a data xref into any head of K(C)                                 -> refuse
  vector  an INTB/EXTB slot equal to a head of K(C)                         -> refuse
  ptr     I2 ptr-root flag, an o_imm operand anywhere in the DB equal to the entry, or the entry's
          LE32 value stored at a byte offset of the image that is not inside a code head and not
          inside the RGB565 atlas FFC3EB80..FFEB74D8                         -> refuse
          (the scan is for the 3-byte LE prefix, which also covers RX imm24 forms; 3-byte-only
          hits outside code are listed in raw\ptr-scan.tsv but are not pointers)
A candidate with no fall-through or switch entry, entered only by unconditional branches, whose
entry instruction is a pushm frame prologue (6E xx), is a tail-call target and stays a function.
The owner of each edge is the function containing its source head.  Roots are resolved through
candidates (a candidate whose sources resolve to one root merges into that root).  A candidate
with sources in more than one root, or with no external source, is listed as ambiguous.
Outputs ida\out\sub-final2\: merge-plan.tsv, raw\plan_status.txt, raw\ptr-scan.tsv
"""
from __future__ import annotations
import sys
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root
import os, struct, traceback

ROOT = str(_REPO)
OUT = os.path.join(ROOT, r"ida\out\sub-final2")
RAW = os.path.join(OUT, "raw")
STATUS = os.path.join(RAW, "plan_status.txt")
BIN = os.path.join(ROOT, r"decrypted\FT3D_SUB_ver102_ALL.bin")
BASE = 0xFFC00000
INTB = 0xFFED8A70
ATLAS = (0xFFC3EB80, 0xFFEB74D8)
CF_STOP = 0x1


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

    i2 = rd(os.path.join(ROOT, r"ida\out\sub-final\functions.tsv"))
    i2map = {int(r["start"], 16): r for r in i2}
    cands = []
    for r in i2:
        er = r["entry_refs"]
        if r["reach"] == "reachable" and (er == "" or (er.startswith("jump") and "," not in er)):
            cands.append(int(r["start"], 16))
    cset = set(cands)
    log("candidates (I2 reachable, entry refs empty or jump-only) %d" % len(cands))

    vec = set(le32(INTB + 4 * i) for i in range(256)) | set(le32(0xFFFFFF80 + 4 * i) for i in range(32))
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

    # o_imm operands anywhere in the DB equal to a candidate entry
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
                if op.type == ida_ua.o_imm and (op.value & 0xFFFFFFFF) in cset:
                    imm_hits.setdefault(op.value & 0xFFFFFFFF, []).append(hd)

    # raw 3-byte LE prefix scan (LE32 pointer or RX imm24), every offset of the image
    ptr_rows = []
    raw_hits = {}
    for s in cands:
        pat = struct.pack("<I", s)[:3]
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
            ptr_rows.append((s, ea, k, img[o - 4 if o >= 4 else 0:o + 8].hex()))
            if k in ("code-imm", "data-aligned", "data-unaligned"):
                raw_hits.setdefault(s, []).append((ea, k))
            o = img.find(pat, o + 1)
    with open(os.path.join(RAW, "ptr-scan.tsv"), "w", encoding="utf-8", newline="\n") as h:
        h.write("entry\thit\tclass\tbytes_around\n")
        for row in ptr_rows:
            h.write("%08X\t%08X\t%s\t%s\n" % row)
    log("LE32 byte-scan hits %d (pointer-like %d entries) ; o_imm hits %d entries" % (len(ptr_rows), len(raw_hits), len(imm_hits)))

    info = {}
    for s in cands:
        f = ida_funcs.get_func(s)
        if not f or f.start_ea != s:
            info[s] = dict(err="not a function start in this DB"); continue
        chunks = sorted(tuple(c) for c in idautils.Chunks(s))
        inK = lambda ea: any(a <= ea < b for a, b in chunks)
        heads = []
        for a, b in chunks:
            heads.extend(idautils.Heads(a, b))
        edges = []; refuse = []
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
                    refuse.append("call:%08X->%08X" % (xr.frm, x))
                elif xr.iscode:
                    refuse.append("cref%d:%08X->%08X" % (xr.type, xr.frm, x))
                elif swsite(xr.frm) is not None:
                    if not inK(swsite(xr.frm)):
                        edges.append(("switch", swsite(xr.frm), x))   # IDA switch-table xref = a case edge
                else:
                    refuse.append("dref:%08X->%08X" % (xr.frm, x))
            for site in sw.get(x, ()):
                if not inK(site):
                    edges.append(("switch", site, x))
            if x in vec:
                refuse.append("vector:%08X" % x)
        if "ptr-root" in i2map[s]["entry_refs"]:
            refuse.append("i2-ptr-root")
        for hd in imm_hits.get(s, []):
            refuse.append("imm:%08X" % hd)
        for ea, k in raw_hits.get(s, []):
            if k != "code-imm":
                refuse.append("le32-%s:%08X" % (k, ea))
        srcf = set()
        for k, frm, to in edges:
            g = ida_funcs.get_func(frm)
            srcf.add(g.start_ea if g else None)
        # was the entry entered by fall-through from the head just before it?
        p = ida_bytes.prev_head(s, 0)
        entry_ft = any(k == "flow" and to == s for k, frm, to in edges)
        # tail-call target: no fall-through or switch entry at all, entered only by unconditional
        # branches, and the entry is a pushm frame prologue (6E xx) -> a function of its own
        uncond = all(k == "jump" and is_stop(frm) for k, frm, to in edges)
        tailcall = bool(edges) and uncond and u8(s) == 0x6E
        info[s] = dict(chunks=chunks, edges=edges, refuse=refuse, srcf=srcf, entry_ft=entry_ft, end=f.end_ea, tailcall=tailcall,
                       last_stop=is_stop(ida_bytes.prev_head(f.end_ea, s)))

    # resolve roots: fixpoint over root sets.  A root is a non-candidate function, a refused
    # candidate, or a candidate with no external source.  rootset(C) = union over its source
    # functions g of ({g} if g is a root else rootset(g)).  A candidate whose rootset has more
    # than one member is a shared tail: it becomes a root itself and the sets are recomputed.
    roots = set()
    for c in cands:
        d = info[c]
        if "err" in d or d["refuse"] or not d["srcf"] or None in d["srcf"] or d.get("tailcall"):
            roots.add(c)
    while True:
        rs = {c: set() for c in cands if c not in roots}
        changed = True
        while changed:
            changed = False
            for c in rs:
                new = set()
                for g in info[c]["srcf"]:
                    if g in rs:
                        new |= rs[g]
                    else:
                        new.add(g)
                if new != rs[c]:
                    rs[c] = new; changed = True
        multi = [c for c in rs if len(rs[c]) != 1]
        if not multi:
            break
        roots.update(multi)
    rootset = rs

    def root(fs):
        return fs if fs not in rootset else next(iter(rootset[fs]))

    nm = na = nr = 0
    with open(os.path.join(OUT, "merge-plan.tsv"), "w", encoding="utf-8", newline="\n") as h:
        h.write("old_start\told_end\tdecision\tnew_owner\tdirect_owners\tentry_fallthrough\tchunks\tedges\treason\n")
        for s in sorted(cands):
            d = info[s]
            if "err" in d:
                h.write("%08X\t\tambiguous\t\t\t\t\t\t%s\n" % (s, d["err"])); na += 1; continue
            r = root(s)
            ch = ";".join("%08X-%08X" % c for c in d["chunks"])
            ed = ";".join("%s:%08X->%08X" % e for e in d["edges"])
            own = ",".join(("%08X" % g) if g is not None else "none" for g in sorted(d["srcf"], key=lambda v: v or 0))
            if d["refuse"]:
                dec = "refused"; why = ",".join(d["refuse"]); nr += 1; r = None
            elif s in roots:
                dec = "ambiguous"
                nroots = set()
                for g in d["srcf"]:
                    nroots |= ({g} if g not in rootset else rootset[g])
                why = ("no external entry edge" if not d["srcf"] else
                       "tail-call target: pushm prologue %s, entered only by unconditional branch from %s" % (
                           img[s - BASE:s - BASE + 2].hex(), ",".join("%08X" % e[1] for e in d["edges"])) if d.get("tailcall") else
                       "shared tail: entered from %d roots %s" % (len(nroots), ",".join(("%08X" % g) if g else "none" for g in sorted(nroots, key=lambda v: v or 0))))
                na += 1; r = None
            else:
                dec = "merge"; nm += 1
                kinds = sorted(set(e[0] for e in d["edges"]))
                why = "%s continuation; no call/pointer/vector ref%s" % ("+".join(kinds), "" if d["entry_ft"] or "flow" not in kinds else "")
            h.write("%08X\t%08X\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n" % (s, d["end"], dec, ("%08X" % r) if r else "", own,
                    "yes" if d["entry_ft"] else "no", ch, ed, why))
    log("plan: merge %d ambiguous %d refused %d" % (nm, na, nr))
    # ambiguous.tsv: every candidate that stays a function, plus merges whose root I2 did not
    # class as reachable (the continuation was 'reachable' only through a lane-4 root)
    with open(os.path.join(OUT, "ambiguous.tsv"), "w", encoding="utf-8", newline="\n") as h:
        h.write("old_start\tstatus\troot\troot_I2_reach\tdirect_owners\tedges\treason\n")
        for r in rd(os.path.join(OUT, "merge-plan.tsv")):
            s = int(r["old_start"], 16)
            if r["decision"] != "merge":
                h.write("%s\tkept as function (%s)\t\t\t%s\t%s\t%s\n" % (r["old_start"], r["decision"], r["direct_owners"], r["edges"], r["reason"]))
            else:
                rr = i2map.get(int(r["new_owner"], 16), {}).get("reach", "")
                if rr != "reachable":
                    h.write("%s\tmerged, flagged\t%s\t%s\t%s\t%s\troot is %s in I2's index; the continuation was reachable only as a lane-4 '%s' root\n" % (
                        r["old_start"], r["new_owner"], rr, r["direct_owners"], r["edges"], rr, i2map[s]["lane4_class"]))
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
