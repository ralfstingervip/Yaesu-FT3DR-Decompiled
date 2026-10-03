r"""SUB-VEC pass D: extend code recovery above 0xFFE80000.

Three seed sources:
  1. every `MOV.L #imm, rd` site (RX encodings FB (rd<<4)|0x0E + imm24 and
     FB (rd<<4)|0x02 + imm32) whose immediate lands in 0x00080000-0x000FFFFF --
     these are known-good instruction addresses even in undisassembled code;
  2. pointer-table follows: aligned dwords anywhere in the image that point at a
     plausible prologue in the owned region;
  3. a prologue-pattern linear sweep over undefined bytes.

Validation of a candidate is byte-level: every instruction must decode, and a
return instruction (rts 02 / rte 7F95 / rtfi 7F94 / rtsd 67xx / 3Fxxyy) must be
reached within 0x1000 bytes.

    python ida/run_job.py --script ida\jobs\subvec_sweep.py \
        --db SUB_VEC --reopen --timeout 7000
"""

from __future__ import annotations
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root

import os
import traceback

OUT = str(_REPO / "ida/out/sub-vec")
BASE = 0xFFC00000
TOP = 0x100000000
MINE_LO = 0xFFE80000
MINE_HI = 0xFFFFFF80
CODE_LO = 0xFFED0000          # where real code starts in the owned region
STATUS = os.path.join(OUT, "passD_status.txt")


def log(text):
    with open(STATUS, "a", encoding="utf-8", newline="\n") as handle:
        handle.write(text + "\n")


def esc(text):
    return (text or "").replace("\t", " ").replace("\r", " ").replace("\n", " ")


