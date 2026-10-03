r"""SUB-VEC pass C: dump the vector-setup and handler-body functions, then extend
code recovery in the region above 0xFFE80000 that SUB-VEC owns.

    python ida/run_job.py --script ida\jobs\subvec_recover.py \
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
STATUS = os.path.join(OUT, "passC_status.txt")

DUMP = [
    0xFFEDB300,  # SCI + ICU setup
    0xFFF36CCA,  # module-stop / clock init
    0xFFF36F03,
    0xFFF37443,
    0xFFEE1393,
    0xFFF15055,
    0xFFF33AA7,  # body of vector 44
    0xFFF32A29,  # body of vector 111
    0xFFF33122,  # body of vector 123
    0xFFF32BB7,  # vector 128 enable/disable
    0xFFF39E37,  # vector 129 enable/disable
    0xFFEF1DDA,  # vector 126 disable
    0xFFEF1E4C,
    0xFFF15648,  # vector 134
    0xFFEE1105,  # vector 135
    0xFFF36B1E,  # vector 136
    0xFFF36B9D,
    0xFFF15168,  # MTU-area init
    0xFFF1521C,  # vector 210 enable
    0xFFF1522B,
    0xFFF15087,
    0xFFF150D2,
    0xFFF37590,
    0xFFEDC976,
    0xFFEDD6FB,
]


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

    def dump_func(h, start):
        f = ida_funcs.get_func(start)
        nm = idc.get_func_name(start) or idc.get_name(start) or ""
        if f is None:
            h.write("\n;=== %08X no function (%s)\n" % (start, nm))
            return
        h.write("\n;=== %08X-%08X  file %06X  size %d  %s\n" % (
            f.start_ea, f.end_ea, f.start_ea - BASE, f.end_ea - f.start_ea, nm))
        ea = f.start_ea
        while ea < f.end_ea and ea != idc.BADADDR:
            sz = max(1, idc.get_item_size(ea))
            raw = ida_bytes.get_bytes(ea, min(sz, 12)) or b""
            h.write("%08X  %-26s %s\n" % (ea, raw.hex(), esc(idc.generate_disasm_line(ea, 0) or "")))
            ea = idc.next_head(ea, f.end_ea)

    with open(os.path.join(OUT, "setup_disasm.txt"), "w", encoding="utf-8", newline="\n") as h:
        for start in DUMP:
            dump_func(h, start)
    log("wrote setup_disasm.txt")

    # -------- coverage before ------------------------------------------
    def coverage():
        n = 0
        b = 0
        nmine = 0
        bmine = 0
        for s in idautils.Functions():
            f = ida_funcs.get_func(s)
            if not f:
                continue
            n += 1
            b += f.end_ea - f.start_ea
            if MINE_LO <= s < TOP:
                nmine += 1
                bmine += f.end_ea - f.start_ea
        return n, b, nmine, bmine

    c0 = coverage()
    log("before funcs %d bytes %d  mine funcs %d bytes %d" % c0)

    # -------- step 1: pointer tables -> code candidates ----------------
    # Every 4-byte-aligned dword anywhere in the image whose value lands in
    # 0xFFE80000..0xFFFFFF80 and decodes as a plausible RX prologue.
    PRO = set()

    def plausible(ea):
        """Decode forward; accept if >=4 instructions decode cleanly and an
        rts/rte/bra is reached inside 0x800 bytes."""
        if not (MINE_LO <= ea < MINE_HI):
            return False
        cur = ea
        count = 0
        while cur < ea + 0x800:
            insn = ida_ua.insn_t()
            ln = ida_ua.decode_insn(insn, cur)
            if ln <= 0:
                return False
            m = (idc.print_insn_mnem(cur) or "").lower()
            if not m:
                return False
            count += 1
            if m in ("rts", "rte", "rtfi", "rtsd"):
                return count >= 3
            if m in ("bra", "jmp") and count >= 3:
                return True
            cur += ln
            if count > 400:
                return False
        return False

    def is_prologue(ea):
        b0 = ida_bytes.get_byte(ea)
        b1 = ida_bytes.get_byte(ea + 1)
        if b0 == 0x6E:                       # pushm rA-rB
            lo, hi = b1 >> 4, b1 & 0xF
            return 1 <= lo < hi <= 15
        if b0 == 0x7E and 0xA0 <= b1 <= 0xAF:  # push.l rN
            return True
        if b0 == 0x60 and (b1 & 0x0F) == 0 and (b1 >> 4) != 0:  # sub #imm,sp
            return True
        if b0 == 0x71 and b1 == 0x04:        # add #imm, sp, sp
            return True
        return False

    seg = ida_segment.get_first_seg()
    ptr_hits = 0
    while seg is not None:
        blob = ida_bytes.get_bytes(seg.start_ea, seg.end_ea - seg.start_ea)
        if blob:
            for off in range(0, len(blob) - 3, 4):
                v = int.from_bytes(blob[off:off + 4], "little")
                if MINE_LO <= v < MINE_HI and (v & 1) == 0:
                    if ida_funcs.get_func(v) is None and is_prologue(v) and plausible(v):
                        PRO.add(v)
                        ptr_hits += 1
        seg = ida_segment.get_next_seg(seg.start_ea)
    log("pointer-table candidates %d" % ptr_hits)

    # -------- step 2: prologue sweep over undefined bytes --------------
    sweep_hits = 0
    ea = MINE_LO
    while ea < MINE_HI:
        fl = ida_bytes.get_flags(ea)
        if ida_bytes.is_code(fl) or ida_funcs.get_func(ea) is not None:
            ea += 1
            continue
        if is_prologue(ea) and plausible(ea):
            PRO.add(ea)
            sweep_hits += 1
            ea += 2
            continue
        ea += 1
    log("prologue-sweep candidates %d total %d" % (sweep_hits, len(PRO)))

    # -------- step 3: create them, then close the xref graph ----------
    created = 0
    for v in sorted(PRO):
        if ida_funcs.get_func(v) is not None:
            continue
        ida_bytes.del_items(v, ida_bytes.DELIT_SIMPLE, 2)
        if ida_ua.create_insn(v):
            ida_auto.auto_make_proc(v)
            created += 1
    ida_auto.auto_wait()
    log("auto_make_proc %d, waiting" % created)

    # xref closure
    for rnd in range(30):
        add = []
        for s in list(idautils.Functions()):
            f = ida_funcs.get_func(s)
            if f is None or not (MINE_LO <= s < TOP):
                continue
            e = f.start_ea
            while e < f.end_ea and e != idc.BADADDR:
                for ref in idautils.CodeRefsFrom(e, 0):
                    if MINE_LO <= ref < MINE_HI and ida_funcs.get_func(ref) is None:
                        add.append(ref)
                e = idc.next_head(e, f.end_ea)
        if not add:
            log("xref closure settled at round %d" % rnd)
            break
        for ref in set(add):
            ida_bytes.del_items(ref, ida_bytes.DELIT_SIMPLE, 2)
            ida_ua.create_insn(ref)
            ida_auto.auto_make_proc(ref)
        ida_auto.auto_wait()
    ida_auto.auto_wait()

    c1 = coverage()
    log("after funcs %d bytes %d  mine funcs %d bytes %d" % c1)

    # -------- function list -------------------------------------------
    with open(os.path.join(OUT, "functions_after.tsv"), "w", encoding="utf-8", newline="\n") as h:
        h.write("ea\tend\tsize\tfile_off\tname\n")
        for s in idautils.Functions():
            f = ida_funcs.get_func(s)
            if not f:
                continue
            h.write("%08X\t%08X\t%d\t%06X\t%s\n" % (
                s, f.end_ea, f.end_ea - s, s - BASE, esc(idc.get_func_name(s) or "")))
    log("wrote functions_after.tsv")

    with open(os.path.join(OUT, "coverage.txt"), "w", encoding="utf-8", newline="\n") as h:
        h.write("region_owned %08X-%08X (%d bytes)\n" % (MINE_LO, MINE_HI, MINE_HI - MINE_LO))
        h.write("baseline_from ida/db/radio/SUB.i64  functions 455  bytes 106944\n")
        h.write("after_passA   functions %d bytes %d\n" % (c0[0], c0[1]))
        h.write("after_passC   functions %d bytes %d\n" % (c1[0], c1[1]))
        h.write("in_owned_region_before functions %d bytes %d\n" % (c0[2], c0[3]))
        h.write("in_owned_region_after  functions %d bytes %d\n" % (c1[2], c1[3]))
        h.write("pointer_table_candidates %d\nprologue_sweep_candidates %d\ncreated %d\n" % (
            ptr_hits, sweep_hits, created))
    log("passC done")


if True:
    os.makedirs(OUT, exist_ok=True)
    with open(STATUS, "w", encoding="utf-8", newline="\n") as _h:
        _h.write("start\n")
    try:
        main()
    except Exception:
        with open(os.path.join(OUT, "passC_traceback.txt"), "w", encoding="utf-8", newline="\n") as _h:
            _h.write(traceback.format_exc())
        log("EXCEPTION written")
    import idc as _idc
    _idc.qexit(0)
