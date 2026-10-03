r"""Lane 4 pass 3 -- recover the dark code in the SUB window code band.

The band 0xFFEDB000-0xFFF48000 (+ 0xFFF4C000-0xFFF50000) is ~all instructions
(hex-verified) but only ~30% is in functions: entire dark functions reached only
through register-indirect dispatch sit between the recovered ones. This pass
gap-fills undefined bytes with a synced linear disassembly, creates functions at
prologues and at every call/jump target, closes xrefs, then measures with a
fall-through-aware validator.

    python ida/run_job.py --script ida\jobs\full_l4_recover.py --db SUB_WINDOW --reopen --timeout 6000
"""
from __future__ import annotations
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root
import os, traceback

OUT = str(_REPO / "ida/out/sub-window")
BASE = 0xFFC00000
WIN_LO = 0xFFED0000
WIN_HI = 0xFFF50000
STATUS = os.path.join(OUT, "l4_recover_status.txt")
# code sub-bands (exclude leading data tables 0xFFED0000-0xFFEDB000 and the
# string pool 0xFFF48000-0xFFF4C000)
BANDS = [(0xFFEDB000, 0xFFF48000), (0xFFF4C000, 0xFFF50000)]
DATA_REGIONS = [
    (0xFFED0000, 0xFFED3F6C, "bitmap-descriptor-table-tail"),
    (0xFFED3F6C, 0xFFED5800, "UI-layout-tables"),
    (0xFFED5800, 0xFFED8A70, "zero-heavy-tables"),
    (0xFFED8A70, 0xFFED8E70, "INTB-vector-table"),
    (0xFFED8E70, 0xFFEDB000, "post-vector-data"),
    (0xFFF48000, 0xFFF4C000, "string-pool"),
]


def log(t):
    with open(STATUS, "a", encoding="utf-8", newline="\n") as h:
        h.write(t + "\n")


