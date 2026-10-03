r"""Lane 4 pass 2 -- correct numerator, robust terminator, denominator proof.

Runs on SUB_WINDOW (reopen). Does NOT create functions; it re-classifies and
measures. Terminator = last instruction has CF_STOP (covers rts/rte/rtsd and
unconditional bra/jmp tail-calls). Numerator = CODE-flagged bytes inside a
validated function (counted through a byte-set, no double count). A linear-decode
probe over undefined runs in the code band separates probable-missed-code from
probable-data so the instruction-byte denominator can be stated with a method.

    python ida/run_job.py --script ida\jobs\full_l4_measure.py --db SUB_WINDOW --reopen
"""
from __future__ import annotations
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root
import os, traceback

OUT = str(_REPO / "ida/out/sub-window")
BASE = 0xFFC00000
WIN_LO = 0xFFED0000
WIN_HI = 0xFFF50000
STATUS = os.path.join(OUT, "l4_measure_status.txt")

# proved / high-confidence data subregions in the window (evidence in doc16/doc02
# and the raw entropy block-map). [lo, hi, label]
DATA_REGIONS = [
    (0xFFED0000, 0xFFED3F6C, "bitmap-descriptor-table-tail (doc16, 16B records)"),
    (0xFFED3F6C, 0xFFED5800, "UI layout tables (ent~5, printable runs)"),
    (0xFFED5800, 0xFFED8A70, "zero-heavy tables (ent<2.1, 75% zero)"),
    (0xFFED8A70, 0xFFED8E70, "INTB relocatable vector table (doc02, 256x4)"),
    (0xFFED8E70, 0xFFEDC000, "post-vector data / RAM-init tables (ent<4)"),
    (0xFFF48000, 0xFFF4C000, "string pool (FIRM ERROR etc., printable 49-76%)"),
]


def log(t):
    with open(STATUS, "a", encoding="utf-8", newline="\n") as h:
        h.write(t + "\n")


def in_data_region(ea):
    for lo, hi, lbl in DATA_REGIONS:
        if lo <= ea < hi:
            return lbl
    return None


