r"""Lane H8 -- SUB code-window gap: reproduce the split and dump every gap run.

    python ida/run_job.py --script ida\jobs\h8_gap_dump.py --db H8_SUBGAP --copy-from ida\db\jobs\FIN_SUB_T2\FIN_SUB_T2.i64
    python ida/run_job.py --script ida\jobs\h8_gap_dump.py --db H8_SUBGAP --reopen

Read-only with respect to the DB contents (no create_insn / add_func here).
"""
from __future__ import annotations
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root
import os, traceback

ROOT = str(_REPO)
OUT = os.path.join(ROOT, r"ida\out\sub-gap")
RAW = os.path.join(OUT, "raw")
STATUS = os.path.join(RAW, "h8_gap_dump_status.txt")
WIN_LO, WIN_HI = 0xFFED0000, 0xFFF50000
PAST_HI = 0xFFF50A00
DATA = [(0xFFED0000, 0xFFED3F6C), (0xFFED3F6C, 0xFFED5800), (0xFFED5800, 0xFFED8A70),
        (0xFFED8A70, 0xFFED8E70), (0xFFF48000, 0xFFF4C000)]
CF_STOP = 0x1


def log(t):
    with open(STATUS, "a", encoding="utf-8", newline="\n") as h:
        h.write(t + "\n")