def main():
    import ida_auto
    import ida_bytes
    import ida_funcs
    import ida_segment
    import ida_ua
    import idautils
    import idc

    # whole image as bytes, for the encoding scan
    img = {}
    seg = ida_segment.get_first_seg()
    segs = []
    while seg is not None:
        blob = ida_bytes.get_bytes(seg.start_ea, seg.end_ea - seg.start_ea)
        if blob:
            segs.append((seg.start_ea, blob))
        seg = ida_segment.get_next_seg(seg.start_ea)
    log("segments read %d" % len(segs))

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
        if b0 == 0x6E:                                 # pushm rA-rB
            return 1 <= (b1 >> 4) < (b1 & 0xF) <= 15
        if b0 == 0x7E and 0xA0 <= b1 <= 0xAF:          # push.l rN
            return True
        if b0 == 0x60 and (b1 & 0x0F) == 0 and (b1 >> 4):  # sub #imm4, sp
            return True
        if b0 == 0x71 and b1 == 0x04:                  # add #imm, sp, sp
            return True
        if b0 == 0xFB and (b1 & 0x0F) in (0x02, 0x0E):  # mov.l #imm, rd
            return True
        return False

    # ---- seed 1: MOV.L #imm,rd sites with a peripheral immediate ----
    sites = []
    for start, blob in segs:
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
                sites.append(start + off)
    in_mine = [s for s in sites if MINE_LO <= s < MINE_HI]
    uncovered = [s for s in in_mine if ida_funcs.get_func(s) is None]
    log("periph base-load sites total %d in owned region %d not in a function %d" % (
        len(sites), len(in_mine), len(uncovered)))
    with open(os.path.join(OUT, "periph_base_loads.tsv"), "w", encoding="utf-8", newline="\n") as h:
        h.write("insn_ea\tfile_off\tperiph_addr\tregion\tin_function\n")
        for s in sorted(sites):
            lo = gb(s + 1) & 0x0F
            v = int.from_bytes(ida_bytes.get_bytes(s + 2, 3 if lo == 0x0E else 4) or b"\0", "little")
            f = ida_funcs.get_func(s)
            h.write("%08X\t%06X\t%08X\t%s\t%s\n" % (
                s, s - BASE, v,
                "owned" if MINE_LO <= s < MINE_HI else "lower",
                idc.get_func_name(f.start_ea) if f else ""))
    log("wrote periph_base_loads.tsv")

    # for each uncovered site, walk back to a prologue that linearly reaches it
    seeds = set()
    for s in uncovered:
        found = None
        for back in range(0, 0x300):
            c = s - back
            if c < CODE_LO:
                break
            if not is_prologue(c):
                continue
            cur = c
            ok = False
            while cur <= s:
                if cur == s:
                    ok = True
                    break
                insn = ida_ua.insn_t()
                ln = ida_ua.decode_insn(insn, cur)
                if ln <= 0 or ln > 8:
                    break
                cur += ln
            if ok and plausible(c):
                found = c
                break
        if found is not None:
            seeds.add(found)
    log("seed1 prologues recovered %d" % len(seeds))

    # ---- seed 2: pointer tables ----
    ptr = 0
    for start, blob in segs:
        for off in range(0, len(blob) - 3, 4):
            v = int.from_bytes(blob[off:off + 4], "little")
            if MINE_LO <= v < MINE_HI and ida_funcs.get_func(v) is None:
                if is_prologue(v) and plausible(v):
                    seeds.add(v)
                    ptr += 1
    log("seed2 pointer-table candidates %d (cumulative seeds %d)" % (ptr, len(seeds)))

    # ---- seed 3: prologue sweep over undefined bytes ----
    sweep = 0
    ea = CODE_LO
    while ea < MINE_HI:
        if ida_bytes.is_code(ida_bytes.get_flags(ea)) or ida_funcs.get_func(ea) is not None:
            ea += 1
            continue
        b0 = gb(ea)
        if b0 in (0x6E, 0x7E, 0x60, 0x71) and is_prologue(ea) and plausible(ea):
            seeds.add(ea)
            sweep += 1
            ea += 2
            continue
        ea += 1
    log("seed3 prologue-sweep candidates %d (cumulative seeds %d)" % (sweep, len(seeds)))

    # ---- create ----
    created = 0
    for v in sorted(seeds):
        if ida_funcs.get_func(v) is not None:
            continue
        ida_bytes.del_items(v, ida_bytes.DELIT_SIMPLE, 2)
        if ida_ua.create_insn(v):
            ida_auto.auto_make_proc(v)
            created += 1
    ida_auto.auto_wait()
    log("created %d, first wait done" % created)

    # ---- xref closure ----
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
            log("xref closure settled after %d rounds" % rnd)
            break
        made = 0
        for ref in add:
            ida_bytes.del_items(ref, ida_bytes.DELIT_SIMPLE, 2)
            if ida_ua.create_insn(ref):
                ida_auto.auto_make_proc(ref)
                made += 1
        ida_auto.auto_wait()
        log("round %d refs %d made %d" % (rnd, len(add), made))
        if made == 0:
            break
    ida_auto.auto_wait()

    # ---- coverage ----
    nf = nb = mf = mb = 0
    for s in idautils.Functions():
        f = ida_funcs.get_func(s)
        if not f:
            continue
        nf += 1
        nb += f.end_ea - f.start_ea
        if MINE_LO <= s < TOP:
            mf += 1
            mb += f.end_ea - f.start_ea
    # byte-level classification of the code-bearing part of the owned region
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
    log("funcs %d bytes %d  owned funcs %d bytes %d" % (nf, nb, mf, mb))
    log("FFED0000-FFFFFF80 code %d data %d undefined %d" % (code_b, data_b, undef_b))

    with open(os.path.join(OUT, "coverage.txt"), "w", encoding="utf-8", newline="\n") as h:
        h.write("database SUB_VEC, seeded --copy-from ida/db/radio/SUB.i64\n")
        h.write("owned region %08X-%08X\n" % (MINE_LO, MINE_HI))
        h.write("baseline (shared SUB.i64)      functions 455  bytes_in_functions 106944\n")
        h.write("after passA (vector closure)   functions 876  bytes_in_functions 147376\n")
        h.write("after passD (sweep)            functions %d  bytes_in_functions %d\n" % (nf, nb))
        h.write("functions with start in owned region %d  bytes %d\n" % (mf, mb))
        h.write("periph base-load sites: image %d, owned region %d, not in a function before passD %d\n" % (
            len(sites), len(in_mine), len(uncovered)))
        h.write("seeds: base-load prologues %d, pointer-table %d, prologue-sweep %d, created %d\n" % (
            len(seeds) - ptr - sweep, ptr, sweep, created))
        h.write("byte classification FFED0000-FFFFFF80 (%d bytes): code %d data %d undefined %d\n" % (
            MINE_HI - CODE_LO, code_b, data_b, undef_b))

    with open(os.path.join(OUT, "functions_after.tsv"), "w", encoding="utf-8", newline="\n") as h:
        h.write("ea\tend\tsize\tfile_off\tname\n")
        for s in idautils.Functions():
            f = ida_funcs.get_func(s)
            if not f:
                continue
            h.write("%08X\t%08X\t%d\t%06X\t%s\n" % (
                s, f.end_ea, f.end_ea - s, s - BASE, esc(idc.get_func_name(s) or "")))
    log("passD done")


if True:
    os.makedirs(OUT, exist_ok=True)
    with open(STATUS, "w", encoding="utf-8", newline="\n") as _h:
        _h.write("start\n")
    try:
        main()
    except Exception:
        with open(os.path.join(OUT, "passD_traceback.txt"), "w", encoding="utf-8", newline="\n") as _h:
            _h.write(traceback.format_exc())
        log("EXCEPTION written")
    import idc as _idc
    _idc.qexit(0)