def main():
    import ida_auto, ida_bytes, ida_funcs, ida_ua, idautils, idc
    CF_STOP = 0x00001

    def gb(ea):
        b = ida_bytes.get_byte(ea)
        return b if b is not None else 0xFF

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

    def plausible_seed(ea, bound=0x2000):
        # linear decode from ea must reach a flow-stop within bound with no
        # invalid instruction and >=3 instructions (rejects data pools)
        cur = ea
        n = 0
        while cur < ea + bound and cur < WIN_HI:
            insn = ida_ua.insn_t()
            ln = ida_ua.decode_insn(insn, cur)
            if ln <= 0 or ln > 8:
                return False
            n += 1
            if insn.get_canon_feature() & CF_STOP:
                return n >= 3
            cur += ln
        return False

    def in_data_region(ea):
        for lo, hi, lbl in DATA_REGIONS:
            if lo <= ea < hi:
                return lbl
        return None

    def code_bytes_window():
        c = 0
        ea = WIN_LO
        while ea < WIN_HI:
            if ida_bytes.is_code(ida_bytes.get_flags(ea)):
                c += 1
            ea += 1
        return c

    before = code_bytes_window()
    log("code bytes before %d" % before)

    # ---- gap-filling synced linear disassembly, iterated ----
    # seed an undefined byte only at a real function boundary: either a prologue,
    # or immediately after a flow-stop instruction (rts/rte/bra/jmp). plausible_seed
    # requires a clean run to a flow-stop, which rejects data pools.
    made = 0
    for rnd in range(6):
        rmade = 0
        for blo, bhi in BANDS:
            ea = blo
            prev_stop = True   # start of band is a boundary
            while ea < bhi:
                fl = ida_bytes.get_flags(ea)
                if ida_bytes.is_code(fl):
                    insn = ida_ua.insn_t()
                    ln = ida_ua.decode_insn(insn, ea)
                    prev_stop = bool(insn.get_canon_feature() & CF_STOP) if ln > 0 else False
                    sz = ida_bytes.get_item_size(ea)
                    ea += sz if sz > 0 else 1
                    continue
                if ida_bytes.is_data(fl):
                    prev_stop = False
                    sz = ida_bytes.get_item_size(ea)
                    ea += sz if sz > 0 else 1
                    continue
                # undefined -- guarded aggressive: any clean run to a flow-stop
                if plausible_seed(ea):
                    if ida_ua.create_insn(ea) and ida_funcs.add_func(ea):
                        rmade += 1
                        insn = ida_ua.insn_t()
                        ida_ua.decode_insn(insn, ea)
                        sz = ida_bytes.get_item_size(ea)
                        ea += sz if sz > 0 else 1
                        prev_stop = False
                        continue
                prev_stop = False
                ea += 1
        ida_auto.auto_wait()
        made += rmade
        log("fill round %d made %d (code bytes %d)" % (rnd, rmade, code_bytes_window()))
        if rmade == 0:
            break
    fail = 0
    log("linear fill total: made %d" % made)

    # ---- create functions at prologues in the band ----
    fnew = 0
    for blo, bhi in BANDS:
        ea = blo
        while ea < bhi:
            if ida_bytes.is_code(ida_bytes.get_flags(ea)) and ida_funcs.get_func(ea) is None:
                if is_prologue(ea) and plausible_seed(ea):
                    if ida_funcs.add_func(ea):
                        fnew += 1
            ea += 1
    ida_auto.auto_wait()
    log("functions added at prologues %d" % fnew)

    # ---- xref closure: create functions at every call/jump target in band ----
    for rnd in range(30):
        add = set()
        for s in list(idautils.Functions(WIN_LO, 0xFFFFFF80)):
            f = ida_funcs.get_func(s)
            if not f:
                continue
            e = f.start_ea
            while e < f.end_ea and e != idc.BADADDR:
                for ref in idautils.CodeRefsFrom(e, 0):
                    if WIN_LO <= ref < WIN_HI and ida_funcs.get_func(ref) is None \
                            and ida_bytes.is_code(ida_bytes.get_flags(ref)):
                        add.add(ref)
                nx = idc.next_head(e, f.end_ea)
                if nx == idc.BADADDR or nx <= e:
                    break
                e = nx
        if not add:
            log("xref closure settled round %d" % rnd)
            break
        m = 0
        for ref in add:
            if ida_funcs.add_func(ref):
                m += 1
        ida_auto.auto_wait()
        if m == 0:
            break
    ida_auto.auto_wait()
    after = code_bytes_window()
    log("code bytes after all %d (delta +%d)" % (after, after - before))

    # ---- final classification & numerator ----
    def plausible2(ea, bound=0x3000):
        cur = ea
        n = 0
        while cur < ea + bound and cur < WIN_HI:
            insn = ida_ua.insn_t()
            ln = ida_ua.decode_insn(insn, cur)
            if ln <= 0 or ln > 8:
                return False
            n += 1
            if insn.get_canon_feature() & CF_STOP:
                return n >= 2
            cur += ln
        return False

    def has_call_or_jump_ref(ea):
        for xr in idautils.XrefsTo(ea, 0):
            if xr.iscode and xr.type != 21:
                return True
        return False

    def code_bytes_in(f):
        c = 0
        ea = f.start_ea
        while ea < f.end_ea:
            if ida_bytes.is_code(ida_bytes.get_flags(ea)):
                c += 1
            ea += 1
        return c

    n_xref = n_body = n_reject = 0
    ib_xref = ib_body = ib_reject = 0
    body_prol = 0
    rows = []
    for s in idautils.Functions(WIN_LO, WIN_HI):
        f = ida_funcs.get_func(s)
        if not f:
            continue
        cb = code_bytes_in(f)
        xref = has_call_or_jump_ref(s)
        dr = in_data_region(s)
        prol = is_prologue(s)
        pl = plausible2(s)
        fb = (ida_bytes.get_bytes(s, min(8, f.end_ea - s)) or b"").hex()
        if dr is not None:
            cls = "rejected"; n_reject += 1; ib_reject += cb
            ev = "in-data-region:%s" % dr
        elif xref:
            cls = "xref"; n_xref += 1; ib_xref += cb
            ev = "start %08X %s" % (s, fb)
        elif pl and prol:
            cls = "body"; n_body += 1; ib_body += cb; body_prol += 1
            ev = "start %08X %s prologue+stop" % (s, fb)
        else:
            cls = "rejected"; n_reject += 1; ib_reject += cb
            ev = "start %08X %s prol=%d plausible=%d" % (s, fb, int(prol), int(pl))
        rows.append((s, f.end_ea, cls, "yes" if xref else "no", ev, cb))

    numerator = ib_xref + ib_body
    log("FINAL xref %d(%d) body %d(%d) reject %d(%d) numerator %d" % (
        n_xref, ib_xref, n_body, ib_body, n_reject, ib_reject, numerator))

    # denominator
    total_win = WIN_HI - WIN_LO
    proved_data = sum(hi - lo for lo, hi, _ in DATA_REGIONS)
    ff_pad = zero_pad = 0
    for blo, bhi in BANDS:
        ea = blo
        while ea < bhi:
            if not ida_bytes.is_code(ida_bytes.get_flags(ea)):
                b = gb(ea)
                if b == 0xFF: ff_pad += 1
                elif b == 0x00: zero_pad += 1
            ea += 1
    denom = total_win - proved_data - ff_pad - zero_pad

    with open(os.path.join(OUT, "functions.tsv"), "w", encoding="utf-8", newline="\n") as h:
        h.write("start\tend\tvalidated\txref\tpurpose\tevidence\n")
        for s, e, cls, x, ev, cb in sorted(rows):
            h.write("%08X\t%08X\t%s\t%s\t%s\t%s\n" % (s, e, cls, x, "", ev))

    with open(os.path.join(OUT, "coverage.txt"), "w", encoding="utf-8", newline="\n") as h:
        h.write("Lane 4 SUB code window -- coverage after dark-code recovery\n")
        h.write("database SUB_WINDOW; window %08X-%08X = %d bytes\n\n" % (WIN_LO, WIN_HI, total_win))
        h.write("code bytes in window: before %d  after %d  (+%d recovered)\n\n" % (
            before, after, after - before))
        h.write("== function classification (start in window; code-bytes) ==\n")
        h.write("reached-by-xref     %d funcs   %d code bytes\n" % (n_xref, ib_xref))
        h.write("validated-by-body   %d funcs   %d code bytes  (%d w/ stack prologue)\n" % (
            n_body, ib_body, body_prol))
        h.write("rejected            %d funcs   %d code bytes\n" % (n_reject, ib_reject))
        h.write("VALIDATED TOTAL     %d funcs   %d code bytes  <-- numerator\n" % (
            n_xref + n_body, numerator))
        h.write("baseline was 154162 instruction bytes; delta %+d\n\n" % (numerator - 154162))
        h.write("== instruction-byte denominator ==\n")
        h.write("window total                    %d\n" % total_win)
        for lo, hi, lbl in DATA_REGIONS:
            h.write("  -data %08X-%08X %7d  %s\n" % (lo, hi, hi - lo, lbl))
        h.write("proved data total               %d\n" % proved_data)
        h.write("erased 0xFF pad (code band)     %d\n" % ff_pad)
        h.write("zero-fill pad (code band)       %d\n" % zero_pad)
        h.write("instruction-byte denominator    %d\n" % denom)
        h.write("  numerator/denominator = %d/%d = %.1f%%\n" % (
            numerator, denom, 100.0 * numerator / denom))
        h.write("  code-bytes/denominator= %d/%d = %.1f%%\n" % (
            after, denom, 100.0 * after / denom))
        h.write("  numerator/full-window = %d/%d = %.1f%%\n" % (
            numerator, total_win, 100.0 * numerator / total_win))
    log("done")


if True:
    os.makedirs(OUT, exist_ok=True)
    with open(STATUS, "w", encoding="utf-8", newline="\n") as _h:
        _h.write("start\n")
    try:
        main()
    except Exception:
        with open(os.path.join(OUT, "l4_recover_tb.txt"), "w", encoding="utf-8", newline="\n") as _h:
            _h.write(traceback.format_exc())
        log("EXCEPTION")
    import idc as _idc
    _idc.qexit(0)
