r"""SUB-UPPER pass 1: maximise code recovery in the SUB upper region and dump a
function list + coverage, so later passes can test the bitmap-addressing and USB
questions against real disassembly.

Seeded --copy-from ida\db\radio\SUB.i64 (455 functions inherited).  Recovery is
the same proven three-stage approach SUB-VEC used, reproduced here independently:
  1. reclass the resource/dense/pad/rom segments CODE,
  2. vector-table closure (INTB 256 + EXTB 32, create funcs, BFS call graph),
  3. sweep: peripheral base-load seeds (RX FB imm24/imm32 into 0x00080000+),
     pointer-table seeds, prologue sweep, then xref closure.

Output: ida/out/sub-upper/
"""

from __future__ import annotations
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root

import os
import traceback

OUT = str(_REPO / "ida/out/sub-upper")
BASE = 0xFFC00000
SIZE = 0x400000
TOP = 0x100000000
INTB = 0xFFED8A70
EXTB = 0xFFFFFF80
MINE_LO = 0xFFE80000
MINE_HI = 0xFFFFFF80
CODE_LO = 0xFFED0000
STATUS = os.path.join(OUT, "probe_status.txt")


def log(text):
    with open(STATUS, "a", encoding="utf-8", newline="\n") as h:
        h.write(text + "\n")


def esc(text):
    return (text or "").replace("\t", " ").replace("\r", " ").replace("\n", " ")