def main():
    import ida_auto, ida_bytes, ida_funcs, ida_ua, idautils, idc
    ida_auto.auto_wait()
    os.makedirs(RAW, exist_ok=True)

    rows = []
    with open(os.path.join(ROOT, r"ida\out\sub-window\functions.tsv"), encoding="utf-8") as h:
        next(h)
        for ln in h:
            p = ln.rstrip("\n").split("\t")
            rows.append((int(p[0], 16), int(p[1], 16), p[2]))
    rej2 = set()
    for i in range(1, 6):
        with open(os.path.join(ROOT, r"ida\out\wave2\sub-purpose-%d.tsv" % i), encoding="utf-8") as h:
            next(h)
            for ln in h:
                p = ln.rstrip("\n").split("\t")
                if len(p) > 3 and p[3] == "rejected":
                    rej2.add(int(p[0], 16))
    cls_of = {s: c for s, e, c in rows}

    N = WIN_HI - WIN_LO
    mark = bytearray(N)        # 1 = validated-fn instruction byte, 2 = proved data
    tot = 0; tot_rej2 = 0
    for s, e, c in rows:
        if c not in ("xref", "body"):
            continue
        ea = s; n = 0
        while ea < e:
            fl = ida_bytes.get_flags(ea)
            if ida_bytes.is_code(fl):
                sz = ida_bytes.get_item_size(ea)
                for k in range(sz):
                    if WIN_LO <= ea + k < WIN_HI and ea + k < e:
                        if mark[ea + k - WIN_LO] == 0:
                            mark[ea + k - WIN_LO] = 1; n += 1
                ea += max(sz, 1)
            else:
                ea += 1
        tot += n
        if s in rej2:
            tot_rej2 += n
    for lo, hi in DATA:
        for a in range(lo, hi):
            if mark[a - WIN_LO] == 0:
                mark[a - WIN_LO] = 2
    nd = sum(1 for b in mark if b == 2)
    log("validated instr bytes (this DB, functions.tsv ranges, item-size, deduped) %d" % tot)
    log("of which in 68 wave2 rejects %d" % tot_rej2)
    log("proved data %d ; gap %d" % (nd, N - tot - nd))

    # whole-window instruction / data / unk composition of this DB
    ib = db = ub = 0; ea = WIN_LO
    while ea < WIN_HI:
        fl = ida_bytes.get_flags(ea)
        if ida_bytes.is_code(fl):
            sz = ida_bytes.get_item_size(ea); ib += sz; ea += max(sz, 1)
        elif ida_bytes.is_data(fl):
            sz = ida_bytes.get_item_size(ea); db += sz; ea += max(sz, 1)
        else:
            if not ida_bytes.is_tail(fl):
                ub += 1
            ea += 1
    log("window composition this DB: instr %d data %d unk %d" % (ib, db, ub))

    # gap runs
    runs = []; a = 0
    while a < N:
        if mark[a] == 0:
            b = a
            while b < N and mark[b] == 0:
                b += 1
            runs.append((WIN_LO + a, WIN_LO + b)); a = b
        else:
            a += 1
    log("gap runs %d" % len(runs))

    def comp(lo, hi):
        """instr bytes / data bytes / unk bytes of IDA items intersecting [lo,hi)"""
        ci = cd = cu = 0; heads = []
        ea = lo
        h0 = ida_bytes.get_item_head(lo)
        if h0 != idc.BADADDR and h0 < lo:
            ea = h0
        while ea < hi:
            fl = ida_bytes.get_flags(ea)
            if ida_bytes.is_code(fl) or ida_bytes.is_data(fl):
                sz = max(ida_bytes.get_item_size(ea), 1)
                ov = min(ea + sz, hi) - max(ea, lo)
                if ov > 0:
                    if ida_bytes.is_code(fl):
                        ci += ov
                        if ea >= lo: heads.append(ea)
                    else:
                        cd += ov
                ea += sz
            else:
                if ea >= lo: cu += 1
                ea += 1
        return ci, cd, cu, heads

    def probe(ea, lim):
        """linear decode from ea; return (n_insn, end_ea, stop_kind)"""
        cur = ea; n = 0
        while cur < lim + 64:
            insn = ida_ua.insn_t(); ln = ida_ua.decode_insn(insn, cur)
            if ln <= 0:
                return n, cur, "invalid"
            n += 1
            if insn.get_canon_feature() & CF_STOP:
                return n, cur + ln, "stop:" + idc.print_insn_mnem(cur)
            cur += ln
        return n, cur, "nostop"

    with open(os.path.join(RAW, "gap_raw.tsv"), "w", encoding="utf-8", newline="\n") as h:
        h.write("start\tend\tlen\tinstr\tdata\tunk\tfunc\tfunc_end\tfunc_cls\tcode_xr_in\tdata_xr_in\tprobe_n\tprobe_end\tprobe_stop\tfirst_heads\tbytes32\n")
        for lo, hi in runs:
            ci, cd, cu, heads = comp(lo, hi)
            f = ida_funcs.get_func(lo)
            fs = "%08X" % f.start_ea if f else ""
            fe = "%08X" % f.end_ea if f else ""
            fc = cls_of.get(f.start_ea, "notlisted") if f else ""
            if f and f.start_ea in rej2:
                fc += "+w2rej"
            cx = []; dx = []
            for t in range(lo, hi):
                for xr in idautils.XrefsTo(t, 0):
                    if xr.iscode and xr.type != 21:
                        cx.append("%08X>%08X:%d" % (xr.frm, t, xr.type))
                    elif not xr.iscode:
                        dx.append("%08X>%08X" % (xr.frm, t))
            pn, pe, ps = probe(lo, hi)
            bb = (ida_bytes.get_bytes(lo, min(32, hi - lo)) or b"").hex()
            h.write("%08X\t%08X\t%d\t%d\t%d\t%d\t%s\t%s\t%s\t%s\t%s\t%d\t%08X\t%s\t%s\t%s\n" % (
                lo, hi, hi - lo, ci, cd, cu, fs, fe, fc, ";".join(cx[:12]), ";".join(dx[:12]),
                pn, pe, ps, ",".join("%08X" % x for x in heads[:6]), bb))

    # all functions in DB in window+past window
    with open(os.path.join(RAW, "db_funcs.tsv"), "w", encoding="utf-8", newline="\n") as h:
        h.write("start\tend\tcls\tnchunks\n")
        for s in idautils.Functions(WIN_LO, PAST_HI):
            f = ida_funcs.get_func(s)
            nch = len(list(idautils.Chunks(s)))
            h.write("%08X\t%08X\t%s\t%d\n" % (s, f.end_ea, cls_of.get(s, "notlisted"), nch))

    # past-window region item dump
    with open(os.path.join(RAW, "past_items.tsv"), "w", encoding="utf-8", newline="\n") as h:
        ea = WIN_HI
        while ea < PAST_HI:
            fl = ida_bytes.get_flags(ea)
            sz = max(ida_bytes.get_item_size(ea), 1)
            k = "code" if ida_bytes.is_code(fl) else ("data" if ida_bytes.is_data(fl) else "unk")
            if k == "unk":
                sz = 1
            xr = ";".join("%08X:%d" % (x.frm, x.type) for x in idautils.XrefsTo(ea, 0))
            f = ida_funcs.get_func(ea)
            h.write("%08X\t%d\t%s\t%s\t%s\t%s\n" % (ea, sz, k, ("%08X" % f.start_ea) if f else "",
                                                 idc.generate_disasm_line(ea, 0) if k != "unk" else "%02X" % ida_bytes.get_byte(ea), xr))
            ea += sz
    log("done")


try:
    main()
except Exception:
    with open(STATUS, "a", encoding="utf-8", newline="\n") as h:
        h.write(traceback.format_exc())
finally:
    import idc
    idc.qexit(0)