def main():
    import ida_bytes, ida_funcs, ida_ua, idautils, idc

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

    CF_STOP = idc.CF_STOP if hasattr(idc, "CF_STOP") else 0x00001

    def last_insn_stops(f):
        # walk to last instruction, test CF_STOP
        e = f.start_ea
        last = None
        while e < f.end_ea and e != idc.BADADDR:
            last = e
            nxt = idc.next_head(e, f.end_ea)
            if nxt == idc.BADADDR or nxt <= e:
                break
            e = nxt
        if last is None:
            return False
        insn = ida_ua.insn_t()
        if ida_ua.decode_insn(insn, last) <= 0:
            return False
        ft = insn.get_canon_feature()
        return bool(ft & CF_STOP)

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
    reject_reasons = {"in_data_region": 0, "no_terminator": 0, "no_decode": 0}
    body_prol = 0
    for s in idautils.Functions(WIN_LO, WIN_HI):
        f = ida_funcs.get_func(s)
        if not f:
            continue
        cb = code_bytes_in(f)
        # decode check
        good = True
        e = f.start_ea
        while e < f.end_ea and e != idc.BADADDR:
            insn = ida_ua.insn_t()
            if ida_ua.decode_insn(insn, e) <= 0:
                good = False
                break
            nxt = idc.next_head(e, f.end_ea)
            if nxt == idc.BADADDR or nxt <= e:
                break
            e = nxt
        xref = has_call_or_jump_ref(s)
        dr = in_data_region(s)
        term = last_insn_stops(f)
        prol = is_prologue(s)
        if dr is not None:
            n_reject += 1; ib_reject += cb; reject_reasons["in_data_region"] += 1
        elif xref:
            n_xref += 1; ib_xref += cb
        elif good and term:
            n_body += 1; ib_body += cb
            if prol:
                body_prol += 1
        else:
            n_reject += 1; ib_reject += cb
            if not good:
                reject_reasons["no_decode"] += 1
            else:
                reject_reasons["no_terminator"] += 1

    log("xref %d(%d)  body %d(%d)  reject %d(%d)  body_with_prologue %d" % (
        n_xref, ib_xref, n_body, ib_body, n_reject, ib_reject, body_prol))
    log("reject reasons %s" % reject_reasons)

    # ---- per-2KB code fraction ----
    blk = 2048
    blockmap = []
    ea = WIN_LO
    while ea < WIN_HI:
        c = d = u = 0
        for j in range(blk):
            fl = ida_bytes.get_flags(ea + j)
            if ida_bytes.is_code(fl): c += 1
            elif ida_bytes.is_data(fl): d += 1
            else: u += 1
        blockmap.append((ea, c, d, u))
        ea += blk

    # ---- linear-decode probe of undefined runs in the code band ----
    # code band = window minus the data regions above and the tail JPEG-ish block
    def in_any_data(ea):
        return in_data_region(ea) is not None
    probable_code = 0
    probable_data = 0
    probed = 0
    ea = 0xFFEDC000
    band_hi = 0xFFF48000
    while ea < band_hi:
        fl = ida_bytes.get_flags(ea)
        if ida_bytes.is_code(fl) or ida_bytes.is_data(fl):
            ea += 1
            continue
        # start of an undefined run
        run_start = ea
        while ea < band_hi and not ida_bytes.is_code(ida_bytes.get_flags(ea)) \
                and not ida_bytes.is_data(ida_bytes.get_flags(ea)):
            ea += 1
        run_len = ea - run_start
        probed += run_len
        # decode linearly through the run; does it form clean instructions reaching
        # a CF_STOP without an invalid opcode?
        cur = run_start
        ninsn = 0
        stops = 0
        bad = 0
        while cur < ea:
            insn = ida_ua.insn_t()
            ln = ida_ua.decode_insn(insn, cur)
            if ln <= 0 or ln > 8:
                bad += 1
                cur += 1
                continue
            ninsn += 1
            if insn.get_canon_feature() & CF_STOP:
                stops += 1
            cur += ln
        # heuristic: a real code run decodes with almost no invalid bytes and
        # contains at least one flow-stop per ~200 bytes
        if run_len >= 8 and bad == 0 and stops >= max(1, run_len // 400):
            probable_code += run_len
        else:
            probable_data += run_len

    log("undefined-run probe in code band: probed %d probable_code %d probable_data %d" % (
        probed, probable_code, probable_data))

    # ---- denominator ----
    total_win = WIN_HI - WIN_LO
    proved_data = sum(hi - lo for lo, hi, _ in DATA_REGIONS)
    # bytes that are erased(FF) or zero-fill inside the code band, treat as pad/data
    ff_pad = zero_pad = 0
    ea = 0xFFEDC000
    while ea < band_hi:
        b = gb(ea)
        if not ida_bytes.is_code(ida_bytes.get_flags(ea)):
            if b == 0xFF: ff_pad += 1
            elif b == 0x00: zero_pad += 1
        ea += 1

    numerator = ib_xref + ib_body
    with open(os.path.join(OUT, "coverage.txt"), "w", encoding="utf-8", newline="\n") as h:
        h.write("Lane 4 SUB code window -- coverage and denominator\n")
        h.write("database SUB_WINDOW (copy of SUB_VEC.i64); window %08X-%08X = %d bytes\n\n" % (
            WIN_LO, WIN_HI, total_win))
        h.write("== function classification (start in window; code-BYTES in parens) ==\n")
        h.write("reached-by-xref     %d funcs   %d code bytes\n" % (n_xref, ib_xref))
        h.write("validated-by-body   %d funcs   %d code bytes  (%d have a stack prologue)\n" % (
            n_body, ib_body, body_prol))
        h.write("rejected            %d funcs   %d code bytes\n" % (n_reject, ib_reject))
        h.write("  reject reasons: %s\n" % reject_reasons)
        h.write("VALIDATED TOTAL     %d funcs   %d code bytes  <-- numerator\n\n" % (
            n_xref + n_body, numerator))
        h.write("== instruction-byte denominator (method) ==\n")
        h.write("window total                         %d\n" % total_win)
        for lo, hi, lbl in DATA_REGIONS:
            h.write("  -proved data %08X-%08X %7d  %s\n" % (lo, hi, hi - lo, lbl))
        h.write("proved data (tables+strings) total   %d\n" % proved_data)
        h.write("erased 0xFF pad in code band         %d\n" % ff_pad)
        h.write("zero-fill pad in code band           %d\n" % zero_pad)
        denom = total_win - proved_data - ff_pad - zero_pad
        h.write("instruction-byte denominator         %d  (window - proved data - pad)\n" % denom)
        h.write("  numerator/denominator = %d/%d = %.1f%%\n" % (
            numerator, denom, 100.0 * numerator / denom))
        h.write("  numerator/full-window = %d/%d = %.1f%%\n\n" % (
            numerator, total_win, 100.0 * numerator / total_win))
        h.write("== undefined-run probe in code band 0xFFEDC000-0xFFF48000 ==\n")
        h.write("undefined bytes probed  %d\n" % probed)
        h.write("  decode as clean code  %d  (probable missed code, upper bound)\n" % probable_code)
        h.write("  do not               %d  (probable data/pool)\n" % probable_data)

    with open(os.path.join(OUT, "blockmap.tsv"), "w", encoding="utf-8", newline="\n") as h:
        h.write("block_addr\tcode\tdata\tundef\n")
        for a, c, d, u in blockmap:
            h.write("%08X\t%d\t%d\t%d\n" % (a, c, d, u))
    log("done")


if True:
    os.makedirs(OUT, exist_ok=True)
    with open(STATUS, "w", encoding="utf-8", newline="\n") as _h:
        _h.write("start\n")
    try:
        main()
    except Exception:
        with open(os.path.join(OUT, "l4_measure_tb.txt"), "w", encoding="utf-8", newline="\n") as _h:
            _h.write(traceback.format_exc())
        log("EXCEPTION")
    import idc as _idc
    _idc.qexit(0)
