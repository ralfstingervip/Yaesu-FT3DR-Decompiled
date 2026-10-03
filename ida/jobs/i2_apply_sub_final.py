r"""Lane I2 -- apply every H8 (doc 46) and H10 (doc 48) repair to a SUB database.  Idempotent:
each step tests the DB first and only changes what is missing, so re-running it on a repaired
DB changes nothing.  One run = one "pass": apply, then re-run auto-analysis over the window,
then measure what the whole pass changed.

    python ida/run_job.py --script ida\jobs\i2_apply_sub_final.py --db SUB_FINAL --reopen --env I2_PASS=1

Inputs (all frozen on disk; nothing is read from another lane's DB)
  ida\out\sub-final\target-heads.tsv    every instruction head of FFED0000..FFF50A00 (i2_plan.py)
  ida\out\sub-final\func-plan.tsv       function deletions / creations / merges (i2_plan.py)
  ida\out\sub-final\retype.tsv          published-data bytes IDA had decoded as code
  ida\out\sub-gap\typed-data.tsv        H8 .data images, pads, past-window tables
  ida\out\sub-gap\raw\switches.tsv, switch_edges.tsv   H8 40 relative switch tables
  ida\out\sub-gap\raw\ptr_sites.tsv, reach.tsv         H8 pointer sites and tier-2 roots
Steps
  1 segment boundary RES/DENSE moved from FFEE0000 to FFEDAB4C (first code byte after the
    .data images), so FFEDFFFD `fb e2 d4 cd 01 00` can be decoded (H8 finding 5)
  2 delete planned functions (bad-head starts, wave-2 rejects incl. the 49 `60 40` slivers)
  3 undefine every code head in the window that is not a target head (H10's 108 + I2's 30)
  4 create every target head
  5 typed data (.data images, DTBL/BTBL, pads, past-window JPEG tables, published-data retype)
  6 the 40 relative switch tables (switch info + case xrefs + table items)
  7 pointer xrefs (instruction immediates -> offset operands; data sites -> offsets/user drefs)
  8 functions: planned creations and merges, then attach every unowned head by flow, jump,
    call or pointer evidence
  9 auto-analysis over the window, then measure the pass
Output ida\out\sub-final\raw\apply_pass<N>.txt (+ .tsv of every change)
"""
from __future__ import annotations
import sys
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root
import os, struct, traceback

