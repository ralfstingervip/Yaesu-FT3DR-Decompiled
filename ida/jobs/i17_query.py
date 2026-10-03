r"""Lane I17 -- read-only query of the SUB_FINAL2 DB.  Collects the evidence the I17 plan needs:
  refs.tsv   every operand of every code head in FFC00000..FFF50A00 whose value (o_imm/o_mem/o_displ
             value or addr) lies in the data ranges below, with the owning function and disassembly
  drefs.tsv  every data xref whose target lies in the data ranges below
  funcs.tsv  every function: start, end, chunks (with tail owner counts), entry xrefs by type,
             prev head before the entry (ea, size, is_stop, owner function, owner chunk end)
Ranges: FFECE4E4..FFED8E70 (below-window block + published low tables) and FFF48000..FFF4B059 (pool).
    python ida/run_job.py --script ida\jobs\i17_query.py --db SUB_FINAL2 --reopen
Output: ida\out\sub-final2\raw\query_<tag>\   (tag from env I17_TAG, default 'seed')
"""
from __future__ import annotations
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root
import os, traceback

ROOT = str(_REPO)
TAG = os.environ.get("I17_TAG", "seed")
OUT = os.path.join(ROOT, r"ida\out\sub-final2\raw", "query_" + TAG)
RANGES = [(0xFFECE4E4, 0xFFED8E70), (0xFFF48000, 0xFFF4B059)]
LO, HI = 0xFFED0000, 0xFFF50A00
CF_STOP = 0x1


def inr(v):
    return any(a <= v < b for a, b in RANGES)


def log(t):
    with open(os.path.join(OUT, "status.txt"), "a", encoding="utf-8", newline="\n") as h:
        h.write(t + "\n")


def main():
    import ida_auto, ida_bytes, ida_ua, ida_funcs, ida_xref, idautils, idc, ida_name, ida_lines
    os.makedirs(OUT, exist_ok=True)
    ida_auto.auto_wait()
    nref = 0
    with open(os.path.join(OUT, "refs.tsv"), "w", encoding="utf-8", newline="\n") as h:
        h.write("insn\tfunc\top\toptype\tvalue\tbytes\tdisasm\n")
        ea = 0xFFC00000
        while ea < HI:
            fl = ida_bytes.get_flags(ea)
            if ida_bytes.is_code(fl):
                insn = ida_ua.insn_t(); ln = ida_ua.decode_insn(insn, ea)
                if ln > 0:
                    for n, op in enumerate(insn.ops):
                        if op.type == 0:
                            break
                        for v in set([op.value & 0xFFFFFFFF, op.addr & 0xFFFFFFFF]):
                            if inr(v):
                                f = ida_funcs.get_func(ea)
                                dis = ida_lines.tag_remove(idc.generate_disasm_line(ea, 0) or "")
                                h.write("%08X\t%s\t%d\t%d\t%08X\t%s\t%s\n" % (ea, ("%08X" % f.start_ea) if f else "", n, op.type, v,
                                        ida_bytes.get_bytes(ea, ln).hex(), dis))
                                nref += 1
                ea += max(ida_bytes.get_item_size(ea), 1)
            elif ida_bytes.is_data(fl):
                ea += max(ida_bytes.get_item_size(ea), 1)
            else:
                ea = ida_bytes.next_head(ea, HI) if ea < 0xFFED0000 else ea + 1
                if ea == idc.BADADDR:
                    break
    nd = 0
    with open(os.path.join(OUT, "drefs.tsv"), "w", encoding="utf-8", newline="\n") as h:
        h.write("from\tto\ttype\tfrom_is_code\n")
        for a, b in RANGES:
            for t in range(a, b):
                for x in idautils.XrefsTo(t, 0):
                    if not x.iscode:
                        h.write("%08X\t%08X\t%d\t%d\n" % (x.frm, t, x.type, int(ida_bytes.is_code(ida_bytes.get_flags(x.frm)))))
                        nd += 1
    nf = 0
    with open(os.path.join(OUT, "funcs.tsv"), "w", encoding="utf-8", newline="\n") as h:
        h.write("start\tend\tname\tchunks\tcalls\tjumps\tdrefs\tother\tprev\tprev_size\tprev_stop\tprev_func\tprev_chunk_end\tprev_chunk_refqty\tlast_stop\n")
        for s in idautils.Functions():
            f = ida_funcs.get_func(s)
            ch = []
            for a, b in idautils.Chunks(s):
                c = ida_funcs.get_fchunk(a)
                rq = c.refqty if (c and c.start_ea != s) else 0
                ch.append("%08X-%08X/%d" % (a, b, rq))
            calls = []; jumps = []; drefs = []; other = []
            for x in idautils.XrefsTo(s, 0):
                if x.type == 21:
                    continue
                if x.iscode and x.type in (16, 17):
                    calls.append("%08X" % x.frm)
                elif x.iscode and x.type in (18, 19):
                    jumps.append("%08X" % x.frm)
                elif not x.iscode:
                    drefs.append("%08X:%d" % (x.frm, x.type))
                else:
                    other.append("%08X:%d" % (x.frm, x.type))
            p = ida_bytes.prev_head(s, 0)
            ps = pst = pf = pce = prq = ""
            if p != idc.BADADDR:
                pfl = ida_bytes.get_flags(p)
                ps = str(ida_bytes.get_item_size(p))
                if ida_bytes.is_code(pfl):
                    insn = ida_ua.insn_t()
                    pst = "1" if (ida_ua.decode_insn(insn, p) > 0 and insn.get_canon_feature() & CF_STOP) else "0"
                else:
                    pst = "data"
                pfn = ida_funcs.get_func(p)
                if pfn:
                    pf = "%08X" % pfn.start_ea
                    c = ida_funcs.get_fchunk(p)
                    pce = "%08X" % c.end_ea
                    prq = str(c.refqty) if c.start_ea != pfn.start_ea else "0"
            # last instruction of the entry chunk
            l = ida_bytes.prev_head(f.end_ea, s)
            insn = ida_ua.insn_t()
            lst = "1" if (l != idc.BADADDR and ida_ua.decode_insn(insn, l) > 0 and insn.get_canon_feature() & CF_STOP) else "0"
            h.write("%08X\t%08X\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n" % (
                s, f.end_ea, ida_name.get_name(s), ";".join(ch), ",".join(calls), ",".join(jumps), ",".join(drefs),
                ",".join(other), ("%08X" % p) if p != idc.BADADDR else "", ps, pst, pf, pce, prq, lst))
            nf += 1
    log("refs %d drefs %d funcs %d" % (nref, nd, nf))
    log("done")


try:
    main()
except Exception:
    os.makedirs(OUT, exist_ok=True)
    log(traceback.format_exc())
finally:
    import idc
    idc.qexit(0)