def main():
    import ida_auto
    import ida_bytes
    import ida_funcs
    import ida_ida
    import ida_name
    import ida_segment
    import ida_ua
    import idautils
    import idc

    log("procname %s" % (ida_ida.inf_get_procname() or "?"))
    log("min %#x max %#x" % (ida_ida.inf_get_min_ea(), ida_ida.inf_get_max_ea()))

    seg_rows = []
    seg = ida_segment.get_first_seg()
    while seg is not None:
        seg_rows.append((idc.get_segm_name(seg.start_ea), seg.start_ea, seg.end_ea))
        seg = ida_segment.get_next_seg(seg.start_ea)
    for name, s, e in seg_rows:
        log("seg_in %s %08X-%08X" % (name, s, e))
    for name, s, e in seg_rows:
        if name in ("RES", "DENSE", "PAD", "ROM", "LOWER", "UPPER"):
            sg = ida_segment.getseg(s)
            try:
                ida_segment.set_segm_class(sg, "CODE", 0)
                log("reclass %s CODE ok" % name)
            except Exception as exc:
                log("reclass %s failed %s" % (name, exc))

    funcs_before = sum(1 for _ in idautils.Functions())
    log("funcs_before %d" % funcs_before)

    # ---- stage 2: vector-table closure ---------------------------------
    def read_table(table_ea, count):
        out = []
        for i in range(count):
            ea = table_ea + i * 4
            raw = ida_bytes.get_bytes(ea, 4)
            v = int.from_bytes(raw, "little") if raw and len(raw) == 4 else None
            out.append((i, ea, v))
        return out

    targets = {}
    for tag, rows in (("intb", read_table(INTB, 256)), ("extb", read_table(EXTB, 32))):
        for i, ea, v in rows:
            if v and BASE <= v < TOP:
                targets.setdefault(v, []).append((tag, i))
    log("distinct in-image vector targets %d" % len(targets))

    for v in sorted(targets):
        if not ida_bytes.is_code(ida_bytes.get_flags(v)):
            ida_bytes.del_items(v, ida_bytes.DELIT_SIMPLE, 4)
            ida_ua.create_insn(v)
        ida_auto.auto_make_proc(v)
    ida_auto.auto_wait()
    for v in sorted(targets):
        if ida_funcs.get_func(v) is None:
            ida_funcs.add_func(v)
    ida_auto.auto_wait()

    seen = set()
    queue = list(sorted(targets))
    rounds = 0
    while queue and rounds < 400:
        rounds += 1
        nxt = []
        for start in queue:
            if start in seen:
                continue
            seen.add(start)
            f = ida_funcs.get_func(start)
            if f is None:
                continue
            ea = f.start_ea
            while ea < f.end_ea and ea != idc.BADADDR:
                for ref in idautils.CodeRefsFrom(ea, 0):
                    if BASE <= ref < TOP and ref not in seen:
                        if ida_funcs.get_func(ref) is None:
                            ida_bytes.del_items(ref, ida_bytes.DELIT_SIMPLE, 2)
                            ida_ua.create_insn(ref)
                            ida_auto.auto_make_proc(ref)
                        nxt.append(ref)
                ea = idc.next_head(ea, f.end_ea)
        if nxt:
            ida_auto.auto_wait()
        queue = []
        for ref in nxt:
            fr = ida_funcs.get_func(ref)
            if fr is not None and fr.start_ea not in seen:
                queue.append(fr.start_ea)
            elif fr is None and ref not in seen:
                queue.append(ref)
    ida_auto.auto_wait()
    log("vector closure rounds %d, funcs now %d" % (rounds, sum(1 for _ in idautils.Functions())))

    # ---- stage 3: sweep -------------------------------------------------
    segs = []
    for name, s, e in seg_rows:
        blob = ida_bytes.get_bytes(s, e - s)
        if blob:
            segs.append((s, blob))

    def gb(ea):
        b = ida_bytes.get_byte(ea)
        return b if b is not None else 0xFF

    def is_ret_at(ea):
        b0 = gb(ea)
        if b0 == 0x02:
            return 1
        if b0 == 0x7F and gb(ea + 1) in (0x94, 0x95):
            return 2
        if b0 == 0x67:
            return 2
        if b0 == 0x3F:
            return 3
        return 0

    def plausible(ea, limit=0x1000):
        if not (MINE_LO <= ea < MINE_HI):
            return False
        cur = ea
        count = 0
        while cur < ea + limit and cur < MINE_HI:
            r = is_ret_at(cur)
            insn = ida_ua.insn_t()
            ln = ida_ua.decode_insn(insn, cur)
            if ln <= 0 or ln > 8:
                return False
            if r and r == ln:
                return count >= 2
            count += 1
            if count > 600:
                return False
            cur += ln
        return False

    def is_prologue(ea):
        b0, b1 = gb(ea), gb(ea + 1)
        if b0 == 0x6E:
            return 1 <= (b1 >> 4) < (b1 & 0xF) <= 15
        if b0 == 0x7E and 0xA0 <= b1 <= 0xAF:
            return True
        if b0 == 0x60 and (b1 & 0x0F) == 0 and (b1 >> 4):
            return True
        if b0 == 0x71 and b1 == 0x04:
            return True
        if b0 == 0xFB and (b1 & 0x0F) in (0x02, 0x0E):
            return True
        return False

    sites = []
    for s, blob in segs:
        n = len(blob)
        for off in range(n - 6):
            if blob[off] != 0xFB:
                continue
            lo = blob[off + 1] & 0x0F
            if lo == 0x0E:
                v = int.from_bytes(blob[off + 2:off + 5], "little")
            elif lo == 0x02:
                v = int.from_bytes(blob[off + 2:off + 6], "little")
            else:
                continue
            if 0x00080000 <= v < 0x00100000:
                sites.append(s + off)
    in_mine = [x for x in sites if MINE_LO <= x < MINE_HI]
    uncovered = [x for x in in_mine if ida_funcs.get_func(x) is None]
    log("periph base-load sites %d, in owned %d, uncovered %d" % (len(sites), len(in_mine), len(uncovered)))

    seeds = set()
    for x in uncovered:
        for back in range(0, 0x300):
            c = x - back
            if c < CODE_LO:
                break
            if not is_prologue(c):
                continue
            cur = c
            ok = False
            while cur <= x:
                if cur == x:
                    ok = True
                    break
                insn = ida_ua.insn_t()
                ln = ida_ua.decode_insn(insn, cur)
                if ln <= 0 or ln > 8:
                    break
                cur += ln
            if ok and plausible(c):
                seeds.add(c)
                break

    for s, blob in segs:
        for off in range(0, len(blob) - 3, 4):
            v = int.from_bytes(blob[off:off + 4], "little")
            if MINE_LO <= v < MINE_HI and ida_funcs.get_func(v) is None and is_prologue(v) and plausible(v):
                seeds.add(v)

    ea = CODE_LO
    while ea < MINE_HI:
        if ida_bytes.is_code(ida_bytes.get_flags(ea)) or ida_funcs.get_func(ea) is not None:
            ea += 1
            continue
        if gb(ea) in (0x6E, 0x7E, 0x60, 0x71) and is_prologue(ea) and plausible(ea):
            seeds.add(ea)
            ea += 2
            continue
        ea += 1
    log("sweep seeds %d" % len(seeds))

    for v in sorted(seeds):
        if ida_funcs.get_func(v) is None:
            ida_bytes.del_items(v, ida_bytes.DELIT_SIMPLE, 2)
            if ida_ua.create_insn(v):
                ida_auto.auto_make_proc(v)
    ida_auto.auto_wait()

    for rnd in range(25):
        add = set()
        for s in list(idautils.Functions()):
            f = ida_funcs.get_func(s)
            if f is None or not (MINE_LO <= s < TOP):
                continue
            e = f.start_ea
            while e < f.end_ea and e != idc.BADADDR:
                for ref in idautils.CodeRefsFrom(e, 0):
                    if MINE_LO <= ref < MINE_HI and ida_funcs.get_func(ref) is None:
                        add.add(ref)
                e = idc.next_head(e, f.end_ea)
        if not add:
            break
        made = 0
        for ref in add:
            ida_bytes.del_items(ref, ida_bytes.DELIT_SIMPLE, 2)
            if ida_ua.create_insn(ref):
                ida_auto.auto_make_proc(ref)
                made += 1
        ida_auto.auto_wait()
        if made == 0:
            break
    ida_auto.auto_wait()

    # ---- coverage + dump ------------------------------------------------
    nf = nb = 0
    with open(os.path.join(OUT, "functions.tsv"), "w", encoding="utf-8", newline="\n") as h:
        h.write("ea\tend\tsize\tfile_off\tname\n")
        for s in idautils.Functions():
            f = ida_funcs.get_func(s)
            if not f:
                continue
            nf += 1
            nb += f.end_ea - f.start_ea
            h.write("%08X\t%08X\t%d\t%06X\t%s\n" % (s, f.end_ea, f.end_ea - s, s - BASE, esc(idc.get_func_name(s) or "")))

    code_b = data_b = undef_b = 0
    ea = CODE_LO
    while ea < MINE_HI:
        fl = ida_bytes.get_flags(ea)
        if ida_bytes.is_code(fl):
            code_b += 1
        elif ida_bytes.is_data(fl):
            data_b += 1
        else:
            undef_b += 1
        ea += 1

    with open(os.path.join(OUT, "coverage.txt"), "w", encoding="utf-8", newline="\n") as h:
        h.write("database SUB_UPPER, seeded --copy-from ida/db/radio/SUB.i64\n")
        h.write("funcs_before %d\nfuncs_after %d bytes_in_functions %d\n" % (funcs_before, nf, nb))
        h.write("code window FFED0000-FFFFFF80 (%d bytes): code %d data %d undefined %d\n"
                % (MINE_HI - CODE_LO, code_b, data_b, undef_b))
    log("probe done funcs %d bytes %d" % (nf, nb))


if True:
    os.makedirs(OUT, exist_ok=True)
    with open(STATUS, "w", encoding="utf-8", newline="\n") as _h:
        _h.write("start\n")
    try:
        main()
    except Exception:
        with open(os.path.join(OUT, "probe_traceback.txt"), "w", encoding="utf-8", newline="\n") as _h:
            _h.write(traceback.format_exc())
        log("EXCEPTION written")
    import idc as _idc
    _idc.qexit(0)