ROOT = str(_REPO)
OUT = os.path.join(ROOT, r"ida\out\sub-final")
RAW = os.path.join(OUT, "raw")
GAP = os.path.join(ROOT, r"ida\out\sub-gap")
PASS = os.environ.get("I2_PASS", "x")
STATUS = os.path.join(RAW, "apply_pass%s.txt" % PASS)
CHG = os.path.join(RAW, "apply_pass%s_changes.tsv" % PASS)
BIN = os.path.join(ROOT, r"decrypted\FT3D_SUB_ver102_ALL.bin")
BASE = 0xFFC00000
LO, HI = 0xFFED0000, 0xFFF50A00
WIN_HI = 0xFFF50000
SPLIT = 0xFFEDAB4C
INTB = 0xFFED8A70
PUBDATA = [(0xFFED0000, 0xFFED8E70), (0xFFF48000, 0xFFF4B059)]
DINIT = [(0xFFED8E70, 0xFFED8FFB, 0x1217E), (0xFFED8FFC, 0xFFED9762, 0x12570), (0xFFED9764, 0xFFEDAB4C, 0x68514)]
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
    import ida_auto, ida_bytes, ida_ua, ida_funcs, ida_segment, ida_nalt, ida_xref, ida_offset
    import ida_name, idautils, idc
    ida_auto.auto_wait()
    img = sys.exit("The firmware image is not in this repository.")
    chg = open(CHG, "w", encoding="utf-8", newline="\n")
    chg.write("step\taction\tea\tdetail\n")
    cnt = {}

    def note(step, action, ea, detail=""):
        cnt[(step, action)] = cnt.get((step, action), 0) + 1
        chg.write("%s\t%s\t%08X\t%s\n" % (step, action, ea, detail))

    def le32(ea):
        return struct.unpack_from("<I", img, ea - BASE)[0]

    def snapshot():
        heads = {}
        ea = LO
        while ea < HI:
            fl = ida_bytes.get_flags(ea)
            if ida_bytes.is_code(fl) or ida_bytes.is_data(fl):
                sz = max(ida_bytes.get_item_size(ea), 1)
                heads[ea] = (sz, "c" if ida_bytes.is_code(fl) else "d")
                ea += sz
            else:
                ea += 1
        fns = {}
        for s in idautils.Functions():
            fns[s] = tuple(idautils.Chunks(s))
        return heads, fns

    pre_heads, pre_fns = snapshot()

    tgt = {}
    for r in rd(os.path.join(OUT, "target-heads.tsv")):
        tgt[int(r["ea"], 16)] = (int(r["size"]), r["class"])
    plan = [(r["action"], int(r["ea"], 16), int(r["end"], 16), r["reason"]) for r in rd(os.path.join(OUT, "func-plan.tsv"))]

    # ---- 1. segment boundary
    res = ida_segment.getseg(SPLIT - 1); dense = ida_segment.getseg(0xFFEE0000)
    if dense.start_ea != SPLIT:
        old = (res.start_ea, res.end_ea, dense.start_ea, dense.end_ea)
        ok1 = ida_segment.set_segm_end(res.start_ea, SPLIT, ida_segment.SEGMOD_KEEP | ida_segment.SEGMOD_SILENT)
        ok2 = ida_segment.set_segm_start(0xFFEE0000, SPLIT, ida_segment.SEGMOD_KEEP | ida_segment.SEGMOD_SILENT)
        note("1", "segment", SPLIT, "RES %08X-%08X DENSE %08X-%08X -> split at %08X ok=%s/%s" % (old + (SPLIT, ok1, ok2)))
        dense = ida_segment.getseg(SPLIT)
        if dense is None or dense.start_ea != SPLIT:
            raise RuntimeError("segment move failed")

    # ---- 2. function deletions (and the delete half of each merge)
    merge_tails = {}
    for act, ea, end, why in plan:
        if act == "delete":
            f = ida_funcs.get_func(ea)
            if f and f.start_ea == ea:
                ida_funcs.del_func(ea); note("2", "del_func", ea, why)
            c = "I2: lane-4 function start sub_%08X removed: %s" % (ea, why)
            if (idc.get_cmt(ea, 0) or "") != c and ea in tgt:
                idc.set_cmt(ea, c, 0)
        elif act == "merge" and end != ea:
            f = ida_funcs.get_func(end)
            if f and f.start_ea == end and end in tgt:
                merge_tails[ea] = (f.end_ea, [c for c in idautils.Chunks(end) if c[0] != end])
                ida_funcs.del_func(end); note("2", "del_func_merge", end, "merged into %08X" % ea)
            c = "I2: lane-4 function sub_%08X merged into sub_%08X (entry)" % (end, ea)
            if (idc.get_cmt(end, 0) or "") != c and end in tgt:
                idc.set_cmt(end, c, 0)

    # ---- 3. undefine code heads that are not target heads
    ea = LO; bad = []
    while ea < HI:
        fl = ida_bytes.get_flags(ea)
        if ida_bytes.is_code(fl):
            sz = max(ida_bytes.get_item_size(ea), 1)
            if ea not in tgt or tgt[ea][0] != sz:
                bad.append((ea, sz))
            ea += sz
        elif ida_bytes.is_data(fl):
            ea += max(ida_bytes.get_item_size(ea), 1)
        else:
            ea += 1
    for ea, sz in bad:
        f = ida_funcs.get_func(ea)
        if f and f.start_ea == ea:
            ida_funcs.del_func(ea); note("3", "del_func", ea, "start head being undefined")
        ida_bytes.del_items(ea, ida_bytes.DELIT_SIMPLE, sz)
        note("3", "undefine", ea, "%d %s" % (sz, img[ea - BASE:ea - BASE + sz].hex()))

    # ---- 4. create every target head
    fail = 0
    for ea in sorted(tgt):
        sz, k = tgt[ea]
        fl = ida_bytes.get_flags(ea)
        if ida_bytes.is_code(fl) and ida_bytes.get_item_size(ea) == sz:
            continue
        hd = ida_bytes.get_item_head(ea)
        if hd != ea and hd != idc.BADADDR and (ida_bytes.is_code(ida_bytes.get_flags(hd)) or ida_bytes.is_data(ida_bytes.get_flags(hd))):
            ida_bytes.del_items(hd, ida_bytes.DELIT_SIMPLE, max(ida_bytes.get_item_size(hd), 1))
        ida_bytes.del_items(ea, ida_bytes.DELIT_SIMPLE, sz)
        n = ida_ua.create_insn(ea)
        if n != sz:
            fail += 1; note("4", "create_insn_FAIL", ea, "want %d got %d %s" % (sz, n, k))
        else:
            note("4", "create_insn", ea, "%d %s" % (sz, k))
    ida_auto.auto_wait()

    # ---- 5. typed data
    def want_data(ea, size, kind):
        """kind: byte|dword|strlit; returns True if created"""
        fl = ida_bytes.get_flags(ea)
        if ida_bytes.is_data(fl) and ida_bytes.get_item_size(ea) == size:
            if kind == "strlit" and ida_bytes.is_strlit(fl):
                return False
            if kind == "dword" and ida_bytes.is_dword(fl):
                return False
            if kind == "byte" and ida_bytes.is_byte(fl):
                return False
        for x in range(ea, ea + size):
            if ida_bytes.is_code(ida_bytes.get_flags(x)):
                raise RuntimeError("refusing to overwrite code at %08X for data %08X" % (x, ea))
        ida_bytes.del_items(ea, ida_bytes.DELIT_SIMPLE, size)
        if kind == "strlit":
            ok = ida_bytes.create_strlit(ea, size, ida_nalt.STRTYPE_C)
        elif kind == "dword":
            ok = ida_bytes.create_dword(ea, size)
        else:
            ok = ida_bytes.create_byte(ea, size)
        return ok

    def name(ea, nm):
        cur = ida_name.get_name(ea)
        if cur != nm and (not cur or cur.startswith(("unk_", "byte_", "dword_", "off_", "word_", "asc_", "loc_", "sub_"))):
            ida_name.set_name(ea, nm, ida_name.SN_NOWARN | ida_name.SN_NOCHECK)

    for r in rd(os.path.join(OUT, "retype.tsv")):
        a, z, t = int(r["start"], 16), int(r["end"], 16), r["type"]
        if t == "dword":
            for q in range(a, z, 4):
                if want_data(q, 4, "dword"):
                    note("5", "retype_dword", q, "%08X" % le32(q))
                v = le32(q)
                if 0xFFC00000 <= v and not ida_bytes.is_off0(ida_bytes.get_flags(q)):
                    ida_offset.op_plain_offset(q, 0, 0); note("5", "offset", q, "%08X" % v)
        else:
            if want_data(a, z - a, t):
                note("5", "retype_" + t, a, "%d" % (z - a))
    for i, (a, z, dst) in enumerate(DINIT):
        if want_data(a, z - a, "byte"):
            note("5", "dinit_image", a, "len %d -> RAM %X" % (z - a, dst))
        name(a, "dinit_src_%05X" % dst)
    for a, z in ((0xFFED8FFB, 0xFFED8FFC), (0xFFED9762, 0xFFED9764), (0xFFF508F5, 0xFFF508F8)):
        if want_data(a, z - a, "byte"):
            note("5", "pad", a, "%d" % (z - a))
    # _INITSCT tables: DTBL {src,end,dst} x3, BTBL {start,end} x3
    for q in range(0xFFED8A34, 0xFFED8A70, 4):
        if want_data(q, 4, "dword"):
            note("5", "initsct_dword", q, "%08X" % le32(q))
        if le32(q) >= 0xFFC00000 and not ida_bytes.is_off0(ida_bytes.get_flags(q)):
            ida_offset.op_plain_offset(q, 0, 0); note("5", "offset", q, "%08X" % le32(q))
    name(0xFFED8A34, "initsct_dtbl"); name(0xFFED8A58, "initsct_btbl")
    if want_data(0xFFF508F8, 64, "byte"):
        note("5", "jpeg_zigzag", 0xFFF508F8, "u8[64]")
    name(0xFFF508F8, "jpeg_dezigzag")
    if want_data(0xFFF50938, 28, "dword"):
        note("5", "idct_const", 0xFFF50938, "u32[7]")
    name(0xFFF50938, "idct_cos_q14")
    if want_data(0xFFF50954, 12, "byte"):
        note("5", "const_u8", 0xFFF50954, "u8[12]")

    # ---- 6. relative switch tables
    edges = {}
    with open(os.path.join(GAP, r"raw\switch_edges.tsv"), encoding="utf-8") as h:
        for ln in h:
            s_, t_, e_ = ln.split()
            edges.setdefault(int(s_, 16), []).append(int(t_, 16))
    SW_SIGNED = getattr(ida_nalt, "SWI_SIGNED", 0x2000)
    SW_ELBASE = getattr(ida_nalt, "SWI_ELBASE", 0x200)
    SW_JSIZE = getattr(ida_nalt, "SWI_JSIZE", 0x400)
    nsw = 0
    for r in rd(os.path.join(GAP, r"raw\switches.tsv")):
        site = int(r["bra_site"], 16); tbl = int(r["table"], 16); esz = int(r["entry_size"]); n = int(r["entries"])
        if not n:
            continue
        want = edges[site]
        fmt = {1: "b", 2: "h"}[esz]
        raw = [struct.unpack_from("<" + fmt, img, tbl - BASE + i * esz)[0] for i in range(n)]
        signed = [(site + d) & 0xFFFFFFFF for d in raw] == want
        if not signed:
            rawu = [struct.unpack_from("<" + fmt.upper(), img, tbl - BASE + i * esz)[0] for i in range(n)]
            if [(site + d) & 0xFFFFFFFF for d in rawu] != want:
                raise RuntimeError("switch %08X: table does not reproduce H8 edges" % site)
        old = ida_nalt.get_switch_info(site)
        def cases(sw):
            res = ida_xref.calc_switch_cases(site, sw) if sw else None
            return sorted(set(res.targets[i] for i in range(len(res.targets)))) if res else []
        if old and old.jumps == tbl and old.get_jtable_size() == n and old.elbase == site and cases(old) == sorted(set(want)):
            pass
        else:
            # element size: (J32, JSIZE) = 00 -> 2 bytes, 01 -> 1 byte (IDA's own 1-byte tables
            # here carry 0x802600 = VERSION|SIGNED|JSIZE|ELBASE)
            for x in list(idautils.XrefsFrom(site, 0)):
                if x.iscode and x.type != 21 and x.to not in want:
                    ida_xref.del_cref(site, x.to, 0); note("6", "switch_stale_cref_del", site, "%08X" % x.to)
            si = ida_nalt.switch_info_t()
            si.flags = SW_ELBASE | (SW_JSIZE if esz == 1 else 0) | (SW_SIGNED if signed else 0)
            si.ncases = n
            si.jumps = tbl
            si.elbase = site
            si.lowcase = 0
            si.defjump = idc.BADADDR
            si.startea = site
            ida_nalt.set_switch_info(site, si)
            note("6", "switch_info", site, "table %08X x%d esz %d %s" % (tbl, n, esz, "signed" if signed else "unsigned"))
            si = ida_nalt.get_switch_info(site)
            if cases(si) != sorted(set(want)):
                raise RuntimeError("switch %08X: IDA cases do not equal H8 edges after set_switch_info" % site)
            ida_xref.create_switch_table(site, si)
            note("6", "switch_xrefs", site, "%d cases" % n)
        for t in want:
            if t == site + 2:
                continue          # case = next address: IDA keeps no jump xref to it
            if t not in set(x.to for x in idautils.XrefsFrom(site, 0) if x.iscode):
                ida_xref.add_cref(site, t, ida_xref.fl_JN | ida_xref.XREF_USER)
                note("6", "switch_cref_user", site, "%08X" % t)
        fl = ida_bytes.get_flags(tbl)
        okt = ida_bytes.is_data(fl) and ida_bytes.get_item_size(tbl) == n * esz and             (ida_bytes.is_byte(fl) if esz == 1 else ida_bytes.is_word(fl))
        if not okt:
            for x in range(tbl, tbl + n * esz):
                if ida_bytes.is_code(ida_bytes.get_flags(x)):
                    raise RuntimeError("switch table %08X overlaps code at %08X" % (tbl, x))
            ida_bytes.del_items(tbl, ida_bytes.DELIT_SIMPLE, n * esz)
            if esz == 1:
                ida_bytes.create_byte(tbl, n)
            else:
                ida_bytes.create_word(tbl, n * 2)
            note("6", "switch_table_item", tbl, "%d x %d" % (n, esz))
        nsw += 1
    log("switch sites handled %d" % nsw)

    # ---- 7. pointer xrefs
    t2 = {}
    for r in rd(os.path.join(GAP, r"raw\reach.tsv")):
        if r["tier"].startswith("T2") and r["kind"].startswith("ptr"):
            t2[int(r["src"], 16)] = int(r["ea"], 16)
    sites = rd(os.path.join(GAP, r"raw\ptr_sites.tsv"))
    siteset = set(int(r["site"], 16) for r in sites)

    def in_pub(ea):
        return any(lo <= ea < hi for lo, hi in PUBDATA) or any(a <= ea < z for a, z, d in DINIT)

    def has_dref(site, v):
        return any((not x.iscode) and x.to == v for x in idautils.XrefsFrom(site, 0))

    dinit_ptrs = []
    for r in sites:
        site = int(r["site"], 16); v = int(r["target"], 16)
        if v not in tgt or v >= WIN_HI + 0xA00:
            continue
        hd = ida_bytes.get_item_head(site)
        fl = ida_bytes.get_flags(hd)
        if ida_bytes.is_code(fl):
            if hd not in tgt:
                continue
            insn = ida_ua.insn_t()
            if ida_ua.decode_insn(insn, hd) <= 0:
                continue
            for n_, op in enumerate(insn.ops):
                if op.type == 0:
                    break
                if op.type == ida_ua.o_imm and (op.value & 0xFFFFFFFF) == v:
                    if not ida_bytes.is_off(ida_bytes.get_flags(hd), n_):
                        ida_offset.op_plain_offset(hd, n_, 0); note("7", "imm_offset", hd, "op%d -> %08X" % (n_, v))
                    break
            continue
        if site % 4:
            continue                      # unaligned LE32 matches are not typed (coincidental)
        if any(a <= site < z for a, z, d in DINIT):
            dinit_ptrs.append((site, v)); continue
        if not (in_pub(site) or site in t2):
            continue
        if all(ida_bytes.is_unknown(ida_bytes.get_flags(x)) for x in range(site, site + 4)):
            if want_data(site, 4, "dword"):
                note("7", "ptr_dword", site, "%08X" % v)
        fl = ida_bytes.get_flags(site)
        if ida_bytes.is_dword(fl) and ida_bytes.get_item_size(site) == 4:
            if not ida_bytes.is_off0(fl):
                ida_offset.op_plain_offset(site, 0, 0); note("7", "ptr_offset", site, "%08X" % v)
        elif ida_bytes.is_head(fl) and not has_dref(site, v):
            ida_xref.add_dref(site, v, ida_xref.dr_O | ida_xref.XREF_USER); note("7", "ptr_dref_user", site, "%08X" % v)
        elif not ida_bytes.is_head(fl):
            note("7", "ptr_site_untyped", site, "%08X inside another item" % v)
    with open(os.path.join(OUT, "dinit-code-pointers.tsv"), "w", encoding="utf-8", newline="\n") as h:
        h.write("rom_site\tram_copy\tcode_target\n")
        for site, v in sorted(dinit_ptrs):
            a, z, d = [x for x in DINIT if x[0] <= site < x[1]][0]
            h.write("%08X\t%05X\t%08X\n" % (site, d + site - a, v))
    ida_auto.auto_wait()

    # ---- 8. functions
    def fstart(ea):
        f = ida_funcs.get_func(ea)
        return f.start_ea if f else None

    for act, ea, end, why in plan:
        if act != "create":
            continue
        f = ida_funcs.get_func(ea)
        if f and f.start_ea == ea:
            continue
        if f:
            # swallowed by another function's chunk: give the range back
            ch = ida_funcs.get_fchunk(ea)
            if ch and ch.start_ea != f.start_ea:
                ida_funcs.remove_func_tail(f, ch.start_ea); note("8", "remove_tail", ch.start_ea, "from %08X for entry %08X" % (f.start_ea, ea))
            else:
                ida_funcs.set_func_end(f.start_ea, ea); note("8", "trim_func", f.start_ea, "end -> %08X for entry %08X" % (ea, ea))
        ok = ida_funcs.add_func(ea, end)
        if not ok:
            ok = ida_funcs.add_func(ea)
        note("8", "add_func" if ok else "add_func_FAIL", ea, "%08X %s" % (end, why))
    for act, ea, end, why in plan:
        if act != "merge" or end == ea:
            continue
        f = ida_funcs.get_func(ea)
        if not f or f.start_ea != ea:
            ok = ida_funcs.add_func(ea)
            note("8", "add_func_merge" if ok else "add_func_merge_FAIL", ea, why)
            f = ida_funcs.get_func(ea)
        if not f:
            continue
        if ea in merge_tails:
            fend, tails = merge_tails[ea]
            if f.end_ea < fend and fstart(fend - 1) is None:
                ida_funcs.set_func_end(ea, fend); note("8", "merge_extend", ea, "end -> %08X" % fend)
            for a, z in tails:
                if fstart(a) is None:
                    ida_funcs.append_func_tail(ida_funcs.get_func(ea), a, z); note("8", "merge_tail", a, "%08X-%08X -> %08X" % (a, z, ea))
    ida_auto.auto_wait()

    vec = set()
    for i in range(256):
        vec.add(le32(INTB + 4 * i))
    for i in range(32):
        vec.add(le32(0xFFFFFF80 + 4 * i))

    def is_stop(ea):
        insn = ida_ua.insn_t()
        return ida_ua.decode_insn(insn, ea) > 0 and bool(insn.get_canon_feature() & CF_STOP)

    for it in range(30):
        tk = sorted(t for t in tgt if fstart(t) is None and ida_bytes.is_code(ida_bytes.get_flags(t)))
        blocks = []
        for t in tk:
            if blocks and blocks[-1][1] == t and not blocks[-1][2]:
                blocks[-1][1] = t + tgt[t][0]; blocks[-1][2] = is_stop(t)
            else:
                blocks.append([t, t + tgt[t][0], is_stop(t)])
        # a block also ends where an owned head begins
        prog = 0
        for s, e, stp in blocks:
            if fstart(s) is not None:
                continue
            p = ida_bytes.prev_head(s, LO)
            pf = fstart(p) if p != idc.BADADDR else None
            if pf is not None and ida_bytes.is_code(ida_bytes.get_flags(p)) and p + ida_bytes.get_item_size(p) == s and not is_stop(p):
                ch = ida_funcs.get_fchunk(p)
                if ch.end_ea == s:
                    ok = ida_funcs.set_func_end(p, e)
                    note("8", "extend_flow" if ok else "extend_flow_FAIL", s, "%08X-%08X chunk of %08X" % (s, e, pf))
                else:
                    ok = ida_funcs.append_func_tail(ida_funcs.get_func(pf), s, e)
                    note("8", "tail_flow" if ok else "tail_flow_FAIL", s, "%08X-%08X -> %08X" % (s, e, pf))
                prog += 1; continue
            xin = [x for x in idautils.XrefsTo(s, 0) if x.type != 21]
            calls = [x for x in xin if x.iscode and x.type in (16, 17)]
            jumps = [x for x in xin if x.iscode and x.type in (18, 19) and fstart(x.frm) is not None]
            drefs = [x for x in xin if not x.iscode]
            if calls or drefs or s in vec:
                ok = ida_funcs.add_func(s, e)
                note("8", "add_func_ref" if ok else "add_func_ref_FAIL", s, "%08X calls %d drefs %d vec %d" % (e, len(calls), len(drefs), s in vec))
                prog += 1; continue
            if jumps:
                pf = fstart(jumps[0].frm)
                ok = ida_funcs.append_func_tail(ida_funcs.get_func(pf), s, e)
                note("8", "tail_jump" if ok else "tail_jump_FAIL", s, "%08X-%08X -> %08X (from %08X)" % (s, e, pf, jumps[0].frm))
                prog += 1; continue
            k = tgt[s][1]
            if k.startswith("res-") and stp and not k.startswith("res-w2-sliver"):
                ok = ida_funcs.add_func(s, e)
                note("8", "add_func_dead" if ok else "add_func_dead_FAIL", s, "%08X %s" % (e, k))
                prog += 1; continue
        if not prog:
            break
        ida_auto.auto_wait()
    left = [t for t in tgt if fstart(t) is None]
    for t in sorted(left):
        note("8", "unowned_left", t, tgt[t][1])
    log("unowned target heads left %d" % len(left))

    # ---- 9. re-run auto-analysis over the window, then measure the whole pass
    ida_auto.plan_range(LO, HI)
    ida_auto.auto_wait()
    post_heads, post_fns = snapshot()
    hadd = [e for e in post_heads if e not in pre_heads or pre_heads[e] != post_heads[e]]
    hdel = [e for e in pre_heads if e not in post_heads or pre_heads[e] != post_heads[e]]
    fadd = [s for s in post_fns if s not in pre_fns]
    fdel = [s for s in pre_fns if s not in post_fns]
    fchg = [s for s in post_fns if s in pre_fns and post_fns[s] != pre_fns[s]]
    code_now = [e for e, v in post_heads.items() if v[1] == "c"]
    extra = [e for e in code_now if e not in tgt or tgt[e][0] != post_heads[e][0]]
    missing = [e for e in tgt if e not in post_heads or post_heads[e] != (tgt[e][0], "c")]
    with open(CHG.replace("_changes", "_delta"), "w", encoding="utf-8", newline="\n") as h:
        h.write("kind\tea\tbefore\tafter\n")
        for e in sorted(hadd):
            h.write("item+\t%08X\t%s\t%s\n" % (e, pre_heads.get(e, ""), post_heads[e]))
        for e in sorted(hdel):
            if e not in post_heads:
                h.write("item-\t%08X\t%s\t\n" % (e, pre_heads[e]))
        for s in sorted(fadd):
            h.write("func+\t%08X\t\t%s\n" % (s, post_fns[s]))
        for s in sorted(fdel):
            h.write("func-\t%08X\t%s\t\n" % (s, pre_fns[s]))
        for s in sorted(fchg):
            h.write("func~\t%08X\t%s\t%s\n" % (s, pre_fns[s], post_fns[s]))
        for e in sorted(extra):
            h.write("extra_code\t%08X\t\t%s\n" % (e, post_heads[e]))
        for e in sorted(missing):
            h.write("missing_target\t%08X\t%s\t%s\n" % (e, tgt[e], post_heads.get(e)))
    for (step, action), n in sorted(cnt.items()):
        log("step %s %-22s %d" % (step, action, n))
    log("PASS %s: items changed/added %d removed-or-changed %d ; functions +%d -%d ~%d ; code heads %d ; extra code %d ; missing targets %d ; switch infos %d"
        % (PASS, len(hadd), len(hdel), len(fadd), len(fdel), len(fchg), len(code_now), len(extra), len(missing),
           sum(1 for e in code_now if ida_nalt.get_switch_info(e))))
    log("done")
    chg.close()


try:
    os.makedirs(RAW, exist_ok=True)
    main()
except Exception:
    with open(STATUS, "a", encoding="utf-8", newline="\n") as h:
        h.write(traceback.format_exc())
finally:
    import idc
    idc.qexit(0)
